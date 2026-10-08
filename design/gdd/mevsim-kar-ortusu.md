# Kar yağışı ve örtüsü — MEV-04

## Overview
Mevcut IklimGorseli yağışı ve zemin/çimen shaderları normal kış takvimine bağlanır. Yeni MevsimKarOrtusu çatılarda aynı kar oranını kullanır.

## Player Fantasy
Oyuncu kış ilerledikçe köy zemini ve çatıların beyazlaştığını görür.

## Detailed Rules
Kışın ilk gününde %15, son gününde %85 örtü; ara günler doğrusal. Fırtına önayarı eski %85 değeri korur. Baharda örtü ve yağış kaldırılır. Önceki tek MultiMesh yağış düğümü tekrar kullanılır; tanecikler tek yerde BoxMesh yer tutucudur. Yapı materyalleri kopyalanıp üst normal yüzeylerine ek shader geçişi eklenir; temel doku/malzeme ezilmez. Görsel sorgu gün, kayıt, stok ve RNG değiştirmez.

## Formulas
İlerleme = (mevsim_gunu-1)/max(1,süre-1). Örtü = lerp(ilk_gun,son_gun,ilerleme). Fırtına firtina oranıdır; kış dışı normal hava sıfır. Çatı alfa = örtü × smoothstep(yukari_esik,0.9,dünya normalinin y değeri).

## Edge Cases
Yeni bina yeniden kurulduğunda örtü yeniden uygulanır. Aynı düğüme tekrar uygulama materyal geçişi çoğaltmaz; bahar aynı geçişin alfasını sıfırlar. Kayıt dönüşü aynı gün ve iklimden aynı oranı türetir. Admin/normal takvim tek efekt kullanır. Düşük grafik profili mevcut yağış katmanını gizler; ekonomi etkilenmez.

## Dependencies
MevsimYoneticisi, IklimDeneyi, mevcut IklimGorseli çağrısı ve KoyYonetimSahnesi yenile akışı. Yeni helper ve çatı shaderı dışında ikinci sahne/yağış/HUD yoktur.

## Tuning Knobs
Data/kar_ortusu.json ilk_gun,son_gun,firtina,yukari_esik. VFX-KAR isteğe bağlı doku ihtiyacı envanter G MEV04-KAR satırında; üretim/indirme yapılmadı. Mevcut zemin ve çimen materyalleri kullanılır.

## Acceptance Criteria
Günlük artış, bahar sıfır, admin fırtına uyumu, read-only ve kayıt roundtrip unit test. Gerçek köyde zemin ve çatı aynı oran, tekrar çağrıda aynı geçiş sayısı, tek kutu yağışı, native shader derleme ve görüntü doğrulanır. Grafik profili ve karakter hava regresyonları geçer.
