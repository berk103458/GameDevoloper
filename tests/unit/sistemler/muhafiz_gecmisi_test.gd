extends SceneTree
const G = preload("res://src/sistemler/muhafiz_gecmisi.gd")
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	for id in G.SIRA:
		var o := Oturum.new(kat, 1406)
		var once := o.kaydet()
		dene(not G.sec(o, "yanlis"), "Geçersiz geçmiş reddedilir")
		dene(G.sec(o, id), "Dört geçmiş seçilebilir")
		dene(not G.sec(o, id) and not G.sec(o, "ahi_ciragi"), "İkinci seçim reddedilir")
		var bilgiler := G.yapi_bilgisi(o)
		dene(bilgiler.size() == 1, "Tek yapı bilgisi")
		var binalar: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/koy/binalar.json"))
		dene(binalar.has(bilgiler[0]), "Bilgi gerçek yapı kimliğidir")
		var sonra := o.kaydet()
		sonra.erase("muhafiz_gecmisi")
		once.erase("muhafiz_gecmisi")
		dene(once == sonra, "Geçmiş ekonomi, bina, RNG veya zar verisi değiştirmez")
		var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
		dene(geri != null and G.kimlik(geri) == id, "Kayıt dönüşünde geçmiş korunur")
		dene(G.diller(geri).size() == (1 if id == "medrese_talebesi" else 0), "Medrese dil satırı")
	var eski := Oturum.new(kat, 42)
	var veri := eski.kaydet()
	veri.erase("muhafiz_gecmisi")
	var legacy := Oturum.kayittan(kat, veri)
	dene(G.kimlik(legacy).is_empty() and G.yapi_bilgisi(legacy).is_empty(), "Eski kayıt seçilmedi kalır")
	dene(not G.sec(legacy, "eski_levent"), "Sıfırıncı gündeki eski kayıt da değişmez")
	legacy.gun = 2
	dene(not G.sec(legacy, "eski_levent"), "Başlamış oyunda geçmiş atanmaz")
	print("MUHAFIZ GEÇMİŞİ: GEÇTİ" if hata == 0 else "MUHAFIZ GEÇMİŞİ: KALDI")
	quit(hata)
