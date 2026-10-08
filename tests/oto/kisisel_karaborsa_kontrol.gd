extends Node
class TestAna extends Ana:
 func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  ayarlar = Ayarlar.new("user://unused_private_trade.cfg")
  katalog = Katalog.new()
  katalog.yukle()
  oturum = Oturum.new(katalog, 76)
  kayit = GuvenliKayit.new("user://test_private_trade_ui.json")
  theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
 get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
 var ana := TestAna.new()
 add_child(ana)
 var y := ana.oturum.yonetim
 y.gun = 15
 y.akce = 1000
 ana._koye_git()
 var e: KoyEkrani = ana._ekran
 e._pazar_ac()
 await get_tree().process_frame
 var al := e.find_child("kisisel_al_yasak_muhur", true, false) as Button
 _kontrol(al != null and al.disabled, "Kamu akçesi varken kişisel kese boş; alış kapalı")
 ana.oturum.muhafiz_akce = 100
 e._pazar_ac()
 await get_tree().process_frame
 al = e.find_child("kisisel_al_yasak_muhur", true, false) as Button
 _kontrol(al != null and not al.disabled, "Kişisel finansman alış açar")
 var stok := y.kaynaklar.kaydet()
 var rng := y._rng.state
 if al != null: al.pressed.emit()
 await get_tree().process_frame
 _kontrol(ana.oturum.muhafiz_akce == 85 and y.akce == 1000 and y.kaynaklar.kaydet() == stok and y._rng.state == rng, "Gerçek düğme yalnız kişisel keseden alır")
 al = e.find_child("kisisel_al_yasak_muhur", true, false) as Button
 _kontrol(al != null and al.disabled, "Aynı ziyarette mühür stok tükendi")
 var oda := e.find_child("muhafiz_odasi_ac", true, false) as Button
 var once := JSON.stringify(ana.oturum.kaydet())
 if oda != null: oda.pressed.emit()
 await get_tree().process_frame
 _kontrol(_metin(e).contains("Yasak mühür · 1 adet") and JSON.stringify(ana.oturum.kaydet()) == once, "Muhafız odası gerçek envanteri salt okunur gösterir")
 _kontrol(not e.find_children("*", "ColorRect", true, false).is_empty(), "Gerçek asset yerine merkezi kutu")
 var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
 if not dizin.is_empty() and DisplayServer.get_name() != "headless":
  await get_tree().create_timer(0.5).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(dizin.path_join("tuc11_oda.png"))
 y.gun = 17
 e._pazar_ac()
 await get_tree().process_frame
 _kontrol(e.find_child("kisisel_al_yasak_muhur", true, false) == null and e.find_child("muhafiz_odasi_ac", true, false) != null, "Tüccar ayrılır, oda erişimi kalır")
 ana.kayit.sil()
 ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.3).timeout
 print("KİŞİSEL KARABORSA UI: GEÇTİ" if hata == 0 else "KİŞİSEL KARABORSA UI: KALDI")
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
