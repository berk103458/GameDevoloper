extends SceneTree

var _hata := 0

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
	_dene(ses.bus == &"Ambiance" and AudioServer.get_bus_send(AudioServer.get_bus_index("Ambiance")) == &"Efekt", "koy_ortam_test.gd:25")
	ortam.faz(&"gunduz")
	_dene(ses.parca == &"ortam_koy_gunduz", "koy_ortam_test.gd:27")
	ortam.faz(&"aksam")
	_dene(ses.degisim == 1, "koy_ortam_test.gd:29")
	ortam.faz(&"gece")
	_dene(ses.parca == &"ortam_koy_gece" and ses.degisim == 2, "koy_ortam_test.gd:31")
	ortam.free()
	_dene(ses.bus == &"Efekt", "koy_ortam_test.gd:33")
	ses.free()
	for parca in ["gunduz", "gece"]:
		_dene(ResourceLoader.exists("res://assets/ses/ortam_koy_%s.wav" % parca), "koy_ortam_test.gd:36")
	print("KÖY ORTAMI: GEÇTİ" if _hata == 0 else "KÖY ORTAMI: KALDI (%d hata)" % _hata)
	quit(1 if _hata > 0 else 0)


func _dene(kosul: bool, ad: String) -> void:
	if not kosul:
		_hata += 1
		push_error(ad)
