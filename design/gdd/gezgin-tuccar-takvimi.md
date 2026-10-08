# Gezgin tüccar takvimi — TUC-01

## Overview
Mevcut kervan/pazar yolu dört günde bir varış ve iki gün konaklama kullanır. Ayrı takvim, kayıt durumu veya ikinci pazar kurulmaz.

## Player Fantasy
Oyuncu pazardan gelecek uzmanı ve varış gününü öğrenir; konaklama boyunca alışveriş planlar.

## Detailed Rules
Oyuncunun 4. ve 5. günlerinde Celep Hamdullah pazardadır; 6. günde ayrılır. 8. günde Nalbur, 12. günde Kumaşçı/Aktar, 16. günde Silah Tüccarı, 20. günde tekrar Celep gelir. Mevcut kervan_gunu, kervana_sat, kervandan_al ve çeki hayvanı alımı aynı ziyaret koşulunu kullanır. Uzmanlara özel stoklar TUC-02/03/04/08 kapsamındadır; bu adım mevcut genel alışverişi kaldırmaz.

## Formulas
Oyuncu günü = kaydedilen gun + 1. Varışlar kervan_araligi katlarındadır. Konaklama [varış, varış + konaklama) aralığıdır. Uzman indeksinin ziyaret sayısına göre modülü alınır. Konaklama süresi 1 ile varış aralığı arasında sınırlanır.

## Edge Cases
İlk üç gün tüccar yoktur. Eski kaydın gun değeri korunur; takvim yeni dört günlük kurala göre hesaplanır, migration alanı eklenmez. Tekrarlanan pazar açılışları gün, RNG ve kayıt değiştirmez. Dışarıya dönen uzman sözlükleri kaynak veriyi değiştiremez.

## Dependencies
GezginTuccarTakvimi saf hesap; KoyYonetimi mevcut gün ve kervan API'si; GezginTuccarPazarAdaptoru mevcut KoyEkrani pazar kartına tek satır bağlanır. Gece mevcut gün artırımıyla ilerler.

## Tuning Knobs
KoyAyarlari.kervan_araligi ve data/ayarlar/koy.tres dört gün; data/gezgin_tuccar_takvimi.json konaklama ve uzman sırası. Asset gerekmedi; yalnız mevcut pazar metni genişletildi.

## Acceptance Criteria
32 günlük sınırlar, uzman döngüsü, varış/ayrılışta mevcut alım/satım kapısı; gerçek pazar ad/süre satırı, kayıt dönüşü ve RNG korunumu. Köy yönetimi/çeki lojistiği regresyonu ve 20 gece koşusu geçer.
