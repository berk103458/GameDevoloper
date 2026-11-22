## Koyun, keçi, tavuk ve eşek alımı; barınak kapasitesi, gece ürün katkısı ve sahne yerleşimi.
class_name EkHayvanPazari
extends RefCounted

const META := &"ek_hayvanlar"
const PAZARLIK_META := &"ek_hayvan_pazarlik"
const TURLER: Array[String] = ["koyun", "keci", "tavuk", "esek"]

const HAYVANLAR := {
	"koyun": {
		"ad": "Koyun",
		"fiyat": 18,
		"satis": 9,
		"gida": 1,
		"kece_esik": 2,
		"agil_bonus": 0.12,
		"model": "td_k13",
		"boy": 0.78,
		"katki_ozet": "Gecede +1 Gıda (+ her 2 koyuna +1 Keçe), Ağıl +%12",
	},
	"keci": {
		"ad": "Keçi",
		"fiyat": 20,
		"satis": 10,
		"gida": 1,
		"agil_bonus": 0.15,
		"model": "td_a163",
		"boy": 0.80,
		"katki_ozet": "Gecede +1 Gıda, Ağıl +%15",
	},
	"tavuk": {
		"ad": "Tavuk",
		"fiyat": 10,
		"satis": 5,
		"gida": 1,
		"model": "td_a146",
		"boy": 0.40,
		"katki_ozet": "Gecede +1 Gıda (yumurta / et payı)",
	},
	"esek": {
		"ad": "Eşek",
		"fiyat": 22,
		"satis": 11,
		"odun": 1,
		"tas": 1,
		"uretim_bonus": 0.15,
		"model": "td_a157",
		"boy": 1.20,
		"katki_ozet": "Gecede +1 Odun ve +1 Taş, Tarla/Ocak/Odunluk +%15",
	},
}


static func tuccar_koyde_mi(y: KoyYonetimi) -> bool:
	if y == null or y.son != "":
		return false
	if y.kervan_gunu():
		return true
	return y.gun >= 0 and y.gun <= 2 and not TuccarKapiGecisi.engel(y)


static func tuccar_bilgisi(y: KoyYonetimi) -> Dictionary:
	if y == null:
		return {"ad": "Gezgin Tüccar", "uzmanlik": "Erzak ve hayvan", "kalan": 1, "oncu": true}
	var d := GezginTuccarTakvimi.durum(y.gun, y.a.kervan_araligi)
	if d.aktif:
		return {
			"id": String(d.tuccar.get("id", "celep_hamdullah")),
			"ad": String(d.tuccar.get("ad", "Gezgin Tüccar")),
			"uzmanlik": String(d.tuccar.get("uzmanlik", "Kervan ticareti")),
			"kalan": int(d.get("kalan", 1)),
			"oncu": false,
		}
	if y.gun >= 0 and y.gun <= 2 and not TuccarKapiGecisi.engel(y):
		return {
			"id": "oncu_kervan",
			"ad": "Öncü Gezgin Kervan ve Celep Kalfası",
			"uzmanlik": "Canlı hayvan (koyun/keçi/tavuk/eşek) ve temel erzak",
			"kalan": 3 - y.gun,
			"oncu": true,
		}
	return {
		"id": "beklemede",
		"ad": String(d.sonraki_tuccar.get("ad", "Gezgin Tüccar")),
		"uzmanlik": String(d.sonraki_tuccar.get("uzmanlik", "")),
		"kalan": 0,
		"sonraki_gun": int(d.get("sonraki_gun", 4)),
		"oncu": false,
	}


static func _depo(y: KoyYonetimi) -> Dictionary:
	if y == null:
		return {"koyun": 0, "keci": 0, "tavuk": 0, "esek": 0}
	var v: Variant = y.get_meta(META, {})
	var sonuc := {"koyun": 0, "keci": 0, "tavuk": 0, "esek": 0}
	if v is Dictionary:
		for tur in TURLER:
			sonuc[tur] = clampi(int((v as Dictionary).get(tur, 0)), 0, 500)
	return sonuc


static func sayi(y: KoyYonetimi, tur: String) -> int:
	return int(_depo(y).get(tur, 0))


static func toplam_ek(y: KoyYonetimi) -> int:
	var d := _depo(y)
	var t := 0
	for tur in TURLER:
		t += int(d.get(tur, 0))
	return t


static func kapasite(y: KoyYonetimi, tur: String) -> int:
	var taban := {"koyun": 2, "keci": 2, "tavuk": 3, "esek": 1}
	var cap := int(taban.get(tur, 1))
	if y == null:
		return cap
	for b in y.binalar:
		if not b.hazir():
			continue
		if b.tur == "agil":
			if tur == "koyun": cap += 4
			elif tur == "keci": cap += 3
			elif tur == "tavuk": cap += 2
		elif b.tur in ["kulube", "tas_ev"] and tur == "tavuk":
			cap += 2
		elif b.tur in ["ahir", "ambar"] and tur == "esek":
			cap += 2
	return cap


static func alinabilir(y: KoyYonetimi, tur: String) -> bool:
	if y == null or not HAYVANLAR.has(tur):
		return false
	if not tuccar_koyde_mi(y):
		return false
	var fiyat := int(HAYVANLAR[tur]["fiyat"])
	return sayi(y, tur) < kapasite(y, tur) and y.akce >= fiyat


static func al(y: KoyYonetimi, tur: String) -> bool:
	if not alinabilir(y, tur):
		return false
	var fiyat := int(HAYVANLAR[tur]["fiyat"])
	y.akce -= fiyat
	var d := _depo(y)
	d[tur] = int(d.get(tur, 0)) + 1
	y.set_meta(META, d)
	return true


static func satilabilir(y: KoyYonetimi, tur: String) -> bool:
	if y == null or not HAYVANLAR.has(tur):
		return false
	return tuccar_koyde_mi(y) and sayi(y, tur) > 0


static func sat(y: KoyYonetimi, tur: String) -> bool:
	if not satilabilir(y, tur):
		return false
	var bedel := int(HAYVANLAR[tur]["satis"])
	var d := _depo(y)
	d[tur] = maxi(0, int(d.get(tur, 0)) - 1)
	y.set_meta(META, d)
	y.akce += bedel
	return true


static func carpan_eki(y: KoyYonetimi, b: KoyBinasi, urun: String) -> float:
	if y == null or b == null or not b.hazir() or toplam_ek(y) <= 0:
		return 0.0
	var ek := 0.0
	if b.tur == "agil" and urun == "gida":
		ek += float(sayi(y, "koyun")) * float(HAYVANLAR["koyun"]["agil_bonus"])
		ek += float(sayi(y, "keci")) * float(HAYVANLAR["keci"]["agil_bonus"])
	if b.tur in ["tarla", "bostan", "odunluk", "tas_ocagi"] and urun in ["gida", "bugday", "odun", "tas"]:
		ek += float(sayi(y, "esek")) * float(HAYVANLAR["esek"]["uretim_bonus"])
	return ek


static func gece_katkisi(y: KoyYonetimi, rapor: Dictionary) -> void:
	if y == null or y.son != "":
		return
	var d := _depo(y)
	var eklenen := {}
	var koyun_s := int(d.get("koyun", 0))
	var keci_s := int(d.get("keci", 0))
	var tavuk_s := int(d.get("tavuk", 0))
	var esek_s := int(d.get("esek", 0))
	var inek_s := int(y.lojistik.hayvanlar.get("inek", 0)) if y.lojistik != null else 0
	var koc_s := int(y.lojistik.hayvanlar.get("koc", 0)) if y.lojistik != null else 0
	var okuz_s := int(y.lojistik.hayvanlar.get("okuz", 0)) if y.lojistik != null else 0

	var gida_ek := koyun_s + keci_s + tavuk_s + inek_s + koc_s
	var kece_ek := (koyun_s / 2) + (koc_s / 2)
	var odun_ek := esek_s
	var tas_ek := esek_s
	var bugday_ek := okuz_s if _hazir_bina_var(y, ["tarla", "bostan"]) else 0
	if bugday_ek == 0 and okuz_s > 0:
		odun_ek += okuz_s

	if gida_ek > 0:
		eklenen["gida"] = y.kaynaklar.ekle("gida", gida_ek)
	if kece_ek > 0:
		eklenen["kece"] = y.kaynaklar.ekle("kece", kece_ek)
	if odun_ek > 0:
		eklenen["odun"] = y.kaynaklar.ekle("odun", odun_ek)
	if tas_ek > 0:
		eklenen["tas"] = y.kaynaklar.ekle("tas", tas_ek)
	if bugday_ek > 0:
		eklenen["bugday"] = y.kaynaklar.ekle("bugday", bugday_ek)

	var uretim: Variant = rapor.get("uretim", {})
	if uretim is Dictionary:
		for urun in eklenen:
			var val := int(eklenen[urun])
			if val > 0:
				(uretim as Dictionary)[urun] = int((uretim as Dictionary).get(urun, 0)) + val


static func _hazir_bina_var(y: KoyYonetimi, turler: Array[String]) -> bool:
	for b in y.binalar:
		if b.hazir() and b.tur in turler:
			return true
	return false


static func kaydet(y: KoyYonetimi) -> Dictionary:
	return _depo(y)


static func yukle(y: KoyYonetimi, v: Variant) -> void:
	if y == null or not (v is Dictionary):
		return
	var d := {"koyun": 0, "keci": 0, "tavuk": 0, "esek": 0}
	for tur in TURLER:
		d[tur] = clampi(int((v as Dictionary).get(tur, 0)), 0, 500)
	var sum := 0
	for tur in TURLER:
		sum += int(d[tur])
	if sum > 0:
		y.set_meta(META, d)
	else:
		y.remove_meta(META)


static func ozet_metni(y: KoyYonetimi) -> String:
	var d := _depo(y)
	return "Köy hayvanların · Koyun: %d/%d · Keçi: %d/%d · Tavuk: %d/%d · Eşek: %d/%d" % [
		int(d["koyun"]), kapasite(y, "koyun"),
		int(d["keci"]), kapasite(y, "keci"),
		int(d["tavuk"]), kapasite(y, "tavuk"),
		int(d["esek"]), kapasite(y, "esek"),
	]


static func sahne_hayvanlarini_kur(s: KoyYonetimSahnesi, ust: Node3D) -> void:
	if s == null or s.yonetim == null or ust == null:
		return
	var eski := ust.get_node_or_null(^"satin_alinan_hayvanlar")
	if eski != null:
		ust.remove_child(eski)
		eski.queue_free()
	var y := s.yonetim
	if toplam_ek(y) <= 0:
		return
	var kok := Node3D.new()
	kok.name = "satin_alinan_hayvanlar"
	ust.add_child(kok)
	var rota := KoyRotasi.new()
	rota.kur(y.izgara, 1.0)
	var m := y.a.meydan
	var meydan_merkez := s.alan_merkezi(m.position, m.size)
	var bas := s.hucre_kosesi(Vector2i.ZERO)
	var d := _depo(y)
	var idx := 0
	for tur in TURLER:
		var adet := int(d.get(tur, 0))
		if adet <= 0:
			continue
		var bilgi: Dictionary = HAYVANLAR[tur]
		var model_ad := String(bilgi["model"])
		if not Dunya3B.model_var_mi(model_ad):
			continue
		var boy := float(bilgi["boy"])
		for i in adet:
			var n := Dunya3B.nesne(model_ad, boy)
			n.name = "hayvan_%s_%d" % [tur, i]
			var konum := _hayvan_konumu(s, y, rota, meydan_merkez, bas, tur, idx)
			n.position = Vector3(konum.x, s.ayak_zemini_yuksekligi(konum), konum.z)
			n.rotation.y = deg_to_rad(float((idx * 53) % 360))
			kok.add_child(n)
			idx += 1


static func _hayvan_konumu(s: KoyYonetimSahnesi, y: KoyYonetimi, rota: KoyRotasi, meydan_merkez: Vector3, bas: Vector3, tur: String, idx: int) -> Vector3:
	var tercih_turler: Array[String] = ["agil"]
	if tur == "tavuk":
		tercih_turler = ["kulube", "tas_ev", "agil"]
	elif tur == "esek":
		tercih_turler = ["ahir", "ambar", "tas_ocagi"]
	var uygun_binalar: Array[KoyBinasi] = []
	for b in y.binalar:
		if b.hazir() and b.tur in tercih_turler:
			uygun_binalar.append(b)
	if not uygun_binalar.is_empty():
		var hedef_b := uygun_binalar[idx % uygun_binalar.size()]
		var b_boy := hedef_b.boyut(y.katalog)
		var b_merkez := s.alan_merkezi(hedef_b.hucre, b_boy)
		var ofsetler := [
			Vector3(0.45 * b_boy.x, 0.0, 0.45 * b_boy.y),
			Vector3(-0.45 * b_boy.x, 0.0, 0.45 * b_boy.y),
			Vector3(0.45 * b_boy.x, 0.0, -0.45 * b_boy.y),
			Vector3(-0.45 * b_boy.x, 0.0, -0.45 * b_boy.y),
		]
		for k in ofsetler.size():
			var aday: Vector3 = b_merkez + ofsetler[(idx + k) % ofsetler.size()]
			var hx := int(floor((aday.x - bas.x) / s.HUCRE))
			var hz := int(floor((aday.z - bas.z) / s.HUCRE))
			if not rota.gecilir(Vector2i(hx, hz)):
				return aday
	var aci := float(idx) * 0.95
	var yaricap := 4.4 + float(idx % 3) * 0.65
	return meydan_merkez + Vector3(cos(aci) * yaricap, 0.0, sin(aci) * yaricap)
