## SAB-05, SAB-08, SAB-09: zindan payının okuyucusu.
## Erzak düşüşünü ekonomi dosyasına yazmaz; düşülecek miktarı ve kaynağı döner.
extends RefCounted

const AYAR_YOL := "res://data/koy/sabah_hukum.json"

static var _ayar: Dictionary = {}


static func ayar() -> Dictionary:
	if _ayar.is_empty():
		var veri = JSON.parse_string(FileAccess.get_file_as_string(AYAR_YOL))
		_ayar = veri if veri is Dictionary else {}
	return _ayar


static func pay() -> int:
	return int(ayar().get("ekmek_payi", 1))


static func tavan() -> int:
	return int(ayar().get("sabah_tavan", 1))


## Hane doluysa hane, boşsa ambar. Sürgün ve infaz düşürmez. Stok yazılmaz.
static func plan(hukum: String, hane_dolu: bool, ambar: int) -> Dictionary:
	if hukum != "zindan":
		return {"dusum": 0, "kaynak": "", "isaret": ""}
	if not hane_dolu and ambar <= 0:
		return {"dusum": 0, "kaynak": "ambar", "isaret": "ekmek_yok"}
	if hane_dolu:
		return {"dusum": pay(), "kaynak": "hane", "isaret": ""}
	return {"dusum": pay(), "kaynak": "ambar", "isaret": ""}
