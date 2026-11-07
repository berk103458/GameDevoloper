extends SceneTree
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func liste(y: KoyYonetimi) -> Dictionary:
	var d := {}
	for tur in y.katalog.turler: d[tur] = YapiKilidi.durum(y, tur).acik
	return d
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var a := Oturum.new(kat, 10101)
	var b := Oturum.new(kat, 10101)
	preload("res://src/sistemler/muhafiz_gecmisi.gd").sec(a, "ahi_ciragi")
	preload("res://src/sistemler/muhafiz_gecmisi.gd").sec(b, "ahi_ciragi")
	preload("res://src/sistemler/acilis_senaryosu.gd").kur(a)
	preload("res://src/sistemler/acilis_senaryosu.gd").kur(b)
	dene(liste(a.yonetim) == liste(b.yonetim), "Aynı tohumlu gerçek kuruluş aynı kilitleri verir")
	dene(a.yapilar[&"konak"] == 0 and YapiKilidi.konak_kademesi() == 3, "K3 sınıfı eski Konak/Ağalık durumunu açmaz")
	b.yonetim.agalik = true
	dene(b.yapilar[&"konak"] == 1 and YapiKilidi.konak_kademesi() == 3 and not b.yonetim.katalog.var_mi("konak"), "Mevcut Ağalık anlamı korunur; yeni Konak bina kimliği yok")
	b.yonetim.agalik = false
	var once := liste(a.yonetim)
	var binalar := a.yonetim.binalar.size()
	var g := Gelen.new()
	g.sinif = &"ciftci"
	g.stat = 5
	g.ad_anahtari = "Yapı sınır testi"
	g.secenekler = PackedStringArray(["kabul"])
	# İlk kuruluş kapı özel akışı yerine olağan kapı kararı oturumunda sınanır.
	var o := Oturum.new(kat, 10102)
	var y := o.yonetim
	var kilitler := liste(y)
	var s := o.karar_ver(g, &"kabul")
	dene(not s.get("engellendi", false) and y.koylu(int(s.get("koylu_id", -1))) != null, "Gerçek olağan kapı kabulü işlendi")
	dene(y.binalar.is_empty() and liste(y) == kilitler, "Kapı kabulü bina/kademe kurmaz")
	var k := y.koylu(s.koylu_id)
	CasusGeceTakibi.kaydet(y, k, "ambar", -1, "kundaklama", "gida", 0, true)
	dene(DivanHukmu.uygula(o, k.id, "zindan"), "Gerçek divan hükmü işlendi")
	dene(y.binalar.is_empty() and liste(y) == kilitler, "Divan yapı veya bilgi kademesi açmaz")
	var olay := OlayVerisi.new()
	olay.id = &"yap01_sinir_olayi"
	olay.secenek_anahtarlari = PackedStringArray(["yap01_sinir_secim"])
	olay.secenek_etkileri = [{"akce": 1}]
	var akce_once := o.akce
	o.olay_uygula(olay, 0)
	dene(o.akce == akce_once + 1, "Gerçek olay seçeneği ekonomi etkisini yazdı")
	dene(y.binalar.is_empty() and liste(y) == kilitler, "Olay kartı yapı veya bilgi açmaz")
	dene(a.yonetim.binalar.size() == binalar and liste(a.yonetim) == once, "Sınır kontrolleri diğer oturuma yazmaz")
	# Bilgi seviyesi, mevcut sur taksitinin tutarını/akışını değiştirmez.
	for z in [a.yonetim, b.yonetim]:
		z.akce = 10000
		var stok := {}
		for tur in Kaynaklar.TURLER: stok[tur] = 1000
		z.kaynaklar = Kaynaklar.new(100000, stok)
	b.yonetim.koylular[0].yapi_bilgisi = YapiKilidi.bilgi_oku(YapiKilidi.AYAR.binalar.keys())
	for i in a.yonetim.a.sur_bedel.size() * a.yonetim.a.sur_taksit:
		dene(a.yonetim.sur_taksiti() == b.yonetim.sur_taksiti(), "Bilgi sur taksit tutarını değiştirmez")
		dene(a.yonetim.sur_taksit_ode() and b.yonetim.sur_taksit_ode(), "Mevcut taksit gerçek ödenir")
	dene(a.yonetim.sur_seviye == 3 and b.yonetim.sur_seviye == 3 and a.akce == b.akce and a.yonetim.kaynaklar.kaydet() == b.yonetim.kaynaklar.kaydet(), "Sur3 ödeme/kasa/malzeme bilgi kademesinden bağımsızdır")
	var kaynak := FileAccess.get_file_as_string("res://src/koy/yapi_kilidi.gd")
	dene(not kaynak.contains("koy_sahnesi") and not kaynak.contains("KoyYerlesimi") and not kaynak.contains("PackedScene"), "Kilit ikinci sahne/harita import etmez")
	print("YAPI KİLİDİ SINIR: GEÇTİ" if hata == 0 else "YAPI KİLİDİ SINIR: KALDI")
	quit(hata)
