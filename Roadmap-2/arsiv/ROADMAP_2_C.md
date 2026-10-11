<!-- BOLUM_HAZIR -->
# Kapı Muhafızı — ROADMAP 2 / Parça C

Parça C: yazım, iş, yapı bilgisi, yaşam barı, dünya zamanı, sevilen yüz. Bu dosya bölündükten sonra A döngüsü tarafından değiştirilmez.

**Madde biçimi:** `- [ ] **ÖNEK-NN:** Başlık — amaç.` Altında: **Amaç**, **Kurallar**, **Uç durumlar**, **Kabul** (ölçülebilir test), **Bağımlılık**, **Boyut**, **Dosya**, **Asset**.

**Ortak kurallar:** yeni dosya + ince adaptör; çekirdekte minimal ekleme; `koy_sahnesi` / statik `KoyYerlesimi` yok; ajan asset üretmez ve indirmez, gereken asset satıra yazılır, yerine kutu veya düz renk konur. ROADMAP 1'de biten makine (salgın, mevsim, tüccar, divan mahkemesi, yozlaşma ağacı, bölge haritası, çift kasa, cenaze, gözcü kulesi, heybe ve ipucu motoru, tansiyon aralıkları, üretim zinciri) yeniden kurulmaz. Varsa adaptör yazılır.

Alınmayacaklar (ayrı sistem olmaz): kalp puanı, hediye takvimi, romans, seslendirme, ikinci harita.


İlke: oyun çalışırken yapay zekâ çağrılmaz. Metinler oyun dışında, dünya kitabına (RAG) dayanarak güçlü bir modelle yazılır, doğrulayıcıdan geçer, insan onayıyla veri olarak girer.

YAZ-01 … YAZ-10 gövdesi durur. Yeni maddeler YAZ-11 … YAZ-90. İkinci üslup belgesi ve ikinci doğrulayıcı yok.

### 19.1 Dünya kitabı

- [ ] **YAZ-01:** Dünya kitabı — dönem bilgisi.
  - Amaç: Dünya kitabı — dönem bilgisi.
  - Kurallar:
    1. `docs/dunya_kitabi/` altında konu başına bir dosya durur. Konu listesi şudur: tarih (Babai İsyanı 1240, Kösedağ 1243, sonrası Moğol tahakkümü), Selçuklu uç düzeni, Türkmen boyları ve göç, Bizans uç beyleri ve Rum köylüler, Ermeni ve Süryani toplulukları, Ahi teşkilatı, dervişler, ticaret yolları ve kervansaraylar, köy ekonomisi, meslekler, giyim, yemek, inanç ve yemin kalıpları, coğrafya (Sivas, Erzincan, Kayseri, Konya, Malatya). Bu 14 dosya kapanış sayısıdır.
    2. Her dosyada oyun metninin kullanacağı olgular ve bir `## Kaynaklar` listesi vardır. Kaynak satırı boş olan dosya onaylanmaz.
    3. Kitap, salgın, mevsim, tüccar, divan, yozlaşma, bölge haritası, çift kasa, cenaze veya üretim zinciri için ikinci bir kural yazmaz. Bu makineler `ROADMAP.md` içindedir; kitap yalnız onların dönem ağzını besler.
    4. Anlatı yönetmeni ve Ahmet onayı dosyanın sonunda iki isim olarak durur. Onaysız dosya YAZ-04 tarafından `data/soz/` altına alınmaz.
  - Uç durumlar: iki dosya aynı olguyu farklı yazarsa doğrulayıcı çifti listeler, oyuna ikisini birden sokmaz. Coğrafya dosyasında olmayan bir şehir adı karakter kartına yazılamaz. Kaynak uydurulmuşsa (künye yok) o satır yok hükmündedir.
  - Kabul: 14 konu dosyası durur; her birinde en az bir kaynak satırı ve iki isimlik onay vardır. Test: kaynak başlığı silinen bir dosya onay sayımında 13/14 kalır ve YAZ-04 onu üretmez.
  - Bağımlılık: yok. Boyut: L (içerik).
  - Dosya: yeni `docs/dunya_kitabi/*.md`.
  - Asset: asset gerekmedi.

- [ ] **YAZ-11:** Kitap dosyası on dört konudur
  - Ne: YAZ-01 listesi dışındaki on beşinci konu dosyası oyuna girmez.
  - Kabul: 15. dosya YAZ-04 tarafından kopyalanmaz. Test: sayım.
  - Bağımlılık: YAZ-01 Boyut: S.
  - Dosya: `docs/dunya_kitabi/`
  - Asset: asset gerekmedi.

- [ ] **YAZ-12:** Kaynaksız olgu satırı onaylanmaz
  - Ne: `## Kaynaklar` boşsa dosya 14'ten düşer.
  - Kabul: Boş kaynak 13/14. Test: YAZ-01.
  - Bağımlılık: YAZ-01 Boyut: S.
  - Dosya: `docs/dunya_kitabi/`
  - Asset: asset gerekmedi.

- [ ] **YAZ-13:** Kitap kural makinesi yazmaz
  - Ne: Salgın, mevsim, divan, üretim için ikinci kural cümlesi doğrulayıcıda hatadır.
  - Kabul: Kural cümlesi 1 hata. Test: tarama.
  - Bağımlılık: YAZ-01 Boyut: S.
  - Dosya: `docs/dunya_kitabi/`
  - Asset: asset gerekmedi.

- [ ] **YAZ-14:** İki dosya aynı olguyu çelişirse ikisi de girmez
  - Ne: İki dosya aynı olguyu çelişirse ikisi de girmez. Doğrulayıcı çifti listeler.
  - Kabul: Çift listede 2, oyunda 0. Test: fixtures.
  - Bağımlılık: YAZ-01. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.

- [ ] **YAZ-15:** Coğrafyada olmayan şehir kartta yazılmaz
  - Ne: Şehir adı coğrafya dosyasında yoksa karakter kartı reddedilir.
  - Kabul: Uydurma şehir 1 hata. Test: fixtures.
  - Bağımlılık: YAZ-01 Boyut: S.
  - Dosya: `docs/dunya_kitabi/`
  - Asset: asset gerekmedi.

- [ ] **YAZ-16:** Kitap çalışma anında okunmaz
  - Ne: Kitap çalışma anında okunmaz. `res://` altında `dunya_kitabi` 0.
  - Kabul: Export listesi 0. Test: KLT-22.
  - Bağımlılık: KLT-22. Boyut: S.
  - Dosya: `docs/dunya_kitabi/`
  - Asset: asset gerekmedi.

- [ ] **YAZ-17:** Onay iki isim ister
  - Ne: Onay iki isim ister. Tek imza YAZ-04'ü geçmez.
  - Kabul: Tek isim red. Test: KLT-02.
  - Bağımlılık: KLT-02. Boyut: S.
  - Dosya: `docs/dunya_kitabi/`
  - Asset: asset gerekmedi.

- [ ] **YAZ-18:** Kitap sürümü metin sürümünden ayrıdır
  - Ne: Kitap sürümü metin sürümünden ayrıdır. Oyun kaydı kitap sürümünü gömmez.
  - Kabul: Kayıtta kitap alanı 0. Test: tarama.
  - Bağımlılık: YAZ-01. Boyut: S.
  - Dosya: `docs/dunya_kitabi/`
  - Asset: asset gerekmedi.


### 19.2 Üslup

- [ ] **YAZ-02:** Üslup rehberi — dönem dili, yaşayan dil.
  - Amaç: Üslup rehberi — dönem dili, yaşayan dil.
  - Kurallar:
    1. `docs/dunya_kitabi/USLUP.md` şunları taşır: hitap sözcükleri (ağam, beğim, bacı, ahi baba, efendi, ana, kardaş), selamlaşma, yemin ve dua kalıpları, ağız farkları (Türkmen, Rum, Ahi, derviş, levent), yasak kelime listesi, selam ölçüsü (en çok 2 cümle; ilk cevaplar kısa).
    2. Yapay kalıplar ve halk ağzı yapıları USLUP §1–2'deki listedir: vecize karşıtlığı, üçlü sıra, gerekçe bağlacı, soruya tam oturan cevap, tekdüze ritim, güzel kapanış; karşılarında devrik cümle, aktarılan söz, soruya soru, dolgu söz, yarım bırakma, kendini düzeltme, yan cevap. Yeni kalıp bu listeden ayrı icat edilmez.
    3. Yasak kelimeler `data/soz/yasak_kelimeler.txt` içine dökülür. YAZ-07 bu dosyayı tarar. USLUP §7'deki 14 yapaylık kuralı uyarıdır, satırı silmez.
    4. Yazım sırası USLUP §6'dır: özet, sesli doğaçlama, biçime sokma, denetim, inceleme. Model "kim bu insan" paragrafını ve doğaçlamayı yazmaz.
    5. Bu belgedeki hitap sözcüğü, YAZ-09'daki `hitap` alanının adı değildir. Biri "ağam" demektir, öbürü kadronun tekrar görme türüdür.
  - Uç durumlar: Rum veya Ermeni ağıza zorla "selamün aleyküm" yazılırsa doğrulayıcı uyarı verir. Seslendirme satırı, fonetik satırı ve ses dosyası yolu bu belgede yer almaz. Replik ölçüsü aşılırsa satır hatadır, sahne tamamı değil.
  - Kabul: USLUP.md, taslaktaki 7 bölümü ve 14 yapaylık kuralını taşır; yasak liste dosyası en az USLUP §3'teki modern sözleri içerir. Test: listeye bilerek "aslında" konmuş bir replik YAZ-07'de 1 uyarı üretir; kural sayısı 14'tür.
  - Bağımlılık: YAZ-01. Boyut: M.
  - Dosya: yeni `docs/dunya_kitabi/USLUP.md`, `data/soz/yasak_kelimeler.txt`.
  - Asset: asset gerekmedi.

- [ ] **YAZ-19:** Üslup ikinci belge açmaz
  - Ne: `USLUP_REHBERI.md` tek gövdedir. İkinci üslup dosyası onaylanmaz.
  - Kabul: İkinci dosya 0. Test: sayım.
  - Bağımlılık: YAZ-02 Boyut: S.
  - Dosya: `Roadmap-2/USLUP_REHBERI.md`
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

- [ ] **YAZ-23:** Sesli doğaçlama oyuna girmez
  - Ne: Sesli doğaçlama oyuna girmez. Taslak notu `data/soz` altında durmaz.
  - Kabul: Taslak klasörü export'ta 0. Test: liste.
  - Bağımlılık: YAZ-02. Boyut: S.
  - Dosya: `docs/soz/`
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
  - Amaç: Karakter ses kartı — her karakter için.
  - Kurallar:
    1. Kart sayısı 30 CHR + 40 adlı karakterdir. Dosya başına bir kişi.
    2. İlk alan, insan eliyle yazılmış "kim bu insan" paragrafıdır. Model bu paragrafı üretmez. Paragraf boşsa kart doğrulamadan geçmez.
    3. Zorunlu alanlar: köken, ağız, konuşma alışkanlığı, yalan biçimi, korktuğu şey, istediği şey, `cekirdek` (YAZ-09), varsa sır ve nedeni, `baglar`. Alışkanlık sıfat cümlesi olamaz; örnek ölçü "soruya önce yarım cevap verir, sonra düzeltir".
    4. Yalan biçimi şu dörtten biridir: sapma, aşırı ayrıntı, soruya soru, susma. Sırrı olmayan çekirdekte sır alanı boş kalır, uydurma sır konmaz.
    5. Bağlar tek alandadır (`baglar`). İkinci bir ilişki listesi açılmaz. Hafıza ve dedikodu bu alanı okur (YAZ-09).
  - Uç durumlar: adsız sınıf şablonu bu 70 kartın içinde sayılmaz (onlar YAZ-06). Aynı alışkanlık cümlesi iki kartta tekrarlanırsa doğrulayıcı uyarı verir. Köken, YAZ-01 coğrafyasında yoksa kart hata alır.
  - Kabul: 70 kartın her birinde paragraf, dört yalan biçiminden biri ve bir çekirdek vardır. Test: paragrafı silinen kart 1 hata verir; 70 dışı bir eksik sayım raporda görünür. Taşınan kontroller: YAZ-29: Kart kalp alanı taşımaz (`kalp` 1 hata.).
  - Bağımlılık: YAZ-01. Boyut: L (içerik).
  - Dosya: yeni `data/soz/ses_kartlari/*.json`.
  - Asset: asset gerekmedi.


- [ ] **YAZ-30:** İki kart aynı ağzı tarif edemez
  - Ne: Kör okuma DYL-11 skoru kart onayından önce durur.
  - Kabul: Skorsuz kart red. Test: KLT-05.
  - Bağımlılık: DYL-11 Boyut: S.
  - Dosya: `docs/soz/kor_okuma.csv`
  - Asset: asset gerekmedi.

- [ ] **YAZ-31:** Kart meslek yasağını bilir
  - Ne: Eş kartında demirci, taşçı, asker yazılmaz. ACL-02 listesi.
  - Kabul: Yasak meslek 1 hata. Test: fixtures.
  - Bağımlılık: ACL-02 Boyut: S.
  - Dosya: `docs/soz/ses_kartlari/`
  - Asset: asset gerekmedi.

- [ ] **YAZ-32:** Adsızın kartı sınıf şablonudur
  - Ne: Adsızın kartı sınıf şablonudur. Kişi kartı açılmaz. KOP-10.
  - Kabul: Adsızda kişi kartı 0. Test: sayım.
  - Bağımlılık: KOP-10. Boyut: S.
  - Dosya: `docs/soz/ses_kartlari/`
  - Asset: asset gerekmedi.

- [ ] **YAZ-33:** Kart örnek cümle ister
  - Ne: Örnek satırı boş kart onaylanmaz. DYL-14.
  - Kabul: Boş örnek red. Test: KLT-14.
  - Bağımlılık: DYL-14 Boyut: S.
  - Dosya: `docs/soz/ses_kartlari/`
  - Asset: asset gerekmedi.

- [ ] **YAZ-34:** Kart oyun kaydına girmez
  - Ne: Kart yazar belgesidir. `kayit.json` içinde ses kartı 0.
  - Kabul: Alan 0. Test: tarama.
  - Bağımlılık: YAZ-03 Boyut: S.
  - Dosya: `docs/soz/ses_kartlari/`
  - Asset: asset gerekmedi.


### 19.4 Üretim kapısı

- [ ] **YAZ-04:** Yazım hattı — model istemi, üretim, doğrulama, onay.
  - Amaç: Yazım hattı — model istemi, üretim, doğrulama, onay.
  - Kurallar:
    1. `tools/soz_yazim/` istemi dört parçayı birden okur: dünya kitabı, üslup, ses kartı, şema. Biri eksikse araç çalışmaz.
    2. Araç çıktıyı şemaya çevirir ve inceleme raporu yazar: yasak kelime, uzunluk, selamdan önce hikâye, eksik konu, çelişki çifti.
    3. Onay imzası dosyada durur: kim, tarih. İmzasız çıktı `data/soz/` altına kopyalanmaz. Oyun imzasız dosyayı yüklemez.
    4. Oyun sürecinde bu araca çağrı yoktur. Araç bir seferlik üretim içindir.
  - Uç durumlar: raporunda hata duran dosya imzalanabilir ama kopya adımı reddeder. Aynı karaktere ikinci üretim, eskisinin imzasını silmeden yeni dosya açmaz; üzerine yazmadan önce rapor farkını gösterir.
  - Kabul: imzasız bir reçber çıktısı `data/soz/` altında 0 dosya bırakır; imzalı çıktı şema raporunda 0 hatayla durur. Test: istemden dünya kitabı yolu çıkarılınca araç 1 hatayla durur.
  - Bağımlılık: DIY-01, YAZ-02, YAZ-03. Boyut: M.
  - Dosya: yeni `tools/soz_yazim/*.py`, `tools/soz_yazim/istem.md`.
  - Asset: asset gerekmedi.

- [ ] **YAZ-35:** Üretim sırası HAT belgesindedir
  - Ne: Kitap, taslak, yapaylık, kör okuma, kota, iki isim, `data/soz`. Atlanan adım kopyalanmaz.
  - Kabul: Atlanan adım 0 kopya. Test: KLT-01.
  - Bağımlılık: KLT-01 Boyut: S.
  - Dosya: `docs/soz/HAT.md`
  - Asset: asset gerekmedi.

- [ ] **YAZ-36:** Model istemi oyuna gömülmez
  - Ne: Model istemi oyuna gömülmez. İstem metni `res://` altında 0.
  - Kabul: Model istemi oyuna gömülmez. Export 0. Test: liste.
  - Bağımlılık: YAZ-04. Boyut: S.
  - Dosya: `docs/soz/`
  - Asset: asset gerekmedi.

- [ ] **YAZ-37:** Doğrulayıcı kapısı `soz_kapi.py`dir
  - Ne: Doğrulayıcı kapısı `soz_kapi.py`dir. İkinci doğrulayıcı yazılmaz.
  - Kabul: Araç sayısı 1. Test: sayım.
  - Bağımlılık: KLT-04. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.

- [ ] **YAZ-38:** İnsan onayı olmadan kopya yoktur
  - Ne: İnsan onayı olmadan kopya yoktur. İmzasız dosya `data/soz` altında 0.
  - Kabul: İnsan onayı olmadan kopya yoktur. İmzasız 0. Test: kapı.
  - Bağımlılık: YAZ-04. Boyut: S.
  - Dosya: `data/soz/`
  - Asset: asset gerekmedi.

- [ ] **YAZ-39:** Eski diyalog taşınmaz
  - Ne: DIY-16. Yan yana bakış DYL-13 kaydı olmadan 'taşındı' yazılmaz.
  - Kabul: Kayıtsız id hazır değil. Test: KLT-13.
  - Bağımlılık: DIY-16 Boyut: S.
  - Dosya: `docs/soz/HAT.md`
  - Asset: asset gerekmedi.

- [ ] **YAZ-40:** Üretim çalışma anında çalışmaz
  - Ne: Üretim çalışma anında çalışmaz. Oyun içi istem düğmesi 0.
  - Kabul: Üretim çalışma anında çalışmaz. Düğme 0. Test: KLT-23.
  - Bağımlılık: KLT-23. Boyut: S.
  - Dosya: `src/`
  - Asset: asset gerekmedi.

- [ ] **YAZ-41:** Hatalı dosya komşusunu düşürmez
  - Ne: Bir karakter reddedilince diğerleri kalır.
  - Kabul: Komşu dosya durur. Test: iki dosya.
  - Bağımlılık: YAZ-04 Boyut: S.
  - Dosya: `data/soz/`
  - Asset: asset gerekmedi.


### 19.5 Pilot

- [ ] **YAZ-05:** Pilot: Sivaslı reçber ve iki karakter daha.
  - Amaç: Pilot: Sivaslı reçber ve iki karakter daha.
  - Kurallar:
    1. Üç kişi: Sivaslı reçber, bir tehlikeli CHR (`cekirdek: tehlikeli_yalan`), bir adlı karakter.
    2. Şema tamdır: varış ve karar her sahnede vardır. Selam, yedi konu, sır evresi ve ikilem üç sahneye birden dayatılmaz. Reçber konu merkezli kalabilir; öbür iki sahne OZGUNLUK §4'ten, birbirinden farklı biçimdedir.
    3. Sır evresi yalnız çekirdeği bunu isteyen sahnededir. Pilot dosyalarının en çok birinde sır düğümü vardır.
    4. Üç dosyanın toplamında en az bir hafıza varyantı, bir mevsim veya kriz varyantı ve en az iki çelişki çifti vardır. Hepsi reçberde toplanabilir.
    5. Ahmet onay satırı yazılmadan YAZ-06 dalgası başlamaz.
  - Uç durumlar: üç sahne aynı açılış cümlesiyle başlarsa pilot tamam sayılmaz (ortak selam kalıbı "Selamün aleyküm" bu yasağın dışındadır). Onaysız dosya diskte durabilir, oyun onu yüklemez.
  - Kabul: üç dosya şema hatasızdır; en az iki sahne biçimi kullanılır; sır düğümü en çok bir dosyadadır. Test: sır düğümü iki dosyada birden duruyorsa pilot kontrolü 1 hata verir. Onay satırı yokken başlatılan YAZ-06 dalgası 0 karakter yazar.
  - Bağımlılık: YAZ-04, DIY-02…DIY-11. Boyut: M.
  - Dosya: `data/soz/recber.json` ve iki pilot dosyası.
  - Asset: asset gerekmedi.

- [ ] **YAZ-43:** Pilot üç ağızla sınırlıdır
  - Ne: Sivaslı reçber ve iki karakter. Dördüncü pilot dosyası toplu yazıma karışmaz.
  - Kabul: Pilot klasöründe dosya 3. Test: sayım.
  - Bağımlılık: YAZ-05 Boyut: S.
  - Dosya: `data/soz/`
  - Asset: asset gerekmedi.

- [ ] **YAZ-44:** Pilot kota hesabına girer
  - Ne: YAZ-09 yüzdeleri pilotu da sayar. Ayrı kota yok.
  - Kabul: Pilot hariç yüzde 0. Test: rapor.
  - Bağımlılık: YAZ-09 Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.

- [ ] **YAZ-45:** Pilot kapı fixtures'ına bağlanır
  - Ne: Pilot kapı fixtures'ına bağlanır. Üç id DYL-16 `--check` listesindedir.
  - Kabul: Üç id fark 0. Test: DYL-16.
  - Bağımlılık: DYL-16. Boyut: S.
  - Dosya: `data/soz/`
  - Asset: asset gerekmedi.

- [ ] **YAZ-46:** Pilot şehir adı coğrafyadadır
  - Ne: Sivas coğrafya dosyasında yoksa pilot onaylanmaz.
  - Kabul: Eksik şehir red. Test: YAZ-01.
  - Bağımlılık: YAZ-01 Boyut: S.
  - Dosya: `docs/dunya_kitabi/`
  - Asset: asset gerekmedi.

- [ ] **YAZ-47:** Pilot sır içermez
  - Ne: Pilot sır içermez. Üç dosyada zorunlu `sira` 0.
  - Kabul: Alan 1 hata. Test: KLT-03.
  - Bağımlılık: DIY-01a. Boyut: S.
  - Dosya: `data/soz/`
  - Asset: asset gerekmedi.

- [ ] **YAZ-48:** Pilot ses dosyası taşımaz
  - Ne: Pilot ses dosyası taşımaz. Wav sayısı 0.
  - Kabul: Pilot ses dosyası taşımaz. Sayım 0. Test: sayım.
  - Bağımlılık: YAZ-05. Boyut: S.
  - Dosya: `data/soz/`
  - Asset: asset gerekmedi.

- [ ] **YAZ-49:** Pilot köy sohbeti açmaz
  - Ne: YAZ-08 bu üçüne özel ikinci sahne yazmaz.
  - Kabul: Ayrı sahne 0. Test: tarama.
  - Bağımlılık: YAZ-08 Boyut: S.
  - Dosya: `data/soz/`
  - Asset: asset gerekmedi.


### 19.6 Toplu yazım

- [ ] **YAZ-06:** Toplu yeniden yazım — 30 CHR, 40 adlı karakter, adsız şablonlar.
  - Amaç: Toplu yeniden yazım — 30 CHR, 40 adlı karakter, adsız şablonlar.
  - Kurallar:
    1. Dalga boyu 10 kişidir. Dalga, doğrulayıcı 0 hata ve insan onayı olmadan kapanmaz. Sonraki dalga öncekinin kapanışını bekler.
    2. 30 CHR ve 40 adlı karakter YAZ-03 kartlarına birebir karşılık gelir. Kartı olmayan kişi üretilmez.
    3. Adsız gelenler 70 kişinin dışındadır, yedi dalgaya sayılmaz. Sınıf başına en az 4 kişilik şablonu vardır. Aynı sınıftan iki kişi aynı şablon kimliğini taşımaz.
    4. Rapor, karakter başına düğüm, konu, çelişki ve ikilem sayısını yazar. Sır düğümü olmayan kişi raporda 0 sır olarak durur; bu bir hata değildir.
    5. Eski `SohbetVerisi` ve `diyalog_01_20.json` metinleri bu dalgaya kopyalanmaz (DIY-16).
  - Uç durumlar: dalga ortasında bir kartın çekirdeği değişirse o kişinin dosyası dalgadan düşer, yeniden onay bekler. Adsız havuzu 4 şablondan az bir sınıfla açılırsa o sınıfın üretimi durur, diğer sınıflar sürer.
  - Kabul: yedi dalga sonunda 70 adlı/CHR dosyası imzalıdır ve rapor satır sayısı 70'tir. Test: aynı şablon kimliğini paylaşan iki adsız dosya doğrulayıcıda 1 hata verir.
  - Bağımlılık: YAZ-05. Boyut: L (içerik).
  - Dosya: `data/soz/*.json`.
  - Asset: asset gerekmedi.

- [ ] **YAZ-51:** Toplu yazım kadro listesini okur
  - Ne: 30 CHR ve 40 adlı. Listede olmayan id üretilmez.
  - Kabul: Liste dışı 0 dosya. Test: sayım.
  - Bağımlılık: YAZ-06 Boyut: S.
  - Dosya: `data/soz/`
  - Asset: asset gerekmedi.

- [ ] **YAZ-52:** Adsız şablon kişi dosyası değildir
  - Ne: Adsız şablon kişi dosyası değildir. Şablon sayısı sınıf sayısıdır. KOP-10.
  - Kabul: Şablon kişiye kopyalanırsa 1 hata. Test: kapı.
  - Bağımlılık: KOP-10. Boyut: S.
  - Dosya: `data/soz/`
  - Asset: asset gerekmedi.

- [ ] **YAZ-53:** Toplu yazım eski satırı silmez
  - Ne: Eski anahtar CSV'de kalır, yeni anahtar eklenir. SYS-09 silme yasağı.
  - Kabul: Silinen anahtar 0. Test: diff.
  - Bağımlılık: SYS-09 Boyut: S.
  - Dosya: `data/metin/metinler.csv`
  - Asset: asset gerekmedi.

- [ ] **YAZ-54:** Her dosya bir ses kartına bağlıdır
  - Ne: Her dosya bir ses kartına bağlıdır. Kartsız toplu dosya reddedilir.
  - Kabul: Her dosya bir ses kartına bağlıdır. Kartsız 0. Test: kapı.
  - Bağımlılık: YAZ-03. Boyut: S.
  - Dosya: `data/soz/`
  - Asset: asset gerekmedi.

- [ ] **YAZ-55:** Toplu yazım kotayı aşamaz
  - Ne: Sır, dinleyici, dedikodu yüzdeleri YAZ-09. Aşım red.
  - Kabul: Aşım 1 hata. Test: KLT-06.
  - Bağımlılık: YAZ-09 Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.


- [ ] **YAZ-58:** Toplu yazım bir gecede oyuna girmez
  - Ne: Onaylı paket tek seferde kopyalanır, yarım klasör yüklenmez.
  - Kabul: Yarım klasör 0 yükleme. Test: kapı.
  - Bağımlılık: YAZ-06 Boyut: S.
  - Dosya: `data/soz/`
  - Asset: asset gerekmedi.


### 19.7 Doğrulama ve köy sohbeti

- [ ] **YAZ-07:** Söz doğrulayıcı ve önizleme aracı.
  - Amaç: Söz doğrulayıcı ve önizleme aracı.
  - Kurallar:
    1. `tools/soz_dogrula.py` sanity paketine tek satırla girer. Hata sayılanlar: şema, kopuk düğüm, ulaşılamayan dal, eksik metin anahtarı, selam kuralı, tek şanslık kontrolün birden çok yerde durması.
    2. Yasak kelime ve USLUP §7'deki 14 yapaylık kuralı uyarıdır. Uyarı sanity'yi kırmaz. Kararı insan verir.
    3. Oyun içi önizleyici ADM panelinden açılır: karakter seçilir, bağlam kurulur (mevsim, kriz, tansiyon, hafıza), ağaç yürütülür. Önizleme `son_karar`, kasa, nüfus ve kayıt dosyasına yazmaz.
    4. ADM paneline tek düğme eklenir. İkinci bir diyalog debug ekranı açılmaz.
  - Uç durumlar: yapaylık uyarısı olan sahne sanity'de geçer, YAZ-10 onayı onu ayrıca bekletir. Önizlemede atılan zar kayıtlı zar değeridir; canlı oyun zarını tüketmez.
  - Kabul: kopuk düğümlü bir örnek dosya sanity'de 1 hata verir; 14 yapaylık kuralından birini kıran satır 1 uyarı verir ve sanity hatası 0 kalır. Test: önizleme koşusundan sonra kayıt dosyasının `son_karar` alanı değişmez.
  - Bağımlılık: DIY-01. Boyut: M.
  - Dosya: yeni `tools/soz_dogrula.py`, `src/debug/soz_onizleme.gd`; `tools/sanity_check.py` tek satır; ADM paneline tek düğme.
  - Asset: asset gerekmedi.

- [ ] **YAZ-59:** Doğrulayıcı önizlemesi oyun içi değildir
  - Ne: YAZ-07 aracı `tools/` altındadır. Oyuncu menüsünde önizleme 0.
  - Kabul: Menü düğmesi 0. Test: tarama.
  - Bağımlılık: YAZ-07 Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.


- [ ] **YAZ-61:** Önizleme metni CSV'den gelir
  - Ne: Düz cümle araç çıktısında anahtarın çevirisidir.
  - Kabul: Düz gömülü cümle 0. Test: tarama.
  - Bağımlılık: SYS-09 Boyut: S.
  - Dosya: `data/metin/metinler.csv`
  - Asset: asset gerekmedi.

- [ ] **YAZ-62:** Önizleme kayıt yazmaz
  - Ne: Önizleme kayıt yazmaz. Araç `user://kayit.json` açmaz.
  - Kabul: Önizleme kayıt yazmaz. Yazım 0. Test: tarama.
  - Bağımlılık: YAZ-07. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.

- [ ] **YAZ-63:** Köy sohbeti kapı dosyasını kopyalamaz
  - Ne: YAZ-08 kendi düğümleridir. Kapı düğümü köyde tekrar basılmaz.
  - Kabul: Aynı düğüm id köyde 0. Test: tarama.
  - Bağımlılık: YAZ-08 Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **YAZ-64:** Köy sohbeti günde bir konudur
  - Ne: Köy sohbeti günde bir konudur. İki konu aynı günde açılmaz.
  - Kabul: İkinci konu 0. Test: birim.
  - Bağımlılık: YAZ-08. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **YAZ-65:** Köy sohbeti söylentiyi okur
  - Ne: SOY-46. İkinci dedikodu cümlesi üretilmez.
  - Kabul: Konu varsa iki ağız farklı. Test: SOY-46.
  - Bağımlılık: SOY-46 Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **YAZ-66:** Köy sohbeti sahne açmaz
  - Ne: 3B sohbet sahnesi 0. Metin kadrajı duran paneldir.
  - Kabul: `sohbet_sahnesi` 0. Test: tarama.
  - Bağımlılık: YAZ-08 Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.


### 19.8 Kota ve inceleme

- [ ] **YAZ-08:** Köy içi sohbetler — köylüler de konuşur.
  - Amaç: Köy içi sohbetler — köylüler de konuşur.
  - Kurallar:
    1. Konuşma köylü kartından açılır. Yeni bir sohbet haritası veya ikinci sahne yoktur.
    2. Konu başlıkları dörttür: iş, aile, dert, dedikodu. Her CHR için en az 3 köy satırı vardır.
    3. Satır, kapı hafızasını okur (`son_karar`, verilen söz, yüzleşilen yalan). Ret yemiş ve köyde durmayan kişinin köy satırı yoktur.
    4. Dedikodu satırı DIY-13 kaydına yazar. Fısıltı gazetesi bu kaydı okur; sohbet kendi haberini uydurmaz.
  - Uç durumlar: ölen kişinin satırı SEV-07 ile kapanır. Eşin akşam sohbeti (ACL-03) gece raporu öncesinde kalır; köy kartındaki dört başlık onun yerine geçmez. Çocuk çalışmadığı için iş başlığı boş kalır (UZM-08); boş başlık sohbeti kırmaz.
  - Kabul: köydeki bir CHR kartından 3 satır açılır ve kapıdaki ret/kabul hafızasına göre selam değişir. Test: köyde olmayan CHR için satır sayısı 0; dedikodu satırı fısıltıya tanıksız yazılmaz. Taşınan kontroller: YAZ-86: Köy sahnesi import edilmez (Import 0.).
  - Bağımlılık: YAZ-06, DIY-13. Boyut: M.
  - Dosya: yeni `src/arayuz/koy_hud/koylu_sohbeti.gd`.
  - Asset: asset gerekmedi.

- [ ] **YAZ-67:** Çekirdek kotası kadroya yazılır
  - Ne: YAZ-09. Herkese sır yazılmaz. %100 sır red.
  - Kabul: %100 1 hata. Test: KLT-20.
  - Bağımlılık: YAZ-09 Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.

- [ ] **YAZ-68:** Dinleyici kotası ayrıdır
  - Ne: Dinleyici çekirdeği sır kotasına sayılmaz.
  - Kabul: Karışık sütun 0. Test: rapor.
  - Bağımlılık: YAZ-09 Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.


- [ ] **YAZ-70:** Kota raporu turda bir satırdır
  - Ne: Kota raporu turda bir satırdır. İkinci rapor yok.
  - Kabul: Kota raporu turda bir satırdır. Satır 1. Test: KLT-18.
  - Bağımlılık: KLT-18. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.

- [ ] **YAZ-71:** İnceleme modu satır seçer
  - Ne: YAZ-10 kapsam taraması dosyadaki her satırı bir kez okur. Atlanan satır 1 hata.
  - Kabul: Atlanan 1. Test: sayım.
  - Bağımlılık: YAZ-10 Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.

- [ ] **YAZ-72:** İnceleme oyunu durdurmaz
  - Ne: İnceleme oyunu durdurmaz. Araç oyun sürecine bağlanmaz.
  - Kabul: Oyun süreci 0. Test: tarama.
  - Bağımlılık: YAZ-10. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.

- [ ] **YAZ-73:** İnceleme yasak listesini USLUP'tan okur
  - Ne: İnceleme yasak listesini USLUP'tan okur. Kopya liste 0.
  - Kabul: Liste dosyası 1. Test: tarama.
  - Bağımlılık: YAZ-02. Boyut: S.
  - Dosya: `Roadmap-2/USLUP_REHBERI.md`
  - Asset: asset gerekmedi.

- [ ] **YAZ-74:** İnceleme sonucu kapıya yazılır
  - Ne: HAT.md kutusu. Yazılmadan dosya hazır sayılmaz.
  - Kabul: Kutusuz red. Test: KLT-01.
  - Bağımlılık: KLT-01 Boyut: S.
  - Dosya: `docs/soz/HAT.md`
  - Asset: asset gerekmedi.


### 19.9 Anahtar ve CSV

- [ ] **YAZ-09:** Hikâye çekirdekleri ve kadro özgünlük denetimi.
  - Amaç: Hikâye çekirdekleri ve kadro özgünlük denetimi.
  - Kurallar:
    1. `Roadmap-2/OZGUNLUK.md` esastır. Zorunlu evre yalnız varış ve karardır. `cekirdek` alanı zorunludur. Çekirdek sır değilse heybe ipucu şartı yoktur (DIY-01a).
    2. Çekirdek değerleri: dürüst, koruma yalanı, yanlış anlaşılma, bilmediği, abartma, başkasının sırrı, pazarlık, itiraf etmek isteyen, dinlenmek isteyen, tehlikeli yalan, hafif. Kota: dürüst + dinlenmek isteyen yaklaşık %40; başka hiçbir çekirdek %15'i geçmez. Tek sahne biçimi %30'u geçmez. Kadronun yarısından fazlası sır evresi kullanıyorsa uyarı çıkar. Dört benzersizlik ekseninde aynı iki karakter uyarıdır.
    3. `hitap` ayrı bir sistem değildir. Kişinin neden tekrar görülesi olduğunu söyler. Değerler: `saygi`, `sefkat`, `aliskanlik`, `agirlik`, `gulus`. USLUP'taki "ağam / beğim" sözcükleri bu alan değildir.
    4. Beş türün her biri en az bir adlı kişide bulunur. `aliskanlik` 2 veya 3 kişidir; SEV-02'nin zararsız, tekrar gelen yüzleri bunlardır. Tür puan tutmaz. Kadro dosyasında kalp puanı, hediye takvimi, romans metni veya seslendirme anahtarı varsa doğrulayıcı hata verir. Tür, kabul veya ret zarını değiştirmez.
    5. Türlerin anlamı yazım notudur. Saygı: sözü dinlenen kişi, kısa iş cümlesi. Şefkat: birine bakan veya birini kaybetmiş kişi, hal sorma. Alışkanlık: zararsız ve yine gelen. Ağırlık: oyuncunun kararı bu yüzde durur; ODA-09 vicdan kabusu yeniden yazılmaz. Gülüş: kapıyı hafifleten ağız; çekirdekle aynı alan değildir, `hafif` olmak zorunda değildir.
    6. `baglar` hafıza (DIY-11) ve dedikoduya (DIY-13) bağlanır. Yeni ilişki ekranı yoktur.
  - Uç durumlar: adsız şablonun `hitap` değeri yoktur; kota adlı kadroyu sayar. Yazar uyarıya gerekçe notu düşerse o uyarı geçilir, hata geçilmez. Kalp veya hediye anahtarı gerekçeyle de geçmez. Bir kişi hem sır çekirdeği hem gülüş taşıyabilir; sır kotası bundan ayrı sayılır.
  - Kabul: `tools/soz_kadro_denetimi.py` örnek kadroda çekirdek kotasını, beş türün varlığını ve `aliskanlik` sayısının 2–3 bandını doğru sayar. Test: bir tür silinince 1 uyarı; `kalp` veya `hediye` anahtarı konunca 1 hata; gerekçe notu çekirdek uyarısını düşürür, hata anahtarını düşürmez. Taşınan kontroller: DYL-88: Eylem kalp yazmaz (Hata 1.); YAZ-85: Kalp ve hediye alanı reddedilir (Alan 1 hata.).
  - Bağımlılık: YAZ-03, YAZ-07, DIY-01a. Boyut: M.
  - Dosya: yeni `tools/soz_kadro_denetimi.py`; `data/soz/kadro.json`.
  - Asset: asset gerekmedi.

- [ ] **YAZ-75:** Anahtar biçimi standarttır
  - Ne: Noktalı küçük harf. YER-02. İkinci standart yok.
  - Kabul: Biçimsiz 1 hata. Test: metin_dogrula.
  - Bağımlılık: YER-02 Boyut: S.
  - Dosya: `tools/metin_dogrula.py`
  - Asset: asset gerekmedi.

- [ ] **YAZ-76:** Yer tutucu sayısı kodla eşittir
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

- [ ] **YAZ-78:** Çift boşluk diyalog satırında da aranır
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

- [ ] **YAZ-80:** CHR anahtar biçimi korunur
  - Ne: `CHR_XXX_DUGUM_YY` standardı. Yeni biçim reddedilir.
  - Kabul: Yeni biçim 1 hata. Test: standart.
  - Bağımlılık: SYS-09 Boyut: S.
  - Dosya: `docs/METIN_ANAHTAR_STANDARDI.md`
  - Asset: asset gerekmedi.

- [ ] **YAZ-81:** Yetim anahtar silinmeden belgelenir
  - Ne: Kullanılmayan anahtar listeye yazılır, CSV'den bu maddede silinmez.
  - Kabul: Silinen 0, liste 1. Test: diff.
  - Bağımlılık: SYS-09 Boyut: S.
  - Dosya: `data/metin/metinler.csv`
  - Asset: asset gerekmedi.


### 19.10 Sınır ve kapanış

- [ ] **YAZ-10:** İnceleme modu ve kapsam taraması.
  - Amaç: İnceleme modu ve kapsam taraması.
  - Kurallar:
    1. Önizlemede her satır üç işaretten birini alır: doğal, yapay, yeniden yaz. İşaretler JSON olarak dışa ve içe aktarılır.
    2. Metin değişince o satırın işareti "metin değişti" olur. Eski doğal işareti sessizce kalmaz.
    3. Kapsam taraması (`soz_dogrula.py --kapsam`) kayıtlı bağlam tohumlarıyla ağacı yürütür. Hiç seçilmeyen satırı ve ulaşılmayan düğümü listeler. Bu tarama oyuncunun karşısına çıkmaz.
    4. Sahne, yapay ve yeniden yaz işareti 0 iken ve kapsamda görünmeyen satır 0 iken onaya gider.
  - Uç durumlar: kapsam tohumu boşsa tarama "çalışmadı" der, sahneyi onaylı saymaz. İşaret dosyası sahne dosyasından ayrıdır; sahne silinince işaretler kimlikle eşleşmeyeni listeler, sessizce yok olmaz.
  - Kabul: bir satır yapay işaretliyken onay adımı reddedilir. Test: metin değiştirilince işaret "metin değişti" olur; 1000 tohumluk taramada ulaşılmayan bir düğüm listede 1 satırdır. Prototip karşılığı `Roadmap-2/soz_agaci` İnceleme ve Şablon sekmeleridir.
  - Bağımlılık: YAZ-07. Boyut: S.
  - Dosya: `src/debug/soz_onizleme.gd`; `tools/soz_dogrula.py --kapsam`.
  - Asset: asset gerekmedi.

- [ ] **YAZ-83:** Söz dosyası ikinci motor açmaz
  - Ne: Söz dosyası ikinci motor açmaz. YAZ içeriği DIY-02 motoruna girer.
  - Kabul: Yeni sınıf 0. Test: tarama.
  - Bağımlılık: DIY-02. Boyut: S.
  - Dosya: `data/soz/`
  - Asset: asset gerekmedi.

- [ ] **YAZ-84:** Ses dosyası eklenmez
  - Ne: Ses dosyası eklenmez. Bu bölüm wav üretmez.
  - Kabul: Ses dosyası eklenmez. Sayı aynı. Test: sayım.
  - Bağımlılık: YAZ-02. Boyut: S.
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
  - Kabul: Açılış çökmez. Test: KAY.
  - Bağımlılık: KAY-04 Boyut: S.
  - Dosya: `src/sistemler/kayit_gocu.gd`
  - Asset: asset gerekmedi.

- [ ] **YAZ-90:** Kapanış beş iddiayı koşar
  - Ne: Kitap 14, pilotsuz toplu kopya 0, kota aşımı red, düz cümle 0, çalışma anında istem 0.
  - Kabul: Beş iddia. Test: `tests/tools/test_soz_kapi.py`.
  - Bağımlılık: YAZ-01 Boyut: M.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.


ISG-01 … ISG-03 gövdesi durur. Yeni maddeler ISG-04 … ISG-83. İkinci meslek ağacı yok.

### 20.1 Kabul uyarısı

- [ ] **ISG-01:** Kabul anında meslek uyarısı.
  - Amaç: Kabul anında meslek uyarısı.
  - Kurallar:
    1. Uyarı karar panelindedir. Metin kalıbı: "Kumaşçı — dokuma tezgâhı yok. Nitelikli iş verilemez; günde 1 erzak yer, geçici işte %X verimle çalışır." Meslek ve bina adları `data/meslek_binalari.json` eşlemesinden gelir.
    2. "Günde 1 erzak" EKO-09 tüketimidir. Bu madde ikinci bir yeme bedeli yazmaz.
    3. "%X" ISG-02 tablosundaki geçici iş verimidir. UZM-03 bina–meslek çarpanı durur; uyarı o çarpanı değiştirmez.
    4. Bina köyde varsa uyarı satırı çıkmaz. Mesleği olmayan kişide satır çıkmaz.
  - Uç durumlar: birden çok mesleği olan kişide uyarı, eksik olan her bina için bir satırdır, en fazla eşleme dosyasındaki kadar. Eş (ACL-02) kendi meslek listesindedir; listede olmayan meslek ona yazılmaz. Bina inşa halindeyse uyarı "bina yok" sayılır, bitince satır kalkar.
  - Kabul: atölyesiz köyde kumaşçı kabul panelinde 1 uyarı vardır; aynı köye dokuma tezgâhı konunca uyarı 0'dır. Test: erzak tüketimi uyarı açıkken de kapalıyken de gece başına 1 kalır. Taşınan kontroller: ISG-68: Yasak sahne yoktur (Import 0.); ISG-70: Kalp yoktur (Hata.); ISG-71: Ses yoktur (Sayı aynı.).
  - Bağımlılık: yok. Boyut: S.
  - Dosya: yeni `src/kapi/meslek_uyarisi.gd`; meslek→bina eşlemesi `data/meslek_binalari.json`.
  - Asset: asset gerekmedi.


- [ ] **ISG-05:** Uyarı meslek listesini okur
  - Ne: Liste `meslek_yapilari`. Uydurma meslek 0.
  - Kabul: 0. Test: tarama.
  - Bağımlılık: ISG-01 Boyut: S.
  - Dosya: `src/koy/meslek_yapilari.gd`
  - Asset: asset gerekmedi.


- [ ] **ISG-07:** Eş uyarısı kapı kabulü değildir
  - Ne: Eş uyarısı kapı kabulü değildir. Eş zaten içeride.
  - Kabul: Uyarı 0 eşe. Test: ACL-02.
  - Bağımlılık: ACL-02. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.


- [ ] **ISG-09:** Uyarı kabulü engellemez
  - Ne: Uyarı kabulü engellemez. Oyuncu yine alır.
  - Kabul: Kabul açık. Test: birim.
  - Bağımlılık: ISG-01. Boyut: S.
  - Dosya: `src/arayuz/kapi_ekrani.gd`
  - Asset: asset gerekmedi.


- [ ] **ISG-11:** Uyarı kayda düşmez
  - Ne: Her kabulde yeniden hesap. Eski uyarı alanı yok.
  - Kabul: Alan 0. Test: tarama.
  - Bağımlılık: ISG-01 Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.


### 20.2 Geçici iş

- [ ] **ISG-02:** Geçici işler havuzu — boştakilere iş.
  - Amaç: Geçici işler havuzu — boştakilere iş.
  - Kurallar:
    1. İş listesi `data/gecici_isler.json` içindedir: taş toplama (BUG-21 taş yatağı), çalı ve dal toplama (odun), su taşıma, hendek ve yol açma (mevcut inşaat hızına artı), inşaat yardımcılığı, gece bekçisine eşlik (mevcut güvenlik hesabına artı, yorgunluğa artı), yün eğirme (evde; uygun olan kadın veya yaşlı), ot ve mantar toplama (mevsimlik erzak), çocuk ve hasta bakımı.
    2. Her işin verimi ve yorgunluğu yalnız bu dosyadadır. Kodda sabit verim sayısı yoktur.
    3. Köylü kartında "Geçici işler" sekmesi vardır. Atama gece bilançosuna iş kimliğiyle ayrı satır yazar.
    4. Bu liste EKO-02…06 zincirini, ANI-03 su rutinini ve KRI-15 afyon toplamayı yeniden kurmaz. Ot ve mantar erzak yazar, afyon yazmaz. Taş toplama taş ocağı kurmaz.
  - Uç durumlar: çocuk ağır işe yazılmaz (UZM-08). Taş yatağı 0 ise taş toplama kapalıdır; diğer işler sürer. Mevsim ot vermiyorsa o iş 0 erzak yazar, hata vermez. Kişi aynı gece hem bina işinde hem geçici işte sayılmaz.
  - Kabul: listedeki her iş, bir gece koşusunda bilançoda kendi kimliğiyle bir satır üretir. Test: ot satırı afyon stokunu değiştirmez; taş yatağı 0 iken taş satırı 0'dır. Taşınan kontroller: ISG-72: Hediye ile iş açılmaz (0.).
  - Bağımlılık: BUG-21, YSM-01. Boyut: M.
  - Dosya: yeni `src/koy/gecici_isler.gd`; köylü kartına adaptör.
  - Asset: işlere özel el aleti envantere `ISG02-ALETLER`; yer tutucu ANI-11 kutu soketi.

- [ ] **ISG-12:** Geçici iş havuzu ISG-02'dir
  - Ne: Geçici iş havuzu ISG-02'dir. Boştaki yetişkin. Çocuk yok.
  - Kabul: Geçici iş havuzu ISG-02'dir. Çocuk 0. Test: ISG-02.
  - Bağımlılık: ISG-02. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **ISG-13:** Havuz bina ister
  - Ne: Havuz bina ister. Bina yoksa iş yok. BUG-16.
  - Kabul: Havuz bina ister. İş 0. Test: BUG-16.
  - Bağımlılık: BUG-16. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **ISG-14:** Aynı kişi iki işe yazılmaz
  - Ne: Aynı kişi iki işe yazılmaz. İkinci atama 0.
  - Kabul: Aynı kişi iki işe yazılmaz. 0. Test: birim.
  - Bağımlılık: ISG-02. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **ISG-15:** Yaralı geçici işe yazılmaz
  - Ne: Yaralı geçici işe yazılmaz. CAT yarası.
  - Kabul: Yaralı geçici işe yazılmaz. Atama 0. Test: CAT-03.
  - Bağımlılık: CAT-03. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **ISG-16:** Nöbetçi geçici işe yazılmaz
  - Ne: Nöbetçi geçici işe yazılmaz. NBT aynı gece.
  - Kabul: Nöbetçi geçici işe yazılmaz. Atama 0. Test: NBT-01.
  - Bağımlılık: NBT-01. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.


- [ ] **ISG-18:** Havuz sırası kayda gömülmez
  - Ne: Havuz sırası kayda gömülmez. Her sabah yeniden.
  - Kabul: Havuz sırası kayda gömülmez. Alan 0. Test: tarama.
  - Bağımlılık: ISG-02. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.


### 20.3 Boşta bedel

- [ ] **ISG-03:** Boşta kalma bedeli ve görünürlüğü.
  - Amaç: Boşta kalma bedeli ve görünürlüğü.
  - Kurallar:
    1. HUD satırı "Boşta: N kişi"dir. N, o gün binada ve geçici işte olmayan yetişkinleri sayar.
    2. Boşta kalanın morali UZM-06 memnuniyetinden düşer. İkinci bir moral sayacı açılmaz. Düşüş miktarı veri dosyasındadır.
    3. Mesleği olan kişi 3 gün üst üste boşta kalırsa YAZ-08 sohbetinde terk cümlesi açılır. Cümle bir istektir; o gece kişiyi köyden silmez.
    4. Geçici işe veya binaya yazılınca sayaç o kişi için 0'a döner.
  - Uç durumlar: mesleksiz kişide terk cümlesi açılmaz. Çocuk ve eş sayaçta meslekli sayılmaz. Kişi 2. gün işe girerse 3. gün cümlesi yoktur. Hasta veya karantinadaki kişi boşta sayılmaz.
  - Kabul: 3 tam boş günün sonunda o kişinin köy sohbetinde 1 terk satırı vardır. Test: 2. gün geçici işe alınan kişide satır 0'dır; HUD N'si atama sonrası bir azalır.
  - Bağımlılık: ISG-02. Boyut: S.
  - Dosya: yeni `src/koy/bosta_kalma.gd`.
  - Asset: asset gerekmedi.

- [ ] **ISG-20:** Boşta kalma bedeli ISG-03'tür
  - Ne: Boşta kalma bedeli ISG-03'tür. Moral düşüşü dosyada. Kod sabiti 0.
  - Kabul: Boşta kalma bedeli ISG-03'tür. Sabit 0. Test: DEN-01.
  - Bağımlılık: DEN-01. Boyut: S.
  - Dosya: `data/ayarlar/denge.json`
  - Asset: asset gerekmedi.

- [ ] **ISG-21:** Bedel günde bir
  - Ne: Bedel günde bir. İkinci düşüş 0.
  - Kabul: Bedel günde bir. Delta 1. Test: birim.
  - Bağımlılık: ISG-03. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **ISG-22:** İş varsa bedel yok
  - Ne: İş varsa bedel yok. Atanınca düşüş 0.
  - Kabul: İş varsa bedel yok. 0. Test: birim.
  - Bağımlılık: ISG-03. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.


- [ ] **ISG-24:** Bedel HUD'da bir satırdır
  - Ne: Bedel HUD'da bir satırdır. İkinci bar yok.
  - Kabul: Bedel HUD'da bir satırdır. Satır 1. Test: ekran.
  - Bağımlılık: ISG-03. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/`
  - Asset: asset gerekmedi.

- [ ] **ISG-25:** Bedel ölçümü DEN satırıdır
  - Ne: Bedel ölçümü DEN satırıdır. Formül değişmez.
  - Kabul: Bedel ölçümü DEN satırıdır. Satır 1. Test: DEN.
  - Bağımlılık: DEN-05. Boyut: S.
  - Dosya: `src/sistemler/denge_olcumu.gd`
  - Asset: asset gerekmedi.

- [ ] **ISG-26:** Bedel kışta mevsimi okur
  - Ne: Bedel kışta mevsimi okur. Ayrı kış bedeli yok. MEV çarpanı.
  - Kabul: Çarpan 1 kaynak. Test: MEV.
  - Bağımlılık: MEV-01. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **ISG-27:** Bedel açlıkla toplanıp tek çubuk olmaz
  - Ne: Bedel açlıkla toplanıp tek çubuk olmaz. YSM ayrı.
  - Kabul: Toplam çubuk 0. Test: tarama.
  - Bağımlılık: YSM-01. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.


### 20.4 Atama kadrajı

- [ ] **ISG-28:** Atama sürüklemedir
  - Ne: `koylu_surukleme_kulpu.gd`. Yeni atama penceresi yok.
  - Kabul: Pencere 0. Test: tarama.
  - Bağımlılık: ISG-02 Boyut: S.
  - Dosya: `src/arayuz/koylu_surukleme_kulpu.gd`
  - Asset: asset gerekmedi.


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

- [ ] **ISG-36:** Üretim işsiz artmaz
  - Ne: Üretim işsiz artmaz. Boştaki çiftçi ürün yazmaz.
  - Kabul: Üretim işsiz artmaz. Ürün 0. Test: birim.
  - Bağımlılık: ISG-03. Boyut: S.
  - Dosya: `src/koy/uretim.gd`
  - Asset: asset gerekmedi.

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

- [ ] **ISG-41:** Açlık verimi YSM-02'dedir
  - Ne: Açlık verimi YSM-02'dedir. ISG ikinci çarpan yazmaz.
  - Kabul: Çarpan 1 kaynak. Test: YSM-02.
  - Bağımlılık: YSM-02. Boyut: S.
  - Dosya: `src/koy/uretim.gd`
  - Asset: asset gerekmedi.

- [ ] **ISG-42:** Mevsim verimi MEV'dedir
  - Ne: Mevsim verimi MEV'dedir. Kış tarlası MEV-03.
  - Kabul: İkinci kış 0. Test: tarama.
  - Bağımlılık: MEV-03. Boyut: S.
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

- [ ] **ISG-46:** Aynı hücre iki işçi alabilir
  - Ne: Aynı hücre iki işçi alabilir. Bina kapasitesi dosyada. Aşım red.
  - Kabul: Aynı hücre iki işçi alabilir. Aşım 0. Test: birim.
  - Bağımlılık: ISG-02. Boyut: S.
  - Dosya: `data/koy/`
  - Asset: asset gerekmedi.

- [ ] **ISG-47:** Kapasite kod sabiti değildir
  - Ne: Kapasite kod sabiti değildir. JSON.
  - Kabul: Kapasite kod sabiti değildir. Sabit 0. Test: tarama.
  - Bağımlılık: ISG-02. Boyut: S.
  - Dosya: `data/koy/`
  - Asset: asset gerekmedi.

- [ ] **ISG-48:** Yıkılan bina işçiyi boşa çıkarır
  - Ne: Ertesi sabah havuza. Aynı karede çökme 0.
  - Kabul: SCRIPT ERROR 0. Test: yıkım.
  - Bağımlılık: ISG-02 Boyut: S.
  - Dosya: `src/arayuz/koy_ekrani.gd`
  - Asset: asset gerekmedi.


- [ ] **ISG-51:** Boş yer ertesi sabah dolmaz
  - Ne: Boş yer ertesi sabah dolmaz. Otomatik atama 0.
  - Kabul: Boş yer ertesi sabah dolmaz. 0. Test: birim.
  - Bağımlılık: ISG-02. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.


### 20.7 Kart

- [ ] **ISG-52:** Kartta iş adı görünür
  - Ne: Kartta iş adı görünür. Düz id değil, çeviri.
  - Kabul: `chr_` ekranda 0. Test: ekran.
  - Bağımlılık: SYS-09. Boyut: S.
  - Dosya: `src/arayuz/koylu_karti.gd`
  - Asset: asset gerekmedi.

- [ ] **ISG-53:** Boşta kelimesi bir anahtardır
  - Ne: Boşta kelimesi bir anahtardır. Her panel kendi cümlesini yazmaz.
  - Kabul: Anahtar 1. Test: tarama.
  - Bağımlılık: ISG-03. Boyut: S.
  - Dosya: `data/metin/metinler.csv`
  - Asset: asset gerekmedi.


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
  - Ne: Eski kayıt işsiz sayılır. Alan yoksa boşta. Çökme 0.
  - Kabul: Eski kayıt işsiz sayılır. Açılış 1. Test: KAY.
  - Bağımlılık: KAY-04. Boyut: S.
  - Dosya: `src/sistemler/kayit_gocu.gd`
  - Asset: asset gerekmedi.

- [ ] **ISG-63:** İkiz atama aynı tohumda eşittir
  - Ne: İkiz atama aynı tohumda eşittir. Eşit.
  - Kabul: İkiz atama aynı tohumda eşittir. Eşit. Test: ikiz.
  - Bağımlılık: ISG-02. Boyut: S.
  - Dosya: `tests/oto/is_ikiz.tscn`
  - Asset: asset gerekmedi.


- [ ] **ISG-67:** İş ölçümü otuz günde bantta
  - Ne: Boşta oranı DEN. Sapınca formül kendiliğinden değişmez.
  - Kabul: Rapor 1. Test: DEN.
  - Bağımlılık: DEN-05 Boyut: S.
  - Dosya: `src/sistemler/denge_olcumu.gd`
  - Asset: asset gerekmedi.


### 20.9 Sınır


- [ ] **ISG-69:** İkinci meslek ağacı yoktur
  - Ne: İkinci meslek ağacı yoktur. UZM ağacı durur.
  - Kabul: Sınıf yeni 0. Test: tarama.
  - Bağımlılık: UZM-04. Boyut: S.
  - Dosya: `src/koy/meslek_yapilari.gd`
  - Asset: asset gerekmedi.


- [ ] **ISG-73:** Çocuk çırak yaşı UZM-04'tür
  - Ne: Çocuk çırak yaşı UZM-04'tür. ISG yaş icat etmez.
  - Kabul: Eşik 1 kaynak. Test: UZM-04.
  - Bağımlılık: UZM-04. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **ISG-74:** Köle veya ikinci sınıf yoktur
  - Ne: Köle veya ikinci sınıf yoktur. Yetişkin, çırak, usta duran ayrımdır.
  - Kabul: Yeni sınıf adı 0. Test: tarama.
  - Bağımlılık: ISG-02. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **ISG-75:** İşçi maaşı muhafız maaşı değildir
  - Ne: İşçi maaşı muhafız maaşı değildir. `muhafiz_maas` karışmaz.
  - Kabul: Karışık yazım 0. Test: tarama.
  - Bağımlılık: ISG-03. Boyut: S.
  - Dosya: `data/ayarlar/koy.tres`
  - Asset: asset gerekmedi.


### 20.10 Kapanış

- [ ] **ISG-76:** Kabul uyarısı kapıdaki tek satırdır
  - Ne: Kabul uyarısı kapıdaki tek satırdır. Köyde ikinci kopya yok.
  - Kabul: Kabul uyarısı kapıdaki tek satırdır. Kopya 0. Test: tarama.
  - Bağımlılık: ISG-01. Boyut: S.
  - Dosya: `src/arayuz/kapi_ekrani.gd`
  - Asset: asset gerekmedi.

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

- [ ] **ISG-79:** Yapı kilidi YAP'tır
  - Ne: Yapı kilidi YAP'tır. ISG kademe açmaz.
  - Kabul: Kademe diff 0. Test: YAP-01.
  - Bağımlılık: YAP-01. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **ISG-80:** Divan iş cezası yazmaz
  - Ne: Divan iş cezası yazmaz. CAS üçlü karar.
  - Kabul: Dördüncü 0. Test: CAS-07.
  - Bağımlılık: CAS-07. Boyut: S.
  - Dosya: `src/kapi/divan_hukmu.gd`
  - Asset: asset gerekmedi.


- [ ] **ISG-83:** Kapanış altı iddiayı koşar
  - Ne: Çocuk iş 0, çift atama 0, boşta bedel bir, yıkım çökmez, eş havuzda 0, wav 0.
  - Kabul: Altı iddia. Test: `tests/unit/koy/is_gucu_test.gd`.
  - Bağımlılık: ISG-01 Boyut: S.
  - Dosya: `tests/unit/koy/is_gucu_test.gd`
  - Asset: asset gerekmedi.


YAP-01 … YAP-06 gövdesi durur. Yeni maddeler YAP-07 … YAP-86. Yeni bina türü ve yeni seviye sayısı yok.

### 21.1 Kademe

- [ ] **YAP-01:** Yapı kademeleri — her şey baştan açık değil.
  - Amaç: Yapı kademeleri — her şey baştan açık değil.
  - Kurallar:
    1. Kademe tablosu `data/koy/yapi_kademeleri.json` içindedir. K0: çadır, tarla, taş yatağı, odun yığını. K1: kulübe, hızarhane, taş ocağı, ambar. K2: taş ev, sur 2, değirmen, şifahane. K3: sur 3, konak, gelişmiş atölyeler.
    2. Kilitli yapı inşa menüsünde gri durur. Satırda gereken bilgi yazılır: "Gerekli: duvarcı ustası".
    3. ADM-08 bina seviyesi (üretim çarpanı, yatak ve depo artışı, sur hasarı) durur. K0–K3 o seviyeyi değiştirmez. UZM-11 çırak / kalfa / usta kişinindir, yapının kademesi değildir.
    4. K0 baştan kurulabilir. K1 ve üstü YAP-02 bilgisi olmadan kurulamaz.
  - Uç durumlar: tabloda olmayan bir bina K0 sayılır ve menüde kilitlenmez; doğrulayıcı bunu uyarı olarak listeler. Sur hasarı yalnız surdadır (ADM-08); kademe normal binaya hasar alanı açmaz.
  - Kabul: K2 satırı, bilgi yokken kurulamaz ve menüde gri "Gerekli" yazar. Test: aynı binanın ADM-08 seviyesi kilit yüzünden değişmez. Taşınan kontroller: YAP-71: Yasak sahne yoktur (Import 0.); YAP-75: İkinci harita yoktur (0.).
  - Bağımlılık: yok. Boyut: M.
  - Dosya: yeni `src/koy/yapi_kilidi.gd`; `BinaKatalogu` sorgusuna tek satır.
  - Asset: asset gerekmedi.


- [ ] **YAP-08:** Kademe sayısı UZM seviyesidir
  - Ne: Kademe sayısı UZM seviyesidir. Yeni seviye icat edilmez.
  - Kabul: Seviye kümesi aynı. Test: UZM-11.
  - Bağımlılık: UZM-11. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **YAP-09:** Kademe bedeli `koy.tres` dizisidir
  - Ne: Kademe bedeli `koy.tres` dizisidir. Kod içi bedel 0.
  - Kabul: Kademe bedeli `koy.tres` dizisidir. Sabit 0. Test: tarama.
  - Bağımlılık: YAP-01. Boyut: S.
  - Dosya: `data/ayarlar/koy.tres`
  - Asset: asset gerekmedi.

- [ ] **YAP-10:** Bedel yetmezse düğme kapalıdır
  - Ne: Bedel yetmezse düğme kapalıdır. Borçla kurulum yok.
  - Kabul: Bedel yetmezse düğme kapalıdır. Kapalı 1. Test: birim.
  - Bağımlılık: YAP-01. Boyut: S.
  - Dosya: `src/arayuz/koy_ekrani.gd`
  - Asset: asset gerekmedi.

- [ ] **YAP-11:** Kademe atlanmaz
  - Ne: Kademe atlanmaz. 2 olmadan 3 yok.
  - Kabul: Kademe atlanmaz. Atlama 0. Test: birim.
  - Bağımlılık: YAP-01. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **YAP-12:** Yıkım kademeyi sıfırlar
  - Ne: Yıkım kademeyi sıfırlar. Gizli kademe kalmaz.
  - Kabul: Yıkım kademeyi sıfırlar. Kademe 0. Test: yıkım.
  - Bağımlılık: YAP-01. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.


- [ ] **YAP-14:** Kademe ikonu üretilmez
  - Ne: Kademe ikonu üretilmez. Yer tutucu harf veya duran kart.
  - Kabul: Kademe ikonu üretilmez. png 0. Test: sayım.
  - Bağımlılık: ARY-05. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/yapi_karti.gd`
  - Asset: asset gerekmedi.


### 21.2 Bilginin kaynağı

- [ ] **YAP-02:** Yapı bilgisinin kaynakları — usta, muhafız geçmişi, çırak.
  - Amaç: Yapı bilgisinin kaynakları — usta, muhafız geçmişi, çırak.
  - Kurallar:
    1. Yapı açılır: o bilgiye sahip usta köyde yaşıyorsa; muhafızın seçtiği geçmiş o bilgiyi taşıyorsa (ACL-06); veya çırak UZM-11 ile usta olduysa.
    2. Usta ölür veya köyden ayrılırsa yeni inşaat kapanır. Ayakta duran yapı durur.
    3. Çırak usta olmuşsa bilgi köyde kalır. Usta gittikten sonra kilit geri gelmez.
    4. Bilgi bayrağı `Koylu` üzerinde optional alandır. İkinci bir yetenek ağacı açılmaz.
  - Uç durumlar: geçmişin açtığı bilgi, o geçmiş seçilmeden kayıtta durmaz. Aynı yapıyı hem geçmiş hem usta açıyorsa bayrak tektir. Usta köye gelir ama kabul edilmezse bilgi açılmaz.
  - Kabul: usta ayrılınca kilit geri gelir; aynı köyde çırak usta olmuşsa kilit gelmez. Test: ACL-06 geçmişi o yapıyı biliyorsa usta hiç gelmeden yapı kurulabilir. Taşınan kontroller: YAP-21: Bilgi takası akçe istemez (Akçe deltası 0.).
  - Bağımlılık: YAP-01, ACL-06. Boyut: M.
  - Dosya: yeni `src/koy/yapi_bilgisi.gd`; ustalık verisi `Koylu` (optional alan).
  - Asset: asset gerekmedi.

- [ ] **YAP-15:** Bilgi üç kaynaktan gelir
  - Ne: Usta, geçmiş, çırak. YAP-02. Dördüncü kaynak yok.
  - Kabul: Kaynak 3. Test: YAP-02.
  - Bağımlılık: YAP-02 Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **YAP-16:** Geçmiş yapı açabilir
  - Ne: ACL-06 bayrağı. Her geçmiş her yapıyı açmaz, tablo dosyada.
  - Kabul: Tablosuz açılış 0. Test: birim.
  - Bağımlılık: ACL-06 Boyut: S.
  - Dosya: `data/yapi_bilgisi.json`
  - Asset: asset gerekmedi.

- [ ] **YAP-17:** Çırak bilgiyi ustadan devralır
  - Ne: Usta ölünce çırak kademeyi taşır, yeni usta doğmaz.
  - Kabul: Yeni usta 0. Test: ölüm.
  - Bağımlılık: YAP-02 Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **YAP-18:** Bilgi olmadan kademe düğmesi kapalıdır
  - Ne: Bilgi olmadan kademe düğmesi kapalıdır. Sebep satırı bir anahtar.
  - Kabul: Kapalı 1, sebep 1. Test: ekran.
  - Bağımlılık: YAP-01. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/yapi_karti.gd`
  - Asset: asset gerekmedi.

- [ ] **YAP-19:** Bilgi kalıcıdır
  - Ne: Bilgi kalıcıdır. Bir kez öğrenilir, ikinci kez aranmaz.
  - Kabul: Bilgi kalıcıdır. Arama 1. Test: birim.
  - Bağımlılık: YAP-02. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **YAP-20:** Bilgi kayda optional yazılır
  - Ne: Bilgi kayda optional yazılır. Eski kayıt bilgisiz. Çökme 0.
  - Kabul: Bilgi kayda optional yazılır. Açılış 1. Test: KAY.
  - Bağımlılık: KAY-04. Boyut: S.
  - Dosya: `src/sistemler/kayit_gocu.gd`
  - Asset: asset gerekmedi.


### 21.3 Usta

- [ ] **YAP-03:** Ustalar kapıdan gelir — özel karakterler.
  - Amaç: Ustalar kapıdan gelir — özel karakterler.
  - Kurallar:
    1. Kimler geleceği `data/ustalar.json` içindedir. Geliş ağırlığı köy çekiciliğini (KAP-16: refah, güvenlik, yatak) ve dünya olayını (DNY) okur. Bu madde ikinci bir gelen zarı açmaz.
    2. Her ustanın kendi söz ağacı vardır (YAZ-05 hattı). Kabul pazarlığı üç başlıktır: ücret, ev, yanında gelen aile. Ücret kamu kasasından düşer (EKO-01 `koy_akce`). Kişisel kese bu ücretin kaynağı değildir.
    3. Aile, KAP-17 kafilesi olarak yatak sayar. KAP-17 yokken aile, ustanın kaydındaki kişi sayısıdır ve aynı yatağı tüketir.
    4. Test tohumunda bir K2 ustası 28 günde en az bir kez kapıya gelir. Oyuncunun her oyununda bu garanti değildir; ağırlık veridedir.
  - Uç durumlar: yatak doluyken pazarlık metni ACL-05 uyarısını gösterir; oyuncu yine de kabul edebilir, fazla kişi açıkta kalır. Usta ret yerse bilgi açılmaz ve aynı tohumda aynı gün yeniden kuyruğa eklenmez.
  - Kabul: tohumlu 28 gün koşusunda K2 ustası geliş sayısı en az 1'dir. Test: kabul edilen ücret `koy_akce` düşer, `muhafiz_akce` aynı kalır. Taşınan kontroller: YAP-74: Kalp yoktur (Hata.).
  - Bağımlılık: YAP-02, KAP-16, YAZ-05. Boyut: M.
  - Dosya: yeni `src/kapi/usta_gelisi.gd`, `data/ustalar.json`.
  - Asset: usta modelleri envantere `YAP03-USTALAR`.


- [ ] **YAP-24:** Usta adsız şablon değildir
  - Ne: Usta adsız şablon değildir. Adlı dosya. KOP-10 adsız kalanı açmaz.
  - Kabul: Adsız usta 0. Test: KOP-10.
  - Bağımlılık: KOP-10. Boyut: S.
  - Dosya: `data/soz/`
  - Asset: asset gerekmedi.

- [ ] **YAP-25:** Usta reddedilirse bilgi gelmez
  - Ne: Usta reddedilirse bilgi gelmez. Köyde değilse kademe kilitli kalır.
  - Kabul: Usta reddedilirse bilgi gelmez. Kilit 1. Test: ret.
  - Bağımlılık: YAP-03. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **YAP-26:** Usta ölünce kademe kapanmaz
  - Ne: Usta ölünce kademe kapanmaz. Öğrenilmiş bilgi durur.
  - Kabul: Kademe durur. Test: KRI-05.
  - Bağımlılık: KRI-05. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **YAP-27:** İkinci aynı usta aynı bilgiyi tekrar açmaz
  - Ne: İkinci aynı usta aynı bilgiyi tekrar açmaz. Delta 0.
  - Kabul: İkinci aynı usta aynı bilgiyi tekrar açmaz. 0. Test: iki ziyaret.
  - Bağımlılık: YAP-03. Boyut: S.
  - Dosya: `src/koy/`
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
  - Amaç: Usta defterleri ve yapı resimleri — ganimetten gelen bilgi.
  - Kurallar:
    1. Defter, yapı resmi veya örnek eşya şu duran akışların ganimetine yazılır: dış sefer, pusu temizliği (HAR-05, HAR-14), baskın sonrası, tüccar (TUC). Yeni tüccar takvimi açılmaz.
    2. Eşya envanterde görünür. Yapı kilidi ancak YAP-05 çözümlemesi bitince açılır.
    3. Aynı defter kimliği ikinci kez düşerse yığın 1 kalır, ikinci kilit açmaz.
  - Uç durumlar: tüccar her uğrayışta defter bırakmaz; ağırlık tablodadır. Tablo satırı olmayan bir ganimet defter üretmez. Defter, çözümleme bitmeden satılırsa kilit açılmaz.
  - Kabul: ganimet tablosundaki bir satır envantere bir defter yazar ve ilgili yapı o an kilitli kalır. Test: aynı kimlik iki kez düşünce envanter sayısı 1'dir. Taşınan kontroller: YAP-73: Ses yoktur (Sayı aynı.).
  - Bağımlılık: YAP-01. Boyut: M.
  - Dosya: yeni `src/koy/usta_defterleri.gd`, `data/usta_defterleri.json`.
  - Asset: defter ikonu envantere `YAP04-DEFTER`.


- [ ] **YAP-32:** Defter heybeden okunur
  - Ne: Yeni eşya türü şemayı büyümez. Mevcut ipucu kaydı.
  - Kabul: Yeni sınıf 0. Test: tarama.
  - Bağımlılık: YAP-04 Boyut: S.
  - Dosya: `src/kapi/`
  - Asset: asset gerekmedi.

- [ ] **YAP-33:** Defter bir kez öğrenir
  - Ne: Defter bir kez öğrenir. İkinci okuma delta 0.
  - Kabul: Defter bir kez öğrenir. 0. Test: birim.
  - Bağımlılık: YAP-04. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **YAP-34:** Defter metni resim değildir
  - Ne: Defter metni resim değildir. Asset üretilmez. Metin anahtarı.
  - Kabul: Defter metni resim değildir. png 0. Test: sayım.
  - Bağımlılık: ARY-05. Boyut: S.
  - Dosya: `docs/EKSIK_ASSET_ENVANTERI.md`
  - Asset: asset gerekmedi.

- [ ] **YAP-35:** Yapı resmi aynı kaynaktır
  - Ne: Yapı resmi aynı kaynaktır. Ayrı mini oyun yok.
  - Kabul: Yapı resmi aynı kaynaktır. Oyun 0. Test: tarama.
  - Bağımlılık: YAP-04. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **YAP-36:** Sahte defter öğrenmez
  - Ne: Koşul tutmazsa bilgi 0. DYL çelişki ayrı.
  - Kabul: Bilgi 0. Test: birim.
  - Bağımlılık: YAP-04 Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **YAP-37:** Defter sözü DYL-08 ile dönebilir
  - Ne: Defter sözü DYL-08 ile dönebilir. İkinci dönüş motoru yok.
  - Kabul: Defter sözü DYL-08 ile dönebilir. Dönüş 1. Test: DYL-08.
  - Bağımlılık: DYL-08. Boyut: S.
  - Dosya: `src/soz/soz_motoru.gd`
  - Asset: asset gerekmedi.

- [ ] **YAP-38:** Defter kaydı optional
  - Ne: Defter kaydı optional. Eski kayıt boş.
  - Kabul: Defter kaydı optional. Çökme 0. Test: KAY.
  - Bağımlılık: KAY-04. Boyut: S.
  - Dosya: `src/sistemler/kayit_gocu.gd`
  - Asset: asset gerekmedi.


### 21.5 Çözümleme

- [ ] **YAP-05:** Çözümleme işi — araştırma.
  - Amaç: Çözümleme işi — araştırma.
  - Kurallar:
    1. İş, K1 çözümleme odasında yapılır. Oda yoksa iş başlamaz. Oda kataloga tek satır olarak girer.
    2. Süre ve sonuç `data/usta_defterleri.json` içindedir. Örnek sonuçlar, duran sistemlere yazar: Horasan harcı sur hasarına (ADM-08, yalnız sur); Rum usulü su değirmeni mevcut değirmen üretimine (EKO-04); Türkmen keçesi kış odun tüketimine (EKO-09); uzun menzilli yay mevcut savunma formülüne (HAR-15). Yeni savaş, yeni mevsim ve yeni değirmen binası açılmaz.
    3. Aynı anda tek çözümleme vardır. İkincisi kuyrukta bekler.
  - Uç durumlar: çözen kişi ölürse gün sayacı durur, defter envanterde kalır, ilerleme silinmez. Oda yıkılırsa iş durur. Süre 0 gün yazılmışsa doğrulayıcı o satırı hata sayar.
  - Kabul: tablodaki süre dolunca tek hedef sistem değişir ve defter "çözüldü" olur. Test: ikinci defter aynı gün başlatılamaz; süre ile sonuç tablo değeriyle aynıdır.
  - Bağımlılık: YAP-04. Boyut: M.
  - Dosya: yeni `src/koy/cozumleme.gd`; çözümleme odası katalog satırı.
  - Asset: çözümleme odası modeli envantere `YAP05-ODA`.


- [ ] **YAP-40:** Çözümleme işçisi yetişkindir
  - Ne: Çözümleme işçisi yetişkindir. Çocuk 0.
  - Kabul: Çözümleme işçisi yetişkindir. 0. Test: UZM-08.
  - Bağımlılık: UZM-08. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **YAP-41:** İşçi boşa çıkarsa sayaç durur
  - Ne: İşçi boşa çıkarsa sayaç durur. Silinmez.
  - Kabul: Sayaç aynı. Test: ISG-02.
  - Bağımlılık: ISG-02. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **YAP-42:** Sayaç kod sabiti değildir
  - Ne: Sayaç kod sabiti değildir. JSON.
  - Kabul: Sayaç kod sabiti değildir. Sabit 0. Test: tarama.
  - Bağımlılık: YAP-05. Boyut: S.
  - Dosya: `data/yapi_bilgisi.json`
  - Asset: asset gerekmedi.

- [ ] **YAP-43:** Biten çözümleme bildirimi bir satırdır
  - Ne: Biten çözümleme bildirimi bir satırdır. İkinci sahne yok.
  - Kabul: Biten çözümleme bildirimi bir satırdır. Satır 1. Test: ekran.
  - Bağımlılık: YAP-05. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/yapi_karti.gd`
  - Asset: asset gerekmedi.

- [ ] **YAP-44:** Çözümleme akçe yakmaz
  - Ne: Bedel kurulunca. Araştırma bedelsiz veya dosyadaki tek bedel. İkinci bedel yok.
  - Kabul: Bedel kaynağı 1. Test: birim.
  - Bağımlılık: YAP-05 Boyut: S.
  - Dosya: `data/yapi_bilgisi.json`
  - Asset: asset gerekmedi.

- [ ] **YAP-45:** Çözümleme kışın durabilir
  - Ne: Çözümleme kışın durabilir. MEV. Ayrı kış araştırma yok.
  - Kabul: Çarpan 1 kaynak. Test: MEV.
  - Bağımlılık: MEV-01. Boyut: S.
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
  - Amaç: Özel eşyalar.
  - Kurallar:
    1. `data/ozel_esyalar.json` en az 8 satırdır. Her satırda ad, YAZ-01 kaynak notu ve tek `hedef_sistem` vardır.
    2. `hedef_sistem` oyunda duran bir kapıdır: sur hasarı, değirmen üretimi, kış odun tüketimi, savunma formülü, erzak, sağlık, güvenlik. Listede olmayan bir kapı doğrulayıcıda hatadır.
    3. Bir eşya iki kapıya birden yazamaz. Etki, o kapının mevcut gece hesabına tek çarpandır.
  - Uç durumlar: kaynak notu boş olan satır sayılmaz, 8 eşiği onu beklemez. Aynı eşya iki kez çözülürse çarpan bir kez uygulanır.
  - Kabul: 8 satırın her biri dolu kaynak notu ve tek kapı taşır; birim test her kapıda çarpanın tabloyla aynı olduğunu görür. Test: iki kapılı bir satır 1 hata verir.
  - Bağımlılık: YAP-05, YAZ-01. Boyut: M.
  - Dosya: yeni `src/koy/ozel_esyalar.gd`, `data/ozel_esyalar.json`.
  - Asset: eşya ikonları envantere `YAP06-ESYA`.

- [ ] **YAP-47:** Özel eşya YAP-06 listesindedir
  - Ne: Özel eşya YAP-06 listesindedir. Liste dışı eşya kademe açmaz.
  - Kabul: Özel eşya YAP-06 listesindedir. Açılış 0. Test: YAP-06.
  - Bağımlılık: YAP-06. Boyut: S.
  - Dosya: `data/yapi_bilgisi.json`
  - Asset: asset gerekmedi.

- [ ] **YAP-48:** Eşya heybede bir kez tüketilir
  - Ne: Eşya heybede bir kez tüketilir. İkinci yapı yok.
  - Kabul: Eşya heybede bir kez tüketilir. Tüketim 1. Test: birim.
  - Bağımlılık: YAP-06. Boyut: S.
  - Dosya: `src/kapi/`
  - Asset: asset gerekmedi.

- [ ] **YAP-49:** Eşya çocuk heybesinden de okunur
  - Ne: Eşya çocuk heybesinden de okunur. Sahip yaşından bağımsız, tek kayıt.
  - Kabul: Çift kayıt 0. Test: tarama.
  - Bağımlılık: YAP-06. Boyut: S.
  - Dosya: `src/kapi/`
  - Asset: asset gerekmedi.

- [ ] **YAP-50:** Eşya ikonu Sanat'tan
  - Ne: Eşya ikonu Sanat'tan. Yeni png 0.
  - Kabul: Eşya ikonu Sanat'tan. 0. Test: sayım.
  - Bağımlılık: ARY-05. Boyut: S.
  - Dosya: `src/arayuz/esya_karti.gd`
  - Asset: asset gerekmedi.

- [ ] **YAP-51:** Eşya açıklaması anahtardır
  - Ne: Eşya açıklaması anahtardır. Düz cümle 0.
  - Kabul: Eşya açıklaması anahtardır. 0. Test: SYS-09.
  - Bağımlılık: SYS-09. Boyut: S.
  - Dosya: `data/metin/metinler.csv`
  - Asset: asset gerekmedi.

- [ ] **YAP-52:** Eşya satılırsa bilgi geri alınmaz
  - Ne: Eşya satılırsa bilgi geri alınmaz. Öğrenilmiş kademe durur.
  - Kabul: Kademe durur. Test: satış.
  - Bağımlılık: YAP-06. Boyut: S.
  - Dosya: `src/koy/`
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

- [ ] **YAP-56:** Kilitli kademe sebebi görünür
  - Ne: Kilitli kademe sebebi görünür. Sessiz kilit yok.
  - Kabul: Kilitli kademe sebebi görünür. Sebep 1. Test: ekran.
  - Bağımlılık: YAP-01. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/yapi_karti.gd`
  - Asset: asset gerekmedi.


- [ ] **YAP-58:** Hayalet yerleşim kilitli yapıda çıkmaz
  - Ne: Hayalet yerleşim kilitli yapıda çıkmaz. R ile dönen hayalet yok.
  - Kabul: Hayalet yerleşim kilitli yapıda çıkmaz. Hayalet 0. Test: kilit.
  - Bağımlılık: YAP-01. Boyut: S.
  - Dosya: `src/arayuz/koy_ekrani.gd`
  - Asset: asset gerekmedi.

- [ ] **YAP-59:** Kart uzun metni kayar
  - Ne: Kart uzun metni kayar. Kesilen glif 0.
  - Kabul: Kart uzun metni kayar. 0. Test: GRV-15.
  - Bağımlılık: GRV-15. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/yapi_karti.gd`
  - Asset: asset gerekmedi.

- [ ] **YAP-60:** Eksik anahtar kartı düşürmez
  - Ne: Eksik anahtar kartı düşürmez. Kilit metni anahtar yoksa nötr sebep.
  - Kabul: Eksik anahtar kartı düşürmez. Çökme 0. Test: SYS-09.
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

- [ ] **YAP-63:** Kurulum kaynak düşer
  - Ne: Taş, odun, akçe dosyadaki bedel. Çift düşüş yok.
  - Kabul: Delta 1. Test: birim.
  - Bağımlılık: BUG-21 Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **YAP-64:** Kurulum işçisiz bitmez
  - Ne: Kurulum işçisiz bitmez. ISG. İşçi yoksa süre ilerlemez.
  - Kabul: Sayaç durur. Test: ISG-02.
  - Bağımlılık: ISG-02. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **YAP-65:** Yarım inşaat kayda yazılır
  - Ne: Yarım inşaat kayda yazılır. Yükleme başa sarmaz.
  - Kabul: Yarım inşaat kayda yazılır. Kademe aynı. Test: KAY.
  - Bağımlılık: SYS-02. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **YAP-66:** Yıkım kaynak iade etmez
  - Ne: Tam iade yok. Dosyada oran varsa o, yoksa 0.
  - Kabul: İkinci oran 0. Test: birim.
  - Bağımlılık: YAP-01 Boyut: S.
  - Dosya: `data/ayarlar/koy.tres`
  - Asset: asset gerekmedi.

- [ ] **YAP-67:** İnşaat kışın MEV'i okur
  - Ne: İnşaat kışın MEV'i okur. Ayrı kış inşaat yok.
  - Kabul: İnşaat kışın MEV'i okur. Kaynak 1. Test: MEV.
  - Bağımlılık: MEV-01. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **YAP-68:** İnşaat salgında durabilir
  - Ne: İnşaat salgında durabilir. İşçi hasta ise sayaç durur.
  - Kabul: İnşaat salgında durabilir. Durur. Test: YSM-02.
  - Bağımlılık: YSM-02. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **YAP-69:** Sur taksiti ayrıdır
  - Ne: `sur_taksit` koy.tres. YAP onu yeniden yazmaz.
  - Kabul: Diff 0. Test: tarama.
  - Bağımlılık: YAP-01 Boyut: S.
  - Dosya: `data/ayarlar/koy.tres`
  - Asset: asset gerekmedi.

- [ ] **YAP-70:** İnşaat ölçümü DEN satırıdır
  - Ne: İnşaat ölçümü DEN satırıdır. Süre bandı. Formül değişmez.
  - Kabul: İnşaat ölçümü DEN satırıdır. Satır 1. Test: DEN.
  - Bağımlılık: DEN-05. Boyut: S.
  - Dosya: `src/sistemler/denge_olcumu.gd`
  - Asset: asset gerekmedi.


### 21.9 Sınır


- [ ] **YAP-72:** Yeni bina türü bu bölümde yoktur
  - Ne: Yeni bina türü bu bölümde yoktur. Duran türler.
  - Kabul: Yeni bina türü bu bölümde yoktur. Yeni id 0. Test: sayım.
  - Bağımlılık: YAP-01. Boyut: S.
  - Dosya: `data/koy/`
  - Asset: asset gerekmedi.


- [ ] **YAP-78:** İkiz kademe aynı tohumdadır
  - Ne: İkiz kademe aynı tohumdadır. Eşit.
  - Kabul: İkiz kademe aynı tohumdadır. Eşit. Test: ikiz.
  - Bağımlılık: YAP-01. Boyut: S.
  - Dosya: `tests/oto/yapi_ikiz.tscn`
  - Asset: asset gerekmedi.


### 21.10 Kapanış

- [ ] **YAP-79:** Usta defteri şematik diye anılmaz
  - Ne: Usta defteri şematik diye anılmaz. Karar kaydı: usta defteri / yapı resmi.
  - Kabul: Şematik kelimesi oyuncu metninde 0. Test: tarama.
  - Bağımlılık: YAP-04. Boyut: S.
  - Dosya: `data/metin/metinler.csv`
  - Asset: asset gerekmedi.


- [ ] **YAP-82:** Divan kademe açamaz
  - Ne: Divan kademe açamaz. CAS.
  - Kabul: Divan kademe açamaz. 0. Test: tarama.
  - Bağımlılık: CAS-07. Boyut: S.
  - Dosya: `src/kapi/divan_hukmu.gd`
  - Asset: asset gerekmedi.

- [ ] **YAP-83:** Kapı kararı bina kurmaz
  - Ne: Kapı kararı bina kurmaz. Kurulum köydedir.
  - Kabul: Kapıda kur 0. Test: tarama.
  - Bağımlılık: KAP-16. Boyut: S.
  - Dosya: `src/arayuz/kapi_ekrani.gd`
  - Asset: asset gerekmedi.


- [ ] **YAP-85:** Olay kartı kademe açmaz
  - Ne: Olay kartı kademe açmaz. OZL şema büyümez.
  - Kabul: Alan 0 yeni. Test: OZL-30.
  - Bağımlılık: OZL-30. Boyut: S.
  - Dosya: `src/veri/olay_verisi.gd`
  - Asset: asset gerekmedi.

- [ ] **YAP-86:** Kapanış altı iddiayı koşar
  - Ne: Kilitli kademe kurulamaz, usta reddinde bilgi 0, defter bir kez, çocuk araştırma 0, çift düşüş 0, png 0.
  - Kabul: Altı iddia. Test: `tests/unit/koy/yapi_bilgisi_test.gd`.
  - Bağımlılık: YAP-01 Boyut: S.
  - Dosya: `tests/unit/koy/yapi_bilgisi_test.gd`
  - Asset: asset gerekmedi.


YSM-01 … YSM-03 gövdesi durur. Yeni maddeler YSM-04 … YSM-83. İkinci açlık sayacı ve kişi barı HUD'u yok.

### 22.1 Üç değer

- [ ] **YSM-01:** Köylü başına açlık, yorgunluk, moral barı.
  - Amaç: Köylü başına açlık, yorgunluk, moral barı.
  - Kurallar:
    1. Açlık, üst üste erzak payı alınamayan gece sayısıdır. Pay EKO-09'dur (kişi başı gece 1 erzak). Erzak 3'ün altındayken sağlık ve bulaş KRI-12'dedir. Bu madde o eşiği yeniden yazmaz.
    2. Yorgunluk UZM-14 gece vardiyası kaydıdır. YSM-03 uykusu aynı değeri düşürür.
    3. Moral UZM-06 memnuniyetidir. İkinci moral sayısı yoktur.
    4. Üç bar köylü kartında ve ANI-14 yüzen kartında okunur. Yeni kart açılmaz.
  - Uç durumlar: değer kaydı olmayan eski kayıtta bar 0'dan başlar, gece hesabı bir sonraki sabah doldurur. Ölen kişide bar çizilmez. Eşin ayrı izlenen sağlığı (ACL-02) bu üç barın dördüncü şeridi değildir; eş de aynı üç alanı kullanır.
  - Kabul: erzaksız bir geceden sonra o köylünün açlık değeri 1 artar. Test: KRI-12 sağlık düşüşü, bar açıkken de kapalıyken de aynıdır; yüzen kartta bar sayısı 3'tür. Taşınan kontroller: YSM-68: Yasak sahne yoktur (Import 0.); YSM-70: Kalp yoktur (Hata.); YSM-72: İkinci harita yoktur (0.); YSM-73: Hediye ile moral dolmaz (0.).
  - Bağımlılık: yok. Boyut: M.
  - Dosya: yeni `src/koy/yasam_barlari.gd`, `src/arayuz/koy_hud/yasam_barlari_paneli.gd`.
  - Asset: bar ikonları envantere `YSM01-IKON`.

- [ ] **YSM-04:** Açlık kişi başınadır
  - Ne: YSM-01. Köy ortalaması ikinci bar açmaz.
  - Kabul: Kişi alanı 1, ortalama bar 0. Test: tarama.
  - Bağımlılık: YSM-01 Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **YSM-05:** Yorgunluk uyku ile sıfırlanır
  - Ne: YSM-03 ev uykusu. Nöbet yorgunluğu UZM-14 ile aynı alan, ikinci yorgunluk yok.
  - Kabul: Alan 1. Test: iki gece.
  - Bağımlılık: YSM-03 Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **YSM-06:** Moral halk barı değildir
  - Ne: Moral halk barı değildir. Kişi morali `bar.halk` ile toplanmaz.
  - Kabul: Toplam yazımı 0. Test: tarama.
  - Bağımlılık: YSM-01. Boyut: S.
  - Dosya: `src/koy/barlar.gd`
  - Asset: asset gerekmedi.

- [ ] **YSM-07:** Üç değer 0–100 aralığındadır
  - Ne: Üç değer 0–100 aralığındadır. Taşan yazım kırpılmaz, reddedilir.
  - Kabul: 101 yazımı 1 hata. Test: birim.
  - Bağımlılık: YSM-01. Boyut: S.
  - Dosya: `data/ayarlar/koy.tres`
  - Asset: asset gerekmedi.

- [ ] **YSM-08:** Başlangıç değerleri dosyadadır
  - Ne: `baslangic_sadakat` ve `baslangic_moral` kod sabiti değildir.
  - Kabul: `.gd` sabiti 0. Test: tarama.
  - Bağımlılık: YSM-01 Boyut: S.
  - Dosya: `data/ayarlar/koy.tres`
  - Asset: asset gerekmedi.


- [ ] **YSM-10:** Eş aynı üç değeri taşır
  - Ne: Eş aynı üç değeri taşır. Ayrı eş barı yok.
  - Kabul: Bar sayısı kişiyle aynı. Test: ACL-02.
  - Bağımlılık: ACL-02. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.


### 22.2 Açlık kademesi

- [ ] **YSM-02:** Açlığın kademeli etkisi.
  - Amaç: Açlığın kademeli etkisi.
  - Kurallar:
    1. Eşikler `data/koy/aclik_kademeleri.json` içindedir. 1 gün: üretim −%20. 2 gün: üretim −%50 ve yürüyüş yavaşlar. 2 günü aşan: kişi evde yatar, çalışmaz, hastalık riski artar.
    2. Üretim çarpanı UZM-03 ve ADM-08 hesabının üstüne tek çarpan olarak biner. Ayrı bir üretim defteri açılmaz.
    3. Hastalık riski mevcut sağlık yöneticisine (KRI) yazılır. Yeni bir salgın dalgası bu maddeden çıkmaz.
  - Uç durumlar: gece payı düşünce sayaç 0'a döner ve çarpan 1 olur. Yatan kişiye geçici iş yazılamaz (ISG-02 sekmesi kapalı). Eşik dosyasında gün sayısı yoksa o kademe uygulanmaz.
  - Kabul: 1, 2 ve 3 aç gün için üretim çarpanı tablodaki üç değerdir. Test: 3. gün kişi iş satırı yazmaz ve salgın sayacı kendiliğinden artmaz.
  - Bağımlılık: YSM-01. Boyut: S.
  - Dosya: yeni `src/koy/aclik_kademesi.gd`; ANI rutinlerine tek satır.
  - Asset: asset gerekmedi.

- [ ] **YSM-12:** Açlık kademesi YSM-02'dedir
  - Ne: Açlık kademesi YSM-02'dedir. Tok, aç, bitkin. Dördüncü kademe yok.
  - Kabul: Açlık kademesi YSM-02'dedir. Kademe 3. Test: YSM-02.
  - Bağımlılık: YSM-02. Boyut: S.
  - Dosya: `data/ayarlar/koy.tres`
  - Asset: asset gerekmedi.

- [ ] **YSM-13:** Kademe eşiği dosyadadır
  - Ne: Kademe eşiği dosyadadır. Kod içi 30/10 sabiti 0.
  - Kabul: Kademe eşiği dosyadadır. Sabit 0. Test: tarama.
  - Bağımlılık: YSM-02. Boyut: S.
  - Dosya: `data/ayarlar/denge.json`
  - Asset: asset gerekmedi.

- [ ] **YSM-14:** Aç kademe verimi düşürür
  - Ne: `aclik_verim` okunur. İkinci çarpan yok.
  - Kabul: Çarpan 1 kaynak. Test: birim.
  - Bağımlılık: YSM-02 Boyut: S.
  - Dosya: `src/koy/uretim.gd`
  - Asset: asset gerekmedi.

- [ ] **YSM-15:** Bitkin işe yazılmaz
  - Ne: Bitkin işe yazılmaz. ISG ataması 0.
  - Kabul: Bitkin işe yazılmaz. Atama 0. Test: ISG-02.
  - Bağımlılık: ISG-02. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **YSM-16:** Açlık ölümü sağlık eşiğindendir
  - Ne: Yeni ölüm türü yok. Sağlık 0 ise KRI-05.
  - Kabul: Çağrı 1. Test: KRI-05.
  - Bağımlılık: KRI-05 Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **YSM-17:** Tok kişi gecede iyileşir
  - Ne: Tok kişi gecede iyileşir. `iyilesme` dosyada. Açken iyileşme 0.
  - Kabul: Açken delta 0. Test: birim.
  - Bağımlılık: YSM-02. Boyut: S.
  - Dosya: `data/ayarlar/koy.tres`
  - Asset: asset gerekmedi.

- [ ] **YSM-18:** İyileşme günde bir
  - Ne: İyileşme günde bir. İkinci çağrı 0.
  - Kabul: İyileşme günde bir. Delta 1. Test: birim.
  - Bağımlılık: YSM-02. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **YSM-19:** Kademe metni kelimedir
  - Ne: Kademe metni kelimedir. Kartta sayı yerine tok / aç / bitkin.
  - Kabul: Ham sayı 0. Test: ekran.
  - Bağımlılık: YSM-01. Boyut: S.
  - Dosya: `src/arayuz/koylu_karti.gd`
  - Asset: asset gerekmedi.


### 22.3 Uyku

- [ ] **YSM-03:** Gece evde uyku, gündüz dinlenme.
  - Amaç: Gece evde uyku, gündüz dinlenme.
  - Kurallar:
    1. Yataklı evde uyuyan kişinin yorgunluğu veri dosyasındaki tam miktar kadar düşer.
    2. Yatağı olmayan açıkta uyur (ACL-05). Düşüş tam miktarın yarısıdır. Yarım, dosyada yazılır, kodda sabitlenmez.
    3. Gündüz ateş başı (ANI-07) ve boşta durmak yorgunluk düşürmez. Dinlenme adımı yalnız gece uykusudur.
    4. Yorgun kişi kaza riskini UZM-12 ve UZM-14 hesabına ekler. İkinci bir kaza zar tablosu açılmaz.
  - Uç durumlar: gece vardiyasına yazılan kişi o gece uyumaz, düşüş 0'dır. Ev varken yatak doluysa fazla kişi açıkta sayılır. Ölen kişi uyku satırı yazmaz.
  - Kabul: aynı yorgunlukla yatan iki kişiden yataklı olanın düşüşü, açıkta kalanın düşüşünün iki katıdır. Test: gündüz ateşte duran kişide yorgunluk değişmez; kaza olasılığı UZM tablosunun dışına yazılmaz. Taşınan kontroller: YSM-71: Ses yoktur (Sayı aynı.).
  - Bağımlılık: YSM-01, ACL-05. Boyut: S.
  - Dosya: yeni `src/koy/uyku_dinlenme.gd`.
  - Asset: asset gerekmedi.


- [ ] **YSM-22:** Gündüz dinlenme işi keser
  - Ne: Dinlenen üretmez. İkinci dinlenme barı yok.
  - Kabul: Üretim 0. Test: birim.
  - Bağımlılık: YSM-03 Boyut: S.
  - Dosya: `src/koy/uretim.gd`
  - Asset: asset gerekmedi.

- [ ] **YSM-23:** Nöbet uykusu YSM'yi deler
  - Ne: NBT-05 uyuyan nöbetçi ertesi gün yorgun. Ev uykusu bunu siler.
  - Kabul: Nöbet sonrası yorgunluk 1, ev sonrası 0. Test: iki gece.
  - Bağımlılık: NBT-05 Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **YSM-24:** Oyuncu nöbeti de yorar
  - Ne: HAN kuralı. Yeni oyuncu barı yok, UZM-14 okunur.
  - Kabul: Alan 1. Test: HAN.
  - Bağımlılık: UZM-14 Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.


- [ ] **YSM-26:** Uyku sesi üretilmez
  - Ne: Uyku sesi üretilmez. Wav 0.
  - Kabul: Uyku sesi üretilmez. Sayı aynı. Test: sayım.
  - Bağımlılık: YSM-03. Boyut: S.
  - Dosya: `assets/ses/`
  - Asset: asset gerekmedi.

- [ ] **YSM-27:** Uyku kaydı optional
  - Ne: Uyku kaydı optional. Eski kayıt dinlenmiş sayılmaz, çökmez.
  - Kabul: Uyku kaydı optional. Açılış 1. Test: KAY.
  - Bağımlılık: KAY-04. Boyut: S.
  - Dosya: `src/sistemler/kayit_gocu.gd`
  - Asset: asset gerekmedi.


### 22.4 Soğuk ve gıda

- [ ] **YSM-28:** Gıda düşünce açlık artar
  - Ne: Tüketim EKO-09. YSM ikinci tüketim yazmaz.
  - Kabul: Tüketim çağrısı 1. Test: EKO-09.
  - Bağımlılık: EKO-09 Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **YSM-29:** Kış odunu sağlık düşürür
  - Ne: `soguk_saglik`. Donma yöneticisi MEV-02'dir, YSM onu yeniden yazmaz.
  - Kabul: İkinci soğuk fonksiyon 0. Test: tarama.
  - Bağımlılık: MEV-02 Boyut: S.
  - Dosya: `src/dunya/donma_yoneticisi.gd`
  - Asset: asset gerekmedi.

- [ ] **YSM-30:** Odun varsa soğuk cezası 0
  - Ne: Odun varsa soğuk cezası 0. Eşik `MevsimTuketimAdaptoru`.
  - Kabul: Odun yeterken delta 0. Test: birim.
  - Bağımlılık: MEV-02. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **YSM-31:** Açlık moral düşürür
  - Ne: Açlık moral düşürür. `aclik_moral` dosyada.
  - Kabul: Sabit 0 kodda. Test: tarama.
  - Bağımlılık: YSM-02. Boyut: S.
  - Dosya: `data/ayarlar/koy.tres`
  - Asset: asset gerekmedi.

- [ ] **YSM-32:** Moral 0 kişiyi kaçırmaz
  - Ne: Kaçış KRI eşiğidir. YSM kaçış fonksiyonu açmaz.
  - Kabul: Kaçış çağrısı 0. Test: tarama.
  - Bağımlılık: YSM-01 Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.


- [ ] **YSM-34:** Şifahane iyileşmesi YSM ile toplanmaz
  - Ne: Aynı gece iki iyileşme varsa büyük olan kalır, ikisi birden yazılmaz.
  - Kabul: Delta 1. Test: birim.
  - Bağımlılık: CAT-03 Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **YSM-35:** Salgın sağlık düşüşü KRI'dedir
  - Ne: Salgın sağlık düşüşü KRI'dedir. YSM hastalık formülü yazmaz.
  - Kabul: Salgın sağlık düşüşü KRI'dedir. Formül 0. Test: tarama.
  - Bağımlılık: YSM-02. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.


### 22.5 Kart

- [ ] **YSM-36:** Kartta üç kelime vardır
  - Ne: Açlık, yorgunluk, moral. Dördüncü satır yok.
  - Kabul: Satır 3. Test: ekran.
  - Bağımlılık: YSM-01 Boyut: S.
  - Dosya: `src/arayuz/koylu_karti.gd`
  - Asset: asset gerekmedi.

- [ ] **YSM-37:** Güvenlik satırı kaybolmaz
  - Ne: TEK-03. Yaşam satırları onu aşağı itmez.
  - Kabul: İlk ekranda 1. Test: TEK-03.
  - Bağımlılık: TEK-03 Boyut: S.
  - Dosya: `src/arayuz/koylu_karti.gd`
  - Asset: asset gerekmedi.

- [ ] **YSM-38:** Kart tema puntosunu kullanır
  - Ne: Kart tema puntosunu kullanır. Yerel punto 0.
  - Kabul: Kart tema puntosunu kullanır. 0. Test: ARY-02.
  - Bağımlılık: ARY-02. Boyut: S.
  - Dosya: `src/arayuz/koylu_karti.gd`
  - Asset: asset gerekmedi.

- [ ] **YSM-39:** Sayı yerine kelime
  - Ne: Sayı yerine kelime. 0–100 oyuncuya basılmaz.
  - Kabul: Ham sayı 0. Test: ekran.
  - Bağımlılık: YSM-01. Boyut: S.
  - Dosya: `src/arayuz/koylu_karti.gd`
  - Asset: asset gerekmedi.

- [ ] **YSM-40:** Köy HUD'u kişi barı açmaz
  - Ne: Köy HUD'u kişi barı açmaz. Ortalama çubuk 0.
  - Kabul: Köy HUD'u kişi barı açmaz. Çubuk 0. Test: tarama.
  - Bağımlılık: YSM-01. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/`
  - Asset: asset gerekmedi.

- [ ] **YSM-41:** Eksik anahtar kartı düşürmez
  - Ne: Eksik anahtar kartı düşürmez. Nötr kelime.
  - Kabul: Eksik anahtar kartı düşürmez. Çökme 0. Test: SYS-09.
  - Bağımlılık: SYS-09. Boyut: S.
  - Dosya: `src/arayuz/koylu_karti.gd`
  - Asset: asset gerekmedi.

- [ ] **YSM-42:** Kart hızı değiştirmez
  - Ne: Kart hızı değiştirmez. Scale aynı.
  - Kabul: Kart hızı değiştirmez. Fark 0. Test: hız.
  - Bağımlılık: TEK-22. Boyut: S.
  - Dosya: `src/arayuz/koy_ekrani.gd`
  - Asset: asset gerekmedi.


### 22.6 Kayıt

- [ ] **YSM-44:** Değerler kişi kaydındadır
  - Ne: Değerler kişi kaydındadır. Ayrı `yasam.json` kökü yok.
  - Kabul: Değerler kişi kaydındadır. Kök 0. Test: tarama.
  - Bağımlılık: KAY-04. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **YSM-45:** Yükleme düşüşü tekrarlamaz
  - Ne: Yükleme düşüşü tekrarlamaz. Delta 0.
  - Kabul: Yükleme düşüşü tekrarlamaz. 0. Test: SYS-02.
  - Bağımlılık: SYS-02. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **YSM-46:** Eski kayıt orta değer sayılır
  - Ne: Eski kayıt orta değer sayılır. Alan yoksa başlangıç, çökme 0.
  - Kabul: Eski kayıt orta değer sayılır. Açılış 1. Test: KAY.
  - Bağımlılık: KAY-04. Boyut: S.
  - Dosya: `src/sistemler/kayit_gocu.gd`
  - Asset: asset gerekmedi.

- [ ] **YSM-47:** İkiz gece aynı düşüşü verir
  - Ne: İkiz gece aynı düşüşü verir. Tohum eşit.
  - Kabul: İkiz gece aynı düşüşü verir. Eşit. Test: ikiz.
  - Bağımlılık: YSM-01. Boyut: S.
  - Dosya: `tests/oto/yasam_ikiz.tscn`
  - Asset: asset gerekmedi.


- [ ] **YSM-51:** Ölçüm DEN satırıdır
  - Ne: Ölçüm DEN satırıdır. Aç oranı. Formül değişmez.
  - Kabul: Ölçüm DEN satırıdır. Satır 1. Test: DEN.
  - Bağımlılık: DEN-05. Boyut: S.
  - Dosya: `src/sistemler/denge_olcumu.gd`
  - Asset: asset gerekmedi.


### 22.7 İş çarpanı

- [ ] **YSM-52:** İş verimi tek çarpanda birleşir
  - Ne: Açlık, yorgunluk, mevsim çarpımları çarpılır, toplanmaz.
  - Kabul: Toplam formül 0. Test: birim.
  - Bağımlılık: YSM-02 Boyut: S.
  - Dosya: `src/koy/uretim.gd`
  - Asset: asset gerekmedi.

- [ ] **YSM-53:** Çarpan tabanı 0.4'ün altına inmez
  - Ne: Çarpan tabanı 0.4'ün altına inmez. `carpan_alt` koy.tres.
  - Kabul: Çarpan tabanı 0.4'ün altına inmez. Altı 0. Test: birim.
  - Bağımlılık: YSM-02. Boyut: S.
  - Dosya: `data/ayarlar/koy.tres`
  - Asset: asset gerekmedi.

- [ ] **YSM-54:** Usta çarpanı flag'dedir
  - Ne: `usta` 1.3. YSM ikinci usta çarpanı yazmaz.
  - Kabul: Kaynak 1. Test: tarama.
  - Bağımlılık: UZM-04 Boyut: S.
  - Dosya: `data/ayarlar/koy.tres`
  - Asset: asset gerekmedi.

- [ ] **YSM-55:** Bitkin çarpanı sıfır üretmez
  - Ne: Alt taban korunur. Ölüm yine sağlık eşiği.
  - Kabul: Üretim ≥ taban. Test: birim.
  - Bağımlılık: YSM-02 Boyut: S.
  - Dosya: `src/koy/uretim.gd`
  - Asset: asset gerekmedi.

- [ ] **YSM-56:** Dinlenen çarpan almaz
  - Ne: Dinlenen çarpan almaz. Üretim 0, çarpan hesabı yok.
  - Kabul: Dinlenen çarpan almaz. Çağrı 0. Test: YSM-03.
  - Bağımlılık: YSM-03. Boyut: S.
  - Dosya: `src/koy/uretim.gd`
  - Asset: asset gerekmedi.

- [ ] **YSM-57:** Greve giden çarpan almaz
  - Ne: Greve giden çarpan almaz. Üretim 0.
  - Kabul: Greve giden çarpan almaz. 0. Test: ISG.
  - Bağımlılık: ISG-02. Boyut: S.
  - Dosya: `src/koy/meslek_grevi.gd`
  - Asset: asset gerekmedi.

- [ ] **YSM-58:** Çarpan kod sabiti değildir
  - Ne: Çarpan kod sabiti değildir. Dosya.
  - Kabul: Çarpan kod sabiti değildir. Sabit 0. Test: tarama.
  - Bağımlılık: DEN-01. Boyut: S.
  - Dosya: `data/ayarlar/koy.tres`
  - Asset: asset gerekmedi.

- [ ] **YSM-59:** Çarpan HUD'da görünmez
  - Ne: Çarpan HUD'da görünmez. Oyuncu kelimeyi görür, çarpanı değil.
  - Kabul: Çarpan yazısı 0. Test: ekran.
  - Bağımlılık: YSM-01. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/`
  - Asset: asset gerekmedi.


### 22.8 Söz ve nöbet

- [ ] **YSM-60:** Aç köylü sözü değişir
  - Ne: DIY bağlam anahtarı `aclik`. Motor ikinci cümle üretmez.
  - Kabul: Anahtar 1. Test: DIY-09.
  - Bağımlılık: DIY-09 Boyut: S.
  - Dosya: `src/soz/soz_motoru.gd`
  - Asset: asset gerekmedi.


- [ ] **YSM-62:** Açlık dedikodusu tanık ister
  - Ne: Açlık dedikodusu tanık ister. Tanıksız kayıt 0.
  - Kabul: Açlık dedikodusu tanık ister. 0. Test: DIY-13.
  - Bağımlılık: DIY-13. Boyut: S.
  - Dosya: `src/sistemler/soylenti_agi.gd`
  - Asset: asset gerekmedi.

- [ ] **YSM-63:** Ölüm sabah satırıdır
  - Ne: Ölüm sabah satırıdır. SAB. İkinci ölüm cümlesi yok.
  - Kabul: Ölüm sabah satırıdır. Satır 1. Test: SAB-01.
  - Bağımlılık: SAB-01. Boyut: S.
  - Dosya: `src/koy/sabah_defteri.gd`
  - Asset: asset gerekmedi.


- [ ] **YSM-66:** Açlık zarı değiştirmez
  - Ne: ZAR formu aynı. Yorgunluk yaklaşım eki dosyadaysa ZAR-04 tablosundadır, YSM içi ek 0.
  - Kabul: İç ek 0. Test: tarama.
  - Bağımlılık: ZAR-04 Boyut: S.
  - Dosya: `src/soz/zar_atisi.gd`
  - Asset: asset gerekmedi.

- [ ] **YSM-67:** Aç çocuk işe zorlanmaz
  - Ne: Aç çocuk işe zorlanmaz. Uyarı 1, atama 0.
  - Kabul: Aç çocuk işe zorlanmaz. 0. Test: UZM-08.
  - Bağımlılık: UZM-08. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.


### 22.9 Sınır


- [ ] **YSM-69:** Yeni bar sınıfı yoktur
  - Ne: Yeni bar sınıfı yoktur. `barlar.gd` dört bar durur.
  - Kabul: Beşinci 0. Test: tarama.
  - Bağımlılık: YSM-01. Boyut: S.
  - Dosya: `src/koy/barlar.gd`
  - Asset: asset gerekmedi.


- [ ] **YSM-74:** Oyuncu açlık barı yoktur
  - Ne: Muhafız yorgunluğu UZM-14. Açlık köylüdedir.
  - Kabul: Oyuncu açlık alanı 0. Test: tarama.
  - Bağımlılık: UZM-14 Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.


### 22.10 Kapanış

- [ ] **YSM-76:** Dört köy barı durur
  - Ne: Halk, ordu, soylu, tüccar. YSM onları kişi değerine çevirmez.
  - Kabul: Yazım yönü tek: kişi kendi alanına. Test: tarama.
  - Bağımlılık: YSM-01 Boyut: S.
  - Dosya: `src/koy/barlar.gd`
  - Asset: asset gerekmedi.

- [ ] **YSM-77:** Kişi değeri bar eşiğini tek başına kırmaz
  - Ne: Kişi değeri bar eşiğini tek başına kırmaz. Kırılma hâlâ bar fonksiyonundadır.
  - Kabul: Kişi 0 iken bar kırılması otomatik 0. Test: birim.
  - Bağımlılık: YSM-01. Boyut: S.
  - Dosya: `src/koy/barlar.gd`
  - Asset: asset gerekmedi.


- [ ] **YSM-79:** Olay kartı ikinci açlık yazmaz
  - Ne: Olay kartı ikinci açlık yazmaz. `OlayVerisi` yeni alan almaz.
  - Kabul: Olay kartı ikinci açlık yazmaz. Alan 0. Test: OZL-30.
  - Bağımlılık: OZL-30. Boyut: S.
  - Dosya: `src/veri/olay_verisi.gd`
  - Asset: asset gerekmedi.

- [ ] **YSM-80:** Divan moral cezası CAS'tadır
  - Ne: Divan moral cezası CAS'tadır. YSM ceza tablosu açmaz.
  - Kabul: Divan moral cezası CAS'tadır. Tablo 0. Test: tarama.
  - Bağımlılık: CAS-07. Boyut: S.
  - Dosya: `src/kapi/divan_hukmu.gd`
  - Asset: asset gerekmedi.


- [ ] **YSM-82:** Kapı kararı kişiyi anında doyurmaz
  - Ne: Etki gece çözümünde, kabul anında değil.
  - Kabul: Anında delta 0. Test: kabul.
  - Bağımlılık: YSM-02 Boyut: S.
  - Dosya: `src/arayuz/kapi_ekrani.gd`
  - Asset: asset gerekmedi.

- [ ] **YSM-83:** Kapanış altı iddiayı koşar
  - Ne: Üç kademe, bitkin işe yazılmaz, ev uykusu yorgunluğu siler, ikinci tüketim 0, kartta sayı 0, wav 0.
  - Kabul: Altı iddia. Test: `tests/unit/koy/yasam_test.gd`.
  - Bağımlılık: YSM-01 Boyut: S.
  - Dosya: `tests/unit/koy/yasam_test.gd`
  - Asset: asset gerekmedi.


DNY-01 … DNY-04 gövdesi durur. Yeni maddeler DNY-05 … DNY-84. İkinci harita ve altıncı son yok.

### 23.1 Çizelge

- [ ] **DNY-01:** Dünya zaman çizelgesi.
  - Amaç: Dünya zaman çizelgesi.
  - Kurallar:
    1. `data/dunya/zaman_cizelgesi.json` altı olayı taşır: Moğol ilerleyişi, Selçuklu taht kavgası, Bizans uç baskısı, kıtlık yılı, salgın dalgası, ticaret yolunun kapanması.
    2. Her olayın üç evresi vardır: erken söylenti, kesin haber, etki. Evre günü, mevcut mevsim yılının içindedir. Bu madde yeni bir yıl uzunluğu yazmaz.
    3. Moğol ilerleyişinin günleri HAR-02 sayacından okunur. Çizelge ikinci bir "kalan gün" tutmaz.
    4. Etki evresi gelince çağrı DNY-03'edir. Çizelge bar, kasa veya nüfus değiştirmez.
  - Uç durumlar: kayıt olayın ortasında açılırsa evre kaldığı günden sürer. İki olay aynı gün söylentiye girebilir. Etki evreleri aynı güne denk gelirse o gece tek etki yazılır, öbürü bir sonraki geceye kalır.
  - Kabul: üç mevsim yılı boyunca altı olay, dosyadaki sırayla üç evreyi de gezer. Test: HAR-02 kalan günü ile çizelgedeki Moğol günü aynı sayıdır; çizelgede ayrı sayaç alanı yoktur. Taşınan kontroller: DNY-69: Yasak sahne yoktur (Import 0.); DNY-70: İkinci harita yoktur (Yeni sahne 0.).
  - Bağımlılık: YAZ-01. Boyut: M.
  - Dosya: yeni `src/sistemler/dunya_zamani.gd`.
  - Asset: asset gerekmedi.

- [ ] **DNY-05:** Çizelge tek dosyadadır
  - Ne: DNY-01. Olay yılı kodda gömülü değildir.
  - Kabul: `.gd` içinde 1240 sabiti 0. Test: tarama.
  - Bağımlılık: DNY-01 Boyut: S.
  - Dosya: `data/dunya/cizelge.json`
  - Asset: asset gerekmedi.

- [ ] **DNY-06:** Çizelge kitapla çelişirse kitap kazanır
  - Ne: YAZ-01 olgusu farklıysa çizelge satırı reddedilir.
  - Kabul: Çelişki 1 hata. Test: kapı.
  - Bağımlılık: YAZ-01 Boyut: S.
  - Dosya: `docs/dunya_kitabi/`
  - Asset: asset gerekmedi.


- [ ] **DNY-08:** Aynı işaret iki kez düşmez
  - Ne: Aynı işaret iki kez düşmez. `tek_sefer` dünya olayı.
  - Kabul: İkinci düşüş 0. Test: birim.
  - Bağımlılık: DNY-01. Boyut: S.
  - Dosya: `src/sistemler/`
  - Asset: asset gerekmedi.


- [ ] **DNY-11:** İşaret kayda optional yazılır
  - Ne: İşaret kayda optional yazılır. Eski kayıt boş.
  - Kabul: İşaret kayda optional yazılır. Çökme 0. Test: KAY.
  - Bağımlılık: KAY-04. Boyut: S.
  - Dosya: `src/sistemler/kayit_gocu.gd`
  - Asset: asset gerekmedi.


### 23.2 Haber

- [ ] **DNY-02:** Haber önce insanlardan duyulur.
  - Amaç: Haber önce insanlardan duyulur.
  - Kurallar:
    1. Erken söylenti ve kesin haber, "Yolda ne gördün" konusunda ve köy dedikodusunda durur. Etki evresinden önce en az iki ayrı karakter satırı vardır.
    2. Satırlar YAZ içeriğidir. Aynı olay kimliği için iki satırın metni birebir aynı olamaz.
    3. Dedikodu DIY-13 üzerinden fısıltıya gider. Bu madde gazete üretmez.
    4. Gözcü (HAR-06, HAR-13) ertesi günkü kafileyi söyler. Dünya haberi gözcü kulesinden açılmaz.
  - Uç durumlar: o gün kapıya kimse gelmezse söylenti bir sonraki gelişe kalır ve etki evresi öne çekilmez. Köyde konuşacak kimse yoksa satır 0'dır, etki yine de DNY-01 gününü bekler.
  - Kabul: etki evresinden önceki pencerede aynı olay için en az 2 satır vardır ve bu satırlar birbirinin kopyası değildir. Test: gözcü özeti açıkken dünya olay satırı sayısı artmaz. Taşınan kontroller: DNY-20: Haber sesi yoktur (Sayı aynı.); DNY-71: Ses yoktur (Sayı aynı.).
  - Bağımlılık: DNY-01, DIY-03, DIY-13. Boyut: M.
  - Dosya: `src/soz/baglam_sorgusu.gd` alanı; içerik YAZ.
  - Asset: asset gerekmedi.

- [ ] **DNY-13:** Haber önce ağızdan gelir
  - Ne: DNY-02. Yazılı satır yüz geldikten sonra susar.
  - Kabul: Yüz varsa yazılı 0. Test: OMR-36.
  - Bağımlılık: OMR-36 Boyut: S.
  - Dosya: `src/koy/haberci_agi.gd`
  - Asset: asset gerekmedi.

- [ ] **DNY-14:** İki ağız aynı olayı farklı söyler
  - Ne: Biri `dogru=false` olabilir. SOY-25. İkinci haber kanalı yok.
  - Kabul: İki satır. Test: SOY-25.
  - Bağımlılık: SOY-25 Boyut: S.
  - Dosya: `src/sistemler/soylenti_agi.gd`
  - Asset: asset gerekmedi.

- [ ] **DNY-15:** Yazılı haber 1 veya 2 gece öndedir
  - Ne: OMR kuralı. Bu madde ikinci saat yazmaz.
  - Kabul: Fark 1 veya 2. Test: OMR.
  - Bağımlılık: DNY-02 Boyut: S.
  - Dosya: `src/koy/haberci_agi.gd`
  - Asset: asset gerekmedi.

- [ ] **DNY-16:** Haberci paneli duran dosyadır
  - Ne: `haberci_anlati_paneli.gd`. Yeni panel yok.
  - Kabul: Dosya 1. Test: sayım.
  - Bağımlılık: DNY-02 Boyut: S.
  - Dosya: `src/arayuz/koy_hud/haberci_anlati_paneli.gd`
  - Asset: asset gerekmedi.


- [ ] **DNY-18:** Haber kaynağı köyde vardır
  - Ne: Haber kaynağı köyde vardır. Uydurma ad 0. BUG-17.
  - Kabul: Ad yoksa satır 0. Test: BUG-17.
  - Bağımlılık: BUG-17. Boyut: S.
  - Dosya: `src/koy/haberci_agi.gd`
  - Asset: asset gerekmedi.

- [ ] **DNY-19:** Haber barı tek başına kırmaz
  - Ne: Kamuoyu eşiği SOY-13. Haber satırı delta 0.
  - Kabul: Delta 0. Test: SOY-13.
  - Bağımlılık: SOY-13 Boyut: S.
  - Dosya: `src/koy/barlar.gd`
  - Asset: asset gerekmedi.


### 23.3 Köy etkisi

- [ ] **DNY-03:** Olayların köye etkisi.
  - Amaç: Olayların köye etkisi.
  - Kurallar:
    1. Her olayın tek kapısı dosyada yazılıdır. Eşleme: Moğol ilerleyişi → tehdit (HAR-02); Selçuklu taht kavgası → gelen akışı (KAP-16); Bizans uç baskısı → haraç (HAR-03); kıtlık yılı → tüketim (EKO-09); salgın dalgası → sağlık yöneticisi (KRI); ticaret yolunun kapanması → fiyat (TUC-09). KRI-06, erzak bitince kendi koşuluyla çalışır; kıtlık yılı ona ikinci kez yazmaz.
    2. Salgın dalgası yeni hastalık türü açmaz. Kıtlık yılı yeni isyan kurmaz. Ticaret yolunun kapanması yeni pazar kurmaz.
    3. Gece raporunda etki, olay kimliğiyle tek satırdır.
    4. KAP-16 göç dalgasını kendi zarının üstüne ikinci kez atmaz; bu maddenin yazdığı çarpanı okur.
  - Uç durumlar: kapısı listede olmayan olay etki evresine gelince rapor "yazılmadı" der ve bar değiştirmez. Aynı gece DNY-01'in ertelediği ikinci olay bir sonraki gecenin tek satırıdır.
  - Kabul: altı olayın her biri için bir etki testi, tam bir kapıya yazar. Test: iki kapılı bir olay satırı doğrulayıcıda 1 hatadır; salgın olayından sonra hastalık türü sayısı değişmez.
  - Bağımlılık: DNY-01, KAP-16. Boyut: M.
  - Dosya: yeni `src/sistemler/dunya_etkisi.gd`.
  - Asset: asset gerekmedi.

- [ ] **DNY-21:** Dünya olayı köy etkisini dosyadan alır
  - Ne: DNY-03. Etki `OlayVerisi` şemasındadır, yeni anahtar yok.
  - Kabul: Alan sayısı aynı. Test: OZL-30.
  - Bağımlılık: OZL-30 Boyut: S.
  - Dosya: `src/veri/olay_verisi.gd`
  - Asset: asset gerekmedi.


- [ ] **DNY-23:** Kıtlık haberi ambarı kendiliğinden boşaltmaz
  - Ne: Kıtlık haberi ambarı kendiliğinden boşaltmaz. Etki kart seçimine bağlıdır.
  - Kabul: Seçimsiz delta 0. Test: birim.
  - Bağımlılık: DNY-03. Boyut: S.
  - Dosya: `data/olaylar/kitlik.tres`
  - Asset: asset gerekmedi.

- [ ] **DNY-24:** Salgın haberi hastalığı başlatmaz
  - Ne: Salgın haberi hastalığı başlatmaz. KRI kendi eşiği. Haber yalnız söz.
  - Kabul: Hastalık çağrısı 0 haber anında. Test: tarama.
  - Bağımlılık: DNY-03. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **DNY-25:** Vergi haberi vergi panelini açar
  - Ne: Vergi haberi vergi panelini açar. `vergi_paneli.gd`. Yeni vergi yok.
  - Kabul: Panel 1, yeni sınıf 0. Test: sayım.
  - Bağımlılık: DNY-03. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/vergi_paneli.gd`
  - Asset: asset gerekmedi.

- [ ] **DNY-26:** Etki bir kez yazılır
  - Ne: Etki bir kez yazılır. Aynı işaret ikinci gece delta 0.
  - Kabul: Etki bir kez yazılır. Delta 1. Test: birim.
  - Bağımlılık: DNY-03. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.


- [ ] **DNY-28:** Etki ölçümü DEN satırıdır
  - Ne: Etki ölçümü DEN satırıdır. Formül değişmez.
  - Kabul: Etki ölçümü DEN satırıdır. Satır 1. Test: DEN.
  - Bağımlılık: DEN-05. Boyut: S.
  - Dosya: `src/sistemler/denge_olcumu.gd`
  - Asset: asset gerekmedi.


### 23.4 Kararın dönüşü

- [ ] **DNY-04:** Oyuncunun kararları dünyaya geri döner.
  - Amaç: Oyuncunun kararları dünyaya geri döner.
  - Kurallar:
    1. Koşulu değişen kararlar üçtür: Tekfur haracı (HAR-03), Moğol elçisi, Türkmen beyiyle ittifak (HAR-07). Başka karar bu dosyaya kendiliğinden yazılmaz.
    2. Karar kaydı çizelgede sonraki olayın koşul alanına girer. Nihai sonlar SYS-20 bu kaydı okur. Altıncı son açılmaz.
    3. Karar verilmemiş durum da bir değerdir: `bekliyor`. Boş alan sonraki olayı düşürmez, koşul "karar yok" dalını kullanır.
  - Uç durumlar: aynı karara iki kez basılırsa kayıt son değeri tutar, çizelge iki kez ilerlemez. Heyet konuşması KOP-02'dedir; bu madde ikinci bir heyet diyaloğu yazmaz.
  - Kabul: iki farklı karar dizisi, aynı tohumda iki farklı olay sırası üretir. Test: SYS-20 son kimliği hâlâ beş değerden biridir; `bekliyor` ile biten kayıt hata vermez. Taşınan kontroller: DNY-72: Kalp yoktur (Hata.).
  - Bağımlılık: DNY-01. Boyut: M.
  - Dosya: `src/sistemler/dunya_zamani.gd`.
  - Asset: asset gerekmedi.

- [ ] **DNY-29:** Karar dünyaya işaret yazar
  - Ne: DNY-04. İşaret çizelge kimliğidir, yeni son değildir.
  - Kabul: Son kümesi 5. Test: SYS-20.
  - Bağımlılık: SYS-20 Boyut: S.
  - Dosya: `data/dunya/cizelge.json`
  - Asset: asset gerekmedi.

- [ ] **DNY-30:** İşaret en çok bir gecede bir
  - Ne: İşaret en çok bir gecede bir. İki karar aynı işareti iki kez açmaz.
  - Kabul: İşaret en çok bir gecede bir. İşaret 1. Test: birim.
  - Bağımlılık: DNY-04. Boyut: S.
  - Dosya: `src/sistemler/`
  - Asset: asset gerekmedi.

- [ ] **DNY-31:** Red ve kabul farklı işaret olabilir
  - Ne: Red ve kabul farklı işaret olabilir. Aynı işaret zorlanmaz. Dosyada iki dal.
  - Kabul: Red ve kabul farklı işaret olabilir. Dal 2. Test: fixtures.
  - Bağımlılık: DNY-04. Boyut: S.
  - Dosya: `data/dunya/cizelge.json`
  - Asset: asset gerekmedi.

- [ ] **DNY-32:** İşaret sözde okunur
  - Ne: DIY-09 anahtarı `dunya.<id>`. Motor ikinci cümle üretmez.
  - Kabul: Anahtar 1. Test: DIY-09.
  - Bağımlılık: DIY-09 Boyut: S.
  - Dosya: `src/soz/soz_motoru.gd`
  - Asset: asset gerekmedi.


- [ ] **DNY-34:** İşaret köylü ağzından döner
  - Ne: En az bir kişi dosyasında dal. Yoksa yalnız yazılı haber.
  - Kabul: Dal veya haber 1. Test: birim.
  - Bağımlılık: DNY-02 Boyut: S.
  - Dosya: `data/soz/`
  - Asset: asset gerekmedi.

- [ ] **DNY-35:** İşaret perde 2 dalgasına kalır
  - Ne: İşaret perde 2 dalgasına kalır. OMR dalga dışına çıkmaz.
  - Kabul: Dalga dışı 0. Test: OMR.
  - Bağımlılık: DNY-04. Boyut: S.
  - Dosya: `src/koy/perde_gecisi.gd`
  - Asset: asset gerekmedi.

- [ ] **DNY-36:** İşaret kaydı optional
  - Ne: İşaret kaydı optional. Eski kayıt işaretsiz açılır.
  - Kabul: İşaret kaydı optional. Çökme 0. Test: KAY.
  - Bağımlılık: KAY-04. Boyut: S.
  - Dosya: `src/sistemler/kayit_gocu.gd`
  - Asset: asset gerekmedi.


### 23.5 Duran hatlar

- [ ] **DNY-37:** Moğol sayacı HAR-02'dir
  - Ne: Moğol sayacı HAR-02'dir. DNY ikinci sayaç açmaz.
  - Kabul: Moğol sayacı HAR-02'dir. Sayaç 1. Test: tarama.
  - Bağımlılık: HAR-02. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **DNY-38:** Tekfur hattı kendi dosyasındadır
  - Ne: `tekfur_elcisi.tres`. Yeni elçi sınıfı yok.
  - Kabul: Sınıf 0 yeni. Test: sayım.
  - Bağımlılık: DNY-01 Boyut: S.
  - Dosya: `data/olaylar/tekfur_elcisi.tres`
  - Asset: asset gerekmedi.

- [ ] **DNY-39:** Sancak fermanı gece 8'dir
  - Ne: `sancak_asker_talebi`. Aralık kodda gömülü değil, duran veri.
  - Kabul: İkinci tarih 0. Test: tarama.
  - Bağımlılık: OMR Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **DNY-40:** Oba ittifakı iki geliş ister
  - Ne: İkinci geliş 4 geceden önce zorlanmaz. DIY-11 ziyaret.
  - Kabul: Ziyaret < 1 ise istek 0. Test: OMR.
  - Bağımlılık: DIY-11 Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **DNY-41:** Ahi haberi karttır
  - Ne: Ahi haberi karttır. `ahi_haber.tres`. Yeni ahi sistemi yok.
  - Kabul: Ahi haberi karttır. Sistem 0. Test: sayım.
  - Bağımlılık: DNY-01. Boyut: S.
  - Dosya: `data/olaylar/ahi_haber.tres`
  - Asset: asset gerekmedi.


- [ ] **DNY-43:** Yüz gelmeden haber gelir
  - Ne: Yüz gelmeden haber gelir. OMR. Çizelge yüzü öne çekmez.
  - Kabul: Fark 1 veya 2. Test: OMR.
  - Bağımlılık: DNY-02. Boyut: S.
  - Dosya: `src/koy/haberci_agi.gd`
  - Asset: asset gerekmedi.

- [ ] **DNY-44:** Demo perde 2 yüzünü keser
  - Ne: SRM-07. Çizelge perde 2 satırını oynatmaz.
  - Kabul: Satır 0. Test: SRM-07.
  - Bağımlılık: SRM-07 Boyut: S.
  - Dosya: `src/sistemler/demo_kesiti.gd`
  - Asset: asset gerekmedi.


### 23.6 Kadraj


- [ ] **DNY-46:** Haber metni kaydırılır
  - Ne: Haber metni kaydırılır. Kesilen glif 0.
  - Kabul: Haber metni kaydırılır. 0. Test: GRV-15.
  - Bağımlılık: GRV-15. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/haberci_anlati_paneli.gd`
  - Asset: asset gerekmedi.

- [ ] **DNY-47:** Haber köy hızını değiştirmez
  - Ne: Haber köy hızını değiştirmez. Scale aynı.
  - Kabul: Haber köy hızını değiştirmez. Fark 0. Test: hız.
  - Bağımlılık: TEK-22. Boyut: S.
  - Dosya: `src/arayuz/koy_ekrani.gd`
  - Asset: asset gerekmedi.

- [ ] **DNY-48:** Haber kapıda karar vermez
  - Ne: Haber kapıda karar vermez. Okumak kabul değildir.
  - Kabul: Karar deltası 0. Test: birim.
  - Bağımlılık: KAP-16. Boyut: S.
  - Dosya: `src/arayuz/kapi_ekrani.gd`
  - Asset: asset gerekmedi.

- [ ] **DNY-49:** Eksik anahtar haberi düşürmez
  - Ne: Eksik anahtar haberi düşürmez. Nötr satır.
  - Kabul: Eksik anahtar haberi düşürmez. Çökme 0. Test: SYS-09.
  - Bağımlılık: SYS-09. Boyut: S.
  - Dosya: `src/koy/haberci_agi.gd`
  - Asset: asset gerekmedi.


- [ ] **DNY-51:** Haber balonu yoktur
  - Ne: Haber balonu yoktur. 3B üstü yazı 0.
  - Kabul: Haber balonu yoktur. 0. Test: SOY-31.
  - Bağımlılık: SOY-31. Boyut: S.
  - Dosya: `src/koy/gorsel/`
  - Asset: asset gerekmedi.


### 23.7 Takvim sınırı


- [ ] **DNY-54:** Mevsim çizelgeyi kaydırmaz
  - Ne: Kış olayı kışa çekilmez, günü sabittir. Dosya günü.
  - Kabul: Gün aynı. Test: kış.
  - Bağımlılık: DNY-01 Boyut: S.
  - Dosya: `data/dunya/cizelge.json`
  - Asset: asset gerekmedi.

- [ ] **DNY-55:** Boş gün haberi silmez
  - Ne: KAP-16 gecesinde yazılı haber durur, yüz gelmez.
  - Kabul: Yüz 0, satır 1. Test: boş gün.
  - Bağımlılık: KAP-16 Boyut: S.
  - Dosya: `src/koy/haberci_agi.gd`
  - Asset: asset gerekmedi.


- [ ] **DNY-58:** Yıl izi çizelge değildir
  - Ne: Yıl izi çizelge değildir. YIL kişi satırı. DNY onu kopyalamaz.
  - Kabul: Yıl izi çizelge değildir. Kopya 0. Test: YIL-01.
  - Bağımlılık: YIL-01. Boyut: S.
  - Dosya: `src/koy/yil_izi.gd`
  - Asset: asset gerekmedi.

- [ ] **DNY-59:** Olay olasılığı çizelgeyi ezmez
  - Ne: `olay_olasiligi` dünya işaretini silmez. İşaret ayrı kapı.
  - Kabul: İşaret olasılıktan bağımsız 1. Test: birim.
  - Bağımlılık: DEN-01 Boyut: S.
  - Dosya: `data/ayarlar/oyun.tres`
  - Asset: asset gerekmedi.

- [ ] **DNY-60:** İkiz çizelge aynı günde düşer
  - Ne: Tohum yüzün gününü kaydırabilir, işareti silemez.
  - Kabul: İşaret günü eşit. Test: ikiz.
  - Bağımlılık: DNY-01 Boyut: S.
  - Dosya: `tests/oto/dunya_ikiz.tscn`
  - Asset: asset gerekmedi.


### 23.8 Kayıt

- [ ] **DNY-61:** Kayıt işaret listesidir
  - Ne: Kayıt işaret listesidir. Düz metin gömülmez.
  - Kabul: Cümle alanı 0. Test: tarama.
  - Bağımlılık: KAY-04. Boyut: S.
  - Dosya: `src/sistemler/`
  - Asset: asset gerekmedi.

- [ ] **DNY-62:** Yükleme etkiyi tekrarlamaz
  - Ne: Yükleme etkiyi tekrarlamaz. Delta 0.
  - Kabul: Yükleme etkiyi tekrarlamaz. 0. Test: SYS-02.
  - Bağımlılık: SYS-02. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **DNY-63:** Eski kayıt çizelgesiz açılır
  - Ne: İşaretler yeni oyundan işler, geçmiş gece zorlanmaz.
  - Kabul: Geçmişe sarma 0. Test: KAY.
  - Bağımlılık: KAY-04 Boyut: S.
  - Dosya: `src/sistemler/kayit_gocu.gd`
  - Asset: asset gerekmedi.


- [ ] **DNY-67:** Ölçüm kaç işaret düştüğünü yazar
  - Ne: Ölçüm kaç işaret düştüğünü yazar. DEN. Formül değişmez.
  - Kabul: Ölçüm kaç işaret düştüğünü yazar. Satır 1. Test: DEN.
  - Bağımlılık: DEN-05. Boyut: S.
  - Dosya: `src/sistemler/denge_olcumu.gd`
  - Asset: asset gerekmedi.

- [ ] **DNY-68:** İkiz haber günü eşittir
  - Ne: İkiz haber günü eşittir. İki koşu.
  - Kabul: İkiz haber günü eşittir. Eşit. Test: ikiz.
  - Bağımlılık: DNY-02. Boyut: S.
  - Dosya: `tests/oto/dunya_ikiz.tscn`
  - Asset: asset gerekmedi.


### 23.9 Sınır


- [ ] **DNY-74:** Çalışma anında model yoktur
  - Ne: Çalışma anında model yoktur. HTTP 0.
  - Kabul: Çalışma anında model yoktur. 0. Test: KLT-23.
  - Bağımlılık: KLT-23. Boyut: S.
  - Dosya: `src/`
  - Asset: asset gerekmedi.


- [ ] **DNY-76:** Yeni olay kartı tavanı OZL-25'tir
  - Ne: Çizelge yeni tres açmaz, duran 34'ü okur.
  - Kabul: Yeni tres 0. Test: OZL-25.
  - Bağımlılık: OZL-25 Boyut: S.
  - Dosya: `data/olaylar/`
  - Asset: asset gerekmedi.


### 23.10 Kapanış

- [ ] **DNY-77:** Gazete dünya haberi basmaz
  - Ne: KOP-05 köy kaydıdır. Çizelge gazeteye yazmaz.
  - Kabul: Çağrı 0. Test: tarama.
  - Bağımlılık: KOP-05 Boyut: S.
  - Dosya: `src/kapi/fisilti_gazetesi.gd`
  - Asset: asset gerekmedi.


- [ ] **DNY-79:** Kapı dünya işaretini kabul saymaz
  - Ne: Kapı dünya işaretini kabul saymaz. Kabul köylü kararıdır, çizelge ayrı.
  - Kabul: Karışık delta 0. Test: birim.
  - Bağımlılık: KAP-16. Boyut: S.
  - Dosya: `src/arayuz/kapi_ekrani.gd`
  - Asset: asset gerekmedi.

- [ ] **DNY-80:** Divan çizelgeyi değiştirmez
  - Ne: Divan çizelgeyi değiştirmez. CAS üçlü karar.
  - Kabul: İşaret yazımı 0 divanda. Test: tarama.
  - Bağımlılık: CAS-07. Boyut: S.
  - Dosya: `src/kapi/divan_hukmu.gd`
  - Asset: asset gerekmedi.

- [ ] **DNY-81:** Nöbet dünyayı görmez
  - Ne: Nöbet dünyayı görmez. NBT görüşü kapı kuyruğudur.
  - Kabul: Çizelge yazımı 0. Test: tarama.
  - Bağımlılık: NBT-06. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.


- [ ] **DNY-84:** Kapanış altı iddiayı koşar
  - Ne: İşaret bir kez, haber yüzden önce, savaşsız yetim 0, altıncı son 0, ikinci harita 0, eski kayıt açılır.
  - Kabul: Altı iddia. Test: `tests/unit/sistemler/dunya_test.gd`.
  - Bağımlılık: DNY-01 Boyut: S.
  - Dosya: `tests/unit/sistemler/dunya_test.gd`
  - Asset: asset gerekmedi.


Nöbet devri ayrı dosyada Bölüm 26 olarak durur (`ROADMAP_2_BOLUM_26.md`). Bu başlık 11 Ekim 2026'da 25a oldu. Kimlikler SEV-01…07 değişmedi.

Oyun favoriyi seçmez. Aynı koşullar her çekirdekte çalışır. Burada yeni bir ekonomi, harita, romans veya kalp sayacı yoktur. Her madde duran bir sistemin üstüne oturur.

SEV-01 … SEV-07 gövdesi durur. Yeni maddeler SEV-08 … SEV-87. Kalp, romans ve hediye takvimi yok.

### 25a.1 Boş gün

- [ ] **SEV-01:** Boş gün köy günüdür.
  - Amaç: Boş gün köy günüdür.
  - Kurallar:
    1. Boş günü KAP-16 üretir. Bu madde ikinci bir "kimse gelmesin" zarı açmaz.
    2. O gün oyuncu ateş başına (ANI-07) veya bir tezgâha yürüyebilir. Orada en çok iki satır duyulur. Satır ödül, eşya veya bar vermez.
    3. Satır, orada duran bir kişinin işinden gelir (YAZ-08 köy satırı). Kişi yoksa satır da yoktur, boş meydan hataya düşmez.
    4. Gözcü boş günü bildirmeye devam eder (HAR-06/13). Gözcü kulesi yeniden kurulmaz.
  - Uç durumlar: boş gün ile oyuncunun kapıyı kapatması aynı şey değildir. Kapı kapalıysa (ACL-01 ilk gün) bu madde ateş satırını yine verebilir, kuyruk zaten yoktur. İki boş gün art arda aynı satırı tekrarlamaz. Havuzda yinelenmeyecek satır kalmadıysa o gün sessizdir.
  - Kabul: 28 günde KAP-16'nın ürettiği her boş günde ateş veya tezgâh etkileşimi açılır; etkileşim barları değiştirmez. Test: dolu günde bu etkileşim kapalıdır. Taşınan kontroller: SEV-80: Yasak sahne yoktur (Import 0.); SEV-85: İkinci harita yoktur (0.).
  - Bağımlılık: KAP-16, YAZ-08. Boyut: S.
  - Dosya: yeni `src/koy/bos_gun_durusu.gd`; ANI-07 toplanma noktasına tek etkileşim.
  - Asset: asset gerekmedi. Ateş ANI-07'de duruyor.


- [ ] **SEV-11:** Boş günde zar yoktur
  - Ne: Boş günde zar yoktur. ZAR paneli 0.
  - Kabul: Boş günde zar yoktur. 0. Test: ZAR-01.
  - Bağımlılık: ZAR-01. Boyut: S.
  - Dosya: `src/arayuz/kapi/tansiyon_gostergesi.gd`
  - Asset: asset gerekmedi.

- [ ] **SEV-12:** Boş gün kayda yazılır
  - Ne: Boş gün kayda yazılır. Tür `bos`. Eski kayıt yok sayılır.
  - Kabul: Boş gün kayda yazılır. Çökme 0. Test: KAY.
  - Bağımlılık: KAY-04. Boyut: S.
  - Dosya: `src/sistemler/kayit_gocu.gd`
  - Asset: asset gerekmedi.


### 25a.2 Ateş

- [ ] **SEV-02:** Tanıdık yüz ateşe gelir.
  - Amaç: Tanıdık yüz ateşe gelir.
  - Kurallar:
    1. Aday, köyde yaşayan adlı kişidir. Kapı kuyruğuna eklenmez, yatak ve kabul kararı istenmez.
    2. Selam `son_karar` ve bir somut anıyı kullanır (verdiğin ekmek, sorduğun ad, çevirdiğin akraba). Anı yoksa genel selam da yoktur, kişi o akşam gelmez.
    3. Kadrodan 2 veya 3 kişi Jorji tipindedir: tekrar gelir, tehlikeli değildir, yalanı varsa kolay çözülür. Bu işaret `hitap: aliskanlik` ile aynı kişidir (YAZ-09). Yeni bir kişilik sistemi açılmaz.
    4. Aynı kişi art arda iki boş olmayan akşamda zorla getirilmez. Aralık veri dosyasındadır.
  - Uç durumlar: kişi öldüyse veya köyü terk ettiyse selam gelmez. Jorji tipi kişi ret yemişse ve köyde değilse bu madde onu içeri almaz; dönüş KAP-16 ve hafıza işidir.
  - Kabul: köydeki bir kişi için `son_karar` kayıtlıyken ateş selamı o kararı anar. Test: anı silinince selam 0; kuyruk uzunluğu değişmez. Taşınan kontroller: SEV-23: Ateş sesi yoktur (Sayı aynı.); SEV-84: Seslendirme yoktur (Sayı aynı.).
  - Bağımlılık: SEV-01, DIY-11. Boyut: M.
  - Dosya: `src/koy/bos_gun_durusu.gd` genişler; `data/soz/tanidik_yuz.json`.
  - Asset: asset gerekmedi.


- [ ] **SEV-17:** Ateş kişisi köydedir
  - Ne: Ateş kişisi köydedir. Ayrılan gelemez.
  - Kabul: Ateş kişisi köydedir. Id 0. Test: BUG-17.
  - Bağımlılık: BUG-17. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **SEV-18:** Ateş günde bir kişidir
  - Ne: Ateş günde bir kişidir. İkinci yüz 0.
  - Kabul: Ateş günde bir kişidir. 1. Test: birim.
  - Bağımlılık: SEV-02. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **SEV-19:** Ateş çocuğu tek başına çağırmaz
  - Ne: Ateş çocuğu tek başına çağırmaz. Yanında yetişkin yoksa geliş 0.
  - Kabul: Ateş çocuğu tek başına çağırmaz. 0. Test: UZM-08.
  - Bağımlılık: UZM-08. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **SEV-20:** Ateş eşi her boş günde zorlamaz
  - Ne: Eş akşam sohbeti ACL-03'tedir. Aynı gece iki sahne 0.
  - Kabul: Sohbet 1. Test: ACL-03.
  - Bağımlılık: ACL-03 Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **SEV-21:** Ateş sözü bir daldır
  - Ne: Ateş sözü bir daldır. DIY dosyası. Yeni motor yok.
  - Kabul: Sınıf 0 yeni. Test: DIY-02.
  - Bağımlılık: DIY-02. Boyut: S.
  - Dosya: `src/soz/soz_motoru.gd`
  - Asset: asset gerekmedi.

- [ ] **SEV-22:** Ateş sahnesi 3B tören değildir
  - Ne: Ateş sahnesi 3B tören değildir. Duran köy kadrajı.
  - Kabul: Sahne yeni 0. Test: tarama.
  - Bağımlılık: SEV-02. Boyut: S.
  - Dosya: `src/koy/gorsel/`
  - Asset: asset gerekmedi.


### 25a.3 İz

- [ ] **SEV-03:** Kişisel iz köyde kalır.
  - Amaç: Kişisel iz köyde kalır.
  - Kurallar:
    1. İz, heybede zaten duran `Clue_*` eşyasının küçük yer tutucusudur. Yeni heybe motoru yok.
    2. Yer, kişinin iş binasıdır (ağıl direği, tezgâh kenarı). Bina yoksa iz evin yanında durur, bina kendiliğinden kurulmaz.
    3. Rüşvetle alınan eşya muhafız odasındaki mevcut raftadır (ODA-03). Raf yeniden yazılmaz. O eşyanın etiketi ekşidir. Gönüllü verilen lokmanın etiketi sıcaktır. İkisi de aynı raftadır, ikinci envanter açılmaz.
    4. Kişi ölünce veya temelli gidince iz kalkar (SEV-07).
  - Uç durumlar: aynı eşya hem köy izi hem oda rafı olamaz. Rüşvet eşyası köyde ikinci kopya bırakmaz. İz, üretim vermez.
  - Kabul: CHR_017 kabul ve sır çözülmüşken kurdele ağıl yerinde görünür. Rüşvet eşyası yalnız odada ve ekşi etikettedir. Test: kişi köyden düşünce iz 0.
  - Bağımlılık: DIY-11, SEV-07. Boyut: M.
  - Dosya: yeni `src/koy/kisisel_iz.gd`; ODA-03 rafına etiket adaptörü.
  - Asset: iz yer tutucusu envantere `SEV03-IZ`; düz renk küçük kutu. Oda rafı için yeni model yok.


- [ ] **SEV-25:** İz bir kişide bir tanedir
  - Ne: İz bir kişide bir tanedir. İkinci iz aynı id'ye yazılmaz.
  - Kabul: İz bir kişide bir tanedir. İz 1. Test: birim.
  - Bağımlılık: SEV-03. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.


- [ ] **SEV-27:** İz iş noktasıdır
  - Ne: İz iş noktasıdır. Tezgâh veya tarla. Yeni nokta türü yok.
  - Kabul: İz iş noktasıdır. Tür 2. Test: sayım.
  - Bağımlılık: SEV-03. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **SEV-28:** İz otomatik işçi almaz
  - Ne: İz otomatik işçi almaz. Boş yer ISG doldurmaz o gün.
  - Kabul: İz otomatik işçi almaz. Atama 0. Test: ISG-02.
  - Bağımlılık: ISG-02. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **SEV-29:** İz kartta bir kelimedir
  - Ne: İz kartta bir kelimedir. Sayı değil.
  - Kabul: İz kartta bir kelimedir. Sayı 0. Test: ekran.
  - Bağımlılık: SEV-03. Boyut: S.
  - Dosya: `src/arayuz/koylu_karti.gd`
  - Asset: asset gerekmedi.

- [ ] **SEV-30:** İz kaydı optional
  - Ne: İz kaydı optional. Eski kayıt izsiz.
  - Kabul: İz kaydı optional. Çökme 0. Test: KAY.
  - Bağımlılık: KAY-04. Boyut: S.
  - Dosya: `src/sistemler/kayit_gocu.gd`
  - Asset: asset gerekmedi.


### 25a.4 Tek istek

- [ ] **SEV-04:** Tek istek.
  - Amaç: Tek istek.
  - Kurallar:
    1. Kişi köye yerleştikten sonra bir kez, bir cümleyle bir şey ister. İstek `gun_min` ve `gun_max` taşır.
    2. Tutmak isteğe bağlıdır. Tutulmazsa süre bitince bir satır değişir. Ceza barı, yeni düşman veya zorunlu görev doğmaz.
    3. Aynı anda oyuncunun önünde en çok bir istek cümlesi durur. Günlük yok, harita işareti yok.
    4. İstek, muhafızın verdiği söz değildir (DYL-05). Karışmaz. DYL-05 muhafızın borcudur, bu maddenin isteği köylünündür.
  - Uç durumlar: süre dolmadan kişi ölürse istek sessizce kapanır. İstek, olmayan bir binayı şart koşamaz. Şart olan bina yoksa istek hiç açılmaz.
  - Kabul: bir test kişisinde istek bir kez konuşulur, süre bitince satır değişir, ikinci istek açılmaz. Test: görev listesi düğümü yok. Taşınan kontroller: SEV-83: Hediye takvimi yoktur (0.).
  - Bağımlılık: YAZ-08, DIY-11. Boyut: S.
  - Dosya: yeni `src/koy/tek_istek.gd`; `data/soz/istekler.json`.
  - Asset: asset gerekmedi.


- [ ] **SEV-32:** Tek istek SEV-04'tür
  - Ne: Tek istek SEV-04'tür. İkinci istek aynı ziyarette yok.
  - Kabul: Tek istek SEV-04'tür. İstek 1. Test: SEV-04.
  - Bağımlılık: SEV-04. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **SEV-33:** İstek kapı kararı değildir
  - Ne: İstek kapı kararı değildir. Kabul veya ret açmaz.
  - Kabul: Karar deltası 0. Test: KAP.
  - Bağımlılık: KAP-16. Boyut: S.
  - Dosya: `src/arayuz/kapi_ekrani.gd`
  - Asset: asset gerekmedi.

- [ ] **SEV-34:** İstek kaynak yetmezse kapanır
  - Ne: İstek kaynak yetmezse kapanır. Bedava yok.
  - Kabul: İstek kaynak yetmezse kapanır. Kapalı 1. Test: birim.
  - Bağımlılık: SEV-04. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **SEV-35:** İstek bir kez ödüllendirilir
  - Ne: İstek bir kez ödüllendirilir. Delta 1.
  - Kabul: İstek bir kez ödüllendirilir. 1. Test: birim.
  - Bağımlılık: SEV-04. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **SEV-36:** İstek çocuk işi değildir
  - Ne: İstek çocuk işi değildir. Çocuk istek sahibi olmaz.
  - Kabul: İstek çocuk işi değildir. 0. Test: UZM-08.
  - Bağımlılık: UZM-08. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.


- [ ] **SEV-38:** Reddedilen istek kin barı açmaz
  - Ne: Reddedilen istek kin barı açmaz. Husumet dosyada +1 ise o, yeni bar yok.
  - Kabul: Yeni bar 0. Test: tarama.
  - Bağımlılık: SEV-04. Boyut: S.
  - Dosya: `src/koy/husumet.gd`
  - Asset: asset gerekmedi.


### 25a.5 Bağ

- [ ] **SEV-05:** Köylüler birbirine bağlanır.
  - Amaç: Köylüler birbirine bağlanır.
  - Kurallar:
    1. Bağ, UZM-07 kaydının dostluk ucudur. Düşman çifti bugün aynı binada üretimi durduruyor. Bu madde o kavgayı ikinci kez kurmaz.
    2. Dost çift aynı binada çalışırken verime küçük bir fark ve ateşte bir duyulan cümle yazar (SEV-01). Fark veri dosyasındadır, kodda sabit sayı yoktur.
    3. Bağ `baglar` alanından gelir (OZGUNLUK, YAZ-09). Yeni ilişki ekranı yoktur.
    4. Bağın taraflarından biri köyde değilse cümle ve verim farkı uygulanmaz.
  - Uç durumlar: düşman bağı ile dost bağ aynı çifte yazılamaz. Doğrulayıcı bunu hata sayar. Üçüncü bir kişi bağı ikiye bölmez.
  - Kabul: dost çift aynı binadayken verim tablodaki farkı alır ve ateşte bir satır duyulur. Düşman çiftte UZM-07 davranışı değişmez. Test: biri köyde değilken fark 0. Taşınan kontroller: SEV-41: Bağ kalp değildir (Hata 1.); SEV-45: Bağ hediye istemez (0.); SEV-81: Kalp yoktur (Hata.); SEV-82: Romans yoktur (Hata.).
  - Bağımlılık: YAZ-09, SEV-01. Boyut: S.
  - Dosya: `src/koy/koylu_bagi.gd` ince adaptör; UZM-07 veri kaydına `uc: dost|dusman`.
  - Asset: asset gerekmedi.

- [ ] **SEV-40:** Bağ iki kişi arasındadır
  - Ne: SEV-05. Grup itibarı DIY-12'dir, bağ onu yazmaz.
  - Kabul: İtibar yazımı 0. Test: tarama.
  - Bağımlılık: DIY-12 Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.


- [ ] **SEV-42:** Bağ en çok bir cümledir
  - Ne: Bağ en çok bir cümledir. Kartta kelime. Sayı yok.
  - Kabul: Bağ en çok bir cümledir. Sayı 0. Test: ekran.
  - Bağımlılık: SEV-05. Boyut: S.
  - Dosya: `src/arayuz/koylu_karti.gd`
  - Asset: asset gerekmedi.


- [ ] **SEV-44:** Bağ günde bir kez kurulur
  - Ne: Bağ günde bir kez kurulur. İkinci çift aynı gün 0.
  - Kabul: Bağ günde bir kez kurulur. 0. Test: birim.
  - Bağımlılık: SEV-05. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.


- [ ] **SEV-46:** Bağ söz dalı açabilir
  - Ne: Bağ söz dalı açabilir. DIY. Zorunlu dal değil.
  - Kabul: Dal yoksa hata 0. Test: fixtures.
  - Bağımlılık: DIY-03. Boyut: S.
  - Dosya: `data/soz/`
  - Asset: asset gerekmedi.

- [ ] **SEV-47:** Bağ kaydı optional
  - Ne: Bağ kaydı optional. Eski kayıt bağsız.
  - Kabul: Bağ kaydı optional. Çökme 0. Test: KAY.
  - Bağımlılık: KAY-04. Boyut: S.
  - Dosya: `src/sistemler/kayit_gocu.gd`
  - Asset: asset gerekmedi.


### 25a.6 Ad

- [ ] **SEV-06:** İsim ancak sorulunca kartta durur.
  - Amaç: İsim ancak sorulunca kartta durur.
  - Kurallar:
    1. Yüzen kart ANI-14'tür. Yeni kart yoktur.
    2. Gerçek ad sorulmuşsa (`Flag_Kimlik_Cozuldu` veya sözdeki ad beyanı) kart o ada döner.
    3. Sorulmadıysa kart maske adını gösterir. Maske, sayfadaki `Persona_Maskesi` kısa adıdır.
    4. Oyuncu adı sonradan köy sohbetinde de öğrenebilir (YAZ-08). Öğrenince kart döner. Zorla açılan bir "adı göster" düğmesi yoktur.
  - Uç durumlar: adsız figürün gerçek adı yoktur, kart sınıf adında kalır. Eşin adı açılışta bilinir, maske kuralına girmez.
  - Kabul: CHR_017 kapıda ad sorulmadan kabul edilirse kart "çoban" maskesinde kalır. Ad sorulmuş kabulde kart "Fadime" olur. Test: bayrak yokken Fadime yazısı 0.
  - Bağımlılık: DIY-11, YAZ-08. Boyut: S.
  - Dosya: ANI-14 kart metnine tek koşul.
  - Asset: asset gerekmedi.


- [ ] **SEV-50:** Adsızın gerçek adı yoktur
  - Ne: Adsızın gerçek adı yoktur. Sınıf adı kalır.
  - Kabul: Uydurma ad 0. Test: SEV-06.
  - Bağımlılık: SEV-06. Boyut: S.
  - Dosya: `src/arayuz/koylu_karti.gd`
  - Asset: asset gerekmedi.

- [ ] **SEV-51:** Eşin adı maskeye girmez
  - Ne: Eşin adı maskeye girmez. Açılışta bilinir.
  - Kabul: Eşin adı maskeye girmez. Maske 0. Test: ACL-02.
  - Bağımlılık: ACL-02. Boyut: S.
  - Dosya: `src/arayuz/koylu_karti.gd`
  - Asset: asset gerekmedi.


- [ ] **SEV-54:** Ad çevirisi YER-17'dir
  - Ne: Ad çevirisi YER-17'dir. Özel isim aynı kalır.
  - Kabul: Fark 1 uyarı. Test: YER-17.
  - Bağımlılık: YER-17. Boyut: S.
  - Dosya: `data/metin/metinler.csv`
  - Asset: asset gerekmedi.


### 25a.7 Veda

- [ ] **SEV-07:** Veda o kişiyi götürür.
  - Amaç: Veda o kişiyi götürür.
  - Kurallar:
    1. Cenaze akışı KRI-05'tir. Toplu mezar, tören ve yas süresi yeniden yazılmaz.
    2. Tören o kişinin adını söyler (SEV-06 kuralıyla bilinen ad; bilinmiyorsa maske adı).
    3. Kişisel iz kalkar (SEV-03). İşlediği tezgâh veya tarla noktası bir gün boş kalır. Yerine otomatik işçi konmaz.
    4. Yeni yas sayacı açılmaz. KRI-05'in iki günlük tavanı durur.
  - Uç durumlar: adsız figürün vedası adı olmayan bir satırdır, izi yoktur. Eşin ölümü ACL-02 yasını kullanır, bu madde onu ikinci kez yas tutturmaz. Tezgâh yoksa yalnız ad söylenir.
  - Kabul: adlı bir ölümde gece raporu adı yazar, iz 0 olur, ilgili iş noktası ertesi gün boştur. Test: KRI-05 seçenekleri (toplu mezar / tören) hâlâ iki tanedir, üçüncü seçenek yoktur. Taşınan kontroller: SEV-63: Veda sesi yoktur (Sayı aynı.).
  - Bağımlılık: SEV-03, SEV-06. Boyut: S.
  - Dosya: `src/koy/cenaze_yasi.gd` adaptör; bir satır ad, bir satır boş tezgâh.
  - Asset: asset gerekmedi. Mezar yer tutucusu KRI-05'te duruyor.

Bölüm 25a alt başlığı dörttür, onun altındadır: yedi madde dört kümeye düşer; yeni madde eklenmedi, köyde tekrar görme SEV-01…07 ile sınırlıdır.


- [ ] **SEV-58:** Veda bilinen adı söyler
  - Ne: Veda bilinen adı söyler. Maske ise maske. SEV-06.
  - Kabul: Yanlış ad 0. Test: SEV-06.
  - Bağımlılık: SEV-06. Boyut: S.
  - Dosya: `src/koy/cenaze_yasi.gd`
  - Asset: asset gerekmedi.


- [ ] **SEV-60:** Eş vedası ACL yasını kullanır
  - Ne: Eş vedası ACL yasını kullanır. SEV ikinci yas yazmaz.
  - Kabul: Yas çağrısı 1 kaynak. Test: ACL-02.
  - Bağımlılık: ACL-02. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **SEV-61:** Adsız veda adsız satırdır
  - Ne: Adsız veda adsız satırdır. İz 0.
  - Kabul: Adsız veda adsız satırdır. İz 0. Test: birim.
  - Bağımlılık: SEV-07. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **SEV-62:** Veda yeni mezar modeli istemez
  - Ne: Veda yeni mezar modeli istemez. KRI yer tutucu.
  - Kabul: Veda yeni mezar modeli istemez. png 0. Test: sayım.
  - Bağımlılık: ARY-05. Boyut: S.
  - Dosya: `docs/EKSIK_ASSET_ENVANTERI.md`
  - Asset: asset gerekmedi.


### 25a.8 Kadraj

- [ ] **SEV-64:** Boş gün HUD'u köy kadrajıdır
  - Ne: Boş gün HUD'u köy kadrajıdır. Yeni panel sınıfı 0.
  - Kabul: Boş gün HUD'u köy kadrajıdır. Sınıf 0. Test: tarama.
  - Bağımlılık: SEV-01. Boyut: S.
  - Dosya: `src/arayuz/koy_ekrani.gd`
  - Asset: asset gerekmedi.


- [ ] **SEV-66:** İstek düğmesi kapalıysa sebep vardır
  - Ne: İstek düğmesi kapalıysa sebep vardır. Sessiz kaybolma yok.
  - Kabul: İstek düğmesi kapalıysa sebep vardır. Sebep 1. Test: ekran.
  - Bağımlılık: SEV-04. Boyut: S.
  - Dosya: `src/arayuz/koy_ekrani.gd`
  - Asset: asset gerekmedi.


- [ ] **SEV-68:** Uzun satır kayar
  - Ne: Uzun satır kayar. Kesilen glif 0.
  - Kabul: Uzun satır kayar. 0. Test: GRV-15.
  - Bağımlılık: GRV-15. Boyut: S.
  - Dosya: `src/arayuz/koy_ekrani.gd`
  - Asset: asset gerekmedi.

- [ ] **SEV-69:** Esc isteği vermez
  - Ne: Esc isteği vermez. Duraklat. Delta 0.
  - Kabul: Esc isteği vermez. 0. Test: GIR-08.
  - Bağımlılık: GIR-08. Boyut: S.
  - Dosya: `src/arayuz/ana.gd`
  - Asset: asset gerekmedi.

- [ ] **SEV-70:** Hız boş günde köy kuralıdır
  - Ne: Hız boş günde köy kuralıdır. Kapı kilidi yok. Scale köyde seçilir.
  - Kabul: Kapı scale zorlaması 0. Test: hız.
  - Bağımlılık: TEK-22. Boyut: S.
  - Dosya: `src/arayuz/koy_ekrani.gd`
  - Asset: asset gerekmedi.

- [ ] **SEV-71:** Eksik anahtar günü düşürmez
  - Ne: Eksik anahtar günü düşürmez. Nötr satır.
  - Kabul: Eksik anahtar günü düşürmez. Çökme 0. Test: SYS-09.
  - Bağımlılık: SYS-09. Boyut: S.
  - Dosya: `src/arayuz/koy_ekrani.gd`
  - Asset: asset gerekmedi.


### 25a.9 Kayıt

- [ ] **SEV-72:** Kayıt optional alanlardır
  - Ne: Kayıt optional alanlardır. İz, bağ, ad bayrağı. Yoksa boş.
  - Kabul: Kayıt optional alanlardır. Çökme 0. Test: KAY.
  - Bağımlılık: KAY-04. Boyut: S.
  - Dosya: `src/sistemler/kayit_gocu.gd`
  - Asset: asset gerekmedi.

- [ ] **SEV-73:** Yükleme isteği tekrarlamaz
  - Ne: Yükleme isteği tekrarlamaz. Delta 0.
  - Kabul: Yükleme isteği tekrarlamaz. 0. Test: SYS-02.
  - Bağımlılık: SYS-02. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

- [ ] **SEV-74:** İkiz boş gün aynı gündür
  - Ne: İkiz boş gün aynı gündür. Tohum eşit.
  - Kabul: İkiz boş gün aynı gündür. Eşit. Test: ikiz.
  - Bağımlılık: KAP-16. Boyut: S.
  - Dosya: `tests/oto/bos_gun_ikiz.tscn`
  - Asset: asset gerekmedi.


- [ ] **SEV-78:** Ölçüm boş gün sayısını yazar
  - Ne: Ölçüm boş gün sayısını yazar. DEN. Formül değişmez.
  - Kabul: Ölçüm boş gün sayısını yazar. Satır 1. Test: DEN.
  - Bağımlılık: DEN-05. Boyut: S.
  - Dosya: `src/sistemler/denge_olcumu.gd`
  - Asset: asset gerekmedi.

- [ ] **SEV-79:** Ad bayrağı yüklemede açılmaz
  - Ne: Ad bayrağı yüklemede açılmaz. Sorulmadıysa maske durur.
  - Kabul: Ad bayrağı yüklemede açılmaz. Maske 1. Test: KAY.
  - Bağımlılık: SEV-06. Boyut: S.
  - Dosya: `src/arayuz/koylu_karti.gd`
  - Asset: asset gerekmedi.


### 25a.10 Kapanış


- [ ] **SEV-87:** Kapanış altı iddiayı koşar
  - Ne: Boş günde kuyruk 0, ateş kuyruğa yazılmaz, ad sorulmadan maske, veda iki seçenek, kalp 0, wav 0.
  - Kabul: Altı iddia. Test: `tests/unit/koy/sevilen_yuz_test.gd`.
  - Bağımlılık: SEV-01 Boyut: S.
  - Dosya: `tests/unit/koy/sevilen_yuz_test.gd`
  - Asset: asset gerekmedi.

