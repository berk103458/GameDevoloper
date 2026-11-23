## B7: pirinç terazinin sönümlü salınımla kefeye yatması (adil / eğik).
class_name VicdanTerazisiAnimasyonu
extends KodluSahneAnimasyonu

const AYAK := "res://assets/ui/oda/vicdan_terazisi/ayak.png"
const KOL := "res://assets/ui/oda/vicdan_terazisi/kol.png"

var _ayak: TextureRect
var _kol: TextureRect
var _denge := 50
var _hedef_aci := 0.0


static func hedef_aci(denge: int) -> float:
	# 0 yoz (sol -), 50 dengede, 100 adil (sağ +). Derece.
	var d := clampi(denge, 0, 100)
	if d >= 70:
		return 16.0
	if d <= 30:
		return -16.0
	return clampf(float(d - 50) * 0.22, -8.0, 8.0)


static func kol_aci(t: float, hedef: float) -> float:
	# sönümlü salınım hedefe
	var u := clampf(t / 1.35, 0.0, 1.0)
	var yaklas := hedef * (1.0 - exp(-3.2 * u))
	var sal := 11.0 * exp(-3.4 * u) * sin(14.0 * u)
	return yaklas + sal


static func olustur(denge: int = 50) -> VicdanTerazisiAnimasyonu:
	if KodluSahneAnimasyonu.doku(AYAK) == null or KodluSahneAnimasyonu.doku(KOL) == null:
		return null
	var n := VicdanTerazisiAnimasyonu.new()
	n._denge = denge
	n._hedef_aci = hedef_aci(denge)
	n._sure = 1.70
	n._perde_alfa = 0.55
	return n


static func oynat(ebeveyn: Control, denge: int = 50) -> void:
	if ebeveyn == null:
		return
	KodluSahneAnimasyonu.oynat_uzerinde(ebeveyn, olustur(denge), KodluSahneAnimasyonu.aninda_mi(ebeveyn))


func _sahne_kur() -> void:
	_ayak = TextureRect.new()
	_ayak.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_ayak.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_ayak.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_ayak.texture = KodluSahneAnimasyonu.doku(AYAK)
	_ayak.size = Vector2(420, 420)
	add_child(_ayak)
	_kol = TextureRect.new()
	_kol.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_kol.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_kol.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_kol.texture = KodluSahneAnimasyonu.doku(KOL)
	_kol.size = Vector2(420, 420)
	_kol.pivot_offset = Vector2(210, 168)  # fulkrum, 512 ölçeğinde ~0.5, 0.40
	add_child(_kol)


func _uygula(t: float) -> void:
	var sz := size if size.x >= 8.0 else Vector2(1280, 720)
	var pos := Vector2(sz.x * 0.5 - 210, sz.y * 0.5 - 210)
	if _ayak:
		_ayak.position = pos
	if _kol:
		_kol.position = pos
		_kol.rotation_degrees = kol_aci(t, _hedef_aci)
