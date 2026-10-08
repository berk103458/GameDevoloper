extends Node
class TestAna extends Ana:
 func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  ayarlar=Ayarlar.new("user://unused_cas08.cfg")
  katalog=Katalog.new()
  katalog.yukle()
  oturum=Oturum.new(katalog,73)
  kayit=GuvenliKayit.new("user://test_karaboran_ui.json")
  theme=Tema.olustur(ayarlar)
func _ready() -> void:
 get_tree().create_timer(45.0).timeout.connect(func() -> void: get_tree().quit(1))
 var ana:=TestAna.new()
 add_child(ana)
 var o:=ana.oturum
 var y:=o.yonetim
 var rr:=o.karar_ver(o._adli_gelen(&"chr_004"),&"kabul")
 var k:=y.koylu(rr.koylu_id)
 CasusGeceTakibi.kaydet(y,k,"cephanelik",-1,"sabotaj","alet",0,true)
 assert(DivanHukmu.uygula(o,k.id,"zindan"))
 y.kaynaklar.ekle("gida",80)
 y.kaynaklar.ekle("odun",80)
 y.gece()
 y.gece()
 assert(KaraboranIntikami.durum(y).is_empty())
 ana._koye_git()
 var e: KoyEkrani=ana._ekran
 e._gece_dugmesi.pressed.emit()
 await get_tree().process_frame
 assert(KaraboranIntikami.durum(y)==[k.id])
 var bulundu:=false
 for l in e.find_children("*","Label",true,false):
  if l.text.contains("Karaboran çetesi"): bulundu=true
 assert(bulundu)
 var once:=JSON.stringify(o.kaydet())
 e._gece_dugmesi.pressed.emit()
 assert(JSON.stringify(o.kaydet())==once)
 var dizin:=OS.get_environment("ADMIN_TEST_CIKTI")
 if not dizin.is_empty() and DisplayServer.get_name()!="headless":
  await get_tree().create_timer(1.9).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(dizin.path_join("cas08_intikam.png"))
 ana.kayit.sil()
 ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.5).timeout
 print("KARABORAN UI: GEÇTİ")
 await Ses.cik(0)
