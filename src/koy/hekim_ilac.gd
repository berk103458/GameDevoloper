## KRI-03: mevcut Şifahane, ambar ve tek ölüm yoluna deterministik adaptör.
class_name HekimIlac
extends RefCounted
const HASTALIK_CARPANI := 0.20
const ILAC_SAGLIK := 25

## KRI-15 bu tek reçete API'sinin girdisine ot ekleyebilir; ikinci üretim yok.
static func receteler() -> Dictionary:
	return {"bakim": {"girdi": {}, "uretim": {}}, "ilac": {"girdi": {"afyon": 1, "su": 1}, "uretim": {"ilac": 1}}}

## Ad/maske/bayrak üzerinden kimlik tahmini yapılmaz. Yalnız adsız legacy
## hekimlerde mevcut cerrah/otacı zanaatı ve ustalık durumu kullanılır.
static func yetkin(k: Koylu) -> bool:
	if k.adli_id != &"": return k.adli_id in [&"chr_008", &"chr_003"]
	return k.zanaat_turu in [ZanaatTuru.Tur.CERRAH, ZanaatTuru.Tur.OTACI] and k.usta_mi()

## Günlük tedavi makbuzu koruyucu yetkinliği tüketmez. Çalışabilir hekim,
## hazır bina ve mevcut hizmet engelleri aranır; hasta/izole hekim sayılmaz.
static func etkin(y: KoyYonetimi, bina_id: int = -1) -> bool:
	if y.son != &"" or y.isyan_kalan >= 0: return false
	for b in y.binalar:
		if bina_id >= 0 and b.id != bina_id: continue
		if b.tur != "sifahane" or not b.hazir() or KanDavasi.engel(y, b.id): continue
		for k in y.calisanlar(b.id):
			if yetkin(k) and Sifahane.hekim_calismaya_uygun(y, k, b): return true
	return false

## Sağlık tam sayı: aşağı yuvarlama köylü lehinedir (12→2, 8→1).
## Ölüm zarı/diriltme/ikinci tarama yok; diğer sağlık kayıplarına dokunmaz.
static func hastalik_kaybi(y: KoyYonetimi, kayip: int) -> int:
	return int(float(kayip) * HASTALIK_CARPANI) if etkin(y) else kayip

## Tek ortak tedavi kontenjanını çağıran tüketir. İlaç yoksa eski 2 erzak
## tedavisi aynen sürer; ilaç tek başına gizli hastalığı açığa çıkarmaz.
static func tedavi_bedeli(y: KoyYonetimi) -> Dictionary:
	return {"ilac": 1} if y.kaynaklar.miktar("ilac") > 0 else {"gida": 2}

static func metin(y: KoyYonetimi, bina_id: int = -1) -> String:
	var yetkin_hekim := etkin(y, bina_id)
	return "Yetkin hekim: %s · bulaşıcı hastalık sağlık kaybı %s\nİlaç stoğu %d · bulaşıcı hastalık tedavisi: 1 ilaç / +25 sağlık; ilaç yoksa 2 erzak / +10 sağlık\nİlaç reçetesi: 1 afyon + 1 su; üretim beceri ve bina verimine bağlı" % ["etkin" if yetkin_hekim else "etkin değil", "−%80" if yetkin_hekim else "normal", y.kaynaklar.miktar("ilac")]
