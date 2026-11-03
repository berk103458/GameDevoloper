# gdlint: disable=max-line-length
class_name Yemin
extends RefCounted

## DYL-03: Yemin ettirmek.
## Ziyaret başına bir kez kullanılır. Dört tutum: eder, kivranir, rahat, reddeder.
## İnanç alanı boşsa yemin seçeneği gizlenir. Yemin zar açmaz.

var yemin_edildi: bool = false
var ceza_yazildi: bool = false

func temizle() -> void:
	yemin_edildi = false
	ceza_yazildi = false

func yemin_uygun_mu(karakter_verisi: Dictionary) -> bool:
	if yemin_edildi:
		return false
	var inanc: String = str(karakter_verisi.get("inanc", "")).strip_edges()
	if inanc.is_empty():
		return false
	return true

func yemin_et(karakter_verisi: Dictionary, baglam: Dictionary = {}, motor: SozMotoru = null) -> Dictionary:
	if yemin_edildi:
		return {"basarili": false, "sebep": "ikinci_yemin_yasak"}

	var inanc: String = str(karakter_verisi.get("inanc", "")).strip_edges()
	if inanc.is_empty():
		return {"basarili": false, "sebep": "inanc_alani_bos"}

	yemin_edildi = true

	# Tansiyon 1 artar (Kural 5)
	var tansiyon_artisi: int = 1
	var guven_azalisi: int = 0
	if karakter_verisi.get("saygin", false):
		guven_azalisi = 2

	if motor:
		motor.guven = clampi(motor.guven - guven_azalisi, 0, 10)

	var yemin_bilgisi: Dictionary = karakter_verisi.get("yemin", {})
	var tutum: String = str(yemin_bilgisi.get("tutum", "eder"))
	var satirlar: Array = yemin_bilgisi.get("satirlar", [])
	var metin: String = satirlar[0] if not satirlar.is_empty() else ""

	var sonuc := {
		"basarili": true,
		"tutum": tutum,
		"metin": metin,
		"ipucu": "",
		"yalan_yemin": false,
		"zar_atisi": false, # Yemin satırı zar atışı açmaz (Kabul)
		"tansiyon_artisi": tansiyon_artisi,
		"guven_azalisi": guven_azalisi
	}

	match tutum:
		"eder":
			# Dürüst kişi hemen eder
			pass
		"kivranir":
			# İnançlı yalancı kaçamak cevap verir; ipucu oluşur
			sonuc["ipucu"] = "yemin_kacamak"
		"rahat":
			# İnançsız yalancı rahatça yemin eder; yalan yemin bayrağı gizli düşer
			sonuc["yalan_yemin"] = true
		"reddeder":
			# İnancı izin vermeyen gerekçeyle reddeder; yalan veya kaçamak yazmaz
			pass

	return sonuc

func bozulma_cezasi_uygula(terazi: Dictionary) -> bool:
	# Bozulan yemin yalnız 1 kez ceza yazar
	if ceza_yazildi:
		return false
	ceza_yazildi = true
	terazi["yalan_yemin_edeni_aldi"] = true
	return true
