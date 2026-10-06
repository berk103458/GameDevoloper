## Köy meydanı: ortadaki ateş ve çevresindeki sohbet yuvaları (Marker3D). Akşam iş bitince köylüler
## buraya gelir, ateşe dönük oturur. Ateş köyün tek gölge düşüren ışığıdır; çıtırtısı 3B ses olarak duyulur.
class_name MeydanAlani
extends Node3D

var _yuvalar: Array[Marker3D] = []
## yuva indeksi -> KoyluAI
var _dolu: Dictionary = {}
var _isik: OmniLight3D
var _alevler: Array[MeshInstance3D] = []
var _zaman := 0.0


## Meydanı yerleşimdeki yuvalarla kurar.
func kur(y: KoyYerlesimi) -> void:
	position = KoyYerlesimi.MEYDAN
	for i in y.meydan_yuvalari.size():
		var m := Marker3D.new()
		m.name = "Yuva%d" % i
		m.position = y.meydan_yuvalari[i] - KoyYerlesimi.MEYDAN
		add_child(m)
		_yuvalar.append(m)
	var ates := Dunya3B.esya("campfire-pit", 0.55)
	ates.scale = Vector3.ONE * 1.6
	add_child(ates)
	for mi in ates.find_children("*", "MeshInstance3D", true, false):
		(mi as MeshInstance3D).cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Renkler.MESALE
	mat.emission_enabled = true
	mat.emission = Renkler.MESALE
	mat.emission_energy_multiplier = 4.0
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	for i in 3:
		var a := MeshInstance3D.new()
		var k := SphereMesh.new()
		k.radius = 0.22 - i * 0.05
		k.height = 0.9 - i * 0.2
		a.mesh = k
		a.material_override = mat
		a.position = Vector3((i - 1) * 0.12, 0.45 + i * 0.08, (i % 2) * 0.1)
		a.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		add_child(a)
		_alevler.append(a)
	var kivilcim := CPUParticles3D.new()
	kivilcim.amount = 24
	kivilcim.lifetime = 1.6
	kivilcim.position.y = 0.7
	kivilcim.direction = Vector3.UP
	kivilcim.spread = 25.0
	kivilcim.initial_velocity_min = 0.8
	kivilcim.initial_velocity_max = 1.8
	kivilcim.gravity = Vector3(0, 0.3, 0)
	kivilcim.scale_amount_min = 0.03
	kivilcim.scale_amount_max = 0.06
	var km := SphereMesh.new()
	km.radius = 0.5
	km.height = 1.0
	km.radial_segments = 4
	km.rings = 2
	km.material = mat
	kivilcim.mesh = km
	add_child(kivilcim)
	_isik = OmniLight3D.new()
	_isik.light_color = Renkler.MESALE
	_isik.light_energy = 3.2
	_isik.omni_range = 13.0
	_isik.shadow_enabled = true
	_isik.position.y = 1.5
	add_child(_isik)
	var ses := AudioStreamPlayer3D.new()
	var yol := "res://assets/ses/ortam_mesale_dongu.wav"
	if ResourceLoader.exists(yol):
		var akis := load(yol) as AudioStreamWAV
		if akis != null:
			akis = akis.duplicate() as AudioStreamWAV
			akis.loop_mode = AudioStreamWAV.LOOP_FORWARD
			akis.loop_begin = 0
			akis.loop_end = int(akis.get_length() * akis.mix_rate)
			ses.stream = akis
			ses.bus = &"Efekt"
			ses.unit_size = 6.0
			ses.volume_db = -4.0
			ses.autoplay = true
	add_child(ses)


## Boş yuva verir (dünya konumu); hepsi doluysa meydanın dış halkasında bir yer.
func yuva_al(ai: KoyluAI) -> Vector3:
	for i in _dolu:
		if _dolu[i] == ai:
			return _yuvalar[i].global_position if _yuvalar[i].is_inside_tree() else _yuvalar[i].position + position
	for i in _yuvalar.size():
		if not _dolu.has(i):
			_dolu[i] = ai
			return _yuvalar[i].position + position
	var a := ai.sira * 2.39996
	return position + Vector3(sin(a), 0, cos(a)) * (4.6 + (ai.sira % 3) * 0.7)


func yuva_birak(ai: KoyluAI) -> void:
	for i in _dolu.keys():
		if _dolu[i] == ai:
			_dolu.erase(i)


func _process(delta: float) -> void:
	_zaman += delta
	if _isik != null:
		_isik.light_energy = 3.2 * (0.82 + 0.18 * sin(_zaman * 9.0) * sin(_zaman * 3.3))
	for i in _alevler.size():
		var s := 1.0 + 0.15 * sin(_zaman * (11.0 + i * 3.0) + i)
		_alevler[i].scale = Vector3(1.0 / s, s, 1.0 / s)
