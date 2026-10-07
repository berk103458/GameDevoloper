extends SceneTree
var hata := 0
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 31)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y.kaynaklar.kapasite = 10000
	y.akce = 1000
	for tur in ["gida", "tomruk", "odun", "tas", "kereste", "alet"]: y.kaynaklar.ekle(tur, 100)
	var k := y.kabul({"ad": "Ali", "sinif": "ciftci", "stat": 5})
	k.moral = 50
	y.muhafiz_ata(k.id)
	_kontrol(not NobetYorgunlugu.aktif(k, y) and is_equal_approx(IsKazalari.risk(k, y), 0.10), "İlk gece eski uyuklama riski")
	y._rng.seed = _tohum(0.14, 1.0)
	y.gece()
	_kontrol(NobetYorgunlugu.aktif(k, y) and is_equal_approx(IsKazalari.risk(k, y), 0.14), "Gerçek uyanık nöbet ertesi gün riski %40 artırır")
	kat.koy_ayarlari = y.a.duplicate(true)
	var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	geri.yonetim.a = y.a.duplicate(true)
	geri.yonetim._ambar_kapasitesi()
	_kontrol(geri.yonetim.koylu(k.id).yorgunluk == k.yorgunluk and NobetYorgunlugu.aktif(geri.yonetim.koylu(k.id), geri.yonetim), "Yorgunluk JSON ile takvime bağlı korunur")
	y._rng.seed = _tohum(0.10, 0.14)
	geri.yonetim._rng.seed = y._rng.seed
	y.gece()
	geri.yonetim.gece()
	_kontrol(IsKazalari.uyuyor(k) and y.etkin_muhafiz_sayisi() == 0, "Yalnız artırılmış risk aralığındaki zar gerçek nöbette uyutur")
	_kontrol(k.is_kazasi == geri.yonetim.koylu(k.id).is_kazasi and y._rng.state == geri.yonetim._rng.state, "Yükleme aynı yorgun uyuklama ve RNG yi üretir")
	_kontrol(not NobetYorgunlugu.aktif(k, y), "Uyuyakalan nöbet yeni uykusuzluk sayılmaz")
	y.gece()
	_kontrol(not IsKazalari.uyuyor(k) and not NobetYorgunlugu.aktif(k, y), "Uyuma etkisi bitse de uyuduğu gece yeni vardiya sayılmaz")
	k.moral = 50
	y._rng.seed = _tohum(0.14, 1.0)
	y.gece()
	var b := _kur(y)
	y.kaynaklar.stok["alet"] = 0
	y.ata(k.id, b.id)
	_kontrol(is_equal_approx(IsKazalari.risk(k, y), 0.112), "Nöbetten sonra uyumsuz gündüz işinde yaralanma %8→%11.2")
	k.moral = 50
	y._rng.seed = _tohum(0.08, 0.112)
	y.gece()
	_kontrol(k.is_kazasi.get("tur") == "yaralanma" and k.saglik == 80, "Artan aralıktaki zar gerçek üretim gecesinde yaralar")
	y.bosalt(k.id)
	y.gece()
	_kontrol(not NobetYorgunlugu.aktif(k, y), "Nöbetsiz gece sonrası yorgunluk sona erer")
	var uygun := y.kabul({"sinif": "asker"})
	y.muhafiz_ata(uygun.id)
	uygun.yorgunluk = {"son_gece": y.gun - 1}
	_kontrol(IsKazalari.risk(uygun, y) == 0.0, "Mevcut uyumlu nöbet bağışıklığı korunur; sıfır risk büyütülmez")
	var once := o.kaydet()
	NobetYorgunlugu.nobetciler(y)
	NobetYorgunlugu.metin(k, y)
	_kontrol(o.kaydet() == once, "Yorgunluk gözlemi salt okunur")
	_kontrol(Koylu.kayittan({"id": 1}).yorgunluk.is_empty(), "Eski kayıt dinlenmiş başlar")
	for bozuk in [null, {}, {"son_gece": -1}, {"son_gece": 1.5}]:
		_kontrol(NobetYorgunlugu.oku(bozuk).is_empty(), "Bozuk yorgunluk kaydı reddedilir")
	print("NÖBET YORGUNLUĞU: GEÇTİ" if hata == 0 else "NÖBET YORGUNLUĞU: KALDI")
	quit(hata)
func _tohum(alt: float, ust: float) -> int:
	var zar := RandomNumberGenerator.new()
	for n in range(1, 10000):
		zar.seed = n
		var r := zar.randf()
		if r >= alt and r < ust: return n
	return 1
func _kur(y: KoyYonetimi) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim("hizarhane", h)["olur"]:
				var b := y.bina(y.bina_kur("hizarhane", h)["id"])
				b.insa_kalan = 0
				return b
	return null
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
