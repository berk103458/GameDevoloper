## TEK-25 negatif fikstür: yarı yazılmış kayıt dosyasında gerçek Ana.devam_et.
## Yalnız ayrı pid adlı test dosyası yazılır; gerçek kayıt yuvasına dokunulmaz.
extends Node

class MenuAna extends Ana:
	var test_yolu: String

	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		TranslationServer.set_locale("tr")
		GuvenliMetin.kur()
		ayarlar = Ayarlar.new(test_yolu + ".cfg")
		katalog = Katalog.new()
		if katalog.yukle() != Katalog.Durum.HAZIR:
			return
		kayit = GuvenliKayit.new(test_yolu)
		theme = Tema.olustur(ayarlar)


func _ready() -> void:
	call_deferred("_kos")


func _kos() -> void:
	var yol := "user://tek25_%d_%d.json" % [OS.get_process_id(), Time.get_ticks_usec()]
	var yaz := FileAccess.open(yol, FileAccess.WRITE)
	yaz.store_string('{"surum": 3, "tohum": "5", "koy_yone')
	yaz.close()
	var baytlar := FileAccess.get_file_as_bytes(yol)
	var ana := MenuAna.new()
	ana.test_yolu = yol
	add_child(ana)
	await get_tree().process_frame
	# Yarım yazılmış dosyada "Devam" hata ekranını açar, oturum kurmaz.
	ana.devam_et()
	await get_tree().process_frame
	await get_tree().process_frame
	var hata_ekrani := ana._ekran as BilgiEkrani
	var olur := ana.oturum == null and hata_ekrani != null
	if olur:
		olur = hata_ekrani.baslik == "Kayıt açılamadı" and hata_ekrani.dugmeler == PackedStringArray(["Ana menüye dön"])
		hata_ekrani.secildi.emit(0)
		await get_tree().process_frame
		olur = olur and ana._ekran is MenuEkrani
	if olur:
		var devam := ana._ekran.find_children("*", "Button", true, false).filter(
			func(b: Node) -> bool: return (b as Button).text == tr("arayuz.menu.devam"))
		olur = devam.size() == 1 and not (devam[0] as Button).disabled
	olur = olur and FileAccess.get_file_as_bytes(yol) == baytlar
	print("TEK25 KESİK KAYIT MENÜSÜ: GEÇTİ" if olur else "TEK25 KESİK KAYIT MENÜSÜ: KALDI")
	DirAccess.remove_absolute(ProjectSettings.globalize_path(yol))
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().root.get_node("Ses").sustur()
	get_tree().quit(0 if olur else 1)