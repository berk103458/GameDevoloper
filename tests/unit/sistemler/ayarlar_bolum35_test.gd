## Bölüm 35 boş AYR maddelerinin birim testi.
extends SceneTree

const YOL := "user://test_ayar_bolum35.cfg"
const Palet = preload("res://src/arayuz/renk_paleti.gd")
const Sekmeler = preload("res://src/arayuz/ayarlar/ayar_sekmeleri.gd")
const Hizli = preload("res://src/sistemler/hizli_kayit.gd")
const Zorluk = preload("res://src/sistemler/zorluk_secimi.gd")
const Ipucu = preload("res://src/sistemler/ipucu_anahtari.gd")
const Rapor = preload("res://src/sistemler/rapor_bekle.gd")
const Karar = preload("res://src/sistemler/karar_onayi.gd")
const Hiz = preload("res://src/sistemler/koy_hizi_ayari.gd")
const Hareket = preload("res://src/sistemler/hareket_azalt.gd")
const Belirme = preload("res://src/arayuz/soz/belirme_baglantisi.gd")
const Okunmus = preload("res://src/arayuz/soz/okunmus_isaret.gd")
const Tansiyon = preload("res://src/arayuz/kapi/tansiyon_bicimi.gd")
const Bar = preload("res://src/arayuz/kapi/bar_bicimi.gd")
const Zar = preload("res://src/arayuz/kapi/zar_sonucu.gd")
const Gecmis = preload("res://src/arayuz/kapi/konusma_gecmisi.gd")
const Yeni = preload("res://src/arayuz/yeni_oyun_ekrani.gd")
const Izi = preload("res://src/debug/tester_izi.gd")
const Oneri = preload("res://src/sistemler/profil_onerisi.gd")
const Yuva = preload("res://src/sistemler/kayit_yuvalari.gd")

var hata := 0


func _initialize() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	_sekmeler()
	_aninda_yaz()
	_olcek_ve_okuma()
	_palet_ve_kontrast()
	_ses_ve_goruntu()
	_oyun_kayit_ipuclari()
	_hareket_ve_gecmis()
	_yeni_oyun_ve_yuva()
	_cekirdek_degismez()
	_sil()
	print("AYARLAR BOLUM 35: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)


func _sekmeler() -> void:
	_kontrol(Sekmeler.sekme_sayisi() == 6, "AYR-01: sekme sayısı 6")
	_kontrol(Sekmeler.bos_yuvalar().size() == 2, "AYR-50: iki boş yuva")
	for yol in Sekmeler.betikler():
		var betik := load(yol) as GDScript
		_kontrol(betik != null and betik.can_instantiate(), "AYR-01: sekme betiği " + yol)
	var a := _ayar()
	var ekran := AyarlarEkrani.new()
	ekran.ayarlar = a
	root.add_child(ekran)
	var kabuk := ekran.get_child(ekran.get_child_count() - 1)
	_kontrol(kabuk.get_script() == Sekmeler, "AYR-01: kabuk ayarlar ekranına bağlandı")
	root.remove_child(ekran)
	ekran.free()
	var bayrak := [false]
	a.degisti.connect(func(_k: StringName) -> void: bayrak[0] = true)
	AyarlarEk.ayarla(a, &"ipuclari", false)
	_kontrol(bool(bayrak[0]), "AYR-04: değişim sinyali")
	_kontrol(not FileAccess.file_exists(YOL), "AYR-04: kapanmadan dosya yazılmaz")
	a.yaz()
	_kontrol(FileAccess.file_exists(YOL), "AYR-04: yaz() dosyayı oluşturur")


func _aninda_yaz() -> void:
	var a := _ayar()
	Izi.temizle()
	_kontrol(AyarlarEk.ayarla(a, &"vsync", false), "AYR-39: vsync değişir")
	_kontrol(Izi.satirlar.size() == 1 and Izi.satirlar[0].begins_with("AYAR vsync"), "AYR-47: değişim başına bir AYAR satırı")
	var olcum := PerformansSeridi.oku()
	_kontrol(olcum.has("kare_siniri") and olcum.has("vsync_acik"), "AYR-39: performans şeridi vsync ve kare sınırını okur")


func _olcek_ve_okuma() -> void:
	var a := _ayar()
	_kontrol(AyarlarEk.ayarla(a, &"metin_olcegi", 175), "AYR-07: 175 kabul edilir")
	_kontrol(a.boyut(26) == roundi(26 * 175 / 100.0), "AYR-07: boyut 175 ölçeğini kullanır")
	a.yaz()
	var b := Ayarlar.new(YOL)
	b.yukle()
	AyarlarEk.bagla(b)
	_kontrol(b.al(&"metin_olcegi") == 175, "AYR-07: 175 dosyadan geri okunur")
	_kontrol(AyarlarEk.ayarla(a, &"satir_araligi", &"genis"), "AYR-08: geniş satır aralığı")
	_kontrol(Palet.satir_araligi_px(a) == 14, "AYR-08: geniş mod +6 px")
	_kontrol(AyarlarEk.ayarla(a, &"metin_agirligi", 500), "AYR-13: kalın ağırlık")
	_kontrol(Palet.govde_agirligi(a) == 500, "AYR-13: gövde 500")
	a.ayarla(&"belirme_hizi", &"aninda")
	_kontrol(Belirme.satir_ms(a, 400.0) == 0.0, "AYR-09: anında satır gecikmesi 0")
	_kontrol(Belirme.zar_ms(a, 800.0) <= 200.0, "AYR-09: anında zar animasyonu 200 ms altında")
	var zar := Zar.metin(4, true)
	_kontrol(zar.find("4") >= 0 and zar.find(tr("arayuz.ayarlar.zar.gecti")) >= 0, "AYR-17: zar rakam ve söz")


func _palet_ve_kontrast() -> void:
	var a := _ayar()
	for ad in ["olagan", "deuteranopi", "protanopi", "tritanopi"]:
		AyarlarEk.ayarla(a, &"renk_paleti", StringName(ad))
		for i in 4:
			for j in range(i + 1, 4):
				var fark := Palet.delta_e(Palet.bar_rengi(a, i), Palet.bar_rengi(a, j))
				_kontrol(fark >= 20.0, "AYR-14: %s bar %d-%d ΔE %.1f" % [ad, i, j, fark])
	_kontrol(Tansiyon.cizgi_sayisi(0) == 1 and Tansiyon.cizgi_sayisi(1) == 2 and Tansiyon.cizgi_sayisi(2) == 3, "AYR-15: üç kademe üç çizgi")
	var kutu := VBoxContainer.new()
	root.add_child(kutu)
	var bar := ProgressBar.new()
	kutu.add_child(bar)
	Bar.isaretle(kutu)
	_kontrol(String(bar.get_meta(&"harf", "")).length() == 1, "AYR-15: barda harf")
	var gosterge := VBoxContainer.new()
	root.add_child(gosterge)
	_kontrol(Tansiyon.kademe_gecti(gosterge, 0, 0) == 0, "AYR-21: ilk kademe yanıp sönmez")
	_kontrol(Tansiyon.kademe_gecti(gosterge, 1, 0) == 1, "AYR-21: sessiz kademe geçişi bir yanıp sönme")
	AyarlarEk.ayarla(a, &"yuksek_kontrast", true)
	var tema := Tema.olustur(a)
	Palet.uygula(tema, a)
	var oran := Palet.kontrast(Palet.metin_rengi(a), Renkler.GECE)
	_kontrol(oran >= 7.0, "AYR-16: kontrast %.2f" % oran)
	AyarlarEk.ayarla(a, &"odak_cercevesi", &"kalin")
	_kontrol(Palet.odak_kalinligi(a) == 3, "AYR-19: kalın odak 3 px")
	kutu.queue_free()
	gosterge.queue_free()


func _ses_ve_goruntu() -> void:
	var a := _ayar()
	var ses: VBoxContainer = load("res://src/arayuz/ayarlar/ses_sekmesi.gd").new()
	ses.ayarlar = a
	root.add_child(ses)
	_kontrol(ses.kaydiricilar.size() == 3, "AYR-20: üç kaydırıcı")
	var buslar: Array[String] = []
	for anahtar in Ayarlar.BUSLAR:
		buslar.append(String(Ayarlar.BUSLAR[anahtar]))
	_kontrol(buslar == ["Master", "Muzik", "Efekt"], "AYR-20: bus adları aynı")
	var goruntu: VBoxContainer = load("res://src/arayuz/ayarlar/goruntu_sekmesi.gd").new()
	goruntu.ayarlar = a
	root.add_child(goruntu)
	a.ayarla(&"ekran_modu", &"tam_ekran")
	_kontrol(not goruntu.secici_etkin(), "AYR-38: tam ekranda boyut seçici pasif")
	a.ayarla(&"ekran_modu", &"pencere")
	_kontrol(goruntu.secici_etkin(), "AYR-38: pencerede boyut seçici açık")
	var once_boyut := a.boyut(Tema.GOVDE_PX)
	a.ayarla(&"cozunurluk_3d", 50)
	_kontrol(a.boyut(Tema.GOVDE_PX) == once_boyut, "AYR-42: 3B ölçek metin boyutunu değiştirmez")
	_kontrol(String(ProjectSettings.get_setting("display/window/stretch/mode")) == "canvas_items", "AYR-42: arayüz canvas_items")
	var oneri = Oneri.new()
	var profil := StringName(a.al(&"grafik_profili"))
	_kontrol(oneri.gece_ekle(20.0).is_empty() and oneri.gece_ekle(20.0).is_empty(), "AYR-41: iki gece öneri yok")
	_kontrol(oneri.gece_ekle(20.0) == "arayuz.ayarlar.profil_onerisi", "AYR-41: üçüncü gece bir kez öneri")
	_kontrol(oneri.gece_ekle(10.0).is_empty() and a.al(&"grafik_profili") == profil, "AYR-41: profil kendiliğinden değişmez")
	ses.queue_free()
	goruntu.queue_free()


func _oyun_kayit_ipuclari() -> void:
	var a := _ayar()
	var kayit := IpucuKaydi.new()
	kayit.ipucu_ekle("kuyu")
	AyarlarEk.ayarla(a, &"ipuclari", false)
	_kontrol(not Ipucu.gosterilir_mi(a, kayit, "yeni"), "AYR-12: kapalıyken ipucu 0")
	AyarlarEk.ayarla(a, &"ipuclari", true)
	Ipucu.sifirla(kayit)
	_kontrol(Ipucu.gosterilir_mi(a, kayit, "kuyu"), "AYR-12: sıfırlamadan sonra ipucu gelir")
	AyarlarEk.ayarla(a, &"koy_hizi_varsayilan", 2)
	Engine.time_scale = float(Hiz.acilis(a))
	_kontrol(is_equal_approx(Engine.time_scale, 2.0), "AYR-24: ayar 2 ise açılış hızı 2")
	Engine.time_scale = 1.0
	_kontrol(Rapor.zamanlayici_ms(a) == 0, "AYR-26: açıkken rapor zamanlayıcısı 0")
	Karar.sifirla()
	AyarlarEk.ayarla(a, &"karar_onayi", true)
	_kontrol(not Karar.izinli(a, "kabul"), "AYR-27: açıkken tek tıkla karar yok")
	_kontrol(Karar.izinli(a, "kabul"), "AYR-27: ikinci tık kararı açar")
	Karar.sifirla()
	AyarlarEk.ayarla(a, &"karar_onayi", false)
	var kat := Katalog.new()
	_kontrol(kat.yukle() == Katalog.Durum.HAZIR, "katalog hazır")
	var oturum := Oturum.new(kat, 11)
	var ham := oturum.kaydet()
	var ayar_anahtarlari: Array[String] = []
	for k in Ayarlar.VARSAYILAN:
		ayar_anahtarlari.append(String(k))
	for k in AyarlarEk.VARSAYILAN:
		ayar_anahtarlari.append(String(k))
	var kacak := 0
	for k in ham:
		if String(k) in ayar_anahtarlari and String(k) != "zorluk":
			kacak += 1
	_kontrol(kacak == 0, "AYR-45: kayıtta ayar anahtarı yok")
	Zorluk.kayda_yaz(ham, "siki")
	_kontrol(String(ham.get("zorluk", "")) == "siki" and "siki" in Zorluk.anahtarlar(), "AYR-23: zorluk denge anahtarı ve kayıtta")
	var defter := Zorluk.degistir(a, ham, "kolay")
	_kontrol(defter.begins_with("zorluk ") and String(a.al(&"zorluk")) == "kolay", "AYR-23: değişim defter satırı")
	Hareket.guncelle(a)
	AyarlarEk.ayarla(a, &"hareket_azalt", true)
	_kontrol(Hareket.sure(0.6) == 0.0, "AYR-18: hareket azaltma süresi 0 (acik=%s)" % Hareket.acik)
	var gecis := KapiKameraGecisi.new()
	root.add_child(gecis)
	var kamera := Camera3D.new()
	root.add_child(kamera)
	gecis.kamera = kamera
	var vardi := [false]
	gecis.kuyruk(func(_v: Vector3) -> void: vardi[0] = true, Vector3.ZERO, Vector3(1, 0, 0), 40.0)
	_kontrol(bool(vardi[0]) and is_equal_approx(kamera.fov, 40.0), "AYR-18: kamera geçişi anında biter fov=%s vardi=%s" % [kamera.fov, vardi[0]])


func _hareket_ve_gecmis() -> void:
	var a := _ayar()
	var kat := Katalog.new()
	_kontrol(kat.yukle() == Katalog.Durum.HAZIR, "okunmuş işaret için katalog")
	var rng := RandomNumberGenerator.new()
	var kadro := KarakterKadrosu.new(kat, rng, rng)
	var kisi: StringName = kadro.durumlar.keys()[0]
	_kontrol(not Okunmus.soluk_mu(a, kadro, kisi, "selam"), "AYR-10: ilk ziyaret soluk değil")
	Okunmus.isaretle(kadro, kisi, "selam")
	_kontrol(Okunmus.soluk_mu(a, kadro, kisi, "selam"), "AYR-10: ikinci ziyaret soluk")
	AyarlarEk.ayarla(a, &"okunmus_isaret", false)
	_kontrol(not Okunmus.soluk_mu(a, kadro, kisi, "selam"), "AYR-10: anahtar kapalıyken soluk yok")
	var sol := InputEventJoypadMotion.new()
	sol.axis = JOY_AXIS_LEFT_Y
	sol.axis_value = -1.0
	_kontrol(not Gecmis.kaydir(RichTextLabel.new(), sol) and not Gecmis.kaydir(null, sol), "AYR-11: sol çubuk ve boş kayıt kaydırmaz")


func _yeni_oyun_ve_yuva() -> void:
	_kontrol(Yeni.alan_sayisi(true) == 2 and Yeni.alan_sayisi(false) == 3, "AYR-34: ilk oyunda iki, sonra üç alan")
	_kontrol(Yeni.tohum_coz("") == 0 and Yeni.tohum_coz("42") == 42, "AYR-35: boş tohum rastgele, sayı okunur")
	_kontrol(not Yeni.baslat_olur(true, false) and Yeni.baslat_olur(true, true), "AYR-36: dolu yuvada onaysız başlangıç yok")
	var iz_yol := "user://test_oyuncu_izi_35.cfg"
	var iz := OyuncuIzi.new(iz_yol)
	_kontrol(Yeni.iz_satiri(iz).is_empty(), "AYR-37: iz yoksa satır yok")
	iz.oyunu_tamamla()
	_kontrol(not Yeni.iz_satiri(iz).is_empty(), "AYR-37: iz varsa satır var")
	if FileAccess.file_exists(iz_yol):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(iz_yol))
	var kok := "user://test_hizli_35/"
	var kok_disk := ProjectSettings.globalize_path(kok)
	DirAccess.make_dir_recursive_absolute(kok_disk)
	for ad in ["kayit.json", "kayit_1.json", "kayit_2.json", "kayit_3.json", "kayit_1.json.bak"]:
		var tam := kok_disk.path_join(ad)
		if FileAccess.file_exists(tam):
			DirAccess.remove_absolute(tam)
	var yuvalar := Yuva.new(kok)
	var veri := {"surum": Oturum.KAYIT_SURUMU, "gun": 2, "nufus": 4}
	var sorgu_yazildi := Hizli.dene(&"sorgu", yuvalar, veri)
	var sorgu_var := yuvalar.var_mi(1)
	_kontrol(not sorgu_yazildi and not sorgu_var, "AYR-30: sorguda hızlı kayıt yok yazildi=%s var=%s yol=%s" % [sorgu_yazildi, sorgu_var, yuvalar.yuva_yolu(1)])
	_kontrol(Hizli.dene(&"koy", yuvalar, veri) and yuvalar.var_mi(1), "AYR-30: köyde hızlı kayıt yazılır")
	var ilk := FileAccess.get_modified_time(yuvalar.yuva_yolu(1))
	OS.delay_msec(1100)
	_kontrol(Hizli.dene(&"koy", yuvalar, {"surum": Oturum.KAYIT_SURUMU, "gun": 3, "nufus": 5}), "AYR-30: ikinci yazım")
	_kontrol(FileAccess.get_modified_time(yuvalar.yuva_yolu(1)) > ilk, "AYR-30: köyde dosya saati değişir")
	var kat := Katalog.new()
	kat.yukle()
	var bir := _kuyruk(Oturum.new(kat, 4242))
	var iki := _kuyruk(Oturum.new(kat, 4242))
	_kontrol(bir == iki and not bir.is_empty(), "AYR-35: aynı tohum ilk altı gece aynı kuyruk")


func _cekirdek_degismez() -> void:
	var cekirdek := FileAccess.get_file_as_string("res://src/sistemler/ayarlar.gd")
	var tema := FileAccess.get_file_as_string("res://src/arayuz/tema.gd")
	for anahtar in AyarlarEk.VARSAYILAN:
		_kontrol(not cekirdek.contains(String(anahtar)), "AYR-48: ayarlar.gd ek anahtar taşımıyor (%s)" % anahtar)
	_kontrol(not tema.contains("renk_paleti") and not tema.contains("yuksek_kontrast"), "AYR-48: tema.gd palet taşımıyor")


func _kuyruk(o: Oturum) -> String:
	var parca: PackedStringArray = []
	for _gece in 6:
		var satir: PackedStringArray = []
		for g in o.gece_kuyrugu():
			satir.append("%s:%s" % [g.id, g.sinif])
		parca.append("|".join(satir))
		o.gun += 1
	return "\n".join(parca)


func _ayar() -> Ayarlar:
	_sil()
	var a := Ayarlar.new(YOL)
	a.yukle()
	AyarlarEk.bagla(a)
	return a


func _sil() -> void:
	if FileAccess.file_exists(YOL):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(YOL))


func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
