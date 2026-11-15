# Kapı Muhafızı — ROADMAP 3 (Sıra Tabanlı Savaş)

> **Sahip: Ahmet tarafı** (`AGENTS.md` → "15 Kas 2026 bölüşümü"). Bu yol haritası, `docs/ROADMAP_3_SAVAS_ON_RAPOR.md` (§5, §5.9, §7A, §8) ve K1–K18 kesinleşen kararları temel alınarak hazırlanmıştır. Berk tarafı bu dosyadaki maddelere dokunmaz.
> **DURUM LEJANDI:** `[ ]` Beklemede · `[/]` Geliştiriliyor · `[x]` Tamamlandı (kilitli).

---

## AJAN İLERLEME PANOSU (her ajan önce burayı okusun)

- **Bölüşüm (K17):** `ROADMAP_2` ile aynıdır; **baştan** (`A–D` grupları) ve **sondan** (`G–E` grupları) ilerlenir. Ayrı bir orta bölge açılmaz. Her maddenin `Sahip` alanı `baştan` veya `sondan` olarak işaretlidir.
- **Sahiplik akışı:** Başlamadan önce `git pull --rebase`, ardından tek maddeyi `[/] (AjanAdı)` yapıp commit + push et. Başka ajanın `[/]` maddesine dokunma. Bitince `[x] (AjanAdı)` yap ve `codex.md/<AjanAdı>.md` günlüğünü güncelle.
- **Mimari ilke:** Yeni dosyalar (`src/savas/`, `src/arayuz/savas/`, `data/savas/`, `tests/unit/savas/`) + ince adaptör. Korumalı çekirdek dosyalara (`ana.gd`, `koy_ekrani.gd`, `tema.gd`, `hud.gd`, `karakter_model.gd`, `koy_yonetim_sahnesi.gd`, `oturum.gd`, `ses.gd`, `koy_nufusu.gd`, `guvenli_kayit.gd`, `data/metin/metinler.csv`, `tests/oto/otomatik_oyuncu.gd`) yalnız tek satırlık adaptör gerekçesiyle girilir. Eski `koy_sahnesi` yasaktır.
- **ROADMAP_2 sınırı:** `ROADMAP_2.md` maddelerine ve kabul testlerine dokunulmaz; "yeni savaş yok" diyen `ROADMAP_2` maddelerinin (`YAP-56`, `MCL-09`, `HAR-02`, `BUG-18`, `OMR-42`) testleri bozulmadan adaptörle genişletilir.
- **Kesinleşen kararlar (K1–K18):**
  - **K1 / K18 (Dönem):** 1243 Kösedağ sonrası Selçuklu ucu. Yeni savaş metinlerinde `akıncı`, `tımar`, `sipahi`, `yeniçeri`, `levent ocağı` kullanılmaz; yerine `uç beyi`, `subaşı`, `alp`, `gazi`, `tekfur`, `harami` kullanılır. Eski metinler ve diyaloglar değiştirilmez.
  - **K2 (Hamle):** Turda birim başına **2 eylem** (AP sistemi yok).
  - **K3 (Can):** Sayısal HP. HP `0` = `düştü`; savaş sonunda düşenler için ayrı yara/sakatlık zarı atılır.
  - **K4 (Muhafız):** Muhafız ölmez. HP `0` olursa savaş kaybedilmiş sayılır; kalan dostlar çekilebilir, galibiyet yazılmaz, komuta kimseye devredilmez.
  - **K5 (Moğol):** Küçük öncü/keşif grupları savaşılır; büyük akın kolu savaşsız karar düğümüyle çözülür.
  - **K6 (Katılım):** Kadın ve genç katılımı ayarlanabilir (varsayılan açık, oyun ortasında değişebilir). Çocuklar her durumda savaş dışıdır.
  - **K7 (Kıtlık):** Kıtlık/açlık isyanı şimdilik kapsam dışıdır (gelecek notu).
  - **K8 (Önek):** `SVS-` kullanılır; `CAT-01..04` korunur, `CAT-05..84` açılmaz.
  - **K9 (Okçuluk):** `okculuk_oyunu.gd` sur okçusu becerisine bağlanır.
  - **K10 (Otomatik çözüm yok):** Oyuncuya açık otomatik çözüm yoktur; her savaş oynanır. `SVS-19` yalnız test amaçlı YZ–YZ koşucusudur.
  - **K11 (Kapı düellosu):** `CAT-02` "askerle karşılık" içinde iki oynanır yol vardır (adamlarını gönder veya muhafız düellosu). Beşinci kapı seçeneği açılmaz.
  - **K12 (Kayıt):** Savaş ortasında kayıt yok; savaş başlamadan otomatik kayıt alınır.
  - **K13 / K14 (Ganimet & Esir):** Ganimet paylaşımı adalet/yozlaşma terazisine yazılır; esir ve fidye `ROADMAP_3` içindedir.
  - **K15 (Tavan):** Bir savaşta en fazla **20 birim** bulunur.
  - **K16 (Asset):** 2B arayüz üretimi serbest; 3B yalnız Meshy/açık lisans; ses sessiz yer tutucu. Hepsi `docs/EKSIK_ASSET_ENVANTERI.md` dosyasına yazılır.

---

## Oyun Sistemleri Analizi (Savaş Tasarım Referansları ve Somut Dönüşüm)

| Referans Oyun | Alınan Mekanik Karar | Somut Sayısal/Taktik Karşılığı (`data/savas/`) | Alınmayanlar |
|---|---|---|---|
| **XCOM 2** | Tur başına **2 eylemli** aksiyon modeli, siper/görüş hattı ve isabet olasılığının şeffaf gösterimi. | Eylem = `2/2`; yarım siper `+1`, tam siper `+2` savunma eki; ağır atış (arbalet/nişanlı yay) `2` eylem yer. Hedefleme öncesi `basari_olasiligi` (`%`) görünür. | Aksiyon puanı (AP) ve bilimkurgu ekipman ağacı alınmaz. |
| **Battle Brothers** | **Yorgunluk**, **moral basamakları**, kalıcı yara/sakatlık, ön/arka sıra ve **yan saldırı (flanking)**, silah zırh-delme farkları. | 4 moral basamağı (`70+/45–69/20–44/<20`), 2+ düşmanla sarılmada `+2` isabet / `-1` moral; topuz zırh delme `2`, balta kapı `×2`. | Paralı asker şirketi ekonomisi ve sınırsız asker alımı alınmaz. |
| **Into the Breach** | Küçük, okunaklı harita üzerinde ağır hamle sonuçları ve **düşman niyetinin önceden görünmesi**. | Gözcü kulesi veya keşif eri (`CHR_023`) varsa düşmanın bir sonraki hedef hücresi çizgiyle görünür; sur ve kapı gediği harita kontrolünü belirler. | Zar yerine sabit itme bulmacası alınmaz. |
| **Darkest Dungeon** | Moralin ayrı bir çubuk olarak savaşı kırması ve **savaş sonrası iyileşme/travma ekonomisinin** köye taşması. | Yorgunluk `%50+` iken moral zarına `-1`, `%80+` iken `-2`; `agir_yara` şifahanede yatak/hekim ister, `kalici_sakatlik` iş gücünü `%50` düşürür. | Sabit 4'lü sıra düzeni ve fantastik düşmanlar alınmaz. |
| **Mount & Blade** | **Savaş öncesi karar** (savaş, pazarlık, rüşvet, kaç), **esir/fidye** ve komutanın moral aurası. | Muhafız/çavuş `3` hücre aura (`+1` moral); düşman lideri (`cete_reisi`) düşünce tüm düşmanlara `-2` moral darbesi; sınıfına göre `5–25` akçe fidye. | Gerçek zamanlı savaş ve oyuncuya açık otomatik çözüm (K10) alınmaz. |
| **The Banner Saga** | Kayıp, yaralanma ve mühimmat/erzak baskısının doğrudan **köy hayatta kalma döngüsüne** bağlanması. | Yay/arbalet cephane kotası (`10`/`8` ok), tükenince yakın dövüşe geçiş; savaş kaybı moral, güvenlik, cenaze ve `KAP-18` göç zincirini tetikler. | Ayrı zırh-kırma/can iki çubuklu hasar matematiği alınmaz (tek HP + zırh düşümü K3). |

### Analizden Doğan Tekil Sistem Kuralları (Yol Haritası Eşlemesi)
- **Teçhizat farkları (silah & zırh matrisi)** → `SVS-04.a`, `SVS-04.b`
- **Sınıf ve birim özel yetenekleri** → `SVS-06.b`
- **Durum etkileri (buff/debuff, süre, yığılma)** → `SVS-11.b`
- **Moral ve yorgunluk etkileşimi** → `SVS-15.a`, `SVS-15.b`
- **Zorluk eğrisi** → `SVS-20.b`
- **Baskın strateji yasağı** → `SVS-20.c`
- **Dengeleme ve karşı güçler** → `SVS-49.a`, `SVS-49.b`

---

## A. Temel, Veri ve Katılım (`baştan`)

- [ ] **SVS-01:** Savaş klasör yapısı ve adaptör sınırları
  - **Amaç:** Sıra tabanlı savaş motorunu, arayüzünü ve verisini mevcut köy/kapı kodundan yalıtarak güvenli genişletme zemini kurmak.
  - **Kapsam:** `src/savas/`, `src/arayuz/savas/`, `data/savas/` ve `tests/unit/savas/` klasör iskeleti ile mevcut çekirdek sistemlere (`oturum.gd`, `koy_yonetimi.gd`, `kapi_ekrani.gd`) tek satırlık adaptör arayüzünün tanımlanması dahildir. Savaş mantığı veya UI sahneleri bu maddede yazılmaz.
  - **Bağımlılıklar:** yok.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/savas_koprusu.gd`, `data/savas/`, `src/arayuz/savas/`, `tests/unit/savas/`. Korumalı çekirdeğe dokunulmaz (yalnız köprü arayüzü hazırlanır).
  - **Veri şeması:** veri yok.
  - **Kabul ölçütleri:** Belirtilen 4 klasör mevcuttur; `savas_koprusu.gd` Godot headless importta `0` script hatası verir ve `koy_sahnesi` / `KoyYerlesimi` referansı içermez.
  - **Testler:** `tests/unit/savas/savas_koprusu_test.gd` (headless sınıf yükleme ve eski sahne yasağı taraması).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** metin yok.
  - **Sahip:** baştan.

- [ ] **SVS-53:** Savaşa katılım ayarı — kadınlar ve gençler (K6)
  - **Amaç:** Oyuncunun kadın ve genç köylülerin savaşa katılıp katılmayacağını oyun başında ve oyun ortasında belirleyebilmesini sağlamak.
  - **Kapsam:** Katılım bayrağı (varsayılan `true`), ayarlar paneli ve yeni oyun seçeneği bağlantısı, çocukların (`yas_grubu == "cocuk"`) her koşulda savaş dışı bırakılması dahildir. Birim dönüştürme mantığı `SVS-03`'tedir.
  - **Bağımlılıklar:** `SVS-01`, `ROADMAP_2` Bölüm 35 (ayarlar paneli).
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/katilim_ayari.gd`; mevcut `src/arayuz/ayarlar_paneli.gd` ve `src/arayuz/yeni_oyun_ekrani.gd` içine ince adaptör. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `ayarlar`: `{"savas_kadin_genc_katilimi": bool}` (varsayılan `true`).
  - **Kabul ölçütleri:** Varsayılan değer `true`'dur; ayar oyun ortasında `false` yapılınca sonraki savaş aday listesinde kadın/genç sayısı `0` olur; çocuk sayısı her iki durumda `0` kalır.
  - **Testler:** `tests/unit/savas/katilim_ayari_test.gd` (varsayılan açık, oyun ortası değişim, çocuk hariç tutma).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.ayar.kadin_genc_katilim`, `svs.ayar.kadin_genc_aciklama` (TR ve EN).
  - **Sahip:** baştan.

- [ ] **SVS-02:** Birim istatistik şablonu
  - **Amaç:** Hem dost hem düşman bütün savaşçıların ortak bir sayısal veri yapısıyla temsil edilmesini sağlamak.
  - **Kapsam:** `SavasBirimi` veri/kaynak sınıfı (`can`, `azami_can`, `saldiri`, `savunma`, `menzil_becerisi`, `inisiyatif`, `moral`, `moral_tabani`, `yorgunluk`, `yorgunluk_tavani`, `ekipman`, `rol_etiketleri`, `durumlar`) dahildir. Sınıf/düşman sayıları `SVS-05` ve `SVS-06.a`'dadır.
  - **Bağımlılıklar:** `SVS-01`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/savas_birimi.gd`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `data/savas/birim_semasi.json`: zorunlu alanlar `id`, `taraf` (`dost`|`dusman`|`tarafsiz`), `azami_can` (int >= 1), `saldiri` (int), `savunma` (int), `menzil_becerisi` (int), `inisiyatif` (int), `moral_tabani` (int 0..100), `yorgunluk_tavani` (int >= 4), `ekipman` (`{silah, kalkan, zirh}`), `rol_etiketleri` (`Array[String]`).
  - **Kabul ölçütleri:** Şemadaki herhangi bir zorunlu alan eksikse doğrulayıcı `1` hata döner; negatif `azami_can` reddedilir; tüm savaş birimleri aynı `SavasBirimi` sınıfını kullanır.
  - **Testler:** `tests/unit/savas/savas_birimi_test.gd` (şema doğrulama, sınır değerleri).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** metin yok.
  - **Sahip:** baştan.

- [ ] **SVS-03:** Köylü, asker ve adlı karakterden savaş birimine dönüştürücü
  - **Amaç:** Köydeki gerçek bireylerin (sağlık, beceri, nöbet yorgunluğu, rol, ekipman) savaşa birebir taşınmasını ve savaş sonrası aynı kişiye geri yazılmasını sağlamak.
  - **Kapsam:**
    1. Mevcut `koy_nufusu`, `karakterler/CHR_*.tres`, `aydogdu/nogay/miraen`, `CHR_021..024` (eski asker/kaçak) ve Muhafız'ın `SavasBirimi`'ne dönüştürülmesi.
    2. `SVS-53` katılım ayarına göre aday süzme; karantinadaki, uyuyan, ağır yaralı ve çocuk (`yas_grubu == "cocuk"`) bireylerin elenmesi.
    3. Köylü sağlığından (`0–100`) başlangıç HP oranlaması (`max(1, round(azami_can * saglik / 100))`).
  - **Bağımlılıklar:** `SVS-02`, `SVS-53`, `ROADMAP_2` (`HAR-10`, `UZM-14`).
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/birim_donusturucu.gd`. Korumalı çekirdek `koy_nufusu.gd`'ye dokunulmaz; yalnızca okuma/yazma adaptörü üzerinden çalışır.
  - **Veri şeması:** `data/savas/donusum_kurallari.json`: `saglik_hp_orani`, `sinif_baz_degerleri`, `eski_asker_bonuslari` (`CHR_021` piyade `+1 saldiri`, `CHR_022` davulcu `davul_morali`, `CHR_023` kesif `+2 gorus`, `CHR_024` cebeci `ekipman_onarim`).
  - **Kabul ölçütleri:** Sağlığı `%50` olan köylü başlangıç HP'sinin yarısıyla (en az `1`) başlar; `SVS-53` kapalıyken kadın/genç aday listesine girmez; çocuk (`yas_grubu == "cocuk"`) hiçbir durumda girmez; karantinadaki/uyuyan asker süzülür.
  - **Testler:** `tests/unit/savas/birim_donusturucu_test.gd` (sabit tohumlu nüfus dönüşümü, katılım filtresi, sağlık→HP oranı).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** metin yok.
  - **Sahip:** baştan.

#### SVS-04 — 13. Yüzyıl Dönem Teçhizatı ve Köy Stoğu (`SVS-04.a` – `SVS-04.b`)

- [ ] **SVS-04.a:** 13. yüzyıl silah matrisi ve karşı oynanış farkları
  - **Amaç:** Her silahın birbirinden net taktik rolü (menzil, hasar, zırh delme, ağırlık, 2 eylemli atış, kapı kırıcılık) taşımasını sağlamak. Her silah için ayrı madde açılmaz.
  - **Kapsam:** Tek `silahlar.json` tablosunda tüm dönem silahları ve karşı oynanış kuralları:
    1. `kilic` (menzil `1`, hasar `4`, delme `0`, ağırlık `1`, `1` eylem) — zırhsıza karşı dengeli; ağır zırhta zayıf.
    2. `mizrak` (menzil `1–2`, hasar `3`, delme `1`, ağırlık `2`, `1` eylem, `karsilama` özelliği) — atlı hücumuna karşı güçlü; yakın çevrelenmede zayıf.
    3. `topuz` / gürz (menzil `1`, hasar `4`, delme `3`, ağırlık `2`, `1` eylem) — ağır zırh ve kalkanlı tekfura karşı güçlü.
    4. `balta` (menzil `1`, hasar `5`, delme `1`, ağırlık `3`, `1` eylem, `kapi_carpani: 2.0`) — ahşap kapı ve barikata karşı güçlü; yorgunluk maliyeti yüksek.
    5. `turk_yayi` (menzil `2–5`, hasar `4`, delme `1`, ağırlık `1`, `1` eylem, sur `+1` menzil) — zırhsıza ve açıkta düşmana güçlü; kalkan duvarında (`-3` isabet) zayıf.
    6. `arbalet` / tzangra (menzil `2–6`, hasar `6`, delme `3`, ağırlık `3`, **`agir_eylem_mi: true`** — doldur+at `2` eylem) — ağır zırhı deler; yavaş ve hareketli süvariye karşı zayıf.
    7. `sapan` (menzil `2–4`, hasar `2`, delme `0`, ağırlık `0`) ve `orak`/`sopa` (menzil `1`, hasar `2`, delme `0`, ağırlık `1`) — silahsız köylü aleti.
  - **Bağımlılıklar:** `SVS-02`, `K1`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/techizat_tablosu.gd`, `data/savas/silahlar.json`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `silahlar.json`: `{id, tur, menzil_min, menzil_max, hasar, zirh_delme, agirlik, yorgunluk_eki, agir_eylem_mi, kapi_carpani, guclu_karsi, zayif_karsi}`.
  - **Kabul ölçütleri:** Tüm silahlar şemadan hatasız yüklenir; `arbalet.agir_eylem_mi == true`, `topuz.zirh_delme >= 3`, `mizrak.menzil_max == 2`, `balta.kapi_carpani == 2.0` doğrulanır.
  - **Testler:** `tests/unit/savas/techizat_tablosu_test.gd` (silah matrisi şema ve rol farkı doğrulaması).
  - **Asset:** Yer tutucu: el eşyası kutuları (`el_esyasi.gd`). 2B ikonlar `docs/EKSIK_ASSET_ENVANTERI.md` içine eklenir.
  - **Metin anahtarları:** `svs.silah.<id>` (TR ve EN dönem adları).
  - **Sahip:** baştan.

- [ ] **SVS-04.b:** 13. yüzyıl koruma/zırh matrisi ve köy silah stoğu dağıtımı
  - **Amaç:** Kalkan ve zırh katmanlarının savunma/hasar azaltma ile yorgunluk bedeli arasında anlamlı takas yaratmasını ve köyün gerçek silah/zırh stoğundan dağıtılmasını sağlamak.
  - **Kapsam:**
    1. Tek `zirhlar.json` tablosu: `yok` (`0` zırh, `0` ağırlık), `kece_kaftan` (`1` zırh, `+0` savunma, `1` ağırlık), `deri_zirh` (`2` zırh, `2` ağırlık), `zirh_gomlegi` (`3` zırh, `3` ağırlık, `+1` yorgunluk/tur), `tolga` (miğfer, kritik/baş yarası azaltımı), `kucuk_kalkan` (`+1` savunma, `1` ağırlık), `buyuk_kalkan` (`+2` savunma, menzilli atışa `+3` savunma, `2` ağırlık).
    2. Köyün gerçek silah/zırh stoğundan (`silah_karaborsasi`, `demirhane`, `koy_ayarlari`) öncelik sırasıyla (muhafız → asker → milis) dağıtım; stokta silah yoksa köylüye `orak`/`sopa`/`sapan` verilmesi.
  - **Bağımlılıklar:** `SVS-04.a`, `SVS-03`.
  - **Etkilenen dosya ve klasörler:** Yeni `data/savas/zirhlar.json`; `src/savas/techizat_tablosu.gd` (dağıtım işlevi). Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `zirhlar.json`: `{id, tur (govde|kalkan|bas), zirh_puani, savunma_eki, menzil_savunma_eki, agirlik, yorgunluk_eki}`.
  - **Kabul ölçütleri:** Ağır zırh giyen birim daha az HP kaybeder ama yorgunluk tavanına daha erken ulaşır; köy stoğunda `0` kılıç varken köylüye `kilic` verilmez, `orak`/`sopa`/`sapan` atanır.
  - **Testler:** `tests/unit/savas/techizat_dağıtım_test.gd` (stok sınırı, yorgunluk ağırlık cezası, alet yedeği).
  - **Asset:** Yer tutucu: el eşyası kutuları; yeni zırh/kalkan ikonları `docs/EKSIK_ASSET_ENVANTERI.md` içine yazılır.
  - **Metin anahtarları:** `svs.zirh.<id>` (TR ve EN dönem adları).
  - **Sahip:** baştan.

- [ ] **SVS-05:** Düşman şablonları tek tablosu
  - **Amaç:** Döneme uygun tüm düşman tiplerini tek veri tablosunda tanımlamak ve tekrar eden düşman maddelerini önlemek.
  - **Kapsam:** Tek tabloda 12 düşman satırı ve başlangıç istatistik önerileri: `harami` (HP `10`, moral `45`), `cete_reisi` (HP `18`, moral `75`, aura), `eskiya_okcusu` (HP `9`), `tekfur_yayasi` (HP `15`, zırh `3`, kalkan), `tekfur_arbaletcisi` (HP `11`, arbalet), `tekfur_mizrakli_atlisi` (HP `16`, hareket `6`), `rum_milisi` (HP `9`, öldürmede Rum itibar cezası), `mogol_oncu_atlisi` (HP `14`, atlı okçu, `kucuk_grup_tavan: 8` K5), `asi_turkmen_atlisi` (HP `13`, `turkmen_kin`), `asker_kacagi` (HP `11`, umutsuz), `caresiz_sivil` (HP `7`, öldürmede ağır sosyal ceza), `kurt_surusu` (HP `8`, hayvan YZ). Kopya madde açılmaz.
  - **Bağımlılıklar:** `SVS-02`, `SVS-04.a`, `SVS-04.b`, `K1`, `K5`.
  - **Etkilenen dosya ve klasörler:** Yeni `data/savas/dusman_sablonlari.json`, `src/savas/sablon_yukleyici.gd`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `dusman_sablonlari.json`: `{id, grup_etiketi, savas_puani, azami_can, saldiri, savunma, menzil_becerisi, inisiyatif, moral_tabani, yorgunluk_tavani, varsayilan_ekipman, yz_profili, kucuk_grup_tavan, oldurme_ceza_bayragi}`.
  - **Kabul ölçütleri:** 12 düşman tipi şemadan hatasız yüklenir; Osmanlı terimi geçmez; `mogol_oncu_atlisi` için `kucuk_grup_tavan <= 8` doğrulanır; `caresiz_sivil` öldürme ceza bayrağı taşır.
  - **Testler:** `tests/unit/savas/sablon_yukleyici_test.gd` (12 düşman şablonu şema ve terim denetimi).
  - **Asset:** Kutu/kapsül yer tutucu + isim etiketi. 3B modeller ve animasyonlar `docs/EKSIK_ASSET_ENVANTERI.md` (3B başlığı) altına yazılır.
  - **Metin anahtarları:** `svs.dusman.<id>` (TR ve EN).
  - **Sahip:** baştan.

#### SVS-06 — Dost Şablonları ve Birim Yetenekleri (`SVS-06.a` – `SVS-06.b`)

- [ ] **SVS-06.a:** Dost şablonları ve başlangıç istatistik matrisi
  - **Amaç:** Köy tarafında savaşa girebilecek tüm dost rollerini tek veri tablosunda somut sayısal başlangıç değerleriyle tanımlamak.
  - **Kapsam:** Tek `dost_sablonlari.json` tablosunda 13 dost rolü: `muhafiz` (HP `20`, aura, K4 ölümsüz), `cavus` (HP `15`, ast komutan), `kapi_mizraklisi` (HP `14`), `sur_okcusu` (HP `10`), `devriye` (HP `12`), `adli_asker` (`aydogdu`/`nogay`/`miraen`, HP `16`), `eski_asker` (`CHR_021..024`, HP `13`), `erkek_milis` (HP `9`), `kadin_genc_milis` (HP `8`, `SVS-53`'e bağlı), `hekim` (HP `9`, cephe dışı tedavi), `turkmen_alp` (HP `13`, `HAR-07`), `uc_beyi_askeri` (HP `15`, `HAR-04`), `gazi_gonullu` (HP `13`, dış sefer).
  - **Bağımlılıklar:** `SVS-02`, `SVS-04.a`, `SVS-04.b`, `K1`, `K6`.
  - **Etkilenen dosya ve klasörler:** Yeni `data/savas/dost_sablonlari.json`; `src/savas/sablon_yukleyici.gd`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `dost_sablonlari.json`: `{id, azami_can, saldiri, savunma, menzil_becerisi, inisiyatif, moral_tabani, yorgunluk_tavani, varsayilan_ekipman, izinli_yetenekler}`.
  - **Kabul ölçütleri:** 13 dost rolü şemadan hatasız yüklenir; tüm yeni adlar K1/K18 dönem terimlerine uyar (`akıncı`/`tımar`/`sipahi`/`yeniçeri`/`levent` yok).
  - **Testler:** `tests/unit/savas/dost_sablonlari_test.gd` (13 dost şablonu şema ve dönem terimi doğrulaması).
  - **Asset:** Kutu/kapsül yer tutucu + isim etiketi; 3B karakter/animasyon kalemleri `docs/EKSIK_ASSET_ENVANTERI.md` (3B başlığı) altına yazılır.
  - **Metin anahtarları:** `svs.dost.<id>` (TR ve EN).
  - **Sahip:** baştan.

- [ ] **SVS-06.b:** Sınıf ve birim özel yetenekleri tablosu (maliyet, bekleme, karşı oynanış)
  - **Amaç:** Her sınıf ve birimin aktif/pasif yeteneklerini bekleme süresi, eylem/yorgunluk maliyeti ve açık karşı oynanış kuralıyla tek tabloda yönetmek. Yetenek başına ayrı madde açılmaz.
  - **Kapsam:** Tek `yetenekler.json` tablosunda tüm yetenekler:
    1. `emir` (Muhafız/Çavuş — `1` eylem, `2` yorgunluk, bekleme `2` tur, menzil `3`, dost birime `+1` eylem veya `+15` moral; **karşı oynanış:** komutanı kuşat/sersemlet).
    2. `kalkan_duvari` (Yaya/Tekfur — `1` eylem, `2` yorgunluk, bekleme `1` tur, `+2` savunma ve ok atışına `+3`; **karşı oynanış:** `topuz`/`arbalet` zırh delme veya `yan_saldiri`).
    3. `karsilama_mizragi` (Mızraklı — `1` eylem, `1` yorgunluk, bekleme `0`, yaklaşan ilk düşmana öncelikli saldırı; **karşı oynanış:** menzilli ateş veya `sersemledi`).
    4. `bandaj_kaldir` (Hekim — `2` eylem, `2` yorgunluk, bekleme `2` tur, menzil `1`, düşen dostu `3` HP ile ayağa kaldırır; **karşı oynanış:** hekime menzilli baskı).
    5. `nisanli_atis` (Okçu — `2` eylem, `2` yorgunluk, bekleme `1` tur, `+2` isabet; **karşı oynanış:** tam siper veya yakın mesafeye girme).
    6. `sahte_ricat` (Atlı Okçu — `1` eylem, `2` yorgunluk, bekleme `2` tur, atış sonrası `3` hücre geri çekilir; **karşı oynanış:** mızraklı karşılama veya yol kesme).
    7. `kapi_baltasi` (Balta/Kuşatma — `2` eylem, `3` yorgunluk, bekleme `1` tur, kapıya `×2` hasar; **karşı oynanış:** surdan okçu ateşi).
    8. `davul_morali` (`CHR_022` — `1` eylem, `1` yorgunluk, bekleme `2` tur, `4` hücredeki dostlara `+10` moral; **karşı oynanış:** davulcuyu sustur/korkut).
  - **Bağımlılıklar:** `SVS-06.a`, `SVS-11.a`.
  - **Etkilenen dosya ve klasörler:** Yeni `data/savas/yetenekler.json`, `src/savas/yetenek_sistemi.gd`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `yetenekler.json`: `{id, eylem_bedeli (1|2), yorgunluk_bedeli, bekleme_turu, menzil, hedef_turu, karsi_oynanis_etiketi, etki}`.
  - **Kabul ölçütleri:** `bekleme_turu > 0` iken yetenek ikinci kez kullanılamaz; `eylem_bedeli` ve `yorgunluk_bedeli` doğru düşülür; her yetenek boş olmayan bir `karsi_oynanis_etiketi` taşır.
  - **Testler:** `tests/unit/savas/yetenek_sistemi_test.gd` (8 yetenek için bekleme süresi, maliyet düşümü ve karşı oynanış etiketi doğrulaması).
  - **Asset:** Eylem çubuğu yetenek ikonları `docs/EKSIK_ASSET_ENVANTERI.md` (2B başlığı) altına yazılır.
  - **Metin anahtarları:** `svs.yetenek.<id>`, `svs.yetenek.<id>_aciklama` (TR ve EN).
  - **Sahip:** baştan.

---

## B. Motor Çekirdeği (`baştan`)

- [ ] **SVS-07:** Savaş durumu nesnesi ve deterministik RNG
  - **Amaç:** Savaşın tüm akışını sahneden ve UI'dan bağımsız saf mantık (`RefCounted`) içinde deterministik olarak çalıştırmak.
  - **Kapsam:** `SavasDurumu` (birimler, ızgara referansı, tur/raunt sayacı, aktif birim, savaş türü, hava/gece bayrağı, günlük olay listesi) ve oturum `_rng.state`'inden türetilen deterministik `RandomNumberGenerator` dahildir.
  - **Bağımlılıklar:** `SVS-01`, `SVS-02`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/savas_durumu.gd`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** veri yok (çalışma zamanı `RefCounted` durumu).
  - **Kabul ölçütleri:** Aynı başlangıç tohumu ve aynı girdi dizisiyle iki headless koşu birebir aynı `SavasDurumu` özetini ve RNG durumunu üretir; Node/SceneTree bağımlılığı `0`'dır.
  - **Testler:** `tests/unit/savas/savas_durumu_test.gd` (sabit tohumlu iki koşu eşitliği).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** metin yok.
  - **Sahip:** baştan.

- [ ] **SVS-08:** Savaş ızgarası, siper/yükseklik ve 20 birim tavanı (K15)
  - **Amaç:** Köyün mevcut A* `izgara.gd` hücrelerini siper, yükseklik, yanıcılık ve kapı sağlamlığıyla savaş haritasına dönüştürmek ve performans tavanını korumak.
  - **Kapsam:**
    1. Kare ızgara + 8 yön komşuluk ve `izgara.gd` A* hücrelerinin okunması.
    2. Hücre nitelikleri (`gecilebilir`, `siper`: `yok`/`yarim`/`tam`, `yukseklik`: `zemin`/`sur`, `yanicilik`, `kapi_saglamligi`) ve `HAR-10` konuşlanma hücrelerinin aktarımı.
    3. **20 birim tavanı (K15):** Bir savaşta en fazla `20` birim sahneye girer; 21. ve sonraki adaylar `yedek_liste` / `gelmedi` olarak veride tutulur.
  - **Bağımlılıklar:** `SVS-07`, `ROADMAP_2` (`HAR-10`, `K15`).
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/savas_izgarasi.gd`, `data/savas/arazi_kurallari.json`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `arazi_kurallari.json`: `{azami_birim: 20, siper_ekleri: {yok: 0, yarim: 1, tam: 2}, sur_yukseklik_menzil_bonusu: 1, sur_savunma_bonusu: 2}`.
  - **Kabul ölçütleri:** `25` aday birim verildiğinde sahneye tam `20` birim girer, `5` birim yedek/gelmedi listesinde kalır; siper ve sur bonusları `arazi_kurallari.json`'dan okunur.
  - **Testler:** `tests/unit/savas/savas_izgarasi_test.gd` (sabit tohumla 20 birim tavanı, 8 yön komşuluk, siper/yükseklik okuması).
  - **Asset:** asset gerekmedi (mevcut köy ızgarası kullanılır).
  - **Metin anahtarları:** metin yok.
  - **Sahip:** baştan.

- [ ] **SVS-09:** Kapı arenası haritası
  - **Amaç:** Kapı arbedesi ve kapı düellosu (`SVS-23.a`, `SVS-23.b`) için küçük, sabit ve okunaklı bir kare ızgara tanımlamak.
  - **Kapsam:** Kapı önü için sabit boyutlu arena verisi (`10x8` kare, giriş hücreleri, kapı duvarı siperi, kaçış kenarı) ve `SavasIzgarasi` yükleyicisi dahildir.
  - **Bağımlılıklar:** `SVS-08`.
  - **Etkilenen dosya ve klasörler:** Yeni `data/savas/haritalar/kapi_arenasi.json`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `kapi_arenasi.json`: `{id: "kapi_arenasi", genislik: 10, yukseklik: 8, dost_dogus: [[x,y]], dusman_dogus: [[x,y]], kapi_hucreleri, kacis_kenari}`.
  - **Kabul ölçütleri:** Arena `1v1` düello ve `1–3`'e `1–3` arbede için yeterli geçilebilir hücre ve kaçış kenarı içerir; sıfır hata ile `SavasIzgarasi`'na yüklenir.
  - **Testler:** `tests/unit/savas/kapi_arenasi_test.gd` (doğuş hücrelerinin geçilebilirliği, kaçış kenarı).
  - **Asset:** asset gerekmedi (mevcut kapı önü sahnesi/ızgarası).
  - **Metin anahtarları:** metin yok.
  - **Sahip:** baştan.

- [ ] **SVS-10:** İnisiyatif ve tur sırası
  - **Amaç:** Raunt başında deterministik tur sırası kurmak ve sıra şeridinin okuyacağı sırayı üretmek.
  - **Kapsam:** Raunt başında her canlı/düşmemiş birim için `inisiyatif + d6` atışı, eşitlikte dost tarafın önce gelmesi ve raunt sonu fazı (kanama, yangın, durum süresi azaltımı, takviye tetiği) dahildir.
  - **Bağımlılıklar:** `SVS-07`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/tur_yoneticisi.gd`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** veri yok.
  - **Kabul ölçütleri:** Sabit tohumda iki koşu birebir aynı sıra listesi üretir; eşit inisiyatif+d6 durumunda dost birim her zaman öne geçer; düşmüş (`can <= 0`) birim tur sırasına alınmaz.
  - **Testler:** `tests/unit/savas/tur_yoneticisi_test.gd` (sabit tohum sırası, eşitlik kuralı, düşmüş birim dışlama).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** metin yok.
  - **Sahip:** baştan.

#### SVS-11 — İki Eylemli Aksiyon Modeli ve Durum Etkileri (`SVS-11.a` – `SVS-11.b`)

- [ ] **SVS-11.a:** İki eylemli aksiyon modeli (K2) ve ağır eylem kuralları
  - **Amaç:** XCOM tarzı turda birim başına 2 eylem kuralını ve 2 eylem tüketen ağır eylemleri kesin kurallarla işletmek.
  - **Kapsam:**
    1. Her birimin tur başında `2` eylem hakkı alması (AP sistemi kesinlikle yoktur, `K2`).
    2. Geçerli birleşimler: `hareket + eylem`, `eylem + hareket`, `hareket + hareket` (koşu), `eylem + pas`.
    3. Ağır eylemler (`arbalet` atışı, `nisanli_atis`, `kapi_baltasi`, `bandaj_kaldir`): yalnızca `2` eylem mevcutken kullanılabilir ve turu sonlandırır.
    4. Yorgunluk tavanı (`SVS-16`) veya `sersemledi` durumu altındaki birimin `1` eylemle sınırlanması; `düştü` (`can == 0`) birimin `0` eylemi olması.
  - **Bağımlılıklar:** `SVS-04.a`, `SVS-06.b`, `SVS-10`, `K2`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/eylem_modeli.gd`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** veri yok (`silahlar.json` ve `yetenekler.json` içindeki `eylem_bedeli` / `agir_eylem_mi` alanlarını okur).
  - **Kabul ölçütleri:** `1` eylem harcandıktan sonra `agir_eylem_mi == true` olan eylem seçilemez; ağır eylem kullanılınca kalan eylem `0` olur; düştü durumundaki birimin eylem hakkı `0`'dır.
  - **Testler:** `tests/unit/savas/eylem_modeli_test.gd` (tüm ikili kombinasyonlar, ağır eylem kilidi, düştü/kısıtlı tur).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** metin yok.
  - **Sahip:** baştan.

- [ ] **SVS-11.b:** Durum etkileri (buff/debuff) tablosu, süre ve yığılma kuralları
  - **Amaç:** Savaş içi tüm güçlendirme ve zayıflatma etkilerinin sayısal değerlerini, sürelerini, yığılma yasağını ve temizlenme koşullarını tek tabloda yönetmek.
  - **Kapsam:** Tek `durum_etkileri.json` tablosu ve yaşam döngüsü:
    1. **Bufflar:** `kalkan_duvari` (`+2` savunma, `+3` menzil savunması, `1` tur, `yenile`), `ilham` (`+1` saldırı, `+10` moral, `2` tur, `yenile`).
    2. **Debufflar:** `kanama` (raunt sonu `-2` HP, `3` tur, `uzat` — en çok `5` tur), `sersemledi` (`-1` eylem, `1` tur, `yoksay`), `zehir_is` (`-1` saldırı, `-1` görüş, `2` tur, `yenile`), `yara_sarsintisi` (`-2` savunma, savaş sonuna kadar, `yoksay`), `yangin_panigi` (raunt sonu `-8` moral, `2` tur, `yenile`).
    3. **Yığılma yasağı:** Aynı durum iki kez uygulandığında sayısal bonus/ceza katlanmaz; yalnızca tablodaki `yigilma_kurali` (`yenile` | `uzat` | `yoksay`) uygulanır.
    4. **Temizlenme:** `kanama` bandajla, `yangin_panigi` uzaklaşma/su ile erken kalkar.
  - **Bağımlılıklar:** `SVS-11.a`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/durum_etkileri.gd`, `data/savas/durum_etkileri.json`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `durum_etkileri.json`: `{id, tur (buff|debuff), sure_turu, azami_sure, yigilma_kurali, savunma_eki, saldiri_eki, eylem_kisiti, tur_sonu_hp_delta, tur_sonu_moral_delta, temizleme_etiketi}`.
  - **Kabul ölçütleri:** Aynı etki iki kez uygulandığında savunma/saldırı bonusu katlanmaz (`1×` kalır); `kanama` uzatmada `azami_sure: 5`'i aşmaz; süre `0` olunca etki otomatik silinir.
  - **Testler:** `tests/unit/savas/durum_etkileri_test.gd` (7 durum etkisi, yığılmama, uzatma tavanı, bandajla kanama silinmesi).
  - **Asset:** Durum ikonu yer tutucuları `docs/EKSIK_ASSET_ENVANTERI.md` (2B başlığı) altına yazılır.
  - **Metin anahtarları:** `svs.durum.<id>` (TR ve EN).
  - **Sahip:** baştan.

- [ ] **SVS-12:** Hareket, menzil, 8 yön ve görüş hesabı
  - **Amaç:** Birimlerin ızgara üzerinde A* yol bulma ile yürümesini, silah menzili ve görüş hattı (LoS) ile hedef alabilmesini, gece savaşında ışık kaynağına göre görüş kısıtının işlemesini sağlamak.
  - **Kapsam:** 8 yönlü A* yol bulma, düşman kontrol bölgesi/çarpışma engeli, menzil (`min..max`) ve engel/duvar görüş hattı, gece görüş menzili (`4` hücre) ile meşale/muhafız ışığı (`+3` hücre, `muhafiz_donanimi.json`) bağlantısı dahildir.
  - **Bağımlılıklar:** `SVS-08`, `SVS-04.a`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/hareket_ve_gorus.gd`, `data/savas/gorus_kurallari.json`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `gorus_kurallari.json`: `{gunduz_gorus_hucre: 10, gece_taban_gorus: 4, mesale_ek_gorus: 3, sur_gorus_bonusu: 2}`.
  - **Kabul ölçütleri:** Duvar/tam engel arkasındaki hedefe menzilli saldırı görüş dışı kalır; gece görüşü gündüzden kısadır ve meşale taşıyan birimin çevresinde `mesale_ek_gorus` kadar açılır; sur yüksekliği okçu menziline veri kadar ekler.
  - **Testler:** `tests/unit/savas/hareket_ve_gorus_test.gd` (LoS engel testi, gece/meşale görüşü, 8 yön yol maliyeti).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** metin yok.
  - **Sahip:** baştan.

- [ ] **SVS-13:** Savaş zarı adaptörü (`SavasZari`), isabet ve HP hasarı (K3)
  - **Amaç:** Savaş zarını mevcut `SorguZari` kurallarıyla (`d6`/`d12`, `zar >= gerekli`, tavan daima başarı, `1` daima başarısız, tek `basari_olasiligi` yolu) kurmak ve isabet eden saldırıda sayısal HP hasarını düşmek.
  - **Kapsam:**
    1. `SavasZari` adaptörü (`SorguZari.olasilik` ve `SorguZari.basarili` üzerinden, ikinci hesap yolu açmadan).
    2. İsabet formülü: `d12 >= hedef_savunma + mesafe_eki + siper_eki + moral_eki + yorgunluk_eki - saldiri` (`1` her zaman ıska, `12` her zaman isabet).
    3. HP hasarı (K3): `max(1, silah_hasari + d6 - max(0, zirh_puani - zirh_delme))`.
  - **Bağımlılıklar:** `SVS-11.a`, `SVS-12`, `ROADMAP_2` (`ZAR-01..06`), `K3`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/savas_zari.gd`, `data/savas/isabet_kurallari.json`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `isabet_kurallari.json`: `{mesafe_basina_ek: 1, siper_ekleri, moral_ekleri, yorgunluk_eki, asgari_hasar: 1}`.
  - **Kabul ölçütleri:** `1` atan saldırı her zaman ıskalar, `12` atan her zaman isabet eder; isabet olasılığı doğrudan `SorguZari.olasilik` çıktısıdır; isabet eden saldırıda hedef HP'si en az `1` düşer.
  - **Testler:** `tests/unit/savas/savas_zari_test.gd` (tavan/1 kuralı, `basari_olasiligi` tutarlılığı, zırh delme ve asgari `1` hasar).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.zar.isabet`, `svs.zar.iska`, `svs.zar.hasar` (TR ve EN; mevcut `ZAR_BASARILI` vb. kullanılır).
  - **Sahip:** baştan.

- [ ] **SVS-14:** HP sıfırda "düştü" durumu ve savaş sonu yara/sakatlık zarı (K3, K4)
  - **Amaç:** Savaş içinde HP `0`'a inen karakterin eylemsiz `"düştü"` durumuna geçmesini ve savaş sonunda düşenler için ağır sonuçlu ama okunaklı yara/sakatlık zarı atılmasını sağlamak.
  - **Kapsam:**
    1. HP `0` anında `"düştü"` bayrağı (haritada yatar, düşman esir alabilir/öldürebilir, hekim `bandaj_kaldir` ile kaldırabilir).
    2. Savaş sonunda her düşen için `d12` yara/sakatlık zarı (`1–3` ölüm, `4–6` ağır yara, `7–8` kalıcı sakatlık, `9–12` hafif yara) ve değiştiriciler (hekim `+2`, şifahane `+1`, ağır silah `-1`, düşman elinde kaldı `-2`).
    3. **Muhafız kuralı (K4):** Muhafız ölüm satırına asla girmez; `d12 <= 6` gelse bile sonuç en kötü `agir_yara` olur.
  - **Bağımlılıklar:** `SVS-13`, `K3`, `K4`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/yara_zari.gd`, `data/savas/yara_tablosu.json`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `yara_tablosu.json`: `{d12_araliklari: {olum, agir_yara, kalici_sakatlik, hafif_yara}, degistiriciler: {hekim: 2, sifahane: 1, agir_silah: -1, alanda_kaldi: -2}, muhafiz_en_kotu: "agir_yara"}`.
  - **Kabul ölçütleri:** HP `0` olan birim turda eylem alamaz; `1000` sabit tohumlu testte Muhafız için `olum` sonucu `0` kez döner; hekim ve şifahane varlığı `olum` olasılığını veri tablosu kadar düşürür.
  - **Testler:** `tests/unit/savas/yara_zari_test.gd` (düşen birim kilidi, 4 sonuç dağılımı, Muhafız ölümsüzlük doğrulaması).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.yara.dustu`, `svs.yara.olum`, `svs.yara.agir`, `svs.yara.sakatlik`, `svs.yara.hafif` (TR ve EN).
  - **Sahip:** baştan.

#### SVS-15 — Moral Basamakları ve Moral–Yorgunluk Etkileşimi (`SVS-15.a` – `SVS-15.b`)

- [ ] **SVS-15.a:** Moral basamakları ve bozgun akışı
  - **Amaç:** Birimlerin savaş içinde 4 kademeli moral değişimi yaşamasını, komutan aurasıyla toparlanmasını ve bozguna uğrayınca kaçmasını sağlamak.
  - **Kapsam:** 4 moral basamağı (`kararli` `70–100` [`+1` saldırı], `tedirgin` `45–69` [`0`], `sarsilmis` `20–44` [`-1` saldırı, `-1` savunma], `bozgun` `0–19` [eylemini kaçış kenarına kullanır]); moral tetikleri (dost düştü `-15`, lider düştü `-25`, sayısal üstünlük `+5`, evini savunma `+10`, harami erken kırılma eşiği `30`); komutan aurası (`3` hücre içinde `+1` moral zarı).
  - **Bağımlılıklar:** `SVS-13`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/moral_sistemi.gd`, `data/savas/moral_kurallari.json`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `moral_kurallari.json`: `{basamaklar, isabet_ekleri, tetik_deltalari, komutan_aura_menzili: 3, harami_bozgun_esigi: 30}`.
  - **Kabul ölçütleri:** `bozgun` basamağındaki birim saldırı seçmez, kaçış kenarına yönelir; lideri düşen haramiler tek turda moral kontrolüne girer; komutan `3` hücre içindeyken dostlar `+1` aura bonusu alır.
  - **Testler:** `tests/unit/savas/moral_sistemi_test.gd` (4 basamak geçişi, komutan aurası, bozgun kaçışı).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.moral.kararli`, `svs.moral.tedirgin`, `svs.moral.sarsilmis`, `svs.moral.bozgun` (TR ve EN).
  - **Sahip:** baştan.

- [ ] **SVS-15.b:** Moral–yorgunluk etkileşim kuralı
  - **Amaç:** Yorgunluk ve moral çubuklarını birbirine tek, şeffaf ve öngörülebilir bir kural üzerinden bağlayarak yorgun birimin moralinin daha kolay kırılmasını sağlamak.
  - **Kapsam:** İki ayrı çubuk (`moral`, `yorgunluk`) korunur; tek etkileşim kuralı işler: yorgunluk oranı `%50–%79` iken moral zarına `-1` ve moral kaybına `×1.25`, `%80+` iken moral zarına `-2` ve moral kaybına `×1.5` uygulanır; turda hiç hareket/saldırı yapmadan dinlenme yorgunluğu düşürüp moral zarındaki cezayı kaldırır.
  - **Bağımlılıklar:** `SVS-15.a`, `SVS-16`.
  - **Etkilenen dosya ve klasörler:** `src/savas/moral_sistemi.gd` (tek etkileşim işlevi), `data/savas/moral_kurallari.json` (`yorgunluk_etkilesimi` bloğu). Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `moral_kurallari.json`: `yorgunluk_etkilesimi: {orta_esik_yuzde: 50, orta_zar_cezasi: -1, yuksek_esik_yuzde: 80, yuksek_zar_cezasi: -2}`.
  - **Kabul ölçütleri:** Aynı moral darbesinde yorgunluğu `%85` olan birim, yorgunluğu `%10` olan birimden veri tablosu kadar daha fazla moral kaybeder ve `-2` zar cezası alır; dinlenmeyle yorgunluk düşünce ceza kalkar.
  - **Testler:** `tests/unit/savas/moral_yorgunluk_test.gd` (dinç vs yorgun birim moral kırılma karşılaştırması).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.moral.yorgunluk_etkisi` (TR ve EN).
  - **Sahip:** baştan.

- [ ] **SVS-16:** Yorgunluk çubuğu ve nöbet yorgunluğundan devralma
  - **Amaç:** Her savaş eyleminin ve zırh/silah ağırlığının yorgunluk üretmesini, nöbetten yorgun çıkan muhafız/askerin savaşa yorgun başlamasını sağlamak.
  - **Kapsam:** Eylem başına yorgunluk birikimi (`hareket +1`, `saldırı +2`, `ağır eylem +3`, zırh ağırlığı tur başı `+0..+1`), dinlenme/pas geçme ile düşüş (`-3`), tavan aşımında birimin turda yalnız `1` eylem yapabilmesi ve mevcut nöbet yorgunluğundan (`UZM-14`, `YSM-03`) başlangıç yorgunluğu aktarımı dahildir.
  - **Bağımlılıklar:** `SVS-04.b`, `SVS-11.a`, `ROADMAP_2` (`UZM-14`, `YSM-03`).
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/yorgunluk_sistemi.gd`, `data/savas/yorgunluk_kurallari.json`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `yorgunluk_kurallari.json`: `{nobet_aktarim_orani: 0.5, dinlenme_azaltimi: 3, agirlik_carpani: 1, kisit_esigi_yuzde: 100}`.
  - **Kabul ölçütleri:** Yorgunluk `yorgunluk_tavani`na ulaşan birim sonraki turda `1` eylemle başlar; nöbet yorgunluğu taşıyan karakter savaşın 1. turuna `yorgunluk > 0` ile girer.
  - **Testler:** `tests/unit/savas/yorgunluk_sistemi_test.gd` (tavan kısıtı, dinlenme, nöbet devralımı).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.yorgunluk.kisit` (TR ve EN).
  - **Sahip:** baştan.

- [ ] **SVS-17:** Nöbet tutma (overwatch) ve karşılama saldırısı
  - **Amaç:** Birimin kalan eylemini menzile giren ilk düşmana tepki atışı veya mızrak karşılaması olarak saklayabilmesini sağlamak.
  - **Kapsam:** `nobet_tut` eylemi (kalan eylemi harcar, yön/menzil alanı kurar), düşman hareketiyle tetiklenen tepki saldırısı ve `mizrak` silahının yaklaşan düşmana öncelikli karşılama saldırısı dahildir.
  - **Bağımlılıklar:** `SVS-11.a`, `SVS-12`, `SVS-13`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/nobet_tepkisi.gd`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** veri yok (`silahlar.json` menzil ve `yetenekler.json` tetik alanını okur).
  - **Kabul ölçütleri:** `nobet_tut` aktifken menzile giren ilk düşmana otomatik `1` tepki saldırısı yapılır ve nöbet durumu sıfırlanır; kendi turu başında kullanılmamış nöbet kalkar.
  - **Testler:** `tests/unit/savas/nobet_tepkisi_test.gd` (menzil girişinde tetiklenme, tek seferlik harcanma, mızrak karşılaması).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.eylem.nobet_tut`, `svs.gunluk.nobet_tetiklendi` (TR ve EN).
  - **Sahip:** baştan.

#### SVS-18 — Savaş Bitiş Koşulları ve §5.9 Sonuç Tablosu (`SVS-18.a` – `SVS-18.b`)

- [ ] **SVS-18.a:** Kazanma, mağlubiyet, geri çekilme, teslim ve K4 Muhafız kuralı
  - **Amaç:** Savaşın bitiş koşullarını tek yerde değerlendirmek ve Muhafız'ın ölmemesi (`K4`) ile mağlubiyet kilidini garantiye almak.
  - **Kapsam:**
    1. Bitiş tetikleri: tüm düşmanların düşmesi/kaçması/teslim olması (`galibiyet`); tüm dostların düşmesi/kaçması (`maglubiyet`).
    2. **Muhafız kuralı (K4):** Muhafız HP=`0` olduğu anda savaş durumu `muhafiz_dustu` (mağlubiyet) bayrağı alır; kalan dostlar o turu bitirip harita kenarından çekilebilir, ama galibiyet yazılmaz ve komuta kimseye devredilmez.
    3. Harita kenarından geri çekilme ve bozgun/ağır yarada düşman teslimi.
  - **Bağımlılıklar:** `SVS-14`, `SVS-15.a`, `K4`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/sonuc_cozucu.gd`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** veri yok (`sonuc_tablosu.json` verisini okur).
  - **Kabul ölçütleri:** Muhafız HP=`0` olduğunda düşman sonradan temizlense bile sonuç `galibiyet` olmaz, `muhafiz_dustu` (mağlubiyet) yazılır; harita kenarından çekilen birim canlı kalır ama ganimet alamaz.
  - **Testler:** `tests/unit/savas/sonuc_cozucu_test.gd` (4 bitiş durumu, Muhafız HP=0 mağlubiyeti, teslim ve çekilme).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.sonuc.galibiyet`, `svs.sonuc.maglubiyet`, `svs.sonuc.muhafiz_dustu`, `svs.sonuc.cekilme` (TR ve EN).
  - **Sahip:** baştan.

- [ ] **SVS-18.b:** §5.9 sonuç tablosu (`data/savas/sonuc_tablosu.json`) ve somut başlangıç değerleri
  - **Amaç:** Ön rapordaki §5.9 galibiyet/mağlubiyet tablosunu sayısal başlangıç değerleriyle tek veri dosyasına dökmek.
  - **Kapsam:** `sonuc_tablosu.json` içinde `galibiyet`, `maglubiyet`, `muhafiz_dustu`, `cekilme` ve `kapi_duellosu_kucuk` satırları için somut değerler: ganimet izni, itibar deltaları (`+2` / `-2`), husumet yönü, kaynak kayıp oranları (mağlubiyette ambar/akçe `%15–%25`, sur hasarı `10–25`), moral/güvenlik deltaları (`+10` / `-15`) dahildir.
  - **Bağımlılıklar:** `SVS-18.a`.
  - **Etkilenen dosya ve klasörler:** Yeni `data/savas/sonuc_tablosu.json`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `sonuc_tablosu.json`: `{satirlar: {galibiyet, maglubiyet, muhafiz_dustu, cekilme, kapi_duellosu_kucuk}: {ganimet_izni, itibar_deltasi, husumet_deltasi, kaynak_kayip_orani, sur_hasar_araligi, koy_moral_deltasi, guvenlik_deltasi}}`.
  - **Kabul ölçütleri:** `muhafiz_dustu` satırı ganimet/itibar/kaynak bakımından `maglubiyet` ile özdeş, yara bakımından Muhafız için `en_kotu: agir_yara` döner; tüm oranlar `[0.0, 1.0]` aralığındadır.
  - **Testler:** `tests/unit/savas/sonuc_tablosu_test.gd` (şema ve §5.9 tutarlılık doğrulaması).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** metin yok.
  - **Sahip:** baştan.

- [ ] **SVS-19:** Yalnız test amaçlı YZ–YZ koşucusu (K10)
  - **Amaç:** Otomatik testlerin (`otomatik_oyuncu` ve denge ölçümü) UI açmadan iki tarafı da YZ ile oynatarak savaşı baştan sona tamamlayabilmesini sağlamak.
  - **Kapsam:** Headless YZ–YZ döngüsü (azami tur emniyet sınırı `50` raunt ile sonsuz döngü koruması) dahildir. **Oyuncu menüsünde veya savaş kararı ekranında kesinlikle görünmez (K10); oyuncuya açık otomatik çözüm değildir.** Eski `savunma_gucu` / `HusumetBaskini` formülleriyle aynı sayıyı verme testi yazılmaz.
  - **Bağımlılıklar:** `SVS-18.a`, `SVS-20.a`, `K10`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/yz_test_kosucusu.gd`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** veri yok.
  - **Kabul ölçütleri:** Sabit tohumla bir `3 harami / 2 muhafız` savaşı `<= 30` rauntta sonlanır; `SavasKararPaneli` ve UI sahnelerinde bu koşucuyu çağıran hiçbir düğme yoktur.
  - **Testler:** `tests/unit/savas/yz_test_kosucusu_test.gd` (sonlanma garantisi, UI düğmesi yokluğu taraması).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** metin yok.
  - **Sahip:** baştan.

---

## C. Yapay Zekâ, Zorluk ve Taktik Kurallar (`baştan`)

#### SVS-20 — Fayda Tabanlı YZ, Zorluk Eğrisi ve Baskın Strateji Yasağı (`SVS-20.a` – `SVS-20.c`)

- [ ] **SVS-20.a:** Fayda tabanlı (utility) YZ çekirdeği — hile yasağı
  - **Amaç:** Oyuncuyla birebir aynı zar, görüş ve yorgunluk kurallarına uyan, hile yapmayan fayda tabanlı YZ karar çekirdeğini kurmak.
  - **Kapsam:**
    1. Birimin kalan eylemlerine göre tüm geçerli aday aksiyonların üretilmesi (hareket, saldırı, yetenek, nöbet, geri çekilme).
    2. Fayda puanlama formülü: `beklenen_hasar * hedef_onceligi + oldurme_bonusu + siper_degeri + yan_saldiri_bonusu - alinan_risk`.
    3. Eşitlik kuralı: YZ oyuncudan farklı zar/istatistik bonusu almaz, sis arkasını görmez.
  - **Bağımlılıklar:** `SVS-12`, `SVS-13`, `SVS-15.a`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/savas_yz.gd`, `data/savas/yz_kurallari.json`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `yz_kurallari.json`: `{puan_agirliklari: {hasar, oldurme_bonusu, siper, yan_saldiri, tehlike_cezasi}}`.
  - **Kabul ölçütleri:** YZ hiçbir koşulda oyuncudan farklı zar/istatistik bonusu almaz; görünmeyen (LoS dışı) birime saldırmaz; sabit tohumda aynı durumu tekrarlar.
  - **Testler:** `tests/unit/savas/savas_yz_test.gd` (hile yokluğu, LoS sınırı, tutarlı puanlama).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** metin yok.
  - **Sahip:** baştan.

- [ ] **SVS-20.b:** Zorluk eğrisi (evreler ve düşman bileşimi)
  - **Amaç:** İlk savaşların küçük ve okunaklı kalmasını, ilerleyen günlerde zorluğun YZ hilesiyle değil birim sayısı ve düşman bileşimiyle `20` birim tavana (`K15`) kadar artmasını sağlamak.
  - **Kapsam:** Tek `zorluk_egrisi.json` tablosu ve 4 evre:
    1. Evre 1 (Gün `1–10`): `2–4` hafif düşman (harami/asker kaçağı, düşük zırh, menzilsiz).
    2. Evre 2 (Gün `11–25`): `4–8` karma düşman (eşkıya okçusu + çete reisi dahil).
    3. Evre 3 (Gün `26–45`): `8–14` zırhlı/menzilli düşman (tekfur yayası, arbaletçi, Moğol öncü).
    4. Evre 4 (Gün `46+`): `12–20` birim (tavan `K15` = 20), mızraklı atlı + kuşatma/yangın bileşimi.
  - **Bağımlılıklar:** `SVS-20.a`, `SVS-05`, `SVS-08`, `K15`.
  - **Etkilenen dosya ve klasörler:** Yeni `data/savas/zorluk_egrisi.json`, `src/savas/zorluk_secici.gd`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `zorluk_egrisi.json`: `{evreler: [{id, gun_min, gun_max, dusman_min, dusman_max, puan_butcesi, izinli_sablonlar}]}`.
  - **Kabul ölçütleri:** Gün `1–10` arasında hiçbir savaş `4` düşmandan fazla üretmez; hiçbir evrede toplam sahne birimi `20`'yi aşmaz (`K15`); evre yükseldikçe `SavasZari` veya YZ bonusları değişmez.
  - **Testler:** `tests/unit/savas/zorluk_egrisi_test.gd` (4 evre birim ve bileşim sınırları, 20 tavanı).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** metin yok.
  - **Sahip:** baştan.

- [ ] **SVS-20.c:** Baskın strateji yasağı ve karşı hamle kuralları
  - **Amaç:** Oyuncunun tek bir baskın stratejiyi ("hep yay", "hep kapıda bekle", "tek ağır zırhlıyla geçidi tıka") tekrarlayarak oyunu kırmasını veri tablosuyla engellemek.
  - **Kapsam:** Adıyla tanımlı 3 baskın stratejiye karşı otomatik YZ ve saha kuralları:
    1. **`"hep yay"` yasağı:** Dostların `>= %60`'ı menzilli ise YZ `kalkan_duvari` (`+3` menzil savunması) ve hızlı atlı/yan baskın ağırlığını `+40` artırır; ayrıca `SVS-57` cephane sınırı okçuyu yakın dövüşe zorlar.
    2. **`"hep kapıda bekle"` yasağı:** Oyuncu `3` raunt boyunca kapı gerisinden çıkmazsa YZ `kapi_baltasi`, kundaklama (`SVS-26`) ve sur tırmanma/çevirme ağırlığını `+50` artırır.
    3. **`"tek tankla blokla"` yasağı:** Tek birime `2+` düşman yaklaşınca `SVS-56` yan saldırı (`flanking`) cezası ve `topuz` zırh delme önceliği devreye girer.
  - **Bağımlılıklar:** `SVS-20.a`, `SVS-56`, `SVS-57`.
  - **Etkilenen dosya ve klasörler:** Yeni `data/savas/baskin_strateji_karsi.json`; `src/savas/savas_yz.gd` (karşı ağırlık okuyucu). Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `baskin_strateji_karsi.json`: `{hep_yay_esik_orani: 0.6, hep_yay_kalkan_bonusu: 40, kapi_bekleme_raunt_esigi: 3, kapi_yangin_bonusu: 50, tank_cevre_bonusu: 35}`.
  - **Kabul ölçütleri:** Tamamı okçu dost grubuna karşı tekfur yayası `kalkan_duvari` açar; `3` raunt kapıda bekleyene karşı YZ kundaklama/kapı baltası seçer.
  - **Testler:** `tests/unit/savas/baskin_strateji_test.gd` (3 yasaklı stratejiye karşı YZ puan kayması doğrulaması).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** metin yok.
  - **Sahip:** baştan.

- [ ] **SVS-21:** Davranış profilleri tek tablosu
  - **Amaç:** Farklı düşman ve yardımcı dost sınıflarının aynı YZ çekirdeği üzerinde farklı taktik karakterler sergilemesini sağlamak.
  - **Kapsam:** Tek veri tablosunda 5 profil ağırlığı (`harami`: ganimet hücresi + zayıf hedef + erken kaçış; `tekfur_yayasi`: kapı/gedik + kalkan duvarı; `atli_okcu`: mesafe koruma + `sahte_ricat`; `koylu_milis`: mevzi savunması; `caresiz_tek_kisi`: kaçış yolu arama, sıkışınca saldırı) dahildir. Profil başına ayrı kod veya madde açılmaz.
  - **Bağımlılıklar:** `SVS-20.a`, `SVS-05`.
  - **Etkilenen dosya ve klasörler:** Yeni `data/savas/yz_profilleri.json`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `yz_profilleri.json`: `{id, agirliklar: {saldiri, siper, ganimet_hedefi, kapi_hedefi, mesafe_koru, kacis}}`.
  - **Kabul ölçütleri:** `harami` profili eşit mesafede ambar/ganimet hücresini hedefler; `atli_okcu` atıştan sonra kalan eylemiyle mesafe açar; `tekfur_yayasi` kapıya ilerler.
  - **Testler:** `tests/unit/savas/yz_profilleri_test.gd` (sabit haritada 5 profilin beklenen hamle seçimi).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** metin yok.
  - **Sahip:** baştan.

- [ ] **SVS-22:** Düşman niyet gösterimi
  - **Amaç:** Oyuncunun taktik okuyabilmesi için düşmanın bir sonraki hedef/hamle niyetini (Into the Breach tarzı) gözcü kulesi ve keşif eri durumuna bağlı olarak göstermesini sağlamak.
  - **Kapsam:** YZ'nin seçtiği aday hedef hücresi/birimi niyet verisinin üretilmesi; Gözcü kulesi (`HAR-06`) ayaktaysa veya kadroda keşif eri (`CHR_023`) savaştaysa niyet çizgisinin açılması, aksi halde gizli kalması dahildir.
  - **Bağımlılıklar:** `SVS-20.a`, `ROADMAP_2` (`HAR-06`).
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/niyet_gosterimi.gd`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** veri yok.
  - **Kabul ölçütleri:** Gözcü kulesi yokken ve keşif eri yokken niyet listesi boştur (`0` kayıt); kule varken yaklaşan düşmanların hedef niyeti veri olarak döner.
  - **Testler:** `tests/unit/savas/niyet_gosterimi_test.gd` (gözcü kulesi/keşif eri açık-kapalı ayrımı).
  - **Asset:** Niyet oku/çizgisi `docs/EKSIK_ASSET_ENVANTERI.md` (2B başlığı) altına yazılır.
  - **Metin anahtarları:** `svs.ipucu.niyet_gizli` (TR ve EN).
  - **Sahip:** baştan.

- [ ] **SVS-55:** Arazi, mevsim/hava etkisi ve hareket maliyeti
  - **Amaç:** Çamur, kar ve engebenin hareket/yorgunluk maliyetini artırmasını, yağmur ve kış sisinin ise menzilli saldırı ve görüşü etkilemesini sağlamak.
  - **Kapsam:** Mevcut `Takvim` mevsim/hava durumu verisinin okunması; arazi maliyet tablosu (`duz: 1`, `engebe/camur: 2` hareket, `kar: +1` yorgunluk); yağmur/kış sisinde yay/arbalet menzil `-1` ve isabet `-1` kuralı dahildir.
  - **Bağımlılıklar:** `SVS-08`, `SVS-12`, `SVS-13`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/arazi_ve_hava.gd`, `data/savas/hava_etkileri.json`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `hava_etkileri.json`: `{zemin_maliyeti: {duz, camur, kar, engebe}, hava_etkisi: {acik, yagmur, kar_firtinasi}: {gorus_delta, menzil_delta, isabet_delta}}`.
  - **Kabul ölçütleri:** Yağmurda yay menzili `1` hücre kısalır; çamur hücresinden geçmek `2` hareket adımı harcar; açık havada ek ceza `0`'dır.
  - **Testler:** `tests/unit/savas/arazi_ve_hava_test.gd` (mevsim/hava cezaları ve çamur/kar hareket maliyeti).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.hava.yagmur`, `svs.hava.kar`, `svs.arazi.camur` (TR ve EN).
  - **Sahip:** baştan.

- [ ] **SVS-56:** Cephe düzeni ve yan saldırı (flanking) kuralları
  - **Amaç:** Battle Brothers tarzı ön/arka sıra korumasını ve bir birimi iki düşman arasına sıkıştırmanın/arkadan vurmanın taktik ödülünü kurmak.
  - **Kapsam:**
    1. **Yan saldırı (flanking):** Hedef birime `2` veya daha fazla düşman bitişikse saldırana `+2` isabet (ek her bitişik düşman için `+1`, en çok `+3`) ve hedefe `-5` moral darbesi yazılır.
    2. **Ön/arka sıra koruması:** Önünde dost kalkanlı/mızraklı birim duran okçu/hekime doğrudan yakın dövüşe geçiş engellenir (etrafından dolaşmak gerekir).
  - **Bağımlılıklar:** `SVS-08`, `SVS-12`, `SVS-13`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/cephe_ve_kusatma_bonusu.gd`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `data/savas/isabet_kurallari.json` içine `flanking_taban_bonusu: 2`, `flanking_tavan: 3`, `flanking_moral_cezasi: -5`.
  - **Kabul ölçütleri:** İki düşmanla bitişik birime yapılan yakın saldırı `+2` isabet bonusu alır; önü dost birimle kapalı arka sıra birimine doğrudan yakın saldırı yapılamaz.
  - **Testler:** `tests/unit/savas/cephe_flanking_test.gd` (2+ düşman flanking bonusu, ön sıra koruması).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.taktik.yan_saldiri` (TR ve EN).
  - **Sahip:** baştan.

- [ ] **SVS-57:** Cephane sınırı ve savaş içi mühimmat tüketimi
  - **Amaç:** Okçuların sonsuz ok atmasını önleyerek "hep yay" baskın stratejisini kırmak ve ok stoğunu köy ekonomisine bağlamak.
  - **Kapsam:** Savaş başında menzilli birimlere mühimmat kotası verilmesi (`turk_yayi: 10` ok, `arbalet: 8` cıvata, `sapan: 12` taş); atış başına `1` cephane düşümü; cephane `0` olunca birimin yakın dövüş yedek silahına (`kilic`/`bicak`/`sopa`) geçmesi ve savaş sonunda harcanan okların köy stoğundan düşülmesi dahildir.
  - **Bağımlılıklar:** `SVS-04.a`, `SVS-04.b`, `SVS-13`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/cephane_yoneticisi.gd`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `data/savas/silahlar.json` içine `cephane_kotasi` ve `yedek_yakin_silah` alanları.
  - **Kabul ölçütleri:** `10` atıştan sonra `turk_yayi` birimi bir daha menzilli atış yapamaz ve otomatik yakın dövüş silahına geçer; harcanan ok sayısı köy ok stoğundan düşülür (`>= 0`).
  - **Testler:** `tests/unit/savas/cephane_yoneticisi_test.gd` (kota tükenmesi, yakın silaha geçiş, köy ok stoğu düşümü).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.cephane.bitti`, `svs.cephane.kalan` (TR ve EN).
  - **Sahip:** baştan.

---

## D. Savaş Türleri (`baştan`)

#### SVS-23 — Kapı Arbedesi ve Muhafız Düellosu (`SVS-23.a` – `SVS-23.b`, K11)

- [ ] **SVS-23.a:** `CAT-02` iki yol seçimi ve eski tek zar çözümünün kapatılması
  - **Amaç:** `CAT-01`/`CAT-02` kapı kavgasının "askerle karşılık" seçeneğini iki oynanır yola (adamlarını gönder vs muhafız düellosu) bağlamak ve eski tek zar otomatik çözümünü kapatmak.
  - **Kapsam:**
    1. `CAT-02` 4 ana seçeneğinin korunması (5. kapı seçeneği kesinlikle açılmaz, `K11`).
    2. "Askerle karşılık" seçilince alt seçim: `adamlari_gonder` (`1–3` asker vs `1–3` saldırgan) veya `muhafiz_duellosu` (`1v1` Muhafız vs kapıdaki karakter).
    3. Eski tek zar sonucunun oyuncuya kapalı kalması.
  - **Bağımlılıklar:** `SVS-09`, `ROADMAP_1` (`CAT-01`, `CAT-02`), `K11`.
  - **Etkilenen dosya ve klasörler:** Mevcut `src/kapi/kapi_kavgasi.gd` ve `src/arayuz/kapi_kavgasi_paneli.gd` içine ince adaptör. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** veri yok (`data/kapi_kavgasi.json` tetikleyicisini okur).
  - **Kabul ölçütleri:** Kapı kavgası panelinde ana seçenek sayısı `4` kalır; "askerle karşılık" tıklandığında eski tek zar sonucu yerine iki K11 yolu sunulur.
  - **Testler:** `tests/unit/savas/kapi_arbedesi_secim_test.gd` (4 seçenek sınırı, 2 yol açılışı, eski tek zar yolunun kapalı olması).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.kapi.adamlari_gonder`, `svs.kapi.muhafiz_duellosu` (TR ve EN).
  - **Sahip:** baştan.

- [ ] **SVS-23.b:** Kapı arenası düello ve arbede savaş akışı
  - **Amaç:** Kapı arbedesinin ve `1v1` Muhafız düellosunun `kapi_arenasi` üzerinde sıra tabanlı oynanmasını ve `§5.9` küçük ölçekli sonuç tablosuna bağlanmasını sağlamak.
  - **Kapsam:**
    1. `kapi_arenasi` doğuşu (`1v1` veya `1–3`'e `1–3`).
    2. Düello kuralı: taraflardan biri `bozgun`a uğrarsa kaçış kenarından gider; `caresiz_sivil` öldürülürse ağır sosyal ceza yazılır.
    3. Savaş sonu: `kapi_duellosu_kucuk` satırı (`SVS-18.b`) ile kin, yara ve dedikodu sonucunun kapı ekranına dönmesi; Muhafız HP=`0` ise ölmez (`K4`).
  - **Bağımlılıklar:** `SVS-23.a`, `SVS-09`, `SVS-18.b`, `K4`, `K11`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/turler/kapi_arbedesi_akisi.gd`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** veri yok (`sonuc_tablosu.json` içindeki `kapi_duellosu_kucuk` satırını kullanır).
  - **Kabul ölçütleri:** Her iki yol da `SavasDurumu` başlatır; Muhafız HP=`0` olduğunda düello mağlubiyet sayılır ve Muhafız hayatta kalır; kapı sırasındaki korku (`CAT-04`) akışıyla uyumludur.
  - **Testler:** `tests/unit/savas/kapi_arbedesi_test.gd` (iki yolun da arena başlatması, Muhafız HP=0 mağlubiyeti).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.kapi.duello_basladi`, `svs.kapi.duello_bitti` (TR ve EN).
  - **Sahip:** baştan.

- [ ] **SVS-24:** Gece baskını (`Husumet.gece` ve `CAS-08`)
  - **Amaç:** Soyut kalan `HusumetBaskini` ve Karaboran intikamını (`CAS-08`) köy ızgarasında gece görüş kısıtlı oynanır baskın savaşına çevirmek.
  - **Kapsam:** Gece görüşü (`SVS-12`), ambar/ağıl hedefleyen harami baskını kurulumu, `CAS-08` tetiği ve kurt sürüsü (`MEV-10`) hafif baskın varyantı (veri parametresiyle) dahildir.
  - **Bağımlılıklar:** `SVS-12`, `SVS-18.a`, `SVS-21`, `ROADMAP_1` (`CAS-08`, `MEV-10`, `BUG-18`).
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/turler/gece_baskini_akisi.gd`; mevcut `src/koy/husumet_baskini.gd` içine ince adaptör. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `data/savas/senaryolar/gece_baskini.json`: `{hedef_binalar, ganimet_calma_turu, kurt_varyanti_parametreleri}`.
  - **Kabul ölçütleri:** Nüfus eşiği altındayken (`BUG-18` / `OMR-42`) kurt dışı gece baskını açılmaz; gece görüş kısıtı aktiftir; baskın sonucu mevcut husumet/stok alanlarına yazar.
  - **Testler:** `tests/unit/savas/gece_baskini_test.gd` (gece görüşü, `BUG-18` kapısı, ambar hedefleme).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.baskin.baslik`, `svs.baskin.karaboran` (TR ve EN).
  - **Sahip:** baştan.

#### SVS-25 — Kapı ve Sur Kuşatması (`SVS-25.a` – `SVS-25.b`)

- [ ] **SVS-25.a:** Kuşatma hazırlığı ve yaklaşma evresi
  - **Amaç:** Tekfur baskını (`HAR-03`) başladığında `HAR-10` konuşlanmasını sahneye taşıyıp `20` birim tavanını (`K15`) ve yaklaşma dalgasını kurmak.
  - **Kapsam:**
    1. `koy_yonetimi.gd:_asamalar` içinden tek satırlık adaptör tetiği.
    2. `HAR-10` konuşlanmasının (kapı mızraklısı, sur okçusu, devriye) başlangıç hücrelerine yerleşimi.
    3. `20` birim tavanı (`K15`) süzgeci ile tekfur öncü dalgasının (yaya + okçu/arbalet) harita dış sınırından girişi.
  - **Bağımlılıklar:** `SVS-08`, `SVS-21`, `ROADMAP_1` (`HAR-03`, `HAR-10`), `K15`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/turler/kusatma_akisi.gd`; `src/koy/koy_yonetimi.gd` içine tek satırlık adaptör. Korumalı çekirdeğe başka dokunuş yok.
  - **Veri şeması:** `data/savas/senaryolar/tekfur_kusatmasi.json`: `{evreler, kapi_gedik_esigi, takviye_rauntlari, birim_tavani: 20}`.
  - **Kabul ölçütleri:** Kuşatmada sahneye giren birim sayısı `<= 20`'dir (`K15`); `HAR-10` sur okçuları sur hücrelerinde başlar.
  - **Testler:** `tests/unit/savas/kusatma_hazirlik_test.gd` (20 birim tavanı, `HAR-10` yerleşimi).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.kusatma.baslik` (TR ve EN).
  - **Sahip:** baştan.

- [ ] **SVS-25.b:** Çok aşamalı kuşatma akışı (kapı, gedik ve iç avlu)
  - **Amaç:** Tekfur kuşatmasının kapı zorlama, gedik açılışı ve iç avlu savunması aşamalarıyla oynanmasını ve `SON_TEKFUR` sonucuna bağlanmasını sağlamak.
  - **Kapsam:**
    1. **Evre 1 (Yaklaşma ve sur ateşi):** Tekfur yayaları kalkan duvarıyla kapıya yaklaşırken sur okçuları yüksekten ateş eder.
    2. **Evre 2 (Kapı ve sur zorlama):** Balta ve ateşle kapı sağlamlığı (`SVS-26`) düşürülür.
    3. **Evre 3 (Gedik ve iç avlu):** Kapı sağlamlığı `0` olunca iç avlu geçidi açılır; savunma veya mağlubiyet (`SON_TEKFUR`) burada kesinleşir. `savunma_gucu()` formülü silinmez ama kuşatma sonucu savaşla belirlenir.
  - **Bağımlılıklar:** `SVS-25.a`, `SVS-26`, `SVS-18.b`.
  - **Etkilenen dosya ve klasörler:** `src/savas/turler/kusatma_akisi.gd` (evre geçişleri). Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `tekfur_kusatmasi.json` içindeki `evre_gecis_kosullari` alanı.
  - **Kabul ölçütleri:** Kapı sağlamlığı `0` olunca iç avlu hücreleri geçilebilir hale gelir; kuşatma mağlubiyeti `SON_TEKFUR` bayrağını tetikler; `savunma_gucu()` mevcut testleri bozulmaz.
  - **Testler:** `tests/unit/savas/kusatma_akisi_test.gd` (kapı gediği açılışı, 3 evre geçişi, mağlubiyet/galibiyet bayrağı).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.kusatma.gedik_acildi`, `svs.kusatma.ic_avlu` (TR ve EN).
  - **Sahip:** baştan.

- [ ] **SVS-26:** Kapı ve sur hasarı, yangın ve savaş sonrası onarım
  - **Amaç:** Savaş sırasında kapıya ve binalara verilen fiziksel hasar ile yangının kalıcı olmasını ve mevcut onarım ekonomisine bağlanmasını sağlamak.
  - **Kapsam:** Balta/ateşle kapı ve sura (`sur_hasar`) hasar verilmesi, raunt sonunda yanıcı hücrelere yangın yayılması (`yaz_su_yangin` / ambar kundaklaması bağı), su/köylü müdahalesi ile söndürme ve savaş sonrası mevcut taş/kereste bedeliyle (`KRI-06` onarım modeli) onarım dahildir.
  - **Bağımlılıklar:** `SVS-08`, `SVS-10`, `ROADMAP_1` (`KRI-06`).
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/yapi_ve_yangin.gd`, `data/savas/yangin_kurallari.json`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `yangin_kurallari.json`: `{yayilma_olasiligi: 0.35, kapi_can: 40, sur_hasar_carpani: 1.0, sondurme_eylem_bedeli: 1}`.
  - **Kabul ölçütleri:** Kapı hasarı savaş bitince köyün `sur_hasar` alanına kalıcı olarak yazılır; yangın her raunt sonunda komşu yanıcı hücreye veri olasılığıyla sıçrar; onarım taş/kereste stoğundan düşer.
  - **Testler:** `tests/unit/savas/yapi_ve_yangin_test.gd` (sabit tohumlu yangın yayılması, `sur_hasar` kalıcılığı, onarım bedeli).
  - **Asset:** Yangın/duman efekt yer tutucusu `docs/EKSIK_ASSET_ENVANTERI.md` içine yazılır.
  - **Metin anahtarları:** `svs.yangin.basladi`, `svs.yangin.sonduruldu`, `svs.yapi.kapi_kirildi` (TR ve EN).
  - **Sahip:** baştan.

- [ ] **SVS-27:** Moğol tehdidi — küçük grup savaşı ve büyük kol karar düğümü (K5)
  - **Amaç:** `HAR-02` (`mogol_oncusu.gd`) ve `DNY-01` Moğol ilerleyişi sayacı dolduğunda K5 kararına uygun iki farklı çözüm yolu sunmak.
  - **Kapsam:** Küçük öncü/keşif grubu (`3–8` atlı okçu) için sıra tabanlı savaş; büyük akın kolu için **savaşsız karar düğümü** (`kaç`, `saklan`, `haraç ver`, `elçiyle görüş`) dahildir. Büyük kol kesinlikle savaş sahnesi açmaz.
  - **Bağımlılıklar:** `SVS-18.a`, `SVS-21`, `ROADMAP_1` (`HAR-02`), `ROADMAP_2` (`DNY-01`), `K5`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/turler/mogol_tehdidi_akisi.gd`; mevcut `src/sistemler/mogol_oncusu.gd` içine ince adaptör. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `data/savas/senaryolar/mogol_tehdidi.json`: `{kucuk_grup_min: 3, kucuk_grup_max: 8, buyuk_kol_kararlari: [kac, saklan, harac, elci]}`.
  - **Kabul ölçütleri:** Küçük grupta `<= 8` Moğol atlısı savaş başlatır; büyük kolda hiçbir karar savaş motorunu tetiklemez, sonuç doğrudan kaynak/itibar/kayıp alanlarına yazar.
  - **Testler:** `tests/unit/savas/mogol_tehdidi_test.gd` (küçük grup savaş açılışı, büyük kol savaşsız 4 karar sonucu).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.mogol.oncu_savas`, `svs.mogol.buyuk_kol_baslik`, `svs.mogol.kac`, `svs.mogol.saklan`, `svs.mogol.harac`, `svs.mogol.elci` (TR ve EN).
  - **Sahip:** baştan.

- [ ] **SVS-28:** Dış sefer ve pusu temizliği (`HAR-05`, `HAR-14`)
  - **Amaç:** Oyuncunun kendi seçtiği küçük bir grupla köy dışındaki harita düğümünde pusu temizleme saldırısını oynanır kılmak.
  - **Kapsam:** Harita düğümü (dağ yolu/geçit) ızgarası, `3–8` gönüllü/seçilmiş köylü ve gazi/alp katılımı, zaferde `pusu_ticaret_akisi.gd` (`HAR-14`) tüccar akışı ve ganimet ödülü dahildir.
  - **Bağımlılıklar:** `SVS-18.a`, `SVS-21`, `ROADMAP_1` (`HAR-05`, `HAR-14`).
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/turler/dis_sefer_akisi.gd`, `data/savas/haritalar/dag_gecidi.json`; mevcut `src/koy/ticaret/pusu_ticaret_akisi.gd` içine ince adaptör. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `dag_gecidi.json`: `{id, genislik, yukseklik, pusu_siperleri, dost_giris, dusman_pusu_noktalari}`.
  - **Kabul ölçütleri:** Sefer zaferi `HAR-14` tüccar ağırlığı bonusunu `3` günlüğüne yazar; köyde en az nöbetçi bırakılmadan sefer başlatılamaz; `BUG-18` nüfus eşiği korunur.
  - **Testler:** `tests/unit/savas/dis_sefer_test.gd` (geçit haritası kurulumu, `HAR-14` bonusu bağlantısı).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.sefer.baslik`, `svs.sefer.pusu_temizlendi` (TR ve EN).
  - **Sahip:** baştan.

- [ ] **SVS-29:** Kervan koruma savaşı
  - **Amaç:** `kervan_korumasi.json` akışını yol haritasında kervanı kaçırma/koruma hedefli oynanır bir savunma senaryosuna bağlamak.
  - **Kapsam:** Tarafsız tüccar kervanı birimleri (sivil), kervanın kaçış kenarına ulaşmasıyla kazanma koşulu, sivil ölümü durumunda ağır itibar/ticaret cezası dahildir.
  - **Bağımlılıklar:** `SVS-18.a`, `SVS-28`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/turler/kervan_koruma_akisi.gd`, `data/savas/haritalar/kervan_yolu.json`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `kervan_yolu.json`: `{id, kervan_cikis_kenari, sivil_sayisi, koruma_min: 2, koruma_max: 6}`.
  - **Kabul ölçütleri:** Kervan birimleri çıkış kenarına ulaşınca savaş `galibiyet` ile biter; bir kervan sivili ölürse tüccar itibarı veri kadar düşer.
  - **Testler:** `tests/unit/savas/kervan_koruma_test.gd` (kervan kaçış zaferi, sivil ölüm cezası).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.kervan.baslik`, `svs.kervan.kurtuldu`, `svs.kervan.sivil_kaybi` (TR ve EN).
  - **Sahip:** baştan.

- [ ] **SVS-30:** Müttefik takviyesi (Türkmen obası ve uç beyi / subaşı)
  - **Amaç:** İttifak (`HAR-07`) veya büyük tehditte uç beyi/subaşı talebiyle (`HAR-04`) savaşa dost takviye birimlerinin katılmasını sağlamak.
  - **Kapsam:** `oba_ittifaki.gd` aktifken Türkmen oba atlısı (alp) takviyesi; büyük kuşatmada uç beyi/subaşı askerlerinin geç ve pazarlıklı (borç/ferman doğurarak) sahaya girmesi; `20` birim tavanına (`K15`) takılmadan yedek sırası dahildir.
  - **Bağımlılıklar:** `SVS-06.a`, `SVS-08`, `SVS-10`, `ROADMAP_1` (`HAR-04`, `HAR-07`), `K1`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/muttefik_takviyesi.gd`; mevcut `src/koy/oba_ittifaki.gd` ve `src/sistemler/sancak_asker_talebi.gd` içine ince adaptör. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `data/savas/takviye_kurallari.json`: `{turkmen_alp_sayisi: 2, uc_beyi_gecikme_raundu: 3, uc_beyi_borc_akcesi: 30}`.
  - **Kabul ölçütleri:** İttifak yokken Türkmen takviyesi gelmez; toplam birim sayısı takviye dahil `20`'yi geçmez (`K15`); uç beyi yardımı kabul edilirse borç/ferman kayda yazılır.
  - **Testler:** `tests/unit/savas/muttefik_takviyesi_test.gd` (ittifak açık/kapalı, 20 birim tavanı koruması, borç kaydı).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.takviye.turkmen_geldi`, `svs.takviye.subasi_pazarlik` (TR ve EN).
  - **Sahip:** baştan.

- [ ] **SVS-54:** Okçuluk mini oyunu ile sur okçusu becerisi bağlantısı (K9)
  - **Amaç:** Mevcut `okculuk_oyunu.gd` mini oyunundaki performansın `HAR-10` sur okçusu birimlerinin savaş becerisine yansımasını sağlamak.
  - **Kapsam:** Okçuluk mini oyun skorunun sur okçusu `menzil_becerisi` bonusuna (`+1..+2` tavanıyla sınırlı) bağlanması dahildir. İkinci bir mini oyun yazılmaz.
  - **Bağımlılıklar:** `SVS-03`, `SVS-06.a`, `ROADMAP_1` (`HAR-10`), `K9`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/okculuk_beceri_bagi.gd`; mevcut `src/arayuz/okculuk_oyunu.gd` içine tek satırlık adaptör. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `data/savas/donusum_kurallari.json` içine `okculuk_beceri_bonusu_tavan: 2` alanı.
  - **Kabul ölçütleri:** Okçuluk skoru eşiği geçince `HAR-10` sur okçusu rolündeki birimlerin `menzil_becerisi` veri tavanı kadar artar; diğer roller etkilenmez.
  - **Testler:** `tests/unit/savas/okculuk_beceri_bagi_test.gd` (skor→beceri artışı ve tavan sınırı).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.okculuk.talim_bonusu` (TR ve EN).
  - **Sahip:** baştan.

---

## E. Savaş Öncesi ve Sonrası (`sondan`)

- [ ] **SVS-31:** Savaş kararı paneli (otomatik çözüm yok, K10, K11)
  - **Amaç:** Oyuncuya her tehditte savaş, pazarlık, rüşvet (akçe/erzak), kapıyı kapatıp bekleme ve kaçma/saklanma kararlarını tek ekranda sunmak; gözcü kulesi durumuna göre düşman özetini göstermek.
  - **Kapsam:** Karar seçenekleri, Gözcü kulesi (`HAR-06`, `HAR-13`) yoksa düşman sayısının `"bilinmiyor"` görünmesi, pazarlıkta mevcut söz/zar akışı ve kapı arbedesinde K11'e göre `"adamlarını gönder"` / `"muhafız düellosu"` ayrımı dahildir. **Otomatik çöz düğmesi kesinlikle yoktur (K10).**
  - **Bağımlılıklar:** `SVS-23.a`, `SVS-24`, `SVS-25.a`, `SVS-27`, `ROADMAP_1` (`HAR-06`, `HAR-13`), `K10`, `K11`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/arayuz/savas/savas_karar_paneli.gd` ve `.tscn`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** veri yok.
  - **Kabul ölçütleri:** Panelde "otomatik çöz" veya "atla" düğmesi `0` adettir; gözcü kulesi yokken düşman sayısı gizlenir; kapı arbedesinde iki K11 yolu görünür.
  - **Testler:** `tests/unit/savas/savas_karar_paneli_test.gd` (otomatik çöz yokluğu, gözcü kulesi açık/kapalı, K11 seçenekleri).
  - **Asset:** 2B panel düzeni Bölüm 43 temasıyla yapılır; ek ikonlar `docs/EKSIK_ASSET_ENVANTERI.md` içine yazılır.
  - **Metin anahtarları:** `svs.karar.savas`, `svs.karar.pazarlik`, `svs.karar.rusvet`, `svs.karar.kapat`, `svs.karar.kac`, `svs.karar.sayi_bilinmiyor` (TR ve EN).
  - **Sahip:** sondan.

- [ ] **SVS-32:** Konuşlanma ekranı (`HAR-10` başlangıç dizilişi)
  - **Amaç:** Savaş başlamadan önce `HAR-10` rollerinin (kapı mızraklısı, sur okçusu, devriye) başlangıç hücrelerine otomatik yerleştirilmesini ve oyuncunun sınırlı yeniden diziliş yapabilmesini sağlamak.
  - **Kapsam:** `savunma_konuslanmasi.gd` verisinden başlangıç koordinatlarının okunması, yalnızca izinli konuşlanma bölgesinde birim yeri değiştirme ve savaşı başlatma düğmesi dahildir.
  - **Bağımlılıklar:** `SVS-08`, `SVS-31`, `ROADMAP_1` (`HAR-10`, `HAR-15`).
  - **Etkilenen dosya ve klasörler:** Yeni `src/arayuz/savas/konuslanma_paneli.gd`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** veri yok (`data/savunma_konuslanmasi.json` ve harita doğuş hücrelerini okur).
  - **Kabul ölçütleri:** `HAR-10`daki sur okçuları başlangıçta sur hücrelerine yerleşir; izinli bölge dışına birim sürüklenemez; `20` birim sınırı (`K15`) korunur.
  - **Testler:** `tests/unit/savas/konuslanma_paneli_test.gd` (HAR-10 yerleşim eşleşmesi, bölge sınırı).
  - **Asset:** Konuşlanma hücresi vurgusu `docs/EKSIK_ASSET_ENVANTERI.md` (2B başlığı) altına yazılır.
  - **Metin anahtarları:** `svs.konuslanma.baslik`, `svs.konuslanma.baslat` (TR ve EN).
  - **Sahip:** sondan.

- [ ] **SVS-33:** Ganimet paylaşımı ve adalet/yozlaşma terazisi (K13)
  - **Amaç:** Savaş zaferi sonrası ele geçirilen ganimetin (silah, zırh, at, akçe, `YAP-56` usta defteri) paylaşımını ahlaki bir terazi kararına dönüştürmek.
  - **Kapsam:**
    1. Ganimet havuzunun toplanması (yenilen/teslim olan düşmandan akçe, teçhizat, at ve `YAP-56` usta defteri düşme kontrolü).
    2. Üçlü paylaşım seçimi: `beye_pay` (bey/uç beyi ilişkisi `+1`, köye `%50`), `koye_pay` (adalet terazisi `+2`, tüm akçe/erzak köye), `muhafiza_pay` (yozlaşma terazisi `+2`, kişisel kese `+`, asker morali düşebilir).
    3. Seçilen payın mevcut köy kasasına, vergi/terazi sistemine ve envantere yazılması.
  - **Bağımlılıklar:** `SVS-18.b`, `ROADMAP_2` (`YAP-56`), `K13`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/ganimet_paylasimi.gd`, `data/savas/ganimet_tablosu.json`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `ganimet_tablosu.json`: `{secenekler: {beye_pay, koye_pay, muhafiza_pay}, terazi_deltalari, defter_dusme_olasiligi: 0.15}`.
  - **Kabul ölçütleri:** `muhafiza_pay` seçimi yozlaşma yönüne, `koye_pay` adalet yönüne terazi deltası yazar; toplam dağıtılan akçe ganimet toplamını aşmaz; `YAP-56` usta defteri düşerse envantere eklenir.
  - **Testler:** `tests/unit/savas/ganimet_paylasimi_test.gd` (terazi yönü, akçe toplam koruması, defter düşmesi).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.ganimet.beye_pay`, `svs.ganimet.koye_pay`, `svs.ganimet.muhafiza_pay` (TR ve EN).
  - **Sahip:** sondan.

#### SVS-34 — Esir ve Fidye Akışı (`SVS-34.a` – `SVS-34.b`, K14)

- [ ] **SVS-34.a:** Esir yakalama, zindanda tutma ve günlük erzak maliyeti
  - **Amaç:** Savaşta teslim olan veya HP `0` ile alanda kalan düşmanların esir olarak zindana alınmasını ve günlük erzak maliyetinin işlemesini sağlamak.
  - **Kapsam:**
    1. Teslim olan veya savaş sonu hayatta kalan düşmanların esir listesine eklenmesi (zindan kapasitesi sınırıyla).
    2. Zindandaki her esir için gece sonu günlük erzak bedeli düşümü; erzak yoksa esir sağlığı/kaçış riski.
  - **Bağımlılıklar:** `SVS-18.a`, `K14`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/esir_yoneticisi.gd`, `data/savas/esir_kurallari.json`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `esir_kurallari.json`: `{zindan_kapasitesi: 6, gunluk_erzak_bedeli: 1, fidye_degerleri_sinif: {harami: 8, cete_reisi: 25, tekfur_yayasi: 15, mogol_oncu_atlisi: 20}}`.
  - **Kabul ölçütleri:** Yakalanan esir sayısı `zindan_kapasitesi`'ni aşamaz; her gece zindandaki esir başına `gunluk_erzak_bedeli` erzak düşülür.
  - **Testler:** `tests/unit/savas/esir_yakalama_test.gd` (kapasite sınırı, günlük erzak düşümü).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.esir.yakalandi`, `svs.esir.zindanda_tut` (TR ve EN).
  - **Sahip:** sondan.

- [ ] **SVS-34.b:** Fidye pazarlığı, salıverme ve kısmi divan hükmü
  - **Amaç:** Esirler için fidye isteme, salıverme veya divan hükmüne çıkarma kararlarını `ROADMAP_3` içinde (tamamını divana devretmeden, `K14`) çözmek.
  - **Kapsam:**
    1. Sınıfına göre fidye teklifi/ödemesi (kabul edilirse esir serbest kalır, köy kasasına akçe girer).
    2. Karşılıksız salıverme (`itibar +1`, husumet düşüşü) veya ağır suçluyu divan hükmüne çıkarma (`divan` adaptörü, `K14`).
  - **Bağımlılıklar:** `SVS-34.a`, `SVS-33`, `K14`.
  - **Etkilenen dosya ve klasörler:** `src/savas/esir_yoneticisi.gd` (fidye ve hüküm işlevleri). Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `esir_kurallari.json` içindeki `saliverme_itibar_deltasi`, `idam_husumet_deltasi`.
  - **Kabul ölçütleri:** Fidye kabul edilince esir listeden düşer ve köy kasasına `fidye_degerleri_sinif` kadar akçe girer; salıvermede grup itibarı artar.
  - **Testler:** `tests/unit/savas/esir_fidye_test.gd` (fidye akçesi, salıverme itibarı, divan köprüsü).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.esir.fidye_iste`, `svs.esir.saliver` (TR ve EN).
  - **Sahip:** sondan.

- [ ] **SVS-35:** Savaş sonrası tedavi ve kalıcı sakatlık iş gücü etkisi
  - **Amaç:** Savaş sonu yara/sakatlık zarı (`SVS-14`) sonuçlarını mevcut şifahane ve köylü sağlığı sistemine bağlamak.
  - **Kapsam:** Savaş sonrası HP oranından köylü sağlığına (`0–100`) aktarım, `agir_yara` için çalışma kilidi (`3` gün) ve hekimsiz gecede ölüm zarı, `kalici_sakatlik` için iş gücü düşüşü (`%50`) ve askerlikten düşme, `CAT-03` / `KRI-03` / `KRI-13` şifahane yatak ve triyaj bağlantısı dahildir.
  - **Bağımlılıklar:** `SVS-14`, `ROADMAP_1` (`CAT-03`, `KRI-03`, `KRI-13`).
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/savas_tedavi_bagi.gd`; mevcut `src/koy/hekim_ilac.gd` içine ince adaptör. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `data/savas/yara_tablosu.json` içindeki `iyilesme_gunu: 3` ve `sakatlik_isgucu_carpani: 0.5` alanları.
  - **Kabul ölçütleri:** `kalici_sakatlik` alan köylü asker aday listesine bir daha girmez; şifahane yatakları doluysa triyaj `KRI-13` kuralıyla çalışır; HP'den köylü sağlığına aktarım `0..100` aralığında kalır.
  - **Testler:** `tests/unit/savas/savas_tedavi_bagi_test.gd` (HP→sağlık aktarımı, sakatlık asker engeli, hekimsiz ağır yara).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.tedavi.agir_yara`, `svs.tedavi.kalici_sakatlik`, `svs.tedavi.iyilesti` (TR ve EN).
  - **Sahip:** sondan.

- [ ] **SVS-36:** Ölüm sonrası hane, eş, yetim, miras ve cenaze zinciri (K4)
  - **Amaç:** Savaşta ölen her köylünün/askerin köyde gerçek bir toplumsal iz bırakmasını sağlamak.
  - **Kapsam:** `KRI-05` ve `cenaze_yasi.gd` tek çağrı bağlantısı (`CAT-02` kural 5 korunur), hane reisi ölürse eş/yetim/miras ve `KAP-18` yetim/sığınmacı etkisi dahildir. **Muhafız bu zincire asla girmez (K4).**
  - **Bağımlılıklar:** `SVS-14`, `SVS-18.a`, `ROADMAP_1` (`KRI-05`, `CAT-02`), `ROADMAP_2` (`KAP-18`), `K4`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/savas_olum_bagi.gd`; mevcut `src/koy/cenaze_yasi.gd` içine ince adaptör. Korumalı çekirdeğe dokunulmaz (mevcut ölüm akışı çağrılır).
  - **Veri şeması:** veri yok.
  - **Kabul ölçütleri:** Ölen her sivil/asker için cenaze ve yas akışı tam `1` kez tetiklenir; Muhafız HP=`0` olduğunda ölüm sayısı `0` kalır; hane reisi ölünce yetim/miras bayrağı güncellenir.
  - **Testler:** `tests/unit/savas/savas_olum_bagi_test.gd` (tek çağrı cenaze tetiği, Muhafız hariç tutma, hane etkisi).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.olum.cenaze_satiri` (TR ve EN).
  - **Sahip:** sondan.

- [ ] **SVS-37:** Köye etki (moral, güvenlik, husumet, grup itibarı ve ticaret)
  - **Amaç:** Savaş sonucunun (`§5.9`) köyün makro göstergelerine ve `data/gruplar.json` itibarlarına doğrudan yansımasını sağlamak.
  - **Kapsam:** Galibiyet/mağlubiyet sonucuna göre köy morali, `savunma_guvenligi`, `husumet`, grup itibarı (`turkmen`, `rum`, `ahi`, `koylu`, `tuccar`, `asker`) ve kervan/tüccar akışı güncellemeleri dahildir.
  - **Bağımlılıklar:** `SVS-18.b`, `SVS-35`, `SVS-36`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/koy_etkisi.gd`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `data/savas/sonuc_tablosu.json` içindeki `itibar_deltalari`, `koy_moral_deltasi`, `guvenlik_deltasi` alanları.
  - **Kabul ölçütleri:** Rum milisi öldürmek `rum` itibarını düşürür; zafer sonrası köy morali ve güvenliği veri tablosu kadar artar; mağlubiyette ambar/akçe kaybı mevcut kaynak sınırları (`>= 0`) içinde düşer.
  - **Testler:** `tests/unit/savas/koy_etkisi_test.gd` (grup itibarı deltaları, kaynak alt sınırı `0`).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** metin yok (mevcut grup/kaynak anahtarları kullanılır).
  - **Sahip:** sondan.

- [ ] **SVS-38:** Kan davası ve intikam tetikleyicileri
  - **Amaç:** Çete reisi veya tekfur askeri öldürmenin ilerleyen gecelerde husumet ve intikam baskını doğurmasını sağlamak; çete anlaşması (`HAR-08`) varken çelişmemesini garanti etmek.
  - **Kapsam:** Öldürülen harami/Karaboran için çete husumet artışı, öldürülen tekfur askeri için tekfur baskısı artışı ve `HAR-08` dokunulmazlık anlaşmasının bozulma/korunma kuralı dahildir.
  - **Bağımlılıklar:** `SVS-37`, `ROADMAP_1` (`HAR-08`, `CAS-08`).
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/kan_davasi.gd`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `data/savas/sonuc_tablosu.json` içindeki `kan_davasi_husumet_carpanlari`.
  - **Kabul ölçütleri:** Çete reisi öldürülünce husumet veri tablosu kadar artar; `HAR-08` anlaşması aktifken oyuncu saldırmadıkça çete baskını tetiklenmez; oyuncu saldırırsa anlaşma bozulur.
  - **Testler:** `tests/unit/savas/kan_davasi_test.gd` (Karaboran kan davası, `HAR-08` anlaşma bozulma kuralı).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.kan_davasi.basladi` (TR ve EN).
  - **Sahip:** sondan.

- [ ] **SVS-39:** Savaş söylentisi ve dedikodu (`DIY-13`, Bölüm 37)
  - **Amaç:** Savaşın sonucunu, kahramanlıkları, sivil kayıplarını ve kaçışları mevcut söylenti/dedikodu ağına yazmak.
  - **Kapsam:** Savaş sonunda `dedikodu.olay_kaydet` çağrısı (zafer, yenilgi, sivil ölümü, Muhafız'ın düşmesi) dahildir. Eski diyalog dosyalarına dokunulmaz (`K18`).
  - **Bağımlılıklar:** `SVS-18.a`, `ROADMAP_2` (`DIY-13`, Bölüm 37).
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/savas_dedikodusu.gd`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** veri yok.
  - **Kabul ölçütleri:** Her tamamlanan savaş sonrasında en az `1` dedikodu olayı `dedikodu` sistemine yazılır; sivil öldürüldüyse ilgili kin/kınama dedikodusu seçilir.
  - **Testler:** `tests/unit/savas/savas_dedikodusu_test.gd` (zafer/yenilgi/sivil kaybı dedikodu kaydı).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.dedikodu.zafer`, `svs.dedikodu.yenilgi`, `svs.dedikodu.sivil_olumu`, `svs.dedikodu.muhafiz_dustu` (TR ve EN).
  - **Sahip:** sondan.

- [ ] **SVS-40:** Gece raporu ve hafıza defteri savaş satırları
  - **Amaç:** Savaş özetini mevcut gece raporuna ve hafıza defterine eklemek; `GRV-12` kuralına uyarak ikinci bir rapor sahnesi açmamak.
  - **Kapsam:** `GeceBilancosu` / `rapor.olaylar` ve hafıza defteri içine savaş özeti satırlarının eklenmesi dahildir.
  - **Bağımlılıklar:** `SVS-18.a`, `SVS-35`, `SVS-36`, `ROADMAP_2` (`GRV-12`).
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/savas_rapor_bagi.gd`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** veri yok.
  - **Kabul ölçütleri:** Savaş yapılan gecenin `gece_sonu()` raporunda savaş özeti satırı bulunur; ayrı bir tam ekran rapor sahnesi açılmaz.
  - **Testler:** `tests/unit/savas/savas_rapor_bagi_test.gd` (gece raporu satırı varlığı, tek sahne kuralı).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.rapor.ozet_zafer`, `svs.rapor.ozet_yenilgi` (TR ve EN).
  - **Sahip:** sondan.

---

## F. Arayüz, Erişilebilirlik ve Asset (`sondan`)

#### SVS-41 — Savaş Ekranı Kabuğu ve Izgara Vurguları (`SVS-41.a` – `SVS-41.b`)

- [ ] **SVS-41.a:** Savaş ekranı düzeni (tur şeridi, birim kartı, eylem çubuğu)
  - **Amaç:** Oyuncunun sıra tabanlı savaşı okuyup yönetebileceği ana savaş arayüzünü Bölüm 43 tema anahtarlarıyla kurmak.
  - **Kapsam:** Üstte tur sırası şeridi (`SVS-10`), altta seçili birim kartı (HP, moral basamağı, yorgunluk, kalan eylem `2/2`, ekipman ve cephane), eylem çubuğu (`hareket`, `saldır`, `nöbet tut`, `kalkan`, `bandaj`, `emir`, `çekil`) ve turu bitir düğmesi dahildir.
  - **Bağımlılıklar:** `SVS-10`, `SVS-11.a`, `ROADMAP_2` Bölüm 43 (`GRV`).
  - **Etkilenen dosya ve klasörler:** Yeni `src/arayuz/savas/savas_ekrani.gd` ve `.tscn`, `tur_seridi.gd`, `birim_karti.gd`. Korumalı çekirdeğe (`tema.gd`, `hud.gd`) dokunulmaz.
  - **Veri şeması:** veri yok.
  - **Kabul ölçütleri:** Seçili birimin HP, moral, yorgunluk ve `2/2` eylem göstergesi `SavasDurumu` ile senkronize güncellenir; tüm düğmeler Bölüm 43 tema anahtarlarını kullanır.
  - **Testler:** `tests/oto/savas_ekrani_kontrol.tscn` (headless açılış, tur şeridi ve birim kartı güncellemesi, 0 script hatası).
  - **Asset:** 2B arayüz üretimi serbesttir; tüm yeni UI ikonları `docs/EKSIK_ASSET_ENVANTERI.md` içine yazılır.
  - **Metin anahtarları:** `svs.eylem.hareket`, `svs.eylem.saldir`, `svs.eylem.kalkan`, `svs.eylem.bandaj`, `svs.eylem.emir`, `svs.eylem.cekil` (TR ve EN).
  - **Sahip:** sondan.

- [ ] **SVS-41.b:** Etkileşimli ızgara vurguları (hareket alanı, menzil, siper)
  - **Amaç:** Oyuncunun seçili birimle nereye yürüyebileceğini, hangi hücrelerin menzilde/siperde olduğunu ve yan saldırı fırsatlarını ızgara üzerinde doğrudan görmesini sağlamak.
  - **Kapsam:** `1` eylemle yürünebilir hücre vurgusu, `2` eylemle koşu sınırı vurgusu, silah menzil halkası, hücre siper ikonu (`yarim`/`tam`) ve seçili hedef hücresi çerçevesi dahildir.
  - **Bağımlılıklar:** `SVS-41.a`, `SVS-12`, `SVS-08`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/arayuz/savas/izgara_vurgusu.gd`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** veri yok.
  - **Kabul ölçütleri:** `1` eylem kaldığında `2` eylemlik koşu hücreleri kapanır; LoS dışı hedef hücresi kırmızı/engelli olarak işaretlenir.
  - **Testler:** `tests/unit/savas/izgara_vurgusu_test.gd` (kalan eyleme göre yürünebilir hücre sayısı, LoS dışı işaret).
  - **Asset:** Hücre vurgu ve siper ikonları `docs/EKSIK_ASSET_ENVANTERI.md` (2B başlığı) altına yazılır.
  - **Metin anahtarları:** `svs.ui.siper_yarim`, `svs.ui.siper_tam` (TR ve EN).
  - **Sahip:** sondan.

- [ ] **SVS-42:** Hedefleme, isabet olasılığı, görünür zar kadrajı ve erişilebilirlik
  - **Amaç:** Hedef üzerine gelince isabet olasılığını (`basari_olasiligi`) ve gerekli zar değerini göstermek, zar atışını mevcut görünür zar kadrajıyla yapmak ve tam erişilebilirlik sağlamak.
  - **Kapsam:** Hedef imleci tooltip'i (`basari_olasiligi` ve gerekli `d12` değeri), görünür zar kadrajı bağlantısı (`ZAR_BASARILI` vb.) ve **erişilebilirlik kuralları** (sonuç renkle değil sözcükle yazılır, yazı puntosu `GRV-13` altına inmez, savaş hızı `1x`/`2x` ayarı) dahildir.
  - **Bağımlılıklar:** `SVS-13`, `SVS-41.a`, `ROADMAP_2` (`ZAR-01`, `GRV-13`).
  - **Etkilenen dosya ve klasörler:** Yeni `src/arayuz/savas/hedefleme_ve_zar.gd`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** veri yok.
  - **Kabul ölçütleri:** Zar sonucu etiketinde yalnızca renk değil açık sözcük (`ZAR_BASARILI` / `ZAR_BASARISIZ` vb.) yer alır; tüm savaş etiketleri `>= GRV-13` asgari puntosundadır; isabet olasılığı `SavasZari` ile birebir aynıdır.
  - **Testler:** `tests/unit/savas/hedefleme_ve_zar_test.gd` (olasılık eşleşmesi, sözcük varlığı, punto alt sınırı).
  - **Asset:** Zar kadrajı mevcut `ZAR01` altyapısını kullanır.
  - **Metin anahtarları:** `svs.ui.isabet_yuzde`, `svs.ui.gereken_zar`, `svs.ui.savas_hizi` (TR ve EN).
  - **Sahip:** sondan.

- [ ] **SVS-58:** Savaş kamerası ve hamle geri bildirimi
  - **Amaç:** Sıra gelen birime ve kritik hamlelere yumuşak kamera odağı kurmak, hasar/ıska/durum değişikliklerini okunaklı yüzen etiketlerle göstermek.
  - **Kapsam:** Sıra başlangıcında aktif birime ve saldırıda hedefe odaklanan yumuşak kamera takibi (oyuncunun manuel kaydırmasına saygılı), yüzen hasar/ıska/durum metni (`>= GRV-13` punto) ve ayarlanabilir hafif sarsıntı dahildir.
  - **Bağımlılıklar:** `SVS-41.a`, `SVS-42`, `ROADMAP_2` (`GRV-13`).
  - **Etkilenen dosya ve klasörler:** Yeni `src/arayuz/savas/savas_kamerasi.gd`, `src/arayuz/savas/yuzen_bildirim.gd`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** veri yok.
  - **Kabul ölçütleri:** Aktif birim değişince kamera hedefi `<= 0.4` saniyede çerçeve içine alır; yüzen metinler `>= GRV-13` puntosundadır ve `2x` hızda ölçeklenir.
  - **Testler:** `tests/unit/savas/savas_kamerasi_test.gd` (odak hedefi güncellemesi, yüzen bildirim metni).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** metin yok (mevcut `svs.zar.*` ve `svs.durum.*` anahtarlarını kullanır).
  - **Sahip:** sondan.

- [ ] **SVS-43:** Savaş günlüğü
  - **Amaç:** Savaş ekranının sol altında her hamle, zar, hasar, moral ve yangın olayını kronolojik metin satırları olarak göstermek.
  - **Kapsam:** Kaydırılabilir günlük kutusu ve `SavasDurumu.gunluk` olaylarından çeviri anahtarıyla satır üretimi dahildir.
  - **Bağımlılıklar:** `SVS-07`, `SVS-41.a`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/arayuz/savas/savas_gunlugu_paneli.gd`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** veri yok.
  - **Kabul ölçütleri:** Her saldırı ve moral değişimi günlükte `1` okunaklı satır üretir; metinler `tr()` üzerinden çevrilir.
  - **Testler:** `tests/unit/savas/savas_gunlugu_test.gd` (olay→satır biçimleme ve boş/ham anahtar kalmaması).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.gunluk.saldiri`, `svs.gunluk.kacis`, `svs.gunluk.dustu` (TR ve EN).
  - **Sahip:** sondan.

- [ ] **SVS-44:** Savaş sonu özet paneli
  - **Amaç:** Savaş biter bitmez oyuncuya kayıpları, yaralıları, esirleri ve ganimet/paylaşım kararını tek özet panelinde göstermek.
  - **Kapsam:** Sonuç başlığı (`§5.9`), düşenler ve yara zarı sonuçları (`SVS-14`), esirler (`SVS-34.a`), ganimet paylaşımı (`SVS-33`) ve köye dönüş düğmesi dahildir.
  - **Bağımlılıklar:** `SVS-18.b`, `SVS-33`, `SVS-34.a`, `SVS-41.a`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/arayuz/savas/savas_ozet_paneli.gd` ve `.tscn`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** veri yok.
  - **Kabul ölçütleri:** Panel `SVS-18.b` sonucunu, ölü/yaralı sayısını ve esir sayısını doğru listeler; zaferde ganimet paylaşım seçimi yapılmadan panel kapanmaz.
  - **Testler:** `tests/unit/savas/savas_ozet_paneli_test.gd` (galibiyet/mağlubiyet özet alanları, ganimet seçim kilidi).
  - **Asset:** 2B panel düzeni Bölüm 43 temasıyla yapılır.
  - **Metin anahtarları:** `svs.ozet.baslik`, `svs.ozet.kayip_yok`, `svs.ozet.koye_don` (TR ve EN).
  - **Sahip:** sondan.

- [ ] **SVS-45:** Savaş girdileri (klavye, fare ve gamepad)
  - **Amaç:** Tüm savaş ekranının fare, klavye ve gamepad ile eksiksiz oynanabilmesini ve `ROADMAP_2` Bölüm 45 girdi standardına uymasını sağlamak.
  - **Kapsam:** Izgara imleç gezintisi, birim seçimi, eylem kısayolları (`1..7`), turu bitirme ve odak geri dönüşü (`grab_focus`) dahildir.
  - **Bağımlılıklar:** `SVS-41.a`, `ROADMAP_2` Bölüm 45.
  - **Etkilenen dosya ve klasörler:** Yeni `src/arayuz/savas/savas_girdisi.gd`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** veri yok.
  - **Kabul ölçütleri:** Yalnız klavye/gamepad eylemleriyle birim seçilir, hareket hücresine gidilir, hedefe saldırılır ve tur bitirilir; odak kaybolmaz.
  - **Testler:** `tests/oto/savas_girdisi_kontrol.gd` (odak ve eylem tetikleme doğrulaması).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.girdi.yardim` (TR ve EN).
  - **Sahip:** sondan.

- [ ] **SVS-46:** Savaş metin anahtarları TR/EN (K18)
  - **Amaç:** `ROADMAP_3` boyunca eklenen tüm `svs.*` anahtarlarının `data/metin/metinler.csv` içinde eksiksiz TR ve EN karşılıklarına sahip olmasını ve dönem terimi kuralının (`K1`, `K18`) doğrulanmasını sağlamak.
  - **Kapsam:** Tüm `svs.*` anahtarlarının `metinler.csv` satır satır eklenmesi (dosya toptan ezilmez), eski satır ve diyaloglara dokunulmaması (`K18`) ve `test_metin_dogrula.py` (`YER-02` 3 parça, `KVR-11` küçük harf noktalı) uyumluluğu dahildir.
  - **Bağımlılıklar:** `SVS-01..45`, `SVS-53..58`, `ROADMAP_2` Bölüm 46, `K1`, `K18`.
  - **Etkilenen dosya ve klasörler:** `data/metin/metinler.csv` (yalnız yeni `svs.*` satırları eklenir; eski satırlar değiştirilmez).
  - **Veri şeması:** `keys,tr,en` (en az 3 noktalı parça: `svs.<alan>.<ad>`).
  - **Kabul ölçütleri:** `test_metin_dogrula.py` `0` hata verir; yeni `svs.*` satırlarında Osmanlı terimi (`akıncı`, `tımar`, `sipahi`, `yeniçeri`, `levent ocağı`) sayısı `0`'dır; ham `svs.` anahtarı arayüzde görünmez.
  - **Testler:** `tests/tools/test_metin_dogrula.py` + `tests/unit/savas/savas_metin_test.gd` (TR/EN doluluk ve terim taraması).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** Tüm `svs.*` anahtarlarının toplu TR/EN doğrulaması.
  - **Sahip:** sondan.

- [ ] **SVS-47:** Savaş görsel ve ses yer tutucuları (K16)
  - **Amaç:** Savaş birimleri ve efektleri için oyun mekaniğini engellemeyen yer tutucular kurmak; 3B savaş animasyonları ve ses/ikon ihtiyaçlarını `docs/EKSIK_ASSET_ENVANTERI.md` altında kayıt altına almak.
  - **Kapsam:** Birimler için düz renkli `BoxMesh`/`CapsuleMesh` + kısa isim etiketi; sesler için sessiz/boş çağrı adaptörü (`ses.gd` korunur); Meshy ile üretilecek 3B savaş animasyonlarının (kılıç, mızrak, yay, düşme, kalkan) envanterdeki **3B başlığı** altına işlenmesi dahildir. Bu madde asset üretmez.
  - **Bağımlılıklar:** `SVS-41.a`, `K16`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/arayuz/savas/birim_gorunumu.gd`, `src/savas/savas_ses_adaptoru.gd`, `docs/EKSIK_ASSET_ENVANTERI.md`. Korumalı çekirdeğe (`ses.gd`, `karakter_model.gd`) dokunulmaz.
  - **Veri şeması:** veri yok.
  - **Kabul ölçütleri:** Asset yokken tüm savaş sahnesi kutu/kapsül + isim etiketiyle hatasız oynanır; ses çağrıları sessizce `0` hata döner; tüm eksik 2B/3B/ses kalemleri `docs/EKSIK_ASSET_ENVANTERI.md` dosyasında kayıtlıdır.
  - **Testler:** `tests/unit/savas/birim_gorunumu_test.gd` (etiket ve yer tutucu kurulumu, sessiz ses çağrısı).
  - **Asset:** Yer tutucu: `BoxMesh`/`CapsuleMesh` + `Label3D`/2B kutu; tüm kalemler `docs/EKSIK_ASSET_ENVANTERI.md` (3B savaş animasyonları 3B başlığında).
  - **Metin anahtarları:** metin yok.
  - **Sahip:** sondan.

---

## G. Kayıt, Denge ve Kapanış (`sondan`)

- [ ] **SVS-48:** Savaş öncesi otomatik kayıt ve kayıt göçü (K12)
  - **Amaç:** K12 kararına uygun olarak savaş ortasında kayıt almamak, her savaş başlamadan hemen önce otomatik kayıt almak ve oyun savaş ortasında kapanırsa savaş başından temiz devam edilmesini sağlamak.
  - **Kapsam:** Savaş tetiklenmeden hemen önce `GuvenliKayit` üzerinden otomatik kayıt çağrısı, savaş ekranında kaydetme düğmesinin kapalı olması ve gerekirse `SYS-14` adım göçüyle yeni savaş kalıcılık alanlarının (ör. katılım ayarı, `sur_hasar`) eklenmesi dahildir.
  - **Bağımlılıklar:** `SVS-31`, `SVS-53`, `ROADMAP_1` (`SYS-02`, `SYS-14`), `K12`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/savas_kayit_bagi.gd`; mevcut `src/sistemler/guvenli_kayit.gd` içine gerekirse yalnız `SYS-14` göç adımı eklenir (atomik yazım korunur).
  - **Veri şeması:** Kayıt sözlüğü: `{"savas_kadin_genc_katilimi": bool, "savas_oncesi_oto": bool}`.
  - **Kabul ölçütleri:** Savaş ekranındayken kayıt alma eylemi `0` kez çalışır; savaş başlamadan `1` otomatik kayıt alınır; eski `ROADMAP_2` kayıtları göçle hatasız açılır.
  - **Testler:** `tests/unit/savas/savas_kayit_bagi_test.gd` (savaş ortası kayıt engeli, savaş öncesi oto-kayıt, eski kayıt göçü).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.kayit.savas_oncesi_bildirim` (TR ve EN).
  - **Sahip:** sondan.

#### SVS-49 — Dengeleme, Karşı Güçler ve Senaryo Ölçüm Koşucusu (`SVS-49.a` – `SVS-49.b`)

- [ ] **SVS-49.a:** Dengeleme tabloları, sayısal tavanlar ve karşı güç matrisi
  - **Amaç:** Savaşın tüm sayısal tavanlarını ve taş-kağıt-makas karşı güç dengesini tek denge dosyasında kilitleyerek yenilmez birim/diziliş oluşmasını önlemek.
  - **Kapsam:** `data/savas/denge_sinirlari.json` ve `tools/savas_denge_dogrula.py`:
    1. Sayısal tavanlar: `azami_can` (`6..24`), `zirh_puani` (`0..4`), `silah_hasari` (`2..6`), `birim_tavani` (`20`, `K15`).
    2. Karşı güç matrisi doğrulaması: `topuz/arbalet` > `zirh_gomlegi`; `kalkan_duvari` > `turk_yayi`; `mizrak_karsilama` > `atli_hucumu`; `hizli_atli/yan_saldiri` > `acikta_okcu`.
  - **Bağımlılıklar:** `SVS-04.a`, `SVS-04.b`, `SVS-06.b`, `SVS-20.c`.
  - **Etkilenen dosya ve klasörler:** Yeni `tools/savas_denge_dogrula.py`, `data/savas/denge_sinirlari.json`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `denge_sinirlari.json`: `{hp_min: 6, hp_max: 24, zirh_tavan: 4, hasar_tavan: 6, birim_tavani: 20, karsi_guc_matrisi}`.
  - **Kabul ölçütleri:** `tools/savas_denge_dogrula.py` `0` hata verir; tavanı aşan veya karşı gücü olmayan herhangi bir veri satırı `1` doğrulama hatası üretir.
  - **Testler:** `tests/tools/test_savas_denge.py` (tavan ve karşı güç matrisi denetimi).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** metin yok.
  - **Sahip:** sondan.

- [ ] **SVS-49.b:** Sabit tohumlu `senaryo_kosucusu` ölçüm koşusu
  - **Amaç:** Gerçek savaş motorunu 5 temel denge senaryosunda sabit tohumlarla 100'er kez koşturup kazanma oranlarını ve ortalama tur süresini ölçmek.
  - **Kapsam:** `senaryo_kosucusu.gd` üzerinde 5 ölçüm senaryosu (`3 harami / 2 muhafız`, `kapı düellosu`, `tekfur kuşatması`, `Moğol öncü 4v4`, `hep yay vs kalkan duvarı`).
  - **Bağımlılıklar:** `SVS-49.a`, `SVS-19`, `SVS-23.b`, `SVS-25.b`, `SVS-27`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/senaryo_kosucusu.gd`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** veri yok.
  - **Kabul ölçütleri:** Sabit tohumlu `100` ölçüm koşusunda `3 harami / 2 muhafız` senaryosu `%35–%75` kazanma bandında sonuçlanır; `"hep yay"` takımı `kalkan_duvari` karşısında `%50`'nin altında kalır; Muhafız HP=`0` olduğunda `0` kez galibiyet yazılır.
  - **Testler:** `tests/unit/savas/senaryo_kosucusu_test.gd` (5 senaryo istatistik bandı doğrulaması).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** metin yok.
  - **Sahip:** sondan.

- [ ] **SVS-50:** `otomatik_oyuncu` 20 gece savaşlı duman testi (K10)
  - **Amaç:** Oyunun 20 gecelik tam döngüsünün, savaşlar sırasında kilitlenmeden ve oyuncuya açık otomatik çözüm eklenmeden (`K10`) çalıştığını doğrulamak.
  - **Kapsam:** `otomatik_oyuncu.gd` içinde yalnızca test koşusu sırasında `SVS-19` (`yz_test_kosucusu.gd`) çağrısını kullanan ince test kancası dahildir. Oyuncu arayüzüne atlama seçeneği eklenmez.
  - **Bağımlılıklar:** `SVS-19`, `SVS-48`, `SVS-49.b`, `K10`.
  - **Etkilenen dosya ve klasörler:** `tests/oto/otomatik_oyuncu.gd` (yalnız `SVS-19` test kancası eklenir; mevcut akış bozulmaz).
  - **Veri şeması:** veri yok.
  - **Kabul ölçütleri:** `otomatik_oyuncu` `20` geceyi `0` kilitlenme, `0` script hatası ve `0` yetim node ile tamamlar; UI'da otomatik çözüm düğmesi yoktur.
  - **Testler:** `tests/oto/otomatik_oyuncu_savas_kontrol.tscn` (headless 20 gece koşusu).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** metin yok.
  - **Sahip:** sondan.

- [ ] **SVS-51:** Perde ve son bağlantıları + `ROADMAP_2` sınır koruması
  - **Amaç:** 2. perde savunma savaşını, Tekfur ve haraç sonlarını (`SYS-19`, `SYS-20`) sıra tabanlı savaş sonuçlarına bağlamak; `BUG-18`/`OMR-42` nüfus eşiğini ve `MCL-09` meclis yasağını korumak.
  - **Kapsam:** `SON_TEKFUR` ve 2. perde savunma tetiklerinin `SVS-25.b` kuşatma sonucuna bağlanması, `BUG-18` (`nufus < 14` iken kurt dışı baskın yok) ve `MCL-09` (meclis savaş açamaz) sınır kontrollerinin korunması dahildir.
  - **Bağımlılıklar:** `SVS-25.b`, `SVS-37`, `ROADMAP_1` (`SYS-19`, `SYS-20`), `ROADMAP_2` (`BUG-18`, `OMR-42`, `MCL-09`).
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/perde_son_bagi.gd`; mevcut `src/sistemler/perde_yoneticisi.gd` içine tek satırlık adaptör. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** veri yok.
  - **Kabul ölçütleri:** Kuşatma mağlubiyeti `SON_TEKFUR` sonunu tetikler; nüfus eşiği altındayken kurt dışı savaş `0` kez açılır; meclis kararlarından savaş tetiklenmez.
  - **Testler:** `tests/unit/savas/perde_son_bagi_test.gd` (Tekfur sonu, `BUG-18` ve `MCL-09` sınır doğrulaması).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** metin yok (mevcut son metinleri korunur).
  - **Sahip:** sondan.

- [ ] **SVS-52:** `ROADMAP_3` kapanış testi
  - **Amaç:** Tüm `SVS-01..58` katmanlarının uçtan uca bir arada hatasız çalıştığını tek kapanış kapısında doğrulamak.
  - **Kapsam:** Godot headless import + parse kontrolü, tüm `tests/unit/savas/*.gd`, `tests/oto/savas_*.tscn`, `tools/savas_denge_dogrula.py`, `tools/metin_dogrula.py`, `ROADMAP_2` sınır testlerinin (`MCL-09`, `BUG-18`, `YAP-56`, `HAR-02`) bozulmadığının doğrulanması ve `docs/OYUN_RAPORU.md` kapanış notu dahildir.
  - **Bağımlılıklar:** `SVS-01..51`, `SVS-53..58`.
  - **Etkilenen dosya ve klasörler:** Yeni `tests/oto/savas_kapanis_kontrol.gd` ve `.tscn`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** veri yok.
  - **Kabul ölçütleri:** Tam savaş test paketi ve `tools/sanity_check.py` `0` script hatası, `0` failed assertion ve `0` sızan yetim kaynakla geçer.
  - **Testler:** `tests/oto/savas_kapanis_kontrol.tscn` + `tools/sanity_check.py`.
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** metin yok.
  - **Sahip:** sondan.

---

**Toplam:** **70 iş birimi** (`47` tekil ana madde + `11` bölünmüş ana başlıktan `23` alt madde [`SVS-04.a/b`, `SVS-06.a/b`, `SVS-11.a/b`, `SVS-15.a/b`, `SVS-18.a/b`, `SVS-20.a/b/c`, `SVS-23.a/b`, `SVS-25.a/b`, `SVS-34.a/b`, `SVS-41.a/b`, `SVS-49.a/b`]; `baştan`: `44` iş birimi [`A–D`], `sondan`: `26` iş birimi [`E–G`]).

**Kapsam dışı (K7, gelecek notu):** Kıtlık / açlık isyanı ve ambar yağması (`KRI-06`, `KRI-14`) `ROADMAP_3` kapsamı dışındadır; mevcut akış olduğu gibi kalır, ayrı `SVS-*` maddesi açılmaz.
