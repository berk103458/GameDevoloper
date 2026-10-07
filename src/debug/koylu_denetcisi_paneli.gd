class_name KoyluDenetcisiPaneli
extends PanelContainer
var baglam: Node
var tablo: Tree
var durum: Label
var satirlar: Array[Dictionary] = []
var _son_ms := 0

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	custom_minimum_size = Vector2(1400, 520)
	position = get_viewport_rect().size / 2.0 - custom_minimum_size / 2.0
	mouse_filter = Control.MOUSE_FILTER_STOP
	var kutu := StyleBoxFlat.new()
	kutu.bg_color = Color("#101923")
	kutu.set_content_margin_all(20)
	add_theme_stylebox_override("panel", kutu)
	var v := VBoxContainer.new()
	add_child(v)
	durum = Label.new()
	v.add_child(durum)
	var aciklama := Label.new()
	aciklama.text = "Salt okunur. Brüt/gece formül verimidir; stok, diğer çalışanlar ve kesir artığı net ambar sonucunu değiştirir."
	aciklama.add_theme_font_size_override("font_size", 18)
	v.add_child(aciklama)
	tablo = Tree.new()
	tablo.columns = 9
	tablo.hide_root = true
	tablo.column_titles_visible = true
	tablo.custom_minimum_size = Vector2(1360, 400)
	tablo.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var basliklar := ["Köylü", "Atama", "Anlık eylem", "Zanaat", "Verim ×", "Brüt/gece (+kritik)", "Üretim durumu", "Güçlü yön", "Zayıf yön"]
	var genislikler := [180, 120, 130, 130, 75, 170, 160, 145, 145]
	for i in basliklar.size():
		tablo.set_column_title(i, basliklar[i])
		tablo.set_column_custom_minimum_width(i, genislikler[i])
		tablo.set_column_clip_content(i, true)
	v.add_child(tablo)
	var kapat := Button.new()
	kapat.text = "Denetçiyi kapat"
	kapat.pressed.connect(func() -> void: ac(false))
	v.add_child(kapat)
	ac(false)

func ac(evet: bool) -> void:
	visible = evet
	set_process(evet)
	if evet: yenile()

func _process(_delta: float) -> void:
	if Time.get_ticks_msec() - _son_ms >= 500: yenile()

func yenile() -> void:
	_son_ms = Time.get_ticks_msec()
	var o: Oturum = baglam.get("oturum") if is_instance_valid(baglam) else null
	var hareket: KoyHalkHareketi
	var e: Node = baglam.get("_ekran") if is_instance_valid(baglam) else null
	if is_instance_valid(e) and e.get_script() != null and e.get_script().get_global_name() == "KoyEkrani": hareket = e.get("sahne3b").get("halk_hareketi")
	satirlar = KoyluDenetcisi.satirlar(o, hareket)
	durum.text = "Köylü / zanaat denetçisi · %d kişi · %s" % [satirlar.size(), "canlı sahne" if hareket != null else "sahne yok, yalnız model"]
	var root := tablo.get_root()
	if root == null: root = tablo.create_item()
	var item := root.get_first_child()
	for r in satirlar:
		if item == null: item = tablo.create_item(root)
		var cikti: Array[String] = []
		for tur in r["uretim"]:
			cikti.append("%s %.2f%s" % [tur, r["uretim"][tur], " (+%d)" % r["bonus"][tur] if r["bonus"].has(tur) else ""])
		var hucreler := ["#%d %s" % [r["id"], tr(r["ad"])], r["bina"], r["eylem"], "%s · %d" % [ZanaatTuru.ad(r["zanaat_turu"]), r["stat"]], "%.2f" % r["carpan"], ", ".join(cikti) if not cikti.is_empty() else "—", r["engel"]]
		hucreler.append(PasifOzellikler.metin(r["pasif_ozellikler"], true))
		hucreler.append(PasifOzellikler.metin(r["pasif_ozellikler"], false))
		for i in hucreler.size():
			item.set_text(i, hucreler[i])
			item.set_tooltip_text(i, hucreler[i])
		item.set_tooltip_text(3, hucreler[3] + "\n" + String(r["egitim"]) + "\n" + String(r["yas_rolu"]))
		item.set_tooltip_text(2, hucreler[2] + "\n" + String(r["memnuniyet"]) + "\n" + String(r["toplumsal_bag"]))
		item.set_tooltip_text(8, hucreler[8] + "\n" + String(r["gizli_egilim"]))
		item.set_tooltip_text(4, "Meslek ×%.2f · uyumsuz işte kişi/gece alet kırma riski %%%.0f" % [r.get("meslek_carpani", 1.0), float(r.get("alet_riski", 0.0)) * 100.0])
		item.set_tooltip_text(6, hucreler[6] + "\n" + String(r["is_kazasi"]) + "\nUyumsuz iş/nöbet kaza riski: %%%.0f" % (float(r["kaza_riski"]) * 100.0))
		item = item.get_next()
	while item != null:
		var sonraki := item.get_next()
		item.free()
		item = sonraki
