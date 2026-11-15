## MEV-09: mevcut 2D portre görselini daraltır; kanıt, karar ve metin API değişmez.
class_name KapiGorusAdaptoru
extends RefCounted
const AYAR: Dictionary = preload("res://data/kapi_gorusu.json").data
const BULANIK := preload("res://src/arayuz/kapi/kapi_gorusu.gdshader")
const META := &"kapi_gorus_eski_mat"

## Eski bağımsız inceleme hostunda oturum şart koşmaz.
static func bagla(panel: Control, ekran: Control) -> void:
	for alan in ekran.get_property_list():
		if alan.name == "oturum":
			var o := ekran.get("oturum") as Oturum
			if o != null: uygula(panel, o.yonetim)
			return

## Aynı hava kaydından okunur; gün/RNG/kanıt veya kayda yazmaz.
static func yaricap(y: KoyYonetimi) -> float:
	return clampf(float(AYAR.get(IklimDeneyi.hava(y), 0.0)), 0.0, 8.0)

## İdempotent; normal havaya dönüşte önceki materyali aynen geri verir.
static func uygula(panel: Control, y: KoyYonetimi) -> void:
	var portre := panel.find_child("GorselIz", true, false) as TextureButton
	if portre == null: return
	var r := yaricap(y)
	if not portre.has_meta(META): portre.set_meta(META, {"mat": portre.material})
	if r > 0.0:
		var mat := portre.material as ShaderMaterial
		if mat == null or mat.shader != BULANIK:
			mat = ShaderMaterial.new()
			mat.shader = BULANIK
			portre.material = mat
		mat.set_shader_parameter("yaricap", r)
	else:
		portre.material = portre.get_meta(META)["mat"]
	var kutu := portre.get_parent()
	var uyari := kutu.get_node_or_null("KapiGorusUyarisi") as Label
	if uyari == null:
		uyari = Label.new()
		uyari.name = "KapiGorusUyarisi"
		uyari.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		uyari.add_theme_font_size_override("font_size", Kabuk.KUCUK)
		kutu.add_child(uyari)
		kutu.move_child(uyari, portre.get_index() + 1)
	uyari.text = "Tipi görüşü daraltıyor; fiziksel iz için portreyi yakından incele." if IklimDeneyi.hava(y) == "kar_firtinasi" else "Sis görüşü daraltıyor; fiziksel iz için portreyi yakından incele."
	uyari.visible = r > 0.0
