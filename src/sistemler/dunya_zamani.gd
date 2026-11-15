## DNY-01: Dünya zaman çizelgesi (erken söylenti → kesin haber → etki).
## Günler `data/dunya/zaman_cizelgesi.json` içindedir; Moğol günü HAR-02 (`MogolOncusu`) sayacından okunur.
## Çizelge bar, kasa veya nüfus değiştirmez; etki evresi DNY-03'e çağrı yapar.
class_name DunyaZamani
extends RefCounted

const CIZELGE_YOLU := "res://data/dunya/zaman_cizelgesi.json"
const KITAP_DIZINI := "res://docs/dunya_kitabi"
const EVRELER := ["erken_soylenti", "kesin_haber", "etki"]
const GERI_DONEN_KARARLAR := ["tekfur_haraci", "mogol_elcisi", "turkmen_ittifaki"]
const KARAR_DEGERLERI := ["bekliyor", "kabul", "ret"]
const KARAR_GUN_KAYMASI := {"kabul": 4, "ret": -4, "bekliyor": 0}
const YASAK_CELISKI_KELIMELER := [
	"fetret", "malazgirt", "1071", "1402", "1453",
	"osmanli", "osmanlı", "timur", "tufek", "tüfek", "barut",
]

static var _cizelge_onbellek: Dictionary = {}
static var _kitap_onbellek: Dictionary = {}


static func cizelge(yol: String = CIZELGE_YOLU) -> Dictionary:
	if yol == CIZELGE_YOLU and not _cizelge_onbellek.is_empty():
		return _cizelge_onbellek
	if not FileAccess.file_exists(yol):
		return {}
	var veri: Variant = JSON.parse_string(FileAccess.get_file_as_string(yol))
	if not (veri is Dictionary):
		return {}
	if yol == CIZELGE_YOLU:
		_cizelge_onbellek = veri
	return veri


static func kitap_olgulari(dizin: String = KITAP_DIZINI) -> Dictionary:
	if dizin == KITAP_DIZINI and not _kitap_onbellek.is_empty():
		return _kitap_onbellek
	var olgular := {}
	var dir := DirAccess.open(dizin)
	if dir == null:
		return olgular
	var rx := RegEx.new()
	rx.compile("^- \\*\\*([a-z0-9_]+):\\*\\*\\s*(.+)$")
	dir.list_dir_begin()
	var ad := dir.get_next()
	while ad != "":
		if not dir.current_is_dir() and ad.ends_with(".md") and ad != "README.md":
			var icerik := FileAccess.get_file_as_string(dizin.path_join(ad))
			for satir in icerik.split("\n"):
				var m := rx.search(satir.strip_edges())
				if m != null:
					olgular[m.get_string(1)] = m.get_string(2)
		ad = dir.get_next()
	dir.list_dir_end()
	if dizin == KITAP_DIZINI:
		_kitap_onbellek = olgular
	return olgular


static func _satir_metinleri(olay: Dictionary) -> Array[String]:
	var parcalar: Array[String] = []
	for k in ["id", "ad", "ad_anahtari", "kaynak_notu", "kaynak_notu_anahtari", "metin"]:
		var v: Variant = olay.get(k, "")
		if v is String and not String(v).is_empty():
			parcalar.append(String(v))
	var evreler: Variant = olay.get("evreler", {})
	if evreler is Dictionary:
		for ev in (evreler as Dictionary).values():
			if ev is Dictionary:
				var replikler: Variant = (ev as Dictionary).get("replikler", [])
				if replikler is Array:
					for r in replikler:
						if r is Dictionary and (r as Dictionary).has("metin"):
							parcalar.append(String((r as Dictionary)["metin"]))
	return parcalar


static func _yasak_kelime_var_mi(metin: String) -> String:
	var kucuk := metin.to_lower()
	for kelime in YASAK_CELISKI_KELIMELER:
		var rx := RegEx.new()
		rx.compile("(^|[^a-zçğıöşü0-9_])" + kelime + "([^a-zçğıöşü0-9_]|$)")
		if rx.search(kucuk) != null:
			return kelime
	return ""


static func satir_hatasi(olay: Variant, bilinen_olgular: Dictionary) -> String:
	if not (olay is Dictionary):
		return "gecersiz_satir"
	var d: Dictionary = olay
	var id := String(d.get("id", "")).strip_edges()
	if id.is_empty():
		return "bos_olay_id"
	if bool(d.get("dunya_kitabi_celiski", false)):
		return "dunya_kitabi_celiski:%s" % id
	var olgu_ref := String(d.get("olgu", d.get("dunya_kitabi_olgu", ""))).strip_edges()
	if not olgu_ref.is_empty() and not bilinen_olgular.is_empty() and not bilinen_olgular.has(olgu_ref):
		return "bilinmeyen_olgu:%s:%s" % [id, olgu_ref]
	for metin in _satir_metinleri(d):
		var yasak := _yasak_kelime_var_mi(metin)
		if not yasak.is_empty():
			return "dunya_kitabi_celiski:%s:%s" % [id, yasak]
	var evreler: Variant = d.get("evreler", {})
	if not (evreler is Dictionary):
		return "eksik_evreler:%s" % id
	var etki: Variant = (evreler as Dictionary).get("etki", {})
	if etki is Dictionary:
		var hk: Variant = (etki as Dictionary).get("hedef_kapi", "")
		if hk is Array and (hk as Array).size() > 1:
			return "coklu_hedef_kapi:%s" % id
		var hklar: Variant = (etki as Dictionary).get("hedef_kapilar", [])
		if hklar is Array and (hklar as Array).size() > 1:
			return "coklu_hedef_kapi:%s" % id
	return ""


static func dogrula(veri: Variant = null, kitap_dizin: String = KITAP_DIZINI) -> Array[String]:
	var kaynak: Dictionary = veri if veri is Dictionary else cizelge()
	var hatalar: Array[String] = []
	var olaylar: Variant = kaynak.get("olaylar", [])
	if not (olaylar is Array):
		hatalar.append("olaylar_dizi_degil")
		return hatalar
	var bilinen := kitap_olgulari(kitap_dizin)
	var gorulen := {}
	for olay in olaylar:
		var h := satir_hatasi(olay, bilinen)
		if not h.is_empty():
			hatalar.append(h)
			continue
		var id := String((olay as Dictionary).get("id", "")).strip_edges()
		if gorulen.has(id):
			hatalar.append("tekrar_olay_id:%s" % id)
			continue
		gorulen[id] = true
	return hatalar


static func gecerli_olaylar(veri: Variant = null, kitap_dizin: String = KITAP_DIZINI) -> Array[Dictionary]:
	var kaynak: Dictionary = veri if veri is Dictionary else cizelge()
	var sonuc: Array[Dictionary] = []
	var olaylar: Variant = kaynak.get("olaylar", [])
	if not (olaylar is Array):
		return sonuc
	var bilinen := kitap_olgulari(kitap_dizin)
	var gorulen := {}
	for olay in olaylar:
		if not satir_hatasi(olay, bilinen).is_empty():
			continue
		var d: Dictionary = olay
		var id := String(d.get("id", "")).strip_edges()
		if gorulen.has(id):
			continue
		gorulen[id] = true
		sonuc.append(d)
	return sonuc


## HAR-02 kalan gün sayısını tek kaynaktan (MogolOncusu) okur; ayrı sayaç tutmaz.
static func mogol_kalan_gun(o: Oturum) -> int:
	if o == null:
		return int(MogolOncusu.AYAR.get("varis_gunu", 0))
	return int(MogolOncusu.durum(o).get("kalan", 0))


static func evre_gunu(o: Oturum, olay: Dictionary, evre: String) -> int:
	var evreler: Variant = olay.get("evreler", {})
	if not (evreler is Dictionary):
		return 0
	var ev: Variant = (evreler as Dictionary).get(evre, {})
	if not (ev is Dictionary):
		return 0
	var ev_d: Dictionary = ev
	var kayma := _olay_karar_kaymasi(o, olay)
	if String(olay.get("gun_kaynagi", "")) == "har02_sayaci":
		var g := maxi(0, o.gun) if o != null else 0
		var varis := g + mogol_kalan_gun(o)
		if o != null and g > int(MogolOncusu.AYAR.get("varis_gunu", varis)):
			varis = int(MogolOncusu.AYAR.get("varis_gunu", varis))
		return maxi(1, varis + int(ev_d.get("gun_ofset", 0)) + kayma)
	return maxi(1, int(ev_d.get("gun", 0)) + kayma)


static func _olay_karar_kaymasi(o: Oturum, olay: Dictionary) -> int:
	if o == null:
		return 0
	var dal := olay_karar_dali(o, olay)
	var k := String(dal.get("karar", "bekliyor"))
	return int(KARAR_GUN_KAYMASI.get(k, 0))


static func _temiz_isaretler(ham_isaret: Variant) -> Array[String]:
	var sonuc: Array[String] = []
	if ham_isaret is Array:
		for x in ham_isaret:
			var s := String(x).strip_edges()
			if s.is_empty() or s == "kalp" or s.begins_with("kalp."):
				continue
			if not (s in sonuc):
				sonuc.append(s)
	return sonuc


static func _varsayilan_kararlar() -> Dictionary:
	var k := {}
	for ad in GERI_DONEN_KARARLAR:
		k[ad] = "bekliyor"
	return k


static func oku(v: Variant) -> Dictionary:
	var d: Dictionary = {
		"isaretler": [],
		"son_gece": -1,
		"taban_gun": 0,
		"etki_uygulananlar": [],
		"kararlar": _varsayilan_kararlar(),
		"bekleyen_karar_isaretleri": [],
		"son_karar_gece": -1,
		"iletildi": [],
	}
	if not (v is Dictionary):
		return d
	var ham: Dictionary = v
	d["isaretler"] = _temiz_isaretler(ham.get("isaretler", []))
	var sg: Variant = ham.get("son_gece", -1)
	if (sg is int or sg is float) and is_finite(float(sg)):
		d["son_gece"] = maxi(-1, int(sg))
	var tg: Variant = ham.get("taban_gun", 0)
	if (tg is int or tg is float) and is_finite(float(tg)):
		d["taban_gun"] = maxi(0, int(tg))
	var skg: Variant = ham.get("son_karar_gece", -1)
	if (skg is int or skg is float) and is_finite(float(skg)):
		d["son_karar_gece"] = maxi(-1, int(skg))
	var eu: Variant = ham.get("etki_uygulananlar", [])
	if eu is Array:
		for x in eu:
			var s := String(x).strip_edges()
			if not s.is_empty() and not (s in d["etki_uygulananlar"]):
				(d["etki_uygulananlar"] as Array).append(s)
	var kr: Variant = ham.get("kararlar", {})
	if kr is Dictionary:
		for k in GERI_DONEN_KARARLAR:
			if (kr as Dictionary).has(k):
				var val := String((kr as Dictionary)[k]).strip_edges()
				d["kararlar"][k] = val if val in KARAR_DEGERLERI else "bekliyor"
	var bk: Variant = ham.get("bekleyen_karar_isaretleri", [])
	if bk is Array:
		for x in bk:
			var s := String(x).strip_edges()
			if s in GERI_DONEN_KARARLAR and not (s in d["bekleyen_karar_isaretleri"]):
				(d["bekleyen_karar_isaretleri"] as Array).append(s)
	var il: Variant = ham.get("iletildi", [])
	if il is Array:
		for x in il:
			var s := String(x).strip_edges()
			if not s.is_empty() and not (s in d["iletildi"]):
				(d["iletildi"] as Array).append(s)
	return d


static func karar_durumu(o: Oturum, karar_id: String) -> String:
	var kid := String(karar_id).strip_edges()
	if not (kid in GERI_DONEN_KARARLAR):
		return ""
	var k: Dictionary = durum(o).get("kararlar", {})
	var val := String(k.get(kid, "bekliyor")).strip_edges()
	return val if val in KARAR_DEGERLERI else "bekliyor"


static func kararlar_oku(o: Oturum) -> Dictionary:
	var sonuc := {}
	for k in GERI_DONEN_KARARLAR:
		sonuc[k] = karar_durumu(o, k)
	return sonuc


static func olay_karar_dali(o: Oturum, olay: Dictionary) -> Dictionary:
	var kk: Variant = olay.get("karar_kosulu", {})
	if not (kk is Dictionary):
		return {"bagli_karar": "", "karar": "bekliyor", "anahtar": ""}
	var kk_d: Dictionary = kk
	var bagli := String(kk_d.get("bagli_karar", "")).strip_edges()
	if not (bagli in GERI_DONEN_KARARLAR):
		return {"bagli_karar": "", "karar": "bekliyor", "anahtar": ""}
	var val := karar_durumu(o, bagli)
	return {
		"bagli_karar": bagli,
		"karar": val,
		"anahtar": String(kk_d.get(val, kk_d.get("bekliyor", ""))),
	}


## DNY-04: Yalnız üç karar (tekfur_haraci, mogol_elcisi, turkmen_ittifaki) yazılır;
## aynı karara iki kez basılırsa son değeri tutar; kalp alanı veya kapı genel kabulü yazılmaz.
static func karar_kaydet(o: Oturum, karar_id: String, deger: String) -> bool:
	var kid := String(karar_id).strip_edges()
	var val := String(deger).strip_edges()
	if o == null or not (kid in GERI_DONEN_KARARLAR) or not (val in KARAR_DEGERLERI):
		return false
	var d := oku(o.dunya_zamani)
	d["kararlar"][kid] = val
	if not (kid in d["bekleyen_karar_isaretleri"]):
		(d["bekleyen_karar_isaretleri"] as Array).append(kid)
	o.dunya_zamani = d
	return true


static func _karar_isareti_yaz(d: Dictionary, no: int) -> Array[String]:
	var yazilan: Array[String] = []
	if no <= int(d.get("son_karar_gece", -1)):
		return yazilan
	var aday := ""
	var bekleyen: Array = d.get("bekleyen_karar_isaretleri", [])
	for kid_v in bekleyen:
		var kid := String(kid_v)
		if kid in GERI_DONEN_KARARLAR and String((d["kararlar"] as Dictionary).get(kid, "bekliyor")) in ["kabul", "ret"]:
			aday = kid
			break
	if aday.is_empty():
		var kararlar_d: Dictionary = d.get("kararlar", {})
		for kid in GERI_DONEN_KARARLAR:
			var val := String(kararlar_d.get(kid, "bekliyor"))
			if val in ["kabul", "ret"] and not ("karar.%s.%s" % [kid, val] in d["isaretler"]):
				aday = kid
				break
	if aday.is_empty():
		return yazilan
	var val := String((d["kararlar"] as Dictionary).get(aday, "bekliyor"))
	var hedef_isaret := "karar.%s.%s" % [aday, val]
	var temiz: Array = []
	for x in d["isaretler"]:
		var s := String(x)
		if s.begins_with("karar.%s." % aday):
			continue
		temiz.append(s)
	if not (hedef_isaret in temiz):
		temiz.append(hedef_isaret)
		yazilan.append(hedef_isaret)
	d["isaretler"] = temiz
	d["son_karar_gece"] = no
	var kalan_bekleyen: Array = []
	for x in bekleyen:
		if String(x) != aday:
			kalan_bekleyen.append(x)
	d["bekleyen_karar_isaretleri"] = kalan_bekleyen
	return yazilan


static func durum(o: Oturum) -> Dictionary:
	if o == null:
		return oku({})
	return oku(o.dunya_zamani)


static func isaretler(o: Oturum) -> Array[String]:
	var sonuc: Array[String] = []
	for x in durum(o).get("isaretler", []):
		sonuc.append(String(x))
	return sonuc


static func isaret_var_mi(o: Oturum, isaret: String) -> bool:
	return isaret in isaretler(o)


## Kayıttan okuma: eski kayıtta `dunya_zamani` / `isaretler` yoksa boş başlar ve geçmiş geceleri zorlamaz.
static func kayittan_oku(o: Oturum, veri: Dictionary) -> void:
	if o == null:
		return
	var ham: Variant = veri.get("dunya_zamani", null)
	if not (ham is Dictionary) or not (ham as Dictionary).has("isaretler"):
		var bos := oku({})
		bos["taban_gun"] = maxi(0, o.gun)
		bos["son_gece"] = maxi(-1, o.gun)
		o.dunya_zamani = bos
		return
	o.dunya_zamani = oku(ham)


## Gece sonu çizelge ilerlemesi. Tek gecede en fazla bir etki evresi yazılır; öbürü ertesi geceye kalır.
## Çizelge bar, kasa veya nüfus değiştirmez.
static func gece(o: Oturum, r: Dictionary, ozel_cizelge: Variant = null, kitap_dizin: String = KITAP_DIZINI) -> Dictionary:
	if o == null or o.yonetim == null or o.yonetim.son != "":
		return {}
	var no := int(r.get("gun", o.gun - 1)) + 1
	var d := oku(o.dunya_zamani)
	if no <= int(d["son_gece"]):
		return {}
	d["son_gece"] = no
	var taban := int(d.get("taban_gun", 0))
	var yazilan_evreler: Array[String] = []
	var etki_yazildi := false
	var olay_listesi := gecerli_olaylar(ozel_cizelge, kitap_dizin)
	for olay in olay_listesi:
		var id := String(olay.get("id", "")).strip_edges()
		for evre in EVRELER:
			var e_gun := evre_gunu(o, olay, evre)
			if e_gun < taban or no < e_gun:
				continue
			var isaret := "%s.%s" % [id, evre]
			if isaret in d["isaretler"]:
				continue
			if evre == "etki":
				if etki_yazildi:
					continue
				etki_yazildi = true
				(d["isaretler"] as Array).append(isaret)
				if not (id in d["isaretler"]):
					(d["isaretler"] as Array).append(id)
				yazilan_evreler.append(isaret)
				if ResourceLoader.exists("res://src/sistemler/dunya_etkisi.gd"):
					var etki_sinifi = load("res://src/sistemler/dunya_etkisi.gd")
					if etki_sinifi != null and etki_sinifi.has_method("uygula"):
						etki_sinifi.uygula(o, olay, r)
			else:
				(d["isaretler"] as Array).append(isaret)
				yazilan_evreler.append(isaret)
				_koy_dedikodusu_yaz(o, olay, evre, no)
	var karar_yazilan := _karar_isareti_yaz(d, no)
	yazilan_evreler.append_array(karar_yazilan)
	o.dunya_zamani = d
	return {"gece": no, "yeni_isaretler": yazilan_evreler, "yeni_karar_isaretleri": karar_yazilan}


static func _replik_metni(rep: Dictionary) -> String:
	var anahtar := String(rep.get("anahtar", "")).strip_edges()
	if not anahtar.is_empty():
		var ceviri := TranslationServer.translate(anahtar)
		if not ceviri.is_empty() and ceviri != anahtar:
			return ceviri
	return String(rep.get("metin", "")).strip_edges()


static func _canli_tanik_id(y: KoyYonetimi, konusmaci: String) -> String:
	if y == null or y.koylular.is_empty():
		return ""
	var en_kucuk := -1
	for k in y.koylular:
		if k.saglik <= 0:
			continue
		if not konusmaci.is_empty() and String(k.adli_id) == konusmaci:
			return str(k.id)
		if en_kucuk < 0 or k.id < en_kucuk:
			en_kucuk = k.id
	return "" if en_kucuk < 0 else str(en_kucuk)


static func _koy_dedikodusu_yaz(o: Oturum, olay: Dictionary, evre: String, gece_no: int) -> void:
	if o == null or o.dedikodu == null or o.yonetim == null:
		return
	var evreler: Variant = olay.get("evreler", {})
	if not (evreler is Dictionary):
		return
	var ev_d: Variant = (evreler as Dictionary).get(evre, {})
	if not (ev_d is Dictionary):
		return
	var replikler: Variant = (ev_d as Dictionary).get("replikler", [])
	if not (replikler is Array):
		return
	var olay_id := String(olay.get("id", "")).strip_edges()
	for rep in replikler:
		if not (rep is Dictionary):
			continue
		var rd: Dictionary = rep
		if String(rd.get("konu", "")) != "koy_dedikodusu":
			continue
		var tanik := _canli_tanik_id(o.yonetim, String(rd.get("konusmaci", "")))
		if tanik.is_empty():
			return
		var metin := _replik_metni(rd)
		if metin.is_empty():
			return
		o.dedikodu.olay_kaydet("dunya_%s_%s" % [olay_id, evre], "dunya_haberi", gece_no, tanik, 1, {"satir": metin, "olay": olay_id, "evre": evre})
		return


## DNY-02: erken söylenti ve kesin haber satırlarını salt-okunur döner.
static func haber_satirlari(o: Oturum, konu: String = "", ozel_cizelge: Variant = null, kitap_dizin: String = KITAP_DIZINI, sadece_olay_id: String = "") -> Array[Dictionary]:
	var sonuc: Array[Dictionary] = []
	if o == null:
		return sonuc
	var aktif_isaretler := isaretler(o)
	for olay in gecerli_olaylar(ozel_cizelge, kitap_dizin):
		var oid := String(olay.get("id", "")).strip_edges()
		if not sadece_olay_id.is_empty() and oid != sadece_olay_id:
			continue
		var evreler: Variant = olay.get("evreler", {})
		if not (evreler is Dictionary):
			continue
		for evre in ["erken_soylenti", "kesin_haber"]:
			if not ("%s.%s" % [oid, evre] in aktif_isaretler):
				continue
			var ev_d: Variant = (evreler as Dictionary).get(evre, {})
			if not (ev_d is Dictionary):
				continue
			var replikler: Variant = (ev_d as Dictionary).get("replikler", [])
			if not (replikler is Array):
				continue
			for rep in replikler:
				if not (rep is Dictionary):
					continue
				var rd: Dictionary = rep
				var r_konu := String(rd.get("konu", ""))
				if not konu.is_empty() and r_konu != konu:
					continue
				var metin := _replik_metni(rd)
				if metin.is_empty():
					continue
				sonuc.append({
					"olay_id": oid,
					"evre": evre,
					"konu": r_konu,
					"konusmaci": String(rd.get("konusmaci", "")),
					"anahtar": String(rd.get("anahtar", "")),
					"metin": metin,
				})
	return sonuc


static func koy_dedikodu_satirlari(o: Oturum) -> Array[Dictionary]:
	var sonuc: Array[Dictionary] = []
	if o == null or o.dedikodu == null:
		return sonuc
	for k in o.dedikodu.kayitlar():
		if String(k.get("tur", "")) == "dunya_haberi":
			sonuc.append(k)
	return sonuc


## DNY-02: boş günde yüz üretmez ve bekleyen haberi silmez; bir sonraki gerçek gelende "Yolda ne gördün?" dalına bağlar.
static func kapi_haberi_ekle(o: Oturum, kuyruk: Array[Gelen], ozel_cizelge: Variant = null, kitap_dizin: String = KITAP_DIZINI) -> void:
	if o == null or kuyruk.is_empty():
		return
	var d := oku(o.dunya_zamani)
	var iletildi: Array = d.get("iletildi", [])
	var adaylar := haber_satirlari(o, "yolda_ne_gordun", ozel_cizelge, kitap_dizin)
	if adaylar.is_empty():
		return
	var soru_baslik := String(KonuMerkezi.SABIT_KONU_BASLIKLARI.get("yolda_ne_gordun", "Yolda ne gördün?"))
	var degisti := false
	for h in adaylar:
		var isaret := "%s.%s" % [String(h.olay_id), String(h.evre)]
		if isaret in iletildi:
			continue
		var hedef: Gelen = null
		for g in kuyruk:
			if g != null and String(g.id) == String(h.konusmaci):
				hedef = g
				break
		if hedef == null:
			for g in kuyruk:
				if g != null:
					hedef = g
					break
		if hedef == null:
			continue
		hedef.sorular.append(PackedStringArray([soru_baslik, String(h.metin)]))
		var ust := hedef.soru_ust.duplicate()
		ust.append(-1)
		hedef.soru_ust = ust
		var bay := hedef.soru_bayraklari.duplicate()
		bay.append("")
		hedef.soru_bayraklari = bay
		iletildi.append(isaret)
		degisti = true
	if degisti:
		d["iletildi"] = iletildi
		o.dunya_zamani = d
