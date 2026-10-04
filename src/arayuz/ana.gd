## Oyunun kök sahnesi: kataloğu ve ayarları kurar, ekranlar arasında geçer.
## Akış: Menü → Kapı (gece) → Köy (gece sonu) → … → Perde geçişi → … → Son.
class_name Ana
extends Control

var katalog: Katalog
var ayarlar: Ayarlar
var kayit: KayitDeposu
var oturum: Oturum
var _ekran: Control
var _kapi: KapiEkrani
var _ust: Control


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_eylemleri_kur()
	TranslationServer.set_locale("tr")
	ayarlar = Ayarlar.new()
	ayarlar.yukle()
	ayarlar.uygula()
	ayarlar.degisti.connect(func(_a: StringName) -> void: theme = Tema.olustur(ayarlar))
	theme = Tema.olustur(ayarlar)
	_imleci_kur()
	kayit = KayitDeposu.new()
	katalog = Katalog.new()
	if katalog.yukle() != Katalog.Durum.HAZIR:
		_hata_goster()
		return
	ana_menu()
	Ses.dongu_baslat()


## Ana menüyü gösterir.
func ana_menu() -> void:
	var e := _bilgi("", tr("arayuz.menu.alt"), [tr("arayuz.menu.yeni"), tr("arayuz.menu.devam"), tr("arayuz.menu.ayarlar"), tr("arayuz.menu.cik")])
	if not kayit.var_mi():
		e.pasifler = [1]
	e.secildi.connect(func(i: int) -> void:
		match i:
			0: yeni_oyun()
			1: devam_et()
			2: _ayarlari_ac(ana_menu)
			3: get_tree().quit()
	)
	_goster(e)


func yeni_oyun(tohum: int = 0) -> void:
	kayit.sil()
	oturum = Oturum.new(katalog, tohum)
	_kapiya_git()


func devam_et() -> void:
	var o := Oturum.kayittan(katalog, kayit.oku())
	if o == null:
		ana_menu()
		return
	oturum = o
	_kapiya_git()


func _kapiya_git() -> void:
	_kapi = KapiEkrani.new()
	_kapi.oturum = oturum
	_kapi.ayarlar = ayarlar
	_kapi.gece_bitti.connect(_gece_bitti)
	_kapi.oturum_bitti.connect(_kirildi)
	_kapi.duraklat_istendi.connect(_duraklat)
	_goster(_kapi)
	_kapi.gece_baslat()


func _gece_bitti(rapor: Dictionary) -> void:
	Ses.cal(&"sfx_gece_bitti")
	if rapor["son"] != &"" and rapor["son"] != &"kirildi":
		_son_goster(rapor["son"])
		return
	var koy := KoyEkrani.new()
	koy.oturum = oturum
	koy.ayarlar = ayarlar
	koy.rapor = rapor
	koy.oturum_bitti.connect(_kirildi)
	koy.devam_istendi.connect(func() -> void:
		# Gece sonu kaydı: olay ve yapılar çözüldükten sonra (GDD 1: gece sonu çözümünden sonra).
		kayit.yaz(oturum.kaydet())
		if rapor["perde_degisti"]:
			_perde_gecisi()
		else:
			_kapiya_git()
	)
	_goster(koy)


func _son_goster(son: StringName) -> void:
	kayit.sil()
	var e := _bilgi(tr("arayuz.son." + String(son)), tr("arayuz.son.%s_metin" % son), [tr("arayuz.son.yeniden"), tr("arayuz.son.menu")],
		oturum.gun, "env_village_bg")
	e.secildi.connect(_son_secimi)
	_goster(e)


func _perde_gecisi() -> void:
	var e := _bilgi(tr("arayuz.perde.baslik"), tr("arayuz.perde.metin"), [tr("arayuz.perde.devam")], -1, "env_village_bg")
	e.secildi.connect(func(_i: int) -> void: _kapiya_git())
	_goster(e)


func _kirildi(kirilan: int) -> void:
	kayit.sil()
	var ad := tr(oturum.ayarlar.bar_anahtarlari[kirilan])
	Ses.cal(&"sfx_bar_kirildi")
	var e := _bilgi(tr("arayuz.son.kirildi") % ad, tr("arayuz.son.kirildi.%d" % kirilan), [tr("arayuz.son.yeniden"), tr("arayuz.son.menu")], oturum.gun)
	e.secildi.connect(_son_secimi)
	_goster(e)


func _son_secimi(i: int) -> void:
	if i == 0:
		yeni_oyun()
	else:
		ana_menu()


func _duraklat() -> void:
	if _ust != null:
		return
	var e := _bilgi(tr("arayuz.duraklat.baslik"), "", [tr("arayuz.duraklat.devam"), tr("arayuz.menu.ayarlar"), tr("arayuz.duraklat.menu")], -1, "")
	e.secildi.connect(func(i: int) -> void:
		_ust_kapat()
		match i:
			1: _ayarlari_ac(_duraklat, true)
			2: ana_menu()
	)
	_ust_ac(e)


func _ayarlari_ac(sonra: Callable, ustte: bool = false) -> void:
	var a := AyarlarEkrani.new()
	a.ayarlar = ayarlar
	if ustte:
		a.kapandi.connect(func() -> void:
			_ust_kapat()
			sonra.call()
		)
		_ust_ac(a)
	else:
		a.kapandi.connect(func() -> void: sonra.call())
		_goster(a)


func _ust_ac(e: Control) -> void:
	_ust = e
	add_child(e)
	if _ekran != null:
		_ekran.process_mode = Node.PROCESS_MODE_DISABLED


func _ust_kapat() -> void:
	if _ust != null:
		_ust.queue_free()
		_ust = null
	if _ekran != null:
		_ekran.process_mode = Node.PROCESS_MODE_INHERIT


func _bilgi(baslik: String, metin: String, dugmeler: Array, sayi: int = -1, arka: String = "3d_kapi") -> BilgiEkrani:
	var e := BilgiEkrani.new()
	e.ayarlar = ayarlar
	e.baslik = baslik
	e.metin = metin
	e.dugmeler = PackedStringArray(dugmeler)
	e.sayi = sayi
	e.sayi_etiketi = tr("arayuz.son.gun")
	e.arka_plan = arka
	return e


func _goster(e: Control) -> void:
	_ust_kapat()
	if _ekran != null:
		_ekran.queue_free()
	_ekran = e
	add_child(e)


func _hata_goster() -> void:
	# Tablo bozuk olabileceği için bu metin koddadır (İçerik veri hattı, Open Question 2).
	var l := Label.new()
	l.text = "Oyun içeriği yüklenemedi.\n\n" + "\n".join(katalog.hatalar)
	l.position = Vector2(80, 80)
	add_child(l)


func _imleci_kur() -> void:
	var t := Sanat.doku("ui", "ui_cursor_arrow_32")
	if t != null:
		Input.set_custom_mouse_cursor(t, Input.CURSOR_ARROW)
		Input.set_custom_mouse_cursor(t, Input.CURSOR_POINTING_HAND)


## Girdi eylemleri (Girdi ve odak gezinmesi GDD, kural 1). Gezinme ve onay Godot'un ui_* eylemleridir.
func _eylemleri_kur() -> void:
	var tuslar := {
		"geri": [KEY_ESCAPE], "menu": [KEY_P],
		"kisayol_1": [KEY_1], "kisayol_2": [KEY_2], "kisayol_3": [KEY_3], "kisayol_4": [KEY_4],
	}
	for eylem in tuslar:
		if InputMap.has_action(eylem):
			continue
		InputMap.add_action(eylem)
		for k in tuslar[eylem]:
			var o := InputEventKey.new()
			o.physical_keycode = k
			InputMap.action_add_event(eylem, o)
	var gamepad := {"geri": JOY_BUTTON_B, "menu": JOY_BUTTON_START}
	for eylem in gamepad:
		var j := InputEventJoypadButton.new()
		j.button_index = gamepad[eylem]
		InputMap.action_add_event(eylem, j)
