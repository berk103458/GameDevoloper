extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_water.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 76)
		kayit = GuvenliKayit.new("user://test_water_ui.json")
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
	for t in ["odun", "tas", "kereste"]: y.kaynaklar.ekle(t, 100)
	for tur in ["tarla", "bostan"]:
		var b := _kur(y, tur)
		kontrol(b != null, "Gerçek tarla/bostan kurulur")
		if b == null:
			await Ses.cik(1)
			return
		var k := y.kabul({"sinif": "ciftci", "stat": 5})
		kontrol(y.ata(k.id, b.id), "Gerçek çiftçi/bostancı ataması")
	var once := JSON.stringify(ana.oturum.kaydet())
	ana._koye_git()
	await get_tree().process_frame
	var s: KoyYonetimSahnesi = ana._ekran.sahne3b
	var h := s.halk_hareketi
	h.set_process(false)
	h._process(0.0)
	for k in y.koylular:
		var f: KarakterModel = h.modeller[k.id]
		var e := f.get_node_or_null("sulama_rutini") as SulamaRutini
		kontrol(e != null and e.kova != null, "Gerçek el kemiğinde kova")
		for i in 3:
			var d: Dictionary = h._durum[k.id]
			kontrol(d.sulama and d.sulama_i == i, "Kuyu, ark, dinlenme sırası")
			while int(d.adim) < d.yol.size():
				f.position = d.yol[d.adim]
				h._process(0.0)
			f.yurumeyi_durdur()
			kontrol(e.akis.visible == (i == 1) and e.su.visible == (i == 1), "Dolu kova ve varışta akış")
			kontrol(e.kova.visible == (i != 2), "Dinlenmede kova gizli")
			var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
			if i == 1 and k.id == y.koylular[0].id and not dizin.is_empty() and DisplayServer.get_name() != "headless":
				s.set_process(false)
				s.kamera.position = f.position + Vector3(4, 3, 5)
				s.kamera.look_at(f.position + Vector3(0, 0.8, 0))
				await get_tree().create_timer(0.4).timeout
				await RenderingServer.frame_post_draw
				get_viewport().get_texture().get_image().save_png(dizin.path_join("ani03_sulama.png"))
			h._process(float(SulamaRutini.AYAR.sureler[i]) + 0.1)
			h._process(0.0)
	kontrol(JSON.stringify(ana.oturum.kaydet()) == once, "Sulama ekonomi/RNG/kayıt değiştirmez")
	h.yenile()
	h._process(0.0)
	for f in h.modeller.values(): kontrol(f.find_children("sulama_rutini", "", false, false).size() == 1, "Tek kova sistemi")
	s.faz(&"gece", 0.0)
	h._process(0.0)
	await get_tree().process_frame
	for f in h.modeller.values(): kontrol(f.get_node_or_null("sulama_rutini") == null, "Gece kova kaldırılır")
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("SULAMA RUTİNİ UI: GEÇTİ" if hata == 0 else "SULAMA RUTİNİ UI: KALDI")
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
