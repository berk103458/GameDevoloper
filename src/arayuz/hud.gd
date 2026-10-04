## Üst HUD şeridi: parçalı barlar solda, rüşvet keseleri ve gece sayacı sağda (sanat kitabı 7.2, 7.6).
class_name Hud
extends PanelContainer

var _oturum: Oturum
var _bar_kutulari: Array[HBoxContainer] = []
var _bar_etiketleri: Array[Label] = []
var _keseler: HBoxContainer
var _gece: Label
var _koy: Label
var _ekonomi: Label


## HUD'u bir oturuma bağlar.
func bagla(oturum: Oturum) -> void:
	_oturum = oturum
	oturum.barlar.degisti.connect(guncelle)
	oturum.koy.degisti.connect(guncelle)
	guncelle()


func _ready() -> void:
	custom_minimum_size = Vector2(0, 92)
	var kutu := HBoxContainer.new()
	kutu.add_theme_constant_override("separation", 36)
	add_child(kutu)
	for i in 4:
		var v := VBoxContainer.new()
		v.add_theme_constant_override("separation", 4)
		var e := Label.new()
		e.add_theme_font_size_override("font_size", Tema.KUCUK_PX)
		v.add_child(e)
		var parcalar := HBoxContainer.new()
		parcalar.add_theme_constant_override("separation", 3)
		v.add_child(parcalar)
		kutu.add_child(v)
		_bar_etiketleri.append(e)
		_bar_kutulari.append(parcalar)
	var bosluk := Control.new()
	bosluk.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	kutu.add_child(bosluk)
	_ekonomi = Label.new()
	_ekonomi.add_theme_font_size_override("font_size", Tema.KUCUK_PX)
	_ekonomi.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	kutu.add_child(_ekonomi)
	_keseler = HBoxContainer.new()
	_keseler.add_theme_constant_override("separation", 6)
	kutu.add_child(_keseler)
	var sag := VBoxContainer.new()
	_gece = Label.new()
	_gece.add_theme_font_size_override("font_size", Tema.BASLIK_PX)
	_gece.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	sag.add_child(_gece)
	_koy = Label.new()
	_koy.add_theme_font_size_override("font_size", Tema.KUCUK_PX)
	_koy.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	sag.add_child(_koy)
	kutu.add_child(sag)


## Tüm göstergeleri oturumdan yeniden çizer.
func guncelle() -> void:
	if _oturum == null:
		return
	var b := _oturum.barlar
	for i in mini(_bar_kutulari.size(), b.degerler.size()):
		var v: int = b.degerler[i]
		_bar_etiketleri[i].text = "%s  %d" % [tr(_oturum.ayarlar.bar_anahtarlari[i]), v]
		var p := _bar_kutulari[i]
		for c in p.get_children():
			c.queue_free()
		for s in b.azami:
			var durum := "empty"
			if s < v:
				durum = "full"
				if v <= 3 and s == v - 1:
					durum = "cracked_02"
				elif v <= 3 and s == v - 2:
					durum = "cracked_01"
			p.add_child(_parca(durum))
	for c in _keseler.get_children():
		c.queue_free()
	for k in _oturum.ayarlar.rusvet_hakki:
		var dolu := k < _oturum.rusvet_hakki
		var t := Sanat.doku("ui", "icon_bribe_pouch_%s_48" % ("full" if dolu else "empty"))
		if t != null:
			var r := TextureRect.new()
			r.texture = t
			r.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
			_keseler.add_child(r)
		else:
			var l := Label.new()
			l.text = "●" if dolu else "○"
			_keseler.add_child(l)
	_gece.text = tr("arayuz.hud.gece") % _oturum.gosterilen_gece()
	_koy.text = tr("arayuz.hud.kose") % _oturum.koy.toplam()
	_ekonomi.text = "%s\n%s" % [tr("arayuz.hud.akce") % _oturum.akce, tr("arayuz.hud.ambar") % _oturum.ambar]


func _parca(durum: String) -> Control:
	var t := Sanat.doku("ui", "ui_bar_segment_%s" % durum)
	if t != null:
		var r := TextureRect.new()
		r.texture = t
		r.custom_minimum_size = Vector2(22, 30)
		r.stretch_mode = TextureRect.STRETCH_KEEP
		return r
	var c := ColorRect.new()
	c.custom_minimum_size = Vector2(18, 26)
	c.color = Renkler.KUL if durum != "empty" else Renkler.DERIN_MAVI
	return c
