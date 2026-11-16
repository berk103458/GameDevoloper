# Dönem asset envanteri

17 Kasım 2026 (Ahmet'in görev tarihi; sayfalar 16 Kasım UTC akşamı açıldı). Cursor. Yalnız araştırma. Oyun kodu, sahne, `assets/meshy_manifest.json` ve indirme yok.

İstenen dönem: 14. yüzyıl Osmanlı uç beyliği, sınır köyü, ciddi ve gerçekçi ton. Repodaki Meshy istemlerinin bir kısmı hâlâ 1243 Selçuklu ucu diye yazar. Bu liste 14. yüzyıl Osmanlı sınırına göre işaretlenir. Aynı nesne 13. yüzyıl ucunda da durabiliyorsa bu, gerekçede söylenir.

Lisanslar yayın öncesi ayrıca alınacak. Ücretli ve kısıtlı kayıtlar da durur. Lisans hücresi sayfadan okunandır. CC-BY-SA, paylaşılan türevi de aynı lisansla bağlar; oyun dosyasına gömmeden önce insan kararı gerekir.

## Nasıl tarandı

Her satırın linki bu makineden açıldı. 404 dönen sayfa yazılmadı. 403 veya 429 ile gövdesi okunamayan katalog, "bulunamadı" bölümündedir; nesne uydurulmadı.

Okunan kataloglar: Quaternius paket sayfaları, Kenney ve OpenGameArt aynaları, KayKit, Poly Haven, ambientCG, Summer Engine koleksiyon merkezleri ve üç tekil sayfa, game-icons.net (yalnız 200 dönen ikonlar), Wikimedia Commons dosya sayfaları, Google Fonts, Sketchfab'da lisansı sayfada yazan üç model, Mixamo giriş sayfası ve Adobe topluluk lisans metni, Fab ana sayfası. Met nesne sayfaları arama sırasında açıldı; ardından HEAD istekleri 429 aldı. Smithsonian, Europeana ve British Museum bu makineye 403 verdi.

Summer Engine'de el yapımı ile yapay zekâ ayrıdır. Koleksiyon sayfası bunu her parça için yazmaz. Tekil sayfada "Handmade" veya "Made with …" yazmıyorsa üretim yolu "sayfada yok" diye bırakıldı.

Repoda bugün: `assets/meshy_manifest.json` 920 kayıt. Yapı, nesne, karakter ve hayvanların çoğu Meshy çıktısı ve rig'siz yapı/eşya. Karakter yürüyüş klipleri rigli. Köy kataloğu `data/koy/binalar.json`: çadır, kulübe (`yapi/ev`), tarla, hızarhane, taş ocağı, avcı, atölye, ambar. Gezgin stok ikonu `src/arayuz/koy_hud/gezgin_stok_ikonu.gd` hâlâ düz renktir (çivi, tırpan, balta, afyon, sargı, keçe, kumaş, zırh, yay, kalkan, su, saman, ilaç). Alış satırının kendisi `gezgin_stok_paneli.gd` içindedir.

## Özet sayılar

Tablolardaki linkli satır 73'tür. Uygunluk, satırın gerekçe hücresinden sayıldı.

| Uygunluk | Kayıt |
|---|---|
| KESİN | 12 |
| İSTEĞE BAĞLI | 9 |
| UYARLANIRSA | 47 |
| Dönem dışı (açıkça elenir) | 1 |
| Katalog veya sınıfsız (tek parça açılmadı) | 4 |
| Toplam satır | 73 |

Bölüm satırları: ikon 11, sikke ve belge 3, çerçeve 5, yazı tipi 10, yapı 10, eşya ve silah 7, hayvan 3, karakter ve hareket 8, doğa ve doku 13, ücretli ve kısıtlı 3, VFX 0. Katalog satırları yapı ve doğa bölümlerinin içindedir.

KESİN olanlar tahta ve taş dokusu, kurumuş gövde, deve piktogramı, EB Garamond, Amiri, repodaki Alegreya ve Cinzel, Quaternius hareket kütüphanesi ve Mixamo hareket lisansıdır. Köy evi, cami, hamam, tekke, ferace ve çakşır için hazır ve dönemine oturan bir 3B paket bulunamadı.

## Hemen bakılacak ilk 30

Sıra, oyundaki boşluğa göredir. Hepsi indirme emri değildir.

1. Poly Haven `medieval_wood` — ahşap doku, CC0, KESİN.
2. ambientCG Wood 049 — ikinci ahşap, CC0, KESİN.
3. Poly Haven `rock_wall_03` ve `rock_01` — taş doku ve kaya, CC0, KESİN.
4. Poly Haven `dead_tree_trunk` — 102K üçgen, kuru ağaç, CC0, KESİN.
5. Poly Haven `wooden_barrels_01` — 33K üçgen, fıçı, CC0. Çember demiri durur; İSTEĞE BAĞLI.
6. Google Fonts EB Garamond — latin-ext, OFL, defter ve ferman gövdesi, KESİN.
7. Google Fonts Amiri — Arapça gövde ve latin-ext, OFL, belgedeki Arapça satır, KESİN.
8. Repodaki Alegreya ve Cinzel — zaten var, yeniden alınmaz.
9. game-icons buğday, kumaş topu, örs, deve — CC BY 3.0, geçici tüccar ikonu.
10. Wikimedia, II. Murad akçesi — CC BY-SA 3.0, sikke referansı. 15. yüzyıl.
11. Wikimedia, tuğralı ferman — kamu malı eser fotoğrafı, 16. yüzyıl düzen referansı.
12. Met miğfer 14.25.534 — kamu malı fotoğraf, yaklaşık 1580, zırh referansı. 3B dosya bu sayfada yok.
13. Quaternius Universal Animation Library — CC0, insan hareketi. Repoda A01 olarak geçiyor; ikinci kopya açmadan dosya adı karşılaştırılmalı.
14. Mixamo Idle — ücretsiz özel lisans, Adobe kimliği. Mevcut rig'e hedef. Karakter modeli alınmaz.
15. Quaternius Ultimate Animated Animals — CC0, rigli. Üslup yuvarlak; renk ve oran iner.
16. Quaternius Ultimate Crops — CC0, tarla. Bitki türü tek tek seçilir.
17. Quaternius Ultimate Nature — CC0, 150 model. Avrupa ormanı; ardıç ve çınar ayrıca aranır.
18. Kenney Nature Kit — CC0. Aynı sınır.
19. Kenney Animal Pack Remastered — CC0, stilize. Deve ve at silueti için bakılır, koyun modeli Meshy'de var.
20. Quaternius Medieval Village MegaKit — CC0 yazıyor; sayfa paketin bir kısmını ücretsiz, kaynağı destekçiye ayırıyor. Dam ve pencere Avrupa. Kerpiç sıva ve alçak saçak gerekir.
21. KayKit Medieval Hexagon — CC0. Kilise ve taverna çıkar. Değirmen, kuyu, ev, sur kalır ve sıvanır.
22. Kenney Castle Kit — CC0, 75+ model. Sur ve kapı Avrupa kalesi. Palisada ile değiştirilecek yer `sur_2_palisat` zaten repoda.
23. Kenney Medieval RTS — CC0, 2B. Harita simgesi. Haçlı birlikleri kullanılmaz.
24. Kenney Food Kit — CC0. Ekmek ve et seçilir; modern ambalaj atılır.
25. Sketchfab değirmen, FLAREMEDIA — CC BY 4.0, 592 üçgen. Avrupa çatı değirmeni. Kanat ve gövde sadeleştirilir.
26. Sketchfab cami, endomirebus — CC BY 4.0, 7,3K üçgen. Minare ve kubbe erken Osmanlı ölçüsüne çekilir. Sayfa tarih vermiyor.
27. Summer `medieval-village-realistic` — yarım ahşap Avrupa köyü. Tek parça sayfası açılmadan lisans ve yapay zekâ işareti yok sayılır.
28. Summer `rpg-medieval-realistic` — aynı şart. Viking silah rafı dönem dışı.
29. Lamoot RPG GUI — repoda aday. Yeni indirme değil; CC BY 3.0 tahta çerçeve.
30. Quaternius Modular Weapons — CC0, 24 silah. Kılıç düz ve Avrupa. Repodaki `kilic`, `yay`, `kalkan`, `mizrak` dururken yenisi ancak eğri kılıç boşluğu için referans olur.

## 2D ikonlar

Hepsi game-icons.net, SVG ve PNG, CC BY 3.0. Atıf: Lorc veya Delapouite, game-icons.net. Rig yok. Çözünürlük vektör. Üslup düz siyah piktogramdır; 14. yüzyıl resmi değildir. Tüccar satırında geçici ikon olur, sahne modeli olmaz.

| Kategori | Ad | Link | Tür | Biçim | Ölçü | Rig | Lisans | Uygunluk | Oyunda | Repoda |
|---|---|---|---|---|---|---|---|---|---|---|
| tahıl | Buğday | https://game-icons.net/1x1/lorc/wheat.html | 2D | SVG, PNG | vektör | hayır | CC BY 3.0 | UYARLANIRSA. Başak doğru, çizgi modern | `gezgin_stok_paneli.gd` tahıl satırı; tarla `binalar.json` | `assets/ui/koy/bugday.svg` benzeri düz ikon var |
| kumaş | Kumaş topu | https://game-icons.net/1x1/delapouite/rolled-cloth.html | 2D | SVG, PNG | vektör | hayır | CC BY 3.0 | UYARLANIRSA. Top doğru, desen yok | kumaşçı stoğu, `gezgin_stok_ikonu` kumaş | `icon` ailesi ve `kumas` aranır; düz renk kutu duruyor |
| deri | Deri yelek | https://game-icons.net/1x1/lorc/leather-vest.html | 2D | SVG, PNG | vektör | hayır | CC BY 3.0 | UYARLANIRSA. Yelek modern kesim. Deri balyası değil | heybe ve celep | Meshy `el_kurk_bohca` 3B var, 2B ikon yok |
| demir | Örs | https://game-icons.net/1x1/lorc/anvil.html | 2D | SVG, PNG | vektör | hayır | CC BY 3.0 | UYARLANIRSA. Örs biçimi genel | atölye, demirhane | `assets/model/nesne/ors.glb` var |
| alet | Kütükte balta | https://game-icons.net/1x1/lorc/axe-in-stump.html | 2D | SVG, PNG | vektör | hayır | CC BY 3.0 | UYARLANIRSA. Balta doğru, kütük batı masalı | gezgin balta, hızarhane | `balta.glb` var |
| silah | Okçu | https://game-icons.net/1x1/lorc/bowman.html | 2D | SVG, PNG | vektör | hayır | CC BY 3.0 | UYARLANIRSA. Şapka ve yay Avrupa okçusu | kapı, avcı | `yay.glb` var |
| ilaç | İksir küresi | https://game-icons.net/1x1/lorc/potion-ball.html | 2D | SVG, PNG | vektör | hayır | CC BY 3.0 | UYARLANIRSA. Cam iksir. Osmanlı ot kesesi değil | aktar, `ilac` ikonu | şifahane modeli var, ikon düz renk |
| hayvan | Deve | https://game-icons.net/1x1/delapouite/camel.html | 2D | SVG, PNG | vektör | hayır | CC BY 3.0 | KESİN. Tek hörgüçlü siluet kervana uyar | celep, kervan | `deve` Meshy hayvanı manifestte |
| tuz | Tuzluk | https://game-icons.net/1x1/lorc/salt-shaker.html | 2D | SVG, PNG | vektör | hayır | CC BY 3.0 | UYARLANIRSA. Modern tuzluk. Tuz kesesi çizilmeli | tüccar tuz satırı | yok |
| durum | Kanayan kalp | https://game-icons.net/1x1/lorc/bleeding-heart.html | 2D | SVG, PNG | vektör | hayır | CC BY 3.0 | UYARLANIRSA. Hastalık değil, fantezi kalp | moral veya yara için ancak çizgi değişirse | yok |
| belge | Açık tomar | https://game-icons.net/1x1/lorc/scroll-unfurled.html | 2D | SVG, PNG | vektör | hayır | CC BY 3.0 | UYARLANIRSA. Tomar Avrupa. Ferman sayfa düzeni değil | divan, mühür kağıdı ikonu | defter adayları ayrı | 

İpek, baharat, çömlek, akçe, açlık ve hastalık için bu sitede açılan adaylar 404 verdi (`spices`, `salt`, `sheep`, `cow`, `hunger`, `sickle`, `coins`). Doğru dosya adı bulunamadı. Uydurulmadı.

## Para, belge, mühür

| Kategori | Ad | Link | Tür | Biçim | Ölçü | Rig | Lisans | Uygunluk | Oyunda | Repoda |
|---|---|---|---|---|---|---|---|---|---|---|
| sikke | II. Murad akçesi, ön yüz | https://commons.wikimedia.org/wiki/File:Ak%C3%A7e_of_Murad_II_Obverse.JPG | 2D | JPG | 1280×1280 | hayır | CC BY-SA 3.0. Sayfa metni: "This file is licensed under the Creative Commons Attribution-Share Alike 3.0 Unported". Kategori CC-BY-SA-3.0 | İSTEĞE BAĞLI. Akçe doğru birim. II. Murad 1421–1451, 14. yüzyıl değil | tüccar akçe ikonu için fotoğraf referansı | `icon_akce.png` atmosfer paketinde var, fotoğraf değil |
| ferman | Tuğralı ferman | https://commons.wikimedia.org/wiki/File:Unknown,_Turkey,_16th_Century_-_Ferman_with_a_Tughra_-_Google_Art_Project.jpg | 2D | JPG | sayfa açıldı, piksel bu turda ölçülmedi | hayır | Commons: eserin kendisi kamu malı (yazar ömrü + 100 yıl). Katar İslam Sanatı Müzesi koleksiyonu. Fotoğrafın müze izni ayrıca okunmadı | İSTEĞE BAĞLI. Düzen doğru, tarih 16. yüzyıl, Kanuni | divan ve kapı belgesi referansı | oyun içi ferman modeli yok |
| tuğra | III. Murad tuğrası | https://commons.wikimedia.org/wiki/File:Tughra_of_Murad_III.png | 2D | PNG | sayfa 200 | hayır | Bu dosyanın lisans kutusu bu turda satır satır okunmadı. Kategori sayfası açıldı, tekil lisans hükmü yazılmadı | İSTEĞE BAĞLI. Tuğra biçimi doğru, sahip 1574–1595 | mühür süsü referansı, oyun mührü olmaz | `ornament_seal` üslup parçası var, tuğra değil |

Dirhem için doğrulanmış tek dosya yok. Altın sultani için kategori var (`Category:Sultani`) ama tek dosya açılmadı; satır yok.

## Çerçeve, panel, düğme

| Kategori | Ad | Link | Tür | Biçim | Ölçü | Rig | Lisans | Uygunluk | Oyunda | Repoda |
|---|---|---|---|---|---|---|---|---|---|---|
| çerçeve | Kenney UI Pack | https://opengameart.org/content/ui-pack | 2D | PNG, SVG | 430+ parça | hayır | CC0 | UYARLANIRSA. Düz ve renkli. Kapı gecesine boya ve is gerekir | ayarlar, düğme hali | `docs/UI_ADAYLARI.md` günlük paketi elemiş |
| çerçeve | Kenney UI Pack RPG | https://opengameart.org/content/ui-pack-rpg-extension | 2D | PNG | sayfa 200 | hayır | CC0 | UYARLANIRSA. Kahverengi RPG. Çizgi film | köy paneli adayı, repoda bağlı | aday 3 olarak duruyor |
| çerçeve | Lamoot RPG GUI v1 | https://opengameart.org/content/rpg-gui-construction-kit-v10 | 2D | PNG, GIMP | sayfa 200 | hayır | CC BY 3.0. Atıf Matjaž Lamut. Sayfa ek olarak bir doku ve kamu malı ahşap fotoğrafı kullanıldığını söyler; o iki kaynağın lisansı zip açılmadan doğrulanmadı | UYARLANIRSA. Yıpranmış tahta. Köşe oku Avrupa RPG | menü levhası | aday 1 olarak duruyor |
| çerçeve | Kenney Medieval RTS | https://opengameart.org/content/medieval-rts-120 | 2D | PNG, SVG | 127 PNG | hayır | CC0 | UYARLANIRSA. Üstten bakış Avrupa birlikleri. Haç ve miğfer silinir | harita simgesi | yok |
| katalog | Summer çerçeve koleksiyonu | https://www.summerengine.com/asset-store/c/frames-borders | 2D | karışık | 165 varlık, sayfa sayısı | hayır | parça sayfasında | katalog. Tek parça açılmadı | portre çerçevesi aranacak yer | `portrait_frame.png` repoda, bağsız |

Yazı süsü olarak ayrı bir Selçuklu veya Osmanlı rumi paketi bulunamadı. game-icons tomar, süs değil.

## Yazı tipleri

Google Fonts sayfaları 200. Lisans OFL 1.1. Oyun içine gömmek serbest; font dosyasını tek başına satmak yasak. Türkçe glif bu turda font dosyası indirilip cmap'ten sayılmadı. latin-ext alt kümesi Google Fonts kaydında olanlar Türkçe için olağan yoldur; cmap yine de indirme anında sayılır.

| Kategori | Ad | Link | Tür | Biçim | Ölçü | Rig | Lisans | Uygunluk | Oyunda | Repoda |
|---|---|---|---|---|---|---|---|---|---|---|
| gövde | EB Garamond | https://fonts.google.com/specimen/EB+Garamond | font | TTF değişken | latin, latin-ext, Yunanca, Kiril | hayır | OFL | KESİN. Kitap gövdesi. 16. yüzyıl Garamond çizgisi, 14. yüzyıl hattı değil; Türkçe okunur | defter, ferman Latin satırı | yok. Gövde bugün Alegreya |
| gövde | Literata | https://fonts.google.com/specimen/Literata | font | TTF | sayfa 200 | hayır | OFL | İSTEĞE BAĞLI. Ekran serifi, dönem taklidi değil | uzun konuşma | yok |
| gövde | Source Serif 4 | https://fonts.google.com/specimen/Source+Serif+4 | font | TTF | sayfa 200 | hayır | OFL | İSTEĞE BAĞLI. Aynı | aynı | yok |
| başlık | Cinzel | https://fonts.google.com/specimen/Cinzel | font | TTF değişken | latin-ext | hayır | OFL | KESİN. Repoda Türkçe glif daha önce sayıldı | köy başlığı | `assets/font/Cinzel-wght.ttf` |
| gövde | Alegreya | https://fonts.google.com/specimen/Alegreya | font | TTF değişken | sayfa 200 | hayır | OFL | KESİN. Repoda duruyor | bütün UI | `assets/font/Alegreya-wght.ttf` |
| Arapça | Amiri | https://fonts.google.com/specimen/Amiri | font | TTF | Arapça + latin-ext | hayır | OFL | KESİN. Belgedeki Arapça satır. Türkçe gövde için değil | ferman, mühür altı | yok |
| Arapça | Scheherazade New | https://fonts.google.com/specimen/Scheherazade+New | font | TTF | Arapça | hayır | OFL | İSTEĞE BAĞLI. Latin Türkçe glif iddiası yok | yalnız Arapça satır | yok |
| Arapça | Noto Naskh Arabic | https://fonts.google.com/specimen/Noto+Naskh+Arabic | font | TTF | Arapça | hayır | OFL | İSTEĞE BAĞLI. Aynı | aynı | yok |
| başlık | MedievalSharp | https://fonts.google.com/specimen/MedievalSharp | font | TTF | sayfa 200, alt küme bu turda okunmadı | hayır | OFL | UYARLANIRSA. Kara Avrupa teşhiri. Türkçe glif doğrulanmadı; yoksa alınmaz | alınmasın | yok |
| başlık | UnifrakturMaguntia | https://fonts.google.com/specimen/UnifrakturMaguntia | font | TTF | sayfa 200 | hayır | OFL | UYARLANIRSA. Gotik kırık yazı. Osmanlı ve Türkçe için yanlış | alınmasın | yok |

## 3B yapılar

| Kategori | Ad | Link | Tür | Biçim | Ölçü | Rig | Lisans | Uygunluk | Oyunda | Repoda |
|---|---|---|---|---|---|---|---|---|---|---|
| köy | Medieval Village MegaKit | https://quaternius.com/packs/medievalvillagemegakit.html | 3D | FBX, OBJ, glTF | 304 model. Sayfa: duvar, çatı, merdiven, kapı, pencere, asma. Ücretsiz pay %60–70, ek pay destekçi, motor kaynağı ayrı. Hüküm sayfada CC0 | hayır | CC0 (sayfa böyle yazar; hangi dosyanın ücretsiz zip'te olduğu indirilmeden sayılmadı) | UYARLANIRSA. Yarım ahşap, dik çatı, Avrupa penceresi. Kerpiç, düz dam veya alçak kiremit, avlu duvarı gerekir | `binalar.json` ev, atölye, ambar | `yapi/ev.glb`, `atolye`, `ambar`, `kervansaray` Meshy |
| köy | Medieval Village (eski paket) | https://quaternius.com/packs/medievalvillage.html | 3D | sayfa 200 | ayrı sayı okunmadı | hayır | CC0 (Quaternius paket ailesi; bu sayfanın lisans cümlesi megakit kadar uzun okunmadı) | UYARLANIRSA. Aynı üslup | aynı | aynı |
| köy | KayKit Medieval Builder, eski | https://kaylousberg.itch.io/kaykit-medieval-builder-pack | 3D | FBX, OBJ, DAE, glTF | 200+ sahne, 10+ bina | hayır | CC0. Sayfa: üretken yapay zekâ yok | UYARLANIRSA. Altıgen ve kare Avrupa köyü | köy ızgarası | günlük: KayKit hex alınmadı, MegaKit çevre duruyor |
| köy | KayKit Medieval Hexagon 1.0 | https://github.com/KayKit-Game-Assets/KayKit-Medieval-Hexagon-Pack-1.0 | 3D | FBX, glTF | 200 model, tek 1024 doku | hayır | CC0 | UYARLANIRSA. İçinde demirci, hızar, değirmen, kuyu, ev, kışla, pazar, okçuluk. Kilise ve taverna çıkar. Renkler mavi kırmızı yeşil sarı, oyun kahverengisi değil | `degirmen`, `pazar_tezgahi`, `kuyu` | Meshy karşılıkları var |
| kale | Kenney Castle Kit | https://kenney.nl/assets/castle-kit | 3D | OBJ, FBX, glTF | 75+ | hayır | CC0. OGA aynası da CC0: https://opengameart.org/content/castle-kit | UYARLANIRSA. Sur, kule, kapı, kuşatma, sancak. Mazgal ve köprü Avrupa. Kapı kirişi ve palisada repodakine yaklaştırılır | `kapi`, `sur_3_tas`, `gozetleme_kulesi` | Meshy kapı ve sur var |
| kale | Kenney Fantasy Town | https://kenney.nl/assets/fantasy-town-kit | 3D | sayfa 200 | 2.0 sürümü | hayır | Kenney sayfalarında CC0 damgası bu turda gövde metninde de görüldü (food ve animal sayfaları). Bu sayfanın gövdesi kısa döndü | UYARLANIRSA. Fantezi kasaba. Büyü evi ve tabela atılır | köy dolgusu | yok |
| katalog | Summer gerçekçi köy | https://www.summerengine.com/asset-store/c/medieval-village-realistic | 3D | koleksiyon | dört yarım ahşap ev, demirci, su hızarı, han, 33 eşya. Katalog metni | parça bilinmiyor | "Check each asset detail page". Toplu lisans yok | UYARLANIRSA. Yarım ahşap Alman köyü. Kerpiç ve toprak dam yok. Yapay zekâ işareti parça sayfasında | referans, doğrudan koyma | Meshy ev var |
| katalog | Summer gerçekçi kale | https://www.summerengine.com/asset-store/c/medieval-castle-realistic | 3D | koleksiyon | Poly Haven taramasından sur, 15,8 m kule, silahlık. Katalog metni | hayır | parça sayfası | UYARLANIRSA. Katalogda katana da sayılmış. O parça alınmaz | sur referansı | `sur_3_tas.glb` |
| cami | Low poly cami | https://sketchfab.com/3d-models/mosque-low-poly-152d26c4b6a24fe8888639405b4bb948 | 3D | Sketchfab indirmesi, biçim sayfada GLB/FBX olarak açılmadı | 7,3K üçgen, 4,2K köşe | sayfada yok | CC BY 4.0 | UYARLANIRSA. Cami kütlesi var. Erken Osmanlı tek minare ve alçak kubbe ölçüsü sayfada yok | ileride mescit. `binalar.json` içinde cami yok | yok |
| değirmen | Low-poly değirmen | https://sketchfab.com/3d-models/windmill-low-poly-ed577ce3d4db49a283924c2ec27e65e8 | 3D | aynı | 592 üçgen, 267 köşe | sayfada yok | CC BY 4.0 | UYARLANIRSA. Avrupa çatı değirmeni. Anadolu su değirmeni için oluk ve çark gerekir | `yapi/degirmen` | Meshy değirmen var |

Han, hamam, tekke, mescit, gözcü kulesinin Osmanlı biçimi, otağ ve kerpiç ev için hazır CC0 paket bulunamadı. Repoda `kervansaray`, `cadir`, `gozetleme_kulesi`, `sifahane` Meshy'dir.

## Eşya, alet, silah, zırh

| Kategori | Ad | Link | Tür | Biçim | Ölçü | Rig | Lisans | Uygunluk | Oyunda | Repoda |
|---|---|---|---|---|---|---|---|---|---|---|
| silah | Modular Weapons | https://quaternius.com/packs/medievalweapons.html | 3D | FBX, OBJ, Blend | 24 model: kılıç, hançer, yay, kalkan, çekiç. Eylül 2018 | hayır | sayfa "free to use in personal and commercial projects"; Quaternius ailesi CC0 diye listelenir, bu sayfanın CC0 sözcüğü megakit kadar açık okunmadı | UYARLANIRSA. Düz kılıç ve uçurtma kalkan. Eğri kılıç, yumurta kalkan ve tik ağacı yay gerekir | kapı `kilic`, `yay`, `kalkan` | Meshy karşılıkları var |
| silah | Ultimate RPG | https://quaternius.com/packs/ultimaterpg.html | 3D | sayfa 200 | sayı okunmadı | bilinmiyor | CC0 aile | UYARLANIRSA. İksir ve fantezi eşya elenir | heybe | heybe çizimi kodla |
| eşya | Survival | https://quaternius.com/packs/survival.html | 3D | sayfa 200 | sayı okunmadı | bilinmiyor | CC0 aile | UYARLANIRSA. Kamp baltası ve çadır modern hayatta kalma. Otağ ve nalbur aleti seçilir | avcı çadırı, alet | `balta`, `orak`, `kazma` yoksa `balta.glb` var |
| katalog | Summer kılıç koleksiyonu | https://www.summerengine.com/asset-store/c/swords | 3D | karışık | 98 varlık | parça | parça sayfası | katalog. Tek kılıç açılmadı | kapı silahı aranacak yer | `kilic.glb` |
| katalog | Summer yiyecek | https://www.summerengine.com/asset-store/c/food-items | 2D/3D | karışık | 67 | hayır | parça sayfası | katalog | tüccar | yok |
| katalog | Summer sikke | https://www.summerengine.com/asset-store/c/coins-loot | 2D/3D | karışık | 180 | hayır | parça sayfası | UYARLANIRSA. Altın ve kristal. Akçe yazısı yok | tüccar | `icon_akce` |
| referans | Met kılıç 36.25.1333 | https://www.metmuseum.org/art/collection/search/24323 | 2D | müze fotoğrafı | kabza Osmanlı geç 17. yy, namlu Avrupa 17. yy | hayır | sayfa aramada açıldı, "Public Domain" bu kılıç sayfasında ayrıca işaretli değildi (miğfer sayfalarında vardı). 3B indirme yok | İSTEĞE BAĞLI. Eğri değil, düz namlu. 14. yüzyıl değil | silah çizimi referansı | `kilic.glb` |

Bizans lamellar ve Moğol tulga için oyun paketi bulunamadı. Met miğferleri fotoğraf referansıdır.

## Hayvanlar

| Kategori | Ad | Link | Tür | Biçim | Ölçü | Rig | Lisans | Uygunluk | Oyunda | Repoda |
|---|---|---|---|---|---|---|---|---|---|---|
| hayvan | Ultimate Animated Animals | https://quaternius.com/packs/ultimateanimatedanimals.html | 3D | FBX, OBJ, glTF, Blend | 12 hayvan, her biri 12+ hareket. Temmuz 2021 | evet | ticari kullanım serbest; CC0 aile | UYARLANIRSA. Yuvarlak üslup. At, inek, koyun, kurt seçilir. Deve pakette sayılmadı | celep, ağıl, ahır | Meshy: kurt, ve manifestte köpek, inek, koç, beygir, at, keçi, deve |
| hayvan | Kenney Animal Pack Remastered | https://kenney.nl/assets/animal-pack-redux | 3D | Kenney biçimleri | sayfa 200 | sayfada animasyon iddiası yok | sayfada CC0 | UYARLANIRSA. Düşük çokgen, çizgi film | aynı | aynı |
| doğa | Ultimate Fantasy RTS | https://quaternius.com/packs/ultimatefantasyrts.html | 3D | sayfa 200 | sayı okunmadı | birimlerde olabilir | CC0 aile | UYARLANIRSA. Ejder ve büyü birimi elenir. Çiftlik parçası kalırsa | köy | Meshy yapılar duruyor |

## Karakter ve animasyon

| Kategori | Ad | Link | Tür | Biçim | Ölçü | Rig | Lisans | Uygunluk | Oyunda | Repoda |
|---|---|---|---|---|---|---|---|---|---|---|
| hareket | Universal Animation Library | https://quaternius.com/packs/universalanimationlibrary.html | anim | sayfa 200 | sayı bu turda okunmadı | evet, insan | sayfada CC0 | KESİN. Hareket iskelete gider, kıyafet getirmez | muhafız idle ve yürüyüş | günlük A01 Quaternius UAL. Karakter klipleri Meshy |
| hareket | Mixamo | https://www.mixamo.com/ | anim | FBX | iki ayaklı insan. Idle, yürüme, konuşma | evet | Ücretsiz özel lisans. Adobe kimliği, Creative Cloud şart değil. Oyun içi kullanım serbest, ham dosyayı asset paketi diye dağıtmak yasak. Yapay zekâ eğitimine yasak. Kaynak: Adobe topluluk lisans metni ve 23 Haziran 2021 ek şart PDF. Resmi help sayfası bu makinede 403 | KESİN hareket için. Karakterler modern veya fantezi, alınmaz | mevcut Meshy rig'e Idle | karakterler zaten klipli |
| erkek | Ultimate Modular Men | https://quaternius.com/packs/ultimatemodularcharacters.html | 3D | sayfa 200 | modüler | evet beklenir, sayfada tek tek sayılmadı | CC0 aile | UYARLANIRSA. Çıplak taban ve Avrupa zırh parçası. Şalvar, sarık, ferace yok | kapı karakteri tabanı | onlarca rigli Meshy karakter var |
| kadın | Ultimate Modular Women | https://quaternius.com/packs/ultimatemodularwomen.html | 3D | sayfa 200 | modüler | aynı | CC0 aile | UYARLANIRSA. Aynı. Başörtüsü ve entari yok | köylü kadın | `ciftci_kadin`, `sorhan_karisi` |
| şövalye | Animated Knight | https://quaternius.com/packs/knightcharacter.html | 3D | sayfa 200 | tek karakter | evet, paket adı animasyonlu | CC0 aile | UYARLANIRSA. Tam plaka. Uç beyi askeri değil | alınmasın, ancak metal okuma referansı | `asker` Meshy |
| tekil | Kael, Dragon Knight | https://www.summerengine.com/asset-store/kael-dragon-knight-2db3d167 | 3D | sayfa indirme biçimini bu özette yazmıyor | yok | sayfada yok | CC0 | UYARLANIRSA. Ejderha şövalyesi. Üretim yolu sayfada yok | alınmasın | yok |
| tekil | Anime Girl Idle | https://www.summerengine.com/asset-store/anime-girl-idle-b2642d9a | anim | GLB | yok | evet | sayfa "Handmade", Quaternius kataloğundan | UYARLANIRSA. Anime. Dönem kıyafeti yok | alınmasın | yok |
| tekil | PSX Raptor | https://www.summerengine.com/asset-store/psx-raptor-cab774d2 | 3D | sayfa | yok | hayır | CC0. "Made with image-to-3d" | dönem dışı. Yapay zekâ | alınmasın | yok |

Osmanlı, Bizans veya Moğol kıyafetli, rigli, CC0 bir karakter paketi bulunamadı.

## Doğa, doku, ekin

| Kategori | Ad | Link | Tür | Biçim | Ölçü | Rig | Lisans | Uygunluk | Oyunda | Repoda |
|---|---|---|---|---|---|---|---|---|---|---|
| doku | Medieval Wood | https://polyhaven.com/a/medieval_wood | doku | PBR | 2 m geniş, sayfa 69,9 MB | hayır | CC0 | KESİN. Eskimiş tahta. "Medieval" adı Avrupa tahtası da olabilir; damar nötr | kapı, ev, ambar malzemesi | Meshy modellerin kendi dokusu var |
| doku | Wood 049 | https://ambientcg.com/view?id=Wood049 | doku | PBR | sayfa başlığı Wood 049 | hayır | CC0. ambientCG ana sayfası bütün varlıklar CC0 der: https://ambientcg.com/ | KESİN | aynı | yok |
| doku | Rock Wall 03 | https://polyhaven.com/a/rock_wall_03 | doku | PBR | 2,6 m | hayır | CC0 | KESİN. Kuru taş | sur, taş ev | `sur_3_tas` |
| kaya | Rock 01 | https://polyhaven.com/a/rock_01 | 3D | Poly Haven biçimleri (glb, blend) | sayfa 200, üçgen bu turda okunmadı | hayır | CC0 | KESİN | köy kenarı | `kaya.glb`, `kaya_02.glb` |
| ağaç | Dead Tree Trunk | https://polyhaven.com/a/dead_tree_trunk | 3D | aynı | 102K üçgen, 3,1 m | hayır | CC0 | KESİN. Kurumuş gövde, tür iddiası yok | kış, yanık kenar | `agac.glb` stilize |
| ağaç | Pine Tree 01 | https://polyhaven.com/a/pine_tree_01 | 3D | aynı | 17M üçgen, 1,31 GB | hayır | CC0 | UYARLANIRSA. Çam doğru bölgede de durur. Çokgen oyun ölçüsünün çok üstünde. İndirmeden seyreltme şart | orman kenarı | stilize ağaç var |
| ağaç | Island Tree 03 | https://polyhaven.com/a/island_tree_03 | 3D | aynı | 5M üçgen | hayır | CC0 | UYARLANIRSA. Ada ağacı, Anadolu türü değil ve ağır | alınmasın | var |
| fıçı | Wooden Barrels 01 | https://polyhaven.com/a/wooden_barrels_01 | 3D | aynı | 33K üçgen, 4,4 m grup | hayır | CC0 | İSTEĞE BAĞLI. Fıçı doğru. Fotoğraf gerçekliği oyun üslubundan ağır | ambar, han | `cuval_yigini` var, fıçı yok |
| doğa | Ultimate Nature | https://quaternius.com/packs/ultimatenature.html | 3D | FBX, OBJ, Blend | 150 model, Haziran 2019 | hayır | ticari serbest, CC0 aile | UYARLANIRSA. Stilize orman. Çınar, ardıç, asma seçilerek | köy çevresi | `agac`, `agac_02` |
| ekin | Ultimate Crops | https://quaternius.com/packs/ultimatecrops.html | 3D | sayfa 200 | sayı okunmadı | hayır | CC0 aile | UYARLANIRSA. Mısır ve kabak varsa atılır. Buğday ve arpa kalır | `tarla`, `bostan` | `tarla.glb`, `bostan.glb` |
| doğa | Kenney Nature Kit | https://kenney.nl/assets/nature-kit | 3D | sayfa 200 | sayı okunmadı | hayır | Kenney CC0 | UYARLANIRSA. Aynı | aynı | aynı |
| yiyecek | Kenney Food Kit | https://kenney.nl/assets/food-kit | 3D | sayfa 200 | sayı okunmadı | hayır | sayfada CC0 | UYARLANIRSA. Ekmek ve et alınır, kutu ve şişe atılır | pazar | düz ikonlar |
| katalog | Summer orman | https://www.summerengine.com/asset-store/c/survival-nature | 3D | koleksiyon | 18 animasyonlu hayvan, huş, çam, kaya, kamp. Katalog | hayvanlarda evet deniyor | parça sayfası | UYARLANIRSA. Yapay zekâ işareti parça sayfasında aranacak | köy çevresi | hayvanlar Meshy |

Çit için Poly Haven `wooden_fence_01` 404. Repoda `kazik_cit.glb` var.

## VFX

Doğrulanmış, döneme ait bir duman, ateş veya toz paketi bulunamadı. Kenney parçacık paketi bu turda açılmadı; yok denmez, satır da açılmaz. Repoda daha önce duman ve ateş yer tutucusu çalışması vardır; bu envanter onu yeniden ölçmedi.

## Ücretli ve kısıtlı

Fiyatı bu turda görülen yeni bir mağaza ürünü yok. CraftPix Medieval GUI daha önceki raporda etiket listesinde 9,50 USD idi; bu turda ürün sayfası yeniden açılmadı, fiyat tekrar yazılmadı. Lisansı CC0 değildir.

| Kategori | Ad | Link | Tür | Biçim | Ölçü | Rig | Lisans | Uygunluk | Oyunda | Repoda |
|---|---|---|---|---|---|---|---|---|---|---|
| karakter | LPC medieval fantasy sprites | https://opengameart.org/content/lpc-medieval-fantasy-character-sprites | 2D | PNG | sayfa 200 | sprite | Sayfa CC BY-SA 3.0 veya GPL 3 diyor. CC0 sözcüğü de sayfada geçiyor; asıl şerit SA/GPL. Paylaşım aynı lisansla | UYARLANIRSA. Piksel, Avrupa zırhı. SA, oyun dosyasına gömülürse bulaşır | alınmasın | yok |
| köy | Low Poly Farm | https://sketchfab.com/3d-models/low-poly-farm-a4e01e15d0e8494e8b9055fc3809c1c5 | 3D | Sketchfab | 7,1K üçgen | hayır | CC BY. İçindeki rüzgar türbini modern | UYARLANIRSA. Türbin ve modern çit atılırsa bile üslup oyuncak | alınmasın | tarla var |
| katalog | Fab ana sayfa | https://www.fab.com/ | katalog | — | — | — | ana sayfa lisans cümlesi okunmadı | ürün doğrulanmadı | — | — |

## Bulunamadı

Bunlar arandı, doğrulanmış dosya çıkmadı.

- 14. yüzyıl Anadolu kerpiç evi, avlulu, hazır CC0 veya CC-BY paket.
- Hamam, tekke, mescit, hanın Osmanlı erken tipi. Yalnız genel bir low-poly cami (CC BY 4.0) var.
- Otağ veya kara çadırın dönemine uygun hazır modeli. Repoda Meshy `cadir` var.
- İpek, baharat, çömlek, akçe ve açlık için game-icons.net'te açılan kısa adlar 404.
- Dirhem fotoğrafı bu turda tek tek açılmadı.
- Eğri kılıç, yumurta kalkan ve lamellar için hazır oyun paketi.
- Rigli Osmanlı veya Moğol kıyafet paketi.
- Dönem VFX paketi.
- Smithsonian 3D, Europeana ve British Museum: bu makine 403. Tek nesne yok.
- Unity Asset Store ücretsiz dönem ürünü: ürün sayfası açılmadı.
- Fab'da tek tek ücretsiz dönem modeli: ana sayfa dışında doğrulama yok.
- Summer Engine'de "Handmade" damgalı ve Anadolu'ya oturan bir yapı, bu turda tek tek çıkmadı. Açılan el yapımı örnek anime kızdır. Açılan yapay zekâ örneği PSX raptor ve piksel atlıdır. Ortaçağ koleksiyonları katalogdur.

## Repoda olup yeniden aranmayacaklar

Meshy ve bağlı dosyalar: kapı, kapı içi, palisada, taş sur, gözetleme kulesi, ev, çadır, avcı çadırı, ahır, ağıl, ambar, değirmen, fırın, demirhane, hızarhane, şifahane, kervansaray, pazar tezgahı, kuyu, ağaç, kaya, kazık çit, kılıç, yay, kalkan, mızrak, balta, orak, kürek, çuval, araba, zar. Karakter yürüyüş klipleri ve hayvanlar manifestte. 2B'de Alegreya, Cinzel, `assets/ui/koy/*.svg`, `assets/ui/atmosfer/gece_kapisi/` (ekrana bağlı değil).

Yeni hazır asset, bu dosyaların yerine geçmeden önce ölçü ve üslup karşılaşılır. Aynı iş için ikinci kapı veya ikinci kılıç indirilmez.
