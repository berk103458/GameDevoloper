extends Node
class TestAna extends Ana:
 func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  ayarlar = Ayarlar.new("user://unused_kanit_karti.cfg")
  katalog = Katalog.new()
  katalog.yukle()
  oturum = Oturum.new(katalog, 76)
  kayit = GuvenliKayit.new("user://test_divan_kanit_karti_ui.json")
  theme = Tema.olustur(ayarlar)
func _ready() -> void:
 process_mode=Node.PROCESS_MODE_ALWAYS
 get_tree().create_timer(45.0).timeout.connect(func() -> void: get_tree().quit(1))
 var ana := TestAna.new()
 add_child(ana)
 var o := ana.oturum
 var y := o.yonetim
 var g:=o._adli_gelen(&"chr_001")
 g.chr_sorgusu().obje_incele(1)
 g.chr_sorgusu().obje_incele(2)
 g.chr_sorgusu().gorsel_incele()
 var rr:=o.karar_ver(g,&"kabul")
 var k:=y.koylu(rr.koylu_id)
 var gizli := y.kabul({"ad":"Gizli Abbas","adli_id":"chr_009"})
 CasusGeceTakibi.kaydet(y,k,"ambar",-1,"kundaklama","gida",4,true)
 CasusGeceTakibi.kaydet(y,gizli,"kuyu",-1,"zehirleme","saglik",4,false)
 ana._koye_git()
 var e: KoyEkrani=ana._ekran
 var figur: KarakterModel=e.sahne3b.halk_hareketi.modeller[k.id]
 var eski_poz:=figur.global_transform
 var eski_rota:=JSON.stringify(e.sahne3b.halk_hareketi._durum[k.id])
 var hedef:=e.sahne3b.hedef
 var uzak:=e.sahne3b.uzaklik
 e._hiz_sec(2)
 var d:=DivanBaglantisi.ac(e)
 assert(d!=null and get_tree().paused and e.sahne3b.has_node("divan_meydani"))
 assert(DivanBaglantisi.ac(e)==null and e.sahne3b.get_node("divan_meydani").get_child_count()==3)
 assert(figur.global_transform!=eski_poz and JSON.stringify(e.sahne3b.halk_hareketi._durum[k.id])==eski_rota)
 var once:=y.kaynaklar.kaydet()
 var rng:=y._rng.state
 d.sec(k.id)
 assert(DivanOturumu.durum(y).kisi==k.id and d._bilgi.text.contains("Kundaklama") and not d._bilgi.text.contains("Gizli Abbas") and y.kaynaklar.kaydet()==once and y._rng.state==rng)
 var kartlar:=d._liste.find_children("kanit_*","PanelContainer",true,false)
 assert(kartlar.size()==3)
 for p in kartlar:
  var clue:=String(p.get_meta("clue"))
  assert(clue in DivanKanit.durum(k).ipuclar and p.find_children("kaynak_aciklamasi","Label",true,false)[0].text==DivanKanit.ipuclari(k)[clue].aciklama)
 var ilk:=d._liste.find_children("divan_sorgula","Button",true,false)[0] as Button
 assert(ilk.disabled)
 for anahtar in ["Nişan kanıtı","Yük kanıtı"]:
  for b in d._liste.find_children("*","Button",true,false):
   if b.text.begins_with(anahtar) and not b.disabled: b.pressed.emit(); break
  await get_tree().process_frame
 var sor:=d._liste.find_children("divan_sorgula","Button",true,false)[0] as Button
 assert(not sor.disabled)
 sor.pressed.emit()
 await get_tree().process_frame
 assert(DivanKanit.durum(k).itiraf and d._liste.find_children("divan_sorgula","Button",true,false)[0].disabled and y.kaynaklar.kaydet()==once and y._rng.state==rng)
 var dizin:=OS.get_environment("ADMIN_TEST_CIKTI")
 if not dizin.is_empty() and DisplayServer.get_name()!="headless":
  await get_tree().create_timer(0.5).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(dizin.path_join("cas14_kanit.png"))
 var poz_geri := [false]
 d.tree_exiting.connect(func() -> void: poz_geri[0]=figur.global_transform==eski_poz)
 d.get_node("divan_paneli").find_children("divan_kapat","Button",true,false)[0].pressed.emit()
 await get_tree().process_frame
 await get_tree().process_frame
 assert(not get_tree().paused and Engine.time_scale==2.0 and e.sahne3b.hedef==hedef and e.sahne3b.uzaklik==uzak and not e.sahne3b.has_node("divan_meydani"))
 assert(poz_geri[0])
 var yeniden:=DivanBaglantisi.ac(e)
 assert(yeniden!=null and yeniden._bilgi.text.contains(k.ad))
 yeniden.queue_free()
 await get_tree().process_frame
 e._hiz_sec(1)
 e._kart_ac("Mevcut olay")
 assert(DivanBaglantisi.ac(e)==null)
 e._kart_kapat()
 await get_tree().process_frame
 ana.kayit.sil()
 ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.5).timeout
 print("DIVAN KANIT KART UI: GEÇTİ")
 await Ses.cik(0)
