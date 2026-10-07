extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_admin_koylu.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 88)
		kayit = GuvenliKayit.new("user://test_admin_koylu.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var k := ana.oturum.yonetim.kabul({"ad": "Test çiftçi", "sinif": "ciftci", "stat": 5})
	ana.oturum.yonetim.kabul({"ad": "Boşta köylü", "sinif": "esnaf"})
	var y := ana.oturum.yonetim
	var bina: KoyBinasi
	for cy in y.a.izgara_boyut.y:
		if bina != null: break
		for cx in y.a.izgara_boyut.x:
			var hucre := Vector2i(cx, cy)
			if y.yerlesim("tarla", hucre)["olur"]:
				bina = y.bina(y.bina_kur("tarla", hucre)["id"])
				bina.insa_kalan = 0
				bina.seviye = 2
				y.ata(k.id, bina.id)
				break
	k.moral = 50
	ana._koye_git()
	var admin := AdminHud.new()
	admin.baglam = ana
	ana.add_child(admin)
	admin.ac(true)
	var p := admin.koylu_paneli
	_kontrol(not p.visible and not p.is_processing(), "Kapalı denetçi işlemez")
	var once := ana.oturum.kaydet()
	var kayit := FileAccess.get_file_as_string(ana.kayit.yol)
	p.ac(true)
	_kontrol(p.satirlar.size() == 2 and p.tablo.get_root().get_child_count() == 2, "Gerçek Tree tablo tüm gerçek köylüleri gösterir")
	_kontrol(p.tablo.get_root().get_first_child().get_text(3).contains("Çiftçi") and k.stat == 5, "Meslek ve sayısal beceri gerçek tabloda birlikte gösterilir")
	_kontrol(not p.tablo.get_root().get_first_child().get_text(7).is_empty() and not p.tablo.get_root().get_first_child().get_text(8).is_empty(), "Güçlü ve zayıf yön ayrı gerçek tablo sütunlarında")
	var h: KoyHalkHareketi = ana._ekran.sahne3b.halk_hareketi
	h.set_process(false)
	h._bekleyen.clear()
	h._durum[k.id] = {"yol": [Vector3.ZERO], "adim": 0, "dinlen": false, "is": false}
	p.yenile()
	_kontrol(p.satirlar[0]["eylem"] == "Yürüyor", "Denetçi gerçek hareket rutininin yürüyüşünü okur")
	h.faz_adi = &"gunduz"
	h._durum[k.id] = {"yol": [], "adim": 0, "dinlen": true, "is": false}
	p.yenile()
	_kontrol(p.satirlar[0]["eylem"] == "Dinleniyor", "Canlı dinlenme durumunu okur")
	h._durum[k.id].dinlen = false
	h._durum[k.id].is = true
	p.yenile()
	_kontrol(p.satirlar[0]["eylem"] == "Çalışıyor", "Canlı çalışma durumunu okur")
	_kontrol(ana.oturum.kaydet() == once and FileAccess.get_file_as_string(ana.kayit.yol) == kayit and not get_tree().paused, "Tablo modeli/kaydı değiştirmez veya oyunu durdurmaz")
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y._ambar_kapasitesi()
	for tur in ["gida", "odun"]: y.kaynaklar.ekle(tur, 200)
	var usta := y.kabul({"ad": "Osman Dayı", "adli_id": "chr_013", "sinif": "ciftci", "stat": 5})
	y.ata(usta.id, bina.id)
	k.stat = 3
	usta.moral = 80
	k.moral = 80
	for gece in 5: y.gece()
	p.yenile()
	_kontrol(k.stat == 6 and p.tablo.get_root().get_first_child().get_tooltip_text(3).contains("Yarı usta"), "Beş gerçek gecenin eğitim sonucu canlı Tree ipucunda gösterilir")
	k.zanaat_turu = ZanaatTuru.Tur.ASKER
	k.saglik = 100
	y.kaynaklar.stok["alet"] = 0
	var zar := RandomNumberGenerator.new()
	var kaza_tohumu := 1
	while true:
		zar.seed = kaza_tohumu
		if zar.randf() < IsKazalari.YARALANMA_RISKI: break
		kaza_tohumu += 1
	y._rng.seed = kaza_tohumu
	y.gece()
	p.yenile()
	_kontrol(k.saglik == 80 and p.tablo.get_root().get_first_child().get_tooltip_text(6).contains("yaralandı"), "Gerçek iş kazası canlı denetçi ipucuna ve sağlık modeline yansır")
	k.is_kazasi.clear()
	k.bayraklar.erase("agir_yarali")
	k.moral = 0
	var memnuniyet_once := ana.oturum.kaydet()
	p.yenile()
	_kontrol(p.tablo.get_root().get_first_child().get_text(6).contains("Kişisel isyan") and p.tablo.get_root().get_first_child().get_tooltip_text(2).contains("işi reddediyor"), "Canlı tablo kişisel iş reddi ve eşik bilgisini gösterir")
	_kontrol(ana.oturum.kaydet() == memnuniyet_once, "Memnuniyet ipucu model veya RNG değiştirmez")
	k.moral = 80
	k.toplumsal_bag = KanDavasi.kaynak(&"chr_005")
	var divan := y.kabul({"ad": "Şemsettin", "adli_id": "chr_007", "sinif": "asker", "stat": 5})
	divan.moral = 80
	_kontrol(y.ata(divan.id, bina.id), "Divan görevlisi gerçek üçüncü iş yuvasında")
	y._rng.seed = kaza_tohumu
	var kavga := y.gece()
	p.yenile()
	_kontrol(kavga["uretim"].is_empty() and p.tablo.get_root().get_first_child().get_text(6).contains("Kan davası"), "Gerçek kavga gecesinin üretim duruşu canlı tabloda")
	_kontrol(p.tablo.get_root().get_first_child().get_tooltip_text(2).contains("Karaboran"), "İlişki grubu canlı ipucunda")
	var ekran := ana._ekran as KoyEkrani
	ekran._secili_bina = bina.id
	ekran._bilgi_goster()
	_kontrol(ekran._bilgi_icerik.get_children().any(func(n: Node) -> bool: return not n.is_queued_for_deletion() and n is Label and n.text == KanDavasi.DURUS_METNI), "Normal bina bilgi paneli çözümüyle birlikte kan davasını gösterir")
	y.bosalt(divan.id)
	ekran._bilgi_goster()
	_kontrol(not ekran._bilgi_icerik.get_children().any(func(n: Node) -> bool: return not n.is_queued_for_deletion() and n is Label and n.text.contains("Kan davası")), "Ayırınca eski bekliyor alanı oyuncuya yanlış duruş göstermez")
	y.ata(divan.id, bina.id)
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name() != "headless":
		await get_tree().create_timer(0.5).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("adm13_koylu.png"))
	admin.ac(false)
	_kontrol(not p.visible and not p.is_processing(), "Konsolla tablo kapanır ve işlemez")
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("ADMIN KÖYLÜ: GEÇTİ" if hata == 0 else "ADMIN KÖYLÜ: KALDI")
	await Ses.cik(hata)
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
