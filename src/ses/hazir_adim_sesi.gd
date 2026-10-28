## Görsel aktörün gerçek yer değiştirmesi; rota/tempo değiştirmez, havuz taşmasını sınırlar.
extends Node

static var _son_adim := 0
var _onceki := Vector3.ZERO
var _mesafe := 0.0
var _hazir := false

func _process(_delta: float) -> void:
	var aktor := get_parent() as Node3D
	if not _hazir:
		_onceki = aktor.global_position
		_hazir = true
		return
	var p := aktor.global_position
	var fark := Vector2(p.x - _onceki.x, p.z - _onceki.z).length()
	_onceki = p
	if fark > 1.0:
		_mesafe = 0.0 # Kurulum/ışınlanma ayak sesi üretmez.
		return
	_mesafe += fark
	if _mesafe < 0.65:
		return
	_mesafe = 0.0
	var simdi := Time.get_ticks_msec()
	if simdi - _son_adim >= 180:
		_son_adim = simdi
		get_tree().root.get_node("Ses").cal(&"sfx_adim", -24.0)
