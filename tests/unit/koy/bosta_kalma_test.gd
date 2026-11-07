extends SceneTree
const B = preload("res://src/koy/bosta_kalma.gd")
var hata := 0

func dene(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)

func _initialize() -> void:
	call_deferred("_calistir")

func _calistir() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var y := Oturum.new(kat, 303).yonetim
	var k := y.kabul({"ad": "İş arayan", "sinif": "ciftci"})
	var moral := k.moral
	for gun in 3:
		y.gun = gun
		B.gece(y, {})
		var once := k.moral
		B.gece(y, {})
		dene(k.moral == once, "Aynı gece ikinci bedel yok")
	y.gun = 3
	dene(k.moral == moral - 3 * int(B.AYAR.moral_kaybi), "Üç gecenin tek moral bedeli")
	dene(B.gunler(y, k) == 3 and not B.sohbet_satiri(y, k).is_empty(), "Üç tam boş gün terk cümlesini açar")
	B.sifirla(y, k.id)
	dene(B.gunler(y, k) == 0 and B.sohbet_satiri(y, k).is_empty(), "İşe giriş sayacı sıfırlar")
	for durum in ["cocuk", "es", "oyuncu", "hasta", "karantina"]:
		var diger := y.kabul({"ad": durum})
		match durum:
			"cocuk": diger.yas_grubu = &"cocuk"
			"es": diger.bayrak_ekle("acl01_es")
			"oyuncu": diger.bayrak_ekle("acl01_muhafiz")
			"hasta": diger.bayrak_ekle("hasta")
			"karantina": diger.karantina = {"baslangic": 1, "bitis": 3, "bina": 99}
		dene(not B.uygun(y, diger), durum + " boşta sayılmaz")
	var durum := k.bosta_kalma.duplicate(true)
	var kayit: Variant = JSON.parse_string(JSON.stringify(durum))
	k.bosta_kalma = B.oku(kayit)
	dene(k.bosta_kalma == durum, "JSON sayacı korur")
	# Gerçek kayıt yolu: optional alan eski kaydı bozmaz.
	k.bosta_kalma = {"gun": 2, "son_gece": 2}
	var yuklu := Koylu.kayittan(JSON.parse_string(JSON.stringify(k.kaydet())))
	dene(yuklu.bosta_kalma == k.bosta_kalma, "Kişi JSON kayıt dönüşü")
	var eski := k.kaydet()
	eski.erase("bosta_kalma")
	dene(Koylu.kayittan(eski).bosta_kalma.is_empty(), "Eski kayıt sayacı boş başlatır")
	for bozuk in [null, [], {"gun": true, "son_gece": 2}, {"gun": 1.5, "son_gece": 2}, {"gun": 4, "son_gece": 2}]:
		dene(B.oku(bozuk).is_empty(), "Bozuk optional sayaç reddedilir")
	dene(B.sohbet_satiri(null, k).is_empty(), "Bağlamsız eski sohbet çağrısı korunur")
	var o := Oturum.new(kat, 303)
	var normal := o.yonetim
	normal.a = normal.a.duplicate(true)
	normal.a.ambar_taban_kapasite = 10000
	normal.a.tok_moral = 0
	normal.a.evsiz_moral = 0
	normal.a.isyan_esigi = -1
	normal.kaynaklar = Kaynaklar.new(10000, {"gida": 1000, "su": 1000, "odun": 1000})
	var kisi := normal.kabul({"ad": "Usta", "sinif": "ciftci"})
	var baslangic := kisi.moral
	for i in 3:
		var r := normal.gece()
		dene(int(r.get("bosta_moral_bedeli", -1)) == int(B.AYAR.moral_kaybi), "Gerçekleşen bedel gece raporunda tek satır")
		var foto := normal.kaydet()
		for tekrar in 2:
			var olcum := DengeOlcumu.olustur(o, r)
			dene(olcum.get("bosta_moral_bedeli", -1) == r.get("bosta_moral_bedeli", -2), "DEN rapordan aynı bedeli okur")
		dene(normal.kaydet() == foto, "DEN ikinci bedel veya gece üretmez")
		var sarili := DengeOlcumu.olustur(o, {"rapor": r})
		dene(sarili.bosta_moral_bedeli == r.bosta_moral_bedeli, "Oturum rapor zarfı aynı satırı taşır")
	dene(normal.gun == 3 and B.gunler(normal, kisi) == 3, "Normal gece üç tam gün sayar")
	dene(kisi.moral == baslangic - 3 * int(B.AYAR.moral_kaybi), "Normal gece tek moral alanına yazar")
	dene(normal.koylu(kisi.id) != null, "Terk isteği kişiyi silmez")
	var h := Hud.new()
	root.add_child(h)
	h.bagla(o)
	await process_frame
	var l := h._nufus.get_parent().get_node("BostaSayisi") as Label
	dene(l.text == TranslationServer.translate("koy.bosta.hud") % 1, "Gerçek HUD çeviri anahtarıyla sayar")
	var replikler: Array[String] = []
	var dy := KoyDiyalogYoneticisi.new()
	dy.replik_geldi.connect(func(_ad: String, metin: String, _s: Array) -> void: replikler.append(metin))
	dene(dy.muhabbet_baslat(kisi, normal), "Mevcut Parley muhabbeti başlar")
	await process_frame
	var gozlem_once := normal.kaydet()
	var satir := B.sohbet_satiri(normal, kisi)
	B.sayi(normal)
	dene(normal.kaydet() == gozlem_once, "HUD ve sohbet gözlemi kayıt/RNG değiştirmez")
	dene(not replikler.is_empty() and replikler[0].count(satir) == 1, "İlk köy repliğinde tek terk satırı")
	if not dy.son_secenekler.is_empty():
		dy.secenek_sec(dy.son_secenekler[0])
		await process_frame
		if replikler.size() > 1: dene(not satir in replikler[1], "Sonraki replikte terk satırı yinelenmez")
	dy.bitir()
	var odunluk := KoyBinasi.new()
	odunluk.id = 77
	odunluk.tur = "odunluk"
	normal.binalar.append(odunluk)
	dene(GeciciIsler.ata(normal, kisi.id, "dal_toplama"), "Gerçek geçici iş ataması")
	h.guncelle()
	dene(B.gunler(normal, kisi) == 0 and B.sohbet_satiri(normal, kisi).is_empty(), "Atama sayacı ve isteği sıfırlar")
	dene(l.text == TranslationServer.translate("koy.bosta.hud") % 0, "Atamayla HUD sayısı bir azalır")
	var onceki := kisi.moral
	normal.bosalt(kisi.id)
	# Son bedelin gecesine geri dönmek aynı geceyi yeniden ücretlendirmez.
	normal.gun -= 1
	B.gece(normal, {})
	dene(kisi.moral == onceki and B.gunler(normal, kisi) == 0, "Atama/boşaltma bedel damgasını korur")
	kisi.zanaat_turu = ZanaatTuru.Tur.BELIRSIZ
	kisi.bosta_kalma = {"gun": 3, "son_gece": normal.gun}
	dene(B.sohbet_satiri(normal, kisi).is_empty(), "Mesleksiz kişide terk isteği yok")
	# İkinci gün işe giren yetişkinde üçüncü gece terk cümlesi açılmaz.
	var ikinci := normal.kabul({"ad": "Yeni işçi", "sinif": "ciftci"})
	ikinci.bosta_kalma = {"gun": 1, "son_gece": normal.gun - 1}
	dene(GeciciIsler.ata(normal, ikinci.id, "dal_toplama"), "İkinci gün işe giriş")
	for i in 2: normal.gece()
	dene(B.sohbet_satiri(normal, ikinci).is_empty() and B.gunler(normal, ikinci) == 0, "Üçüncü gün işçinin terk satırı yok")
	normal.bosalt(ikinci.id)
	ikinci.bosta_kalma = {"gun": 3, "son_gece": normal.gun - 1}
	dene(normal.ata(ikinci.id, odunluk.id), "Gerçek bina ataması")
	dene(B.gunler(normal, ikinci) == 0, "Bina ataması anında sıfırlar")
	var kayit_y := KoyYonetimi.kayittan(normal.a, normal.katalog, JSON.parse_string(JSON.stringify(normal.kaydet())))
	dene(kayit_y.koylu(ikinci.id).bosta_kalma == ikinci.bosta_kalma, "Köy kaydı optional sayacı taşır")
	# Mevsim çarpanı mevcut mevsim kaydından gelir; tüm varsayılanlar nötrdür.
	var mevsim_no := int(MevsimYoneticisi.durum(normal).mevsim)
	normal.a.bosta_moral_carpanlari[mevsim_no] = 2.0
	normal.bosalt(ikinci.id)
	ikinci.bosta_kalma = {}
	var moral_once := ikinci.moral
	B.gece(normal, {})
	dene(ikinci.moral == maxi(0, moral_once - 2 * int(B.AYAR.moral_kaybi)), "Bedel mevsim kaydındaki çarpanı kullanır")
	dene(ikinci.aclik == 0, "Boşta bedeli açlık sayacına yazılmaz")
	ikinci.bosta_kalma = {"gun": 3, "son_gece": normal.gun + 100}
	dene(B.gunler(normal, ikinci) == 0, "Gelecek tarih terk isteği açmaz")
	B.gece(normal, {})
	dene(B.gunler(normal, ikinci) == 1, "Gelecek tarih sonraki normal sayımı kilitlemez")
	var tek := Oturum.new(kat, 304).yonetim
	var dusuk := tek.kabul({"ad": "Düşük moral"})
	dusuk.moral = 1
	dene(B.gece(tek, {}) == 1 and dusuk.moral == 0, "Gerçek bedel moral tabanında tam bir puandır")
	dene(B.gece(tek, {}) == 0, "Aynı gecenin ikinci ölçümü sıfır bedel")
	h.free()
	print("BOŞTA KALMA MODEL: GEÇTİ" if hata == 0 else "BOŞTA KALMA MODEL: KALDI")
	quit(hata)
