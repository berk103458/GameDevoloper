# Ses

*Durum: Uygulandı (4 Ekim 2026, kullanıcı isteği). Sesler `tools/ses/ses_uret.py` ile koddan üretilir (yer tutucu; aynı adla gerçek kayıt konunca oyun değişmez). Olay–ses eşlemesi `tools/icerik/icerik_uret.py` → `OLAY_SESLERI`.*

## Overview
Üç katman: **müzik** (gece neyi; olaylarda geçici döngü, ör. düğünde davul-zurna), **ortam** (kapıda meşale,
köyde gece: cırcır böceği, rüzgâr, uzak köpek, baykuş) ve **efektler** (kapı, kese, hasat, ekim, olay sesleri).
Autoload `Ses` döngüler arasında yumuşak geçiş yapar.

## Player Fantasy
Köy yaşıyor: kapı sessizken bile arkada bir köy nefes alıyor; düğün olunca davul duyuluyor.

## Detailed Rules
1. Ekran değişince ortam seçilir: köy ekranı → `ortam_koy_dongu`, diğerleri → `ortam_mesale_dongu`; müzik varsayılana döner.
2. Olay kartı açılınca genel olay sesi ve olayın `ses` efekti çalar; `muzik` doluysa kart açık kaldıkça o döngü çalar, "Devam" ile varsayılana döner.
3. Sıra olayları da `ses` alanını kullanır (sıra kapma → kalabalık, kavga → bağırış, panik → at nalı).
4. Ekim → `sfx_ekim`; gece raporunda hasat varsa → `sfx_hasat`.
5. Geçiş `GECIS` (1.5 s) sürer; dosyası olmayan döngüye geçilmez (çalan döngü sürer).

## Formulas
- **F1 Geçiş:** yeni döngü `−40 dB → hedef`, eski `hedef → −40 dB`, ikisi de `GECIS` saniyede; sonra eski durur.

## Edge Cases
- Ses dosyası yoksa efekt sessizce atlanır (`Ses._akis` → null).
- Aynı döngü yeniden istenirse baştan başlamaz.

## Dependencies
Oyun durumu (1), Gece olayları (16), Sıra olayları (25), Tarla ve ürünler (26), Ayarlar (17: Muzik/Efekt bus'ları).

## Tuning Knobs
`Ses.GECIS`, efekt düzeyleri (çağrı yerindeki dB), `OLAY_SESLERI` eşlemesi, üretici parametreleri (tempo 9/8 sekizlik 0.15 s).

## Acceptance Criteria
- Olayların andığı her ses dosyası vardır; düğün müzik döngüsünü anar. — `tests/unit/ses/ses_test.gd`
- Müzik ve ortam geçişi çalan döngünün adını değiştirir; olmayan dosya değiştirmez. — aynı test.
