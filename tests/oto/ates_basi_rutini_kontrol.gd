extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_fire.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 76)
		kayit = GuvenliKayit.new("user://test_fire_ui.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
	seed(5812)
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var y := ana.oturum.yonetim
	var ids: Array[int] = []
	for i in 5:
		ids.append(y.kabul({"sinif": "ciftci", "stat": 5}).id)
	var guard := y.kabul({"sinif": "asker", "stat": 5})
	guard.is_yeri = KoyYonetimi.MUHAFIZ
	var worker := y.kabul({"sinif": "ciftci", "stat": 5})
	worker.is_yeri = 900
	var once := JSON.stringify(ana.oturum.kaydet().merged({"faz": "koy"}, true))
	ana._koye_git()
	await get_tree().process_frame
	var s: KoyYonetimSahnesi = ana._ekran.sahne3b
	var h := s.halk_hareketi
	h.set_process(false)
	for faz in [&"aksam", &"gece"]:
		s.faz(faz, 0.0)
		for i in 3: h._process(0.0)
		var duraklar: Array[Vector3] = []
		var ofsetler := {}
		var kol_pozlari := {}
		for id in ids:
			var d: Dictionary = h._durum[id]
			var f: KarakterModel = h.modeller[id]
			kontrol(d.ates_basi and not d.yol.is_empty(), "Boşta köylünün erişilebilir ateş rotası")
			if d.yol.is_empty(): continue
			var p: Vector3 = d.yol[-1]
			kontrol(not duraklar.has(p), "Her köylüye ayrı durak")
			duraklar.append(p)
			var mesafe := p.distance_to(AtesBasiRutini.konum(s))
			kontrol(mesafe >= float(AtesBasiRutini.AYAR.en_yakin) and mesafe <= float(AtesBasiRutini.AYAR.en_uzak) + 0.1, "Ateşten güvenli halka")
			for adim in range(d.yol.size() + 1):
				if int(d.adim) >= d.yol.size(): break
				f.position = d.yol[d.adim]
				h._process(0.0)
			kontrol(int(d.adim) >= d.yol.size(), "Rota sonuna ulaşılır")
			f.yurumeyi_durdur()
			var poz := f.duzeltici()
			kontrol(poz != null and poz.surekli == &"isin" and h.eylem(id) == "Ateş başında ısınıyor", "Varınca gerçek iskelette ısınma")
			if poz != null and poz.surekli == &"isin":
				ofsetler[poz.faz] = true
				# Aynı animasyon anında yalnız gerçek modelin faz ofseti değişir.
				var onkol := AtesBasiRutini.kol(1.0, 0.5 + poz.faz)[1]
				kol_pozlari[snappedf(onkol.y, 0.0001)] = true
		kontrol(ofsetler.size() == 5 and kol_pozlari.size() >= 2, "SAH-58: Beş modelin ısınma pozu aynı kareye yığılmaz")
		print("SAH-58 %s: ofset=%d, farklı önkol pozu=%d" % [faz, ofsetler.size(), kol_pozlari.size()])
		kontrol(h._durum[guard.id].devriye and not h._durum[guard.id].ates_basi, "Muhafız devriyesi korunur")
		kontrol(not h._durum[worker.id].ates_basi, "Atanmış işçinin ev rutini korunur")
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name() != "headless":
		s.set_process(false)
		var ates := AtesBasiRutini.konum(s)
		s.kamera.position = ates + Vector3(7, 6, 9)
		s.kamera.look_at(ates + Vector3(0, 0.9, 0))
		await get_tree().create_timer(1.0).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("ani07_ates.png"))
	s.faz(&"gunduz", 0.0)
	for i in 3: h._process(0.0)
	for id in ids:
		kontrol(not h._durum[id].ates_basi and h.modeller[id].duzeltici().surekli == &"", "Gündüz ısınma duruşu kapanır")
	kontrol(JSON.stringify(ana.oturum.kaydet()) == once, "Ateş ritüeli kayıt/RNG/stok değiştirmez")
	# Kopuk rota aynı kişiyi başka köylünün durağına atamaz.
	s.faz(&"gece", 0.0)
	for i in 3: h._process(0.0)
	var id := ids[0]
	var bas := h.rotaci.yakin(y.a.meydan.position)
	var hedef := AtesBasiRutini.hedef(h, y.koylu(id), bas)
	if not hedef.is_empty():
		y.izgara.engeller[hedef.son] = true
		h.rotaci.kur(y.izgara, 2.5)
		var kapali := AtesBasiRutini.hedef(h, y.koylu(id), bas)
		kontrol(kapali.is_empty() or h.rotaci.gecilir(kapali.son), "Engel içinden geçilmez")
		y.izgara.engeller.erase(hedef.son)
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("ATEŞ BAŞI UI: GEÇTİ" if hata == 0 else "ATEŞ BAŞI UI: KALDI")
	await Ses.cik(hata)
func kontrol(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
