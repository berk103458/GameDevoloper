# gdlint: disable=max-line-length
class_name Bakis
extends RefCounted

## DYL-02: Bakmak — konuşmadan süzmek.
## KOP-03: Hastalık, bakışın bir bölgesidir (yüz ve eller KRI-11 belirtilerini üretir).
## Yüz, eller, ayak ve çarık, giysi, yük, yanındakiler.
## Her bakış sabırdan 1 düşer; ışık yoksa ipucu ve gözlem gelmez.
## Aynı bölgeye ikinci bakış yeni bilgi üretmez.

const HASTALIK_TESHIS = preload("res://src/kapi/hastalik_teshis_adaptoru.gd")
const HASTALIK_BOLGELERI := ["yuz", "eller"]

var bakilan_bolgeler: Dictionary = {} # bolge -> sayac
var teshis_dugmesi_sayisi: int = 0 # KOP-03 Kural 2: ayrı teşhis düğmesi yoktur (0)

func temizle() -> void:
	bakilan_bolgeler.clear()

static func _isik_acik_mi(baglam: Dictionary) -> bool:
	if baglam.has("kosul") and baglam["kosul"] is Dictionary:
		var k: Dictionary = baglam["kosul"]
		if k.has("baglam") and k["baglam"] is Dictionary and k["baglam"].has("isik"):
			return bool(k["baglam"]["isik"])
	if baglam.has("baglam") and baglam["baglam"] is Dictionary and baglam["baglam"].has("isik"):
		return bool(baglam["baglam"]["isik"])
	return bool(baglam.get("isik", true))

func bak(bolge: String, bakis_verisi: Dictionary, baglam: Dictionary, motor: SozMotoru = null, gelen: Variant = null) -> Dictionary:
	var sonuc := {
		"bolge": bolge,
		"basarili": false,
		"satir": "",
		"ek_yorum": "",
		"ipucu": "",
		"enfeksiyon_ipucu": "",
		"tepki": "",
		"teshis_dugmesi": teshis_dugmesi_sayisi
	}

	var hedef_gelen: Variant = gelen if gelen != null else baglam.get("gelen", null)

	# Işık koşulu denetimi (BUG-25 / DYL-02 / KOP-03 Kural 3)
	var isik_var: bool = _isik_acik_mi(baglam)
	if not isik_var:
		# Işık kapalıyken bölge düğmesi durur, gözlem satırı ve ipucu gelmez
		if motor:
			motor.sabir = maxi(motor.sabir - 1, 0)
		return {
			"bolge": bolge,
			"basarili": false,
			"satir": "Karanlıkta bir şey seçilmiyor.",
			"ipucu": "",
			"enfeksiyon_ipucu": "",
			"tepki": "",
			"teshis_dugmesi": teshis_dugmesi_sayisi
		}

	# Sabır maliyeti: Her bakış sabırdan 1 düşer
	if motor:
		motor.sabir = maxi(motor.sabir - 1, 0)

	var tekrar_sayisi: int = int(bakilan_bolgeler.get(bolge, 0))
	bakilan_bolgeler[bolge] = tekrar_sayisi + 1

	var b_bilgi: Dictionary = bakis_verisi.get(bolge, {}) if bakis_verisi.get(bolge) is Dictionary else {}
	if b_bilgi.is_empty():
		return sonuc

	# Aynı bölgeye ikinci bakış yeni bilgi/belirti vermez (DYL-02 Kural 6 / KOP-03 Uç durumlar)
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
			"enfeksiyon_ipucu": "",
			"tepki": t_satir,
			"teshis_dugmesi": teshis_dugmesi_sayisi
		}

	var satirlar: Array = b_bilgi.get("satirlar", [])
	if not satirlar.is_empty():
		sonuc["satir"] = str(satirlar[0])
		sonuc["basarili"] = true

	# İpucu üretimi (yalnızca ilk bakışta ve ışık varken)
	var ipucu := str(b_bilgi.get("ipucu", ""))

	# KOP-03: Yüz ve eller bölgesi KRI-11 belirtilerini üretir (ateş, kanlı öksürük, irin).
	# Belirti satırı yokken enfeksiyon ipucu yazılmaz.
	if bolge in HASTALIK_BOLGELERI:
		var enf_ipucu := HASTALIK_TESHIS.bakis_belirtisi_isle(hedef_gelen, bolge, b_bilgi, str(sonuc["satir"]), isik_var)
		if not enf_ipucu.is_empty():
			sonuc["enfeksiyon_ipucu"] = enf_ipucu
			if ipucu.is_empty():
				ipucu = enf_ipucu
		elif ipucu.begins_with("Clue_Enfeksiyon_"):
			# Belirti satırı yokken enfeksiyon ipucu yazılmaz (KOP-03 Kural 3)
			ipucu = ""

	if not ipucu.is_empty():
		sonuc["ipucu"] = ipucu

	# Tecrübe eşiği ek yorumu (Kural 3)
	var tecrube: int = int(baglam.get("tecrube", 0))
	var tecrube_esigi: int = int(b_bilgi.get("tecrube_esigi", 3))
	if tecrube >= tecrube_esigi and b_bilgi.has("ek_yorum"):
		sonuc["ek_yorum"] = str(b_bilgi.get("ek_yorum"))

	return sonuc
