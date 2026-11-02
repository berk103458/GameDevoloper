extends Node
class TestAna extends Ana:
	var menuye_dondu := false
	func _ready() -> void: pass
	func ana_menu() -> void: menuye_dondu = true
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func _ready() -> void: call_deferred("calistir")
func calistir() -> void:
	var a := TestAna.new()
	add_child(a)
	a.ayarlar = Ayarlar.new()
	a.katalog = Katalog.new()
	a.katalog.yukle()
	var yol := "user://kalfa_kay55_menu_%d.json" % OS.get_process_id()
	a.kayit = GuvenliKayit.new(yol)
	var eski := Oturum.new(a.katalog, 3155).kaydet()
	eski.surum = 2
	eski.muhafiz_akce = "bozuk"
	var yedek := eski.duplicate(true)
	yedek.muhafiz_akce = 17
	var baytlar := {}
	for ek in ["", ".bak", ".bak.tmp"]:
		var f := FileAccess.open(yol + ek, FileAccess.WRITE)
		f.store_string(JSON.stringify(eski if ek == "" else yedek))
		f.close()
		baytlar[ek] = FileAccess.get_file_as_bytes(yol + ek)
	a.devam_et()
	await get_tree().process_frame
	var ekran := a._ekran as BilgiEkrani
	dene(ekran != null and ekran.baslik == "Kayıt açılamadı", "Oyuncu gerçek Devam et yolunda hata görür")
	dene(a.oturum == null and not a.menuye_dondu, "Yeni oyun kurulmaz, hata ekranı atlanmaz")
	for ek in baytlar:
		dene(FileAccess.get_file_as_bytes(yol + ek) == baytlar[ek], "Başarısız göç ana/yedek baytlarını değiştirmez: " + ek)
	var ana: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(yol))
	dene(int(ana.surum) == 2 and ana.muhafiz_akce == "bozuk", "Ana dosya göç öncesi sürümde kaldı")
	dene(not FileAccess.file_exists(yol + ".tmp"), "Başarısız göç yeni ana/tmp yazmadı")
	if ekran != null:
		dene(ekran.dugmeler == PackedStringArray(["Ana menüye dön"]), "Yeni oyuna zorlayan düğme yok")
		ekran.secildi.emit(0)
		dene(a.menuye_dondu, "Oyuncu ana menüye dönebilir")
	a.kayit.sil()
	a.queue_free()
	await get_tree().process_frame
	print("BAŞARISIZ GÖÇ MENÜ: GEÇTİ" if hata == 0 else "BAŞARISIZ GÖÇ MENÜ: KALDI")
	await Ses.cik(hata)
