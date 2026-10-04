# Köy gelişimi

*Durum: Uygulandı (4 Ekim 2026, kullanıcı isteği). Değerler `data/ayarlar/oyun.tres` → `tools/icerik/icerik_uret.py`.*

## Overview
Köy büyüdükçe görünümü değişir. Yeni yapı **Köy konağı** (3 seviye) nüfus şartıyla kurulur; **Sur** artık
birinci perdede de kurulabilir ve her seviyede kazıklar yükselir. Konak seviyesi evleri de değiştirir:
çadırlar eve döner, evler büyür.

## Player Fantasy
"Kapıdan aldığım her kişi bu köyü büyüttü." Köy ekranında emeğin görünür karşılığı.

## Detailed Rules
1. Konak, `konak_bedel[s]` akçe ve en az `konak_nufus[s]` köylü ister (s = mevcut seviye).
2. Konak her kuruluşta Soylular +1.
3. Görünüm: 1 = taş temel, ahşap kat, çatı, meşale; 2 = avlu duvarı ve sancak; 3 = gözcü kulesi.
4. Konak < 2 iken her üçüncü ev çadırdır; ev boyu `2.6 + konak × 0.35`.
5. Sur her perdede kurulabilir; kazık boyu `1.8 + sur × 0.6`. Çit tarla alanında kesilir (ekinler örtülmez).

## Formulas
- **F1 Konak şartı:** `olur = akçe ≥ konak_bedel[s] ∧ nüfus ≥ konak_nufus[s]`.

## Edge Cases
- En üst seviyede satır "en üst seviyede" yazar, kurulamaz.
- Eski kayıtlarda konak yoktur → 0 okunur.

## Dependencies
Köy yapıları (11), Köy nüfusu (10), Barlar (8), Köy görünümü (20), Tarla ve ürünler (26).

## Tuning Knobs
`konak_bedel` [10, 18, 28], `konak_nufus` [5, 10, 16], `sur_bedel`.

## Acceptance Criteria
- Nüfus eksikken konak kurulmaz; tamamlanınca kurulur, Soylular +1. — `tests/unit/koy_yapilari/koy_yapilari_test.gd`
- Sur birinci perdede kurulur; kayıt konağı taşır. — aynı test.
- Görünüm seviyeye göre değişir. — `production/qa/evidence/koy-gelisme-1/`
