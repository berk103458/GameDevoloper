extends SceneTree
var hata := 0
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 29)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y.kaynaklar.kapasite = 10000
	y.akce = 1000
	for tur in ["gida", "tomruk", "odun", "tas", "kereste", "alet", "demir"]: y.kaynaklar.ekle(tur, 100)
	var b := _kur(y, "tarla")
	var h := _kur(y, "hizarhane")
	var k := y.kabul({"sinif": "ciftci", "stat": 5})
	k.moral = 50
	var once := o.kaydet()
	var iyi := AtamaOnizlemesi.oku(y, k.id, b.id)
	_kontrol(iyi.olur and iyi.yesil and is_equal_approx(iyi.sonra.gida, 3.2), "Uygun tarla gerçek formülle yeşil 3.20 brüt")
	var kotu := AtamaOnizlemesi.oku(y, k.id, h.id)
	_kontrol(kotu.olur and not kotu.yesil and is_equal_approx(kotu.sonra.odun, 1.5), "Uyumsuz hızar atamaya izin verir ama kırmızı 1.50 brüt")
	_kontrol(o.kaydet() == once, "Önizleme canlı atama/RNG/stok/artık değiştirmez")
	y.ata(k.id, b.id)
	var artik := float(y._artik.get("%d:gida" % b.id, 0.0))
	var rapor := y.gece()
	_kontrol(is_equal_approx(float(rapor.uretim.gida) + float(y._artik.get("%d:gida" % b.id, 0.0)) - artik, iyi.sonra.gida), "Önizleme gerçek üretim ve kesir artığıyla eşleşir")
	var cocuk := y.kabul({"adli_id": "chr_006"})
	_kontrol(not AtamaOnizlemesi.oku(y, cocuk.id, b.id).olur, "Çocuk ağır iş dropu engellenir")
	while y.calisanlar(b.id).size() < y.katalog.slot(b.tur):
		var kisi := y.kabul({})
		y.ata(kisi.id, b.id)
	var ek := y.kabul({})
	_kontrol(not AtamaOnizlemesi.oku(y, ek.id, b.id).olur, "Dolu yuva dropu engellenir")
	var deg := _kur(y, "degirmen")
	var isci := y.kabul({"adli_id": "chr_030", "stat": 5})
	isci.moral = 50
	y.ata(isci.id, deg.id)
	var usta := y.kabul({"adli_id": "chr_013", "stat": 5})
	var danisman := AtamaOnizlemesi.oku(y, usta.id, deg.id)
	_kontrol(danisman.yesil and is_equal_approx(danisman.once.gida, 4.8) and is_equal_approx(danisman.sonra.gida, 5.52), "Yaşlı danışmanın gerçek %15 bina sinerjisi yeşil önizlenir")
	var katip := y.kabul({"adli_id": "chr_007"})
	var grev := AtamaOnizlemesi.oku(y, katip.id, h.id)
	_kontrol(grev.olur and not grev.yesil and grev.neden.contains("Grev") and grev.sonra.is_empty(), "Grevci yanlış işte sıfır üretim ve kırmızı uyarı")
	_kontrol(not AtamaOnizlemesi.oku(y, 99999, h.id).olur, "Ayrılmış kişi dropu reddedilir")
	print("ATAMA ÖNİZLEMESİ: GEÇTİ" if hata == 0 else "ATAMA ÖNİZLEMESİ: KALDI")
	quit(hata)
func _kur(y: KoyYonetimi, tur: String) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim(tur, h)["olur"]:
				var b := y.bina(y.bina_kur(tur, h)["id"])
				b.insa_kalan = 0
				return b
	return null
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
