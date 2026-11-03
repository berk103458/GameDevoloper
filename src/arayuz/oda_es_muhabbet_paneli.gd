# Muhafız odasında eş ile konuşma paneli (Görev 5 - Bölüm 1B)
class_name OdaEsMuhabbetPaneli
extends RefCounted

static func kur(ekran: Control, icerik: VBoxContainer) -> void:
	var o: Oturum = ekran.get("oturum")
	if o == null:
		return
		
	var panel := PanelContainer.new()
	panel.name = "oda_es_paneli"
	panel.add_theme_stylebox_override("panel", Tema.koy_paneli())
	icerik.add_child(panel)
	
	var m := MarginContainer.new()
	for y in ["margin_left", "margin_right", "margin_top", "margin_bottom"]:
		m.add_theme_constant_override(y, 12)
	panel.add_child(m)
	
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 8)
	m.add_child(v)
	
	var baslik := Label.new()
	baslik.text = "Eşin Sedirde Dinleniyor"
	baslik.add_theme_font_size_override("font_size", 16)
	baslik.add_theme_color_override("font_color", Color("#e8b86d"))
	v.add_child(baslik)
	
	var aciklama := Label.new()
	aciklama.text = "Ocağın başına oturmuş, yün eğiriyor. Günün yorgunluğunu, kapı kararlarını ve köyün ahvalini seninle dertleşmek ister."
	aciklama.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	v.add_child(aciklama)
	
	var b := Button.new()
	b.name = "esle_dertles_butonu"
	b.text = "Eşinle Dertleş"
	b.custom_minimum_size.y = 38
	v.add_child(b)
	
	b.pressed.connect(func() -> void:
		var es_koylu: Koylu = null
		if o.yonetim:
			for k in o.yonetim.koylular:
				if k.bayrak_var(&"acl01_es") or k.ad.to_lower().contains("es"):
					es_koylu = k
					break
		if es_koylu == null:
			es_koylu = Koylu.new()
			es_koylu.ad = "Eş"
			es_koylu.bayrak_ekle(&"acl01_es")
			
		var y := KoyDiyalogYoneticisi.new()
		KoyDiyalogPaneli.ac(ekran, y)
		y.muhabbet_baslat(es_koylu, o.yonetim)
	)
