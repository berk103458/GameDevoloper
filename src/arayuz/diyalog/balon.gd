## Dialogue Manager örnek balonunun ince kabuğu. Eklenti sahnesi durur.
## Panel, gece kapısı çerçevesini giyer. Kök dosya kuralı: diyalog metni burada yazılmaz.
extends "res://addons/dialogue_manager/example_balloon/example_balloon.gd"


func _ready() -> void:
	super()
	var p := get_node_or_null("Balloon/MarginContainer/PanelContainer")
	var cerceve := GeceKapisiCerceve.panel()
	if p is PanelContainer and cerceve != null:
		(p as PanelContainer).add_theme_stylebox_override("panel", cerceve)
	var ornek := get_node_or_null("Balloon/CenterContainer/ResponsesMenu/ResponseExample")
	var dugme := GeceKapisiCerceve.dugme()
	if ornek is Button and dugme != null:
		for durum in ["normal", "hover", "pressed", "focus", "disabled", "hover_pressed"]:
			(ornek as Button).add_theme_stylebox_override(durum, dugme.duplicate())
