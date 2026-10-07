extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_flock.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 76)
		kayit = GuvenliKayit.new("user://test_flock_ui.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var y := ana.oturum.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y.kaynaklar.kapasite = 10000
	for t in ["odun", "gida"]: y.kaynaklar.ekle(t, 100)
	var b := _kur(y)
	kontrol(b != null, "Gerçek ağıl kurulur")
	if b == null:
		await Ses.cik(1)
		return
	var k := y.kabul({"sinif": "ciftci", "stat": 5})
	k.zanaat_turu = ZanaatTuru.Tur.COBAN
	kontrol(y.ata(k.id, b.id), "Gerçek çoban ataması")
	var once := JSON.stringify(ana.oturum.kaydet())
	ana._koye_git()
	await get_tree().process_frame
	var s: KoyYonetimSahnesi = ana._ekran.sahne3b
	var h := s.halk_hareketi
	h.set_process(false)
	h._process(0.0)
	var suru := CobanSurusu._bul(h, b.id)
	kontrol(suru != null and suru.koyunlar.size() == 4, "Dört koyunluk başlangıç sürüsü")
	suru.set_process(false)
	_bitir(h, k.id)
	for i in 200: suru._process(1.0)
	kontrol(not suru.kapali and suru.adimlar[0] >= suru.yollar[0].size(), "Gündüz sürü otlakta, kapı açık")
	h.yenile()
	h._process(0.0)
	kontrol(CobanSurusu._bul(h, b.id) == suru, "Yenileme aynı sürüyü korur")
	var adet := 0
	for n in h.get_children():
		if n is CobanSurusu and not n.is_queued_for_deletion(): adet += 1
	kontrol(adet == 1, "Çift sürü yok")
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name() != "headless":
		s.set_process(false)
		s.kamera.position = suru.koyunlar[0].global_position + Vector3(5, 4, 7)
		s.kamera.look_at(suru.koyunlar[0].global_position + Vector3(0, 0.6, 0))
		await get_tree().create_timer(0.4).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("ani05_otlak.png"))
	var gate := b.hucre + Vector2i(b.boyut(y.katalog).x / 2, b.boyut(y.katalog).y)
	y.izgara.engeller[gate] = true
	h.yenile()
	s.faz(&"aksam", 0.0)
	h._process(0.0)
	var suru_once := suru.koyunlar[0].global_position
	for i in 20: suru._process(1.0)
	kontrol(not suru.kapali and suru.koyunlar[0].global_position == suru_once, "Kapalı dönüşte sürü çitten kestirme yapmaz")
	y.izgara.engeller.erase(gate)
	h.yenile()
	s.faz(&"aksam", 0.0)
	h._process(0.0)
	kontrol(not suru.kapali, "Dönüş başında kapı erken kapanmaz")
	_bitir(h, k.id)
	for i in 200: suru._process(1.0)
	kontrol(suru.kapali, "Sürü ağıla varınca kapı kapanır")
	var kapilar := s._yapilar.find_children("agil_kapisi", "", true, false)
	kontrol(not kapilar.is_empty(), "Gerçek kapı düğümü vardır")
	for kap in kapilar: kontrol(absf(kap.rotation.y) < 0.001, "Gerçek kapı dönüşü kapanır")
	var merkez := s.alan_merkezi(b.hucre, b.boyut(y.katalog))
	for n in suru.koyunlar: kontrol(n.global_position.distance_to(merkez) < 2.0, "Akşam koyunlar ağılda")
	kontrol(JSON.stringify(ana.oturum.kaydet()) == once, "Otlatma üretim/kayıt/RNG değiştirmez")
	var u := {}
	var olaylar: Array[Dictionary] = []
	y._uret(u, olaylar)
	kontrol(int(u.get("gida", 0)) >= 1, "Ağıl gerçek mevcut gece üretimine bağlı")
	var geri := KoyYonetimi.kayittan(y.a, y.katalog, JSON.parse_string(JSON.stringify(y.kaydet())))
	kontrol(geri.bina(b.id).tur == "agil" and geri.bina(b.id).hazir() and geri.koylu(k.id).is_yeri == b.id, "Ağıl/çoban kayıt dönüşümü")
	y.bosalt(k.id)
	h.yenile()
	await get_tree().process_frame
	var bos := CobanSurusu._bul(h, b.id)
	kontrol(bos != null and bos.coban_id == -1 and bos.koyunlar.size() == 4, "Çobansız sürü ağılda korunur")
	y.binalar.erase(b)
	h.yenile()
	await get_tree().process_frame
	kontrol(CobanSurusu._bul(h, b.id) == null, "Yıkılan ağılda görsel kalmaz")
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("ÇOBAN SÜRÜSÜ UI: GEÇTİ" if hata == 0 else "ÇOBAN SÜRÜSÜ UI: KALDI")
	await Ses.cik(hata)
func _bitir(h: KoyHalkHareketi, id: int) -> void:
	var d: Dictionary = h._durum[id]
	var f: KarakterModel = h.modeller[id]
	while int(d.adim) < d.yol.size():
		f.position = d.yol[d.adim]
		h._process(0.0)
	f.yurumeyi_durdur()
func _kur(y: KoyYonetimi) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim("agil", h).olur:
				var b := y.bina(y.bina_kur("agil", h).id)
				if b == null: return null
				b.insa_kalan = 0
				return b
	return null
func kontrol(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
