## Ortak kare dizisi kabuğu: TextureRect, dosya yoksa olustur null döner.
class_name KareAnimasyonKabuk
extends TextureRect

signal bitti

const KARE_SURE := 0.15
const SON_TUTMA := 0.22

var _kareler: Array[Texture2D] = []
var _oynuyor := false
var _kucuk_ikon := false


static func yukle_kareler(kok: String, adet: int) -> Array[Texture2D]:
	var kareler: Array[Texture2D] = []
	for no in range(1, adet + 1):
		var yol := "%skare_%02d.png" % [kok, no]
		if not ResourceLoader.exists(yol):
			break
		var doku: Texture2D = load(yol)
		if doku == null:
			break
		kareler.append(doku)
	return kareler


## `zar_d6_roll_01.png` gibi ön ekli kareler (assets/art/anim).
static func yukle_kareler_on_ekli(kok: String, on_ek: String, adet: int) -> Array[Texture2D]:
	var kareler: Array[Texture2D] = []
	for no in range(1, adet + 1):
		var yol := "%s%s%02d.png" % [kok, on_ek, no]
		if not ResourceLoader.exists(yol):
			break
		var doku: Texture2D = load(yol)
		if doku == null:
			break
		kareler.append(doku)
	return kareler


func kur(kareler: Array[Texture2D]) -> void:
	_kareler = kareler
	if not kareler.is_empty() and kareler[0] != null and kareler[0].get_width() <= 512:
		_kucuk_ikon = true


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	if _kucuk_ikon:
		anchor_left = 0.5
		anchor_right = 0.5
		anchor_top = 0.5
		anchor_bottom = 0.5
		offset_left = -240
		offset_top = -240
		offset_right = 240
		offset_bottom = 240
	else:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	if not _kareler.is_empty():
		texture = _kareler[0]


func oyna() -> void:
	if _oynuyor:
		return
	if _kareler.size() < 2:
		bitti.emit()
		return
	_oynuyor = true
	texture = _kareler[0]
	for i in range(1, _kareler.size()):
		await get_tree().create_timer(KARE_SURE).timeout
		if not is_instance_valid(self):
			return
		texture = _kareler[i]
	await get_tree().create_timer(SON_TUTMA).timeout
	if is_instance_valid(self):
		bitti.emit()


func son_kareyi_goster() -> void:
	if not _kareler.is_empty():
		texture = _kareler[_kareler.size() - 1]


## Overlay olarak ekler, oynatır, siler. Kare yoksa hemen döner.
static func oynat_uzerinde(ebeveyn: Control, n: KareAnimasyonKabuk, aninda: bool = false) -> void:
	if ebeveyn == null or n == null:
		return
	var perde := ColorRect.new()
	perde.name = "KareAnimasyonPerde"
	perde.color = Color(0.02, 0.02, 0.03, 0.72)
	perde.mouse_filter = Control.MOUSE_FILTER_IGNORE
	perde.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	perde.z_index = 79
	ebeveyn.add_child(perde)
	n.z_index = 80
	ebeveyn.add_child(n)
	if aninda:
		n.son_kareyi_goster()
		await ebeveyn.get_tree().create_timer(0.18).timeout
	else:
		await n.oyna()
	if is_instance_valid(n):
		var tw := n.create_tween()
		tw.tween_property(n, "modulate:a", 0.0, 0.28)
		if is_instance_valid(perde):
			tw.parallel().tween_property(perde, "modulate:a", 0.0, 0.28)
		await tw.finished
	if is_instance_valid(n):
		n.queue_free()
	if is_instance_valid(perde):
		perde.queue_free()
