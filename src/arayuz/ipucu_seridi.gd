## OGR-08 & OGR-11: Ipucu tek satirdir ve ekranin ayni kosesindedir; koy hizini degistirmez.
## Ipucu metni en cok 90 karakterdir, HUD'un alt-sol kosesinde 6 saniye durur ya da ilk girdiyle kapanir.
## Pencere acmaz, oyunu durdurmaz, `Engine.time_scale` degerine dokunmaz.
class_name IpucuSeridi
extends PanelContainer

signal kapandi(ipucu_id: String)

const AZAMI_KARAKTER := 90
const GOSTERIM_SURESI_SN := 6.0

var _etiket: Label
var _aktif_id: String = ""
var _kalan_sure: float = 0.0


func _init() -> void:
	name = "IpucuSeridi"
	visible = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	offset_left = 24
	offset_bottom = -24
	offset_top = -68
	offset_right = 760
	var kutu := StyleBoxFlat.new()
	kutu.bg_color = Color(0.06, 0.05, 0.04, 0.88)
	kutu.border_color = Color(0.72, 0.61, 0.36, 0.85)
	kutu.set_border_width_all(1)
	kutu.set_content_margin_all(10)
	add_theme_stylebox_override("panel", kutu)
	_etiket = Label.new()
	_etiket.name = "IpucuMetni"
	_etiket.clip_text = false
	_etiket.autowrap_mode = TextServer.AUTOWRAP_OFF
	add_child(_etiket)
	set_process(false)


static func metin_kirp(metin: String) -> String:
	var tek_satir := metin.replace("\r", " ").replace("\n", " ").strip_edges()
	if tek_satir.length() <= AZAMI_KARAKTER:
		return tek_satir
	return tek_satir.substr(0, AZAMI_KARAKTER).strip_edges()


## GIR-21 / OGR-22: hız yer tutucuları geçerli eylem atamasından okunur.
static func eylem_yerlestir(metin: String) -> String:
	for eylem: String in ["hiz_1", "hiz_2", "hiz_3", "hiz_dur"]:
		var yer := "{" + eylem + "}"
		if yer in metin:
			metin = metin.replace(yer, GirdiEylemleri.tus_adi(eylem))
	return metin


static func hiz_ipucu() -> String:
	return eylem_yerlestir(TranslationServer.translate("arayuz.girdi.ipucu.hiz"))


func goster(metin: String, ipucu_id: String = "", sure_sn: float = GOSTERIM_SURESI_SN) -> bool:
	var temiz := metin_kirp(eylem_yerlestir(metin))
	if temiz.is_empty():
		return false
	if _etiket == null:
		_etiket = Label.new()
		add_child(_etiket)
	_etiket.text = temiz
	_aktif_id = ipucu_id.strip_edges()
	_kalan_sure = maxf(0.1, sure_sn)
	visible = true
	set_process(true)
	return true


func ayar_degisti(_anahtar: StringName, ayarlar: Ayarlar) -> void:
	if not preload("res://src/sistemler/ipucu_anahtari.gd").gosterim_acik(ayarlar): kapat()


func kapat() -> void:
	if not visible and _kalan_sure <= 0.0:
		return
	var eski_id := _aktif_id
	visible = false
	_kalan_sure = 0.0
	_aktif_id = ""
	set_process(false)
	kapandi.emit(eski_id)


func kalan_sure() -> float:
	return _kalan_sure


func aktif_metin() -> String:
	return _etiket.text if _etiket != null else ""


func _process(delta: float) -> void:
	if not visible:
		set_process(false)
		return
	var gercek_delta := delta / Engine.time_scale if Engine.time_scale > 0.0 else delta
	_kalan_sure -= gercek_delta
	if _kalan_sure <= 0.0:
		kapat()


func _input(olay: InputEvent) -> void:
	if not visible:
		return
	if olay is InputEventKey and (olay as InputEventKey).pressed and not (olay as InputEventKey).echo:
		kapat()
	elif olay is InputEventMouseButton and (olay as InputEventMouseButton).pressed:
		kapat()
	elif olay is InputEventJoypadButton and (olay as InputEventJoypadButton).pressed:
		kapat()
