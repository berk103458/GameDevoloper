## SRM-02, SRM-12: surum yalniz proje ayarindan okunur. Alinan sonlar OMR-47 dosyasindandir.
class_name SurumKimligi
extends RefCounted

const IZ_YOLU := "user://oyuncu_izi.cfg"
const IZ_BOLUM := "oyuncu_izi"
const IZ_ANAHTAR := "alinan_sonlar"


static func surum() -> String:
	return String(ProjectSettings.get_setting("application/config/version", ""))


static func pencere_adi() -> String:
	return String(ProjectSettings.get_setting("application/config/name", ""))


static func metin() -> String:
	var deger := surum()
	if deger.is_empty():
		return ""
	var kalip := TranslationServer.translate("arayuz.menu.surum")
	if kalip.is_empty() or kalip == "arayuz.menu.surum":
		return deger
	return kalip % deger


## Dosya yoksa veya liste yoksa satir 0. Ikinci iz dosyasi acmaz.
static func daha_once(yol: String = IZ_YOLU) -> PackedStringArray:
	var sonuc := PackedStringArray()
	if yol.is_empty() or not FileAccess.file_exists(yol):
		return sonuc
	var cfg := ConfigFile.new()
	if cfg.load(yol) != OK:
		return sonuc
	var ham: Variant = cfg.get_value(IZ_BOLUM, IZ_ANAHTAR, PackedStringArray())
	if ham is PackedStringArray:
		for ad in ham:
			var temiz := String(ad).strip_edges()
			if not temiz.is_empty():
				sonuc.append(temiz)
	elif ham is Array:
		for ad in ham:
			var temiz := String(ad).strip_edges()
			if not temiz.is_empty():
				sonuc.append(temiz)
	elif ham is String and not String(ham).strip_edges().is_empty():
		for parca in String(ham).split(",", false):
			var temiz := parca.strip_edges()
			if not temiz.is_empty():
				sonuc.append(temiz)
	return sonuc
