# Açlık–sağlık çaprazı — KRI-12

## Overview
Ambar neredeyse boşken açlık ile hastalık birbirini besler. Mevcut gece döngüsü, `Koylu.saglik` ve `SaglikYoneticisi` temas bulaşması genişletilir; ikinci açlık, sağlık veya salgın motoru yoktur.

## Player Fantasy
Erzak dibe vurduğunda köy yalnız aç kalmaz; zayıflayan beden hastalığa da yenik düşer. Oyuncu ambarı 3 erzağın üstünde tutarak salgının hızlanmasını önler.

## Detailed Rules
- Gece başında (mevcut kış hastalığından sonra, salgın bulaşmasından önce) ambarda `gida < erzak_esigi` (3) ise o gece çapraz etki açılır ve gece raporuna tek satır yazılır.
- Açık gecede dış görevde olmayan her köylü mevcut sağlık döngüsünde ek `saglik_kaybi` (1) kaybeder; bu, mevcut açlık (`ac`) kaybına ve hastalık kaybına eklenir, ölüm kontrolünden önce uygulanır.
- Açık gecede `SaglikYoneticisi` temas bulaşma riski `yayilma_carpani` (×2) ile çarpılır, tavan 100. Tifo (yalnız kirli su) etkilenmez; temas/aday sayısı sınırları aynıdır.
- RNG çekim sayısı değişmez; yalnız eşik değişir. Fotoğraf yalnız o gece için anlamlıdır, kayda yazılmaz; yüklenen köy bir sonraki gece yeniden ölçer.

## Formulas
`aktif = gida_gece_basi < 3`; `risk' = min(100, risk × 2)`; `saglik' = saglik − 1` (aktif gecede, dış görev hariç).

## Edge Cases
- Boş köy veya bitmiş oturum: etki ve rapor yok.
- Erzak eşikte (3): etki yok.
- Kervandaki kişi ek kayıp almaz (köyde değil).

## Dependencies
`KoyYonetimi.gece`/`_saglik_ve_moral` (iki satır), `SaglikYoneticisi.gece` (risk çağrısı), `IflasYoneticisi.olay_metin` (rapor). Ayar: `data/koy/aclik_saglik.json`.

## Acceptance Criteria
Birim: `tests/unit/kvr/aclik_saglik_test.gd`; akış: `tests/oto/aclik_saglik_kontrol.gd` (gerçek köy ekranı gecesi, rapor, GuvenliKayit, tok gece).
