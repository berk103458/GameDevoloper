extends Node
class TestAna extends Ana:
 func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  ayarlar=Ayarlar.new("user://unused_harita.cfg")
  katalog=Katalog.new()
  katalog.yukle()
  oturum=Oturum.new(katalog,1102)
  kayit=GuvenliKayit.new("user://test_harita_ui.json")
  theme=Tema.olustur(ayarlar)
func _ready() -> void:
 process_mode=Node.PROCESS_MODE_ALWAYS
 get_tree().create_timer(45).timeout.connect(func() -> void: get_tree().quit(1))
 var ana:=TestAna.new()
 add_child(ana)
 var o:=ana.oturum
 o.yonetim.kabul({"ad":"Harita tanığı"})
 o.yonetim.tekfur_baski=3
 o.yonetim.savusturulan=2
 ana._koye_git()
 var e:=ana._ekran as KoyEkrani
 e._hiz_sec(2)
 var once:=JSON.stringify(o.kaydet())
 var rng:=o.yonetim._rng.state
 var hedef:=e.sahne3b.hedef
 var uzak:=e.sahne3b.uzaklik
 assert(e.find_children("harita_ac","Button",true,false).size()==1)
 e.find_children("harita_ac","Button",true,false)[0].pressed.emit()
 var d:=e.get_node("HaritaEkrani") as HaritaEkrani
 assert(d!=null and get_tree().paused)
 assert(HaritaBaglantisi.ac(e)==null and MuhafizOdasiBaglantisi.ac(e)==null and DivanBaglantisi.ac(e)==null)
 await get_tree().process_frame
 for id in ["hisar","karaboran","tekfur","goc_yolu"]:
  var b:=d.find_children("sec_"+id,"Button",true,false)[0] as Button
  b.pressed.emit()
  assert(d._baslik.text==String(CevreHaritasi.bilgi(o,id).ad))
  assert(d._bilgi.text==String(CevreHaritasi.bilgi(o,id).metin))
 d.bolge_sec("tekfur")
 assert(d._bilgi.text.contains("3") and d._bilgi.text.contains("2"))
 for key in [KEY_P,KEY_1]:
  var olay:=InputEventKey.new()
  olay.keycode=key
  olay.physical_keycode=key
  olay.pressed=true
  Input.parse_input_event(olay)
  await get_tree().process_frame
 assert(get_tree().paused and e._ust_kart==null and JSON.stringify(o.kaydet())==once and o.yonetim._rng.state==rng)
 assert(e.sahne3b.hedef==hedef and e.sahne3b.uzaklik==uzak)
 var dizin:=OS.get_environment("ADMIN_TEST_CIKTI")
 if not dizin.is_empty() and DisplayServer.get_name()!="headless":
  await get_tree().create_timer(0.5).timeout
  await RenderingServer.frame_post_draw
  for id in ["hisar","karaboran","tekfur","goc_yolu"]:
   var n:=d._noktalar[id] as ColorRect
   assert(Rect2(Vector2.ZERO,d._alan.size).encloses(Rect2(n.position,n.size)))
  get_viewport().get_texture().get_image().save_png(dizin.path_join("har01_harita.png"))
 d.find_children("harita_kapat","Button",true,false)[0].pressed.emit()
 await get_tree().process_frame
 assert(not get_tree().paused and Engine.time_scale==2 and not e.has_node("HaritaEkrani"))
 e._hiz_sec(0)
 ana.ayarlar.degerler[&"metin_olcegi"]=150
 d=HaritaBaglantisi.ac(e)
 assert(d!=null and get_tree().paused)
 d.bolge_sec("hisar")
 await get_tree().process_frame
 await get_tree().process_frame
 assert(d._bilgi.get_theme_font_size("font_size")==ana.ayarlar.boyut(24))
 assert((d.find_children("harita_kapat","Button",true,false)[0] as Button).get_global_rect().end.y<=get_viewport().get_visible_rect().end.y)
 if not dizin.is_empty() and DisplayServer.get_name()!="headless":
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(dizin.path_join("har01_harita150.png"))
 var esc:=InputEventKey.new()
 esc.keycode=KEY_ESCAPE
 esc.pressed=true
 Input.parse_input_event(esc)
 await get_tree().process_frame
 await get_tree().process_frame
 assert(not e.has_node("HaritaEkrani") and get_tree().paused)
 e._hiz_sec(1)
 var oda:=MuhafizOdasiBaglantisi.ac(e)
 assert(oda!=null and HaritaBaglantisi.ac(e)==null)
 oda.queue_free()
 await get_tree().process_frame
 var divan:=DivanBaglantisi.ac(e)
 assert(divan!=null and HaritaBaglantisi.ac(e)==null)
 divan.queue_free()
 await get_tree().process_frame
 e._kart_ac("Mevcut olay")
 assert(HaritaBaglantisi.ac(e)==null)
 e._kart_kapat()
 await get_tree().process_frame
 o.yonetim.son="isyan"
 assert(HaritaBaglantisi.ac(e)==null)
 ana.kayit.sil()
 ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.5).timeout
 print("HARITA UI: GEÇTİ")
 await Ses.cik(0)
