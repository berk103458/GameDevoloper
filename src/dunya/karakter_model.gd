## Yürüyebilen karakter: Meshy iskeletli modeli, yürüme animasyonu ve durma animasyonu.
## Durma: dinlenme pozundan kurulan "bekle" animasyonu + DurusDuzeltici (nefes, ağırlık aktarma, bakış).
## DurusDuzeltici her iki durumda da kolları indirir, bileği düzeltir ve avucu bacağa çevirir.
class_name KarakterModel
extends Node3D

const YURUME_HIZI := 1.9  # m/s (oyun temposu için gerçekten biraz hızlı)
const BEKLE := "bekle"
## Yürüme ile durma arasındaki karışım süresi (s).
const GECIS := 0.3

var _oynatici: AnimationPlayer
var _anim: String = ""
var _duzeltici: DurusDuzeltici
var _bekleme_hedef := 1.0


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
	if ap.is_empty():
		return
	_oynatici = ap[0]
	_anim = _oynatici.get_animation_list()[0]
	_oynatici.get_animation(_anim).loop_mode = Animation.LOOP_LINEAR
	var sk := model.find_children("*", "Skeleton3D", true, false)
	if not sk.is_empty():
		_bekle_animasyonu_kur(sk[0] as Skeleton3D)
		_duzeltici = DurusDuzeltici.new()
		_duzeltici.faz = randf() * 20.0
		_duzeltici.bekleme = 1.0
		sk[0].add_child(_duzeltici)
	dur()


func _process(delta: float) -> void:
	if _duzeltici != null:
		_duzeltici.bekleme = move_toward(_duzeltici.bekleme, _bekleme_hedef, delta / GECIS)


## Hedefe yürür (dünya konumu), yüzünü yürüdüğü yöne çevirir.
func yuru(hedef: Vector3, hiz: float = YURUME_HIZI) -> void:
	var fark := hedef - position
	fark.y = 0.0
	if fark.length() < 0.01:
		return
	look_at(position + fark, Vector3.UP, true)
	if _oynatici != null:
		_oynatici.play(_anim, GECIS)
		_oynatici.speed_scale = hiz / 1.35
	_bekleme_hedef = 0.0
	var t := create_tween()
	t.tween_property(self, "position", hedef, fark.length() / hiz)
	await t.finished
	if is_inside_tree():
		dur()


## Durur: "bekle" animasyonuna yumuşak geçiş; nefes ve kıpırtıyı DurusDuzeltici verir.
func dur() -> void:
	_bekleme_hedef = 1.0
	if _oynatici == null:
		return
	_oynatici.speed_scale = 1.0
	if _oynatici.has_animation(BEKLE):
		_oynatici.play(BEKLE, GECIS)
	else:
		_oynatici.play(_anim)
		_oynatici.seek(0.0, true)
		_oynatici.speed_scale = 0.0


## Sürekli iş hareketini açar/kapatır (&"calis" ya da &"").
func calis(ad: StringName) -> void:
	if _duzeltici != null:
		_duzeltici.surekli = ad
		if ad == &"":
			_duzeltici.duygu = &""


## Anlık duygu hareketi (&"sevinc" / &"ofke"); süresi kadar bekler.
func duygu(ad: StringName) -> void:
	if _duzeltici == null:
		return
	_duzeltici.duygu_baslat(ad)
	await get_tree().create_timer(_duzeltici.duygu_suresi * 0.8).timeout


## Bir noktaya döner (Y ekseninde).
func bak(nokta: Vector3) -> void:
	var f := nokta - position
	f.y = 0.0
	if f.length() > 0.01:
		look_at(position + f, Vector3.UP, true)


## Yürüme animasyonunun izlerini kullanarak dinlenme pozunda duran döngülü "bekle" animasyonu kurar.
## Aynı modelin kopyaları kitaplığı paylaşır; bir kez kurulur.
func _bekle_animasyonu_kur(sk: Skeleton3D) -> void:
	if _oynatici.has_animation(BEKLE):
		return
	var yuru_anim := _oynatici.get_animation(_anim)
	var a := Animation.new()
	a.length = 2.0
	a.loop_mode = Animation.LOOP_LINEAR
	for i in yuru_anim.get_track_count():
		var tur := yuru_anim.track_get_type(i)
		if tur != Animation.TYPE_ROTATION_3D and tur != Animation.TYPE_POSITION_3D:
			continue
		var yol := yuru_anim.track_get_path(i)
		var kemik := sk.find_bone(String(yol.get_concatenated_subnames()))
		if kemik < 0:
			continue
		var dinlenme := sk.get_bone_rest(kemik)
		var iz := a.add_track(tur)
		a.track_set_path(iz, yol)
		if tur == Animation.TYPE_ROTATION_3D:
			a.rotation_track_insert_key(iz, 0.0, dinlenme.basis.get_rotation_quaternion())
		else:
			a.position_track_insert_key(iz, 0.0, dinlenme.origin)
	var kitap := _oynatici.get_animation_library(&"")
	if kitap == null:
		kitap = AnimationLibrary.new()
		_oynatici.add_animation_library(&"", kitap)
	kitap.add_animation(BEKLE, a)
