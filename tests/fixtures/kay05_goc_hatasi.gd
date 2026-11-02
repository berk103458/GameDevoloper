## Yalnız KAY-05 parent testi başlatır; bu alt süreçte tek kasıtlı assert beklenir.
extends SceneTree
func _ilk(v: Dictionary) -> Dictionary:
	v.surum = 3
	v.kisi.hafiza.append("yalnız geçici kopyada")
	print("KAY05_STEP1_DONE")
	return v
func _hatali(_v: Dictionary) -> Dictionary:
	assert(false, "KAY05_EXPECTED_MIGRATION_FAILURE")
	return {}
func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 1 or not args[0].begins_with("user://kalfa_kay05_"):
		quit(2)
		return
	var k := GuvenliKayit.new(args[0])
	var sonuc := preload("res://src/sistemler/kayit_gocu_soz.gd").uygula(k.oku(), 4, {2:_ilk, 3:_hatali})
	if not sonuc.is_empty():
		print("KAY05_UNEXPECTED_SUCCESS")
		quit(1)
		return
	print("KAY05_REJECTED")
	quit(0)
