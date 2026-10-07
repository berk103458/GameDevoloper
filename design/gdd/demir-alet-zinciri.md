# EKO-06 — Demir madenciliği ve alet aşınması

## Overview
Yeni Demir Madeni ham cevher çıkarır, Demir Ocağı cevheri yakacakla işlenmiş demire dönüştürür; mevcut demirhane/atölye demir ve keresteyle alet üretir. Mevcut demir kimliği işlenmiş demirdir; eski stok ve tarif kimlikleri korunur.

## Detailed Rules
Maden: 8 odun/4 taş/1 alet, iki iş yuvası, iki gün; çalışan başına temel 3 cevher. Ocak: 8 odun/6 taş/2 harç, iki iş yuvası, iki gün; 2 cevher/1 odun → temel 2 demir. Mevcut alet reçetesi 1 kereste/1 demir → temel 1 alet. Bütün gerçek iş koşulları, kış, isyan, meslek, yaş, ambar ve girdi kontrolleri uygulanır. Ocak ve maden ağır iştir; mevcut genel yapı görseli kullanılır.

Alet gereken tarla/bostan/orman/hızar/taş/kireç/demir üretimi alet stoğu sıfırsa önceki verimin %30'uyla çalışır. Fiili üretim başında aleti bulunan çalışan başına 0.1 aşınma birikir; 1 birikince bir alet tüketilir. Aletsiz çalışan sonradan ürettiği alete geçmiş kullanım borcu çıkarmaz. Girdi eksik, üretim duruşu veya başlangıçta dolu ambar aşınma üretmez. Nöbet, danışman ve hizmet alet tüketmez. Mevcut uyumsuz iş alet kırma riski ayrı olaydır; yeni aşınma RNG kullanmaz. İlk alet kervandan alınabilir; demirci aletsiz de düşük hızla yeni alet üreterek kilidi açabilir.

## Formulas
Gerçek/önizleme verimi = eski ortak formül × (alet varsa 1, yoksa 0.30). Birikmiş aşınma = önceki kesir + 0.1 × uygun fiili çalışan sayısı; tam kısım kadar mevcut alet düşer, kesir optional JSON alanıyla korunur. Sayısal tolerans yalnız 1 sınırında kayan nokta yuvarlamasını düzeltir; denge parametresi değildir.

## Edge Cases
Eski kayıtta cevher/aşınma sıfır; eski demir/alet korunur. Bozuk negatif, sayı olmayan, sonsuz veya ≥1 kesir reddedilir. Girdisiz ocak yakacağı harcamaz. Son alet üretim bittikten sonra aşınır; sonraki çalışan/gece düşük verim kullanır. Önizleme ve debug salt okunurdur, aşınma/stok/RNG değiştirmez. Üretim kesirleri mevcut kayıt alanında korunur.

## Dependencies
EKO-02 kereste/yakacak, EKO-05 harç; KoyYonetimi gerçek gece üretimi, Kaynaklar, BinaKatalogu, güvenli JSON; ortak AtamaOnizlemesi ve KoyluDenetcisi; yaş/grev/kaza adapterleri. CSV kilidi boyunca yeni etiketler adapterdedir.

## Tuning Knobs
Yeni yapı, reçete, aletsiz çarpan, aşınma ve alet gereken türler data/koy/demir_zinciri.json içinde açık denge varsayımlarıdır.

## Acceptance Criteria
Gerçek gecede cevher/demir/alet; aletsiz %70 düşüş gerçek model ve salt okunur önizlemede eşit; fiili üretimde alet tükenmesi; duruşta aşınma olmaması; eski/yeni JSON, bozuk kayıt; gerçek UI stok/maliyet/açıklama; native görüntü, ayna ve tam regresyon geçmeden ROADMAP kapanmaz. EKO-13 detaylı aşınma doğrulaması ve HUD ipucu [alet aşınması](alet-asinmasi.md) paketinde ayrıca kapanır.
