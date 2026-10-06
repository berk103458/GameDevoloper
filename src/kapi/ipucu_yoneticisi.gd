## Oturumdan bağımsız, ziyaret başına Clue kaydı.
class_name IpucuYoneticisi
extends RefCounted

signal ipucu_bulundu(ipucu: StringName)
var _kayitlar: Dictionary = {}

func kaydet(ipucu: StringName) -> bool:
	if not String(ipucu).begins_with("Clue_") or _kayitlar.has(ipucu):
		return false
	_kayitlar[ipucu] = true
	ipucu_bulundu.emit(ipucu)
	return true

func var_mi(ipucu: StringName) -> bool:
	return _kayitlar.has(ipucu)

func kayitlar() -> Dictionary:
	return _kayitlar.duplicate()
