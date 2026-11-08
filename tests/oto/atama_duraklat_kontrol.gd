extends Node
class TestAna extends Ana:
	func _ready() -> void:
		ayarlar = Ayarlar.new("user://unused_isg32.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 3232)
		kayit = GuvenliKayit.new("user://isg32_test.json")
		theme = Tema.olustur(ayarlar)

var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)

func _ready() -> void:
	call_deferred("_calistir")

func _calistir() -> void:
	get_tree().create_timer(45.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var y := ana.oturum.yonetim
	var b := KoyBinasi.new()
	b.id = 77
	b.tur = "odunluk"
	b.hucre = Vector2i(2, 2)
	y.binalar.append(b)
	var k := y.kabul({"ad": "Atama işçisi"})
	ana._koye_git()
	await get_tree().process_frame
	var ekran := ana._ekran as KoyEkrani
	KoyluKarti.ac(ekran, k.id)
	ana._duraklat()
	await get_tree().process_frame
	var once := y.kaydet()
	var veri := {"tur": "koylu_atama", "kisi": k.id, "oturum": ana.oturum.get_instance_id()}
	dene(not ekran._atama_alani.veri_gecerli(veri), "Duraklatta sürükleme kabulü kapalı")
	ekran._atama_alani._drop_data(Vector2.ZERO, veri)
	for dugme in ekran._ust_kart.find_children("*", "Button", true, false):
		if dugme.has_meta("hedef") or dugme.has_meta("gecici_is"): dugme.pressed.emit()
	KoyluKarti._ata(ekran, k.id, b.id)
	dene(y.kaydet() == once, "Duraklat menüsünde bina ataması delta0")
	KoyGeciciIslerPaneli.ata(ekran, k.id, "dal_toplama")
	dene(y.kaydet() == once, "Duraklat menüsünde geçici iş delta0")
	ana._ust_kapat()
	await get_tree().process_frame
	y.bosalt(k.id)
	ekran._hiz_sec(0)
	once = y.kaydet()
	KoyluKarti._ata(ekran, k.id, b.id)
	KoyGeciciIslerPaneli.ata(ekran, k.id, "dal_toplama")
	dene(y.kaydet() == once, "Sıfır hızda atamalar delta0")
	ekran._hiz_sec(1)
	KoyluKarti._ata(ekran, k.id, b.id)
	dene(k.is_yeri == b.id, "Devamdan sonra normal bina ataması çalışır")
	y.bosalt(k.id)
	KoyGeciciIslerPaneli.ata(ekran, k.id, "dal_toplama")
	dene(GeciciIsler.secili(k) == "dal_toplama", "Devamdan sonra geçici iş çalışır")
	ana.queue_free()
	await get_tree().process_frame
	print("ATAMA DURAKLAT: GEÇTİ" if hata == 0 else "ATAMA DURAKLAT: KALDI")
	await Ses.cik(hata)
