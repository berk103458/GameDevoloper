class_name YazYanginRiski
extends RefCounted
## Meydan meşalesine yakın kuru ottaki çatılar; yeni yangın simülasyonu yok.
static func adaylar(y: KoyYonetimi) -> Array[KoyBinasi]:
 var r: Array[KoyBinasi] = []
 if IklimDeneyi.hava(y) in ["yagmur", "kar_firtinasi"]: return r
 if y.nufus()==0 or (y.mevsim()!=1 and IklimDeneyi.hava(y)!="kuraklik"): return r
 var mesale := Vector2(y.a.meydan.position)+Vector2(y.a.meydan.size)/2.0 + Vector2(AtesBasiRutini.AYAR.ates_ofset[0],AtesBasiRutini.AYAR.ates_ofset[1])/KoyYonetimSahnesi.HUCRE
 for b in y.binalar:
  if b.hazir() and b.tur in SuDengesi.AYAR.yanabilir and (Vector2(b.hucre)+Vector2(b.boyut(y.katalog))/2.0).distance_to(mesale)<=float(SuDengesi.AYAR.mesale_mesafe): r.append(b)
 r.sort_custom(func(a:KoyBinasi,b:KoyBinasi)->bool:return a.id<b.id)
 return r
## Gecede tek kıvılcım riski; rezerv varsa aynı ambardan söndürme, yoksa mevcut iadesiz bina kaybı.
static func gece(y: KoyYonetimi, olaylar: Array[Dictionary]) -> int:
 var aday := adaylar(y)
 if aday.is_empty(): return 0
 var makbuz := SuDengesi.durum(y)
 if int(makbuz.yangin_gun)==y.gun: return 0
 makbuz.yangin_gun=y.gun
 y.set_meta(SuDengesi.META,makbuz)
 if y._rng.randi_range(1,100)>int(SuDengesi.AYAR.kivilcim_yuzde): return 0
 var b := aday[0]
 var su := int(SuDengesi.AYAR.sondurme_su)
 if y.kaynaklar.miktar("su")>=su:
  y.kaynaklar.azalt("su",su)
  olaylar.append({"anahtar":"Meşale kıvılcımı kuru otu tutuşturdu; %d su rezerviyle yangın söndürüldü.","deger":[su]})
  return su
 elif y.bina_el_koy(b.id):
  olaylar.append({"anahtar":"Meşaleden kuru ota yangın sıçradı; su rezervi yoktu, %s (#%d) kaybedildi.","deger":[MeslekYapilari.ad(b.tur),b.id]})
 return 0
