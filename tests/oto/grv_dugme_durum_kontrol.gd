## GRV-16: gerçek kayıtsız ana menü ve ortak düğme durumları.
extends Node

class TestAna extends Ana:
	func _ready() -> void:
		ayarlar = Ayarlar.new("user://grv16_kullanilmaz.cfg")
		kayit = GuvenliKayit.new("user://grv16_" + str(Time.get_ticks_usec()) + ".json")
		theme = Tema.olustur(ayarlar)

var hata := 0

func _ready() -> void:
	get_tree().create_timer(30.0).timeout.connect(func() -> void: get_tree().quit(1))
	if OS.get_cmdline_user_args().has("GRV-07"):
		await _kapi()
		print("GRV-07 KARAR: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
		await Ses.cik(0 if hata == 0 else 1)
		return
	var ana := TestAna.new()
	add_child(ana)
	_kontrol(not ana.kayit.var_mi(), "fixture kayıtsızdır")
	ana.ana_menu()
	await get_tree().create_timer(1.0).timeout
	var menu := ana._ekran as MenuEkrani
	_kontrol(menu != null and menu._satirlar.size() == 4, "gerçek ana menü dört satır kurar")
	if menu != null and menu._satirlar.size() == 4:
		var devam := menu._satirlar[1]
		_kontrol(devam.visible and devam.disabled, "kayıtsız Devam görünür ve kapalıdır")
		for satir in menu._satirlar:
			_kontrol(not satir.flat, "tema zemini çizilir")
			for durum in ["normal", "hover", "pressed", "disabled", "focus"]:
				_kontrol(not satir.has_theme_stylebox_override(durum), "yerel stil yok: " + durum)
				_kontrol(satir.get_theme_stylebox(durum) == ana.theme.get_stylebox(durum, "Button"), "aynı tema kaynağı: " + durum)
		_kontrol(devam.get_draw_mode() == BaseButton.DRAW_DISABLED, "Devam gerçek disabled durumunu çizer")
		_kontrol(menu._satirlar[0].has_focus(), "klavye odağı etkin ilk satırdadır")
	ana.queue_free()
	await get_tree().process_frame
	print("GRV-16 MENÜ: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	await Ses.cik(0 if hata == 0 else 1)

func _kapi() -> void:
	var katalog := Katalog.new()
	katalog.yukle()
	var o := Oturum.new(katalog, 71)
	o.gun = 3
	var e := KapiEkrani.new()
	e.oturum = o
	e.ayarlar = Ayarlar.new("user://grv07_kullanilmaz.cfg")
	e.theme = Tema.olustur(e.ayarlar)
	add_child(e)
	var g := Gelen.new()
	g.ad_anahtari = "Karar testi"
	g.sinif = &"ciftci"
	g.secenekler = PackedStringArray(["kabul", "ret"])
	g.heybe = o.heybe_uret(g.sinif)
	e._gelen = g
	var once := JSON.stringify(o.kaydet())
	e._karar_goster()
	e._tumunu_goster()
	await get_tree().process_frame
	_kontrol(e.evre == &"karar" and e._karar_dugmeleri.size() == 2, "gerçek karar fabrikası mevcut iki türü kurar")
	for b in e._karar_dugmeleri:
		_kontrol(b is MenuSatiri and b.visible and not b.flat, "gerçek karar satırı tema zeminini çizer")
		for durum in ["normal", "hover", "pressed", "disabled"]:
			_kontrol(not b.has_theme_stylebox_override(durum), "karar yerel stil açmaz: " + durum)
			_kontrol(b.get_theme_stylebox(durum) == e.theme.get_stylebox(durum, "Button"), "karar ortak durumu miras alır: " + durum)
		b.disabled = true
		_kontrol(b.get_draw_mode() == BaseButton.DRAW_DISABLED and b.visible, "kapalı karar görünür, disabled stilini çizer")
	_kontrol(JSON.stringify(o.kaydet()) == once, "karar gösterimi oyun kaydını değiştirmez")
	e.queue_free()
	await get_tree().process_frame

func _kontrol(durum: bool, mesaj: String) -> void:
	if not durum:
		hata += 1
		push_error(mesaj)
