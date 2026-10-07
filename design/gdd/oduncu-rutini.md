# Oduncu ve öküz tomruk rotası — ANI-04

## Overview
Mevcut orman kampı/hızar zincirine gündüz orman kenarı → tomruk taşıma → kamp dinlenme görsel döngüsü eklenir.

## Player Fantasy
Oyuncu balta kullanan oduncuyu ve sahip olduğu öküzün hızara getirdiği tomrukları görür.

## Detailed Rules
Hazır odunluk görevlisi ve hazır hızar gerekir; yoksa mevcut normal iş rutini kullanılır. Orman durağı mevcut ızgaranın orman kuşağına komşu köşesidir; A* köy dışına taşmaz. Balta gerçek sağ el kemiğinde taşınır ve yalnız varışta sallanır. Yük aşamasında gerçek kayıtlı öküz/hazır ahır kapasitesi, görünür uygun çalışanların kimlik sırasına göre paylaştırılır; aynı öküz ikinci çalışana gösterilmez. İnek sahipliği öküz görseli üretmez. Hayvan yoksa mevcut el tomruğu kullanılır. İnsan ve öküz tek halk rotasının dönüşümünü paylaşır; ayrı hayvan yön bulma/teslim hesabı yoktur. Hızar durağı kuyudan uzak erişilebilir bina çevresidir. Akşam/gece araçlar kaldırılır ve CHR eşyasının eski görünürlüğü döner.

## Formulas
Aşama = (aşama + 1) modulo 3; bekleme JSON sureler[aşama]. Görsel öküz bütçesi = min(kayıtlı öküz, hazır ahır kapasitesi). Balta salınımı = sin(zaman × hız) × genlik. Gerçek üretim/taşıma yalnız mevcut EKO-02/EKO-03 gece modelindedir.

## Edge Cases
Hazır hızar/ahır yokluğu, sahiplik kaybı, eksik el kemiği/model ve kopuk rota güvenli fallback kullanır. Mevcut öküz GLB'de animasyon klibi yoktur: model rota üzerinde yer değiştirir, kemikli yürüyüş animasyonu iddiası yoktur. Taşıma nesneleri görseldir; gündüz durakları stokları veya sefer kuyruğunu ikinci kez değiştirmez. Orman köşe ağaçları mevcut ücretsiz GLB'den gelir.

## Dependencies
OduncuRutini, KoyHalkHareketi/KoyRotasi, CekiLojistigi, OdunZinciri, ElEsyasi ve mevcut öküz/ağaç modelleri. KoyYonetimSahnesi'nde tek orman dekoratörü çağrısı; eski RTS/çift HUD/ikinci lojistik yoktur.

## Tuning Knobs
data/oduncu_rutini.json: süreler, balta boy/renk/salınım, öküz boy/ofset/yönü, tomruk ölçü/adet/renk, orman ağaç boy/ofseti ve kuyu güvenlik mesafesi. Mevcut yürüyüş hızı ve kare başına A* bütçesi korunur.

## Acceptance Criteria
Hazır kamp/hızar/faz, gerçek sahiplik/ahır ve tek hayvan sınırı birimi. Gerçek iki işçide animasyonlu insan yürüyüşü, aşama araçları, varışta balta, öküz ve elle fallback, gece temizliği; kayıt/RNG/stok/lojistik aynı. Native sahne, kaynak/API/rota/üretim/çekiş regresyonları ve izole 20 gece geçer.
