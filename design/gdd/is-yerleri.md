# İş yerleri

*Durum: Uygulandı (4 Ekim 2026, kullanıcı isteği). Değerler `data/ayarlar/oyun.tres` → `tools/icerik/icerik_uret.py`.*

## Overview
Kapıda kabul edilen (ya da rüşvetle giren) kişi için bekçi bir iş yeri seçer: Tarla, Pazar, Kervansaray
(kurulmuşsa) ya da Kışla. Kişi köyde yazıldığı işi yapar. İşe uygun olmayan birini yazmak oranın gücünü düşürür.

## Player Fantasy
"Bu adamın eli kılıç tutar mı, orak mı?" Kapıda verilen ikinci karar: kişiyi tanıyıp doğru yere koymak.

## Detailed Rules
1. Karar Kabul ya da Rüşvet al olduğunda (birinci perde) "Nerede çalışacak?" adımı açılır; "Karara dön" geri götürür.
2. Satırın alt yazısı işin sınıfını söyler ("çiftçi işi"); kişinin uygun olup olmadığını söylemez.
3. Kişi köy nüfusunda işin sınıfında sayılır (tarla → çiftçi, pazar ve kervansaray → esnaf, kışla → asker).
4. Kişinin görünen sınıfı işin sınıfından farklıysa işin barı `uyumsuz_ceza` düşer.
5. "Kışlaya yaz" kararı ayrı kalır (kendi bar etkileriyle); ikinci perdede iş adımı yoktur.

## Formulas
- **F1 Uyumsuzluk:** `gelen.sinif ≠ is_siniflari[i]` ⇒ `bar[is_barlari[i]] −= uyumsuz_ceza`.
- **Örnek:** Esnaf bir çırak kışlaya yazılır → asker sayılır, Ordu −1 (karar etkisine ek).

## Edge Cases
- Kervansaray kurulmadan listede görünmez.
- Adlı karakterler gerçek sınıfıyla karşılaştırılır.
- İkinci perdede seçenek yalnız kabul/ret; iş adımı atlanır, kişi kendi sınıfında sayılır.

## Dependencies
Karar (7), Barlar (8), Köy nüfusu (10), Köy yapıları (11), Sohbet ve karar arayüzü (18).

## Tuning Knobs
`is_idleri`, `is_siniflari`, `is_barlari`, `is_yapilari` (tablo), `uyumsuz_ceza` (1; 0 = bedel yok, 2 = sert).

## Acceptance Criteria
- Kabulden sonra iş adımı açılır; seçim kişiyi o işin sınıfında sayar. — `tests/unit/is_yerleri/is_yerleri_test.gd`
- Uygunsuz yazım işin barını düşürür; uygun yazım düşürmez. — aynı test.
- Kervansaray yalnız kurulunca listelenir. — aynı test.
