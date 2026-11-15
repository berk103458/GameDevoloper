## CAT-02: gerçek ret, kalıcı söz/kuyruk, bakiye ve gece cenaze hattı.
extends "res://tests/unit/kapi/kapi_kavgasi_oyun_test.gd"

func _calistir() -> void:
	kat = Katalog.new()
	kat.yukle()
	if _secenekler() != true: hata += 1
	if _kilitler() != true: hata += 1
	if _donus() != true: hata += 1
	if _olum() != true: hata += 1
	if _adli_ve_vade() != true: hata += 1
	print("KAVGA SECENEK OYUN: %s (%d kontrol, %d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", kontrol, hata])
	quit(1 if hata > 0 else 0)

func _ac() -> Oturum:
	var o := _oturum(true)
	o.muhafiz_akce = 9
	var tanik := _gelen("")
	tanik.id = &"tanik"
	A.tanik_hazirla(o, [tanik])
	dene(o.karar_ver(_gelen(), &"ret").durum == "kavga_acik", "Gerçek ret kavgayı açar")
	return o

func _secenekler() -> bool:
	var kimlikler := {}
	for id in KapiKavgasi.GECERLI_SECENEKLER:
		var o := _ac()
		var r: Dictionary = A.sec(o, id, {"zar_atis": 6})
		dene(r.get("olur", false), "Gerçek oturum seçimi: " + id)
		kimlikler[r.get("sonuc_kimligi", "")] = true
		var para := o.muhafiz_akce
		dene(not A.sec(o, id).get("olur", false), "Çift tık reddedilir")
		dene(o.muhafiz_akce == para, "İkinci tık bakiyeyi değiştirmez")
		if id == "akceyle_erteleme":
			dene(para == 7 and o.soz_kaydi.sozler.satirlar().size() == 1, "Gerçek kasa -2 ve tek kalıcı söz")
		if id == "reddetme":
			dene(r.kayit_kimligi == "kavga_kin" and o.dedikodu.kayitlar().size() == 1, "Kin ve tanık dedikodusu")
	dene(kimlikler.size() == 4 and not kimlikler.has(""), "Dört ayrı sonuç")
	return true

func _kilitler() -> bool:
	var o := _ac()
	o.muhafiz_akce = 0
	var d: Dictionary = A.al(o).kavga.secenek_durumlari(A.baglam(o))
	dene(d.akceyle_erteleme.kilit_nedeni == "akce_yetersiz", "Yetersiz kasa nedeni")
	dene(not A.sec(o, "akceyle_erteleme").get("olur", false), "Kilitli erteleme uygulanamaz")
	o.muhafiz_akce = 9
	for i in 5: o.soz_kaydi.sozler.ekle(str(i), "baska", o.gun, "yarin_gel", false)
	d = A.al(o).kavga.secenek_durumlari(A.baglam(o))
	dene(d.akceyle_erteleme.kilit_nedeni == "acik_soz_siniri_dolu", "Mevcut beş söz sınırı")
	dene(not A.sec(o, "akceyle_erteleme").get("olur", false) and o.muhafiz_akce == 9, "Altıncı söz kasa harcamaz")
	A.al(o).panel_acik = true
	o.yonetim.bosalt(o.yonetim.koylular[0].id)
	d = A.al(o).kavga.secenek_durumlari(A.baglam(o))
	dene(not d.askerle_karsilik.gorunur and d.sozle_yatistirma.acik and d.reddetme.acik, "Asker ayrılırken diğer seçenekler korunur")
	dene(A.sec(o, "reddetme").get("olur", false), "Askersiz panel sonuçlanır")
	o = _ac()
	dene(A.sec(o, "reddetme", {"kalp": 1}).get("hata_sayisi", 0) == 1, "Kalp bir hata")
	return true

func _donus() -> bool:
	for tutulacak in [false, true]:
		var o := _ac()
		var r: Dictionary = A.sec(o, "akceyle_erteleme", {"donus_gun_ek": 3})
		dene(int(r.donus_gun) == o.gun + 3, "Veri aralığında dönüş günü")
		# Gerçek kayıt/yükleme dönüşü ve açık söz kaybolmamalı.
		o = Oturum.kayittan(kat, o.kaydet())
		dene(o != null and o.soz_kaydi.sozler.acik_sayisi() == 1, "Söz save/load ile yaşar")
		var kuyruk: Array[Gelen] = []
		o.yonetim.gun = int(r.donus_gun) - 1
		KararDonusu.spawn_ekle(o, kuyruk)
		dene(kuyruk.is_empty(), "Dönüş erken açılmaz")
		o.yonetim.gun += 1
		KararDonusu.spawn_ekle(o, kuyruk)
		dene(kuyruk.size() == 1, "Gerçek tek spawn kuyruğundan figür döner")
		if kuyruk.is_empty(): return false
		KararDonusu.spawn_ekle(o, kuyruk)
		dene(kuyruk.size() == 1, "Dönüş çift yazılmaz")
		o.karar_ver(kuyruk[0], &"kabul" if tutulacak else &"ret")
		dene(o.soz_kaydi.sozler.acik_sayisi() == 0, "Söz gerçek kararla kapanır")
		dene(o.grup_itibari.deger("koylu") == (0 if tutulacak else -1), "Tutulmayan söz gerçek itibar -1")
	return true

func _olum() -> bool:
	var o := _ac()
	var r: Dictionary = A.sec(o, "askerle_karsilik", {"zorla_alt_sonuc": "olum"})
	dene(r.get("olur", false) and SiraOlayiSonucu.durum(o.yonetim).size() == 1, "Ölüm tek kalıcı cenaze makbuzu")
	A.sec(o, "askerle_karsilik", {"zorla_alt_sonuc": "olum"})
	dene(SiraOlayiSonucu.durum(o.yonetim).size() == 1, "Çift ölüm haberi yok")
	o = Oturum.kayittan(kat, o.kaydet())
	var y := o.yonetim
	var rapor: Dictionary = y.gece()
	dene(rapor.olenler.size() == 1 and rapor.get("cenaze", {}).get("sayi", 0) == 1, "Gerçek gece nüfus/ölüm raporu ve CenazeYasi")
	dene(SiraOlayiSonucu.durum(y).is_empty(), "Ölüm makbuzu tüketildi")
	return true

func _adli_ve_vade() -> bool:
	var o := _oturum(true)
	o.muhafiz_akce = 9
	var g := o._adli_gelen(&"chr_001")
	g.kavga_tip = "genc_erkek"
	g.chr_sorgusu().bayraklar["Flag_Kilitlendi"] = true
	dene(o.karar_ver(g, &"ret").get("durum") == "kavga_acik", "Adlı gerçek ret")
	var r: Dictionary = A.sec(o, "akceyle_erteleme", {"donus_gun_ek": 4})
	var grup: String = o.soz_kaydi.sozler.satirlar()[0].grup
	o = Oturum.kayittan(kat, o.kaydet())
	o.yonetim.gun = int(r.donus_gun)
	var kuyruk: Array[Gelen] = []
	KararDonusu.spawn_ekle(o, kuyruk)
	dene(kuyruk.size() == 1 and kuyruk[0].id == &"chr_001", "Adlı kişi mevcut spawn hattından döner")
	o.yonetim.gun += 1
	KararDonusu.spawn_ekle(o, kuyruk)
	dene(o.soz_kaydi.sozler.acik_sayisi() == 0 and o.grup_itibari.deger(grup) == -1, "Vadesi geçen söz tek itibar cezası")
	KararDonusu.spawn_ekle(o, kuyruk)
	dene(o.grup_itibari.deger(grup) == -1, "Vade cezası tekrarlanmaz")
	o = _oturum(true)
	o.karar_ver(g, &"ret")
	A.sec(o, "askerle_karsilik", {"zorla_alt_sonuc": "olum"})
	dene(o.kadro.durumlar[&"chr_001"].durum == &"oldu", "Ölüm DIY-11 hafızasını korur")
	return true
