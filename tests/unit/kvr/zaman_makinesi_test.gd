extends SceneTree

class OlaysizOturum extends Oturum:
	func olay_sec() -> OlayVerisi:
		return null

class OlayliOturum extends OlaysizOturum:
	var test_olay: OlayVerisi
	func olay_sec() -> OlayVerisi:
		return test_olay

var hata := 0
var katalog: Katalog

func _initialize() -> void:
	call_deferred("_calistir")

func _calistir() -> void:
	katalog = Katalog.new()
	katalog.yukle()
	for adet in [1, 5, 10]:
		var gercek := OlaysizOturum.new(katalog, 89)
		var dogrudan := OlaysizOturum.new(katalog, 89)
		_hazirla(gercek)
		_hazirla(dogrudan)
		var sonuc := ZamanMakinesi.ilerlet(gercek, adet, 123)
		for i in adet:
			dogrudan.gece_sonu()
		_kontrol(sonuc["ok"] and sonuc["gecen"] == adet and gercek.gun == adet and sonuc["raporlar"].size() == adet, "Tam 1/5/10 gece ve rapor sayısı")
		_kontrol(JSON.stringify(gercek.kaydet()) == JSON.stringify(dogrudan.kaydet()), "Üretim/tüketim, kadro ve RNG doğrudan gerçek gece çağrılarıyla aynı")
		var once := JSON.stringify(gercek.kaydet())
		_kontrol(not ZamanMakinesi.ilerlet(gercek, 2)["ok"] and JSON.stringify(gercek.kaydet()) == once, "Geçersiz adım yan etkisizdir")
	var biten := OlaysizOturum.new(katalog, 7)
	biten.yonetim.gun = biten.yonetim.a.emniyet_gun
	biten.yonetim.en_yuksek_nufus = biten.yonetim.a.emniyet_nufus
	var erken := ZamanMakinesi.ilerlet(biten, 10)
	_kontrol(erken["gecen"] == 1 and erken["son"] == "halk_kirildi", "Gerçek terminal sonuçta ilerleme durur")
	var gun := biten.gun
	_kontrol(not ZamanMakinesi.ilerlet(biten, 1)["ok"] and biten.gun == gun, "Bitmiş oyun tekrar hesaplanmaz")
	var olayli := OlayliOturum.new(katalog, 9)
	_hazirla(olayli)
	olayli.test_olay = _olay()
	var secim := ZamanMakinesi.ilerlet(olayli, 5, 12)
	_kontrol(secim["gecen"] == 5 and olayli.bayraklar.get(&"debug_test", false), "Geçerli gece seçeneği gerçek olay API'sinden uygulanır")
	for r: Dictionary in secim["raporlar"]:
		_kontrol(r["secenek"] == 1 and r["mini_oyun_puan"] == 0, "Koşulu tutmayan seçenek seçilmez; mini oyun ödülü uydurulmaz")
	olayli.test_olay.secenek_etkileri[1]["gerekli"] = {"akce": 1000000}
	var bekleyen := ZamanMakinesi.ilerlet(olayli, 5)
	_kontrol(bekleyen["gecen"] == 1 and bekleyen["bekleyen_olay"] == olayli.test_olay, "Geçersiz tüm seçeneklerde olay korunur; gizlice atlanmaz")
	print("ZAMAN MAKİNESİ: GEÇTİ" if hata == 0 else "ZAMAN MAKİNESİ: KALDI")
	quit(hata)

func _hazirla(o: Oturum) -> void:
	for i in 3:
		o.yonetim.kabul({"ad": "Test %d" % i, "sinif": "ciftci", "stat": 5})
	o.yonetim.kaynaklar.ekle("gida", 100)
	var a := o.yonetim.a
	var hucre := Vector2i(a.meydan.position.x + a.meydan.size.x / 2 + 1, a.meydan.end.y + 1)
	var d := o.yonetim.bina_kur("cadir", hucre)
	_kontrol(d["olur"], "Test köyünde gerçek katalogdan barınak kurulur")
	if d["olur"]:
		o.yonetim.bina(d["id"]).insa_kalan = 0

func _olay() -> OlayVerisi:
	var o := OlayVerisi.new()
	o.id = &"debug_fixture"
	o.metin_anahtari = "debug_fixture.metin"
	o.secenek_etkileri = [{"gerekli": {"akce": 1000000}}, {"bayrak": "debug_test", "oyun": "harman", "oyun_odul": {"akce": 20}, "oyun_esik": 10}]
	return o

func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
