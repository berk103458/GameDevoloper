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

## Oyun Sistemleri Analizi (Savaş Tasarım Referansları)

| Referans Oyun | Alınan Mekanik Karar | Alınmayanlar |
|---|---|---|
| **XCOM 2** | Tur başına **2 eylemli** basit aksiyon modeli, siper/görüş hattı ve isabet olasılığının hamle öncesi şeffaf gösterilmesi. | Aksiyon puanı (AP) ve bilimkurgu ekipman ağacı alınmaz. |
| **Battle Brothers** | **Yorgunluk** birikimi, **moral basamakları** (kararlı → bozgun), kalıcı yara/sakatlık ve silah türüne göre farklı vuruş/delme özellikleri. | Paralı asker şirketi ekonomisi ve sınırsız asker alımı alınmaz. |
| **Into the Breach** | Küçük, okunaklı harita üzerinde her hamlenin ağır sonuç doğurması ve düşmanın bir sonraki **niyetinin önceden görünmesi**. | Bulmaca benzeri deterministik hasar (zar yerine sabit itme) alınmaz. |
| **Darkest Dungeon** | Moral/stresin ayrı bir çubuk olarak savaşı kırması ve **savaş sonrası iyileşme/travma ekonomisinin** köye taşması. | Sabit 4'lü sıra düzeni ve fantastik düşmanlar alınmaz. |
| **Mount & Blade** | **Savaş öncesi karar** (savaş, pazarlık, rüşvet, kaç), **esir/fidye** ve komutanın birlik moraline doğrudan etkisi. | Gerçek zamanlı savaş ve oyuncuya açık otomatik çözüm (K10) alınmaz. |
| **The Banner Saga** | Kayıp ve kıtlık baskısının doğrudan **yolculuk/köy hayatta kalma döngüsüne** bağlanması. | Ayrı zırh-kırma/can iki çubuklu hasar matematiği alınmaz (tek HP + zırh düşümü K3). |

### Analizden Doğan Tekil Sistem Kuralları (Yol Haritası Eşlemesi)
- **Dengeleme** → `SVS-49` (sayısal tablolar, tavanlar, karşı güç doğrulaması).
- **Güçlendirme ve zayıflatma (buff/debuff)** → `SVS-11` (durum etkileri, süreler ve yığılma yasağı).
- **Sınıf ve birim yetenekleri** → `SVS-06` (bekleme süresi, eylem/yorgunluk maliyeti, karşı oynanış tek tabloda).
- **Teçhizat farkları** → `SVS-04` (13. yy silah ve zırhlarının menzil, hasar, zırh delme, ağırlık ve 2 eylemli atış farkları tek tabloda).
- **Moral ve yorgunluk etkileşimi** → `SVS-15` (yorgun birimin moralinin daha kolay kırılması; iki ayrı çubuk, tek etkileşim kuralı).
- **Baskın strateji yasağı** → `SVS-20` ("hep yay", "hep kapıda bekle" gibi tek doğru yolların karşı hamle ve saha cezalarıyla kırılması).
- **Zorluk eğrisi** → `SVS-20` (ilk savaş küçük/okunaklı; zorluk YZ hilesiyle değil birim sayısı ve bileşimiyle 20 tavana kadar artar).

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
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/katilim_ayari.gd`; mevcut `src/arayuz/ayarlar_paneli.gd` ve `src/arayuz/yeni_oyun_ekrani.gd` içine ince adaptör. Korumalı çekirdeğe dokunulmaz (`Oturum` veya ayarlar kaynağı üzerinden okunur).
  - **Veri şeması:** `ayarlar`: `{"savas_kadin_genc_katilimi": bool}` (varsayılan `true`).
  - **Kabul ölçütleri:** Varsayılan değer `true`'dur; ayar oyun ortasında `false` yapılınca sonraki savaş aday listesinde kadın/genç sayısı `0` olur; çocuk sayısı her iki durumda `0` kalır.
  - **Testler:** `tests/unit/savas/katilim_ayari_test.gd` (varsayılan açık, oyun ortası değişim, çocuk hariç tutma).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.ayar.kadin_genc_katilim` (TR: `Kadın ve gençler savaşa katılsın` / EN: `Allow women and youths in combat`), `svs.ayar.kadin_genc_aciklama` (TR: `Çocuklar her durumda savaş dışıdır.` / EN: `Children never enter combat.`).
  - **Sahip:** baştan.

- [ ] **SVS-02:** Birim istatistik şablonu
  - **Amaç:** Hem dost hem düşman bütün savaşçıların ortak bir sayısal veri yapısıyla temsil edilmesini sağlamak.
  - **Kapsam:** `SavasBirimi` veri/kaynak sınıfı (`can`, `azami_can`, `saldiri`, `savunma`, `menzil_becerisi`, `inisiyatif`, `moral`, `moral_tabani`, `yorgunluk`, `yorgunluk_tavani`, `ekipman`, `rol_etiketleri`, `durumlar`) dahildir. Sınıf/düşman sayıları `SVS-05` ve `SVS-06`'dadır.
  - **Bağımlılıklar:** `SVS-01`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/savas_birimi.gd`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `data/savas/birim_semasi.json`: zorunlu alanlar `id`, `taraf` (`dost`|`dusman`|`tarafsiz`), `azami_can` (int >= 1), `saldiri` (int), `savunma` (int), `menzil_becerisi` (int), `inisiyatif` (int), `moral_tabani` (int), `yorgunluk_tavani` (int), `ekipman` (`{silah, kalkan, zirh}`), `rol_etiketleri` (`Array[String]`).
  - **Kabul ölçütleri:** Şemadaki herhangi bir zorunlu alan eksikse doğrulayıcı `1` hata döner; negatif `azami_can` reddedilir; tüm savaş birimleri aynı `SavasBirimi` sınıfını kullanır.
  - **Testler:** `tests/unit/savas/savas_birimi_test.gd` (şema doğrulama, sınır değerleri).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** metin yok.
  - **Sahip:** baştan.

- [ ] **SVS-03:** Köylü, asker ve adlı karakterden savaş birimine dönüştürücü
  - **Amaç:** Köydeki gerçek bireylerin (sağlık, beceri, nöbet yorgunluğu, rol, ekipman) savaşa birebir taşınmasını ve savaş sonrası aynı kişiye geri yazılmasını sağlamak.
  - **Kapsam:** Mevcut `koy_nufusu`, `karakterler/CHR_*.tres`, `aydogdu/nogay/miraen`, `CHR_021..024` (eski asker/kaçak) ve Muhafız'ın `SavasBirimi`'ne dönüştürülmesi; `SVS-53` katılım ayarına göre aday süzme; köylü sağlığından (`0–100`) başlangıç HP oranlaması dahildir.
  - **Bağımlılıklar:** `SVS-02`, `SVS-53`, `ROADMAP_2` (`HAR-10`, `UZM-14`).
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/birim_donusturucu.gd`. Korumalı çekirdek `koy_nufusu.gd`'ye dokunulmaz; yalnızca okuma/yazma adaptörü üzerinden çalışır.
  - **Veri şeması:** `data/savas/donusum_kurallari.json`: `saglik_hp_orani`, `sinif_baz_degerleri`, `eski_asker_bonuslari` (`CHR_021..024`).
  - **Kabul ölçütleri:** Sağlığı `%50` olan köylü başlangıç HP'sinin yarısıyla (en az `1`) başlar; `SVS-53` kapalıyken kadın/genç aday listesine girmez; çocuk (`yas_grubu == "cocuk"`) hiçbir durumda girmez; karantinadaki/uyuyan asker süzülür.
  - **Testler:** `tests/unit/savas/birim_donusturucu_test.gd` (sabit tohumlu nüfus dönüşümü, katılım filtresi, sağlık→HP oranı).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** metin yok.
  - **Sahip:** baştan.

- [ ] **SVS-04:** 13. yüzyıl dönem teçhizatı tablosu ve köy silah stoğu
  - **Amaç:** Silah ve zırhların birbirinden anlamlı taktik farklar (menzil, hasar, zırh delme, ağırlık, iki eylem harcayan ağır atış) üretmesini ve köyün gerçek silah stoğuna bağlanmasını sağlamak.
  - **Kapsam:** Tek veri tablosunda tüm 13. yy Selçuklu ucu ve tekfur/Moğol silah ve zırhları (`kılıç`, `mızrak` [2 hücre + karşılama], `topuz/gürz` [zırh delme], `balta` [kapı hasarı], `Türk yayı`, `arbalet/tzangra` [zırh delme + 2 eylemli doldurma/atış], `sapan/taş`, `orak/sopa`, `kalkan`, `keçe/pamuk kaftan`, `deri/pullu zırh`, `zırh gömleği`, `tolga`); köy silah stoğu dağıtımı (silahsız köylüye alet) dahildir. Her silah için ayrı madde açılmaz.
  - **Bağımlılıklar:** `SVS-02`, `K1`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/techizat_tablosu.gd`, `data/savas/silahlar.json`, `data/savas/zirhlar.json`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `silahlar.json`: `{id, tur, menzil_min, menzil_max, hasar, zirh_delme, agirlik, yorgunluk_eki, agir_eylem_mi, kapi_carpani}`. `zirhlar.json`: `{id, zirh_puani, savunma_eki, agirlik, yorgunluk_eki}`.
  - **Kabul ölçütleri:** Her silahın benzersiz rolü veri doğrulayıcısından geçer (ör. `arbalet.agir_eylem_mi == true`, `topuz.zirh_delme > kilic.zirh_delme`, `mizrak.menzil_max == 2`); stokta silah yoksa köylü otomatik alet (`orak`/`sopa`/`sapan`) alır.
  - **Testler:** `tests/unit/savas/techizat_tablosu_test.gd` (şema, zırh delme, ağır eylem bayrağı, stok dağıtımı).
  - **Asset:** Yer tutucu: el eşyası kutuları (`el_esyasi.gd`). Yeni 3B/2B silah ikonları `docs/EKSIK_ASSET_ENVANTERI.md` içine eklenir.
  - **Metin anahtarları:** `svs.silah.<id>`, `svs.zirh.<id>` (TR ve EN dönem adları).
  - **Sahip:** baştan.

- [ ] **SVS-05:** Düşman şablonları tek tablosu
  - **Amaç:** Döneme uygun tüm düşman tiplerini tek veri tablosunda tanımlamak ve tekrar eden düşman maddelerini önlemek.
  - **Kapsam:** Tek tabloda şu satırlar yer alır: `harami` (Kızıl Karga), `cete_reisi` (Karaboran), `eskiya_okcusu`, `tekfur_yayasi`, `tekfur_arbaletcisi`, `tekfur_mizrakli_atlisi`, `rum_milisi`, `mogol_oncu_atlisi` (yalnız 3–8 kişilik küçük grup, K5), `asi_turkmen_atlisi` (`turkmen_kin`), `asker_kacagi`, `caresiz_sivil` (aç aile reisi/genç erkek — öldürmede ağır sosyal ceza), `kurt_surusu`. Kopya madde açılmaz.
  - **Bağımlılıklar:** `SVS-02`, `SVS-04`, `K1`, `K5`.
  - **Etkilenen dosya ve klasörler:** Yeni `data/savas/dusman_sablonlari.json`, `src/savas/sablon_yukleyici.gd`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `dusman_sablonlari.json`: `{id, grup_etiketi, savas_puani, azami_can, saldiri, savunma, menzil_becerisi, inisiyatif, moral_tabani, yorgunluk_tavani, varsayilan_ekipman, yz_profili, kucuk_grup_tavan}`.
  - **Kabul ölçütleri:** Listelenen 12 düşman tipi şemadan hatasız yüklenir; Osmanlı terimi geçmez; `mogol_oncu_atlisi` için `kucuk_grup_tavan <= 8` doğrulanır; `caresiz_sivil` öldürme ceza bayrağı taşır.
  - **Testler:** `tests/unit/savas/sablon_yukleyici_test.gd` (12 düşman şablonu şema ve terim denetimi).
  - **Asset:** Kutu/kapsül yer tutucu + isim etiketi. 3B modeller ve animasyonlar `docs/EKSIK_ASSET_ENVANTERI.md` (3B başlığı) altına yazılır.
  - **Metin anahtarları:** `svs.dusman.<id>` (TR ve EN).
  - **Sahip:** baştan.

- [ ] **SVS-06:** Dost şablonları ve birim yetenekleri tek tablosu
  - **Amaç:** Dost tarafın tüm rollerini ve hem dost hem düşman birimlerin aktif/pasif yeteneklerini (bekleme süresi, maliyet, karşı oynanış) tek tabloda tanımlamak.
  - **Kapsam:** Dost rolleri (`muhafiz`, `cavus`, `kapi_mizraklisi`, `sur_okcusu`, `devriye`, `adli_asker`, `eski_asker`, `erkek_milis`, `kadin_genc_milis`, `hekim`, `turkmen_alp`, `uc_beyi_askeri`, `gazi_gonullu`) ve tüm birim yetenekleri (`emir`, `kalkan_duvari`, `karsilama_mizragi`, `bandaj_kaldir`, `nisanli_atis`, `sahte_ricat`, `kapi_balta`, `davul_morali`) dahildir. Her yetenek veya rol için ayrı madde açılmaz.
  - **Bağımlılıklar:** `SVS-02`, `SVS-04`, `SVS-05`, `K1`, `K6`.
  - **Etkilenen dosya ve klasörler:** Yeni `data/savas/dost_sablonlari.json`, `data/savas/yetenekler.json`, `src/savas/yetenek_sistemi.gd`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `yetenekler.json`: `{id, eylem_bedeli (1|2), yorgunluk_bedeli, bekleme_turu, menzil, hedef_turu, karsi_oynanis_etiketi, etki}`.
  - **Kabul ölçütleri:** Her yetenek bekleme süresi ve yorgunluk/eylem maliyetine sahiptir; `bekleme_turu > 0` iken yetenek ikinci kez kullanılamaz; her yetenek bir karşı oynanış etiketi taşır (ör. `kalkan_duvari` ↔ `topuz`/`kusatma_baltasi`).
  - **Testler:** `tests/unit/savas/yetenek_sistemi_test.gd` (bekleme süresi, eylem/yorgunluk düşümü, karşı oynanış etiketi doğrulaması).
  - **Asset:** Eylem çubuğu ikonları 2B envantere yazılır; 3B karakter/animasyon yer tutucusu `docs/EKSIK_ASSET_ENVANTERI.md` içindedir.
  - **Metin anahtarları:** `svs.dost.<id>`, `svs.yetenek.<id>`, `svs.yetenek.<id>_aciklama` (TR ve EN).
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
  - **Kapsam:** Kare ızgara + 8 yön komşuluk, hücre nitelikleri (`gecilebilir`, `siper`: `yok`/`yarim`/`tam`, `yukseklik`: `zemin`/`sur`, `yanicilik`, `kapi_saglamligi`), `HAR-10` konuşlanma hücrelerinin okunması ve **bir savaşta en fazla 20 birim (K15)** sınırı (21. birim sahneye girmez, yedek/gelmedi olarak veride kalır) dahildir.
  - **Bağımlılıklar:** `SVS-07`, `ROADMAP_2` (`HAR-10`, `K15`).
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/savas_izgarasi.gd`, `data/savas/arazi_kurallari.json`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `arazi_kurallari.json`: `{azami_birim: 20, siper_ekleri: {yok: 0, yarim: 1, tam: 2}, sur_yukseklik_menzil_bonusu, sur_savunma_bonusu}`.
  - **Kabul ölçütleri:** `25` aday birim verildiğinde sahneye tam `20` birim girer, `5` birim yedek/gelmedi listesinde kalır; siper ve sur bonusları `arazi_kurallari.json`'dan okunur.
  - **Testler:** `tests/unit/savas/savas_izgarasi_test.gd` (sabit tohumla 20 birim tavanı, 8 yön komşuluk, siper/yükseklik okuması).
  - **Asset:** asset gerekmedi (mevcut köy ızgarası kullanılır).
  - **Metin anahtarları:** metin yok.
  - **Sahip:** baştan.

- [ ] **SVS-09:** Kapı arenası haritası
  - **Amaç:** Kapı arbedesi ve kapı düellosu (`SVS-23`) için küçük, sabit ve okunaklı bir kare ızgara tanımlamak.
  - **Kapsam:** Kapı önü için sabit boyutlu arena verisi (giriş hücreleri, kapı duvarı siperi, kaçış kenarı) ve `SavasIzgarasi` yükleyicisi dahildir.
  - **Bağımlılıklar:** `SVS-08`.
  - **Etkilenen dosya ve klasörler:** Yeni `data/savas/haritalar/kapi_arenasi.json`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `kapi_arenasi.json`: `{id: "kapi_arenasi", genislik, yukseklik, dost_dogus: [[x,y]], dusman_dogus: [[x,y]], kapi_hucreleri, kacis_kenari}`.
  - **Kabul ölçütleri:** Arena `1v1` düello ve `1–3`'e `1–3` arbede için yeterli geçilebilir hücre ve kaçış kenarı içerir; sıfır hata ile `SavasIzgarasi`'na yüklenir.
  - **Testler:** `tests/unit/savas/kapi_arenasi_test.gd` (doğuş hücrelerinin geçilebilirliği, kaçış kenarı).
  - **Asset:** asset gerekmedi (mevcut kapı önü sahnesi/ızgarası).
  - **Metin anahtarları:** metin yok.
  - **Sahip:** baştan.

- [ ] **SVS-10:** İnisiyatif ve tur sırası
  - **Amaç:** Raunt başında deterministik tur sırası kurmak ve sıra şeridinin okuyacağı sırayı üretmek.
  - **Kapsam:** Raunt başında her canlı/düşmemiş birim için `inisiyatif + d6` atışı, eşitlikte dost tarafın önce gelmesi ve raunt sonu fazı (kanama, yangın, moral/takviye tetiği) dahildir.
  - **Bağımlılıklar:** `SVS-07`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/tur_yoneticisi.gd`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** veri yok.
  - **Kabul ölçütleri:** Sabit tohumda iki koşu birebir aynı sıra listesi üretir; eşit inisiyatif+d6 durumunda dost birim her zaman öne geçer; düşmüş (`can <= 0`) birim tur sırasına alınmaz.
  - **Testler:** `tests/unit/savas/tur_yoneticisi_test.gd` (sabit tohum sırası, eşitlik kuralı, düşmüş birim dışlama).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** metin yok.
  - **Sahip:** baştan.

- [ ] **SVS-11:** İki eylemli aksiyon modeli (K2) ve durum etkileri (buff/debuff) tablosu
  - **Amaç:** XCOM tarzı turda 2 eylem kuralını uygulamak ve tüm güçlendirme/zayıflatma (buff/debuff) etkilerinin süre ve yığılma kurallarını tek yerde yönetmek.
  - **Kapsam:** Birim başına `2` eylem (`hareket+eylem`, `eylem+hareket`, `iki hareket`, iki eylem harcayan ağır eylemler); durum etkileri tablosu (`kalkan_duvari`, `sersemledi`, `kanama`, `ilham`, `zehir_is`, `yara_sarsintisi`), süre sayacı ve **yığılma yasağı** (aynı etki üst üste katlanmaz, tablo kuralına göre süresi yenilenir/uzar) dahildir.
  - **Bağımlılıklar:** `SVS-04`, `SVS-06`, `SVS-10`, `K2`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/eylem_ve_durum.gd`, `data/savas/durum_etkileri.json`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `durum_etkileri.json`: `{id, tur (buff|debuff), sure_turu, yigilma_kurali (yenile|uzat|yoksay), savunma_eki, saldiri_eki, eylem_kisiti, tur_sonu_hp_delta}`.
  - **Kabul ölçütleri:** Ağır eylem kullanılınca kalan eylem `0` olur ve tur biter; aynı durum etkisi iki kez uygulanınca sayısal bonus katlanmaz, yalnız `yigilma_kurali` işler; düştü (`can == 0`) durumundaki birimin kalan eylemi `0` sayılır.
  - **Testler:** `tests/unit/savas/eylem_ve_durum_test.gd` (2 eylem kombinasyonları, ağır eylem, buff/debuff yığılmama ve süre dolumu).
  - **Asset:** Durum ikonu yer tutucuları 2B envantere yazılır.
  - **Metin anahtarları:** `svs.durum.<id>` (TR ve EN).
  - **Sahip:** baştan.

- [ ] **SVS-12:** Hareket, menzil, 8 yön ve görüş hesabı
  - **Amaç:** Birimlerin ızgara üzerinde A* yol bulma ile yürümesini, silah menzili ve görüş hattı (LoS) ile hedef alabilmesini, gece savaşında ışık kaynağına göre görüş kısıtının işlemesini sağlamak.
  - **Kapsam:** 8 yönlü yol bulma, düşman kontrol bölgesi/çarpışma engeli, menzil (`min..max`) ve engel/duvar görüş hattı, gece görüş menzili ile meşale/muhafız ışığı (`muhafiz_donanimi.json`) bağlantısı dahildir.
  - **Bağımlılıklar:** `SVS-08`, `SVS-04`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/hareket_ve_gorus.gd`, `data/savas/gorus_kurallari.json`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `gorus_kurallari.json`: `{gunduz_gorus_hucre, gece_taban_gorus, mesale_ek_gorus, sur_gorus_bonusu}`.
  - **Kabul ölçütleri:** Duvar/tam engel arkasındaki hedefe menzilli saldırı görüş dışı kalır; gece görüşü gündüzden kısadır ve meşale taşıyan birimin çevresinde `mesale_ek_gorus` kadar açılır; sur yüksekliği okçu menziline veri kadar ekler.
  - **Testler:** `tests/unit/savas/hareket_ve_gorus_test.gd` (LoS engel testi, gece/meşale görüşü, 8 yön yol maliyeti).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** metin yok.
  - **Sahip:** baştan.

- [ ] **SVS-13:** Savaş zarı adaptörü (`SavasZari`), isabet ve HP hasarı (K3)
  - **Amaç:** Savaş zarını mevcut `SorguZari` kurallarıyla (`d6`/`d12`, `zar >= gerekli`, tavan daima başarı, `1` daima başarısız, tek `basari_olasiligi` yolu) kurmak ve isabet eden saldırıda sayısal HP hasarını düşmek.
  - **Kapsam:** `SavasZari` adaptörü (`SorguZari.olasilik` ve `SorguZari.basarili` üzerinden, ikinci hesap yolu açmadan), isabet formülü (`d12 >= hedef_savunma + mesafe_eki + siper_eki + moral_eki + yorgunluk_eki - saldiri`) ve HP hasarı (`silah_hasari + d6 - max(0, zirh - zirh_delme)`, en az `1`) dahildir.
  - **Bağımlılıklar:** `SVS-11`, `SVS-12`, `ROADMAP_2` (`ZAR-01..06`), `K3`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/savas_zari.gd`, `data/savas/isabet_kurallari.json`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `isabet_kurallari.json`: `{mesafe_basina_ek, siper_ekleri, moral_ekleri, yorgunluk_eki, asgari_hasar: 1}`.
  - **Kabul ölçütleri:** `1` atan saldırı her zaman ıskalar, `12` atan her zaman isabet eder; isabet olasılığı doğrudan `SorguZari.olasilik` çıktısıdır; isabet eden saldırıda hedef HP'si en az `1` düşer.
  - **Testler:** `tests/unit/savas/savas_zari_test.gd` (tavan/1 kuralı, `basari_olasiligi` tutarlılığı, zırh delme ve asgari `1` hasar).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.zar.isabet`, `svs.zar.iska`, `svs.zar.hasar` (TR ve EN; mevcut `ZAR_BASARILI` vb. kullanılır).
  - **Sahip:** baştan.

- [ ] **SVS-14:** HP sıfırda "düştü" durumu ve savaş sonu yara/sakatlık zarı (K3, K4)
  - **Amaç:** Savaş içinde HP `0`'a inen karakterin eylemsiz `"düştü"` durumuna geçmesini ve savaş sonunda düşenler için ağır sonuçlu ama okunaklı yara/sakatlık zarı atılmasını sağlamak.
  - **Kapsam:** HP `0` anında `"düştü"` bayrağı; savaş sonunda her düşen için `d12` yara/sakatlık zarı (`olum`, `agir_yara`, `kalici_sakatlik`, `hafif_yara`) ve değiştiriciler (hekim, şifahane, düşüren silah, alanda kalma); **Muhafızın (K4) ölüm satırına asla girmemesi** (en kötü `agir_yara`) dahildir.
  - **Bağımlılıklar:** `SVS-13`, `K3`, `K4`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/yara_zari.gd`, `data/savas/yara_tablosu.json`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `yara_tablosu.json`: `{d12_araliklari: {olum, agir_yara, kalici_sakatlik, hafif_yara}, degistiriciler: {hekim, sifahane, agir_silah, alanda_kaldi}, muhafiz_en_kotu: "agir_yara"}`.
  - **Kabul ölçütleri:** HP `0` olan birim turda eylem alamaz; `1000` sabit tohumlu testte Muhafız için `olum` sonucu `0` kez döner; hekim ve şifahane varlığı `olum` aralığını veri tablosu kadar daraltır.
  - **Testler:** `tests/unit/savas/yara_zari_test.gd` (düşen birim kilidi, 4 sonuç dağılımı, Muhafız ölümsüzlük doğrulaması).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.yara.dustu`, `svs.yara.olum`, `svs.yara.agir`, `svs.yara.sakatlik`, `svs.yara.hafif` (TR ve EN).
  - **Sahip:** baştan.

- [ ] **SVS-15:** Moral basamakları, bozgun ve moral–yorgunluk etkileşimi
  - **Amaç:** Birimlerin savaş içinde moral kaybetmesini, bozguna uğrayınca kaçmasını ve yorgunluğun moral kırılmasını hızlandırmasını tek bir etkileşim kuralıyla bağlamak.
  - **Kapsam:** 4 moral basamağı (`kararli`, `tedirgin`, `sarsilmis`, `bozgun`), moral tetikleyicileri (dost ölümü, komutan yakınlığı, sayısal üstünlük, evini savunma, harami erken kırılma), `d6` moral kontrolü ve **moral–yorgunluk tek etkileşim kuralı** (yüksek yorgunluk kademesi moral zarına doğrudan eksi değiştirici yazar) dahildir.
  - **Bağımlılıklar:** `SVS-13`, `SVS-16`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/moral_sistemi.gd`, `data/savas/moral_kurallari.json`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `moral_kurallari.json`: `{basamaklar, isabet_ekleri, tetik_deltalari, komutan_aura_menzili, yorgunluk_moral_cezasi}`.
  - **Kabul ölçütleri:** Yorgun birim (`yorgunluk >= esik`) aynı moral darbesinde dinç birimden veri kadar daha yüksek bozgun olasılığına sahiptir; `bozgun` basamağındaki birim kaçış kenarına yönelir.
  - **Testler:** `tests/unit/savas/moral_sistemi_test.gd` (4 basamak geçişi, komutan aurası, yorgunluk–moral cezası).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.moral.kararli`, `svs.moral.tedirgin`, `svs.moral.sarsilmis`, `svs.moral.bozgun` (TR ve EN).
  - **Sahip:** baştan.

- [ ] **SVS-16:** Yorgunluk çubuğu ve nöbet yorgunluğundan devralma
  - **Amaç:** Her savaş eyleminin ve zırh/silah ağırlığının yorgunluk üretmesini, nöbetten yorgun çıkan muhafız/askerin savaşa yorgun başlamasını sağlamak.
  - **Kapsam:** Eylem başına yorgunluk birikimi, dinlenme/pas geçme ile düşüş, tavan aşımında birimin turda yalnız `1` eylem yapabilmesi ve mevcut nöbet yorgunluğundan (`UZM-14`, `YSM-03`) başlangıç yorgunluğu aktarımı dahildir.
  - **Bağımlılıklar:** `SVS-04`, `SVS-11`, `ROADMAP_2` (`UZM-14`, `YSM-03`).
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/yorgunluk_sistemi.gd`, `data/savas/yorgunluk_kurallari.json`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `yorgunluk_kurallari.json`: `{nobet_aktarim_orani, dinlenme_azaltimi, agirlik_carpani, kisit_esigi_yuzde}`.
  - **Kabul ölçütleri:** Yorgunluk `yorgunluk_tavani`na ulaşan birim sonraki turda `1` eylemle başlar; nöbet yorgunluğu taşıyan karakter savaşın 1. turuna `yorgunluk > 0` ile girer.
  - **Testler:** `tests/unit/savas/yorgunluk_sistemi_test.gd` (tavan kısıtı, dinlenme, nöbet devralımı).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.yorgunluk.kisit` (TR ve EN).
  - **Sahip:** baştan.

- [ ] **SVS-17:** Nöbet tutma (overwatch) ve karşılama saldırısı
  - **Amaç:** Birimin kalan eylemini menzile giren ilk düşmana tepki atışı veya mızrak karşılaması olarak saklayabilmesini sağlamak.
  - **Kapsam:** `nobet_tut` eylemi (kalan eylemi harcar, yön/menzil alanı kurar), düşman hareketiyle tetiklenen tepki saldırısı ve `mizrak` silahının yaklaşan düşmana öncelikli karşılama saldırısı dahildir.
  - **Bağımlılıklar:** `SVS-11`, `SVS-12`, `SVS-13`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/nobet_tepkisi.gd`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** veri yok (`silahlar.json` menzil ve `yetenekler.json` tetik alanını okur).
  - **Kabul ölçütleri:** `nobet_tut` aktifken menzile giren ilk düşmana otomatik `1` tepki saldırısı yapılır ve nöbet durumu sıfırlanır; kendi turu başında kullanılmamış nöbet kalkar.
  - **Testler:** `tests/unit/savas/nobet_tepkisi_test.gd` (menzil girişinde tetiklenme, tek seferlik harcanma, mızrak karşılaması).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.eylem.nobet_tut`, `svs.gunluk.nobet_tetiklendi` (TR ve EN).
  - **Sahip:** baştan.

- [ ] **SVS-18:** Kazanma, mağlubiyet, geri çekilme, teslim ve §5.9 sonuç tablosu (K4)
  - **Amaç:** Savaşın bitiş koşullarını (galibiyet, mağlubiyet, Muhafız düştü, geri çekilme, teslim) tek tabloda birleştirmek ve K4 kuralını garantiye almak.
  - **Kapsam:** `data/savas/sonuc_tablosu.json` (§5.9 tablosu: tetik, ganimet, itibar, husumet, yara, kaynak, köye etki), harita kenarından geri çekilme, bozgunda/ağır yarada düşman teslimi ve **Muhafız HP=0 olunca savaşın kaybedilmiş sayılması** (kalan dostlar çekilebilir, galibiyet yazılmaz, komuta devredilmez, Muhafız hayatta kalır) dahildir.
  - **Bağımlılıklar:** `SVS-14`, `SVS-15`, `K4`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/sonuc_cozucu.gd`, `data/savas/sonuc_tablosu.json`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `sonuc_tablosu.json`: `galibiyet`, `maglubiyet`, `muhafiz_dustu`, `cekilme` satırları (`ganimet_izni`, `itibar_yonu`, `husumet_yonu`, `kaynak_kaybi`, `koy_etkisi`).
  - **Kabul ölçütleri:** Muhafız HP=`0` olduğunda düşman sonradan temizlense bile sonuç `galibiyet` olmaz, `muhafiz_dustu` (mağlubiyet) yazılır; harita kenarından çekilen birim canlı kalır ama ganimet alamaz.
  - **Testler:** `tests/unit/savas/sonuc_cozucu_test.gd` (4 bitiş durumu, Muhafız HP=0 mağlubiyeti, teslim ve çekilme).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.sonuc.galibiyet`, `svs.sonuc.maglubiyet`, `svs.sonuc.muhafiz_dustu`, `svs.sonuc.cekilme` (TR ve EN).
  - **Sahip:** baştan.

- [ ] **SVS-19:** Yalnız test amaçlı YZ–YZ koşucusu (K10)
  - **Amaç:** Otomatik testlerin (`otomatik_oyuncu` ve denge ölçümü) UI açmadan iki tarafı da YZ ile oynatarak savaşı baştan sona tamamlayabilmesini sağlamak.
  - **Kapsam:** Headless YZ–YZ döngüsü (azami tur emniyet sınırı ile sonsuz döngü koruması) dahildir. **Oyuncu menüsünde veya savaş kararı ekranında kesinlikle görünmez (K10); oyuncuya açık otomatik çözüm değildir.** Eski `savunma_gucu` / `HusumetBaskini` formülleriyle aynı sayıyı verme testi yazılmaz.
  - **Bağımlılıklar:** `SVS-18`, `SVS-20`, `K10`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/yz_test_kosucusu.gd`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** veri yok.
  - **Kabul ölçütleri:** Sabit tohumla bir `3 harami / 2 muhafız` savaşı `<= 30` rauntta sonlanır; `SavasKararPaneli` ve UI sahnelerinde bu koşucuyu çağıran hiçbir düğme yoktur.
  - **Testler:** `tests/unit/savas/yz_test_kosucusu_test.gd` (sonlanma garantisi, UI düğmesi yokluğu taraması).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** metin yok.
  - **Sahip:** baştan.

---

## C. Yapay Zekâ ve Zorluk (`baştan`)

- [ ] **SVS-20:** Fayda tabanlı YZ çekirdeği, zorluk eğrisi ve baskın strateji yasağı
  - **Amaç:** Hile yapmayan (gizli zar/istatistik bonusu almayan) fayda tabanlı YZ kurmak; zorluk eğrisini birim sayısı/bileşimiyle yönetmek ve tek doğru baskın stratejileri ("hep yay", "hep kapıda bekle") veri tablosuyla cezalandırmak.
  - **Kapsam:** Aksiyon puanlama çekirdeği (hasar beklentisi, öldürme şansı, siper değeri, hedef önceliği, kaçış); zorluk eğrisi tablosu (ilk savaş `2–4` birim ve düşük zırh, ilerledikçe `20` birim tavana kadar çeşitlenen düşman bileşimi); baskın strateji karşı önlemleri (ör. uzun süre kapıda bekleyene karşı yangın/gedik/kuşatma baskısı, yalnız yay kullanan takıma karşı kalkan duvarı ve hızlı süvari baskısı) dahildir.
  - **Bağımlılıklar:** `SVS-12`, `SVS-13`, `SVS-15`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/savas_yz.gd`, `data/savas/yz_kurallari.json`, `data/savas/zorluk_egrisi.json`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `zorluk_egrisi.json`: `{evreler: [{gun_min, birim_min, birim_max, izinli_siniflar}]}`. `yz_kurallari.json`: `{karsi_strateji: {hep_yay_kalkan_bonusu, kapi_bekleme_yangin_agirligi}}`.
  - **Kabul ölçütleri:** YZ hiçbir koşulda oyuncudan farklı zar veya gizli bonus almaz; 1. evre savaşı `<= 4` düşmanla başlar; düşmanlar kalkan duvarı/yan ateş ile "hep yay" veya "hep kapıda bekle" düzenine karşı puan önceliğini değiştirir.
  - **Testler:** `tests/unit/savas/savas_yz_test.gd` (hile yokluğu, zorluk eğrisi basamakları, karşı strateji puan kayması).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** metin yok.
  - **Sahip:** baştan.

- [ ] **SVS-21:** Davranış profilleri tek tablosu
  - **Amaç:** Farklı düşman ve yardımcı dost sınıflarının aynı YZ çekirdeği üzerinde farklı taktik karakterler sergilemesini sağlamak.
  - **Kapsam:** Tek veri tablosunda 5 profil ağırlığı (`harami`: ganimet hücresi + zayıf hedef + erken kaçış; `tekfur_yayasi`: kapı/gedik + kalkan duvarı; `atli_okcu`: mesafe koruma + vur-kaç; `koylu_milis`: mevzi savunması; `caresiz_tek_kisi`: kaçış yolu arama, sıkışınca saldırı) dahildir. Profil başına ayrı kod veya madde açılmaz.
  - **Bağımlılıklar:** `SVS-20`, `SVS-05`.
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
  - **Bağımlılıklar:** `SVS-20`, `ROADMAP_2` (`HAR-06`).
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/niyet_gosterimi.gd`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** veri yok.
  - **Kabul ölçütleri:** Gözcü kulesi yokken ve keşif eri yokken niyet listesi boştur (`0` kayıt); kule varken en az yaklaşan düşmanların hedef niyeti veri olarak döner.
  - **Testler:** `tests/unit/savas/niyet_gosterimi_test.gd` (gözcü kulesi/keşif eri açık-kapalı ayrımı).
  - **Asset:** Niyet oku/çizgisi 2B arayüz envanterine yazılır.
  - **Metin anahtarları:** `svs.ipucu.niyet_gizli` (TR ve EN).
  - **Sahip:** baştan.

---

## D. Savaş Türleri (`baştan`)

- [ ] **SVS-23:** Kapı arbedesi ve muhafız düellosu (K11)
  - **Amaç:** `CAT-01`/`CAT-02` kapı kavgasının "askerle karşılık" seçeneğini sıra tabanlı oynanır kılmak; oyuncuya adamlarını gönderme veya muhafızın kendisiyle düello yapma yollarını açmak.
  - **Kapsam:** `CAT-02` "askerle karşılık" içinde iki oynanır alt yol (`adamlari_gonder` 1–3v1–3 veya `muhafiz_duellosu` 1v1, `kapi_arenasi` üzerinde), eski tek zar otomatik çözümünün kaldırılması ve `CAT-02` beşinci seçenek yasağının korunması dahildir.
  - **Bağımlılıklar:** `SVS-09`, `SVS-18`, `ROADMAP_1` (`CAT-01`, `CAT-02`), `K11`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/turler/kapi_arbedesi_akisi.gd`; mevcut `src/kapi/kapi_kavgasi.gd` ve `src/arayuz/kapi_kavgasi_paneli.gd` içine ince adaptör. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** veri yok (`data/kapi_kavgasi.json` tetikleyicisini okur).
  - **Kabul ölçütleri:** Kapı kavgasında 4 ana seçenek korunur (5. seçenek yok); "askerle karşılık" seçilince her iki yol da `SavasDurumu` başlatır; eski tek zar çözümü oyuncuya açık kalmaz.
  - **Testler:** `tests/unit/savas/kapi_arbedesi_test.gd` (iki yolun da arena başlatması, 4 seçenek sınırı, Muhafız HP=0 mağlubiyeti).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.kapi.adamlari_gonder`, `svs.kapi.muhafiz_duellosu` (TR ve EN).
  - **Sahip:** baştan.

- [ ] **SVS-24:** Gece baskını (`Husumet.gece` ve `CAS-08`)
  - **Amaç:** Soyut kalan `HusumetBaskini` ve Karaboran intikamını (`CAS-08`) köy ızgarasında gece görüş kısıtlı oynanır baskın savaşına çevirmek.
  - **Kapsam:** Gece görüşü (`SVS-12`), ambar/ağıl hedefleyen harami baskını kurulumu, `CAS-08` tetiği ve kurt sürüsü (`MEV-10`) hafif baskın varyantı (veri parametresiyle) dahildir.
  - **Bağımlılıklar:** `SVS-12`, `SVS-18`, `SVS-21`, `ROADMAP_1` (`CAS-08`, `MEV-10`, `BUG-18`).
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/turler/gece_baskini_akisi.gd`; mevcut `src/koy/husumet_baskini.gd` içine ince adaptör. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `data/savas/senaryolar/gece_baskini.json`: `{hedef_binalar, ganimet_calma_turu, kurt_varyanti_parametreleri}`.
  - **Kabul ölçütleri:** Nüfus eşiği altındayken (`BUG-18` / `OMR-42`) kurt dışı gece baskını açılmaz; gece görüş kısıtı aktiftir; baskın sonucu mevcut husumet/stok alanlarına yazar.
  - **Testler:** `tests/unit/savas/gece_baskini_test.gd` (gece görüşü, `BUG-18` kapısı, ambar hedefleme).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.baskin.baslik`, `svs.baskin.karaboran` (TR ve EN).
  - **Sahip:** baştan.

- [ ] **SVS-25:** Kapı ve sur kuşatması (Tekfur baskını)
  - **Amaç:** Oyunun en kritik tehdidi olan Tekfur baskınını tek sayı karşılaştırmasından çıkarıp çok aşamalı savunma savaşına dönüştürmek.
  - **Kapsam:** Yaklaşma, kapı/sur savunması, gedik açılması ve iç avlu aşamaları; `HAR-10` konuşlanmasından başlangıç dizilişi; `tekfur_gucu` yerine `SavasDurumu` sonucuyla `SON_TEKFUR` bağlantısı dahildir.
  - **Bağımlılıklar:** `SVS-18`, `SVS-21`, `SVS-26`, `ROADMAP_1` (`HAR-03`, `HAR-10`).
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/turler/kusatma_akisi.gd`; mevcut `src/koy/koy_yonetimi.gd` içindeki `_asamalar` tetiğine tek satırlık adaptör. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `data/savas/senaryolar/tekfur_kusatmasi.json`: `{evreler, kapi_gedik_esigi, takviye_rauntlari, birim_tavani: 20}`.
  - **Kabul ölçütleri:** Kuşatmada en fazla `20` birim sahneye girer (`K15`); kapı sağlamlığı `0` olunca iç avlu geçidi açılır; `savunma_gucu()` formülü silinmez ama kuşatma sonucu savaşla belirlenir.
  - **Testler:** `tests/unit/savas/kusatma_akisi_test.gd` (kapı gediği açılışı, 20 birim sınırı, mağlubiyet/galibiyet bayrağı).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.kusatma.baslik`, `svs.kusatma.gedik_acildi` (TR ve EN).
  - **Sahip:** baştan.

- [ ] **SVS-26:** Kapı ve sur hasarı, yangın ve savaş sonrası onarım
  - **Amaç:** Savaş sırasında kapıya ve binalara verilen fiziksel hasar ile yangının kalıcı olmasını ve mevcut onarım ekonomisine bağlanmasını sağlamak.
  - **Kapsam:** Balta/ateşle kapı ve sura (`sur_hasar`) hasar verilmesi, raunt sonunda yanıcı hücrelere yangın yayılması (`yaz_su_yangin` / ambar kundaklaması bağı), su/köylü müdahalesi ile söndürme ve savaş sonrası mevcut taş/kereste bedeliyle (`KRI-06` onarım modeli) onarım dahildir.
  - **Bağımlılıklar:** `SVS-08`, `SVS-10`, `ROADMAP_1` (`KRI-06`).
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/yapi_ve_yangin.gd`, `data/savas/yangin_kurallari.json`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `yangin_kurallari.json`: `{yayilma_olasiligi, kapi_can, sur_hasar_carpani, sondurme_eylem_bedeli}`.
  - **Kabul ölçütleri:** Kapı hasarı savaş bitince köyün `sur_hasar` alanına kalıcı olarak yazılır; yangın her raunt sonunda komşu yanıcı hücreye veri olasılığıyla sıçrar; onarım taş/kereste stoğundan düşer.
  - **Testler:** `tests/unit/savas/yapi_ve_yangin_test.gd` (sabit tohumlu yangın yayılması, `sur_hasar` kalıcılığı, onarım bedeli).
  - **Asset:** Yangın/duman efekt yer tutucusu `docs/EKSIK_ASSET_ENVANTERI.md` içine yazılır.
  - **Metin anahtarları:** `svs.yangin.basladi`, `svs.yangin.sonduruldu`, `svs.yapi.kapi_kirildi` (TR ve EN).
  - **Sahip:** baştan.

- [ ] **SVS-27:** Moğol tehdidi — küçük grup savaşı ve büyük kol karar düğümü (K5)
  - **Amaç:** `HAR-02` (`mogol_oncusu.gd`) ve `DNY-01` Moğol ilerleyişi sayacı dolduğunda K5 kararına uygun iki farklı çözüm yolu sunmak.
  - **Kapsam:** Küçük öncü/keşif grubu (`3–8` atlı okçu) için sıra tabanlı savaş; büyük akın kolu için **savaşsız karar düğümü** (`kaç`, `saklan`, `haraç ver`, `elçiyle görüş`) dahildir. Büyük kol kesinlikle savaş sahnesi açmaz.
  - **Bağımlılıklar:** `SVS-18`, `SVS-21`, `ROADMAP_1` (`HAR-02`), `ROADMAP_2` (`DNY-01`), `K5`.
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
  - **Bağımlılıklar:** `SVS-18`, `SVS-21`, `ROADMAP_1` (`HAR-05`, `HAR-14`).
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/turler/dis_sefer_akisi.gd`, `data/savas/haritalar/dag_gecidi.json`; mevcut `src/koy/ticaret/pusu_ticaret_akisi.gd` içine ince adaptör. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `dag_gecidi.json`: `{id, genislik, yukseklik, pusu_siperleri, dost_giris, dusman_pusu_noktalari}`.
  - **Kabul ölçütleri:** Sefer zaferi `HAR-14` tüccar ağırlığı bonusunu `3` günlüğüne yazar; köyde en az nöbetçi bırakılmadan sefer başlatılamaz (veya uyarı verir); `BUG-18` nüfus eşiği korunur.
  - **Testler:** `tests/unit/savas/dis_sefer_test.gd` (geçit haritası kurulumu, `HAR-14` bonusu bağlantısı).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.sefer.baslik`, `svs.sefer.pusu_temizlendi` (TR ve EN).
  - **Sahip:** baştan.

- [ ] **SVS-29:** Kervan koruma savaşı
  - **Amaç:** `kervan_korumasi.json` akışını yol haritasında kervanı kaçırma/koruma hedefli oynanır bir savunma senaryosuna bağlamak.
  - **Kapsam:** Tarafsız tüccar kervanı birimleri (sivil), kervanın kaçış kenarına ulaşmasıyla kazanma koşulu, sivil ölümü durumunda ağır itibar/ticaret cezası dahildir.
  - **Bağımlılıklar:** `SVS-18`, `SVS-28`.
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
  - **Bağımlılıklar:** `SVS-06`, `SVS-08`, `SVS-10`, `ROADMAP_1` (`HAR-04`, `HAR-07`), `K1`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/muttefik_takviyesi.gd`; mevcut `src/koy/oba_ittifaki.gd` ve `src/sistemler/sancak_asker_talebi.gd` içine ince adaptör. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `data/savas/takviye_kurallari.json`: `{turkmen_alp_sayisi, uc_beyi_gecikme_raundu, uc_beyi_borc_akcesi}`.
  - **Kabul ölçütleri:** İttifak yokken Türkmen takviyesi gelmez; toplam birim sayısı takviye dahil `20`'yi geçmez (`K15`); uç beyi yardımı kabul edilirse borç/ferman kayda yazılır.
  - **Testler:** `tests/unit/savas/muttefik_takviyesi_test.gd` (ittifak açık/kapalı, 20 birim tavanı koruması, borç kaydı).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.takviye.turkmen_geldi`, `svs.takviye.subasi_pazarlik` (TR ve EN).
  - **Sahip:** baştan.

- [ ] **SVS-54:** Okçuluk mini oyunu ile sur okçusu becerisi bağlantısı (K9)
  - **Amaç:** Mevcut `okculuk_oyunu.gd` mini oyunundaki performansın `HAR-10` sur okçusu birimlerinin savaş becerisine yansımasını sağlamak.
  - **Kapsam:** Okçuluk mini oyun skorunun sur okçusu `menzil_becerisi` bonusuna (verideki tavanla sınırlı) bağlanması dahildir. İkinci bir mini oyun yazılmaz.
  - **Bağımlılıklar:** `SVS-03`, `SVS-06`, `ROADMAP_1` (`HAR-10`), `K9`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/okculuk_beceri_bagi.gd`; mevcut `src/arayuz/okculuk_oyunu.gd` içine tek satırlık adaptör. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `data/savas/donusum_kurallari.json` içine `okculuk_beceri_bonusu_tavan` alanı.
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
  - **Bağımlılıklar:** `SVS-23`, `SVS-24`, `SVS-25`, `SVS-27`, `ROADMAP_1` (`HAR-06`, `HAR-13`), `K10`, `K11`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/arayuz/savas/savas_karar_paneli.gd` ve `.tscn`. Korumalı çekirdeğe dokunulmaz (`koy_ekrani.gd` / `kapi_ekrani.gd` adaptör çağrısı üzerinden açılır).
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
  - **Asset:** Konuşlanma hücresi vurgusu 2B arayüz envanterine yazılır.
  - **Metin anahtarları:** `svs.konuslanma.baslik`, `svs.konuslanma.baslat` (TR ve EN).
  - **Sahip:** sondan.

- [ ] **SVS-33:** Ganimet paylaşımı ve adalet/yozlaşma terazisi (K13)
  - **Amaç:** Savaş zaferi sonrası ele geçirilen ganimetin (silah, zırh, at, akçe, `YAP-56` usta defteri) paylaşımını ahlaki bir terazi kararına dönüştürmek.
  - **Kapsam:** Üçlü paylaşım kararı (`beye_pay`, `koye_pay`, `muhafiza_pay`), mevcut kasa/vergi ve adalet–yozlaşma terazisine (`terazi_etkisi`) yazım, `YAP-56` usta defteri düşme olasılığı dahildir.
  - **Bağımlılıklar:** `SVS-18`, `ROADMAP_2` (`YAP-56`), `K13`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/ganimet_paylasimi.gd`, `data/savas/ganimet_tablosu.json`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `ganimet_tablosu.json`: `{secenekler: {beye_pay, koye_pay, muhafiza_pay}, terazi_deltalari, defter_dusme_olasiligi}`.
  - **Kabul ölçütleri:** `muhafiza_pay` seçimi yozlaşma yönüne, `koye_pay` adalet yönüne terazi deltası yazar; toplam dağıtılan akçe ganimet toplamını aşmaz; `YAP-56` usta defteri düşerse envantere eklenir.
  - **Testler:** `tests/unit/savas/ganimet_paylasimi_test.gd` (terazi yönü, akçe toplam koruması, defter düşmesi).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.ganimet.beye_pay`, `svs.ganimet.koye_pay`, `svs.ganimet.muhafiza_pay` (TR ve EN).
  - **Sahip:** sondan.

- [ ] **SVS-34:** Esir ve fidye akışı (K14)
  - **Amaç:** Teslim olan veya savaş sonunda düşüp yakalanan düşmanların zindana alınmasını, fidye pazarlığını ve salıverme kararlarını yönetmek.
  - **Kapsam:** Esir yakalama, zindanda tutma (erzak maliyeti), fidye teklifi/ödemesi, salıverme ve kısmi divan hükmü bağlantısı dahildir (işin tamamı divana devredilmez, K14).
  - **Bağımlılıklar:** `SVS-18`, `SVS-33`, `K14`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/esir_yoneticisi.gd`, `data/savas/esir_kurallari.json`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `esir_kurallari.json`: `{fidye_degerleri_sinif, gunluk_erzak_bedeli, saliverme_itibar_deltasi, idam_husumet_deltasi}`.
  - **Kabul ölçütleri:** Yakalanan esir sayısı zindan kapasitesini aşamaz; fidye kabul edilince esir listeden düşer ve köy kasasına akçe girer; günlük erzak bedeli düşülür.
  - **Testler:** `tests/unit/savas/esir_yoneticisi_test.gd` (yakalama, fidye akçesi, salıverme itibarı).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.esir.yakalandi`, `svs.esir.fidye_iste`, `svs.esir.saliver`, `svs.esir.zindanda_tut` (TR ve EN).
  - **Sahip:** sondan.

- [ ] **SVS-35:** Savaş sonrası tedavi ve kalıcı sakatlık iş gücü etkisi
  - **Amaç:** Savaş sonu yara/sakatlık zarı (`SVS-14`) sonuçlarını mevcut şifahane ve köylü sağlığı sistemine bağlamak.
  - **Kapsam:** Savaş sonrası HP oranından köylü sağlığına (`0–100`) aktarım, `agir_yara` için çalışma kilidi ve hekimsiz gecede ölüm zarı, `kalici_sakatlik` için iş gücü düşüşü ve askerlikten düşme, `CAT-03` / `KRI-03` / `KRI-13` şifahane yatak ve triyaj bağlantısı dahildir.
  - **Bağımlılıklar:** `SVS-14`, `ROADMAP_1` (`CAT-03`, `KRI-03`, `KRI-13`).
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/savas_tedavi_bagi.gd`; mevcut `src/koy/hekim_ilac.gd` içine ince adaptör. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `data/savas/yara_tablosu.json` içindeki `iyilesme_gunu` ve `sakatlik_isgucu_carpani` alanları.
  - **Kabul ölçütleri:** `kalici_sakatlik` alan köylü asker aday listesine bir daha girmez; şifahane yatakları doluysa triyaj `KRI-13` kuralıyla çalışır; HP'den köylü sağlığına aktarım `0..100` aralığında kalır.
  - **Testler:** `tests/unit/savas/savas_tedavi_bagi_test.gd` (HP→sağlık aktarımı, sakatlık asker engeli, hekimsiz ağır yara).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.tedavi.agir_yara`, `svs.tedavi.kalici_sakatlik`, `svs.tedavi.iyilesti` (TR ve EN).
  - **Sahip:** sondan.

- [ ] **SVS-36:** Ölüm sonrası hane, eş, yetim, miras ve cenaze zinciri (K4)
  - **Amaç:** Savaşta ölen her köylünün/askerin köyde gerçek bir toplumsal iz bırakmasını sağlamak.
  - **Kapsam:** `KRI-05` ve `cenaze_yasi.gd` tek çağrı bağlantısı (`CAT-02` kural 5 korunur), hane reisi ölürse eş/yetim/miras ve `KAP-18` yetim/sığınmacı etkisi dahildir. **Muhafız bu zincire asla girmez (K4).**
  - **Bağımlılıklar:** `SVS-14`, `SVS-18`, `ROADMAP_1` (`KRI-05`, `CAT-02`), `ROADMAP_2` (`KAP-18`), `K4`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/savas_olum_bagi.gd`; mevcut `src/koy/cenaze_yasi.gd` içine ince adaptör. Korumalı çekirdeğe `koy_nufusu.gd` dışından tek çağrı adaptörüyle dokunulmaz (mevcut ölüm akışı çağrılır).
  - **Veri şeması:** veri yok.
  - **Kabul ölçütleri:** Ölen her sivil/asker için cenaze ve yas akışı tam `1` kez tetiklenir; Muhafız HP=`0` olduğunda ölüm sayısı `0` kalır; hane reisi ölünce yetim/miras bayrağı güncellenir.
  - **Testler:** `tests/unit/savas/savas_olum_bagi_test.gd` (tek çağrı cenaze tetiği, Muhafız hariç tutma, hane etkisi).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.olum.cenaze_satiri` (TR ve EN).
  - **Sahip:** sondan.

- [ ] **SVS-37:** Köye etki (moral, güvenlik, husumet, grup itibarı ve ticaret)
  - **Amaç:** Savaş sonucunun (`§5.9`) köyün makro göstergelerine ve `data/gruplar.json` itibarlarına doğrudan yansımasını sağlamak.
  - **Kapsam:** Galibiyet/mağlubiyet sonucuna göre köy morali, `savunma_guvenligi`, `husumet`, grup itibarı (`turkmen`, `rum`, `ahi`, `koylu`, `tuccar`, `asker`) ve kervan/tüccar akışı güncellemeleri dahildir.
  - **Bağımlılıklar:** `SVS-18`, `SVS-35`, `SVS-36`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/koy_etkisi.gd`. Korumalı çekirdeğe dokunulmaz (mevcut `Oturum` / `KoyYonetimi` alanlarına adaptör üzerinden yazar).
  - **Veri şeması:** `data/savas/sonuc_tablosu.json` içindeki `itibar_deltalari`, `moral_deltasi`, `guvenlik_deltasi` alanları.
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
  - **Bağımlılıklar:** `SVS-18`, `ROADMAP_2` (`DIY-13`, Bölüm 37).
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
  - **Bağımlılıklar:** `SVS-18`, `SVS-35`, `SVS-36`, `ROADMAP_2` (`GRV-12`).
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/savas_rapor_bagi.gd`. Korumalı çekirdeğe dokunulmaz (mevcut gece raporu sözlüğüne yazar).
  - **Veri şeması:** veri yok.
  - **Kabul ölçütleri:** Savaş yapılan gecenin `gece_sonu()` raporunda savaş özeti satırı bulunur; ayrı bir tam ekran rapor sahnesi açılmaz.
  - **Testler:** `tests/unit/savas/savas_rapor_bagi_test.gd` (gece raporu satırı varlığı, tek sahne kuralı).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.rapor.ozet_zafer`, `svs.rapor.ozet_yenilgi` (TR ve EN).
  - **Sahip:** sondan.

---

## F. Arayüz, Erişilebilirlik ve Asset (`sondan`)

- [ ] **SVS-41:** Savaş ekranı kabuğu (tur şeridi, birim kartı, eylem çubuğu)
  - **Amaç:** Oyuncunun sıra tabanlı savaşı okuyup yönetebileceği ana savaş arayüzünü Bölüm 43 tema anahtarlarıyla kurmak.
  - **Kapsam:** Üstte tur sırası şeridi (`SVS-10`), altta seçili birim kartı (HP, moral, yorgunluk, kalan eylem `2/2`, ekipman), eylem çubuğu (`hareket`, `saldır`, `nöbet tut`, `kalkan`, `bandaj`, `emir`, `çekil`) ve ızgara vurgu katmanı dahildir.
  - **Bağımlılıklar:** `SVS-10`, `SVS-11`, `ROADMAP_2` Bölüm 43 (`GRV`).
  - **Etkilenen dosya ve klasörler:** Yeni `src/arayuz/savas/savas_ekrani.gd` ve `.tscn`, `tur_seridi.gd`, `birim_karti.gd`. Korumalı çekirdeğe (`tema.gd`, `hud.gd`) dokunulmaz.
  - **Veri şeması:** veri yok.
  - **Kabul ölçütleri:** Seçili birimin HP, moral, yorgunluk ve `2/2` eylem göstergesi `SavasDurumu` ile senkronize güncellenir; tüm düğmeler Bölüm 43 tema anahtarlarını kullanır.
  - **Testler:** `tests/oto/savas_ekrani_kontrol.tscn` (headless açılış, tur şeridi ve birim kartı güncellemesi, 0 script hatası).
  - **Asset:** 2B arayüz üretimi serbesttir; tüm yeni UI ikonları `docs/EKSIK_ASSET_ENVANTERI.md` içine yazılır.
  - **Metin anahtarları:** `svs.eylem.hareket`, `svs.eylem.saldir`, `svs.eylem.kalkan`, `svs.eylem.bandaj`, `svs.eylem.emir`, `svs.eylem.cekil` (TR ve EN).
  - **Sahip:** sondan.

- [ ] **SVS-42:** Hedefleme, isabet olasılığı, görünür zar kadrajı ve erişilebilirlik
  - **Amaç:** Hedef üzerine gelince isabet olasılığını (`basari_olasiligi`) ve gerekli zar değerini göstermek, zar atışını mevcut görünür zar kadrajıyla yapmak ve tam erişilebilirlik sağlamak.
  - **Kapsam:** Hedef imleci tooltip'i (`basari_olasiligi` ve gerekli `d12` değeri), görünür zar kadrajı bağlantısı (`ZAR_BASARILI` vb.) ve **erişilebilirlik kuralları** (sonuç renkle değil sözcükle yazılır, yazı puntosu `GRV-13` altına inmez, savaş hızı `1x`/`2x` ayarı) dahildir.
  - **Bağımlılıklar:** `SVS-13`, `SVS-41`, `ROADMAP_2` (`ZAR-01`, `GRV-13`).
  - **Etkilenen dosya ve klasörler:** Yeni `src/arayuz/savas/hedefleme_ve_zar.gd`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** veri yok.
  - **Kabul ölçütleri:** Zar sonucu etiketinde yalnızca renk değil açık sözcük (`ZAR_BASARILI` / `ZAR_BASARISIZ` vb.) yer alır; tüm savaş etiketleri `>= GRV-13` asgari puntosundadır; isabet olasılığı `SavasZari` ile birebir aynıdır.
  - **Testler:** `tests/unit/savas/hedefleme_ve_zar_test.gd` (olasılık eşleşmesi, sözcük varlığı, punto alt sınırı).
  - **Asset:** Zar kadrajı mevcut `ZAR01` altyapısını kullanır.
  - **Metin anahtarları:** `svs.ui.isabet_yuzde`, `svs.ui.gereken_zar`, `svs.ui.savas_hizi` (TR ve EN).
  - **Sahip:** sondan.

- [ ] **SVS-43:** Savaş günlüğü
  - **Amaç:** Savaş ekranının sol altında her hamle, zar, hasar, moral ve yangın olayını kronolojik metin satırları olarak göstermek.
  - **Kapsam:** Kaydırılabilir günlük kutusu ve `SavasDurumu.gunluk` olaylarından çeviri anahtarıyla satır üretimi dahildir.
  - **Bağımlılıklar:** `SVS-07`, `SVS-41`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/arayuz/savas/savas_gunlugu_paneli.gd`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** veri yok.
  - **Kabul ölçütleri:** Her saldırı ve moral değişimi günlükte `1` okunaklı satır üretir; metinler `tr()` üzerinden çevrilir.
  - **Testler:** `tests/unit/savas/savas_gunlugu_test.gd` (olay→satır biçimleme ve boş/ham anahtar kalmaması).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** `svs.gunluk.saldiri`, `svs.gunluk.kacis`, `svs.gunluk.dustu` (TR ve EN).
  - **Sahip:** sondan.

- [ ] **SVS-44:** Savaş sonu özet paneli
  - **Amaç:** Savaş biter bitmez oyuncuya kayıpları, yaralıları, esirleri ve ganimet/paylaşım kararını tek özet panelinde göstermek.
  - **Kapsam:** Sonuç başlığı (`§5.9`), düşenler ve yara zarı sonuçları (`SVS-14`), esirler (`SVS-34`), ganimet paylaşımı (`SVS-33`) ve köye dönüş düğmesi dahildir.
  - **Bağımlılıklar:** `SVS-18`, `SVS-33`, `SVS-34`, `SVS-41`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/arayuz/savas/savas_ozet_paneli.gd` ve `.tscn`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** veri yok.
  - **Kabul ölçütleri:** Panel `SVS-18` sonucunu, ölü/yaralı sayısını ve esir sayısını doğru listeler; zaferde ganimet paylaşım seçimi yapılmadan panel kapanmaz.
  - **Testler:** `tests/unit/savas/savas_ozet_paneli_test.gd` (galibiyet/mağlubiyet özet alanları, ganimet seçim kilidi).
  - **Asset:** 2B panel düzeni Bölüm 43 temasıyla yapılır.
  - **Metin anahtarları:** `svs.ozet.baslik`, `svs.ozet.kayip_yok`, `svs.ozet.koye_don` (TR ve EN).
  - **Sahip:** sondan.

- [ ] **SVS-45:** Savaş girdileri (klavye, fare ve gamepad)
  - **Amaç:** Tüm savaş ekranının fare, klavye ve gamepad ile eksiksiz oynanabilmesini ve `ROADMAP_2` Bölüm 45 girdi standardına uymasını sağlamak.
  - **Kapsam:** Izgara imleç gezintisi, birim seçimi, eylem kısayolları (`1..7`), turu bitirme ve odak geri dönüşü (`grab_focus`) dahildir.
  - **Bağımlılıklar:** `SVS-41`, `ROADMAP_2` Bölüm 45.
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
  - **Bağımlılıklar:** `SVS-01..45`, `ROADMAP_2` Bölüm 46, `K1`, `K18`.
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
  - **Bağımlılıklar:** `SVS-41`, `K16`.
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

- [ ] **SVS-49:** Dengeleme tabloları, karşı güçler ve senaryo ölçüm koşucusu
  - **Amaç:** Savaş ekonomisini, isabet/hasar tavanlarını ve karşı güç dengelerini sayısal veri tablolarında doğrulamak; baskın strateji açıklarını ölçmek.
  - **Kapsam:** `senaryo_kosucusu.gd` üzerinde sabit tohumlu ölçüm senaryoları (`3 harami / 2 muhafız`, `kapı düellosu`, `kuşatma`, `Moğol öncü`, `hep yay vs kalkan`), sayısal tavan/alt sınır doğrulayıcısı (`tools/savas_denge_dogrula.py`) dahildir.
  - **Bağımlılıklar:** `SVS-19`, `SVS-20`, `SVS-23..29`.
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/senaryo_kosucusu.gd`, `tools/savas_denge_dogrula.py`, `data/savas/denge_sinirlari.json`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** `denge_sinirlari.json`: `{hp_min, hp_max, hasar_tavan, birim_tavani: 20, karsi_guc_matrisi}`.
  - **Kabul ölçütleri:** `tools/savas_denge_dogrula.py` `0` hata verir; sabit tohumlu `100` ölçüm koşusunda `3 harami / 2 muhafız` senaryosu dengeli (`%35–%75` aralığında) sonuçlanır; Muhafız HP=`0` olduğunda `0` kez galibiyet yazılır.
  - **Testler:** `tests/tools/test_savas_denge.py` ve `tests/unit/savas/senaryo_kosucusu_test.gd`.
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** metin yok.
  - **Sahip:** sondan.

- [ ] **SVS-50:** `otomatik_oyuncu` 20 gece savaşlı duman testi (K10)
  - **Amaç:** Oyunun 20 gecelik tam döngüsünün, savaşlar sırasında kilitlenmeden ve oyuncuya açık otomatik çözüm eklenmeden (`K10`) çalıştığını doğrulamak.
  - **Kapsam:** `otomatik_oyuncu.gd` içinde yalnızca test koşusu sırasında `SVS-19` (`yz_test_kosucusu.gd`) çağrısını kullanan ince test kancası dahildir. Oyuncu arayüzüne atlama seçeneği eklenmez.
  - **Bağımlılıklar:** `SVS-19`, `SVS-48`, `SVS-49`, `K10`.
  - **Etkilenen dosya ve klasörler:** `tests/oto/otomatik_oyuncu.gd` (yalnız `SVS-19` test kancası eklenir; mevcut akış bozulmaz).
  - **Veri şeması:** veri yok.
  - **Kabul ölçütleri:** `otomatik_oyuncu` `20` geceyi `0` kilitlenme, `0` script hatası ve `0` yetim node ile tamamlar; UI'da otomatik çözüm düğmesi yoktur.
  - **Testler:** `tests/oto/otomatik_oyuncu_savas_kontrol.tscn` (headless 20 gece koşusu).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** metin yok.
  - **Sahip:** sondan.

- [ ] **SVS-51:** Perde ve son bağlantıları + `ROADMAP_2` sınır koruması
  - **Amaç:** 2. perde savunma savaşını, Tekfur ve haraç sonlarını (`SYS-19`, `SYS-20`) sıra tabanlı savaş sonuçlarına bağlamak; `BUG-18`/`OMR-42` nüfus eşiğini ve `MCL-09` meclis yasağını korumak.
  - **Kapsam:** `SON_TEKFUR` ve 2. perde savunma tetiklerinin `SVS-25` kuşatma sonucuna bağlanması, `BUG-18` (`nufus < 14` iken kurt dışı baskın yok) ve `MCL-09` (meclis savaş açamaz) sınır kontrollerinin korunması dahildir.
  - **Bağımlılıklar:** `SVS-25`, `SVS-37`, `ROADMAP_1` (`SYS-19`, `SYS-20`), `ROADMAP_2` (`BUG-18`, `OMR-42`, `MCL-09`).
  - **Etkilenen dosya ve klasörler:** Yeni `src/savas/perde_son_bagi.gd`; mevcut `src/sistemler/perde_yoneticisi.gd` içine tek satırlık adaptör. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** veri yok.
  - **Kabul ölçütleri:** Kuşatma mağlubiyeti `SON_TEKFUR` sonunu tetikler; nüfus eşiği altındayken kurt dışı savaş `0` kez açılır; meclis kararlarından savaş tetiklenmez.
  - **Testler:** `tests/unit/savas/perde_son_bagi_test.gd` (Tekfur sonu, `BUG-18` ve `MCL-09` sınır doğrulaması).
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** metin yok (mevcut son metinleri korunur).
  - **Sahip:** sondan.

- [ ] **SVS-52:** `ROADMAP_3` kapanış testi
  - **Amaç:** Tüm `SVS-01..54` katmanlarının uçtan uca bir arada hatasız çalıştığını tek kapanış kapısında doğrulamak.
  - **Kapsam:** Godot headless import + parse kontrolü, tüm `tests/unit/savas/*.gd`, `tests/oto/savas_*.tscn`, `tools/savas_denge_dogrula.py`, `tools/metin_dogrula.py`, `ROADMAP_2` sınır testlerinin (`MCL-09`, `BUG-18`, `YAP-56`, `HAR-02`) bozulmadığının doğrulanması ve `docs/OYUN_RAPORU.md` kapanış notu dahildir.
  - **Bağımlılıklar:** `SVS-01..51`, `SVS-53`, `SVS-54`.
  - **Etkilenen dosya ve klasörler:** Yeni `tests/oto/savas_kapanis_kontrol.gd` ve `.tscn`. Korumalı çekirdeğe dokunulmaz.
  - **Veri şeması:** veri yok.
  - **Kabul ölçütleri:** Tam savaş test paketi ve `tools/sanity_check.py` `0` script hatası, `0` failed assertion ve `0` sızan yetim kaynakla geçer.
  - **Testler:** `tests/oto/savas_kapanis_kontrol.tscn` + `tools/sanity_check.py`.
  - **Asset:** asset gerekmedi.
  - **Metin anahtarları:** metin yok.
  - **Sahip:** sondan.

---

**Toplam:** 54 madde (`SVS-01` … `SVS-54`; `baştan`: 32 madde [A, B, C, D], `sondan`: 22 madde [E, F, G]).

**Kapsam dışı (K7, gelecek notu):** Kıtlık / açlık isyanı ve ambar yağması (`KRI-06`, `KRI-14`) `ROADMAP_3` kapsamı dışındadır; mevcut akış olduğu gibi kalır, ayrı `SVS-*` maddesi açılmaz.
