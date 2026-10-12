## ACL-05: barınak kapasitesi kabul sınırı. Kabul iddialarının her biri bir dene() satırıdır.
extends SceneTree
const BARINAK = preload("res://src/kapi/barinak_uyarisi.gd")
const ACILIS = preload("res://src/sistemler/acilis_senaryosu.gd")
var hata := 0

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)

func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	# Kural 1: "Yatak: dolu/toplam" görünür; muhafız ve eş sayılır.
	var o := Oturum.new(kat, 1401)
	ACILIS.kur(o)
	var y := o.yonetim
	dene(BARINAK.toplam(y) == 4 and BARINAK.dolu(y) == 2, "İki kişilik hane 4 yatağın 2'sini doldurur (muhafız+eş)")
	dene(BARINAK.satir(y) == "Yatak: 2/4", "Satır 'Yatak: dolu/toplam' biçiminde")
	dene(BARINAK.acikta(y) == 0, "Başlangıçta açıkta kimse yok")
	dene(BARINAK.yeter_mi(y, 1), "Boş yatak varken yeni gelen sığar")
	dene(not BARINAK.metin(y, 1).contains("Yatacak yer yok"), "Yatak varken uyarı görünmez")
	# Ek şart: yatak satırı akçe yazmaz.
	var akce_once := y.akce
	BARINAK.metin(y, 1)
	dene(y.akce == akce_once, "Yatak satırı akçe yazmaz")

	# Kabul iddiası 1: dolu köyde kabul açıkta sayısını 1 artırır; ret 0 artırır.
	y.kabul({"ad": "Deneme Bir"})
	y.kabul({"ad": "Deneme İki"})
	y._barindir()
	dene(BARINAK.dolu(y) == 4 and BARINAK.acikta(y) == 0, "Dört kişi dört yatağa yerleşir")
	dene(not BARINAK.yeter_mi(y, 1), "Tam dolu köyde yeni gelen için yatak yok")
	dene(BARINAK.metin(y, 1).contains("Yatacak yer yok; açıkta kalır."), "Yatak yetmezse uyarı görünür; kabul kapanmaz")
	var once := BARINAK.acikta(y)
	var gelen_kisi := y.kabul({"ad": "Deneme Üç"})
	dene(BARINAK.acikta(y) == once + 1, "Dolu köyde kabul açıkta sayısını 1 artırır")
	dene(gelen_kisi.ev == -1, "Açıkta kalan kişi kayda evsiz yazılır")
	var ret_once := BARINAK.acikta(y)
	y.ret("Deneme X", false)
	dene(BARINAK.acikta(y) == ret_once, "Ret açıkta sayısını artırmaz")

	# Kabul iddiası 2: dört kişilik aile ve 2 yatak varken uyarı dördü için görünür.
	# Ek şart: kapasite .gd sabiti değildir, bina verisinden okunur (test türü veriden gelir).
	var kat2 := Katalog.new()
	kat2.yukle()
	kat2.binalar.turler["test_iki_yatak"] = {"kategori": "barinma", "boyut": [1, 1], "yatak": 2, "insa_gun": 0}
	var o2 := Oturum.new(kat2, 77)
	var b := KoyBinasi.new()
	b.id = 0
	b.tur = "test_iki_yatak"
	b.insa_kalan = 0
	o2.yonetim.binalar.append(b)
	dene(BARINAK.toplam(o2.yonetim) == 2, "Kapasite bina verisinden okunur (2 yatak)")
	dene(BARINAK.satir(o2.yonetim) == "Yatak: 0/2", "Sayı bina verisinden gelir, .gd sabitinden değil")
	dene(not BARINAK.yeter_mi(o2.yonetim, 4), "Dört kişilik aile iki yatağa sığmaz")
	dene(BARINAK.metin(o2.yonetim, 4).contains("Yatacak yer yok; açıkta kalır."), "Uyarı dördü için görünür")
	dene(BARINAK.yeter_mi(o2.yonetim, 2), "İki kişi iki yatağa sığar")

	# Uç durum: yatak 0 iken panel '0/0' der, çökmez.
	var kat3 := Katalog.new()
	kat3.yukle()
	var o3 := Oturum.new(kat3, 5)
	dene(BARINAK.toplam(o3.yonetim) == 0 and BARINAK.satir(o3.yonetim) == "Yatak: 0/0", "Yatak 0 iken panel 0/0 der, çökmez")

	# Kural 3: açıkta kalan kişi kayda yazılır (kayıt dönüşü aynı sayıyı verir).
	var geri := KoyYonetimi.kayittan(y.a, y.katalog, y.kaydet())
	dene(BARINAK.acikta(geri) == 1 and BARINAK.dolu(geri) == 4, "Açıkta kalan kişi kayıtta korunur")

	# Eski kayıt: 'ev' alanı olmayan köylü çökmez, açıkta sayılır (varsayılan -1).
	var eski := y.kaydet()
	for kayit in eski["koylular"]:
		kayit.erase("ev")
	var eski_geri := KoyYonetimi.kayittan(y.a, y.katalog, eski)
	dene(eski_geri.koylular.size() == y.koylular.size() and BARINAK.acikta(eski_geri) == eski_geri.koylular.size(), "Eski kayıtta ev alanı yoksa tüm kişiler açıkta okunur, çökme yok")

	print("BARINAK UYARISI: GEÇTİ" if hata == 0 else "BARINAK UYARISI: KALDI")
	quit(hata)