# Gezgin silah tüccarı ve karaborsa — TUC-08

## Overview
Silah Tüccarı mevcut dört uzman takviminde zırh/yay/kalkan satar; aynı pazarda isteğe bağlı kaçak tutsak teklifi bulunur. Tek ambar, ziyaret geçmişi ve mevcut köylü kabul/barınma modeli kullanılır.

## Player Fantasy
Oyuncu savunma malzemesi tedarik eder ve karaborsa teklifinin açık toplumsal bedelini değerlendirir.

## Detailed Rules
Silah tüccarı 16–17. gün ve her 16 günde bir gelir; ziyaret başına zırh 4, yay 6, kalkan 6 stok. Ürünler mevcut ortak ambara yazılır; ayrı donanım deposu veya otomatik tüketim yoktur. ANI-01 mevcut görev donanımı/görselleri korunur; satın alınan stok o sistemi ikinci kez kurmaz. Kaçak teklif aynı iki günde yalnız bir kişi sunar. 30 kamu akçesi ve tamamlanmış barınakta boş yatak gerekir. İşlem tek normal çiftçi köylüyü eski_tutsak bayrağıyla mevcut kabul ve barındırma yoluna ekler; kişi ambar malzemesi değildir. Başarı Adalet -5 ve Asayiş riski +5 verir; reddetmek hiçbir şey değiştirmez. Silah tüccarı borç ambargosu bütün teklif ve ürün alımlarını kapatır.

## Formulas
Ürün bedelleri: zırh 24, yay 12, kalkan 10 akçe/adet. Ürün kabulü mevcut stok ≥ adet AND boş ambar ≥ adet AND kamu akçesi ≥ bedel. Kişi kabulü Silah ziyareti AND ambargo yok AND kamu akçesi ≥ 30 AND yatak kapasitesi > nüfus AND aynı ziyaret kişi makbuzu < 1. Adalet = max(0, Adalet - 5); risk = min(100, risk + 5).

## Edge Cases
İkinci konaklama günü ve kayıt yüklemesi ürün/kişi stoğunu yenilemez. Sonraki uzman varışı başarılı işlemde mevcut ziyaret makbuzunu yeniler. Aynı ziyarette önce ürün sonra kişi veya tersi satın alma diğer makbuzları korur. Dolu ambar ürünü, yataksız köy kişiyi alamaz; başarısız işlem kasa/nüfus/geçmiş/RNG değiştirmez. Kişi ölse/ayrılsa bile makbuz aynı ziyarette yeni kişiyi açmaz. Bilinmeyen/bozuk makbuz reddedilir, aşırı büyük değer ziyaret stoğuna sınırlanır. Kapasite küçülmesinde yeni ürünler mevcut taşma sırasına dahildir.

## Dependencies
SilahKaraborsasi yeni saf işlem helperı, GezginTuccarStogu mevcut ziyaret makbuzu loaderında tek çağrı. SilahKaraborsaPaneli mevcut GezginStokPaneli satırına tek çağrı; tek pazar/HUD kullanılır. Kaynaklar/Hud/AmbarBakimi üç ürün türünü genişletir. KoyYonetimi kabul, yatak_kapasitesi ve _barindir mevcut API'leri; çekirdek nüfus/kasa sistemi yeniden yazılmaz.

## Tuning Knobs
data/gezgin_tuccar_stogu.json silah stoğu ve fiyatı; data/silah_karaborsasi.json kişi fiyat/stoğu, sınıf/özellikler ve toplumsal bedel. Gerçek üç ürün ikonu envanter G TUC08 satırlarında; tek GezginStokIkonu ColorRect yer tutucusu. Kişi mevcut genel köylü görselini kullanır; asset üretimi/indirme yoktur.

## Acceptance Criteria
Üç stok alımı gerçek pazar/HUD'da gösterilir; kamu kasası ve tek ambar doğrulanır. Yatak/para/ambargo engelleri, tek teklif, normal köylü/hane oluşumu, toplumsal bedel, stok/RNG korunması, ikinci gün/sonraki ziyaret ve kayıt roundtrip testleri geçer. Yeni ürün taşma bakımı, önceki tüccar/sipariş/borç/snapshot/iflas/20 gece regresyonları geçer. Native pazar ve ds ayna import/UI doğrulanır; G envanteri aynı pakettedir.
