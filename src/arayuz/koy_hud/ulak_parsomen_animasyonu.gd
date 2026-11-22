## Kapı açılışı beratı: mühür kırılır, parşömen açılır.
## Kareler yoksa `olustur` null döner; düz yazı paneli bozulmaz.
class_name UlakParsomenAnimasyonu
extends TextureRect

signal bitti

const KOK := "res://assets/ui/ulak/parsomen/"
const ULAK_YOL := "res://assets/ui/ulak/ulak_asker.png"
const KARE_SURE := 0.15
const SON_TUTMA := 0.18
const KARE_SAYISI := 9

var _kareler: Array[Texture2D] = []
var _oynuyor := false


static func kare_yolu(no: int) -> String:
	return "%skare_%02d.png" % [KOK, no]


static func kareleri() -> Array[Texture2D]:
	var kareler: Array[Texture2D] = []
	for no in range(1, KARE_SAYISI + 1):
		var yol := kare_yolu(no)
		if not ResourceLoader.exists(yol):
			break
		var doku: Texture2D = load(yol)
		if doku == null:
			break
		kareler.append(doku)
	return kareler


static func ulak_dokusu() -> Texture2D:
	if not ResourceLoader.exists(ULAK_YOL):
		return null
	return load(ULAK_YOL) as Texture2D


## En az iki karesi varsa animasyonu kurar; yoksa null.
static func olustur() -> UlakParsomenAnimasyonu:
	var kareler := kareleri()
	if kareler.size() < 2:
		return null
	var n := UlakParsomenAnimasyonu.new()
	n._kareler = kareler
	return n


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	if not _kareler.is_empty():
		texture = _kareler[0]
	gui_input.connect(_tik)


func _tik(olay: InputEvent) -> void:
	if _oynuyor:
		return
	if olay is InputEventMouseButton and olay.pressed and olay.button_index == MOUSE_BUTTON_LEFT:
		accept_event()
		oyna()


func oyna() -> void:
	if _oynuyor:
		return
	if _kareler.size() < 2:
		bitti.emit()
		return
	_oynuyor = true
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	texture = _kareler[0]
	for i in range(1, _kareler.size()):
		await get_tree().create_timer(KARE_SURE).timeout
		if not is_instance_valid(self):
			return
		texture = _kareler[i]
	await get_tree().create_timer(SON_TUTMA).timeout
	if is_instance_valid(self):
		bitti.emit()
