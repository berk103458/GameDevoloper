## ANI-02: hedef politikası; mevcut A* ve halk hareket kuyruğunu kullanır.
class_name MuhafizDevriyesi
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/muhafiz_devriyesi.json"))
## Kapı, hazır kışlalar ve işlevli sur kulelerinin kararlı hücre sırası.
static func duraklar(y: KoyYonetimi) -> Array[Dictionary]:
 var s: Array[Dictionary] = KurtBaskini.duraklar(y)
 s.append({"hucre": KapiNobeti.esik_hucresi(y), "kisi": KapiNobeti.yuva(y), "ad": "Kapıda nöbet"})
 for b in y.binalar:
  if b.tur == "muhafiz_kislasi" and b.hazir():
   s.append({"bina": b, "ad": "Kışlada nöbet"})
 if y.sur_seviye > 0 and y.sur_hasar < 100:
  for h in kuleler(y): s.append({"hucre": h, "ad": "Sur kulesinde nöbet"})
 return s
## Köşe kuleleriyle aynı hücreler; görsel konum ve devriye tek kaynaktan gelir.
static func kuleler(y: KoyYonetimi) -> Array[Vector2i]:
 var b := y.a.izgara_boyut - Vector2i.ONE
 return [Vector2i.ZERO, Vector2i(b.x, 0), b, Vector2i(0, b.y)]
## Erişilmeyen durakları atlar; tümü kopuksa boş sonuçla mevcut yerde bekler.
static func hedef(y: KoyYonetimi, r: KoyRotasi, bas: Vector2i, sira: int, kisi: int = -1) -> Dictionary:
 var taktik := SavunmaKonuslanmasi.hedef(y, r, bas, kisi, sira)
 if not taktik.is_empty(): return taktik
 var ds := duraklar(y)
 for i in ds.size():
  var d: Dictionary = ds[posmod(sira + i, ds.size())]
  var son: Vector2i = r.bina_duragi(bas, Rect2i(d.bina.hucre, d.bina.boyut(y.katalog)), sira) if d.has("bina") else r.yakin(d.hucre)
  if son.x >= 0 and not r.yol(bas, son).is_empty():
   return {"son": son, "ad": d.ad, "sira": posmod(sira + i, ds.size())}
 return {}
## Mevcut yapı köküne dört ahşap gözetleme platformu; kayıt/ızgara doluluğu değişmez.
static func kule_kur(s: KoyYonetimSahnesi, kok: Node3D) -> void:
 if s.yonetim.sur_seviye <= 0 or s.yonetim.sur_hasar >= 100: return
 var en := float(AYAR.kule_genislik)
 var boy := float(AYAR.kule_yukseklik)
 var d := float(AYAR.direk_kalinlik)
 for h in kuleler(s.yonetim):
  var n := Node3D.new()
  n.name = "devriye_kulesi_%d_%d" % [h.x, h.y]
  n.set_meta("devriye_kulesi", true)
  n.position = s.alan_merkezi(h, Vector2i.ONE)
  # Izgara dışına taşan kule; yürüyüş zeminde iç köşe durağına yapılır.
  n.position += Vector3(-s.HUCRE if h.x == 0 else s.HUCRE, 0, -s.HUCRE if h.y == 0 else s.HUCRE)
  kok.add_child(n)
  for x in [-1, 1]:
   for z in [-1, 1]: _kutu(n, Vector3(d, boy, d), Vector3(x * en / 2, boy / 2, z * en / 2))
  _kutu(n, Vector3(en + d, float(AYAR.platform_kalinlik), en + d), Vector3(0, boy * 0.65, 0))
  for x in [-1, 1]: _kutu(n, Vector3(d, d, en), Vector3(x * en / 2, boy * 0.65 + float(AYAR.korkuluk_yukseklik), 0))
  for z in [-1, 1]: _kutu(n, Vector3(en, d, d), Vector3(0, boy * 0.65 + float(AYAR.korkuluk_yukseklik), z * en / 2))
static func _kutu(n: Node3D, boy: Vector3, p: Vector3) -> void:
 var m := MeshInstance3D.new()
 var b := BoxMesh.new()
 b.size = boy
 m.mesh = b
 m.position = p
 m.material_override = Dunya3B.duz_malzeme(Color(AYAR.renk))
 n.add_child(m)
