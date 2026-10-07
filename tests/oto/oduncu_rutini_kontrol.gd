extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_wood.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 76)
		kayit = GuvenliKayit.new("user://test_wood_ui.json")
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
	y.akce = 1000
	for t in ["odun", "tas", "kereste", "alet"]: y.kaynaklar.ekle(t, 100)
	var kamp := _kur(y, "odunluk")
	kontrol(kamp != null and _kur(y, "hizarhane") != null and _kur(y, "ahir") != null, "Gerçek kamp/hızar/ahır")
	if kamp == null:
		await Ses.cik(1)
		return
	for i in 2:
		var k := y.kabul({"sinif": "ciftci", "stat": 5})
		kontrol(y.ata(k.id, kamp.id), "Oduncu ataması")
	y.lojistik.hayvanlar.okuz = 1
	var once := JSON.stringify(ana.oturum.kaydet())
	ana._koye_git()
	await get_tree().process_frame
	var s: KoyYonetimSahnesi = ana._ekran.sahne3b
	var h := s.halk_hareketi
	h.set_process(false)
	h._process(0.0)
	var f: KarakterModel = h.modeller[y.koylular[0].id]
	var e := f.get_node_or_null("oduncu_rutini") as OduncuRutini
	kontrol(e != null and e.balta != null, "Gerçek el kemiğinde balta")
	var once_konum := f.position
	await get_tree().create_timer(0.5).timeout
	kontrol(f.position.distance_to(once_konum) > 0.01, "Oduncu gerçek rotada yürür")
	for i in 3:
		var d: Dictionary = h._durum[y.koylular[0].id]
		kontrol(d.oduncu and d.oduncu_i == i, "Orman, hızar, kamp sırası")
		kontrol(e.balta.visible == (i == 0) and e.yuk.visible == (i == 1), "Balta ve tomruk yükü aşamaya uyar")
		var v := 0
		for model in h.modeller.values():
			var o := model.get_node_or_null("oduncu_rutini") as OduncuRutini
			if o != null and o.okuz != null and o.okuz.visible: v += 1
		kontrol(v <= 1, "Bir kayıtlı öküz çoğaltılmaz")
		while int(d.adim) < d.yol.size():
			f.position = d.yol[d.adim]
			h._process(0.0)
		f.yurumeyi_durdur()
		kontrol(e._kesiyor == (i == 0), "Balta yalnız orman varışında sallanır")
		var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
		if i == 1 and not dizin.is_empty() and DisplayServer.get_name() != "headless":
			s.set_process(false)
			s.kamera.position = f.position + Vector3(5, 3.5, 6)
			s.kamera.look_at(f.position + Vector3(0, 0.8, 0))
			await get_tree().create_timer(0.4).timeout
			await RenderingServer.frame_post_draw
			get_viewport().get_texture().get_image().save_png(dizin.path_join("ani04_tomruk.png"))
		h._process(float(OduncuRutini.AYAR.sureler[i]) + 0.1)
		h._process(0.0)
	kontrol(JSON.stringify(ana.oturum.kaydet()) == once, "Görsel taşıma gerçek lojistiği/stoğu/RNG değiştirmez")
	y.lojistik.hayvanlar.okuz = 0
	h.yenile()
	h._process(0.0)
	h._durum[y.koylular[0].id].oduncu_i = 1
	h._iste(y.koylular[0].id)
	h._process(0.0)
	kontrol(not e.okuz.visible and e.elle.visible, "Öküz yoksa elle taşıma")
	s.faz(&"gece", 0.0)
	h._process(0.0)
	await get_tree().process_frame
	kontrol(f.get_node_or_null("oduncu_rutini") == null, "Gece araçlar temizlenir")
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("ODUNCU RUTİNİ UI: GEÇTİ" if hata == 0 else "ODUNCU RUTİNİ UI: KALDI")
	await Ses.cik(hata)
func _kur(y: KoyYonetimi, tur: String) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim(tur, h).olur:
				var b := y.bina(y.bina_kur(tur, h).id)
				if b == null: return null
				b.insa_kalan = 0
				return b
	return null
func kontrol(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
