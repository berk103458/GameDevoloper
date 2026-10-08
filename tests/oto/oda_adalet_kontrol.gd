extends Node
func _ready() -> void:
 get_tree().create_timer(45.0).timeout.connect(func() -> void: get_tree().quit(1))
 var kat:=Katalog.new()
 kat.yukle()
 var o:=Oturum.new(kat,981)
 o.muhafiz_akce=40
 o.muhafiz_tecrubesi=8
 o.yonetim.adalet=80
 var kok:=Control.new()
 kok.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 var a:=Ayarlar.new()
 kok.theme=Tema.olustur(a)
 add_child(kok)
 var oda:=MuhafizOdasiEkrani.new()
 oda.oturum=o
 kok.add_child(oda)
 var keskin:=oda.find_children("yetenek_keskin_bakis","Button",true,false)[0] as Button
 assert(not keskin.disabled and oda.find_children("yetenek_gonul_bagi","Button",true,false)[0].disabled)
 keskin.pressed.emit()
 await get_tree().process_frame
 var gonul:=oda.find_children("yetenek_gonul_bagi","Button",true,false)[0] as Button
 assert(not gonul.disabled)
 gonul.pressed.emit()
 await get_tree().process_frame
 assert(o.muhafiz_akce==10 and oda.find_children("oda_yetenekleri","VBoxContainer",true,false).size()==1)
 var sc:=oda.find_children("oda_kaydir","ScrollContainer",true,false)[0] as ScrollContainer
 sc.scroll_vertical=350
 var dizin:=OS.get_environment("ADMIN_TEST_CIKTI")
 if not dizin.is_empty() and DisplayServer.get_name()!="headless":
  await get_tree().create_timer(0.5).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(dizin.path_join("oda06_adalet.png"))
 oda.queue_free()
 await get_tree().process_frame
 var e:=KapiEkrani.new()
 e.oturum=o
 e.ayarlar=a
 kok.add_child(e)
 var g:=o._adli_gelen(&"chr_001")
 e._gelen=g
 e._sohbet_goster()
 var s:=g.chr_sorgusu() as ChrSorgusu
 var source:=JSON.stringify(s.karakter.obje_1)
 var tansiyon:=s.tansiyon
 var rng:=o.yonetim._rng.state
 var cash:=o.muhafiz_akce
 assert(s.ipuclari.is_empty())
 (e._eylemler.get_child(0) as Button).pressed.emit()
 await get_tree().process_frame
 var p:=e.get_node("ChrInceleme")
 assert(p.has_node("EsyaDetayKarti") and s.ipuclari.size()==1 and s.ipuclari.has(s.karakter.obje_ipucu(1)))
 assert(not s.ipuclari.has(s.karakter.obje_ipucu(2)) and not s.ipuclari.has(s.karakter.gorsel_hata_ipucu))
 assert(JSON.stringify(s.karakter.obje_1)==source and s.tansiyon==tansiyon and o.muhafiz_akce==cash and o.yonetim._rng.state==rng)
 p.queue_free()
 await get_tree().process_frame
 (e._eylemler.get_child(0) as Button).pressed.emit()
 await get_tree().process_frame
 assert(s.ipuclari.size()==1)
 if not dizin.is_empty() and DisplayServer.get_name()!="headless":
  await get_tree().create_timer(0.5).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(dizin.path_join("oda06_inceleme.png"))
 e.get_node("ChrInceleme").queue_free()
 await get_tree().process_frame
 var genel:=Gelen.new()
 genel.ad_anahtari=&"ad.koylu"
 genel.heybe=Heybe.new()
 genel.heybe.ekle("akce","akce",1,3,true)
 e._gelen=genel
 e._heybe_ac()
 await get_tree().process_frame
 assert(e._heybe_paneli!=null and genel.heybe.yakalandi() and not genel.heybe.alinan_var() and e._yalan_yazildi and o.muhafiz_akce==cash)
 e._heybe_paneli.kapandi.emit()
 await get_tree().process_frame
 assert(e._heybe_paneli==null)
 kok.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.8).timeout
 print("ODA ADALET UI: GEÇTİ")
 await Ses.cik(0)
