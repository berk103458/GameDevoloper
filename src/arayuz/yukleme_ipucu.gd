## Yükleme ipuçları. Çeviri dosyası yenilenmeden de tr/en döner.
class_name YuklemeIpucu
extends RefCounted

const SATIRLAR := [
	["Kapıdaki ilk cümle, gece boyunca hatırlanır.", "The first sentence at the gate is remembered all night."],
	["Heybedeki azık, sabahın ilk işini belirler.", "The food in the satchel decides the morning's first task."],
	["Tansiyon yükselince bazı sözler kapanır.", "When tension rises, some words close."],
	["Kayıt, mühür basılmadan da durur. Çıkmadan yaz.", "The save holds before any seal. Write it before you leave."],
	["Köyde aynı yüz, ertesi gece kapıya dönebilir.", "The same face in the village may return to the gate the next night."],
]


static func metin() -> String:
	var satir: Array = SATIRLAR[randi() % SATIRLAR.size()]
	var dil := TranslationServer.get_locale()
	if dil.begins_with("en"):
		return str(satir[1])
	return str(satir[0])
