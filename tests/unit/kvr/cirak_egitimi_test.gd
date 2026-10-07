extends SceneTree
var hata := 0
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 93)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y.kaynaklar.kapasite = 10000
	for tur in ["gida", "odun", "tas", "kereste", "demir", "alet"]: y.kaynaklar.ekle(tur, 300)
	var b := _kur(y)
	var u := y.kabul({"adli_id": "chr_013", "sinif": "ciftci", "stat": 5})
	var k := y.kabul({"sinif": "ciftci", "stat": 3})
	u.moral = 80
	k.moral = 80
	_kontrol(y.ata(u.id, b.id) and y.ata(k.id, b.id), "Gerçek tarla ataması")
	_kontrol(CirakEgitimi.usta(u) and not u.usta_mi(), "Osman Dayı kaynak ustalığı, düşük statta da öğretir")
	y._uret({}, [])
	_kontrol(k.egitim.is_empty(), "Doğrudan üretim eğitim gecesi sayılmaz")
	for n in range(1, 3):
		y.gece()
		_kontrol(k.egitim.get("gece") == n and k.stat == 3, "Gerçek ortak gece: %d" % n)
	var v := JSON.parse_string(JSON.stringify(o.kaydet())) as Dictionary
	var geri := Oturum.kayittan(kat, v)
	geri.yonetim.a = y.a.duplicate(true)
	geri.yonetim._ambar_kapasitesi()
	_kontrol(geri.yonetim.koylu(k.id).egitim == k.egitim, "JSON eğitim sayacını korur")
	for n in range(3, 6):
		var rapor := y.gece()
		geri.yonetim.gece()
		_kontrol(k.egitim.get("gece") == n, "Kayıttan sonraki gerçek gece: %d" % n)
		_kontrol(k.egitim == geri.yonetim.koylu(k.id).egitim and k.stat == geri.yonetim.koylu(k.id).stat, "Yükleme aynı ilerlemeyi üretir")
		if n == 5: _kontrol(rapor["olaylar"].any(func(e: Dictionary) -> bool: return e["anahtar"].contains("yarı usta")), "Beşinci gecede rapor")
	_kontrol(k.stat == 6 and not k.usta_mi() and k.zanaat_turu == u.zanaat_turu and k.egitim["tamamlandi"], "Yarı usta; tam usta değil")
	var son := y.gece()
	_kontrol(k.egitim["gece"] == 5 and not son["olaylar"].any(func(e: Dictionary) -> bool: return e["anahtar"].contains("yarı usta")), "Terfi yalnız bir kez")
	var c := y.kabul({"sinif": "ciftci", "stat": 2})
	y.ata(c.id, b.id)
	var isler := {u.id: b.id, c.id: b.id}
	CirakEgitimi.gece(y, isler, [])
	_kontrol(c.egitim["gece"] == 1, "Yeni çırak ilk ortak gece")
	c.bayraklar.append("hasta")
	CirakEgitimi.gece(y, isler, [])
	_kontrol(c.egitim["gece"] == 1, "Hasta çırak ilerlemez")
	c.bayraklar.clear()
	CirakEgitimi.gece(y, {}, [])
	_kontrol(c.egitim["gece"] == 1, "Üretim yoksa ilerleme yok")
	u.is_yeri = -1
	CirakEgitimi.gece(y, isler, [])
	_kontrol(c.egitim.is_empty(), "Usta ayrılırsa sayaç sıfırlanır")
	_kontrol(Koylu.kayittan({"id": 1}).egitim.is_empty(), "Eski kayıt eğitim gerektirmez")
	for bozuk in [null, {}, {"usta": 1, "bina": 2, "gece": 1.5, "tamamlandi": false}, {"usta": 1, "bina": 2, "gece": 5, "tamamlandi": false}, {"usta": -1, "bina": 2, "gece": 2, "tamamlandi": false}]:
		_kontrol(CirakEgitimi.oku(bozuk).is_empty(), "Bozuk eğitim reddedilir")
	var satirlar := KoyluDenetcisi.satirlar(o)
	_kontrol(satirlar.any(func(s: Dictionary) -> bool: return String(s.get("egitim", "")).contains("Yarı usta")), "Denetçi tamamlanan eğitimi gösterir")
	print("ÇIRAK EĞİTİMİ: GEÇTİ" if hata == 0 else "ÇIRAK EĞİTİMİ: KALDI")
	quit(hata)
func _kur(y: KoyYonetimi) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim("tarla", h)["olur"]:
				var d := y.bina_kur("tarla", h)
				var b := y.bina(d["id"])
				b.insa_kalan = 0
				return b
	return null
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
