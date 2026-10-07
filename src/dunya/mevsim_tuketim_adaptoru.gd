## EKO-09/MEV-11: soğuk ihtiyacı, yerleşim haneleri yerine canlı nüfus üzerinden.
class_name MevsimTuketimAdaptoru
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/koy/tuketim_dengesi.json"))
## Gerçek takvim veya iklim deneyinde soğuksa kişi başı yakacak ihtiyacı.
static func odun(y: KoyYonetimi) -> int:
	return ceili(y.nufus() * int(AYAR.odun_kisi) * IklimDeneyi.odun_carpani(y)) if y.kis_mi() else 0
