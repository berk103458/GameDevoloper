extends Node
class TestAna extends Ana:
 func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  ayarlar=Ayarlar.new("user://unused_cas10.cfg")
  katalog=Katalog.new()
  katalog.yukle()
  oturum=Oturum.new(katalog,73)
  kayit=GuvenliKayit.new("user://test_haksizlik_ui.json")
  theme=Tema.olustur(ayarlar)
func _ready() -> void:
 process_mode=Node.PROCESS_MODE_ALWAYS
 get_tree().create_timer(45.0).timeout.connect(func() -> void: get_tree().quit(1))
 var ana:=TestAna.new()
 add_child(ana)
 var o:=ana.oturum
 var y:=o.yonetim
 var k:=y.kabul({"ad":"Masum komşu","adli_id":"chr_003"})
 FisiltiGazetesi.gece(y,[])
 assert(o.olay_uygula(o.olay_sec(),0).ok)
 ana._koye_git()
 var e: KoyEkrani=ana._ekran
 var d:=DivanBaglantisi.ac(e)
 d.sec(k.id)
 assert(d._liste.find_children("hukum_infaz","Button",true,false)[0].disabled)
 assert(d._liste.find_children("hukum_surgun","Button",true,false)[0].disabled)
 var z:=d._liste.find_children("hukum_zindan","Button",true,false)[0] as Button
 assert(not z.disabled)
 var uyari:=false
 for l in d._liste.find_children("*","Label",true,false):
  if l.text.contains("haksız yargıdır"): uyari=true
 assert(uyari and d._liste.find_children("divan_sorgula","Button",true,false)[0].disabled)
 z.pressed.emit()
 await get_tree().process_frame
 await get_tree().process_frame
 assert(DivanHukmu.zindanda(k) and not get_tree().paused)
 y.akce=0
 d=DivanBaglantisi.ac(e)
 d.sec(k.id)
 assert(d._bilgi.text.contains("Zindan hükmü kayıtta") and e.sahne3b.halk_hareketi.modeller[k.id].visible)
 assert(d._liste.find_children("haksiz_tazmin","Button",true,false)[0].disabled)
 y.akce=15
 d.sec(k.id)
 var t:=d._liste.find_children("haksiz_tazmin","Button",true,false)[0] as Button
 assert(not t.disabled and t.text.contains("kamu"))
 var dizin:=OS.get_environment("ADMIN_TEST_CIKTI")
 if not dizin.is_empty() and DisplayServer.get_name()!="headless":
  await get_tree().create_timer(0.5).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(dizin.path_join("cas10_tazmin.png"))
 t.pressed.emit()
 await get_tree().process_frame
 await get_tree().process_frame
 assert(not get_tree().paused and not DivanHukmu.zindanda(k) and y.akce==5 and e.sahne3b.halk_hareketi.modeller[k.id].visible and DivanOturumu.adaylar(y).is_empty())
 ana.kayit.sil()
 ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.5).timeout
 print("DIVAN HAKSIZLIK UI: GEÇTİ")
 await Ses.cik(0)
