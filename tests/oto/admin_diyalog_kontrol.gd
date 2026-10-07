extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_admin_diyalog.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 45)
		kayit = GuvenliKayit.new("user://test_admin_diyalog.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var e := KapiEkrani.new()
	e.oturum = ana.oturum
	e.ayarlar = ana.ayarlar
	ana._kapi = e
	ana._goster(e)
	e._gelen = ana.oturum._adli_gelen(&"chr_001")
	e._sohbet_goster()
	var s: ChrSorgusu = e._gelen.chr_sorgusu()
	var admin := AdminHud.new()
	admin.baglam = ana
	ana.add_child(admin)
	admin.ac(true)
	var p := admin.diyalog_paneli
	_kontrol(not p.visible and not p.is_processing(), "Kapali diyalog paneli islemez")
	p.ac(true)
	p.kilit.select(2)
	p.kilit.item_selected.emit(2)
	_kontrol(s.tansiyon == 5 and s.has_meta(DiyalogDeneyi.META), "Gercek dropdown 5 kilidi kurar")
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name() != "headless":
		await get_tree().create_timer(0.5).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("adm15_diyalog.png"))
	var gun := ana.oturum.gun
	var koy := ana.oturum.koy_akce
	var muhafiz := ana.oturum.muhafiz_akce
	var gelen := e._gelen
	p.otomatik.button_pressed = true
	var baslangic := Time.get_ticks_msec()
	while p.otomatik.button_pressed and Time.get_ticks_msec() - baslangic < 15000:
		await get_tree().create_timer(0.05).timeout
	_kontrol(not p.otomatik.button_pressed and p.adim_sayisi > 0 and (e.evre == &"karar" or not p.son_rapor["ok"]), "Gercek 500 ms otomatik akis dongude guvenle durur")
	_kontrol(s.tansiyon == 5 and e._gelen == gelen and ana.oturum.gun == gun and ana.oturum.koy_akce == koy and ana.oturum.muhafiz_akce == muhafiz, "Kilit akista korunur, ziyaret/karar/kasa/gun uygulanmaz")
	p.kilit.select(3)
	p.kilit.item_selected.emit(3)
	_kontrol(s.tansiyon == 9 and s.bayraklar["Flag_Kilitlendi"] and not s.karar_acik(&"kabul"), "9 panik kilidini normal motor uzerinden uygular")
	p.otomatik.button_pressed = true
	baslangic = Time.get_ticks_msec()
	while p.otomatik.button_pressed and Time.get_ticks_msec() - baslangic < 5000:
		await get_tree().create_timer(0.05).timeout
	_kontrol(e.evre == &"karar" and not p.otomatik.button_pressed, "Panik dalindaki gercek otomatik akis karar ekraninda durur")
	admin.ac(false)
	_kontrol(not p.visible and not p.is_processing() and not s.has_meta(DiyalogDeneyi.META) and s.bayraklar["Flag_Kilitlendi"], "Panel kapatma debug kilidini cozer, kalici panigi korur")
	admin.ac(true)
	p.ac(true)
	var eski := e._gelen
	e._gelen = ana.oturum._adli_gelen(&"chr_002")
	e._sohbet_goster()
	_kontrol(not DiyalogDeneyi.adim(ana, eski)["ok"] and not DiyalogDeneyi.uygula(ana, eski, 2)["ok"], "Eski callback yeni ziyareti degistirmez")
	p.yenile()
	var once: StringName = e._gelen.chr_sorgusu().dugum_id
	var modal := Control.new()
	modal.name = "ChrInceleme"
	e.add_child(modal)
	_kontrol(not DiyalogDeneyi.adim(ana, e._gelen)["ok"] and e._gelen.chr_sorgusu().dugum_id == once, "Ipucu modalinda otomatik akis engellenir")
	modal.free()
	# Kapali clue secenegi: kaynak veriyi degistirmeden acik yollar bu test ziyaretinde harcanir.
	var cs: ChrSorgusu = e._gelen.chr_sorgusu()
	var sec: Array = cs.karakter.diyalog_dugumu(cs.dugum_id)["secenekler"]
	for i in sec.size(): cs._denemeler["%s:%d" % [cs.dugum_id, i]] = true
	_kontrol(not DiyalogDeneyi.adim(ana, e._gelen)["ok"] and cs.ipuclari.is_empty(), "Kapali kosullarda durur; ipucu uydurmaz")
	e._gelen = ana.oturum._adli_gelen(&"aydogdu")
	e._sohbet_goster()
	p.yenile()
	_kontrol(p.kilit.disabled and e._gelen.chr_sorgusu() == null, "Eski soru akisinda CHR tansiyonu uydurulmaz")
	for i in 16:
		if e.evre == &"karar": break
		_kontrol(DiyalogDeneyi.adim(ana, e._gelen)["ok"], "Eski sorular normal API ile ilerler")
		await get_tree().process_frame
	_kontrol(e.evre == &"karar", "Eski akis da karar ekraninda durur")
	p.adim_sayisi = 64
	p.otomatik.set_pressed_no_signal(true)
	p._adim()
	_kontrol(not p.otomatik.button_pressed and not p.son_rapor["ok"], "64 adim dongu siniri")
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("ADMIN DIYALOG: GEÇTİ" if hata == 0 else "ADMIN DIYALOG: KALDI")
	await Ses.cik(hata)
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
