## Yürüyebilen karakter: Meshy iskeletli modeli ve yürüme animasyonu. Duruşta animasyon yavaş döner (nefes).
class_name KarakterModel
extends Node3D

const YURUME_HIZI := 1.9  # m/s (oyun temposu için gerçekten biraz hızlı)

var _oynatici: AnimationPlayer
var _anim: String = ""


func kur(model: Node3D) -> void:
	if model == null:
		var m := MeshInstance3D.new()
		var c := CapsuleMesh.new()
		c.radius = 0.28
		c.height = 1.7
		m.mesh = c
		m.position.y = 0.85
		m.material_override = Dunya3B.duz_malzeme(Renkler.SOGUK_MAVI)
		add_child(m)
		return
	add_child(model)
	var ap := model.find_children("*", "AnimationPlayer", true, false)
	if not ap.is_empty():
		_oynatici = ap[0]
		_anim = _oynatici.get_animation_list()[0]
		_oynatici.get_animation(_anim).loop_mode = Animation.LOOP_LINEAR
		dur()


## Hedefe yürür (dünya konumu), yüzünü yürüdüğü yöne çevirir.
func yuru(hedef: Vector3) -> void:
	var fark := hedef - position
	fark.y = 0.0
	if fark.length() < 0.01:
		return
	look_at(position + fark, Vector3.UP, true)
	if _oynatici != null:
		_oynatici.play(_anim)
		_oynatici.speed_scale = YURUME_HIZI / 1.35
	var t := create_tween()
	t.tween_property(self, "position", hedef, fark.length() / YURUME_HIZI)
	await t.finished
	if is_inside_tree():
		dur()


## Durur: yürüme döngüsü çok yavaş oynar (yerinde kıpırtı).
func dur() -> void:
	if _oynatici != null:
		_oynatici.play(_anim)
		_oynatici.seek(0.0, true)
		_oynatici.speed_scale = 0.0


## Bir noktaya döner (Y ekseninde).
func bak(nokta: Vector3) -> void:
	var f := nokta - position
	f.y = 0.0
	if f.length() > 0.01:
		look_at(position + f, Vector3.UP, true)
