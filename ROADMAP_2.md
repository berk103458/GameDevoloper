# Kapı Muhafızı — ROADMAP 2

Bu dosya ROADMAP 2’nin tek ve geçerli kopyasıdır (11 Ekim 2026, Muharrir birleştirdi). ROADMAP 1 (`ROADMAP.md`) bitmiş oyundur ve yalnız okuma referansıdır.

## AJAN İLERLEME PANOSU (her ajan önce burayı okusun)

- **Sahiplik:** Bir maddeye başlamadan önce `git pull`, sonra maddeyi `[/] (AjanAdı)` yap, commit + push et. Başka ajanın `[/]` işaretlediği maddeye DOKUNMA. Bitince `[x] (AjanAdı)`.
- **Asset teslimi (Ahmet/Muharrir, 12 Ekim):** Mekanik isim etiketli kutuyla biter, asset beklenmez. Envanter 2D/3D ayrılır: 2D için aynı maddede gece_kapisi tekli prompt + dosya/ölçü/saydamlık (saydam kaynak #00FF00), 3D için kısa tanım + metreyle ölçü. Asset entegrasyonu üretim bitince yapılır; önceki erken ekleme izninin sırasını bu kural değiştirir.
- **Sıra:** Aşağıdaki "Önerilen uygulama sırası" fazlarına göre ilerle. Faz 0 bitmeden Faz 1’e geçme (paralel çalışan ajanlar aynı fazın farklı maddelerini alır).
- **Küçük maddeler:** Boyutu S olan ve tek satırlık test/kontrol niteliğindeki maddeler, aynı alt başlıktaki ait oldukları büyük maddeyle birlikte tek iş olarak alınabilir; o zaman hepsi aynı commit’te `[x]` yapılır ve commit mesajında kimlikler listelenir.
- **Asset:** Üretme yok. Uygun ve açık lisanslı (CC0/CC-BY) asset internetten eklenebilir, kaynak+lisans envantere (AGENTS.md asset kuralı, Berk 11 Ekim). Bulunamazsa isim etiketli kutu yer tutucu kullan, gereken asset `docs/EKSIK_ASSET_ENVANTERI.md` ve ARY-05 listesine.
- **Mimari:** festive tek ana dal; yeni dosya + ince adaptör; `koy_sahnesi` yasak; ROADMAP 1 sistemleri yeniden kurulmaz, adaptörle okunur.
- **İlk iş (Claude):** `Roadmap-2/arsiv/` altındaki temizlik artığı — Bölüm 19–21 dolgu ayıklaması ve TASIMA_LISTESI dosyalarının uygulanması. Ayrıntı: Ajan Masası (#11).

Zemin kuralı: `ROADMAP.md` (yol haritası 1) bitmiş oyundur ve yalnız okuma referansıdır. Silinmez, bu dizinin yerine geçmez. Yeni madde o makineyi yeniden kurmaz. Salgın, mevsim, tüccar, divan mahkemesi, yozlaşma ağacı, bölge haritası, çift kasa, cenaze, gözcü kulesi, heybe, tansiyon aralığı, üretim zinciri, atomik kayıt (SYS-02) ve sürüm göçü (SYS-01, SYS-14) adaptörle okunur.

Ortak madde kuralları aşağıda "Ortak madde kuralları" başlığındadır. Asset üretilmez. Oyun kodu bu klasörden değiştirilmez.

## Önerilen uygulama sırası

> Parça adları eski bölünmeden kalmadır: **Parça A** = Bölüm 13, 14, 15, 24 · **Parça B** = Bölüm 16, 17, 18, 25 ve köprü maddeleri KOP-01…10 (en sondaki EK A’da) · **Parça C** = Bölüm 19, 20, 21, 22, 23, 25a. Yardımcı belgeler ve diyalog prototipi `Roadmap-2/` klasöründedir (`USLUP_REHBERI.md`, `OZGUNLUK.md`, `DIYALOG_URETIM_ARASTIRMASI.md`, `soz_agaci/`); eski parça dosyaları ve karar kayıtları `Roadmap-2/arsiv/`.

1. **Faz 0:** Parça A, BUG-16 … BUG-25.
2. **Faz 1:** Parça A, ACL ve KAP-16 … KAP-19. ARY-01 erken başlar, seçim insan bekler.
3. **Faz 2:** Parça B, DIY, ZAR, CAT, DYL-01 … DYL-06, KOP-01 … KOP-10. Aynı fazda Bölüm 31 (kayıt göçü), hafıza ve güven alanları kayda yazılır yazılmaz. Parça C'de YAZ-01 … YAZ-03 motoru beklemez.
4. **Faz 3:** Parça C, YAZ-04 … YAZ-10. Parça B, DYL-07 … DYL-10 ve DYL-16.
5. **Faz 4:** Parça C, ISG, YAP, YSM, SEV-01 … SEV-07. Bu fazın sonunda Bölüm 32 (ölçüm). ZAR ve açılış stoku hazır olmadan ölçüm kapanmaz.
6. **Faz 5:** Parça C, DNY.
7. **Faz 6:** Parça A, ARY-02 … ARY-05.
8. **43'ten sonra, 26–30 genişletmesinden önce:** Bölüm 44 (3B cila), sonra 45 (kontroller), sonra 46 (yerelleştirme altyapısı). ~~Her biri onay beklemeden yazılmaz.~~ (Muharrir, 11 Ekim 2026: onay bekleme iptal; 33–46 tek seferde yazıldı.)
9. **46'dan sonra:** Bölüm 26, 27, 28, 29 ve 30 bugün tek başlık ve on maddedir. ~~En az on alt başlık kuralına çekilmeleri 46 bittikten sonraya bırakıldı. O iş 46 bitmeden başlanmaz.~~ (11 Ekim 2026: alt başlık yapısı verildi; madde eklenmedi, dolgu yok. Alt başlık sayısı onun altındaysa sebebi bölüm sonunda tek cümledir.)
10. **Uygulama fazı (33–46):** 41 (teknik borç) Faz 0 ile birlikte başlar. 33 ve 35 Faz 1'e eklenir. 36, 37, 39 Faz 2–3'te Söz motorunun kaydını okur. 34 ve 38 Faz 5 (DNY) ile birlikte. 40 Faz 3 yazım hattıyla. 43 Faz 6 (ARY) içinde, yüksek öncelikli. 42, 45, 46 en son; 42 sürümden önce kapanır.

## Karar kaydı (Ahmet, 10 Ekim 2026)

1. **ACL-04:** Kapıyı Sancak Beyi'nin ulağı ve beratı açar; hemen ardından ilk aile gelir ve ilk sorgu onlarla yapılır.
2. **ZAR-01:** Tansiyon eki üç kademe: sakin +0, gergin +1, panik +2. Değer 2 → 3 / 4 / 5.
3. **ACL-02:** Eşin mesleğini oyuncu seçer, ama yalnız eşe uygun listeden (demirci, taşçı, asker vb. yok).
4. **YAP-04:** "Şematik" yerine "usta defteri / yapı resmi".
5. **DIY-16:** Eski diyaloglar taşınmaz, baştan yazılır. Önce profesyonel oyunların mantığı incelenir, kendi stilimizle motor kurulur (DIY-01).
6. **YAZ-02:** Doğallık kelimeden değil cümle yapısından gelir. Metin önce sesli doğaçlamayla çıkar, sonra yapaylık denetimi ve satır satır inceleme yapılır (YAZ-10).
7. **YAZ-09:** Şablon bir dilbilgisidir, içerik kalıbı değil. Her karakterin sırrı olmaz; hikâye çekirdekleri kadroya kotayla dağıtılır.
8. **Bölüm 25 (Diyalog):** Sorgu eylemleri, kapı dışındaki sonuçlar ve yazım araçları tek bölümde toplandı. Oyuna ses eklenmez; bütün araçlar metinle çalışır.
9. **Zemin (11 Ekim 2026):** `ROADMAP.md` kapanmış işin listesidir. Yeni madde o makineyi yeniden kurmaz. Köprü maddeleri KOP-01…08 ve prototip sırası A3 bu kuralın uygulamasıdır.
10. **Bölünme (11 Ekim 2026):** Gövde üç dosyaya ayrıldı. Kararların metni değişmedi. Planın ekleri: bar eşiği KAP-16'da ya işler ya sayfadan silinir. Bölüm 5 satırı KOP-04'te `hedef_sistem + alan + deger` olur, parser bina adı tahmin etmez. Sayfasız 93 takip kimliği KOP-09. Kapıdaki sayı KOP-10'da kişinin karar matrisinden gelir, sınıf şablonu yalnız adsızda kalır. Üç diyalog biçiminin eşlemesi DIY-16'dadır. Şema sır dayatmaz (DIY-01a). Prototip dosyası DYL-16'da `--check` ile doğrulanır. SEV-01…07 Parça C'dedir. Hitap türü YAZ-09 kotasının notudur. Kalp puanı, hediye takvimi, romans, seslendirme ve ikinci harita yoktur.


## Ortak madde kuralları


Parça A: acil kilitler, açılış, kapı akışı, arayüz. Oyun kodu bu dosyadan yazılmaz.

**Madde biçimi:** Amaç, numaralı Kurallar, Uç durumlar, ölçülebilir Kabul ve test, Bağımlılık, Boyut, Dosya, Asset.

**Ortak kurallar:** yeni dosya + ince adaptör; çekirdekte minimal ekleme; `koy_sahnesi` / statik `KoyYerlesimi` yok; ajan asset üretmez (uygun ve açık lisanslı asset kaynak ve lisansıyla eklenebilir; AGENTS.md asset kuralı). ROADMAP 1 bitmiştir. Salgın, mevsim motoru, tüccar, divan mahkemesi, yozlaşma ağacı, bölge haritası, çift kasa, cenaze töreni, gözcü kulesi, heybe ve ipucu motoru, tansiyon aralıkları ve üretim zinciri burada yeniden kurulmaz. Madde onları okur.

Boş günün köyde keyif olması SEV-01'dir (Parça C). Bu parça boş günü yalnız üretir.


---

## BÖLÜM 13: Acil Oyun Hataları ve Oynanış Kilitleri (Faz 0)


BUG-16 … BUG-25 gövdesi durur. Yeni maddeler BUG-26 … BUG-105. TEK ve DEN'de duran borç burada ikinci kez çözülmez.

### 13.1 Olay koşulu

- [x] **BUG-16:** (Kalfa) Olay ön koşul denetimi — bina, nüfus ve yaş grubu koşulu sağlanmayan olay tetiklenmez.
  - Ne: Gece kartı, metninde geçen bina köyde yoksa, istenen yaş grubu yoksa ya da nüfus eşiği tutmuyorsa oyuncuya hiç açılmaz. Seçici `OlayVerisi.kosullar` içindeki `bina_var`, `nufus_en_az`, `cocuk_var` ve `yas_grubu` anahtarlarını okur; koşul tutmayan kartın ağırlığı sıfır olur ve yerini koşulu tutan bir kart alır. Havuz boşsa o gece kart çıkmaz, köy fazı yine açılır.
  - Kabul: Ambar yokken ambar adı geçen kart 100 gecede 0 kez seçilir (`tests/unit/olay/on_kosul_test.gd`). Tarama listesinde her `data/olaylar/*.tres` için bir satır vardır; imzasız bina adı 1 doğrulama hatası verir. Tanınmayan koşul anahtarı sessizce yok sayılmaz, aynı test 1 hata yazar. Nüfus eşiği sayı olarak `.gd` dosyasına gömülmez; `nufus_en_az` yalnız `.tres` içindedir. Ek şart: `olay_on_kosulu.gd` `koy_sahnesi` import etmez. Ek şart: yarım kalmış kayıtta olay ertesi gece yeniden koşula bakar, zorla bitirilmez. Ek şart: aynı tohumla iki koşu aynı olay kimliğini seçer.
  - Bağımlılık: yok. Boyut: M.
  - Dosya: yeni `src/sistemler/olay_on_kosulu.gd`; olay seçiminde tek satır çağrı; `data/olaylar/*.tres` koşul alanları.
  - Asset: asset gerekmedi.


### 13.2 Fısıltı

- [x] **BUG-17:** (Kalfa) Fısıltı gazetesi yer bilgisi — pusula yalnız köyde var olan bir yeri anar.
  - Ne: Sabah pusulası oyuncuya "dün ambar tarafındaydı" demez; ambar yoksa o kalıp hiç basılmaz. `data/fisilti_gazetesi.json` içindeki sabit yer adı `{yer}` olur ve `{yer}` yalnız o gece ayakta duran binalardan seçilir. Uygun bina yoksa pusula o gece yazılmaz. Gece içinde yanan bina sabah seçilmez. Kişi adı `{yer}` yerine geçmez.
  - Kabul: Binasız köyde 30 gecede yer pusulası 0 satırdır. Ambar ayaktayken en az bir denemede pusula metninde "ambar" geçer. Olmayan bir bina adı 30 gecede 0 kez görünür (`tests/unit/kapi/fisilti_yer_test.gd`). Ek şart: ölü ya da köyden ayrılmış kişinin adı pusulada basılmaz; bu süzgeç SOY-45 ile aynı kayıttır, ikinci liste tutulmaz.
  - Bağımlılık: BUG-16. Boyut: S.
  - Dosya: `src/kapi/fisilti_gazetesi.gd` yer seçimine adaptör; `data/fisilti_gazetesi.json`.
  - Asset: asset gerekmedi.


### 13.3 Tehdit takvimi

- [x] **BUG-18:** (Kalfa) Tehdit alışma süresi — pusucu, çete, casus ve sabotaj ilk N gün gelmez.
  - Ne: Oyuncu ilk iki haftayı kapıyı ve köyü öğrenerek geçirir; pusucu, çete ve sabotaj o sürede kapıya düşmez. Süre `tehdit_baslangic_gunu` ayarındadır, öneri 14 gündür ve koda gömülmez. Moğol sayacı (HAR-02) bu sürede de artar. Sancak ulağı ve diplomatik heyet bu listenin dışındadır. Süre dolmadan debug ile çağrılan tehdit takvimi "doğal geliş" saymaz. Kayıt 14 günü geçmişse takvim geriye sarılmaz.
  - Kabul: 13. günde pusucu, çete ve sabotaj gelişi 0; aynı günde HAR-02 sayacı yine artar. Ulağın ilk gün gelişi engellenmez. 15. günde bu üç tehdidin ağırlığı taban değere döner (`tests/unit/sistemler/tehdit_takvimi_test.gd` dört iddiayı ayrı koşar). Ek şart: süre dolmadan debug ile çağrılan tehdit takvim sayacını artırmaz. Ek şart: 14 günü geçmiş eski kayıt açılınca `tehdit_baslangic_gunu` başa alınmaz.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: yeni `src/sistemler/tehdit_takvimi.gd`; `GuvenlikKafileDengesi` ve baskın tetikleyicilerine tek satır.
  - Asset: asset gerekmedi.


### 13.4 Sıra olayı

- [x] **BUG-19:** (Kalfa) Sıra olaylarında cinsiyet ve yaş uyumu — metin, sahnedeki gerçek modele göre yazılır.
  - Ne: Sırada bayılan kişi erkekse oyuncu "yaşlı bir kadın" cümlesini görmez. Beş sıra olayı (`sira_atlama`, `sira_bayilma`, `sira_kavga`, `sira_panik`, `sira_vazgecen`) seçilen modelin cinsiyetini ve yaş grubunu okur; metin `{kisi}` kalıbıdır ve kadın, adam, çocuk, yaşlı için ayrı çeviri anahtarı vardır. Modelde cinsiyet yoksa metin "biri" der. Çocuk modele yaşlı anahtarı verilmez.
  - Kabul: Beş olayın her birinde 100 denemede metindeki kişi sözcüğü modelin cinsiyeti ve yaşıyla birebir uyar (`tests/unit/kapi/sira_olayi_kisisi_test.gd`). Eksik cinsiyette "biri" 1 kez, yanlış cinsiyet 0 kez çıkar. Sabit "yaşlı bir kadın" satırı `data/sira_olaylari/` altında 0 kalır. Ek şart: sırada kimse yoksa olay başlamaz; bu kapı BUG-16 nüfus koşuludur. Ek şart: çocuk modelde yaşlı anahtarı 100 denemede 0 kez seçilir.
  - Bağımlılık: yok. Boyut: M.
  - Dosya: yeni `src/kapi/sira_olayi_kisisi.gd`; `data/sira_olaylari/*.tres` anahtar ekleri; `data/metin/metinler.csv` satır ekleme.
  - Asset: asset gerekmedi.


### 13.5 Açılış kaynak kilidi

- [x] **BUG-20:** (Kalfa) Sıra olayı seçimlerinin gerçek sonucu — yardım edilmeyen kişi ölebilir, sakatlanabilir, terk edebilir.
  - Ne: "Sıra yürüsün" seçilince yere düşen kişi yerinde kalmaz; `data/sira_olaylari/sonuclar.json` ölüm, sakatlık, sıradan ayrılma ya da toparlanmadan birini seçer ve gece raporu bunu tek satır yazar. Yardım düğmesi erzak ya da akçe ister; kaynak yetmezse düğme kapalı kalır. Ölüm duran cenaze akışını (KRI-05) bir kez çağırır. Sakat kalan kişi kabul edilirse düşük sağlıkla içeri girer; terk eden kişi köylü olmaz.
  - Kabul: "Sıra yürüsün" dört sonuçtan birini üretir ve raporda görünür. Yardım gerçek kaynak düşer. Ölüm KRI-05'i bir kez çağırır. Test: 1000 zar, oran sapması %3'ün altında. Kaynaksız köyde yardım düğmesi kapalı.
  - Bağımlılık: BUG-19. Boyut: M.
  - Dosya: yeni `src/kapi/sira_olayi_sonucu.gd`; olay sonucu uygulayan yere tek satır.
  - Asset: asset gerekmedi.


### 13.6 Kamera, meşale, kuyu

- [x] **BUG-21:** (Codex) Taş kilidi — başlangıç taş yatağı ve kurtarıcı kaynak.
  - Ne: Yeni oyunda köy kenarında kazılabilir bir taş yatağı durur; toplam 20 taş, işçi başı günde 4. Kaynak satırı "Taş yatağı: 20 taştan N kaldı" yazar. Taş bitmiş, taş ocağı yok ve ocağı o sabah kurmak mümkün değilse boş bir hücreye 10 taşlık yatak düşer; oyun bunu bir kez söyler ve oyun başına en çok 3 kez yapar. Oyuncu taşı bekletiyorsa yatak düşmez. Eski kayda yatak zorla eklenmez.
  - Kurallar:
    1. Yeni oyunda köy kenarında kazılabilir bir taş yatağı vardır. Toplam 20 taş, işçi başı günde 4.
    2. Kaynak bilgisinde "Taş yatağı: 20 taştan N kaldı" yazar. N, kalan taştır.
    3. Taş 0, taş ocağı yok ve taş ocağı o an kurulamıyorsa sabaha geçerken boş bir hücreye 10 taşlık yatak düşer. Oyuna tek satır bilgi verilir. Oyun başına en çok 3 kez.
    4. Kurtarıcı yatak, oyuncu taşı işçisiz bekletiyorsa düşmez. Düşme şartı "kurulamıyor"dur, "kurmadı" değildir.
    5. Taş ocağı (EKO-05) durur. Bu madde ikinci ocak türü açmaz.
  - Uç durumlar: yatak bitince bilgi "kaldı: 0" der ve kazı düğmesi kapanır. 3 kurtarıcıdan sonra yeni yatak düşmez. Haritada boş hücre yoksa düşme o sabah ertelenir, oyun çökmez. Eski kayıtta yatak yoktur, zorla eklenmez.
  - Kabul: hızarhane + 2 çadır + tarla açılışından sonra 10 gün içinde taş ocağı kurulabilir (`DUMAN_TESTI_ACILIS` ile birlikte BUG-22). Kurtarıcı sayacı 3'te durur. Bilgi satırı kalan taşla birebir.
  - Bağımlılık: yok. Boyut: M.
  - Dosya: yeni `src/koy/tas_yatagi.gd`, `src/koy/kaynak_kurtarici.gd`; `KoyYonetimi` sabah akışına tek satır; kayıtta optional alan.
  - Asset: taş yatağı modeli — yer tutucu gri `BoxMesh` öbeği; envantere `BUG21-TASYATAGI`.

### 13.7 Gece ve kayıt kilidi

- [x] **BUG-22:** (testx) Açılış ekonomisi dengesi — başlangıç stoku ve ilk yapı maliyetleri kilitlenmez.
  - Ne: Yeni oyunda ilk beş yapı sırası taş ve odun yüzünden kilitlenmez. `baslangic_kaynak` ve `binalar.json` maliyetleri tek tabloda yeniden yazılır; sayılar koda gömülmez ve eski kaydın stoku değişmez. Odun sıfırının ayrı bir zinciri bu maddede açılmaz.
  - Kurallar:
    1. `baslangic_kaynak` ve `binalar.json` maliyetleri tek tabloda yeniden yazılır. Maliyet kodun içine gömülmez.
    2. Tablo yeni oyuna uygulanır. Eski kayıtın stoku değiştirilmez.
    3. Otomatik oyuncu beş farklı açılış sırasıyla 20 gece kilitlenmeden geçer. Kilit, "taş ocağı kurulamıyor ve kurtarıcı da bitti" halidir.
    4. Yeni kaynak türü eklenmez. Odun, taş, erzak ve akçe duran hesapta kalır.
  - Uç durumlar: ACL-01 bir evle başladığı için tabloda o evin maliyeti tekrar tahsil edilmez. Beş sıradan biri kilitlenirse madde kapanmaz. Debug enjektörüyle doldurulan stok, duman testinin yerine geçmez.
  - Kabul: `DUMAN_TESTI_ACILIS=1` şu beş sıranın beşini de 20 gece kilitlenmeden geçirir. (1) hızarhane, iki çadır, tarla, sonra taş ocağı. (2) önce tarla, sonra yatak, sonra ocak. (3) ilk beş gece yalnız başlangıç evi, sonra ocak. (4) çadırlar, odun yapısından önce. (5) taş yatağı 20 taşı verir vermez ocak. Eski kayıt yüklemesinde başlangıç stoku değişmez.
  - Bağımlılık: BUG-21, ACL-01. Boyut: M.
  - Dosya: `data/ayarlar/koy.tres`, `data/koy/binalar.json`; yeni test senaryosu `tests/oto/acilis_denge_kontrol.tscn`.
  - Asset: asset gerekmedi.

### 13.8 Kapı çift işlem

- [x] **BUG-23:** (Codex) Çiftçi tarla üstünde çalışır — iş noktası tarla alanının içinde.
  - Ne: Çalışma saatinde çiftçi tarla dikdörtgeninin içinde durur. Birden çok çiftçi aynı noktaya yığılmaz; noktalar tarlanın içinde dağılır. Tarla yoksa kişi dünya orijinine ışınlanmaz ve iş iptali uyarıdır, betik hatası değildir. Gece uyku noktası tarla olmaz.
  - Kurallar:
    1. Çalışma saatinde iş noktası tarla dikdörtgeninin içindedir.
    2. ANI-13 gezinme ağı tarla içini yürünebilir tutar. Yeni navigasyon ağı yazılmaz.
    3. Birden çok çiftçi aynı noktaya yığılmaz. Noktalar dikdörtgenin içinde dağıtılır.
    4. Tarla yoksa çiftçi dünya orijinine ışınlanmaz. Eski iş noktası kalır.
  - Uç durumlar: tarla yeni kurulmuş ve ağ henüz güncellenmemişse kişi tarla kenarında bir kare bekler, içine düşene kadar "dışarıda" sayılır ve test bunu hata saymaz, en geç bir kare sonra içeridedir. Gece uyku noktası tarla değildir (YSM-03). Hasat şenliği (MEV-08) bu noktayı değiştirmez.
  - Kabul: 20 denemede çalışma saatinde tarla dışında 0 kişi vardır; iki çiftçi aynı koordinatta 0 kez durur (`tests/unit/koy/tarla_is_noktalari_test.gd`). Ek şart: tarla yokken atama betik hatası yazmaz ve kişiyi dünya orijinine götürmez.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: yeni `src/koy/tarla_is_noktalari.gd`; ANI-13 ağına tek işaret.
  - Asset: asset gerekmedi.

### 13.9 Bilinen borç sınırı

- [x] **BUG-24:** (Codex) Kamera orta tuşla sürükleme — strateji oyunlarındaki gibi harita kaydırma.
  - Ne: Köy ekranında tekerlek yakınlaştırır, orta tuş haritayı kaydırır. Kaydırma hızı denge dosyasındadır; piksel sabiti koda yazılmaz. Kamera harita kenarını aşmaz. Takip kamerası sürükleme başlayınca bırakılır. Duraklat menüsü ya da bir panel açıkken orta tuş dünyayı oynatmaz. Kapı sahnesinde bu kaydırma çalışmaz.
  - Kurallar:
    1. Kaydırma yalnız köy ekranındadır. Kapı sahnesi kaymaz.
    2. Kamera harita sınırının dışına çıkmaz.
    3. ANI-14 takip kamerası sürükleme başlayınca bırakılır. Bırakılınca takip kendiliğinden geri gelmez. Oyuncu kişiye yeniden tıklarsa takip döner.
    4. Ayar menüsünde eksen ters çevrilir. Varsayılan, elin gittiği yöne haritanın gelmesidir.
    5. Orta tuş bir panelin üstündeyse dünya kaymaz.
  - Uç durumlar: düğme bırakılınca son karede fazladan kayma olmaz. Düşük kare hızında sıçrama, son iki imleç konumuyla sınırlanır. Kapıya geçiş kamerayı kapı düzenine alır, köy kaydırması orada sürmez.
  - Kabul: Sınır dışında kamera 0 kare kalır. Panel ya da duraklat menüsü üstünde orta tuşla dünya kayması 0'dır. Ters ayar açıkken yön ters, kapalıyken düzdür. Takip, sürüklemede 1 kare içinde biter (`tests/unit/dunya/kamera_surukleme_test.gd`). Ek şart: kaydırma hızı `data/ayarlar/denge.json` içindedir; `.gd` içinde bu işe ait piksel sabiti 0'dır.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: yeni `src/dunya/kamera_surukleme.gd`; `koy_yonetim_sahnesi.gd` tek bağlantı.
  - Asset: asset gerekmedi.

### 13.10 Kapanış

- [x] **BUG-25:** (Kalfa) Kapı meşaleleri ve kuyu modeli onarımı.
  - Ne: Kapıdaki iki meşalenin alev soketi ile ışık noktası aynı yerdedir. Kuyu tabanı zemine oturur ve tepesi bir köylünün boyunu geçmez. Yeni heykel üretilmez; duran modelin konumu, ölçeği ve malzemesi düzeltilir. Köyde ikinci bir meşale sınıfı açılmaz. Kuyu suyu kirletme hesabı değişmez.
  - Kurallar:
    1. İki meşalenin alev soketi ile ışık noktası aynı konumdadır.
    2. Kuyu tabanı zemin düzlemindedir. Yüksekliği bir köylü modelinin boyunu aşmaz.
    3. Yeni model gelene kadar duran modelin konum, ölçek ve malzemesi ayarlanır. Model üretilmez.
    4. Işık sistemi ve gece görüşü (MEV-09) yeniden yazılmaz. Bu madde yalnız duran iki meşale ile kuyunun dönüşünü düzeltir.
  - Uç durumlar: düşük grafik profilinde (BUG-10) ışık kapanırsa soket yine alevin yerindedir, ışık yok diye meşale kaymaz. Bir meşale düzeltilip öteki eski ölçekte kalamaz. Kuyu su kirletme hesabını (KRI-04) değiştirmez.
  - Kabul: iki meşalede soket ile ışık farkı 0. Kuyu tabanı zeminle kesişir, tepe yüksekliği köylü boyunun altındadır. Görünür sahnede ölçülür.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: kapı ve kuyu sahne ayar dosyaları.
  - Asset: gerçek model gerekirse envantere `BUG25-MESALE`, `BUG25-KUYU`. Yer tutucu: duran modelin düzeltilmiş hali.

---

ACL-01 … ACL-06 gövdesi durur. Yeni maddeler ACL-07 … ACL-86. İkinci hane ekonomisi ve kalp yoktur.


---

## BÖLÜM 14: Açılış, Hane ve Köyün Kuruluşu (Faz 1)

### 14.1 Köyden açılış

- [x] **ACL-01:** (Kalfa) Oyun köy ekranından başlar — tek ev, muhafız ve eşi.
  - Ne: Yeni oyunda haritada bir hazır ev, muhafız ve eşi vardır; yatak 4'tür ve evin maliyeti yeniden kesilmez. Kapı ilk gün kapalıdır, HUD bunu yazar, kuyruk kurulmaz. `ana.gd` yalnız yeni oyunu bu sahneye yollar. Eski kayıt kaldığı sahneye döner. Eş kimliği kayıtta yoksa kuruluştan türetilir, oyun çökmez.
  - Kurallar:
    1. Yeni oyunda haritada 1 hazır ev vardır. Yatak 4. Evin maliyeti başlangıçtan tekrar kesilmez (BUG-22).
    2. Kapı ilk gün kapalıdır. HUD "Kapı kapalı" yazar. Kuyruk o gün kurulmaz.
    3. Muhafız ve eş köyde durur. İkisi de yatak sayısına dahildir.
    4. `ana.gd` yalnız yeni oyunu bu sahneye yönlendirir. Eski kayıt kaldığı yere gider, eve ve eşe zorla çevrilmez.
  - Uç durumlar: "devam" eski bir kapı gecesini açıyorsa köy açılışı araya girmez. Ev yıkılırsa yatak 0 olur, ikinci bedava ev doğmaz. Eş modeli gelene kadar yer tutucu köylü, renk farkıyla durur. İkinci oynanabilir gövde yazılmaz.
  - Kabul: Yeni oyunda köy ekranı açılır, ev 1, kişi 2, yatak 4, HUD "Kapı kapalı" yazar (`tests/unit/sistemler/acilis_senaryosu_test.gd`). Eski kayıt aynı gün ve aynı sahnede açılır. Ek şart: eş kimliği boş kayıttan türetilir, çökme olmaz. Ek şart: ev içi sahne ve ikinci harita bu maddede açılmaz; yeni ses dosyası eklenmez. Ek şart: aynı tohumla iki yeni oyun aynı evi ve aynı iki kişiyi kurar.
  - Bağımlılık: yok. Boyut: L (`ana.gd` çekirdek, tek yönlendirme).
  - Dosya: yeni `src/sistemler/acilis_senaryosu.gd`; `ana.gd` tek yönlendirme; `data/acilis.json`.
  - Asset: envantere `ACL01-MUHAFIZ`, `ACL01-ES`. Yer tutucu: duran köylü modeli + renk farkı.


### 14.2 Eş ve meslek

- [/] **ACL-02:** (testx) Eş — oynanabilir ama sıradan köylü değil.
  - Ne: Eş köylü listesinde ayrı satırdadır; kışla, kervan, sürgün ve divan düğmeleri onda kapalıdır ve kapı kuyruğuna yazılmaz. Meslek yalnız `data/hane_esi.json` listesinden seçilir: dokumacı, ebe, fırıncı, bostancı, sütçü, yün eğirici; okuryazar geçmişte kâtiplik açılır. Demirci, taşçı, oduncu, asker ve madenci listede yoktur. Meslek değişince bir gün verimsiz çalışır. Ölümde yeni son yazılmaz, duran epilog ağır yas olarak açılır.
  - Kurallar:
    1. Eş köylü listesinde ayrı satırdadır. Kışla, kervan, sürgün ve divan düğmeleri onda kapalıdır.
    2. Meslek yalnız `data/hane_esi.json` listesinden seçilir: dokumacı/keçeci, ebe/şifacı, fırıncı/aşçı, bostancı, sütçü/yoğurtçu, yün eğirici. Okuryazar geçmişte (ACL-06 medrese) kâtiplik açılır.
    3. Demirci, taşçı, oduncu, asker ve madenci listede yoktur. Liste dışı bir kimlik reddedilir.
    4. Meslek değişince 1 gün verimsiz çalışır. Arabuluculuk her meslekte açıktır ve morale yazılır.
    5. Ölüm, duran epilog dalını ağır yas olarak açar (SYS-20 / ODA-10). Yeni son yazılmaz.
  - Uç durumlar: eş ölünce akşam sohbeti (ACL-03) bir daha açılmaz. Meslek günü dolmadan ikinci değişiklik birikir, gün 1'de kalır, 2 olmaz. Debug konsolundan demirci yazılırsa kayıt reddeder. Eşin sağlığı ve morali köylü barıdır (YSM-01), ayrı bir eş barı açılmaz.
  - Kabul: Listede altı meslek ve okuryazar geçmişte kâtiplik atanır; demirci ve asker 0 kez kabul edilir (`tests/unit/koy/hane_esi_test.gd`). Eşte kışla, kervan, sürgün ve divan düğmesi kapalıdır. Ek şart: eşin kimliği kapı kuyruğunda 0 kez görünür. Ek şart: kalp alanı yazılmaz. Ek şart: Eş sürgün yoluna yazılırsa hane uyarısı çıkar ve köy kaydı silinmez.
  - Bağımlılık: ACL-01. Boyut: M.
  - Dosya: yeni `src/koy/hane_esi.gd`; köylü kartına adaptör.
  - Asset: asset gerekmedi (ACL-01 modeli).

### 14.3 Akşam

- [ ] **ACL-03:** Akşam sohbeti — eş günün kararlarını konuşur.
  - Ne: Ağır bir kapı kararından sonra, gece raporundan önce eş bir kez konuşur. Konu ağırlığı ve meslek cümlesi DYL-07'den okunur; ikinci sohbet motoru yazılmaz. Ağır karar yoksa gündelik satır gelir ya da sohbet hiç açılmaz. Sohbet atlanabilir ve atlamak barı değiştirmez. Meclis gecesinde bu sohbet açılmaz. Eş ölmüşse tetik susar.
  - Kurallar:
    1. Bu madde tetiği ve kapanışı tanımlar. Konu ağırlığı, meslek varyantı ve eş hafızası DYL-07'den okunur. İkinci sohbet motoru yazılmaz.
    2. Rapor öncesi en çok 1 sohbet. Ağır karar yoksa DYL-07'nin gündelik satırı gelir veya sohbet olmaz. Her gece zorunlu konuşma yoktur.
    3. Sohbet atlanabilir. Atlamanın cezası yoktur.
    4. Eşin tepkisi duran muhafız terazisine ve eşin moraline yazılır. Yeni terazi açılmaz.
  - Uç durumlar: eş ölüyse tetik 0. Kapı hiç açılmadıysa (ACL-01 ilk gün) konuşulacak kapı kararı yoktur, sohbet olmaz. DYL-07 dosyası henüz yoksa tetik susar, yer tutucu tek satır uydurmaz.
  - Kabul: Ağır kararlı gecede rapor öncesi sohbet 1 kez açılır; aynı kararla ertesi gece 0 kez açılır (`tests/unit/koy/aksam_sohbeti_test.gd`). Atlama barı değiştirmez. Eş ölmüşken tetik 0'dır. Ek şart: meclis gecesinde sohbet 0'dır. Ek şart: sohbet metni kalp anahtarı yazmaz ve yeni ses dosyası eklemez.
  - Bağımlılık: ACL-02, DYL-07. Boyut: M.
  - Dosya: yeni `src/koy/aksam_sohbeti.gd`; gece raporu öncesine tek çağrı. Metin `data/soz/aksam_konulari.json` (DYL-07).
  - Asset: asset gerekmedi. Ocak görseli DYL-07 envanterindedir.


### 14.4 Ulak ve ilk aile

- [x] **ACL-04:** (Kalfa) Kapıyı açan olay — ilk gün akşamı: Sancak Beyi'nin ulağı ve kapıdaki ilk aile.
  - Ne: İlk gün akşamı Sancak Beyi'nin ulağı beratı okur ve gider; ardından kapıda ilk aile durur. Öğretici selam, konu, heybe ve kararı gösterir, atlanabilir. Ulak bölümü 60 saniyeyi geçmez. Ulak köylü olmaz, nüfus artmaz. Ertesi sabah kapı açılır. Aynı kayıtta ulak ikinci kez gelmez.
  - Kurallar:
    1. İlk gün akşamı ulak gelir. Berat: muhafız uç kapısını tutacak, "bu yurt sığınana açıktır". Bey, HAR-04'teki sancak beyidir. Yeni bey yazılmaz.
    2. Ulak gidince ilk aile kapıdadır. İlk sorgu öğreticidir: selam, konu, heybe, karar. Eş kapının yanında bir cümle söyler.
    3. Sahne atlanamaz. Öğretici adımlar atlanabilir. Ulak bölümü 60 saniyeyi geçmez.
    4. Bu ulağı BUG-18 tehdit saymaz.
    5. Ertesi sabah kapı açılır. İlk günden önce kuyruk yoktur (ACL-01).
  - Uç durumlar: kayıt ilk akşamdan sonra açılırsa ulak bir daha gelmez. Öğretici atlanırsa aile yine kapıdadır, karar istenmeden gece bitmez. Söz motoru (Parça B) hazır değilse öğretici kısa ve sabit bir sahne kullanır. Bu sahne `gecis` tablosunda geçici diye işaretlenir, kalıcı ikinci diyalog yolu olmaz.
  - Kabul: Yeni oyunda ilk akşam ulak 60 saniyenin altında biter, ardından aile kapıdadır, ertesi sabah HUD kapının açık olduğunu yazar (`tests/unit/sistemler/kapi_acilis_olayi_test.gd`). Aynı kayıtta ulak ikinci kez 0 gelir. Ek şart: ulak kabul edilmez, nüfus artışı 0'dır. Ek şart: tehdit takvimi bu ulağı kesmez.
  - Bağımlılık: ACL-01, BUG-18. Boyut: M.
  - Dosya: yeni `src/sistemler/kapi_acilis_olayi.gd`; `data/olaylar/kapi_acilisi.tres`.
  - Asset: ara sahne arka planı envantere `ACL04-ARASAHNE`. Yer tutucu: düz renk + metin.


### 14.5 Yatak

- [x] **ACL-05:** (testx) Barınak kapasitesi kabul sınırı — yer yokken kabul edileni oyuncu bilir.
  - Ne: Karar panelinde "Yatak: dolu/toplam" yazar; muhafız ve eş bu sayıya dahildir. Yatak yetmezse oyuncu "Yatacak yer yok; açıkta kalır" uyarısını görür ve kabul düğmesi açık kalır. Açıkta kalan kişi kayda yazılır. Kapasite sayısı koda gömülmez. Yatak akçe üretmez.
  - Kurallar:
    1. Karar panelinde "Yatak: dolu/toplam" görünür. Muhafız ve eş sayılır.
    2. Yatak yetmezse uyarı: "Yatacak yer yok; açıkta kalır." Kabul kapanmaz.
    3. Açıkta kalan kişi kayda yazılır. YSM-03 onun uykusunu yarım düşürür. Bu madde ikinci uyku hesabı açmaz.
    4. Aile (KAP-17) yatak kontrolünü kişi sayısıyla yapar, bir yataklık kabul gibi görünmez.
  - Uç durumlar: tam dolu köyde kabul, açıkta sayısını 1 artırır. Ret, sayıyı artırmaz. Gece içinde ev bitince açıkta kalan otomatik yatağa geçmez, sabah yerleşir. Yatak 0 iken panel "0/0" der, çökmez.
  - Kabul: Dolu köyde kabul, açıkta sayısını 1 artırır; ret 0 artırır. Dört kişilik aile ve 2 yatak varken uyarı dördü için görünür (`tests/unit/kapi/barinak_uyarisi_test.gd`). Ek şart: kapasite `.gd` sabiti değildir, bina verisinden okunur. Ek şart: yatak satırı akçe yazmaz.
  - Bağımlılık: ACL-01. Boyut: S.
  - Dosya: yeni `src/kapi/barinak_uyarisi.gd`; karar paneline tek satır.
  - Asset: asset gerekmedi.

### 14.6 Geçmiş

- [x] **ACL-06:** (Kalfa) Muhafızın geçmişi — açılışta seçilen arka plan.
  - Ne: Yeni oyunda oyuncu dört geçmişten birini seçer: eski levent, Ahi çırağı, medrese talebesi, çoban oğlu. Seçim kayıtta tek alandır ve oyun başladıktan sonra değişmez. Her geçmiş bir yapı bilgisi açar; bina bedava kurulmaz. Geçmiş zar tabanını değiştirmez ve eş meslek listesine girmez. Eski kayıtta alan yoksa "seçilmedi" kalır, rastgele geçmiş atanmaz.
  - Kurallar:
    1. Yeni oyunda 4 geçmişten biri seçilir: eski levent, Ahi çırağı, medrese talebesi, çoban oğlu. Kayıtta tek alan.
    2. Her geçmiş bir yapı bilgisi açar (YAP-02). Bina bedava kurulmaz.
    3. Diyaloğa açtığı seçenek her zaman avantajlı değildir. Karşıdakinin statüsü yüksekse tansiyon artabilir. Seçenek metni Parça B'dedir (DIY-15). Bu madde yalnız kimliği saklar.
    4. Oyun başladıktan sonra geçmiş değişmez.
    5. Medrese geçmişi dil listesine bir satır yazar (DYL-06 okur). Bu madde tercüman motoru kurmaz.
  - Uç durumlar: seçim yapılmadan başlanırsa kayıt açılmaz. Eski kayıtta alan yoksa "seçilmedi" durur, rastgele geçmiş atanmaz. Aynı geçmiş iki yapı birden açmaz.
  - Kabul: Dört geçmişin her biri bir ve yalnız bir yapı kimliği açar. Kayıt yeniden yüklenince geçmiş aynıdır (`tests/unit/sistemler/muhafiz_gecmisi_test.gd`). İkinci bir geçmiş alanı yazılamaz. Ek şart: geçmiş zar tabanını değiştirmez. Ek şart: geçmiş eş meslek listesinde 0 kez görünür. Ek şart: kalp alanı ve yeni ses dosyası yazılmaz.
  - Bağımlılık: ACL-01. Boyut: M.
  - Dosya: yeni `src/sistemler/muhafiz_gecmisi.gd`, `data/muhafiz_gecmisleri.json`.
  - Asset: asset gerekmedi.

KAP-16 … KAP-19 gövdesi durur. Yeni maddeler KAP-20 … KAP-99. İkinci kapı motoru yok.


---

## BÖLÜM 15: Kapı Akışı ve Nüfus Gerçekçiliği (Faz 1)

### 15.1 Gelen sayısı

- [/] **KAP-16:** (testx) Değişken gelen sayısı, boş gün ve sayfadaki bar eşiği.
  - Ne: Her gece kapıya gelen kişi sayısı sabit 3 olmaktan çıkar; köyün refahı, güvenliği, yatağı, mevsimi ve dünya olayı `data/gelen_akisi.json` üzerinden sayıyı belirler. 28 günde en az 4 gece kapı açık kalır ama kimse gelmez. Perde 2, perde 1 formülünü kullanmaz; `perde2_gece_basina_gelen` okunur. Aynı kadro kimliği bir gecede bir kez gelir. Ayrılmış ya da ölü kimlik kuyruğa yazılmaz. Tavan dolunca fazla kişi ertesi güne kalmaz. Fadime sayfasındaki "Moral < 6" gibi bar cümlesi ya canlı barla değerlendirilir ya sayfadan silinir.
  - Kurallar:
    1. `gece_basina_gelen = 3` sabiti kalkar. Günlük sayı köy çekiciliği (refah, güvenlik, yatak), mevsim ve dünya olayından gelir. Mevsim motoru (MEV) okunur, yeniden yazılmaz. Kışın sayı düşer, çünkü duran mevsim çarpanı okunur.
    2. 28 günde en az 4 boş gün vardır. Alt ve üst sınır `data/gelen_akisi.json` içindedir. Gözcü (HAR-06/13) boş günü bildirir. Gözcü kulesi kurulmaz.
    3. CHR `Spawn_Koşulu` içindeki bar karşılaştırması (`Moral < 6`, Güvenlik, Erzak) iki yoldan biriyle biter. Ya gelen akışı o barı canlı değerle değerlendirir ya cümle sayfadan silinir.
    4. `chr_parser.py --check`, bar karşılaştırması durup da değerlendirilmeyen sayfayı hata sayar. Bugün parser yalnız `Tur > N` alıyor, geri kalanı metinde ölü kalıyor. Örnek: CHR_017 Fadime, "Tur > 3 ve Moral < 6". Ya tur 4'ten sonra moral 6'nın altındayken gelir ya moral cümlesi silinir ve tur 4'ten sonra moralden bağımsız gelir.
    5. Boş gün, oyuncunun kapıyı kapatması değildir. Kapı açıktır, gelen yoktur. O günün ateş başı keyfi SEV-01'dir. Bu madde onu üretmez.
  - Uç durumlar: bar eşiği yeni bir moral sistemi açmaz, duran barı okur. Tehdit takvimi (BUG-18) bu dağılımın üstündedir, ilk 14 günde tehdit yine 0'dır. Heyet (HAR-12) günlük sayının içine gömülmez, kuyruk başında kalır. Eski kayıtın o geceki kuyruğu yarıda silinmez.
  - Kabul: 100 tohumlu 28 gün koşusunda boş gün en az 4'tür ve gelen sayısı tablo aralığındadır (`tests/unit/kapi/gelen_akisi_test.gd`). Fadime sayfasında moral cümlesi duruyorsa moral 6 ve üstündeyken geliş 0'dır. Değerlendirilmeyen bar cümlesi `chr_parser.py --check` ile 1 hata verir. Ek şart: `.gd` içinde `gece_basina_gelen = 3` ataması 0'dır. Ek şart: aynı kadro kimliği bir gecede 0 kez tekrarlar; ayrılmış kimlik kuyrukta 0'dır. Ek şart: tavan 3 iken kuyruk 3'ü geçmez ve fazla kişi ertesi güne yazılmaz. Ek şart: aynı gece kapıdan çıkmış kişi kuyruğa geri yazılmaz. Ek şart: karar veya sohbet bitmeden kuyruk ilerlemez; kuyruk boşsa faz köye geçer. Ek şart: aynı tohumla iki koşunun ilk altı gecesinin kimlik sırası aynıdır. Ek şart: duraklatıp devam edince açık kişinin kimliği değişmez.
  - Bağımlılık: BUG-18. Boyut: M.
  - Dosya: yeni `src/kapi/gelen_akisi.gd`, `data/gelen_akisi.json`; kuyruk kurulumuna tek satır; `tools/chr_parser.py` bar cümlesini ya okur ya reddeder.
  - Asset: asset gerekmedi.

### 15.2 Kuyruk

- [x] **KAP-17:** (Kalfa) Aileler birlikte gelir.
  - Ne: Kapıya karı, koca, çocuk ve yaşlıdan kurulu bir kafile tek sorguyla gelir; sorgu aile reisiyledir. Varsayılan karar herkese uygulanır. "Yalnız çocukları al" ayrı bir düğmedir ve çocuksuz kafilede görünmez. Bölme, vicdan terazisine ve dedikodu kaydına bir satır yazar; yeni dedikodu motoru açılmaz. Reisin kimliği düşünce kişiler kuyruğa saçılmaz, kafile tek karar olarak kalır. Dört kişilik kabul dört köylü ekler.
  - Kurallar:
    1. Aile karı-koca, çocuk ve yaşlıdan kurulur. Sorgu aile reisiyle yapılır.
    2. Varsayılan karar ailenin tamamına uygulanır. "Yalnız çocukları al" bölme seçeneği ayrı bir düğmedir.
    3. Bölme, vicdan terazisine ve dedikoduya yazılır. Dedikodu motoru Parça B'dedir (DIY-13). Bu madde yeni dedikodu sistemi açmaz, aynı kayda bir satır bırakır.
    4. Yatak kontrolü (ACL-05) kişi sayısıyladır.
    5. Çocuk ve yaşlı modeli yer tutucudur. Üretim zinciri değişmez.
  - Uç durumlar: tek kişilik "aile" sıradan gelendir, bölme düğmesi görünmez. Çocuksuz ailede "yalnız çocukları al" yoktur. Bölünüp dışarıda kalanlar köylü olmaz ve aynı gece ikinci kez kuyruğa girmez. Dört kişilik kabul, dört köylü ekler.
  - Kabul: Dört kişilik kabul dört köylü ekler ve yatak kontrolü dört kişi sayar (`tests/unit/kapi/aile_kafilesi_test.gd`). Çocuksuz ailede bölme düğmesi 0 kez görünür. Bölme, dedikodu kaydına 1 satır yazar. Ek şart: reisin kimliği düşünce kafile tek karar olarak kalır, kişiler ayrı kuyruk satırına saçılmaz.
  - Bağımlılık: ACL-05. Boyut: L.
  - Dosya: yeni `src/kapi/aile_kafilesi.gd`; `Gelen` için optional aile alanı; köylü üretimine adaptör.
  - Asset: çocuk ve yaşlı modelleri envantere `KAP17-COCUK`, `KAP17-YASLI`. Yer tutucu: duran köylü, ölçek ve renk farkı.

### 15.3 Soru ve heybe

- [ ] **KAP-18:** Yetimler ve savaştan kaçan çocuklar.
  - Ne: Dünya savaş olayından sonra kapıya çocuk kafilesi düşer; olay yoksa bu kafile 28 günde hiç gelmez. Kabul edilen çocuk bir haneye ya da eşe emanet edilir. Hane yoksa ACL-05 uyarısı çıkar ve çocuk açıkta kalır, silinmez. Çocuk çalışmaz. 28. günde yaş grubu gence döner ve çırak düğmesi açılır. Model KAP-17 çocuk modelidir.
  - Kurallar:
    1. Bu kafile, dünya savaş olayından sonra açılır (DNY-01). Olay yoksa ağırlık 0.
    2. Kabul edilen çocuk bir haneye veya eşe emanet edilir. Eş yoksa ve hane yoksa kabul uyarısı ACL-05 ile aynıdır, çocuk açıkta kalır.
    3. Çocuk çalışmaz. Bu, duran yaş kuralıdır (UZM-08). Yeni iş yasağı yazılmaz.
    4. Belli günden sonra yaş grubu gence döner ve çırak alınabilir (UZM-04). Yeni seviye sistemi açılmaz.
    5. Model KAP-17 çocuk modelidir. İkinci çocuk modeli istenmez.
  - Uç durumlar: emanet edilen hane yok olursa çocuk açıkta sayısına düşer, silinmez. 28 gün dolmadan genç olmaz. Savaş olayı bitmiş bir kayıtta kafile bir daha zorla gelmez, ağırlık normale döner.
  - Kabul: Savaş olayı yokken 28 günde bu kafile 0 kez gelir (`tests/unit/koy/yetim_bakimi_test.gd`). Olay varken kabul, çocuğu bir haneye bağlar ve çalıştığı gün 0'dır. 28. günde yaş grubu gençtir ve çırak düğmesi açılır.
  - Bağımlılık: KAP-17, DNY-01. Boyut: M.
  - Dosya: yeni `src/koy/yetim_bakimi.gd`; `Koylu.yas_grubu` geçişine adaptör.
  - Asset: KAP-17 çocuk modeli. Yeni satır yok.

- [/] **KAP-39:** (testx) Heybe açıkken soru seçilmez
  - Ne: Heybe paneli açıkken oyuncu yeni bir soru seçemez ve soru hakkı düşmez. Panel kapanınca kalan hak aynı sayıda durur. Karar düğmesi de bu sırada etki yazmaz.
  - Kabul: Heybe açıkken soru düğmesine basmak hak sayısını değiştirmez ve yeni dal açmaz (`tests/unit/kapi/heybe_kilit_test.gd`). Panel kapanınca hak, açılmadan önceki değerle aynıdır. Ek şart: Heybe açıkken sorgu eylemi seçilmez; panel kapanınca aynı düğme durur.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `src/arayuz/kapi_ekrani.gd`, `src/arayuz/heybe_paneli.gd`
  - Asset: asset gerekmedi.

### 15.4 Karar

- [x] **KAP-19:** (Kalfa) Köy nüfusu kompozisyonu — çocuksuz köyde çocuk olayı yok.
  - Ne: Gece kartı havuzu yaşayan hane sayısına göre üç listeden seçilir: 5 ve altı, 6–12, 13 ve üstü. Çocuk olayı `cocuk_var` ister; düğün olayı en az iki yetişkin hane ister. Üç kişilik köyde bu iki kart 30 gecede hiç açılmaz. Katman atlamak için nüfus şişirilmez. Seçim BUG-16 denetçisinden geçer; ikinci seçici yazılmaz.
  - Kurallar:
    1. Havuz hane sayısına göre üç katmandır: 5 ve altı, 6–12, 13 ve üstü. Listeler veri dosyasındadır.
    2. Katman seçimi BUG-16 denetçisinden geçer. İkinci olay seçici yazılmaz.
    3. Çocuk olayı `cocuk_var` ister. Düğün olayı en az iki yetişkin hane ister. Bu madde yeni bir düğün töreni veya mini oyun yazmaz. Duran olay varsa yalnız kapısı bağlanır.
    4. Katman atlamak için nüfus şişirilmez. Sayım, yaşayan hanedir.
  - Uç durumlar: 3 kişilik köyde düğün ve çocuk olayı 0. 13 haneye çıkan köy ertesi gece üst katmanı görür, aynı gece yarım olay katman değiştirmez. Nüfus düşünce üst katman olayı yarıda kesilmez, yeni seçim alt katmandan yapılır.
  - Kabul: Üç kişilik köyde 30 gecede düğün ve çocuk olayı 0 kez seçilir (`tests/unit/olay/nufus_katmani_test.gd`). On üç hanelik köyde üst katman listesinden en az bir seçim vardır. Sayım yaşayan hanedir.
  - Bağımlılık: BUG-16, KAP-17. Boyut: S.
  - Dosya: `data/olaylar` koşulları. Seçici BUG-16 dosyasıdır.
  - Asset: asset gerekmedi.

---

- [/] **KAP-45:** (testx) Karar bir kez uygulanır
  - Ne: Oyuncu kabul ya da ret düğmesine art arda bassa bile gece sonu etkisi bir kez yazılır. Bar kırılınca `oturum_bitti` bir kez gider; ikinci kırılma ikinci sinyal üretmez. Heybe açıkken bu düğmeler de etki yazmaz.
  - Kabul: Aynı karara iki tıkta bar deltası 1'dir (`tests/unit/kapi/karar_bir_kez_test.gd`). Bar sıfıra inince `oturum_bitti` 1 kez yayılır.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `src/arayuz/kapi_ekrani.gd`
  - Asset: asset gerekmedi.

- [/] **KAP-48:** (testx) Rüşvet hakkı ayardadır
  - Ne: Kapı, rüşvet düğmesini `oyun_ayarlari.gd` içindeki `rusvet_hakki` değerine göre kapatır. Alan bugün yalnız tanımlı, kapı onu okumuyor. Ayar 1 iken ikinci rüşvet denemesi düğmeyi kapalı bırakır. Sayı kapi ekranının içine gömülmez.
  - Kabul: `rusvet_hakki` 1 iken ikinci rüşvet denemesinde düğme kapalıdır ve gece sonuna ikinci rüşvet yazılmaz (`tests/unit/kapi/rusvet_hakki_test.gd`). Alan `src/veri/oyun_ayarlari.gd` dışında ikinci bir 3 sabiti olarak durmaz.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `src/arayuz/kapi_ekrani.gd`; okuma `src/veri/oyun_ayarlari.gd`.
  - Asset: asset gerekmedi.

ARY-01 … ARY-05 gövdesi durur. Yeni maddeler ARY-06 … ARY-85. Dosya dosya iş GRV-31 ve sonrasındadır; burada ikinci palet yok.


---

## BÖLÜM 16: Söz Sistemi — Yeni Diyalog Motoru (Faz 2)


Site şu an tek sahne: Yusuf, konu merkezli yüzleşme. Oyna, Ağaç, İnceleme, Şablon var. Güven, söz kesme, karşı soru ve yapaylık denetimi çalışıyor. Sıradaki iş siteyi ikinci bir oyun yapmak değil, biten sistemlerin söz hâlini bu sahnede denemek. Her adım bir ROADMAP maddesinin kabulünü küçültür. Godot’a ancak o kabul sitede görülünce geçilir.

1. **Bağlam paneli gerçek oyuna yaklaşır** (DIY-08). Mevsim ve şifahanenin yanına: yatak doluluk, salgın, terazi (adil/yoz), tipi (ışık), önceki karar, tanıyan köylü. Sahne bu alanları okur. Okumadığı bir düğme eklenmez.
2. **Çelişki tahtası** (DYL-01). Oyuncu iki kaydı kendisi eşleştirir. Yusuf’un beş çifti elle yazılmış “yüzleş” seçeneği olmaktan çıkar.
3. **Bakış** (DYL-02 + KOP-03). Yüz, eller, çarık, yük. Bir bölge KRI-11 belirtisidir. Işık kapalıyken (tipi, akşam) ayrıntı gizlenir.
4. **Kapıdan çıkış iki karttır** (DYL-07, DYL-08). Karardan sonra kısa akşam satırı, sonra “N gece sonra” dönüşü. Dönüş KVR-08 biçiminde bir kayıttır. Yeni sahne dosyası açılmaz; Yusuf’un sonlarına eklenir.
5. **İkinci kişi, başka biçim.** YAZ-05’in ikinci karakteri. Çekirdek ve sahne biçimi Yusuf’tan farklı olur (kısa dürüst, pazarlık, sessiz veya soru soran). Metin üslup rehberine uyar. Kör okuma (DYL-11) bu adımdan önce anlamsızdır, çünkü tek ses vardır.
6. **Yusuf’un ikinci çekirdeği** (DYL-10): `durust`. Aynı selam, başka heybe, yolda yedi ev yok. Tohum hâlâ köyün tohumu olabilir. Kadro kotası sitede sayılır.
7. **Altın oynanış** (DYL-16). Sitede “kayıt al”: seçimler ve zar sonucu → beklenen satırlar. Dosya `tests/soz/altin/` taslağı olarak bu klasörde durur. Oyun motoru yazılınca aynı dosyayı okur.
8. **Yerinde düzenleme** (DYL-15) en sonda. Önce iki biçim oturur. Düzenleyici, oturmamış bir kalıbı kolaylaştırmasın.

Sesli doğaçlama (YAZ-02) 5. adımın metninden önce gelir. Model “kim bu insan” paragrafını yazmaz.


Amaç: üç ayrı diyalog yolunu (adlı karakter sohbeti `SohbetVerisi`, adsız `diyalog_01_20.json`, CHR sorgu `ChrSorgusu`) tek bir konuşma motorunda toplamak. Eski metinler taşınmaz, baştan yazılır (YAZ-06); eski yollar yeni içerik hazır olunca kapatılır (DIY-16). Motor, profesyonel oyunların kanıtlanmış mantığı incelenerek ama kendi stilimizle kurulur. Motor yazımı Claude'un işidir (zor iş).

DIY-01 … DIY-18 gövdesi durur; alt başlıklara bölündü, kimlikleri değişmedi. Yeni maddeler DIY-19 … DIY-98. İkinci Söz motoru yok.

### 16.1 Şema — düğüm dosyası reddi

- [x] **DIY-01:** (Claude) Söz motoru tasarım belgesi — profesyonel oyunların mantığı ve "Kapı usulü".
  - Ne: `docs/SOZ_TASARIMI.md` yedi oyunun ne yaptığını, neyin alınacağını ve neyin alınmayacağını ayrı başlıklarda yazar. Alınan her mekanik bir DIY veya ZAR maddesine bağlanır. Kapı usulü selamı, eşiği, heybeden sürüklenen soruyu, susmayı ve beyan defterini bu belgede sabitler. Belge Ahmet onaylamadan şemaya geçilmez.
  - Kurallar:
    1. `docs/SOZ_TASARIMI.md` iki bölümden oluşur: İnceleme ve Kapı usulü. Üçüncü bölüm açılmaz.
    2. İnceleme yedi kaynağı ayrı başlıkta tutar: Kingdom Come 2, Disco Elysium, Valve kural seçimi, Failbetter/Emily Short, Pentiment, Papers Please, inkle/Ink. Her başlıkta dört satır zorunludur: ne yapıyor, neden işe yarıyor, alınacak kısım, alınmayacak kısım ve gerekçesi.
    3. Alınan her mekanik bir DIY veya ZAR maddesine bağlanır. Bağı olmayan “alınacak” satırı belgeye girmez. İç ses, beceri ağacı ve görünmez zar alınmaz; bunların maddesi yoktur.
    4. Kapı usulü şu kuralları yazar: selam ve ikram (su, ekmek, ateş başına davet tansiyonu değiştirir); eşikte konuşma (içeri alınmadan önce ve sonra ayrı satır); heybedeki eşya sohbete sürüklenerek sorulur; susmak cevaptır; beyan defteri ve yüzleşme; muhafız sezgisi ile eşin akşam yorumu iç sesin yerini tutar; kısa cümle, önce selam.
    5. Belge Ahmet onayı almadan DIY-01a şemasına geçilmez.
  - Uç durumlar: iki kaynak aynı mekaniği söylüyorsa tek maddeye bağlanır, ikinci tasarım yazılmaz. Maddesi olmayan fikir “park” listesine de konmaz. İnceleme bölümü oyun repliği üretmez.
  - Kabul: yedi kaynağın dördü de dolu; her alınacak satırın bir DIY veya ZAR kimliği vardır. Test: kimliği olmayan alınacak satırı doğrulayıcı 1 hata sayar; bölüm sayısı 2’den farklıysa kabul sayılmaz.
  - Bağımlılık: yok. Boyut: M.
  - Dosya: yeni `docs/SOZ_TASARIMI.md`.
  - Asset: asset gerekmedi.

- [ ] **DIY-01a:** Söz veri şeması — konuşma dosyası biçimi.
  - Ne: Konuşma dosyası düğüm, satır, konu, beyan, ikram, zar kontrolü ve `cekirdek` alanlarını taşır. Dürüst çekirdek ipucusuz geçebilir; koruma yalanı ipucusuz geçemez. Konuşmacı kadroda yoksa, seçenek kimliği çiftse, düğüm kendine kenar veriyorsa ya da birden fazla giriş varsa dosya yüklenmez. Derinlik tavanı `data/soz/kurallar.json` içindedir.
  - Kurallar:
    1. Zorunlu alanlar yalnız varış, karar ve `cekirdek`. Selam, konular, yüzleşme, sır ve ikilem yoksa dosya yine geçerlidir.
    2. `cekirdek` OZGUNLUK türlerinden biridir. Sır çekirdeği (`koruma_yalani`, `baskasinin_sirri`, `tehlikeli_yalan`) değilse heybe ipucu şartı kalkar. Doğrulayıcı bu karakterde `Clue_*` yok diye hata vermez.
    3. Sır çekirdeğinde en az bir ipucu ve bir yüzleşme çifti zorunludur.
    4. Evre listesi (selam, konular, derinleşme, yüzleşme, pazarlık, veda) örnektir, şablon değildir. Kadronun yarısından fazlası sır evresi kullanıyorsa uyarı YAZ-09'dadır; şema o uyarıyı üretmez, yalnız alanı taşır.
  - Uç durumlar: dürüst karakterde boş `sir` alanı hatadır, alan hiç yazılmaz. Çekirdeksiz dosya şemadan geçmez.
  - Kabul: Üç örnek dosyadan ipucusuz dürüst olan geçer, ipucusuz koruma yalanı geçmez (`tests/unit/soz/sema_test.gd`). Ek şart: kadroda olmayan konuşmacı, çift seçenek kimliği, kendine kenar ve ikinci giriş her biri 1 şema hatası verir. Ek şart: tavan 12 iken 13. düğüm 1 hata verir ve tavan `.gd` içine yazılmaz.
  - Bağımlılık: DIY-01. Boyut: M.
  - Dosya: yeni `docs/SOZ_SEMASI.md`, `data/soz/_sema.json`, `data/soz/ornek_*.json`.
  - Asset: asset gerekmedi.

### 16.2 Yürütme — etki, kayıt, kilit

- [ ] **DIY-02:** Söz motoru çekirdeği — düğüm yürütücü.
  - Ne: `SozMotoru` konuşma dosyasını okur, koşulu tutan satırı verir ve seçimin etkisini bir kez yazar. Şemaya uymayan dosya sahneyi sustu kapatır, oyunu düşürmez ve yedek hikâye uydurmaz. Etki anahtarı bar, akçe, ambar, bayrak, tansiyon ve ziyaret dışında olursa dosya reddedilir. Boş metin anahtarı ve bağlamda olmayan `{yer}` satırı oynatılmaz. Eski kayıtta düğüm alanı yoksa sahne girişten başlar.
  - Kurallar:
    1. `SozMotoru` konuşma dosyasını okur, koşulları değerlendirir, satırları sırayla verir, seçim alır, etkileri uygular.
    2. `ChrSorgusu` kilitleri motorda durur: tansiyon, ipucu kilidi, bayrak, panik kilidi, `Final_Ret`, karar kısıtı. Yeni kilit türü eklenmez.
    3. Karar matrisi ve gecikmeli etkiler (KVR-07/08) aynı API’den okunur. Motor ikinci kuyruk açmaz (KOP-04).
    4. Dosya şeması DIY-01a’dır. Şemaya uymayan dosya yüklenmez; motor yedek hikâye uydurmaz.
    5. Etki sözlüğü veridedir. Kod karakter adı veya cümle bilmez.
  - Uç durumlar: koşulu tutmayan satır atlanır. Hiç satır kalmazsa veda düğümüne düşülür; veda da yoksa sahne “sustu” ile kapanır ve karar düğmeleri açık kalır. Panik kilidinde ikna ve gözdağı kapanır, `Final_Ret` yolu durur. Kayıt yarım kalırsa son düğüm kimliği yazılır, sahne baştan açılmaz.
  - Kabul: Altı kilit türünün her biri bir örnek dosyayla geçer (`tests/unit/soz/soz_motoru_test.gd`). Şema hatası olan dosya 0 satır oynatır. Ek şart: aynı seçimin ikinci `sonuc` çağrısı barı bir kez daha değiştirmez. Ek şart: `altin` etki anahtarı ve boş metin anahtarı 1'er hata verir.
  - Bağımlılık: DIY-01a. Boyut: L.
  - Dosya: yeni `src/soz/soz_motoru.gd`, `src/soz/soz_dugumu.gd`.
  - Asset: asset gerekmedi.

- [ ] **DIY-03:** Selam önce, hikâye sonra — konu merkezi.
  - Ne: Karakter kapıya varınca oyuncu önce selamı görür; selam bitmeden konu listesi açılmaz. Konu sırası dosyadaki dizidir, kod yeniden sıralamaz. Konu düğümünde kabul ve ret kapalıdır; veda veya sustu kapanışında karar çubuğu açılır. Konu açıkken köy ekranına geçilmez. Her konu düğümünün merkeze dönen bir kenarı vardır.
  - Kurallar:
    1. Karakter kapıya varınca yalnız selam satırı gelir. Selam bitmeden konu listesi açılmaz.
    2. Ortak konu kümesi: Nereden, Neden yola düştün, Kiminle, Ne iş bilirsin, Yükün, Yolda ne gördün, varsa Haber. Başlık her karakterde aynıdır; cevap ağacı karaktere özeldir.
    3. “Kimsin / nesin / kendini tanıt” üçlüsü kalkar. Eski otomatik `acilis` hikâyesi selam sayılmaz (DIY-16).
    4. Veride olmayan konu listede görünmez. Boş başlık basılmaz.
    5. İkram (su, ekmek) selam evresinin seçeneğidir, ayrı konu değildir. Tansiyon etkisi seçenekte yazar.
  - Uç durumlar: konu listesi boşsa (sessiz karakter veya dil engeli) yalnız selam, bakış ve karar kalır. Heyet sahnesinde (KOP-02) konu merkezi açılmaz. Aynı konu ikinci kez seçilirse katman DIY-04’e gider, selam tekrar etmez.
  - Kabul: Otuz adlı karakterde selamdan önce hikâye satırı 0'dır (`tests/unit/soz/konu_merkezi_test.gd`). "Kimsin?" başlığı 0'dır. Ek şart: konu ekranında karar düğmesi 0'dır. Ek şart: kenarsız konu düğümü 1 şema hatası verir. Ek şart: Bağ için söz dalı yoksa doğrulayıcı hata yazmaz.
  - Bağımlılık: DIY-02. Boyut: M.
  - Dosya: yeni `src/soz/konu_merkezi.gd`; `src/arayuz/kapi/soz_paneli.gd` (yeni panel, eski panele adaptör).
  - Asset: asset gerekmedi.

### 16.3 Konu merkezi

- [ ] **DIY-04:** Derinleşme katmanları — aynı konuda üstelemek yeni bilgi açar.
  - Ne: Oyuncu aynı konuyu üstelerse ikinci katman açılır; birinci seçilmeden ikinci gelmez. Üsteleme başka konuya zıplamaz. Tavan `kurallar.json` içindedir, öneri 3'tür; dördüncü üsteleme yeni soru açmaz, veda satırı gelir. Susuş beyan yazmaz.
  - Kurallar:
    1. Her konuda en az 2 katman vardır. İkinci katman birincisi seçilmeden açılmaz.
    2. Üstelemek tansiyonu artırabilir. Artış seçenekte yazar; yazılmamışsa +0’dır.
    3. Karakter bir katmanda susabilir. Susuş satırı `susus: true` taşır, beyan üretmez, ipucu üretebilir.
    4. Doğrulayıcı her karakterde konu başına katman sayısını raporlar. 1 katman hatadır. Konu hiç yoksa rapor “yok” yazar, 0 diye hata basmaz.
    5. Son katmandan sonra üsteleme düğmesi kapanır. Motor yeni katman uydurmaz.
  - Uç durumlar: “gerisini sorma” susuşu o konunun sonraki katmanlarını kilitler. Güven eşiği (DIY-17) susuşu açabilir; eşik yazılmamışsa susuş kalır. Üsteleme sabır harcar (DIY-05).
  - Kabul: Bir katmanlı konu 1 hata verir; susuş satırı beyan defterine 0 kayıt yazar (`tests/unit/soz/derinlesme_test.gd`). İkinci katman birincisiz seçilemez. Ek şart: tavan 3 iken dördüncü üsteleme soru açmaz.
  - Bağımlılık: DIY-03. Boyut: M.
  - Dosya: şema + motor; içerik YAZ bölümünde.
  - Asset: asset gerekmedi.

- [ ] **DIY-05:** Sıra sabrı — sohbetin zaman bedeli.
  - Ne: Her soru, bakış ve yemin sıradaki sabırdan düşer; HUD kalan sayıyı ve eylemin bedelini gösterir. Sayaç saniye değildir: oyuncu düşünürken, menü açıkken ve sıra olayı kartı açıkken düşmez. Tavan `azami_soru` alanıdır, ikinci bir sayı yazılmaz. Sabır bitince konu kapanır, veda ve karar çubuğu açılır. Hız çarpanı açık düğümü kesmez.
  - Kurallar:
    1. Her soru, bakış, gösterme, yemin ve tercüman çağrısı sıradaki sabırdan düşer. Miktar eylemde yazar; yazılmamış soru −1’dir.
    2. Sabır gerçek zaman değildir. Oyuncu düşünürken sayaç ilerlemez.
    3. Sabır 0 olunca sıradan biri ayrılır veya mevcut sıra olayı tetiklenir (BUG-20). Yeni olay türü açılmaz.
    4. Sabır HUD’da görünür: kalan sayı ve bu eylemin bedeli.
    5. Heyet ve zorunlu gelen (KAP-16) sabır harcamaz.
  - Uç durumlar: sırada tek kişi varken sabır 0’a inerse ayrılacak kimse yoktur; sıra olayı da yoksa HUD “sabır bitti” der, kapıdaki kişi kaçmaz. Sabır eksiye inmez. Aynı konunun ikinci katmanı da sabır harcar.
  - Kabul: On iki soruluk örnekte ayrılan kişi ya da tetiklenen sıra olayı en az 1'dir (`tests/unit/kapi/sira_sabri_test.gd`). Şemada gerçek zaman alanı 0'dır. Ek şart: `azami_soru` dışında ikinci tavan sabiti 0'dır. Ek şart: menü açılıp kapanınca kalan sayı değişmez.
  - Bağımlılık: DIY-03, BUG-20. Boyut: S.
  - Dosya: yeni `src/kapi/sira_sabri.gd`.
  - Asset: asset gerekmedi.

### 16.4 Sabır ve kesme

- [ ] **DIY-06:** Beyan defteri — karakterin söyledikleri kayda geçer.
  - Ne: Önemli cevap, sorgu panelindeki küçük deftere metin anahtarı ve kaynak soru kimliğiyle düşer. Aynı ziyarette aynı beyan ikinci kez yazılmaz. Ziyaret bitince satırlar kişi hafızasına geçer; `Clue_*` sayısı bu yüzden artmaz. Köyden ayrılanın satırı silinmez, yanına gittiği yazılır. Eski kayıtta liste yoksa boş sayılır.
  - Kurallar:
    1. Önemli cevap bir beyan üretir. Beyan, metin anahtarı ve kaynak soru kimliği taşır. Örnekler: “Sivas’tan geliyorum”, “yalnızım”, “yükümde darı var”.
    2. Beyanlar sorgu panelindeki küçük defterde listelenir. Yanında hangi sorudan veya hangi bakıştan geldiği yazar.
    3. Aynı ziyarette aynı beyan kimliği ikinci kez yazılmaz.
    4. Ziyaret sonunda beyanlar kişi hafızasına geçer (DIY-11). `Clue_*` ayrı kalır; defter ipucu yöneticisinin yerine geçmez.
    5. Susuş (DIY-04) ve “anlaşılamadı” (DYL-06) beyan değildir. Ayrı kayıt türüdür.
  - Uç durumlar: yüzleşme beyanı çürütürse eski satır silinmez, “çürütüldü” işaretlenir. Karakter beyan bitmeden kaçarsa o ana kadarki beyanlar hafızaya yazılır. Boş metinli beyan şema hatasıdır, deftere girmez.
  - Kabul: Aynı cevabı iki kez seçmek defterde 1 satır bırakır (`tests/unit/soz/beyan_defteri_test.gd`). `Clue_*` sayısı beyan yüzünden artmaz. Ek şart: ayrılan kişinin satırı durur. Ek şart: beyan alanı olmayan eski kayıt açılır ve liste boştur.
  - Bağımlılık: DIY-02. Boyut: M.
  - Dosya: yeni `src/soz/beyan_defteri.gd`; `IpucuYoneticisi` yanında ikinci sistem değil, aynı ziyaret kapsamında ayrı defter.
  - Asset: asset gerekmedi.

- [ ] **DIY-07:** Çelişki ve yüzleşme — yalan, kanıtla ortaya çıkar.
  - Ne: Heybe, astar veya hastalık belirtisi bir beyanla çelişirse o çifte özel yüzleşme dalı açılır. İpucu yokken dal kapalıdır. Hazır "Yüzleş" düğmesi yalnız `celiski_yardimi` açıkken görünür. Çözülen çelişki aynı ziyarette ikinci dal açmaz.
  - Kurallar:
    1. İpucu (heybe, astar, görsel hata, hastalık belirtisi) bir beyanla çelişirse o çifte özel yüzleşme dalı tanımlanır.
    2. Hazır “Yüzleş” seçeneği yalnız `celiski_yardimi` açıkken görünür (DYL-01). Kapalıyken dal doğru çiftle açılır.
    3. Sır çekirdeğinde her CHR’de en az 1, tehlikeli CHR’de en az 2 çelişki çifti vardır. Dürüst çekirdekte çift zorunlu değildir (DIY-01a).
    4. İpucu yokken yüzleşme kapalıdır (KAP-07). İpucu varken dal koşulu açılır.
    5. Çözülen çelişki aynı ziyarette ikinci dal açmaz.
  - Uç durumlar: aynı ipucu iki çifte girerse ikisi de açılabilir; biri çözülünce öteki durur. Tehlikeli işareti olmayan CHR’de tek çift yeter. Çiftin bir kaydı silinmişse doğrulayıcı 1 hata verir, motor o dalı gizler.
  - Kabul: İpucu yokken yüzleşme seçeneği 0, varken 1'dir (`tests/unit/soz/celiski_test.gd`). Dürüst örnekte 0 çift şemadan geçer. Tehlikeli örnekte tek çift 1 hata verir.
  - Bağımlılık: DIY-06. Boyut: M.
  - Dosya: yeni `src/soz/celiski.gd`.
  - Asset: asset gerekmedi.

### 16.5 Beyan ve çelişki işareti

- [x] **DIY-08:** (testx) Bağlam sorgusu — dünyanın durumu tek sözlükte.
  - Ne: Konuşma başında gün, mevsim, binalar, nüfus, terazi, yatak ve salgın tek sözlükte toplanır. Sözlük salt okunurdur; olmayan bina `false` döner. Ziyaret içinde dikilen bina aynı konuşmada görünmez. Kayıt yüklenince sözlük kayıttan değil canlı yöneticilerden kurulur.
  - Kurallar:
    1. Konuşma başında tek sözlük üretilir: gün, mevsim, hava, açık krizler, köydeki binalar, nüfus, muhafız terazisi, itibar, önceki ziyaretler, dünya olayları, yatak doluluk, salgın bayrağı, tipi ve ışık.
    2. Sözlük salt okunurdur. Ekonomiye, kasaya ve salgın sayacına yazmaz.
    3. Olmayan bina `false` döner. Kelime tahmini yoktur (KOP-04 ile aynı ilke).
    4. Sahne, sözlükte okumadığı alanla düğme açmaz. Koşul alanı sözlükte yoksa satır seçilmez ve doğrulayıcı uyarır.
    5. Sözlük ziyaret başında bir kez kurulur. Ziyaret içinde dikilen bina aynı konuşmada görünmez.
  - Uç durumlar: yönetici yoksa alan `false` veya 0 döner, sahne çökmez. İki kriz aynı anahtardaysa liste döner, son kriz öncekini silmez. Kayıt yüklenince sözlük kayıttan değil canlı yöneticilerden kurulur.
  - Kabul: Şifahane yokken `bina.sifahane` false döner (`tests/unit/soz/baglam_sorgusu_test.gd`). Sözlük yazma çağrısı 0'dır. Belgede olup sözlükte olmayan alan 1 hata verir.
  - Bağımlılık: yok. Boyut: M.
  - Dosya: yeni `src/soz/baglam_sorgusu.gd`; okuduğu yöneticiler değişmez.
  - Asset: asset gerekmedi.

- [x] **DIY-09:** Kural tablosu ile bağlamsal satır seçimi. (Antigravity)
  - Ne: Bir satırın birden çok varyantı varsa en çok koşulu tutan seçilir. Eşit sayıda tutan iki varyantta `oncelik` kazanır. Hiçbiri tutmazsa varsayılan gelir; varsayılan yoksa satır susar. Kısmi tutma sayılmaz.
  - Kurallar:
    1. Bir satırın birden çok varyantı olabilir. Her varyantın koşulları DIY-08 sözlüğündendir.
    2. En çok koşulu tutan varyant seçilir. Eşit sayıda tutan iki varyantta `oncelik` kazanır. İkisi de yoksa varsayılan satır gelir.
    3. Hiçbiri tutmazsa varsayılan satır gelir. Varsayılan yoksa satır susar, motor çökmez.
    4. Tansiyon bantları (sakin, gergin, panik), mevsim, kriz ve hafıza aynı seçiciyle yürür. İkinci seçici yoktur.
    5. Koşulu tutmayan varyant seçilmez. Kısmi tutma “biraz uygun” diye sayılmaz; sayım tam eşleşmedir.
  - Uç durumlar: altı koşulun beşi tutan varyant, üçü tutandan kazanır. Hepsi 0 tutarsa varsayılan gelir. `oncelik` de koşul sayısı da eşitse doğrulayıcı 1 hata verir; dosya sırası hakem olmaz. Boş koşul listesi varsayılan sayılır.
  - Kabul: Beş koşul tutan varyant, üç koşul tutanı 1000 seçimde 0 kez yener (`tests/unit/soz/satir_secici_test.gd`). Önceliksiz eşitlikte yükleme 1 hata verir. Ek şart: Aç kişinin söz bağlamına aclik anahtarı yazılır; motor ikinci cümle üretmez. Ek şart: Dünya işareti söz bağlamına dunya öneki ve olay kimliği olarak girer; motor yeni cümle üretmez.
  - Bağımlılık: DIY-08. Boyut: M.
  - Dosya: yeni `src/soz/satir_secici.gd`.
  - Asset: asset gerekmedi.

### 16.6 Bağlam sözlüğü

- [ ] **DIY-10:** Sır ve ikilem dalları — neden sakladığı.
  - Ne: Sırrı açığa çıkan karakter neden dalına geçer; neden aile, borç, korku, inanç veya yeminden biri olarak veridedir. Dalın sonunda en az iki seçenek kalır ve etkileri farklıdır. Dürüst dosyada ikilem zorunlu değildir. Kasayı eksiye indirecek seçenek kilitli görünür, silinmez.
  - Kurallar:
    1. Sır çekirdeğinde sırrı açığa çıkan karakter neden dalına geçer. Neden veridedir: aile, borç, korku, inanç veya yemin. Kod neden bilmez.
    2. Dalın sonunda en az 2 seçenek kalır. Her seçeneğin bedeli duran bir sisteme yazar: adalet, köy güvenliği, vicdan veya kasa. Yeni sayaç yok.
    3. İki seçenek aynı etki sözlüğünü taşıyamaz. Doğrulayıcı bunu hata sayar.
    4. Dürüst çekirdekte ikilem zorunlu değildir (DIY-01a).
    5. Tek şanslık zar (ZAR-05) yalnız bu düğümlerde durabilir.
  - Uç durumlar: bir seçenek koşul tutmadığı için gizlenir ve ortada tek seçenek kalırsa motor karar düğmesini de açık tutar. Karakter dal ortasında kaçarsa ikilem “çözülmedi” diye hafızaya yazılır. Kasayı eksiye indirecek seçenek kilitli görünür, silinmez.
  - Kabul: Her tehlikeli CHR dosyasında en az 1 ikilem vardır (`tests/unit/soz/ikilem_test.gd`). Aynı etki sözlüğüne sahip iki seçenek 1 hata verir. Dürüst dosyada 0 ikilem geçer.
  - Bağımlılık: DIY-07. Boyut: M.
  - Dosya: şema + motor; içerik YAZ.
  - Asset: asset gerekmedi.

- [x] **DIY-11:** Kişi hafızası — dönen karakter hatırlar. (Antigravity)
  - Ne: Dönen karakterin selamı son kararı okur; retten sonra selam `selam_ret` olur. Hafıza `KarakterKadrosu.durumlar` içindedir, ikinci depo yoktur. Kayıt yüklemek ziyaret sayacını artırmaz. Sayaç 9'dan sonra yeni selam anahtarı açmaz. Eski kayıtta alan yoksa boş sayılır, oyun çökmez.
  - Kurallar:
    1. Kişi başına hafıza şunları tutar: son karar (kabul, ret, rüşvet, kışla, kaçtı), verilen söz, yapılan yardım, yüzleşilen yalan, ödenen veya alınan akçe.
    2. Tek kaynak `KarakterKadrosu.durumlar[id]` alanlarıdır (`ziyaret`, `son_karar`). Yeni alanlar optional kayıttır. İkinci hafıza deposu yoktur.
    3. Dönüşte selam ve en az 1 konu hafızaya göre değişir (DIY-09 varyantı).
    4. Hafıza yoksa ilk ziyaret selamı gelir. Eski kayıtta alan yoksa oyun çökmez, alan boş sayılır.
    5. Eşin akşam hafızası aynı kaydın `es` altıdır (DYL-07). Ayrı eş deposu yok.
  - Uç durumlar: ret sonrası kabul, `son_karar` alanını ezer; ret satırı silinmez, selam son kararı okur. Kişi ölürse hafıza “öldü” diye kapanır ve selam varyantı seçilmez; haber DYL-08 kanalına gider. Aynı gün ikinci ziyaret yoksa hafıza ertesi kapıda okunur.
  - Kabul: `son_karar=ret` iken selam kimliği `selam_ret` olur (`tests/unit/soz/kisi_hafizasi_test.gd`). Kadroda ikinci sözlük yazımı 0'dır. Ek şart: kaydet-yükle sonrası ziyaret sayısı aynı kalır. Ek şart: onuncu ziyaret dokuzuncu ziyaretin selam anahtarını kullanır.
  - Bağımlılık: DIY-09. Boyut: M.
  - Dosya: yeni `src/soz/kisi_hafizasi.gd`; kayıt adaptörü (`guvenli_kayit.gd` çekirdek, minimal).
  - Asset: asset gerekmedi.

### 16.7 Hafıza, grup, güven

- [x] **DIY-12:** Grup itibarı — Türkmen, Rum, Ahi, köylü, tüccar, asker. (Antigravity)
  - Ne: Altı grubun her birinin itibarı eksi on ile artı on arasındadır. Bir ziyaret yalnız karakterin birincil grubuna yazar; Türkmen reti Rum değerini değiştirmez. Sınırın dışına taşan yazım eksi on veya artı onda kesilir. Yedinci grup adı reddedilir. Kayıt anahtarı kalp veya romans olamaz.
  - Kurallar:
    1. Gruplar: Türkmen, Rum, Ahi, köylü, tüccar, asker. İtibar grup başına −10…+10.
    2. Karar, karakterin birincil grubuna bir kez yazar. Çift gruplu kişide yazar birincil grubu seçer; ikinci gruba aynı ziyarette yazılmaz.
    3. İtibar satır seçimine (DIY-09) ve zar değiştiricisine (ZAR-04) girer.
    4. Köylü kartında ve muhafız odasında görünür. Yeni ekran açılmaz.
    5. Sınır dışına taşan yazım −10 veya +10’da kesilir.
  - Uç durumlar: grupsuz karakter köylü sayılır; bu varsayılan alandır, uyarı değildir. Türkmen ret dizisi Rum değerini değiştirmez. −10’dayken yeni ret değeri değiştirmez, yazım denemesi kayıtta “kesildi” diye durur.
  - Kabul: Türkmen reti Türkmen itibarını düşürür, Rum deltası 0 kalır (`tests/unit/sistemler/grup_itibari_test.gd`). Eksi ondayken bir ret daha eksi on bırakır. Bir ziyarette yazılan grup sayısı 1'dir.
  - Bağımlılık: DIY-08. Boyut: M.
  - Dosya: yeni `src/sistemler/grup_itibari.gd`, `data/gruplar.json`.
  - Asset: asset gerekmedi.

- [x] **DIY-13:** Dedikodu yayılımı — haber gecikmeli dolaşır. (Antigravity)
  - Ne: Rüşvet, şiddet, aileyi bölme ve haksız ret tanık varsa bir ila üç gece içinde yayılır. Tanık yoksa satır oluşmaz. Aynı olay kimliği ikinci kayıt açmaz. Sabah pusulasına bunu KOP-05 yazar; gazete kendi cümlesini uydurmaz.
  - Kurallar:
    1. Ağır olay türleri veridedir: rüşvet, şiddet, aileyi bölme, haksız ret. Listede olmayan olay dedikodu üretmez.
    2. Tanık yoksa kayıt oluşmaz. Tanık, kapıda sırada duran veya olayı gören köylüdür.
    3. Kayıt 1–3 gece içinde yayılır. Gün aralığı kayıtta yazar. Sabah pusulasına KOP-05 yazar.
    4. `FisiltiGazetesi` (CAS-09) ve `BatilInancHisterisi` (KRI-08) aynı kaydı okur. Kendi olayını yazmaz.
    5. Aynı olay kimliği ikinci kayıt açmaz.
  - Uç durumlar: tanık ertesi gece ölürse yayılmamış kayıt düşer. Üçüncü geceden sonra basılmamış satır silinir, birikmez. Kamu vergisi dedikodu değildir; tanıklı şahsi rüşvet yayılır.
  - Kabul: Tanıksız rüşvet 0 satır üretir (`tests/unit/sistemler/dedikodu_test.gd`). Tanıklı rüşvet üç gece içinde 1 satır olur. Gün sıfırda pusula satırı 0'dır.
  - Bağımlılık: DIY-11, DIY-12. Boyut: M.
  - Dosya: yeni `src/sistemler/dedikodu.gd`.
  - Asset: asset gerekmedi.

### 16.8 Dedikodu kancası

- [x] **DIY-14:** "Bu hatırlanacak" bildirimi. (Antigravity)
  - Ne: Hafıza veya dedikodu yazan seçimde oyuncu iki saniye "Bu hatırlanacak" notunu görür. Notta isim ve gece sayısı yoktur; metin çeviri anahtarıdır. Ayar kapatılırsa not gizlenir, kayıt yine yazılır. Aynı seçimde not bir kez çıkar.
  - Kurallar:
    1. Not yalnız hafıza (DIY-11) veya dedikodu (DIY-13) yazılan seçimde çıkar.
    2. Metin “Bu hatırlanacak”tır. İsim, grup ve gece sayısı yazılmaz.
    3. Ayarlardan kapatılabilir. Kapalıyken yazım durmaz, yalnız not gizlenir.
    4. Aynı seçimde hem hafıza hem dedikodu varsa not bir kez çıkar.
    5. Not 2 saniye sonra kapanır. Tıklanınca da kapanır. Kararı bekletmez.
  - Uç durumlar: ayar kapalıyken kayıt yine yazılır. İkinci not birincinin üstüne binmez; birincisi kapanır, kuyruk birikmez. Kaçış (ZAR-03) hafızaya yazıyorsa not çıkar.
  - Kabul: Ayar kapalıyken not 0 kez görünür, kayıt 1 kez yazılır (`tests/unit/kapi/hatirlanma_notu_test.gd`). Tek seçimde not sayısı 1'dir. Metinde özel ad 0'dır.
  - Bağımlılık: DIY-11. Boyut: S.
  - Dosya: yeni `src/arayuz/kapi/hatirlanma_notu.gd`.
  - Asset: asset gerekmedi.

- [x] **DIY-15:** (Kalfa) Muhafızın sesi — seçenek metni terazi ve geçmişe göre tonlanır.
  - Ne: Tonlanan her seçenekte adil, sert ve yozlaşmış üç metin vardır; etki sözlüğü üçünde aynıdır. Terazi ortaya yakınsa sert varyant gelir. Geçmişe özel seçenek geçmiş yoksa gizlenir. Boş varyantla sahne yüklenmez. Ton anahtarı yoksa nötr anahtar kullanılır ve ton sonucu değiştirmez.
  - Kurallar:
    1. Tonlanan her seçenekte 3 varyant vardır: adil, sert, yozlaşmış. Mekanik etki üçünde aynıdır. Metin ve karşı tepki farklıdır.
    2. Ton eşiği `data/` içindedir, sabit kodlanmaz. Eşik ODA skorunu okur (KOP-06).
    3. ACL-06 geçmişine özel seçenek bu katmandadır. Geçmiş yoksa o seçenek gizlenir; varsayılan ton kalır.
    4. Karşı tepki de DIY-09 ile seçilir. İkinci ton motoru yoktur.
    5. Üç metinden biri boşsa doğrulayıcı hata verir. Eksik tonla sahne yüklenmez.
  - Uç durumlar: terazi ortadaysa sert varyant gelir. Geçmiş seçeneği üç tonda da durur; ton metni değiştirir, seçeneği silmez. Etki sözlüğü farklı olan üçlü hata sayılır.
  - Kabul: Adil ve yoz metin anahtarları eşit değildir, etki JSON eşittir (`tests/unit/soz/muhafiz_tonu_test.gd`). Boş yoz varyant 1 hata verir.
  - Bağımlılık: DIY-09, ACL-06. Boyut: S.
  - Dosya: yeni `src/soz/muhafiz_tonu.gd`; okuma `MuhafizTerazisi`, `MuhafizVicdani`.
  - Asset: asset gerekmedi.

### 16.9 Ton, eski yol, prototip

- [ ] **DIY-16:** Eski diyalog yollarının kapatılması — yeniden yazılan içerik devreye girer.
  - Ne: Yeni konuşma dosyası biten karakter eski `diyalog_sirasi` yolundan çıkar; iki kaynak aynı karede basılmaz. Eşleme `data/soz/gecis.json` içindedir ve karşılığı olmayan alan `tasinmaz` diye yazılır. Kapanış bayrağı `kurallar.json` içindedir; bayrak kapalıyken eski sıra durur. Dosyası ve sınıf şablonu olmayan adlı figür sustu kapanır, şablon uydurulmaz.
  - Kurallar:
    1. Eşleme tablosu `docs/SOZ_SEMASI.md` içindedir. Satırlar: `diyalog_01_20.json` soru dizisi → konu ve katman; otomatik `acilis` → yalnız selam, hikâye konu seçilince; `SohbetVerisi` giriş / açılış / soru dizisi → aynı ayrım; CHR düğüm 00 ve üç dal → varış, konular, yüzleşme; `Clue_*` ve dört `Flag_*` aynı kimlikle kalır; `karar_matrisi` KOP-10'a gider.
    2. Karşılığı olmayan alan tabloda `tasinmaz` diye yazılır. Sessiz silme yoktur.
    3. Eski metin kendiliğinden taşınmaz. YAZ-06 dalgası biten karakter tek yola geçer, eski ve yeni birlikte çalışmaz.
    4. Son dalgadan sonra sohbet akışı, `_gemini_al()` ve `chr_diyalog_paneli.gd` kapıdan çıkar. Heybe, görsel hata, karar matrisi ve spawn verisi yerinde kalır. Eski kayıt açılır, `diyalog_sira` yok sayılır.
  - Uç durumlar: adsız yirmi diyalogun yirmisinde de `acilis` var ve ilk soru "Kimsin?". Tabloda bu ikisi `tasinmaz` veya yeni selam kuralına bağlanır; otomatik hikâye yeni dosyada kalamaz. Geçiş tablosunda olmayan karakter eski yolda kalır, ikisi birden açılmaz.
  - Kabul: Otuz adlı karakter yeni motordan konuşur ve eski yola çağrı 0'dır (`tests/unit/soz/gecis_test.gd`). Eşleme tablosunda boş karşılık 0'dır. Ek şart: bayrak kapalıyken `diyalog_sirasi.gd` `oku` hâlâ çağrılır; açıkken çağrı 0'dır.
  - Bağımlılık: DIY-02, YAZ-06, DIY-01a. Boyut: L.
  - Dosya: `Oturum`, `chr_kapi_adaptoru.gd`, `kapi_ekrani.gd` yönlendirmesi (çekirdek, minimal); karakter başına geçiş tablosu `data/soz/gecis.json`.
  - Asset: asset gerekmedi.

- [ ] **DIY-17:** Güven ve korku ayrı ölçülür.
  - Ne: Güven sıfır ile on arasında ayrı bir çubuktur; korkuyla açılan sır eksik kalır, güvenle açılan sır tam açılır. Güven yedi ve üstündeyken itiraf görünür ve zarsız tam sır açar. Altındayken itiraf düğmesi yoktur. İki değer toplanıp tek çubuk olmaz.
  - Kurallar:
    1. Güven 0–10’dur. Başlangıç karakter verisindedir; alan yoksa 3’tür.
    2. İkram, karşılık verme ve dinleme artırır. Sert soru, heybeyi izinsiz karıştırma ve söz kesme düşürür. Miktar seçenekte yazar.
    3. Güven satır koşuludur (`guven_min` / `guven_max`) ve zar değiştiricisidir: güven ≥ 7 iken ikna −1, güven ≤ 2 iken ikna +1.
    4. Güvenle açılan sır tam açılır. Korkuyla (zar, gözdağı) açılan sır eksik açılır; kalan parça bakış veya heybe ile doğrulanır.
    5. Güven ≥ 7 iken `itiraf` seçeneği görünür ve zarsız tam sır açar. Altındayken görünmez.
  - Uç durumlar: güven 0’ın altına ve 10’un üstüne yazılmaz. Aynı sır önce korkuyla açıldıysa güven sonradan yükselse bile itiraf o sır için kapanır; eksik parça yalnız bakış veya heybe ile tamamlanır. Yusuf prototip düğümleri `sir_acildi`, `sir_acildi_korku` ve `itiraf` bu kuralın örneğidir.
  - Kabul: Güven 6 iken itiraf düğmesi 0, 7 iken 1'dir (`tests/unit/soz/guven_korku_test.gd`). Korku dalındaki beyan sayısı tam daldan azdır.
  - Bağımlılık: DIY-02, DIY-09, ZAR-04. Boyut: M.
  - Dosya: `src/soz/` durum nesnesi; sorgu paneline ikinci çubuk.
  - Asset: asset gerekmedi.

### 16.10 Sınır ve kapanış

- [ ] **DIY-18:** Söz kesme, karşı soru ve muhafızın beyanı.
  - Ne: Muhafız anlatıyı kesince cümle "—" ile biter, sabır bir artar, güven bir düşer ve o düğüme bir daha girilmez. Karakter soru sorarsa muhafızın cevabı `soylenen` kaydına düşer ve bir sabır hakkı harcar. Cevap verilmeden o cevaba bağlı varyant seçilmez.
  - Kurallar:
    1. `kesme`: muhafız anlatıyı keser. Son replik yarıda kalır, sabır +1, güven −1. Kaçan düğüme bir daha ulaşılmaz.
    2. `kesilir`: karakter muhafızın cümlesini keser. Cümle yarıda kalır. Acele cevap sezgi satırı ve ipucu üretebilir.
    3. Karakter soru sorar. Muhafızın cevabı `soylenen` kaydıdır. Sonraki varyant yalnız o cevap verilmişse seçilir.
    4. Seçimden hemen sonra kısa `tepki` satırı gelir. Tepki yoksa atlanır.
    5. Arayüzde kesilen cümle “—” ile biter. Tamamı ayrıca gösterilmez.
  - Uç durumlar: kesilen düğümün cümlesi beyan defterine yazılmaz. `soylenen` yalan olabilir (DYL-04); bu madde doğruluğu denetlemez, kaydı tutar. Aynı anlatı ikinci kez kesilemez, düğüm kapalıdır. Soru sorulmadan `soylenen` koşullu varyant seçilmez.
  - Kabul: Kesilen anlatının devam düğümüne erişim 0'dır (`tests/unit/soz/soz_kesme_test.gd`). `soylenen` yokken koşullu varyant 0 kez seçilir. Ek şart: karşı soru kalan sabrı 1 düşürür.
  - Bağımlılık: DIY-02, DIY-09. Boyut: M.
  - Dosya: `src/soz/` motor; sorgu paneli satır çizimi.
  - Asset: asset gerekmedi.

ZAR-01 … ZAR-06 gövdesi durur. Yeni maddeler ZAR-07 … ZAR-86. İkinci zar sınıfı yok.


---

## BÖLÜM 17: Görünür Zar ve Sorgu Dengesi (Faz 2)

### 17.1 Zarın kendisi

- [x] **ZAR-01:** (Antigravity) Görünür zar — d6 ve d12. _(sanity bekliyor)_
  - Ne: İkna, blöf, gözdağı ve gönül almada oyuncu atılan zarın sayısını görür. Başarı `zar ≥ gerekli` kuralıdır; gerekli değer karakter değeri artı bir artı tansiyon ekidir. Sakin ek 0, gergin ek 1, panik ek 2'dir. Değer 2 ve sakin iken gerekli 3, panikte 5 olur. d20 reddedilir. Aynı tohum aynı sonucu verir.
  - Kurallar:
    1. İkna, blöf, gözdağı ve gönül alma seçeneklerinde ekranda zar atılır. Karakter verisinde `zar` alanı `d6` veya `d12` olur.
    2. Başarı kuralı `zar ≥ gerekli`. `gerekli` = karakter değeri + 1 + tansiyon eki + değiştiriciler.
    3. Tansiyon eki üç kademedir: sakin (0–3) +0, gergin (4–7) +1, panik (8–10) +2. Aralıklar KAP-02’den gelir.
    4. Formül ve eşikler `data/chr_runtime/sorgu_kurallari.tres` içindedir. Sabit kodlanmaz. Değer 2 örneği: sakin 3, gergin 4, panik 5.
    5. `ChrSorgusu.basari_olasiligi` (KAP-09) bu kurala döner. İkinci olasılık hesabı kalmaz. Eski kayıt açılır; eksik `zar` alanı ZAR-02 varsayılanına düşer.
  - Uç durumlar: `gerekli` zarın tavanından büyükse (d6’da 7 ve üstü) düğme kilitlenir, zar atılmaz. d6’da 6 ve d12’de 12 her zaman başarıdır; 1 her zaman başarısızdır. Değiştirici 1’i başarıya çevirmez. Zar görseli yoksa düz renk kutu ve sayı yeter.
  - Kabul: Değer 2, sakin ve değiştirici 0 iken gerekli 3'tür; panikte gerekli 5'tir (`tests/unit/kapi/sorgu_zari_test.gd`). On bin atışta d6 dağılımı teorik orandan en fazla yüzde 2 sapar. KAP-09'a giden ikinci hesap yolu 0'dır. Ek şart: aynı tohumla iki atış aynı sayıyı verir. Ek şart: yeni ses dosyası eklenmez. Ek şart: başarı ve başarısızlık yalnız renkle değil, sayı ve sözcükle de yazılır. Ek şart: Hüküm sabahı zar atışı yazmaz.
  - Bağımlılık: yok (DIY-02 gelince motora taşınır). Boyut: M.
  - Dosya: yeni `src/kapi/sorgu_zari.gd`; `ChrSorgusu.secenek_sec` tek satır.
  - Asset: zar görseli envantere `ZAR01-ZAR` (d6, d12); yer tutucu düz renk kutu + sayı.


### 17.2 Karakter değeri

- [x] **ZAR-02:** (Antigravity) Karakter değeri — kişiye göre taban zorluk. _(sanity bekliyor)_ — kişiye göre taban zorluk.
  - Ne: Her adlı karakterin `sorgu_degeri` vardır; d6 için 1–5, d12 için 2–10. Alan CHR sayfasının dördüncü bölümündedir ve `chr_parser.py` okur. Eksik alanda sınıfa göre varsayılan yazılır ve doğrulama 1 hata verir. Aynı ziyarette iki atış aynı tabanı kullanır. Adsız figür bu alanı kullanmaz.
  - Kurallar:
    1. Her CHR ve adlı karakterde `sorgu_degeri` vardır. d6 için 1–5, d12 için 2–10.
    2. Alan CHR şablonunun Bölüm 4 satırındadır. `chr_parser.py` okur.
    3. Eksik alanda sınıfa göre varsayılan yazılır ve `--check` hata verir. Yeni sayfa üretilmez.
    4. Aralık dışı değer dosyayı geçirmez. Varsayılan da aralık dışına yazılamaz.
    5. Adsız figür bu alanı kullanmaz. Onun zorluğu sınıf sabitidir.
  - Uç durumlar: d6 karakterde değer 6 yazılırsa 1 hata. Alan boşluğu yalnız adlı CHR ve adlı karakterde hatadır; adsız yirmilik diyalog bu hatayı üretmez. Parser bu alanı sayı okur, bina adı tahmin etmez.
  - Kabul: Bir CHR'den alan silinince `chr_parser.py --check` 1 hata verir (`tests/tools/test_chr_sorgu_degeri.py`). d12'de değer 1 yazılırsa 1 hata verir. Ek şart: aynı ziyarette iki atışın tabanı aynıdır.
  - Bağımlılık: ZAR-01. Boyut: S.
  - Dosya: `karakterler/CHR_*.md` Bölüm 4 satırı, `tools/chr_parser.py`.
  - Asset: asset gerekmedi.

### 17.3 Tansiyon

- [x] **ZAR-03:** (Antigravity) Tansiyon 10'u aşarsa karakter gider. _(sanity bekliyor)_
  - Ne: Başarısız zar tansiyonu seçenekte yazan kadar artırır; yazılmamışsa bir artar. Tansiyon onu aşarsa karakter kaçar ve karar "kaçtı" olur; ret sayacı artmaz. Konu değişince tansiyon sıfırlanmaz, veda sıfırlar. Menü açıkken değer değişmez. Başarılı zar, tansiyon ondayken karakteri kaçırmaz.
  - Kurallar:
    1. Başarısız zar tansiyonu seçenekte yazan kadar artırır. Yazılmamışsa +1’dir.
    2. Tansiyon 10’u aşarsa karakter ayrılır. Karar “kaçtı”dır. Kabul, ret, rüşvet ve kışla yazılmaz.
    3. Kaçış kişi hafızasına yazılır. Tanık varsa dedikoduya da yazılır (DIY-13).
    4. Tehlikeli karakter kaçarsa sonraki tehdit, duran tehdit sayacına yazar. Yeni sayaç yok.
    5. Tansiyon 10’dayken başarılı zar kaçırmaz. Kaçış, eşi aşan başarısız zar veya aynı eşi aşan başka artıştır.
  - Uç durumlar: panik kilidi (8–10) seçenek kapatır; kaçış ziyareti bitirir. İkisi aynı bayrak değildir. Kaçışta gösterilmemiş çelişki “çözülmedi” diye kalır (DYL-01). Tansiyon 10’da artış +0 olan başarısızlık kaçırmaz.
  - Kabul: Tansiyon 10, başarısız zar ve artış 1 iken karar "kaçtı" olur (`tests/unit/kapi/tansiyon_kacis_test.gd`). Tansiyon 10 ve başarılı zarda karakter durur. Ek şart: kaçış `ret_sayisi` artırmaz. Ek şart: eşik sayısı `data/ayarlar/denge.json` içindedir.
  - Bağımlılık: ZAR-01. Boyut: S.
  - Dosya: `src/kapi/sorgu_zari.gd`; karar akışına adaptör.
  - Asset: asset gerekmedi.


### 17.4 Yaklaşım

- [x] **ZAR-04:** (Antigravity) Yaklaşım türleri ve değiştiriciler. _(sanity bekliyor)_
  - Ne: Dört yaklaşım vardır: ikna, blöf, gözdağı ve gönül alma. Terazi, grup itibarı, kanıt, asker ve yorgunluk `gerekli` değeri en çok eksi üç ile artı üç arasında değiştirir. Zar atılmadan önce tutan her madde ayrı satırda görünür. Beşinci yaklaşım adı reddedilir. Kalp veya romans eşiği yoktur.
  - Kurallar:
    1. Dört yaklaşım vardır: ikna, blöf, gözdağı, gönül alma. Beşinci tür yazılamaz.
    2. Değiştiriciler: terazi (adil iken ikna ve gönül alma −1; yoz iken gözdağı −1), grup itibarı (uçta en çok ±1), bulunmuş kanıt −1, yanındaki asker gözdağı −1, yorgunluk +1.
    3. Eksi, `gerekli` değerini düşürür. Artı yükseltir. Toplam −3…+3 dışında kesilir.
    4. Zar öncesi liste her tutan maddeyi ayrı satır gösterir. Gizli değiştirici yoktur.
    5. Tablo `data/zar_degistiricileri.json` içindedir. Skor kaynağı KOP-06’daki mevcut terazidir.
  - Uç durumlar: asker yokken asker satırı listede hiç yazılmaz. İki kanıt ikinci −1 vermez; “bulundu mu” sayılır. Toplam −4 hesaplanırsa −3’e kesilir ve listede kesildiği yazar.
  - Kabul: Adil terazi ve bulunan kanıt ikna eşiğini 2 düşürür; asker iknaya yazmaz (`tests/unit/kapi/zar_degistirici_test.gd`). Yoz gözdağı 1 düşürür. Toplam eksi 4 hesaplanırsa eksi 3'e kesilir. Ek şart: kalp veya romans anahtarı 1 hata verir. Ek şart: Yorgunluk yaklaşım eki varsa yalnız zar değiştirici tablosundadır; yaşam kodu iç ek yazmaz.
  - Bağımlılık: ZAR-01, DIY-12. Boyut: M.
  - Dosya: yeni `src/kapi/zar_degistiricileri.gd`, `data/zar_degistiricileri.json`.
  - Asset: asset gerekmedi.

### 17.5 Beyaz ve kırmızı

- [ ] **ZAR-05:** Tekrar edilebilir ve tek şanslık kontroller.
  - Ne: Beyaz kontrol aynı koşul kümesiyle ikinci kez atılmaz; kanıt veya tansiyon bandı değişince yeniden açılır. Kırmızı kontrol bir kez atılır ve sonuç kalıcıdır; başarı da başarısızlık da dalı kapatır. Kod türü kendiliğinden değiştirmez. Menü açılıp kapanınca tekrar hakkı düşmez. Odak değişimi zarı yeniden atmaz.
  - Kurallar:
    1. Kontrol türü `tekrar` veya `tek_sans` olarak veride yazar.
    2. `tekrar` aynı koşul kümesiyle ikinci kez atılmaz. Koşul değişince (kanıt, tansiyon bandı veya güven eşiği) yeniden açılır.
    3. `tek_sans` kırmızı kenarlıdır, bir kez atılır, sonuç kalıcıdır. Yalnız sır ve ikilem düğümlerinde durur (DIY-10).
    4. Tek şansın başarısı da başarısızlığı da dalı kapatır. İkisi de ikinci kez açılmaz.
    5. Tür boşsa doğrulayıcı hata verir. Boş tür sessizce `tekrar` sayılmaz.
  - Uç durumlar: sır dışında yazılan `tek_sans` dosyayı geçirmez. Karakter kaçıp dönerse tek şans sonucu hafızada durur, düğüm açılmaz. `tekrar` kontrolünde zar 1 gelmişse koşul aynıyken düğme kilitlidir.
  - Kabul: Koşul değişmeden ikinci beyaz atış 0'dır; kanıt eklenince 1 atış daha açılır (`tests/unit/kapi/zar_tur_test.gd`). Sır dışında `tek_sans` 1 hata verir. Ek şart: menü açılıp kapanınca tekrar hakkı aynı kalır.
  - Bağımlılık: ZAR-01, DIY-10. Boyut: S.
  - Dosya: şema + `sorgu_zari.gd`.
  - Asset: asset gerekmedi.

### 17.6 Sezgi

- [x] **ZAR-06:** (Kalfa) Muhafız sezgisi — zarsız pasif kontrol.
  - Ne: Tecrübe ve geçmiş eşiği geçince ek bir satır kendiliğinden görünür; zar atılmaz. Eşik altındayken satır da ipucu da yoktur. Sezgi beyan değildir. Bir ziyarette en çok bir kez açılır. Sır çekirdeğinde her CHR'de en az bir sezgi satırı vardır.
  - Kurallar:
    1. Muhafız tecrübesi ve ACL-06 geçmişi eşiği geçince ek satır kendiliğinden görünür. Zar atılmaz.
    2. Eşik `data/` içindedir. Bakıştaki ek yorum (DYL-02) aynı eşiği kullanır. İkinci eşik yoktur.
    3. Sır çekirdeğinde her CHR’de en az 1 sezgi satırı vardır. Dürüst çekirdekte zorunlu değildir (DIY-01a).
    4. Eşik altındayken satır görünmez ve ipucu üretmez.
    5. Sezgi beyan değildir. İpucu üretirse `Clue_*` ile aynı anahtarı kullanır.
  - Uç durumlar: geçmiş o sezgiyi açmıyorsa satır gizlenir; genel sezgi varsa o gelir. Işık kapalıysa bakış sezgisi de gizlenir. Eşik eşitse satır görünür.
  - Kabul: Tecrübe eşiğin bir altındayken sezgi ipucu 0, eşitken 1'dir (`tests/unit/soz/sezgi_test.gd`). Zar çağrısı 0'dır. Ek şart: aynı ziyarette ikinci sezgi satırı 0'dır.
  - Bağımlılık: DIY-09, ACL-06. Boyut: S.
  - Dosya: yeni `src/soz/muhafiz_sezgisi.gd`.
  - Asset: asset gerekmedi.


CAT-01 … CAT-04 gövdesi durur. Yeni maddeler CAT-05 … CAT-84. Beşinci seçenek ve yeni ceza yoktur.


---

## BÖLÜM 18: Kapıda Çatışma ve Sonuçları (Faz 2)

### 18.1 Kavga ne zaman

- [x] **CAT-01:** Geri çevrilen kavga çıkarabilir. (Antigravity)
  - Ne: Yer yokluğu veya sert ret, tip listesindeki genç erkek, aç aile reisi ya da asker kaçağında kavga isteği doğurur. Kavga yalnız kapıda ve en az bir asker varken açılır. Asker yoksa kişi tehdit edip gider; tanık varsa bu gidiş dedikoduya yazılır. Köy meydanı, şifahane ve divanda kavga sahnesi yoktur. Heyet sırasında kavga açılmaz.
  - Kurallar:
    1. Kavga isteği iki koşulla doğar: yer yokluğu veya sert ret; karakter tipi genç erkek, aç aile reisi veya asker kaçağı. Tip veridedir.
    2. Kavga yalnız kapıda ve en az 1 asker varken açılır.
    3. Asker yoksa kişi tehdit edip gider. Tanık varsa bu gidiş dedikoduya yazılır (DIY-13). Kavga sahnesi açılmaz.
    4. Köy meydanı, şifahane ve divanda kavga sahnesi yoktur.
    5. Tip listesinde olmayan ret sıradan rettir. Zorunlu kavga seçeneği eklenmez.
  - Uç durumlar: asker kapıdan ayrılırsa açılmamış istek “tehdit edip gitti”ye döner. Sahne başlamışsa seçenekler kapanır ve sonuç kaçış sayılır. Aynı kişi aynı gün ikinci kavga isteği üretmez. Heyet sırasında (KOP-02) kavga açılmaz.
  - Kabul: Askersiz köyde kavga sahnesi 0'dır (`tests/unit/kapi/kapi_kavgasi_test.gd`). Tip listesinde olmayan rette kavga bayrağı 0'dır. Asker 1 ve tip uygunken bayrak 1'dir. Ek şart: yeni ses dosyası, kan efekti ve ikinci harita eklenmez.
  - Bağımlılık: ACL-05, DIY-13. Boyut: M.
  - Dosya: yeni `src/kapi/kapi_kavgasi.gd`.
  - Asset: asset gerekmedi.


### 18.2 Dört seçenek

- [x] **CAT-02:** Kavga seçenekleri — askerle karşılık, akçeyle erteleme, sözle yatıştırma, reddetme. (Antigravity)
  - Ne: Kapıdaki kavgada oyuncu dört yoldan birini seçer: askerle karşılık, akçeyle erteleme, sözle yatıştırma veya reddetme. Askerle karşılık zar atar ve yaralanma, ölüm, kaçış ya da kin bırakır. Akçe yetmezse erteleme kilitli görünür. Beşinci seçenek yoktur. Kalp alanı yazılmaz.
  - Kurallar:
    1. Dört seçenek vardır: askerle karşılık, akçeyle erteleme, sözle yatıştırma, reddetme. Beşinci seçenek yazılamaz.
    2. Askerle karşılık asker becerisi ve ZAR-01 kullanır. Sonuç yaralanma, ölüm, kaçış veya kindir. Sonuç tablosu veridedir.
    3. Akçeyle erteleme DYL-05 `yarin_gel` sözünü açar. Kişi 2–4 gün sonra döner. Söz tutulmazsa grup itibarı −1 olur. Akçe `muhafiz_akce` hesabından düşer.
    4. Yatıştırma ikna veya gönül alma zarıdır. Reddetme kin ve, tanık varsa, dedikodu yazar; kavga anında biter.
    5. Ölüm, duran nüfus ve cenaze akışına haber verir. Yeni cenaze sistemi kurulmaz.
  - Uç durumlar: akçe yetmezse erteleme kilitli görünür. Asker ölürse karşılık seçeneği kapanır, diğer üçü durur. Açık söz sayısı 5 ise (DYL-05) erteleme kilitlidir ve nedeni yazar. Kin ile kaçış ayrı kayıt kimliğidir.
  - Kabul: Dört seçenek dört ayrı sonuç kimliği üretir (`tests/unit/kapi/kavga_secenek_test.gd`). Erteleme `verilen_soz` kaydına 1 satır yazar. Ölüm cenaze akışına tek çağrı yazar. Ek şart: kalp anahtarı 1 hata verir. Ek şart: aynı seçeneğe iki tıkta sonuç bir kez yazılır.
  - Bağımlılık: CAT-01, ZAR-01, DIY-11. Boyut: M.
  - Dosya: `src/kapi/kapi_kavgasi.gd`.
  - Asset: kavga canlandırması için envantere `CAT02-KAVGA` animasyon; yer tutucu sarsıntı + metin.

### 18.3 Yaralı

- [x] **CAT-03:** Yaralının tedavisi — hekim varsa iyileştirir. (Antigravity)
  - Ne: Kavga yaralısı, bizden ya da yabancı, şifahane varsa hekime gider. Hekim varsa duran iyileşme akışı sağlığı yükseltir; hekim yoksa veya hekim kendisi yaralıysa kayıp sürer. Yabancı tedavi edilip gönderilirse grup itibarı bir artar ve köylü olmaz. Ölü hekime gitmez. Aynı yara ikinci gece bir daha iyileşmez.
  - Kurallar:
    1. Yaralı bizden veya yabancı olabilir. İkisi de Şifahane’ye gidebilir.
    2. Hekim varsa mevcut KRI-03 akışı iyileştirir. Hekim yoksa sağlık kaybı sürer. Yeni ilaç üretilmez.
    3. Yabancı yaralıyı tedavi edip göndermek grup itibarını +1 yazar.
    4. Şifahane `false` ise (DIY-08) tedavi seçeneği görünmez.
    5. Ölüm bu maddeye girmez. Ölü hekime gitmez.
  - Uç durumlar: hekim kendisi yaralıysa tedavi edemez; sağlık kaybı sürer. İki yaralı aynı gece varsa hekim birini seçer, diğeri bekler. Bekleyen yabancı gece ölürse itibar artışı yazılmaz. Tedavisi biten yabancı köylü olmaz, gider.
  - Kabul: Hekim ve şifahane varken sağlık deltası pozitiftir; hekim yokken kayıp sürer (`tests/unit/koy/hekim_yara_test.gd`). İtibar artışı yalnız "tedavi edip gönder"de 1'dir. Ek şart: aynı yara ikinci gece sağlık deltası 0'dır.
  - Bağımlılık: CAT-02. Boyut: S.
  - Dosya: `src/koy/hekim_ilac.gd` adaptör.
  - Asset: asset gerekmedi.


### 18.4 Sıranın korkusu

- [x] **CAT-04:** Kapıda şiddet sırayı korkutur. (Antigravity)
  - Ne: Askerle karşılık veya ölüm, sıradaki kişilerin tansiyonunu okur. Eşik üstündekiler tablodaki olasılıkla ayrılabilir; herkes ayrılmaz. Yatıştırma ve erteleme bu ayrılmayı tetiklemez. Yeni korku barı açılmaz. Menü açıkken artış donar.
  - Kurallar:
    1. Şiddet, karşılık veya ölüm sonucudur. Sıradaki kişilerin sabrı ve tansiyonu okunur.
    2. Tansiyonu eşik üstü olan sıradaki ayrılabilir. Eşik `data/` içindedir. Herkes ayrılmaz.
    3. Ayrılan kişi sonraki gün, tanık kuralıyla, dedikodu taşır (DIY-13).
    4. Yatıştırma ve erteleme şiddet sayılmaz. Ayrılma tetiklemez.
    5. Olasılık tabloyla sabittir. Kod içine gömülü oran yoktur.
  - Uç durumlar: sırada kimse yoksa ayrılma 0, dedikodu da 0’dır. Ayrılan kişi o ziyaretin konusuysa ikinci kez kaçmaz. Şiddet heyet sırasında olmaz (KOP-02). Tabloda olasılık 0 ise test ortamında da ayrılan 0’dır.
  - Kabul: Eşik altı sırada ayrılan 0'dır (`tests/unit/kapi/siddet_korkusu_test.gd`). Eşik üstü ve olasılık 1 olan satırda ayrılan 1'dir. Yatıştırmada ayrılan 0'dır. Ek şart: menü açılıp kapanınca tansiyon artışı değişmez.
  - Bağımlılık: CAT-02, BUG-20. Boyut: S.
  - Dosya: yeni `src/kapi/siddet_korkusu.gd`.
  - Asset: asset gerekmedi.


Amaç: Söz motorunu (Bölüm 16) ve yazım hattını (Bölüm 19) derinleştirmek. Burada yeni sistem kurulmaz. Her madde var olan bir sistemin üstüne oturur: beyan defteri, kişi hafızası, dedikodu, eş, gecikmeli etkiler, kapsam taraması. Hepsi önce `Roadmap-2/soz_agaci` prototipinde Yusuf sahnesiyle denenir. Prototipte işe yaradığı görülmeden Godot'a geçmez.

**Bölümün ortak kuralları (her maddede geçerli, tekrar yazılmaz):**
- Her sorgu eylemi (göstermek, bakmak, yemin ettirmek, tercüman çağırmak) sıra sabrından düşer (DIY-05). Bedava eylem yoktur.
- Her eylemin sonucu veri dosyasındadır; kod karakter adı veya metin bilmez.
- Her etki mevcut bir değere yazılır: tansiyon, güven (DIY-17), grup itibarı (DIY-12), muhafız terazisi ve vicdanı, eşin morali, kişi hafızası (DIY-11), dedikodu (DIY-13). Bu bölüm için yeni bir sayaç açılmaz.
- Yazım araçları gözlem verir, karar vermez. Uyarıyı yazar gerekçe yazarak geçebilir.
- Ses dosyası yoktur. Bütün araçlar metinle çalışır.

DYL-01 … DYL-16 gövdesi durur. Yeni maddeler DYL-17 … DYL-96. İkinci diyalog motoru yok.


---

## BÖLÜM 19: Söz İçeriği — Dünya Kitabı ve Karakterlerin Yeniden Yazımı (Faz 3)

<!-- BOLUM_HAZIR -->
# Kapı Muhafızı — ROADMAP 2 / Parça C

Parça C: yazım, iş, yapı bilgisi, yaşam barı, dünya zamanı, sevilen yüz. Bu dosya bölündükten sonra A döngüsü tarafından değiştirilmez.

**Madde biçimi:** `- [ ] **ÖNEK-NN:** Başlık — amaç.` Altında: **Amaç**, **Kurallar**, **Uç durumlar**, **Kabul** (ölçülebilir test), **Bağımlılık**, **Boyut**, **Dosya**, **Asset**.

**Ortak kurallar:** yeni dosya + ince adaptör; çekirdekte minimal ekleme; `koy_sahnesi` / statik `KoyYerlesimi` yok; ajan asset üretmez (uygun ve açık lisanslı asset kaynak ve lisansıyla eklenebilir; AGENTS.md asset kuralı), gereken asset satıra yazılır, yerine kutu veya düz renk konur. ROADMAP 1'de biten makine (salgın, mevsim, tüccar, divan mahkemesi, yozlaşma ağacı, bölge haritası, çift kasa, cenaze, gözcü kulesi, heybe ve ipucu motoru, tansiyon aralıkları, üretim zinciri) yeniden kurulmaz. Varsa adaptör yazılır.

Alınmayacaklar (ayrı sistem olmaz): kalp puanı, hediye takvimi, romans, seslendirme, ikinci harita.


İlke: oyun çalışırken yapay zekâ çağrılmaz. Metinler oyun dışında, dünya kitabına (RAG) dayanarak güçlü bir modelle yazılır, doğrulayıcıdan geçer, insan onayıyla veri olarak girer.

YAZ-01 … YAZ-10 gövdesi durur. Yeni maddeler YAZ-11 … YAZ-90. İkinci üslup belgesi ve ikinci doğrulayıcı yok.

### 19.1 Dünya kitabı

- [/] **YAZ-01:** (Claude — yazıldı, Ahmet + anlatı yönetmeni onayı bekliyor) Dünya kitabı — dönem bilgisi.
  - Ne: Oyuncu bu kitabı görmez; yazar ve doğrulayıcı görür. `docs/dunya_kitabi/` altında on dört konu dosyası durur: tarih, uç düzeni, Türkmen göçü, Bizans ve Rum köylüler, Ermeni ve Süryani toplulukları, Ahi, dervişler, ticaret ve kervansaray, köy ekonomisi, meslekler, giyim, yemek, inanç ve yemin, coğrafya. Her dosyada oyun metninin kullanacağı olgular ve boş olmayan bir `## Kaynaklar` listesi vardır. Anlatı yönetmeni ile Ahmet'in adları dosyanın sonunda durur. Kitap, salgın, mevsim, tüccar, divan, yozlaşma, bölge haritası, çift kasa, cenaze veya üretim için ikinci kural yazmaz.
  - Kurallar:
    1. `docs/dunya_kitabi/` altında konu başına bir dosya durur. Konu listesi şudur: tarih (Babai İsyanı 1240, Kösedağ 1243, sonrası Moğol tahakkümü), Selçuklu uç düzeni, Türkmen boyları ve göç, Bizans uç beyleri ve Rum köylüler, Ermeni ve Süryani toplulukları, Ahi teşkilatı, dervişler, ticaret yolları ve kervansaraylar, köy ekonomisi, meslekler, giyim, yemek, inanç ve yemin kalıpları, coğrafya (Sivas, Erzincan, Kayseri, Konya, Malatya). Bu 14 dosya kapanış sayısıdır.
    2. Her dosyada oyun metninin kullanacağı olgular ve bir `## Kaynaklar` listesi vardır. Kaynak satırı boş olan dosya onaylanmaz.
    3. Kitap, salgın, mevsim, tüccar, divan, yozlaşma, bölge haritası, çift kasa, cenaze veya üretim zinciri için ikinci bir kural yazmaz. Bu makineler `ROADMAP.md` içindedir; kitap yalnız onların dönem ağzını besler.
    4. Anlatı yönetmeni ve Ahmet onayı dosyanın sonunda iki isim olarak durur. Onaysız dosya YAZ-04 tarafından `data/soz/` altına alınmaz.
  - Uç durumlar: iki dosya aynı olguyu farklı yazarsa doğrulayıcı çifti listeler, oyuna ikisini birden sokmaz. Coğrafya dosyasında olmayan bir şehir adı karakter kartına yazılamaz. Kaynak uydurulmuşsa (künye yok) o satır yok hükmündedir.
  - Kabul: On dört dosyanın her birinde en az bir kaynak satırı ve iki isim vardır (`tests/tools/test_dunya_kitabi.py`). Kaynak başlığı silinen dosya sayımda 13 kalır ve YAZ-04 onu `data/soz/` altına kopyalamaz. İki dosya aynı olguyu çelişerek yazarsa doğrulayıcı çifti listeler ve ikisini de oyuna sokmaz. Coğrafya dosyasında olmayan şehir adı karakter kartında 1 hata verir. Ek şart: oyun kaydında dünya kitabı sürüm alanı yoktur.
  - Bağımlılık: yok. Boyut: L (içerik).
  - Dosya: yeni `docs/dunya_kitabi/*.md`.
  - Asset: asset gerekmedi.

- [ ] **YAZ-16:** Kitap çalışma anında okunmaz
  - Ne: Kitap çalışma anında okunmaz. `res://` altında `dunya_kitabi` 0.
  - Kabul: Export listesi 0. Test: KLT-22.
  - Bağımlılık: KLT-22. Boyut: S.
  - Dosya: `docs/dunya_kitabi/`
  - Asset: asset gerekmedi.

### 19.2 Üslup

- [ ] **YAZ-02:** Üslup rehberi — dönem dili, yaşayan dil.
  - Ne: Yazar tek üslup gövdesini okur: `Roadmap-2/USLUP_REHBERI.md`. Taslakta hitap, selam, yemin, ağız farkı ve modern söz yasağı vardır; oyun tarafında `data/soz/yasak_kelimeler.txt` henüz yoktur. Doğrulayıcı bu listeyi tarar. Yapaylık kuralları uyarıdır, satırı silmez. Sesli doğaçlama ham metindir; oyun paketine ve `data/soz/` altına girmez.
  - Kurallar:
    1. `docs/dunya_kitabi/USLUP.md` şunları taşır: hitap sözcükleri (ağam, beğim, bacı, ahi baba, efendi, ana, kardaş), selamlaşma, yemin ve dua kalıpları, ağız farkları (Türkmen, Rum, Ahi, derviş, levent), yasak kelime listesi, selam ölçüsü (en çok 2 cümle; ilk cevaplar kısa).
    2. Yapay kalıplar ve halk ağzı yapıları USLUP §1–2'deki listedir: vecize karşıtlığı, üçlü sıra, gerekçe bağlacı, soruya tam oturan cevap, tekdüze ritim, güzel kapanış; karşılarında devrik cümle, aktarılan söz, soruya soru, dolgu söz, yarım bırakma, kendini düzeltme, yan cevap. Yeni kalıp bu listeden ayrı icat edilmez.
    3. Yasak kelimeler `data/soz/yasak_kelimeler.txt` içine dökülür. YAZ-07 bu dosyayı tarar. USLUP §7'deki 14 yapaylık kuralı uyarıdır, satırı silmez.
    4. Yazım sırası USLUP §6'dır: özet, sesli doğaçlama, biçime sokma, denetim, inceleme. Model "kim bu insan" paragrafını ve doğaçlamayı yazmaz.
    5. Bu belgedeki hitap sözcüğü, YAZ-09'daki `hitap` alanının adı değildir. Biri "ağam" demektir, öbürü kadronun tekrar görme türüdür.
  - Uç durumlar: Rum veya Ermeni ağıza zorla "selamün aleyküm" yazılırsa doğrulayıcı uyarı verir. Seslendirme satırı, fonetik satırı ve ses dosyası yolu bu belgede yer almaz. Replik ölçüsü aşılırsa satır hatadır, sahne tamamı değil.
  - Kabul: Yasak liste, rehberdeki modern sözlerin hepsini taşır (`tests/tools/test_uslup_kapisi.py`). Listeye bilerek "aslında" konmuş bir replik 1 uyarı üretir ve satır silinmez. Rehberdeki yapaylık kuralı sayısı 14'tür. Ek şart: ikinci üslup dosyası onaylanmaz. Ek şart: doğaçlama taslağının yolu dışa aktarım listesinde yoktur.
  - Bağımlılık: YAZ-01. Boyut: M.
  - Dosya: yeni `docs/dunya_kitabi/USLUP.md`, `data/soz/yasak_kelimeler.txt`.
  - Asset: asset gerekmedi.

- [ ] **YAZ-20:** Yasak kalıp listesi §1'dir
  - Ne: KLT-04 aynı listeyi çağırır. Burada ikinci liste yazılmaz.
  - Kabul: Liste dosyası 1. Test: tarama.
  - Bağımlılık: KLT-04 Boyut: S.
  - Dosya: `Roadmap-2/USLUP_REHBERI.md`
  - Asset: asset gerekmedi.

- [ ] **YAZ-21:** Cümle kalıbı şablon değildir
  - Ne: Aynı bilgi iki ağızda aynı iskeletle yazılırsa kota ihlalidir.
  - Kabul: İki ağız aynı iskelet 1 uyarı. Test: inceleme.
  - Bağımlılık: YAZ-09 Boyut: S.
  - Dosya: `Roadmap-2/USLUP_REHBERI.md`
  - Asset: asset gerekmedi.

- [ ] **YAZ-22:** Hitap kota notudur
  - Ne: Hitap kota notudur. Hitap puanı diye alan açılmaz.
  - Kabul: `hitap_puani` 0. Test: tarama.
  - Bağımlılık: YAZ-09. Boyut: S.
  - Dosya: `Roadmap-2/USLUP_REHBERI.md`
  - Asset: asset gerekmedi.

- [ ] **YAZ-24:** İpucu metni üslup denetimine girer
  - Ne: `ogretici.` anahtarları YAZ-10'dan geçer.
  - Kabul: İhlal 0. Test: OGR-09.
  - Bağımlılık: OGR-09 Boyut: S.
  - Dosya: `data/metin/metinler.csv`
  - Asset: asset gerekmedi.

- [ ] **YAZ-25:** Teknik ayar metni üsluba girmez
  - Ne: `arayuz.girdi.*` ve `arayuz.ayarlar.*` diyalog taramasının dışındadır.
  - Kabul: Bu öneklerde üslup hatası 0 sayılır. Test: KLT.
  - Bağımlılık: GIR-22 Boyut: S.
  - Dosya: `Roadmap-2/USLUP_REHBERI.md`
  - Asset: asset gerekmedi.

- [ ] **YAZ-26:** Dönem dersi cümlesi reddedilir
  - Ne: Yıl numarası anlatan satır (1240, Kösedağ) karakter ağzında doğrulayıcı hatasıdır. Kitapta kalır.
  - Kabul: Ağızda yıl sayısı 1 hata. Test: fixtures.
  - Bağımlılık: YAZ-02 Boyut: S.
  - Dosya: `Roadmap-2/USLUP_REHBERI.md`
  - Asset: asset gerekmedi.


### 19.3 Ses kartı

- [ ] **YAZ-03:** Karakter ses kartı — her karakter için.
  - Ne: Yazar, 30 CHR ve 40 adlı kişi için birer ses kartı doldurur. Oyuncu kartı görmez. Kartta insan eliyle yazılmış bir paragraf, köken, ağız, konuşma alışkanlığı, dört yalan biçiminden biri, korku, istek, çekirdek ve bağlar durur. Paragraf boşsa kart geçmez. Alışkanlık cümlesi iki kartta tekrarlanırsa doğrulayıcı uyarı verir. Adsız sınıf şablonu bu yetmiş sayının dışındadır.
  - Kurallar:
    1. Kart sayısı 30 CHR + 40 adlı karakterdir. Dosya başına bir kişi.
    2. İlk alan, insan eliyle yazılmış "kim bu insan" paragrafıdır. Model bu paragrafı üretmez. Paragraf boşsa kart doğrulamadan geçmez.
    3. Zorunlu alanlar: köken, ağız, konuşma alışkanlığı, yalan biçimi, korktuğu şey, istediği şey, `cekirdek` (YAZ-09), varsa sır ve nedeni, `baglar`. Alışkanlık sıfat cümlesi olamaz; örnek ölçü "soruya önce yarım cevap verir, sonra düzeltir".
    4. Yalan biçimi şu dörtten biridir: sapma, aşırı ayrıntı, soruya soru, susma. Sırrı olmayan çekirdekte sır alanı boş kalır, uydurma sır konmaz.
    5. Bağlar tek alandadır (`baglar`). İkinci bir ilişki listesi açılmaz. Hafıza ve dedikodu bu alanı okur (YAZ-09).
  - Uç durumlar: adsız sınıf şablonu bu 70 kartın içinde sayılmaz (onlar YAZ-06). Aynı alışkanlık cümlesi iki kartta tekrarlanırsa doğrulayıcı uyarı verir. Köken, YAZ-01 coğrafyasında yoksa kart hata alır.
  - Kabul: Yetmiş kartın her birinde paragraf, bir yalan biçimi ve bir çekirdek vardır (`tests/tools/test_ses_karti.py`). Paragrafı silinen kart 1 hata verir. Eksik sayım raporda görünür. Ek şart: kartta `kalp` alanı 1 hata verir. Ek şart: eş kartında demirci, taşçı veya asker yazılırsa 1 hata verir. Ek şart: `kayit.json` içinde ses kartı alanı yoktur.
  - Bağımlılık: YAZ-01. Boyut: L (içerik).
  - Dosya: yeni `data/soz/ses_kartlari/*.json`.
  - Asset: asset gerekmedi.


- [ ] **YAZ-30:** İki kart aynı ağzı tarif edemez
  - Ne: Kör okuma DYL-11 skoru kart onayından önce durur.
  - Kabul: Skorsuz kart red. Test: KLT-05.
  - Bağımlılık: DYL-11 Boyut: S.
  - Dosya: `docs/soz/kor_okuma.csv`
  - Asset: asset gerekmedi.

- [ ] **YAZ-33:** Kart örnek cümle ister
  - Ne: Örnek satırı boş kart onaylanmaz. DYL-14.
  - Kabul: Boş örnek red. Test: KLT-14.
  - Bağımlılık: DYL-14 Boyut: S.
  - Dosya: `docs/soz/ses_kartlari/`
  - Asset: asset gerekmedi.

### 19.4 Üretim kapısı

- [ ] **YAZ-04:** Yazım hattı — model istemi, üretim, doğrulama, onay.
  - Ne: Yazar oyunun dışında bir aracı çalıştırır. Araç dünya kitabını, üslubu, ses kartını ve şemayı birlikte okur; biri eksikse durur. Çıktı şemaya çevrilir, inceleme raporu yazılır. İmzasız dosya `data/soz/` altına kopyalanmaz ve oyun onu yüklemez. Oyun sürecinde bu araca çağrı yoktur.
  - Kurallar:
    1. `tools/soz_yazim/` istemi dört parçayı birden okur: dünya kitabı, üslup, ses kartı, şema. Biri eksikse araç çalışmaz.
    2. Araç çıktıyı şemaya çevirir ve inceleme raporu yazar: yasak kelime, uzunluk, selamdan önce hikâye, eksik konu, çelişki çifti.
    3. Onay imzası dosyada durur: kim, tarih. İmzasız çıktı `data/soz/` altına kopyalanmaz. Oyun imzasız dosyayı yüklemez.
    4. Oyun sürecinde bu araca çağrı yoktur. Araç bir seferlik üretim içindir.
  - Uç durumlar: raporunda hata duran dosya imzalanabilir ama kopya adımı reddeder. Aynı karaktere ikinci üretim, eskisinin imzasını silmeden yeni dosya açmaz; üzerine yazmadan önce rapor farkını gösterir.
  - Kabul: İmzasız bir reçber çıktısı `data/soz/` altında 0 dosya bırakır; imzalı çıktı şema raporunda 0 hatayla durur (`tests/tools/test_soz_yazim.py`). İstemden dünya kitabı yolu çıkarılınca araç 1 hatayla durur. Ek şart: istem metninin yolu `res://` listesinde yoktur. Ek şart: yazım kapısı `tools/soz_kapi.py` tek kapı aracıdır; ikinci kapı dosyası yazılmaz. Ek şart: bir karakterin dosyası reddedilince komşu karakter dosyaları yerinde kalır.
  - Bağımlılık: DIY-01, YAZ-02, YAZ-03. Boyut: M.
  - Dosya: yeni `tools/soz_yazim/*.py`, `tools/soz_yazim/istem.md`.
  - Asset: asset gerekmedi.

- [ ] **YAZ-35:** Üretim sırası HAT belgesindedir
  - Ne: Kitap, taslak, yapaylık, kör okuma, kota, iki isim, `data/soz`. Atlanan adım kopyalanmaz.
  - Kabul: Atlanan adım 0 kopya. Test: KLT-01.
  - Bağımlılık: KLT-01 Boyut: S.
  - Dosya: `docs/soz/HAT.md`
  - Asset: asset gerekmedi.

- [ ] **YAZ-39:** Eski diyalog taşınmaz
  - Ne: DIY-16. Yan yana bakış DYL-13 kaydı olmadan 'taşındı' yazılmaz.
  - Kabul: Kayıtsız id hazır değil. Test: KLT-13.
  - Bağımlılık: DIY-16 Boyut: S.
  - Dosya: `docs/soz/HAT.md`
  - Asset: asset gerekmedi.

### 19.5 Pilot

- [ ] **YAZ-05:** Pilot: Sivaslı reçber ve iki karakter daha.
  - Ne: Oyuncu kapıda üç pilot ağzı duyar: Sivaslı reçber, çekirdeği tehlikeli yalan olan bir CHR ve bir adlı karakter. Üç dosyada varış ve karar vardır. Selam, yedi konu ve ikilem üç sahneye birden dayatılmaz. Sır düğümü en çok bir dosyadadır. Ahmet onay satırı yokken toplu yazım dalgası başlamaz.
  - Kurallar:
    1. Üç kişi: Sivaslı reçber, bir tehlikeli CHR (`cekirdek: tehlikeli_yalan`), bir adlı karakter.
    2. Şema tamdır: varış ve karar her sahnede vardır. Selam, yedi konu, sır evresi ve ikilem üç sahneye birden dayatılmaz. Reçber konu merkezli kalabilir; öbür iki sahne OZGUNLUK §4'ten, birbirinden farklı biçimdedir.
    3. Sır evresi yalnız çekirdeği bunu isteyen sahnededir. Pilot dosyalarının en çok birinde sır düğümü vardır.
    4. Üç dosyanın toplamında en az bir hafıza varyantı, bir mevsim veya kriz varyantı ve en az iki çelişki çifti vardır. Hepsi reçberde toplanabilir.
    5. Ahmet onay satırı yazılmadan YAZ-06 dalgası başlamaz.
  - Uç durumlar: üç sahne aynı açılış cümlesiyle başlarsa pilot tamam sayılmaz (ortak selam kalıbı "Selamün aleyküm" bu yasağın dışındadır). Onaysız dosya diskte durabilir, oyun onu yüklemez.
  - Kabul: Üç dosya şema hatasızdır; en az iki sahne biçimi kullanılır; sır düğümü en çok bir dosyadadır (`tests/tools/test_soz_pilot.py`). Sır düğümü iki dosyada birden duruyorsa kontrol 1 hata verir. Onay satırı yokken başlatılan toplu dalga 0 karakter yazar. Ek şart: üç pilot dosyasında ses dosyası yolu yoktur.
  - Bağımlılık: YAZ-04, DIY-02…DIY-11. Boyut: M.
  - Dosya: `data/soz/recber.json` ve iki pilot dosyası.
  - Asset: asset gerekmedi.

- [ ] **YAZ-45:** Pilot kapı fixtures'ına bağlanır
  - Ne: Pilot kapı fixtures'ına bağlanır. Üç id DYL-16 `--check` listesindedir.
  - Kabul: Üç id fark 0. Test: DYL-16.
  - Bağımlılık: DYL-16. Boyut: S.
  - Dosya: `data/soz/`
  - Asset: asset gerekmedi.

- [ ] **YAZ-47:** Pilot sır içermez
  - Ne: Pilot sır içermez. Üç dosyada zorunlu `sira` 0.
  - Kabul: Alan 1 hata. Test: KLT-03.
  - Bağımlılık: DIY-01a. Boyut: S.
  - Dosya: `data/soz/`
  - Asset: asset gerekmedi.

### 19.6 Toplu yazım

- [ ] **YAZ-06:** Toplu yeniden yazım — 30 CHR, 40 adlı karakter, adsız şablonlar.
  - Ne: Onaylı pilottan sonra yazar kadroyu onar kişilik dalgalarla yeniden yazar. Dalga, doğrulayıcı 0 hata ve insan onayı olmadan kapanmaz. Otuz CHR ve kırk adlı kişi kendi ses kartına bağlıdır; kartı olmayan kişi üretilmez. Adsız gelenler yedi dalganın dışındadır ve sınıf şablonu taşır. Aynı şablon kimliği iki adsızda tekrarlanmaz. Eski sohbet verisi bu dalgaya kopyalanmaz.
  - Kurallar:
    1. Dalga boyu 10 kişidir. Dalga, doğrulayıcı 0 hata ve insan onayı olmadan kapanmaz. Sonraki dalga öncekinin kapanışını bekler.
    2. 30 CHR ve 40 adlı karakter YAZ-03 kartlarına birebir karşılık gelir. Kartı olmayan kişi üretilmez.
    3. Adsız gelenler 70 kişinin dışındadır, yedi dalgaya sayılmaz. Sınıf başına en az 4 kişilik şablonu vardır. Aynı sınıftan iki kişi aynı şablon kimliğini taşımaz.
    4. Rapor, karakter başına düğüm, konu, çelişki ve ikilem sayısını yazar. Sır düğümü olmayan kişi raporda 0 sır olarak durur; bu bir hata değildir.
    5. Eski `SohbetVerisi` ve `diyalog_01_20.json` metinleri bu dalgaya kopyalanmaz (DIY-16).
  - Uç durumlar: dalga ortasında bir kartın çekirdeği değişirse o kişinin dosyası dalgadan düşer, yeniden onay bekler. Adsız havuzu 4 şablondan az bir sınıfla açılırsa o sınıfın üretimi durur, diğer sınıflar sürer.
  - Kabul: Yedi dalga sonunda 70 adlı veya CHR dosyası imzalıdır ve rapor satır sayısı 70'tir (`tests/tools/test_soz_dalga.py`). Aynı şablon kimliğini paylaşan iki adsız dosya 1 hata verir. Ek şart: toplu yazım `metinler.csv` içindeki eski anahtarı silmez, yeni anahtar ekler. Ek şart: onaylı paket tek seferde kopyalanır; yarım klasör oyun tarafından yüklenmez.
  - Bağımlılık: YAZ-05. Boyut: L (içerik).
  - Dosya: `data/soz/*.json`.
  - Asset: asset gerekmedi.

### 19.7 Doğrulama ve köy sohbeti

- [ ] **YAZ-07:** Söz doğrulayıcı ve önizleme aracı.
  - Ne: Geliştirici, söz dosyasını oyuna girmeden doğrular. Şema, kopuk düğüm, ulaşılamayan dal, eksik metin anahtarı, selam kuralı ve tek şansın birden çok yerde durması hatadır. On dört yapaylık kuralı uyarıdır ve sanity'yi kırmaz. ADM panelinden tek düğmeyle önizleme açılır; oyuncu menüsünde bu düğme yoktur. Önizleme karakteri, mevsimi, krizi, tansiyonu ve hafızayı seçer, ağacı yürütür ve kayıt dosyasına yazmaz.
  - Kurallar:
    1. `tools/soz_dogrula.py` sanity paketine tek satırla girer. Hata sayılanlar: şema, kopuk düğüm, ulaşılamayan dal, eksik metin anahtarı, selam kuralı, tek şanslık kontrolün birden çok yerde durması.
    2. Yasak kelime ve USLUP §7'deki 14 yapaylık kuralı uyarıdır. Uyarı sanity'yi kırmaz. Kararı insan verir.
    3. Oyun içi önizleyici ADM panelinden açılır: karakter seçilir, bağlam kurulur (mevsim, kriz, tansiyon, hafıza), ağaç yürütülür. Önizleme `son_karar`, kasa, nüfus ve kayıt dosyasına yazmaz.
    4. ADM paneline tek düğme eklenir. İkinci bir diyalog debug ekranı açılmaz.
  - Uç durumlar: yapaylık uyarısı olan sahne sanity'de geçer, YAZ-10 onayı onu ayrıca bekletir. Önizlemede atılan zar kayıtlı zar değeridir; canlı oyun zarını tüketmez.
  - Kabul: Kopuk düğümlü örnek dosya sanity'de 1 hata verir; bir yapaylık kuralını kıran satır 1 uyarı verir ve sanity hatası 0 kalır (`tests/tools/test_soz_dogrula.py`). Önizleme koşusundan sonra kayıt dosyasının `son_karar` alanı değişmez. Ek şart: önizleme çıktısında düz gömülü cümle yoktur; metin CSV anahtarının çevirisidir.
  - Bağımlılık: DIY-01. Boyut: M.
  - Dosya: yeni `tools/soz_dogrula.py`, `src/debug/soz_onizleme.gd`; `tools/sanity_check.py` tek satır; ADM paneline tek düğme.
  - Asset: asset gerekmedi.

- [ ] **YAZ-65:** Köy sohbeti söylentiyi okur
  - Ne: SOY-46. İkinci dedikodu cümlesi üretilmez.
  - Kabul: Konu varsa iki ağız farklı. Test: SOY-46.
  - Bağımlılık: SOY-46 Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

### 19.8 Kota ve inceleme

- [ ] **YAZ-08:** Köy içi sohbetler — köylüler de konuşur.
  - Ne: Oyuncu köyde bir köylü kartını açınca iş, aile, dert veya dedikodu başlığından satır okur. Yeni sohbet haritası veya ikinci sahne yoktur. Her CHR için en az üç köy satırı vardır. Satır, kapıdaki ret, kabul, verilen söz ve yüzleşilen yalanı okur; selam buna göre değişir. Köyde durmayan kişinin satırı yoktur. Dedikodu kendi haberini uydurmaz. Pilot üçlüsüne özel ikinci sahne yazılmaz. Aynı kapı düğümü köyde tekrar basılmaz. Bir günde bir konu açılır.
  - Kurallar:
    1. Konuşma köylü kartından açılır. Yeni bir sohbet haritası veya ikinci sahne yoktur.
    2. Konu başlıkları dörttür: iş, aile, dert, dedikodu. Her CHR için en az 3 köy satırı vardır.
    3. Satır, kapı hafızasını okur (`son_karar`, verilen söz, yüzleşilen yalan). Ret yemiş ve köyde durmayan kişinin köy satırı yoktur.
    4. Dedikodu satırı DIY-13 kaydına yazar. Fısıltı gazetesi bu kaydı okur; sohbet kendi haberini uydurmaz.
  - Uç durumlar: ölen kişinin satırı SEV-07 ile kapanır. Eşin akşam sohbeti (ACL-03) gece raporu öncesinde kalır; köy kartındaki dört başlık onun yerine geçmez. Çocuk çalışmadığı için iş başlığı boş kalır (UZM-08); boş başlık sohbeti kırmaz.
  - Kabul: Köydeki bir CHR kartından 3 satır açılır ve kapıdaki ret veya kabule göre selam değişir (`tests/unit/koy/koylu_sohbeti_test.gd`). Köyde olmayan CHR için satır sayısı 0'dır. Dedikodu satırı fısıltıya tanıksız yazılmaz. Ek şart: `koylu_sohbeti.gd` `koy_sahnesi` import etmez. Ek şart: üç pilot kimliği için ayrı bir köy sahnesi yoktur. Ek şart: kapı düğüm kimliği köy sohbetinde tekrar etmez. Ek şart: aynı gün ikinci konu açılmaz.
  - Bağımlılık: YAZ-06, DIY-13. Boyut: M.
  - Dosya: yeni `src/arayuz/koy_hud/koylu_sohbeti.gd`.
  - Asset: asset gerekmedi.

- [ ] **YAZ-70:** Kota raporu turda bir satırdır
  - Ne: Kota raporu turda bir satırdır. İkinci rapor yok.
  - Kabul: Kota raporu turda bir satırdır. Satır 1. Test: KLT-18.
  - Bağımlılık: KLT-18. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.

- [ ] **YAZ-74:** İnceleme sonucu kapıya yazılır
  - Ne: HAT.md kutusu. Yazılmadan dosya hazır sayılmaz.
  - Kabul: Kutusuz red. Test: KLT-01.
  - Bağımlılık: KLT-01 Boyut: S.
  - Dosya: `docs/soz/HAT.md`
  - Asset: asset gerekmedi.


### 19.9 Anahtar ve CSV

- [ ] **YAZ-09:** Hikâye çekirdekleri ve kadro özgünlük denetimi.
  - Ne: Doğrulayıcı kadroyu sayar. Her adlı kişide bir çekirdek vardır. Dürüst ile dinlenmek isteyen birlikte yaklaşık yüzde 40'tır; başka hiçbir çekirdek yüzde 15'i geçmez. Tek sahne biçimi yüzde 30'u geçmez. Hitap beş türden biridir ve puan tutmaz. Beş türün her biri en az bir adlı kişide bulunur; alışkanlık iki veya üç kişidir. Pilot dosyaları bu paydadadır. Kalp, hediye, romans veya seslendirme anahtarı hata verir.
  - Kurallar:
    1. `Roadmap-2/OZGUNLUK.md` esastır. Zorunlu evre yalnız varış ve karardır. `cekirdek` alanı zorunludur. Çekirdek sır değilse heybe ipucu şartı yoktur (DIY-01a).
    2. Çekirdek değerleri: dürüst, koruma yalanı, yanlış anlaşılma, bilmediği, abartma, başkasının sırrı, pazarlık, itiraf etmek isteyen, dinlenmek isteyen, tehlikeli yalan, hafif. Kota: dürüst + dinlenmek isteyen yaklaşık %40; başka hiçbir çekirdek %15'i geçmez. Tek sahne biçimi %30'u geçmez. Kadronun yarısından fazlası sır evresi kullanıyorsa uyarı çıkar. Dört benzersizlik ekseninde aynı iki karakter uyarıdır.
    3. `hitap` ayrı bir sistem değildir. Kişinin neden tekrar görülesi olduğunu söyler. Değerler: `saygi`, `sefkat`, `aliskanlik`, `agirlik`, `gulus`. USLUP'taki "ağam / beğim" sözcükleri bu alan değildir.
    4. Beş türün her biri en az bir adlı kişide bulunur. `aliskanlik` 2 veya 3 kişidir; SEV-02'nin zararsız, tekrar gelen yüzleri bunlardır. Tür puan tutmaz. Kadro dosyasında kalp puanı, hediye takvimi, romans metni veya seslendirme anahtarı varsa doğrulayıcı hata verir. Tür, kabul veya ret zarını değiştirmez.
    5. Türlerin anlamı yazım notudur. Saygı: sözü dinlenen kişi, kısa iş cümlesi. Şefkat: birine bakan veya birini kaybetmiş kişi, hal sorma. Alışkanlık: zararsız ve yine gelen. Ağırlık: oyuncunun kararı bu yüzde durur; ODA-09 vicdan kabusu yeniden yazılmaz. Gülüş: kapıyı hafifleten ağız; çekirdekle aynı alan değildir, `hafif` olmak zorunda değildir.
    6. `baglar` hafıza (DIY-11) ve dedikoduya (DIY-13) bağlanır. Yeni ilişki ekranı yoktur.
  - Uç durumlar: adsız şablonun `hitap` değeri yoktur; kota adlı kadroyu sayar. Yazar uyarıya gerekçe notu düşerse o uyarı geçilir, hata geçilmez. Kalp veya hediye anahtarı gerekçeyle de geçmez. Bir kişi hem sır çekirdeği hem gülüş taşıyabilir; sır kotası bundan ayrı sayılır.
  - Kabul: Örnek kadroda çekirdek kotası, beş türün varlığı ve `aliskanlik` sayısının 2–3 bandı doğru sayılır (`tests/tools/test_soz_kadro.py`). Bir tür silinince 1 uyarı çıkar. `kalp` veya `hediye` anahtarı 1 hata verir. Gerekçe notu çekirdek uyarısını düşürür, hata anahtarını düşürmez. Ek şart: üç pilot dosyası kota paydasına girer; pilotu dışarıda bırakan yüzde kabul edilmez.
  - Bağımlılık: YAZ-03, YAZ-07, DIY-01a. Boyut: M.
  - Dosya: yeni `tools/soz_kadro_denetimi.py`; `data/soz/kadro.json`.
  - Asset: asset gerekmedi.

- [x] **YAZ-75:** (Claude — YER-02 kuralı) Anahtar biçimi standarttır
  - Ne: Noktalı küçük harf. YER-02. İkinci standart yok.
  - Kabul: Biçimsiz 1 hata. Test: metin_dogrula.
  - Bağımlılık: YER-02 Boyut: S.
  - Dosya: `tools/metin_dogrula.py`
  - Asset: asset gerekmedi.

- [x] **YAZ-76:** (Claude — KLT-43 kuralı) Yer tutucu sayısı kodla eşittir
  - Ne: Yer tutucu sayısı kodla eşittir. `%s` `%d` farkı 1 hata.
  - Kabul: Yer tutucu sayısı kodla eşittir. Fark 1. Test: araç.
  - Bağımlılık: SYS-09. Boyut: S.
  - Dosya: `tools/metin_dogrula.py`
  - Asset: asset gerekmedi.

- [ ] **YAZ-77:** Boş Türkçe hücre hatadır
  - Ne: `en` boş olabilir, `tr` boş olamaz. YER-04.
  - Kabul: Boş tr 1 hata. Test: YER-04.
  - Bağımlılık: YER-04 Boyut: S.
  - Dosya: `data/metin/metinler.csv`
  - Asset: asset gerekmedi.

- [x] **YAZ-78:** (Claude — KLT-11 kuralı) Çift boşluk diyalog satırında da aranır
  - Ne: TST-0006 kuralı `sohbet.` önekine de bakar.
  - Kabul: Çift boşluk 1. Test: KLT-11.
  - Bağımlılık: KLT-11 Boyut: S.
  - Dosya: `data/metin/metinler.csv`
  - Asset: asset gerekmedi.

- [ ] **YAZ-79:** Kişi adı çevrilmez
  - Ne: YER-17. Ad hücresi ikinci dilde de aynı kalır.
  - Kabul: Farklı ad 1 uyarı. Test: YER-17.
  - Bağımlılık: YER-17 Boyut: S.
  - Dosya: `data/metin/metinler.csv`
  - Asset: asset gerekmedi.

- [x] **YAZ-80:** (Claude — SYS-09 biçim testi) CHR anahtar biçimi korunur
  - Ne: `CHR_XXX_DUGUM_YY` standardı. Yeni biçim reddedilir.
  - Kabul: Yeni biçim 1 hata. Test: standart.
  - Bağımlılık: SYS-09 Boyut: S.
  - Dosya: `docs/METIN_ANAHTAR_STANDARDI.md`
  - Asset: asset gerekmedi.

- [x] **YAZ-81:** (Claude) Yetim anahtar silinmeden belgelenir
  - Ne: Kullanılmayan anahtar listeye yazılır, CSV'den bu maddede silinmez.
  - Kabul: Silinen 0, liste 1. Test: diff.
  - Bağımlılık: SYS-09 Boyut: S.
  - Dosya: `data/metin/metinler.csv`
  - Asset: asset gerekmedi.


### 19.10 Sınır ve kapanış

- [ ] **YAZ-10:** İnceleme modu ve kapsam taraması.
  - Ne: Önizlemede yazar her satıra doğal, yapay veya yeniden yaz işaretini koyar. İşaretler JSON olarak dışa ve içe aktarılır. Metin değişince işaret "metin değişti" olur. Kapsam taraması kayıtlı tohumlarla ağacı yürütür, seçilmeyen satırı ve ulaşılmayan düğümü listeler. Oyuncu bu taramayı görmez. Yapay veya yeniden yaz işareti dururken ya da görünmeyen satır varken sahne onaya gitmez.
  - Kurallar:
    1. Önizlemede her satır üç işaretten birini alır: doğal, yapay, yeniden yaz. İşaretler JSON olarak dışa ve içe aktarılır.
    2. Metin değişince o satırın işareti "metin değişti" olur. Eski doğal işareti sessizce kalmaz.
    3. Kapsam taraması (`soz_dogrula.py --kapsam`) kayıtlı bağlam tohumlarıyla ağacı yürütür. Hiç seçilmeyen satırı ve ulaşılmayan düğümü listeler. Bu tarama oyuncunun karşısına çıkmaz.
    4. Sahne, yapay ve yeniden yaz işareti 0 iken ve kapsamda görünmeyen satır 0 iken onaya gider.
  - Uç durumlar: kapsam tohumu boşsa tarama "çalışmadı" der, sahneyi onaylı saymaz. İşaret dosyası sahne dosyasından ayrıdır; sahne silinince işaretler kimlikle eşleşmeyeni listeler, sessizce yok olmaz.
  - Kabul: Bir satır yapay işaretliyken onay adımı reddedilir (`tests/tools/test_soz_kapsam.py`). Metin değiştirilince işaret "metin değişti" olur. Bin tohumluk taramada ulaşılmayan bir düğüm listede 1 satırdır. Kapsam tohumu boşsa tarama sahneyi onaylı saymaz.
  - Bağımlılık: YAZ-07. Boyut: S.
  - Dosya: `src/debug/soz_onizleme.gd`; `tools/soz_dogrula.py --kapsam`.
  - Asset: asset gerekmedi.

- [ ] **YAZ-83:** Söz dosyası ikinci motor açmaz
  - Ne: Söz dosyası ikinci motor açmaz. YAZ içeriği DIY-02 motoruna girer.
  - Kabul: Yeni sınıf 0. Test: tarama.
  - Bağımlılık: DIY-02. Boyut: S.
  - Dosya: `data/soz/`
  - Asset: asset gerekmedi.

- [ ] **YAZ-87:** Kayıt metin gömmez
  - Ne: Konuşma cümlesi kayıtta anahtar olarak durur, düz metin olarak değil.
  - Kabul: Düz cümle alanı 0. Test: tarama.
  - Bağımlılık: KAY-04 Boyut: S.
  - Dosya: `data/soz/`
  - Asset: asset gerekmedi.


- [ ] **YAZ-89:** Göç optional alandır
  - Ne: Eski kayıt yeni söz dosyasını zorunlu tutmaz.
  - Kabul: Eski kayıtta söz dosyası alanı yoksa yükleme açılır ve yeni söz dosyası aranmaz (`tests/unit/sistemler/kayit_gocu_test.gd`).
  - Bağımlılık: KAY-04 Boyut: S.
  - Dosya: `src/sistemler/kayit_gocu.gd`
  - Asset: asset gerekmedi.


ISG-01 … ISG-03 gövdesi durur. Yeni maddeler ISG-04 … ISG-83. İkinci meslek ağacı yok.


---

## BÖLÜM 20: İş Gücü, Meslek Uyarısı ve Geçici İşler (Faz 4)

### 20.1 Kabul uyarısı

- [ ] **ISG-01:** Kabul anında meslek uyarısı.
  - Ne: Oyuncu kapıda birini kabul ederken, mesleğinin binası köyde yoksa karar panelinde bir uyarı satırı görür. Satırda meslek adı, eksik bina, nitelikli iş verilemeyeceği, günde 1 erzak ve geçici işteki verim yazar. Meslek ve bina adları `data/meslek_binalari.json` eşlemesinden gelir. Bina köydeyse veya kişinin mesleği yoksa satır çıkmaz. Uyarı kabulü kapatmaz. Eş bu panelde değildir. Uyarı kayda yazılmaz. Aynı satır köy ekranında ikinci kez basılmaz.
  - Kurallar:
    1. Uyarı karar panelindedir. Metin kalıbı: "Kumaşçı — dokuma tezgâhı yok. Nitelikli iş verilemez; günde 1 erzak yer, geçici işte %X verimle çalışır." Meslek ve bina adları `data/meslek_binalari.json` eşlemesinden gelir.
    2. "Günde 1 erzak" EKO-09 tüketimidir. Bu madde ikinci bir yeme bedeli yazmaz.
    3. "%X" ISG-02 tablosundaki geçici iş verimidir. UZM-03 bina–meslek çarpanı durur; uyarı o çarpanı değiştirmez.
    4. Bina köyde varsa uyarı satırı çıkmaz. Mesleği olmayan kişide satır çıkmaz.
  - Uç durumlar: birden çok mesleği olan kişide uyarı, eksik olan her bina için bir satırdır, en fazla eşleme dosyasındaki kadar. Eş (ACL-02) kendi meslek listesindedir; listede olmayan meslek ona yazılmaz. Bina inşa halindeyse uyarı "bina yok" sayılır, bitince satır kalkar.
  - Kabul: Atölyesiz köyde kumaşçı kabul panelinde 1 uyarı vardır; dokuma tezgâhı konunca uyarı 0'dır (`tests/unit/kapi/meslek_uyarisi_test.gd`). Erzak tüketimi uyarı açıkken de kapalıyken de gece başına 1 kalır. Uyarı açıkken kabul düğmesi kapalı değildir. Ek şart: `meslek_uyarisi.gd` `koy_sahnesi` import etmez. Ek şart: uyarı metninde kalp alanı yoktur ve yeni ses dosyası eklenmez. Ek şart: eş için bu satır çıkmaz. Ek şart: kayıt dosyasında uyarı alanı yoktur. Ek şart: köy ekranında aynı uyarı metni durmaz.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: yeni `src/kapi/meslek_uyarisi.gd`; meslek→bina eşlemesi `data/meslek_binalari.json`.
  - Asset: asset gerekmedi.


### 20.2 Geçici iş

- [ ] **ISG-02:** Geçici işler havuzu — boştakilere iş.
  - Ne: Oyuncu, binası olmayan yetişkini köylü kartındaki geçici işler sekmesinden bir işe yazar. İş listesi, verim ve yorgunluk `data/gecici_isler.json` içindedir. Gece bilançosunda her iş kendi kimliğiyle bir satırdır. Çocuk, yaralı ve o gece nöbet yuvasındaki kişi yazılmaz. Aynı kişi aynı gece iki işe yazılmaz. Havuz sırası kayda gömülmez. Atama, duran sürükleme kulpuyla yapılır; yeni atama penceresi açılmaz. Hediye anahtarı iş açmaz. İkinci meslek ağacı, köle sınıfı ve muhafız maaşı alanı açılmaz.
  - Kurallar:
    1. İş listesi `data/gecici_isler.json` içindedir: taş toplama (BUG-21 taş yatağı), çalı ve dal toplama (odun), su taşıma, hendek ve yol açma (mevcut inşaat hızına artı), inşaat yardımcılığı, gece bekçisine eşlik (mevcut güvenlik hesabına artı, yorgunluğa artı), yün eğirme (evde; uygun olan kadın veya yaşlı), ot ve mantar toplama (mevsimlik erzak), çocuk ve hasta bakımı.
    2. Her işin verimi ve yorgunluğu yalnız bu dosyadadır. Kodda sabit verim sayısı yoktur.
    3. Köylü kartında "Geçici işler" sekmesi vardır. Atama gece bilançosuna iş kimliğiyle ayrı satır yazar.
    4. Bu liste EKO-02…06 zincirini, ANI-03 su rutinini ve KRI-15 afyon toplamayı yeniden kurmaz. Ot ve mantar erzak yazar, afyon yazmaz. Taş toplama taş ocağı kurmaz.
  - Uç durumlar: çocuk ağır işe yazılmaz (UZM-08). Taş yatağı 0 ise taş toplama kapalıdır; diğer işler sürer. Mevsim ot vermiyorsa o iş 0 erzak yazar, hata vermez. Kişi aynı gece hem bina işinde hem geçici işte sayılmaz.
  - Kabul: Listedeki her iş, bir gece koşusunda bilançoda kendi kimliğiyle bir satır üretir (`tests/unit/koy/gecici_isler_test.gd`). Ot satırı afyon stokunu değiştirmez. Taş yatağı 0 iken taş satırı 0'dır. Ek şart: çocuk, yaralı ve nöbetçi ataması yoktur. Ek şart: aynı kişiye ikinci geçici iş yazılmaz. Ek şart: kayıtta havuz sıra alanı yoktur; sabah sıra yeniden kurulur. Ek şart: `koylu_surukleme_kulpu.gd` dışında yeni atama penceresi açılmaz. Ek şart: hediye anahtarı iş satırı açmaz. Ek şart: yeni meslek sınıfı adı ve `muhafiz_maas` yazımı yoktur. Ek şart: aynı tohumla iki gecede aynı kişinin geçici iş kimliği aynıdır. Ek şart: boşalan yuva, kışın donmuş tarladan yapılan kaydırma dışında ertesi sabah kendiliğinden dolmaz. Ek şart: işçisi olan bina yıkılınca o işçi boşa düşer ve yıkım koşusunda SCRIPT ERROR çıkmaz. Ek şart: köylü kartında iş adı metin tablosundan okunur; ekranda ham `chr_` ya da iş anahtarı görünmez. Ek şart: Çınar meclisi gecesinde geçici iş ve bina üretimi kesilmez; iş o gece biter.
  - Bağımlılık: BUG-21, YSM-01. Boyut: M.
  - Dosya: yeni `src/koy/gecici_isler.gd`; köylü kartına adaptör.
  - Asset: işlere özel el aleti envantere `ISG02-ALETLER`; yer tutucu ANI-11 kutu soketi.

- [ ] **ISG-13:** Havuz bina ister
  - Ne: Havuz bina ister. Bina yoksa iş yok. BUG-16.
  - Kabul: Havuz bina ister. İş 0. Test: BUG-16.
  - Bağımlılık: BUG-16. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

### 20.3 Boşta bedel

- [ ] **ISG-03:** Boşta kalma bedeli ve görünürlüğü.
  - Ne: Oyuncu köy HUD'unda "Boşta: N kişi" satırını görür. N, o gün binada ve geçici işte olmayan yetişkinleri sayar. Boşta kalanın morali duran memnuniyet değerinden düşer; düşüş miktarı veri dosyasındadır ve günde bir kez yazılır. Mesleği olan kişi üç gün üst üste boşta kalırsa köy sohbetinde terk cümlesi açılır; o gece köyden silinmez. İşe yazılınca sayaç sıfır olur. Çocuk, eş, hasta ve karantinadaki kişi boşta sayılmaz. Kış için ayrı bir bedel yoktur. Açlık çubuğuyla tek çubukta birleşmez.
  - Kurallar:
    1. HUD satırı "Boşta: N kişi"dir. N, o gün binada ve geçici işte olmayan yetişkinleri sayar.
    2. Boşta kalanın morali UZM-06 memnuniyetinden düşer. İkinci bir moral sayacı açılmaz. Düşüş miktarı veri dosyasındadır.
    3. Mesleği olan kişi 3 gün üst üste boşta kalırsa YAZ-08 sohbetinde terk cümlesi açılır. Cümle bir istektir; o gece kişiyi köyden silmez.
    4. Geçici işe veya binaya yazılınca sayaç o kişi için 0'a döner.
  - Uç durumlar: mesleksiz kişide terk cümlesi açılmaz. Çocuk ve eş sayaçta meslekli sayılmaz. Kişi 2. gün işe girerse 3. gün cümlesi yoktur. Hasta veya karantinadaki kişi boşta sayılmaz.
  - Kabul: Üç tam boş günün sonunda o kişinin köy sohbetinde 1 terk satırı vardır (`tests/unit/koy/bosta_kalma_test.gd`). İkinci gün geçici işe alınan kişide satır yoktur. HUD sayısı atama sonrası bir azalır. Ek şart: aynı kişiye aynı gün ikinci moral düşüşü yazılmaz. Ek şart: kış bedeli ayrı bir sayı değildir; çarpan mevsim kaydından okunur. Ek şart: boşta düşüşü açlık çubuğuna eklenip tek çubuk olmaz. Ek şart: "Boşta" sözcüğü HUD'a `metinler.csv` anahtarından gelir; kodda düz Türkçe sözcük yoktur.
  - Bağımlılık: ISG-02. Boyut: S.
  - Dosya: yeni `src/koy/bosta_kalma.gd`.
  - Asset: asset gerekmedi.

- [ ] **ISG-25:** Bedel ölçümü DEN satırıdır
  - Ne: Bedel ölçümü DEN satırıdır. Formül değişmez.
  - Kabul: Bedel ölçümü DEN satırıdır. Satır 1. Test: DEN.
  - Bağımlılık: DEN-05. Boyut: S.
  - Dosya: `src/sistemler/denge_olcumu.gd`
  - Asset: asset gerekmedi.

### 20.4 Atama kadrajı

- [ ] **ISG-30:** Yanlış binaya bırakmak iş yazmaz
  - Ne: Yanlış binaya bırakmak iş yazmaz. Bina meslek uymazsa geri döner.
  - Kabul: Yanlış binaya bırakmak iş yazmaz. İş 0. Test: birim.
  - Bağımlılık: ISG-01. Boyut: S.
  - Dosya: `src/arayuz/koy_atama_alani.gd`
  - Asset: asset gerekmedi.


- [ ] **ISG-32:** Atama duraklatta uygulanmaz
  - Ne: Atama duraklatta uygulanmaz. Delta 0.
  - Kabul: Atama duraklatta uygulanmaz. 0. Test: menü.
  - Bağımlılık: GIR-08. Boyut: S.
  - Dosya: `src/arayuz/ana.gd`
  - Asset: asset gerekmedi.

- [ ] **ISG-33:** Atama ipucu bir kez
  - Ne: Atama ipucu bir kez. OGR.
  - Kabul: Atama ipucu bir kez. İkinci 0. Test: OGR-07.
  - Bağımlılık: OGR-07. Boyut: S.
  - Dosya: `src/sistemler/ipucu_kaydi.gd`
  - Asset: asset gerekmedi.


- [ ] **ISG-35:** Atama klavye ile de bırakılır
  - Ne: Atama klavye ile de bırakılır. GIR. Fare şart değil.
  - Kabul: Atama klavye ile de bırakılır. Klavye 1. Test: GIR-06.
  - Bağımlılık: GIR-06. Boyut: S.
  - Dosya: `src/arayuz/koy_atama_alani.gd`
  - Asset: asset gerekmedi.


### 20.5 Üretim bağı

- [ ] **ISG-37:** Usta yokken çırak yarım üretir
  - Ne: TEZ-07. Bu madde ikinci çırak motoru açmaz.
  - Kabul: Çıktı TEZ tablosu. Test: TEZ-07.
  - Bağımlılık: TEZ-07 Boyut: S.
  - Dosya: `src/koy/tezgahta_gun.gd`
  - Asset: asset gerekmedi.

- [ ] **ISG-38:** Greve giden üretmez
  - Ne: `meslek_grevi.gd`. İş düşer, yeni grev motoru yok.
  - Kabul: Üretim 0. Test: birim.
  - Bağımlılık: ISG-02 Boyut: S.
  - Dosya: `src/koy/meslek_grevi.gd`
  - Asset: asset gerekmedi.

- [ ] **ISG-39:** Grev söylenti eşiğini SOY-34 okur
  - Ne: Grev söylenti eşiğini SOY-34 okur. İkinci eşik yok.
  - Kabul: Grev söylenti eşiğini SOY-34 okur. Eşik 1. Test: SOY-34.
  - Bağımlılık: SOY-34. Boyut: S.
  - Dosya: `src/koy/meslek_grevi.gd`
  - Asset: asset gerekmedi.

- [ ] **ISG-40:** Hastalık işi düşürür
  - Ne: Hastalık işi düşürür. KRI. Sağlık 0 ise üretim 0.
  - Kabul: Hastalık işi düşürür. 0. Test: birim.
  - Bağımlılık: YSM-02. Boyut: S.
  - Dosya: `src/koy/uretim.gd`
  - Asset: asset gerekmedi.

- [ ] **ISG-43:** Üretim ölçümü DEN'dedir
  - Ne: Üretim ölçümü DEN'dedir. Formül değişmez.
  - Kabul: Üretim ölçümü DEN'dedir. Diff 0. Test: DEN.
  - Bağımlılık: DEN-01. Boyut: S.
  - Dosya: `src/sistemler/denge_olcumu.gd`
  - Asset: asset gerekmedi.


### 20.6 Yer ve yıkım

- [ ] **ISG-44:** İş yeri ızgaradadır
  - Ne: İş yeri ızgaradadır. Hücre dışı atama 0. BUG-23.
  - Kabul: İş yeri ızgaradadır. 0. Test: BUG-23.
  - Bağımlılık: BUG-23. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **ISG-45:** Bina yokken yer tutucu iş yoktur
  - Ne: Bina yokken yer tutucu iş yoktur. İş 0.
  - Kabul: Bina yokken yer tutucu iş yoktur. 0. Test: BUG-16.
  - Bağımlılık: BUG-16. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

### 20.7 Kart

- [ ] **ISG-56:** İş ikonu Sanat'tan gelir
  - Ne: İş ikonu Sanat'tan gelir. Panel `load` açmaz.
  - Kabul: İş ikonu Sanat'tan gelir. load 0. Test: GRV-27.
  - Bağımlılık: GRV-27. Boyut: S.
  - Dosya: `src/arayuz/sanat.gd`
  - Asset: asset gerekmedi.

- [ ] **ISG-57:** İkon yoksa harf
  - Ne: İkon yoksa harf. Png inmez.
  - Kabul: İkon yoksa harf. png 0. Test: sayım.
  - Bağımlılık: ARY-05. Boyut: S.
  - Dosya: `src/arayuz/koy_atama_alani.gd`
  - Asset: asset gerekmedi.


### 20.8 Kayıt ve ölçüm

- [ ] **ISG-60:** Atama kaydı kişi üstündedir
  - Ne: Atama kaydı kişi üstündedir. Ayrı iş kayıt kökü yok.
  - Kabul: Atama kaydı kişi üstündedir. Kök 0. Test: tarama.
  - Bağımlılık: KAY-04. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **ISG-61:** Yükleme atamayı tekrar üretmez
  - Ne: Yükleme atamayı tekrar üretmez. Çift ürün 0.
  - Kabul: Yükleme atamayı tekrar üretmez. Delta 0. Test: SYS-02.
  - Bağımlılık: SYS-02. Boyut: S.
  - Dosya: `src/koy/uretim.gd`
  - Asset: asset gerekmedi.

- [ ] **ISG-62:** Eski kayıt işsiz sayılır
  - Ne: Eski kayıtta iş alanı yoksa kişi boşta sayılır ve yükleme açılır.
  - Kabul: Eski kayıtta iş alanı yoksa kişi boşta sayılır ve yükleme açılır (`tests/unit/sistemler/kayit_gocu_test.gd`).
  - Bağımlılık: KAY-04. Boyut: S.
  - Dosya: `src/sistemler/kayit_gocu.gd`
  - Asset: asset gerekmedi.

- [ ] **ISG-67:** İş ölçümü otuz günde bantta
  - Ne: Boşta oranı DEN. Sapınca formül kendiliğinden değişmez.
  - Kabul: Rapor 1. Test: DEN.
  - Bağımlılık: DEN-05 Boyut: S.
  - Dosya: `src/sistemler/denge_olcumu.gd`
  - Asset: asset gerekmedi.


### 20.9 Sınır


- [ ] **ISG-73:** Çocuk çırak yaşı UZM-04'tür
  - Ne: Çocuk çırak yaşı UZM-04'tür. ISG yaş icat etmez.
  - Kabul: Eşik 1 kaynak. Test: UZM-04.
  - Bağımlılık: UZM-04. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

### 20.10 Kapanış

- [ ] **ISG-77:** Geçici iş menüsü ayarlarda değildir
  - Ne: Geçici iş menüsü ayarlarda değildir. AYR oyun sekmesi iş atamaz.
  - Kabul: Geçici iş menüsü ayarlarda değildir. Atama 0. Test: ayar.
  - Bağımlılık: AYR. Boyut: S.
  - Dosya: `src/arayuz/ayarlar_ekrani.gd`
  - Asset: asset gerekmedi.

- [ ] **ISG-78:** Tezgâh yüzü TEZ'dedir
  - Ne: Tezgâh yüzü TEZ'dedir. ISG sipariş cümlesi yazmaz.
  - Kabul: Tezgâh yüzü TEZ'dedir. Cümle 0. Test: TEZ-02.
  - Bağımlılık: TEZ-02. Boyut: S.
  - Dosya: `src/koy/tezgahta_gun.gd`
  - Asset: asset gerekmedi.

- [ ] **ISG-80:** Divan iş cezası yazmaz
  - Ne: Divan iş cezası yazmaz. CAS üçlü karar.
  - Kabul: Dördüncü 0. Test: CAS-07.
  - Bağımlılık: CAS-07. Boyut: S.
  - Dosya: `src/kapi/divan_hukmu.gd`
  - Asset: asset gerekmedi.


YAP-01 … YAP-06 gövdesi durur. Yeni maddeler YAP-07 … YAP-86. Yeni bina türü ve yeni seviye sayısı yok.


---

## BÖLÜM 21: Yapı Kilidi, Ustalar, Usta Defterleri ve Yapı Resimleri (Faz 4)

### 21.1 Kademe

- [ ] **YAP-01:** Yapı kademeleri — her şey baştan açık değil.
  - Ne: Oyuncu inşa menüsünde kilitli yapıyı gri görür ve satırda gereken bilgiyi okur. Kademe tablosu `data/koy/yapi_kademeleri.json` içindedir. K0 baştan kurulabilir. K1 ve üstü, yapı bilgisi yokken kurulamaz. K0–K3, duran bina seviyesinin üretim çarpanını değiştirmez. Bedel `koy.tres` dizisinden okunur. Bedel yetmezse düğme kapalıdır. Kademe atlanmaz. Yıkım kademeyi sıfırlar. Kilitli yapıda yerleştirme hayaleti çıkmaz. İş gücü, kapı kararı, divan hükmü ve olay kartı kademe açmaz. Yeni bina türü eklenmez. İşçi yokken inşaat günü ilerlemez.
  - Kurallar:
    1. Kademe tablosu `data/koy/yapi_kademeleri.json` içindedir. K0: çadır, tarla, taş yatağı, odun yığını. K1: kulübe, hızarhane, taş ocağı, ambar. K2: taş ev, sur 2, değirmen, şifahane. K3: sur 3, konak, gelişmiş atölyeler.
    2. Kilitli yapı inşa menüsünde gri durur. Satırda gereken bilgi yazılır: "Gerekli: duvarcı ustası".
    3. ADM-08 bina seviyesi (üretim çarpanı, yatak ve depo artışı, sur hasarı) durur. K0–K3 o seviyeyi değiştirmez. UZM-11 çırak / kalfa / usta kişinindir, yapının kademesi değildir.
    4. K0 baştan kurulabilir. K1 ve üstü YAP-02 bilgisi olmadan kurulamaz.
  - Uç durumlar: tabloda olmayan bir bina K0 sayılır ve menüde kilitlenmez; doğrulayıcı bunu uyarı olarak listeler. Sur hasarı yalnız surdadır (ADM-08); kademe normal binaya hasar alanı açmaz.
  - Kabul: K2 satırı, bilgi yokken kurulamaz ve menüde gri "Gerekli" yazar (`tests/unit/koy/yapi_kilidi_test.gd`). Aynı binanın ADM-08 seviyesi kilit yüzünden değişmez. Ek şart: bedel `.gd` sabiti değildir; yetmeyen bedelde düğme kapalıdır ve borçla kurulum olmaz. Ek şart: ikinci kademe yokken üçüncü kademe kurulamaz. Ek şart: yıkılan binanın kademesi sıfırdır. Ek şart: kilitli yapıda hayalet yerleşim görünmez. Ek şart: `yapi_kilidi.gd` `koy_sahnesi` import etmez ve ikinci harita açılmaz. Ek şart: yeni bina kimliği yoktur. Ek şart: kapı ekranı, divan hükmü ve olay kartı kademe açmaz. Ek şart: aynı tohumla iki yeni oyunda kilit listesi aynıdır. Ek şart: kademe ikonu üretilmez; yer tutucu harf veya duran kart kullanılır. Ek şart: işçi yokken inşaat kalan günü azalmaz. Ek şart: inşaat kış çarpanını mevsim kaydından okur; ayrı kış inşaat sayısı yoktur. Ek şart: işçi hastaysa inşaat sayacı o gün azalmaz. Ek şart: yapı kartının uzun metni kayar; son satır kesilmez. Ek şart: yarım kalan inşaat kayıttan yüklenince aynı kademe ve aynı kalan günle sürer. Ek şart: `sur_taksiti` kademe tablosundan bağımsızdır; kademe açılınca taksit davranışı değişmez. Ek şart: kapı kararı bina kurmaz; kurulum yalnız köy ekranından yapılır.
  - Bağımlılık: yok. Boyut: M.
  - Dosya: yeni `src/koy/yapi_kilidi.gd`; `BinaKatalogu` sorgusuna tek satır.
  - Asset: asset gerekmedi.


### 21.2 Bilginin kaynağı

- [ ] **YAP-02:** Yapı bilgisinin kaynakları — usta, muhafız geçmişi, çırak.
  - Ne: Oyuncu yapı bilgisini üç yoldan biriyle açar: o bilgiye sahip usta köyde yaşıyorsa, seçilen muhafız geçmişi tabloda o yapıyı taşıyorsa, ya da çırak usta olmuşsa. Usta ölür veya ayrılırsa yeni inşaat kapanır; ayaktaki yapı durur. Çırak usta olduysa kilit geri gelmez ve yeni usta kaydı doğmaz. Geçmişin açtığı yapılar `data/yapi_bilgisi.json` içindedir. Bilgi bayrağı kişi kaydında optional alandır. İkinci yetenek ağacı açılmaz. Bilgi takası akçe istemez.
  - Kurallar:
    1. Yapı açılır: o bilgiye sahip usta köyde yaşıyorsa; muhafızın seçtiği geçmiş o bilgiyi taşıyorsa (ACL-06); veya çırak UZM-11 ile usta olduysa.
    2. Usta ölür veya köyden ayrılırsa yeni inşaat kapanır. Ayakta duran yapı durur.
    3. Çırak usta olmuşsa bilgi köyde kalır. Usta gittikten sonra kilit geri gelmez.
    4. Bilgi bayrağı `Koylu` üzerinde optional alandır. İkinci bir yetenek ağacı açılmaz.
  - Uç durumlar: geçmişin açtığı bilgi, o geçmiş seçilmeden kayıtta durmaz. Aynı yapıyı hem geçmiş hem usta açıyorsa bayrak tektir. Usta köye gelir ama kabul edilmezse bilgi açılmaz.
  - Kabul: Usta ayrılınca kilit geri gelir; aynı köyde çırak usta olmuşsa kilit gelmez (`tests/unit/koy/yapi_bilgisi_test.gd`). Geçmiş o yapıyı biliyorsa usta hiç gelmeden yapı kurulabilir. Tabloda olmayan geçmiş yapı açmaz. Ek şart: usta ölünce yeni usta kaydı doğmaz. Ek şart: bilgi takasında akçe deltası sıfırdır.
  - Bağımlılık: YAP-01, ACL-06. Boyut: M.
  - Dosya: yeni `src/koy/yapi_bilgisi.gd`; ustalık verisi `Koylu` (optional alan).
  - Asset: asset gerekmedi.

- [ ] **YAP-20:** Bilgi kayda optional yazılır
  - Ne: Yapı bilgisi kayda optional yazılır. Eski kayıtta alan yoksa yapılar kilitli başlar ve yükleme açılır.
  - Kabul: Eski kayıtta bilgi alanı yoksa yükleme açılır ve kilitli yapılar kilitli kalır (`tests/unit/sistemler/kayit_gocu_test.gd`).
  - Bağımlılık: KAY-04. Boyut: S.
  - Dosya: `src/sistemler/kayit_gocu.gd`
  - Asset: asset gerekmedi.


### 21.3 Usta

- [ ] **YAP-03:** Ustalar kapıdan gelir — özel karakterler.
  - Ne: Oyuncu kapıda bir usta görür. Kimlerin geleceği `data/ustalar.json` içindedir; ağırlık köy çekiciliğini ve dünya olayını okur, ikinci bir gelen zarı açılmaz. Kabul pazarlığı ücret, ev ve aile başlıklarındadır. Ücret kamu kasasından düşer, kişisel keseden düşmez. Test tohumunda bir K2 ustası 28 günde en az bir kez gelir. Ret yiyen usta bilgi açmaz. Aynı usta ikinci gelişinde aynı bilgiyi yeniden açmaz.
  - Kurallar:
    1. Kimler geleceği `data/ustalar.json` içindedir. Geliş ağırlığı köy çekiciliğini (KAP-16: refah, güvenlik, yatak) ve dünya olayını (DNY) okur. Bu madde ikinci bir gelen zarı açmaz.
    2. Her ustanın kendi söz ağacı vardır (YAZ-05 hattı). Kabul pazarlığı üç başlıktır: ücret, ev, yanında gelen aile. Ücret kamu kasasından düşer (EKO-01 `koy_akce`). Kişisel kese bu ücretin kaynağı değildir.
    3. Aile, KAP-17 kafilesi olarak yatak sayar. KAP-17 yokken aile, ustanın kaydındaki kişi sayısıdır ve aynı yatağı tüketir.
    4. Test tohumunda bir K2 ustası 28 günde en az bir kez kapıya gelir. Oyuncunun her oyununda bu garanti değildir; ağırlık veridedir.
  - Uç durumlar: yatak doluyken pazarlık metni ACL-05 uyarısını gösterir; oyuncu yine de kabul edebilir, fazla kişi açıkta kalır. Usta ret yerse bilgi açılmaz ve aynı tohumda aynı gün yeniden kuyruğa eklenmez.
  - Kabul: Tohumlu 28 gün koşusunda K2 ustası geliş sayısı en az 1'dir (`tests/unit/kapi/usta_gelisi_test.gd`). Kabul edilen ücret `koy_akce` düşer, `muhafiz_akce` aynı kalır. Ek şart: aynı usta ikinci ziyarette bilgi deltası sıfırdır. Ek şart: usta kaydında kalp alanı 1 hata verir.
  - Bağımlılık: YAP-02, KAP-16, YAZ-05. Boyut: M.
  - Dosya: yeni `src/kapi/usta_gelisi.gd`, `data/ustalar.json`.
  - Asset: usta modelleri envantere `YAP03-USTALAR`.


- [ ] **YAP-24:** Usta adsız şablon değildir
  - Ne: Usta adsız şablon değildir. Adlı dosya. KOP-10 adsız kalanı açmaz.
  - Kabul: Adsız usta 0. Test: KOP-10.
  - Bağımlılık: KOP-10. Boyut: S.
  - Dosya: `data/soz/`
  - Asset: asset gerekmedi.

- [ ] **YAP-28:** Usta çocuğu çırak olabilir
  - Ne: Usta çocuğu çırak olabilir. Yaş UZM-04. Erken çırak 0.
  - Kabul: Usta çocuğu çırak olabilir. Erken 0. Test: UZM-04.
  - Bağımlılık: UZM-04. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **YAP-29:** Usta nöbet tutmaz
  - Ne: Usta nöbet tutmaz. NBT asker ister.
  - Kabul: Usta nöbet tutmaz. Atama 0. Test: NBT-02.
  - Bağımlılık: NBT-02. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.


### 21.4 Defter ve resim

- [ ] **YAP-04:** Usta defterleri ve yapı resimleri — ganimetten gelen bilgi.
  - Ne: Oyuncu sefer, pusu, baskın veya tüccar ganimetinde bir defter, yapı resmi veya örnek eşya görür. Eşya envanterdedir. Yapı kilidi, çözümleme bitmeden açılmaz. Aynı defter kimliği ikinci kez düşünce yığın bir kalır. Defter yeni eşya sınıfı açmaz; duran heybe kaydına yazılır. Metin bir resim dosyası değildir. Oyuncu metninde bu eşya "şematik" diye anılmaz.
  - Kurallar:
    1. Defter, yapı resmi veya örnek eşya şu duran akışların ganimetine yazılır: dış sefer, pusu temizliği (HAR-05, HAR-14), baskın sonrası, tüccar (TUC). Yeni tüccar takvimi açılmaz.
    2. Eşya envanterde görünür. Yapı kilidi ancak YAP-05 çözümlemesi bitince açılır.
    3. Aynı defter kimliği ikinci kez düşerse yığın 1 kalır, ikinci kilit açmaz.
  - Uç durumlar: tüccar her uğrayışta defter bırakmaz; ağırlık tablodadır. Tablo satırı olmayan bir ganimet defter üretmez. Defter, çözümleme bitmeden satılırsa kilit açılmaz.
  - Kabul: Ganimet tablosundaki bir satır envantere bir defter yazar ve ilgili yapı o an kilitli kalır (`tests/unit/koy/usta_defterleri_test.gd`). Aynı kimlik iki kez düşünce envanter sayısı 1'dir. Ek şart: yeni eşya sınıfı yoktur. Ek şart: defter metni için yeni png üretilmez. Ek şart: defter kaydı yeni ses dosyası eklemez. Ek şart: oyuncu metninde "şematik" geçmez; ad usta defteri ya da yapı resmidir.
  - Bağımlılık: YAP-01. Boyut: M.
  - Dosya: yeni `src/koy/usta_defterleri.gd`, `data/usta_defterleri.json`.
  - Asset: defter ikonu envantere `YAP04-DEFTER`.


- [ ] **YAP-37:** Defter sözü DYL-08 ile dönebilir
  - Ne: Defter sözü DYL-08 ile dönebilir. İkinci dönüş motoru yok.
  - Kabul: Defter sözü DYL-08 ile dönebilir. Dönüş 1. Test: DYL-08.
  - Bağımlılık: DYL-08. Boyut: S.
  - Dosya: `src/soz/soz_motoru.gd`
  - Asset: asset gerekmedi.

- [ ] **YAP-38:** Defter kaydı optional
  - Ne: Defter kaydı optional'dır. Eski kayıtta alan yoksa yükleme açılır.
  - Kabul: Eski kayıtta defter alanı yoksa yükleme açılır ve envanterde defter aranmaz (`tests/unit/sistemler/kayit_gocu_test.gd`).
  - Bağımlılık: KAY-04. Boyut: S.
  - Dosya: `src/sistemler/kayit_gocu.gd`
  - Asset: asset gerekmedi.


### 21.5 Çözümleme

- [ ] **YAP-05:** Çözümleme işi — araştırma.
  - Ne: Oyuncu K1 çözümleme odasında bir defteri araştırır. Oda yoksa iş başlamaz. Süre ve sonuç `data/usta_defterleri.json` içindedir. Sonuç, duran sistemlerden birine tek çarpan yazar. Aynı anda tek çözümleme vardır. Biten iş köyde tek satır bildirir. Bedel tek kaynaktır. Kış çarpanı mevsim kaydından okunur.
  - Kurallar:
    1. İş, K1 çözümleme odasında yapılır. Oda yoksa iş başlamaz. Oda kataloga tek satır olarak girer.
    2. Süre ve sonuç `data/usta_defterleri.json` içindedir. Örnek sonuçlar, duran sistemlere yazar: Horasan harcı sur hasarına (ADM-08, yalnız sur); Rum usulü su değirmeni mevcut değirmen üretimine (EKO-04); Türkmen keçesi kış odun tüketimine (EKO-09); uzun menzilli yay mevcut savunma formülüne (HAR-15). Yeni savaş, yeni mevsim ve yeni değirmen binası açılmaz.
    3. Aynı anda tek çözümleme vardır. İkincisi kuyrukta bekler.
  - Uç durumlar: çözen kişi ölürse gün sayacı durur, defter envanterde kalır, ilerleme silinmez. Oda yıkılırsa iş durur. Süre 0 gün yazılmışsa doğrulayıcı o satırı hata sayar.
  - Kabul: Tablodaki süre dolunca tek hedef sistem değişir ve defter çözüldü olur (`tests/unit/koy/cozumleme_test.gd`). İkinci defter aynı gün başlatılamaz. Süre ile sonuç tablo değeriyle aynıdır. Ek şart: biten iş ikinci sahne açmaz, bildirim bir satırdır. Ek şart: ikinci akçe düşüşü yoktur. Ek şart: ayrı kış araştırma sayısı yoktur. Ek şart: çözümleme işçisi işten alınırsa gün sayacı durur; ilerleme silinmez, işçi dönünce kaldığı yerden sürer.
  - Bağımlılık: YAP-04. Boyut: M.
  - Dosya: yeni `src/koy/cozumleme.gd`; çözümleme odası katalog satırı.
  - Asset: çözümleme odası modeli envantere `YAP05-ODA`.


- [ ] **YAP-40:** Çözümleme işçisi yetişkindir
  - Ne: Çözümleme işçisi yetişkindir. Çocuk 0.
  - Kabul: Çözümleme işçisi yetişkindir. 0. Test: UZM-08.
  - Bağımlılık: UZM-08. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **YAP-46:** Çözümleme ölçümü DEN satırıdır
  - Ne: Çözümleme ölçümü DEN satırıdır. Formül değişmez.
  - Kabul: Çözümleme ölçümü DEN satırıdır. Satır 1. Test: DEN.
  - Bağımlılık: DEN-05. Boyut: S.
  - Dosya: `src/sistemler/denge_olcumu.gd`
  - Asset: asset gerekmedi.


### 21.6 Özel eşya

- [ ] **YAP-06:** Özel eşyalar.
  - Ne: Oyuncu en az sekiz özel eşyadan birini çözer. Her satırda ad, dünya kitabı kaynak notu ve tek hedef sistem vardır. Hedef, oyunda duran bir kapıdır. Bir eşya iki kapıya yazamaz. Etki, o kapının gece hesabına tek çarpandır. Çözülmüş eşya satılınca açılmış kademe geri kapanmaz. Eşya çocuk heybesinden de okunur; ikinci kayıt açılmaz. İkon `Sanat` üzerinden gelir; yeni png üretilmez.
  - Kurallar:
    1. `data/ozel_esyalar.json` en az 8 satırdır. Her satırda ad, YAZ-01 kaynak notu ve tek `hedef_sistem` vardır.
    2. `hedef_sistem` oyunda duran bir kapıdır: sur hasarı, değirmen üretimi, kış odun tüketimi, savunma formülü, erzak, sağlık, güvenlik. Listede olmayan bir kapı doğrulayıcıda hatadır.
    3. Bir eşya iki kapıya birden yazamaz. Etki, o kapının mevcut gece hesabına tek çarpandır.
  - Uç durumlar: kaynak notu boş olan satır sayılmaz, 8 eşiği onu beklemez. Aynı eşya iki kez çözülürse çarpan bir kez uygulanır.
  - Kabul: Sekiz satırın her biri dolu kaynak notu ve tek kapı taşır (`tests/unit/koy/ozel_esyalar_test.gd`). İki kapılı bir satır 1 hata verir. Aynı eşya iki kez çözülürse çarpan bir kez uygulanır. Ek şart: satıştan sonra kademe açık kalır. Ek şart: çocuk heybesindeki eşya ayrı bir kayıt açmaz. Ek şart: eşya ikonu yeni png üretmez.
  - Bağımlılık: YAP-05, YAZ-01. Boyut: M.
  - Dosya: yeni `src/koy/ozel_esyalar.gd`, `data/ozel_esyalar.json`.
  - Asset: eşya ikonları envantere `YAP06-ESYA`.

- [ ] **YAP-51:** Eşya açıklaması anahtardır
  - Ne: Eşya açıklaması anahtardır. Düz cümle 0.
  - Kabul: Eşya açıklaması anahtardır. 0. Test: SYS-09.
  - Bağımlılık: SYS-09. Boyut: S.
  - Dosya: `data/metin/metinler.csv`
  - Asset: asset gerekmedi.

- [ ] **YAP-53:** Eşya kavga ganimeti olabilir
  - Ne: Eşya kavga ganimeti olabilir. CAT ayrı eşya sınıfı açmaz.
  - Kabul: Eşya kavga ganimeti olabilir. Sınıf aynı. Test: CAT.
  - Bağımlılık: CAT-02. Boyut: S.
  - Dosya: `src/kapi/`
  - Asset: asset gerekmedi.

- [ ] **YAP-54:** Eşya ölçümü DEN'de değildir
  - Ne: Eşya ölçümü DEN'de değildir. Nadir olay. Bant zorlanmaz.
  - Kabul: Zorunlu bant 0. Test: belge.
  - Bağımlılık: DEN-01. Boyut: S.
  - Dosya: `data/yapi_bilgisi.json`
  - Asset: asset gerekmedi.


### 21.7 Kart

- [ ] **YAP-55:** Yapı kartı tema zemini ister
  - Ne: GRV dosya maddesi. Bu madde kural değiştirmez.
  - Kabul: Renk 0. Test: GRV.
  - Bağımlılık: ARY-02 Boyut: S.
  - Dosya: `src/arayuz/koy_hud/yapi_karti.gd`
  - Asset: asset gerekmedi.

- [ ] **YAP-60:** Eksik anahtar kartı düşürmez
  - Ne: Kilit metninin anahtarı yoksa kart nötr sebep gösterir ve açık kalır.
  - Kabul: Eksik kilit anahtarında kart açık kalır ve nötr sebep satırı görünür (`tests/unit/koy/yapi_karti_test.gd`).
  - Bağımlılık: SYS-09. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/yapi_karti.gd`
  - Asset: asset gerekmedi.

- [ ] **YAP-61:** Kart köy hızını değiştirmez
  - Ne: Kart köy hızını değiştirmez. Açık kart scale aynı.
  - Kabul: Kart köy hızını değiştirmez. Fark 0. Test: hız.
  - Bağımlılık: TEK-22. Boyut: S.
  - Dosya: `src/arayuz/koy_ekrani.gd`
  - Asset: asset gerekmedi.

- [ ] **YAP-62:** Kart 3B modeli değiştirmez
  - Ne: Kart 3B modeli değiştirmez. SAH. Mesh diff 0.
  - Kabul: Kart 3B modeli değiştirmez. 0. Test: tarama.
  - Bağımlılık: SAH. Boyut: S.
  - Dosya: `src/koy/gorsel/`
  - Asset: asset gerekmedi.


### 21.8 İnşaat

- [ ] **YAP-70:** İnşaat ölçümü DEN satırıdır
  - Ne: İnşaat ölçümü DEN satırıdır. Süre bandı. Formül değişmez.
  - Kabul: İnşaat ölçümü DEN satırıdır. Satır 1. Test: DEN.
  - Bağımlılık: DEN-05. Boyut: S.
  - Dosya: `src/sistemler/denge_olcumu.gd`
  - Asset: asset gerekmedi.


YSM-01 … YSM-03 gövdesi durur. Yeni maddeler YSM-04 … YSM-83. İkinci açlık sayacı ve kişi barı HUD'u yok.


---

## BÖLÜM 22: Yaşam Barları ve Köylü Davranışı (Faz 4)

YSM-01 … YSM-03 gövdesi durur. Yeni maddeler YSM-04 … YSM-83. İkinci açlık sayacı ve kişi barı HUD'u yok.

### 22.1 Üç değer

- [x] **YSM-01:** (testx) Köylü başına açlık, yorgunluk, moral barı.
  - Ne: Her köylünün kendi açlık sayacı, yorgunluk kaydı ve moral sayısı vardır; köy ortalaması ikinci çubuk açmaz. Açlık, üst üste erzak payı alınamayan gece sayısıdır ve pay EKO-09'un kişi başı gece 1 erzakıdır. Yorgunluk UZM-14 gece vardiyası kaydıdır; gece uykusu aynı kaydı düşürür. Moral UZM-06 memnuniyetidir, ikinci bir moral sayısı yoktur. Üç değer köylü kartında ve ANI-14 yüzen kartında okunur. Erzak 3'ün altındaki sağlık düşüşü KRI-12'dedir; bu madde o eşiği yeniden yazmaz. Eş aynı üç alanı kullanır, dördüncü şerit açılmaz.
  - Kabul: Erzaksız bir geceden sonra o köylünün açlık sayısı 1 artar; pay düşünce sayaç 0'a döner (`tests/unit/koy/yasam_test.gd`). Yüzen kartta çizilen yaşam değeri 3'tür. Ölen kişide bar çizilmez. Değer kaydı olmayan eski kayıtta açlık 0'dan başlar ve bir sonraki sabah dolar. KRI-12 sağlık düşüşü, bar çiziliyken de çizilmezken de aynı kalır. Ek şart: Kişi morali halk, ordu, soylu veya tüccar barına yazılmaz; `barlar.gd` dört bar olarak kalır. Ek şart: Köy HUD'unda kişi barı ve ortalama çubuk açılmaz. Ek şart: Üç değer kişi kaydındadır; ayrı `yasam.json` kökü yazılmaz. Ek şart: Yükleme aynı gecenin açlık artışını ve yorgunluk düşüşünü ikinci kez uygulamaz. Ek şart: Aynı tohumla iki koşu, aynı kişide aynı açlık artışını ve aynı yorgunluk düşüşünü yazar. Ek şart: Tek kişinin açlığı, yorgunluğu veya morali bir köy barını kırmaz. Ek şart: Olay kartı açlık sayacına yazmaz; sayaç yalnız gece payından artar. Ek şart: Kapı kabulü açlık sayacını o anda değiştirmez; pay hesabı gece çözümündedir. Ek şart: Oyuncunun açlık alanı yoktur; muhafız yorgunluğu UZM-14 kaydıdır. Ek şart: Moral 0 kişiyi köyden kaçırmaz; kaçış mevcut sağlık eşiğindedir. Ek şart: `yasam_barlari.gd` `koy_sahnesi` import etmez, ikinci harita açmaz, kalp alanı yazmaz ve hediye moral sayısını doldurmaz.
  - Bağımlılık: yok. Boyut: M.
  - Dosya: yeni `src/koy/yasam_barlari.gd`, `src/arayuz/koy_hud/yasam_barlari_paneli.gd`.
  - Asset: bar ikonları envantere `YSM01-IKON`.


### 22.2 Açlık kademesi

- [ ] **YSM-02:** Açlığın kademeli etkisi.
  - Ne: Açlık üç kademedir ve eşikler `data/koy/aclik_kademeleri.json` içindedir. Bir gün üretim çarpanı 0.80'dir. İki gün çarpan 0.50 olur ve yürüyüş yavaşlar. İki günü aşan kişi evde yatar, iş satırı yazmaz ve hastalık riski artar. Çarpan, UZM-03 ve ADM-08 hesabının üstüne tek çarpan olarak biner; `uretim.gd` içindeki `aclik_verim` bu tablonun yerine geçer, ikinci çarpan açılmaz. Hastalık riski mevcut sağlık yöneticisine yazılır, yeni salgın dalgası çıkmaz.
  - Kabul: 1. günde üretim çarpanı 0.80, 2. günde 0.50'dir; 3. günde kişi iş satırı yazmaz ve salgın sayacı kendiliğinden artmaz (`tests/unit/koy/yasam_test.gd`). Gece payı düşünce sayaç 0'a döner ve çarpan 1 olur. Eşik dosyasında gün sayısı yoksa o kademe uygulanmaz. Yatan kişiye geçici iş yazılmaz. Ek şart: Kademe kartta tok, aç veya bitkin kelimesiyle yazılır; 0–100 sayısı basılmaz. Ek şart: Tok kişide gece sağlık artışı `iyilesme` alanından bir kez okunur; aç kademesinde bu artış 0'dır. Ek şart: Aç kademesinde moral düşüşü `aclik_moral` alanından okunur; bu sayı `.gd` içine yazılmaz. Ek şart: Aynı gecede şifahane iyileşmesi de varsa yalnız büyük olan yazılır. Ek şart: Açlık yeni ölüm türü açmaz; sağlık 0 olan kişi KRI-05 cenaze akışına bir kez girer. Ek şart: Zindan payı bitince yeni hastalık açılmaz; sağlık düşüşü yalnız açlık kademesindedir.
  - Bağımlılık: YSM-01. Boyut: S.
  - Dosya: yeni `src/koy/aclik_kademesi.gd`; ANI rutinlerine tek satır.
  - Asset: asset gerekmedi.


### 22.3 Uyku

- [ ] **YSM-03:** Gece evde uyku, gündüz dinlenme.
  - Ne: Yataklı evde uyuyan kişinin yorgunluğu veri dosyasındaki tam miktar kadar düşer. Yatağı olmayan açıkta uyur ve düşüş tam miktarın yarısıdır; yarım dosyada yazılır, koda gömülmez. Gündüz ateş başı ve boşta durmak yorgunluk düşürmez; dinlenme adımı yalnız gece uykusudur. Gece vardiyasına yazılan kişi o gece uyumaz ve düşüş 0'dır. Yorgunluk, kaza riskine UZM-12 ve UZM-14 hesabıyla eklenir; ikinci bir kaza zar tablosu açılmaz.
  - Kabul: Aynı yorgunlukla yatan iki kişiden yataklı olanın düşüşü, açıkta kalanın düşüşünün iki katıdır (`tests/unit/koy/yasam_test.gd`). Gündüz ateşte duran kişide yorgunluk değişmez. Ev varken yatak doluysa fazla kişi açıkta sayılır. Ölen kişi uyku satırı yazmaz. Ek şart: Kayıtta uyku alanı yoksa kişi dinlenmiş sayılmaz; açılış bir sonraki gece hesabına bırakılır. Ek şart: Yeni uyku ses dosyası eklenmez. Ek şart: Oyuncunun nöbet yorgunluğu ertesi gün evde uyuyunca silinir; ayrı bir yorgunluk alanı açılmaz.
  - Bağımlılık: YSM-01, ACL-05. Boyut: S.
  - Dosya: yeni `src/koy/uyku_dinlenme.gd`.
  - Asset: asset gerekmedi.


### 22.5 Kart

### 22.6 Kayıt

### 22.8 Söz ve nöbet

### 22.10 Kapanış

DNY-01 … DNY-04 gövdesi durur. Yeni maddeler DNY-05 … DNY-84. İkinci harita ve altıncı son yok.


---

## BÖLÜM 23: Zamanla İlerleyen Dünya (Faz 5)

### 23.1 Çizelge

- [ ] **DNY-01:** Dünya zaman çizelgesi.
  - Ne: `data/dunya/zaman_cizelgesi.json` altı olayı sırayla taşır: Moğol ilerleyişi, Selçuklu taht kavgası, Bizans uç baskısı, kıtlık yılı, salgın dalgası ve ticaret yolunun kapanması. Her olayın erken söylenti, kesin haber ve etki evresi vardır; evre günü mevcut mevsim yılının içindedir ve bu madde yeni bir yıl uzunluğu yazmaz. Moğol günleri HAR-02 sayacından okunur, çizelge ikinci bir kalan gün tutmaz. Etki evresi gelince çağrı DNY-03'edir; çizelge bar, kasa veya nüfus değiştirmez.
  - Kabul: Üç mevsim yılı boyunca altı olay, dosyadaki sırayla üç evreyi de gezer (`tests/unit/sistemler/dunya_test.gd`). HAR-02 kalan günü ile çizelgedeki Moğol günü aynı sayıdır ve çizelgede ayrı sayaç alanı yoktur. İki olay aynı gün etki evresine gelirse o gece tek etki yazılır, öbürü ertesi geceye kalır. Kayıt olayın ortasında açılırsa evre kaldığı günden sürer. Ek şart: Çizelge yılı `.gd` içine gömülmez; günler `zaman_cizelgesi.json` içindedir. Ek şart: Dünya kitabı olgusuyla çelişen satır 1 doğrulama hatası verir ve o olay düşmez. Ek şart: Aynı olay kimliği ikinci kez düşmez. Ek şart: Eski kayıtta işaret listesi yoksa liste boş başlar ve geçmiş geceler zorla işletilmez. Ek şart: Mevsim değişince olay günü kaymaz. Ek şart: Aynı tohumla iki koşu aynı olay kimliğini aynı günde düşürür. Ek şart: Kayıt, işaret kimliklerinin listesidir; cümle metni gömülmez. Ek şart: `dunya_zamani.gd` `koy_sahnesi` import etmez ve ikinci harita açmaz. Ek şart: Divan hükmü çizelge işaretine yazmaz; üçlü karar ROADMAP 1 CAS-07'de durur.
  - Bağımlılık: YAZ-01. Boyut: M.
  - Dosya: yeni `src/sistemler/dunya_zamani.gd`.
  - Asset: asset gerekmedi.


### 23.2 Haber

- [ ] **DNY-02:** Haber önce insanlardan duyulur.
  - Ne: Erken söylenti ve kesin haber, "Yolda ne gördün" konusunda ve köy dedikodusunda durur. Etki evresinden önce aynı olay için en az iki ayrı karakter satırı vardır; satırlar YAZ içeriğidir ve birebir aynı olamaz. Dedikodu DIY-13 üzerinden fısıltıya gider; bu madde gazete üretmez. Gözcü ertesi günkü kafileyi söyler, dünya haberi gözcü kulesinden açılmaz. O gün kapıya kimse gelmezse söylenti bir sonraki gelişe kalır ve etki evresi öne çekilmez.
  - Kabul: Etki evresinden önceki pencerede aynı olay için en az 2 satır vardır ve bu satırlar birbirinin kopyası değildir (`tests/unit/sistemler/dunya_test.gd`). Gözcü özeti açıkken dünya olay satırı sayısı artmaz. Köyde konuşacak kimse yoksa satır 0'dır ve etki DNY-01 gününü bekler. Ek şart: Salgın haber satırı hastalık yöneticisini çağırmaz; çağrı etki evresindedir. Ek şart: Karar işaretinin kişi dosyasında dalı yoksa o işaret yalnız yazılı haberde kalır. Ek şart: Boş günde yazılı haber satırı durur ve silinmez; yüz o gece gelmez. Ek şart: Aynı tohumla iki koşu aynı haber satırını aynı günde üretir. Ek şart: Yeni haber ses dosyası eklenmez.
  - Bağımlılık: DNY-01, DIY-03, DIY-13. Boyut: M.
  - Dosya: `src/soz/baglam_sorgusu.gd` alanı; içerik YAZ.
  - Asset: asset gerekmedi.

### 23.3 Köy etkisi

- [ ] **DNY-03:** Olayların köye etkisi.
  - Ne: Her olayın tek kapısı dosyada yazılıdır. Moğol ilerleyişi tehdit kapısına (HAR-02), Selçuklu taht kavgası gelen akışına (KAP-16), Bizans uç baskısı haraca (HAR-03), kıtlık yılı tüketime (EKO-09), salgın dalgası sağlık yöneticisine ve ticaret yolunun kapanması fiyata (TUC-09) yazılır. Kıtlık yılı KRI-06'ya ikinci kez yazmaz. Salgın yeni hastalık türü açmaz, kıtlık yeni isyan kurmaz, yol kapanması yeni pazar kurmaz. KAP-16 göç dalgası kendi zarının üstüne ikinci kez atılmaz; bu maddenin çarpanını okur.
  - Kabul: Altı olayın her biri bir etki testinde tam bir kapıya yazar (`tests/unit/sistemler/dunya_test.gd`). İki kapılı bir olay satırı doğrulayıcıda 1 hatadır. Salgın olayından sonra hastalık türü sayısı değişmez. Kapısı listede olmayan olay bar değiştirmez ve raporda "yazılmadı" der. Gece raporunda etki, olay kimliğiyle tek satırdır. Ek şart: Etki mevcut `OlayVerisi` alanlarına yazılır; şemaya yeni anahtar eklenmez. Ek şart: Aynı olay kimliğinin etkisi bir kez yazılır; yükleme bu etkiyi ikinci kez uygulamaz.
  - Bağımlılık: DNY-01, KAP-16. Boyut: M.
  - Dosya: yeni `src/sistemler/dunya_etkisi.gd`.
  - Asset: asset gerekmedi.

### 23.4 Kararın dönüşü

- [ ] **DNY-04:** Oyuncunun kararları dünyaya geri döner.
  - Ne: Çizelgeye geri dönen kararlar üçtür: Tekfur haracı (HAR-03), Moğol elçisi ve Türkmen beyiyle ittifak (HAR-07). Başka karar bu dosyaya kendiliğinden yazılmaz. Karar, sonraki olayın koşul alanına girer. Nihai sonlar SYS-20 bu kaydı okur; altıncı son açılmaz. Karar verilmemiş durum `bekliyor` değeridir; boş alan sonraki olayı düşürmez ve "karar yok" dalını kullanır. Aynı karara iki kez basılırsa kayıt son değeri tutar. Heyet konuşması KOP-02'dedir; ikinci bir heyet diyaloğu yazılmaz.
  - Kabul: İki farklı karar dizisi, aynı tohumda iki farklı olay sırası üretir (`tests/unit/sistemler/dunya_test.gd`). SYS-20 son kimliği beş değerden biri olarak kalır. `bekliyor` ile biten kayıt açılır. Ek şart: Aynı gecede çizelgeye en çok bir karar işareti yazılır. Ek şart: Haraç, elçi ve ittifak kayıtlarında kabul ile ret ayrı koşul dalıdır. Ek şart: Kapıdaki kabul düğmesi dünya işaretini karar saymaz; işaret yalnız bu üç kayıttan yazılır. Ek şart: Türkmen ittifak isteği, aynı kişinin ikinci ziyareti dört geceden önceyse açılmaz. Ek şart: Kalp alanı yazılmaz.
  - Bağımlılık: DNY-01. Boyut: M.
  - Dosya: `src/sistemler/dunya_zamani.gd`.
  - Asset: asset gerekmedi.

### 23.5 Duran hatlar

### 23.6 Kadraj


### 23.7 Takvim sınırı

### 23.8 Kayıt

### 23.9 Sınır


### 23.10 Kapanış

Nöbet devri ayrı dosyada Bölüm 26 olarak durur (`ROADMAP_2_BOLUM_26.md`). Bu başlık 11 Ekim 2026'da 25a oldu. Kimlikler SEV-01…07 değişmedi.

Oyun favoriyi seçmez. Aynı koşullar her çekirdekte çalışır. Burada yeni bir ekonomi, harita, romans veya kalp sayacı yoktur. Her madde duran bir sistemin üstüne oturur.

SEV-01 … SEV-07 gövdesi durur. Yeni maddeler SEV-08 … SEV-87. Kalp, romans ve hediye takvimi yok.


---

## BÖLÜM 24: Arayüz, Görsel Dil ve Yükleme Ekranları (Faz 6)

### 24.1 Şablon seçimi

- [/] **ARY-01:** (Claude — şablonlar hazır, Berk + Ahmet seçimi bekliyor) Görsel dil için örnek şablonlar — Berk ve Ahmet seçer.
  - Ne: Üç şablon, sorgu, harita ve köylü kartı yer tutucusunda açılır; oyun sahneleri bu maddede değişmez. Her şablonda renk, çerçeve, yazı tipi ailesi, dört düğme durumu ve panel dokusu yazılıdır. Seçim `docs/arayuz/SABLONLAR.md` içine iki isimle yazılır. Seçim yoksa `tema.gd` renk değiştirmez ve `src/arayuz/tema/` oluşmaz. Doku ve yazı tipi üretilmez; yer tutucu `StyleBoxFlat`tır. Önizleme `ana.tscn` yerine geçmez.
  - Kurallar:
    1. Üç şablonun her birinde renk, çerçeve, yazı tipi ailesi, düğme durumları (normal, üstünde, basılı, kapalı) ve panel dokusu yazılıdır.
    2. Her şablon üç yer tutucu ekranda durur: sorgu, harita, köylü kartı. Oyun ekranlarının kendisi bu maddede değişmez.
    3. Seçim `docs/arayuz/SABLONLAR.md` içine yazılır. Seçim yoksa ARY-02 başlamaz.
    4. Doku ve yazı tipi üretilmez. Yer tutucu `StyleBoxFlat`tır.
  - Uç durumlar: iki şablon aynı renk çiftini kullanırsa üçüncüsü ayrışmak zorundadır, belge bunu not eder. Seçim boş bırakılırsa önizleme sahnesi açılır, oyun teması değişmez.
  - Kabul: Önizleme sahnesinde üç şablon, sorgu, harita ve kart yer tutucusunda açılır (`src/arayuz/tema_onizleme.tscn`). Belgede bir seçim satırı ve dört düğme durumu vardır. Seçim satırı boşken `tema.gd` renk değiştirmez ve `src/arayuz/tema/` altında dosya 0'dır. Ek şart: `project.godot` ana sahnesi bu maddede değişmez. Ek şart: iki şablon aynı renk çiftini kullanırsa belge üçüncüsünü ayırır.
  - Bağımlılık: yok. Boyut: M.
  - Dosya: yeni `docs/arayuz/SABLONLAR.md`, `src/arayuz/tema_onizleme.tscn`.
  - Asset: doku, çerçeve ve yazı tipi envantere `ARY01-*`. Yer tutucu `StyleBoxFlat`.

### 24.2 Tema kaynağı

- [ ] **ARY-02:** Tema altyapısı — seçilen dil tek yerden.
  - Ne: Seçilen şablonun renk, çerçeve ve punto değerleri `src/arayuz/tema/` altındaki kaynakta durur. `tema.gd` yalnız bu kaynağı bağlar; çekirdek dosyada renk listesi büyümez. Oyuncu paneli yerel `Color(` veya `font_size` yazmaz. Eksik stil anahtarı pembe hata basmaz, belgedeki nötr yedeği kullanır ve tarama bunu hata sayar. Kapı sahnesi yeniden çizilmez, yalnız kaynağa bağlanır. Gövde puntosu 26'nın, küçük punto 22'nin altına inmez.
  - Kurallar:
    1. Yeni stiller ayrı tema kaynağındadır. `tema.gd` yalnız o kaynağı bağlar. Çekirdek dosyada renk listesi büyümez.
    2. Tarama, panel üstündeki yerel renk ve punto sayısını 0 ister. İstisna listesi belgededir. İstisna dışı her yerel renk hatadır.
    3. ARY-01 seçimi yoksa bu madde uygulanmaz.
    4. Admin katmanı (ADM-01) kendi katmanında kalır, tema onu yutmaz.
  - Uç durumlar: eksik bir stil anahtarı panelde pembe bir hata rengi değil, belgedeki yedek nötr rengi kullanır ve taramada hata sayılır. Kapı sahnesi bu maddede yeniden çizilmez, yalnız kaynağa bağlanır.
  - Kabul: `tests/tools/test_arayuz_renk.py` oyuncu panellerinde istisna dışı yerel renk ve puntoyu 0 görür. `tema.gd` farkı bağlama satırının dışına çıkmaz. Seçim satırı boşken tema dosyası yazılmaz. Ek şart: gövde puntosu 26, küçük punto en az 22'dir. Ek şart: admin katmanı tema kaynağını import etmez. Ek şart: mühür ve çerçeve ham renk bırakmaz.
  - Bağımlılık: ARY-01. Boyut: L.
  - Dosya: yeni `src/arayuz/tema/*.tres`; `tema.gd` adaptör.
  - Asset: ARY-01 envanteri. Yeni üretim yok.

### 24.3 Sekiz ekran kabuğu

- [ ] **ARY-03:** Ekranların taşınması — harita, sorgu, seçim, köy HUD, pazar, divan, oda, gece raporu.
  - Ne: Harita, kapı sorgusu, karar düğmeleri, köy HUD, pazar, divan, muhafız odası ve gece raporu seçilen temanın kabuğunu giyer. Pazar kabuğu satış, fiyat ve kaydırma dosyalarını kapsar; fiyatın hesaplandığı tüccar motoru aynı kalır. Oda kabuğu yedi paneli kapsar, terazi kuralı değişmez. Gece raporu ayrı sahne açmaz, köy kadrajında `gece_bilancosu.gd` ile çizilir. Her ekranın önce ve sonra görüntüsü rapordadır. Ekran yeni oyun sistemi eklemez.
  - Kurallar:
    1. Alt kapanışlar ayrıdır: harita, sorgu, seçim düğmeleri, köy HUD, pazar, divan, oda, gece raporu. Biri açıkken madde açık kalır.
    2. Her alt kapanışın önce ve sonra görüntüsü rapordadır. Ölçüt, duran kapı sahnesidir.
    3. Ekran yeni bir oyun sistemi eklemez. Pazar hâlâ TUC, divan hâlâ CAS, oda hâlâ ODA'dır. Yalnız kabuk değişir.
    4. Stil ARY-02 kaynağındandır. Ekran içine renk gömülmez.
  - Uç durumlar: bir ekranın görüntüsü yoksa o alt madde kapanmaz. Kapı sahnesinin kendisi bu listede değildir, ölçüt olarak durur. Eksik asset, düz renk yer tutucuyla kapanışı engellemez. Yer tutucu raporda belirtilir.
  - Kabul: Sekiz ekranın sekizinde önce ve sonra görüntüsü vardır; `tests/tools/test_arayuz_renk.py` her birinde yerel rengi 0 görür. Biri eksikse üst madde açık kalır. Ek şart: `pazar_satis_paneli.gd` ve fiyat ile kaydırma dosyalarında yerel renk 0'dır, fiyat fonksiyonunun imzası değişmez.
  - Bağımlılık: ARY-02. Boyut: L.
  - Dosya: ilgili arayüz dosyaları, her birine tema adaptörü.
  - Asset: ekran arka planları envantere `ARY03-*`. Yer tutucu: düz renk.

### 24.4 Yükleme

- [ ] **ARY-04:** Yükleme ekranları ve ara sahne çerçevesi — çeşitli, tekrarsız.
  - Ne: Yükleme en az sekiz yuvadan bir görsel ve altında kısa bir satır gösterir. Aynı yuva art arda iki kez seçilmez. Satır dünya kitabından ya da `data/yukleme_ekranlari.json` listesinden gelir; kodun içine tarih cümlesi yazılmaz. Görsel yoksa düz renk ve satır durur, yükleme kesilmez. Ara sahneler aynı çerçeveyi kullanır.
  - Kurallar:
    1. En az 8 yuva vardır. Aynı görsel art arda iki kez seçilmez.
    2. Görselin altında kısa bir satır vardır. Dünya kitabı (YAZ-01) hazırsa satır oradan seçilir. Hazır değilse `data/yukleme_ekranlari.json` içindeki sabit kısa liste kullanılır. Kodun içine tarih cümlesi yazılmaz.
    3. Ara sahneler aynı çerçeveyi kullanır. Yeni bir sinematik motor yoktur.
    4. Görsel yoksa düz renk ve satır gösterilir. Yükleme bu yüzden durmaz.
  - Uç durumlar: 8 yuvadan biri eksik dosyaysa o yuva atlanır, art arda aynı yuva yine gelmez. Liste boşsa tek nötr satır vardır, çökme yoktur. Ulak sahnesi (ACL-04) bu çerçeveyi kullanır, ikinci bir ara sahne düzeni açmaz.
  - Kabul: 20 ardışık yüklemede art arda aynı yuva 0 kez gelir (`tests/unit/arayuz/yukleme_ekrani_test.gd`). Eksik dosyada düz renk ve satır görünür, hata ekranı yoktur. Satır, JSON veya dünya kitabının dışından 0 kez yazılır.
  - Bağımlılık: ARY-02. Boyut: M.
  - Dosya: yeni `src/arayuz/yukleme_ekrani.gd`, `data/yukleme_ekranlari.json`.
  - Asset: 8 yükleme görseli envantere `ARY04-YUKLEME-01` … `ARY04-YUKLEME-08`. Yer tutucu: düz renk + satır.


### 24.5 Asset envanteri

- [x] **ARY-05:** (Claude) ROADMAP 2 asset listesi — yalnız gerekenler.
  - Ne: `docs/EKSIK_ASSET_ENVANTERI.md` içinde ROADMAP 2 bölümü, her gereken model için bir satır tutar. Satırda kimlik, tür, yer tutucu yolu ve arama sözcüğü vardır. Kimliği yol haritasında olmayan satır ve aynı kimliğin ikinci satırı hatadır. Liste ses dosyası istemez. Bu madde dosya üretmez.
  - Kurallar:
    1. `docs/EKSIK_ASSET_ENVANTERI.md` içinde ROADMAP 2 bölümü vardır.
    2. Her satırda ROADMAP kimliği, tür, yer tutucu yolu, Türkçe ve İngilizce arama sözcüğü, öncelik vardır.
    3. Satırın kimliği A, B veya C dosyalarındaki bir maddedir. Kimliği olmayan satır hatadır.
    4. Bu madde dosya üretmez. Parça A'nın kendi kimlikleri şunlardır: `BUG21-TASYATAGI`, `BUG25-MESALE`, `BUG25-KUYU`, `ACL01-MUHAFIZ`, `ACL01-ES`, `ACL04-ARASAHNE`, `KAP17-COCUK`, `KAP17-YASLI`, `ARY01-*`, `ARY03-*`, `ARY04-YUKLEME-01` … `08`.
    5. B ve C kimlikleri (zar, yemin, ocak, denetçi, defter, oda, eşya) o maddeler yazıldıkça listeye eklenir. Bu madde onları icat etmez, yalnız listeyi tutar.
  - Uç durumlar: yer tutucusu olan bir madde listede yoksa tarama 1 hata verir. Aynı kimlik iki satırda duramaz. "İleride lazım olur" diye eklenen satır silinir.
  - Kabul: Tarama, üç parça dosyasındaki her `envantere` kimliğini listede bir kez bulur (`tests/tools/test_asset_envanteri.py`). Listede fazla kimlik 0'dır. Ek şart: envanterde wav satırı 0'dır.
  - Bağımlılık: parça dosyaları. Boyut: S. Liste her kapanışta güncellenir.
  - Dosya: `docs/EKSIK_ASSET_ENVANTERI.md`.
  - Asset: —


### 24.9 Ölçü

- [ ] **ARY-70:** Üç genişlik açılır
  - Ne: Oyuncu pencereyi 1280, 1600 ve 1920 genişlikte açınca tema kabuğu taşan yazıyı kesmez; panel kayar. Metin ölçeği 150'ye çıkınca da glif kadrajın dışında kalmaz. Pencere boyu listesi ayarlar bölümündedir, burada ikinci liste açılmaz.
  - Kabul: Üç genişlikte ve 150 ölçekte kesilen glif 0'dır ve betik hatası 0'dır (`tests/unit/arayuz/tema_olcu_test.gd`).
  - Bağımlılık: ARY-02. Boyut: S.
  - Dosya: `src/arayuz/tema.gd`
  - Asset: asset gerekmedi.


---

## BÖLÜM 25: Diyalog — Sorgu Eylemleri, Kapı Dışındaki Sonuçlar ve Yazım Araçları (Faz 2–3)

### 25.1 Çelişki ve bakış

- [ ] **DYL-01:** Çelişkiyi yüzüne vurmak — iki kaydı oyuncu kendisi eşleştirir.
  - Ne: Oyuncu defterden iki kaydı kendisi seçer; motor çifti otomatik eşleştirmez. Doğru çift yüzleşme dalını açar. Yanlış çift tansiyonu bir artırır, güveni iki düşürür ve aynı çift bir daha denenemez. Üç yanlıştan sonra "Göster" o ziyarette kapanır. İlk üç gün hazır "Yüzleş" düğmesi de durur, sonra yalnız "Göster" kalır.
  - Kurallar:
    1. Sorgu panelinde "Göster" eylemi. Oyuncu defterden iki kayıt seçer: beyan + ipucu, beyan + beyan ya da beyan + duyduğu söz (başka bir karakterin beyanı veya dedikodu, DIY-11/13).
    2. Sahne verisinde `celiskiler: [{a, b, dal, guc}]`. `a` ve `b` kayıt kimlikleridir; sıra önemsizdir.
    3. Doğru çift, o çelişkiye özel yüzleşme dalına geçer (DIY-07 dalları buradan tetiklenir).
    4. `guc: "guclu"` doğrudan dala gider. `guc: "zayif"` ikna zarı açar, kanıt değiştiricisi −1 (ZAR-04).
    5. Yanlış çift: tansiyon +1, güven −2, sabır −1. Karakterin kendine özgü tepki satırı gelir ("Ne alakası var bunun?"). Tepki satırı yoksa varsayılan satır kullanılır.
    6. Aynı yanlış çift ikinci kez denenemez. Üç yanlıştan sonra "Göster" o ziyarette kapanır, karakter muhafızı ciddiye almaz (gözdağı +1).
    7. Defterdeki her kaydın yanında nereden geldiği yazar: hangi soruda söylendi, hangi bakışta görüldü.
    8. Zorluk ayarı `celiski_yardimi`: açıkken bugünkü gibi hazır "Yüzleş" seçenekleri de görünür (öğretici ve kolay oyun); kapalıyken yalnız "Göster" kalır. Varsayılan: ilk 3 gün açık, sonra kapalı.
  - Uç durumlar: aynı ipucu iki çelişkide birden yer alabilir; çözülmüş çelişki defterde üstü çizili görünür ve yeniden gösterilemez. Karakter kaçarsa (ZAR-03) gösterilmemiş çelişkiler kişi hafızasına "çözülmedi" diye yazılır, karakter dönerse yeniden kullanılabilir. Defterde tek kayıt varken Göster kilitlidir; bir kayıt kendisiyle eşleşmez.
  - Kabul: Yusuf'un beş yüzleşmesi çelişki çiftiyle kurulur; elle yazılmış yüzleşme seçeneği 0 kalır (`tests/unit/soz/celiski_goster_test.gd`). Üç yanlıştan sonra "Göster" kapanır. Tek kayıtta "Göster" 0'dır. Ek şart: `koy_sahnesi` import edilmez.
  - Bağımlılık: DIY-06, DIY-07. Boyut: M.
  - Dosya: `src/soz/celiski.gd` (DIY-07 dosyası genişler, ikinci sistem yok); yeni `src/arayuz/kapi/beyan_defteri_paneli.gd`.
  - Asset: asset gerekmedi (defter paneli ARY şablonuyla).

- [ ] **DYL-02:** Bakmak — konuşmadan süzmek.
  - Ne: Oyuncu yüz, eller, çarık, giysi, yük ve yanındakilere bakar; her bakış sabırdan bir düşer ve bir gözlem satırı verir. Işık kapalıysa ayrıntı ve ipucu gelmez. Aynı bölgeye ikinci bakış yeni bilgi vermez. Tecrübe eşiği altındayken ek yorum satırı görünmez. Hastalık belirtisi bu bakışın bir bölgesidir; ikinci vücut haritası açılmaz.
  - Kurallar:
    1. Sorgu panelinde "Bak" eylemi, bölgelere ayrılır: yüz, eller, ayak ve çarık, giysi, yük (dokunmadan; heybeyi açmak ayrı eylemdir), yanındakiler (hayvan, çocuk, eşya).
    2. Her bakış sabırdan 1 düşer ve bir gözlem satırı verir (anlatı). Gözlem bir ipucu üretebilir.
    3. Muhafız tecrübesi eşiği geçerse aynı bakış ek yorum satırı verir ("Nasırsız el. Reçber eli değil bu."). Bu, ZAR-06 sezgisinin kullandığı eşiktir, ikinci eşik yoktur.
    4. Işık koşulu: akşam ve kışın bazı ayrıntılar görünmez (`kosul.baglam.isik`). Kapı meşalesi yanıyorsa görünür (BUG-25).
    5. Karakter bakılmaya tepki verebilir: uzun süzmek (aynı bölgeye ikinci bakış ya da üç bölgeden fazlası) karaktere özgü tepki satırı getirir ve güveni düşürür. Tepkiyi yazar yazar; yazmazsa tepki olmaz.
    6. Aynı bölgeye ikinci bakış yeni bilgi vermez, yalnız tepki riskini taşır.
    7. Bakış verisi modelde görünenle tutarlı olmalı. Görselde olmayan bir ayrıntı yazılmışsa doğrulayıcı onu "görsel bekliyor" diye listeler ve satır envantere bağlanır.
    8. CHR'lerdeki mevcut görsel hata verisi bu eylemle okunur, ayrı bir inceleme yolu kalmaz.
  - Şema: `bakislar: {bolge: {satirlar[], ipucu, kosul, tepki[]}}`.
  - Uç durumlar: Heybeyi açmak bakış sayılmaz; kendi eylemidir ve bu maddenin sabrını ayrıca harcamaz. Işık kapalıyken bölge düğmesi durur, gözlem satırı ve ipucu gelmez. Üç bölgeden sonraki bakış tepki eşiğini aşar, yeni ipucu üretmez.
  - Kabul: Yusuf'ta eller, çarık, kese ve yüzde bakış vardır (`tests/unit/soz/bakis_test.gd`). Her bölge sabırdan 1 düşer. Işıksız yüzde ipucu 0'dır. Tekrar bakış yeni ipucu üretmez.
  - Bağımlılık: DIY-02, ZAR-06, BUG-25. Boyut: M.
  - Dosya: yeni `src/soz/bakis.gd`; sorgu paneline eylem düğmesi.
  - Asset: karakter ayrıntıları (yamalı çarık, nasırlı el, sarılı yara, yanık giysi) envantere `DYL02-AYRINTI-*`; yer tutucu: modelin ilgili bölgesinde düz renkli küçük kutu + gözlem metni.

### 25.2 Yemin, yalan, söz

- [ ] **DYL-03:** Yemin ettirmek.
  - Ne: Oyuncu ziyarette bir kez "El bas, yemin et" der. Yemin şekli karakterin inancına göre dünya kitabından gelir; uymayan şekil hakarettir. Tutum dört türden biridir: eder, kıvranır, rahat ya da reddeder. Yemin zar açmaz. Bozulan yemin bir kez ceza yazar. İnanç alanı boşsa düğme gizlenir.
  - Kurallar:
    1. Seçenek: "El bas, yemin et." Ziyaret başına bir kez kullanılır.
    2. Yemin şekli karakterin inancına ve grubuna göre değişir. Hangi grup neye yemin eder, dünya kitabından gelir (YAZ-01). Örnekler kaynakla doğrulanmadan oyuna girmez.
    3. Yanlış şekil teklif etmek (karakterin inancına uymayan yemin) hakarettir: güven −3, grup itibarı −1.
    4. Karakter verisinde `yemin: {tutum, satirlar}`. Tutum dört türden biridir:
      - `eder`: dürüst kişi hemen eder.
      - `kivranir`: inançlı yalancı kaçamak cevap verir. İpucu `yemin_kacamak` oluşur.
      - `rahat`: inançsız yalancı rahatça yemin eder. Yalan yemin bayrağı gizli olarak düşer.
      - `reddeder`: inancı yemine izin vermeyen kişi gerekçesiyle reddeder. Bu bir yalan belirtisi değildir.
    5. Bedel: yemin istemek tansiyonu 1 artırır. Saygın kişide (derviş, ahi babası, yaşlı) güveni de 2 düşürür.
    6. Yalan yemin sonradan ortaya çıkarsa (DYL-08 dönüşü, dedikodu) kişi grubunda ağır itibar kaybı yaşar ve muhafız terazisine yazılır ("yalan yemine göz yumdun" değil, "yalan yemin edeni içeri aldın").
  - Uç durumlar: İnanç alanı boşsa yemin düğmesi gizlenir, hakaret yazılmaz. `reddeder` tutumu yalan bayrağı ve `yemin_kacamak` ipucu yazmaz. Sır açıldıktan sonraki satır, açılmadan önceki satırın yerine geçer; ikisi birden görünmez.
  - Kabul: Dört tutum dört ayrı sonuç verir (`tests/unit/soz/yemin_test.gd`). İkinci yemin seçeneği görünmez. İnanç alanı boşken yemin düğmesi 0'dır. Ek şart: yemin satırı zar atışı açmaz. Ek şart: bozulan yemin ikinci ceza yazmaz.
  - Bağımlılık: DIY-02, DIY-12, YAZ-01. Boyut: S.
  - Dosya: yeni `src/soz/yemin.gd`.
  - Asset: yemin nesneleri (dünya kitabına göre) envantere `DYL03-YEMIN`; yer tutucu: düz renk kutu + etiket.

- [ ] **DYL-04:** Muhafız da yalan söyler.
  - Ne: Oyuncu yalan seçeneğinin yanında "Yalan" etiketini görür; kandırılan karakterdir. Yalan tansiyonu düşürür ya da gözdağını kolaylaştırır. Köyde gerçek görülürse ertesi gün kişi hafızasına `muhafiz_yalani` yazılır. Tanık varsa dedikodu da yayılır. Sözlükte olmayan `gercek` anahtarı 1 hata verir.
  - Kurallar:
    1. Seçenekte `soylenen: {id, metin, dogru: false, gercek}`. `gercek` kontrol edilebilecek bağlam alanını gösterir (asker sayısı, beyin köyde olup olmadığı, yatak sayısı).
    2. Oyuncu yalan söylediğini bilir: seçeneğin yanında küçük işaret ve "Yalan" etiketi bulunur. Oyuncu kandırılmaz, karakter kandırılır.
    3. Faydası: tansiyon düşürür ya da gözdağını kolaylaştırır (−1). Hangisi olduğu seçenekte yazar.
    4. Ortaya çıkma yolları:
      1. Karakter içeri alınır ve köyde gerçeği görür (`gercek` alanı köyde gözlenebilir). Ertesi gün kişi hafızasına `muhafiz_yalani` yazılır.
      2. Dedikodu ile yayılır (DIY-13, tanık kuralı geçerli).
      3. Karakter yalanı anında sezer. Hangi koşulda sezeceğini yazar belirler (tecrübeli asker, köyü tanıyan kişi).
    5. Yakalanınca: güven −4, grup itibarı −1, vicdan kaydı. Dönen karakterin selamı bu varyanta geçer (DIY-11).
    6. "Senin söylediklerin" listesinde yalanlar ayrı renkte durur. Oyuncu ne söylediğini unutmaz.
  - Uç durumlar: Tanık yoksa dedikodu yolu susar; köyde gözlenen `gercek` alanı ertesi gün yine açığa çıkarabilir. `gercek` sözlükte yoksa yalan sessiz kalır ve doğrulayıcı 1 hata verir. Aynı ziyarette sezilen yalan gece denetiminde ikinci ceza yazmaz.
  - Kabul: Yusuf'taki "Bey içeride, kırk atlısı var" kaydı `dogru:false` taşır (`tests/unit/soz/yalan_denetimi_test.gd`). Köyde gözlenen alan yalanı açığa çıkarır. Aynı yalan için ceza kaydı 1'dir.
  - Bağımlılık: DIY-18, DIY-11, DIY-13. Boyut: M.
  - Dosya: `src/soz/` muhafız beyanı kaydı (DIY-18 dosyası); yeni `src/soz/yalan_denetimi.gd` (gece sonu, köyde gözlenen alanları karşılaştırır).
  - Asset: asset gerekmedi.

### 25.3 Dil ve akşam

- [ ] **DYL-05:** Söz vermek — tutulan ve tutulmayan söz.
  - Ne: Oyuncu "yarın gel" ya da "aileni ararım" dediğinde söz kişi hafızasına ve "Verdiğin sözler" listesine düşer. Süre dolunca kişi kapıya zorunlu gelen olarak gelir; sistem yatak ya da divan kaydına bakarak sözün tutulup tutulmadığını kendisi sayar. Tutulan söz güveni artırır, tutulmayan söz itibarı düşürür ve tanık varsa dedikodu açar. Aynı anda en çok beş açık söz vardır. Söz kimliği dosyada tekildir; tutulan sözün ödülü bir kez yazılır.
  - Kurallar:
    1. Seçenekte `soz: {id, tur, sure_gun, kosul}`. Türler: `yarin_gel` (yer açılınca), `beyle_konusurum`, `aileni_ararim` (kervan ya da gözcü sorar), `isini_ayarlarim`. Tür listesi veride.
    2. Söz kişi hafızasına ve muhafızın defterinde "Verdiğin sözler" listesine yazılır; süresi yaklaşınca bir gün önce hatırlatma çıkar.
    3. Süre dolunca karakter kendiliğinden kapıya gelir (KAP-16 gelen akışına zorunlu gelen olarak eklenir).
    4. Tutulup tutulmadığını sistem denetler (yatak boş mu, divanda ilgili eylem yapıldı mı vb.). Oyuncunun beyanına bakılmaz.
    5. Tutulan söz: güven ve grup itibarı artar; karakterin dönüş sahnesi "tuttun" varyantıyla açılır.
    6. Tutulmayan söz: itibar düşer, dedikodu yayılır, dönüş sahnesi sitem varyantıyla açılır.
    7. Söz verilen kişi her zaman dönmeyebilir (yolda öldü, başka köye yerleşti); bu ihtimal DYL-08 dönüşüyle bildirilir.
    8. Aynı anda en çok 5 açık söz. Altıncı söz seçeneği kilitli görünür ve nedeni yazar.
  - Uç durumlar: Süre 0 gün yazılırsa dosya geçmez. Kişi süre dolmadan ölürse söz düşer, itibar cezası yazılmaz, haber DYL-08 `haberci` kanalına gider. Açık söz 5 iken altıncı söz ve CAT-02 ertelemesi birlikte kilitlidir.
  - Kabul: Yusuf'u yer yokken çevirirken "yarın gel" sözü kayda düşer ve süre dolunca iki dönüş varyantından biri açılır (`tests/unit/soz/verilen_soz_test.gd`). Açık söz altıya çıkmaz. Süre 0 olan söz 1 hata verir. Ek şart: aynı söz kimliği ikinci kez 1 hata verir. Ek şart: tutulan sözün ödülü ikinci kez yazılmaz.
  - Bağımlılık: DIY-11, KAP-16; CAT-02 bu maddeyi kullanır. Boyut: M.
  - Dosya: yeni `src/soz/verilen_soz.gd`; muhafız defterine liste (oda ekranı adaptörü).
  - Asset: asset gerekmedi.

- [x] **DYL-06:** Dil engeli ve tercüman. (Antigravity)
  - Ne: Ortak dil yoksa oyuncu kırık Türkçe ya da "Rumca bir şeyler söylüyor" anlatısını görür; yabancı dilde tam cümle yazılmaz. Köyde o dili bilen biri varsa tercüman çağrılır, sabır iki düşer ve o köylü o gün yarım çalışır. Köyde tercüman yoksa düğme görünmez. Tercüman kendi grubuna göre satırı yumuşatabilir; eş tercüman çarpıtmaz. Ayrı bir tercüman motoru açılmaz.
  - Kurallar:
    1. Karakter verisinde `diller`; muhafızın dilleri geçmişinden gelir (ACL-06: medreseli Arapça ve Farsça, levent biraz Rumca). Köylülerin bildiği diller köylü verisinde optional alan.
    2. Ortak dil yoksa karakter satırlarının `kirik` varyantı gelir: kırık Türkçe ya da anlatı ("Rumca bir şeyler söylüyor. Arada 'Kayseri' diyor."). Oyunda yabancı dilde cümle yazılmaz; yalnız kırık Türkçe ve anlatı kullanılır.
    3. Ortak dil yokken konu merkezi daralır: yazar hangi konuların işaretle anlaşılabildiğini seçer (2–3 konu).
    4. Tercüman çağırmak: köyde dili bilen biri varsa çağrılır. Sabır −2, o köylü o gün yarım çalışır (ISG iş gücü hesabına tek satır).
    5. Tercüman tarafsız değildir. Kendi grubuna ve karakterine göre bazı satırları yumuşatır ya da çarpıtır (`tercuman` varyantları). Tecrübe eşiği üstünde muhafız çarpıtmayı sezer (sezgi satırı).
    6. Eş tercüman olabilir. Çarpıtmaz, ama akşam sohbetinde (DYL-07) duyduğunu anar.
    7. Tercümansız karar verilebilir; bu durumda beyan defterinde "anlaşılamadı" kayıtları kalır.
  - Yazım yükü: çok dilli her karakter için iki metin yazılır (anlaşılan ve kırık). Doğrulayıcı eksik `kirik` varyantını hata sayar.
  - Uç durumlar: Ortak dil varken `kirik` varyant seçilmez. Tercüman köylünün iş gücü 1.0 ise çağrıdan sonra 0.5 olur; zaten 0.5 ise ikinci çağrı 0’a indirimez. Eş tercüman çarpıtma varyantı üretmez.
  - Kabul: Ortak dil yokken yalnız kırık satırlar gelir; tercüman çağrılınca tam satırlar gelir (`tests/unit/soz/dil_engeli_test.gd`). Tercüman köylünün iş gücü 1.0 iken çağrıdan sonra 0.5 olur. Ortak dilde kırık satır 0'dır. Ek şart: tercüman bayrağı yokken düğme 0'dır.
  - Bağımlılık: DIY-09, DIY-12, ACL-06. Boyut: M.
  - Dosya: yeni `src/soz/dil_engeli.gd`; köylü verisine optional `diller`.
  - Asset: asset gerekmedi.


### 25.4 Dönüş, denetçi, varyant

- [ ] **DYL-07:** Akşam eşle konuşmak (ACL-03'ün ayrıntılı tasarımı).
  - Ne: Gece raporundan önce ocak başında en çok bir sohbet açılır. Konu, günün kararları arasından ağırlık tablosuna göre seçilir; eşin mesleği cümleyi değiştirir. Eş, muhafızın görmediği bir şeyi söyleyebilir ve bu ertesi gün ipucu olur. Sohbet atlanabilir, atlamanın cezası yoktur. Meclis gecesinde ve eş ölmüşken sohbet açılmaz. Yeni ses dosyası eklenmez.
  - Kurallar:
    1. Gece raporundan önce, ocak başında, en çok bir sohbet. 2–4 eş repliği, muhafız için 2–3 cevap: savunmak, kabul etmek, susmak.
    2. Konu, günün kararları arasından ağırlık tablosuna göre seçilir (`data/soz/aksam_konulari.json`). Örnek ağırlıklar: aileyi bölmek 5, rüşvet 5, çocuklu aileyi çevirmek 4, yalan yemin edeni almak 3, yakalanan yalan 3, tutulmayan söz 3. Eşit ağırlıkta en yeni olay seçilir.
    3. Eşin mesleği bakış açısını belirler: ebe hastalığı, fırıncı erzakı, dokumacı kadınlar arasındaki sözü anar. Her konuda en az 2 meslek varyantı yazılır.
    4. Eş muhafızın görmediğini söyleyebilir (kapının yanında gördüğü, köyde duyduğu). Bu bilgi ertesi gün ipucu ya da kişi hafızası olarak kullanılır.
    5. Eş geçmiş sohbetleri anar ("Geçen hafta da böyle demiştin"). Bunun için eşe ait küçük bir hafıza tutulur; DIY-11'in eş kaydıdır, ayrı sistem değildir.
    6. Etkiler: eşin morali ve muhafız terazisi (ACL-03). Muhafızın cevabı da etki taşır: susmak moral düşürmez ama terazi kaydına "kaçtı" yazar.
    7. Ağır karar yoksa gündelik kısa bir satır gelir ya da sohbet olmaz. Her gece konuşmak zorunlu değildir.
    8. Sohbet atlanabilir; atlamanın cezası yoktur.
  - İçerik ölçüsü: 10 konu × 3 tepki (ACL-03) × en az 2 meslek varyantı. Eşin ses kartı da YAZ-03 kurallarıyla yazılır.
  - Uç durumlar: Ağırlık tablosunda olmayan karar konu seçmez. Eş ölmüşse sohbet açılmaz ve ceza yazılmaz. İki olay aynı ağırlıktaysa ziyaret sırası büyük olan seçilir.
  - Kabul: Yusuf kararından sonra ağırlığı en yüksek olayın konusu seçilir (`tests/unit/koy/aksam_konu_test.gd`). Eşit ağırlıkta ziyaret sırası büyük olan konu gelir. Atlama barı değiştirmez. Ağırlığı 0 olan olay konu olmaz.
  - Bağımlılık: ACL-02, ACL-03, DIY-08, DIY-11. Boyut: M.
  - Dosya: `src/koy/aksam_sohbeti.gd` (ACL-03 dosyası); `data/soz/aksam_konulari.json`.
  - Asset: ocak başı ara sahne arka planı envantere `DYL07-OCAK`; yer tutucu: düz renk + metin, ARY-04 çerçevesi.

- [ ] **DYL-08:** Kararın sonradan dönüşü.
  - Ne: Bir kapı kararının sonucu günler sonra sabah raporu, başka bir gelenin haberi ya da köylü kartı olarak döner. Günde en çok iki dönüş gösterilir; üçüncüsü ertesi güne aynı kuyrukta kalır. Ölen kişinin dönüşü yalnız haberci kanalından gelir. Yeni sahne ve ikinci harita açılmaz.
  - Kurallar:
    1. Sahne verisinde her sonun `donusler: [{gun_min, gun_max, kosul, kanal, satirlar, etki}]` alanı olur.
    2. Kanal üç türden biridir:
      - `sabah`: sabah raporunda 2–4 satırlık kısa sahne.
      - `haberci`: kapıya gelen başka bir karakterin "Yolda ne gördün" konusunda geçer (DNY-02 kanalı).
      - `koylu`: köylü kartında ya da köy sohbetinde (YAZ-08).
    3. Dönüşün etkisi mevcut sisteme yazılır: salgın, moral, itibar, nüfus. Örnek: Yusuf gizlice alındıysa ateş salgın sistemine yazılır; şifahaneye alındıysa kız iyileşir ve Yusuf'un moraline yazılır.
    4. Dönüşlerin hepsi kötü değildir. Doğru kararın da dönüşü olur. Doğrulayıcı, bir sahnenin bütün dönüşleri cezaysa uyarır.
    5. Ağır kararların (DYL-07 tablosunda ağırlığı 4 ve üstü) en az bir dönüşü olmalı.
    6. Günde en çok 2 dönüş sahnesi gösterilir; fazlası ertesi güne kayar. Ölen ya da köyü terk eden karakterin dönüşü yalnız `haberci` kanalından gelir.
  - Uç durumlar: `gun_min` > `gun_max` ise dosya 1 hata verir. Ölen karakterin `sabah` ve `koylu` kanalı seçilmez, yalnız `haberci` kalır. Günlük 2 sınırını aşan üçüncü dönüş ertesi güne aynı KVR-08 kuyruğunda yazılır.
  - Kabul: Yusuf'un on bir sonundan en az altısının dönüşü gün aralığında gelir (`tests/unit/soz/karar_donusu_test.gd`). `gun_min` 5 ve `gun_max` 2 olan dönüş 1 hata verir. Üçüncü dönüş ayrı listede 0 satırdır. Ek şart: yeni sahne ve ikinci harita 0'dır. Ek şart: aynı kapı kararı ikinci sabah satırı yazmaz ve SAB-01 kancasına düşmez. Ek şart: ayrılan kişinin kimliği dönüş sahnesine girmez; satırda adı gitti diye işaretlenir. Ek şart: aynı dönüş bir barı bir kez değiştirir; ertesi gecede o barın deltası 0'dır. Ek şart: tanıklı dönüş mevcut dedikodu kaydına 1 satır düşer; tanıksız dönüşte dedikodu satırı 0'dır.
  - Bağımlılık: DIY-11, DNY-02, KVR-07/08. Boyut: M.
  - Dosya: yeni `src/soz/karar_donusu.gd` (kuyruğa yazan adaptör).
  - Asset: asset gerekmedi (ARY-04 çerçevesi).

### 25.5 Kör okuma ve yan yana

- [ ] **DYL-09:** Beyin denetçisi — sorgulanan muhafız.
  - Ne: Sancak beyinin adamı yedi ila on günde bir kapıya gelir ve muhafızı sorgular. Elinde dedikodu, kabul-ret sayısı ve tutulmayan sözler vardır. Teftiş koşulu tutmuyorsa sahne açılmaz. Sonuç övgü, uyarı ya da cezadır; üst üste iki ağır cezadan sonra görevden alma uyarısı mevcut son sistemine yazılır, altıncı son açılmaz.
  - Kurallar:
    1. Sancak beyinin adamı (HAR-04'teki beyle aynı kişi; unvanı dünya kitabından gelir) 7–10 günde bir gelir. Gelişi bir gün önce ulak ya da dedikoduyla duyulur.
    2. Denetçinin elindekiler: dedikodu kayıtları (DIY-13), ölçülebilir veriler (kabul ve ret sayısı, salgın, kasa, şiddet olayları) ve tutulmayan sözler (DYL-05).
    3. Sahne Söz motoruyla yürür. Konuşan denetçidir; seçenekler muhafızın cevaplarıdır. Tansiyon burada muhafızın gerginliğini ölçer.
    4. Denetçi de çelişki gösterir: muhafızın cevabını dedikodu kaydıyla karşılaştırır (DYL-01 ters yönde). Muhafız yalan söyleyebilir (DYL-04); yakalanırsa ağır bedel öder.
    5. Savunma zarı: muhafız ikna ya da gönül alma dener; zorluk denetçinin sorgu değeridir. ZAR-01 aynen geçerlidir.
    6. Sonuçlar: övgü (akçe ya da itibar), uyarı, ceza (akçe, birkaç gün yabancı kabul yasağı). Üst üste iki ağır cezadan sonra görevden alma uyarısı gelir. Oyun sonu yalnız mevcut son sistemine (SYS-20) bağlanır; yeni son yazılmaz.
    7. İlk denetçi gelmeden önce akşam sohbetinde eş bunu anar (DYL-07 konusu).
  - Uç durumlar: Denetçi günü gelmeden ceza uygulanmaz. Kabul yasağı yabancı kabulünü kapatır; heyet sahnesi (KOP-02) açık kalır. Üst üste iki ağır ceza SYS-20 koşuluna yazar, altıncı son açmaz.
  - Kabul: Temiz, karışık ve kötü defter için üç sahne vardır (`tests/unit/kapi/denetci_gelisi_test.gd`). Denetçi olmayan günde ceza bayrağı 0'dır. Kabul yasağında yabancı kabul 0, heyet sahnesi 1'dir.
  - Bağımlılık: DIY-02, DIY-13, DYL-01, DYL-04, HAR-04. Boyut: M.
  - Dosya: yeni `src/kapi/denetci_gelisi.gd`; sahne `data/soz/denetci_*.json`.
  - Asset: denetçi modeli envantere `DYL09-DENETCI`; yer tutucu: mevcut köylü modeli + renk farkı.

- [ ] **DYL-10:** Aynı karakter, farklı oyun — çekirdek varyantları.
  - Ne: Yusuf gibi kilit bir karakterin iki ya da üç çekirdeği aynı kimlikte durur; ikinci karakter kimliği açılmaz. Varyant oyun başında tohumla seçilir ve kayıtta değişmez. Heybe, bakış ayrıntısı ve dönüşler varyanta göre değişir. Dürüst Yusuf'ta yolda yedi ev yoktur.
  - Kurallar:
    1. Kilit karakterde 2–3 çekirdek bulunur (YAZ-09 türlerinden). Ortak kısım (selam, kimlik, çekirdekten bağımsız konular) bir kez yazılır; çekirdeğe bağlı düğüm ve satırlar `kosul.cekirdek` ile ayrılır.
    2. Varyant oyun başında tohumla seçilir, kayda yazılır ve o oyunda değişmez.
    3. Heybe içeriği, görsel ayrıntılar (DYL-02), bağlar (OZGUNLUK §6) ve dönüşler (DYL-08) varyanta göre değişir. Yusuf dürüstse yolda yedi ev de yoktur.
    4. Kadro denetimi (YAZ-09) bütün varyantları ayrı sayar ve kotayı beklenen değer üzerinden hesaplar.
    5. Önizleme aracında varyant seçici bulunur; kapsam taraması her varyantı ayrı yürütür.
  - Uç durumlar: Kayıtta tohum varsa çekirdek yeniden seçilmez. Dürüst varyantın heybesi boş olabilir; doğrulayıcı ipucu yok diye hata basmaz (DIY-01a). Hiçbir varyantta görünmeyen satır 1 hatadır.
  - Kabul: Aynı tohum ikinci açılışta aynı `cekirdek` değerini verir (`tests/unit/soz/cekirdek_secici_test.gd`). Yüz tohumda her varyant en az bir kez çıkar. Hiçbir varyantta görünmeyen satır 0 kalır.
  - Bağımlılık: YAZ-09, DIY-09. Boyut: M.
  - Dosya: yeni `src/soz/cekirdek_secici.gd`; kayıtta optional alan.
  - Asset: asset gerekmedi.


### 25.6 Örnek, site, fixtures

- [ ] **DYL-11:** Kör okuma testi — bu sözü kim söyledi?
  - Ne: İnceleme aracında seçilen ağızların replikleri adsız ve karışık sırayla gelir; okuyan her satırın konuşanını işaretler. Özel ad, yer adı ve karakterin kendi adı üç nokta ile kapanır. Sonuçta ağız başına doğru oranı ve en çok karışan çiftler durur. Şansın üstünde olup yüzde yetmişin altında kalan ağız için "ses kartları birbirine yakın" uyarısı çıkar.
  - Kurallar:
    1. İnceleme aracında ayrı sekme. Üç ya da dört ağız seçilir; yalnız karakter replikleri adsız ve karışık sırayla gelir.
    2. Ele veren bilgiler gizlenir: özel adlar, yer adları ve karakterin kendi adı "…" ile maskelenir. Maskelenecek sözcük listesi sahne verisinden otomatik çıkar.
    3. Okuyan her satır için kimin söylediğini seçer. Sonuçta karakter başına doğru oranı ve en çok karışan çiftler görünür.
    4. Eşik: şans düzeyinin üstünde ama %70'in altında kalan karakter için "ses kartları birbirine yakın" uyarısı çıkar. Şans düzeyi seçilen karakter sayısına göre hesaplanır.
    5. Aynı kişi testi tekrar yaparsa daha önce gördüğü satırlar öne çıkmaz.
    6. Sonuç inceleme dosyasına eklenir ve dışa aktarılır. Sahne dosyasının içine skor alanı yazılmaz.
  - Uç durumlar: Seçilen ağız sayısı 1 ise sekme kilitlenir; şans düzeyi hesaplanmaz. İki ağız seçilirse sonuç tablosu açılmaz. Maske listesi boşsa ve satırda özel ad kalmışsa skor yazılmaz. Aynı satır aynı oturumda ikinci kez öne çıkmaz.
  - Kabul: Yusuf ile iki ayrı ağız karışık listede maskesiz özel ad 0 bırakır ve doğru oranı hesaplanır (`tests/unit/soz/kor_okuma_test.gd`). Seçilen ağız 1 iken sekme kilitlidir. Maskelenmemiş özel ad varken skor satırı 0'dır. Ek şart: skor alanı olmayan dosya skor satırı yazmaz. Ek şart: oyun menüsünde kör okuma düğmesi yoktur. Ek şart: iki ağızla skor yazılmaz; skor satırı üç ağız ister.
  - Bağımlılık: YAZ-10, YAZ-03. Boyut: S.
  - Dosya: prototip `Roadmap-2/soz_agaci`; oyun tarafında `src/debug/soz_onizleme.gd` sekmesi.
  - Asset: asset gerekmedi.

- [ ] **DYL-12:** Muhafız tipleriyle tarama — sonlar dengeli mi?
  - Ne: Geliştirici aynı sahneyi beş muhafız tipiyle tarar; İnceleme sekmesinde son dağılımı, ortalama adım, sır açılma oranı ve kaçış oranı görünür. Sert tipte gözdağı seçimi yumuşak tipten yüksek çıkar. Bir tipte tek son yüzde seksenin üstündeyse ya da iki tip aynı dağılımı veriyorsa uyarı çıkar, son silinmez.
  - Kurallar:
    1. Muhafız tipleri veride (`data/soz/muhafiz_tipleri.json`):
      - sert: gözdağı, ikram yok, heybeye hemen bakar;
      - yumuşak: ikram eder, dinler, ikna dener;
      - açgözlü: rüşvet ve pazarlık;
      - meraklı: her konuyu açar, söz kesmez;
      - aceleci: az soru, hızlı karar.
    2. Tip, seçeneklerin özelliklerine ağırlık verir: zar yaklaşımı, tansiyon etkisi, kesme, ikram, karar türü. Yazarın ek etiket yazması gerekmez; gerekirse seçeneğe `tavir` etiketi eklenir.
    3. Her tip için rapor: sonların dağılımı, ortalama adım sayısı, sır açılma oranı (güvenle ya da korkuyla), kaçış oranı, ulaşılmayan düğümler.
    4. Gözlemler (hüküm değil):
      - bir tipte tek son %80'i geçiyorsa;
      - hiçbir tipte %1'i geçemeyen bir son varsa ve o son `nadir: true` diye işaretlenmemişse;
      - iki tip aynı dağılımı veriyorsa (tipler arasında fark yoksa sahne seçimlere tepki vermiyor demektir).
  - Uç durumlar: `nadir: true` son yüzde 1 altında kalsa da uyarı üretmez. İki tip aynı dağılımı verirse uyarı çıkar, son silinmez. Beş tipten biri dosyada yoksa tarama başlamaz.
  - Kabul: Yusuf sahnesi beş tiple taranır (`tests/tools/test_soz_tip_taramasi.py`). Sert tipin gözdağı oranı yumuşak tipinkinden yüksektir. `nadir: true` sonun uyarı sayısı 0'dır. Beş tipten biri dosyada yoksa tarama rapor satırı 0'dır ve 1 hata verir.
  - Bağımlılık: YAZ-10. Boyut: S.
  - Dosya: prototip; oyun tarafında `tools/soz_dogrula.py --tip`.
  - Asset: asset gerekmedi.

### 25.7 Kapı dışı sonuç

- [ ] **DYL-13:** Eski ve yeni metni yan yana görmek.
  - Ne: İnceleyen, işaret anındaki cümle ile yeni cümleyi kelime farkı olarak görür; eklenen yeşil, silinen kırmızı durur. "Yeniden yaz" ya da "yapay" işaretli satır değişince durum kendiliğinden "yeniden incele" olur. Satır yer değiştirirse `sid` işareti taşır; `sid` yokken benzer satır yalnız öneri verir ve hazır kimlik sayılmaz.
  - Kurallar:
    1. İşaretlendiği andaki metin zaten saklanıyor. Metin değişince eski ve yeni hâli kelime düzeyinde fark olarak gösterilir: eklenen yeşil, silinen kırmızı.
    2. "Yeniden yaz" ya da "yapay" işaretli bir satır değişince durumu kendiliğinden "yeniden incele" olur. İnceleyen yeni hâli yeniden işaretler.
    3. Her satırın sürüm geçmişi inceleme dosyasında tutulur. Kayıt, yazan ve inceleyen olmak üzere iki kişi adı ister.
    4. Satır yer değiştirdiyse kalıcı satır kimliği (`sid`, DYL-15) sayesinde işaret kaybolmaz. `sid` gelene kadar, metin benzerliğine göre "taşınmış olabilir" önerisi çıkar. Öneri, taşındı kimliğini hazır saymaz.
    5. Sahne özeti: kaç satır değişti; yapaylık uyarıları ve dolgu ile üç nokta oranları önce ve sonra.
  - Uç durumlar: `sid` yokken benzerlik eşiğinin altındaki satır otomatik eşlenmez, yalnız “taşınmış olabilir” önerisi çıkar. Değişmeyen satır “yeniden incele” olmaz. Yalnız boşluk farkı sürüm yazmaz. Eski cümle `data/soz` altına kopyalanmaz.
  - Kabul: Yusuf'un iki sürümünde değişen satırın durumu "yeniden incele" olur (`tests/unit/soz/metin_farki_test.gd`). Yalnız boşluk farkında sürüm sayısı 0'dır. Ek şart: kaydı olmayan taşındı kimliği hazır sayılmaz. Ek şart: eski cümle `data/soz` içine kopyalanmaz. Ek şart: sürüm kaydı iki kişi adı ister.
  - Bağımlılık: YAZ-10. Boyut: S.
  - Dosya: prototip; oyun tarafında `src/debug/soz_onizleme.gd`.
  - Asset: asset gerekmedi.

### 25.8 Eylem kadrajı

- [ ] **DYL-14:** Kaynaklı örnek defteri — bir köylü buna nasıl cevap verir?
  - Ne: Yazar, yapı türü ve durum için kaynaklı kısa örnekleri `docs/dunya_kitabi/ornek_defteri/` altında görür. İnceleme aracında yapaylık uyarısının yanında "örnek gör" bağlantısı, uyarının türüne uyan kayıtları açar. Model bu deftere satır yazmaz; kaynaksız kayıt listeye girmez.
  - Kurallar:
    1. `docs/dunya_kitabi/ornek_defteri/` altında kayıtlar tutulur. Her kayıtta:
      - yapı türü (USLUP_REHBERI §2 kategorileri);
      - durum (soruyu geçiştirme, yas, pazarlık, övünme, sitem, yalvarma);
      - kısa örnek;
      - kaynak (eser, sayfa, derleyen, yer, yıl);
      - ağız bölgesi;
      - not.
    2. Kaynak türleri USLUP_REHBERI §6'daki gibidir: göç ve mübadele tanıklıkları, ağız derlemeleri, Dede Korkut, köy edebiyatı.
    3. Telif sınırı: birebir alıntı en çok bir cümle; gerisi yapının tarifi ("soruya cevap vermeden önce soranın akrabasını sorar").
    4. Dönem notu: bugünkü ağızlar 13. yüzyılı birebir yansıtmaz. Örnekler cümle yapısı için kullanılır, kelime için değil; yasak kelime listesi geçerlidir.
    5. Kayıtları yalnız insan girer ve kaynağı doğrulanır. Model bu deftere örnek yazmaz.
    6. İnceleme aracında yapaylık uyarısının yanında "örnek gör" bağlantısı bulunur; uyarının türüne uyan kayıtlar açılır.
  - Uç durumlar: Kaynak alanı boş kayıt 1 hatadır ve “örnek gör” listesine girmez. Bir cümleden uzun birebir alıntı 1 hatadır. Kaynağı insan doğrulamamış satır deftere konmaz. Kadrodaki adı olmayan köylü kaydı deftere girmez.
  - Kabul: USLUP_REHBERI §2'deki 12 yapı türünün her birinde en az 3 kayıt vardır ve her kaydın kaynak alanı doludur (`tests/tools/test_ornek_defteri.py`). Kaynaksız kayıt 1 hata verir. İki cümlelik birebir alıntı 1 hata verir. Ek şart: ikinci örnek defteri açılmaz. Ek şart: defterdeki köylü adı kadroda yoksa kayıt 1 hata verir.
  - Bağımlılık: YAZ-01, YAZ-02. Boyut: M (içerik).
  - Dosya: yeni `docs/dunya_kitabi/ornek_defteri/*.md`.
  - Asset: asset gerekmedi.

- [ ] **DYL-74:** Kapalı eylem sebebi bir kelimedir
  - Ne: Kapanan sorgu eylemi kadrajdan silinmez; düğmenin altında bir kelimelik sebep görünür ve bu kelime çeviri anahtarıdır. Altı eylem düğmesi sığmazsa liste kayar. Yedinci eylem türü eklenmez. Oyuncu düğmede madde kimliği görmez.
  - Kurallar:
    1. Kapalı düğme görünür kalır. Sebep bir kelimedir ve `data/metin/metinler.csv` anahtarıdır.
    2. Eylem düğmesi sayısı 6'yı geçmez. Altı düğmede kaydırma vardır.
    3. Düğme metni oyuncu dilindedir. Madde kimliği ve dosya adı ekranda durmaz.
  - Uç durumlar: Sebep anahtarı yoksa düğme görünür kalır, sebep satırı boş basılmaz ve doğrulayıcı 1 hata verir. Yedinci tür dosyada varsa panel açılmaz.
  - Kabul: Üç yanlıştan sonra Göster düğmesi görünür kalır ve sebep bir kelimedir (`tests/unit/soz/eylem_kadraji_test.gd`). Altı düğmede kaydırma 1'dir. Ekran metninde `DYL-` öneki 0'dır. Yedinci eylem türü dosyada 0'dır.
  - Bağımlılık: DYL-01, YAZ-02. Boyut: S.
  - Dosya: `chr_diyalog_paneli.gd`
  - Asset: asset gerekmedi.

### 25.9 Kayıt ve ölçüm

- [ ] **DYL-15:** Sitede düzenleme — JS dosyası açmadan yazmak.
  - Ne: Yazar, İnceleme ve Ağaç sekmelerinde satır metnini yerinde değiştirir; koşul ve etki için form vardır, ham JSON açılmaz. Ağaçta düğüm eklenir, bağlantı sürüklenir, hedefi olmayan bağ kaydolmaz. Kaydetmek tarayıcıdan sahne dosyası indirir; `sid` yer değişse de durur.
  - Kurallar:
    1. Satırların ve seçeneklerin metni İnceleme ve Ağaç sekmelerinde yerinde düzenlenir. Koşul ve etki için form vardır; ham JSON düzenlenmez.
    2. Ağaç sekmesinde düğüm eklenir ve silinir, bağlantı sürüklenerek kurulur. Hedefi olmayan bağlantı kaydedilemez.
    3. Her değişiklikten sonra doğrulama ve yapaylık denetimi canlı çalışır.
    4. Kalıcı satır kimliği (`sid`): yeni satıra bir kez verilir, yer değiştirse de değişmez. İnceleme işaretleri ve DYL-13 geçmişi buna bağlanır. Mevcut sahnelere bir kez toplu olarak eklenir.
    5. Geri al ve yinele.
    6. Kaydetmek: tarayıcıdan sahne dosyası indirilir. Biçim DIY-01a şemasıdır, Godot aynı dosyayı okur. Dosyaya değişiklik günlüğü (kim, ne zaman, kaç satır) eklenir. Site `data/soz` altına yazmaz.
    7. Sitede yapılan değişiklik inceleme işaretlerini silmez; değişen satırlar DYL-13 kuralıyla "yeniden incele" olur.
  - Uç durumlar: İndirilen dosya DIY-01a şemasından geçmezse kayıt tamamlanmaz ve DYL-16 altın klasörüne yazılmaz. Geri al `sid` silmez. Hedefi olmayan bağlantı kaydedilemez.
  - Kabul: Yusuf sahnesinde eklenen düğüm bağlanır, düzeltilen satır indirilip yeniden yüklenince doğrulamadan geçer (`tests/tools/test_soz_duzenleyici.py`). Hedefi olmayan bağlantı kayda 0 satır yazar. Geri al `sid` değerini silmez. Şemaya uymayan indirme altın klasöre 0 dosya yazar. Ek şart: site kaydı `data/soz` altına yazmaz; HAT.md onayı olmadan kopya 0'dır.
  - Bağımlılık: DIY-01a, YAZ-10, DYL-13. Boyut: L (prototip aracı).
  - Dosya: `Roadmap-2/soz_agaci/duzenleyici.js` (yeni dosya); şemaya `sid` alanı.
  - Asset: asset gerekmedi.


### 25.10 Sınır ve kapanış

- [ ] **DYL-16:** Ortak test dosyaları — prototip ve oyun aynı sonucu verir.
  - Ne: Prototipte "kayıt al" düğmesi seçimleri ve kayıtlı zar sonucunu beklenen satır kimlikleriyle `tests/soz/altin/` altına yazar. Godot aynı dosyayı `SozMotoru` ile oynatır; JS motoru da aynı kaydı oynatır. Ayrışan adım fark raporunda görünür. Bu kayıtta canlı zar çağrısı yoktur.
  - Kurallar:
    1. Prototipten "altın oynanış" kaydı alınır: bağlam, seçim dizisi, zar sonuçları (kayıtlı değer) → beklenen satır kimlikleri dizisi ve son durum (tansiyon, güven, sabır, bayraklar, beyanlar, söylenenler, karar).
    2. Kayıtlar `tests/soz/altin/*.json` altında durur. GDScript birim testi her kaydı `SozMotoru` ile oynatır ve birebir karşılaştırır. JS motoru da aynı kayıtları oynatır.
    3. Sahne başına en az: her son için bir oynanış; kesme, kesilir, söylenen, varyant seçimi, güvenle ve korkuyla sır açılması, kaçış. Prototipte "kayıt al" düğmesi bulunur.
    4. İki motor ayrışırsa hakem şema belgesidir (DIY-01a). Fark raporu hangi adımda ayrıldığını gösterir.
    5. Sanity tam paketine girer (`tools/sanity_check.py` tek satır).
  - Uç durumlar: Şemadan geçmeyen indirilen sahne altın oynanışa girmez ve Godot o dosyayı okumaz. Altın oynanış kayıtlı zarı kullanır; canlı zar çağrısı 0’dır. Eksik son için altın dosyası yoksa 15/15 kabulü verilmez.
  - Kabul: Yusuf için en az 15 altın oynanış iki motorda da 15/15 biter (`tests/unit/soz/altin_oynanis_test.gd`). Şemaya uymayan indirilen dosya 1 hata verir ve altın klasöre girmez. Bilerek bozulan bir etki, fark raporunda ayrıldığı adımı gösterir. Altın oynanışta canlı zar çağrısı 0'dır. Ek şart: `--check` farkı 0 değilse altın klasörüne kopya yazılmaz. Ek şart: aynı tohum ve aynı eylem dizisi iki ayrı koşuda aynı dal kimliğini seçer.
  - Bağımlılık: DIY-01a, DIY-02, KOP-09. Boyut: M.
  - Dosya: yeni `tests/soz/altin/`, `tests/unit/soz/altin_oynanis_test.gd`; prototipte kayıt düğmesi.
  - Asset: asset gerekmedi.

---

## BÖLÜM 25a: Sevilen Yüz — Köyde Tekrar Görme (Faz 4)

### 25a.1 Boş gün

- [ ] **SEV-01:** Boş gün köy günüdür.
  - Ne: Boş günü KAP-16 üretir; bu madde ikinci bir "kimse gelmesin" zarı açmaz. O gün oyuncu ateş başına veya bir tezgâha yürüyebilir ve orada en çok iki satır duyar. Satır, orada duran kişinin işinden gelir; ödül, eşya veya bar vermez. Kişi yoksa satır da yoktur. Gözcü boş günü bildirmeye devam eder. İki boş gün art arda aynı satırı tekrarlamaz; havuz bitince o gün sessizdir.
  - Kabul: KAP-16'nın ürettiği bir boş günde ateş veya tezgâh etkileşimi açılır ve bar değerleri değişmez (`tests/unit/koy/sevilen_yuz_test.gd`). Dolu günde bu etkileşim kapalıdır. Kapı kapalıyken ateş satırı yine gelebilir. Ek şart: Boş gün yeni panel sınıfı açmaz; köy kadrajı durur. Ek şart: `bos_gun_durusu.gd` `koy_sahnesi` import etmez ve ikinci harita açmaz.
  - Bağımlılık: KAP-16, YAZ-08. Boyut: S.
  - Dosya: yeni `src/koy/bos_gun_durusu.gd`; ANI-07 toplanma noktasına tek etkileşim.
  - Asset: asset gerekmedi. Ateş ANI-07'de duruyor.


### 25a.2 Ateş

- [ ] **SEV-02:** Tanıdık yüz ateşe gelir.
  - Ne: Boş günde ateşe gelen kişi köyde yaşayan adlı biridir; kapı kuyruğuna eklenmez, yatak ve kabul kararı istenmez. Selam `son_karar` ile bir somut anıyı kullanır: verilen ekmek, sorulan ad veya çevrilen akraba. Anı yoksa genel selam da yoktur ve kişi o akşam gelmez. Kadrodan 2 veya 3 kişi `hitap: aliskanlik` ile Jorji tipindedir; yeni kişilik sistemi açılmaz. Aynı kişi art arda iki boş olmayan akşamda zorla getirilmez; aralık veri dosyasındadır. Ölen, köyü terk eden veya ret yemiş ve köyde olmayan kişi içeri alınmaz.
  - Kabul: Köydeki bir kişi için `son_karar` kayıtlıyken ateş selamı o kararı anar (`tests/unit/koy/sevilen_yuz_test.gd`). Anı silinince selam gelmez ve kuyruk uzunluğu değişmez. Ek şart: Bir boş günde ateşe en çok bir kişi gelir. Ek şart: Çocuk ateşe yalnız çağrılmaz; yanında yetişkin yoksa o akşam geliş olmaz. Ek şart: Eş akşam sohbeti aynı gecede açıksa ateş selamı açılmaz. Ek şart: Ateş selamı yeni sahne açmaz; duran köy kadrajında iki satırdır. Ek şart: Yeni ateş ses dosyası eklenmez.
  - Bağımlılık: SEV-01, DIY-11. Boyut: M.
  - Dosya: `src/koy/bos_gun_durusu.gd` genişler; `data/soz/tanidik_yuz.json`.
  - Asset: asset gerekmedi.


### 25a.3 İz

- [ ] **SEV-03:** Kişisel iz köyde kalır.
  - Ne: İz, heybede duran `Clue_*` eşyasının küçük yer tutucusudur; yeni heybe motoru yoktur. Yer, kişinin iş binasıdır; bina yoksa iz evin yanında durur ve bina kendiliğinden kurulmaz. Rüşvetle alınan eşya muhafız odasındaki raftadır ve etiketi ekşidir. Gönüllü verilen lokmanın etiketi sıcaktır. İkisi de aynı raftadır. Kişi ölünce veya temelli gidince iz kalkar. İz üretim vermez. Aynı eşya hem köy izi hem oda rafı olamaz.
  - Kabul: CHR_017 kabul ve sır çözülmüşken kurdele ağıl yerinde görünür (`tests/unit/koy/sevilen_yuz_test.gd`). Rüşvet eşyası yalnız odada ve ekşi etikettedir. Kişi köyden düşünce iz kalkar. Ek şart: Bir kişinin köyde aynı anda bir izi vardır. Ek şart: İz dururken o iş noktasına otomatik işçi yazılmaz. Ek şart: Kartta iz bir kelime olarak durur, sayı olarak durmaz. Ek şart: Kayıtta iz alanı yoksa kişi izsiz açılır.
  - Bağımlılık: DIY-11, SEV-07. Boyut: M.
  - Dosya: yeni `src/koy/kisisel_iz.gd`; ODA-03 rafına etiket adaptörü.
  - Asset: iz yer tutucusu envantere `SEV03-IZ`; düz renk küçük kutu. Oda rafı için yeni model yok.


### 25a.4 Tek istek

- [ ] **SEV-04:** Tek istek.
  - Ne: Kişi köye yerleştikten sonra bir kez, bir cümleyle bir şey ister. İstek `gun_min` ve `gun_max` taşır. Tutmak isteğe bağlıdır; tutulmazsa süre bitince bir satır değişir. Ceza barı, yeni düşman veya zorunlu görev doğmaz. Aynı anda oyuncunun önünde en çok bir istek cümlesi durur. İstek muhafızın borcu değildir (DYL-05). Süre dolmadan kişi ölürse istek kapanır. Şart olan bina yoksa istek açılmaz.
  - Kabul: Bir test kişisinde istek bir kez konuşulur, süre bitince satır değişir ve ikinci istek açılmaz (`tests/unit/koy/sevilen_yuz_test.gd`). Görev listesi düğümü yoktur. Ek şart: İstek kapıdaki kabul veya ret düğmesini açmaz. Ek şart: İstenen kaynak yoksa istek kapanır ve bedelsiz tamamlanmaz. Ek şart: Çocuk istek sahibi olmaz. Ek şart: Reddedilen istek yeni bar açmaz; husumet artışı varsa duran `husumet.gd` kaydına yazılır. Ek şart: Yükleme aynı isteği ikinci kez açmaz. Ek şart: Hediye takvimi yazılmaz.
  - Bağımlılık: YAZ-08, DIY-11. Boyut: S.
  - Dosya: yeni `src/koy/tek_istek.gd`; `data/soz/istekler.json`.
  - Asset: asset gerekmedi.


### 25a.5 Bağ

- [ ] **SEV-05:** Köylüler birbirine bağlanır.
  - Ne: Bağ, UZM-07 kaydının dostluk ucudur. Düşman çifti aynı binada üretimi durduruyor; bu madde o kavgayı ikinci kez kurmaz. Dost çift aynı binada çalışırken verime dosyadaki küçük farkı ekler ve ateşte bir cümle duyulur. Fark koda gömülmez. Bağ `baglar` alanından gelir. Yeni ilişki ekranı yoktur. Taraflardan biri köyde değilse cümle ve verim farkı uygulanmaz. Düşman bağı ile dost bağ aynı çifte yazılamaz.
  - Kabul: Dost çift aynı binadayken verim, tablodaki fark kadar artar ve ateşte bir satır duyulur (`tests/unit/koy/sevilen_yuz_test.gd`). Düşman çiftte UZM-07 davranışı değişmez. Biri köyde değilken fark uygulanmaz. Ek şart: Bağ grup itibarına yazılmaz. Ek şart: Bağ kartta tek kelime olarak durur, sayı olarak durmaz. Ek şart: Aynı günde yeni bağ en çok bir çift için kurulur. Ek şart: Kayıtta bağ alanı yoksa çift bağsız açılır. Ek şart: Bağ kalp alanı, romans veya hediye isteği yazmaz.
  - Bağımlılık: YAZ-09, SEV-01. Boyut: S.
  - Dosya: `src/koy/koylu_bagi.gd` ince adaptör; UZM-07 veri kaydına `uc: dost|dusman`.
  - Asset: asset gerekmedi.

### 25a.6 Ad

- [ ] **SEV-06:** İsim ancak sorulunca kartta durur.
  - Ne: Yüzen kart ANI-14'tür; yeni kart yoktur. Gerçek ad sorulmuşsa (`Flag_Kimlik_Cozuldu` veya sözdeki ad beyanı) kart o ada döner. Sorulmadıysa kart `Persona_Maskesi` kısa adını gösterir. Oyuncu adı köy sohbetinde de öğrenebilir; öğrenince kart döner. "Adı göster" düğmesi yoktur. Adsız figürün gerçek adı yoktur, kart sınıf adında kalır. Eşin adı açılışta bilinir ve maske kuralına girmez.
  - Kabul: CHR_017 kapıda ad sorulmadan kabul edilirse kart "çoban" maskesinde kalır; ad sorulmuş kabulde kart "Fadime" olur (`tests/unit/koy/sevilen_yuz_test.gd`). Bayrak yokken Fadime yazısı görünmez. Ek şart: Yükleme ad bayrağını kendiliğinden açmaz; sorulmamış kart maskede kalır.
  - Bağımlılık: DIY-11, YAZ-08. Boyut: S.
  - Dosya: ANI-14 kart metnine tek koşul.
  - Asset: asset gerekmedi.


### 25a.7 Veda

- [ ] **SEV-07:** Veda o kişiyi götürür.
  - Ne: Cenaze akışı KRI-05'tir; toplu mezar, tören ve yas süresi yeniden yazılmaz. Tören, bilinen adı söyler; bilinmiyorsa maske adını söyler. Kişisel iz kalkar. İşlediği tezgâh veya tarla noktası bir gün boş kalır ve yerine otomatik işçi konmaz. Yeni yas sayacı açılmaz. Adsız figürün vedası adı olmayan bir satırdır ve izi yoktur. Eşin ölümü ACL-02 yasını kullanır; bu madde ikinci bir yas yazmaz. Tezgâh yoksa yalnız ad söylenir.
  - Kabul: Adlı bir ölümde gece raporu adı yazar, iz kalkar ve ilgili iş noktası ertesi gün boştur (`tests/unit/koy/sevilen_yuz_test.gd`). KRI-05 seçenekleri toplu mezar ve tören olarak iki tanedir. Ek şart: Yeni mezar modeli ve yeni veda ses dosyası eklenmez.
  - Bağımlılık: SEV-03, SEV-06. Boyut: S.
  - Dosya: `src/koy/cenaze_yasi.gd` adaptör; bir satır ad, bir satır boş tezgâh.
  - Asset: asset gerekmedi. Mezar yer tutucusu KRI-05'te duruyor.

Bölüm 25a alt başlığı dörttür, onun altındadır: yedi madde dört kümeye düşer; yeni madde eklenmedi, köyde tekrar görme SEV-01…07 ile sınırlıdır.


### 25a.8 Kadraj

### 25a.9 Kayıt

---

## BÖLÜM 26: Nöbet devri


Oyuncu köydeyken kapı boş kalmaz. Nöbeti tutan bir kişi vardır. Zemin ANI-02 devriye rotası ve HAR-15 güvenlik hesabıdır. Yeni ordu, yeni harita ve yeni savaş yok. Gece vardiyasının yorgunluğu UZM-14, uykusu YSM-03, fırtınanın kuyruk ve görüşü MEV-15 ile MEV-09, kıtlıkta nöbetçinin ambara gitmesi KRI-14'tür. Bu bölüm o kayıtları okur.

Kimlik numaraları yeniden sıralanmaz. `src/koy/kapi_nobeti.gd` henüz yoktur.

**Madde biçimi:** Ne, numaralı Kurallar, Uç durumlar, Kabul ve test, Bağımlılık, Boyut, Dosya, Asset.

---

### 26.1 Nöbetçinin kimliği ve kapıya etkisi

- [x] **NBT-01:** (testx) Kapıda tek yuva.
  - Ne: Direğin üstündeki ad, yuvaya yazılmış köylünün kayıtlı adıdır. Kapıda ikinci yuva yoktur; ANI-02 rotası kapıya uğradığında orada bu kişi durur.
  - Kurallar:
    1. Kapıda tek nöbet yuvası vardır. Yuvaya köyde yaşayan bir kişinin kimliği yazılır.
    2. ANI-02 rotası (kapı, kışla, sur) durur. Bu madde rotayı yeniden çizmez. Rota kapıya uğradığında orada yuvadaki kişi durur.
    3. ISG-02 "gece bekçisine eşlik" işi yuvanın kendisi değildir. Eşlik eden ikinci kişidir. Yuva boşken eşlik eden yuvaya kendiliğinden geçmez.
    4. Kapı ACL-01 gereği kapalıysa yuva boş durabilir. Kapı açıldıktan sonra (ACL-04 ertesi sabah) yuva boşsa NBT-08 işler.
  - Uç durumlar: köyde asker yoksa yuvaya yazılacak kimse çiftçi veya esnaf olabilir. Bu atama NBT-02 uyarısını açar, atamayı reddetmez. Ölen kişinin kimliği yuvada kalamaz, sabah düşer.
  - Kabul: Kapı açık ve oyuncu köydeyken direkte görünen ad, yuva kimliğinin kayıtlı adıyla aynıdır; ikinci yuva 0'dır (`tests/unit/koy/kapi_nobeti_test.gd`). Eşlik işi yuvayı tek başına doldurmaz. Ek şart: Oyun açılışında yuva boştur; oyuncu kendiliğinden nöbetçi yazılmaz ve liste boşsa zorla köylü konmaz. Ek şart: Nöbetçi köy kartından seçilir, ayrı nöbet sahnesi açılmaz. Ek şart: Yuvadaki kişi o gece kendi işinde üretim yazmaz; sabah ölmediyse eski işine döner. Ek şart: Yuva, devir, görülenler, fırtına, uyku ve boş direk tek kayıt sözlüğündedir. Ek şart: Nöbet, `muhafiz_maas` dışında ikinci bir maaş açmaz. Ek şart: Yeni sahne, ses dosyası ve kalp alanı eklenmez. Ek şart: Çınar meclisi nöbetçi maaşını değiştirmez.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: yeni `src/koy/kapi_nobeti.gd`; ANI-02 kapı noktasına tek okuma.
  - Asset: asset gerekmedi. Meşale ANI-01 soketindedir.

- [ ] **NBT-02:** Yanlış nöbetçi bir geleni kaçırır.
  - Ne: Eş ve çocuk yuvaya konamaz. Asker olmayan yetişkin veya yorgun kişi durursa o gecenin bir geleni sabah raporunda görülmedi diye durur; gelen KAP-16 listesinden kalkmaz.
  - Kurallar:
    1. Yanlış kişi şunlardır: çocuk (UZM-08 çalışmaz), eş (ACL-02 kapı nöbetine yazılamaz), yorgunluk eşiğini aşmış kişi (YSM-01), mesleği asker olmayan yetişkin. Asker olmayan yetişkin yazılabilir ama yanlış sayılır.
    2. Eş yuvaya konamaz. Düğme kapalıdır.
    3. Çocuk yuvaya konamaz.
    4. Yanlış yetişkin veya yorgun kişi durursa HAR-15 güvenlik katkısı o kişinin beceri ve sağlık teriminden gelir. Yeni güvenlik sayısı açılmaz. Ayrıca o gece kapıya gelen bir kişinin varışı sabah raporuna "görülmedi" diye düşer. Gelişin kendisi KAP-16'dadır, silinmez.
    5. Doğru kişi (asker, yorgun değil) "görülmedi" üretmez.
  - Uç durumlar: yorgun asker yanlış sayılır, mesleği asker diye affedilmez. Eş ve çocuk için kayıt denemesi 0 yazar. Görülmeyen kişi köye gizlice eklenmez. Yalnız rapor satırı eksik kalır.
  - Kabul: Eş ve çocuk ataması 0 kez yazılır. Yorgun olmayan askerde görülmedi satırı 0'dır. Asker olmayan yetişkinde o gecenin bir geleni raporda görülmedi olur ve HAR-15 aynı fonksiyondan okunur (`tests/unit/koy/kapi_nobeti_test.gd`). Ek şart: Usta yuvaya yazılamaz; kimin listeleneceği meslek kaydından okunur. Ek şart: Görülmeyen geliş ertesi gece yeni bir kuyruk kaydı olarak doğmaz; KAP-16 satırı durur.
  - Bağımlılık: NBT-01. Boyut: S.
  - Dosya: `src/koy/kapi_nobeti.gd`; HAR-15 hesabına yeni fonksiyon yok, duran fonksiyon okunur.
  - Asset: asset gerekmedi.

### 26.2 Devir zamanı, fırtına ve uyku

- [ ] **NBT-03:** Akşam teslim, sabah aynı yuva.
  - Ne: Gün kapanırken yuvadaki kişi tutan olur; sabah yuva kendiliğinden boşalmaz. Devir kaydı bırakan ve alan adını taşır, ayrı bir sahne açmaz.
  - Kurallar:
    1. Akşam, gün kapanırken yuvadaki kişi "tutan" olur. Sabah, gece hesabından sonra yuva boşaltılmaz. Oyuncu yeni bir ad yazarsa devir olur.
    2. Devir kaydı iki ad taşır: bırakan, alan. Aynı kişi iki gece durursa bırakan ve alan aynı addır. Bu da bir devirdir.
    3. Gün döngüsü ve gece sonu duran hesaptır. İkinci bir saat sistemi açılmaz.
    4. Devir anında en çok bir cümle vardır: bırakanın adı, alanın adı. Cümle gece raporunun malzemesidir (NBT-07). Ayrı bir sahne açılmaz.
  - Uç durumlar: akşam yuva boşsa devir kaydı "boş"tur, uydurma bir nöbetçi adı yazılmaz. Gece yarısı ölen tutan, sabah kaydında tutan olarak kalır ve yuva boşalır. Oyuncu köyde değil kapı sahnesindeyse devir yine yazılır, kapı sorgusu bölünmez.
  - Kabul: İki farklı kişide bırakan ve alan adları kayda uyar. Aynı kişi iki gece durunca iki ad da o kişidir. Boş yuvada uydurma ad 0'dır (`tests/unit/koy/kapi_nobeti_test.gd`). Ek şart: Aynı gece ikinci seçim veya ikinci devir öncekini bırakır ve yorgunluk kaydını bir kez yazar. Ek şart: Devir, kapı kuyruğunun sırasını silmez. Ek şart: Oyun hızı üç katındayken akşam devri bir kez yazılır. Ek şart: Eski kayıtta devir alanı yoksa nöbet yok sayılır ve kayıt açılır. Ek şart: Çınar meclisi açıkken nöbet devri aynı gece yazılır; meclis devri kesmez.
  - Bağımlılık: NBT-01. Boyut: S.
  - Dosya: `src/koy/kapi_nobeti.gd` kayıt alanı; gece sonuna tek satır.
  - Asset: asset gerekmedi.

- [ ] **NBT-04:** Fırtına bir geleni kaçırır.
  - Ne: Fırtına ve tipi MEV-09 ile MEV-15'ten okunur; kuyruk hesabı yeniden yazılmaz. Fırtına gecesinde doğru nöbetçi de bir geleni kaçırabilir ve sabah satırı tipi diye işaretler.
  - Kurallar:
    1. Fırtına ve tipi MEV-09 ile MEV-15'tir. Kuyruk daralması ve bulanık ipucu yeniden yazılmaz.
    2. Bu madde yalnız şunu ekler: fırtına gecesinde nöbetçi "görülmedi" sayısını NBT-02'deki yanlış kişi kuralından bağımsız bir artırır. Doğru kişi de fırtınada bir geleni kaçırabilir.
    3. Kaçırılan gelen KAP-16 listesinden silinmez. Sabah satırı "tipi, görülmedi" der.
    4. Fırtına yoksa bu artış 0'dır.
  - Uç durumlar: fırtına ve yanlış kişi aynı gece üst üste binirse iki ayrı "görülmedi" satırı yazılabilir, gelen iki kez silinmez. Kapı kapalıysa (ACL-01) fırtına satırı da yoktur, gelen yoktur. MEV-15 zaten kuyruğu sıfıra indirdiyse kaçırılacak gelen yoktur, satır "tipi, kapı boş geçti" olur.
  - Kabul: Fırtınasız doğru nöbetçide tipi satırı 0'dır. Fırtınalı gecede tipi ile görülmedi satırı en az 1'dir; kuyruk zaten boşsa satır tipi ve kapı boş geçti olur. Kuyruk uzunluğu bu maddeden sonra MEV-15 ile aynı kalır (`tests/unit/koy/kapi_nobeti_test.gd`).
  - Bağımlılık: NBT-02, NBT-03. Boyut: S.
  - Dosya: `src/koy/kapi_nobeti.gd`; MEV-09 bayrağına tek okuma.
  - Asset: asset gerekmedi.

- [ ] **NBT-05:** Uyuyan nöbetçi bir geleni kaçırır.
  - Ne: UZM-14 o gece uyku derse nöbetçi uyku halinde durur ve bir gelen uyudu diye işaretlenir. Yüzde tablosu bu maddede yoktur; kişi yatağına ışınlanmaz.
  - Kurallar:
    1. Uyuma ihtimali UZM-14 kaydıdır. Gece vardiyasında uyumama ve ertesi gün riski orada durur. Bu madde ikinci bir yüzde yazmaz.
    2. UZM-14 o gece uyku derse nöbetçi modelinde uyku hali oynar. Yeni animasyon üretilmez. Duran uyku veya çökme klibi yoksa idle eğik durur. Bu bir yer tutucudur.
    3. Uyuduğu gece NBT-02'deki gibi bir gelen "uyudu, görülmedi" diye işaretlenir. Gelen silinmez.
    4. YSM-03, nöbet tutan kişinin o gece yatakta uyumadığını zaten yazar. Bu madde onu eve ışınlamaz.
  - Uç durumlar: UZM-14 uyuma demezse eğik duruş da "uyudu" satırı da 0'dır. Çocuk ve eş zaten yuvada değildir (NBT-02). Uyuyan nöbetçi kıtlıkta ambara giderse (KRI-14) uyku hali biter, yuva NBT-08 gereği boş sayılır.
  - Kabul: UZM-14 uyku dediği gecede raporda uyudu ve görülmedi satırı 1'dir ve model uyku halindedir. Uyumadığı gecede bu satır 0'dır ve yüzde tablosu bu dosyada yoktur (`tests/unit/koy/kapi_nobeti_test.gd`).
  - Bağımlılık: NBT-04. Boyut: S.
  - Dosya: `src/koy/kapi_nobeti.gd`; UZM-14 sonucuna tek okuma.
  - Asset: asset gerekmedi. Uyku klibi yoksa idle eğik duruş yeter. Envantere yeni satır yok.

### 26.3 Görünen ve sabah raporu

- [ ] **NBT-06:** Görülenler listesi sorgu değildir.
  - Ne: Liste, o gecenin KAP-16 gelişlerinden görülmedi işaretli olmayan kimlikleri taşır. Listede replik, ipucu ve karar yoktur; kapı sahnesindeki sorgu bu listeden açılmaz.
  - Kurallar:
    1. Görülenler listesi o gecenin KAP-16 gelişlerinden, "görülmedi" işaretli olmayan adları taşır.
    2. Liste ad, sınıf ve bir kısa haldir (yorgun, aileli, tek). Replik, ipucu ve karar yoktur.
    3. Oyuncu kapı sahnesine geçince sorgu duran kapı akışındadır. Nöbetçi listeyi oyuncuya soru olarak açmaz.
    4. CHR heybesi ve tansiyon bu listede yoktur. Heybe motoru okunmaz.
  - Uç durumlar: boş gece (KAP-16) listeyi boş bırakır, uydurma yüz yazılmaz. Aile (KAP-17) listede bir satırdır, kişi sayısı yanındadır, her çocuk ayrı sorgu olmaz. "Görülmedi" olan ad listede yoktur.
  - Kabul: Üç gelişli bir gecede görülmeyen biri çıktıktan sonra listede 2 ad durur. Listede replik anahtarı 0'dır (`tests/unit/koy/kapi_nobeti_test.gd`). Ek şart: Görülen kişi köye kabul edilmiş sayılmaz ve `kabul_sayisi` artmaz. Ek şart: Görülenler listesi beyan defterine satır yazmaz. Ek şart: Görülenler kayıtta kimlik listesidir; düz ad gömülmez. Ek şart: Nöbet ekranı çizelge işaretine yazmaz.
  - Bağımlılık: NBT-05. Boyut: S.
  - Dosya: `src/koy/kapi_nobeti.gd` içinde görülenler listesi.
  - Asset: asset gerekmedi.

- [ ] **NBT-07:** Sabah raporunda iki nöbet satırı.
  - Ne: Duran gece raporuna iki satır eklenir; üçüncü nöbet satırı ve ikinci panel yoktur. İlk satır tutan adı, ikinci satır görülen ve görülmedi sayısıdır.
  - Kurallar:
    1. Satırlar duran gece raporuna eklenir. İkinci bir rapor paneli yoktur.
    2. İlk satır NBT-03 devridir: tutan ad, varsa bırakan ad.
    3. İkinci satır NBT-06 listesinin sayısı ile "görülmedi" sayısıdır. Fırtına (NBT-04) ve uyku (NBT-05) kendi sözcüğünü bu satıra ekler.
    4. Rapor kararı değiştirmez. Nöbetçi sabah rapordan sonra kendiliğinden cezalandırılmaz.
  - Uç durumlar: kapı kapalı gece (ACL-01) iki satırı da yazmaz. Boş gece "tutan ad, gelen 0" yazar. Tutan gece ölmüşse satır ölümü uydurmaz, "tutan sabaha kalmadı" der. Cenaze metni KRI-05'te kalır.
  - Kabul: Açık kapılı bir gecede nöbet satırı 2'dir. Kapalı kapıda nöbet satırı 0'dır. Fırtına sözcüğü fırtınasız raporda 0 kez geçer (`tests/unit/koy/kapi_nobeti_test.gd`). Ek şart: İki satır metin anahtarıdır; cümle betiğe düz yazılmaz. Ek şart: Hüküm sabahı nöbet raporunun iki satırını tam liste diye basmaz.
  - Bağımlılık: NBT-06. Boyut: S.
  - Dosya: gece raporu metnine tek çağrı; `src/koy/kapi_nobeti.gd` satırları üretir.
  - Asset: asset gerekmedi.

### 26.4 Boş direk ve oyuncunun dönüşü

- [ ] **NBT-08:** Boş direk gecenin gelişlerini kaçırır.
  - Ne: Kapı açık, oyuncu köyde ve yuva boşsa o gecenin gelişlerinin hepsi görülmedi olur. Oyuncu kapı sahnesindeyse bu kaçırma yazılmaz; kıtlık nöbetçiyi ambara çektiyse yuva o gece boş sayılır.
  - Kurallar:
    1. Şart: kapı açık, oyuncu köy sahnesinde, yuva boş. Üçü birden yoksa bu madde susar.
    2. O gece KAP-16 gelişlerinin hepsi "görülmedi" olur. Liste (NBT-06) boş kalır.
    3. KRI-14 nöbetçiyi ambara çektiyse yuva o gece boş sayılır. Kıtlık nöbeti yeniden yazılmaz.
    4. CAS gece takibi durur. Bu madde yeni bir sabotaj türü eklemez. Boş direk, duran takibe yeni bir fiil yazmaz.
  - Uç durumlar: oyuncu kapı sahnesine geçmişse direk boş olsa da bu madde "görülmedi" basmaz, sorgu oyuncunundur. İlk gün kapı kapalıyken boş direk hata değildir. Boş direk güvenlik formülüne ikinci bir ceza eklemez. HAR-15 zaten kişi yoksa katkı almaz.
  - Kabul: Üç şart birden varken gelişlerin tamamı görülmedi olur ve görülenler listesi 0'dır. Oyuncu kapı sahnesindeyken aynı gecede bu görülmedi sayısı 0'dır (`tests/unit/koy/kapi_nobeti_test.gd`). Ek şart: Boş direk yalnız o gecenin gelişlerini kaçırır; ertesi gece ceza birikmez. Ek şart: Oyuncu o gece nöbete yazılırsa boş direk kaçırması yazılmaz. Ek şart: Boş yuvada maaş satırı yazılmaz.
  - Bağımlılık: NBT-07. Boyut: S.
  - Dosya: `src/koy/kapi_nobeti.gd`; KRI-14 sonucuna tek okuma.
  - Asset: asset gerekmedi.

- [ ] **NBT-09:** Oyuncu kapıya girince nöbetçi kenara çekilir.
  - Ne: Kapı sahnesi açılınca yuvadaki kişi direğin yanına çekilir ve sorguyu oyuncu yürütür. Köye dönüşte aynı kimlik yuvaya geri gelir; nöbetçinin kaçırdığı satır durur, bakılan gelene oyuncu gördü eklenir.
  - Kurallar:
    1. Kapı sahnesi açılınca yuvadaki kişi direğin bir adım yanına çekilir. Sorgu düğmeleri ona ait değildir.
    2. O ana kadar yazılmış görülenler listesi durur. Oyuncunun baktığı gelişler listeye "oyuncu gördü" diye eklenir, nöbetçinin kaçırdığı satır silinmez.
    3. Oyuncu köye dönünce aynı kişi yuvaya geri döner. Yeni bir atama penceresi zorlanmaz.
    4. Kapı sahnesinin kamera ve diyalog akışı yeniden kurulmaz.
  - Uç durumlar: yuva boşken oyuncu kapıya girerse kenara çekilecek model yoktur, sorgu yine açılır. Nöbetçi uyku halindeyse (NBT-05) kenara çekilince uyku hali biter. İki nöbetçi modeli direğe üst üste binmez.
  - Kabul: Kapı sahnesinde replik söyleyen yuva kimliği 0'dır. Köye dönüşte yuva kimliği aynı kalır (`tests/unit/koy/kapi_nobeti_test.gd`). Ek şart: Oyuncu kendisi nöbetçi yazılırsa kapı sorgusu açılmaz ve köy kadrajı durur. Ek şart: Oyuncu nöbet tutarken kalan soru hakkı değişmez. Ek şart: Oyuncu nöbeti `muhafiz_maas` tutarını artırmaz. Ek şart: Oyuncu nöbeti kayıtta tek bayraktır; yeni bar açılmaz. Ek şart: Kapı ekranına yeni sinyal eklenmez.
  - Bağımlılık: NBT-08. Boyut: M.
  - Dosya: `src/koy/kapi_nobeti.gd`; kapı sahnesi açılışına tek çağrı.
  - Asset: asset gerekmedi.

### 26.8 Oyuncunun nöbeti

### 26.9 Maaş ve güvenlik

İnce satırların bir kısmı üst maddenin ek şartına alındı. Kodda bitenler kalktı. Başka dosyanın işi olan satırlar yerinde durur.


---

## BÖLÜM 27: Çınar meclisinin sesi


Oylama duruyor. KRI-07 krizde çınar altı meclisini açar, gizli oyu sayar, halkın kararını uygula veya reddet diye önüne koyar. Bu bölüm yeni meclis kurmaz. İçeri alınan kişiler konuşur. Şikâyet, gerçek bir kararın adını taşır. Oy, duran bir değere yazılır. Meclis her gece açılmaz.

Kalp puanı, romans ve seslendirme yok.

Kimlik aralığı MCL-01 … MCL-90'tır. Numaralar yeniden sıralanmaz.

**Madde biçimi:** Amaç, numaralı Kurallar, Uç durumlar, Kabul ve test, Bağımlılık, Boyut, Dosya, Asset.

---

### 27.1 Konuşan ve şikâyetin adı

- [x] **MCL-01:** (testx) Çınarın altında konuşan, içeri alınan kişidir.
  - Ne: Krizli gecede içeri alınmış ve o gece köyde yaşayan en çok üç kişi çınarın altında konuşur. Kapı kuyruğundaki, ret yemiş veya ölü kimlik satıra yazılmaz; adlı kimse yoksa oylama adsız tek satırla açılır.
  - Kabul: Krizsiz gecede konuşmacı sayısı 0'dır. Krizli gecede konuşanların hepsi köy kaydındadır ve sayı 3'ü geçmez. Ret yemiş bir kimlik satırda 0 kez durur (`tests/unit/koy/meclis_sesi_test.gd`). Ek şart: `meclis` adlı yeni sahne açılmaz ve wav dosyası eklenmez. Ek şart: `meclis_sesi.gd` ile KRI-07 paneli dışında üçüncü bir meclis dosyası açılmaz.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: yeni `src/koy/meclis_sesi.gd`; KRI-07 paneline konuşma listesi, oy hesabına dokunulmaz.
  - Asset: asset gerekmedi. Çınar ANI-07 ateş başındadır.

- [ ] **MCL-02:** Şikâyet, bir kararın adını taşır.
  - Ne: Şikâyet cümlesi, kapıda duran kararın adını ve hedef kişinin adını taşır; ad kabul, ret, rüşvet, kışla veya aileyi bölmeden biridir. Aynı karar ikinci ağza verilmez; kayıt yoksa o ağız susar ve genel yakınma satırı üretilmez.
  - Kabul: Karar kaydı olmayan köyde konuşma satırı 0'dır; KRI-07 oyu açılabilir. Bir ret ve bir rüşvet kayıtlıysa en az bir cümle bu adlardan birini taşır ve iki ağız aynı karar kimliğini tekrarlamaz (`tests/unit/koy/meclis_sesi_test.gd`). Ek şart: Aynı tohumla iki koşu aynı şikâyet karar kimliğini seçer. Ek şart: Divanda hükme bağlanmış karar ertesi mecliste şikâyet adayı olmaz. Ek şart: Şikâyet kaydı karar kimliğini tutar; kişinin düz adı kayda gömülü ikinci bir alan olmaz.
  - Bağımlılık: MCL-01. Boyut: S.
  - Dosya: `src/koy/meclis_sesi.gd`; kapı karar kaydına okuma.
  - Asset: asset gerekmedi.

- [ ] **MCL-03:** Eş veya usta söz isterse üç ağzın dışında bir satır alır.
  - Ne: Sağ eş, üç ağzın dışında bir satır alır ve cümlede mesleğinin sözcüğü durur; eş yoksa usta, dolu yapı bilgisinin adını söyler. Eş ile usta aynı gece ikisi birden konuşmaz ve bu satır üç ağzın yerine geçmez.
  - Kabul: Eş sağken ek satır 1'dir ve meslek sözcüğü cümlededir. Eş ölü, usta varken ek satır yapı adını taşır; ikisi de yokken ek satır 0'dır. Üç ağız duruyorsa toplam satır 4'ü geçmez (`tests/unit/koy/meclis_sesi_test.gd`).
  - Bağımlılık: MCL-02. Boyut: S.
  - Dosya: `src/koy/meclis_sesi.gd`; ACL-02 ve YAP-03 kaydına okuma.
  - Asset: asset gerekmedi.

### 27.2 Oy ve açılış sıklığı

- [ ] **MCL-04:** Oy, duran bir değere yazar.
  - Ne: Uygula ve reddet, KRI-07 tablosundaki sadakat ve moral farkını yazar; bu dosyada yeni bir oy katsayısı yoktur. Reddet, şikâyetin hedef kişisine gece boyunca bir kez "mecliste adı geçti" yazar; hafıza kaydı yoksa işaret gece raporunda kalır.
  - Kabul: Uygula ile reddet farklı sonuç yazar ve KRI-07 sayılarının dışında yeni bar anahtarı 0'dır. Hedef kişide "mecliste adı geçti" en çok 1'dir (`tests/unit/koy/meclis_sesi_test.gd`). Ek şart: Aynı düğmeye iki basışta sadakat farkı bir kez yazılır. Ek şart: Meclis sesi alanı olmayan eski kayıt açılır; o gece oy adsız durur ve işaret yazılmaz.
  - Bağımlılık: MCL-03. Boyut: S.
  - Dosya: `src/koy/meclis_sesi.gd`; KRI-07 sonuç fonksiyonuna tek işaret.
  - Asset: asset gerekmedi.

- [ ] **MCL-05:** Meclis her gece açılmaz.
  - Ne: İki meclis arasında en az dört gece vardır; süre `data/koy` meclis ayarından okunur ve koda gömülü ikinci takvim yazılmaz. Heyet veya açılış ulağı olan gece meclis ertelenir, ertelenen oy silinmez.
  - Kabul: Kriz sürerken art arda iki gecede meclis 0'dır. Dört gece sonra kriz duruyorsa meclis 1'dir. Heyet gecesinde meclis 0, ertesi uygun gecede 1'dir. Kriz o gece biterse ertelenmiş meclis açılmaz. Süre dolmadan zorla açılan meclis dört gece sayacını yine işletir (`tests/unit/koy/meclis_sesi_test.gd`). Ek şart: Kapının boş günü meclisi kendiliğinden açmaz; şikâyet kaydı duruyorsa boş gün meclisi engellemez. Ek şart: Hüküm sabahı meclis sahnesini açmaz.
  - Bağımlılık: MCL-04. Boyut: S.
  - Dosya: `src/koy/meclis_sesi.gd`; KRI-07 tetikine tek süre kapısı.
  - Asset: asset gerekmedi.

### 27.3 Karar cümlesi ve söz sırası

- [ ] **MCL-06:** Uygula ve reddet, konuşulan adı söyler.
  - Ne: Uygula ve reddet düğmelerinin altında konuşulan kararın adı ve kişisi yazar; alt satır yoksa düğme çalışır. Basılan düğme gece raporuna bu satırla bir kez düşer, gizli oy yeniden sayılmaz.
  - Kabul: Düğme sayısı 2'dir ve kimlikler KRI-07 ile aynıdır; üçüncü düğme 0'dır. Raporda karar adı 1 kez geçer (`tests/unit/koy/meclis_sesi_test.gd`).
  - Bağımlılık: MCL-05. Boyut: S.
  - Dosya: KRI-07 paneline tek alt satır; `src/koy/meclis_sesi.gd` metni verir.
  - Asset: asset gerekmedi.

- [ ] **MCL-07:** En ağır kararın sahibi önce konuşur.
  - Ne: İlk ağız, köyde duran en ağır kararın hedefidir; ağırlık akşam konuları tablosundan okunur, tablo yoksa sıra aileyi bölme, rüşvet, çocuklu ret ve ölümdür. Eşin ek satırı ağırlık sırasında yarışmaz, ilk ağızdan sonra gelir.
  - Kabul: Bölme ve rüşvet aynı köydeyse ilk ağız bölmenin hedefidir. Tablo yokken bölme, rüşvetten önce gelir. Eş satırı ilk ağız değildir (`tests/unit/koy/meclis_sesi_test.gd`).
  - Bağımlılık: MCL-06. Boyut: M.
  - Dosya: `src/koy/meclis_sesi.gd`; DYL-07 tablosuna okuma. Yazma yok.
  - Asset: asset gerekmedi.

### 27.4 Sınırlar

- [ ] **MCL-08:** Köyde olmayan kişi çınarın altında duramaz.
  - Ne: Liste her satırdan önce köy nüfusuna bakar; köyde olmayan kişinin cümlesi düşer ve sırada karar sahibi varsa o kişi geçer. O gece ölen veya divanla çıkan kişi listeyi bir satır kısaltır, meclis kapanmaz.
  - Kabul: Köyde olmayan kimlik listede 0'dır. Üç adaydan biri ölünce satır sayısı 2'dir ve meclis sürer. Sahnedeki model sayısı kalan satır sayısıyla aynıdır (`tests/unit/koy/meclis_sesi_test.gd`).
  - Bağımlılık: MCL-07. Boyut: S.
  - Dosya: `src/koy/meclis_sesi.gd`; nüfus kaydına tek süzgeç.
  - Asset: asset gerekmedi.

- [ ] **MCL-09:** Meclis savaş, bina ve son açamaz.
  - Ne: Meclis harita, sefer, yapı kademesi ve nihai son kaydını değiştirmez; yazabildiği yer KRI-07 farkı ile "mecliste adı geçti" işaretidir. Metinde sefer, düğün veya kalp sözcüğü varsa o cümle karar adına döner.
  - Kabul: Meclis gecesinden sonra HAR, YAP ve SYS-20 kayıtlarının özü değişmez. Yasak sözcük taramasında hata 0'dır. Fark ve işaret dışında yazılan alan 0'dır. Evlilik, hediye ve kalp alanı bu gecede yazılmaz (`tests/unit/koy/meclis_sesi_test.gd`). Ek şart: Reddet divan hükmü, infaz veya sürgün kaydı açmaz. Ek şart: Meclis nöbet yuvasına kimse yazmaz. Ek şart: Meclis kapı kabulü, reti, rüşveti, kışlayı veya aile bölmeyi yazmaz.
  - Bağımlılık: MCL-08. Boyut: S.
  - Dosya: `src/koy/meclis_sesi.gd` yazma listesi; `tools` tarafında meclis metni taraması tek liste.
  - Asset: asset gerekmedi.

### 27.6 Şikâyetin kaynağı

### 27.7 Perde 2 konusu

### 27.8 Panel

### 27.9 Aynı gece

---

## BÖLÜM 28: Hükmün sabahı


Zemin: divan hükmü CAS-07 üçlüsüdür (zindan, sürgün, infaz). Cenaze KRI-05 ve SEV-07 akışıdır. Mahkeme yeniden kurulmaz. KOP-01 divan konuşmasını yürütür; bu bölüm o konuşmayı yazmaz. Burada hükümden sonraki üç sabah köyde neyin değiştiği durur: hane kapısı, boş tezgâh, tek dedikodu satırı, zindanın ekmeği, sürgünün yolu.

Dönem 1240'lar. Yol adı metindir. İkinci harita, kalp puanı, romans ve ses yoktur. Her madde bir öncekinin kaydını okur.

### 28.1 Hükmün kaydı

- [ ] **SAB-01:** Gece hükmü sabah defterine tek satır düşer.
  - Ne: Gece bitince son CAS-07 kaydı deftere tek satır olur: kişi, hüküm (zindan, sürgün veya infaz) ve gün 0; ertesi sabah aynı satır basılmaz. Hüküm yoksa defter boş kalır ve sonraki sabahları açmaz; gece içinde değişen hükümden yalnız son hali okunur, ad sorulmamışsa maskede kalır.
  - Kabul: İnfaz gecesinin sabahında satır sayısı 1 ve `hukum` değeri `infaz` olur (`tests/unit/koy/sabah_defteri_test.gd`). Hüküm yokken satır 0, aynı kişiye iki yazımda satır 1 kalır. Meclis tutanağıyla birebir satır 0. Kayıtta düz metin alanı 0. Aynı sabah ikinci yol satırı 0. Yeni ses dosyası ve kalp anahtarı 0. Ek şart: Sabah defteri nöbetin görülenler listesini ikinci kez basmaz; nöbeti anarsa bunu tek satırda bırakır. Ek şart: Çınar meclisi sabah defterine cümle yazmaz; sabah satırının kaynağı CAS-07 hükmüdür. Ek şart: Ölüm sabah defterine tek satır yazılır; ikinci ölüm cümlesi açılmaz.
  - Bağımlılık: CAS-07. Boyut: S.
  - Dosya: yeni `src/koy/sabah_defteri.gd`; CAS-07 kaydına okuma.
  - Asset: asset gerekmedi.

### 28.2 İlk sabah köyde

- [ ] **SAB-02:** Evde kalanların adı kapı satırına düşer.
  - Ne: Satırdaki kişinin hanesinde veride kim varsa sabah kapısı onların görünen adını sayar; çocuk listede durur ama ağır işe yazılmaz. Kayıt yoksa veya kalan 0 ise sonuç `evi_bos` olur, evlilik ve yeni akraba eklenmez.
  - Kabul: Hanede 2 kişi varken sabah satırı 2 ad taşır (`tests/unit/koy/sabah_defteri_test.gd`). Hane kaydı yokken ad sayısı 0 ve kayıt `evi_bos` olur.
  - Bağımlılık: SAB-01. Boyut: S.
  - Dosya: `src/koy/sabah_defteri.gd`; hane kaydına okuma.
  - Asset: asset gerekmedi.

- [ ] **SAB-03:** Birincil iş yeri o sabah kapalı kalır.
  - Ne: Hükümlünün birincil iş yeri o sabah `kapali` olur ve o gün kişi katkısını duran hesaba yazmaz. İki yer bağlıysa yalnız birincil kapanır; tezgâh yoksa veya yer zaten kapalıysa yeni bayrak ve ikinci tabela yazılmaz.
  - Kabul: Demirhaneye bağlı bir zindan hükmünde sabah demirhane `kapali` ve kişi katkısı 0 olur (`tests/unit/koy/sabah_defteri_test.gd`). Tezgâhsız kişide `kapali` bayrağı 0.
  - Bağımlılık: SAB-02. Boyut: M.
  - Dosya: `src/koy/sabah_defteri.gd`; ANI-08 düğümüne `kapali` adaptörü.
  - Asset: kapalı örtü envantere `SAB03-ORTU`; yer tutucu düz renk bez, ANI-08 düğümünün üstünde.

- [ ] **SAB-04:** Kapalı tezgâh tek dedikodu satırı olur.
  - Ne: Kapalı tezgâh varsa o sabah tek dedikodu satırı tezgâhın adını taşır; tezgâh yoksa konu hüküm değeridir. Tanık yoksa satır çıkmaz ve köy sohbeti ayrı bir infaz haberi üretmez.
  - Kabul: Tanıklı kapalı tezgâhta pusulada 1 satır vardır ve satır tezgâhın adını taşır (`tests/unit/koy/sabah_defteri_test.gd`). Tanıksız sabah satır sayısı 0. Aynı sabahta ikinci satır 0.
  - Bağımlılık: SAB-03, DIY-13. Boyut: S.
  - Dosya: `src/sistemler/dedikodu.gd` tek yazım; yeni gazete dosyası yok.
  - Asset: asset gerekmedi.

### 28.3 Hükmün yolu — zindan, sürgün, infaz

- [ ] **SAB-05:** Zindan payı bir erzak düşürür.
  - Ne: Zindan hükmünde hane doluysa pay onların erzağından 1 düşer, hane boşsa kamu ambarından 1 düşer; sürgün ve infaz erzak düşürmez. Erzak kalmamışsa kişiye `ekmek_yok` yazılır, kişi zindanda kalır ve bu pay onu öldürmez.
  - Kabul: Zindan ve dolu hanede hane erzağı 1 azalır, zindan payı 1 olur (`tests/unit/koy/sabah_defteri_test.gd`). İnfazda erzak deltası 0. Ambar 0 iken işaret `ekmek_yok` olur. Pay miktarı `data/koy/` içindedir. Eşin ayrı tüketimi ikinci kez düşmez. Çocuk bu paya yazılmaz. Aynı tohumla iki koşu aynı düşüşü yazar.
  - Bağımlılık: SAB-02. Boyut: S.
  - Dosya: yeni `src/koy/zindan_ekmegi.gd`; EKO-09 düşüşüne tek satır.
  - Asset: asset gerekmedi. Ekmek, duran erzak ikonudur.

- [ ] **SAB-06:** Sürgün kapıdan bir yol adıyla çıkar.
  - Ne: Sürgün sabahında kitaptaki bir yol adı (Sivas, Kayseri, Konya veya dosyadaki başka ad) kapı satırına yazılır, kişi nüfustan 1 düşer ve harita açılmaz. Hanede kalanlar köyde kalır; ad boşsa nüfus düşmez, çocuk yanında kayıt yoksa satır `açıkta` kalır ve kayıt görünen adı değil yol kimliğini tutar.
  - Kabul: Sürgünde nüfus 1 azalır ve sabah metninde bir yol adı vardır (`tests/unit/koy/sabah_defteri_test.gd`). Yol adı boşsa nüfus deltası 0. Zindan ve infazda yol satırı 0. Harita düğümü 0. Yol satırı için ses dosyası 0.
  - Bağımlılık: SAB-03. Boyut: M.
  - Dosya: `src/koy/sabah_defteri.gd`; `data/soz/surgun_yollari.json`.
  - Asset: asset gerekmedi.

- [ ] **SAB-07:** İnfaz sabahı duran cenazeyi açar.
  - Ne: İnfaz sabahı duran cenaze akışını bir kez çağırır; tören seçeneği iki kalır ve ad satırı bir kez yazılır. Zindan ve sürgünde cenaze açılmaz, kişi zaten ölü kayıtlıysa ikinci çağrı yazılmaz.
  - Kabul: İnfaz sabahında cenaze çağrısı 1 ve tören seçeneği 2 olur (`tests/unit/koy/sabah_defteri_test.gd`). Zindanda cenaze çağrısı 0. Ad satırı sayısı 1.
  - Bağımlılık: SAB-04, SEV-07. Boyut: S.
  - Dosya: `src/koy/cenaze_yasi.gd` tek çağrı; yeni tören dosyası yok.
  - Asset: asset gerekmedi. Mezar yer tutucusu KRI-05'te durur.

### 28.4 Sonraki sabahlar

- [ ] **SAB-08:** İkinci sabah ekmeği sürer, yolu basmaz.
  - Ne: Gün 0'dan 1'e çıkar ve yeni CAS-07 kararı yazılmaz; zindan payı bir kez daha düşer, sürgün yolu ile nüfus düşüşü tekrar yazılmaz. İnfazda tezgâh kapalı kalır, cenaze ikinci kez çağrılmaz ve dedikodu kimliği ikinci satır basmaz.
  - Kabul: Zindanın ikinci sabahında erzak bir kez daha 1 azalır ve dedikodu satırı 1 kalır (`tests/unit/koy/sabah_defteri_test.gd`). Sürgünün ikinci sabahında nüfus deltası 0. Kayıt yüklenince gün artışı 0. Gün tavanı `data/koy/` içindedir, betiğe gömülü 3 sabiti yoktur.
  - Bağımlılık: SAB-05, SAB-06, SAB-07. Boyut: S.
  - Dosya: `src/koy/sabah_defteri.gd`.
  - Asset: asset gerekmedi.

- [ ] **SAB-09:** Üçüncü sabah tezgâha vekil yazmaz.
  - Ne: Gün 2 olunca `kapali` bayrağı sürer; haneden kimse usta yazılmaz, çırak varsa rütbesi artmaz ve yas bitse de tezgâh burada açılmaz. Zindan payı üçüncü kez düşer, erzak yoksa `ekmek_yok` durur ve yeni dedikodu satırı yazılmaz.
  - Kabul: Gün 2'de `kapali` tezgâh 1 ve otomatik işçi 0 olur (`tests/unit/koy/sabah_defteri_test.gd`). Üç sabahın ekmek toplamı zindanda 3, infazda 0 ve sürgünde 0'dır. Dördüncü sabah bu hükümden ekmek düşüşü 0.
  - Bağımlılık: SAB-08. Boyut: S.
  - Dosya: `src/koy/sabah_defteri.gd`.
  - Asset: asset gerekmedi.

### 28.5 Hesap

- [ ] **SAB-10:** Üç sabahın sayıları kapanışta okunur.
  - Ne: Üçüncü sabahın sonunda kapanış yedi sayıyı okur: hüküm, hane kalanı, kapalı tezgâh, dedikodu, ekmek düşüşü, yol ve cenaze. Gün 2 olmadan kapanış görünmez; kapanış erzak, nüfus ve tezgâh yazmaz.
  - Kabul: Sürgünde cenaze 0 ve yol 1, infazda yol 0 ve cenaze 1, zindanda ekmek 3 ve yol 0 (`tests/unit/koy/sabah_defteri_test.gd`). Kişi kaydı yoksa kapanış `kayip` der, sayılar 0 yazılır ve sahne açık kalır.
  - Bağımlılık: SAB-09. Boyut: S.
  - Dosya: `src/koy/sabah_defteri.gd` kapanış sayımı.
  - Asset: asset gerekmedi.

### 28.6 Sabahın yeri

### 28.7 Ekmek

### 28.8 Yol

### 28.9 Kadraj

- [ ] **SAB-75:** Sabah paneli köy ekranında durur.
  - Ne: Hüküm satırı köy ekranında bir panelde durur ve kapı kuyruğu kurulmadan okunur. Ayrı sabah sahnesi açılmaz; panel `rapor_bekle` ayarını kullanır ve ikinci anahtar açmaz.
  - Kabul: Satır varken köy ekranında panel 1 ve sabah sahnesi 0 (`tests/unit/koy/sabah_defteri_test.gd`). Kuyruk kurulmadan panel okunmuş olur. Bu panel için ayar anahtarı 1.
  - Bağımlılık: SAB-01. Boyut: S.
  - Dosya: `src/arayuz/koy_ekrani.gd`
  - Asset: asset gerekmedi.

### 28.10 Sınır ve kapanış

Dördüncü ceza kodda üç kararla kapanmıştır. Kapanış paketi bu bölümdeki kabul satırlarının tekrarıydı.


---

## BÖLÜM 29: Tezgâhta gün


Zemin: çıraklık UZM-04 ve UZM-11, tezgâh hareketi ANI-08, zanaat siparişi TUC-05. Yeni üretim ağacı yok. YAP kademesi bu bölümde yazılmaz. Beş usta sabahında iş gözle değişir: ham, iz, biçim, ağız, teslim. Siparişin bir yüzü vardır. Usta yoksa çırak durur, gün ilerlemez, parçada titreme izi kalır.

Yerler döneme uygundur: ağıl, değirmen, demirhane, bez. Kalp puanı, romans, ses ve ikinci harita yoktur. Her madde bir öncekinin kaydını okur.

### 29.1 Yer ve yüz

- [x] **TEZ-01:** (testx) Dört tezgâhın yeri
  - Ne: Oyuncu sabah köyde ağılı, değirmeni, demirhaneyi ve bez tezgâhını ayrı iş yerleri olarak görür; her yer ANI-08 düğümüdür, düğümü olmayan yer iş almaz. Aynı anda bir tezgâhta bir görünür iş durur; yer kaydı düğüm kimliğidir, düz ad yazılmaz.
  - Kabul: Düğümü olan dört yerde açık iş 1, düğümü olmayan ya da ızgara hücresinin dışındaki yerde iş 0'dır (`tests/unit/koy/tezgahta_gun_test.gd`). `tezgahta_gun.gd` YAP kademesi yazmaz, EKO-04 un sayısı bu maddeden değişmez ve `koy_sahnesi` import etmez. Ek şart: iş köy ekranında durur, yeni sahne ve yeni meslek açılmaz. Ek şart: kış için beşinci yer açılmaz, mevsim MEV-01'den okunur. Ek şart: SEV-01 boş gününde açık sabah satırı silinmez.
  - Bağımlılık: ANI-08. Boyut: S.
  - Dosya: yeni `src/koy/tezgahta_gun.gd`; ANI-08 düğümüne okuma.
  - Asset: dört örtü envantere `TEZ01-ORTU` (ağıl kirli beyaz, değirmen taş gri, demir is, bez ham). Yer tutucu düz renk. Yeni model yok.
- [ ] **TEZ-02:** Siparişin yüzü
  - Ne: Açık TUC-05 siparişi dört yerden birine bağlanır; yüzü köyde duran bir hane, usta ya da tüccardır ve yüzü olmayan sipariş tezgâha inmez. Bir yüzün aynı anda bir açık siparişi vardır; kapı kuyruğundaki kimlik ve köyden ayrılmış kişi yüz olamaz.
  - Kabul: Bir bez siparişi bir köylü adına tezgâha iner (`tests/unit/koy/tezgahta_gun_test.gd`). `yuzsuz` kayıtta `gun` artışı 0'dır; aynı yüzde ikinci açık sipariş 1 doğrulama hatası verir. Ek şart: yüz kaydında ses anahtarı ve `kalp` alanı yoktur.
  - Bağımlılık: TEZ-01, TUC-05. Boyut: M.
  - Dosya: `src/koy/tezgahta_gun.gd`; `data/tez/siparis_yuzu.json`.
  - Asset: asset gerekmedi.

### 29.2 Beş sabah — ham, iz, biçim, ağız

- [ ] **TEZ-03:** Birinci sabah ham yığındır
  - Ne: Usta tezgâhtaysa ve stok en az 1 ise kayıt `gun` 1 ve hal `ham` olur; hammadde stoğundan bir kez 1 düşer. Stok 0 ise sabah açılmaz; satır kapı kuyruğu kurulmadan yazılır.
  - Kabul: Stok varken `gun` 1 ve hal `ham`dır (`tests/unit/koy/tezgahta_gun_test.gd`). Stok 0 iken `gun` 0 ve teslim 0'dır; aynı sabahda ikinci stok düşüşü yoktur.
  - Bağımlılık: TEZ-02. Boyut: S.
  - Dosya: `src/koy/tezgahta_gun.gd`.
  - Asset: ham blok envantere `TEZ03-HAM`; yer tutucu düz renk küp, örtünün üstünde.
- [ ] **TEZ-04:** İkinci sabah iz bırakır
  - Ne: `ham` kaydın sonraki usta sabahı `gun` 2 olur; parça düğüm, oluk, eğri çubuk ya da ilk kesik olarak görünür ve örtü rengi gün 1 ile aynı kalır. `gun` 1 yokken iz yazılmaz, teslim anahtarı bu kayıtta durmaz.
  - Kabul: `ham` kayıttan sonraki usta sabahı `gun` 2'dir (`tests/unit/koy/tezgahta_gun_test.gd`). `gun` 1 yokken `gun` 2 sayısı 0'dır.
  - Bağımlılık: TEZ-03. Boyut: S.
  - Dosya: `src/koy/tezgahta_gun.gd`.
  - Asset: iz bloğu envantere `TEZ04-IZ`; yer tutucu aynı küp, bir kenarı koyu.
- [ ] **TEZ-05:** Üçüncü sabah biçim verir
  - Ne: `gun` 2 varken bir usta sabahı `gun` 3 yazar ve etiket işin adını gösterir; yüz bu sabah parçayı alamaz. Biçim aleti stokta yoksa `gun` artmaz ve `titreme` 1 artar.
  - Kabul: `gun` 2 sonrası etiket gün 3 adını taşır ve teslim düğmesi 0'dır (`tests/unit/koy/tezgahta_gun_test.gd`). Sipariş türü dört yere uymazsa parça `gun` 2'de kalır.
  - Bağımlılık: TEZ-04. Boyut: S.
  - Dosya: `src/koy/tezgahta_gun.gd`.
  - Asset: biçim bloğu envantere `TEZ05-BICIM`; yer tutucu küp, etikette işin adı.
- [ ] **TEZ-06:** Dördüncü sabah ağız ve kenardır
  - Ne: `gun` 3 sonrası usta sabahı `gun` 4 olur; bez siparişi boya diyorsa ve boya stoğu varsa stoktan 1 düşer, boya yoksa parça `boyasiz` kalır. Kenar fire oranı `siparis_yuzu.json` içindedir, fire ikinci parça yazmaz ve demirhanede yeni ocak açılmaz.
  - Kabul: `gun` 3 kaydından sonraki usta sabahı `gun` 4'tür (`tests/unit/koy/tezgahta_gun_test.gd`). Boyasız bezde stok deltası 0'dır; demirhanede ocak düğümü 0'dır; teslim edilen parça sayısı 1 kalır.
  - Bağımlılık: TEZ-05. Boyut: S.
  - Dosya: `src/koy/tezgahta_gun.gd`.
  - Asset: ağız bloğu envantere `TEZ06-AGIZ`; yer tutucu küp, bir ucu açık renk.

### 29.3 Ustanın yokluğu ve teslim

- [ ] **TEZ-07:** Usta yoksa çırak titretir
  - Ne: Usta ölü, sürgün, zindanda, hasta, başka binada, o gece nöbetçi ya da YSM-02 bitkinse çırak tezgâhta durur, `gun` artmaz ve parçaya `titreme` 1 eklenir. Çırak yoksa veya SAB `kapali` ise `titreme` yazılmaz; rütbe UZM-11'den okunur, artmaz.
  - Kabul: Usta yok, çırak var, bir sabah: `gun` aynı, `titreme` 1, rütbe deltası 0'dır (`tests/unit/koy/tezgahta_gun_test.gd`). Çırak yokken `titreme` 0'dır; SAB `kapali` iken çırak sahnesi 0'dır.
  - Bağımlılık: TEZ-06, UZM-04, UZM-11. Boyut: M.
  - Dosya: `src/koy/tezgahta_gun.gd`; UZM rütbesine okuma.
  - Asset: titreme çizgisi envantere `TEZ07-TITREME`; yer tutucu blok üstünde eğri tek çizgi.
- [ ] **TEZ-08:** Beşinci sabah teslimdir
  - Ne: `gun` 4 ise sonraki usta sabahı `gun` 5 ve hal `tam` olur; parça yüzün ev kaydına 1 yazılır, TUC-05 siparişi kapanır ve ücret o siparişteki değerdir. Yüz köyde değilse veya yüzde ücret yoksa parça tezgâhta kalır ve sipariş açık kalır; parça ambara ikinci kopya yazılmaz.
  - Kabul: Beş ilerleyen usta sabahında sipariş kapalı ve ev kaydında parça 1'dir (`tests/unit/koy/tezgahta_gun_test.gd`). Yüz köyde değilken TUC-05 açık kalır; `titreme` 2 iken teslim olur ve işaret 2 kalır. Ek şart: aynı sipariş ikinci kez kapanmaz. Ek şart: teslim kapı kabulü sayılmaz, gelen sayısı değişmez. Ek şart: divan hükmü bu ücreti yazmaz.
  - Bağımlılık: TEZ-07, TUC-05. Boyut: M.
  - Dosya: `src/koy/tezgahta_gun.gd`; TUC-05 kapanışına tek satır.
  - Asset: teslim parçası envantere `TEZ08-PARCA`; yer tutucu düz renk, yüzde küçük kutu.

### 29.4 Tek cümle ve sayım

- [ ] **TEZ-09:** Yüz bir cümle söyler
  - Ne: Teslimde bir kez cümle yazılır; `titreme` 0 ise anahtar `tam`, 0'dan büyükse `egri` olur. Cümle erzak, akçe, rütbe ve itibar yazmaz; kayıt düz metni gömmez, anahtarı tutar.
  - Kabul: `titreme` 0 tesliminde anahtar `tam`, `titreme` 1 tesliminde `egri`dir (`tests/unit/koy/tezgahta_gun_test.gd`). Cümle sonrası erzak deltası 0 ve rütbe deltası 0'dır. Ek şart: anahtar eksikse parça eve inmez ve gece fazı açılır. Ek şart: cümle dosyasında ses yolu yoktur.
  - Bağımlılık: TEZ-08. Boyut: S.
  - Dosya: `data/tez/siparis_yuzu.json` iki cümle anahtarı.
  - Asset: asset gerekmedi.
- [ ] **TEZ-10:** Beş sabah sayılır
  - Ne: Sayım ilerleyen usta sabahını, `titreme` değerini, son `gun` değerini, teslimi, cümle anahtarını, rütbe deltasını, un deltasını ve kademe deltasını okur, bunlara yazmaz. Beş ilerleyen sabah `gun` 5 eder; her yok sabah `titreme`yi 1 artırır ve `gun` artırmaz.
  - Kabul: Usta her sabah oradaysa `gun` 5, `titreme` 0, teslim 1 ve cümle `tam` olur (`tests/unit/koy/tezgahta_gun_test.gd`). Bir sabah usta yok ve çırak varsa `gun` 4, `titreme` 1, teslim 0'dır; rütbe, un ve kademe deltaları 0'dır. Ek şart: aynı tohumla iki sayım aynı `gun`, `titreme` ve teslim sayılarını verir. Ek şart: hız 3 iken bir sabah `gun` değerini bir kez artırır. Ek şart: eski kayıtta sayım alanı yoksa teslim 0 ve `gun` 0 yazılır, gece fazı açılır.
  - Bağımlılık: TEZ-09. Boyut: S.
  - Dosya: `src/koy/tezgahta_gun.gd` sayım.
  - Asset: asset gerekmedi.

Alt başlık dörttür, onun altındadır: on madde dört kümeye düşer, yeni madde ve yeni sistem eklenmedi (indeks madde 9).

### 29.5 Ham ve iz

### 29.6 Teslim

### 29.8 Sınır

### 29.10 Kapanış

Alt başlık ona tamamlandı. Eski gövde durur. Yeni kimlikler TEZ-11 … TEZ-90. Her alt başlığa sekiz yeni satır kondu.


---

## BÖLÜM 30: Yılın izi


Zemin `MEV-01` … `MEV-15` duran mevsim döngüsüdür. Yıl 4 mevsim × 7 gündür; gün sayısı `mevsim_yoneticisi` kaydından okunur. Bu bölüm o motora bir kişinin satırını bağlar. 1240'lar Anadolu: cümle hasadı, kışı, tarlayı ve su sırasını söyler; tarih dersi açmaz.

Aynı iş burada yeniden kurulmaz. Kar örtüsü `MEV-04`'tür. Kış ölümü `MEV-02` / `MEV-11` ve `EKO-09` hesabındadır. Donmuş tarla `MEV-03`'tür. Hasat şenliği ve moral `MEV-08`'dir. Taşkın `MEV-06`'dır. Yaz su çarpanı `MEV-07`'dir. Su taşıma `ANI-03`'tür. Takvim göstergesi `MEV-12`'dir. Boş gün ateşi `SEV-01`'dir. Ateşe gelen tanıdık `SEV-02`'dir. Karttaki ad `SEV-06`'dır. Veda `SEV-07` ve `KRI-05`'tir. Beş nihai son `SYS-20`'dir.

Kalp puanı, hediye takvimi, romans ve seslendirme bu bölümde yoktur. Asset üretilmez.

#### 30.1 Yılın yüzü

- [ ] **YIL-01:** Yılın yüzü bir kişidir
  - Ne: Mevsim yılı açılırken köyde yaşayan adlı yetişkinlerden biri `yil_izi` alanına bir kez yazılır; tarla işi olan varsa o seçilir, tek adlı yetişkin eş ise o seçilir. Dört mevsim aynı kimliği okur; adsız, ölü ve köyden ayrılmış kişi seçilmez, kişi ölürse kalan slotlar boş kalır.
  - Kabul: Bir yılda `yil_izi` en çok bir kimliktir ve dört mevsim slotu o kimliği taşır (`tests/unit/koy/yil_izi_test.gd`). Köyde adlı kimse yokken satır 0'dır; boş günde yıl satırı 0'dır; ölümden sonra açılan slot 0 ve cenaze seçeneği 2'dir. Ek şart: aynı tohumla iki açılış aynı kimliği seçer. Ek şart: eski kayıtta `yil_izi` yoksa alan boş kalır ve mevsim günü artar. Ek şart: satır düz cümle gömmez, `data/soz/yil_izi.json` anahtarını okur. Ek şart: `yil_izi.gd` takvim düğümü açmaz ve `koy_sahnesi` import etmez. Ek şart: nöbet ataması değişmez ve nöbet gecesinde duyulmuş satır silinmez. Ek şart: anahtar yoksa o slot 0 sayılır, mevsim günü yine artar.
  - Bağımlılık: MEV-01, YAZ-08. Boyut: M.
  - Dosya: yeni `src/koy/yil_izi.gd`; `data/soz/yil_izi.json`. `mevsim_yoneticisi` tek okuma.
  - Asset: asset gerekmedi.

#### 30.2 Güz

- [ ] **YIL-02:** Güz sofrasında ad söylenir
  - Ne: Ambar doluyken MEV-08 şenliği açıksa sofrada bir satır, `yil_izi` kişisinin görünen adını söyler; şenliği bu madde kurmaz. Cümle ödül ve eşya vermez, moral artışı MEV-08 tablosunda kalır.
  - Kabul: Ambar dolu bir güz gününde sofra satırı 1'dir ve yıl dosyasından gelen moral 0'dır (`tests/unit/koy/yil_izi_test.gd`). Şenlik kapalıyken sofra satırı 0'dır. Ek şart: Söz motoru dosyası yokken sofra satırı yine 1'dir.
  - Bağımlılık: YIL-01, MEV-08, SEV-06. Boyut: S.
  - Dosya: `src/koy/yil_izi.gd`; `data/soz/yil_izi.json` anahtarı `guz_sofra`.
  - Asset: asset gerekmedi. Sofra `MEV-08` yerindedir.

- [ ] **YIL-03:** Şenlik yoksa harman cümlesi duyulur
  - Ne: Güzde şenlik kapalıyken harman ya da ambar sayımının yanında bir satır görünen adı söyler; yeni bina kurulmaz. Şenlik açıksa bu satır kapanır, kişi ölmüşse satır yazılmaz.
  - Kabul: Ambarsız güz gününde harman satırı 1, sofra satırı 0 ve moral deltası 0'dır (`tests/unit/koy/yil_izi_test.gd`). Şenlik açılınca harman satırı 0'a döner.
  - Bağımlılık: YIL-01, MEV-08, SEV-06. Boyut: S.
  - Dosya: `data/soz/yil_izi.json` anahtarı `guz_harman`.
  - Asset: asset gerekmedi.

#### 30.3 Kış

- [ ] **YIL-04:** Kışta dışarı ve ev iki ayrı cümledir
  - Ne: Kişi açıkta uyuyorsa o gece `kis_disari`, yatakta uyuyorsa `kis_ev` duyulur; iki anahtar aynı gece birlikte duyulmaz. Ölüm, donma ve odun cezası MEV-02, MEV-11 ve EKO-09 hesabında kalır, yıl satırı o zara yazmaz.
  - Kabul: Aynı kişi açıkta bir kış gecesinde `kis_disari` satırını duyar, yataklı gecede `kis_ev` duyar (`tests/unit/koy/yil_izi_test.gd`). Yıl satırı açıkken ve kapalıyken donma sayısı aynıdır. Ek şart: kış metni güz metniyle aynıysa 1 hata.
  - Bağımlılık: YIL-01, YSM-03, ACL-05. Boyut: S.
  - Dosya: `data/soz/yil_izi.json` anahtarları `kis_disari`, `kis_ev`.
  - Asset: asset gerekmedi.

- [ ] **YIL-05:** Kışın tarla susar
  - Ne: Mevsim kış ve iş noktası tarla ise yıl satırı 0'dır; üretim, don ve ürün MEV-03 değerinde kalır. Kışın `ilkbahar_tarla` cümlesi açılmaz.
  - Kabul: Kışın tarla yıl satırı 0'dır ve tarla üretimi MEV-03 ile aynıdır (`tests/unit/koy/yil_izi_test.gd`). Kış gününde `ilkbahar_tarla` satırı 0'dır.
  - Bağımlılık: YIL-01, MEV-03. Boyut: S.
  - Dosya: `src/koy/yil_izi.gd` kış kolu. Ayrı satır anahtarı yok.
  - Asset: asset gerekmedi.

#### 30.4 İlkbahar

- [ ] **YIL-06:** İlkbaharda tarlasına döner
  - Ne: Mevsim ilkbahar olunca ve MEV-03 kilidi kalkınca `yil_izi` kişisinin tarla iş noktasında bir satır duyulur; yeni tarla ve yeni ürün açılmaz. Kişinin tarla işi yoksa cümle kendi duran iş noktasında bir kez duyulur.
  - Kabul: İlkbaharın ilk gününde tarla satırı 1'dir ve tarla üretimi MEV-03 kalkmış haliyle aynıdır (`tests/unit/koy/yil_izi_test.gd`). Ölü kişide satır 0'dır; kış gününde satır 0'dır. Ek şart: ilkbahar satırı açıkken ISG-02 atama sayısı aynı kalır.
  - Bağımlılık: YIL-05, MEV-03. Boyut: S.
  - Dosya: `data/soz/yil_izi.json` anahtarı `ilkbahar_tarla`.
  - Asset: asset gerekmedi.

- [ ] **YIL-07:** Taşkın gününde bir cümle duyulur
  - Ne: Satır yalnız MEV-06 olayı o gün açıksa durur; bent kırmaz, kuyu kireci yazmaz ve onarım başlatmaz. Cümle `yil_izi` kişisinindir ve `ilkbahar_tarla` ile aynı metin olamaz.
  - Kabul: MEV-06 açık bir ilkbahar gününde taşkın satırı 1'dir (`tests/unit/koy/yil_izi_test.gd`). Olay kapalıyken satır 0'dır; bent onarım sayacı yıl satırı yüzünden değişmez.
  - Bağımlılık: YIL-01, MEV-06. Boyut: S.
  - Dosya: `data/soz/yil_izi.json` anahtarı `ilkbahar_taskin`.
  - Asset: asset gerekmedi.

#### 30.5 Yaz

- [ ] **YIL-08:** Yaz su sırasında bir söz duyulur
  - Ne: Mevsim yaz iken ANI-03 su taşıma sırasında bir satır duyulur; yeni kuyruk ve yeni su kaynağı açılmaz, su tüketimi MEV-07 çarpanında kalır. Kişi o gün su işinde değilse cümle sırada bir ağızdan duyulur; yaz değilse veya kişi ölmüşse satır 0'dır.
  - Kabul: Bir yaz su gününde satır 1'dir ve su tüketimi MEV-07 değeriyle aynıdır (`tests/unit/koy/yil_izi_test.gd`). Kişi su işinde değilken de satır 1'dir ve atama kaydı aynı kalır; yangın riski tablosu değişmez. Ek şart: susuzluk cezası YSM-02 değerinde kalır ve yaz satırı bar yazmaz.
  - Bağımlılık: YIL-01, MEV-07. Boyut: S.
  - Dosya: `data/soz/yil_izi.json` anahtarı `yaz_su`. `ANI-03` sırasına tek cümle.
  - Asset: asset gerekmedi.

#### 30.6 Ad ve kapanış

- [ ] **YIL-09:** Söylenen ad karttaki addır
  - Ne: Güz cümlesi SEV-06 görünen adını okur; ad bayrağı yoksa maskenin kısa adı, bayrak varsa gerçek ad söylenir. Yıl ortasında ad açılırsa sonraki slot yeni adı söyler, yazılmış satır değişmez.
  - Kabul: `CHR_017` ad bayrağı yokken güz cümlesinde "çoban" geçer ve "Fadime" 0'dır; bayrak varken "Fadime" 1'dir (`tests/unit/koy/yil_izi_test.gd`). Kartın kendi yazısı değişmez.
  - Bağımlılık: YIL-02, SEV-06. Boyut: S.
  - Dosya: `src/koy/yil_izi.gd` ad okuması. Kart dosyasına yazılmaz.
  - Asset: asset gerekmedi.

- [ ] **YIL-10:** Yıl kapanışında slotlar sayılır
  - Ne: Kapanış, dördüncü mevsimin yedinci gününün gecesidir; rapor güz, kış, ilkbahar tarlası, taşkın ve yaz slotlarından duyulanları sayar, en çok 5 olur. Rapor SYS-20 son kimliğine yazılmaz, ardından `yil_izi` temizlenir.
  - Kabul: 28. gece raporundaki sayı, o yıl duyulan satır sayısıyla aynıdır ve SYS-20 kimliği kapanıştan önce ve sonra aynıdır (`tests/unit/koy/yil_izi_test.gd`). Ölümden sonraki slot rapora girmez; boş izde rapor 0'dır. `yil_izi.json` içinde kalp, hediye, romans ve ses anahtarı 0'dır. Ek şart: hız 3 iken aynı slot bir gecede bir kez sayılır. Ek şart: kayıt yüklenince duyulmuş slot yeniden sayılmaz. Ek şart: kapanış satırı dünya zaman çizelgesine yazılmaz.
  - Bağımlılık: YIL-01, MEV-01, SYS-20. Boyut: S.
  - Dosya: `src/koy/yil_izi.gd` gece raporuna tek satır.
  - Asset: asset gerekmedi.

Alt başlık altıdır, onun altındadır: on madde mevsim sırasıyla altı kümeye düşer, yeni madde ve yeni sistem eklenmedi (indeks madde 9).

#### 30.7 Takvim sınırı

#### 30.8 Kadraj

#### 30.9 Kayıt

Alt başlık ona tamamlandı. Eski gövde durur. Yeni kimlikler YIL-11 … YIL-90. Her alt başlığa sekiz yeni satır kondu.


---

## BÖLÜM 31: Kayıt uyumu, göç ve doğrulama


Faz 2. Hafıza, güven ve korku kayda yazılır yazılmaz bu bölüm de yazılır. Söz dosyaları köye girmeden önce eski kayıt açılabilmelidir.

Zemin: atomik kayıt SYS-02, sürüm göçü SYS-01 ve SYS-14, adsız diyalog sırası SYS-16, metin anahtarı SYS-09, yirmi gece dumanı SYS-10, sanity SYS-06 ve SYS-11. Bunlar yeniden kurulmaz. Bu bölüm onların üstüne Söz alanlarını ekler. Hızlı kayıt ve kayıt yuvası Bölüm 35'tedir. Burada açılmaz. Ses yoktur. Asset gerekmez.

Alt başlıklar ondur. Her maddede dolgu yoktur. Ölçü, kaydet-yükle ikizidir.

### 31.1 Sürüm kapısı

- [x] **KAY-01:** (testx) Kayıt sürümü tek sayıdır ve dosyanın başında durur.
  - Ne: sürüm alanı yoksa yükleme durur, köy uydurulmaz.
  - Kabul: sürüm alanı yoksa yükleme durur, köy uydurulmaz. Test: alansız dosya reddedilir, yedek durur.
  - Bağımlılık: SYS-01. Boyut: S.
  - Dosya: `src/sistemler/guvenli_kayit.gd`.
  - Asset: asset gerekmedi.
- [x] **KAY-02:** (Kalfa) Gelecek sürüm açılmaz.
  - Ne: dosyadaki sürüm, oyunun bildiği sürümden büyükse yükleme reddedilir. Eski dosya ezilmez.
  - Kabul: dosyadaki sürüm, oyunun bildiği sürümden büyükse yükleme reddedilir. Eski dosya ezilmez. Test: sürüm +1 dosya.
  - Bağımlılık: KAY-01, SYS-14. Boyut: S.
  - Dosya: `src/sistemler/guvenli_kayit.gd`.
  - Asset: asset gerekmedi.
- [x] **KAY-03:** (Kalfa) Göç tek basamaklıdır.
  - Ne: N'den N+2'ye atlanmaz. Ara adım fonksiyonu çalışır.
  - Kabul: N'den N+2'ye atlanmaz. Ara adım fonksiyonu çalışır. Test: iki basamaklı fixtür, ara fonksiyon bir kez çağrılır.
  - Bağımlılık: KAY-01. Boyut: M.
  - Dosya: `src/sistemler/kayit_gocu_soz.gd` (yeni). `guvenli_kayit.gd` tek çağrı.
  - Asset: asset gerekmedi.
- [x] **KAY-04:** İçerik sürümü ile kayıt sürümü ayrıdır. (Antigravity)
  - Ne: `icerik_surumu` artınca kişi hafızası silinmez. Kayıt sürümü artınca katalog baştan kurulmaz.
  - Kabul: `icerik_surumu` artınca kişi hafızası silinmez. Kayıt sürümü artınca katalog baştan kurulmaz. Test: iki sayaç bağımsız. Ek şart: Eski kayıtta sabah defteri satırı yoksa satır boş sayılır ve oyun açılır. Ek şart: Eski kayıtta sabah gün sayacı yoksa sayaç 0 sayılır ve yükleme onu artırmaz. Ek şart: Eski kayıtta eylem listesi yoksa liste boş sayılır. Ek şart: Kayıt yüklenince aynı kapı eylemi ikinci kez uygulanmaz. Ek şart: Boş gün kayıtta bos türüyle durur; alan yoksa o gün yok sayılır.
  - Bağımlılık: KAY-01. Boyut: S.
  - Dosya: `data/ayarlar/icerik.tres` okunur, yazılmaz.
  - Asset: asset gerekmedi.
- [x] **KAY-05:** (Kalfa) Göç yarıda kalırsa ana dosya değişmez.
  - Ne: göç fonksiyonu hata verirse `bak.tmp` geri gelir. SYS-02 yolu ikinci kez yazılmaz.
  - Kabul: göç fonksiyonu hata verirse `bak.tmp` geri gelir. SYS-02 yolu ikinci kez yazılmaz. Test: göç ortasında fırlatılan hata, ana dosyanın sağladığı baytı korur.
  - Bağımlılık: SYS-02, KAY-03. Boyut: S.
  - Dosya: `src/sistemler/kayit_gocu_soz.gd`.
  - Asset: asset gerekmedi.
- [x] **KAY-06:** (Kalfa) Göç oyuncuya bir satır yazar.
  - Ne: başarılı göçte gece raporunda tek satır: hangi sürümden hangi sürüme. Satır dünya kitabı ağzında değildir, düzdür.
  - Kabul: başarılı göçte gece raporunda tek satır: hangi sürümden hangi sürüme. Satır dünya kitabı ağzında değildir, düzdür. Test: metin anahtarı tabloda vardır.
  - Bağımlılık: KAY-03, SYS-09. Boyut: S.
  - Dosya: `data/metin/metinler.csv` tek satır.
  - Asset: asset gerekmedi.

### 31.2 Söz alanlarının kayda girmesi

- [ ] **KAY-07:** Güven ve korku kişi kaydındadır.
  - Ne: DIY-17 değerleri optional alandır. Eski kayıtta alan yoktur. Yeni kayıtta 0–10 dışına çıkmaz.
  - Kabul: DIY-17 değerleri optional alandır. Eski kayıtta alan yoktur. Yeni kayıtta 0–10 dışına çıkmaz. Test: ikiz yüklemede iki sayı aynı.
  - Bağımlılık: DIY-17, KAY-03. Boyut: M.
  - Dosya: `src/soz/kisi_hafizasi.gd` kayıt adaptörü.
  - Asset: asset gerekmedi.
- [ ] **KAY-08:** Beyanlar ziyaret sonunda kişiye yazılır.
  - Ne: DIY-06 defteri gece kapanınca kişi kimliğinin altında durur. Aynı beyan iki kez yazılmaz.
  - Kabul: DIY-06 defteri gece kapanınca kişi kimliğinin altında durur. Aynı beyan iki kez yazılmaz. Test: aynı id ikinci yazımda liste uzamaz.
  - Bağımlılık: DIY-06, DIY-11. Boyut: M.
  - Dosya: `src/soz/beyan_defteri.gd`.
  - Asset: asset gerekmedi.
- [ ] **KAY-09:** Verilen sözler süreleriyle durur.
  - Ne: DYL-05 kaydı gün, tür ve tutuldu bilgisini taşır. Açık söz en çok 5'tir. Altıncı kayıtta yoksa yükleme onu düşürmez, günlük yazar.
  - Kabul: DYL-05 kaydı gün, tür ve tutuldu bilgisini taşır. Açık söz en çok 5'tir. Altıncı kayıtta yoksa yükleme onu düşürmez, günlük yazar. Test: süre günü kaydet-yükle ile kaymaz.
  - Bağımlılık: DYL-05. Boyut: M.
  - Dosya: `src/soz/verilen_soz.gd`.
  - Asset: asset gerekmedi.
- [ ] **KAY-10:** Muhafızın yalanı kayıtta `dogru: false` taşır.
  - Ne: DYL-04 kaydı yüklemede kaybolmaz. Ortaya çıkmış yalan bir daha gizlenmez.
  - Kabul: DYL-04 kaydı yüklemede kaybolmaz. Ortaya çıkmış yalan bir daha gizlenmez. Test: bayrak ikizde aynı.
  - Bağımlılık: DYL-04. Boyut: S.
  - Dosya: `src/soz/yalan_denetimi.gd`.
  - Asset: asset gerekmedi.
- [x] **KAY-11:** (Kalfa) Grup itibarı kayıttadır.
  - Ne: DIY-12 altı grup, her biri −10…+10. Eksik grup 0 sayılır, diğerleri bozulmaz.
  - Kabul: DIY-12 altı grup, her biri −10…+10. Eksik grup 0 sayılır, diğerleri bozulmaz. Test: Türkmen −3 yüklemede −3.
  - Bağımlılık: DIY-12. Boyut: S.
  - Dosya: `src/sistemler/grup_itibari.gd`.
  - Asset: asset gerekmedi.
- [x] **KAY-12:** (Kalfa) Dedikodu kuyruğu yaşıyla durur.
  - Ne: DIY-13 kaydı kaç gece önce doğduğunu yazar. Yüklemede yaş artmaz. Tanık biti korunur.
  - Kabul: DIY-13 kaydı kaç gece önce doğduğunu yazar. Yüklemede yaş artmaz. Tanık biti korunur. Test: tanıksız kayıt yüklemede hâlâ yayılmaz.
  - Bağımlılık: DIY-13, KOP-05. Boyut: M.
  - Dosya: `src/sistemler/dedikodu.gd`.
  - Asset: asset gerekmedi.

### 31.3 Bozuk ve eksik alan

- [ ] **KAY-13:** Eksik güven sıfırdır, hikâye uydurulmaz.
  - Ne: alan yoksa güven 0, korku o ziyaretin başlangıç tansiyonudur. Kişi kendiliğinden itiraf etmez.
  - Kabul: alan yoksa güven 0, korku o ziyaretin başlangıç tansiyonudur. Kişi kendiliğinden itiraf etmez. Test: alansız kayıtta itiraf seçeneği kapalı.
  - Bağımlılık: KAY-07. Boyut: S.
  - Dosya: `src/sistemler/kayit_gocu_soz.gd`.
  - Asset: asset gerekmedi.
- [ ] **KAY-14:** Sayı taşan alan kıskaçlanır ve günlüğe düşer.
  - Ne: güven 40 ise 10 olur. Süre −3 ise 0 olur. Köy barları bu kıskaçtan etkilenmez.
  - Kabul: güven 40 ise 10 olur. Süre −3 ise 0 olur. Köy barları bu kıskaçtan etkilenmez. Test: taşan fixtür açılır, günlükte bir satır.
  - Bağımlılık: KAY-13. Boyut: S.
  - Dosya: `src/sistemler/kayit_gocu_soz.gd`.
  - Asset: asset gerekmedi.
- [ ] **KAY-15:** Bilinmeyen kişi kimliği o kaydı düşürür, köyü düşürmez.
  - Ne: hafızada katalogda olmayan id varsa o kişi atlanır, diğer köylüler durur. Sessiz silme yoktur, geliştirme günlüğüne yazılır.
  - Kabul: hafızada katalogda olmayan id varsa o kişi atlanır, diğer köylüler durur. Sessiz silme yoktur, geliştirme günlüğüne yazılır. Test: sahte id, köylü sayısı aynı.
  - Bağımlılık: KAY-08. Boyut: S.
  - Dosya: `src/sistemler/kayit_gocu_soz.gd`.
  - Asset: asset gerekmedi.
- [ ] **KAY-16:** Bilinmeyen çekirdek, tohumu yeniden çekmez.
  - Ne: DYL-10 varyantı kayıtta yoksa o oyunda varyant seçilmez. Yeni tohum atılmaz.
  - Kabul: DYL-10 varyantı kayıtta yoksa o oyunda varyant seçilmez. Yeni tohum atılmaz. Test: aynı tohum, varyantsız kayıt, yüklemede hâlâ varyantsız.
  - Bağımlılık: DYL-10. Boyut: S.
  - Dosya: `src/soz/cekirdek_secici.gd`.
  - Asset: asset gerekmedi.
- [ ] **KAY-17:** Tipi yanlış alan göçü durdurur.
  - Ne: güven dizesi ("yüksek") gelirse göç hata verir, yedek yüklenir. Kıskaç uygulanmaz.
  - Kabul: güven dizesi ("yüksek") gelirse göç hata verir, yedek yüklenir. Kıskaç uygulanmaz. Test: tipi bozuk fixtür.
  - Bağımlılık: KAY-05. Boyut: S.
  - Dosya: `src/sistemler/kayit_gocu_soz.gd`.
  - Asset: asset gerekmedi.
- [ ] **KAY-18:** Söz listesi dizi değilse boş dizi olur.
  - Ne: alan sözlük gelirse boş liste yazılır, oyun açılır, o kişinin sözü yok sayılır.
  - Kabul: alan sözlük gelirse boş liste yazılır, oyun açılır, o kişinin sözü yok sayılır. Test: çökme yok.
  - Bağımlılık: KAY-09. Boyut: S.
  - Dosya: `src/soz/verilen_soz.gd`.
  - Asset: asset gerekmedi.
- [ ] **KAY-61:** Aynı kişi hafızada iki kez duruyorsa tek kayıt kalır.
  - Ne: mükerrer id birleştirilir. Ziyaret sayısı büyük olan kalır. Öteki düşer, günlüğe yazılır. Köylü ikiye bölünmez.
  - Kabul: mükerrer id birleştirilir. Ziyaret sayısı büyük olan kalır. Öteki düşer, günlüğe yazılır. Köylü ikiye bölünmez. Test: iki kayıt, tek köylü.
  - Bağımlılık: KAY-15. Boyut: S.
  - Dosya: `src/sistemler/kayit_gocu_soz.gd`.
  - Asset: asset gerekmedi.
- [ ] **KAY-62:** Kimliksiz beyan satırı düşer, defter durur.
  - Ne: beyan dizisinde `id` boşsa yalnız o satır atılır. Diğer beyanlar kalır.
  - Kabul: beyan dizisinde `id` boşsa yalnız o satır atılır. Diğer beyanlar kalır. Test: üç satırdan biri boş, yüklemede iki satır.
  - Bağımlılık: KAY-08. Boyut: S.
  - Dosya: `src/soz/beyan_defteri.gd`.
  - Asset: asset gerekmedi.
- [ ] **KAY-63:** Bayrak bool değilse yanlış sayılır.
  - Ne: `Flag_Sir_Tamamen_Cozuldu` dize veya sayı gelirse false yazılır, günlüğe düşer. Sır kendiliğinden açılmaz.
  - Kabul: `Flag_Sir_Tamamen_Cozuldu` dize veya sayı gelirse false yazılır, günlüğe düşer. Sır kendiliğinden açılmaz. Test: "evet" değeri itirafı açmaz.
  - Bağımlılık: KAY-17. Boyut: S.
  - Dosya: `src/sistemler/kayit_gocu_soz.gd`.
  - Asset: asset gerekmedi.
- [x] **KAY-64:** (Kalfa) Kesik dosya kayıt değildir.
  - Ne: JSON ayrışmayan dosya yüklenmez. Göç başlamaz. Sağlam yedek varsa o açılır. Yedek de yoksa oyuncu yeni oyuna zorlanmaz, hata görür.
  - Kabul: JSON ayrışmayan dosya yüklenmez. Göç başlamaz. Sağlam yedek varsa o açılır. Yedek de yoksa oyuncu yeni oyuna zorlanmaz, hata görür. Test: yarım kesilmiş dosya.
  - Bağımlılık: SYS-02, KAY-05. Boyut: S.
  - Dosya: `src/sistemler/guvenli_kayit.gd`.
  - Asset: asset gerekmedi.

### 31.4 Kayıt ikizi

- [ ] **KAY-19:** Aynı tohum, kaydet-yükle, kapıdaki kişi aynıdır.
  - Ne: gece sonu kayıt, yükle, ertesi sabah kuyruğun ilk kimliği aynı.
  - Kabul: gece sonu kayıt, yükle, ertesi sabah kuyruğun ilk kimliği aynı. Test: sabit tohum.
  - Bağımlılık: KAY-03, KAP-16. Boyut: M.
  - Dosya: `tests/unit/kayit/soz_ikiz_test.gd`.
  - Asset: asset gerekmedi.
- [ ] **KAY-20:** Kayıtlı zar yeniden atılmaz.
  - Ne: DYL-16 altınındaki zar değeri yüklemede aynı kalır. Yeni atış yoktur.
  - Kabul: DYL-16 altınındaki zar değeri yüklemede aynı kalır. Yeni atış yoktur. Test: zar 4 kayıtlı, yüklemede 4.
  - Bağımlılık: ZAR-01, DYL-16. Boyut: S.
  - Dosya: `tests/unit/kayit/soz_ikiz_test.gd`.
  - Asset: asset gerekmedi.
- [ ] **KAY-21:** Güven, korku ve itibar ikizde birebirdir.
  - Ne: KAY-07 ve KAY-11 alanları yüklemede aynı sayıdır.
  - Kabul: KAY-07 ve KAY-11 alanları yüklemede aynı sayıdır. Test: altı grup ve bir kişi.
  - Bağımlılık: KAY-07, KAY-11. Boyut: S.
  - Dosya: `tests/unit/kayit/soz_ikiz_test.gd`.
  - Asset: asset gerekmedi.
- [ ] **KAY-22:** Açık sözün hatırlatma günü kaymaz.
  - Ne: "yarın" sözü yüklemeden sonra hâlâ yarındır, bugün olmaz.
  - Kabul: "yarın" sözü yüklemeden sonra hâlâ yarındır, bugün olmaz. Test: gün sayacı eşit.
  - Bağımlılık: KAY-09. Boyut: S.
  - Dosya: `tests/unit/kayit/soz_ikiz_test.gd`.
  - Asset: asset gerekmedi.
- [x] **KAY-23:** Dedikodunun yaşı kaymaz. (Kalfa)
  - Ne: 2 gece önce doğan kayıt, yüklemede hâlâ 2 gece öncedir.
  - Kabul: 2 gece önce doğan kayıt, yüklemede hâlâ 2 gece öncedir. Test: yaş alanı eşit.
  - Bağımlılık: KAY-12. Boyut: S.
  - Dosya: `tests/unit/kayit/soz_ikiz_test.gd`.
  - Asset: asset gerekmedi.
- [ ] **KAY-24:** Altın oynanış, kayıtlı bağlamla aynı satırları verir.
  - Ne: DYL-16 dosyası yüklenmiş bir kaydın bağlamıyla bir kez daha oynar. Satır kimlikleri birebirdir.
  - Kabul: DYL-16 dosyası yüklenmiş bir kaydın bağlamıyla bir kez daha oynar. Satır kimlikleri birebirdir. Test: Yusuf için en az bir altın kayıt.
  - Bağımlılık: DYL-16, KAY-19. Boyut: M.
  - Dosya: `tests/unit/soz/altin_oynanis_test.gd`.
  - Asset: asset gerekmedi.

### 31.5 Kapı ve köy birlikte açılır

- [ ] **KAY-25:** Yarım kuyruk köylüyü silmez.
  - Ne: köy kaydı sağlam, kapı kuyruğu yarım ise kuyruk o sabah yeniden kurulur. Köylü sayısı değişmez.
  - Kabul: köy kaydı sağlam, kapı kuyruğu yarım ise kuyruk o sabah yeniden kurulur. Köylü sayısı değişmez. Test: yarım kuyruk fixtürü.
  - Bağımlılık: KAY-15. Boyut: M.
  - Dosya: `src/sistemler/kayit_gocu_soz.gd`.
  - Asset: asset gerekmedi.
- [ ] **KAY-26:** Açık sorgu aynı düğümden devam eder.
  - Ne: kayıt, düğüm kimliğini ve seçilmiş konuları yazar. Yüklemede selam yeniden okunmaz.
  - Kabul: kayıt, düğüm kimliğini ve seçilmiş konuları yazar. Yüklemede selam yeniden okunmaz. Test: düğüm id eşit.
  - Bağımlılık: DIY-02. Boyut: M.
  - Dosya: `src/soz/soz_motoru.gd` kayıt alanı.
  - Asset: asset gerekmedi.
- [ ] **KAY-27:** Eski diyalog sırası silinmez, yeni motorda okunmaz.
  - Ne: SYS-16 `diyalog_sira` dosyada kalır. Kişi yeni motora geçmişse bu sayı yok sayılır. Geçmemiş kişi eski yerinden devam eder.
  - Kabul: SYS-16 `diyalog_sira` dosyada kalır. Kişi yeni motora geçmişse bu sayı yok sayılır. Geçmemiş kişi eski yerinden devam eder. Test: geçiş tablosundaki kişi ile tabloda olmayan kişi.
  - Bağımlılık: SYS-16, DIY-16. Boyut: S.
  - Dosya: `data/soz/gecis.json` okunur.
  - Asset: asset gerekmedi.
- [ ] **KAY-28:** Eşin mesleği ve muhafızın geçmişi göçte durur.
  - Ne: ACL-02 ve ACL-06 alanları yeni sürümde aynıdır. Göç onları varsayılana çekmez.
  - Kabul: ACL-02 ve ACL-06 alanları yeni sürümde aynıdır. Göç onları varsayılana çekmez. Test: iki alan eşit.
  - Bağımlılık: ACL-02, ACL-06. Boyut: S.
  - Dosya: `src/sistemler/kayit_gocu_soz.gd`.
  - Asset: asset gerekmedi.
- [x] **KAY-29:** Yatak ve açıkta kalan sayısı durur. (Kalfa)
  - Ne: ACL-05 sayıları yüklemede aynıdır. Göç kimseyi içeri veya dışarı almaz.
  - Kabul: ACL-05 sayıları yüklemede aynıdır. Göç kimseyi içeri veya dışarı almaz. Test: açıkta kalan sayısı eşit.
  - Bağımlılık: ACL-05. Boyut: S.
  - Dosya: `src/sistemler/kayit_gocu_soz.gd`.
  - Asset: asset gerekmedi.
- [ ] **KAY-30:** Gece ortasında söz kaydı yazılmaz.
  - Ne: sorgu sürerken otomatik kayıt yoktur. Kayıt gece sonunda ve menüdedir. Hızlı kayıt Bölüm 35'e kalır.
  - Kabul: sorgu sürerken otomatik kayıt yoktur. Kayıt gece sonunda ve menüdedir. Hızlı kayıt Bölüm 35'e kalır. Test: sorgu ortasında kayıt dosyasının saati değişmez.
  - Bağımlılık: KAY-26. Boyut: S.
  - Dosya: `src/sistemler/guvenli_kayit.gd`.
  - Asset: asset gerekmedi.

### 31.6 Diyalog verisi doğrulayıcısı

- [ ] **KAY-31:** Söz doğrulayıcısı ikinci araç değildir.
  - Ne: YAZ-07 `tools/soz_dogrula.py` tek kapıdır. Bu bölüm ona kayıt uyumu kuralları ekler. Yeni betik açılmaz.
  - Kabul: YAZ-07 `tools/soz_dogrula.py` tek kapıdır. Bu bölüm ona kayıt uyumu kuralları ekler. Yeni betik açılmaz. Test: betik adı biricik.
  - Bağımlılık: YAZ-07. Boyut: S.
  - Dosya: `tools/soz_dogrula.py`.
  - Asset: asset gerekmedi.
- [ ] **KAY-32:** Kayıtta geçen her kişi katalogdadır.
  - Ne: doğrulayıcı, kayıt fixtüründeki kimlikleri katalogla karşılar. Eksik kimlik hata.
  - Kabul: doğrulayıcı, kayıt fixtüründeki kimlikleri katalogla karşılar. Eksik kimlik hata. Test: sahte id, çıkış kodu 1.
  - Bağımlılık: KAY-15, KAY-31. Boyut: S.
  - Dosya: `tools/soz_dogrula.py`.
  - Asset: asset gerekmedi.
- [ ] **KAY-33:** Eksik metin anahtarı kaydı açar, doğrulayıcıyı kırmaz.
  - Ne: SYS-09 `[KEY_NOT_FOUND]` oyunda durur. Doğrulayıcı bunu içerik hatası sayar, kayıt göçünü durdurmaz.
  - Kabul: SYS-09 `[KEY_NOT_FOUND]` oyunda durur. Doğrulayıcı bunu içerik hatası sayar, kayıt göçünü durdurmaz. Test: anahtarsız satır, göç başarılı, doğrulayıcı hatalı.
  - Bağımlılık: SYS-09, KAY-31. Boyut: S.
  - Dosya: `tools/soz_dogrula.py`.
  - Asset: asset gerekmedi.
- [ ] **KAY-34:** Kayıtlı kadroda çekirdek kotası sayılır.
  - Ne: YAZ-09 kotası, o kayıttaki varyantlara bakar. Yüzde 40 sınırı sapmışsa uyarı, yükleme durmaz.
  - Kabul: YAZ-09 kotası, o kayıttaki varyantlara bakar. Yüzde 40 sınırı sapmışsa uyarı, yükleme durmaz. Test: tek çekirdekli fixtür uyarı verir.
  - Bağımlılık: YAZ-09. Boyut: S.
  - Dosya: `tools/soz_kadro_denetimi.py`.
  - Asset: asset gerekmedi.
- [ ] **KAY-35:** Yasak kelime yüklemeyi kesmez.
  - Ne: YAZ-02 listesi içerik aracını keser. Oyuncunun kaydı açılır.
  - Kabul: YAZ-02 listesi içerik aracını keser. Oyuncunun kaydı açılır. Test: yasaklı kelime içeren kayıt açılır.
  - Bağımlılık: YAZ-02. Boyut: S.
  - Dosya: `tools/soz_dogrula.py`.
  - Asset: asset gerekmedi.
- [ ] **KAY-36:** Kopuk düğüm, kayıtlı ziyareti düşürmez.
  - Ne: kişinin son düğümü şemada yoksa ziyaret selama döner, kişi silinmez. Geliştirme günlüğüne yazılır.
  - Kabul: kişinin son düğümü şemada yoksa ziyaret selama döner, kişi silinmez. Geliştirme günlüğüne yazılır. Test: silinmiş düğüm id.
  - Bağımlılık: KAY-26, KAY-31. Boyut: S.
  - Dosya: `src/soz/soz_motoru.gd`.
  - Asset: asset gerekmedi.

### 31.7 Sanity genişlemesi

- [x] **KAY-37:** Sanity göç testini çağırır. (Kalfa)
  - Ne: `tools/sanity_check.py` tam paket, KAY-03 fixtürünü çalıştırır. Yeni paket yazılmaz, tek satır eklenir.
  - Kabul: `tools/sanity_check.py` tam paket, KAY-03 fixtürünü çalıştırır. Yeni paket yazılmaz, tek satır eklenir. Test: sanity listesinde göç adı vardır.
  - Bağımlılık: SYS-11, KAY-03. Boyut: S.
  - Dosya: `tools/sanity_check.py`.
  - Asset: asset gerekmedi.
- [ ] **KAY-38:** Sanity söz şemasını çağırır.
  - Ne: YAZ-07 sanity'ye girer. Şema hatası tam paketi kırar.
  - Kabul: YAZ-07 sanity'ye girer. Şema hatası tam paketi kırar. Test: kopuk düğüm, sanity hatalı.
  - Bağımlılık: YAZ-07, KAY-31. Boyut: S.
  - Dosya: `tools/sanity_check.py`.
  - Asset: asset gerekmedi.
- [ ] **KAY-39:** Sanity altın oynanışı çağırır.
  - Ne: DYL-16 kayıtları tam pakettedir. Bir oynanış saparsa paket hatalı.
  - Kabul: DYL-16 kayıtları tam pakettedir. Bir oynanış saparsa paket hatalı. Test: bilerek bozulan etki.
  - Bağımlılık: DYL-16. Boyut: S.
  - Dosya: `tools/sanity_check.py`.
  - Asset: asset gerekmedi.
- [x] **KAY-40:** (Claude) Tam paket sıfır hata kuralı durur.
  - Ne: yeni testler uyarıyla geçmez. Hata varsa paket hatalı.
  - Kabul: yeni testler uyarıyla geçmez. Hata varsa paket hatalı. Test: kasıtlı bir göç hatası paketi kırar.
  - Bağımlılık: SYS-06. Boyut: S.
  - Dosya: `tools/sanity_check.py`.
  - Asset: asset gerekmedi.
- [ ] **KAY-41:** Yirmi gece, göçmüş kayıtla da koşar.
  - Ne: SYS-10 dumanı, KAY-03'ten çıkmış bir kayıtla 20 gece çökmez. İkinci duman aracı yazılmaz.
  - Kabul: SYS-10 dumanı, KAY-03'ten çıkmış bir kayıtla 20 gece çökmez. İkinci duman aracı yazılmaz. Test: 20 gece, bellek sınırı SYS-10 ile aynı.
  - Bağımlılık: SYS-10, KAY-03. Boyut: M.
  - Dosya: `tests/oto/` mevcut duman.
  - Asset: asset gerekmedi.
- [ ] **KAY-42:** Doğrulama ilkinde durmaz.
  - Ne: üç hatalı kayıt alanı tek listede toplanır. İçerik hattındaki kural burada da geçerlidir.
  - Kabul: üç hatalı kayıt alanı tek listede toplanır. İçerik hattındaki kural burada da geçerlidir. Test: üç hata, üç satır.
  - Bağımlılık: KAY-31. Boyut: S.
  - Dosya: `tools/soz_dogrula.py`.
  - Asset: asset gerekmedi.

### 31.8 Regresyon

- [ ] **KAY-43:** Sürüm 3 kaydı yeni sürümde açılır.
  - Ne: chr-runtime notundaki oturum sürüm 3 fixtürü göçer. Köy, kadro ve rastgelelik durur.
  - Kabul: chr-runtime notundaki oturum sürüm 3 fixtürü göçer. Köy, kadro ve rastgelelik durur. Test: köylü sayısı eşit.
  - Bağımlılık: KAY-03, SYS-14. Boyut: M.
  - Dosya: `tests/unit/kvr/kayit_gocu_test.gd` genişler.
  - Asset: asset gerekmedi.
- [x] **KAY-44:** (testx) Dört barlı sürüm 1 kaydı hâlâ reddedilir.
  - Ne: SYS-14'ün reddi bozulmaz. Göç onu Söz kaydına çevirmez.
  - Kabul: SYS-14'ün reddi bozulmaz. Göç onu Söz kaydına çevirmez. Test: v1 dosya reddedilir.
  - Bağımlılık: SYS-14. Boyut: S.
  - Dosya: `tests/unit/kvr/kayit_gocu_test.gd`.
  - Asset: asset gerekmedi.
- [x] **KAY-45:** Kişisel kasa göçte yer değiştirmez. (Kalfa)
  - Ne: `muhafiz_akce` ve köy akçesi sayıları aynı kalır. Söz göçü transfer yapmaz.
  - Kabul: `muhafiz_akce` ve köy akçesi sayıları aynı kalır. Söz göçü transfer yapmaz. Test: iki kasa eşit.
  - Bağımlılık: EKO-01, KAY-03. Boyut: S.
  - Dosya: `tests/unit/kayit/soz_ikiz_test.gd`.
  - Asset: asset gerekmedi.
- [x] **KAY-46:** Mevsim günü kaymaz. (Kalfa)
  - Ne: MEV-01 günü ve mevsimi yüklemede aynıdır. Söz göçü takvimi ilerletmez.
  - Kabul: MEV-01 günü ve mevsimi yüklemede aynıdır. Söz göçü takvimi ilerletmez. Test: gün eşit.
  - Bağımlılık: MEV-01. Boyut: S.
  - Dosya: `tests/unit/kayit/soz_ikiz_test.gd`.
  - Asset: asset gerekmedi.
- [x] **KAY-47:** Nihai son kimliği beş değerden biri kalır. (Kalfa)
  - Ne: SYS-20 kimliği göçte değişmez. Altıncı son yazılmaz.
  - Kabul: SYS-20 kimliği göçte değişmez. Altıncı son yazılmaz. Test: kimlik kümesi aynı.
  - Bağımlılık: SYS-20. Boyut: S.
  - Dosya: `tests/unit/kayit/soz_ikiz_test.gd`.
  - Asset: asset gerekmedi.
- [ ] **KAY-48:** Adsız diyalog sırası eski kayıtta kalır.
  - Ne: SYS-16 sayısı göçten sonra dosyada durur.
  - Kabul: SYS-16 sayısı göçten sonra dosyada durur. Test: sayı eşit.
  - Bağımlılık: KAY-27. Boyut: S.
  - Dosya: `tests/unit/kayit/soz_ikiz_test.gd`.
  - Asset: asset gerekmedi.
- [x] **KAY-65:** Karantina kaydı göçte sıfırlanmaz. (Kalfa)
  - Ne: KRI-02 kalan gün ve kişi kimliği yüklemede aynıdır. Söz göçü hastayı iyileştirmez.
  - Kabul: KRI-02 kalan gün ve kişi kimliği yüklemede aynıdır. Söz göçü hastayı iyileştirmez. Test: kalan gün eşit.
  - Bağımlılık: KRI-02, KAY-03. Boyut: S.
  - Dosya: `tests/unit/kayit/soz_ikiz_test.gd`.
  - Asset: asset gerekmedi.
- [x] **KAY-66:** Bina ilerlemesi kaymaz. (Kalfa)
  - Ne: inşaatın kalan günü ve seviye göçte aynıdır. Yeni bina belirmez.
  - Kabul: inşaatın kalan günü ve seviye göçte aynıdır. Yeni bina belirmez. Test: bir yarımbina, kalan gün eşit.
  - Bağımlılık: KAY-03. Boyut: S.
  - Dosya: `tests/unit/kayit/soz_ikiz_test.gd`.
  - Asset: asset gerekmedi.
- [x] **KAY-67:** Adalet ve yozlaşma terazisi kaymaz. (Kalfa)
  - Ne: ODA-12 skoru göçte değişmez. Söz alanları teraziyi yeniden hesaplamaz.
  - Kabul: ODA-12 skoru göçte değişmez. Söz alanları teraziyi yeniden hesaplamaz. Test: skor eşit.
  - Bağımlılık: ODA-12, KAY-03. Boyut: S.
  - Dosya: `tests/unit/kayit/soz_ikiz_test.gd`.
  - Asset: asset gerekmedi.
- [x] **KAY-68:** Moğol sayacı ve mevsim sayacı birbirine karışmaz. (Kalfa)
  - Ne: HAR-02 kalan günü ile MEV-01 günü göçte yer değiştirmez.
  - Kabul: HAR-02 kalan günü ile MEV-01 günü göçte yer değiştirmez. Test: iki sayaç ayrı ayrı eşit.
  - Bağımlılık: HAR-02, KAY-46. Boyut: S.
  - Dosya: `tests/unit/kayit/soz_ikiz_test.gd`.
  - Asset: asset gerekmedi.

### 31.9 Performans bütçesi

- [ ] **KAY-49:** Göç bir saniyenin altındadır.
  - Ne: MVP boy kayıtta göç + doğrulama 1 saniyeden kısadır. Ölçü, içerik hattındaki açılış ölçüsüyle aynıdır. İkinci ölçü uydurulmaz.
  - Kabul: MVP boy kayıtta göç + doğrulama 1 saniyeden kısadır. Ölçü, içerik hattındaki açılış ölçüsüyle aynıdır. İkinci ölçü uydurulmaz. Test: süre satırı raporda.
  - Bağımlılık: KAY-03. Boyut: S.
  - Dosya: `tests/unit/kayit/soz_ikiz_test.gd`.
  - Asset: asset gerekmedi.
- [ ] **KAY-50:** Kişi başına kayıt üst sınırı vardır.
  - Ne: beyan listesi kişi başı en çok 40 satır. Aşan satır yazılmaz, günlük uyarır. Oyun açılır.
  - Kabul: beyan listesi kişi başı en çok 40 satır. Aşan satır yazılmaz, günlük uyarır. Oyun açılır. Test: 41. satır düşer.
  - Bağımlılık: KAY-08. Boyut: S.
  - Dosya: `src/soz/kisi_hafizasi.gd`.
  - Asset: asset gerekmedi.
- [ ] **KAY-51:** Yükleme bütün söz dosyalarını açmaz.
  - Ne: o gecenin kişileri okunur. Katalogdaki öteki söz dosyaları o yüklemede açılmaz.
  - Kabul: o gecenin kişileri okunur. Katalogdaki öteki söz dosyaları o yüklemede açılmaz. Test: açılan dosya sayısı kuyruk uzunluğunu geçmez.
  - Bağımlılık: DIY-02. Boyut: M.
  - Dosya: `src/soz/soz_motoru.gd`.
  - Asset: asset gerekmedi.
- [ ] **KAY-52:** Üç yıl aç-kapa bellek tavanını aşmaz.
  - Ne: 3 yıl simülasyonunda kayıt aç-kapa sonrası bellek artışı SYS-10 tavanının içindedir. Yeni tavan uydurulmaz.
  - Kabul: 3 yıl simülasyonunda kayıt aç-kapa sonrası bellek artışı SYS-10 tavanının içindedir. Yeni tavan uydurulmaz. Test: rapor satırı.
  - Bağımlılık: SYS-10, DNY-01. Boyut: M.
  - Dosya: `tests/oto/` duman genişler.
  - Asset: asset gerekmedi.
- [ ] **KAY-53:** Doğrulayıcı otuz CHR'yi tek koşuda bitirir.
  - Ne: 30 CHR + adlı karakterler tek süreçte doğrulanır. Süre raporda.
  - Kabul: 30 CHR + adlı karakterler tek süreçte doğrulanır. Süre raporda. Test: koşu hatasız biter.
  - Bağımlılık: KAY-31. Boyut: S.
  - Dosya: `tools/soz_dogrula.py`.
  - Asset: asset gerekmedi.
- [ ] **KAY-54:** On beş altın oynanışın toplam süresi tavandadır.
  - Ne: DYL-16 Yusuf paketi 15 oynanışı tek testte biter. Süre raporda, kapı yoktur.
  - Kabul: DYL-16 Yusuf paketi 15 oynanışı tek testte biter. Süre raporda, kapı yoktur. Test: 15/15.
  - Bağımlılık: DYL-16. Boyut: S.
  - Dosya: `tests/unit/soz/altin_oynanis_test.gd`.
  - Asset: asset gerekmedi.
- [ ] **KAY-69:** Gece sonu kayıt yazması bir saniyenin altındadır.
  - Ne: göç süresi (KAY-49) ile yazma süresi ayrı ölçülür. Yazma 1 saniyeyi geçerse rapor satırı hatalıdır. Oyun kilitlenmez.
  - Kabul: göç süresi (KAY-49) ile yazma süresi ayrı ölçülür. Yazma 1 saniyeyi geçerse rapor satırı hatalıdır. Oyun kilitlenmez. Test: MVP kayıtta yazma süresi.
  - Bağımlılık: KAY-49, SYS-02. Boyut: S.
  - Dosya: `tests/unit/kayit/soz_ikiz_test.gd`.
  - Asset: asset gerekmedi.
- [ ] **KAY-70:** Dedikodu listesi büyümez.
  - Ne: kayıtta en çok 80 dedikodu satırı durur. En eski satır düşer. Düşen satır yayılmamış bir olayı geri getirmez.
  - Kabul: kayıtta en çok 80 dedikodu satırı durur. En eski satır düşer. Düşen satır yayılmamış bir olayı geri getirmez. Test: 81. satır yazılmaz.
  - Bağımlılık: KAY-12, KAY-50. Boyut: S.
  - Dosya: `src/sistemler/dedikodu.gd`.
  - Asset: asset gerekmedi.
- [ ] **KAY-71:** Göç, oyun karesinde çalışmaz.
  - Ne: göç yükleme adımındadır. Kapı veya köy sahnesi açıkken göç fonksiyonu çağrılmaz.
  - Kabul: göç yükleme adımındadır. Kapı veya köy sahnesi açıkken göç fonksiyonu çağrılmaz. Test: sahnedeyken çağrı geliştirme hatasıdır.
  - Bağımlılık: KAY-03. Boyut: S.
  - Dosya: `src/sistemler/kayit_gocu_soz.gd`.
  - Asset: asset gerekmedi.
- [ ] **KAY-72:** Yüz tohumluk ikiz tek koşuda biter.
  - Ne: KAY-19 ölçüsü 100 tohumda da kapı kimliğini tutar. Süre raporda yazılır, yeni bir geçme kapısı uydurulmaz. Sapma varsa o tohumun numarası listededir.
  - Kabul: KAY-19 ölçüsü 100 tohumda da kapı kimliğini tutar. Süre raporda yazılır, yeni bir geçme kapısı uydurulmaz. Sapma varsa o tohumun numarası listededir. Test: 100 tohum, sapma listesi boş.
  - Bağımlılık: KAY-19. Boyut: M.
  - Dosya: `tests/unit/kayit/soz_ikiz_test.gd`.
  - Asset: asset gerekmedi.

### 31.10 Geri alma

- [x] **KAY-55:** Başarısız göç yedeği geri getirir. (Kalfa)
  - Ne: oyuncu kısa bir hata görür. Ana dosya göç öncesidir.
  - Kabul: oyuncu kısa bir hata görür. Ana dosya göç öncesidir. Test: hatalı göçten sonra sürüm numarası eskisidir.
  - Bağımlılık: KAY-05, SYS-02. Boyut: S.
  - Dosya: `src/sistemler/guvenli_kayit.gd`.
  - Asset: asset gerekmedi.
- [x] **KAY-56:** (testx) Yedek, ikinci bir başarısız göçte ezilmez.
  - Ne: `bak.tmp` sağlamsa yeni bozuk dosya onun üstüne yazılmaz. SYS-02 kuralı durur.
  - Kabul: `bak.tmp` sağlamsa yeni bozuk dosya onun üstüne yazılmaz. SYS-02 kuralı durur. Test: iki hatalı deneme, yedek baytı aynı.
  - Bağımlılık: SYS-02. Boyut: S.
  - Dosya: `src/sistemler/guvenli_kayit.gd`.
  - Asset: asset gerekmedi.
- [ ] **KAY-57:** Geri alınan sürüm yeni alanı yok sayar, silmez.
  - Ne: oyun eski sürümle açılırsa güven alanı okunmaz. Dosyadan da silinmez. Tekrar yeni sürüme geçince alan durur.
  - Kabul: oyun eski sürümle açılırsa güven alanı okunmaz. Dosyadan da silinmez. Tekrar yeni sürüme geçince alan durur. Test: alan baytı yerinde.
  - Bağımlılık: KAY-07, KAY-55. Boyut: M.
  - Dosya: `src/sistemler/kayit_gocu_soz.gd`.
  - Asset: asset gerekmedi.
- [ ] **KAY-58:** Söz alanları tek bayrakla kapanır.
  - Ne: `data/ayarlar` içinde bir bayrak kapalıysa göç Söz alanlarını yazmaz, eski yol durur. Bayrak açıksa KAY-07…12 yazılır.
  - Kabul: `data/ayarlar` içinde bir bayrak kapalıysa göç Söz alanlarını yazmaz, eski yol durur. Bayrak açıksa KAY-07…12 yazılır. Test: kapalı bayrakta dosyada güven alanı yoktur.
  - Bağımlılık: KAY-07. Boyut: S.
  - Dosya: `data/ayarlar/oyun.tres`.
  - Asset: asset gerekmedi.
- [ ] **KAY-59:** Göç tek komutla koşar.
  - Ne: geliştirici kaydı el ile düzenlemez. Bir test komutu fixtürü göçtürür.
  - Kabul: geliştirici kaydı el ile düzenlemez. Bir test komutu fixtürü göçtürür. Test: komut çıkış kodu 0.
  - Bağımlılık: KAY-03. Boyut: S.
  - Dosya: `tests/unit/kayit/soz_ikiz_test.gd`.
  - Asset: asset gerekmedi.
- [/] **KAY-60:** Sürüm atlaması bu dosyada yazılı onay ister. (Kalfa)
  - Ne: ara adım silinmeden sürüm atlanmaz. Atlama kararı bu bölümün sonuna bir satır olarak yazılır. Satır yoksa KAY-03 atlamayı reddeder.
  - Kabul: ara adım silinmeden sürüm atlanmaz. Atlama kararı bu bölümün sonuna bir satır olarak yazılır. Satır yoksa KAY-03 atlamayı reddeder. Test: onaysız atlama hatası.
  - Bağımlılık: KAY-03. Boyut: S.
  - Dosya: `ROADMAP_2_BOLUM_31.md` karar satırı, kod `kayit_gocu_soz.gd`.
  - Asset: asset gerekmedi.

Onay satırı henüz yok. Sürüm atlanmaz.


---

## BÖLÜM 32: Denge yeniden ayarı ve ekonomi ölçümü


Faz 4'ün sonu. Ölçülen sistemler duruyor: çift kasa (EKO-01), tüketim (EKO-09), fiyat (TUC-09), açılış (BUG-21, BUG-22), yaşam barı (YSM), geçici iş (ISG), zar (ZAR), yozlaşma (ODA-04, ODA-12), krizler (KRI), beş son (SYS-20). Bu bölüm onları yeniden kurmaz. Sayıları tek tabloda toplar, ölçer, sapınca tabloyu değiştirir. Kodda yeni sabit yoktur.

Tester planındaki TST-04 ve TST-05 burada tanımlanmaz ve kopyalanmaz. Ölçüm onların persona kimliğini okur.

Odun darlığı (BUG-0018) ayrı bir odun sistemi değildir. BUG-22 tablosunun odun satırıdır.

Alt başlıklar ondur. Her birinde sekiz madde vardır. Dokuzuncu ve onuncu, var olan bir formülü ikinci kez yazacağı için konmadı.

### 32.1 Tek ayar tablosu

- [x] **DEN-01:** (testx) Denge sayıları tek dosyadadır.
  - Ne: zar eşiği, açılış stoku, fiyat çarpanı, kriz aralığı ve zorluk çarpanı `data/ayarlar/denge.json` içindedir. Bu sayılar `.gd` dosyasında sabit değildir.
  - Kabul: zar eşiği, açılış stoku, fiyat çarpanı, kriz aralığı ve zorluk çarpanı `data/ayarlar/denge.json` içindedir. Bu sayılar `.gd` dosyasında sabit değildir. Test: dosyada olmayan bir denge sayısı tarama ile 0 bulunur. Ek şart: Olay olasılığı dünya işaretini silmez.
  - Bağımlılık: yok. Boyut: M.
  - Dosya: `data/ayarlar/denge.json`. Okuyanlar mevcut sistemlere tek satır.
  - Asset: asset gerekmedi.
- [x] **DEN-02:** (Antigravity) Tablo sürümü kayıtla birlikte durur. _(sanity bekliyor)_
  - Ne: denge dosyasının sürümü KAY-04 içeriğinden ayrıdır. Eski kayıt yeni tabloyla açılır. Kayıt, tabloyu içine gömmez.
  - Kabul: denge dosyasının sürümü KAY-04 içeriğinden ayrıdır. Eski kayıt yeni tabloyla açılır. Kayıt, tabloyu içine gömmez. Test: tablo sürümü artınca köylü sayısı değişmez.
  - Bağımlılık: KAY-04, DEN-01. Boyut: S.
  - Dosya: `data/ayarlar/denge.json`.
  - Asset: asset gerekmedi.
- [x] **DEN-03:** (Antigravity) Aralık dışındaki tablo değeri oyunu açmaz. _(sanity bekliyor; oyun açılış tarafı DEN-03b)_
  - Ne: doğrulama, her anahtarın alt ve üst sınırına bakar. Sınır dışı değer kırpılmaz. Katalog hatalı olur.
  - Kabul: doğrulama, her anahtarın alt ve üst sınırına bakar. Sınır dışı değer kırpılmaz. Katalog hatalı olur. Test: negatif fiyat çarpanı, açılış hatası.
  - Bağımlılık: DEN-01. Boyut: S.
  - Dosya: `tools/denge_dogrula.py`. Sanity'ye tek satır.
  - Asset: asset gerekmedi.
- [ ] **DEN-03b:** Aralık dışı tablo değeri oyun açılışında net hata verir (Kalfa ACL-04'ü bitirince).
  - Ne: DEN-03'ün sanity tarafı bitti (	ools/denge_dogrula.py, data/ayarlar/denge_sinirlari.json). Bu madde aynı doğrulamayı oyun açılışına bağlar: sınır dışı değerde oyun açılmaz ve oyuncuya çeviri anahtarıyla net hata mesajı gösterilir. Değer kırpılmaz.
  - Kabul: aralık dışı değerle açılış 1 hata mesajı verir, mesaj düz Türkçe gömülü değil çeviri anahtarıdır. Test: açılış kontrolü bilerek bozuk tabloyla kırmızı olur. Ek şart: yeni .gd doğrulayıcı yeni dosyadadır; açılışa tek satır çağrı eklenir.
  - Bağımlılık: DEN-03. Ön koşul: Kalfa ACL-04'ü bitirmiş olmalı; metinler.csv, project.godot ve açılış dosyaları ACL-04 yarım işinde olduğundan o zamana kadar dokunulmaz. Boyut: S.
  - Dosya: yeni src/sistemler/denge_sinir_denetimi.gd; açılışa tek satır; data/metin/metinler.csv içine bir anahtar.
  - Asset: asset gerekmedi.
- [ ] **DEN-03c:** Denge tablosunu okuyan oyun kodu (zorluk çarpanı, ilk hafta erzak payı).
  - Ne: DEN-04 zorluk ve DEN-13 ilk_hafta_erzak şu an yalnız veri ve doğrulamadır; oyun kodu bunları okumaz. Bu madde tek bir okuyucu (yeni src/sistemler/denge_tablosu.gd) yazar ve mevcut sistemlere tek satırla bağlar. Tablo yoksa ya da bozuksa oyun açılmaz (DEN-08); kodda yedek sayı olmaz.
  - Kabul: Zorluk olagan iken hiçbir sayı değişmez; kolay/siki çarpanı tablodan gelir. Açılış erzağı ilk_hafta_erzak formülüyle hesaplanır ve 2 kişilik açılışta 30'dur. Test: 	ests/unit/sistemler/denge_tablosu_test.gd. Ek şart: koy_ayarlari.gd ve kirli listedeki dosyalara dokunmadan önce sahibine sorulur.
  - Bağımlılık: DEN-04, DEN-13, DEN-03b. Boyut: M.
  - Dosya: yeni src/sistemler/denge_tablosu.gd; mevcut sistemlere tek satır çağrı.
  - Asset: asset gerekmedi.
- [x] **DEN-04:** (Antigravity) Zorluk, tabloyu çarpar, ikinci tablo açmaz. _(sanity bekliyor)_
  - Ne: kolay, olağan ve sıkı yalnız çarpandır. Anahtarlar üç kez yazılmaz.
  - Kabul: kolay, olağan ve sıkı yalnız çarpandır. Anahtarlar üç kez yazılmaz. Test: olağanda çarpan 1, diğer iki çarpan dosyada.
  - Bağımlılık: DEN-01. Boyut: S.
  - Dosya: `data/ayarlar/denge.json` içindeki `zorluk`.
  - Asset: asset gerekmedi.
- [x] **DEN-05:** (Antigravity) Ölçüm raporu gece hesabını ikinci kez çalıştırmaz. _(sanity bekliyor)_
  - Ne: rapor, `gece_sonu()` dönüşünü okur. Yeni bir tüketim fonksiyonu yok.
  - Kabul: rapor, `gece_sonu()` dönüşünü okur. Yeni bir tüketim fonksiyonu yok. Test: bir gecede tüketim fonksiyonu bir kez çağrılır. Ek şart: Nöbet maaşı ölçümü denge raporunun bir satırıdır; maaş formülü bu satırda değişmez. Ek şart: Çınar meclisinin oy farkı denge formülünü değiştirmez; ölçüm yeni bir tüketim fonksiyonu açmaz. Ek şart: Zindan ekmek payı denge formülünü değiştirmez; ölçüm mevcut gece raporunu okur. Ek şart: Ölçüm raporunda her sorgu eyleminin kullanım sayısı bir satırdır; gece formülü değişmez. Ek şart: Aç kişi oranı gece ölçümüne bir satır eklenir; denge hesabı ikinci kez çalışmaz.
  - Bağımlılık: EKO-15, DEN-01. Boyut: S.
  - Dosya: `src/sistemler/denge_olcumu.gd`.
  - Asset: asset gerekmedi.
- [x] **DEN-06:** (Antigravity) Rapor oyuncuya açılmaz. _(sanity bekliyor)_
  - Ne: ölçüm geliştirme günlüğündedir. Kapı ve köy HUD'unda denge sayısı görünmez.
  - Kabul: ölçüm geliştirme günlüğündedir. Kapı ve köy HUD'unda denge sayısı görünmez. Test: oyuncu arayüzünde "denge" anahtarı 0.
  - Bağımlılık: DEN-05. Boyut: S.
  - Dosya: `src/sistemler/denge_olcumu.gd`.
  - Asset: asset gerekmedi.
- [x] **DEN-07:** (Antigravity) Tablo anahtarı Türkçe harf taşımaz. _(sanity bekliyor)_
  - Ne: anahtar ASCII snake_case'dir. İçerik hattındaki id kuralı geçerlidir.
  - Kabul: anahtar ASCII snake_case'dir. İçerik hattındaki id kuralı geçerlidir. Test: `odun_carpani` geçer, `odun çarpanı` reddedilir.
  - Bağımlılık: DEN-03. Boyut: S.
  - Dosya: `tools/denge_dogrula.py`.
  - Asset: asset gerekmedi.
- [x] **DEN-08:** (Antigravity) Eksik anahtar, kod içi yedek sayı kullanmaz. _(sanity bekliyor)_
  - Ne: anahtar yoksa oyun açılmaz. Sessiz varsayılan yoktur.
  - Kabul: anahtar yoksa oyun açılmaz. Sessiz varsayılan yoktur. Test: silinmiş `baslangic_odun`, açılış hatası.
  - Bağımlılık: DEN-03. Boyut: S.
  - Dosya: `tools/denge_dogrula.py`.
  - Asset: asset gerekmedi.

### 32.2 Açılış stoku ve odun

- [x] **DEN-09:** (Antigravity) Açılış stoku BUG-22 tablosudur. _(sanity bekliyor)_
  - Ne: ikinci bir başlangıç dosyası yok. `denge.json` BUG-22'nin okuduğu sayıları gösterir.
  - Kabul: ikinci bir başlangıç dosyası yok. `denge.json` BUG-22'nin okuduğu sayıları gösterir. Test: iki dosyada farklı odun sayısı varsa doğrulayıcı hata verir.
  - Bağımlılık: BUG-22, DEN-01. Boyut: S.
  - Dosya: `data/ayarlar/denge.json`, `data/ayarlar/koy.tres`.
  - Asset: asset gerekmedi.
- [ ] **DEN-10:** Odun darlığı ölçülür.
  - Ne: BUG-0018, ilk 10 gecede odunun sıfıra düşüp ateşin kesildiği koşudur. Beş açılış sırasının (BUG-22) hiçbiri bu koşula girmez.
  - Kabul: BUG-0018, ilk 10 gecede odunun sıfıra düşüp ateşin kesildiği koşudur. Beş açılış sırasının (BUG-22) hiçbiri bu koşula girmez. Test: beş sıra, 10 gece, odun 0 gün sayısı 0.
  - Bağımlılık: BUG-22, EKO-02, MEV-11. Boyut: M.
  - Dosya: `tests/oto/acilis_denge_kontrol.tscn` genişler.
  - Asset: asset gerekmedi.
- [x] **DEN-11:** (Antigravity) Taş yatağı ikinci kez yazılmaz. _(sanity bekliyor)_
  - Ne: 20 taş ve kurtarıcı yatak BUG-21'dir. Bu bölüm o sayıyı ölçer, yeni yatak eklemez.
  - Kabul: 20 taş ve kurtarıcı yatak BUG-21'dir. Bu bölüm o sayıyı ölçer, yeni yatak eklemez. Test: yatak sayısı oyun başında 1, kurtarıcı tavanı 3.
  - Bağımlılık: BUG-21. Boyut: S.
  - Dosya: `tests/oto/acilis_denge_kontrol.tscn`.
  - Asset: asset gerekmedi.
- [ ] **DEN-12:** Kış açılışı yaz açılışından ayrı ölçülür.
  - Ne: MEV-01 kışında ilk 10 gecenin odun dibi yazdaki dibin altındadır. Altında kalması tabloda yazılı bir farktır.
  - Kabul: MEV-01 kışında ilk 10 gecenin odun dibi yazdaki dibin altındadır. Altında kalması tabloda yazılı bir farktır. Test: iki mevsim, fark tabloya uyar.
  - Bağımlılık: MEV-11, DEN-10. Boyut: M.
  - Dosya: `data/ayarlar/denge.json` `kis_odun_farki`.
  - Asset: asset gerekmedi.
- [x] **DEN-13:** (Antigravity) İlk hafta erzak, nüfus çarpı gece artı paydır. _(sanity bekliyor)_
  - Ne: açılış erzağı, evdeki kişi sayısı çarpı 7 artı tablodaki paydır. Pay kodda sabit değildir.
  - Kabul: açılış erzağı, evdeki kişi sayısı çarpı 7 artı tablodaki paydır. Pay kodda sabit değildir. Test: 2 kişilik açılışta erzak formüle eşittir.
  - Bağımlılık: ACL-01, EKO-09. Boyut: S.
  - Dosya: `data/ayarlar/denge.json`.
  - Asset: asset gerekmedi.
- [x] **DEN-14:** (Antigravity) Açılışta akçe iki kasada da tablodadır. _(sanity bekliyor)_
  - Ne: köy akçesi ve muhafız akçesi ayrı satırdır. Göç onları birbirine katmaz (KAY-45).
  - Kabul: köy akçesi ve muhafız akçesi ayrı satırdır. Göç onları birbirine katmaz (KAY-45). Test: iki satır, toplam kodda yazılmaz.
  - Bağımlılık: EKO-01, DEN-01. Boyut: S.
  - Dosya: `data/ayarlar/denge.json`.
  - Asset: asset gerekmedi.
- [ ] **DEN-15:** Hızarhane, iki çadır ve tarla sırası kilitlenmez.
  - Ne: BUG-22'nin bu sırası 10 gün içinde taş ocağına gider. Odun o sırada 0 olmaz (DEN-10).
  - Kabul: BUG-22'nin bu sırası 10 gün içinde taş ocağına gider. Odun o sırada 0 olmaz (DEN-10). Test: tek senaryo, iki koşul.
  - Bağımlılık: DEN-10, BUG-21. Boyut: S.
  - Dosya: `tests/oto/acilis_denge_kontrol.tscn`.
  - Asset: asset gerekmedi.
- [ ] **DEN-16:** Açılış ölçümü 20 geceyi geçer.
  - Ne: beş sıra 20 gece çökmeden biter. Bu, BUG-22 kabulünün ölçüm kopyasıdır. Yeni otomatik oyuncu yazılmaz.
  - Kabul: beş sıra 20 gece çökmeden biter. Bu, BUG-22 kabulünün ölçüm kopyasıdır. Yeni otomatik oyuncu yazılmaz. Test: mevcut senaryo yeşil.
  - Bağımlılık: BUG-22. Boyut: S.
  - Dosya: `tests/oto/acilis_denge_kontrol.tscn`.
  - Asset: asset gerekmedi.

### 32.3 Zarın ekonomiye yazılması

- [x] **DEN-17:** (Antigravity) Zar formülü ZAR-01'de kalır. _(sanity bekliyor)_
  - Ne: denge dosyası eşikleri okur, formülü yeniden yazmaz.
  - Kabul: denge dosyası eşikleri okur, formülü yeniden yazmaz. Test: dosyadaki eşik ile `sorgu_kurallari.tres` aynı sayıdır. Farklıysa doğrulayıcı hata verir.
  - Bağımlılık: ZAR-01, DEN-03. Boyut: S.
  - Dosya: `data/ayarlar/denge.json`, `data/chr_runtime/sorgu_kurallari.tres`.
  - Asset: asset gerekmedi.
- [ ] **DEN-18:** Başarılı ikna, rüşveti azaltan bir çarpan değildir.
  - Ne: zar sonucu kasaya yazılmaz. Kasa, karar matrisinden yazar (KOP-10).
  - Kabul: zar sonucu kasaya yazılmaz. Kasa, karar matrisinden yazar (KOP-10). Test: 100 başarılı zar, kasa yalnız matris kadar değişir.
  - Bağımlılık: KOP-10, ZAR-01. Boyut: S.
  - Dosya: `src/sistemler/denge_olcumu.gd`.
  - Asset: asset gerekmedi.
- [x] **DEN-19:** (Antigravity) Kaçan kişinin ekonomik bedeli ölçülür. _(sanity bekliyor)_
  - Ne: ZAR-03 kaçışı, o kişinin kabul matrisindeki erzak satırının tersi değildir. Bedel, tablodaki tek satırdır: kaçan kişi başına dedikodu, kasa değil.
  - Kabul: ZAR-03 kaçışı, o kişinin kabul matrisindeki erzak satırının tersi değildir. Bedel, tablodaki tek satırdır: kaçan kişi başına dedikodu, kasa değil. Test: kaçışta `muhafiz_akce` değişmez.
  - Bağımlılık: ZAR-03, DIY-13. Boyut: S.
  - Dosya: `data/ayarlar/denge.json`.
  - Asset: asset gerekmedi.
- [ ] **DEN-20:** d6 ve d12 aynı ekonomik kapıyı kullanır.
  - Ne: yüzün türü zorluğu değiştirir, kasaya ayrı çarpan yazmaz.
  - Kabul: yüzün türü zorluğu değiştirir, kasaya ayrı çarpan yazmaz. Test: aynı karar, iki zar türü, kasa farkı 0.
  - Bağımlılık: ZAR-01, DEN-18. Boyut: S.
  - Dosya: `tests/unit/denge/zar_kasa_test.gd`.
  - Asset: asset gerekmedi.
- [x] **DEN-21:** (Antigravity) Değiştirici listesi ekonomi üretmez. _(sanity bekliyor)_
  - Ne: ZAR-04 değiştiricisi yalnız gereken sayıyı değiştirir. Akçe satırı yoktur.
  - Kabul: ZAR-04 değiştiricisi yalnız gereken sayıyı değiştirir. Akçe satırı yoktur. Test: asker yanındayken kasa aynı kararda aynıdır.
  - Bağımlılık: ZAR-04. Boyut: S.
  - Dosya: `tests/unit/denge/zar_kasa_test.gd`.
  - Asset: asset gerekmedi.
- [x] **DEN-22:** (Antigravity) Yüz başarısız zarın gece raporu tek satırdır. _(sanity bekliyor)_
  - Ne: rapor, o gecenin başarısız zar sayısını yazar. Her zar için ayrı ekonomik satır açmaz.
  - Kabul: rapor, o gecenin başarısız zar sayısını yazar. Her zar için ayrı ekonomik satır açmaz. Test: 3 başarısızlık, raporda bir sayı.
  - Bağımlılık: EKO-15, ZAR-01. Boyut: S.
  - Dosya: `src/sistemler/denge_olcumu.gd`.
  - Asset: asset gerekmedi.
- [x] **DEN-23:** (Antigravity) Tansiyon eki üç kademedir. _(sanity bekliyor)_
  - Ne: sakin, gergin, panik ekleri ZAR-01 kararındaki 0, 1, 2'dir. Denge dosyası bu üç sayıyı tekrar tanımlamaz, okur.
  - Kabul: sakin, gergin, panik ekleri ZAR-01 kararındaki 0, 1, 2'dir. Denge dosyası bu üç sayıyı tekrar tanımlamaz, okur. Test: dosyada ikinci bir ek anahtarı yoktur.
  - Bağımlılık: ZAR-01, DEN-17. Boyut: S.
  - Dosya: `tools/denge_dogrula.py`.
  - Asset: asset gerekmedi.
- [x] **DEN-24:** (Antigravity) Ölçüm, 10.000 atışın dağılım kapısını yeniden koymaz. _(sanity bekliyor)_
  - Ne: ZAR-01'in ±%2 testi durur. Bu bölüm o testi çağırır, eşiği değiştirmez.
  - Kabul: ZAR-01'in ±%2 testi durur. Bu bölüm o testi çağırır, eşiği değiştirmez. Test: mevcut zar testi yeşil.
  - Bağımlılık: ZAR-01. Boyut: S.
  - Dosya: mevcut zar testi.
  - Asset: asset gerekmedi.

### 32.4 Yaşam barı ve üretim

- [ ] **DEN-25:** Açlık kademesi YSM-02'dir.
  - Ne: yüzde 20, yüzde 50 ve yatar eşikleri o maddeden okunur. Denge dosyası aynı sayıyı ikinci kez yazarsa doğrulayıcı hata verir.
  - Kabul: yüzde 20, yüzde 50 ve yatar eşikleri o maddeden okunur. Denge dosyası aynı sayıyı ikinci kez yazarsa doğrulayıcı hata verir. Test: tek eşik kaynağı.
  - Bağımlılık: YSM-02, DEN-03. Boyut: S.
  - Dosya: `tools/denge_dogrula.py`.
  - Asset: asset gerekmedi.
- [ ] **DEN-26:** İki günü aşan açlık üretimi sıfırlar.
  - Ne: YSM-02'nin yatar hali, o gecenin üretim satırında 0 yazar. İkinci bir ceza çarpanı eklenmez.
  - Kabul: YSM-02'nin yatar hali, o gecenin üretim satırında 0 yazar. İkinci bir ceza çarpanı eklenmez. Test: 3. aç gün, üretim 0.
  - Bağımlılık: YSM-02. Boyut: S.
  - Dosya: `tests/unit/denge/aclik_uretim_test.gd`.
  - Asset: asset gerekmedi.
- [ ] **DEN-27:** Erzak eşiği KRI-12 ile aynıdır.
  - Ne: erzak 3 gecenin altına inince sağlık eşiği KRI-12'dedir. Denge bunu ölçer, eşiği kopyalamaz.
  - Kabul: erzak 3 gecenin altına inince sağlık eşiği KRI-12'dedir. Denge bunu ölçer, eşiği kopyalamaz. Test: eşik sayısı bir.
  - Bağımlılık: KRI-12, YSM-01. Boyut: S.
  - Dosya: `tools/denge_dogrula.py`.
  - Asset: asset gerekmedi.
- [ ] **DEN-28:** Yataksız uyku YSM-03'tür.
  - Ne: açıkta kalanın yorgunluğu yarım düşer. Bu bölüm yeni bir uyku formülü yazmaz.
  - Kabul: açıkta kalanın yorgunluğu yarım düşer. Bu bölüm yeni bir uyku formülü yazmaz. Test: yataklı ve yataksız fark, YSM-03 kabulüne uyar.
  - Bağımlılık: YSM-03, ACL-05. Boyut: S.
  - Dosya: `tests/unit/denge/aclik_uretim_test.gd`.
  - Asset: asset gerekmedi.
- [ ] **DEN-29:** Yirmi günlük aç köy ölçülür.
  - Ne: erzak 0 ile başlayan 20 gecede ölüm sayısı tablodaki alt ve üst sınırın içindedir. Sınır dosyadadır.
  - Kabul: erzak 0 ile başlayan 20 gecede ölüm sayısı tablodaki alt ve üst sınırın içindedir. Sınır dosyadadır. Test: 20 gece, sayı aralıkta.
  - Bağımlılık: EKO-09, YSM-02, DEN-01. Boyut: M.
  - Dosya: `data/ayarlar/denge.json` `aclik_olum_aralik`.
  - Asset: asset gerekmedi.
- [ ] **DEN-30:** Tok köyde üretim taban çizgidir.
  - Ne: erzak bolken 20 gecenin üretimi, aç köy ölçüsünün üstündedir. İki ölçüm aynı tohumdadır.
  - Kabul: erzak bolken 20 gecenin üretimi, aç köy ölçüsünün üstündedir. İki ölçüm aynı tohumdadır. Test: tok üretim > aç üretim.
  - Bağımlılık: DEN-29. Boyut: S.
  - Dosya: `tests/unit/denge/aclik_uretim_test.gd`.
  - Asset: asset gerekmedi.
- [ ] **DEN-31:** Bar, ikinci gece hesabı açmaz.
  - Ne: YSM-01, KRI-12 hesabını okur. Denge raporu da onu okur.
  - Kabul: YSM-01, KRI-12 hesabını okur. Denge raporu da onu okur. Test: sağlık fonksiyonu gecede bir kez.
  - Bağımlılık: YSM-01, DEN-05. Boyut: S.
  - Dosya: `src/sistemler/denge_olcumu.gd`.
  - Asset: asset gerekmedi.
- [ ] **DEN-32:** Ölüm, cenaze sistemine gider.
  - Ne: açlıktan ölen kişi KRI-05 kuyruğuna yazılır. Bu bölüm ayrı mezar açmaz.
  - Kabul: açlıktan ölen kişi KRI-05 kuyruğuna yazılır. Bu bölüm ayrı mezar açmaz. Test: ölüm sayısı ile cenaze kuyruğu eşit.
  - Bağımlılık: KRI-05, DEN-29. Boyut: S.
  - Dosya: `tests/unit/denge/aclik_uretim_test.gd`.
  - Asset: asset gerekmedi.

### 32.5 Meslek ve boşta kalan

- [ ] **DEN-33:** Meslek uyarısı ISG-01'dir.
  - Ne: atölyesiz kumaşçı uyarısı o maddede kalır. Denge, uyarının göründüğü gece sayısını ölçer. Yeni uyarı metni yazmaz.
  - Kabul: atölyesiz kumaşçı uyarısı o maddede kalır. Denge, uyarının göründüğü gece sayısını ölçer. Yeni uyarı metni yazmaz. Test: atölyesiz 10 gece, uyarı en az 1.
  - Bağımlılık: ISG-01. Boyut: S.
  - Dosya: `src/sistemler/denge_olcumu.gd`.
  - Asset: asset gerekmedi.
- [ ] **DEN-34:** Geçici işin verimi tablodadır.
  - Ne: ISG-02 verimleri `gecici_isler.json` içindedir. `denge.json` aynı sayıyı kopyalamaz, yolu yazar.
  - Kabul: ISG-02 verimleri `gecici_isler.json` içindedir. `denge.json` aynı sayıyı kopyalamaz, yolu yazar. Test: kopya sayı varsa hata.
  - Bağımlılık: ISG-02, DEN-03. Boyut: S.
  - Dosya: `tools/denge_dogrula.py`.
  - Asset: asset gerekmedi.
- [ ] **DEN-35:** Boşta üç gün, terk isteği ISG-03'tür.
  - Ne: eşik o maddede kalır. Ölçüm, 20 gecede terk isteği sayısının aralıkta olduğunu söyler. Aralık dosyadadır.
  - Kabul: eşik o maddede kalır. Ölçüm, 20 gecede terk isteği sayısının aralıkta olduğunu söyler. Aralık dosyadadır. Test: 3 kişilik boş köy, sayı aralıkta.
  - Bağımlılık: ISG-03, DEN-01. Boyut: M.
  - Dosya: `data/ayarlar/denge.json` `bosta_terk_aralik`.
  - Asset: asset gerekmedi.
- [ ] **DEN-36:** Nitelikli iş, geçici işten çok üretir.
  - Ne: atölyeli kumaşçının gecelik çıktısı, aynı kişinin geçici iş çıktısının üstündedir. Fark tabloda bir orandır.
  - Kabul: atölyeli kumaşçının gecelik çıktısı, aynı kişinin geçici iş çıktısının üstündedir. Fark tabloda bir orandır. Test: oran tutulur.
  - Bağımlılık: ISG-01, ISG-02, UZM-03. Boyut: M.
  - Dosya: `data/ayarlar/denge.json`.
  - Asset: asset gerekmedi.
- [ ] **DEN-37:** Eşin mesleği demirhaneye yazılmaz.
  - Ne: ACL-02 listesi dışındaki meslek hâlâ reddedilir. Denge bu listeyi genişletmez.
  - Kabul: ACL-02 listesi dışındaki meslek hâlâ reddedilir. Denge bu listeyi genişletmez. Test: demirci reddi durur.
  - Bağımlılık: ACL-02. Boyut: S.
  - Dosya: mevcut ACL-02 testi.
  - Asset: asset gerekmedi.
- [ ] **DEN-38:** Meslek değişiminin bir günlük kaybı durur.
  - Ne: ACL-02'deki 1 gün verimsizlik ölçülür, uzatılmaz.
  - Kabul: ACL-02'deki 1 gün verimsizlik ölçülür, uzatılmaz. Test: değişim günü üretim, ertesi günden düşüktür.
  - Bağımlılık: ACL-02. Boyut: S.
  - Dosya: `tests/unit/denge/meslek_verim_test.gd`.
  - Asset: asset gerekmedi.
- [ ] **DEN-39:** Çırak beş günde yarım usta olur.
  - Ne: UZM-04 süresi değişmez. Ölçüm, 5. günde verimin ara basamakta olduğunu doğrular.
  - Kabul: UZM-04 süresi değişmez. Ölçüm, 5. günde verimin ara basamakta olduğunu doğrular. Test: 4. gün ara basamak değil, 5. gün odur.
  - Bağımlılık: UZM-04. Boyut: S.
  - Dosya: `tests/unit/denge/meslek_verim_test.gd`.
  - Asset: asset gerekmedi.
- [ ] **DEN-40:** Boştaki vasıfsız, salgında ot toplar.
  - Ne: KRI-15 kuralı durur. Denge, salgınsız günde ot toplanmadığını ölçer.
  - Kabul: KRI-15 kuralı durur. Denge, salgınsız günde ot toplanmadığını ölçer. Test: salgın yok, afyon 0.
  - Bağımlılık: KRI-15. Boyut: S.
  - Dosya: `tests/unit/denge/meslek_verim_test.gd`.
  - Asset: asset gerekmedi.

### 32.6 Rüşvet ve yozlaşma

- [ ] **DEN-41:** Rüşvet kişisel kasaya gider.
  - Ne: EKO-01 ayrımı durur. Ölçüm, rüşvetin köy akçesine yazılmadığını 20 kararda doğrular.
  - Kabul: EKO-01 ayrımı durur. Ölçüm, rüşvetin köy akçesine yazılmadığını 20 kararda doğrular. Test: köy akçesi sabit, kişisel kasa artar.
  - Bağımlılık: EKO-01, KOP-10. Boyut: S.
  - Dosya: `tests/unit/denge/rusvet_test.gd`.
  - Asset: asset gerekmedi.
- [ ] **DEN-42:** Rüşvetin akçe tavanı matriste kalır.
  - Ne: KVR kıskacı −4…+4 stat içindir. Akçe tavanı karakter matrisindedir, denge dosyasında ikinci tavan yoktur.
  - Kabul: KVR kıskacı −4…+4 stat içindir. Akçe tavanı karakter matrisindedir, denge dosyasında ikinci tavan yoktur. Test: matris 3 ise kasa +3, dosyada ayrı tavan anahtarı yok.
  - Bağımlılık: KOP-10, DEN-08. Boyut: S.
  - Dosya: `tools/denge_dogrula.py`.
  - Asset: asset gerekmedi.
- [ ] **DEN-43:** Yozlaşma skoru ODA-12'dir.
  - Ne: rüşvet skoru o sisteme yazar. Yeni terazi açılmaz.
  - Kabul: rüşvet skoru o sisteme yazar. Yeni terazi açılmaz. Test: bir rüşvet, skor bir kez artar.
  - Bağımlılık: ODA-12. Boyut: S.
  - Dosya: `tests/unit/denge/rusvet_test.gd`.
  - Asset: asset gerekmedi.
- [ ] **DEN-44:** Yirmi rüşvet, müfettiş eşiğine gider.
  - Ne: ODA-07 eşiği değişmez. Ölçüm, tablodaki rüşvet sayısında teftiş bayrağının açıldığını söyler. Sayı dosyadadır ve ODA eşiğiyle aynı olmalıdır. Farklıysa hata.
  - Kabul: ODA-07 eşiği değişmez. Ölçüm, tablodaki rüşvet sayısında teftiş bayrağının açıldığını söyler. Sayı dosyadadır ve ODA eşiğiyle aynı olmalıdır. Farklıysa hata. Test: eşik eşitliği.
  - Bağımlılık: ODA-07, DEN-03. Boyut: M.
  - Dosya: `tools/denge_dogrula.py`.
  - Asset: asset gerekmedi.
- [ ] **DEN-45:** Adil uçta rüşvet reddi kasayı büyütmez.
  - Ne: ret, kişisel kasaya 0 yazar. Ölçüm bunu 20 rette doğrular.
  - Kabul: ret, kişisel kasaya 0 yazar. Ölçüm bunu 20 rette doğrular. Test: kasa deltası 0.
  - Bağımlılık: DEN-41. Boyut: S.
  - Dosya: `tests/unit/denge/rusvet_test.gd`.
  - Asset: asset gerekmedi.
- [ ] **DEN-46:** Haraç yeteneği ODA-05'tir.
  - Ne: günlük esnaf haraç o yetenekte kalır. Denge yeni bir vergi icat etmez.
  - Kabul: günlük esnaf haraç o yetenekte kalır. Denge yeni bir vergi icat etmez. Test: yetenek kapalıyken haraç 0.
  - Bağımlılık: ODA-05. Boyut: S.
  - Dosya: `tests/unit/denge/rusvet_test.gd`.
  - Asset: asset gerekmedi.
- [ ] **DEN-47:** Rüşvet ekonomisi 28 günde aralıktadır.
  - Ne: olağan zorlukta, rüşveti kabul eden otomatik oyuncunun kişisel kasası tablodaki alt ve üst sınırdadır.
  - Kabul: olağan zorlukta, rüşveti kabul eden otomatik oyuncunun kişisel kasası tablodaki alt ve üst sınırdadır. Test: 28 gece, kasa aralıkta.
  - Bağımlılık: DEN-04, DEN-41. Boyut: M.
  - Dosya: `data/ayarlar/denge.json` `rusvet_kasa_aralik`.
  - Asset: asset gerekmedi.
- [ ] **DEN-48:** Rüşveti reddeden oyuncu aynı 28 günde iflas etmez.
  - Ne: ret oyuncusunun köy akçesi 3 gece üst üste eksi olmaz (EKO-10 eşiği).
  - Kabul: ret oyuncusunun köy akçesi 3 gece üst üste eksi olmaz (EKO-10 eşiği). Test: 28 gece, iflas olayı 0.
  - Bağımlılık: EKO-10, DEN-47. Boyut: M.
  - Dosya: `tests/oto/denge_persona.tscn`.
  - Asset: asset gerekmedi.

### 32.7 Fiyat eğrisi

- [ ] **DEN-49:** Fiyat TUC-09'dur.
  - Ne: kış çarpanı o maddede kalır. Denge dosyası aynı çarpanı kopyalamaz.
  - Kabul: kış çarpanı o maddede kalır. Denge dosyası aynı çarpanı kopyalamaz. Test: tek kış çarpanı.
  - Bağımlılık: TUC-09, DEN-03. Boyut: S.
  - Dosya: `tools/denge_dogrula.py`.
  - Asset: asset gerekmedi.
- [x] **DEN-50:** (testx) Kış odunu yaz odunundan pahalıdır.
  - Ne: ölçülen fiyat, TUC-09 çarpanına uyar. Sapma yüzde 0'dır, çünkü çarpan tek kaynaktır.
  - Kabul: ölçülen fiyat, TUC-09 çarpanına uyar. Sapma yüzde 0'dır, çünkü çarpan tek kaynaktır. Test: kış fiyatı = yaz fiyatı çarpı çarpan.
  - Bağımlılık: TUC-09, MEV-01. Boyut: S.
  - Dosya: `tests/unit/denge/fiyat_test.gd`.
  - Asset: asset gerekmedi.
- [x] **DEN-51:** (testx) Erzak bitince fiyat tavandadır.
  - Ne: tavan TUC-09 tablosundadır. Bu bölüm tavanı yükseltmez.
  - Kabul: tavan TUC-09 tablosundadır. Bu bölüm tavanı yükseltmez. Test: erzak 0, fiyat tavan, tavanın üstü yok.
  - Bağımlılık: TUC-09. Boyut: S.
  - Dosya: `tests/unit/denge/fiyat_test.gd`.
  - Asset: asset gerekmedi.
- [x] **DEN-52:** (testx) Oyuncu satışı iki kasaya ayrı yazılır.
  - Ne: TUC-10 resmi satış köy akçesine, kişisel satış muhafız akçesine gider. Ölçüm karışmayı 10 satışta arar.
  - Kabul: TUC-10 resmi satış köy akçesine, kişisel satış muhafız akçesine gider. Ölçüm karışmayı 10 satışta arar. Test: karışma 0.
  - Bağımlılık: TUC-10, EKO-01. Boyut: S.
  - Dosya: `tests/unit/denge/fiyat_test.gd`.
  - Asset: asset gerekmedi.
- [ ] **DEN-53:** Sözleşme cezası TUC-07'dir.
  - Ne: gecikme faizi o maddede kalır. Denge faizi ikinci kez tanımlamaz.
  - Kabul: gecikme faizi o maddede kalır. Denge faizi ikinci kez tanımlamaz. Test: tek faiz anahtarı.
  - Bağımlılık: TUC-07, DEN-03. Boyut: S.
  - Dosya: `tools/denge_dogrula.py`.
  - Asset: asset gerekmedi.
- [ ] **DEN-54:** Yirmi sekiz günde tüccar iflası aralıktadır.
  - Ne: olağan oyunda EKO-10 iflası tablodaki alt ve üst sayıdadır. Alt sınır 0 olabilir.
  - Kabul: olağan oyunda EKO-10 iflası tablodaki alt ve üst sayıdadır. Alt sınır 0 olabilir. Test: 28 gece, sayı aralıkta.
  - Bağımlılık: EKO-10, TUC-09. Boyut: M.
  - Dosya: `data/ayarlar/denge.json` `iflas_aralik`.
  - Asset: asset gerekmedi.
- [x] **DEN-55:** (testx) Fiyat, gece raporunda kaynağıyla durur.
  - Ne: EKO-15 bilançosu kış çarpanını ayrı satır yazar. Yeni bilanço yoktur.
  - Kabul: EKO-15 bilançosu kış çarpanını ayrı satır yazar. Yeni bilanço yoktur. Test: kış gecesinde satır var, yaz gecesinde yok.
  - Bağımlılık: EKO-15, TUC-09. Boyut: S.
  - Dosya: mevcut bilanço.
  - Asset: asset gerekmedi.
- [x] **DEN-56:** (testx) Karaborsa fiyatı kişisel kasadadır.
  - Ne: TUC-11 alışı `muhafiz_akce` düşer. Köy akçesi düşmez.
  - Kabul: TUC-11 alışı `muhafiz_akce` düşer. Köy akçesi düşmez. Test: bir alış, iki kasa.
  - Bağımlılık: TUC-11. Boyut: S.
  - Dosya: `tests/unit/denge/fiyat_test.gd`.
  - Asset: asset gerekmedi.

### 32.8 Kriz sıklığı

- [ ] **DEN-57:** Kriz listesi KRI maddeleridir.
  - Ne: salgın, kıtlık, kundak, zehir, isyan ayrı sistem olarak durur. Denge yalnız aralık yazar: 28 günde en az ve en çok kaç kriz.
  - Kabul: salgın, kıtlık, kundak, zehir, isyan ayrı sistem olarak durur. Denge yalnız aralık yazar: 28 günde en az ve en çok kaç kriz. Test: aralık dosyada, kriz kodu dosyada değil.
  - Bağımlılık: DEN-01. Boyut: S.
  - Dosya: `data/ayarlar/denge.json` `kriz_aralik`.
  - Asset: asset gerekmedi.
- [ ] **DEN-58:** İlk 14 gün tehdit BUG-18'dir.
  - Ne: pusu, çete, casus ve sabotaj o günden önce 0'dır. Denge bu kapıyı gevşetmez.
  - Kabul: pusu, çete, casus ve sabotaj o günden önce 0'dır. Denge bu kapıyı gevşetmez. Test: 13. gün tehdit 0.
  - Bağımlılık: BUG-18. Boyut: S.
  - Dosya: mevcut BUG-18 testi.
  - Asset: asset gerekmedi.
- [ ] **DEN-59:** 28 günde kriz sayısı aralıktadır.
  - Ne: olağan zorluk, sabit tohumla 28 gecede kriz sayısı alt ve üst arasındadır.
  - Kabul: olağan zorluk, sabit tohumla 28 gecede kriz sayısı alt ve üst arasındadır. Test: 20 tohumun en az 16'sı aralıkta.
  - Bağımlılık: DEN-57, DEN-04. Boyut: M.
  - Dosya: `tests/oto/denge_kriz.tscn`.
  - Asset: asset gerekmedi.
- [ ] **DEN-60:** İki kriz aynı gece tek rapordadır.
  - Ne: KRI-10 üst üste binmeyi zaten bilir. Ölçüm, aynı gecede iki kriz satırının tek raporda durduğunu söyler. Yeni birleştirici yok.
  - Kabul: KRI-10 üst üste binmeyi zaten bilir. Ölçüm, aynı gecede iki kriz satırının tek raporda durduğunu söyler. Yeni birleştirici yok. Test: iki kriz, rapor başlığı bir.
  - Bağımlılık: KRI-10. Boyut: S.
  - Dosya: `tests/oto/denge_kriz.tscn`.
  - Asset: asset gerekmedi.
- [ ] **DEN-61:** Kıtlık, erzak 0 ile ölçülür.
  - Ne: KRI-06 iki gece 0 kuralı değişmez. Ölçüm, eşiğin bir geceye inmediğini doğrular.
  - Kabul: KRI-06 iki gece 0 kuralı değişmez. Ölçüm, eşiğin bir geceye inmediğini doğrular. Test: 1 gece 0, isyan yok. 2 gece 0, isyan var.
  - Bağımlılık: KRI-06. Boyut: S.
  - Dosya: `tests/oto/denge_kriz.tscn`.
  - Asset: asset gerekmedi.
- [ ] **DEN-62:** Salgın, kapı teşhisi olmadan kendiliğinden başlamaz.
  - Ne: KRI-01 ve KRI-11 durur. Denge, teşhis kapalı bir kayıtta 28 günde salgın 0 ölçer.
  - Kabul: KRI-01 ve KRI-11 durur. Denge, teşhis kapalı bir kayıtta 28 günde salgın 0 ölçer. Test: teşhissiz 28 gece.
  - Bağımlılık: KRI-01, KRI-11. Boyut: M.
  - Dosya: `tests/oto/denge_kriz.tscn`.
  - Asset: asset gerekmedi.
- [ ] **DEN-63:** Sıkı zorluk kriz aralığını yükseltir.
  - Ne: DEN-04 çarpanı alt ve üst sınırı birlikte kaydırır. Olağanın üst sınırı, sıkının alt sınırından büyüktür.
  - Kabul: DEN-04 çarpanı alt ve üst sınırı birlikte kaydırır. Olağanın üst sınırı, sıkının alt sınırından büyüktür. Test: iki aralık kesişmez.
  - Bağımlılık: DEN-04, DEN-57. Boyut: S.
  - Dosya: `data/ayarlar/denge.json`.
  - Asset: asset gerekmedi.
- [ ] **DEN-64:** Kriz ölçümü Moğol sayacını ilerletmez.
  - Ne: HAR-02 kendi günündedir. Kriz sayacı ona yazmaz.
  - Kabul: HAR-02 kendi günündedir. Kriz sayacı ona yazmaz. Test: 28 gece kriz ölçümü, Moğol kalan günü takvim kadar azalır, fazlası yok.
  - Bağımlılık: HAR-02, DEN-59. Boyut: S.
  - Dosya: `tests/oto/denge_kriz.tscn`.
  - Asset: asset gerekmedi.

### 32.9 Zorluk

- [ ] **DEN-65:** Üç zorluk vardır.
  - Ne: kolay, olağan, sıkı. Dördüncü ad yazılırsa doğrulayıcı hata verir.
  - Kabul: kolay, olağan, sıkı. Dördüncü ad yazılırsa doğrulayıcı hata verir. Test: üç anahtar.
  - Bağımlılık: DEN-04. Boyut: S.
  - Dosya: `data/ayarlar/denge.json`.
  - Asset: asset gerekmedi.
- [ ] **DEN-66:** Zorluk yeni oyunda seçilir.
  - Ne: seçim açılıştadır. Kayıtta tek alan. Yüklemede değişmez.
  - Kabul: seçim açılıştadır. Kayıtta tek alan. Yüklemede değişmez. Test: sıkı kayıt, yüklemede sıkı.
  - Bağımlılık: DEN-65, KAY-03. Boyut: S.
  - Dosya: `src/sistemler/acilis_senaryosu.gd` tek alan.
  - Asset: asset gerekmedi.
- [ ] **DEN-67:** Zorluk zar formülünü değiştirmez.
  - Ne: ZAR-01 eşikleri üç zorlukta da aynıdır. Zorluk gelen sayısını, kriz aralığını ve fiyat çarpanını değiştirir.
  - Kabul: ZAR-01 eşikleri üç zorlukta da aynıdır. Zorluk gelen sayısını, kriz aralığını ve fiyat çarpanını değiştirir. Test: gerekli zar sayısı iki zorlukta eşit.
  - Bağımlılık: ZAR-01, DEN-65. Boyut: S.
  - Dosya: `tests/unit/denge/zorluk_test.gd`.
  - Asset: asset gerekmedi.
- [ ] **DEN-68:** Kolay, ilk 10 günde odun bitirmez.
  - Ne: DEN-10 koşulu kolayda da 0'dır. Kolay, odunu sonsuz yapmaz.
  - Kabul: DEN-10 koşulu kolayda da 0'dır. Kolay, odunu sonsuz yapmaz. Test: 10 gece, odun dibi 0 değil.
  - Bağımlılık: DEN-10, DEN-65. Boyut: S.
  - Dosya: `tests/oto/acilis_denge_kontrol.tscn`.
  - Asset: asset gerekmedi.
- [ ] **DEN-69:** Sıkı, açılış erzağını payın altına indirir.
  - Ne: DEN-13 payı sıkıda çarpanla küçülür. Pay 1 gecenin altına inmez.
  - Kabul: DEN-13 payı sıkıda çarpanla küçülür. Pay 1 gecenin altına inmez. Test: sıkı erzak, olağandan küçük, 1 geceden büyük.
  - Bağımlılık: DEN-13, DEN-04. Boyut: S.
  - Dosya: `data/ayarlar/denge.json`.
  - Asset: asset gerekmedi.
- [ ] **DEN-70:** Olağan, ölçümün referansıdır.
  - Ne: DEN-47, DEN-54 ve DEN-59 olağanda koşar. Kolay ve sıkı ayrı aralık taşır.
  - Kabul: DEN-47, DEN-54 ve DEN-59 olağanda koşar. Kolay ve sıkı ayrı aralık taşır. Test: üç aralık dosyada.
  - Bağımlılık: DEN-65. Boyut: S.
  - Dosya: `data/ayarlar/denge.json`.
  - Asset: asset gerekmedi.
- [ ] **DEN-71:** Zorluk, son kimliğini değiştirmez.
  - Ne: SYS-20 beş sonu üç zorlukta da aynı kimliklerdir. Sıkı altıncı son açmaz.
  - Kabul: SYS-20 beş sonu üç zorlukta da aynı kimliklerdir. Sıkı altıncı son açmaz. Test: son kümesi eşit.
  - Bağımlılık: SYS-20, DEN-65. Boyut: S.
  - Dosya: `tests/unit/denge/zorluk_test.gd`.
  - Asset: asset gerekmedi.
- [ ] **DEN-72:** Zorluk menüsü Bölüm 35 ve 43'e kalır.
  - Ne: bu bölüm seçimin verisini yazar. Yazı boyutu, sekme ve panel burada yoktur.
  - Kabul: bu bölüm seçimin verisini yazar. Yazı boyutu, sekme ve panel burada yoktur. Test: bu dosyada arayüz maddesi 0.
  - Bağımlılık: DEN-66. Boyut: S.
  - Dosya: `data/ayarlar/denge.json`.
  - Asset: asset gerekmedi.

### 32.10 Son dağılımı ve persona

- [ ] **DEN-73:** Beş sonun hedef aralığı vardır.
  - Ne: 100 otomatik oyun, her son tablodaki alt ve üst yüzde arasındadır. Yüzdelerin toplamı 100'dür. Altıncı son 0'dır.
  - Kabul: 100 otomatik oyun, her son tablodaki alt ve üst yüzde arasındadır. Yüzdelerin toplamı 100'dür. Altıncı son 0'dır. Test: toplam 100, altıncı 0.
  - Bağımlılık: SYS-20, DEN-01. Boyut: M.
  - Dosya: `data/ayarlar/denge.json` `son_aralik`.
  - Asset: asset gerekmedi.
- [ ] **DEN-74:** İflas ve yıkım ayrı sayılır.
  - Ne: EKO-10 iflası bir son değildir. Son dağılımına karışmaz.
  - Kabul: EKO-10 iflası bir son değildir. Son dağılımına karışmaz. Test: iflaslı oyun, son kimliği hâlâ beşten biridir veya oyun sürmektedir.
  - Bağımlılık: EKO-10, DEN-73. Boyut: S.
  - Dosya: `tests/oto/denge_persona.tscn`.
  - Asset: asset gerekmedi.
- [ ] **DEN-75:** TST-04 personası burada tanımlanmaz.
  - Ne: ölçüm, Tester TST-04 kimliğini okur. O maddenin adımları bu dosyada yoktur. Kimlik yoksa ölçüm durur, uydurma persona yazılmaz.
  - Kabul: ölçüm, Tester TST-04 kimliğini okur. O maddenin adımları bu dosyada yoktur. Kimlik yoksa ölçüm durur, uydurma persona yazılmaz. Test: kimlik listesi TST dosyasıyla aynıdır.
  - Bağımlılık: DEN-05. Boyut: S.
  - Dosya: `src/sistemler/denge_olcumu.gd`.
  - Asset: asset gerekmedi.
- [ ] **DEN-76:** TST-05 sonuç ölçüsü burada tanımlanmaz.
  - Ne: son dağılımı TST-05'in sayacını okur. İkinci bir son sayacı yazılmaz.
  - Kabul: son dağılımı TST-05'in sayacını okur. İkinci bir son sayacı yazılmaz. Test: sayaç bir.
  - Bağımlılık: DEN-73, SYS-20. Boyut: S.
  - Dosya: `src/sistemler/denge_olcumu.gd`.
  - Asset: asset gerekmedi.
- [ ] **DEN-77:** Dört oyuncu tipi dört dağılım verir.
  - Ne: tipler DEN-75 kimlikleridir. Rüşvetçi, reddeden, aç ve tok ayrı 28 gece koşar. Dörder dağılım tabloda ayrı satırdır.
  - Kabul: tipler DEN-75 kimlikleridir. Rüşvetçi, reddeden, aç ve tok ayrı 28 gece koşar. Dörder dağılım tabloda ayrı satırdır. Test: dört satır, birbirinin kopyası değil.
  - Bağımlılık: DEN-75, DEN-47, DEN-48. Boyut: L.
  - Dosya: `tests/oto/denge_persona.tscn`.
  - Asset: asset gerekmedi.
- [ ] **DEN-78:** Aynı tohum aynı sonu verir.
  - Ne: persona ve zorluk sabitse 2 koşu aynı son kimliğindedir.
  - Kabul: persona ve zorluk sabitse 2 koşu aynı son kimliğindedir. Test: çift koşu.
  - Bağımlılık: DEN-73, KAY-19. Boyut: S.
  - Dosya: `tests/oto/denge_persona.tscn`.
  - Asset: asset gerekmedi.
- [ ] **DEN-79:** Ölçüm 100 oyunu bir gecede bitirir.
  - Ne: headless paket, SYS-10 dumanının üstüne 100 kısa oyun ekler. Süre raporda. Yeni tavan uydurulmaz. Paket kırmızıysa birleşme yok.
  - Kabul: headless paket, SYS-10 dumanının üstüne 100 kısa oyun ekler. Süre raporda. Yeni tavan uydurulmaz. Paket kırmızıysa birleşme yok. Test: 100 koşu biter.
  - Bağımlılık: SYS-10, DEN-73. Boyut: M.
  - Dosya: `tools/sanity_check.py` tek satır.
  - Asset: asset gerekmedi.
- [ ] **DEN-80:** Sapma, tabloyu kendisi değiştirmez.
  - Ne: aralık dışındaki ölçüm rapor yazar. `denge.json` oyun sırasında yazılmaz. Değişiklik insan eliyledir.
  - Kabul: aralık dışındaki ölçüm rapor yazar. `denge.json` oyun sırasında yazılmaz. Değişiklik insan eliyledir. Test: sapmalı koşu, dosya baytı aynı.
  - Bağımlılık: DEN-06, DEN-73. Boyut: S.
  - Dosya: `src/sistemler/denge_olcumu.gd`.
  - Asset: asset gerekmedi.


---

## BÖLÜM 33: Oyuncuyu alıştırma ve ilk saat


Faz 1 (ACL ve KAP-16 ile birlikte). Zemin: açılış sahnesi ACL-01 (köy ekranından başlar), ACL-04 (ulak, berat, ilk aile), ACL-06 (muhafızın geçmişi), açılış ekonomisi BUG-21/BUG-22, tehdit alışma süresi BUG-18, boş gün KAP-16, menü `src/arayuz/menu_ekrani.gd`, bilgi kadrajı `src/arayuz/bilgi_ekrani.gd`, metin anahtarları `data/metin/metinler.csv` (`arayuz.menu.ipucu` var). Kodda öğretici, rehber veya ilk gün akışı yoktur (`rg -i 'ogretici|tutorial|rehber' src` → 0). Bu bölüm açılışı yeniden yazmaz; ilk saatin öğrenme sırasını, ipuçlarının ne zaman ve nerede çıkacağını, neyin gizli kalacağını yazar.

Kimlikler OGR-01 … OGR-57. Öğretici ayrı bir mod değildir; oyunun ilk gecesidir. Pencereli, oyunu durduran, "devam için tıkla" diyen bir ders yoktur. Oyuncu kapıda ve köyde yaparak öğrenir; satırlar yalnız ilk kez bir şey yapılacağı an gelir, bir kez görünür, kayda yazılır.

Mimari: her madde yeni dosyadır, çekirdeğe (`ana.gd`, `koy_ekrani.gd`, `hud.gd`, `kapi_ekrani.gd`) tek satır adaptör. `koy_sahnesi` yasaktır. Bitince `[x]` ve ajan adı. Asset üretilmez; görsel ihtiyaç ARY-05'e yazılır. Ses yok.

**Madde biçimi:** Ne, Kabul, Bağımlılık + Boyut, Dosya, Asset.

---

### 33.1 İlk saatin omurgası — neyin ne zaman öğrenildiği

- [x] **OGR-01:** İlk saat haritası tek dosyada durur. (Antigravity)
  - Ne: oyuncunun ilk altı gecede karşılaşacağı kavramlar (kapı sorgusu, zar, bar, heybe, köy atama, gece raporu, pazar, divan, oda) gece numarasına bağlı sıralı listedir. Hangi kavramın hangi gecede ilk kez göründüğü buradan okunur.
  - Kabul: `data/ogretici/ilk_saat.json` içinde her kavramın `gece_min` ve `tetik` alanı vardır. Listede olmayan ipucu çıkmaz. Test: dosyadaki kavram sayısı ile ilk altı gecede gösterilen ipucu sayısı eşittir.
  - Bağımlılık: ACL-04. Boyut: S.
  - Dosya: yeni: `data/ogretici/ilk_saat.json`; yeni: `src/sistemler/ilk_saat.gd`.
  - Asset: asset gerekmedi.
- [ ] **OGR-02:** İlk gece yalnız kapı ve karar öğretir.
  - Ne: ulak ve ilk aile (ACL-04) geçerken oyuncu yalnız soru sormayı ve kabul/ret vermeyi görür. Rüşvet, arama, zar değiştiricisi ve heybe ilk gece kapalıdır.
  - Kabul: gece 0'da `rusvet_hakki` (`data/ayarlar/oyun.tres`) düğmesi görünmez; soru sayısı `azami_soru` (4) ile sınırlı kalır. Test: gece 0 anlık görüntüsünde rüşvet ve arama düğmesi 0.
  - Bağımlılık: OGR-01, ACL-04. Boyut: S.
  - Dosya: yeni: `src/kapi/ilk_gece_kisiti.gd`; `src/arayuz/kapi_ekrani.gd` tek satır.
  - Asset: asset gerekmedi.
- [x] **OGR-03:** İkinci gece zar görünür olur. (Antigravity)
  - Ne: görünür zar (ZAR-01) ilk kez ikinci gece bir soruda açılır. Oyuncu zarı ilk kez attığında "gerekli = değer + 1 + tansiyon eki" formülü tek satırlık ipucuyla gösterilir.
  - Kabul: ipucu bir kez görünür, `ilk_saat` kaydına `zar_gosterildi` yazılır. Test: aynı kayıtla ikinci açılışta ipucu 0.
  - Bağımlılık: ZAR-01, OGR-01. Boyut: S.
  - Dosya: yeni: `src/kapi/zar_ipucu.gd`.
  - Asset: asset gerekmedi.
- [ ] **OGR-04:** Köy ekranı ilk kez kabulden sonra açılır.
  - Ne: ilk kabul edilen kişi köye girince oyuncu köy ekranına geçer; ilk görev onu bir işe atamaktır (ISG-01 uyarısı burada ilk kez görünür).
  - Kabul: ilk kabulden önce köy ekranı düğmesi pasiftir. Test: kabul 0 iken köy ekranına geçiş 0.
  - Bağımlılık: ACL-01, ISG-01. Boyut: S.
  - Dosya: yeni: `src/sistemler/ilk_saat.gd` içinde `koy_acik()`; `src/arayuz/ana.gd` tek satır.
  - Asset: asset gerekmedi.
- [ ] **OGR-05:** Gece raporu ilk kez üç satırla gelir.
  - Ne: ilk gece raporu (`src/sistemler/gece_bilancosu.gd`) tam tablo yerine üç satır gösterir: kim geldi, kim kaldı, ambar ne oldu. Tam tablo üçüncü geceden sonra açılır.
  - Kabul: gece 0 ve 1 raporunda satır sayısı 3; gece 3'ten sonra tam. Test: iki anlık görüntü karşılaştırması.
  - Bağımlılık: OGR-01. Boyut: S.
  - Dosya: yeni: `src/arayuz/gece_raporu_kisa.gd`; `src/arayuz/koy_ekrani.gd` tek satır.
  - Asset: asset gerekmedi.
- [x] **OGR-06:** Tehdit alışma süresi ilk saatle hizalıdır. (Antigravity)
  - Ne: BUG-18'in "ilk N gün tehdit yok" değeri, OGR-01 listesinde pazar ve divan öğrenilmeden önce dolmaz. İki sayı tek yerden okunur.
  - Kabul: `ilk_saat.json` içindeki `tehdit_baslangic` BUG-18 sabitini okur; iki ayrı sayı yoktur. Test: değer değişince ikisi birlikte değişir.
  - Bağımlılık: BUG-18, OGR-01. Boyut: S.
  - Dosya: `data/ogretici/ilk_saat.json`.
  - Asset: asset gerekmedi.

### 33.2 Bağlamsal ipuçları — bir kez, yerinde, kısa

- [x] **OGR-07:** İpucu kaydı kayıt dosyasındadır. (Antigravity)
  - Ne: gösterilen her ipucunun kimliği oyun kaydına `ogretici.gorulen` dizisinde yazılır. Yeni oyunda sıfırlanır; ayarlardan "ipuçlarını sıfırla" ile de sıfırlanır (Bölüm 35).
  - Kabul: kayıt sürümü KAY zincirine uyar; eski kayıtta alan yoksa boş sayılır, oyun çökmez. Test: alan silinmiş kayıt açılır.
  - Bağımlılık: KAY-04. Boyut: S.
  - Dosya: yeni: `src/sistemler/ipucu_kaydi.gd`.
  - Asset: asset gerekmedi.
- [x] **OGR-08:** İpucu tek satırdır ve ekranın aynı köşesindedir. (Antigravity)
  - Ne: ipucu metni en çok 90 karakterdir, HUD'un alt-sol köşesinde 6 saniye durur ya da ilk girdiyle kapanır. Pencere açmaz, oyunu durdurmaz.
  - Kabul: `metinler.csv` `ogretici.*` anahtarlarının hepsi ≤ 90 karakter (`tools/metin_dogrula.py` kuralı). Test: tarama 0 ihlal.
  - Bağımlılık: OGR-07. Boyut: S.
  - Dosya: yeni: `src/arayuz/ipucu_seridi.gd`; `tools/metin_dogrula.py` tek kural.
  - Asset: asset gerekmedi.
- [ ] **OGR-09:** İpucu kendi anahtarıyla yazılır, Üslup Rehberi'ne uyar.
  - Ne: ipucu metinleri `ogretici.` önekiyle `metinler.csv`'ye girer; USLUP_REHBERI §7 yapaylık denetiminden geçer ("Bu hatırlanacak" tonu değil, muhafızın kendi kendine notu tonu).
  - Kabul: `ogretici.` anahtarları yapaylık taramasından (YAZ-10) geçer. Test: tarama raporunda `ogretici.` ihlali 0.
  - Bağımlılık: YAZ-02, YAZ-10. Boyut: S.
  - Dosya: `data/metin/metinler.csv` (yeni satırlar).
  - Asset: asset gerekmedi.
- [ ] **OGR-10:** Aynı ipucu iki kez çıkmaz, kaçırılan ipucu geri çağrılabilir.
  - Ne: görülen ipucu bir daha gelmez. Oyuncu kaçırdıysa Bölüm 39 hafıza defterinin "Not" sayfasında son beş ipucu durur.
  - Kabul: aynı kimlik kayıtta bir kez; defter sayfasında en çok beş satır. Test: altı ipucu sonrası sayfa 5 satır.
  - Bağımlılık: OGR-07, HFZ-01. Boyut: S.
  - Dosya: `src/sistemler/ipucu_kaydi.gd`.
  - Asset: asset gerekmedi.
- [x] **OGR-11:** İpucu, köy hızı 0 değilken de gelir, hızı değiştirmez. (Antigravity)
  - Ne: köy ekranında zaman akarken (`koy_ekrani.gd:342 _hiz_sec`) ipucu `Engine.time_scale`'e dokunmaz.
  - Kabul: ipucu öncesi ve sonrası `time_scale` eşittir. Test: hız 2'de ipucu açılıp kapanınca hız 2.
  - Bağımlılık: OGR-08. Boyut: S.
  - Dosya: `src/arayuz/ipucu_seridi.gd`.
  - Asset: asset gerekmedi.
- [x] **OGR-12:** Debug HUD'da ipucu akışı izlenir. (Antigravity)
  - Ne: `src/debug/admin_hud.gd` (F1) listesine "görülen ipuçları" satırı ve "hepsini sıfırla" düğmesi eklenir. Oyuncu arayüzüne girmez.
  - Kabul: debug kapalıyken düğme 0. Test: `--debug` olmadan açılışta düğme yok.
  - Bağımlılık: OGR-07. Boyut: S.
  - Dosya: yeni: `src/debug/ipucu_paneli.gd`; `admin_hud.gd` tek satır.
  - Asset: asset gerekmedi.

### 33.3 Kapı sorgusunun öğretilmesi

- [ ] **OGR-13:** İlk aile sorgusu kılavuzsuz ama dar.
  - Ne: ACL-04'teki ilk ailede konu merkezinde (DIY-04) yalnız iki konu açıktır: kim olduğu ve neden geldiği. Diğer konular sonraki ziyaretlerde açılır.
  - Kabul: gece 0 ilk ailede açık konu 2. Test: söz dosyasında `gece_min` alanı.
  - Bağımlılık: DIY-04, ACL-04. Boyut: S.
  - Dosya: Söz veri dosyası (DIY-02 şeması) `gece_min` alanı; ilk aile dosyası YAZ-05 pilotunda.
  - Asset: asset gerekmedi.
- [ ] **OGR-14:** Beyan defteri ilk çelişkide tanıtılır.
  - Ne: beyan defteri (DIY-07) ilk kez bir karakter kendi sözüyle çelişince açılır; o ana kadar HUD'da düğmesi görünmez.
  - Kabul: ilk çelişki öncesi defter düğmesi 0; sonrası 1 ve ipucu bir kez. Test: çelişkisiz üç ziyaret sonrası düğme 0.
  - Bağımlılık: DIY-07, DIY-08, OGR-07. Boyut: S.
  - Dosya: yeni: `src/kapi/defter_tanitimi.gd`.
  - Asset: asset gerekmedi.
- [x] **OGR-15:** Heybe ilk kez bir gizli eşyada açılır. (Antigravity)
  - Ne: heybe arama (R1 heybe, `src/sistemler/heybe.gd`) ilk kez `esya_gizli` (oyun.tres `yuzuk`) taşıyan kişide ipucu alır. Önceki ziyaretlerde heybe düğmesi vardır ama ipucu yoktur.
  - Kabul: ilk gizli eşya ziyaretinde ipucu 1. Test: gizli eşyasız kayıtta ipucu 0.
  - Bağımlılık: OGR-07. Boyut: S.
  - Dosya: `src/sistemler/ilk_saat.gd` tetik satırı.
  - Asset: asset gerekmedi.
- [x] **OGR-16:** Tansiyon göstergesi ilk sarıda açıklanır. (Antigravity)
  - Ne: `src/arayuz/kapi/tansiyon_gostergesi.gd` ilk kez "gergin" kademeye (ZAR-01 +1) geçince tek satır ipucu: zar zorlaştı.
  - Kabul: ipucu kademe geçişinde bir kez. Test: sakin kalan gecede ipucu 0.
  - Bağımlılık: ZAR-01, OGR-07. Boyut: S.
  - Dosya: `src/sistemler/ilk_saat.gd` tetik satırı.
  - Asset: asset gerekmedi.
- [x] **OGR-17:** Bar etkisi ilk hareket eden barda gösterilir. (Antigravity)
  - Ne: dört bar (`bar.halk`, `bar.soylular`, `bar.tuccarlar`, `bar.ordu`; `oyun.tres bar_baslangic 6`) ilk kez değişince hangi kararın hangi barı oynattığı tek satırla söylenir.
  - Kabul: ipucu ilk değişimde bir kez; bar adı anahtarla yazılır. Test: bar değişmeyen gecede 0.
  - Bağımlılık: OGR-07. Boyut: S.
  - Dosya: `src/sistemler/ilk_saat.gd` tetik satırı.
  - Asset: asset gerekmedi.
- [x] **OGR-18:** Kabul sınırı (barınak) ilk doluda söylenir. (Antigravity)
  - Ne: ACL-05 barınak kapasitesi ilk kez dolunca ipucu: yer yok, kabul edilen dışarıda kalır. İpucu kararı engellemez.
  - Kabul: ilk dolu anda bir kez. Test: kapasite dolmadan 0.
  - Bağımlılık: ACL-05, OGR-07. Boyut: S.
  - Dosya: `src/sistemler/ilk_saat.gd` tetik satırı.
  - Asset: asset gerekmedi.

### 33.4 Köy ekranının öğretilmesi

- [ ] **OGR-19:** İlk atama sürükle-bırakla gösterilir.
  - Ne: ilk köylü kartı (`src/arayuz/koylu_karti.gd`, `koylu_surukleme_kulpu.gd`) sürüklenebilir olduğunda tek satır ipucu ve kartın kulpunda bir kez yanıp sönen vurgu.
  - Kabul: ilk atama sonrası vurgu kalkar. Test: ikinci köylüde vurgu 0.
  - Bağımlılık: OGR-04. Boyut: S.
  - Dosya: yeni: `src/arayuz/koy_hud/ilk_atama_vurgusu.gd`.
  - Asset: asset gerekmedi (vurgu kod çizimi).
- [x] **OGR-20:** Kaynak göstergesi ilk eksilişte açıklanır. (Antigravity)
  - Ne: `koy_hud/kaynak_gostergesi.gd` ilk kez bir kaynak düşünce tüketim satırı (EKO-09, `tuketim_dengesi.json`) tek satırla söylenir.
  - Kabul: bir kez. Test: tüketim 0 olan gecede ipucu 0.
  - Bağımlılık: OGR-07. Boyut: S.
  - Dosya: `src/sistemler/ilk_saat.gd` tetik satırı.
  - Asset: asset gerekmedi.
- [x] **OGR-21:** Taş ve odun kilidi ilk inşa denemesinde uyarır. (Antigravity)
  - Ne: BUG-21/BUG-22 düzeltmesinden sonra bile ilk inşa denemesinde kaynak yetmezse ipucu kaynağın nereden geldiğini söyler (taş yatağı, oduncu).
  - Kabul: yetersiz kaynakla ilk denemede bir kez. Test: yeterli kaynakla 0.
  - Bağımlılık: BUG-21, BUG-22. Boyut: S.
  - Dosya: `src/sistemler/ilk_saat.gd` tetik satırı.
  - Asset: asset gerekmedi.
- [ ] **OGR-22:** Hız tuşları ilk köy gününde gösterilir.
  - Ne: köy ekranında hız seçimi (`koy_ekrani.gd:330–343`, 1–5 ve P) ilk açılışta tek satırla söylenir; tuş adları Bölüm 45 eylem haritasından okunur.
  - Kabul: ipucu metninde tuş adı sabit değil, eylemden gelir. Test: tuş yeniden atanınca ipucu metni değişir.
  - Bağımlılık: GIR-03, OGR-07. Boyut: S.
  - Dosya: `src/sistemler/ilk_saat.gd` tetik satırı.
  - Asset: asset gerekmedi.
- [ ] **OGR-23:** Boş gün ilk kez gelince açıklanır.
  - Ne: KAP-16 boş gün ilk kez düşünce ipucu: bugün kapıya kimse gelmedi, köy günü (SEV-01).
  - Kabul: ilk boş günde bir kez. Test: boş gün olmayan altı gecede 0.
  - Bağımlılık: KAP-16, SEV-01. Boyut: S.
  - Dosya: `src/sistemler/ilk_saat.gd` tetik satırı.
  - Asset: asset gerekmedi.
- [x] **OGR-24:** Pazar ve divan düğmeleri açılınca işaretlenir. (Antigravity)
  - Ne: pazar (TUC) ve divan (CAS-07) HUD düğmeleri ilk kez etkin olunca kenarında bir kez yanıp sönen işaret ve tek satır.
  - Kabul: ilk açılışta işaret; girince kalkar. Test: iki kez tıklanmış düğmede işaret 0.
  - Bağımlılık: OGR-07. Boyut: S.
  - Dosya: yeni: `src/arayuz/koy_hud/yeni_dugme_isareti.gd`.
  - Asset: asset gerekmedi.

### 33.5 Kademeli açılan arayüz

- [ ] **OGR-25:** HUD katmanları gece sayısına göre açılır.
  - Ne: köy HUD'undaki ~45 panelin tümü ilk gece görünmez. `ilk_saat.json` her panelin dosya adına `gece_min` verir; panel o geceden önce ağaca eklenmez.
  - Kabul: gece 0 HUD'unda panel sayısı ≤ 6. Test: `tests/oto/koy_hud_kontrol.tscn` gece 0 ile çalıştırılır.
  - Bağımlılık: OGR-01. Boyut: M.
  - Dosya: yeni: `src/arayuz/koy_hud/hud_katmani.gd`; `src/arayuz/hud.gd` tek satır.
  - Asset: asset gerekmedi.
- [ ] **OGR-26:** Gizli panel, verisi oluşunca kendini açar.
  - Ne: `gece_min` dolmasa da ilgili sistem veri üretirse (örn. karantina, `karantina_paneli.gd`) panel açılır. Gizlilik oyuncudan bilgi saklamaz.
  - Kabul: karantina bayrağı açıkken panel gece 0'da bile görünür. Test: bayrak enjekte edilir, panel 1.
  - Bağımlılık: OGR-25. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/hud_katmani.gd`.
  - Asset: asset gerekmedi.
- [ ] **OGR-27:** Muhafız odası ilk teftişten sonra açılır.
  - Ne: `src/arayuz/muhafiz_odasi_ekrani.gd` düğmesi ilk sancak teftişi (`sancak_teftisi.gd`) ya da ilk yozlaşma kararından sonra görünür.
  - Kabul: iki tetikten önce düğme 0. Test: tetiksiz kayıt.
  - Bağımlılık: OGR-25. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/hud_katmani.gd`.
  - Asset: asset gerekmedi.
- [ ] **OGR-28:** Harita ilk kervandan sonra açılır.
  - Ne: `src/arayuz/harita_ekrani.gd` ilk kervan olayı (`data/olaylar/kervan.tres`, `koy.tres kervan_araligi 4`) ya da ilk haberciden sonra açılır.
  - Kabul: tetik öncesi harita düğmesi 0. Test: gece 3 anlık görüntüsü.
  - Bağımlılık: OGR-25. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/hud_katmani.gd`.
  - Asset: asset gerekmedi.
- [ ] **OGR-29:** Kademeli açılış ayarlardan kapatılabilir.
  - Ne: Bölüm 35'te "deneyimli oyuncu" anahtarı; açıkken bütün paneller ilk geceden görünür ve ipucu çıkmaz.
  - Kabul: anahtar açıkken gece 0 HUD tam. Test: iki anahtar durumunda panel sayısı.
  - Bağımlılık: AYR-12, OGR-25. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/hud_katmani.gd`.
  - Asset: asset gerekmedi.
- [ ] **OGR-30:** Katman sırası tester ikizinde doğrulanır.
  - Ne: TST-06 kayıt ikizi ile aynı tohumda iki açılışın panel açılış geceleri eşittir.
  - Kabul: iki koşunun `hud_katmani` günlüğü aynıdır. Test: `tests/oto/` yeni kontrol.
  - Bağımlılık: OGR-25. Boyut: S.
  - Dosya: yeni: `tests/oto/hud_katmani_kontrol.tscn`.
  - Asset: asset gerekmedi.

### 33.6 İlk başarısızlık ve kurtarma

- [ ] **OGR-31:** İlk kötü karar bir açıklama satırı alır.
  - Ne: oyuncunun ilk reddi ya da kabulü kötü sonuç verince (DYL-08 kararın dönüşü) sabah raporunda bir satır bağlantı kurar: "Üç gece önce kapıda …". Ders değil, hatırlatma.
  - Kabul: ilk olumsuz dönüşte satır bir kez. Test: dönüş olmayan kayıtta 0.
  - Bağımlılık: DYL-08. Boyut: S.
  - Dosya: `src/sistemler/ilk_saat.gd` tetik satırı.
  - Asset: asset gerekmedi.
- [x] **OGR-32:** Kıtlık eşiği ilk yaklaşmada görünür. (Antigravity)
  - Ne: ambar `ambar_yedek_gece` (oyun.tres = 1) altına ilk inince ipucu ve ambar göstergesinde renk; kıtlık sistemi (KRI) değişmez.
  - Kabul: ilk yaklaşmada bir kez. Test: bol ambarlı kayıtta 0.
  - Bağımlılık: OGR-20. Boyut: S.
  - Dosya: `src/sistemler/ilk_saat.gd` tetik satırı.
  - Asset: asset gerekmedi.
- [x] **OGR-33:** İlk saat içinde oyun bitmez. (Antigravity)
  - Ne: ilk altı gecede beş sondan (SYS-20) hiçbiri tetiklenemez; eşik koşulu `nihai_son.gd` tarafından okunur, `ilk_saat.json` `son_kilidi_gece` alanıyla ertelenir.
  - Kabul: gece < 6 iken son 0. Test: en kötü değerlerle gece 5 anlık görüntüsü.
  - Bağımlılık: SYS-20, OGR-01. Boyut: S.
  - Dosya: yeni: `src/sistemler/son_kilidi.gd`; `nihai_son.gd` tek satır.
  - Asset: asset gerekmedi.
- [x] **OGR-34:** İflas uyarısı ilk eksi kasada gelir. (Antigravity)
  - Ne: `src/koy/iflas_yoneticisi.gd` (`data/koy/iflas.json`) eşiğinden iki gece önce tek satır uyarı.
  - Kabul: uyarı iflas gecesinden önce; iflas metni değişmez. Test: zaman makinesiyle (`src/debug/zaman_makinesi.gd`) iki gece.
  - Bağımlılık: OGR-07. Boyut: S.
  - Dosya: `src/sistemler/ilk_saat.gd` tetik satırı.
  - Asset: asset gerekmedi.
- [ ] **OGR-35:** "Ne yapabilirim?" sayfası — tek sayfa, metin.
  - Ne: Esc menüsüne (`menu` eylemi) "Kapı usulü" sayfası eklenir: kapı, köy, zar, bar, heybe için beşer satır. Kaydırmalı tek sayfa, resim yok.
  - Kabul: sayfa 25 satırı geçmez, hepsi `metinler.csv`'den. Test: anahtar sayısı 25.
  - Bağımlılık: OGR-09. Boyut: S.
  - Dosya: yeni: `src/arayuz/kapi_usulu_sayfasi.gd`; `menu_ekrani.gd` tek satır.
  - Asset: asset gerekmedi.
- [ ] **OGR-36:** İlk saat sonu özet satırı.
  - Ne: altıncı gecenin raporunda bir satır: kaç kişi geldi, kaç kabul, kaç ret, köy nüfusu. `ana.gd:125 arayuz.son.istatistik` biçimi kullanılır.
  - Kabul: gece 5 raporunda satır 1, başka gecede 0. Test: anlık görüntü.
  - Bağımlılık: OGR-05. Boyut: S.
  - Dosya: `src/arayuz/gece_raporu_kisa.gd`.
  - Asset: asset gerekmedi.

### 33.7 Muhafızın geçmişi ve öğretinin kişiselleşmesi

- [x] **OGR-37:** Seçilen geçmiş ilk ipuçlarını değiştirir. (Antigravity)
  - Ne: ACL-06 muhafızın geçmişi (eski asker, kâtip, çiftçi vb.) seçildiğinde o alanın ipucu atlanır: kâtip beyan defteri ipucunu görmez, asker tansiyon ipucunu görmez.
  - Kabul: `ilk_saat.json` her ipucuda `atla_gecmis` listesi. Test: iki geçmişle ipucu kümesi farkı ≥ 1.
  - Bağımlılık: ACL-06, OGR-01. Boyut: S.
  - Dosya: `data/ogretici/ilk_saat.json`.
  - Asset: asset gerekmedi.
- [ ] **OGR-38:** Atlanan ipucu yerine geçmişin tek cümlesi.
  - Ne: atlanan ipucunun yerinde muhafızın geçmişine ait tek cümle durur (USLUP_REHBERI ses kartı tonunda). Bilgi vermez, kişilik verir.
  - Kabul: cümle `ogretici.gecmis.*` anahtarındadır; en çok 70 karakter. Test: tarama.
  - Bağımlılık: OGR-37, YAZ-03. Boyut: S.
  - Dosya: `data/metin/metinler.csv`.
  - Asset: asset gerekmedi.
- [ ] **OGR-39:** Eş ilk akşam sohbetinde bir şey öğretir.
  - Ne: ACL-03 / DYL-07 akşam sohbetinin ilk gecesinde eş, gün içinde kullanılmayan bir aracı tek cümleyle anar (heybe, beyan). Bu Söz motorunda bir bağlam sorgusu dalıdır (DIY-09).
  - Kabul: dal yalnız ilk üç gecede ve araç kullanılmadıysa açılır. Test: aracı kullanan kayıtta dal 0.
  - Bağımlılık: DYL-07, DIY-09. Boyut: S.
  - Dosya: eş söz dosyası (YAZ-05 pilot kapsamı) dal satırı.
  - Asset: asset gerekmedi.
- [ ] **OGR-40:** Ulak ikinci gece dönüp berat şartını hatırlatır.
  - Ne: ACL-04 ulağı ikinci gecenin sonunda tek satır haber bırakır: sancak beyi kapının defterini ister (SYS-20 sonlarından teftiş yoluna işaret).
  - Kabul: satır gece 1 sonunda bir kez. Test: anlık görüntü.
  - Bağımlılık: ACL-04. Boyut: S.
  - Dosya: `src/sistemler/ilk_saat.gd` tetik satırı; metin `metinler.csv`.
  - Asset: asset gerekmedi.
- [ ] **OGR-41:** Yeni oyun başlangıç özeti tek kadraj.
  - Ne: ACL-06 seçiminden sonra `bilgi_ekrani.gd` kadrajında üç satır: kimsin, köy nerede, kapı ne zaman açılır. Resim yok, metin koddan.
  - Kabul: kadraj bir girdiyle geçilir; süre sınırı yok. Test: anahtar sayısı 3.
  - Bağımlılık: ACL-06. Boyut: S.
  - Dosya: `src/arayuz/bilgi_ekrani.gd` çağrısı; metin `metinler.csv`.
  - Asset: asset gerekmedi.

### 33.8 Ölçüm — ilk saat gerçekten öğretiyor mu

- [ ] **OGR-42:** İlk saat ölçüm kancası.
  - Ne: TST-03 ölçüm kancalarına `ILKSAAT` eklenir: her ipucunun gösterildiği gece, oyuncunun ilgili aracı ilk kullandığı gece.
  - Kabul: kanca günlüğü JSON'dur; tester runner okur. Test: altı gecelik koşuda satır sayısı = ipucu sayısı.
  - Bağımlılık: OGR-07, TST-03. Boyut: S.
  - Dosya: yeni: `src/debug/ilk_saat_kancasi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OGR-43:** Yedi persona ilk saati geçer.
  - Ne: TST-07 personaları (`tools/python_test_runner.py`) ilk altı geceyi oynar; hiçbiri OGR-33 kilidi yüzünden değil, oyun yüzünden kaybetmemelidir.
  - Kabul: yedi koşuda son 0, ambar ≥ 0. Test: runner raporu.
  - Bağımlılık: OGR-33, TST-07. Boyut: S.
  - Dosya: `tools/python_test_runner.py` senaryo satırı.
  - Asset: asset gerekmedi.
- [ ] **OGR-44:** Kullanılmayan araç raporu.
  - Ne: ölçüm, altı gecede hiç kullanılmayan aracı (heybe, beyan, yemin, bakmak…) listeler. Tasarım bu listeye göre ipucu gecesini kaydırır; kod değişmez.
  - Kabul: rapor `docs/tester/` altında tablo. Test: tablo üretilir.
  - Bağımlılık: OGR-42. Boyut: S.
  - Dosya: `tools/python_test_runner.py` rapor satırı.
  - Asset: asset gerekmedi.
- [x] **OGR-45:** İpucu sayısı üst sınırı. (Antigravity)
  - Ne: ilk altı gecede gösterilen ipucu toplamı 20'yi geçmez (öneri). Geçerse liste kırpılır, önce en az kullanılan araç kalır.
  - Kabul: `ilk_saat.json` kavram sayısı ≤ 20. Test: sayım.
  - Bağımlılık: OGR-01. Boyut: S.
  - Dosya: `data/ogretici/ilk_saat.json`.
  - Asset: asset gerekmedi.
- [ ] **OGR-46:** İlk saat süresi ölçülür.
  - Ne: altı gecenin gerçek süresi (otomatik oyuncu, `tests/oto/otomatik_oyuncu.tscn`) ölçülür; hedef 45–75 dakika (öneri). Sapınca `gece_basina_gelen` değil, ipucu ve kademeli açılış gecesi oynar.
  - Kabul: ölçüm raporda. Test: runner süre satırı.
  - Bağımlılık: OGR-42. Boyut: S.
  - Dosya: `tools/python_test_runner.py`.
  - Asset: asset gerekmedi.

### 33.9 Yeniden oynayan oyuncu

- [ ] **OGR-47:** İkinci oyunda ipucu kapalıdır.
  - Ne: `user://ayarlar.cfg` içinde `ilk_oyun_bitti` anahtarı; bir kez altı gece geçildiyse yeni oyunda ipucu ve kademeli açılış kapalı başlar, Bölüm 35'ten açılabilir.
  - Kabul: anahtar `Ayarlar.VARSAYILAN`'a değil ayrı dosyaya yazılır (çekirdek dosya korunur). Test: iki açılış.
  - Bağımlılık: AYR-12. Boyut: S.
  - Dosya: yeni: `src/sistemler/oyuncu_izi.gd` (`user://oyuncu_izi.cfg`).
  - Asset: asset gerekmedi.
- [ ] **OGR-48:** Açılış kadrajı ikinci oyunda atlanır.
  - Ne: OGR-41 kadrajı `ilk_oyun_bitti` iken gösterilmez.
  - Kabul: ikinci oyunda kadraj 0. Test: iki açılış.
  - Bağımlılık: OGR-41, OGR-47. Boyut: S.
  - Dosya: `src/sistemler/oyuncu_izi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OGR-49:** Yeni mekanik (sürüm sonrası) tek ipucu alır.
  - Ne: sürüm güncellemesiyle gelen yeni sistem, deneyimli oyuncuya da bir kez ipucu verir; `ilk_saat.json` kavramında `surum_min` alanı.
  - Kabul: eski `oyuncu_izi` ile yeni sürümde yalnız yeni kavramın ipucu 1. Test: sürüm alanı değiştirilir.
  - Bağımlılık: OGR-47, KAY-04. Boyut: S.
  - Dosya: `data/ogretici/ilk_saat.json`.
  - Asset: asset gerekmedi.
- [ ] **OGR-50:** Zorluk seçimi ikinci oyunda açılır.
  - Ne: DEN-04 zorluk çarpanı (kolay/olağan/sıkı) ilk oyunda gösterilmez, olağan başlar; `ilk_oyun_bitti` ile yeni oyun ekranında görünür.
  - Kabul: ilk oyunda zorluk seçici 0. Test: iki açılış.
  - Bağımlılık: DEN-04, OGR-47, AYR-23, AYR-34. Boyut: S.
  - Dosya: `src/sistemler/oyuncu_izi.gd`; yeni oyun ekranı AYR-34.
  - Asset: asset gerekmedi.
- [ ] **OGR-51:** Devam eden kayıtta ipucu durumu kayıttan gelir.
  - Ne: "Devam" ile açılan kayıtta `ogretici.gorulen` kayıttan, `ilk_oyun_bitti` ayardan okunur; ikisi çelişirse kayıt kazanır.
  - Kabul: kayıt alanı dolu, ayar boş → ipucu kayıt kadar. Test: çapraz durum.
  - Bağımlılık: OGR-07, OGR-47. Boyut: S.
  - Dosya: `src/sistemler/ipucu_kaydi.gd`.
  - Asset: asset gerekmedi.

### 33.10 Sınırlar ve kapanış

- [x] **OGR-52:** (Claude) Öğretici ayrı sahne açmaz.
  - Ne: `tutorial`, `ogretici_sahne` adlı sahne yoktur; her şey canlı oyunda olur.
  - Kabul: `rg -l 'ogretici_sahne|tutorial' src` → 0. Test: tarama.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: tarama `tools/godot_script_taramasi.py` tek kural.
  - Asset: asset gerekmedi.
- [x] **OGR-53:** Çekirdek dosyalarda ipucu metni yoktur. (Antigravity)
  - Ne: `ana.gd`, `koy_ekrani.gd`, `hud.gd`, `kapi_ekrani.gd` içinde `ogretici.` anahtarı geçmez; yalnız adaptör çağrısı vardır.
  - Kabul: dört dosyada `ogretici.` 0. Test: tarama.
  - Bağımlılık: OGR-08. Boyut: S.
  - Dosya: `tools/godot_script_taramasi.py`.
  - Asset: asset gerekmedi.
- [ ] **OGR-54:** İpucu oyun durumunu değiştirmez.
  - Ne: ipucu gösterimi RNG, kayıt sayaçları, bar ve kasaya dokunmaz. TST-06 ikiz koşusu ipucu açık/kapalı iken aynı sonucu verir.
  - Kabul: iki koşunun durum anlık görüntüsü (`src/debug/durum_anlik_goruntusu.gd`) eşittir. Test: ikiz.
  - Bağımlılık: OGR-25, TST-06. Boyut: S.
  - Dosya: yeni: `tests/oto/ipucu_ikiz_kontrol.tscn`.
  - Asset: asset gerekmedi.
- [x] **OGR-55:** Admin HUD oyuncuya öğretilmez. (Antigravity)
  - Ne: F1 / `~` (`src/debug/admin_hud.gd`) hiçbir ipucunda anılmaz; sürüm derlemesinde kapalıdır (Bölüm 42).
  - Kabul: `ogretici.` metinlerinde "F1" 0. Test: tarama.
  - Bağımlılık: SRM-05. Boyut: S.
  - Dosya: `tools/metin_dogrula.py` tek kural.
  - Asset: asset gerekmedi.
- [x] **OGR-56:** (Claude) İlk saat metinleri İngilizce sütuna hazır anahtarlardır.
  - Ne: `ogretici.` anahtarları Bölüm 46 ikinci sütun kuralına uyar; metin içinde tuş adı ve sayı yer tutucuyla (`%s`, `%d`) gelir.
  - Kabul: sabit tuş adı içeren `ogretici.` satırı 0. Test: tarama.
  - Bağımlılık: YER-02. Boyut: S.
  - Dosya: `data/metin/metinler.csv`.
  - Asset: asset gerekmedi.
- [ ] **OGR-57:** Kapanış testi — altı gece tek koşu.
  - Ne: tek otomatik koşu: ipucu sırası OGR-01 listesine eşit, panel açılış geceleri OGR-25'e eşit, son 0, ikinci açılışta ipucu 0.
  - Kabul: dört iddia tek testte. Test: `tests/oto/ilk_saat_kontrol.tscn`.
  - Bağımlılık: OGR-01…56. Boyut: S.
  - Dosya: yeni: `tests/oto/ilk_saat_kontrol.tscn`, `tests/oto/ilk_saat_kontrol.gd`.
  - Asset: asset gerekmedi.

Alt başlıklarda madde sayısı altı ile yedi arasındadır; onuncu madde her yerde bir öncekinin kabulünü tekrar edeceği için konmadı. Toplam 57 madde.


---

## BÖLÜM 34: Ana hikâye omurgası ve perde yapısı


Faz 5 (DNY ile birlikte; KOP-07 ve YAZ-06 metinlerinden sonra). Zemin, kodda duran iki perde ve beş sondur:

- Perde geçişi SYS-19: `src/koy/perde_gecisi.gd` — nüfus `agalik_nufus` (18, `data/ayarlar/oyun.tres oturma_esigi`) olunca "Köy oturdu", 2. perde kendi sayacını tutar, `perde2_hedef_gece` (12) dolunca `SON_ZAFER`. Perde 2'de gelen sayısı `perde2_gece_basina_gelen` (2).
- Beş son SYS-20: `src/sistemler/nihai_son.gd` — zafer beş sona ayrılır: `tekfur_haraccisi`, `ertugrul_obasi`, `beyin_uc_koyu`, `ahi_kasabasi`, `uc_tutundu`; kayıp sonları `isyan`, `tekfur`, `halk_kirildi`, `azil`, `idam` korunur. Göstergeler huzur/adalet/refah/güvenlik/nüfus/yozlaşma 0–100; eşikler `data/nihai_sonlar.json`. Epilog `muhafiz_epilogu.gd`, sunum `src/arayuz/muhafiz_epilogu_sunumu.gd`, kadraj `bilgi_ekrani.gd`.
- Dış dünya hatları: Moğol öncüsü `mogol_oncusu.gd`, tekfur haraç heyeti `tekfur_harac_heyeti.gd`, oba ittifakı `oba_ittifaki.gd`, sancak fermanı `sancak_asker_talebi.gd` (gece 8, aralık 12), haberci ağı `haberci_agi.gd` (HAR-09), olaylar `data/olaylar/` (ertugrul_haberi, nogay_haber, mogol_duman, tekfur_elcisi, bey_daveti, aydogdu_oba, miraen_cavus, sorhan_damga, thessra_afyon).

Bu bölüm perdeyi, sonu ve dış hatları yeniden kurmaz. Onları bir omurgaya dizer: oyuncu neyin ne zaman gelmekte olduğunu hisseder, her sonun yolu önceden okunur, her hat bir yüzle gelir. Mevsim izi Bölüm 30'dadır (YIL), buraya girmez. Dünya zaman çizelgesi DNY-01'dedir; bu bölüm ona perde ve son bağlar. Metinlerin ağzı KOP-07'dedir; burada metin yazılmaz.

Kimlikler OMR-01 … OMR-55. Kalp puanı, romans, ikinci harita, seslendirme yok. Asset üretilmez. Yeni dosya + ince adaptör; çekirdek dosya (`oturum.gd`, `koy_yonetim_sahnesi.gd`) değişmez. Bitince `[x]` ve ajan adı.

**Madde biçimi:** Ne, Kabul, Bağımlılık + Boyut, Dosya, Asset.

---

### 34.1 Omurga belgesi — üç perde, bir kapı

- [x] **OMR-01:** (Claude) Omurga tek belgede durur.
  - Ne: perde 1 (kapı açılır, köy kurulur, 18 nüfus), perde 2 (ağalık, 12 gece, dış baskı) ve kapanış (beş son) tek belgede; her perdenin sorusu, baskısı ve kapanış koşulu kod referansıyla yazılır.
  - Kabul: belgede `perde_gecisi.gd`, `nihai_son.gd`, `oyun.tres` alanları adlarıyla geçer; kodda olmayan koşul yoktur. Test: insan okuması + referans taraması.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: yeni: `design/omurga.md` (oyun deposunda, uygulama fazında).
  - Asset: asset gerekmedi.
- [x] **OMR-02:** Perde 1'in üç dönemi. (Antigravity)
  - Ne: perde 1 üç döneme bölünür: kuruluş (nüfus < 8), yerleşme (8–13), oturma (14–18). Dönem, mevcut nüfustan türetilir; yeni sayaç yoktur.
  - Kabul: `donem(y)` fonksiyonu nüfustan üç değer döner; kayda yazılmaz. Test: üç nüfus değeri.
  - Bağımlılık: OMR-01. Boyut: S.
  - Dosya: yeni: `src/sistemler/omurga.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-03:** Dönem, gelen kadroyu süzer.
  - Ne: `karakter_kadrosu.gd uygunlar(gece)` çağrısına dönem bilgisi eklenir: kuruluşta aile ve zanaatkâr ağırlıklı, oturmada tüccar, heyet ve tehdit. Karar matrisi (KOP-10) değişmez, yalnız aday havuzu daralır.
  - Kabul: `data/omurga.json` içinde dönem → sınıf ağırlığı; kuruluşta asker ağırlığı ≤ 0.1. Test: 100 gece simülasyon dağılımı.
  - Bağımlılık: OMR-02, KOP-10. Boyut: M.
  - Dosya: yeni: `src/sistemler/omurga_suzgeci.gd`; `karakter_kadrosu.gd` çağıran tarafa tek satır (çekirdek değil).
  - Asset: asset gerekmedi.
- [x] **OMR-04:** Perde 2'nin üç dalgası. (Antigravity)
  - Ne: 12 gecelik perde 2 üç dalgaya bölünür (4+4+4): baskı gelir, baskı sıkışır, kapanış. Dalga `perde_gecisi.gece(y)` değerinden türetilir.
  - Kabul: `dalga(y)` 1/2/3 döner; `perde2_hedef_gece` değişince dalga sınırları oranla kayar. Test: hedef 12 ve 15'te sınırlar.
  - Bağımlılık: OMR-01. Boyut: S.
  - Dosya: `src/sistemler/omurga.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-05:** Dış hatlar dalgaya bağlanır.
  - Ne: Moğol öncüsü, tekfur heyeti, oba ittifakı ve ferman tetikleri dalga numarasını okur; dalga 1'de yalnız haber, dalga 2'de talep, dalga 3'te sonuç. Hatların kendi aralığı (`harac_araligi`, ferman 12) korunur, dalga yalnız ön koşuldur.
  - Kabul: dalga 1'de tekfur talebi 0, haberi ≥ 1. Test: zaman makinesiyle üç dalga.
  - Bağımlılık: OMR-04, HAR-09. Boyut: M.
  - Dosya: yeni: `src/sistemler/dis_hat_kapisi.gd`; dört hat dosyasına birer satır.
  - Asset: asset gerekmedi.
- [x] **OMR-06:** Omurga kayda yazmaz. (Antigravity)
  - Ne: dönem ve dalga türetilmiş değerdir; kayıt alanı yoktur. Eski kayıt açılınca aynı dönem hesaplanır.
  - Kabul: `omurga.gd` içinde `kaydet/yukle` yoktur. Test: tarama.
  - Bağımlılık: OMR-02, OMR-04. Boyut: S.
  - Dosya: `src/sistemler/omurga.gd`.
  - Asset: asset gerekmedi.

### 34.2 Perde geçişi sahnesi

- [ ] **OMR-07:** "Köy oturdu" kadrajı tek ağızdan.
  - Ne: `perde_gecisi.olay_metin` sabit Türkçe metni (`"Köy oturdu · 2. perde başladı…"`) `metinler.csv` anahtarına taşınır; metin KOP-07 ağzıyla yeniden yazılır. Fonksiyon imzası değişmez.
  - Kabul: `perde_gecisi.gd` içinde sabit cümle 0; anahtar `anlati.perde.basladi`. Test: tarama + ekran.
  - Bağımlılık: KOP-07. Boyut: S.
  - Dosya: yeni: `src/sistemler/perde_metni.gd`; `perde_gecisi.gd` tek satır.
  - Asset: asset gerekmedi.
- [ ] **OMR-08:** Geçiş gecesinde kapı kapalıdır.
  - Ne: "Köy oturdu" gecesi kapıya kimse gelmez (KAP-16 boş gün zorlanır); oyuncu köyde ağalık kararını verir.
  - Kabul: geçiş gecesi `gece_basina_gelen` 0. Test: nüfus 18'e enjekte, o gece kuyruk boş.
  - Bağımlılık: KAP-16. Boyut: S.
  - Dosya: yeni: `src/sistemler/gecis_gecesi.gd`; kuyruk üreticisine tek satır.
  - Asset: asset gerekmedi.
- [ ] **OMR-09:** Geçişte eş ve çınar konuşur.
  - Ne: geçiş akşamı eş (DYL-07) ve çınar meclisi (MCL) "ağalık" konusunu alır; iki ayrı sahne değil, mevcut akşam sohbeti ve meclis dalıdır.
  - Kabul: Söz dosyasında `perde_gecisi` bağlam anahtarı (DIY-09). Test: bağlam açıkken dal 1.
  - Bağımlılık: DYL-07, MCL-01, DIY-09. Boyut: S.
  - Dosya: eş ve meclis söz dosyaları (YAZ-06 kapsamı) dal satırı.
  - Asset: asset gerekmedi.
- [ ] **OMR-10:** Geçiş kadrajında köyün özeti.
  - Ne: `bilgi_ekrani.gd` kadrajında perde 1 özeti: gün, gelen, kabul, ret, ölü, en çok anılan karar (Bölüm 39 defterinden). Resim yok.
  - Kabul: altı satır, hepsi kayıttan. Test: anlık görüntü.
  - Bağımlılık: HFZ-01. Boyut: S.
  - Dosya: yeni: `src/arayuz/perde_ozeti.gd`.
  - Asset: asset gerekmedi.
- [x] **OMR-11:** Geçiş sonrası ilk gün ipucu almaz. (Antigravity)
  - Ne: perde 2'nin ilk günü Bölüm 33 ipucu sistemi susar; oyuncu deneyimlidir.
  - Kabul: `ilk_saat.json` kavramlarının hiçbiri perde 2'de tetiklenmez. Test: geçiş sonrası altı gece ipucu 0.
  - Bağımlılık: OGR-01. Boyut: S.
  - Dosya: `src/sistemler/ilk_saat.gd` tek koşul.
  - Asset: asset gerekmedi.
- [x] **OMR-12:** (Claude) Geçiş geri alınmaz, kayıt geçişi korur.
  - Ne: `perde_gecisi.yukle` legacy davranışı (alan yoksa sonraki gece başlar) belgelenir ve test edilir; omurga buna dokunmaz.
  - Kabul: `tests/unit/kvr/` mevcut perde testi referansla belgede. Test: var olan test geçer.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `design/omurga.md` referans satırı.
  - Asset: asset gerekmedi.

### 34.3 Beş sonun yolu görünür olur

- [x] **OMR-13:** Son göstergeleri oda ekranında okunur. (Antigravity)
  - Ne: `nihai_son.gostergeler(o)` altı değeri perde 2'de muhafız odası terazisi panelinde (`oda_terazisi_paneli.gd` yanında) görünür. Perde 1'de gizlidir.
  - Kabul: perde 2'de altı satır; sayı yerine kademe sözcüğü (`_kademe`: düşük/orta/yüksek). Test: anlık görüntü.
  - Bağımlılık: OMR-04. Boyut: S.
  - Dosya: yeni: `src/arayuz/oda_gidisat_paneli.gd`; `muhafiz_odasi_ekrani.gd` tek satır.
  - Asset: asset gerekmedi.
- [x] **OMR-14:** Hangi sona yaklaşıldığı tek cümleyle söylenir. (Antigravity)
  - Ne: `nihai_son.son(o, &"zafer")` sonucu perde 2 dalga 2'den itibaren oda panelinde "şu an gidişat: …" cümlesiyle görünür. Sayı yok, ad var.
  - Kabul: cümle `nihai_sonlar.json sonlar[n].baslik` ile aynı adı taşır. Test: beş son için beş cümle.
  - Bağımlılık: OMR-13. Boyut: S.
  - Dosya: `src/arayuz/oda_gidisat_paneli.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-15:** Her sonun bir yüzü vardır.
  - Ne: beş sonun her biri bir adlı karakterle anılır: tekfur haraççısı → tekfur elçisi (`tekfur_elcisi.tres`), Ertuğrul obası → Aydoğdu (`aydogdu_oba.tres`), beyin uç köyü → ulak (ACL-04), ahi kasabası → ahi (`ahi_haber.tres`), uç tutundu → eş. Yüz, dalga 2'de kapıya ya da köye gelir ve o sonun koşulunu kendi ağzından söyler (Söz motoru).
  - Kabul: beş yüz için beş Söz dosyası dalı; koşul metni `nihai_sonlar.json esik` değerleriyle çelişmez. Test: yazım hattı denetimi (KLT).
  - Bağımlılık: OMR-05, YAZ-06. Boyut: M.
  - Dosya: Söz dosyaları; `data/omurga.json` yüz eşlemesi.
  - Asset: asset gerekmedi.
- [ ] **OMR-16:** Kayıp sonları erken uyarır.
  - Ne: `isyan`, `tekfur`, `halk_kirildi`, `azil`, `idam` sonlarının her birinin eşiğine iki gece kala haberci ağı (HAR-09) bir satır düşürür. Eşik değişmez.
  - Kabul: her kayıp sonu için bir uyarı anahtarı; uyarı eşikten önce. Test: beş kayıp yolu zaman makinesiyle.
  - Bağımlılık: HAR-09. Boyut: M.
  - Dosya: yeni: `src/sistemler/son_uyarisi.gd`; `haberci_agi.gd` tek satır.
  - Asset: asset gerekmedi.
- [ ] **OMR-17:** Sonun seçildiği an kayda yazılır.
  - Ne: `son_metni` dönüşündeki `nihai` alanı oyun kaydına ve Bölüm 39 defterine yazılır; epilog sonradan yeniden okunabilir.
  - Kabul: kayıt alanı `son.nihai`; eski kayıtta yoksa boş. Test: KAY zinciri.
  - Bağımlılık: KAY-04, HFZ-01. Boyut: S.
  - Dosya: yeni: `src/sistemler/son_kaydi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-18:** Beş son beş farklı kadraj değil, bir kadraj beş metindir.
  - Ne: `muhafiz_epilogu_sunumu.gd` tek kadraj kalır; görsel çeşitleme yok. Metin KOP-07 ağzıyla.
  - Kabul: sunum dosyasında son başına görsel dalı 0. Test: tarama.
  - Bağımlılık: KOP-07. Boyut: S.
  - Dosya: `src/arayuz/muhafiz_epilogu_sunumu.gd` (değişmez; madde sınır koyar).
  - Asset: asset gerekmedi.

### 34.4 Dış hatların yüzleri

- [ ] **OMR-19:** Moğol hattı üç adımdır: duman, haber, öncü.
  - Ne: `mogol_duman.tres` (olay) → `nogay_haber.tres` → `mogol_oncusu.gd`; üç adım dalga 1/2/3'e bağlanır. Öncü kapıya gelirse Söz motoru sahnesi (KOP-02 heyet biçimi).
  - Kabul: üç adım sırası bozulmaz; adım atlanırsa sonraki tetiklenmez. Test: dalga sırası.
  - Bağımlılık: OMR-05. Boyut: S.
  - Dosya: `src/sistemler/dis_hat_kapisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-20:** Tekfur hattı: elçi, haraç, heyet.
  - Ne: `tekfur_elcisi.tres` → `tekfur_harac_heyeti.gd` → `tekfur_heyeti_paneli.gd`. Elçi kapıda konuşur (KOP-02); haraç kararı divan değil muhafızındır (CAS-07 dışı).
  - Kabul: elçi gelmeden haraç talebi 0. Test: dalga sırası.
  - Bağımlılık: OMR-05, KOP-02. Boyut: S.
  - Dosya: `src/sistemler/dis_hat_kapisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-21:** Oba hattı: Aydoğdu iki kez gelir.
  - Ne: `aydogdu_oba.tres` ve `oba_ittifaki.gd`; Aydoğdu ilk gelişte tanışır, ikincide ittifak ister. İki geliş arası ≥ 4 gece (öneri). Kişi hafızası (DIY-11) ikinci gelişi tanır.
  - Kabul: ikinci gelişte `durumlar[id].ziyaret` ≥ 1. Test: iki ziyaret.
  - Bağımlılık: DIY-11, OMR-05. Boyut: S.
  - Dosya: `src/sistemler/dis_hat_kapisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-22:** Sancak hattı: ulak döner.
  - Ne: ACL-04 ulağı `sancak_asker_talebi.gd` fermanını (gece 8) ve `sancak_teftisi.gd` teftişini kapıda bizzat getirir; yazılı haber yerine yüz.
  - Kabul: ferman gecesi ulak kuyrukta 1. Test: gece 8 kuyruğu.
  - Bağımlılık: ACL-04, OMR-05. Boyut: S.
  - Dosya: `src/sistemler/dis_hat_kapisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-23:** Ahi hattı: tezgâhtan kasabaya.
  - Ne: `ahi_haber.tres` ve `ahi_kasabasi` sonu; ahi, TEZ (Bölüm 29) teslimlerini ve refah/adalet göstergesini okur, dalga 2'de köye gelir.
  - Kabul: TEZ teslim sayısı ≥ 1 değilse ahi gelmez. Test: iki kayıt.
  - Bağımlılık: TEZ-08, OMR-05. Boyut: S.
  - Dosya: `src/sistemler/dis_hat_kapisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-24:** Hatlar aynı gece çakışmaz.
  - Ne: bir gecede en çok bir dış hat yüzü gelir; öncelik sırası `data/omurga.json`'da (sancak > tekfur > Moğol > oba > ahi).
  - Kabul: aynı gece iki hat yüzü 0. Test: hepsi uygunken bir gece. Ek şart: Dış hat yüzü çınarın altında durmaz; mecliste yalnız adı anılır, modeli kapıda kalır.
  - Bağımlılık: OMR-19…23. Boyut: S.
  - Dosya: `src/sistemler/dis_hat_kapisi.gd`.
  - Asset: asset gerekmedi.

### 34.5 Oyuncunun kararı omurgayı büker

- [ ] **OMR-25:** Üç karar üç hattı kapatır.
  - Ne: tekfur elçisini reddetmek tekfur hattını sertleştirir, Moğol öncüsünü kabul etmek haraççı yolunu açar, ulağı aldatmak sancak hattını kapatır. Bu etkiler mevcut bar ve bayraklarla olur, yeni sayaç yok.
  - Kabul: üç karar → üç bayrak; bayrak `atil_bayraklar.json` zincirine uyar. Test: üç kayıt.
  - Bağımlılık: OMR-19…22. Boyut: M.
  - Dosya: `src/sistemler/dis_hat_kapisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-26:** Kapatılan hat sona yansır.
  - Ne: hat kapanınca `nihai_son.son` öncelik sırası değişmez ama koşul sağlanamaz hale gelir; oyuncu oda panelinde (OMR-14) gidişat değişimini görür.
  - Kabul: hat kapatıldıktan sonra panel cümlesi değişir. Test: önce/sonra.
  - Bağımlılık: OMR-14, OMR-25. Boyut: S.
  - Dosya: `src/arayuz/oda_gidisat_paneli.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-27:** Divan hükmü omurgaya dokunur.
  - Ne: CAS-07 infaz ve sürgün sayısı adalet göstergesini (`y.adalet`) etkiler; bu zaten koddadır. Madde, bu etkinin SAB (Bölüm 28) sabah satırında anılmasını ister.
  - Kabul: SAB-01 satırında adalet değişimi tek kelime. Test: hüküm sonrası satır.
  - Bağımlılık: SAB-01. Boyut: S.
  - Dosya: `src/koy/sabah_defteri.gd` tek alan.
  - Asset: asset gerekmedi.
- [x] **OMR-28:** Yozlaşma eşiği omurgada görünür. (Antigravity)
  - Ne: `nihai_sonlar.json esik.yozlasma` eşiğine üç kademe kala oda vicdan paneli (`oda_vicdan_paneli.gd`) bir satır düşürür.
  - Kabul: uyarı eşikten önce; eşik değişmez. Test: terazi enjeksiyonu (`stat_enjektoru.gd`).
  - Bağımlılık: ODA-12. Boyut: S.
  - Dosya: yeni: `src/arayuz/oda_yozlasma_uyarisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-29:** Verilen söz omurgaya girer.
  - Ne: DYL-05 verilen sözlerden dış hat yüzlerine verilenler (`"Aydoğdu'ya söz"`) `data/omurga.json`'da hat koşulu olarak okunur; tutulmayan söz hattı kapatır.
  - Kabul: söz tutulmadı → ilgili hat bayrağı. Test: iki kayıt.
  - Bağımlılık: DYL-05, OMR-25. Boyut: S.
  - Dosya: `src/sistemler/dis_hat_kapisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-30:** Omurga oyuncuyu zorlamaz.
  - Ne: hiçbir hat zorunlu değildir; hepsi reddedilirse `uc_tutundu` yolu açık kalır. Bu, `nihai_son.son` son satırının (varsayılan dönüş) belgelenmesidir.
  - Kabul: dört hat kapalı, yozlaşma düşük → son `uc_tutundu`. Test: kayıt.
  - Bağımlılık: OMR-25. Boyut: S.
  - Dosya: `design/omurga.md`.
  - Asset: asset gerekmedi.

### 34.6 Zamanlama ve tempo

- [ ] **OMR-31:** Perde 1 hedef süresi ölçülür.
  - Ne: 18 nüfusa ulaşma gecesi otomatik oyuncuyla ölçülür; hedef 20–30 gece (öneri). Sapınca `gece_basina_gelen` değil kabul oranı ve omurga süzgeci (OMR-03) oynar.
  - Kabul: ölçüm raporda, DEN tablosuyla paylaşılır. Test: runner.
  - Bağımlılık: DEN-05, OMR-03. Boyut: S.
  - Dosya: `tools/python_test_runner.py` satırı.
  - Asset: asset gerekmedi.
- [ ] **OMR-32:** Dalga başına en az bir yüz.
  - Ne: perde 2'nin her dalgasında en az bir dış hat yüzü gelir; hiçbiri uygun değilse ulak gelir.
  - Kabul: üç dalgada yüz sayısı ≥ 3. Test: hatları kapatılmış kayıt.
  - Bağımlılık: OMR-24. Boyut: S.
  - Dosya: `src/sistemler/dis_hat_kapisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-33:** Boş gün oranı perdeye göre değişir.
  - Ne: KAP-16 boş gün olasılığı perde 1 oturma döneminde artar, perde 2 dalga 3'te sıfırlanır. Değer `data/omurga.json`'dadır.
  - Kabul: dalga 3'te boş gün 0. Test: 12 gece.
  - Bağımlılık: KAP-16, OMR-04. Boyut: S.
  - Dosya: `data/omurga.json`; KAP-16 okuyucusuna tek satır.
  - Asset: asset gerekmedi.
- [x] **OMR-34:** Mevsim omurgayı bağlamaz. (Antigravity)
  - Ne: perde geçişi mevsime bağlı değildir (Bölüm 30 ayrı). Madde yalnız sınır koyar: `omurga.gd` `takvim.gd`'yi okumaz.
  - Kabul: `omurga.gd` içinde `Takvim` 0. Test: tarama.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `src/sistemler/omurga.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-35:** Tempo ölçümü ikizle doğrulanır.
  - Ne: aynı tohumla iki koşuda dönem/dalga geçiş geceleri eşittir.
  - Kabul: iki günlük eşit. Test: TST-06 ikizi.
  - Bağımlılık: TST-06. Boyut: S.
  - Dosya: yeni: `tests/oto/omurga_ikiz_kontrol.tscn`.
  - Asset: asset gerekmedi.

### 34.7 Haberci ağı omurgaya bağlanır

- [ ] **OMR-36:** Haber dalgayı önceler.
  - Ne: `haberci_agi.gd` her dış hat yüzünden 1–2 gece önce yazılı haber düşürür (kaynaklar `data/haberci_agi.json kaynaklar`). Yüz gelmeden haber gelir.
  - Kabul: yüz gecesi − haber gecesi ∈ {1, 2}. Test: dört hat.
  - Bağımlılık: OMR-05, HAR-09. Boyut: S.
  - Dosya: `src/sistemler/dis_hat_kapisi.gd` → `haberci_agi.gd` tek satır.
  - Asset: asset gerekmedi.
- [ ] **OMR-37:** Haber önce insandan duyulur (DNY-02 ile aynı kural).
  - Ne: haber kapıdaki bir kişinin ağzından da gelebilir (DIY-13 dedikodu); yazılı haber yalnız kimse söylemediyse düşer.
  - Kabul: bir ziyaretçi haberi söylediyse yazılı satır 0. Test: iki kayıt.
  - Bağımlılık: DNY-02, DIY-13. Boyut: S.
  - Dosya: `src/sistemler/dis_hat_kapisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-38:** Haber defteri Bölüm 39'a yazar.
  - Ne: haberci ağının `bekleyen` listesi hafıza defterinin "Haber" sayfasına geçer; `azami_metin` sınırı korunur.
  - Kabul: defter sayfası ile `haberci_agi.oku` listesi eşit. Test: karşılaştırma.
  - Bağımlılık: HFZ-01. Boyut: S.
  - Dosya: `src/arayuz/hafiza_defteri.gd` sayfa adaptörü.
  - Asset: asset gerekmedi.
- [ ] **OMR-39:** Sahte haber hat kapatmaz.
  - Ne: DIY-13 dedikodusu yanlış olabilir; omurga yalnız `haberci_agi` kaynaklı doğrulanmış haberi okur. Oyuncu farkı Bölüm 37'de görür.
  - Kabul: dedikodu bayrağı dış hat kapısını tetiklemez. Test: sahte dedikodu enjeksiyonu.
  - Bağımlılık: SOY-01. Boyut: S.
  - Dosya: `src/sistemler/dis_hat_kapisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-40:** Haber metni KOP-07 ağzındadır.
  - Ne: `mogol_oncusu.olay_metin` ve benzeri sabit metinler `metinler.csv`'ye taşınır; ağız aynı yazardadır. İmzalar değişmez.
  - Kabul: dört hat dosyasında sabit Türkçe cümle 0. Test: tarama.
  - Bağımlılık: KOP-07, OMR-07. Boyut: M.
  - Dosya: yeni: `src/sistemler/hat_metni.gd`; dört dosyaya birer satır.
  - Asset: asset gerekmedi.

### 34.8 Omurga ve köy sistemleri

- [ ] **OMR-41:** Krizler dalgaya göre sıklaşır.
  - Ne: KRI kriz tetik olasılığı (`data/koy/kriz_kenetlenmesi.json` ve ilgili) perde 2 dalga 2'de çarpanla artar; çarpan DEN tablosundadır.
  - Kabul: `denge.json` içinde `kriz_dalga_carpani`. Test: DEN-01 tablosu.
  - Bağımlılık: DEN-01, OMR-04. Boyut: S.
  - Dosya: `data/ayarlar/denge.json`.
  - Asset: asset gerekmedi.
- [ ] **OMR-42:** Nüfus 18 öncesi savaş yok.
  - Ne: BUG-18 tehdit alışma süresine ek olarak kurt baskını dışındaki saldırı hatları (çete, pusucu) oturma dönemine (nüfus ≥ 14) kadar gelmez.
  - Kabul: nüfus < 14 iken çete 0. Test: enjekte nüfus.
  - Bağımlılık: BUG-18, OMR-02. Boyut: S.
  - Dosya: `src/sistemler/omurga_suzgeci.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-43:** Perde 2'de ambar baskısı artar.
  - Ne: perde 2 gelen sayısı düşer (2) ama hane büyür; tüketim `tuketim_dengesi.json` değişmez, köy olayları (KRI) sıklaşır (OMR-41). Madde bu ilişkiyi DEN raporunda ölçer.
  - Kabul: perde 2 ortalama ambar eğimi raporda. Test: runner.
  - Bağımlılık: DEN-05. Boyut: S.
  - Dosya: `tools/python_test_runner.py`.
  - Asset: asset gerekmedi.
- [ ] **OMR-44:** Çınar meclisi perde 2'de her hafta toplanır.
  - Ne: MCL-05 "her gece açılmaz" kuralına perde 2 istisnası: `takvim.hafta_basi` gecelerinde meclis açılır ve dış hat konusu konuşulur.
  - Kabul: perde 2 hafta başı meclis 1. Test: 12 gece. Ek şart: Aynı gecede köy şikâyeti ile dış hat konusu birlikte açılmaz; dış hat varsa konuşulan konu odur.
  - Bağımlılık: MCL-05, OMR-04. Boyut: S.
  - Dosya: MCL-05 dosyasına tek koşul.
  - Asset: asset gerekmedi.
- [ ] **OMR-45:** Nöbet devri perde 2'de zorunludur.
  - Ne: NBT (Bölüm 26) nöbetçi atanmadan perde 2 gecesi geçmez; boş direk (NBT-08) perde 2'de bir uyarı satırı alır.
  - Kabul: perde 2 boş direk gecesinde uyarı 1. Test: kayıt.
  - Bağımlılık: NBT-08. Boyut: S.
  - Dosya: NBT-08 dosyasına tek satır.
  - Asset: asset gerekmedi.

### 34.9 Yeniden oynanabilirlik

- [x] **OMR-46:** (Claude) Beş son beş farklı ilk aile değildir.
  - Ne: açılış (ACL-04) sabittir; omurga dallanması oyuncunun kararlarındadır. Madde sınır koyar: `omurga.json` açılışı okumaz.
  - Kabul: tarama. Test: tarama.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `design/omurga.md`.
  - Asset: asset gerekmedi.
- [ ] **OMR-47:** Alınan son kaydı ikinci oyunda hatırlanır.
  - Ne: `oyuncu_izi.cfg` (OGR-47) içine alınan sonlar yazılır; yeni oyun ekranında "daha önce: …" satırı. Başarım değil, iz.
  - Kabul: beş sondan alınanlar listelenir. Test: iki oyun.
  - Bağımlılık: OGR-47, OMR-17. Boyut: S.
  - Dosya: `src/sistemler/oyuncu_izi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-48:** Alınmamış sona ipucu, yol tarifi değil.
  - Ne: ikinci oyunda oda gidişat paneli (OMR-14) alınmamış sonları soluk gösterir; koşul yazmaz.
  - Kabul: panelde alınmamış son adı soluk, koşul metni 0. Test: anlık görüntü.
  - Bağımlılık: OMR-47. Boyut: S.
  - Dosya: `src/arayuz/oda_gidisat_paneli.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-49:** Muhafızın geçmişi hat yüzlerinin ilk cümlesini değiştirir.
  - Ne: ACL-06 geçmişine göre ulak, elçi ve Aydoğdu ilk selamı farklı verir (DIY-04 selam). Beş yüz × geçmiş sayısı kadar selam satırı.
  - Kabul: iki geçmişle selam farkı ≥ 1. Test: Söz dosyası.
  - Bağımlılık: ACL-06, DIY-04. Boyut: S.
  - Dosya: Söz dosyaları.
  - Asset: asset gerekmedi.
- [ ] **OMR-50:** Tohum ve omurga.
  - Ne: oyun tohumu (RNG) hat yüzlerinin geliş gecesini dalga içinde kaydırır; dalga dışına çıkaramaz.
  - Kabul: 20 tohumda yüz gecesi dalga sınırı içinde. Test: runner.
  - Bağımlılık: OMR-05. Boyut: S.
  - Dosya: `tools/python_test_runner.py`.
  - Asset: asset gerekmedi.

### 34.10 Sınırlar ve kapanış

- [x] **OMR-51:** (Claude) Üçüncü perde yoktur.
  - Ne: `perde2_hedef_gece` dolunca oyun biter; omurga üçüncü perde, ikinci harita veya yeni son açmaz.
  - Kabul: `nihai_sonlar.json sonlar` sayısı sabit (5 + kayıp sonları). Test: sayım.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `design/omurga.md`.
  - Asset: asset gerekmedi.
- [x] **OMR-52:** (Claude) Çekirdek imzalar değişmez.
  - Ne: `perde_gecisi` statik fonksiyonları, `nihai_son.son/son_metni/gostergeler`, `oturum_bitti(son)` imzaları aynıdır.
  - Kabul: `tools/api_sozlesmesi.py` baseline farkı 0. Test: araç.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `tools/api_sozlesmesi_baseline.json`.
  - Asset: asset gerekmedi.
- [ ] **OMR-53:** Omurga verisi tek dosyadır.
  - Ne: dönem eşikleri, dalga sınırları, hat öncelikleri ve yüz eşlemesi `data/omurga.json`; `.gd` içinde sabit yok.
  - Kabul: `omurga*.gd` içinde sayı sabiti 0 (0/1 hariç). Test: tarama.
  - Bağımlılık: OMR-02…05. Boyut: S.
  - Dosya: yeni: `data/omurga.json`.
  - Asset: asset gerekmedi.
- [x] **OMR-54:** (Claude) Omurga metinleri ikinci sütuna hazır.
  - Ne: tüm omurga metinleri `metinler.csv` anahtarıdır (Bölüm 46).
  - Kabul: `omurga*.gd`, `dis_hat_kapisi.gd` içinde Türkçe sabit 0. Test: tarama.
  - Bağımlılık: YER-02. Boyut: S.
  - Dosya: `data/metin/metinler.csv`.
  - Asset: asset gerekmedi.
- [ ] **OMR-55:** Kapanış testi — iki perde tek koşu.
  - Ne: otomatik oyuncu nüfus 18'e ulaşır, geçiş gecesi kapı kapalıdır, üç dalgada ≥ 3 yüz gelir, son beşten biridir, kayıt `son.nihai` yazar.
  - Kabul: beş iddia tek testte. Test: `tests/oto/omurga_kontrol.tscn`.
  - Bağımlılık: OMR-01…54. Boyut: M.
  - Dosya: yeni: `tests/oto/omurga_kontrol.tscn`, `tests/oto/omurga_kontrol.gd`.
  - Asset: asset gerekmedi.

Alt başlıklarda madde sayısı beş ile altı arasındadır; onuncu madde her yerde var olan bir perde ya da son kuralını ikinci kez yazacağı için konmadı. Toplam 55 madde.


---

## BÖLÜM 35: Ayarlar, erişilebilirlik ve okuma konforu


Faz 1 (Bölüm 33 ile birlikte; görsel kabuğu Bölüm 43 / ARY-02 tema altyapısından alır). Zemin, kodda duran ayar deposu ve ekranıdır:

- `src/sistemler/ayarlar.gd` — `VARSAYILAN`: `ses_ana 8`, `ses_muzik 7`, `ses_efekt 8`, `ekran_modu tam_ekran|pencere`, `metin_olcegi 100|125|150`, `belirme_hizi normal|hizli|aninda` (`CARPAN` 1.0/0.5/0.0), `grafik_profili normal|dusuk`, `cozunurluk_3d 50…100`. Fonksiyonlar `yukle`, `yaz`, `al`, `ayarla`, `varsayilana_don`, `belirme_ms`, `boyut`, `uygula`; sinyal `degisti`; dosya `user://ayarlar.cfg`.
- `src/arayuz/ayarlar_ekrani.gd` — `SATIRLAR` altı satır (üç ses, ekran modu, metin ölçeği, belirme hızı); zemin tek `ColorRect` `Renkler.GECE` (satır 21–24); `_degistir(a, yon)` sol/sağ oklarla değer değiştirir. `src/arayuz/grafik_ayarlari_paneli.gd` iki `OptionButton`.
- `src/arayuz/tema.gd` — `GOVDE_PX 26`, `KUCUK_PX 22`, `BASLIK_PX 34`; `boyut()` metin ölçeğini uygular. Font Alegreya değişken (`assets/font/`).
- Kayıt: `src/sistemler/kayit_deposu.gd` tek dosya `user://kayit.json` (`var_mi`, `yaz`, `oku`, `sil`); `oturum.gd KAYIT_SURUMU 3`; atomik yazım `atomik_json_kaydi.gd` (SYS-02); göç `kayit_gocu.gd` (SYS-01/14). Kayıt yuvası ve hızlı kayıt yoktur; Bölüm 31 onları buraya bıraktı (`BOLUM_31.md:5`).
- Zorluk çarpanı DEN-04'tedir; menüsü DEN-72 ile buraya ve 43'e bırakıldı.
- Kodda `ekran_modu` dışında pencere boyutu, vsync, kare sınırı, renk körlüğü paleti, tuş atama (Bölüm 45) ve dil seçimi (Bölüm 46) yoktur (`rg -i 'vsync|max_fps|daltonizm|renk_koru' src` → 0 [doğrulanamadı: yalnız bu dört terim tarandı]).

Bu bölüm ayar deposunu yeniden kurmaz; `ayarlar.gd` çekirdek sayılır, yeni anahtarlar ayrı dosyadan (`ayarlar_ek.gd`) `Ayarlar.degerler` sözlüğüne kaydolur. Ses ve seslendirme kapsam dışıdır; ses alt başlığı yalnız var olan üç bus için erişilebilirlik satırı taşır.

Kimlikler AYR-01 … AYR-52. Asset üretilmez; görsel ihtiyaç ARY-05'e yazılır. Bitince `[x]` ve ajan adı.

**Madde biçimi:** Ne, Kabul, Bağımlılık + Boyut, Dosya, Asset.

---

### 35.1 Ayarlar ekranının yapısı

- [ ] **AYR-01:** Ayarlar beş sekmedir.
  - Ne: Oyun, Görüntü, Okuma, Ses, Kontroller (45) ve Dil (46) için sekmeler; bugünkü tek düz liste yerine. Her sekme kendi dosyasıdır; `ayarlar_ekrani.gd` yalnız sekme kabuğunu çağırır.
  - Kabul: `ayarlar_ekrani.gd` içinde `SATIRLAR` kalır (geri uyum), sekmeler yeni dosyadan yüklenir. Test: sekme sayısı 6, her sekme bir `.gd`.
  - Bağımlılık: ARY-02. Boyut: M.
  - Dosya: yeni: `src/arayuz/ayarlar/ayar_sekmeleri.gd`, `oyun_sekmesi.gd`, `goruntu_sekmesi.gd`, `okuma_sekmesi.gd`, `ses_sekmesi.gd`; `ayarlar_ekrani.gd` tek satır.
  - Asset: asset gerekmedi.
- [x] **AYR-02:** (testx) Ek anahtarlar ayrı dosyadan kaydolur.
  - Ne: bu bölümün yeni anahtarları (`VARSAYILAN` ve `GECERLI` listeleri) `ayarlar_ek.gd` içinde durur ve açılışta `Ayarlar.degerler`'e birleştirilir; `ayarlar.gd` değişmez.
  - Kabul: `ayarlar.gd` diff 0; `ayarlar.al(&"yeni_anahtar")` çalışır. Test: birim.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: yeni: `src/sistemler/ayarlar_ek.gd`; `ana.gd` tek satır.
  - Asset: asset gerekmedi.
- [ ] **AYR-03:** Her satırın açıklaması vardır.
  - Ne: seçili satırın altında tek satırlık açıklama (`arayuz.ayarlar.<anahtar>_aciklama`); ne yaptığı ve varsayılanı yazar.
  - Kabul: her anahtar için açıklama anahtarı var; `metin_dogrula.py` eksik açıklamayı hata sayar. Test: tarama.
  - Bağımlılık: AYR-01. Boyut: S.
  - Dosya: `data/metin/metinler.csv`; `tools/metin_dogrula.py` tek kural.
  - Asset: asset gerekmedi.
- [ ] **AYR-04:** Ayar anında uygulanır, kapanınca yazılır.
  - Ne: mevcut davranış (`ayarlar_ekrani.gd` başlık yorumu) korunur ve yeni sekmelere de uygulanır; "Uygula" düğmesi yoktur.
  - Kabul: değer değişince `degisti` sinyali; `yaz()` yalnız `_kapat()`'ta. Test: birim.
  - Bağımlılık: AYR-01. Boyut: S.
  - Dosya: `src/arayuz/ayarlar/ayar_sekmeleri.gd`.
  - Asset: asset gerekmedi.
- [x] **AYR-05:** Varsayılana dön sekme başınadır. (Antigravity)
  - Ne: `varsayilana_don()` bütün ayarları sıfırlar; sekme başına "bu sekmeyi sıfırla" eklenir, onay ister.
  - Kabul: Okuma sekmesi sıfırlanınca ses değerleri aynı kalır. Test: birim.
  - Bağımlılık: AYR-02. Boyut: S.
  - Dosya: `src/sistemler/ayarlar_ek.gd` `sekme_sifirla(sekme)`.
  - Asset: asset gerekmedi.
- [x] **AYR-06:** (testx) Ayarlar oyun içinden ve menüden aynı ekrandır.
  - Ne: Esc menüsü (`menu` eylemi) ve ana menü (`menu_ekrani.gd arayuz.menu.ayarlar`) aynı `AyarlarEkrani` örneğini açar; köy hızı açılışta saklanır, kapanışta geri gelir (`harita_baglantisi.gd:17` kalıbı).
  - Kabul: oyun içinde açılıp kapanınca `Engine.time_scale` eşit. Test: birim.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: yeni: `src/arayuz/koy_hud/ayarlar_baglantisi.gd`.
  - Asset: asset gerekmedi.

### 35.2 Okuma konforu

- [ ] **AYR-07:** Metin ölçeğine 175 eklenir.
  - Ne: `GECERLI.metin_olcegi` 100/125/150'ye 175 eklenir (ayrı dosyadan). Tüm paneller `ayarlar.boyut()` kullandığı sürece taşma `yapi_karti.gd:59` kalıbıyla kaydırmaya düşer.
  - Kabul: 175'te hiçbir metin kesilmez; TST-10 arayüz tarayıcısı üç çözünürlükte 0 taşma. Test: tarayıcı.
  - Bağımlılık: AYR-02, TST-10. Boyut: M.
  - Dosya: `src/sistemler/ayarlar_ek.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-08:** Satır aralığı ayarı.
  - Ne: `satir_araligi` anahtarı (normal/geniş); `RichTextLabel` `line_separation` tema sabitine yazılır.
  - Kabul: geniş modda satır aralığı +6 px (öneri). Test: ekran.
  - Bağımlılık: AYR-02, ARY-02. Boyut: S.
  - Dosya: `src/sistemler/ayarlar_ek.gd`; tema kaynağına tek satır.
  - Asset: asset gerekmedi.
- [ ] **AYR-09:** Belirme hızı Söz motoruna bağlanır.
  - Ne: `belirme_ms()` yeni Söz motorunun (DIY-03) satır belirmesinde tek kaynaktır; `aninda` seçildiğinde satır tam gelir, zar animasyonu (ZAR-01) da kısalır.
  - Kabul: `aninda`'da satır gecikmesi 0 ms, zar animasyonu ≤ 200 ms. Test: zamanlayıcı.
  - Bağımlılık: DIY-03, ZAR-01. Boyut: S.
  - Dosya: Söz motoru görünümüne tek satır.
  - Asset: asset gerekmedi.
- [ ] **AYR-10:** Okunmuş satır işareti.
  - Ne: Söz motorunda daha önce görülmüş seçenek soluk renkle işaretlenir (kişi hafızası DIY-11 ile aynı kayıt). Anahtar `okunmus_isaret` açık/kapalı.
  - Kabul: ikinci ziyarette aynı seçenek soluk. Test: iki ziyaret.
  - Bağımlılık: DIY-11. Boyut: S.
  - Dosya: Söz motoru görünümüne tek satır; `ayarlar_ek.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-11:** Konuşma geçmişi kaydırılabilir.
  - Ne: sorgu sırasında önceki satırlar yukarı kaydırılarak okunur (beyan defteri DIY-07'den ayrı, yalnız bu ziyaretin akışı). Fare tekeri ve gamepad sağ çubuk.
  - Kabul: 20 satırlık sorguda ilk satıra dönülür. Test: ekran.
  - Bağımlılık: DIY-03. Boyut: S.
  - Dosya: yeni: `src/arayuz/kapi/konusma_gecmisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-12:** İpuçları ve deneyimli oyuncu anahtarı.
  - Ne: Oyun sekmesinde `ipuclari` (açık/kapalı) ve `kademeli_hud` (açık/kapalı); "ipuçlarını sıfırla" düğmesi `ogretici.gorulen`'i temizler. Bölüm 33 bunları okur.
  - Kabul: kapalıyken ipucu 0; sıfırla sonrası yeni oyunda ipucu tekrar gelir. Test: iki koşu.
  - Bağımlılık: OGR-07, OGR-29. Boyut: S.
  - Dosya: `src/sistemler/ayarlar_ek.gd`; `src/arayuz/ayarlar/oyun_sekmesi.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-13:** Font ağırlığı seçimi.
  - Ne: Alegreya değişken font `wght` ekseni kullanılır (`tema.font(agirlik)`); `metin_agirligi` normal (400) / kalın (500). Yeni font dosyası yok.
  - Kabul: kalın seçilince gövde 500. Test: tema sorgusu.
  - Bağımlılık: AYR-02. Boyut: S.
  - Dosya: `src/sistemler/ayarlar_ek.gd`; tema kaynağına tek satır.
  - Asset: asset gerekmedi.

### 35.3 Görsel erişilebilirlik

- [ ] **AYR-14:** Renk körlüğü paleti.
  - Ne: `renk_paleti` anahtarı: olağan / deuteranopi / protanopi / tritanopi. Dört bar, tansiyon göstergesi, kaynak göstergesi ve zar rengini etkileyen palet ARY-02 tema kaynağının ikinci tablosudur; `renkler.gd` değişmez.
  - Kabul: palet değişince `Renkler` sabitleri yerine tema kaynağı okunur; dört palette bar renkleri çift çift ayrışır (ΔE ≥ 20, öneri). Test: ekran + sayı.
  - Bağımlılık: ARY-02. Boyut: M.
  - Dosya: yeni: `src/arayuz/tema/palet.gd`; yeni: `data/arayuz/paletler.json`.
  - Asset: asset gerekmedi.
- [ ] **AYR-15:** Renk tek bilgi taşıyıcı değildir.
  - Ne: bar, tansiyon ve kaynak durumu renkle birlikte bir biçim ya da harf taşır (bar adının ilk harfi, tansiyonda üç kademe çizgi). Palet seçiminden bağımsız açıktır.
  - Kabul: `tansiyon_gostergesi.gd` üç kademede üç farklı çizgi sayısı; `barlar.gd` görünümünde harf. Test: ekran.
  - Bağımlılık: AYR-14. Boyut: S.
  - Dosya: yeni: `src/arayuz/kapi/tansiyon_bicimi.gd`; bar görünümüne tek satır.
  - Asset: asset gerekmedi.
- [ ] **AYR-16:** Yüksek kontrast modu.
  - Ne: `yuksek_kontrast` anahtarı: panel dolgusu tam opak, kenar kalınlığı +1, metin rengi tam `KUL` yerine beyaz. Tema kaynağı ikinci değer kümesi.
  - Kabul: açıkken metin/zemin kontrast oranı ≥ 7:1 (WCAG AAA, öneri). Test: renk ölçümü.
  - Bağımlılık: ARY-02. Boyut: S.
  - Dosya: `src/arayuz/tema/palet.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-17:** Zar sonucu rakamla da yazılır.
  - Ne: görünür zar (ZAR-01) sonucunu yalnız yüzle değil rakamla ve "geçti/kaldı" sözüyle gösterir; `belirme_hizi aninda` ile uyumlu.
  - Kabul: zar panelinde rakam ve söz 1. Test: ekran.
  - Bağımlılık: ZAR-01. Boyut: S.
  - Dosya: zar görünümüne tek satır.
  - Asset: asset gerekmedi.
- [ ] **AYR-18:** Hareket azaltma.
  - Ne: `hareket_azalt` anahtarı: 12 fps adımlı hareket (`adim.gd`) korunur, ancak ekran sarsıntısı, kamera geçişi (`kapi_kamera_gecisi.gd`) ve panel kayma animasyonları anında olur.
  - Kabul: açıkken `kapi_kamera_gecisi` süresi 0. Test: zamanlayıcı.
  - Bağımlılık: AYR-02. Boyut: S.
  - Dosya: `src/sistemler/ayarlar_ek.gd`; kamera geçişine tek satır.
  - Asset: asset gerekmedi.
- [ ] **AYR-19:** İmleç ve odak çerçevesi büyütme.
  - Ne: `odak_cercevesi` normal/kalın; klavye ve gamepad odağı (`ui_*` eylemleri) kalın modda 3 px kenar.
  - Kabul: odaklı düğme kenarı 3 px. Test: ekran.
  - Bağımlılık: ARY-02, GIR-06. Boyut: S.
  - Dosya: `src/arayuz/tema/palet.gd`.
  - Asset: asset gerekmedi.

### 35.4 Ses ayarları (yalnız var olan üç bus)

- [ ] **AYR-20:** Ses sekmesi üç kaydırıcıdır.
  - Ne: `ses_ana`, `ses_muzik`, `ses_efekt` (`BUSLAR`) 0–10 kaydırıcı olarak taşınır; ok tuşlarıyla da değişir. Yeni bus yok.
  - Kabul: üç kaydırıcı; `AudioServer` bus adları `BUSLAR` ile aynı. Test: birim.
  - Bağımlılık: AYR-01. Boyut: S.
  - Dosya: `src/arayuz/ayarlar/ses_sekmesi.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-21:** Sessizde görsel karşılık.
  - Ne: `ses_ana` 0 iken tansiyon müziği (`tansiyon_muzigi.gd`) kademe geçişi tansiyon göstergesinde bir yanıp sönmeyle duyurulur; başka görsel ses karşılığı yok.
  - Kabul: ses 0 ve kademe geçişi → gösterge 1 yanıp sönme. Test: ekran.
  - Bağımlılık: AYR-15. Boyut: S.
  - Dosya: `src/arayuz/kapi/tansiyon_bicimi.gd`.
  - Asset: asset gerekmedi.
- [x] **AYR-22:** Odak kaybında ses kısılır. (Antigravity)
  - Ne: pencere odak kaybedince `ses_ana` geçici 0; dönüşte eski değer. Anahtar `arka_planda_sustur`.
  - Kabul: `NOTIFICATION_APPLICATION_FOCUS_OUT` sonrası Master -80 dB; dönüşte eski. Test: birim.
  - Bağımlılık: AYR-02. Boyut: S.
  - Dosya: yeni: `src/sistemler/odak_sesi.gd`.
  - Asset: asset gerekmedi.

### 35.5 Oyun ayarları

- [ ] **AYR-23:** Zorluk seçimi.
  - Ne: DEN-04 çarpanı (kolay/olağan/sıkı) Oyun sekmesinde ve yeni oyun ekranında; oyun içinde değiştirilebilir, değişim Bölüm 39 defterine yazılır. DEN-72 bu maddeyle kapanır.
  - Kabul: değer `denge.json zorluk` anahtarlarından biri; kayıtta tutulur. Test: birim.
  - Bağımlılık: DEN-04, OGR-50. Boyut: S.
  - Dosya: `src/arayuz/ayarlar/oyun_sekmesi.gd`; kayıt alanı `zorluk`.
  - Asset: asset gerekmedi.
- [ ] **AYR-24:** Köy hızı varsayılanı.
  - Ne: `koy_hizi_varsayilan` 1/2/3: köy ekranı açılınca `_hiz_sec` bu değeri alır.
  - Kabul: ayar 2 ise açılışta `Engine.time_scale` 2. Test: birim.
  - Bağımlılık: AYR-02. Boyut: S.
  - Dosya: `src/sistemler/ayarlar_ek.gd`; `koy_ekrani.gd` tek satır.
  - Asset: asset gerekmedi.
- [ ] **AYR-25:** Olayda otomatik duraklat.
  - Ne: `olayda_duraklat` açıkken köy olayı (`OlayVerisi`) açılınca hız 0'a iner; kapanınca eski hız.
  - Kabul: olay paneli açılınca `paused` true. Test: birim.
  - Bağımlılık: AYR-02. Boyut: S.
  - Dosya: olay paneline tek satır.
  - Asset: asset gerekmedi.
- [ ] **AYR-26:** Gece raporu otomatik kapanmaz.
  - Ne: `rapor_bekle` açıkken gece raporu oyuncu kapatana kadar durur (varsayılan açık).
  - Kabul: açıkken rapor zamanlayıcısı 0. Test: birim.
  - Bağımlılık: AYR-02. Boyut: S.
  - Dosya: rapor panelinde tek satır.
  - Asset: asset gerekmedi.
- [ ] **AYR-27:** Karar onayı.
  - Ne: `karar_onayi` açıkken kabul/ret düğmesi ikinci tıklama ister (yanlış tıklamaya karşı). Varsayılan kapalı.
  - Kabul: açıkken tek tıkla karar 0. Test: birim.
  - Bağımlılık: AYR-02. Boyut: S.
  - Dosya: `kapi_ekrani.gd` karar düğmesine tek satır.
  - Asset: asset gerekmedi.

### 35.6 Kayıt: yuva, hızlı kayıt, otomatik kayıt

- [x] **AYR-28:** Üç kayıt yuvası. (Antigravity)
  - Ne: `kayit_deposu.gd` tek dosya kalır; üstüne `kayit_yuvalari.gd` üç yol verir (`user://kayit_1.json` … `_3`). Eski `user://kayit.json` ilk yuvaya göç eder (KAY zinciri).
  - Kabul: üç yuva; eski dosya varsa yuva 1'de görünür, silinmez. Test: göç birimi.
  - Bağımlılık: KAY-04, SYS-01. Boyut: M.
  - Dosya: yeni: `src/sistemler/kayit_yuvalari.gd`.
  - Asset: asset gerekmedi.
- [x] **AYR-29:** Yuva kartı. (Antigravity)
  - Ne: her yuvada gün, nüfus, perde, son kayıt saati ve muhafızın geçmişi (ACL-06) yazar; ekran görüntüsü yok.
  - Kabul: beş alan kayıt başlığından okunur; bozuk kayıt "okunamadı" yazar, çökmez. Test: bozuk dosya.
  - Bağımlılık: AYR-28. Boyut: S.
  - Dosya: yeni: `src/arayuz/kayit_yuva_karti.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-30:** Hızlı kayıt yalnız köyde.
  - Ne: `hizli_kayit` eylemi (Bölüm 45, varsayılan F5) köy ekranında kayıt yazar; sorgu sırasında kapalıdır (KAY-30 ile uyumlu). Yazım atomiktir (SYS-02).
  - Kabul: sorgu ortasında eylem 0 etki; köyde dosya saati değişir. Test: birim.
  - Bağımlılık: KAY-30, GIR-03. Boyut: S.
  - Dosya: yeni: `src/sistemler/hizli_kayit.gd`.
  - Asset: asset gerekmedi.
- [x] **AYR-31:** Otomatik kayıt ayarı. (Antigravity)
  - Ne: gece sonu kaydı (mevcut) korunur; `otomatik_kayit` anahtarı her gece / üç gecede bir / kapalı. Kapalıyken yalnız elle kayıt.
  - Kabul: üç gecede bir seçiliyken dosya saati üç gecede değişir. Test: birim.
  - Bağımlılık: AYR-02. Boyut: S.
  - Dosya: `src/sistemler/ayarlar_ek.gd`; gece sonu kayıt çağrısına tek satır.
  - Asset: asset gerekmedi.
- [x] **AYR-32:** Silme iki adımdır. (Antigravity)
  - Ne: yuva silme onay ister; silinen dosya `user://cop/` altına taşınır, bir sonraki açılışta temizlenir.
  - Kabul: silme sonrası `cop/` içinde dosya 1; ikinci açılışta 0. Test: birim.
  - Bağımlılık: AYR-28. Boyut: S.
  - Dosya: `src/sistemler/kayit_yuvalari.gd`.
  - Asset: asset gerekmedi.
- [x] **AYR-33:** Uyumsuz kayıt açılmaz, açıklanır. (Antigravity)
  - Ne: `KAYIT_SURUMU` ileri olan dosya yuva kartında "yeni sürüm kaydı" yazar; açılmaz, silinmez.
  - Kabul: sürüm 99 dosyası → kart uyarısı, çökme 0. Test: birim.
  - Bağımlılık: AYR-29, KAY-04. Boyut: S.
  - Dosya: `src/arayuz/kayit_yuva_karti.gd`.
  - Asset: asset gerekmedi.

### 35.7 Yeni oyun ekranı

- [ ] **AYR-34:** Yeni oyun tek ekrandır.
  - Ne: `arayuz.menu.yeni` → tek ekran: muhafızın geçmişi (ACL-06), zorluk (AYR-23, ilk oyunda gizli OGR-50), yuva seçimi (AYR-28). Başka seçenek yok.
  - Kabul: ekranda üç alan; ilk oyunda iki. Test: ekran.
  - Bağımlılık: ACL-06, AYR-23, AYR-28. Boyut: S.
  - Dosya: yeni: `src/arayuz/yeni_oyun_ekrani.gd`; `menu_ekrani.gd` tek satır.
  - Asset: asset gerekmedi.
- [ ] **AYR-35:** Tohum gösterilir, girilir.
  - Ne: oyun tohumu ekranda okunur ve isteğe bağlı girilir (TST-06 ikizi için). Varsayılan rastgele.
  - Kabul: aynı tohumla iki oyun ilk altı gece aynı kuyruğu üretir. Test: ikiz.
  - Bağımlılık: TST-06. Boyut: S.
  - Dosya: `src/arayuz/yeni_oyun_ekrani.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-36:** Dolu yuvaya yazma onayı.
  - Ne: seçilen yuva doluysa üzerine yazma onayı; onaysız geri döner.
  - Kabul: dolu yuvada tek tıkla başlangıç 0. Test: birim.
  - Bağımlılık: AYR-28. Boyut: S.
  - Dosya: `src/arayuz/yeni_oyun_ekrani.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-37:** Önceki oyunların izi.
  - Ne: `oyuncu_izi.cfg` (OGR-47) alınan sonları ve oyun sayısını tek satırla gösterir (OMR-47).
  - Kabul: satır var/yok iz dosyasına göre. Test: iki durum.
  - Bağımlılık: OMR-47. Boyut: S.
  - Dosya: `src/arayuz/yeni_oyun_ekrani.gd`.
  - Asset: asset gerekmedi.

### 35.8 Görüntü ve performans ayarları

- [ ] **AYR-38:** Pencere boyutu seçimi.
  - Ne: `ekran_modu pencere` iken 1280×720 / 1600×900 / 1920×1080 seçimi (`project.godot` override 1600×900). Stretch `canvas_items/expand` korunur.
  - Kabul: seçim `DisplayServer.window_set_size`; tam ekranda seçici pasif. Test: birim.
  - Bağımlılık: AYR-02. Boyut: S.
  - Dosya: `src/arayuz/ayarlar/goruntu_sekmesi.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-39:** Dikey eşitleme ve kare sınırı.
  - Ne: `vsync` açık/kapalı (`DisplayServer.window_set_vsync_mode`), `kare_siniri` 30/60/kapalı (`Engine.max_fps`).
  - Kabul: değer anında uygulanır; `performans_seridi.gd` okur. Test: birim.
  - Bağımlılık: AYR-02. Boyut: S.
  - Dosya: `src/arayuz/ayarlar/goruntu_sekmesi.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-40:** Grafik profili ve 3B çözünürlük buraya taşınır.
  - Ne: `grafik_ayarlari_paneli.gd` iki seçicisi Görüntü sekmesine girer; panel dosyası ince adaptör kalır.
  - Kabul: aynı anahtarlar, aynı etkiler (`grafik_profili_adaptoru.gd`). Test: birim.
  - Bağımlılık: AYR-01. Boyut: S.
  - Dosya: `src/arayuz/ayarlar/goruntu_sekmesi.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-41:** Düşük profil otomatik önerisi.
  - Ne: `performans_seridi` üç gece ortalaması 30 fps altında kalırsa bir kez "düşük profil?" satırı; otomatik değiştirmez.
  - Kabul: öneri bir kez; `grafik_profili` kendi kendine değişmez. Test: birim.
  - Bağımlılık: TEK-10. Boyut: S.
  - Dosya: yeni: `src/sistemler/profil_onerisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-42:** Arayüz ölçeği 3B'den ayrı.
  - Ne: `cozunurluk_3d` 3B sahneyi küçültürken arayüz (`canvas_items`) tam çözünürlükte kalır; madde bunu test eder.
  - Kabul: `cozunurluk_3d 50` iken metin keskinliği değişmez. Test: ekran.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `tests/oto/` ekran kontrolü.
  - Asset: asset gerekmedi.

### 35.9 Kalıcılık, göç ve denetim

- [x] **AYR-43:** Ayar dosyası sürümlüdür. (Antigravity)
  - Ne: `ayarlar.cfg` içine `surum` anahtarı; bilinmeyen anahtar atılmaz, saklanır (ileri sürüm uyumu).
  - Kabul: ileri sürüm dosyası açılır, bilinmeyen anahtar korunur. Test: birim.
  - Bağımlılık: AYR-02. Boyut: S.
  - Dosya: `src/sistemler/ayarlar_ek.gd`.
  - Asset: asset gerekmedi.
- [x] **AYR-44:** (testx) Geçersiz değer varsayılana düşer, loglanır.
  - Ne: `_gecerli` reddettiği değer için tek satır log; oyun çökmez.
  - Kabul: bozuk cfg ile açılış, log 1. Test: birim.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `src/sistemler/ayarlar_ek.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-45:** Ayarlar kayıt dosyasına girmez.
  - Ne: zorluk (AYR-23) dışında hiçbir ayar oyun kaydında durmaz; kayıt taşınınca ayarlar makineye aittir.
  - Kabul: kayıt JSON'unda ayar anahtarı 0 (zorluk hariç). Test: tarama.
  - Bağımlılık: AYR-23. Boyut: S.
  - Dosya: `tests/unit/` kayıt tarama.
  - Asset: asset gerekmedi.
- [x] **AYR-46:** Komut satırından ayar. (Antigravity)
  - Ne: `--ayar anahtar=deger` argümanı (tester için); yalnız o oturumda geçerli, dosyaya yazılmaz.
  - Kabul: argümanla açılış değeri uygular, `yaz()` sonrası dosya değişmez. Test: birim.
  - Bağımlılık: AYR-02. Boyut: S.
  - Dosya: `src/sistemler/ayarlar_ek.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-47:** Ayar değişimi tester günlüğüne düşer.
  - Ne: TST-03 kancasına `AYAR` satırı: hangi anahtar ne oldu.
  - Kabul: değişim başına bir satır. Test: birim.
  - Bağımlılık: TST-03. Boyut: S.
  - Dosya: `src/sistemler/ayarlar_ek.gd`.
  - Asset: asset gerekmedi.

### 35.10 Sınırlar ve kapanış

- [ ] **AYR-48:** `ayarlar.gd` ve `tema.gd` değişmez.
  - Ne: iki çekirdek dosyanın diff'i 0; yeni anahtar, palet ve sekme ayrı dosyadadır.
  - Kabul: `git diff` iki dosyada 0 (uygulama fazında). Test: inceleme.
  - Bağımlılık: AYR-02, AYR-14. Boyut: S.
  - Dosya: `src/sistemler/ayarlar_ek.gd`, `src/arayuz/tema/palet.gd`.
  - Asset: asset gerekmedi.
- [x] **AYR-49:** (Claude) Ses üretimi yok.
  - Ne: bu bölüm yeni ses dosyası, bus, seslendirme veya ekran okuyucu sesi eklemez.
  - Kabul: `assets/ses/` dosya sayısı değişmez. Test: sayım.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **AYR-50:** Tuş atama ve dil bu bölümde değildir.
  - Ne: Kontroller sekmesi Bölüm 45 (GIR), Dil sekmesi Bölüm 46 (YER) içindedir; burada yalnız sekme yuvası vardır.
  - Kabul: `ayar_sekmeleri.gd` iki boş yuva. Test: ekran.
  - Bağımlılık: GIR-01, YER-01. Boyut: S.
  - Dosya: `src/arayuz/ayarlar/ayar_sekmeleri.gd`.
  - Asset: asset gerekmedi.
- [x] **AYR-51:** (Claude) Ayar metinleri ikinci sütuna hazırdır.
  - Ne: tüm `arayuz.ayarlar.*` anahtarları Bölüm 46 kuralına uyar.
  - Kabul: sekme dosyalarında Türkçe sabit 0. Test: tarama.
  - Bağımlılık: YER-02. Boyut: S.
  - Dosya: `data/metin/metinler.csv`.
  - Asset: asset gerekmedi.
- [ ] **AYR-52:** Kapanış testi.
  - Ne: tek koşu: altı sekme açılır, her anahtar değiştirilip geri alınır, dosya yazılır, yeniden okunur, değerler eşit; üç yuvaya kayıt yazılır ve okunur.
  - Kabul: dört iddia tek testte. Test: `tests/oto/ayarlar_kontrol.tscn`.
  - Bağımlılık: AYR-01…51. Boyut: S.
  - Dosya: yeni: `tests/oto/ayarlar_kontrol.tscn`, `tests/oto/ayarlar_kontrol.gd`.
  - Asset: asset gerekmedi.

Alt başlıklarda madde sayısı üç ile yedi arasındadır; ses alt başlığı yalnız var olan üç bus ile sınırlı olduğu için üçtür, diğerlerinde onuncu madde var olan bir anahtarı ikinci kez yazacağı için konmadı. Toplam 52 madde.


---

## BÖLÜM 36: Muhafızın kişisel hayatı ve hane içi diyalog


Faz 2–3 (ACL-01…03 ve DYL-07 kapandıktan sonra; Söz motoru DIY-03 çalışır durumda). Zemin:

- Hane kuruluşu ACL-01 (tek ev, yatak 4, muhafız ve eş), eş ACL-02 (`src/koy/hane_esi.gd`, `data/hane_esi.json` meslek listesi: dokumacı/keçeci, ebe/şifacı, fırıncı/aşçı, bostancı, sütçü/yoğurtçu, yün eğirici; kâtiplik yalnız medrese geçmişinde), akşam sohbeti ACL-03 + DYL-07 (`src/koy/aksam_sohbeti.gd`, `data/soz/aksam_konulari.json`, eş hafızası DIY-11'in eş kaydı).
- Kodda hane, eş ve aile verisi yoktur (`rg -w 'hane|eşi'` → yalnız yorum). Var olan: muhafız maaşı `src/koy/muhafiz_maasi.gd` + `data/koy/muhafiz_maasi.json`; nöbet yorgunluğu `src/koy/nobet_yorgunlugu.gd` (UZM-14); cenaze yası `src/koy/cenaze_yasi.gd`; yaş rolleri `src/koy/yas_rolleri.gd` (çocuk/yetişkin/yaşlı); yaşam barları YSM-01…03 (Parça C); muhafız odası `src/dunya/muhafiz_odasi.gd`, vicdan `oda_vicdan_paneli.gd`, terazi `muhafiz_terazisi.gd`.
- Komşu bölümler: MCL-03 (eş meclis sözü), SAB-02 (hükümlünün hanesi), KAP-18 yetimler, SEV (köyde tekrar görme), Bölüm 37 söylenti.

Bu bölüm akşam sohbetini yeniden kurmaz. Hanenin günün geri kalanını yazar: sabah, sofra, eşin işi, misafir, muhafızın bedeni ve eve dönüşü, eşin yokluğu. Ahmet'in kararı bağlayıcıdır: kalp puanı, romans, hediye takvimi yok; eşin mesleği yalnız listeden; eş için ayrı bar açılmaz (YSM-01 köylü barıdır).

Kimlikler HAN-01 … HAN-52. Asset üretilmez; ocak görseli DYL-07 envanterindedir (`DYL07-OCAK`). Seslendirme yok. Yeni dosya + ince adaptör; `koy_ekrani.gd`, `oturum.gd`, `koy_nufusu.gd` değişmez. Bitince `[x]` ve ajan adı.

**Madde biçimi:** Ne, Kabul, Bağımlılık + Boyut, Dosya, Asset.

---

### 36.1 Hanenin kaydı ve günü

- [ ] **HAN-01:** Hane tek kayıt alanıdır.
  - Ne: `hane` sözlüğü: ev kimliği, üyeler (muhafız, eş, varsa misafir/yetim), ocak durumu, son sofra günü. Eşin kendi verisi `hane_esi.gd`'de kalır; hane onu okur.
  - Kabul: alan KAY zincirine optional girer; eski kayıtta yoksa ACL-01 kuruluşundan türetilir. Test: KAY birimi.
  - Bağımlılık: ACL-01, KAY-04. Boyut: S.
  - Dosya: yeni: `src/koy/hane.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-02:** Hanenin günü dört andır.
  - Ne: sabah (kapıya çıkmadan), öğle (köy ekranında eş işte), akşam (ACL-03 sohbeti), gece (uyku YSM-03). Yalnız sabah bu bölümün yeni anıdır; diğer üçü var olan sistemlere bağlanır.
  - Kabul: `hane.gd` dört an için dört kanca; sabah dışındakiler mevcut çağrıya tek satırla bağlanır. Test: bir gün dört kanca.
  - Bağımlılık: HAN-01, ACL-03, YSM-03. Boyut: S.
  - Dosya: `src/koy/hane.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-03:** Sabah satırı — eşin tek cümlesi.
  - Ne: kapı açılmadan eş bir cümle söyler: dünkü sohbetin kalıntısı, bugünün havası (`mevsim_yoneticisi`), ambar (`kaynaklar.gd`) ya da köyde duyduğu (HAN-25). Pencere değil, HUD'da tek satır; Söz motoru dalı değil, bağlam sorgusu (DIY-09) seçimli satırdır.
  - Kabul: günde en çok 1; eş ölüyse 0; satır `sohbet.es.sabah.*` anahtarlı ve ≤ 100 karakter. Test: üç durum.
  - Bağımlılık: HAN-02, DIY-09, DIY-10. Boyut: S.
  - Dosya: yeni: `src/koy/sabah_satiri.gd`; yeni: `data/soz/sabah_satirlari.json`.
  - Asset: asset gerekmedi.
- [ ] **HAN-04:** Sabah satırı akşam sohbetini tekrarlamaz.
  - Ne: akşam konuşulan konu (`aksam_sohbeti` kaydı) sabah satırında aynı anahtarla gelmez; sabah yalnız "kalıntı" biçimini kullanır ("Dün dediğin aklımda.").
  - Kabul: aynı konu kimliği iki yerde 0. Test: sohbet + sabah.
  - Bağımlılık: HAN-03, DYL-07. Boyut: S.
  - Dosya: `src/koy/sabah_satiri.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-05:** Sofra günü.
  - Ne: `takvim.hafta_basi` gecesinde hane sofra kurar: ambardan `1 gida` düşer (`tuketim_dengesi.json` üstüne değil, mevcut hane tüketiminin içinden), muhafız moral +1 (YSM-01 köylü barı mantığında muhafızın kendi değeri). Sofra satırı gece raporuna girer.
  - Kabul: hafta başı sofra 1; ambar 0 ise sofra olmaz, satır "boş sofra". Test: iki ambar durumu.
  - Bağımlılık: HAN-01, MEV-01. Boyut: S.
  - Dosya: `src/koy/hane.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-06:** Hane olayları tek günlükte.
  - Ne: sabah satırı, sofra, misafir, yas gibi hane olayları Bölüm 39 defterinin "Hane" sayfasına yazılır.
  - Kabul: her hane olayı bir satır. Test: defter sayfası.
  - Bağımlılık: HFZ-01. Boyut: S.
  - Dosya: `src/koy/hane.gd` → defter adaptörü.
  - Asset: asset gerekmedi.

### 36.2 Eşin işi ve hane ekonomisi

- [ ] **HAN-07:** Eşin işi köy üretimine girer.
  - Ne: ACL-02 meslekleri üretim zincirine (`src/koy/uretim.gd`, `meslek_yapilari.gd`) ince adaptörle bağlanır: ebe → şifahane triyajına +1 kontenjan (`sifahane_kontenjani.gd`), fırıncı → ekmek (`esya_idleri` içinde `ekmek`), dokumacı → kumaş, bostancı → gıda, sütçü → gıda, yün eğirici → kumaş zinciri girdisi.
  - Kabul: her meslek bir çıktı; `hane_esi.json` içinde `uretim` alanı. Test: altı meslek altı çıktı. Ek şart: Hüküm sabahı eşin üretim satırını ikinci kez basmaz. Ek şart: Eşin meslek çıktısı dört tezgâh sabahına yazılmaz; tezgâh ikinci meslek sınıfı açmaz.
  - Bağımlılık: ACL-02. Boyut: M.
  - Dosya: yeni: `src/koy/es_uretimi.gd`; `hane_esi.json` alanı.
  - Asset: asset gerekmedi.
- [ ] **HAN-08:** Eşin işi atama alanında görünür.
  - Ne: `koy_atama_alani.gd` listesinde eş kendi satırında, mesleği ve bugünkü çıktısı yazılı; sürüklenemez (ACL-02 kural 1).
  - Kabul: eş kartı sürükleme kulpu 0. Test: ekran.
  - Bağımlılık: HAN-07. Boyut: S.
  - Dosya: `koylu_karti.gd` adaptörü (ACL-02'de var) tek alan.
  - Asset: asset gerekmedi.
- [ ] **HAN-09:** Muhafız maaşı haneye düşer.
  - Ne: `muhafiz_maasi.gd` maaşı köy kasasından ayrı "hane kesesi"ne yazılır; hane kesesi yalnız HAN maddelerinde harcanır (misafir yemeği, yas). Çift kasa (EKO-01) dokunulmaz.
  - Kabul: maaş günü hane kesesi artar, köy kasası eski kuralla değişir. Test: maaş günü.
  - Bağımlılık: HAN-01. Boyut: S.
  - Dosya: `src/koy/hane.gd` `kese`.
  - Asset: asset gerekmedi.
- [ ] **HAN-10:** Eş kazancı hane kesesine değil köye.
  - Ne: eşin üretimi köy ambarına gider; hane kesesine akçe yazmaz. Madde sınır koyar: hane ayrı ekonomi değildir.
  - Kabul: `es_uretimi.gd` içinde `kese` yazımı 0. Test: tarama.
  - Bağımlılık: HAN-07, HAN-09. Boyut: S.
  - Dosya: `src/koy/es_uretimi.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-11:** Eşin meslek değişimi akşam sohbetinde geçer.
  - Ne: ACL-02 kural 4'teki meslek değişimi oyuncu kararıyla kartta yapılır; eş o akşam bunu bir konu olarak alır (`aksam_konulari.json` ağırlık 2, öneri).
  - Kabul: değişim gecesi konu adayı 1. Test: değişim.
  - Bağımlılık: DYL-07. Boyut: S.
  - Dosya: `data/soz/aksam_konulari.json` satırı.
  - Asset: asset gerekmedi.

### 36.3 Hane misafiri

- [ ] **HAN-12:** Kapıdan gelen bir gece hanede kalabilir.
  - Ne: köyde yatak yoksa (ACL-05 sınırı) kabul edilen kişi bir geceliğine hanenin boş yatağında kalır (ACL-01 yatak 4: iki boş). Oyuncu kararı sorgu sonunda tek seçenek: "bu gece bizde".
  - Kabul: boş hane yatağı varken seçenek 1, yokken 0; misafir ertesi sabah köy listesine düşer. Test: iki durum.
  - Bağımlılık: ACL-05, HAN-01. Boyut: M.
  - Dosya: yeni: `src/koy/hane_misafiri.gd`; kapı karar adaptörüne tek seçenek.
  - Asset: asset gerekmedi.
- [ ] **HAN-13:** Misafir eşle konuşur.
  - Ne: misafir gecesi akşam sohbeti (ACL-03) üç ağızlı olur: eş, misafir, muhafız. Misafirin repliği kendi Söz dosyasından (kişi hafızası DIY-11 kaydı) tek dal.
  - Kabul: misafir gecesi sohbet katılımcı 3. Test: misafir.
  - Bağımlılık: HAN-12, DYL-07, DIY-11. Boyut: S.
  - Dosya: `src/koy/aksam_sohbeti.gd` tek satır; misafir dalı Söz dosyasında.
  - Asset: asset gerekmedi.
- [ ] **HAN-14:** Misafir bir şey bırakır.
  - Ne: misafir sabah giderken heybesinden bir eşya (`esya_idleri`) ya da bir haber (Bölüm 37) bırakabilir; olasılık `data/hane.json`.
  - Kabul: 100 misafirde bırakma oranı tabloya ±%5. Test: simülasyon.
  - Bağımlılık: HAN-12, SOY-03. Boyut: S.
  - Dosya: `src/koy/hane_misafiri.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-15:** Misafir çalabilir.
  - Ne: `yalan_olasiligi` (oyun.tres 0.35) tabanlı küçük olasılıkla misafir hane kesesinden akçe götürür; sabah satırı bunu söyler. Hırsızlık olayı (`hirsizlik.tres`) yeniden kurulmaz; bu hanenin kendi satırıdır.
  - Kabul: çalma olasılığı tabloda; çalınca kese düşer, defter satırı yazılır. Test: enjekte.
  - Bağımlılık: HAN-09, HAN-12. Boyut: S.
  - Dosya: `src/koy/hane_misafiri.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-16:** Yetim hanede kalabilir.
  - Ne: KAP-18 yetimi oyuncu haneye alabilir; hane üyesi olur, yaş rolü `cocuk` (`yas_rolleri.gd`), işe atanmaz, ambardan köylü tüketimi düşer. Evlat edinme töreni, ad verme ve ilişki sayacı yoktur.
  - Kabul: hanede en çok 2 yetim (boş yatak); yetim köy listesinde `hane` etiketiyle. Test: üçüncü yetim reddedilir.
  - Bağımlılık: KAP-18, HAN-01. Boyut: M.
  - Dosya: `src/koy/hane.gd` `uye_ekle`.
  - Asset: asset gerekmedi.
- [ ] **HAN-17:** Hanedeki çocuk büyür.
  - Ne: `yas_rolleri` çocuk → yetişkin geçişi (R1 kuralı) hanedeki yetimde de işler; yetişkin olunca haneden çıkar, köylü olur, bir sabah satırı alır.
  - Kabul: geçiş gününde hane üyesi −1, köylü +1. Test: zaman makinesi.
  - Bağımlılık: HAN-16. Boyut: S.
  - Dosya: `src/koy/hane.gd`.
  - Asset: asset gerekmedi.

### 36.4 Eşin gözü — köyde duyulan

- [ ] **HAN-18:** Eş günde bir şey duyar.
  - Ne: DYL-07 kural 4'ün köy tarafı: eşin mesleğine göre bir kaynak (ebe → hastalar, fırıncı → ambar ve kuyruk, dokumacı → kadınlar arası söz, bostancı → tarla, sütçü → ağıl, yün eğirici → pazar) günde en çok bir "duyum" üretir. Duyum Bölüm 37 söylenti ağına bir düğüm olarak girer.
  - Kabul: günde ≤ 1 duyum; kaynak mesleğe bağlı tabloda. Test: altı meslek.
  - Bağımlılık: SOY-02, ACL-02. Boyut: M.
  - Dosya: yeni: `src/koy/es_duyumu.gd`; `data/hane.json` tablo.
  - Asset: asset gerekmedi.
- [ ] **HAN-19:** Duyum akşam ya da sabah söylenir.
  - Ne: duyum ağır karar yoksa akşam sohbetinin gündelik satırı, ağır karar varsa ertesi sabah satırı olur. İki yerde birden gelmez.
  - Kabul: aynı duyum kimliği bir kez. Test: iki gece.
  - Bağımlılık: HAN-03, HAN-18. Boyut: S.
  - Dosya: `src/koy/es_duyumu.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-20:** Duyum yanlış olabilir.
  - Ne: duyumun doğruluk oranı Bölüm 37 kuralına bağlıdır; eş kendi kaynağını söyler ("Fatma dedi"). Oyuncu doğrulamadan kullanırsa sonucu üstlenir.
  - Kabul: yanlış duyum oranı SOY tablosundan. Test: simülasyon.
  - Bağımlılık: SOY-05. Boyut: S.
  - Dosya: `src/koy/es_duyumu.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-21:** Duyum ertesi günün sorgusunda ipucu olur.
  - Ne: duyum bir kapı ziyaretçisini anıyorsa (`durumlar[id]`), o kişinin sorgusunda bağlam sorgusu (DIY-09) `es_duyumu` anahtarını açar; muhafız "Eşim seni anlattı" diyebilir (DYL-01 çelişki yolu).
  - Kabul: duyumlu kişide dal 1, duyumsuzda 0. Test: iki ziyaret.
  - Bağımlılık: HAN-18, DIY-09, DYL-01. Boyut: S.
  - Dosya: `src/koy/es_duyumu.gd` → bağlam sözlüğüne tek anahtar.
  - Asset: asset gerekmedi.
- [ ] **HAN-22:** Eşin söylediği defterde kaynaklıdır.
  - Ne: Bölüm 39 defterinde duyum satırı "eş, kaynak, gün" ile yazılır; doğrulanınca işaretlenir.
  - Kabul: defter satırında üç alan. Test: defter.
  - Bağımlılık: HFZ-01, HAN-18. Boyut: S.
  - Dosya: defter adaptörü.
  - Asset: asset gerekmedi.

### 36.5 Muhafızın bedeni

- [ ] **HAN-23:** Muhafızın uykusu nöbet yorgunluğuna bağlıdır.
  - Ne: `nobet_yorgunlugu.gd` (UZM-14) değeri muhafızın kendisine de uygulanır: oyuncu gece nöbeti kendisi tutarsa (NBT-09) ertesi gün yorgunluk; evde uyursa sıfırlanır. Yeni bar açılmaz; UZM-14 değeri okunur.
  - Kabul: kendi nöbetinde yorgunluk +1, evde uyku sonrası 0. Test: iki gece.
  - Bağımlılık: NBT-09, UZM-14. Boyut: S.
  - Dosya: yeni: `src/koy/muhafiz_bedeni.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-24:** Yorgun muhafızın zarı.
  - Ne: yorgunluk ≥ 2 iken görünür zar değiştiricisi −1 (ZAR-04 yaklaşım değiştiricileri tablosuna bir satır). Oyuncu zar panelinde "yorgun" etiketini görür.
  - Kabul: değiştirici tabloda; yorgunluk 0'da 0. Test: iki durum.
  - Bağımlılık: ZAR-04, HAN-23. Boyut: S.
  - Dosya: ZAR-04 değiştirici tablosu satırı.
  - Asset: asset gerekmedi.
- [ ] **HAN-25:** Muhafız hastalanabilir.
  - Ne: salgın (`saglik_yoneticisi.gd`, `kis_hastaligi.gd`) muhafızı da aday sayar; hastaysa gün kapıda `azami_soru` −1 ve eş ebe ise iyileşme 1 gün erken. Yeni hastalık sistemi yok.
  - Kabul: hasta muhafızda soru hakkı 3; ebe eşle süre −1. Test: enjekte hastalık.
  - Bağımlılık: HAN-07, KRI. Boyut: S.
  - Dosya: `src/koy/muhafiz_bedeni.gd`; sağlık yöneticisine tek satır (aday listesi).
  - Asset: asset gerekmedi.
- [ ] **HAN-26:** Kavgada yaralanan muhafız.
  - Ne: CAT-03 yaralının tedavisi muhafıza da uygulanır; yaralıyken heybe araması yapılamaz (eğilemez), hekim yoksa 2 gün.
  - Kabul: yaralı muhafızda arama düğmesi 0. Test: CAT-01 sonrası.
  - Bağımlılık: CAT-03. Boyut: S.
  - Dosya: `src/koy/muhafiz_bedeni.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-27:** Beden durumu HUD'da tek simgedir.
  - Ne: yorgun/hasta/yaralı üç durum kapı HUD'unda tek satırlık etiket; bar değil.
  - Kabul: durum yokken etiket 0. Test: ekran.
  - Bağımlılık: HAN-23…26. Boyut: S.
  - Dosya: yeni: `src/arayuz/kapi/beden_etiketi.gd`.
  - Asset: asset gerekmedi.

### 36.6 Eve dönüş ve vicdan

- [ ] **HAN-28:** Eve dönüş anı.
  - Ne: kapı günü bitince (`ana.gd` köy geçişi, `oturum_fazi.gd`) kısa bir "eve dönüş" satırı: günün en ağır kararının tek cümlelik yankısı (DYL-07 ağırlık tablosundan en yüksek). Sohbet değil, geçiş satırı.
  - Kabul: ağır karar varsa satır 1, yoksa 0. Test: iki gün.
  - Bağımlılık: DYL-07, HAN-02. Boyut: S.
  - Dosya: yeni: `src/koy/eve_donus.gd`; faz geçişine tek satır.
  - Asset: asset gerekmedi.
- [ ] **HAN-29:** Eşin terazi görüşü.
  - Ne: muhafız terazisi (`muhafiz_terazisi.gd`) kademe değiştirince eş bunu akşam sohbetinde bir konu olarak alır (ağırlık 4, öneri). Eş teraziyi "yozlaşma" diye değil kendi diliyle söyler (USLUP).
  - Kabul: kademe değişim gecesi konu adayı 1. Test: enjekte terazi.
  - Bağımlılık: DYL-07, ODA-12. Boyut: S.
  - Dosya: `data/soz/aksam_konulari.json` satırı.
  - Asset: asset gerekmedi.
- [ ] **HAN-30:** Vicdan paneli eşin sözünü hatırlar.
  - Ne: `oda_vicdan_paneli.gd` son üç akşam sohbetinin eş cümlesini gösterir (DIY-11 eş kaydından). Yeni kayıt yok.
  - Kabul: panelde ≤ 3 satır. Test: ekran.
  - Bağımlılık: DYL-07. Boyut: S.
  - Dosya: yeni: `src/arayuz/oda_es_sozu.gd`; vicdan paneline tek satır.
  - Asset: asset gerekmedi.
- [ ] **HAN-31:** Rüşvet eve girmez.
  - Ne: rüşvet akçesi (`rusvet_akce`) hane kesesine değil muhafızın gizli kasasına (ODA kasa, `oda_kasasi_paneli.gd`) gider. Eş fark ederse (olasılık terazi kademesine bağlı) konu olur.
  - Kabul: rüşvet sonrası hane kesesi değişmez; fark olasılığı tabloda. Test: rüşvet.
  - Bağımlılık: ODA-04, HAN-09. Boyut: S.
  - Dosya: `src/koy/hane.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-32:** Susmak da kaydedilir.
  - Ne: DYL-07 kural 6 "kaçtı" kaydı üst üste üç gece olursa sabah satırı bunu söyler; ceza yok.
  - Kabul: üç "kaçtı" sonrası sabah satırı 1. Test: üç gece.
  - Bağımlılık: DYL-07, HAN-03. Boyut: S.
  - Dosya: `src/koy/sabah_satiri.gd`.
  - Asset: asset gerekmedi.

### 36.7 Hane ve köy

- [ ] **HAN-33:** Komşu hane.
  - Ne: köyde ev sayısı ≥ 2 olunca en yakın ev "komşu" etiketlenir (`izgara.gd` komşuluğu). Komşu hanenin bir üyesi eşin duyum kaynaklarına eklenir.
  - Kabul: komşu 1, ev yoksa 0. Test: iki harita.
  - Bağımlılık: HAN-18. Boyut: S.
  - Dosya: `src/koy/es_duyumu.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-34:** Eş çınarda söz alır (MCL-03'ün hane tarafı).
  - Ne: eş meclis sözü aldığı gece akşam sohbeti yerine meclis repliği gelir; iki sahne üst üste binmez.
  - Kabul: meclis gecesi akşam sohbeti 0. Test: MCL gecesi.
  - Bağımlılık: MCL-03, ACL-03. Boyut: S.
  - Dosya: `src/koy/aksam_sohbeti.gd` tek koşul.
  - Asset: asset gerekmedi.
- [ ] **HAN-35:** Hükümlünün hanesi eşin gözündedir (SAB-02 ile bağ).
  - Ne: SAB-02 "evde kalanlar" eşin duyum kaynağına girer; eş ebe ya da dokumacıysa hükümlünün eşini anar.
  - Kabul: SAB-02 kaydı varken duyum adayı 1. Test: hüküm sonrası.
  - Bağımlılık: SAB-02, HAN-18. Boyut: S.
  - Dosya: `src/koy/es_duyumu.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-36:** Cenaze yası haneye de düşer.
  - Ne: `cenaze_yasi.gd` köy yası haneyi de kapsar: cenaze günü sofra kurulmaz (HAN-05), sabah satırı yas cümlesi.
  - Kabul: cenaze haftasında sofra 0. Test: cenaze.
  - Bağımlılık: KRI-05, HAN-05. Boyut: S.
  - Dosya: `src/koy/hane.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-37:** Sevilen yüz haneye uğrar (SEV-02 ile bağ).
  - Ne: SEV-02 ateşe gelen tanıdık yüz, boş günde (KAP-16) hanenin ocağına da gelebilir; o gece HAN-13 üç ağızlı sohbet olur.
  - Kabul: boş günde SEV-02 kişisi varsa misafir seçeneği 1. Test: boş gün.
  - Bağımlılık: SEV-02, HAN-13. Boyut: S.
  - Dosya: `src/koy/hane_misafiri.gd`.
  - Asset: asset gerekmedi.

### 36.8 Eşin yokluğu

- [ ] **HAN-38:** Eş ölünce hane susar.
  - Ne: ACL-02 kural 5 ağır yas: akşam sohbeti, sabah satırı ve duyum kapanır; sofra kurulmaz; hane sayfasında tek satır yas. Yeni son yok.
  - Kabul: ölüm sonrası dört kanca 0. Test: ölüm enjeksiyonu.
  - Bağımlılık: ACL-02. Boyut: S.
  - Dosya: `src/koy/hane.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-39:** Yas süresi sonrası tek satır.
  - Ne: 7 gün (öneri; `cenaze_yasi.gd` süresiyle aynı) sonra sabah satırı yerine muhafızın kendi tek cümlesi gelir (ACL-06 geçmişine göre). Yeni eş, evlilik, romans yoktur.
  - Kabul: yas sonrası satır muhafızın; `hane_esi` alanı boş kalır. Test: 8. gün.
  - Bağımlılık: HAN-38. Boyut: S.
  - Dosya: `src/koy/sabah_satiri.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-40:** Eş kaçırılabilir ya da hastalanabilir, ölmeden.
  - Ne: çete baskını (`husumet_baskini.gd`) ve salgın eşi geçici alabilir: hasta eş 3 gün sohbet etmez, duyum vermez; "kaçırılma" yoktur (yeni hat açılmaz), yalnız hastalık.
  - Kabul: hasta eşte üç kanca 0, iyileşince döner. Test: enjekte.
  - Bağımlılık: KRI, HAN-02. Boyut: S.
  - Dosya: `src/koy/hane.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-41:** Eşin ölümü omurgaya yansır.
  - Ne: eş ölümü `uc_tutundu` sonunun yüzünü (OMR-15) kaldırır; epilog ağır yas dalıyla gelir (ACL-02 kural 5).
  - Kabul: eş ölüyken `uc_tutundu` yüzü 0, epilog dalı 1. Test: son.
  - Bağımlılık: OMR-15. Boyut: S.
  - Dosya: `data/omurga.json`.
  - Asset: asset gerekmedi.

### 36.9 Yazım ve ses kartı

- [ ] **HAN-42:** Eşin ses kartı tek kaynaktır.
  - Ne: YAZ-03 ses kartı eş için meslek varyantlarını da kapsar; sabah satırı, duyum, misafir sohbeti aynı karttan yazılır.
  - Kabul: kartta altı meslek için altı "ağız notu". Test: kart.
  - Bağımlılık: YAZ-03. Boyut: S.
  - Dosya: YAZ-03 kart dosyası.
  - Asset: asset gerekmedi.
- [ ] **HAN-43:** Sabah satırı havuzu.
  - Ne: 6 meslek × 4 kaynak (hava, ambar, duyum, kalıntı) × 2 varyant = 48 satır (öneri); hepsi USLUP §7 denetiminden geçer.
  - Kabul: `sabah_satirlari.json` ≥ 48 satır; yapaylık taraması 0 ihlal. Test: tarama.
  - Bağımlılık: HAN-03, YAZ-10. Boyut: M.
  - Dosya: `data/soz/sabah_satirlari.json`.
  - Asset: asset gerekmedi.
- [ ] **HAN-44:** Hitap kuralı.
  - Ne: eş muhafıza adıyla değil USLUP §3 hitap türlerinden biriyle seslenir; hitap ACL-06 geçmişine göre seçilir ve değişmez.
  - Kabul: eş satırlarında muhafız adı 0. Test: tarama.
  - Bağımlılık: YAZ-02. Boyut: S.
  - Dosya: `data/soz/sabah_satirlari.json`.
  - Asset: asset gerekmedi.
- [ ] **HAN-45:** Kör okuma testi eşi kapsar.
  - Ne: DYL-11 kör okuma setine eşin satırları girer; eş ile diğer kadın karakterler ayrışmalı.
  - Kabul: eş doğru tanıma ≥ %70 (öneri). Test: DYL-11.
  - Bağımlılık: DYL-11. Boyut: S.
  - Dosya: DYL-11 test seti.
  - Asset: asset gerekmedi.
- [ ] **HAN-46:** Çocuk ağzı ayrıdır.
  - Ne: hanedeki yetimin tek satırları (sabah, veda) çocuk ağzıyla; USLUP yaş kuralı.
  - Kabul: çocuk satırlarında yetişkin kalıbı 0. Test: inceleme.
  - Bağımlılık: HAN-16, YAZ-02. Boyut: S.
  - Dosya: `data/soz/sabah_satirlari.json` çocuk bölümü.
  - Asset: asset gerekmedi.

### 36.10 Sınırlar ve kapanış

- [x] **HAN-47:** (Claude — kapsam bekçisi) Kalp puanı, romans, hediye yok.
  - Ne: hane sözlüğünde `sevgi`, `kalp`, `hediye`, `iliski` anahtarı yoktur; eş morali YSM-01 köylü barıdır.
  - Kabul: `rg -i 'kalp|hediye|romans|iliski' src/koy/hane*.gd` → 0. Test: tarama.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `tools/godot_script_taramasi.py` tek kural.
  - Asset: asset gerekmedi.
- [ ] **HAN-48:** Eşin mesleği yalnız listeden.
  - Ne: ACL-02 listesi tek kaynaktır; bu bölüm liste eklemez.
  - Kabul: `hane_esi.json` meslek sayısı ACL-02 ile aynı (6 + kâtip). Test: sayım.
  - Bağımlılık: ACL-02. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [x] **HAN-49:** (Claude) Eş için ikinci oynanabilir gövde yok.
  - Ne: oyuncu eşi yönetmez; eş sürüklenmez, kapıya gitmez (ACL-01 uç durum).
  - Kabul: eşte `yuru()` çağrısı yalnız rutin (`koy_halk_hareketi`). Test: tarama.
  - Bağımlılık: ACL-01. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [x] **HAN-50:** (Claude — kapsam bekçisi) Hane sahnesi yoktur.
  - Ne: ev içi 3B sahne, oda kamerası veya ayrı ekran açılmaz; hane HUD satırı ve akşam kadrajıdır (DYL-07 `DYL07-OCAK`).
  - Kabul: `hane_sahnesi`, `ev_ici` adlı sahne 0. Test: tarama.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [x] **HAN-51:** (Claude) Çekirdek imzalar.
  - Ne: `koy_nufusu.gd`, `oturum.gd`, `koy_ekrani.gd` değişmez; hane kancaları adaptördür.
  - Kabul: `api_sozlesmesi.py` farkı 0. Test: araç.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `tools/api_sozlesmesi_baseline.json`.
  - Asset: asset gerekmedi.
- [ ] **HAN-52:** Kapanış testi.
  - Ne: tek koşu: üç gün hane döngüsü (sabah satırı, iş çıktısı, sofra, misafir, duyum → ipucu), eş ölümü sonrası dört kanca 0, kayıt KAY zincirinden geçer.
  - Kabul: üç iddia tek testte. Test: `tests/unit/koy/hane_test.gd`.
  - Bağımlılık: HAN-01…51. Boyut: M.
  - Dosya: yeni: `tests/unit/koy/hane_test.gd`.
  - Asset: asset gerekmedi.

Alt başlıklarda madde sayısı dört ile altı arasındadır; onuncu madde her yerde ACL-02/03 ya da DYL-07'de duran bir kuralı ikinci kez yazacağı için konmadı. Toplam 52 madde.


---

## BÖLÜM 37: Söylenti, dedikodu ve kamuoyu ağı


Faz 2–3 (DIY-13 ve KOP-05 kapandıktan sonra). Zemin:

- Fısıltı gazetesi CAS-09: `src/kapi/fisilti_gazetesi.gd` (`oku`, `durum`, `gece`, `olay`, `tanimli`, `uygun`, `uygula`), veri `data/fisilti_gazetesi.json`; yer kalıbı BUG-17 ile `{yer}` olur.
- Dedikodu yayılımı DIY-13 (`src/sistemler/dedikodu.gd`, tanık, 1–3 gece, ağır olay listesi); KOP-05 dedikoduyu gazetenin tek yazarı yapar; `BatilInancHisterisi` (KRI-08, `src/koy/batil_inanc_histerisi.gd`) aynı kaydı okur.
- Grup itibarı DIY-12 (altı grup, −10…+10), kişi hafızası DIY-11, "Bu hatırlanacak" DIY-14, haber önce insandan DNY-02, sabah tek dedikodu satırı SAB-04, köy içi sohbetler YAZ-08, çınar meclisi MCL, eşin duyumu HAN-18, haberci ağı HAR-09 (`haberci_agi.gd`).
- Kodda kamuoyu, söylenti ağı, kaynak güvenilirliği yoktur; dört bar (`barlar.gd`) köy genelinin tek sayısıdır.

Bu bölüm dedikodu kaydını ve gazeteyi yeniden kurmaz. Dedikodunun ağını yazar: kaynağı, taşıyıcısı, kulağı, doğruluğu, kamuoyuna dönüşmesi ve oyuncunun bunu okuyup etkilemesi. Kayıt DIY-13'ündür; ağ ona kaynak, yol ve güvenilirlik alanı ekler. Söz motoru DIY-03 satır seçiminde ağı bağlam sorgusuyla (DIY-09) okur.

Kimlikler SOY-01 … SOY-50. Kalp puanı, romans, seslendirme yok. Asset üretilmez. Yeni dosya + ince adaptör; `fisilti_gazetesi.gd` ve `dedikodu.gd` imzaları değişmez. Bitince `[x]` ve ajan adı.

**Madde biçimi:** Ne, Kabul, Bağımlılık + Boyut, Dosya, Asset.

---

### 37.1 Söylentinin anatomisi — kaynak, yol, doğruluk

- [ ] **SOY-01:** Her dedikodu kaydının kaynağı ve doğruluğu vardır.
  - Ne: DIY-13 kaydına optional iki alan: `kaynak` (tanık köylü kimliği) ve `dogru` (bool; olay gerçekten oldu mu). Yanlış söylenti SOY-05 ile üretilir. Omurga (OMR-39) yalnız `dogru` kayıtları okur.
  - Kabul: alanlar optional; eski kayıt `dogru=true`, `kaynak=""` sayılır. Test: KAY birimi.
  - Bağımlılık: DIY-13, KAY-04. Boyut: S.
  - Dosya: yeni: `src/sistemler/soylenti_agi.gd` (kaydı okur, alan ekler).
  - Asset: asset gerekmedi.
- [ ] **SOY-02:** Düğüm — kim duydu.
  - Ne: her kayıt için "duyanlar" kümesi: başlangıçta tanık; her gece yayılım adımında (DIY-13 1–3 gece) tanığın komşuları (`izgara.gd` komşuluk) ve aynı iş yerindekiler (`meslek_yapilari.gd`) eklenir. Eşin duyumu (HAN-18) bu kümeden gelir.
  - Kabul: gece başına yeni duyan ≤ 4 (öneri, `data/soylenti.json`); duyanlar kümesi kayıtta. Test: üç gece.
  - Bağımlılık: SOY-01, HAN-18. Boyut: M.
  - Dosya: `src/sistemler/soylenti_agi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SOY-03:** Taşıyıcı — kapıdan giren haber.
  - Ne: kapıdan kabul edilen kişi dış haber taşıyabilir (DNY-02 söylentisi, hane misafiri HAN-14); içeri girince ilk düğüm odur.
  - Kabul: kabul edilen taşıyıcı kayıtta `kaynak`. Test: kabul.
  - Bağımlılık: DNY-02, SOY-02. Boyut: S.
  - Dosya: `src/sistemler/soylenti_agi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SOY-04:** Reddedilen de haber bırakır.
  - Ne: reddedilen kişi sıradakilere (kapı kuyruğu, `kapi_firtina_kuyrugu.gd` sırası) bir cümle bırakabilir; kuyruktaki kabul edilirse haberi taşır.
  - Kabul: red sonrası kuyrukta `tasinan_haber` 1. Test: red + kabul.
  - Bağımlılık: SOY-03. Boyut: S.
  - Dosya: `src/sistemler/soylenti_agi.gd`; kuyruk adaptörü tek satır.
  - Asset: asset gerekmedi.
- [ ] **SOY-05:** Yanlış söylenti.
  - Ne: kayıt yayılırken her adımda bozulma olasılığı (`yalan_olasiligi` 0.35'in çeyreği, öneri `data/soylenti.json`): kişi adı, yer veya miktar değişir; `dogru=false` kopyası oluşur. Asıl kayıt silinmez.
  - Kabul: 100 yayılımda bozulma oranı tablo ±%5; bozulan kopya `kaynak` alanında bozanı taşır. Test: simülasyon.
  - Bağımlılık: SOY-01. Boyut: M.
  - Dosya: `src/sistemler/soylenti_agi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SOY-06:** Söylenti ölür.
  - Ne: DIY-13 "üçüncü geceden sonra basılmamış satır silinir" kuralı korunur; ağ kaydı 7 gece (öneri) sonra düşer, kamuoyuna (SOY-13) dönüştüyse izi orada kalır.
  - Kabul: 8. gece kayıt 0. Test: zaman makinesi.
  - Bağımlılık: SOY-02. Boyut: S.
  - Dosya: `src/sistemler/soylenti_agi.gd`.
  - Asset: asset gerekmedi.

### 37.2 Kaynak güvenilirliği

- [ ] **SOY-07:** Her köylünün söz güvenilirliği vardır.
  - Ne: köylüde optional `guvenilirlik` 0–3 (başlangıç 2): yaydığı söylenti doğru çıkınca +1, yanlış çıkınca −1. Kalp puanı değil; yalnız haber doğruluğu.
  - Kabul: alan `koylu.gd` dışında ağ sözlüğünde (çekirdek değişmez). Test: iki olay.
  - Bağımlılık: SOY-05. Boyut: S.
  - Dosya: `src/sistemler/soylenti_agi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SOY-08:** Güvenilirlik köylü kartında bir kelimedir.
  - Ne: `koylu_karti_verisi.gd` adaptörüne tek alan: "ağzı sıkı / konuşkan / uyduruyor" (3/2/0–1).
  - Kabul: kartta kelime; sayı yok. Test: ekran.
  - Bağımlılık: SOY-07. Boyut: S.
  - Dosya: kart adaptörü tek alan.
  - Asset: asset gerekmedi.
- [ ] **SOY-09:** Doğrulama — oyuncu kaynağa sorar.
  - Ne: köy ekranında köylüye tıklayınca (`koylu_secimi.gd`) "ne duydun?" tek seçenek: köylü bildiği söylentiyi kendi ağzından söyler (YAZ-08 köy sohbeti dalı). Oyuncu iki kaynağı karşılaştırır; sistem doğruyu söylemez.
  - Kabul: duyan köylüde dal 1, duymayanda 0. Test: iki köylü.
  - Bağımlılık: YAZ-08, SOY-02. Boyut: M.
  - Dosya: yeni: `src/koy/ne_duydun.gd`; köylü seçim adaptörüne tek satır.
  - Asset: asset gerekmedi.
- [ ] **SOY-10:** Kapıda doğrulama (DYL-01 ile bağ).
  - Ne: sorguda beyan defterine (DIY-07) düşen söz, ağdaki bir kayıtla çelişiyorsa oyuncu "köyde başka duydum" diyebilir (DYL-01 çelişki yolu). Ağ kaydı `dogru=false` ise muhafız yanılır; tansiyon +1.
  - Kabul: doğru kayıtla çelişki zarsız geçer; yanlış kayıtla tansiyon +1. Test: iki kayıt.
  - Bağımlılık: DYL-01, SOY-01. Boyut: S.
  - Dosya: DYL-01 adaptörüne tek koşul.
  - Asset: asset gerekmedi.
- [ ] **SOY-11:** Yanlış söylenti doğrulanınca kaynağı düşer.
  - Ne: SOY-09/10 ile yanlış çıkan söylentinin bozan kaynağının güvenilirliği −1, doğru çıkanın +1; defter satırı yazılır.
  - Kabul: iki yön. Test: birim.
  - Bağımlılık: SOY-07, SOY-09. Boyut: S.
  - Dosya: `src/sistemler/soylenti_agi.gd`.
  - Asset: asset gerekmedi.

### 37.3 Kamuoyu — söylenti bara dönüşür

- [ ] **SOY-12:** Kamuoyu konusu.
  - Ne: aynı olay kimliğini köyün ≥ %40'ı (öneri) duyduğunda kayıt "kamuoyu konusu" olur; o andan sonra çınar meclisi (MCL-02) şikâyet olarak alabilir.
  - Kabul: eşik `data/soylenti.json`; eşik altında meclis adayı 0. Test: iki nüfus.
  - Bağımlılık: SOY-02, MCL-02. Boyut: S.
  - Dosya: `src/sistemler/soylenti_agi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SOY-13:** Kamuoyu barı oynatır, gazete oynatmaz.
  - Ne: bar değişimi (`barlar.gd`) yalnız kamuoyu konusu olunca ve bir kez: ağır olay türüne göre `bar.halk` ya da `bar.tuccarlar` −1. Gazete satırı bar değiştirmez (KOP-05 kural 2 korunur).
  - Kabul: eşik altında bar deltası 0; eşik üstünde bir kez −1. Test: simülasyon. Ek şart: Haber satırı kamuoyu barını tek başına değiştirmez.
  - Bağımlılık: SOY-12. Boyut: S.
  - Dosya: `src/sistemler/soylenti_agi.gd` → bar adaptörü tek satır.
  - Asset: asset gerekmedi.
- [ ] **SOY-14:** Grup itibarı kamuoyuna girer (DIY-12 ile bağ).
  - Ne: kamuoyu konusu bir grubu anıyorsa (Türkmen/Rum/Ahi…) grup itibarı DIY-12 bir kez yazılır; iki kez yazılmaz (DIY-12 kural 2).
  - Kabul: aynı konu için grup yazımı 1. Test: birim.
  - Bağımlılık: DIY-12, SOY-12. Boyut: S.
  - Dosya: `src/sistemler/soylenti_agi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SOY-15:** Histeri kamuoyundan beslenir (KRI-08 ile bağ).
  - Ne: `BatilInancHisterisi` yanlış söylentileri (`dogru=false`) kamuoyu konusu olunca ek tetik sayar; histeri motoru değişmez, yalnız girdi kaynağı genişler.
  - Kabul: yanlış kamuoyu konusu histeri sayacına +1. Test: KRI-08 birimi.
  - Bağımlılık: KRI-08, SOY-05. Boyut: S.
  - Dosya: `batil_inanc_histerisi.gd` okuyucusuna tek satır.
  - Asset: asset gerekmedi.
- [ ] **SOY-16:** Kamuoyu söner.
  - Ne: kamuoyu konusu 5 gece (öneri) sonra "eski konu" olur; meclis almaz, bar değişmez, defterde kalır.
  - Kabul: 6. gece meclis adayı 0. Test: zaman makinesi. Ek şart: Çınar meclisi kamuoyu değerini tek başına değiştirmez; düşüş divan hükmü veya süre dolumudur.
  - Bağımlılık: SOY-12. Boyut: S.
  - Dosya: `src/sistemler/soylenti_agi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SOY-17:** Olumlu söylenti de vardır.
  - Ne: DIY-13 ağır olay listesine karşılık "iyi olay" listesi: haksızlığa karşı durma (divan), yaralıyı tedavi (CAT-03), aileyi birlikte alma. Olumlu kamuoyu `bar.halk` +1. Liste veridedir.
  - Kabul: `data/soylenti.json iyi_olaylar`; olumlu kamuoyu bir kez +1. Test: birim.
  - Bağımlılık: SOY-13. Boyut: S.
  - Dosya: `data/soylenti.json`.
  - Asset: asset gerekmedi.

### 37.4 Oyuncunun söylenti üzerindeki etkisi

- [ ] **SOY-18:** Muhafız söylenti yayabilir.
  - Ne: akşam sohbetinde (DYL-07) ya da çınarda (MCL) muhafız bir söylentiyi "doğru" ya da "yalan" diye niteleyebilir; nitelik ağa muhafız kaynaklı düğüm olarak girer; muhafızın da güvenilirliği vardır (SOY-07).
  - Kabul: muhafız düğümü kayıtta; yanlış nitelik güvenilirlik −1. Test: birim.
  - Bağımlılık: SOY-07, DYL-07. Boyut: M.
  - Dosya: `src/sistemler/soylenti_agi.gd`; DYL-07 ve MCL dalı.
  - Asset: asset gerekmedi.
- [ ] **SOY-19:** Muhafızın yalanı ağa düşer (DYL-04 ile bağ).
  - Ne: DYL-04 muhafız yalanı, tanık varsa DIY-13 kaydı açar (ağır olay listesine "muhafızın yalanı" eklenir).
  - Kabul: tanıklı yalan kayıt 1, tanıksız 0. Test: iki durum.
  - Bağımlılık: DYL-04, DIY-13. Boyut: S.
  - Dosya: DIY-13 olay listesi satırı.
  - Asset: asset gerekmedi.
- [ ] **SOY-20:** Susturma.
  - Ne: oyuncu bir kaynağa "bunu konuşma" diyebilir (SOY-09 ekranında ikinci seçenek): kaynak güvenilirliği yüksekse yayılım durur, düşükse hızlanır. Sonucu oyuncu bilmez.
  - Kabul: iki güvenilirlik düzeyinde iki sonuç. Test: birim.
  - Bağımlılık: SOY-09. Boyut: S.
  - Dosya: `src/koy/ne_duydun.gd`.
  - Asset: asset gerekmedi.
- [ ] **SOY-21:** Divan söylentiyi keser (CAS-07 ile bağ).
  - Ne: divan hükmü verilen olay için kamuoyu konusu kapanır; SAB-04 tek satırı yazılır, ağ kaydı "hükme bağlandı" olur.
  - Kabul: hüküm sonrası kamuoyu 0, SAB-04 satırı 1. Test: hüküm.
  - Bağımlılık: CAS-07, SAB-04. Boyut: S.
  - Dosya: `src/sistemler/soylenti_agi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SOY-22:** Rüşvetin söylentisi oda kasasına bakar.
  - Ne: tanıklı rüşvet (DIY-13 kural) kamuoyu olunca sancak teftişi (`sancak_teftisi.gd`) o olayı sorar; teftiş yeniden kurulmaz, soru listesine girdi.
  - Kabul: rüşvet kamuoyu + teftiş → soru 1. Test: birim.
  - Bağımlılık: SOY-12, ODA. Boyut: S.
  - Dosya: teftiş soru listesine tek satır.
  - Asset: asset gerekmedi.

### 37.5 Söz motorunda söylenti

- [ ] **SOY-23:** Bağlam sorgusunda söylenti anahtarları.
  - Ne: DIY-09 sözlüğüne `soylenti.<olay_id>.duydu`, `.dogru`, `.kaynak` anahtarları; satır seçimi "duydum ki…" dalını açar.
  - Kabul: duyan karakterde anahtar true. Test: birim.
  - Bağımlılık: DIY-09, SOY-02. Boyut: S.
  - Dosya: `src/sistemler/soylenti_agi.gd` → bağlam sözlüğü.
  - Asset: asset gerekmedi.
- [ ] **SOY-24:** Dönen karakter söylentiyi getirir.
  - Ne: DIY-11 dönen karakter köyde duyduğunu (ağ kaydı) ilk cümlesinde anabilir; söz dosyasında `soylenti` dalı.
  - Kabul: dönen + duyan → dal 1. Test: iki ziyaret.
  - Bağımlılık: DIY-11, SOY-23. Boyut: S.
  - Dosya: Söz dosyaları.
  - Asset: asset gerekmedi.
- [ ] **SOY-25:** Dış söylenti çelişir (DNY-02 kural 1).
  - Ne: iki kapı ziyaretçisi aynı dünya olayını farklı söyler; iki satır farklı `kaynak`, biri `dogru=false`. Oyuncu beyan defterinde ikisini görür.
  - Kabul: aynı olay iki satır, metinler farklı (DNY-02 kural 2). Test: iki ziyaret.
  - Bağımlılık: DNY-02, SOY-05. Boyut: S.
  - Dosya: Söz dosyaları; `soylenti_agi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SOY-26:** "Bu hatırlanacak" söylentide de çıkar (DIY-14).
  - Ne: oyuncunun seçimi ağa muhafız düğümü yazıyorsa DIY-14 notu çıkar; kural DIY-14'ündür.
  - Kabul: not bir kez. Test: birim.
  - Bağımlılık: DIY-14, SOY-18. Boyut: S.
  - Dosya: DIY-14 tetik listesi satırı.
  - Asset: asset gerekmedi.
- [ ] **SOY-27:** Söylenti satırları YAZ kotasına girer.
  - Ne: "duydum ki" satırları OZGUNLUK kotasında (YAZ-09) "dedikodu çekirdeği" türüne sayılır; kadroda ≤ %20 (öneri).
  - Kabul: kota raporu. Test: YAZ-09 denetimi.
  - Bağımlılık: YAZ-09. Boyut: S.
  - Dosya: YAZ-09 kota tablosu.
  - Asset: asset gerekmedi.

### 37.6 Görünürlük — oyuncu ağı nasıl okur

- [ ] **SOY-28:** Fısıltı gazetesi aynı kalır, kaynak sütunu eklenir.
  - Ne: sabah pusulası satırının altına küçük yazı: "duyan: Fatma" (SOY-01 `kaynak`). Satır sayısı ve kalıp değişmez.
  - Kabul: pusula satırında kaynak 1; kaynaksız kayıtta boş. Test: ekran.
  - Bağımlılık: SOY-01. Boyut: S.
  - Dosya: yeni: `src/arayuz/koy_hud/pusula_kaynak.gd`; gazete görünümüne tek satır.
  - Asset: asset gerekmedi.
- [ ] **SOY-29:** Defterde "Söylenti" sayfası.
  - Ne: Bölüm 39 defterinde canlı söylentiler: olay, kaynak, kaç kişi duydu (sayı değil kademe: birkaç / yarı köy / herkes), doğrulandı mı.
  - Kabul: sayfa ağ kaydıyla eşit. Test: defter.
  - Bağımlılık: HFZ-01, SOY-02. Boyut: S.
  - Dosya: defter adaptörü.
  - Asset: asset gerekmedi.
- [ ] **SOY-30:** Kamuoyu konusu HUD'da tek satırdır.
  - Ne: kamuoyu konusu varken köy HUD'unda tek satır "köy … konuşuyor"; tıklanınca defter sayfası.
  - Kabul: konu yokken satır 0. Test: ekran.
  - Bağımlılık: SOY-12, SOY-29. Boyut: S.
  - Dosya: yeni: `src/arayuz/koy_hud/kamuoyu_seridi.gd`.
  - Asset: asset gerekmedi.
- [x] **SOY-31:** (Claude — kapsam bekçisi) Köylü üstü baloncuk yok.
  - Ne: 3B köylülerin üstünde söylenti baloncuğu çizilmez; ağ metinle okunur (Bölüm 44 sınırı).
  - Kabul: `koy/gorsel/` içinde söylenti çizimi 0. Test: tarama.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **SOY-32:** Yayılım haritası yalnız debug'da.
  - Ne: `src/debug/` panelinde ağ grafiği (kim kime, hangi gece); oyuncuya kapalı.
  - Kabul: debug kapalıyken panel 0. Test: tarama.
  - Bağımlılık: SOY-02. Boyut: S.
  - Dosya: yeni: `src/debug/soylenti_paneli.gd`.
  - Asset: asset gerekmedi.

### 37.7 Dedikodu ve köy sistemleri

- [ ] **SOY-33:** Çınar meclisi kamuoyu konusunu alır (MCL-02).
  - Ne: MCL-02 şikâyeti SOY-12 konusundan gelir; şikâyet metni kaynak adını taşır (MCL-06).
  - Kabul: kamuoyu konusu varken meclis şikâyeti onu seçer. Test: meclis.
  - Bağımlılık: MCL-02, SOY-12. Boyut: S.
  - Dosya: MCL-02 adaptörüne tek satır.
  - Asset: asset gerekmedi.
- [ ] **SOY-34:** Grev söylentiden tetiklenebilir (`meslek_grevi.gd`).
  - Ne: iş kazası ya da ücret söylentisi kamuoyu olursa meslek grevi olasılığı artar; grev motoru değişmez, girdi eklenir.
  - Kabul: kamuoyu + meslek eşleşmesi → grev olasılığı +0.1 (öneri). Test: birim.
  - Bağımlılık: SOY-12. Boyut: S.
  - Dosya: grev okuyucusuna tek satır.
  - Asset: asset gerekmedi.
- [ ] **SOY-35:** Husumet söylentiyle büyür (`husumet.gd`, `kan_davasi.gd`).
  - Ne: iki köylü arasındaki husumet, biri diğeri hakkında yanlış söylenti yaydığında +1; kan davası eşiği değişmez.
  - Kabul: yanlış söylenti kaynağı ve hedefi → husumet +1. Test: birim.
  - Bağımlılık: SOY-05. Boyut: S.
  - Dosya: husumet okuyucusuna tek satır.
  - Asset: asset gerekmedi.
- [ ] **SOY-36:** Pazar fiyatı söylentiye tepki verir (`ticaret_fiyatlari.gd`).
  - Ne: "kervan gelmeyecek" türü dış söylenti kamuoyu olunca pazar fiyat çarpanı bir gün +%10 (öneri); yanlışsa ertesi gün düzelir. Fiyat motoru değişmez.
  - Kabul: çarpan bir gün; DEN tablosunda. Test: birim.
  - Bağımlılık: SOY-12, DEN-01. Boyut: S.
  - Dosya: fiyat okuyucusuna tek satır; `denge.json`.
  - Asset: asset gerekmedi.
- [ ] **SOY-37:** Göç söylentisi (`goc_yolu_guvenligi.gd`).
  - Ne: "yol güvensiz" söylentisi kamuoyu olunca kapıya gelen sayısı o gece −1 (öneri); doğruysa ertesi gün de.
  - Kabul: gelen sayısı −1. Test: birim.
  - Bağımlılık: SOY-12. Boyut: S.
  - Dosya: kuyruk adaptörüne tek satır.
  - Asset: asset gerekmedi.

### 37.8 Veri ve ölçüm

- [ ] **SOY-38:** Ağ sayıları tek dosyadadır.
  - Ne: yayılım hızı, bozulma oranı, kamuoyu eşiği, ömür, bar etkisi `data/soylenti.json`; DEN-01 tablosu bu dosyayı okur.
  - Kabul: `.gd` içinde sayı sabiti 0. Test: tarama.
  - Bağımlılık: DEN-01. Boyut: S.
  - Dosya: yeni: `data/soylenti.json`.
  - Asset: asset gerekmedi.
- [ ] **SOY-39:** Söylenti yoğunluğu ölçülür.
  - Ne: 30 gecelik koşuda gece başına canlı söylenti sayısı, kamuoyu konusu sayısı, yanlış oranı raporlanır; hedef canlı ≤ 3, kamuoyu ≤ 1 (öneri).
  - Kabul: rapor DEN raporunun satırıdır. Test: runner.
  - Bağımlılık: DEN-05. Boyut: S.
  - Dosya: `tools/python_test_runner.py`.
  - Asset: asset gerekmedi.
- [ ] **SOY-40:** Küçük köyde ağ susar.
  - Ne: nüfus < 5 iken yayılım yoktur (duyan = tanık); kamuoyu konusu olmaz. BUG-16 ön koşul kuralı burada da geçerlidir.
  - Kabul: nüfus 4'te kamuoyu 0. Test: birim.
  - Bağımlılık: BUG-16. Boyut: S.
  - Dosya: `src/sistemler/soylenti_agi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SOY-41:** İkiz koşu.
  - Ne: aynı tohumla iki koşuda yayılım günlüğü eşit (RNG tek kaynaktan, `_rng_donus` kalıbı).
  - Kabul: iki günlük eşit. Test: TST-06.
  - Bağımlılık: TST-06. Boyut: S.
  - Dosya: yeni: `tests/oto/soylenti_ikiz_kontrol.tscn`.
  - Asset: asset gerekmedi.
- [ ] **SOY-42:** Kayıt göçü.
  - Ne: ağ alanları optional; eski kayıt açılınca DIY-13 kayıtları kaynaksız sayılır, ağ sıfırdan başlar; oyun çökmez.
  - Kabul: eski kayıt KAY testi. Test: KAY zinciri.
  - Bağımlılık: KAY-04. Boyut: S.
  - Dosya: `src/sistemler/soylenti_agi.gd` `yukle`.
  - Asset: asset gerekmedi.

### 37.9 Yazım

- [ ] **SOY-43:** "Duydum ki" kalıpları şablon dilbilgisidir (YAZ-09).
  - Ne: söylenti satırı şablonu `{kaynak} dedi, {olay}` değil; her karakter kendi ağzından söyler, şablon yalnız olay alanlarını doldurur. USLUP §1 yapay kalıp listesi geçerlidir.
  - Kabul: aynı olay için iki karakterde iki farklı cümle yapısı. Test: inceleme.
  - Bağımlılık: YAZ-09. Boyut: S.
  - Dosya: Söz dosyaları.
  - Asset: asset gerekmedi.
- [ ] **SOY-44:** Yanlış söylentinin bozulma biçimi yazılıdır.
  - Ne: SOY-05 bozulması üç biçimden biri: ad kayması, yer kayması, abartı; her biçimin metin kalıbı `fisilti_gazetesi.json` kalıplarına paralel.
  - Kabul: üç biçim üç kalıp. Test: birim.
  - Bağımlılık: SOY-05. Boyut: S.
  - Dosya: `data/soylenti.json` kalıpları.
  - Asset: asset gerekmedi.
- [ ] **SOY-45:** Kaynak adı yalnız köyde var olan kişidir (BUG-17 ile aynı kural).
  - Ne: `kaynak` köy listesinde yoksa satır basılmaz; uydurma ad yok.
  - Kabul: ölen kaynaklı satır 0. Test: birim.
  - Bağımlılık: BUG-17. Boyut: S.
  - Dosya: `src/sistemler/soylenti_agi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SOY-46:** Köy sohbeti söylentiyi okur (YAZ-08).
  - Ne: YAZ-08 köylü sohbetleri canlı söylentiyi konu alabilir; iki köylü aynı olayı farklı söyler (DNY-02 kuralı).
  - Kabul: sohbette söylenti konusu varken iki satır farklı. Test: inceleme.
  - Bağımlılık: YAZ-08. Boyut: S.
  - Dosya: YAZ-08 konu tablosu.
  - Asset: asset gerekmedi.

### 37.10 Sınırlar ve kapanış

- [x] **SOY-47:** (Claude) Gazete ve dedikodu motoru değişmez.
  - Ne: `fisilti_gazetesi.gd`, `dedikodu.gd`, `batil_inanc_histerisi.gd` imzaları aynı; ağ onların kaydını okur, alan ekler.
  - Kabul: `api_sozlesmesi.py` farkı 0. Test: araç.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `tools/api_sozlesmesi_baseline.json`.
  - Asset: asset gerekmedi.
- [ ] **SOY-48:** İkinci dedikodu kaydı yoktur.
  - Ne: ağ, DIY-13 kaydını genişletir; ayrı `soylenti` kaydı tutmaz.
  - Kabul: kayıt JSON'unda iki ayrı dedikodu listesi 0. Test: tarama.
  - Bağımlılık: SOY-01. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [x] **SOY-49:** (Claude — kapsam bekçisi) Söylenti seslendirilmez, baloncuk çizilmez.
  - Ne: ses dosyası ve 3B baloncuk yok (SOY-31).
  - Kabul: `assets/ses/` sayısı değişmez. Test: sayım.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **SOY-50:** Kapanış testi.
  - Ne: tek koşu: tanıklı rüşvet → 3 gece yayılım → kamuoyu → bar −1 bir kez → meclis şikâyeti → divan hükmü → kamuoyu 0; yanlış kopya → kaynak güvenilirliği −1.
  - Kabul: yedi adım tek testte. Test: `tests/unit/kvr/soylenti_agi_test.gd`.
  - Bağımlılık: SOY-01…49. Boyut: M.
  - Dosya: yeni: `tests/unit/kvr/soylenti_agi_test.gd`.
  - Asset: asset gerekmedi.

Alt başlıklarda madde sayısı dört ile altı arasındadır; onuncu madde her yerde DIY-13 ya da KOP-05'te duran bir kuralı ikinci kez yazacağı için konmadı. Toplam 50 madde.


---

## BÖLÜM 38: Gece, kapı dışı ve özel olaylar


Faz 5 (DNY ve KAP-16 ile birlikte). Zemin:

- Gece sonu kartı `src/veri/olay_verisi.gd` (`id`, `baslik_anahtari`, `metin_anahtari`, `kosullar`, `agirlik`, `tek_sefer`, `secenek_anahtarlari`, `secenek_etkileri`, `ses`, `muzik`). Koşul anahtarları: `gece_min/max`, `perde`, `koyde[]`, `ayrildi[]`, `bayrak[]`, `bayrak_yok[]`, `nufus_min`, `sinif_min{}`, `ambar_max`, `akce_min`, `yapi_min{}`, `bar_max{}`, `sans`.
- `data/olaylar/` 34 kart: `ahi_haber`, `aydogdu_oba`, `ayse_tezgah`, `bebek`, `bey_daveti`, `dervis`, `dugun`, `ertugrul_haberi`, `harman`, `hasan_defter`, `hirsizlik`, `kacak_koylu`, `karaca_ocak`, `kervan`, `kitlik`, `kurt`, `miraen_cavus`, `mogol_duman`, `nogay_haber`, `okculuk`, `pazar_gunu`, `salgin`, `saruca_tohum`, `sorhan_damga`, `sur_catlak`, `tarla_cekirge`, `tarla_don`, `tarla_kuraklik`, `tarla_yagmur`, `tekfur_elcisi`, `thessra_afyon`, `vergi_tahsildari`, `yangin`, `yusuf_keci`.
- Sıra olayları `data/sira_olaylari/`: `sira_atlama`, `sira_bayilma`, `sira_kavga`, `sira_panik`, `sira_vazgecen`; adaptör `src/kapi/sira_atlama_adaptoru.gd`. BUG-19/20 kişi ve sonuç bağını yazar.
- Olasılıklar `data/ayarlar/oyun.tres`: `olay_olasiligi 0.75`, `sira_olay_olasiligi 0.35`.
- Boş gün KAP-16, boş günün köyde keyfi SEV-01, olay ön koşulu BUG-16, nüfus katmanı KAP-19, cenaze akışı KRI-05, gece raporu `gece_bilancosu.gd`.
- Kodda olay kartını Söz motoruna bağlayan, boş günü sahneye çeviren veya gece kapı dışı bir evre açan bir katman yoktur.

Bu bölüm `OlayVerisi` şemasını değiştirmez, 34 kartı silmez, KRI-05 cenazesini yeniden kurmaz. Kartları Söz, defter ve boş güne bağlar; şemaya uyan en çok iki yeni kart ekler (kadı, âşık). Ses ve müzik alanları durur, yeni ses üretilmez (R2 seslendirme yasağı).

Kimlikler OZL-01 … OZL-35. Asset üretilmez. Yeni dosya + ince adaptör. Bitince `[x]` ve ajan adı.

**Madde biçimi:** Ne, Kabul, Bağımlılık + Boyut, Dosya, Asset.

---

### 38.1 Var olan kart — şema aynı, bağ yeni

- [x] **OZL-01:** Olay seçici BUG-16'dan geçer, ikinci seçici yoktur. (Antigravity)
  - Ne: gece sonu kartı mevcut seçiciden gelir; BUG-16 koşulu (`bina_var`, `nufus_en_az`, `cocuk_var`, `yas_grubu`) ve KAP-19 katmanı okunur. Bu bölüm yeni havuz yazmaz.
  - Kabul: `olay_secici` adlı ikinci dosya 0. Test: tarama.
  - Bağımlılık: BUG-16, KAP-19. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [x] **OZL-02:** Kart metni Söz dalına düşebilir. (Antigravity)
  - Ne: seçilen kartın `id` değeri DIY-09 bağlamına `olay.<id>` anahtarı olarak girer; kapıda veya köyde o olayı anan kişi (tanık, eş, dönen yüz) ilgili dalı açar. Kart metni CSV'de kalır, ikinci kopya yazılmaz.
  - Kabul: kart gecesi + tanık → dal 1; kart yokken 0. Test: iki gece.
  - Bağımlılık: DIY-09. Boyut: S.
  - Dosya: yeni: `src/sistemler/olay_soz_bagi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OZL-03:** Kart seçimi deftere düşer.
  - Ne: oyuncunun kart seçeneği Bölüm 39 defterine "olay, gece, seçenek" satırı yazar; etki `secenek_etkileri` ile aynıdır, ikinci etki tablosu yoktur.
  - Kabul: seçim gecesi defter satırı 1. Test: defter.
  - Bağımlılık: HFZ-01. Boyut: S.
  - Dosya: defter adaptörü tek satır.
  - Asset: asset gerekmedi.
- [x] **OZL-04:** `tek_sefer` kartı ikinci kez gelmez. (Antigravity)
  - Ne: şemanın `tek_sefer` alanı korunur; bu bölüm onu ezer bir "tekrar izin" yazmaz.
  - Kabul: `dervis`, `dugun` tek_sefer ise 30 gecede en çok 1. Test: runner.
  - Bağımlılık: OZL-01. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [x] **OZL-05:** Kart yoksa gece kilitlenmez. (Antigravity)
  - Ne: BUG-16 havuzu boşsa (kural 2) kart çıkmaz; rapor "bu gece köy sessiz" satırı yazar, oyun devam eder.
  - Kabul: havuz boş + `olay_olasiligi` 1 olsa bile kart 0, faz geçer. Test: boş havuz.
  - Bağımlılık: BUG-16. Boyut: S.
  - Dosya: `gece_bilancosu.gd` adaptörü tek satır.
  - Asset: asset gerekmedi.

### 38.2 Sıra olayları — kapıda, kuyrukta

- [x] **OZL-06:** (Claude) Beş sıra olayı BUG-19/20 ile bağlanır, altıncı tür açılmaz.
  - Ne: `sira_atlama`, `sira_bayilma`, `sira_kavga`, `sira_panik`, `sira_vazgecen` durur. Yeni sıra kartı bu bölümde yazılmaz.
  - Kabul: `data/sira_olaylari/` dosya sayısı 5. Test: sayım.
  - Bağımlılık: BUG-19, BUG-20. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [x] **OZL-07:** Sıra olayı Söz dalını açar. (Antigravity)
  - Ne: kuyruktaki kişinin Söz dosyasında `sira.<id>` dalı varsa (bayılma yardımı, kavga ayırma) kartın yanında o dal bir kez sorulur; yoksa kart tek başına kalır.
  - Kabul: dalı olan kişide 1, olmayanda kart-only. Test: iki kişi.
  - Bağımlılık: DIY-03, OZL-06. Boyut: M.
  - Dosya: `src/sistemler/olay_soz_bagi.gd`; `sira_atlama_adaptoru.gd` tek satır.
  - Asset: asset gerekmedi.
- [ ] **OZL-08:** Sıra olayı boş günde (KAP-16) çıkmaz.
  - Ne: KAP-16 boş gününde kuyruk yoktur; `sira_olay_olasiligi` o gece 0 okunur.
  - Kabul: boş günde sıra olayı 0. Test: KAP-16 gecesi.
  - Bağımlılık: KAP-16. Boyut: S.
  - Dosya: sıra seçicine tek satır.
  - Asset: asset gerekmedi.

### 38.3 Boş gün — kapı kapalı, köy açık

- [ ] **OZL-09:** Boş gün SEV-01'dir, ikinci boş gün sistemi yoktur.
  - Ne: KAP-16 üretir, SEV-01 köyde keyfe çevirir. Bu bölüm yalnız "boş günde kart havuzu"nu bağlar: kapı kartı 0, köy kartı (pazar_gunu, harman, dugun koşulu tutarsa) 1 olabilir.
  - Kabul: boş günde kapı kuyruğu 0, köy kartı koşulu tutarsa 1. Test: iki gece.
  - Bağımlılık: KAP-16, SEV-01. Boyut: S.
  - Dosya: yeni: `src/sistemler/bos_gun_olayi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OZL-10:** Boş günde âşık veya gezgin ozan gelebilir.
  - Ne: yeni kart `data/olaylar/asik.tres`, `OlayVerisi` şeması; koşul `nufus_min: 6`, `tek_sefer: false`, ağırlık düşük. Seçenek: dinle (moral +1, akçe 0) / gönder (etki 0). Mini oyun yok, ses üretilmez.
  - Kabul: nüfus 5'te 0, 6+'da çıkabilir; `secenek_etkileri` iki sözlük. Test: iki nüfus.
  - Bağımlılık: OZL-09, BUG-16. Boyut: S.
  - Dosya: `data/olaylar/asik.tres`; `metinler.csv` `olay.asik.*`.
  - Asset: asset gerekmedi (yer tutucu: duran köylü).
- [ ] **OZL-11:** Boş gün deftere "kapı yoktu" yazar.
  - Ne: HFZ defterine gece türü `bos_gun` satırı; gelen 0, kart varsa kart id.
  - Kabul: boş gün satırı 1. Test: defter.
  - Bağımlılık: HFZ-01, KAP-16. Boyut: S.
  - Dosya: defter adaptörü.
  - Asset: asset gerekmedi.

### 38.4 Takvim ve mevsim kartları

- [x] **OZL-12:** Tarla kartları mevsim okur, ikinci takvim açmaz. (Antigravity)
  - Ne: `tarla_yagmur`, `tarla_kuraklik`, `tarla_don`, `tarla_cekirge` mevcut `kosullar` ile durur; `takvim.gd` (`mevsim`, `kis_mi`) koşula bağlanır. Yeni mevsim sayacı yok (MEV-01 durur).
  - Kabul: kışta `tarla_yagmur` 0 (koşul yazılırsa); koşulsuz imza BUG-16 listesindedir. Test: dört mevsim.
  - Bağımlılık: BUG-16, MEV-01. Boyut: S.
  - Dosya: ilgili `.tres` `kosullar`.
  - Asset: asset gerekmedi.
- [x] **OZL-13:** `harman` ve `pazar_gunu` hafta başına bakabilir. (Antigravity)
  - Ne: `takvim.hafta_basi` true iken bu iki kartın ağırlığı artar (öneri `data/olay_agirlik.json`); kart id değişmez.
  - Kabul: hafta başı olmayan gecede ağırlık taban, başında çarpan. Test: 7 gece.
  - Bağımlılık: OZL-01. Boyut: S.
  - Dosya: yeni: `data/olay_agirlik.json`.
  - Asset: asset gerekmedi.
- [x] **OZL-14:** Kış odunu kartı yoktur. (Antigravity)
  - Ne: odun darlığı BUG-22 / DEN tablosudur; "kış odunu yok" diye yeni kart yazılmaz (32. bölüm sınırı).
  - Kabul: `olaylar/` içinde `kis_odun` id 0. Test: sayım.
  - Bağımlılık: DEN-01. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

### 38.5 Yaşam olayları — düğün, bebek, cenaze

- [x] **OZL-15:** `dugun.tres` KAP-19 ve BUG-16 ile bağlanır, tören motoru açılmaz. (Antigravity)
  - Ne: düğün kartı en az iki yetişkin hane ister (KAP-19 kural 3). Mini oyun, dans veya hediye takvimi yok.
  - Kabul: 3 kişilik köyde 30 gece `dugun` 0. Test: KAP-19 testi ile ortak.
  - Bağımlılık: KAP-19, BUG-16. Boyut: S.
  - Dosya: `data/olaylar/dugun.tres` koşul.
  - Asset: asset gerekmedi.
- [x] **OZL-16:** `bebek.tres` `cocuk_var` tersine bakmaz, `hane_var` ister. (Antigravity)
  - Ne: bebek kartı çocuk doğurur; koşul yetişkin çift / hane. KAP-17 çocuk modeli doğumda kullanılır, ikinci model yok.
  - Kabul: hanesiz köyde `bebek` 0. Test: birim.
  - Bağımlılık: KAP-17, BUG-16. Boyut: S.
  - Dosya: `data/olaylar/bebek.tres`.
  - Asset: KAP-17 çocuk. Yeni satır yok.
- [x] **OZL-17:** Ölüm KRI-05'e gider, yeni cenaze kartı yazılmaz. (Antigravity)
  - Ne: yangın, kurt, salgın, sıra ölümü (BUG-20) duran cenaze akışını çağırır. `cenaze.tres` diye ikinci kart yoktur.
  - Kabul: `data/olaylar/cenaze.tres` 0; ölüm → KRI-05 çağrı 1. Test: tarama + birim.
  - Bağımlılık: KRI-05, BUG-20. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [x] **OZL-18:** Cenaze gecesi HUD `cenaze_raporu.gd` okunur. (Antigravity)
  - Ne: `src/arayuz/koy_hud/cenaze_raporu.gd` durur; Söz bağında `olay.cenaze` anahtarı bu rapordan türetilir, yeni panel yok.
  - Kabul: cenaze gecesi rapor paneli 1, yeni dosya 0. Test: ekran.
  - Bağımlılık: KRI-05. Boyut: S.
  - Dosya: `olay_soz_bagi.gd` okuyucu.
  - Asset: asset gerekmedi.

### 38.6 Dış yüzler — kart ve kapı aynı kişi olmaz

- [ ] **OZL-19:** Heyet kartı ile kapı yüzü aynı gece çakışmaz.
  - Ne: `tekfur_elcisi`, `bey_daveti`, `vergi_tahsildari`, `aydogdu_oba`, `miraen_cavus` kartları, OMR-24 "bir gecede en çok bir dış hat yüzü" kuralına girer: o gece kapıda aynı id yüz olarak duruyorsa kart 0'dır.
  - Kabul: yüz + kart aynı id, aynı gece 0. Test: enjekte.
  - Bağımlılık: OMR-24. Boyut: S.
  - Dosya: `bos_gun_olayi.gd` değil; olay seçicine tek satır.
  - Asset: asset gerekmedi.
- [ ] **OZL-20:** Haber kartları DNY-02 ile tek kaynaktır.
  - Ne: `ertugrul_haberi`, `nogay_haber`, `mogol_duman`, `ahi_haber` yazılı haberdir; yüz gelmeden haber (OMR-36) bu kartlardan biri olabilir, ikinci haber kanalı açılmaz.
  - Kabul: aynı olay id için kart + haberci ağı satırı aynı gece en çok 1. Test: OMR-36 ile ortak.
  - Bağımlılık: DNY-02, OMR-36. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

### 38.7 Gece evresi — kapı kapandıktan sonra

- [ ] **OZL-21:** Gece evresi yeni faz değildir.
  - Ne: `oturum_fazi.gd` değerleri `kapi` / `koy` durur; üçüncü faz (`gece_devriye`) açılmaz. Nöbet NBT-09 oyuncunun köy ekranında kalmasıdır.
  - Kabul: faz enum'una yeni değer 0. Test: tarama.
  - Bağımlılık: NBT-09. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **OZL-22:** Nöbet tutulan gecede kart ertesi sabaha kayar.
  - Ne: oyuncu NBT-09 ile nöbetteyse gece kartı ertesi köy evresinde açılır; iki kart üst üste binmez.
  - Kabul: nöbet gecesi kart 0, ertesi köy evresi 1 (koşul tutarsa). Test: iki gece.
  - Bağımlılık: NBT-09, OZL-01. Boyut: S.
  - Dosya: olay seçicine tek satır.
  - Asset: asset gerekmedi.
- [x] **OZL-23:** (Claude — kapsam bekçisi) Gözcü kulesi gece olayı üretmez.
  - Ne: duran gözcü kulesi (R1) yalnız görüş mesafesidir; "kuleden görülen olay" diye kart yazılmaz.
  - Kabul: `olaylar/` içinde `kule` id 0. Test: sayım.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

### 38.8 Yeni kart — yalnız şemaya uyan, yalnız gerekçeli

- [ ] **OZL-24:** Kadı kartı.
  - Ne: `data/olaylar/kadi.tres`; koşul `nufus_min: 10`, `gece_min` BUG-18 tehdit süresinden sonra, `tek_sefer: true`. Seçenek: davayı dinle (divan CAS-07 oturumu açılır, kart divanı yeniden kurmaz) / geçiştir (adalet −1, `koy.tres harc_adalet` okunur). Kadı kapı yüzü değildir.
  - Kabul: nüfus 9'da 0; dinle → divan oturumu 1. Test: iki nüfus.
  - Bağımlılık: CAS-07, BUG-18, BUG-16. Boyut: M.
  - Dosya: `data/olaylar/kadi.tres`; `metinler.csv` `olay.kadi.*`.
  - Asset: asset gerekmedi (yer tutucu: duran köylü).
- [ ] **OZL-25:** Üçüncü yeni kart yoktur.
  - Ne: âşık (OZL-10) ve kadı (OZL-24) bu bölümün tavanıdır. "İleride lazım" kartı yazılmaz.
  - Kabul: bu dosyada `data/olaylar/` yeni id sayısı 2. Test: sayım.
  - Bağımlılık: OZL-10, OZL-24. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

### 38.9 Görünürlük ve yazım

- [x] **OZL-26:** (Claude) Kart metni `olay.` anahtarıdır (SYS-09).
  - Ne: yeni ve eski kartların `baslik_anahtari` / `metin_anahtari` / `secenek_anahtarlari` `olay.` önekine uyar; düz Türkçe `.tres` içinde yok.
  - Kabul: `tools/metin_dogrula.py --kaynak` olay katalogu 0 eksik. Test: araç.
  - Bağımlılık: SYS-09. Boyut: S.
  - Dosya: `data/metin/metinler.csv`.
  - Asset: asset gerekmedi.
- [ ] **OZL-27:** Kart USLUP §1'den geçer.
  - Ne: yeni iki kartın metni YAZ-10 yapaylık taramasından geçer; "köyünüzün geleceği" kalıbı yok.
  - Kabul: `olay.asik.*` ve `olay.kadi.*` ihlal 0. Test: YAZ-10.
  - Bağımlılık: YAZ-10. Boyut: S.
  - Dosya: CSV satırları.
  - Asset: asset gerekmedi.
- [x] **OZL-28:** (Claude — kapsam bekçisi) Kart HUD'u `BilgiEkrani` kadrajıdır, yeni sahne değildir.
  - Ne: gece kartı duran bilgi/olay kadrajında açılır; 3B tören sahnesi yok (SAH sınırı).
  - Kabul: `olay_sahnesi.tscn` 0. Test: tarama.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **OZL-29:** Olasılıklar `oyun.tres` / `denge.json` dışına çıkmaz.
  - Ne: `olay_olasiligi` ve `sira_olay_olasiligi` DEN-01 tablosuna taşınır (32 zaten ister); bu bölüm yeni sabit yazmaz.
  - Kabul: `.gd` içinde `0.75` / `0.35` olay sabiti 0. Test: tarama.
  - Bağımlılık: DEN-01. Boyut: S.
  - Dosya: `data/ayarlar/denge.json`.
  - Asset: asset gerekmedi.

### 38.10 Sınırlar ve kapanış

- [x] **OZL-30:** (Claude) `OlayVerisi` alan listesi değişmez.
  - Ne: yeni koşul veya etki anahtarı eklenmez; kadı "divan aç" etkisi mevcut `bayrak` / çağrı ile yapılır.
  - Kabul: `olay_verisi.gd` export alanı sayısı bu madde öncesi ile eşit. Test: `api_sozlesmesi.py`.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `tools/api_sozlesmesi_baseline.json`.
  - Asset: asset gerekmedi.
- [x] **OZL-31:** (Claude — kapsam bekçisi) Ses ve müzik üretilmez.
  - Ne: şemadaki `ses` / `muzik` alanları boş kalabilir; yeni wav/ogg yok. R2 seslendirme yasağı.
  - Kabul: `assets/ses/` sayısı değişmez. Test: sayım.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [x] **OZL-32:** (Claude — kapsam bekçisi) İkinci harita ve gece haritası yoktur.
  - Ne: bölge haritası (R1) durur; "gece dışarı çık" haritası açılmaz.
  - Kabul: `gece_haritasi` 0. Test: tarama.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [x] **OZL-33:** (Claude) 34 eski kart silinmez, id değişmez.
  - Ne: rename / delete yok; koşul alanı eklenebilir (BUG-16).
  - Kabul: 34 id listesi bu dosyanın zeminindedir; silinen 0. Test: sayım.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `data/olaylar/*.tres`.
  - Asset: asset gerekmedi.
- [ ] **OZL-34:** Kayıt göçü.
  - Ne: yeni kart id'leri eski kayıtta yoksa seçilmez; oyun çökmez.
  - Kabul: eski kayıt + yeni katalog açılır. Test: KAY zinciri.
  - Bağımlılık: KAY-04. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **OZL-35:** Kapanış testi.
  - Ne: tek koşu: BUG-16 boş havuz → kart 0; `dugun` küçük köyde 0; boş gün + âşık koşulu; kadı → divan; yüz+kart çakışması 0; KRI-05 ölüm yolu.
  - Kabul: altı iddia tek testte. Test: `tests/unit/olay/ozel_olay_test.gd`.
  - Bağımlılık: OZL-01…34. Boyut: M.
  - Dosya: yeni: `tests/unit/olay/ozel_olay_test.gd`.
  - Asset: asset gerekmedi.

Alt başlıklarda madde sayısı üç ile altı arasındadır; onuncu madde 34 kartın her birini yeniden tarif edeceği veya `OlayVerisi` şemasını şişireceği için konmadı. Toplam 35 madde. Yeni kart tavanı 2 (âşık, kadı).


---

## BÖLÜM 39: Karar sonuçlarının görünürlüğü ve hafıza defteri


Faz 2–3 (Söz kaydı yazılır yazılmaz). Zemin:

- "Bu hatırlanacak" bildirimi DIY-14; kararın dönüşü DYL-08; beyan defteri DIY-07 (`src` yolu o maddede); sabah defteri SAB-01; kişi hafızası DIY-11 (`karakter_kadrosu.gd durumlar`); grup itibarı DIY-12.
- Gece raporu `src/sistemler/gece_bilancosu.gd`; son ekranı `ana.gd:125` dört sayı (gün, kabul, ret, nüfus); oda teftiş notu `oda_teftis_notu.gd`; muhafız epilogu `muhafiz_epilogu_sunumu.gd`.
- Kodda oyuncunun geçmiş kararlarını sayfa sayfa okuduğu tek bir hafıza defteri yoktur (`rg -i 'hafiza_defteri|karar_defteri'` src → 0; beyan defteri sorgu-içi ve DIY-07'nindir).

Bu bölüm kayıt alanlarını yeniden tanımlamaz. DIY-07, DIY-11, DIY-14, DYL-08, SAB-01 ve SOY-29'un yazdığı satırları tek okuma yüzeyinde toplar. Kalp puanı, romans, "ilişki barı" yok.

Kimlikler HFZ-01 … HFZ-32. OGR-10, SOY-29, HAN-21, OZL-03/11 bu çekirdeği (HFZ-01) bekler. Asset üretilmez; defter kabuğu ARY-02 temasını okur. Bitince `[x]` ve ajan adı.

**Madde biçimi:** Ne, Kabul, Bağımlılık + Boyut, Dosya, Asset.

---

### 39.1 Çekirdek — tek defter, dört sayfa

- [ ] **HFZ-01:** Hafıza defteri çekirdeği.
  - Ne: oyuncunun okuduğu tek defter. Sayfalar: Karar, Beyan, Söylenti, Not. Veri kaynağı mevcut kayıtlardır; defter ikinci bir olay günlüğü tutmaz.
  - Kabul: dört sayfa; sayfa verisi DIY-14 / DIY-07 / SOY-29 / OGR-10 okuyucusudur. Test: dört okuyucu, yazım 0 (defter yazmaz).
  - Bağımlılık: DIY-14, DIY-07. Boyut: M.
  - Dosya: yeni: `src/sistemler/hafiza_defteri.gd`; yeni: `src/arayuz/hafiza_defteri_ekrani.gd`.
  - Asset: asset gerekmedi. Kabuk ARY-02.
- [ ] **HFZ-02:** Defter kaydı optional alandır.
  - Ne: oyun kaydına `hafiza.okunan` (hangi satırlar görüldü) yazılır; satırların kendisi kaynak sistemlerindir. Eski kayıtta alan yoksa boş sayılır.
  - Kabul: alan silinmiş kayıt açılır, çökmez. Test: KAY birimi.
  - Bağımlılık: KAY-04, HFZ-01. Boyut: S.
  - Dosya: `hafiza_defteri.gd` `kaydet` / `yukle`.
  - Asset: asset gerekmedi.
- [ ] **HFZ-03:** Defter oyunu durdurur, hızı değiştirmez.
  - Ne: açılınca `koy_ekrani` hızı saklanır (divan_baglantisi kalıbı: `divan_baglantisi.gd:16`); kapanınca aynı değere döner. `Engine.time_scale` defter kodunda yazılmaz.
  - Kabul: açıkken hız değişmez, kapandıktan sonra önceki hız. Test: hız 2'de aç/kapa.
  - Bağımlılık: HFZ-01. Boyut: S.
  - Dosya: `hafiza_defteri_ekrani.gd`.
  - Asset: asset gerekmedi.
- [ ] **HFZ-04:** Defter kapı ve köyde aynı dosyadır.
  - Ne: ikinci bir "kapı defteri" ekranı açılmaz; `kapi_ekrani.gd` sağdaki DEFTER dikdörtgeni (satır 13, `Rect2(1172, 104, 716, 952)`) sorgu defteridir, bu maddenin defteri değildir.
  - Kabul: sınıf adı `HafizaDefteriEkrani` bir kez. Test: tarama.
  - Bağımlılık: HFZ-01. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

### 39.2 Karar sayfası

- [ ] **HFZ-05:** Karar satırı DIY-14 ve DYL-08'dan gelir.
  - Ne: "Bu hatırlanacak" tetiklenen her seçim bir satır: kişi, gece, kısa sonuç (DYL-08 döndüğünde güncellenir). Metin DIY-14'ün notudur, burada yeniden yazılmaz.
  - Kabul: DIY-14 tetik 1 → satır 1; tetik 0 → satır 0. Test: iki sorgu.
  - Bağımlılık: DIY-14, DYL-08. Boyut: S.
  - Dosya: `hafiza_defteri.gd` okuyucu.
  - Asset: asset gerekmedi.
- [ ] **HFZ-06:** Kapı kabul/ret her satır değildir.
  - Ne: her kabul/ret deftere düşmez; yalnız DIY-14 işaretlisi ve DYL-08 dönüşü. Aksi halde defter 30 günde okunmaz olur.
  - Kabul: 10 adsız kabul, DIY-14 yok → karar satırı 0. Test: on kabul.
  - Bağımlılık: HFZ-05. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **HFZ-07:** Divan hükmü karar sayfasına bir satırdır.
  - Ne: CAS-07 hükmü (suçlu/değil, ceza) bir satır; SAB-01 sabah satırı ile aynı olay, iki kopya değil (SAB-01 okunur).
  - Kabul: bir hüküm → karar satırı 1, sabah kopyası 0. Test: hüküm.
  - Bağımlılık: CAS-07, SAB-01. Boyut: S.
  - Dosya: okuyucu.
  - Asset: asset gerekmedi.
- [ ] **HFZ-08:** Omurga yüzü kararı işaretlenir.
  - Ne: OMR hat yüzü (sancak, tekfur, Moğol, oba) kararı DIY-14 listesine zaten giriyorsa satır "dış hat" etiketi alır; yeni sayaç yok.
  - Kabul: etiket metin, sayı değil. Test: bir yüz.
  - Bağımlılık: OMR-24, HFZ-05. Boyut: S.
  - Dosya: okuyucu.
  - Asset: asset gerekmedi.

### 39.3 Beyan ve söylenti sayfaları

- [ ] **HFZ-09:** Beyan sayfası DIY-07 defteridir.
  - Ne: bu ziyaretin ve önceki ziyaretlerin beyan satırları; çelişki çifti (DYL-01) işaretli. DIY-07 veri modeli değişmez.
  - Kabul: sayfa DIY-07 kayıt sayısıyla eşit. Test: iki ziyaret.
  - Bağımlılık: DIY-07, DYL-01. Boyut: S.
  - Dosya: okuyucu.
  - Asset: asset gerekmedi.
- [ ] **HFZ-10:** Söylenti sayfası SOY-29'dur.
  - Ne: canlı söylenti: olay, kaynak, kademe (birkaç / yarı köy / herkes), doğrulandı mı. Ağ kaydı SOY-01'indir.
  - Kabul: sayfa ağ kaydıyla eşit. Test: SOY-29 ile ortak.
  - Bağımlılık: SOY-29. Boyut: S.
  - Dosya: okuyucu.
  - Asset: asset gerekmedi.
- [ ] **HFZ-11:** Not sayfası son beş ipucudur (OGR-10).
  - Ne: `ogretici.gorulen` son beş kimliğin metni; altıncı düşer.
  - Kabul: altı ipucu sonrası satır 5. Test: OGR-10 ile ortak.
  - Bağımlılık: OGR-10. Boyut: S.
  - Dosya: okuyucu.
  - Asset: asset gerekmedi.
- [ ] **HFZ-12:** Eş duyumu not veya söylentiye düşer, üçüncü sayfa açmaz.
  - Ne: HAN-21 duyum satırı söylenti sayfasındadır (kaynak = eş); ayrı "Hane" sayfası yoktur.
  - Kabul: sayfa sayısı 4 kalır. Test: sayım.
  - Bağımlılık: HAN-21. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

### 39.4 Açılış ve gezinme

- [ ] **HFZ-13:** Köy HUD'dan açılır.
  - Ne: köy ekranında tek düğme / kısayol (GIR-03 adı); kapıda sorgu evresinde kapalıdır (sorgu defteriyle karışmasın).
  - Kabul: `evre == sohbet|karar` iken düğme 0; köyde 1. Test: iki ekran.
  - Bağımlılık: GIR-03. Boyut: S.
  - Dosya: `koy_ekrani.gd` tek satır; `kapi_ekrani.gd` çağrı 0.
  - Asset: asset gerekmedi.
- [ ] **HFZ-14:** Duraklat menüsünden açılır.
  - Ne: `ana.gd _duraklat` (satır 149) dördüncü satır "Defter"; mevcut üç satır (devam, ayarlar, menü) yerinde kalır.
  - Kabul: düğme sayısı 4; menüye dönüş 3. sırada kalır. Test: ekran.
  - Bağımlılık: HFZ-01. Boyut: S.
  - Dosya: `ana.gd` `_duraklat` tek satır.
  - Asset: asset gerekmedi.
- [ ] **HFZ-15:** Sayfa gezinmesi `ui_*` ve kısayoldur.
  - Ne: sekme veya 1–4 (GIR `kisayol_1…4`); `geri` kapatır (`ana.gd:240`).
  - Kabul: `geri` ile kapanır, odak ilk sayfadadır. Test: klavye.
  - Bağımlılık: GIR-01. Boyut: S.
  - Dosya: `hafiza_defteri_ekrani.gd`.
  - Asset: asset gerekmedi.
- [ ] **HFZ-16:** Boş sayfa metni vardır.
  - Ne: satır yokken "henüz bir şey yazılmadı" (`hafiza.bos.*`); pembe anahtar yok.
  - Kabul: yeni oyunda dört boş metin CSV'de. Test: `metin_dogrula.py`.
  - Bağımlılık: SYS-09. Boyut: S.
  - Dosya: `metinler.csv`.
  - Asset: asset gerekmedi.

### 39.5 Filtre ve okunurluk

- [ ] **HFZ-17:** Satırlar geceden yeniye sıralanır.
  - Ne: varsayılan sıra `gece` azalan; kişi adına göre süzme tek alan.
  - Kabul: süzme sonrası yabancı kişi 0. Test: iki kişi.
  - Bağımlılık: HFZ-01. Boyut: S.
  - Dosya: `hafiza_defteri.gd`.
  - Asset: asset gerekmedi.
- [ ] **HFZ-18:** Okunmuş satır soluk (AYR-10 ile aynı anahtar).
  - Ne: `okunmus_isaret` açıksa görülen satır soluk; kapalıysa hepsi aynı. AYR-10 Söz seçeneği içindir, bu madde defter satırı içindir, aynı ayar anahtarı.
  - Kabul: anahtar kapalıyken soluk 0. Test: iki ayar.
  - Bağımlılık: AYR-10. Boyut: S.
  - Dosya: `hafiza_defteri_ekrani.gd`.
  - Asset: asset gerekmedi.
- [ ] **HFZ-19:** Metin ölçeği `ayarlar.boyut()` okur.
  - Ne: defter puntoları `tema.gd` + `metin_olcegi`; yerel punto yok.
  - Kabul: ölçek 150'de tarama yerel punto 0. Test: ARY-02 tarama.
  - Bağımlılık: ARY-02. Boyut: S.
  - Dosya: ekran.
  - Asset: asset gerekmedi.

### 39.6 Sabah ve yıl ile sınır

- [ ] **HFZ-20:** SAB-01 sabah satırı deftere kopyalanmaz.
  - Ne: sabah defteri SAB-01 ekranıdır; HFZ onu okur (HFZ-07) ama sabah akışını değiştirmez.
  - Kabul: sabah evresinde HFZ otomatik açılmaz. Test: gece sonu.
  - Bağımlılık: SAB-01. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **HFZ-21:** YIL izi defter sayfası değildir.
  - Ne: yılın izi Bölüm 30'dadır; HFZ "mevsim özeti" sayfası açmaz.
  - Kabul: sayfa 4. Test: sayım.
  - Bağımlılık: YIL-01. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [x] **HFZ-22:** (Claude — kapsam bekçisi) Son ekranı defteri açmaz.
  - Ne: `ana.gd _son_goster` epilog + dört istatistiktir; defter son ekranına gömülmez. İstatistik genişlemesi SRM-08'dedir.
  - Kabul: son ekranında `HafizaDefteriEkrani` 0. Test: tarama.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

### 39.7 Yazım

- [ ] **HFZ-23:** Satır başlığı kişi adıdır, sistem jargonu değildir.
  - Ne: "DIY-14 tetik" diye yazılmaz; "Hasan — üçüncü gece" yazılır. Anahtar `hafiza.satir.*`.
  - Kabul: oyuncu yüzünde `DIY-` / `HFZ-` 0. Test: tarama.
  - Bağımlılık: YAZ-02. Boyut: S.
  - Dosya: `metinler.csv`.
  - Asset: asset gerekmedi.
- [ ] **HFZ-24:** Ölü / ayrılmış kişi adı çizilmez, satır kalır.
  - Ne: kişi köyden gittiyse ad "gitti" işaretli kalır; uydurma ad yok (BUG-17 kuralı).
  - Kabul: ölü id → ad mevcut kayıt adı, yeni ad 0. Test: ölüm sonrası defter.
  - Bağımlılık: BUG-17. Boyut: S.
  - Dosya: okuyucu.
  - Asset: asset gerekmedi.

### 39.8 Debug ve ölçüm

- [ ] **HFZ-25:** Debug satır enjektörü.
  - Ne: `src/debug/` ile sahte karar satırı; oyuncu sürümünde kapalı (SRM-05).
  - Kabul: debug kapalıyken enjektör 0. Test: tarama.
  - Bağımlılık: SRM-05. Boyut: S.
  - Dosya: yeni: `src/debug/hafiza_enjektoru.gd`.
  - Asset: asset gerekmedi.
- [ ] **HFZ-26:** Defter satır tavanı.
  - Ne: karar sayfası en çok 40 satır (öneri, `data/hafiza.json`); eski satır düşer, kaynak sistem kaydı silinmez.
  - Kabul: 41. satırda görünen 40. Test: enjekte.
  - Bağımlılık: HFZ-01. Boyut: S.
  - Dosya: `data/hafiza.json`.
  - Asset: asset gerekmedi.

### 39.9 Bağımlı okuyucular — bu bölüm yazmaz

- [ ] **HFZ-27:** OGR-10 yalnız okur.
  - Ne: ipucu kimliği `ipucu_kaydi.gd`'dedir; defter kopyalamaz.
  - Kabul: ipucu yazımı `hafiza_defteri.gd` içinde 0. Test: tarama.
  - Bağımlılık: OGR-10. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **HFZ-28:** SOY-29 yalnız okur.
  - Ne: ağ kaydı `soylenti_agi.gd`'dedir.
  - Kabul: söylenti yazımı defterde 0. Test: tarama.
  - Bağımlılık: SOY-29. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **HFZ-29:** OZL-03 yalnız okur.
  - Ne: kart seçimi olay kaydındadır.
  - Kabul: olay yazımı defterde 0. Test: tarama.
  - Bağımlılık: OZL-03. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

### 39.10 Sınırlar ve kapanış

- [x] **HFZ-30:** (Claude — kapsam bekçisi) İlişki barı, kalp, hediye yok.
  - Ne: karar kaydı yasağı; defter sayısal "sevgi" göstermez.
  - Kabul: `kalp|romans|hediye` anahtarı 0. Test: tarama.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [x] **HFZ-31:** (Claude) Çekirdek imzalar.
  - Ne: `oturum.gd`, `karakter_kadrosu.gd`, `kapi_ekrani.gd` değişmez; `ana.gd` yalnız `_duraklat` satırı.
  - Kabul: `api_sozlesmesi.py` farkı yalnız izinli satır. Test: araç.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: baseline.
  - Asset: asset gerekmedi.
- [ ] **HFZ-32:** Kapanış testi.
  - Ne: tek koşu: DIY-14 satırı → defter; boş yeni oyun dört boş sayfa; duraklat açar; kapıda kapalı; eski kayıt alan yok.
  - Kabul: beş iddia. Test: `tests/unit/sistemler/hafiza_defteri_test.gd`.
  - Bağımlılık: HFZ-01…31. Boyut: M.
  - Dosya: yeni test.
  - Asset: asset gerekmedi.

Alt başlıklarda madde sayısı üç ile dört arasındadır; onuncu madde DIY-07 veya DIY-14 kuralını ikinci kez yazacağı için konmadı. Toplam 32 madde.


---

## BÖLÜM 40: Diyalog kalite güvencesi ve yazım hattı


Faz 3 (YAZ-04…10 ve DYL-11…16 ile birlikte). Zemin:

- Yazım hattı YAZ-01…10 (dünya kitabı, üslup, üretim, doğrulama, kota, satır inceleme).
- Yazım araçları 25.3: DYL-11 kör okuma, DYL-12 muhafız tipi tarama, DYL-13 eski/yeni yan yana, DYL-14 kaynaklı örnek, DYL-15 sitede düzenleme, DYL-16 prototip `--check`.
- Prototip `Roadmap-2/soz_agaci/yapaylik.js`, `motor.js`, `sahne_recber.js`. Oyun tarafı `tools/metin_dogrula.py`, `docs/METIN_ANAHTAR_STANDARDI.md`.
- Tester planı K7: diyalog kalitesi elle; otomatik yapaylık taraması yok. TST-0002 (6 eksik anahtar), TST-0006 (çift boşluk, yinelenen tekfur metni) AÇIK.
- Kodda `data/soz/` üretim kapısı ve CI yapaylık adımı yoktur (YAZ-04 onları tanımlar; bu bölüm kapıyı ölçülebilir kılar).

Bu bölüm DYL-11…16'yı kopyalamaz, YAZ maddelerini yeniden yazmaz. Onların çıktısını kabul ölçütüne, tarama sırasına ve "oyuna girer / girmez" kararına bağlar. Yeni diyalog içeriği buradan üretilmez.

Kimlikler KLT-01 … KLT-75. Bitince `[x]` ve ajan adı.

**Madde biçimi:** Ne, Kabul, Bağımlılık + Boyut, Dosya, Asset.

---

### 40.1 Hattın sırası — oyuna girmeden önce

- [ ] **KLT-01:** Üretim sırası tek belgededir.
  - Ne: sıra sabittir: YAZ-01 kitap → taslak → YAZ-10 yapaylık → DYL-11 kör okuma → YAZ-09 kota → insan onayı → YAZ-04 `data/soz/`. Sıra atlanırsa dosya oyuna alınmaz.
  - Kabul: `docs/soz/HAT.md` içinde sıra; atlanan adımlı dosya YAZ-04 tarafından reddedilir. Test: onaysız dosya 0 kopya.
  - Bağımlılık: YAZ-04, YAZ-10, DYL-11. Boyut: S.
  - Dosya: yeni: `docs/soz/HAT.md`.
  - Asset: asset gerekmedi.
- [ ] **KLT-02:** Onay iki isimdir (YAZ-01 kural 4).
  - Ne: anlatı yönetmeni + Ahmet; tek isim yetmez. Bu madde ikinci onay süreci açmaz.
  - Kabul: tek isimli dosya reddedilir. Test: YAZ-04. Taşınan: KLT-49: İki isimden biri boşsa red.
  - Bağımlılık: YAZ-01. Boyut: S.
  - Dosya: `HAT.md`.
  - Asset: asset gerekmedi.
- [ ] **KLT-03:** Şablon sır dayatmaz (DIY-01a).
  - Ne: kapı denetimi `soz` dosyasında `sira` alanı yoksa kabul; varsa ve zorunluysa red. DIY-01a kuralı burada ölçülür.
  - Kabul: zorunlu sırası olan dosya 1 hata. Test: birim.
  - Bağımlılık: DIY-01a. Boyut: S.
  - Dosya: yeni: `tools/soz_kapi.py`.
  - Asset: asset gerekmedi.

- [ ] **KLT-26:** Adım kutusu tek dosyadır
  - Ne: Adım kutusu tek dosyadır. Geçen adım `HAT.md` kutusuna yazılır.
  - Kabul: Kutusuz kopya 0. Test: kapı.
  - Bağımlılık: KLT-01. Boyut: S.
  - Dosya: `docs/soz/HAT.md`
  - Asset: asset gerekmedi.
- [ ] **KLT-27:** Sebepsiz adım atlama reddedilir
  - Ne: Sebepsiz adım atlama reddedilir. Atlama satırında sebep yoksa kopya yoktur.
  - Kabul: Sebepsiz 1 hata. Test: fixtures.
  - Bağımlılık: KLT-01. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.
- [ ] **KLT-28:** Kapı Godot başlatmaz
  - Ne: Kapı Godot başlatmaz. Doğrulayıcı oyun sürecini açmaz.
  - Kabul: Süreç 0. Test: tarama.
  - Bağımlılık: KLT-01. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.
- [x] **KLT-29:** (Claude) Kapı anahtar silmez
  - Ne: Kapı anahtar silmez. CSV'den satır silinmez.
  - Kabul: Silinen 0. Test: diff.
  - Bağımlılık: SYS-09. Boyut: S.
  - Dosya: `data/metin/metinler.csv`
  - Asset: asset gerekmedi.
- [ ] **KLT-30:** Hata kopyayı keser, uyarı kesmez
  - Ne: Hata kopyayı keser, uyarı kesmez. İki seviye karışmaz.
  - Kabul: Hata 0 kopya, uyarı 1 kopya. Test: fixtures.
  - Bağımlılık: KLT-04. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.

### 40.2 Otomatik taramalar — DYL araçlarını çağırır

- [ ] **KLT-04:** Yapaylık taraması CI adımıdır.
  - Ne: `yapaylik.js` kuralları (USLUP §1) `tools/soz_kapi.py` içinden çağrılır; ihlal 0 olmadan `data/soz/` kopyalanmaz. DYL-16 `--check` aynı dosyayı kullanır, ikinci kural seti yok.
  - Kabul: bilinen yasak kalıp 1 hata. Test: fixtures.
  - Bağımlılık: YAZ-10, DYL-16. Boyut: M.
  - Dosya: `tools/soz_kapi.py`.
  - Asset: asset gerekmedi.
- [ ] **KLT-05:** Kör okuma skoru kayda geçer (DYL-11).
  - Ne: DYL-11 testi yapılmadan karakter dosyası "hazır" olmaz; skor `docs/soz/kor_okuma.csv` satırıdır. Eşik DYL-11'indir, burada icat edilmez.
  - Kabul: skor satırı olmayan id YAZ-04 red. Test: kapı.
  - Bağımlılık: DYL-11. Boyut: S.
  - Dosya: `docs/soz/kor_okuma.csv`.
  - Asset: asset gerekmedi.
- [ ] **KLT-06:** Kota raporu YAZ-09'dan okunur.
  - Ne: sır, dinleyici, dedikodu çekirdeği (SOY-27) yüzdeleri; aşım red.
  - Kabul: dedikodu > %20 (SOY-27 öneri) → 1 hata. Test: kota.
  - Bağımlılık: YAZ-09, SOY-27. Boyut: S.
  - Dosya: `soz_kapi.py`.
  - Asset: asset gerekmedi.

- [ ] **KLT-31:** Yasak kalıp USLUP §1 dışına taşmaz
  - Ne: Yasak kalıp USLUP §1 dışına taşmaz. İkinci yasak dosyası yok.
  - Kabul: Dosya 1. Test: tarama.
  - Bağımlılık: YAZ-02. Boyut: S.
  - Dosya: `USLUP_REHBERI.md`
  - Asset: asset gerekmedi.
- [ ] **KLT-32:** Aynı iskelet iki ağızda uyarır
  - Ne: Aynı iskelet iki ağızda uyarır. Bilgi aynı, sıra aynıysa 1 uyarı.
  - Kabul: Uyarı 1. Test: fixtures.
  - Bağımlılık: YAZ-09. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.
- [ ] **KLT-33:** Ünlem yığılması uyarır
  - Ne: Ünlem yığılması uyarır. Üç ünlem 1 uyarı. Diyalog satırında.
  - Kabul: Uyarı 1. Test: fixtures.
  - Bağımlılık: YAZ-02. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.
- [ ] **KLT-34:** Oyuncu yönergesi diyalogda reddedilir
  - Ne: Oyuncu yönergesi diyalogda reddedilir. 'Tıkla', 'menüye dön' ağızda 1 hata. İpucu anahtarı hariç.
  - Kabul: Hata 1. Test: fixtures.
  - Bağımlılık: YAZ-02. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.
- [ ] **KLT-35:** Rakamla yıl ağızda reddedilir
  - Ne: Rakamla yıl ağızda reddedilir. 1240 veya 1243 karakter satırında 1 hata. Kitapta serbest.
  - Kabul: Hata 1. Test: fixtures.
  - Bağımlılık: YAZ-02. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.

### 40.3 Tutarlılık — ölü, giden, çelişki

- [ ] **KLT-07:** Ölü veya ayrılmış kişi anılmaz.
  - Ne: `koyde[]` / `ayrildi[]` koşulu tutmayan satırda o kişinin adı geçiyorsa tarama hatası (Valve olgu listesi, DIY-09).
  - Kabul: ayrılmış id + ad geçen satır 1 hata. Test: fixtures. Taşınan: KLT-36: Ayrılan kişi koşulsuz anılmaz.
  - Bağımlılık: DIY-09. Boyut: S.
  - Dosya: `soz_kapi.py`.
  - Asset: asset gerekmedi.
- [ ] **KLT-08:** Aynı gün iki zıt olgu.
  - Ne: aynı `gece` ve aynı `olay_id` için iki `dogru=true` çelişik beyan tarama uyarısıdır; DNY-02 kural 1 kasıtlı çelişkiyse `kasitli_celiski` işareti gerekir.
  - Kabul: işaretsiz çelişki 1 uyarı. Test: fixtures.
  - Bağımlılık: DNY-02, SOY-25. Boyut: S.
  - Dosya: `soz_kapi.py`.
  - Asset: asset gerekmedi.
- [ ] **KLT-09:** Yer ve bina adı BUG-16 listesindedir.
  - Ne: satırdaki bina adı `bina_var` veya koşulsuz imza listesinde değilse hata (BUG-17 gazete kuralının Söz hali).
  - Kabul: olmayan bina adı 1 hata. Test: fixtures.
  - Bağımlılık: BUG-16, BUG-17. Boyut: S.
  - Dosya: `soz_kapi.py`.
  - Asset: asset gerekmedi.

- [ ] **KLT-37:** Aynı gece iki doğru çelişki işareti ister
  - Ne: Aynı gece iki doğru çelişki işareti ister. İşaretsiz çift 1 uyarı. KLT-08.
  - Kabul: Uyarı 1. Test: fixtures.
  - Bağımlılık: KLT-08. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.
- [ ] **KLT-39:** Olmayan meslek ağızda reddedilir
  - Ne: Olmayan meslek ağızda reddedilir. Meslek listesi `meslek_yapilari` dışındaysa 1 hata.
  - Kabul: Hata 1. Test: fixtures.
  - Bağımlılık: ISG-01. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.
- [ ] **KLT-40:** Çocuk ağzı iş emri vermez
  - Ne: Çocuk ağzı iş emri vermez. Çocuk düğümünde iş atama fiili 1 uyarı.
  - Kabul: Uyarı 1. Test: fixtures.
  - Bağımlılık: UZM-08. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.

### 40.4 Metin anahtarı ve CSV

- [x] **KLT-10:** (Claude) TST-0002 altı eksik anahtar kapanır.
  - Ne: eski: TST-0002. `metin_dogrula.py --kaynak` 0 eksik anahtar olmadan bu madde açık kalır. Yeni sistem değil, açık bulgu.
  - Kabul: `GuvenliMetin.eksikler` uzunluğu 0 (temiz tur). Test: araç. Taşınan: KLT-41: Eksik anahtar listesi tektir.
  - Bağımlılık: SYS-09. Boyut: S.
  - Dosya: `data/metin/metinler.csv`.
  - Asset: asset gerekmedi.
- [x] **KLT-11:** (Claude) TST-0006 çift boşluk ve tekfur ikizi.
  - Ne: eski: TST-0006. `arayuz.oyun.kenar`, `arayuz.oyun.tam` tek boşluk; `anlati.saldiri.guc` ya yetimdir (kaldır) ya `koy.olay.tekfur_baskini` ile birleşir. Anahtar silme SYS-09 kuralına aykırıysa yetim belgelenir, metin eşitlenir.
  - Kabul: iki satırda çift boşluk 0; iki metin çelişmez. Test: `metin_dogrula.py` kural + inceleme. Taşınan: KLT-42: Çift boşluk sohbet önekine de bakar.
  - Bağımlılık: SYS-09. Boyut: S.
  - Dosya: `metinler.csv`.
  - Asset: asset gerekmedi.
- [ ] **KLT-12:** `ogretici.` uzunluk kuralı (OGR-08) kapıdadır.
  - Ne: `ogretici.*` ≤ 90 karakter; `soz_kapi.py` bunu `metin_dogrula` ile paylaşır, ikinci limit yazılmaz.
  - Kabul: 91 karakter 1 hata. Test: fixtures.
  - Bağımlılık: OGR-08. Boyut: S.
  - Dosya: `metin_dogrula.py`.
  - Asset: asset gerekmedi.

- [x] **KLT-43:** (Claude) Yer tutucu fazlası hatadır
  - Ne: Yer tutucu fazlası hatadır. Kod argümanından fazla `%s` 1 hata.
  - Kabul: Hata 1. Test: araç.
  - Bağımlılık: YER-02. Boyut: S.
  - Dosya: `tools/metin_dogrula.py`
  - Asset: asset gerekmedi.
- [x] **KLT-44:** (Claude) Mükerrer anahtar hatadır
  - Ne: Mükerrer anahtar hatadır. Aynı anahtar iki satır 1 hata. Silme yok, ikincisi red.
  - Kabul: Hata 1. Test: araç.
  - Bağımlılık: SYS-09. Boyut: S.
  - Dosya: `tools/metin_dogrula.py`
  - Asset: asset gerekmedi.
- [x] **KLT-45:** (Claude) Tırnak kırığı satırı yutar
  - Ne: Tırnak kırığı satırı yutar. Standart §2. Kırık tırnak 1 hata, sonraki anahtar kurtulur.
  - Kabul: Hata 1, sonraki anahtar durur. Test: fixtures.
  - Bağımlılık: SYS-09. Boyut: S.
  - Dosya: `tools/metin_dogrula.py`
  - Asset: asset gerekmedi.

### 40.5 İnsan incelemesi — araçları tekrar tarif etmez

- [ ] **KLT-13:** DYL-13 yan yana bakış kapı adımıdır.
  - Ne: eski/yeni metin bakılmadan "taşındı" sayılmaz. DIY-16 eski diyalogları taşımama kararı durur; bakış, silinenle yeninin aynı ağız olmadığını doğrular.
  - Kabul: bakış kaydı olmayan karakter "hazır" değil. Test: `HAT.md` kutusu.
  - Bağımlılık: DYL-13, DIY-16. Boyut: S.
  - Dosya: `docs/soz/HAT.md`.
  - Asset: asset gerekmedi.
- [ ] **KLT-14:** DYL-14 örnek defteri yazarın elindedir.
  - Ne: "bir köylü buna nasıl cevap verir?" sorusu üretimde zorunlu; çıktı DYL-14 defterine gider, burada ikinci defter yok.
  - Kabul: örnek satırı 0 olan taslak red. Test: kapı.
  - Bağımlılık: DYL-14. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **KLT-15:** DYL-12 son dağılımı yazım kapısı değildir.
  - Ne: muhafız tipi tarama denge içindir (32); yazım hattını kilitlemez. Bu madde o taramayı buraya taşımaz.
  - Kabul: `soz_kapi.py` içinde son eşiği 0. Test: tarama.
  - Bağımlılık: DYL-12, DEN. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

- [ ] **KLT-46:** Kör okuma satırı silinmez
  - Ne: Kör okuma satırı silinmez. Skor dosyasında eski satır kalır, üstüne yazılırsa tarih düşer.
  - Kabul: Silinen id 0. Test: diff.
  - Bağımlılık: DYL-11. Boyut: S.
  - Dosya: `docs/soz/kor_okuma.csv`
  - Asset: asset gerekmedi.
- [ ] **KLT-47:** Örnek cümle kadro adıdır
  - Ne: Örnek cümle kadro adıdır. Örnekteki ad kadroda yoksa 1 hata.
  - Kabul: Hata 1. Test: fixtures.
  - Bağımlılık: DYL-14. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.
- [ ] **KLT-48:** Yan yana bakış eski metni kopyalamaz
  - Ne: Yan yana bakış eski metni kopyalamaz. Eski cümle `data/soz` içine düşerse 1 hata.
  - Kabul: Hata 1. Test: diff.
  - Bağımlılık: DIY-16. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.
- [ ] **KLT-50:** İnceleme kutusu satır sayısı dosya satırına eşittir
  - Ne: İnceleme kutusu satır sayısı dosya satırına eşittir. Eksik satır 1 hata.
  - Kabul: Hata 1. Test: sayım.
  - Bağımlılık: YAZ-10. Boyut: S.
  - Dosya: `docs/soz/HAT.md`
  - Asset: asset gerekmedi.

### 40.6 Prototip ve oyun aynı sonuç

- [ ] **KLT-16:** DYL-16 `--check` kapanmadan `data/soz/` şişmez.
  - Ne: prototip motoru ile oyun adaptörü aynı fixtures'ta aynı dalı seçer. KOP söz adaptörü imzası değişmez.
  - Kabul: `--check` 0 fark. Test: DYL-16.
  - Bağımlılık: DYL-16, KOP. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **KLT-17:** DYL-15 sitede düzenleme üretim aracıdır, oyun içi editör değildir.
  - Ne: oyuncu Söz dosyası düzenlemez; madde sınırı koyar.
  - Kabul: `src/` içinde soz editörü 0. Test: tarama. Taşınan: KLT-52: Site editörü `src` altında değildir.
  - Bağımlılık: DYL-15. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

- [ ] **KLT-53:** Prototip kaydı onay bezemez
  - Ne: Prototip kaydı onay bezemez. Site kaydı HAT onayı sayılmaz.
  - Kabul: Onaysız kopya 0. Test: kapı.
  - Bağımlılık: YAZ-04. Boyut: S.
  - Dosya: `Roadmap-2/soz_agaci/`
  - Asset: asset gerekmedi.
- [ ] **KLT-54:** JS ve GDScript aynı seçim kimliğini verir
  - Ne: JS ve GDScript aynı seçim kimliğini verir. Bir fixtures.
  - Kabul: Fark 0. Test: DYL-16.
  - Bağımlılık: DIY-02. Boyut: S.
  - Dosya: `src/soz/soz_motoru.gd`
  - Asset: asset gerekmedi.
- [ ] **KLT-55:** Fixtures içine düz Türkçe gömülmez
  - Ne: Fixtures içine düz Türkçe gömülmez. Anahtar kullanılır.
  - Kabul: Düz cümle 1 hata. Test: tarama.
  - Bağımlılık: SYS-09. Boyut: S.
  - Dosya: `Roadmap-2/soz_agaci/`
  - Asset: asset gerekmedi.

### 40.7 Tester köprüsü

- [ ] **KLT-18:** Tester K7 kör noktası bu kapıya bağlanır.
  - Ne: tur raporunda `soz_kapi.py` özeti bir satır: ihlal, kota, eksik anahtar. Persona "hikâye odaklı" (TESTER planı §3) diyalog dalını gezer; kalite puanı kanaat değildir, kapı sayısıdır.
  - Kabul: tur raporunda `soz_kapi` satırı. Test: örnek rapor. Taşınan: KLT-56: Tur satırı `soz_kapi` özetidir.
  - Bağımlılık: ADM-16. Boyut: S.
  - Dosya: tester rapor şablonu (oyun deposu `docs/tester/`, bu klasörden yazılmaz — madde oraya işaret eder).
  - Asset: asset gerekmedi.
- [ ] **KLT-19:** Ses testi yoktur.
  - Ne: tester K6 (ses) ve R2 seslendirme yasağı; bu bölüm ses taraması açmaz.
  - Kabul: `soz_kapi.py` içinde ses kuralı 0. Test: tarama. Taşınan: KLT-58: Ses turu açılmaz.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

- [ ] **KLT-57:** Hikâye personası dal gezmez diye kalite puanı yazılmaz
  - Ne: Hikâye personası dal gezmez diye kalite puanı yazılmaz. Puan kapı sayısıdır. Kanaat satırı raporda 0.
  - Kabul: Kanaat 0. Test: şablon.
  - Bağımlılık: KLT-18. Boyut: S.
  - Dosya: `docs/tester/`
  - Asset: asset gerekmedi.
- [x] **KLT-59:** (Claude) Tester metin silmez
  - Ne: Tester metin silmez. CSV yaması tester işi değildir.
  - Kabul: Yazım 0. Test: tarama.
  - Bağımlılık: TST-0006. Boyut: S.
  - Dosya: `docs/tester/`
  - Asset: asset gerekmedi.
- [ ] **KLT-60:** Kapı kırmızıysa tur diyaloğu geçti sayılmaz
  - Ne: Kapı kırmızıysa tur diyaloğu geçti sayılmaz. Sanity yeşil olsa da kapı kırmızıysa diyalog kutusu açık kalır.
  - Kabul: Kutu açık. Test: örnek.
  - Bağımlılık: KLT-04. Boyut: S.
  - Dosya: `docs/soz/HAT.md`
  - Asset: asset gerekmedi.

### 40.8 Kapsam ve kota disiplini

- [ ] **KLT-20:** Her karakterin sırrı yoktur (YAZ-09).
  - Ne: kapı, kadroda sır çekirdeği kotasını okur; %100 sır red.
  - Kabul: kota aşımı 1 hata. Test: YAZ-09. Taşınan: KLT-61: Sır kotası yüzde yüzü reddeder.
  - Bağımlılık: YAZ-09. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [x] **KLT-21:** (Claude — kapsam bekçisi) Hitap türü kota notudur, sistem değildir.
  - Ne: karar kaydı 10; `hitap` alanı oyun mekaniği açmaz.
  - Kabul: `hitap_puani` 0. Test: tarama. Taşınan: KLT-63: Hitap puanı alanı açılmaz.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

- [ ] **KLT-64:** Dinleyici kotası ayrı sütundur
  - Ne: Dinleyici kotası ayrı sütundur. Sır ile toplanmaz.
  - Kabul: Tek sütun 0. Test: rapor.
  - Bağımlılık: YAZ-09. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.
- [ ] **KLT-65:** Kota dosyası `kurallar.json` ile çelişirse kapı durur
  - Ne: Kota dosyası `kurallar.json` ile çelişirse kapı durur. İki sayı. Büyük olan değil, kapı hatası.
  - Kabul: Hata 1. Test: fixtures.
  - Bağımlılık: YAZ-09. Boyut: S.
  - Dosya: `data/soz/kurallar.json`
  - Asset: asset gerekmedi.

### 40.9 Dosya ve araç sınırı

- [ ] **KLT-22:** Dünya kitabı çalışma anında okunmaz (YAZ-01).
  - Ne: `docs/dunya_kitabi/` `res://` altına kopyalanmaz.
  - Kabul: export'ta kitap yolu 0. Test: export listesi. Taşınan: KLT-66: Kitap export'a girmez.
  - Bağımlılık: YAZ-01. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [x] **KLT-23:** (Claude) Çalışma anında model çağrısı yoktur (YAZ ilke).
  - Ne: `src/` içinde HTTP/LLM çağrısı 0 (mevcut köprü localhost hariç, ADM-16).
  - Kabul: tarama 0. Test: `godot_script_taramasi.py` kuralı. Taşınan: KLT-67: HTTP dizesi söz araçlarında yoktur.
  - Bağımlılık: ADM-16. Boyut: S.
  - Dosya: araç kuralı.
  - Asset: asset gerekmedi.

- [ ] **KLT-68:** Araç `user://` yazmaz
  - Ne: Araç `user://` yazmaz. Kayıt ve ayar dosyasına dokunmaz.
  - Kabul: Yazım 0. Test: tarama.
  - Bağımlılık: KLT-23. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.
- [ ] **KLT-69:** Araç ağacı silmez
  - Ne: Araç ağacı silmez. `data/soz` dosyası araç tarafından kaldırılmaz. Red ayrı klasöre liste yazar.
  - Kabul: Silinen 0. Test: diff.
  - Bağımlılık: YAZ-04. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.

### 40.10 Sınırlar ve kapanış

- [x] **KLT-24:** (Claude) 25.3 kimlikleri silinmez.
  - Ne: DYL-11…16 yerinde; bu bölüm onlara atıf verir.
  - Kabul: B dosyasında DYL-11…16 durur. Test: sayım. Taşınan: KLT-71: DYL-11…16 durur.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `ROADMAP_2_B.md`.
  - Asset: asset gerekmedi.
- [ ] **KLT-25:** Kapanış testi.
  - Ne: fixtures: yasak kalıp, onaysız dosya, ölü adı, 91 karakter ipucu, çift boşluk — beşinin de red.
  - Kabul: beş fixture 5 hata. Test: `tests/tools/test_soz_kapi.py`. Taşınan: KLT-75: Kapanış beş fixtures reddeder.
  - Bağımlılık: KLT-01…24. Boyut: M.
  - Dosya: yeni test.
  - Asset: asset gerekmedi.

Alt başlıklarda madde sayısı iki ile üç arasındadır; onuncu madde YAZ veya DYL gövdesini tekrar edeceği için konmadı. Toplam 25 madde.

- [ ] **KLT-72:** Yeni madde ikinci motor açmaz
  - Ne: Yeni madde ikinci motor açmaz. Sınıf ek 0.
  - Kabul: Sınıf 1. Test: tarama.
  - Bağımlılık: DIY-02. Boyut: S.
  - Dosya: `src/soz/soz_motoru.gd`
  - Asset: asset gerekmedi.
- [ ] **KLT-73:** Wav eklenmez
  - Ne: Wav eklenmez. Sayı aynı.
  - Kabul: Sayım. Test: sayım.
  - Bağımlılık: KLT-19. Boyut: S.
  - Dosya: `assets/ses/`
  - Asset: asset gerekmedi.


---

## BÖLÜM 41: Performans, kararlılık ve teknik borç


Faz 0 ile birlikte başlar; ölçüm Faz 4'te DEN ile kapanır. Zemin, kodda duran ve yeniden kurulmayacak makineler:

- Performans şeridi `src/debug/performans_seridi.gd` — `ac(evet)`, `_yenile`, `oku()` sözlüğü: `fps` (`TIME_FPS`), `kare_ms` (`TIME_PROCESS`), `draw`, RAM `MEMORY_STATIC`. Şerit ekrandadır; dosyaya yazmaz (tester planı K3).
- Düşük bellek `src/dunya/dusuk_bellek_profili.gd` `memory_free()` — beş önbellek: `Sanat`, `Pbr`, `Dunya3B`, `KarakterModel` klipleri, `DurusDuzeltici` şekilleri; `KapiManzarasi._gurultu` null.
- Grafik profili `src/dunya/grafik_profili_adaptoru.gd`; efekt havuzu `src/ses/efekt_havuzu_temizligi.gd`.
- `src/dunya/donma_yoneticisi.gd` donma bekçisi değildir. MEV-02 soğuk hasarıdır (`adaylar`, `risk`, `soguk`). Kare takılması burada ölçülmez.
- Kayıt atomik yazımı SYS-02 `atomik_json_kaydi.gd`; tek dosya `user://kayit.json`. Göç SYS-01/14, Bölüm 31.
- Yükleme katmanı `src/arayuz/varlik_yukleme_paneli.gd` — `hazirla` / `bitir`; zemin `Color("#0d1117")`; metin düz `"Hazırlanıyor…"` (çeviri anahtarı değil).
- Köy hızı `koy_ekrani.gd:337 _hiz_sec`; sahneden çıkış `_exit_tree` (satır 350) `paused` ve `time_scale` ve `max_physics_steps_per_frame` geri yükler.
- Açık bulgular: TST-0001, TST-0005 AÇIK. TST-0002 ve TST-0006 Bölüm 40'dadır (KLT-10, KLT-11). TST-0004 / BUG-0018 odun kilidi Bölüm 32'dedir, burada ikinci ekonomi yoktur. TST-0007 ve TST-0008 model ölçüsü Bölüm 44'tedir. ADV-01…07 `docs/denetim/2026-10-10-claude-test-raporu.md:62–69`. ADM-16 `[/]` (`ROADMAP.md`).

Bu bölüm salgın, mevsim, kayıt göçü veya köprü komut listesini yeniden yazmaz. Açık borcu kimliğiyle kapatır ve ölçer.

Kimlikler TEK-01 … TEK-34. Asset üretilmez. Bitince `[x]` ve ajan adı.

**Madde biçimi:** Ne, Kabul, Bağımlılık + Boyut, Dosya, Asset.

---

### 41.1 Açık bulgular — kimlik durur

- [x] **TEK-01:** (testx) TST-0001 — `KoyNufusu.sayi` eksik sınıf anahtarında SCRIPT ERROR.
  - Ne: eski: TST-0001. `sayi()` olmayan sınıf anahtarında hata basmaz, 0 döner ve bir kez `push_warning` yazar.
  - Kabul: eksik anahtarda SCRIPT ERROR 0, dönüş 0. Test: birim.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `src/koy/koy_nufusu.gd`.
  - Asset: asset gerekmedi.
- [x] **TEK-02:** (testx) TST-0005 — 43 yetim `.import`.
  - Ne: eski: TST-0005. `assets/model/karakter/*_yuru_Image_0.jpg.import` var, `.jpg` yok; headless import ERROR üretir. Karşılığı olmayan `.import` silinir. Yeni jpg üretilmez, mesh'e dokunulmaz.
  - Kabul: yetim `.import` sayısı 0; import logunda `_yuru_Image_0.jpg` ERROR 0. Test: import log sayımı.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `assets/model/karakter/*.import` (yalnız yetim meta).
  - Asset: asset gerekmedi.
- [ ] **TEK-03:** ADV-01 — güvenlik satırı kartta görünür.
  - Ne: eski: ADV-01. "Güvenlik … savunma hazırlığı +N" `koylu_karti.gd` içinde kaydırmadan görünen üst bloktadır.
  - Kabul: 1080p ve metin ölçeği 150'de satır ilk ekrandadır. Test: kart açılışı, kaydırma 0. Ek şart: Yaşam satırları güvenlik satırını ilk ekrandan düşürmez.
  - Bağımlılık: ARY-02. Boyut: S.
  - Dosya: `src/arayuz/koylu_karti.gd`.
  - Asset: asset gerekmedi.
- [x] **TEK-04:** (Codex) ADV-06 — teşhis ibresi bir kez yazılır.
  - Ne: eski: ADV-06. Yüz ve heybe incelemesinde aynı ibre satırı konuşma kaydına ikinci kez eklenmez.
  - Kabul: aynı incelemede ibre satırı 1. Test: iki inceleme.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: teşhis yazan kapi paneli (ince adaptör, tek satır).
  - Asset: asset gerekmedi.
- [ ] **TEK-05:** ADV-03 — eski `usta_demirci` bayrağı göçer.
  - Ne: eski: ADV-03. BUG-0001 yeni kabulleri düzeltir; eski kayıttaki CHR bayrağı Bölüm 31 göç adımına bir satır olarak girer. İkinci göç motoru yok.
  - Kabul: bayraklı eski kayıt açılınca göç sonrası bayrak doğru sınıfta 1. Test: KAY zinciri.
  - Bağımlılık: KAY-04. Boyut: S.
  - Dosya: `src/sistemler/kayit_gocu.gd` tek adım.
  - Asset: asset gerekmedi.
- [x] **TEK-06:** (testx) ADM-16 kapanış ölçütü, komut listesi yeniden yazılmaz.
  - Ne: `ROADMAP.md` ADM-16 `[/]` durur. Bu madde köprüyü ikinci kez tasarlamaz. Kapanış: normal oyunda port yokken `oyun_koprusu.gd` süreç açmaz; `--bridge-port` ile `ping` döner. Komut kümesi o maddenin listesidir.
  - Kabul: portsuz açılışta dinleyen soket 0. Test: iki açılış.
  - Bağımlılık: ADM-16. Boyut: S.
  - Dosya: `src/debug/oyun_koprusu.gd` (oyun deposunda; bu klasörden yazılmaz).
  - Asset: asset gerekmedi.

### 41.2 Ölçüm — üç gece

- [x] **TEK-07:** (Codex) ADV-02 — kuyu zehri enjektörü hekimi hasta etmez.
  - Ne: eski: ADV-02. Debug "kuyu zehri" herkese `hasta` vermez; KRI-04 gibi yalnız su içenlere ve olasılıkla düşer. Hekim `hekim etkin` yanlış pozitif almaz.
  - Kabul: enjektör sonrası hekim `hasta` değilse `hekim etkin` true. Test: birim.
  - Bağımlılık: KRI-04. Boyut: S.
  - Dosya: `src/debug/` kuyu enjektörü.
  - Asset: asset gerekmedi.
- [x] **TEK-08:** (Kalfa) ADV-05 karar olarak kalır, yeni bonus yoktur.
  - Ne: eski: ADV-05. Kenetlenme bonusu gizli kuluçkada verilmez. Bu bir borç kapatma değil, yazılı karardır: dolaylı ipucu kabul. Kod değişmez, `docs/denetim` notu "karar" olur.
  - Kabul: bonus formülü diff'i 0. Test: tarama.
  - Bağımlılık: KRI-10. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **TEK-09:** ADV-07 eşikleri DEN'dedir.
  - Ne: eski: ADV-07. `data/atil_bayraklar.json` ve `data/nihai_sonlar.json` gözden geçirmesi Bölüm 32'dedir. Burada ikinci eşik tablosu açılmaz.
  - Kabul: bu dosyada yeni json 0. Test: sayım.
  - Bağımlılık: DEN-01. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [x] **TEK-10:** (Codex) Üç gecelik performans ölçümü.
  - Ne: `PerformansSeridi.oku()` üç gece boyunca gece başına bir satır yazar: fps ortanca, kare_ms en yüksek, `memory_free` öncesi RAM. Hedef (öneri, `data/teknik.json`): ortanca fps ≥ 30, kare_ms tavanı dosyada. Otomatik profil değiştirmez (AYR düşük profil satırı ayrıdır).
  - Kabul: üç gece sonunda satır 3; eşik altı bir uyarı, crash yok. Test: `tests/oto` koşusu.
  - Bağımlılık: yok. Boyut: M.
  - Dosya: yeni: `src/debug/performans_gunlugu.gd`; `data/teknik.json`.
  - Asset: asset gerekmedi.
- [ ] **TEK-11:** Günlük oyuncu sürümünde kapalıdır.
  - Ne: `performans_gunlugu` yalnız debug veya `--perf-log` ile yazar. SRM-05 kapalı sürümde dosya oluşmaz.
  - Kabul: bayraksız export'ta log dosyası 0. Test: açılış.
  - Bağımlılık: TEK-10, SRM-05. Boyut: S.
  - Dosya: `performans_gunlugu.gd`.
  - Asset: asset gerekmedi.
- [x] **TEK-12:** (testx) ADV-04 — manifest bilinçli API değişince güncellenir.
  - Ne: eski: ADV-04. `tools/api_sozlesmesi.py` baseline ile birebir bakar. Korumalı imza değişince baseline aynı commit'te güncellenir; sessiz sapma sanity'yi geçmez.
  - Kabul: imza değişip baseline eskiyse sanity kırmızı. Test: araç. Ek şart: Kapı ekranına `eylem_bitti` sinyali eklenmez.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `tools/api_sozlesmesi_baseline.json`.
  - Asset: asset gerekmedi.

### 41.3 Bellek ve önbellek

- [x] **TEK-13:** (Kalfa) `memory_free` ikinci önbellek açmaz.
  - Ne: beş önbellek listesi `dusuk_bellek_profili.gd` içindedir. Yeni sistem kendi önbelleğini bu listeye eklemeden biriktirmez.
  - Kabul: `memory_free` dönüş sözlüğünde beş anahtar. Test: birim.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `src/dunya/dusuk_bellek_profili.gd`.
  - Asset: asset gerekmedi.
- [x] **TEK-14:** (Kalfa) Düşük profil `memory_free` çağırır, şeridi çağırmaz.
  - Ne: `grafik_profili == dusuk` iken sahne geçişinde `memory_free` bir kez; `PerformansSeridi.ac(true)` oyuncuda 0.
  - Kabul: düşük profilde çağrı 1, şerit görünür 0. Test: profil değiştir.
  - Bağımlılık: TEK-13. Boyut: S.
  - Dosya: `grafik_profili_adaptoru.gd` tek satır.
  - Asset: asset gerekmedi.
- [x] **TEK-15:** (Kalfa) Efekt havuzu temizliği durur.
  - Ne: `efekt_havuzu_temizligi.gd` ve `ana.gd _goster` içindeki `Ses.efektleri_temizle()` yerinde kalır. İkinci havuz yok.
  - Kabul: sahne geçişinde çift temizlik çağrısı 1 (mevcut tek çağrı). Test: tarama.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

### 41.4 Hata bütçesi

- [x] **TEK-16:** (Kalfa) Sanity SCRIPT ERROR bütçesi 0'dır.
  - Ne: `tools/sanity_check.py` turunda SCRIPT ERROR satırı 0. TEK-01 kapanmadan bu madde kapanmaz.
  - Kabul: temiz turda SCRIPT ERROR 0. Test: sanity.
  - Bağımlılık: TEK-01. Boyut: S.
  - Dosya: `tools/sanity_check.py`.
  - Asset: asset gerekmedi.
- [x] **TEK-17:** (Claude) `[KEY_NOT_FOUND]` bütçesi KLT-10'dur.
  - Ne: metin eksikleri Bölüm 40'dadır. Bu madde ikinci doğrulayıcı yazmaz.
  - Kabul: `metin_dogrula.py` çağrısı `soz_kapi` / mevcut araçta 1, burada 0 yeni araç. Test: sayım.
  - Bağımlılık: KLT-10. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [x] **TEK-18:** (Kalfa) Push_error katalogu kilitlemez.
  - Ne: `GuvenliMetin` ve `Ayarlar.yukle` bozuk dosyada oyunu açar, varsayılana döner (`ayarlar.gd:38–49`). Bu davranış bozulmaz.
  - Kabul: bozuk `ayarlar.cfg` ile menü açılır. Test: birim.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

### 41.5 Yükleme katmanı

- [x] **TEK-19:** (Kalfa) Yükleme paneli bitince input'u bırakır.
  - Ne: `VarlikYuklemePaneli._input` her olayı yer (`set_input_as_handled`). `bitir` düğümü ağaçtan çıkarır; sonraki karede tıklama oyuna gider.
  - Kabul: `bitir` sonrası panel çocuğu 0, ilk tıklama menüye ulaşır. Test: akış.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `src/arayuz/varlik_yukleme_paneli.gd`.
  - Asset: asset gerekmedi.
- [x] **TEK-20:** (Kalfa) Çift kapı yüklemesi engeli durur.
  - Ne: `ana.gd _kapi_yukleniyor` (satır 80–97) ikinci `_kapiya_git` çağrısını yutar. Bayrak `bitir` sonrası false olur; takılı true kalırsa kapı bir daha açılmaz — test bunu yakalar.
  - Kabul: art arda iki çağrıda ekran 1; bitişte bayrak false. Test: birim.
  - Bağımlılık: TEK-19. Boyut: S.
  - Dosya: `src/arayuz/ana.gd` (yalnız test; imza değişmez).
  - Asset: asset gerekmedi.
- [x] **TEK-21:** (Claude) "Hazırlanıyor…" çeviri anahtarına geçer.
  - Ne: düz metin `arayuz.yukleme.hazirlaniyor` olur. YER-02 kuralı. Zemin rengi Bölüm 43'ün konusudur, burada değişmez.
  - Kabul: `tr("` dışı düz Türkçe bu dosyada 0 (bilinçli istisna listesi boş). Test: tarama.
  - Bağımlılık: YER-02. Boyut: S.
  - Dosya: `varlik_yukleme_paneli.gd`; `metinler.csv`.
  - Asset: asset gerekmedi.

### 41.6 Zaman ölçeği

- [x] **TEK-22:** (testx) Sahne çıkışı hızı sıfırlar.
  - Ne: `koy_ekrani.gd _exit_tree` `paused = false`, `time_scale = 1`, fizik adımını `_onceki_fizik_adimi` yapar. Test kilitler; kod yeniden yazılmaz.
  - Kabul: hız 3'te menüye dönünce `time_scale` 1 ve `paused` false. Test: akış. Ek şart: Sabah defteri satırı yazılırken `time_scale` değişmez. Ek şart: Boş günde hız köy ekranının seçimidir; kapı kilidi uygulanmaz.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `tests/` akış.
  - Asset: asset gerekmedi.
- [x] **TEK-23:** (testx) Gece kilidi hızı 1'de tutar.
  - Ne: `_hiz_sec` `_gece_kilidi.kilitli()` iken katı 1 yapar (`gece_gecis_kilidi.gd`). Kilit varken hız 3 seçilemez.
  - Kabul: kilitliyken `time_scale` 1. Test: birim.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [x] **TEK-24:** (testx) Defter ve divan hızı geri verir.
  - Ne: HFZ-03 ve `divan_baglantisi.gd` hız saklama kalıbı bozulmaz. İkinci saklama yazılmaz.
  - Kabul: divan aç/kapa sonrası hız aynı. Test: HFZ-03 ile ortak. Ek şart: Çınar meclisi paneli açıkken oyun hızı değişmez; panel kapanınca hız kaldığı değere döner.
  - Bağımlılık: HFZ-03. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

### 41.7 Kayıt yazımı

- [x] **TEK-25:** (testx) Atomik yazım SYS-02'dir.
  - Ne: yarıda kesilen `kayit.json` bir sonraki açılışta ya tamdır ya yok hükmündedir. Bu madde `atomik_json_kaydi.gd` gövdesini değiştirmez; kesik dosya testini ekler.
  - Kabul: yarı yazılmış dosyada `devam_et` menüye döner, çökmez (`ana.gd:68–71`). Test: kesik dosya.
  - Bağımlılık: SYS-02. Boyut: S.
  - Dosya: `tests/unit` kayıt.
  - Asset: asset gerekmedi.
- [x] **TEK-26:** (testx) Tek kayıt dosyası durur.
  - Ne: yuva Bölüm 35'tedir. Burada ikinci `user://` kayıt yolu açılmaz.
  - Kabul: `kayit_deposu.gd` yol sayısı 1. Test: tarama.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

### 41.8 Debug sınırı

- [x] **TEK-27:** (testx) Admin HUD oyuncu sürümünde doğmaz.
  - Ne: `ana.gd:20 AdminHud.new()` SRM-05 kapalıyken eklenmez. Debug araçları (`gece_deneyi.gd`, enjektörler) aynı bayrağın ardındadır.
  - Kabul: kapalı sürümde `AdminHud` çocuk sayısı 0. Test: açılış.
  - Bağımlılık: SRM-05. Boyut: S.
  - Dosya: `src/arayuz/ana.gd` tek koşul.
  - Asset: asset gerekmedi.
- [x] **TEK-28:** (testx) F1 ve `~` yalnız adminde.
  - Ne: `admin_hud.gd` kısayolları HUD yokken hiçbir şeyi açmaz.
  - Kabul: HUD'suz sahnede F1 etkisi 0. Test: girdi.
  - Bağımlılık: TEK-27. Boyut: S.
  - Dosya: `src/debug/admin_hud.gd`.
  - Asset: asset gerekmedi.

### 41.9 Uzun koşu

- [ ] **TEK-29:** Yirmi gece dumanı bellek sıçraması yazmaz.
  - Ne: tester dumanı (20 gece) TEK-10 günlüğünde RAM'in gece başına sınırsız artmadığını bakar. Eşik `data/teknik.json` (öneri: 20 gecede 2 kattan az). Sıçrama varsa madde açık kalır, otomatik `memory_free` spam'i yok.
  - Kabul: eşik altı koşu geçer; üstü raporda 1 satır. Test: duman.
  - Bağımlılık: TEK-10. Boyut: M.
  - Dosya: `data/teknik.json`.
  - Asset: asset gerekmedi.
- [x] **TEK-30:** (Claude — kapsam bekçisi) Soğuk ölüm bu bölümün işi değildir.
  - Ne: `donma_yoneticisi.gd` MEV-02'dir. Kare takılması veya bellek için ona satır eklenmez.
  - Kabul: dosya diff'i 0. Test: tarama.
  - Bağımlılık: MEV-02. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

### 41.10 Sınırlar ve kapanış

- [ ] **TEK-31:** Çekirdek ekonomi ve olay şeması değişmez.
  - Ne: `oyun.tres` denge sayıları, `OlayVerisi` alanları, `oturum.gd` kayıt sürümü bu bölümden artmaz. Sürüm artışı yalnız TEK-05 göçü gerektirirse KAY kuralıncadır.
  - Kabul: `olay_verisi.gd` diff 0. Test: sözleşme.
  - Bağımlılık: KAY-04. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [x] **TEK-32:** (Claude — kapsam bekçisi) Model ölçüsü burada yoktur.
  - Ne: TST-0007 (chr_011 pelerin) ve TST-0008 (ayak, Aydoğdu yayı) Bölüm 44 maddesidir. Asset üretilmez.
  - Kabul: bu dosyada `chr_011` düzeltme adımı 0. Test: sayım.
  - Bağımlılık: SAH. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [x] **TEK-33:** (Claude — kapsam bekçisi) Odun kilidi burada yoktur.
  - Ne: TST-0004 / BUG-0018 Bölüm 32 odun satırıdır.
  - Kabul: `odun_zinciri.gd` bu bölümden değişmez. Test: tarama.
  - Bağımlılık: DEN. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **TEK-34:** Kapanış testi.
  - Ne: tek koşu: TST-0001 anahtarı 0 hata; yetim import 0; üç gece perf satırı 3; yükleme paneli kalkınca tıklama gider; hız 3'ten menüde scale 1; portsuz köprü soketi 0.
  - Kabul: altı iddia. Test: `tests/unit/sistemler/teknik_borc_test.gd` + import sayımı.
  - Bağımlılık: TEK-01…33. Boyut: M.
  - Dosya: yeni test.
  - Asset: asset gerekmedi.

Alt başlıklarda madde sayısı üç ile altı arasındadır. Onuncu madde, 31 veya 32'de duran bir kuralı ikinci kez yazacağı için konmadı. Toplam 34 madde.


---

## BÖLÜM 42: Sürüm hazırlığı ve cila


En son kapanır; 41 ve 43 bitmeden sürüm işareti konmaz. Zemin:

- `project.godot` `config/name="GameDevoloper"`. `config/version` yok. Ana sahne `res://src/arayuz/ana.tscn`. Özellikler `4.7`, Forward Plus.
- Menü `src/arayuz/menu_ekrani.gd` `OYUN_ADI := ""` (satır 8). Düğmeler `ana.gd:49`: yeni, devam, ayarlar, çık. Kayıt yoksa devam pasif (`pasifler = [1]`).
- Son ekranı `ana.gd:120 _son_goster`: epilog + `arayuz.son.istatistik` ile gün, kabul, ret, nüfus. Kayıt silinir. Başarım kodu yok (`basarim` / `achievement` araması 0).
- Çıkış `Ses.cik()` menüden. Duraklat `ana.gd:149`: devam, ayarlar, menü.
- Kayıt `user://kayit.json` tek dosya. Ayar `user://ayarlar.cfg`.
- Steamworks, export preset ve mağaza metni deposunda yoktur. Bu bölüm SDK kurmaz, başarım API'si açmaz.

Kimlikler SRM-01 … SRM-26. Asset üretilmez; ikon ihtiyacı ARY-05 satırıdır. Bitince `[x]` ve ajan adı.

**Madde biçimi:** Ne, Kabul, Bağımlılık + Boyut, Dosya, Asset.

---

### 42.1 Kimlik — ad, sürüm, pencere

- [x] **SRM-01:** (Claude) Pencere adı oyun adıdır.
  - Ne: `config/name` "GameDevoloper" kalmaz. Ad `arayuz.menu.baslik` ile aynı metinden okunur; `project.godot` adı o metnin düz kopyasıdır (Godot config çeviri fonksiyonu çağırmaz). `OYUN_ADI` boş kalırsa başlık satırı menüdeki `baslik`tır, ikinci marka yok.
  - Kabul: pencere başlığında "GameDevoloper" 0. Test: açılış başlığı.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `project.godot`; `menu_ekrani.gd` boş sabit durur ya da `baslik` ile dolar, ikinci ad yazılmaz.
  - Asset: asset gerekmedi.
- [ ] **SRM-02:** Sürüm tek sabittir.
  - Ne: `config/version` bir dizedir (öneri `0.2.0`, Ahmet koyar). Menü alt satırı `arayuz.menu.surum` ile onu gösterir. Kod içinde dağınık sürüm yazısı 0.
  - Kabul: menüde sürüm 1, `project.godot` ile aynı. Test: iki yer eşit.
  - Bağımlılık: SRM-01. Boyut: S.
  - Dosya: `project.godot`; `metinler.csv`.
  - Asset: asset gerekmedi.
- [x] **SRM-03:** (Claude) Godot 4.7 dışına çıkılmaz.
  - Ne: `config/features` 4.7 kalır. Sürüm notu 4.7.2 çalıştırma sürümünü belgeler (`docs/` bir satır). Motor yükseltilmez.
  - Kabul: features içinde `4.7` durur. Test: dosya.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `project.godot`.
  - Asset: asset gerekmedi.

### 42.2 Oyuncu sürümü — debug kapalı

- [ ] **SRM-04:** İki açılış vardır: geliştirme ve oyuncu.
  - Ne: oyuncu açılışı `--debug-arac` yokken admin, perf günlüğü ve köprüyü kurmaz. Geliştirme açılışı bugünkü davranıştır.
  - Kabul: bayraksız süreçte `AdminHud` 0 (TEK-27). Test: iki açılış.
  - Bağımlılık: TEK-27. Boyut: S.
  - Dosya: `src/arayuz/ana.gd` tek koşul.
  - Asset: asset gerekmedi.
- [ ] **SRM-05:** Debug kapalı sürüm.
  - Ne: export ön ayarında debug araçları kapalıdır: admin HUD, F1, performans şeridi, perf günlüğü, senaryo koşucusu, zaman makinesi, enjektörler. Köprü yalnız `--bridge-port` ile (ADM-16). Ön ayar `export_presets.cfg` içinde bir Windows hedefidir; Steam hedefi yoktur.
  - Kabul: oyuncu export'unda `src/debug/` düğümü 0. Test: export açılışı.
  - Bağımlılık: SRM-04, ADM-16. Boyut: M.
  - Dosya: `export_presets.cfg` (oyun deposunda, uygulanırken).
  - Asset: asset gerekmedi.
- [ ] **SRM-06:** Oyuncu sürümünde konsol izi yoktur.
  - Ne: `push_error` durur (TEK-18); oyuncuya hata ayıklama dökümü penceresi açılmaz. Godot'un kendi stdout'u paket dışında bırakılır.
  - Kabul: export'ta verbose bayrağı kapalı. Test: preset.
  - Bağımlılık: SRM-05. Boyut: S.
  - Dosya: `export_presets.cfg`.
  - Asset: asset gerekmedi.

### 42.3 Demo kesiti — yeni perde yok

- [ ] **SRM-07:** Demo, perde 1 ile sınırlı bir export bayrağıdır.
  - Ne: `demo` ayarı açıkken oyun `perde_gecisi` "Köy oturdu" kartında biter; perde 2 ve beş son çalışmaz. Omurga (Bölüm 34) yeniden yazılmaz. Sayı `oturma_esigi` (18) durur.
  - Kabul: demo bayrağında nüfus 18 sonrası kapı gecesi 0, bitiş kartı 1. Bayrak kapalıyken bugünkü perde 2. Test: iki bayrak.
  - Bağımlılık: OMR-08. Boyut: M.
  - Dosya: yeni: `src/sistemler/demo_kesiti.gd`; `perde_gecisi` çağrısına tek satır.
  - Asset: asset gerekmedi.
- [ ] **SRM-08:** Demo metni son ekranına eklenir, istatistik uydurmaz.
  - Ne: demo bitişinde mevcut dört sayı (gün, kabul, ret, nüfus) ve bir cümle `arayuz.demo.bitti`. Yeni sayaç yok.
  - Kabul: dört sayı `yonetim` alanlarından gelir. Test: son ekranı.
  - Bağımlılık: SRM-07. Boyut: S.
  - Dosya: `ana.gd _son_goster` demo dalı; `metinler.csv`.
  - Asset: asset gerekmedi.
- [ ] **SRM-09:** Tam sürümde demo kartı çıkmaz.
  - Ne: bayrak kapalıyken `demo_kesiti` 0 çağrı etkisi.
  - Kabul: normal oyunda perde 2 gecesi başlar. Test: bayrak kapalı.
  - Bağımlılık: SRM-07. Boyut: S.
  - Dosya: `demo_kesiti.gd`.
  - Asset: asset gerekmedi.

### 42.4 İstatistik — başarım sistemi yok

- [x] **SRM-10:** (Claude) Son ekranı sayaçları duran alanlardır.
  - Ne: gün, kabul, ret, nüfus (`ana.gd:125`). Başka alan eklenmez: zafer sayısı, ölüm, rüşvet. Onlar yoksa satır da yok.
  - Kabul: format argümanı 4. Test: `tr` yer tutucu sayısı.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `ana.gd`.
  - Asset: asset gerekmedi.
- [ ] **SRM-11:** Başarım tablosu açılmaz.
  - Ne: Steam başarımları ve oyun içi rozet yoktur. Alınan son izi OMR-47 `oyuncu_izi.cfg` dosyasıdır; bu bölüm onu başarım diye yeniden adlandırmaz.
  - Kabul: `basarim` sınıfı 0. Test: tarama.
  - Bağımlılık: OMR-47. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **SRM-12:** İkinci oyunda "daha önce" satırı OMR-47'dir.
  - Ne: menüde alınan sonların kısa adı. Liste OMR-47'den okunur, burada ikinci dosya yok.
  - Kabul: iz dosyası boşken satır 0. Test: OMR-47.
  - Bağımlılık: OMR-47. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

### 42.5 İlk açılış ve çıkış

- [x] **SRM-13:** (Claude) Kayıtsız devam kapalı kalır.
  - Ne: `kayit.var_mi()` false iken devam düğmesi pasif (`ana.gd:50–51`). Test bunu kilitler.
  - Kabul: dosya yokken `pasifler` içinde 1. Test: açılış.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [x] **SRM-14:** (Claude) Çıkış kaydı yazmadan menüye döner, duraklatta sorar.
  - Ne: duraklat → menü (`_duraklat` seçenek 2) mevcut kaydı silmez; son ekranı siler (`kayit.sil`). İkisi karışmaz. Yeni onay penceresi açılmaz.
  - Kabul: duraklattan menüye dönünce `kayit.json` durur. Test: akış.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [x] **SRM-15:** (Claude) `Ses.cik` oyunu kapatır.
  - Ne: menü çıkışı bugünkü `Ses.cik()` yoludur. İkinci kapatma fonksiyonu yok.
  - Kabul: çıkış çağrısı 1. Test: tarama.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `ana.gd`.
  - Asset: asset gerekmedi.

### 42.6 Mağaza metni — SDK yok

- [x] **SRM-16:** (Claude) Steamworks bu sürüme girmez.
  - Ne: depoda Steam API yoktur. Başarım, bulut kayıt, atölye eklenmez. Kayıt `user://` kalır.
  - Kabul: `steam` geçen script 0. Test: tarama.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [x] **SRM-17:** (Claude) Mağaza metni bu klasörde bir sayfadır, oyuna gömülmez.
  - Ne: `docs/surum/MAGAZA.md` (uygulanırken oyun deposunda) kısa paragraf, beş sonun adı, "seslendirme yok / tek harita" dürüst satırı. Oyun bu dosyayı okumaz.
  - Kabul: `res://` altında mağaza md 0. Test: export listesi.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `docs/surum/MAGAZA.md`.
  - Asset: asset gerekmedi.
- [x] **SRM-18:** (Claude) İkon üretilmez.
  - Ne: pencere ikonu yoksa Godot varsayılanı durur. İhtiyaç ARY-05'e `SRM18-IKON` diye yazılır. Dosya indirilmez.
  - Kabul: bu madde png yazmaz. Test: sayım.
  - Bağımlılık: ARY-05. Boyut: S.
  - Dosya: envanter satırı.
  - Asset: `SRM18-IKON`. Yer tutucu: Godot varsayılan ikonu.

### 42.7 Ekran listesi — çekim ve kontrol

- [ ] **SRM-19:** Sürüm kontrolü şu ekranları gezer.
  - Ne: tek liste: menü, ayarlar, yükleme, kapı (sorgu + karar), heybe, köy, harita, divan, muhafız odası, gece kartı, son ekranı. Liste Bölüm 43 envanterinin oyuncu yüzüdür; HUD parçaları ayrı sayılmaz.
  - Kabul: 11 ekranın her biri açılır, SCRIPT ERROR 0. Test: duman.
  - Bağımlılık: TEK-16. Boyut: M.
  - Dosya: `tests/oto` duman notu.
  - Asset: asset gerekmedi.
- [ ] **SRM-20:** Üç çözünürlükte aynı liste.
  - Ne: pencere 1280×720, 1600×900 (bugünkü override), 1920×1080. Taşan metin AYR ve GRV işidir; bu madde yalnız "açıldı" der.
  - Kabul: üç boyutta 11 ekran açılır. Test: duman × 3.
  - Bağımlılık: SRM-19, AYR. Boyut: M.
  - Dosya: —.
  - Asset: asset gerekmedi.

### 42.8 Gizlilik ve ağ

- [ ] **SRM-21:** Oyun dışarı istek atmaz.
  - Ne: oyuncu sürümünde HTTP/telemetri 0. Yerel köprü (ADM-16) localhost ve bayraklıdır, sürümde kapalıdır.
  - Kabul: bayraksız ağ bağlantısı 0. Test: tarama + açılış.
  - Bağımlılık: SRM-05. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [x] **SRM-22:** (Claude) Kayıt yolu belgede bir satırdır.
  - Ne: `user://kayit.json` ve `user://ayarlar.cfg`. Bulut kopyası yoktur.
  - Kabul: MAGAZA.md'de yol 1, bulut sözü 0. Test: dosya.
  - Bağımlılık: SRM-17. Boyut: S.
  - Dosya: `docs/surum/MAGAZA.md`.
  - Asset: asset gerekmedi.

### 42.9 İçerik sınırı

- [x] **SRM-23:** (Claude) Sürüm notu seslendirme vaat etmez.
  - Ne: mağaza ve menü "sesli diyalog" demez. Efekt ve müzik duran `Ses` autoload'ıdır, yeni dosya yok.
  - Kabul: `seslendirme` vaadi 0. Test: metin tarama.
  - Bağımlılık: SRM-17. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [x] **SRM-24:** (Claude) İkinci harita vaadi yoktur.
  - Ne: bölge haritası (R1 `harita_ekrani.gd`) tek haritadır. Mağaza "dünya haritası" diye ikinci bir oyun alanı yazmaz.
  - Kabul: MAGAZA.md'de ikinci harita 0. Test: dosya.
  - Bağımlılık: SRM-17. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

### 42.10 Sınırlar ve kapanış

- [ ] **SRM-25:** Denge ve yazım bu bölümde değişmez.
  - Ne: `denge.json` ve `data/soz/` sürüm kesitinden oynanmaz. Sapma DEN ve KLT'dedir.
  - Kabul: bu bölümün diff'i o iki ağaca girmez. Test: tarama.
  - Bağımlılık: DEN-01, KLT-01. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **SRM-26:** Kapanış testi.
  - Ne: bayraksız açılışta admin 0, pencere adı eski yazım değil, kayıtsız devam pasif, demo bayrağında perde 2 yok, son ekranı 4 sayı, steam script 0.
  - Kabul: altı iddia. Test: `tests/oto/surum_kontrol.tscn`.
  - Bağımlılık: SRM-01…25. Boyut: M.
  - Dosya: yeni test sahnesi.
  - Asset: asset gerekmedi.

Alt başlıklarda madde sayısı üçtür. Onuncu madde Steam API'si veya başarım tablosu uyduracağı için konmadı. Toplam 26 madde.


---

## BÖLÜM 43: Arayüz görsel revizyonu ve ekran envanteri


Faz 6, ARY ile birlikte, yüksek öncelik. Zemin:

- ARY-01 üç şablon ve seçim (`docs/arayuz/SABLONLAR.md`). Seçim yoksa ARY-02 başlamaz. Bu bölüm şablon icat etmez.
- ARY-02 tema kaynağı `src/arayuz/tema/*.tres`; `tema.gd` bağlar. `GOVDE_PX 26`, `KUCUK_PX 22`, `BASLIK_PX 34`.
- ARY-03 sekiz alt kapanış: harita, sorgu, seçim, köy HUD, pazar, divan, oda, gece raporu. Bu bölüm o sekizini dosya adına bağlar; ARY kimliği değişmez.
- ARY-04 yükleme yuvaları. ARY-05 envanter. Yer tutucu düz renktir.
- `Renkler`, `Sanat.KOK = res://assets/art/`. Menü zemini `menu_ekrani.gd` `ColorRect` `Renkler.GECE` artı 3B `MenuSahnesi`. Ayarlar zemini `ayarlar_ekrani.gd:21–24` yalnız `ColorRect` `Renkler.GECE`. Yükleme `varlik_yukleme_paneli.gd` `Color("#0d1117")`.

Aşağıdaki tablo envanterin kendisidir. Listede olmayan bir ekran ARY-03 kapsamına girmez. Widget'lar ekran sayılmaz.

| Ekran | Dosya | Zemin bugün |
|---|---|---|
| Kök / geçiş | `src/arayuz/ana.gd` | sahne yok, çocuk ekran |
| Menü | `menu_ekrani.gd`, `menu_satiri.gd`, `menu_susu.gd` | 3B gece + `ColorRect` |
| Ayarlar | `ayarlar_ekrani.gd`, `grafik_ayarlari_paneli.gd` | yalnız `ColorRect` GECE |
| Yükleme | `varlik_yukleme_paneli.gd` | düz `#0d1117` |
| Bilgi, son, duraklat, perde | `bilgi_ekrani.gd` (`ana._bilgi`, `arka_plan`) | `3d_kapi` / `3d_koy` / duraklatta `""` |
| Kapı | `kapi_ekrani.gd`, `hud.gd`, `hud_islem_kapisi.gd` | 3B kapı |
| Kapı parçaları | `chr_diyalog_paneli.gd`, `chr_inceleme_paneli.gd`, `chr_kapi_adaptoru.gd`, `heybe_paneli.gd`, `heybe_cizimi.gd`, `esya_karti.gd`, `esya_simgesi.gd`, `kapi/esya_detay_karti.gd`, `kapi/kapi_gorus_adaptoru.gd`, `kapi/tansiyon_gostergesi.gd`, `heyet_kapi_paneli.gd`, `tuccar_kapi_paneli.gd` | kapı sahnesinin üstü |
| Köy | `koy_ekrani.gd`, `koy_atama_alani.gd`, `koylu_karti.gd`, `koylu_surukleme_kulpu.gd` | 3B köy |
| Harita | `harita_ekrani.gd` | ARY-03 harita |
| Divan | `src/kapi/divan_ekrani.gd` (+ `divan_sorgu_paneli.gd`, `divan_hukum_paneli.gd`, `divan_kanit_karti.gd`, `divan_haksizlik_paneli.gd`, `divan_baglantisi.gd`) | ayrı ekran |
| Muhafız odası | `muhafiz_odasi_ekrani.gd`, `oda_kasasi_paneli.gd`, `oda_terazisi_paneli.gd`, `oda_vicdan_paneli.gd`, `oda_yetenek_paneli.gd`, `oda_gelistirme_paneli.gd`, `oda_envanter_sergisi.gd`, `oda_teftis_notu.gd` | oda sahnesi |
| Mini oyun | `mini_oyun.gd`, `harman_oyunu.gd`, `okculuk_oyunu.gd` | oyun kadrajı |
| Köy HUD | `src/arayuz/koy_hud/*.gd` (43 dosya; pazar `pazar_satis_paneli.gd`, meclis `cinar_meclis_paneli.gd`, cenaze `cenaze_raporu.gd`) | köyün üstü |
| Tema | `tema.gd`, `renkler.gd`, `sanat.gd`, `cerceve_kutu.gd`, `muhur.gd`, `adim.gd` | kaynak |

Gece raporu ayrı ekran değildir: `src/sistemler/gece_bilancosu.gd` köy ekranında çizilir. İkinci rapor sahnesi açılmaz.

Kimlikler GRV-01 … GRV-101. Asset üretilmez. Bitince `[x]` ve ajan adı.

**Madde biçimi:** Ne, Kabul, Bağımlılık + Boyut, Dosya, Asset.

---

### 43.1 Envanter kapanışı

- [ ] **GRV-01:** Bu tablodaki her ekranın bir zemin hükmü vardır.
  - Ne: hüküm üçtür: `sahne` (3B duruyor), `tema` (ARY-02 düzlemi), `eksik` (düz renk, sahne yok). Hüküm bu dosyadaki tablonun sağ sütunundan çıkar, ikinci liste tutulmaz.
  - Kabul: tabloda satırı olup hükmü boş ekran 0. Test: satır sayımı.
  - Bağımlılık: ARY-02. Boyut: S.
  - Dosya: bu bölüm. Uygulanırken kopya `docs/arayuz/EKRANLAR.md` (oyun deposu).
  - Asset: asset gerekmedi.
- [ ] **GRV-02:** Ayarlar `eksik`tir.
  - Ne: `ayarlar_ekrani.gd` zemini yalnız `ColorRect`. ARY-02 sonrası tema düzlemi gelir; fotoğraf üretilmez. Sağ kenar boşluğu bugün `margin_right 760` (satır 30) — 1600×900'de sağ yarı boş kalır, yerleşim tema ile dolar.
  - Kabul: yerel `ColorRect` rengi 0, tema kaynağından 1. Test: ARY-02 tarama.
  - Bağımlılık: ARY-02, GRV-01. Boyut: M.
  - Dosya: `src/arayuz/ayarlar_ekrani.gd`.
  - Asset: asset gerekmedi.
- [ ] **GRV-03:** Yükleme `eksik`tir, ARY-04 yuvasına bağlanır.
  - Ne: `#0d1117` gömülü renk kalkar. Zemin ARY-04 yuvası ya da yuva yoksa tema nötrüdür. Metin TEK-21 anahtarıdır. Yeni sinematik yok.
  - Kabul: dosyada `Color("#0d1117")` 0. Test: tarama.
  - Bağımlılık: ARY-04, TEK-21. Boyut: S.
  - Dosya: `varlik_yukleme_paneli.gd`.
  - Asset: ARY-04 yer tutucusu. Yeni satır yok.
- [ ] **GRV-04:** Duraklat zemini boş string bırakmaz.
  - Ne: `ana.gd:152` duraklat `arka_plan ""` verir. Boşken `bilgi_ekrani` tema düzlemi kullanır, pembe/şeffaf delik yok.
  - Kabul: duraklatta arka plan düğümü 1. Test: ekran.
  - Bağımlılık: ARY-02. Boyut: S.
  - Dosya: `bilgi_ekrani.gd`.
  - Asset: asset gerekmedi.

### 43.2 ARY-03 sekizi — dosya bağı

- [ ] **GRV-05:** Harita `harita_ekrani.gd`.
  - Ne: ARY-03 harita alt kapanışı bu dosyadır. Bölge haritası (R1) yeniden kurulmaz, kabuk değişir.
  - Kabul: önce/sonra görüntüsü ARY-03 raporunda bu dosya adıyla. Test: ARY-03.
  - Bağımlılık: ARY-03. Boyut: M.
  - Dosya: `src/arayuz/harita_ekrani.gd`.
  - Asset: `ARY03-HARITA` yer tutucu, düz renk.
- [ ] **GRV-06:** Sorgu `kapi_ekrani.gd` konuşma kutusu ve `chr_diyalog_paneli.gd`.
  - Ne: `KONUSMA` dikdörtgeni (satır 14, `Rect2(36, 742, 1104, 314)`) ve sağ `DEFTER` (satır 13) tema kaynağına bağlanır. 3B kapı sahnesi yeniden çizilmez.
  - Kabul: iki panelde yerel renk 0. Test: ARY-02 tarama.
  - Bağımlılık: ARY-03. Boyut: M.
  - Dosya: `kapi_ekrani.gd`, `chr_diyalog_paneli.gd`.
  - Asset: asset gerekmedi.
- [ ] **GRV-07:** Seçim düğmeleri kapı karar çubuğudur.
  - Ne: `kapi_ekrani` karar düğmeleri (`_karar_dugmeleri`) tema düğme durumlarını (normal, üstünde, basılı, kapalı) kullanır. Yeni karar türü eklenmez.
  - Kabul: düğme `StyleBox` tema kaynağından. Test: tarama.
  - Bağımlılık: ARY-02. Boyut: S.
  - Dosya: `kapi_ekrani.gd`.
  - Asset: asset gerekmedi.
- [ ] **GRV-08:** Köy HUD `src/arayuz/koy_hud/`.
  - Ne: 43 panel tek tema kaynağı. Her panele ayrı palet yok. İşlev (pazar, meclis, cenaze, vergi) durur.
  - Kabul: klasörde yerel renk tarama 0, istisna listesi ARY-02 belgesinde. Test: tarama.
  - Bağımlılık: ARY-02. Boyut: L.
  - Dosya: `src/arayuz/koy_hud/*.gd`.
  - Asset: asset gerekmedi.
- [ ] **GRV-09:** Pazar `pazar_satis_paneli.gd`.
  - Ne: ARY-03 pazar alt kapanışı bu panel ve `ticaret_fiyat_paneli.gd`, `pazar_kart_kaydirma.gd`. Fiyat motoru değişmez.
  - Kabul: üç dosyada yerel renk 0. Test: tarama.
  - Bağımlılık: ARY-03. Boyut: S.
  - Dosya: adı geçen üç dosya.
  - Asset: asset gerekmedi.
- [ ] **GRV-10:** Divan `divan_ekrani.gd`.
  - Ne: sorgu, hüküm, kanıt, haksızlık panelleri aynı tema. `divan_meydani.gd` 3B'dir, kabuk işi değildir (Bölüm 44).
  - Kabul: dört panel dosyasında yerel renk 0. Test: tarama.
  - Bağımlılık: ARY-03. Boyut: M.
  - Dosya: `src/kapi/divan_ekrani.gd` ve üç panel.
  - Asset: asset gerekmedi.
- [ ] **GRV-11:** Oda `muhafiz_odasi_ekrani.gd`.
  - Ne: yedi `oda_*` paneli tema. Terazi, vicdan, kasa kuralları ODA maddelerindedir, burada değişmez.
  - Kabul: oda ekranında yerel renk 0. Test: tarama.
  - Bağımlılık: ARY-03. Boyut: M.
  - Dosya: `muhafiz_odasi_ekrani.gd`, `oda_*.gd`.
  - Asset: asset gerekmedi.
- [ ] **GRV-12:** Gece raporu ayrı sahne olmaz.
  - Ne: `gece_bilancosu.gd` çıktısı köy ekranındaki mevcut kadrajda tema ile çizilir. `gece_raporu_ekrani.tscn` açılmaz.
  - Kabul: bu adlı sahne 0. Test: tarama.
  - Bağımlılık: ARY-03. Boyut: S.
  - Dosya: `koy_ekrani.gd` rapor çizimi.
  - Asset: asset gerekmedi.

### 43.3 Okunurluk

- [ ] **GRV-13:** Gövde puntosu 26'nın altına inmez.
  - Ne: `Tema.GOVDE_PX` 26 tabandır; `metin_olcegi` 100'de gövde 26. HUD sayı etiketleri `KUCUK_PX` 22'nin altına yerel punto ile düşmez.
  - Kabul: 22 altı `font_size` override tarama 0 (istisna: `performans_seridi.gd` 18, debug, SRM-05'te yok). Test: tarama.
  - Bağımlılık: ARY-02. Boyut: S.
  - Dosya: `tema.gd`.
  - Asset: asset gerekmedi.
- [ ] **GRV-14:** ADV-01 kart düzeni GRV ile aynı geçişte kapanır.
  - Ne: TEK-03 güvenlik satırı, kart teması değişirken kaybolmaz. İki iş aynı dosyada çakışırsa satır üstte kalır.
  - Kabul: tema sonrası satır görünür. Test: TEK-03.
  - Bağımlılık: TEK-03. Boyut: S.
  - Dosya: `koylu_karti.gd`.
  - Asset: asset gerekmedi.
- [ ] **GRV-15:** Uzun metin kesilmez, kayar.
  - Ne: kapı konuşması ve divan metni `autowrap` + kaydırma. 1920 ve 1280'de son satır kaydırılarak okunur (tester K5).
  - Kabul: 400 karakterlik deneme metninde kesilen glif 0. Test: iki çözünürlük. Ek şart: Çınar meclisi şikâyet satırı kaydırılır; uzun metinde kesilen glif kalmaz. Ek şart: Hüküm sabahı paneli uzun satırda glif kesmez, kaydırır. Ek şart: Tezgâh sabah satırı köy panelinde kesilmez; 400 karakterlik denemede son satır kayarak okunur. Ek şart: Yıl cümlesi köy satırında kesilmez; 400 karakterlik denemede son satır kayarak okunur.
  - Bağımlılık: GRV-06. Boyut: M.
  - Dosya: `chr_diyalog_paneli.gd`, `divan_sorgu_paneli.gd`.
  - Asset: asset gerekmedi.

### 43.4 Odak ve durum

- [ ] **GRV-16:** Düğme dört durumu temadadır.
  - Ne: normal, üstünde, basılı, kapalı. Kapalı devam düğmesi (`pasifler`) kapalı stili kullanır, kaybolmaz.
  - Kabul: kayıtsız menüde devam görünür ve `disabled`. Test: menü.
  - Bağımlılık: ARY-01. Boyut: S.
  - Dosya: `menu_satiri.gd`.
  - Asset: asset gerekmedi.
- [ ] **GRV-17:** Odak çerçevesi AYR ile aynı anahtardır.
  - Ne: klavye odağı kalınlığı AYR `odak_cercevesi` değeridir. Burada ikinci çerçeve rengi yok.
  - Kabul: tema odak stili 1. Test: AYR ile ortak.
  - Bağımlılık: AYR. Boyut: S.
  - Dosya: tema kaynağı.
  - Asset: asset gerekmedi.

### 43.5 Mini oyun ve heybe

- [ ] **GRV-18:** Harman ve okçuluk kadrajı temaya girer, kuralı girmez.
  - Ne: `harman_oyunu.gd`, `okculuk_oyunu.gd` skor yazısı tema puntosu. Oyun eşiği `OlayVerisi` içindedir, değişmez.
  - Kabul: skor puntosu `boyut()` ile ölçeklenir. Test: ölçek 150.
  - Bağımlılık: ARY-02. Boyut: S.
  - Dosya: iki oyun dosyası.
  - Asset: asset gerekmedi.
- [ ] **GRV-19:** Heybe paneli kapı defterinin üstüne taşmaz.
  - Ne: `heybe_paneli.gd` açıkken `DEFTER` dikdörtgeni ile çakışma alanı 0 (tester üst üste panel). Çakışırsa panel konuşma kutusunun üstünde, defterin solunda durur.
  - Kabul: 1600×900'de iki dikdörtgen kesişimi boş. Test: ölçüm.
  - Bağımlılık: GRV-06. Boyut: S.
  - Dosya: `heybe_paneli.gd`.
  - Asset: asset gerekmedi.

### 43.6 Menü

- [ ] **GRV-20:** Menü 3B sahnesi durur.
  - Ne: `MenuSahnesi` referans yerleşimi (4 Ekim notu, dosya başı) bozulmaz. Tema yalnız yazı ve düğmeye gelir.
  - Kabul: `SubViewport` düğümü durur. Test: menü açılır.
  - Bağımlılık: ARY-02. Boyut: S.
  - Dosya: `menu_ekrani.gd`.
  - Asset: asset gerekmedi.
- [ ] **GRV-21:** Menü ipucu köşesi ölçekle taşmaz.
  - Ne: sağ alt ipucu (`offset` satır 74–80) `metin_olcegi` 150'de ekran içinde kalır.
  - Kabul: 150 ölçekte ipucu kutusu viewport içindedir. Test: iki ölçek.
  - Bağımlılık: AYR. Boyut: S.
  - Dosya: `menu_ekrani.gd`.
  - Asset: asset gerekmedi.

### 43.7 Tutarlılık taraması

- [ ] **GRV-22:** Gömülü renk listesi kapanır.
  - Ne: `src/arayuz/**/*.gd` içinde `Color("#` ve `ColorRect` ham renk ARY-02 istisna listesinde değilse hatadır. `Renkler` sabitleri tema kaynağına taşınınca istisna da düşer.
  - Kabul: istisna dışı 0. Test: `tools/` tarama kuralı.
  - Bağımlılık: ARY-02. Boyut: M.
  - Dosya: yeni tarama kuralı, `sanity_check.py` tek satır.
  - Asset: asset gerekmedi.
- [ ] **GRV-23:** Admin katmanı tema yutmaz (ARY-02 kural 4).
  - Ne: `src/debug/` renkleri oyuncu temasına girmez.
  - Kabul: debug dosyası tema kaynağını import etmez. Test: tarama.
  - Bağımlılık: ARY-02. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

### 43.8 Yeni ekranlar — kabuk hazır, sistem değil

- [ ] **GRV-24:** Hafıza defteri kabuğu bu temadadır.
  - Ne: HFZ-01 ekranı bilgi ekranı yerleşimini kullanır, kendi paletini açmaz.
  - Kabul: `hafiza_defteri_ekrani.gd` içinde `Color("#` 0. Test: tarama.
  - Bağımlılık: HFZ-01, ARY-02. Boyut: S.
  - Dosya: `hafiza_defteri_ekrani.gd`.
  - Asset: asset gerekmedi.
- [ ] **GRV-25:** Ayar sekmeleri (35, 45, 46) aynı paneldedir.
  - Ne: ses, görüntü, oyun, kontroller (GIR-01), dil (YER-01) ayrı pencere açmaz. Ayarlar ekranı sekmeli tek kabuktur.
  - Kabul: aynı anda açık ayar penceresi 1. Test: sekme geçişi.
  - Bağımlılık: GIR-01, YER-01, ARY-02. Boyut: M.
  - Dosya: `ayarlar_ekrani.gd`.
  - Asset: asset gerekmedi.

### 43.9 Asset sınırı

- [ ] **GRV-26:** Yeni doku üretilmez.
  - Ne: eksik zemin ARY-05'e yazılır: `GRV02-AYARLAR`, `GRV04-DURAKLAT`. Yer tutucu tema düzlemi. İndirme yok.
  - Kabul: bu madde dosya üretmez. Test: sayım.
  - Bağımlılık: ARY-05. Boyut: S.
  - Dosya: `docs/EKSIK_ASSET_ENVANTERI.md`.
  - Asset: iki envanter satırı. Yer tutucu: tema rengi.
- [x] **GRV-27:** (Claude) Portre ve ikon `Sanat`'tan gelir.
  - Ne: `sanat.gd` `portre` / `doku` durur. Panel kendi `load` yolunu açmaz.
  - Kabul: `src/arayuz` içinde `load("res://assets` tarama, `Sanat.` dışı 0 (istisna belgede). Test: tarama.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

### 43.10 Sınırlar ve kapanış

- [x] **GRV-28:** (Claude — TEK-12 protected-api) Oynanış bu bölümden değişmez.
  - Ne: kabul, ret, hız, fiyat, divan hükmü aynı fonksiyonlardır. Yalnız çizim kaynağı değişir.
  - Kabul: `api_sozlesmesi.py` oyun kuralları farkı 0. Test: araç.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: baseline.
  - Asset: asset gerekmedi.
- [x] **GRV-29:** (Claude) 3B cila Bölüm 44'tür.
  - Ne: kamera, animasyon, pelerin, ayak (TST-0007/0008) burada yoktur.
  - Kabul: `src/koy/gorsel/` diff'i bu bölümden 0. Test: tarama.
  - Bağımlılık: SAH. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **GRV-30:** Kapanış testi.
  - Ne: ayarlar ve yüklemede gömülü renk 0; sekiz ARY-03 dosya adı raporda; duraklat zemini var; heybe-defter kesişimi boş; debug tema import etmez.
  - Kabul: beş iddia. Test: tarama betiği `tests/tools/test_arayuz_renk.py`.
  - Bağımlılık: GRV-01…29. Boyut: M.
  - Dosya: yeni test.
  - Asset: asset gerekmedi.

Alt başlık 43.2'de sekiz madde vardır; diğerlerinde iki ile dört. Onuncu madde, her HUD dosyasına ayrı kimlik açacağı için konmadı (43 dosya tek maddede, GRV-08). Toplam 30 madde.

### 43.11 Ekran envanteri — arka plansız veya düz düğme

Her satır 11 Ekim 2026 taramasındandır (`ColorRect` ve `Button.new` sayımı). Oynanış fonksiyonu değişmez. Asset üretilmez. GRV-08 klasör maddesi durur; burada dosya dosyadır.

#### 43.11 Kapı ve inceleme

- [ ] **GRV-31:** `chr_diyalog_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/chr_diyalog_paneli.gd` bugün ColorRect 0 ve 3 düz düğmeyle duruyor; notu: Konuşma seçenekleri düz düğme. Tema bağlanınca yalnız `chr_diyalog_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Konuşma seçenekleri düz düğme davranışı değişmez.
  - Kabul: `chr_diyalog_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `chr_diyalog_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/chr_diyalog_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-32:** `chr_inceleme_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/chr_inceleme_paneli.gd` bugün ColorRect 0 ve 4 düz düğmeyle duruyor; notu: Bakış seçenekleri düz düğme. Tema bağlanınca yalnız `chr_inceleme_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Bakış seçenekleri düz düğme davranışı değişmez.
  - Kabul: `chr_inceleme_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `chr_inceleme_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/chr_inceleme_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-33:** `grafik_ayarlari_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/grafik_ayarlari_paneli.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Grafik seçicisi düz düğme, zemin yok. Tema bağlanınca yalnız `grafik_ayarlari_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Grafik seçicisi düz düğme, zemin yok davranışı değişmez.
  - Kabul: `grafik_ayarlari_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `grafik_ayarlari_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/grafik_ayarlari_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-34:** `esya_karti.gd` temaya bağlanır.
  - Ne: `src/arayuz/esya_karti.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Eşya kartı zeminsiz. Tema bağlanınca yalnız `esya_karti.gd` ARY-02 zeminini ve düğme durumunu okur, Eşya kartı zeminsiz davranışı değişmez.
  - Kabul: `esya_karti.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `esya_karti.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/esya_karti.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-35:** `hud.gd` temaya bağlanır.
  - Ne: `src/arayuz/hud.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Kapı HUD yazısı zeminsiz. Tema bağlanınca yalnız `hud.gd` ARY-02 zeminini ve düğme durumunu okur, Kapı HUD yazısı zeminsiz davranışı değişmez.
  - Kabul: `hud.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `hud.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/hud.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-36:** `koy_ekrani.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_ekrani.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Köy araç şeridi düz düğme; 3B sahne zemin sayılmaz. Tema bağlanınca yalnız `koy_ekrani.gd` ARY-02 zeminini ve düğme durumunu okur, Köy araç şeridi düz düğme; 3B sahne zemin sayılmaz davranışı değişmez.
  - Kabul: `koy_ekrani.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `koy_ekrani.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_ekrani.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-37:** `koylu_karti.gd` temaya bağlanır.
  - Ne: `src/arayuz/koylu_karti.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Köylü kartı zeminsiz. Tema bağlanınca yalnız `koylu_karti.gd` ARY-02 zeminini ve düğme durumunu okur, Köylü kartı zeminsiz davranışı değişmez.
  - Kabul: `koylu_karti.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `koylu_karti.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koylu_karti.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-38:** `koy_atama_alani.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_atama_alani.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Atama alanı zeminsiz. Tema bağlanınca yalnız `koy_atama_alani.gd` ARY-02 zeminini ve düğme durumunu okur, Atama alanı zeminsiz davranışı değişmez.
  - Kabul: `koy_atama_alani.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `koy_atama_alani.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_atama_alani.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-39:** `heyet_kapi_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/heyet_kapi_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Heyet paneli zeminsiz. Tema bağlanınca yalnız `heyet_kapi_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Heyet paneli zeminsiz davranışı değişmez.
  - Kabul: `heyet_kapi_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `heyet_kapi_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/heyet_kapi_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-40:** `tuccar_kapi_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/tuccar_kapi_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Tüccar paneli zeminsiz. Tema bağlanınca yalnız `tuccar_kapi_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Tüccar paneli zeminsiz davranışı değişmez.
  - Kabul: `tuccar_kapi_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `tuccar_kapi_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/tuccar_kapi_paneli.gd`.
  - Asset: asset gerekmedi.


#### 43.12 Köy, kart, oda

- [ ] **GRV-41:** `oda_gelistirme_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/oda_gelistirme_paneli.gd` bugün ColorRect 0 ve 2 düz düğmeyle duruyor; notu: Geliştirme düğmeleri düz. Tema bağlanınca yalnız `oda_gelistirme_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Geliştirme düğmeleri düz davranışı değişmez.
  - Kabul: `oda_gelistirme_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `oda_gelistirme_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/oda_gelistirme_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-42:** `oda_kasasi_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/oda_kasasi_paneli.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Kasa düğmesi düz, zemin yok. Tema bağlanınca yalnız `oda_kasasi_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Kasa düğmesi düz, zemin yok davranışı değişmez.
  - Kabul: `oda_kasasi_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `oda_kasasi_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/oda_kasasi_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-43:** `oda_terazisi_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/oda_terazisi_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Terazi yazısı zeminsiz. Tema bağlanınca yalnız `oda_terazisi_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Terazi yazısı zeminsiz davranışı değişmez.
  - Kabul: `oda_terazisi_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `oda_terazisi_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/oda_terazisi_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-44:** `oda_vicdan_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/oda_vicdan_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Vicdan yazısı zeminsiz. Tema bağlanınca yalnız `oda_vicdan_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Vicdan yazısı zeminsiz davranışı değişmez.
  - Kabul: `oda_vicdan_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `oda_vicdan_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/oda_vicdan_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-45:** `oda_yetenek_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/oda_yetenek_paneli.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Yetenek düğmesi düz. Tema bağlanınca yalnız `oda_yetenek_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Yetenek düğmesi düz davranışı değişmez.
  - Kabul: `oda_yetenek_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `oda_yetenek_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/oda_yetenek_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-46:** `harman_oyunu.gd` temaya bağlanır.
  - Ne: `src/arayuz/harman_oyunu.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Harman kadrajı zeminsiz. Tema bağlanınca yalnız `harman_oyunu.gd` ARY-02 zeminini ve düğme durumunu okur, Harman kadrajı zeminsiz davranışı değişmez.
  - Kabul: `harman_oyunu.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `harman_oyunu.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/harman_oyunu.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-47:** `okculuk_oyunu.gd` temaya bağlanır.
  - Ne: `src/arayuz/okculuk_oyunu.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Okçuluk kadrajı zeminsiz. Tema bağlanınca yalnız `okculuk_oyunu.gd` ARY-02 zeminini ve düğme durumunu okur, Okçuluk kadrajı zeminsiz davranışı değişmez.
  - Kabul: `okculuk_oyunu.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `okculuk_oyunu.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/okculuk_oyunu.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-48:** `tansiyon_gostergesi.gd` temaya bağlanır.
  - Ne: `src/arayuz/kapi/tansiyon_gostergesi.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Tansiyon yazısı zeminsiz. Tema bağlanınca yalnız `tansiyon_gostergesi.gd` ARY-02 zeminini ve düğme durumunu okur, Tansiyon yazısı zeminsiz davranışı değişmez.
  - Kabul: `tansiyon_gostergesi.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `tansiyon_gostergesi.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/kapi/tansiyon_gostergesi.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-49:** `kapi_gorus_adaptoru.gd` temaya bağlanır.
  - Ne: `src/arayuz/kapi/kapi_gorus_adaptoru.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Görüş satırı zeminsiz. Tema bağlanınca yalnız `kapi_gorus_adaptoru.gd` ARY-02 zeminini ve düğme durumunu okur, Görüş satırı zeminsiz davranışı değişmez.
  - Kabul: `kapi_gorus_adaptoru.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `kapi_gorus_adaptoru.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/kapi/kapi_gorus_adaptoru.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-50:** `divan_ekrani.gd` temaya bağlanır.
  - Ne: `src/kapi/divan_ekrani.gd` bugün ColorRect 0 ve 2 düz düğmeyle duruyor; notu: Divan ekranı zeminsiz, düz düğme. Tema bağlanınca yalnız `divan_ekrani.gd` ARY-02 zeminini ve düğme durumunu okur, Divan ekranı zeminsiz, düz düğme davranışı değişmez.
  - Kabul: `divan_ekrani.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `divan_ekrani.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/kapi/divan_ekrani.gd`.
  - Asset: asset gerekmedi.


#### 43.13 Divan

- [ ] **GRV-51:** `divan_sorgu_paneli.gd` temaya bağlanır.
  - Ne: `src/kapi/divan_sorgu_paneli.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Divan sorgu düğmesi düz. Tema bağlanınca yalnız `divan_sorgu_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Divan sorgu düğmesi düz davranışı değişmez.
  - Kabul: `divan_sorgu_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `divan_sorgu_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/kapi/divan_sorgu_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-52:** `divan_hukum_paneli.gd` temaya bağlanır.
  - Ne: `src/kapi/divan_hukum_paneli.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Hüküm düğmesi düz. Tema bağlanınca yalnız `divan_hukum_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Hüküm düğmesi düz davranışı değişmez.
  - Kabul: `divan_hukum_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `divan_hukum_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/kapi/divan_hukum_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-53:** `divan_haksizlik_paneli.gd` temaya bağlanır.
  - Ne: `src/kapi/divan_haksizlik_paneli.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Haksızlık düğmesi düz. Tema bağlanınca yalnız `divan_haksizlik_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Haksızlık düğmesi düz davranışı değişmez.
  - Kabul: `divan_haksizlik_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `divan_haksizlik_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/kapi/divan_haksizlik_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-54:** `divan_kanit_karti.gd` temaya bağlanır.
  - Ne: `src/kapi/divan_kanit_karti.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Kanıt kartı düz düğme. Tema bağlanınca yalnız `divan_kanit_karti.gd` ARY-02 zeminini ve düğme durumunu okur, Kanıt kartı düz düğme davranışı değişmez.
  - Kabul: `divan_kanit_karti.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `divan_kanit_karti.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/kapi/divan_kanit_karti.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-55:** `ambar_kapisi_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/ambar_kapisi_paneli.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Ambar düğmesi düz. Tema bağlanınca yalnız `ambar_kapisi_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Ambar düğmesi düz davranışı değişmez.
  - Kabul: `ambar_kapisi_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `ambar_kapisi_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/ambar_kapisi_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-56:** `cati_kar_bilgisi.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/cati_kar_bilgisi.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Çatı satırı zeminsiz. Tema bağlanınca yalnız `cati_kar_bilgisi.gd` ARY-02 zeminini ve düğme durumunu okur, Çatı satırı zeminsiz davranışı değişmez.
  - Kabul: `cati_kar_bilgisi.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `cati_kar_bilgisi.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/cati_kar_bilgisi.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-57:** `cinar_meclis_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/cinar_meclis_paneli.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Meclis düğmesi düz. Tema bağlanınca yalnız `cinar_meclis_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Meclis düğmesi düz davranışı değişmez.
  - Kabul: `cinar_meclis_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `cinar_meclis_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/cinar_meclis_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-58:** `harita_baglantisi.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/harita_baglantisi.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Harita düğmesi düz. Tema bağlanınca yalnız `harita_baglantisi.gd` ARY-02 zeminini ve düğme durumunu okur, Harita düğmesi düz davranışı değişmez.
  - Kabul: `harita_baglantisi.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `harita_baglantisi.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/harita_baglantisi.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-59:** `hekim_ilac_bilgisi.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/hekim_ilac_bilgisi.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Hekim satırı zeminsiz. Tema bağlanınca yalnız `hekim_ilac_bilgisi.gd` ARY-02 zeminini ve düğme durumunu okur, Hekim satırı zeminsiz davranışı değişmez.
  - Kabul: `hekim_ilac_bilgisi.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `hekim_ilac_bilgisi.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/hekim_ilac_bilgisi.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-60:** `histeri_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/histeri_paneli.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Histeri düğmesi düz. Tema bağlanınca yalnız `histeri_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Histeri düğmesi düz davranışı değişmez.
  - Kabul: `histeri_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `histeri_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/histeri_paneli.gd`.
  - Asset: asset gerekmedi.


#### 43.14 Köy şeridi — düğmeli

- [ ] **GRV-61:** `kaynak_gostergesi.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/kaynak_gostergesi.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Kaynak yazısı zeminsiz. Tema bağlanınca yalnız `kaynak_gostergesi.gd` ARY-02 zeminini ve düğme durumunu okur, Kaynak yazısı zeminsiz davranışı değişmez.
  - Kabul: `kaynak_gostergesi.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `kaynak_gostergesi.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/kaynak_gostergesi.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-62:** `kese_gostergesi.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/kese_gostergesi.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Kese yazısı zeminsiz. Tema bağlanınca yalnız `kese_gostergesi.gd` ARY-02 zeminini ve düğme durumunu okur, Kese yazısı zeminsiz davranışı değişmez.
  - Kabul: `kese_gostergesi.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `kese_gostergesi.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/kese_gostergesi.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-63:** `kundak_clue_bilgisi.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/kundak_clue_bilgisi.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Kundak satırı zeminsiz. Tema bağlanınca yalnız `kundak_clue_bilgisi.gd` ARY-02 zeminini ve düğme durumunu okur, Kundak satırı zeminsiz davranışı değişmez.
  - Kabul: `kundak_clue_bilgisi.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `kundak_clue_bilgisi.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/kundak_clue_bilgisi.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-64:** `kuyu_kirecleme_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/kuyu_kirecleme_paneli.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Kuyu düğmesi düz. Tema bağlanınca yalnız `kuyu_kirecleme_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Kuyu düğmesi düz davranışı değişmez.
  - Kabul: `kuyu_kirecleme_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `kuyu_kirecleme_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/kuyu_kirecleme_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-65:** `muhafiz_odasi_baglantisi.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/muhafiz_odasi_baglantisi.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Oda düğmesi düz. Tema bağlanınca yalnız `muhafiz_odasi_baglantisi.gd` ARY-02 zeminini ve düğme durumunu okur, Oda düğmesi düz davranışı değişmez.
  - Kabul: `muhafiz_odasi_baglantisi.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `muhafiz_odasi_baglantisi.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/muhafiz_odasi_baglantisi.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-66:** `pazar_satis_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/pazar_satis_paneli.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Pazar düğmesi düz. Tema bağlanınca yalnız `pazar_satis_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Pazar düğmesi düz davranışı değişmez.
  - Kabul: `pazar_satis_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `pazar_satis_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/pazar_satis_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-67:** `saman_bilgisi.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/saman_bilgisi.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Saman düğmesi düz. Tema bağlanınca yalnız `saman_bilgisi.gd` ARY-02 zeminini ve düğme durumunu okur, Saman düğmesi düz davranışı değişmez.
  - Kabul: `saman_bilgisi.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `saman_bilgisi.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/saman_bilgisi.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-68:** `siparis_sozlesme_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/siparis_sozlesme_paneli.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Sözleşme düğmesi düz. Tema bağlanınca yalnız `siparis_sozlesme_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Sözleşme düğmesi düz davranışı değişmez.
  - Kabul: `siparis_sozlesme_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `siparis_sozlesme_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/siparis_sozlesme_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-69:** `su_rezerv_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/su_rezerv_paneli.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Su düğmesi düz. Tema bağlanınca yalnız `su_rezerv_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Su düğmesi düz davranışı değişmez.
  - Kabul: `su_rezerv_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `su_rezerv_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/su_rezerv_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-70:** `yapi_karti.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/yapi_karti.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Yapı kartı zeminsiz. Tema bağlanınca yalnız `yapi_karti.gd` ARY-02 zeminini ve düğme durumunu okur, Yapı kartı zeminsiz davranışı değişmez.
  - Kabul: `yapi_karti.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `yapi_karti.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/yapi_karti.gd`.
  - Asset: asset gerekmedi.


#### 43.15 Köy şeridi — yazı

- [ ] **GRV-71:** `alet_asinma_bilgisi.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/alet_asinma_bilgisi.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Aşınma satırı zeminsiz. Tema bağlanınca yalnız `alet_asinma_bilgisi.gd` ARY-02 zeminini ve düğme durumunu okur, Aşınma satırı zeminsiz davranışı değişmez.
  - Kabul: `alet_asinma_bilgisi.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `alet_asinma_bilgisi.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/alet_asinma_bilgisi.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-72:** `ceki_hayvani_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/ceki_hayvani_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Çeki hayvanı paneli zeminsiz. Tema bağlanınca yalnız `ceki_hayvani_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Çeki hayvanı paneli zeminsiz davranışı değişmez.
  - Kabul: `ceki_hayvani_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `ceki_hayvani_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/ceki_hayvani_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-73:** `celep_pazar_adaptoru.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/celep_pazar_adaptoru.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Celep adaptörü zeminsiz. Tema bağlanınca yalnız `celep_pazar_adaptoru.gd` ARY-02 zeminini ve düğme durumunu okur, Celep adaptörü zeminsiz davranışı değişmez.
  - Kabul: `celep_pazar_adaptoru.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `celep_pazar_adaptoru.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/celep_pazar_adaptoru.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-74:** `cenaze_raporu.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/cenaze_raporu.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Cenaze raporu zeminsiz. Tema bağlanınca yalnız `cenaze_raporu.gd` ARY-02 zeminini ve düğme durumunu okur, Cenaze raporu zeminsiz davranışı değişmez.
  - Kabul: `cenaze_raporu.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `cenaze_raporu.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/cenaze_raporu.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-75:** `cete_anlasma_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/cete_anlasma_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Çete paneli zeminsiz. Tema bağlanınca yalnız `cete_anlasma_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Çete paneli zeminsiz davranışı değişmez.
  - Kabul: `cete_anlasma_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `cete_anlasma_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/cete_anlasma_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-76:** `gezgin_stok_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/gezgin_stok_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Gezgin stok paneli zeminsiz. Tema bağlanınca yalnız `gezgin_stok_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Gezgin stok paneli zeminsiz davranışı değişmez.
  - Kabul: `gezgin_stok_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `gezgin_stok_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/gezgin_stok_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-77:** `gezgin_tuccar_pazar_adaptoru.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/gezgin_tuccar_pazar_adaptoru.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Gezgin tüccar adaptörü zeminsiz. Tema bağlanınca yalnız `gezgin_tuccar_pazar_adaptoru.gd` ARY-02 zeminini ve düğme durumunu okur, Gezgin tüccar adaptörü zeminsiz davranışı değişmez.
  - Kabul: `gezgin_tuccar_pazar_adaptoru.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `gezgin_tuccar_pazar_adaptoru.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/gezgin_tuccar_pazar_adaptoru.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-78:** `goc_yolu_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/goc_yolu_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Göç yolu paneli zeminsiz. Tema bağlanınca yalnız `goc_yolu_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Göç yolu paneli zeminsiz davranışı değişmez.
  - Kabul: `goc_yolu_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `goc_yolu_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/goc_yolu_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-79:** `hayvan_takas_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/hayvan_takas_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Hayvan takas paneli zeminsiz. Tema bağlanınca yalnız `hayvan_takas_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Hayvan takas paneli zeminsiz davranışı değişmez.
  - Kabul: `hayvan_takas_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `hayvan_takas_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/hayvan_takas_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-80:** `karantina_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/karantina_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Karantina paneli zeminsiz. Tema bağlanınca yalnız `karantina_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Karantina paneli zeminsiz davranışı değişmez.
  - Kabul: `karantina_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `karantina_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/karantina_paneli.gd`.
  - Asset: asset gerekmedi.


#### 43.16 Köy şeridi — kalan paneller

- [ ] **GRV-81:** `kasa_transfer_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/kasa_transfer_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Kasa transferi zeminsiz. Tema bağlanınca yalnız `kasa_transfer_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Kasa transferi zeminsiz davranışı değişmez.
  - Kabul: `kasa_transfer_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `kasa_transfer_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/kasa_transfer_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-82:** `kervan_koruma_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/kervan_koruma_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Kervan koruma paneli zeminsiz. Tema bağlanınca yalnız `kervan_koruma_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Kervan koruma paneli zeminsiz davranışı değişmez.
  - Kabul: `kervan_koruma_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `kervan_koruma_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/kervan_koruma_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-83:** `konuslanma_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/konuslanma_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Konuşlanma paneli zeminsiz. Tema bağlanınca yalnız `konuslanma_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Konuşlanma paneli zeminsiz davranışı değişmez.
  - Kabul: `konuslanma_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `konuslanma_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/konuslanma_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-84:** `kumas_aktar_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/kumas_aktar_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Kumaş aktarım paneli zeminsiz. Tema bağlanınca yalnız `kumas_aktar_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Kumaş aktarım paneli zeminsiz davranışı değişmez.
  - Kabul: `kumas_aktar_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `kumas_aktar_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/kumas_aktar_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-85:** `mevsim_takvim.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/mevsim_takvim.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Mevsim takvimi zeminsiz. Tema bağlanınca yalnız `mevsim_takvim.gd` ARY-02 zeminini ve düğme durumunu okur, Mevsim takvimi zeminsiz davranışı değişmez.
  - Kabul: `mevsim_takvim.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `mevsim_takvim.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/mevsim_takvim.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-86:** `oba_ittifak_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/oba_ittifak_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Oba paneli zeminsiz. Tema bağlanınca yalnız `oba_ittifak_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Oba paneli zeminsiz davranışı değişmez.
  - Kabul: `oba_ittifak_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `oba_ittifak_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/oba_ittifak_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-87:** `pazar_kart_kaydirma.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/pazar_kart_kaydirma.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Pazar kaydırma zeminsiz. Tema bağlanınca yalnız `pazar_kart_kaydirma.gd` ARY-02 zeminini ve düğme durumunu okur, Pazar kaydırma zeminsiz davranışı değişmez.
  - Kabul: `pazar_kart_kaydirma.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `pazar_kart_kaydirma.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/pazar_kart_kaydirma.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-88:** `silah_karaborsa_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/silah_karaborsa_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Silah paneli zeminsiz. Tema bağlanınca yalnız `silah_karaborsa_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Silah paneli zeminsiz davranışı değişmez.
  - Kabul: `silah_karaborsa_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `silah_karaborsa_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/silah_karaborsa_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-89:** `siparis_ihlal_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/siparis_ihlal_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: İhlal paneli zeminsiz. Tema bağlanınca yalnız `siparis_ihlal_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, İhlal paneli zeminsiz davranışı değişmez.
  - Kabul: `siparis_ihlal_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `siparis_ihlal_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/siparis_ihlal_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-90:** `siparis_komisyon_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/siparis_komisyon_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Komisyon paneli zeminsiz. Tema bağlanınca yalnız `siparis_komisyon_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Komisyon paneli zeminsiz davranışı değişmez.
  - Kabul: `siparis_komisyon_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `siparis_komisyon_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/siparis_komisyon_paneli.gd`.
  - Asset: asset gerekmedi.


#### 43.17 Tek renk ve bağlar

- [ ] **GRV-91:** `siparis_teslim_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/siparis_teslim_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Teslim paneli zeminsiz. Tema bağlanınca yalnız `siparis_teslim_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Teslim paneli zeminsiz davranışı değişmez.
  - Kabul: `siparis_teslim_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `siparis_teslim_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/siparis_teslim_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-92:** `ticaret_fiyat_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/ticaret_fiyat_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Fiyat paneli zeminsiz. Tema bağlanınca yalnız `ticaret_fiyat_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Fiyat paneli zeminsiz davranışı değişmez.
  - Kabul: `ticaret_fiyat_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `ticaret_fiyat_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/ticaret_fiyat_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-93:** `vergi_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/vergi_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Vergi paneli zeminsiz. Tema bağlanınca yalnız `vergi_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Vergi paneli zeminsiz davranışı değişmez.
  - Kabul: `vergi_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `vergi_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/vergi_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-94:** `gezgin_stok_ikonu.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/gezgin_stok_ikonu.gd` bugün ColorRect 1 ve 0 düz düğmeyle duruyor; notu: Tek ColorRect var, tema kaynağına bağlı değil. Tema bağlanınca yalnız `gezgin_stok_ikonu.gd` ARY-02 zeminini ve düğme durumunu okur, Tek ColorRect var, tema kaynağına bağlı değil davranışı değişmez.
  - Kabul: `gezgin_stok_ikonu.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `gezgin_stok_ikonu.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/gezgin_stok_ikonu.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-95:** `haberci_anlati_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/haberci_anlati_paneli.gd` bugün ColorRect 1 ve 0 düz düğmeyle duruyor; notu: Tek ColorRect, düz anlatı. Tema bağlanınca yalnız `haberci_anlati_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Tek ColorRect, düz anlatı davranışı değişmez.
  - Kabul: `haberci_anlati_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `haberci_anlati_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/haberci_anlati_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-96:** `kisisel_karaborsa_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/kisisel_karaborsa_paneli.gd` bugün ColorRect 1 ve 0 düz düğmeyle duruyor; notu: Tek ColorRect, tema dışı. Tema bağlanınca yalnız `kisisel_karaborsa_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Tek ColorRect, tema dışı davranışı değişmez.
  - Kabul: `kisisel_karaborsa_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `kisisel_karaborsa_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/kisisel_karaborsa_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-97:** `tekfur_heyeti_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/tekfur_heyeti_paneli.gd` bugün ColorRect 1 ve 0 düz düğmeyle duruyor; notu: Tek ColorRect, tema dışı. Tema bağlanınca yalnız `tekfur_heyeti_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Tek ColorRect, tema dışı davranışı değişmez.
  - Kabul: `tekfur_heyeti_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `tekfur_heyeti_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/tekfur_heyeti_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-98:** `koylu_surukleme_kulpu.gd` temaya bağlanır.
  - Ne: `src/arayuz/koylu_surukleme_kulpu.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Sürükleme kulpu zeminsiz. Tema bağlanınca yalnız `koylu_surukleme_kulpu.gd` ARY-02 zeminini ve düğme durumunu okur, Sürükleme kulpu zeminsiz davranışı değişmez.
  - Kabul: `koylu_surukleme_kulpu.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `koylu_surukleme_kulpu.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koylu_surukleme_kulpu.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-99:** `divan_baglantisi.gd` temaya bağlanır.
  - Ne: `src/kapi/divan_baglantisi.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Divan açılış düğmesi düz. Tema bağlanınca yalnız `divan_baglantisi.gd` ARY-02 zeminini ve düğme durumunu okur, Divan açılış düğmesi düz davranışı değişmez.
  - Kabul: `divan_baglantisi.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `divan_baglantisi.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/kapi/divan_baglantisi.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-100:** `chr_kapi_adaptoru.gd` temaya bağlanır.
  - Ne: `src/arayuz/chr_kapi_adaptoru.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Kapı adaptör düğmesi düz. Tema bağlanınca yalnız `chr_kapi_adaptoru.gd` ARY-02 zeminini ve düğme durumunu okur, Kapı adaptör düğmesi düz davranışı değişmez.
  - Kabul: `chr_kapi_adaptoru.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `chr_kapi_adaptoru.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/chr_kapi_adaptoru.gd`.
  - Asset: asset gerekmedi.


#### 43.18 Ekran

- [ ] **GRV-101:** `hastalik_teshis_adaptoru.gd` temaya bağlanır.
  - Ne: `src/kapi/hastalik_teshis_adaptoru.gd` bugün ColorRect 0 ve 2 düz düğmeyle duruyor; notu: Teşhis düğmeleri düz. Tema bağlanınca yalnız `hastalik_teshis_adaptoru.gd` ARY-02 zeminini ve düğme durumunu okur, Teşhis düğmeleri düz davranışı değişmez.
  - Kabul: `hastalik_teshis_adaptoru.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `hastalik_teshis_adaptoru.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/kapi/hastalik_teshis_adaptoru.gd`.
  - Asset: asset gerekmedi.


43.11–43.18 taramanın arka plansız veya düz düğmeli panelleridir. Mantık dosyaları (`fisilti_gazetesi.gd`, `divan_hukmu.gd`, `ipucu_yoneticisi.gd`) ekran değildir, satır açılmadı. Son kimlik GRV-101.


---

## BÖLÜM 44: 3B sahne, kamera ve animasyon cilası


Kod tarafı. Faz sırası: Bölüm 43 bittikten sonra, Bölüm 45'ten önce. Bölüm 26–30 genişletmesi bundan da sonradır.

Zemin: yürüme ağı ANI-13, takip kamerası ANI-14, orta tuş kaydırma BUG-24, kemik soketi ANI-11, boşta bekleme ANI-12, eksik klipte idle BUG-09 ve BUG-12, ışık BUG-04, hava tepkisi ANI-09, devriye ANI-02, ateş başı ANI-07, tezgâh ANI-08, el eşyası `src/dunya/el_esyasi.gd`. Bunlar yeniden kurulmaz. Bu bölüm onların oturuşunu düzeltir.

Görsel hata denetimi `tests/oto/karakter_muayene.tscn` ve Tester TST-08 ile bağlanır. O maddeler burada kopyalanmaz. Eksik klip üretilmez. Adı ARY-05 listesine yazılır.

Alt başlıklar ondur. Her birinde sekiz madde vardır. Dokuzuncu, var olan bir ANI maddesini ikinci kez yazacağı için konmadı.

Bölüm 45 ile sınır: burada tuş yoktur. Kamera orta tuşu BUG-24'te kalır. Bölüm 43 ile sınır: burada panel ve düğme yoktur. Işık, modelin üstündedir.

### 44.1 Ayak ve zemin

- [ ] **SAH-01:** Ayak, yürünebilir zeminin üstündedir.
  - Ne: tarla, patika ve kapı eşiğinde topuk zeminin altından geçmez. 20 adımlık yürüyüşte gömülme karesi 0'dır.
  - Kabul: tarla, patika ve kapı eşiğinde topuk zeminin altından geçmez. 20 adımlık yürüyüşte gömülme karesi 0'dır. Test: üç zemin, muayene aracı yüksekliği yazar.
  - Bağımlılık: ANI-13. Boyut: M.
  - Dosya: `src/dunya/ayak_zemini.gd` (yeni). Karakter modele tek bağ.
  - Asset: asset gerekmedi.
- [ ] **SAH-02:** Eğik zeminde ayak yüzeyi izler.
  - Ne: yokuşta iki ayak aynı dünya yüksekliğine zorlanmaz. Her ayak kendi değdiği noktadadır.
  - Kabul: yokuşta iki ayak aynı dünya yüksekliğine zorlanmaz. Her ayak kendi değdiği noktadadır. Test: eğimli hücre, iki ayak yüksekliği farklı.
  - Bağımlılık: SAH-01. Boyut: M.
  - Dosya: `src/dunya/ayak_zemini.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-03:** Ayak kayması adım boyunu aşmaz.
  - Ne: bir adımda ayak, görünen adım uzunluğundan fazla kaymaz. Ölçü iskelet ile kök hareketinin farkıdır.
  - Kabul: bir adımda ayak, görünen adım uzunluğundan fazla kaymaz. Ölçü iskelet ile kök hareketinin farkıdır. Test: 10 adım, fark tablodaki eşiğin altında.
  - Bağımlılık: SAH-01. Boyut: M.
  - Dosya: `src/dunya/ayak_zemini.gd`. Eşik `data/ayarlar/sahne.json`.
  - Asset: asset gerekmedi.
- [ ] **SAH-04:** Durunca ayaklar kapanır.
  - Ne: hız sıfır olunca kayma birikmez. Karakter yokuşta yavaşça aşağı akmaz.
  - Kabul: hız sıfır olunca kayma birikmez. Karakter yokuşta yavaşça aşağı akmaz. Test: 5 saniye duruş, konum deltası eşik altı.
  - Bağımlılık: SAH-03. Boyut: S.
  - Dosya: `src/dunya/ayak_zemini.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-05:** Kapı eşiği ayrı bir zemin değildir.
  - Ne: eşik, ANI-13 ağının bir hücresidir. İkinci bir yükseklik sabiti kodda yoktur.
  - Kabul: eşik, ANI-13 ağının bir hücresidir. İkinci bir yükseklik sabiti kodda yoktur. Test: eşikte gömülme 0, ağ dışı hücreye ayak basılmaz.
  - Bağımlılık: ANI-13, SAH-01. Boyut: S.
  - Dosya: `src/dunya/ayak_zemini.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-06:** Çömelme ve eğilme ayağı yerden koparmaz.
  - Ne: kabuldeki şükran ve retteki diz çökme, ayak tabanını zeminde tutar. Klip yoksa BUG-09 idle'a düşer, ayak yine zemindedir.
  - Kabul: kabuldeki şükran ve retteki diz çökme, ayak tabanını zeminde tutar. Klip yoksa BUG-09 idle'a düşer, ayak yine zemindedir. Test: iki poz, taban yüksekliği.
  - Bağımlılık: SAH-01, BUG-09. Boyut: S.
  - Dosya: `src/dunya/ayak_zemini.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-07:** Kalabalıkta ayak birbirinin içinden geçmez.
  - Ne: iki karakterin kökleri ANI-13 çarpışma payından yakına girmez. Ayak cilası bu payı daraltmaz.
  - Kabul: iki karakterin kökleri ANI-13 çarpışma payından yakına girmez. Ayak cilası bu payı daraltmaz. Test: iki model, aralık en az pay.
  - Bağımlılık: ANI-13, SAH-01. Boyut: S.
  - Dosya: `src/dunya/ayak_zemini.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-08:** Muayene aracı ayak yüksekliğini yazar.
  - Ne: `karakter_muayene.tscn` her model için en alçak kemik yüksekliğini satır yazar. Eşik altı satır hata sayılır. TST-08'in adımları burada yoktur.
  - Kabul: `karakter_muayene.tscn` her model için en alçak kemik yüksekliğini satır yazar. Eşik altı satır hata sayılır. TST-08'in adımları burada yoktur. Test: bilerek gömülü model, raporda 1 satır.
  - Bağımlılık: SAH-01. Boyut: S.
  - Dosya: `tests/oto/karakter_muayene.gd`.
  - Asset: asset gerekmedi.

### 44.2 El eşyası

- [ ] **SAH-09:** Eşya, eldeki sokettedir.
  - Ne: `el_esyasi.gd` avuç noktasını kullanır. Eşya göğüs veya uyluk kemikle kesişmez.
  - Kabul: `el_esyasi.gd` avuç noktasını kullanır. Eşya göğüs veya uyluk kemikle kesişmez. Test: 8 eşya türü, kesişen kare 0.
  - Bağımlılık: ANI-11. Boyut: M.
  - Dosya: `src/dunya/el_esyasi.gd`.
  - Asset: asset gerekmedi. Çakışan tür ARY-05'e `SAH-EL-CAKISMA` diye yazılır, üretilmez.
- [ ] **SAH-10:** Yürürken eşya ele yapışıktır.
  - Ne: kök hızlanırken eşya ele göre 2 santimden fazla gecikmez.
  - Kabul: kök hızlanırken eşya ele göre 2 santimden fazla gecikmez. Test: 20 adım, gecikme eşiği.
  - Bağımlılık: SAH-09. Boyut: S.
  - Dosya: `src/dunya/el_esyasi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-11:** Eğilince eşya yere girmez.
  - Ne: diz çökmede asılı eşya zeminin altına inmez. Asa dik kalır. Mevcut sarkma kuralı durur.
  - Kabul: diz çökmede asılı eşya zeminin altına inmez. Asa dik kalır. Mevcut sarkma kuralı durur. Test: çuval ve asa, zemin kesişimi 0.
  - Bağımlılık: SAH-06, SAH-09. Boyut: S.
  - Dosya: `src/dunya/el_esyasi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-12:** İki elde iki eşya omurgayı delmez.
  - Ne: heybe ve araç aynı anda takılıysa birbirinin ve gövdenin içinden geçmez.
  - Kabul: heybe ve araç aynı anda takılıysa birbirinin ve gövdenin içinden geçmez. Test: çift soket, kesişim 0.
  - Bağımlılık: ANI-11, SAH-09. Boyut: M.
  - Dosya: `src/dunya/el_esyasi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-13:** Konuşma klibi eşyayı düşürmez.
  - Ne: ağız klibi oynarken tutuş soketi kopmaz. Klip yoksa idle, eşya elde kalır.
  - Kabul: ağız klibi oynarken tutuş soketi kopmaz. Klip yoksa idle, eşya elde kalır. Test: konuşma 3 saniye, soket dolu.
  - Bağımlılık: BUG-09, SAH-09. Boyut: S.
  - Dosya: `src/dunya/el_esyasi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-14:** Kapıdaki yük, köydeki yükle aynı sokettedir.
  - Ne: kabul edilen kişinin el eşyası kapıdan köye geçince türü değişmez, noktası değişmez. İkinci tutuş tablosu yok.
  - Kabul: kabul edilen kişinin el eşyası kapıdan köye geçince türü değişmez, noktası değişmez. İkinci tutuş tablosu yok. Test: aynı tür, iki sahne, aynı soket adı.
  - Bağımlılık: SAH-09. Boyut: S.
  - Dosya: `data/el_esyalari.json`.
  - Asset: asset gerekmedi.
- [ ] **SAH-15:** Çocuk modelinde büyük yük küçülür.
  - Ne: ölçek, model boyunun oranıdır. Sabit yetişkin ölçeği çocukta gövdeyi yutmaz.
  - Kabul: ölçek, model boyunun oranıdır. Sabit yetişkin ölçeği çocukta gövdeyi yutmaz. Test: çocuk ve yetişkin, eşya boyu oran içinde.
  - Bağımlılık: SAH-09, UZM-08. Boyut: S.
  - Dosya: `src/dunya/el_esyasi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-16:** Muayene kesişen eşyayı listeler.
  - Ne: araç, kemikle kesişen eşya türünü yazar. Liste ARY-05'e işlenir, model üretilmez.
  - Kabul: araç, kemikle kesişen eşya türünü yazar. Liste ARY-05'e işlenir, model üretilmez. Test: kasıtlı kesişim, raporda tür adı.
  - Bağımlılık: SAH-08, SAH-09. Boyut: S.
  - Dosya: `tests/oto/karakter_muayene.gd`. `docs/EKSIK_ASSET_ENVANTERI.md` satırı.
  - Asset: çakışan eşya `SAH-EL-*`. Yer tutucu mevcut kutu.

### 44.3 Yürüme, koşma, durma

- [ ] **SAH-17:** Hız üç bandadır.
  - Ne: dur, yürü, koş. Bant eşikleri `sahne.json` içindedir. Kodda sabit hız yoktur.
  - Kabul: dur, yürü, koş. Bant eşikleri `sahne.json` içindedir. Kodda sabit hız yoktur. Test: üç bant, üç klip adı.
  - Bağımlılık: DEN-01 ile aynı kural, dosya ayrı. Boyut: S.
  - Dosya: `data/ayarlar/sahne.json`.
  - Asset: asset gerekmedi.
- [ ] **SAH-18:** Durmadan yürümeye geçiş karışıktır.
  - Ne: geçiş bir karede zıplamaz. Karışım süresi tablodadır.
  - Kabul: geçiş bir karede zıplamaz. Karışım süresi tablodadır. Test: geçişin ilk karesinde poz, dur klibine daha yakındır.
  - Bağımlılık: SAH-17. Boyut: M.
  - Dosya: `src/dunya/hareket_gecisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-19:** Koşu yalnız kovalama ve kaçışta açılır.
  - Ne: günlük devriye yürür. Koşu, mevcut kaçış ve kovalama olayına bağlıdır. Yeni bir koşu hali yazılmaz.
  - Kabul: günlük devriye yürür. Koşu, mevcut kaçış ve kovalama olayına bağlıdır. Yeni bir koşu hali yazılmaz. Test: devriyede koşu klibi 0.
  - Bağımlılık: ANI-02, SAH-17. Boyut: S.
  - Dosya: `src/dunya/hareket_gecisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-20:** Durunca kayma SAH-04 ile kapanır.
  - Ne: hız bandı dura düşünce ayak cilası aynı karede devreye girer. İki sistem bir kare gecikmez.
  - Kabul: hız bandı dura düşünce ayak cilası aynı karede devreye girer. İki sistem bir kare gecikmez. Test: duruş karesi, kayma 0.
  - Bağımlılık: SAH-04, SAH-18. Boyut: S.
  - Dosya: `src/dunya/hareket_gecisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-21:** Yokuşta bant değişmez, adım kısalır.
  - Ne: eğim hızı ANI-13 ile gelir. Koşu bandı eğim yüzünden kendiliğinden açılmaz.
  - Kabul: eğim hızı ANI-13 ile gelir. Koşu bandı eğim yüzünden kendiliğinden açılmaz. Test: yokuşta bant yürü, kök hız düşük.
  - Bağımlılık: ANI-13, SAH-17. Boyut: S.
  - Dosya: `src/dunya/hareket_gecisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-22:** Yorgun yürüyüş ayrı bir klip istemez.
  - Ne: YSM yorgunluğu mevcut yürüyüşün hızını düşürür. Yeni yorgun klip üretilmez. Klip yoksa listeye yazılır, idle oynar.
  - Kabul: YSM yorgunluğu mevcut yürüyüşün hızını düşürür. Yeni yorgun klip üretilmez. Klip yoksa listeye yazılır, idle oynar. Test: yorgun hız < tok hız, klip adı aynı.
  - Bağımlılık: YSM-01, BUG-09. Boyut: S.
  - Dosya: `src/dunya/hareket_gecisi.gd`.
  - Asset: yorgun klip gerekirse `SAH-YORGUN-YURU`. Üretilmez.
- [ ] **SAH-23:** Kapıdaki bekleme yürümeyi keser.
  - Ne: sorgu sırasında kök hız 0'dır. Konuşma klibi yürüyüşle karışmaz.
  - Kabul: sorgu sırasında kök hız 0'dır. Konuşma klibi yürüyüşle karışmaz. Test: sorgu 5 saniye, konum deltası eşik altı.
  - Bağımlılık: SAH-17. Boyut: S.
  - Dosya: `src/dunya/hareket_gecisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-24:** Geçiş süresi zorluğu değiştirmez.
  - Ne: DEN-65 üç zorlukta da karışım süresi aynıdır.
  - Kabul: DEN-65 üç zorlukta da karışım süresi aynıdır. Test: iki zorluk, süre eşit.
  - Bağımlılık: SAH-18, DEN-65. Boyut: S.
  - Dosya: `data/ayarlar/sahne.json`.
  - Asset: asset gerekmedi.

### 44.4 Animasyon karıştırma

- [ ] **SAH-25:** İki klip birden tam ağırlıkta oynamaz.
  - Ne: karışım ağırlıkları toplamı 1'dir.
  - Kabul: karışım ağırlıkları toplamı 1'dir. Test: yürüyüşten duruşa, ara karede toplam 1.
  - Bağımlılık: SAH-18. Boyut: S.
  - Dosya: `src/dunya/hareket_gecisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-26:** Üst gövde konuşur, alt gövde yürür.
  - Ne: yalnız köyde, elde iş varken. Kapı sorgusunda alt gövde durur (SAH-23).
  - Kabul: yalnız köyde, elde iş varken. Kapı sorgusunda alt gövde durur (SAH-23). Test: tarlada konuşma, bacak klibi yürüyüş.
  - Bağımlılık: SAH-23, ANI-08. Boyut: M.
  - Dosya: `src/dunya/hareket_gecisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-27:** Eksik klip karışımı bozmaz.
  - Ne: BUG-09 idle'a düşer. Karışım, olmayan klibi ağırlığa katmaz.
  - Kabul: BUG-09 idle'a düşer. Karışım, olmayan klibi ağırlığa katmaz. Test: silinmiş klip, çökme yok, idle ağırlığı 1.
  - Bağımlılık: BUG-09, SAH-25. Boyut: S.
  - Dosya: `src/dunya/hareket_gecisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-28:** Bekleme çeşitliliği karışımı kesmez.
  - Ne: ANI-12 ofseti durur. Ofset, geçiş ortasında klibi sıfırlamaz.
  - Kabul: ANI-12 ofseti durur. Ofset, geçiş ortasında klibi sıfırlamaz. Test: iki karakter, geçiş sırasında ofset korunur.
  - Bağımlılık: ANI-12, SAH-18. Boyut: S.
  - Dosya: `src/dunya/hareket_gecisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-29:** Tezgâh klibi yürüyüşle karışmaz.
  - Ne: ANI-08 iş noktasında kök hız 0, üst gövde iş klibidir. Yürüyüş ağırlığı 0.
  - Kabul: ANI-08 iş noktasında kök hız 0, üst gövde iş klibidir. Yürüyüş ağırlığı 0. Test: örs başında bacak klibi değil.
  - Bağımlılık: ANI-08, SAH-26. Boyut: S.
  - Dosya: `src/dunya/hareket_gecisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-30:** Hava tepkisi ayrı bir karışım katmanıdır.
  - Ne: ANI-09 üşüme, yürüyüşü değiştirmez. Üst üste biner, yerine geçmez.
  - Kabul: ANI-09 üşüme, yürüyüşü değiştirmez. Üst üste biner, yerine geçmez. Test: karda yürüme klibi durur, omuz katmanı eklenir.
  - Bağımlılık: ANI-09, SAH-26. Boyut: S.
  - Dosya: `src/dunya/hareket_gecisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-31:** Karışım kayda yazılmaz.
  - Ne: KAY göçü klip ağırlığı tutmaz. Yüklemede bant, hızdan yeniden kurulur.
  - Kabul: KAY göçü klip ağırlığı tutmaz. Yüklemede bant, hızdan yeniden kurulur. Test: kayıtta ağırlık alanı yok.
  - Bağımlılık: KAY-03, SAH-17. Boyut: S.
  - Dosya: `src/dunya/hareket_gecisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-32:** Aynı karede üç geçiş olmaz.
  - Ne: dur, yürü, koş aynı karede sıralanırsa ortadaki atlanır. Titreme yok.
  - Kabul: dur, yürü, koş aynı karede sıralanırsa ortadaki atlanır. Titreme yok. Test: hız zıplaması, tek geçiş.
  - Bağımlılık: SAH-18. Boyut: S.
  - Dosya: `src/dunya/hareket_gecisi.gd`.
  - Asset: asset gerekmedi.

### 44.5 Kalabalıkta yol

- [ ] **SAH-33:** Yol ağı ANI-13'tür.
  - Ne: ikinci navigasyon bölgesi yok. Kapı, tarla ve patika aynı ağdadır.
  - Kabul: ikinci navigasyon bölgesi yok. Kapı, tarla ve patika aynı ağdadır. Test: ağ sayısı 1.
  - Bağımlılık: ANI-13. Boyut: S.
  - Dosya: mevcut köy sahnesi.
  - Asset: asset gerekmedi.
- [ ] **SAH-34:** İki kişi aynı hücreye oturmaz.
  - Ne: varış hücresi doluysa komşu boş hücre seçilir. İç içe model 0'dır.
  - Kabul: varış hücresi doluysa komşu boş hücre seçilir. İç içe model 0'dır. Test: 8 kişi, bir kapı, kesişim 0.
  - Bağımlılık: ANI-13, SAH-07. Boyut: M.
  - Dosya: `src/dunya/kalabalik_yol.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-35:** Sıradaki kişi kapı çizgisini tutar.
  - Ne: kapı kuyruğu mevcut sıranın üstüne kurulur. Yeni bir kuyruk dizilimi yazılmaz.
  - Kabul: kapı kuyruğu mevcut sıranın üstüne kurulur. Yeni bir kuyruk dizilimi yazılmaz. Test: 4 kişi, çizgi sırası bozulmaz.
  - Bağımlılık: SAH-34. Boyut: S.
  - Dosya: `src/dunya/kalabalik_yol.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-36:** Dar kapıdan tek kişi geçer.
  - Ne: eşik hücresi aynı anda bir köke açıktır. İkinci kişi bekler, itmez.
  - Kabul: eşik hücresi aynı anda bir köke açıktır. İkinci kişi bekler, itmez. Test: iki kişi, eşikte bir kök.
  - Bağımlılık: SAH-05, SAH-34. Boyut: S.
  - Dosya: `src/dunya/kalabalik_yol.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-37:** Sıkışan kişi idle'a düşer.
  - Ne: 2 saniye yol bulamayan kök yürümeyi keser, ANI-12 bekler. Işınlanma yoktur.
  - Kabul: 2 saniye yol bulamayan kök yürümeyi keser, ANI-12 bekler. Işınlanma yoktur. Test: kapalı avlu, ışın 0.
  - Bağımlılık: ANI-12, SAH-34. Boyut: S.
  - Dosya: `src/dunya/kalabalik_yol.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-38:** Gece devriyesi kalabalığı delmez.
  - Ne: ANI-02 rotası dolu hücreden kayar. Nöbetçi köylünün içinden geçmez.
  - Kabul: ANI-02 rotası dolu hücreden kayar. Nöbetçi köylünün içinden geçmez. Test: ateş başı kalabalık, devriye kesişimi 0.
  - Bağımlılık: ANI-02, SAH-34. Boyut: M.
  - Dosya: `src/dunya/kalabalik_yol.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-39:** On kişide yol bir kareyi aşmaz.
  - Ne: yol hesabı kare bütçesinin içindedir. Bütçe `sahne.json` içindedir. Aşımda o karede yeni yol aranmaz, eski yol sürer.
  - Kabul: yol hesabı kare bütçesinin içindedir. Bütçe `sahne.json` içindedir. Aşımda o karede yeni yol aranmaz, eski yol sürer. Test: 10 kişi, aşım satırı.
  - Bağımlılık: SAH-34. Boyut: M.
  - Dosya: `data/ayarlar/sahne.json`.
  - Asset: asset gerekmedi.
- [ ] **SAH-40:** Çocuk ve yaşlı aynı ağı kullanır.
  - Ne: UZM-08 ayrı navigasyon açmaz. Hızları banttan düşer (SAH-22).
  - Kabul: UZM-08 ayrı navigasyon açmaz. Hızları banttan düşer (SAH-22). Test: iki yaş, ağ kimliği aynı.
  - Bağımlılık: UZM-08, SAH-33. Boyut: S.
  - Dosya: `src/dunya/kalabalik_yol.gd`.
  - Asset: asset gerekmedi.

### 44.6 Kamera

- [ ] **SAH-41:** Köy kamerası ANI-14 ve BUG-24'tür.
  - Ne: takip ve orta tuş kaydırma durur. İkinci kamera rig'i yok.
  - Kabul: takip ve orta tuş kaydırma durur. İkinci kamera rig'i yok. Test: iki giriş aynı kamerayı oynatır.
  - Bağımlılık: ANI-14, BUG-24. Boyut: S.
  - Dosya: `src/dunya/kamera_surukleme.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-42:** Yakınlaştırma sınırlıdır.
  - Ne: tekerlek, tablodaki alt ve üst yüksekliğin dışına çıkmaz. Zemin delinmez.
  - Kabul: tekerlek, tablodaki alt ve üst yüksekliğin dışına çıkmaz. Zemin delinmez. Test: iki uç, yükseklik eşit sınır.
  - Bağımlılık: SAH-41. Boyut: S.
  - Dosya: `data/ayarlar/sahne.json` `kamera_yukseklik`.
  - Asset: asset gerekmedi.
- [ ] **SAH-43:** Sınır, köyün dışına geçmez.
  - Ne: BUG-24 sınır kuralı durur. Yakınlaştırma sınırı genişletmez.
  - Kabul: BUG-24 sınır kuralı durur. Yakınlaştırma sınırı genişletmez. Test: köşe, kamera içeride.
  - Bağımlılık: BUG-24, SAH-42. Boyut: S.
  - Dosya: `src/dunya/kamera_surukleme.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-44:** Takip, sürüklemeyi bırakır.
  - Ne: ANI-14, orta tuş basılıyken hedefi koyverir. Bırakınca takip geri gelmez. Oyuncu yeniden seçer.
  - Kabul: ANI-14, orta tuş basılıyken hedefi koyverir. Bırakınca takip geri gelmez. Oyuncu yeniden seçer. Test: sürükle, takip kapalı.
  - Bağımlılık: ANI-14, BUG-24. Boyut: S.
  - Dosya: `src/dunya/kamera_surukleme.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-45:** Kamera modele girmez.
  - Ne: en yakın yükseklikte kamera küresi karakterin içinden geçmez.
  - Kabul: en yakın yükseklikte kamera küresi karakterin içinden geçmez. Test: seçili köylü, kamera mesafesi en az taban.
  - Bağımlılık: SAH-42. Boyut: S.
  - Dosya: `src/dunya/kamera_surukleme.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-46:** Kapı kamerası köy kamerası değildir.
  - Ne: kapı FOV sabiti BUG-13'tedir. Köy yakınlaştırması kapı FOV'unu değiştirmez.
  - Kabul: kapı FOV sabiti BUG-13'tedir. Köy yakınlaştırması kapı FOV'unu değiştirmez. Test: sahne geçişi, kapı FOV eski değer.
  - Bağımlılık: BUG-13, SAH-42. Boyut: S.
  - Dosya: kapı kamerası, tek okuma.
  - Asset: asset gerekmedi.
- [ ] **SAH-47:** Kamera sarsıntısı yalnız kapı olayındadır.
  - Ne: CAT yer tutucu sarsıntısı köy kamerasına yazılmaz.
  - Kabul: CAT yer tutucu sarsıntısı köy kamerasına yazılmaz. Test: köyde sarsıntı süresi 0.
  - Bağımlılık: CAT-02, SAH-41. Boyut: S.
  - Dosya: `src/dunya/kamera_surukleme.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-48:** Kamera ayarı kayda girmez.
  - Ne: yükseklik oyuncunun oturumundadır. KAY göçü onu taşımaz.
  - Kabul: yükseklik oyuncunun oturumundadır. KAY göçü onu taşımaz. Test: kayıtta kamera alanı yok.
  - Bağımlılık: KAY-03, SAH-42. Boyut: S.
  - Dosya: `src/dunya/kamera_surukleme.gd`.
  - Asset: asset gerekmedi.

### 44.7 Kapıda konuşan yüz

- [ ] **SAH-49:** Konuşan kişi kadrajdadır.
  - Ne: sorgu açılınca kamera o modele bakar. Bakış, BUG-13 FOV sınırının içinde kalır.
  - Kabul: sorgu açılınca kamera o modele bakar. Bakış, BUG-13 FOV sınırının içinde kalır. Test: üç boy model, yüz kadrajda.
  - Bağımlılık: BUG-13. Boyut: M.
  - Dosya: `src/kapi/kapi_kamera_vurgu.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-50:** Vurgu, heybe açıkken modeli örtmez.
  - Ne: heybe paneli BUG-15 ile tıklamayı yer. Kamera, paneli kapatacak kadar yaklaşmaz.
  - Kabul: heybe paneli BUG-15 ile tıklamayı yer. Kamera, paneli kapatacak kadar yaklaşmaz. Test: panel açık, model hâlâ görünür.
  - Bağımlılık: BUG-15, SAH-49. Boyut: S.
  - Dosya: `src/kapi/kapi_kamera_vurgu.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-51:** Sıradaki kişi vurgulanmaz.
  - Ne: kadraj kapıdaki kişidir. Sıradaki ikinci modele kesme yoktur.
  - Kabul: kadraj kapıdaki kişidir. Sıradaki ikinci modele kesme yoktur. Test: 4 kişilik sıra, kamera birincidedir.
  - Bağımlılık: SAH-49, SAH-35. Boyut: S.
  - Dosya: `src/kapi/kapi_kamera_vurgu.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-52:** Konuşma bitince vurgu gevşer.
  - Ne: karar panelinde kamera bir adım geri durur. Yüz hâlâ kadrajdadır.
  - Kabul: karar panelinde kamera bir adım geri durur. Yüz hâlâ kadrajdadır. Test: iki mesafe, karar mesafesi büyük.
  - Bağımlılık: SAH-49. Boyut: S.
  - Dosya: `src/kapi/kapi_kamera_vurgu.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-53:** Eş kapıdaysa ikinci kadraj açılmaz.
  - Ne: ACL öğreticisinde eş yanında durur. Kamera muhafızı ayrıca kadraja almaz. Tek bakış.
  - Kabul: ACL öğreticisinde eş yanında durur. Kamera muhafızı ayrıca kadraja almaz. Tek bakış. Test: eş varken kamera sayısı 1.
  - Bağımlılık: ACL-04, SAH-49. Boyut: S.
  - Dosya: `src/kapi/kapi_kamera_vurgu.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-54:** Vurgu titreşmez.
  - Ne: aynı kişi konuşurken kamera her satırda yeniden kesmez. Yeni cümle, aynı kadraj.
  - Kabul: aynı kişi konuşurken kamera her satırda yeniden kesmez. Yeni cümle, aynı kadraj. Test: 5 satır, kamera konumu sabit.
  - Bağımlılık: SAH-49. Boyut: S.
  - Dosya: `src/kapi/kapi_kamera_vurgu.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-55:** Kaçan kişi kadrajdan yürür.
  - Ne: ZAR-03 kaçışında kamera ışınlanmaz. Kişi eşiğe kadar görünür.
  - Kabul: ZAR-03 kaçışında kamera ışınlanmaz. Kişi eşiğe kadar görünür. Test: kaçış, kadrajda en az 1 saniye.
  - Bağımlılık: ZAR-03, SAH-49. Boyut: S.
  - Dosya: `src/kapi/kapi_kamera_vurgu.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-56:** Vurgu köy kamerasına yazılmaz.
  - Ne: sahne değişince kapı bakışı sıfırlanır. Köy, ANI-14 ile açılır.
  - Kabul: sahne değişince kapı bakışı sıfırlanır. Köy, ANI-14 ile açılır. Test: köyde kapı hedefi yok.
  - Bağımlılık: SAH-41, SAH-49. Boyut: S.
  - Dosya: `src/kapi/kapi_kamera_vurgu.gd`.
  - Asset: asset gerekmedi.

### 44.8 Köyün canlılığı

- [ ] **SAH-57:** Gündüz iş, gece ateş.
  - Ne: ANI-07 ve ANI-08 kendi saatindedir. Bu bölüm yeni rutin eklemez. Ölçüm: gündüz tezgâhta en az bir kişi, gece ateşte en az bir kişi, yatak varsa.
  - Kabul: ANI-07 ve ANI-08 kendi saatindedir. Bu bölüm yeni rutin eklemez. Ölçüm: gündüz tezgâhta en az bir kişi, gece ateşte en az bir kişi, yatak varsa. Test: iki saat.
  - Bağımlılık: ANI-07, ANI-08. Boyut: S.
  - Dosya: `tests/oto/karakter_muayene.gd` sayım satırı.
  - Asset: asset gerekmedi.
- [ ] **SAH-58:** Rutinler aynı karede aynı pozu tutmaz.
  - Ne: ANI-12 ofseti durur. Beş kişi ateşte aynı karede eğilmez.
  - Kabul: ANI-12 ofseti durur. Beş kişi ateşte aynı karede eğilmez. Test: beş ofset, en az iki farklı faz.
  - Bağımlılık: ANI-12, SAH-57. Boyut: S.
  - Dosya: mevcut bekleme.
  - Asset: asset gerekmedi.
- [ ] **SAH-59:** Yağmurda saçak altı ANI-09'dur.
  - Ne: yeni bir yağmur sahnesi yok. Ölçüm, yağmurda açık avluda duran işçi sayısının düştüğünü söyler.
  - Kabul: yeni bir yağmur sahnesi yok. Ölçüm, yağmurda açık avluda duran işçi sayısının düştüğünü söyler. Test: yağmur açık, saçak dolu.
  - Bağımlılık: ANI-09. Boyut: S.
  - Dosya: `tests/oto/karakter_muayene.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-60:** Değirmen ve duman LOD'dur.
  - Ne: ANI-06 ve ANI-15 durur. Uzak kamerada parçacık kapanır, yakın açılır. Yeni parçacık üretilmez.
  - Kabul: ANI-06 ve ANI-15 durur. Uzak kamerada parçacık kapanır, yakın açılır. Yeni parçacık üretilmez. Test: iki mesafe, iki durum.
  - Bağımlılık: ANI-15, SAH-42. Boyut: S.
  - Dosya: mevcut parçacık.
  - Asset: asset gerekmedi.
- [ ] **SAH-61:** Boş köy rutin başlatmaz.
  - Ne: köylü 0 ise ateş halkası ve tezgâh klibi aranmaz.
  - Kabul: köylü 0 ise ateş halkası ve tezgâh klibi aranmaz. Test: boş köy, iş klibi 0.
  - Bağımlılık: SAH-57. Boyut: S.
  - Dosya: `src/dunya/hareket_gecisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-62:** Nöbetçi ateşe oturmaz.
  - Ne: NBT nöbetindeki kişi ANI-07 halkasına girmez. Direğinde durur.
  - Kabul: NBT nöbetindeki kişi ANI-07 halkasına girmez. Direğinde durur. Test: nöbetçi, ateş merkezi uzaklığı payın üstü.
  - Bağımlılık: NBT-01, ANI-07. Boyut: S.
  - Dosya: `src/dunya/kalabalik_yol.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-63:** Gece yürüyüşü meşale soketini söndürmez.
  - Ne: ANI-01 meşalesi gece devriyesinde yanar. Gündüz işinde yanmaz.
  - Kabul: ANI-01 meşalesi gece devriyesinde yanar. Gündüz işinde yanmaz. Test: iki saat, ışık açık ve kapalı.
  - Bağımlılık: ANI-01, ANI-02. Boyut: S.
  - Dosya: mevcut donanım.
  - Asset: asset gerekmedi.
- [ ] **SAH-64:** Canlılık yeni bina kurmaz.
  - Ne: duman yalnız var olan tezgâhtan çıkar. Eksik bina, parçacık doğurmaz.
  - Kabul: duman yalnız var olan tezgâhtan çıkar. Eksik bina, parçacık doğurmaz. Test: tezgâhsız köy, duman 0.
  - Bağımlılık: ANI-15. Boyut: S.
  - Dosya: mevcut parçacık.
  - Asset: asset gerekmedi.

### 44.9 Işık ve gölge

- [ ] **SAH-65:** Kapı ışığı BUG-04 ölçüsündedir.
  - Ne: gölge haritası o maddenin boyutunu aşmaz. Bu bölüm yeni bir gölge sistemi açmaz.
  - Kabul: gölge haritası o maddenin boyutunu aşmaz. Bu bölüm yeni bir gölge sistemi açmaz. Test: gölge boyutu tavanın altında.
  - Bağımlılık: BUG-04. Boyut: S.
  - Dosya: kapı ışığı.
  - Asset: asset gerekmedi.
- [ ] **SAH-66:** Meşale, modeli çift aydınlatmaz.
  - Ne: aynı meşalenin iki ışığı yoktur. ANI-01 soketi tek ışıktır.
  - Kabul: aynı meşalenin iki ışığı yoktur. ANI-01 soketi tek ışıktır. Test: meşale başına ışık sayısı 1.
  - Bağımlılık: ANI-01, SAH-65. Boyut: S.
  - Dosya: `src/dunya/karakter_ekipman_yoneticisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-67:** Köy gecesi, kapı gecesinden ayrıdır.
  - Ne: köy ortam ışığı kapı meşalesini büyütmez. İki sahne iki ışık ayarı.
  - Kabul: köy ortam ışığı kapı meşalesini büyütmez. İki sahne iki ışık ayarı. Test: sahne geçişi, kapı ışık enerjisi eski değer.
  - Bağımlılık: SAH-65. Boyut: S.
  - Dosya: `data/ayarlar/sahne.json` iki blok.
  - Asset: asset gerekmedi.
- [ ] **SAH-68:** Düşük donanım gölgeyi kapatır.
  - Ne: BUG-10 profili durur. Düşükte dinamik gölge kapalı, ışık açık.
  - Kabul: BUG-10 profili durur. Düşükte dinamik gölge kapalı, ışık açık. Test: profil, gölge bayrağı.
  - Bağımlılık: BUG-10, SAH-65. Boyut: S.
  - Dosya: mevcut grafik ayarı.
  - Asset: asset gerekmedi.
- [ ] **SAH-69:** Ateş ışığı halkayı geçer.
  - Ne: ANI-07 ateşinin ışığı oturanların yüzüne değer. Işık yarıçapı tablodadır.
  - Kabul: ANI-07 ateşinin ışığı oturanların yüzüne değer. Işık yarıçapı tablodadır. Test: ateş başı, en az bir yüz aydınlık.
  - Bağımlılık: ANI-07, SAH-67. Boyut: S.
  - Dosya: `data/ayarlar/sahne.json`.
  - Asset: asset gerekmedi.
- [ ] **SAH-70:** Gündüz meşale yakılmaz.
  - Ne: SAH-63 ile aynı saat kuralı. Gündüz enerji 0.
  - Kabul: SAH-63 ile aynı saat kuralı. Gündüz enerji 0. Test: öğle, meşale enerjisi 0.
  - Bağımlılık: SAH-63. Boyut: S.
  - Dosya: `src/dunya/karakter_ekipman_yoneticisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-71:** Işık sayısı tavandadır.
  - Ne: sahnedeki dinamik ışık en çok tablodaki sayıdır. Aşan meşale ışıksız sokette kalır, model durur.
  - Kabul: sahnedeki dinamik ışık en çok tablodaki sayıdır. Aşan meşale ışıksız sokette kalır, model durur. Test: tavan artı bir, ışık sayısı tavan.
  - Bağımlılık: SAH-66. Boyut: M.
  - Dosya: `data/ayarlar/sahne.json` `isik_tavan`.
  - Asset: asset gerekmedi.
- [ ] **SAH-72:** Gölge, ayak testini bozmaz.
  - Ne: SAH-01 yüksekliği gölge açık ve kapalıyken aynıdır.
  - Kabul: SAH-01 yüksekliği gölge açık ve kapalıyken aynıdır. Test: iki profil, aynı taban.
  - Bağımlılık: SAH-01, SAH-68. Boyut: S.
  - Dosya: `tests/oto/karakter_muayene.gd`.
  - Asset: asset gerekmedi.

### 44.10 Muayene ve eksik klipler

- [ ] **SAH-73:** Muayene aracı TST-08'in yerine geçmez.
  - Ne: `tests/oto/karakter_muayene.tscn` durur. TST-08 adımları bu dosyada yazılmaz. Araç, bu bölümün ölçümlerini satır olarak ekler.
  - Kabul: `tests/oto/karakter_muayene.tscn` durur. TST-08 adımları bu dosyada yazılmaz. Araç, bu bölümün ölçümlerini satır olarak ekler. Test: araç açılır, TST metni bu bölümde 0.
  - Bağımlılık: SAH-08. Boyut: S.
  - Dosya: `tests/oto/karakter_muayene.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-74:** Eksik klip listesi ARY-05'e yazılır.
  - Ne: BUG-09'un düştüğü her klip adı envanterde bir satırdır. Satırda sahne, model ve istenen klip vardır. Dosya üretilmez.
  - Kabul: BUG-09'un düştüğü her klip adı envanterde bir satırdır. Satırda sahne, model ve istenen klip vardır. Dosya üretilmez. Test: bilerek silinen klip, envanterde 1 satır.
  - Bağımlılık: BUG-09, ARY-05. Boyut: S.
  - Dosya: `docs/EKSIK_ASSET_ENVANTERI.md`.
  - Asset: `SAH-KLIP-*`. Yer tutucu idle.
- [ ] **SAH-75:** Listede olan klip oyunda aranmaz.
  - Ne: envanter satırı `bekliyor` ise oynatıcı idle kullanır, hata fırlatmaz.
  - Kabul: envanter satırı `bekliyor` ise oynatıcı idle kullanır, hata fırlatmaz. Test: bekleyen klip, idle.
  - Bağımlılık: SAH-74, BUG-12. Boyut: S.
  - Dosya: `src/dunya/guvenli_karakter_animasyonu.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-76:** Muayene 30 karakteri tek koşuda görür.
  - Ne: CHR_001…030 modelleri araçtan geçer. Çökme yok. Rapor 30 satırdır. Eksik model yedek modele düşer, satırda yedek yazar.
  - Kabul: CHR_001…030 modelleri araçtan geçer. Çökme yok. Rapor 30 satırdır. Eksik model yedek modele düşer, satırda yedek yazar. Test: 30 satır.
  - Bağımlılık: SAH-73. Boyut: M.
  - Dosya: `tests/oto/karakter_muayene.tscn`.
  - Asset: asset gerekmedi.
- [ ] **SAH-77:** Rapor ayak, eşya ve klip diye üçe ayrılır.
  - Ne: SAH-08, SAH-16 ve SAH-74 aynı raporda üç başlıktır. Başlık karışmaz.
  - Kabul: SAH-08, SAH-16 ve SAH-74 aynı raporda üç başlıktır. Başlık karışmaz. Test: üç başlık.
  - Bağımlılık: SAH-08, SAH-16, SAH-74. Boyut: S.
  - Dosya: `tests/oto/karakter_muayene.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-78:** Rapor oyunu durdurmaz.
  - Ne: hata satırı headless koşuda çıkar, oyuncu sürümünde panel açılmaz.
  - Kabul: hata satırı headless koşuda çıkar, oyuncu sürümünde panel açılmaz. Test: sürüm bayrağı, panel 0.
  - Bağımlılık: SAH-73. Boyut: S.
  - Dosya: `tests/oto/karakter_muayene.gd`.
  - Asset: asset gerekmedi.
- [ ] **SAH-79:** Sanity muayeneyi çağırır.
  - Ne: `sanity_check.py` aracı tek satırla koşar. Yeni sanity paketi yok.
  - Kabul: `sanity_check.py` aracı tek satırla koşar. Yeni sanity paketi yok. Test: listede muayene adı.
  - Bağımlılık: SYS-11, SAH-76. Boyut: S.
  - Dosya: `tools/sanity_check.py`.
  - Asset: asset gerekmedi.
- [ ] **SAH-80:** Cila, diyaloğun metnini değiştirmez.
  - Ne: kamera ve klip, söz dosyasına yazmaz. Replik seçimi aynı kalır.
  - Kabul: kamera ve klip, söz dosyasına yazmaz. Replik seçimi aynı kalır. Test: altın oynanış (DYL-16) cila açıkken de aynı satırları verir.
  - Bağımlılık: DYL-16, SAH-49. Boyut: S.
  - Dosya: `tests/unit/soz/altin_oynanis_test.gd`.
  - Asset: asset gerekmedi.


---

## BÖLÜM 45: Kontroller ve girdi


43'ten sonra, 46'dan önce. Zemin:

- `project.godot` içinde `[input]` bloğu yoktur. Eylemler `src/arayuz/ana.gd:237 _eylemleri_kur()` ile çalışma anında eklenir.
- Eylemler: `geri` = Esc ve gamepad B (`JOY_BUTTON_B`); `menu` = P ve Start (`JOY_BUTTON_START`); `kisayol_1`…`kisayol_5` = 1…5. Yorum: gezinme ve onay Godot'un `ui_*` eylemleridir.
- Köy ham tuş okur (`koy_ekrani.gd:312 _unhandled_input`): R yön çevirir, B barınma kategorisi, P nüfus, 1/2/3 hız (`_hiz_sec`), Space dur/sürdür, Esc kip temizler. Fare (`_dunya_girdisi`, satır 232): tekerlek yakınlaşır, sol seçer, sağ kipi kapatır.
- Orta tuş kamera BUG-24'tedir. Bu bölüm onu yeniden yazmaz.
- Tuş atama ekranı yoktur. Ayarlar `SATIRLAR` listesinde girdi satırı yoktur.

Kimlikler GIR-01 … GIR-26. Asset üretilmez. Bitince `[x]` ve ajan adı.

**Madde biçimi:** Ne, Kabul, Bağımlılık + Boyut, Dosya, Asset.

---

### 45.1 Eylem haritası

- [ ] **GIR-01:** Ayarlarda kontroller sekmesi.
  - Ne: `ayarlar_ekrani.gd` sekmelerinden biri kontrollerdir (GRV-25). Sekme eylemleri listeler, yeniden atamayı açar, varsayılana döner. Oynanış ayarı buraya gömülmez.
  - Kabul: sekme açıkken en az `geri`, `menu`, hız ve köy eylemleri satırdadır. Test: ekran.
  - Bağımlılık: GRV-25. Boyut: M.
  - Dosya: yeni: `src/arayuz/kontroller_sekmesi.gd`; `ayarlar_ekrani.gd` tek satır.
  - Asset: asset gerekmedi.
- [ ] **GIR-02:** Köy ham tuşu bırakır.
  - Ne: `KEY_R`, `KEY_B`, `KEY_P`, `KEY_1`, `KEY_2`, `KEY_3`, `KEY_SPACE`, `KEY_ESCAPE` karşılaştırması kalkar. Yerine `is_action_pressed`: `bina_cevir`, `bina_barinma`, `nufus`, `hiz_1`, `hiz_2`, `hiz_3`, `hiz_dur`, `kip_kapat`.
  - Kabul: `_unhandled_input` içinde `physical_keycode` 0. Test: tarama + hız 2 hâlâ 2.
  - Bağımlılık: GIR-01. Boyut: M.
  - Dosya: `koy_ekrani.gd`; eylemler `ana.gd _eylemleri_kur` ya da yeni `src/arayuz/girdi_eylemleri.gd`.
  - Asset: asset gerekmedi.
- [ ] **GIR-03:** Eylem adı ekranda çeviri anahtarıdır.
  - Ne: atama satırı `arayuz.girdi.<eylem>` ile yazılır, tuşun görünen adı `InputEvent.as_text()` değil, OS tuş adının kısa hali (Esc, Space, 1, P). Oyuncu "kisayol_1" görmez.
  - Kabul: sekmede ham eylem kimliği 0. Test: ekran + CSV.
  - Bağımlılık: GIR-01, YER-02. Boyut: S.
  - Dosya: `kontroller_sekmesi.gd`; `metinler.csv`.
  - Asset: asset gerekmedi.
- [ ] **GIR-04:** `[input]` proje dosyasına gömülmez.
  - Ne: bugünkü yol durur: eylemler kodda kurulur, atamalar `user://ayarlar.cfg` ek bölümünde saklanır. `project.godot` `[input]` bloğu açılmaz; iki kaynak olmasın.
  - Kabul: `project.godot` içinde `[input]` 0. Test: dosya.
  - Bağımlılık: GIR-02. Boyut: S.
  - Dosya: `girdi_eylemleri.gd`; `ayarlar.gd` ek bölüm (çekirdek anahtar listesi büyümez, bölüm adı `girdi`).
  - Asset: asset gerekmedi.

### 45.2 Çakışma

- [ ] **GIR-05:** P iki iş taşımaz.
  - Ne: `menu` eylemi P, köy `nufus` da P. Aynı fiziksel tuş iki eyleme atanamaz. Varsayılan: `menu` Esc yanına değil, ayrı bir tuşa (öneri F10) çekilir ya da yalnız duraklat açıkken dinlenir. Köyde P nüfus olarak kalır.
  - Kabul: köy ekranında P bir iş yapar (nüfus), duraklat açmaz. Test: köyde P.
  - Bağımlılık: GIR-02. Boyut: S.
  - Dosya: `girdi_eylemleri.gd`.
  - Asset: asset gerekmedi.
- [ ] **GIR-06:** Odak gezinmesi `ui_*` ile kalır, her ekranda komşu vardır.
  - Ne: `ui_up`, `ui_down`, `ui_left`, `ui_right`, `ui_accept`, `ui_cancel` Godot varsayılanıdır, yeniden tanımlanmaz. Menüdeki `_odak_komsulari` kalıbı ayarlar, defter ve duraklat düğmelerine de uygulanır. Fare olmadan sekme gezilir.
  - Kabul: ayarlar sekmesinde odak halkası düğme sayısına eşittir, kopuk düğme 0. Test: klavye. Ek şart: Kapıdaki sorgu eylemleri ok tuşuyla seçilir; bu iş yeni oyun kolu şartı açmaz.
  - Bağımlılık: GIR-01. Boyut: M.
  - Dosya: `ayarlar_ekrani.gd`, `hafiza_defteri_ekrani.gd`, `ana.gd` duraklat.
  - Asset: asset gerekmedi.
- [ ] **GIR-07:** 1–3 hız ile kapı kısayolu aynı anda dinlemez.
  - Ne: `kisayol_1…3` kapı sorgu ekranında, `hiz_1…3` köy ekranında. İkisi birden aynı karede işlenmez. Aynı tuşa atamak serbesttir çünkü ekranlar ayrıdır; atama ekranı bunu çakışma saymaz.
  - Kabul: köyde 1 hız seçer, kapı kısayolunu çalıştırmaz. Test: iki ekran.
  - Bağımlılık: GIR-02. Boyut: S.
  - Dosya: `girdi_eylemleri.gd`.
  - Asset: asset gerekmedi.
- [ ] **GIR-08:** Esc sırası tektir.
  - Ne: açık üst panel (heybe, kart, defter, kip) varsa Esc onu kapatır; yoksa `geri` duraklatır. `kip_kapat` ve `geri` aynı tuşta olabilir, tüketim sırası: üst panel, kip, duraklat.
  - Kabul: heybe açıkken Esc duraklat açmaz. Test: üç durum. Ek şart: Nöbet atama kartı açıkken Esc seçimi yuvaya yazmaz. Ek şart: Çınar meclisi oy düğmesi duraklat menüsü açıkken sadakat ve moral farkı yazmaz. Ek şart: Esc tezgâh teslimini onaylamaz; ücret ve parça o tuşla yazılmaz. Ek şart: Esc yıl cümlesini kapatır, moral ve erzak yazmaz.
  - Bağımlılık: GIR-02. Boyut: S.
  - Dosya: `koy_ekrani.gd`, `kapi_ekrani.gd`.
  - Asset: asset gerekmedi.

### 45.3 Atama

- [ ] **GIR-09:** Bir eylem bir tuş bekler.
  - Ne: satıra basılınca sonraki tuş veya gamepad düğmesi o eyleme yazılır. Fare düğmesi kamera eylemine yazılır (tekerlek, sol, sağ); karar düğmesine yazılmaz.
  - Kabul: `hiz_1` R'ye alınınca 1 hız seçmez, R seçer. Test: atama.
  - Bağımlılık: GIR-01. Boyut: M.
  - Dosya: `kontroller_sekmesi.gd`.
  - Asset: asset gerekmedi.
- [ ] **GIR-10:** Çakışan atama uyarı verir, sessizce silmez.
  - Ne: aynı ekranda dinlenen iki eylem aynı tuşa gelirse satır "çakışıyor" der (`arayuz.girdi.cakisma`). Kayıt yazılır ama ikinci eylem o tuşu dinlemez.
  - Kabul: çakışmada işleyen eylem 1. Test: birim.
  - Bağımlılık: GIR-09. Boyut: S.
  - Dosya: `girdi_eylemleri.gd`.
  - Asset: asset gerekmedi.
- [ ] **GIR-11:** Varsayılan `ayarlar.varsayilana_don` girdiye de döner.
  - Ne: mevcut düğme (`ayarlar_ekrani.gd:68`) girdi bölümünü de sıfırlar. Ayrı "tuşları sıfırla" şart değildir; varsa aynı fonksiyonu çağırır.
  - Kabul: sıfırlama sonrası P nüfus, 1 hız. Test: atama + sıfır.
  - Bağımlılık: GIR-09. Boyut: S.
  - Dosya: `ayarlar.gd` `varsayilana_don`.
  - Asset: asset gerekmedi.

### 45.4 Gamepad

- [ ] **GIR-12:** Gamepad bugün iki eylemdir, liste bunu söyler.
  - Ne: varsayılan gamepad: `geri` B, `menu` Start. Hız, nüfus, çevir, kabul/ret için varsayılan düğme `data/girdi.json` içindedir (öneri: omuz hız, A kabul, X ret — sayılar dosyada). Kod içi düğme indeksi 0.
  - Kabul: json silinince oyun klavye varsayılanıyla açılır, çökmez. Test: dosyasız açılış.
  - Bağımlılık: GIR-04. Boyut: M.
  - Dosya: yeni: `data/girdi.json`.
  - Asset: asset gerekmedi.
- [ ] **GIR-13:** Sol çubuk köy imlecini kaydırır, yeni kamera yazmaz.
  - Ne: çubuk, fare hareketinin yerine `sahne3b.isaret` noktasına ofset ekler. Yakınlaşma tekerlek eylemi `yakinlas` ile kalır (BUG-24 orta tuş ayrı).
  - Kabul: çubuk sapması seçim hücresini değiştirir, `yakinlas` çağrı sayısı sapma ile artmaz. Test: girdi.
  - Bağımlılık: GIR-12. Boyut: M.
  - Dosya: `koy_ekrani.gd` tek dal.
  - Asset: asset gerekmedi.
- [ ] **GIR-14:** Gamepad yokken klavye tamdır.
  - Ne: düğme okunamazsa klavye yolu durur. Oyun gamepad aramaz, hata basmaz.
  - Kabul: gamepads boşken SCRIPT ERROR 0. Test: açılış.
  - Bağımlılık: GIR-12. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

### 45.5 Kapı kararları

- [ ] **GIR-15:** Kabul ve ret eylemdir.
  - Ne: kapı karar düğmeleri tıklanınca olduğu gibi kalır; ek olarak `kapi_kabul` ve `kapi_ret` eylemleri aynı fonksiyonu çağırır. Yeni karar türü yok (`KARAR_SIMGE` kümesi durur).
  - Kabul: klavye ile kabul, fare ile kabul aynı `sonuc` yolunu bir kez çağırır. Test: iki girdi.
  - Bağımlılık: GIR-02. Boyut: S.
  - Dosya: `kapi_ekrani.gd` tek bağ.
  - Asset: asset gerekmedi.
- [ ] **GIR-16:** `ui_accept` ile `kapi_kabul` çakışması GIR-10'dur.
  - Ne: Godot varsayılan Enter hem `ui_accept` hem kabul olmasın diye kabul eylemi Enter'dan başka varsayılan taşır (öneri Y). Enter odaklanan düğmeyi basar.
  - Kabul: odaklı ret düğmesinde Enter ret basar, kabul basmaz. Test: odak.
  - Bağımlılık: GIR-06, GIR-15. Boyut: S.
  - Dosya: `data/girdi.json`.
  - Asset: asset gerekmedi.

### 45.6 Fare

- [ ] **GIR-17:** Sol, sağ, tekerlek eylem kimliği alır, davranış değişmez.
  - Ne: `MOUSE_BUTTON_LEFT/RIGHT/WHEEL_*` karşılaştırması eylem olur: `sec`, `iptal_kip`, `yakinlas`, `uzaklas`. İşlev satır 236–248'dekiyle aynıdır.
  - Kabul: sol köylü kartını açar, tekerlek `yakinlas` işaretini korur. Test: köy.
  - Bağımlılık: GIR-02. Boyut: S.
  - Dosya: `koy_ekrani.gd`.
  - Asset: asset gerekmedi.
- [x] **GIR-18:** (Claude) Orta tuş BUG-24'te kalır.
  - Ne: kamera orta tuşu bu dosyada yeniden tanımlanmaz.
  - Kabul: bu bölümde orta tuş maddesi 1'dir ve o da budur (iş yok). Test: sayım.
  - Bağımlılık: BUG-24. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

### 45.7 Kayıt

- [ ] **GIR-19:** Atama ayar dosyasındadır, oyun kaydında değildir.
  - Ne: tuşlar `ayarlar.cfg` `girdi` bölümünde. `kayit.json` silinince atama durur. Eski ayar dosyasında bölüm yoksa varsayılan kurulur.
  - Kabul: kayıtsız açılışta atama hatırlanır; ayar dosyası yokken varsayılan. Test: iki dosya.
  - Bağımlılık: GIR-04. Boyut: S.
  - Dosya: `ayarlar.gd`.
  - Asset: asset gerekmedi.
- [ ] **GIR-20:** Bozuk atama satırı düşer.
  - Ne: bilinmeyen eylem veya boş olay `_gecerli` gibi yutulur, o eylem varsayılana döner, oyun açılır (`ayarlar.gd:48` kalıbı).
  - Kabul: `hiz_1=` boş satırında hız tuşu 1'dir, çökme 0. Test: birim.
  - Bağımlılık: GIR-19. Boyut: S.
  - Dosya: `girdi_eylemleri.gd`.
  - Asset: asset gerekmedi.

### 45.8 Metin ve öğretici

- [ ] **GIR-21:** İpucu tuş adı eylemden gelir.
  - Ne: OGR ipuçları "1'e bas" diye gömülü yazmaz. `arayuz.girdi.hiz_1` görünen adı yer tutucuya girer. Oyuncu tuşu değiştirince ipucu yeni adı söyler.
  - Kabul: `hiz_1` R iken ipucu metninde R geçer, "1" geçmez. Test: atama + ipucu.
  - Bağımlılık: GIR-03, OGR-09. Boyut: S.
  - Dosya: `ipucu_seridi.gd`.
  - Asset: asset gerekmedi.
- [ ] **GIR-22:** Kontroller sekmesi USLUP dışıdır.
  - Ne: tuş adları tekniktir; YAZ-10 diyalog taramasına girmez.
  - Kabul: `arayuz.girdi.*` yapaylık listesinde 0. Test: KLT kapısı.
  - Bağımlılık: KLT-04. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

### 45.9 Sürüm

- [ ] **GIR-23:** Oyuncu sürümünde atama ekranı durur.
  - Ne: SRM-05 debug'ı kapatır, kontroller sekmesini kapatmaz.
  - Kabul: bayraksız export'ta sekme 1. Test: SRM-05 açılışı.
  - Bağımlılık: SRM-05. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [x] **GIR-24:** (Claude) Gamepad glyph çizilmez.
  - Ne: düğme ikonu üretilmez. Metin "A", "B", "Start" yeter. İhtiyaç doğarsa ARY-05, bu madde dosya koymaz.
  - Kabul: yeni png 0. Test: sayım.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

### 45.10 Sınırlar ve kapanış

- [ ] **GIR-25:** Hız formülü değişmez.
  - Ne: `_hiz_sec` 0…3, kilitliyken 1, `time_scale` kuralı TEK-22/23'tedir. Bu bölüm yalnız tuşu değiştirir.
  - Kabul: `_hiz_sec` gövdesi diff'i yorum ve eylem bağı dışında 0. Test: hız birimi.
  - Bağımlılık: TEK-23. Boyut: S.
  - Dosya: `koy_ekrani.gd`.
  - Asset: asset gerekmedi.
- [ ] **GIR-26:** Kapanış testi.
  - Ne: varsayılanda köy 1/2/3 hız, P nüfus, Space durur; P duraklat açmaz; heybe açıkken Esc duraklat açmaz; atama kaydı oyun kaydından bağımsız; `[input]` yok.
  - Kabul: beş iddia. Test: `tests/unit/arayuz/girdi_test.gd`.
  - Bağımlılık: GIR-01…25. Boyut: M.
  - Dosya: yeni test.
  - Asset: asset gerekmedi.

Alt başlıklarda madde sayısı iki ile dört arasındadır. Onuncu madde, her HUD paneline ayrı kısayol uyduracağı için konmadı. Toplam 26 madde.


---

## BÖLÜM 46: Yerelleştirme altyapısı


En son. Çeviri metni bu bölümün işi değildir; ikinci sütun boş kalabilir. Zemin:

- `project.godot:30–33` — `locale/translations` yalnız `res://data/metin/metinler.tr.translation`, `locale/fallback = "tr"`.
- `src/arayuz/ana.gd:23` `TranslationServer.set_locale("tr")` sabit.
- `data/metin/metinler.csv` başlık `keys,tr`. Tek dil sütunu. Standart `docs/METIN_ANAHTAR_STANDARDI.md`: noktalı küçük harf, `%s`/`%d` sayısı kodla aynı, boş Türkçe yok.
- Doğrulama `tools/metin_dogrula.py`. Çalışma anı `src/sistemler/guvenli_metin.gd` (`GuvenliMetin.kur`, eksikte `[KEY_NOT_FOUND]`, kilit yok).
- `TranslationServer.translate` doğrudan çağrıları: `karar_replik_adaptoru.gd`, `iflas_yoneticisi.gd`, `koylu_karti_verisi.gd`, `levent_firari.gd`, `sancak_teftisi.gd`, `koylu_takibi.gd`, `coban_surusu.gd`.
- Düz metin örnekleri: `varlik_yukleme_paneli.gd` `"Hazırlanıyor…"` (TEK-21 anahtara alır); `ana.gd:223` hata metni kasten kodda ("tablo bozuk olabilir").
- Font Alegreya `assets/font/`, `tema.gd`.

Kimlikler YER-01 … YER-23. Asset üretilmez. Bitince `[x]` ve ajan adı.

**Madde biçimi:** Ne, Kabul, Bağımlılık + Boyut, Dosya, Asset.

---

### 46.1 Dil seçimi

- [ ] **YER-01:** Ayarlarda dil sekmesi.
  - Ne: GRV-25 sekmelerinden biri dildir. Liste bugün tek satır: Türkçe (`tr`). İkinci dil dosyası yoksa başka satır çizilmez. Seçim `ayarlar.cfg` anahtarı `dil` (ek dosya `ayarlar_ek.gd` kalıbı, Bölüm 35). Varsayılan `tr`.
  - Kabul: dosya yokken liste uzunluğu 1. Test: ekran.
  - Bağımlılık: GRV-25. Boyut: S.
  - Dosya: yeni: `src/arayuz/dil_sekmesi.gd`.
  - Asset: asset gerekmedi.
- [x] **YER-02:** (Claude) Anahtar ve yer tutucu kuralı standarttadır.
  - Ne: `docs/METIN_ANAHTAR_STANDARDI.md` tek kural belgesidir. Yeni anahtar `alan.alt.ad` biçimindedir. `%s` / `%d` sayısı `tr()` argümanıyla aynıdır. Bu bölüm ikinci standart açmaz. TEK-21 ve GIR-03 bu kurala uyar.
  - Kabul: biçimsiz anahtar `metin_dogrula.py` ile 1 hata. Test: mevcut araç.
  - Bağımlılık: SYS-09. Boyut: S.
  - Dosya: `docs/METIN_ANAHTAR_STANDARDI.md`; `tools/metin_dogrula.py`.
  - Asset: asset gerekmedi.
- [ ] **YER-03:** `set_locale` sabiti kalkar.
  - Ne: `ana.gd:23` `"tr"` yazmaz. `ayarlar` içindeki `dil` okunur; geçersizse fallback `tr`.
  - Kabul: ayar `tr` iken locale `tr`; çöp değerde locale `tr` ve uyarı 1. Test: birim.
  - Bağımlılık: YER-01. Boyut: S.
  - Dosya: `ana.gd` tek satır.
  - Asset: asset gerekmedi.

### 46.2 İkinci sütun — altyapı, çeviri değil

- [x] **YER-04:** (Claude) CSV ikinci dil sütununu kabul eder, doldurmayı beklemez.
  - Ne: başlık `keys,tr` durur. İsteğe bağlı üçüncü sütun `en` eklenebilir; hücre boşsa o satır `tr`'ye düşer. Boş `tr` hâlâ hatadır (standart §2). Bu madde İngilizce cümle yazmaz.
  - Kabul: `en` boş bir satırda oyun Türkçe metni gösterir; `tr` boşsa doğrulayıcı hata. Test: iki satır.
  - Bağımlılık: YER-02. Boyut: M.
  - Dosya: `tools/metin_dogrula.py` sütun kuralı; `data/metin/metinler.csv` başlık (sütun eklenirse).
  - Asset: asset gerekmedi.
- [ ] **YER-05:** Godot çeviri dosyası sütundan üretilir.
  - Ne: bugün `metinler.tr.translation` tek dosyadır. İkinci sütun dolu değilse ikinci `.translation` üretilmez. Üretim kuralı `docs/METIN_ANAHTAR_STANDARDI.md` içine bir paragraf olarak yazılır; elle kopya çeviri dosyası yasaktır.
  - Kabul: `en` sütunu yokken `locale/translations` uzunluğu 1. Test: proje dosyası.
  - Bağımlılık: YER-04. Boyut: S.
  - Dosya: `project.godot`; standart belgesi.
  - Asset: asset gerekmedi.
- [ ] **YER-06:** Fallback `tr` kalır.
  - Ne: `locale/fallback` `tr`. İkinci dil eksik anahtarda Türkçe görünür, `[KEY_NOT_FOUND]` ancak Türkçe de yoksa çıkar (`GuvenliMetin`).
  - Kabul: fallback satırı `tr`. Test: dosya.
  - Bağımlılık: YER-05. Boyut: S.
  - Dosya: `project.godot`.
  - Asset: asset gerekmedi.

### 46.3 Doğrudan çeviri çağrıları

- [ ] **YER-07:** Yedi dosya `tr()` ile hizalanır.
  - Ne: `TranslationServer.translate` çağrıları şunlardadır: `karar_replik_adaptoru.gd`, `iflas_yoneticisi.gd`, `koylu_karti_verisi.gd`, `levent_firari.gd`, `sancak_teftisi.gd`, `koylu_takibi.gd`, `coban_surusu.gd`. Yeni çağrı eklenmez. Mevcut çağrı locale değişince aynı anahtarı yeni dilde okur; gövdeye Türkçe sabit gömülüyse sabit CSV'ye taşınır.
  - Kabul: bu yedi dosyada tırnak içi uzun Türkçe cümle 0 (anahtar hariç). Test: tarama.
  - Bağımlılık: YER-03. Boyut: M.
  - Dosya: adı geçen yedi script; `metinler.csv`.
  - Asset: asset gerekmedi.
- [ ] **YER-08:** `GuvenliMetin` locale değişince yeniden kurulur.
  - Ne: `dil` değişince `GuvenliMetin.kur()` bir kez daha çalışır. Eksik listesi yeni locale'e göredir.
  - Kabul: dil değiştirince `eksikler` yeniden sayılır. Test: birim.
  - Bağımlılık: YER-03. Boyut: S.
  - Dosya: `guvenli_metin.gd`; ayar `degisti` bağı.
  - Asset: asset gerekmedi.

### 46.4 Düz metin istisnaları

- [x] **YER-09:** (Claude) Katalog hata metni kodda kalır.
  - Ne: `ana.gd:222–226` "Oyun içeriği yüklenemedi" kasten çeviri dışıdır (tablo bozuk olabilir). İstisna listesi standart belgesine bir satır olarak yazılır. Başka düz metin bu istisnaya eklenmez.
  - Kabul: istisna listesinde 1 satır. Test: belge.
  - Bağımlılık: YER-02. Boyut: S.
  - Dosya: `docs/METIN_ANAHTAR_STANDARDI.md`.
  - Asset: asset gerekmedi.
- [ ] **YER-10:** "Hazırlanıyor…" istisna değildir.
  - Ne: TEK-21 anahtara alır. Yükleme paneli YER-09 listesine girmez.
  - Kabul: panelde düz Türkçe 0. Test: TEK-21.
  - Bağımlılık: TEK-21. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **YER-11:** Debug metinleri çevrilmez.
  - Ne: `src/debug/` ve `performans_seridi.gd` tooltip'i oyuncu diline girmez. SRM-05 zaten oyuncuda kapalıdır.
  - Kabul: debug klasörü `metin_dogrula --kaynak` anahtar zorunluluğunun dışındadır (belgede). Test: araç.
  - Bağımlılık: SRM-05. Boyut: S.
  - Dosya: standart belgesi.
  - Asset: asset gerekmedi.

### 46.5 Font

- [x] **YER-12:** (Claude) Alegreya Türkçe glifleri taşır.
  - Ne: `ı İ ş ğ ü ö ç` gövde puntosunda `.` kutusuna düşmez. Ölçüm `tema.gd` fontu ile bir test dizesidir. Yeni font indirilmez.
  - Kabul: yedi karakterde `get_char_size` 0 değil. Test: birim.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `tests/unit/arayuz/font_glif_test.gd`.
  - Asset: asset gerekmedi.
- [ ] **YER-13:** İkinci dil fontu bu sürümde yoktur.
  - Ne: `en` sütunu ileride dolarsa da Alegreya Latin yeter sayılır. Arap harfi, Kiril veya CJK için font maddesi açılmaz.
  - Kabul: `assets/font/` dosya sayısı değişmez. Test: sayım.
  - Bağımlılık: YER-12. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

### 46.6 Çoğul ve biçim

- [x] **YER-14:** (Claude) Çoğul eki ayrı anahtardır, motor değildir.
  - Ne: Türkçe ek uyumu için `tr()` içinde ek üretilmez. Gerekirse `...tek` / `...cok` iki anahtar. Yeni i18n kütüphanesi yok.
  - Kabul: `src/` içinde çoğul fonksiyonu 0. Test: tarama.
  - Bağımlılık: YER-02. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [x] **YER-15:** (Claude) Sayı biçimi Türkçe kalır.
  - Ne: binlik ayırıcı ve ondalık için ikinci bir biçimleyici yok. Akçe ve kaynak etiketleri bugünkü `tr` kalıbındadır.
  - Kabul: `Locale` sayı formatı değiştiren satır 0. Test: tarama.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

### 46.7 İçerik sınırı

- [ ] **YER-16:** Diyalog çevirisi yazılmaz.
  - Ne: `data/soz/` ve `sohbet.*` anahtarlarının İngilizcesi bu bölümde üretilmez. KLT kapısı Türkçe metne bakmaya devam eder.
  - Kabul: bu bölümün diff'i `data/soz/` içine girmez. Test: tarama.
  - Bağımlılık: KLT-01. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **YER-17:** Kişi adları çevrilmez.
  - Ne: `karakter.*` adları özel isimdir. İkinci sütun olsa da ad hücresi `tr` ile aynı kalır; doğrulayıcı uyarı vermez.
  - Kabul: ad satırında `en` ≠ `tr` ise 1 uyarı (sütun varsa). Test: fixtures.
  - Bağımlılık: YER-04. Boyut: S.
  - Dosya: `metin_dogrula.py`.
  - Asset: asset gerekmedi.

### 46.8 Değişim anı

- [ ] **YER-18:** Dil değişimi açık ekranı yeniler.
  - Ne: `Ayarlar.degisti` (`dil`) menü ve ayarlar etiketlerini yeniden `tr()` ile kurar. Oyun ortasında köy metni bir sonraki ekran açılışında değişir; yarıda kalan konuşma satırı o an yenilenmez (cümle bölünmesin).
  - Kabul: menüde anında yeni etiket; açık sorgu satırı aynı kalır. Test: iki ekran.
  - Bağımlılık: YER-03. Boyut: S.
  - Dosya: `menu_ekrani.gd`, `ayarlar_ekrani.gd`.
  - Asset: asset gerekmedi.
- [ ] **YER-19:** Kayıt dili gömmez.
  - Ne: `kayit.json` içinde locale yok. Dil ayardadır (GIR-19 ile aynı ayrım). Eski kayıt açılır.
  - Kabul: kayıtta `dil` anahtarı 0. Test: KAY.
  - Bağımlılık: YER-01. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

### 46.9 Tester

- [x] **YER-20:** (Claude) TST-0002 bu kapıda da görünür.
  - Ne: eksik anahtar KLT-10 ile kapanır. Yerelleştirme aracı aynı `metin_dogrula.py` çıktısını okur, ikinci tarayıcı yazmaz.
  - Kabul: yeni `metin_tarayici` dosyası 0. Test: sayım.
  - Bağımlılık: KLT-10. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **YER-21:** Çift boşluk dil sütununda da aranır.
  - Ne: TST-0006 / KLT-11 kuralı `tr` sütununa bakar. `en` doluysa aynı kural ona da uygulanır; boş `en` atlanır.
  - Kabul: `en` içinde çift boşluk 1 hata, boş hücre 0 hata. Test: fixtures.
  - Bağımlılık: KLT-11, YER-04. Boyut: S.
  - Dosya: `metin_dogrula.py`.
  - Asset: asset gerekmedi.

### 46.10 Sınırlar ve kapanış

- [x] **YER-22:** (Claude) Çalışma anında çeviri hizmeti yoktur.
  - Ne: HTTP çeviri, model çağrısı, otomatik satır üretimi yok (KLT-23 ile aynı sınır).
  - Kabul: `src/arayuz/dil_sekmesi.gd` içinde ağ çağrısı 0. Test: tarama.
  - Bağımlılık: KLT-23. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **YER-23:** Kapanış testi.
  - Ne: locale ayarı `tr`; çöp dilde fallback; CSV'de boş `tr` hata; boş `en` Türkçe gösterir; yedi dosyada yeni `translate` çağrısı yok; font yedi glif; katalog hata metni istisna listesinde tek.
  - Kabul: yedi iddia. Test: `tests/tools/test_yerel_dil.py` + font birimi.
  - Bağımlılık: YER-01…22. Boyut: M.
  - Dosya: yeni test.
  - Asset: asset gerekmedi.

Alt başlıklarda madde sayısı iki ile üç arasındadır. Onuncu madde, İngilizce diyalog veya ikinci font uyduracağı için konmadı. Toplam 23 madde. Çeviri kapsam dışıdır.


---

## EK A: Araştırma özeti ve ROADMAP 1 zemini (Parça B önsözü)

<!-- BOLUM_HAZIR -->

Parça B: söz motoru, zar, kapı kavgası, diyalog eylemleri, köprüler. Bu dosya bölündükten sonra A döngüsü tarafından değiştirilmez.

**Madde biçimi:** `- [ ] **ÖNEK-NN:** Başlık — amaç.` Altında: **Amaç**, **Kurallar**, **Uç durumlar**, **Kabul** (ölçülebilir test), **Bağımlılık**, **Boyut**, **Dosya**, **Asset**.

**Ortak kurallar:** yeni dosya + ince adaptör; çekirdekte minimal ekleme; `koy_sahnesi` / statik `KoyYerlesimi` yok; ajan asset üretmez (uygun ve açık lisanslı asset kaynak ve lisansıyla eklenebilir; AGENTS.md asset kuralı), gereken asset satıra yazılır, yerine kutu veya düz renk konur. ROADMAP 1'de biten makine (salgın, mevsim, tüccar, divan mahkemesi, yozlaşma ağacı, bölge haritası, çift kasa, cenaze, gözcü kulesi, heybe ve ipucu motoru, tansiyon aralıkları, üretim zinciri) yeniden kurulmaz. Varsa adaptör yazılır.


| Kaynak | Ne yapıyor | Bizdeki karşılığı |
|---|---|---|
| Kingdom Come: Deliverance 2 | Konu başlığından seçilen sohbet; zamanlı cevap; beceri kontrolünde zar yok, değer karşılaştırması; kontrolün türü (ikna, gözdağı, etkileme, baskı) itibara, kıyafete ve karşıdakinin statüsüne göre değişir; itibar köy/grup başına tutulur; suç tanıklar ve dedikodu ile gecikmeli yayılır | Konu merkezi (DIY-03), sıra sabrı (DIY-05), yaklaşım türleri ve muhafız itibarına göre değiştirici (ZAR-04), grup itibarı ve gecikmeli dedikodu (DIY-12, DIY-13) |
| Disco Elysium | Aktif kontrol 2d6 + beceri; beyaz kontrol tekrar denenebilir, kırmızı kontrol tek şanslık ve kalıcı; pasif kontrol zar atmadan ek satır açar | Görünür zar (ZAR-01), tekrar edilebilir / tek şanslık ayrımı (ZAR-05), muhafızın pasif sezgisi (ZAR-06) |
| Valve dinamik diyalog (Ruskin, GDC 2012) | Dünya durumu düz bir olgu listesine çevrilir; en çok koşulu tutan kural seçilir; kural yoksa susar | Bağlam sorgusu ve kural tablosu (DIY-08, DIY-09): "ambar yokken ambar demek" hatası yapısal olarak biter |
| Failbetter / Emily Short (kalite ve önem tabanlı anlatı) | Küçük "hikâyecik"ler değişken koşullarla açılır | Dünya olayları ve karakter dönüşleri hikâyecik havuzu (DNY-02) |
| Pentiment (Obsidian) | Dönem dili ağdalı değil yaşayan dil; geçmişin açtığı seçenek her zaman iyi değil; "Bu hatırlanacak" bildirimi | Muhafız geçmişi (ACL-06), üslup rehberi (YAZ-02), hatırlanma bildirimi (DIY-14) |
| Papers, Please | Beyan ile belge/eşya arasındaki çelişki oyuncunun bulduğu şeydir; denetim ve ceza | Beyan defteri ve çelişki yüzleşmesi (DIY-06, DIY-07), beyin denetçisi (DYL-09) |
| Ace Attorney | Oyuncu tanığın sözüyle kanıtı kendisi eşleştirir; yanlış eşleştirmenin bedeli var | Çelişkiyi yüzüne vurmak (DYL-01) |

**Ton örneği (yön göstermek için, nihai metin değil).** Bugünkü Sivaslı reçber kapıya varır varmaz hikâyesini anlatıyor. Hedeflenen:

- Selam: "(Çuvalı yere bırakır, bir süre soluklanır.) Selamün aleyküm, ağam… Bir tas su verir misin? Sonra ne sorarsan sor."
- "Nereden?" sorulursa: "Sivas yakasından. Köy yandı." (Susar.) Üstelenirse ikinci katman açılır.
- Tohum ancak heybede bulunursa konuşulur, ve gerekçesi bir ikilemdir (ör. tohum köyün ortak tohumudur, geride kalanlara söz vermiştir).

### A2. ROADMAP 1 zemini — biten makine, üstüne binen söz

Bu klasördeki `ROADMAP.md` kapanmış yol haritasıdır. Kapı ipucu motoru, tansiyon, heybe, karar matrisi, gecikmeli etkiler, çift kasa, mevsim, salgın, divan, yozlaşma, harita diplomasisi, fısıltı gazetesi, perde geçişi ve beş nihai son oyunda vardır. ROADMAP 2 bunları ikinci kez yazmaz. Yeni madde ya ince bir adaptördür ya da bu makinelerin üstünde duran söz katmanıdır.

| Biten iş | Kimlik | ROADMAP 2 kuralı |
|---|---|---|
| Heybe, görsel hata, suçlama kilidi | KAP-03…07, KAP-11, KAP-14 | Bakış ve yüzleşme yeni inceleme yolu açmaz. Aynı `Clue_*` okunur. |
| Kapıda hastalık teşhisi | KRI-11 | Bakışın bir bölgesidir. Kabulde mevcut karantina şartına yazar. |
| Tansiyon 0–3 / 4–7 / 8–10, panik kilidi | KAP-02, KAP-08, KAP-12, KAP-13 | Aralıklar korunur. Görünür zar bu aralıkların eki olur (ZAR-01). |
| Blöf olasılığı (oyuncu zarı görmüyor) | KAP-09 | Yerine ZAR-01 geçer. İkinci olasılık hesabı kalmaz. |
| Karar matrisi ve gecikmeli etki | KVR-07, KVR-08 | Kararın dönüşü (DYL-08) bu kuyruğa yazılır. Yeni kuyruk yok. |
| Karara bağlı sonraki karakter | KVR-09 | Karakter bağları (`baglar`) bu spawn alanına yazılır. Ayrı “takipçi listesi” yok. |
| Çift kasa, rüşvet, yozlaşma ağacı, vicdan | EKO-01, ODA-04…06, ODA-09 | Zar değiştiricisi ve muhafız tonu bu skoru okur. Yeni terazi yok. |
| Sancak müfettişi | ODA-07, ODA-13 | Beyin denetçisi (DYL-09) bu teftişin söz sahnesidir. İkinci denetçi sistemi yok. |
| Divan, kanıt sunma, ihbar | CAS-05, CAS-06, CAS-09, CAS-11, CAS-15 | Divan da Söz motoruyla konuşur (KOP-01). Dedikodu fısıltı gazetesine yazar. |
| Heyet kuyruk başında, atlanamaz | HAR-03, HAR-04, HAR-12 | Heyet bir köylü ağacı değildir (KOP-02). Ödeme kamu kasasından. |
| Mevsim, tipi, kapı görüşü | MEV-01, MEV-09, MEV-15 | Bakışın ışık koşulu ve gelen akışı bunları okur. |
| Açlık–sağlık, tüketim | EKO-09, KRI-12 | Yaşam barı (YSM) aynı gece hesabını gösterir. İkinci açlık sayacı yok. |
| Usta–çırak, bina seviyesi | UZM-04, UZM-11, ADM-08 | Yapı kilidi (YAP) yeni bir seviye sayısı icat etmez; mevcut seviyeyi bilgiye bağlar. |
| Beş nihai son, 2. perde | SYS-19, SYS-20, ODA-10 | Dünya olayları ve denetçi cezası bu sonlara koşul yazar. Altıncı son yok. |
| Adsız diyalog sırası | SYS-16 | Yeni motora geçene kadar kalır, sonra DIY-16 ile kapanır. |

Köprü maddeleri (KOP) aşağıdaki bölümlerin ön koşuludur. Kabul satırı olmayan bir “ayrıca şunu da yapalım” cümlesi yol haritasına girmez.

- [ ] **KOP-01:** Divan konuşması Söz motoruna bağlanır.
  - Ne: Yargılama sahnesi `SozMotoru` ile yürür; konuşan sanık ve muhafızdır. Kanıt listesi kapıdaki `Clue_*` kaydıdır. İpucu yokken suçlama kilitlidir. İtiraf, sürgün ve infaz mevcut üç karardan birine tek satır yazar; dördüncü ceza yoktur.
  - Kurallar:
    1. Yargılama sahnesi (CAS-05) `SozMotoru` ile yürür. Sahne dosyası `data/soz/divan_*.json` olur. Konuşan sanık ve muhafızdır.
    2. Kanıt listesi kapıdaki `Clue_*` kaydıdır (CAS-11). Yeni kanıt türü üretilmez. İpucu yoksa suçlama seçeneği kilitli kalır; kilit KAP-07 ile aynı anahtarı kullanır.
    3. Sanığın cevabı beyan defterine (DIY-06) geçer. İtiraf, sürgün ve infaz mevcut üçlü karara (CAS-07) yazılır. Dördüncü ceza türü yazılamaz.
    4. Divan dedikodu üretmez. Ağır sonuç KOP-05’in okuduğu tek kayda gider.
  - Uç durumlar: sanık kapıda hiç konuşmadan divana düşerse beyan defteri boştur; suçlama yalnız heybe ve görsel `Clue_*` ile açılır. Aynı ipucu kapıda tüketildiyse divanda ikinci yüzleşme dalı açılmaz. İtiraf seçeneği ipucu kilitliyken listede görünmez.
  - Kabul: ipucu yokken suçlama seçeneği kilitli, varken açık; verilen karar CAS-07 üçlüsünden birine tek satır yazar. Test: boş defter ve ipucu yokken suçlama sayısı 0; bir `Clue_*` varken suçlama 1 ve karar kaydı 1.
  - Bağımlılık: DIY-02, DIY-07, CAS-05. Boyut: M.
  - Dosya: `src/kapi/divan_kanit.gd` adaptör; sahne `data/soz/divan_*.json`.
  - Asset: asset gerekmedi.
- [ ] **KOP-02:** Heyet sahnesi — atlanamayan konuşma.
  - Ne: Heyet kuyruk başında durur ve atlanamaz. Heyet açıkken sıradaki köylüye soru, bakış ve heybe açılmaz. Ödeme yalnız kamu akçesi ve buğdaydır; `muhafiz_akce` bu sahnede yazılmaz. Ret, haritadaki mevcut saldırı veya asker sayacını bir artırır.
  - Kurallar:
    1. HAR-03 ve HAR-04 sahneleri `data/soz/heyet_*.json` ile yürür. Nereden, Yükün, Kimsin başlıkları bu dosyada yoktur.
    2. Heyet kuyruk başındadır ve atlanamaz (HAR-12). Heyet açıkken sıradaki köylüye soru, bakış ve heybe açılamaz.
    3. Ödeme yalnız kamu akçesi ve buğdaydır. `muhafiz_akce` bu sahnede yazılmaz.
    4. Ret, haritadaki mevcut saldırı veya asker toplama sayacına yazar. Yeni sayaç açılmaz.
  - Uç durumlar: kamu kasası ve buğday birlikte yetmezse ödeme düğmesi kilitli görünür ve eksik malın adı yazar; sahne kapanmaz. Aynı gün ikinci heyet spawn olmaz. Ferman metni üslup denetiminden geçer; yeni oyun sonu üretmez.
  - Kabul: heyet açıkken köylü soru sayısı 0. Test: haraç sahnesinde `konu_merkezi` seçeneği 0; ödeme kamu kasasından bir kez düşer; ret mevcut harita sayacını 1 artırır; `muhafiz_akce` deltası 0.
  - Bağımlılık: DIY-02, DIY-08. Boyut: M.
  - Dosya: yeni `data/soz/heyet_*.json`; `DiplomatikHeyet` tek satır.
  - Asset: asset gerekmedi.
- [ ] **KOP-03:** Hastalık, bakışın bir bölgesidir.
  - Ne: Yüz ve ellere bakınca ateş, kanlı öksürük veya irin satırı çıkabilir. Ayrı teşhis düğmesi yoktur. Belirti yokken enfeksiyon ipucu yazılmaz. Işık kapalıysa belirti de ipucu da oluşmaz. Kabul, duran karantina bayrağına bir kez yazar.
  - Kurallar:
    1. DYL-02 yüz ve eller bölgesi KRI-11 belirtilerini üretir: ateş, kanlı öksürük, irin. İpucu anahtarı KRI-11 ile aynıdır.
    2. Ayrı teşhis düğmesi yoktur. Bakış ipucu üretirse kabul kararı mevcut karantina şartını açar.
    3. Belirti satırı yokken enfeksiyon ipucu yazılmaz. Işık kapalıysa (DYL-02 `kosul.baglam.isik`) belirti de ipucu da oluşmaz.
    4. Şifahane ve salgın sayacı yeniden kurulmaz. Kabul, duran karantina bayrağına bir kez yazar.
  - Uç durumlar: aynı bölgeye ikinci bakış yeni belirti üretmez. Karakter kaçarsa (ZAR-03) ipucu kişi hafızasında kalır, karantina açılmaz. Heybede hastalık nesnesi yoksa yalnız bakış ipucu sayılır.
  - Kabul: belirti yokken enfeksiyon ipucu 0. Test: yüz bölgesinde ateş satırı varken kabul karantina şartını 1 kez açar; aynı ziyarette teşhis düğmesi 0; ışıksız bakışta ipucu 0.
  - Bağımlılık: DYL-02. Boyut: S.
  - Dosya: `src/soz/bakis.gd` ile `src/kapi/hastalik_teshis_adaptoru.gd` aynı kaydı yazar.
  - Asset: asset gerekmedi.
- [ ] **KOP-04:** Tek gecikmeli kuyruk, tek spawn zinciri.
  - Ne: Kararın dönüşü `gecikmeli_etkiler` ve `sonraki_spawns` alanlarına yazılır; ikinci kuyruk yoktur. Her satır `hedef_sistem`, `alan`, `deger` ve `tur_offset` taşır. Parser bina adını kelime listesinden tahmin etmez. Tahmin gerektiren satır `chr_parser --check` ile 1 hata verir.
  - Kurallar:
    1. DYL-08 dönüşleri ve karakter bağları `gecikmeli_etkiler` (KVR-08) ile `sonraki_spawns` (KVR-09) alanlarına yazılır. İkinci kuyruk yoktur.
    2. Her gecikmeli satır serbest cümle değildir. Zorunlu alanlar: `hedef_sistem`, `alan`, `deger`, `tur_offset`. `hedef_sistem` oyunda duran bir kapıdır: `bar`, `dedikodu`, `spawn`, `kuyu_zehri`, `ambar_kundak`. Yeni sistem adı yazılamaz.
    3. Parser bina adını kelime listesinden tahmin etmez. Tahmin olmadan `hedef_sistem` çıkmayan satır `chr_parser --check` hatasıdır.
    4. Bugün `stat_etkisi` gece motorunda genel uygulanmıyor. Yalnız kuyu zehri ve ambar kundaklaması `CasusGeceTakibi.gecikmeli` ile negatif stat arıyor. Bu madde o iki yolu ikinci kez yazmaz. Yapılandırılmış satır mevcut kuyruğa eklenir.
  - Uç durumlar: Fadime'nin "Tur 4'te Recep Ağıl kapısına dayanır" cümlesi ya `hedef_sistem: spawn` artı gerçek bir kimlik olur ya sayfadan çıkar. Şiir olarak kalan satır derlenmez. Yusuf kabulünün dönüşü kayıtta tek satırdır.
  - Kabul: yapılandırılmış satır tek kuyrukta durur. Tahmine muhtaç bir satırla `--check` 1 hata verir. Test: aynı karar iki kuyruğa yazılmaz.
  - Bağımlılık: DYL-08, DIY-11. Boyut: M.
  - Dosya: `src/soz/karar_donusu.gd` mevcut kuyruğa adaptör; `tools/chr_parser.py` alan okur, bina listesiyle tahmin etmez.
  - Asset: asset gerekmedi.
- [x] **KOP-05:** Dedikodu, fısıltı gazetesinin yazarıdır. (Antigravity)
  - Ne: Sabah pusulası yalnız dedikodu kaydındaki satırı basar. Kayıtta olmayan olay pusulada görünmez. Tanıksız rüşvet 0 satır üretir. Tanıklı rüşvet bir ila üç gece içinde tam bir satır olur. Gazete kendi cümlesini yazmaz, kaydı okur.
  - Kurallar:
    1. DIY-13 kaydı sabah pusulasına (CAS-09) ve SYS-18 bayraklarına tek yazardır.
    2. Gazete kayıttaki satırdan başka cümle basmaz. Kayıtta olmayan olay pusulada görünmez.
    3. Tanık yoksa satır çıkmaz. Tanık eşiği DIY-13 ile aynıdır; burada ikinci eşik yoktur.
    4. `BatilInancHisterisi` (KRI-08) aynı kaydı okur. Histeri motoru yeniden yazılmaz.
  - Uç durumlar: tanık gece ölür veya köyü terk ederse henüz basılmamış kayıt düşer. Aynı olay kimliği iki gece üst üste ikinci satır üretmez. Kişisel kasadaki rüşvet de tanık varsa bir satırdır; tanık yoksa akçe hareketi pusulaya yazılmaz.
  - Kabul: tanıksız rüşvet pusulada 0 satır. Test: tanıklı rüşvet 1–3 gece içinde pusulada tam 1 satır; gazete yazma çağrısı 0, okuma çağrısı 1.
  - Bağımlılık: DIY-13. Boyut: S.
  - Dosya: `src/sistemler/dedikodu.gd`; `fisilti_gazetesi.gd` okur.
  - Asset: asset gerekmedi.
- [ ] **KOP-06:** Yozlaşma ağacı sözü ve zarı değiştirir.
  - Ne: Göz yumma ve keskin bakış zar değiştiricisidir; yeni yetenek puanı açılmaz. Aynı skor muhafızın tonunu seçer: yoz uçta gözdağı, adil uçta gönül alma. Üç tonda da etki sözlüğü aynı kalır. Orta skorda değiştirici sıfırdır.
  - Kurallar:
    1. ODA-05 (göz yumma, haraç) ve ODA-06 (keskin bakış, gönül bağı) ZAR-04 değiştiricisidir. Yeni yetenek puanı açılmaz.
    2. Aynı skor DIY-15 tonunu seçer. Yoz uçta gözdağı metni, adil uçta gönül alma metni gelir. Üç tonda da mekanik etki sözlüğü aynı kalır.
    3. Vicdan kabusları (ODA-09) akşam sohbetinin konu adayıdır (DYL-07). Ayrı kabus sahnesi kurulmaz.
    4. Terazi yeniden kurulmaz. Okunan değer mevcut `MuhafizTerazisi` skorudur.
  - Uç durumlar: skor ortadaysa değiştirici 0’dır ve varsayılan ton gelir. Uç skor ±1’den büyük değiştirici yazamaz; tavan ZAR-04 tablosundadır. Kabus konusu o günün ağırlık tablosunda yoksa seçilmez.
  - Kabul: aynı seçenek kimliğinde yoz ve adil metin anahtarı farklı, etki sözlüğü aynıdır. Test: iki uçta etki JSON eşit; yeni yetenek anahtarı 0; orta skorda değiştirici 0.
  - Bağımlılık: ZAR-04, DIY-15, DYL-07. Boyut: S.
  - Dosya: `src/kapi/zar_degistiricileri.gd` mevcut skoru okur.
  - Asset: asset gerekmedi.
- [ ] **KOP-07:** Perde ve son metinleri aynı ağızdan yazılır.
  - Ne: Köyün oturması, beş nihai son ve epilog `data/soz/sonlar.json` anahtarlarından okunur. `nihai_son.gd` cümle üretmez. Altıncı son kimliği doğrulayıcıda 1 hata verir. Koşulu tutmayan son gösterilmez.
  - Kurallar:
    1. “Köy oturdu” (SYS-19), beş nihai son ve muhafız epiloğu (SYS-20, ODA-10) üslup rehberinden ve yapaylık denetiminden geçer.
    2. Yeni son eklenmez. Dünya olayı ve denetçi cezası mevcut son koşullarına yazar.
    3. Metin anahtarları `data/soz/sonlar.json` içindedir. `nihai_son.gd` cümle üretmez, anahtar okur.
    4. Yasak kalıp (YAZ-02) bu dosyada 0 olmalıdır. Denetim geçmeden son kapanmaz.
  - Uç durumlar: koşulu tutmayan son metni gösterilmez. İki son aynı gece tutarsa SYS-20 öncelik tablosu kazanır; yeni öncelik sırası yazılmaz. Epilog, son tetiklenmeden seçilmez.
  - Kabul: son kimliği sayısı 5; metin denetiminde yasak kalıp 0. Test: altıncı kimlikle yüklenen `sonlar.json` doğrulayıcıda 1 hata; koşulsuz epilog satırı 0.
  - Bağımlılık: YAZ-02, DNY-04, DYL-09. Boyut: M.
  - Dosya: `data/soz/sonlar.json`; `src/sistemler/nihai_son.gd` anahtar okur.
  - Asset: asset gerekmedi.
- [ ] **KOP-08:** Tüccar kapıda pazarlık sahnesidir.
  - Ne: Geçiş bacı ve rüşvet konu menüsü olmadan pazarlık sahnesinde yürür. Resmi vergi kamu kasasına, şahsi rüşvet `muhafiz_akce` hesabına ayrı satır yazar. İki hedef aynı düğmede birleşmez. Heyet kuyruk başındayken tüccar konuşmaz.
  - Kurallar:
    1. Geçiş bacı ve rüşvet (TUC-12) pazarlık sahne biçimindedir (OZGUNLUK §4). Konu menüsü yoktur.
    2. Şahsi rüşvet `muhafiz_akce` hesabına işler. İkinci kasa açılmaz.
    3. Resmi vergi kamu kasasına, şahsi rüşvet kişisel kasaya yazar. İki hedef aynı düğmede birleşmez.
    4. Pazarlık zar kullanırsa yaklaşım ikna veya blöftür (ZAR-04). Beşinci yaklaşım türü yoktur.
  - Uç durumlar: kişisel kasa yetmezse rüşvet düğmesi kilitli görünür ve sahne açık kalır. Heyet kuyruk başındayken (KOP-02) tüccar konuşmaz. Tanıklı rüşvet KOP-05’e tek satır yazar.
  - Kabul: resmi vergi ile şahsi rüşvet iki ayrı kayıt. Test: bir pazarlıkta kamu kasası +M ve `muhafiz_akce` +N ayrı satır; konu başlığı sayısı 0.
  - Bağımlılık: DIY-02. Boyut: S.
  - Dosya: `data/soz/tuccar_kapi.json`.
  - Asset: asset gerekmedi.
- [ ] **KOP-09:** Hayalet takip kimliği kalmaz.
  - Ne: `chr_parser.py --check` sayfası olmayan takip kimliğini artık uyarı değil hata sayar. `sonraki_spawns` içindeki her kimlik ya bir CHR sayfasına sahiptir ya satır silinir. Olmayan kişi için "ileride gelir" cümlesi yazılmaz. Boş yuvayı doldurmak için yeni CHR üretilmez.
  - Kurallar:
    1. `chr_parser.py --check` bugün 30 sayfayı geçerli sayar ve 93 takip kimliğini sayfasız bırakır (uyarı). Bu uyarı hataya döner.
    2. `sonraki_spawns` içindeki her kimlik ya `karakterler/CHR_*.md` sayfasına sahiptir ya satır silinir.
    3. Silinen satırın yerine "ileride gelir" cümlesi yazılmaz. Olmayan kişi vaat edilmez.
    4. Dört spawn zorunluluğu kalkar. Sayfa 0, 1 veya daha çok gerçek kimlik yazabilir. Eksik yuvayı doldurmak için boş CHR üretilmez.
  - Uç durumlar: CHR_017'deki CHR_068 (Hatice), CHR_069 (Recep), CHR_070 (Gülizar), CHR_071 (Pakize) ya kendi sayfalarını alır ya Fadime'nin spawn satırından silinir. Başka bir sayfanın aynı kimliğe bakması da sayfa sayılır. Kimlik çakışması hatadır.
  - Kabul: `--check` çıktısında external follow-up 0. Test: sayfasız bir kimlik bırakılan dosya 1 hata verir.
  - Bağımlılık: KOP-04. Boyut: M.
  - Dosya: `tools/chr_parser.py`; `karakterler/CHR_*.md` Bölüm 5 spawn satırları.
  - Asset: asset gerekmedi. Yeni model bu maddeyle açılmaz.
- [ ] **KOP-10:** Kapıdaki sayı, kişinin karar matrisinden gelir.
  - Ne: Adlı CHR ziyaretinde bar etkisi sınıf şablonundan değil `karar_matrisi` satırından gelir. Sır açık ve sır gizli varyantı varsa doğru varyant seçilir. Adsız figür şablonda kalır. Rüşvet akçesi kişisel kasada kalır, kamu kasasına ikinci kez yazılmaz.
  - Kurallar:
    1. Bugün adlı gelende düğme etkisi `k.etki(karar)` ile sınıf şablonundan gelir. CHR matrisinin beş statı (Refah, Erzak, Güvenlik, Moral, Sağlık) köy barına yazılmaz. Matris kapıda yalnız rüşvetin `muhafiz_akce` ve `esyalar` alanı için okunur.
    2. CHR ziyaretinde etki `karar_matrisi` satırından gelir. Sır açık ve sır gizli varyantı varsa doğru varyant seçilir. Clamp −4…+4 durur.
    3. Sınıf şablonu yalnız adsız figürde kalır (`diyalog_01_20.json` ve sınıf şablonu). Adlı CHR'de şablon etkisi ayrıca uygulanmaz.
    4. Rüşvet akçesi kişisel kasada kalır. Kamu kasasına ikinci bir yazım yoktur.
  - Uç durumlar: varyant yoksa düz satır kullanılır. Matriste olmayan bir karar düğmesi kapıda görünmez. Adsız kabuldeki rastgele ±1 (oturumdaki şablon titremesi) CHR yoluna sızmaz.
  - Kabul: CHR_017 kabul ve sır çözülmüşken Erzak +2 ve Moral +2 köy barına bir kez yazar; sınıf şablonu o ziyarette yazmaz. Adsız `diyalog_01` kabulü şablondan gelir. Test: dört karar türü, iki varyant.
  - Bağımlılık: DIY-02. Boyut: M.
  - Dosya: kapı karar uygulayıcısına tek okuma; `data/chr_runtime/CHR_*.tres` kaynağı değişmez, şema KOP-04 ile yapılandırılır.
  - Asset: asset gerekmedi.

---

## Hazır asset entegrasyonu — Ahmet/Muharrir, 28 Ekim 2026

Yalnız repodaki hazır 3D, animasyon, ses ve VFX kaynakları bağlanır. Mekanik, diyalog, denge ve 2D değişmez. Tam sanity yalnız Ahmet ayrıca isterse çalıştırılır; bölüm hedefli headless import/parse ve sahne testleriyle doğrulanır.

- [x] **HAE-01:** Köyün kutu yapılarını MegaKit modülleriyle değiştir. (Kalfa)
  - Dosya: `src/koy/gorsel/hazir_koy_yapilari.gd`, `src/dunya/koy_yonetim_sahnesi.gd`.
  - Kabul: hazır konut/kapalı yapı kabuğu ve saçak tek görsel ailede; taban y=0, mevcut ızgara zarfı aşılmaz. İnşaat iskeleleri ve tarla/ağıl mekaniği korunur; eksik özgül yapı etiketlenir. İHT-0372/0397 bağlantısı ve hedefli geometri/yenileme testi.
- [x] **HAE-02:** LOWPO demirci/çocuk ve UAL idle/yürüme/iş kliplerini ilgili rollere bağla.
  - Çözüldü (Kalfa): Ahmet’in açık onayıyla yerel UAL/KayKit kaynaklarından yalnız sayısal rig/rest referansı çıkarıldı; yeni indirme/ham model yok.
  - Dosya: `src/dunya/hazir_karakterler.gd`, `src/dunya/hazir_karakter_animasyonu.gd`, `src/dunya/dunya3b.gd`, `src/dunya/hazir_karakter_modeli.gd`, `data/animasyon/ual_referans.json`.
  - Kabul: çocuk 1,15 m, yetişkin 1,80 m; rig/rest pozu dönüşümü, yürüyüş/idle geçişi ve iş hareketi hedefte denenir. UAL ana, A03 yalnız karşılığı yoksa; doğrulanmayan klip zorlanmaz. Mevcut CHR kimliği, rota ve çalışma mantığı korunur. İHT-0357/0431 ve doğrulanan hareketler işaretlenir.
- [x] **HAE-03:** Örs/alet/masa/yatak/odun ve koyun/inek/köpek sahne bağlantıları.
  - Dosya: `src/koy/gorsel/hazir_esya_hayvan.gd`, mevcut zanaat/hayvan görsel adaptörleri.
  - Kabul: gerçek kullanım noktaları, metre ölçeği, yerde doğru pivot; mevcut öküz dosyası korunur. Mevcut sürü/üretim sayıları değişmez; bulunmayan eşya isim etiketli kalır. Bağlanan İHT'ler iki envantere yazılır.
- [x] **HAE-04:** Hazır sesleri mevcut Ses üzerinden bağla; dere WAV'ını kısa döngülü OGG'a çevir.
  - Dosya: `src/ses/hazir_ses_kaynaklari.gd`, `src/sistemler/ses.gd`, `assets/ses/quendel/dere_dongu.ogg`, `docs/credits/HAZIR_ASSET_ATIFLARI.md`.
  - Kabul: kapı aç/kapa, adım, sikke, dere ve örs doğru tetiklerde; yeni autoload yok. Kısa OGG döngüsünde yumuşak birleşim, atıfta “ogg'a çevrildi (Kalfa)”; bus/susturma/kayıt mantığı korunur.
- [x] **HAE-05:** Meşale alevi, baca dumanı ve ocak ateşi GPUParticles3D bağlantıları.
  - Dosya: `src/koy/gorsel/hazir_ates_efektleri.gd`, `src/dunya/dunya3b.gd`, köy/atölye görsel adaptörleri.
  - Kabul: yalnız mevcut izinli duman/alev/ışık dokuları; sınırlandırılmış parçacık miktarı, doğru yayın alanı, gece okunurluğu ve sahne temizliği. Elektrik/büyü ve 2D UI yok. İHT karşılıkları/testler kaydedilir.
