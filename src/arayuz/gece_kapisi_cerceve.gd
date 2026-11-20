## Gece kapısı 9-dilim çerçeveleri. Paylar docs/arayuz/GECE_KAPISI_ALFA_KABUL.md tablosundandır.
## Doku yoksa null döner; çağıran düz StyleBoxFlat'te kalır.
class_name GeceKapisiCerceve
extends RefCounted

const KOK := "res://assets/ui/atmosfer/gece_kapisi/"
const ARKA := "res://assets/ui/arkaplan/"
const TEMA := "res://src/arayuz/gece_kapisi_tema.tres"

## texture_margin sol, üst, sağ, alt. İçerik payı yazının tahtaya binmemesi içindir.
const DILIM := {
	"dialogue_panel": [112, 112, 112, 112, 36],
	"button_normal": [28, 28, 28, 28, 14],
	"button_hover": [28, 28, 28, 28, 14],
	"button_pressed": [28, 28, 28, 28, 14],
	"button_disabled": [28, 28, 28, 28, 14],
	"focus_ring": [28, 28, 28, 28, 14],
	"settings_panel": [192, 192, 192, 192, 40],
	"tooltip_panel": [72, 72, 72, 72, 20],
	"hud_strip": [80, 48, 80, 48, 12],
	"loading_track": [32, 24, 32, 24, 4],
	"loading_fill": [32, 24, 32, 24, 4],
}


static func yol(ad: String) -> String:
	return KOK + ad + ".png"


static func var_mi(ad: String) -> bool:
	return FileAccess.file_exists(yol(ad)) or ResourceLoader.exists(yol(ad))


## Import önbelleği yoksa PNG doğrudan okunur. Oyun içi importlı doku önceliklidir.
static func _doku(ad: String) -> Texture2D:
	var kaynak: Texture2D = load(yol(ad))
	if kaynak != null:
		return kaynak
	var img := Image.new()
	if img.load(yol(ad)) != OK:
		return null
	return ImageTexture.create_from_image(img)


static func kutu(ad: String) -> StyleBoxTexture:
	if not DILIM.has(ad) or not var_mi(ad):
		return null
	var pay: Array = DILIM[ad]
	var doku := _doku(ad)
	if doku == null:
		return null
	var s := StyleBoxTexture.new()
	s.texture = doku
	s.texture_margin_left = pay[0]
	s.texture_margin_top = pay[1]
	s.texture_margin_right = pay[2]
	s.texture_margin_bottom = pay[3]
	s.content_margin_left = pay[4]
	s.content_margin_right = pay[4]
	s.content_margin_top = pay[4]
	s.content_margin_bottom = pay[4]
	s.axis_stretch_horizontal = StyleBoxTexture.AXIS_STRETCH_MODE_STRETCH
	s.axis_stretch_vertical = StyleBoxTexture.AXIS_STRETCH_MODE_STRETCH
	return s


## Düğme kaynağı 192 px yüksektir. Kabul payı 64+64, 48 px'lik düğmede köşeyi ezer.
## 28 px pay, metal köşenin dış halkasını bırakır ve yazıya yer açar.
static func dugme(ad: String = "button_normal") -> StyleBox:
	return kutu(ad)


static func panel() -> StyleBox:
	return kutu("dialogue_panel")


static func uygula(t: Theme) -> bool:
	var p := panel()
	if p == null:
		return false
	t.set_stylebox("panel", "Panel", p)
	t.set_stylebox("panel", "PanelContainer", p.duplicate())
	var normal := dugme("button_normal")
	var hover := dugme("button_hover")
	var basili := dugme("button_pressed")
	var pasif := dugme("button_disabled")
	var odak := dugme("focus_ring")
	if normal != null:
		t.set_stylebox("normal", "Button", normal)
		t.set_stylebox("hover", "Button", hover if hover != null else normal.duplicate())
		t.set_stylebox("pressed", "Button", basili if basili != null else normal.duplicate())
		t.set_stylebox("hover_pressed", "Button", basili if basili != null else normal.duplicate())
		t.set_stylebox("disabled", "Button", pasif if pasif != null else normal.duplicate())
		t.set_stylebox("focus", "Button", odak if odak != null else normal.duplicate())
	var ayar := kutu("settings_panel")
	if ayar != null:
		t.add_type("AyarPaneli")
		t.set_type_variation("AyarPaneli", "PanelContainer")
		t.set_stylebox("panel", "AyarPaneli", ayar)
	var ipucu := kutu("tooltip_panel")
	if ipucu != null:
		t.set_stylebox("panel", "TooltipPanel", ipucu)
	var serit := kutu("hud_strip")
	if serit != null:
		if not t.has_stylebox("panel", "HudPanel"):
			t.add_type("HudPanel")
			t.set_type_variation("HudPanel", "PanelContainer")
		t.set_stylebox("panel", "HudPanel", serit)
	var iz := kutu("loading_track")
	var dolu := kutu("loading_fill")
	if iz != null and dolu != null:
		t.set_stylebox("background", "ProgressBar", iz)
		t.set_stylebox("fill", "ProgressBar", dolu)
	return true


## Ahmet dosyayı koyunca kod değişmez. Yoksa isim etiketli koyu kutu.
static func arka_plan(ad: String) -> Control:
	var dosya := ARKA + ad + ".png"
	if ResourceLoader.exists(dosya):
		var r := TextureRect.new()
		r.name = "arka_" + ad
		r.texture = load(dosya)
		r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		r.mouse_filter = Control.MOUSE_FILTER_IGNORE
		r.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		return r
	var kutu_renk := ColorRect.new()
	kutu_renk.name = "arka_" + ad
	kutu_renk.color = Color("14120f")
	kutu_renk.mouse_filter = Control.MOUSE_FILTER_IGNORE
	kutu_renk.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	kutu_renk.set_meta("kabuk_yer_tutucu", true)
	var etiket := Label.new()
	etiket.text = ad
	etiket.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	etiket.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	etiket.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	etiket.mouse_filter = Control.MOUSE_FILTER_IGNORE
	kutu_renk.add_child(etiket)
	return kutu_renk


static func yukleme_arkasi() -> Control:
	var secilen := _rastgele_yukleme()
	if secilen != "":
		var r := TextureRect.new()
		r.name = "arka_yukleme"
		r.texture = load(secilen)
		r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		r.mouse_filter = Control.MOUSE_FILTER_STOP
		r.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		return r
	if var_mi("loading_bg"):
		var hazir := TextureRect.new()
		hazir.name = "arka_yukleme"
		hazir.texture = load(yol("loading_bg"))
		hazir.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		hazir.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		hazir.mouse_filter = Control.MOUSE_FILTER_STOP
		hazir.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		return hazir
	return arka_plan("yukleme")


static func _rastgele_yukleme() -> String:
	var d := DirAccess.open(ARKA)
	if d == null:
		return ""
	var adaylar: PackedStringArray = []
	d.list_dir_begin()
	var ad := d.get_next()
	while ad != "":
		if not d.current_is_dir() and ad.begins_with("yukleme") and ad.ends_with(".png"):
			adaylar.append(ARKA + ad)
		ad = d.get_next()
	if adaylar.is_empty():
		return ""
	return adaylar[randi() % adaylar.size()]
