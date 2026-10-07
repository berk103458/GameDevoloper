extends Node

class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_admin_kaynak.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 47)
		kayit = GuvenliKayit.new("user://test_admin_kaynak.json")
		theme = Tema.olustur(ayarlar)

var hata := 0
func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	ana.oturum.yonetim.kabul({"ad": "Test", "sinif": "ciftci"})
	ana._koye_git()
	var admin := AdminHud.new()
	admin.baglam = ana
	ana.add_child(admin)
	admin.ac(true)
	var p := admin.kaynak_paneli
	var gun := ana.oturum.gun
	for i in p.ALANLAR.size():
		p.secim.select(i)
		p.miktar.value = 3
		p.miktar.get_line_edit().text = "3"
		p.yenile()
		_kontrol(not p.uygula.disabled, "Köyde gerçek kaynak düğmesi açık")
		p.uygula.pressed.emit()
		var geri := Oturum.kayittan(ana.katalog, ana.kayit.oku())
		var alan: String = p.ALANLAR[i]
		var beklenen: int
		var yuklenen: int
		if alan in StatEnjektoru.ALANLAR:
			beklenen = StatEnjektoru.oku(ana.oturum, alan)
			yuklenen = StatEnjektoru.oku(geri, alan)
		elif alan in ["koy_akce", "muhafiz_akce"]:
			beklenen = int(ana.oturum.get(alan))
			yuklenen = int(geri.get(alan))
		else:
			beklenen = ana.oturum.yonetim.kaynaklar.miktar(alan)
			yuklenen = geri.yonetim.kaynaklar.miktar(alan)
		_kontrol(yuklenen == beklenen and geri.gun == gun, "UI değişikliği güvenli test slotunda korunur")
	p.secim.select(1)
	p.miktar.get_line_edit().text = "-999"
	p.uygula.pressed.emit()
	_kontrol(ana.oturum.muhafiz_akce == 0 and p.mevcut.text == "Mevcut: 0", "Yazılmış SpinBox girdisi düğmede uygulanır; gösterge canlı yenilenir")
	_kontrol(ana.oturum.gun == gun and not get_tree().paused, "Kaynak kontrolü geceyi çalıştırmaz veya oyunu durdurmaz")
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name() != "headless":
		await get_tree().create_timer(0.5).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("adm04_kaynak.png"))
	ana._ekran._geceye_gec()
	p.yenile()
	var once := JSON.stringify(ana.oturum.kaydet())
	_kontrol(p.uygula.disabled, "Gece raporu açıkken enjektör kilitli")
	p.uygula.pressed.emit()
	_kontrol(JSON.stringify(ana.oturum.kaydet()) == once, "Doğrudan sinyal kilidi aşamaz")
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("ADMIN KAYNAK: GEÇTİ" if hata == 0 else "ADMIN KAYNAK: KALDI")
	Ses.cik(hata)

func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
