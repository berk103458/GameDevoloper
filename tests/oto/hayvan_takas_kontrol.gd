extends Node
class TestAna extends Ana:
 func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  ayarlar = Ayarlar.new("user://unused_animal_trade.cfg")
  katalog = Katalog.new()
  katalog.yukle()
  oturum = Oturum.new(katalog, 76)
  kayit = GuvenliKayit.new("user://test_animal_trade_ui.json")
  theme = Tema.olustur(ayarlar)
func _ready() -> void:
 get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
 var ana := TestAna.new()
 add_child(ana)
 var y := ana.oturum.yonetim
 y.akce = 1000
 y.kaynaklar.kapasite = 10000
 for t in ["odun", "tas", "gida"]: y.kaynaklar.ekle(t, 100)
 y.kabul({"ad": "Çoban", "yapi_bilgisi": ["ahir", "agil"]})
 kur(y, "ahir")
 var agil := kur(y, "agil")
 y.gun = 3
 ana._koye_git()
 var e: KoyEkrani = ana._ekran
 e._pazar_ac()
 for tur in ["okuz", "inek", "koc"]:
  await get_tree().process_frame
  var b := dugme(e, "%s al · %d akçe" % [CelepHamdullah.AYAR.hayvanlar[tur].ad, CekiLojistigi.FIYAT[tur]])
  assert(b != null and not b.disabled)
  b.pressed.emit()
 await get_tree().process_frame
 var h := e.sahne3b.halk_hareketi
 var suru := CobanSurusu._bul(h, agil.id)
 assert(suru != null and suru.koyunlar.size() == 5 and suru.adimlar.size() == 5 and suru.yollar.size() == 5)
 assert(suru.koyunlar[4].has_meta("satinalinan_koc") and suru.koyunlar[4].get_child_count() > 0)
 var makbuz := JSON.stringify(ana.oturum.kaydet())
 h.yenile()
 h.yenile()
 assert(CobanSurusu._bul(h, agil.id) == suru and suru.koyunlar.size() == 5 and JSON.stringify(ana.oturum.kaydet()) == makbuz)
 await foto("pazar")
 var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
 if not dizin.is_empty() and DisplayServer.get_name() != "headless":
  e._kart_kapat()
  e.sahne3b.set_process(false)
  e.sahne3b.kamera.size = 12.0
  e.sahne3b.kamera.position = suru.koyunlar[4].global_position + Vector3(5, 4, 7)
  e.sahne3b.kamera.look_at(suru.koyunlar[4].global_position + Vector3(0, 0.6, 0))
  await foto("suru")
  e._pazar_ac()
  await get_tree().process_frame
 var kamu := y.akce
 var geri := e.find_child("hayvan_geri_sat_koc", true, false) as Button
 assert(geri != null and not geri.disabled)
 geri.pressed.emit()
 await get_tree().process_frame
 assert(y.akce == kamu + 12 and ana.oturum.muhafiz_akce == 0 and y.lojistik.hayvanlar.koc == 0)
 assert(suru.koyunlar.size() == 4 and suru.adimlar.size() == 4 and suru.yollar.size() == 4)
 geri = e.find_child("hayvan_geri_sat_koc", true, false) as Button
 assert(geri != null and geri.disabled)
 await foto("satildi")
 ana.kayit.sil()
 ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.5).timeout
 print("HAYVAN TAKAS UI: GEÇTİ")
 await Ses.cik(0)
func foto(ad: String) -> void:
 var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
 if dizin.is_empty() or DisplayServer.get_name() == "headless": return
 await get_tree().create_timer(0.5).timeout
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png(dizin.path_join("tuc14_" + ad + ".png"))
func dugme(n: Node, text: String) -> Button:
 if n is Button and n.text == text: return n
 for c in n.get_children():
  if c.is_queued_for_deletion(): continue
  var b := dugme(c, text)
  if b != null: return b
 return null
func kur(y: KoyYonetimi, tur: String) -> KoyBinasi:
 for cy in y.a.izgara_boyut.y:
  for cx in y.a.izgara_boyut.x:
   var h := Vector2i(cx, cy)
   if y.yerlesim(tur, h).olur:
    var b := y.bina(y.bina_kur(tur, h).id)
    b.insa_kalan = 0
    return b
 assert(false)
 return null
