extends Node
class TestAna extends Ana:
 func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  ayarlar = Ayarlar.new("user://unused_karaborsa.cfg")
  katalog = Katalog.new()
  katalog.yukle()
  oturum = Oturum.new(katalog, 76)
  kayit = GuvenliKayit.new("user://test_karaborsa_ui.json")
  theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
 get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
 var ana := TestAna.new()
 add_child(ana)
 var y := ana.oturum.yonetim
 y.akce = 1000
 y.kaynaklar.kapasite = 10000
 y.gun = 15
 ana._koye_git()
 var e: KoyEkrani = ana._ekran
 e._pazar_ac()
 await get_tree().process_frame
 for tur in ["zirh", "yay", "kalkan"]:
  var d := e.find_child("gezgin_al_" + tur, true, false) as Button
  _kontrol(d != null and not d.disabled, "Gerçek Silah stok düğmesi")
  var para := y.akce
  var adet := y.kaynaklar.miktar(tur)
  if d != null: d.pressed.emit()
  await get_tree().process_frame
  _kontrol(y.kaynaklar.miktar(tur) == adet + 1 and y.akce == para - int(GezginTuccarStogu.AYAR.silah_tuccari[tur].fiyat), "UI tek ambar/kasa işlemi")
 for tur in ["zirh", "yay", "kalkan"]:
  var kart: KaynakGostergesi = e.hud._stok_etiketleri.get(tur)
  _kontrol(kart != null and kart._miktar.text == "1" and _metin(kart).contains(GezginTuccarStogu.AYAR.silah_tuccari[tur].ad), "Mevcut HUD yeni stok ve gerçek ad gösterir")
  _kontrol(not kart.find_children("*", "ColorRect", true, false).is_empty(), "Asset yerine düz kutu ikon")
 var once := JSON.stringify(ana.oturum.kaydet())
 e._pazar_ac()
 await get_tree().process_frame
 _kontrol(JSON.stringify(ana.oturum.kaydet()) == once, "Yeniden açılan pazar kaydı ve stok geçmişini değiştirmez")
 var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
 if not dizin.is_empty() and DisplayServer.get_name() != "headless":
  await get_tree().create_timer(0.5).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(dizin.path_join("tuc08_karaborsa.png"))
 var teklif := e.find_child("karaborsa_tutsak_al", true, false) as Button
 _kontrol(teklif != null and teklif.disabled, "Yataksız kaçak teklif kapalı")
 _kontrol(_metin(e).contains("Adalet -5") and _metin(e).contains("Asayiş riski +5"), "İşlemin toplumsal bedeli görünür")
 var barinak := _kur(y, "cadir")
 _kontrol(barinak != null, "Mevcut barınak hazırlanır")
 e._pazar_ac()
 await get_tree().process_frame
 teklif = e.find_child("karaborsa_tutsak_al", true, false) as Button
 _kontrol(teklif != null and not teklif.disabled, "Boş yatak teklifi açar")
 var para := y.akce
 var stok := y.kaynaklar.kaydet()
 var rng := y._rng.state
 if teklif != null: teklif.pressed.emit()
 await get_tree().process_frame
 _kontrol(y.nufus() == 1 and y.koylular[0].ev == barinak.id and y.koylular[0].bayrak_var("eski_tutsak"), "Gerçek UI tek barındırılmış köylü yaratır")
 _kontrol(y.akce == para - int(SilahKaraborsasi.AYAR.fiyat) and y.kaynaklar.kaydet() == stok and y._rng.state == rng, "UI kamu ödeme; stok/RNG değişmez")
 teklif = e.find_child("karaborsa_tutsak_al", true, false) as Button
 _kontrol(teklif != null and teklif.disabled, "Aynı ziyaret ikinci kişi satmaz")
 y.gun = 16
 e._pazar_ac()
 await get_tree().process_frame
 _kontrol(y.gezgin_ticaret.kalan(y, "yay") == 5 and not SilahKaraborsasi.alinabilir(y), "İkinci gün aynı ürün/kişi stoğu")
 y.gun = 17
 e._pazar_ac()
 await get_tree().process_frame
 _kontrol(e.find_child("gezgin_al_yay", true, false) == null and e.find_child("karaborsa_tutsak_al", true, false) == null, "Ayrılan uzman panel bırakmaz")
 ana.kayit.sil()
 ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.3).timeout
 print("KARABORSA UI: GEÇTİ" if hata == 0 else "KARABORSA UI: KALDI")
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
