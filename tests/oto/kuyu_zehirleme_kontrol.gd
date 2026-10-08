extends Node
class TestAna extends Ana:
 func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  ayarlar = Ayarlar.new("user://unused_cas03.cfg")
  katalog = Katalog.new()
  katalog.yukle()
  oturum = Oturum.new(katalog, 76)
  kayit = GuvenliKayit.new("user://test_kuyu_zehir_ui.json")
  theme = Tema.olustur(ayarlar)
func _ready() -> void:
 get_tree().create_timer(45.0).timeout.connect(func() -> void: get_tree().quit(1))
 var ana := TestAna.new()
 add_child(ana)
 var o := ana.oturum
 var y := o.yonetim
 var g := o._adli_gelen(&"chr_002")
 g.chr_sorgusu().obje_incele(2)
 var rr := o.karar_ver(g,&"kabul")
 var k := y.koylu(rr.koylu_id)
 y.gun = 2
 y.a.iyilesme = 0
 y.kaynaklar.ekle("gida",100)
 ana._koye_git()
 var e: KoyEkrani = ana._ekran
 e._gece_dugmesi.pressed.emit()
 await get_tree().process_frame
 assert(k.saglik == 96 and KuyuZehirleme.durum(y).tespit_gunu == 3)
 var bulundu := false
 for l in e.find_children("*","Label",true,false):
  if l.text.contains("Sabah kuyuda zehirlenme"):
   bulundu = true
   assert(not l.text.contains(k.ad))
 assert(bulundu and SuDengesi.tip(y).contains("1 kişi") and CasusGeceTakibi.acik_izler(y).is_empty())
 assert(SuDengesi.tip(y).contains("keşfedilmiş zehir malzemesi yük ipucu: 1"))
 var once := JSON.stringify(o.kaydet())
 e._gece_dugmesi.pressed.emit()
 assert(JSON.stringify(o.kaydet()) == once)
 var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
 if not dizin.is_empty() and DisplayServer.get_name() != "headless":
  await get_tree().create_timer(1.9).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(dizin.path_join("cas03_zehir.png"))
 ana.kayit.sil()
 ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.5).timeout
 print("KUYU ZEHİR UI: GEÇTİ")
 await Ses.cik(0)
