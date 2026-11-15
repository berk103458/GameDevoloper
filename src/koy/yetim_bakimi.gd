## KAP-18: savaş olayı sonrası gelen yetim kafilesi; mevcut KAP-17 aile şeması,
## Hane/BarinakUyarisi ve YasRolleri üzerinden çalışır.
class_name YetimBakimi
extends RefCounted

const META := &"kap18_yetim_bakimi"
const KAYNAK := "res://data/soz/yetim_kafilesi.json"
const Aile := preload("res://src/kapi/aile_kafilesi.gd")
const Barinak := preload("res://src/kapi/barinak_uyarisi.gd")
const YETIM_BAYRAK := "kap18_yetim"
const ES_BAYRAK := "kap18_yetim_es"
const ACIKTA_BAYRAK := "kap18_yetim_acikta"
const GENCE_GECIS_GUNU := 28
const SAVAS_ISARETLERI := ["mogol_ilerleyisi.etki"]

static var _katalog_onbellek: Dictionary = {}


static func _katalog() -> Dictionary:
	if _katalog_onbellek.is_empty():
		var f := FileAccess.open(KAYNAK, FileAccess.READ)
		if f != null:
			var veri: Variant = JSON.parse_string(f.get_as_text())
			if veri is Dictionary:
				_katalog_onbellek = veri
	return _katalog_onbellek


static func savas_olayi_var_mi(o: Oturum) -> bool:
	if o == null: return false
	for isaret in SAVAS_ISARETLERI:
		if DunyaZamani.isaret_var_mi(o, isaret):
			return true
	return o.bayraklar.has(&"mogol_ilerleyisi_etki") or o.bayraklar.has(&"kap18_savas_olayi")


static func durum(o: Oturum) -> Dictionary:
	if o == null: return {"sonuc": "", "gun": -1, "acikta": 0}
	return o.get_meta(META, {"sonuc": "", "gun": -1, "acikta": 0}).duplicate(true)


static func yukle(o: Oturum, v: Variant) -> void:
	var d := {"sonuc": "", "gun": -1, "acikta": 0}
	if v is Dictionary:
		var s: Variant = v.get("sonuc", "")
		if s is String and s in ["", "kabul", "ret"]:
			d["sonuc"] = s
		var g: Variant = v.get("gun", -1)
		if (g is int or g is float) and is_finite(float(g)):
			d["gun"] = maxi(-1, int(g))
		var a: Variant = v.get("acikta", 0)
		if (a is int or a is float) and is_finite(float(a)):
			d["acikta"] = maxi(0, int(a))
	if String(d.sonuc).is_empty() and o != null and o.yonetim != null:
		for k in o.yonetim.koylular:
			if k.bayrak_var(YETIM_BAYRAK):
				d["sonuc"] = "kabul"
				break
	if o != null:
		o.set_meta(META, d)


static func ilgilenir(g: Gelen) -> bool:
	return g != null and g.aile_id.begins_with("kap18_yetim") and not g.aile.is_empty()


static func ekle(o: Oturum, kuyruk: Array[Gelen]) -> void:
	if o == null: return
	var d := durum(o)
	if not String(d.get("sonuc", "")).is_empty(): return
	for mevcut in kuyruk:
		if ilgilenir(mevcut): return
	if not savas_olayi_var_mi(o): return
	var kat := _katalog()
	var uyeler := Aile.uyeleri_oku(kat.get("kafile_uyeleri", []))
	if uyeler.is_empty(): return
	var g := Gelen.new()
	g.id = &"kap18_yetim_kafilesi"
	g.adli = false
	g.ad_anahtari = "kap18.yetim.kafile_baslik"
	g.sinif = &"ciftci"
	g.portre = String(uyeler[0].get("portre", "peasant_01"))
	g.stat = int(uyeler[0].get("stat", 3))
	g.aile_id = "kap18_yetim_%d" % o.gun
	g.aile = uyeler
	var dugumler: Dictionary = kat.get("dugumler", {}) if kat.get("dugumler") is Dictionary else {}
	var acilis_metin := TranslationServer.translate("kap18.yetim.kafile_acilis")
	g.giris_anahtari = acilis_metin
	g.acilis = String(dugumler.get("giris", {}).get("satir", acilis_metin))
	g.secenekler = PackedStringArray(["kabul", "ret"])
	g.etkiler = {"kabul": {}, "ret": {}}
	var sorular: Array[PackedStringArray] = []
	var ust: PackedInt32Array = PackedInt32Array()
	var bayraklar: PackedStringArray = PackedStringArray()
	var giris_secenekler: Array = dugumler.get("giris", {}).get("secenekler", [])
	if giris_secenekler is Array:
		for s in giris_secenekler:
			if not s is Dictionary: continue
			var hedef_id := String(s.get("hedef", ""))
			var hedef_d: Dictionary = dugumler.get(hedef_id, {}) if dugumler.get(hedef_id) is Dictionary else {}
			var yanit := String(hedef_d.get("satir", ""))
			var soru := String(s.get("metin", ""))
			if not soru.is_empty() and not yanit.is_empty():
				sorular.append(PackedStringArray([soru, yanit]))
				ust.append(-1)
				bayraklar.append("")
	g.sorular = sorular
	g.soru_ust = ust
	g.soru_bayraklari = bayraklar
	kuyruk.append(g)


static func _bos_yatak_evi(y: KoyYonetimi, tercih_ev: int = -1) -> int:
	if y == null: return -1
	var dolu := {}
	for k in y.koylular:
		if DivanHukmu.zindanda(k): continue
		if k.ev >= 0:
			dolu[k.ev] = int(dolu.get(k.ev, 0)) + 1
	if tercih_ev >= 0:
		var tb := y.bina(tercih_ev)
		if tb != null and tb.hazir() and tb.yatak(y.katalog) > int(dolu.get(tb.id, 0)):
			return tb.id
	for b in y.binalar:
		if b.hazir() and b.yatak(y.katalog) > int(dolu.get(b.id, 0)):
			return b.id
	return -1


static func _uygun_hane(y: KoyYonetimi) -> Dictionary:
	if y == null: return {}
	for k in y.koylular:
		if k.hane_id >= 0 and k.saglik > 0 and k.ev >= 0 and k.yas_grubu in [&"yetiskin", &"yasli"] and not DivanHukmu.zindanda(k):
			return {"hane_id": k.hane_id, "ev": k.ev, "ad": k.ad}
	return {}


static func _es_hanesi_uygun_mu(y: KoyYonetimi) -> bool:
	return y != null and y.hane != null and y.hane.es_hayatta and not y.hane.yas_donemi and y.hane.ev_id >= 0 and y.bina(y.hane.ev_id) != null


static func karar(o: Oturum, g: Gelen, secim: StringName, _is_yeri: StringName = &"") -> Dictionary:
	var engel := {"engellendi": true, "kaldi": false, "kirilan": -1}
	if o == null or not ilgilenir(g): return engel
	var d := durum(o)
	if not String(d.get("sonuc", "")).is_empty(): return engel
	if secim not in [&"kabul", &"ret"]: return engel
	if secim == &"ret":
		o.yonetim.ret(o.tr_gelen(g), false)
		d["sonuc"] = "ret"
		d["gun"] = o.gun
		d["acikta"] = 0
		o.set_meta(META, d)
		return {
			"kaldi": false,
			"kirilan": -1,
			"rusvet_harcandi": -1,
			"alinan": [],
			"alinan_akce": 0,
			"alinan_ambar": {},
			"gasp": false,
			"durust_arandi": false,
			"harc": false,
			"koylu_id": -1,
			"yetim": true,
			"kabul_edilen": 0,
			"acikta": 0,
			"barinak_uyari": "",
			"sonuc_anahtari": "kap18.yetim.ret_sonuc",
			"sonuc_metin": TranslationServer.translate("kap18.yetim.ret_sonuc"),
		}
	var y := o.yonetim
	var hane_bilgi := _uygun_hane(y)
	var es_uygun := _es_hanesi_uygun_mu(y)
	var kabul_edilen: Array[Koylu] = []
	var hane_sayisi := 0
	var es_sayisi := 0
	var acikta_sayisi := 0
	for u in g.aile:
		var k := y.kabul(u)
		k.yas_grubu = &"cocuk"
		k.stat = clampi(int(u.get("stat", 3)), 1, 10)
		k.is_yeri = KoyYonetimi.BOSTA
		k.giris_gunu = y.gun
		k.bayrak_ekle(YETIM_BAYRAK)
		var konuldu := false
		if not hane_bilgi.is_empty():
			var ev_id := _bos_yatak_evi(y, int(hane_bilgi.ev))
			if ev_id >= 0:
				k.hane_id = int(hane_bilgi.hane_id)
				k.ev = ev_id
				hane_sayisi += 1
				konuldu = true
		if not konuldu and es_uygun:
			var ev_id := _bos_yatak_evi(y, y.hane.ev_id)
			if ev_id >= 0 and y.hane.yetim_al(k.ad):
				k.ev = ev_id
				k.bayrak_ekle(ES_BAYRAK)
				if not (k.id in y.hane.uyeler):
					y.hane.uyeler.append(k.id)
				es_sayisi += 1
				konuldu = true
		if not konuldu:
			k.hane_id = -1
			k.ev = -1
			k.bayrak_ekle(ACIKTA_BAYRAK)
			acikta_sayisi += 1
		kabul_edilen.append(k)
	var uyari := Barinak.metin(y, g.aile.size()) if acikta_sayisi > 0 or not Barinak.yeter_mi(y, 1) else ""
	var sonuc_anahtari := "kap18.yetim.kabul_acikta" if acikta_sayisi > 0 and hane_sayisi == 0 and es_sayisi == 0 else ("kap18.yetim.kabul_es" if hane_sayisi == 0 and es_sayisi > 0 else "kap18.yetim.kabul_hane")
	var sonuc_metin := TranslationServer.translate(sonuc_anahtari)
	if not uyari.is_empty() and sonuc_anahtari != "kap18.yetim.kabul_acikta":
		sonuc_metin += "\n" + uyari
	elif not uyari.is_empty():
		sonuc_metin += "\n" + uyari
	d["sonuc"] = "kabul"
	d["gun"] = o.gun
	d["acikta"] = acikta_sayisi
	o.set_meta(META, d)
	o._koy_esitle()
	return {
		"kaldi": true,
		"kirilan": -1,
		"rusvet_harcandi": -1,
		"alinan": [],
		"alinan_akce": 0,
		"alinan_ambar": {},
		"gasp": false,
		"durust_arandi": false,
		"harc": false,
		"koylu_id": kabul_edilen[0].id if not kabul_edilen.is_empty() else -1,
		"yetim": true,
		"kabul_edilen": kabul_edilen.size(),
		"hane": hane_sayisi,
		"es": es_sayisi,
		"acikta": acikta_sayisi,
		"barinak_uyari": uyari,
		"sonuc_anahtari": sonuc_anahtari,
		"sonuc_metin": sonuc_metin,
	}


static func _hane_gecerli_mi(y: KoyYonetimi, k: Koylu) -> bool:
	if y == null or k == null: return false
	if k.bayrak_var(ES_BAYRAK):
		return _es_hanesi_uygun_mu(y)
	if k.hane_id < 0: return false
	for u in y.koylular:
		if u.id == k.id or u.saglik <= 0: continue
		if u.hane_id == k.hane_id and u.yas_grubu in [&"yetiskin", &"yasli"] and u.ev >= 0 and not DivanHukmu.zindanda(u):
			return true
	return false


static func acikta_kalmali(y: KoyYonetimi, k: Koylu) -> bool:
	if k == null or not k.bayrak_var(YETIM_BAYRAK): return false
	if k.yas_grubu != &"cocuk": return false
	return not _hane_gecerli_mi(y, k)


static func gece(y: KoyYonetimi, olaylar: Array[Dictionary]) -> void:
	if y == null: return
	for k in y.koylular:
		if not k.bayrak_var(YETIM_BAYRAK): continue
		if k.yas_grubu == &"cocuk" and y.gun - k.giris_gunu >= GENCE_GECIS_GUNU:
			k.yas_grubu = &"genc"
			k.bayraklar.erase(ACIKTA_BAYRAK)
			olaylar.append({"anahtar": "kap18.yetim.genc_oldu"})
			continue
		if k.yas_grubu == &"cocuk" and not _hane_gecerli_mi(y, k):
			var onceki_acikta := k.ev < 0 and k.bayrak_var(ACIKTA_BAYRAK)
			k.hane_id = -1
			k.ev = -1
			k.bayraklar.erase(ES_BAYRAK)
			k.bayrak_ekle(ACIKTA_BAYRAK)
			if not onceki_acikta:
				olaylar.append({"anahtar": "kap18.yetim.kabul_acikta"})
