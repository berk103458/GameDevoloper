## Kapı kamera yazımlarının tek sahibi; son istek önceki geçişi iptal eder.
class_name KapiKameraGecisi
extends Node

var kamera: Camera3D
var _nesil := 0
var _tween: Tween

func _baslat() -> int:
	_nesil += 1
	if _tween != null and _tween.is_valid():
		_tween.kill()
	_tween = null
	return _nesil

func kuyruk(bakis: Callable, simdiki: Vector3, hedef: Vector3, fov: float) -> void:
	var n := _baslat()
	if not is_instance_valid(kamera):
		return
	_tween = create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	_tween.tween_method(bakis, simdiki, hedef, 0.6)
	_tween.tween_property(kamera, "fov", fov, 0.6)
	# kill() finished sinyali vermez; iptal edilen çağrı da beklemekten çıkar.
	while n == _nesil and _tween != null and _tween.is_valid() and _tween.is_running():
		await get_tree().process_frame
	if n == _nesil and is_instance_valid(kamera):
		kamera.fov = fov
		bakis.call(hedef)

func karar(icerden: bool, normal_fov: float, bakis: Callable, hedef: Vector3) -> void:
	var n := _baslat()
	if not is_instance_valid(kamera):
		return
	bakis.call(hedef)
	for i in range(1, 4):
		if n != _nesil or not is_instance_valid(kamera):
			return
		kamera.fov = normal_fov - (i if icerden else 3 - i) * 3.0
		await get_tree().create_timer(1.0 / 12.0).timeout
	if n == _nesil and is_instance_valid(kamera):
		kamera.fov = normal_fov - 9.0 if icerden else normal_fov

func _exit_tree() -> void:
	_baslat()
