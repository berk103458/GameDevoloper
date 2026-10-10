# ROADMAP 2 — Diyalog odağı çerçevesi

Bu dosya madde değildir. ROADMAP 2'nin diyalog bölümü için başlıkları ve kapsamı çizer. Maddeleri Spark yazar, Gemini sınar (`SUREC.md`). Her başlık en az bir maddeyle karşılanmalıdır (Gemini kontrol 5).

## 1. Mevcut diyalog sisteminin tespiti (10 Ekim 2026, festive `2fa512e`)

Oyunda üç ayrı diyalog katmanı var. ROADMAP 2 maddesi hangi katmana dokunduğunu yazar.

### Katman A — Adlı karakter sohbeti

- Veri: `data/karakterler/*.tres` (`KarakterVerisi`, `sohbet_id`, `n_ziyaret`) + `data/sohbetler/*.tres` (`SohbetVerisi`, 40 dosya).
- Metin: `data/metin/metinler.csv` içinde `sohbet.<id>.*` anahtarları (yaklaşık 990 satır).
- Akış: `Oturum._adli_gelen()` (`src/sistemler/oturum.gd`) ziyaret sayısına göre giriş/açılış/soru seçer → `Gelen` (`src/sistemler/gelen.gd`) → `KapiEkrani._sohbet_goster()` (`src/arayuz/kapi_ekrani.gd`). Takip sorusu `soru_ust` ile üst soru sorulunca açılır.
- Ziyaret hafızası: `KarakterKadrosu.durumlar[id]` (`src/sistemler/karakter_kadrosu.gd`) içinde `ziyaret`, `son_gece`, `son_karar`, `donus` alanları. Sohbet ziyaret sayısını kullanır; `son_karar` replik seçiminde kullanılmıyor.

### Katman B — Adsız hazır diyalog

- Veri: `data/diyalog/diyalog_01_20.json` (20 kayıt: `sahne`, `acilis`, `sorular` ağacı, `secenekler`, `esik`, `yanitlar`).
- Akış: `Oturum._gemini_al()` sırayla verir; sıra `diyalog_sira` alanıyla kaydedilir (SYS-16, `src/sistemler/diyalog_sirasi.gd`). Bitince adsız gelenler `data/siniflar/` sınıf şablonlarına (`sablon.*` anahtarları) düşer.
- Metin JSON içinde düz Türkçe; CSV anahtarı değil.

### Katman C — CHR sorgu ağacı

- Kaynak: `karakterler/CHR_001.md` … `CHR_030.md` (5 bölümlü şablon) → `tools/chr_parser.py` → `data/chr_runtime/CHR_*.tres` (`KarakterVerisi`: `diyalog_dugumleri`, `metinler`, `karar_matrisi`, `obje_1/2`, `gorsel_hata_ipucu`, `baslangic_tansiyonu`).
- Metin: `.tres` içindeki `metinler` sözlüğü (`CHR_XXX_DUGUM_YY_REPLIK`, `CHR_XXX_DUGUM_YY_SEC_Z_METIN`, `CLUE_CHRXXX_*`). Bu anahtarlar `metinler.csv` içinde değil.
- Motor: `ChrSorgusu` (`src/sistemler/chr_sorgusu.gd`) — düğüm, tansiyon 0–10, `gecisler` + `tansiyon_kosulu` ile replik içermeyen yönlendirme düğümleri, `gerekli_ipuclari` / `gerekli_bayraklar` kilidi (KAP-07), ikna/blöf zarı (KAP-09, `data/chr_runtime/sorgu_kurallari.tres`), `Flag_Kilitlendi` ve `Final_Ret` (KAP-08).
- Arayüz: `src/arayuz/chr_diyalog_paneli.gd`, `src/arayuz/chr_kapi_adaptoru.gd`, tansiyon göstergesi `src/arayuz/kapi/tansiyon_gostergesi.gd`.

### Çevredeki diyalog parçaları

- Karar repliği: `src/kapi/karar_replik_adaptoru.gd` (BUG-03, `anlati.sonuc.*`).
- Replik foley: `src/sistemler/chr_sorgu_sesi.gd`. Tansiyon müziği: `src/sistemler/tansiyon_muzigi.gd`.
- İpucu: `src/kapi/ipucu_yoneticisi.gd`, hastalık belirtisi `src/kapi/hastalik_teshis_adaptoru.gd` (KRI-11).
- Söylenti: `src/kapi/fisilti_gazetesi.gd` (CAS-09, `data/fisilti_gazetesi.json`), `src/koy/batil_inanc_histerisi.gd` (KRI-08).
- Muhafız çizgisi: `src/sistemler/muhafiz_terazisi.gd` (ODA-04; `rusvet_sayisi`, zimmet, haraç, haksızlık makbuzu), `src/sistemler/muhafiz_vicdani.gd` (ODA-09).
- Debug: `src/debug/diyalog_deneyi.gd` + `diyalog_deneyi_paneli.gd` (ADM-15, tansiyon kilidi 2/5/9).
- Doğrulama: `tools/metin_dogrula.py --kaynak`, `tools/chr_parser.py --check`, `Katalog._anahtar_dogrula` (`src/cekirdek/katalog.gd`), runtime `GuvenliMetin` (`src/sistemler/guvenli_metin.gd`, `[KEY_NOT_FOUND]`). Standart `docs/METIN_ANAHTAR_STANDARDI.md`.

## 2. Başlıklar ve kapsam

Her başlıkta "Kapsam" maddenin sınırını, "Bağlantı" mevcut koda ince adaptör yolunu söyler. Önerilen önek `DIY`; kesin önek Spark'ın tur 1 kararıdır.

### 2.1 Karakter sesi profilleri

- **Kapsam:** her CHR (001–030) ve her adlı karakter için tek ses kartı: konuşma tarzı (kısa/uzun, resmi/kaba), şive veya ağız (Türkmen, Rum, Ahi, derviş, levent dili), sözlü tik (tekrar eden söz, yemin kalıbı), yalan kalıbı (sapma, aşırı ayrıntı, soruya soruyla cevap, susma). Profil veri olur; replik yazımı ayrı iştir.
- **Bağlantı:** yeni veri dosyası (ör. `data/diyalog/ses_profilleri.json`, taslak hedef yol) + `KarakterVerisi` alanı açmadan id ile okuyan yeni okuyucu. CHR için `karakterler/CHR_*.md` Bölüm 4'e isteğe bağlı satır ve `chr_parser.py` uyumu ayrı madde olabilir. Profil, replik metnini değiştirmez; yazarlara ve doğrulama aracına girdi olur.

### 2.2 NPC hafızası

- **Kapsam:** dönen karakter önceki ziyaretteki rüşveti, reti, kabulü, kışlayı ve yardımı hatırlar; giriş/açılış repliği buna göre seçilir. Hafıza kişi başına sınırlı ve kayıtta optional alandır.
- **Bağlantı:** okuma kaynağı mevcut `KarakterKadrosu.durumlar[id].son_karar` / `ziyaret` ve `Oturum.bayraklar` (`rusvet_sayisi`). Yeni dosya (ör. `src/sistemler/diyalog_hafizasi.gd`) seçim yapar; `SohbetVerisi.giris/acilis` çağrısının önüne tek satırlık adaptör. Katman C için `ChrSorgusu` yeni bayrağı `gerekli_bayraklar` üzerinden okur; motor değişmez. Kayıt gerekiyorsa `GuvenliKayit` optional alan + göç notu (`oturum.gd` ve `guvenli_kayit.gd` çekirdek, minimal).

### 2.3 Dedikodu yayılımı

- **Kapsam:** kapıdaki karar ve köydeki olaylar köylüler arasında söylenti olarak yayılır; birkaç gece içinde başka karakterlerin repliğinde ve sabah kartında görünür. Söylenti kanıt değildir, gizli CHR kimliğini açmaz.
- **Bağlantı:** mevcut `FisiltiGazetesi` (CAS-09) ve `BatilInancHisterisi` (KRI-08) ikinci motor yazılmadan genişletilir. Yeni dosya söylenti kaydını tutar; fısıltı pusulası ve 2.2 hafızası bu kaydı okur. Gece tetikleyicisi mevcut gece akışına bağlanır; UI zamanı ile `gece_sonu()` karışmaz.

### 2.4 Daha derin dallanma

- **Kapsam:** ara düğümler (soru ile karar arasında ikinci, üçüncü katman), yalanın ortaya çıkması (önceki cevapla yeni ipucu çelişince açılan yüzleşme dalı), tansiyona göre aynı düğümün farklı repliği (Sakin / Gergin / Panik varyantı).
- **Bağlantı:** Katman C'de `ChrSorgusu` zaten `gecisler` + `tansiyon_kosulu` ve `gerekli_ipuclari` destekler; ilk iş mevcut motorla yazılabilen derinliği veri olarak eklemektir. Tansiyon varyantı için düğümde isteğe bağlı replik anahtarı ve `ChrSorgusu.replik_baslat/metin` önünde küçük seçici (yeni dosya). Yalan çelişkisi `IpucuYoneticisi` kayıtları + yeni "söylendi" bayrağıyla. Katman A'da `soru_ust` zinciri derinleştirilir. Katman B JSON'u şema değişmeden genişletilir veya göç notu yazılır.

### 2.5 Ortam, kriz ve mevsim tepkisi

- **Kapsam:** kapıdaki replik o günün durumuna değinir: mevsim/hava (MEV), açık kriz (KRI salgın, kıtlık, kirli kuyu, yas), dış tehdit (HAR Moğol, Tekfur heyeti), köyün statları.
- **Bağlantı:** okuma mevcut yöneticilerden (`src/dunya/mevsim_yoneticisi.gd`, `src/koy/saglik_yoneticisi.gd`, `kitlik_isyani.gd`, `kuyu_kirliligi.gd`, `src/sistemler/mogol_oncusu.gd`, `tekfur_harac_heyeti.gd`). Yeni bağlam okuyucusu tek sözlük döndürür; replik seçicisi (2.4) bu sözlüğe bakar. Ekonomiye ve gece hesabına yazmaz.

### 2.6 Muhafızın ses tonu

- **Kapsam:** oyuncunun seçenek metinleri yozlaşma/adalet çizgisine göre tonlanır (sert, yumuşak, alaycı, rüşvetçi göz kırpma). Aynı seçeneğin mekanik etkisi değişmez; yalnız metni ve NPC'nin tepkisi değişir.
- **Bağlantı:** okuma `MuhafizTerazisi.durum()` (ODA-04) ve `MuhafizVicdani` (ODA-09). Seçenek metnini çeviren küçük seçici `chr_diyalog_paneli.gd` ve `kapi_ekrani.gd` içinde tek çağrı. Ton eşiği `data/` altında yapılandırma; sabit kodlanmaz.

### 2.7 Diyalog yazım-önizleme aracı

- **Kapsam:** yazarın bir CHR veya sohbeti oyunu baştan oynamadan açıp düğümleri, tansiyon varyantlarını, hafıza/ortam koşullarını seçerek görmesi.
- **Bağlantı:** mevcut ADM paneli (`src/debug/admin_hud.gd`) ve `DiyalogDeneyi` (ADM-15) genişletilir; yeni debug paneli yeni dosya olur. Yalnız debug katmanında çalışır, kayda yazmaz.

### 2.8 CSV anahtar doğrulama

- **Kapsam:** yeni replik, varyant, hafıza ve ton anahtarlarının standarda uyması; eksik, mükerrer ve sahipsiz anahtarın sanity'de düşmesi; üç katmanın (CSV `sohbet.*`, JSON düz metin, `.tres` `metinler`) aynı denetimden geçmesi.
- **Bağlantı:** `tools/metin_dogrula.py` ve `tools/chr_parser.py --check` genişletilir; yeni denetim `tools/sanity_check.py` adımına tek satır. Standart değişikliği önce `docs/METIN_ANAHTAR_STANDARDI.md` içinde. `metinler.csv` satır satır eklenir, ezilmez (çekirdek dosya).

## 3. Sınırlar

- Asset yok. Seslendirme, yeni ses, portre veya animasyon istenmez; gerekiyorsa sessiz/boş çağrı ve `docs/EKSIK_ASSET_ENVANTERI.md` satırı.
- Çalışma anında dil modeli veya ağ çağrısı yok. Tüm replikler önceden yazılmış veridir.
- Mevcut motorlar (`ChrSorgusu`, `SohbetVerisi`, `_gemini_al`) yeniden yazılmaz; yeni dosya + ince adaptör.
- KAP-09 zarı, KAP-08 panik kilidi, BUG-03 karar repliği, SYS-16 sıra kaydı, CAS-09 fısıltı ve KRI-08 histeri biten iştir; ROADMAP 2 bunları tekrar yazmaz, üstüne kurar.
