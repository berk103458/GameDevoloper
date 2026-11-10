## YIL-01 … YIL-10: yılın yüzü. Cümle yazılmaz; anahtar ve kart adı okunur.
## Mevsim motoruna, üretime, suya ve son kimliğine yazılmaz.
class_name YilIzi
extends RefCounted

const META := &"yil_izi"
const DOSYA := "res://data/soz/yil_izi.json"

static func _ayar() -> Dictionary:
	var veri = JSON.parse_string(FileAccess.get_file_as_string(DOSYA))
	return veri if veri is Dictionary else {}


static func anahtar(ad: String) -> String:
	var tablo: Dictionary = _ayar().get("anahtarlar", {})
	return String(tablo.get(ad, ""))


static func bos() -> Dictionary:
	return {"kisi": "", "slotlar": {}, "duyulan": [], "sayilan": {}, "ad_bayragi": false, "maske": "", "gercek": ""}


static func oku(v: Variant) -> Dictionary:
	var d := bos()
	if not v is Dictionary:
		return d
	if v.get("kisi") is String:
		d.kisi = String(v.kisi)
	if v.get("slotlar") is Dictionary:
		d.slotlar = v.slotlar.duplicate(true)
	if v.get("duyulan") is Array:
		d.duyulan = v.duyulan.duplicate()
	if v.get("sayilan") is Dictionary:
		d.sayilan = v.sayilan.duplicate(true)
	if v.get("ad_bayragi") is bool:
		d.ad_bayragi = v.ad_bayragi
	if v.get("maske") is String:
		d.maske = String(v.maske)
	if v.get("gercek") is String:
		d.gercek = String(v.gercek)
	return d


static func durum(y: KoyYonetimi) -> Dictionary:
	return oku(y.get_meta(META, {}))


static func _yaz(y: KoyYonetimi, d: Dictionary) -> void:
	y.set_meta(META, d)


static func uretim_oku(deger: int) -> int:
	return deger


static func takvim(y: KoyYonetimi) -> Dictionary:
	return MevsimYoneticisi.durum(y)


static func _adli(k: Koylu) -> bool:
	return k != null and k.saglik > 0 and String(k.adli_id) != ""


static func sec(y: KoyYonetimi, tohum: int) -> String:
	var d := durum(y)
	if d.kisi != "":
		return d.kisi
	var tarla: Array[Koylu] = []
	var diger: Array[Koylu] = []
	for k in y.koylular:
		if not _adli(k):
			continue
		if YilIziGecesi.tarlada(y, k):
			tarla.append(k)
		else:
			diger.append(k)
	var havuz: Array[Koylu] = tarla if not tarla.is_empty() else diger
	if havuz.is_empty():
		return ""
	havuz.sort_custom(func(a: Koylu, b: Koylu) -> bool: return a.id < b.id)
	var secilen: Koylu = havuz[absi(tohum) % havuz.size()]
	d.kisi = String(secilen.adli_id)
	for ad in ["guz", "kis", "ilkbahar", "yaz"]:
		d.slotlar[ad] = d.kisi
	_yaz(y, d)
	return d.kisi


static func gorunen_ad(y: KoyYonetimi) -> String:
	var d := durum(y)
	return d.gercek if d.ad_bayragi and d.gercek != "" else d.maske


static func ad_ac(y: KoyYonetimi, acik: bool) -> void:
	var d := durum(y)
	d.ad_bayragi = acik
	_yaz(y, d)


static func _kisi_sag(y: KoyYonetimi) -> bool:
	var kim := String(durum(y).kisi)
	if kim == "":
		return false
	for k in y.koylular:
		if String(k.adli_id) == kim and k.saglik > 0:
			return true
	return false


static func satir(y: KoyYonetimi, baglam: Dictionary = {}) -> Dictionary:
	var d := durum(y)
	var tak := takvim(y)
	var ad := String(tak.get("ad", ""))
	var ana := ""
	var bos := {"anahtar": "", "ad": "", "moral_delta": 0}
	if d.kisi == "" or not _kisi_sag(y):
		return bos
	if bool(baglam.get("bos_gun", false)):
		return bos
	if ad == "sonbahar":
		if bool(baglam.get("senlik", false)) and bool(baglam.get("ambar_dolu", false)):
			ana = "guz_sofra"
		elif not bool(baglam.get("senlik", false)):
			ana = "guz_harman"
	elif ad == "kis":
		if bool(baglam.get("tarla", false)):
			return bos
		ana = "kis_ev" if bool(baglam.get("yatak", false)) else "kis_disari"
	elif ad == "ilkbahar":
		if bool(baglam.get("taskin", false)):
			ana = "ilkbahar_taskin"
		else:
			ana = "ilkbahar_tarla"
	elif ad == "yaz":
		ana = "yaz_su"
	var metin := anahtar(ana)
	if metin.is_empty():
		return bos
	var gecmis: Variant = d.slotlar.get(ad + "_satir", {})
	if gecmis is Dictionary and String(gecmis.get("anahtar", "")) == metin:
		return gecmis
	if gecmis is Dictionary and String(gecmis.get("slot", "")) != "" and String(gecmis.slot) in d.duyulan and String(gecmis.slot) != ana:
		d.duyulan.erase(gecmis.slot)
	var satir := {"anahtar": metin, "ad": gorunen_ad(y), "moral_delta": 0, "slot": ana}
	d.slotlar[ad + "_satir"] = satir
	if ana not in d.duyulan:
		d.duyulan.append(ana)
	_yaz(y, d)
	return satir


static func kapanis(y: KoyYonetimi, sys20: String) -> Dictionary:
	var d := durum(y)
	var tak := takvim(y)
	var gun := int(tak.get("yil_gunu", 0))
	var uzun := int(tak.get("yil_uzunlugu", 28))
	if gun != uzun:
		return {"sayi": -1, "sys20": sys20}
	var anahtar := "%s:%s" % [tak.get("yil", 0), gun]
	if d.sayilan.has(anahtar):
		return {"sayi": int(d.sayilan[anahtar]), "sys20": sys20}
	var sayi := mini(5, d.duyulan.size())
	d.sayilan[anahtar] = sayi
	d.kisi = ""
	d.slotlar = {}
	d.duyulan = []
	_yaz(y, d)
	return {"sayi": sayi, "sys20": sys20}
