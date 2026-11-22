## Gece kapısı 9-dilim çerçeveleri. Paylar docs/arayuz/GECE_KAPISI_ALFA_KABUL.md tablosundandır.
## Doku yoksa null döner; çağıran düz StyleBoxFlat'te kalır.
class_name GeceKapisiCerceve
extends RefCounted

const KOK := "res://assets/ui/atmosfer/gece_kapisi/"
const ARKA := "res://assets/ui/arkaplan/"
const TEMA := "res://src/arayuz/gece_kapisi_tema.tres"

const KIRPMA := 16
const KIRPILAN := [
	"dialogue_panel",
	"button_normal",
	"button_hover",
	"button_pressed",
	"button_disabled",
	"focus_ring",
	"settings_panel",
	"tooltip_panel",
	"hud_strip",
	"loading_track",
	"loading_fill",
]

## texture_margin sol, üst, sağ, alt. İçerik payı yazının tahtaya binmemesi içindir.
const DILIM := {
	"dialogue_panel": [112, 112, 112, 112, 24],
	"button_normal": [18, 14, 18, 14, 10],
	"button_hover": [18, 14, 18, 14, 10],
	"button_pressed": [18, 14, 18, 14, 10],
	"button_disabled": [18, 14, 18, 14, 10],
	"focus_ring": [18, 14, 18, 14, 10],
	"settings_panel": [192, 192, 192, 192, 40],
	"tooltip_panel": [72, 72, 72, 72, 20],
	"hud_strip": [44, 32, 44, 32, 8],
	"loading_track": [16, 4, 16, 4, 2],
	"loading_fill": [16, 4, 16, 4, 2],
	## Ahmet'in altı parçası. Dosya yoksa bu satırlar kullanılmaz; eski PNG durur.
	"cerceve_diyalog_seridi": [112, 96, 112, 96, 28],
	"cerceve_secenek_satiri": [28, 18, 28, 18, 10],
	"cerceve_portre": [96, 96, 96, 96, 12],
	"cerceve_panel": [96, 96, 96, 96, 32],
	"cerceve_muhur": [0, 0, 0, 0, 0],
	"cerceve_rumi_kose": [0, 0, 0, 0, 0],
}

## Nihai adlar. Ham yeşil kopya work/ui_yesil_ham/ altına konur; araç bunu üretir.
const BEKLENEN := [
	"cerceve_diyalog_seridi",
	"cerceve_secenek_satiri",
	"cerceve_portre",
	"cerceve_panel",
	"cerceve_muhur",
	"cerceve_rumi_kose",
]


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


## Yeni parça varsa o doku ve kendi payı. Yoksa istenen eski ad.
static func _kaynak(ad: String) -> String:
	if ad == "dialogue_panel" and var_mi("cerceve_diyalog_seridi"):
		return "cerceve_diyalog_seridi"
	if (ad.begins_with("button_") or ad == "focus_ring") and var_mi("cerceve_secenek_satiri"):
		return "cerceve_secenek_satiri"
	if ad == "settings_panel" and var_mi("cerceve_panel"):
		return "cerceve_panel"
	return ad


static func kutu(ad: String, eskiyi_koru: bool = false) -> StyleBoxTexture:
	if not DILIM.has(ad):
		return null
	var kaynak := ad if eskiyi_koru else _kaynak(ad)
	if not var_mi(kaynak):
		return null
	var pay: Array = DILIM[kaynak]
	var doku := _doku(kaynak)
	if doku == null:
		return null
	var s := StyleBoxTexture.new()
	s.texture = doku
	if kaynak in KIRPILAN and doku.get_width() > KIRPMA * 2 and doku.get_height() > KIRPMA * 2:
		s.region_rect = Rect2(KIRPMA, KIRPMA, doku.get_width() - KIRPMA * 2, doku.get_height() - KIRPMA * 2)
	s.texture_margin_left = pay[0]
	s.texture_margin_top = pay[1]
	s.texture_margin_right = pay[2]
	s.texture_margin_bottom = pay[3]
	s.content_margin_left = pay[4]
	s.content_margin_right = pay[4]
	s.content_margin_top = pay[4]
	s.content_margin_bottom = pay[4]
	if kaynak in ["button_normal", "button_hover", "button_pressed", "button_disabled", "focus_ring"]:
		s.content_margin_left = 18
		s.content_margin_right = 18
	elif kaynak == "hud_strip":
		s.content_margin_left = 30
		s.content_margin_right = 64
		s.content_margin_top = 10
		s.content_margin_bottom = 10
	s.axis_stretch_horizontal = StyleBoxTexture.AXIS_STRETCH_MODE_STRETCH
	s.axis_stretch_vertical = StyleBoxTexture.AXIS_STRETCH_MODE_STRETCH
	return s


## Düğme kaynağı 192 px yüksektir. Kabul payı 64+64, 48 px'lik düğmede köşeyi ezer.
## 28 px pay, metal köşenin dış halkasını bırakır ve yazıya yer açar.
static func dugme(ad: String = "button_normal") -> StyleBox:
	return kutu(ad)


static func panel() -> StyleBox:
	return kutu("dialogue_panel")


## Balon paneline rumi köşe. Dosya yoksa hiçbir düğüm eklenmez.
static func rumi_koseleri(panel: Control) -> void:
	if panel == null or not var_mi("cerceve_rumi_kose"):
		return
	var doku := _doku("cerceve_rumi_kose")
	if doku == null:
		return
	var cevir: Array[Dictionary] = [
		{"ad": "RumiSolUst", "yer": Control.PRESET_TOP_LEFT, "yatay": false, "dikey": false},
		{"ad": "RumiSagUst", "yer": Control.PRESET_TOP_RIGHT, "yatay": true, "dikey": false},
		{"ad": "RumiSagAlt", "yer": Control.PRESET_BOTTOM_RIGHT, "yatay": true, "dikey": true},
		{"ad": "RumiSolAlt", "yer": Control.PRESET_BOTTOM_LEFT, "yatay": false, "dikey": true},
	]
	for bilgi in cevir:
		if panel.get_node_or_null(String(bilgi["ad"])) != null:
			continue
		var kose := TextureRect.new()
		kose.name = String(bilgi["ad"])
		kose.texture = doku
		kose.mouse_filter = Control.MOUSE_FILTER_IGNORE
		kose.flip_h = bool(bilgi["yatay"])
		kose.flip_v = bool(bilgi["dikey"])
		kose.custom_minimum_size = Vector2(72, 72)
		kose.set_anchors_preset(int(bilgi["yer"]))
		if int(bilgi["yer"]) == Control.PRESET_TOP_LEFT:
			kose.offset_right = 72
			kose.offset_bottom = 72
		elif int(bilgi["yer"]) == Control.PRESET_TOP_RIGHT:
			kose.offset_left = -72
			kose.offset_bottom = 72
		elif int(bilgi["yer"]) == Control.PRESET_BOTTOM_RIGHT:
			kose.offset_left = -72
			kose.offset_top = -72
		else:
			kose.offset_right = 72
			kose.offset_top = -72
		panel.add_child(kose)


## Portre düğmesinin arkasına delikli çerçeve. Dosya yoksa düğüm aynı kalır.
static func portre_giydir(hedef: Control) -> void:
	var cerceve := kutu("cerceve_portre")
	if cerceve == null or hedef == null or hedef.get_parent() == null:
		return
	var ebeveyn := hedef.get_parent()
	var sira := hedef.get_index()
	var kap := Panel.new()
	kap.name = "PortreCercevesi"
	kap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	kap.add_theme_stylebox_override("panel", cerceve)
	kap.size_flags_horizontal = hedef.size_flags_horizontal
	kap.size_flags_vertical = hedef.size_flags_vertical
	ebeveyn.remove_child(hedef)
	kap.add_child(hedef)
	hedef.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	ebeveyn.add_child(kap)
	ebeveyn.move_child(kap, sira)


## Defter veya divan sayfasının köşesine mühür. Dosya yoksa eklenmez.
static func muhur_ekle(zemin: Control) -> void:
	if zemin == null or zemin.get_node_or_null("Muhur") != null or not var_mi("cerceve_muhur"):
		return
	var doku := _doku("cerceve_muhur")
	if doku == null:
		return
	var damga := TextureRect.new()
	damga.name = "Muhur"
	damga.texture = doku
	damga.mouse_filter = Control.MOUSE_FILTER_IGNORE
	damga.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	damga.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	damga.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	damga.offset_left = -136
	damga.offset_top = -136
	damga.offset_right = -28
	damga.offset_bottom = -28
	zemin.add_child(damga)


static func uygula(t: Theme) -> bool:
	## Genel panel yeni dosyayı bekler. Yoksa eski diyalog tahtası kalır; şerit balona aittir.
	var ozel := kutu("cerceve_panel")
	var govde := ozel if ozel != null else kutu("dialogue_panel", true)
	if govde == null:
		return false
	t.set_stylebox("panel", "Panel", govde)
	t.set_stylebox("panel", "PanelContainer", govde.duplicate())
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


static func _arka_doku(ad: String) -> Texture2D:
	var dosya := ARKA + ad + ".png"
	if not (FileAccess.file_exists(dosya) or ResourceLoader.exists(dosya)):
		return null
	if ResourceLoader.exists(dosya):
		var kaynak: Texture2D = load(dosya) as Texture2D
		if kaynak != null:
			return kaynak
	var img := Image.new()
	if img.load(dosya) != OK:
		return null
	return ImageTexture.create_from_image(img)


## Dosya varsa tam ekran arka plan TextureRect döner; yoksa null (eski görünüm aynen kalır).
static func arka_plan_varsa(ad: String) -> TextureRect:
	var doku := _arka_doku(ad)
	if doku == null:
		return null
	var r := TextureRect.new()
	r.name = "arka_" + ad
	r.texture = doku
	r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	r.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	return r


## Ahmet dosyayı koyunca kod değişmez. Yoksa isim etiketli koyu kutu.
static func arka_plan(ad: String) -> Control:
	var hazir := arka_plan_varsa(ad)
	if hazir != null:
		return hazir
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
