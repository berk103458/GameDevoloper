## TUC-06: tek sipariş için atomik stok/ödeme/itibar ve sonraki ziyaret stoğu.
class_name SiparisTeslimati
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/siparis_teslimati.json"))
## Tam miktar ve zamanında bekleyen taahhüt; tüccarın yeniden gelmesi gerekmez.
static func teslim_edilebilir(y: KoyYonetimi, id: String) -> bool:
 var s: Dictionary = y.siparisler.sozlesmeler.get(id, {})
 return not s.is_empty() and s.durum == "bekliyor" and y.gun + 1 <= int(s.vade) and y.kaynaklar.miktar(s.urun) >= int(s.adet)
## Aynı taahhüt ikinci kez para/itibar veremez; kasa ve stok tek modelden güncellenir.
static func teslim(y: KoyYonetimi, id: String) -> bool:
 if not teslim_edilebilir(y, id): return false
 var s: Dictionary = y.siparisler.sozlesmeler[id]
 y.kaynaklar.azalt(s.urun, int(s.adet))
 y.akce += int(s.odul)
 s.durum = "teslim"
 s.teslim_gunu = y.gun + 1
 var i: Dictionary = y.tuccar_itibari.get(s.tuccar, {"puan": 0, "acilis": -1}).duplicate()
 i.puan = mini(int(AYAR.itibar_ust), int(i.puan) + int(AYAR.itibar_artisi))
 if int(i.acilis) < 0 and int(i.puan) >= int(AYAR.itibar_esigi): i.acilis = y.gun + 1
 y.tuccar_itibari[s.tuccar] = i
 return true
## Eşik ilk başarıda açılır, aynı ziyarette ürün eklenmez; sonraki ziyaret kalıcıdır.
static func nadir(y: KoyYonetimi, ziyaret: Dictionary) -> Dictionary:
 if not ziyaret.aktif: return {}
 var i: Dictionary = y.tuccar_itibari.get(ziyaret.tuccar.id, {})
 if int(i.get("puan", 0)) < int(AYAR.itibar_esigi) or int(i.get("acilis", -1)) < 0 or int(ziyaret.gelis_gunu) <= int(i.acilis): return {}
 return AYAR.nadir.get(ziyaret.tuccar.id, {}).duplicate(true)
## Optional eski itibar alanını sınırlı ve bağımsız sözlük olarak doğrular.
static func oku(v: Variant) -> Dictionary:
 var r := {}
 if not v is Dictionary: return r
 for id in AYAR.nadir:
  var i: Variant = v.get(id)
  if not i is Dictionary: continue
  var p: Variant = i.get("puan")
  var a: Variant = i.get("acilis")
  if not (p is int or p is float) or not (a is int or a is float): continue
  if not is_finite(float(p)) or not is_finite(float(a)) or floor(float(p)) != float(p) or floor(float(a)) != float(a) or float(a) < -1 or float(a) > 1000000: continue
  r[id] = {"puan": int(clampf(float(p), 0, float(AYAR.itibar_ust))), "acilis": int(a)}
 return r
## Teslim tarihi kayıt dönüşünde korunur; eski bekleyen kayıt şekli değişmez.
static func kayit_alanlari(v: Dictionary, hedef: Dictionary) -> void:
 SiparisKomisyonu.kayit(v, hedef)
 var n: Variant = v.get("teslim_gunu")
 if hedef.durum == "teslim" and (n is int or n is float) and is_finite(float(n)) and floor(float(n)) == float(n) and float(n) >= int(hedef.kabul_gunu) and float(n) <= int(hedef.vade): hedef.teslim_gunu = int(n)
