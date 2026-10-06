## HUD net değişimi, maliyet kapısı, kategori kaydırması ve duraklatmadan dönüş için entegrasyon testi.
extends Node

var _hata := 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	call_deferred("_dene")

func _dene() -> void:
	TranslationServer.set_locale("tr")
	var k := Katalog.new()
	k.yukle()
	var o := Oturum.new(k, 21)
	var a := Ayarlar.new()
	var ana := Control.new()
	ana.theme = Tema.olustur(a)
	get_tree().root.add_child(ana)
	var e := KoyEkrani.new()
	e.oturum = o
	e.ayarlar = a
	ana.add_child(e)
	await get_tree().process_frame
	var once := o.yonetim.akce
	o.yonetim.akce += 3
	o.yonetim.gun += 1
	e.hud.guncelle()
	_dogrula(e.hud._akce._miktar.text == str(once + 3), "Akçe güncellendi")
	_dogrula(e.hud._akce._net.text == "+3", "Akçe net değişimi")
	e.hud.guncelle()
	_dogrula(e.hud._akce._net.text == "+3", "Aynı gün yenileme neti korur")
	e._hiz_sec(3)
	_dogrula(Engine.time_scale == 3.0 and not get_tree().paused, "3x çalışıyor")
	var bosluk := InputEventKey.new()
	bosluk.physical_keycode = KEY_SPACE
	bosluk.pressed = true
	e._unhandled_input(bosluk)
	_dogrula(get_tree().paused and e.can_process(), "Duraklamada UI çalışıyor")
	_dogrula(not e.sahne3b.can_process(), "Duraklamada dünya duruyor")
	e._unhandled_input(bosluk)
	_dogrula(not get_tree().paused and Engine.time_scale == 3.0, "Son hızda sürüyor")
	e._hiz_sec(1)
	e._kategori = "uretim"
	e._yapi_satirini_ciz()
	_dogrula(e._yapi_satiri.get_child_count() == o.yonetim.katalog.kategoridekiler("uretim").size(), "Üretim kartlarının tamamı var")
	_dogrula(e._yapi_satiri.get_parent() is ScrollContainer, "Kartlar kaydırılabilir")
	var kart := YapiKarti.new()
	ana.add_child(kart)
	o.yonetim.kaynaklar.stok.clear()
	kart.kur("kulube", o.yonetim, a)
	_dogrula(kart.disabled, "Yetersiz malzeme inşayı engeller")
	e._hiz_sec(0)
	e.queue_free()
	await get_tree().process_frame
	_dogrula(not get_tree().paused and Engine.time_scale == 1.0, "Ekrandan çıkış zamanı sıfırlar")
	ana.queue_free()
	await get_tree().process_frame
	print("KOY HUD TEST: %s (%d hata)" % ["GEÇTİ" if _hata == 0 else "KALDI", _hata])
	get_tree().quit(0 if _hata == 0 else 1)

func _dogrula(olur: bool, ad: String) -> void:
	if not olur:
		_hata += 1
		push_error(ad)
