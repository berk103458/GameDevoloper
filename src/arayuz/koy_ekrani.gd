## Köy görünümü: gece sonunda, meşaleler yandıktan sonra (sanat kitabı 2.3, 6.5).
## Bu gece girenler sağdan yürüyerek köye girer; meşale sayısı nüfusla artar.
class_name KoyEkrani
extends Control

signal devam_istendi

const ZEMIN_Y := 560.0
const KOY_YUKSEKLIK := 1000.0
const AZAMI_FIGUR := 48
const AZAMI_MESALE := 12

var oturum: Oturum
var ayarlar: Ayarlar
## `Oturum.gece_sonu()` raporu.
var rapor: Dictionary = {}

var _sahne: Control
var _dugme: Button


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var zemin := ColorRect.new()
	zemin.color = Renkler.GECE
	zemin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(zemin)
	_sahne = Control.new()
	_sahne.position = Vector2(0, 0)
	_sahne.size = Vector2(1920, KOY_YUKSEKLIK)
	_sahne.clip_contents = true
	add_child(_sahne)
	var arka := Sanat.doku("env", "env_village_bg")
	if arka != null:
		var r := TextureRect.new()
		r.texture = arka
		r.size = _sahne.size
		r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		r.stretch_mode = TextureRect.STRETCH_SCALE
		_sahne.add_child(r)
	else:
		var y := ColorRect.new()
		y.color = Renkler.SOGUK_MAVI
		y.position = Vector2(0, ZEMIN_Y)
		y.size = Vector2(1920, KOY_YUKSEKLIK - ZEMIN_Y)
		_sahne.add_child(y)
	if oturum.perde == 2:
		_tekfur_ciz()
	_mesaleleri_ciz()
	_figurleri_ciz()
	_bilgi_ciz()


## Meşale sayısı = 1 + nüfus / 3 (en çok AZAMI_MESALE).
func mesale_sayisi() -> int:
	return clampi(1 + oturum.koy.toplam() / 3, 1, AZAMI_MESALE)


func _mesale_konumu(i: int) -> Vector2:
	# Sabit, düzensiz bir dizilim: köy sağa ve sola doğru yayılır.
	var sira := [960, 760, 1160, 600, 1330, 450, 1480, 860, 1060, 300, 1640, 680]
	var derin := [0, 40, 20, 70, 50, 30, 80, 110, 100, 60, 90, 130]
	return Vector2(sira[i], ZEMIN_Y + 40 + derin[i])


func _mesaleleri_ciz() -> void:
	var leke := Sanat.doku("fx", "fx_torchlight_patch_village_01")
	var mesale := Sanat.doku("fx", "fx_torch_village_01")
	for i in mesale_sayisi():
		var p := _mesale_konumu(i)
		if leke != null:
			var l := TextureRect.new()
			l.texture = leke
			l.position = p - Vector2(130, -50)
			_sahne.add_child(l)
		else:
			var l2 := ColorRect.new()
			l2.color = Renkler.MESALE
			l2.position = p + Vector2(-90, 70)
			l2.size = Vector2(180, 40)
			_sahne.add_child(l2)
		if mesale != null:
			var m := TextureRect.new()
			m.texture = mesale
			m.position = p - Vector2(20, 0)
			_sahne.add_child(m)


func _figur_konumu(i: int) -> Vector2:
	# Meşale kümelerinin çevresine sıkışan yerleşim; konum sırası sabittir.
	var mesale := _mesale_konumu(i % mesale_sayisi())
	var halka := i / mesale_sayisi()
	var yon := -1.0 if (i + halka) % 2 == 0 else 1.0
	return mesale + Vector2(yon * (40 + halka * 34), 10 + (halka % 3) * 22)


func _figurleri_ciz() -> void:
	var yeni := oturum.koy.bu_gece_girenler
	var eski_sayi := clampi(oturum.koy.toplam() - yeni.size(), 0, AZAMI_FIGUR)
	var sirali_siniflar := _sinif_dizisi()
	for i in eski_sayi:
		_figur_ekle(&"", sirali_siniflar[i % sirali_siniflar.size()] if not sirali_siniflar.is_empty() else &"ciftci", _figur_konumu(i), false)
	for n in yeni.size():
		var i := eski_sayi + n
		if i >= AZAMI_FIGUR:
			break
		var g: Dictionary = yeni[n]
		var f := _figur_ekle(g["adli_id"], g["sinif"], Vector2(1960, _figur_konumu(i).y), true)
		_gir(f, _figur_konumu(i), n)


func _sinif_dizisi() -> Array[StringName]:
	var dizi: Array[StringName] = []
	for s in [&"ciftci", &"esnaf", &"asker"]:
		for k in oturum.koy.sayi(s):
			dizi.append(s)
	return dizi


func _figur_ekle(adli_id: StringName, sinif: StringName, konum: Vector2, _yeni: bool) -> Control:
	var t := Sanat.koy_figuru(adli_id, sinif)
	var c: Control
	if t != null:
		var r := TextureRect.new()
		r.texture = t
		c = r
	else:
		var k := ColorRect.new()
		k.color = Renkler.DERIN_MAVI
		k.size = Vector2(36, 96)
		c = k
	c.position = konum - Vector2(28, 110)
	_sahne.add_child(c)
	return c


func _gir(f: Control, hedef: Vector2, sira: int) -> void:
	await get_tree().create_timer(0.4 + sira * 0.5).timeout
	await Adim.yuru(f, hedef - Vector2(28, 110), 14, 6.0)


func _tekfur_ciz() -> void:
	var t := Sanat.doku("char", "crowd_tekfur_spear_01_far")
	var yakinlik := clampf(float(oturum.perde2_gece) / oturum.ayarlar.perde2_hedef_gece, 0.0, 1.0)
	# Uzak tepelerde, kervansarayın solunda; geceler geçtikçe sayıca artar ve aşağı (yakına) iner.
	var adet := mini(1 + oturum.perde2_gece / 3, 3)
	for i in adet:
		var x := -260.0 + i * 150.0 + yakinlik * 60.0
		var y := 392.0 + yakinlik * 70.0 + i * 12.0
		if t != null:
			var r := TextureRect.new()
			r.texture = t
			r.position = Vector2(x, y)
			_sahne.add_child(r)
		else:
			var k := ColorRect.new()
			k.color = Renkler.DERIN_MAVI
			k.position = Vector2(x, y)
			k.size = Vector2(200, 30)
			_sahne.add_child(k)


func _bilgi_ciz() -> void:
	var serit := PanelContainer.new()
	serit.position = Vector2(0, KOY_YUKSEKLIK - 220)
	serit.size = Vector2(1920, 300)
	add_child(serit)
	var kenar := MarginContainer.new()
	for y in ["margin_left", "margin_right", "margin_top", "margin_bottom"]:
		kenar.add_theme_constant_override(y, 30)
	serit.add_child(kenar)
	var yatay := HBoxContainer.new()
	yatay.add_theme_constant_override("separation", 40)
	kenar.add_child(yatay)
	var sol := VBoxContainer.new()
	sol.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	yatay.add_child(sol)
	var baslik := Label.new()
	baslik.text = "%s — %s" % [tr("arayuz.koy.baslik"), tr("anlati.gece.bitti")]
	baslik.add_theme_font_size_override("font_size", ayarlar.boyut(Tema.BASLIK_PX))
	sol.add_child(baslik)
	var nufus := Label.new()
	nufus.text = tr("arayuz.koy.nufus") % [oturum.koy.sayi(&"asker"), oturum.koy.sayi(&"esnaf"), oturum.koy.sayi(&"ciftci")]
	sol.add_child(nufus)
	for o in rapor.get("olaylar", PackedStringArray()):
		var l := Label.new()
		l.text = tr(o)
		l.add_theme_color_override("font_color", Renkler.SOGUK_MAVI)
		sol.add_child(l)
	if rapor.get("rusvet_harcandi", -1) >= 0:
		var r := Label.new()
		r.text = tr("anlati.rusvet.harcandi") % tr(oturum.ayarlar.bar_anahtarlari[rapor["rusvet_harcandi"]])
		sol.add_child(r)
	_dugme = Button.new()
	_dugme.text = tr("arayuz.koy.sonraki")
	_dugme.custom_minimum_size = Vector2(360, 72)
	_dugme.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	_dugme.pressed.connect(func() -> void: devam_istendi.emit())
	yatay.add_child(_dugme)
	_dugme.grab_focus.call_deferred()
