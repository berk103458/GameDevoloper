## Sabah defteri: kapak menteşeden açılır, sayfalar kodla çevrilir. Metin görsele gömülmez.
class_name SabahDefteriAnimasyonu
extends Control

signal bitti

const KOK := "res://assets/ui/koy/sabah_defteri/"
const KAPAK: Array[String] = ["kapali.png", "kapak_yarim.png", "kapak_sola.png", "acik.png"]
const KAPAK_SURE: Array[float] = [0.0, 0.55, 1.20, 2.00]
const SAYFA_BAS := 2.00
const SAYFA_SURE := 0.42
const SAYFA_ADET := 2
const YAZI_BAS := 2.88
const SURE := 3.35


var _kayit := ""
var _kareler: Array[Texture2D] = []
var _arka: TextureRect
var _on: TextureRect
var _sayfa: Polygon2D
var _yazi: Label
var _gecen := 0.0
var _oynuyor := false


static func kare_yolu(ad: String) -> String:
	return KOK + ad


static func kareleri_yukle() -> Array[Texture2D]:
	var kareler: Array[Texture2D] = []
	for ad in KAPAK:
		var yol := kare_yolu(ad)
		if not ResourceLoader.exists(yol):
			return []
		var doku: Texture2D = load(yol)
		if doku == null:
			return []
		kareler.append(doku)
	return kareler


static func kapak_karisimi(t: float) -> Dictionary:
	var son := KAPAK_SURE.size() - 1
	var u := clampf(t, 0.0, KAPAK_SURE[son])
	var i := 0
	while i < son and u >= KAPAK_SURE[i + 1]:
		i += 1
	if i >= son:
		return {"a": son, "b": son, "k": 1.0}
	var t0: float = KAPAK_SURE[i]
	var t1: float = KAPAK_SURE[i + 1]
	var k := 0.0 if t1 <= t0 else clampf((u - t0) / (t1 - t0), 0.0, 1.0)
	# kısa tutuş, yumuşak çözünme
	var ease := 0.0
	if k < 0.16:
		ease = 0.0
	elif k < 0.78:
		var u2 := (k - 0.16) / 0.62
		ease = u2 * u2 * (3.0 - 2.0 * u2)
	else:
		ease = 1.0
	return {"a": i, "b": i + 1, "k": ease}


static func sayfa_kat(t: float) -> Dictionary:
	if t < SAYFA_BAS:
		return {"no": 0, "kat": 0.0, "gorunur": false}
	var yerel := t - SAYFA_BAS
	var no := clampi(int(yerel / SAYFA_SURE), 0, SAYFA_ADET - 1)
	var kat := clampf((yerel - no * SAYFA_SURE) / SAYFA_SURE, 0.0, 1.0)
	return {"no": no, "kat": kat, "gorunur": yerel < SAYFA_SURE * SAYFA_ADET + 0.02}


static func olustur(kayit_metni: String = "") -> SabahDefteriAnimasyonu:
	var kareler := kareleri_yukle()
	if kareler.size() < KAPAK.size():
		return null
	var n := SabahDefteriAnimasyonu.new()
	n._kareler = kareler
	n._kayit = kayit_metni
	return n


static func oynat(ebeveyn: Control, kayit_metni: String = "") -> void:
	if ebeveyn == null:
		return
	var n := olustur(kayit_metni)
	if n == null:
		return
	ebeveyn.add_child(n)
	n._baslat()
	await n.bitti
	if is_instance_valid(n):
		var tw := n.create_tween()
		tw.tween_property(n, "modulate:a", 0.0, 0.28)
		await tw.finished
	if is_instance_valid(n):
		n.queue_free()


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	z_index = 80
	var perde := ColorRect.new()
	perde.color = Color(0.02, 0.02, 0.03, 0.35)
	perde.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	perde.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(perde)
	_arka = _sahne()
	_on = _sahne()
	add_child(_arka)
	add_child(_on)
	if not _kareler.is_empty():
		_arka.texture = _kareler[0]
		_on.texture = _kareler[0]
	_sayfa = Polygon2D.new()
	_sayfa.color = Color(0.90, 0.84, 0.72, 0.96)
	_sayfa.visible = false
	add_child(_sayfa)
	_yazi = Label.new()
	_yazi.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_yazi.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_yazi.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	_yazi.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_yazi.add_theme_font_size_override("font_size", 28)
	_yazi.add_theme_color_override("font_color", Color(0.18, 0.13, 0.08, 1.0))
	_yazi.text = _kayit
	_yazi.modulate.a = 0.0
	add_child(_yazi)
	_uygula(0.0)


func _sahne() -> TextureRect:
	var t := TextureRect.new()
	t.mouse_filter = Control.MOUSE_FILTER_IGNORE
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	t.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	return t


func _baslat() -> void:
	_gecen = 0.0
	_oynuyor = true
	set_process(true)


func _process(dt: float) -> void:
	if not _oynuyor:
		return
	_gecen += dt
	_uygula(_gecen)
	if _gecen >= SURE:
		_oynuyor = false
		set_process(false)
		bitti.emit()


func _uygula(t: float) -> void:
	var k := kapak_karisimi(t)
	var ia: int = k["a"]
	var ib: int = k["b"]
	var kar: float = k["k"]
	if ia >= 0 and ia < _kareler.size():
		_arka.texture = _kareler[ia]
	if ib >= 0 and ib < _kareler.size():
		_on.texture = _kareler[ib]
	_arka.modulate.a = 1.0
	_on.modulate.a = kar
	_sayfa_uygula(t)
	if t < YAZI_BAS:
		_yazi.modulate.a = 0.0
	else:
		_yazi.modulate.a = clampf((t - YAZI_BAS) / 0.28, 0.0, 1.0)
	_yazi_yerlestir()


func _sayfa_uygula(t: float) -> void:
	var s := sayfa_kat(t)
	if not bool(s["gorunur"]) or float(s["kat"]) <= 0.0:
		_sayfa.visible = false
		return
	_sayfa.visible = true
	var sz := size
	if sz.x < 8.0:
		sz = Vector2(1152, 864)
	# acik.png perspektifindeki sayfa köşeleri (oran).
	var gt := Vector2(sz.x * 0.443, sz.y * 0.315)
	var gb := Vector2(sz.x * 0.500, sz.y * 0.690)
	var ot := Vector2(sz.x * 0.722, sz.y * 0.292)
	var ob := Vector2(sz.x * 0.812, sz.y * 0.713)
	var lt := Vector2(sz.x * 0.361, sz.y * 0.352)
	var lb := Vector2(sz.x * 0.309, sz.y * 0.769)
	var kat: float = s["kat"]
	# 0–0.5: sağ sayfa omurgaya kıvrılır, 0.5–1: sol tarafa açılır.
	if kat <= 0.5:
		var u := kat / 0.5
		var kvr := cos(u * PI * 0.5)
		var dt := ot.lerp(gt, 1.0 - kvr)
		var db := ob.lerp(gb, 1.0 - kvr)
		_sayfa.polygon = PackedVector2Array([gt, dt, db, gb])
		_sayfa.color = Color(0.90, 0.84, 0.72, 0.96).lerp(Color(0.55, 0.46, 0.36, 1.0), u * 0.45)
	else:
		var u := (kat - 0.5) / 0.5
		var kvr := sin(u * PI * 0.5)
		var dt := gt.lerp(lt, kvr)
		var db := gb.lerp(lb, kvr)
		_sayfa.polygon = PackedVector2Array([dt, gt, gb, db])
		_sayfa.color = Color(0.55, 0.46, 0.36, 1.0).lerp(Color(0.90, 0.84, 0.72, 0.96), u)


func _yazi_yerlestir() -> void:
	var sz := size
	if sz.x < 8.0:
		sz = Vector2(1152, 864)
	_yazi.position = Vector2(sz.x * 0.50, sz.y * 0.34)
	_yazi.size = Vector2(sz.x * 0.24, sz.y * 0.36)
