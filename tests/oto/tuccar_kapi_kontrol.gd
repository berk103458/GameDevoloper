## TUC-12: gerçek kapı düğmesi, çift kasa ve nüfus kabul kontrolü.
extends Node
func _ready() -> void:
 get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
 var k := Katalog.new()
 k.yukle()
 var o := Oturum.new(k, 76)
 o.yonetim.gun = 3
 var liste := o.gece_kuyrugu()
 assert(TuccarKapiGecisi.ilgilenir(liste[0]) and liste.size() > 1)
 var kok := Control.new()
 kok.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 var a := Ayarlar.new()
 kok.theme = Tema.olustur(a)
 add_child(kok)
 var e := KapiEkrani.new()
 e.oturum = o
 e.ayarlar = a
 kok.add_child(e)
 e._gelen = liste[0]
 e._ad.text = e._gelen.ad_anahtari
 await e.sahne.gelen_yaklas(e._model_adi(e._gelen))
 e._karar_goster()
 assert(e._karar_etiketi("harc").contains("bac"))
 assert(e._karar_alt_yazi("rusvet").contains("kişisel"))
 await get_tree().create_timer(1.5).timeout
 var cikti := OS.get_environment("ADMIN_TEST_CIKTI")
 if not cikti.is_empty() and DisplayServer.get_name() != "headless":
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(cikti.path_join("tuccar_kapi.png"))
 var para := o.koy_akce
 var nufus := o.yonetim.nufus()
 e._karar_bas("harc")
 e._karar_bas("harc")
 await get_tree().process_frame
 assert(o.koy_akce == para + int(TuccarKapiGecisi.AYAR.bac))
 assert(o.muhafiz_akce == 0 and o.yonetim.nufus() == nufus and o.yonetim.kervan_gunu())
 await e.gece_bitti
 kok.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(1.0).timeout
 print("TÜCCAR KAPI UI: GEÇTİ")
 get_tree().quit(0)
