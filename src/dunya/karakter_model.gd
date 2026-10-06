## Yürüyebilen karakter: Meshy iskeletli modeli ve yürüme animasyonu. Duruşta ilk kare tutulur.
## Köyde ayrıca: sağ ele alet (BoneAttachment3D), iş salınımı, seçim çerçevesi ve uzaklıkta yarı hızda animasyon.
class_name KarakterModel
extends Node3D

const YURUME_HIZI := 1.9  # m/s (oyun temposu için gerçekten biraz hızlı)
## Animasyonun doğal yürüme hızı (m/s); oynatma hızı buna göre ölçeklenir.
const ANIM_HIZI := 1.35
const EL_KEMIGI := "RightHand"

var _oynatici: AnimationPlayer
var _anim: String = ""
var _iskelet: Skeleton3D
var _alet_pivot: Node3D
var _salinim: Tween
var _uzak := false
var _uzak_kare := 0


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
	var sk := model.find_children("*", "Skeleton3D", true, false)
	if not sk.is_empty():
		_iskelet = sk[0]


## Hedefe yürür (dünya konumu), yüzünü yürüdüğü yöne çevirir.
func yuru(hedef: Vector3) -> void:
	var fark := hedef - position
	fark.y = 0.0
	if fark.length() < 0.01:
		return
	look_at(position + fark, Vector3.UP, true)
	yurume_oynat(YURUME_HIZI)
	var t := create_tween()
	t.tween_property(self, "position", hedef, fark.length() / YURUME_HIZI)
	await t.finished
	if is_inside_tree():
		dur()


## Yürüme döngüsünü verilen hızla (m/s) oynatır; konumu çağıran taşır.
func yurume_oynat(hiz: float) -> void:
	if _oynatici == null:
		return
	if _oynatici.current_animation != _anim or not _oynatici.is_playing():
		_oynatici.play(_anim)
	_oynatici.speed_scale = hiz / ANIM_HIZI


## Durur: yürüme döngüsünün ilk karesi (ayakta duruş).
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


## Sağ ele Kenney aletini takar (`tool-axe`, `tool-hoe`, `tool-pickaxe`, `tool-hammer`, `tool-shovel`); "" söker.
func alet_tak(ad: String, boy: float = 0.85) -> void:
	if _alet_pivot != null:
		_alet_pivot.get_parent().queue_free()
		_alet_pivot = null
	if ad == "" or _iskelet == null or _iskelet.find_bone(EL_KEMIGI) < 0:
		return
	var ek := BoneAttachment3D.new()
	ek.bone_name = EL_KEMIGI
	_iskelet.add_child(ek)
	_alet_pivot = Node3D.new()
	ek.add_child(_alet_pivot)
	var alet := Dunya3B.esya(ad, boy)
	_alet_pivot.add_child(alet)
	# Kemik dünyası iskeletin ölçeğini taşır; alet gerçek metre boyunda kalsın diye ters ölçeklenir.
	var olcek := _iskelet.transform.basis.get_scale().x
	var ust := _iskelet.get_parent() as Node3D
	while ust != null and ust != self:
		olcek *= ust.scale.x
		ust = ust.get_parent() as Node3D
	_alet_pivot.scale = Vector3.ONE / maxf(olcek, 0.0001)
	# Sap ele, ağız yukarı-ileri: aletin tabanı (sap ucu) avuçtan biraz aşağıda.
	alet.position = Vector3(0, -boy * 0.25, 0)
	_alet_pivot.rotation_degrees = Vector3(90, 0, 0)


## İş salınımı: alet ve gövde ritmik iner kalkar. `acik` false durdurur.
func salla(acik: bool, ritim: float = 0.9) -> void:
	if _salinim != null:
		_salinim.kill()
		_salinim = null
	if _alet_pivot != null:
		_alet_pivot.rotation_degrees.x = 90.0
	if not acik:
		return
	dur()
	_salinim = create_tween().set_loops()
	if _alet_pivot != null:
		_salinim.tween_property(_alet_pivot, "rotation_degrees:x", 20.0, ritim * 0.55).set_trans(Tween.TRANS_SINE)
		_salinim.tween_property(_alet_pivot, "rotation_degrees:x", 120.0, ritim * 0.25).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		_salinim.tween_property(_alet_pivot, "rotation_degrees:x", 90.0, ritim * 0.2)
	else:
		_salinim.tween_property(self, "rotation_degrees:x", 6.0, ritim * 0.5)
		_salinim.tween_property(self, "rotation_degrees:x", 0.0, ritim * 0.5)


## Seçim çerçevesi (ters kabuk); `malzeme` null kaldırır.
func cerceve(malzeme: Material) -> void:
	for mi in find_children("*", "MeshInstance3D", true, false):
		(mi as MeshInstance3D).material_overlay = malzeme


## Kameradan uzaksa animasyon yarı hızda güncellenir (her iki karede bir, iki kat adım).
func uzak_ayarla(uzak: bool) -> void:
	if _oynatici == null or uzak == _uzak:
		return
	_uzak = uzak
	_oynatici.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL if uzak else AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_IDLE


func _process(delta: float) -> void:
	if _uzak and _oynatici != null:
		_uzak_kare += 1
		if _uzak_kare % 2 == 0:
			_oynatici.advance(delta * 2.0)
