extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_yas.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 89)
		kayit = GuvenliKayit.new("user://test_yas.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var y := ana.oturum.yonetim
	y.akce = 100
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y.kaynaklar.kapasite = 10000
	for tur in ["gida", "odun", "tas", "kereste"]: y.kaynaklar.ekle(tur, 100)
	var m: KoyBinasi
	for cy in y.a.izgara_boyut.y:
		if m != null: break
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim("degirmen", h)["olur"]:
				m = y.bina(y.bina_kur("degirmen", h)["id"])
				m.insa_kalan = 0
				break
	var isci := y.kabul({"ad": "Latif", "adli_id": "chr_030", "sinif": "esnaf", "stat": 5})
	var usta := y.kabul({"ad": "Osman Dayı", "adli_id": "chr_013", "sinif": "ciftci", "stat": 5})
	var cocuk := y.kabul({"ad": "Seyit", "adli_id": "chr_006", "sinif": "ciftci", "stat": 5})
	for k in y.koylular: k.moral = 50
	_kontrol(y.ata(isci.id, m.id) and y.ata(usta.id, m.id) and not y.ata(cocuk.id, m.id), "Gerçek değirmen ataması; çocuk ağır işte yok")
	var rapor := y.gece()
	_kontrol(int(rapor["uretim"]["gida"]) == 5, "Gerçek gece danışmanlı öğütme üretir")
	ana._koye_git()
	var admin := AdminHud.new()
	admin.baglam = ana
	ana.add_child(admin)
	admin.ac(true)
	admin.koylu_paneli.ac(true)
	var tablo := admin.koylu_paneli.tablo
	var satir := tablo.get_root().get_first_child()
	_kontrol(satir.get_text(5).contains("5.52"), "Canlı üretici önizlemesi %15 danışman bonusunu içerir")
	satir = satir.get_next()
	_kontrol(satir.get_text(6).contains("Danışman") and satir.get_tooltip_text(3).contains("Yaşlı"), "Canlı yaşlı danışman rolü ve kendi üretiminin yokluğu")
	_kontrol(MeslekYapilari.ad("degirmen") == "Değirmen" and MeslekYapilari.aciklama("degirmen").contains("%15"), "Normal yapı adı ve açıklaması okunur")
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name() != "headless":
		await get_tree().create_timer(0.5).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("uzm08_yas.png"))
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("YAŞ UI: GEÇTİ" if hata == 0 else "YAŞ UI: KALDI")
	await Ses.cik(hata)
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
