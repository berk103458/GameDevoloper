## C3: keten cenaze örtüsü yavaşça örtülür. Saygılı, kısa; metin yok.
class_name CenazeOrtusuAnimasyonu
extends KodluSahneAnimasyonu

const KOK := "res://assets/ui/koy/cenaze_ortusu/"
const PLAKALAR: Array[String] = ["katli.png", "ortulu.png"]
const PLAKA_SURE: Array[float] = [0.0, 2.15]


static func olustur() -> CenazeOrtusuAnimasyonu:
	var n := CenazeOrtusuAnimasyonu.new()
	for ad in PLAKALAR:
		var d := KodluSahneAnimasyonu.doku(KOK + ad)
		if d == null:
			return null
		n._plakalar.append(d)
	n._plaka_sure = PLAKA_SURE.duplicate()
	n._sure = 2.85
	n._perde_alfa = 0.62
	return n


static func oynat(ebeveyn: Control) -> void:
	if ebeveyn == null:
		return
	await KodluSahneAnimasyonu.oynat_uzerinde(ebeveyn, olustur(), KodluSahneAnimasyonu.aninda_mi(ebeveyn))


func _uygula(t: float) -> void:
	_plaka_uygula(t)
	# örtü ağırlığının yavaş inmesi: üst plaka hafif aşağı oturur.
	if _on != null:
		var k := KodluSahneAnimasyonu.plaka_karisimi(_plaka_sure, t)
		var inis := KodluSahneAnimasyonu.ease_out(float(k["k"]))
		var sz := size if size.y >= 8.0 else Vector2(1024, 1024)
		_on.position.y = lerpf(-sz.y * 0.045, 0.0, inis)
