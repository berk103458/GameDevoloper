## ANI-13: mevcut A* hücrelerini aynı engellerden kurulan 3B koridor haritasına geçirir.
class_name KoyZeminNavigasyonu
extends NavigationRegion3D
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/koy_zemin_navigasyonu.json"))
var _onceki_iterasyon := 0
var _onceki_bolge := 0
var _ornek := Vector3.ZERO
var _bekliyor := true
var sorgu_sayisi := 0
var yedek_sayisi := 0

## Tek bölgeyi doluluk değişimine göre yeniler; kayıt/ekonomi ve A* hedefleri korunur.
static func yenile(h: KoyHalkHareketi) -> void:
 var n := h.get_node_or_null("zemin_navigasyonu") as KoyZeminNavigasyonu
 if n == null:
  n = KoyZeminNavigasyonu.new()
  n.name = "zemin_navigasyonu"
  h.add_child(n)
 n._onceki_iterasyon = NavigationServer3D.map_get_iteration_id(n.get_navigation_map())
 n._onceki_bolge = NavigationServer3D.region_get_iteration_id(n.get_rid())
 n._bekliyor = true
 n.set_physics_process(true)
 var mesh := koridor(h.rotaci._izgara, h.sahne.HUCRE, h.sahne.hucre_kosesi(Vector2i.ZERO))
 mesh.cell_size = NavigationServer3D.map_get_cell_size(n.get_navigation_map())
 mesh.cell_height = NavigationServer3D.map_get_cell_height(n.get_navigation_map())
 n.navigation_layers = int(AYAR.navigation_layers)
 n.navigation_mesh = mesh
 n._ornek = mesh.vertices[0] if not mesh.vertices.is_empty() else Vector3.ZERO

## Bina/engele polygon yazmaz; ortak kenarlı dört yönlü kollar köşeden kesmeyi önler.
static func koridor(g: Izgara, hucre: float, kose: Vector3) -> NavigationMesh:
 var mesh := NavigationMesh.new()
 var noktalar := PackedVector3Array()
 var indeks := {}
 var polygonlar: Array[PackedInt32Array] = []
 var rota := KoyRotasi.new()
 rota.kur(g, 1.0)
 var yari := hucre * 0.5
 var ic := yari - float(AYAR.kenar_bosluk)
 for y in g.boyut.y:
  for x in g.boyut.x:
   var h := Vector2i(x, y)
   if not rota.gecilir(h): continue
   var c := kose + Vector3((x + 0.5) * hucre, 0, (y + 0.5) * hucre)
   var alanlar: Array[Rect2] = [Rect2(-ic, -ic, ic * 2, ic * 2)]
   if rota.gecilir(h + Vector2i.RIGHT): alanlar.append(Rect2(ic, -ic, yari - ic, ic * 2))
   if rota.gecilir(h + Vector2i.LEFT): alanlar.append(Rect2(-yari, -ic, yari - ic, ic * 2))
   if rota.gecilir(h + Vector2i.DOWN): alanlar.append(Rect2(-ic, ic, ic * 2, yari - ic))
   if rota.gecilir(h + Vector2i.UP): alanlar.append(Rect2(-ic, -yari, ic * 2, yari - ic))
   for a in alanlar:
    var polygon := PackedInt32Array()
    for p in [a.position, Vector2(a.position.x, a.end.y), a.end, Vector2(a.end.x, a.position.y)]:
     var v := c + Vector3(p.x, 0, p.y)
     if not indeks.has(v):
      indeks[v] = noktalar.size()
      noktalar.append(v)
     polygon.append(int(indeks[v]))
    polygonlar.append(polygon)
 mesh.vertices = noktalar
 for polygon in polygonlar: mesh.add_polygon(polygon)
 return mesh

## Harita senkronizasyonu bitmeden eski navmesh kullanılmaz.
func hazir() -> bool:
 return not _bekliyor

func _physics_process(_delta: float) -> void:
 if not _bekliyor: return
 var iterasyon := NavigationServer3D.map_get_iteration_id(get_navigation_map())
 var bolge := NavigationServer3D.region_get_iteration_id(get_rid())
 var haritada := iterasyon != 0 and NavigationServer3D.map_get_closest_point_owner(get_navigation_map(), _ornek) == get_rid()
 if _bekliyor and bolge != 0 and bolge != _onceki_bolge and iterasyon != _onceki_iterasyon and haritada:
  _bekliyor = false
  set_physics_process(false)

## Patika ağırlıklı A* sırası korunur; her komşu segment gerçek 3B haritadan sorgulanır.
static func yol(h: KoyHalkHareketi, hucreler: Array[Vector2i]) -> Array[Vector3]:
 var eski: Array[Vector3] = []
 for cell in hucreler:
  if not h.rotaci.gecilir(cell): return []
  eski.append(h._konum(cell))
 var n := h.get_node_or_null("zemin_navigasyonu") as KoyZeminNavigasyonu
 if n == null or not n.hazir() or eski.size() < 2: return eski
 var sonuc: Array[Vector3] = [eski[0]]
 for i in range(1, eski.size()):
  var parca := NavigationServer3D.map_get_path(n.get_navigation_map(), eski[i - 1], eski[i], true, n.navigation_layers)
  n.sorgu_sayisi += 1
  if parca.is_empty() or parca[-1].distance_to(eski[i]) > float(AYAR.hedef_toleransi):
   n.yedek_sayisi += 1
   return eski
  for p in parca:
   if not sonuc[-1].is_equal_approx(p): sonuc.append(p)
 return sonuc
