# Kapı Muhafızı — ROADMAP 4 (Test, İçerik, Telemetri, Ses, Paketleme ve İngilizce Kalitesi)

> **Sahip: Ahmet tarafı** (`AGENTS.md` → "15 Kas 2026 bölüşümü"). Bu yol haritası, `docs/ROADMAP_4_ON_RAPOR.md` ön raporu ve **16 Kasım 2026 Ahmet kararları** temel alınarak hazırlanmıştır.  
> **Kesin Sınır:** `ROADMAP_2.md` açık maddeleri (`ARY-*`, `GRV-*`, `SOY-*`, `SEV-05`, `AYR-29/33`, `HAN-13/34`, `DYL-14`, `YIL-09`, `OGR-43/57`) ve `ROADMAP_3.md` (`SVS-01..58`) **Berk ve Usta tarafındadır**. Ahmet ajanları `ROADMAP_3.md` ve `SVS-*` maddelerine dokunmaz; bu belgedeki çakışma riski taşıyan noktalar **Çakışma notu** ve **Ajan Masası (GitHub issue #11)** listesinde ayrıca işaretlenmiştir.  
> **DURUM LEJANDI:** `[ ]` Beklemede · `[/]` Geliştiriliyor · `[x]` Tamamlandı (kilitli).

---

## Ahmet Kararları (16 Kasım 2026 — Kesinleşen İlkeler)

| Karar | Seçim | Etkilenen Maddeler |
|---|---|---|
| **A1** | Görev 22'de tespit edilen ve Berk tarafındaki açık maddelere ait olmayan bağsız betikler (`Parley actions/*`, `facts/*`, `TemaOnizleme`, `Bakis` vb.) silinecek (git geçmişinde durur). Silmeden önce Berk tarafına ait olup olmadığını doğrulayan adım zorunludur. | `TST-04.a`, `TST-04.b`, `TST-05`, `TST-06`, `TST-07` |
| **A2** | Yalnız `29` test değil, `assert()` kullanan **51 test dosyasının tamamı** tek standartta hata durumunda `quit(1)` ile başarısız olacak biçimde düzeltilecek. | `TST-01.a`, `TST-01.b`, `TST-02.a`, `TST-02.b`, `TST-02.c`, `TST-03` |
| **B1** | Karakter havuzu **30'da (`CHR_001`–`CHR_030`) kalacak**, yeni karakter eklenmeyecek. Yerine mevcut 30 karaktere varyantlar (alternatif diyalog dalları, farklı ruh halleri/geliş sebepleri, geçmiş kararlara göre değişen tepkiler) eklenecek. | `ICR-03`, `ICR-04.a`, `ICR-04.b`, `ICR-05`, `ICR-14` |
| **B2** | Başlangıç senaryolarının **hepsi ilk günden açık** olacak; kilit/açma şartı yok. | `ICR-12.a`, `ICR-12.b`, `ICR-14` |
| **C1** | Playtest sürümünde ilk açılışta yerel telemetri için tek soruluk onay penceresi gösterilecek. Tam sürüm davranışı sonraya bırakılır (`TEL-01/02`'de not edilir). | `TEL-01`, `TEL-02`, `PKT-04.b` |
| **C2** | Ayarlar'a **"Test raporunu klasörde göster"** düğmesi eklenecek; telemetri dosyası `user://telemetri/` altında tutulacak. | `TEL-03.a`, `TEL-03.b`, `TEL-04`, `TEL-05.a` |
| **D1** | Ses için yalnız **açık lisanslı (CC0 / CC-BY)** hazır ses ve müzik eklenecek, her dosya için kaynak ve lisans kaydı tutulacak (`AGENTS.md` asset kuralı). Mevcut **73** ses dosyası seviye ve tutarlılık açısından dengelenecek. Ses üretmek yasak. | `SES-01.a`, `SES-01.b`, `SES-03`, `SES-06` |
| **D2** | Ses ayarları `Master` altında **Müzik, Efekt ve Ortam** olmak üzere **3 ayrı bus** olacak; Ayarlar'da üçü için ayrı kaydırıcı bulunacak. | `SES-02`, `SES-05`, `SES-07` |
| **E1** | Steamworks, başarımlar ve Steam Cloud `ROADMAP_4`'e girmeyecek; `PKT` bölümü yalnız **bağımsız (DRM-free) Windows demo paketini** kapsayacak. | `PKT-02`, `PKT-03`, `PKT-04.a`, `PKT-06.a` |
| **E2** | Uygulama ikonu oyuna özgün bir görselden hazırlanacak (görseli Ahmet Nano Banana ile üretecek, `.ico`'ya insan eliyle çevirecek). Ajan ikon üretmeyecek; yalnız `docs/EKSIK_ASSET_ENVANTERI.md`'ye 2D prompt yazacak ve hazır `.ico` yolunu `export_presets.cfg`'ye bağlayacak. | `PKT-01`, `PKT-02` |
| **F1** | *Tekfur, Akçe, Ahi, Uç Bey* gibi tarihsel terimler İngilizce metinde özgün haliyle kalacak; ilk geçtikleri yerde kısa açıklama (tooltip veya sözlük) verilecek. | `ING-01`, `ING-02`, `ING-04` |
| **F2** | Desteklenen diller **yalnız Türkçe (`tr`) ve İngilizce (`en`)**. Üçüncü dil altyapısı açılmayacak. | `ING-03.a`, `ING-05`, `ING-06.a` |

---

## Bölüm A — Test Güvenilirliği ve Bağsız Kod (`TST`)

Bu bölüm, `ROADMAP_4`'ün tüm sonraki içerik, telemetri, ses, paketleme ve çeviri çalışmalarının üzerine oturacağı hatasız doğrulama zeminini kurar. Önce sahte yeşil veren `assert + quit(0)` testleri gerçek başarısız çıkışa (`quit(1)`) geçirilir, ardından Görev 22'de tespit edilen bağsız betikler Berk tarafıyla sahiplik kontrolünden geçirilip ölü olanlar güvenle temizlenir.

**Bölüm bitiş ölçütü:** `assert()` içeren 51 testin tamamı hata ürettiğinde kesin `quit(1)` döner; Görev 22 listesindeki Berk dışı bağsız betikler temizlenmiş/bağlanmış olur; `tools/sanity_check.py` ve `TST-08` hedefli test çekirdeği `0` hata ile geçer.

- [ ] **TST-01:** Merkezi test çıkış kapısı ve hata sayacı standardı
  - **Amaç:** Headless testlerin hata durumunda sessizce `0` ile çıkmasını engelleyecek ortak bir başarısızlık kapısı kurmak.
  - **Bugünkü durum:** `tests/unit/kvr/` ve `tests/unit/diyalog/` testleri kendi içinde `hata` / `_hata` sayaçlarıyla `quit(1)` dönerken, `tests/oto/` ve `tests/unit/koy/sevilen_yuz_test.gd` içinde merkezi bir çıkış standardı yoktur; örneğin `tests/oto/mogol_oncusu_kontrol.gd` satır 18'de yalnızca zaman aşımında `quit(1)` verir, sonunda `await Ses.cik(0)` ile her koşulda `0` döner.
  - **Yapılacaklar:** Alt maddeler `TST-01.a` ve `TST-01.b` üzerinden ortak yardımcı ve `Ses.cik()` kapanış koruması kurulur.
  - **Dokunulacak dosyalar:** Yeni `tests/ortak/test_sonucu.gd`, `tests/fixtures/` yardımcıları.
  - **Kabul ölçütü:** Sahte hata enjekte edilen bir test `quit(1)` ve standart `KALDI` satırı üretir (`tests/unit/sistemler/test_sonucu_test.gd`).
  - **Bağımlılık:** yok.
  - **Tahmini büyüklük:** `S`

  - [ ] **TST-01.a:** Ortak `TestSonucu` hata sayacı ve zorunlu `quit(1)` yardımcısı
    - **Amaç:** Tüm yeni ve dönüştürülecek testlerde `dogrula(kosul, mesaj)` çağrısının hata sayıp tek noktadan `bitir(tree)` ile `0`/`1` dönmesini sağlamak.
    - **Bugünkü durum:** `tests/ortak/` altında ortak bir çıkış kapısı yoktur; her test `quit(0)`/`quit(1)` mantığını elle yazar.
    - **Yapılacaklar:** `TestSonucu` sınıfını `ekle_hata()`, `kontrol(kosul, ad)`, `cikis_kodu()` ve `bitir(tree)` metodlarıyla yaz; başarısızlıkta mutlaka `printerr("KALDI: ...")` bas.
    - **Dokunulacak dosyalar:** Yeni `tests/ortak/test_sonucu.gd`, `tests/unit/sistemler/test_sonucu_test.gd`.
    - **Kabul ölçütü:** Başarısız `kontrol(false, ...)` çağrısında `cikis_kodu() == 1` ve `KALDI:` çıktısı doğrulanır (`tests/unit/sistemler/test_sonucu_test.gd`).
    - **Bağımlılık:** yok.
    - **Tahmini büyüklük:** `S`

  - [ ] **TST-01.b:** `tests/fixtures/` ve `Ses.cik()` kapanış yollarının hata kodu koruması
    - **Amaç:** `await Ses.cik(0)` veya fixture akışlarının birikmiş test hatalarını ezerek çıkış kodunu `0` yapmasını önlemek.
    - **Bugünkü durum:** `tests/fixtures/kay05_goc_hatasi.gd` içinde `assert(` kullanımı vardır ve `tests/oto/*.gd` sonlarında `await Ses.cik(0)` sabit `0` parametresiyle çağrılır (`src/sistemler/ses.gd`).
    - **Yapılacaklar:** `Ses.cik()` imzasını bozmadan (`AGENTS.md` §2 korumalı dosya kuralı gereği) testlerin `Ses.cik(sonuc.cikis_kodu())` geçirmesini sağlayan kalıbı fixture'lara uygula; `tests/fixtures/kay05_goc_hatasi.gd` çıkışını düzelt.
    - **Dokunulacak dosyalar:** `tests/fixtures/kay05_goc_hatasi.gd` (gerekirse diğer `tests/fixtures/*.gd`).
    - **Kabul ölçütü:** `kay05_goc_hatasi.gd` içinde çıplak `assert(` kalmaz ve sahte bozuk durumda `quit(1)` döner (`tests/unit/kayit/kay04_icerik_surumu_test.gd`).
    - **Bağımlılık:** `TST-01.a`.
    - **Tahmini büyüklük:** `S`

- [ ] **TST-02:** `assert()` kullanan tüm 51 test dosyasının tek standartta `quit(1)` dönüşümü (Karar A2)
  - **Amaç:** Yalnız Görev 22'deki 29 testi değil, repodaki `assert()` kullanan 51 testin tamamını gerçek başarısız çıkış verir hâle getirmek.
  - **Bugünkü durum:** `tests/` altında `assert(` çağrısı içeren toplam **51** dosya vardır: **49** `tests/oto/*.gd` dosyası, `tests/unit/koy/sevilen_yuz_test.gd` (satır 64 `quit(0)`, satır 99–117 `assert`), ve `tests/fixtures/kay05_goc_hatasi.gd`. Release/headless koşuda `assert` başarısızlığı yakalanıp `quit(1)` üretmez.
  - **Yapılacaklar:** Üç alt adımda (`TST-02.a`, `TST-02.b`, `TST-02.c`) bütün `assert(` çağrıları `TestSonucu.kontrol()` ile değiştirilir.
  - **Dokunulacak dosyalar:** `tests/unit/koy/sevilen_yuz_test.gd`, `tests/oto/*.gd` (49 dosya).
  - **Kabul ölçütü:** `tests/` altında `assert(` taraması yalnızca `0` sonuç verir ve örnek enjekte hata `quit(1)` döndürür.
  - **Bağımlılık:** `TST-01.b`.
  - **Tahmini büyüklük:** `L`

  - [ ] **TST-02.a:** `sevilen_yuz_test.gd` ve ilk birim/fixture `assert` kalıntılarının dönüşümü
    - **Amaç:** `tests/unit/` içindeki tek `assert` kullanan `sevilen_yuz_test.gd` dosyasını gerçek hata raporu verir hâle getirmek.
    - **Bugünkü durum:** `tests/unit/koy/sevilen_yuz_test.gd` satır 64'te `quit(0)` çağırırken satır 99–117 arası yardımcı doğrulamalar `assert(...)` kullanmaktadır.
    - **Yapılacaklar:** `sevilen_yuz_test.gd` içindeki tüm `assert` satırlarını `TestSonucu.kontrol()` yapısına geçir; `quit(sonuc.cikis_kodu())` ile çık.
    - **Dokunulacak dosyalar:** `tests/unit/koy/sevilen_yuz_test.gd`.
    - **Kabul ölçütü:** `tests/unit/koy/sevilen_yuz_test.gd` sıfır `assert(` içerir ve headless koşuda `0` hata ile geçer; bozuk veriyle `quit(1)` döner.
    - **Bağımlılık:** `TST-01.b`.
    - **Tahmini büyüklük:** `S`
    - **Çakışma notu:** `SEV-05` Berk tarafında açık olduğundan yalnızca test çıkış mekanizması düzeltilir, oyun mantığı/kapsamı değiştirilmez.

  - [ ] **TST-02.b:** `tests/oto/` ilk 25 kontrol testinin `quit(1)` dönüşümü
    - **Amaç:** `tests/oto/` altındaki alfabetik ilk 25 kontrol betiğinin sessiz geçmesini önlemek.
    - **Bugünkü durum:** `tests/oto/acilis_bagimlilik_kontrol.gd`, `acilis_denge_kontrol.gd`, `acilis_koy_kontrol.gd`, `aclik_saglik_kontrol.gd` dahil 49 `tests/oto/*.gd` dosyası `assert(` + son satırda `quit(0)`/`Ses.cik(0)` kullanır.
    - **Yapılacaklar:** Alfabetik ilk 25 `tests/oto/*.gd` dosyasında `assert(...)` ifadelerini `TestSonucu.kontrol()` ile değiştir ve çıkışta `Ses.cik(sonuc.cikis_kodu())` kullan.
    - **Dokunulacak dosyalar:** `tests/oto/` (alfabetik ilk 25 `.gd` dosyası).
    - **Kabul ölçütü:** İlk 25 `tests/oto/*.gd` dosyasında `assert(` sayısı `0` olur ve headless koşuları `0` ile geçer.
    - **Bağımlılık:** `TST-02.a`.
    - **Tahmini büyüklük:** `M`

  - [ ] **TST-02.c:** `tests/oto/` kalan 24 kontrol testinin `quit(1)` dönüşümü
    - **Amaç:** Kalan tüm `tests/oto/*.gd` dosyalarını tek standartta `quit(1)` kapısına bağlamak.
    - **Bugünkü durum:** Kalan 24 `tests/oto/*.gd` dosyası (`mogol_oncusu_kontrol.gd` dahil) satır sonlarında `await Ses.cik(0)` ve `assert(` taşır.
    - **Yapılacaklar:** Kalan 24 dosyayı `TestSonucu.kontrol()` ve `cikis_kodu()` standardına taşı; `tests/` genelinde `assert(` kalmadığını doğrula.
    - **Dokunulacak dosyalar:** `tests/oto/` (kalan 24 `.gd` dosyası).
    - **Kabul ölçütü:** `tests/` altında `assert(` araması `0` dosya döner; tüm `tests/oto/*.gd` headless koşuda `0` döner, yapay hata enjeksiyonunda `1` döner.
    - **Bağımlılık:** `TST-02.b`.
    - **Tahmini büyüklük:** `M`

- [ ] **TST-03:** `tools/sanity_check.py` başarısız çıkış ve sessiz `KALDI` yakalama denetimi
  - **Amaç:** Otomatik birleştirme kapısının sahte yeşil testleri asla geçirmediğini araç seviyesinde garanti etmek.
  - **Bugünkü durum:** `tools/sanity_check.py` satır 19–22'de `ERROR` regex'i `SCRIPT ERROR|Parse Error|...|KALDI` arar; ancak test betikleri `quit(0)` döndüğünde ve `KALDI` basmadığında süreç kodunu başarılı sayar.
  - **Yapılacaklar:** `sanity_check.py` içine `tests/` altında `assert(` kullanımını uyaran/reddeden bir ön kontrol ekle; `tests/oto/` çalıştırıcısının sıfır-dışı çıkış kodunu kesin hata saydığını doğrula.
  - **Dokunulacak dosyalar:** `tools/sanity_check.py`, yeni Python birim testi `tests/py/test_sanity_check.py` (veya mevcut `tools/` testleri).
  - **Kabul ölçütü:** `sanity_check.py` yapay bir `assert(` veya `quit(1)` durumunda sıfır-dışı çıkış verir; normal koşuda `0` döner (`tests/py/test_sanity_check.py`).
  - **Bağımlılık:** `TST-02.c`.
  - **Tahmini büyüklük:** `M`

- [ ] **TST-04:** Görev 22 bağsız `src/` betikleri envanteri ve Berk sahiplik doğrulaması (Karar A1)
  - **Amaç:** Ölü betikleri silmeden önce tek bir dosyanın bile Berk/Usta tarafındaki açık veya yarım `ROADMAP_2` maddesine ait olmadığından emin olmak.
  - **Bugünkü durum:** `docs/denetim/2026-11-10-gorev22-bagsiz-maddeler.md` satır 50–51 yaklaşık 40+ bağsız betik listelerken satır 13–36'da yeniden `[ ]` açılan `ROADMAP_2.md` maddeleri yer alır (`SoylentiAgi`, `KapiKavgasi` `CAT-01/02`, `SiddetKorkusu` `CAT-04`, `Yemin` `DYL-03`, `SevilenYuz` `SEV-01..05`, `DefterTanitimi` `OGR-14`, `YeniDugmeIsareti` `OGR-24`, `GecisGecesi` `OMR-08`, `PerdeOzeti` `OMR-10`, `KayitYuvaKarti` `AYR-29/33`, `YilIzi` `YIL-01/02/05/09/10`, `KonusmaGecmisi` `AYR-11`, `ProfilOnerisi` `AYR-41`, `AksamSohbeti` `HAN-13/34`, `HavaReplikAdaptoru` `KVR-SES-01`). `ROADMAP_2.md` içinde ayrıca 26 açık/`[/]` madde (`ARY-*`, `GRV-*`, `SOY-*`, `DYL-14`, `OGR-57`) bulunmaktadır.
  - **Yapılacaklar:** `TST-04.a` ve `TST-04.b` ile her dosya tek tek sınıflandırılır ve Berk dosyaları dokunulmaz olarak mühürlenir.
  - **Dokunulacak dosyalar:** Yeni `docs/denetim/2026-11-16-bagsiz-betik-sahiplik-tablosu.md`.
  - **Kabul ölçütü:** Görev 22 listesindeki her betiğin karşısında `BERK-KILITLI`, `SILINECEK` veya `BAGLANACAK` etiketi bulunur (`tools/bagsiz_denetim.py` veya doğrulama kontrolü).
  - **Bağımlılık:** `TST-03`.
  - **Tahmini büyüklük:** `M`

  - [ ] **TST-04.a:** Görev 22 listesindeki tüm bağsız betiklerin `ROADMAP_2` / `ROADMAP_3` çapraz sahiplik tablosu
    - **Amaç:** Hangi bağsız betiğin gerçekten sahipsiz/ölü, hangisinin Berk tarafının açık maddesine bağlı olduğunu kanıtlı belgeye bağlamak.
    - **Bugünkü durum:** Sahiplik bilgisi `AGENTS.md`, `ROADMAP_2.md` ve `2026-11-10-gorev22-bagsiz-maddeler.md` arasında dağınıktır.
    - **Yapılacaklar:** Her betiği `git grep` ile referans taramasına sok; `ROADMAP_2.md` açık/yarım (`SEV-05`, `AYR-29/33`, `HAN-13/34`, `DYL-14`, `YIL-09`, `SOY-*`, `ARY-*`, `GRV-*`) ve `ROADMAP_3` (`SVS-*`) referanslarıyla eşle; `SILINECEK`, `BAGLANACAK`, `BERK-KILITLI` kararını yaz.
    - **Dokunulacak dosyalar:** Yeni `docs/denetim/2026-11-16-bagsiz-betik-sahiplik-tablosu.md`.
    - **Kabul ölçütü:** Listelenen betik sayısı `2026-11-10-gorev22-bagsiz-maddeler.md` ile %100 örtüşür ve `0` belirsiz dosya kalır.
    - **Bağımlılık:** `TST-03`.
    - **Tahmini büyüklük:** `S`

  - [ ] **TST-04.b:** Berk tarafına ait bağsız betik listesinin Ajan Masası (issue #11) ön listesi olarak kilitlenmesi
    - **Amaç:** Silme adımlarının Berk/Usta tarafının işiyle asla çarpışmamasını sağlamak.
    - **Bugünkü durum:** `SevilenYuz` (`SEV-01..05`), `KayitYuvaKarti` (`AYR-29/33`), `AksamSohbeti` (`HAN-13/34`), `SoylentiAgi` (`SOY-25/43/46`), `YilIzi` (`YIL-09`), `KapiKavgasi` (`CAT-01/02`), `SiddetKorkusu` (`CAT-04`) doğrudan Berk sorumluluk alanına temas etmektedir.
    - **Yapılacaklar:** `BERK-KILITLI` işaretli dosyaları koruma listesine al; yalnızca Ahmet onayı sonrası Ajan Masası'nda `[EMIR]` olarak sorulacak başlıkları belgeye yaz.
    - **Dokunulacak dosyalar:** `docs/denetim/2026-11-16-bagsiz-betik-sahiplik-tablosu.md`.
    - **Kabul ölçütü:** Hiçbir `BERK-KILITLI` dosya `TST-05/06/07` silme listesinde yer almaz.
    - **Bağımlılık:** `TST-04.a`.
    - **Tahmini büyüklük:** `S`
    - **Çakışma notu:** Berk/Usta sorumluluğundaki `SEV-05`, `AYR-29/33`, `HAN-13/34`, `SOY-*`, `YIL-09` ve `CAT-01..04` betiklerine dokunulmaz.

- [ ] **TST-05:** Ahmet tarafı ölü diyalog / Parley prototip betiklerinin silinmesi (Karar A1)
  - **Amaç:** Kullanılmayan Parley eylem/gerçek (`actions/*`, `facts/*`) ve yerini `ChrSorgusu`'na bırakmış ölü diyalog betiklerini kaldırarak kod tabanını sadeleştirmek.
  - **Bugünkü durum:** `docs/denetim/2026-11-10-gorev22-bagsiz-maddeler.md` satır 50–51 Parley `src/diyalog/actions/*` ve `facts/*` dosyalarını ayrıca `Bakis`, `BeyinDenetcisi`, `CeliskiYuzlesme`, `DilEngeli`, `KonuMerkezi`, `MuhafizYalani`, `SozVerme` betiklerini çağrılmayanlar arasında sayar.
  - **Yapılacaklar:** `TST-04.a` tablosunda `SILINECEK` onaylı Berk dışı diyalog/Parley betiklerini ve bunlara bağlı ölü testleri kaldır; Godot UID taramasında kırık referans olmadığını doğrula.
  - **Dokunulacak dosyalar:** `src/diyalog/actions/*`, `src/diyalog/facts/*` ve `TST-04.a`'da `SILINECEK` işaretli diyalog betikleri (+ ilgili `.uid`).
  - **Kabul ölçütü:** Godot `--headless --import` ve `tools/sanity_check.py` `0` `Failed to load script` ve `0` kırık `.uid` ile tamamlanır (`tests/oto/acilis_bagimlilik_kontrol.gd`).
  - **Bağımlılık:** `TST-04.b`.
  - **Tahmini büyüklük:** `M`

- [ ] **TST-06:** Ahmet tarafı ölü arayüz/önizleme betiklerinin ve yetim `.uid` dosyalarının silinmesi (Karar A1)
  - **Amaç:** Oyundan çağrılmayan eski önizleme ve artık UI betiklerini (`tema_onizleme.gd`, `ui_adaylari/onizleme.gd`, `soz/okunmus_isaret.gd` vb.) temizleyerek tema çakışmalarını azaltmak.
  - **Bugünkü durum:** `src/arayuz/tema_onizleme.gd`, `src/arayuz/ui_adaylari/onizleme.gd` ve `src/arayuz/soz/okunmus_isaret.gd` Görev 22 denetiminde bağsız bulunmuştur.
  - **Yapılacaklar:** `TST-04.a` tablosunda `SILINECEK` işaretlenen Berk dışı arayüz betiklerini sil; kalan `.uid` dosyalarını ve `project.godot`/`.tscn` referanslarını denetle.
  - **Dokunulacak dosyalar:** `src/arayuz/tema_onizleme.gd`, `src/arayuz/ui_adaylari/onizleme.gd`, `src/arayuz/soz/okunmus_isaret.gd` ve `TST-04.a` onaylı diğer ölü UI betikleri.
  - **Kabul ölçütü:** `acilis_bagimlilik_kontrol.gd` ve `tools/sanity_check.py` `0` script/UID hatası ile geçer.
  - **Bağımlılık:** `TST-04.b`.
  - **Tahmini büyüklük:** `S`
  - **Çakışma notu:** `ROADMAP_2` `ARY-*` ve `GRV-*` aktif ekran dosyalarına (`harita_ekrani.gd`, `histeri_paneli.gd` vb.) kesinlikle dokunulmaz.

- [ ] **TST-07:** Faydalı ölçüm ve sistem betiklerinin (`DengeOlcumu`, `IsOlcumu`, `IcerikAyarlari`) çekirdeğe ince bağlantısı
  - **Amaç:** Silinmeyecek kadar değerli olan geliştirme/denge ölçüm ve içerik yardımcılarının sahipsiz kalmasını önleyip `ICR` ve `TEL` bölümlerine hazır bağlamak.
  - **Bugünkü durum:** `src/sistemler/denge_olcumu.gd` (`DengeOlcumu`), `is_olcumu.gd`, `bosta_terk_olcumu.gd` ve `src/veri/icerik_ayarlari.gd` Görev 22'de doğrudan oyun döngüsünden çağrılmayanlar arasında yer alır (`denge_gunlugu.gd` yalnızca `PerformansGunlugu` varsa `DengeOlcumu.olustur()` çağırır).
  - **Yapılacaklar:** `TST-04.a`'da `BAGLANACAK` işaretlenen betikleri ince adaptörlerle ilgili test/denge akışlarına bağla veya gerçekten işlevsiz kalan alt parçaları kaldır.
  - **Dokunulacak dosyalar:** `src/sistemler/denge_olcumu.gd`, `src/sistemler/is_olcumu.gd`, `src/sistemler/bosta_terk_olcumu.gd`, `src/veri/icerik_ayarlari.gd`.
  - **Kabul ölçütü:** `tests/unit/denge/denge_olcumu_test.gd`, `is_olcumu_test.gd`, `bosta_terk_olcumu_test.gd` headless koşuda `0` hata ile geçer ve `DengeOlcumu` çağrısı en az bir aktif akışta kanıtlanır.
  - **Bağımlılık:** `TST-05`, `TST-06`.
  - **Tahmini büyüklük:** `M`

- [ ] **TST-08:** Bölüm B–F için hedefli duman ve birim test çekirdeği (`hedefli_test_listesi`)
  - **Amaç:** Sonraki bölümlerde her madde bittiğinde tam 20 gecelik uzun test yerine 1–2 dakikada koşabilecek güvenilir bir duman/birim test paketi sunmak.
  - **Bugünkü durum:** `tools/sanity_check.py` varsayılan tam koşusu bütün `tests/unit/` ve UI senaryolarını çalıştırır; `B–F` bölümleri için ayrılmış tek bir hedefli profil yoktur.
  - **Yapılacaklar:** Çekirdek kapı/köy döngüsü, karakter/olay, kayıt/demo, ses ve metin CSV doğrulamalarını kapsayan hedefli koşu parametresini (`--hedefli` veya `tests/hedefli_liste.txt`) ekle; tümünün `TST-02` `quit(1)` standardında olduğunu doğrula.
  - **Dokunulacak dosyalar:** `tools/sanity_check.py`, yeni `tests/hedefli_liste.txt`.
  - **Kabul ölçütü:** Hedefli test komutu tüm `TST`, çekirdek döngü (`otomatik_oyuncu`), `olay`, `kayit`, `ses` ve `metin` birim testlerini `0` hata ile `quit(0)` döndürerek bitirir.
  - **Bağımlılık:** `TST-07`.
  - **Tahmini büyüklük:** `M`

---

## Bölüm B — İçerik ve Tekrar Oynanabilirlik (`ICR`)

Karar `B1` gereği **30 mevcut karaktere (`CHR_001`–`CHR_030`) yeni karakter eklenmez**; bunun yerine mevcut 30 karaktere ruh hali, geliş sebebi ve geçmiş karar tepki varyantları eklenir. Karar `B2` gereği tüm başlangıç senaryoları ilk günden açık olur. Tüm yeni olaylar, dallanan diyaloglar, debuff zincirleri ve mevsim/yıl döngüsü varyasyonları doğrudan `Oturum`, `KoyYonetimi`, `GelenAkisi` ve `NihaiSon` sistemlerine bağlanır.

**Bölüm bitiş ölçütü:** 30 mevcut karakterin tümü çoklu ruh hali/karar varyantlarına sahip olur; olay tekrar önleme torbası, yeni olay türleri, karar-sonuç/debuff zincirleri, yıllık mevsim alt tipleri ve 1. günden açık 3+ başlangıç senaryosu çoklu tohum testinde (`ICR-14`) `0` hata ile doğrulanır.

- [ ] **ICR-01:** Ortak `CHR_*` kimlik ve yaşam döngüsü durum sözleşmesi
  - **Amaç:** Aynı karakterin kapı, köy, kapı kavgası ve savaş esir/fidye sistemleri arasında çelişkili veya kopyalanmış kimlikle görünmesini önlemek.
  - **Bugünkü durum:** `GelenAkisi._ayrilmis_veya_olu()` (`src/kapi/gelen_akisi.gd:238`) ve `KarakterKadrosu` (`src/sistemler/karakter_kadrosu.gd`) karakterin köydeki/ayrılmış durumunu takip eder; ancak `ROADMAP_3` `SVS-34.a/b` (esir/fidye) ve `KapiKavgasi` (`CAT-01/02`) ile paylaşılacak ortak bir `esir` / `fidye_bekliyor` durum sözleşmesi tanımlı değildir.
  - **Yapılacaklar:** `ChrSozlesmesi` (`src/veri/chr_sozlesmesi.gd`) veya yeni `src/sistemler/chr_durum_koprusu.gd` içine tekil `chr_id` yaşam durumu enum'u (`disarida`, `koyde`, `kovuldu`, `esir`, `fidye_bekliyor`, `oldu`) ve okuma/yazma adaptörü ekle; `GelenAkisi.uygun_adaylar()` içinden `esir`/`oldu` kişilerin kapı kuyruğuna düşmesini engelle.
  - **Dokunulacak dosyalar:** Yeni `src/sistemler/chr_durum_koprusu.gd`, `src/kapi/gelen_akisi.gd`, `src/sistemler/karakter_kadrosu.gd`.
  - **Kabul ölçütü:** `esir` veya `oldu` işaretli `chr_id` sonraki gece `GelenAkisi.uygun_adaylar()` listesinde yer almaz (`tests/unit/karakter_sayfalari/chr_durum_koprusu_test.gd`).
  - **Bağımlılık:** `TST-08`.
  - **Tahmini büyüklük:** `M`
  - **Çakışma notu:** `ROADMAP_3` `SVS-34.a/b` ve `ROADMAP_2` `CAT-01/02` Berk tarafındadır; yalnızca salt-okunur/adaptör durum sözleşmesi açılır, savaş içi esir mantığına dokunulmaz.

- [ ] **ICR-02:** Olay kartı tekrar önleme torbası ve bekleme süresi yöneticisi
  - **Amaç:** `tek_sefer = false` tekrarlanabilir olayların aynı veya ardışık gecelerde üst üste çıkarak oyuncuyu sıkmasını önlemek.
  - **Bugünkü durum:** `OlayVerisi` (`src/veri/olay_verisi.gd:11-12`) `agirlik` ve `tek_sefer` alanlarına sahiptir; `Oturum.olay_sec()` (`src/sistemler/oturum.gd:510`) ve `OlayOnKosulu.agirlik()` (`src/sistemler/olay_on_kosulu.gd:94`) olay seçer ancak son gecelerde çıkan olayları veya olay kategorilerini bastıran bir bekleme süresi (cooldown) torbası tutmaz.
  - **Yapılacaklar:** `ICR-02.a` ve `ICR-02.b` ile kayıt destekli bekleme geçmişi ve deste ağırlıklandırma motoru kurulur.
  - **Dokunulacak dosyalar:** `src/sistemler/oturum.gd` (yalnız ince adaptör), `src/sistemler/olay_on_kosulu.gd`, yeni `src/sistemler/olay_destesi.gd`.
  - **Kabul ölçütü:** 20 gecelik deterministik simülasyonda `tek_sefer = false` bir olay kartı en az 3 gece geçmeden tekrar seçilmez (`tests/unit/olay/olay_destesi_test.gd`).
  - **Bağımlılık:** `TST-08`.
  - **Tahmini büyüklük:** `M`

  - [ ] **ICR-02.a:** `Oturum` kayıt verisine olay geçmişi ve kategori bekleme sayacı eklenmesi
    - **Amaç:** Kaydedilip yüklenen oyunlarda da son çıkan olay ve tema geçmişinin korunmasını sağlamak.
    - **Bugünkü durum:** `Oturum.kaydet()` (`src/sistemler/oturum.gd:971`) `olay_havuzu` veya biten olayları saklar, ancak olay tema/kategori bekleme gecelerini tutan alan yoktur.
    - **Yapılacaklar:** `OlayDestesi` durum sözlüğünü (`son_gorulen: {id: gece}`, `kategori_sayac`) `Oturum.kaydet()` / `kayittan()` içine `KayitGocu` uyumlu yedekle bağla.
    - **Dokunulacak dosyalar:** Yeni `src/sistemler/olay_destesi.gd`, `src/sistemler/oturum.gd` (ince adaptör), `src/sistemler/kayit_gocu.gd`.
    - **Kabul ölçütü:** Kayıt-yükle sonrası son çıkan olayın bekleme gecesi değeri bozulmadan korunur (`tests/unit/olay/olay_destesi_test.gd`).
    - **Bağımlılık:** `TST-08`.
    - **Tahmini büyüklük:** `S`

  - [ ] **ICR-02.b:** `OlayOnKosulu.agirlik()` içinde son 3 gece tekrarı azaltan deste ağırlık motoru
    - **Amaç:** Yakın gecede çıkan temaların (ör. kıtlık, ticaret, kuyu) ağırlığını düşürüp görülmemiş temalara şans tanımak.
    - **Bugünkü durum:** `OlayOnKosulu.agirlik(o, kart)` (`src/sistemler/olay_on_kosulu.gd:94`) sabit ağırlık hesaplaması yapar.
    - **Yapılacaklar:** `OlayDestesi.etkin_agirlik(o, kart)` fonksiyonunu `OlayOnKosulu.agirlik()` içine bağla; son 3 gecede çıkan karta `0.0` (zorunlu yedek kalmadıkça), aynı temadan karta `×0.35` çarpan uygula.
    - **Dokunulacak dosyalar:** `src/sistemler/olay_on_kosulu.gd`, `src/sistemler/olay_destesi.gd`.
    - **Kabul ölçütü:** Aynı kategori iki gece üst üste seçildiğinde alternatif kategorinin seçilme olasılığı istatistiksel olarak üstün çıkar (`tests/unit/olay/olay_destesi_test.gd`).
    - **Bağımlılık:** `ICR-02.a`.
    - **Tahmini büyüklük:** `M`

- [ ] **ICR-03:** Mevcut 30 karaktere ruh hali ve geliş sebebi varyant altyapısı (Karar B1)
  - **Amaç:** Yeni karakter eklemeden mevcut 30 adlı ziyaretçinin farklı günlerde farklı ruh halleri, niyetler ve başlangıç tansiyonlarıyla kapıya gelmesini sağlamak.
  - **Bugünkü durum:** `KarakterVerisi` (`src/veri/karakter_verisi.gd:13-60`) tek `baslangic_tansiyonu`, tek `persona_maskesi` ve sabit `diyalog_dugumleri` taşır; `ChrSorgusu.replik_baslat()` (`src/sistemler/chr_sorgusu.gd:28`) her ziyarette `dugum_id = &"00"` ile başlar ve alternatif geliş sebebi seçmez.
  - **Yapılacaklar:** `KarakterVerisi` şemasını bozmadan isteğe bağlı `varyant_profilleri` (`ruh_hali`: `olagan`, `kuskulu`, `caresiz`, `ofkeli`; `gelis_sebebi`; `tansiyon_ek`; `baslangic_dugum_override`; `kosul`) alanını ekle; `ChrSorgusu` ve `Gelen.chr_sorgusu()` (`src/sistemler/gelen.gd:20`) açılışta uygun varyantı seçip `zar_baglami`'na yazsın.
  - **Dokunulacak dosyalar:** `src/veri/karakter_verisi.gd`, `src/sistemler/chr_sorgusu.gd`, `src/sistemler/gelen.gd`, yeni `src/kapi/chr_varyant_secici.gd`.
  - **Kabul ölçütü:** Aynı `CHR_*` kaynağı koşula göre farklı `baslangic_tansiyonu` ve farklı açılış düğümüne yönlenir; eski `CHR_*.tres` dosyaları `dogrula() == true` kalır (`tests/unit/karakter_sayfalari/chr_varyant_test.gd`).
  - **Bağımlılık:** `ICR-01`.
  - **Tahmini büyüklük:** `M`

- [ ] **ICR-04:** Önceki kapı kararlarına göre değişen 30 karakter tepki ve tekrar ziyaret varyantları (Karar B1)
  - **Amaç:** Oyuncunun önceki günlerde bir karaktere gösterdiği merhamet, rüşvet veya sertliğin aynı karakterin (veya çevresinin) sonraki gelişindeki tutumunu değiştirmesini sağlamak.
  - **Bugünkü durum:** `KarakterVerisi.sonraki_spawns` (`src/veri/karakter_verisi.gd:21`) ve `karar_matrisi.varyantlar` (satır 30) altyapısı mevcuttur, ancak `karakterler/CHR_001`–`CHR_030` profillerinin büyük çoğunluğu sabit tek yol kullanır; geçmiş karar bayrağına (`kovuldu`, `rusvet_alindi`, `sorguda_yakalandi`) göre alternatif diyalog dalı sınırlıdır.
  - **Yapılacaklar:** `ICR-04.a` ve `ICR-04.b` ile 30 karakterin tamamına 2–3'er varyant (alternatif diyalog düğümü, farklı ruh hali, farklı geliş sebebi ve karar tepkisi) tanımlanır.
  - **Dokunulacak dosyalar:** `data/karakterler/*.tres`, `data/chr_runtime/*.tres`, `data/metin/metinler.csv` (yeni varyant metinleri — `ING` aşamasına kadar TR + geçici EN).
  - **Kabul ölçütü:** 30 karakterin her birinde en az 2 aktif varyant tetiklenebilir ve `ChrSozlesmesi.karakter_hatalari()` `0` hata döner (`tests/unit/karakter_sayfalari/chr_varyant_kapsam_test.gd`).
  - **Bağımlılık:** `ICR-03`.
  - **Tahmini büyüklük:** `L`

  - [ ] **ICR-04.a:** İlk 15 karakter (`CHR_001`–`CHR_015`) varyant ve geçmiş karar tepki verileri
    - **Amaç:** İlk yarı kadronun önceki kapı/köy kararlarına göre farklı ruh hali ve diyalog dallarıyla dönmesini sağlamak.
    - **Bugünkü durum:** `CHR_001`–`CHR_015` tek varsayılan açılış akışı kullanır (`KarakterKadrosu`).
    - **Yapılacaklar:** `CHR_001`–`CHR_015` için ruh hali, geliş sebebi ve geçmiş karara bağlı diyalog düğümü varyantlarını yaz; `KarakterKadrosu.sonuc()` içindeki karar geçmişini varyant koşullarına bağla.
    - **Dokunulacak dosyalar:** `data/karakterler/chr_001..015.tres`, `data/chr_runtime/`, `src/sistemler/karakter_kadrosu.gd`.
    - **Kabul ölçütü:** `CHR_001`–`CHR_015` arası her karakter için varsayılan + en az 1 koşullu varyant birim testte açılır (`tests/unit/karakter_sayfalari/chr_varyant_kapsam_test.gd`).
    - **Bağımlılık:** `ICR-03`.
    - **Tahmini büyüklük:** `M`

  - [ ] **ICR-04.b:** İkinci 15 karakter (`CHR_016`–`CHR_030`) varyant ve geçmiş karar tepki verileri
    - **Amaç:** Kadronun ikinci yarısının da ruh hali ve tekrar ziyaret tepkileriyle her koşuda farklı hissettirmesini sağlamak.
    - **Bugünkü durum:** `CHR_016`–`CHR_030` profilleri tekrar oynanışta sabit yanıt verir.
    - **Yapılacaklar:** `CHR_016`–`CHR_030` için ruh hali, geliş sebebi, rüşvet/ret sonrası tepki varyantlarını ve ilgili zar bağlamı etkilerini tanımla.
    - **Dokunulacak dosyalar:** `data/karakterler/chr_016..030.tres`, `data/chr_runtime/`, `src/sistemler/karakter_kadrosu.gd`.
    - **Kabul ölçütü:** `CHR_016`–`CHR_030` tamamında varyant doğrulaması ve `ChrSozlesmesi` kontrolü `0` hata verir (`tests/unit/karakter_sayfalari/chr_varyant_kapsam_test.gd`).
    - **Bağımlılık:** `ICR-04.a`.
    - **Tahmini büyüklük:** `M`

- [ ] **ICR-05:** Dallanan diyalog sonuçlarının kapı kararına ve köy işlerine doğrudan yansıması
  - **Amaç:** Kapıdaki sorguda bir sırrı veya yalanı açığa çıkarmanın yalnız metin değişimi değil, doğrudan köy iş ataması ve debuff üzerinde stratejik karşılık üretmesini sağlamak.
  - **Bugünkü durum:** `ChrSorgusu` (`src/sistemler/chr_sorgusu.gd`) `Flag_Sir_Tamamen_Cozuldu` ve `Flag_Kimlik_Cozuldu` bayraklarını ayarlar; `Oturum._karar_sonucu()` (`src/sistemler/oturum.gd:220`) ise ağırlıklı olarak genel bar ve `karar_matrisi` stat etkisini uygular; çözülen sırrın köylünün `Koylu` iş verimi veya `PasifOzellikler` üzerindeki geçici/kalıcı karşılığı sınırlıdır.
  - **Yapılacaklar:** `Oturum.karar_ver()` / `_karar_sonucu()` içinde çözülen diyalog bayrağına göre kabul edilen köylüye geçici moral/sadakat desteği, iş verimi düzenlemesi (`Koylu.is_gucu`) veya koruma bayrağı ekleyen `src/kapi/diyalog_sonuc_koprusu.gd` adaptörünü yaz; reddedilen yalancının ise muhafız/halk güvenini farklı etkilemesini sağla.
  - **Dokunulacak dosyalar:** Yeni `src/kapi/diyalog_sonuc_koprusu.gd`, `src/sistemler/oturum.gd` (ince adaptör), `src/koy/koy_yonetimi.gd` (ince adaptör).
  - **Kabul ölçütü:** Sırrı çözülerek alınan karakter ile çözülmeden alınan aynı karakterin başlangıç sadakat/verim veya köy bayrağı çıktısı ölçülebilir biçimde ayrılır (`tests/unit/kapi_kararlari/diyalog_sonuc_koprusu_test.gd`).
  - **Bağımlılık:** `ICR-04.b`.
  - **Tahmini büyüklük:** `M`

- [ ] **ICR-06:** Kapı ve köy kararlarının sonraki günlere gecikmeli etkisi ve debuff zincirleri
  - **Amaç:** Bugün verilen "ucuz rüşvet" veya "sorgusuz kabul" kararlarının 2–4 gece sonra köy işlerine debuff, olay kartı veya özel kapı ziyaretçisi olarak geri dönmesini sağlamak.
  - **Bugünkü durum:** `KarakterVerisi` `gecikmeli_etkiler` ve `sonraki_spawns` (`src/veri/karakter_verisi.gd:21-24`), `OlayVerisi` ise `sonraki_gelen` (`src/veri/olay_verisi.gd:15`) tanımlar; ancak kapı ve köy kararlarının takvime bağlı gecikmeli kuyruğunu tek merkezde işleten birleştirilmiş bir yankı sistemi eksiktir.
  - **Yapılacaklar:** `ICR-06.a` ve `ICR-06.b` ile gecikmeli karar takvim kuyruğu ve ertesi gece kuyruk etkisi kurulur.
  - **Dokunulacak dosyalar:** Yeni `src/sistemler/karar_yankisi.gd`, `src/sistemler/oturum.gd`, `src/kapi/gelen_akisi.gd`.
  - **Kabul ölçütü:** Belirli bir kapı/olay kararı verildikten `N` gece sonra beklenen debuff veya takip ziyaretçisi deterministik olarak tetiklenir (`tests/unit/sistemler/karar_yankisi_test.gd`).
  - **Bağımlılık:** `ICR-05`.
  - **Tahmini büyüklük:** `L`

  - [ ] **ICR-06.a:** Gecikmeli kapı/köy karar etkileri ve debuff zincirleri için takvim kuyruğu
    - **Amaç:** Kaydedilebilir bir gecikmeli etki listesiyle sonraki günlerde stat, `nobet_yorgunlugu`, `husumet` veya sağlık debuff'ı tetiklemek.
    - **Bugünkü durum:** `KoyYonetimi.gece()` (`src/koy/koy_yonetimi.gd:559`) gece hesaplarını yürütür, ancak kapı/olay kaynaklı çok günlü gecikmeli yankı kuyruğu `Oturum` ile birleşik değildir.
    - **Yapılacaklar:** `KararYankisi` sınıfını yaz (`ekle(gece_hedef, tur, veri)`, `gece_isle(o, gece)`), `Oturum.kaydet()`/`kayittan()` içine bağla ve `gece_sonu()` raporuna yankı satırı üret.
    - **Dokunulacak dosyalar:** Yeni `src/sistemler/karar_yankisi.gd`, `src/sistemler/oturum.gd`.
    - **Kabul ölçütü:** Kayıt-yükleme yapıldığında bile hedef gece geldiğinde gecikmeli debuff/stat etkisi eksiksiz uygulanır (`tests/unit/sistemler/karar_yankisi_test.gd`).
    - **Bağımlılık:** `ICR-05`.
    - **Tahmini büyüklük:** `M`

  - [ ] **ICR-06.b:** Kapı ve köy kararlarının sonraki gelen kişi (`sonraki_spawns` / kuyruk) profilini etkilemesi
    - **Amaç:** Bir tüccarı soymanın/kovmanın ertesi gece gelen kervan sayısını veya muhafız baskısını, merhamet göstermenin ise yeni sığınmacı/hekim gelişini tetiklemesini sağlamak.
    - **Bugünkü durum:** `GelenAkisi.gunluk_sayi()` (`src/kapi/gelen_akisi.gd:131`) ile `Oturum.gece_kuyrugu()` (`src/sistemler/oturum.gd:123`) arasında `sonraki_gelen` ve itibar/karar yankısı bağlantısı sınırlıdır.
    - **Yapılacaklar:** `KararYankisi` içinden ertesi gece kuyruğuna zorunlu veya ağırlıklı aday (`sonraki_spawns` + `GelenAkisi.uygun_adaylar()`) enjekte eden köprüyü kur.
    - **Dokunulacak dosyalar:** `src/sistemler/karar_yankisi.gd`, `src/kapi/gelen_akisi.gd`, `src/sistemler/oturum.gd`.
    - **Kabul ölçütü:** Önceki gece verilen tetikleyici karar sonrası ertesi gece kuyruğunda beklenen takip kişisi/sınıfı yer alır (`tests/unit/kapi_kuyrugu/yanki_kuyruk_test.gd`).
    - **Bağımlılık:** `ICR-06.a`.
    - **Tahmini büyüklük:** `M`

- [ ] **ICR-07:** Köy işleri ve debuff etkileşimli günlük iş verimi/olay bağlantıları
  - **Amaç:** Köydeki aktif debuff'ların (`nobet_yorgunlugu`, `aclik_kademesi`, `enfeksiyon`, `karantina`, `is_kazasi`) yalnızca sayısal düşüş değil, doğrudan iş atama ikilemleri ve özel olay koşulları üretmesini sağlamak.
  - **Bugünkü durum:** `Koylu` (`src/koy/koylu.gd:23-29`) `yorgunluk`, `is_kazasi`, `zanaat_kazasi`, `kis_hastaligi`, `enfeksiyon`, `karantina` sözlüklerini taşır; `KoyYonetimi._uret()` (`src/koy/koy_yonetimi.gd:702`) bunların üretim etkisini hesaplar ancak debuff birikimi `OlayOnKosulu` ile yeni köy iş kararlarına yeterince bağlanmaz.
  - **Yapılacaklar:** `OlayOnKosulu.uygun()` (`src/sistemler/olay_on_kosulu.gd:29`) içine aktif debuff sayacı/eşik anahtarları (`yorgun_min`, `hasta_min`, `bosta_min`) ekle; `KoyYonetimi._uret()` içinden yüksek yorgunluk/açlıkta geçici iş veya dinlenme ikilemi sinyali üret.
  - **Dokunulacak dosyalar:** `src/sistemler/olay_on_kosulu.gd`, `src/koy/koy_yonetimi.gd` (ince adaptör), yeni `src/koy/debuff_olay_koprusu.gd`.
  - **Kabul ölçütü:** Köyde belirli sayıda yorgun/hasta çalışan varken ilgili debuff koşullu olay ön koşulu `true` döner (`tests/unit/olay/debuff_on_kosul_test.gd`).
  - **Bağımlılık:** `ICR-06.a`, `ICR-02.b`.
  - **Tahmini büyüklük:** `M`

- [ ] **ICR-08:** Yeni olay türleri I — Kervan, ticaret yolu ve dış baskı olay kartları
  - **Amaç:** Yalnız tek seferlik olaylarla sınırlı kalmayıp `kervan_gunu()`, `tekfur_gucu()` ve `akce_min` durumlarına göre tetiklenen tekrar oynanabilir ticaret/diplomasi olay türleri eklemek.
  - **Bugünkü durum:** `data/olaylar/*.tres` altında toplam **50** olay vardır; `OzelOlay.KOY_KARTLARI` ve `DIS_YUZ` (`src/sistemler/ozel_olay.gd:5-6`) sınırlı sayıda sabit kart tanımlar.
  - **Yapılacaklar:** 13. yy Selçuklu uç gerçekliğine uygun (sahte sikke/kantar hilesi, kış öncesi tuz/demir takası, Tekfur gümrük mülazımı, han konaklama vergisi, kaçak kervan ihbarı vb.) en az **8** yeni `data/olaylar/*.tres` kartı yaz; seçenekleri `sonraki_gelen`, `bayrak`, `gecikmeli_etki` (`ICR-06`) ile bağla.
  - **Dokunulacak dosyalar:** Yeni `data/olaylar/*.tres` (en az 8 kart), `data/metin/metinler.csv`.
  - **Kabul ölçütü:** Yeni olay kartlarının tamamı `OlayOnKosulu.dogrula()` ve `tests/unit/olay/yeni_olaylar_test.gd` içinde `0` hata ile yüklenir ve koşulda seçilebilir.
  - **Bağımlılık:** `ICR-06.b`, `ICR-02.b`.
  - **Tahmini büyüklük:** `M`

- [ ] **ICR-09:** Yeni olay türleri II — Köy içi çatışma, pasif özellik ve zanaat ikilemleri
  - **Amaç:** `PasifOzellikler` (`kundak_egilimi`, `santajci`, `sifaci`, `lider`, `demirci`) ve kurulu yapıların (`sifahane`, `demirhane`, `degirmen`) hikâyesiz sayı bonusu gibi kalmayıp yaşayan köy olayları doğurmasını sağlamak.
  - **Bugünkü durum:** `PasifOzellikler.CHR` (`src/koy/pasif_ozellikler.gd:21`) 30 karaktere güçlü/zayıf yön çifti atar; `OlayOnKosulu` bina varlığını (`bina_var`) kontrol edebilir ancak pasif özellik tetikli olay çeşidi azdır.
  - **Yapılacaklar:** `OlayOnKosulu` içine `ozellik_var` koşulunu ekle; köy içi zanaat/pasif özellik çatışmalarını işleyen en az **8** yeni `data/olaylar/*.tres` kartı (şifahanede ot kıtlığı, demirci çırağı kazası, kuyu başı söylentisi, şantajcı tehdidi vb.) ekle.
  - **Dokunulacak dosyalar:** `src/sistemler/olay_on_kosulu.gd`, yeni `data/olaylar/*.tres` (en az 8 kart), `data/metin/metinler.csv`.
  - **Kabul ölçütü:** Pasif özellik veya bina koşulu sağlandığında yeni olaylar `OlayOnKosulu.uygun()` taramasından `true` ile geçer (`tests/unit/olay/on_kosul_test.gd`).
  - **Bağımlılık:** `ICR-07`.
  - **Tahmini büyüklük:** `M`

- [ ] **ICR-10:** Mevsim ve yıl döngüsü varyasyonları (`Takvim` / `MevsimYoneticisi`)
  - **Amaç:** Her oyundaki ilkbahar/yaz/güz/kış geçişinin birebir aynı geçmesini önleyip yıllık doğa/iklim varyasyonlarıyla tekrar oynanabilirliği artırmak.
  - **Bugünkü durum:** `Takvim` (`src/koy/takvim.gd:8-28`) her mevsimi `mevsim_gun` güne böler ve `MevsimYoneticisi` (`src/dunya/mevsim_yoneticisi.gd`) sabit taşkın/şenlik döngüsünü işletir; ancak "Kurak Yaz", "Erken Don", "Bereketli Güz" veya "Sert Tipi" gibi yıldan yıla değişen deterministik mevsim alt-tipleri yoktur.
  - **Yapılacaklar:** `ICR-10.a` ve `ICR-10.b` ile mevsim alt-tipleri tanımlanır ve kapı/üretim/olay sistemlerine bağlanır.
  - **Dokunulacak dosyalar:** `src/dunya/mevsim_yoneticisi.gd`, `src/kapi/gelen_akisi.gd`, `src/sistemler/olay_on_kosulu.gd`, yeni `src/dunya/mevsim_varyasyonu.gd`.
  - **Kabul ölçütü:** Farklı tohum veya yıllarda aynı mevsim farklı `alt_tip` üretebilir; kış/yaz varyasyonu tüketim ve kapı sayısını ölçülebilir biçimde etkiler (`tests/unit/dunya/mevsim_varyasyonu_test.gd`).
  - **Bağımlılık:** `ICR-07`.
  - **Tahmini büyüklük:** `L`
  - **Çakışma notu:** `ROADMAP_2` `YIL-01..10` (`src/koy/yil_izi.gd`) yalnız anlatı satırı üretir ve mevsim motoruna yazmaz (`yil_izi.gd:2`); `YilIzi`'ne dokunulmaz.

  - [ ] **ICR-10.a:** `MevsimYoneticisi` içinde yıl başına deterministik mevsim alt-tipi seçicisi ve kayıt alanı
    - **Amaç:** Her yılın dört mevsimine tohum tabanlı tekil alt-tip (`olagan`, `erken_don`, `kurak`, `bereketli`, `sert_tipi`) atamak ve kayıtta saklamak.
    - **Bugünkü durum:** `MevsimYoneticisi.durum(y)` mevsim indeksini ve yılı döndürür, ancak mevsim alt-tipi alanı içermez.
    - **Yapılacaklar:** `MevsimVaryasyonu` modülünü yaz; yıl ve mevsim geçişinde deterministik alt-tip belirle, `KoyYonetimi.kaydet()` / `kayittan()` içine `KayitGocu` uyumlu sakla ve `gece()` raporuna mevsim hava satırı ekle.
    - **Dokunulacak dosyalar:** Yeni `src/dunya/mevsim_varyasyonu.gd`, `src/dunya/mevsim_yoneticisi.gd`, `src/koy/koy_yonetimi.gd` (ince adaptör).
    - **Kabul ölçütü:** Kayıt-yükleme sonrası aktif `mevsim_alt_tipi` korunur; iki farklı tohumda en az bir farklı mevsim alt-tipi üretilir (`tests/unit/dunya/mevsim_varyasyonu_test.gd`).
    - **Bağımlılık:** `ICR-07`.
    - **Tahmini büyüklük:** `M`

  - [ ] **ICR-10.b:** Mevsim alt-tiplerinin kapı kuyruğu (`GelenAkisi`), üretim/tüketim ve olay ön koşullarına bağlanması
    - **Amaç:** Değişen mevsim alt-tiplerinin oynanış kararlarını gerçekten etkilemesini sağlamak (ör. "Erken Don"da sığınmacı artışı + odun tüketimi, "Kurak Yaz"da tarla düşüşü + kuyu olayı).
    - **Bugünkü durum:** `GelenAkisi.mevsim_carpani()` (`src/kapi/gelen_akisi.gd:83`) yalnız genel mevsim indeksine bakar; `OlayOnKosulu` mevsim alt-tipini bilmez.
    - **Yapılacaklar:** `GelenAkisi.mevsim_carpani()` ve `src/dunya/mevsim_tuketim_adaptoru.gd` içine `MevsimVaryasyonu` çarpanlarını ekle; `OlayOnKosulu.uygun()` içine `mevsim_alt_tipi` filtresi tanımla.
    - **Dokunulacak dosyalar:** `src/kapi/gelen_akisi.gd`, `src/dunya/mevsim_tuketim_adaptoru.gd`, `src/sistemler/olay_on_kosulu.gd`.
    - **Kabul ölçütü:** Aynı gece ve nüfusta `"sert_tipi"` ile `"bereketli"` alt-tiplerinin odun/erzak tüketimi ve kapı kuyruğu çarpanı farklı çıkar (`tests/unit/dunya/mevsim_varyasyonu_test.gd`).
    - **Bağımlılık:** `ICR-10.a`.
    - **Tahmini büyüklük:** `M`

- [ ] **ICR-11:** 5 zafer ve 5 kayıp sonuna giden ara dönüm noktası ve yol çeşitliliği
  - **Amaç:** Her oynanışta aynı tek güvenli stratejiye kilitlenmeden, ticaret, halk sağlığı, sancak diplomasisi veya sert düzen üzerinden 5 zafer ve 5 kayıp sonuna ulaşan ara yolları çeşitlendirmek.
  - **Bugünkü durum:** `NihaiSon` (`src/sistemler/nihai_son.gd:9-50`) 5 gösterge + yozlaşma üzerinden *Tekfur Haraççısı, Ertuğrul Obası, Beyin Uç Köyü, Ahi Kasabası, Uç Tutundu* sonlarını çözer; `PerdeGecisi` (`src/koy/perde_gecisi.gd`) 18 nüfusta 2. Perdeye geçer. Ara dönemde bir oyuncuyu farklı sonlara yönlendiren dinamik dönüm noktası olayları sınırlıdır.
  - **Yapılacaklar:** 2. Perde öncesi ve sonrası için her zafer yönüne alternatif tırmanma yolu açan ara olay koşulları ve `SonucEpilogOlusturucu` (`src/sistemler/sonuc_epilog_olusturucu.gd`) içine alınan dönüm noktalarını özetleyen dinamik satır desteği ekle.
  - **Dokunulacak dosyalar:** `src/sistemler/nihai_son.gd`, `src/sistemler/sonuc_epilog_olusturucu.gd`, `src/koy/perde_gecisi.gd`, yeni `data/olaylar/*.tres` (4 dönüm noktası kartı).
  - **Kabul ölçütü:** Farklı karar örüntüleriyle koşulan simülasyonlarda en az 4 farklı zafer sonuna ulaşılabildiği kanıtlanır (`tests/unit/denge/son_yol_cesitliligi_test.gd`).
  - **Bağımlılık:** `ICR-08`, `ICR-09`, `ICR-10.b`.
  - **Tahmini büyüklük:** `M`

- [ ] **ICR-12:** Çoklu başlangıç koşulları ve senaryo kataloğu (Karar B2: hepsi 1. günden açık)
  - **Amaç:** Tekrar oynanışta oyuncuya en baştan farklı ekonomik ve diplomatik darboğazlar sunarak her seferinde yeni bir açılış bulmacası yaşatmak.
  - **Bugünkü durum:** `AcilisSenaryosu.kur(o, zorluk)` (`src/sistemler/acilis_senaryosu.gd:9`) tek sabit başlangıç kurulumu uygular; `data/baslangic/` klasörü mevcut değildir; `YeniOyunEkrani` (`src/arayuz/yeni_oyun_ekrani.gd`) yalnızca geçmiş, zorluk, yuva ve tohum seçtirir.
  - **Yapılacaklar:** `ICR-12.a` ve `ICR-12.b` ile 1. günden kilitsiz seçilebilir 3+ başlangıç senaryosu eklenir.
  - **Dokunulacak dosyalar:** Yeni `data/baslangic/*.json` (veya `.tres`), `src/sistemler/acilis_senaryosu.gd`, `src/arayuz/yeni_oyun_ekrani.gd`.
  - **Kabul ölçütü:** 3 başlangıç senaryosunun her biri 1. günden kilit olmadan seçilip farklı başlangıç kaynağı/barı ile oyun başlatır (`tests/unit/sistemler/baslangic_senaryosu_test.gd`).
  - **Bağımlılık:** `ICR-11`.
  - **Tahmini büyüklük:** `L`

  - [ ] **ICR-12.a:** `data/baslangic/` başlangıç senaryosu şeması ve 3 senaryo tanımı
    - **Amaç:** *Olağan Uç*, *Kıtlık ve Kuşatma* (düşük erzak, yüksek savunma baskısı, sert kış eşiği) ve *Kervan Kavşağı* (yüksek akçe/tüccar akışı, yüksek harami/tekfur dikkati) senaryolarını veri odaklı tanımlamak.
    - **Bugünkü durum:** Başlangıç değerleri `data/ayarlar/oyun.tres` ve `AcilisSenaryosu.kur()` içinde sabittir.
    - **Yapılacaklar:** `data/baslangic/` altına 3 senaryo dosyası oluştur; `AcilisSenaryosu.kur(o, zorluk, senaryo_id)` imzasını geriye dönük uyumlu genişlet.
    - **Dokunulacak dosyalar:** Yeni `data/baslangic/olagan_uc.json`, `data/baslangic/kitlik_kusatma.json`, `data/baslangic/kervan_kavsagi.json`, `src/sistemler/acilis_senaryosu.gd`.
    - **Kabul ölçütü:** Üç senaryonun her biri `AcilisSenaryosu.kur()` ile farklı başlangıç akçe/erzak/bar/mevsim durumu üretir (`tests/unit/sistemler/baslangic_senaryosu_test.gd`).
    - **Bağımlılık:** `ICR-11`.
    - **Tahmini büyüklük:** `M`

  - [ ] **ICR-12.b:** `YeniOyunEkrani` içine 1. günden kilitsiz açık senaryo seçicisi bağlanması (Karar B2)
    - **Amaç:** Oyuncunun herhangi bir koşulu/sonu bitirmeyi beklemeden ilk açılıştan itibaren dilediği senaryoyu seçebilmesini sağlamak.
    - **Bugünkü durum:** `YeniOyunEkrani` (`src/arayuz/yeni_oyun_ekrani.gd:5`) `baslatildi(tohum, gecmis)` sinyali yayınlar; senaryo seçimi yoktur.
    - **Yapılacaklar:** `YeniOyunEkrani`'na mevcut `ARY` yerleşimini bozmadan başlangıç senaryosu seçici satırı ekle; hiçbir kilit/açma şartı koyma (Karar B2).
    - **Dokunulacak dosyalar:** `src/arayuz/yeni_oyun_ekrani.gd`, `src/arayuz/menu_ekrani.gd` (ince sinyal adaptörü).
    - **Kabul ölçütü:** İlk açılışta 3 senaryo da etkin ve seçilebilir durumdadır; seçilen `senaryo_id` `Oturum`'a geçer (`tests/unit/arayuz/yeni_oyun_senaryo_test.gd`).
    - **Bağımlılık:** `ICR-12.a`.
    - **Tahmini büyüklük:** `S`
    - **Çakışma notu:** `ROADMAP_2` `ARY-03` ekran taşıma çalışması Berk tarafındadır; yeni oyun seçicisi mevcut düzen bozulmadan ince satır olarak eklenir.

- [ ] **ICR-13:** Sonraki gelen kişi ve günlük kuyruk dinamiğinin tüm yeni sistemlerle bütünleştirilmesi
  - **Amaç:** Başlangıç senaryoları, mevsim alt-tipleri, gecikmeli karar yankıları ve 30 karakter varyantlarının aynı günlük kapı kuyruğunda tutarlı ve dengeli biçimde çalışmasını sağlamak.
  - **Bugünkü durum:** `GelenAkisi.gunluk_sayi()` ve `kuyrugu_temizle_ve_sinirla()` (`src/kapi/gelen_akisi.gd:131, 295`) mevcut kuralları uygular; ancak yeni senaryo ağırlıkları ve mevsim alt-tipi etkileri tek akışta sınanmamıştır.
  - **Yapılacaklar:** `GelenAkisi` içindeki tüm çarpanları (senaryo + mevsim alt-tipi + karar yankısı + karakter varyant uygunluğu) tek deterministik öncelik sırasıyla birleştir ve `tavan()` aşımı olmadığını doğrula.
  - **Dokunulacak dosyalar:** `src/kapi/gelen_akisi.gd`, `src/sistemler/oturum.gd`.
  - **Kabul ölçütü:** Tüm başlangıç senaryolarında 15 gecelik kuyruk hiçbir gece boş çökme üretmez ve `GelenAkisi.tavan()` aşılmaz (`tests/unit/kapi_kuyrugu/kuyruk_butunluk_test.gd`).
  - **Bağımlılık:** `ICR-12.b`, `ICR-10.b`, `ICR-06.b`.
  - **Tahmini büyüklük:** `M`

- [ ] **ICR-14:** İçerik ve tekrar oynanabilirlik çoklu tohum dağılım doğrulaması
  - **Amaç:** Yeni eklenen tüm varyantların, olay türlerinin, mevsim alt-tiplerinin ve başlangıç senaryolarının deterministik olarak farklı oturumlar ürettiğini nicel olarak kanıtlamak.
  - **Bugünkü durum:** `tests/oto/otomatik_oyuncu.gd` tek varsayılan akışı test eder; 30 karakter varyant dağılımını, tekrar önlemeyi ve 3 senaryoyu kıyaslayan bir dağılım testi yoktur.
  - **Yapılacaklar:** 3 başlangıç senaryosu × 10 tohum = 30 hızlı simülasyon koşturan birim/duman testi yaz; ardışık olay tekrarı olmadığını, 30 karakterin varyantlarının tetiklendiğini ve en az 3 farklı son sınıfına gidildiğini doğrula.
  - **Dokunulacak dosyalar:** Yeni `tests/unit/olay/tekrar_oynanabilirlik_test.gd`.
  - **Kabul ölçütü:** `tekrar_oynanabilirlik_test.gd` 30 simülasyonda `0` çökme, `0` ardışık aynı olay ve ölçülebilir varyant çeşitliliği raporuyla `quit(0)` döner.
  - **Bağımlılık:** `ICR-13`.
  - **Tahmini büyüklük:** `S`

---

## Bölüm C — Oyun Testi ve Yerel Telemetri (`TEL`)

Bölüm B'de zenginleştirilen içerik ve senaryoların gerçek playtester oturumlarında dengesini ölçmek için **tamamen yerel, ağ çıkışı olmayan** bir telemetri katmanı kurulur. Karar `C1` uyarınca yalnız playtest derlemesinde ilk açılışta tek soruluk onay penceresi açılır (tam sürüm davranışı sonraya bırakılır); Karar `C2` uyarınca veriler `user://telemetri/` altına yazılır ve Ayarlar ekranından tek düğmeyle klasörde açılabilir. `ROADMAP_3` `SVS-49.b` (`senaryo_kosucusu`) ve `SVS-50` kopyalanmaz.

**Bölüm bitiş ölçütü:** Playtest derlemesi ilk açılışta tek soruluk onay ister; izin veren oyuncunun kapı/olay/bırakma/son verisi `user://telemetri/` altına JSONL yazılır; Ayarlar'daki "Test raporunu klasörde göster" düğmesi çalışır ve `tools/denge_raporu.py` denge özetini hatasız üretir.

- [ ] **TEL-01:** Yerel telemetri veri şeması, gizlilik sınırı ve `ayarlar.cfg` anahtarı
  - **Amaç:** Hiçbir kişisel kimlik veya ağ bağlantısı kullanmadan yalnız oyun dengesi için gereken anonim yerel JSONL şemasını sabitlemek.
  - **Bugünkü durum:** `src/debug/denge_gunlugu.gd` (`DengeGunlugu`, satır 1–33) yalnız sahnede `PerformansGunlugu` varsa dev-only çıktı yazar; `src/sistemler/ayarlar.gd` içinde oyuncu izinli bir `yerel_telemetri` anahtarı yoktur.
  - **Yapılacaklar:** `Ayarlar.VARSAYILAN` ve `GECERLI` içine `&"yerel_telemetri"` (üç durum: `&"sorulmadi"`, `&"acik"`, `&"kapali"` — playtest dışındaki derlemelerde kayıt yazmaz; *Not: Tam sürüm varsayılanı "Sonraya bırakılanlar" listesinde tutulur*) ekle; `user://telemetri/oturum_<timestamp>_<tohum>.jsonl` şemasını (`surum`, `senaryo_id`, `gece`, `olaylar`, `kararlar`, `kaynaklar`, `son`, `birakma_nedeni`) tanımla.
  - **Dokunulacak dosyalar:** `src/sistemler/ayarlar.gd`, yeni `src/sistemler/yerel_telemetri.gd`.
  - **Kabul ölçütü:** İzin `kapali` iken `user://telemetri/` altına `0` dosya yazılır; `acik` iken yalnız geçerli JSONL satırları yazılır (`tests/unit/sistemler/yerel_telemetri_test.gd`).
  - **Bağımlılık:** `TST-08`, `ICR-14`.
  - **Tahmini büyüklük:** `S`

- [ ] **TEL-02:** Playtest ilk açılış tek soruluk onay penceresi (Karar C1)
  - **Amaç:** Playtesterlardan açık ve anlaşılır tek soruluk rıza alarak veri toplamayı başlatmak; hayır denirse hiç kayıt tutmamak.
  - **Bugünkü durum:** `src/sistemler/oyuncu_surumu.gd` (`OyuncuSurumu`) debug/perf argümanlarını ayrıştırır, ancak ana menüde playtest telemetri rızası soran bir pencere yoktur.
  - **Yapılacaklar:** `OyuncuSurumu` içine `playtest_mi()` yardımcısı ekle (feature `playtest` veya env `KAPI_PLAYTEST=1`); ana menü açılışında `&"yerel_telemetri" == &"sorulmadi"` ve `playtest_mi()` ise tek soruluk, iki düğmeli ("Evet, yerel günlük tut" / "Hayır, tutma") küçük onay penceresi göster ve seçimi `user://ayarlar.cfg`'ye yaz. *(Tam sürüm davranışı sonraya bırakıldı.)*
  - **Dokunulacak dosyalar:** `src/sistemler/oyuncu_surumu.gd`, `src/arayuz/menu_ekrani.gd`, yeni `src/arayuz/telemetri_onay_paneli.gd`, `data/metin/metinler.csv`.
  - **Kabul ölçütü:** İlk playtest açılışında onay penceresi görünür, seçim sonrası `&"sorulmadi"` durumu değişir ve ikinci açılışta pencere tekrar çıkmaz (`tests/unit/arayuz/telemetri_onay_test.gd`).
  - **Bağımlılık:** `TEL-01`.
  - **Tahmini büyüklük:** `M`
  - **Çakışma notu:** `ROADMAP_2` `ARY` tema düzeni Berk tarafındadır; yeni panel `Tema` sabitleriyle düz ve izole kurulur.

- [ ] **TEL-03:** Kapı kararları, olay seçimleri ve bırakma noktası telemetri adaptörü
  - **Amaç:** Oyuncuların hangi gecede oyunu bıraktığını, hangi olay seçiminin ve hangi kapı kararının ekonomiyi kırdığını oturum sonu + ara kayıtlarla yakalamak.
  - **Bugünkü durum:** `DengeGunlugu` (`src/debug/denge_gunlugu.gd`) yalnız gece sonu `DengeOlcumu.olustur()` çıktısını işler; kapı sırasındaki bireysel kabul/ret/rüşvet kararlarını, erken pencere kapatmayı (`WM_CLOSE_REQUEST`) ve varılan sonu bağımsız telemetri oturumuna yazmaz.
  - **Yapılacaklar:** `TEL-03.a` ve `TEL-03.b` ile `DengeGunlugu` / `Oturum` sinyallerine ince dinleyici bağlanır.
  - **Dokunulacak dosyalar:** `src/sistemler/yerel_telemetri.gd`, `src/debug/denge_gunlugu.gd` (yalnız şema paylaşımı), `src/arayuz/ana.gd` (tek satırlık yaşam döngüsü kancası).
  - **Kabul ölçütü:** Örnek bir 5 gecelik oturum + erken çıkışta tüm kararlar ve bırakma gecesi eksiksiz JSONL satırı olarak doğrulanır (`tests/unit/sistemler/yerel_telemetri_akisi_test.gd`).
  - **Bağımlılık:** `TEL-02`, `ICR-12.a`.
  - **Tahmini büyüklük:** `M`
  - **Çakışma notu:** `src/arayuz/ana.gd` `AGENTS.md` §2 korumalı çekirdek dosyadır (yalnız tek satırlık çıkış/oturum adaptörü). `ROADMAP_3` `SVS-49.b` (`senaryo_kosucusu.gd`) dosyasına dokunulmaz.

  - [ ] **TEL-03.a:** Kapı kararı ve olay seçimi dinleyici adaptörü (`YerelTelemetri`)
    - **Amaç:** `Oturum.karar_ver()`, `Oturum.olay_uygula()` ve `Oturum.gece_sonu()` verilerini `user://telemetri/` dosyasına satır satır eklemek.
    - **Bugünkü durum:** `YerelTelemetri` (`TEL-01`) henüz oyun döngüsü çağrılarına bağlı değildir.
    - **Yapılacaklar:** `Oturum` ve `KoyYonetimi` mevcut sinyallerini/sonuç sözlüklerini bozmadan tek noktadan dinleyen adaptör yaz; aynı gece içindeki kararları (`karar`, `tansiyon`, `secilen_olay_id`, `senaryo_id`) tamponlayıp her gece atomik ekle (`FileAccess`).
    - **Dokunulacak dosyalar:** `src/sistemler/yerel_telemetri.gd`, `src/arayuz/kapi_ekrani.gd` veya `src/arayuz/ana.gd` (en az temasla).
    - **Kabul ölçütü:** Kapı kararı + olay seçimi sonrası JSONL dosyasında ilgili anahtarlar doğru değerle okunur (`tests/unit/sistemler/yerel_telemetri_akisi_test.gd`).
    - **Bağımlılık:** `TEL-02`, `ICR-12.a`.
    - **Tahmini büyüklük:** `M`

  - [ ] **TEL-03.b:** Erken çıkış (bırakma noktası) ve varılan son kaydı
    - **Amaç:** Oyuncunun oyunu tamamlamadan kapattığı veya menüye döndüğü geceyi/sahneyi ve oyunu bitiren 5 zafer / 5 kayıp sonunu kaydetmek.
    - **Bugünkü durum:** `Oturum.son_verisi_isle()` (`src/sistemler/oturum.gd:967`) son verisini işler ama bırakma noktası izlemez.
    - **Yapılacaklar:** Pencere kapatma (`NOTIFICATION_WM_CLOSE_REQUEST`), menüye çıkış ve `son_verisi_isle()` anında `birakma_noktasi` (`gece`, `faz`, `son_id`) satırını diske güvenli yaz.
    - **Dokunulacak dosyalar:** `src/sistemler/yerel_telemetri.gd`, `src/arayuz/ana.gd` (ince çıkış sinyali).
    - **Kabul ölçütü:** Hem erken çıkışta hem de zafer/kayıp sonu tetiklendiğinde son JSONL satırı `birakma_noktasi` veya `varilan_son` içerir (`tests/unit/sistemler/yerel_telemetri_akisi_test.gd`).
    - **Bağımlılık:** `TEL-03.a`.
    - **Tahmini büyüklük:** `S`

- [ ] **TEL-04:** Ayarlar ekranında "Test raporunu klasörde göster" düğmesi (Karar C2)
  - **Amaç:** Playtesterların `user://telemetri/` yolunu işletim sisteminde elle aramadan tek tıkla klasörü açıp rapor dosyasını paylaşabilmesini sağlamak.
  - **Bugünkü durum:** `AyarlarEkrani` (`src/arayuz/ayarlar_ekrani.gd`) içinde dosya klasörü açan bir düğme yoktur.
  - **Yapılacaklar:** `user://telemetri/` klasörünü gerektiğinde oluşturan (`DirAccess.make_dir_recursive_absolute`), dosya sayısını gösteren ve tıklandığında `OS.shell_open(ProjectSettings.globalize_path("user://telemetri"))` çağıran (headless testte güvenli atlanan) düğmeyi Ayarlar'a ekle.
  - **Dokunulacak dosyalar:** `src/arayuz/ayarlar_ekrani.gd`, `src/sistemler/yerel_telemetri.gd`, `data/metin/metinler.csv`.
  - **Kabul ölçütü:** `AyarlarEkrani` testinde düğme var, hedef yol `ProjectSettings.globalize_path("user://telemetri")` ile eşleşiyor ve dosya sayısı doğru güncelleniyor (`tests/unit/arayuz/ayarlar_telemetri_dugmesi_test.gd`).
  - **Bağımlılık:** `TEL-01`.
  - **Tahmini büyüklük:** `S`
  - **Çakışma notu:** `ROADMAP_2` `ARY` görsel teması Ayarlar ekranına sonradan uyarlanabilir; yeni düğme mevcut satır düzenine eklenir.

- [ ] **TEL-05:** Otomatik denge ve bırakma noktası analiz aracı (`tools/denge_raporu.py`)
  - **Amaç:** Toplanan onlarca yerel JSONL oturumunu tek komutla okunabilir bir denge ve darboğaz raporuna dönüştürmek.
  - **Bugünkü durum:** Repoda `user://telemetri/*.jsonl` oturumlarını toplu analiz edip bırakma/son dağılımı çıkaran bir Python betiği yoktur.
  - **Yapılacaklar:** `TEL-05.a` ve `TEL-05.b` ile Python raporlayıcı ve birim testleri yazılır.
  - **Dokunulacak dosyalar:** Yeni `tools/denge_raporu.py`, yeni `tests/py/test_denge_raporu.py`.
  - **Kabul ölçütü:** Sentetik 10 oturumluk JSONL dizini verildiğinde hatasız özet raporu üretilir (`tests/py/test_denge_raporu.py`).
  - **Bağımlılık:** `TEL-03.b`.
  - **Tahmini büyüklük:** `M`

  - [ ] **TEL-05.a:** JSONL oturum okuyucu, 5+5 son dağılımı ve bırakma gecesi histogramı
    - **Amaç:** Kaç oturumun hangi gecede bittiğini, 5 zafer / 5 kayıp dağılımını ve ortalama oturum süresini çıkarmak.
    - **Bugünkü durum:** Yalnız ham `DengeOlcumu.son_dagilimi_oku()` (`src/sistemler/denge_olcumu.gd:144`) vardır.
    - **Yapılacaklar:** `tools/denge_raporu.py` içine JSONL okuyucu, bozuk satır atlayıcı ve son/bırakma histogramı hesaplayıcısını yaz.
    - **Dokunulacak dosyalar:** Yeni `tools/denge_raporu.py`.
    - **Kabul ölçütü:** Çeşitli sonlar ve erken çıkışlar içeren test dosyalarında toplam oturum, zafer/kayıp oranı ve tepe bırakma gecesi doğru hesaplanır (`tests/py/test_denge_raporu.py`).
    - **Bağımlılık:** `TEL-03.b`.
    - **Tahmini büyüklük:** `M`

  - [ ] **TEL-05.b:** Senaryo bazlı darboğaz kaynağı ve karar eğilimi Markdown/CSV özeti
    - **Amaç:** *Kıtlık ve Kuşatma* vs *Kervan Kavşağı* senaryolarında hangi gecede erzak/akçe/huzur çöküşü yaşandığını ve hangi olay seçeneğinin ezici biçimde tercih edildiğini görmek.
    - **Bugünkü durum:** Senaryo bazlı kıyaslama aracı mevcut değildir.
    - **Yapılacaklar:** `tools/denge_raporu.py` çıktısına `senaryo_id` gruplaması, kaynak medyan eğrisi ve baskın olay seçeneği uyarısı ekle.
    - **Dokunulacak dosyalar:** `tools/denge_raporu.py`, `tests/py/test_denge_raporu.py`.
    - **Kabul ölçütü:** En az 2 farklı `senaryo_id` içeren örnek veri üzerinde grup bazlı darboğaz ve olay seçim oranları doğru çıkar (`tests/py/test_denge_raporu.py`).
    - **Bağımlılık:** `TEL-05.a`.
    - **Tahmini büyüklük:** `S`

- [ ] **TEL-06:** Playtest ön-denge turu ve `denge.json` / `oyun.tres` sınır doğrulaması
  - **Amaç:** Bölüm B içeriklerinin ve 3 başlangıç senaryosunun oyun ekonomisini kırmadığını telemetri + simülasyon raporuyla ilk kez doğrulamak.
  - **Bugünkü durum:** `data/ayarlar/denge.json`, `denge_sinirlari.json` ve `oyun.tres` mevcut değerlerle kalmıştır; `ICR` varyant ve senaryolarından sonra henüz sınanmamıştır.
  - **Yapılacaklar:** `ICR-14` simülasyonlarından + örnek playtest JSONL çıktılarından `tools/denge_raporu.py` çalıştır; tespit edilen imkânsız açılış/ekonomi patlamalarını `DengeSinirDenetimi` sınırları içinde ayarla.
  - **Dokunulacak dosyalar:** `data/ayarlar/denge.json`, `data/ayarlar/oyun.tres`, yeni rapor notu `docs/denetim/roadmap4_on_denge.md`.
  - **Kabul ölçütü:** `tests/unit/denge/denge_sinir_denetimi_test.gd` ve `tekrar_oynanabilirlik_test.gd` `0` sınır aşımı ile geçer.
  - **Bağımlılık:** `TEL-05.b`, `TEL-04`.
  - **Tahmini büyüklük:** `M`

---

## Bölüm D — Ses ve Müzik (`SES`)

Karar `D1` gereği **ses üretimi kesinlikle yasaktır**; yalnızca mevcut **73** ses dosyası seviye/tutarlılık açısından dengelenir ve eksik yerler için **CC0 / CC-BY** açık lisanslı hazır ses/müzik seçilip kaynak+lisans kaydı tutulur. Karar `D2` gereği `Master` altında `Muzik`, `Efekt` ve `Ortam` olmak üzere 3 ayrı bus ile Ayarlar'da üç ayrı kaydırıcı bulunur. `src/sistemler/ses.gd` korumalı çekirdek dosya olduğundan değişiklikler ince adaptör ve yeni dosyalarla (`src/ses/`, `src/sistemler/muzik_yonetmeni.gd`) yapılır; `ROADMAP_3` `SVS-47` (`K16`) savaş ses yer tutucusuna dokunulmaz.

**Bölüm bitiş ölçütü:** Mevcut 73 ses ve yeni eklenen tüm CC0/CC-BY seslerin lisans/atıf kaydı tamdır; ses düzeyleri tutarlıdır; `Master -> Muzik, Efekt, Ortam` 3 bus ve Ayarlar kaydırıcıları çalışır; uyarlanabilir müzik ve ortam döngüleri sahne/durum geçişlerinde hatasız çapraz geçiş yapar.

- [ ] **SES-01:** Mevcut 73 ses dosyası envanteri, lisans kaydı ve seviye/tutarlılık denetimi (Karar D1)
  - **Amaç:** Yeni dosya eklemeden önce eldeki seslerin hangilerinin oyunda kullanıldığını, hangilerinin aşırı yüksek/alçak (clip/fısıltı) çaldığını ve hangilerinin lisans kaydının eksik olduğunu netleştirmek.
  - **Bugünkü durum:** `assets/ses/` altında kök klasörde 39 ve 8 alt klasörde (`cici`, `cyrex`, `heyhey`, `heyhey_savas`, `kenney_rpg`, `quendel`, `rpg_sound`, `rubberduck`) olmak üzere toplam **73** ham ses dosyası (`.import` hariç) vardır. `src/ses/hazir_ses_kaynaklari.gd` hazır ses yönlendirmesi yapar, ancak tüm 73 dosya için dB/LUFS tutarlılık tablosu yoktur.
  - **Yapılacaklar:** `SES-01.a` ve `SES-01.b` ile lisans/eksik listesi ve ses seviyesi denge tablosu çıkarılır.
  - **Dokunulacak dosyalar:** `docs/EKSIK_ASSET_ENVANTERI.md`, `docs/credits/HAZIR_ASSET_ATIFLARI.md`, yeni `data/ses/ses_denge_tablosu.json`.
  - **Kabul ölçütü:** 73 dosyanın tamamı envanterde ve dB kazanç (gain offset) tablosunda kayıtlıdır (`tests/unit/ses/ses_test.gd`).
  - **Bağımlılık:** `TST-08`.
  - **Tahmini büyüklük:** `M`

  - [ ] **SES-01.a:** 73 ses dosyasının tam envanteri ve eksik/lisans boşluklarının kaydı
    - **Amaç:** Hangi olay/arayüz/mevsim için eldeki sesin yettiğini, hangisi için CC0/CC-BY hazır ses aranacağını saptamak.
    - **Bugünkü durum:** `src/sistemler/ses.gd` ve `src/ses/hazir_ses_kaynaklari.gd` içinde kullanılan anahtarlar ile `assets/ses/` altındaki 73 dosyanın eşleşmesi dağınıktır.
    - **Yapılacaklar:** Tüm kodda çağrılan `Ses.cal()`, `Ses.oynat()`, `Ses.muzik_cal()`, `Ses.ortam_cal()` anahtarlarını tara; eldeki 73 dosya ile eşleştir; açıkta kalan ihtiyaçları ve lisansı doğrulanmamış dosyaları `docs/EKSIK_ASSET_ENVANTERI.md` + `docs/credits/HAZIR_ASSET_ATIFLARI.md` dosyalarına işle.
    - **Dokunulacak dosyalar:** `docs/EKSIK_ASSET_ENVANTERI.md`, `docs/credits/HAZIR_ASSET_ATIFLARI.md`.
    - **Kabul ölçütü:** Kodda çağrılan `0` yetim ses anahtarı belirsiz kalır; her hazır ses için yazar/bağlantı/lisans satırı mevcuttur.
    - **Bağımlılık:** `TST-08`.
    - **Tahmini büyüklük:** `S`

  - [ ] **SES-01.b:** Mevcut 73 ses dosyası için dB/LUFS seviye ölçümü ve tutarlılık dengelemesi
    - **Amaç:** Bir efektin kulak tırmalayıp ötekinin hiç duyulmaması sorununu ses dosyası sentezlemeden yazılımsal kazanç telafisiyle (veya lossless/WAV normalize politikasına uygun dB tablosuyla) çözmek.
    - **Bugünkü durum:** `Ses.oynat(ad, db)` (`src/sistemler/ses.gd:187`) sabit `0.0` dB varsayılanı kullanır; kaynak dosyalar arası peak/RMS farkını eşitleyen bir tablo yoktur.
    - **Yapılacaklar:** 73 dosyanın tepe/RMS dB ölçümünü çıkaran salt-okunur Python taraması yap (`tools/ses_seviye_olc.py`); `data/ses/ses_denge_tablosu.json` içine anahtar başına `db_ofset` yaz ve `Ses` / `HazirSesKaynaklari` adaptörüyle oynatma anında uygula. *(Not: Yeni ses üretilmez.)*
    - **Dokunulacak dosyalar:** Yeni `tools/ses_seviye_olc.py`, yeni `data/ses/ses_denge_tablosu.json`, `src/ses/hazir_ses_kaynaklari.gd`.
    - **Kabul ölçütü:** Tüm 73 ses dosyası için `db_ofset` değerleri `[-18, +6]` dB güvenli aralığındadır ve `0` dBFS üzeri kırpma (clipping) yoktur (`tests/unit/ses/ses_seviye_tablosu_test.gd`).
    - **Bağımlılık:** `SES-01.a`.
    - **Tahmini büyüklük:** `M`

- [ ] **SES-02:** Üç ayrı ses bus'ı (`Master -> Muzik, Efekt, Ortam`) ve Ayarlar kaydırıcıları (Karar D2)
  - **Amaç:** Oyuncunun meşale, rüzgâr, kalabalık gibi sürekli ortam seslerini silah/mühür/uyarı efektlerinden bağımsız kısabilmesini sağlamak.
  - **Bugünkü durum:** `src/sistemler/ayarlar.gd` satır 9 ve 22'de yalnızca `&"ses_ana": 8`, `&"ses_muzik": 7`, `&"ses_efekt": 8` ve `BUSLAR := {&"ses_ana": "Master", &"ses_muzik": "Muzik", &"ses_efekt": "Efekt"}` vardır. `src/sistemler/ses.gd` satır 153–159'da `ortam_busunu_ayarla()` zaten mevcuttur ama varsayılan bus `Efekt`'tir.
  - **Yapılacaklar:** Godot varsayılan bus düzenine (veya `Ses` başlangıç bus kurulumuna ince adaptörle) `Ortam` bus'ını `Master` altında ekle; `Ses` başlatıldığında `ortam_busunu_ayarla(&"Ortam")` uygula; `Ayarlar.VARSAYILAN` ve `BUSLAR` içine `&"ses_ortam": 7` ekle; `AyarlarEkrani` (`src/arayuz/ayarlar_ekrani.gd`) içine üçüncü ses kaydırıcısını bağla ve `user://ayarlar.cfg` ile kalıcı yap.
  - **Dokunulacak dosyalar:** `default_bus_layout.tres` (veya `src/ses/ses_bus_kurulumu.gd`), `src/sistemler/ses.gd` (yalnız tek satırlık adaptör), `src/sistemler/ayarlar.gd`, `src/arayuz/ayarlar_ekrani.gd`, `data/metin/metinler.csv`.
  - **Kabul ölçütü:** `AudioServer` içinde `Master`, `Muzik`, `Efekt`, `Ortam` bus'ları bulunur; `AyarlarEkrani`'nda 3 ayrı ses kaydırıcısı değer değişimini bus dB'sine yansıtır (`tests/unit/ses/ses_bus_ayar_test.gd`).
  - **Bağımlılık:** `SES-01.b`.
  - **Tahmini büyüklük:** `M`
  - **Çakışma notu:** `src/sistemler/ses.gd` korumalı çekirdek dosyadır; yeniden yazılmaz, yalnız `Ortam` bus yönlendirmesi eklenir.

- [ ] **SES-03:** CC0 / CC-BY açık lisanslı eksik müzik ve ortam paketlerinin seçimi ve bağlanması (Karar D1)
  - **Amaç:** Menü, gündüz köy, kış/kriz gerilimi ve temel UI etkileşimlerinde eksik kalan ses boşluklarını telifsiz açık lisanslı kaynaklarla doldurmak.
  - **Bugünkü durum:** `assets/ses/` altında `muzik_gece_dongu.wav`, `muzik_dugun_dongu.wav`, `muzik_chr_sakin/gergin/panik.wav`, `ortam_koy_gunduz/gece/dongu.wav`, `ortam_mesale_dongu.wav` vardır; ancak ana menü/gündüz köy/kış temalı ayrı döngüler ile bazı UI/olay sesleri eksiktir (`SES-01.a`). `OZL-31` gereği ses/müzik üretimi yapılmaz.
  - **Yapılacaklar:** `SES-01.a`'da belirlenen boşluklar için 13. yy Anadolu atmosferine uygun (abartısız enstrümantal/doğal — kılıç, meşale, rüzgâr, ahşap/parşömen, dönemsel yaylı/vurmalı) CC0/CC-BY hazır dosyaları indir; `assets/ses/hazir_.../` altına koy, `src/ses/hazir_ses_kaynaklari.gd` ve `ses_denge_tablosu.json` ile eşle; her dosyanın kaynak URL, yazar, lisans ve gerekiyorsa atıf metnini `docs/credits/HAZIR_ASSET_ATIFLARI.md` ile `docs/EKSIK_ASSET_ENVANTERI.md`'ye yaz. *(Ses sentezi/üretimi kesinlikle yapılmaz.)*
  - **Dokunulacak dosyalar:** Yeni CC0/CC-BY ses dosyaları (`assets/ses/`), `src/ses/hazir_ses_kaynaklari.gd`, `data/ses/ses_denge_tablosu.json`, `docs/credits/HAZIR_ASSET_ATIFLARI.md`, `docs/EKSIK_ASSET_ENVANTERI.md`.
  - **Kabul ölçütü:** Her yeni eklenen ses dosyası headless importtan `0` hata ile geçer, `ses_denge_tablosu.json` içinde kazancı tanımlıdır ve `HAZIR_ASSET_ATIFLARI.md` içinde CC0/CC-BY lisans kaydı vardır.
  - **Bağımlılık:** `SES-02`.
  - **Tahmini büyüklük:** `M`

- [ ] **SES-04:** Uyarlanabilir müzik yönetmeni (`MuzikYonetmeni`)
  - **Amaç:** Sabit tek parça çalmak yerine oyunun temposuna (menü, gündüz yönetim, sorgu gerilimi, gece raporu, kış/kıtlık krizi) göre akıcı crossfade geçişleri sunmak.
  - **Bugünkü durum:** `Ses.muzik_cal()` (`src/sistemler/ses.gd:111`) `GECIS := 1.5` saniyelik crossfade destekler ve `TansiyonMuzigi` (`src/sistemler/tansiyon_muzigi.gd`) sorgu tansiyonunu takip eder; ancak menü → kapı → köy → gece → kış arası genel müzik durum makinesi yoktur.
  - **Yapılacaklar:** `SES-04.a` ve `SES-04.b` ile merkezi `MuzikYonetmeni` durum makinesi kurulur.
  - **Dokunulacak dosyalar:** Yeni `src/sistemler/muzik_yonetmeni.gd`, `src/sistemler/tansiyon_muzigi.gd`, `src/arayuz/menu_ekrani.gd`, `src/arayuz/koy_ekrani.gd` (tek satırlık durum bildirimi).
  - **Kabul ölçütü:** Sahne/durum değişimlerinde çakışan iki müzik kalmaz, `Ses.muzik_adi()` beklenen parçaya geçer (`tests/unit/ses/muzik_yonetmeni_test.gd`).
  - **Bağımlılık:** `SES-03`.
  - **Tahmini büyüklük:** `L`
  - **Çakışma notu:** `src/arayuz/koy_ekrani.gd` korumalı çekirdek dosyadır (yalnız tek satırlık bildirim); `ROADMAP_3` `SVS-47` (`K16`) savaş yer tutucusuna dokunulmaz.

  - [ ] **SES-04.a:** Durum makinesi (Menü, Gündüz Köy, Kapı Sorgu, Gece Raporu, Mevsim/Kriz) crossfade bağlantısı
    - **Amaç:** Oyun durumu değiştiğinde `MuzikYonetmeni.durum_ayarla(durum)` üzerinden uygun döngüye 1.5 sn crossfade ile geçmek.
    - **Bugünkü durum:** `OturumFazi` ve `Takvim.kis_mi()` durumları mevcuttur ama müzik yöneticisine bağlı değildir.
    - **Yapılacaklar:** `MuzikYonetmeni` durum öncelik tablosunu (`olay_ozel > kriz/kis > sorgu_tansiyon > gece > gunduz > menu`) yaz; aynı parça çalıyorsa yeniden başlatma yapma.
    - **Dokunulacak dosyalar:** Yeni `src/sistemler/muzik_yonetmeni.gd`, `src/sistemler/tansiyon_muzigi.gd`.
    - **Kabul ölçütü:** Öncelik sıralaması ve aynı durumun gereksiz restart atmaması birim testte geçer (`tests/unit/ses/muzik_yonetmeni_test.gd`).
    - **Bağımlılık:** `SES-03`.
    - **Tahmini büyüklük:** `M`

  - [ ] **SES-04.b:** `OlayVerisi.muzik` kart müziği ve savaş yer tutucu kancası (`K16` uyumlu)
    - **Amaç:** Düğün/harman gibi özel olay kartları açıldığında kartın kendi müziğini (`OlayVerisi.muzik`) çalıp kapanınca önceki durum müziğine yumuşak dönmek; savaş tarafına sessiz uyumlu kanca bırakmak.
    - **Bugünkü durum:** `OlayVerisi` satır 20–21 `muzik: StringName` taşır; kart kapandığında önceki müziğe dönüşü yöneten yığın yoktur.
    - **Yapılacaklar:** `MuzikYonetmeni.gecici_muzik_it(ad)` / `cikar()` yığınını yaz; `ROADMAP_3` `SVS-47` koduna dokunmadan dışarıdan çağrılabilecek salt arayüz bırak.
    - **Dokunulacak dosyalar:** `src/sistemler/muzik_yonetmeni.gd`, olay kartı sunucusu (`src/arayuz/gece_raporu_kisa.gd` veya ilgili kart paneli).
    - **Kabul ölçütü:** Özel olay kartı açılıp kapandığında müzik önce kart müziğine geçer, ardından önceki durum müziğine döner (`tests/unit/ses/muzik_yonetmeni_test.gd`).
    - **Bağımlılık:** `SES-04.a`.
    - **Tahmini büyüklük:** `S`
    - **Çakışma notu:** `ROADMAP_3` `SVS-47` (`K16`) savaş içi ses yer tutucusuna dokunulmaz.

- [ ] **SES-05:** Gündüz/gece ve mevsim ortam ses katmanı (`Ortam` bus'ı)
  - **Amaç:** Kapıda meşale/rüzgâr, köyde gündüz uğultu/dere, gece/kışta ise soğuk rüzgâr/baykuş döngüsüyle mekân atmosferini güçlendirmek.
  - **Bugünkü durum:** `src/sistemler/koy_ortam_sesi.gd` ve `ortam_koy_gunduz.wav`, `ortam_koy_gece.wav`, `ortam_mesale_dongu.wav`, `assets/ses/quendel/dere_dongu.ogg` mevcuttur; ancak `SES-02` `Ortam` bus'ına ve `ICR-10` mevsim alt-tiplerine bağlı tam döngü haritası yoktur.
  - **Yapılacaklar:** `KoyOrtamSesi` içini `Ortam` bus'ına yönlendir; `Takvim.kis_mi()` ve `MevsimVaryasyonu` (`ICR-10.a`) durumuna göre ortam döngüsü seç (`Ses.ortam_cal()`).
  - **Dokunulacak dosyalar:** `src/sistemler/koy_ortam_sesi.gd`, `src/sistemler/ses.gd` (yalnız zaten var olan `ortam_cal` API'si kullanılır).
  - **Kabul ölçütü:** Kapı, gündüz köy, gece köy ve kış modlarında `Ses.ortam_adi()` farklı ortam döngülerine geçer ve `Ortam` bus'ından çalar (`tests/unit/ses/ortam_sesi_test.gd`).
  - **Bağımlılık:** `SES-02`, `SES-03`, `ICR-10.a`.
  - **Tahmini büyüklük:** `M`

- [ ] **SES-06:** Arayüz, mühür ve kapı/köy karar sesleri eşlemesi
  - **Amaç:** Oyuncunun her düğme, sayfa çevirme, mühür basma ve akçe kesesi işleminde net işitsel geri bildirim almasını sağlamak.
  - **Bugünkü durum:** `src/sistemler/guvenli_ses_cagrisi.gd`, `src/arayuz/muhur.gd` ve `src/ses/hazir_ses_kaynaklari.gd` temel sesleri taşır; ancak bazı yeni paneller (`heyet_kapi_paneli.gd`, `ayarlar_ekrani.gd`, `yeni_oyun_ekrani.gd`) sessiz kalmakta veya eksik anahtar çağırmaktadır.
  - **Yapılacaklar:** UI etkileşim ses tablosunu (`ui_tik`, `ui_sayfa`, `ui_muhur_onay`, `ui_muhur_ret`, `ui_kese_akce`, `ui_uyari`) `HazirSesKaynaklari` ve `GuvenliSesCagrisi` üzerinden ilgili panellere bağla.
  - **Dokunulacak dosyalar:** `src/ses/hazir_ses_kaynaklari.gd`, `src/arayuz/muhur.gd`, `src/arayuz/ayarlar_ekrani.gd`, `src/arayuz/yeni_oyun_ekrani.gd`, `src/arayuz/heyet_kapi_paneli.gd`.
  - **Kabul ölçütü:** Tüm tanımlı UI ses anahtarları `Ses.oynat()` içinde `true` (headless dahil) döner (`tests/unit/ses/ui_ses_test.gd`).
  - **Bağımlılık:** `SES-03`.
  - **Tahmini büyüklük:** `M`

- [ ] **SES-07:** Ses karışımı (mix), sorgu ducking'i ve ses bütünlük testi
  - **Amaç:** Aynı anda müzik + ortam + efekt çalarken seslerin birbirini boğmamasını ve `ayarlar.cfg` ile her açılışta doğru mix'le başlamasını sağlamak.
  - **Bugünkü durum:** `Ses.oynat()` maksimum `ES_ZAMANLI := 6` oyuncu kullanır (`src/sistemler/ses.gd`); ancak yüksek tansiyonlu sorguda veya uyarı efekti çalarken `Ortam` bus'ını kısa süreli kısan bir ducking kuralı yoktur.
  - **Yapılacaklar:** `MuzikYonetmeni` veya `src/ses/ses_karisim.gd` içinde sorgu yüksek tansiyonunda `Ortam` sesini `-4` dB yumuşatan tween ekle; `ayarlar.cfg` ile `Muzik/Efekt/Ortam` ayarlarının çakışmadığını doğrula (`kullanıcı bus ayarı korunur`).
  - **Dokunulacak dosyalar:** Yeni `src/ses/ses_karisim.gd`, `src/sistemler/muzik_yonetmeni.gd`, `tests/unit/ses/ses_test.gd`.
  - **Kabul ölçütü:** `tests/unit/ses/ses_test.gd` ve yeni `ses_karisim_test.gd` kullanıcı bus değerlerini ezmeden ducking uygulandığını doğrular ve `0` hata ile geçer.
  - **Bağımlılık:** `SES-04.b`, `SES-05`, `SES-06`.
  - **Tahmini büyüklük:** `S`

---

## Bölüm E — Paketleme ve Bağımsız Windows Demo (`PKT`)

Karar `E1` uyarınca Steamworks, başarımlar ve Steam Cloud bu aşamaya **girmez** ("Sonraya bırakılanlar"dadır); `PKT` bölümü yalnız **bağımsız (DRM-free) Windows demo paketini** ve temel tam sürüm export metadata'sını kapsar. Karar `E2` gereği uygulama ikonu ajan tarafından üretilmez: ajan yalnız `docs/EKSIK_ASSET_ENVANTERI.md`'ye Nano Banana promptu yazar ve Ahmet'in insan eliyle `.ico`'ya çevirdiği hazır dosyayı `export_presets.cfg`'ye bağlar.

**Bölüm bitiş ölçütü:** `docs/EKSIK_ASSET_ENVANTERI.md` ikon promptunu içerir ve hazır `.ico` `export_presets.cfg`'ye bağlıdır; `[preset.0]` tam sürüm ve `[preset.1]` DRM-free Windows Demo ön ayarları doldurulmuştur; `DemoKesiti` sınırı ve headless demo export duman testi `0` hata ile geçer.

- [ ] **PKT-01:** Uygulama ikonu Nano Banana promptu ve hazır `.ico` bağlantı kancası (Karar E2)
  - **Amaç:** Godot'nun varsayılan robot ikonu yerine 13. yy Selçuklu uç kapısı kimliğini taşıyan özgün uygulama ikonunun `.ico` bağlantısını hazırlamak.
  - **Bugünkü durum:** `export_presets.cfg` satır 18'de `application/icon=""` boştur; `ROADMAP_2.md` satır 7049'da `SRM-18` (*İkon üretilmez*) kuralı yer alır; `docs/EKSIK_ASSET_ENVANTERI.md` içinde uygulama ikonu için henüz Nano Banana promptu yoktur.
  - **Yapılacaklar:** `docs/EKSIK_ASSET_ENVANTERI.md` başına "PKT-01 Uygulama İkonu (2D)" maddesi olarak, tekli İngilizce Nano Banana promptu (ör. 13. yy Selçuklu taş kapısı kemeri ve balmumu mühür/demir kilit simgesi, `#00FF00` veya net koyu zemin, yazı yok, `1024×1024` kaynak), beklenen dosya yolu (`assets/ikon/kapi_muhafizi.ico`) ekle; Ahmet'in hazırlayacağı `.ico` dosyasını `export_presets.cfg`'ye bağla (dosya henüz konmamışsa eksik `.ico` kontrol uyarısı ver). *(Ajan kesinlikle ikon üretmez.)*
  - **Dokunulacak dosyalar:** `docs/EKSIK_ASSET_ENVANTERI.md`, `export_presets.cfg` (`application/icon`).
  - **Kabul ölçütü:** `docs/EKSIK_ASSET_ENVANTERI.md`'de `PKT-01` Nano Banana promptu kayıtlıdır; hazır `assets/ikon/kapi_muhafizi.ico` konduğunda `export_presets.cfg` doğrulayıcısı `0` hata verir (`tests/py/test_export_presets.py`).
  - **Bağımlılık:** `TST-08`.
  - **Tahmini büyüklük:** `S`

- [ ] **PKT-02:** `export_presets.cfg` tam sürüm metadata ve SemVer sürüm düzeni
  - **Amaç:** Windows derlemesinin boş ürün adı ve `0.0.0` sürüm numarasıyla çıkmasını engelleyip resmi kimlik ve sürüm bilgisi kazandırmak.
  - **Bugünkü durum:** `export_presets.cfg` satır 1–41 içinde yalnızca `[preset.0]` (`Windows Desktop`) vardır; `export_path=""`, `application/product_name=""`, `application/file_version=""`, `application/product_version=""`, `application/company_name=""`, `application/copyright=""` alanlarının tamamı boştur. `docs/surum/SURUM_NOTU.md` satır 3 sürümü `Godot 4.7.2-stable` olarak sabitler.
  - **Yapılacaklar:** `[preset.0]` için `product_name="Kapi Muhafizi"`, SemVer sürüm (`0.4.0` veya geçerli taslak no), `company_name`, `copyright`, `export_path="build/windows/KapiMuhafizi.exe"` ve `project.godot` `application/config/version` senkronunu kur.
  - **Dokunulacak dosyalar:** `export_presets.cfg`, `project.godot`, `docs/surum/SURUM_NOTU.md`.
  - **Kabul ölçütü:** `export_presets.cfg` `[preset.0]` içinde boş zorunlu metadata alanı kalmaz (`tests/py/test_export_presets.py`).
  - **Bağımlılık:** `PKT-01`, `SES-07`.
  - **Tahmini büyüklük:** `S`

- [ ] **PKT-03:** Bağımsız (DRM-Free) Windows Demo ön ayarı (`[preset.1]`) (Karar E1)
  - **Amaç:** Herhangi bir Steamworks, DRM veya ağ bağımlılığı olmayan, tek arşivde paylaşılabilen Windows Demo ön ayarını oluşturmak.
  - **Bugünkü durum:** `export_presets.cfg` içinde ikinci bir ön ayar (`[preset.1]`) yoktur; `DemoKesiti` (`src/sistemler/demo_kesiti.gd:4-11`) yalnız `--demo` komutu veya `DEMO=1` ortam değişkeniyle tetiklenebilir, derleme içine gömülü `demo` feature flag'i kontrol edilmemektedir.
  - **Yapılacaklar:** `export_presets.cfg` altına `[preset.1]` (`name="Windows Demo"`, `custom_features="demo"`, `export_path="build/demo/KapiMuhafiziDemo.exe"`) ekle; `DemoKesiti.aktif()` içine `OS.has_feature("demo")` desteğini ekle; `docs/` ve `tests/` klasörlerinin pakete girmediğini `export_filter` / `.gdignore` ile doğrula.
  - **Dokunulacak dosyalar:** `export_presets.cfg`, `src/sistemler/demo_kesiti.gd`.
  - **Kabul ölçütü:** `OS.has_feature("demo")` veya `--demo` aktifken `DemoKesiti.aktif() == true` döner; `[preset.1]` `export_presets.cfg`'de geçerli ve DRM-free yapılandırılmıştır (`tests/unit/sistemler/demo_kesiti_test.gd`, `tests/py/test_export_presets.py`).
  - **Bağımlılık:** `PKT-02`.
  - **Tahmini büyüklük:** `M`

- [ ] **PKT-04:** `DemoKesiti` sınır akışı, kayıt koruma ve playtest telemetri/senaryo uyumu
  - **Amaç:** Demo oyuncusunun 1. Perde sonunda tatmin edici bir kapanış ekranı görmesini, kaydının bozulmamasını ve playtest telemetrisi + başlangıç senaryolarıyla sorunsuz çalışmasını sağlamak.
  - **Bugünkü durum:** `DemoKesiti` (`src/sistemler/demo_kesiti.gd:15-42`) `oturma_esigi` (`18`) ve `perde2_baslar(demo)` denetimi sunar; ancak `demo` sınırına gelindiğinde özel kapanış/teşekkür ekranı ve tam sürümde devam kaydı koruma testi tanımlanmamıştır.
  - **Yapılacaklar:** `PKT-04.a` ve `PKT-04.b` ile demo kapanış akışı, kayıt koruma ve `TEL-02` / `ICR-12` uyumu tamamlanır.
  - **Dokunulacak dosyalar:** `src/sistemler/demo_kesiti.gd`, yeni `src/arayuz/demo_bitis_ekrani.gd`, `src/koy/perde_gecisi.gd` (ince adaptör), `data/metin/metinler.csv`.
  - **Kabul ölçütü:** Demo sınırına gelindiğinde `DemoBitisEkrani` açılır, `user://kayit.json` zarar görmez ve tam sürüm modunda (`demo=false`) aynı kayıt 2. Perdeye devam eder (`tests/unit/kayit/demo_kayit_koruma_test.gd`).
  - **Bağımlılık:** `PKT-03`, `ICR-12.b`, `TEL-03.b`.
  - **Tahmini büyüklük:** `M`

  - [ ] **PKT-04.a:** `DemoKesiti` 1. Perde sonu kapanış ekranı ve kayıt koruma doğrulaması
    - **Amaç:** 18 nüfus (1. Perde sonu) eşiğinde demoyu zarif bir özet/teşekkür ekranıyla sonlandırıp oyuncunun kaydını saklamak.
    - **Bugünkü durum:** `PerdeGecisi` 18 nüfusta 2. Perdeye geçerken `DemoKesiti.perde2_baslar()` falselanırsa kullanıcıyı yönlendiren özel bitiş ekranı eksik kalabilir.
    - **Yapılacaklar:** `DemoBitisEkrani` panelini yaz (bu koşunun özeti + ana menüye dön düğmesi); `user://kayit.json` dosyasının silinmeden "demo sınırında bekliyor" olarak kaldığını ve demo kapalı açılışta 2. Perdeye devam edebildiğini doğrula.
    - **Dokunulacak dosyalar:** Yeni `src/arayuz/demo_bitis_ekrani.gd`, `src/koy/perde_gecisi.gd`, `data/metin/metinler.csv`.
    - **Kabul ölçütü:** Demo sınırında `DemoBitisEkrani` görünür; aynı kayıt `demo=false` ile yüklendiğinde 2. Perde başlatılabilir (`tests/unit/kayit/demo_kayit_koruma_test.gd`).
    - **Bağımlılık:** `PKT-03`.
    - **Tahmini büyüklük:** `M`

  - [ ] **PKT-04.b:** Demo içinde başlangıç senaryoları (`ICR-12`) ve playtest telemetri (`TEL-02`) uyumu
    - **Amaç:** Demo derlemesinde seçilebilir başlangıç senaryolarının (Karar B2) ve playtest telemetri onayının (Karar C1) çakışmadan çalışmasını sağlamak.
    - **Bugünkü durum:** `DemoKesiti`, `AcilisSenaryosu` ve `YerelTelemetri` henüz tek senaryo olarak birlikte test edilmemiştir.
    - **Yapılacaklar:** Demo + playtest özellikleriyle açılan oturumda hem senaryo seçiminin hem telemetri onay/yazımının hem "Klasörde Göster" düğmesinin (`TEL-04`) çalıştığını doğrulayan entegrasyon testi yaz.
    - **Dokunulacak dosyalar:** Yeni `tests/oto/demo_akis_kontrol.gd`, `tests/hedefli_liste.txt`.
    - **Kabul ölçütü:** `demo_akis_kontrol.gd` `TestSonucu` standardında `0` hata ile `quit(0)` döner.
    - **Bağımlılık:** `PKT-04.a`, `ICR-12.b`, `TEL-04`.
    - **Tahmini büyüklük:** `S`

- [ ] **PKT-05:** `docs/surum/MAGAZA.md` ve sürüm notunun demo/ses durumuna güncellenmesi
  - **Amaç:** Mağaza ve demo tanıtım metninin oyunun güncel durumuyla (müzik/ses katmanı, başlangıç senaryoları, demo kapsam sınırı, yazılı diyalog dürüst satırı) birebir örtüşmesini sağlamak.
  - **Bugünkü durum:** `docs/surum/MAGAZA.md` satır 1–25 eski MVP kapsamını, 5 sonu ve "Seslendirme yoktur; konuşmalar yazılıdır" notunu içerir; başlangıç senaryolarından veya demo kapsamından söz etmez.
  - **Yapılacaklar:** `docs/surum/MAGAZA.md` içine demo kapsamı (1. Perde sonu / 3 başlangıç senaryosu), ses durumu (CC0/CC-BY müzik & ortam sesleri eklendi, seslendirme yoktur notu korunur) ve `PKT-02` sürüm numarası bilgilerini ekle.
  - **Dokunulacak dosyalar:** `docs/surum/MAGAZA.md`, `docs/surum/SURUM_NOTU.md`.
  - **Kabul ölçütü:** `MAGAZA.md` içinde Steamworks veya 13. yy dışı dönem terimi (`akıncı`, `yeniçeri` vb.) yoktur; tüm sayılar ve modlar mevcut kodla uyumludur.
  - **Bağımlılık:** `PKT-04.b`, `SES-07`.
  - **Tahmini büyüklük:** `S`

- [ ] **PKT-06:** Otomatik export betiği ve bağımsız Windows Demo paket duman testi
  - **Amaç:** Paket alma işlemini elle tıklamadan tek komutlu, tekrarlanabilir ve bozuk dosya yakalayan bir boru hattına bağlamak.
  - **Bugünkü durum:** Repoda Godot `--export-release` komutunu sarıp çıktıyı doğrulayan otomatik bir betik yoktur.
  - **Yapılacaklar:** `PKT-06.a` ve `PKT-06.b` ile paketleme betiği ve çıktı denetimi kurulur.
  - **Dokunulacak dosyalar:** Yeni `tools/demo_paketle.py`, yeni `tests/py/test_demo_paket.py`.
  - **Kabul ölçütü:** Paketleme aracı `.exe`/`.pck` varlığını, boyut/kaynak listesini ve dışarıdan çalıştırmada `0` `SCRIPT ERROR` çıktısını doğrular.
  - **Bağımlılık:** `PKT-05`.
  - **Tahmini büyüklük:** `M`

  - [ ] **PKT-06.a:** `tools/demo_paketle.py` tek komutluk DRM-free Windows Demo paketleyici
    - **Amaç:** `godot --headless --export-release "Windows Demo"` çağrısını yönetip temiz ZIP/klasör çıktısı üretmek.
    - **Bugünkü durum:** Elle Godot Editor export dışında komut satırı paketleme betiği bulunmamaktadır.
    - **Yapılacaklar:** `tools/demo_paketle.py` yaz: önce `sanity_check.py` (hedefli), ardından `--export-release "Windows Demo"`, çıktı klasörü doğrulama ve `.zip` paketleme; Steam DLL/kütüphanesi taşımadığını kontrol et.
    - **Dokunulacak dosyalar:** Yeni `tools/demo_paketle.py`.
    - **Kabul ölçütü:** `tools/demo_paketle.py --kuru` tüm ön kontrolleri `0` hata ile geçer; export şablonu kurulu ortamda `.exe` + `.pck` üretir (`tests/py/test_demo_paket.py`).
    - **Bağımlılık:** `PKT-05`.
    - **Tahmini büyüklük:** `M`

  - [ ] **PKT-06.b:** Export paketi kaynak sızıntısı ve `--headless` açılış duman testi
    - **Amaç:** `docs/`, `tests/`, `.md` taslakları veya geliştirici araçlarının oyuncu paketine sızmadığını ve derlenmiş paketin açılışta çökmediğini doğrulamak.
    - **Bugünkü durum:** Export sonrası `.pck` içeriğini veya üretilen demo ikilisini otomatik sınayan bir test yoktur.
    - **Yapılacaklar:** `tools/demo_paketle.py` sonuna `.pck` / çıktı taraması (yalnız izinli uzantılar, `tests/` ve `docs/` hariç) ve paketli ikiliyle `--headless` hızlı açılış/kapanış testi ekle.
    - **Dokunulacak dosyalar:** `tools/demo_paketle.py`, `tests/py/test_demo_paket.py`.
    - **Kabul ölçütü:** Üretilen pakette `0` yasaklı klasör sızıntısı ve açılışta `0` `SCRIPT ERROR` / `Failed to load script` doğrulanır.
    - **Bağımlılık:** `PKT-06.a`.
    - **Tahmini büyüklük:** `S`

---

## Bölüm F — İngilizce Metin Kalitesi (`ING` — En Son)

`ICR`, `TEL`, `SES` ve `PKT` bölümlerinden doğan tüm yeni metin anahtarları sabitlendikten sonra en son adımda İngilizce yerelleştirme kalitesi kapatılır. Karar `F1` uyarınca *Tekfur, Akçe, Ahi, Uç Bey* gibi tarihsel terimler İngilizce metinde özgün haliyle kalıp ilk geçtikleri yerde kısa açıklama/ipucu alır; Karar `F2` uyarınca yalnız Türkçe (`tr`) ve İngilizce (`en`) desteklenir (üçüncü dil altyapısı açılmaz). `ROADMAP_3` `SVS-46` savaş metinleri Berk/Usta tarafında bırakılır.

**Bölüm bitiş ölçütü:** `docs/TERIM_SOZLUGU_EN.md` sözlüğü ve ilk geçiş açıklaması çalışır; `docs/INGILIZCE_METIN_TASLAGI.csv` ile `data/metin/metinler.csv` senkronize edilir; `tools/metin_dogrula.py` genişletilmiş uzunluk/terim denetimi ve `"en"` yerel ayarındaki arayüz taşma testi `0` hata ile geçer.

- [ ] **ING-01:** 13. yüzyıl Anadolu ucu İngilizce terim sözlüğü (Karar F1)
  - **Amaç:** Dönem unvanları ve kurumlarının çeviride tutarsız veya uydurma Osmanlıca/Batı feodal karşılıklarına kaymasını önlemek.
  - **Bugünkü durum:** `tools/metin_dogrula.py` satır 1–60 anahtar biçimi ve `%s` tutarlılığı kontrol eder; ancak terim yazım birliğini zorlayan sabit bir İngilizce terim sözlüğü (`docs/TERIM_SOZLUGU_EN.md`) mevcut değildir.
  - **Yapılacaklar:** *Tekfur, Akçe, Ahi, Uç Bey, Subaşı, Oba, Divan, Şifahane, Harami, Kervansaray, Alp, Gazi* terimleri için tekil İngilizce yazım (italik/büyük harf standardı + kısa parantez/ipucu açıklaması) tablosu oluştur; Osmanlıca (`yeniçeri`, `tımar`, `sipahi`, `akıncı`) yasak listesini ekle.
  - **Dokunulacak dosyalar:** Yeni `docs/TERIM_SOZLUGU_EN.md`.
  - **Kabul ölçütü:** `docs/TERIM_SOZLUGU_EN.md` içinde temel tarihsel terimlerin %100'ü tanımlı ve ilk geçiş kısa açıklamaları hazırdır.
  - **Bağımlılık:** `PKT-05`, `ICR-14`.
  - **Tahmini büyüklük:** `S`

- [ ] **ING-02:** Tarihsel terim ilk geçiş açıklama / ipucu (`tooltip` / sözlük) bağlantısı (Karar F1)
  - **Amaç:** İngilizce oyuncunun *Tekfur* veya *Akçe* gibi özgün terimleri ilk gördüğünde oyundan kopmadan anlamasını sağlamak.
  - **Bugünkü durum:** `DilAyari` (`src/sistemler/dil_ayari.gd:46-52`) `metinler.en.translation` yükler; ancak İngilizce metinde ilk geçen özgün terimlere kısa açıklama/ipucu ekleyen bir yardımcı veya sözlük erişimi yoktur.
  - **Yapılacaklar:** `ING-01` sözlüğündeki terimler için iki katmanlı destek ekle: (i) diyalog/olay metinlerinde terimin ilk geçtiği yerde kısa bağlam (`Tekfur (local Byzantine lord)` kalıbı) ve/veya (ii) bilgi/defter panelinde kısa `Terimler / Glossary` sekmesi veya BBCode ipucu adaptörü (`tr` akışını bozmadan).
  - **Dokunulacak dosyalar:** Yeni `src/arayuz/terim_ipucu_adaptoru.gd`, `src/sistemler/dil_ayari.gd`, `data/metin/metinler.csv`.
  - **Kabul ölçütü:** `DilAyari.sec(a, "en")` aktifken tanımlı terimlerin ilk geçişinde veya sözlük görünümünde kısa açıklama doğrulanır (`tests/unit/metin/terim_ipucu_test.gd`).
  - **Bağımlılık:** `ING-01`.
  - **Tahmini büyüklük:** `M`
  - **Çakışma notu:** `ROADMAP_2` `ARY` / `GRV-15` metin kaydırma işi Berk tarafındadır; yeni terim ipucu yalnızca mevcut `RichTextLabel` veya bilgi ekranına ince eklenti olarak bağlanır.

- [ ] **ING-03:** Eksik ~361+ satırın `docs/INGILIZCE_METIN_TASLAGI.csv` ve ana `metinler.csv` ile senkronizasyonu (Karar F2)
  - **Amaç:** İngilizce oynanışta yer yer Türkçe satır veya ham anahtar kodu çıkmasına neden olan taslak-ana CSV farkını tamamen kapatmak.
  - **Bugünkü durum:** `docs/INGILIZCE_METIN_TASLAGI.csv` toplam **2352** satırken, `data/metin/metinler.csv` **2713** satırdır; aradaki en az **361 satırlık** fark (artı `ROADMAP_4` `ICR`/`TEL`/`SES`/`PKT` maddelerinden gelen yeni anahtarlar) henüz tam İngilizce karşılığa bağlanmamıştır. `DilAyari.DOSYA_EN` (`src/sistemler/dil_ayari.gd:7`) `res://data/metin/metinler.en.translation` bekler.
  - **Yapılacaklar:** `ING-03.a` ve `ING-03.b` ile eksik satırlar çevrilip ana CSV ve `.translation` kaynağına güvenli biçimde işlenir.
  - **Dokunulacak dosyalar:** `docs/INGILIZCE_METIN_TASLAGI.csv`, `data/metin/metinler.csv`, `data/metin/metinler.en.translation`.
  - **Kabul ölçütü:** `metinler.csv` içindeki her aktif (`SVS-*` dışı) satırın boş olmayan ve Türkçe kopyası olmayan geçerli bir `en` sütunu vardır (`tools/metin_dogrula.py`).
  - **Bağımlılık:** `ING-02`.
  - **Tahmini büyüklük:** `L`
  - **Çakışma notu:** `data/metin/metinler.csv` `AGENTS.md` §2 korumalı çekirdek dosyadır. Dosya seviyesinde ezme yapılmaz, yalnız anahtar (ID) bazlı satır güncellenir; `ROADMAP_3` `SVS-46` savaş anahtarlarına dokunulmaz.

  - [ ] **ING-03.a:** Taslak dışındaki eksik ~361+ satır ile `ROADMAP_4` yeni anahtarlarının ayrıştırılıp çevrilmesi
    - **Amaç:** `metinler.csv` içinde `en` eksiği olan tüm satırları (`dedikodu.kacis`, `zar.degistirici.*`, olaylar, `ICR/TEL/SES/PKT` yeni anahtarları) sözlüğe göre çevirmek.
    - **Bugünkü durum:** `INGILIZCE_METIN_TASLAGI.csv` (`2352` satır) güncelliğini yitirmiştir.
    - **Yapılacaklar:** Fark tarama komutuyla `metinler.csv` ve `INGILIZCE_METIN_TASLAGI.csv` arasındaki eksik anahtarları çıkar (`svs.*` savaş anahtarlarını hariç tut); `ING-01` terim sözlüğüne göre doğal, kısa İngilizce çevirilerini taslağa ekle.
    - **Dokunulacak dosyalar:** `docs/INGILIZCE_METIN_TASLAGI.csv`.
    - **Kabul ölçütü:** Taslak CSV içinde `metinler.csv`'ye kıyasla eksik (`svs.*` hariç) `0` anahtar kalır; her satırda `en` kolonu doludur.
    - **Bağımlılık:** `ING-02`.
    - **Tahmini büyüklük:** `M`

  - [ ] **ING-03.b:** `data/metin/metinler.csv` anahtar bazlı birleştirme ve `.en.translation` derlemesi
    - **Amaç:** Onaylı `en` satırlarını ana `metinler.csv`'ye güvenli aktarmak ve Godot'nun `metinler.en.translation` kaynağını güncellemek.
    - **Bugünkü durum:** `DilAyari` (`src/sistemler/dil_ayari.gd:52`) çalışma anında `metinler.en.translation` dosyasını okur.
    - **Yapılacaklar:** Anahtar bazlı birleştirme betiğiyle `metinler.csv`'nin yalnız `en` sütununu (mevcut `tr` metnine ve `svs.*` satırlarına dokunmadan) güncelle; Godot `--headless --import` ile `metinler.en.translation` çıktısını yenile.
    - **Dokunulacak dosyalar:** `data/metin/metinler.csv`, `data/metin/metinler.en.translation`.
    - **Kabul ölçütü:** Godot `--headless` altında `TranslationServer.set_locale("en")` sonrası örnek anahtarların tamamı İngilizce döner (`tests/unit/metin/guvenli_metin_test.gd`).
    - **Bağımlılık:** `ING-03.a`.
    - **Tahmini büyüklük:** `M`
    - **Çakışma notu:** Berk tarafının `ROADMAP_2` veya `SVS-46` satırlarıyla birleştirme öncesi `git pull --rebase` alınır; yalnız ID bazlı fark işlenir.

- [ ] **ING-04:** İngilizce üslup, terim tutarlılığı ve yer tutucu (`%s`/`%d`) redaksiyonu
  - **Amaç:** Çevirideki üslup dalgalanmalarını, dönem dışı kelimeleri ve oyun içi formatlama çökmelerine yol açabilecek yer tutucu uyuşmazlıklarını temizlemek.
  - **Bugünkü durum:** `tools/metin_dogrula.py` satır 22'de `PLACEHOLDER` kontrolü tanımlar ancak `en` sütunundaki 2700+ satır için toplu 13. yy üslup ve terim tutarlılığı redaksiyonu yapılmamıştır.
  - **Yapılacaklar:** Tüm `en` sütununda `ING-01` terimlerini, `%s`/`%d` sırasını/sayısını, Osmanlıca yasaklı kelimeleri ve diyalog tonunu baştan sona redakte et.
  - **Dokunulacak dosyalar:** `data/metin/metinler.csv`, `docs/INGILIZCE_METIN_TASLAGI.csv`.
  - **Kabul ölçütü:** `tools/metin_dogrula.py` `0` yer tutucu hatası ve `0` sözlük/dönem dışı terim ihlali raporlar.
  - **Bağımlılık:** `ING-03.b`.
  - **Tahmini büyüklük:** `M`

- [ ] **ING-05:** `tools/metin_dogrula.py` genişletilmiş uzunluk bütçesi ve terim denetimi (Karar F2)
  - **Amaç:** Bundan sonra eklenecek her İngilizce metnin düğme taşması veya terim bozulması üretmesini otomatik yakalamak (yalnız `tr` ve `en` dilleriyle sınırlı).
  - **Bugünkü durum:** `tools/metin_dogrula.py` satır 33–39'da yalnız `ogretici.*` için `sinir = 90` (`OGR-08`) kontrolü vardır; diğer UI önekleri (`arayuz.*`, `dugme.*`, `secenek.*`) veya `ING-01` terim sözlüğü için kural yoktur.
  - **Yapılacaklar:** `tools/metin_dogrula.py` içine önek bazlı İngilizce uzunluk bütçesi (ör. kısa düğme/etiket sınırları), `ING-01` yasak terim kontrolü ve yalnız `keys, tr, en` sütun doğrulaması (Karar F2: 3. dil sütunu açılmaz) ekle.
  - **Dokunulacak dosyalar:** `tools/metin_dogrula.py`, `tests/py/test_metin_dogrula.py`.
  - **Kabul ölçütü:** `tools/metin_dogrula.py` tam `metinler.csv` üzerinde `0` hata döner ve testteki yapay uzun/yasaklı terimli satırı yakalayıp hata verir (`tests/py/test_metin_dogrula.py`).
  - **Bağımlılık:** `ING-04`.
  - **Tahmini büyüklük:** `M`

- [ ] **ING-06:** Otomatik `"en"` yerel ayar arayüz taşma testi ve `ROADMAP_4` kapanış doğrulaması
  - **Amaç:** İngilizce dilinde oynarken hiçbir ana menü, ayar, yeni oyun, kapı, köy veya demo ekranında yazı kesilmesi veya taşma yaşanmadığını sahne üstünde kanıtlamak.
  - **Bugünkü durum:** `tests/oto/` ve `tests/unit/arayuz/` testleri çoğunlukla varsayılan `tr` diliyle koşulur; `"en"` dilinde `Label`/`Button` taşma denetimi yapan otomatik sahne kontrolü yoktur.
  - **Yapılacaklar:** `ING-06.a` ve `ING-06.b` ile canlı sahne taşma testi ve final `sanity_check.py` kapanışı yapılır.
  - **Dokunulacak dosyalar:** Yeni `tests/oto/en_arayuz_tasma_kontrol.gd`, `tests/hedefli_liste.txt`.
  - **Kabul ölçütü:** Tüm ekranlarda `"en"` metinleri çerçeve dışına taşmaz ve `sanity_check.py` tam paketi `0` hata ile tamamlar.
  - **Bağımlılık:** `ING-05`, `PKT-06.b`, `TST-08`.
  - **Tahmini büyüklük:** `M`

  - [ ] **ING-06.a:** `TranslationServer.set_locale("en")` altında ekran metin taşma ve kesilme testi
    - **Amaç:** Ana menü, Yeni Oyun (`ICR-12.b`), Ayarlar (`SES-02`, `TEL-04`), Kapı (`CHR_*`), Köy HUD, Gece Raporu ve Demo Bitiş ekranlarında `"en"` metinlerin görünür alanda kaldığını doğrulamak.
    - **Bugünkü durum:** `DilAyari.sec(a, "en")` sahne taşma testi mevcut değildir.
    - **Yapılacaklar:** `en_arayuz_tasma_kontrol.gd` testini yaz; hedef sahneleri `en` yerel ayarında yükleyip `Label`/`Button` minimum genişlik/clip kontrolü yap ve `TestSonucu` standardında `quit(0)`/`quit(1)` dön.
    - **Dokunulacak dosyalar:** Yeni `tests/oto/en_arayuz_tasma_kontrol.gd`.
    - **Kabul ölçütü:** `en_arayuz_tasma_kontrol.gd` `0` taşma ve `0` çevrilmemiş anahtar (`KEY_...` / `arayuz....`) bulgusuyla `quit(0)` döner.
    - **Bağımlılık:** `ING-05`, `PKT-06.b`.
    - **Tahmini büyüklük:** `M`

  - [ ] **ING-06.b:** `ROADMAP_4` final `tools/sanity_check.py` + `tools/metin_dogrula.py` kapanış doğrulaması
    - **Amaç:** Bütün A–F bölümleri tamamlandıktan sonra tüm oyunun tek bir temiz kapanış raporunda `0` hata verdiğini doğrulamak.
    - **Bugünkü durum:** Final kapanış koşusu bütün bölümler bitince yapılacaktır.
    - **Yapılacaklar:** `tools/metin_dogrula.py`, `tools/sanity_check.py` (tam koşu), `tools/denge_raporu.py` ve `tools/demo_paketle.py` doğrulamalarını art arda koş; sonucu rapora yaz.
    - **Dokunulacak dosyalar:** Kapanış doğrulama notu `docs/denetim/roadmap4_kapanis_dogrulamasi.md`.
    - **Kabul ölçütü:** Tüm test takımları ve export duman testi `0` hata (`quit(0)`) verir.
    - **Bağımlılık:** `ING-06.a`.
    - **Tahmini büyüklük:** `S`

---

## Tüm Maddeler Bağımlılık Zinciri (Tek Liste)

1. `TST-01.a` (Ortak `TestSonucu` hata sayacı)
2. `TST-01.b` (Fixture ve `Ses.cik()` hata kodu koruması; *bağımlı: `TST-01.a`*)
3. `TST-02.a` (`sevilen_yuz_test.gd` dönüşümü; *bağımlı: `TST-01.b`*)
4. `TST-02.b` (`tests/oto/` ilk 25 test dönüşümü; *bağımlı: `TST-02.a`*)
5. `TST-02.c` (`tests/oto/` kalan 24 test dönüşümü; *bağımlı: `TST-02.b`*) → `TST-02` tamamlanır
6. `TST-03` (`tools/sanity_check.py` başarısız çıkış denetimi; *bağımlı: `TST-02.c`*)
7. `TST-04.a` (Görev 22 bağsız betikler çapraz sahiplik tablosu; *bağımlı: `TST-03`*)
8. `TST-04.b` (Berk tarafı bağsız betik listesi kilidi; *bağımlı: `TST-04.a`*) → `TST-04` tamamlanır
9. `TST-05` (Ahmet tarafı ölü diyalog/Parley betiklerinin silinmesi; *bağımlı: `TST-04.b`*)
10. `TST-06` (Ahmet tarafı ölü UI/önizleme betiklerinin silinmesi; *bağımlı: `TST-04.b`*)
11. `TST-07` (Faydalı ölçüm/sistem betiklerinin ince bağlantısı; *bağımlı: `TST-05`, `TST-06`*)
12. `TST-08` (Bölüm B–F hedefli test çekirdeği `hedefli_test_listesi`; *bağımlı: `TST-07`*) → **Bölüm A sonu**
13. `ICR-01` (Ortak `CHR_*` kimlik ve yaşam döngüsü durum sözleşmesi; *bağımlı: `TST-08`*)
14. `ICR-02.a` (Olay geçmişi ve kategori bekleme kaydı; *bağımlı: `TST-08`*)
15. `ICR-02.b` (Deste ağırlık motoru; *bağımlı: `ICR-02.a`*) → `ICR-02` tamamlanır
16. `ICR-03` (30 karaktere ruh hali/geliş sebebi varyant altyapısı; *bağımlı: `ICR-01`*)
17. `ICR-04.a` (`CHR_001`–`CHR_015` varyant ve geçmiş karar tepki verileri; *bağımlı: `ICR-03`*)
18. `ICR-04.b` (`CHR_016`–`CHR_030` varyant ve geçmiş karar tepki verileri; *bağımlı: `ICR-04.a`*) → `ICR-04` tamamlanır
19. `ICR-05` (Dallanan diyalog sonuçlarının kapı/köy işlerine yansıması; *bağımlı: `ICR-04.b`*)
20. `ICR-06.a` (Gecikmeli kapı/köy karar etkileri ve debuff kuyruğu; *bağımlı: `ICR-05`*)
21. `ICR-06.b` (Kararların `sonraki_spawns` / kuyruk profilini etkilemesi; *bağımlı: `ICR-06.a`*) → `ICR-06` tamamlanır
22. `ICR-07` (Köy işleri ve debuff etkileşimli olay koşulları; *bağımlı: `ICR-06.a`, `ICR-02.b`*)
23. `ICR-08` (Yeni olay türleri I: Kervan/ticaret/dış baskı; *bağımlı: `ICR-06.b`, `ICR-02.b`*)
24. `ICR-09` (Yeni olay türleri II: Köy içi çatışma/pasif özellik/zanaat; *bağımlı: `ICR-07`*)
25. `ICR-10.a` (Yıl başına deterministik mevsim alt-tipi seçicisi; *bağımlı: `ICR-07`*)
26. `ICR-10.b` (Mevsim alt-tiplerinin kapı/üretim/olay sistemlerine bağlanması; *bağımlı: `ICR-10.a`*) → `ICR-10` tamamlanır
27. `ICR-11` (5+5 sonuna giden ara dönüm noktası ve yol çeşitliliği; *bağımlı: `ICR-08`, `ICR-09`, `ICR-10.b`*)
28. `ICR-12.a` (`data/baslangic/` 3 başlangıç senaryosu tanımı; *bağımlı: `ICR-11`*)
29. `ICR-12.b` (`YeniOyunEkrani` 1. günden açık senaryo seçicisi; *bağımlı: `ICR-12.a`*) → `ICR-12` tamamlanır
30. `ICR-13` (Sonraki gelen kişi ve kuyruk dinamiğinin bütünleştirilmesi; *bağımlı: `ICR-12.b`, `ICR-10.b`, `ICR-06.b`*)
31. `ICR-14` (30 simülasyonluk içerik/çeşitlilik dağılım testi; *bağımlı: `ICR-13`*) → **Bölüm B sonu**
32. `TEL-01` (Yerel telemetri şeması, gizlilik ve `ayarlar.cfg` anahtarı; *bağımlı: `TST-08`, `ICR-14`*)
33. `TEL-02` (Playtest ilk açılış tek soruluk onay penceresi; *bağımlı: `TEL-01`*)
34. `TEL-03.a` (Kapı kararı ve olay seçimi telemetri adaptörü; *bağımlı: `TEL-02`, `ICR-12.a`*)
35. `TEL-03.b` (Erken çıkış / bırakma noktası ve son kaydı; *bağımlı: `TEL-03.a`*) → `TEL-03` tamamlanır
36. `TEL-04` (Ayarlar'da "Test raporunu klasörde göster" düğmesi; *bağımlı: `TEL-01`*)
37. `TEL-05.a` (`tools/denge_raporu.py` son ve bırakma histogramı; *bağımlı: `TEL-03.b`*)
38. `TEL-05.b` (Senaryo bazlı darboğaz Markdown/CSV özeti; *bağımlı: `TEL-05.a`*) → `TEL-05` tamamlanır
39. `TEL-06` (Playtest ön-denge turu ve `denge.json` sınır doğrulaması; *bağımlı: `TEL-05.b`, `TEL-04`*) → **Bölüm C sonu**
40. `SES-01.a` (73 ses dosyası envanteri ve lisans/eksik listesi; *bağımlı: `TST-08`*)
41. `SES-01.b` (73 ses dosyası seviye ölçümü ve `db_ofset` denge tablosu; *bağımlı: `SES-01.a`*) → `SES-01` tamamlanır
42. `SES-02` (`Master -> Muzik, Efekt, Ortam` 3 bus ve Ayarlar kaydırıcıları; *bağımlı: `SES-01.b`*)
43. `SES-03` (CC0/CC-BY açık lisanslı müzik ve ortam seçimi/bağlantısı; *bağımlı: `SES-02`*)
44. `SES-04.a` (Uyarlanabilir müzik durum makinesi crossfade'i; *bağımlı: `SES-03`*)
45. `SES-04.b` (`OlayVerisi.muzik` kart müziği ve savaş kancası; *bağımlı: `SES-04.a`*) → `SES-04` tamamlanır
46. `SES-05` (Gündüz/gece ve mevsim ortam ses katmanı `Ortam` bus'ında; *bağımlı: `SES-02`, `SES-03`, `ICR-10.a`*)
47. `SES-06` (Arayüz, mühür ve kapı/köy karar sesleri eşlemesi; *bağımlı: `SES-03`*)
48. `SES-07` (Ses karışımı, sorgu ducking ve ses bütünlük testi; *bağımlı: `SES-04.b`, `SES-05`, `SES-06`*) → **Bölüm D sonu**
49. `PKT-01` (Uygulama ikonu Nano Banana promptu ve `.ico` kancası; *bağımlı: `TST-08`*)
50. `PKT-02` (`export_presets.cfg` tam sürüm metadata ve SemVer; *bağımlı: `PKT-01`, `SES-07`*)
51. `PKT-03` (DRM-free Windows Demo ön ayarı `[preset.1]`; *bağımlı: `PKT-02`*)
52. `PKT-04.a` (`DemoKesiti` 1. Perde bitiş ekranı ve kayıt koruma; *bağımlı: `PKT-03`*)
53. `PKT-04.b` (Demo içinde senaryolar ve playtest telemetri uyumu; *bağımlı: `PKT-04.a`, `ICR-12.b`, `TEL-04`*) → `PKT-04` tamamlanır
54. `PKT-05` (`docs/surum/MAGAZA.md` ve `SURUM_NOTU.md` güncellemesi; *bağımlı: `PKT-04.b`, `SES-07`*)
55. `PKT-06.a` (`tools/demo_paketle.py` tek komutluk paketleyici; *bağımlı: `PKT-05`*)
56. `PKT-06.b` (Export paketi sızıntı ve headless açılış duman testi; *bağımlı: `PKT-06.a`*) → `PKT-06` tamamlanır → **Bölüm E sonu**
57. `ING-01` (13. yy Anadolu ucu İngilizce terim sözlüğü; *bağımlı: `PKT-05`, `ICR-14`*)
58. `ING-02` (Tarihsel terim ilk geçiş açıklama/ipucu bağlantısı; *bağımlı: `ING-01`*)
59. `ING-03.a` (Eksik ~361+ satır ve yeni anahtarların taslak CSV'de çevrilmesi; *bağımlı: `ING-02`*)
60. `ING-03.b` (`data/metin/metinler.csv` anahtar bazlı birleştirme ve `.en.translation` derlemesi; *bağımlı: `ING-03.a`*) → `ING-03` tamamlanır
61. `ING-04` (İngilizce üslup, sözlük ve yer tutucu redaksiyonu; *bağımlı: `ING-03.b`*)
62. `ING-05` (`tools/metin_dogrula.py` genişletilmiş uzunluk/terim denetimi; *bağımlı: `ING-04`*)
63. `ING-06.a` (`"en"` yerel ayarında ekran taşma ve kesilme testi; *bağımlı: `ING-05`, `PKT-06.b`*)
64. `ING-06.b` (Final `sanity_check.py` + `metin_dogrula.py` kapanış doğrulaması; *bağımlı: `ING-06.a`*) → `ING-06` tamamlanır → **Bölüm F ve ROADMAP_4 sonu**

---

## Ajan Masası'nda (GitHub Issue #11) Konuşulacaklar (Berk/Usta Tarafıyla Çakışma Listesi)

> **Not:** Bu maddeler Berk/Usta tarafının aktif `ROADMAP_2` / `ARY` / `ROADMAP_3` (`SVS-*`) sorumluluklarıyla kesişmektedir. Uygulamaya geçmeden önce Ajan Masası'nda ilgili eşgüdüm notu paylaşılır (`[EMIR]` / `[SORU]`):

1. **`TST-02.a` (`sevilen_yuz_test.gd`):** `SEV-05` maddesi Berk tarafında açık olduğu için bu dosyada yalnızca `assert -> TestSonucu` çıkış kapısı değiştirilecek; oyun mantığına dokunulmadığı bildirilecek.
2. **`TST-04.b` (Bağsız `src/` betikleri listesi):** `SevilenYuz` (`SEV-01..05`), `KayitYuvaKarti` (`AYR-29/33`), `AksamSohbeti` (`HAN-13/34`), `SoylentiAgi` (`SOY-25/43/46`), `YilIzi` (`YIL-09`), `KapiKavgasi` (`CAT-01/02`), `SiddetKorkusu` (`CAT-04`) için Berk/Usta tarafının silme/bağlama niyeti `[EMIR]` ile sorulacak.
3. **`TST-06` (`tema_onizleme.gd`, `ui_adaylari/onizleme.gd`):** `ARY-*` ve `GRV-*` tema çalışması sürerken bunların ölü artıktan sayılıp silineceği teyit edilecek.
4. **`ICR-01` (Ortak `CHR_*` durum sözleşmesi):** `ROADMAP_3` `SVS-34.a/b` (esir/fidye) ve `CAT-01/02` ile `chr_id` yaşam durumu bayrakları (`esir`, `fidye_bekliyor`, `oldu`) senkronu Usta/Berk'e iletilecek.
5. **`ICR-12.b`, `TEL-02`, `TEL-04`, `ING-02` (Arayüz eklentileri):** `ARY-*` / `GRV-*` ekran taşıma/tema çalışması bitiş sırasına göre yeni oyun senaryo satırı, playtest onay penceresi, klasör açma düğmesi ve terim ipucu eklentisinin hangi tema bileşenlerini kullanacağı hizalanacak.
6. **`SES-02` & `SES-04.b` (`ses.gd` ve `SVS-47`):** `ses.gd` korumalı dosya olduğu için yalnız `Ortam` bus yönlendirmesi ekleneceği ve `SVS-47` (`K16`) savaş ses yer tutucusuna dokunulmayacağı bildirilecek.
7. **`ING-03.b` (`data/metin/metinler.csv`):** Berk tarafının `ROADMAP_2` ve `SVS-46` satırlarını ezmemek için yalnız ID bazlı birleştirme takvimi hizalanacak.

---

## Sonraya Bırakılanlar (ROADMAP 4 Kapsam Dışı)

1. **Steamworks SDK / GodotSteam entegrasyonu:** Bu sürümde yalnız bağımsız (DRM-free) Windows demo ve temel export üretilir (Karar `E1`).
2. **Steam Başarımları (`SRM-11`):** Steamworks ile birlikte sonraki aşamaya bırakılmıştır (Karar `E1`).
3. **Steam Cloud Kayıt Eşitlemesi (`SRM-16`):** Tekil `user://kayit.json` yerel kalır; bulut kayıt sonraya bırakılmıştır (Karar `E1`).
4. **Tam sürüm telemetri varsayılanı ve veri politikası:** `C1` kararıyla yalnız playtest derlemesinde ilk açılış onay penceresi kurulur; nihai çıkış sürümünde telemetrinin varsayılan durumu/kapatılması sonraki sürümde kararlaştırılır (Karar `C1`).
5. **30 üstü yeni karakter eklenmesi (`CHR_031+`):** Önce mevcut 30 karakter varyantlarla (`B1`) test edilecek; yeni yüz/karakter ekleme kararı playtest sonucuna bırakılmıştır (Karar `B1`).
6. **Üçüncü dil altyapısı (Almanca, Fransızca, Rusça vb.):** Bu yol haritasında yalnız Türkçe ve İngilizce desteklenir (Karar `F2`).
7. **Savaş ses üretimi / savaş özel müzikleri:** `ROADMAP_3` `SVS-47` (`K16`) yer tutucu olarak Berk/Usta tarafındadır; bu listede yalnız `SES-04.b` kancası bırakılmıştır.
