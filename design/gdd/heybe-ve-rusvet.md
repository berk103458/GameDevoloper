# Heybe ve rüşvet

*Durum: Uygulandı (4 Ekim 2026, kullanıcı isteği). Değerler `data/ayarlar/oyun.tres` → `tools/icerik/icerik_uret.py`.*

## Overview
Kapıya gelen herkesin bir heybesi vardır: söylediği akçe ve eşyalar, bir de bazen astarına sakladıkları.
Oyuncu sorabilir ("Heybende ne var?"), heybeyi açıp bakabilir, astarı yoklayabilir. Rüşvet artık
belirsiz bir "3 akçe" değil: gelenin teklifi düğmede yazar, oyuncu heybeden ne alacağını kendisi seçer.
Yalan yakalanırsa saklananların hepsine el konabilir.

## Player Fantasy
Kapıdaki adam heybeye bakar ve gözlerini kaçıran yolcuyu yakalar; ama her aramanın bir bedeli vardır.
Sütun 1 (her kapı bir bedel): gasp da, dürüst birini didiklemek de kapıda adını çıkarır.

## Detailed Rules
1. Her gelene gece başında bir heybe üretilir (`Oturum.heybe_uret`, kendi RNG akışı `_rng_heybe`).
2. **Beyan:** `beyan_akce_min..max` arası akçe + sınıfına uygun 1–2 eşya (eşya tablosundaki `kimler`).
3. **Yalan:** `yalan_olasiligi` ile astarda `gizli_akce_min..max` akçe saklanır; ayrıca
   `gizli_esya_olasiligi` ile bir değerli eşya (yalnız astarda çıkanlar, örn. gümüş yüzük).
4. **Sohbet:** "Heybende ne var?" sorusu soru hakkından sayılmaz; gelen beyanını söyler.
5. **Heybesini ara** (sohbette ve kararda): heybe paneli açılır. Görünenler: beyan edilenler + astardan çıkanlar.
   Eşyaya basmak onu "Alınacaklar"a koyar/geri verir; akçede adet −/+ (klavye ◀ ▶, fare tekerleği) ile seçilir.
6. **Astarı yokla** (bir kez): saklı bir şey varsa çıkar, "beyan edilmedi" diye işaretlenir, "Yalan yakalandı" mührü basılır.
7. **Kararlar:**
   - **Rüşvet al:** tepsi boşsa teklif kadar beyan akçesi; doluysa tepsidekiler alınır. Gelen içeri girer.
   - **El koy, geri çevir** (yalnız yalan yakalanınca açılır): astardan çıkanların hepsi + tepsidekiler alınır; gelen geri döner; bar etkisi "Ret" ile aynıdır.
   - Kabul / Ret / Kışla: heybeden bir şey alınmaz (tepsi yok sayılır).
8. Alınan akçe ve mal değeri kasaya (akçe), gıda değeri ambara gider.

## Formulas
- **F1 Teklif:** `teklif = max(1, ceil(beyan_akce × teklif_orani))`
- **F2 Gasp:** `gasp = max(0, Σ(beyan edilenlerden alınan × birim değer) − teklif)`; astardan çıkanlar sayılmaz.
  `gasp > 0` ise Halk `−gasp_halk_cezasi` (bir kez).
- **F3 Dürüst arama:** astar yoklandı ve saklı bir şey yoksa, karar anında Halk `−durust_arama_cezasi`.
- **F4 Dağılım:** `akçe += Σ değer (tür ≠ gida)`, `ambar += Σ değer (tür = gida)`.
- **Örnek:** Beyan 6 akçe + arpa (4); astarda 20 akçe + gümüş yüzük (9). Teklif = ceil(6 × 0.5) = 3.
  Oyuncu arpayı tepsiye koyup yalanı yakalar ve el koyar → akçe +29 (20 + 9), ambar +4;
  gasp = 4 − 3 = 1 > 0 → Halk −1. Aralıklar: teklif 1–4, astar akçesi 8–20, saklı yüzükle 17–29.

## Edge Cases
- Hiç seçmeden "El koy": yine saklananların hepsi alınır.
- Yalan yoksa "El koy" hiç görünmez.
- İkinci perdede seçenekler kabul/ret; heybe araması ve "El koy" yine çalışır, rüşvet yoktur.
- Astar bir kez yoklanır; panel yeniden açılınca yırtık ve çıkanlar yerinde kalır.
- Heybe gece içinde yaşar; kayıt gece sonunda olduğu için heybe kaydedilmez, yalnız RNG durumu kaydedilir (eski kayıtlar 3 durumlu RNG ile yüklenir).

## Dependencies
Karar (7), Barlar (8), Köy üretimi/ambar (12), Sohbet (6), İçerik veri hattı (2), Sohbet ve karar arayüzü (18).

## Tuning Knobs
`beyan_akce_min/max` (2/8), `yalan_olasiligi` (0.35), `gizli_akce_min/max` (8/20), `gizli_esya_olasiligi` (0.4),
`teklif_orani` (0.5), `gasp_halk_cezasi` (1), `durust_arama_cezasi` (1), eşya tablosu (`ESYALAR` içerik betiğinde).

## Acceptance Criteria
- Rüşvet düğmesi miktarı yazar (teklif ya da tepsi değeri). — `tests/oto` ekran görüntüsü 8.
- Yalancının astarı yoklanınca saklananlar görünür, mühür basılır, "El koy" açılır.
- El koyunca saklanan akçe ve eşyaların tamamı alınır, gelen geri döner. — `tests/unit/heybe/heybe_test.gd`
- Teklif üstü beyan eşyası almak Halk'ı 1 düşürür; dürüst birinin astarını yoklamak da. — aynı test.
- Aynı tohum aynı heybeleri üretir; yalan oranı ayarın çevresindedir. — aynı test.
