## ANI-10: mevcut risklerden türeyen salt görsel gece rutini; suç/RNG hesabı yok.
class_name SinsiGeceRutini
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/sinsi_gece.json"))
## Sağlıklı gece adayları; muhafız ve normal köylü rutini korunur.
static func aday(y: KoyYonetimi, k: Koylu, faz: StringName) -> bool:
 if k == null or faz != &"gece" or MuhafizMaasi.aday(k, y): return false
 if k.saglik <= 0 or "hasta" in k.bayraklar + k.gizli_bayraklar or "agir_yarali" in k.bayraklar + k.gizli_bayraklar: return false
 return GizliEgilimler.risk(k) > 0.0 or IsMemnuniyeti.sabotaj_riski(k, y) > 0.0
## Sadece görünür mevcut nöbetçilerin gerçek konumları; yeni aktör oluşturulmaz.
static func nobetciler(h: KoyHalkHareketi) -> Array[Vector3]:
 var sonuc: Array[Vector3] = []
 for id in h.modeller:
  if MuhafizMaasi.aday(h.sahne.yonetim.koylu(id), h.sahne.yonetim): sonuc.append(h.modeller[id].position)
 return sonuc
## Devriye yaklaşınca, mevcut kaçış hedefi de riskliyse bütçeli rota kuyruğuna al.
static func tehdit(h: KoyHalkHareketi, id: int) -> bool:
 var d: Dictionary = h._durum[id]
 var p: Vector3 = h.modeller[id].position
 for n in nobetciler(h):
  if p.distance_to(n) >= float(AYAR.muhafiz_mesafesi): continue
  if int(d.adim) < d.yol.size() and d.yol[-1].distance_to(n) > float(AYAR.muhafiz_mesafesi): continue
  return true
 return false
## Ateşten uzakta, yol/meydan dışında erişilebilir kuytu; nöbetçi mesafesi öncelikli.
static func hedef(h: KoyHalkHareketi, k: Koylu, bas: Vector2i) -> Dictionary:
 var s := h.sahne
 var ates := AtesBasiRutini.konum(s)
 var nobet := nobetciler(h)
 var yerler: Array[Dictionary] = []
 var dolu: Array[Vector3] = []
 for id in h.modeller:
  if id == k.id or not h._durum[id].get("sinsi", false): continue
  var d: Dictionary = h._durum[id]
  dolu.append(d.yol[-1] if not d.yol.is_empty() else h.modeller[id].position)
 var boy := s.yonetim.a.izgara_boyut
 for cy in range(1, boy.y - 1):
  for cx in range(1, boy.x - 1):
   var hucre := Vector2i(cx, cy)
   if not h.rotaci.gecilir(hucre) or s.yonetim.izgara.meydanda(hucre) or s.yonetim.izgara.yollar.has(hucre): continue
   var p := h._konum(hucre)
   if p.distance_to(ates) < float(AYAR.ates_mesafesi): continue
   if dolu.any(func(v: Vector3) -> bool: return p.distance_to(v) < s.HUCRE): continue
   var guven := 1.0e9
   for n in nobet: guven = minf(guven, p.distance_to(n))
   if guven < float(AYAR.muhafiz_mesafesi): continue
   if not nobet.is_empty() and p.distance_to(h.modeller[k.id].position) < float(AYAR.yer_degistirme): continue
   # Kimliğe göre kararlı dağılım; RNG ve atamalar değiştirilmez.
   var sira := posmod(cx + cy * boy.x + k.id * int(AYAR.sacilim), boy.x * boy.y)
   yerler.append({"h": hucre, "guven": guven, "sira": sira})
 yerler.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
  return a.sira < b.sira if is_equal_approx(a.guven, b.guven) else a.guven > b.guven)
 for yer in yerler:
  if not h.rotaci.yol(bas, yer.h).is_empty(): return {"son": yer.h, "bak": ates}
 return {}

## Tek satırlık plan adaptörü; tüm gece öncelikleri bu rutin içinde kalır.
static func planla(h: KoyHalkHareketi, k: Koylu, bas: Vector2i, son: Vector2i) -> Vector2i:
 var d: Dictionary = h._durum[k.id]
 d.sinsi = false
 d.sinsi_bekle = 0.0
 if d.get("siginma", false) or not aday(h.sahne.yonetim, k, h.faz_adi): return son
 var kuytu := hedef(h, k, bas)
 if kuytu.is_empty(): return son
 d.bak = kuytu.bak
 d.sinsi = true
 d.is = false
 d.ates_basi = false
 d.coban = false
 return kuytu.son
## Tek satırlık kare adaptörü; güvenli kaçışı kesmeden aynı kuyruğa yeniden planlar.
static func guncelle(h: KoyHalkHareketi, id: int, delta: float) -> bool:
 var d: Dictionary = h._durum[id]
 if not d.get("sinsi", false): return false
 d.sinsi_bekle = float(d.get("sinsi_bekle", 0.0)) + delta
 if d.sinsi_bekle < float(AYAR.yeniden_planlama) or not tehdit(h, id): return false
 d.sinsi_bekle = 0.0
 h._iste(id)
 return true
## Mevcut yürüyüş hızına yalnız görsel çarpan.
static func hiz(d: Dictionary) -> float:
 return float(AYAR.hiz) if d.get("sinsi", false) else 1.0
