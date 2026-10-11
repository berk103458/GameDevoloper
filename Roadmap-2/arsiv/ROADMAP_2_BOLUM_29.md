# BÖLÜM 29: Tezgâhta gün

Zemin: çıraklık UZM-04 ve UZM-11, tezgâh hareketi ANI-08, zanaat siparişi TUC-05. Yeni üretim ağacı yok. YAP kademesi bu bölümde yazılmaz. Beş usta sabahında iş gözle değişir: ham, iz, biçim, ağız, teslim. Siparişin bir yüzü vardır. Usta yoksa çırak durur, gün ilerlemez, parçada titreme izi kalır.

Yerler döneme uygundur: ağıl, değirmen, demirhane, bez. Kalp puanı, romans, ses ve ikinci harita yoktur. Her madde bir öncekinin kaydını okur.

## 29.1 Yer ve yüz

- [ ] **TEZ-01:** Dört tezgâhın yeri
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

- [ ] **TEZ-14:** Tezgâh eşi meslek üretimidir
  - Ne: Tezgâh eşi meslek üretimidir. HAN. İkinci tezgâh sınıfı yok.
  - Kabul: Sınıf 0 yeni. Test: HAN-07.
  - Bağımlılık: HAN-07. Boyut: S.
  - Dosya: `src/koy/es_uretimi.gd`
  - Asset: asset gerekmedi.

## 29.2 Beş sabah — ham, iz, biçim, ağız

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

## 29.3 Ustanın yokluğu ve teslim

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

## 29.4 Tek cümle ve sayım

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

- [ ] **TEZ-37:** Cümle şablon iskelet taşımaz
  - Ne: Cümle şablon iskelet taşımaz. İki yüz aynı iskelet 1 uyarı.
  - Kabul: Cümle şablon iskelet taşımaz. Uyarı 1. Test: YAZ-09.
  - Bağımlılık: YAZ-09. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.
- [ ] **TEZ-38:** Cümle yıl sayısı söylemez
  - Ne: Cümle yıl sayısı söylemez. 1240 ağızda 1 hata.
  - Kabul: Cümle yıl sayısı söylemez. Hata 1. Test: YAZ-02.
  - Bağımlılık: YAZ-02. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.
- [ ] **TEZ-40:** Cümle sabah defterini değiştirmez
  - Ne: Cümle sabah defterini değiştirmez. SAB kendi satırı.
  - Kabul: Cümle sabah defterini değiştirmez. Kopya 0. Test: SAB-01.
  - Bağımlılık: SAB-01. Boyut: S.
  - Dosya: `src/koy/sabah_defteri.gd`
  - Asset: asset gerekmedi.
- [ ] **TEZ-41:** Cümle dedikodu tanık ister
  - Ne: Cümle dedikodu tanık ister. Tanıksız 0.
  - Kabul: Cümle dedikodu tanık ister. 0. Test: DIY-13.
  - Bağımlılık: DIY-13. Boyut: S.
  - Dosya: `src/sistemler/soylenti_agi.gd`
  - Asset: asset gerekmedi.


## 29.5 Ham ve iz

- [ ] **TEZ-47:** Sayım ölçümü DEN satırıdır
  - Ne: Sayım ölçümü DEN satırıdır. Formül değişmez.
  - Kabul: Sayım ölçümü DEN satırıdır. Satır 1. Test: DEN.
  - Bağımlılık: DEN-05. Boyut: S.
  - Dosya: `src/sistemler/denge_olcumu.gd`
  - Asset: asset gerekmedi.

## 29.6 Teslim

- [ ] **TEZ-58:** Fire ölçümü DEN'dedir
  - Ne: Fire ölçümü DEN'dedir. Formül değişmez.
  - Kabul: Fire ölçümü DEN'dedir. Satır 1. Test: DEN.
  - Bağımlılık: DEN-05. Boyut: S.
  - Dosya: `src/sistemler/denge_olcumu.gd`
  - Asset: asset gerekmedi.

## 29.8 Sınır

- [ ] **TEZ-70:** Uzun satır kayar
  - Ne: Uzun satır kayar. Kesilen glif 0.
  - Kabul: Uzun satır kayar. 0. Test: GRV-15.
  - Bağımlılık: GRV-15. Boyut: S.
  - Dosya: `src/arayuz/koy_ekrani.gd`
  - Asset: asset gerekmedi.
- [ ] **TEZ-72:** Esc teslim etmez
  - Ne: Esc teslim etmez. Delta 0.
  - Kabul: Esc teslim etmez. 0. Test: GIR-08.
  - Bağımlılık: GIR-08. Boyut: S.
  - Dosya: `src/arayuz/ana.gd`
  - Asset: asset gerekmedi.

## 29.10 Kapanış

- [ ] **TEZ-89:** Olay kartı teslim etmez
  - Ne: Olay kartı teslim etmez. OZL şema büyümez.
  - Kabul: Olay kartı teslim etmez. Alan 0. Test: OZL-30.
  - Bağımlılık: OZL-30. Boyut: S.
  - Dosya: `src/veri/olay_verisi.gd`
  - Asset: asset gerekmedi.

Alt başlık ona tamamlandı. Eski gövde durur. Yeni kimlikler TEZ-11 … TEZ-90. Her alt başlığa sekiz yeni satır kondu.
