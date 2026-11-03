# Antigravity İlerleme Dosyası — Görev 4 (Görev 3 Derinleştirme)

**Görev:** Tüm diyalogların derinleştirilmesi, dallandırılması, köylü hafızası ve tam kadro köy sohbetleri  
**Veren:** Ahmet (Kaşif aracılığıyla), 4 Kasım 2026 00:20  
**Ajan:** Antigravity  
**Dal:** `feature/diyalog-yeniden-yazim`  
**Başlangıç Tarihi:** 4 Kasım 2026  

---

## Aşama E — Öz Denetim ve Puan Tablosu

Görev 3 yaklaşık 45 dakikalık sürede tamamlanmış, temel mimari (Parley adaptörleri, JSON kapı şeması, temel metin iyileştirmeleri) kurulmuş ancak Ahmet'in "büyük düşünün, diyalogları ve seçimleri derinleştirin" vizyonu karşısında bazı alanlar yüzeysel kalmıştır. 

Aşağıdaki denetim, Ahmet'in 7 temel isteği üzerinden mevcut sistemin durumunu puanlamakta ve Görev 4 kapsamında yapılacak somut düzeltmeleri listelemektedir:

### 7 Temel İstek Kriterleri:
1. **İstek 1 (Sahiplik):** Bütün diyaloglar senin sorumluluğunda.
2. **İstek 2 (İnsanlaştırma):** Her karakter insan gibi konuşuyor (dönem/yöre ağzı, kaçamak cevap, yalan, zaaf, korku).
3. **İstek 3 (Büyük Seçimler):** Ek seçenekler ve kararlar var; sonuçları barlar, köy, iş, dedikodu ve sonraki günlere yayılıyor.
4. **İstek 4 (Tepkisellik):** Karakterler oyuncunun seçimlerine (sert/kaba, merhametli, kurnaz, rüşvetçi) uygun karşılık veriyor.
5. **İstek 5 (Ayıklama):** Gereksiz, tekdüze, aynı sonuca varan sorular ve diyaloglar ayıklanmış.
6. **İstek 6 (Köy İçi Sekanslar):** Köylüler kendi aralarında mevsime, son kararlara ve köyün kriz durumuna göre sohbet ediyor.
7. **İstek 7 (Tıklayınca Muhabbet):** Köyde köylüye tıklayınca konuşma açılıyor; adlı karakterler duruma göre (normal, kıtlık/kriz, tartışmalı kapı kararı) en az 3 farklı dal sunuyor.

---

### Puan Tablosu (Görev 3 Mevcut Durum vs. Görev 4 Hedefi)

| Bileşen / Karakter | İ1 | İ2 | İ3 | İ4 | İ5 | İ6 | İ7 | Ort. Puan (10 Üzerinden) | Tespit Edilen Eksiklik | Görev 4 Düzeltme Planı |
|---|---|---|---|---|---|---|---|---|---|---|
| **diyalog_01 (Erzincanlı Çiftçi)** | 10 | 7 | 5 | 6 | 8 | - | - | **7.2 / 10** | Sorular hala tek hatlı; beylik ambarından tohum kaçırma korkusu yeterince derin işlenmemiş; önceki gece reddedilen köylüyü hatırlamıyor. | 3 soru dalına sert/merhametli/kurnaz alt seçenekler eklenecek; önceki gece dağda kurda yem olan köylü hafızası ve ambar iş izi bağlanacak. |
| **diyalog_02 (Kayserili Çuhacı)** | 10 | 7 | 5 | 6 | 8 | - | - | **7.2 / 10** | Kumaş içindeki dirhemler ve Ahi yeminleri yüzeye çıkmıyor; rüşvet seçeneği tek satır kalmış. | Kumaş katları arasındaki dirhemler, Ahi Karaca Usta referansı, sert sorguda lonca tehdidi ve atölye etkisi eklenecek. |
| **diyalog_03 (Sivas Bozgun Askeri)** | 10 | 8 | 6 | 6 | 8 | - | - | **7.6 / 10** | Firar utancı ve cellat korkusu derinleştirilmemiş; kışla seçeneğinde kule nöbetine adanma sığ. | Kırık kargı tehdidi, merhamette diz çökme, önceki gün kovulan neferleri anma ve kışla kule savunma bonusu eklenecek. |
| **diyalog_04 (Koyunlu Çoban)** | 10 | 7 | 5 | 6 | 8 | - | - | **7.2 / 10** | Koyunların uyuz/çiçek hastalığı şüphesi diyalogda sınanmıyor; kaba yaklaşımda inatlaşma yok. | Sürü sağlığı sorgusu, kaba tavırda yaylacı inadı, rüşvette toklu teklifi ve köy ağılı verim izi eklenecek. |
| **diyalog_05 (Demirci Kalfası)** | 10 | 7 | 5 | 5 | 8 | - | - | **7.0 / 10** | Ustasını Moğol akınında bırakıp kaçma travması yüzeysel; Karaca Usta ile Ahi ocağı bağı eksik. | Ustasını terk etme itirafı, Karaca Usta korkusu, maden külçesi rüşveti ve demirhane kalkan üretimi izi eklenecek. |
| **diyalog_06 (Yamuk Miğferli Asker)** | 10 | 7 | 5 | 6 | 8 | - | - | **7.2 / 10** | Kılıcı kaybetme utancı ve harami pususu detaysız; alaycı üslup daha keskin olmalı. | Kılıcı haramiye kaptırma itirafı, boş kın gerilimi, askeri disiplin ve kışla gözcülüğü eklenecek. |
| **diyalog_07 (Sabanı Kırık Rençber)** | 10 | 8 | 6 | 6 | 8 | - | - | **7.6 / 10** | Küflü arpa tohumu ve oğullarının şehit oluşu arasındaki bağ zayıf; merhamet/sertlik zıtlığı sığ. | Küflü tohumu toprağa gömme çaresizliği, şehit oğul acısı, köy ambarına bereket/küf riski eklenecek. |
| **diyalog_08 (Kunduracı Çırağı)** | 10 | 7 | 5 | 6 | 8 | - | - | **7.2 / 10** | Heybedeki gümüş toka ve çalıntı mal kuşkusu yeterince açılmamış; ret eşiği 0 etkisi sığ. | Gümüş toka hırsızlığı yüzleştirmesi, efendisine sitem, rüşvette tokalı kemer teklifi eklenecek. |
| **diyalog_09 (Kemankeş)** | 10 | 8 | 6 | 6 | 8 | - | - | **7.6 / 10** | Boş sadağın ardındaki ihanet ve intikam arzusu yeterince keskin değil. | Hain nöbetçiyi arama intikamı, yay kirişi ve parmak zihgiri sorgusu, kule savunması eklenecek. |
| **diyalog_10 (Yetimli Köylü)** | 10 | 8 | 6 | 6 | 8 | - | - | **7.6 / 10** | Testideki kutsal şıra ve yetimlerin geleceği üzerine dramatik seçenek az. | Kaba sorguda çocukların ağlaması, obanın son şırası yemini, köy ocağına iş gücü eklenecek. |
| **diyalog_11–15 (Asker & Esnaf & Çoban)** | 10 | 7 | 5 | 6 | 8 | - | - | **7.2 / 10** | Çifte tabanlı kazan (12), topal oğlak borcu (13), kaya tuzu güherçilesi (14), borazancı suskunluğu (15) tek kollu akıyor. | Her birine sert/merhametli/kurnaz alt yollar, önceki gün kararları hafızası ve köy izleri eklenecek. |
| **diyalog_16–20 (Bağcı, Kantarcı, Fırıncı vb.)** | 10 | 7 | 5 | 6 | 8 | - | - | **7.2 / 10** | Hileli dirhem (17), kireçli kale yolsuzluğu (18), zehirli un (19), damgalı nal (20) çatışmaları daha organik olmalı. | Çelişkili ifadeler, söz kesmeler, kadı/muhafız çatışması ve rüşvet pazarlıkları genişletilecek. |
| **Yusuf (Yetim Keçi Çobanı)** | 10 | 8 | 6 | 7 | 8 | 7 | 8 | **7.7 / 10** | Parley sekansı var ama yalnız normal gün; kıtlık veya kapıda haksız ret durumuna tepki vermiyor. | Normal gün, kıtlık ve kapı kararı tepkisi olmak üzere 3 duruma göre dallanan tam Parley ağacı kurulacak. |
| **Miraen (Rum Şifacı Kadın)** | 10 | 5 | 3 | 3 | 6 | - | 3 | **4.3 / 10** | Özel Parley sekansı YOK; genel köylü diyaloğuna düşüyor. | `koylu_muhabbet_miraen.ds` yazılacak; tıp yazmaları, kuyu zehri ve salgın durumları işlenecek. |
| **Karaca Usta (Ahi Demircisi)** | 10 | 5 | 3 | 3 | 6 | - | 3 | **4.3 / 10** | Özel Parley sekansı YOK; Ahi fütüvvet ahlakı ve rüşvete öfkesi oyunda hissedilmiyor. | `koylu_muhabbet_karaca_usta.ds` yazılacak; kapıdaki rüşvet dedikodusuna tepkisi ve silah üretimi işlenecek. |
| **Ayşe Bacı (Bacıyan-ı Rum)** | 10 | 5 | 3 | 3 | 6 | - | 3 | **4.3 / 10** | Özel Parley sekansı YOK; kadın örgütlenmesi ve dayanışma sandığı diyalogda yok. | `koylu_muhabbet_ayse_baci.ds` yazılacak; yetimlere sahip çıkma ve kıtlıkta aşevi idaresi işlenecek. |
| **Aydoğdu (Emekli Çavuş)** | 10 | 5 | 3 | 3 | 6 | - | 3 | **4.3 / 10** | Özel Parley sekansı YOK; kapı asayişi ve kışla tecrübesi köye yansımıyor. | `koylu_muhabbet_aydogdu.ds` yazılacak; sağır kulağın dramı, kışla disiplini ve harami tehlikesi işlenecek. |
| **Saruca Hatun (Köy Ocağı Reisi)** | 10 | 5 | 3 | 3 | 6 | - | 3 | **4.3 / 10** | Özel Parley sekansı YOK; gizli tahıl sandığı ve anaç öğütleri eksik. | `koylu_muhabbet_saruca_hatun.ds` yazılacak; zahire hesabı, kış kıtlığı ve ocak bereketi işlenecek. |
| **Thessra, Sorhan, Hasan Ç., Nogay** | 10 | 5 | 3 | 3 | 6 | - | 3 | **4.3 / 10** | Özel Parley sekansları YOK; karakter derinlikleri ölü metin olarak kalmış. | Her biri için 3 duruma göre değişen müstakil `.ds` ağaçları hazırlanacak. |
| **Köy İçi Sekanslar (Ortam Sahneleri)** | 10 | 7 | 6 | 6 | 8 | 6 | - | **7.0 / 10** | Yalnızca 2 sekans var (`degirmen_kitlik` ve `meydan_atesi`). Mevsim ve harami baskınları eksik. | 4 yeni ortam sekansı (`demirhane_pusat`, `kuyu_hastalik`, `nobet_harami`, `pazar_fiskos`) eklenecek. |

---

### Görev 4 Yol Haritası ve İcra Planı

1. **Aşama E:** Öz denetim ve puan tablosu tamamlandı (Bu doküman).
2. **Aşama F Parti 1 (`diyalog_01` – `diyalog_05`):** 5 kapı karakterinin tüm düğümlerine sert/merhametli/kurnaz alt seçenekler, kaçamak/yalan/çelişki replikleri, önceki gece kararlarını hatırlayan hafıza satırları ve köy etkisi bayrakları eklenecek.
3. **Aşama F Parti 2 (`diyalog_06` – `diyalog_10`):** 5 karakter derinleştirilecek.
4. **Aşama F Parti 3 (`diyalog_11` – `diyalog_15`):** 5 karakter derinleştirilecek.
5. **Aşama F Parti 4 (`diyalog_16` – `diyalog_20`):** 5 karakter derinleştirilecek.
6. **Aşama G (Köy Sohbetleri ve Adlı Köylüler):** 
   - 9 adlı köylü için (`miraen`, `karaca_usta`, `ayse_baci`, `aydogdu`, `saruca_hatun`, `thessra`, `sorhan`, `hasan_celebi`, `nogay`) ve derinleştirilmiş `yusuf` için 3'er durumlu Parley ağaçları oluşturulacak.
   - 4 yeni ortam sekansı oluşturulacak.
   - `KoyDiyalogYoneticisi`'ne dinamik yönlendirici eklenecek.
7. **Aşama H (Bütünlük ve Doğrulama):** Testler ve doğrulayıcılar koşturulacak, `GOREV4_TAMAM` ile tamamlanacak.


---

## Aşama F — Kapı Diyaloglarının Derinleştirilmesi

### Parti 1 (`diyalog_01` – `diyalog_05`) — Tamamlandı
- **diyalog_01 (Erzincanlı Çiftçi):**
  - Beylik ambarı yangını, çalıntı tohum kuşkusu, sert sorguda kekeleme ve kaçamak cevaplar işlendi.
  - Önceki gece kapıdan çevrilen köylünün kurda yem oluşunu hatırlayan hafıza dalı bağlandı.
  - Merhametli yaklaşımda gözyaşı ve tohumu köye adama, rüşvet yaklaşımında gizli tohum takası derinleştirildi.
- **diyalog_02 (Kayserili Çuhacı):**
  - Kumaş katları arasına gizlenmiş gümüş dirhemler ve dükkân anahtarları sorguya açıldı.
  - Karaca Usta'nın Ahi ocağı referansı, sert sorguda lonca yemini ve kışla çadır tamiri vazifesi bağlandı.
  - Önceki gün kovalana saraç kalfasını hatırlayan hafıza dalı eklendi.
- **diyalog_03 (Sivas Bozgun Askeri):**
  - Kırık kargı tehdidi ("Bir adım daha atarsan kırık kargıyı bağrına çalarım!"), sancak ve firari gerilimi derinleştirildi.
  - Merhametli yaklaşımda diz çöküp yarayı açma, kışla seçeneğinde harita üstünde pusu noktalarını gösterme eklendi.
  - Dün kapıdan çevrilen askerin haramiye katılması hafızası işlendi.
- **diyalog_04 (Koyunlu Çoban):**
  - Sürü sağlığı (hastalık/uyuz kuşkusu), yaylacı inadı ve hayvanları koruma içgüdüsü işlendi.
  - Yusuf ve Karabaş referansı, rüşvette dövme bakır çıngırak ve haftalık teleme peyniri vaadi bağlandı.
  - Önceki gün dağda ateş yakan kovulmuş obalıları hatırlayan hafıza satırları eklendi.
- **diyalog_05 (Demirci Kalfası):**
  - Moğol akınında ustasını geride bırakıp kaçmanın vicdan azabı ve kaçak kalfa travması işlendi.
  - Karaca Usta'nın eski çırağı oluşu, Ahi ocağına teslimiyet ve yarım okkalık has pirinç maden külçesi rüşveti bağlandı.
  - Kayseri'den gelen çuhacı Selim Usta'yı hatırlama ve tanıma hafızası eklendi.
- **Doğrulama:** `tests/unit/diyalog/diyalog_butunluk_test.gd` (Godot 4.7.2 headless, 0 hata, GEÇTİ).

### Parti 2 (`diyalog_06` – `diyalog_10`) — Tamamlandı
- **diyalog_06 (Yamuk Miğferli Asker):**
  - Kılıcı ekmeğe satma yalanının ardındaki Karaboran harami pususu ve haraç verme utancı yüzleştirildi.
  - Sivaslı kargıcı neferi tanıma ve sırt sırta nöbet tutma hafızası bağlandı.
  - Gürz darbesiyle çift görme, kulak hassasiyeti ve gece seslerini dinleme derinleştirildi.
- **diyalog_07 (Sabanı Kırık Rençber):**
  - Küflü arpa tohumunu ambardan kurtarırken şehit düşen iki oğlunun dramı ve taşlık yamaçta tek tek ekme yemini işlendi.
  - Karaca Usta'ya saban demirini kaynattırma ve Erzincanlı Halil'in sarı tohumuyla kardeşleme hafızası bağlandı.
  - Moğol akıncılarının nehir boyuna gidişi istihbaratı eklendi.
- **diyalog_08 (Kunduracı Çırağı):**
  - Efendisinin yanan konağından gümüş kemer tokası aşırma itirafı, kefaret olarak köy sandığına teslim etme seçeneği işlendi.
  - Kayserili çuhacı ustayı tanıma ve onun kumaşına astar dikme bağı eklendi.
  - Ret eşiği 0 zorunlu kuralı korundu.
- **diyalog_09 (Kemankeş):**
  - Boş sadağın ardındaki hain nöbetçi cinayeti ve intikam arayışı ("İki yoldaşım sırtından vuruldu!") derinleştirildi.
  - Sivaslı yaralı kargıcıyı cepheden tanıma ("O hendekte vuruşurken ben tepeden ok yağdırıyordum!") hafızası bağlandı.
  - Kargı sazından kamış ve tavuk teleğiyle ok imalatı ve boynuz zihgir sorgusu eklendi.
- **diyalog_10 (Yetimli Genç Rençber):**
  - Testideki asırlık bağ kütüğü şırası, anasının bereket vasiyeti ve köy bağına dökme arzusu işlendi.
  - Ayşe Bacı ve Saruca Hatun'un yetim aşevine odun ve un taşıma görevi bağlandı.
  - Dün kapıdan çevrilen mültecilere su ikram etme hafızası eklendi.
- **Doğrulama:** `tests/unit/diyalog/diyalog_butunluk_test.gd` (Godot 4.7.2 headless, 0 hata, GEÇTİ).

### Parti 3 (`diyalog_11` – `diyalog_15`) — Tamamlandı
- **diyalog_11 (Yaralı Köprü Levendi):**
  - Çavuşun hendekte şehit düşüşü ve köyleri uyarmak için öne salınış dramı işlendi.
  - Şifacı Rum Miraen Hatun'a yönlendirilme ve Tokatlı kemankeşi cepheden tanıma hafızası bağlandı.
  - Kırık kalkanla kışla nöbetine ve dizdara süvari menfezlerini göstermeye adanma seçeneği eklendi.
- **diyalog_12 (Eşekli Seyyar Kalaycı):**
  - Çifte tabanlı kazanda kaçak cıva tozu ve saf kalay külçesi saklama itirafı ve Karaca Usta'nın demirhanesine hibe etme seçeneği işlendi.
  - Dikici kalfasını tanıma ve pirinç tokalarını parlatma hafızası bağlandı.
  - Nişadır dumanı ve bakır tencere zehirlenmesini önleme zanaatı derinleştirildi.
- **diyalog_13 (Topal Oğlaklı Çoban):**
  - Ağılın borç yüzünden Kızıl Karga haramilerince basılması itirafı ("Suç bendedir, bu masum oğlağı kurda atmayın!") işlendi.
  - Yusuf ve Karabaş ile dostluk kurma, yetim oğlağı Yusuf'a emanet etme hafızası bağlandı.
  - Dün gelen yaylacı Dursun'un Akça koyunundan süt emzirme bağı eklendi.
- **diyalog_14 (Kaya Tuzu Tüccarı):**
  - Kesenin dibindeki barutluk kükürtlü güherçile tozu tespiti ve kışla sur patlatma fitillerine hibe seçeneği işlendi.
  - Kalaycı Mahmut Usta'yı tanıma ve tuz ambarı bereketi hafızası bağlandı.
  - Çatlak ellerdeki tuz yanıkları ve kış erzağı muhafazası derinleştirildi.
- **diyalog_15 (Kule Borazancısı):**
  - Kuleyi basan haramilerin önündeki amcasının oğlunu görüp bir an donma itirafı ve vicdan çatışması işlendi.
  - Yaralı taş köprü neferini tanıma ve tepedeki elli atlı süvarinin geçiş haritasını dizdara verme hafızası bağlandı.
  - Eğri bakır borazanın iki mil öteden avaz verme hüneri eklendi.
- **Doğrulama:** `tests/unit/diyalog/diyalog_butunluk_test.gd` (Godot 4.7.2 headless, 0 hata, GEÇTİ).

### Parti 4 (`diyalog_16` – `diyalog_20`) — Tamamlandı
- **diyalog_16 (Asma Fidanlı Bağcı):**
  - Bizans sınırından kaçırılan misket üzümü aşı çubuğu, softaların tepkisi ve şifacı Miraen Hatun'a aşı verme seçeneği işlendi.
  - Testisinde bağ şırası taşıyan yetim rençber çocuğu tanıma ve onun şırasıyla asmayı sulama hafızası bağlandı.
  - Güney yamacın taşlık toprağında şekerli üzüm yetiştirme ve kış sepetçiliği hüneri eklendi.
- **diyalog_17 (Dirhemleri Şakırdayan Kantarcı):**
  - Beş dirhemlik pirinç kütüğün altındaki eğe izleri ve hileli dirhem itirafı ("Çarşı haracını ödeyemeyince törpüledim, kırın o dirhemi!") derinleştirildi.
  - Hileli dirhemi kırıp kalan mühürlü dirhemlerle köy pazarında adil tartı tutma seçeneği işlendi.
  - Dün gelen kaya tuzu tüccarı İlyas'ı tanıma ve kervan tartısı hafızası bağlandı.
- **diyalog_18 (Kireç Lekeli Kale Irgatı):**
  - Kale dizdarının harçtan kireç ve taş çalma yolsuzluğunu görmesi ve susturulmak için kalasla dövülüp hendeğe atılması dramı işlendi.
  - Ahşap kazık surların altına taş temel ve kireçli harç dolgusu çekme hüneri eklendi.
  - Kuledeki kemankeşin mazgal zayıflığı uyarısını doğrulama hafızası bağlandı.
- **diyalog_19 (Gürgen Tekneli Fırıncı):**
  - Çavdar mahmuzu şüphesine karşı kırk yıllık ocağın çörekotlu ekşi mayasını koklatma ve köye ekmek kokusu yayma arzusu işlendi.
  - Un ambarını idare eden Saruca Hatun'a saygı ve çay taşlarından nar gibi tandır kurma hüneri eklendi.
  - Sabanı kırık Arpacı İdris Amca'yı tanıma ve onun arpa unundan kış çöreği yapma hafızası bağlandı.
- **diyalog_20 (Ayağına Çivi Batmış Nalbant):**
  - Palaskasındaki nallarda Kızıl Karga haramilerinin üç çentikli damgasını itiraf etmesi ("Atlarını zorla nallattılar amma son aygırın tırnağına çiviyi bilerek eğri çaktım ki tökezlesin!") işlendi.
  - Eşkıyanın atlarını sakatlayıp kışla dizdarına harita verme seçeneği ve Şifacı Miraen Hatun'a topuk tedavisi bağlandı.
  - Kulesi basılan borazancıyı tanıma ve harami süvari atlarının nal durumunu teyit etme hafızası eklendi.
- **Doğrulama:** `tests/unit/diyalog/diyalog_butunluk_test.gd` (Godot 4.7.2 headless, 0 hata, GEÇTİ).


---

## Aşama G — Köy Sohbetleri ve Tıklayınca Konuşma (Parley) — Tamamlandı

### 1. Adlı Köylüler için 3 Durumlu Tıklayınca Muhabbet Ağaçları (`data/parley/koy/`)
10 adlı köy sakini için 3 farklı duruma (Normal gün/iş, Kriz/kıtlık/salgın/harami, Kapıdaki son tartışmalı kararlar) göre dallanan müstakil Parley `.ds` diyalog grafikleri üretildi:
1. `koylu_muhabbet_yusuf.ds`: Karabaş'ın ipi, Kösedağ bozgunu, Saruca Hatun'un tarhanası, kapıdaki adil muhafız fısıltısı.
2. `koylu_muhabbet_miraen.ds`: Rum cerrahlık ilmi, dağ kekiği/kantaron merhemi, kuyu kireçleme ve karantina tedbirleri, kapıdan alınan yaralı levent ve nalbantın tedavisi.
3. `koylu_muhabbet_karaca_usta.ds`: Ahi ocağı fütüvvet ahlakı, oraklardan pusat yapma, rüşvetle girene demirhane boykotu, kalfayı çırak alma sevinci.
4. `koylu_muhabbet_ayse_baci.ds`: Bacıyan-ı Rum kadın dayanışması, yetim aşevi, kıtlıkta çörekotlu ekmek, yetimli rençber ailesini kucaklama.
5. `koylu_muhabbet_aydogdu.ds`: Emekli çavuş disiplini, mazgal nöbeti denetimi, hendek kurt çukurları ve Kösedağ süvari pusuları, kapıdan alınan askerlerin kışlaya intibakı.
6. `koylu_muhabbet_saruca_hatun.ds`: Köy ocağı anası, gizli zahire sandığı güvencesi, tasarruf terbiyesi, fırıncının tandırı kurması ve tuz ambarı bereketi.
7. `koylu_muhabbet_thessra.ds`: Andezit taş blokları, su arkı ve sur çatlağı ölçümleri, mancınık sekmeli dış bent, kireççi kale ırgatıyla sur örme ortaklığı.
8. `koylu_muhabbet_sorhan.ds`: Bozkır at terbiyesi, süvari vadisi taktikleri, topuğu çivili nalbant ustasının aygırlara hilal nal çakması.
9. `koylu_muhabbet_hasan_celebi.ds`: Divan kâtipliği, koyundaki gizli defter sayfası, kanunsuz vergiye direnç, hileli dirhemi kırılan kantarcının adalete boyun eğişi.
10. `koylu_muhabbet_nogay.ds`: Çamlıkta Kızıl Karga izi sürme, orman kapanları, topal oğlaklı çobanın ve kule borazancısının anlattıklarını izlerle doğrulama.

### 2. Zenginleştirilmiş Ortam Sohbet Sekansları
Köylülerin kendi aralarında döneme, mevsime ve kriz durumlarına göre konuştukları 4 yeni sahne sekansı eklendi (toplam 6 sekans):
1. `sekans_degirmen_kitlik.ds`: Latif & İdris (Un ve kıtlık tartışması)
2. `sekans_meydan_atesi.ds`: Aydoğdu & Ayşe Bacı (Kurt baskını ve kış hazırlığı)
3. `sekans_demirhane_pusat.ds`: Karaca Usta & Thessra (Kapı kanadına çift sıra dövme demir takviyesi, sur ve mazgal perçinleri)
4. `sekans_kuyu_hastalik.ds`: Miraen & Saruca Hatun (Kuyu suyundaki pas kokusu, sönmemiş kireçle dezenfeksiyon, tandırda su kaynatma)
5. `sekans_nobet_harami.ds`: Nogay & Sorhan (Gece teyakkuzu, ahırda tayların huzursuzluğu, vadide karşı pusu)
6. `sekans_pazar_fiskos.ds`: Hasan Çelebi & Yusuf (Kapıdaki adalet dedikoduları, divan defterinin önemi, yetimin duaları)

### 3. Dinamik Yönlendirici Mimarisi
`src/diyalog/koy_diyalog_yoneticisi.gd` güncellendi: Tıklanan köylünün `adli_id` veya `ad` bilgisine göre otomatik olarak ilgili özel `.ds` dosyasına yönlendirme sağlandı, bulunamadığı durumlarda genel köylü sekansına güvenli geri düşüş bağlandı.
- **Doğrulama:** `tests/unit/diyalog/diyalog_butunluk_test.gd` (Godot 4.7.2 headless, 17 Parley dosyası, BFS erişilebilirliği, 0 hata, GEÇTİ).


---

## Aşama H — Bütünlük ve Nihai Doğrulama Kontrolleri (Tamamlandı)

Repodaki tüm doğrulayıcı araçlar ve Godot headless testleri çalıştırılarak eksiksiz bütünlük doğrulandı:

1. **`python tools/chr_parser.py --check`:**
   - 30 CHR karakter sayfası eksiksiz ayrıştırıldı, doğrulanıp onaylandı (0 hata, GEÇTİ).
2. **`python tools/metin_dogrula.py`:**
   - `data/metin/metinler.csv` dosyasının bütünlüğü ve formatı doğrulandı (PASS).
3. **`python tools/soz_tasarimi_dogrula.py` (`PYTHONUTF8=1`):**
   - Söz tasarımı doğrulandı (SÖZ TASARIMI: GEÇTİ).
4. **`tests/unit/diyalog/diyalog_butunluk_test.gd` (Godot 4.7.2 Headless):**
   - 20 kapı ziyaretçisi diyaloğunun şeması, sahne metinleri, seçenek-eşik denkliği, yanıt sözlüğü karşılıkları, kervanla kaçış yasağı ve diyalog_08 ret eşiği (0 hata).
   - 17 Parley `.ds` dosyasının AST ayrıştırması, kırık bağlantı (dangling edge) kontrolü, START'tan tüm düğümlere BFS erişilebilirliği (sıfır yetim/ulaşılamayan düğüm), Fact ve Action script referanslarının diskteki varlığı (0 hata).
   - Türkçe karakterlerin (`ç, ğ, ı, İ, ö, ş, ü, Ç, Ğ, Ö, Ş, Ü`) tüm JSON ve Parley dosyalarında bozulmadan korunduğu (0 hata).
   - `ParleyKoyAdaptoru` ve `KoyDiyalogYoneticisi`'nin Yusuf, Miraen, Karaca Usta ve ortam sekansları üzerinden uçtan uca çalışması (0 hata, GEÇTİ).
5. **`tests/unit/kvr/diyalog_mantigi_test.gd` (Godot 4.7.2 Headless):**
   - Diyalog mantığı ve karar/eşik kontrolleri doğrulandı (0 hata, GEÇTİ).
6. **`tests/unit/diyalog/koy_parley_sistemi_test.gd` (Godot 4.7.2 Headless):**
   - Parley adaptör ve arayüz entegrasyonu doğrulandı (0 hata, GEÇTİ).

---

## Özet İstatistikler
- **Yeniden Yazılan & Derinleştirilen Kapı Ziyaretçisi:** 20 Karakter (`diyalog_01` – `diyalog_20`), 80+ derinleştirilmiş alt soru/cevap ve sert/merhametli/kurnaz dalları, önceki gün kararları hafıza referansları.
- **Yazılan Parley Adlı Köylü Ağacı:** 10 Adlı Karakter (Yusuf, Miraen, Karaca Usta, Ayşe Bacı, Aydoğdu, Saruca Hatun, Thessra, Sorhan, Hasan Çelebi, Nogay), her biri için 3 duruma (normal, kriz, kapı kararı) göre dallanan müstakil ağaçlar.
- **Yazılan Parley Ortam Sekansı:** 6 Sekans (`degirmen_kitlik`, `meydan_atesi`, `demirhane_pusat`, `kuyu_hastalik`, `nobet_harami`, `pazar_fiskos`).
- **Toplam Test ve Doğrulama Hata Sayısı:** 0 (Sıfır Hata Politikası tam sağlandı).

GOREV4_TAMAM
