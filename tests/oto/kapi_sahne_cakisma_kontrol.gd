extends Node

var _hata := 0


func _dogrula(kosul: bool, mesaj: String) -> void:
	if not kosul:
		_hata += 1
		push_error("CIL-25 HATA: " + mesaj)


func _ready() -> void:
	get_tree().create_timer(30.0).timeout.connect(func() -> void: get_tree().quit(1))
	call_deferred("_calistir")


func _calistir() -> void:
	var png_dizin := OS.get_environment("KAPI_PNG_DIZIN")
	var png_on := OS.get_environment("KAPI_PNG_ON")
	if DisplayServer.get_name() != "headless":
		DisplayServer.window_set_size(Vector2i(1920, 1080))
	get_viewport().size = Vector2i(1920, 1080)

	# 1) Tüm sur seviyelerinde (0..3) AABB çakışma kontrolü
	for sur_sv in [0, 1, 2, 3]:
		var ts := KapiSahnesi.new()
		ts.sur = sur_sv
		ts.gunduz = true
		add_child(ts)
		await get_tree().process_frame
		_aabb_tara(ts, sur_sv)
		ts.queue_free()
		await get_tree().process_frame

	# 2) KapiEkrani 1920x1080 kadraj ve panel örtüşme kontrolü (+ opsiyonel önce/sonra PNG)
	var kat := Katalog.new()
	kat.yukle()
	var ayar := Ayarlar.new("user://unused_cil25.cfg")
	var ot := Oturum.new(kat, 42)
	ot.yapilar[&"sur"] = 1
	var ekran := KapiEkrani.new()
	ekran.oturum = ot
	ekran.ayarlar = ayar
	ekran.theme = Tema.olustur(ayar)
	add_child(ekran)
	await get_tree().process_frame
	await get_tree().process_frame

	var s: KapiSahnesi = ekran.sahne
	s.kuyruk_doldur(["chr_002", "chr_003", "chr_004"])
	var f := Dunya3B.karakter("chr_001")
	f.position = KapiSahnesi.DURMA + Vector3(0.0, s.ayak_zemini_yuksekligi(KapiSahnesi.DURMA), 0.0)
	s.add_child(f)
	f.bak(s.kamera.position)
	s._gelen = f
	ekran._ad.text = "Alparslan Bey"
	ekran._sinif.text = "Yolcu gibi görünüyor"
	ekran._levha_ad.text = "Alparslan Bey"
	ekran._kayit.clear()
	ekran._kayit.append_text("Kapıdan geçmek için izin isterim bekçi.")
	for _i in 4:
		await get_tree().process_frame

	var cam: Camera3D = s.kamera
	var olcek := Vector2(1920.0, 1080.0) / Vector2(ekran._vp.size)
	var p_ayak := cam.unproject_position(f.global_position) * olcek
	var p_bel := cam.unproject_position(f.global_position + Vector3(0, 0.90, 0)) * olcek
	var p_gogus := cam.unproject_position(f.global_position + Vector3(0, 1.30, 0)) * olcek
	var p_bas := cam.unproject_position(f.global_position + Vector3(0, 1.70, 0)) * olcek
	print("CIL-25 KADRAJ (1920x1080): cam=%s fov=%.1f h_offset=%.2f ayak=%s bel=%s gogus=%s bas=%s" % [cam.position, cam.fov, cam.h_offset, p_ayak, p_bel, p_gogus, p_bas])

	# Baş ve gövde (bel..baş) 1920x1080 orta üçte birde ve panel altında değil
	_dogrula(p_bas.x >= 260.0 and p_bas.x <= KapiEkrani.DEFTER.position.x - 40.0, "Baş defter panelinin dışında (x=%.1f < %.1f)" % [p_bas.x, KapiEkrani.DEFTER.position.x - 40.0])
	_dogrula(p_bas.y >= 110.0 and p_bas.y <= KapiEkrani.KONUSMA.position.y - 180.0, "Baş üst HUD altında değil ve orta üstte (y=%.1f)" % p_bas.y)
	_dogrula(p_gogus.y <= KapiEkrani.KONUSMA.position.y - 30.0, "Gövde/göğüs konuşma paneli altında değil (y=%.1f <= %.1f)" % [p_gogus.y, KapiEkrani.KONUSMA.position.y - 30.0])
	_dogrula(p_bel.y <= KapiEkrani.KONUSMA.position.y + 10.0, "Bel seviyesi konuşma kutusunun çok altında değil (y=%.1f)" % p_bel.y)

	if png_dizin != "":
		await RenderingServer.frame_post_draw
		var gun_img := get_viewport().get_texture().get_image()
		gun_img.save_png(png_dizin.path_join(png_on + "_gunduz.png"))

		s.queue_free()
		await get_tree().process_frame
		var s_gece := KapiSahnesi.new()
		s_gece.gece = 2
		s_gece.perde = 1
		s_gece.sur = 1
		s_gece.gunduz = false
		ekran._vp.add_child(s_gece)
		s_gece.kuyruk_doldur(["chr_002", "chr_003", "chr_004"])
		var fg := Dunya3B.karakter("chr_002")
		fg.position = KapiSahnesi.DURMA + Vector3(0.0, s_gece.ayak_zemini_yuksekligi(KapiSahnesi.DURMA), 0.0)
		s_gece.add_child(fg)
		fg.bak(s_gece.kamera.position)
		s_gece._gelen = fg
		s_gece.kamera.h_offset = KapiEkrani.KAMERA_KAYMA
		for _i in 4:
			await get_tree().process_frame
		await RenderingServer.frame_post_draw
		var gece_img := get_viewport().get_texture().get_image()
		gece_img.save_png(png_dizin.path_join(png_on + "_gece.png"))

	print("CIL-25 KAPI SAHNE ÇAKIŞMA & KADRAJ: GEÇTİ" if _hata == 0 else "CIL-25 KAPI SAHNE ÇAKIŞMA & KADRAJ: KALDI (%d hata)" % _hata)
	get_tree().quit(0 if _hata == 0 else 1)


func _aabb_tara(ts: KapiSahnesi, sur_sv: int) -> void:
	var parcalar: Array[Dictionary] = []
	for cocuk in ts.get_children():
		if not (cocuk is Node3D):
			continue
		var n := cocuk as Node3D
		if n == ts.manzara or n is Camera3D or n is DirectionalLight3D:
			continue
		if n == ts.cerceve:
			for cc in n.get_children():
				if cc is Node3D and not (cc is OmniLight3D):
					var cn := cc as Node3D
					if cn is MeshInstance3D and ts.cerceve._esik_yuzeyleri.has(cn as MeshInstance3D):
						continue
					var kutu := _dunya_aabb(cn)
					if kutu.size.length() > 0.02:
						parcalar.append({"ad": "cerceve/" + String(cn.name), "kutu": kutu})
		else:
			var kutu := _dunya_aabb(n)
			if kutu.size.length() > 0.02:
				parcalar.append({"ad": "sahne/" + String(n.name), "kutu": kutu})
	var cakisma := 0
	for i in parcalar.size():
		for j in range(i + 1, parcalar.size()):
			var a: Dictionary = parcalar[i]
			var b: Dictionary = parcalar[j]
			var ic: AABB = (a["kutu"] as AABB).intersection(b["kutu"] as AABB)
			if ic.size.x > 0.01 and ic.size.y > 0.01 and ic.size.z > 0.01:
				cakisma += 1
				print("  [SUR=%d CAKISMA] %s <-> %s kesisim=%s" % [sur_sv, a["ad"], b["ad"], ic.size])
	_dogrula(cakisma == 0, "sur=%d kapı sahnesinde %d adet >1cm iç içe geçme var" % [sur_sv, cakisma])


func _dunya_aabb(n: Node3D) -> AABB:
	var birlesik := AABB()
	var var_mi := false
	if n is MeshInstance3D:
		var mi := n as MeshInstance3D
		if mi.visible and mi.mesh != null:
			birlesik = mi.global_transform * mi.get_aabb()
			var_mi = true
	for c in n.find_children("*", "MeshInstance3D", true, false):
		var mi := c as MeshInstance3D
		if not mi.visible or mi.mesh == null:
			continue
		var k := mi.global_transform * mi.get_aabb()
		if not var_mi:
			birlesik = k
			var_mi = true
		else:
			birlesik = birlesik.merge(k)
	return birlesik
