# Oyun Gelişim Raporu (Tester)

Her tur/gün sonunda en üste bir giriş. Kalıp: `docs/tester/TESTER_REHBERI.md` §5. Sayılar ölçülerek yazılır.

<!-- En yeni giriş buraya -->

## 2026-10-11 · Tur 2 · commit 5c9a5b1 → 5396fae
- **Sağlık:** Etkin sanity **320/320 PASS** (harness "315 failed" = yalnız ortam sertifika hatası; gerçek `KALDI`/`SCRIPT ERROR` 0). 7/24 koşu: 106/108/109/110/111 tamamlandı, **0 DONMA**, 0 çökme (oyun 112 sürerken hata spam'i: TST-0003).
- **Bu turda giren:** 5396fae — BUG-0016 (CHR sorgusunda tüm cevaplar kapalı + ipucu kilitliyken kapı softlock'u; `KilitliKarar` "Kararını ver" çıkışı + regresyon testi).
- **İyileşen:** Kapı sorgusunda oyuncu artık sıkışmıyor; fix sonrası başlayan oyun 109'da KILIT/SOHBET_KILIDI yok (öncesi 106/107/108'de vardı).
- **Kötüleşen / regresyon:** Kapıda yok; ancak HEAD'de (5396fae) 7/24 oyun 112'de gece rutini her karede `is_yeri` SCRIPT ERROR basıyor (TST-0003, P1).
- **Oynanış hissi:** Kapı sorgusu akıcı; tek pürüz: başarısız ikna denemesi cevabı kalıcı tüketiyor ve bunu ekranda açıklamıyor (ONR-001).
- **Denge eğrisi:** Tur boyunca tamamlanan **5/5 oyun yenilgiyle bitti** — 106 Tekfur akıncıları (g6), 108 İsyan (g14, huzur 6), 109 Muhafız azledildi (g6), 110 İsyan (g12, huzur 2), 111 Tekfur akıncıları (g18). Zafer 0/5; ortalama son gün ≈ **11,2**. Düşük kabul (0.2–0.6) oyunlarında köy isyanla çöküyor → güçlü [DENGE] sinyali.
- **Açık bulgu:** P0 0 · P1 1 (TST-0003) · P2 2 (TST-0001, TST-0002) · P3 0
- **Bir sonraki tur odağı:** TST-0003 (P1, gece rutini null köylü) düzeltmesini doğrula; TST-0002'nin `[KEY_NOT_FOUND]` gösterdiği ekranı görüntüyle kesinleştir; TST-0001'in oynanış etkisi (`sayi()` çağrıları); pencereli elle CHR ikna-fail doğrulaması; düşük kabul ile zafer/denge eğrisi.

## 2026-10-11 · Tur 1 (eğitim) · commit 5c9a5b1 → 5c9a5b1 (tur boyunca değişmedi)
- **Sağlık:** ölçülmedi (eğitim turu — sanity ve otomatik koşu çalıştırılmadı)
- **Bu turda giren:** yok (kod değişmedi; yalnız rehber, skill, ROADMAP panosu ve OYNA.md okundu)
- **İyileşen:** ölçülmedi
- **Kötüleşen / regresyon:** ölçülmedi
- **Oynanış hissi:** ölçülmedi (elle oynama yapılmadı)
- **Denge eğrisi:** Tur boyunca tamamlanan **5/5 oyun yenilgiyle bitti** — 106 Tekfur akıncıları (g6), 108 İsyan (g14, huzur 6), 109 Muhafız azledildi (g6), 110 İsyan (g12, huzur 2), 111 Tekfur akıncıları (g18). Zafer 0/5; ortalama son gün ≈ **11,2**. Düşük kabul (0.2–0.6) oyunlarında köy isyanla çöküyor → güçlü [DENGE] sinyali.
- **Açık bulgu:** P0 0 · P1 0 · P2 0 · P3 0 (bu turda TST numarası açılmadı; bulgu listesi boş)
- **Kaynak koddan izlenen:** BUG-0013 — kayıttan **Devam** köy yerine kapıyı açıyor. Kök neden `src/arayuz/ana.gd` `devam_et()` (satır 68–74): kayıt yüklendikten sonra koşulsuz `_kapiya_git()` çağrılıyor; `Oturum.kaydet()` (satır 725–747) kaydın hangi fazda olduğunu tutmuyor. Ayrıntı: `codex.md/Tester.md`.
- **Bir sonraki tur odağı:** TST-0003 (P1, gece rutini null köylü) düzeltmesini doğrula; TST-0002'nin `[KEY_NOT_FOUND]` gösterdiği ekranı görüntüyle kesinleştir; TST-0001'in oynanış etkisi (`sayi()` çağrıları); pencereli elle CHR ikna-fail doğrulaması; düşük kabul ile zafer/denge eğrisi.
