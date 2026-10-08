extends SceneTree
var hata := 0
func _initialize() -> void:
 var g := Izgara.new(Vector2i(5, 5), Rect2i(0, 0, 1, 1))
 g.dolu[Vector2i(2, 2)] = 1
 g.engeller[Vector2i(1, 1)] = true
 var once := str(g.dolu) + str(g.engeller) + str(g.yollar)
 var mesh := KoyZeminNavigasyonu.koridor(g, 2.0, Vector3.ZERO)
 var vertices := mesh.vertices
 var centers := {}
 for i in mesh.get_polygon_count():
  var c := Vector3.ZERO
  var poly := mesh.get_polygon(i)
  for j in poly: c += vertices[j]
  c /= poly.size()
  var cell := Vector2i(floori(c.x / 2), floori(c.z / 2))
  centers[cell] = true
  dene(not g.dolu.has(cell) and not g.engeller.has(cell), "Engel içinde polygon yok")
 dene(centers.size() == 23, "Tüm açık hücreler kapsanır")
 dene(str(g.dolu) + str(g.engeller) + str(g.yollar) == once, "Izgara salt okunur")
 # Yapının bitişik köşesine yaklaşan geniş diagonal polygon yok.
 dene(not vertices.has(Vector3(4, 0, 4)), "Bina köşesinde tampon bırakılır")
 print("ZEMİN NAVİGASYONU: GEÇTİ" if hata == 0 else "ZEMİN NAVİGASYONU: KALDI")
 quit(hata)
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
