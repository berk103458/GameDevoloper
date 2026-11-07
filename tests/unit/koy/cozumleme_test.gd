## YAP-05 ilk dilim: yalnız veri/oda sözleşmesi; tam iş kabulü henüz değildir.
extends SceneTree
const C = preload("res://src/koy/cozumleme.gd")
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func _initialize() -> void:
	var kat := BinaKatalogu.new()
	dene(kat.var_mi("cozumleme_odasi") and kat.slot("cozumleme_odasi") == 1 and YapiKilidi.kademe("cozumleme_odasi") == 1,"YAP-05 tek K1 oda ve mevcut atama yuvası")
	dene(C.dogrula().is_empty(),"Gerçek çözümleme verisi geçerli")
	var asil := preload("res://src/koy/usta_defterleri.gd").AYAR
	for sure in [0,-1,true,1.5,INF]:
		var bozuk := asil.duplicate(true)
		bozuk.defterler.usta_defteri_marangoz.arastirma.sure_gun = sure
		dene(not C.dogrula(bozuk).is_empty(),"Bozuk/sıfır süre reddedilir")
	for sonuc in [{"hedef_sistem":"ikinci_savas","carpan":1.1},{"hedef_sistem":"hizarhane_uretimi","carpan":0},{"hedef_sistem":"hizarhane_uretimi","carpan":1.1,"ikinci_hedef":"savunma"}]:
		var bozuk := asil.duplicate(true)
		bozuk.defterler.usta_defteri_marangoz.arastirma.sonuc = sonuc
		dene(not C.dogrula(bozuk).is_empty(),"Tek mevcut hedef ve pozitif çarpan zorunlu")
	var y := KoyYonetimi.new(KoyAyarlari.new(),kat,5050)
	dene(not C.oda(y,99),"Oda yokken hazır sayılmaz")
	var b := KoyBinasi.new()
	b.id = 99
	b.tur = "cozumleme_odasi"
	b.insa_kalan = 1
	y.binalar.append(b)
	dene(not C.oda(y,b.id),"Yarım oda hazır sayılmaz")
	b.insa_kalan = 0
	dene(C.oda(y,b.id),"Hazır K1 oda mevcut modelden okunur")
	var bilen := y.kabul({"ad":"Doğrudan oda bilgisi","yapi_bilgisi":["cozumleme_odasi"]})
	dene(YapiKilidi.durum(y,"cozumleme_odasi").acik,"Doğrudan oda bilgisi de geçerlidir")
	y.koylular.erase(bilen)
	bilen = y.kabul({"ad":"Ambar bilgisi","yapi_bilgisi":["ambar"]})
	dene(YapiKilidi.durum(y,"cozumleme_odasi").acik and YapiKilidi.gereken_bilgi("cozumleme_odasi") == "ambar","Oda mevcut ambar bilgisini veriden okuyarak açılır")
	var bozuk := YapiKilidi.AYAR.duplicate(true)
	bozuk.bilgi_eslesmeleri.cozumleme_odasi = "olmayan"
	dene(not YapiKilidi.dogrula(kat,bozuk).is_empty(),"Tablosuz bilgi eşlemesi reddedilir")
	print("ÇÖZÜMLEME VERİ: GEÇTİ" if hata == 0 else "ÇÖZÜMLEME VERİ: KALDI")
	quit(hata)
