## 2D CHR inceleme; mevcut heybe panelinin eşya/astar API'sini değiştirmez.
extends PanelContainer

var sorgu: RefCounted
var _aciklama: RichTextLabel
var _portre_doku: Texture2D
var _iz_doku: Texture2D
var _iz_acik := false
var _gorsel_iz_dugmesi: TextureButton


func gorsel_iz_dugmesi() -> TextureButton:
	return _gorsel_iz_dugmesi

func _nesne_incele(sira: int) -> void:
	if has_node("EsyaDetayKarti"):
		return
	_aciklama.text = sorgu.obje_incele(sira)
	var kart := preload("res://src/arayuz/kapi/esya_detay_karti.tscn").instantiate()
	kart.baslik = "İncelenen nişan" if sira == 1 else "İncelenen yük"
	kart.aciklama = _aciklama.text
	await EvrakAnimasyonu.oynat(self, String(kart.aciklama))
	add_child(kart)

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	z_index = 20
	var kutu := VBoxContainer.new()
	kutu.add_theme_constant_override("separation", 18)
	add_child(kutu)
	var baslik := Label.new()
	baslik.text = "Nişan ve yük incelemesi"
	baslik.add_theme_font_size_override("font_size", Tema.BASLIK_PX)
	kutu.add_child(baslik)
	var cid := String(sorgu.karakter.id).to_lower()
	var nisani := Button.new()
	nisani.text = "Nişanı / mührü incele"
	var obje1_doku := Sanat.doku("icons", "icon_clue_%s_obje1" % cid)
	if obje1_doku != null:
		nisani.icon = obje1_doku
		nisani.expand_icon = true
	nisani.custom_minimum_size.y = 70
	nisani.pressed.connect(_nesne_incele.bind(1))
	kutu.add_child(nisani)
	var yuk := Button.new()
	yuk.text = "Yükü / gizli bölmeyi incele"
	var obje2_doku := Sanat.doku("icons", "icon_clue_%s_obje2" % cid)
	if obje2_doku != null:
		yuk.icon = obje2_doku
		yuk.expand_icon = true
	yuk.custom_minimum_size.y = 70
	yuk.pressed.connect(_nesne_incele.bind(2))
	kutu.add_child(yuk)
	var portre := TextureButton.new()
	_gorsel_iz_dugmesi = portre
	portre.name = "GorselIz"
	portre.ignore_texture_size = true
	portre.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	portre.custom_minimum_size = Vector2(240, 220)
	_portre_doku = Sanat.portre(cid)
	if _portre_doku == null:
		var eski_yol := "res://data/karakterler/%s.tres" % cid
		if ResourceLoader.exists(eski_yol):
			var eski := load(eski_yol) as KarakterVerisi
			if eski != null:
				_portre_doku = Sanat.portre(String(eski.portre))
	portre.texture_normal = _portre_doku
	_iz_doku = Sanat.doku("inspect", "%s_trace" % cid)
	portre.tooltip_text = "Portrede fiziksel izi incele"
	portre.pressed.connect(func() -> void:
		_aciklama.text = sorgu.gorsel_incele()
		if _iz_doku != null:
			_iz_acik = not _iz_acik
			portre.texture_normal = _iz_doku if _iz_acik else _portre_doku
	)
	kutu.add_child(portre)
	GeceKapisiCerceve.portre_giydir(portre)
	var portre_yuvasi := portre.get_parent() as Control
	if portre_yuvasi != kutu:
		portre_yuvasi.custom_minimum_size = portre.get_combined_minimum_size()
	var iz_etiketi := Label.new()
	iz_etiketi.text = "Fiziksel izi incelemek için portreye tıkla"
	kutu.add_child(iz_etiketi)
	_aciklama = RichTextLabel.new()
	_aciklama.custom_minimum_size = Vector2(950, 290)
	_aciklama.add_theme_font_size_override("normal_font_size", Tema.KUCUK_PX)
	kutu.add_child(_aciklama)
	var kapat := Button.new()
	kapat.text = "Sorguya dön"
	kapat.custom_minimum_size.y = 60
	kapat.pressed.connect(queue_free)
	kutu.add_child(kapat)
