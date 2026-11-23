## B3: habercinin katlanmış olay kâğıdının açılması. Metin Label sonra gelir.
class_name OlayKartiAnimasyonu
extends KodluSahneAnimasyonu

const KOK := "res://assets/ui/koy/olay_karti/"
const PLAKA := ["katli.png", "acik.png"]
const PLAKA_SURE: Array[float] = [0.0, 0.70]


static func olustur() -> OlayKartiAnimasyonu:
	var kareler: Array[Texture2D] = []
	for ad in PLAKA:
		var d := KodluSahneAnimasyonu.doku(KOK + ad)
		if d == null:
			return null
		kareler.append(d)
	var n := OlayKartiAnimasyonu.new()
	n._plakalar = kareler
	n._plaka_sure = PLAKA_SURE
	n._sure = 1.80
	return n


static func oynat(ebeveyn: Control) -> void:
	if ebeveyn == null:
		return
	await KodluSahneAnimasyonu.oynat_uzerinde(ebeveyn, olustur(), KodluSahneAnimasyonu.aninda_mi(ebeveyn))
