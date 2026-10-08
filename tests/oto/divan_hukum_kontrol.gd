extends Node
class TestAna extends Ana:
 func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  ayarlar= Ayarlar.new("user://unused_divan_hukum.cfg")
  katalog=Katalog.new()
  katalog.yukle()
  oturum=Oturum.new(katalog,76)
  kayit=GuvenliKayit.new("user://test_divan_hukum_ui.json")
  theme=Tema.olustur(ayarlar)
func _ready() -> void:
 process_mode=Node.PROCESS_MODE_ALWAYS
 get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
 for karar in DivanHukmu.KARARLAR:
  var ana:=TestAna.new()
  add_child(ana)
  var y:=ana.oturum.yonetim
  var g:=ana.oturum._adli_gelen(&"chr_001")
  var rr:=ana.oturum.karar_ver(g,&"kabul")
  var k:=y.koylu(rr.koylu_id)
  CasusGeceTakibi.kaydet(y,k,"ambar",-1,"kundaklama","gida",0,true)
  ana._koye_git()
  var e: KoyEkrani=ana._ekran
  var hedef:=e.sahne3b.hedef
  var uzak:=e.sahne3b.uzaklik
  var stok:=y.kaynaklar.kaydet()
  e._hiz_sec(2)
  var d:=DivanBaglantisi.ac(e)
  assert(d!=null and get_tree().paused)
  d.sec(k.id)
  var dugmeler:=d._liste.find_children("hukum_*","Button",true,false)
  assert(dugmeler.size()==3)
  for b in dugmeler: assert(not b.disabled and b.text.contains("Moral"))
  d._liste.find_children("hukum_"+String(karar),"Button",true,false)[0].pressed.emit()
  await get_tree().process_frame
  await get_tree().process_frame
  assert(not get_tree().paused and Engine.time_scale==2.0 and not e.has_node("DivanEkrani") and not e.sahne3b.has_node("divan_meydani"))
  assert(e.sahne3b.hedef==hedef and e.sahne3b.uzaklik==uzak and y.kaynaklar.kaydet()==stok)
  assert(DivanHukmu.durum(y)[str(k.id)].karar==karar)
  if karar=="zindan":
   assert(DivanHukmu.zindanda(k) and not e.sahne3b.halk_hareketi.modeller[k.id].visible)
   assert(e.sahne3b._yapilar.find_children("zindan_kutu","MeshInstance3D",true,false).size()==1)
   var dizin:=OS.get_environment("ADMIN_TEST_CIKTI")
   if not dizin.is_empty() and DisplayServer.get_name()!="headless":
    await get_tree().create_timer(0.5).timeout
    await RenderingServer.frame_post_draw
    get_viewport().get_texture().get_image().save_png(dizin.path_join("cas07_zindan.png"))
  else: assert(y.koylu(k.id)==null and not e.sahne3b.halk_hareketi.modeller.has(k.id))
  e._hiz_sec(1)
  ana.kayit.sil()
  ana.queue_free()
  await get_tree().process_frame
  await get_tree().create_timer(0.2).timeout
 print("DIVAN HUKUM UI: GEÇTİ")
 await Ses.cik(0)
