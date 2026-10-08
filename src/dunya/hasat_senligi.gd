class_name HasatSenligi
extends RefCounted
const META := &"hasat_senligi_yili"
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/hasat_senligi.json"))
## Optional yıl alanı; eski/bozuk değer kutlama hakkını tüketmez.
static func oku(v: Variant) -> int:
 return int(v) if (v is int or v is float) and is_finite(float(v)) and float(v)==floor(float(v)) and float(v)>=0 and float(v)<=1000000000 else 0
## Yıl takvimden, kutlama kaydı mevcut yönetim metadata'sından gelir.
static func son_yil(y:KoyYonetimi)->int:
 return oku(y.get_meta(META,0))
## Sonbahar, dolu ambar ve bu gecenin gerçek erzak ihtiyacı; salt okunur.
static func hazir(y:KoyYonetimi)->bool:
 return y.son=="" and y.nufus()>0 and y.mevsim()==int(AYAR.mevsim) and int(MevsimYoneticisi.durum(y).yil)>son_yil(y) and y.kaynaklar.kapasite>0 and y.kaynaklar.toplam()>=y.kaynaklar.kapasite and y.kaynaklar.miktar("gida")>=int(TuketimDengesi.gerek(y).gida)
## Tüketim öncesi adaylığın ardından mevcut sağlık/moral sonuçlarına tek yıllık dopingle bağlanır.
static func uygula(y:KoyYonetimi, aday:bool, olaylar:Array[Dictionary])->void:
 var yil:=int(MevsimYoneticisi.durum(y).yil)
 if not aday or y.nufus()==0 or y.son!="" or y.mevsim()!=int(AYAR.mevsim) or yil<=son_yil(y):return
 for k in y.koylular:k.moral=clampi(int(AYAR.moral),0,100)
 y.set_meta(META,yil)
 olaylar.append({"anahtar":"Ambar dolu: hasat şenliği! Köylü morali %d; yılda bir kutlama.","deger":[int(AYAR.moral)]})
