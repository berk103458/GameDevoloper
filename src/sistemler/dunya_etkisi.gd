## DNY-03: dünya olaylarının etki evresini tek geçerli kapıya bağlar.
## İki kapılı veya tanımsız kapılı olay etki yazmaz; aynı olay ikinci kez uygulanmaz.
class_name DunyaEtkisi
extends RefCounted

const META := &"dny03_etkiler"
const GECERLI_KAPILAR := [
	"tehdit_kapisi",
	"gelen_akisi",
	"harac",
	"tuketim",
	"saglik_yoneticisi",
	"fiyat",
]


static func _hedefleri_coz(etki: Variant) -> Array[String]:
	var hedefler: Array[String] = []
	if not (etki is Dictionary):
		return hedefler
	var d := etki as Dictionary
	for alan in ["hedef_kapi", "hedef_kapilar"]:
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


static func satir_hatasi(olay: Variant) -> String:
	if not (olay is Dictionary):
		return "gecersiz_satir"
	var d := olay as Dictionary
	var oid := String(d.get("id", "")).strip_edges()
	var evreler: Variant = d.get("evreler", {})
	if not (evreler is Dictionary) or not (evreler as Dictionary).has("etki"):
		return ""
	var hedefler := _hedefleri_coz((evreler as Dictionary).get("etki", {}))
	if hedefler.size() > 1:
		return "coklu_hedef_kapi:%s" % oid
	if hedefler.is_empty() or not (hedefler[0] in GECERLI_KAPILAR):
		return "gecersiz_hedef_kapi:%s" % oid
	return ""


static func dogrula(veri: Variant = null) -> Array[String]:
	var kaynak: Variant = DunyaZamani.cizelge() if veri == null else veri
	var hatalar: Array[String] = []
	if not (kaynak is Dictionary) or not ((kaynak as Dictionary).get("olaylar", null) is Array):
		hatalar.append("olaylar_dizisi_eksik")
		return hatalar
	for olay in ((kaynak as Dictionary)["olaylar"] as Array):
		var hata := satir_hatasi(olay)
		if not hata.is_empty():
			hatalar.append(hata)
	return hatalar


static func temiz_etkiler(ham: Variant) -> Dictionary:
	var sonuc := {}
	if not (ham is Dictionary):
		return sonuc
	for oid in (ham as Dictionary):
		var v: Variant = (ham as Dictionary)[oid]
		if not (v is Dictionary):
			continue
		var kapi := String((v as Dictionary).get("hedef_kapi", "")).strip_edges()
		if not (kapi in GECERLI_KAPILAR):
			continue
		var carpan := float((v as Dictionary).get("carpan", 1.0))
		if not is_finite(carpan) or carpan <= 0.0:
			continue
		sonuc[String(oid)] = {"hedef_kapi": kapi, "carpan": carpan}
	return sonuc


static func _rapor_ekle(r: Dictionary, oid: String, anahtar: String) -> void:
	if not (r.get("olaylar") is Array):
		return
	var son_anahtar := anahtar.strip_edges()
	if son_anahtar.is_empty() or TranslationServer.translate(son_anahtar) == son_anahtar:
		son_anahtar = "Dünya Etkisi (%s): etki uygulandı." % oid
	(r["olaylar"] as Array).append({"anahtar": son_anahtar, "deger": []})


## Etki evresini oturuma ve gece raporuna en fazla bir kez yazar; yükleme tekrar yazmaz.
static func uygula(o: Oturum, olay: Dictionary, r: Dictionary) -> Dictionary:
	if o == null or o.yonetim == null or not (olay is Dictionary):
		return {"yazildi": false, "neden": "gecersiz_oturum"}
	var oid := String(olay.get("id", "")).strip_edges()
	if oid.is_empty():
		return {"yazildi": false, "neden": "kimliksiz_olay"}
	var d := DunyaZamani.oku(o.dunya_zamani)
	var uygulananlar: Array = d.get("etki_uygulananlar", [])
	var etkiler: Dictionary = temiz_etkiler(d.get("etkiler", {}))
	if oid in uygulananlar or etkiler.has(oid):
		esitle(o)
		return {"yazildi": false, "neden": "zaten_uygulandi"}
	var evreler: Variant = olay.get("evreler", {})
	var etki: Dictionary = (evreler as Dictionary).get("etki", {}) if evreler is Dictionary and (evreler as Dictionary).get("etki") is Dictionary else {}
	var hedefler := _hedefleri_coz(etki)
	if hedefler.size() != 1 or not (hedefler[0] in GECERLI_KAPILAR):
		uygulananlar.append(oid)
		d["etki_uygulananlar"] = uygulananlar
		d["etkiler"] = etkiler
		o.dunya_zamani = d
		if r.get("olaylar") is Array:
			(r["olaylar"] as Array).append({"anahtar": "Dünya Etkisi (%s): yazılmadı" % oid, "deger": []})
		esitle(o)
		return {"yazildi": false, "neden": "yazilmadi", "id": oid}
	var kapi := hedefler[0]
	var carpan := maxf(0.1, float(etki.get("carpan", 1.0)))
	uygulananlar.append(oid)
	etkiler[oid] = {"hedef_kapi": kapi, "carpan": carpan}
	d["etki_uygulananlar"] = uygulananlar
	d["etkiler"] = etkiler
	o.dunya_zamani = d
	esitle(o)
	_rapor_ekle(r, oid, String(etki.get("rapor_anahtari", "")))
	return {"yazildi": true, "id": oid, "hedef_kapi": kapi, "carpan": carpan}


static func harita_olustur(o: Oturum) -> Dictionary:
	var harita := {}
	if o == null:
		return harita
	var etkiler := temiz_etkiler(o.dunya_zamani.get("etkiler", {}))
	for oid in etkiler:
		var kayit: Dictionary = etkiler[oid]
		var kapi := String(kayit["hedef_kapi"])
		harita[kapi] = float(harita.get(kapi, 1.0)) * float(kayit["carpan"])
	return harita


static func esitle(o: Oturum) -> void:
	if o == null or o.yonetim == null:
		return
	o.yonetim.set_meta(META, harita_olustur(o))


static func y_carpani(y: KoyYonetimi, kapi: String) -> float:
	if y == null or not y.has_meta(META):
		return 1.0
	var harita: Variant = y.get_meta(META, {})
	if not (harita is Dictionary):
		return 1.0
	return maxf(0.1, float((harita as Dictionary).get(kapi, 1.0)))


static func o_carpani(o: Oturum, kapi: String) -> float:
	if o == null:
		return 1.0
	var harita := harita_olustur(o)
	if harita.has(kapi):
		return maxf(0.1, float(harita[kapi]))
	if o.yonetim != null:
		return y_carpani(o.yonetim, kapi)
	return 1.0
