## Sert adımlı hareket (sanat kitabı 7.7): ara kare karışımı yok, 12 fps adımlar.
class_name Adim
extends RefCounted

const KARE_SN := 1.0 / 12.0


## Düğümü `hedef` konuma `adim_sayisi` sert adımda taşır; yürüyüşte her adımda hafif sekme.
static func yuru(dugum: CanvasItem, hedef: Vector2, adim_sayisi: int, sekme: float = 0.0) -> void:
	if not is_instance_valid(dugum):
		return
	var bas: Vector2 = dugum.position
	for i in range(1, adim_sayisi + 1):
		if not is_instance_valid(dugum) or not dugum.is_inside_tree():
			return
		var p := bas.lerp(hedef, float(i) / adim_sayisi)
		if sekme != 0.0 and i < adim_sayisi:
			p.y -= sekme if i % 2 == 1 else 0.0
		dugum.position = p.round()
		await dugum.get_tree().create_timer(KARE_SN * 2.0).timeout
	if is_instance_valid(dugum):
		dugum.position = hedef


## Gece rengine kesme: `sure` saniye boyunca tam ekran örtü.
static func kesme(ust: Node, sure: float = 0.25) -> void:
	var ortu := ColorRect.new()
	ortu.color = Renkler.GECE
	ortu.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	ortu.mouse_filter = Control.MOUSE_FILTER_STOP
	ust.add_child(ortu)
	await ust.get_tree().create_timer(sure).timeout
	ortu.queue_free()
