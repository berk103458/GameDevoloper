## YAP-06: data/ozel_esyalar.json için doğrulama, çözümleme, satış kalıcılığı ve hedef kapı çarpanları.
class_name OzelEsyalar
extends RefCounted

const VERI_YOLU := "res://data/ozel_esyalar.json"
const META := &"yap06_ozel_esyalar"
const EN_AZ_SATIR := 8
const GECERLI_HEDEFLER := [
	"sur_hasari",
	"degirmen_uretimi",
	"kis_odun_tuketimi",
	"savunma_formulu",
	"erzak",
	"saglik",
	"guvenlik",
]


static func veri_oku(yol: String = VERI_YOLU) -> Dictionary:
	if not FileAccess.file_exists(yol):
		return {}
	var ham: Variant = JSON.parse_string(FileAccess.get_file_as_string(yol))
	return ham as Dictionary if ham is Dictionary else {}


static func _gecerli_hedef_listesi(veri: Dictionary) -> Array[String]:
	var liste: Array[String] = []
	var ham: Variant = veri.get("gecerli_hedefler", GECERLI_HEDEFLER)
	if ham is Array:
		for x in (ham as Array):
			var s := String(x).strip_edges()
			if s in GECERLI_HEDEFLER and not (s in liste):
				liste.append(s)
	if liste.is_empty():
		for s in GECERLI_HEDEFLER:
			liste.append(s)
	return liste


static func tanimlar(veri: Variant = null) -> Array[Dictionary]:
	var kaynak: Dictionary = veri_oku() if veri == null else (veri as Dictionary if veri is Dictionary else {})
	var sonuc: Array[Dictionary] = []
	var ham: Variant = kaynak.get("esyalar", [])
	if not (ham is Array):
		return sonuc
	for oge in (ham as Array):
		if oge is Dictionary:
			sonuc.append((oge as Dictionary).duplicate(true))
	return sonuc


static func tanim(esya_id: String, veri: Variant = null) -> Dictionary:
	var aranan := esya_id.strip_edges()
	if aranan.is_empty():
		return {}
	for oge in tanimlar(veri):
		if String(oge.get("id", "")).strip_edges() == aranan:
			return oge
	return {}


static func _hedefleri_coz(oge: Variant) -> Array[String]:
	var hedefler: Array[String] = []
	if not (oge is Dictionary):
		return hedefler
	var d := oge as Dictionary
	for alan in ["hedef_sistem", "hedef_sistemler", "ikinci_hedef"]:
		if not d.has(alan):
			continue
		var ham: Variant = d[alan]
		if ham is Array:
			for x in (ham as Array):
				var s := String(x).strip_edges()
				if not s.is_empty() and not (s in hedefler):
					hedefler.append(s)
		elif ham is String or ham is StringName:
			for parca in String(ham).replace(";", ",").split(",", false):
				var s := parca.strip_edges()
				if not s.is_empty() and not (s in hedefler):
					hedefler.append(s)
	return hedefler


static func kaynak_notu_var_mi(oge: Variant) -> bool:
	if not (oge is Dictionary):
		return false
	var d := oge as Dictionary
	if d.has("kaynak_notu"):
		return not String(d.get("kaynak_notu", "")).strip_edges().is_empty()
	var anahtar := String(d.get("kaynak_notu_anahtari", "")).strip_edges()
	if anahtar.is_empty():
		return false
	if not TranslationServer.get_loaded_locales().is_empty():
		var ceviri := String(TranslationServer.translate(StringName(anahtar))).strip_edges()
		if ceviri.is_empty() or ceviri == anahtar:
			return false
	return true


static func satir_hatasi(oge: Variant, gecerliler: Array[String] = []) -> String:
	if not (oge is Dictionary):
		return "gecersiz_satir"
	var d := oge as Dictionary
	var oid := String(d.get("id", "")).strip_edges()
	if oid.is_empty():
		return "kimliksiz_esya"
	var ad_var := not String(d.get("ad", "")).strip_edges().is_empty() or not String(d.get("ad_anahtari", "")).strip_edges().is_empty()
	if not ad_var:
		return "adsiz_esya:%s" % oid
	var izinli := gecerliler if not gecerliler.is_empty() else _gecerli_hedef_listesi(veri_oku())
	var hedefler := _hedefleri_coz(d)
	if hedefler.size() > 1:
		return "coklu_hedef_sistem:%s" % oid
	if hedefler.is_empty() or not (hedefler[0] in izinli):
		return "gecersiz_hedef_sistem:%s" % oid
	var carpan_ham: Variant = d.get("carpan", null)
	if not (carpan_ham is int or carpan_ham is float) or not is_finite(float(carpan_ham)) or float(carpan_ham) <= 0.0:
		return "gecersiz_carpan:%s" % oid
	return ""


static func dogrula(veri: Variant = null) -> Array[String]:
	var kaynak: Dictionary = veri_oku() if veri == null else (veri as Dictionary if veri is Dictionary else {})
	var hatalar: Array[String] = []
	if not (kaynak.get("esyalar", null) is Array):
		hatalar.append("esyalar_dizisi_eksik")
		return hatalar
	var gecerliler := _gecerli_hedef_listesi(kaynak)
	var gecerli_sayisi := 0
	for oge in (kaynak["esyalar"] as Array):
		var hata := satir_hatasi(oge, gecerliler)
		if not hata.is_empty():
			hatalar.append(hata)
			continue
		if kaynak_notu_var_mi(oge):
			gecerli_sayisi += 1
	if gecerli_sayisi < EN_AZ_SATIR:
		hatalar.append("yetersiz_ozel_esya:%d" % gecerli_sayisi)
	return hatalar


static func bos() -> Dictionary:
	return {"surum": 1, "cozulmus": []}


static func oku(v: Variant) -> Dictionary:
	var s := bos()
	if not (v is Dictionary):
		return s
	var cozulmus: Variant = (v as Dictionary).get("cozulmus", [])
	if not (cozulmus is Array):
		return s
	var gorulen := {}
	var sonuc: Array[String] = []
	for x in (cozulmus as Array):
		var oid := String(x).strip_edges()
		if oid.is_empty() or gorulen.has(oid):
			continue
		var t := tanim(oid)
		if t.is_empty() or not satir_hatasi(t).is_empty():
			continue
		gorulen[oid] = true
		sonuc.append(oid)
	s["cozulmus"] = sonuc
	return s


static func durum(y: KoyYonetimi) -> Dictionary:
	if y == null:
		return bos()
	return oku(y.get_meta(META, bos()))


static func yukle(y: KoyYonetimi, v: Variant) -> void:
	if y == null:
		return
	y.set_meta(META, oku(v))


## Tek mevcut heybeden (ör. çocuk heybesi) özel eşyaları ikinci kayıt açmadan okur.
static func heybedeki_ozeller(heybe: Heybe) -> Array[Dictionary]:
	var sonuc: Array[Dictionary] = []
	if heybe == null:
		return sonuc
	for e in heybe.esyalar:
		if not (e is Dictionary):
			continue
		var adet := maxi(0, int((e as Dictionary).get("adet", 0)))
		if adet <= 0:
			continue
		var oid := String((e as Dictionary).get("id", (e as Dictionary).get("kaynak", ""))).strip_edges()
		var t := tanim(oid)
		if not t.is_empty():
			sonuc.append({"id": oid, "adet": adet, "tanim": t})
	return sonuc


static func _esya_eslesir_mi(kayit: Variant, esya_id: String) -> bool:
	if not (kayit is Dictionary):
		return false
	var d := kayit as Dictionary
	return String(d.get("id", d.get("kaynak", ""))).strip_edges() == esya_id


static func sahip_adet(o: Oturum, esya_id: String, heybe: Heybe = null) -> int:
	var toplam := 0
	if o != null:
		for e in o.muhafiz_esyalari:
			if _esya_eslesir_mi(e, esya_id):
				toplam += maxi(0, int((e as Dictionary).get("adet", 0)))
	if heybe != null:
		for e in heybe.esyalar:
			if _esya_eslesir_mi(e, esya_id):
				toplam += maxi(0, int((e as Dictionary).get("adet", 0)))
	return toplam


static func cozuldu_mu(y: KoyYonetimi, esya_id: String) -> bool:
	return esya_id.strip_edges() in (durum(y).get("cozulmus", []) as Array)


static func coz(o: Oturum, esya_id: String, heybe: Heybe = null) -> Dictionary:
	if o == null or o.yonetim == null:
		return {"ok": false, "neden": "gecersiz_oturum"}
	var oid := esya_id.strip_edges()
	var t := tanim(oid)
	if t.is_empty() or not satir_hatasi(t).is_empty() or not kaynak_notu_var_mi(t):
		return {"ok": false, "neden": "gecersiz_esya"}
	var d := durum(o.yonetim)
	var liste: Array = d["cozulmus"]
	var hedef := String(t.get("hedef_sistem", ""))
	if oid in liste:
		return {"ok": false, "neden": "zaten_cozuldu", "id": oid, "hedef_sistem": hedef, "carpan": carpan(o.yonetim, hedef)}
	if sahip_adet(o, oid, heybe) <= 0:
		return {"ok": false, "neden": "esya_yok", "id": oid}
	liste.append(oid)
	d["cozulmus"] = liste
	o.yonetim.set_meta(META, d)
	return {"ok": true, "id": oid, "hedef_sistem": hedef, "carpan": float(t.get("carpan", 1.0))}


## Çözülmüş eşya satıldığında yalnızca envanterdeki adet düşer; açılmış kademe kapanmaz.
static func sat(o: Oturum, esya_id: String, adet: int = 1) -> Dictionary:
	if o == null or adet <= 0:
		return {"ok": false, "neden": "gecersiz_istek", "satilan": 0, "akce": 0}
	var oid := esya_id.strip_edges()
	var kalan := adet
	var akce_kazanc := 0
	var i := o.muhafiz_esyalari.size() - 1
	while i >= 0 and kalan > 0:
		var e: Dictionary = o.muhafiz_esyalari[i]
		if _esya_eslesir_mi(e, oid):
			var mevcut := maxi(0, int(e.get("adet", 0)))
			var kes := mini(kalan, mevcut)
			if kes > 0:
				var birim := maxi(1, int(e.get("deger", 10)))
				akce_kazanc += kes * birim
				e["adet"] = mevcut - kes
				kalan -= kes
				if int(e["adet"]) <= 0:
					o.muhafiz_esyalari.remove_at(i)
		i -= 1
	var satilan := adet - kalan
	if satilan <= 0:
		return {"ok": false, "neden": "esya_yok", "satilan": 0, "akce": 0}
	o.muhafiz_akce += akce_kazanc
	return {"ok": true, "id": oid, "satilan": satilan, "akce": akce_kazanc}


static func carpan(y: KoyYonetimi, hedef_sistem: String) -> float:
	if y == null:
		return 1.0
	var hedef := hedef_sistem.strip_edges()
	var sonuc := 1.0
	for oid in (durum(y).get("cozulmus", []) as Array):
		var t := tanim(String(oid))
		if t.is_empty() or not satir_hatasi(t).is_empty():
			continue
		if String(t.get("hedef_sistem", "")).strip_edges() == hedef:
			sonuc *= float(t.get("carpan", 1.0))
	return sonuc


static func sur_hasari(y: KoyYonetimi, ham_hasar: int) -> int:
	if ham_hasar <= 0:
		return 0
	var c := carpan(y, "sur_hasari")
	if is_equal_approx(c, 1.0):
		return ham_hasar
	return maxi(1, roundi(float(ham_hasar) * c))


static func ikon_dokusu(esya_id: String) -> Texture2D:
	var t := tanim(esya_id)
	var ikon := String(t.get("ikon", "")).strip_edges()
	if not ikon.is_empty():
		var ozel := Sanat.doku("icons", "icon_ozel_%s" % ikon)
		if ozel != null:
			return ozel
	return Sanat.doku("icons", "icon_ozel_esya")
