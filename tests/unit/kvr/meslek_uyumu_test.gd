extends SceneTree
var hata := 0
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 93)
	var y := o.yonetim
	y.kaynaklar.kapasite = 10000
	for tur in ["gida", "odun", "tas", "kereste", "demir", "alet"]: y.kaynaklar.ekle(tur, 100)
	var k := y.kabul({"adli_id": "chr_015", "sinif": "ciftci", "stat": 5})
	k.moral = 50
	var b := _kur(y, "bostan")
	_kontrol(y.ata(k.id, b.id), "Bostancı gerçek kurulmuş bostana atanır")
	var once := o.kaydet()
	var gozlem := KoyluDenetcisi.satirlar(o)[0]
	_kontrol(is_equal_approx(gozlem["meslek_carpani"], 1.6) and is_equal_approx(gozlem["uretim"]["gida"], 3.2) and o.kaydet() == once, "Bostancı +%60 önizlemesi salt okunur")
	var u := {}
	var olaylar: Array[Dictionary] = []
	y._uret(u, olaylar)
	_kontrol(is_equal_approx(float(u["gida"]) + float(y._artik["%d:gida" % b.id]), 3.2), "Gerçek bostan üretimi 3.2 gıda + kesir artığı")
	var d := _kur(y, "demirhane")
	y.ata(k.id, d.id)
	_kontrol(is_equal_approx(MeslekUyumu.carpan(k, d.tur), 0.5) and is_equal_approx(MeslekUyumu.alet_riski(k, d.tur), 0.1), "Bostancı demirhanede −%50 ve %10 alet riski")
	var seed_ := 1
	var zar := RandomNumberGenerator.new()
	while true:
		zar.seed = seed_
		if zar.randf() < 0.1: break
		seed_ += 1
	y._rng.seed = seed_
	var alet := y.kaynaklar.miktar("alet")
	u.clear()
	olaylar.clear()
	y._uret(u, olaylar)
	_kontrol(y.kaynaklar.miktar("alet") == alet - 1 and olaylar.any(func(e: Dictionary) -> bool: return e["anahtar"].begins_with("Uyumsuz işte")), "Gerçek uyumsuz üretim RNG sonucu 1 alet kırar ve rapor verir")
	_kontrol(is_equal_approx(float(y._artik["%d:alet" % d.id]), 0.5), "Uyumsuz üretim kesri 0.5; seviye ve bayrak formülü korunur")
	var rng := y._rng.state
	y.kaynaklar.stok["demir"] = 0
	y._uret({}, [])
	_kontrol(y._rng.state == rng, "Girdi yokken çalışma olmaz; alet riski/RNG çalışmaz")
	y.kaynaklar.stok["demir"] = 10
	y.kaynaklar.kapasite = y.kaynaklar.toplam()
	y._uret({}, [])
	_kontrol(y._rng.state == rng, "Dolu ambarda risk/RNG çalışmaz")
	k.zanaat_turu = ZanaatTuru.Tur.DEMIRCI
	_kontrol(is_equal_approx(MeslekUyumu.carpan(k, d.tur), 1.6) and MeslekUyumu.alet_riski(k, d.tur) == 0.0, "Demirci demirhanede doğru uzmanlık")
	k.adli_id = &"chr_003"
	k.zanaat_turu = ZanaatTuru.Tur.CERRAH
	_kontrol(MeslekUyumu.carpan(k, d.tur) == 1.6, "Haydar'ın kaynak ikinci uzmanlığı dökümcülük korunur")
	var v := o.kaydet()
	var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(v)))
	_kontrol(geri.yonetim.bina(d.id).tur == "demirhane" and geri.yonetim._rng.state == y._rng.state, "Yeni türler ve alet RNG'si kayıtla korunur")
	var eski: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(BinaKatalogu.YOL))
	for tur in eski:
		if not String(tur).begins_with("_"): _kontrol(y.katalog.veri(tur) == eski[tur], "Eski katalog ezilmez: " + tur)
	print("MESLEK UYUMU: GEÇTİ" if hata == 0 else "MESLEK UYUMU: KALDI")
	quit(hata)
func _kur(y: KoyYonetimi, tur: String) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim(tur, h)["olur"]:
				var d := y.bina_kur(tur, h)
				var b := y.bina(d["id"])
				b.insa_kalan = 0
				return b
	return null
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
