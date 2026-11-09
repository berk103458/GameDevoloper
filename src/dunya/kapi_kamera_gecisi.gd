## Kapı kamera yazımlarının tek sahibi; son istek önceki geçişi iptal eder.
class_name KapiKameraGecisi
extends Node

var kamera: Camera3D
var taban_konum: Vector3
var _nesil := 0
var _tween: Tween

func _baslat() -> int:
	_nesil += 1
	if _tween != null and _tween.is_valid():
		_tween.kill()
	_tween = null
	return _nesil

func kuyruk(bakis: Callable, simdiki: Vector3, hedef: Vector3, fov: float) -> void:
	await _gecis(bakis, simdiki, hedef, fov, taban_konum, 0.6)


func karar(acik: bool, normal_fov: float, bakis: Callable, simdiki: Vector3, hedef: Vector3) -> void:
	var konum := taban_konum
	if acik:
		konum.z += KapiKameraVurgu.KARAR_GERI_ADIM
	await _gecis(bakis, simdiki, hedef, normal_fov, konum, 0.25)


func _gecis(bakis: Callable, simdiki: Vector3, hedef: Vector3, fov: float, konum: Vector3, sure: float) -> void:
	var n := _baslat()
	if not is_instance_valid(kamera):
		return
	sure = preload("res://src/sistemler/hareket_azalt.gd").sure(sure)
	if sure > 0.0:
		_tween = create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		_tween.tween_property(kamera, "position", konum, sure)
		_tween.tween_method(bakis, simdiki, hedef, sure)
		_tween.tween_property(kamera, "fov", fov, sure)
		# kill() finished sinyali vermez; iptal edilen çağrı da beklemekten çıkar.
		while n == _nesil and _tween != null and _tween.is_valid() and _tween.is_running():
			await get_tree().process_frame
	if n == _nesil and is_instance_valid(kamera):
		kamera.position = konum
		kamera.fov = fov
		bakis.call(hedef)


func _exit_tree() -> void:
	_baslat()
