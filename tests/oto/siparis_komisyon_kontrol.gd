## TUC-13: mevcut defterde gerçek komisyon düğmesi ve net kasalar.
extends Node
class TestAna extends Ana:
 func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  ayarlar = Ayarlar.new("user://unused_commission.cfg")
  katalog = Katalog.new()
  katalog.yukle()
  oturum = Oturum.new(katalog, 76)
  kayit = GuvenliKayit.new("user://test_commission_ui.json")
  theme = Tema.olustur(ayarlar)
func _ready() -> void:
 get_tree().create_timer(45.0).timeout.connect(func() -> void: get_tree().quit(1))
 var ana := TestAna.new()
 add_child(ana)
 var o := ana.oturum
 var y := o.yonetim
 y.gun = 3
 assert(y.siparisler.kabul(y))
 y.kaynaklar.ekle("un", 12)
 var id := String(y.siparisler.sozlesmeler.keys()[0])
 ana._koye_git()
 var e: KoyEkrani = ana._ekran
 SiparisSozlesmePaneli.ac(e)
 await get_tree().process_frame
 var b := e.find_child("siparis_komisyon_%s_20" % id.replace(":", "_"), true, false) as Button
 assert(b != null and not b.disabled and b.tooltip_text.contains("Net kamu 20, kişisel 4"))
 assert(e.find_child("siparis_teslim_" + id.replace(":", "_"), true, false) != null)
 await foto("teklif")
 var kamu := y.akce
 b.pressed.emit()
 b.pressed.emit()
 await get_tree().process_frame
 assert(y.akce == kamu + 20 and o.muhafiz_akce == 4 and y.kaynaklar.miktar("un") == 0)
 assert(y.tuccar_itibari.celep_hamdullah.puan == 10 and y.adalet == 65)
 assert(metin(e).contains("Muhafız komisyonu: 4 akçe (20%)"))
 assert(e.find_child("siparis_teslim_" + id.replace(":", "_"), true, false) == null)
 await foto("makbuz")
 ana.kayit.sil()
 ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.5).timeout
 print("SİPARİŞ KOMİSYON UI: GEÇTİ")
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
 get_viewport().get_texture().get_image().save_png(dizin.path_join("tuc13_" + ad + ".png"))
