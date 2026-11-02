## Kapı ekranına eklenen küçük bağlantı; JSON ve eski heybe akışı korunur.
extends RefCounted

static func karar_kilidi(dugme: MenuSatiri, sorgu: RefCounted, karar: StringName) -> void:
	if sorgu == null:
		return
	dugme.disabled = not sorgu.karar_acik(karar)
	if dugme.disabled:
		dugme.alt_yazi = "Panik: barışçıl kabul kapalı"
		dugme.tooltip_text = dugme.alt_yazi

static func diyalog_goster(ekran: Control, gelen: Gelen, secenekler: VBoxContainer, eylemler: VBoxContainer) -> bool:
	var sorgu := gelen.chr_sorgusu()
	if sorgu == null:
		return false
	sorgu.tecrube = MuhafizOdaGelisimi.etkin_tecrube(ekran.oturum)
	preload("res://src/soz/muhafiz_sezgisi.gd").goster(ekran, gelen)
	ekran.call("_chr_tansiyon_degisti", sorgu.tansiyon)
	var animasyon := Callable(ekran, "_chr_tansiyon_degisti")
	if not sorgu.tansiyon_degisti.is_connected(animasyon):
		sorgu.tansiyon_degisti.connect(animasyon)
	var konusma := Callable(ekran, "_chr_replik_basladi")
	if not sorgu.replik_basladi.is_connected(konusma):
		sorgu.replik_basladi.connect(konusma)
	var panel := preload("res://src/arayuz/chr_diyalog_paneli.gd").new()
	panel.sorgu = sorgu
	panel.karar_istendi.connect(Callable(ekran, "_karar_goster"))
	secenekler.add_child(panel)
	inceleme_dugmesi(ekran, gelen, eylemler)
	return true

static func inceleme_dugmesi(ekran: Control, gelen: Gelen, eylemler: VBoxContainer) -> Button:
	var sorgu := gelen.chr_sorgusu()
	if sorgu == null:
		return null
	var dugme := Button.new()
	dugme.text = "Nişan ve yükü incele"
	dugme.custom_minimum_size.y = 64
	eylemler.add_child(dugme)
	dugme.pressed.connect(func() -> void:
		if ekran.has_node("ChrInceleme"):
			return
		var panel := preload("res://src/arayuz/chr_inceleme_paneli.gd").new()
		panel.name = "ChrInceleme"
		panel.sorgu = sorgu
		ekran.add_child(panel)
		MuhafizAdaletYetenekleri.chr_incele(ekran.get("oturum") as Oturum, panel)
		KapiGorusAdaptoru.bagla(panel, ekran)
		preload("res://src/kapi/hastalik_teshis_adaptoru.gd").chr_bagla(panel, ekran, gelen)
	)
	return dugme
