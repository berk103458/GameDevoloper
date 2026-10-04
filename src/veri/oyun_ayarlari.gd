## Oynanış ayar değerleri; tümü veridir (`data/ayarlar/oyun.tres`).
class_name OyunAyarlari
extends Resource

@export_group("Barlar")
## Bar adlarının çeviri anahtarları; sıra tüm etki dizilerinin sırasıdır.
@export var bar_anahtarlari: PackedStringArray
@export var bar_baslangic: int = 6
@export var bar_azami: int = 10
## Rüşvet hakkı harcanınca kırılan barın döndüğü değer.
@export var rusvet_kurtarma: int = 3
@export var rusvet_hakki: int = 3

@export_group("Kapı")
@export var gece_basina_gelen: int = 3
## Bir yuvaya adlı karakter gelme olasılığı (uygun varsa).
@export var adli_olasiligi: float = 0.6
@export var azami_soru: int = 2
## İki seçeneğin belirişi arası (ms), %100 hızda.
@export var belirme_ms: float = 300.0

@export_group("Köy baskısı")
## Çiftçi × bu sayı < nüfus ise Halk düşer.
@export var gida_carpani: int = 3
## Bu geceden sonra asker × 2 < gece ise Ordu düşer.
@export var ordu_baski_gecesi: int = 3
## Her bu kadar gecede bir Soylular düşer (vergi).
@export var vergi_araligi: int = 4
## Bu geceden sonra esnaf yoksa Tüccarlar düşer.
@export var tuccar_baski_gecesi: int = 2

@export_group("Perdeler")
## Gece sonunda nüfus bu sayıya ulaşırsa köy oturur (ağalık).
@export var oturma_esigi: int = 12
@export var perde2_gece_basina_gelen: int = 2
## İkinci perdede bu kadar gece dayanılırsa son tetiklenir.
@export var perde2_hedef_gece: int = 10
## Saldırı gücü = taban + perde2 gecesi / artış_aralığı.
@export var saldiri_taban: int = 1
@export var saldiri_artis_araligi: int = 2
## Savunma = asker / bu sayı (aşağı yuvarlanır).
@export var savunma_bolen: int = 2
