extends Node
class TestAna extends Ana:
 func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  ayarlar=Ayarlar.new("user://unused_konuslanma.cfg")
  katalog=Katalog.new();katalog.yukle()
  oturum=Oturum.new(katalog,1902)
  kayit=GuvenliKayit.new("user://unused_konuslanma.json")
  theme=Tema.olustur(ayarlar)
func sec(e: KoyEkrani,rol: String) -> Button:
 for b in e.find_children("*","Button",true,false):
  if not b.is_queued_for_deletion() and b.has_meta("konuslanma") and b.get_meta("konuslanma")==rol: return b
 return null
func _ready() -> void:
 process_mode=Node.PROCESS_MODE_ALWAYS
 get_tree().create_timer(55).timeout.connect(func() -> void: get_tree().quit(1))
 var ana:=TestAna.new()
 add_child(ana)
 var y:=ana.oturum.yonetim
 y.agalik=true;y.sur_seviye=1
 var k:=y.kabul({"sinif":"asker","stat":5})
 k.moral=100;k.saglik=100
 assert(y.muhafiz_ata(k.id))
 var rng:=y._rng.state
 var para:=y.akce
 var savunma:=y.savunma_gucu()
 var is_yeri:=k.is_yeri
 ana._koye_git()
 await get_tree().process_frame
 var e:=ana._ekran as KoyEkrani
 KoyluKarti.ac(e,k.id)
 var b:=sec(e,"sur")
 assert(b!=null and not b.disabled)
 b.pressed.emit()
 await get_tree().process_frame
 var h:=e.sahne3b.halk_hareketi
 h.set_process(false);h._process(0.0)
 assert(SavunmaKonuslanmasi.etkin(y,k.id)=="sur" and h._durum[k.id].devriye_ad=="Sur okçusu")
 var f: KarakterModel=h.modeller[k.id]
 var d:=f.get_node_or_null("muhafiz_donanimi") as MuhafizDonanimi
 assert(d!=null and d.get_node_or_null("taktik_silah")!=null and not d.silah.visible)
 var hedef: Vector3=h._durum[k.id].yol.back()
 h._iste(k.id);h._process(0.0)
 assert(h._durum[k.id].yol.back()==hedef)
 h.yenile();h._process(0.0)
 assert(d.find_children("taktik_silah","",false,false).size()==1)
 var dizin:=OS.get_environment("ADMIN_TEST_CIKTI")
 if not dizin.is_empty() and DisplayServer.get_name()!="headless":
  var scroll:=e.find_children("*","ScrollContainer",true,false)
  for n in scroll:
   if n.is_ancestor_of(sec(e,"sur")): n.ensure_control_visible(sec(e,"sur"))
  await get_tree().create_timer(0.4).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(dizin.path_join("har10_konuslanma.png"))
 sec(e,"kapi").pressed.emit()
 await get_tree().process_frame
 h._process(0.0)
 assert(h._durum[k.id].devriye_ad=="Kapı mızraklısı" and d.find_children("taktik_silah","",false,false).size()==1)
 var kayit: Variant=JSON.parse_string(JSON.stringify(ana.oturum.kaydet()))
 var yuk:=Oturum.kayittan(ana.katalog,kayit)
 assert(SavunmaKonuslanmasi.etkin(yuk.yonetim,k.id)=="kapi")
 sec(e,"").pressed.emit()
 await get_tree().process_frame
 h._process(0.0)
 assert(SavunmaKonuslanmasi.durum(y).is_empty() and d.get_node_or_null("taktik_silah")==null and d.silah.visible)
 assert(k.is_yeri==is_yeri and y._rng.state==rng and y.akce==para and y.savunma_gucu()==savunma and h.modeller.size()==y.koylular.size())
 assert(sec(e,"").disabled)
 sec(e,"sur").pressed.emit()
 await get_tree().process_frame
 y.sur_hasar=100
 h.yenile();h._process(0.0)
 assert(SavunmaKonuslanmasi.etkin(y,k.id)=="" and d.get_node_or_null("taktik_silah")==null and d.silah.visible)
 KoyluKarti.ac(e,k.id)
 assert(not sec(e,"").disabled)
 sec(e,"").pressed.emit()
 await get_tree().process_frame
 ana.kayit.sil();ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.5).timeout
 print("KONUSLANMA UI: GEÇTİ")
 await Ses.cik(0)
