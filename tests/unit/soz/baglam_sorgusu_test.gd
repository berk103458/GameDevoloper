## DIY-08: baglam sorgusu birim testi. Kabul iddialari tek tek kontrol edilir:
## sifahane yokken bina.sifahane false; sozluk yazma cagrisi 0; belgede olup sozlukte
## olmayan alan 1 hata; yoneticisiz cokme yok; ziyaret icinde dikilen bina gorunmez.
extends SceneTree

var hata := 0
var _katalog: Katalog


func _initialize() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	_katalog = Katalog.new()
	_katalog.yukle()

	# Kabul 4: yoneticisiz (bos oturum) cokme yok, alanlar false/0.
	var bos := BaglamSorgusu.new()
	var a := bos.yenile(null)
	_kontrol(BaglamSorgusu.eksik_alanlar(a).is_empty(), "Bos oturumda tum alanlar dolu")
	_kontrol(int(a.gun) == 0, "Yoneticisiz gun 0")
	_kontrol(int(a.nufus) == 0, "Yoneticisiz nufus 0")
	_kontrol(float(a.yatak) == 0.0, "Yoneticisiz yatak 0.0")
	_kontrol(bool(a.salgin) == false, "Yoneticisiz salgin false")
	_kontrol(not bool(a.bina.get("sifahane", false)), "Yoneticisiz bina.sifahane false")
	_kontrol((a.krizler as Array).is_empty(), "Yoneticisiz krizler bos")

	# Kabul 3: belgede olmayan alan varsa dogrulayici hata bulur (tek tek).
	_kontrol(BaglamSorgusu.eksik_alanlar(a).size() == 0, "Belgedeki alanlarin hepsi sozlukte")
	var bozuk := a.duplicate(true)
	bozuk["uydurma_alan"] = 1
	_kontrol(BaglamSorgusu.eksik_alanlar(bozuk).size() == 1, "Belgede olmayan alan 1 hata verir")
	bozuk.erase("gun")
	_kontrol(BaglamSorgusu.eksik_alanlar(bozuk).size() == 2, "Eksik alan da hataya eklenir")
	for alan in BaglamSorgusu.alanlar():
		_kontrol(a.has(alan), "Alan sozlukte var: %s" % alan)

	# Kabul 2: donen deger degistirilemez; kopyayi degistirmek saklanani bozmaz.
	var o := Oturum.new(_katalog, 4213)
	var s := BaglamSorgusu.new()
	s.kur(o, null)
	_kontrol(int(s.oku().gun) == int(o.yonetim.gun), "sozluk.gun canli gunle ayni")
	var disari := s.oku()
	disari["gun"] = 9999
	disari["nufus"] = 9999
	_kontrol(int(s.oku().gun) == int(o.yonetim.gun), "Donen kopyayi degistirmek sozlugu bozmaz")
	_kontrol(int(s.oku().nufus) == int(o.yonetim.nufus()), "Donen kopya nufusu da bozmaz")

	# Kabul 1: ziyaret icinde dikilen bina ayni konusmada gorunmez.
	_ziyaret_bina(o)

	# Kabul 1b: kayit yuklenince sozluk kayittan degil canli yoneticilerden kurulur.
	_kayit_ziyaret(o)

	# Kabul 2b: sozluk kurmak hicbir yoneticiye yazmaz.
	_yazma_sayaci()

	await process_frame
	await process_frame
	await create_timer(0.8).timeout
	print("BAGLAM SORGUSU: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)


func _ziyaret_bina(o: Oturum) -> void:
	var s := BaglamSorgusu.new()
	s.kur(o, null)
	_kontrol(not bool(s.oku().bina.get("sifahane", false)), "Baslangicta sifahane yok")
	_kontrol(s.oku().bina.has("sifahane") and s.oku().bina["sifahane"] == false, "Olmayan bina anahtari dogrudan false doner")
	var d := _kur_bina(o.yonetim, "sifahane")
	_kontrol(d.get("olur", false), "Sifahane kuruldu")
	_kontrol(not bool(s.oku().bina.get("sifahane", false)), "Ziyaret icinde dikilen bina sozlukte gorunmez")
	var canli := s.yenile(o, null)
	_kontrol(bool(canli.bina.get("sifahane", false)), "Yenilenen sozluk canli binayi gorur")


func _kayit_ziyaret(o: Oturum) -> void:
	var s := BaglamSorgusu.new()
	var ilk := s.yenile(o, null)
	var kopya: KoyYonetimi = KoyYonetimi.kayittan(_katalog.koy_ayarlari, _katalog.binalar, JSON.parse_string(JSON.stringify(o.yonetim.kaydet())))
	# Kayit yuklenince sozluk kayittan degil, yuklenen canli yoneticiden kurulur.
	var yuklu := Oturum.new(_katalog, 1)
	yuklu.yonetim = kopya
	var yeni := BaglamSorgusu.new().yenile(yuklu, null)
	_kontrol(int(yeni.gun) == int(ilk.gun), "Kayit sonrasi gun korunur")
	_kontrol(int(yeni.nufus) == int(ilk.nufus), "Kayit sonrasi nufus korunur")
	_kontrol(str(yeni.bina) == str(ilk.bina), "Kayit sonrasi bina sozlugu ayni")


func _yazma_sayaci() -> void:
	var o := Oturum.new(_katalog, 77)
	_kabul(o.yonetim, "yz0")
	_kabul(o.yonetim, "yz1")
	_kur_bina(o.yonetim, "kulube")
	var once := _damga(o)
	var s := BaglamSorgusu.new()
	s.kur(o, null)
	_kontrol(_damga(o) == once, "Sozluk kurmak hicbir yoneticiye yazmaz")


## Yazma sayaci: oturumun degisebilir durumunu metne cevirip karsilastirir.
func _damga(o: Oturum) -> String:
	return JSON.stringify({
		"y": o.yonetim.kaydet(),
		"kadro": o.kadro.kaydet(),
		"bayraklar": o.bayraklar,
		"gorulen": o.gorulen_olaylar.keys().map(func(x): return String(x)),
		"kasa": o.kasa_transferleri,
		"yetenek": o.muhafiz_yetenekleri,
	})


func _kabul(y: KoyYonetimi, ad: String) -> void:
	y.kabul({"ad": ad, "sinif": "ciftci", "stat": 5})


func _kur_bina(y: KoyYonetimi, tur: String) -> Dictionary:
	y.kaynaklar.kapasite = 10000
	for t in ["odun", "tas", "kereste", "alet"]:
		y.kaynaklar.ekle(t, 50)
	var d := y.bina_kur(tur, _sag_yol(y))
	if d.get("olur", false):
		y.bina(int(d["id"])).insa_kalan = 0
	return d


func _sag_yol(y: KoyYonetimi) -> Vector2i:
	var ayar := y.a
	var x := ayar.meydan.position.x + ayar.meydan.size.x / 2 + 1
	for yy in range(ayar.meydan.end.y, ayar.izgara_boyut.y):
		var h := Vector2i(x, yy)
		if y.izgara.yerlesebilir(_hucreler(h, Vector2i(3, 3)))["olur"]:
			return h
	return Vector2i(x, ayar.meydan.end.y)


func _hucreler(h: Vector2i, b: Vector2i) -> Array[Vector2i]:
	var r: Array[Vector2i] = []
	for yy in b.y:
		for xx in b.x:
			r.append(h + Vector2i(xx, yy))
	return r


func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
