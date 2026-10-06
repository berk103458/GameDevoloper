## Köy hayvanları (tavuk, köpek): yuvasının çevresinde gezinir, durup eşelenir. Köpek ara sıra bir
## köylünün peşine takılır. Modeller Kenney "Cube Pets" (CC0), kendi yürüme/boş/yeme animasyonlarıyla.
class_name HayvanAI
extends Node3D

const HAYVAN_KOK := "res://assets/kenney/hayvan/"

var tur := "chick"
var yuva := Vector3.ZERO
var yaricap := 4.0
var hiz := 0.8
## Köpeğin peşine takılabileceği köylüler.
var koyluler: Array[KoyluAI] = []

var _oynatici: AnimationPlayer
var _hedef := Vector3.ZERO
var _bekle := 0.0
var _takip: KoyluAI
var _rng := RandomNumberGenerator.new()


## Hayvanı kurar: `tur` Kenney adı (chick, dog), `boy` metre.
func kur(tur_: String, boy: float, yuva_: Vector3, tohum: int) -> void:
	tur = tur_
	yuva = yuva_
	_rng.seed = tohum
	position = yuva + Vector3(_rng.randf_range(-2, 2), 0, _rng.randf_range(-2, 2))
	var yol := HAYVAN_KOK + "animal-%s.glb" % tur
	if not ResourceLoader.exists(yol):
		return
	var kap := Node3D.new()
	add_child(kap)
	var n: Node3D = (load(yol) as PackedScene).instantiate()
	kap.add_child(n)
	var kutu := AABB()
	var ilk := true
	for mi in n.find_children("*", "MeshInstance3D", true, false):
		var a := (mi as MeshInstance3D).get_aabb()
		kutu = a if ilk else kutu.merge(a)
		ilk = false
	if kutu.size.y > 0.001:
		n.scale = Vector3.ONE * (boy / kutu.size.y)
	var ap := n.find_children("*", "AnimationPlayer", true, false)
	if not ap.is_empty():
		_oynatici = ap[0]
		for ad in ["walk", "idle", "eat", "run"]:
			if _oynatici.has_animation(ad):
				_oynatici.get_animation(ad).loop_mode = Animation.LOOP_LINEAR
	_bekle = _rng.randf_range(0.0, 2.0)
	_oynat("idle")


func _process(delta: float) -> void:
	if _takip != null and is_instance_valid(_takip) and _takip.govde.visible:
		_hedef = _takip.govde.position + Vector3(0.9, 0, -0.9)
		if position.distance_to(_hedef) < 1.2:
			_oynat("idle")
			if _rng.randf() < delta * 0.08:
				_takip = null
			return
		_yuru(delta, hiz * 1.6)
		return
	if _bekle > 0.0:
		_bekle -= delta
		if _bekle <= 0.0:
			_yeni_hedef()
		return
	if position.distance_to(_hedef) < 0.15:
		_bekle = _rng.randf_range(1.5, 5.0)
		_oynat("eat" if _rng.randf() < 0.6 else "idle")
		return
	_yuru(delta, hiz)


func _yuru(delta: float, h: float) -> void:
	var fark := _hedef - position
	fark.y = 0.0
	var yon := fark.normalized()
	position += yon * minf(h * delta, fark.length())
	rotation.y = lerp_angle(rotation.y, atan2(yon.x, yon.z), clampf(delta * 6.0, 0.0, 1.0))
	_oynat("walk" if h < 1.5 else "run")


func _yeni_hedef() -> void:
	if tur == "dog" and not koyluler.is_empty() and _rng.randf() < 0.35:
		_takip = koyluler[_rng.randi_range(0, koyluler.size() - 1)]
		return
	var a := _rng.randf() * TAU
	_hedef = yuva + Vector3(sin(a), 0, cos(a)) * _rng.randf_range(0.5, yaricap)


func _oynat(ad: String) -> void:
	if _oynatici != null and _oynatici.has_animation(ad) and _oynatici.current_animation != ad:
		_oynatici.play(ad, 0.2)
