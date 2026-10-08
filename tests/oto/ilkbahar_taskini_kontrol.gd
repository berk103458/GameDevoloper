extends Node
class TestAna extends Ana:
 func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  ayarlar = Ayarlar.new("user://unused_flood.cfg")
  katalog = Katalog.new()
  katalog.yukle()
  oturum = Oturum.new(katalog, 76)
  kayit = GuvenliKayit.new("user://test_flood_ui.json")
  theme = Tema.olustur(ayarlar)
func _ready() -> void:
 get_tree().create_timer(45.0).timeout.connect(func() -> void: get_tree().quit(1))
 var ana := TestAna.new()
 add_child(ana)
 var o := ana.oturum
 var y := o.yonetim
 y.kabul({"ad":"Su köylüsü", "sinif":"ciftci", "stat":5})
 y.gun = 28
 IlkbaharTaskini.gece(y, [])
 ana._koye_git()
 var e: KoyEkrani = ana._ekran
 var olay := o.olay_sec()
 e._olay_goster(olay, {})
 var onar := dugme(e, "Bendi onar")
 assert(onar != null and onar.disabled)
 e._kart_kapat()
 await get_tree().process_frame
 y.kaynaklar.ekle("tas", 4)
 y.kaynaklar.ekle("kirec", 2)
 e._olay_goster(olay, {})
 onar = dugme(e, "Bendi onar")
 assert(not onar.disabled)
 var tas := y.kaynaklar.miktar("tas")
 var kirec := y.kaynaklar.miktar("kirec")
 var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
 if not dizin.is_empty() and DisplayServer.get_name() != "headless":
  await get_tree().create_timer(0.5).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(dizin.path_join("mev06_bent.png"))
 onar.pressed.emit()
 await get_tree().process_frame
 assert(not IlkbaharTaskini.durum(y).hasar and y.kaynaklar.miktar("tas") == tas-4 and y.kaynaklar.miktar("kirec") == kirec-2)
 var bulundu := false
 for l in e.find_children("*", "Label", true, false):
  if l.text.contains("Su bendi onarıldı"): bulundu = true
 assert(bulundu)
 var once := JSON.stringify(o.kaydet())
 assert(not o.olay_uygula(olay, 0).ok and JSON.stringify(o.kaydet()) == once)
 ana.kayit.sil()
 ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.5).timeout
 print("İLKBAHAR TAŞKINI UI: GEÇTİ")
 await Ses.cik(0)
func dugme(e: KoyEkrani, metin: String) -> Button:
 for b in e.find_children("*", "Button", true, false):
  if b.text.contains(metin) and not b.is_queued_for_deletion(): return b
 return null
