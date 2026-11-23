## Çalıştırma: godot --headless --path . -s tests/unit/arayuz/sabah_defteri_animasyonu_test.gd
extends SceneTree

var hata := 0


func _initialize() -> void:
	call_deferred("_calistir")


func _kontrol(v: bool, ad: String) -> void:
	if not v:
		push_error(ad)
		hata += 1


func _calistir() -> void:
	_kontrol(ResourceLoader.exists(SabahDefteriAnimasyonu.KOK + "kare_01.png"), "defter kare 01 duruyor")
	_kontrol(ResourceLoader.exists(SabahDefteriAnimasyonu.KOK + "kare_09.png"), "defter kare 09 duruyor")
	var kareler := KareAnimasyonKabuk.yukle_kareler(SabahDefteriAnimasyonu.KOK, SabahDefteriAnimasyonu.KARE_SAYISI)
	_kontrol(kareler.size() == SabahDefteriAnimasyonu.KARE_SAYISI, "dokuz defter karesi yüklenir")
	var n := SabahDefteriAnimasyonu.olustur()
	_kontrol(n != null and n._kareler.size() == SabahDefteriAnimasyonu.KARE_SAYISI, "olustur kare dizisini kurar")
	_kontrol(not n._kucuk_ikon, "defter tam sahne kabuğudur")
	n.queue_free()
	quit(1 if hata else 0)
