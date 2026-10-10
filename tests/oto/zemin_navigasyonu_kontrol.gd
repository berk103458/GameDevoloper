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
 var son := Vector2i(m.position.x + m.size.x / 2, y.izgara.boyut.y - 1)
 var cells := h.rotaci.yol(bas, son)
 var yol := KoyZeminNavigasyonu.yol(h, cells)
 kontrol(not yol.is_empty() and n.sorgu_sayisi > 0 and n.yedek_sayisi == 0, "Patika/kapı rotası NavigationServer3D kullanır")
 kontrol(yol[-1].is_equal_approx(h._konum(son)), "Kapı hedefi aynen korunur")
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
 ana.kayit.sil()
 ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.3).timeout
 print("ZEMİN NAVİGASYONU UI: GEÇTİ" if hata == 0 else "ZEMİN NAVİGASYONU UI: KALDI")
 await Ses.cik(hata)
func kontrol(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
