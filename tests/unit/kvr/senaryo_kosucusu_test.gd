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
	katalog = Katalog.new()
	katalog.yukle()
	var normal := _oturum()
	var once := JSON.stringify(normal.kaydet())
	_kontrol(not SenaryoKosucusu.calistir(normal, "yok")["ok"] and JSON.stringify(normal.kaydet()) == once, "Geçersiz senaryo yan etkisiz")
	normal.yonetim.set_meta(GeceDeneyi.META, func(_y: KoyYonetimi) -> void: pass)
	_kontrol(not SenaryoKosucusu.calistir(normal, "kitlik_10")["ok"] and normal.yonetim.has_meta(GeceDeneyi.META), "Başka gece deneyi ezilmez")
	var kitlik := _oturum()
	var ayarlar := kitlik.yonetim.a
	var r := SenaryoKosucusu.calistir(kitlik, "kitlik_10", 14)
	_kontrol(r["gecen"] == 10 and r["kayiplar"].size() == 10 and r["raporlar"].size() == 10, "Tam 10 gerçek gece ve gıda kaybı raporu")
	for kayit: Dictionary in r["raporlar"]:
		var rapor: Dictionary = kayit["rapor"]
		_kontrol(rapor["tuketim"].get("gida", -1) == 0 and _olay_var(rapor, "koy.olay.aclik"), "Tarla gerçekten üretse de kayıp sonrası açlık normal tüketim API'sinden")
	_kontrol(r["kayiplar"][0]["gida_kaybi"] > 0 and not kitlik.yonetim.has_meta(GeceDeneyi.META) and kitlik.yonetim.a == ayarlar, "Üretilen gıda da kaybolur; deney/ayar temizlenir")
	var baskin := _oturum()
	var asil := baskin.yonetim.a
	var zar := asil.baskin_zar
	r = SenaryoKosucusu.calistir(baskin, "baskin", 14)
	_kontrol(r["gecen"] == 1 and _olay_var(r["raporlar"][0]["rapor"], "koy.olay.baskin"), "Gerçek husumet baskını kesin oluşur")
	_kontrol(baskin.yonetim.a == asil and asil.baskin_zar == zar, "Baskın olasılığı kaynak ayarda değişmez")
	var veba := _oturum()
	r = SenaryoKosucusu.calistir(veba, "veba", 14)
	_kontrol(r["gecen"] == 1 and r["hazirlik"]["hasta_koylu"] == 2, "Salgın stres girdisi gerçek köylülere")
	for k in veba.yonetim.koylular:
		_kontrol("hasta" in k.bayraklar and k.saglik == 65, "−40 sağlık ve normal ev iyileşmesi +5")
	var geri := Oturum.kayittan(katalog, JSON.parse_string(JSON.stringify(veba.kaydet())))
	_kontrol("hasta" in geri.yonetim.koylular[0].bayraklar and geri.yonetim.koylular[0].saglik == 65, "Senaryo sonuçları normal kayıtta korunur")
	var terminal := _oturum()
	terminal.yonetim.koylular[0].saglik = 1
	terminal.yonetim.koylular[1].saglik = 1
	terminal.yonetim.en_yuksek_nufus = terminal.yonetim.a.emniyet_nufus
	terminal.gun = terminal.yonetim.a.emniyet_gun
	r = SenaryoKosucusu.calistir(terminal, "kitlik_10", 3)
	_kontrol(r["gecen"] == 1 and r["son"] == "halk_kirildi" and not terminal.yonetim.has_meta(GeceDeneyi.META), "Terminal sonuçta erken durulur ve deney temizlenir")
	var bekleyen := OlayliOturum.new(katalog, 83)
	_hazirla(bekleyen)
	bekleyen.test_olay = OlayVerisi.new()
	bekleyen.test_olay.id = &"debug_fixture"
	bekleyen.test_olay.secenek_etkileri = [{"gerekli": {"akce": 1000000}}]
	r = SenaryoKosucusu.calistir(bekleyen, "kitlik_10", 4)
	_kontrol(r["gecen"] == 1 and r["bekleyen_olay"] == bekleyen.test_olay and not bekleyen.yonetim.has_meta(GeceDeneyi.META), "Bekleyen olay korunur, kıtlık hooku sonraki geceye sızmaz")
	print("SENARYO KOŞUCUSU: GEÇTİ" if hata == 0 else "SENARYO KOŞUCUSU: KALDI")
	quit(hata)

func _oturum() -> Oturum:
	var o := OlaysizOturum.new(katalog, 83)
	_hazirla(o)
	return o
func _hazirla(o: Oturum) -> void:
	# Model fixture terminal isyanı engeller; tüketim/ölüm hesapları gerçek kalır.
	o.yonetim.a = o.yonetim.a.duplicate(true)
	o.yonetim.a.isyan_esigi = -1
	for i in 2:
		o.yonetim.kabul({"ad": "Test %d" % i, "sinif": "ciftci", "stat": 5})
	for tur in ["cadir", "tarla"]:
		var bulundu := false
		for cy in o.yonetim.a.izgara_boyut.y:
			for cx in o.yonetim.a.izgara_boyut.x:
				var h := Vector2i(cx, cy)
				if o.yonetim.yerlesim(tur, h)["olur"]:
					var d := o.yonetim.bina_kur(tur, h)
					o.yonetim.bina(d["id"]).insa_kalan = 0
					if tur == "tarla":
						o.yonetim.ata(o.yonetim.koylular[0].id, d["id"])
					bulundu = true
					break
			if bulundu: break
		_kontrol(bulundu, "Gerçek fixture bina kurulumu")
	o.yonetim._barindir()
func _olay_var(r: Dictionary, anahtar: String) -> bool:
	for olay: Dictionary in r["olaylar"]:
		if olay["anahtar"] == anahtar: return true
	return false
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
