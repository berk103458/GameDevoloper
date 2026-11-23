## B9: elin kını duran hançer kabzasına gitmesi. Şiddet sahnesi değil.
class_name KavgaGerilimAnimasyonu
extends KodluSahneAnimasyonu

const KOK := "res://assets/ui/kapi/kavga_gerilim/"
const PLAKA := ["uzak.png", "kabza.png"]
const PLAKA_SURE: Array[float] = [0.0, 0.85]


static func olustur() -> KavgaGerilimAnimasyonu:
	var kareler: Array[Texture2D] = []
	for ad in PLAKA:
		var d := KodluSahneAnimasyonu.doku(KOK + ad)
		if d == null:
			return null
		kareler.append(d)
	var n := KavgaGerilimAnimasyonu.new()
	n._plakalar = kareler
	n._plaka_sure = PLAKA_SURE
	n._sure = 1.60
	return n


static func oynat(ebeveyn: Control) -> void:
	if ebeveyn == null:
		return
	await KodluSahneAnimasyonu.oynat_uzerinde(ebeveyn, olustur(), KodluSahneAnimasyonu.aninda_mi(ebeveyn))


func _uygula(t: float) -> void:
	_plaka_uygula(t)
	# kavrama sonrası hafif titreme
	if t >= 0.95 and _on:
		var u := t - 0.95
		var amp := 1.8 * exp(-3.0 * u)
		_on.position = Vector2(amp * sin(u * 42.0), amp * 0.5 * cos(u * 36.0))
