extends Node
class TestAna extends Ana:
 func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  ayarlar = Ayarlar.new("user://unused_prices.cfg")
  katalog = Katalog.new()
  katalog.yukle()
  oturum = Oturum.new(katalog, 76)
  kayit = GuvenliKayit.new("user://test_prices_ui.json")
  theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
 get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
 var ana := TestAna.new()
 add_child(ana)
 var y := ana.oturum.yonetim
 y.gun = 23
 y.akce = 100
 ana._koye_git()
 var e: KoyEkrani = ana._ekran
 e._pazar_ac()
 await get_tree().process_frame
 var gida := e.find_child("kervan_al_gida", true, false) as Button
 var odun := e.find_child("kervan_al_odun", true, false) as Button
 _kontrol(gida != null and gida.text.contains("15") and odun != null and odun.text.contains("15"), "Kışta gerçek alış bedeli 15 akçe")
 _kontrol(_metin(e).contains("×3.00"), "Mevcut pazar kış çarpanını açıklar")
 var once := JSON.stringify(ana.oturum.kaydet())
 e._pazar_ac()
 await get_tree().process_frame
 _kontrol(JSON.stringify(ana.oturum.kaydet()) == once, "Fiyat gösterimi model/RNG değiştirmez")
 gida = e.find_child("kervan_al_gida", true, false) as Button
 var stok := y.kaynaklar.miktar("gida")
 if gida != null: gida.pressed.emit()
 await get_tree().process_frame
 _kontrol(y.akce == 85 and y.kaynaklar.miktar("gida") == stok + 10, "Gerçek düğme gösterdiği 15 akçeyi tahsil eder")
 var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
 if not dizin.is_empty() and DisplayServer.get_name() != "headless":
  await get_tree().create_timer(0.5).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(dizin.path_join("tuc09_kis.png"))
 y.gun = 7
 e._pazar_ac()
 await get_tree().process_frame
 gida = e.find_child("kervan_al_gida", true, false) as Button
 _kontrol(gida != null and gida.text.contains("4") and _metin(e).contains("×0.75"), "Yaz indirimli parti bedeli ekranda")
 var kasa := y.akce
 if gida != null: gida.pressed.emit()
 await get_tree().process_frame
 _kontrol(y.akce == kasa - 4, "Yaz gerçek tahsilatı yuvarlanmış 4 akçe")
 if not dizin.is_empty() and DisplayServer.get_name() != "headless":
  await get_tree().create_timer(0.5).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(dizin.path_join("tuc09_yaz.png"))
 y.husumet.tekfura_gecenler.append("demirci")
 e._pazar_ac()
 await get_tree().process_frame
 var alet := e.find_child("kervan_al_alet", true, false) as Button
 _kontrol(alet != null and alet.text.contains("75"), "Tekfur ek fiyatı tahsilattan önce ekranda görünür")
 ana.kayit.sil()
 ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.3).timeout
 print("FİYAT UI: GEÇTİ" if hata == 0 else "FİYAT UI: KALDI")
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
