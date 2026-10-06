## İnşa çubuğundaki yapı kartı: simge, ad, seviye taşları, bedel, kısa açıklama ve eksik koşul.
## Düğmedir (odak ve klavye çalışır); üzerine gelince ya da odaklanınca `onizle` yayar, köyde hayalet görünür.
class_name BinaSecimKarti
extends Button

signal onizle(yapi: StringName)
signal onizleme_bitti

const SIMGE := {&"pazar": "shop", &"kervansaray": "camel", &"sur": "stone-tower"}

var yapi: StringName
var oturum: Oturum


func _ready() -> void:
	custom_minimum_size = Vector2(300, 150)
	clip_contents = true
	var d := oturum.yapi_durumu(yapi)
	var seviye: int = oturum.yapilar[yapi]
	var azami: int = (oturum.ayarlar.get(String(yapi) + "_bedel") as PackedInt32Array).size()
	var kenar := MarginContainer.new()
	kenar.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for y in ["margin_left", "margin_right"]:
		kenar.add_theme_constant_override(y, 14)
	for y in ["margin_top", "margin_bottom"]:
		kenar.add_theme_constant_override(y, 10)
	kenar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(kenar)
	var v := VBoxContainer.new()
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_theme_constant_override("separation", 4)
	kenar.add_child(v)
	var ust := HBoxContainer.new()
	ust.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ust.add_theme_constant_override("separation", 10)
	v.add_child(ust)
	ust.add_child(HudYardim.simge(SIMGE.get(yapi, "village"), 40.0))
	var ad_kutu := VBoxContainer.new()
	ad_kutu.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ad_kutu.add_theme_constant_override("separation", 0)
	ad_kutu.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ust.add_child(ad_kutu)
	ad_kutu.add_child(HudYardim.etiket(tr("arayuz.yapi." + String(yapi)), &"Baslik", 24))
	var taslar := ""
	for i in azami:
		taslar += "◆ " if i < seviye else "◇ "
	var tl := HudYardim.etiket(taslar.strip_edges(), &"", 18)
	tl.add_theme_color_override("font_color", Renkler.BRONZ_ACIK)
	ad_kutu.add_child(tl)
	var bedel := HBoxContainer.new()
	bedel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bedel.add_theme_constant_override("separation", 4)
	ust.add_child(bedel)
	if d["bedel"] >= 0:
		bedel.add_child(HudYardim.simge("two-coins", 26.0))
		var bl := HudYardim.etiket(str(d["bedel"]), &"Sayi", 24)
		bl.add_theme_color_override("font_color", Renkler.PARSOMEN if oturum.akce >= int(d["bedel"]) else Renkler.EKSI)
		bedel.add_child(bl)
	var aciklama := HudYardim.etiket(tr("arayuz.yapi.%s_aciklama" % yapi), &"", 18)
	aciklama.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	aciklama.add_theme_color_override("font_color", Renkler.PARSOMEN.darkened(0.15))
	v.add_child(aciklama)
	if d["bedel"] < 0:
		var az := HudYardim.etiket(tr("arayuz.yapi.azami") % tr("arayuz.yapi." + String(yapi)), &"", 18)
		az.add_theme_color_override("font_color", Renkler.BRONZ_ACIK)
		v.add_child(az)
		disabled = true
	else:
		if oturum.koy.sayi(&"esnaf") < int(d["esnaf"]):
			var e := HudYardim.etiket(tr("arayuz.yapi.esnaf_gerek") % d["esnaf"], &"", 18)
			e.add_theme_color_override("font_color", Renkler.EKSI)
			v.add_child(e)
		disabled = not d["olur"]
	tooltip_text = tr("arayuz.yapi.%s_aciklama" % yapi)
	mouse_entered.connect(func() -> void: onizle.emit(yapi))
	focus_entered.connect(func() -> void: onizle.emit(yapi))
	mouse_exited.connect(func() -> void: onizleme_bitti.emit())
	focus_exited.connect(func() -> void: onizleme_bitti.emit())
