> Bu rapor ROADMAP_4.md'ye dönüştürüldü; kararlar 16 Kasım 2026'da Ahmet tarafından verildi.

# ROADMAP 4 Hazırlık Ön Raporu — Kapı Muhafızı

**Tarih:** 15 Kasım 2026  
**Hazırlayan:** Antigravity  
**Dal:** `claude/festive-volta-li1sfm`  
**Durum:** Ön rapor (henüz `ROADMAP_4.md` yazılmadı; kod, test ve asset üretilmedi)

---

## 0. Kapsam ve Sınırlar

Kapı Muhafızı'nın çekirdek döngüsü (kapı → köy → gece raporu → perde → 5 zafer / 5 kayıp sonu, tekil kayıt `user://kayit.json`) oynanabilir durumdadır. Bu ön rapor, çekirdek döngüyü **güvenilir test tabanına oturtma, içerik ve tekrar oynanabilirliği derinleştirme, oynanış verisiyle dengeleme, ses/müzik katmanını kurma, Steam/demo paketleme ve İngilizce yerelleştirme kalitesini tamamlama** hedeflerini kapsar.

**Kesin Sınırlar (Berk/Usta Tarafıyla Ayrım):**
- `ROADMAP_2.md` içinde kalan açık/yarım maddeler ve arayüz teması (`ARY-*`) **Berk/Usta tarafındadır**; bu raporda tekrar edilmez, yalnız çakışma/teslim noktaları işaretlenir.
- `ROADMAP_3.md` (`SVS-01..58`, sıra tabanlı savaş) **Berk/Usta tarafındadır**; yalnızca okunmuştur. Savaş mekanikleri, savaş ses yer tutucuları (`SVS-47`), savaş metinleri (`SVS-46`) ve savaş ölçüm koşucusu (`SVS-49.b`) yeniden yazılmaz; `ROADMAP_4` yalnız **üstüne kurulan** veya **ortak kimlik/veri paylaşan** noktalarda köprü kurar.

**Bölüm Sırası (Katı Bağımlılık Zinciri):**
`A (Test & Bağsız Kod)` → `B (İçerik & Tekrar Oynanabilirlik)` → `C (Oyun Testi & Yerel Telemetri)` → `D (Ses & Müzik)` → `E (Paketleme & Steam Demosu)` → `F (İngilizce Metin Kalitesi)`

---

## Bölüm A — Test Güvenilirliği ve Bağsız Kod (Önerilen Önek: `TST`)

### A.1. Bugünkü Durum (Kanıtlı)
1. **Sahte geçer (`assert` + `quit(0)`) riski:**
   - `docs/denetim/2026-11-10-gorev22-bagsiz-maddeler.md` (satır 52–53), yalnız `assert()` kullanıp sonunda `quit(0)` ile çıkan **29 test** bulunduğunu ve hata oluşsa bile çıkış kodunun `0` döndüğünü kayıt altına almıştır.
   - Örnek 1: `tests/oto/mogol_oncusu_kontrol.gd` (satır 18'de yalnızca 45 sn zaman aşımı `quit(1)` verir; satır 30, 36 ve 51'de `assert(...)` kullanır ve sonunda `await Ses.cik(0)` ile `0` döner). `tests/oto/` altında toplam 49 `.gd` dosyası vardır ve `tests/` genelinde 51 dosyada `assert(...)` çağrısı bulunmaktadır.
   - Örnek 2: `tests/unit/koy/sevilen_yuz_test.gd` (satır 64'te `quit(0)` çağrılırken `assert(...)` doğrulamaları satır 99–117 arasındadır). Buna karşılık `tests/unit/kvr/` ve `tests/unit/diyalog/` testleri `hata` / `_hata` sayaçlarıyla çalışır (`assert` sayısı `0`).
2. **Oyundan hiç çağrılmayan (`src/`) bağsız betikler:**
   - `docs/denetim/2026-11-10-gorev22-bagsiz-maddeler.md` (satır 50–51) şu betiklerin oyundan hiç çağrılmadığını listeler:
     - Köy/kapı/sistem: `AyakZemini`, `HareketGecisi`, `KalabalikYol`, `SoylentiAgi`, `KapiKavgasi`, `SiddetKorkusu`, `SorguZari`, `ZarIpucu`, `TansiyonKacisAdaptoru`, `DefterTanitimi`, `AksamSohbeti`, `SevilenYuz`, `YilIzi`, `GecisGecesi`, `PerdeOzeti`, `KayitYuvaKarti`, `KonusmaGecmisi`, `HatirlanmaNotu`, `YeniDugmeIsareti`, `TemaOnizleme`, `OdakSesi`, `ProfilOnerisi`, `SonUyarisi`, `SurumEkranListesi`, `EpilogMetinVerisi`, `IcerikAyarlari`.
     - Diyalog/sorgu: `Bakis`, `BeyinDenetcisi`, `CeliskiYuzlesme`, `DilEngeli`, `HavaReplikAdaptoru`, `KararDonusu`, `KonuMerkezi`, `MuhafizYalani`, `SozVerme`, `Yemin`, `src/veri/chr_sorgu_kurallari.gd`.
     - Arayüz/Parley/ölçüm: `src/arayuz/soz/okunmus_isaret.gd`, `src/arayuz/ui_adaylari/onizleme.gd`, Parley `src/diyalog/actions/*` ve `facts/*`, ölçüm araçları (`DengeOlcumu`, `is_olcumu.gd`, `bosta_terk_olcumu.gd`).
   - Aynı denetim belgesi (satır 13–36), bağsız olduğu için yeniden `[ ]` açılan `ROADMAP_2.md` maddelerini de listeler (`SoylentiAgi` 47 madde, `KapiKavgasi` `CAT-01/02`, `SiddetKorkusu` `CAT-04`, `Yemin` `DYL-03`, `SevilenYuz` `SEV-01..05`, `DefterTanitimi` `OGR-14`, `YeniDugmeIsareti` `OGR-24`, `GecisGecesi` `OMR-08`, `PerdeOzeti` `OMR-10`, `KayitYuvaKarti` `AYR-29/33`, `YilIzi` `YIL-01/02/05/09/10`, `KonusmaGecmisi` `AYR-11`, `ProfilOnerisi` `AYR-41`, `AksamSohbeti` `HAN-13/34`, `HavaReplikAdaptoru` `KVR-SES-01`, ayrıca `DYL-14`).

### A.2. Gerçek Oyunlardan Analiz
- **Factorio & RimWorld (Headless Smoke + Strict Exit Gate):** Her güncelleme öncesi deterministik senaryo koşucuları başarısız koşulda kesin sıfır-dışı (`exit != 0`) döner; sessiz `assert` yutulmasına izin verilmez. **Bize alınacak:** Godot `--headless` altında `assert()` yerine merkezi `TestSonucu` / hata sayacı ile gerçek `quit(1)` zorunluluğu.
- **Hades & Dead Cells (Dead Code Pruning):** Erken prototip sistemleri ana döngüye bağlanmayacaksa repo içinde "ölü ağırlık" olarak tutulmaz; ya tek noktadan entegre edilir ya da arşivlenir/silinir. **Bize alınacak:** Görev 22 listesindeki her bağsız betik için tek seferlik "bağla / sil / Berk'e bırak" karar tablosu.

### A.3. Taslak Madde Listesi (`TST-*`)
1. **TST-01 — Merkezi test çıkış yardımcısı ve sahte-geçer (`assert + quit(0)`) düzeltmesi:**
   - **TST-01.a:** Headless testler için ortak hata sayacı / çıkış kapısı (`hata > 0` ise kesin `quit(1)`).
   - **TST-01.b:** Görev 22'deki 29+ testin (ve `tests/oto/*.gd` ile `sevilen_yuz_test.gd` dahil `assert` kullanan dosyaların) gerçek başarısız çıkış verir hâle getirilmesi. *(Bağımlılık: `TST-01.a`)*
2. **TST-02 — Bağsız `src/` betikleri envanter ve sahiplik kararı:** Görev 22 listesindeki (~40+) bağsız betiğin üç sınıfa ayrılması: (i) Berk/Usta `ROADMAP_2` açık maddelerine ait olanlar (dokunulmaz, Ajan Masası'nda `[EMIR]` beklenir), (ii) Ahmet tarafında hemen silinecek ölü prototipler, (iii) `B–F` bölümlerinde kullanılacak ölçüm/uyum betikleri (`DengeOlcumu` vb.). *(Bağımlılık: `TST-01.b`)*
3. **TST-03 — Ahmet tarafı ölü betik temizliği ve hedef entegrasyon:** `TST-02` karar tablosunda "sil" işaretlenen ve sahipliği çakışmayan betiklerin temizlenmesi; "bağla" işaretlenenlerin ince adaptörle bağlanması. *(Bağımlılık: `TST-02`)*
4. **TST-04 — Bölüm B–F için hedefli duman ve birim test çekirdeği (`hedefli_test_listesi`):** Sonraki bölümlerin her adımından sonra koşulacak hızlı hedefli test paketinin (çekirdek döngü, karakter/olay doğrulama, kayıt/demo, ses, metin CSV) tanımlanması ve `quit(1)` ile doğrulanması. *(Bağımlılık: `TST-01.b`, `TST-03`)*

### A.4. Berk/Usta Tarafıyla Çakışma Riski
- **Yüksek risk:** Görev 22'de yeniden açılan `SEV-05`, `AYR-29/33`, `HAN-13/34`, `OGR-43`, `DYL-14`, `YIL-09` gibi maddeler `AGENTS.md` (15 Kas 2026 bölüşümü) gereği **Berk tarafındadır**.
- **Zorunlu Kural:** Berk tarafının dosyaları silinemez veya bağlanamaz; yalnızca `TST-02` karar tablosunda işaretlenir ve müdahale gerekiyorsa GitHub Issue #11 (Ajan Masası) üzerinden `[EMIR]` etiketiyle koordinasyon sağlanır.

### A.5. Ahmet'e Numaralı Karar Soruları
1. **Karar A1 — Görev 22'deki bağsız betiklerden Berk tarafındaki açık maddelere ait olmayanlar (ör. Parley `actions/*`, `facts/*`, `TemaOnizleme`, `Bakis`) ne yapılsın?**
   - *Seçenek 1:* Tamamen silinsin (git geçmişinde zaten duruyor).
   - *Seçenek 2:* `arsiv/` klasörüne taşınıp `.gdignore` ile oyun dışına alınsın.
   - *Önerim:* **Seçenek 1 (Silinsin).** Ölü betik Godot UID/parse taramasını kirletir; ihtiyaç olursa git tarihinden tek komutla döner.
2. **Karar A2 — `TST-01` kapsamında `tests/oto/*.gd` içindeki 49 kontrol testinin tamamı mı yoksa yalnız Görev 22'deki 29 test mi `quit(1)` kuralına geçirilsin?**
   - *Seçenek 1:* Yalnız Görev 22'de listelenen 29 test.
   - *Seçenek 2:* `assert` kullanan tüm 51 test dosyası tek standartta `quit(1)` kuralına geçirilsin.
   - *Önerim:* **Seçenek 2.** Kısmi düzeltme sahte yeşil bırakır; hepsini tek seferde düzeltmek en güvenli temeldir.

---

## Bölüm B — İçerik ve Tekrar Oynanabilirlik (Önerilen Önek: `ICR`)

### B.1. Bugünkü Durum (Kanıtlı)
1. **Karakter havuzu:** `karakterler/CHR_*.md` altında toplam **30** karakter tanımı bulunmaktadır.
2. **Olay kartları:** `data/olaylar/*.tres` altında toplam **50** olay kaynağı dosyası bulunmaktadır *(Not: İstemde 51 belirtilmiş olsa da disk üzerindeki mevcut sayı 50'dir)*.
3. **Başlangıç koşulları:** `data/baslangic/` klasörü henüz **mevcut değildir**; her oturum tek tip başlangıç durumuyla açılır.
4. **Savaş ve kapı kavgası bağı:** `ROADMAP_3.md` `SVS-34.a` / `SVS-34.b` (satır 720–741) esir yakalama, zindanda tutma ve fidye pazarlığını tanımlar; `KapiKavgasi` (`CAT-01/02`) ise kapı önündeki arbedeyi yönetir. Karakter kimliklerinin (`CHR_*`) bu üç sistem arasında çakışmaması gerekir.

### B.2. Gerçek Oyunlardan Analiz
- **Papers, Please (Yapılandırılmış Kapı Akışı + Tekrar Önleme):** Gelen ziyaretçiler hikâye-kritik sabit karakterler ile prosedürel/havuz karakterlerin dengeli karışımıdır; aynı yüz veya aynı ikilem art arda gelmez. **Bize alınacak:** Olay/karakter kartları için "son N gece bekleme süresi (cooldown)" ve "torba/deste (bag randomizer)" mekaniği.
- **Reigns & Frostpunk (Dallanmış Kart Desteleri + Başlangıç Senaryoları):** Farklı senaryolar ("Kıtlık Kışı", "Tekfur Baskısı", "Gazi Akını") aynı temel mekanikleri bambaşka stratejik bulmacalara dönüştürür. **Bize alınacak:** `data/baslangic/` altında 3–4 farklı başlangıç senaryosu (başlangıç nüfusu, akçe, erzak, tekfur/bey ilişkisi farkları).
- **Crusader Kings & Darkest Dungeon (Kalıcı Kimlik & Son Çeşitliliği):** Bir karakterin geçmişteki eylemi (affedilen, esir alınan, kovulan) sonraki gecelerde ya da savaşta geri döner. **Bize alınacak:** `CHR_*` kimliklerinin kapı → köy → esir/fidye hattında tekil `chr_id` üzerinden takip edilmesi ve 5 zafer / 5 kayıp sonuna giden ara dönüm noktalarının zenginleştirilmesi.

### B.3. Taslak Madde Listesi (`ICR-*`)
1. **ICR-01 — Ortak `CHR_*` Kimlik ve Durum Şeması:** Kapı, köy, kapı kavgası (`CAT`) ve savaş esir/fidye (`SVS-34`) sistemlerinin aynı karakter kimliğini (`chr_id`, durum bayrakları: `koyde`, `kovuldu`, `esir`, `fidye_bekliyor`, `oldu`) okuyup güncellemesini sağlayan sözleşme. *(Bağımlılık: `TST-04`)*
2. **ICR-02 — Olay Kartı Tekrar Önleme ve Deste Yöneticisi:** `data/olaylar/*.tres` (50+ kart) için yakın geçmiş bekleme süresi, etiket/tema ağırlığı ve perde/mevsim koşulu filtresi. *(Bağımlılık: `TST-04`)*
3. **ICR-03 — Karakter Havuzu Genişletmesi:**
   - **ICR-03.a:** 30 olan `CHR_*` havuzunun 13. yy Selçuklu ucu rollerine (ahi esnafı, derviş, kaçak sipahi, Rum/Ermeni tüccar, casus, yaralı gazî vb.) göre genişletilmesi. *(Bağımlılık: `ICR-01`)*
   - **ICR-03.b:** Yeni karakterlerin `Olay` ve `SVS-34` esir havuzlarıyla etiket eşleşmesinin test edilmesi. *(Bağımlılık: `ICR-03.a`, `ICR-02`)*
4. **ICR-04 — Olay Çeşitliliği ve Sonlara Giden Yollar:** 5 zafer / 5 kayıp sonuna ulaşan ara dalların (Tekfur, Beylik, Ahi, Moğol/Uç dengesi) yeni `data/olaylar/*.tres` kartlarıyla beslenmesi. *(Bağımlılık: `ICR-02`, `ICR-03.b`)*
5. **ICR-05 — Farklı Başlangıç Koşulları (Senaryo Seçimi):** `data/baslangic/` altında en az 3 başlangıç ön ayarı (ör. *Standart Uç*, *Kıtlık ve Kuşatma*, *Zengin Kervan Yolu*) ve yeni oyun ekranına seçici bağlanması. *(Bağımlılık: `ICR-04`)*

### B.4. Berk/Usta Tarafıyla Çakışma Riski
- **Orta risk:** `ROADMAP_3.md` `SVS-34.a/b` (esir/fidye) ve `ROADMAP_2` `CAT-01/02` (`KapiKavgasi`) Berk tarafındadır. `ICR-01` yalnızca mevcut `CHR_*` veri alanlarını genişletmeli, savaş içi esir mantığına dokunmamalıdır.
- **Veri çakışması:** `data/olaylar/` ve `karakterler/` yeni dosyalar olarak eklendiğinde mevcut 30 karakter ve 50 olay kimliği bozulmamalıdır.

### B.5. Ahmet'e Numaralı Karar Soruları
1. **Karar B1 — `ICR-03` ile karakter havuzu (`CHR_*`) kaç karaktere çıkarılsın?**
   - *Seçenek 1:* 30 → 45 karakter (orta kapsam, 15 yeni rol).
   - *Seçenek 2:* 30 → 60 karakter (geniş kapsam, her son yolu için özel yüzler).
   - *Seçenek 3:* 30 karakter kalsın, mevcutlara alternatif diyaloğ/varyant eklensin.
   - *Önerim:* **Seçenek 1 (45 karakter).** Her yeni karakter 3D model/yer tutucu ve çeviri yükü getirir; 45 hedefli ve sürdürülebilirdir.
2. **Karar B2 — Başlangıç senaryoları (`ICR-05`) ilk açılışta açık mı olsun, yoksa bir son görüldükten sonra mı açılsın?**
   - *Seçenek 1:* İlk günden tüm başlangıç senaryoları seçilebilir.
   - *Seçenek 2:* İlk standart koşudan (veya 1. Perde geçişinden) sonra açılır.
   - *Önerim:* **Seçenek 1.** Oyuncunun/testçinin tekrar oynanabilirliği hemen görebilmesi ve Steam demosu dahil farklı tatlar deneyebilmesi için baştan açık olması daha iyidir.

---

## Bölüm C — Oyun Testi ve Yerel Telemetri (Önerilen Önek: `TEL`)

### C.1. Bugünkü Durum (Kanıtlı)
1. **Mevcut geliştirici günlüğü:** `src/debug/denge_gunlugu.gd` (satır 1–33) içinde `DengeGunlugu` sınıfı her gece sonunda `DengeOlcumu.olustur(...)` çıktısını JSON satırı olarak yazar; ancak yalnızca sahnede `PerformansGunlugu` düğümü varsa ve `gunluk.etkin` açık ise çalışır. Oyuncuya yönelik izin (opt-in) ekranı, oturum sonu özeti veya bırakma noktası kaydı yoktur.
2. **ROADMAP_3 ölçüm araçları:** `ROADMAP_3.md` Bölüm G altında `SVS-48` (kayıt göçü, satır 940), `SVS-49.a` (dengeleme tabloları, satır 954), `SVS-49.b` (sabit tohumlu `senaryo_kosucusu` ölçüm koşucusu, satır 968) ve `SVS-50` (`otomatik_oyuncu` 20 gece savaşlı duman testi, satır 980) tanımlıdır. `ROADMAP_4` bunları **kopyalamaz**; yalnızca aynı veri formatını köy/kapı kararlarıyla birleştirir.

### C.2. Gerçek Oyunlardan Analiz
- **This War of Mine & Frostpunk (Karar İzleri & Bırakma Noktası Analizi):** Oyuncuların hangi günde, hangi kaynak darboğazında oyunu kapattığı veya hangi ahlaki kararda tıkandığı denge yamalarının temelidir. **Bize alınacak:** Gece numarası, son kapanış ekranı/olayı, kaynak eğrisi ve varılan sonun yerel `user://telemetri/` JSONL dosyasına yazılması.
- **Slay the Spire / Hades (Şeffaf Yerel Koşu Geçmişi):** Oyuncu isterse kendi koşu istatistiklerini ve denge özetini görebilir; ağ bağlantısı veya üçüncü parti sunucu gerektirmez. **Bize alınacak:** Ayarlar veya ilk açılışta tek tıkla "Yerel oyun testi günlüğünü aç/kapat" izni ve geliştiriciye paylaşılabilir tekil özet raporu üreticisi.

### C.3. Taslak Madde Listesi (`TEL-*`)
1. **TEL-01 — Oyuncu İzinli Yerel Telemetri Ayarı ve Gizlilik Çerçevesi:** `ayarlar.cfg` içinde varsayılanı kapalı (veya ilk oyun testi sürümünde açıkça sorulan) `yerel_telemetri` anahtarı; hiçbir kişisel veri/ağ çıkışı olmadan yalnız `user://telemetri/` altına yazım. *(Bağımlılık: `TST-04`)*
2. **TEL-02 — Karar, Kaynak ve Bırakma Noktası Kayıt Adaptörü:** Mevcut `DengeGunlugu` (`src/debug/denge_gunlugu.gd`) üstüne inşa edilerek kapı kararları (kabul/ret/sorgu), olay seçimleri, varılan son ve erken çıkış/bırakma gecesini JSONL olarak kaydetme; `SVS-49.b` şemasıyla uyumlu ortak oturum ID'si. *(Bağımlılık: `TEL-01`, `ICR-04`)*
3. **TEL-03 — Otomatik Denge Raporu Üreticisi (`tools/denge_raporu.py`):** Toplanan yerel JSONL oturumlarından 5 zafer / 5 kayıp son dağılımı, en sık bırakılan gece ve darboğaz kaynağı özeti üreten salt-okunur analiz betiği. *(Bağımlılık: `TEL-02`, `ICR-05`)*

### C.4. Berk/Usta Tarafıyla Çakışma Riski
- **Düşük-Orta risk:** `ROADMAP_3.md` `SVS-49.b` (`senaryo_kosucusu.gd`) ve `SVS-50` (`otomatik_oyuncu`) Berk/Usta tarafındadır. `TEL-02` bu dosyalara yazmamalı, yalnız `DengeGunlugu` / `Oturum` sinyallerini dinleyen bağımsız bir adaptör olmalıdır.

### C.5. Ahmet'e Numaralı Karar Soruları
1. **Karar C1 — Yerel telemetri izni (opt-in) Steam/oyuncu sürümünde varsayılan olarak nasıl davransın?**
   - *Seçenek 1:* Varsayılan kapalı; Ayarlar'dan oyuncu açar.
   - *Seçenek 2:* İlk açılışta kısa, tek soruluk onay penceresi gösterilir ("Oyun dengesini iyileştirmek için yerel oturum istatistiği tutulsun mu?").
   - *Önerim:* **Seçenek 2 (Playtest dönemi) / Seçenek 1 (Tam çıkış).** Playtestte geri bildirim almak için açıkça sorulması, tam sürümde ise varsayılan kapalı olması en temiz Steam pratiğidir.
2. **Karar C2 — Toplanan yerel telemetri dosyası nasıl dışa aktarılsın?**
   - *Seçenek 1:* Yalnız `user://telemetri/oturum_*.jsonl` dosyası (kullanıcı klasöründen alınır).
   - *Seçenek 2:* Ana menü / Ayarlar içine "Test Raporunu Klasörde Göster" düğmesi eklensin.
   - *Önerim:* **Seçenek 2.** Playtesterların dosya yolunu elle aramadan tek tuşla paylaşabilmesini sağlar.

---

## Bölüm D — Ses ve Müzik (Önerilen Önek: `SES`)

### D.1. Bugünkü Durum (Kanıtlı)
1. **Ses Autoload Altyapısı:** `src/sistemler/ses.gd` (satır 1–220):
   - Bus yapısı: `Master` → `Muzik` ve `Efekt`.
   - `ES_ZAMANLI := 6` eşzamanlı SFX oynatıcı havuzu (`oynat()`, `cal()`), `GECIS := 1.5` saniyelik paralel Tween crossfade (`_gecis()`), `VARSAYILAN_MUZIK := &"muzik_gece_dongu"`, `VARSAYILAN_ORTAM := &"ortam_mesale_dongu"`.
   - `muzik_cal()` ve `ortam_cal()` ile döngü değişimi; `sustur()` içinde `get_tree().call_group("chr_tansiyon_muzigi", "durdur")` çağrısı mevcut.
2. **Ham Ses Dosyaları:** `assets/ses/` altında toplam **72** ham ses dosyası (`.wav`/`.ogg`/`.mp3`) mevcuttur (`muzik_chr_gergin.wav`, `muzik_chr_panik.wav`, `muzik_chr_sakin.wav`, `muzik_dugun_dongu.wav`, `muzik_gece_dongu.wav`, `ortam_koy_dongu.wav`, `ortam_koy_gece.wav`, `ortam_koy_gunduz.wav`, `ortam_mesale_dongu.wav` ve `sfx_*` dosyaları).
3. **Kısıt Kuralları:**
   - `ROADMAP_2.md` (satır 5965): `[x] OZL-31: (Claude — kapsam bekçisi) Ses ve müzik üretilmez.`
   - `ROADMAP_3.md` `K16` (`SVS-47`, satır 924): Savaş sesleri için sessiz/boş yer tutucu kuralı geçerlidir.

### D.2. Gerçek Oyunlardan Analiz
- **Frostpunk & Darkest Dungeon (Duruma Duyarlı Çapraz Geçiş / Katmanlı Müzik):** Gündüz yönetim sakinliği, gece/fırtına yaklaşırken gerilim yaylılarına/vurmalılarına sorunsuz geçiş yapar; sabit tek döngü çalmaz. **Bize alınacak:** Mevcut `Ses._gecis()` altyapısını **menü / gündüz köy / kapı sorgu gerilimi / gece / kritik tehlike** durumlarına bağlayan merkezi `MuzikYonetmeni` (state-driven adaptive music).
- **Papers, Please & Banished (Net Arayüz & Ortam Geri Bildirimi):** Mühür basma, defter açma, kapı sürgüsü, sikke sesi oyuncuya ekrana bakmadan bile kararının ağırlığını hissettirir; ortam sesi (meşale, rüzgâr, kalabalık uğultusu) gece-gündüz ayrımını güçlendirir. **Bize alınacak:** UI düğme/panel ve olay kartı seslerinin tek merkezden bus/ses düzeyi dengesiyle bağlanması.

### D.3. Taslak Madde Listesi (`SES-*`)
1. **SES-01 — Ses Envanteri ve Eksik/Bozuk Dosya Denetimi:** `assets/ses/` içindeki 72 dosyanın format, ses seviyesi (LUFS/dB normalizasyon ihtiyacı) ve `Ses` autoload'unda çağrılan tüm adların eksiksiz listelenmesi; lisans/kaynak boşluklarının `docs/EKSIK_ASSET_ENVANTERI.md`'ye işlenmesi. *(Bağımlılık: `TST-04`)*
2. **SES-02 — Uyarlanabilir Müzik Yönetmeni:**
   - **SES-02.a:** Durum makinesi (Menü, Gündüz Köy, Kapı Sorgu Sakin/Gergin/Panik, Gece Raporu, Mevsim/Kış gerilimi) ile `Ses.muzik_cal()` arasında otomatik crossfade bağlantısı. *(Bağımlılık: `SES-01`)*
   - **SES-02.b:** Çatışma/savaş ekranı (`SVS-47` yer tutucusu bozulmadan) için opsiyonel gerilim katmanı kancası. *(Bağımlılık: `SES-02.a`)*
3. **SES-03 — Ortam ve Arayüz Ses Katmanı:** Gündüz/gece/mevsim ortam döngülerinin (`ortam_koy_gunduz`, `ortam_koy_gece`, `ortam_mesale_dongu`) sahne geçişlerine bağlanması ve eksik UI/karar seslerinin tekil çağrı tablosuyla bağlanması. *(Bağımlılık: `SES-01`)*
4. **SES-04 — Ses Karışımı (Mix) ve Ayarlar Entegrasyonu:** `Master`, `Muzik`, `Efekt` (gerekirse `Ortam` alt bus'ı) ses sürgüleri, sorgu geriliminde ortam sesini hafifçe kısan ducking ve `user://ayarlar.cfg` kalıcılığı. *(Bağımlılık: `SES-02.a`, `SES-03`)*

### D.4. Berk/Usta Tarafıyla Çakışma Riski
- **Orta risk:** `src/sistemler/ses.gd` `AGENTS.md` §2'de **korumalı çekirdek dosya**dır. Değişiklikler `ses.gd`'yi yeniden yazmadan ince adaptör veya yeni `src/sistemler/muzik_yonetmeni.gd` dosyasıyla yapılmalıdır. `ROADMAP_3` `SVS-47` (`K16`) savaş ses yer tutucularına dokunulmamalıdır.

### D.5. Ahmet'e Numaralı Karar Soruları
1. **Karar D1 — `OZL-31` ("Ses ve müzik üretilmez") kuralı `ROADMAP_4` için nasıl güncellensin?**
   - *Seçenek 1:* Sadece açık lisanslı (CC0 / CC-BY) hazır ses ve müzikler (`assets/ses/`) seçilip entegre edilsin.
   - *Seçenek 2:* Harici ses tasarımcısı / müzik üretimi ile özgün 13. yy Anadolu temalı parçalar eklensin; `ROADMAP_4` kod tarafı hazır beklesin.
   - *Seçenek 3:* Mevcut 72 dosya düzeltilip dengelensin, yeni ses dosyası alınmasın.
   - *Önerim:* **Seçenek 1 (CC0/CC-BY hazır + mevcut 72 dosyanın dengelenmesi).** `OZL-31` felsefesini korur, telif riski yaratmaz ve oyunu sessiz bırakmaz.
2. **Karar D2 — Ortam sesleri (`ortam_*`) ayrı bir `Ortam` audio bus'ına alınsın mı?**
   - *Seçenek 1:* Evet, `Master -> Muzik, Efekt, Ortam` (oyuncu ortamı ayrı kısabilsin).
   - *Seçenek 2:* Hayır, `Efekt` altında kalsın (mevcut 2 bus korunur).
   - *Önerim:* **Seçenek 1.** Uzun oynanışta meşale/rüzgâr döngüsünü efektlerden ayrı kısabilmek önemli bir erişilebilirlik/konfor standardıdır.

---

## Bölüm E — Paketleme ve Steam Demosu (Önerilen Önek: `PKT`)

### E.1. Bugünkü Durum (Kanıtlı)
1. **`export_presets.cfg`:** Dosyada (satır 1–41) yalnızca `[preset.0]` (`name="Windows"`, `platform="Windows Desktop"`) bulunmaktadır. `export_path=""`, `application/icon=""`, `application/product_name=""`, `application/file_version=""`, `application/product_version=""`, `application/company_name=""`, `application/copyright=""` alanlarının tamamı boştur. Demo için `[preset.1]` yoktur.
2. **Demo Kesiti:** `src/sistemler/demo_kesiti.gd` (satır 1–42) `DemoKesiti` sınıfını tanımlar: `--demo` argümanı veya `DEMO=1` ortam değişkeniyle aktifleşir, `res://data/ayarlar/oyun.tres` içinden `oturma_esigi` (yedek `18`) okur ve `perde2_baslar(demo)` ile 2. Perde geçişini sınırlar.
3. **Mağaza ve Sürüm Belgeleri:** `docs/surum/MAGAZA.md` (satır 1–25) tanıtım metni, 5 son listesi ve dürüst satırı ("Seslendirme yoktur; konuşmalar yazılıdır") içerir. `docs/surum/SURUM_NOTU.md` (satır 1–3) motoru `Godot 4.7.2-stable` olarak sabitler.
4. **ROADMAP_2 Sürüm Sınırları:** `ROADMAP_2.md` içinde `SRM-11` (satır 7001: *Başarım tablosu açılmaz*), `SRM-16` (satır 7037: *Steamworks bu sürüme girmez*) ve `SRM-18` (satır 7049: *İkon üretilmez*) kapsam dışı bırakılmıştır.

### E.2. Gerçek Oyunlardan Analiz
- **Papers, Please & Factorio (Temiz Demo Kesiti + Kayıt Uyumluluğu):** Demo, oyunun çekirdek hissini eksiksiz verir ve net bir "Demo Bitti / Tam Sürümde Devam Et" ekranıyla biter; demo kaydı tam sürümde bozulmadan devam eder. **Bize alınacak:** `DemoKesiti` (`oturma_esigi: 18`) tetiklendiğinde oyuncunun kaydını silmeden koruyan ve tam sürüme geçiş mesajı veren demo bitiş akışı.
- **Steam Next Fest Standartları (Temiz Build, Sürüm Numarası, İkon):** `export_presets.cfg` içinde ürün adı, SemVer sürüm numarası, şirket/telif bilgisi ve `.ico` olmadan Windows derlemesi `godot.exe` ikonu ve boş metadata ile çıkar. **Bize alınacak:** Tam sürüm + Demo için ayrı `export_presets.cfg` ön ayarları ve komut satırından tek komutluk doğrulama.

### E.3. Taslak Madde Listesi (`PKT-*`)
1. **PKT-01 — `export_presets.cfg` Tam Sürüm Metadata ve Sürüm Numarası:** `[preset.0]` için `product_name` ("Kapı Muhafızı"), `file_version`, `product_version`, `company_name`, `copyright`, `export_path` ve ikon yolunun tanımlanması. *(Bağımlılık: `TST-04`, `D` bölümü ses dosyaları)*
2. **PKT-02 — Demo Ön Ayarı (`[preset.1]`) ve `DemoKesiti` Uçtan Uca Doğrulaması:** `--demo` / feature flag (`demo`) ile derlenen ikinci ön ayar; `DemoKesiti.perde2_baslar()` sınırında demo bitiş ekranı, kayıt koruma ve headless export duman testi. *(Bağımlılık: `PKT-01`, `ICR-05`)*
3. **PKT-03 — Mağaza Sayfası (`docs/surum/MAGAZA.md`) ve Sürüm Notu Güncellemesi:** `ROADMAP_3` savaş özeti, güncellenen ses/müzik durumu, demo sınırı ve İngilizce mağaza metni eşlemesi. *(Bağımlılık: `PKT-02`, `SES-04`)*
4. **PKT-04 — *(Koşullu — Ahmet Kararına Bağlı)* Steamworks / Başarım / Bulut Kayıt:** Eğer `SRM-11/16` yeniden açılırsa, GodotSteam/Steamworks eklentisi, temel başarımlar ve `user://kayit.json` bulut kayıt eşlemesi. *(Bağımlılık: `PKT-02`)*

### E.4. Berk/Usta Tarafıyla Çakışma Riski
- **Düşük risk:** Paketleme dosyaları (`export_presets.cfg`, `docs/surum/`) Berk tarafının aktif oyun koduyla çakışmaz; ancak `ROADMAP_2` açık maddeleri ve `ROADMAP_3` tamamlanmadan final demo/mağaza metni kilitlenmemelidir.

### E.5. Ahmet'e Numaralı Karar Soruları
1. **Karar E1 — `ROADMAP_2` `SRM-11` (Başarımlar) ve `SRM-16` (Steamworks / Bulut Kayıt) `ROADMAP_4`'te yeniden açılsın mı?**
   - *Seçenek 1:* Hayır, `ROADMAP_4` yalnız DRM-free / bağımsız Steam Demo paketi çıkarır; Steamworks sonraki aşamaya kalır.
   - *Seçenek 2:* Evet, `PKT-04` olarak Steamworks + temel başarımlar + Steam Cloud `ROADMAP_4`'e eklensin.
   - *Önerim:* **Seçenek 2 (eğer hedef Steam Next Fest / Steam sayfasıysa)**; yalnız itch.io / kapalı playtest hedefleniyorsa **Seçenek 1**.
2. **Karar E2 — `SRM-18` (Uygulama ikonu üretilmez) kuralı nasıl çözülsün?**
   - *Seçenek 1:* Mevcut onaylı bir görselden/logodan insan tarafından `.ico` hazırlanıp yolu `export_presets.cfg`'ye yazılır.
   - *Seçenek 2:* İkon boş bırakılır (geçici varsayılan Godot ikonu).
   - *Önerim:* **Seçenek 1.** Steam/Windows dağıtımında Godot varsayılan ikonu kabul görmez; ajana ürettirmeden insan eliyle tek `.ico` verilmesi gerekir.

---

## Bölüm F — İngilizce Metin Kalitesi (Son) (Önerilen Önek: `ING`)

### F.1. Bugünkü Durum (Kanıtlı)
1. **Taslak ve Ana CSV Farkı:** `docs/INGILIZCE_METIN_TASLAGI.csv` toplam **2352** satır (`anahtar,tr,en,not` sütunlarıyla `taslak_tam`), buna karşılık `data/metin/metinler.csv` **2713** satırdır. Aradaki **~361 satırlık** fark (sonradan eklenen diyalog, arayüz, `zar.degistirici.*`, `dedikodu.kacis` vb.) henüz İngilizce taslağa/ana CSV'ye senkronize edilmemiştir.
2. **Doğrulayıcı Sınırları:** `tools/metin_dogrula.py` (satır 1–60) şu anda CSV yapısı, `KVR-11` noktalı anahtar biçimi, `%s/%d` yer tutucu sayısı ve `OGR-08` (`ogretici.*` için 90 karakter sınırı) kontrolü yapar; genel arayüz düğmeleri/panelleri için İngilizce karakter/taşma kontrolü ve terim tutarlılığı denetimi yoktur.
3. **Savaş Metinleri:** `ROADMAP_3.md` `SVS-46` (satır 912) yeni savaş TR/EN metin anahtarlarını kendi kapsamında tutar; `ROADMAP_4` bunları tekrarlamaz.

### F.2. Gerçek Oyunlardan Analiz
- **Crusader Kings & Mount & Blade (Tarihsel Terim Sözlüğü / Glossary):** 13. yy Anadolu Selçuklu ucu terimleri (*Tekfur*, *Ahi*, *Akçe*, *Subaşı*, *Uç Beyi*, *Oba*) rastgele "Baron/Gold/Guild" diye çevrilirse dönem atmosferi kaybolur. **Bize alınacak:** `docs/TERIM_SOZLUGU_EN.md` altında sabit terim karşılıkları ve otomatik tutarlılık denetimi.
- **Hades & Darkest Dungeon (UI Taşma Bütçesi):** İngilizce metinler bazı düğme ve kartlarda Türkçe'den %15–25 uzun olabilir; metin kutusundan taşma veya satır kırılması yaşanır. **Bize alınacak:** `tools/metin_dogrula.py` veya ayrı bir kontrol betiğine UI bileşeni başına karakter bütçesi ve headless sahne taşma testi eklenmesi.

### F.3. Taslak Madde Listesi (`ING-*`)
1. **ING-01 — 13. Yüzyıl Anadolu Ucu İngilizce Terim Sözlüğü:** Tarihsel unvanlar, para/kaynak adları ve kurumların tekil İngilizce karşılıklarının sabitlenmesi (Osmanlı terimleri hariç tutularak). *(Bağımlılık: `B` ve `E` bölümlerindeki tüm yeni metin anahtarlarının dondurulması)*
2. **ING-02 — Eksik ~361+ Satırın Eşitlenmesi ve Ana `metinler.csv` Senkronizasyonu:** `data/metin/metinler.csv` (ve `ICR`/`TEL`/`PKT` ile yeni eklenen tüm anahtarlar) ile `docs/INGILIZCE_METIN_TASLAGI.csv` arasındaki farkın kapatılması; `SVS-46` savaş anahtarlarına dokunulmadan. *(Bağımlılık: `ING-01`, `ICR-05`, `PKT-03`)*
3. **ING-03 — İngilizce Üslup ve Tutarsızlık Redaksiyonu:** Tüm `en` sütununun sözlük (`ING-01`), yer tutucu (`%s`, `%d`) ve 13. yy üslubu açısından gözden geçirilmesi. *(Bağımlılık: `ING-02`)*
4. **ING-04 — Arayüz Taşma ve Otomatik Dil Geçiş Testi:** `TranslationServer.set_locale("en")` altında ana menü, kapı, köy, gece raporu ve mağaza/demo ekranlarında etiket taşması olmadığını doğrulayan otomatik headless test + `tools/metin_dogrula.py` uzunluk kuralı genişletmesi. *(Bağımlılık: `ING-03`, `TST-04`)*

### F.4. Berk/Usta Tarafıyla Çakışma Riski
- **Orta-Yüksek risk:** `data/metin/metinler.csv` `AGENTS.md` §2'de **korumalı çekirdek dosya**dır. Berk tarafı `ROADMAP_2` ve `ROADMAP_3` (`SVS-46`) satırlarını düzenlerken dosya seviyesinde ezme kesinlikle yapılmamalı, yalnız anahtar (ID) bazlı satır birleştirmesi uygulanmalıdır.

### F.5. Ahmet'e Numaralı Karar Soruları
1. **Karar F1 — 13. yy Selçuklu/Anadolu terimleri İngilizce'de nasıl yazılsın?**
   - *Seçenek 1:* Özgün Türkçe/tarihsel biçim korunsun + ilk geçtiği yerde kısa bağlam (*Tekfur*, *Akçe*, *Ahi*, *Uç Bey*).
   - *Seçenek 2:* Tam İngilizce karşılık kullanılsın (*Byzantine Lord*, *Silver Coin*, *Guildmaster*, *Frontier Lord*).
   - *Önerim:* **Seçenek 1 (Özgün terim + bağlam).** *Mount & Blade* ve *Crusader Kings* oyuncuları tarihsel atmosfer için özgün unvanları tercih eder.
2. **Karar F2 — `ROADMAP_4` çıkışında desteklenen diller ne olsun?**
   - *Seçenek 1:* Yalnız `tr` + `en`.
   - *Seçenek 2:* Üçüncü bir dil için altyapı hazırlansın.
   - *Önerim:* **Seçenek 1 (`tr` + `en`).** Kaliteli iki dil, yarım yamalak üç dilden her zaman daha iyidir.

---

## Bölüm ve Madde Bağımlılık Zinciri (Tek Liste)

1. **`TST-01.a`** (Ortak test çıkış kapısı) →
2. **`TST-01.b`** (29+ sahte-geçer testin `quit(1)` dönüşümü) →
3. **`TST-02`** (Bağsız `src/` betikleri envanter ve Berk/Ahmet sahiplik kararı) →
4. **`TST-03`** (Ahmet tarafı ölü betik temizliği ve hedef entegrasyon) →
5. **`TST-04`** (Bölüm B–F için hedefli duman ve birim test çekirdeği) →
6. **`ICR-01`** (Ortak `CHR_*` kimlik ve durum şeması; *bağımlı: `TST-04`*) →
7. **`ICR-02`** (Olay kartı tekrar önleme ve deste yöneticisi; *bağımlı: `TST-04`*) →
8. **`ICR-03.a`** (`CHR_*` havuzu genişletmesi; *bağımlı: `ICR-01`*) →
9. **`ICR-03.b`** (Yeni karakterlerin olay ve esir havuzlarıyla eşleşmesi; *bağımlı: `ICR-03.a`, `ICR-02`*) →
10. **`ICR-04`** (Olay çeşitliliği ve 5+5 son yolları; *bağımlı: `ICR-02`, `ICR-03.b`*) →
11. **`ICR-05`** (Farklı başlangıç koşulları / senaryo seçimi; *bağımlı: `ICR-04`*) →
12. **`TEL-01`** (Oyuncu izinli yerel telemetri ayarı; *bağımlı: `TST-04`*) →
13. **`TEL-02`** (Karar, kaynak ve bırakma noktası kayıt adaptörü; *bağımlı: `TEL-01`, `ICR-04`*) →
14. **`TEL-03`** (`tools/denge_raporu.py` denge özet üreticisi; *bağımlı: `TEL-02`, `ICR-05`*) →
15. **`SES-01`** (72 ses dosyası envanteri ve eksik/seviye denetimi; *bağımlılık: `TST-04`*) →
16. **`SES-02.a`** (Uyarlanabilir müzik durum makinesi ve crossfade; *bağımlı: `SES-01`*) →
17. **`SES-02.b`** (Savaş/çatışma gerilim kancası; *bağımlı: `SES-02.a`*) →
18. **`SES-03`** (Ortam döngüleri ve arayüz ses katmanı; *bağımlı: `SES-01`*) →
19. **`SES-04`** (Ses karışımı, ducking ve `ayarlar.cfg` kalıcılığı; *bağımlı: `SES-02.a`, `SES-03`*) →
20. **`PKT-01`** (`export_presets.cfg` tam sürüm metadata ve sürüm no; *bağımlı: `TST-04`, `SES-04`*) →
21. **`PKT-02`** (`[preset.1]` demo ön ayarı ve `DemoKesiti` doğrulaması; *bağımlı: `PKT-01`, `ICR-05`*) →
22. **`PKT-03`** (`docs/surum/MAGAZA.md` ve sürüm notu güncellemesi; *bağımlı: `PKT-02`, `SES-04`*) →
23. **`PKT-04`** *(Koşullu)* (Steamworks / başarımlar / bulut kayıt; *bağımlı: `PKT-02`*) →
24. **`ING-01`** (13. yy Anadolu ucu İngilizce terim sözlüğü; *bağımlı: `ICR-05`, `PKT-03`*) →
25. **`ING-02`** (Eksik ~361+ satırın ana `metinler.csv` ile senkronizasyonu; *bağımlı: `ING-01`*) →
26. **`ING-03`** (İngilizce üslup ve yer tutucu redaksiyonu; *bağımlı: `ING-02`*) →
27. **`ING-04`** (`en` yerel ayarıyla arayüz taşma ve otomatik geçiş testi; *bağımlı: `ING-03`, `TST-04`*)
