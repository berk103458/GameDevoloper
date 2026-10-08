extends Node
class TestAna extends Ana:
 func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  ayarlar=Ayarlar.new("user://unused_mogol.cfg")
  katalog=Katalog.new()
  katalog.yukle()
  oturum=Oturum.new(katalog,1204)
  kayit=GuvenliKayit.new("user://test_mogol_ui.json")
  theme=Tema.olustur(ayarlar)
func metin(n: Node) -> String:
 var s: String=n.text if n is Label else ""
 for c in n.get_children():
  if not c.is_queued_for_deletion(): s+=" "+metin(c)
 return s
func _ready() -> void:
 process_mode=Node.PROCESS_MODE_ALWAYS
 get_tree().create_timer(45).timeout.connect(func() -> void: get_tree().quit(1))
 var ana:=TestAna.new()
 add_child(ana)
 var o:=ana.oturum
 o.yonetim.kabul({"ad":"Öncü haberi"})
 o.yonetim.kaynaklar.ekle("gida",100)
 o.yonetim.kaynaklar.ekle("su",100)
 o.gun=24
 ana._koye_git()
 var e:=ana._ekran as KoyEkrani
 e._geceye_gec()
 await get_tree().process_frame
 assert(o.gun==25 and metin(e).contains("Moğol öncüleri yaklaşıyor") and metin(e).contains("5 gün") and not metin(e).contains("koy.olay.mogol_oncusu"))
 ana._koye_git()
 await get_tree().process_frame
 e=ana._ekran as KoyEkrani
 var once:=JSON.stringify(o.kaydet())
 var d:=HaritaBaglantisi.ac(e)
 assert(d!=null and d._bilgi.text.contains("5 gün"))
 assert(JSON.stringify(o.kaydet())==once)
 var dizin:=OS.get_environment("ADMIN_TEST_CIKTI")
 if not dizin.is_empty() and DisplayServer.get_name()!="headless":
  await get_tree().create_timer(0.5).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(dizin.path_join("har02_oncu.png"))
 d.queue_free()
 await get_tree().process_frame
 o.gun=30
 ana.oturum=Oturum.kayittan(ana.katalog,JSON.parse_string(JSON.stringify(o.kaydet())))
 ana._koye_git()
 await get_tree().process_frame
 e=ana._ekran as KoyEkrani
 d=HaritaBaglantisi.ac(e)
 assert(d!=null and d._bilgi.text.contains("sınırda") and not d._bilgi.text.contains("-1 gün"))
 ana.kayit.sil()
 ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.5).timeout
 print("MOGOL ONCU UI: GEÇTİ")
 await Ses.cik(0)
