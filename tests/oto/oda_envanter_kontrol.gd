extends Node
class TestAna extends Ana:
 func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  ayarlar=Ayarlar.new("user://unused_oda.cfg")
  katalog=Katalog.new()
  katalog.yukle()
  oturum=Oturum.new(katalog,76)
  kayit=GuvenliKayit.new("user://test_oda_ui.json")
  theme=Tema.olustur(ayarlar)

func _ready() -> void:
 process_mode=Node.PROCESS_MODE_ALWAYS
 get_tree().create_timer(45.0).timeout.connect(func() -> void: get_tree().quit(1))
 var ana:=TestAna.new()
 add_child(ana)
 var o: Oturum=ana.oturum
 o.yonetim.kabul({"ad":"Oda komşusu"})
 o.muhafiz_akce=17
 o.muhafiz_esyalari=[{"id":"karaborsa_yasak_muhur","ad":"Yasak mühür","adet":2,"son_varis":0,"ziyaret_adet":0},{"id":"bos","ad":"Satılmış eşya","adet":0}]
 var hediye:=""
 for n in range(1,31):
  var g:=o._adli_gelen(StringName("chr_%03d"%n))
  var s: ChrSorgusu=g.chr_sorgusu()
  var d: Dictionary=s.karakter.karar_verisi(&"rusvet")
  if d.get("esyalar",[]).is_empty(): continue
  hediye=String(d.esyalar[0])
  o.karar_ver(g,&"rusvet")
  break
 assert(not hediye.is_empty())
 for i in range(20): o.muhafiz_esyalari.append({"ad":"Sergi kaydı %d"%i,"adet":1000000})
 ana._koye_git()
 var e: KoyEkrani=ana._ekran
 e._hiz_sec(2)
 var once:=JSON.stringify(o.kaydet())
 var rng:=o.yonetim._rng.state
 var hedef:=e.sahne3b.hedef
 var uz:=e.sahne3b.uzaklik
 e.find_children("oda_ac","Button",true,false)[0].pressed.emit()
 var d:=e.get_node("MuhafizOdasiEkrani") as MuhafizOdasiEkrani
 assert(d!=null and get_tree().paused and d.oda!=null)
 assert(MuhafizOdasiBaglantisi.ac(e)==null and DivanBaglantisi.ac(e)==null)
 assert(d.oda.get_world_3d()!=e.sahne3b.get_world_3d())
 for isim in ["yatak","masa","mesale","gizli_kasa"]:
  assert(d.oda.get_node(isim) is MeshInstance3D and d.oda.get_node(isim).mesh is BoxMesh)
 var satirlar:=d.find_children("oda_esya_*","PanelContainer",true,false)
 assert(satirlar.size()==o.muhafiz_esyalari.size()-1)
 assert(d.find_children("esya_adi","Label",true,false)[0].text=="Yasak mühür · 2 adet")
 var hediye_gorundu:=false
 for l in d.find_children("esya_adi","Label",true,false):
  if l.text.begins_with(hediye): hediye_gorundu=true
  assert(not l.text.contains("Satılmış eşya"))
 assert(hediye_gorundu and d.oda.get_node("kisisel_esya_sergisi").get_child_count()==int(MuhafizOdasi.AYAR.sergi_azami))
 var geri:=Oturum.kayittan(ana.katalog,JSON.parse_string(JSON.stringify(o.kaydet())))
 assert(geri.muhafiz_esyalari==o.muhafiz_esyalari)
 await get_tree().process_frame
 await get_tree().process_frame
 var kaydir:=d.find_children("oda_kaydir","ScrollContainer",true,false)[0] as ScrollContainer
 assert(kaydir.get_v_scroll_bar().max_value>kaydir.get_v_scroll_bar().page)
 kaydir.scroll_vertical=int(kaydir.get_v_scroll_bar().max_value)
 await get_tree().process_frame
 var don:=d.find_children("oda_kapat","Button",true,false)[0] as Button
 assert(don.get_global_rect().end.y<=get_viewport().get_visible_rect().size.y)
 kaydir.scroll_vertical=0
 var anahtar:=InputEventKey.new()
 anahtar.keycode=KEY_P
 anahtar.physical_keycode=KEY_P
 anahtar.pressed=true
 Input.parse_input_event(anahtar)
 await get_tree().process_frame
 assert(e._ust_kart==null and JSON.stringify(o.kaydet())==once and o.yonetim._rng.state==rng)
 anahtar=InputEventKey.new()
 anahtar.keycode=KEY_1
 anahtar.physical_keycode=KEY_1
 anahtar.pressed=true
 Input.parse_input_event(anahtar)
 await get_tree().process_frame
 assert(get_tree().paused and not d.is_queued_for_deletion())
 assert(e.sahne3b.hedef==hedef and e.sahne3b.uzaklik==uz)
 var dizin:=OS.get_environment("ADMIN_TEST_CIKTI")
 if not dizin.is_empty() and DisplayServer.get_name()!="headless":
  await get_tree().create_timer(0.5).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(dizin.path_join("oda03_sergi.png"))
 d.find_children("oda_kapat","Button",true,false)[0].pressed.emit()
 await get_tree().process_frame
 assert(not get_tree().paused and Engine.time_scale==2.0 and not e.has_node("MuhafizOdasiEkrani"))
 e._hiz_sec(0)
 o.muhafiz_esyalari=[]
 d=MuhafizOdasiBaglantisi.ac(e)
 assert(d!=null)
 assert(d.oda.get_node("kisisel_esya_sergisi").get_child_count()==0 and d.find_children("oda_envanter_bos","Label",true,false).size()==1)
 anahtar=InputEventKey.new()
 anahtar.keycode=KEY_ESCAPE
 anahtar.physical_keycode=KEY_ESCAPE
 anahtar.pressed=true
 Input.parse_input_event(anahtar)
 await get_tree().process_frame
 await get_tree().process_frame
 assert(not e.has_node("MuhafizOdasiEkrani") and get_tree().paused)
 e._hiz_sec(1)
 var divan:=DivanBaglantisi.ac(e)
 assert(divan!=null and MuhafizOdasiBaglantisi.ac(e)==null)
 divan.queue_free()
 await get_tree().process_frame
 e._kart_ac("Mevcut olay")
 assert(MuhafizOdasiBaglantisi.ac(e)==null)
 e._kart_kapat()
 await get_tree().process_frame
 o.yonetim.son=&"isyan"
 assert(MuhafizOdasiBaglantisi.ac(e)==null)
 ana.kayit.sil()
 ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.5).timeout
 print("ODA ENVANTER UI: GEÇTİ")
 await Ses.cik(0)
