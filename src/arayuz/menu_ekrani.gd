## Ana menü (referans: design/art/referans/menu_referans.webp — kullanıcı kararı, 4 Ekim 2026):
## 3D gece sahnesi; solda üst satır, büyük başlık, süslü ayraç, ikonlu dört satır; sağ altta ipucu.
## BilgiEkrani'nın `secildi` sözleşmesini ve düğme alanlarını kullanır; yalnız yerleşim farklıdır.
class_name MenuEkrani
extends BilgiEkrani

## Oyunun adı kilitte açık; ad konunca buraya yazılır ve başlığın üstünde basılır.
const OYUN_ADI := ""
## Satırlar arası belirme adımı (s); ayarlardaki belirme hızına uyar.
const ADIM_S := 0.09
const IKONLAR := [MenuSatiri.Ikon.AY, MenuSatiri.Ikon.ISARET, MenuSatiri.Ikon.CARK, MenuSatiri.Ikon.KAPI]
const SOL := 108.0
const GENISLIK := 500.0

var ust_satir: String = ""
var ipucu: String = ""
var metin_anahtarlari: PackedStringArray = []
var _satirlar: Array[Button] = []
var surum_metni: String = ""
var daha_once: PackedStringArray = PackedStringArray()


func _ready() -> void:
	preload("res://src/arayuz/yeni_oyun_ekrani.gd").menu_hazir(self)
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var zemin := ColorRect.new()
	zemin.color = Renkler.GECE
	zemin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(zemin)
	var kap := SubViewportContainer.new()
	kap.stretch = true
	kap.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	kap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(kap)
	var vp := SubViewport.new()
	vp.size = Vector2i(1920, 1080)
	kap.add_child(vp)
	vp.add_child(MenuSahnesi.new())
	add_child(_sol_golge())

	var kok := Control.new()
	kok.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	kok.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(kok)
	var y := 355.0
	if OYUN_ADI != "":
		_etiket(kok, OYUN_ADI, 30, Tema.font(700), MenuSatiri.ALTIN, y - 60.0)
	_etiket(kok, ust_satir, 26, Tema.font(400), Color(MenuSatiri.KREM, 0.85), y)
	_sus(kok, MenuSusu.Tur.UST, y + 43.0, GENISLIK - 8.0, 170.0)
	var b := _etiket(kok, baslik, 118, Tema.font(500), MenuSatiri.KREM, y + 50.0)
	b.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.7))
	b.add_theme_constant_override("shadow_offset_y", 5)
	b.add_theme_constant_override("shadow_offset_x", 0)
	b.add_theme_constant_override("shadow_outline_size", 10)
	_sus(kok, MenuSusu.Tur.ALT, y + 200.0, GENISLIK, 230.0)

	var liste: Array[Button] = []
	for i in dugmeler.size():
		var d := MenuSatiri.new()
		d.text = dugmeler[i]
		d.ikon = IKONLAR[mini(i, IKONLAR.size() - 1)]
		d.font_ = Tema.font(500)
		d.punto = ayarlar.boyut(34)
		d.disabled = i in pasifler
		d.position = Vector2(SOL, y + 255.0 + i * 82.0)
		d.size = Vector2(GENISLIK, 70)
		d.pressed.connect(func() -> void: secildi.emit(i))
		d.focus_entered.connect(func() -> void: Ses.cal(&"sfx_secim", -8.0))
		d.visible = false
		kok.add_child(d)
		liste.append(d)
	_satirlar = liste
	_odak_komsulari(liste)
	if ayarlar != null and not ayarlar.degisti.is_connected(_dil_degisti):
		ayarlar.degisti.connect(_dil_degisti)

	if ipucu != "":
		var f := Tema.font(400)
		var px := ayarlar.boyut(Kabuk.KUCUK)
		var ekran := get_viewport_rect().size
		if ekran.x < 100.0:
			ekran = Vector2(1920, 1080)
		var kutu := Kabuk.ipucu_kutusu(ekran, int(ayarlar.al(&"metin_olcegi")))
		var alan := Control.new()
		alan.name = "menu_ipucu"
		alan.anchor_left = 1.0
		alan.anchor_right = 1.0
		alan.anchor_top = 1.0
		alan.anchor_bottom = 1.0
		alan.offset_left = kutu.position.x - ekran.x
		alan.offset_right = kutu.end.x - ekran.x
		alan.offset_top = kutu.position.y - ekran.y
		alan.offset_bottom = kutu.end.y - ekran.y
		alan.mouse_filter = Control.MOUSE_FILTER_IGNORE
		alan.clip_contents = true
		add_child(alan)
		var s := MenuSusu.new()
		s.tur = MenuSusu.Tur.IPUCU
		s.konum = kutu.size.x
		s.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		alan.add_child(s)
		var l := Label.new()
		l.text = ipucu
		l.add_theme_font_size_override("font_size", px)
		l.add_theme_color_override("font_color", Color(MenuSatiri.KREM, 0.75))
		if f != null:
			l.add_theme_font_override("font", f)
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		l.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		alan.add_child(l)
	if surum_metni != "":
		var surum := _etiket(kok, surum_metni, 22, Tema.font(400), Color(MenuSatiri.KREM, 0.7), 990.0)
		surum.name = "surum"
	if daha_once.size() > 0:
		var once := _etiket(kok, tr("arayuz.menu.daha_once") % ", ".join(daha_once), 22, Tema.font(400), Color(MenuSatiri.KREM, 0.7), 1024.0)
		once.name = "daha_once"
	_sirayla_goster(liste)


## Sol yarıyı yumuşakça karartan gölge: yazı sahnenin önünde okunur; üstte gök (ay) açık kalır.
func _sol_golge() -> ColorRect:
	var sh := Shader.new()
	sh.code = """
shader_type canvas_item;
void fragment() {
	float yatay = 1.0 - smoothstep(0.0, 0.62, UV.x);
	float dikey = smoothstep(0.22, 0.45, UV.y);
	COLOR = vec4(0.01, 0.015, 0.03, 0.82 * yatay * dikey);
}
"""
	var m := ShaderMaterial.new()
	m.shader = sh
	var r := ColorRect.new()
	r.material = m
	r.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return r


## Satırlar yukarıdan aşağı sırayla belirir; ilk etkin satır odak alır.
func _sirayla_goster(liste: Array[Button]) -> void:
	var adim := ayarlar.belirme_ms(ADIM_S * 1000.0) / 1000.0
	for d in liste:
		if adim > 0.0:
			await get_tree().create_timer(adim).timeout
		if not is_instance_valid(d):
			return
		d.visible = true
	for d in liste:
		if not d.disabled:
			d.grab_focus()
			break


func _dil_degisti(anahtar: StringName) -> void:
	if anahtar != &"dil":
		return
	for i in _satirlar.size():
		if i < metin_anahtarlari.size() and is_instance_valid(_satirlar[i]):
			_satirlar[i].text = DilAyari.gorunen("menu", _satirlar[i].text, metin_anahtarlari[i])


## Odak yalnız etkin satırlar arasında, listede sarar (7.10).
func _odak_komsulari(liste: Array[Button]) -> void:
	var etkin := liste.filter(func(b: Button) -> bool: return not b.disabled)
	for i in etkin.size():
		var b: Button = etkin[i]
		b.focus_neighbor_top = b.get_path_to(etkin[(i - 1 + etkin.size()) % etkin.size()])
		b.focus_neighbor_bottom = b.get_path_to(etkin[(i + 1) % etkin.size()])


func _etiket(kok: Control, metin_: String, px: int, f: Font, renk: Color, y: float) -> Label:
	var l := Label.new()
	l.text = metin_
	l.position = Vector2(SOL, y)
	l.add_theme_font_size_override("font_size", ayarlar.boyut(px))
	l.add_theme_color_override("font_color", renk)
	if f != null:
		l.add_theme_font_override("font", f)
	kok.add_child(l)
	return l


func _sus(kok: Control, tur_: MenuSusu.Tur, y: float, genislik: float, konum_: float) -> void:
	var s := MenuSusu.new()
	s.tur = tur_
	s.konum = konum_
	s.position = Vector2(SOL, y - 12.0)
	s.size = Vector2(genislik, 24)
	s.mouse_filter = Control.MOUSE_FILTER_IGNORE
	kok.add_child(s)
