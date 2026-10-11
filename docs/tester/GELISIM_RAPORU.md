# Oyun Gelişim Raporu (Tester)

Her tur/gün sonunda en üste bir giriş. Kalıp: `docs/tester/TESTER_REHBERI.md` §5. Sayılar ölçülerek yazılır.

<!-- En yeni giriş buraya -->

## 2026-10-11 · Tur 3 · commit 34d36f7 (kod: 254202d)
- **Sağlık:** Etkin sanity **320/320 PASS** (harness "315 failed" = yalnız ortam sertifika hatası; gerçek `KALDI` 0, `SCRIPT ERROR` 0). BÖLÜM 6 (tüccar/pazar/sipariş) 9 kvr birim testi **GEÇTİ**. 20-gece duman: GEÇTİ, bellek 68.9→69.6 MB (sızıntı yok).
- **Bu turda doğrulanan:** BUG-0016 (CHR kilit çıkışı) — birim testi GEÇTİ + post-fix oyunlarda KILIT yok → **DOĞRULANDI**. TST-0003 (gece rutini null köylü, BUG-0017/254202d) — post-fix oyun 113–116'da `is_yeri` hatası 0 → **DOĞRULANDI**.
- **Bu turda giren:** yeni kod yok (tur başında güncellendi; son kod commit'i 254202d).
- **İyileşen:** Gece rutini hata spam'i ve kapı softlock'u bitti; oyunlar hatasız ilerliyor.
- **Kötüleşen / regresyon:** Kod regresyonu yok. Ama **denge çökük**: 22/22 gözlem yenilgi, zafer 0.
- **Oynanış hissi:** Akt-1 (g0–g6) sağlıklı — huzur 55–84, kaynaklar dengeli, rapor metinleri okunaklı (ekran görüntüsü `04_kart.png`: kaynak şeridi, "1. gecenin raporu", bina menüsü doğru). Akt-2'de **gıda g6–g8'de 0** oluyor ve huzur tek haneliye düşüyor; oyuncu için "neden birden çöküyorum?" hissi var.
- **Denge eğrisi:** 2. perde huzur çöküşü **kıtlık kaynaklı** (`aclik_moral=15`/gece). Kök neden: **odun üretilemiyor** (EKO-02 sonrası `hizarhane` tomruk ister, `odunluk` hiç kurulmuyor) → köy 5 yapıda donuyor → tarla eklenemiyor → gıda 0 → isyan/tekfur. Ortalama son gün ≈ 11; en sık son İsyan (6), Tekfur (4), azil (2). Ayrıntı: TST-0004, ONR-003, ONR-004.
- **Açık bulgu:** P0 0 · P1 1 (TST-0004 — denge) · P2 2 (TST-0001, TST-0002) · P3 1 (TST-0005 — yetim .import import gurultusu). TST-0003 DOĞRULANDI.
- **Bir sonraki tur odağı:** ONR-004 uygulanınca (otomatik oyuncu `odunluk` kursun) zafer oranını yeniden ölç; TST-0002'nin `[KEY_NOT_FOUND]` ekranını görüntüyle kesinleştir; TST-0001 tekrarını ara; pencereli elle CHR ikna-fail ekran görüntüsü.


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
