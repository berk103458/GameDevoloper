extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_stealth.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 76)
		kayit = GuvenliKayit.new("user://test_stealth_ui.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var y := ana.oturum.yonetim
	var k := y.kabul({"sinif": "ciftci", "stat": 5})
	k.gizli_egilim = {"tur": "haydut"}
	var guard := y.kabul({"sinif": "asker", "stat": 5})
	guard.is_yeri = KoyYonetimi.MUHAFIZ
	var normal := y.kabul({"sinif": "ciftci", "stat": 5})
	var once := JSON.stringify(ana.oturum.kaydet())
	ana._koye_git()
	await get_tree().process_frame
	var s: KoyYonetimSahnesi = ana._ekran.sahne3b
	var h := s.halk_hareketi
	h.set_process(false)
	s.faz(&"gece", 0.0)
	for i in 3: h._process(0.0)
	var d: Dictionary = h._durum[k.id]
	var f: KarakterModel = h.modeller[k.id]
	kontrol(d.sinsi and not d.ates_basi and not d.is, "Gece kuytu, ateş ve iş kapalı")
	kontrol(h._durum[guard.id].devriye and not h._durum[guard.id].sinsi, "Nöbetçi rutini korunur")
	kontrol(not h._durum[normal.id].sinsi and h._durum[normal.id].ates_basi, "Normal köylü ateşe gider")
	for adim in range(d.yol.size() + 1):
		if int(d.adim) >= d.yol.size(): break
		f.position = d.yol[d.adim]
		h._process(0.0)
	f.yurumeyi_durdur()
	kontrol(f.position.distance_to(AtesBasiRutini.konum(s)) >= float(SinsiGeceRutini.AYAR.ates_mesafesi), "Kuytu ateşten uzakta")
	kontrol(h.eylem(k.id) == "Tenhada bekliyor" and GizliEgilimler.oyuncu_metin(k) == "Gizli eğilimler bilinmiyor", "Gizli kimlik metne sızmaz")
	var ilk := f.position
	var g: KarakterModel = h.modeller[guard.id]
	g.yurumeyi_durdur()
	g.position = ilk + Vector3(1, 0, 0)
	kontrol(SinsiGeceRutini.tehdit(h, k.id), "Gerçek nöbetçi yaklaşımı algılanır")
	h._process(float(SinsiGeceRutini.AYAR.yeniden_planlama))
	for i in 3: h._process(0.0)
	kontrol(not d.yol.is_empty() and d.yol[-1].distance_to(ilk) >= float(SinsiGeceRutini.AYAR.yer_degistirme) - 0.5, "Aynı bütçeli A* kuyruğunda yön değişir")
	kontrol(not SinsiGeceRutini.tehdit(h, k.id), "Güvenli kaçış hedefi yeniden planlama döngüsü oluşturmaz")
	kontrol(JSON.stringify(ana.oturum.kaydet()) == once, "Rota stok/kayıt/RNG ve suç hesabı değiştirmez")
	await _goruntu(s, f, "ani10_gece.png")
	guard.is_yeri = KoyYonetimi.BOSTA
	s.faz(&"gece", 0.0)
	for i in 3: h._process(0.0)
	kontrol(d.sinsi and not d.yol.is_empty() and SinsiGeceRutini.nobetciler(h).is_empty(), "Muhafız yokken kararlı kuytu rota")
	var ikinci := y.kabul({"sinif": "ciftci", "stat": 5})
	ikinci.gizli_egilim = {"tur": "haydut"}
	h.yenile()
	for i in 3: h._process(0.0)
	var d2: Dictionary = h._durum[ikinci.id]
	kontrol(d2.sinsi and d2.yol[-1].distance_to(d.yol[-1]) > s.HUCRE / 2, "Aynı kuytuda üst üste binmez")
	s.faz(&"gunduz", 0.0)
	for i in 3: h._process(0.0)
	kontrol(not d.sinsi, "Gündüz normal rutine dönüş")
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("SİNSİ GECE UI: GEÇTİ" if hata == 0 else "SİNSİ GECE UI: KALDI")
	await Ses.cik(hata)
func _goruntu(s: KoyYonetimSahnesi, f: KarakterModel, ad: String) -> void:
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if dizin.is_empty() or DisplayServer.get_name() == "headless": return
	s.set_process(false)
	s.kamera.position = f.position + Vector3(5, 2.5, 3)
	s.kamera.look_at(f.position + Vector3(0, 0.9, 0))
	await get_tree().create_timer(0.3).timeout
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png(dizin.path_join(ad))
func kontrol(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
