## SRM-07, SRM-08, SRM-09: demo yalniz perde 1'i tutar. Esik oturma_esigi degeridir, burada degistirilmez.
class_name DemoKesiti
extends RefCounted

const BAYRAK := "--demo"
## Test zorlamasi: -1 serbest, 0 kapali, 1 acik.
static var zorla: int = -1


static func acik(argumanlar: PackedStringArray = OS.get_cmdline_user_args()) -> bool:
	if zorla == 0:
		return false
	if zorla == 1:
		return true
	return argumanlar.has(BAYRAK) or OS.get_environment("DEMO") == "1"


static func esik() -> int:
	var ayar = load("res://data/ayarlar/oyun.tres")
	if ayar != null and ayar.get("oturma_esigi") != null:
		return int(ayar.oturma_esigi)
	return 18


static func kapi_gecesi(demo: bool, nufus: int, sinir: int = -1) -> int:
	var kullan := esik() if sinir < 0 else sinir
	if demo and nufus >= kullan:
		return 0
	return 1


static func bitis_karti(demo: bool, nufus: int, sinir: int = -1) -> int:
	var kullan := esik() if sinir < 0 else sinir
	return 1 if demo and nufus >= kullan else 0


static func perde2_baslar(demo: bool) -> bool:
	return not demo


static func istatistik_sayisi() -> int:
	return 4
