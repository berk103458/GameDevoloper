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
## Gerçek kalan başlangıç sürüsü ve satın alınmış koç aynı üç dizide uzlaştırılır.
static func yenile(s: CobanSurusu) -> void:
 var y := s.halk.sahne.yonetim
 var taban := SamanBakimi.taban(y.bina(s.bina_id))
 var ek := CelepHamdullah.barindir(y, s.bina_id).count("koc")
 for satin in [false, true]:
  var hedef: int = ek if satin else taban
  var mevcut := 0
  for n in s.koyunlar:
   if n.has_meta("satinalinan_koc") == satin: mevcut += 1
  for i in range(s.koyunlar.size() - 1, -1, -1):
   if mevcut <= hedef: break
   if s.koyunlar[i].has_meta("satinalinan_koc") != satin: continue
   var n: Node3D = s.koyunlar[i]
   s.koyunlar.remove_at(i)
   s.adimlar.remove_at(i)
   s.yollar.remove_at(i)
   n.queue_free()
   mevcut -= 1
  while mevcut < hedef:
   var n := _koc() if satin else CobanSurusu.koyun("keci" if (mevcut % 4 == 3 and Dunya3B.model_var_mi("td_a163")) else "koyun")
   s.add_child(n)
   var b := y.bina(s.bina_id)
   n.global_position = s.koyunlar[0].global_position if not s.koyunlar.is_empty() else s.halk.sahne.alan_merkezi(b.hucre, b.boyut(y.katalog))
   s.adimlar.append(s.adimlar[0] if not s.adimlar.is_empty() else 0)
   s.yollar.append(s.yollar[0].duplicate() if not s.yollar.is_empty() else [])
   s.koyunlar.append(n)
   mevcut += 1
static func _koc() -> Node3D:
 if Dunya3B.model_var_mi("koc", "hayvan"):
  var n := Dunya3B.nesne("koc", 0.79, "hayvan")
  n.name = "satinalinan_koc"
  n.set_meta("satinalinan_koc", true)
  var bas := Node3D.new()
  bas.name = "bas"
  n.add_child(bas)
  return n
 var n := Node3D.new()
 n.name = "satinalinan_koc"
 n.set_meta("satinalinan_koc", true)
 var kutu := CelepHayvanGorseli._yer_tutucu("koc")
 kutu.position.y = float(CelepHamdullah.AYAR.gorsel.boyut[1]) / 2.0
 n.add_child(kutu)
 var bas := Node3D.new()
 bas.name = "bas"
 n.add_child(bas)
 return n
