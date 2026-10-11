extends Node
class TestAna extends Ana:
 func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  ayarlar = Ayarlar.new("user://unused_fisilti.cfg")
  katalog = Katalog.new()
  katalog.yukle()
  oturum = Oturum.new(katalog, 76)
  kayit = GuvenliKayit.new("user://test_fisilti_ui.json")
  theme = Tema.olustur(ayarlar)
func _ready() -> void:
 get_tree().create_timer(45.0).timeout.connect(func() -> void: get_tree().quit(1))
 var ana := TestAna.new()
 add_child(ana)
 var o := ana.oturum
 var y := o.yonetim
 var bina := KoyBinasi.new()
 bina.id = 17
 bina.tur = "ambar"
 y.binalar.append(bina)
 var k := y.kabul({"ad":"Masum komşu","adli_id":"chr_003"})
 FisiltiGazetesi.gece(y,[])
 ana._koye_git()
 var e: KoyEkrani = ana._ekran
 var olay := o.olay_sec()
 e._olay_goster(olay,{})
 var al := dugme(e,"Pusulayı arşivle")
 assert(al != null and not al.disabled)
 var kamu := y.akce
 var stok := y.kaynaklar.kaydet()
 var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
 if not dizin.is_empty() and DisplayServer.get_name() != "headless":
  await get_tree().create_timer(0.5).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(dizin.path_join("cas09_pusula.png"))
 al.pressed.emit()
 await get_tree().process_frame
 assert(not FisiltiGazetesi.durum(y).bekliyor and y.akce == kamu and y.kaynaklar.kaydet() == stok and CasusGeceTakibi.acik_izler(y).is_empty() and not DivanHukmu.verildi(y,k.id) and k.ad=="Masum komşu")
 var once := JSON.stringify(o.kaydet())
 assert(not o.olay_uygula(olay,0).ok and JSON.stringify(o.kaydet()) == once)
 ana.kayit.sil()
 ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.5).timeout
 print("FISILTI UI: GEÇTİ")
 await Ses.cik(0)
func dugme(e: KoyEkrani, metin: String) -> Button:
 for b in e.find_children("*", "Button", true, false):
  if b.text.contains(metin) and not b.is_queued_for_deletion(): return b
 return null
