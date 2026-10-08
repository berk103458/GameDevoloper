extends Node
class TestAna extends Ana:
 func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  ayarlar = Ayarlar.new("user://unused_caravan_guard.cfg")
  katalog = Katalog.new()
  katalog.yukle()
  oturum = Oturum.new(katalog, 76)
  kayit = GuvenliKayit.new("user://test_caravan_guard_ui.json")
  theme = Tema.olustur(ayarlar)
func _ready() -> void:
 get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
 var ana := TestAna.new()
 add_child(ana)
 var y := ana.oturum.yonetim
 y.akce = 1000
 y.kaynaklar.kapasite = 10000
 for t in ["odun", "tas", "kereste", "gida"]: y.kaynaklar.ekle(t, 100)
 var kisla := kur(y)
 var k := y.kabul({"ad": "Kervan nöbetçisi", "sinif": "asker", "stat": 5})
 assert(y.ata(k.id, kisla.id))
 y.gun = 3
 ana._koye_git()
 var e: KoyEkrani = ana._ekran
 e._pazar_ac()
 await get_tree().process_frame
 var b := e.find_child("kervan_koruma_" + str(k.id), true, false) as Button
 assert(b != null and not b.disabled)
 var kamu := y.akce
 b.pressed.emit()
 b.pressed.emit()
 await get_tree().process_frame
 var h := e.sahne3b.halk_hareketi
 h.set_process(false)
 h._process(0.0)
 assert(y.akce == kamu + 12 and ana.oturum.muhafiz_akce == 0 and y.etkin_muhafiz_sayisi() == 0)
 assert(not h.modeller[k.id].visible and h.eylem(k.id) == "Kervan korumasında")
 assert(metin(e).contains("Güvenlik 85") and metin(e).contains("7. gün döner"))
 await foto("gorev")
 y.gun = 6
 e.sahne3b.yenile()
 h._process(0.0)
 e._pazar_ac()
 await get_tree().process_frame
 assert(h.modeller[k.id].visible and y.etkin_muhafiz_sayisi() == 1 and StatEnjektoru.oku(ana.oturum, "Guvenlik") == 90 and k.is_yeri == kisla.id)
 await foto("donus")
 ana.kayit.sil()
 ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.5).timeout
 print("KERVAN KORUMA UI: GEÇTİ")
 await Ses.cik(0)
func metin(n: Node) -> String:
 var s: String = n.text if n is Label else ""
 for c in n.get_children():
  if not c.is_queued_for_deletion(): s += " " + metin(c)
 return s
func foto(ad: String) -> void:
 var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
 if dizin.is_empty() or DisplayServer.get_name() == "headless": return
 await get_tree().create_timer(0.5).timeout
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png(dizin.path_join("tuc15_" + ad + ".png"))
func kur(y: KoyYonetimi) -> KoyBinasi:
 for cy in y.a.izgara_boyut.y:
  for cx in y.a.izgara_boyut.x:
   var h := Vector2i(cx, cy)
   if y.yerlesim("muhafiz_kislasi", h).olur:
    var b := y.bina(y.bina_kur("muhafiz_kislasi", h).id)
    b.insa_kalan = 0
    return b
 assert(false)
 return null
