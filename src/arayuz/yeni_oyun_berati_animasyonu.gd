## C6: boş berat muhafıza uzatılır. Kısa; asker yok; ulak 9 karesi kullanılmaz.
class_name YeniOyunBeratiAnimasyonu
extends KodluSahneAnimasyonu

const KOK := "res://assets/ui/menu/yeni_oyun_berati/"
const PLAKALAR: Array[String] = ["katli.png", "uzatilmis.png"]
const PLAKA_SURE: Array[float] = [0.0, 0.85]


static func olustur() -> YeniOyunBeratiAnimasyonu:
	var n := YeniOyunBeratiAnimasyonu.new()
	for ad in PLAKALAR:
		var d := KodluSahneAnimasyonu.doku(KOK + ad)
		if d == null:
			return null
		n._plakalar.append(d)
	n._plaka_sure = PLAKA_SURE.duplicate()
	n._sure = 1.70
	n._perde_alfa = 0.55
	return n


static func oynat(ebeveyn: Control) -> void:
	if ebeveyn == null:
		return
	await KodluSahneAnimasyonu.oynat_uzerinde(ebeveyn, olustur(), KodluSahneAnimasyonu.aninda_mi(ebeveyn))


## t=0 uzakta / küçük; sonda muhafıza doğru oturur.
static func uzatma_ornek(t: float) -> Dictionary:
	var u := clampf(t / 1.05, 0.0, 1.0)
	var s := KodluSahneAnimasyonu.settle(u, 0.045)
	return {"olcek": lerpf(0.86, 1.0, s), "y": lerpf(0.06, 0.0, s)}


func _uygula(t: float) -> void:
	_plaka_uygula(t)
	var s := uzatma_ornek(t)
	var sz := size if size.x >= 8.0 else Vector2(1024, 1024)
	for kat in [_arka, _on]:
		if kat == null:
			continue
		kat.pivot_offset = sz * 0.5
		kat.scale = Vector2(float(s["olcek"]), float(s["olcek"]))
		kat.position.y = sz.y * float(s["y"])
