## AYR-41: Üç gece ortalaması 30 fps altındaysa bir kez düşük profil önerilir.
## Grafik profili kendiliğinden değişmez.
class_name ProfilOnerisi
extends RefCounted

const ESIK := 30.0
const GECE := 3

var _ortalama: Array[float] = []
var onerildi := false


func gece_ekle(ortalama_fps: float) -> String:
	_ortalama.append(ortalama_fps)
	if onerildi or _ortalama.size() < GECE:
		return ""
	var dilim := _ortalama.slice(_ortalama.size() - GECE, _ortalama.size())
	var toplam := 0.0
	for fps in dilim:
		toplam += float(fps)
	if toplam / float(GECE) >= ESIK:
		return ""
	onerildi = true
	return "arayuz.ayarlar.profil_onerisi"


func profili_degistirdi_mi(once: StringName, sonra: StringName) -> bool:
	return once != sonra
