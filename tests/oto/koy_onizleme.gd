## Köy sahnesi önizlemesi: nüfuslu bir oturumla 3D köyü kurar, saatleri ilerletip ekran görüntüsü alır.
## Ortam: KLASOR (çıktı), NUFUS (kişi sayısı), SAATLER ("16.6,18.9,21" gibi), PERDE (1/2), MESAFE (kamera m).
extends Node

func _ready() -> void:
	var klasor := OS.get_environment("KLASOR") if OS.get_environment("KLASOR") != "" else "user://koy"
	DirAccess.make_dir_recursive_absolute(klasor)
	var katalog := Katalog.new()
	katalog.yukle()
	var o := Oturum.new(katalog, 7)
	var nufus := int(OS.get_environment("NUFUS")) if OS.get_environment("NUFUS") != "" else 14
	for i in nufus:
		o.koy.ekle([&"ciftci", &"esnaf", &"asker"][i % 3] if i % 5 != 4 else &"ciftci", &"", "", "", &"kabul", 1)
	o.koy.bu_gece_girenler.clear()
	o.yapilar[&"pazar"] = 1
	o.yapilar[&"kervansaray"] = 1
	if OS.get_environment("PERDE") == "2":
		o.perde = 2
		o.perde2_gece = 5
		o.yapilar[&"sur"] = 1
	var vp := SubViewport.new()
	vp.size = Vector2i(1920, 1080)
	vp.msaa_3d = Viewport.MSAA_4X
	var kap := SubViewportContainer.new()
	kap.size = Vector2(1920, 1080)
	kap.stretch = true
	add_child(kap)
	kap.add_child(vp)
	var s := KoySahnesi.new()
	s.oturum = o
	vp.add_child(s)
	if OS.get_environment("MESAFE") != "":
		s.kamera._hedef_uzaklik = float(OS.get_environment("MESAFE"))
		s.kamera.uzaklik = s.kamera._hedef_uzaklik
	if OS.get_environment("ODAK") != "":
		var o_ := OS.get_environment("ODAK").split(",")
		s.kamera.odak = Vector3(float(o_[0]), 0, float(o_[1]))
		s.kamera._hedef_odak = s.kamera.odak
	var saatler := (OS.get_environment("SAATLER") if OS.get_environment("SAATLER") != "" else "16.6,19.0,21.2").split(",")
	for sa in saatler:
		s.saat = float(sa)
		await get_tree().create_timer(4.0).timeout
		await RenderingServer.frame_post_draw
		vp.get_texture().get_image().save_png("%s/koy_%s.png" % [klasor, sa])
		print("foto ", sa)
	get_tree().quit()
