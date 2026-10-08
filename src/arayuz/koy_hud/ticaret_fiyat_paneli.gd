## TUC-09: mevcut pazar durumuna mevsim fiyat açıklaması.
class_name TicaretFiyatPaneli
extends RefCounted
## Tek kartta ortak hesap; yeni HUD veya fiyat simülasyonu yoktur.
static func ekle(e: KoyEkrani, ust: Control) -> void:
 var l := e._etiket(ust, "Odun/erzak fiyat çarpanı: ×%.2f · genel alışlar parti bedeline yuvarlanır." % TicaretFiyatlari.carpan(e._y, "gida"), Tema.KUCUK_PX)
 l.name = "ticaret_mevsim_fiyati"
