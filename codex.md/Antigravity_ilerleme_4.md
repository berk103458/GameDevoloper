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
