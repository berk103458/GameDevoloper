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
## Heybesinde en az bu kadar akçe söyleyen zengin sayılır: harç kararı sunulmaz, alınırsa iltimas sayılabilir.
@export var zengin_esigi: int = 6
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
@export var perde2_hedef_gece: int = 12
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
## Ambar takası (design/gdd/koy-gelisimi.md, F3): köy, bu kadar gecelik tüketimi ambarda yedek tutar; fazlasını
## yoldan geçen tüccara satar. `ambar_akce_orani` ürün = 1 akçe; gecede en çok `takas_taban` + pazar seviyesi ×
## `takas_pazar_artis` akçelik satılır.
@export var ambar_yedek_gece: int = 1
## Tezgâh bulamayan esnaftan bu kadarı bir akçe kazanır (seyyar satış).
@export var seyyar_bolen: int = 2
@export var ambar_akce_orani: int = 4
@export var takas_taban: int = 2
@export var takas_pazar_artis: int = 1
## Boş rüşvet kesesini yeniden doldurmanın bedeli.
@export var kese_fiyati: int = 8

@export_group("Yapılar")
## Seviye 1, 2, 3 bedelleri (akçe).
@export var pazar_bedel: PackedInt32Array = PackedInt32Array([5, 9, 14])
@export var kervansaray_bedel: PackedInt32Array = PackedInt32Array([7, 12, 18])
## Seviye başına gereken esnaf.
@export var pazar_esnaf: PackedInt32Array = PackedInt32Array([1, 3, 5])
@export var kervansaray_esnaf: PackedInt32Array = PackedInt32Array([2, 4, 6])
## Sur seviyesi bedelleri (birinci perdede de kurulur; savunmaya ikinci perdede sayılır).
@export var sur_bedel: PackedInt32Array = PackedInt32Array([6, 10, 15])
## Köy konağı seviye bedelleri ve gereken nüfus; her seviye Soylular +1, köyün görünüşü gelişir.
@export var konak_bedel: PackedInt32Array = PackedInt32Array([10, 18, 28])
@export var konak_nufus: PackedInt32Array = PackedInt32Array([5, 10, 16])

@export_group("Olaylar")
## Gece sonunda bir olay çıkma olasılığı (uygun olay varsa).
@export var olay_olasiligi: float = 0.75

@export_group("İş yerleri")
## Kabul edilen kapıda bir iş yerine yazılır (design/gdd/is-yerleri.md). Aynı sıra:
## id, işin sınıfı (köy nüfusunda sayıldığı yer), uygunsuz yazılınca düşen bar, gereken yapı ("" = yok).
@export var is_idleri: PackedStringArray
@export var is_siniflari: PackedStringArray
@export var is_barlari: PackedInt32Array
@export var is_yapilari: PackedStringArray
## Uygunsuz yazımın bedeli (işin barından düşen).
@export var uyumsuz_ceza: int = 1

@export_group("Tarla ve ürünler")
## Her bu kadar çiftçi bir tarla (parsel) açar; en çok `tarla_azami`.
@export var ciftci_tarla_basina: int = 2
@export var tarla_azami: int = 6
## Ürün tablosu (aynı sıra): id, büyüme süresi (gece), hasat verimi (ambar), tohum bedeli (ambar).
@export var bitki_idleri: PackedStringArray
@export var bitki_sureleri: PackedInt32Array
@export var bitki_verimleri: PackedInt32Array
@export var bitki_tohumlari: PackedInt32Array
## Erken donda ölen ekin yaşı (≤ bu gece).
@export var don_esigi: int = 1


## Ürün id → büyüme süresi.
func bitki_sure_sozlugu() -> Dictionary:
	var d := {}
	for i in bitki_idleri.size():
		d[bitki_idleri[i]] = bitki_sureleri[i]
	return d


## Ürün id → hasat verimi.
func bitki_verim_sozlugu() -> Dictionary:
	var d := {}
	for i in bitki_idleri.size():
		d[bitki_idleri[i]] = bitki_verimleri[i]
	return d

@export_group("Sıra olayları")
## İki gelen arasında kuyrukta bir olay çıkma olasılığı.
@export var sira_olay_olasiligi: float = 0.35

@export_group("Mini oyunlar")
## Okçuluk: ok sayısı (her ok en çok 2 puan), nişangâhın salınım hızı (salınım/s) ve her okta artışı,
## merkez ve halka yarıçapı (hedef yarıçapına oranla). design/gdd/koy-mini-oyunlari.md
@export var okculuk_ok: int = 3
@export var okculuk_hiz: float = 0.45
@export var okculuk_hiz_artis: float = 0.12
@export var okculuk_merkez: float = 0.15
@export var okculuk_halka: float = 0.42
## Harman: vuruş sayısı (her isabet 1 puan), vuruş aralığı (s) ve isabet toleransı (s).
@export var harman_vurus: int = 8
@export var harman_aralik: float = 0.8
@export var harman_tolerans: float = 0.17

@export_group("Söz kaydı")
## KAY-58: kapalıyken göç Söz alanlarını yazmaz. Kayıt sürümü ayrı kalır.
@export var soz_alanlari_acik: bool = true

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
