## AYR-27: Karar onayı açıkken ilk tık kararı vermez. Varsayılan kapalıdır.
extends RefCounted

static var _bekleyen := ""


static func izinli(a: Ayarlar, anahtar: String) -> bool:
	if a == null or not bool(a.degerler.get(&"karar_onayi", false)):
		_bekleyen = ""
		return true
	if _bekleyen == anahtar:
		_bekleyen = ""
		return true
	_bekleyen = anahtar
	return false


static func sifirla() -> void:
	_bekleyen = ""
