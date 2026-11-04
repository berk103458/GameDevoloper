extends SceneTree

const Gorunum = preload("res://src/arayuz/defter_gorunumu.gd")


func _init() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	if FileAccess.file_exists(Gorunum.KAYIT):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(Gorunum.KAYIT))
	var hata := 0
	var ekran := HafizaDefteriEkrani.new()
	ekran.ayarlar = Ayarlar.new("user://defter_aday_test.cfg")
	root.add_child(ekran)
	await process_frame
	var satir := ekran.find_child("defter_adaylari", true, false)
	if satir == null or satir.get_child_count() != 3:
		hata += 1
		push_error("üç defter adayı yok")
	var zemin: PanelContainer = null
	for cocuk in ekran.get_children():
		if cocuk is PanelContainer:
			zemin = cocuk
			break
	if zemin == null or not (zemin.get_theme_stylebox("panel") is StyleBoxTexture):
		hata += 1
		push_error("seçili sayfa zeminde görünmüyor")
	Gorunum.sec(ekran, "lif")
	if Gorunum.secili_id() != "lif" or String(zemin.get_meta(&"defter_aday", "")) != "lif":
		hata += 1
		push_error("lif seçilemedi")
	var acik := satir.get_node_or_null("defter_aday_acik_kitap") as Button
	if acik != null:
		acik.pressed.emit()
	if Gorunum.secili_id() != "acik_kitap":
		hata += 1
		push_error("açık kitap düğmesi seçimi yazmadı")
	ekran.free()
	if FileAccess.file_exists(Gorunum.KAYIT):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(Gorunum.KAYIT))
	print("DEFTER ADAY: %s" % ("GEÇTİ" if hata == 0 else "KALDI"))
	quit(hata)
