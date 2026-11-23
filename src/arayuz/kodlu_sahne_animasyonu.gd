## Kodla hareket eden sahne overlay'i: perde, süre, sönümlü geçiş.
class_name KodluSahneAnimasyonu
extends Control

signal bitti

var _gecen := 0.0
var _sure := 1.8
var _oynuyor := false
var _perde_alfa := 0.58
var _plakalar: Array[Texture2D] = []
var _plaka_sure: Array[float] = []
var _arka: TextureRect
var _on: TextureRect
var _perde: ColorRect


static func doku(yol: String) -> Texture2D:
	if not ResourceLoader.exists(yol):
		return null
	return load(yol) as Texture2D


static func ease_out(t: float) -> float:
	var u := clampf(t, 0.0, 1.0)
	return 1.0 - pow(1.0 - u, 3.0)


static func smoothstepk(t: float) -> float:
	var u := clampf(t, 0.0, 1.0)
	return u * u * (3.0 - 2.0 * u)


## Çıkışta hafif taşma, sonra yerine oturuş (ağırlık hissi).
static func settle(t: float, tasma: float = 0.07) -> float:
	var u := clampf(t, 0.0, 1.0)
	if u < 0.76:
		var s := u / 0.76
		return (1.0 + tasma) * ease_out(s)
	var s := (u - 0.76) / 0.24
	return 1.0 + tasma * (1.0 - s) * (1.0 - s) * (1.0 - 2.0 * s)


static func plaka_karisimi(sureler: Array, t: float) -> Dictionary:
	if sureler.is_empty():
		return {"a": 0, "b": 0, "k": 1.0}
	var son := sureler.size() - 1
	var u := clampf(t, 0.0, float(sureler[son]))
	var i := 0
	while i < son and u >= float(sureler[i + 1]):
		i += 1
	if i >= son:
		return {"a": son, "b": son, "k": 1.0}
	var t0 := float(sureler[i])
	var t1 := float(sureler[i + 1])
	var k := 0.0 if t1 <= t0 else clampf((u - t0) / (t1 - t0), 0.0, 1.0)
	# kısa tutuş, yumuşak çözünme, sonda settle
	var ease := 0.0
	if k < 0.14:
		ease = 0.0
	elif k < 0.82:
		ease = smoothstepk((k - 0.14) / 0.68)
	else:
		ease = 1.0
	return {"a": i, "b": i + 1, "k": ease}


static func aninda_mi(dugum: Node) -> bool:
	var n := dugum
	while n != null:
		if "ayarlar" in n and n.ayarlar != null:
			return n.ayarlar.al(&"belirme_hizi") == &"aninda"
		n = n.get_parent()
	return false


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	z_index = 80
	_perde = ColorRect.new()
	_perde.color = Color(0.02, 0.02, 0.03, _perde_alfa)
	_perde.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_perde.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_perde)
	_sahne_kur()
	_uygula(0.0)


func _sahne_kur() -> void:
	if _plakalar.is_empty():
		return
	_arka = _katman(_plakalar[0])
	_on = _katman(_plakalar[0])
	add_child(_arka)
	add_child(_on)


func _katman(doku_ref: Texture2D) -> TextureRect:
	var t := TextureRect.new()
	t.mouse_filter = Control.MOUSE_FILTER_IGNORE
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	t.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	t.texture = doku_ref
	return t


func _plaka_uygula(t: float) -> void:
	if _plakalar.is_empty() or _arka == null:
		return
	var k := plaka_karisimi(_plaka_sure, t)
	var ia: int = k["a"]
	var ib: int = k["b"]
	var kar: float = k["k"]
	if ia >= 0 and ia < _plakalar.size():
		_arka.texture = _plakalar[ia]
	if ib >= 0 and ib < _plakalar.size():
		_on.texture = _plakalar[ib]
	_arka.modulate.a = 1.0
	_on.modulate.a = kar


func _uygula(t: float) -> void:
	_plaka_uygula(t)


func _baslat() -> void:
	_gecen = 0.0
	_oynuyor = true
	set_process(true)


func _aninda_goster() -> void:
	_oynuyor = false
	set_process(false)
	_uygula(_sure)


func _process(dt: float) -> void:
	if not _oynuyor:
		return
	_gecen += dt
	_uygula(minf(_gecen, _sure))
	if _gecen >= _sure:
		_oynuyor = false
		set_process(false)
		bitti.emit()


static func oynat_uzerinde(ebeveyn: Control, n: KodluSahneAnimasyonu, aninda: bool = false) -> void:
	if ebeveyn == null or n == null:
		return
	ebeveyn.add_child(n)
	if aninda:
		n._aninda_goster()
		await ebeveyn.get_tree().create_timer(0.20).timeout
	else:
		n._baslat()
		await n.bitti
	if is_instance_valid(n):
		var tw := n.create_tween()
		tw.tween_property(n, "modulate:a", 0.0, 0.28)
		await tw.finished
	if is_instance_valid(n):
		n.queue_free()
