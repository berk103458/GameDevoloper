## YAP-01 ilk dilim: kademe tablosu mevcut bina/ADM kimliklerinden ayrıdır.
extends SceneTree
const KILIT = preload("res://src/koy/yapi_kilidi.gd")
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func _initialize() -> void:
	var kat := BinaKatalogu.new()
	dene(KILIT.dogrula(kat).is_empty(), "Kademe tablosunda yeni/geçersiz bina kimliği yok")
	for tur in ["cadir", "tarla", "odunluk"]: dene(KILIT.kademe(tur) == 0, "K0: " + tur)
	for tur in ["kulube", "hizarhane", "tas_ocagi", "ambar"]: dene(KILIT.kademe(tur) == 1, "K1: " + tur)
	for tur in ["tas_ev", "degirmen", "sifahane"]: dene(KILIT.kademe(tur) == 2, "K2: " + tur)
	dene(KILIT.kademe("atolye") == 3, "Gelişmiş atölye K3")
	dene(KILIT.kademe("tablo_disinda") == 0, "Tablo dışı bina K0")
	var eski := kat.turler.duplicate(true)
	var b := KoyBinasi.new()
	b.tur = "tas_ev"
	b.seviye = 3
	dene(KILIT.kademe(b.tur) == 2 and b.seviye == 3 and kat.turler == eski, "Kademe ADM-08 seviyesine veya kataloğa yazmaz")
	kat.turler["deneme"] = {"kurulabilir": true}
	dene("deneme" in KILIT.eksik_turler(kat), "Tablosuz kurulabilir bina uyarı listesinde")
	dene(KILIT.gereken_bilgi("cadir").is_empty() and KILIT.gereken_bilgi("tas_ev") == "tas_ev", "K0 açık, üst kademe tek yapı bilgisini ister")
	dene(KILIT.konak_kademesi() == 3 and not kat.var_mi("konak"), "Mevcut Ağalık/konak hedefi K3, yeni bina türü değil")
	dene(KILIT.sur_kademesi(2) == 2 and KILIT.sur_kademesi(3) == 3, "Sur 2/3 ayrı bina kimliği açmaz")
	dene(not KILIT.dogrula(kat, {}).is_empty(), "Eksik kademe verisi reddedilir")
	for deger in [true, 1.5, 4, -1]:
		var bozuk := KILIT.AYAR.duplicate(true)
		bozuk.binalar.tarla = deger
		dene(not KILIT.dogrula(kat, bozuk).is_empty(), "Tek bozuk kademe reddedilir")
	for deger in [true, 0, 4, "3"]:
		var bozuk := KILIT.AYAR.duplicate(true)
		bozuk.konak = deger
		dene(not KILIT.dogrula(kat, bozuk).is_empty(), "Konak yalnız K3 sınıfını kabul eder")
	var yeni := KILIT.AYAR.duplicate(true)
	yeni.binalar["yeni_kimlik"] = 1
	dene(not KILIT.dogrula(kat, yeni).is_empty(), "Yeni bina kimliği reddedilir")
	for deger in [[true, 2, 3], [1, 2], [1, 2, 4]]:
		var bozuk := KILIT.AYAR.duplicate(true)
		bozuk.sur = deger
		dene(not KILIT.dogrula(kat, bozuk).is_empty(), "Tek bozuk sur verisi reddedilir")
	for deger in [[1, 1, 1], [1, 1, 1, 0], [1, 1, true, 0.5], [1, 1, 1, INF]]:
		var bozuk := KILIT.AYAR.duplicate(true)
		bozuk.insa_mevsim_carpanlari = deger
		dene(not KILIT.dogrula(kat, bozuk).is_empty(), "Tek bozuk mevsim verisi reddedilir")
	print("YAPI KİLİDİ VERİ: GEÇTİ" if hata == 0 else "YAPI KİLİDİ VERİ: KALDI")
	quit(hata)
