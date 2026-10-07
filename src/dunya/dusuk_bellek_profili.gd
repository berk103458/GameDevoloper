## Kullanılmayan kaynakların güçlü cache referanslarını bırakır; aktif sahne kendi kaynaklarını tutar.
class_name DusukBellekProfili
extends RefCounted

static func memory_free() -> Dictionary:
	var sonuc := {
		"sanat": Sanat._onbellek.size(),
		"malzeme": Pbr._onbellek.size(),
		"model": Dunya3B._onbellek.size(),
		"klip": KarakterModel._klip_onbellek.size(),
		"sekil": DurusDuzeltici._sekil_onbellek.size(),
	}
	Sanat._onbellek.clear()
	Pbr._onbellek.clear()
	Dunya3B._onbellek.clear()
	KarakterModel._klip_onbellek.clear()
	DurusDuzeltici._sekil_onbellek.clear()
	KapiManzarasi._gurultu = null
	return sonuc
