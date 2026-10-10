# Oyun Gelişim Raporu (Tester)

Her tur/gün sonunda en üste bir giriş. Kalıp: `docs/tester/TESTER_REHBERI.md` §5. Sayılar ölçülerek yazılır.

<!-- En yeni giriş buraya -->

## 2026-10-11 · Tur 1 (eğitim) · commit 5c9a5b1 → 5c9a5b1 (tur boyunca değişmedi)
- **Sağlık:** ölçülmedi (eğitim turu — sanity ve otomatik koşu çalıştırılmadı)
- **Bu turda giren:** yok (kod değişmedi; yalnız rehber, skill, ROADMAP panosu ve OYNA.md okundu)
- **İyileşen:** ölçülmedi
- **Kötüleşen / regresyon:** ölçülmedi
- **Oynanış hissi:** ölçülmedi (elle oynama yapılmadı)
- **Denge eğrisi:** ölçülmedi
- **Açık bulgu:** P0 0 · P1 0 · P2 0 · P3 0 (bu turda TST numarası açılmadı; bulgu listesi boş)
- **Kaynak koddan izlenen:** BUG-0013 — kayıttan **Devam** köy yerine kapıyı açıyor. Kök neden `src/arayuz/ana.gd` `devam_et()` (satır 68–74): kayıt yüklendikten sonra koşulsuz `_kapiya_git()` çağrılıyor; `Oturum.kaydet()` (satır 725–747) kaydın hangi fazda olduğunu tutmuyor. Ayrıntı: `codex.md/Tester.md`.
- **Bir sonraki tur odağı:** tam sanity (beklenti ~320 PASS) + en az bir elle oyun; BUG-0013 adımlarını oyunda gerçekten deneyip doğrulamak/yalanlamak, sonuca göre TST numarasıyla bulgu açmak; farklı tohum/kabul oranıyla en az 3 otomatik koşu.
