extends Node

class BozukAna extends Ana:
	func _denge_hatasi() -> String:
		return preload("res://src/sistemler/denge_sinir_denetimi.gd").hata({"x": 2, "zorluk": {"kolay": {}, "olagan": {}, "siki": {}}}, {"x": {"alt": 1, "ust": 1}})

func _ready() -> void:
	TranslationServer.set_locale("tr")
	var ana := BozukAna.new()
	add_child(ana)
	for i in 180:
		await get_tree().process_frame
		if ana.get_children().any(func(cocuk: Node) -> bool: return cocuk is Label and cocuk.text == tr("acilis.denge_hatasi") % "x"):
			break
	var hata := 0
	for cocuk in ana.get_children():
		if cocuk is MenuEkrani:
			get_tree().quit(1)
			return
		if cocuk is Label and cocuk.text == tr("acilis.denge_hatasi") % "x":
			hata += 1
	print("DEN-03b açılış hata ekranı: ", hata)
	await Ses.cik(0 if hata == 1 else 1)
