# Art Bible: (ad yok)

> **Status**: Draft
> **Owned By**: art-director
> **Last Updated**: 2026-10-04
> **Art Director Sign-Off (AD-ART-BIBLE)**: [Not yet reviewed]

`/art-bible` writes these nine sections in this order and replaces each
section's `[To be designed]` line as that section is approved. A section still
holding its placeholder is incomplete; a later run fills only those.

## 1. Visual Identity Statement

### Tek Satırlık Görsel Kural

**Kalın mürekkep, düz renk, gradyan yok; gece soğuktur ve tek sıcak kaynak meşaledir.**

Belirsiz bir görsel kararda bu satır şöyle okunur: daha sade, daha soğuk, daha düz olan seçenek kazanır. `#C4843A` yalnız sahnede bir meşale varsa ve yalnız onun ışığının değdiği yerde görünür. Bu satır kilitli konseptin (`design/gdd/kapi-konsept.md`) görsel kuralının ta kendisidir; yeni bir kural eklemez.

Paletin görevleri sabittir: gece `#0D0F14` zemin ve boşluktur; soğuk mavi `#4A6B8A` dünyanın kendisidir (gök, taş, uzak figürler); ahşap `#3D2E24` kapının ve insan elinden çıkmış her şeyin rengidir; meşale `#C4843A` sıcaklığın tek kaynağıdır. Figürler: yorgun yüz, yün kapüşon, keten tunik, deri kemer. Fotogerçekçilik, anime, modern kep, palto ve fermuar yok. Görselin içinde yazı ve rakam yok — yazı ve rakam koddadır. Reigns'in kart sadeliği ve Papers, Please'in yorgun kapısı yön verir, kopyalanmaz.

### İlke 1: Sıcaklık yalnız meşalenin hakkıdır
**Sütun: 3 — Yorgun gece**

*Tasarım testi:* Bir renk ya da ışık seçimi belirsizse soğuk olanı seçeriz; sıcak ton yalnız meşalenin doğrudan aydınlattığı yerde, sert kenarlı düz bir ışık lekesi olarak kullanılır — yumuşak geçiş ve yayılan hale yoktur.

Gecenin yorgunluğu, sıcaklığın az ve pahalı olmasından gelir. Meşale dışında sıcak bir ton girdiği an — turuncu bir gün batımı, altın bir arayüz parıltısı, sıcak tenli bir kalabalık — meşale artık tek sıcak kaynak değildir ve ton dağılır. Gradyan yasağı ışığın kendisini de bağlar: meşale ışığı, değdiği yüzeylerde `#C4843A` tonunda sert kenarlı, düz lekelerle çizilir; halo yoktur (kullanıcı onayı, 4 Ekim 2026).

### İlke 2: Yüz konuşur, görsel hüküm vermez
**Sütun: 2 — Konuşarak karar ver**

*Tasarım testi:* Bir karakterin görünüşü niyetini ya da kararın sonucunu ele verebilecekse, yorgun ve okunabilir ama hükümsüz olan yüzü seçeriz; "iyi/tehlikeli" renk kodu, kötü adam yüzü ya da güven veren parıltı yoktur.

Oyuncu gelenin kim olduğunu konuşarak öğrenir ve kimse seçeneğin sonucunu söylemez. Görsel bu sonucu söylerse sohbetin yerini alır. Yüz ve kıyafet kişinin *kim* olduğunu anlatır — yorgunluğunu, mesleğinin izini, yolun günlerini — *ne yapacağını* değil. Bu ilke, "kartta iyi ya da kötü etiketi yok" kuralının görsel karşılığıdır ve "görselde yazı ve rakam yok" kuralıyla birlikte çalışır.

### İlke 3: Köyde gördüğün her şey kapıda verdiğin bir karardır
**Sütun: 4 — Köy senin aynan**

*Tasarım testi:* Köyde bir görsel ayrıntı belirsizse, içeri alınmış birinin izini taşıyan ayrıntıyı seçeriz (bir Ahi esnafın aleti, bir çiftçinin tarlası, bir askerin silahı); kimseye bağlı olmayan genel süsü değil.

Köy oyuncunun kapıdaki kararlarından kurulur, bu yüzden köyde rastgele dekor olmaz; her görsel öğe geçmiş bir kabul kararına kadar izlenebilir olmalıdır. Yapı listesi kilitlidir — yalnız kervansaray ve pazar — bu yüzden köyün değişimi yeni bina türleriyle değil, insanlarla ve onların bıraktığı izlerle gösterilir. Köy oturup oyuncu ağa olduğunda bile palet kuralı geçerlidir: köy ancak daha çok meşale yanarak ısınır, paletin kendisi ısınmaz.

## 2. Mood & Atmosphere

Her durum Bölüm 1'deki tek kurala bağlıdır. Durumlar birbirinden **renk sıcaklığıyla değil**, dört şeyle ayrılır: (1) ekrandaki meşale lekesinin miktarı ve yeri, (2) gece `#0D0F14` ile soğuk mavi `#4A6B8A` arasındaki alan oranı, (3) kadrajın sıkılığı, (4) mürekkep çizgisinin yoğunluğu. Palet hiçbir durumda ısınmaz; bir durum "daha iyi" hissettirecekse bunu daha çok meşale ya da daha geniş kadraj taşır (İlke 3).

> **Teknik not (technical-artist):** Meşale ışığı `PointLight2D` + gradyan dokusuyla yapılmaz; elle çizilmiş, sert kenarlı, düz `#C4843A` poligon/sprite lekeleridir. `WorldEnvironment` glow kapalıdır — 4.6'daki glow yeniden yazımı ne olursa olsun yumuşak hale üretir ve İlke 1'i bozar.

### 2.1 Kapıda gece — varış ve sohbet
- **Duygu:** Yorgun dikkat; karşındaki bir yabancı ve sen onu okumaya çalışıyorsun.
- **Işık:** Tek meşale. Gelenin yüzünün yarısına ve kapının bir kanadına sert kenarlı `#C4843A` lekesi; gerisi gece. Yüzün ışık almayan yarısı soğuk mavi ya da düz mürekkep gölgesi.
- **Sıfatlar:** sessiz, yakın, yorgun, tetikte. **Enerji:** düşük, sabit.
- **Taşıyıcı öğe:** Yüze düşen yarım meşale lekesi. Konuşma ilerledikçe ışık değişmez (İlke 2); bilgiyi ışık değil sohbet açar. Kişinin yarısını görürsün, gerisini sorarak öğrenirsin (Sütun 2).

### 2.2 Karar anı
- **Duygu:** Ağırlık — ne seçersen seç bir bedel var (Sütun 1).
- **Işık:** Meşale lekesi aynı; kadraj hafifçe daralır, soğuk mavi alan küçülür, gece öne çıkar. Seçenekler tek tek belirir (kilit: "ekrana bir anda düşmez").
- **Sıfatlar:** dar, durgun, ağır, sessiz. **Enerji:** çok düşük, nefes tutulmuş.
- **Taşıyıcı öğe:** Daralan kadraj. Hiçbir seçenek renkle "doğru/yanlış" diye işaretlenmez; yanıp sönen düğme ya da renk vurgusu yok (Sütun 3).

### 2.3 Köy görünümü — her zaman meşaleler yandıktan sonra
*Kullanıcı kararı (4 Ekim 2026): seçenek B. Oyunda gün ışığı sahnesi yoktur.*
- **Duygu:** Kapıdan sonra nefes alma; kırılgan bir emek.
- **Işık:** Köy her zaman alacakaranlıkta ya da gecede, meşaleler yanmışken gösterilir. Kaç meşale yanıyorsa köy o kadar büyümüştür. Palet, gök ve zemin ısınmaz.
- **Sıfatlar:** dağınık, kırılgan, emek kokan, soğuk. **Enerji:** düşük–orta.
- **Taşıyıcı öğe:** Köydeki meşale lekelerinin sayısı — Sütun 3 ve Sütun 4 aynı görüntüde birleşir. Köyde gelişigüzel süs yoktur; her öğe bir kapı kararına bağlanır (İlke 3).
- **Risk:** Hiç gün ışığı olmaması monotonluk yaratabilir; çeşitlilik kadraj, meşale dizilimi ve kalabalık yoğunluğuyla sağlanır.

### 2.4 Barlar kırılmaya yaklaşırken — kriz
- **Duygu:** Kemiren endişe, panik değil (birinci perdede refleks yok).
- **Işık:** Palet kırmızıya kaymaz — paletimizde kırmızı yok ve olmayacak. Kriz şekille anlatılır: barlarda mürekkep çatlakları (Bölüm 3). Sahnedeki meşale lekesi küçülebilir; bu yalnız ruh halidir, sinyal değildir (Bölüm 4).
- **Sıfatlar:** gergin, çatlak, kurumuş, ince. **Enerji:** orta — gerilim artar, tempo artmaz.
- **Taşıyıcı öğe:** Bar çerçevesindeki çatlak mürekkep çizgileri.

### 2.5 Rüşvet
- **Duygu:** Sessiz utanç, el altından pazarlık.
- **Işık:** Meşale lekesi yalnız ellere ve keseye düşer; yüzler gölgede. Kimse kimsenin gözüne bakmaz.
- **Sıfatlar:** gizli, alçak, el altından, kısa. **Enerji:** çok düşük, kısa bir an.
- **Taşıyıcı öğe:** Deri kese (ahşap `#3D2E24` ailesi).
- **Renk kuralı:** Para ve sikke altın ya da sıcak tonla çizilmez; sikke soğuk kül tonunda, kese ahşap tonunda. Sikkenin üstünde rakam ya da yazı yoktur.

### 2.6 Perde geçişi — ağalık
- **Duygu:** Ağırlaşan sorumluluk; zafer değil, rol değişimi.
- **Işık:** Palet ısınmaz. Köyde biriken meşaleler ilk kez tek bir kadrajda birlikte görünür. Geçiş kesme ya da düz renk kararma ile yapılır — crossfade yok.
- **Sıfatlar:** ağır, geniş, sessiz, yeni. **Enerji:** düşük, törensiz.
- **Açık soru (kullanıcı: "sonra"):** İkinci perdede kapının köyün içinden ve daha küçük görünmesi önerildi; karar ertelendi.

### 2.7 İkinci perde — savunma
- **Duygu:** Kurduğun şeyi kaybetme korkusu.
- **Işık:** Köyün meşale lekeleri korunacak şey olarak öne çıkar. Tekfur'un güçleri soğuk mavi uzak siluetlerdir (palet rolü "uzak figürler") — kötü adam yüzü yok (İlke 2).
- **Sıfatlar:** sıkışmış, kalabalık, savunmacı, soğuk. **Enerji:** oyunun en yükseği, yine de gösterişli efekt yok (Sütun 3). Kilitteki demoda savunma ayrı harita değil, bar ve rüşvet üzerinden işler; görsel zenginlik bu ölçekte kalır.
- **Taşıyıcı öğe:** Soğuk mavi siluet kalabalığının köyün meşale lekelerine yaklaşması.
- **Açık soru (kullanıcı: "sonra karar verelim"):** Saldırıda ateş/yangın olacak mı? Olacaksa meşale ailesinin kuralına (aynı `#C4843A`, sert düz leke) uymalı.

### 2.8 Son(lar)
Sonların adı ve koşulu kilitte boştur; içerik uydurulmaz. Yalnız çerçeve: her son tek bir durağan kadrajdır; palet aynı kalır — son "mutlu" diye ısınmaz, "kötü" diye kararmaz. Sonlar renk koduyla değil kompozisyonla ayrılır (kapının durumu, meşale sayısı, kadraj genişliği). **Enerji:** durgun.

### 2.9 Menüler
- **Duygu:** Eşik — oyuna girmeden önceki gece.
- **Işık:** Gece zemin, tek meşale lekesi, kapı siluetinin bir parçası. Arayüz metni kül tonunda (Bölüm 4).
- **Sıfatlar:** boş, sakin, bekleyen. **Enerji:** en düşük.
- **Taşıyıcı öğe:** Tek meşale — oyunun görsel sözleşmesini ilk karede kurar.

**Ayırt edilebilirlik özeti:** Sohbet = yarım yüz ışığı · Karar = daralan kadraj · Köy = meşale sayısı · Kriz = çatlak · Rüşvet = yalnız eller · Ağalık = biriken meşaleler · Savunma = soğuk kalabalık · Son = durağan kompozisyon · Menü = tek meşale.

## 3. Shape Language

Ana fikir: **kalın mürekkep görsel hiyerarşinin kendisidir** — neyin önemli olduğunu renk değil çizgi kalınlığı söyler. Bu bir süs değil zorunluluktur: ahşap `#3D2E24` ile gece `#0D0F14` arasındaki kontrast yalnızca ~1.5:1'dir (Bölüm 4); kapı ve insan yapımı her şey kalın mürekkep konturu olmadan geceden ayrılamaz.

**Çizgi ağırlığı hiyerarşisi (1080p referans yüksekliğinde; Bölüm 8'de technical-artist doğrular):**
- Kahraman dış siluet: 6 px
- İç detay (kıvrım, yüz çizgisi): 3 px
- Destekleyici / uzak öğeler: 2 px ya da çizgisiz düz soğuk mavi leke

### 3.1 Karakter silüet felsefesi
- **Okunurluk testi:** Her karakter düz siyah dolguyla, ~64 px yükseklikte (kart / küçük resim boyutu) tanınabilmelidir. Tanıma yükünü renk değil siluet taşır — bu aynı zamanda renk körlüğü güvenliğidir (Bölüm 4.5).
- **Ortak gövde dili (yorgunluk):** Düşük omuzlar, öne eğik baş, kapüşonun üçgen tepesi, kalın kumaşın düz ve ağır düşüşü. Keskin aksiyon pozu ve kahramanca dik duruş yok (Sütun 3). Ortak şablon: yün kapüşon, keten tunik, deri kemer. Modern kep, palto, fermuar şablona hiç girmez.
- **Sınıf ayrımı eşyayla yapılır, ahlakla değil:**
  - **Asker:** Kemerden sarkan kın, omuzda mızrak ya da kalkan kenarı — dikey, uzun çizgi.
  - **Esnaf:** Sırtta denk ya da bohça, elde alet. **Ahi** esnafı belinde belirgin bir **kuşak (şed)** taşır (kullanıcı onayı, 4 Ekim 2026); kilitteki "deri kemer" ile çelişmez.
  - **Çiftçi:** Tahıl çuvalı, orak ya da çapa — yatay, yere yakın kütle.
- **Okunurluk düzeyi — ipucu (kullanıcı kararı: B):** Eşya sınıfa dair bir *ipucu* verir; "Kimsin, nesin" sohbeti onu doğrular. Siluet sınıfı kesin olarak söylemez, ama görsel de yalan söylemez. Böylece İlke 2 korunur ve sohbetin görevi kalır.
- **Özel karakterler (Miraen, Sorhan, Thessra ve adı konmamış 7–8 karakter):** İşleri serbest olduğu için sınıf eşyası yerine her birine tek bir **imza şekli** (alışılmadık bir kapüşon kesimi, tek bir taşınan nesne vb.) verilir. Geri dönen karakterler bununla tanınır. Kural: imza şekli kişinin kim olduğunu söyler, ne yapacağını asla söylemez (İlke 2).
- **Yasak:** Kötü adam yüzü, sivri şeytani kaşlar, "güvenilir" yuvarlak hatlar; renkle iyi/kötü kodlaması. Kartta iyi-kötü etiketi yok.

### 3.2 Çevre geometrisi
- **Kapı (kahraman yapı):** Oyunun en büyük dikdörtgeni. Kalın dikey tahtalar, ağır yatay kirişler, demir yok ya da çok az. Ahşap `#3D2E24`, en kalın mürekkep. Dikeyliği bariyer anlamı taşır (Sütun 1).
- **Dünya (taş, gök, uzak arazi):** Düzensiz, kırık, alçak yatay çizgiler; soğuk mavi düz lekeler. Uç bölge ıssızdır — kalabalık doku yok. Derinlik gradyanla değil, düz ton katmanlarıyla verilir (Bölüm 4).
- **Köy — yalnız iki yapı:**
  - **Kervansaray:** Kapalı kare avlu, tek kemerli taçkapı; Selçuklu kervansarayının sadeleştirilmiş hali (mukarnas yok ya da tek çizgiyle ima). Kapıyla akraba dikdörtgen, insan yapımı düzenin dili.
  - **Pazar:** Açık, alçak; direkler ve gerili örtüler.
  - Bunların dışında görünen her nesne (çadır, ocak, çit) içeri alınan birinin izidir — gelişigüzel dekor yok (İlke 3). Bina yerleştirme hissi veren ızgara düzeni yok; yerleşim organik ve sıkışıktır.
- **Özet:** İnsan yapımı = düz kenar ve dik açı, ahşap · Doğa = kırık ve düzensiz, soğuk mavi · Gece = şekilsiz boşluk.

### 3.3 Arayüz şekil grameri
- **Paneller:** Sert köşeli dikdörtgen, kalın mürekkep çerçeve, düz gece dolgu. Yuvarlak köşe ve cam efekti yok.
- **Sohbet seçenekleri:** Tek tek beliren, eşit boyda yatay şeritler. Hiçbir seçenek ötekinden büyük, parlak ya da renkli değildir — kimse sonucu söylemez (Sütun 2).
- **Karar düğmeleri:** Kabul, ret, rüşvet, kışla — aynı şekil, renk ve boyut. Farkı yalnız simge ve koddan gelen kelime yapar. Yeşil-kabul / kırmızı-ret yok. Düğmeler ileride değişecek; gramer düğme sayısından bağımsızdır.
- **Barlar:** Yatay, parçalı levhalar (tahta ya da taş blok). Bar zayıfladıkça parçalara mürekkep çatlakları eklenir; kırılma eşiğinde parça yarılır. Bilgi şekille de taşınır (Bölüm 4.5). Bar etiketleri onaylanmadığı için bar başına simge tanımlanmadı.
- **Rüşvet hakları:** Üç ayrı kese simgesi; kullanıldıkça boş kontura döner. Rakam sanatta değil, gerekirse kodda.

### 3.4 Kahraman ve destekleyici şekiller
- **Kahraman (en kalın çizgi, en yüksek kontrast):** Kapıdaki yüz, kapı, meşale ve meşale lekeleri.
- **Destekleyici (ince ya da çizgisiz, düşük kontrast):** Gök, sur, uzak figürler, Tekfur kalabalığı.
- **Kural:** Bir karede en fazla bir kahraman odak — sohbette yüz, köyde meşale kümesi, savunmada korunan köy. Göz önce sıcak lekeye, sonra kalın mürekkebe, en son soğuk alana gider.

## 4. Color System

### 4.1 Ana palet

| # | Ad | Hex | Durum | Rol |
|---|---|---|---|---|
| 1 | Gece | `#0D0F14` | Kilitli | Zemin, boşluk, gölge — ekranın en büyük alanı |
| 2 | Soğuk mavi | `#4A6B8A` | Kilitli | Dünya: gök, taş, uzak figürler, yüzlerin ışık almayan yanı |
| 3 | Ahşap | `#3D2E24` | Kilitli | Kapı ve insan yapımı her şey: kiriş, kese, kemer, kervansaray ve pazar ahşabı |
| 4 | Meşale | `#C4843A` | Kilitli | Tek sıcaklık: yalnız meşale ve onun yüzeylere düşen sert lekeleri |
| 5 | Mürekkep | `#06070A` | Onaylı (4 Ekim 2026) | Kontur çizgisi; geceden bir kademe koyu, mavi ve ahşap dolguların üstünde net okunur |
| 6 | Kül | `#B8C2CC` | Onaylı (4 Ekim 2026) | Arayüz metni, simge, sikke; soğuk kırık beyaz (krem/parşömen gibi sıcak bir beyaz bilinçli olarak seçilmedi — sıcaklık yalnız meşalenin) |
| 7 | Derin mavi | `#24364A` | Onaylı (4 Ekim 2026) | Uzak katman / ikinci derinlik basamağı — gradyan yerine düz ton basamağı |

### 4.2 Semantik renk kullanımı
- **Sıcaklık = meşale = insan varlığı ve emek.** Başka anlamı yoktur; "iyi", "güvenli" ya da "doğru seçenek" demek değildir.
- **Soğuk = dünya ve mesafe.** "Tehlike" ya da "düşman" demek değildir. Tekfur soğuk çizilir çünkü uzaktadır, kötü olduğu için değil (İlke 2).
- **Ahşap = insan yapımı.** Kapı, kese, köy yapıları.
- **Yasak semantikler:** Kırmızı = tehlike, yeşil = onay, altın = ödül. Bu renkler paletimizde yoktur ve eklenmeyecektir. Durum bilgisi şekil, simge, metin (kod) ve sesle verilir.

### 4.3 Bölge bazında sıcaklık kuralları
- **Kapı:** En fazla bir meşale kaynağı. Sıcak leke kapı kadrajının yaklaşık %10–15'ini geçmez (ayarlanabilir; Bölüm 8'de doğrulanır). Gece ağırlıkta, gelenin yüzü kahraman.
- **Köy:** Sıcaklık yalnız meşale sayısıyla artar; her meşale bir kapı kararının izidir (İlke 3). Palet, arka plan ve gök hiçbir zaman ısınmaz. Köy her zaman meşaleler yanmışken gösterilir (Bölüm 2.3).
- **Savunma:** Köyün meşaleleri korunacak sıcak çekirdek; saldıran taraf tamamen soğuk mavi ve derin mavi. Ateş/yangın kararı açık (Bölüm 2.7); olursa meşale rengi ve sert leke kuralını kullanır.

### 4.4 Arayüz paletinin dünyadan ayrılması
- Arayüz yalnız **gece** (panel dolgusu), **mürekkep** (çerçeve) ve **kül** (metin, simge) kullanır.
- **Meşale rengi arayüzde kullanılmaz.** Seçili seçenek bile turuncu ile vurgulanmaz — arayüzde sıcaklık "bu seçenek iyi" diye okunur ve İlke 2'yi bozar. Seçili / üzerine gelinen öğe kalınlaşan mürekkep çerçeveyle ya da çerçeve-metin yer değişimiyle (ters çevirme) gösterilir.
- Gerekçe: dünyadaki tek sıcak noktanın anlamını korumak.

### 4.5 Renk körlüğü ve okunurluk güvenliği
Gece `#0D0F14` üzerinde kontrast (WCAG göreli parlaklık, yaklaşık):
- Meşale ≈ 6.1:1 — iyi
- Soğuk mavi ≈ 3.4:1 — büyük öğeler için yeterli
- **Ahşap ≈ 1.5:1 — çok düşük.** Kapı ve ahşap nesneler mürekkep kontur ve meşale lekesi olmadan okunmaz; kalın mürekkep bu yüzden zorunludur.
- Kül ≈ 10.6:1 — metin için AAA

Ayrımlar:
- **Meşale ↔ soğuk mavi:** sarı-mavi ekseni; döteranopi ve protanopide korunur. Tritanopi bu ekseni zayıflatır, ama ~2:1 parlaklık farkı okumayı taşır.
- **Meşale ↔ ahşap:** aynı ton ailesi; ayrımı tamamen parlaklık yapar — renk körlüğünde de güvenli.

Yedek sinyal gerektiren bilgiler (renk asla tek başına sinyal değildir):
1. **Barlar / kırılmaya yaklaşma:** şekil (çatlak, yarılan parça) + ses ipucu + koddan metin etiketi.
2. **Rüşvet hakları:** dolu/boş kese simgesi; sayı gerekirse kodda.
3. **Seçili arayüz öğesi:** çerçeve kalınlığı ya da ters çevirme; renk değişimi yok.
4. **Krizde küçülen meşale lekesi:** yalnız ruh hali; bilgi taşımaz.
5. **Geri dönen karakterler:** renkle değil imza siluetiyle tanınır (Bölüm 3.1).

## 5. Character Design Direction

### 5.0 Ana fikir
**Figür yolun ve emeğin izini taşır; niyetin izini asla.** Herkes aynı yorgun gövde dilinden çıkar (3.1) ve üç katmanla ayrılır: (1) eşya — sınıfa dair *ipucu*; (2) imza şekli — *kim* olduğu; (3) yolun izi — ne kadar yol yürüdüğü. Hiçbir katman "iyi/tehlikeli" demez (İlke 2).

### 5.1 Oyuncu karakteri — kervan muhafızı
*Kullanıcı kararı (4 Ekim 2026): seçenek A.*
- **Yüzü hiç gösterilmez.** Oyuncunun aynası köydür (Sütun 4).
- **Kapıda:** Birinci şahıs bakış; kamera muhafızın gelene baktığı yerdedir. Gelenin yüzü kahramandır (3.4); oyuncunun yüzü kadraja girerse bir karede iki kahraman olur.
- **Yalnız eller:** Kapı kanadına dayanan el; rüşvette keseyi uzatan/alan el (2.5). Eller ahşap tonu yün yen ve deri bilekliktir; yüzük, süs, rütbe işareti yok.
- **Köy görünümünde oyuncu figürü yoktur** — köyde görülen herkes içeri alınmış biridir (İlke 3).
- **Ağalık (2.6):** Rol değişimi giysiyle değil kadrajla anlatılır; oyuncuya kaftan, kürk ya da rütbe giydirilmez.

### 5.2 Ortak figür şablonu — 13. yüzyıl Anadolu ucu
Kilitteki temel (yün kapüşon, keten tunik, deri kemer) her figürün başlangıcıdır. Dönem için akla yatkın eklemeler:
- **Baş:** yün kapüşon; keçe börk; sade sarık sargısı. Kadınlarda baş örtüsü ya da omza dökülen örtü.
- **Gövde:** keten tunik/gömlek; üstünde önü bindirmeli, bağcık ya da kuşakla kapanan yün kaftan; keçe kepenek (kolsuz kalın keçe pelerin). Dikişli yakalı palto yok.
- **Bel:** deri kemer; Ahi'de şed; yün kuşak sargısı.
- **Bacak/ayak:** bol yün şalvar ya da tozluk sargısı; çarık; atlı ve askerlerde yumuşak deri çizme; yoldakilerde ayağa bez sargı.
- **Kapanma:** bağcık, düğüm, kuşak, kemik ya da ahşap ilik. **Fermuar, sıra düğme, metal toka dizisi yok.**
- **Yasak:** modern kep, palto, fermuar (kilit); dönem dışı kavuk, fes, sıra düğmeli cepken; fantastik zırh, boynuzlu miğfer.
- **Kadın ve çocuk figürleri** kapıya gelenler arasında yer alır (kullanıcı kararı, 4 Ekim 2026); aynı giyim ve gövde kuralları geçerlidir. Çocuk figürleri de yorgun gövde dilini taşır; "masum" ya da "tehlikeli" diye işaretlenmez (İlke 2).
- **Renk — yalnız paletten** (kullanıcı kararı, 4 Ekim 2026): Ten için ayrı hex yoktur; yüzün ışık alan yarısı meşale lekesi, almayan yarısı soğuk mavi ya da mürekkep gölgesidir (2.1). Keten dahil tüm kumaş gece soğuk mavi ya da derin mavi okunur; deri ve ahşap eşya ahşap tonunda; kül arayüz ve sikkeye ayrılmıştır.

### 5.3 Bir bakışta ayırt etme — sınıf ipuçları
Okunurluk **ipucudur**, hüküm değil (3.1, karar B). Her ipucu siyah dolgu ~64 px testinde **siluetin dış hattını** değiştirmelidir; siluet içinde kalan bir iç çizgi ipucu sayılmaz.
- **Asker:** dikey, uzun çizgi — kemerden sarkan hafif eğri kılıç kını, omuzda mızrak ya da yuvarlak kalkan kenarı; okçu Türkmen için sadak ve yay. Zırh en fazla kapitone kaftan ya da tek miğfer çizgisi.
- **Esnaf:** sırtta denk ya da bohça (siluetin üstüne çıkan kütle), elde tek meslek aleti.
- **Ahi:** esnaf siluetine ek **şed**. Şed siyah dolguda görünmez, bu yüzden **düğümünün sarkan uçları siluetin dışına taşar**; Ahi'yi 64 px'te bu uçlar tanıtır. Şed deri kemerin üstüne bağlanır.
- **Çiftçi:** yatay, yere yakın kütle — tahıl çuvalı, orak ya da çapa; gövdenin altında taşınır.
- **İpucu yalan söylemez ama her şeyi söylemez:** bir asker bohça taşıyabilir; eşya yalnız "nesin?" sorusuna bir başlangıç verir.

### 5.4 Özel karakterler ve imza şekli
Miraen, Sorhan, Thessra ve adı konmamış 7–8 karakter için bu belge **görünüş tanımlamaz, yalnız kural koyar**; işleri serbesttir.
1. **Tek imza şekli** — siluetin dış hattını değiştiren tek şekil (kapüşon kesimi, taşınan nesne, omuz/kol çizgisi farkı). İkinci imza yok.
2. **İmza sınıf eşyası değildir** — tek başına asker/esnaf/çiftçi okutmaz.
3. **İmza niyet söylemez** — silah ucu, gizli bıçak, "şüpheli" sargı gibi tehdit ya da güven ima eden şekiller imza olamaz (İlke 2).
4. **Geri dönüşte imza sabit, durum değişken** — geçen zamanı yolun izi gösterir (yıpranmış kumaş, artan sargı, değişen yük).
5. **Her ölçekte görünür** — köy basamağında da (5.7) okunur; içeri alınan özel karakter köyde imzasıyla bulunur (6.4).
6. **Benzersiz** — iki imza siyah dolguda yan yana karıştırılmaz.

### 5.5 Üç topluluk
Ahlakla değil, **durum, ölçek ve uzaklıkla** ayrılırlar (İlke 2, 4.2).
- **Yoldakiler (Moğol baskınından kaçanlar, kapıda):** yükün altında; katmanlı sargı, bohça, ayakta bez, kumaş eteklerinde düz derin mavi toz lekeleri. Arkadaki bekleyen kuyruk düzensiz ritimlidir — eğik başlar, farklı yükseklikte yükler.
- **Köylüler (içeri alınanlar):** aynı insanlar, yükü bırakmış; elde iş aleti, bir meşale lekesinin yanında eğilmiş ya da bir şey taşırken. İlk gün kapıdan giren köyde de tanınır.
- **Tekfur'un adamları:** yalnız **uzak** — soğuk mavi/derin mavi düz siluet, iç detay ve yüz yok (2.7, 3.4). Onları siluet ritmi ayırır: düzenli aralık, tekrarlanan dikey mızrak uçları, ortak kalkan biçimi — "örgütlü ve uzak", "şeytani" değil.
- **Moğollar:** kilitte sahnede tanımlı değil — **açık soru** (aşağıda).

### 5.6 İfade ve poz
- **Taban ifade: yorgun ve tutuk** — ağır göz kapağı, göz altında tek mürekkep çizgisi, kapalı ya da hafif aralık ağız, öne eğik baş.
- **Dar aralık** — üç kaldıraç: göz kapağı açıklığı, ağız çizgisinin eğimi, baş açısı. Çığlık, gözyaşı damlası, abartılı kaş, anime işaretleri (ter damlası, kızarma) yok.
- **Önerilen poz seti (kart başına):** nötr-yorgun, dinleyen, kaçınan (bakış yanda), konuşan, sessiz. Sayı Bölüm 8'de bütçelenir.
- **İfade söylenene tepki verir, sonuca değil** — karar öncesinde hiçbir ifade "doğru seçenek" ipucu vermez (Sütun 2).
- **Gövde:** düşük omuzlar, ağırlık tek bacakta, eller yüke ya da kemere tutunmuş; kahramanca dik duruş, dinamik aksiyon açısı yok.
- **Işık ifadeyi değiştirmez** — sohbet boyunca meşale lekesi sabittir (2.1).

### 5.7 2D ayrıntı basamakları ("LOD")
Godot'da otomatik 2D LOD yoktur; **her basamak ayrı çizilir**. Kart çizimi köy boyutuna küçültülmez (6 px kontur 1 px'in altına düşer, mürekkep kimliği kaybolur). Kontur her basamakta ekran px'inde sabittir.

| Basamak | Ölçek (1080p, öneri) | Kontur | Korunan | Atılan |
|---|---|---|---|---|
| **Kart / sohbet** | Yüz-göğüs, ekran yüksekliğinin ~%55–70'i | Dış 6 px, iç 3 px | Yüz çizgileri, sınıf eşyası, imza şekli, şed düğümü, yol izi, birkaç kumaş kıvrımı | Kumaş dokusu, dikiş, süs |
| **Köy figürü** | Tam boy ~64–120 px (3.1'deki test) | Dış 2 px, iç yok | Siluet, sınıf eşyası, imza, şed uçları, meşaleye dönük yanda tek sert leke | Yüz (kapüşon şekli yeter), kıvrım, yol izi |
| **Uzak kalabalık** | <48 px | Yok | Yalnız dış siluet; düz soğuk mavi ya da derin mavi | Tüm iç ayrıntı (Tekfur adamları, kapı kuyruğu) |

**Kural:** Bir ayrıntı bulunduğu basamakta siyah dolgu testini değiştirmiyorsa o basamaktan atılır (istisna: kart basamağında yüz çizgileri).

### Açık sorular (Bölüm 5)
- **Karar sonrası yüz tepkisi:** Karardan sonra gelen kişinin tepkisi gösterilecek mi; gösterilirse sonucu söylemeyen, aynı dar aralıkta bir tepki mi?
- **Moğollar:** Kaçılan baskın görselde hiç gösterilecek mi (uzak siluet, ufukta duman), yoksa yalnız yoldakilerin izleriyle mi anlatılacak?

## 6. Environment Design Language

[To be designed] — architectural style and its tie to the world's culture,
texture philosophy (painted, PBR or stylised, and why), prop density rules per
area type, and environmental storytelling guidelines.

## 7. UI/HUD Visual Direction

[To be designed] — diegetic versus screen-space HUD, typography (personality,
weight, size hierarchy, minimum readable size), iconography style, UI animation
feel, and any art-direction versus readability conflict and how it was decided.

## 8. Asset Standards

[To be designed] — file formats, naming convention, texture resolution tiers,
LOD levels, export settings, and the engine's hard limits (poly budgets per
asset category, texture memory, material slots). Where an art preference and a
technical limit disagree, record both and the trade-off chosen.

## 9. Reference Direction

[To be designed] — 3–5 references (games, films, art styles or artists). For
each: the specific element to take from it, and what to avoid so the result
does not read as a copy.
