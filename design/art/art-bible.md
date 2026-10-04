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

[To be designed] — a primary palette of 5–7 colours with their meaning in this
world, semantic colour usage, per-area colour temperature rules, the UI palette
and where it diverges, and colourblind safety: which semantic colours need a
shape, icon or sound backup.

## 5. Character Design Direction

[To be designed] — the player character's visual archetype, how players tell
enemies, NPCs and allies apart at a glance, expression and pose style, and how
much detail survives at game camera distance (LOD philosophy).

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
