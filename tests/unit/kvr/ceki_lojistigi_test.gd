extends SceneTree
var hata := 0
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 76)
	var y := o.yonetim
	y.akce = 1000
	y.kaynaklar.kapasite = 10000
	for t in ["odun", "tas"]: y.kaynaklar.ekle(t, 100)
	var kamp := _kur(y, "odunluk")
	var ahir := _kur(y, "ahir")
	while not y.kervan_gunu(): y.gun += 1
	_kontrol(not y.lojistik.al(y, "ejderha"), "Bilinmeyen tür alınmaz")
	ahir.insa_kalan = 1
	_kontrol(not y.lojistik.al(y, "okuz"), "Bitmemiş ahır hayvan alamaz")
	ahir.insa_kalan = 0
	var para := y.akce
	_kontrol(y.lojistik.al(y, "okuz") and y.akce == para - 40, "Kamu kasasıyla gerçek hayvan alımı")
	_kontrol(y.lojistik.sefer(y) == {"kapasite": 9, "sure": 0.5}, "Öküz: sefer kapasitesi ×3, süre /2")
	_kontrol(y.lojistik.al(y, "inek") and not y.lojistik.al(y, "okuz"), "İnek de çeker; ahır kapasitesi aşılmaz")
	y.lojistik = CekiLojistigi.new()
	var olay: Array[Dictionary] = []
	var u := {}
	y._ambara(kamp, "tomruk", 12.0, 0, u, olay)
	_kontrol(y.kaynaklar.miktar("tomruk") == 3 and y.lojistik.bekleyen.get(str(kamp.id), 0) == 9, "Elle tek sefer 3 teslim eder; yük kaybolmaz")
	var kopya := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	_kontrol(kopya.yonetim.lojistik.kaydet() == y.lojistik.kaydet(), "Bekleyen yük ve sefer zamanı JSON ile korunur")
	var r := {}
	y.lojistik.gece_basla(y, r)
	_kontrol(r.get("tomruk", 0) == 3 and y.lojistik.bekleyen.get(str(kamp.id), 0) == 6, "Ertesi gece bekleyen yük taşınır")
	y.lojistik.hayvanlar.inek = 1
	r.clear()
	y.lojistik.gece_basla(y, r)
	_kontrol(r.get("tomruk", 0) == 6 and y.lojistik.bekleyen.is_empty(), "İnek bekleyen sevkiyatı boşaltır")
	y.lojistik = CekiLojistigi.new()
	y.lojistik.hayvanlar.okuz = 1
	u.clear()
	var once := y.kaynaklar.miktar("tomruk")
	y._ambara(kamp, "tomruk", 20, 0, u, olay)
	_kontrol(y.kaynaklar.miktar("tomruk") == once + 18 and y.lojistik.bekleyen.get(str(kamp.id), 0) == 2, "Aynı gece iki 9 birim sefer; üretim çarpılmaz")
	y.kaynaklar.kapasite = y.kaynaklar.toplam()
	y.lojistik.gece_basla(y, {})
	_kontrol(y.lojistik.bekleyen.get(str(kamp.id), 0) == 2, "Dolu ambar yükü kaybettirmez")
	ahir.insa_kalan = 1
	_kontrol(y.lojistik.sefer(y).kapasite == 3, "Kullanılamayan ahır bonus vermez")
	var eski := y.kaydet()
	eski.erase("lojistik")
	_kontrol(KoyYonetimi.kayittan(y.a, y.katalog, eski).lojistik.sayi() == 0, "Eski kayıt hayvanı sıfır varsayar")
	_kontrol(CekiLojistigi.kayittan({"hayvanlar": "bozuk", "bekleyen": []}).sayi() == 0, "Bozuk ek veri güvenle varsayılana döner")
	ahir.insa_kalan = 0
	y.lojistik = CekiLojistigi.new()
	y._artik.clear()
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y.kaynaklar.kapasite = 10000
	y.kaynaklar.ekle("gida", 100)
	for i in 2:
		var k := y.kabul({"ad": "Oduncu", "sinif": "oduncu", "stat": 5})
		k.moral = 50
		y.ata(k.id, kamp.id)
	var hayvanli := KoyYonetimi.kayittan(y.a, y.katalog, JSON.parse_string(JSON.stringify(y.kaydet())))
	hayvanli.lojistik.hayvanlar.okuz = 1
	var elle := y.gece()
	var cekili := hayvanli.gece()
	_kontrol(elle.uretim.get("tomruk", 0) == 3 and cekili.uretim.get("tomruk", 0) >= 6, "Gerçek gece: iki oduncunun hayvanlı sevkiyatı elle taşımadan fazladır")
	_kontrol(not y.lojistik.bekleyen.is_empty() and hayvanli.lojistik.bekleyen.is_empty(), "Gerçek üretim artmaz; elle kalan yük kaynak binada bekler")
	print("ÇEKİ LOJİSTİĞİ: GEÇTİ" if hata == 0 else "ÇEKİ LOJİSTİĞİ: KALDI")
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
