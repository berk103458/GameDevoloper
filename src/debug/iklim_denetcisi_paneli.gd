class_name IklimDenetcisiPaneli
extends PanelContainer
signal sonuc_alindi(sonuc: Dictionary)
var baglam: Node
var mevsim: OptionButton
var hava: OptionButton
var uygula: Button
var sifirla: Button
var durum: Label
var son_rapor: Dictionary = {}
var _sure := 0.0

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	custom_minimum_size = Vector2(900, 300)
	position = get_viewport_rect().size / 2.0 - custom_minimum_size / 2.0
	mouse_filter = Control.MOUSE_FILTER_STOP
	var kutu := StyleBoxFlat.new()
	kutu.bg_color = Color("#101923")
	kutu.set_content_margin_all(20)
	add_theme_stylebox_override("panel", kutu)
	var v := VBoxContainer.new()
	add_child(v)
	var baslik := Label.new()
	baslik.text = "Mevsim ve hava deneyi"
	v.add_child(baslik)
	durum = Label.new()
	durum.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	v.add_child(durum)
	var satir := HBoxContainer.new()
	v.add_child(satir)
	mevsim = OptionButton.new()
	for ad in ["Takvimden", "İlkbahar", "Yaz", "Sonbahar", "Kış"]: mevsim.add_item(ad)
	satir.add_child(mevsim)
	hava = OptionButton.new()
	for ad in ["Normal", "Kar fırtınası", "Kuraklık", "Yağmur"]: hava.add_item(ad)
	satir.add_child(hava)
	uygula = Button.new()
	uygula.text = "İklimi uygula"
	uygula.pressed.connect(_uygula)
	satir.add_child(uygula)
	sifirla = Button.new()
	sifirla.text = "Takvime / normal havaya dön"
	sifirla.pressed.connect(_sifirla)
	v.add_child(sifirla)
	var aciklama := Label.new()
	aciklama.text = "Gün ilerlemez. Deney çarpanları: kuraklık gıda ×1,5; kar fırtınası odun ×2.\nFırtınada soğuk/tarla durması ve eksik yakacak hasarı gerçek gece modelinden."
	aciklama.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	aciklama.add_theme_font_size_override("font_size", 18)
	v.add_child(aciklama)
	var kapat := Button.new()
	kapat.text = "Denetçiyi kapat"
	kapat.pressed.connect(func() -> void: ac(false))
	v.add_child(kapat)
	ac(false)

func ac(evet: bool) -> void:
	visible = evet
	set_process(evet)
	if evet:
		var o: Oturum = baglam.get("oturum") if is_instance_valid(baglam) else null
		if o != null:
			mevsim.select(int(IklimDeneyi.ayar(o.yonetim).get("mevsim", -1)) + 1)
			hava.select(IklimDeneyi.HAVALAR.find(IklimDeneyi.hava(o.yonetim)))
		yenile()

func _process(delta: float) -> void:
	_sure += delta
	if _sure >= 0.5:
		_sure = 0.0
		yenile()

func yenile() -> void:
	var o: Oturum = baglam.get("oturum") if is_instance_valid(baglam) else null
	durum.text = "Oturum yok" if o == null else "%s · %s · Gıda ×%.1f / Odun ×%.1f" % [["İlkbahar", "Yaz", "Sonbahar", "Kış"][o.yonetim.mevsim()], ["Normal", "Kar fırtınası", "Kuraklık", "Yağmur"][IklimDeneyi.HAVALAR.find(IklimDeneyi.hava(o.yonetim))], IklimDeneyi.gida_carpani(o.yonetim), IklimDeneyi.odun_carpani(o.yonetim)]
	uygula.disabled = not ZamanMakinesi.uygun(baglam)
	sifirla.disabled = uygula.disabled

func _uygula() -> void:
	son_rapor = IklimDeneyi.uygula(baglam, mevsim.selected - 1, IklimDeneyi.HAVALAR[hava.selected])
	yenile()
	sonuc_alindi.emit(son_rapor)

func _sifirla() -> void:
	mevsim.select(0)
	hava.select(0)
	_uygula()
