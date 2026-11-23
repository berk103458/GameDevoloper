## Çalıştırma: godot --headless --path . -s tests/unit/arayuz/rusvet_kesesi_animasyonu_test.gd
extends SceneTree

var hata := 0


func _initialize() -> void:
	call_deferred("_calistir")


func _kontrol(v: bool, ad: String) -> void:
	if not v:
		push_error(ad)
		hata += 1


func _calistir() -> void:
	_kontrol(ResourceLoader.exists(RusvetKesesiAnimasyonu.KOK + "kare_01.png"), "kese kare 01 duruyor")
	var kareler := KareAnimasyonKabuk.yukle_kareler(RusvetKesesiAnimasyonu.KOK, RusvetKesesiAnimasyonu.KARE_SAYISI)
	_kontrol(kareler.size() == RusvetKesesiAnimasyonu.KARE_SAYISI, "sekiz kese karesi yüklenir")
	var n := RusvetKesesiAnimasyonu.olustur()
	_kontrol(n != null and n._kareler.size() == RusvetKesesiAnimasyonu.KARE_SAYISI, "olustur kare dizisini kurar")
	_kontrol(not n._kucuk_ikon, "kese tam sahne kabuğudur")
	n.queue_free()
	var yok := KareAnimasyonKabuk.yukle_kareler("res://yok_kese/", 8)
	_kontrol(yok.is_empty(), "eksik yolda kare yüklenmez")
	quit(1 if hata else 0)
