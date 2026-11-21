# UI kit taraması

20 Kasım 2026. Cursor. Yalnız araştırma. Kod, satın alma, zip indirme ve repoya asset yok. Fiyatlar bu tarihte açık sayfadan okundu; mağaza fiyatı değişebilir. Önizlemeler rapor için `/opt/cursor/artifacts/ui_aday_<n>.png` altına kondu, depoya girmedi.

Amaç: Kapı Muhafızı arayüzünü düz site kabuğundan çıkarıp Manor Lords, Kingdom Come, Bannerlord, Crusader Kings III, Banished ve Pentiment çizgisinde, 14. yüzyıl Osmanlı uç beyliğine oturan bir kabuk yapmak. Çini, Parşömen ve Ocak düz renk şablonları seçilmedi. Kenney çizgi film kabuğu olarak duruyor.

## Bugün repoda ne var?

`docs/arayuz/ARAYUZ_DENETIMI.md` aynı gün yazıldı. Ana menü Ahmet'in beğendiği satır çiziminde kaldı. Oyun içi panel, düğme ve yükleme örtüsü `src/arayuz/gece_kapisi_cerceve.gd` ile `assets/ui/atmosfer/gece_kapisi/` PNG'lerine bağlandı. Düğme dilim payı 64 px kısa düğmeyi ezdiği için 28 px'e indirildi. Panel payı 112 px. Denetim, yükleme, köy paneli, kapı sorgu çerçevesi, diyalog balonu, ayarlar ve heybenin hâlâ zayıf olduğunu yazar.

Bu taramada `dialogue_panel.png` ve `button_normal.png` açıldı: isli ahşap, ince demir köşe, düz kontur. `portrait_frame.png` köşelerinde kelt düğümü var. Bu, 13.–14. yüzyıl Anadolu kapısının rumi ve tombak dili değildir. Set repoda durabilir, çünkü Ahmet'in üretimidir. Hazır kitlerin çoğu bu dosyadan daha «oyun vitrini» durur; hiçbiri uç beyliği süsü taşımaz.

`docs/arayuz/NANO_BANANA_PROMPTLARI.md` opak ekran zeminleri içindir (yükleme, ayarlar, heybe). Çerçeve ve düğme o listede yoktur. Çerçeve promptları `docs/arayuz/ARAYUZ_ARASTIRMA_RAPORU.md` sonundadır: köşesi süssüz 9-dilim, zemin `#00FF00`, gotik kemer ve haç yok.

## Lisans duvarı

Oyun deposu herkese açıktır. Satın alınan ham PNG ve PSD bu depoya konamaz.

| Kaynak | Ticari oyunda | Godot | Açık repoda ham dosya |
|---|---|---|---|
| Unity Asset Store, standart EULA, Restricted değil | Evet. Varlık, oyunun gömülü parçası olur; oyunun kendisi varlıktan ibaret olamaz | EULA metni motor adı koymaz. 1 Ocak 2023 metninde lisans, elektronik uygulama içine gömmeyi yazar | Hayır. Varlık, ürünün içine gömülü olmadan dağıtılamaz |
| Fab standart lisans | Evet, proje içinde | Metin motor adı koymaz. İçerik başka yazılımla birleştirilebilir | Hayır. Ortaklara yalnız özel depoda verilir. Herkese açık dağıtım yok. GPL ve CC-BY-SA ile içeriği o lisansın altına sokmak da yasak |
| GameDev Market | Evet, sınırsız sayıda medya ürünü | Motor şartı bu ürün sayfalarında yok | Hayır. Ürün dışında paylaşmak ve yeniden dağıtmak yasak |
| CraftPix ücretli | Evet, telifsiz, sınırsız proje | Sayfa motor serbestliği yazar | Hayır. Kaynak dosya dağıtımı yasak (`craftpix.net/file-licenses/`) |
| CC0 / CC-BY | Evet | Evet | Evet. CC-BY atıf ister |
| SIL OFL yazı tipi | Evet | Evet | Evet. Türev de OFL kalır |
| Ahmet'in Nano Banana çıktısı | Proje kendi üretimini depoya koyuyor | Evet | Bu depodaki gece kapısı dosyaları bu yolla duruyor. Google'ın güncel ticaret şartı bu turda madde madde yeniden okunmadı |

Unity listelerinde bu turda Restricted rozeti görünmedi. Rozet sonradan çıkarsa o ürünün kendi şartı geçerlidir.

## Puan

Dönem puanı 1–5. 5, 14. yüzyıl Anadolu kapısı: isli ceviz, tombak, koyu mürekkep, rumi, haçsız ve çizgi filmsiz. 3, ciddi ortaçağ malzemesi olup Avrupa arması, İskandinav maskesi veya büyü küresi taşıyan set. 1, çizgi film, anime veya düz site şeridi.

Üretken yapay zeka sayfada yazılmışsa aday tablosuna girmedi.

## Adaylar

| # | Ad | Sayfa | Fiyat | Lisans ve depo | İçerik | AI | Puan |
|---|---|---|---|---|---|---|---|
| 1 | Medieval Kingdom UI, PONETI | https://assetstore.unity.com/packages/2d/gui/medieval-kingdom-ui-180688 | 99,99 USD | Unity standart EULA, Single Entity. Godot'a gömülebilir. Açık repoya girmez | İki kabuk (Classic, White gold). 98 arayüz ikonu, 17 ekipman ikonu, 33 UI PSD, 32 bar PSD, 5 karo zemin 4096, dünya haritası PNG 15360×8640, portre ve karakter resimleri. Vitrindeki 6000 ikon pakete dahil değil | Sayfada üretken AI ibaresi yok | 3 |
| 2 | Dark Fantasy GUI / UI Kit, HONETi | https://assetstore.unity.com/packages/2d/gui/dark-fantasy-gui-ui-kit-68828 | 14,99 USD | Unity standart EULA. Açık repoya girmez | Görev, yetenek, envanter ve ayar pencereleri; iki renk düğme, radyo, onay, kaydırma, yuva, deneyim çubuğu, dört imleç, can ve mana küreleri. Vitrin görseli 516×389 | Sayfada yok | 3 |
| 3 | Fantasy GUI Middle Ages, HONETi | https://assetstore.unity.com/packages/2d/gui/fantasy-gui-ui-middle-ages-ui-kit-170-png-and-psd-ai-sources-31027 | 19,99 USD | Unity standart EULA. Açık repoya girmez | 170 PNG. Menü, metin, görev, ekipman, envanter, istatistik pencereleri. 30 ikon. PSD ve Adobe Illustrator kaynağı. Addaki «ai» Illustrator'dur | Sayfada üretken AI ibaresi yok | 3 |
| 4 | 4k GUI, stone and wood, HONETi | https://assetstore.unity.com/packages/2d/gui/icons/4k-gui-ui-kit-stone-and-wood-over-400-png-prefabs-121412 | 49,99 USD | Unity standart EULA. Açık repoya girmez | 400'den fazla PNG, prefab, 117 ikon, HUD, imleç, can ve mana küreleri, ses. Vitrinde boynuzlu kafatası | Sayfada yok | 2 |
| 5 | Viking RPG UI, Lid Games | https://www.fab.com/listings/74f1f296-f0d3-4771-8fc6-7646aea804d1 | 14,99 USD, ilk okuma | Fab standart. Unreal ve Unity paketi. 2B doku Godot'ta kullanılabilir. Açık repoya girmez; özel ortak deposu serbest | Sayfa «hand-painted» der. Kodlanmış arayüz değil. Vitrin: ahşap panel, parşömen görev yaprağı, balta ve maske | İkinci okumada «Generated with AI: Yes» görünmedi. 1 Aralık 2026'ya kadar süren bir indirim şeridi vardı; indirimli etiket bu ürüne ayrıca düşmedi | 3 |
| 6 | HUD and GUI Medieval Art Bundle | https://www.fab.com/listings/464b18b0-121d-4c50-bde3-86f556a309ef | 31,49 USD, ilk okuma | Fab standart. Açık repoya girmez | 600'den fazla parça, altı renk. 132 yuvarlak ve 132 kare ikonlu düğme, 42 pencere, 44 süs, 200'den fazla ikon, büyü ikonları, arayüz ve büyü sesi. Önerilen yazı tipleri pakette yok | Bu okumada «Generated with AI: Yes» ibaresi görünmedi | 2 |
| 7 | Medieval GUI, CraftPix | https://craftpix.net/product/medieval-gui/ | 9,50 USD | CraftPix: ticari, sınırsız proje, kaynak dağıtımı yok | PSD ve PNG. Giriş, kayıt, görev, karakter, yetenek, envanter, sohbet, harita, yükleme. Üç renk: kırmızı, yeşil, mor. Yazı ayrı katmanda | Sayfada yok | 3 |
| 8 | Gothic Medieval UI, GabrielaTot | https://www.gamedevmarket.net/asset/gothic-medieval-ui | 6 USD | GameDev Market. Medya ürününde serbest. Ham dosya dağıtımı yok | Süslü çerçeve, 60'tan fazla ikon (siyah ve beyaz), beş renk düğme, can çubuğu, kaydırma. PNG ve Adobe Illustrator. Önerilen Old London yazı tipi pakette yok | Sayfada yok | 2 |
| 9 | RPG GUI construction kit v1.0, Lamoot | https://opengameart.org/content/rpg-gui-construction-kit-v10 | 0 | CC-BY 3.0. Ticari serbest, atıf zorunlu. Açık repoya girebilir | Parça parça pencere, düğme ve kaydırma. Hazır ekran yok. GIMP kaynağı var. Yazar, bir doku ve bir kamu malı ahşap fotoğrafı kullandığını yazar. Vitrin 400×319 | Sayfada yok. 2010 tarihli elle iş | 3 |
| 10 | Nano Banana çerçeve yolu | Üretim Ahmet'te. Mevcut teslim `assets/ui/atmosfer/gece_kapisi/`. Çerçeve cümleleri `ARAYUZ_ARASTIRMA_RAPORU.md`, zemin cümleleri `NANO_BANANA_PROMPTLARI.md` | Mağaza fiyatı yok | Dosya proje üretimi olarak depoya konabiliyor. Bu, gece kapısı setinin durduğu yoldur | İstenen: 9-dilim diyalog şeridi, seçenek satırı, portre çerçevesi, panel, mühür, ayrı rumi köşe. Eldeki diyalog paneli ahşap ve demir. Portre köşesi kelt düğümü | Bu yolun kendisi üretken görüntüdür. Kural, mağaza sayfasında AI yazan hazır kiti eler. Ahmet'in kendi üretimi o elemenin dışında, çünkü başka kit yok | Yol 4. Eldeki panel 3 |

Önizleme: 1 `ui_aday_1.png`, 2 `ui_aday_2.png`, 3 `ui_aday_3.png`, 4 `ui_aday_4.png`, 5 `ui_aday_5.png`, 6 `ui_aday_6.png`, 7 `ui_aday_7.png`, 8 `ui_aday_8.png`, 9 `ui_aday_9.png`, 10 eldeki diyalog paneli `ui_aday_10.png`. 2, 3 ve 9 mağaza vitrininin kendi küçük ölçüsüdür; büyütülmedi.

### Kısa gerekçe

1. Vitrin, CK3 ve strateji oyunundaki koyu levha, parşömen ayar sayfası ve portre çerçevesine en çok yaklaşan settir. Haç, Avrupa arması, şövalye ve kraliçe resmi uç beyliğine girmez. PSD olduğu için yazı ve haç ayıklanabilir. Vitrinde «SETTINGS» ve «New Game» boyalı duruyor; zip açılmadan her PNG'de yazı olduğu doğrulanmadı.
2. Koyu altın pencere, düz mor sitenin üstündedir. Can küresi ve yetenek tablosu Avrupa fantezi RPG'sidir. 14,99 USD'lik en ucuz ciddi pencere budur. Vitrin küçüktür; paket içi çözünürlük zip açılmadan ölçülmedi.
3. Aynı yayıncının daha düz, taş düğmeli seti. PSD ve Illustrator kaynağı, haç ve yazı ayıklamayı kolaylaştırır. Üslup 2 numaradan daha soluk.
4. Taş ve ahşap malzeme var. Boynuzlu kafatası, kılıç ikonu ve mana küresi bu oyunun gece kapısına ağırlık bindirir. 49,99 USD, ayıklama yüküne göre yüksek.
5. Ahşap ve yıpranmış kâğıt, gece kapısı malzemesine en yakın hazır deridir. Balta, sakallı maske ve «MARINE ADVENTURE» yazısı İskandinav deniz oyunudur. Sayfa 9-dilim ölçüsü vermez.
6. Parça sayısı yüksektir. Ejderha, Kelt düğümü ve büyü ikonu bu kabuğun malzemesi değildir. Sesler aynı lisansın içindedir; ayrıca bir ses paketi sayılmadı.
7. Boyalı ahşap ve parşömen var. Ekranlar sabit giriş kompozisyonudur: kale dişi, kılıç demeti, kırmızı kurdele. 9-dilim HUD değildir. PSD'de yazı ayrı katmanda olduğu için login yazısı silinebilir. Yeşil ve mor varyant bu oyuna girmez.
8. Vektör olduğu için keskin kalır. Gül pencere, kurukafa ve blackletter gotik katedraldir. Pentiment'in mürekkebi değildir; o oyun bir yazıcının kitabıdır.
9. Yıpranmış pirinç ve kâğıt, düz siteden uzaktır. Çözünürlük düşüktür. `docs/UI_ADAYLARI.md` bunu ana menüde denemişti. Denetim, beş hazır adayın menüyü örtmesini bu turda kapattı. Bütün oyuna yayılırsa gece kapısı setinin gerisine düşer. Açık depoya girebilen tek tam kit budur.
10. Mağazada Anadolu süsü yok. İstenen malzeme promptla tarif edilebiliyor. Eldeki teslim, kelt köşe ve tutarsız düğme ailesi yüzünden henüz 5 değil. Kalfa notu duruyor: model alfa ve kesin 9-dilim vermez; maske ve ölçü sonra elle yapılır.

## Elenenler

Sayfa açıldı ve aday tablosuna girmedi.

| Ad | Sayfa | Neden |
|---|---|---|
| GUI Pro — Fantasy RPG, LAYERLAB, 39,99 USD | https://assetstore.unity.com/packages/2d/gui/gui-pro-fantasy-rpg-170168 | 1200'den fazla PNG, 1920×1080 vitrin. Mobil çizgi film: mücevher, sandık, «TAP TO START». Sayfadaki AI cümlesi alıcının modeli eğitmesini yasaklar; paketin üretken görüntü olduğu yazılmaz |
| Medieval Wooden GUI, guiworld, 13 USD | https://assetstore.unity.com/packages/2d/gui/icons/medieval-wooden-gui-174623 | 10 PSD, 1920×1080. Mavi tente, yeşil «GET IT!» düğmesi, çizgi film dükkân |
| Medieval GUI Standard Pack, Cryptogene, 15,95 USD | https://assetstore.unity.com/packages/2d/gui/medieval-gui-standard-pack-136218 | Comic ve Paper Flat dahil on iki bin parça. Vitrin yıldızlı kilit ızgarası |
| Medieval GUI — Vector + Raster, 19 USD | https://www.gamedevmarket.net/asset/medieval-gui-vector-raster-graphics | Aynı çizgi film ızgarası. SVG var, üslup uygun değil |
| Parchment Game user interface kit, 17 USD | https://www.gamedevmarket.net/asset/parchment-game-user-interface-kit | Düz şerit, pembe kurdele, mavi düğme. Reddedilen Parşömen şablonunun hazır hali |
| Royal classic medieval GUI, Meenu Chan, 30 USD | https://assetstore.unity.com/packages/2d/gui/royal-classic-medieval-gui-asset-pack-273376 | Sayfa «elle yapıldı, AI aracı yok» der. 8 PSD, 32 PNG. Gümüş anime çerçeve ve mor saçlı portre |
| Game UI Pack — Medieval Theme, 406pixel, 7,99 USD | https://assetstore.unity.com/packages/2d/gui/game-ui-pack-medieval-theme-206720 | Sayfa piksel sanat yazar. 75 parça |
| Medieval Fantasy UI, ProfSchizoid | https://www.fab.com/listings/7b4a8db4-1427-464c-8c4a-6bfae31e632e | Sayfa: Generated with AI: Yes. Fiyat aralığı 5,99–14,99 USD göründü. Elendi |
| Gothic & Gold 4K, Vill8tion | https://vill8tion.itch.io/medieval-fantasy-rpg-ui-kit-gothic-gold-4k | itch etiketi AI Assisted. PNG zemini siyah, gerçek alfa değil. Fiyat 3,99 USD göründü |
| Fantasy RPG UI Kit, StationSupply | https://stationsupply.itch.io/fantasy-rpg-ui-kit | Premium kademe sayfada AI görüntü diye yazar. Standard 5 USD, Premium 12 USD. İkisi de elendi |
| Fantasy RPG Game UI Kit, Tavmir | https://tavmir.itch.io/fantasy-rpg-game-ui-kit | Sayfa: AI-assisted tools. 4,99 USD. Arama orabon adresinden bu sayfaya düştü |
| Oakhold, Ters.co | https://tersco.itch.io/oakhold-medieval-fantasy-rpg-ui-kit | Piksel. Sayfa üretken görüntü olmadığını, çizim betiğinin AI asistanıyla yazıldığını söyler. Tam kit 4,99 USD. Üslup kale pikselidir |
| Pixel UI Free | https://godotengine.org/asset-library/asset/5494 | Godot teması hazır, 16 px piksel. Godot Asset Library aramasında boyalı ortaçağ teması çıkmadı |
| Humble GUI Galore | https://www.humblebundle.com/software/gui-galore-gamedev-market-software | 404 |
| Humble Game Dev GUI Goodness | https://www.humblebundle.com/software/game-dev-gui-goodness-software | 404 |
| Complete RPG Creator Bundle | https://www.humblebundle.com/software/complete-rpg-creator-bundle-2d-gui-audio-assets-software | Sayfa 200 döndü. Arama kartı kampanyayı 15 Ağustos–19 Eylül 2026 diye kapatır. İçerik listesi bu turda açılmadı |

Osmanlı, Selçuklu, Pers veya İslami geometriyle kurulmuş bir 9-dilim arayüz kiti bu taramada çıkmadı. ArtStation kartlarında İslami desen ve Mağribi mimari modelleri göründü; onlar arayüz kiti değildir, sayfaları bu turda ürün kaydı olarak açılmadı.

GameDev Market gotik sayfası tarayıcıda okundu. Düz HTTP isteği bu makineden 403 aldı. Adres 404 değildir.

## Yazı tipleri

Gövde ve başlık depoda. `assets/font/Alegreya-wght.ttf`, yatık Alegreya ve `Cinzel-wght.ttf` cmap'i ğ ş ı İ ç ö ü için 12/12. İkisi de SIL OFL. Açık repoda durabilirler. Cinzel Roma yazıtıdır; Selçuklu değildir. Başlık için okunaklıdır. Alegreya gövde metnidir.

Bu turda `/tmp` altında ölçülüp depoya konmayan OFL aileler, aynı on iki harf için cmap'te tam çıktı:

| Aile | Sayfa | Ne işe yarar |
|---|---|---|
| EB Garamond | https://fonts.google.com/specimen/EB+Garamond | Defter ve divan. 16. yüzyıl Garamond canlandırması. 14. yüzyıldan sonra, yine de ciddi ve Türkçe |
| Cardo | https://fonts.google.com/specimen/Cardo | Bilimsel metin. Oyun başlığından çok tutanak |
| Spectral | https://fonts.google.com/specimen/Spectral | Çağdaş edebi serif. Dönem puanı Alegreya ile aynı çizgide |
| Crimson Pro | https://fonts.google.com/specimen/Crimson+Pro | Okunaklı gövde. Yeni bir dönem yüzü eklemez |
| Almendra | https://fonts.google.com/specimen/Almendra | Daha süslü. Küçük puntoda ayrıca bakılır. cmap tam, çizim kalitesi tek tek harfte ölçülmedi |
| IM Fell English | https://fonts.google.com/specimen/IM+Fell+English | 17. yüzyıl İngiliz tipi. cmap tam. Uç beyliği yazısı değildir; gövdeye konursa oyun Avrupa matbaasına kayar |

MedievalSharp ve Cormorant Garamond dosya adresleri bu turda 404 verdi. Glif iddiası yok. Blackletter denenmedi; Türkçe gövde için uygun aday sayılmadı.

Yeni yazı tipi gerekmez. Eksik olan çerçevedir. Defter sayfası ayrıca istenirse EB Garamond, OFL olduğu için depoya eklenebilir. Bu turda eklenmedi.

## İlk üç

### Ücretsiz: Lamoot

Açık depoya girebilen tek hazır kit. Atıf: «RPG GUI construction kit v1.0 — Lamoot, CC-BY 3.0.» Kalite tavanı düşük. Gece kapısı setinin yerine geçmez. Yeni ekran için parça lazımsa ve satın alma yoksa bu dosya durur. Ana kabuk önerisi değildir.

14,99 USD'lik Dark Fantasy ve Viking, ucuz ücretli komşulardır. İkisi de açık repoya girmez. Viking'in ahşabı malzemeye daha yakındır. Dark Fantasy'nin penceresi daha «büyük RPG» durur. İkisi de Avrupa fantezisidir.

### En kaliteli hazır: Medieval Kingdom UI

99,99 USD. Vitrin, bu taramadaki en ciddi boyalı kabuktur. Dönem puanı 3'tür: haç ve arma ayıklanmadan bağlanmaz. PSD bu ayıklamayı mümkün kılar. Dosyalar gitignore veya depo dışı bir pakette kalır. CI ve başka ajan o PNG'leri görmez. Bu, projenin açık depo düzeniyle çatışır.

### Nano Banana

Dönemi tutan ve depoya girebilen yol budur. Yeni üretim, eldeki setin üstüne kelt köşe eklemez. Araştırma raporundaki altı parça yeter: diyalog şeridi, seçenek satırı, portre çerçevesi, panel, mühür, ayrı rumi köşe. Zemin promptları (`NANO_BANANA_PROMPTLARI.md`) opak sahnedir; çerçeve işi onların yerine geçmez. Alfa ve 9-dilim modelden beklenmez. Magenta veya `#00FF00` zemin maskelenir, dilim eldeki `GeceKapisiCerceve` tablosuna yazılır. Hover, basılı ve kapalı haller yeni çizim değildir; kabul edilmiş düğmenin parlaklık türevleri zaten `GECE_KAPISI_ALFA_KABUL.md` içinde bu yolla yapılmıştır.

## Entegrasyon

Kod tarafı her hazır kitte aynıdır ve incedir. `GeceKapisiCerceve.kutu()` bir PNG yolu ve beş sayı (sol, üst, sağ, alt, içerik payı) ister. Unity prefab'ı ve Fab widget'ı kullanılmaz. Yeni doku, düğme yüksekliğinde köşeyi ezmeyecek payla ölçülür. 64 px payın 48 px düğmede ne yaptığı denetimde yazılıdır.

Asıl iş lisansa ve ayıklamaya göredir.

| Aday | İş | Depo |
|---|---|---|
| 1 Medieval Kingdom | PSD'den haç, arma ve boyalı İngilizce ayıklanır. Seçilen panel ve düğme ölçülür. Portre ve kral resimleri alınmaz. Tema yolu depo dışı pakete bakar | Ham dosya git'e girmez |
| 2 Dark Fantasy | Prefab atılır. Küre ve yetenek tablosu elenir. Kalan pencere ölçülür. Vitrin 516 px; paket çözünürlüğü ayrıca ölçülür | Ham dosya git'e girmez |
| 3 Middle Ages | PSD en kullanışlı parçadır. Düz taş düğme, gece kapısı ahşabının yerine ancak ayar ekranında durur | Ham dosya git'e girmez |
| 4 Taş ve ahşap 4k | 400 PNG elenir. Kafatası ve küre kalmaz. Kalan azsa satın alma boşa gider | Ham dosya git'e girmez |
| 5 Viking | Ahşap panel ve kâğıt alınır. Balta, maske ve deniz yazısı atılır. Dilim sayfada yok, elle ölçülür | Ham dosya git'e girmez. Özel ortak deposu Fab metnine uyar |
| 6 HUD demeti | Ejderha, Kelt düğümü ve büyü ikonu atılır. Kalan çerçeve azdır. Ses ayrıca dinlenir | Ham dosya git'e girmez |
| 7 CraftPix | PSD'den yazı katmanı silinir. Pencere sabit kompozisyondur; 9-dilim şerit olmaz. Kırmızı ahşap varyantı dışında renk alınmaz | Ham dosya git'e girmez |
| 8 Gotik vektör | SVG keskin kalır. Gül ve kurukafa bu oyuna girmez. İş küçük, üslup uymaz | Ham dosya git'e girmez |
| 9 Lamoot | Atıfla `assets/` altına konabilir. Ölçü küçüktür. Mevcut gece kapısı temasının yerine geçmez | Açık repo serbest |
| 10 Nano Banana | Altı parça üretilir, maskelenir, ölçülür, `DILIM` tablosuna yazılır. `tema.gd` yeniden yazılmaz. Portre çerçevesi kelt düğümden çıkar | Depoya girer |

## Sonuç

Hazır kit, düz siteyi boyalı bir oyun penceresine çevirir. Hiçbiri 14. yüzyıl uç beyliği değildir. En dolu vitrin Medieval Kingdom UI'dır ve açık depoya giremez. Açık depoya girebilen hazır kit Lamoot'tur ve çözünürlüğü düşüktür. Dönem ve depo birlikte isteniyorsa çerçeve Ahmet'in Nano Banana üretiminden gelir; eldeki gece kapısı paneli ahşap ve demir için durur, portre köşesi yeniden üretilir.

Satın alma, zip ve kod bu turda yok. Asset gerekmedi.
