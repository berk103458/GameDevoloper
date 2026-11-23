## Çalıştırma: godot --headless --path . -s tests/unit/arayuz/yalan_muhur_animasyonu_test.gd
extends SceneTree

var hata := 0


func _initialize() -> void:
	call_deferred("_calistir")


func _kontrol(v: bool, ad: String) -> void:
	if not v:
		push_error(ad)
		hata += 1


func _calistir() -> void:
	_kontrol(ResourceLoader.exists("res://assets/art/anim/muhur_bas_01.png"), "mühür kare 01 duruyor")
	var kareler := KareAnimasyonKabuk.yukle_kareler_on_ekli(YalanMuhurAnimasyonu.KOK, "muhur_bas_", YalanMuhurAnimasyonu.KARE_SAYISI)
	_kontrol(kareler.size() == YalanMuhurAnimasyonu.KARE_SAYISI, "dört mühür karesi yüklenir")
	var n := YalanMuhurAnimasyonu.olustur()
	_kontrol(n != null and n._kareler.size() == YalanMuhurAnimasyonu.KARE_SAYISI, "olustur kare dizisini kurar")
	_kontrol(n._kucuk_ikon, "mühür küçük ikon kutusu")
	n.queue_free()
	quit(1 if hata else 0)
