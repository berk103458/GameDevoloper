extends Node
class TestAna extends Ana:
 func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  ayarlar=Ayarlar.new("user://unused_teftis.cfg")
  katalog=Katalog.new()
  katalog.yukle()
  oturum=Oturum.new(katalog,915)
  kayit=GuvenliKayit.new("user://test_teftis_ui.json")
  theme=Tema.olustur(ayarlar)
func metin(n: Node) -> String:
 var s: String=n.text if n is Label else ""
 for c in n.get_children():
  if not c.is_queued_for_deletion(): s+=" "+metin(c)
 return s
func _ready() -> void:
 get_tree().create_timer(45.0).timeout.connect(func() -> void: get_tree().quit(1))
 var ayar:=SancakTeftisi.AYAR
 SancakTeftisi.AYAR=ayar.duplicate(true)
 SancakTeftisi.AYAR.bulma_olasiligi=1.0
 var ana:=TestAna.new()
 add_child(ana)
 var o:=ana.oturum
 for i in 4:
  var g:=Gelen.new()
  g.id=StringName("teftis_ui_%d"%i)
  o.karar_ver(g,&"rusvet")
 o.yonetim.kabul({"ad":"Teftiş tanığı"})
 o.gun=5
 o.yonetim.kaynaklar.ekle("gida",100)
 o.yonetim.kaynaklar.ekle("su",100)
 ana._koye_git()
 var e:=ana._ekran as KoyEkrani
 var oda:=MuhafizOdasiBaglantisi.ac(e)
 assert(oda!=null and oda.find_children("oda_teftis_notu","Label",true,false).size()==1)
 oda.find_children("oda_kasa_ac","Button",true,false)[0].button_pressed=true
 oda.find_children("oda_kasa_ac","Button",true,false)[0].button_pressed=false
 oda.queue_free()
 await get_tree().process_frame
 e._geceye_gec()
 await get_tree().process_frame
 assert(o.yonetim.son==String(SancakTeftisi.SON_AZIL) and metin(e).contains("azledildi") and not metin(e).contains("koy.olay.sancak_teftisi"))
 var once:=JSON.stringify(o.kaydet())
 e._geceye_gec()
 assert(JSON.stringify(o.kaydet())==once)
 var dugmeler:=e._ust_kart.find_children("*","Button",true,false)
 (dugmeler.back() as Button).pressed.emit()
 await get_tree().process_frame
 var son:=ana._ekran as BilgiEkrani
 assert(son!=null and son.baslik=="Muhafız azledildi" and son.metin.contains("Köy ayakta") and son.sayi==6)
 assert(son.has_node("teftis_okuma_zemini"))
 var dizin:=OS.get_environment("ADMIN_TEST_CIKTI")
 if not dizin.is_empty() and DisplayServer.get_name()!="headless":
  await get_tree().create_timer(0.5).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(dizin.path_join("oda07_azil.png"))
 ana._son_goster(SancakTeftisi.SON_IDAM)
 await get_tree().process_frame
 assert((ana._ekran as BilgiEkrani).baslik=="Muhafızın idamı")
 ana._son_goster(&"zafer")
 await get_tree().process_frame
 assert(not ana._ekran.has_node("teftis_okuma_zemini"))
 ana.kayit.sil()
 ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.5).timeout
 SancakTeftisi.AYAR=ayar
 print("SANCAK TEFTIS UI: GEÇTİ")
 await Ses.cik(0)
