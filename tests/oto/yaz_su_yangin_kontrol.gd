extends Node
class TestAna extends Ana:
 func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  ayarlar = Ayarlar.new("user://unused_summer.cfg")
  katalog = Katalog.new()
  katalog.yukle()
  oturum = Oturum.new(katalog, 76)
  kayit = GuvenliKayit.new("user://test_summer_ui.json")
  theme = Tema.olustur(ayarlar)
func _ready() -> void:
 get_tree().create_timer(45.0).timeout.connect(func() -> void: get_tree().quit(1))
 var ana:=TestAna.new()
 add_child(ana)
 var o:=ana.oturum
 var y:=o.yonetim
 for i in 3:y.kabul({"ad":"Su köylüsü", "stat":5})
 y.gun=7
 y.akce=100
 ana._koye_git()
 var e:KoyEkrani=ana._ekran
 assert(e.hud._stok_etiketleri.has("su") and e.hud._stok_etiketleri.su.tooltip_text.contains("Gecelik ihtiyaç: 6"))
 e._pazar_ac()
 var b:=dugme(e)
 assert(b!=null and not b.disabled)
 var para:=y.akce
 b.pressed.emit()
 await get_tree().process_frame
 assert(y.kaynaklar.miktar("su")==10 and y.akce==para-1 and o.muhafiz_akce==0 and SuDengesi.taze(y)==10)
 b=dugme(e)
 b.pressed.emit()
 await get_tree().process_frame
 assert(y.kaynaklar.miktar("su")==20 and SuDengesi.taze(y)==0 and dugme(e).disabled)
 var dizin:=OS.get_environment("ADMIN_TEST_CIKTI")
 if not dizin.is_empty() and DisplayServer.get_name()!="headless":
  await get_tree().create_timer(0.5).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(dizin.path_join("mev07_su.png"))
 var r:=y.gece()
 assert(r.su.ihtiyac==6 and r.su.depo==6 and r.su.taze==0 and r.su.eksik==0 and y.kaynaklar.miktar("su")==14)
 ana.kayit.sil()
 ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.5).timeout
 print("YAZ SU/YANGIN UI: GEÇTİ")
 await Ses.cik(0)
func dugme(e:KoyEkrani)->Button:
 for b in e.find_children("su_rezerv_doldur", "Button", true, false):
  var p:Node=b
  var sil:=false
  while p!=null:
   if p.is_queued_for_deletion():sil=true
   p=p.get_parent()
  if not sil:return b
 return null
