extends SceneTree
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func yer(y: KoyYonetimi, tur: String) -> Vector2i:
	var b := KoyBinasi.new()
	b.tur = tur
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			b.hucre = Vector2i(cx, cy)
			if y.izgara.yerlesebilir(b.hucreler(y.katalog)).olur: return b.hucre
	return Vector2i(-1, -1)
func _initialize() -> void:
	var y := KoyYonetimi.new(KoyAyarlari.new(), BinaKatalogu.new(), 101)
	y.a.ambar_taban_kapasite = 10000
	y.kaynaklar = Kaynaklar.new(10000, {"odun": 1000, "tas": 1000, "kereste": 1000, "harc": 1000, "alet": 1000})
	y.akce = 1000
	var h := yer(y, "tas_ev")
	var foto := y.kaydet()
	dene(y.yerlesim("tas_ev", h).get("neden") == "yapi_bilgisi", "Bilgisiz K2 önizlemesi reddedilir")
	dene(not y.bina_kur("tas_ev", h).olur and y.kaydet() == foto, "Bilgisiz gerçek kurulumda kasa/kayıt değişmez")
	var usta := y.kabul({"ad": "Bilgi sahibi"})
	usta.yapi_bilgisi = YapiKilidi.bilgi_oku(["tas_ev", "atolye"])
	var kulube := KoyBinasi.new()
	kulube.id = 90
	kulube.tur = "kulube"
	kulube.seviye = 3
	kulube.hucre = yer(y, "kulube")
	y.binalar.append(kulube)
	y.izgara.yerlestir(kulube.id, kulube.hucreler(y.katalog))
	dene(YapiKilidi.durum(y, "atolye").get("neden") == "yapi_on_kademe", "Hazır K2 olmadan K3 kurulamaz")
	h = yer(y, "tas_ev")
	var kur := y.bina_kur("tas_ev", h)
	dene(kur.olur, "Bilgi ve hazır K1 ile K2 gerçek kurulumu")
	if kur.olur:
		var b := y.bina(kur.id)
		dene(b.seviye == 1 and kulube.seviye == 3, "YAP kademesi ADM seviyelerini değiştirmez")
		dene(not YapiKilidi.durum(y, "atolye").acik, "Yarım K2 üst kademeyi açmaz")
		b.insa_kalan = 0
		dene(YapiKilidi.durum(y, "atolye").acik, "Hazır K2 ve bilgi K3 açar")
		var geri := KoyYonetimi.kayittan(y.a, y.katalog, JSON.parse_string(JSON.stringify(y.kaydet())))
		dene(geri.koylu(usta.id).yapi_bilgisi == usta.yapi_bilgisi, "Optional bilgi gerçek JSON yüklenir")
		usta.saglik = 0
		dene(not YapiKilidi.durum(y, "tas_ev").acik and y.bina(b.id) != null, "Ölen bilgi sahibi yeni kurulumu kapatır; bina durur")
		usta.saglik = 100
		var ust := KoyBinasi.new()
		ust.id = 91
		ust.tur = "atolye"
		y.binalar.append(ust)
		y.bina_yik(b.id)
		dene(YapiKilidi.durum(y, "atolye").get("neden") == "yapi_on_kademe", "K2 yıkılınca mevcut K3 alt kademe yerine geçmez")
		dene(YapiKilidi.kurulu_kademe(y, b.id) == 0, "Yıkılan yapının kurulu kademesi0")
	dene(Koylu.kayittan({"id": 9}).yapi_bilgisi.is_empty(), "Eski kayda bilgi uydurulmaz")
	print("YAPI KURULUM KİLİDİ: GEÇTİ" if hata == 0 else "YAPI KURULUM KİLİDİ: KALDI")
	quit(hata)
