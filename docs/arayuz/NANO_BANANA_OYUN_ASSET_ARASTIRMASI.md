# Nano Banana: oyuna hazır 2D görsel ve animasyon araştırması (Kalfa)

12 Ekim 2026. Kullanıcı önce araştırma, sonra yeni prompt istedi. Bu teslimde görsel veya oyun kodu üretilmedi. Yeni ROADMAP maddesi alınmadı; ARY-01 sahipliği korunur.

## Sonuç

Nano Banana ile bu oyunun atmosferik arka planı, panel malzemesi, ikon ve portre resmi üretilebilir. **Resmi üretmek ile oyuna hazır dosyayı hazırlamak ayrı aşamalardır.** Önceki promptlarım kesin piksel ölçüsü, gerçek alfa ve sabit buton geometrisini aynı resim üretim isteğine yükledi. Yeni akış bu beklentiyi kaldırır: bir istekte bir resim, ardından maskeleme, kadraj/ölçü ve motor ayarı.

Google'ın belgesi referanslı düzenlemeyi destekler; çıktı adedinin her zaman istenene uymadığını da belirtir. Boyut/oran seçenekleri model ve kullanılan yüzeye bağlıdır. API örneği Gemini sohbetindeki ayarların birebir karşılığı sayılmaz. [Google görüntü üretimi belgesi](https://ai.google.dev/gemini-api/docs/image-generation).

Google'ın Pro rehberi açık kompozisyon ve referans rollerini önerir; karakter tutarlılığı ve karmaşık düzenlemelerde sınırlama olduğunu da söyler. Bu nedenle referans, piksel düzeyinde eşitlik garantisi değildir. [Google Pro prompt rehberi](https://blog.google/products-and-platforms/products/gemini/prompting-tips-nano-banana-pro/).

Gerçek alfa üretemeyeceğine dair bütün sürümleri kapsayan resmî hüküm bulmadım. Buna karşılık Google forumunda bir Pro kullanıcısı saydamlık yerine çizilmiş damalar aldığını bildiriyor; destek yanıtı örnek istiyor, kesin özellik açıklaması vermiyor. Bu bir kullanıcı bulgusudur. [Forum bildirimi](https://discuss.ai.google.dev/t/how-can-i-make-the-background-transparent/111698). Bizim ikinci paketimizin tamamı da RGB/JPEG: **bu teslimlerde alfa yok**. Saydamlığı promptun başarısına bırakmayacağız.

## İnsanlar nasıl kullanmış?

| Birincil kaynak | Paylaşılan yöntem | Bizim için ders |
|---|---|---|
| [karem505 — character-animation-skill](https://github.com/karem505/character-animation-skill) | Nano Banana **2** ile sabit ana resimden tek tek poz düzenlemeleri; hizalama, arka plan ayırma ve kare birleştirme. Tek sprite sheet denemesinde ölçek sıçraması ve kaybolan uzuvlar bildirmiş. | Her kare aynı ana resmi referans alsın. Model çıktısı ile sonradan saydamlaştırılmış çıktıyı karıştırma. Bu örnek Pro'yu bizim oyunumuzda doğrulayan test değildir. |
| [Dream_Ep — kendi oyun üretim akışı](https://www.reddit.com/r/aigamedev/comments/1r02x55/spent_2_weeks_building_a_tool_instead_of_my_game/) | Nano Banana ile temel sprite, Grok ile hareket videosu, ardından kare çıkarma ve temizleme. Yorumlarda hizalama/titreme sorunu da konuşuluyor. | Video, hareket kaynağı olabilir; seçilen karelerin sabit boyut ve ortak pivotla hazırlanması gerekir. Her video motor teslimi değildir. |
| [SpriteMaster — geliştiricinin kendi araç sayfası](https://spritemaster.pages.dev/) | Video karelerini seçme, renk anahtarıyla zemin çıkarma, hale temizliği ve PNG sprite sheet dışa aktarma özelliklerini anlatıyor. | Örnek bir hazırlama aracı; bu görevde yüklenmedi, çalıştırılmadı ve sonucu bağımsız test edilmedi. |
| [Selphea — kendi Spine2D çalışması](https://www.reddit.com/r/StableDiffusion/comments/1ryqfe9/sharing_my_gen_ai_workflow_for_animating_my/) | Karakter tasarımı/poz araçları ve Nano Banana karakter levhasından sonra Spine2D'de elle animasyon; saldırı konumu ve zamanlamasını kontrol etmek için. | Resmi katmanlara ayırıp hareketi elle kurmak ayrı bir seçenek. Bu 2D iskelet yöntemidir; 3D model üretimi değildir. |

Bunlar geliştiricilerin kendi paylaşımlarıdır; kontrollü kalite karşılaştırması veya tamamlanmış ticari oyun kanıtı sayılmaz. Sonuçları oyunumuzda denemeden başarı garantisi vermiyoruz.

## Bizim statik UI akışımız

1. Gemini'de görüntü üretimini seç. Her mesajda **yalnız bir parça** iste. On parça, on ayrı üretim isteğidir; tek mesajda on görsel istemiyoruz.
2. Ahmet'in beğendiği bir gerçek resmi stil referansı olarak yükle. Dosya adını yazmak resmi yüklemek yerine geçmez. Yeni parça isterken referansın yalnız malzeme/renk için olduğunu açıkla; aynı şeklin yeni hali isteniyorsa onaylı temel parçayı ver.
3. Arka planı tam sahne olarak üret. Saydam UI için resme dama çizdirmek yerine tek renk magenta zemin iste. Bu zemin **geçici ayırma zemini**, oyun rengi değildir. Nesnede magenta kullanma.
4. Resmi gerçekten indir. Yanıtta yalnız `There is a file...` yazıyorsa teslim alınmış dosya sayılmaz. Yeniden gerçek görüntü çıktısı iste; dosya adı üzerinden görünmeyen resmi kurtarabileceğimizi varsayma.
5. Kaynağı koru. Magentayı maskele; JPEG sıkıştırması ve ışık taşması varsa kenarları elle düzelt. Karmaşık saç/duman için renk anahtarı yetmeyebilir. Beyaz veya damalı eski resmi körlemesine renk silerek temizleme: nesnenin içindeki aynı renkleri de silebilir.
6. Kesin hedef ölçüyü editörde hazırla. Dış pay ve çerçevenin iç deliği için gerçek alfa üret; düzleştirilmiş PNG alfa değildir. Sahne resmini germek yerine kadrajı koru. 2K kaynak otomatik olarak bozuk sayılmaz; hedef kullanım ve sanat ayrıntısına göre değerlendirilir. 4K istenirse uygulamadaki gerçek ayarı ayrıca kontrol et.
7. 9-slice kesimlerini **son dosya ölçüsü** üzerinden ayarla. Köşe süsü kesim bandını geçiyorsa bant/süs düzeltilir; sayısal kesim çizgisini modele yazmak bu kontrolün yerini tutmaz. [Godot NinePatchRect](https://docs.godotengine.org/en/stable/classes/class_ninepatchrect.html).
8. Butonun normal resmi kabul edilince hover/basılı/pasif aynı dokudan vurgu, gölge ve soluklaştırma ile türetilir. Sekmenin seçili hali, onay işareti ve odak çizgisi de ayrı küçük katman olabilir. Bunlar tasarım önerisidir; bu teslimde oyun temasına uygulanmadı.

Magenta arka planın tamamen düzgün çıkması da garanti değildir. Arka plan lekeli veya nesnenin kenarında pembe yansıma varsa otomatik silmenin ardından elle kontrol gerekir. Görsel üretim aracı, bir raster editörün kesin maske işlemi yerine geçmez.

## Ardışık fotoğraflardan animasyon

**Tek tek kare:** önce sabit ana portre veya nesne resmi seçilir. Her üretimde aynı ana resim yüklenir; yalnız o karedeki poz değişikliği istenir. Bir önceki bozulmuş kareyi sürekli devralmak kimlik kaymasını büyütebilir. Teslimden sonra bütün kareler ortak tuval, ölçek ve pivotta hizalanır; her birine ayrı dar kırpma yapılmaz. Uzuv/yüz, kontur ve zemin kontrol edilir. Modelin tutarlılığı yine gözle doğrulanır.

**Video → kare:** onaylı temel resimden kısa, sabit kameralı hareket videosu başka bir video üretim aracıyla hazırlanabilir. Uygun hareket aralığı seçilir, bozuk/bulanık kareler elenir, zemin çıkarılır ve kareler hizalanır. Bu, Nano Banana Pro'nun tek başına video ürettiği anlamına gelmez. Zamanlama ve döngü birleşimi ayrıca düzeltilir.

**Katman → motor animasyonu:** sabit kandil resmi, alev ve ışık katmanı ayrı tutulabilir; portrede gövde ve yüz katmanları elle hazırlanabilir. Küçük ışık titreşimi, imleç veya yükleme hareketinde bütün ekranı her karede yeniden çizdirmek yerine bu yöntemi öneriyorum. Böylece taş/ahşap/yazı alanı titremez. Tam karakter yürümesi için uygun rig veya tek tek kare hazırlama ayrı iştir; 3D oyun karakterlerine 2D sprite yaması yapmıyoruz.

Godot, ayrı kareleri veya sprite sheet'i `AnimatedSprite2D`/`SpriteFrames` ile oynatabilir. Bu teslimde yalnız üretim planı var, oyuna animasyon bağlanmadı. [Godot sprite animasyon rehberi](https://docs.godotengine.org/en/stable/tutorials/2d/2d_sprite_animation.html).

İlk küçük deneme için beş karelik portre göz kırpma planı yeni prompt belgesinde bulunur. Kapalı gözde kısa tutma, ardından normal resimde uzun bekleme uygulanabilir; tüm kareler eşit süre olmak zorunda değildir. Bu bir deneme önerisidir, yeni mekanik veya asset zorunluluğu değildir.

## Yeni paket kontrolü — mevcut dosyalardan

23 JPEG, 22 farklı içerik var; `loading_bg.jpg` ile `loading_bg2.jpg` aynı byte/hash. 18 saydam olması beklenen kaynak RGB; hiçbirinde alfa yok. Yeni kaynaklar bu araştırma sırasında değiştirilmedi ve önceki üç PNG adayının üzerine yazılmadı.

| Yeni dosya / aile | Görsel bulgu ve karar |
|---|---|
| `main_menu_bg.jpg` | Sol tarafta sert koyu blok hâlâ var; ortam ışığına yedirilmiş menü boşluğu için yeniden üretim önerilir. |
| `interrogation_bg.jpg` | Ortada büyük açık krem alan var; gece ortamının sakin karanlık boşluğu istenmeli. |
| `map_bg.jpg` | Dekoratif harita adayı; gerçek düğümler/veri hizası henüz doğrulanmadı. |
| `loading_bg.jpg`, `loading_bg2.jpg` | Aynı resim; yeni yükleme arka planı adayı. Camlı fener yerine açık fitilli seramik kandil istemek dönem yönünü daha net tutar. |
| `dialogue_panel`, `settings_panel`, `tooltip_panel`, `villager_card`, `portrait_frame` | Nesneler tanınır; alfa ve kenar payı hazırlanmalı. Büyük köşe süslerinin 9-slice bandında kalması ayrıca kontrol edilmeli. Portre deliğindeki damalar saydam değildir. |
| Dört `button_*` | Aynı tuval ölçüsü yeterli değil: dört farklı çerçeve/ahşap biçimi çıkmış. Yeni normal temelinden durumlar türetilecek. |
| `focus_ring.jpg` | Bu kez odak çizgisi tanınır; ortadaki ve dıştaki damalar gerçek alfa yapılmadan kullanılamaz. |
| `hud_strip.jpg` | Şerit tanınır, ancak geniş kaynak tuvalinin içinde ince nesne var. Nihai kadraj ve alfa gerekiyor. |
| `Refer to this file by its name verbatim-1.jpg` | Yatay oyuk kanal. Sürgü/yükleme kanalı ayrımı belirsiz; kesin slot adı verilmez. |
| `Refer to this file by its name verbatim-2.jpg` | Dikey kaydırma kanalı adayı; kaynak tuvali geniş, nesne dikey. |
| `Refer to this file by its name verbatim-3.jpg`, `-4.jpg` | Vurgulu/vurgusuz geniş panel varyantları. Sekme olarak kesin eşleme yapılmaz. |
| `Refer to this file by its name verbatim-5.jpg` | Sürgü tutamacı adayı. |
| `Refer to this file by its name verbatim-6.jpg` | Kaydırma tutamacı adayı. |
| `Refer to this file by its name verbatim-7.jpg` | İşaretli onay kutusu adayı. |

Yeni paket için gözle okunur yazı veya renk örnekleri görülmedi; OCR garantisi verilmez. Yeni `checkbox_off` ve `loading_fill` teslimi bulunamadı. Bazı kanal/sekme eşlemeleri belirsiz; bunları tamamlandı saymıyoruz. Kullanıcının belirttiği **`watermarked_img_2943715367622830842.jpg`** proje ve taranan Ahmet Downloads/Pictures/Desktop dosyalarında bulunamadı. Kaynaklar daha sonra hazırlanacak; burada alfa düzeltildi veya import tamamlandı denmiyor.

## Yeni promptların kapsamı

[GEMINI_TEKLI_URETIM_PROMPTLARI.md](GEMINI_TEKLI_URETIM_PROMPTLARI.md) eski gece kapısı UI kataloğundaki 57 slotu kapsar: 51 ayrı resim promptu, altı slot için aynı temel dokudan türetme tarifi; ayrıca isteğe bağlı göz kırpma denemesi. Dosya/nihai ölçü/alfa/9-slice bilgisi her slotta bulunur. Sıra numarası dosyaya yazdırılmayacak; prompt dışında Ahmet'in takip bilgisi olarak kalır. İstenen ilk tekrar **yalnız loading_fill** olabilir; aynı mesajda sonraki parçalara geçilmez.

Bu belge envanterin tüm oyun assetlerini kapatmaz. `UI_ASSET_PROMPTLARI_2.md` için daha önce istenen bütün 2D envanter çalışması henüz teslim edilmedi; 3D açık sayısı bu araştırmada yeniden sayılmadı. 3D üretimi yok. Tam oyun sanity yerine belge/katalog tutarlılığı kontrol edilir. Zorunlu ds ayna yolu bu bilgisayarda yok; eşitlendi denmez.
