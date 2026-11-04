## GIR-13: sol çubuk köy imlecini kaydırır. Yakınlaşma tekerlek eylemindedir.
class_name KoyCubukImleci
extends RefCounted


## Bağlı gamepad yoksa sıfır döner; aygıt aranmaz.
static func sapma() -> Vector2:
	var bagli := Input.get_connected_joypads()
	if bagli.is_empty():
		return Vector2.ZERO
	var cubuk := GirdiEylemleri.cubuk_ayari()
	if not cubuk.has("eksen_x") or not cubuk.has("eksen_y"):
		return Vector2.ZERO
	var cihaz := int(bagli[0])
	var v := Vector2(
		Input.get_joy_axis(cihaz, int(cubuk["eksen_x"])),
		Input.get_joy_axis(cihaz, int(cubuk["eksen_y"]))
	)
	if v.length() < float(cubuk.get("olu_bolge", 0.25)):
		return Vector2.ZERO
	return v


## Sapmayı ekran ofsetine çevirir. Yakınlaşma çağırmaz.
static func hedef(merkez: Vector2, sapma: Vector2) -> Vector2:
	var olcek := float(GirdiEylemleri.cubuk_ayari().get("olcek", 220.0))
	return merkez + sapma * olcek


## Çubuk sapması yakınlaşma sayısını artırmaz.
static func yakinlas_cagrilir(_sapma: Vector2) -> bool:
	return false
