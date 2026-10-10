# Codex öz denetimi — KRI-11…15 / SYS-16…20

**Tarih:** 11 Ekim 2026 · **Denetleyen:** Codex (Berk)  
**Dal / incelenen başlangıç HEAD:** `claude/festive-volta-li1sfm` / `2fa512e359e43da4911b431d7d8ff8ff652e73f2`  
**Kapsam:** `c1b0fec` KRI-11, `acbf185`…`4981688` özellik commitleri, `54f9f08`, `29b7d21`, `6ea6972`, `2fa512e`; mevcut çalışma kopyasının gerçek bağlantıları ve testleri. `29b7d21` özelliklerin başlangıcı değil, UID paketidir.  
**İlk denetimin işlem sınırı (tarihsel):** Oyun kodu, test kodu, veri, CSV ve ROADMAP değiştirilmedi; düzeltmeler yalnız öneriydi. Commit/push/pull yapılmadı. Asset gerekmedi. Aşağıdaki kaynak izleri ilk denetime aittir; kullanıcının sonraki düzeltme görevinin durumu hata tablosunda ve kapanış ekinde ayrıca tutulur.

## Yöntem ve kanıt sınırı

ROADMAP tanımları, özellik GDD'leri, kaynak diff'i, çağrı sırası, kayıt üreticileri/okuyucuları ve mevcut birim/akış testleri bağımsız olarak incelendi. Önceki Claude raporundaki son numara `BUG-0010`; aşağıdaki yeni kayıtlar `BUG-0011` ile başlar. Önceden düzeltilmiş BUG-0007/0008/0009/0010 tekrar açık sayılmadı.

**TEMİZ:** İncelenen sözleşmede somut kusur bulunmadı; bütün olası durumların kanıtı değildir. **HATA:** Kaynak akışından gösterilebilen sözleşme/davranış tutarsızlığı. **RİSK:** Tasarım kapsamı, denge veya test kanıtı eksikliği; çalışma zamanı hatası olarak sunulmaz. Yeni hata senaryoları için betik yazılmadı; BUG tekrarları aşağıda statik yürütme izleriyle tarif edilir. Mevcut testlerin geçmesi bu yeni senaryoları doğrulamaz.

Çalışmaya başlarken çalışma kopyasında bağımsız doküman/import değişiklikleri ve `work/` vardı. Kaynak/test/araçlarda başlangıç diff'i yoktu. Takipli dosyaların başlangıç SHA-256 listesi `work/oz_denetim_logs/baslangic_sha256.json` dosyasına alındı. `gh issue view 11 --comments` denendi; `gh` PATH'te bulunamadı, Ajan Masası okunamadı. Bu denetim hiçbir ajanın sahipliğini değiştirmez.

## Sonuç tablosu

| Madde | Durum | Ana sonuç |
|---|---|---|
| KRI-11 | TEMİZ | Açık belirti → aynı ziyaret ipucu → tüm kabul yollarında mevcut karantina bağlantısı var. |
| KRI-12 | RİSK | Mekanik eşik/kayıp çalışmaya bağlı; RNG çekim sayısının değişmediği iddiası doğru değil (BUG-0015). |
| KRI-13 | RİSK | Bulaşıcı hastalar kendi aralarında sıralanıyor; bütün Şifahane hastaları için ortak triyaj yok. |
| KRI-14 | HATA | Aynı gece/olay listesiyle tekrar çağrı malı tekrar geri alabilir, moral bedelini tekrar uygular (BUG-0012). |
| KRI-15 | RİSK | Afyon girdisi bağlı; ilaç üretim hızındaki gerçek fayda testte gösterilmiyor. |
| SYS-16 | HATA | Sıra yükleniyor fakat köye geçiş kaydından Devam aynı gün yeni kapı kuyruğu açıyor (BUG-0013). |
| SYS-17 | TEMİZ | Ret/eşik/yanıt dizileri ve dört yerleşik kabul metni tanıma uygun. |
| SYS-18 | HATA | Sonradan değişen kasa/moral gece raporunun kapanış alanlarında güncellenmiyor (BUG-0011). |
| SYS-19 | RİSK | Normal 12 gece ve başlangıç kaydı tutarlı; eski zafer yolu ve geçiş ekranı sınırları ayrıca doğrulanmalı. |
| SYS-20 | HATA | Bey sonu kalıcı gönderim geçmişi yerine sıfırlanan son ferman seçimini kullanıyor (BUG-0014). |

**Özet:** 2 TEMİZ, 4 HATA, 4 RİSK. Beş yeni BUG kaydı; biri yanlış dokümantasyon/RNG sözleşmesidir.

## Madde bazında inceleme

### KRI-11 — TEMİZ

- **Uygunluk ve kanıt:** `src/kapi/hastalik_teshis_adaptoru.gd:10` yalnız açık bayrakları okur; gizli hastalık/hikâye metni kanıt olmaz. `:18` CHR'nin mevcut `IpucuYoneticisi` servisini kullanır; adsız ziyaret için ziyaret meta verisi vardır. `:41` yüz/heybe keşfi tek ipucu üretir. `:58` kabul/harç/rüşvet/kışla önkoşullarını; `:69` mevcut `KarantinaYoneticisi.al` bağlantısını uygular. Model kapısı `src/sistemler/oturum.gd:192`, kabul adaptörü `:255`; UI zorlanmış karar kapıları `src/arayuz/kapi_ekrani.gd:514` ve `:546` üzerindedir.
- **Kayıt/null:** Null ziyaret ve olmayan belirti güvenli dönüyor (`hastalik_teshis_adaptoru.gd:12`, `:27`, `:36`). Debug ziyaret kaydı isteğe bağlı ipucunu `src/debug/kapi_anlik_goruntusu.gd:17` / `:104` üzerinden taşır; normal oturum kaydı kabul edilmiş köylünün karantina/enfeksiyon alanlarını mevcut sistemle taşır. Önceki kayıt keşif uydurmuyor. Sağlıklı fakat şüpheli kişi izole edilebilir; adaptör enfeksiyon üretmiyor.
- **Kalan sınır ve öneri:** CHR paneli çocuğuna konumsal erişim (`hastalik_teshis_adaptoru.gd:132`) panel düzeni değişince kırılgan; adla düğme bulma tercih edilmeli. İnceleme metni tekrar ediyor (önceki ADV-06). Şifahane kurulmadan açık hastayı kabul edememe sert bir denge kararıdır; mekanik gereği uygulanmış, kusur sayılmadı. `tests/unit/kvr/hastalik_teshis_test.gd:49` dört kabul yolunu, bedeli, dolu kontenjanı, gizliliği ve JSON'u kapsıyor. Eksik kapsam: yalnız heybe belirtisi + heybesiz ziyaretin gerçek UI yolu, CHR panel yapısındaki değişiklik ve `o.yonetim == null` gibi sözleşme dışı çağrı. Bugün normal Oturum her zaman yönetim kurduğundan son durum hata olarak kaydedilmedi.

### KRI-12 — RİSK

- **Uygunluk:** `src/koy/koy_yonetimi.gd:547` anlık erzak fotoğrafını salgından önce alır; `:808` ek −1 sağlığı tek ölüm denetiminden önce uygular. `src/koy/aclik_saglik.gd:11` boş/terminal köyü, `:26` dış görevi dışlar; eşik tam 3'te kapanır. `src/koy/saglik_yoneticisi.gd:79` yalnız mevcut temas bulaşma zarının eşiğini katlar; tifo/su yolu değişmez. Fotoğraf geçici, sonuç sağlık kalıcıdır; bir sonraki gün eski meta aktif değildir (`aclik_saglik.gd:18`). Bu başlangıç tercihi gece sonunda stok azalmasıyla aynı şey değildir; GDD bunu açıkça tanımlamış.
- **Bulgu — BUG-0015:** Kaynak ve GDD'de “RNG çekim sayısı değişmez” deniyor (`aclik_saglik.gd:3`, `design/gdd/aclik-saglik.md:13`). Oysa `saglik_yoneticisi.gd:75` iki başarılı yeni vakada erken durur. ×2 eşik iki başarıya daha erken ulaşabilir ve daha az zar çeker. Sağlık cezasının RNG'siz olması ile bütün salgın algoritmasının çekim sayısının eşit olması farklıdır. Kayıt devamı deterministik kalabilir; bu bulgu tek başına save/load bozulması demek değildir.
- **Öneri/kapsam:** İddia “yeni bağımsız RNG yok, mevcut temas zarı kullanılır; çekim sayısı vaka tavanına bağlıdır” şeklinde düzeltilmeli. Sabit sayıda çekim ayrıca isteniyorsa önceden çekilmiş temas zarlarını kullanan yeni yardımcı + ince adaptör düşünülmeli. `tests/unit/kvr/aclik_saglik_test.gd:40` RNG eşitliğini enfeksiyonsuz sağlık-cezası senaryosunda kontrol ediyor; `:62` salgın karşılaştırmasında RNG son durumunu kontrol etmiyor. Üçten fazla temas adayı, iki vaka sınırı, çoklu kaynak, gece başında 2 erzak→üretimle dolma ve 3 erzak→tüketimle tükenme sınırları eklenmeli. Sürekli kıtlıkta açlık/infeksiyon/ek −1 birleşimi ölüm sarmalı açısından ölçülmeli.

### KRI-13 — RİSK

- **Uygunluk:** `src/koy/sifahane_triyaj.gd:8` sağlık artan/ID eşitlik sırasını üretir; `src/koy/saglik_yoneticisi.gd:95` mevcut tedaviyi bu sıraya bağlar. `sifahane_triyaj.gd:30` işleyen karantina yatakları doluysa, görünür ve karantina dışında bekleyen hasta için −3 sağlık / köyde kalanlara −2 moral üretir. Olay tek mevcut rapor adaptörüne bağlıdır. Şifahane yok/boş yatak/gizli kuluçka cezalandırılmıyor; bu GDD'de belgelenmiş tercihtir. Yeni kalıcı yatak sözlüğü yoktur.
- **Gece sırası bulgusu:** `src/koy/koy_yonetimi.gd:563` yanık, `:564` kış hastalığı, `:565` enfeksiyon sırasıyla aynı `SifahaneKontenjani` tüketilir. `src/koy/zanaat_kazalari.gd:31` ve `src/koy/kis_hastaligi.gd:43` sağlık sırasını kullanmaz. Tek hekimlik kontenjanı olan köyde hafif kış hastası, ağır bulaşıcı hastadan önce tedavi alabilir. Bu, “triyaj en ağır hastayı önce tedavi eder” rapor cümlesini (`sifahane_triyaj.gd:45`) bütün hastalar için doğru kılmaz. Önceki sistem önceliğini koruma tercihi olabilir; bu nedenle kesin regresyon değil RİSK olarak ayrıldı.
- **Karantina/denge:** Karantinadaki hasta `SaglikYoneticisi.temas_edebilir` false olduğundan enfeksiyon tedavisine alınmaz (`saglik_yoneticisi.gd:96`); dolu yataklar tedavi edilmiş olsa bile izolasyon süreleri bitene kadar işgal edilir. Ayrıca hekim işleyişi kapanınca `sifahane_triyaj.gece` toplam yatak 0 olduğu için çöküş cezası kalkar (`:31`). Yeni Şifahane faydalıdır ama işleyen hekimin olmadığı durumun daha az ceza üretmesi teşvik tersliği yaratabilir.
- **Öneri/test:** Ortak triyaj hedefleniyorsa yeni bir aday/sıra yardımcı dosyasıyla yanık/kış/enfeksiyon için tek kontenjan sırası kurulmalı; hastalık türüne göre mevcut tedavi API'leri korunmalı. Yalnız enfeksiyon triyajı isteniyorsa rapor/GDD bunu açık söylemeli. `tests/unit/kvr/sifahane_triyaj_test.gd:62` yalnız aynı tür üç hastayı test ediyor. Karışık hastalık türü, karantina içi ağır hasta, hekimin hasta/izole olması, yatakların tam o gün boşalması, çoklu Şifahane ve eşit sağlık-ID kapsamı eklenmeli. Kayıt karşılaştırması `:107` mevcut durum içindir; yükleyip ertesi gece iki dalı karşılaştırma eksiktir.

### KRI-14 — HATA

- **Uygunluk:** İlk kıtlık gecesi uyarı ve KRI-06 yağma gecesi arbede, `src/koy/koy_yonetimi.gd:593` üzerinden mevcut isyanın arkasına bağlıdır. `src/koy/kitlik_nobeti.gd:9` mevcut etkin muhafız sayısı koşullarını tekrarlar; geri alım kişi başı %25 / tavan %100 / aşağı yuvarlama ve ambar kapasitesiyle sınırlıdır (`:29`). Moral köye −3, nöbetçiye ilave −5; sıfır nöbetçi sessizdir. Yeni kayıt/yağma motoru yok.
- **Bulgu — BUG-0012:** `kitlik_nobeti.gd:22` aynı geceye ait olayı bulunca, daha önce tüketilip tüketilmediğini denetlemeden `:33` malı ekler, `:35` ve `:37` morali yeniden keser. Aynı olay listesiyle iki çağrı aynı yağmayı iki kez geri alır. KRI-06'nın makbuzu KRI-06 gece üretimini korur; bu adaptörün ödeme yolunu korumaz. Normal `KoyYonetimi.gece` tek çağrı yaptığı için burada güncel UI'da çift çağrı kanıtlanmadı; hata, modülün ilan edilmiş tekrar güvenli sözleşmesindedir.
- **Öneri/test:** Mevcut kıtlık makbuzuna isteğe bağlı son arbede gecesi/işlendi alanı veya mevcut olayın sonuç makbuzu ekleyen küçük yardımcıyla tekrar kapatılmalı. `tests/unit/kvr/kitlik_nobeti_test.gd:70` yüklenmiş, günü ilerlemiş köyü **boş** olay listesiyle çağırıyor; aynı gün/aynı yağma olayını tekrar vermiyor. Bu test çift geri alımı yakalayamaz. Aynı gün iki çağrı, JSON sonrası aynı olayın yeniden verilmesi, 1/4/5 nöbetçi, küçük yağmada yuvarlama, kapasite daralması ve karantina/maaş borcu/dış görev kapsamı gerekli.
- **Sunum/denge sınırı:** “Ambara yöneldi” yalnız rapor metnidir (`kitlik_nobeti.gd:43`); devriye hedefi `src/koy/gorsel/koy_halk_hareketi.gd:166` hâlâ `MuhafizDevriyesi.hedef` çağırır, kıtlık adaptörüyle rota bağlantısı yok. `src/koy/gorsel/muhafiz_devriyesi.gd:6` normal durakları seçer. GDD/envanter bunu rapor sunumu olarak belgelemiş; fiziksel yönelme bekleniyorsa yeni rutin + ince hedef adaptörü gerekir. Etkin muhafız sözleşmesinin sağlamlık koşulu eksikliği de devralınmış risktir: `koy_yonetimi.gd:155` ve `kitlik_nobeti.gd:13`, `CirakEgitimi.saglam` kullanmaz; hasta/zindandaki eski nöbet atamasının sayılması ayrıca doğrulanmalı.

### KRI-15 — RİSK

- **Uygunluk:** `src/koy/koy_yonetimi.gd:552` üretimden önce ot ekler. `src/koy/sifali_ot.gd:9` yalnız görünür/temas edebilen enfeksiyonu tetikleyici yapar; `:19` sağlam, yetişkin, işi olmayan ve usta olmayan adayları, `:18` en çok üç kişiyi seçer. İsyan/terminal engeli `:24`; stok ekleme gerçek ambar kapasitesini kullanır. `src/koy/hekim_ilac.gd:9` afyon + su → ilaç reçetesidir. Yeni kaynak/kalıcı alan yok; afyon mevcut kaynak kaydıyla sürer.
- **Risk:** “Salgın” burada tek uygun görünür hastadır. Hastaların hepsi karantinada veya zindandaysa toplama kesilir; bu belgelenmiş ama oyuncuya beklenmedik olabilir. Toplayıcılar her gece dizi başından seçilir, rotasyon yok. BOSTA ve usta olmayan, zanaatı olan düşük statlı kişiyi de kapsar; “vasıfsız” için bunun amaçlanan anlam olduğu teyit edilmeli. `CirakEgitimi.saglam` önceki `ac` durumunu okuduğundan bu gece yemek yiyecek ama dün aç kalmış kişi toplamaz. Enfeksiyon öncesi değil sonrası seçim, yeni hastanın aynı gece otçu olmamasını sağlar.
- **Öneri/test:** Mevcut `tests/oto/sifali_ot_kontrol.gd:28`…`:44` senaryosunda hekim/ilaç reçetesi yok; yalnız afyon stoku/raporu/kaydı kanıtlanıyor. Birim test `tests/unit/kvr/sifali_ot_test.gd:51` reçete anahtarını kontrol ediyor. Afyonu 0, suyu yeterli, işleyen Şifahane ilaç reçetesinde olan köyde otun **aynı gece ilaç üretimini ve tedaviyi** artırdığı karşılaştırmalı senaryo eklenmeli. Ambar dolu, su yok, hekim yok, tamamen karantinadaki salgın ve iş/kayıt ataması kapsamı gerekli. Mekanik düzeltme zorunlu bulunmadı; ilk iş kanıt ve denge kararını tamamlamak.

### SYS-16 — HATA

- **Başarılı bölüm:** `src/sistemler/oturum.gd:731` mevcut `diyalog_sira` alanını yazar, `:774` doğrulayıcıyla okur. `src/sistemler/diyalog_sirasi.gd:8` negatif/kesirli/sonsuz/null değeri 0'a döndürür; bitmiş listeyi tekrar açmaz. `src/sistemler/oturum.gd:630` liste sonundan şablona geçer. Legacy alan yoksa baştan başlama güvenli ve belgelenmiştir; normal JSON sayısı float döndüğünde tam sayı kabul edilir.
- **Bulgu — BUG-0013:** `src/arayuz/ana.gd:99` kapı günü bittikten sonra, gece henüz çalışmadan köye geçiş kaydını yazar. `:68` Devam bu kaydı okuyunca her zaman `:74` `_kapiya_git` çağırır. `src/arayuz/kapi_ekrani.gd:222` aynı gün için yeni `gece_kuyrugu` üretir; `src/sistemler/oturum.gd:130` ve `:633` sonraki adsız diyalogları tüketir. Sıra geriye dönmez, fakat oyuncu kaldığı köy fazına dönemez: gün/gece ilerlemeden ek kapı nöbeti ve diyalog tüketimi gerçekleşir. Faz sorunu SYS-16'dan önceki Ana akışında da vardır; yeni “Devam kaldığı yerden” iddiasının sınırını ihlal eder.
- **Öneri/test:** Yeni kayıt-fazı yardımcı dosyası + Ana'da ince adaptörle köy/kapı kontrol noktası korunmalı; gün sayacı gece çalışmadan artırılmamalı. Legacy faz alanı yoksa mevcut kapı davranışı açık varsayım olarak korunabilir. `tests/oto/diyalog_sirasi_kontrol.gd:29` yalnız `>= sira` kontrolü yapıyor, kaçırılan fazı/ek tüketimi kabul ediyor; `:30` ikinci diyalog karşılaştırmasını gerçek Devam oturumunda değil ayrı `Oturum.kayittan` nesnesinde yapıyor. Gerçek ikinci Ana'nın ekranı, aynı gün toplam ziyaret/karar sayısı ve diyalog indeksi kontrol edilmeli. Kapı ortasından kayıt veya admin snapshot normal gün-sonu kaydından ayrı sözleşme olarak test edilmeli.

### SYS-17 — TEMİZ

- **Uygunluk:** `data/diyalog/diyalog_01_20.json:321` diyalog_08'e Ret ekler; `:326` paralel eşik 0, `:331` ret yanıtı vardır. Yerleşik kabul metinleri `:537`, `:577`, `:662`, `:705` üzerindedir; sabah kervanla ayrılma yerine köyde kalma anlatılır. Diff sadece amaçlanan JSON satırlarıdır; CSV değişmemiştir.
- **Mantık/kayıt:** `src/sistemler/oturum.gd:652` seçenek/eşik dizilerini birlikte taşır; 2. perdede `:655` kabul/ret filtresi iki diziyi aynı seçim üzerinden oluşturur. Kalıcılık SYS-16 indeksini kullanır; mevcut veriyle boş seçenek veya null yanıt bulunmadı. Kabulün gerçek yerleşme yolu `oturum.gd:244` mevcut köylü kabulüdür.
- **Öneri/test:** `tests/unit/kvr/diyalog_mantigi_test.gd:15` seçenek/eşik/yanıt uyumunu, `:19` Ret'i, `:25` gerçek gelen seçeneklerini kapsar. Dört metnin gerçek kabul sonucunda nüfus +1 ve ertesi gün köyde kalması, 2. perde Ret ve rüşvet eşiğinin bir soru sonra açılması eklenebilir. Zorunlu kod düzeltmesi bulunmadı.

### SYS-18 — HATA

- **Uygunluk:** Altı bayrak mevcut sözlükten okunur (`src/sistemler/atil_bayraklar.gd:19`, `:23`, `:32`, `:36`, `:40`, `:44`). Bayraklar mevcut Oturum kaydında korunur (`src/sistemler/oturum.gd:727`, `:728`, `:760`). RNG eklenmez; rüşvet etkisi tavanlıdır. `src/sistemler/oturum.gd:286` gerçek geceye bağlanır.
- **Bulgu — BUG-0011:** `src/koy/koy_yonetimi.gd:601` / `:602` rapor kapanış akçe/huzur değerlerini alır ve döner. Daha sonra `atil_bayraklar.gd:33` kasaya kira, `:27` hastalara moral ekler. `oturum.gd:286` sonrasında bu iki rapor alanı güncellenmez. UI `src/arayuz/koy_ekrani.gd:660` / `:661` eski değerleri gösterirken gerçek kasa ve `GeceBilancosu` son durumu yenidir. Örnek: rapor kapanışı 100 ise +2 kira sonrası HUD/bilanço 102, rapor 100 kalır; hasta morali artışı ortalamayı değiştiriyorsa Huzur da eski kalır.
- **Öneri:** Bayrak adaptörü tamamlandıktan sonra mevcut raporun `akce` ve `huzur` kapanışlarını tazelemeli; ayrı rapor veya ikinci kasa yapılmamalı. `tests/unit/kvr/atil_bayraklar_test.gd:39` raporu yalnız `{olaylar: []}` ile kurduğundan kapanış uyumsuzluğunu ölçmez. Gerçek hafta başı gece_sonu → rapor/HUD/bilanço/save kapanış eşitliği testi gerekli.
- **Ek sıra/kayıt riskleri:** Bayrak etkileri `_isyan`, `_husumet`, `IflasYoneticisi.gece`, son denetimi ve HaberciAgi'den sonra geliyor. Dolayısıyla aynı geceki kira iflası, dua isyanı, Türkmen husumeti o gecenin baskınını önlemez/etkilemez; bu gecikme açık karar olarak belgelenmeli. `atil_bayraklar.gd:15` tekrar makbuzu yalnız meta; kayda alınmıyor. Aynı gün bu yardımcı yükleme sonrası doğrudan tekrar çalıştırılırsa kira/moral tekrarlanabilir. Normal `gece_sonu` önce gün ilerlettiği için normal Devam'da bu çift uygulama kanıtlanmadı; risk olarak ayrıldı. Miraen'in kalıcı bayrağı kişinin ölümü/ayrılması/görev dışı kalmasını kontrol etmez; devam eden gerçek devriye mi, kalıcı karar etkisi mi olduğu tanımlanmalı. Haftalık etkiler ilerlemiş günü kullanır; vergi de gün + 1 kullandığından aynı hafta sınırında kalır (src/koy/vergi_politikasi.gd:18) (`koy_yonetimi.gd:588`, `:604`).

### SYS-19 — RİSK

- **Uygunluk:** `src/koy/koy_yonetimi.gd:861` 18 nüfusta ağalığı açar; `:597` geçiş gecesinin ertesi gününü başlangıç yapar. `src/koy/perde_gecisi.gd:13` tamamlanan gece sayısını mutlak günden türetir; gün sıfırlanmaz. `src/sistemler/oturum.gd:287` mevcut terminal kayıp sonucunu ezmeden 12 gece zaferini uygular (`perde_gecisi.gd:30`). Alan `koy_yonetimi.gd:913` kayda girer, `:973` gün/ağalık yüklendikten sonra okunur. Legacy/bozuk/ileri başlangıç −1 olup sonraki gece açılır; önceki BUG-0009 düzeltmesi bu akışta korunmuş.
- **Risk:** `src/koy/koy_yonetimi.gd:878` üçüncü savuşturulan baskında eski erken zaferi koruyor. Dolayısıyla 12 gece bütün zaferlerin zorunlu süresi değildir; `design/gdd/nihai-sonlar.md:5` iki yolu da kabul ediyor. ROADMAP'in “2. perde 12 gece” hedefiyle bu istisna açık okunmalı. `perde_gecisi.gd:18` yalnız ağalık/başlangıcı kontrol ediyor, terminal sonu kontrol etmiyor; geçiş gecesinde son oluşursa aynı raporda “2. perde başladı” ve kayıp son birlikte görülebilir. Bu sunum sınırı için senaryo çalıştırılmadı.
- **Öneri/test:** Üç baskın istisnası korunacaksa süre ifadesi bunu belirtmeli; korunmayacaksa mevcut zafer tetikleyicisi ince adaptörle aynı süre sözleşmesine bağlanmalı. Başlangıç işaretleyici terminal geceyi atlamalı. `tests/unit/kvr/perde_gecisi_test.gd:18` haraç aralığını 100000 yaparak süre testindeki gerçek Tekfur yolunu kaldırıyor; `:41` kayıt başlangıcını kontrol ediyor ancak özgün/yüklenmiş köyü hedefe kadar paralel yürütmüyor. 11/12 gece save/load devamı, tam hedefte kayıp/teftiş, geçiş kartında kapatıp Devam, 17/18 nüfus sınırında aynı gece ölüm, iki Şifahane kriziyle eşzamanlı geçiş ve üç baskın erken zafer kapsamı gerekli.

### SYS-20 — HATA

- **Uygunluk:** `src/sistemler/nihai_son.gd:17` yalnız zaferi beş başlığa ayırır. Kayıp başlıkları korunur, beş gösterge + yozlaşma cümleleri `:33` üzerinden eklenir; `:43` null Oturum'da eski metin döner. Gösterge aralıkları sıkıştırılır, boş nüfusta bölme hedefi en az 1'dir (`:11`). `src/arayuz/ana.gd:119` tek mevcut son ekranına bağlanmıştır. Seçim salt okunur; ayrı bir final sonu kaydı yok, mevcut terminal/oturumdan türetilir.
- **Bulgu — BUG-0014:** `nihai_son.gd:25` Bey sonunu son `sancak_asker_talebi.secim` alanının 0/1 olmasına bağlar. `src/sistemler/sancak_asker_talebi.gd:26` yeni fermanda seçimi −1, `:28` gönderilen listesini boş yapar; `:75` sonraki reddi 2 yapar. Daha önce levent göndermiş köy bu geçmişi ve ilgili final yolunu kaybeder. Güvenlik ≥70 / üç etkin nöbetçi yedeği sağlanmıyorsa final farklı çıkar. Yeni ferman final gecesinde de açılabilir; çağrı `src/sistemler/oturum.gd:284`, süre-sonu denetimi `:287` üzerindedir. Ferman 8. gece başlar, aralığı 12'dir (`data/sancak_asker_talebi.json:2`); yeni dönem son seçimi temizler.
- **Öneri/test:** Başarılı levent gönderimini mevcut kalıcı bayrak sözlüğünde ya da mevcut makbuzun isteğe bağlı kalıcı alanında saklayan küçük yardımcı; son seçimini bu geçmişten okumalı. Legacy kayıtta yalnız son 0/1 ve makbuz kanıtıyla geriye uyumlu başlangıç yapılmalı; veri yokken geçmiş gönderim uydurulmamalı. `tests/unit/kvr/nihai_son_test.gd:38` hazır secim=0 sözlüğünü doğrudan yazar, gerçek gönderim→yeni ferman→kayıt→final zincirini test etmez. Bu zincir ve son gecede yeni ferman kapsamı gerekli.
- **Denge/metin riskleri:** Tekfur dalı yüksek yozlaşmayı diğer bütün yollardan önce seçiyor; alternatif olarak hiç baskın/ret olmayan belirli süreyi haraç kabulü sayıyor (`nihai_son.gd:22`). Gerçek ödeme geçmişi okunmadığından değiştirilmiş/legacy ayarlarda henüz haraç ödememiş köy yanlış anlatıya düşebilir. Dört finalin önceliğiyle düşük/yüksek eşik kombinasyonları ve 35/36/64/65 sınırları ölçülmeli. `tests/oto/nihai_son_kontrol.gd:25` haraç yolunu kapatıp tek Ahi örneğini doğrular; beş finalin gerçek kayıt/devam/UI zinciri kanıtlanmış değildir. Yozlaşma Tekfur başlığını seçerken 60/100 değeri epilogda “orta” olabilir (yüksek ≥65); bu çelişki değil, ayrı eşiklerin okunabilirlik riskidir.

## Ortak kayıt, metin ve mimari kontrolü

- İncelenen aralıkta `data/metin/metinler.csv` diff'i boş. Kodda altı yeni olay türü `IflasYoneticisi.olay_metin` içinde ayrıştırılır: `src/koy/iflas_yoneticisi.gd:34`…`:39`. Her yardımcıya **tam dış olay Dictionary'si** gider; yardımcı kendi `e.<tur>` alt sözlüğünü okur. Bu yeni türlerde yanlış iç/dış sözlük aktarımı bulunmadı. `atil_bayrak`, `sifali_ot`, `kitlik_nobeti`, `sifahane_triyaj`, `aclik_saglik`, `perde_gecisi` üreticileri bu biçime uygundur. `{}` veya `{tur: null}` gibi bozuk olaylara genel tolerans yok; güncel üreticiler böyle olay üretmiyor. Kaydedilmiş rapor replay desteği eklenecekse tek doğrulama adaptörü ve boş/null alt sözlük testleri gerekecek.
- KRI-14 geri alınan kaynak adları `kitlik_nobeti.gd:45` ham ID ile yazılır; KRI-06 aynı kaynakları `DemirZinciri.ad` ile çevirir (`kitlik_isyani.gd:134`). S3 metin iyileştirmesi olarak mevcut kaynak adı yardımcı kullanılmalı; CSV değişikliği gerekmez.
- Yeni özellikler yeni yardımcı dosyalarda; Oturum ve Ana bağlantıları küçük eklerdir. Çekirdek yeniden yazımı, ikinci oyun dalı veya eski köy mimarisi dönüşü bulunmadı. CSV/asset üretimi yok; `docs/EKSIK_ASSET_ENVANTERI.md:437`…`:456` madde bazında “asset gerekmedi” kararlarını içerir. KRI-14 fiziksel rota eksikliği bu kararın sunum sınırıdır.
- KRI-12/13/14/15 çoğunlukla mevcut köylü/stok/karantina/kıtlık alanlarını kullanır; yalnız SYS-19 isteğe bağlı başlangıç ekler. SYS-16 değer doğrulaması mevcut alanı korur. SYS-18 meta tekrar makbuzunun kalıcı olmaması ve SYS-20 geçici ferman seçiminin geçmiş yerine kullanılması özel dikkat gerektirir.
- Normal Oturum/KoyYonetimi nesnesi, katalog ve kaynaklar kurulmuş kabul ediliyor. Null köylü içeren tipli dizi, eksik preload JSON veya null yönetim için genel savunma yok; normal kayıt okuyucusu tipli nesneler kurduğu için bunlar bugünkü akışta kanıtlanmış hata sayılmadı. Bozuk isteğe bağlı yeni alanlar SYS-16/19'da açık doğrulanıyor; bütün kayıt şemasının kötü niyetli/bozuk değer toleransı bu on maddeden geniştir.

## Yeni hata listesi — BUG-0010'dan devam

Önem: **S2** oyun sonucu/kalıcılık/mekanik doğruluk; **S3** rapor veya sınırlı API/dokümantasyon sözleşmesi. Kayıtlar ilk denetimde **AÇIK / statik kaynak kanıtı** olarak açıldı. Tekrar üretme izleri tarihsel olarak korundu; sonraki Codex düzeltmesi ve eklenen test dosyaları her satırın son hücresinde belirtilir. Beş yeni birim otomatik keşifle, iki yeni akış açık listeyle `tools/sanity_check.py` kapsamına alındı; mevcut diyalog akışı da güçlendirildi.

| ID | Önem / madde | Tekrar üretme izi ve beklenen/gerçek sonuç | Kaynak ve önerilen düzeltme |
|---|---|---|---|
| BUG-0011 | S3 · SYS-18 | Hafta başına giren gerçek gecede `baci_tezgah` olsun. Köy raporu akçeyi kaydeder, ardından kira +2 olur. Beklenen: rapor/HUD/bilanço/kayıt aynı kapanış. Gerçek: rapor akçesi 2 eksik; derviş morali ortalamayı değiştiriyorsa rapor Huzur da geride. | `src/koy/koy_yonetimi.gd:601`, `src/sistemler/atil_bayraklar.gd:27`, `:33`, `src/sistemler/oturum.gd:286`, `src/arayuz/koy_ekrani.gd:660`. Bayrak adaptörü sonunda mevcut kapanış alanlarını tazele; gerçek gece eşitliği testi. **DÜZELTİLDİ (Codex) — src/sistemler/atil_bayraklar.gd; tests/unit/kvr/atil_bayrak_kapanis_test.gd, tests/oto/atil_bayrak_kapanis_kontrol.gd, tests/oto/atil_bayrak_kapanis_kontrol.tscn.** |
| BUG-0012 | S3 · KRI-14 | Gün değişmeden, boş ambar yeri ve nöbetçi bulunan köyde aynı geçerli `kitlik_isyani` olay listesiyle `KITLIK_NOBETI.gece` iki kez çağrılsın. Beklenen: geri alım/moral bir kez. Gerçek: ilk olay hâlâ listede; ikinci kez mal eklenir, moral tekrar kesilir. Normal gece bugün bir kez çağırıyor. | `src/koy/kitlik_nobeti.gd:22`, `:33`, `:35`. Mevcut kıtlık/olay makbuzunda işlemi işaretle; aynı gün aynı olay ve JSON replay testi. **DÜZELTİLDİ (Codex) — src/koy/kitlik_nobet_makbuzu.gd, src/koy/kitlik_isyani.gd, src/koy/kitlik_nobeti.gd; tests/unit/kvr/kitlik_nobet_tekrar_test.gd.** |
| BUG-0013 | S2 · SYS-16 (önceden var olan faz sorunu) | Kapı nöbetini bitir→`Ana._koye_git` kaydı→geceye geçmeden kapat→Devam. Beklenen: aynı köy fazı, ek ziyaret/diyalog tüketimi yok. Gerçek: aynı gün yeni kapı kuyruğu açılır, sonraki hazır diyaloglar tüketilir. | `src/arayuz/ana.gd:99`, `:74`, `src/arayuz/kapi_ekrani.gd:222`, `src/sistemler/oturum.gd:633`. Yeni faz yardımcı dosyası + ince Ana adaptörü; legacy varsayımı ve gerçek ikinci Ana ekran/indeks kontrolü. **DÜZELTİLDİ (Codex) — src/sistemler/oturum_fazi.gd, src/sistemler/oturum.gd, src/arayuz/ana.gd; tests/unit/kvr/oturum_fazi_test.gd, tests/oto/diyalog_sirasi_kontrol.gd.** |
| BUG-0014 | S2 · SYS-20 | Gerçek fermanı levent göndererek tamamla; güvenliği Bey yedeği altına ayarla/koru, oba ittifakı ve yüksek yozlaşma olmasın; sonraki ferman açılsın veya reddedilsin; kayıt/devam→zafer. Beklenen: gönderim geçmişi Bey koşulunu korur. Gerçek: `secim` −1/2 olup önceki gönderim silinir, başka son seçilir. | `src/sistemler/nihai_son.gd:25`, `src/sistemler/sancak_asker_talebi.gd:26`, `:28`, `:75`. Mevcut bayrak/makbuzda kalıcı başarı izi, kanıtlı legacy geçişi ve gerçek ferman zinciri testi. **DÜZELTİLDİ (Codex) — src/sistemler/levent_gonderim_gecmisi.gd, src/sistemler/sancak_asker_talebi.gd, src/sistemler/nihai_son.gd; tests/unit/kvr/levent_gonderim_gecmisi_test.gd, tests/unit/kvr/nihai_son_test.gd, tests/oto/levent_final_kontrol.gd, tests/oto/levent_final_kontrol.tscn.** |
| BUG-0015 | S3 · KRI-12 (dokümantasyon/test sözleşmesi) | Bir görünür humma kaynağı + aynı hazır binada en az üç aday. Örneğin ardışık zarlar 25, 30, 90: taban %20 üç deneme/0 vaka; ×2 %40 ilk iki deneme/2 vaka ve erken durma. Beklenen ilan edilmiş sabit çekim sayısı; gerçek 3 ve 2 çekim. Bu bir statik karşı örnektir, belirli engine seed'iyle koşulmuş test değildir. | `src/koy/aclik_saglik.gd:3`, `src/koy/saglik_yoneticisi.gd:75`, `:79`, `design/gdd/aclik-saglik.md:13`. Yeni RNG eklenmediği ile çekim sayısının eşit olduğu iddialarını ayır; sınır testini üç+ adayla kur. **DÜZELTİLDİ (Codex) — src/koy/aclik_saglik.gd (yalnız yorum), design/gdd/aclik-saglik.md; tests/unit/kvr/aclik_saglik_rng_sinir_test.gd, tests/unit/kvr/aclik_saglik_test.gd (yorum).** |

**Düzeltme sırası önerisi:** BUG-0013 / BUG-0014 (devam ve final), BUG-0011 (rapor), BUG-0012 (tekrar sözleşmesi), BUG-0015 (kanıt dili). KRI-13 ortak triyaj ve SYS-19 erken zafer tasarım kapsamı netleştirildikten sonra genişletilmeli. Bu sıra yeni ROADMAP maddesi/sahipliği değildir.

## Sanity ve teslim sonucu

**Motor:** Logdan doğrulanan `Godot Engine v4.7.2.stable.official.ed1daf0bf`.

İlk olarak istenen ön import çalıştırıldı:

```text
C:/Users/ds/Desktop/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe --headless --editor --import --quit --path .
```

Çıkış kodu 0, ancak kullanıcı dizinindeki `Godot/editor_settings-4.7.tres` yazımı reddedildi. Bu nedenle temiz import başarısı olarak sayılmadı. Log: `work/oz_denetim_logs/on_import.log`.

Ardından istenen sanity komutu çalıştırıldı:

```text
python -B tools/sanity_check.py --godot C:/Users/ds/Desktop/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe --logs work/oz_denetim_logs
```

İlk koşuda 5 PASS / 19 FAIL yazıldıktan sonra koşu durduruldu: `user://logs` yazımı ve Windows kök sertifika deposu erişimi hataları ortaktı; kayıt testinde yazılamayan dosya nedeniyle null `store_string` hatası da çıktı. Bu eksik koşu tam sanity değildir. Log: `work/oz_denetim_logs/sanity_runner.txt` ve aynı dizindeki ilk test logları.

Yazma engelini ayırmak ve kullanıcının gerçek kayıtlarını korumak için yalnız alt süreç ortamında `APPDATA` / `LOCALAPPDATA`, `work/oz_denetim_logs/isolated_appdata` / `isolated_local` altına yönlendirildi. Önce mevcut SYS-16 birim testiyle kayıt yazımı doğrulandı; sonra **bütün 319 kontrol** aynı motor ve aynı sanity aracıyla yeniden çalıştırıldı; log hedefi `work/oz_denetim_logs/isolated_sanity`. Araç, hata filtresi ve test kodu değiştirilmedi.

| Kapanış ölçütü | Sonuç |
|---|---|
| Tam sanity'nin ham sonucu | **5 PASS / 314 FAIL**, çıkış kodu **1**; `Sanity: 314 failed. No staging/commit/push.` |
| Başarılı araç kontrolleri | CHR kaynak, CSV, Python testleri, açılış kaynağı, korumalı API — beşi PASS. |
| Ortak motor hatası | 314 Godot çalıştırmasında `ERROR: Failed to read the root certificate store.` |
| Oyun testlerinin kendi tamamlanma işaretleri | 313 test logunda `GEÇTİ`; bu işaretler ham FAIL'leri PASS'a dönüştürmez. Kalan bir Godot kontrolü editor import'udur. |
| İncelenen özellik testleri | On maddenin birim testleri ve mevcut yedi UI akışı tamamlanma işaretlerini verdi; yeni BUG senaryoları bu testlere eklenmedi. |
| Parse/çalışma zamanı betik hataları | İzole tam koşuda `SCRIPT ERROR`, `Parse Error`, `Failed to load script`, `KALDI` görülmedi. |
| 20 gece dumanı | `20 GECE DUMAN: GEÇTİ`; rapor `gece=20`, `gun=20`, `son=tekfur`. Motor sertifika hatası nedeniyle sanity satırı yine FAIL. |
| Ek çıkış sorunu | Tam koşuda `kitlik_isyani_kontrol.log` renderer RID / 23 resource / PagedAllocator sızıntı ERROR'ları da içeriyor. Aşağıdaki aralıklı gözlem ayrıca korunmuştur. |

**Kapsam dışı ama sanity'de görülen aralıklı RİSK:** KRI-06 kıtlık-isyanı UI testi başarı işaretini verdikten sonra RID/resource sızıntısı bildirdi. Aynı mevcut sahnenin aynı izole kullanıcı diziniyle tekil tekrarında çıkış 0 ve `GEÇTİ` görüldü; sızıntı tekrarlanmadı, sertifika hatası sürdü. Bu nedenle sızıntının kök nedeni veya KRI-14'ten geldiği doğrulanmış değildir; yeni özellik hatası diye numaralandırılmadı. Sınır: `tests/oto/kitlik_isyani_kontrol.gd:94`…`:97` sahneyi kuyrukla serbest bırakıp tek kare sonra çıkışa gider. Öneri: `--verbose` ile kalan nesne/RID sahiplerini bulmak ve asenkron sahne kapanışının gerçekten tamamlandığını doğrulamak. Tam koşu logu ve `work/oz_denetim_logs/kitlik_tekrar.log` birlikte değerlendirilmelidir. Eski boulder GLTF UID→metin-yolu fallback uyarıları da vardır; bu tur asset/import dosyaları düzeltilmedi.

**Yorum:** Temiz sanity **alınamadı**. Sertifika erişimi ve yukarıdaki aralıklı çıkış hatası giderilmeden “0 hata” kabul ölçütü sağlanmış sayılmaz. Önceki Claude raporundaki 319 PASS / 0 hata bu denetimin sonucu olarak kullanılmadı. Başarı işaretleri mevcut test senaryolarının tamamlandığını gösterir; bu rapordaki yeni mantık/kapsam bulgularını çürütmez. Görünür Godot incelemesi veya yalnız commitli önbelleksiz klon bu salt denetim turunda yapılmadı.

**Kanıt dosyaları:** `work/oz_denetim_logs/sonuc_ozeti.json`, `isolated_runner.txt`, `isolated_sanity/*.log`, `kitlik_tekrar.log`, `baslangic_sha256.json`. Oyun kaynakları, testler, araçlar, veri/CSV, assetler ve `project.godot` başlangıç hash'leriyle aynı kaldı; Git'te bu alanların diff'i boş. `AGENTS.md` farkının kaynağı, denetim sürerken dışarıdan eklenen 5c9a5b1 Tester eğitim kiti commit'idir: kapanış HEAD'i 5c9a5b1 oldu. Bu commit yalnız ajan/Tester belgeleri ve skill ekler; incelenen oyun kaynaklarını değiştirmez. Bu ajan commit/push/pull yapmadı; bağımsız belge değişiklikleri korundu. Tek yeni sürümlenebilir çıktı bu denetim raporudur; diğer çalışma değişiklikleri korunmuştur.

**Yerel ayna:** `C:/Users/ds/Documents/GitHub/GameDevoloper/docs/denetim/2026-10-11-codex-oz-denetim.md` mevcut değildi. Yalnız yeni raporu kopyalama denemesi `Copy-Item: UnauthorizedAccessException / erişim reddedildi` ile engellendi; bu oturum çalışma alanı dışında yazamıyor. Ayna raporu **oluşturulamadı**; eşitlendi iddiası yok. Rapor/logların ayna transferi bu izin sınırı nedeniyle tamamlanamadı. Başka dosya/branch/history üzerine yazılmadı. Commit/push yapılmadı.

## 11 Ekim 2026 — istenen beş düzeltme (Codex)

Uygulama sırası **BUG-0013 → BUG-0014 → BUG-0011 → BUG-0012 → BUG-0015**. İlk denetimin kaynak izleri ve log sonucu yukarıda tarihsel kanıt olarak korundu.

- **BUG-0013:** İsteğe bağlı `faz` alanı mevcut Oturum kaydına eklenir; Ana köy fazına kapı kuyruğu üretmeden döner. Faz alanı olmayan/bozuk legacy kayıt eski kapı davranışını sürdürür; köy fazı kanıtsız tahmin edilmez. Yeni birim JSON/legacy/bozuk alanları, güçlendirilen `diyalog_sirasi_kontrol` ikinci gerçek Ana'da ekranın Köy olduğunu, gün/sıra/RNG/kadronun aynen kaldığını ve gece sonrası kaydın Kapı olduğunu ölçer.
- **BUG-0014:** `levent_gonderildi` mevcut ferman makbuzunun kalıcı başarı alanıdır; yalnız başarılı gerçek gönderimde açılır, yeni ferman veya ret temizlemez. Legacy başlangıç için son seçim 0/1, uygun tarih ve iki farklı geçerli kişi makbuzu gerekir; boş makbuzdan geçmiş üretilmez. Yeni birim her iki gönderim seçeneğini, yeni/ret fermanı ve JSON devamını ölçer. `levent_final_kontrol` gerçek ilk gönderim, GuvenliKayit/ikinci Ana ve gerçek 12. perde gecesi zafer/Bey ekranını; ayrıca final gecesinde yeni ferman açılmasını kapsar. Finalin diğer öncelikleri değişmez.
- **BUG-0011:** Bayrak adaptörü sonunda mevcut raporun `akce` ve `huzur` kapanışları tazelenir. Çağrı sırası değişmez; kira/dua o gecenin daha önce çözülmüş iflas/isyan/baskın sonucunu geriye dönük değiştirmez. Yeni birim ve gerçek gece UI testi hafta başındaki +2 kira/+2 hasta morali etkisini, açılışın korunmasını ve rapor/HUD/bilanço/kayıt kapanış eşitliğini ölçer.
- **BUG-0012:** Gün kilidi mevcut KRI-06 makbuzunda `nobet_son_gece`, JSON olay izi `nobet_islendi` olarak tutulur. Aynı listede ikinci çağrı, JSON replay ve save/load sonrası işaretsiz eski olay ek geri alım/moral kaybı üretmez; uyarı da tek kezdir. Yeni günün yeni olayı çalışır. Legacy alan yokken nöbet geçmişi uydurulmaz; RNG tüketilmez. Mevcut `IflasYoneticisi.olay_metin` dış olay Dictionary sözleşmesi korunur.
- **BUG-0015:** Yalnız kaynak yorumu ve GDD'deki sabit RNG çekim sayısı iddiası düzeltildi; bulaşma/denge kodu değişmedi. Yeni sınır testinde bir görünür humma kaynağı ve aynı hazır binada üç aday var. Godot 4.7.2'nin gerçek RNG'sinde bulunan **seed=50, zarlar=[27, 28, 44]** tabanda üç çekim/0 vaka, ×2'de iki çekim/2 vaka üretir; test sonraki RNG durumunun farklılığını da doğrular.

Beş yeni birim `*test.gd` keşfiyle, iki yeni `.tscn` akışı açık listeyle sanity'ye eklendi (toplam 326 kontrol). Bu görevde ROADMAP ve `.git` düzenlenmedi; `data/metin/metinler.csv`, kayıt sürümü ve korumalı API imzaları korundu. Asset gerekmedi. Commit/push yapılmadı. Eşzamanlı Tester belge değişiklikleri bu göreve dahil edilmedi.

**BUG-0013 mevcut test uyumu:** İlk tam koşu sırasında 19 görsel akış fikstürünün Kapı fazındaki kaydı Köy'e geçtikten sonra birebir beklediği görüldü. Her birinde yalnız başlangıç fotoğrafına beklenen `faz: "koy"` eklenir (`Dictionary.merged`); ekonomi, stok, RNG ve bütün diğer kayıt alanları hâlâ ekran açılmadan önceki fotoğrafla birebir karşılaştırılır. Kontrol gevşetilmedi ve görsel/üretim kodu değiştirilmedi. Tam dosya listesi: `work/bugfix_0011_0015/faz_test_uyarlamalari.json`. İlk eksik koşu kapanış kanıtı sayılmadı; `work/bugfix_0011_0015_onceki/ilk_kosu/` altında korundu. 19 uyarlamanın tamamı hedefli tekrarda ve sonraki iki tam koşuda geçti.

### Nihai doğrulama ve teslim

Son kaynaklarda önce kullanıcının istediği `--headless --editor --import --quit --path .` komutu çalıştı: **çıkış 0**, betik/parse hatası yok. Ardından istenen tam komut yeniden tamamlandı:

```text
python -B tools/sanity_check.py --godot C:/Users/ds/Desktop/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe --logs work/bugfix_0011_0015
```

Test kayıtları ve editor ayarları için yalnız alt süreçte `APPDATA`/`LOCALAPPDATA`, proje içindeki `work/bugfix_0011_0015/isolated_appdata` ve `isolated_local` dizinlerine yönlendirildi; gerçek kullanıcı kayıtları kullanılmadı. Koşucu hata filtresi değiştirilmedi.

| Son tam koşu ölçütü | Sonuç |
|---|---|
| Tamamlanan kontroller | **326/326** |
| Oyun testi tamamlanma işaretleri | **320/320 GEÇTİ**, eksik işaret yok; editor import işaret beklemez |
| Betik/parse/yükleme hataları | **0 SCRIPT ERROR / Parse Error / Failed to load script / KALDI** |
| İzin verilen sertifika mesajı dışındaki ERROR | **0**, RID/kaynak sızıntısı hatası yok |
| 20 gece dumanı | **20 GECE DUMAN: GEÇTİ** |
| Koşucunun ham sonucu | **5 PASS / 321 FAIL**, exit **1**; 321 FAIL'in tamamı `Failed to read the root certificate store` mesajını içerir |
| Kullanıcının izin verdiği ortam istisnasıyla değerlendirme | **326 kontrol doğrulandı**; ham FAIL'ler saklandı, sertifika mesajı dışında hata veya eksik işaret yok |
| Kaynak/test/veri kararlılığı | 1799 dosyanın hash'i doğrulama sırasında aynı; CSV ve AGENTS başlangıçla birebir aynı; 10 yeni UID tekil |

İkinci koşudaki `kuyu_zehirleme_kontrol`, yalnız motor başlığıyla tamamlanma işareti vermeden sonlandı; nedeni doğrulanmadı. Aynı kaynakla tekil tekrarı exit 0/GEÇTİ verdi. Eksik işaret nihai başarı sayılmadı: ikinci koşu `work/bugfix_0011_0015_onceki/ikinci_kosu/` altında korundu, son import + **326 kontrolün tamamı** yeniden koşuldu; son tam koşuda bu akış da GEÇTİ. Nihai kanıt yalnız `work/bugfix_0011_0015/*.log`, `sanity_runner.txt` ve `sonuc_ozeti.json` dosyalarıdır.

**Kapsam koruması:** ROADMAP'in `Sıradaki` satırı ve ADM-16 maddesi tur sırasında bağımsız düzenlendi. Codex bu görevde ROADMAP'e yazmadı; görev dışı değişim geri alınmadı ve görev manifestine eklenmedi. Tester belgeleri de korundu. Commit/push ve `.git` işlemi yok; asset gerekmedi.

**Değişen dosyalar:** 56 proje dosyası (46 kaynak/test/araç/belge + 10 UID); tam liste `work/bugfix_0011_0015/degisen_dosyalar.md` ve `.json` içinde. **Ayna:** oturum izinleri `C:/Users/ds/Documents/GitHub/GameDevoloper` dizinini salt okunur tutuyor; otomatik eşitleme yapılamadı. Salt okunur karşılaştırma `ayna_on_kontrol.json` içinde; `savunma_guvenligi_kontrol.gd` başlangıcıyla aynada yalnız satır sonu farkı var. Ayna güncellendi iddiası yok.
