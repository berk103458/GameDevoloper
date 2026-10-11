# Kapı Muhafızı — ROADMAP 2 / Parça A

Parça A: acil kilitler, açılış, kapı akışı, arayüz. Oyun kodu bu dosyadan yazılmaz.

**Madde biçimi:** Amaç, numaralı Kurallar, Uç durumlar, ölçülebilir Kabul ve test, Bağımlılık, Boyut, Dosya, Asset.

**Ortak kurallar:** yeni dosya + ince adaptör; çekirdekte minimal ekleme; `koy_sahnesi` / statik `KoyYerlesimi` yok; ajan asset üretmez ve indirmez. ROADMAP 1 bitmiştir. Salgın, mevsim motoru, tüccar, divan mahkemesi, yozlaşma ağacı, bölge haritası, çift kasa, cenaze töreni, gözcü kulesi, heybe ve ipucu motoru, tansiyon aralıkları ve üretim zinciri burada yeniden kurulmaz. Madde onları okur.

Boş günün köyde keyif olması SEV-01'dir (Parça C). Bu parça boş günü yalnız üretir.

---


BUG-16 … BUG-25 gövdesi durur. Yeni maddeler BUG-26 … BUG-105. TEK ve DEN'de duran borç burada ikinci kez çözülmez.

### 13.1 Olay koşulu

- [ ] **BUG-16:** Olay ön koşul denetimi — bina, nüfus ve yaş grubu koşulu sağlanmayan olay tetiklenmez.
  - Ne: Gece kartı, metninde geçen bina köyde yoksa, istenen yaş grubu yoksa ya da nüfus eşiği tutmuyorsa oyuncuya hiç açılmaz. Seçici `OlayVerisi.kosullar` içindeki `bina_var`, `nufus_en_az`, `cocuk_var` ve `yas_grubu` anahtarlarını okur; koşul tutmayan kartın ağırlığı sıfır olur ve yerini koşulu tutan bir kart alır. Havuz boşsa o gece kart çıkmaz, köy fazı yine açılır.
  - Kabul: Ambar yokken ambar adı geçen kart 100 gecede 0 kez seçilir (`tests/unit/olay/on_kosul_test.gd`). Tarama listesinde her `data/olaylar/*.tres` için bir satır vardır; imzasız bina adı 1 doğrulama hatası verir. Tanınmayan koşul anahtarı sessizce yok sayılmaz, aynı test 1 hata yazar. Nüfus eşiği sayı olarak `.gd` dosyasına gömülmez; `nufus_en_az` yalnız `.tres` içindedir. Ek şart: `olay_on_kosulu.gd` `koy_sahnesi` import etmez. Ek şart: yarım kalmış kayıtta olay ertesi gece yeniden koşula bakar, zorla bitirilmez. Ek şart: aynı tohumla iki koşu aynı olay kimliğini seçer.
  - Bağımlılık: yok. Boyut: M.
  - Dosya: yeni `src/sistemler/olay_on_kosulu.gd`; olay seçiminde tek satır çağrı; `data/olaylar/*.tres` koşul alanları.
  - Asset: asset gerekmedi.


### 13.2 Fısıltı

- [ ] **BUG-17:** Fısıltı gazetesi yer bilgisi — pusula yalnız köyde var olan bir yeri anar.
  - Ne: Sabah pusulası oyuncuya "dün ambar tarafındaydı" demez; ambar yoksa o kalıp hiç basılmaz. `data/fisilti_gazetesi.json` içindeki sabit yer adı `{yer}` olur ve `{yer}` yalnız o gece ayakta duran binalardan seçilir. Uygun bina yoksa pusula o gece yazılmaz. Gece içinde yanan bina sabah seçilmez. Kişi adı `{yer}` yerine geçmez.
  - Kabul: Binasız köyde 30 gecede yer pusulası 0 satırdır. Ambar ayaktayken en az bir denemede pusula metninde "ambar" geçer. Olmayan bir bina adı 30 gecede 0 kez görünür (`tests/unit/kapi/fisilti_yer_test.gd`). Ek şart: ölü ya da köyden ayrılmış kişinin adı pusulada basılmaz; bu süzgeç SOY-45 ile aynı kayıttır, ikinci liste tutulmaz.
  - Bağımlılık: BUG-16. Boyut: S.
  - Dosya: `src/kapi/fisilti_gazetesi.gd` yer seçimine adaptör; `data/fisilti_gazetesi.json`.
  - Asset: asset gerekmedi.


### 13.3 Tehdit takvimi

- [ ] **BUG-18:** Tehdit alışma süresi — pusucu, çete, casus ve sabotaj ilk N gün gelmez.
  - Ne: Oyuncu ilk iki haftayı kapıyı ve köyü öğrenerek geçirir; pusucu, çete ve sabotaj o sürede kapıya düşmez. Süre `tehdit_baslangic_gunu` ayarındadır, öneri 14 gündür ve koda gömülmez. Moğol sayacı (HAR-02) bu sürede de artar. Sancak ulağı ve diplomatik heyet bu listenin dışındadır. Süre dolmadan debug ile çağrılan tehdit takvimi "doğal geliş" saymaz. Kayıt 14 günü geçmişse takvim geriye sarılmaz.
  - Kabul: 13. günde pusucu, çete ve sabotaj gelişi 0; aynı günde HAR-02 sayacı yine artar. Ulağın ilk gün gelişi engellenmez. 15. günde bu üç tehdidin ağırlığı taban değere döner (`tests/unit/sistemler/tehdit_takvimi_test.gd` dört iddiayı ayrı koşar). Ek şart: süre dolmadan debug ile çağrılan tehdit takvim sayacını artırmaz. Ek şart: 14 günü geçmiş eski kayıt açılınca `tehdit_baslangic_gunu` başa alınmaz.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: yeni `src/sistemler/tehdit_takvimi.gd`; `GuvenlikKafileDengesi` ve baskın tetikleyicilerine tek satır.
  - Asset: asset gerekmedi.


### 13.4 Sıra olayı

- [ ] **BUG-19:** Sıra olaylarında cinsiyet ve yaş uyumu — metin, sahnedeki gerçek modele göre yazılır.
  - Ne: Sırada bayılan kişi erkekse oyuncu "yaşlı bir kadın" cümlesini görmez. Beş sıra olayı (`sira_atlama`, `sira_bayilma`, `sira_kavga`, `sira_panik`, `sira_vazgecen`) seçilen modelin cinsiyetini ve yaş grubunu okur; metin `{kisi}` kalıbıdır ve kadın, adam, çocuk, yaşlı için ayrı çeviri anahtarı vardır. Modelde cinsiyet yoksa metin "biri" der. Çocuk modele yaşlı anahtarı verilmez.
  - Kabul: Beş olayın her birinde 100 denemede metindeki kişi sözcüğü modelin cinsiyeti ve yaşıyla birebir uyar (`tests/unit/kapi/sira_olayi_kisisi_test.gd`). Eksik cinsiyette "biri" 1 kez, yanlış cinsiyet 0 kez çıkar. Sabit "yaşlı bir kadın" satırı `data/sira_olaylari/` altında 0 kalır. Ek şart: sırada kimse yoksa olay başlamaz; bu kapı BUG-16 nüfus koşuludur. Ek şart: çocuk modelde yaşlı anahtarı 100 denemede 0 kez seçilir.
  - Bağımlılık: yok. Boyut: M.
  - Dosya: yeni `src/kapi/sira_olayi_kisisi.gd`; `data/sira_olaylari/*.tres` anahtar ekleri; `data/metin/metinler.csv` satır ekleme.
  - Asset: asset gerekmedi.


### 13.5 Açılış kaynak kilidi

- [ ] **BUG-20:** Sıra olayı seçimlerinin gerçek sonucu — yardım edilmeyen kişi ölebilir, sakatlanabilir, terk edebilir.
  - Ne: "Sıra yürüsün" seçilince yere düşen kişi yerinde kalmaz; `data/sira_olaylari/sonuclar.json` ölüm, sakatlık, sıradan ayrılma ya da toparlanmadan birini seçer ve gece raporu bunu tek satır yazar. Yardım düğmesi erzak ya da akçe ister; kaynak yetmezse düğme kapalı kalır. Ölüm duran cenaze akışını (KRI-05) bir kez çağırır. Sakat kalan kişi kabul edilirse düşük sağlıkla içeri girer; terk eden kişi köylü olmaz.
  - Kabul: "Sıra yürüsün" dört sonuçtan birini üretir ve raporda görünür. Yardım gerçek kaynak düşer. Ölüm KRI-05'i bir kez çağırır. Test: 1000 zar, oran sapması %3'ün altında. Kaynaksız köyde yardım düğmesi kapalı.
  - Bağımlılık: BUG-19. Boyut: M.
  - Dosya: yeni `src/kapi/sira_olayi_sonucu.gd`; olay sonucu uygulayan yere tek satır.
  - Asset: asset gerekmedi.


### 13.6 Kamera, meşale, kuyu

- [ ] **BUG-21:** Taş kilidi — başlangıç taş yatağı ve kurtarıcı kaynak.
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

- [ ] **BUG-22:** Açılış ekonomisi dengesi — başlangıç stoku ve ilk yapı maliyetleri kilitlenmez.
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

- [ ] **BUG-23:** Çiftçi tarla üstünde çalışır — iş noktası tarla alanının içinde.
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

- [ ] **BUG-24:** Kamera orta tuşla sürükleme — strateji oyunlarındaki gibi harita kaydırma.
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

- [ ] **BUG-25:** Kapı meşaleleri ve kuyu modeli onarımı.
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

### 14.1 Köyden açılış

- [ ] **ACL-01:** Oyun köy ekranından başlar — tek ev, muhafız ve eşi.
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

- [ ] **ACL-02:** Eş — oynanabilir ama sıradan köylü değil.
  - Ne: Eş köylü listesinde ayrı satırdadır; kışla, kervan, sürgün ve divan düğmeleri onda kapalıdır ve kapı kuyruğuna yazılmaz. Meslek yalnız `data/hane_esi.json` listesinden seçilir: dokumacı, ebe, fırıncı, bostancı, sütçü, yün eğirici; okuryazar geçmişte kâtiplik açılır. Demirci, taşçı, oduncu, asker ve madenci listede yoktur. Meslek değişince bir gün verimsiz çalışır. Ölümde yeni son yazılmaz, duran epilog ağır yas olarak açılır.
  - Kurallar:
    1. Eş köylü listesinde ayrı satırdadır. Kışla, kervan, sürgün ve divan düğmeleri onda kapalıdır.
    2. Meslek yalnız `data/hane_esi.json` listesinden seçilir: dokumacı/keçeci, ebe/şifacı, fırıncı/aşçı, bostancı, sütçü/yoğurtçu, yün eğirici. Okuryazar geçmişte (ACL-06 medrese) kâtiplik açılır.
    3. Demirci, taşçı, oduncu, asker ve madenci listede yoktur. Liste dışı bir kimlik reddedilir.
    4. Meslek değişince 1 gün verimsiz çalışır. Arabuluculuk her meslekte açıktır ve morale yazılır.
    5. Ölüm, duran epilog dalını ağır yas olarak açar (SYS-20 / ODA-10). Yeni son yazılmaz.
  - Uç durumlar: eş ölünce akşam sohbeti (ACL-03) bir daha açılmaz. Meslek günü dolmadan ikinci değişiklik birikir, gün 1'de kalır, 2 olmaz. Debug konsolundan demirci yazılırsa kayıt reddeder. Eşin sağlığı ve morali köylü barıdır (YSM-01), ayrı bir eş barı açılmaz.
  - Kabul: Listede altı meslek ve okuryazar geçmişte kâtiplik atanır; demirci ve asker 0 kez kabul edilir (`tests/unit/koy/hane_esi_test.gd`). Eşte kışla, kervan, sürgün ve divan düğmesi kapalıdır. Ek şart: eşin kimliği kapı kuyruğunda 0 kez görünür. Ek şart: kalp alanı yazılmaz.
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

- [ ] **ACL-04:** Kapıyı açan olay — ilk gün akşamı: Sancak Beyi'nin ulağı ve kapıdaki ilk aile.
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

- [ ] **ACL-05:** Barınak kapasitesi kabul sınırı — yer yokken kabul edileni oyuncu bilir.
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

- [ ] **ACL-06:** Muhafızın geçmişi — açılışta seçilen arka plan.
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

### 15.1 Gelen sayısı

- [ ] **KAP-16:** Değişken gelen sayısı, boş gün ve sayfadaki bar eşiği.
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

- [ ] **KAP-17:** Aileler birlikte gelir.
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

- [ ] **KAP-39:** Heybe açıkken soru seçilmez
  - Ne: Heybe paneli açıkken oyuncu yeni bir soru seçemez ve soru hakkı düşmez. Panel kapanınca kalan hak aynı sayıda durur. Karar düğmesi de bu sırada etki yazmaz.
  - Kabul: Heybe açıkken soru düğmesine basmak hak sayısını değiştirmez ve yeni dal açmaz (`tests/unit/kapi/heybe_kilit_test.gd`). Panel kapanınca hak, açılmadan önceki değerle aynıdır.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `src/arayuz/kapi_ekrani.gd`, `src/arayuz/heybe_paneli.gd`
  - Asset: asset gerekmedi.

### 15.4 Karar

- [ ] **KAP-19:** Köy nüfusu kompozisyonu — çocuksuz köyde çocuk olayı yok.
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

- [ ] **KAP-45:** Karar bir kez uygulanır
  - Ne: Oyuncu kabul ya da ret düğmesine art arda bassa bile gece sonu etkisi bir kez yazılır. Bar kırılınca `oturum_bitti` bir kez gider; ikinci kırılma ikinci sinyal üretmez. Heybe açıkken bu düğmeler de etki yazmaz.
  - Kabul: Aynı karara iki tıkta bar deltası 1'dir (`tests/unit/kapi/karar_bir_kez_test.gd`). Bar sıfıra inince `oturum_bitti` 1 kez yayılır.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `src/arayuz/kapi_ekrani.gd`
  - Asset: asset gerekmedi.

- [ ] **KAP-48:** Rüşvet hakkı ayardadır
  - Ne: Kapı, rüşvet düğmesini `oyun_ayarlari.gd` içindeki `rusvet_hakki` değerine göre kapatır. Alan bugün yalnız tanımlı, kapı onu okumuyor. Ayar 1 iken ikinci rüşvet denemesi düğmeyi kapalı bırakır. Sayı kapi ekranının içine gömülmez.
  - Kabul: `rusvet_hakki` 1 iken ikinci rüşvet denemesinde düğme kapalıdır ve gece sonuna ikinci rüşvet yazılmaz (`tests/unit/kapi/rusvet_hakki_test.gd`). Alan `src/veri/oyun_ayarlari.gd` dışında ikinci bir 3 sabiti olarak durmaz.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `src/arayuz/kapi_ekrani.gd`; okuma `src/veri/oyun_ayarlari.gd`.
  - Asset: asset gerekmedi.

ARY-01 … ARY-05 gövdesi durur. Yeni maddeler ARY-06 … ARY-85. Dosya dosya iş GRV-31 ve sonrasındadır; burada ikinci palet yok.

### 24.1 Şablon seçimi

- [ ] **ARY-01:** Görsel dil için örnek şablonlar — Berk ve Ahmet seçer.
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

- [ ] **ARY-05:** ROADMAP 2 asset listesi — yalnız gerekenler.
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



