extends Node
class TestAna extends Ana:
 func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  ayarlar=Ayarlar.new("user://unused_epilogue.cfg")
  katalog=Katalog.new()
  katalog.yukle()
  oturum=Oturum.new(katalog,1012)
  kayit=GuvenliKayit.new("user://test_epilogue_ui.json")
  theme=Tema.olustur(ayarlar)
func _ready() -> void:
 get_tree().create_timer(45).timeout.connect(func() -> void: get_tree().quit(1))
 var ana:=TestAna.new()
 add_child(ana)
 var o:=ana.oturum
 o.yonetim.kabul({"ad":"Son tanığı"})
 o.yonetim.adalet=80
 o.yonetim.son="tekfur"
 ana._son_goster(&"tekfur")
 await get_tree().process_frame
 var e:=ana._ekran as BilgiEkrani
 assert(e.metin.contains("Adil kahraman") and e.metin.contains("köyün akıbetinden ayrı"))
 assert(e.has_node("epilogue_okuma_zemini") and e.find_children("*","Button",true,false).size()==2)
 o.yonetim.adalet=40
 o.bayraklar[&"rusvet_sayisi"]=int(MuhafizEpilogu.AYAR.kacak_yoz)
 o.muhafiz_akce=50
 o.yonetim.son="zafer"
 o.yonetim.gun=30
 o.bayraklar[&"dursun_ve_turna_kabul"]=true
 o.bayraklar[&"lokman_kabul"]=true
 o.bayraklar[&"banu_ittifak_kabul"]=true
 o.bayraklar[&"sungur_tatmin_edildi"]=true
 o.bayraklar[&"veba_kirec_karantina_basarili"]=true
 var once:=JSON.stringify(o.kaydet())
 ana._son_goster(&"zafer")
 await get_tree().process_frame
 await get_tree().process_frame
 e=ana._ekran as BilgiEkrani
 assert(e.metin.contains("Venedik kaçağı") and e.metin.contains("Venedik yoluna"))
 assert(JSON.stringify(o.kaydet())==once)
 var kartlar:=e.find_child("kisisel_akibet_kartlari",true,false)
 assert(kartlar!=null and kartlar.get_child_count()==6)
 for c in [["dursun_turna","epilog.dursun_turna.kabul"],["lokman","epilog.lokman.iyilesti"],["banu","epilog.banu.ittifak"],["sungur","epilog.sungur.ittifak"],["vebali_ana","epilog.vebali_ana.sifa"]]:
  var metin:=kartlar.get_node(c[0]+"/Metin") as Label
  assert(metin.text==GuvenliMetin.metin(c[1]) and metin.text!=c[1])
 print("ANL-EPI-01: 6 kişisel kart")
 var dizin:=OS.get_environment("ADMIN_TEST_CIKTI")
 if not dizin.is_empty() and DisplayServer.get_name()!="headless":
  await get_tree().create_timer(0.5).timeout
  await RenderingServer.frame_post_draw
  for b in e.find_children("*","Button",true,false): assert(b.get_global_rect().end.y<=get_viewport().get_visible_rect().end.y)
  get_viewport().get_texture().get_image().save_png(dizin.path_join("oda10_venedik.png"))
 ana.ayarlar.degerler[&"metin_olcegi"]=150
 ana._son_goster(&"zafer")
 await get_tree().process_frame
 await get_tree().process_frame
 e=ana._ekran as BilgiEkrani
 assert(e.find_children("epilogue_kaydir","ScrollContainer",true,false).size()==1)
 for b in e.find_children("*","Button",true,false): assert(b.get_global_rect().end.y<=get_viewport().get_visible_rect().end.y)
 ana._son_goster(SancakTeftisi.SON_IDAM)
 await get_tree().process_frame
 e=ana._ekran as BilgiEkrani
 assert(e.metin.contains("İdam hükmü") and not e.metin.contains("Venedik kaçağı") and e.has_node("teftis_okuma_zemini") and not e.has_node("epilogue_okuma_zemini"))
 ana.kayit.sil()
 ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.5).timeout
 print("MUHAFIZ EPILOGU UI: GEÇTİ")
 await Ses.cik(0)
