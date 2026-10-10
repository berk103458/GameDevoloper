# Atıl bayrakların olaylara bağlanması — SYS-18

## Overview
Olay kartlarında konan ama hiçbir sistemin okumadığı `Oturum.bayraklar` gece/diplomasi sonucuna bağlanır. Mevcut bayrak sözlüğü ve göstergeler kullanılır; KVR-06 `Flag_*` sorgu sözlüğüne dokunulmaz, yeni sözlük yoktur.

## Detailed Rules
`Oturum.gece_sonu` içinde köy gecesinden sonra (`src/sistemler/atil_bayraklar.gd`), aynı gece bir kez, RNG'siz:
| Bayrak (kaynak olay) | Sıklık | Sonuç |
|---|---|---|
| `miraen_sadik` (Miraen çavuş kalır) | her gece | asayiş riski −1 (devriye) |
| `dervis` (dervişi doyur) | her gece | belirtisi açık her hastaya moral +2 |
| `baci_tezgah` (Ayşe bacıya tezgâh) | hafta başı | köy kasası +2 akçe |
| `turkmen_kin` (Sorhan damgası) | hafta başı | husumet +2 (diplomasi) |
| `thessra_kirgin` (Thessra afyon) | hafta başı | adalet −1 |
| `rusvet_sayisi` ≥ 3 | hafta başı | asayiş riski + ⌊rüşvet/3⌋ (tavan 5) |

Gece raporunda tek "Eski kararların izi" satırı. Bayraklar zaten kayıtta; yeni kayıt alanı yok. Ayarlar: `data/atil_bayraklar.json`.

## Acceptance Criteria
`tests/unit/kvr/atil_bayraklar_test.gd`: bayraksız oyun değişmez, her bayrağın sonucu, hafta ortası, eşik, tekrar yok, gerçek `gece_sonu` + kayıt.
