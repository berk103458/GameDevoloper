## YSM-01: köylü kartındaki üç yaşam değeri. Bar ikonları yer tutucu düz ColorRect'tir;
## gerçek ikon gelince yalnız bu satırlardaki renk kutuları değişir. Köy ortalaması çizmez.
class_name YasamBarlariPaneli
extends RefCounted

const ADLAR := {"aclik": "koy.yasam.aclik", "yorgunluk": "koy.yasam.yorgunluk", "moral": "koy.yasam.moral"}
const IKON_RENK := {"aclik": Renkler.MESALE, "yorgunluk": Kabuk.YORGUNLUK, "moral": Kabuk.MORAL}

## Yaşayan köylü için üç satırı karta ekler; ölü/geçersiz kişide hiçbir şey çizmez.
static func ekle(y: KoyYonetimi, ebeveyn: Control, k: Koylu) -> void:
	var d := YasamBarlari.oku(k, y)
	if d.is_empty(): return
	var baslik := Label.new()
	baslik.name = "yasam_barlari"
	baslik.text = TranslationServer.translate("koy.yasam.baslik")
	baslik.add_theme_font_size_override("font_size", Tema.KUCUK_PX)
	ebeveyn.add_child(baslik)
	for anahtar in YasamBarlari.DEGERLER:
		if d.has(anahtar):
			ebeveyn.add_child(_satir(anahtar, d))

## İkon (yer tutucu), ad ve bar tek satırda; her değer kendi barında okunur.
static func _satir(anahtar: String, d: Dictionary) -> Control:
	var satir := HBoxContainer.new()
	satir.name = "yasam_" + anahtar
	satir.add_theme_constant_override("separation", 8)
	var ikon := ColorRect.new() # YSM01-IKON yer tutucusu; gerçek ikon gelince bu kutu değişir.
	ikon.custom_minimum_size = Vector2(14, 14)
	ikon.color = IKON_RENK.get(anahtar, Color.WHITE)
	satir.add_child(ikon)
	var ad := Label.new()
	ad.text = TranslationServer.translate(ADLAR.get(anahtar, anahtar))
	ad.add_theme_font_size_override("font_size", Tema.KUCUK_PX)
	ad.custom_minimum_size = Vector2(96, 0)
	satir.add_child(ad)
	var bar := ProgressBar.new()
	bar.show_percentage = false
	bar.custom_minimum_size = Vector2(120, 0)
	if anahtar == "yorgunluk":
		bar.max_value = 1.0
		bar.value = 1.0 if bool(d.yorgunluk) else 0.0
	elif anahtar == "moral":
		bar.max_value = 100.0
		bar.value = clampf(float(d.moral), 0.0, 100.0)
	else:
		bar.max_value = maxf(1.0, float(d.aclik))
		bar.value = float(d.aclik)
	satir.add_child(bar)
	return satir