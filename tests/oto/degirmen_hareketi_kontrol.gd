extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_mill.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 76)
		kayit = GuvenliKayit.new("user://test_mill_ui.json")
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
	for t in ["odun", "bugday"]: y.kaynaklar.ekle(t, 100)
	var b := _kur(y)
	kontrol(b != null, "Gerçek değirmen")
	if b == null:
		await Ses.cik(1)
		return
	var k := y.kabul({"sinif": "ciftci", "stat": 5})
	k.zanaat_turu = ZanaatTuru.Tur.DEGIRMENCI
	kontrol(y.ata(k.id, b.id) and y.recete_sec(b.id, "un"), "Gerçek değirmenci/un ataması")
	var once := JSON.stringify(ana.oturum.kaydet())
	ana._koye_git()
	await get_tree().process_frame
	var s: KoyYonetimSahnesi = ana._ekran.sahne3b
	var h := s.halk_hareketi
	h.set_process(false)
	h._process(0.0)
	var wheel: DegirmenHareketi
	for n in s._yapilar.get_children():
		if int(n.get_meta("bina_id", -1)) == b.id and not n.is_queued_for_deletion():
			for c in n.get_children():
				if c is DegirmenHareketi: wheel = c
	kontrol(wheel != null and wheel.teker != null, "Gerçek çark/sundurma modeli")
	var aci := wheel.teker.rotation.z
	wheel._process(0.5)
	kontrol(wheel.teker.rotation.z != aci, "Çalışan ve girdili değirmende çark döner")
	var miktar := y.kaynaklar.miktar("bugday")
	y.kaynaklar.harca({"bugday": miktar})
	aci = wheel.teker.rotation.z
	wheel._process(0.5)
	kontrol(wheel.teker.rotation.z == aci, "Girdi biterse çark durur")
	y.kaynaklar.ekle("bugday", miktar)
	var f: KarakterModel = h.modeller[k.id]
	var e := f.get_node_or_null("degirmen_cuvali") as DegirmenHareketi
	kontrol(e != null and e.cuval != null, "Gerçek el kemiğinde çuval")
	for i in 3:
		var d: Dictionary = h._durum[k.id]
		kontrol(d.degirmenci and d.degirmenci_i == i and e.cuval.visible == (i == 1), "İş, çuval, dinlenme sırası")
		while int(d.adim) < d.yol.size():
			f.position = d.yol[d.adim]
			h._process(0.0)
		f.yurumeyi_durdur()
		if i == 1:
			kontrol(f.position.distance_to(h._konum(b.hucre + Vector2i(b.boyut(y.katalog).x - 1, b.boyut(y.katalog).y))) < s.HUCRE / 2, "Çuval sundurmanın erişilebilir ön durağına gelir")
		var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
		if i == 1 and not dizin.is_empty() and DisplayServer.get_name() != "headless":
			s.set_process(false)
			var merkez := s.alan_merkezi(b.hucre, b.boyut(y.katalog))
			s.kamera.position = merkez + Vector3(8, 6, 11)
			s.kamera.look_at(merkez + Vector3(0, 0.9, 0))
			await get_tree().create_timer(0.4).timeout
			await RenderingServer.frame_post_draw
			get_viewport().get_texture().get_image().save_png(dizin.path_join("ani06_degirmen.png"))
			var disari := (f.position - merkez).normalized()
			disari.y = 0
			s.kamera.position = f.position + disari.normalized() * 5 + Vector3(0, 2.5, 0)
			s.kamera.look_at(f.position + Vector3(0, 0.9, 0))
			await get_tree().create_timer(0.3).timeout
			await RenderingServer.frame_post_draw
			get_viewport().get_texture().get_image().save_png(dizin.path_join("ani06_cuval.png"))
		h._process(float(DegirmenHareketi.AYAR.sureler[i]) + 0.1)
		h._process(0.0)
	kontrol(JSON.stringify(ana.oturum.kaydet()) == once, "Görsel öğütme kayıt/RNG/stok değiştirmez")
	h.yenile()
	h._process(0.0)
	kontrol(f.find_children("degirmen_cuvali", "", false, false).size() == 1, "Tek çuval sistemi")
	s.faz(&"gece", 0.0)
	h._process(0.0)
	await get_tree().process_frame
	aci = wheel.teker.rotation.z
	wheel._process(0.5)
	kontrol(wheel.teker.rotation.z == aci and f.get_node_or_null("degirmen_cuvali") == null, "Gece çark/çuval kapalı")
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("DEĞİRMEN HAREKETİ UI: GEÇTİ" if hata == 0 else "DEĞİRMEN HAREKETİ UI: KALDI")
	await Ses.cik(hata)
func _kur(y: KoyYonetimi) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim("degirmen", h).olur:
				var b := y.bina(y.bina_kur("degirmen", h).id)
				if b == null: return null
				b.insa_kalan = 0
				return b
	return null
func kontrol(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
