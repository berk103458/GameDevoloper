# Tarla ve ürünler

*Durum: Uygulandı (4 Ekim 2026, kullanıcı isteği). Değerler `data/ayarlar/oyun.tres` → `tools/icerik/icerik_uret.py`.*

## Overview
Her iki çiftçi köyün doğusunda bir tarla (parsel) açar. Oyuncu köy ekranında boş parsellere ürün eker;
ekin her gece büyür, olgunlaşınca hasat ambara gider. Yağmur, kuraklık, çekirge ve erken don büyümeyi ve verimi etkiler.
Çiftçiler tarlada çalışırken görünür.

## Player Fantasy
Kapıdan aldığın çiftçiler toprağa can verir; hangi ürünü ekeceğin kışa ne kadar hazır olacağını belirler.

## Detailed Rules
1. Parsel sayısı = `ceil(çiftçi / ciftci_tarla_basina)`, en çok `tarla_azami`; gece sonunda güncellenir. Azalırsa sondaki parseller ekinleriyle kaybolur.
2. Ekim: köy ekranında "X ek" düğmesi ilk boş parsele eker; tohum bedeli ambardan düşer.
3. Her gece sonu (ambar üretiminden sonra) ekili parseller bir gece büyür; `gün ≥ süre` olunca hasat: `ambar += round(verim × çarpan)`, parsel boşalır.
4. Çiftçinin günlük üretimi (`ciftci_uretim`) sürer; tarla ek hasat getirir.
5. Olaylar (gece olayı, koşul `tarla_ekili_min: 1`): `tarla_gun ±n` (büyüme), `tarla_verim ×x` (verim), `tarla_don` (`don_esigi` geceden genç ekinler ölür).
6. Görsel: parsel = sürülmüş toprak + karıklar; ekin olgunluğa göre uzar ve sararır (tahıl koni, baklagil öbek); ekili parselde iki çiftçi eğilip orak sallar.

## Formulas
- **F1 Parsel:** `n = min(tarla_azami, ceil(ciftci / ciftci_tarla_basina))` — 5 çiftçi → 3 parsel.
- **F2 Hasat:** `verim_son = round(verim × çarpan)` — çekirge (×0.5) sonrası buğday 10 → 5.
- **Ürünler:** Buğday 4 gece, +10, tohum 2 · Arpa 3, +7, 1 · Mercimek 2, +4, 1 · Nohut 3, +6, 2.
  Gece başına net: buğday 2.0, arpa 2.0, mercimek 1.5, nohut 1.33 — buğday ve arpa verimli, mercimek hızlı ve risksiz (dondan önce biter).

## Edge Cases
- Tohum için ambar yetmezse düğme pasif. Boş parsel yoksa düğmeler görünmez.
- Kuraklıkta büyüme 0'ın altına inmez. Don yalnız genç ekini öldürür.
- Kayıt: parseller (ürün, gün, çarpan) kaydedilir; eski kayıtlarda tarla yoktur.

## Dependencies
Köy nüfusu (10), Köy üretimi (12), Gece olayları, Köy görünümü (20), Kayıt (16).

## Tuning Knobs
`ciftci_tarla_basina` (2), `tarla_azami` (6), ürün tablosu (`BITKILER`), `don_esigi` (1), olay ağırlıkları.

## Acceptance Criteria
- Parsel sayısı, ekim, büyüme, hasat, yağmur/kuraklık/çekirge/don etkileri ve kayıt. — `tests/unit/tarla/tarla_test.gd`
- Ekinler olgunluğa göre görünür ve çiftçiler çalışır. — `production/qa/evidence/koy-tarla-1/`
