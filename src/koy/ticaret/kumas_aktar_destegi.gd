## TUC-04: mevcut şifahane ve kişi Refah statına ortak ambar malzemesi desteği.
class_name KumasAktarDestegi
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/kumas_aktar_destegi.json"))
## Başarılı mevcut tedaviyi destekler; eksik çift malzeme veya tam sağlıkta harcama yok.
static func tedavi(y: KoyYonetimi, k: Koylu, olaylar: Array[Dictionary]) -> bool:
 if k.saglik <= 0 or k.saglik >= 100 or not y.kaynaklar.harca(AYAR.tedavi.maliyet): return false
 k.saglik = mini(100, k.saglik + int(AYAR.tedavi.saglik))
 olaylar.append({"anahtar": "Şifahane köylü %s için afyon ve sargı kullandı; ek sağlık %+d.", "deger": [k.ad, int(AYAR.tedavi.saglik)]})
 return true
## Dağıtımdan yararlanabilecek yaşayan, Refah sınırına ulaşmamış kişilerin sayısı.
static func kisi(y: KoyYonetimi, tur: String) -> int:
 if not AYAR.luks.has(tur): return 0
 var n := 0
 for k in y.koylular:
  if k.saglik > 0 and k.refah < int(EkonomikRefah.AYAR.ust): n += 1
 return mini(n, y.kaynaklar.miktar(tur))
## Kullanıcının dağıtım eylemi; düşük Refah önce, kişi başına bir mevcut stok.
static func dagit(y: KoyYonetimi, tur: String) -> int:
 var adet := kisi(y, tur)
 if adet <= 0: return 0
 var kisiler := y.koylular.duplicate()
 kisiler.sort_custom(func(a: Koylu, b: Koylu) -> bool: return a.refah < b.refah if a.refah != b.refah else a.id < b.id)
 var n := 0
 for k in kisiler:
  if n >= adet: break
  if k.saglik <= 0 or k.refah >= int(EkonomikRefah.AYAR.ust): continue
  k.refah = mini(int(EkonomikRefah.AYAR.ust), k.refah + int(AYAR.luks[tur].refah))
  n += 1
 y.kaynaklar.azalt(tur, n)
 return n
