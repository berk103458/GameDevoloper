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

@export_group("Ekonomi")
@export var akce_baslangic: int = 4
## Rüşvet alınınca kesene giren akçe.
@export var rusvet_akce: int = 3
@export var ambar_baslangic: int = 6
## Çiftçi başına gecelik ürün.
@export var ciftci_uretim: int = 2
## Gecelik tüketim = ceil(nüfus / bu sayı).
@export var tuketim_bolen: int = 2
## Esnaf başına gecelik akçe; pazar her seviyede +1 akçe/esnaf.
@export var esnaf_gelir: int = 1
## Pazarsız alışveriş edebilen esnaf sayısı; pazar her seviyede bu kadar ekler.
@export var pazar_tezgah_taban: int = 2
@export var pazar_tezgah_artis: int = 2
## Kervansaray seviyesi başına gecelik akçe.
@export var kervansaray_gelir: int = 2
## Boş rüşvet kesesini yeniden doldurmanın bedeli.
@export var kese_fiyati: int = 8

@export_group("Yapılar")
## Seviye 1, 2, 3 bedelleri (akçe).
@export var pazar_bedel: PackedInt32Array = PackedInt32Array([5, 9, 14])
@export var kervansaray_bedel: PackedInt32Array = PackedInt32Array([7, 12, 18])
## Seviye başına gereken esnaf.
@export var pazar_esnaf: PackedInt32Array = PackedInt32Array([1, 3, 5])
@export var kervansaray_esnaf: PackedInt32Array = PackedInt32Array([2, 4, 6])
## Sur seviyesi bedelleri (yalnız ikinci perde).
@export var sur_bedel: PackedInt32Array = PackedInt32Array([6, 10, 15])

@export_group("Olaylar")
## Gece sonunda bir olay çıkma olasılığı (uygun olay varsa).
@export var olay_olasiligi: float = 0.75

@export_group("Heybe")
## Gelenin söylediği akçe aralığı.
@export var beyan_akce_min: int = 2
@export var beyan_akce_max: int = 8
## Gelenin yalan söyleyip astara bir şey saklama olasılığı.
@export var yalan_olasiligi: float = 0.35
## Astarda saklı akçe aralığı.
@export var gizli_akce_min: int = 8
@export var gizli_akce_max: int = 20
## Yalancının astarına ayrıca değerli bir eşya saklama olasılığı.
@export var gizli_esya_olasiligi: float = 0.4
## Rüşvet teklifi = ceil(beyan akçe × oran), en az 1.
@export var teklif_orani: float = 0.5
## Teklifinden fazlasını almanın (gasp) Halk bedeli.
@export var gasp_halk_cezasi: int = 1
## Dürüst birinin astarını yoklamanın Halk bedeli.
@export var durust_arama_cezasi: int = 1
## Eşya tablosu (aynı sıra): id, tür (akce|gida|mal), birim değer (akçe), kimler taşır ("*" = herkes),
## yalnız astarda mı çıkar (1 = değerli, saklanan).
@export var esya_idleri: PackedStringArray
@export var esya_turleri: PackedStringArray
@export var esya_degerleri: PackedInt32Array
@export var esya_siniflari: PackedStringArray
@export var esya_gizli: PackedInt32Array
