extends SceneTree
func _initialize() -> void:
	call_deferred("_calistir")
func _calistir() -> void:
	var z = preload("res://src/sistemler/kayit_gocu_soz.gd")
	var ekran := Node.new()
	root.add_child(ekran)
	z.oynanis_isaretle(ekran, true)
	var cagrildi := {"adet":0}
	var sonuc: Dictionary = z.uygula({"surum":1}, 2, {1:func(v: Dictionary) -> Dictionary: cagrildi.adet += 1; v.surum = 2; return v})
	if sonuc.is_empty() and cagrildi.adet == 0: print("KAY71_REJECTED_BEFORE_STEP")
	ekran.free()
	quit(0 if sonuc.is_empty() and cagrildi.adet == 0 else 1)
