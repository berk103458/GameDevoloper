extends SceneTree

class SahteSes:
	extends Node
	var bus: StringName = &"Efekt"
	var parca: StringName = &""
	var degisim: int = 0
	func ortam_busu_adi() -> StringName:
		return bus
	func ortam_busunu_ayarla(ad: StringName) -> void:
		bus = ad
	func ortam_cal(ad: StringName, _db: float) -> void:
		parca = ad
		degisim += 1

func _initialize() -> void:
	call_deferred("_calistir")

func _calistir() -> void:
	var ses := SahteSes.new()
	root.add_child(ses)
	var ortam := preload("res://src/sistemler/koy_ortam_sesi.gd").new()
	ortam._ses = ses
	root.add_child(ortam)
	assert(ses.bus == &"Ambiance" and AudioServer.get_bus_send(AudioServer.get_bus_index("Ambiance")) == &"Efekt")
	ortam.faz(&"gunduz")
	assert(ses.parca == &"ortam_koy_gunduz")
	ortam.faz(&"aksam")
	assert(ses.degisim == 1)
	ortam.faz(&"gece")
	assert(ses.parca == &"ortam_koy_gece" and ses.degisim == 2)
	ortam.free()
	assert(ses.bus == &"Efekt")
	ses.free()
	for parca in ["gunduz", "gece"]:
		assert(ResourceLoader.exists("res://assets/ses/ortam_koy_%s.wav" % parca))
	print("KÖY ORTAMI: GEÇTİ")
	quit(0)
