## B2: açık hafıza defterinde kodla sayfa kıvrımı. Yazı gömülmez.
class_name HafizaSayfasiAnimasyonu
extends KodluSahneAnimasyonu

const KOK := "res://assets/ui/hafiza/sayfa/"
const SAYFA_SURE := 0.62

var _sayfa: Polygon2D
var _kisa := false


static func olustur(kisa: bool = false) -> HafizaSayfasiAnimasyonu:
	var d := KodluSahneAnimasyonu.doku(KOK + "acik.png")
	if d == null:
		return null
	var n := HafizaSayfasiAnimasyonu.new()
	n._plakalar = [d]
	n._plaka_sure = [0.0, 0.0]
	n._kisa = kisa
	n._sure = 0.95 if kisa else 1.25
	n._perde_alfa = 0.40
	return n


static func oynat(ebeveyn: Control, kisa: bool = false) -> void:
	if ebeveyn == null:
		return
	var n := olustur(kisa)
	await KodluSahneAnimasyonu.oynat_uzerinde(ebeveyn, n, KodluSahneAnimasyonu.aninda_mi(ebeveyn))


func _sahne_kur() -> void:
	super._sahne_kur()
	_sayfa = Polygon2D.new()
	_sayfa.color = Color(0.90, 0.84, 0.72, 0.94)
	_sayfa.visible = false
	add_child(_sayfa)


func _uygula(t: float) -> void:
	_plaka_uygula(t)
	if _sayfa == null:
		return
	var kat := clampf(t / SAYFA_SURE, 0.0, 1.0)
	if kat <= 0.0 or kat >= 1.0:
		_sayfa.visible = false
		return
	_sayfa.visible = true
	var sz := size if size.x >= 8.0 else Vector2(1152, 864)
	var gt := Vector2(sz.x * 0.48, sz.y * 0.30)
	var gb := Vector2(sz.x * 0.50, sz.y * 0.74)
	var ot := Vector2(sz.x * 0.74, sz.y * 0.28)
	var ob := Vector2(sz.x * 0.80, sz.y * 0.76)
	var lt := Vector2(sz.x * 0.28, sz.y * 0.32)
	var lb := Vector2(sz.x * 0.24, sz.y * 0.78)
	if kat <= 0.5:
		var u := kat / 0.5
		var kvr := cos(u * PI * 0.5)
		var dt := ot.lerp(gt, 1.0 - kvr)
		var db := ob.lerp(gb, 1.0 - kvr)
		_sayfa.polygon = PackedVector2Array([gt, dt, db, gb])
		_sayfa.color = Color(0.90, 0.84, 0.72, 0.94).lerp(Color(0.55, 0.46, 0.36, 1.0), u * 0.45)
	else:
		var u := (kat - 0.5) / 0.5
		var kvr := sin(u * PI * 0.5)
		var dt := gt.lerp(lt, kvr)
		var db := gb.lerp(lb, kvr)
		_sayfa.polygon = PackedVector2Array([dt, gt, gb, db])
		_sayfa.color = Color(0.55, 0.46, 0.36, 1.0).lerp(Color(0.90, 0.84, 0.72, 0.94), u)
