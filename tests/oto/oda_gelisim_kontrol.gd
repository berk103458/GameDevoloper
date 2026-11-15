extends Node
func _ready() -> void:
 get_tree().create_timer(45.0).timeout.connect(func() -> void: get_tree().quit(1))
 var kat:=Katalog.new()
 kat.yukle()
 var o:=Oturum.new(kat,641)
 o.muhafiz_akce=75
 o.muhafiz_tecrubesi=12
 o.oda_gelisimi={"yorgunluk":80}
 var kok:=Control.new()
 kok.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 var a:=Ayarlar.new()
 kok.theme=Tema.olustur(a)
 add_child(kok)
 var e:=KapiEkrani.new()
 e.oturum=o
 e.ayarlar=a
 kok.add_child(e)
 var g:=o._adli_gelen(&"chr_001")
 e._gelen=g
 e._sohbet_goster()
 assert(g.chr_sorgusu().tecrube==8 and o.muhafiz_tecrubesi==12)
 e.queue_free()
 await get_tree().process_frame
 var oda:=MuhafizOdasiEkrani.new()
 oda.oturum=o
 kok.add_child(oda)
 var kamu:=o.koy_akce
 var stok:=o.yonetim.kaynaklar.kaydet()
 var rng:=o.yonetim._rng.state
 for id in MuhafizOdaGelisimi.GELISTIRMELER:
  var b:=oda.find_children("oda_gelistir_"+id,"Button",true,false)[0] as Button
  assert(not b.disabled)
  b.pressed.emit()
  await get_tree().process_frame
 assert(o.muhafiz_akce==15 and MuhafizOdaGelisimi.oku(o.oda_gelisimi).yorgunluk==0)
 assert(oda.find_children("oda_gelistirmeleri","VBoxContainer",true,false).size()==1 and oda.find_children("oda_yetenekleri","VBoxContainer",true,false).size()==1)
 for id in ["askilik","kutuphane"]:
  assert(oda.oda.get_node(id) is MeshInstance3D and oda.oda.get_node(id).mesh is BoxMesh)
 var saved:=JSON.stringify(o.kaydet())
 OdaGelistirmePaneli.kur(oda,oda.find_children("oda_gelistirmeleri","VBoxContainer",true,false)[0].get_parent())
 await get_tree().process_frame
 assert(JSON.stringify(o.kaydet())==saved and oda.oda.find_children("askilik","MeshInstance3D",true,false).size()==1)
 MuhafizOdaGelisimi.karar(o)
 OdaGelistirmePaneli.kur(oda,oda.find_children("oda_gelistirmeleri","VBoxContainer",true,false)[0].get_parent())
 var dinlen:=oda.find_children("oda_dinlen","Button",true,false)[0] as Button
 assert(not dinlen.disabled)
 dinlen.pressed.emit()
 await get_tree().process_frame
 assert(oda.find_children("oda_dinlen","Button",true,false)[0].disabled)
 var sc:=oda.find_children("oda_kaydir","ScrollContainer",true,false)[0] as ScrollContainer
 sc.scroll_vertical=1000
 var dizin:=OS.get_environment("ADMIN_TEST_CIKTI")
 if not dizin.is_empty() and DisplayServer.get_name()!="headless":
  await get_tree().create_timer(0.5).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(dizin.path_join("oda08_gelisim.png"))
 oda.queue_free()
 await get_tree().process_frame
 e=KapiEkrani.new()
 e.oturum=o
 e.ayarlar=a
 kok.add_child(e)
 e._gelen=g
 e._sohbet_goster()
 var sor:=g.chr_sorgusu()
 var deg:Dictionary=sor.yaklasim_degistiricisi({"beceri":"ikna"})
 # ZAR-01: tecrübe tek eşikli görünür -1 satırıdır (MuhafizSezgisi eşiği); ikinci olasılık yolu yok.
 assert(sor.tecrube==12 and String(deg.satirlar[-1].tur)=="tecrube" and sor.basari_olasiligi(int(deg.toplam))>sor.basari_olasiligi())
 assert(o.koy_akce==kamu and o.yonetim.kaynaklar.kaydet()==stok and o.yonetim._rng.state==rng)
 kok.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.8).timeout
 print("ODA GELISIM UI: GEÇTİ")
 await Ses.cik(0)
