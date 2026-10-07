class_name KoyluSuruklemeKulpu
extends Button
var ekran: KoyEkrani
var kisi := -1
func _get_drag_data(_yer: Vector2) -> Variant:
	if not is_instance_valid(ekran) or ekran.oturum.yonetim.koylu(kisi) == null: return null
	var l := Label.new()
	l.text = ekran.oturum.yonetim.koylu(kisi).ad + " · binaya bırak"
	l.add_theme_font_size_override("font_size", 22)
	set_drag_preview(l)
	if is_instance_valid(ekran._ust_kart): ekran._ust_kart.hide()
	return {"tur": "koylu_atama", "kisi": kisi, "oturum": ekran.oturum.get_instance_id()}
