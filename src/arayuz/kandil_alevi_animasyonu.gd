## C1/C2: ağır kandil alevi. Origin kareleri paylaşılır; köşede / çubuk yanında döngü.
class_name KandilAleviAnimasyonu
extends Control

const KOK := "res://assets/art/anim/"
const ADET := 4
const PERIYOT := 3.8
## ping-pong: son adım ilk kareye döner (son ≈ ilk).
const DIZI: Array[int] = [0, 1, 2, 3, 2, 1]


static func kare_yolu(i: int) -> String:
	return KOK + "kandil_alev_%02d.png" % (clampi(i, 0, ADET - 1) + 1)


static func kareleri_yukle() -> Array[Texture2D]:
	var kareler: Array[Texture2D] = []
	for i in ADET:
		var d := KodluSahneAnimasyonu.doku(kare_yolu(i))
		if d == null:
			return []
		kareler.append(d)
	return kareler


## t saniye; dönen karışım. Son adım 1→0 ile başa bağlanır.
static func dongu_karisimi(t: float, periyot: float = PERIYOT) -> Dictionary:
	var p := periyot if periyot > 0.001 else PERIYOT
	var faz := fposmod(t, p) / p
	var adim := DIZI.size()
	var u := faz * float(adim)
	var i := int(u) % adim
	var k: float = u - float(i)
	return {"a": DIZI[i], "b": DIZI[(i + 1) % adim], "k": KodluSahneAnimasyonu.smoothstepk(k)}


static func alev_olcek(t: float) -> float:
	return 1.0 + 0.04 * sin(t * 1.55) + 0.018 * sin(t * 0.73 + 0.9)


static func alev_parlaklik(t: float) -> float:
	return 0.86 + 0.14 * (0.5 + 0.5 * sin(t * 1.28 + 0.35)) + 0.04 * sin(t * 2.1)


static func yerlestir(ebeveyn: Control, yer: String = "menu_kose") -> KandilAleviAnimasyonu:
	if ebeveyn == null:
		return null
	var kareler := kareleri_yukle()
	if kareler.size() < ADET:
		return null
	var n := KandilAleviAnimasyonu.new()
	n.name = "KandilAlevi"
	n.mouse_filter = Control.MOUSE_FILTER_IGNORE
	n.process_mode = Node.PROCESS_MODE_ALWAYS
	n.z_index = 30
	n._kareler = kareler
	if yer == "yukleme_cubugu":
		n.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
		n.offset_left = -540
		n.offset_right = -340
		n.offset_top = -220
		n.offset_bottom = -40
	else:
		n.anchor_left = 1.0
		n.anchor_right = 1.0
		n.anchor_top = 1.0
		n.anchor_bottom = 1.0
		n.offset_left = -250
		n.offset_right = -24
		n.offset_top = -340
		n.offset_bottom = -90
	ebeveyn.add_child(n)
	n._sahne_kur()
	n.set_process(true)
	return n


static func cubuk_yanina(zemin: Control) -> KandilAleviAnimasyonu:
	return yerlestir(zemin, "yukleme_cubugu")


var _kareler: Array[Texture2D] = []
var _arka: TextureRect
var _on: TextureRect
var _gecen := 0.0


func _sahne_kur() -> void:
	_arka = _katman(_kareler[0])
	_on = _katman(_kareler[0])
	add_child(_arka)
	add_child(_on)
	_uygula(0.0)


func _katman(doku_ref: Texture2D) -> TextureRect:
	var t := TextureRect.new()
	t.mouse_filter = Control.MOUSE_FILTER_IGNORE
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	t.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	t.pivot_offset = Vector2(113, 125)
	t.texture = doku_ref
	return t


func _process(dt: float) -> void:
	_gecen += dt
	_uygula(_gecen)


func _uygula(t: float) -> void:
	if _kareler.is_empty() or _arka == null:
		return
	var k := dongu_karisimi(t)
	var ia: int = k["a"]
	var ib: int = k["b"]
	if ia >= 0 and ia < _kareler.size():
		_arka.texture = _kareler[ia]
	if ib >= 0 and ib < _kareler.size():
		_on.texture = _kareler[ib]
	_arka.modulate.a = 1.0
	_on.modulate.a = float(k["k"])
	var olcek := alev_olcek(t)
	var par := alev_parlaklik(t)
	var col := Color(par, par * 0.97, par * 0.88, 1.0)
	_arka.modulate = Color(col, 1.0)
	_on.modulate = Color(col, float(k["k"]))
	# pivot kandil kabının alev köküne yakın; scale oradan.
	for kat in [_arka, _on]:
		kat.pivot_offset = kat.size * Vector2(0.50, 0.62) if kat.size.x > 4.0 else Vector2(100, 120)
		kat.scale = Vector2(olcek, olcek)
