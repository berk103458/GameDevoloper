# Oyun Gelişim Raporu (Tester)

Her tur/gün sonunda en üste bir giriş. Kalıp: `docs/tester/TESTER_REHBERI.md` §5. Sayılar ölçülerek yazılır.

<!-- En yeni giriş buraya -->

## 2026-10-11 · Tur 10 · commit ffe2e4b
- **Sağlık:** **Tam sanity `Sanity: 0 failed`** (328 PASS / 0 FAIL / 328 log) — TST-0011 düzeltmesi bu ortamda da çalışıyor (**DOĞRULANDI**); import exit 0. `SCRIPT ERROR / Parse Error / Failed to load script / KALDI` = 0.
- **Bu turda giren kod:** yok (tur 9 = aa3099a). Son commit **ffe2e4b** yalnız doküman: `ROADMAP_2.md` (–1643 satır) + `Roadmap-2/arsiv/KARAR_KAYDI.md` (+314). Oyun kodu değişmedi.
- **ffe2e4b iddia denetimi (betikle):** ROADMAP_2 **1064 madde**, **kopya kimlik 0**; bölüm 19–21 = **36+26+22 = 84** (203->84 doğru); diff'te "+…Ek şart" satırı **50** (doğru); SİL kimliği hedefleyen içerik atfı **0**. Not: 16 bölüm başı "Yeni maddeler X … Y" **aralık etiketi** ucu silinmiş kimlik (ör. BUG-26/BUG-105) -> **ONR-014 (Düşük, doküman)**. Kanıt: `work/tester/tur10/karar_denetim*.py`.
- **Doğrulanan:** **TST-0011** (6202f96, tam sanity) · **TST-0010** (`perde_gecisi_test`+`nihai_son_test`+`nihai_son_kontrol` PASS) · **BUG-0016** (`chr_kilit_cikisi_test` GEÇTİ; `SOHBET_KILIDI` yalnız 106-108) · **BUG-0017/TST-0003** (`is_yeri` yalnız oyun_112).
- **Denge eğrisi (74 tamamlanan oyun, 7/24 kesintisiz):** Tekfur **30** · İsyan **21** · Azil **21** · **zafer 2/74 = %2,7**. Ortalama son gün **12,89**; **son günü g18 olan 17 oyunun 17'si Tekfur**. 2. perdeye giren **64/64 oyun sur=0 + odun=0**; girişte huzur 53,1 · gıda 5,5 · gün 6,2; 2. perde huzur eğimi **−4,18/gece** (ONR-005/006/010/013).
- **Muayene:** Karakter regresyonu (6 model) TST-0007/0008'i **değişmeden** doğruladı (chr_011 pelerin dev torba; chr_009/chr_021 ayak 0,09 m havada; aydogdu yay-bacak). Türkçe **dilim 7 (901–1050)** temiz; c3≡c5 çift metni (30 karakter) sürüyor -> `[SORU]`. Sıradaki dilim **1051–1200**.
- **Açık bulgu:** P0 0 · P1 0 · **P2 3** (TST-0002/0004/0007) · **P3 5** (TST-0001/0005/0006/0008/0009) -> toplam **8 açık**. Kapanan (DOĞRULANDI): TST-0011, TST-0010. Yeni bulgu **0**. Yeni öneri **ONR-014** (Düşük).
- **Bir sonraki tur odağı:** pencereli zafer denemesi + "bu geceyi atlatırsan tutundun" uyarısı (ONR-010/005/006); sancak teftişi uyarı yüzeyi (ONR-007); Türkçe dilim 8 (1051–1200); TST-0002 için görünür `[KEY_NOT_FOUND]` üretme denemesi; ONR-004 uygulanınca `odunluk` ile zafer ölçümü.

## 2026-10-11 · Tur 9 · commit 6202f96
- **Sağlık:** **Tam sanity Sanity: 0 failed** (327 PASS / 0 FAIL / 329 log) — tur 3–8'deki "322 failed" yanlış negatifi **TST-0011 düzeltmesiyle kapandı** ve **DOĞRULANDI**. Import exit 0, 0 SCRIPT/Parse; 102 ERROR satırı tamamı TST-0005 yetim .import. 13 kenar senaryosuyla cert-satırı istisnasının yalnız o satırı yok saydığı kanıtlandı (gerçek ERROR:/SCRIPT ERROR/KALDI/Parse Error hepsi hâlâ FAIL).
- **Bu turda giren kod:** 6202f96 fix(TST-0011) — 	ools/sanity_check.py + 	ests/tools/test_sanity_check.py (2 yeni python testi). Tur 8: rapor commit'i.
- **Doğrulanan:** **TST-0011** (6202f96) · **TST-0010** (8acb352, tekrar). **BUG-0016 / BUG-0017 (TST-0003)** fix sonrası yeni KILIT/is_yeri kaydı 0 → durum korunuyor.
- **Denge eğrisi (66 tamamlanan oyun, 7/24 döngü kesintisiz):** zafer **2/66 = %3,0** (tur 8 %3,2). Dağılım: Tekfur **28** · İsyan **18** · Azil **18** · Uç Tutundu 1 · Beyin Uç Köyü 1. Ortalama son gün **12,56**; son günler **g5:10** (hepsi teftiş gecesi azli) ve **g18:15** (hepsi Tekfur).
- **Yeni ölçüm — zafer fiilen imkânsız:** ağalık ort. **gün 6** açılıyor → 12. perde gecesi = **19. gece** → o gece Tekfur akını önce çözülüyor: **son günü g18 olan 15 oyunun 15'i Tekfur**. Zafere ulaşan 2 oyunda ağalık gün 5'te açılmıştı. Yani zafer "ağalığı 5. günde açma" şansına bağlı (ONR-010 güçlendirildi, kaynak sırası oturum.gd:277-287 ile doğrulandı).
- **Yeni ölçüm — azil ekonomik değil:** 18 azilin **tamamı** teftiş gecelerinde (6/11/16); kök usvet_agirlik=5 → 4 rüşvet = yozlaşma 20 + dolu kişisel kasa → %50. Teftiş takvimi/riski oyunda hiç görünmüyor (ONR-007 güçlendirildi).
- **Yeni ölçüm:** 2. perdeye giren **58/58 oyun sur=0 + odun=0**; 2. perde huzuru **−4,19/gece**, sonu **21,9** (ONR-005/006/013 tur 9 sayılarıyla güncellendi).
- **TST-0002 derinleşti:** 6 eksik anahtarın uyarısı her oyunda sürüyor ama görünür etiketler (yapı kartları "TAŞ EV", üst kaynak şeridi Tomruk/Buğday/Un/Kireç/Harç, gece raporu kartı) **doğru Türkçe** — uyarı, adaptör zincirlerindeki **eager varsayılan** yüzünden çoğunlukla yanlış alarm. Görünür [KEY_NOT_FOUND] yakalanamadı → P2→P3 önerisi + iki yönlü düzeltme.
- **Kendi koşularım:** 901 (0,30) İsyan g14 · 902 (0,70) Azil g11 · 903 (0,95) Tekfur g13 — SCRIPT ERROR/KILIT/NaN/eksi stok **0**. **Regresyon:** BÖLÜM 9 (ODA) 14 akış GEÇTİ; BÖLÜM 6 (TUC) 12 akış + 13 birim GEÇTİ (sanity). **Türkçe dilim 6 (751–900) temiz**; sonraki dilim **901–1050**.
- **Açık bulgu:** P0 0 · P1 0 · P2 3 (TST-0002, 0004, 0007) · P3 5 (TST-0001, 0005, 0006, 0008, 0009). **Kapanan: TST-0011 (DOĞRULANDI)**. Yeni bulgu: **0**.
- **Bir sonraki tur odağı:** (1) ONR-010 zafer-gecesi çakışması için oyuncu gözüyle (elle/pencereli) zafer denemesi ve "bu geceyi atlatırsan tutundun" uyarısının varlığını ölç; (2) sancak teftişi uyarı yüzeyi (ONR-007) için oda ekranında teftiş takvimi var mı kontrolü; (3) Türkçe dilim 7 (901–1050); (4) karakter muayenesi tekrarı (chr_011/Aydoğdu regresyonu); (5) TST-0002 için pazar/rapor satırlarında 	r("koy.kaynak.tomruk") görünür çıkışını üretmeye çalış.

## 2026-10-11 · Tur 8 · commit d2f3b65 (yeni kod commit'i yok)
- **Sağlık:** Etkin sanity **329 log / 0 KALDI / 0 SCRIPT ERROR / 0 Parse Error** (harness "322 failed" = ortam sertifika hatası, yanlış negatif; ilk kez **TST-0011** olarak kayda alındı). Import exit 0; 102 ERROR satırı tamamı TST-0005 yetim `.import`. `perde_gecisi_test`, `nihai_son_test`, `nihai_son_kontrol`, `chr_kilit_cikisi_test` GEÇTİ. **BÖLÜM 12 (SYS-01…20) regresyonu: 11 birim + 7 akış GEÇTİ, regresyon yok.**
- **Bu turda giren kod:** yok (tur 8 boş). Son kod commit'i 8acb352 (tur 7).
- **Doğrulanan:** **TST-0010 DOĞRULANDI** (tekrar; kaynak+test) · **BUG-0016 DOĞRULANDI** (KILIT toplam 3, hepsi fix öncesi; `SOHBET_KILIDI` 109+ = 0) · **BUG-0017/TST-0003 DOĞRULANDI** (`is_yeri` yalnız oyun_112=511, 113+ = 0).
- **Denge eğrisi (56 tamamlanan oyun):** zafer **2/56 = %3,6**; son dağılımı Tekfur 23 · İsyan 17 · Azil 14 · Uç Tutundu 1 · Beyin Uç Köyü 1. Ortalama son gün **13,98** (en sık g19). **2. perdeye giren 50 oyunun 50'si `sur=0, odun=0, yapı=5`** ile giriyor; 2. perde huzuru **52,9 → 21,8** (ortalama **−4,03/gece**).
- **Yeni:** **TST-0011** (P2, test aracı yanlış negatif) · **ONR-013** (Yüksek, [DENGE] su arzı 20/gün sabit ↔ 2. perde ihtiyacı 23–58; 45/45 oyunda eksik, −3 sağlık/gece).
- **Güçlendirilen:** ONR-004 (araçta odunluk **ve** sur yok), ONR-005 (50/50 sur=0, savunma 1–4 vs atak 4–6), ONR-006 (huzur eğrisi sayıları), ONR-007 (14 azil; 6'sı g6'da köy sağlıklıyken — RNG teftiş), ONR-010 (23 Tekfur sonunun 14'ü g19; 12–13 gece dayanıp zafer gelmiyor).
- **Oyuncu gözü:** köy perde 2 ekranında Odun 1 → inşa menüsünde üç barınmanın üçü de "Malzeme yetersiz" (TST-0004 tuzağı görünür); "Geceye geç" düğmesi düşük kontrast (**ONR-012 doğrulandı**); binalar dokusuz kutu, çadır beyaz kubbe (TST-0009).
- **Açık bulgu:** P0 0 · P1 0 · P2 4 (TST-0002, 0004, 0007, 0011) · P3 5 (TST-0001, 0005, 0006, 0008, 0009).
- **Bir sonraki tur odağı:** (1) 2. perde zafer/kayıp çakışması (ONR-010) — g19'da 12–13 gece dayanıp zafer gelmemesi; (2) su dengesi (ONR-013) doğrulama; (3) Türkçe dilim 6 (751–900); (4) rastgele bölüm regresyonu (BÖLÜM 7/8/9/10/11'den biri).



## 2026-10-11 · Tur 7 · commit 8acb352
- **Sağlık:** Etkin sanity **327 log / 0 KALDI / 0 SCRIPT ERROR** (harness "322 failed" = ortam sertifika hatası, yanlış negatif — tur 3–6 ile aynı). Import exit 0, 0 SCRIPT/Parse; 102 ERROR satırı tamamı TST-0005 yetim `.import`. `perde_gecisi_test` + `nihai_son_test` + oto `nihai_son_kontrol` + `chr_kilit_cikisi_test` GEÇTİ. BÖLÜM 6 regresyonu: **16 akış + 13 birim GEÇTİ**.
- **Bu turda giren kod:** `8acb352` — tek satır: `src/veri/oyun_ayarlari.gd` `perde2_hedef_gece` 10 → **12** (TST-0010).
- **Doğrulanan:** **TST-0010 DOĞRULANDI** (sınıf varsayılanı / `.tres` / yeni kaynak üçü de 12; `.tres` okunamazsa artık sessizce 10'a düşmez) · **BUG-0016 DOĞRULANDI** (KILIT/`SOHBET_KILIDI` yalnız fix öncesi 106/107/108'de; 109–149'da 0).
- **Kimlik çözüldü:** TST-0009 "beyaz küre" = **dokusuz çadır modeli** (`cadir.glb`); `assets/model/**` altında **hiç `.jpg` yok** → tüm modeller dokusuz. Yani TST-0005'in oyun içi etkisi görsel.
- **7/24 (tur 6 sonrası, 145–149):** hata 0, DONMA 0. 145 Azil g16 · 146 Azil g6 · **147/148/149 → 3/3 `g19 Tekfur`** (TST-0010 düzeltmesinden sonra da "zafer gecesi = ölüm gecesi" çakışması sürüyor).
- **Denge eğrisi (43 tamamlanan, 101–149):** Tekfur 19 · İsyan 11 · Azil 11 · **Zafer 2** → zafer **2/43 = %4,7**; ortalama son gün **13,12** (min 5, max 18). 2. perdeye giren **36/36 oyun `sur=0`** ile giriyor; girişte asker ort. 6,6. İlk akın gücü 4 (baskı 1); savunma çoğu oyunda < güç.
- **Oynanış hissi:** Akt-1 sağlıklı. Akt-2 hâlâ "hazırlık" fırsatı vermiyor: gıda g6–8'de 0, akın g7 civarı. Sur taksiti 6–7 gece kazandırıyor ama zafer yok → gerçekçi oyuncu için zafer fiilen ulaşılamıyor (ONR-005/006/010).
- **Açık bulgu:** P0 0 · P1 0 · P2 3 (TST-0002, 0004, 0007) · P3 5 (TST-0001, 0005, 0006, 0008, 0009). Kapanan: TST-0010 (DOĞRULANDI), TST-0003 (DOĞRULANDI). Yeni öneri: **ONR-012** ([ARAYUZ] "Geceye geç" kontrast, doğrulanmadı).
- **Bir sonraki tur odağı:** Türkçe dilim 5 (601–750); ONR-005/006/010 uygulanınca zafer oranını yeniden ölç; TST-0002 `[KEY_NOT_FOUND]` ekran görüntüsü; TST-0005/TST-0009 doku eksikliği (asset envanteri); karakter muayenesi varyantı (kıyafet/el eşyası).

## 2026-10-11 · Tur 6 · commit 6ce5f62 (yeni kod commit'i yok; son kod 062185b)
- **Sağlık:** Etkin sanity **327 log / 0 KALDI / 321 GEÇTİ / 0 SCRIPT ERROR** (harness "322 failed" = ortam sertifika hatası, yanlış negatif — tur 3–5 ile aynı). Import 0 SCRIPT/Parse; 103 ERROR satırı tamamı TST-0005 yetim `.import`. BÖLÜM 11 regresyonu: **13 akış + 18 birim testi GEÇTİ**. `chr_kilit_cikisi_test` GEÇTİ.
- **Bu turda giren kod:** yok (HEAD = tur 5 tester commit'i 6ce5f62).
- **Doğrulanan:** BUG-0016 (KILIT 0, 5396fae sonrası) · BUG-0017/TST-0003 (`is_yeri` 0, 254202d sonrası) · TST-0008/0007 karakter ölçümleri (Aydoğdu yayı, chr_009/021 ayak, chr_011 pelerin) · yusuf = kasıtlı çocuk (hata değil).
- **Tur 5 sonrası 7/24 (8 oyun: 136–144):** DONMA 0, HATA 0; 136 Tekfur g19, 137 Tekfur g13, 138 Azil g6, 139 Azil g11, 140 İsyan g14, 141 Azil g6, 142 Tekfur g7, **143 ZAFER g18 (Beyin Uç Köyü)**, 144 Azil g16.
- **Denge eğrisi (38 tamamlanan, 101–144):** Tekfur 16 · İsyan 11 · Azil 9 · **Zafer 2** → zafer **2/38 = %5,3**; ortalama son gün **12,89**. İki zafer de g18 (124 huzur6 isyanda; 143 huzur14 temiz). Kabul 0.98 → Tekfur 5/Zafer 1; düşük/orta kabul → İsyan/Azil.
- **Kritik denge bulgusu (yeni):** 2. perdeye geçen **36 oyunun hepsi `sur=0, odun=0`** ile giriyor; 9 oyun tam **g19'da (zafer gecesi)** Tekfur ile bitti. Kod sırası gereği akın, zafer denetiminden önce çözülüyor → **zafer gecesi = ölüm gecesi** (ONR-010). Kendi koşumum tohum 701 (kabul 0.9) da g19 Tekfur. Bilinçli persona (odun zinciri): 3/3 g7 ölüm; sur taksiti ödeyen persona g13'e dek dayandı ama 2. akın (güç 6) yendi → zafer gerçekçi oyuncu için ulaşılamıyor.
- **Erken azil:** azil 9/38 (%24), dördü g6 → rüşvet kaynaklı yozlaşma + RNG (ONR-007).
- **Oynanış hissi:** Kapı/Akt-1 sağlıklı ve hatasız. Akt-2 "hazırlık yap" fırsatı vermiyor: gıda g6–8'de 0, akın g6–7'de geliyor; oyuncu neden çöktüğünü göremiyor.
- **Açık bulgu:** P0 0 · P1 0 · P2 3 (TST-0001, 0002, 0004) · P3 5 (TST-0005, 0006, 0007, 0008, 0009, 0010). Yeni: **TST-0010** (perde2 hedef 10 vs 12). Yeni öneri: **ONR-010** (zafer/ölüm çakışması), **ONR-011** (muayene aracı çocuk yanlış pozitifi).
- **Bir sonraki tur odağı:** ONR-005/006/010 uygulanınca zafer oranını yeniden ölç; ONR-004 (araç `odunluk`) sonrası denge; Türkçe dilim 4 (451+); TST-0002 `[KEY_NOT_FOUND]` ekran görüntüsü; TST-0009 beyaz kürenin kimliği (görsel: çadır/yurt domuna benziyor).

## 2026-10-11 · Tur 5 · commit 39847ea (yeni kod commit'i yok; son kod 062185b)
- **Sağlık:** Sanity harness'ı ortam sertifika hatası yüzünden çok sayıda "FAIL" yazıyor (**yanlış negatif** — aynı test doğrudan koşulunca GEÇTİ). Doğrudan GEÇTİ: BÖLÜM 2 regresyonu 12 birim + 5 akış testi, `chr_kilit_cikisi_test`, `odun_zinciri_test`.
- **Bu turda giren kod:** yok (yalnız denetim commit'i 0ac499c; kod 062185b). Oyun kodu değişmedi.
- **Doğrulanan:** BUG-0016 ve BUG-0017 **sürüyor** (oyunlar 124–135'te KILIT/SOHBET_KILIDI 0, `is_yeri` SCRIPT ERROR 0, DONMA 0). BUG-0018/TST-0004 açılış stoğu **ÖLÇÜLDÜ** (20 odun / 5 taş) — "≈9 odun / kesin kilit" iddiası çürütüldü; **strateji tuzağı (S3)** olarak güncellendi.
- **Düzeltme (Tur 4'ün eksik sayımı):** Tur 4 "zafer 0" demişti → oyun **124 = ZAFER ("Uç Tutundu")**. 106–135: **zafer 1/29 = %3,4**, ortalama son gün **13,4**.
- **Denge eğrisi (29 tamamlanan oyun, 106–135):** Tekfur 13 · İsyan 10 · Muhafız azledildi 5 · zafer 1.
- **Oynanış hissi:** Akt-1 sağlıklı. **2. perde** gece 6'da açılıyor; haraç (10 akçe + 20 buğday) ödenemeyince **gece 7** saldırısı: **"güçleri 4, savunman 2"** → ölüm. Persona (bilinçli "önce odun zinciri") tohum 201/202/203'te 3/3 gece 7 ölümü; gıda gece 5'te 0. Tek zafer, köy isyan/açlık içindeyken **saat dolduğu için** geldi → ONR-009.
- **Açık bulgu:** P0 0 · P1 0 · P2 3 (TST-0001, TST-0002, TST-0004) · P3 3 (TST-0005, TST-0006, TST-0009). TST-0004 P1→P2 düştü (artık kesin kilit değil, strateji tuzağı).
- **Bir sonraki tur odağı:** ONR-005/ONR-009 (2. perde hazırlık penceresi + zafer koşulu) uygulanınca zafer oranını yeniden ölç; ONR-004 (araç `odunluk` kursun) sonrası denge eğrisi; TST-0002 `[KEY_NOT_FOUND]` ekranını görüntüyle kesinleştir; TST-0009 beyaz küre kimliği.

## 2026-10-11 · Tur 4 · commit 0ac499c (kod: 160ef54)
- **Sağlık:** Etkin sanity **327/327 PASS** (harness "322 failed" = yalnız ortam sertifika hatası; gerçek `KALDI` 0, `SCRIPT ERROR` 0, `Parse Error` 0). `20-night-smoke` GEÇTİ, bellek 69.06→69.72 MB (sızıntı yok). BÖLÜM 7 (mevsim/kış) 5 akış testi **GEÇTİ**; 5 kvr birim testi (perde_gecisi, sancak_teftisi, savunma_guvenligi, tekfur_harac_heyeti, odun_zinciri) **GEÇTİ**; `chr_kilit_cikisi_test` **GEÇTİ (0 hata)**.
- **Bu turda giren kod:** yalnız `0ac499c` (denetim dosyası +1 satır: BUG-0018 kaydı). Oyun kodu değişmedi.
- **Doğrulanan:** BUG-0018/TST-0004 (odun kilidi) kanıtla **DOĞRULANDI**; BUG-0017 (TST-0003) 113–123'te `is_yeri` hata=0 → **DOĞRULANDI**; BUG-0016 5396fae sonrası KILIT/SOHBET_KILIDI yok → **DOĞRULANDI**.
- **İyileşen:** Hata/softlock tarafı temiz: son 11 oyunda (113–123) SCRIPT ERROR 0, DONMA 0, KILIT 0.
- **Kötüleşen / regresyon:** Kod regresyonu yok. **Denge hâlâ çökük:** 24 oyunda (101–123) zafer 0.
- **Denge eğrisi (ölçülmüş):** Tamamlanan 17 oyun; sonlar **Tekfur 9 · İsyan 5 · Muhafız azledildi 3 · zafer 0**; ortalama son gün **≈ 11,4**. 2. perde (nüfus 18) g5–g8'de açılıyor; hepsinde `odun=0, sur=0, yapı=5`. 2. perde girişi ile ilk Tekfur akını arası çok kısa: haraç `(gün+1)%6==0` gününde isteniyor, cevapsız → ret → `tekfur_gucu=2+2×1=4`; duvarsız köyde `savunma ≈ asker/2 = 2–3` → **g7'de ölüm** (106/113/117/123). En iyi oyun 118 (akçe 102) 2. perdede 11 gece dayanıp g19'da düştü.
- **Yeni kategori bulgusu:** [CEVRE] karakter muayenesi — 44 modelin ölçümleri + eksik hareketler (aşağıda Adım 5). [DIYALOG] metinler.csv çift boşluk (TST-0006).
- **Açık bulgu:** P0 0 · P1 1 (TST-0004) · P2 2 (TST-0001, TST-0002) · P3 2 (TST-0005, TST-0006).
- **Bir sonraki tur odağı:** ONR-004 (araçlar `odunluk` kursun) uygulanınca zafer oranını ölç; 2. perde geçişine hazırlık penceresi (ONR-005) ve huzur eğrisi (ONR-006) dengesi; TST-0002 `[KEY_NOT_FOUND]` ekranını görüntüyle kesinleştir.


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


