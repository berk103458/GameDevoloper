extends Node
class TestAna extends Ana:
 func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  ayarlar = Ayarlar.new("user://unused_trade_route.cfg")
  katalog = Katalog.new()
  katalog.yukle()
  oturum = Oturum.new(katalog, 76)
  kayit = GuvenliKayit.new("user://test_trade_route_ui.json")
  theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
 get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
 var ana := TestAna.new()
 add_child(ana)
 var y := ana.oturum.yonetim
 y.gun = 3
 y.akce = 10
 y.kaynaklar.ekle("kereste", 30)
 # Başlangıç stokundan bağımsız: kural "20 odun tek satışta 5 akçe" (BUG-22 başlangıç odununu değiştirdi).
 y.kaynaklar.azalt("odun", y.kaynaklar.miktar("odun") - 20)
 ana._koye_git()
 var e: KoyEkrani = ana._ekran
 e._pazar_ac()
 await get_tree().process_frame
 var sec := e.find_child("pazar_satis_hedefi", true, false) as OptionButton
 _kontrol(sec != null and sec.selected == 0, "Varsayılan kamu hedefi tek pazarda")
 var sat := e.find_child("pazar_tezgah_kereste_5", true, false) as Button
 _kontrol(sat != null and not sat.disabled, "Mevcut kamu satış düğmesi")
 var para := y.akce
 if sat != null: sat.pressed.emit()
 await get_tree().process_frame
 _kontrol(y.akce == para + 3 and ana.oturum.muhafiz_akce == 0, "Varsayılan UI kamu gelirini korur")
 var once := JSON.stringify(ana.oturum.kaydet())
 sec = e.find_child("pazar_satis_hedefi", true, false) as OptionButton
 if sec != null:
  sec.select(1)
  sec.item_selected.emit(1)
 await get_tree().process_frame
 _kontrol(JSON.stringify(ana.oturum.kaydet()) == once, "Hedef seçimi model/RNG değiştirmez")
 sec = e.find_child("pazar_satis_hedefi", true, false) as OptionButton
 _kontrol(sec != null and sec.selected == 1 and sec.tooltip_text.contains("Adalet"), "Kişisel hedef ve sosyal bedel açık")
 sat = e.find_child("pazar_kervan_odun", true, false) as Button
 _kontrol(sat != null and not sat.disabled, "Kişisel kervan satış düğmesi")
 para = y.akce
 if sat != null: sat.pressed.emit()
 await get_tree().process_frame
 _kontrol(ana.oturum.muhafiz_akce == 5 and y.akce == para and y.kaynaklar.miktar("odun") == 0, "Gerçek UI 20 odunu tek satışla kişisel 5 akçeye çevirir")
 _kontrol(y.adalet == 65 and y.asayis_riski == 15, "Mevcut zimmet toplumsal bedeli uygulanır")
 sat = e.find_child("pazar_kervan_kereste", true, false) as Button
 _kontrol(sat != null and sat.disabled, "Günlük sınır/aşırı tutar UI'yi kapatır")
 var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
 if not dizin.is_empty() and DisplayServer.get_name() != "headless":
  await get_tree().create_timer(0.5).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(dizin.path_join("tuc10_kisisel_satis.png"))
 sec = e.find_child("pazar_satis_hedefi", true, false) as OptionButton
 if sec != null:
  sec.select(0)
  sec.item_selected.emit(0)
 await get_tree().process_frame
 sat = e.find_child("pazar_kervan_kereste", true, false) as Button
 _kontrol(sat != null and not sat.disabled, "Kamu satışının kendi yolu açık kalır")
 para = y.akce
 if sat != null: sat.pressed.emit()
 await get_tree().process_frame
 _kontrol(y.akce == para + 20 and ana.oturum.muhafiz_akce == 5, "Kamu dönüşü kişisel keseye ikinci gelir vermez")
 ana.kayit.sil()
 ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.3).timeout
 print("PAZAR HEDEF UI: GEÇTİ" if hata == 0 else "PAZAR HEDEF UI: KALDI")
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
