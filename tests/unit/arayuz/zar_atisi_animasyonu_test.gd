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
	_kontrol(ZarAtisiAnimasyonu.yuz_sayisi(&"d6") == 6, "d6 yüz sayısı")
	_kontrol(ZarAtisiAnimasyonu.yuz_sayisi(&"d12") == 12, "d12 yüz sayısı")
	var d6 := ZarAtisiAnimasyonu.yuzleri_yukle(&"d6")
	_kontrol(d6.size() == 6, "altı d6 yüzü yüklenir")
	var d12 := ZarAtisiAnimasyonu.yuzleri_yukle(&"d12")
	_kontrol(d12.size() == 12, "on iki d12 yüzü yüklenir")
	_kontrol(ResourceLoader.exists(ZarAtisiAnimasyonu.yuz_yolu(&"d6", 1)), "d6 yüz 1 duruyor")
	_kontrol(ResourceLoader.exists(ZarAtisiAnimasyonu.yuz_yolu(&"d12", 12)), "d12 yüz 12 duruyor")
	var p1 := ZarAtisiAnimasyonu.parametreler(&"d6", 5, 42)
	var p2 := ZarAtisiAnimasyonu.parametreler(&"d6", 5, 43)
	_kontrol(not is_equal_approx(float(p1["vx"]), float(p2["vx"])) or not is_equal_approx(float(p1["x0"]), float(p2["x0"])), "farklı tohum farklı fırlatma")
	_kontrol(int(p1["sonuc"]) == 5, "sonuç kilitlenir")
	var son := ZarAtisiAnimasyonu.ornekle(p1, float(p1["sure"]))
	_kontrol(int(son["yuz"]) == 5, "bitişte belirlenen yüz")
	_kontrol(is_equal_approx(float(son["h"]), 0.0), "bitişte yükseklik sıfır")
	_kontrol(bool(son["bitti"]), "süre sonunda bitti")
	var orta := ZarAtisiAnimasyonu.ornekle(p1, 0.12)
	_kontrol(float(orta["h"]) > 0.05, "uçuşta yükselir")
	var yere := 0
	var onceki := 1.0
	var t := 0.0
	while t <= float(p1["t_otur"]) + 0.001:
		var s := ZarAtisiAnimasyonu.ornekle(p1, t)
		var h := float(s["h"])
		if onceki > 0.02 and h <= 0.02:
			yere += 1
		onceki = h
		t += 0.01
	_kontrol(yere >= 2, "en az iki sekişme")
	var n := ZarAtisiAnimasyonu.olustur(&"d6", 3, 7)
	_kontrol(n != null and n._yuzler.size() == 6, "olustur d6 yüzlerini kurar")
	n.queue_free()
	var n12 := ZarAtisiAnimasyonu.olustur(&"d12", 11, 9)
	_kontrol(n12 != null and n12._yuzler.size() == 12, "olustur d12 yüzlerini kurar")
	n12.queue_free()
	quit(1 if hata else 0)
