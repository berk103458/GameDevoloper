## Çalıştırma: godot --headless --path . -s tests/unit/arayuz/zar_atisi_animasyonu_test.gd
extends SceneTree

var hata := 0


func _initialize() -> void:
	call_deferred("_calistir")


func _kontrol(v: bool, ad: String) -> void:
	if not v:
		push_error(ad)
		hata += 1


func _calistir() -> void:
	_kontrol(ZarAtisiAnimasyonu.kare_on_eki(&"d6") == "zar_d6_roll_", "d6 ön eki")
	_kontrol(ZarAtisiAnimasyonu.kare_on_eki(&"d12") == "zar_d12_roll_", "d12 ön eki")
	_kontrol(ResourceLoader.exists("res://assets/art/anim/zar_d6_roll_01.png"), "d6 kare 01 duruyor")
	_kontrol(ResourceLoader.exists("res://assets/art/anim/zar_d12_roll_01.png"), "d12 kare 01 duruyor")
	var d6 := KareAnimasyonKabuk.yukle_kareler_on_ekli(ZarAtisiAnimasyonu.KOK, "zar_d6_roll_", ZarAtisiAnimasyonu.KARE_SAYISI)
	_kontrol(d6.size() == ZarAtisiAnimasyonu.KARE_SAYISI, "dört d6 karesi yüklenir")
	var d12 := KareAnimasyonKabuk.yukle_kareler_on_ekli(ZarAtisiAnimasyonu.KOK, "zar_d12_roll_", ZarAtisiAnimasyonu.KARE_SAYISI)
	_kontrol(d12.size() == ZarAtisiAnimasyonu.KARE_SAYISI, "dört d12 karesi yüklenir")
	var yok := KareAnimasyonKabuk.yukle_kareler_on_ekli("res://yok_anim/", "zar_d6_roll_", 4)
	_kontrol(yok.is_empty(), "eksik yolda kare yüklenmez")
	var n := ZarAtisiAnimasyonu.olustur(&"d6")
	_kontrol(n != null and n._kareler.size() == ZarAtisiAnimasyonu.KARE_SAYISI, "olustur d6 kare dizisini kurar")
	_kontrol(n._kucuk_ikon, "d6 küçük ikon kutusu")
	n.queue_free()
	var n12 := ZarAtisiAnimasyonu.olustur(&"d12")
	_kontrol(n12 != null and n12._kareler.size() == ZarAtisiAnimasyonu.KARE_SAYISI, "olustur d12 kare dizisini kurar")
	n12.queue_free()
	quit(1 if hata else 0)
