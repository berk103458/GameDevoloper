# Alet aşınması — EKO-13

## Overview
EKO-06'nın gerçek üretime bağlı aşınma adaptörü kullanılır; ikinci dayanıklılık sistemi kurulmaz. EKO-13 son aletin tükenmesini farklı üretim türlerinde doğrular ve mevcut stok ipucunu tamamlar.

## Player Fantasy
Oyuncu aletin ne zaman tükenebileceğini ve aletsiz üretimin neden yavaşladığını mevcut kaynak göstergesinden anlar.

## Detailed Rules
Ortak alet stoğu kullanılır. Alet gereken fiili çalışan başına 0.1 aşınma birikir; 1'de bir alet tüketilir. Son alet o çalışanın üretimi tamamlandıktan sonra tükenir; sonraki çalışan/gece %30 verimle çalışır. Girdi eksik, üretim duruşu ve dolu ambar aşındırmaz. Aletsiz iş geçmiş aşınma borcu üretmez; sonradan üretilen yeni alet geriye dönük tüketilmez. Kaza veya uyumsuz işte alet kırılması ayrı mevcut mekaniktir.
Alet göstergesi stok, birikmiş aşınma, çalışan başına oran ve aletsiz verimi salt okunur gösterir. Kamu ve kişisel kasa değişmez.

## Formulas
A = eski aşınma + fiili aletli çalışan × asinma_calisma. Stoktan floor(A) alet tüketilir; kalan kesir saklanır. Ortak üretim/önizleme formülü alet yoksa aletsiz_carpan ile çarpılır. Yuvarlama toleransı yalnız kayan nokta sınırındadır.

## Edge Cases
Eski kayıt aşınmayı sıfır kabul eder; yanlış tür/negatif/sonsuz/≥1 kesir reddedilir. Alet gereken tür ve oran dış JSON'dur. RNG, stok veya kesir HUD çizimiyle ilerlemez. Gıda bozulması aşınmadan ayrı gece bakımında işlenir.

## Dependencies
DemirZinciri, KoyYonetimi._uret, AtamaOnizlemesi, Kaynaklar, mevcut Hud, EKO-06 yapı/reçete zinciri. Eski API ve CSV korunur.

## Tuning Knobs
`data/koy/demir_zinciri.json`: alet_gereken, asinma_calisma, aletsiz_carpan. UI bu ortak değerleri okur, ayrı denge sabiti taşımaz.

## Acceptance Criteria
alet_asinmasi_test: gerçek tarla, taş ocağı ve demir madeninde son aletli tam üretim, sonraki aletsiz düşük üretim, kesir ve salt okunur gözlem. demir_zinciri_test: girdi/dolu ambar/JSON/önizleme. demir_zinciri_kontrol: gerçek HUD %40 aşınma ve %30 verim ipucu, model değişmez; headless ve native görsel kontrol. EKO-12 tam 120 kontrol tabanı korunur.
