## TEK-23: gece kilidi (gece_gecis_kilidi) alındığında hız 1'de tutulur.
## Kilit varken 3x/2x/durdurma isteği 1x'e çekilir; "boş gün" (kilit yok) hız seçimi
## köy ekranınındır, kapı/gece kilidi uygulanmaz. KoyEkrani kodu yeniden yazılmaz.
## Not: -s birim koşusunda Ses autoload'una statik bağımlılık kuramamak için KoyEkrani tipi
## çalışma anında load() ile alınır (ambar_kapisi_paneli.gd'deki ördek tipleme kuralı).
extends SceneTree

var hata := 0

func _initialize() -> void:
	call_deferred("_calistir")

func _calistir() -> void:
	var katalog := Katalog.new()
	katalog.yukle()
	var ayarlar := Ayarlar.new()
	var ekran_tipi: GDScript = load("res://src/arayuz/koy_ekrani.gd")
	var ekran: Node = ekran_tipi.new()
	ekran.oturum = Oturum.new(katalog, 4213)
	ekran.ayarlar = ayarlar
	ekran.theme = Tema.olustur(ayarlar)
	root.add_child(ekran)
	await process_frame

	_kontrol(not ekran._gece_kilidi.kilitli(), "Gece kilidi başlangıçta kapalı")
	ekran._hiz_sec(3)
	_kontrol(Engine.time_scale == 3.0 and not paused, "Kilitsiz günde 3x hız seçilebilir; kilit uygulanmaz")

	_kontrol(ekran._gece_kilidi.al(), "Gece hesaplaşması kilidi alındı")
	_kontrol(ekran._gece_kilidi.kilitli(), "Kilit alındıktan sonra kilitli")
	for kat in [3, 2, 1, 0]:
		ekran._hiz_sec(kat)
		_kontrol(Engine.time_scale == 1.0 and not paused, "Kilitliyken %d isteği 1x'e çekilir" % kat)

	root.remove_child(ekran)
	ekran.free()
	ekran = null
	ekran_tipi = null
	ayarlar = null
	katalog = null
	await process_frame
	await process_frame
	await create_timer(0.5).timeout
	print("HIZ GECE KILIDI: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)

func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)