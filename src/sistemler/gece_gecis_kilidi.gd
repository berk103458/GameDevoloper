## Ekran başına tek gece hesaplaşması; Oturum'un simülasyon API'sine kilit koymaz.
extends RefCounted

var _alindi := false

func al() -> bool:
	if _alindi:
		return false
	_alindi = true
	return true

func kilitli() -> bool:
	return _alindi
