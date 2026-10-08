## EKO-03: Tomruk sevkiyatı üretimden ayrıdır. Bir gece = 1 taşıma zaman bütçesi.
## Varsayım: elle 3 birim/sefer, 1 gece; öküz/inek 9 birim/sefer, 0.5 gece.
## Artan yük kaynak binada bekler; üretim veya inşaat süresi çarpılmaz.
class_name CekiLojistigi
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/koy/ceki_lojistigi.json"))
static var FIYAT: Dictionary = AYAR.fiyat
var hayvanlar: Dictionary = {"okuz": 0, "inek": 0, "beygir": 0, "koc": 0}
var bekleyen: Dictionary = {}
var _zaman: Dictionary = {}
## Hazır ahır türünü kataloğa ekler; CHR placeholderı ile aynı kimliği korur.
static func katalog_ekle(turler: Dictionary) -> void:
	if not turler.has("ahir") or not bool(turler.ahir.get("kurulabilir", false)):
		turler["ahir"] = AYAR.ahir.duplicate(true)
## Yalnız tamamlanmış ahırların hayvan barındırma kapasitesi.
func kapasite(y: KoyYonetimi) -> int:
	var n := 0
	for b in y.binalar:
		if b.tur == "ahir" and b.hazir(): n += int(AYAR.ahir_yer)
	return n
## Kalıcı kayıttaki toplam çeki hayvanı sayısı.
func sayi() -> int:
	return CelepHamdullah.ceki_sayisi(self)
## Kullanılabilir ahır ve en az bir kayıtlı çeki hayvanı var mı?
func etkin(y: KoyYonetimi) -> bool:
	return sayi() > 0 and kapasite(y) > 0
## Dış denge verisinden sefer yükü ve zaman maliyetini döndürür.
func sefer(y: KoyYonetimi) -> Dictionary:
	var s: Dictionary = AYAR.hayvan if etkin(y) else AYAR.elle
	return {"kapasite": int(s.kapasite), "sure": float(s.sure)}
## Kervan günü, kamu kasası ve ahır yeri birlikte doğrulanır.
func alinabilir(y: KoyYonetimi, tur: String) -> bool:
	return CelepHamdullah.alinabilir(y, tur)
## Koşulları tekrar denetleyerek kamu kasasından tek hayvan alır.
func al(y: KoyYonetimi, tur: String) -> bool:
	if not alinabilir(y, tur): return false
	y.akce -= int(FIYAT[tur])
	hayvanlar[tur] = int(hayvanlar.get(tur, 0)) + 1
	return true
## Sefer zamanını yeniler ve önceki yükleri gerçek ambara teslim eder.
func gece_basla(y: KoyYonetimi, uretim: Dictionary) -> void:
	_zaman.clear()
	for key in bekleyen.keys():
		var giren := teslim(y, String(key).to_int(), 0)
		if giren > 0: uretim["tomruk"] = int(uretim.get("tomruk", 0)) + giren
## Yeni yükü kaynak binada kuyruğa alır; yalnız teslim edilen miktarı döndürür.
func teslim(y: KoyYonetimi, bina_id: int, adet: int) -> int:
	var key := str(bina_id)
	bekleyen[key] = int(bekleyen.get(key, 0)) + maxi(0, adet)
	var s := sefer(y)
	var kalan := float(AYAR.gece_zamani) - float(_zaman.get(key, 0.0))
	var giren := 0
	while int(bekleyen[key]) > 0 and kalan >= float(s.sure):
		var yuk := mini(int(bekleyen[key]), int(s.kapasite))
		var alinan := y.kaynaklar.ekle("tomruk", yuk)
		if alinan <= 0: break
		bekleyen[key] = int(bekleyen[key]) - alinan
		giren += alinan
		kalan -= float(s.sure)
		_zaman[key] = float(AYAR.gece_zamani) - kalan
	if int(bekleyen[key]) == 0: bekleyen.erase(key)
	return giren
## Hayvan, kuyruk ve sefer bütçesini saf JSON sözlüğüne dönüştürür.
func kaydet() -> Dictionary:
	return {"hayvanlar": hayvanlar.duplicate(), "bekleyen": bekleyen.duplicate(), "zaman": _zaman.duplicate()}
## Eski veya bozuk ek kayıt alanlarını güvenli boş varsayılana yükler.
static func kayittan(v: Variant) -> CekiLojistigi:
	var l := CekiLojistigi.new()
	if not v is Dictionary: return l
	var h: Variant = v.get("hayvanlar", {})
	if h is Dictionary:
		for t in FIYAT:
			if h.get(t, 0) is float or h.get(t, 0) is int: l.hayvanlar[t] = clampi(int(h.get(t, 0)), 0, 1000)
	var b: Variant = v.get("bekleyen", {})
	if b is Dictionary:
		for key in b:
			if String(key).is_valid_int() and (b[key] is int or b[key] is float): l.bekleyen[String(key)] = clampi(int(b[key]), 0, 1000000)
	var z: Variant = v.get("zaman", {})
	if z is Dictionary:
		for key in z:
			if String(key).is_valid_int() and (z[key] is int or z[key] is float): l._zaman[String(key)] = clampf(float(z[key]), 0.0, float(AYAR.gece_zamani))
	return l
