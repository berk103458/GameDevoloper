# Art Bible: (ad yok)

> **Status**: Draft
> **Owned By**: art-director
> **Last Updated**: 2026-10-04
> **Art Director Sign-Off (AD-ART-BIBLE)**: SKIPPED 2026-10-04 — lean mode

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
- **Meşale rengi arayüzde kullanılmaz.** Seçili seçenek bile turuncu ile vurgulanmaz — arayüzde sıcaklık "bu seçenek iyi" diye okunur ve İlke 2'yi bozar. Seçili / üzerine gelinen öğe **kül çerçeve ve ters çevirme** ile gösterilir (ayrıntı 7.3).
- *Düzeltme (4 Ekim 2026):* İlk taslaktaki "kalınlaşan mürekkep çerçeve" seçeneği kaldırıldı — mürekkep `#06070A` ile gece `#0D0F14` arasındaki kontrast ~1.06:1, yani gece panelinde görünmez. Bu nedenle kül, arayüzde metin ve simgenin yanında **durum çerçevesi** olarak da kullanılır (kullanıcı kararı).
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

### 6.0 Ana fikir
**Ortam sahne değil, kayıttır.** Kapı dış dünyayı tutar; köy kapıda verilen kararları kayda geçirir. Yapı listesi kilitlidir: kapı ve sur, kervansaray, pazar. Bunların dışında görünen her şey içeri alınmış birinin izidir (İlke 3). Doğa ıssız, soğuk ve az çizgilidir; insan izi düz kenarlı, ahşap ve meşalelidir (3.2).

### 6.1 Mimari — Selçuklu dönemi uç
**Anadolu Selçuklu yapısının ıssız bir uçta, az elle ve aceleyle yapılmış hâli.** Saray ya da sultan hanı görkemi yok; ölçek küçük, işçilik kaba, süs tek çizgi.
- **Kapı:** Oyunun en büyük dikdörtgeni ve kahraman yapısı (3.2). Kalın dikey tahtalar, ağır yatay kirişler, çok az demir (tek menteşe ya da sürgü). Ahşap tonu, en kalın mürekkep. Tahtaların hafif eşitsiz boyu elle ve aceleyle yapıldığını söyler.
- **Sur (palisat):** Yan yana çakılmış ahşap kazıklar; uçları kabaca sivriltilmiş, aralarında eşitsiz boşluklar. Destekleyici öğe: 2 px ya da daha ince kontur, kapıdan alçak. Taş sur ya da burç yok.
- **Kervansaray:** Kapalı kare avlu, tek **sivri kemerli** taçkapı (Selçuklu imzası). Duvarlar moloz ya da kaba kesme taş (soğuk mavi düz leke + birkaç mürekkep derz çizgisi); kapı kanatları ve saçak kirişleri ahşap. Mukarnas yok ya da tek çizgiyle ima. **Kitabe bölümü boş bir çerçevedir — içinde harf ya da rakam yok.**
- **Pazar:** Açık, alçak; ahşap direkler, gerili keten/keçe örtüler (gece soğuk mavi). Tabela, yazılı levha, sayılı ölçek yok.
- **Barınma izleri (bina değil):** keçe çadır, kara çadır, sundurma, ocak taşı, çit — yapı türü değil insan izi (3.2). Izgara düzeni yok; yerleşim organik ve sıkışık, meşalelerin çevresinde toplanır.

### 6.2 Doku felsefesi — düz renk ve mürekkep
**Doku tonla değil çizgiyle verilir.** Yüzeyin ahşap, taş ya da keçe olduğunu birkaç mürekkep çizgisi söyler; renk geçişi, gren ya da gürültü söylemez.

Boyalı ve PBR doku neden yok:
1. **İlke 1 ve gradyan yasağı** — boyalı doku ton değişimiyle, PBR normal haritası ve ışık hesabıyla çalışır; ikisi de yumuşak geçiş üretir ve sert kenarlı meşale lekesini bulandırır.
2. **Okunurluk** — ahşabın gece üzerindeki kontrastı ~1.5:1 (4.5); değer gürültüsü bu kontrastı da yer, kapı geceye karışır.
3. **Palet disiplini** — 7 renk ve düz ton basamakları (4.1); boyalı doku paletin dışında ara tonlar üretir.
4. **Ölçek** — doku, 5.7'deki basamaklar arasında titreşir ve karakterle yarışır.

**Kurallar:**
- Doku çizgileri en fazla 2 px; her zaman kahraman konturdan ince.
- Ahşap için birkaç damar çizgisi; taş için derz ve tek tük çatlak; toprak için seyrek yatay çizgi.
- Dithering, gren, gürültü katmanı, boyalı fırça izi yok.
- **Teknik not (technical-artist):** `CanvasItem` normal map'i ve `Light2D` gölgelemesi kullanılmaz; gece hissi için `CanvasModulate` ile toplu renk çarpımı da yapılmaz (kilitli hex değerlerini değiştirir). Renkler doğrudan paletle boyanır.

### 6.3 Bölgelere göre prop yoğunluğu

| Bölge | Yoğunluk | Ne bulunur | Kural |
|---|---|---|---|
| **Kapı** | En düşük | Kapı, tek meşale, sur parçası, gelenin taşıdıkları; arkada uzak kuyruk | Sabit prop en fazla 2. Kadrajın propları **gelen kişiye aittir** (bohça, hayvan, yük). Gece ağırlıklı (4.3). |
| **Köy** | Kararlara bağlı, düşük → orta | Kervansaray, pazar, içeri alınanların izleri | Her prop bir kabul kararına izlenebilir (İlke 3). Kümeler meşale lekelerinin çevresinde toplanır; ışık dışındaki proplar yalnız mürekkep siluetidir. Kimseye bağlı olmayan süs yok. |
| **Savunma** | Köy + savunma izleri | Köyün izleri; içeri alınan askerlerin mızrak sehpası, kalkanı, nöbet yeri | Savunmanın görünüşü **içeri alınan askerlerden** gelir — asker almadıysan mızrak sehpası da yok. Tekfur tarafında prop yok; yalnız arazi katmanları ve siluetler. |

### 6.4 Çevresel anlatım — yazısız hikâye
1. **Her iz bir kişiye.** Köydeki her ayrıntı belirli bir kabul kararına bağlanır — tasarım zorunluluğu olduğu kadar veri bağıdır: iz, bir kabul kaydından türetilir (sistem tasarımında karşılığı kurulmalı).
2. **Sınıfların izi kendi yerinde:**
   - **Esnaf / Ahi:** pazar örtüsü altında tezgâh, alet, örs; Ahi'nin izi pazarda yoğunlaşır.
   - **Çiftçi:** izleri **kervansaray ve pazarın dışında**, köyün kenarında — sürülmüş toprağın yatay çizgileri, tahıl çuvalı, orak. Kilitteki "çiftçi kervansaraya ya da pazara yazmaz" kuralının görsel karşılığı.
   - **Asker / kışla:** kapıya ve sura yakın **nöbet izleri** — nöbet yeri, dayanmış mızrak, kalkan, nöbet ocağı. "Kışla" kararının köydeki görsel karşılığı budur; kışla bir bina değildir (kullanıcı kararı, 4 Ekim 2026).
   - **Yolcu ve kervan:** kervansaray avlusunda yük ve denk.
3. **Özel karakterlerin izi kendi imza şeklini tekrar eder** (5.4); oyuncu köyde gördüğü şekli kapıdan hatırlar. Şeklin ne olduğu ve izin yeri karakter tasarlandıkça belirlenir.
4. **Reddedilenlerin izi** (kullanıcı kararı, 4 Ekim 2026): Geri çevrilenler kapının dışında uzak bir iz bırakır — örneğin uzak kuyrukta kalan ve zamanla sönen bir ateş. İz uzak basamakta (5.7) çizilir, hüküm vermez; yalnız "biri burada kaldı" der (Sütun 1). Ateş meşale ailesinin kuralına uyar (aynı `#C4843A`, sert düz leke).
5. **Yazı ve rakam yok** — kitabe boş, sikke rakamsız (2.5), tabela yok, sayım çentiği yok. Bilgi kodda.
6. **İz hüküm vermez** — "bu kişi iyiydi" demez; yalnız "bu kişi buradaydı ve bu işi yaptı" der (İlke 2).

### 6.5 Köyün görsel büyümesi
Köy **yeni bina türüyle değil, insan ve izle** büyür (İlke 3, 2.3). Kaldıraçlar, önem sırasıyla:
1. **Meşale sayısı** — asıl büyüme ölçüsü (2.3, 4.3). Palet ısınmaz; sıcak leke sayısı artar.
2. **İz yoğunluğu** — meşale kümeleri çevresinde prop sayısı artar.
3. **Köy figürü kalabalığı** — köy basamağındaki figürler (5.7) çoğalır, yerleşim sıkışır.
4. **Var olan yapıların dolması** — kervansaray avlusu dolar, pazar örtüleri ve tezgâhlar çoğalır (aynı yapının büyümesi, yeni bina türü değil).
5. **Kadraj** — köy büyüdükçe görünüm genişler; perde geçişinde meşalelerin hepsi ilk kez tek kadraja sığar (2.6).

**Yasak:** yeni bina türü, ızgara yerleşim, gün ışığına geçiş (2.3), büyümeyi "ödül" gibi gösteren parıltı ya da efekt (Sütun 3).

### 6.6 Figür okunurluğu kuralı
**Doku hiçbir zaman figürle yarışmaz.**
1. **Çizgi basamağı:** Ortam çizgileri aynı karedeki figürün dış konturundan en az bir basamak incedir — kapıda figür 6 px, ortam ≤ 3 px, doku ≤ 2 px; köy basamağında figür 2 px, ortam dokusu çizgisiz (*düzeltme 4 Ekim 2026: en ince çizgi 2 px — 1 px doku kaldırıldı, bkz. 8.4*).
2. **Sessiz halka:** Figür siluetinin çevresinde, kendi kontur kalınlığının ~3 katı genişliğinde bir alana ortam doku çizgisi girmez (öneri; Bölüm 8'de doğrulanır). Figürün arkası tek düz ton.
3. **Siyah dolgu testi sahnede de geçer:** figür siyah doldurulup sahneye konduğunda 64 px'te tanınmalı. Arkasındaki prop siluetiyle birleşen figür testi geçmez — prop kaydırılır, figür değil.
4. **Yoğunluk tavanı:** Ortamın bir bölgesindeki çizgi yoğunluğu, o karedeki kahraman figürün iç ayrıntı yoğunluğunu geçmez. Göz önce sıcak lekeye, sonra kalın mürekkebe gider (3.4); ince doku sona kalır.

## 7. UI/HUD Visual Direction

### 7.0 Ana fikir
**Arayüz sessiz bir defterdir; sahne dünyanındır.** Arayüz yalnız gece `#0D0F14`, mürekkep `#06070A` ve kül `#B8C2CC` ile çizilir (4.4). Meşale `#C4843A` arayüzde hiçbir durumda kullanılmaz. Görüntüde yazı ve rakam yoktur; arayüzdeki her kelime ve sayı koddan gelen metindir (`Label` / `RichTextLabel`). Arayüz hiçbir seçeneği büyüterek, parlatarak ya da renklendirerek "doğru" diye işaretlemez (Sütun 2, 3.3).

### 7.1 Diegetik ve ekran-uzayı

| Öğe | Nerede | Palet |
|---|---|---|
| Kapı, meşale, gelen kişi; rüşvetteki kese ve eller; köydeki meşaleler; reddedilenin uzak ateşi | Dünya | Dünya paleti (Bölüm 2–6) |
| Sohbet, seçenekler, karar düğmeleri | Ekran | Arayüz paleti |
| **Barlar** | **Ekran — üst HUD şeridi** (kullanıcı kararı B, 4 Ekim 2026) | Arayüz paleti |
| Rüşvet hakkı keseleri, gün sayacı, menüler, imleç | Ekran | Arayüz paleti |

Barlar dünyaya konmaz: kapı yanına çakılı bloklar meşaleye yakın ısınır (sıcaklık bir "durum" anlamı kazanır, İlke 1 ve 4.2 bozulur), kapının 2 sabit prop bütçesini (6.3) doldurur ve köy görünümünde kaybolur.

### 7.2 Kapı sohbet ekranı yerleşimi
Referans 1920×1080; ölçüler öneridir (Bölüm 8'de doğrulanır).

```
+--------------------------------------------------------------+
| [bar][bar][bar][bar]                  [kese kese kese] [gün] |  HUD şeridi ~80 px
+-------------------------------+------------------------------+
|                               | Konuşanın adı                |
|   KADRAJ (dünya)              | — Konuşma satırı...          |
|   kapı kanadı, meşale,        |     anlatı satırı (italik)   |
|   gelenin yüzü ve göğsü       | — Konuşma satırı...          |
|   (~1100 px)                  |------------------------------|
|                               | [ seçenek 1               ]  |
|                               | [ seçenek 2               ]  |  tek tek belirir
|                               | [ seçenek 3               ]  |
+-------------------------------+------------------------------+
                                  sohbet sütunu ~780 px, iç boşluk 40 px
```

- **Kadraj — tam taşma** (kullanıcı kararı, 4 Ekim 2026): Dünya ekranın sol kenarına kadar uzanır; dünyayı arayüzden yalnız sohbet panelinin kenarı ayırır. Yüz-göğüs basamağında çizilir (5.7); yüz ekranın sol üçte birinde, kahraman odak (3.4).
- **Sohbet sütunu (sağ):** Gece dolgulu panel; kadrajla ortak kenarında 6 px mürekkep çizgi (soğuk mavi ya da meşale lekesine değdiği için okunur). Satır uzunluğu 45–60 karakter, sola hizalı, iki yana yaslama yok. Üstte sohbet kaydı (yeni satır alta eklenir), altta seçenek yığını.
- **Seçenek şeritleri:** Eşit yükseklik (~64 px) ve genişlik, aralarında 12 px. Yığın 2–6 şerit taşır; yuvalar baştan ayrılır, şerit sayısı yerleşimi kaydırmaz. Uzun seçenek iki satıra kırılır, eşitlik en uzun seçeneğe göre korunur.
- **Karar evresi:** Sohbet bitince seçenek yığınının yerine karar düğmeleri gelir — aynı şerit grameri, tek fark solda 48 px simge (sohbet seçeneklerinde simge yok; evreyi ayıran budur). Aynı anda kadraj daralır (2.2): gece rengi dikey şeritler kadrajın kenarlarından **sert adımlarla** girer (7.7). HUD ve sohbet sütunu yerinde kalır.
- **Sabit yuva:** Bir karar fiili göründüğünde hep aynı yuvada durur; olmayan seçenek boş yuva bırakır, ötekiler kaymaz. Yuvaların sırası anlam taşımaz (sıra game-designer ile belirlenir).
- **HUD şeridi:** Barlar solda, rüşvet keseleri ve gün sayacı sağda. Sohbet sırasında da görünür. Bar sayısı veriden gelir, yerleşim ondan bağımsızdır.

### 7.3 Durum grameri
*Kullanıcı kararı (4 Ekim 2026): kül çerçeve + ters çevirme.* Üç durum birbirinden ayrı ve her biri ≥ 3:1 farkla okunur (WCAG 2.4.7 / 2.4.13).

| Durum | Görünüm |
|---|---|
| Normal | Gece dolgu, kül metin ve simge, mürekkep çerçeve (yalnız dünyaya değdiği yerde görünür). |
| Üzerine gelme / klavye–gamepad odağı | **≥ 3 px kül çerçeve** (~10.5:1). Hover ve gamepad odağı tek bir "odak" durumudur; son kullanılan giriş odağı taşır. |
| Seçili / onaya hazır | **Tam ters çevirme:** kül dolgu, gece metin ve simge. |
| Basılı | Ters çevirme + dolgu içinde 4 px gece iç çerçeve (bir kare). |
| Kullanılamaz | Gri ton ya da alfa soluklaştırma yok (palet dışı ton üretir); boş kese simgesi + kesik kül çerçeve. Düğmenin hiç gösterilmemesi oyun tasarımı kararıdır (açık soru). |

Köşeler sert, yuvarlatma 0, gölge yok, cam efekti yok.

**İki adımlı onay** (kullanıcı kararı, 4 Ekim 2026): Kararlar geri alınamaz ve dört düğme özdeştir. İlk basış seçer (ters çevirme), **aynı düğmeye ikinci basış** kararı verir; başka düğmeye basmak seçimi değiştirir. Ayarlardan kapatılabilir. Ek önlemler: karar paneli açıldıktan ve son seçenek belirdikten sonra ~300–500 ms giriş kilidi (sohbetten taşan tıklamaya karşı); düğmeler arası ≥ 24 px, yükseklik ≥ 56 px; simgenin yanında koddan gelen kelime her zaman görünür. Geri alma (undo) yok — kararın ağırlığını bozar.

### 7.4 Tipografi
**Kişilik:** Yorgun bir yolcunun ağzından okunan ama kitap gibi düzgün metin — hafif elle yazılmış ritmi olan hümanist bir serif; kaligrafik gösteriş yok.
- **Yasak:** blackletter, sahte ortaçağ fontları, Arap harfini taklit eden Latin fontlar, ince/hairline kesimler, **yalnız büyük harfli fontlar** (ı/i ayrımı kaybolur).
- **Ağırlıklar:** Regular, Italic, Bold (varsa Medium). Light/Thin yok.

| Rol (1080p) | Boyut | Biçim |
|---|---|---|
| Konuşma satırı | 30 px | Dik, başında uzun tire "—" |
| Anlatı satırı | 28 px | İtalik, +32 px sol girinti, tiresiz, etiketsiz |
| Konuşanın adı | 22–24 px | Bold, konuşma satırının üstünde |
| Seçenek / karar düğmesi | 30 px | Dik |
| HUD sayısı (gün) | 32 px | Bold, tablo rakamı |
| Bar etiketi | 22 px | Dik |
| Son ekranı gün sayısı | 72 px | Bold |
| **Mutlak alt sınır** | **22 px** | |

Satır aralığı 1.35–1.45 (İ, Ş, Ç, Ğ'nin nokta ve kuyrukları kırpılmasın). Metin ölçeği ayarı %100 / %125 / %150; sohbet sütunu %150'de kaydırmayla taşır.

**Anlatı ile konuşma** renkle ayrılamaz (ikisi de kül); ayrım biçim (dik/italik), Türk edebî diyalog geleneği (konuşma uzun tireyle başlar) ve konumla (anlatı girintili, adsız) yapılır — renk körlüğünden bağımsız (4.5).

**Türkçe zorunlulukları:**
- Fontta `ç Ç ğ Ğ ı İ ö Ö ş Ş ü Ü` ve `â î û Â Î Û` olmalı. Test dizgisi: `Çağ ılgın İğdir ıssız öşü — ÇĞİÖŞÜ çğıiöşü fi fı` — Godot'da gerçek font dosyasıyla 22 ve 30 px'te ekran görüntüsü alınarak doğrulanır.
- Metin kontrollerinde `language = "tr"`; font "fi/fı" bağlarında ı/i ayrımını bozuyorsa `liga` kapatılır.
- **Otomatik büyük harf yok** (`uppercase`, `to_upper()`): i→I dönüşümü İ'yi kaybettirebilir. Büyük harf gerekiyorsa kaynak metinde yazılır.

**Aday font aileleri (ÖNERİ, onaylanmadı; hepsi SIL OFL):** 1. Alegreya / Alegreya Sans (ilk tercih), 2. Literata, 3. Source Serif 4 / Source Sans 3, 4. Noto Serif. EB Garamond 1080p'de küçük boyda ince kaldığı için önerilmez.

### 7.5 İkonografi
- **Biçim:** Düz siluet; iç ayrıntılar 3 px boşluk olarak kesilir. İkinci renk, parıltı, gradyan yok.
- **Teknik:** Tek renkli alfa maskesi; rengi Theme verir, ters çevirmede simge kendiliğinden gece tonuna döner.
- **Izgara:** Düğmede 48 px, HUD'da 40 px. Simgede harf ve rakam yok.
- **Kaynak — dünyadaki nesneler (6.4):** Kabul = açık kapı kanadı · Ret = sürgüsü çekili kapalı kapı · Rüşvet = kese (HUD kesesiyle aynı siluet) · Kışla = dik mızrak ve kalkan kenarı. **✓/✗ kullanılmaz** — kararı notlandırır (Sütun 2). Düğmeler ileride değişse de kural aynı: her karar fiili, dünyada izini bırakan nesneyle simgelenir.
- **Rüşvet keseleri:** Üç kese; dolu = kül dolgu, boş = 3 px kül kontur. Anında değişir.
- **Gün sayacı:** Simge + koddan sayı; sayım çentiği yok. Simge açık soru.

### 7.6 Barlar
- Yatay, parçalı levhalar; parça sayısı ve eşikler veridir (GDD'de).
- Parça durumları: (1) sağlam — kül dolgu, (2) çatlak 1 — tek mürekkep çatlak, (3) çatlak 2 — dallanan çatlak, (4) yarık — iki yarım 4 px ayrık, yalnız kül kontur. Çatlak çizgisi ≥ 2 px.
- En güçlü sinyal **sağlam parça sayısıdır**; kırılan parça boş kül kontura döner (keselerle aynı dil).
- Etiket koddan gelir; bar etiketleri henüz onaylanmadı, bar başına simge yok. Koddan sayı ya da durum kelimesi her zaman görünür.
- Yedek sinyal: şekil + ses + metin (4.5). Kırmızı, flaş, yanıp sönme, titreme yok.

### 7.7 Arayüz animasyonu — sert adımlar
Alfa geçişi (fade) zamana yayılmış bir gradyandır (palet dışı griler üretir); 2.6 crossfade'i de yasaklar. **Alfa fade ve crossfade arayüzde kullanılmaz.** Kilitteki "seçenekler ekrana bir anda düşmez" bir *sıralama* kuralıdır:
- **Seçenek girişi:** Her şerit bir karede belirir (kesme); isteğe bağlı olarak sağdan 3 adımda 16'şar px kayar (12 fps, ara kare karışımı yok). Seçenekler arası ~0.30 s (veri).
- **Atlama:** Herhangi bir girdi kalan seçeneklerin hepsini anında gösterir ama seçmez (giriş kilidi devreye girer). Ayarlarda belirme hızı: normal / hızlı / anında.
- **Kadraj daralması:** gece şeritleri 3 adımda girer.
- **Bar çatlağı:** sprite karesi değişir + ses; flaş ya da sarsıntı yok.
- **Konuşma satırı:** bütün satır tek seferde (daktilo efekti açık soru; olursa atlanabilir).
- **Sahne geçişi:** kesme ya da düz gece rengine kesme (1–3 kare), ardından kesme (2.6).
- **Yasak:** alfa fade, ease-out bulanması, ölçek zıplaması, parıltı nabzı, ekran sarsıntısı, yanıp sönme.
- **Azaltılmış hareket** ayarı kaymayı kaldırır; sıra korunur.

### 7.8 İmleç
Sert kenarlı, hafif elle kesilmiş, asimetrik ok; kül dolgu + 2 px mürekkep kontur. Kılıç ya da eldiven imleci yok; "işaret eden el" yerine okun çentikli bir çeşidi. 1080p'de 32×32, ayarla 48×48. Godot: `Input.set_custom_mouse_cursor` (`CURSOR_ARROW`, `CURSOR_POINTING_HAND`); ayarlardan sistem imlecine dönülebilir.

### 7.9 Menüler
- **Ana menü (2.9):** gece zemin, tek meşale lekesi, kapı siluetinin bir parçası; sol-altta kül metin listesi (odakta kül çerçeve, seçimde ters çevirme). Oyunun adı görsele gömülmez; ad konunca koddan basılır.
- **Duraklatma:** dünyanın üstüne **opak** gece paneli — yarı saydam karartma yok (palet dışı ton).
- **Ayarlar:** parçalı kaydırıcılar (bar grameri). Metin ölçeği, imleç boyutu, seçenek belirme hızı, iki adımlı onay aç/kapa, azaltılmış hareket, ekran modu, tuş atama.
- **Son / skor ekranı:** gece rengine kesme; "hayatta kalınan gün" etiketi koddan, sayı 72 px Bold; kutlama efekti yok (2.8).

### 7.10 Gamepad ve klavye gezinmesi
- Odak sırası görsel sırayı izler: sohbet listesinde yukarı/aşağı, karar sırasında sol/sağ; liste içinde sarar, barlara ya da menüye atlamaz (`focus_neighbor_*` açıkça tanımlanır).
- Karar paneli açılınca odak ilk yuvaya gelir (iki adımlı onay sayesinde güvenli).
- **B / Esc hiçbir zaman "ret" değildir**; yalnız seçimi iptal eder ya da menüyü açar.
- Kararlar doğrudan yüz tuşlarına ya da 1–4 kısayollarına bağlanırsa iki adımlı onay zorunludur.
- Tuş ipucu glifleri kül renkte, son kullanılan girişe göre değişir; tüm tuşlar yeniden atanabilir.

### 7.11 Godot uygulama notları (ui-programmer / technical-artist)
- Projenin varsayılanı tek bir `Theme` kaynağı. `StyleBoxFlat`: `corner_radius_* = 0`, `shadow_size = 0`, `bg_color = #0D0F14`. Focus/hover: `border_width ≥ 3`, `border_color = #B8C2CC`. Pressed/seçili: `bg_color = #B8C2CC`.
- Tip varyasyonları: `DialogueLabel`, `NarrationLabel`, `SpeakerLabel`, `ChoiceButton`, `DecisionButton`, `HudCounter`, `BarLabel`.
- `font_color` / `icon_normal_color` kül; `font_pressed_color` / `icon_pressed_color` gece.
- Animasyon: `AnimationPlayer` izleri `UPDATE_DISCRETE` ya da zamanlayıcı ile sıralama; `modulate:a` tween'i yok.
- Tüm metin çeviri anahtarlarından (`tr()`); metin kontrollerinde `language = "tr"`.
- Godot 4.5+ AccessKit ile ekran okuyucu her seçeneği belirdiği anda okumalı.
- Doğrulama: her ekranın 1080p ekran görüntüsü `production/qa/evidence/` altına.

### Açık sorular (Bölüm 7)
1. **Gün sayacı simgesi:** ay diski, başka bir simge ya da simgesiz yalnız sayı? (Hilal sembol yükü taşıdığı için önerilmedi.)
2. **Oyuncunun seçtiği replik** sohbet kaydında görünecek mi; nasıl etiketlenecek?
3. **Adı bilinmeyen gelen için konuşan etiketi:** boş, "Yabancı" ya da koddan bir tanım?
4. **Rüşvet hakkı bitince** düğme gizlensin mi, kullanılamaz olarak mı görünsün?
5. **Daktilo efekti** olsun mu?
6. **Font:** Alegreya önerildi; onay ve Godot'da Türkçe glif testi gerekiyor.
7. **Seçenek sırası:** sabit mi, rastgele mi? (game-designer ile)

## 8. Asset Standards

> art-director + technical-artist birlikte. **[GK]** işaretli motor bilgileri `docs/engine-reference/godot/` içinde yoktur, genel bilgidir — Godot 4.7.2 editöründe doğrulanmalıdır. "ÖNERİ" işaretli sayılar kalibrasyon sahnesiyle (8.12) doğrulanana kadar kesin değildir.

### 8.0 Üretim hattı
**Yapay zekâ taslak çizer, el kesinleştirir; palet ve mürekkep elden çıkar.**
1. **Spec** — varlık başına yazılı istem (basamak 5.7, palet rolleri, "yazı yok, gradyan yok, düz renk, kalın siyah kontur"); `design/art/asset-specs/` altında.
2. **Ham üretim (Gemini)** — olduğu gibi saklanır, **asla doğrudan oyuna girmez**.
3. **Temizlik (elle)** — sahte yazı silinir, gradyan düzleştirilir, kontur yeniden çizilir (8.5), palet eşlenir (8.6).
4. **Ana dosya** — katmanlı, 2×, palet-tam.
5. **Dışa aktarım** — PNG → Godot içe aktarımı.
6. **Denetim** (8.8) — dosyada ve oyun içi ekran görüntüsünde.

**Komut kuralı (kullanıcı onayı, 4 Ekim 2026):** Gemini komutlarına referans adı **hiç yazılmaz** ("Reigns tarzında", "minyatür gibi", "ağaç baskı stili" yasak); yalnız Bölüm 9'dan çıkan kural cümlesi yazılır. Ad, kaynağın paletini, yazısını ve yüz kalıplarını da getirir — kopya riski.

Görüntü modelleri tam hex, sabit çizgi kalınlığı ve gerçek düz renk üretmez; düz yüzeylere gradyan ve gürültü, tabela/kitabe/sikkeye sahte yazı ekler. Bölüm 1'in kuralı ancak temizlik adımı zorunlu tutulursa korunur.

### 8.1 Dosya biçimleri
| Aşama | Biçim | Not |
|---|---|---|
| Ham yapay zekâ çıktısı | Model ne verirse, değiştirilmeden | İstem ve tarihle saklanır |
| Ana dosya | Katmanlı `.kra` ya da `.psd` (ekip tek araç seçer) | Zorunlu katmanlar: `ink`, `fill`, `light` (8.6) |
| Oyun içi raster | **PNG, 8 bit/kanal RGBA, sRGB** | `iCCP`/`gAMA` parçaları silinir (renk kaymasını önler) |
| Arayüz simgesi, panel çerçevesi, bar levhası | SVG olabilir | Godot SVG'yi içe aktarırken rasterleştirir [GK]; `svg/scale = 2.0`. Karakter ve ortam mürekkebi her zaman PNG |
| Büyük düz renk alanları | Doku yok — `ColorRect` / `Polygon2D` | Gece zemin, düz gök, uzak arazi bandı dokuya basılmaz |

### 8.2 Adlandırma
Biçim: `[önek]_[ad]_[varyant]_[basamak|boyut].png` — **yalnız küçük ASCII harf, rakam ve `_`**, İngilizce ad (kodla uyumlu; `farmer`, `caravanserai`). Türkçe karakter, boşluk ve tire yok. Varyant iki hane (`_01`).

| Önek | Kapsam | Örnek |
|---|---|---|
| `char_` | Adlı ya da sınıf figürü | `char_miraen_listening_card.png`, `char_farmer_01_idle_village.png` |
| `crowd_` | Uzak kalabalık | `crowd_tekfur_spear_01_far.png` |
| `env_` | Yapılar, arazi katmanları | `env_gate_closed_card.png`, `env_terrain_ridge_01_bg.png` |
| `prop_` | İz propları (İlke 3) | `prop_spear_rack_01_village.png` |
| `ui_` | Panel, bar levhası, düğme | `ui_bar_segment_cracked_02.png`, `ui_btn_decision_focus.png` |
| `icon_` | Simgeler | `icon_bribe_pouch_full_48.png` |
| `fx_` | Meşale lekesi, ateş, çatlak | `fx_torchlight_patch_03.png`, `fx_campfire_dying_02_far.png` |

- **Basamak eki (5.7)** zorunlu: `_card` / `_village` / `_far`. Ortam derinliği: `_fg` / `_mg` / `_bg`.
- **Arayüz/simge boyutu:** 1080p ekran boyutu (`_48`).
- **Durum:** `_hover`, `_focus`, `_pressed`, `_disabled`, `_full`, `_empty`, `_cracked`. **Renk adı asla durum eki değildir** (`_red`, `_gold` yasak, 4.2).
- Kaynak dosya aynı adı taşır (`.kra`); ham çıktı `_raw_01` eki alır. Dolgu/mürekkep ayrı dosyalara bölünürse `_fill` / `_ink`.

### 8.3 Taban çözünürlük ve ölçekleme
*Kullanıcı kararları (4 Ekim 2026): genişle + güvenli kadraj; alt sınır 1080p.*
- `display/window/size/viewport_width × height` = **1920×1080** (sanat birimi = 1080p px).
- `stretch/mode = canvas_items`, `stretch/aspect = expand`, `stretch/scale_mode = fractional` [GK]. Elle yazılan `project.godot`'ta bu anahtarlar açıkça yazılır — 4.7'deki "yeni proje varsayılanı" Proje Yöneticisi'nin yazdığı ayar olabilir, motor varsayılanına güvenilmez.
- **Güvenli kadraj:** Her sahnenin önemli öğeleri 16:9 alanın içindedir. Geniş ekranda açılan taşma alanı yalnız gece ya da soğuk mavi düz tondur; kahraman öğe ve meşale lekesi içermez (4.3'teki %10–15 oranı 16:9 alanda ölçülür).
- **Mürekkep kalınlığı** fiziksel pikselde değil, **1080p biriminde** sabittir (5.7'deki "ekran px'inde sabit" = "1080p birimde sabit"): 1080p'de 6 px, 1440p'de 8, 4K'da 12.
- **Desteklenen en düşük çözünürlük 1080p.** 720p yalnız geliştirme penceresidir; sanat değerlendirmesi 720p'de yapılmaz.
- `rendering/viewport/hdr_2d` kapalı; `WorldEnvironment`/glow yok (Bölüm 2).

### 8.4 Çizgi ağırlıkları ve üretim ölçeği
**Tüm sanat 2× çizilir** (3840×2160 eşdeğeri) ve 1080p birimde 0,5 ölçekle yerleştirilir — 4K'ya kadar doku büyütülmez.

| Katman | 1080p | Ana dosya (2×) |
|---|---|---|
| Kahraman dış hat | 6 px | 12 px |
| İç ayrıntı | 3 px | 6 px |
| Destek / uzak öğe, köy figürü konturu | 2 px | 4 px |
| Doku çizgisi | 2 px | 4 px |
| **En ince çizgi (mutlak)** | **2 px** | **4 px** |

Tolerans ±1 ana dosya pikseli. **1 px çizgi yoktur** (kullanıcı kararı, 4 Ekim 2026; 6.6 buna göre düzeltildi). Hücre ve sprite boyutları çift sayıdır (0,5× tam piksele düşsün).

**4.7 notu:** `CanvasItem` artık çizgilere AA tüyü eklemiyor [BC/BP]; mürekkep runtime çizgisi (`draw_line`, `Line2D`) olarak çizilmez, dokuya pişirilir. Çalışma anındaki çizgiler (odak çerçevesi, bar çatlağı) `StyleBoxFlat.border_width` ya da dokuyla yapılır.

### 8.5 Kenar yumuşatma ve palet saflığı
*Kullanıcı kararı (4 Ekim 2026): yalnız kenarda AA, dosyada saf.*
- **Dosyada:** Sprite'ın **iç** renk sınırları (mürekkep–dolgu, dolgu–meşale lekesi) sert ve palet-tamdır. Yumuşatma yalnız sprite'ın **dış kenarında, saydamlıkla** yapılır — kenar pikselinin RGB'si bir palet rengidir, yalnız alfası değişir.
- **Ekranda:** `canvas_items` tamsayı olmayan ölçeklerde ve doğrusal filtrede kenarlarda ara ton üretir. **Kenar AA pikseli gradyan sayılmaz.** Saflık dosyada denetlenir (8.8), ekranda yalnız sıcak alan oranı ölçülür.
- **Kart dış hattı** (12 px ana dosya) her `_card` varlığında elle ya da sabit genişlikli konturla **yeniden çizilir**; iç çizgiler tolerans dışındaysa yeniden çizilir. `_village` dış hattı dolgu maskesinden sabit genişlikli kontur olarak türetilebilir (siyah dolgu testini de verir, 3.1).
- Bir basamağın çizimi başka basamağa **küçültülerek üretilmez** (5.7).

### 8.6 Palet eşlemesi
- **Hedef palet tam 7 hex:** `#0D0F14`, `#4A6B8A`, `#3D2E24`, `#C4843A`, `#06070A`, `#B8C2CC`, `#24364A`. Tek kaynak `assets/palette/` (`.gpl`, `.ase`, `palette_swatch.png`).
- **Dithering kapalı.** En yakın renk algısal uzayda (OKLab) hesaplanır.
- **Mürekkep ile gece neredeyse aynı renktir** — otomatik eşleme ayıramaz; renk katmandan gelir: `ink` = mürekkep, `fill`'deki koyular = gece, `light` = yalnız meşale.
- **Gradyan niceleme ile düzelmez** (basamaklı şeride dönüşür); elle tek tona düzleştirilir ya da sert kenarlı iki bölgeye (soğuk mavi → derin mavi) ayrılır.
- **Sıcak ten tuzağı:** Yapay zekâ yüzleri sıcak tenli çizer; niceleme bunu meşaleye eşler ve İlke 1'i bozar. Meşale lekesi dışındaki sıcak piksel elle soğuk maviye çevrilir (5.2).

### 8.7 Godot içe aktarma ayarları
| Ayar | Değer | Gerekçe |
|---|---|---|
| `compress/mode` | **Lossless** | VRAM sıkıştırması (BC1/BC3) uç renkleri RGB565'e indirger, ör. `#C4843A` → `#C6…`; 4×4 bloklarda ara ton üretir [GK] |
| `mipmaps/generate` | Açık (2× üretilen dünya, kart, arayüz) | 0,5× ve altında çizgi kopmasını ve parıldamayı önler; +%33 bellek |
| Filtre (`rendering/textures/canvas_textures/default_texture_filter`) | `Linear Mipmap` | Ölçeklemede çizgi kalınlığı tutarlı [GK] |
| `process/fix_alpha_border` | Açık | Saydam kenarda koyu/renkli hale oluşmasın [GK] |
| Modulate / CanvasModulate | Kullanılmaz | Hex'i değiştirir (6.2) |

### 8.8 Sert kenarlı meşale lekeleri
- **Kart / sohbet** (yarım yüz lekesi): sanatçının çizdiği ayrı katman sprite'ı (krizde küçültülebilir, 2.4).
- **Köy / kapı zemini ve duvarı:** dokusuz düz `#C4843A` `Polygon2D` — doku belleği sıfır, kolay batch'lenir, köy büyüdükçe veriden eklenir (6.4). `Polygon2D.antialiased = true` (~1 px tüy) önerilir; 4.7'deki tüy değişikliğinin poligona etkisi doğrulanmalı.
- **Katman sırası:** dolgu → leke → mürekkep (figür sprite'ı `fill` ve `ink` olarak ikiye ayrılır; `clip_children` batch'i kırdığı için kullanılmaz).
- **Blend:** `MIX`, modulate beyaz. **Add/Mul/Screen yasak** — hex'i bozar. Leke "ışık" değil, opak boya katmanıdır. `PointLight2D` yok.

### 8.9 Atlas, sprite sayfası, kart pozları
- **Kart pozları — ortak gövde + baş değişir** (kullanıcı kararı, 4 Ekim 2026): gövde bir kez çizilir, baş/ifade parçaları ortak bir atlas'ta (512×512). **Adlı karakter 5 poz** (nötr-yorgun, dinleyen, kaçınan, konuşan, sessiz), **adsız sınıf figürü 2 poz** (nötr-yorgun, konuşan). Bellek ~32 MiB/karakter (tam çizim ~107 MiB olurdu).
- **Köy figürleri ve propları:** tek atlas sayfası (2048×2048), karakter başına sabit 256×256 hücre (ana dosya), pivot ayak tabanında alt-orta. `y_sort` farklı dokular arasında batch kırar — tek sayfa yüzlerce figürü birkaç draw call'a indirir.
- **Uzak kalabalık:** köy atlasında ya da dokusuz `Polygon2D`.
- **Arayüz:** 1024×1024 atlas; paneller 9-slice (`NinePatchRect` / `StyleBoxTexture`).
- Hücre arası boşluk ≥ 8 px (ana dosya). Renk varyantı `modulate` ile değil, atlas'ta ayrı kare ile; asimetrik eşyalı figürler (kın, şed düğümü) `flip_h` ile aynalanmaz.

### 8.10 Kategori başına doku sınırı ve bütçeler (ÖNERİ)
`project.yaml` içinde performans bütçesi henüz yok; aşağıdakiler min-spec belirlenince technical-director ile kesinleşir.

| Kategori | En büyük doku |
|---|---|
| Kart gövdesi | 2048×2048 |
| Kart baş/ifade parçaları | 512×512 ortak atlas |
| Köy figürü + prop + uzak kalabalık | 2048×2048 atlas sayfası |
| Ortam katmanları (kapı, kervansaray, sur) | 4096 kenar, kırpılmış |
| Arayüz | 1024×1024 atlas |
| **Mutlak üst sınır** | 4096 |

| Bütçe | Öneri |
|---|---|
| Yerleşik doku belleği | ≤ 512 MiB |
| Aynı anda yüklü kart karakteri | ≤ 2 |
| 2D draw call / kare | ≤ 200 |
| Görünür köy figürü | ≤ 150 |
| Meşale lekesi poligonu | ≤ 60 (her biri ≤ 16 köşe) |
| Parçacık sistemi | **0** (yangın kararı verilirse yeniden açılır) |
| Özel shader | 0 (mürekkep pişirilir) |

### 8.11 Fontlar
- TTF/OTF dinamik font; arayüz ve başlıkta **MSDF** (her ölçekte keskin), `msdf_pixel_range ≥ 8`, mipmap açık [GK]. 22 px alt sınır sayesinde MSDF'nin küçük punto zayıflığı sorun olmaz; gerekirse gövde metni için normal raster + oversampling.
- Kullanılan glifler önceden üretilir (pre-render), ilk görünümde takılma olmaz.
- **Türkçe glif kabul testi:** `ç Ç ğ Ğ ı İ ö Ö ş Ş ü Ü â î û Â Î Û`; eksik glif varsa fallback font tanımlanır (7.4).

### 8.12 Denetim
Bir yardımcı betik (technical-artist yazar) **yalnız gözlem raporlar**; kararı insan verir (CLAUDE.md).

| # | Kural | Tür |
|---|---|---|
| R1 | Alfası > 0 her pikselin RGB'si 7 hex'ten biri (tolerans 0) | Betik |
| R2 | Alfa 0 ya da 255; ara alfa yalnız ≤ 2 ana dosya piksellik dış kenar bandında | Betik |
| R3 | Kül yalnız `ui_`/`icon_` ve sikkede; meşale yalnız meşale, ateş, `fx_torchlight`, `light` katmanı | Betik |
| R4 | Basamak eki ile piksel boyutu 8.4/8.9 aralığında | Betik |
| R5 | Ad 8.2 desenine uyar | Betik |
| R6 | Yazı, rakam, sahte yazı, imza, filigran yok | İnsan |
| R7 | Gradyan, şerit, gren, gürültü, hale yok | İnsan |
| R8 | Çizgi ağırlığı toleransta; siyah dolgu testi 64 px'te geçiyor | İnsan |
| R9 | Hüküm yok (İlke 2) | İnsan |
| R10 | Kapı kadrajında meşale piksel oranı ≤ %10–15 (16:9 güvenli alanda, ekran görüntüsünde) | Betik + ekran |

**Kalibrasyon sahnesi (yapılmadı, ilk teknik iş):** 2/3/6 px çizgi örnekleri, 64 px siyah siluet, 7 palet karesi; 1920×1080, 2560×1440, 3840×2160 ve 21:9 pencerede açılıp ekran görüntüleri `production/qa/evidence/` altına konur, palet karelerinin iç pikselleri hex olarak ölçülür. Kodlama standardı gereği motor çalıştırılıp gözlenmeden bu bölümün sayıları doğrulanmış sayılmaz.

### 8.13 `assets/` klasör düzeni
```
assets/
  palette/                    palette.gpl, palette.ase, palette_swatch.png
  art/
    _source/                  .gdignore — Godot içe aktarmaz
      raw/                    ham yapay zekâ çıktısı + istem kaydı
      master/                 .kra/.psd ana dosyalar
    characters/<ad>/          card/, village/
    crowd/
    environment/              gate/, caravanserai/, market/, terrain/
    props/
    ui/                       panels/, bars/, buttons/
    icons/
    fx/
  fonts/
```
`_source/` içinde **`.gdignore`** zorunlu — yoksa Godot ham PNG'leri de içe aktarır. Büyük ikili dosyalar için Git LFS kararı producer ve technical-artist'te.

### Açık sorular (Bölüm 8)
- **Gemini çıktı çözünürlüğü** doğrulanmadı; 2× ana dosyaya (kart ~1500 px) yetmezse temizlikten önce büyütme adımı gerekir. İlk test üretimiyle ölçülecek.
- **Yapay zekâ beyanı:** Gemini görselleri görünmez SynthID filigranı taşır; Steam'in yapay zekâ içerik beyanı producer'a iletilmeli.
- **Köy figürü animasyonu** olacak mı; kare sayısı?
- **Ana dosya aracı:** Krita mı Photoshop mu?

## 9. Reference Direction

### 9.0 Ana fikir
**Referans bir kural verir, bir görünüş vermez.** Her kaynaktan tek bir teknik, renk ya da kompozisyon kuralı alınır; kaynaklar birbirini tekrar etmez, her biri farklı bir işe bakar. Kullanıcının kendi referansları Reigns ve Papers, Please'tir ("yakın, kopya değil"). Üç oyun dışı kaynak, her biri başka bir boşluğu (giyim, yapı, mürekkep tekniği) doldurduğu için eklendi (kullanıcı seçimi Claude'a bıraktı, 4 Ekim 2026).

**Komut kuralı (8.0):** Referans adı Gemini komutuna hiçbir zaman yazılmaz; yalnız bu bölümden çıkan kural cümlesi girer.

| # | Kaynak | Baktığı iş | Desteklediği bölüm |
|---|---|---|---|
| 1 | Reigns | Figürün kart boyutunda okunması | 3.1, 5.4, 5.7 |
| 2 | Papers, Please | Kapı sahnesinin kadrajı, tekrarın yorgunluğu | 2.1, 5.5, 6.3, 7.2 |
| 3 | Varka ve Gülşah minyatürleri | Dönem giyimi | 5.2, 5.3 |
| 4 | Selçuklu kervansaray taçkapısı | Yapı kütlesi | 3.2, 6.1 |
| 5 | Ağaç / linol baskı (yüksek baskı tekniği) | Mürekkep çizgisi, gölge kütlesi | 3, 6.2, 2.1 |

### 9.1 Reigns — kart boyutunda tek imza
- **Alınan:** Büst kadrajında tek figür ve onu küçük boyda tanıtan **tek bir dış hat şekli** (başlık, sakal, taşınan nesne). Yüzün birkaç parçaya indirgenmesi: göz kapağı, ağız çizgisi, baş açısı — 5.4'teki imza şekli ve 5.6'daki üç ifade kaldıracının kaynağı.
- **Ayrışılan:** Reigns'in konturu yoktur, bizde kalın mürekkep zorunlu (3). Karikatür burun ve mizahi abartı yok; taban ifade yorgun (5.6). Karakter başına renkli/sıcak kart zemini yok — zemin her zaman gece (4.2). Eğilen/kaydırılan kart çerçevesi ve kart üstü metin yok (7.2). Üstte dolan simge barları yok — bizim barlar simgesiz, çatlayan levhalar (7.6).

### 9.2 Papers, Please — yorgun kapı
- **Alınan:** Birinci şahıs, sabit kadraj; gelen kişi oyuncuya gelir, oyuncu yerinden kalkmaz (5.1). Kahraman odak **tek kişi**, arkadaki kuyruk yalnız uzak ritim (5.5, 6.3). Her gün aynı kadrajın tekrarı yorgunluğu taşır; değişen yalnız gelen kişidir.
- **Ayrışılan:** Piksel sanat yok — 2× çizim ve mürekkep (8.4). Belge, mühür, metin yığını yok; karar sohbetle verilir (Sütun 2, 7.0). Yeşil/kırmızı onay damgası yok (4.2). Çamurlu, düşük doygunluklu kahverengi-zeytin palet yok. Kuşbakışı kuyruk ve propaganda afişi estetiği yok.

### 9.3 Varka ve Gülşah minyatürleri
*13. yüzyıl Anadolu Selçuklu resimli el yazması (Topkapı Sarayı Müzesi koleksiyonu). Katalog numarası, kesin tarih ve nakkaş bilgisi hafızadan yazıldı — kaynakla doğrulanmalı.*
- **Alınan:** Yalnız **giyim ve aksesuar sözlüğü**: önü bindirmeli kaftan, bel kuşağı, börk ve sarık sargısı, yumuşak çizme, sadak ve yay, yuvarlak kalkan — 5.2'deki şablonun görsel kanıtı ve yapay zekânın dönem dışı kavuk/fes/cepken üretimine karşı temizlik referansı (8.0). İkinci kural: figürler **düz bir zemin önünde, yere düşen gölge olmadan** durur — 6.6'daki "figürün arkası tek düz ton" kuralını destekler.
- **Ayrışılan:** Kırmızı, altın, lacivert zemin yok (palet 7 hex; altın yasak semantik, 4.2). Yaldız, metin kartuşu, yazı alanı yok (R6). Saray ve kahramanlık sahnesi, dinamik savaş pozu yok (5.6). Kalıp "ay yüz" güzellik tipi yok; yuvarlak "güvenilir" hat yasak (3.1). Minyatürün eşit, ışıksız aydınlığı yok — tek kaynak meşale (İlke 1).

### 9.4 Selçuklu kervansaray taçkapısı
*Yalnız plan ve kütle için; ölçek ve süsleme alınmaz.*
- **Alınan:** **Düz, sağır bir duvar kütlesinde tek ve yoğun bir giriş.** Vurgu sivri kemerli taçkapıda toplanır, duvarın geri kalanı sessizdir — 3.4'teki "bir karede bir kahraman" kuralının mimarideki karşılığı; 6.1'deki kervansaray tarifini besler ve kapı ile kervansarayın aynı "dikdörtgen içinde tek açıklık" dilini paylaşmasını sağlar.
- **Ayrışılan:** Anıtsal ölçek ve sultan hanı görkemi yok — bizimki uçta, kaba ve küçük (6.1). Mukarnas, geometrik geçme, oyma süsleme yok ya da en fazla tek çizgi. Kitabe yazısı yok (6.4). Sıcak bal rengi kesme taş yok — taş soğuk mavi düz leke (4.1); yapay zekâ çıktısında en olası sıcak renk sızıntısı budur (8.6). Hayvan figürlü kabartmalar yok (sembol yükü, hüküm riski, İlke 2).

### 9.5 Ağaç / linol baskı — yüksek baskı tekniği
*Belirli bir sanatçı değil, tekniğin kendisi (sanatçı adı stil taklidi riski taşır, 8.0).*
- **Alınan:** **Gölgenin çizgiyle değil, düz siyah kütleyle verilmesi** — yüzün ışık almayan yarısı tek parça mürekkep ya da soğuk mavi alan (2.1); ara ton taraması yok, ışık–gölge sınırı tek sert kenar (meşale lekesiyle aynı mantık, İlke 1). İkinci kural: malzeme dokusu **birkaç paralel oyma çizgisiyle** verilir (ahşap damarı, toprak) — 6.2'deki "doku tonla değil çizgiyle" kuralı.
- **Ayrışılan:** İncelip kalınlaşan, sivrilen çizgi yok — ağırlık 6/3/2 px'te sabit (8.4). Kâğıt dokusu, mürekkep taşması, baskı lekesi, ahşap gren izi yok (R7). Ekspresyonist yüz bozması ve korku tonu yok (kötü adam yüzü riski, 3.1). Sık tarama yok; doku çizgisi seyrek ve sessiz halkaya girmez (6.6).

### 9.6 Görsel referans OLMAYANLAR
Not Tonight, Yes Your Grace ve Death and Taxes **oynanış akrabasıdır**, görsel referans değildir (ilk ikisi piksel sanat, üçüncüsü yuvarlak karikatür çizgi). Ortak tuzak: karar ekranında renkli onay/ret işaretleri (4.2).

**Ayrışma testi:** Bir görsel, yanına konduğunda herhangi bir referansın **ekran görüntüsü** sanılıyorsa fazla yakındır; yalnız o referansın kuralını taşıyorsa doğrudur.
