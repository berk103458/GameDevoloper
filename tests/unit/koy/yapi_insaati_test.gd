extends SceneTree
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func _initialize() -> void:
	var y := KoyYonetimi.new(KoyAyarlari.new(), BinaKatalogu.new(), 11)
	var b := KoyBinasi.new()
	b.id = 1
	b.tur = "cadir"
	b.seviye = 2
	b.insa_kalan = 3
	y.binalar.append(b)
	dene(y._insaat() == 0 and b.insa_kalan == 3, "İşçi yokken ilerleme0")
	var k := y.kabul({"ad": "İnşaat işçisi"})
	k.bayrak_ekle("hasta")
	dene(y._insaat() == 0 and b.insa_kalan == 3, "Hasta işçi ilerletmez")
	k.bayraklar.clear()
	y.gun = 21
	dene(y._insaat() == 0 and is_equal_approx(b.insa_artik, 0.5), "Kış çarpanı mevsim kaydından yarım gün taşır")
	var geri := KoyYonetimi.kayittan(y.a, y.katalog, JSON.parse_string(JSON.stringify(y.kaydet())))
	dene(geri.bina(1).insa_kalan == b.insa_kalan and is_equal_approx(geri.bina(1).insa_artik, b.insa_artik), "Yarım inşaatın kalan günü ve artığı kayıttan döner")
	y.gun += 1
	geri.gun += 1
	dene(y._insaat() == 1 and geri._insaat() == 1 and geri.bina(1).kaydet() == b.kaydet(), "Yükleme sonraki kış ilerlemesini korur")
	var carpani_once := MevsimYoneticisi.INSA_CARPANLARI.duplicate()
	MevsimYoneticisi.INSA_CARPANLARI[3] = 0.25
	dene(y._insaat() == 0 and is_equal_approx(b.insa_artik, 0.25), "İnşaat farklı mevsim kaydı değerini gerçekten okur")
	MevsimYoneticisi.INSA_CARPANLARI = carpani_once
	dene(b.seviye == 2, "İnşaat ADM-08 seviyesini değiştirmez")
	print("YAPI İNŞAATI: GEÇTİ" if hata == 0 else "YAPI İNŞAATI: KALDI")
	quit(hata)
