## ANI-09: mevcut hava verisini okur; ikinci hava/üretim simülasyonu yoktur.
class_name KarakterHavaTepkisi
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/karakter_hava.json"))
## Yağmur mevcut iklim debug/runtime sözleşmesine eklenmiş hava değeridir.
static func yagmur(y: KoyYonetimi) -> bool:
 return IklimDeneyi.hava(y) == "yagmur"
## Kar fırtınasında görsel yürüyüş çarpanı; ekonomik tüketim aynı kalır.
static func hiz(y: KoyYonetimi) -> float:
 return float(AYAR.kar_hiz) if IklimDeneyi.hava(y) == "kar_firtinasi" else 1.0
## Ayrı iskelet katmanına verilen hafif omuz büzülmesi (radyan).
static func egim(y: KoyYonetimi) -> float:
 return float(AYAR.kar_egim) if IklimDeneyi.hava(y) == "kar_firtinasi" else 0.0
## Hazır yapının dış, yürünebilir ön hücresi; yapı içine rota yapılmaz.
static func durak(y: KoyYonetimi, b: KoyBinasi) -> Vector2i:
 var boy := b.boyut(y.katalog)
 return b.hucre + Vector2i(boy.x - 1, boy.y)
## Aynı A* üzerinde erişilen en yakın hazır saçak. Nöbetçiler görevde kalır.
static func hedef(h: KoyHalkHareketi, k: Koylu, bas: Vector2i) -> Dictionary:
 var y := h.sahne.yonetim
 if not yagmur(y) or MuhafizMaasi.aday(k, y): return {}
 var en_kisa := 2147483647
 var sonuc := {}
 for b in y.binalar:
  if not b.hazir() or b.tur not in AYAR.sacak_turleri: continue
  var son := durak(y, b)
  var yol := h.rotaci.yol(bas, son)
  if yol.is_empty() or yol.size() >= en_kisa: continue
  en_kisa = yol.size()
  sonuc = {"son": son, "bak": h.sahne.alan_merkezi(b.hucre, b.boyut(y.katalog))}
 return sonuc
## Tek değişim noktası: ön durak üzerinde düz renk kutu saçak yer tutucusu.
static func sacak_kur(s: KoyYonetimSahnesi, n: Node3D, b: KoyBinasi) -> void:
 if b.tur not in AYAR.sacak_turleri: return
 var hazir := HazirKoyYapilari.sacak(Vector3(AYAR.sacak_boy[0], AYAR.sacak_yukseklik, AYAR.sacak_boy[2]))
 if hazir != null:
  hazir.name = "hava_sacagi_hazir"
  hazir.position = s.alan_merkezi(durak(s.yonetim, b), Vector2i.ONE) - s.alan_merkezi(b.hucre, b.boyut(s.yonetim.katalog))
  n.add_child(hazir)
  return
 var m := MeshInstance3D.new()
 m.name = "hava_sacagi_yer_tutucu"
 var kutu := BoxMesh.new()
 kutu.size = Vector3(AYAR.sacak_boy[0], AYAR.sacak_boy[1], AYAR.sacak_boy[2])
 m.mesh = kutu
 m.material_override = Dunya3B.duz_malzeme(Color(AYAR.sacak_renk))
 m.position = s.alan_merkezi(durak(s.yonetim, b), Vector2i.ONE) - s.alan_merkezi(b.hucre, b.boyut(s.yonetim.katalog)) + Vector3(0, float(AYAR.sacak_yukseklik), 0)
 n.add_child(m)
