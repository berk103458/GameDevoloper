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
 var agil := kur(y, "agil")
 y.gun = 3
 ana._koye_git()
 var e: KoyEkrani = ana._ekran
 e._pazar_ac()
 await get_tree().process_frame
 var buy := e.find_child("saman_al", true, false) as Button
 assert(buy != null and not buy.disabled)
 buy.pressed.emit()
 await get_tree().process_frame
 assert(y.kaynaklar.miktar("saman") == 10 and y.akce == 995)
 assert(e.hud._stok_etiketleri.has("saman") and e.hud._stok_etiketleri.saman.tooltip_text.contains("kışlık yem 4/gece"))
 e._kart_kapat()
 await get_tree().process_frame
 e._secili_bina = agil.id
 e._bilgi_goster()
 await get_tree().process_frame
 var et := e.find_child("saman_bilgisi", true, false) as Label
 assert(et != null and et.text.contains("Yaşayan başlangıç koyunu: 4"))
 var h := e.sahne3b.halk_hareketi
 var s := CobanSurusu._bul(h, agil.id)
 assert(s != null and s.koyunlar.size() == 4)
 var sag := s.koyunlar[0]
 y.lojistik.hayvanlar.koc = 1
 h.yenile()
 assert(s.koyunlar.size() == 5 and s.koyunlar[4].has_meta("satinalinan_koc"))
 agil.agil_koyun = 3
 h.yenile()
 assert(s.koyunlar.size() == 4 and s.koyunlar[0] == sag and s.koyunlar[3].has_meta("satinalinan_koc"))
 agil.agil_koyun = 0
 h.yenile()
 assert(s.koyunlar.size() == 1 and s.koyunlar[0].has_meta("satinalinan_koc"))
 y.lojistik.hayvanlar.koc = 0
 h.yenile()
 assert(s.koyunlar.is_empty() and s.adimlar.is_empty() and s.yollar.is_empty())
 y.lojistik.hayvanlar.koc = 1
 h.yenile()
 assert(s.koyunlar.size() == 1 and s.adimlar.size() == 1 and s.yollar.size() == 1 and s.koyunlar[0].has_meta("satinalinan_koc"))
 y.lojistik.hayvanlar.koc = 0
 h.yenile()
 agil.agil_koyun = 3
 h.yenile()
 assert(s.koyunlar.size() == 3 and not s.koyunlar[0].has_meta("satinalinan_koc"))
 var once := JSON.stringify(ana.oturum.kaydet())
 h.yenile()
 assert(JSON.stringify(ana.oturum.kaydet()) == once and s.koyunlar.size() == 3)
 e._kart_kapat()
 await get_tree().process_frame
 e._secili_bina = agil.id
 e._bilgi_goster()
 var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
 if not dizin.is_empty() and DisplayServer.get_name() != "headless":
  await get_tree().create_timer(0.5).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(dizin.path_join("mev14_saman.png"))
 ana.kayit.sil()
 ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.5).timeout
 print("SAMAN UI: GEÇTİ")
 await Ses.cik(0)
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
