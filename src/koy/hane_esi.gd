## ACL-02: Eş — oynanabilir ama sıradan köylü değil (meslek kısıtı, 1 gün verimsizlik, arabuluculuk, ağır yas).
class_name HaneEsi
extends RefCounted

const META := &"hane_esi_durum"
const UYARI_META := &"hane_esi_uyari"
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/hane_esi.json"))

static func es_mi(k: Variant) -> bool:
	return k is Koylu and k.bayrak_var(String(AYAR.bayrak))

static func es_bul(y: KoyYonetimi) -> Koylu:
	if y == null: return null
	for k in y.koylular:
		if es_mi(k): return k
	return null

static func _yonetim_al(o_or_y: Variant) -> KoyYonetimi:
	if o_or_y is KoyYonetimi: return o_or_y
	if o_or_y != null and o_or_y.get("yonetim") is KoyYonetimi: return o_or_y.get("yonetim")
	return null

## ACL-06 / medrese geçmişi veya okuryazar özelliği varsa kâtiplik açılır.
static func okuryazar_mi(o_or_y: Variant = null, k: Koylu = null) -> bool:
	var gecmisler: Array = AYAR.okuryazar_meslegi.get("gecmisler", [])
	if o_or_y != null and o_or_y.get("kadro") != null:
		if preload("res://src/sistemler/muhafiz_gecmisi.gd").kimlik(o_or_y) in gecmisler:
			return true
	var y := _yonetim_al(o_or_y)
	if y != null:
		if bool(y.get_meta(&"okuryazar", false)): return true
		if String(y.get_meta(&"muhafiz_gecmisi", "")) in gecmisler: return true
	var hedef := k if k != null else es_bul(y)
	return hedef != null and "okuryazar" in hedef.pasif_ozellikler

static func meslekler(o_or_y: Variant = null, k: Koylu = null) -> Array[Dictionary]:
	var liste: Array[Dictionary] = []
	for m in AYAR.meslekler:
		if m is Dictionary: liste.append((m as Dictionary).duplicate(true))
	if okuryazar_mi(o_or_y, k):
		var km: Dictionary = AYAR.okuryazar_meslegi
		liste.append({"id": String(km.id), "ad": String(km.ad), "cikti": String(km.cikti), "miktar": int(km.miktar)})
	return liste

static func meslek_gecerli_mi(meslek: Variant, o_or_y: Variant = null, k: Koylu = null) -> bool:
	if not (meslek is String or meslek is StringName): return false
	var id := String(meslek).strip_edges().to_lower()
	if id.is_empty() or id in AYAR.yasak_meslekler: return false
	for m in meslekler(o_or_y, k):
		if String(m.id) == id: return true
	return false

static func oku(v: Variant, o_or_y: Variant = null, k: Koylu = null) -> Dictionary:
	var y := _yonetim_al(o_or_y)
	var varsayilan := String(AYAR.varsayilan_meslek)
	if y != null and y.hane != null and meslek_gecerli_mi(y.hane.es_meslegi, o_or_y, k):
		varsayilan = String(y.hane.es_meslegi).to_lower()
	var d := {"meslek": varsayilan, "degisim_gunu": -1, "verimsiz_kalan": 0, "son_arabuluculuk_gun": -1, "arabuluculuk_sayisi": 0, "tanindi": k != null}
	if not v is Dictionary: return d
	var m := String(v.get("meslek", "")).strip_edges().to_lower()
	if meslek_gecerli_mi(m, o_or_y, k):
		d.meslek = m
	d.degisim_gunu = KurtBaskini.oku(v.get("degisim_gunu", -1))
	d.son_arabuluculuk_gun = KurtBaskini.oku(v.get("son_arabuluculuk_gun", -1))
	if bool(v.get("tanindi", false)) or k != null:
		d.tanindi = true
	var vk: Variant = v.get("verimsiz_kalan", 0)
	if (vk is int or vk is float) and is_finite(float(vk)) and floor(float(vk)) == float(vk):
		d.verimsiz_kalan = clampi(int(vk), 0, int(AYAR.verimsiz_gun))
	var ars: Variant = v.get("arabuluculuk_sayisi", 0)
	if (ars is int or ars is float) and is_finite(float(ars)) and floor(float(ars)) == float(ars):
		d.arabuluculuk_sayisi = clampi(int(ars), 0, 1000000)
	return d

static func durum(y: KoyYonetimi, o: Variant = null) -> Dictionary:
	if y == null: return oku(null)
	var es := es_bul(y)
	var baglam: Variant = o if o != null else y
	var d := oku(y.get_meta(META, {}), baglam, es)
	# Debug veya bozuk kayıttan yasak meslek yazılmışsa geri çevir.
	if es != null:
		var es_sinif := String(es.sinif).strip_edges().to_lower()
		if es_sinif != "" and es_sinif != "ciftci" and not meslek_gecerli_mi(es_sinif, baglam, es):
			es.sinif = StringName(d.meslek)
	return d

static func kaydet(y: KoyYonetimi) -> Dictionary:
	return durum(y)

static func yukle(y: KoyYonetimi, v: Variant, o: Variant = null) -> void:
	if y == null: return
	var es := es_bul(y)
	var d := oku(v, o if o != null else y, es)
	y.set_meta(META, d)
	if y.hane != null:
		y.hane.es_meslegi = String(d.meslek)
	if es != null and String(es.sinif) in AYAR.yasak_meslekler:
		es.sinif = StringName(d.meslek)

## Meslek seçimi: yalnız data/hane_esi.json listesi + okuryazar kâtip. Değişince 1 gün verimsiz (birikmez).
static func meslek_sec(y: KoyYonetimi, yeni_meslek: String, o: Variant = null) -> Dictionary:
	if y == null or y.son != "": return {"ok": false, "hata": "oturum_kapali"}
	var es := es_bul(y)
	if es == null or es.saglik <= 0: return {"ok": false, "hata": "es_yok"}
	var baglam: Variant = o if o != null else y
	var temiz := yeni_meslek.strip_edges().to_lower()
	if not meslek_gecerli_mi(temiz, baglam, es):
		return {"ok": false, "hata": "gecersiz_meslek"}
	var d := durum(y, baglam)
	if String(d.meslek) == temiz:
		return {"ok": true, "degisti": false, "meslek": temiz, "verimsiz_kalan": int(d.verimsiz_kalan)}
	d.meslek = temiz
	d.degisim_gunu = y.gun
	d.tanindi = true
	# Üst üste meslek değişiminde verimsiz süre 1 günde kalır, 2 olmaz.
	d.verimsiz_kalan = int(AYAR.verimsiz_gun)
	y.set_meta(META, d)
	if y.hane != null: y.hane.es_meslegi = temiz
	es.sinif = StringName(temiz)
	return {"ok": true, "degisti": true, "meslek": temiz, "verimsiz_kalan": int(d.verimsiz_kalan)}

static func verim_carpani(y: KoyYonetimi) -> float:
	if y == null: return 1.0
	return 0.5 if int(durum(y).verimsiz_kalan) > 0 else 1.0

static func cikti_al(y: KoyYonetimi) -> Dictionary:
	if y == null: return {}
	var es := es_bul(y)
	if es == null or es.saglik <= 0 or (y.hane != null and not y.hane.es_hayatta): return {}
	var d := durum(y)
	var m_id := String(d.meslek)
	var cikti_adi := "gida"
	var temel := 1
	for m in meslekler(y, es):
		if String(m.id) == m_id:
			cikti_adi = String(m.cikti)
			temel = int(m.miktar)
			break
	var carpan := verim_carpani(y)
	return {"meslek": m_id, "cikti": cikti_adi, "miktar": int(floor(float(temel) * carpan)), "carpan": carpan}

## Arabuluculuk her meslekte açıktır; doğrudan mevcut köylü moraline yazılır (kalp alanı yok).
static func arabuluculuk_yap(y: KoyYonetimi, hedef_id: int = -1) -> Dictionary:
	if y == null or y.son != "": return {"ok": false}
	var es := es_bul(y)
	if es == null or es.saglik <= 0: return {"ok": false}
	var d := durum(y)
	if int(d.son_arabuluculuk_gun) >= y.gun: return {"ok": false, "neden": "bugun_yapildi"}
	var hedef := y.koylu(hedef_id) if hedef_id >= 0 else null
	if hedef == null:
		for k in y.koylular:
			if k.saglik > 0 and not es_mi(k) and (hedef == null or k.moral < hedef.moral):
				hedef = k
	if hedef == null: hedef = es
	var artis := int(AYAR.arabuluculuk_moral)
	hedef.moral = clampi(hedef.moral + artis, 0, 100)
	if hedef != es:
		es.moral = clampi(es.moral + 1, 0, 100)
	if y.hane != null: y.hane.es_moral = es.moral
	d.son_arabuluculuk_gun = y.gun
	d.arabuluculuk_sayisi = int(d.arabuluculuk_sayisi) + 1
	y.set_meta(META, d)
	return {"ok": true, "hedef_id": hedef.id, "moral_farki": artis, "meslek": String(d.meslek)}

## Kışla, muhafız, kervan, sürgün ve divan eylemleri eşte kapalıdır.
static func izinli_mi(k: Variant, eylem: String) -> bool:
	return not (es_mi(k) and eylem in AYAR.kapali_eylemler)

static func surgun_uyarisi(y: KoyYonetimi, k: Variant) -> String:
	if not es_mi(k): return ""
	var u := String(AYAR.uyari_surgun)
	if y != null: y.set_meta(UYARI_META, u)
	return u

static func agir_yas_var_mi(o_or_y: Variant) -> bool:
	var y := _yonetim_al(o_or_y)
	return y != null and y.hane != null and (not y.hane.es_hayatta or y.hane.yas_donemi)

static func agir_yas_satiri(o_or_y: Variant) -> String:
	return String(AYAR.agir_yas_epilog) if agir_yas_var_mi(o_or_y) else ""

## Gece döngüsü: verimsizlik gününü ilerletir ve eş ölümünde yeni son yerine ağır yas açar.
static func gece(y: KoyYonetimi, olaylar: Array[Dictionary]) -> void:
	if y == null: return
	var d := durum(y)
	var es := es_bul(y)
	if es == null or es.saglik <= 0:
		if bool(d.tanindi) and y.hane != null and (y.hane.es_hayatta or not y.hane.yas_donemi):
			y.hane.es_olumu()
			olaylar.append({"anahtar": String(AYAR.agir_yas_epilog), "deger": []})
		return
	if not bool(d.tanindi):
		d.tanindi = true
	if y.hane != null:
		y.hane.es_hayatta = true
		y.hane.es_moral = es.moral
		y.hane.es_meslegi = String(d.meslek)
	if int(d.verimsiz_kalan) > 0:
		d.verimsiz_kalan = maxi(0, int(d.verimsiz_kalan) - 1)
	y.set_meta(META, d)

static func gelen_es_mi(g: Variant, o: Variant) -> bool:
	if g == null or o == null: return false
	var id := String(g.get("id"))
	var acik: Array = g.get("acik_bayraklar") if g.get("acik_bayraklar") is Array else []
	if String(AYAR.bayrak) in acik or id == "acl01_es" or id == "es": return true
	var y := _yonetim_al(o)
	var es := es_bul(y)
	return es != null and es.adli_id != &"" and id == String(es.adli_id)
