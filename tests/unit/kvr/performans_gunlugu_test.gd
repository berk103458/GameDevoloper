extends SceneTree

var hata := 0
var kontrol_sayisi := 0

func _initialize() -> void:
	call_deferred("_calistir")

func _calistir() -> void:
	var p := PerformansGunlugu.new()
	p.etkin = false
	root.add_child(p)
	_kontrol(not p.is_processing(), "Kapalı günlük sayaç sorgulamaz")
	for fps in [90, 10, 40]: p.olcum_ekle({"fps": fps, "kare_ms": fps / 10.0})
	var ozet := p.ozet(2097152)
	_kontrol(ozet.fps_ortanca == 40.0 and ozet.kare_ms_azami == 9.0 and ozet.bellek_mb == 2.0, "Tek örnek sayısı, gerçek azami ve MiB hesabı")
	p.olcum_ekle({"fps": 20, "kare_ms": 1.0})
	_kontrol(p.ozet(null).fps_ortanca == 30.0 and p.ozet(null).bellek_mb == null, "Çift örnekte iki ortanın ortalaması; bilinmeyen RAM null")
	_kontrol(PerformansGunlugu.ortanca({30.0: 9, 90.0: 1}) == 30.0, "Tekrarlanan FPS frekansı korunur")
	_kontrol(PerformansGunlugu.ortanca({10.0: 2, 20.0: 2}) == 15.0, "İki orta değer farklı frekans gruplarında")
	_kontrol(PerformansGunlugu.ortanca({}) == 0.0, "Boş örnek güvenli")
	var adet := p.olcum_sayisi
	for olcum in [{"fps": NAN, "kare_ms": 1}, {"fps": 1, "kare_ms": INF}, {"fps": -1, "kare_ms": 1}, {"fps": "30", "kare_ms": 1}, {}]:
		p.olcum_ekle(olcum)
	_kontrol(p.olcum_sayisi == adet, "Geçersiz ölçüm JSON'a NaN/sahte sayı taşımaz")
	var varsayilan := PerformansGunlugu.esikleri_oku(PerformansGunlugu.VARSAYILAN)
	_kontrol(PerformansGunlugu.esikleri_oku("user://olmayan_teknik.json") == varsayilan, "Eksik ayar veri dosyasındaki varsayılanla sürer")
	var yol := "user://teknik_bozuk_test.json"
	for metin in ["{bozuk", "[]", '{"performans_gunlugu":null}', '{"performans_gunlugu":{"fps_ortanca_en_az":"30","kare_ms_azami":-1}}']:
		_yaz(yol, metin)
		_kontrol(PerformansGunlugu.esikleri_oku(yol) == varsayilan, "Bozuk JSON/şema/alan varsayılana döner")
	_yaz(yol, '{"performans_gunlugu":{"fps_ortanca_en_az":1234}}')
	var ozel := PerformansGunlugu.esikleri_oku(yol)
	_kontrol(ozel.fps_ortanca_en_az == 1234.0 and ozel.kare_ms_azami == varsayilan.kare_ms_azami, "Geçerli tek alan korunur; eksik alan veri varsayılanıdır")
	DirAccess.remove_absolute(yol)
	p.dosya_yolu = "user://performans_kapali_test.jsonl"
	DirAccess.remove_absolute(p.dosya_yolu)
	p.gece_yaz(1)
	_kontrol(not FileAccess.file_exists(p.dosya_yolu), "Açma bayrağı kapalıysa gece dosya açmaz (TEK-11 export testi ayrı)")
	p.free()
	# Farklı geceler arasında ortanca/azami birikmez; aynı gece tekrarı ve dördüncü gece yok.
	p = PerformansGunlugu.new()
	p.dosya_yolu = "user://performans_birim_test.jsonl"
	DirAccess.remove_absolute(p.dosya_yolu)
	p.esikler = {"fps_ortanca_en_az": 1e12, "kare_ms_azami": 1e12}
	root.add_child(p)
	for gece in 3:
		p.olcum_ekle({"fps": 10, "kare_ms": 77})
		p.gece_yaz(gece + 1)
		_kontrol(p.olcum_sayisi == 0 and p.ozet(null).kare_ms_azami == 0, "Gece örnekleri sıfırlanır")
		p.gece_yaz(gece + 1)
	p.gece_yaz(4)
	_kontrol(p.satir_sayisi == 3 and p.uyari_sayisi == 1 and not p.is_processing(), "Üç gecede durur, tekrar yazmaz; eşik uyarısı bir kez")
	DirAccess.remove_absolute(p.dosya_yolu)
	p.free()
	# FPS alt sınırı ile kare tavanı birbirinden bağımsız, eşitlik kabul edilir.
	p = PerformansGunlugu.new()
	p.esikler = {"fps_ortanca_en_az": 30.0, "kare_ms_azami": 10.0}
	_kontrol(not p.esik_asildi({"fps_ortanca": 30.0, "kare_ms_azami": 10.0}), "FPS alt sınırı ve kare tavanına eşitlik kabul edilir")
	_kontrol(p.esik_asildi({"fps_ortanca": 30.0, "kare_ms_azami": 11.0}), "Yalnız kare tavanı üstü uyarır")
	_kontrol(p.esik_asildi({"fps_ortanca": 29.0, "kare_ms_azami": 10.0}), "Yalnız FPS alt sınırı altı uyarır")
	p.free()
	print("PERFORMANS GÜNLÜĞÜ BİRİM: %d kontrol / %s" % [kontrol_sayisi, "GEÇTİ" if hata == 0 else "KALDI"])
	quit(hata)

func _yaz(yol: String, metin: String) -> void:
	var dosya := FileAccess.open(yol, FileAccess.WRITE)
	dosya.store_string(metin)

func _kontrol(olur: bool, metin: String) -> void:
	kontrol_sayisi += 1
	if not olur:
		hata += 1
		push_error(metin)
