## TEK-18 negatif fikstür: yalnız ayrı pid adlı test dosyası; normal ayarlar.cfg yazılmaz.
extends Node

class MenuAna extends Ana:
	var test_yolu: String
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		TranslationServer.set_locale("tr")
		GuvenliMetin.kur()
		ayarlar = Ayarlar.new(test_yolu)
		ayarlar.yukle()
		katalog = Katalog.new()
		if katalog.yukle() != Katalog.Durum.HAZIR:
			return
		kayit = GuvenliKayit.new(test_yolu + ".save")
		theme = Tema.olustur(ayarlar)
		ana_menu()

func _ready() -> void:
	call_deferred("_kos")

func _kos() -> void:
	var yol := "user://tek18_%d_%d.cfg" % [OS.get_process_id(), Time.get_ticks_usec()]
	var f := FileAccess.open(yol, FileAccess.WRITE)
	if f == null:
		print("TEK18 FİKSTÜR DOSYASI: KALDI")
		get_tree().quit(1)
		return
	f.store_string("[ayarlar\nses_ana = ???\n")
	f.close()
	var ana := MenuAna.new()
	ana.test_yolu = yol
	add_child(ana)
	await get_tree().process_frame
	await get_tree().create_timer(1.2).timeout
	var olur := ana.ayarlar.degerler == Ayarlar.VARSAYILAN
	olur = olur and ana._ekran is MenuEkrani and ana._ekran.is_visible_in_tree()
	olur = olur and ana.katalog.hatalar.is_empty()
	var dugmeler := ana._ekran.find_children("*", "Button", true, false)
	olur = olur and not dugmeler.is_empty()
	var acik := false
	for b in dugmeler:
		if not b.disabled and b.is_visible_in_tree(): acik = true
	olur = olur and acik
	print("TEK18 VARSAYILAN VE GERÇEK MENÜ: GEÇTİ" if olur else "TEK18 VARSAYILAN VE GERÇEK MENÜ: KALDI")
	DirAccess.remove_absolute(yol)
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().root.get_node("Ses").sustur()
	get_tree().quit(0 if olur else 1)
