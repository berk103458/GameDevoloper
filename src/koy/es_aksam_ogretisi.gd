## OGR-39: Eş, akşam sohbetinde gün içinde kullanılmayan aracı tek cümleyle anar.
## Dal DIY-09 satır seçicisindedir. Kullanım OGR-42 kancasının ilk kayıt günüdür; ikinci sayaç yoktur.
class_name EsAksamOgretisi
extends RefCounted

const VERI_YOLU := "res://data/soz/es_aksam_ogretisi.json"
const KANCA = preload("res://src/debug/ilk_saat_kancasi.gd")

static var _dallar: Array = []


## Seçilen sohbete en çok bir öğreti cümlesi ekler. Araç kullanıldıysa ya da gün aralığı dışındaysa dal 0 kalır.
static func ekle(o: Oturum, sohbet: Dictionary) -> Dictionary:
	sohbet["ogreti_dal"] = 0
	sohbet["ogreti_anahtar"] = ""
	var dal := _sec(o)
	if dal.is_empty():
		return sohbet
	var anahtar := String(dal.get("metin_anahtari", "")).strip_edges()
	var cumle := _cumle(anahtar)
	if cumle.is_empty() or not _tek_cumle_mi(cumle):
		return sohbet
	var replikler: Array = sohbet.get("es_replikleri", [])
	replikler.append(cumle)
	sohbet["es_replikleri"] = replikler
	sohbet["ogreti_dal"] = 1
	sohbet["ogreti_anahtar"] = anahtar
	return sohbet


static func _sec(o: Oturum) -> Dictionary:
	var dallar := _dal_listesi()
	if dallar.is_empty():
		return {}
	return SatirSecici.new().sec(dallar, _baglam(o, dallar))


## Oyuncu günü, akşam sohbeti gece artmadan önceki gündür (`oturum.gun + 1`).
## Kanca ilk kullanımı yazar; kayıt o güne ya da daha eskiye düşmüşse araç kullanılmış sayılır.
static func _baglam(o: Oturum, dallar: Array) -> Dictionary:
	var araclar: Dictionary = KANCA.araclar(o) if o != null else {}
	var baglam := {"gun": (o.gun + 1) if o != null else 0}
	for ham in dallar:
		if not ham is Dictionary:
			continue
		var kosul: Variant = ham.get("kosullar", {})
		if not kosul is Dictionary:
			continue
		for anahtar in (kosul as Dictionary).keys():
			var ad := String(anahtar)
			if not ad.ends_with("_kullanildi"):
				continue
			var id := ad.trim_suffix("_kullanildi")
			var ilk := int(araclar.get(id, -1))
			baglam[ad] = o != null and ilk >= 0 and ilk <= o.gun
	return baglam


static func _dal_listesi() -> Array:
	if not _dallar.is_empty():
		return _dallar
	if not FileAccess.file_exists(VERI_YOLU):
		return []
	var okunan: Variant = JSON.parse_string(FileAccess.get_file_as_string(VERI_YOLU))
	if okunan is Dictionary and (okunan as Dictionary).get("dallar") is Array:
		_dallar = (okunan as Dictionary).get("dallar")
	return _dallar


static func _cumle(anahtar: String) -> String:
	if anahtar.is_empty() or not GuvenliMetin.anahtar_gibi_mi(anahtar):
		return ""
	var ceviri := String(TranslationServer.translate(anahtar)).strip_edges()
	if ceviri.is_empty() or ceviri == anahtar:
		ceviri = GuvenliMetin.metin(anahtar).strip_edges()
	if ceviri.is_empty() or ceviri == anahtar or ceviri.begins_with(GuvenliMetin.YOK):
		return ""
	return ceviri


static func _tek_cumle_mi(metin: String) -> bool:
	var bitis := 0
	for isaret in [".", "!", "?"]:
		bitis += metin.count(isaret)
	return bitis == 1
