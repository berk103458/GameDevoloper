extends SceneTree

const Cerceve := preload("res://src/arayuz/gece_kapisi_cerceve.gd")
const Ipucu := preload("res://src/arayuz/yukleme_ipucu.gd")

var hata := 0

func _initialize() -> void:
	call_deferred("_calistir")

func _calistir() -> void:
	var p := Cerceve.panel()
	_kontrol(p is StyleBoxTexture, "diyalog paneli doku kutusu")
	if p is StyleBoxTexture:
		_kontrol(is_equal_approx((p as StyleBoxTexture).texture_margin_left, 112.0), "sol pay 112")
	var d := Cerceve.dugme()
	_kontrol(d is StyleBoxTexture, "düğme doku kutusu")
	if d is StyleBoxTexture:
		_kontrol((d as StyleBoxTexture).texture_margin_top < 64.0, "düğme payı 64'ün altında")
	var tr := TranslationServer.get_locale()
	seed(3)
	TranslationServer.set_locale("tr")
	var ipucu := Ipucu.metin()
	seed(3)
	TranslationServer.set_locale("en")
	var ing := Ipucu.metin()
	_kontrol(ipucu != "" and ing != "" and ipucu != ing, "aynı satırın tr ve en metni ayrı")
	TranslationServer.set_locale(tr)
	var arka := Cerceve.arka_plan("olmayan_ekran_adi")
	_kontrol(arka.get_meta("kabuk_yer_tutucu", false), "eksik arka plan yer tutucu")
	var kabuk := load("res://src/arayuz/kabuk.gd")
	var tema := load("res://src/arayuz/tema.gd")
	var yukleme := load("res://src/arayuz/varlik_yukleme_paneli.gd")
	var balon := load("res://src/arayuz/diyalog/balon.gd")
	_kontrol(kabuk != null and tema != null and yukleme != null and balon != null, "tema, kabuk, yükleme ve balon ayrışır")
	_kontrol(kabuk.panel() is StyleBoxTexture, "Kabuk.panel çerçeve döner")
	_kontrol(Cerceve.BEKLENEN.size() == 6, "altı çerçeve adı")
	_kontrol(not Cerceve.var_mi("cerceve_diyalog_seridi"), "yeni şerit yokken eski panel durur")
	_kontrol(Cerceve.kutu("cerceve_panel") == null, "yeni panel dosyası yok")
	_kontrol(Cerceve.kutu("cerceve_muhur") == null and Cerceve.kutu("cerceve_rumi_kose") == null, "mühür ve rumi yokken eklenmez")
	_kontrol(load("res://src/arayuz/ayarlar_ekrani.gd") != null, "ayarlar ekranı ayrışır")
	_kontrol(load("res://src/arayuz/heybe_paneli.gd") != null, "heybe paneli ayrışır")
	_kontrol(load("res://src/arayuz/chr_inceleme_paneli.gd") != null, "portre incelemesi ayrışır")
	_kontrol(load("res://src/arayuz/defter_gorunumu.gd") != null, "defter görünümü ayrışır")
	arka.free()
	print("GECE KAPISI ÇERÇEVE: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)

func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
