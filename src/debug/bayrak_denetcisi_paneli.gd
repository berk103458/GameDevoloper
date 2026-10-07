## Sorgu flag/clue denetimi; kapalıyken işleme yok, Clue kaydı salt okunur.
class_name BayrakDenetcisiPaneli
extends PanelContainer

signal sonuc_alindi(sonuc: Dictionary)
var baglam: Node
var liste: VBoxContainer
var baslik: Label
var kontroller: Dictionary = {}
var _sorgu: ChrSorgusu
var _imza := ""
var _sure := 0.0

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	custom_minimum_size = Vector2(680, 420)
	position = get_viewport_rect().size / 2.0 - custom_minimum_size / 2.0
	mouse_filter = Control.MOUSE_FILTER_STOP
	var kutu := StyleBoxFlat.new()
	kutu.bg_color = Color("#101923")
	kutu.set_content_margin_all(20)
	add_theme_stylebox_override("panel", kutu)
	var v := VBoxContainer.new()
	add_child(v)
	baslik = Label.new()
	v.add_child(baslik)
	var aciklama := Label.new()
	aciklama.text = "Ziyaret bayrakları geçicidir; CHR kaynağı değişmez. Clue listesi salt okunur."
	aciklama.add_theme_font_size_override("font_size", 18)
	v.add_child(aciklama)
	var kaydir := ScrollContainer.new()
	kaydir.custom_minimum_size = Vector2(640, 280)
	kaydir.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(kaydir)
	liste = VBoxContainer.new()
	liste.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	kaydir.add_child(liste)
	var kapat := Button.new()
	kapat.text = "Denetçiyi kapat"
	kapat.pressed.connect(func() -> void: ac(false))
	v.add_child(kapat)
	ac(false)

func ac(evet: bool) -> void:
	visible = evet
	set_process(evet)
	if evet:
		yenile(true)

func _process(delta: float) -> void:
	_sure += delta
	if _sure >= 0.5:
		_sure = 0.0
		yenile()

func yenile(zorla: bool = false) -> void:
	var s := BayrakDenetcisi.sorgu(baglam)
	var imza := "yok" if s == null else "%d:%s:%s" % [s.get_instance_id(), JSON.stringify(s.bayraklar), JSON.stringify(s.ipuclari)]
	if not zorla and imza == _imza:
		return
	_imza = imza
	_sorgu = s
	for n in liste.get_children():
		liste.remove_child(n)
		n.queue_free()
	kontroller.clear()
	baslik.text = "Flag / Clue denetçisi — hazır CHR sorgusu yok"
	if s == null:
		return
	baslik.text = "Flag / Clue · %s" % String(s.karakter.entity_id)
	var anahtarlar := s.bayraklar.keys()
	anahtarlar.sort()
	for anahtar: String in anahtarlar:
		if not anahtar.begins_with("Flag_"):
			continue
		var b := CheckBox.new()
		b.text = anahtar
		b.button_pressed = bool(s.bayraklar[anahtar])
		b.disabled = anahtar == "Flag_Kilitlendi" and b.button_pressed
		if b.disabled:
			b.tooltip_text = "Kalıcı panik kilidi bu ziyarette kaldırılamaz."
		b.toggled.connect(_degistir.bind(s, anahtar))
		liste.add_child(b)
		kontroller[anahtar] = b
	var ipuclari := s.ipuclari.keys()
	ipuclari.sort()
	var etiket := Label.new()
	etiket.text = "Clue kaydı yok" if ipuclari.is_empty() else "Clue kayıtları:\n" + "\n".join(ipuclari)
	etiket.add_theme_font_size_override("font_size", 20)
	liste.add_child(etiket)

func _degistir(acik: bool, beklenen: ChrSorgusu, anahtar: String) -> void:
	var sonuc := BayrakDenetcisi.uygula(baglam, beklenen, anahtar, acik)
	yenile(true)
	sonuc_alindi.emit(sonuc)
