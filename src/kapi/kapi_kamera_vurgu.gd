class_name KapiKameraVurgu
extends Node

## SAH-49..SAH-50: Kapıda konuşan kişi kadraj vurgusu ve heybe paneli görünürlük koruması.

const KAPI_VARSAYILAN_FOV := 32.0
const ASGARI_KAMERA_MESAFESI := 1.8


## SAH-49: Konuşan kişi kadrajdadır; bakış BUG-13 FOV sınırları içinde kalır.
static func kadraj_hesapla(model_pos: Vector3, model_boyu: float = 1.7) -> Vector3:
	# Modelin baş/yüz hizasına odaklanır
	return model_pos + Vector3(0, model_boyu * 0.85, 0)


static func kadrajda_mi(kamera: Camera3D, model_pos: Vector3) -> bool:
	if kamera == null:
		return true
	var odak := kadraj_hesapla(model_pos)
	var kamera_on := -kamera.global_transform.basis.z
	var hedefe := (odak - kamera.global_position).normalized()
	var aci := rad_to_deg(kamera_on.angle_to(hedefe))
	# Kamera yarı-açısı (FOV / 2) içinde mi?
	return aci <= (kamera.fov * 0.5)


## SAH-50: Vurgu heybe açıkken modeli örtmez; kamera paneli kapatacak kadar yaklaşmaz.
static func heybe_ile_mesafe_koru(kamera_mesafesi: float, heybe_acik: bool) -> float:
	if heybe_acik:
		return maxf(kamera_mesafesi, ASGARI_KAMERA_MESAFESI)
	return kamera_mesafesi


static func heybe_acikken_model_gorunur_mu(heybe_acik: bool, kamera_mesafesi: float) -> bool:
	if heybe_acik:
		return kamera_mesafesi >= ASGARI_KAMERA_MESAFESI
	return true
