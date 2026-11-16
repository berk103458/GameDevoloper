extends Node
class TestAna extends Ana:
 func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  ayarlar = Ayarlar.new("user://unused_cas04.cfg")
  katalog = Katalog.new()
  katalog.yukle()
  oturum = Oturum.new(katalog, 76)
  kayit = GuvenliKayit.new("user://test_ambar_kundak_ui.json")
  theme = Tema.olustur(ayarlar)
func kur(y: KoyYonetimi) -> KoyBinasi:
 for cy in y.a.izgara_boyut.y:
  for cx in y.a.izgara_boyut.x:
   var h := Vector2i(cx,cy)
   if y.yerlesim("ambar",h).olur:
    var b := y.bina(y.bina_kur("ambar",h).id)
    b.insa_kalan = 0
    return b
 return null
func _ready() -> void:
 # CAS tur-offset/yangın arayüzü; alışma süresi ayrı testte.
 preload("res://src/sistemler/tehdit_takvimi.gd").AYAR.tehdit_baslangic_gunu = 0
 get_tree().create_timer(45.0).timeout.connect(func() -> void: get_tree().quit(1))
 var ana := TestAna.new()
 add_child(ana)
 var o := ana.oturum
 var y := o.yonetim
 y.akce = 100
 y.kaynaklar.kapasite = 1000
 for t in ["odun","tas","kereste"]: y.kaynaklar.ekle(t,20)
 var usta := y.kabul({"ad": "Ambar kurulum bilgisi"})
 preload("res://src/koy/yapi_bilgisi.gd").ekle(usta, PackedStringArray(["ambar"]))
 var b := kur(y)
 y.koylular.erase(usta) # Yalnız kurulum; kundaklama nüfusunu değiştirmez.
 if b == null:
  push_error("Kundak testi: bilgi/malzeme ile gerçek ambar kurulamadı")
  await Ses.cik(1)
  return
 var g := o._adli_gelen(&"chr_001")
 g.chr_sorgusu().obje_incele(2)
 o.karar_ver(g,&"kabul")
 y.gun = 3
 y.kaynaklar.ekle("su",10)
 ana._koye_git()
 var e: KoyEkrani = ana._ekran
 e._secili_bina=b.id
 e._bilgi_goster()
 assert(e._bilgi_icerik.find_children("kundak_clue_bilgisi","Label",true,false)[0].text.contains("ipucu: 1"))
 e._gece_dugmesi.pressed.emit()
 await get_tree().process_frame
 assert(y.bina(b.id)!=null and y.kaynaklar.miktar("su")==0 and not AmbarKundaklamasi.durum(y).kisiler.is_empty())
 var bulundu := false
 for l in e.find_children("*","Label",true,false):
  if l.text.contains("Kundaklama yangını") and l.text.contains("kurtarıldı"): bulundu = true
 assert(bulundu)
 var once := JSON.stringify(o.kaydet())
 e._gece_dugmesi.pressed.emit()
 assert(JSON.stringify(o.kaydet()) == once)
 var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
 if not dizin.is_empty() and DisplayServer.get_name() != "headless":
  await get_tree().create_timer(1.9).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(dizin.path_join("cas04_kundak.png"))
 ana.kayit.sil()
 ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.5).timeout
 print("AMBAR KUNDAK UI: GEÇTİ")
 await Ses.cik(0)
