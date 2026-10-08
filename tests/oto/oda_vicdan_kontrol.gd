extends Node
func _ready() -> void:
 get_tree().create_timer(45.0).timeout.connect(func() -> void: get_tree().quit(1))
 var kat:=Katalog.new()
 kat.yukle()
 var o:=Oturum.new(kat,372)
 for i in 2: o.karar_ver(Gelen.new(),&"ret")
 o.yonetim.kabul({"ad":"Yaşayan tanık"})
 o.yonetim.kaynaklar.ekle("gida",100)
 o.yonetim.kaynaklar.ekle("su",100)
 o.gece_sonu()
 var once:=JSON.stringify(o.kaydet())
 var rng:=o._rng.state
 var kok:=Control.new()
 kok.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 kok.theme=Tema.olustur(Ayarlar.new())
 add_child(kok)
 var oda:=MuhafizOdasiEkrani.new()
 oda.oturum=o
 kok.add_child(oda)
 assert(oda.oda.has_node("kabus_golgesi") and oda.oda.get_node("kabus_golgesi").mesh is BoxMesh)
 var l:=oda.find_children("oda_vicdan","Label",true,false)[0] as Label
 assert(l.text.contains("bir rüya") and l.text.contains("haksız ret 2"))
 assert(JSON.stringify(o.kaydet())==once and o._rng.state==rng)
 var sc:=oda.find_children("oda_kaydir","ScrollContainer",true,false)[0] as ScrollContainer
 await get_tree().process_frame
 await get_tree().process_frame
 sc.scroll_vertical=int(sc.get_v_scroll_bar().max_value)
 await get_tree().process_frame
 assert(l.get_global_rect().intersects(sc.get_global_rect()))
 var dizin:=OS.get_environment("ADMIN_TEST_CIKTI")
 if not dizin.is_empty() and DisplayServer.get_name()!="headless":
  await get_tree().create_timer(0.5).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(dizin.path_join("oda09_kabus.png"))
 oda.queue_free()
 await get_tree().process_frame
 o.gun+=1
 oda=MuhafizOdasiEkrani.new()
 oda.oturum=o
 kok.add_child(oda)
 assert(not oda.oda.has_node("kabus_golgesi"))
 kok.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.5).timeout
 print("ODA VICDAN UI: GEÇTİ")
 await Ses.cik(0)
