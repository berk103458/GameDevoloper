# Açlık–sağlık çaprazı — KRI-12

## Overview
Ambar neredeyse boşken açlık ile hastalık birbirini besler. Mevcut gece döngüsü, `Koylu.saglik` ve `SaglikYoneticisi` temas bulaşması genişletilir; ikinci açlık, sağlık veya salgın motoru yoktur.

## Player Fantasy
Erzak dibe vurduğunda köy yalnız aç kalmaz; zayıflayan beden hastalığa da yenik düşer. Oyuncu ambarı 3 erzağın üstünde tutarak salgının hızlanmasını önler.

## Detailed Rules
- Gece başında (mevcut kış hastalığından sonra, salgın bulaşmasından önce) ambarda `gida < erzak_esigi` (3) ise o gece çapraz etki açılır ve gece raporuna tek satır yazılır.
- Açık gecede dış görevde olmayan her köylü mevcut sağlık döngüsünde ek `saglik_kaybi` (1) kaybeder; bu, mevcut açlık (`ac`) kaybına ve hastalık kaybına eklenir, ölüm kontrolünden önce uygulanır.
- Açık gecede `SaglikYoneticisi` temas bulaşma riski `yayilma_carpani` (×2) ile çarpılır, tavan 100. Tifo (yalnız kirli su) etkilenmez; temas/aday sayısı sınırları aynıdır.
- Yeni RNG çağrısı/akışı eklenmez; mevcut temas zarının yalnız risk eşiği değişir. Çekim sayısı sabit değildir: iki yeni vaka (`AZAMI_YENI = 2`) sınırına erken varıldığında döngü durur; en çok üç temas (`AZAMI_TEMAS = 3`) denenir. Örneğin bir görünür humma kaynağı ve aynı hazır binada üç aday için 25, 30, 90 zarları taban %20'de üç çekim/0 vaka, ×2 %40'ta iki çekim/2 vaka üretir. Sonraki RNG durumu bu yüzden farklı olabilir. Fotoğraf yalnız o gece için anlamlıdır, kayda yazılmaz; yüklenen köy bir sonraki gece yeniden ölçer.

## Formulas
`aktif = gida_gece_basi < 3`; `risk' = min(100, risk × 2)`; `saglik' = saglik − 1` (aktif gecede, dış görev hariç).

## Edge Cases
- Boş köy veya bitmiş oturum: etki ve rapor yok.
- Erzak eşikte (3): etki yok.
- Kervandaki kişi ek kayıp almaz (köyde değil).

## Dependencies
`KoyYonetimi.gece`/`_saglik_ve_moral` (iki satır), `SaglikYoneticisi.gece` (risk çağrısı), `IflasYoneticisi.olay_metin` (rapor). Ayar: `data/koy/aclik_saglik.json`.

## Acceptance Criteria
Birim: `tests/unit/kvr/aclik_saglik_test.gd`; RNG sınırı: `tests/unit/kvr/aclik_saglik_rng_sinir_test.gd` (bir görünür kaynak + üç aday, tabanda üç/×2'de iki çekim, gerçek motor tohumu ve RNG durumu). Akış: `tests/oto/aclik_saglik_kontrol.gd` (gerçek köy ekranı gecesi, rapor, GuvenliKayit, tok gece).

## Codex kanonik doğrulaması
tam sanity 319 PASS / 0 hata / 20 gece; aynı kanonik kaynaklarda birim ve gerçek HUD/gece/rapor/GuvenliKayit akışı geçti. Loglar: `work/kri12/sanity_ozet.log`, `final_results.json`; tüm kaynak hash değerleri sabit. Uygulama ve yukarıdaki denge kararı Claude'a aittir; bu tur oyun kodu değiştirilmedi. Asset gerekmedi.
