extends Node
class TestAna extends Ana:
 func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  ayarlar = Ayarlar.new("user://unused_breach.cfg")
  katalog = Katalog.new()
  katalog.yukle()
  oturum = Oturum.new(katalog, 76)
  kayit = GuvenliKayit.new("user://test_breach_ui.json")
  theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
 get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
 var ana := TestAna.new()
 add_child(ana)
 var y := ana.oturum.yonetim
 y.gun = 3
 y.siparisler.kabul(y)
 y.gun = 11
 var olaylar: Array[Dictionary] = []
 SiparisIhlali.gece(y, olaylar)
 y.gun = 12
 SiparisIhlali.gece(y, olaylar)
 y.gun = 19
 y.akce = 3
 ana._koye_git()
 var e: KoyEkrani = ana._ekran
 e._pazar_ac()
 await get_tree().process_frame
 _kontrol(_metin(e).contains("ticareti reddediyor"), "Ayrılmış tüccar gerçek pazar satırında görünür")
 _kontrol(e.find_child("gezgin_al_bugday", true, false) == null and e.find_child("celep_al_okuz", true, false) == null, "Terk boyunca ürün/hayvan alımı yok")
 var ac := e.find_child("siparis_defteri_ac", true, false) as BaseButton
 _kontrol(ac != null, "Ceza ödeme defteri pazardan erişilebilir")
 if ac != null: ac.pressed.emit()
 await get_tree().process_frame
 _kontrol(_metin(e).contains("Celep Hamdullah · Borç 7") and not _metin(e).contains("celep_hamdullah"), "Borç/faiz ve okunabilir tüccar adı")
 _kontrol(e.find_child("siparis_kabul", true, false) == null, "Ayrılan tüccarın yeni teklifi yok")
 var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
 if not dizin.is_empty() and DisplayServer.get_name() != "headless":
  await get_tree().create_timer(0.5).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(dizin.path_join("tuc07_ceza.png"))
 var stok := y.kaynaklar.kaydet()
 var rng := y._rng.state
 var ode := e.find_child("siparis_ceza_celep_hamdullah", true, false) as Button
 _kontrol(ode != null and not ode.disabled, "Kısmi ödeme düğmesi açık")
 if ode != null: ode.pressed.emit()
 await get_tree().process_frame
 _kontrol(y.akce == 0 and y.tuccar_cezasi.celep_hamdullah.borc == 4, "Gerçek UI yalnız eldeki 3 kamu akçesini öder")
 ode = e.find_child("siparis_ceza_celep_hamdullah", true, false) as Button
 _kontrol(ode != null and ode.disabled, "Boş kasada ödeme kapalı")
 y.akce = 100
 SiparisSozlesmePaneli.ac(e)
 await get_tree().process_frame
 ode = e.find_child("siparis_ceza_celep_hamdullah", true, false) as Button
 if ode != null: ode.pressed.emit()
 await get_tree().process_frame
 _kontrol(y.akce == 96 and y.tuccar_cezasi.celep_hamdullah.borc == 0 and y.kervan_gunu(), "Tam ödeme ve süresi biten terk ticareti açar")
 _kontrol(y.kaynaklar.kaydet() == stok and y._rng.state == rng, "Ödeme stok/RNG tüketmez")
 e._pazar_ac()
 await get_tree().process_frame
 _kontrol(not _metin(e).contains("ticareti reddediyor"), "Gerçek pazar ödeme sonrası tekrar açılır")
 ac = e.find_child("siparis_defteri_ac", true, false) as BaseButton
 if ac != null: ac.pressed.emit()
 await get_tree().process_frame
 var kabul := e.find_child("siparis_kabul", true, false) as Button
 _kontrol(kabul != null and not kabul.disabled, "Sonraki ziyaret taahhüdü yeniden açılır")
 ana.kayit.sil()
 ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.3).timeout
 print("İHLAL UI: GEÇTİ" if hata == 0 else "İHLAL UI: KALDI")
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
