## Gerçek kapı ve aynı gelen/model kuyruğu; kullanıcı kayıt slotuna yazmaz.
extends Node
func _ready() -> void:
 get_tree().create_timer(120.0).timeout.connect(func() -> void: get_tree().quit(1))
 Engine.time_scale = 8.0
 var k := Katalog.new()
 k.yukle()
 var o := Oturum.new(k, 84)
 var ayar := Ayarlar.new()
 ayar.ayarla(&"hareket_azalt", true)
 var kok := Control.new()
 kok.theme = Tema.olustur(ayar)
 add_child(kok)
 kok.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 var e := KapiEkrani.new()
 e.oturum = o
 e.ayarlar = ayar
 kok.add_child(e)
 IklimDeneyi.degistir(o, -1, "kar_firtinasi")
 for cap in [1, 0]:
  o.gun = 0 if cap == 1 else 26
  e._gece_gelen = 0
  var q: Array[Gelen] = []
  var adlar: Array[String] = []
  for id in ["chr_001", "chr_002", "chr_003"]:
   var g := o._adli_gelen(StringName(id))
   g.heybe = Heybe.new()
   q.append(g)
   adlar.append(e._model_adi(g))
  e._kuyruk = q.duplicate()
  KapiFirtinaKuyrugu.kur(o, e.sahne)
  e.sahne.kuyruk_doldur(adlar)
  assert(e.sahne.kuyruk_sayilari() == Vector2i(cap, 3 - cap))
  var ilk_tansiyon: int = q[1].chr_sorgusu().tansiyon
  for i in q.size():
   await e._siradaki()
   assert(e._gelen == q[i] and e._kuyruk.size() == 2 - i)
   var n := e.sahne.kuyruk_sayilari()
   assert(n.x == mini(cap, 2 - i) and n.x + n.y == 2 - i)
   if i == 0:
    assert(q[1].chr_sorgusu().tansiyon == ilk_tansiyon + 1)
   if i == 1:
    assert(e._bilgi.text.contains("Tipi sırası %d" % cap) and e._bilgi.text.contains("bekleme +1"))
    if cap == 1:
     Engine.time_scale = 1.0
     var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
     if not dizin.is_empty() and DisplayServer.get_name() != "headless":
      await get_tree().create_timer(0.5).timeout
      await RenderingServer.frame_post_draw
      get_viewport().get_texture().get_image().save_png(dizin.path_join("mev15_kuyruk.png"))
     Engine.time_scale = 8.0
  assert(e.sahne._bekleyenler.is_empty() and e.sahne._kuyruktakiler.is_empty())
 IklimDeneyi.degistir(o, -1, "normal")
 KapiFirtinaKuyrugu.kur(o, e.sahne)
 e.sahne.kuyruk_doldur(["ciftci", "esnaf", "asker"])
 assert(e.sahne.kuyruk_sayilari() == Vector2i(3, 0))
 if not await _kapi_kadraji(e, o):
  await Ses.cik(1)
  return
 Engine.time_scale = 1.0
 kok.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.5).timeout
 print("FIRTINA KUYRUK UI: GEÇTİ")
 await Ses.cik(0)


## SAH-51: Gerçek kapı akışında birinci yüz kadrajda kalır.
func _kapi_kadraji(e: KapiEkrani, o: Oturum) -> bool:
 var kuyruk: Array[Gelen] = []
 var adlar: Array[String] = []
 for id in [&"chr_001", &"chr_002", &"chr_003", &"chr_004"]:
  var gelen := o._adli_gelen(id)
  gelen.heybe = Heybe.new()
  kuyruk.append(gelen)
  adlar.append(e._model_adi(gelen))
 e._gece_gelen = 0
 e._kuyruk = kuyruk.duplicate()
 var sahne := e.sahne
 sahne.kuyruk_doldur(adlar)
 if sahne._kuyruktakiler.size() != 4:
  push_error("SAH-51: Dört model kuyrukta görünmeli.")
  return false
 var birinci := sahne._kuyruktakiler[0]
 var ikinci := sahne._kuyruktakiler[1]
 var ikinci_yeri := ikinci.position
 await e._siradaki()
 if e._gelen != kuyruk[0] or sahne._gelen != birinci or sahne._kuyruktakiler[0] != ikinci:
  push_error("SAH-51: Kapıda birinci model, sıranın başında ikinci model olmalı.")
  return false

 var kamera := sahne.kamera
 var once := kamera.global_transform
 var fov := kamera.fov
 sahne.gelen_konus(2.0)
 for _kare in 12:
  await get_tree().process_frame
  var bakis := -kamera.global_basis.z
  var konusan := KapiKameraVurgu.kadraj_hesapla(birinci.global_position) - kamera.global_position
  var bekleyen := KapiKameraVurgu.kadraj_hesapla(ikinci.global_position) - kamera.global_position
  if kamera != kamera.get_viewport().get_camera_3d() or not kamera.global_transform.is_equal_approx(once) or not is_equal_approx(kamera.fov, fov):
   push_error("SAH-51: Konuşma sırasında kamera veya görüş açısı değişti.")
   return false
  if not KapiKameraVurgu.kadrajda_mi(kamera, birinci.global_position) or bakis.angle_to(konusan) >= bakis.angle_to(bekleyen):
   push_error("SAH-51: Kameranın merkezine konuşan yüz daha yakın olmalı.")
   return false
 if ikinci.position.distance_to(ikinci_yeri) < 0.05:
  push_error("SAH-51: Bekleyen model sırada ilerlemedi.")
  return false
 print("SAH-51 DÖRT KİŞİLİK KADRAJ: GEÇTİ")
 return await _karar_kadraji(e, birinci)


func _karar_kadraji(e: KapiEkrani, konusan: KarakterModel) -> bool:
 var kamera := e.sahne.kamera
 var yuz := KapiKameraVurgu.kadraj_hesapla(konusan.global_position)
 var sohbet_konumu := kamera.global_position
 var sohbet_mesafesi := sohbet_konumu.distance_to(yuz)
 e._karar_goster()
 await get_tree().create_timer(0.6).timeout
 if e.evre != &"karar" or kamera.global_position.distance_to(yuz) <= sohbet_mesafesi:
  push_error("SAH-52: Karar panelinde kamera yüzden uzaklaşmalı.")
  return false
 if not KapiKameraVurgu.kadrajda_mi(kamera, konusan.global_position):
  push_error("SAH-52: Karar panelinde konuşanın yüzü kadrajda kalmalı.")
  return false
 e._sohbet_goster()
 await get_tree().create_timer(0.6).timeout
 if e.evre != &"sohbet" or not kamera.global_position.is_equal_approx(sohbet_konumu):
  push_error("SAH-52: Sohbete dönünce kamera başlangıç mesafesine dönmeli.")
  return false
 print("SAH-52 KARAR KADRAJI: GEÇTİ")
 return true
