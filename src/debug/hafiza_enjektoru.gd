## HFZ-25: sahte karar satiri. Oyuncu surumunde kapali (SRM-05 / AdminHud).
class_name HafizaEnjektoru
extends RefCounted


static func satir_ekle(defter: HafizaDefteri, satir: Dictionary, debug_acik: bool = false) -> int:
	if not debug_acik or defter == null:
		return 0
	return defter.hata_ayiklama_ekle(satir)
