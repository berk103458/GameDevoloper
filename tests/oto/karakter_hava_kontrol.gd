extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_weather.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 76)
		kayit = GuvenliKayit.new("user://test_weather_ui.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var y := ana.oturum.yonetim
	y.kaynaklar.kapasite = 10000
	for t in ["odun", "tas", "kereste"]: y.kaynaklar.ekle(t, 100)
	var b := _kur(y)
	kontrol(b != null, "Gerçek kulübe saçağı")
	if b == null:
		await Ses.cik(1)
		return
	var k := y.kabul({"sinif": "ciftci", "stat": 5})
	var guard := y.kabul({"sinif": "asker", "stat": 5})
	guard.is_yeri = KoyYonetimi.MUHAFIZ
	IklimDeneyi.degistir(ana.oturum, 0, "yagmur")
	var once := JSON.stringify(ana.oturum.kaydet())
	ana._koye_git()
	await get_tree().process_frame
	var s: KoyYonetimSahnesi = ana._ekran.sahne3b
	var h := s.halk_hareketi
	h.set_process(false)
	for i in 3: h._process(0.0)
	var d: Dictionary = h._durum[k.id]
	var f: KarakterModel = h.modeller[k.id]
	kontrol(d.siginma and not d.is and not d.ates_basi, "Yağmurda iş/ateş yerine saçak")
	kontrol(h._durum[guard.id].devriye and not h._durum[guard.id].siginma, "Yağmurda muhafız görevi korunur")
	for adim in range(d.yol.size() + 1):
		if int(d.adim) >= d.yol.size(): break
		f.position = d.yol[d.adim]
		h._process(0.0)
	f.yurumeyi_durdur()
	kontrol(f.position.distance_to(h._konum(KarakterHavaTepkisi.durak(y, b))) < s.HUCRE / 2 and h.eylem(k.id).contains("saçak"), "Erişilebilir gerçek saçak altında")
	kontrol(s.find_children("hava_sacagi_yer_tutucu", "", true, false).size() == 1, "Tek kutu saçak yer tutucusu")
	kontrol(JSON.stringify(ana.oturum.kaydet()) == once, "Sığınma kayıt/RNG/stok değiştirmez")
	var panel := IklimDenetcisiPaneli.new()
	panel.baglam = ana
	ana.add_child(panel)
	panel.ac(true)
	kontrol(panel.hava.item_count == 4 and panel.hava.selected == 3, "Mevcut denetçide yağmur seçimi")
	panel.ac(false)
	await _goruntu(s, f, "ani09_yagmur.png")
	IklimDeneyi.degistir(ana.oturum, 0, "normal")
	h.yenile()
	for i in 3: h._process(0.0)
	kontrol(not d.siginma and f.duzeltici().hava_egimi == 0, "Yağmur bitince günlük rutin")
	var bas := f.position
	d.yol = [bas + Vector3(2, 0, 0)]
	d.adim = 0
	h._adim(k.id)
	f._yurume.pause()
	f._yurume.custom_step(0.25)
	var normal := f.position.distance_to(bas)
	f.yurumeyi_durdur()
	f.position = bas
	IklimDeneyi.degistir(ana.oturum, 0, "kar_firtinasi")
	h.yenile()
	for i in 3: h._process(0.0)
	f.yurumeyi_durdur()
	f.position = bas
	d.yol = [bas + Vector3(2, 0, 0)]
	d.adim = 0
	h._adim(k.id)
	f._yurume.pause()
	f._yurume.custom_step(0.25)
	var karda := f.position.distance_to(bas)
	kontrol(karda > 0 and karda < normal * 0.9, "Gerçek yürüyüş tweeni karda yavaş")
	f.yurumeyi_durdur()
	kontrol(f.duzeltici().hava_egimi > 0, "Gerçek iskelette büzülmüş gövde")
	IklimGorseli.uygula(s)
	await _goruntu(s, f, "ani09_kar.png")
	IklimDeneyi.degistir(ana.oturum, 0, "yagmur")
	y.bina_yik(b.id)
	h.yenile()
	for i in 3: h._process(0.0)
	kontrol(not d.siginma, "Hazır saçak kalmayınca geçersiz hedef yok")
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("KARAKTER HAVA UI: GEÇTİ" if hata == 0 else "KARAKTER HAVA UI: KALDI")
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
func _kur(y: KoyYonetimi) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim("kulube", h).olur:
				var b := y.bina(y.bina_kur("kulube", h).id)
				if b == null: return null
				b.insa_kalan = 0
				return b
	return null
func kontrol(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
