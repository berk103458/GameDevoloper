## Ana menü (sanat kitabı 2.9, 7.9): 3D menü sahnesi, sol altta kül metin listesi.
## BilgiEkrani'nın `secildi` sözleşmesini ve düğme alanlarını kullanır; yalnız yerleşim farklıdır.
class_name MenuEkrani
extends BilgiEkrani

## Oyunun adı kilitte açık; ad konunca buraya yazılır ve listenin üstünde basılır (7.9: ad koddan).
const OYUN_ADI := ""
## Seçenekler arası sert adım (s); belirme bir kesmedir, alfa geçişi yok (7.7).
const ADIM_S := 0.09

var ust_satir: String = ""
var ipucu: String = ""


func _ready() -> void:
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

	var kenar := MarginContainer.new()
	kenar.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	kenar.add_theme_constant_override("margin_left", 120)
	kenar.add_theme_constant_override("margin_bottom", 110)
	add_child(kenar)
	var dikey := VBoxContainer.new()
	dikey.alignment = BoxContainer.ALIGNMENT_END
	dikey.add_theme_constant_override("separation", 6)
	kenar.add_child(dikey)
	if OYUN_ADI != "":
		dikey.add_child(_etiket(OYUN_ADI, 72, Tema.font(700)))
	dikey.add_child(_etiket(ust_satir, 22, Tema.font(400), Renkler.SOGUK_MAVI))
	dikey.add_child(_etiket(baslik, 54, Tema.font(500, true)))
	var cizgi := ColorRect.new()
	cizgi.color = Renkler.DERIN_MAVI
	cizgi.custom_minimum_size = Vector2(420, 3)
	cizgi.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	var cizgi_kap := MarginContainer.new()
	cizgi_kap.add_theme_constant_override("margin_top", 18)
	cizgi_kap.add_theme_constant_override("margin_bottom", 18)
	cizgi_kap.add_child(cizgi)
	dikey.add_child(cizgi_kap)

	var liste: Array[Button] = []
	for i in dugmeler.size():
		var d := Button.new()
		d.theme_type_variation = &"MenuDugmesi"
		d.text = dugmeler[i]
		d.alignment = HORIZONTAL_ALIGNMENT_LEFT
		d.custom_minimum_size = Vector2(420, 62)
		d.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		d.disabled = i in pasifler
		d.pressed.connect(func() -> void: secildi.emit(i))
		d.focus_entered.connect(func() -> void: Ses.cal(&"sfx_secim", -8.0))
		d.visible = false
		dikey.add_child(d)
		liste.append(d)
	_odak_komsulari(liste)

	if ipucu != "":
		var ip := _etiket(ipucu, 20, Tema.font(400), Renkler.SOGUK_MAVI)
		ip.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
		ip.grow_horizontal = Control.GROW_DIRECTION_BEGIN
		ip.grow_vertical = Control.GROW_DIRECTION_BEGIN
		ip.position -= Vector2(60, 50)
		add_child(ip)
	_sirayla_goster(liste)


## Düğmeler yukarıdan aşağı birer kesmeyle belirir; ilk etkin düğme odak alır.
func _sirayla_goster(liste: Array[Button]) -> void:
	# Ayarlardaki belirme hızına uyar (anında = hepsi aynı karede).
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


## Odak yalnız etkin düğmeler arasında, listede sarar (7.10).
func _odak_komsulari(liste: Array[Button]) -> void:
	var etkin := liste.filter(func(b: Button) -> bool: return not b.disabled)
	for i in etkin.size():
		var b: Button = etkin[i]
		b.focus_neighbor_top = b.get_path_to(etkin[(i - 1 + etkin.size()) % etkin.size()])
		b.focus_neighbor_bottom = b.get_path_to(etkin[(i + 1) % etkin.size()])


func _etiket(metin_: String, px: int, f: Font, renk: Color = Renkler.KUL) -> Label:
	var l := Label.new()
	l.text = metin_
	l.add_theme_font_size_override("font_size", ayarlar.boyut(px))
	l.add_theme_color_override("font_color", renk)
	if f != null:
		l.add_theme_font_override("font", f)
	return l
