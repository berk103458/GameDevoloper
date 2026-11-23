## Çalıştırma: godot --headless --path . -s tests/unit/arayuz/kapi_surgu_animasyonu_test.gd
extends SceneTree

var hata := 0


func _initialize() -> void:
	call_deferred("_calistir")


func _kontrol(v: bool, ad: String) -> void:
	if not v:
		push_error(ad)
		hata += 1


func _calistir() -> void:
	_kontrol(KapiSurguAnimasyonu.kare_kok(true) == "res://assets/ui/kapi/surgu/kabul/", "kabul kökü")
	_kontrol(KapiSurguAnimasyonu.kare_kok(false) == "res://assets/ui/kapi/surgu/ret/", "ret kökü")
	_kontrol(ResourceLoader.exists(KapiSurguAnimasyonu.kare_kok(true) + "kare_01.png"), "kabul kare 01 duruyor")
	_kontrol(ResourceLoader.exists(KapiSurguAnimasyonu.kare_kok(false) + "kare_01.png"), "ret kare 01 duruyor")
	var kabul := KareAnimasyonKabuk.yukle_kareler(KapiSurguAnimasyonu.kare_kok(true), KapiSurguAnimasyonu.KARE_SAYISI)
	_kontrol(kabul.size() == KapiSurguAnimasyonu.KARE_SAYISI, "sekiz kabul karesi yüklenir")
	var ret := KareAnimasyonKabuk.yukle_kareler(KapiSurguAnimasyonu.kare_kok(false), KapiSurguAnimasyonu.KARE_SAYISI)
	_kontrol(ret.size() == KapiSurguAnimasyonu.KARE_SAYISI, "sekiz ret karesi yüklenir")
	var n := KapiSurguAnimasyonu.olustur(true)
	_kontrol(n != null and n._kareler.size() == KapiSurguAnimasyonu.KARE_SAYISI, "olustur kabul dizisini kurar")
	n.queue_free()
	var n2 := KapiSurguAnimasyonu.olustur(false)
	_kontrol(n2 != null and n2._kareler.size() == KapiSurguAnimasyonu.KARE_SAYISI, "olustur ret dizisini kurar")
	n2.queue_free()
	quit(1 if hata else 0)
