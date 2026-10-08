extends Node
class TestAna extends Ana:
 func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  ayarlar = Ayarlar.new("user://unused_orders.cfg")
  katalog = Katalog.new()
  katalog.yukle()
  oturum = Oturum.new(katalog, 76)
  kayit = GuvenliKayit.new("user://test_orders_ui.json")
  theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
 get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
 var ana := TestAna.new()
 add_child(ana)
 var y := ana.oturum.yonetim
 y.gun = 3
 ana._koye_git()
 var e: KoyEkrani = ana._ekran
 e._pazar_ac()
 await get_tree().process_frame
 var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
 if not dizin.is_empty() and DisplayServer.get_name() != "headless":
  await get_tree().create_timer(0.5).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(dizin.path_join("tuc05_pazar.png"))
 var once := JSON.stringify(ana.oturum.kaydet())
 var ac := e.find_child("siparis_defteri_ac", true, false) as BaseButton
 _kontrol(ac != null, "Sözleşme defteri mevcut pazar satırında")
 if ac != null: ac.pressed.emit()
 await get_tree().process_frame
 _kontrol(_metin(e).contains("12 Un") or _metin(e).contains("12 un"), "Gerçek panel un siparişini gösterir")
 _kontrol(JSON.stringify(ana.oturum.kaydet()) == once, "Defter açılışı model/RNG değiştirmez")
 var kabul := e.find_child("siparis_kabul", true, false) as Button
 _kontrol(kabul != null and not kabul.disabled, "Kabul düğmesi açık")
 var kasa := y.akce
 var stok := y.kaynaklar.kaydet()
 var rng := y._rng.state
 if kabul != null: kabul.pressed.emit()
 await get_tree().process_frame
 _kontrol(y.siparisler.aktif_sayisi() == 1 and y.akce == kasa and y.kaynaklar.kaydet() == stok and y._rng.state == rng, "Gerçek kabul sinyali yalnız taahhüt yazar")
 kabul = e.find_child("siparis_kabul", true, false) as Button
 _kontrol(kabul != null and kabul.disabled, "Aynı teklif tekrar kabul edilemez")
 _kontrol(_metin(e).contains("11. güne kadar"), "Yedi günlük vade görünür")
 if not dizin.is_empty() and DisplayServer.get_name() != "headless":
  await get_tree().create_timer(0.5).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(dizin.path_join("tuc05_sozlesmeler.png"))
 y.gun = 5
 SiparisSozlesmePaneli.ac(e)
 await get_tree().process_frame
 _kontrol(e.find_child("siparis_kabul", true, false) == null and _metin(e).contains("11. güne kadar"), "Tüccar ayrılınca taahhüt defterde kalır, yeni kabul yok")
 ana.kayit.sil()
 ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.3).timeout
 print("SİPARİŞ UI: GEÇTİ" if hata == 0 else "SİPARİŞ UI: KALDI")
 await Ses.cik(hata)
func _metin(n: Node) -> String:
 var r: String = n.text if n is Label else ""
 for c in n.get_children():
  if not c.is_queued_for_deletion(): r += " " + _metin(c)
 return r
func _dugme(n: Node, ad: String) -> Button:
 if n is Button and n.text == ad: return n
 for c in n.get_children():
  if c.is_queued_for_deletion(): continue
  var b := _dugme(c, ad)
  if b != null: return b
 return null
func _kur(y: KoyYonetimi, tur: String) -> KoyBinasi:
 for cy in y.a.izgara_boyut.y:
  for cx in y.a.izgara_boyut.x:
   var h := Vector2i(cx, cy)
   if y.yerlesim(tur, h)["olur"]:
    var b := y.bina(y.bina_kur(tur, h)["id"])
    b.insa_kalan = 0
    return b
 return null
func _kontrol(olur: bool, metin: String) -> void:
 if not olur:
  hata += 1
  push_error(metin)
