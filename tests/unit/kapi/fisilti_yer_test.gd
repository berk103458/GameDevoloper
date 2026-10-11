extends SceneTree
var hata := 0

func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 1717)
	var y := o.yonetim
	var kisi := y.kabul({"ad": "Yaşayan komşu"})
	var satir := 0
	for gun in 30:
		y.gun = gun
		var olaylar: Array[Dictionary] = []
		FisiltiGazetesi.gece(y, olaylar)
		satir += olaylar.size()
	dene(satir == 0 and FisiltiGazetesi.olay(o) == null, "Binasız 30 gecede yer pusulası 0")
	y.set_meta(FisiltiGazetesi.META, {})
	var b := KoyBinasi.new()
	b.id = 17
	b.tur = "ambar"
	y.binalar.append(b)
	var ambarli := 0
	for gun in 30:
		y.gun = gun
		FisiltiGazetesi.gece(y, [])
		var e := FisiltiGazetesi.olay(o)
		if e != null:
			ambarli += 1
			dene(e.metin_anahtari.contains("ambar") and not e.metin_anahtari.contains("{yer}"), "Pusula gerçek ambarı anar")
			dene(not e.metin_anahtari.contains("kışla") and not e.metin_anahtari.contains("değirmen"), "Olmayan bina adı basılmaz")
			dene(FisiltiGazetesi.uygula(o, e, 0).ok, "Pusula mevcut API ile arşivlenir")
	dene(ambarli > 0, "Ambarlı köyde pusula üretildi")
	y.set_meta(FisiltiGazetesi.META, {})
	y.gun = 30
	FisiltiGazetesi.gece(y, [])
	y.binalar.clear()
	dene(FisiltiGazetesi.olay(o) == null, "Sabah yanan/yıkılan bina anılmaz")
	y.binalar.append(b)
	kisi.saglik = 0
	dene(FisiltiGazetesi.olay(o) == null, "Ölen kişinin adı basılmaz")
	kisi.saglik = 100
	y.koylular.clear()
	dene(FisiltiGazetesi.olay(o) == null, "Köyden ayrılan kişinin adı basılmaz")
	print("FISILTI YER: GEÇTİ" if hata == 0 else "FISILTI YER: KALDI")
	quit(hata)

func dene(ok: bool, mesaj: String) -> void:
	if not ok:
		hata += 1
		print("KALDI: " + mesaj)
