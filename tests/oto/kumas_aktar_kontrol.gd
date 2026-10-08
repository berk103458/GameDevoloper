extends Node
class TestAna extends Ana:
 func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  ayarlar = Ayarlar.new("user://unused_aktar.cfg")
  katalog = Katalog.new()
  katalog.yukle()
  oturum = Oturum.new(katalog, 76)
  kayit = GuvenliKayit.new("user://test_aktar_ui.json")
  theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
 get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
 var ana := TestAna.new()
 add_child(ana)
 var y := ana.oturum.yonetim
 y.akce = 1000
 y.kaynaklar.kapasite = 10000
 y.gun = 11
 var a := y.kabul({"sinif": "ciftci", "stat": 5})
 var b := y.kabul({"sinif": "ciftci", "stat": 5})
 a.refah = 40
 b.refah = 70
 ana._koye_git()
 var e: KoyEkrani = ana._ekran
 e._pazar_ac()
 await get_tree().process_frame
 for tur in ["afyon", "sargi", "kece", "kumas"]:
  var d := e.find_child("gezgin_al_" + tur, true, false) as Button
  _kontrol(d != null and not d.disabled, "Gerçek Kumaşçı ve Aktar stok düğmesi")
  var para := y.akce
  var adet := y.kaynaklar.miktar(tur)
  if d != null: d.pressed.emit()
  await get_tree().process_frame
  _kontrol(y.kaynaklar.miktar(tur) == adet + 1 and y.akce == para - int(GezginTuccarStogu.AYAR.kumasci_aktar[tur].fiyat), "UI tek ambar/kasa işlemi")
 for tur in ["afyon", "sargi", "kece", "kumas"]:
  var kart: KaynakGostergesi = e.hud._stok_etiketleri.get(tur)
  _kontrol(kart != null and kart._miktar.text == "1" and _metin(kart).contains(GezginTuccarStogu.AYAR.kumasci_aktar[tur].ad), "Mevcut HUD yeni stok ve gerçek ad gösterir")
  _kontrol(not kart.find_children("*", "ColorRect", true, false).is_empty(), "Asset yerine düz kutu ikon")
 var once := JSON.stringify(ana.oturum.kaydet())
 e._pazar_ac()
 await get_tree().process_frame
 _kontrol(JSON.stringify(ana.oturum.kaydet()) == once, "Yeniden açılan pazar kaydı ve stok geçmişini değiştirmez")
 var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
 if not dizin.is_empty() and DisplayServer.get_name() != "headless":
  await get_tree().create_timer(0.5).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(dizin.path_join("tuc04_aktar.png"))
 var para := y.akce
 var rng := y._rng.state
 for tur in ["kece", "kumas"]:
  var d := e.find_child("luks_dagit_" + tur, true, false) as Button
  _kontrol(d != null and not d.disabled, "Gerçek lüks dağıtım düğmesi")
  if d != null: d.pressed.emit()
  await get_tree().process_frame
 _kontrol(a.refah == 48 and b.refah == 70 and y.kaynaklar.miktar("kece") == 0 and y.kaynaklar.miktar("kumas") == 0, "Dağıtım gerçek düşük Refah kişisine stok verir")
 _kontrol(y.akce == para and y._rng.state == rng, "Dağıtım kasa/RNG korur")
 y.gun = 12
 e._pazar_ac()
 await get_tree().process_frame
 _kontrol(_metin(e).contains("Kumaşçı ve Aktar") and y.gezgin_ticaret.kalan(y, "kumas") == 7, "İkinci gün aynı uzman ve kalan stok")
 y.gun = 13
 e._pazar_ac()
 await get_tree().process_frame
 _kontrol(e.find_child("gezgin_al_kumas", true, false) == null, "Ayrılan uzman stok paneli bırakmaz")
 ana.kayit.sil()
 ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.3).timeout
 print("KUMAŞ AKTAR UI: GEÇTİ" if hata == 0 else "KUMAŞ AKTAR UI: KALDI")
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
