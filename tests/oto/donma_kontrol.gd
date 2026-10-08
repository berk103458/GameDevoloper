extends Node
class TestAna extends Ana:
 func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  ayarlar = Ayarlar.new("user://unused_frost.cfg")
  katalog = Katalog.new()
  katalog.yukle()
  oturum = Oturum.new(katalog, 76)
  kayit = GuvenliKayit.new("user://test_frost_ui.json")
  theme = Tema.olustur(ayarlar)
func _ready() -> void:
 get_tree().create_timer(45.0).timeout.connect(func() -> void: get_tree().quit(1))
 var ana := TestAna.new()
 add_child(ana)
 var y := ana.oturum.yonetim
 y.gun = 21
 y.kaynaklar.azalt("odun", 1000)
 y.kaynaklar.ekle("gida", 50)
 for i in 7:
  var k := y.kabul({"ad": "Soğuk köylüsü %d" % i, "stat": 5})
  k.saglik = 1
  k.moral = 50
 ana._koye_git()
 var e: KoyEkrani = ana._ekran
 await get_tree().process_frame
 e._yenile()
 var odun: KaynakGostergesi = e.hud._stok_etiketleri["odun"]
 assert(odun.tooltip_text.contains("donma eşiğinde 3 kişi") and odun.tooltip_text.contains("Gecelik ihtiyaç: 7"))
 var once := JSON.stringify(ana.oturum.kaydet())
 var hareket := InputEventMouseMotion.new()
 hareket.position = get_viewport().get_final_transform() * (odun.global_position + odun.size / 2.0)
 hareket.global_position = hareket.position
 hareket.window_id = get_window().get_window_id()
 Input.parse_input_event(hareket)
 await get_tree().create_timer(1.2).timeout
 assert(JSON.stringify(ana.oturum.kaydet()) == once)
 var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
 if not dizin.is_empty() and DisplayServer.get_name() != "headless":
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(dizin.path_join("mev02_donma.png"))
 var rapor := y.gece()
 assert(rapor.olenler.size() == 3 and y.nufus() == 4 and rapor.tuketim.odun == 0 and rapor.tuketim.gida == 7)
 e._yenile()
 await get_tree().process_frame
 assert(e.hud._nufus.text.contains("4"))
 ana.kayit.sil()
 ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.5).timeout
 print("DONMA UI: GEÇTİ")
 await Ses.cik(0)
