extends Node
class TestAna extends Ana:
 func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  ayarlar = Ayarlar.new("user://unused_particles.cfg")
  katalog = Katalog.new()
  katalog.yukle()
  oturum = Oturum.new(katalog, 76)
  kayit = GuvenliKayit.new("user://test_particles_ui.json")
  theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
 get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
 var ana := TestAna.new()
 add_child(ana)
 var y := ana.oturum.yonetim
 y.kaynaklar.kapasite = 10000
 for t in ["odun", "tas", "kereste", "demir", "un"]: y.kaynaklar.ekle(t, 100)
 var bs: Array[KoyBinasi] = []
 var ids: Array[int] = []
 for tur in ["demirhane", "firin", "tarla"]:
  var b := _kur(y, tur)
  kontrol(b != null, "Gerçek zanaat binası")
  if b == null:
   await Ses.cik(1)
   return
  var k := y.kabul({"sinif": "ciftci", "stat": 5})
  k.zanaat_turu = ZanaatTuru.Tur.DEMIRCI if tur == "demirhane" else ZanaatTuru.Tur.ESNAF
  kontrol(y.ata(k.id, b.id), "Gerçek zanaat ataması")
  if tur != "tarla": kontrol(y.recete_sec(b.id, "alet" if tur == "demirhane" else "ekmek"), "Gerçek reçete")
  bs.append(b)
  ids.append(k.id)
 var once := JSON.stringify(ana.oturum.kaydet())
 ana._koye_git()
 await get_tree().process_frame
 var s: KoyYonetimSahnesi = ana._ekran.sahne3b
 var h := s.halk_hareketi
 h.set_process(false)
 for i in 3: h._process(0.0)
 for id in ids:
  if id == ids[2]:
   h._durum[id].sulama_i = 1
   h._iste(id)
   h._process(0.0)
  var f: KarakterModel = h.modeller[id]
  var d: Dictionary = h._durum[id]
  kontrol(d.is, "Çalışan/girdili iş aktif")

  for adim in range(d.yol.size() + 1):
   if int(d.adim) >= d.yol.size(): break
   f.position = d.yol[d.adim]
   h._process(0.0)
  f.yurumeyi_durdur()

 s.set_process(false)
 var fxler: Array[AtolyeParcaciklari] = []
 for node in s.find_children("atolye_parcaciklari", "", true, false): fxler.append(node)
 kontrol(fxler.size() == 3, "Üç hazır binada birer efekt grubu")
 for fx in fxler:
  s.kamera.position = fx.global_position + Vector3(0, 5, 8)
  s.kamera.look_at(fx.global_position)
  fx.guncelle()
  for tur in fx.efektler:
   var p: CPUParticles3D = fx.efektler[tur]
   kontrol(p.emitting and p.mesh is BoxMesh and p.fixed_fps == 20, "Çalışma durağında gerçek CPU parçacığı/kutu")
   kontrol(p.amount == int(AtolyeParcaciklari.AYAR.efektler[tur].adet), "Yakında sınırlı tam bütçe")
  s.kamera.position = fx.global_position + Vector3(0, 0, 40)
  s.kamera.look_at(fx.global_position)
  fx.guncelle()
  for tur in fx.efektler: kontrol(fx.efektler[tur].amount <= ceili(AtolyeParcaciklari.AYAR.efektler[tur].adet * 0.5), "Orta mesafede yarım bütçe")
  s.kamera.position = fx.global_position + Vector3(0, 0, 100)
  s.kamera.look_at(fx.global_position)
  fx.guncelle()
  for p in fx.efektler.values(): kontrol(not p.emitting and not p.visible, "Uzakta emisyon ve çizim kapalı")
 var grafik := GrafikProfiliAdaptoru.new()
 grafik.ayarlar = ana.ayarlar
 grafik.hedef = ana
 ana.add_child(grafik)
 ana.ayarlar.ayarla(&"grafik_profili", &"dusuk")
 for fx in fxler:
  s.kamera.position = fx.global_position + Vector3(0, 5, 8)
  s.kamera.look_at(fx.global_position)
  fx.guncelle()
  for p in fx.efektler.values(): kontrol(p.layers == 0 and not p.emitting, "Düşük profil global adaptörle kapalı kalır")
 ana.ayarlar.ayarla(&"grafik_profili", &"normal")
 for fx in fxler:
  s.kamera.position = fx.global_position + Vector3(0, 5, 8)
  s.kamera.look_at(fx.global_position)
  fx.guncelle()
  for p in fx.efektler.values(): kontrol(p.layers != 0 and p.emitting, "Normal profile canlı dönüşte iş efekti geri gelir")
 var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
 if not dizin.is_empty() and DisplayServer.get_name() != "headless":
  for fx in fxler:
   var odak: Vector3 = fx.efektler.su.global_position if fx.efektler.has("su") else fx.global_position + Vector3.UP
   s.kamera.position = odak + Vector3(4, 3, 5)
   s.kamera.look_at(odak)
   fx.guncelle()
   await get_tree().create_timer(1.0).timeout
   await RenderingServer.frame_post_draw
   get_viewport().get_texture().get_image().save_png(dizin.path_join("ani15_%d.png" % fx.bina_id))
 var un := y.kaynaklar.miktar("un")
 y.kaynaklar.harca({"un": un})
 for fx in fxler:
  if fx.bina_id != bs[1].id: continue
  s.kamera.position = fx.global_position + Vector3(0, 5, 8)
  s.kamera.look_at(fx.global_position)
  fx.guncelle()
  for p in fx.efektler.values(): kontrol(not p.emitting, "Girdi bitince yürüyüş planı yenilenmeden bile fırın dumanı durur")
 y.kaynaklar.ekle("un", un)
 h.faz(&"gece")
 for fx in fxler:
  fx.guncelle()
  for p in fx.efektler.values(): kontrol(not p.emitting, "Gece üretim durağı emisyonu kapanır")
 kontrol(JSON.stringify(ana.oturum.kaydet()) == once, "Efektler stok/kayıt/RNG değiştirmez")
 ana.kayit.sil()
 ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.3).timeout
 print("ATÖLYE PARÇACIKLARI UI: GEÇTİ" if hata == 0 else "ATÖLYE PARÇACIKLARI UI: KALDI")
 await Ses.cik(hata)
func _kur(y: KoyYonetimi, tur: String) -> KoyBinasi:
 for cy in y.a.izgara_boyut.y:
  for cx in y.a.izgara_boyut.x:
   var h := Vector2i(cx, cy)
   if y.yerlesim(tur, h).olur:
    var b := y.bina(y.bina_kur(tur, h).id)
    if b == null: return null
    b.insa_kalan = 0
    return b
 return null
func kontrol(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
