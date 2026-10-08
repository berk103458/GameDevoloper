## TUC-14: satın alınan koç aynı çoban sürüsü ve yol dizilerini paylaşır.
class_name CanliHayvanSurusu
extends RefCounted
## Mevcut dört sürülük görsel bütçe dışında koç barınak kutusu kalır.
static func surude(y: KoyYonetimi, bina_id: int, tur: String) -> bool:
 if tur != "koc": return false
 var n := 0
 for b in y.binalar:
  if not CobanSurusu.hazir(b): continue
  if n >= int(CobanSurusu.AYAR.suruler_azami): return false
  if b.id == bina_id: return true
  n += 1
 return false
## Tek sürüde baz dört koyun korunur; yalnız satın alınmış ek kutular uzatılır.
static func yenile(s: CobanSurusu) -> void:
 var taban := int(CobanSurusu.AYAR.koyun_sayisi)
 var hedef := taban + CelepHamdullah.barindir(s.halk.sahne.yonetim, s.bina_id).count("koc")
 while s.koyunlar.size() > hedef:
  var son: Node3D = s.koyunlar.pop_back()
  s.adimlar.pop_back()
  s.yollar.pop_back()
  son.queue_free()
 while s.koyunlar.size() < hedef:
  var n := Node3D.new()
  n.name = "satinalinan_koc_%d" % s.koyunlar.size()
  var kutu := CelepHayvanGorseli._yer_tutucu("koc")
  kutu.position.y = float(CelepHamdullah.AYAR.gorsel.boyut[1]) / 2.0
  n.add_child(kutu)
  var bas := Node3D.new()
  bas.name = "bas"
  n.add_child(bas)
  s.add_child(n)
  n.global_position = s.koyunlar[0].global_position
  s.koyunlar.append(n)
  s.adimlar.append(s.adimlar[0])
  s.yollar.append(s.yollar[0].duplicate())
