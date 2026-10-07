## ANI-07: mevcut ateşe salt görsel toplanma; iş ve nöbet atamalarını değiştirmez.
class_name AtesBasiRutini
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/ates_basi_rutini.json"))
## Yalnız boşta köylüler; atanmış çalışan ve nöbetçiler mevcut rutinde kalır.
static func aday(y: KoyYonetimi, k: Koylu, faz: StringName) -> bool:
 return k != null and faz in [&"aksam", &"gece"] and k.is_yeri == KoyYonetimi.BOSTA and not MuhafizMaasi.aday(k, y)
## Görsel ocak ve yönelme aynı ayardan gelir; ikinci ateş kurulmaz.
static func konum(s: KoyYonetimSahnesi) -> Vector3:
 var m := s.yonetim.a.meydan
 return s.alan_merkezi(m.position, m.size) + Vector3(float(AYAR.ates_ofset[0]), 0.03, float(AYAR.ates_ofset[1]))
## Açık, ateş/kuyu dışında benzersiz durak; erişilemeyen hedefte mevcut rutin korunur.
static func hedef(h: KoyHalkHareketi, k: Koylu, bas: Vector2i) -> Dictionary:
 var s := h.sahne
 var ates := konum(s)
 var kuyu := SulamaRutini.kuyu_konumu(s)
 var m := s.yonetim.a.meydan
 var yerler: Array[Vector2i] = []
 for cy in range(m.position.y - 2, m.end.y + 2):
  for cx in range(m.position.x - 2, m.end.x + 2):
   var hucre := Vector2i(cx, cy)
   if not h.rotaci.gecilir(hucre): continue
   var p := h._konum(hucre)
   var mesafe := Vector2(p.x - ates.x, p.z - ates.z).length()
   if mesafe >= float(AYAR.en_yakin) and mesafe <= float(AYAR.en_uzak) and p.distance_to(kuyu) >= float(AYAR.kuyu_mesafesi): yerler.append(hucre)
 # İlk az sayıdaki köylü de tüm halkaya yayılsın; aynı sıra her aday için korunur.
 var sirali: Array[Vector2i] = []
 while not yerler.is_empty():
  var sec := 0
  var en_iyi := -1.0
  for i in yerler.size():
   var uzaklik := INF
   for once in sirali: uzaklik = minf(uzaklik, Vector2(yerler[i]).distance_squared_to(Vector2(once)))
   if uzaklik > en_iyi:
    en_iyi = uzaklik
    sec = i
  sirali.append(yerler[sec])
  yerler.remove_at(sec)
 yerler = sirali
 var ids: Array[int] = []
 for id in h.modeller:
  if aday(s.yonetim, s.yonetim.koylu(id), h.faz_adi): ids.append(id)
 ids.sort()
 var sira := ids.find(k.id)
 if sira < 0 or sira >= yerler.size(): return {}
 var son := yerler[sira]
 if h.rotaci.yol(bas, son).is_empty(): return {}
 return {"son": son, "bak": ates}
## Mevcut DurusDuzeltici içinde iki eli öne uzatan yumuşak ısınma döngüsü.
static func kol(yan: float, zaman: float) -> Array[Vector3]:
 var salla := sin(zaman * float(AYAR.salinim_hizi)) * float(AYAR.salinim)
 return [Vector3(yan * float(AYAR.kol_yana), float(AYAR.kol_asagi), float(AYAR.kol_one)), Vector3(yan * float(AYAR.onkol_yana), float(AYAR.onkol_yukari) + salla, float(AYAR.onkol_one))]
