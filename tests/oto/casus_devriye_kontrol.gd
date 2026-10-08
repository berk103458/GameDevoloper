extends Node
class TestAna extends Ana:
 func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  ayarlar = Ayarlar.new("user://unused_flood.cfg")
  katalog = Katalog.new()
  katalog.yukle()
  oturum = Oturum.new(katalog, 76)
  kayit = GuvenliKayit.new("user://test_casus_devriye_ui.json")
  theme = Tema.olustur(ayarlar)
func _ready() -> void:
 get_tree().create_timer(45.0).timeout.connect(func() -> void: get_tree().quit(1))
 var ana := TestAna.new()
 add_child(ana)
 var o := ana.oturum
 var y := o.yonetim
 var k := y.kabul({"ad":"Gece şüphelisi", "sinif":"ciftci"})
 var bekci := y.kabul({"ad":"Nöbetçi", "sinif":"asker"})
 y.muhafiz_ata(bekci.id)
 CasusGeceTakibi.kaydet(y,k,"ambar",-1,"hirsizlik","gida",0,true)
 CasusDevriyesi.gece(y,[])
 ana._koye_git()
 var e: KoyEkrani = ana._ekran
 e.sahne3b.halk_hareketi.faz(&"gece")
 var f: KarakterModel = e.sahne3b.halk_hareketi.modeller[bekci.id]
 var donanim := f.get_node("muhafiz_donanimi") as MuhafizDonanimi
 assert(donanim != null and donanim.mesale.visible)
 var olay := o.olay_sec()
 e._olay_goster(olay,{})
 var al := dugme(e,"Tutanağı sakla")
 assert(al != null and not al.disabled)
 var kamu := y.akce
 var stok := y.kaynaklar.kaydet()
 var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
 if not dizin.is_empty() and DisplayServer.get_name() != "headless":
  await get_tree().create_timer(0.5).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(dizin.path_join("cas02_tutanak.png"))
 al.pressed.emit()
 await get_tree().process_frame
 assert(not CasusDevriyesi.durum(y).bekliyor and y.akce == kamu and y.kaynaklar.kaydet() == stok and CasusGeceTakibi.acik_izler(y).size() == 1)
 var once := JSON.stringify(o.kaydet())
 assert(not o.olay_uygula(olay,0).ok and JSON.stringify(o.kaydet()) == once)
 ana.kayit.sil()
 ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.5).timeout
 print("CASUS DEVRİYE UI: GEÇTİ")
 await Ses.cik(0)
func dugme(e: KoyEkrani, metin: String) -> Button:
 for b in e.find_children("*", "Button", true, false):
  if b.text.contains(metin) and not b.is_queued_for_deletion(): return b
 return null
