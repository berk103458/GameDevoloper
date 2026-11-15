extends SceneTree

var _hata: int = 0


func _kontrol(kosul: bool, mesaj: String) -> void:
	if not kosul:
		_hata += 1
		push_error("OZEL ESYALAR TEST HATASI: " + mesaj)


func _hazir_oturum(kat: Katalog, tohum: int) -> Oturum:
	var o := Oturum.new(kat, tohum)
	o.yonetim.kaynaklar.stok["gida"] = 500
	o.yonetim.kaynaklar.stok["odun"] = 500
	o.yonetim.akce = 500
	var k := o.yonetim.kabul({"ad": "Veli", "sinif": &"ciftci", "stat": 5})
	k.saglik = 80
	k.moral = 90
	return o


func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()

	# 1. Gerçek data/ozel_esyalar.json doğrulaması: en az 8 geçerli satır, dolu kaynak notu, tek kapı
	var hatalar := OzelEsyalar.dogrula()
	_kontrol(hatalar.is_empty(), "Gercek ozel_esyalar.json hatasiz olmali: %s" % str(hatalar))
	var tumu := OzelEsyalar.tanimlar()
	_kontrol(tumu.size() >= 8, "En az 8 ozel esya olmali: %d" % tumu.size())
	for oge in tumu:
		_kontrol(OzelEsyalar.kaynak_notu_var_mi(oge), "Kaynak notu dolu olmali: %s" % str(oge.get("id", "")))
		_kontrol(OzelEsyalar.satir_hatasi(oge) == "", "Satir tek gecerli kapi tasimali: %s" % str(oge.get("id", "")))

	# 2. İki kapılı satır tam 1 hata verir; listede olmayan kapı doğrulayıcıda hata verir
	var baz_veri := OzelEsyalar.veri_oku()
	var iki_kapili := baz_veri.duplicate(true)
	(iki_kapili["esyalar"] as Array).append({
		"id": "cift_kapili_test",
		"ad": "Çift Kapı Test",
		"kaynak_notu": "YAZ-01 test",
		"hedef_sistem": ["sur_hasari", "erzak"],
		"carpan": 1.1,
	})
	var h_iki := OzelEsyalar.dogrula(iki_kapili)
	_kontrol(h_iki.size() == 1, "Iki kapili satir tam 1 hata vermeli: %s" % str(h_iki))

	var gecersiz_kapili := baz_veri.duplicate(true)
	(gecersiz_kapili["esyalar"] as Array).append({
		"id": "gecersiz_kapi_test",
		"ad": "Geçersiz Kapı Test",
		"kaynak_notu": "YAZ-01 test",
		"hedef_sistem": "olmayan_sistem",
		"carpan": 1.1,
	})
	var h_gecersiz := OzelEsyalar.dogrula(gecersiz_kapili)
	_kontrol(h_gecersiz.size() == 1, "Listede olmayan kapi dogrulayicida 1 hata vermeli: %s" % str(h_gecersiz))

	# 3. Kaynak notu boş olan satır sayılmaz; 8 eşiği onu beklemez
	var bos_notlu_ek := baz_veri.duplicate(true)
	(bos_notlu_ek["esyalar"] as Array).append({
		"id": "notu_bos_test",
		"ad": "Notu Boş",
		"kaynak_notu": "",
		"hedef_sistem": "erzak",
		"carpan": 1.1,
	})
	_kontrol(OzelEsyalar.dogrula(bos_notlu_ek).is_empty(), "8 dolu satir + 1 bos notlu satir hatasiz olmali")

	var yedi_plus_bos := baz_veri.duplicate(true)
	var sekiz_listesi: Array = yedi_plus_bos["esyalar"]
	sekiz_listesi.pop_back()
	sekiz_listesi.append({
		"id": "notu_bos_eksik",
		"ad": "Notu Boş Eksik",
		"kaynak_notu": "",
		"hedef_sistem": "erzak",
		"carpan": 1.1,
	})
	var h_yedi := OzelEsyalar.dogrula(yedi_plus_bos)
	_kontrol(h_yedi.size() == 1 and h_yedi[0].begins_with("yetersiz_ozel_esya:"), "7 dolu + 1 bos notlu satir yetersiz_ozel_esya vermeli: %s" % str(h_yedi))

	# 4. Çocuk heybesinden okuma (ikinci kayıt açılmaz), iki kez çözmede tek çarpan, satıştan sonra kademe açık kalır
	var o := _hazir_oturum(kat, 6101)
	var cocuk_heybe := Heybe.new()
	cocuk_heybe.ekle("horasan_harci_numunesi", "ozel", 40, 1, false)
	var heybe_ozeller := OzelEsyalar.heybedeki_ozeller(cocuk_heybe)
	_kontrol(heybe_ozeller.size() == 1 and String(heybe_ozeller[0]["id"]) == "horasan_harci_numunesi", "Cocuk heybesinden ozel esya okunabilmeli")

	var ilk_coz := OzelEsyalar.coz(o, "horasan_harci_numunesi", cocuk_heybe)
	_kontrol(bool(ilk_coz.get("ok", false)) and is_equal_approx(OzelEsyalar.carpan(o.yonetim, "sur_hasari"), 0.85), "Cocuk heybesinden cozulen esya carpani uygulamali")

	# İkinci kez muhafiz_esyalari üzerinden çözülse bile çarpan iki kez uygulanmaz
	o.muhafiz_esyalari.append({"id": "horasan_harci_numunesi", "tur": "ozel", "adet": 1, "deger": 40})
	var ikinci_coz := OzelEsyalar.coz(o, "horasan_harci_numunesi")
	_kontrol(not bool(ikinci_coz.get("ok", true)) and is_equal_approx(OzelEsyalar.carpan(o.yonetim, "sur_hasari"), 0.85), "Ayni esya iki kez cozulunce carpan bir kez uygulanmali")

	# Satış sonrası envanterde adet 0'a düşer, akçe eklenir ama kademe açık kalır ve ikinci kayıt açılmaz
	var akce_once := o.muhafiz_akce
	var satis := OzelEsyalar.sat(o, "horasan_harci_numunesi", 1)
	_kontrol(bool(satis.get("ok", false)) and o.muhafiz_akce == akce_once + 40, "Esya satilabilmeli ve akce kisisel keseye girmeli")
	_kontrol(OzelEsyalar.sahip_adet(o, "horasan_harci_numunesi") == 0, "Satilan esya muhafiz_esyalari icinden silinmeli")
	_kontrol(OzelEsyalar.cozuldu_mu(o.yonetim, "horasan_harci_numunesi") and is_equal_approx(OzelEsyalar.carpan(o.yonetim, "sur_hasari"), 0.85), "Satis sonrasinda acilmis kademe acik kalmali")

	var kayit := o.kaydet()
	_kontrol(not kayit.has("cocuk_esyalari") and not kayit.has("heybe_esyalari"), "Ikinci ozel esya/cocuk envanter kaydi acilmamali")
	var yuklenen := Oturum.kayittan(kat, kayit)
	_kontrol(yuklenen != null and is_equal_approx(OzelEsyalar.carpan(yuklenen.yonetim, "sur_hasari"), 0.85), "Kayit-yukleme sonrasi acilmis kademe korunmali")

	# 5. Yedi hedef kapının gerçek hesaplara bağlanması (baz vs çözülmüş)
	var o_baz := _hazir_oturum(kat, 6102)
	var o_acik := _hazir_oturum(kat, 6102)
	o_baz.yonetim.sur_seviye = 2
	o_acik.yonetim.sur_seviye = 2
	o_baz.yonetim.asayis_riski = 25
	o_acik.yonetim.asayis_riski = 25
	for _i in 9:
		o_baz.yonetim.kabul({"ad": "Nufus_%d" % _i, "sinif": &"ciftci", "stat": 5})
		o_acik.yonetim.kabul({"ad": "Nufus_%d" % _i, "sinif": &"ciftci", "stat": 5})
	o_baz.yonetim.sur_hasari_ekle(20)
	OzelEsyalar.coz(o_acik, "horasan_harci_numunesi", cocuk_heybe)
	o_acik.yonetim.sur_hasari_ekle(20)
	_kontrol(o_acik.yonetim.sur_hasar < o_baz.yonetim.sur_hasar, "sur_hasari hedefi sur hasarini azaltmali (%d < %d)" % [o_acik.yonetim.sur_hasar, o_baz.yonetim.sur_hasar])

	# kis_odun_tuketimi
	IklimDeneyi.degistir(o_baz, 3, "normal")
	IklimDeneyi.degistir(o_acik, 3, "normal")
	var kece_heybe := Heybe.new()
	kece_heybe.ekle("turkmen_kece_aba", "ozel", 30, 1, false)
	OzelEsyalar.coz(o_acik, "turkmen_kece_aba", kece_heybe)
	_kontrol(MevsimTuketimAdaptoru.odun(o_acik.yonetim) < MevsimTuketimAdaptoru.odun(o_baz.yonetim), "kis_odun_tuketimi odun ihtiyacini dusurmeli")

	# savunma_formulu
	o_baz.yonetim.kabul({"ad": "Nefer", "sinif": &"asker", "stat": 5})
	o_acik.yonetim.kabul({"ad": "Nefer", "sinif": &"asker", "stat": 5})
	var yay_heybe := Heybe.new()
	yay_heybe.ekle("kirim_akcaagac_yayi", "ozel", 50, 1, false)
	OzelEsyalar.coz(o_acik, "kirim_akcaagac_yayi", yay_heybe)
	_kontrol(o_acik.yonetim.savunma_gucu() > o_baz.yonetim.savunma_gucu(), "savunma_formulu savunma_gucunu artirmali")

	# guvenlik
	var zincir_heybe := Heybe.new()
	zincir_heybe.ekle("ahlat_burc_zinciri", "ozel", 45, 1, false)
	OzelEsyalar.coz(o_acik, "ahlat_burc_zinciri", zincir_heybe)
	_kontrol(KervanKorumasi.guvenlik(o_acik.yonetim) > KervanKorumasi.guvenlik(o_baz.yonetim), "guvenlik KervanKorumasi.guvenlik skorunu artirmali")

	# erzak + degirmen_uretimi + saglik carpanlari
	var uretim_heybe := Heybe.new()
	uretim_heybe.ekle("rum_su_carki_mili", "ozel", 40, 1, false)
	uretim_heybe.ekle("sirlak_bugday_kupu", "ozel", 35, 1, false)
	uretim_heybe.ekle("konevi_tiryak_hokasi", "ozel", 40, 1, false)
	OzelEsyalar.coz(o_acik, "rum_su_carki_mili", uretim_heybe)
	OzelEsyalar.coz(o_acik, "sirlak_bugday_kupu", uretim_heybe)
	OzelEsyalar.coz(o_acik, "konevi_tiryak_hokasi", uretim_heybe)
	_kontrol(is_equal_approx(OzelEsyalar.carpan(o_acik.yonetim, "degirmen_uretimi"), 1.15), "degirmen_uretimi carpani aktif olmali")
	_kontrol(is_equal_approx(OzelEsyalar.carpan(o_acik.yonetim, "erzak"), 1.1), "erzak carpani aktif olmali")
	_kontrol(is_equal_approx(OzelEsyalar.carpan(o_acik.yonetim, "saglik"), 1.15), "saglik carpani aktif olmali")

	# Gerçek üretim ve sağlık iyileşmesi karşılaştırması (tarla ve ev kurulu)
	o_baz.yonetim.gun = 30
	o_acik.yonetim.gun = 30
	var b1 := _bina_ac(o_baz.yonetim, "kulube", Vector2i(0, 0))
	var b2 := _bina_ac(o_acik.yonetim, "kulube", Vector2i(0, 0))
	var t1 := _bina_ac(o_baz.yonetim, "tarla", Vector2i(2, 0))
	var t2 := _bina_ac(o_acik.yonetim, "tarla", Vector2i(2, 0))
	if b1 != null and b2 != null and t1 != null and t2 != null:
		o_baz.yonetim.koylular[0].ev = b1.id
		o_acik.yonetim.koylular[0].ev = b2.id
		o_baz.yonetim.koylular[0].saglik = 70
		o_acik.yonetim.koylular[0].saglik = 70
		for i in mini(2, o_baz.yonetim.koylular.size()):
			o_baz.yonetim.koylular[i].is_yeri = t1.id
			o_acik.yonetim.koylular[i].is_yeri = t2.id
		o_baz.yonetim._barindir()
		o_acik.yonetim._barindir()
		var r_baz := o_baz.yonetim.gece()
		var r_acik := o_acik.yonetim.gece()
		_kontrol(int((r_acik.get("uretim", {}) as Dictionary).get("gida", 0)) > int((r_baz.get("uretim", {}) as Dictionary).get("gida", 0)), "erzak carpani gercek tarla gida uretimini artirmali")
		_kontrol(o_acik.yonetim.koylular[0].saglik >= o_baz.yonetim.koylular[0].saglik, "saglik carpani gece iyilesmesini dusurmemeli/artirmali")

	# 6. İkon Sanat üzerinden okunur, yeni PNG dosyası üretilmez
	var ikon := OzelEsyalar.ikon_dokusu("horasan_harci_numunesi")
	_kontrol(ikon == null or ikon is Texture2D, "Ikon Sanat uzerinden okunmali (yokken null, yeni PNG uretilmez)")

	if _hata == 0:
		print("OZEL ESYALAR (YAP-06): GEÇTİ (0 hata)")
		quit(0)
	else:
		print("OZEL ESYALAR (YAP-06): KALDI (%d hata)" % _hata)
		quit(1)


func _bina_ac(y: KoyYonetimi, tur: String, bas: Vector2i) -> KoyBinasi:
	for cy in range(bas.y, y.a.izgara_boyut.y):
		for cx in range(bas.x, y.a.izgara_boyut.x):
			var h := Vector2i(cx, cy)
			if y.yerlesim(tur, h).get("olur", false):
				var res := y.bina_kur(tur, h)
				if bool(res.get("olur", false)):
					var b := y.bina(int(res["id"]))
					b.insa_kalan = 0
					return b
	return null
