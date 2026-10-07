# Köy pazarı vergi politikası — EKO-08 (aktif)

## Overview
Pazarda düşük, orta veya ağır politika seçilir; tahsilat mevcut haftalık gece döngüsünde kamu kasasına girer. Refah sözleşmesi kullanıcı kararı bekler; madde henüz kapanmaz.

## Player Fantasy
Oyuncu kamu gelirini köylülerin hoşnutluğuyla dengeler; seçimin uygulanacağı zaman ve bedel açıktır.

## Detailed Rules
Varsayılan orta politika eski işçi/usta tabanını korur. Seçim günü, kasayı veya RNG'yi ilerletmez. Vergi muafiyeti hem tahsilatı hem Moral etkisini engeller. Aynı gece yeniden çağrı ikinci tahsilat yapmaz. Tahsilatta düşük +2, orta 0, ağır −5 Moral tüm mevcut köylülere uygulanır; mevcut Moral sınırları geçerlidir. Politikalar JSON kaydında kalır.

## Formulas
Taban = mevcut köylülerin işçi/usta vergi toplamı. Tahsilat = ceil(taban × politika çarpanı). Düşük ×0.5, orta ×1, ağır ×2. Zaman = Takvim.hafta_basi(gun + 1, mevsim_gun). Moral etkisi dış JSON verisidir.

## Edge Cases
Nüfus yoksa bedel sıfırdır. Eski veya geçersiz politika orta, bozuk tahsilat günü −1 ile açılır. Geçerli gün yalnız tam sayı −1…10^9'dur. Pazar önizlemesi model veya RNG değiştirmez. Muafiyetin mevcut isyan/hafta davranışı korunur.

## Dependencies
KoyYonetimi._akce, Takvim, mevcut köylü usta sınıflaması, gerçek pazar kartı, optional JSON kayıt uzantısı. ADM-04 Refah = kamu akçesi kararı ile ROADMAP ağır vergi Refah kaybı çelişiyor. Kullanıcıya ekonomik Refah mı yoksa mevcut kasa eşlemesi mi korunacağı soruldu; yanıt gelmeden bu sözleşme değişmez.

## Tuning Knobs
Data: data/koy/vergi_politikasi.json oran adları, çarpanları ve Moral etkileri. İşçi/usta tabanları ve dönem uzunluğu mevcut köy ayarlarıdır. Bu oranlar denge varsayımıdır.

## Acceptance Criteria
Birim: oranlar, gerçek kamu tahsilatı, Moral, muafiyet, çift çağrı, eski/yeni/bozuk JSON, salt okunur gözlem. Native UI: gerçek pazar düğmesi seçimi, kayıt ve bedel açıklaması, okunaklı ekran. Tam regresyon ve 20 gece. Refah kararı uygulanıp doğrulanmadan EKO-08 tamamlanmış sayılmaz.
