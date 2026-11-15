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
	var o: Oturum = ekran.get("oturum") as Oturum
	if o != null:
		var asker_var: bool = o.yonetim.etkin_muhafiz_sayisi() > 0 or o.yonetim.koylular.any(func(k: Koylu) -> bool: return k.sinif == &"asker" and k.saglik > 0)
		sorgu.zar_baglami = {
			"terazi": MuhafizTerazisi.durum(o),
			"itibar": o.grup_itibari.zar_etkisi(gelen.id),
			"asker": asker_var,
			"kanit": not sorgu.ipuclari.is_empty(),
		}
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
	panel.oturum = ekran.get("oturum") as Oturum
	panel.baglam = gelen.get_meta(&"zar06_baglam", {}).duplicate(true)
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
		var oturum := ekran.get("oturum") as Oturum
		preload("res://src/debug/ilk_saat_kancasi.gd").arac(oturum, "bakmak")
		MuhafizAdaletYetenekleri.chr_incele(oturum, panel)
		KapiGorusAdaptoru.bagla(panel, ekran)
		preload("res://src/kapi/hastalik_teshis_adaptoru.gd").chr_bagla(panel, ekran, gelen)
	)
	return dugme
