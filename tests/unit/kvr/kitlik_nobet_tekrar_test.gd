extends SceneTree
const NOBET = preload("res://src/koy/kitlik_nobeti.gd")
var hata := 0

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)

func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var y := Oturum.new(kat, 1214).yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 1000
	y.asayis_riski = 60
	y.kaynaklar = Kaynaklar.new(1000, {"gida": 0, "odun": 100, "tas": 100, "kereste": 100})
	y.akce = 500
	var n := y.kabul({"ad": "Nöbetçi", "sinif": "asker", "stat": 7})
	n.moral = 80
	dene(y.muhafiz_ata(n.id), "Gerçek nöbetçi")
	var olaylar: Array[Dictionary] = []
	KitlikIsyani.gece(y, olaylar)
	NOBET.gece(y, olaylar)
	NOBET.gece(y, olaylar)
	dene(olaylar.filter(func(e: Dictionary) -> bool: return e.has("kitlik_nobeti")).size() == 1, "Uyarı da bir kez")
	y.gun += 1
	olaylar.clear()
	KitlikIsyani.gece(y, olaylar)
	var ham: Array[Dictionary] = olaylar.duplicate(true)
	var stok_once := y.kaynaklar.stok.duplicate(true)
	var moral_once := n.moral
	var rng := y._rng.state
	NOBET.gece(y, olaylar)
	dene(y.kaynaklar.miktar("odun") > int(stok_once.odun) and n.moral < moral_once, "İlk gerçek yağma geri alındı, moral kesildi")
	var stok := y.kaynaklar.stok.duplicate(true)
	var moral := n.moral
	var sayi := olaylar.size()
	NOBET.gece(y, olaylar)
	dene(y.kaynaklar.stok == stok and n.moral == moral and olaylar.size() == sayi, "Aynı olay listesi ikinci çağrıda saf")
	var replay: Array[Dictionary] = []
	replay.assign(JSON.parse_string(JSON.stringify(olaylar)))
	NOBET.gece(y, replay)
	dene(y.kaynaklar.stok == stok and n.moral == moral and replay.size() == sayi, "JSON olay replay bir kez")
	var geri := KoyYonetimi.kayittan(y.a, y.katalog, JSON.parse_string(JSON.stringify(y.kaydet())))
	NOBET.gece(geri, ham)
	dene(geri.kaynaklar.stok == stok and geri.koylu(n.id).moral == moral and ham.size() == sayi - 1, "Save/load sonrası işaretsiz eski olay da kilitli")
	dene(y._rng.state == rng, "Makbuz RNG tüketmez")
	var arb: Array = olaylar.filter(func(e: Dictionary) -> bool: return e.has("kitlik_nobeti"))
	dene(arb.size() == 1 and IflasYoneticisi.olay_metin(arb[0]).contains("Ambarda arbede"), "Dış olay dict metni korunur")
	# Gün kilidi yeni geceyi kapatmaz; önceki JSON olayının işareti kendi olayında kalır.
	y.gun += 1
	var yeni: Array[Dictionary] = [{"anahtar": "kitlik_isyani", "kitlik_isyani": {"gece": y.gun, "yagma": {"odun": 8}}}]
	NOBET.gece(y, yeni)
	dene(yeni.size() == 2 and n.moral < moral, "Sonraki gecenin yeni olayı işlenir")
	var legacy := y.kaydet()
	legacy.kitlik_isyani.erase("nobet_son_gece")
	var eski := KoyYonetimi.kayittan(y.a, y.katalog, legacy)
	dene(KitlikIsyani.durum(eski).nobet_son_gece == -1, "Legacy makbuz nöbet geçmişi uydurmaz")
	print("KITLIK NOBET TEKRAR: GEÇTİ" if hata == 0 else "KITLIK NOBET TEKRAR: KALDI")
	quit(hata)
