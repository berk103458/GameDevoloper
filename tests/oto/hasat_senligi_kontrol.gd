extends Node
class TestAna extends Ana:
 func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  ayarlar = Ayarlar.new("user://unused_harvest.cfg")
  katalog = Katalog.new()
  katalog.yukle()
  oturum = Oturum.new(katalog, 76)
  kayit = GuvenliKayit.new("user://test_harvest_ui.json")
  theme = Tema.olustur(ayarlar)
func _ready() -> void:
 get_tree().create_timer(45.0).timeout.connect(func() -> void: get_tree().quit(1))
 var ana:=TestAna.new()
 add_child(ana)
 var y:=ana.oturum.yonetim
 for i in 3:
  var k:=y.kabul({"ad":"Hasat köylüsü","stat":5})
  k.moral=40
 y.gun=14
 y.kaynaklar.ekle("gida",y.kaynaklar.bos_yer())
 ana._koye_git()
 var e:KoyEkrani=ana._ekran
 e._geceye_gec()
 await get_tree().process_frame
 assert(y.koylular.all(func(k:Koylu)->bool:return k.moral==100) and e.hud._huzur_bar.value==100)
 var bulundu:=false
 for l in e.find_children("*","Label",true,false):
  if l.text.contains("hasat şenliği"):bulundu=true
 assert(bulundu)
 var dizin:=OS.get_environment("ADMIN_TEST_CIKTI")
 if not dizin.is_empty() and DisplayServer.get_name()!="headless":
  await get_tree().create_timer(0.5).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(dizin.path_join("mev08_hasat.png"))
 ana.kayit.sil()
 ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.5).timeout
 print("HASAT ŞENLİĞİ UI: GEÇTİ")
 await Ses.cik(0)
