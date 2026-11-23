extends SceneTree

func _initialize() -> void:
 call_deferred("_kos")

func _oturum(kat: Katalog, tohum: int) -> Oturum:
 var o:=Oturum.new(kat,tohum)
 return o

func _ekran(o: Oturum, ayarlar: Ayarlar) -> HaritaEkrani:
 var e:=HaritaEkrani.new()
 e.name="HaritaEkrani"
 e.oturum=o
 e.ayarlar=ayarlar
 root.add_child(e)
 return e

func _bekle() -> void:
 await process_frame
 await process_frame
 if DisplayServer.get_name()!="headless":
  await create_timer(0.45).timeout
  await RenderingServer.frame_post_draw

func _cek(yol: String) -> void:
 var img:=root.get_viewport().get_texture().get_image()
 img.save_png(yol)
 print("KAYIT: ", yol, " ", img.get_width(), "x", img.get_height())

func _kos() -> void:
 DisplayServer.window_set_size(Vector2i(1920,1080))
 root.size=Vector2(1920,1080)
 var ayarlar:=Ayarlar.new("user://unused_harita_goruntu.cfg")
 ayarlar.degerler[&"belirme_hizi"]=&"aninda"
 var kat:=Katalog.new()
 kat.yukle()
 var dizin:="/workspace/harita_onizleme"
 DirAccess.make_dir_recursive_absolute(dizin)

 var o1:=_oturum(kat,1301)
 var e1:=_ekran(o1,ayarlar)
 e1.bolge_sec("hisar")
 await _bekle()
 _cek(dizin.path_join("baglama2_normal.png"))
 e1.queue_free()
 await process_frame

 var o2:=_oturum(kat,1302)
 o2.gun=26
 o2.yonetim.harac_bekliyor=true
 o2.yonetim.tekfur_baski=4
 o2.yonetim.husumet.puan=maxi(o2.yonetim.husumet.puan, o2.yonetim.a.sizma_esigi)
 var e2:=_ekran(o2,ayarlar)
 e2.bolge_sec("tekfur")
 await _bekle()
 _cek(dizin.path_join("baglama2_tehlike.png"))
 e2.queue_free()
 await process_frame

 var o3:=_oturum(kat,1303)
 o3.gun=21
 var e3:=_ekran(o3,ayarlar)
 e3.bolge_sec("hisar")
 await _bekle()
 _cek(dizin.path_join("baglama2_kis.png"))
 e3.queue_free()
 await process_frame
 print("HARITA BAGLAMA GORUNTU: TAMAM")
 quit(0)
