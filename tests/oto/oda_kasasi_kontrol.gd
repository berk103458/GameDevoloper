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
 var chr:=o._adli_gelen(&"chr_001")
 o.karar_ver(chr,&"rusvet")
 assert(o.muhafiz_akce==4)
 var g:=Gelen.new()
 g.id=&"kasa_test"
 g.heybe=Heybe.new()
 g.heybe.ekle("akce","akce",1,3,false)
 g.heybe.ekle("gida","gida",2,2,false)
 g.heybe.al(g.heybe.esyalar[0],3)
 g.heybe.al(g.heybe.esyalar[1],2)
 o.karar_ver(g,&"rusvet")
 assert(o.muhafiz_akce==7 and o.muhafiz_esyalari[0].adet==2)
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
  var parca := d.oda.get_node(isim) as Node3D
  assert(parca != null)
  if isim in ["yatak", "masa"]:
   assert(parca is MeshInstance3D or not parca.find_children("*", "MeshInstance3D", true, false).is_empty())
  else:
   assert(parca is MeshInstance3D and parca.mesh is BoxMesh)
 var kasa:=d.find_children("oda_kasa_ac","Button",true,false)[0] as Button
 var alan:=d.find_children("oda_kasasi","VBoxContainer",true,false)[0]
 var kapak:=d.oda.get_node("gizli_kasa") as MeshInstance3D
 var kapak_once:=kapak.transform
 assert(not alan.visible)
 kasa.button_pressed=true
 assert(alan.visible and kapak.transform!=kapak_once)
 var kese:=d.find_children("oda_kese","VBoxContainer",true,false)[0] as KeseGostergesi
 assert(kese._miktar.text=="7 akçe" and d.find_children("oda_kasa_esya","Label",true,false)[0].text=="Kişisel eşya: 2 adet")
 kasa.button_pressed=false
 assert(not alan.visible and kapak.transform==kapak_once)
 kasa.button_pressed=true
 assert(kese._miktar.text=="7 akçe" and JSON.stringify(o.kaydet())==once)
 var geri:=Oturum.kayittan(ana.katalog,JSON.parse_string(JSON.stringify(o.kaydet())))
 assert(geri.muhafiz_akce==o.muhafiz_akce and geri.muhafiz_esyalari==o.muhafiz_esyalari)
 kasa.button_pressed=false
 o.muhafiz_akce=0
 o.muhafiz_esyalari=[]
 kasa.button_pressed=true
 assert(kese._miktar.text=="0 akçe" and d.find_children("oda_kasa_esya","Label",true,false)[0].text=="Kişisel eşya: 0 adet")
 kasa.button_pressed=false
 o.muhafiz_akce=geri.muhafiz_akce
 o.muhafiz_esyalari=geri.muhafiz_esyalari.duplicate(true)
 kasa.button_pressed=true
 assert(JSON.stringify(o.kaydet())==once and kese._miktar.text=="7 akçe")
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
  get_viewport().get_texture().get_image().save_png(dizin.path_join("oda02_kasa.png"))
 d.find_children("oda_kapat","Button",true,false)[0].pressed.emit()
 await get_tree().process_frame
 assert(not get_tree().paused and Engine.time_scale==2.0 and not e.has_node("MuhafizOdasiEkrani"))
 e._hiz_sec(0)
 d=MuhafizOdasiBaglantisi.ac(e)
 assert(d!=null)
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
 print("ODA KASA UI: GEÇTİ")
 await Ses.cik(0)
