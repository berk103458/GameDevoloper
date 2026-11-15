extends Node

var _hata := 0


func _ready() -> void:
	get_tree().create_timer(45).timeout.connect(func() -> void: get_tree().quit(1))
	var ayarlar := Ayarlar.new("user://grv_zemin_kontrol.cfg")
	var kok := Control.new()
	kok.theme = Tema.olustur(ayarlar)
	kok.size = Vector2(1600, 900)
	add_child(kok)
	var ekran := AyarlarEkrani.new()
	ekran.ayarlar = ayarlar
	kok.add_child(ekran)
	await get_tree().process_frame
	await get_tree().process_frame
	var zemin := ekran.get_node_or_null("TemaZemini") as Panel
	_kontrol(zemin != null, "zemin tema Panel düğümüdür")
	if zemin != null:
		_kontrol(zemin.get_theme_stylebox("panel") == kok.theme.get_stylebox("panel", "Panel"), "zemin üst kabuğun tema kaynağını okur")
		_kontrol(not zemin.has_theme_stylebox_override("panel"), "yerel zemin stili yok")
		_kontrol(zemin.mouse_filter == Control.MOUSE_FILTER_IGNORE, "zemin girdiyi yutmaz")
		_kontrol(zemin.size.is_equal_approx(kok.size), "1600x900 tam zemin")
		kok.size = Vector2(1280, 720)
		await get_tree().process_frame
		_kontrol(zemin.size.is_equal_approx(kok.size), "1280x720 tam zemin")
	for cocuk in ekran.get_children():
		_kontrol(not cocuk is ColorRect, "ekran yerel ColorRect üretmez")
		if cocuk is MarginContainer:
			_kontrol(cocuk.get_theme_constant("margin_right") == cocuk.get_theme_constant("margin_left"), "eski sağ yarı boşluğu yok")
	kok.free()
	if _hata == 0:
		print("GRV-02 GEÇTİ")
	get_tree().quit(0 if _hata == 0 else 1)


func _kontrol(durum: bool, mesaj: String) -> void:
	if not durum:
		_hata += 1
		push_error("GRV-02 KALDI: " + mesaj)
