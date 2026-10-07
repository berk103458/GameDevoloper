# Karakter hava tepkileri — ANI-09

## Overview
Mevcut iklim sözleşmesi yağmurda saçak sığınması, kar fırtınasında yavaş/büzülmüş yürüyüşü tetikler.

## Player Fantasy
Köylüler yağışa ve soğuğa görünür biçimde tepki verirken nöbetçiler görevini sürdürür.

## Detailed Rules
Mevcut IklimDeneyi listesine sona yagmur eklenir; önceki üç seçimin kimliği/sırası ve ekonomik çarpanları korunur. Yağmurda hazır kulübe/atölye/demirhane/odunluk/hızar/fırın saçağının erişilebilir en kısa A* ön durağı kullanılır. Bina içine girilmez; nöbetçiler sığınmaz. İş hareketi ve iş eşyası sığınırken kapanır. Yağmur kaldırıldığında normal atama/faz rutini geri gelir. Kar fırtınasında mevcut yürüyüş tween hızına dış çarpan uygulanır; aynı DurusDuzeltici gövdeyi hafif büzer. Sıradan kışta kar fırtınası yoksa hız aynı kalır.

## Formulas
Görsel yürüyüş hızı = mevcut hız × mevcut kişi farkı × (kar_hiz veya 1). Gövde eğimi = kar_egim veya 0 radyan. Saçak seçimi mevcut A* yolunun hücre sayısına göre; eşitlikte mevcut bina sırası. Görsel tepki üretim/tüketim/gece/RNG hesabını değiştirmez.

## Edge Cases
Hazır/erişilebilir saçak yoksa mevcut rota korunur. Yıkılmış/inşa halindeki yapı hedef değildir. Hava değişimi mevcut yenileme ile rota/duruşu sıfırlar. Isınma ve zanaat hareketleri sığınma ile çakışmaz. Rastgele yağış üreticisi veya yeni takvim kurulmaz; mevcut admin denetçisi ve kayıt yağmur değerini taşır. MEV yağış takvimi/VFX ayrı paket; yeni asset üretimi yoktur.

## Dependencies
KarakterHavaTepkisi, mevcut IklimDeneyi/IklimDenetcisiPaneli, KoyRotasi/KoyHalkHareketi, KarakterModel yürüyüş tweeni, DurusDuzeltici ve mevcut üretim rutinlerinin eşya temizliği.

## Tuning Knobs
data/karakter_hava.json: kar hız/eğim, hazır saçak türleri, düz kutu boy/renk/yüksekliği. Tek yer tutucu değişim noktası sacak_kur. Yeni gerçek saçak/soğuk yürüyüş ve yağmur efekti ihtiyaçları docs/EKSIK_ASSET_ENVANTERI.md.

## Acceptance Criteria
Normal/kar/yağmur/kış ayrımı, eski-yeni kayıt, RNG/stok korunumu. Gerçek sahne A* sığınma ve nöbetçi korunması, tek saçak, mevcut admin seçimi, yağmur bitişi, deterministik tween adımıyla gerçek kar hız farkı, gerçek modifier gövde eğimi ve yıkım. Native/ayna ve ilgili iklim/önceki rutin/açılış/20 gece geçer.
