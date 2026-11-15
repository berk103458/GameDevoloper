## SAB-01 … SAB-10: hükmün sabah kaydı. Cümle yazılmaz, anahtar ve kimlik tutulur.
## Erzak ve üretim formülüne yazılmaz; ekmek planı zindan_ekmegi okuyucusundan gelir.
class_name SabahDefteri
extends RefCounted

const META := &"sabah_defteri"
const YOLLAR := "res://data/soz/surgun_yollari.json"

static func bos() -> Dictionary:
	return {
		"satirlar": [], "gun": -1, "yazilan_gun": -1, "kisi": -1, "hukum": "",
		"hane": [], "evi_bos": false, "kapali": -1, "katki": 0,
		"dedikodu": 0, "ekmek": 0, "ekmek_isaret": "", "yol": "",
		"nufus_deltasi": 0, "cenaze": 0, "kapandi": false, "kayip": false, "adalet": "",
	}


static func oku(v: Variant) -> Dictionary:
	var d := bos()
	if not v is Dictionary:
		return d
	if v.get("satirlar") is Array:
		d.satirlar = v.satirlar.duplicate(true)
	for alan in ["gun", "yazilan_gun", "kisi", "kapali", "katki", "dedikodu", "ekmek", "nufus_deltasi", "cenaze"]:
		if v.get(alan) is int or v.get(alan) is float:
			d[alan] = int(v[alan])
	if v.get("hukum") is String:
		d.hukum = String(v.hukum)
	if v.get("hane") is Array:
		d.hane = v.hane.duplicate()
	if v.get("evi_bos") is bool:
		d.evi_bos = v.evi_bos
	if v.get("ekmek_isaret") is String:
		d.ekmek_isaret = String(v.ekmek_isaret)
	if v.get("yol") is String:
		d.yol = String(v.yol)
	if v.get("kapandi") is bool:
		d.kapandi = v.kapandi
	if v.get("kayip") is bool:
		d.kayip = v.kayip
	if v.get("adalet") is String:
		d.adalet = String(v.adalet)
	return d


static func durum(y: KoyYonetimi) -> Dictionary:
	return oku(y.get_meta(META, {}))


static func _yaz(y: KoyYonetimi, d: Dictionary) -> void:
	y.set_meta(META, d)


static func son_hukum(y: KoyYonetimi) -> Dictionary:
	var en_gun := -1
	var secilen := {}
	for id in DivanHukmu.durum(y):
		var x: Dictionary = DivanHukmu.durum(y)[id]
		if int(x.gun) >= en_gun:
			en_gun = int(x.gun)
			secilen = {"kisi": int(id), "hukum": String(x.karar), "adli_id": String(x.adli_id)}
	return secilen


static func hane_kisiler(y: KoyYonetimi, kisi_id: int) -> Array:
	var k := y.koylu(kisi_id)
	if k == null or k.hane_id < 0:
		return []
	var liste: Array = []
	for p in y.koylular:
		if p.hane_id == k.hane_id and p.saglik > 0:
			liste.append({"id": p.id, "ad": p.ad, "agir_is": p.yas_grubu != &"cocuk"})
	return liste


static func yollar() -> PackedStringArray:
	var veri = JSON.parse_string(FileAccess.get_file_as_string(YOLLAR))
	var sonuc := PackedStringArray()
	if veri is Dictionary and veri.get("yollar") is Array:
		for ad in veri.yollar:
			sonuc.append(String(ad))
	return sonuc


static func yol_sec(tohum: int) -> String:
	var liste := yollar()
	if liste.is_empty():
		return ""
	var i := absi(tohum) % liste.size()
	return String(liste[i])


static func tezgah_kapali_mi(y: KoyYonetimi, bina_id: int) -> bool:
	return int(durum(y).kapali) == bina_id and bina_id >= 0


static func katki(y: KoyYonetimi) -> int:
	return int(durum(y).katki)


## İlk sabah. Aynı sabah ikinci çağrı satır eklemez. Ekonomi stokuna yazmaz.
static func sabah(y: KoyYonetimi, tohum: int = 0, tanik: String = "", yol_ver: Variant = null) -> Dictionary:
	var d := durum(y)
	if d.hukum != "" or int(d.yazilan_gun) == y.gun:
		return d
	var hukum := son_hukum(y)
	if hukum.is_empty():
		d.satirlar = []
		d.yazilan_gun = y.gun
		d.gun = -1
		_yaz(y, d)
		return d
	var kisi := int(hukum.kisi)
	var tur := String(hukum.hukum)
	d.kisi = kisi
	d.hukum = tur
	d.gun = 0
	d.yazilan_gun = y.gun
	d.adalet = "adalet" if tur in ["infaz", "surgun"] else ""
	d.satirlar = [{"kisi": kisi, "hukum": tur, "gun": 0, "anahtar": "sabah.hukum.satir", "adalet": d.adalet}]
	var hane := hane_kisiler(y, kisi)
	d.hane = hane
	d.evi_bos = hane.is_empty()
	var k := y.koylu(kisi)
	if k != null and k.is_yeri >= 0:
		d.kapali = k.is_yeri
		d.katki = 0
	else:
		d.kapali = -1
		d.katki = 0
	d.yol = ""
	d.nufus_deltasi = 0
	d.cenaze = 0
	d.ekmek = 0
	d.ekmek_isaret = ""
	d.dedikodu = 0
	if tur == "surgun":
		if y.koylu(kisi) != null and not HaneEsi.izinli_mi(y.koylu(kisi), "surgun"):
			d.yol = ""
			d.nufus_deltasi = 0
			d.uyari = HaneEsi.surgun_uyarisi(y, y.koylu(kisi))
		else:
			d.yol = String(yol_ver) if yol_ver is String else yol_sec(tohum)
			if d.yol.is_empty():
				d.nufus_deltasi = 0
			elif y.koylu(kisi) != null and y.surgun(kisi):
				d.nufus_deltasi = -1
			elif y.koylu(kisi) == null:
				d.nufus_deltasi = -1
	if tur == "infaz":
		d.cenaze = _cenaze_bir(y)
	var plan := preload("res://src/koy/zindan_ekmegi.gd").plan(tur, not d.evi_bos, _ambar(y))
	d.ekmek = int(plan.dusum)
	d.ekmek_isaret = String(plan.isaret)
	if d.kapali >= 0 and not tanik.is_empty():
		d.dedikodu = _dedikodu(y, kisi, tanik, "sabah.dedikodu.tezgah.%d" % int(d.kapali))
	elif d.kapali < 0 and not tanik.is_empty() and not tur.is_empty():
		d.dedikodu = _dedikodu(y, kisi, tanik, "sabah.dedikodu." + tur)
	_yaz(y, d)
	return d


static func ilerle(y: KoyYonetimi) -> Dictionary:
	var d := durum(y)
	if d.hukum.is_empty() or d.kapandi or int(d.gun) < 0:
		return d
	if int(d.gun) + 1 >= preload("res://src/koy/zindan_ekmegi.gd").tavan():
		d.kapandi = true
		_yaz(y, d)
		return d
	d.gun = int(d.gun) + 1
	d.nufus_deltasi = 0
	d.cenaze = int(d.cenaze)
	var plan := preload("res://src/koy/zindan_ekmegi.gd").plan(String(d.hukum), not bool(d.evi_bos), _ambar(y))
	if int(d.gun) < preload("res://src/koy/zindan_ekmegi.gd").tavan():
		d.ekmek = int(d.ekmek) + int(plan.dusum)
		if String(plan.isaret) != "":
			d.ekmek_isaret = String(plan.isaret)
	_yaz(y, d)
	return d


static func kapanis(y: KoyYonetimi) -> Dictionary:
	var d := durum(y)
	if d.kisi < 0 and d.hukum.is_empty():
		return {"durum": "kayip", "hukum": 0, "hane": 0, "kapali": 0, "dedikodu": 0, "ekmek": 0, "yol": 0, "cenaze": 0}
	if int(d.gun) < preload("res://src/koy/zindan_ekmegi.gd").tavan() - 1:
		return {}
	return {
		"durum": "ok",
		"hukum": 1 if d.hukum != "" else 0,
		"hane": d.hane.size(),
		"kapali": 1 if int(d.kapali) >= 0 else 0,
		"dedikodu": int(d.dedikodu),
		"ekmek": int(d.ekmek),
		"yol": 1 if String(d.yol) != "" else 0,
		"cenaze": int(d.cenaze),
	}


static func _ambar(y: KoyYonetimi) -> int:
	return int(y.kaynaklar.miktar("gida"))


static func _cenaze_bir(y: KoyYonetimi) -> int:
	var d := durum(y)
	if int(d.cenaze) > 0:
		return int(d.cenaze)
	var rapor := {"olenler": [1], "olaylar": []}
	CenazeYasi.gece(y, rapor, [])
	return 1 if rapor.has("cenaze") else 0


static func _dedikodu(y: KoyYonetimi, kisi: int, tanik: String, anahtar: String) -> int:
	var defter: Dedikodu = y.get_meta(&"dedikodu_nesne") if y.has_meta(&"dedikodu_nesne") else null
	if defter == null:
		defter = Dedikodu.new()
		y.set_meta(&"dedikodu_nesne", defter)
	var sonuc := defter.sabah_notu("sabah-%d-%d" % [y.gun, kisi], y.gun, tanik, anahtar)
	return 1 if bool(sonuc.get("olur", false)) else int(durum(y).dedikodu)


static func toren_secenekleri() -> PackedStringArray:
	return PackedStringArray(["toplu_mezar", "toren"])
