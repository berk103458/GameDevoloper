## Mevcut husumet baskınının ortak sonucu; CAS08 ikinci hasar/zar sistemi kurmaz.
class_name HusumetBaskini
extends RefCounted
## Aynı stok kaybı, iki mevcut kişi yaralanma zarı ve sosyal sonuç.
static func uygula(y: KoyYonetimi,olaylar: Array[Dictionary]) -> void:
 var g:=y.kaynaklar.azalt("gida",y.kaynaklar.miktar("gida")*3/10)
 var o:=y.kaynaklar.azalt("odun",y.kaynaklar.miktar("odun")/5)
 for i in mini(2,y.koylular.size()):
  var k: Koylu=y.koylular[y._rng.randi_range(0,y.koylular.size()-1)]
  k.saglik=maxi(1,k.saglik-40)
 y._herkese_moral(-15)
 y.asayis_riski=mini(100,y.asayis_riski+20)
 olaylar.append({"anahtar":"koy.olay.baskin","deger":[g,o]})
