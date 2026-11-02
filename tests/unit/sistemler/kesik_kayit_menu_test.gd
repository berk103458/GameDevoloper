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
	var yol := "user://kalfa_kay64_menu_%d.json" % OS.get_process_id()
	a.kayit = GuvenliKayit.new(yol)
	var f := FileAccess.open(yol, FileAccess.WRITE)
	f.store_string('{"surum":3,"koy_yonetimi":')
	f.close()
	var once := FileAccess.get_file_as_bytes(yol)
	a.devam_et()
	await get_tree().process_frame
	var ekran := a._ekran as BilgiEkrani
	dene(ekran != null and ekran.baslik == "Kayıt açılamadı", "Oyuncu gerçek Devam et yolunda hata görür")
	dene(a.oturum == null and not a.menuye_dondu, "Yeni oyun kurulmaz, hata ekranı atlanmaz")
	dene(FileAccess.get_file_as_bytes(yol) == once, "Kesik dosya korunur")
	if ekran != null:
		dene(ekran.dugmeler == PackedStringArray(["Ana menüye dön"]), "Yeni oyuna zorlayan düğme yok")
		ekran.secildi.emit(0)
		dene(a.menuye_dondu, "Oyuncu ana menüye dönebilir")
	a.kayit.sil()
	a.queue_free()
	await get_tree().process_frame
	print("KESİK KAYIT MENÜ: GEÇTİ" if hata == 0 else "KESİK KAYIT MENÜ: KALDI")
	await Ses.cik(hata)
