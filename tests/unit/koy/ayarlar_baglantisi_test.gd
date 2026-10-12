## AYR-06: ayarlar oyun içinden ve menüden aynı `AyarlarEkrani` ekranıdır; köy hızı açılışta
## saklanır, kapanışta geri gelir. KoyEkrani tipi -s koşusunda derleme anında Ses autoload'una
## bağlanmasın diye load() ile alınır (ambar_kapisi_paneli.gd ördek tipleme kuralı).
extends SceneTree

var hata := 0


func _initialize() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	var bag: GDScript = load("res://src/arayuz/koy_hud/ayarlar_baglantisi.gd")
	var katalog := Katalog.new()
	katalog.yukle()
	var ayarlar := Ayarlar.new("user://test_ayarlar_baglantisi.cfg")
	var ekran_tipi: GDScript = load("res://src/arayuz/koy_ekrani.gd")
	var ekran: Node = ekran_tipi.new()
	ekran.oturum = Oturum.new(katalog, 4213)
	ekran.ayarlar = ayarlar
	ekran.theme = Tema.olustur(ayarlar)
	root.add_child(ekran)
	await process_frame
	await process_frame

	# 1) Eylem sütununda tek ayar düğmesi; kur() ikinci kez düğme çoğaltmaz.
	var dugmeler := ekran.find_children("ayarlar_ac", "Button", true, false)
	_kontrol(dugmeler.size() == 1, "AYR-06: oyun içinde tek ayar düğmesi")
	var dugme: Button = dugmeler[0]
	_kontrol(dugme.text == TranslationServer.translate("arayuz.menu.ayarlar"), "AYR-06: düğme metni çeviri anahtarından gelir")
	bag.kur(ekran, dugme.get_parent())
	_kontrol(ekran.find_children("ayarlar_ac", "Button", true, false).size() == 1, "AYR-06: kur() ikinci kez düğme eklemez")

	# 2) Oyun içinde açılış: köy hızı saklanır, ekran aynı AyarlarEkrani'dır.
	ekran._hiz_sec(2)
	_kontrol(Engine.time_scale == 2.0 and not paused, "AYR-06: köy 2x hızda")
	var a = bag.ac(ekran)
	_kontrol(a != null and a is AyarlarEkrani, "AYR-06: açılan ekran AyarlarEkrani")
	_kontrol(ekran.has_node("AyarlarEkrani") and a.name == "AyarlarEkrani", "AYR-06: ekran köyün üstünde tek örnek")
	_kontrol(Engine.time_scale == 1.0 and paused, "AYR-06: açılışta köy hızı saklanır (oyun duraklar)")
	_kontrol(a.process_mode == Node.PROCESS_MODE_ALWAYS, "AYR-06: duraklamış oyunda ayar ekranı çalışır")
	_kontrol(bag.ac(ekran) == null, "AYR-06: ikinci örnek açılmaz")

	# 3) Düğme gerçekten aynı ekranı açar; kapanışta hız geri gelir.
	a._kapat()
	await process_frame
	await process_frame
	_kontrol(ekran.get_node_or_null("AyarlarEkrani") == null, "AYR-06: kapanışta ekran gider")
	_kontrol(Engine.time_scale == 2.0 and not paused, "AYR-06: oyun içinde açılıp kapanınca Engine.time_scale eşit")
	dugme.pressed.emit()
	await process_frame
	_kontrol(ekran.get_node_or_null("AyarlarEkrani") != null, "AYR-06: düğme aynı ekranı açar")
	(ekran.get_node("AyarlarEkrani") as AyarlarEkrani)._kapat()
	await process_frame
	await process_frame
	_kontrol(Engine.time_scale == 2.0 and not paused, "AYR-06: düğme yolunda da hız geri gelir")

	# 4) Gece kilidi açıkken ayar ekranı açılmaz (harita/oda kalıbı).
	ekran._gece_kilidi.al()
	_kontrol(bag.ac(ekran) == null, "AYR-06: gece kilidinde ayar ekranı açılmaz")

	# 5) Menü ve duraklat menüsü aynı AyarlarEkrani'yı açar (satır bazlı kaynak taraması).
	var ekran_ekrani := false
	var menu_yolu := false
	var duraklat_yolu := false
	for satir in FileAccess.get_file_as_string("res://src/arayuz/ana.gd").split("\n"):
		if "AyarlarEkrani.new()" in satir:
			ekran_ekrani = true
		if "_ayarlari_ac(ana_menu)" in satir:
			menu_yolu = true
		if "_ayarlari_ac(_duraklat" in satir:
			duraklat_yolu = true
	_kontrol(ekran_ekrani and menu_yolu and duraklat_yolu, "AYR-06: ana menü ve Esc/duraklat menüsü aynı AyarlarEkrani'yı açar")

	root.remove_child(ekran)
	ekran.free()
	ekran = null
	ekran_tipi = null
	bag = null
	ayarlar = null
	katalog = null
	await process_frame
	await process_frame
	await create_timer(0.5).timeout
	print("AYARLAR BAGLANTISI: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)


func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
