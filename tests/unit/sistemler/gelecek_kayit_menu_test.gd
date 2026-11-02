extends Node
class TestAna extends Ana:
	var menuye_dondu := false
	func _ready() -> void: pass
	func ana_menu() -> void: menuye_dondu = true
var hata := 0
func _ready() -> void: call_deferred("calistir")
func calistir() -> void:
	var a := TestAna.new()
	add_child(a)
	a.katalog = Katalog.new()
	a.katalog.yukle()
	var yol := "user://kalfa_kay02_menu_%d.json" % OS.get_process_id()
	a.kayit = GuvenliKayit.new(yol)
	var f := FileAccess.open(yol, FileAccess.WRITE)
	f.store_string(JSON.stringify({"surum":Oturum.KAYIT_SURUMU + 1, "ozel":"gelecek veri"}))
	f.close()
	var once := FileAccess.get_file_as_bytes(yol)
	a.devam_et()
	if not (a.menuye_dondu and a.oturum == null and FileAccess.get_file_as_bytes(yol) == once):
		hata += 1
		push_error("Gelecek kayıt gerçek Devam et yolunda açılmaz/ezilmez")
	a.kayit.sil()
	a.queue_free()
	await get_tree().process_frame
	print("GELECEK KAYIT MENÜ: GEÇTİ" if hata == 0 else "GELECEK KAYIT MENÜ: KALDI")
	get_tree().quit(hata)
