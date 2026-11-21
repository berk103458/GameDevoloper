extends SceneTree

var _hata := 0

func _initialize() -> void:
	_kos()

func _kos() -> void:
	var metin := FileAccess.get_file_as_string("res://src/koy/gorsel/celep_hayvan_gorseli.gd")
	_kontrol(metin.contains('"tavuk": ["td_a146", 0.40]'), "tavuk ölçeği 0,40 m duruyor")
	var olcu := FileAccess.get_file_as_string("res://data/varlik_olculeri.json")
	_kontrol(olcu.contains("a146") or olcu.contains("td_a146"), "varlık ölçü tablosu duruyor")

	var kat := BinaKatalogu.new()
	var y := KoyYonetimi.new(KoyAyarlari.new(), kat, 28)
	var esnaf := Koylu.new()
	esnaf.id = 1
	esnaf.ad = "Hamza"
	esnaf.sinif = &"esnaf"
	esnaf.ac = true
	esnaf.aclik = 5
	y.koylular.append(esnaf)
	var ciftci := Koylu.new()
	ciftci.id = 2
	ciftci.ad = "Yusuf"
	ciftci.sinif = &"ciftci"
	ciftci.is_gucu = 1.0
	y.koylular.append(ciftci)

	var s := KoyYonetimSahnesi.new()
	s.yonetim = y
	root.add_child(s)
	for i in 8:
		await process_frame

	_kontrol(s.atmosfer.get_node_or_null(^"Sky3D") != null, "Sky3D köyde")
	_kontrol(is_equal_approx(s.atmosfer._sky.tod.current_time, 9.5), "gündüz saati 9.5")
	s.faz(&"gece", 0.0)
	_kontrol(s.atmosfer._sky.tod.current_time > 22.0, "gece saati karanlık")
	_kontrol(s.atmosfer.cevre.fog_enabled, "sis açık")
	var duz := s.arazi.get_node_or_null(^"zemin_eski") as MeshInstance3D
	var terrain := s.arazi.get_node_or_null(^"zemin_terrain") as Terrain3D
	_kontrol(terrain != null and terrain.data.get_region_count() > 0, "Terrain3D bölgesi var")
	_kontrol(duz != null and not duz.visible, "eski zemin duruyor ve gizlendi")
	_kontrol(is_equal_approx(s.arazi.yukseklik_burada(0, 0), 0.0), "ızgara yüksekliği 0")
	print("CARPISMA ", terrain.collision_mode)
	_kontrol(int(terrain.collision_mode) == 0, "arazi çarpışması kapalı")
	var serp := s.arazi.get_node_or_null(^"koy_serpintisi")
	_kontrol(serp != null and serp.get_child_count() == 4, "dört serpinti")
	var olcum := OrnekYigini.olc(s)
	var cikti := 0
	for n in s.arazi.find_children("ScatterOutput", "Node3D", true, false):
		cikti += n.get_child_count()
	_kontrol(cikti >= 4, "serpinti çıktısı")
	print("OLCUM cagri=%d ucgen=%d ornek=%d duz=%d yigin=%d donusen=%d" % [olcum.cagri, olcum.ucgen, olcum.ornek, olcum.duz, olcum.yigin, OrnekYigini.donusen])
	_kontrol(olcum.yigin >= 1, "çimen MultiMesh duruyor")
	var rid := s.get_viewport().get_viewport_rid()
	var cagri := RenderingServer.viewport_get_render_info(rid, RenderingServer.VIEWPORT_RENDER_INFO_TYPE_VISIBLE, RenderingServer.VIEWPORT_RENDER_INFO_DRAW_CALLS_IN_FRAME)
	var ucgen := RenderingServer.viewport_get_render_info(rid, RenderingServer.VIEWPORT_RENDER_INFO_TYPE_VISIBLE, RenderingServer.VIEWPORT_RENDER_INFO_PRIMITIVES_IN_FRAME)
	print("GPU cagri=%d primitif=%d" % [cagri, ucgen])

	var limbo := 0
	for id in s.halk_hareketi.modeller:
		if s.halk_hareketi.modeller[id].get_node_or_null(^"limbo") != null:
			limbo += 1
	_kontrol(limbo >= 1, "Limbo oyuncusu köylüde")
	await process_frame
	_kontrol(String(esnaf.get_meta(&"limbo", "")) != "", "Limbo gündüz iş seçti")

	var govde: Node = s.halk_hareketi.modeller[esnaf.id]
	var ajan := govde.get_node_or_null(^"ihtiyac")
	_kontrol(ajan != null, "planlayıcı esnafta")
	for i in 20:
		await process_frame
		if String(s.halk_hareketi.modeller[esnaf.id].get_meta(&"ihtiyac", "")) != "":
			break
	print("IHTIYAC ", s.halk_hareketi.modeller[esnaf.id].get_meta(&"ihtiyac", ""))

	var g := Gelen.new()
	g.adli = false
	g.sinif = &"ciftci"
	var satirlar := await DmKopru.kapi_satirlari(null, g)
	_kontrol(not satirlar.is_empty(), "kapı sorgusu satırı")
	DmKopru._oturum.yonetim = y
	await DmKopru.kapi_uygula(null, g, "ret")
	_kontrol(String(y.get_meta(&"dm_is", "")) == "debuff", "kapı kararı debuff")
	_kontrol(ciftci.is_gucu < 1.0, "iş gücü düştü")
	_kontrol(int(y.get_meta(&"dm_sonraki", -1)) == ciftci.id, "sıradaki kişi")

	var dy := KoyDiyalogYoneticisi.new()
	var geldi := {"ok": false}
	dy.replik_geldi.connect(func(_a, _b, _c) -> void: geldi.ok = true)
	dy.muhabbet_baslat(esnaf, y)
	for i in 10:
		await process_frame
		if geldi.ok:
			break
	_kontrol(geldi.ok, "tüccar diyaloğu")
	await DmKopru.muhabbet_sec(dy, "harc")
	_kontrol(String(y.get_meta(&"dm_is", "")) == "harc", "tüccar bacı kararı")

	var cikti := OS.get_environment("EKLENTI_EKRAN_GORUNTUSU")
	if DisplayServer.get_name() != "headless" and not cikti.is_empty():
		await RenderingServer.frame_post_draw
		var img := s.get_viewport().get_texture().get_image()
		_kontrol(img != null and img.save_png(cikti) == OK, "ekran görüntüsü yazıldı")
	print("EKLENTI BAG: %s" % ("GEÇTİ" if _hata == 0 else "KALDI (%d)" % _hata))
	quit(_hata)

func _kontrol(kosul: bool, yazi: String) -> void:
	if kosul:
		return
	_hata += 1
	push_error(yazi)
