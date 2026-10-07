## UZM-01: meslek, eski üçlü sınıftan ve 1–10 beceri puanından ayrıdır.
class_name ZanaatTuru
extends RefCounted
enum Tur {
	BELIRSIZ = 0, CIFTCI = 1, ESNAF = 2, ASKER = 3, BOSTANCI = 4,
	COBAN = 5, DEGIRMENCI = 6, KALAYCI = 7, CERRAH = 8, DEMIRCI = 9,
	TELLAL = 10, KATIP = 11, OTACI = 12, BAGCI = 13, SU_USTASI = 14,
	DAVULCU = 15, KESIF_ERI = 16, CEBECI = 17, SU_TASIYICI = 18,
	SARAC = 19, COMLEKCI = 20, BEZCI = 21,
}
# Birincil gerçek uzmanlık: karakterler/CHR_XXX.md Bölüm 1 Gerçek_Kimlik.
# Maske veya suç eğilimi zanaat diye yazılmaz; çift uzman Haydar'ın birincili cerrah.
const CHR := {
	"chr_001": Tur.BELIRSIZ, "chr_002": Tur.CIFTCI, "chr_003": Tur.CERRAH,
	"chr_004": Tur.BELIRSIZ, "chr_005": Tur.BELIRSIZ, "chr_006": Tur.BELIRSIZ,
	"chr_007": Tur.KATIP, "chr_008": Tur.OTACI, "chr_009": Tur.BELIRSIZ,
	"chr_010": Tur.TELLAL, "chr_011": Tur.CIFTCI, "chr_012": Tur.BAGCI,
	"chr_013": Tur.CIFTCI, "chr_014": Tur.COBAN, "chr_015": Tur.BOSTANCI,
	"chr_016": Tur.BAGCI, "chr_017": Tur.COBAN, "chr_018": Tur.BOSTANCI,
	"chr_019": Tur.SU_USTASI, "chr_020": Tur.CIFTCI, "chr_021": Tur.ASKER,
	"chr_022": Tur.DAVULCU, "chr_023": Tur.KESIF_ERI, "chr_024": Tur.CEBECI,
	"chr_025": Tur.SU_TASIYICI, "chr_026": Tur.SARAC, "chr_027": Tur.COMLEKCI,
	"chr_028": Tur.BEZCI, "chr_029": Tur.DEMIRCI, "chr_030": Tur.DEGIRMENCI,
}
const ADLAR := ["Belirsiz", "Çiftçi", "Esnaf", "Asker", "Bostancı", "Çoban", "Değirmenci", "Kalaycı", "Cerrah", "Demirci", "Tellal", "Kâtip", "Otacı", "Bağcı", "Su ustası", "Davulcu", "Keşif eri", "Cebeci", "Su taşıyıcı", "Saraç", "Çömlekçi", "Bezci"]

static func coz(id: StringName, sinif: StringName) -> int:
	var kimlik := String(id).to_lower()
	if CHR.has(kimlik): return CHR[kimlik]
	return {&"ciftci": Tur.CIFTCI, &"esnaf": Tur.ESNAF, &"asker": Tur.ASKER}.get(sinif, Tur.BELIRSIZ)

static func oku(v: Variant, varsayilan: int) -> int:
	if v is String and Tur.has(v): return Tur[v]
	if v is int and v in Tur.values(): return v
	return varsayilan

static func anahtar(tur: int) -> String:
	return Tur.find_key(tur) if tur in Tur.values() else "BELIRSIZ"

static func ad(tur: int) -> String:
	return ADLAR[tur] if tur >= 0 and tur < ADLAR.size() else ADLAR[0]
