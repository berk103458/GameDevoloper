## HAR-01: şematik çevre noktaları ve mevcut köy durumunun saf görünümü.
class_name CevreHaritasi
extends RefCounted
static var AYAR: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/cevre_haritasi.json"))
## Harita yerleşimi dışarıya kopya verilir; konumlar gerçek coğrafi mesafe değildir.
static func bolgeler() -> Array:
 return AYAR.bolgeler.duplicate(true)
## Yalnız mevcut sayaçlar okunur; diplomasi/tehdit olayı veya kuyruk oluşturulmaz.
static func bilgi(o: Oturum,id: String) -> Dictionary:
 if o==null: return {}
 for b in AYAR.bolgeler:
  if String(b.id)!=id: continue
  var s:=String(b.metin)
  if id=="hisar": s+="\n\nGün: %d · Nüfus: %d"%[o.gun,o.yonetim.nufus()]
  elif id=="tekfur": s+="\n\nTekfur baskısı: %d\nSavuşturulan baskın: %d"%[o.yonetim.tekfur_baski,o.yonetim.savusturulan]
  return {"ad":String(b.ad),"metin":s}
 return {}
