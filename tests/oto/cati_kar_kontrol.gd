extends Node
class TestAna extends Ana:
 func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  ayarlar = Ayarlar.new("user://unused_roof.cfg")
  katalog = Katalog.new()
  katalog.yukle()
  oturum = Oturum.new(katalog, 76)
  kayit = GuvenliKayit.new("user://test_roof_ui.json")
  theme = Tema.olustur(ayarlar)
func _ready() -> void:
 get_tree().create_timer(45.0).timeout.connect(func() -> void: get_tree().quit(1))
 var ana := TestAna.new()
 add_child(ana)
 var y := ana.oturum.yonetim
 for t in ["odun", "tas", "kereste"]: y.kaynaklar.ekle(t, 50)
 var b := kur(y)
 assert(b != null)
 var k := y.kabul({"ad":"Kürekçi", "sinif":"ciftci", "stat":5})
 y.gun = 27
 b.cati_kar.yuk = 2.0
 var once := JSON.stringify(ana.oturum.kaydet())
 ana._koye_git()
 var s: KoyYonetimSahnesi = ana._ekran.sahne3b
 var h := s.halk_hareketi
 h.set_process(false)
 await get_tree().process_frame
 h._bekleyen.clear()
 h._planla(k.id)
 var d: Dictionary = h._durum[k.id]
 var f: KarakterModel = h.modeller[k.id]
 assert(d.devriye and d.devriye_ad.contains("Çatı karını") and not d.yol.is_empty())
 assert(f.get_node_or_null("cati_kar_rutini") != null)
 var ekipman := KarakterEkipmanYoneticisi.al(f)
 assert(ekipman.stok.has("kar_kuregi") and ekipman.stok.kar_kuregi.visible and ekipman.stok.kar_kuregi.global_position.distance_to(f.global_position) < 2.0)
 h._planla(k.id)
 assert(f.find_children("cati_kar_rutini", "", false, false).size() == 1 and JSON.stringify(ana.oturum.kaydet()) == once)
 for adim in range(d.yol.size() + 1):
  if int(d.adim) >= d.yol.size(): break
  f.position = d.yol[d.adim]
  h._process(0.0)
 f.yurumeyi_durdur()
 assert(h.eylem(k.id).contains("Çatı karını"))
 var e: KoyEkrani = ana._ekran
 e._secili_bina = b.id
 e._bilgi_goster()
 assert(e._bilgi_icerik.get_node("cati_kar_bilgisi").text.contains("kürekle temizleyecek"))
 var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
 if not dizin.is_empty() and DisplayServer.get_name() != "headless":
  s.set_process(false)
  s.kamera.global_position = f.global_position + Vector3(3, 2.6, 4)
  s.kamera.look_at(f.global_position + Vector3(0, 0.8, 0))
  await get_tree().create_timer(0.7).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(dizin.path_join("mev05_kurek.png"))
 var rapor := y.gece()
 assert(y.bina(b.id) != null and b.cati_kar.yuk == 1.0 and not rapor.olaylar.is_empty())
 h.faz(&"gece")
 h._planla(k.id)
 await get_tree().process_frame
 assert(f.get_node_or_null("cati_kar_rutini") == null)
 ana.kayit.sil()
 ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.5).timeout
 print("ÇATI KAR UI: GEÇTİ")
 await Ses.cik(0)
func kur(y: KoyYonetimi) -> KoyBinasi:
 for cy in y.a.izgara_boyut.y:
  for cx in y.a.izgara_boyut.x:
   var h := Vector2i(cx, cy)
   if y.yerlesim("kulube", h).olur:
    var b := y.bina(y.bina_kur("kulube", h).id)
    b.insa_kalan = 0
    return b
 return null
