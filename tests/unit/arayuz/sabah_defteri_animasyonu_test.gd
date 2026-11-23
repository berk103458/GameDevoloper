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
	_kontrol(ResourceLoader.exists(SabahDefteriAnimasyonu.kare_yolu("kapali.png")), "kapalı defter duruyor")
	_kontrol(ResourceLoader.exists(SabahDefteriAnimasyonu.kare_yolu("kapak_yarim.png")), "yarı açık kapak duruyor")
	_kontrol(ResourceLoader.exists(SabahDefteriAnimasyonu.kare_yolu("kapak_sola.png")), "sola düşen kapak duruyor")
	_kontrol(ResourceLoader.exists(SabahDefteriAnimasyonu.kare_yolu("acik.png")), "açık defter duruyor")
	var kareler := SabahDefteriAnimasyonu.kareleri_yukle()
	_kontrol(kareler.size() == SabahDefteriAnimasyonu.KAPAK.size(), "dört destek karesi yüklenir")
	var k0 := SabahDefteriAnimasyonu.kapak_karisimi(0.0)
	_kontrol(int(k0["a"]) == 0 and float(k0["k"]) == 0.0, "başta kapalı kare")
	var k_son := SabahDefteriAnimasyonu.kapak_karisimi(2.0)
	_kontrol(int(k_son["b"]) == 3, "süre sonunda açık kare")
	var s0 := SabahDefteriAnimasyonu.sayfa_kat(0.5)
	_kontrol(not bool(s0["gorunur"]), "kapak açılırken sayfa kıvrımı yok")
	var s1 := SabahDefteriAnimasyonu.sayfa_kat(SabahDefteriAnimasyonu.SAYFA_BAS + 0.1)
	_kontrol(bool(s1["gorunur"]) and float(s1["kat"]) > 0.0, "açıldıktan sonra sayfa kıvrılır")
	var n := SabahDefteriAnimasyonu.olustur("3. gün")
	_kontrol(n != null and n._kareler.size() == 4, "olustur destek karelerini kurar")
	_kontrol(n._kayit == "3. gün", "kayıt metni saklanır")
	n.queue_free()
	quit(1 if hata else 0)
