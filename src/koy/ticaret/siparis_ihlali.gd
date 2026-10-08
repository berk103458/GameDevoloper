## TUC-07: tek gecelik ihlal geçişi, kalıcı tüccar borcu ve tekrar güvenli faiz.
class_name SiparisIhlali
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/siparis_ihlali.json"))
## Tüccar asgari süre veya ödenmemiş borç boyunca ticareti reddeder.
static func terk(y: KoyYonetimi, id: String) -> bool:
 var c: Dictionary = y.tuccar_cezasi.get(id, {})
 return not c.is_empty() and (int(c.borc) > 0 or y.gun + 1 < int(c.donus))
## Yeni oyun gününde vadeyi denetler; aynı taahhüt ikinci Refah kaybı yaratmaz.
static func gece(y: KoyYonetimi, olaylar: Array[Dictionary]) -> void:
 var bugun := y.gun + 1
 for c in y.tuccar_cezasi.values():
  var gun := int(c.son_faiz)
  while gun < bugun and int(c.borc) > 0 and int(c.borc) < int(AYAR.borc_ust):
   c.borc = mini(int(AYAR.borc_ust), int(c.borc) + ceili(int(c.borc) * float(AYAR.gecelik_faiz)))
   gun += 1
  c.son_faiz = maxi(int(c.son_faiz), bugun)
 for s in y.siparisler.sozlesmeler.values():
  if s.durum != "bekliyor" or bugun <= int(s.vade): continue
  s.durum = "ihlal"
  var c: Dictionary = y.tuccar_cezasi.get(s.tuccar, {"borc": 0, "donus": 0, "son_faiz": bugun}).duplicate()
  c.borc = mini(int(AYAR.borc_ust), int(c.borc) + ceili(int(s.odul) * float(AYAR.ceza_orani)))
  c.donus = maxi(int(c.donus), bugun + int(AYAR.terk_gun))
  y.tuccar_cezasi[s.tuccar] = c
  EkonomikRefah.degistir(y, -int(AYAR.refah_kaybi))
  var i: Dictionary = y.tuccar_itibari.get(s.tuccar, {"puan": 0, "acilis": -1}).duplicate()
  i.puan = maxi(0, int(i.puan) - int(AYAR.itibar_kaybi))
  y.tuccar_itibari[s.tuccar] = i
  olaylar.append({"anahtar": "%s siparişi ihlal edildi; tüccar ayrıldı, ceza borcu %d akçe ve Refah -%d.", "deger": [s.ad, c.borc, int(AYAR.refah_kaybi)]})
## Kamu kasasından eldeki tutar kadar borç öder; stok/RNG değişmez.
static func ode(y: KoyYonetimi, id: String) -> int:
 if not y.tuccar_cezasi.has(id): return 0
 var c: Dictionary = y.tuccar_cezasi[id]
 var adet := mini(maxi(0, y.akce), int(c.borc))
 y.akce -= adet
 c.borc = int(c.borc) - adet
 return adet
## Eski kayıt boş ceza defteri; bozuk sayılar sınırlı güvenli değerlerdir.
static func oku(v: Variant) -> Dictionary:
 var r := {}
 if not v is Dictionary: return r
 for id in SiparisSozlesmeleri.AYAR.teklifler:
  var c: Variant = v.get(id)
  if not c is Dictionary: continue
  var olur := true
  for alan in ["borc", "donus", "son_faiz"]:
   var n: Variant = c.get(alan)
   if not (n is int or n is float) or not is_finite(float(n)) or float(n) < 0 or floor(float(n)) != float(n) or float(n) > 1000000: olur = false
  if olur: r[id] = {"borc": int(c.borc), "donus": int(c.donus), "son_faiz": int(c.son_faiz)}
 return r
