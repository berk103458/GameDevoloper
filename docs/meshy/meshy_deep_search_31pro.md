# Kapı Muhafızı Projesi: Meshy AI 3D Üretim Hattı ve Godot Motoru Entegrasyon Raporu

Geç Ortaçağ Anadolu sınır boylarında geçen, Osmanlı uç beyi temalı anlatı ve yönetim oyunu "Kapı Muhafızı" için geniş çaplı bir 3D varlık kütüphanesinin (asset library) üretilmesi, teknik ve sanatsal açıdan büyük bir titizlik gerektirmektedir. Jeneratif yapay zeka araçlarının, özellikle Meshy API'sinin kullanılması, geleneksel 3D modelleme süreçlerine kıyasla muazzam bir hız avantajı sunarken, aynı zamanda jenerik estetik, hatalı topoloji, anakronistik (dönem dışı) ögeler ve bütçe aşımı gibi ciddi riskleri de beraberinde getirmektedir. Godot 4 oyun motorunda hayat bulacak bu projenin temel görsel tonu; toza bulanmış, aşınmış, yere basan ve yaşanmışlık hissi veren sert bir gerçekçilik üzerine kuruludur[1].  

Bu rapor, yaklaşık 900 kredilik oldukça kısıtlı bir API bütçesiyle en az 81 adet yeni taban mesh modelinin (insansılar, yapılar, hayvanlar ve proplar) Meshy platformunda nasıl üretileceğini, optimize edileceğini ve Godot motoruna nasıl entegre edileceğini derinlemesine analiz etmektedir. Araştırma, yapay zekanın "halüsinasyon" olarak adlandırılan yapısal bozulmalarını (fazladan uzuvlar, okunabilir metin üretimi, havada uçuşan parçalar) engelleme stratejilerini, "Smart Topology" mimarisinin oyun donanımları üzerindeki etkilerini ve karmaşık iskelet (rig) ile animasyon ağaçlarının (AnimationTree) programatik olarak nasıl yönetileceğini detaylandırmaktadır. Raporun nihai çıktısı, üretim bandında görev alacak yapay zeka ajanının satır satır uygulayacağı katı bir "Kurallar Dosyası" olarak sunulmuştur.

## 1. Meshy Algoritmik Mimarisi ve İstek (Prompt) Mühendisliği

Meshy'nin Text-to-3D (Metinden 3D'ye) ve Image-to-3D (Görselden 3D'ye) üretim motorları, devasa veri setleri üzerinde eğitilmiş karmaşık difüzyon (diffusion) modellerine dayanmaktadır. Bu modeller, metin girdilerini latent uzayda (latent space) üç boyutlu voksel veya nokta bulutu (point cloud) verilerine dönüştürürken, metnin yapısal hiyerarşisine büyük bir hassasiyet gösterir[2]. Dil modelleri gibi lineer bir mantıkla çalışmayan bu sistemler için yazılacak istek metinlerinin (prompt), sanatsal betimlemelerden ziyade algoritmik bir formüle dayanması şarttır.  

### Etkili İstem (Prompt) Yapısının Formülasyonu

Meshy API dökümantasyonları ve jeneratif 3D pratikleri incelendiğinde, başarılı bir model üretimi için metnin dört ana bloktan oluşması gerektiği görülmektedir: `[Özne] + [Fiziksel Malzeme/Doku] + [Sanat Stili] + [Teknik Kısıtlamalar]`[3]. Yapay zeka, metnin başındaki kelimelere ağırlıklı değer (token weight) atadığı için, en önemli belirleyiciler en başa yazılmalıdır[3].  

Özne (Subject) tanımlamasında kesinlikle tekil isimler kullanılmalıdır. Jeneratif modeller, çoğul isimleri (örneğin "tüccarlar" veya "kılıçlar") algıladığında, aynı mesh üzerinde birden fazla gövdeyi kaynaştırma (fusion) veya fazladan uzuv ekleme eğilimi gösterir[2]. Kapı Muhafızı projesinde bir pazar tezgahı üretilirken "meyveler" demek yerine "a single pile of apples on a wooden cart" şeklinde sınırlandırılmış tekil tanımlar yapmak, yapısal bozulmaları büyük ölçüde engeller.  

Fiziksel malzeme (Material) tanımlaması, PBR (Physically Based Rendering) haritalarının kalitesini doğrudan etkiler. Meshy 7.1 ve T2.5 modelleri, metindeki "aşınmış" (worn), "paslı" (rusted) veya "kaba" (coarse) kelimelerini algılayarak roughness (pürüzlülük) ve metallic (metalik) haritalarını buna göre şekillendirir[3]. Oyunun tonuna uygun olarak, parlak ve pürüzsüz yüzeylerden kaçınılmalı, "raw wood", "hammered dark iron", "dusty canvas" gibi fiziksel gerçekliği vurgulayan materyal sözlükleri kullanılmalıdır.  

### Negatif Prompt Parametresinin Kullanımdan Kalkması ve Dışlayıcı Dil

Geleneksel stabil difüzyon (Stable Diffusion) tabanlı sistemlerde sıklıkla başvurulan `negative_prompt` parametresi, Meshy'nin güncel v2 API altyapısında kullanımdan kaldırılmıştır (deprecated) ve geriye dönük uyumluluk adına tutulsa da modeller üzerinde hiçbir etki yaratmamaktadır[4]. Bu durum, üretim hattında istenmeyen ögelerin (okunabilir yazılar, modern kıyafetler, uçuşan partiküller) engellenmesi için farklı bir strateji gerektirir.  

İstenmeyen unsurlar, pozitif prompt metninin sonuna dışlayıcı ifadeler (exclusionary phrasing) olarak eklenmelidir. Örneğin, modelin etrafında havada asılı duran anlamsız geometrilerin (floating geometry) oluşmasını engellemek için metnin teknik kısıtlamalar bölümüne "single connected object, isolated on empty background, without floating particles" yazılması elzemdir[3]. Benzer şekilde, zırh veya levhalar üzerinde beliren jenerik yapay zeka harflerini engellemek için "no text, no letters, no labels, texture without writing" ifadeleri kesinlikle prompt içine entegre edilmelidir[3].  

### Poz Parametresinin Topolojiye Etkisi

Özellikle insansı (humanoid) karakterlerin, daha sonra Godot motorunda iskelet sistemine (Skeleton3D) bağlanabilmesi için doğru nötr pozda üretilmeleri hayati önem taşır. Kolların gövdeye bitişik olduğu veya bacakların çaprazlandığı modeller, otomatik ağırlık boyama (weight painting) aşamasında kemiklerin yanlış verteksleri etkilemesine (örneğin kol hareket ettiğinde gövdenin de uzaması) neden olur. Meshy API'si, bu sorunu çözmek için `pose_mode` parametresini sunmaktadır[2]. İnsansı karakter üretimlerinde `pose_mode: "t-pose"` parametresinin kullanılması zorunludur. Bu parametre, algoritmayı kolları yere paralel, bacakları omuz hizasında açık bir şekilde çizmeye zorlar ve "kaynaşmış uzuv" hatasını algoritmik olarak önler[6].  

## 2. API Ekonomisi, Model Sınıflandırması ve Bütçe Yönetimi

Oyun üretim hattındaki en büyük kısıt, toplam 81'den fazla varlığın (insansı, hayvan, yapı ve proplar) yaklaşık 900 kredi gibi oldukça sıkı bir API bütçesiyle tamamlanması zorunluluğudur. Bu durum, her API isteğinin maliyet-fayda oranının hesaplanmasını, gereksiz yüksek çözünürlüklü dokulardan kaçınılmasını ve "deneme-yanılma" (reroll) payının minimize edilmesini gerektirir.

### Standart, Lite ve Smart Topology (Akıllı Topoloji) Karşılaştırması

Meshy altyapısında farklı kalite, maliyet ve poligon özelliklerine sahip çeşitli yapay zeka modelleri bulunmaktadır. Bu modellerin API üzerinden seçimi `ai_model` ve `model_type` parametreleri ile yönetilir[5].  

1. **Standart / Yüksek Detay Modelleri (`meshy-7.1`, `latest`):** Sinematik kalitede, çok yüksek poligon sayılı (genellikle 100.000+ yüz) meshler üretir. Bu modellerin varsayılan maliyeti önizleme (mesh) için 20 kredi, dokulandırma (refine) için 10 kredi olmak üzere toplam 30 kredidir[12]. "Kapı Muhafızı" gibi performansa dayalı oyunlar için bu modeller hem poligon bütçesi (oyun motoru performansı) hem de API bütçesi açısından kullanışsızdır. Standart modeller ancak sonradan Remesh API (5 kredi) ile küçültüldüğünde kullanılabilir ki bu da maliyeti 35 krediye çıkarır.
2. **Lite Modeller (`meshy-6-lite`):** Düşük donanım ve API maliyeti hedeflenerek tasarlanmıştır. Sadece mesh üretimi 5 kredi, 2K dokulandırma ise 10 kredi gerektirir (toplam 15 kredi)[5]. Bu model, karmaşık topoloji veya temiz kenar akışı gerektirmeyen arka plan statik nesneleri (çuval, taş, kaya) için ideal bir bütçe kurtarıcıdır.
3. **Smart Topology / Akıllı Topoloji (`meshy-t2.5` ve `meshy-t2`):** Oyun geliştiricileri için özel olarak eğitilmiş bu modeller, doğrudan oyun motoruna girmeye hazır, temiz üçgen (triangle-only) kenar akışına sahip ve parçaları ayrıştırılmış meshler üretir[5]. Remesh işlemine ihtiyaç duymazlar çünkü poligon sayısı (target\_polycount) üretim aşamasında sınırlandırılır[12]. En güncel sürüm olan `meshy-t2.5`, mesh için 5 kredi ve doku için 10 kredi (toplam 15 kredi) harcar[10]. Bu model, insansı karakterler, hayvanlar ve mimari yapılar için kalite ile bütçe arasındaki optimum dengeyi sağlar. `meshy-t2.5` modelinin desteklediği maksimum poligon sayısı 30.000'dir, bu da oyun içi mobil ve PC performans standartlarını fazlasıyla karşılar[1].

### 900 Kredilik Bütçenin Optimizasyonu ve Dağılım Tablosu

Ajanın üretim aşamasında kararsızlığa düşmemesi ve bütçeyi tüketmemesi için varlık sınıflarına göre API stratejisi matematiksel olarak sabitlenmelidir. 81 parçalık setin 900 kredi içerisine sığdırılabilmesi için, çevre detaylarını oluşturan 38 adet prop'un **dokusuz (untextured, mesh-only)** olarak üretilmesi zorunludur. Dokusuz üretilen bu proplar, Godot içinde ortak materyal havuzlarından giydirilecektir.

| Varlık Sınıfı | Adet | `model_type` ve `ai_model` | İşlem Hattı (Pipeline) | Birim Maliyet | Toplam Kredi |
| --- | --- | --- | --- | --- | --- |
| **Proplar** (Kuyu, Çuval, Meşale) | 38 | `smart-topology` / `meshy-t2.5` | Sadece Mesh (Doku Yok) | 5 Kredi | **190 Kredi** |
| **İnsansılar** (Çavuş, Derviş, Tacir) | 13 | `smart-topology` / `meshy-t2.5` | Mesh (5) + Doku (10) + Rig (5) | 20 Kredi | **260 Kredi** |
| **Yapılar** (Kapı, Çadır, Kervansaray) | 24 | `smart-topology` / `meshy-t2.5` | Mesh (5) + Doku (10) | 15 Kredi | **360 Kredi** |
| **Hayvanlar** (At, Deve, Koç) | 6 | `smart-topology` / `meshy-t2.5` | Mesh (5) + Doku (10) (Rig Yok) | 15 Kredi | **90 Kredi** |
| **TOPLAM BÜTÇE PROJEKSİYONU** | **81** | - | - | - | **900 Kredi** |

*Not: Hata payı ve algoritma sapmaları nedeniyle tekrar (reroll) gerekebileceği için bu sınırların katı bir biçimde ajana yüklenmesi, prop'lar için asla doku (refine) isteği atılmaması kritik önem taşır.*

## 3. Stilistik Bütünlük, Ortak Sanat Yönetimi ve PBR Gerçekçiliği

Bir oyun dünyasındaki en büyük algısal kırılma, varlıkların birbirinden farklı sanat dillerine veya dönemlerine ait görünmesidir. Yapay zeka, doğası gereği jenerik ve ortalama sonuçlar üretmeye eğilimlidir. Eğer bir modele sadece "a medieval tent" yazılırsa, sistem Avrupa gotik fantezisinden fırlamış, ipek kumaşlı ve altın işlemeli, tamamen "Kapı Muhafızı" doğasına aykırı bir sonuç verecektir.

### Ortak Stil Çapası (Style Anchor) Mantığı

Tüm modellerin aynı evrene (geç Ortaçağ Anadolu sınırı) ait olduğunu algoritmaya dayatmak için, her promptun sonuna eklenecek değişmez bir "Stil Çapası" geliştirilmiştir. Bu metin bloğu; dönemi, coğrafyayı, tonu, malzemelerin dokusal yıpranmışlığını ve kaçınılması gereken hataları tek bir cümlede özetler[3].  

Tavsiye edilen ve KURALLAR dosyasına işlenmesi gereken ortak stil çapası şudur:*", late medieval 14th century Anatolian frontier game asset, ottoman border, worn and dusty physical materials, grounded historical realistic style, serious tone, single connected object, no text, no modern elements"*

Bu çapa, yapay zekanın gizli uzayında (latent space) arama yaparken, filtreyi "Tarihsel Gerçekçilik", "Kir/Toz" ve "Anadolu/Osmanlı" etiketlerine daraltarak, stil kaymalarını ve "Avrupa Şatosu" klişelerini doğrudan engeller.

### Fiziksel Tabanlı İşleme (PBR) ve Yüzey Dokuları

Godot 4 motoru, ışıklandırma ve materyal sisteminde doğrudan PBR standardını (Albedo/Diffuse, Metallic, Roughness, Normal, Ambient Occlusion) kullanır[14]. Meshy API'si, `enable_pbr: true` parametresi gönderildiğinde, baz renk (base color) dokusuna ek olarak metalik, pürüzlülük ve normal haritalarını da üretir[5]. "Kapı Muhafızı" atmosferindeki yıpranmışlık hissi; aşınmış ahşabın matlığı (yüksek roughness), kılıçların veya demir menteşelerin oksitlenmiş, yer yer parlayan doğası (karışık metallic ve roughness değerleri) ancak bu PBR haritaları sayesinde oyuncuya geçer[14].  

Dokusuz üretilecek olan 38 prop dışında kalan insansı, hayvan ve yapı modellerinde `enable_pbr: true` parametresinin Refine (doku işlemi) aşamasında API'ye gönderilmesi, görsel kalitenin motor içindeki inandırıcılığı için şarttır. Modellerin doku çözünürlüğü olarak `texture_resolution: "2k"` kullanılması, hem mobil/orta segment PC performansı hem de maliyet optimizasyonu açısından idealdir; 4K veya 8K dokular hem bütçeyi tüketir hem de oyunun bellek (VRAM) sınırlarını zorlar[5].  

### Tohum (Seed) Değerleri ile Tutarlılık

Algoritmik üretimde varyasyonları kontrol etmenin bir diğer yolu `seed` (tohum) parametresini kullanmaktır[11]. Benzer prop'lar (örneğin farklı çuval veya kaya tipleri) üretilirken, eğer ilk sonuç başarılıysa aynı `seed` değerini kullanıp prompt üzerinde sadece ufak tefek değişiklikler ("a large sack" yerine "a small sack") yapmak, varlıkların yüzey renklerini ve ışık tepkilerini benzer tutarak oyun içinde daha organik bir görünüm sağlar.  

## 4. Karakter Topolojisi, İskelet Sistemi (Rigging) ve Animasyon Ağları

Statik nesnelerin aksine insansı (humanoid) karakterlerin oyun motoruna alınmadan önce eklem ve kemik hiyerarşisiyle donatılması (rigging) ve bu hiyerarşiye uygun animasyon kliplerinin bağlanması gerekir. Meshy Rigging API (`/openapi/v1/rigging`) bu işlemi otomatik olarak gerçekleştirerek büyük bir iş yükünü ortadan kaldırır.

### Rigging API Teknik Sınırları ve Parametreleri

Meshy Rigging algoritması yalnızca standart iki ayaklı (bipedal), kolları ve bacakları net bir şekilde ayrışmış, dokulandırılmış insansı karakterler üzerinde çalışmaktadır[18]. Karakterin topolojisi en fazla 380.000 üçgen (triangle) barındırmalıdır. `meshy-t2.5` modelinde üretilen `smart-topology` varlıklar, maksimum 30.000 üçgene sahip olacağından bu limite takılmaz ve sorunsuz işlenir[10].  

En kritik kurallardan biri yön (orientation) ve poz kuralıdır. Algoritmanın kemik sistemini doğru yerleştirebilmesi için modelin yüzünün `+Z` eksenine bakması ve `pose_mode: "t-pose"` veya `"a-pose"` formunda olması zorunludur[2]. Ayrıca Rigging API'sine gönderilen `height_meters` (örneğin 1.7 veya 1.8) parametresi, modelin oyun motoruna doğru metrik sistemde aktarılmasını sağlar[18]. Bu adım atlanırsa karakterler oyun evreninde bir dev ya da karınca boyutunda görünebilir.  

**Hayvanlara İlişkin Kesin Kural:** Meshy Rigging API'si, at, kurt, keçi veya deve gibi dört ayaklı (quadruped) canlıları algılayacak veya kemiklendirecek bir iskelet şablonuna sahip değildir. API dokümantasyonlarına göre, insan dışı anatomilerde algoritma doğrudan `422 Unprocessable Entity` (İşlenemeyen Varlık) veya `400 Bad Request` hatası döndürür ve görevi iptal eder[18]. Bu sebeple, ajanın kredi ve zaman israfını önlemek adına, 6 adet hayvan modeli için KESİNLİKLE Rig API isteği atmaması, bu canlıları sadece `smart-topology` ile nötr pozda statik varlıklar olarak teslim etmesi gereklidir.  

### Animasyon API ve Eylemlerin Birleştirilmesi (Action IDs)

Meshy Animasyon API'si (`/openapi/v1/animations`), başarıyla riglenmiş bir insansı modelin (geçerli bir `rig_task_id` üzerinden) kütüphanedeki hazır eylemlerle (action) canlandırılmasını sağlar[21]. Kapı Muhafızı oyunu için, yürüme, koşma, boşta bekleme (idle), saldırı vb. eylemlerden oluşan 29 adet insan eylemi mevcuttur.  

Eylem başına maliyet 3 kredidir. Önemli bir optimizasyon tekniği olarak API, tek bir istekte en fazla 10 farklı animasyonun `action_ids` dizisi (array) olarak gönderilmesine izin vermektedir (Örnek: `"action_ids": [10, 25, 92]`)[21]. Bu yöntemle gönderilen çoklu animasyonlar, Meshy tarafından tek birleştirilmiş GLB dosyası olarak geri döndürülür[21].  

Godot motorunda bir karakterin hareket mantığını yöneten `AnimationTree` (Animasyon Ağacı) ve `AnimationNodeStateMachine` (Durum Makinesi) sistemleri, tüm kliplerin tek bir `AnimationPlayer` nodu altında bulunmasını gerektirir[23]. Ajanın `action_ids` dizisini kullanarak tüm klipleri (örneğin Yürüme, Bekleme, Ölüm) tek bir GLB dosyası içerisine gömmesi, oyun motorundaki aktarım ve entegrasyon sürecini muazzam ölçüde hızlandırır[21].  

## 5. Yapay Zeka Hatalarının (AI Jank) Teşhisi ve Önleme Stratejileri

Yapay zeka modelleri, bağlamı her zaman fiziksel dünyanın kurallarına göre kuramaz. Bu durum, oyunun "gerçekçilik" duvarını yıkan tipik hatalara (AI Jank) yol açar. Ajan, bu hataları önlemek için prompt mühendisliğini bir bariyer olarak kullanmalıdır.

1. **Ekstra Uzuvlar ve Simetri Bozukluğu:** Bir çavuş modeline elinde hem mızrak hem de kalkan tutması söylenirse, model çoğu zaman üç kollu olarak üretilir. Bu, modelin farklı referans açılarından derlenmesinden kaynaklanır. *Önlem:* Prompt'ta "bipedal", "normal human anatomy", "symmetric face" gibi ifadeler kullanılmalı, karakterin elinde tutacağı eşyalar yerine (silahlar Godot'ta `BoneAttachment3D` kullanılarak sonradan ele ekleneceğinden) sadece kıyafeti betimlenmelidir[28].
2. **Okunabilir Yazıların Çıkması:** 3D model yüzeyinde anlamsız Latin veya Arapça benzeri harflerin belirmesi dönemsel gerçekçiliği bozar. *Önlem:* "no readable text, no letters, no writing" katı kuralı her modele uygulanmalıdır[3].
3. **Havada Uçuşan Parçalar (Floating Geometry):** Modelin yanında asılı duran partiküller, taşlar veya alev efektleri, oyun içinde hitbox (çarpışma kutusu) sorunlarına yol açar. *Önlem:* "single connected object, isolated on empty background" komutu algoritmayı modeli yekpare üretmeye zorlar[4].
4. **Modern Objelerin Sızması (Anakronizm):** "Köy kapısı" denildiğinde modelde modern bir asma kilit belirmesi veya "pazar tezgahı"nda naylon branda görülmesi sık yaşanan bir anakronizm sorunudur. *Önlem:* "late medieval 14th century, rough historical materials" çapası dönemi kilitler.

## 6. Godot 4 GLB Entegrasyonu, Ölçek ve Pivot Pratikleri

Meshy'den alınan GLB dosyası, mesh geometrisini, PBR materyallerini, iskeleti (`Skeleton3D`) ve animasyon kliplerini (`AnimationPlayer`) tek bir paket halinde içerir[5]. Godot 4 motoru bu formatı yerel (native) olarak destekler ve sahneleri `Node3D` hiyerarşisi altında oluşturur[27].  

### Ölçek (Scale) ve Metrik Sistem

Godot'ta uzaysal matematiğin doğru çalışabilmesi, fizikteki yerçekimi hızının veya karakter çarpışma kapsüllerinin (CollisionShape3D) tutarlı olabilmesi için 1 birimin 1 metreye eşit olduğu metrik sistem benimsenmiştir[31]. Modeller, oyun motorunda devasa veya mikroskobik boyutlarda gelmemelidir. Meshy API'sinde riglenen karakterler için `height_meters` parametresi bu sorunu çözerken, yapılar ve proplar için `auto_size: true` parametresi AI vizyonu yardımıyla nesnenin gerçek dünya ölçeğini tahmin edip modeli buna göre boyutlandırır[2].  

### Pivot Noktası (Origin)

Bir modelin pivot (orijin) noktası, modelin dünya koordinatlarında etrafında döndüğü veya yere basan merkezidir. Godot içinde bir kervansarayı veya çadırı haritaya yerleştirirken, pivot noktası modelin tam merkezinde (center) olursa modelin yarısı yerin altına gömülür. Bu nedenle Meshy API'sine gönderilen yapı ve prop isteklerinde modelin yere basan yüzeyinin sıfır noktası kabul edilmesi için `origin_at: "bottom"` parametresinin (veya `auto_size` ile varsayılan davranışın) korunması kritik bir entegrasyon kuralıdır[29].  

### Kemik Haritalama (Retargeting) ve Animasyon Döngüleri

Depoda halihazırda bulunan 44 karakter yürüme animasyonu ile yeni üretilecek olanların aynı sistemde çalışması için Godot'un "Retargeting" (Yeniden Hedefleme) sistemi kullanılır. Meshy'nin rigi, içe aktarım (Import) sırasında Advanced (Gelişmiş) sekmesinden `BoneMap` atanarak `SkeletonProfileHumanoid` profili ile eşleştirilir[33]. Bu sayede A karakterinin koşma animasyonu B karakterine hiçbir kod yazılmadan aktarılabilir[23].  

Son olarak, Meshy'den gelen GLB dosyası içindeki "yürüme" veya "koşma" gibi kliplerin Godot'ta sürekli tekrarlanması (loop) için, import ayarlarından her animasyonun "Loop Mode" seçeneği "Linear" olarak ayarlanmalıdır. Bu işlem kodla yapılamaz, içe aktarma aşamasında .import dosyasına kaydedilmelidir[28].  

# KURALLAR DOSYASI (Yapay Zeka Ajanı İçin Kesin Uygulama Yönergesi)

**AJANIN DİKKATİNE:** Bu dosya, Kapı Muhafızı oyunu için Meshy API'sinde 3D model ve animasyon üretecek yapay zeka ajanı için **kesin, esnetilemez ve doğrudan kopyalanabilir** sistem komutlarını içerir. Bu kuralların dışına çıkılması, API kredisinin boşa gitmesine ve projenin teknik olarak çökmesine neden olacaktır.

## 1. Uyması Zorunlu Stil ve Yasaklar

Üretilecek tüm modeller geç Ortaçağ (14. - 15. yüzyıl) Anadolu sınır boyu estetiğine uymak zorundadır. Oyunun doğasını bozan hiçbir unsur kabul edilemez.

- **İzin Verilen Malzemeler:** Aşınmış ahşap (worn wood), paslı demir (rusted hammered iron), kaba yün (coarse wool), keçe, kaba yontulmuş taş, deri, toprak ve toz.
- **Kesinlikle Yasak (YOKTUR):** Modern giysi/eşyalar, jenerik fantastik silahlar, parlayan büyülü objeler, abartılı şato gotik mimarisi, plastik görünümlü yansımalar.
- **Anatomi İhlalleri Yasaktır:** Karakterler "bipedal", normal insan ölçülerinde ve simetrik olmalıdır. Mobil oyun veya sevimli "chibi" tarzı yasaktır.
- **Yazı Yasağı:** Hiçbir 3D modelin yüzeyinde, kaplamasında, tabelasında veya kumaşında Latince, Arapça veya herhangi bir okunabilir/okunamaz uydurma yazı, amblem, logo BULUNAMAZ. ("no readable text, no letters" zorunludur).
- **Uçuşan Geometri Yasağı:** Model etrafında havada asılı duran parçalar, efektler veya çoklu nesneler yasaktır. ("single connected object, isolated on empty background" zorunludur).

## 2. Ortak Stil Çapası (Her Prompta Eklenecek)

Ajan, yazdığı her model betimlemesinin (prompt) sonuna aşağıdaki metin bloğunu **virgülle ayırarak** kesinlikle ekleyecektir:

> `", late medieval 14th century Anatolian frontier game asset, ottoman border, worn and dusty physical materials, grounded historical realistic style, serious tone, single connected object, no text, no letters, no modern elements"`

## 3. Lite / Standart ve Bütçe Seçim Kuralı (Sınıflandırma)

900 API kredilik bütçeyi korumak için aşağıdaki kural matrisinin dışına **çıkılamaz**:

- **Proplar (38 adet):** Kredi tasarrufu için SADECE MESH (Dokusuz) üretilecektir. `model_type: "smart-topology"`, `ai_model: "meshy-t2.5"`, **`should_texture: false`** kullanılacaktır. (Maliyet: 5 kredi).
- **İnsansılar (13 adet):** `model_type: "smart-topology"`, `ai_model: "meshy-t2.5"`, **`should_texture: true`**, **`pose_mode: "t-pose"`**. (Mesh+Doku 15 kredi, Rig 5 kredi. PBR haritaları eklenecek).
- **Yapılar (24 adet):** `model_type: "smart-topology"`, `ai_model: "meshy-t2.5"`, **`should_texture: true`**. (Maliyet: 15 kredi).
- **Hayvanlar (6 adet):** `model_type: "smart-topology"`, `ai_model: "meshy-t2.5"`, **`should_texture: true`**. (Maliyet: 15 kredi. RIG YAPILMAYACAKTIR).

## 4. İskelet (Rig) ve Animasyon Kuralları

- **Rig Sadece İnsansılara Yapılır:** Hayvanlara, proplara veya yapılara asla Rig API (`/openapi/v1/rigging`) isteği gönderilmeyecektir. Hayvanlarda API "Unprocessable Entity" hatası verir, krediyi boşa harcar.
- **Pozisyon ve Boyut:** İnsansılar üretilirken Text-to-3D aşamasında `pose_mode: "t-pose"` gönderilmesi, Rig aşamasında ise Godot dünyasına uyması için `height_meters: 1.7` (veya uygun insan boyu) parametresinin ayarlanması ZORUNLUDUR.
- **Animasyon API Kullanımı:** Elde edilen `rig_task_id` kullanılarak Animasyon API çağrısı yapılacaktır. 29 istenen eylem, kredi optimizasyonu için `action_ids` array parametresi içine virgülle dizilerek (Ör: `[10, 25, 92]`, istek başına en fazla 10 adet) gönderilmelidir. Bu sayede tüm klipler Godot'un `AnimationPlayer` nodu için tek bir GLB'de birleştirilir.

## 5. Teslim Öncesi Ajan Kontrol Listesi

Ajan, üretilen GLB önizlemesini (`thumbnail_url`) değerlendirmeli, şu hatalardan biri varsa modeli reddetmeli ve promptu iyileştirerek işlemi (reroll) tekrarlamalıdır:

1. [ ] Havada uçuşan anlamsız obje veya partiküller var mı? (Varsa Reddet).
2. [ ] Herhangi bir yüzeyde harf, yazı veya sembolik kelime oluşmuş mu? (Varsa Reddet).
3. [ ] İnsansı karakterde 3. kol, asimetrik bacak veya kılıcın karakterle kaynaşması var mı? (Varsa Reddet).
4. [ ] İnsansı karakter T-Pose duruşunda değil mi? (Kollar aşağıdaysa Rig bozulur, Reddet).
5. [ ] 38 Prop dokulu olarak mı üretildi? (Bütçe ihlali, Reddet, `should_texture: false` yap).

## 6. Sınıflara Göre Tam API Prompt / JSON Şablonları

*NOT: Aşağıdaki örnekler Meshy v2 API yapısına uygun, ajanın doğrudan kodunda kullanabileceği "Payload" örnekleridir.*

**Örnek A: ÇAVUŞ (İnsansı, Rig'e ve Dokuya Hazırlık)**

JSON

```
{
  "mode": "preview",
  "prompt": "A detailed bipedal human character, an older veteran village sergeant wearing a worn leather vest over a dirty coarse wool tunic, iron belt buckle, carrying a simple wooden staff, normal human anatomy, late medieval 14th century Anatolian frontier game asset, ottoman border, worn and dusty physical materials, grounded historical realistic style, serious tone, single connected object, no text, no letters, no modern elements",
  "model_type": "smart-topology",
  "ai_model": "meshy-t2.5",
  "pose_mode": "t-pose",
  "target_polycount": 15000,
  "target_formats": ["glb"]
}
```

*(Ajan bu preview tamamlanınca, `preview_task_id` alıp `mode: "refine"` ve `enable_pbr: true` ile dokulandırma isteği atmalıdır. Sonra Rig API çalıştırılmalıdır).*

**Örnek B: DERVİŞ (İnsansı, Rig'e ve Dokuya Hazırlık)**

JSON

```
{
  "mode": "preview",
  "prompt": "A detailed bipedal human character, a wandering mystic dervish wearing a ragged long coarse wool cloak, a conical felt hat, simple leather sandals, normal human anatomy, late medieval 14th century Anatolian frontier game asset, ottoman border, worn and dusty physical materials, grounded historical realistic style, serious tone, single connected object, no text, no letters, no modern elements",
  "model_type": "smart-topology",
  "ai_model": "meshy-t2.5",
  "pose_mode": "t-pose",
  "target_polycount": 15000,
  "target_formats": ["glb"]
}
```

**Örnek C: KÖY KAPISI (Yapı, Rig YOK, Doku VAR)**

JSON

```
{
  "mode": "preview",
  "prompt": "A medieval architecture structure, a robust border outpost village gate, thick weathered timber logs forming a palisade, heavy solid wood double doors with rusted iron hinges, mud on the base, isolated structure, late medieval 14th century Anatolian frontier game asset, ottoman border, worn and dusty physical materials, grounded historical realistic style, serious tone, single connected object, no text, no letters, no modern elements",
  "model_type": "smart-topology",
  "ai_model": "meshy-t2.5",
  "target_polycount": 30000,
  "target_formats": ["glb"]
}
```

**Örnek D: DEVE (Hayvan, Rig KESİNLİKLE YOK, Doku VAR)**

JSON

```
{
  "mode": "preview",
  "prompt": "A quadruped animal, a sturdy Anatolian pack camel, worn brown fur, equipped with empty wooden panniers strapped with rough leather belts, natural standing pose, late medieval 14th century Anatolian frontier game asset, ottoman border, worn and dusty physical materials, grounded historical realistic style, serious tone, single connected object, no text, no letters, no modern elements",
  "model_type": "smart-topology",
  "ai_model": "meshy-t2.5",
  "target_polycount": 15000,
  "target_formats": ["glb"]
}
```

**Örnek E: MEŞALE (Prop, SADECE MESH / DOKU YOK, Bütçe Kurtarıcı)**

JSON

```
{
  "mode": "preview",
  "prompt": "A static game prop, a rustic hand-held torch made from a split rough wooden branch, tightly bound with dark iron wire at the top holding unlit rags, isolated object, late medieval 14th century Anatolian frontier game asset, ottoman border, worn and dusty physical materials, grounded historical realistic style, serious tone, single connected object, no text, no letters, no modern elements",
  "model_type": "smart-topology",
  "ai_model": "meshy-t2.5",
  "should_texture": false,
  "target_polycount": 4000,
  "target_formats": ["glb"]
}
```

## Kaynaklar

1. [docs.meshy.ai — Game Assets: Create 3D Game Models with AI | Meshy Docs](https://docs.meshy.ai/en/webapp/guides/use-cases/game-assets)
2. [typingmind.com — Meshy 3d by calesthio — AI Skill for Any LLM | TypingMind](https://www.typingmind.com/skills/calesthio-meshy-3d)
3. [docs.meshy.ai — 3D Prompting Guide: Best Practices and Pro Tips | Meshy Docs](https://docs.meshy.ai/en/webapp/guides/prompting)
4. [docs.meshy.ai — Text to 3D: Generate 3D Models from Prompts | Meshy Docs](https://docs.meshy.ai/en/webapp/text-to-3d)
5. [docs.meshy.ai — Image to 3D API - Meshy Docs](https://docs.meshy.ai/en/api/image-to-3d)
6. [docs.meshy.ai — Metinden 3D'ye API - Meshy Docs](https://docs.meshy.ai/tr/api/text-to-3d)
7. [docs.meshy.ai — Creative Lab — Vinyl Figure API | Meshy Docs](https://docs.meshy.ai/en/api/creative-lab-vinyl-figure)
8. [docs.meshy.ai — คู่มือ 3D prompt: แนวทางและเคล็ดลับ - Meshy Docs](https://docs.meshy.ai/th/webapp/guides/prompting)
9. [fal.ai — Meshy 7.1 Image to 3D API Docs - Fal.ai](https://fal.ai/models/meshy/v7.1/image-to-3d/api)
10. [docs.meshy.ai — Changelog - Meshy Docs](https://docs.meshy.ai/en/api/changelog)
11. [comfy.icu — meshy / v7 / imageTo3D - ComfyUI Cloud - Comfy.ICU](https://comfy.icu/node/CivitaiPolyGenFalMeshyV7ImageTo3D)
12. [docs.meshy.ai — Text to 3D API - Meshy Docs](https://docs.meshy.ai/en/api/text-to-3d)
13. [docs.meshy.ai](https://docs.meshy.ai/en/api/pricing)
14. [parse.gl — I cannot create 3D assets fast enough for our game… - Parse](https://parse.gl/questions/i-cannot-create-3d-assets-fast-enough-for-our-game-development-pipeline-who-offers-generative-ai-for-3d-textures-and-meshes--ebbd1016-a243-4a45-bf2c-112cdb23d9af)
15. [github.com — Meshy for Game Asset Generation: Workflows for Unity, Unreal](https://github.com/meshy-dev/game-asset-pipeline)
16. [docs.meshy.ai — Multi-Image to 3D API - Meshy Docs](https://docs.meshy.ai/en/api/multi-image-to-3d)
17. [pixazo.ai — Meshy 7.1 API, Meshy 7 API, Meshy 6 API: Pricing, Documentation](https://www.pixazo.ai/models/meshy-3d)
18. [docs.meshy.ai — Rigging API - Meshy Docs](https://docs.meshy.ai/en/api/rigging)
19. [wavespeed.ai — Meshy V7.1 Multi Image To 3d API Documentation - WaveSpeedAI](https://wavespeed.ai/docs/docs-api/meshy/meshy-v7.1-multi-image-to-3d)
20. [docs.meshy.ai — Text to Motion API - Meshy Docs](https://docs.meshy.ai/en/api/text-to-motion)
21. [docs.meshy.ai — Animation API - Meshy Docs](https://docs.meshy.ai/en/api/animation)
22. [docs.meshy.ai — API de Animación | Meshy Docs](https://docs.meshy.ai/es/api/animation)
23. [mocaponline.com — Godot Animation System Guide: AnimationPlayer - MoCap Online](https://mocaponline.com/blogs/mocap-news/godot-animation-system-guide)
24. [stackoverflow.com — Animation player Tree how to use for gdscript (Godot 4.0)](https://stackoverflow.com/questions/75695489/animation-player-tree-how-to-use-for-gdscript-godot-4-0)
25. [docs.godotengine.org — Using AnimationTree — Godot Engine (4.4) documentation in English](https://docs.godotengine.org/en/4.4/tutorials/animation/animation_tree.html)
26. [reddit.com — State Machine connecting to animation tree : r/godot - Reddit](https://www.reddit.com/r/godot/comments/1qk793r/state_machine_connecting_to_animation_tree/)
27. [ludo.ai — How to Import an AI-Generated Rigged GLB into Godot, Unity](https://ludo.ai/docs/3d-generator/export-to-unity-godot-unreal)
28. [hatchery3d.com — Godot 4: import a GLB character with animations · Hatchery3D](https://hatchery3d.com/blog/rigged-glb-character-in-godot-4)
29. [glama.ai — meshy_multi_image_to_3d - Meshy MCP Server | Glama](https://glama.ai/mcp/servers/meshy-dev/meshy-mcp-server/tools/meshy_multi_image_to_3d)
30. [app.cinevva.com — Blender to Godot 4 Export Checklist: glTF Settings, Animations, and](https://app.cinevva.com/guides/blender-to-godot-export-checklist)
31. [github.com — CITY-ZERO/docs/CONTENT_PIPELINE.md at main · stuffthings15](https://github.com/stuffthings15/CITY-ZERO/blob/main/docs/CONTENT_PIPELINE.md)
32. [docs.meshy.ai — Remesh API - Meshy Docs](https://docs.meshy.ai/en/api/remesh)
33. [humgen3d.com — Export to Godot | Human Generator docs](https://humgen3d.com/docs/process/export-to-godot)
34. [uhiyama-lab.com — Godot 3D Model Import Basics: Bring In glTF, Fix Its Scale and](https://uhiyama-lab.com/en/notes/godot/3d-model-import-gltf-retarget/)
