## CSV kilidinden bağımsız, mevcut ayar ekranının sağındaki grafik tercihleri.
class_name GrafikAyarlariPaneli
extends VBoxContainer

var ayarlar: Ayarlar
var _profil: OptionButton
var _olcek: OptionButton

func _ready() -> void:
	if get_parent() != null and get_parent().get_script() != null and get_parent().get_script().resource_path.ends_with("ayarlar_ekrani.gd"):
		visible = false
		return
	position = Vector2(1190, 210)
	custom_minimum_size = Vector2(540, 0)
	add_theme_constant_override("separation", 20)
	var baslik := Label.new()
	baslik.text = tr("arayuz.ayarlar.grafik.baslik")
	baslik.add_theme_font_size_override("font_size", ayarlar.boyut(Tema.BASLIK_PX) if ayarlar != null else Tema.BASLIK_PX)
	add_child(baslik)
	_profil = _secici(tr("arayuz.ayarlar.grafik.profil"), [tr("arayuz.ayarlar.grafik.normal"), tr("arayuz.ayarlar.grafik.dusuk")])
	_profil.item_selected.connect(func(i: int) -> void:
		ayarlar.ayarla(&"grafik_profili", Ayarlar.GECERLI[&"grafik_profili"][i]))
	_olcek = _secici(tr("arayuz.ayarlar.grafik.cozunurluk"), ["%50", "%67", "%75", "%85", "%100"])
	_olcek.item_selected.connect(func(i: int) -> void:
		ayarlar.ayarla(&"cozunurluk_3d", Ayarlar.GECERLI[&"cozunurluk_3d"][i]))
	var notu := Label.new()
	notu.text = tr("arayuz.ayarlar.grafik.not")
	notu.add_theme_font_size_override("font_size", ayarlar.boyut(Tema.KUCUK_PX) if ayarlar != null else Tema.KUCUK_PX)
	add_child(notu)
	ayarlar.degisti.connect(_yenile)
	_yenile()

func _secici(etiket: String, secenekler: Array) -> OptionButton:
	var l := Label.new()
	l.text = etiket
	add_child(l)
	var b := OptionButton.new()
	b.custom_minimum_size = Vector2(540, 64)
	for metin in secenekler:
		b.add_item(metin)
	add_child(b)
	return b

func _yenile(_anahtar: StringName = &"") -> void:
	_profil.select(Ayarlar.GECERLI[&"grafik_profili"].find(ayarlar.al(&"grafik_profili")))
	_olcek.select(Ayarlar.GECERLI[&"cozunurluk_3d"].find(ayarlar.al(&"cozunurluk_3d")))

func _exit_tree() -> void:
	if ayarlar.degisti.is_connected(_yenile):
		ayarlar.degisti.disconnect(_yenile)
