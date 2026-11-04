# Kapı Muhafızı — Diyalog & Anlatı Gece Özeti

**Kime:** Ahmet | **Ajan:** Antigravity | **Tarih:** 4 Kasım 2026, Sabah | **Dal:** `feature/diyalog-yeniden-yazim` (festive ile tam senkron, teste hazır)

## ☀️ Sabah Önce Bunu Oku (Hızlı Yol Haritası)
1. **Oyun Testi:** Önce `docs/OYUN_TESTI_KONTROL_LISTESI.md` dosyasını aç; başındaki 15 dakikalık en iyi 10 anı oyunda dene.
2. **Birleşme Onayı:** `docs/DIYALOG_DALI_BIRLESME_NOTU.md` dosyasını incele; dal festive ile tam senkronize ve testler 0 hatadır, onay verirsen festive'e birleşecek.
3. **3 Açık Karar:** `docs/KARAR_SECENEKLERI.md` içindeki 3 karardan (Banu Hatun, Molla Şükrü, Vebalı Sabi) seçimini yap; `docs/karar_yamalari/` klasöründe tek tıkla uygulamaya hazır paketleri bekliyor.
4. **Yeni Öneriler & Promptlar:** `docs/ROADMAP_ONERILERI_ANTIGRAVITY.md` (7 hazır taslak `docs/oneri_taslaklari/`) ve `docs/arayuz/DIYALOG_ASSET_PROMPTLARI.md` (57 yeni portre/kart promptu) hazır.

---

## 1. Bu Gece Ne Yapıldı? (Görev 3 → 9)

- **30 Kapı Ziyaretçisi İnsanlaştırıldı:** Kalıp ve kuru bilgi veren diyaloglar çöpe atıldı. 30 karakterin tamamına geçmiş, korku, gizli niyet, alt sorular (3 kademe), yalan/doğru dalları ve şüphe bayrakları işlendi.
- **Eş Karakteri Canlandırıldı:**
  - Kapı ekranında her ziyaretçi için 4 aşamalı eş fısıltısı ve uyarısı bağlandı (karar öncesi, kritik soru, kabul/ret kanaati).
  - Köy/oda sahnesinde eşle konuşulabilen 120+ düğümlü çok katmanlı dertleşme ağacı yazıldı (aile, geçmiş, köy dedikoduları, mevsim, ziyaretçiler).
- **Köy İçi Sohbetler (Parley):** 11 isimli köylü (Karaca Usta, Ayşe Bacı, Yusuf, Miraen, Thessra, Sorhan, Aydoğdu, Saruca Hatun, Hasan Çelebi, Nogay, Eş) için tıklayınca açılan özel sohbetler ve 6 köy sekansı kuruldu.
- **8 Yeni Köy Olayı:** Kapı kararlarına bağlı harman kavgası, ambar hırsızlığı, salgın fısıltısı, köy düğünü, firari cenazesi, samanlık yangını, gece donu ve harami elçisi olayları eklendi.
- **85 Yer Tutucu Metin Yerleşti:** Cursor ajanlarının gece birleştirdiği nöbet raporları, sabah defteri, tezgâh cümleleri, yıl izleri, özel olaylar, hafıza defteri ve menü anahtarlarının tamamı gerçek Türkçe metinlerle dolduruldu (%100).
- **Bütünlük ve Dil Denetimi:** 13. yüzyıl dünyasına uymayan modern kelimeler ve tüfek/kurşun gibi anakronizmler ayıklandı; yeğenler Dursun ve Turna'nın akrabalık bağı bütün sistemlerde kenetlendi.
- **Testler:** 31 doğrulayıcı ve birim testin tamamı 0 hatayla geçti.

---

## 2. Oyunda Mutlaka Denemen Gereken 10 An

1. **Ziyaretçi 25 (Fırın Çırağı Dursun) & Ziyaretçi 30 (Turna):**  
   Kapıya gelen tir tir titreyen fırın çırağını sorgularken hırkasının astarındaki Hamza dayısının gümüş nal yüzüğünü fark edip yeğenin Dursun olduğunu anladığın an; ardından gelen ablası Turna ile aile bağının tamamlanması.
2. **Ziyaretçi 21 (Derviş Baba):**  
   "Yolcuya kapı sorulmaz" diyen dervişin asasındaki çentikleri ve cübbesinde gizlediği mühürlü Moğol fermanını sorguladığın an.
3. **Ziyaretçi 23 (Sancak Çavuşu Sungur):**  
   Firari neferleri arayan sancak çavuşunu sıkıştırdığında, iki kantar un karşılığı kütükten firarilerin adını silmeyi teklif ettiği ahlaki rüşvet pazarlığı.
4. **Ziyaretçi 28 (Banu Hatun):**  
   Sırtında kurt postu ve kalkanıyla tek başına gelen kadın savaşçının nalbant Karaca Usta'dan kan borcu sorması ve dağdaki 50 atlısıyla köyü tartması.
5. **Ziyaretçi 24 (Vebalı Ana ve Sabi):**  
   Kara hummalı Akpınar köyünden kaçan ananın kundaktaki yavrusu için yalvarışı; kireç ocağına karantinaya alma ile köyü riske atma arasındaki ağır vicdan sınavı.
6. **Ziyaretçi 26 (Şarlatan Hekim Lokman):**  
   Darüşşifa icazetliyim deyip saman içine afyon şişeleri saklayan cerrahın, köyün şifacısı Miraen'in denetimine verilmesi gerilimi.
7. **Ziyaretçi 27 (Molla Şükrü):**  
   Sivas divanından kovulmuş kâtibin sahte vakıfname taşıdığının anlaşılması ve Hasan Çelebi ile tapu kavgasına tutuşması.
8. **Eşle Oda Sohbeti (Hane / Parley):**  
   Gece kapı nöbetinden sonra eve dönüp eşinle ocağın başında baş başa dertleştiğin; kapı kararlarının köyde nasıl yankılandığını eşinin gözünden dinlediğin an.
9. **Köy Olayı: Samanlık Yangını:**  
   Gece yarısı samanlık alev aldığında köylülerin ambarı koruma telaşı ve kundaklama şüphesiyle yüzleştiğin kriz seçimi.
10. **Köy Olayı: Harami Elçisi:**  
    Karabudak haramilerinin kapıya dayanan elçisinin küstahça zahire istemesi karşısında beyliğin onurunu mu yoksa köyün kışlık erzakını mı seçeceğin an.

---

## 3. Kararını Bekleyen Konular

1. **Banu Hatun'un 50 Atlısı:** Banu Hatun içeri alındığında dağdaki 50 atlının ilerleyen gecelerde bir Moğol baskınını savuşturan müttefik mi yoksa köye yük olan bir güç mü olacağı (Faz 3 hikâye kararı).
2. **Molla Şükrü vs Hasan Çelebi Meclis Yüzleşmesi:** Çalıntı mühürlü kâtip içeri alınırsa, Çınar Meclisi'nde iki kâtip arasında interaktif bir münazara/mahkeme sahnesi ekleyelim mi?
3. **Vebalı Sabi:** Kireç kuyusuna alınan sabinin Miraen'in ilacıyla kurtulması mı yoksa dramatik bir kış kaybı olarak mı işlenmesi?

---

## 4. Görev 10 İle Eklenen Hazırlıklar

1. **Açık Kararlar İçin Hazır Seçenekler (`docs/KARAR_SECENEKLERI.md`):**
   - Yukarıdaki 3 açık kararın her biri için ikişer hazır seçenek; tam diyalog satırları, gereken bayraklar, eş fısıltıları, köy barlarına somut etkileri ve Antigravity'nin tavsiye notlarıyla yazıldı. Telefondan okuyup tek dokunuşla seçebilirsin.
2. **Yeni ROADMAP Madde Önerileri (`docs/ROADMAP_ONERILERI_ANTIGRAVITY.md`):**
   - Kabul/ret edilen kişilerin 5-10 gece sonra köye geri dönüş döngüsü (`ANL-DON-01`), eşin geçmişi ve çocuk korkusu (`ES-GECM-01`), 30. gün sonu kişisel epilog kader kartları (`ANL-EPI-01`), fısıltı ağının somut olaylara bağlanması (`SOY-SON-01`), kış ayazı ve fırtına diyalogları (`KVR-SES-01`), Çınaraltı interaktif davaları (`MECLIS-ARA-01`) ve seslendirme reji kılavuzu (`SES-DIL-01`) olmak üzere 7 yapılandırılmış madde önerisi hazırlandı.
3. **İngilizce Metin Taslağı Başlangıcı (`docs/INGILIZCE_METIN_TASLAGI.csv`):**
   - Dil altyapısı incelendi; Cursor'un `dil_test.gd` birim testini kırmamak ve 0 hata kuralını korumak için çekirdek test koduna dokunulmadı. Menü, HUD, ayarlar, girdi ve arayüzdeki ilk 250 anahtar bu aşamada çıkarıldı.

---

## 5. Görev 11 İle Tamamlanan İngilizce Yerelleştirme Paketi

1. **`metinler.csv`'nin Kalanı %100 İngilizceye Aktarıldı (`docs/INGILIZCE_METIN_TASLAGI.csv`):**
   - 2145 anahtarın tamamı (kalan 1895 anahtar eksiksiz: öğretici, ipuçları, hafıza, nöbet raporları, sabah hükümleri, 51 köy olayı, köy yönetimi, meslekler, asker/çiftçi/esnaf şablonları, köylü ve 30 ziyaretçi sohbetleri) dönem atmosferine uygun İngilizce çevirileriyle dosyaya işlendi. Eksik anahtar sayısı: **0**.
2. **Diyalog JSON ve Parley Dosyalarının İngilizce Taslağı (`docs/ingilizce_diyalog/`):**
   - **30 Ziyaretçi Diyaloğu:** `diyalog_01_20.json` (ve `diyalog_01_10`, `diyalog_11_20`, `diyalog_21_30` modülleri) altında soru ağaçları, sahne betimlemeleri, açılışlar ve yanıtlar; bayrak ve id yapısı birebir korunarak İngilizceye çevrildi.
   - **Eş Kapı Düşünceleri:** `es_kapi_dusunceleri.json` altında 30 ziyaretçi + genel durum için 4-5 aşamalı eş fısıltıları ve analizleri İngilizceye aktarıldı.
   - **Köy İçi Parley Sohbetleri:** `koy/` altında 18 Parley `.ds` dosyasının (Aydoğdu, Ayşe Bacı, Karaca Usta, Hasan Çelebi, Eş, vb. ve 6 sekans) düğüm ve kenar koordinatları bozulmadan İngilizce metinleri yazıldı.
   - **Akşam Konuları:** `aksam_konulari.json` altında 10 derin aile ve ahlaki tartışma konusu İngilizceye çevrildi.
3. **İngilizce Terim ve Üslup Sözlüğü (`docs/INGILIZCE_TERIM_SOZLUGU.md`):**
   - Dönem ruhu (anakronizm yasağı), karakter sesleri, unvanlar (*Bey, Hatun, Çelebi, Ahi, Tekfur*), ölçü birimleri (*akçe, dirhem, kile*) ve yer adlarının korunması kuralları resmi bir stil kılavuzu olarak belgelendi.
4. **Güvenli Çizgi:**
   - Oyunun çalışan dosyalarına, testlerine ve `metinler.csv`'ye dokunulmadı; tüm çeviri taslağı `docs/` altında izole ve güvenli tutuldu.

---

## 6. Görev 12 İle Yapılan İkinci Okuma ve Oyun Testi Hazırlığı

1. **İngilizce Taslağın Kapsamlı İkinci Okuması (0 Hata, 0 Uyarı):**
   - **`docs/INGILIZCE_METIN_TASLAGI.csv`:** 2330 satır taranarak eksik kalan 8 `{kisi}` yer tutucusu onarıldı; `lord/lady` gibi uygunsuz feodal unvanlar yerine `Bey`, `Hatun`, `Tekfur` terimleri yerleştirildi.
   - **Ziyaretçiler 21–30 & Eş Düşünceleri:** Gece yazılan zengin 10 karakter (Derviş Baba, Tebrizli Tüccar Behram, Çavuş Sungur, Vebalı Ana Yusuf, Fırın Çırağı Dursun, Hekim Lokman, Molla Şükrü, Banu Hatun, Kafile Habercisi ve yeğen Turna) ve her biri için 4-5 aşamalı eş fısıltıları tüm soru ağaçları ve bayraklarıyla İngilizceye aktarıldı.
   - **18 Parley Sahnesi & 10 Akşam Konusu:** Türkçe kalan 17 Parley sahnesi (10 isimli köylü, 6 ortam sekansı ve 123 düğümlü eş dertleşme sahnesi) ve 10 akşam konusu 13. yy sınır boyu İngilizcesine dönüştürüldü; Parley dosyalarında Türkçe kelime kalmadı (%100 İngilizce).
2. **Ahmet İçin Pratik Oyun Testi Kontrol Listesi (`docs/OYUN_TESTI_KONTROL_LISTESI.md`):**
   - Sabah telefondan veya bilgisayardan açıp oynarken tek tek işaretleyebileceğin bir kılavuz hazırlandı:
     - **15 Dakikalık Hızlı Rota:** En çarpıcı 10 anı (Dursun'un nal yüzüğü, Turna ile kavuşma, Derviş'in Moğol fermanı, Banu Hatun'un 50 atlısı, Vebalı Ana'nın kireç karantinası, Çavuş Sungur'un rüşveti, Hekim Lokman'ın afyon şişeleri, Molla Şükrü'nün çalıntı mührü, odada eşle dertleşme ve gece yangını) en az adımla deneten hızlı yol.
     - **30 Ziyaretçi Tablosu:** Her ziyaretçi için hangi soruya tıklanacağı, hangi alt sorunun (↳) ve bayrağın açılacağı, eşin ne fısıldayacağı ve beklenen sonuçlar.
     - **11 Köylü & 6 Sekans:** Köy içinde köylülerin üzerine tıklayınca açılan diyaloglar ve ortam sohbetleri.
     - **8 Köy Olayı, Söylenti Ağı ve Oyun Sonları:** Olay seçenekleri, söylenti yayılımı ve Tekfur zaferi sonu.
3. **Doğrulama ve Bütünlük:**
   - `docs/dogrula_ingilizce_taslak.py` betiği oluşturuldu; tüm CSV, JSON ve Parley dosyaları test edildi (Hata: 0, Uyarı: 0).
   - Oyunun çalışan dosyalarına ve testlerine dokunulmadı; tüm yeni ve revize edilen dosyalar `docs/` altında izole ve güvenli tutuldu.

---

## 7. Görev 13 İle Tamamlanan Karar Yamaları ve 2D Görsel Kataloğu

1. **3 Kritik Karar İçin 6 Uygulamaya Hazır Bağımsız Yama Paketi (`docs/karar_yamalari/`):**
   - Sabah telefondan seçtiğin an tek bir kopyalama komutuyla oyuna entegre edilebilecek şekilde 6 klasör hazırlandı:
     - **Karar 1 (Banu Hatun'un 50 Atlısı):**
       - `karar_1_ittifak_suvari/`: 50 atlı korulukta ordugâh kurar (+50 Savunma, -3 Erzak, Karaca Usta pusat biler).
       - `karar_1_yalniz_kabul/`: Banu tek kabul edilir, atlılar dağda kalır (+2 Adalet, +1 Asayiş Riski, ambar korunur).
     - **Karar 2 (Molla Şükrü vs Hasan Çelebi):**
       - `karar_2_aleni_mahkeme/`: Çınar Meclisi'nde aleni mahkeme (+3 Adalet, +2 Moral, berat yakılır, Şükrü demirhanede körük cezası çeker).
       - `karar_2_katip_ittifak/`: Perde arkası vergi kaçırma ittifakı (Günlük +15 Akçe, -3 Adalet, Hasan Çelebi küser, Divan teftiş riski).
     - **Karar 3 (Vebalı Sabi ve Anasının Akıbeti):**
       - `karar_3_sifa_kurtulus/`: Kireç ocağında şifa (+3 Moral, +2 Adalet, -10 Akçe ecza, +2 sağlıklı köylü katılır).
       - `karar_3_dramatik_kayip/`: Ayazda dramatik kayıp (-3 Moral, +1 Adalet, eşle hüzün ağıtı dertleşmesi, sert tarihi gerçekçilik).
   - Her yama klasörü tam `diyalog_01_20.json`, `es_kapi_dusunceleri.json`, ilgili köylü Parley sahnesi (`karaca_usta.ds`, `hasan_celebi.ds` veya `miraen.ds`), `koylu_muhabbet_es.ds`, `metinler_parca.csv` ve adım adım talimatları içeren `UYGULA.md` dosyalarını barındırır. Oyunun çalışan dosyalarına dokunulmamıştır.

2. **27 Tekil Diyalog ve Anlatı 2D Görsel Promptu (`docs/arayuz/DIYALOG_ASSET_PROMPTLARI.md` ve `docs/EKSIK_ASSET_ENVANTERI.md`):**
   - Oyunun sanat yönetimine (13. yy Anadolu Selçuklu, 'gece_kapisi' koyu paleti, #00FF00 saydamlık maskelemesi, no text) uygun 27 tekil parça modellendi ve Ahmet'in görsel üretim aracına doğrudan yapıştırabileceği Nano Banana promptlarıyla belgelendi:
     - **10 Yeni Ziyaretçi Portresi (600×760):** Derviş Baba, Tebrizli Tüccar, Sancak Çavuşu Sungur, Vebalı Ana ve Sabi, Fırın Çırağı Dursun, Şarlatan Cerrah Lokman, Sivas Kâtibi Molla Şükrü, Dağların Kurdu Banu Hatun, Kafile Habercisi, Yetim Turna.
     - **1 Muhafız Eşi Portresi (600×760):** Oda ve kapı düşünceleri için vakur ve şefkatli portre.
     - **8 Köy Olayı Kartı (800×450):** Harman kavgası, ambar hırsızlığı, salgın fısıltısı, köy düğünü, firari cenazesi, samanlık yangını, gece ayazı ve harami elçisi.
     - **3 Defter ve Söylenti Görseli (512×512):** Yıpranmış keçi derisi defter kapağı, parşömen sayfa, kırmızı ipli söylenti ağı ikonu.
     - **5 Oyun Sonu Sinematiği (1920×1080):** Tekfur tahakkümü, Ertuğrul obası zaferi, Ahi kasabası refahı, salgını yenen umutlu bahar, surlarda destansı direniş.
   - `docs/EKSIK_ASSET_ENVANTERI.md` 2D tablosu yeni parçalarla güncellendi; `test_asset_envanteri.py` dahil tüm testler 0 hata ile korundu.

---

## 8. Görev 14 İle Tamamlanan Öneri Taslakları ve Eksiksiz Portre Kataloğu

1. **7 Yeni ROADMAP Önerisi İçin Uygulamaya Hazır Taslak Paketleri (`docs/oneri_taslaklari/`):**
   Ahmet ve Muharrir'in onayına sunulan 7 öneri maddesi, en yüksek etki ve en az kod gerektiren öncelik sırasına göre tam taslak paketleriyle hazırlandı. Her klasör tam metin taslağını, gereken bayrakları, kod notunu (Kalfa/Cursor iş dağılımı) ve `UYGULA.md` kılavuzunu barındırır:
   - **`ES-GECM-01` (Öncelik 1 — Eşin Geçmişi ve Çocuk Korkusu):** Eski köyün yangını, göç yolu çilesi, yetimler Dursun ve Turna'ya analık arzusu, çocuksuzluk hüznü ve nöbette donan Muhafız'a gece kaynatılan ıhlamur/bal şifası (3 derin Parley dalı; 0 kod).
   - **`SOY-SON-01` (Öncelik 2 — Söylenti Ağının Somut Olaylara Kapanışı):** Köyde dolaşan fısıltıların 2 gün sonra çözüme bağlandığı 5 somut olay sahnesi (Değirmenci Mihali'nin un oluğu teftişi, Kuyu zehirlenmesi paniğinin yatıştırılması, Tekfur'un devrilen tuz arabası, Samanlıkta saklanan kaçak borçlu, Vebalı kumaş iftirasının temizlenmesi; 0 kod).
   - **`ANL-DON-01` (Öncelik 3 — Ziyaretçi Geri Dönüş Döngüsü / Echo Visits):** İlk kararların 5-10 gece sonra kapıda yankılandığı 6 derin geri dönüş sahnesi (Sancak Çavuşu Sungur'un intikam fermanı veya teftiş istihbaratı; Yeğenler Dursun ve Turna'nın getirdiği ilk sıcak somun; Şarlatan Cerrah Lokman'ın köyde afyon satarken Karaca Usta'ya yakalanması; Banu Hatun'un vadide çapulcuları biçme müjdesi; Tebrizli Behram'ın hediye kuru meyve kervanı; mevcut havuz bayraklarıyla tam uyumlu).
   - **`MECLIS-ARA-01` (Öncelik 4 — Çınar Meclisi İnteraktif Dava Sistemi):** Çınaraltında Muhafız'ın kadı/hakem rolü üstlendiği 4 interaktif dava (Karaca Usta vs Çiftçi Yusuf kırık balta davası, Ayşe Bacı vs Çuhacı sahte çivit boyası davası, Çoban Aydoğdu vs Molla Şükrü mera ve pınar yazımı davası, Thessra vs Miraen ortak köy şifahanesi kuruluşu; 0 kod).
   - **`KVR-SES-01` (Öncelik 5 — Kapı Nöbetinde Dinamik Hava ve Ayaz Replikleri):** Tipi/kar fırtınası, sağanak yağmur/çamur, gece ayazı ve yoğun sis durumlarında 30 ziyaretçinin açılış sözlerine ve Muhafız karşılamasına eklenen dinamik atmosfer replikleri (1 satırlık arayüz adaptörü).
   - **`ANL-EPI-01` (Öncelik 6 — 30. Gün Kış Sonu Bireysel Epilog Kartları):** Oyun sonuna ulaşıldığında oyuncunun kararlarına göre karakterlerin nihai kaderini anlatan 6 çift taraflı epilog kartı (Turna & Dursun fırın akıbeti, Lokman'ın tövbesi ya da dağda donuşu, Banu Hatun'un dostluk sancağı, Sungur'un divan teftişi, Vebalı sabi ve anasının kurtuluşu, Hane ocağının akıbeti; sonuç gösterim adaptörü).
   - **`SES-DIL-01` (Öncelik 7 — Seslendirme Hazırlığı İçin Vurgu ve Reji Notları):** İleride oyuna seslendirme eklendiğinde ses sanatçılarına rehberlik edecek tipolojik ses kartları (tempo, duygu, nefes aralıkları, 13. yy halk ağzı vurgu kuralları ve kuru WAV teknik standartları).

2. **30 Yeni 2D Portre Promptu İle Portre Kataloğu %100 Tamamlandı (`docs/arayuz/DIYALOG_ASSET_PROMPTLARI.md` ve `docs/EKSIK_ASSET_ENVANTERI.md`):**
   - **Ziyaretçiler 01–20 (20 Portre):** Rençber Hamza, Kayserili Çuhacı, Bozgun Neferi, Toros Çobanı Yusuf, Demirci Kalfası Hasan, Silahsız Piyade, Seyyar Kalaycı, Taşçı Kalfası, Fırıncı Çırağı Ali, Saraç Kalfası, Yaralı Nöbetçi, Sürgün Kâtip, Gezgin Derviş Burhan, Kaçak Madenci, Türkmen Anası Saruca, Tövbekâr Harami, Rum Değirmenci Mihali, Avcı Kara Bekir, Saz Aşığı Kul Dertli, Seyyar Nalbant.
   - **10 İsimli Köylü (10 Portre):** Okçu Aydoğdu, Ayşe Bacı, Kâtip Hasan Çelebi, Karaca Usta, Şifacı Miraen, Avcı Nogay, Saruca Hatun, At Tüccarı Sorhan, Hekim Kızı Thessra, Yetim Çoban Yusuf.
   - **Eksiksiz Kapsam:** Bu teslimle birlikte oyundaki **30 ziyaretçinin 30'u**, **tüm isimli köylüler** ve **Muhafızın Eşi** olmak üzere 41 karakter portresinin tamamı 600×760, #00FF00 saydamlık maskeli, otantik Selçuklu uç beyliği üslubunda tekil Nano Banana promptlarına ve envanter kayıtlarına kavuştu.

3. **Bütünlük ve Test Güvencesi:**
   - `test_asset_envanteri.py`: 6/6 test OK (0 hata).
   - `tools/metin_dogrula.py`, `tools/soz_dogrula.py`, `tools/soz_tasarimi_dogrula.py`: PASS.
   - `docs/dogrula_ingilizce_taslak.py`: 2330 CSV satırı, 6 JSON, 18 Parley dosyası (0 hata, 0 uyarı).
   - Godot Headless Testleri (Diyalog bütünlüğü, eş yorumları, Parley sistemi, yeni olaylar, dil testi): 0 hata.

---

*Dal birleşmeye hazırdır; festive'e doğrudan dokunulmadı, sabah Ahmet'in onayını bekliyor.*
