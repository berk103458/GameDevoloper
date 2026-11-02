## ZAR-06: mevcut gözlem/Clue üzerinden tek ziyaretlik, zarsız sezgi.
extends RefCounted
const META := &"zar06_goruldu"
const BAGLAM := &"zar06_baglam"
const GECMIS = preload("res://src/sistemler/muhafiz_gecmisi.gd")
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/soz/muhafiz_sezgisi.json"))

## DYL-02 de bu erişimi kullanır; ikinci tecrübe eşiği yok.
static func esik() -> int:
	return int(AYAR.tecrube_esigi)

static func esik_gecti(o: Oturum) -> bool:
	return MuhafizOdaGelisimi.etkin_tecrube(o) >= esik()

static func gorunur(b: Dictionary) -> bool:
	if bool(b.get("tipi", false)): return false
	var isik: Variant = b.get("isik", 0.0)
	# DIY-08'in mevcut sayısal isik alanı bulanıklık yarıçapıdır: 0 açık görüş.
	# DYL-02'nin açık/kapalı ışık bağlamı boolean ise false karanlıktır.
	if isik is bool: return isik
	return (isik is int or isik is float) and is_finite(float(isik)) and float(isik) <= 0.0

static func ac(o: Oturum, g: Gelen, baglam: Dictionary, varyantlar: Array = []) -> String:
	if g == null or g.get_meta(META, false) or not esik_gecti(o): return ""
	var sorgu := g.chr_sorgusu() as ChrSorgusu
	if sorgu == null: return ""
	var gecmis := GECMIS.kimlik(o)
	var adaylar: Array = []
	if varyantlar.is_empty() and AYAR.karakterler.has(String(g.id)):
		# Yeni replik yazılmaz; kaynağın gözlem metni ve Clue kimliği tek kaynak kalır.
		varyantlar = [{"metin": sorgu.karakter.gorsel_hata, "ipucu": String(sorgu.karakter.gorsel_hata_ipucu), "gorsel": true, "gecmisler": AYAR.gecmisler, "kosullar": {}}]
	for v in varyantlar:
		if not v is Dictionary or not v.get("metin") is String or v.metin.is_empty(): continue
		var roller: Array = v.get("gecmisler", [])
		if not roller.is_empty() and gecmis not in roller: continue
		if v.get("gorsel", false) and not gorunur(baglam): continue
		var aday: Dictionary = v.duplicate(true)
		aday["kosullar"] = aday.get("kosullar", {}).duplicate(true)
		if not roller.is_empty(): aday.kosullar["gecmis"] = gecmis
		adaylar.append(aday)
	var b := SatirSecici.baglam_hazirla(baglam, {"gecmis": gecmis})
	var sonuc := SatirSecici.new().sec(adaylar, b)
	if sonuc.is_empty(): return ""
	var ipucu := String(sonuc.get("ipucu", ""))
	if not ipucu.is_empty():
		if ipucu != String(sorgu.karakter.gorsel_hata_ipucu): return ""
		sorgu.gorsel_incele() # Aynı IpucuYoneticisi ve aynı Clue; beyan yazılmaz.
	g.set_meta(META, true)
	return String(sonuc.metin)

static func goster(e: Control, g: Gelen) -> void:
	if not g.has_meta(BAGLAM): g.set_meta(BAGLAM, BaglamSorgusu.new().kur(e.get("oturum") as Oturum, g))
	var metin := ac(e.get("oturum") as Oturum, g, g.get_meta(BAGLAM))
	if not metin.is_empty(): e.call("_yaz", "[i]Sezgi: %s[/i]" % metin)
