## Çalıştırma: godot --headless --path . -s tests/unit/arayuz/b_grubu_animasyonlari_test.gd
extends SceneTree

var hata := 0


func _initialize() -> void:
	call_deferred("_calistir")


func _kontrol(v: bool, ad: String) -> void:
	if not v:
		push_error(ad)
		hata += 1


func _calistir() -> void:
	_kontrol(ResourceLoader.exists("res://assets/ui/kapi/evrak/kapali.png"), "B1 kapalı")
	_kontrol(ResourceLoader.exists("res://assets/ui/kapi/evrak/flap.png"), "B1 flap")
	_kontrol(ResourceLoader.exists("res://assets/ui/kapi/evrak/acik.png"), "B1 açık")
	_kontrol(EvrakAnimasyonu.kagit_mi("Yol tezkiresi ve ferman"), "B1 kâğıt algılar")
	_kontrol(not EvrakAnimasyonu.kagit_mi("sadece deri torba"), "B1 deriyi evrak saymaz")
	var b1 := EvrakAnimasyonu.olustur("berat")
	_kontrol(b1 != null and b1._plakalar.size() == 3, "B1 olustur")
	b1.queue_free()

	_kontrol(ResourceLoader.exists("res://assets/ui/hafiza/sayfa/acik.png"), "B2 açık defter")
	var b2 := HafizaSayfasiAnimasyonu.olustur()
	_kontrol(b2 != null, "B2 olustur")
	b2.queue_free()

	_kontrol(ResourceLoader.exists("res://assets/ui/koy/olay_karti/katli.png"), "B3 katlı")
	_kontrol(ResourceLoader.exists("res://assets/ui/koy/olay_karti/acik.png"), "B3 açık")
	var b3 := OlayKartiAnimasyonu.olustur()
	_kontrol(b3 != null and b3._plakalar.size() == 2, "B3 olustur")
	b3.queue_free()

	_kontrol(ResourceLoader.exists("res://assets/ui/ulak/ferman/sarili.png"), "B4 sarılı")
	_kontrol(ResourceLoader.exists("res://assets/ui/ulak/ferman/muhur_kirik.png"), "B4 mühür kırık")
	_kontrol(ResourceLoader.exists("res://assets/ui/ulak/ferman/acik.png"), "B4 açık")
	var b4 := SancakFermaniAnimasyonu.olustur()
	_kontrol(b4 != null and b4._plakalar.size() == 3, "B4 olustur")
	b4.queue_free()

	_kontrol(ResourceLoader.exists("res://assets/art/anim/kese_sikkesi_01.png"), "B5 kese 1")
	_kontrol(ResourceLoader.exists("res://assets/art/anim/kese_sikkesi_04.png"), "B5 kese 4")
	_kontrol(ResourceLoader.exists("res://assets/ui/koy/akce_sayimi/akce.png"), "B5 akçe")
	var b5 := AkceSayimiAnimasyonu.olustur(11)
	_kontrol(b5 != null, "B5 olustur")
	var p0 := AkceSayimiAnimasyonu.para_ornek(0, 1.6, 11)
	var p9 := AkceSayimiAnimasyonu.para_ornek(9, 1.6, 11)
	_kontrol(bool(p0["gorunur"]) and bool(p9["gorunur"]), "B5 sonunda görünür")
	_kontrol(float(p0["x"]) < 0.5 and float(p9["x"]) > 0.5, "B5 iki yığın")
	_kontrol(float(p0["h"]) <= 0.05, "B5 sonunda yere oturur")
	b5.queue_free()

	_kontrol(ResourceLoader.exists("res://assets/ui/koy/kayit_muhuru/masa.png"), "B6 masa")
	_kontrol(ResourceLoader.exists("res://assets/ui/koy/kayit_muhuru/muhur.png"), "B6 mühür")
	var b6 := KayitMuhuruAnimasyonu.olustur()
	_kontrol(b6 != null, "B6 olustur")
	var m0 := KayitMuhuruAnimasyonu.muhur_ornek(0.0)
	var m1 := KayitMuhuruAnimasyonu.muhur_ornek(1.4)
	_kontrol(float(m0["y"]) < -0.1, "B6 başta havada")
	_kontrol(is_equal_approx(float(m1["y"]), 0.0), "B6 sonda basılı")
	b6.queue_free()

	_kontrol(ResourceLoader.exists("res://assets/ui/oda/vicdan_terazisi/ayak.png"), "B7 ayak")
	_kontrol(ResourceLoader.exists("res://assets/ui/oda/vicdan_terazisi/kol.png"), "B7 kol")
	_kontrol(VicdanTerazisiAnimasyonu.hedef_aci(20) < 0.0, "B7 yoz sola")
	_kontrol(VicdanTerazisiAnimasyonu.hedef_aci(90) > 0.0, "B7 adil sağa")
	var a0 := VicdanTerazisiAnimasyonu.kol_aci(0.0, 16.0)
	var a1 := VicdanTerazisiAnimasyonu.kol_aci(1.6, 16.0)
	_kontrol(absf(a0) < absf(16.0), "B7 başta salınım")
	_kontrol(absf(a1 - 16.0) < 3.0, "B7 sonda hedefe oturur")
	var b7 := VicdanTerazisiAnimasyonu.olustur(80)
	_kontrol(b7 != null, "B7 olustur")
	b7.queue_free()

	_kontrol(ResourceLoader.exists("res://assets/art/anim/tansiyon_catlak_01.png"), "B8 çatlak 1")
	_kontrol(ResourceLoader.exists("res://assets/art/anim/tansiyon_catlak_04.png"), "B8 çatlak 4")
	var b8 := TansiyonCatlamasiAnimasyonu.olustur()
	_kontrol(b8 != null, "B8 olustur")
	b8.queue_free()

	_kontrol(ResourceLoader.exists("res://assets/ui/kapi/kavga_gerilim/uzak.png"), "B9 uzak")
	_kontrol(ResourceLoader.exists("res://assets/ui/kapi/kavga_gerilim/kabza.png"), "B9 kabza")
	var b9 := KavgaGerilimAnimasyonu.olustur()
	_kontrol(b9 != null and b9._plakalar.size() == 2, "B9 olustur")
	b9.queue_free()

	_kontrol(ResourceLoader.exists("res://assets/ui/harita/rulo/sarili.png"), "B10 sarılı")
	_kontrol(ResourceLoader.exists("res://assets/ui/harita/rulo/acik.png"), "B10 açık")
	var ac0 := HaritaRulosuAnimasyonu.acilma(0.0)
	var ac1 := HaritaRulosuAnimasyonu.acilma(2.0)
	_kontrol(ac0 < 0.05, "B10 başta kapalı")
	_kontrol(ac1 > 0.95, "B10 sonda açık")
	var b10 := HaritaRulosuAnimasyonu.olustur()
	_kontrol(b10 != null, "B10 olustur")
	b10.queue_free()

	quit(1 if hata else 0)
