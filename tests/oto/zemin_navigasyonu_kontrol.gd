extends Node
class TestAna extends Ana:
 func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  ayarlar = Ayarlar.new("user://unused_nav.cfg")
  katalog = Katalog.new()
  katalog.yukle()
  oturum = Oturum.new(katalog, 76)
  kayit = GuvenliKayit.new("user://test_nav_ui.json")
  theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
 get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
 var ana := TestAna.new()
 add_child(ana)
 var y := ana.oturum.yonetim
 y.kabul({"sinif": "ciftci", "stat": 5})
 var once := JSON.stringify(ana.oturum.kaydet().merged({"faz": "koy"}, true))
 ana._koye_git()
 await get_tree().process_frame
 var s: KoyYonetimSahnesi = ana._ekran.sahne3b
 var h := s.halk_hareketi
 h.set_process(false)
 var n := h.get_node("zemin_navigasyonu") as KoyZeminNavigasyonu
 for i in 120:
  if n.hazir(): break
  await get_tree().physics_frame
 kontrol(n.hazir(), "Gerçek NavigationRegion3D haritası senkronize olur")
 var m := y.a.meydan
 var bas := m.position
 var son := KapiNobeti.esik_hucresi(y)
 var cells := h.rotaci.yol(bas, son)
 var yol := KoyZeminNavigasyonu.yol(h, cells)
 kontrol(not yol.is_empty() and n.sorgu_sayisi > 0 and n.yedek_sayisi == 0, "Patika/kapı rotası NavigationServer3D kullanır")
 kontrol(yol[-1].is_equal_approx(h._konum(son)), "Kapı hedefi aynen korunur")
 await _esikten_yuru(s, n, yol, son)
 # Gerçek bina hücreleri navmesh dışındadır; geçilmez arazi de aynı süzgeçten geçer.
 var mesh := n.navigation_mesh
 var vertices := mesh.vertices
 for i in mesh.get_polygon_count():
  var merkez := Vector3.ZERO
  var polygon := mesh.get_polygon(i)
  for index in polygon: merkez += vertices[index]
  merkez /= polygon.size()
  var kose := s.hucre_kosesi(Vector2i.ZERO)
  var cell := Vector2i(floori((merkez.x - kose.x) / s.HUCRE), floori((merkez.z - kose.z) / s.HUCRE))
  kontrol(h.rotaci.gecilir(cell), "Polygon bina/arazi içinde değil")
 var engel := cells[cells.size() / 2]
 y.izgara.engeller[engel] = true
 h.yenile()
 kontrol(not n.hazir(), "Doluluk değişince önceki navmesh devre dışı")
 kontrol(KoyZeminNavigasyonu.yol(h, cells).is_empty(), "Eski rotadaki yeni kapalı hücre reddedilir")
 var guvenli := h.rotaci.yol(bas, son)
 kontrol(KoyZeminNavigasyonu.yol(h, guvenli).size() == guvenli.size(), "Sync sırasında güncel güvenli A* yolu")
 for i in 120:
  if n.hazir(): break
  await get_tree().physics_frame
 kontrol(n.hazir(), "Yenilenen bölge yeniden senkronize")
 kontrol(NavigationServer3D.map_get_closest_point(n.get_navigation_map(), h._konum(engel)).distance_to(h._konum(engel)) > 0.5, "Yeni engel gerçek server haritasından da çıkar")
 var dolambac := h.rotaci.yol(bas, son)
 kontrol(not dolambac.is_empty() and not dolambac.has(engel), "Yeni engel A* hedef sırasından çıkar")
 var nav := KoyZeminNavigasyonu.yol(h, dolambac)
 kontrol(n.yedek_sayisi == 0, "Yeni engelden sonra rota da gerçek navmesh kullanır")
 var kose := s.hucre_kosesi(Vector2i.ZERO)
 for i in range(1, nav.size()):
  for j in 17:
   var nokta: Vector3 = nav[i - 1].lerp(nav[i], j / 16.0)
   var cell := Vector2i(floori((nokta.x - kose.x) / s.HUCRE), floori((nokta.z - kose.z) / s.HUCRE))
   kontrol(h.rotaci.gecilir(cell), "Rota segmenti engel içinden geçmez")
 y.izgara.engeller.erase(engel)
 h.yenile()
 kontrol(JSON.stringify(ana.oturum.kaydet()) == once, "Navigasyon kayıt/stok/RNG değiştirmez")
 await _karsilasma(s, n, y.koylular[0].id)
 ana.kayit.sil()
 ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.3).timeout
 print("ZEMİN NAVİGASYONU UI: GEÇTİ" if hata == 0 else "ZEMİN NAVİGASYONU UI: KALDI")
 await Ses.cik(hata)

func _esikten_yuru(s: KoyYonetimSahnesi, n: KoyZeminNavigasyonu, yol: Array[Vector3], esik: Vector2i) -> void:
 var kp := s.kapi_noktasi()
 var hedef := Vector3(kp.x, 0.0, kp.y)
 hedef.y = s.ayak_zemini_yuksekligi(hedef)
 var gorsel: Node3D
 for aday in get_tree().get_nodes_in_group(&"koy_kapisi"):
  if aday.get_parent() == s._yapilar and not aday.is_queued_for_deletion():
   gorsel = aday
   break
 kontrol(gorsel != null and gorsel.position.is_equal_approx(hedef), "SAH-05: Köy kapısı ortak zemindeki eşik konumuna yerleşir")
 var harita := n.get_navigation_map()
 var gecis := NavigationServer3D.map_get_closest_point(harita, hedef)
 kontrol(gecis.distance_to(hedef) < 0.02, "SAH-05: Görünür köy eşiği gerçek gezinme ağında")
 kontrol(yol[-1].is_equal_approx(hedef), "SAH-05: Muhafız durağı ile eşik aynı hücrede")
 var dis := esik + Vector2i.DOWN
 kontrol(KoyZeminNavigasyonu.yol(s.halk_hareketi, [esik, dis]).is_empty(), "SAH-05: Sınır dışındaki komşuya rota verilmez")
 if yol.size() < 2 or not yol[-1].is_equal_approx(hedef):
  return
 var f := Dunya3B.karakter("ciftci")
 f.position = yol[-2]
 s.add_child(f)
 f.bak(hedef)
 var ayak := f.get_node("AyakZemini") as AyakZemini
 var kose := s.hucre_kosesi(Vector2i.ZERO)
 var gomulme := 0
 var ag_disi := 0
 var esik_temasi := 0
 var kare := 0
 f.yuru(hedef, 1.35)
 while f._yurume != null and f._yurume.is_running():
  await get_tree().process_frame
  var farklar := ayak.temas_farklari()
  for i in farklar.size():
   if farklar[i] < -0.0001:
    gomulme += 1
   if farklar[i] > 0.025:
    continue
   var taban := f.position + f.basis * (ayak._ham_tabanlar[i] + ayak._gorsel.position - ayak._taban_konum)
   var hucre := Vector2i(floori((taban.x - kose.x) / s.HUCRE), floori((taban.z - kose.z) / s.HUCRE))
   var yakin := NavigationServer3D.map_get_closest_point(harita, taban)
   var yatay_fark := Vector2(taban.x - yakin.x, taban.z - yakin.z).length()
   if not s.halk_hareketi.rotaci.gecilir(hucre) or yatay_fark > 0.02:
    ag_disi += 1
   elif hucre == esik:
    esik_temasi += 1
  kare += 1
 kontrol(f.position.is_equal_approx(hedef) and kare > 0 and esik_temasi > 0, "SAH-05: Gerçek karakter eşik hücresine basar")
 kontrol(gomulme == 0 and ag_disi == 0, "SAH-05: Eşik yürüyüşünde gömülme ve ağ dışı basış yok")
 print("SAH-05: %d kare, eşik teması=%d, gömülme=%d, ağ dışı=%d" % [kare, esik_temasi, gomulme, ag_disi])
 f.queue_free()


func _karsilasma(s: KoyYonetimSahnesi, n: KoyZeminNavigasyonu, ilk_id: int) -> void:
 var y := s.yonetim
 var h := s.halk_hareketi
 var ikinci := y.kabul({"sinif": "ciftci", "stat": 5})
 var m := y.a.meydan
 var tercih := m.position + Vector2i(ikinci.id % m.size.x, (ikinci.id / m.size.x) % m.size.y)
 var ilk: KarakterModel = h.modeller[ilk_id]
 ilk.position = h._konum(h.rotaci.yakin(tercih))
 h.yenile()
 var yeni: KarakterModel = h.modeller[ikinci.id]
 kontrol(ilk.position.distance_to(yeni.position) >= AyakZemini.CARPISMA_PAYI, "SAH-07: Yeni model dolu kök konumuna doğmaz")
 h._bekleyen.clear()
 for i in 120:
  if n.hazir(): break
  await get_tree().physics_frame
 for uzaklik in [1, 2]:
  await _karsi_yuru(h, n, ilk_id, ikinci.id, uzaklik)


func _karsi_yuru(h: KoyHalkHareketi, n: KoyZeminNavigasyonu, ilk_id: int, ikinci_id: int, uzaklik: int) -> void:
 var y := h.sahne.yonetim
 var bas := y.a.meydan.position
 var son := bas + Vector2i.RIGHT * uzaklik
 var ileri := KoyZeminNavigasyonu.yol(h, h.rotaci.yol(bas, son))
 kontrol(n.hazir() and ileri.size() >= 2 and n.yedek_sayisi == 0, "SAH-07: Aynı canlı ANI-13 koridoru kullanılır")
 if ileri.size() < 2:
  return
 var geri := ileri.duplicate()
 geri.reverse()
 var a: KarakterModel = h.modeller[ilk_id]
 var b: KarakterModel = h.modeller[ikinci_id]
 a.position = ileri[0]
 b.position = geri[0]
 a.bak(ileri[-1])
 b.bak(geri[-1])
 h._durum[ilk_id].yol = ileri
 h._durum[ikinci_id].yol = geri
 h._durum[ilk_id].adim = 0
 h._durum[ikinci_id].adim = 0
 var once := JSON.stringify(y.kaydet())
 h._adim(ilk_id)
 h._adim(ikinci_id)
 var en_yakin := a.position.distance_to(b.position)
 var ag_disi := 0
 var sure := 0.0
 var kare := 0
 while sure < 5.0:
  await get_tree().process_frame
  var dt := get_process_delta_time()
  h._process(dt)
  en_yakin = minf(en_yakin, a.position.distance_to(b.position))
  for aktor in [a, b]:
   var kok: Vector3 = aktor.global_position
   var en_yakin_ag := NavigationServer3D.map_get_closest_point(n.get_navigation_map(), kok)
   if kok.distance_to(en_yakin_ag) > 0.021:
    ag_disi += 1
  sure += dt
  kare += 1
  if a.position.distance_to(ileri[-1]) <= 0.03 and b.position.distance_to(geri[-1]) <= 0.03:
   break
 kontrol(kare >= 30 and en_yakin >= AyakZemini.CARPISMA_PAYI - 0.001, "SAH-07: İki kök hiçbir karede çarpışma payından yakına girmez")
 kontrol(a.position.distance_to(ileri[-1]) <= 0.03 and b.position.distance_to(geri[-1]) <= 0.03, "SAH-07: İki köylü karşılıklı geçip hedefe varır")
 kontrol(ag_disi == 0, "SAH-07: Yan adımlar aynı ANI-13 bölgesinde kalır")
 kontrol(JSON.stringify(y.kaydet()) == once, "SAH-07: Kök ayırma kalıcı köy durumunu değiştirmez")
 print("SAH-07: %d hücre, %d kare, en yakın iki kök=%.5f m, geçiş süresi=%.2f s, ağ dışı=%d" % [uzaklik, kare, en_yakin, sure, ag_disi])

func kontrol(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
