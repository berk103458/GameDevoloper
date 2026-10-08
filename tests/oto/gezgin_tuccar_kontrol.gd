extends Node
class TestAna extends Ana:
 func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  ayarlar = Ayarlar.new("user://unused_trader.cfg")
  katalog = Katalog.new()
  katalog.yukle()
  oturum = Oturum.new(katalog, 76)
  kayit = GuvenliKayit.new("user://test_trader_ui.json")
  theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
 get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
 var ana := TestAna.new()
 add_child(ana)
 var y := ana.oturum.yonetim
 ana._koye_git()
 var e: KoyEkrani = ana._ekran
 for gun in [0, 2, 3, 4, 5, 7]:
  y.gun = gun
  var once := JSON.stringify(ana.oturum.kaydet())
  e._pazar_ac()
  await get_tree().process_frame
  var d := GezginTuccarTakvimi.durum(gun, y.a.kervan_araligi)
  var l := e.find_child("gezgin_tuccar_durumu", true, false) as Label
  dene(l != null, "Mevcut pazarda tek takvim satırı")
  if l != null:
   dene(l.text.contains(d.tuccar.ad if d.aktif else d.sonraki_tuccar.ad), "Gerçek panel uzman adını gösterir")
   dene(l.text.contains("%d gün daha" % d.kalan) if d.aktif else l.text.contains("%d. gün" % d.sonraki_gun), "Konaklama veya sonraki varış gösterilir")
  dene(y.kervan_gunu() == d.aktif, "Pazar ve mevcut işlem API'si aynı takvimi kullanır")
  var yuklenen := KoyYonetimi.kayittan(y.a, y.katalog, y.kaydet())
  dene(yuklenen.gun == gun and yuklenen.kervan_gunu() == d.aktif, "Kayıt dönüşü aynı ziyaret gününü korur")
  dene(JSON.stringify(ana.oturum.kaydet()) == once, "Pazar açılması kayıt/RNG değiştirmez")
  var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
  if gun == 3 and not dizin.is_empty() and DisplayServer.get_name() != "headless":
   await get_tree().create_timer(0.5).timeout
   await RenderingServer.frame_post_draw
   get_viewport().get_texture().get_image().save_png(dizin.path_join("tuc01_pazar.png"))
  e._kart_kapat()
  await get_tree().process_frame
  yuklenen.akce = 1000
  yuklenen.kaynaklar.kapasite = 10000
  yuklenen.kaynaklar.ekle("odun", 20)
  dene((int(yuklenen.kervana_sat("odun", 10).satilan) > 0) == d.aktif, "Alım/satım varış ve ayrılış sınırında kapılanır")
  dene(yuklenen.kervandan_al("demir", 1) == d.aktif, "Satın alma iki konaklama gününde açıktır")
 ana.kayit.sil()
 ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.3).timeout
 print("GEZGİN TÜCCAR UI: GEÇTİ" if hata == 0 else "GEZGİN TÜCCAR UI: KALDI")
 await Ses.cik(hata)
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
