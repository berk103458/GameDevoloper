## Mevcut yürüyüş pozuna yalnız omurga ve üst gövde konuşma izlerini ekler.
class_name KoyKonusmaKatmani
extends SkeletonModifier3D

const DUGUM_ADI := &"KoyKonusmaKatmani"

var _klip: Animation
var _izler: Dictionary[int, int] = {}
var _gecerli: Callable
var _gecis: Tween
var _oturum := 0
var _zaman := 0.0


static func oynat(figur: KarakterModel, oturum: int, sure: float, gecerli: Callable) -> void:
	if not figur.hareket_var("konus"):
		return
	var iskeletler := figur.find_children("*", "Skeleton3D", true, false)
	if iskeletler.is_empty():
		return
	var iskelet := iskeletler[0] as Skeleton3D
	var katman := iskelet.get_node_or_null(NodePath(DUGUM_ADI)) as KoyKonusmaKatmani
	if katman == null:
		katman = KoyKonusmaKatmani.new()
		katman.name = DUGUM_ADI
		katman.active = false
		katman.influence = 0.0
		katman._klip = figur._oynatici.get_animation(StringName(figur._klipler["konus"]))
		katman._izleri_kur(iskelet)
		if katman._izler.is_empty():
			katman.free()
			return
		iskelet.add_child(katman)
	katman._baslat(oturum, sure, gecerli)


static func durdur(figur: KarakterModel, oturum: int) -> void:
	if not is_instance_valid(figur):
		return
	var katman := figur.find_child(String(DUGUM_ADI), true, false) as KoyKonusmaKatmani
	if katman != null and katman._oturum == oturum:
		if katman._gecis != null:
			katman._gecis.kill()
		katman._kapat()


func _izleri_kur(iskelet: Skeleton3D) -> void:
	for i in _klip.get_track_count():
		if _klip.track_get_type(i) != Animation.TYPE_ROTATION_3D or not _klip.track_is_enabled(i):
			continue
		var yol := _klip.track_get_path(i)
		if yol.get_subname_count() != 1:
			continue
		var kemik := iskelet.find_bone(yol.get_subname(0))
		var ata := kemik
		while ata >= 0 and not iskelet.get_bone_name(ata).to_lower().begins_with("spine"):
			ata = iskelet.get_bone_parent(ata)
		if ata >= 0:
			_izler[kemik] = i


func _baslat(oturum: int, sure: float, gecerli: Callable) -> void:
	if _gecis != null:
		_gecis.kill()
	_oturum = oturum
	_gecerli = gecerli
	_zaman = 0.0
	active = true
	var karisim := minf(KarakterModel.GECIS, sure * 0.5)
	_gecis = create_tween()
	_gecis.tween_property(self, "influence", 1.0, karisim)
	_gecis.tween_interval(sure - 2.0 * karisim)
	_gecis.tween_property(self, "influence", 0.0, karisim)
	_gecis.tween_callback(_kapat)


func _kapat() -> void:
	active = false
	influence = 0.0
	_oturum = 0
	_gecerli = Callable()
	_gecis = null


func _process_modification_with_delta(delta: float) -> void:
	if not _gecerli.is_valid() or not _gecerli.call():
		return
	_zaman = fposmod(_zaman + delta, _klip.length)
	var iskelet := get_skeleton()
	for kemik in _izler:
		var poz := _klip.rotation_track_interpolate(_izler[kemik], _zaman)
		iskelet.set_bone_pose_rotation(kemik, poz)
