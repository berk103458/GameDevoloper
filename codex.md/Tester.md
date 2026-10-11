# Tester günlüğü

Ben **Tester**: Kapı Muhafızı'nın tam zamanlı test ajanıyım. Oyunu açar, oynar, sürekli test ederim; bulgu, değişiklik önerisi ve gelişim raporlarımı Claude'a veririm. Kod değiştirmem. Eğitimim ve kurallarım: `docs/tester/TESTER_REHBERI.md` (Claude yazdı, Claude yönetir).

## Durum
- Göreve başlama: 11 Ekim 2026 — **Tur 1 (eğitim)** tamamlandı.
- Çalışma kopyası: `C:\Users\ds\Documents\Codex\tester-ajan` (git worktree, dal `claude/festive-volta-li1sfm`, commit `5c9a5b1`).
- Eğitim turu kuralı: kod (`src/`, `data/`, `tests/`, `tools/`, `ROADMAP.md`) değiştirilmedi; commit/push yapılmadı. Yalnız `docs/tester/` ve bu günlük yazıldı.
- Güncel: **Tur 13** tamamlandı (11 Ekim 2026, commit `ee474a3`; yeni kod yok). Rapor: `docs/tester/turlar/TUR-013.md`. **Tam sanity 330 PASS / 0 FAIL -> `Sanity: 0 failed`.** TST-0011/TST-0010/BUG-0016/BUG-0017 DOĞRULANDI. Yeni bulgu 1 (TST-0012).



## Tur 13 — 11 Ekim 2026 (commit ee474a3; yeni kod yok)

### Ne yaptım
- **TAM sanity (§3.5):** **330 PASS / 0 FAIL / 330 log -> `Sanity: 0 failed`**; log taraması `SCRIPT ERROR|Parse Error|Failed to load script|KALDI` = 0; yok sayılan tek satır sertifika deposu (325). **TST-0011 DOĞRULANDI** (elle ayıklama gerekmiyor).
- **TST-0010 DOĞRULANDI (tekrar):** `perde_gecisi_test`+`nihai_son_test`+`nihai_son_kontrol` PASS; `oyun_ayarlari.gd:39 = 12`, `oyun.tres:24 = 12`. **BUG-0016 DOĞRULANDI:** `chr_kilit_cikisi_test` PASS; `KILIT`/`SOHBET_KILIDI` yalnız 106/107/108. **BUG-0017/TST-0003 DOĞRULANDI:** `is_yeri` yalnız oyun_112.
- **Kendi otomatik koşularım:** 501 (0,2) Azil g5 · 502 (0,6) Tekfur g18 · 503 (0,95) Tekfur g18 — 0 hata, donma yok.
- **Stratejist oyuncu (insan stratejisi, `work/tester/tur13/stratejist.gd`):** odunluk+hızarhane+sur+kışla kurar; **sur=1** gün 7'de kuruldu, Tekfur tutuldu, ama **gıda gün 7'de 0 -> İsyan g16**. Yani savunma yetmiyor, gıda/su öldürüyor.
- **GÖRÜNÜR `[KEY_NOT_FOUND]` yakalandı:** gece raporunda `Üretim: +1 [KEY_NOT_FOUND] koy.kaynak.tomruk, +5 Gıda` -> **TST-0012 (P2)**; **TST-0002 P2'ye yükseltildi** (eksik anahtar 7).
- **Rastgele ROADMAP bölümü regresyonu:** `random.seed(1307)` -> **BÖLÜM 11 (KRI-01…15)**: 13 akış sahnesi **13/13 GEÇTİ**, regresyon yok.
- **Türkçe dilim 10 (1351–1500):** temiz; c3≡c5 çift metni 30/30 CHR'de sürüyor; `cebe yamağı` dönem terimi (hata değil). Kaldığım satır **1500**.
- **Denge:** 100 kayıt / 94 tamamlanan; zafer **2 (%2,1)**; Tekfur 42 · İsyan 26 · Azil 24; 84/84 perde-2 `sur=0, odun=0`; huzur 44→17,2 (gece −3,48); **28 oyun tam g18'de Tekfur**; azil yalnız g5/g10/g15.

### Yeni/kapatılan
- Yeni bulgu: **1 (TST-0012, P2)**. Yeni öneri: **1 (ONR-015, Yüksek)**; ONR-004/005/010/013'e tur 13 sayıları eklendi. Doğrulanan: TST-0011, TST-0010, BUG-0016, BUG-0017/TST-0003. Yeniden açılan: yok.
- Açık: P0 0 · P1 0 · P2 4 (TST-0002/0004/0007/0012) · P3 5 (TST-0001/0005/0006/0008/0009) = toplam 9.

### Sonraki tur odağı
- ONR-010 zafer-gecesi çakışması; ONR-006/013/015 gıda-su dengesi; TST-0007/0008/0009 asset öncelik listesi; Türkçe dilim 11 (1501–1650).

## Tur 12 — 11 Ekim 2026 (commit a636768; fix(BUG-18))

### Ne yaptım
- **a636768 / BUG-18 DOĞRULANDI:** Doğal tehditler (pusucu/çete/casus/sabotaj/baskın) veri ayarlı `tehdit_baslangic_gunu=14` kapısına bağlı; `Oturum.gun` tamamlanan gün okunur. Bağımsız **14 kenar grubu** geçti (sınır 12/13 kapalı 14/15 açık · gun 0/7/13 tehdit 0 · gun15 tehdit>0 · legacy gun25 geri sarılmaz · JSON ayarı 0/−3/999 · `sec` sıfır havuz RNG harcamaz · `aralik` üst sınır · gun13 baskın yok+sönüm sürer · gun14 baskın olur · gun13 sabotaj makbuz yok · debug takvimi ilerletmez · DEBUG_BASKIN kayda yazılmaz · ilk gün ulak+heyet engellenmez · gun13→14 Moğol ilerler · profil süzgeci). Kalfa'nın `tehdit_takvimi_test` sanity içinde GEÇTİ.
- **TAM sanity (§3.5):** **330 PASS / 0 FAIL / 330 log -> `Sanity: 0 failed`**; log taraması `SCRIPT ERROR|Parse Error|Failed to load script|KALDI` = 0; yok sayılan tek satır sertifika deposu (325). **TST-0011 DOĞRULANDI** (elle ayıklama gerekmiyor).
- **TST-0010 DOĞRULANDI (tekrar):** `perde_gecisi_test` + `nihai_son_test` + `nihai_son_kontrol` PASS; `oyun_ayarlari.gd:39 = 12`, `oyun.tres:24 = 12`.
- **BUG-0016 DOĞRULANDI (tekrar):** `chr_kilit_cikisi_test` GEÇTİ; `SOHBET_KILIDI`/`KILIT` yalnız 106/107/108 (fix öncesi), 109–192'de 0. **BUG-0017/TST-0003 DOĞRULANDI (tekrar):** `is_yeri` yalnız oyun_112 (511, fix öncesi); 113–192'de 0.
- **7/24:** **92 kayıt, tamamlanan 86**; Tekfur 37 · azil 24 (hepsi teftiş geceleri g5/g10/g15) · İsyan 23 · **zafer 2/86 = %2,3**; ort. son gün **12,92** (medyan 14). **Perde-2: 75/75 oyun `sur=0`, yapı ≤5, odun gün 1,1'de 0**; ilk Tekfur gücü 5,2 / savunma 2,9. Donma 0; yeni oyunlar (186–192) hata=0.
- **Karakter muayenesi (6 model, regresyon):** TST-0007/0008 değişmedi — chr_011 pelerin dev torba (0,69/0,61), chr_009/chr_021 ayak 0,09 m havada, aydogdu yay-bacak. yusuf 1,17 m = kasıtlı çocuk.
- **Çevre (13.2):** köy inşa görünümünde **beyaz küre çadır (TST-0009)** ana bakış alanında net; gece kapı sahnesi sağlam.
- **Türkçe dilim 9 (1201–1350):** temiz (chr_018–024 sohbet); c3≡c5 çift metni sürüyor -> `[SORU]`. Kaldığım satır **1350**.

### Yeni/kapatılan
- Yeni bulgu: **0**. Yeni öneri: **0** (mevcut ONR-004/005/006/007'ye tur 12 sayıları eklendi). Doğrulanan: **BUG-18**, TST-0011, TST-0010, BUG-0016, BUG-0017/TST-0003. Yeniden açılan: yok.
- Açık: P0 0 · P1 0 · P2 3 (TST-0002/0004/0007) · P3 5 (TST-0001/0005/0006/0008/0009) = toplam 8.
- Ek düzeltme: `DEGISIKLIK_ONERILERI.md` ONR-007 içinde eski bir metin bozulması (`rusvet` -> `usvet` + satır kırılması) onarıldı.

### Sonraki tur odağı
- Zafer ulaşılabilirliği (ONR-004 otomatik oyuncu savunma kursun / ONR-005 / ONR-010); Türkçe dilim 10 (1351–1500); TST-0007/0008/0009 asset öncelik listesi.

## Tur 11 — 11 Ekim 2026 (commit ed34d70; fix(BUG-17))

### Ne yaptım
- **ed34d70 / BUG-17 DOĞRULANDI:** Fısıltı pusulası yalnız **mevcut hazır bina** ve **yaşayan kişi** kaydını okur. Bağımsız 8 kenar senaryosu geçti (binasız 30 gece 0 · inşa halindeki bina · katalog dışı tür · çocuk/zindan/kervan dışlaması · sabah yıkılan bina · `{yer}` artığı yok). Kalfa'nın `fisilti_yer_test` sanity içinde GEÇTİ. İkincil görsel: kart "dün **ambar** tarafındaydı".
- **TAM sanity (§3.5):** **329 PASS / 0 FAIL / 329 log -> `Sanity: 0 failed`**; log taraması `SCRIPT ERROR|Parse Error|Failed to load script|KALDI` = 0; yok sayılan tek satır sertifika deposu (324). **TST-0011 DOĞRULANDI** (elle ayıklama gerekmiyor).
- **TST-0010 DOĞRULANDI (tekrar):** `perde_gecisi_test` + `nihai_son_test` + `nihai_son_kontrol` PASS; `oyun_ayarlari.gd:39 = 12`, `oyun.tres perde2_hedef_gece = 12`.
- **BUG-0016 DOĞRULANDI (tekrar):** `chr_kilit_cikisi_test` GEÇTİ; `SOHBET_KILIDI`/`KILIT` yalnız 106/107/108 (fix öncesi), 109–185'te 0. **BUG-0017/TST-0003 DOĞRULANDI (tekrar):** `is_yeri` yalnız oyun_112; sonrası 0.
- **7/24:** **85 kayıt, tamamlanan 79**; Tekfur 34 · azil 22 · İsyan 21 · **zafer 2/79 = %2,5**; ort. son gün **12,97** (medyan 14). Donma 0; son turdan beri yeni DONMA/KILIT/HATA yok.
- **Karakter muayenesi (6 model, regresyon):** TST-0007/0008 değişmedi — chr_011 pelerin dev torba (0,69/0,61), chr_009/chr_021 ayak 0,09 m havada, aydogdu yay-bacak. yusuf 1,17 m = kasıtlı çocuk.
- **Türkçe dilim 8 (1051–1200):** temiz; `chr_012` "Hatice kızı" = patronimik, çelişki değil. c3≡c5 çift metni sürüyor -> `[SORU]`. Kaldığım satır **1200**.

### Yeni/kapatılan
- Yeni bulgu: **0**. Yeni öneri: **0**. Doğrulanan: **BUG-17**, TST-0011, TST-0010, BUG-0016, BUG-0017/TST-0003. Yeniden açılan: yok.
- Açık: P0 0 · P1 0 · P2 3 (TST-0002/0004/0007) · P3 5 (TST-0001/0005/0006/0008/0009) = toplam 8.

### Sonraki tur odağı
- Zafer ulaşılabilirliği + 2. perde savunma ölümcüllüğü (ONR-005/006/010 — pencereli zafer denemesi); Türkçe dilim 9 (1201–1350); TST-0007/0008 kalan muayene sayfaları; TST-0002 görünür `[KEY_NOT_FOUND]` üretme denemesi.

## Tur 10 — 11 Ekim 2026 (commit ffe2e4b; yeni oyun kodu yok)

### Ne yaptım
- **ffe2e4b denetimi (betikle):** ROADMAP_2 **1064 madde**, **kopya kimlik 0**, bölüm 19–21 = **84**, diff'te **50 yeni "Ek şart"**, SİL kimliği hedefleyen içerik atfı **0**. Tek not: 16 bölüm başındaki "Yeni maddeler X … Y" aralık etiketinin ucu silinmiş kimlik (ör. BUG-26/BUG-105) -> **ONR-014 (Düşük, doküman)**.
- **Tam sanity (§3.5):** **328 PASS / 0 FAIL / 328 log -> `Sanity: 0 failed`**; `SCRIPT ERROR|Parse Error|Failed to load|KALDI` = 0. **TST-0011 DOĞRULANDI.**
- **TST-0010 DOĞRULANDI (tekrar):** `perde_gecisi_test` + `nihai_son_test` + `nihai_son_kontrol` PASS; `oyun_ayarlari.gd:39 = 12`, `oyun.tres:24 = 12`.
- **BUG-0016 DOĞRULANDI (tekrar):** `chr_kilit_cikisi_test` GEÇTİ; `SOHBET_KILIDI` yalnız 106/107/108 (fix öncesi), 109–178'de 0. **BUG-0017/TST-0003 DOĞRULANDI (tekrar):** `is_yeri` yalnız oyun_112 (511), sonrası 0.
- **7/24 (tur 9 sonrası):** **74 tamamlanan** oyun; Tekfur 30 · İsyan 21 · Azil 21 · **zafer 2/74 = %2,7**; ort. son gün 12,89; son günü **g18 olan 17 oyunun 17'si Tekfur**. 2. perdeye giren **64/64 oyun `sur=0 + odun=0`**; huzur eğimi **−4,18/gece**. HATA/DONMA/KILIT yeni 0.
- **Karakter muayenesi (6 model, regresyon):** TST-0007/0008 değişmedi — chr_011 pelerin dev torba (el_aci 0,69), chr_009/chr_021 ayak 0,09 m havada, aydogdu yay-bacak. yusuf 1,17 m = kasıtlı çocuk (ONR-011 yanlış pozitif).
- **Türkçe dilim 7 (901–1050):** temiz; c3≡c5 çift metni (30 karakter) ve TST-0006 çift boşluğu (2 satır) sürüyor. Kaldığım satır **1050**.

### Yeni/kapatılan
- Yeni bulgu: **0**. Yeni öneri: **ONR-014 (Düşük, doküman)**. Doğrulanan: TST-0011, TST-0010, BUG-0016, BUG-0017/TST-0003. Yeniden açılan: yok.
- Açık: P0 0 · P1 0 · P2 3 (TST-0002/0004/0007) · P3 5 (TST-0001/0005/0006/0008/0009) = toplam 8. (TST-0010/0011 DOĞRULANDI.)

### Sonraki tur odağı
- Pencereli zafer denemesi + "bu geceyi atlatırsan tutundun" uyarısı (ONR-010/005/006); sancak teftişi uyarı yüzeyi (ONR-007); Türkçe dilim 8 (1051–1200); TST-0002 için görünür `[KEY_NOT_FOUND]` üretme denemesi; ONR-004 uygulanınca `odunluk` ile zafer ölçümü.


## Tur 9 — 11 Ekim 2026 (commit 6202f96; TST-0011 düzeltmesi)

### Ne yaptım
- **Tam sanity (§3.5):** Sanity: 0 failed — **327 PASS / 0 FAIL / 329 log**. Tur 3–8'deki "322 failed" yanlış negatifi bitti. Import exit 0; 102 ERROR = TST-0005 yetim .import.
- **TST-0011 DOĞRULANDI:** cert-satırı istisnası (	ools/sanity_check.py:18-20, 
un() satır 62) yalnız o satırı yok sayıyor. 13 kenar senaryosu (CRLF'li, sonda boşluklu, iki kez, cert+gerçek ERROR, aynı satırda cert+gerçek hata, noktasız benzer satır, gerçek hata önce, SCRIPT ERROR/KALDI/Parse Error) → 9/9 doğru. Kanıt: `work/tester/tur9/tst0011_kenar*.log`.
- **TST-0010 DOĞRULANDI (tekrar):** kod varsayılanı 12 / .tres 12; perde_gecisi_test, 
ihai_son_test, oto 
ihai_son_kontrol GEÇTİ.
- **7/24 (tur 8 sonrası, 170–173):** 66 tamamlanan oyun; **zafer 2/66 = %3,0**; Tekfur 28 · İsyan 18 · Azil 18 · Uç Tutundu 1 · Beyin Uç Köyü 1; ort. son gün 12,56; KILIT/DONMA yeni 0.
- **DENGE:** (a) 58/58 oyun 2. perdeye sur=0+odun=0 ile giriyor; huzur **−4,19/gece**, sonu 21,9. (b) ağalık ort. gün 6 → 12. perde gecesi = 19. gece; **g19'da biten 15 oyunun 15'i Tekfur** → zafer "ağalığı gün 5'te aç" şansına bağlı (ONR-010). (c) 18 azilin tamamı teftiş gecelerinde (6/11/16); kök rüşvet ağırlığı (4 rüşvet = yozlaşma 20) + dolu kişisel kasa; ekonomi değil (ONR-007).
- **TST-0002 derinleşti:** 6 eksik anahtarın uyarısı her oyunda sürüyor; çağrı yığını koy_ekrani.gd:186 → yapi_karti.gd:38 → ad() zinciri → guvenli_metin.gd:225. **Görünür etiketler doğru** (TAŞ EV kartı, Tomruk/Buğday/Un/Kireç/Harç, gece raporu) → uyarı çoğunlukla yanlış alarm (eager varsayılan); görünür [KEY_NOT_FOUND] yakalanamadı → P2→P3 önerisi. Kanıt: `work/tester/tur9/metin_probe.log`, `koy_insa.png`, `foto_175/05_koy_perde2.png`.
- **Türkçe dilim 6 (satır 751–900):** temiz; sonraki dilim **901–1050**. Ek gözlem: sohbet.<ad>.c3 ≡ c5 (30/40) → Claude'a `[SORU]` (kasıtlı mı?).
- **Rastgele bölüm (BÖLÜM 9, ODA):** 14 akış sahnesi kendi elimle GEÇTİ; BÖLÜM 6 (TUC) da sanity'de 12 akış + 13 birim PASS.
- **Kendi koşularım:** 901 (0,30) İsyan g14 · 902 (0,70) Azil g11 · 903 (0,95) Tekfur g13 — SCRIPT ERROR/KILIT/NaN/eksi stok 0.
- **Kural uyumu:** kod dosyalarına dokunulmadı; hiçbir Godot işlemi adıyla kapatılmadı (7/24 döngü kesintisiz); açılan görsel 4 (hepsi önce küçültüldü); gh kurulu olmadığı için Ajan Masası okunamadı → not düşüldü.

### Yeni/kapatılan
- Yeni bulgu: **0**. Kapanan: **TST-0011 DOĞRULANDI** (+ TST-0010 tekrar). Yeniden açılan: yok.
- Yeni öneri: yok (ONR-007 ve ONR-010 güçlendirildi; ONR-005/006/013 tur 9 sayılarıyla güncellendi).
- Açık: P0 0 · P1 0 · P2 3 (TST-0002, 0004, 0007) · P3 5.

### Sonraki tur odağı
- ONR-010 için elle/pencereli zafer denemesi + "bu geceyi atlatırsan tutundun" uyarısı var mı; teftiş takvimi görünürlüğü (ONR-007); Türkçe dilim 7 (901–1050); karakter muayenesi tekrarı; TST-0002 görünür çıktı üretme denemesi.
## Tur 8 — 11 Ekim 2026 (commit d2f3b65; yeni kod commit'i yok)

### Ne yaptım
- **Sanity:** etkin **329 log / 0 KALDI / 0 SCRIPT ERROR / 0 Parse Error** (harness "322 failed" = ortam sertifika hatası → ilk kez **TST-0011** olarak kayda alındı). Import exit 0; 102 ERROR = TST-0005 yetim `.import`.
- **TST-0010 DOĞRULANDI (tekrar):** `oyun_ayarlari.gd:39`=12, `oyun.tres:24`=12, perde_gecisi/koy_yonetimi yorumları 12; `perde_gecisi_test` + `nihai_son_test` + oto `nihai_son_kontrol` GEÇTİ.
- **BUG-0016 DOĞRULANDI:** `chr_kilit_cikisi_test` GEÇTİ; KILIT toplam 3 (106/107/108, hepsi 5396fae öncesi); `SOHBET_KILIDI` 109+ = 0.
- **BUG-0017/TST-0003 DOĞRULANDI:** `is_yeri` yalnız oyun_112 (511, 254202d öncesi); 113+ = 0.
- **7/24 (tur 7 sonrası, 147–164):** 62 log / 56 tamamlanan; **zafer 2/56 = %3,6**; Tekfur 23 · İsyan 17 · Azil 14 · Uç Tutundu 1 · Beyin Uç Köyü 1; ort. son gün 13,98 (en sık g19). HATA/DONMA/KILIT yeni kayıt 0.
- **DENGE (Claude a/b/c):** (a) 2. perde huzur **52,9 → 21,8**, ortalama −4,03/gece; kök gıda (üretim +4…+6 vs tüketim 18–23) çünkü tarla kurulamıyor (odun 0). (b) 50/50 oyun 2. perdeye `sur=0, odun=0, yapı=5` ile giriyor; savunma 1–4 vs Tekfur 4–6; **23 Tekfur sonunun 14'ü tam g19** (12–13 gece dayanıp zafer gelmiyor → ONR-010). (c) azil ekonomi değil teftiş: 14 azilin 6'sı g6'da ve köy sağlıklı; 4 rüşvet → yozlaşma 20 → g6 teftişi %50.
- **YENİ su bulgusu:** 45/45 oyunda su eksik>0 (ihtiyaç 23–58, kuyu sabit 20/gün; yaz ×2) → **ONR-013**.
- **Türkçe dilim 5** (satır 601–750): temiz; kaldığım satır **750**. TST-0006 ve TST-0002 hâlâ AÇIK (tur 8 kanıtlandı).
- **Rastgele bölüm (BÖLÜM 12, SYS-01…20):** 11 birim + 7 akış GEÇTİ; regresyon yok (kayit_gocu, atomik_kayit, ses, tansiyon_muzigi, guvenli_metin, perde_gecisi, nihai_son, goc_yolu, diyalog_sirasi, acilis_bagimlilik, 20-night-smoke).
- **Kendi koşularım:** oto 901 (0,30) Azil g11 · 902 (0,70) İsyan g18 · 903 (0,95) Tekfur g13 · pencereli 904 (0,50) **Tekfur g19** — dördü de SCRIPT/KILIT/ASIMI 0.
- **Oyuncu gözü:** perde 2 köy ekranında Odun 1 → üç barınmanın üçü de "Malzeme yetersiz" (TST-0004 tuzağı); "Geceye geç" düşük kontrast (**ONR-012 doğrulandı**); mevsim etiketi `Yaz · 1/7 · Açık` doğru (yaz ×2 su çarpanı 2. perdeye denk geliyor).

### Yeni/kapatılan
- Yeni: **TST-0011** (P2, test aracı yanlış negatif), **ONR-013** (Yüksek, [DENGE] su).
- Doğrulanan: **TST-0010**, **BUG-0016**, **BUG-0017/TST-0003**. Yeniden açılan: yok.
- Güçlendirilen: ONR-004/005/006/007/010 (sayısal kanıt), ONR-012 (görsel).
- Açık: P0 0 · P1 0 · P2 4 (TST-0002/0004/0007/0011) · P3 5 (TST-0001/0005/0006/0008/0009).

### Sonraki tur odağı
- ONR-010 zafer/akın çakışması (g19) derinleştirme; ONR-013 su doğrulama; Türkçe dilim 6 (751–900); rastgele bölüm (BÖLÜM 7/8/9/10/11'den biri); TST-0002 `[KEY_NOT_FOUND]` ekran görüntüsü.

## Tur 7 — 11 Ekim 2026 (commit 8acb352)

### Ne yaptım
- **Sanity:** etkin **327 log / 0 KALDI / 0 SCRIPT ERROR** (harness "322 failed" = ortam sertifika yanlış negatifi). Import exit 0, 0 SCRIPT/Parse; 102 ERROR = TST-0005 yetim `.import`.
- **8acb352 doğrulaması (TST-0010):** `src/veri/oyun_ayarlari.gd:39` = 12; `.tres:24` = 12; yeni `OyunAyarlari` varsayılanı = 12 → tek değer, `.tres` okunamazsa sessizce 10'a düşmez. `perde_gecisi_test`, `nihai_son_test`, oto `nihai_son_kontrol` GEÇTİ → **TST-0010 DOĞRULANDI**.
- **BUG-0016 DOĞRULANDI:** `chr_kilit_cikisi_test` GEÇTİ; KILIT/`SOHBET_KILIDI` yalnız 106/107/108 (fix öncesi); 109–149'da 0. Tasarım sorusu (kalıcı kapanma açıklanmıyor) **ONR-001**'e kod kanıtıyla işlendi (`chr_sorgusu.gd:69-71`).
- **TST-0004 sadeleştirildi:** ana kayıt başlığı/önceliği düzeltildi (P1→P2, strateji tuzağı S3, BUG-0018); ONR-003/004 kopya değil, ona bağlı.
- **TST-0009 kimlik çözüldü:** "beyaz küre" = **dokusuz çadır modeli** (`cadir.glb`); `assets/model/**` altında hiç `.jpg` yok.
- **7/24 (145–149):** hata 0, DONMA 0. 145 Azil g16 · 146 Azil g6 · 147/148/149 → **3/3 g19 Tekfur** (ONR-010 sürüyor). 43 tamamlanan: Tekfur 19 · İsyan 11 · Azil 11 · **Zafer 2/43 (%4,7)**; ort. son gün 13,12. 2. perdeye giren 36/36 `sur=0`.
- **Türkçe dilim 4** (satır 451–600): temiz. Kaldığım satır **600**.
- **Rastgele bölüm (BÖLÜM 6):** 16 akış + 13 birim GEÇTİ; regresyon yok.
- **Kendi koşularım:** oto 802 (0.9) İsyan g14, 803 (0.35) Azil g16. Persona2 (odun zinciri + sur) 611 → tekfur g13, 612 → tekfur g7. Açılış 20 odun/5 taş doğrulandı.

### Yeni/kapatılan
- Yeni: **ONR-012 (Düşük, [ARAYUZ] "Geceye geç" kontrast, doğrulanmadı)**.
- Doğrulanan: **TST-0010**, **BUG-0016**. Yeniden açılan: yok.
- Açık: P0 0 · P1 0 · P2 3 (TST-0002/0004/0007) · P3 5 (TST-0001/0005/0006/0008/0009).

### Sonraki tur odağı
- Türkçe dilim 5 (601–750); TST-0002 `[KEY_NOT_FOUND]` ekran görüntüsü; TST-0005/TST-0009 doku eksikliği; ONR-005/006/010 uygulanınca zafer oranını yeniden ölç.

## Tur 6 — 11 Ekim 2026 (commit 6ce5f62; yeni kod commit'i yok)

### Ne yaptım
- **Sanity:** etkin **327 log / 0 KALDI / 321 GEÇTİ / 0 SCRIPT ERROR** (harness "322 failed" = ortam sertifika yanlış negatifi). Import 0 SCRIPT/Parse.
- **7/24 oyunlar (101–144):** 44 kayıt, 38 tamamlanan → Tekfur 16 · İsyan 11 · Azil 9 · **Zafer 2/38 (%5,3)**; ort. son gün 12,89. Tur 5 sonrası 8 oyun (136–144), DONMA/HATA 0.
- **DENGE (Claude soruları):** (a) 2. perde huzur eğrisi gıda g6–8'de 0 → huzur −10…−19/gece. (b) Zafer 2/38; **kritik:** 36/36 oyun 2. perdeye `sur=0, odun=0` ile giriyor, 9 oyun tam **g19 (zafer gecesi)** öldü → kod sırası: akın, zafer denetiminden önce çözülüyor (**ONR-010**). Persona 3/3 g7 ölüm; sur ödeyen persona g13'e dek. (c) erken azil 9/38, dördü g6 = rüşvet yozlaşması + RNG.
- **BUG-0016 DOĞRULANDI:** `chr_kilit_cikisi_test` GEÇTİ; KILIT yalnız 106/107/108 (fix öncesi); 109–144'te 0.
- **BUG-0017/TST-0003 DOĞRULANDI:** `is_yeri` hatası yalnız oyun_112 (511, fix öncesi); sonrasında 0.
- **Karakter muayenesi (44 model):** Aydoğdu yayı, chr_009/021 ayak ~9 cm, chr_011 pelerin → doğrulandı; **yusuf 1.17 m = kasıtlı çocuk** (Claude gözlemi çürütüldü) → ONR-011.
- **Türkçe dilim 3** (satır 301–450): çift boşluk 0, KEY_NOT_FOUND 0. Kaldığım satır **450**.
- **Rastgele bölüm (BÖLÜM 11):** 13 akış + 18 birim testi GEÇTİ; regresyon yok.
- **Kendi koşularım:** oto 701 (0.9) g19 Tekfur (zafer gecesi ölümü), 702 (0.35) g6 azil.

### Yeni/kapatılan
- Yeni: **TST-0010 (P3, perde2 hedef 10 vs 12)**, **ONR-010 (Yüksek)**, **ONR-011 (Düşük)**. ONR-005/006/007 tur 6 sayılarıyla güncellendi.
- Doğrulanan: BUG-0016, BUG-0017/TST-0003, TST-0007/0008. Yeniden açılan: yok.
- Açık: P0 0 · P1 0 · P2 3 (TST-0001/0002/0004) · P3 5 (TST-0005/0006/0007/0008/0009/0010).

### Sonraki tur odağı
- ONR-005/006/010 uygulanınca zafer oranını yeniden ölç; ONR-004 (`odunluk`) sonrası denge.
- Türkçe dilim 4 (451+); TST-0002 `[KEY_NOT_FOUND]` ekran görüntüsü; TST-0009 beyaz küre kimliği.

## Tur 5 — 11 Ekim 2026 (commit 39847ea)

### Ne yaptım
- **Açılış stoğu ÖLÇÜMÜ:** `work/tester/tur5/olcum.gd` → gün 0: akçe 10, gıda 30, **odun 20, taş 5**, kereste 4, alet 2. BUG-0018 düzeltmesi (20 odun/5 taş) doğrulandı; tur 3'ün "≈9 odun/kesin kilit" iddiası çürütüldü → **strateji tuzağı (S3)**.
- **TST-0004 güncellendi** (P1→P2, yeni başlık); ONR-003/ONR-004 kopya kontrolü yapıldı, TST-0004 ana kayda bağlandı.
- **Zafer bulundu:** oyun **124 = "Uç Tutundu" (zafer)**. Tur 4'ün "zafer 0"u eksikti. 106–135: **zafer 1/29 (%3,4)**, ortalama son gün 13,4.
- **Persona oynanışı** (bilinçli "önce odun zinciri"): tohum 201/202/203'te üçü de **gece 7'de Tekfur** ile öldü; gıda gece 5'te 0.
- **Otomatik oyuncu** (headless): tohum 302/kabul 0.95 → "güçleri 4, savunman 2" gece 7 ölümü; tohum 301/kabul 0.2 → gece 13 Tekfur.
- **Regresyon (BÖLÜM 2):** 12 birim + 5 akış testi GEÇTİ; `chr_kilit_cikisi_test` GEÇTİ. Regresyon yok.
- **Çevre muayenesi (§13.2):** köy sahnesinde **kocaman beyaz küre** (yeni bulgu TST-0009); kapı sahnesinde kış ortamı + "Yaz" etiketi uyuşmazlığı.
- **Türkçe dilim 2** (satır 151–300): yazım hatası yok; "Uç tutundu" dizi çakışması notu. Kaldığım satır **300**.
- **Sanity:** import temiz; harness FAIL'leri ortam sertifika hatası (yanlış negatif) — 327 logun 0'ında "KALDI".

### Yeni/kapatılan
- Yeni: **TST-0009 (P3, [CEVRE])**, **ONR-009 ([TASARIM]/[DENGE] zafer koşulu)**.
- Doğrulanan: BUG-0016, BUG-0017, BUG-0018 (ölçüm). Yeniden açılan: yok.
- Açık: P0 0 · P1 0 · P2 3 (TST-0001/0002/0004) · P3 3 (TST-0005/0006/0009).

### Sonraki tur odağı
- ONR-004 (araç `odunluk` kursun) ve ONR-005/ONR-009 uygulanınca **zafer oranını yeniden ölç**.
- TST-0002 `[KEY_NOT_FOUND]` ekranını görüntüyle kesinleştir; TST-0009 beyaz kürenin kimliği.
- Türkçe dilim 3 (satır 301'den).

## Tur 1 (eğitim) — 11 Ekim 2026

### Oyunu 5 cümlede
1. **Kapı Muhafızı**, 13. yüzyıl Anadolu uç beyliğinde bir köyün kapısında nöbet tuttuğun bir yönetim ve ikilem oyunudur.
2. Gündüz kapıda gelen kişiyi en fazla **iki soruyla** sorgular, portre ve heybedeki ipuçlarına bakıp **kabul / ret / rüşvet al / kışlaya yaz** kararını verirsin.
3. Gece köyde bina kurup köylülere iş verirsin; ekonomi (akçe, ambar/erzak), dört bar (**Halk, Soylular, Tüccarlar, Ordu**), üç rüşvet kesesi ve gece sayacı döner.
4. Nüfus **18**e varınca ikinci perde başlar ve Tekfur saldırıları gelir; **12 gece** dayanırsan zafer gelir, bir bar kırılırsa erken **kırılma sonu** olur.
5. Sonlar köyün durumuna göre beş nihai son (Tekfur Haraççısı / Ertuğrul Obası / Beyin Uç Köyü / Ahi Kasabası / Uç Tutundu) ve dört kırılma sonu olarak belirlenir.

### Test araçları (rehber §3)
- **Elle oynama** (pencereli Godot 4.7.2): fare/ok + Enter, kararda 1–4 ve onay, Esc seçimi bırakır, boşta Esc/P duraklatma.
- **Admin paneli** (F1 ya da `~`): kapı atlama, zaman hızı, kaynak enjektörü, NPC çağırma, bayrak denetçisi, bina manipülatörü, senaryo koşucusu (`kitlik_10`, `baskin`, `veba`), anlık görüntü, kasa denetçisi, iklim deneyi, köylü denetçisi, kriz enjektörü, diyalog deneyi, performans şeridi.
- **Otomatik oyuncu**: `TOHUM`/`KABUL_ORANI` ile uzun koşu; `DUMAN_TESTI_20=1` ile 20 gece duman (`tests/oto/otomatik_oyuncu.tscn`).
- **Fotoğraf sahneleri**: `koy_foto.tscn` (KIP bilgi/insa/rapor/bos, FAZ gunduz/aksam/gece), `kapi_foto.tscn`, `menu_foto.tscn`.
- **Tam sanity**: `--headless --editor --import --quit` + `python -B tools/sanity_check.py` — beklenti ~320 PASS, son satır `Sanity: 0 failed`; FAIL = P0.
- **Tek akış testleri**: `tests/oto/*_kontrol.tscn` (ör. `nihai_son_kontrol`, `saglik_salgini_kontrol`), logda `SCRIPT ERROR`/`ERROR:`/`KALDI` testin düştüğünü gösterir.

### BUG-0013 incelemesi (kapı sonrası kayıttan Devam, köy yerine kapıyı açıyor)
Kaynak: `src/arayuz/ana.gd`. Kaynak koddan izlediğim akış:
- `devam_et()` (satır **68–74**): kayıt dosyasını `Oturum.kayittan(katalog, kayit.oku())` ile yükler, sonra **koşulsuz `_kapiya_git()`** çağırır (satır 74).
- `_kapiya_git()` (satır **77–94**): her zaman `KapiEkrani`'yi kurup gösterir.
- Kayıt **iki yerde** yazılır: `_koye_git()` (satır **99**, kapı bitince köye geçmeden) ve köyün `devam_istendi` işleyicisi (satır **106**, geceyi kapatıp yeni güne).
- `Oturum.kaydet()` (satır **725–747**) sürüm alanı `KAYIT_SURUMU=3` yazar ama **hangi fazda (kapı mı, köy mü) kaydedildiğini belirten alan yok**.
- Sonuç: köy fazında (satır 99 veya 106 kaydıyla) dönülen bir oyunda **Devam**'a basınca oturum köyde olmasına karşın kapı ekranı açılıyor. Devam, kaydın fazını bilmiyor.

Tekrar üretme adımlarım (kod akışına göre kurgulandı — **bu turda oyunda deneyip ölçmedim**):
1. Yeni oyun başlat. Bir kapı nöbetini bitir → otomatik kayıt `_koye_git()` ile yazılır (satır 99).
2. Oyunu kapat.
3. Ana menüden **Devam**'a bas.
4. **Beklenen:** köy ekranı (`KoyEkrani`). **Gerçek (kod akışına göre):** kapı ekranı (`KapiEkrani`).
5. Şartlar: kaydın hangi fazda olduğunu tutan alan olmadığı için hem kapı-sonrası hem gece-sonrası kayıtlarında aynı hata beklenir.

Durum: kod kaynağından **izlendi/doğrulandı**; oyunda **yeniden üretme denenmedi** (ölçülmedi). Bu yüzden TST numarası açmadım; sonraki turda oyunda deneyip doğrulayacağım.

### Rehberde anlaşılmayan / eksik bulduğum noktalar
- **Denetim dosyası bu kopyada yok:** `docs/denetim/2026-10-11-codex-oz-denetim.md` (BUG-0013'ün künyesi) commit `5c9a5b1` ağacında bulunmuyor; `docs/denetim/` altında yalnız 4 rapor var. `git fetch` engelli (ağ kısıtlı + `.git/FETCH_HEAD` izin reddi), bu yüzden BUG-0013 metnini kaynağından okuyamadım. → BUG-0013 künye metni nerede tutulacak, rehber bunu netleştirmeli.
- **Eğitim turunda "ölçülmedi" alanları:** rehber §5 gelişim kalıbı `commit X → Y` ve `sanity PASS/FAIL` bekliyor; tur hiç koşu yapmadan geçtiğinde bu alanların zorunlu mu, "ölçülmedi" yazılır mı belirsiz.
- **Kanıt klasörü git durumu:** `work/tester/tur<N>/` klasörünün `.gitignore'da olduğu doğrulanmadı; rehber "git'e girmez" diyor ama teyit edemedim.
- **TST numarası çakışması:** "TST-0001'den artar" kuralı; birden fazla Tester kopyası/paralel koşu olursa aynı numaranın iki kez alınması nasıl önlenir?
- **Skill sahipliği:** `kapi-tester` skill'i `.claude/skills/` altında (Claude tarafı). Ben Codex tester olarak bu skill'i çağırmayı bilmiyorum; rehber hangi ajanın hangi skill kopyasını kullanacağını yazmıyor.
- **Duraklatma kısayolu:** rehber §3.1 "Seçim yokken Esc/P duraklatma" der; `OYNA.md` de aynı. Tutarlı, sorun yok — yalnız kapı önceliği net.
- **Rehberde tutarlılık:** ana sahne rehberde `res://src/arayuz/ana.tscn`, oyun dosyasında `ana.gd` `class_name Ana` ve tek autoload `Ses` — doğruladım.


### Tur 2 (11 Ekim 2026) — BUG-0016 doğrulama + sürekli oyun analizi
- **Commit:** 5396fae (tek yeni commit). Ortam: 7/24 oyun (oyna_surekli) + Codex sanity aynı makinede; hiçbir Godot işlemi adıyla kapatılmadı.
- **BUG-0016 (5396fae) → DOĞRULANDI:** `tests/unit/kvr/chr_kilit_cikisi_test.gd` GEÇTİ (0 hata); fix sonrası oyun 109'da `SOHBET_KILIDI`/KILIT yok (fix öncesi 106/107/108'de vardı). Nüans: `SOHBET_KILIDI` otomatik oyuncunun kendi yedeği; asıl kanıt birim testi.
- **Sanity:** `python -B tools/sanity_check.py` → harness `315 failed` (YANILTICI). Neden: sandbox Godot'un Windows sertifika deposunu engelliyor, her başlangıçta `ERROR: Failed to read the root certificate store` basılıyor; regex bunu hata sayıyor. **Loglardan gerçek sonuç: 320 log → 314 `GEÇTİ`, 0 `KALDI`, 0 gerçek SCRIPT/parse hatası → etkin 320/320 PASS.** 20-night-smoke GEÇTİ, bellek 68.9→69.5 MB.
- **Yeni bulgular:** TST-0001 (P2, [HATA]) `KoyNufusu.sayi()` eksik sınıf anahtarında SCRIPT ERROR (oyun 107, 60 hata, `koy_nufusu.gd:28`); TST-0002 (P2, [ARAYUZ]/[DIYALOG]) 6 metin anahtarı eksik → her oyunda `[KEY_NOT_FOUND]` uyarısı (`koy.kaynak.tomruk/un/harc/kirec`, `koy.yapi.tas_ev[_aciklama]`).
- **Yeni öneriler:** ONR-001 (başarısız ikna cevabının kalıcı kapanması + ekranda açıklanmaması), ONR-002 (KoyNufusu sınıf sözlüğü/API savunmasızlığı = TST-0001 kökü).
- **Sürekli oyun:** Son turdan beri tamamlanan 2 oyun (106, 108) — ikisi de yenilgi; ort. son gün ~10,5; huzur düşüşü/villa isyanı (108, huzur 6) izlenecek [DENGE] sinyali. 0 DONMA.
- **TST-0003 (P1, [HATA]):** HEAD'de (5396fae) oyun 112'de gece rutini her karede SCRIPT ERROR: ... 'is_yeri' on a base object of type 'Nil' (is_kazalari.gd:18; sinsi_gece_rutini.gd:14 nobetciler null koruması yok). 500+ hata, sürüyor.
- **Denge sinyali:** Tamamlanan 5/5 oyun yenilgi (zafer 0/5); ort. son gün ≈ 11,2.
- **Ölçülmeyen:** Pencereli elle CHR ikna-fail ekran görüntüsü (tur bütçesi).
- Detay: `docs/tester/turlar/TUR-002.md`; bulgular `docs/tester/BULGULAR.md`; öneriler `docs/tester/DEGISIKLIK_ONERILERI.md`.

## Tur kayıtları
<!-- Tur N · tarih · commit · test edilen · bulgu/öneri sayısı -->
- Tur 1 (eğitim) · 11 Ekim 2026 · commit 5c9a5b1 (değişmedi) · yalnız okuma + kaynak izleme · bulgu 0, öneri 0
- Tur 2 · 11 Ekim 2026 · commit 5396fae · BUG-0016 doğrulama, sürekli oyun analizi, sanity, 4 görsel · bulgu 3, öneri 2
- Tur 3 · 11 Ekim 2026 · commit 34d36f7 (kod 254202d) · denge soruşturması, BÖLÜM 6 regresyon, sanity · bulgu 1, öneri 2
- Tur 4 · 11 Ekim 2026 · commit 0ac499c (kod 160ef54) · BUG-0018 doğrulama, 2. perde denge, karakter muayenesi (44 model), Türkçe dilim, BÖLÜM 7 regresyon · bulgu 1, öneri 3
## Tur 3 — 11 Ekim 2026 (commit 34d36f7 / kod 254202d)

### Durum
- **Ana odak:** ÖNCELİKLİ DENGE SORUSU (2. perde huzur çöküşü, zafer ulaşılabilirliği, erken ekonomi) + baştan sona oyunlar + rastgele regresyon.
- **Sağlık:** etkin sanity 320/320 PASS (harness 315 FAIL = ortam sertifika hatası). BÖLÜM 6: 9 kvr testi GEÇTİ.
- **Yeni bulgu:** TST-0004 (P1, [DENGE]) zafer sonu ulaşılamıyor. Doğrulanan: BUG-0016, TST-0003.
- **Yeni öneri:** ONR-003, ONR-004. Kod/test/data değiştirilmedi.

### Tur 3 özeti
- **Denge kök nedeni:** EKO-02 (`src/koy/odun_zinciri.gd`) `hizarhane`'yi "2 tomruk → 3 odun" yaptı; tomruk yalnız `odunluk`'tan gelir ama otomatik oyuncu ve `koy_benzetimi.gd` `odunluk` kurmuyor → **odun 1. günden sonra 0** → köy 5 yapıda donuyor → gıda 0 → `aclik_moral=15` ile huzur çöküşü → İsyan/Tekfur. 22/22 gözlem yenilgi, zafer 0.
- **Deneyler:** `work/tester/tur3/denge_ek.gd` (düzeltilmiş strateji — odunluk kur) ve `hizar_tani.gd` (hizarhane yerleşimi). Düzeltmede bile hizarhane yerleşemedi (2×2 + yol komşuluğu).
- **Koşular:** 201/202/203 (headless, kabul 0.95/0.5/0.1) + 301 (pencereli, --audio-driver Dummy). Hepsi İsyan/azil ile bitti.
- **Rastgele bölüm:** BÖLÜM 6 (tüccar/pazar/sipariş) — regresyon yok.
- **Kısıt:** Gerçek elle GUI oynaması yapılamadı; pencereli otomatik koşu + 1 ekran görüntüsü kullanıldı. TST-0002 `[KEY_NOT_FOUND]` ekranı netleşmedi.

### Sonraki tur planı
1. ONR-004 uygulanınca (otomatik oyuncu `odunluk`) zafer oranını yeniden ölç.
2. TST-0002'nin `[KEY_NOT_FOUND]` gösterdiği ekranı görüntüyle kesinleştir.
3. TST-0001 (KoyNufusu) tekrarını ara; pencereli elle CHR ikna-fail ekranı.
4. `koy_benzetimi.gd` zafer eşiğini test et.

## Tur 4 — 11 Ekim 2026 (commit 0ac499c / kod 160ef54)

### Durum
- **Ana odak:** (1) yeni commit `0ac499c` (BUG-0018 kaydı) doğrulaması, (2) ÖNCELİKLİ DENGE SORUSU devamı (2. perde savunma hazırlığı, ilk Tekfur gücü, huzur eğrisi, erken azil), (3) ilk **karakter muayenesi** (44 model, rehber §13.1), (4) Türkçe dilim (§13.3 ilk 150 satır), (5) BUG-0016/BUG-0017 sürdürme, (6) BÖLÜM 7 regresyon.
- **Yeni bulgu:** TST-0006 (P3, [DIYALOG]/metin). **Yeni öneri:** ONR-005, ONR-006, ONR-007.
- **Doğrulanan:** BUG-0018/TST-0004 (odun kilidi, kanıtla), BUG-0017/TST-0003, BUG-0016.
- **Kod/test/data değiştirilmedi.**

### Tur 4 özeti
- **DENGE yanıtları:** (a) 2. perde huzur eğrisi: gıda 1–3 gecede 0, huzur −10…−19/gece (110/112/114/116 örnekleri). (b) Zafer ulaşılamaz: 2. perde girişinde `sur=0 odun=0 yapı=5`, savunma ≈2–3; ilk akın gücü 4 (haraç `(gün+1)%6==0` → cevapsız ret → baski=1 → `2+2×1`), 106/113/117/123 g7'de düştü. (c) 6. gece azil = **Sancak teftişi** (ilk_gece=6, %50), ekonomi çöküşü değil (oyun 109: huzur 54 sağlıklı).
- **Karakter muayenesi:** `work/tester/muayene/` — 44 model, `muayene.json` + temas sayfaları; uyarı/açıklama Adım 5'te (TUR-004).
- **Türkçe dilim:** satır 2–150; 1 yeni bulgu (çift boşluk + yinelenen tekfur metni, TST-0006). Kaldığım satır: **150** (sonraki tur 151’den).
- **Sürekli oyun:** 24 oyun (101–123); sonlar Tekfur 9 · İsyan 5 · azil 3 · zafer 0; ortalama son gün ≈ 11,4; DONMA 0, KILIT 0 (fix sonrası), yeni HATA 0.
- Detay: `docs/tester/turlar/TUR-004.md`.


