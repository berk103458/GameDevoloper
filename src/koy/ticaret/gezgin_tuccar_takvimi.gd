## TUC-01: mevcut kaydedilen gün ve kervan aralığından türeyen tek ziyaret takvimi.
class_name GezginTuccarTakvimi
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/gezgin_tuccar_takvimi.json"))

## Gün sıfır tabanlıdır; gelis/ayrilis/sonraki_gun oyuncunun bir tabanlı günüdür.
static func durum(gun: int, aralik: int) -> Dictionary:
 var periyot := maxi(1, aralik)
 var bugun := maxi(0, gun) + 1
 var kalma := clampi(int(AYAR.konaklama), 1, periyot)
 var ziyaret := (bugun - periyot) / periyot if bugun >= periyot else -1
 var gelis := periyot * (ziyaret + 1)
 var aktif := ziyaret >= 0 and bugun < gelis + kalma
 var sonraki := ziyaret + 1
 var uzmanlar: Array = AYAR.uzmanlar
 return {"aktif": aktif, "tuccar": uzmanlar[posmod(ziyaret, uzmanlar.size())].duplicate(true) if aktif else {},
  "gelis_gunu": gelis if ziyaret >= 0 else 0, "ayrilis_gunu": gelis + kalma if ziyaret >= 0 else 0,
  "kalan": gelis + kalma - bugun if aktif else 0, "sonraki_gun": periyot * (sonraki + 1),
  "sonraki_tuccar": uzmanlar[posmod(sonraki, uzmanlar.size())].duplicate(true)}
