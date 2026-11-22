## AYR-34 … AYR-37: Yeni oyun tek ekran. Geçmiş, zorluk, yuva ve tohum.
class_name YeniOyunEkrani
extends Control

signal baslatildi(tohum: int, gecmis: String)
signal vazgecildi

var ayarlar: Ayarlar
var iz: OyuncuIzi
var yuvalar: KayitYuvalari
var _gecmis := ""
var _yuva := 1
var _onay := false
var _sil_onay := 0
var _kartlar: Dictionary = {}
var _sil_dugmeleri: Dictionary = {}
var _yuva_dugmeleri: Dictionary = {}
var _tohum: LineEdit
var _gecmis_satir_kutusu: HBoxContainer
var _uyari_etiketi: Label
var _baslat_dugmesi: Button


static func menu_hazir(menu: Control) -> void:
	if menu != null:
		menu.set_meta(&"yeni_oyun_ekrani", true)


static func alan_sayisi(ilk_oyun: bool) -> int:
	return 2 if ilk_oyun else 3


static func tohum_coz(metin: String) -> int:
	var temiz := metin.strip_edges()
	if temiz.is_empty() or not temiz.is_valid_int():
		return 0
	return int(temiz)


static func baslat_olur(yuva_dolu: bool, onay: bool) -> bool:
	return not yuva_dolu or onay


static func iz_satiri(kayit: OyuncuIzi) -> String:
	if kayit == null or (not kayit.ilk_oyun_bitti and kayit.bitirilen_oyun_sayisi <= 0 and kayit.alinan_sonlar_listesi().is_empty()):
		return ""
	var temel := TranslationServer.translate("arayuz.ayarlar.yeni_oyun.iz") % kayit.bitirilen_oyun_sayisi
	var sonlar := kayit.daha_once_satiri()
	return temel if sonlar.is_empty() else temel + " · " + sonlar


func _ready() -> void:
	if iz == null:
		iz = OyuncuIzi.new()
	if yuvalar == null:
		yuvalar = KayitYuvalari.new()
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var zemin := ColorRect.new()
	zemin.color = Renkler.GECE
	zemin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(zemin)
	var arka := GeceKapisiCerceve.arka_plan_varsa("kayit")
	if arka != null:
		add_child(arka)
		var perde := ColorRect.new()
		perde.name = "kayit_perde"
		perde.color = Color(Renkler.GECE, 0.42)
		perde.mouse_filter = Control.MOUSE_FILTER_IGNORE
		perde.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		add_child(perde)
	var dikey := VBoxContainer.new()
	dikey.position = Vector2(80, 80)
	dikey.custom_minimum_size = Vector2(900, 0)
	dikey.add_theme_constant_override("separation", 12)
	add_child(dikey)
	var baslik := Label.new()
	baslik.text = tr("arayuz.ayarlar.yeni_oyun.baslik")
	dikey.add_child(baslik)
	_gecmis_satiri(dikey)
	if iz.zorluk_secimi_acik_mi() and ayarlar != null:
		preload("res://src/arayuz/ayarlar/ayar_satiri.gd").ekle(dikey, ayarlar, &"zorluk", Label.new())
	_yuva_satiri(dikey)
	var tohum_ad := Label.new()
	tohum_ad.text = tr("arayuz.ayarlar.yeni_oyun.tohum")
	dikey.add_child(tohum_ad)
	_tohum = LineEdit.new()
	_tohum.placeholder_text = str(randi())
	dikey.add_child(_tohum)
	var iz_yazi := Label.new()
	iz_yazi.text = iz_satiri(iz)
	dikey.add_child(iz_yazi)
	_uyari_etiketi = Label.new()
	_uyari_etiketi.name = "UyariEtiketi"
	_uyari_etiketi.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_uyari_etiketi.add_theme_color_override("font_color", Color("#E8B96B"))
	dikey.add_child(_uyari_etiketi)
	_baslat_dugmesi = Button.new()
	_baslat_dugmesi.name = "BaslatDugmesi"
	_baslat_dugmesi.text = tr("arayuz.ayarlar.yeni_oyun.baslat")
	_baslat_dugmesi.pressed.connect(_baslat)
	dikey.add_child(_baslat_dugmesi)
	var geri := Button.new()
	geri.text = tr("arayuz.ayarlar.geri")
	geri.pressed.connect(func() -> void: vazgecildi.emit())
	dikey.add_child(geri)


func _gecmis_satiri(dikey: VBoxContainer) -> void:
	var g = preload("res://src/sistemler/muhafiz_gecmisi.gd")
	var satir := HBoxContainer.new()
	_gecmis_satir_kutusu = satir
	dikey.add_child(satir)
	for id in g.SIRA:
		var d := Button.new()
		d.text = String(g.VERI[id].ad)
		d.toggle_mode = true
		d.pressed.connect(_gecmis_sec.bind(String(id), d, satir))
		satir.add_child(d)


func _gecmis_sec(id: String, dugme: Button, satir: HBoxContainer) -> void:
	_gecmis = id
	_onay = false
	for c in satir.get_children():
		if c is Button:
			(c as Button).set_pressed_no_signal(c == dugme)
	_durum_guncelle()


func secilen_yuva() -> int:
	return _yuva


func yuva_sec(no: int) -> void:
	_yuva = clampi(no, 1, KayitYuvalari.YUVA_SAYISI)
	_onay = false
	_sil_onay = 0
	for k in _yuva_dugmeleri:
		var dug := _yuva_dugmeleri[k] as Button
		if dug != null:
			dug.set_pressed_no_signal(int(k) == _yuva)
	_durum_guncelle()


func yuva_karti(no: int) -> KayitYuvaKarti:
	return _kartlar.get(clampi(no, 1, KayitYuvalari.YUVA_SAYISI), null) as KayitYuvaKarti


func yuvalari_yenile() -> void:
	if yuvalar == null:
		return
	_onay = false
	for n in [1, 2, 3]:
		var kart := yuva_karti(n)
		if kart != null:
			kart.dosyadan_yukle(yuvalar.yuva_yolu(n))
		var sil := _sil_dugmeleri.get(n, null) as Button
		if sil != null and kart != null:
			sil.visible = kart.durum_kodu != "bos" and kart.durum_kodu != "yeni_surum"
			sil.text = "Silmeyi onayla" if _sil_onay == n else "Yuvayı sil"
	_durum_guncelle()


func _yuva_satiri(dikey: VBoxContainer) -> void:
	var satir := HBoxContainer.new()
	satir.add_theme_constant_override("separation", 12)
	dikey.add_child(satir)
	_kartlar.clear()
	_sil_dugmeleri.clear()
	_yuva_dugmeleri.clear()
	for n in [1, 2, 3]:
		var sutun := VBoxContainer.new()
		sutun.custom_minimum_size = Vector2(280, 0)
		satir.add_child(sutun)
		var d := Button.new()
		d.name = "YuvaDugmesi_%d" % n
		d.text = tr("arayuz.ayarlar.yeni_oyun.yuva") % n
		d.toggle_mode = true
		d.button_pressed = n == _yuva
		d.pressed.connect(func() -> void: yuva_sec(n))
		sutun.add_child(d)
		_yuva_dugmeleri[n] = d
		var kart := KayitYuvaKarti.new(n)
		kart.gui_input.connect(func(olay: InputEvent) -> void:
			if olay is InputEventMouseButton and olay.pressed and olay.button_index == MOUSE_BUTTON_LEFT:
				yuva_sec(n)
		)
		sutun.add_child(kart)
		_kartlar[n] = kart
		var sil := Button.new()
		sil.name = "SilYuvaDugmesi_%d" % n
		sil.text = "Yuvayı sil"
		sil.pressed.connect(func() -> void:
			if kart.durum_kodu == "yeni_surum" or yuvalar == null:
				return
			if _sil_onay != n:
				_sil_onay = n
				yuvalari_yenile()
				return
			if yuvalar.yuva_sil(n, true):
				_sil_onay = 0
				_onay = false
				yuvalari_yenile()
		)
		sutun.add_child(sil)
		_sil_dugmeleri[n] = sil
	yuvalari_yenile()


func _durum_guncelle() -> void:
	if _uyari_etiketi != null:
		_uyari_etiketi.text = ""
	if _baslat_dugmesi != null:
		_baslat_dugmesi.text = tr("arayuz.ayarlar.yeni_oyun.baslat")


func _baslat() -> void:
	if _gecmis.is_empty():
		if _uyari_etiketi != null:
			_uyari_etiketi.text = "Önce muhafızın geçmişini seç."
		if _baslat_dugmesi != null:
			_baslat_dugmesi.text = "Önce muhafızın geçmişini seç"
		if _gecmis_satir_kutusu != null:
			for c in _gecmis_satir_kutusu.get_children():
				if c is Button:
					(c as Button).grab_focus()
					break
		return
	var kart := yuva_karti(_yuva)
	if kart != null and kart.durum_kodu == "yeni_surum":
		if _uyari_etiketi != null:
			_uyari_etiketi.text = "Seçili yuvada yeni sürüm kaydı var; başka yuva seç."
		if _baslat_dugmesi != null:
			_baslat_dugmesi.text = "Başka yuva seç (Yeni sürüm kaydı)"
		return
	var dolu := yuvalar.var_mi(_yuva)
	if not baslat_olur(dolu, _onay):
		_onay = true
		if _baslat_dugmesi != null:
			_baslat_dugmesi.text = "Dolu yuvanın üzerine yaz (Onayla)"
		if _uyari_etiketi != null:
			_uyari_etiketi.text = "Yuva %d dolu. Üzerine yazmak için tekrar bas." % _yuva
		return
	var tohum := tohum_coz(_tohum.text if _tohum != null else "")
	baslatildi.emit(tohum, _gecmis)
