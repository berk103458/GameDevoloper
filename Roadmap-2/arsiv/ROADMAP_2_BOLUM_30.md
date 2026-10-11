# Kapı Muhafızı — ROADMAP 2 / Bölüm 30


Zemin `MEV-01` … `MEV-15` duran mevsim döngüsüdür. Yıl 4 mevsim × 7 gündür; gün sayısı `mevsim_yoneticisi` kaydından okunur. Bu bölüm o motora bir kişinin satırını bağlar. 1240'lar Anadolu: cümle hasadı, kışı, tarlayı ve su sırasını söyler; tarih dersi açmaz.

Aynı iş burada yeniden kurulmaz. Kar örtüsü `MEV-04`'tür. Kış ölümü `MEV-02` / `MEV-11` ve `EKO-09` hesabındadır. Donmuş tarla `MEV-03`'tür. Hasat şenliği ve moral `MEV-08`'dir. Taşkın `MEV-06`'dır. Yaz su çarpanı `MEV-07`'dir. Su taşıma `ANI-03`'tür. Takvim göstergesi `MEV-12`'dir. Boş gün ateşi `SEV-01`'dir. Ateşe gelen tanıdık `SEV-02`'dir. Karttaki ad `SEV-06`'dır. Veda `SEV-07` ve `KRI-05`'tir. Beş nihai son `SYS-20`'dir.

Kalp puanı, hediye takvimi, romans ve seslendirme bu bölümde yoktur. Asset üretilmez.

### 30.1 Yılın yüzü

- [ ] **YIL-01:** Yılın yüzü bir kişidir
  - Ne: Mevsim yılı açılırken köyde yaşayan adlı yetişkinlerden biri `yil_izi` alanına bir kez yazılır; tarla işi olan varsa o seçilir, tek adlı yetişkin eş ise o seçilir. Dört mevsim aynı kimliği okur; adsız, ölü ve köyden ayrılmış kişi seçilmez, kişi ölürse kalan slotlar boş kalır.
  - Kabul: Bir yılda `yil_izi` en çok bir kimliktir ve dört mevsim slotu o kimliği taşır (`tests/unit/koy/yil_izi_test.gd`). Köyde adlı kimse yokken satır 0'dır; boş günde yıl satırı 0'dır; ölümden sonra açılan slot 0 ve cenaze seçeneği 2'dir. Ek şart: aynı tohumla iki açılış aynı kimliği seçer. Ek şart: eski kayıtta `yil_izi` yoksa alan boş kalır ve mevsim günü artar. Ek şart: satır düz cümle gömmez, `data/soz/yil_izi.json` anahtarını okur. Ek şart: `yil_izi.gd` takvim düğümü açmaz ve `koy_sahnesi` import etmez. Ek şart: nöbet ataması değişmez ve nöbet gecesinde duyulmuş satır silinmez. Ek şart: anahtar yoksa o slot 0 sayılır, mevsim günü yine artar.
  - Bağımlılık: MEV-01, YAZ-08. Boyut: M.
  - Dosya: yeni `src/koy/yil_izi.gd`; `data/soz/yil_izi.json`. `mevsim_yoneticisi` tek okuma.
  - Asset: asset gerekmedi.

### 30.2 Güz

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

### 30.3 Kış

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

- [ ] **YIL-34:** Kış ölçümü DEN satırıdır
  - Ne: Kış ölçümü DEN satırıdır. Formül değişmez.
  - Kabul: Kış ölçümü DEN satırıdır. Satır 1. Test: DEN.
  - Bağımlılık: DEN-05. Boyut: S.
  - Dosya: `src/sistemler/denge_olcumu.gd`
  - Asset: asset gerekmedi.

### 30.4 İlkbahar

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

### 30.5 Yaz

- [ ] **YIL-08:** Yaz su sırasında bir söz duyulur
  - Ne: Mevsim yaz iken ANI-03 su taşıma sırasında bir satır duyulur; yeni kuyruk ve yeni su kaynağı açılmaz, su tüketimi MEV-07 çarpanında kalır. Kişi o gün su işinde değilse cümle sırada bir ağızdan duyulur; yaz değilse veya kişi ölmüşse satır 0'dır.
  - Kabul: Bir yaz su gününde satır 1'dir ve su tüketimi MEV-07 değeriyle aynıdır (`tests/unit/koy/yil_izi_test.gd`). Kişi su işinde değilken de satır 1'dir ve atama kaydı aynı kalır; yangın riski tablosu değişmez. Ek şart: susuzluk cezası YSM-02 değerinde kalır ve yaz satırı bar yazmaz.
  - Bağımlılık: YIL-01, MEV-07. Boyut: S.
  - Dosya: `data/soz/yil_izi.json` anahtarı `yaz_su`. `ANI-03` sırasına tek cümle.
  - Asset: asset gerekmedi.

### 30.6 Ad ve kapanış

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

### 30.7 Takvim sınırı

- [ ] **YIL-62:** Sabah defteri yıl raporunu yutmaz
  - Ne: Sabah defteri yıl raporunu yutmaz. SAB. Kapanış satırı ayrı.
  - Kabul: Sabah defteri yıl raporunu yutmaz. Kopya 0. Test: SAB-01.
  - Bağımlılık: SAB-01. Boyut: S.
  - Dosya: `src/koy/sabah_defteri.gd`
  - Asset: asset gerekmedi.

### 30.8 Kadraj

- [ ] **YIL-69:** Uzun cümle kayar
  - Ne: Uzun cümle kayar. Kesilen glif 0.
  - Kabul: Uzun cümle kayar. 0. Test: GRV-15.
  - Bağımlılık: GRV-15. Boyut: S.
  - Dosya: `src/arayuz/koy_ekrani.gd`
  - Asset: asset gerekmedi.
- [ ] **YIL-71:** Esc cümleyi ödül yapmaz
  - Ne: Esc cümleyi ödül yapmaz. Delta 0.
  - Kabul: Esc cümleyi ödül yapmaz. 0. Test: GIR-08.
  - Bağımlılık: GIR-08. Boyut: S.
  - Dosya: `src/arayuz/ana.gd`
  - Asset: asset gerekmedi.

### 30.9 Kayıt

- [ ] **YIL-81:** Ölçüm slot sayısını yazar
  - Ne: Ölçüm slot sayısını yazar. DEN. Formül değişmez.
  - Kabul: Ölçüm slot sayısını yazar. Satır 1. Test: DEN.
  - Bağımlılık: DEN-05. Boyut: S.
  - Dosya: `src/sistemler/denge_olcumu.gd`
  - Asset: asset gerekmedi.

Alt başlık ona tamamlandı. Eski gövde durur. Yeni kimlikler YIL-11 … YIL-90. Her alt başlığa sekiz yeni satır kondu.
