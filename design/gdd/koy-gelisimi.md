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
6. **Akçe hiç kurumaz (QA A-001…003, akçe takılması):** gece sonunda sırasıyla
   - ambarın bir gecelik tüketimden fazlası tüccara satılır (F3);
   - tezgâh bulan esnaf `esnaf_gelir`, bulamayan her iki esnaf seyyar satıştan 1 akçe getirir (F4);
   - asker maaşı akçeden ödenir; akçe yetmezse eksiği ambardan, ürünle ödenir (F5). İkisi de yetmezse Ordu −1.

## Formulas
- **F1 Konak şartı:** `olur = akçe ≥ konak_bedel[s] ∧ nüfus ≥ konak_nufus[s]`.
- **F3 Ambar takası:** `yedek = max(tüketim, 1) × ambar_yedek_gece`; `fazla = ambar − yedek`;
  `akçe = min(⌊fazla / ambar_akce_orani⌋, takas_taban + pazar × takas_pazar_artis)`; satılan ürün `akçe × ambar_akce_orani`.
  Örnek: tüketim 19, ambar 190, pazar 0 → yedek 19, fazla 171, akçe min(42, 2) = 2, ürün −8.
- **F4 Esnaf geliri:** `satan = min(esnaf, pazar_tezgah_taban + pazar × pazar_tezgah_artis)`;
  `gelir = satan × esnaf_gelir + ⌊(esnaf − satan) / seyyar_bolen⌋ + kervansaray × kervansaray_gelir`.
- **F5 Maaş:** `maaş = ⌊asker / 2⌋`; `eksik = max(0, maaş − akçe)`; eksik > 0 ve `ambar ≥ eksik × ambar_akce_orani` ise
  akçe 0'a, ambar `eksik × ambar_akce_orani` düşer; değilse akçe 0 ve Ordu −1.

## Edge Cases
- En üst seviyede satır "en üst seviyede" yazar, kurulamaz.
- Eski kayıtlarda konak yoktur → 0 okunur.

## Dependencies
Köy yapıları (11), Köy nüfusu (10), Barlar (8), Köy görünümü (20), Tarla ve ürünler (26).

## Tuning Knobs
`konak_bedel` [10, 18, 28], `konak_nufus` [5, 10, 16], `sur_bedel`; `ambar_yedek_gece` 1, `ambar_akce_orani` 4,
`takas_taban` 2, `takas_pazar_artis` 1, `seyyar_bolen` 2. Ayar: `tools/denge/ekonomi_benzetimi.gd` QA botlarının
stratejileriyle gece gece akçe/ambar izini basar.

## Acceptance Criteria
- Nüfus eksikken konak kurulmaz; tamamlanınca kurulur, Soylular +1. — `tests/unit/koy_yapilari/koy_yapilari_test.gd`
- Sur birinci perdede kurulur; kayıt konağı taşır. — aynı test.
- Ambar takası, seyyar satış ve ambardan maaş F3–F5'e uyar. — `tests/unit/ekonomi/ekonomi_test.gd`
- Görünüm seviyeye göre değişir. — `production/qa/evidence/koy-gelisme-1/`
