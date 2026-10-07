# Köy pazarı vergi politikası — EKO-08

## Overview
Pazarda düşük, orta veya ağır politika seçilir; tahsilat mevcut haftalık gece döngüsünde kamu kasasına girer. Kullanıcının 7 Ekim otonom geliştirme talimatıyla Refah köylü ekonomik yaşam standardı olarak kamu hazinesinden ayrılır.

## Player Fantasy
Oyuncu kamu gelirini köylülerin hoşnutluğuyla dengeler; seçimin uygulanacağı zaman ve bedel açıktır.

## Detailed Rules
Varsayılan orta politika eski işçi/usta tabanını korur. Seçim günü, kasayı veya RNG'yi ilerletmez. Vergi muafiyeti hem tahsilatı hem Moral etkisini engeller. Aynı gece yeniden çağrı ikinci tahsilat yapmaz. Tahsilatta düşük +2, orta 0, ağır −5 Moral tüm mevcut köylülere uygulanır; ekonomik Refah için de aynı delta uygulanır; mevcut Moral sınırları geçerlidir. Politikalar ve kişi Refahı JSON kaydında kalır. Refah 0–100 ekonomik yaşam standardı puanıdır; kişisel akçe veya kamu bakiyesi değildir.

## Formulas
Taban = mevcut köylülerin işçi/usta vergi toplamı. Tahsilat = ceil(taban × politika çarpanı). Düşük ×0.5, orta ×1, ağır ×2. Zaman = Takvim.hafta_basi(gun + 1, mevsim_gun). Moral/Refah etkileri dış JSON verisidir. Köy Refahı = yaşayan köylü puanlarının tam sayı ortalaması, boş köy 100. Yeni/eski kişi başlangıcı 50.

## Edge Cases
Nüfus yoksa bedel sıfırdır. Eski veya geçersiz politika orta, bozuk tahsilat günü −1 ile açılır. Geçerli gün yalnız tam sayı −1…10^9'dur. Pazar önizlemesi model veya RNG değiştirmez. Bozuk kişi Refahı dış başlangıç 50 ile açılır. Vergi muafiyeti Refah kaybını da engeller. Muafiyetin mevcut isyan/hafta davranışı korunur.

## Dependencies
KoyYonetimi._akce, Takvim, mevcut köylü usta sınıflaması, gerçek pazar kartı, optional JSON kayıt uzantısı. ADM-04 gösterge/adaptör ve köylü kartı ekonomik Refaha bağlanır; kamu akçesi ayrı alan olarak korunur. Kullanıcının otonom tasarım yetkisiyle eski eşleme bu açık kararla güncellenir.

## Tuning Knobs
Data: data/koy/vergi_politikasi.json oran adları, çarpanları ve Moral/Refah etkileri. data/koy/refah.json başlangıç ve sınırlar. İşçi/usta tabanları ve dönem uzunluğu mevcut köy ayarlarıdır. Bu oranlar denge varsayımıdır.

## Acceptance Criteria
Birim: oranlar, gerçek kamu tahsilatı, Moral, muafiyet, çift çağrı, eski/yeni/bozuk JSON, salt okunur gözlem. Native UI: gerçek pazar düğmesi seçimi, kayıt ve bedel açıklaması, okunaklı ekran. Tam regresyon ve 20 gece. Refah-kasa ayrımı, sınırlar ve eski/yeni/bozuk JSON doğrulanmalı.
