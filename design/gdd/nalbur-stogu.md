# Nalbur ve maden stoğu — TUC-03

## Overview
Nalbur uzmanının her ziyaretinde sınırlı demir, çivi, tırpan ve balta alınır. Bütün ürünler mevcut ortak ambar ve kamu kasasını kullanır; ayrı envanter/HUD oluşturulmaz.

## Player Fantasy
Oyuncu Nalbur konaklarken kıt alet ve metal stoğunu satın alıp depolar.

## Detailed Rules
Nalbur 8–9, 24–25… oyuncu günlerinde gelir. Ziyaret stoğu: 20 demir (2 akçe), 30 çivi (2), 6 tırpan (6), 6 balta (5). Panel bir adet alır; mevcut demir alım API'si aynı sınırlı stoktan daha büyük sipariş verebilir. Çivi/tırpan/balta ayrı ambar türleridir; mevcut genel alet tüketimini otomatik değiştirmezler. Üretim, donanım ve kullanım etkileri ilgili sonraki mekanik paketleriyle bağlanır. Eski diğer kervan genel malları korunur.

## Formulas
Kalan = taban stok − aynı varış gününe ait satın alınan miktar. Yeni Nalbur ziyaretinde taban stok gösterilir; panel okuması kayıt değiştirmez. Başarı = adet > 0 AND doğru uzman AND kalan ≥ adet AND boş ambar ≥ adet AND kasa ≥ adet × fiyat. Tam sipariş kabul edilir; kısmi ödeme yoktur.

## Edge Cases
İkinci konaklama günü stok yenilenmez. Ayrılışta düğmeler kaldırılır. Eski kayıtta gezgin_ticaret alanı yoksa geçmiş boştur; yeni kaynaklar sıfırdır. Bozuk negatif/kesirli/sonsuz kayıt değerleri alınmaz; yüksek satın alınan değer taban stokla sınırlanır. Ambar küçülünce üç yeni tür de taşma sırasına dahildir. RNG tüketilmez.

## Dependencies
GezginTuccarStogu saf stok/işlem helperı; KoyYonetimi optional alan ve kaydet/kayittan ince adaptörü. Mevcut kervandan_al demiri aktif uzman stoğuna delege eder. GezginStokPaneli mevcut pazar kartına tek çağrı; Hud/Kaynaklar mevcut tür listeleri genişletilir. DemirZinciri kaynak adı adaptörü yeni etiketlere bağlanır.

## Tuning Knobs
data/gezgin_tuccar_stogu.json uzman→ürün adı/fiyat/stok. data/koy/ambar_bakimi.json mevcut taşma sırası. Yeni ikonlar GezginStokIkonu.ikon tek merkezde düz ColorRect yer tutucudur; envanter G TUC03-CIVI/TIRPAN/BALTA. Asset üretilmedi/indirilmedi; CSV değiştirilmedi.

## Acceptance Criteria
Dört gerçek UI alımı, ortak kasa/ambar/HUD ve kutu ikonlar; iki günlük ortak stok, yeni ziyaret yenilemesi, kayıttan dönüş, eski kayıt, bozuk veri, dolu ambar ve negatif sipariş. Köy yönetimi, stok/ambar bakım, önceki tüccar/çeki/UI ve 20 gece regresyonu geçer.
