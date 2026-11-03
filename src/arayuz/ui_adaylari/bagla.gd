## Gece UI adayları. Her paket ayrı bir ekrana bağlanır; sabah birini Ahmet seçer.
## Ekran betiğine, sinyale ve oyun kuralına dokunulmaz. Yalnız tema ve bir levha eklenir.
## Ayarlar (Bölüm 35), hafıza defteri (Bölüm 39), diyalog ve ekonomi kodu bu listede yoktur.
## Test ve içe aktarma sırasında kapalıdır; birim ölçüsü değişmesin.
extends Node

const MENU := "res://assets/ui_adaylari/lamoot_ahsap/tema.tres"
const HEYBE := "res://assets/ui_adaylari/itsmars_envanter/tema.tres"
const IZGARA := "res://assets/ui_adaylari/itsmars_envanter/izgara.png"
const KOY := "res://assets/ui_adaylari/kenney_rpg/tema.tres"
const BILGI := "res://assets/ui_adaylari/crisp_quest/tema.tres"
const DIVAN := "res://assets/ui_adaylari/kenney_macera/tema.tres"

const EKRAN := {
	"res://src/arayuz/menu_ekrani.gd": MENU,
	"res://src/arayuz/heybe_paneli.gd": HEYBE,
	"res://src/arayuz/bilgi_ekrani.gd": BILGI,
	"res://src/kapi/divan_ekrani.gd": DIVAN,
}

var _acik := false
var _onbellek := {}


func _ready() -> void:
	_acik = _calistirilsin()
	if _acik:
		get_tree().node_added.connect(_eklendi)


func _calistirilsin() -> bool:
	var tum := " ".join(OS.get_cmdline_args())
	if "tests/" in tum or "--import" in tum or "--editor" in tum:
		return false
	return true


func _eklendi(n: Node) -> void:
	if not _acik or not is_instance_valid(n):
		return
	var betik: Script = n.get_script()
	if betik != null and EKRAN.has(str(betik.resource_path)):
		_uygula.call_deferred(n, EKRAN[str(betik.resource_path)])
		return
	if n is PanelContainer:
		var ebeveyn := n.get_parent()
		if ebeveyn == null:
			return
		var eb: Script = ebeveyn.get_script()
		if eb != null and str(eb.resource_path) == "res://src/arayuz/koy_ekrani.gd":
			_uygula.call_deferred(n, KOY)


func _tema(yol: String) -> Theme:
	if not _onbellek.has(yol):
		_onbellek[yol] = load(yol)
	return _onbellek[yol]


func _uygula(n: Node, yol: String) -> void:
	if not is_instance_valid(n) or not n is Control:
		return
	var kok := n as Control
	var tema := _tema(yol)
	if tema == null:
		return
	kok.theme = tema
	_panel_birak(kok)
	var betik: Script = kok.get_script()
	if betik == null:
		return
	var yp := str(betik.resource_path)
	if yp == "res://src/arayuz/menu_ekrani.gd":
		_menu_levhasi(kok, tema)
	elif yp == "res://src/arayuz/heybe_paneli.gd":
		_heybe_izgarasi(kok)


## Köy ve divan paneli kendi düz kutusunu basıyor; aday dokusu görünsün diye o kutu kalkar.
func _panel_birak(n: Node) -> void:
	if n is PanelContainer:
		(n as PanelContainer).remove_theme_stylebox_override("panel")
	for cocuk in n.get_children():
		_panel_birak(cocuk)


## Menü satırı kendi çizer. Levha onun arkasında durur; tıklamayı yemez.
func _menu_levhasi(menu: Control, tema: Theme) -> void:
	if menu.get_node_or_null("aday_levha") != null:
		return
	var kok := _menu_koku(menu)
	if kok == null:
		return
	var levha := Panel.new()
	levha.name = "aday_levha"
	levha.mouse_filter = Control.MOUSE_FILTER_IGNORE
	levha.position = Vector2(36, 250)
	levha.size = Vector2(640, 720)
	var stil := tema.get_stylebox("panel", "Panel")
	if stil != null:
		levha.add_theme_stylebox_override("panel", stil)
	menu.add_child(levha)
	menu.move_child(levha, kok.get_index())


func _menu_koku(n: Node) -> Node:
	for c in n.get_children():
		if c is MenuSatiri:
			return n
		var bulunan := _menu_koku(c)
		if bulunan != null:
			return bulunan
	return null


## Heybe tepsisine taş ızgara. Kartlar sonra eklendiği için üstte kalır. Tıklama geçilir.
func _heybe_izgarasi(heybe: Control) -> void:
	if heybe.get_node_or_null("aday_izgara") != null:
		return
	var r: Rect2 = HeybePaneli.TEPSI
	var izgara := TextureRect.new()
	izgara.name = "aday_izgara"
	izgara.mouse_filter = Control.MOUSE_FILTER_IGNORE
	izgara.texture = load(IZGARA)
	izgara.position = r.position + Vector2(0, 36)
	izgara.size = Vector2(r.size.x, r.size.y - 90)
	izgara.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	izgara.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	heybe.add_child(izgara)
	heybe.move_child(izgara, 1)
