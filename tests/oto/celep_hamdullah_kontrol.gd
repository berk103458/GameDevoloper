extends Node
class TestAna extends Ana:
 func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  ayarlar = Ayarlar.new("user://unused_celep.cfg")
  katalog = Katalog.new()
  katalog.yukle()
  oturum = Oturum.new(katalog, 76)
  kayit = GuvenliKayit.new("user://test_celep_ui.json")
  theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
 get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
 var ana := TestAna.new()
 add_child(ana)
 var y := ana.oturum.yonetim
 y.akce = 1000
 y.kaynaklar.kapasite = 10000
 for t in ["odun", "tas", "gida"]: y.kaynaklar.ekle(t, 100)
 _kur(y, "ahir")
 _kur(y, "ahir")
 _kur(y, "agil")
 y.gun = 3
 ana._koye_git()
 var e: KoyEkrani = ana._ekran
 e._pazar_ac()
 await get_tree().process_frame
 for tur in CelepHamdullah.AYAR.hayvanlar:
  var ad := "%s al · %d akçe" % [CelepHamdullah.AYAR.hayvanlar[tur].ad, CekiLojistigi.FIYAT[tur]]
  var d := _dugme(e, ad)
  _kontrol(d != null and not d.disabled, "Gerçek pazar alım düğmesi: " + tur)
  var para := y.akce
  if d != null: d.pressed.emit()
  await get_tree().process_frame
  _kontrol(int(y.lojistik.hayvanlar.get(tur, 0)) == 1 and y.akce == para - int(CekiLojistigi.FIYAT[tur]), "Gerçek sinyal kamu kasasını kullanır")
 var turler := {}
 for n in e.sahne3b.find_children("celep_*", "", true, false):
  if n.has_meta("hayvan_turu"):
   turler[n.get_meta("hayvan_turu")] = true
   _kontrol(n is MeshInstance3D and n.mesh is BoxMesh, "Merkezi düz kutu yer tutucu")
 _kontrol(turler.size() == 4, "Dört satın alınmış tür doğru barınakta görünür")
 var once := JSON.stringify(ana.oturum.kaydet())
 e._pazar_ac()
 await get_tree().process_frame
 _kontrol(JSON.stringify(ana.oturum.kaydet()) == once, "Pazar yeniden açılması kayıt/RNG değiştirmez")
 var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
 if not dizin.is_empty() and DisplayServer.get_name() != "headless":
  await get_tree().create_timer(0.5).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(dizin.path_join("tuc02_celep.png"))
 y.gun = 7
 e._pazar_ac()
 await get_tree().process_frame
 for tur in CelepHamdullah.AYAR.hayvanlar:
  var d := _dugme(e, "%s al · %d akçe" % [CelepHamdullah.AYAR.hayvanlar[tur].ad, CekiLojistigi.FIYAT[tur]])
  _kontrol(d != null and d.disabled, "Nalbur gününde hayvan düğmesi kapalı")
 ana.kayit.sil()
 ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.3).timeout
 print("CELEP UI: GEÇTİ" if hata == 0 else "CELEP UI: KALDI")
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
