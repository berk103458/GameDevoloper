# gdlint: disable=max-line-length
class_name Bakis
extends RefCounted

## DYL-02: Bakmak — konuşmadan süzmek.
## Yüz, eller, ayak ve çarık, giysi, yük, yanındakiler.
## Her bakış sabırdan 1 düşer; ışık yoksa ipucu ve gözlem gelmez.
## Aynı bölgeye ikinci bakış yeni bilgi üretmez.

var bakilan_bolgeler: Dictionary = {} # bolge -> sayac

func temizle() -> void:
	bakilan_bolgeler.clear()

func bak(bolge: String, bakis_verisi: Dictionary, baglam: Dictionary, motor: SozMotoru = null) -> Dictionary:
	var sonuc := {
		"bolge": bolge,
		"basarili": false,
		"satir": "",
		"ek_yorum": "",
		"ipucu": "",
		"tepki": ""
	}

	# Işık koşulu denetimi (BUG-25 / DYL-02)
	var isik_var: bool = bool(baglam.get("isik", true))
	if not isik_var:
		# Işık kapalıyken bölge düğmesi durur, gözlem satırı ve ipucu gelmez
		if motor:
			motor.sabir = maxi(motor.sabir - 1, 0)
		return {
			"bolge": bolge,
			"basarili": false,
			"satir": "Karanlıkta bir şey seçilmiyor.",
			"ipucu": "",
			"tepki": ""
		}

	# Sabır maliyeti: Her bakış sabırdan 1 düşer
	if motor:
		motor.sabir = maxi(motor.sabir - 1, 0)

	var tekrar_sayisi: int = int(bakilan_bolgeler.get(bolge, 0))
	bakilan_bolgeler[bolge] = tekrar_sayisi + 1

	var b_bilgi: Dictionary = bakis_verisi.get(bolge, {})
	if b_bilgi.is_empty():
		return sonuc

	# Aynı bölgeye ikinci bakış yeni bilgi vermez (Kural 6)
	if tekrar_sayisi > 0:
		var tepkiler: Array = b_bilgi.get("tepki", [])
		var t_satir: String = ""
		if not tepkiler.is_empty():
			t_satir = str(tepkiler[0])
		if motor:
			motor.guven = clampi(motor.guven - 1, 0, 10)
		return {
			"bolge": bolge,
			"basarili": true,
			"tekrar": true,
			"satir": "Daha önce baktın; değişen bir şey yok.",
			"ipucu": "",
			"tepki": t_satir
		}

	var satirlar: Array = b_bilgi.get("satirlar", [])
	if not satirlar.is_empty():
		sonuc["satir"] = str(satirlar[0])
		sonuc["basarili"] = true

	# İpucu üretimi (yalnızca ilk bakışta ve ışık varken)
	var ipucu = str(b_bilgi.get("ipucu", ""))
	if not ipucu.is_empty():
		sonuc["ipucu"] = ipucu

	# Tecrübe eşiği ek yorumu (Kural 3)
	var tecrube: int = int(baglam.get("tecrube", 0))
	var tecrube_esigi: int = int(b_bilgi.get("tecrube_esigi", 3))
	if tecrube >= tecrube_esigi and b_bilgi.has("ek_yorum"):
		sonuc["ek_yorum"] = str(b_bilgi.get("ek_yorum"))

	return sonuc
