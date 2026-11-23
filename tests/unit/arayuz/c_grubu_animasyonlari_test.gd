## Çalıştırma: godot --headless --path . -s tests/unit/arayuz/c_grubu_animasyonlari_test.gd
extends SceneTree

var hata := 0


func _initialize() -> void:
	call_deferred("_calistir")


func _kontrol(v: bool, ad: String) -> void:
	if not v:
		push_error(ad)
		hata += 1


func _calistir() -> void:
	for i in 4:
		_kontrol(ResourceLoader.exists(KandilAleviAnimasyonu.kare_yolu(i)), "C1/C2 kandil %d" % (i + 1))
	var k0 := KandilAleviAnimasyonu.dongu_karisimi(0.0)
	var kson := KandilAleviAnimasyonu.dongu_karisimi(KandilAleviAnimasyonu.PERIYOT - 0.001)
	_kontrol(int(k0["a"]) == 0, "C1 döngü başı ilk kare")
	_kontrol(int(kson["b"]) == 0, "C1 döngü sonu ilk kareye bağlanır")
	var korta := KandilAleviAnimasyonu.dongu_karisimi(KandilAleviAnimasyonu.PERIYOT * 0.5)
	_kontrol(int(korta["a"]) == 3 or int(korta["b"]) == 3, "C1 ortada yüksek alev")
	_kontrol(KandilAleviAnimasyonu.alev_olcek(0.2) != KandilAleviAnimasyonu.alev_olcek(1.1), "C1 ölçek titreşir")
	var kok := Control.new()
	root.add_child(kok)
	kok.size = Vector2(1920, 1080)
	var lamba := KandilAleviAnimasyonu.yerlestir(kok)
	_kontrol(lamba != null, "C1 yerlestir")
	if lamba:
		lamba.queue_free()

	_kontrol(ResourceLoader.exists("res://assets/ui/koy/cenaze_ortusu/katli.png"), "C3 katlı")
	_kontrol(ResourceLoader.exists("res://assets/ui/koy/cenaze_ortusu/ortulu.png"), "C3 örtülü")
	var c3 := CenazeOrtusuAnimasyonu.olustur()
	_kontrol(c3 != null and c3._plakalar.size() == 2, "C3 olustur")
	if c3:
		c3.queue_free()

	_kontrol(ResourceLoader.exists("res://assets/ui/koy/karantina_isareti/asili.png"), "C4 asılı")
	var y0 := KarantinaIsaretiAnimasyonu.isaret_ornek(0.0)
	var y1 := KarantinaIsaretiAnimasyonu.isaret_ornek(1.85)
	_kontrol(float(y0["y"]) < -0.2, "C4 başta yukarıda")
	_kontrol(absf(float(y1["y"])) < 0.03, "C4 sonda asılı oturur")
	var c4 := KarantinaIsaretiAnimasyonu.olustur()
	_kontrol(c4 != null, "C4 olustur")
	if c4:
		c4.queue_free()

	_kontrol(ResourceLoader.exists("res://assets/ui/koy/sabah_defteri/acik.png"), "C5 açık (A6 paylaşımı)")
	_kontrol(ResourceLoader.exists("res://assets/ui/koy/sabah_defteri/kapali.png"), "C5 kapalı (A6 paylaşımı)")
	_kontrol(ResourceLoader.exists("res://assets/ui/koy/perde_defteri/muhurlu.png"), "C5 mühürlü")
	_kontrol(PerdeDefteriAnimasyonu.yazi_alfa(1.0) == 0.0, "C5 yazı erken gizli")
	_kontrol(PerdeDefteriAnimasyonu.yazi_alfa(3.0) >= 0.99, "C5 yazı sonda görünür")
	var c5 := PerdeDefteriAnimasyonu.olustur(PackedStringArray(["1. Perde Sonu"]))
	_kontrol(c5 != null and c5._plakalar.size() == 3, "C5 olustur")
	if c5:
		c5.queue_free()

	_kontrol(ResourceLoader.exists("res://assets/ui/menu/yeni_oyun_berati/katli.png"), "C6 katlı")
	_kontrol(ResourceLoader.exists("res://assets/ui/menu/yeni_oyun_berati/uzatilmis.png"), "C6 uzatılmış")
	_kontrol(not ResourceLoader.exists("res://assets/ui/menu/yeni_oyun_berati/kare_01.png"), "C6 ulak 9 kare seti yok")
	var u0 := YeniOyunBeratiAnimasyonu.uzatma_ornek(0.0)
	var u1 := YeniOyunBeratiAnimasyonu.uzatma_ornek(1.70)
	_kontrol(float(u0["olcek"]) < float(u1["olcek"]), "C6 muhafıza doğru büyür")
	_kontrol(is_equal_approx(float(u1["olcek"]), 1.0) or float(u1["olcek"]) > 0.98, "C6 sonda oturur")
	var c6 := YeniOyunBeratiAnimasyonu.olustur()
	_kontrol(c6 != null and c6._plakalar.size() == 2, "C6 olustur")
	if c6:
		c6.queue_free()

	kok.queue_free()
	if hata == 0:
		print("C grubu animasyon testleri geçti")
	else:
		print("C grubu animasyon testleri başarısız: %d" % hata)
	quit(hata)
