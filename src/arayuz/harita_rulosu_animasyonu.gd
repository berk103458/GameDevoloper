## B10: bez haritanın rulo açılması. Yer adları ve pinler karede yok.
## harita_ekrani.gd'ye kanca konmaz; sınıf + test.
class_name HaritaRulosuAnimasyonu
extends KodluSahneAnimasyonu

const KOK := "res://assets/ui/harita/rulo/"

var _sarili_tr: TextureRect
var _acik_tr: TextureRect
var _maske: Control


static func olustur() -> HaritaRulosuAnimasyonu:
	if KodluSahneAnimasyonu.doku(KOK + "sarili.png") == null:
		return null
	if KodluSahneAnimasyonu.doku(KOK + "acik.png") == null:
		return null
	var n := HaritaRulosuAnimasyonu.new()
	n._sure = 2.05
	return n


static func acilma(t: float) -> float:
	# yavaş başlar, ortada açılır, sonda hafif taşma ile oturur
	return KodluSahneAnimasyonu.settle(clampf((t - 0.25) / 1.45, 0.0, 1.0), 0.05)


static func oynat(ebeveyn: Control) -> void:
	if ebeveyn == null:
		return
	await KodluSahneAnimasyonu.oynat_uzerinde(ebeveyn, olustur(), KodluSahneAnimasyonu.aninda_mi(ebeveyn))


func _sahne_kur() -> void:
	_sarili_tr = _katman(KodluSahneAnimasyonu.doku(KOK + "sarili.png"))
	add_child(_sarili_tr)
	_acik_tr = _katman(KodluSahneAnimasyonu.doku(KOK + "acik.png"))
	_acik_tr.clip_contents = true
	add_child(_acik_tr)


func _uygula(t: float) -> void:
	var k := acilma(t)
	if _sarili_tr:
		_sarili_tr.modulate.a = 1.0 - clampf((k - 0.15) / 0.35, 0.0, 1.0)
	if _acik_tr:
		_acik_tr.modulate.a = clampf(k / 0.25, 0.0, 1.0)
		# yatay açılma: soldan genişler
		var sz := size if size.x >= 8.0 else Vector2(1152, 864)
		var w := clampf(k, 0.04, 1.0)
		_acik_tr.anchor_left = 0.5 - 0.5 * w
		_acik_tr.anchor_right = 0.5 + 0.5 * w
		_acik_tr.anchor_top = 0.0
		_acik_tr.anchor_bottom = 1.0
		_acik_tr.offset_left = 0
		_acik_tr.offset_right = 0
		_acik_tr.offset_top = 0
		_acik_tr.offset_bottom = 0
