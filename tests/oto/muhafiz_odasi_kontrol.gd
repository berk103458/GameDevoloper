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
 o.muhafiz_esyalari=[{"id":"Clue_Test","ad":"Özel kayıt","adet":2}]
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
 for isim in ["mesale","gizli_kasa"]:
  assert(d.oda.get_node(isim) is MeshInstance3D and d.oda.get_node(isim).mesh is BoxMesh)
 for isim in ["yatak", "masa"]:
  assert(d.oda.get_node(isim).has_meta("asset_yolu"))
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
  get_viewport().get_texture().get_image().save_png(dizin.path_join("oda01_oda.png"))
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
 print("MUHAFIZ ODA UI: GEÇTİ")
 await Ses.cik(0)
