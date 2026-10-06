## Akşam defteri. Kapı sahnesine binmez; köy HUD'unun altında, mevcut panel temasıyla durur.
## İkinci bir SubViewport açmaz. Doku olarak yalnız mevcut gıda simgesi kullanılır.
class_name GorevDefteri
extends PanelContainer

const GENISLIK := 380.0
const ERZAK := "quest_granary_food_36"

var _satirlar: VBoxContainer


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	z_index = 5
	position = Vector2(16, 116)
	custom_minimum_size = Vector2(GENISLIK, 0)
	add_theme_stylebox_override("panel", Tema.koy_paneli())
	var cerceve := CerceveKutu.new()
	cerceve.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	cerceve.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(cerceve)
	_satirlar = VBoxContainer.new()
	_satirlar.add_theme_constant_override("separation", 4)
	add_child(_satirlar)
	var sistem := _sistem()
	if sistem != null:
		if sistem.has_signal("quest_completed"):
			sistem.quest_completed.connect(func(_q: Quest) -> void: _ciz())
		if sistem.has_signal("quest_accepted"):
			sistem.quest_accepted.connect(func(_q: Quest) -> void: _ciz())
	_ciz()


func _ciz() -> void:
	if _satirlar == null:
		return
	for c in _satirlar.get_children():
		_satirlar.remove_child(c)
		c.free()
	_satirlar.add_child(_yazi(tr("gorev.defter.baslik"), MenuSatiri.KREM, Tema.KUCUK_PX, true))
	var sistem := _sistem()
	if sistem == null:
		size = get_combined_minimum_size()
		return
	var n := 0
	for q in sistem.get_active_quests():
		if n >= 3 or not (q is GorevKaydi):
			continue
		var g := q as GorevKaydi
		var satir := HBoxContainer.new()
		satir.add_theme_constant_override("separation", 8)
		if g.slug == ERZAK:
			satir.add_child(KaynakGostergesi.ikon("gida", 24))
		satir.add_child(_yazi("%s — %s" % [tr(g.baslik_anahtari), tr(g.amac_anahtari)], Renkler.MESALE, Tema.KUCUK_PX, false))
		_satirlar.add_child(satir)
		n += 1
	var bitti: PackedStringArray = []
	var gun := _gun()
	for q in sistem.get("completed").get_all_quests():
		if q is GorevKaydi and (q as GorevKaydi).bitti_gun == gun:
			bitti.append(tr((q as GorevKaydi).baslik_anahtari))
	if not bitti.is_empty():
		_satirlar.add_child(_yazi(", ".join(bitti), KaynakGostergesi.ARTIS, Tema.KUCUK_PX, false))
	size = get_combined_minimum_size()


func _yazi(metin: String, renk: Color, punto: int, baslik: bool) -> Label:
	var l := Label.new()
	l.text = metin
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.custom_minimum_size.x = GENISLIK - 48
	l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	l.add_theme_font_size_override("font_size", punto)
	l.add_theme_color_override("font_color", renk)
	if baslik:
		var f := Tema.koy_baslik_fontu()
		if f != null:
			l.add_theme_font_override("font", f)
	return l


func _gun() -> int:
	var e := get_parent() as KoyEkrani
	if e != null and e.oturum != null:
		return e.oturum.gun
	return -999


func _sistem() -> Node:
	var agac := get_tree()
	if agac == null or agac.root == null:
		return null
	var n := agac.root.get_node_or_null("QuestSystem")
	if n == null or not n.has_method("get_active_quests"):
		return null
	return n
