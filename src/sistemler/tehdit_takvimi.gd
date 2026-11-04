## BUG-18: gerçek tamamlanan gün okunur; debug/legacy için ikinci sayaç veya kayıt yok.
class_name TehditTakvimi
extends RefCounted
const DEBUG_BASKIN := &"debug_tehdit_baskini"
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/tehdit_takvimi.json"))

static func acik(gun: int) -> bool:
	return gun >= maxi(0, int(AYAR.tehdit_baslangic_gunu))

## Mevcut stres koşusu açıkça baskın ister; geçici izin kayıt ve doğal takvim üretmez.
static func baskin_acik(y: KoyYonetimi) -> bool:
	return acik(y.gun) or y.get_meta(DEBUG_BASKIN, false) == true

## HAR-11'in mevcut risk profilleri kullanılır; ulak/heyet/normal yolcu bu listede değildir.
static func profil_uygun(gun: int, id: StringName) -> bool:
	return acik(gun) or String(id) not in GuvenlikKafileDengesi.AYAR.risk_profilleri

static func adaylar(gun: int, ids: Array[StringName]) -> Array[StringName]:
	return ids.filter(func(id: StringName) -> bool: return profil_uygun(gun, id))

static func agirlik(gun: int, id: StringName, taban: float) -> float:
	return taban if profil_uygun(gun, id) else 0.0
