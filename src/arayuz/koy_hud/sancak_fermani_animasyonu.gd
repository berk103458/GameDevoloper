## B4: resmi ferman rulosunun mühür kırılarak açılması. Metin Label.
class_name SancakFermaniAnimasyonu
extends KodluSahneAnimasyonu

const KOK := "res://assets/ui/ulak/ferman/"
const PLAKA := ["sarili.png", "muhur_kirik.png", "acik.png"]
const PLAKA_SURE: Array[float] = [0.0, 0.55, 1.40]

var _sars := Vector2.ZERO


static func olustur() -> SancakFermaniAnimasyonu:
	var kareler: Array[Texture2D] = []
	for ad in PLAKA:
		var d := KodluSahneAnimasyonu.doku(KOK + ad)
		if d == null:
			return null
		kareler.append(d)
	var n := SancakFermaniAnimasyonu.new()
	n._plakalar = kareler
	n._plaka_sure = PLAKA_SURE
	n._sure = 2.25
	return n


static func oynat(ebeveyn: Control) -> void:
	if ebeveyn == null:
		return
	await KodluSahneAnimasyonu.oynat_uzerinde(ebeveyn, olustur(), KodluSahneAnimasyonu.aninda_mi(ebeveyn))


func _uygula(t: float) -> void:
	# mühür kırılırken kısa sarsıntı
	_sars = Vector2.ZERO
	var kir := 0.55
	if t >= kir and t < kir + 0.16:
		var u := (t - kir) / 0.16
		var amp := 7.0 * (1.0 - u)
		_sars = Vector2(amp * sin(t * 70.0), amp * 0.4 * cos(t * 58.0))
	_plaka_uygula(t)
	if _arka:
		_arka.position = _sars
	if _on:
		_on.position = _sars
