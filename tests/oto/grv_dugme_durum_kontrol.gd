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

func _kontrol(durum: bool, mesaj: String) -> void:
	if not durum:
		hata += 1
		push_error(mesaj)
