extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_sancak_asker.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog,1403)
		kayit = GuvenliKayit.new("user://unused_sancak_asker.json")
		theme = Tema.olustur(ayarlar)
func dugme(e: KoyEkrani,s: String) -> Button:
	for b in e.find_children("*","Button",true,false):
		if b.text.contains(s) and not b.is_queued_for_deletion(): return b
	return null
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().create_timer(45).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var o := ana.oturum
	var y := o.yonetim
	for i in 5: y.kabul({"ad":"Levent %d"%i})
	y.kaynaklar.ekle("gida",150)
	y.kaynaklar.ekle("su",150)
	y.gun = 7
	o.gece_sonu()
	assert(y.gun==8 and SancakAskerTalebi.oku(o.sancak_asker_talebi).bekliyor)
	ana.oturum = Oturum.kayittan(ana.katalog,JSON.parse_string(JSON.stringify(o.kaydet())))
	o = ana.oturum
	y = o.yonetim
	ana._koye_git()
	await get_tree().process_frame
	var e := ana._ekran as KoyEkrani
	var olay := SancakAskerTalebi.olay(o)
	e._olay_goster(olay,{})
	var al := dugme(e,"Uygun iş gücünden")
	var asi := dugme(e,"Açık iş reddi adaylarından")
	assert(al!=null and not al.disabled and asi!=null and asi.disabled)
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name()!="headless":
		await get_tree().create_timer(0.5).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("har04_ferman.png"))
	var para := o.muhafiz_akce
	var kamu := y.akce
	al.pressed.emit()
	await get_tree().process_frame
	assert(y.nufus()==3 and o.koy.toplam()==3 and o.muhafiz_akce==para and y.akce==kamu and not SancakAskerTalebi.oku(o.sancak_asker_talebi).bekliyor)
	var once := JSON.stringify(o.kaydet())
	assert(not o.olay_uygula(olay,0).ok and JSON.stringify(o.kaydet())==once)
	var bitir := dugme(e,"Devam")
	assert(bitir!=null)
	# Fermanın kapanış sözleşmesini izole et; kapının ayrı async varlık yüklemesini başlatma.
	for c in e.devam_istendi.get_connections(): e.devam_istendi.disconnect(c.callable)
	var devam := [false]
	e.devam_istendi.connect(func(_r: Dictionary) -> void: devam[0]=true)
	bitir.pressed.emit()
	await get_tree().process_frame
	assert(devam[0] and e._ust_kart==null)
	await _ulak_kapida(ana)
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.5).timeout
	print("SANCAK ASKER UI: GEÇTİ")
	await Ses.cik(0)


func _ulak_kapida(ana: Ana) -> void:
	var ulak = preload("res://src/sistemler/sancak_ulagi.gd")
	var o := Oturum.new(ana.katalog, 1403)
	o.bayraklar[ulak.ACILIS.ULAK] = true
	for i in 5: o.yonetim.kabul({"ad": "Levent %d" % i})
	o.yonetim.kaynaklar.ekle("gida", 150)
	o.yonetim.kaynaklar.ekle("su", 150)
	o.gun = 5
	assert(not ulak.ilgilenir(o.gece_kuyrugu().front()))
	var teftis_raporu := o.gece_sonu()
	assert(o.gun == 6 and o.sancak_teftisi.sonuc == "temiz")
	assert(not teftis_raporu.olaylar.any(func(olay: Dictionary) -> bool: return olay.has("sancak_teftisi")))
	o = Oturum.kayittan(ana.katalog, JSON.parse_string(JSON.stringify(o.kaydet())))
	assert(o != null)
	var haberci := o.gece_kuyrugu().front() as Gelen
	assert(ulak.ilgilenir(haberci) and haberci.secenekler == PackedStringArray([ulak.DINLE]))
	assert(haberci.acilis == SancakTeftisi.olay_metin(o.sancak_teftisi))
	assert(not o.karar_ver(haberci, ulak.DINLE).engellendi)
	assert(o.karar_ver(haberci, ulak.DINLE).engellendi)
	o.gun = 7
	var kuyruk := o.gece_kuyrugu()
	assert(o.gosterilen_gece() == 8 and ulak.ilgilenir(kuyruk.front()))
	assert(kuyruk.filter(func(g: Gelen) -> bool: return ulak.ilgilenir(g)).size() == 1)
	assert(not SancakAskerTalebi.tanimli(o.olay_sec()))
	var ziyaret: Dictionary = JSON.parse_string(JSON.stringify(KapiAnlikGoruntusu.gelen_kaydet(kuyruk.front())))
	var g := KapiAnlikGoruntusu.gelen_yukle(ziyaret, ana.katalog)
	assert(ulak.ilgilenir(g) and g.get_meta(ulak.META) == o.gun)
	assert(o.karar_ver(haberci, ulak.DINLE).engellendi)
	ana.oturum = o
	var kapi := KapiEkrani.new()
	kapi.oturum = o
	kapi.ayarlar = ana.ayarlar
	ana._goster(kapi)
	kapi._kuyruk = [g]
	kapi._siradaki()
	while kapi.evre != &"karar": await get_tree().process_frame
	assert(kapi._kayit.get_parsed_text().contains("Sancak Beyi 2 levent ister"))
	kapi._tumunu_goster()
	assert(kapi._karar_dugmeleri[0].text.contains("Uygun iş gücünden") and not kapi._karar_dugmeleri[0].disabled)
	assert(kapi._karar_dugmeleri[1].disabled)
	kapi._karar_dugmeleri[0].pressed.emit()
	kapi._karar_dugmeleri[0].pressed.emit()
	assert(kapi._kayit.get_parsed_text().contains("Sancak ordusuna gönderilen leventler"))
	assert(o.yonetim.nufus() == 3 and not o.sancak_asker_talebi.bekliyor)
	assert(o.karar_ver(g, &"ulak_levent").engellendi)
	await kapi.gece_bitti
	var ferman_raporu := o.gece_sonu()
	assert(o.gun == 8 and not o.sancak_asker_talebi.bekliyor)
	assert(not SancakAskerTalebi.tanimli(ferman_raporu.olay))
	assert(not ulak.ilgilenir(o.gece_kuyrugu().front()))
	print("SANCAK ULAK KAPI: GEÇTİ")
