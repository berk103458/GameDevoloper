# Arayüz araştırma raporu

15 Kasım 2026. Cursor. Yalnız araştırma. Bu turda kod, sahne, tema, font, doku ve ROADMAP_2 satırı değişmedi. Çini, Parşömen ve Ocak şablonlarının seçim satırı boş bırakıldı.

Amaç: Ahmet'in reddettiği düz, site benzeri kabuğun yerine, kapı muhafızı oyununa uygun atmosferik bir arayüz yönü önermek. Oyun 1243 Kösedağ sonrası Selçuklu uç bölgesinde geçiyor. Oyuncu kapıdaki kişiyle konuşup karar veriyor. Dünya büyük ölçüde 3B sahnede duruyor; arayüz bu sahnenin üstüne binen katman.

Bu metindeki oyun tarifleri, geliştirici yazıları, röportajlar ve ekran kataloglarından çıkarılmıştır. Oyunlar bu oturumda açılıp oynanmadı. Bir teknik için geliştirici kaynağı yoksa bu ayrıca yazıldı. Fiyatlar 15 Kasım 2026'da açık sayfalardan okundu; mağaza fiyatı değişebilir.

## Bizde arayüz bugün neye benziyor?

Canlı tema `src/arayuz/tema.gd` içindedir. Düğme ve panel `StyleBoxFlat` ile kurulur: düz gece rengi, düz kenar, köşe yarıçapı 0, gölge 0. Menü düğmesi kutusuz kül yazıdır; odak kalın kenardır. Gövde yazısı Alegreya, köy başlığı Cinzel'dir. İkisi de depoda SIL Open Font License 1.1 dosyasıyla durur.

Ortak ölçü `src/arayuz/kabuk.gd` içindedir. `Kabuk.panel()` yine düz renkli bir `StyleBoxFlat` döndürür. Punto gövde 26, küçük 22, başlık 34'tür.

Kapı konuşması `src/arayuz/chr_diyalog_paneli.gd` içinde bir `VBoxContainer`'dır. Replik ve seçenekler `Label` olarak eklenir. Ayrı bir görsel roman eklentisi yoktur. Heybe kartı `create_tween()` ile açılır. Kapı görüşünde `src/arayuz/kapi/kapi_gorusu.gdshader` hafif bir bulanıklık verir. Defter aday sayfası `src/arayuz/defter_gorunumu.gd` içinde `StyleBoxTexture` giyer; bu, dokulu kutunun oyunda tek yerleşik örneğidir.

`docs/arayuz/SABLONLAR.md` üç adayı tanımlar: Çini, Parşömen, Ocak. Üçü de düz `StyleBoxFlat` ve renk tablosudur. Doku üretilmemiştir. Seçim satırı boştur. Reddin malzemesi buradadır: palet değişince ekran hâlâ düz bir form sayfası gibi durur.

`docs/UI_ADAYLARI.md` beş açık lisanslı paketi ayrı ekranlara bağlamış, seçim bırakmıştır. Lamoot ahşap, itsmars envanter, Kenney RPG, Crisp Quest ve Kenney macera. Belge kendi sınırını yazar: Kenney çizgisi çizgi film kabuğuna kayar; bazı paketler parşömen veya düz site yönünü tekrarlar.

`assets/ui/atmosfer/gece_kapisi/` altında diyalog paneli, düğme, portre çerçevesi, ayar paneli, harita zemini ve süs parçaları vardır. `src/` altındaki GDScript bu dosyaları yüklemez. Envanter satırları entegrasyonu üretim sonuna bırakır. Kalfa'nın `docs/arayuz/NANO_BANANA_OYUN_ASSET_ARASTIRMASI.md` notu, erken çıktılarda gerçek alfa olmadığını ve 9-slice bandına taşan köşe süslerini ayrıca kontrol etmek gerektiğini söyler. O belge 12 Ekim 2026 tarihlidir; sonraki temizleme turları envanterde "alfa/ölçü hazır" diye geçer. Bu rapor o dosyaları yeniden ölçmedi.

Köy kaynak ikonlarının bir kısmı `assets/ui/koy/*.svg` olarak durur. Onlar düz piktogramdır, çerçeve değildir.

## 1. Bu tür oyunlar arayüzü nasıl kuruyor?

Ortak ders: atmosfer, bütün ekranı kaplayan süslü bir pencere demek değildir. Konuşmanın kendisi sahnenin içinde kalır. Pencere, kâğıt veya levha yalnız oyuncunun elindeki nesnenin olduğu yerde çıkar. Yazı, çerçevenin önüne geçer. Seçenek az ve büyüktür.

Aşağıdaki teknik sütunu, kaynaktan çıkan yöntemdir. "9-slice kullandılar" denmeyen yerde bu iddia yoktur. Çoğu stüdyo dilim payını yayınlamaz.

### Papers, Please (Lucas Pope, 2013)

Kapı oyununun en yakın akrabası budur. Arayüz bir gişe masasıdır. Evrak sürüklenir, mühür basılır, kural defteri ve saat masanın üstündeki nesnelerdir. Pope, evrakı iki sabit sütuna tıklatınca hem cansız hem de 150 piksel genişlikle sınırlı bulduğunu, bunun yerine tezgâhın tamamında sürükle-bırak kullandığını yazar. Düşük çözünürlük ve kısık renk, kaynak kıtlığından gelmiş, sonra kasvetli havayı ve dağınıklığı azaltmayı da sağlamıştır. Aile durumu ekranı bilerek birkaç nokta ve yazıdır; Pope, aileyi tanımsız bırakıp oyuncunun kendi ailesini yerleştirmesini ister.

| Teknik | Kaynakta görülen |
|---|---|
| 9-slice çerçeve | Yazılmamış |
| Kâğıt / doku | Evrak, masa, mühür, defter nesneleri |
| Tipografi | Ayrı bir yazı tipi makalesi bulunmadı. Okunaklı, kısa etiket |
| Animasyon | Piksel hizalı sürükleme; Pope animasyonu erken bırakıp mekaniğe geçtiğini yazar |
| Shader | Yazılmamış. Üretim Haxe/NME ve Flixel ile anlatılır |
| Diegetic | Evet. Masa, evrak, mühür ve kural defteri dünyanın içindedir |

Kaynak: [Pope devlog derlemesi](https://fguillen.github.io/PapersPleaseDevlogScrap/), [Game Developer, IGF röportajı](https://www.gamedeveloper.com/design/road-to-the-igf-lucas-pope-s-i-papers-please-i-), [Game Developer, kasvet ve sadelik](https://www.gamedeveloper.com/design/designing-the-bleak-genius-of-i-papers-please-i-).

Kapı Muhafızı için alınacak: karar bir düğme ızgarası değil, mühür ve kısa bir satır olsun. Evrak yalnız gerçekten evrak varsa (izin, mühür, mektup) görünsün. Bütün gece konuşmasını pasaport masasına çevirmek bu oyunu Papers, Please kopyası yapar; bizde kişi 3B kapıda duruyor.

### Disco Elysium (ZA/UM, 2019)

Konuşma, boyalı portre ve uzun düzyazıdır. "The Making of Disco Elysium" sanat bölümünde portrelerin yalnız yüz değil, karakterin hikâyedeki yerini anlattığı söylenir. Konuşma kadrajı önceden kurulur; tıklanınca figürler o kompozisyona yürür. Final Cut arayüzünde Taylor Wright üç hazır görüntü kipi yazar: Monitor, TV, Handheld. Her kipin punto ve yerleşimi ayrıdır. Dinamik punto kaydırıcısı desteklenmemiştir.

Yazı tipi için stüdyonun resmi bir adını bu taramada bulamadım. Bir tipografi bülteni gövdeyi Sina Medium diye tahmin eder; bu tahmin olarak kalsın, kaynak gösterilmiş olgu değildir.

| Teknik | Kaynakta görülen |
|---|---|
| 9-slice | Yazılmamış |
| Doku | Boyalı portre ve izometrik resim. Arayüzün kendisi bir parşömen çerçevesi olarak anlatılmaz |
| Tipografi | Serif gövde gözle görülür; resmi aile adı doğrulanmadı |
| Animasyon | Konuşma pozuna yürüme, portre |
| Shader | Sanal doku (Amplify) dünya resmi içindir, diyalog kutusu için anlatılmaz |
| Diegetic | Kısmen. Dünya resimdir. Yetenek ve düşünce dolabı bir arayüz katmanıdır |

Kaynak: [sanat yapım videosu](https://www.youtube.com/watch?v=-eUtrUW2QVU), [Taylor Wright, Final Cut arayüzü](https://redlamp.org/work/disco-elysium/). Tahmin: [Adventures in Typography](https://buttondown.com/adventures/archive/what-text-can-really-be/).

Alınacak: kapıdaki kişinin yüzü küçük bir ikon değil, kadrajın parçası olsun. Seçenekler uzun düzyazının altında, az sayıda ve okunaklı dursun. Düşünce dolabı bizim muhafız tonu ve tansiyon satırına benzer; onu ayrı bir site menüsü yapmaya gerek yok.

### Pentiment (Obsidian, 2022)

Oyun bir el yazmasının içindedir. Sahne değişince kamera sayfanın kendisine uzaklaşır. Günlük; karakter, harita, sözlük ve amaçları tutan, ayrı ayrı riglenmiş 3B bir kitaptır. Josh Sawyer, kendi defterinden hareketle sekmeleri modellediklerini ve Cathy Nichols'un animasyonu yetişsin diye rig'in üç kez yenilendiğini anlatır. SHARP röportajında parşömen ile kâğıdın doku farkı ve sayfa arkasının hafifçe görünmesi hedeflenir; yüzey altı saçılma o turda yapılmamış, uzak bir hedef olarak kalmıştır. Hannah Kennedy sanat yönünü geç ortaçağ baskı ve el yazması dili olarak anlatır.

PCGamesN'in UX yazısı konuşma balonunu şöyle tarif eder: yazı önce kontur olarak belirir, sonra fırça darbesiyle dolar; ara sıra yanlış sözcük çizilip düzeltilir. Bu bir oyuncu yazısıdır, stüdyo teknik belgesi değildir. Yine de kadrajın nasıl çalıştığını görmek için yeterince somuttur.

| Teknik | Kaynakta görülen |
|---|---|
| 9-slice | Yazılmamış. Sayfa ve kitap 3B nesnedir |
| Kâğıt / doku | Parşömen ve kâğıt ayrı dokular. Kitap sayfaları riglenir |
| Tipografi | Dönemin yazı dilinden gelir. Resmi font adı bu taramada yok |
| Animasyon | Sayfa çevirme, sekme, yazının dolması |
| Shader | İstenen yarı saydam parşömen ışığı yapılmamış |
| Diegetic | Evet. Menü, harita ve sözlük kitabın içindedir |

Kaynak: [SHARP News, Sawyer](https://sharpweb.org/sharpnews/2022/12/07/pentiment-an-interview-with-josh-sawyer/), [Game Developer, Hannah Kennedy](https://www.gamedeveloper.com/art/deep-dive-the-art-of-pentiment), [GameBanshee, günlük rig'i](https://www.gamebanshee.com/news/127111-pentiment-josh-sawyer-interview-2.html), [PCGamesN UX notu](https://www.pcgamesn.com/pentiment/obsidian-rpg-game-ux).

Alınacak: hafıza defteri ve divan tutanağı gerçek bir defter gibi açılsın. Kapı konuşmasının tamamını 16. yüzyıl Avrupa el yazmasına çevirmek hem dönemi hem de reddedilen Parşömen şablonunu geri getirir. Pentiment'te kâğıt, çünkü hikâye bir yazıcıdadır. Bizde kâğıt, gece notu ve mühürlü karar için vardır.

### Crusader Kings III (Paradox, 2020)

CK3'ün sanat günlüğü arayüzü şöyle tanımlar: rol yapma oyunlarından etkilenmiş, temiz, nefes alan bir yerleşim. Portre öndedir ve giysi ile beden dili makamı gösterir. Çizimler bağlama göre değişir. Arma sistemi Avrupa heraldiklerinin yanında doğu tamgaları ve İslami (metindeki sözcükle Saracenic) armalar için de ayrıca çalışılmıştır. Günlük, arayüzün tamamını parşömen diye anlatmaz.

The Verge, harita bilgisinin yakınlaştırmayla değiştiğini ve iç içe ipuçlarının terimleri oyunun içinde öğrettiğini yazar. StyleDex gibi kataloglar uzak haritayı eskitilmiş parşömen, pencereyi koyu levha ve altın kenar diye tarif eder. Bu tarif stüdyo belgesi değildir; ekran okumasıdır. CK2'nin parşömen pencerelerinden CK3'e geçiş, oyuncu forumlarında da konuşulur: okunurluk artmış, eski kâğıt hissi azalmıştır.

| Teknik | Kaynakta görülen |
|---|---|
| 9-slice | Yazılmamış |
| Kâğıt / doku | Uzak harita resimde parşömen gibi. Pencereler temiz ve arma / portre ağırlıklı |
| Tipografi | Günlükte font ailesi yok |
| Animasyon | Portre beden dili |
| Shader | Yazılmamış |
| Diegetic | Hayır. Bu bir yönetim masasıdır. Dünya haritadadır, pencere dünyanın içindeki bir nesne değildir |

Kaynak: [CK3 Dev Diary 28](https://forum.paradoxplaza.com/forum/threads/ckiii-dev-diary-28-art-focus.1393627/page-18), [The Verge, harita ve ipucu](https://www.theverge.com/games/23653870/crusader-kings-3-design-ui). Ekran tarifi, stüdyo dışı: [StyleDex](https://www.styledex.games/game/crusader-kings-iii).

Alınacak: köy, divan ve harita çok bilgi taşır. CK3'ün dersi süs yığmak değil, bir bakışta kim olduğunu göstermek ve terimi yerinde açmaktır. Altın Avrupa çerçevesini olduğu gibi almak Selçuklu kapısına uymaz. Günlükteki bağlamlı çizim fikri uyar: aynı pencere kalıbı, içindeki resim kapı gecesi, köy öğleden sonrası veya kış için değişir.

### Pathfinder: Kingmaker (Owlcat, 2018)

Owlcat'in kendi yazısı karakter ekranını kâğıt karakter kâğıdından türetir. Ekran üçe bölünür. Solda çizilmiş portre vardır; 3B model yerine çizim seçilmiştir, gerekçe Baldur's Gate çizgisi ve duygunun çizimde daha rahat okunmasıdır. Yetenekler ayrı sayfaya alınır. Companion'lar için hikâye kartları denenir. Yazı, Wrath of the Righteous'ı ayrıca anlatmaz. İki oyunun arayüzünün aynı olduğu bu raporda iddia edilmez.

| Teknik | Kaynakta görülen |
|---|---|
| 9-slice | Yazılmamış |
| Kâğıt / doku | Kâğıt karakter kâğıdının dijital karşılığı. Doku tarifinden çok yerleşim tarifi |
| Tipografi | Yazılmamış |
| Animasyon | Yazılmamış |
| Shader | Yazılmamış |
| Diegetic | Hayır. Masaüstü karakter kâğıdıdır |

Kaynak: [Owlcat, karakter arayüzü](https://owlcat.games/news/60).

Alınacak: muhafız odası ve heybe bir karakter kâğıdı gibi üç kuşak olabilir. Portre çizim kalsın, 3B modelin küçük bir kopyası olmak zorunda değildir. Yetenek ve vicdan aynı anda her şeyi göstermesin; sayfa ayrılsın.

### Darkest Dungeon (Red Hook, 2016)

Chris Bourassa, GameSpot'a oyunun mum ışığında yıpranmış bir el yazması gibi görünmesini istediklerini söyler. Açılış yüksek kontrastlıdır. Anlatıcı Wayne June'dur ve metin onun sesi için yazılmıştır. Comics Studies yazısı stres balonlarının düz konuşma kutusundan daha sivri çizildiğini anlatır; bu bir akademik gözlemdir, stüdyo teknik notu değildir. Urban Rockets, arayüzde yerleşim kalıpları kurduklarını söyler, doku yöntemini açmaz.

| Teknik | Kaynakta görülen |
|---|---|
| 9-slice | Yazılmamış |
| Kâğıt / doku | Mum ışığı, yıpranmış sayfa, kalem işi. Ayrı bir "paper shader" belgesi yok |
| Tipografi | Gotik anlatım. Font adı yok |
| Animasyon | Çizgi roman karesi gibi hareket |
| Shader | Yayınlanmış bir UI shader notu bulunmadı |
| Diegetic | Kısmen. Kasaba ve zindan resimdir. Paneller dünyanın içindeki nesneler değildir; üslupları dünyayla aynı mürekkeptedir |

Kaynak: [GameSpot, Bourassa](https://www.gamespot.com/articles/the-gothic-sensibilities-of-darkest-dungeon/1100-6424880/), [Urban Rockets](https://urbanrockets.com/portfolio/darkest-dungeon/).

Alınacak: gece kapısında ışık kadrajın kenarında kalsın, yazının üstüne vurmasın. Gotik malikâne, haç ve Avrupa şövalye süsü bu oyunun dönemi değildir. Alınacak olan karanlık, yıpranma ve yazının sahnenin önünde durmasıdır.

### Kingdom Come: Deliverance (Warhorse, 2018)

Warhorse'un kendi arayüz günlüğünü bu taramada bulamadım. Aşağısı PlayCraft Gallery'nin fragman karelerindeki gözlemidir, stüdyo tarifi değildir.

Simya tezgâhında menü yoktur. Tarif bir rahlede açık kitaptır. Körük, kum saati ve havan sağdaki fiil listesiyle kullanılır. Ganimet ekranı envanterle aynı parşömen listeyi kullanır; sekmeler "Found / Inventory" olur, oda panelin kenarında görünür kalır. Görev günlüğü aynı arma şeridinin bir sekmesidir ve sağda mürekkep harita durur.

| Teknik | Bu katalogda görülen |
|---|---|
| 9-slice | Yazılmamış |
| Kâğıt / doku | Envanter ve görev günlüğü parşömen panel. Simya kitabı sahnedeki nesnedir |
| Tipografi | Katalog font adı vermez |
| Animasyon | Katalog UI animasyonu anlatmaz |
| Shader | Yazılmamış |
| Diegetic | Simya ve kilit tam diegetic. Envanter yarı: panel dünyayı tamamen kapatmaz |

Kaynak: [PlayCraft, simya](https://playcraft.space/gallery/kingdom-come-deliverance/alchemy-bench-antidote-recipe/), [ganimet](https://playcraft.space/gallery/kingdom-come-deliverance/looting-chest-found-versus/), [görev günlüğü](https://playcraft.space/gallery/kingdom-come-deliverance/quest-log-hunt-begins/).

Alınacak: heybe ve harita açılınca 3B oda veya köy kenarda görünsün. Tam ekran düz panel sahneyi siler. Bohemya parşömeni ve arma şeridi bizim malzeme değildir.

### The Banner Saga (Stoic, 2014)

Stoic, konuşmayı olay metninden ayırır: önemli bir karar varsa seçenek çıkar, her satır sahte bir seçenek değildir. Pocket Gamer yapım yazısında Arnie Jorgensen üslubu Eyvind Earle'ün *Sleeping Beauty* resmine bağlar. İlk deneme katmanlara ayrılıp parallax edilir. Savaş arayüzü bir festivalde anlaşılmayınca baştan kurulur.

Game Developer'daki UX yazısı üçüncü taraf analizidir. Konuşmayı şöyle okur: ekranın çoğu çizimdir, altta ince bir şerit, solda portre, ad ve metin vardır. Portreler hafif oynar, fon bulanıktır, bazen hava katmanı biner. Yazar, metnin çizimin üstüne taşabildiğini de not eder.

| Teknik | Kaynakta görülen |
|---|---|
| 9-slice | Yazılmamış |
| Kâğıt / doku | El çizimi manzara ve düz boyalı figür. Konuşma kutusu büyük bir panel değildir |
| Tipografi | Yazılmamış |
| Animasyon | Parallax, hafif portre, hava |
| Shader | Yazılmamış. Parallax katman olarak anlatılır |
| Diegetic | Hayır. Sinema kadrajıdır. Arayüz kadrajın alt kenarıdır |

Kaynak: [Stoic, konuşma tasarımı (arşiv)](https://web.archive.org/web/20200821112845/https://stoicstudio.com/single-player-progress/), [Pocket Gamer, yapım](https://www.pocketgamer.biz/the-making-of-the-banner-saga/), [Game Developer, UX analizi](https://www.gamedeveloper.com/design/learning-from-and-improving-banner-saga-trilogy-a-ux-ui-analysis).

Alınacak: kapı konuşmasında 3B kişi kadrajın sahibi kalsın. Yazı altta, tek şeritte dursun. Viking düz boyamasını ve Disney manzarasını almak bu oyunun işi değildir.

### 80 Days ve Heaven's Vault (inkle)

Jon Ingold, 80 Days için her karenin bir dergi sayfası gibi kurulmasını ister. Yazı okunmadan önce bir resim gibi görülür. Kötü punto okumayı keser, kötü geçiş oyuncunun yerini kaybettirir. Arayüz parçaları oyun içinde, işe yaradığı anda teker teker girer. Game Developer yazısında tempo konuşma ritmidedir: duvar gibi metin değil, kısa alışveriş.

Joseph Humfrey'nin 2018 GDC oturumu 80 Days ve Heaven's Vault için punto, animasyonun gözü taşıması ve dikkat dağıtan şeyi kaldırmayı anlatır. Oturumun tam metni bu taramada açılmadı; başlık ve özet doğrulandı: [Game Developer](https://www.gamedeveloper.com/design/video-designing-text-ux-for-effortless-reading).

Heaven's Vault'ta çeviri, arayüzün kendisidir. Yazıt sözcüklere bölünür, oyuncu anlam adaylarını seçer, sözlük birikir. Anlatı ink ile yazılır. ink, inkle'ın kendi dal dili ve motorudur.

| Teknik | Kaynakta görülen |
|---|---|
| 9-slice | Yazılmamış |
| Kâğıt / doku | 80 Days'te sayfa düzeni. Heaven's Vault'ta yazıt |
| Tipografi | Tasarımın ana malzemesi. Aile adı bu taramada yok |
| Animasyon | Gözü satırlar arasında taşımak için. Ayrıntı GDC özetinde |
| Shader | Yazılmamış |
| Diegetic | Heaven's Vault'ta yazıt dünyadadır. 80 Days daha çok temiz bir metin sayfasıdır |

Kaynak: [Vice, Ingold](https://www.vice.com/en/article/the-makers-of-mobile-hit-80-days-on-the-importance-of-amazing-ui-852/), [Game Developer, tempo](https://www.gamedeveloper.com/business/-i-80-days-i-building-the-perfect-text-adventure-for-mobile), [Game Developer, Heaven's Vault dili](https://www.gamedeveloper.com/design/how-inkle-developed-its-own-ancient-language-for-i-heaven-s-vault-i-).

Alınacak: seçenek sayısı az kalsın, her biri kısa bir cümle olsun, yeni düğme türü ancak o gece lazımsa görünsün. ink'e geçmek mevcut CHR sorgu ağacını ikinci bir diyalog sistemi yapar. Önerilmez.

### Citizen Sleeper (Jump Over the Age, 2022)

Gareth Damian Martin arayüzü kendisinin kurduğunu yazar. Gün başında zarlar atılır ve ekranın üstünde durur. Oyuncu zarı bir işe sürükler. Kullanılan zarın yuvası boş kalır. Guillaume Singelin karakter resmini yapar. Martin üslubu "ayrıntıyı oyuncunun tamamladığı" bir çizgi diye tarif eder; Ghost in the Shell ve Cowboy Bebop'u bu iş için andığı cümle dünya ve moda içindir, pencere çerçevesi için değildir.

Curio'nun turuncu, teal ve mürekkep tarifesi üçüncü taraf bir stil rehberidir. Geliştiricinin spesifikasyon metni diye kullanılmadı.

| Teknik | Kaynakta görülen |
|---|---|
| 9-slice | Yazılmamış |
| Kâğıt / doku | Çizgi roman figürü, koyu zemin. Zar yüzü arayüz nesnesidir |
| Tipografi | Yazılmamış |
| Animasyon | Zarın işe sürüklenmesi |
| Shader | Yazılmamış |
| Diegetic | Hayır. Zar ve saat mekaniğin resmi haline gelmiştir |

Kaynak: [Game Developer, Martin](https://www.gamedeveloper.com/business/how-citizen-sleeper-was-inspired-by-tabletop-rpgs-and-gig-work), [ekran tarifi](https://howtomakeanrpg.com/r/a/case-study-citizen-sleeper.html).

Alınacak: kapıdaki zar sonucu küçük bir site formu değil, elde tutulan bir zar gibi dursun. Mekanik zaten `ChrDiyalogPaneli` içinde yazılıyor. Görünüşü değiştirmek sorgu ağacını değiştirmez.

### Bu on oyundan çıkan kısa liste

1. Konuşma ekranında dünya görünür kalır. Yazı bir kenardadır.
2. Pencere, ancak oyuncunun elindeki nesne pencereyse büyür: defter, mühür, mektup, harita.
3. Aynı çerçeve ailesi bütün ekranlarda tekrar eder. Her menü yeni bir site şablonu açmaz.
4. Yazı punto ve satır aralığı süsten önce gelir. Türkçe ekler satırı uzatır.
5. Hazır Avrupa parşömeni veya gotik paket, malzeme olarak bu oyuna uymaz. Uyan şey kadraj disiplinidir.

## 2. Godot 4'te bu nasıl kurulur?

Proje Godot 4.7.2 kullanır. Aşağıdaki sınıf tarifleri 15 Kasım 2026'da `https://docs.godotengine.org/en/stable/` altından okundu. O gün "stable" hangi yamayı gösteriyorsa tarif odur. Bu oturumda editör açılmadı, sahneler çalıştırılmadı. 4.7'ye özgü bilinen arayüz farkı depodaki sürüm notundadır: `RichTextLabel` görsel ölçüsü artık float ve birim cinsindendir (`docs/engine-reference/godot/breaking-changes.md`).

### Tema ve dokuz dilim

Düz renk `StyleBoxFlat` ile biter. Dokulu çerçeve `StyleBoxTexture` ile temaya girer. Bu sınıf, `NinePatchRect` ile aynı 3×3 mantığındadır: köşeler olduğu gibi kalır, kenar ve orta ölçeklenir veya karo olur. Kenar payı `texture_margin_*` ile verilir. `axis_stretch_horizontal` ve `axis_stretch_vertical` üç kip sunar: ger (`STRETCH`), karo (`TILE`), karoyu tam sığdır (`TILE_FIT`). Ahşap damar ve bez için `TILE` veya `TILE_FIT` gerekir. Gerilen orta, damarı macun gibi uzatır. `region_rect` büyük bir sayfadan tek parça kesmek içindir. `modulate_color` aynı dokuyu gece ve seçili durum için hafifçe kaydırmak içindir.

`NinePatchRect` tema dışındaki tek süs içindir: portre deliği, köşe parçası, yükleme çubuğu. Dokümanda varsayılan `mouse_filter` değeri `MOUSE_FILTER_IGNORE` (2) diye yazar. Yani süs, tıklamayı yutmadan durabilir. Bunu sahnede ayrıca doğrulamak gerekir; bu turda doğrulanmadı.

Köşe süsleri dilim bandının içinde çizilirse, panel uzayınca süs de uzar. Kalfa'nın notu doğrudur: rumi köşe, dilim payının dışında ayrı bir `TextureRect` olsun. Çerçeve düz ve tekrarlanabilir kalsın.

Mevcut `Tema.olustur()` düğme ve panel stillerini kodla kurar. Yeni doku, bu fonksiyonun `_kutu()` yerine `StyleBoxTexture` koymasıyla bütün düğmelere gider. Her panel betiğini yeniden yazmak gerekmez. Menü düğmesi `MenuDugmesi` tip varyasyonudur; o varyasyon kutusuz kalabilir. Kapı seçeneği ayrı bir tip varyasyonu olsun, ana menü yazısını da tahta düğmeye çevirmesin.

Resmi tema rehberi: [GUI skinning](https://docs.godotengine.org/en/stable/tutorials/ui/gui_skinning.html), [StyleBoxTexture](https://docs.godotengine.org/en/stable/classes/class_styleboxtexture.html), [NinePatchRect](https://docs.godotengine.org/en/stable/classes/class_ninepatchrect.html).

### Yazı

`RichTextLabel` BBCode efektleri dokümanda şunlardır: pulse, wave, tornado, shake, fade, rainbow. Özel efekt `RichTextEffect` ile yazılır ve `install_effect()` ile bağlanır. Doküman uyarıyı açık yazar: etikette en az bir özel efekt varsa etiket, oyun duraklatılmadıkça efekti işlemeye devam eder. Kapı metninin tamamına dalga vermek hem okumayı bozar hem bu maliyeti açar. Uygun yer, yeni satırın ilk belirmesi veya mühür basıldığı anki kısa bir vurgu olabilir. Sonra efekt kalkar.

Türkçe için gövde Alegreya kalsın. Bu turda yerel `Alegreya-wght.ttf` ve italik dosyasının cmap'i tarandı. `ç ğ ı İ ö ş ü` glifleri vardır (0x20–0x250 aralığında 405 kod noktası). `Cinzel-wght.ttf` aynı harfleri taşır (aynı aralıkta 299 kod noktası). Cinzel teşhir fontudur; uzun konuşma satırında gövde olarak kullanılmaz. İkisi de variable fonttur ve `Tema.font()` ağırlığı `wght` ekseninden okur. Yeni font eklemeden önce aynı cmap kontrolü gerekir. Font rehberi: [BBCode](https://docs.godotengine.org/en/stable/tutorials/ui/bbcode_in_richtextlabel.html), [RichTextEffect](https://docs.godotengine.org/en/stable/classes/class_richtexteffect.html).

### Tween

`create_tween()` projede heybe ve yeni düğme işaretinde zaten vardır. Kapı için yeterli hareket kısadır: şerit alttan 8–12 piksel kayar, mühür bir kez ölçeklenir, seçenekler sıra ile belirir. Sürekli yüzen panel site hissini büyütür. Tween sınıfı: [Tween](https://docs.godotengine.org/en/stable/classes/class_tween.html).

### Shader

Kapıda zaten bir tuval gölgelendiricisi vardır: komşu pikselleri karıştıran hafif bulanıklık. Vinyet aynı yere, yazı katmanının altına, bir `ColorRect` üstüne yazılabilir. Resmi doküman ilk tuval gölgelendiricisini anlatır: [Your first canvas item shader](https://docs.godotengine.org/en/stable/tutorials/shaders/your_first_canvasitem_shader.html). "Hazır kâğıt gölgelendiricisi" diye resmi bir Godot dersi bu taramada bulunmadı. Kâğıt damarı, tekrarlanan bir dokunun `StyleBoxTexture` karosu olarak verilmesi daha dürüst bir yoldur. Gölgelendirici ile mürekkep akıtmak, okunaklı Türkçe metni bozma riski taşır. Mürekkep, olsa olsa mühür anındaki kısa bir leke olsun.

### Diyalog eklentileri

İkisi de MIT ve ticari kullanıma açıktır. İkisi de bu projede kurulmadı, 4.7.2 ile denenmedi.

| Eklenti | Lisans | Sürüm notu | Bağ |
|---|---|---|---|
| Dialogic 2 | MIT. Sıkça sorulanlarda ticari oyun serbest, atıf rica edilir | En az Godot 4.3. 4.7.2 uyumu bu turda denenmedi | [depo](https://github.com/dialogic-godot/dialogic/), [lisans](https://github.com/dialogic-godot/dialogic/blob/main/LICENSE), [SSS](https://docs.dialogic.pro/faq.html) |
| Dialogue Manager 4 | MIT, Nathan Hoad | README bu dalı Godot 4.6+ diye yazar. 4.4/4.5 için eski sürümler listelenir. 4.7.2 denenmedi | [depo](https://github.com/nathanhoad/godot_dialogue_manager/), [lisans](https://github.com/nathanhoad/godot_dialogue_manager/blob/main/LICENSE) |

inkle'ın ink dili de MIT'dir: [github.com/inkle/ink](https://github.com/inkle/ink). Godot 4.7 için bir kapı bu turda kurulup doğrulanmadı. Bir kapı bulunsa da mevcut `chr_diyalog_paneli.gd` ve kilitli JSON sorgu ağacı ikinci bir sistem olur.

Öneri: eklenti alınmasın. Konuşma verisi ve karar sinyalleri (`karar_istendi`, `kacis_istendi`) durur. Değişen şey temanın kutusu, portre çerçevesi ve satırın belirişidir.

## 3. Hazır arayüz var mı?

Proje kuralı: hazır görsel yalnız CC0, kamu malı veya CC-BY ise, kaynak, yazar ve lisans `docs/EKSIK_ASSET_ENVANTERI.md` satırına yazılarak eklenebilir. Ticari kullanımı kapalı, "yalnız kişisel" veya lisansı okunamayan paket alınmaz. Ücretli paketler aşağıda ayrıdır. Onlar bu kurala uymaz; insan ayrıca izin vermeden depoya girmez.

13. yüzyıl Anadolu veya Selçuklu kapısına ait, CC0 ya da CC-BY bir hazır UI kiti bu taramada bulunmadı. Bulunan "medieval" paketler Avrupa fantezisi, piksel şövalye veya düz çizgi filmdir. Hiçbiri tek başına oyunun kabuğu olmasın.

### Açık lisans, depoya girebilir (uyum sınırlı)

| Paket | Lisans | Uyum | Bağ |
|---|---|---|---|
| Kenney UI Pack, RPG Expansion, Adventure, Fantasy UI Borders | CC0. Kenney.nl bu oturumda 403 verdi. Lisans OpenGameArt aynasında CC0 yazıyor. Repodaki `docs/UI_ADAYLARI.md` aynı hükmü, indirilen dosyayla birlikte kaydetmiş | Temiz ve renkli. RPG ve Adventure zaten aday. Anadolu kapısına uzak. Fantasy Borders geometrik tel | [OGA UI Pack](https://opengameart.org/content/ui-pack), [RPG Expansion OGA](https://opengameart.org/content/ui-pack-rpg-extension), [Kenney RPG sayfası](https://kenney.nl/assets/ui-pack-rpg-expansion) |
| Lamoot, RPG GUI construction kit v1.0 | CC-BY 3.0. Atıf: Matjaž Lamut / Lamoot. Sayfa "this texture and this public domain wood photo" der; o iki kaynağın lisansı zip açılmadan yeniden doğrulanmadı | Yıpranmış tahta. Avrupa RPG. Repoda menü adayı olarak duruyor | [OpenGameArt](https://opengameart.org/content/rpg-gui-construction-kit-v10) |
| itsmars, RPG Inventory | CC0. Repodaki kayıt böyle. Bu turda sayfa yeniden açılmadı | Karanlık taş ızgara. Diablo türü. Heybe adayı olarak duruyor | `docs/UI_ADAYLARI.md` |
| Anipixels, Crisp Quest Free | PNG ve tema CC-BY 4.0. Betikler MIT; repoya betik alınmamış | Oyma ahşap ve pirinç. Yazar, şekillerin kodla çizildiğini yazar. Bilgi ekranı adayı | [Asset Library 5551](https://godotengine.org/asset-library/asset/5551), [itch](https://anipixels.itch.io/crisp-quest) |
| azagaya, Kenney's UI Theme for Godot 4.x | Sayfa CC0 1.0 yazar. Grafik Kenney'nindir | Düz, renkli, gündelik. `docs/UI_ADAYLARI.md` bunu zaten elemiş | [itch](https://azagaya.itch.io/kenneys-ui-theme) |
| Top Bit Studios, Medieval Pixel UI | Sayfa CC0 1.0 yazar. "No generative AI" notu var | Küçük piksel seti: ok, bayrak, tahta kutu. Avrupa pankart. 13. yy kapısına uymaz | [itch](https://top-bit-studios.itch.io/free-medieval-pixel-ui) |
| game-icons.net | CC BY 3.0. Yazarlar Lorc, Delapouite ve katkı verenler. Sayfa 23 Nisan 2026 güncellemesi ve 4180 ikon der | Düz siyah-beyaz piktogram. Geçici ikon iskeleti olabilir, çerçeve olamaz. Atıf zorunlu | [game-icons.net](https://game-icons.net/) |
| 7Soul1, 496 RPG ikon | OpenGameArt sayfası CC0. Yorumlarda DeviantArt kamu malı notu ve eski karışık lisans tartışması var. Almadan zip ve güncel yazar sayfası yeniden okunmalı | Piksel fantezi: iksir, altın. Selçuklu eşyası değil | [OpenGameArt](https://opengameart.org/content/496-pixel-art-icons-for-medievalfantasy-rpg) |
| Wenrexa, Medieval Icons | OpenGameArt CC0 | İngiliz anahtarı, iksir, yüzük. Dönem kaçar | [OpenGameArt](https://opengameart.org/content/medieval-icons-inventory-284) |
| Archeia, Arabian Icons | CC-BY 3.0. Atıf Archeia | 24×24 piksel, "çöl / orta doğu", dişli çark da var. Anadolu 1243 değil | [OpenGameArt](https://opengameart.org/content/arabian-icons) |
| Beast, 73 patterns | CC0 | Simetrik siyah-beyaz desen. İslami yıldız diye belgelenmemiş. Süs adayı sayılmadı | [OpenGameArt](https://opengameart.org/content/73-patterns) |

Godot Asset Library'de bu oyuna hazır bir Selçuklu teması bulunmadı. Bulunan işe yarar tema kaydı Crisp Quest'tir (5551). Başka tema ekleri varsa bu turda tek tek lisansları açılmadı.

### Ücretli paketler (depoya girmez)

CraftPix lisansı CC0 / CC-BY değildir. 15 Kasım 2026'da [lisans sayfası](https://craftpix.net/file-licenses/) okundu. Ücretli üründe oyun içinde kullanım ve ticari proje serbest, kaynak dosyayı yeniden dağıtmak yasak, telif yok. Aynı sayfa, ücretsiz ürünlerde de kaynak yeniden dağıtımını yasaklar ve yapay zekâ eğitimini ayrıca yasaklar. Proje kuralı bu lisansı açık lisans saymaz. Fiyatlar etiket listesinden okundu. Ürün sayfasının kendisinde, açılan Medieval GUI sayfasında fiyat satırı yoktu.

| Paket | Görülen fiyat | Neden ayrı duruyor | Bağ |
|---|---|---|---|
| Medieval GUI | 9,50 USD (etiket listesi) | Kırmızı, yeşil, mor Avrupa arayüz sayfaları. Lisans kapalı | [ürün](https://craftpix.net/product/medieval-gui/), [etiket](https://dev.craftpix.net/tags/rpg-game-assets-download/) |
| Wooden GUI | 5,50 USD (kategori) | Parlak casual ahşap. Lisans kapalı | [ürün](https://dev.craftpix.net/product/wooden-gui/) |
| RPG Game UI | 10,50 USD | Genel RPG. Lisans kapalı | [kategori](https://craftpix.net/categorys/gui/) |
| Fantasy RPG GUI | 9,50 USD | Fantezi. Lisans kapalı | [etiket listesi](https://dev.craftpix.net/tags/rpg-game-assets-download/) |

Admurin Wood Theme ücretsiz bir zip ve 1,50 CAD eşiğinde ek dosya sunar. Metin "ticari oyunda kullan, asset olarak yeniden satma, NFT ve yapay zekâ eğitimi yasak" der. Bu CC0 / CC-BY değildir. [itch](https://admurin.itch.io/ui-wood-theme). `docs/UI_ADAYLARI.md` içindeki Pixelkiln, Arkana-FTS, Unknown Horizons ve CraftPix ücretsiz bölümü aynı nedenle daha önce elenmiştir. O eleme bu turda bozulmadı.

Hazır paket, olsa olsa heybe ızgarası veya geçici ikon için yama olur. Kapı kadrajı Ahmet'in üreteceği parçalardan kurulmalı. Aksi halde oyun yeniden bir başkasının Avrupa RPG kabuğuna benzer.

## 4. Bu oyun için üç yön

Üçü de reddedilen düz renk şablonunun yerine geçer. Üçü birden bütün ekranlara ayrı üslup olarak yayılırsa oyun üç oyun gibi durur. Önerilen birleşim şudur: kapı konuşması birinci yöndür, defter ve divan ikinci yöndür, köy şeridi ile ayarlar üçüncü yöndür. Üçü aynı malzemeyi paylaşır: isli ahşap, tombak (dövme pirinç) ince şerit, koyu mürekkep, kül yazı. Rumi köşe her yerde aynı parçadır, her ekranda yeniden icat edilmez.

Seçim Ahmet'tedir. Seçim yazılmadan `tema.gd` değişmez.

### Yön A — Gece şeridi

Kapı, Banner Saga'nın kadrajı ve Darkest Dungeon'ın ışık disiplini ile kurulur. Kişi 3B sahnede ayakta kalır. Üstte gökyüzü ve kapı görünür. Alta, ekranın yaklaşık alt üçte birine, isli bir ahşap şerit iner. Şeridin solu portre deliğidir. Sağda replik, onun altında en fazla dört seçenek. Seçenek site düğmesi değildir: aynı ahşabın içine oyulmuş satırdır, odakta tombak kenar yanar. Zar, şeridin köşesinde kısa bir fildişi veya ahşap zar olarak belirir ve söner. Mühür kararı, Papers, Please'teki gibi bir damgadır; bütün ekranı kaplamaz.

Heybe bu yönde sağdan ince bir deri kapak olarak açılır. 3B kapı kapağın yanında görünür kalır.

Bu yön konuşma, muhafız odasındaki yüz yüze panel ve gece olayı içindir. Köyün bütün ekonomi tablosunu bu şeride sığdırmak yazıyı ezer.

Parçalar: diyalog şeridi (9-slice), seçenek satırı, portre çerçevesi (ortası delik), odak halkası, zar yüzü, küçük mühür. İkon gerekmez.

### Yön B — Mühürlü defter

Kâğıt yalnız kâğıdın olduğu yerde çıkar. Hafıza defteri, divan tutanağı, sabah notu ve izin belgesi bu yöndedir. Pentiment'teki gibi sayfa çevrilir, ama kitap 3B rig olmak zorunda değildir. İlk iş, `defter_gorunumu.gd` içindeki `StyleBoxTexture` yoluna giden tek bir sayfa dokusudur. Sayfa krem bir web formu değildir: lifli, kenarı yırtık, mürekkebi koyu kahve. Başlık Cinzel, gövde Alegreya. Karar basılınca kırmızı-kahve bir mühür bir kez ölçeklenir.

Kapı konuşması bu deftere taşınmaz. Kişi kapıda durur. Defter, oyuncu notu açınca veya divan kurulunca gelir.

Parçalar: sayfa dokusu (karo olabilir, 9-slice şart değil), mühür, sayfa köşesi, ince ayraç. Düğme, şerit düğmesiyle aynı aileden küçültülür.

### Yön C — Rumi kabuk

Köy, harita, ayarlar ve yükleme bu yöndedir. CK3'ün "nefes alan yerleşim ve bağlamlı resim" dersi alınır, Avrupa parşömeni alınmaz. Zemin gece ve is rengidir. Panel ince tombak çerçevedir. Köşe rumisi ayrı decaldır, dilim bandına girmez. Kaynak ikonları küçük, tek renk, aynı mürekkep ailesindendir. Harita bir web haritası değil, bez üstüne mürekkep bir yol şerididir. Yakınlaşınca köy, uzaklaşınca uç bölgesi okunur. Bu davranış CK3'ten kadraj fikridir; onların harita kodu değildir.

Ayarlar aynı çerçeveyi kullanır. Sekmeler tombak şerit olur. Kaydırıcı fitil veya ince metal çubuktur, modern bir slider çizimi değildir.

Parçalar: panel çerçevesi, sekme, kaydırıcı oluğu ve tutamak, onay kutusu, ipucu kutusu, harita bezi, sekiz kaynak ikonu. Menü yazısı kutusuz kalabilir; arkasına yalnız loş bir kapı resmi yeter.

### Ekranların üç yönde hali

| Ekran | A. Gece şeridi | B. Mühürlü defter | C. Rumi kabuk |
|---|---|---|---|
| Kapı konuşması | Ana yer. 3B kişi, alt şerit, portre, az seçenek | Yalnız verilen belge (izin, mektup) şeridin üstüne düşer | Kullanılmaz. Tam panel kişiyi kapatır |
| İç pencere (oda, divan) | Yüz yüze konuşma şerit olarak kalır | Tutanak ve karar defteri | Oda eşyası ve kasası bu kabukta |
| Heybe | Sağdan deri kapak, dünya görünür | Eşya bir liste olarak deftere de yazılabilir | Izgara bu kabuğun yuvası olur |
| Defter | Açılmaz | Ana yer | Çerçeve defterin dış kenarı olabilir |
| Harita | Açılmaz | Kenar notu olarak küçük bir sayfa | Ana yer. Bez ve mürekkep |
| Ayarlar | Açılmaz | Açılmaz | Ana yer. Aynı tombak, sakin tempo |
| Ana menü | Kapı resmi, kutusuz yazı | Kullanılmaz | Arka plan resmi bu yönden |

### Üretim sırası

Sıra, çalışan bir kabuğa en kısa yoldan gider. Her adım Ahmet bir kareyi beğenmeden sonrakine geçmez. Mevcut `gece_kapisi` dosyaları silinmez. Bir parça yeniden üretilmeden önce eli açık, 9-slice bandı ve gerçek alfa kontrol edilir. Kalfa belgesindeki hazır olanlar tekrar çizdirilmez.

1. Ahmet yön birleşimini seçer: kapıda A, defterde B, köy ve ayarda C. Seçim `docs/arayuz/SABLONLAR.md` sonuna yazılır. Bu rapor o satırı doldurmaz.
2. Dört parça: diyalog şeridi, seçenek satırının normal hali, portre çerçevesi, tek rumi köşe. Hover, basılı ve kapalı haller yeni çizim değildir. Aynı doku kararır, tombak kenar açılır veya solar.
3. Alfa maskesi ve 9-slice ölçümü. Köşe rumisi çerçeve dosyasının içinde değildir.
4. `Tema.olustur()` içinde düğme ve panel `StyleBoxTexture` giyer. Ekran betikleri yeniden yazılmaz. İlk prova `src/arayuz/tema_onizleme.tscn` olur.
5. Kapı şeridi bu temayla açılır. 3B sahne görünür kalır. Seçenekler hâlâ mevcut sorgu ağacındandır.
6. Defter sayfası ve mühür, yalnız defter ve divan.
7. Köy şeridi, ayarlar, harita bezi aynı çerçeve ailesinden.
8. İkonlar en son. Çerçeve oturmadan ikon üretmek kabuğu ikon paketine benzetir.
9. Tween ve vinyet en son. Yazı okunmuyorsa efekt eklenmez.

Asset envanteri, üretime geçilen turda ve ancak yeni dosya gerekirse güncellenir. Bu rapor yeni dosya üretmedi.

### Kısa üretim promptları

Kurallar `docs/arayuz/GEMINI_TEKLI_URETIM_PROMPTLARI.md` ile aynıdır. Bir mesajda bir parça. Yazı, rakam, logo ve filigran yok. Zemin düz `#00FF00`. Bu yeşil sonradan maskelenir, resmin içindeki nesnede kullanılmaz. Kalfa, yeşil taşması olursa elle düzeltme gerektiğini de yazar. Avrupa gotik kemer, haç, parşömen rulosu, site kartı, yuvarlak mobil düğme ve düz vektör ikon istenmez. Dönem: 1243 sonrası Anadolu, Selçuklu uç kapısı. Malzeme: isli ceviz, tombak, koyu mürekkep, yün fitil.

Şerit:

```
One UI piece only. A wide horizontal dialogue strip of soot-dark walnut, worn by hands, with a thin tombak brass lip. The center is an empty flat panel for text, with no letters. Corners are plain so the strip can be nine-sliced; do not put ornament on the corners. Background is flat #00FF00 and does not touch the wood. 13th-century Anatolian gate, night, no gothic arch, no cross, no parchment scroll, no website card.
```

Seçenek satırı:

```
One UI piece only. A single horizontal choice row carved into the same soot-dark walnut, slightly inset, thin tombak inner edge. No text. Plain ends for nine-slice. Background flat #00FF00. 13th-century Anatolian, not a mobile button, not a rounded app chip.
```

Portre çerçevesi:

```
One UI piece only. A vertical portrait window of soot-dark wood and a thin tombak rim. The middle is empty and the same flat #00FF00 as the outside, so both can be cut out. A small rumi curl sits only at the four corners, inside the wood, not in the empty middle. No face, no text. 13th-century Seljuk Anatolia, no European knight helm, no gothic tracery.
```

Rumi köşe (ayrı decal):

```
One UI piece only. A single corner ornament of tombak brass in a Seljuk rumi scroll, meant to sit on top of a frame. One corner only, the other three edges fade to empty. Background flat #00FF00. No text, no cross, no fleur-de-lis, no Celtic knot.
```

Mühür:

```
One UI piece only. A round wax seal, dark red-brown, pressed with a simple eight-point Seljuk star, slightly cracked. No letters. Background flat #00FF00. 13th-century Anatolia.
```

Defter sayfası:

```
One UI piece only. A full page of fibrous, warm-gray paper, darker at the edges, a few ink freckles, no writing, no lines of fake text. Even enough to tile. Background is the paper itself, opaque, not #00FF00. Not a clean website parchment, not a European illuminated border.
```

## Ne yapılmadı

Oyunlar oynanmadı. Godot açılmadı. Eklentiler kurulmadı. Kenney'nin kendi sitesi 403 döndü. CraftPix fiyatı ürün sayfasından değil, etiket listesinden okundu. `gece_kapisi` PNG'lerinin güncel alfa ve dilim payı yeniden ölçülmedi. Ahmet'in Windows kopyası bu makinede yok.

Sonraki iş bir madde sahibi almak değildir. Ahmet yönü seçer. Seçimden sonra tema bağlantısı ayrı, küçük bir turdur. ROADMAP_2'deki GRV ve ARY satırları Berk tarafındadır; bu rapor onlara yazılmadı.
