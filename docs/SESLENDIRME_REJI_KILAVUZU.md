# Kapı Muhafızı — Seslendirme ve Dil Reji Kılavuzu (SES-DIL-01)

> **Kapsam:** 13. Yüzyıl Anadolu Selçuklu / Uç Beyliği Dönemi Fonetik Kılavuzu, Reji Direktifleri ve Karakter Ses Kartları  
> **Hazırlayan:** Antigravity (Ahmet ve Kaşif direktifiyle, Görev 17 Paralel Ajan B)  
> **Referans Belgeler:** `ROADMAP_2.md` (SES-DIL-01), `docs/DIYALOG_ANA_PLANI.md`, `data/diyalog/diyalog_01_20.json`, `data/diyalog/en/diyalog_01_20.json`, `data/parley/koy/`  
> **Teknik Standart:** 48 kHz / 24-bit PCM WAV (Mono), Dry Vocal, Proximity Effect

---

## 1. Genel Sanat ve Ses Tasarım Vizyonu

### 1.1. Tarihsel ve Atmosferik Çerçeve
*Kapı Muhafızı*, 1243 Kösedağ Bozgunu sonrasındaki çalkantılı dönemde, dondurucu bir kış mevsiminde dağ geçidindeki sınır kapısını tutan bir nöbetçinin ve sığındığı köyün dramını anlatır. Seslendirme vizyonunun merkezinde şu unsurlar yer alır:

1. **Tiyatro ve Opera Abartısından Kaçınma:** Replikler teatral veya tumturaklı tiratlar gibi okunmamalıdır. Kış ayazında donan, sırtında heybesi olan, açlıktan takati kalmamış, korku veya tekinsizlik içindeki gerçek 13. yüzyıl insanlarının ağzından çıkmalıdır.
2. **Ayaz, Soluk ve Beden Gerçekçiliği:** Soğuk havada konuşurken verilen buharlı kesik nefesler, çene titremeleri, kelime aralarındaki yutkunmalar ve göğüs hırıltıları korunmalıdır. Karakter bir yük taşıyorsa ses tonunda ağırlık, yaralıysa kesik soluk hissedilmelidir.
3. **13. Yüzyıl Anadolu Türkçesi Fonetiği:** Günümüz şehir Türkçesi kibarlığı veya modern dizi dili yerine; sert ünsüzleri (k, t, p, ç) tok vuran, boğaz ve göğüs rezonansını kullanan, devrik ve yalın halk dili esas alınır. Yabancı/azınlık karakterlerde (Tebrizli tüccar, Rum ipekçi, Kıpçak levent) hafif ve otantik dönem aksanları korunmalıdır.
4. **Reji Notasyonu:** Her repliğin başında köşeli parantez içinde verilen `[...]` direktifleri; oyuncunun beden dilini, fiziksel mesafesini, ses dinamiğini ve repliğin alt metnini belirler.

### 1.2. Akustik ve Teknik Kayıt Standartları
- **Örnekleme ve Çözünürlük:** 48 kHz, 24-bit PCM WAV, Mono.
- **Akustik Ortam (Dry Vocal):** Kayıtlar tamamen yansısız (dead room) kuru vokal olarak alınır. Kapı kulesi yankısı, rüzgâr uğultusu ve oda ambiyansı oyun motorunun Godot AudioBus (Reverb/LowPass) hattında dinamik olarak işlenecektir.
- **Mikrofon Mesafesi (Proximity Effect):**
  - *Kapı Nöbeti (Diyalog):* 15–20 cm kardioid/geniş diyafram kondenser mikrofon; soğuk nefes patlamalarını önlemek için pop filtre kullanılır.
  - *Eş Fısıltıları ve İç Ses:* 5–10 cm yakın mikrofonlama; sıcak, samimi, fısıltılı alt harmonikler öne çıkarılır.
  - *Nida ve Tehdit:* 30–40 cm mesafeden ses patlamasına (clipping) izin vermeden göğüsten gelen yüksek projeksiyon.

---

## 2. Ana Karakterler (Core Protagonists)

---

### Muhafız (Oyuncu — Sınır Kapısı Nöbetçisi)
- **Yaş:** 35–40
- **Ses Rengi / Tını:** Derin bariton, tok, ayaz ve yorgunlukla pürüzlenmiş, otoriter ama vicdan terazisi taşıyan ses.
- **Ağız / Şive:** Uç Türkmeni ağzı; sert sessizler, az ve öz kelimeler, gereksiz nezaket eklerinden arınmış doğrudan hitap.
- **Duygu Aralığı:** Nöbet ciddiyeti, tetikte olma, şüphe, soğukkanlılık; eşine karşı gizli şefkat, zorlu kararlarda boğazda düğümlenen keder.
- **Nefes ve Duraklama:** Cümle başlarında donuk nefes verişi, soru sormadan önce 1-2 saniyelik tartan duraklama, kılıç kını veya mızrak sapına dayanan göğüsten tok soluma.

#### Replik 1 (Sorgu / Karar Öncesi)
- **TR:** `[boğuk, nefesini buharla dışarı vererek, gözlerini yabancının heybesine dikerek]` "Kimsin, nereden gelirsin? Bu ayazda dağ boğazı kurt kaynar; doğru söylemezsen kapı açılmaz."
- **EN:** `[low-pitched, releasing frosty breath, eyes fixed on the stranger's pack]` "Who are you, and whence do you come? In this bitter freeze, wolves prowl the pass; speak truth, or this gate stays barred."
- **Reji Notu:** Tehdit değil, kışla nöbetçisinin taşlaşmış dikkati. "Kimsin" kelimesi tok bir 'k' ile vurulmalı, son cümle kesin bir sınır koymalıdır.

#### Replik 2 (Vicdani Hüküm / Eş ile Dertleşme)
- **TR:** `[kısık sesle, ocak közüne bakarak, derin bir iç çekişle]` "Kapıyı kapamak kolay Elif... Amma ardında kalan ahın ağırlığı sırtımdan inmiyor."
- **EN:** `[hushed, gazing into hearth embers, deep weary sigh]` "Barring the gate is easy, Elif... But the weight of the wailing left outside never leaves my shoulders."
- **Reji Notu:** Asker maskesi düşer; yorgun bir aile reisinin vicdan azabı. Ses boğazın altından fısıltıyla gelmeli.

---

### Elif (Muhafızın Eşi — Ocağın Direği)
- **Yaş:** 32–36
- **Ses Rengi / Tını:** Sıcak alto, berrak, metin, şefkatli fakat çetin kış şartlarına dayanıklı dirayetli kadın sesi.
- **Ağız / Şive:** Düzgün Orta Anadolu / Danişmendli Türkmen ağzı; yumuşak sesliler, samimi aile dili.
- **Duygu Aralığı:** Sadakat, koruyuculuk, tehlike karşısında sessiz ikaz, geçmiş travması (kaybedilen çocuk/yetimler) anıldığında kırılgan hüzün.
- **Nefes ve Duraklama:** Sakin ve kontrollü nefes alış; kapı arkasında fısıldarken nefesi mikrofona yakın tutma, söz aralarında kısa yutkunmalar.

#### Replik 1 (Kapı Arkasından İkaz / Sezgi)
- **TR:** `[kulağa fısıldar gibi, acele etmeden, gözleriyle kapı aralığını süzerken]` "Gözlerine bak bey... Avuçları nasırlı değil, kılıç kabzası tutmuş. Çiftçi dediğine kanma."
- **EN:** `[intimate whisper, unhurried, scanning through the gate slit]` "Look at his eyes, husband... His palms bear no plow calouses; they have gripped a sword hilt. Do not be deceived by his peasant garb."
- **Reji Notu:** Aceleci bir panik değil; kadın sezgisi ve soğukkanlı bir stratejist dikkati. "Bey" kelimesi hürmet ve yakınlık taşımalıdır.

#### Replik 2 (Ocak Başı / Gece Rahatlaması)
- **TR:** `[titreyen ellerini muhafızın omzuna koyarcasına, şefkatle]` "Bırak o pusatı köşeye gayrı... Sakalın buz tutmuş. Çorba kaynar, biraz ısın."
- **EN:** `[placing trembling hands gently on his shoulder, warm affection]` "Lay down that blade in the corner now... Frost clings to your beard. The broth simmers; come, thaw yourself."
- **Reji Notu:** Sığınak hissi yaratmalı. Dinleyene kış fırtınasının ardından sıcacık bir ocağın huzurunu geçirmelidir.

---

## 3. Köyün Çekirdek Sakinleri (10 Adlı Köylü)

---

### 1. Yusuf (Yetim Keçi Çobanı)
- **Yaş:** 12
- **Ses Rengi / Tını:** İnce, kırılgan, henüz çatallaşmamış çocuk sesi; zaman zaman çocuksu bir inatla yükselen tını.
- **Ağız / Şive:** Sade köy dili, devrik ve telaşlı cümleler.
- **Duygu Aralığı:** Öksüzlük hüznü, sadakat, korku, kayıp keçisi Karabaş anıldığında gözyaşına boğulacak gibi olma.
- **Nefes ve Duraklama:** Hızlı, kesik göğüs nefesi; ağlamamak için burnunu çekme, kekelemekten korkarak hızlı konuşma.

#### Replik 1
- **TR:** `[üşümüş, burnunu çekerek, titrek bir ısrarla]` "Karabaş dağda kalmadı muhafız emmi... Sesini duydum diyorum! Bırak gideyim, kurda kaptırmam onu!"
- **EN:** `[shivering, sniffing, tremulous insistence]` "Karabaş didn't perish on the mountain, uncle guard... I heard his bell, I swear it! Let me go, I won't let the wolves take him!"
- **Reji Notu:** İnatçı bir masumiyet. "Muhafız emmi" derken korku ile sığınma arzusu iç içe geçmeli.

#### Replik 2
- **TR:** `[kısık sesle, başını önüne eğerek, ipi parmaklarına dolarken]` "Babam da gelmedi Kösedağ'dan... Karabaş da giderse kim kalır benim yanımda?"
- **EN:** `[barely audible, head lowered, winding rough twine around fingers]` "Father never returned from Kösedağ either... If Karabaş is gone too, who do I have left?"
- **Reji Notu:** Boğazda düğümlenen derin öksüz kederi. Son heceler neredeyse kaybolmalıdır.

---

### 2. Miraen (Rum İpekçi & Şifacı Kadın)
- **Yaş:** 38
- **Ses Rengi / Tını:** Melankolik mezzo-soprano, kadife yumuşaklığında, bilge, hafif puslu tını.
- **Ağız / Şive:** Kırık Selçuklu Türkçesi (hafif Grek fonetiği; kelime başı 'h' seslerini yumuşatma, 'r' harflerini tane tane basma).
- **Duygu Aralığı:** Tevekkül, saklı bilgelik, yabancı sayılmanın tedirginliği, şifa verirken mutlak dinginlik.
- **Nefes ve Duraklama:** Yavaş, derin diyafram nefesi; her kelimeyi tartarak konuşur, bitkileri ezerken ritmik nefes verir.

#### Replik 1
- **TR:** `[alçak sesle, merhem kazanını karıştırırken, gözleri uzaklarda]` "Biz dağın bu yüzünü de öte yüzünü de biliriz muhafız... Acının dili birdir; Rum demez, Türkmen demez."
- **EN:** `[softly, stirring salve cauldron, eyes gazing into the distance]` "We know this side of the mountain and the far side alike, guard... Pain speaks one tongue; it knows neither Greek nor Turkmen."
- **Reji Notu:** Kadim bir bilgelik ve hümanizm. Asla didaktik olmamalı; yaşanmış bir sürgünün dinginliğiyle aktarılmalı.

#### Replik 2
- **TR:** `[fısıltıyla, bohçayı göğsüne bastırarak]` "Şu kuru adaçayıyla kantaronu al... Yara derinse tuz basma, bu yaprak dindirir sızıyı."
- **EN:** `[whispering, clutching herb pouch to her chest]` "Take this dried sage and St. John's wort... If the wound runs deep, do not rub salt; this leaf will soothe the throbbing."
- **Reji Notu:** Bir annenin ya da usta bir hekimin sakinleştirici fısıltısı.

---

### 3. Thessra (Taş Ustası & Mimar Kalfası)
- **Yaş:** 42
- **Ses Rengi / Tını:** Bas-bariton, tok, taşa taş vurur gibi sert ve ritmik konuşan ses.
- **Ağız / Şive:** Kapadokya/Konya taş işçisi Türkçesi; az kelimeli, net, köşeli telaffuz.
- **Duygu Aralığı:** Ustalık gururu, nizam takıntısı, dayanıksız harç ve gevşek sur karşısında küçümseyici öfke.
- **Nefes ve Duraklama:** Ağır tempolu, çekiç vuruşu gibi kesik duraklamalar; göğüsten derin soluk alış.

#### Replik 1
- **TR:** `[parmaklarını çatlak taşa sürterek, tok ve kesin]` "Harç kireç tutmamış, kum elenmemiş... Bu burç kış fırtınasına dayanmaz muhafız, yarın temelden sökerim."
- **EN:** `[running fingers over cracked masonry, curt and resolute]` "The mortar lacks lime, the sand was never sifted... This bastion will not withstand the winter gale, guard; tomorrow I tear it from the bedrock."
- **Reji Notu:** Tavizsiz bir mühendis netliği. Duygusallıktan uzak, mesleki otorite vurgulanmalı.

#### Replik 2
- **TR:** `[keskiyi yere bırakırken, memnuniyetsiz bir homurtuyla]` "İnsan çürür oğul, beylik dağılır... Ayakta kalan tek şey şu gönyeli taştır. Düzgün koymazsan altında kalırsın."
- **EN:** `[setting chisel down, disgruntled grunt]` "Man rots away, lad, realms crumble... The only thing that endures is square-cut stone. Lay it true, or it will crush you in your sleep."
- **Reji Notu:** Felsefi ama kaba bir taş ustası gerçekçiliği.

---

### 4. Sorhan (Kıpçak At Terbiyecisi & Levent Firarisi)
- **Yaş:** 30
- **Ses Rengi / Tını:** Çatlak bariton, gırtlaktan gelen bozkır tınısı, ansızın sertleşip sakinleşen dengesiz enerji.
- **Ağız / Şive:** Bozkır Kıpçak Türkçesi (genizden gelen 'ñ' tınısı, sert 'k' ve 'g' harfleri, devrik cümleler).
- **Duygu Aralığı:** Özgürlük tutkusu, at sevgisi, haksız kırbaca karşı gözü kara öfke, tetikte bekleyen firari ürkekliği.
- **Nefes ve Duraklama:** Kesik ve at soluması gibi hızlı nefes; konuşurken sanki dizgin tutuyormuş gibi gergin kas tonusu.

#### Replik 1
- **TR:** `[atın yelesini okşarken, dişlerinin arasından, tehditkâr]` "Bu ata sopa vuranın bileğini keserim muhafız! Bozkır atı kırbaçla değil, yürekle koşar."
- **EN:** `[stroking stallion's mane, through clenched teeth, menacing]` "Whoever lays a whip to this beast, I will sever his wrist, guard! A steppe courser runs on spirit, not the lash."
- **Reji Notu:** Yabani ve tehlikeli bir sadakat. Ses hafif hırıltılı ve gergin olmalıdır.

#### Replik 2
- **TR:** `[etrafı kollayarak, kısık sesle]` "Kışladaki subaşı peşimdedir bilirim... Amma beni bu dağda atımdan gayrı kimse yakalayamaz."
- **EN:** `[glancing over shoulders, hushed gravel]` "I know the garrison officer hunts my tracks... But in these crags, naught can catch me save my own horse."
- **Reji Notu:** Kaçak bir savaşçının gururlu meydan okuyuşu.

---

### 5. Karaca Usta (Ahi Demirci Reisi)
- **Yaş:** 52
- **Ses Rengi / Tını:** Gür bas, ocak ateşi gibi harlı, fütüvvet ahlakının vakarını taşıyan tok göğüs sesi.
- **Ağız / Şive:** Ahilik adabına uygun ölçülü, bilge, saygın Anadolu şehir Türkçesi.
- **Duygu Aralığı:** Zanaat onuru, adalet aşkı, hileli maden ve rüşvete karşı tavizsiz hiddet, babacan koruyuculuk.
- **Nefes ve Duraklama:** Ağır ve derin nefes; cümle sonlarında örse çekiç inmiş gibi tok bitişler.

#### Replik 1
- **TR:** `[örse çekiç vurur gibi tok bir sesle, gözlerini dikerek]` "Haram akçeyle alınan demir tav tutmaz muhafız! Ocağıma ne hileli maden sokarım ne de tartısı bozuk dirhem!"
- **EN:** `[striking anvil-like resonant tone, piercing gaze]` "Iron bought with tainted coin never tempers true, guard! Neither crooked ore nor shaved coin shall ever enter my forge!"
- **Reji Notu:** Ahi ahlakının sarsılmaz manifestosu. Göğüsten gürlemeli fakat bağırmamalıdır.

#### Replik 2
- **TR:** `[sıcak demiri suya daldırıp çıkan cızırtı arasında, sakin]` "Körük ciğer gibidir evlat... Nefesi kesilirse ateş söner, ateş sönerse nizam bozulur. Kapıyı sıkı tutasın."
- **EN:** `[amidst steam hiss as hot blade quenches, calm composure]` "The bellows are like lungs, son... Cut their breath and the fire dies; let the fire die and order collapses. Keep that gate fast."
- **Reji Notu:** Hayat tecrübesiyle yoğrulmuş bir nasihat. Cümle sonundaki uyarı kulağa küpe olacak ağırlıkta olmalı.

---

### 6. Aydoğdu (Emekli Kalkan Başı, Kışla İhtiyarı)
- **Yaş:** 58
- **Ses Rengi / Tını:** Pürüzlü, tütün ve köz kokan çatallı bariton; kışla emir komutası alışkanlığıyla bağırarak başlayan konuşma.
- **Ağız / Şive:** Eski Selçuklu kışla dili; askeri terimler, sert ve buyurgan emir kipleri.
- **Duygu Aralığı:** Kışla nostaljisi, genç nöbetçilere sitem, sağır kulağının getirdiği şüphecilik, savaş yarası sızısı.
- **Nefes ve Duraklama:** Hırıltılı soluk alma; konuşurken bir kulağını karşıdakine çevirme, ani ses yükselmeleri.

#### Replik 1
- **TR:** `[yüksek sesle, kulağını uzatarak, azarlarcasına]` "Ne dedin?! Sağır kulağıma doğru bağır! Kalkanı öyle gevşek tutarsan kaburgana ok yersin çömez!"
- **EN:** `[barking loudly, leaning in with good ear, reproaching]` "What did you mutter?! Shout into my good ear! Hold that buckler so slack and you'll catch a bodkin through your ribs, greenhorn!"
- **Reji Notu:** Kışla çavuşu refleksi. Karakter sağır olduğu için kendi sesini ayarlayamaz, yüksek perdeden girer.

#### Replik 2
- **TR:** `[bastonuna yaslanarak, derinden bir hırıltıyla]` "Kösedağ'da süvari hattını tutamadık... Bari şu köyün kapısını sağlam tutun da kemiklerimiz sızlamasın."
- **EN:** `[leaning heavily on crutch, guttural rasp]` "We failed to hold the cavalry line at Kösedağ... Hold this wretched gate fast at least, lest our bones turn in shame."
- **Reji Notu:** Askeri yenilginin ömür boyu geçmeyen utancı ve kederi.

---

### 7. Saruca Hatun (Köy Ocağının Anaç Reisi)
- **Yaş:** 50
- **Ses Rengi / Tını:** Tok alto, anaç, otoriter, köyün doymasını kendine dert edinmiş güçlü kadın sesi.
- **Ağız / Şive:** Yayla Türkmeni kadın ağzı; deyimler, atasözleri, zengin halk kelimeleri.
- **Duygu Aralığı:** Koruma içgüdüsü, ambar kaygısı, yetimlere karşı sonsuz merhamet, tembellere ve açgözlülere karşı sivri dilli öfke.
- **Nefes ve Duraklama:** Sürekli iş üstünde (hamur yoğururken, erzak tartarırken) verilen ritmik ve telaşsız nefesler.

#### Replik 1
- **TR:** `[elindeki tahta kepçeyi sallayarak, tavizsiz]` "Aç karın doyar muhafız, aç göz doymaz! Ambardaki son un çuvalını yetimlere ayırdım; kimse benden hovardalık beklemesin!"
- **EN:** `[shaking wooden ladle, uncompromising]` "An empty belly can be filled, guard; a greedy eye never! I set aside the last sack of meal for the orphans; let no soul expect indulgence from me!"
- **Reji Notu:** Köyün ambar bekçisi vakarı. Kepçeyi sallarken verdiği ritim ses tonuna yansımalıdır.

#### Replik 2
- **TR:** `[kısık sesle, şefkatle başını sallayarak]` "Şu sabilerin dudağı çatlamış ayazdan... Kazanın dibinde kalan aşı onlara bölüştür, yüzleri gülsün."
- **EN:** `[softened voice, tender nod]` "The little ones' lips are chapped raw from the freeze... Dish out what broth remains in the pot's belly to them; let warmth return to their cheeks."
- **Reji Notu:** Sert kabuğun altındaki sınırsız merhamet.

---

### 8. Ayşe Bacı (Bacıyan-ı Rum Teşkilatçısı & Dokumacı)
- **Yaş:** 40
- **Ses Rengi / Tını:** Kararlı mezzo, berrak, örgütleyici, hakkını arayan ve teşkilat disiplini taşıyan ses.
- **Ağız / Şive:** Ahilik çevresi şehir Türkçesi; kurallı, ikna edici, saygı uyandıran tını.
- **Duygu Aralığı:** Sosyal dayanışma, kadın emeğini koruma dirayeti, haksızlığa karşı dik duruş, sarsılmaz inanç.
- **Nefes ve Duraklama:** Düzgün ve ölçülü solunum; tezgâhın mekiği gibi ritmik konuşma akışı.

#### Replik 1
- **TR:** `[dik durarak, vakur bir tavırla]` "Kadının tezgâhı erkeğin kılıcından keskindir muhafız! Bacılar yün eğirip çadır dikmezse ordu ayazda kırılır."
- **EN:** `[standing upright, dignified bearing]` "A woman's loom cuts sharper than a soldier's blade, guard! If the sisters do not spin wool and stitch tents, armies perish in the winter gale."
- **Reji Notu:** Teşkilat lideri bilinci. Aşağılama yok, eşit ortaklık ve emek vurgusu var.

#### Replik 2
- **TR:** `[dokuma mekiğini tutarak, kararlı bir fısıltıyla]` "Köyü haramiye karşı sadece erkekler savunmayacak. Bacıların eteğinde gizli hançer bilenmiştir, bilesin."
- **EN:** `[gripping weaving shuttle, resolute whisper]` "It will not be men alone defending this stead against brigands. Daggers are honed beneath the sisters' aprons, mark my words."
- **Reji Notu:** Sakin ama ürkütücü bir kararlılık.

---

### 9. Hasan Çelebi (Sürgün Edilmiş Divan Kâtibi)
- **Yaş:** 34
- **Ses Rengi / Tını:** İnce bariton, fısıltılı, tedirgin, kâğıt hışırtısı gibi titrek ve mürekkep kokan bürokrat sesi.
- **Ağız / Şive:** Selçuklu divan dili; Arapça/Farsça terimler serpiştirilmiş, ağdalı ama korkudan kısalan cümleler.
- **Duygu Aralığı:** Paranoya, takip edilme korkusu, entelektüel kibir ile hayatta kalma acziyeti arasındaki çatışma.
- **Nefes ve Duraklama:** Hızlı, sığ göğüs nefesi; konuşurken arkasına bakma, fısıldarken nefes daralması.

#### Replik 1
- **TR:** `[koynundaki parşömene sarılarak, etrafı süzüp fısıldayarak]` "Sesini alçalt nöbetçi... Divandaki vezirlerin mührü kanlıdır. Bir satır yazı koca bir beyliği ateşe vermeye yeter."
- **EN:** `[clutching parchment in bosom, scanning surroundings in hushed dread]` "Lower your voice, sentry... The seals of divan viziers drip with blood. A single penned line suffices to reduce an entire realm to ash."
- **Reji Notu:** Sır saklayan bir devlet kâtibinin dehşeti. Her an hançerlenecekmiş gibi tetikte olmalıdır.

#### Replik 2
- **TR:** `[titreyen mürekkepli parmaklarını uzatarak, çaresiz]` "Beni o süvarilere teslim etme muhafız... Hakikati yazan kalemi kırarlar, beni de bir zindanda çürütürler."
- **EN:** `[extending ink-stained trembling fingers, helpless appeal]` "Do not yield me to those riders, guard... They snap the reed pen that scripts the truth, and leave the scribe to rot in a oubliette."
- **Reji Notu:** Acınası bir entelektüel çaresizlik.

---

### 10. Nogay (Bozkır Gözcüsü & İz Sürücü)
- **Yaş:** 45
- **Ses Rengi / Tını:** Kısık bas, rüzgâr uğultusu gibi boğuk, neredeyse fısıltıyla konuşan avcı sesi.
- **Ağız / Şive:** Bozkır Türkçesi; son derece kısa cümleler, ses taklitleri, az konuşma.
- **Duygu Aralığı:** Doğa ile bütünleşmiş soğukkanlılık, geçmiş günahların ağırlığı, seyreltilmiş vahşilik.
- **Nefes ve Duraklama:** Sessiz avcı nefesi; konuşurken nefesi duyulmaz, kelimeler arasında uzun dinleme duraklamaları vardır.

#### Replik 1
- **TR:** `[kulağını toprağa vermişken, başını kaldırmadan, boğuk]` "Rüzgâr tersine döndü muhafız... Vadide kurtlar değil, zırh şakırtısı var. On iki atlı, nal izleri taze."
- **EN:** `[ear pressed to earth, without raising head, guttural murmur]` "The wind has turned, guard... It is no pack of wolves down the glen, but clinking mail. Twelve mounted men, their hoofprints fresh."
- **Reji Notu:** İz sürücü ciddiyeti. Ses topraktan yükseliyormuş gibi alçak ve tok olmalıdır.

#### Replik 2
- **TR:** `[gözlerini kısıp dağa bakarak, sakin ve soğuk]` "İz yalan söylemez muhafız. İnsan sözüne değil, karda bıraktığı izin derinliğine bakacaksın."
- **EN:** `[narrowing eyes at distant ridge, cold certainty]` "Tracks never lie, guard. Trust not the tongue of man, but the depth of stride he stamps upon the snow."
- **Reji Notu:** Doğa kanunu gibi kesin ve tartışmasız.

---

## 4. Otuz Kapı Ziyaretçisi (30 Gate Visitors: `diyalog_01` – `diyalog_30`)

---

### Ziyaretçi 01 (`diyalog_01`): Hamza (Erzincanlı Yanık Rençber — Çiftçi)
- **Yaş:** 48
- **Ses Rengi:** Yanık bariton, boğuk, toprak ve duman yutmuş kaba köylü sesi.
- **Ağız / Şive:** Doğu Anadolu / Erzincan ova ağzı; 'ağa' yerine 'ağam', kalın sesliler.
- **Duygu Aralığı:** Yıkım sonrası çaresizlik, tohumuna duyduğu kutsal bağlılık, hırsızlık suçlamasında panik.
- **Nefes / Duraklama:** Ağır soluklar, isli öksürük araları, tohum torbasını göğsüne bastırırken iniltili nefes.

#### Replik 1 (Açılış)
- **TR:** `[boğuk, duman kokan bir nefesle, ellerini göğsündeki çıkına bastırarak]` "Selamün aleyküm muhafız ağa... Günlerdir dağ taş aşarım. Arkamda Moğol atlarının çiğnediği kül rengi ova kaldı. Elimde şu bir avuç tohumla bir çuval darıdan gayrı canım da yoktur. Tohumu kimseye çiğnetmem, toprağa gömerim."
- **EN:** `[gravelly, reeking of smoke, clutching chest bundle tightly]` "Peace be upon you, guard effendi... For days I have crossed mountain and stone. Behind me lies an ash-gray plain trampled by Mongol horses. In my hands I hold only this fistful of seed and a sack of millet. I will let no man tread upon this seed; I shall bury it into the earth."
- **Reji Notu:** Bir felaketten sağ çıkmış çiftçi hüznü. "Tohumu çiğnetmem" derken ses aniden sertleşmelidir.

#### Replik 2 (Sorgu Yanıtı / Yalan Şüphesi)
- **TR:** `[kekelediğini gizlemeye çalışarak, korkuyla gözlerini kaçırarak]` "T-tohum mu dedin ağam? Yok... Bey atını sürüp kaleye kapandı, ahaliyi ateşe saldı. Ben bu tohumu ambardan aşırmadım... Yani, tarlamın son başağıydı diyorum! Neft kokusu ovadan sindi üstüme, vallah billah hırsız değilim!"
- **EN:** `[faltering, nervously shifting eyes in mounting dread]` "S-seed, did you say, master? Nay... The Bey spurred his charger into the fortress and left folk to the flame. I pinched no seed from the granary... That is, 'twas the last ear of my own furrow, I say! The stench of pitch clings from the burning vale; by God, I am no thief!"
- **Reji Notu:** Suçluluk ve panik. İlk kelimede kekelemeli, sonra kendini savunmak için hızlanmalıdır.

---

### Ziyaretçi 02 (`diyalog_02`): Mahmut (Kayserili Çuhacı — Esnaf)
- **Yaş:** 50
- **Ses Rengi:** Orta bariton, kelimeleri tartan, ikna kabiliyeti yüksek tüccar tonu.
- **Ağız / Şive:** Kayseri çarşı ağzı; hızlı heceleme, tatlı dilli pazarlıkçı tonlama.
- **Duygu Aralığı:** Mala gelen ziyanın kederi, ticari kurnazlık, rüşvet teklif ederken yılışık tedirginlik.
- **Nefes / Duraklama:** Akıcı, kelime aralarında nefes almadan sıralama; kumaşı okşarken fısıltılı nefes.

#### Replik 1 (Açılış)
- **TR:** `[hızlı ve hesapçı, kucağındaki yün topunu göstererek]` "Kayseri çarşısının kumaşçısı derlerdi bana... Kırk dükkân yandı kül oldu da şu çuha topunu kucağıma basıp kaçtım. İçeriye bir tezgâh açayım, köyün donunu gömleğini dokurum muhafız; yabana atma beni."
- **EN:** `[brisk and calculating, presenting bolt of rough wool]` "They used to call me the clothier of the Kayseri bazaar... Forty stalls burned to ash, but I clutched this bolt of broadcloth to my bosom and fled. Let me set up a loom inside; I will weave tunic and smock for the whole village, guard; do not cast me aside."
- **Reji Notu:** Çarşı esnafı jargonu. Kederli anlatırken bile aklı ticarette olan bir ton.

#### Replik 2 (Rüşvet Teklifi)
- **TR:** `[kumaşın katını aralayıp parıltıyı göstererek, yılışık fısıltı]` "Şu çuhanın arasına bakıver muhafız... Kırk dirhem saf gümüş saklıdır. Yarısı senin kuşağına girsin, sürgüyü arala da içeri süzüleyim."
- **EN:** `[parting cloth fold to flash silver, sly murmur]` "Cast an eye beneath this wool, guard... Forty dirhams of pure silver lie tucked within. Let half slip into your sash, draw the latch, and let me slide inside."
- **Reji Notu:** Yılışık ve gizli pazarlık tonu. Başkası duymasın diye ses kısıktır.

---

### Ziyaretçi 03 (`diyalog_03`): Balaban (Sivas Bozgunu Neferi — Asker)
- **Yaş:** 28
- **Ses Rengi:** Sert bariton, kırık, öfke ve acı dolu kışla askeri sesi.
- **Ağız / Şive:** Sivas/Orta Anadolu askeri ağzı; devrik ve sert emir-itiraz dili.
- **Duygu Aralığı:** Bozgun utancı, komutanlara hiddet, bacak yarasının verdiği sancı, hayatta kalma hırsı.
- **Nefes / Duraklama:** Ağrıdan dişlerini sıkarak konuşma, her iki cümlede bir kesik inilti.

#### Replik 1 (Açılış)
- **TR:** `[kırık kargısına dayanarak, acıyla dişlerini sıkarak]` "Kargım kırıldı, sol bacağım da az kaldı. Sivas boğazında ordu dağıldı muhafız... Beyler kaçtı, nefer kılıç altında ezildi. Kapıyı açarsan kışlaya nefer olurum, açmazsan dağda kurda yem olurum."
- **EN:** `[leaning upon fractured spear, gritting teeth against searing pain]` "My spear is shattered, and my left thigh is near spent. In the Sivas gorge our host broke, guard... The lords fled on swift stallions; common soldiers were trampled under the blade. Barter me entry and I stand sentry in your garrison; bar me, and I become wolf meat upon the crags."
- **Reji Notu:** Onurlu ama ezilmiş bir asker. Acısını gizlemeye çalışırken sesi çatlamalıdır.

#### Replik 2 (Firar İtirafı / Öfke)
- **TR:** `[tükürerek, hınçla kargısını yere vurarak]` "Firari mi dersin bana?! Emir veren bey atını Kösedağ'da dağa sürdü be! Askeri ateşe salıp kaçan beye sadakat mi kalır? Canımı kurtardıysam pusatımla kurtardım!"
- **EN:** `[spitting bitterly, driving broken spear into dirt]` "You dare call me deserter?! The commander who barked our orders spurred his horse over Kösedağ at first blood! What loyalty is owed a lord who leaves his men to the slaughter? If I saved my skin, I bought it with steel!"
- **Reji Notu:** İsyan ve haysiyet patlaması. Bağırmak yerine boğazdan gelen sert bir gürleme.

---

### Ziyaretçi 04 (`diyalog_04`): Durmuş (Yaylası Yanan Çoban — Çiftçi)
- **Yaş:** 44
- **Ses Rengi:** Yumuşak tenor-bariton, saf, yayla rüzgarı yemiş dingin ve kederli köylü sesi.
- **Ağız / Şive:** Toros/Konya Türkmen yaylacı ağzı; saf, hayvanlarıyla konuşur gibi içten.
- **Duygu Aralığı:** Masumiyet, hayvanlarına düşkünlük, yurtsuz kalmanın çocuksu şaşkınlığı.
- **Nefes / Duraklama:** Yavaş, yayla havası çeker gibi geniş nefesler; iki koyununun boynunu okşarken duraklama.

#### Replik 1 (Açılış)
- **TR:** `[çan sesleri arasında, titreyen koyunun başını okşayarak]` "İki koyunum, bir kırık süt kabım kaldı elimde. Yaylamızı duman bürüdü, obayı haramiler dağıttı muhafız... Şu dilsiz hayvanların hatırına beni bir ağıl köşesine alasın."
- **EN:** `[amidst dull bell clinks, stroking trembling sheep]` "Two ewes and a dented milking pail are all that remain in my grasp. Smoke swallowed our high pasture; brigands scattered our tents, guard... For the sake of these dumb beasts, grant me corner in a fold."
- **Reji Notu:** Tevekkül dolu içten bir yakarış.

#### Replik 2 (Hastalık Şüphesi / Savunma)
- **TR:** `[koyunun yününü aralayıp gösterirken, telaşla]` "Uyuz değil ağam, vallah değil! Çalıya sürtündü garipler, dağda diken çoktu. İki güne kireç sürerim, sütü de köye bal olur."
- **EN:** `[parting wool fleece hurriedly, anxious pleading]` "It is no scabies, master, by God it is not! The poor wretches rubbed against briars; thorny brush runs thick on the heights. Two days with lime wash, and their milk will be sweet honey for your babes."
- **Reji Notu:** Masumiyetini ispatlama telaşı.

---

### Ziyaretçi 05 (`diyalog_05`): Veli (Örssüz Demirci Kalfası — Esnaf)
- **Yaş:** 24
- **Ses Rengi:** Metalik, tok tenor, kömür isi yutmuş sert ve enerjik delikanlı sesi.
- **Ağız / Şive:** Ahi çırak ağzı; saygılı ama işini bilen pratik konuşma.
- **Duygu Aralığı:** İş aşkı, ustasını geride bırakmanın vicdan azabı, güç gösterme arzusu.
- **Nefes / Duraklama:** Hızlı, göğüsten derin nefesler; kollarındaki kasları sıkarak konuşma.

#### Replik 1 (Açılış)
- **TR:** `[isli kollarını sıvayarak, gözleri kapı demirlerinde]` "Demirciyim ben... Örsüm kalmadı, körüğün yarısı yandı amma kollarım yerindedir. Köyün demirhanesinde çırak olayım, nal döveyim, kılıç bileyim; kuru ekmeğe razıyım."
- **EN:** `[pushing up soot-stained sleeves, eyeing gate strap-iron]` "Blacksmith is my trade... My anvil is gone, and half my bellows burned to ash, but the sinew in these arms remains true. Let me strike iron in your forge, shoe beasts, grind blades; dry crusts are all the wage I seek."
- **Reji Notu:** Genç bir ustanın özgüveni ve açlığı.

#### Replik 2 (Usta İtirafı)
- **TR:** `[başını eğerek, sesinde titremeyle]` "Ustam 'Kaç oğul, ateşi söndürme' dedi... Kendisi dükkânda kaldı, atlılar kapıyı kırdı. Ocağı tüttürmezsem ustamın kemikleri sızlar muhafız."
- **EN:** `[hanging head, tremor cracking vocal edge]` "My master shouted 'Flee, boy, keep the flame alive!'... He barred himself within as the horsemen battered down the portal. If I let the forge die out, his bones will find no rest, guard."
- **Reji Notu:** Vicdan azabının genç kalpteki ağırlığı.

---

### Ziyaretçi 06 (`diyalog_06`): Timur (Miğferi Yamuk Piyade — Asker)
- **Yaş:** 32
- **Ses Rengi:** Alaycı bariton, kuru, dünya gailesinden bıkmış sınır muhafızı tonu.
- **Ağız / Şive:** Uç askeri argosu; laubali ama tetikte, devrik cümleler.
- **Duygu Aralığı:** Bezginlik, hayatta kalma alaycılığı, silahını kaybetmenin gizli utancı.
- **Nefes / Duraklama:** Dudak bükerek nefes verme, omzunu silkerek konuşma.

#### Replik 1 (Açılış)
- **TR:** `[yamuk miğferini geriye itip alaycı bir sırıtışla]` "Selam olsun nöbetçi gardaş... Erzincan boğazında bir manga askerdik, kala kala şu yamuk miğferle ben kaldım. Kılıç dersen ekmeğe satıldı; surda nöbete adam ararsan içeri al."
- **EN:** `[shoving dented helm back with cynical smirk]` "Hail to you, sentry brother... We were a squad in the Erzincan defile; now naught remains save this crooked pot and my own skin. As for my sword, it was bartered for flatbread; if you need a warm body upon the parapet, let me pass."
- **Reji Notu:** Ölümden dönmüş adamın vurdumduymazlığı.

#### Replik 2 (Silah Utancı)
- **TR:** `[gözlerini kısıp dişlerini sıkarak]` "Kılıcı satmadım... Dağda yolumu kestiler, beş harami üstüme çullandı. Pusatımı aldılar amma canımı alamadılar gardaş. Savaş budur."
- **EN:** `[narrowing gaze, teeth clenched in irritation]` "I sold no blade... They set an ambush in the crags; five brigands swarmed my back. They stripped my steel, aye, but failed to strip my breath. That is war for you."
- **Reji Notu:** Gururu incinmiş askerin öfkesi.

---

### Ziyaretçi 07 (`diyalog_07`): Halil (Sabanı Kırık Rençber — Çiftçi)
- **Yaş:** 56
- **Ses Rengi:** Yaşlı bariton, çatlak, öksürüklü, kederli toprak adamı sesi.
- **Ağız / Şive:** İç Anadolu köylü ağzı; yavaş, uzatan heceler.
- **Duygu Aralığı:** Çaresizlik, yaşlılık yorgunluğu, tohumunun çürüme tehlikesi.
- **Nefes / Duraklama:** Ağır göğüs hırıltısı, iki lafta bir durup belini tutma.

#### Replik 1 (Açılış)
- **TR:** `[kırık saban demirini yere dayayarak, iniltiyle]` "Köyümüzü ateşe verdiler muhafız ağa... Kaçarken kağnı devrildi, öküz çatladı. Elimde şu kırık sabanla bir çinik arpa kaldı. Bu kış kapında ölürüm de geri dönemem."
- **EN:** `[resting cracked plowshare on frozen dirt, groaning softly]` "They set torch to our roofs, guard effendi... As we fled the ox-cart tipped, the beast burst its heart. All I bear is this shattered share and a peck of barley. I would sooner freeze at your gate than turn back."
- **Reji Notu:** Yaşlı ve takatsiz bir ihtiyarın son sığınağı.

#### Replik 2 (Arpa Tohumu)
- **TR:** `[arpa tanelerini avucunda ovuşturarak]` "Arpa tohumu nem aldı oğul... Üç güne toprağa düşmezse küflenir çürür. Bana değil, şu tohuma acı."
- **EN:** `[rubbing grain between calloused palms]` "The barley has taken damp, son... If it finds no furrow in three days, it rots into black mildew. Pity not my grey hairs, but pity the grain."
- **Reji Notu:** Toprak adamının tek derdinin mahsul oluşu.

---

### Ziyaretçi 08 (`diyalog_08`): Cebrail (Kunduracı/Dikici Çırağı — Esnaf)
- **Yaş:** 19
- **Ses Rengi:** Tiz tenor, ürkek, heyecanlı, genç zanaatkar sesi.
- **Ağız / Şive:** Şehir esnafı çırak ağzı; hızlı, saygılı, hafif peltek.
- **Duygu Aralığı:** Korku, kendini kanıtlama telaşı, heybedeki gümüş tokanın tedirginliği.
- **Nefes / Duraklama:** Kesik kesik, telaşlı soluk alış, heybesini sıkıca kavrama.

#### Replik 1 (Açılış)
- **TR:** `[elindeki bızı ve meşin parçasını sallayarak, titrek]` "Çarşımız kül olduğunda dükkândan canımı zor kurtardım muhafız ağa... Deri delerim, çarık dikerim, köylünün çarığını onarırım. Bir tas çorbaya sabaha kadar dikerim."
- **EN:** `[waving awl and scrap leather, trembling voice]` "When the bazaar turned to ash I barely dragged my skin from the shop, guard effendi... I punch hide, stitch moccasins, mend torn boots for the folk. For one bowl of broth I will sew until dawn."
- **Reji Notu:** Açlıktan titreyen genç bir çırak.

#### Replik 2 (Heybedeki Toka)
- **TR:** `[heybesini arkasına saklayarak, gözleri fıldır fıldır]` "Heybede ne mi var? Yok bir şey ağam... Eski köseleler, balmumu bir de... Bir de yolda konağın külünden bulduğum toka... Çalmadım vallah!"
- **EN:** `[shielding pack behind back, shifting eyes rapidly]` "What lies in the pack? Naught, master... Old rawhide scraps, beeswax, and... and a clasp plucked from a burned manor's rubble... By God, I stole it not!"
- **Reji Notu:** Yakalanmış çocuk paniği.

---

### Ziyaretçi 09 (`diyalog_09`): Arslan (Oku Tükenmiş Kemankeş — Asker)
- **Yaş:** 29
- **Ses Rengi:** Soğuk, keskin bariton, az konuşan çelik gibi sert avcı/okçu sesi.
- **Ağız / Şive:** Uç boyu okçu Türkçesi; son derece net, keskin sessizler, lüzumsuz laf yok.
- **Duygu Aralığı:** İntikam arzusu, konsantrasyon, boş sadağın verdiği burukluk.
- **Nefes / Duraklama:** Yay çeker gibi kontrollü, derin ve sessiz nefes; konuşmadan önce hedef süzer gibi bekleme.

#### Replik 1 (Açılış)
- **TR:** `[boş sadağını gösterip yayına yaslanarak, buz gibi bir sesle]` "Uç boyunun kemankeşiyim muhafız... Yayım sağ salim amma sadakta ok kalmadı. Kulede nöbete durayım; yay kirişini çekerim, gözüm kartal gibidir."
- **EN:** `[displaying empty quiver, resting on recurve bow, icy tone]` "I am an archer of the march marches, guard... My bow is whole, yet my quiver gapes barren. Let me keep watch upon your bastion; I draw a heavy cord, and my eye spots like an eagle."
- **Reji Notu:** Keskin, tehlikeli ve kendinden emin.

#### Replik 2 (İntikam Yemini)
- **TR:** `[parmağındaki kemik zihgiri sıkarak, kısık ve zehirli]` "Son okumu kime mi attım? Arkadaşımı arkadan vuran kalleş yüzbaşıya! Yine gelse yine vururum. Buraya da saklanmaya değil, yayımı kırmaya gelmedim."
- **EN:** `[tightening bone thumb-ring, low venomous edge]` "At whom flew my final arrow? At the treacherous captain who skewered my comrade in the spine! Were he to rise again, I'd skewer him twice over. I came not to cower, nor to unstring my bow."
- **Reji Notu:** Bastırılmış soğuk nefret.

---

### Ziyaretçi 10 (`diyalog_10`): Yunus (Testili Yetim Obalı — Çiftçi)
- **Yaş:** 20
- **Ses Rengi:** Kederli tenor, kırılgan, susuzluk ve yastan boğulmuş yumuşak ses.
- **Ağız / Şive:** Güney/Toros Yörük ağzı; içli, türkü söyler gibi yanık tonlama.
- **Duygu Aralığı:** Matem, kutsal emanete sadakat, dünya kaygısını yitirmiş dinginlik.
- **Nefes / Duraklama:** Yavaş yutkunmalar, testiyi kucağında bebek gibi tutarken derin soluklar.

#### Replik 1 (Açılış)
- **TR:** `[kucağındaki sırlı testiyi sımsıkı tutarak, gözleri nemli]` "Obamız kuraklıktan ve baskından dağıldı ağam... Elimde şu sırlı testi kaldı. İçinde su sanırsın amma atalarımın son bağ şırasıdır. Bana bir saçak altı verin, testiyi köyün kütüğüne dökeyim."
- **EN:** `[cradling glazed earthenware jug, misty gaze]` "Our clan was shattered by drought and raiders, master... All that remains in my arms is this glazed jug. You might deem it plain water, yet 'tis the final grape nectar of our fathers' vines. Grant me eaves for shelter, and I pour it out upon your roots."
- **Reji Notu:** Aile ocağının son hatırasını taşıyan gencin kırık sesi.

#### Replik 2 (Merhamet İmtihanı)
- **TR:** `[testiyi öpüp muhafıza uzatarak]` "Bir yudum al muhafız... Zehir değil bu, dedemin diktiği asmanın bereketi. Bizi kapıda kurda bırakırsan bu bereket dağda kurur."
- **EN:** `[kissing the jug rim, proffering it gently]` "Take a sip, guard... 'Tis no poison, but the blessing of vines my grandsire rooted. If you abandon us to the wolves, that blessing withers upon the stone."
- **Reji Notu:** Samimi, dokunaklı bir teslimiyet.

---

### Ziyaretçi 11 (`diyalog_11`): Sinan (Yaralı Köprü Nöbetçisi — Asker)
- **Yaş:** 35
- **Ses Rengi:** Boğuk, hırıltılı bariton; kan kaybı ve ateşten titreyen savaşçı sesi.
- **Ağız / Şive:** Uç askeri dili; emir kipleri acı iniltileriyle karışır.
- **Duygu Aralığı:** Can havli, askeri haber verme sorumluluğu, kangren korkusu.
- **Nefes / Duraklama:** Çok kesik nefesler, konuşurken yarasını tutup inleme.

#### Replik 1 (Açılış)
- **TR:** `[sarılı kolundan kan sızarken, kapıya yaslanıp soluk soluğa]` "Kalkanım çatlak, kolum sargılıdır muhafız ağa... Geçitteki taş köprüyü tuttuk amma sel gibi geldiler. Yaram kangrene döner, bir hekim merhemi sürün; süvari arkamdan yetişmeden kapıyı peyleyin!"
- **EN:** `[blood seeping through arm binding, slumping against gate, breathless]` "My shield is fractured, my arm bound in rags, guard effendi... We held the arched bridge at the pass, but they poured like flash flood. My flesh rots to gangrene; bind it with apothecary salve, and bar the timbers before their vanguard crests the ridge!"
- **Reji Notu:** Hem istihbarat getiren hem de canını kurtarmaya çalışan askerin telaşı.

#### Replik 2 (Geri Çekilme Korkusu)
- **TR:** `[gözleri kararak, güçlükle ayakta durarak]` "Korkup kaçmadım... Onbaşı öldü, sancak düştü! Yalnız başıma köprü tutulmazdı muhafız... Yaramı sarın, kılıç tutacak el kalırsa sura çıkarım."
- **EN:** `[vision dimming, swaying on boots]` "I fled not from terror... The corporal fell, our banner trampled! No lone man could hold that span, guard... Cleanse the rot; if these fingers can yet grip a pommel, I mount your walls."
- **Reji Notu:** Şuurunu kaybetmek üzere olan askerin son gücü.

---

### Ziyaretçi 12 (`diyalog_12`): Davut (Gezgin Bakırcı/Kalaycı — Esnaf)
- **Yaş:** 41
- **Ses Rengi:** Şakacı, kıvrak tenor-bariton; tekinsiz bir sokak neşesi ve kurnazlık taşıyan ses.
- **Ağız / Şive:** Gezgin Ahi/Çingene esnaf tınısı; kelimeleri uzatarak, manalı gülüşlerle.
- **Duygu Aralığı:** Şakacılık, tekinsiz pazarlık, kaçak madeni saklama gerilimi.
- **Nefes / Duraklama:** Akıcı ve neşeli, birdenbire ciddileşen nefes tutuşları.

#### Replik 1 (Açılış)
- **TR:** `[eşeğin sırtındaki kazanları şakırdatarak, geniş bir tebessümle]` "Aşağı nahiyelerin kalaycısıyım muhafız... Eşeğim topal amma kazanım parıldar! Köyün kararmış tencerelerini kalaylayayım, bakır tasları parlatayım. İçeri alırsan şu sarı tası da sana bağışlayayım."
- **EN:** `[clattering kettles upon donkey, broad sly grin]` "Tinker of the lower townships am I, guard... My beast limps, yet my skillets shine bright! Let me tin the village's soot-blackened pots, burnish your copper bowls. Grant me entry and this yellow vessel is yours to keep."
- **Reji Notu:** Neşeli ve sempatik görünmeye çalışan tekinsiz seyyar satıcı.

#### Replik 2 (Kaçak Cıva/Kalay)
- **TR:** `[kulağına eğilip göz kırparak, kısık]` "Kazanın dibinde ne mi var? Boş ver dibini muhafız ağa... Simyacıların aradığı has cıvadır o. Fazla kurcalama, payını al, işimize bakalım."
- **EN:** `[leaning close with wink, whispered rasp]` "What sits beneath the kettle floor? Pay no heed to bottoms, guard effendi... 'Tis pure quicksilver alchemists lust after. Ask no deep questions, pocket your share, and let us prosper."
- **Reji Notu:** Açık rüşvet ve kaçakçılık sırdaşlığı.

---

### Ziyaretçi 13 (`diyalog_13`): Mehmed (Topal Oğlaklı Çoban — Çiftçi)
- **Yaş:** 38
- **Ses Rengi:** Yanık bariton, inatçı, dağ soğuğundan çatlamış kaba ses.
- **Ağız / Şive:** Sert dağlı Türkmen ağzı; kısa, buyurgan ama merhamet dilenen ton.
- **Duygu Aralığı:** Can yoldaşı oğlağa bağlılık, harami korkusu, çaresiz öfke.
- **Nefes / Duraklama:** Burnundan soluyan, yaralı hayvanı kucağında tutmaktan yorulmuş ağır nefes.

#### Replik 1 (Açılış)
- **TR:** `[kucağındaki yaralı oğlağı hırkasıyla örterek, sert ve kederli]` "Yamaçtaki ağılın çobanıyım... Dün gece haramiler bastı; sürüyü dağa sürdüler, şu topal oğlak ayağıma sığındı. Sağlamı götüren harami bunu boğazlayacaktı, vermedim! Bizi içeri al muhafız, ağılda çoban durayım."
- **EN:** `[swaddling crippled kid in wool cloak, curt yet sorrowful]` "Herdsman of the hillside pens am I... Brigands struck yestereve; drove the flock into crags, and this lame kid huddled at my boots. The robbers took the fat sheep and would have slit this one's throat; I yielded him not! Take us within, guard; I will tend your village fold."
- **Reji Notu:** Sert tabiatlı dağlının tek bir hayvana duyduğu dokunaklı sevgi.

#### Replik 2 (Oğlağı Kesme Şartına İsyan)
- **TR:** `[oğlağı göğsüne siper ederek, dişlerini sıkarak]` "Oğlağı kesip kazana mı atalım dersin?! Olmaz muhafız! Onu kurda vermedim, senin çorbana da kurban etmem. Gerekirse ayazda donarız amma bunu kestirmem!"
- **EN:** `[shielding kid with torso, gnashing teeth]` "You bid me slaughter the babe for your stewpot?! Never, guard! I withheld him from wolf fangs; I shall not surrender him to your ladle. We would sooner freeze in the blizzard than see his blood spilt!"
- **Reji Notu:** Şiddetli ve ödünsüz bir koruma refleksi.

---

### Ziyaretçi 14 (`diyalog_14`): Şemsettin (Kaya Tuzu Tüccarı — Esnaf)
- **Yaş:** 54
- **Ses Rengi:** Kuru, tuzdan çatlamış gıcırdayan bas-bariton; ağırbaşlı ve yorgun kervancı.
- **Ağız / Şive:** Çankırı/Tuz Gölü kervan ağzı; kelimeleri uzatan, boğaz temizleyen ton.
- **Duygu Aralığı:** Yorgunluk, ticari ağırbaşlılık, kervanının basılmasının hüznü.
- **Nefes / Duraklama:** Tuz yutmuş gibi kuru öksürükler, derin ve ağır nefes verişler.

#### Replik 1 (Açılış)
- **TR:** `[tuz torbasını yere bırakırken, kuru bir öksürükle]` "Tuz gölünden kervan düzüp dağ köylerine mal taşırdım muhafız... Kar bastırdı, katırlar uçuruma yuvarlandı. Elimde şu üç çuval has kaya tuzu kaldı. Tuzsuz aş, dirliksiz köy olmaz; ambarınıza tuz dökeyim, beni içeri salın."
- **EN:** `[heaving salt sack to the slush, parched cough]` "I rigged a train from the Salt Lake, hauling rock to highland hamlets, guard... Blizzard blindfolded the pass; three mules tumbled down the ravine. All that remains are these three sacks of pure crystal. No stew tastes sweet without salt, no stead thrives without savor; let me salt your pantry, and grant me roof."
- **Reji Notu:** Ağırbaşlı, yaşını başını almış tuz tüccarının yorgunluğu.

#### Replik 2 (Güherçile Şüphesi)
- **TR:** `[tuzu tadıp parmaklarını silerek]` "Tuzun içinde barut tozu mu var dedin? Tövbe de muhafız! Dağ tuzu acıdır amma öldürmez. İftira atıp malıma çökeceksen açık söyle."
- **EN:** `[tasting salt grain, wiping fingertips]` "Powder for cannons mixed in the brine, you say? Bite your tongue, guard! Mountain salt bites sharp, but slays no man. If you seek false pretexts to seize my lading, speak it plain."
- **Reji Notu:** Malına laf söyletmeyen eski tüccar gururu.

---

### Ziyaretçi 15 (`diyalog_15`): Hamit (Kaçak Kule Borazancısı — Asker)
- **Yaş:** 26
- **Ses Rengi:** Titrek tenor, nefesi daralan, dehşet görmüş gözcü neferi sesi.
- **Ağız / Şive:** Kışla askeri Türkçesi; kesik, aceleci ve panik dolu.
- **Duygu Aralığı:** Korku, suçluluk duygusu, can havli, borusunu çalmanın getirdiği vicdan azabı.
- **Nefes / Duraklama:** Hızlı nefes alışlar, göğüs kafesi inip kalkarken kelimeleri yutma.

#### Replik 1 (Açılış)
- **TR:** `[pirinç borazanını göğsüne bastırarak, gözleri yuvalarından fırlamış]` "Tepe gözetleme kulesinin borazancısıyım muhafız! Kuleyi bastılar... Dumanı gördüm, boruyu çaldım amma ovada toplanacak er kalmamıştı! Kaçtım... Kapıyı açın, surda boru çalayım, yaklaşan haramiyi ilk ben haber vereyim!"
- **EN:** `[clutching brass horn to breast, wild staring eyes]` "Watchman of the high tower am I, guard! They overran the bastion... I saw the black plume, I sounded the horn, yet no host remained upon the plain to rally! I fled... Open the gate; I will wind the horn upon your battlements, the first to warn of brigand tread!"
- **Reji Notu:** Şok halindeki askerin telaşlı nefesi.

#### Replik 2 (İhanet Şüphesi)
- **TR:** `[titreyerek, fısıltıyla]` "Kuleyi ateşe verenlerin arasında... amcamın oğlunu gördüm muhafız. Göz göze geldik; kılıcı boğazıma dayamadı, 'Kaç' dedi. Ben hain değilim... kan bağına yenildim!"
- **EN:** `[shuddering, broken whisper]` "Among those who set torch to the keep... I saw my own uncle's seed, guard. Our eyes locked; he stayed his blade from my throat and hissed 'Run.' I am no traitor... my own blood unmanned my hand!"
- **Reji Notu:** Dehşet verici bir aile sırrının itirafı.

---

### Ziyaretçi 16 (`diyalog_16`): Pir Nazar (Asma Fidanlı Bağcı — Çiftçi)
- **Yaş:** 62
- **Ses Rengi:** Puslu, bilge bas-bariton; toprağı koklayan, aşık bir derviş-çiftçi sesi.
- **Ağız / Şive:** Tokat/Amasya bağcı ağzı; şiirsel, aheste ve sabırlı konuşma.
- **Duygu Aralığı:** Toprak aşkı, geleceğe umut, kış ayazına meydan okuyan dinginlik.
- **Nefes / Duraklama:** Yavaş, derin nefesler; fidanın kökünü ıslak beze sararken sevgi dolu duraklamalar.

#### Replik 1 (Açılış)
- **TR:** `[ıslak çula sarılı asma fidanını göstererek, gözlerinde ışıltıyla]` "Aşağı vadinin bağ bekçisiyim muhafız... Asmaları ateşe verdiler amma şu has kökü bezde sakladım. Üç yıla kalmaz bala döner üzümü; sabrı olan var mıdır bu köyde? Beni içeri salın, güney yamacınıza bağ dikeyim."
- **EN:** `[holding vine cutting swaddled in damp burlap, eyes luminous]` "Vinedresser of the lower glen am I, guard... They put torches to the arbors, but this prized root I saved in damp cloth. In three seasons its cluster turns to sweet honey; is there patience enough in this village? Let me pass, and I plant an orchard upon your southern slope."
- **Reji Notu:** Yaşlı adamın toprağa duyduğu sarsılmaz inanç.

#### Replik 2 (Şaraplık Üzüm İtirafı)
- **TR:** `[bıyık altından tebessümle, fısıltılı]` "Bu sıradan sofralık üzüm değildir oğul... Sıkarsan cana can katan has şıra verir. Molla duyarsa haram der amma kış ayazında donan askeri bu diriltir."
- **EN:** `[faint smile beneath grey mustache, conspiratorial whisper]` "This is no common table grape, son... Press it, and it yields draft that breathes life into frozen marrow. The mullah decries it as sin, yet in winter freeze 'tis what keeps a sentry breathing."
- **Reji Notu:** Dünyayı görmüş geçirmiş bir bağcının hoşgörüsü.

---

### Ziyaretçi 17 (`diyalog_17`): İshak (Dirhemleri Şakırdayan Kantarcı — Esnaf)
- **Yaş:** 47
- **Ses Rengi:** İnce, hesapçı bariton; her şeye kuşkuyla bakan, titiz çerçi sesi.
- **Ağız / Şive:** Şehir esnafı Türkçesi; tane tane, resmi ve adli terimlerle.
- **Duygu Aralığı:** Titizlik, adalet iddiası, hileli dirhem yakalandığında kıvırma telaşı.
- **Nefes / Duraklama:** Terazinin kefesini dengeler gibi ölçülü, kısa duraklamalı konuşma.

#### Replik 1 (Açılış)
- **TR:** `[kuşağındaki pirinç dirhemleri şakırdatarak, dik bakışlarla]` "Yaylaları dolaşıp yün ve boya otu tartan kantarcıyım muhafız... Terazi doğru tartar da tartan el düzgün müdür derler? Benim kefemde kıl payı hile yoktur. Köyün pazarına adil kantar kurayım, beni içeri salasın."
- **EN:** `[jingling brass weights in sash, sharp pedantic gaze]` "Weigher of mountain fleece and madder dye am I, guard... Folk say the scale weighs true, yet is the hand that tips it honest? On my pans, not a hairsbreadth of deceit balances. Let me pitch an honest balance in your square, and let me pass."
- **Reji Notu:** Kendi dürüstlüğünü kanıtlamaya çalışan esnaf tonu.

#### Replik 2 (Hileli Dirhem Yakalandığında)
- **TR:** `[eli ayağına dolaşarak, dirhemi avucuna saklamaya çalışarak]` "Dirhemin altı mı zımparalanmış?! Yok muhafız ağa... Sürtünmekten aşınmıştır o! Kervan yolunda taş değdi kefeye... Vallahi kasıt yoktur, ver onu yerine yenisini koyayım!"
- **EN:** `[fumbling in panic, concealing weight in fist]` "The bottom filed down, you say?! Nay, guard effendi... Worn thin from constant rubbing, surely! On rocky trails the pan scraped against granite... By God, no deceit was planned; return it and I substitute an untainted lead!"
- **Reji Notu:** Suçüstü yakalanan düzenbazın telaşı.

---

### Ziyaretçi 18 (`diyalog_18`): Rüstem (Kireç Lekeli Kale Irgatı — İşçi)
- **Yaş:** 40
- **Ses Rengi:** Çok kalın bas, çatlak, kaba, tozdan boğulmuş beden işçisi sesi.
- **Ağız / Şive:** Kaba köylü/ırgat dili; kısa, dolaysız, lafı eğip bükmeyen tavır.
- **Duygu Aralığı:** Öfke, ezilmişlik gururu, fiziksel güç, komutana duyulan hınç.
- **Nefes / Duraklama:** Ağır göğüs nefesi, taş kaldırırken verilen tok "hıh" sesleri.

#### Replik 1 (Açılış)
- **TR:** `[kireçli nasırlı ellerini açarak, kamburunu dikleştirip tok bir sesle]` "Kale hendeğinde taş taşıyan, harç karan ırgatım muhafız... Kireç eti yakar, taş omzu çökertir amma duvar dimdik durur! Bana bir somun ekmek verin, köyün çöken burcunu üç günde omuzlayıp kaldırayım."
- **EN:** `[spreading lime-caked calloused palms, straightening stoop, booming tone]` "Bearer of stone and mixer of mortar in the moat ditch am I, guard... Quicklime scorches the flesh, granite bows the spine, yet the rampart stands upright! Feed me one crust of flatbread, and I shoulder your collapsed parapet whole in three days."
- **Reji Notu:** Kaba, sert ve muazzam bir iş gücünün sesi.

#### Replik 2 (Yolsuzluk İtirafı)
- **TR:** `[omzundaki morluğu göstererek, dişlerini sıkarak]` "Kale komutanı harçtan taş çaldı muhafız! 'Duvar sağlam değil' dedim diye beni kireç ocağında dövdüler. Kaçtım... Susturmak için peşime adam saldılar."
- **EN:** `[baring purple welt on shoulder, teeth grinding]` "The castellan skimped stone from the core, guard! When I muttered 'This revetment is hollow,' they lashed me across the lime kiln. I broke free... and they slipped dogs upon my heels to seal my jaws."
- **Reji Notu:** Haksızlığa uğramış işçinin saf öfkesi.

---

### Ziyaretçi 19 (`diyalog_19`): Haydar (Teknesi Sırtında Fırıncı — Esnaf)
- **Yaş:** 45
- **Ses Rengi:** Sıcak, telaşlı bariton; un kokan, ekmek pişirme tutkusuyla dolu samimi ses.
- **Ağız / Şive:** Şehir fırıncısı ağzı; aceleci, iştah açıcı konuşma.
- **Duygu Aralığı:** Ekmek aşkı, aç kalma korkusu, ununun bozulma endişesi.
- **Nefes / Duraklama:** Hızlı nefesler, konuşurken sürekli elini un silker gibi çırpma.

#### Replik 1 (Açılış)
- **TR:** `[sırtındaki gürgen ekmek teknesini indirerek, unlu elleriyle]` "Menzil hanının fırıncısıyım muhafız... Fırına atlılar daldı, buğdayı çiğnedi amma şu tekneyle iki çuval elenmiş unumu kurtardım. Ekmek külde de pişer muhafız, yeter ki ocak tütsün! Aç kapıyı, köyü somunsuz bırakmayayım."
- **EN:** `[heaving beechwood kneading trough from shoulders, dusting floury palms]` "Baker of the staging caravanserai am I, guard... Horsemen burst into the bakehouse and fouled the grain, yet I saved this trough and two sacks of bolted flour. Bread bakes even in ashes, guard, so long as the hearth smokes! Draw the bolts; let me keep this village from starving for bread."
- **Reji Notu:** Mesleğine tutkun, ekmek kutsallığına inanan ustanın enerjisi.

#### Replik 2 (Çavdar Mahmuzu Şüphesi)
- **TR:** `[un torbasını açıp koklatırken, telaşla]` "Kara un mu dedin? Çavdar mahmuzu zehirli olur bilirim muhafız, tövbe ben ona el sürmem! Bu has sarı buğdaydır; köylüyü delirtmek değil, doyurmak isterim."
- **EN:** `[opening flour sack for inspection, agitated protest]` "Blackened grain, you say? Ergot is poison, I well know, guard; God forbid I touch such blight! This is pure golden durum; I seek to feed your folk, not drive them mad with fever."
- **Reji Notu:** Zehirleme suçlamasına karşı samimi dehşet.

---

### Ziyaretçi 20 (`diyalog_20`): Seyfi (Ayağına Çivi Batmış Nalbant — Esnaf)
- **Yaş:** 37
- **Ses Rengi:** Sert, tok bariton; acıdan dişlerini sıkan, soğuk demirci sesi.
- **Ağız / Şive:** Uç boyu nalbant ağzı; küfürlü, mert, doğrudan konuşan.
- **Duygu Aralığı:** Fiziksel acı, mesleki maharet, haramilere nal çakmış olmanın gizli gerilimi.
- **Nefes / Duraklama:** Topallarken her adımda kesik tıslamalar, acıdan iniltili nefes.

#### Replik 1 (Açılış)
- **TR:** `[tek ayağı üstünde sekerek, elindeki nalbant kerpetenine dayanıp inleyerek]` "Kervan yollarının seyyar nalbantıyım muhafız... Kancık bir kısrak tepti, paslı nal çivisi topuğuma gömüldü! Basamıyorum gayrı... İltihap kemiğe yürümeden ayağımı dağlayın; kışlanın atlarını nallayayım, kapıyı açın!"
- **EN:** `[hopping on one heel, leaning on farrier's pincers with a groan]` "Farrier of the caravan routes am I, guard... A vicious mare lashed out, and a rusted horseshoe nail drove clean into my heel! I cannot plant weight... Sear the flesh before rot creeps to the marrow; I will shoe the garrison's beasts, only draw the bar!"
- **Reji Notu:** Dişini sıkan sert bir ustanın dayanılmaz acısı.

#### Replik 2 (Harami Nalı İtirafı)
- **TR:** `[çantasından çıkan damgalı nalı görünce yutkunarak]` "O naldaki kurt pençesi damgasını mı sorarsın? Dağda yolumu kestiler muhafız... 'Reisin atını nalla, yoksa derini yüzeriz' dediler. Can korkusuyla çaktım o nalı; ben harami yatağı değilim!"
- **EN:** `[swallowing hard as the wolf-claw stamped shoe drops]` "You question that wolf-claw stamp upon the iron? They trapped me in the ravine, guard... 'Shoe the chieftain's charger or we flay your hide,' they hissed. In terror of my life I drove those nails; I am no brigand's accomplice!"
- **Reji Notu:** Ölüm tehdidi altında kalmış sivil zanaatkarın kendini savunması.

---

### Ziyaretçi 21 (`diyalog_21`): Seyyid Burhan (Kalenderi Derviş — Gezgin)
- **Yaş:** 65
- **Ses Rengi:** Derin bas-bariton, puslu, ney sesi gibi buğulu ve dingin sufi sesi.
- **Ağız / Şive:** Tasavvufi Selçuklu Türkçesi; kinayeli, latifeli, dünyayı aşmış bir üslup.
- **Duygu Aralığı:** Mutlak tevekkül, gizli bilgelik, ölüm ve soğuk karşısında kayıtsız tebessüm.
- **Nefes / Duraklama:** Çok yavaş, derin diyafram nefesi; kelimeler arasında derin sükût aralıkları.

#### Replik 1 (Açılış)
- **TR:** `[asasına yaslanıp tebessüm ederek, derinden gelen buğulu bir sesle]` "Yolcuya kapı, taşa toprak sorulmaz muhafız... Yayla çobanının anasından selam getirdim obanıza. Dünya bir handır; kapıyı bekleyen de göçer bir gün, geçen de... Açarsan bir hasır köşesi yeter, açmazsan kar örtümüz olur."
- **EN:** `[leaning on rough staff, serene smile, deep resonant voice]` "To the traveler one asks no portal, to the boulder no soil, guard... I bear tidings from the upland shepherd's mother to your hearth. The world is but a caravanserai; he who guards the gate departs one dawn, as does he who passes through... Open, and a reed mat suffices; keep it barred, and the snow becomes our shroud."
- **Reji Notu:** Dinleyenin içine işleyen bir sükûnet. Korkutucu değil, büyüleyici olmalıdır.

#### Replik 2 (Ferman Sırrı)
- **TR:** `[cübbesinin astarından parşömeni çıkarıp kinayeyle fısıldayarak]` "Bu ipek fermanı Moğol elçisinin koynundan aldım oğul... İçinde beyliğin hangi kalelerinin satıldığı yazar. Dünyanın saltanatı kâğıttan ibarettir; oku da gör nizamı."
- **EN:** `[drawing silk-wrapped scroll from robe lining, wry whisper]` "This silk scroll I slipped from a Mongol envoy's dead sash, son... Within is penned which keeps of your realm are already bargained away. Earthly dominion is wrought of brittle paper; read, and behold your lords' order."
- **Reji Notu:** Acı bir hakikati fısıldayan derviş vakarı.

---

### Ziyaretçi 22 (`diyalog_22`): Hacı Behram (Tebriz Kervan Tüccarı — Esnaf)
- **Yaş:** 52
- **Ses Rengi:** Kadife yumuşaklığında bariton, akıcı, Farsça edalı, kurnaz ve nezaket maskeli tüccar sesi.
- **Ağız / Şive:** Tebriz / Azeri-Fars aksanı; yumuşak 'k' ve 'g' harfleri, ağdalı iltifatlar.
- **Duygu Aralığı:** Ticari nezaket, saklı kibir, Moğol payzası sorgulandığında soğuk tedirginlik.
- **Nefes / Duraklama:** İpek gibi pürüzsüz akış; konuşurken ellerini ovuşturma, kelimeleri uzatma.

#### Replik 1 (Açılış)
- **TR:** `[elini göğsüne koyup zarifçe eğilerek, yumuşak kadife bir tonla]` "Selamün aleyküm koca muhafız! Tebriz kervanından tipi yüzünden koptum... Heybelerim safran, ipek ve Isfahan kınasıyla doludur. Sana yalan söyleyenin terazisi bozulsun ağam; beni içeri alırsan köyün kadınları gülistana döner."
- **EN:** `[hand upon chest, bowing with fluid grace, silken modulation]` "Peace be upon you, mighty sentinel! From the great Tabriz train was I severed by the blizzard... My saddlebags brim with saffron, raw silk, and Isfahan henna. May the scales break of him who speaks falsehood to you, master; admit me within, and your village women shall bloom like a rose garden."
- **Reji Notu:** Şark tüccarının bal damlayan dili. Her kelimesi para ve menfaat kokmalıdır.

#### Replik 2 (Moğol Payzası)
- **TR:** `[göğsündeki gümüş plakayı saklamaya çalışarak, buz gibi bir ciddiyetle]` "Bu gümüş levha mı? İlhanlı ordusunun geçiş beratıdır muhafız... Yol kesenler boynumu vurmasın diye taşıdım. Casus değilim amma bu kâğıt olmasa kervan dağdan inemezdi."
- **EN:** `[striving to conceal silver tablet, cold diplomatic poise]` "This silver tablet? 'Tis an Ilkhanate travel paiza, guard... I bear it solely lest horse archers take my head upon the road. Spy I am not, yet without this talisman no merchant train ever descends these heights alive."
- **Reji Notu:** Nezaket maskesi düşer; siyasi gerçekçilikle konuşur.

---

### Ziyaretçi 23 (`diyalog_23`): Çavuş Sungur (Sancak İnzibatı — Asker)
- **Yaş:** 36
- **Ses Rengi:** Metalik, yırtıcı bariton; kışla kibri ve tehditle dolu otoriter ses.
- **Ağız / Şive:** Sancak inzibat dili; sert, kaba, emir kipleri ve aşağılayıcı hitaplar.
- **Duygu Aralığı:** Kibir, rüşvetçilik, küstahlık, fermanının sahteliği ima edildiğinde saldırgan öfke.
- **Nefes / Duraklama:** Hızlı ve emrivaki; konuşurken kılıç kınını kapıya vurarak ses çıkarma.

#### Replik 1 (Açılış)
- **TR:** `[kılıcının kabzasını kapı parmaklığına vurarak, buyurgan ve gürültülü]` "Açın kapıyı beylik muhafızları! Sancak subaşısı buyruğudur; firarileri teftişe geldim! İçeride kışla kaçakları saklandığı duyulmuştur. Önümden çekilin, yoksa bu kapıyı başınıza yıkarım!"
- **EN:** `[slamming scabbard iron against gate grating, haughty and loud]` "Open the timber, realm guards! By decree of the district warden; I come to inspect deserters! Whispers have reached the seat that army runaways roost within. Step aside from my boots, or I shatter this barrier over your skulls!"
- **Reji Notu:** Devlet gücünü arkasına almış küstah askerin bağırışı.

#### Replik 2 (Rüşvet Pazarlığı)
- **TR:** `[alaycı bir sırıtışla sesini alçaltarak]` "Bak muhafız efendi... On firari var dediler. Bana kese başına üç altın verirsen deftere 'Köyde firari bulunamadı' yazarım. Nizam kâğıtla yürür, anladın mı?"
- **EN:** `[dropping to contemptuous undertone with crooked grin]` "Hear me well, master sentry... They claim ten runaways hide within. Slip three gold dinars per head into my sash, and my ledger shall read 'No runaways found within.' Law moves by ink, you take my meaning?"
- **Reji Notu:** Aşağılık bir şantajcı tonu.

---

### Ziyaretçi 24 (`diyalog_24`): Gülhatun (Vebalı Ana ve Sabi — Çiftçi)
- **Yaş:** 25
- **Ses Rengi:** Hırıltılı, titrek mezzo; yüksek ateşten yanmış, dermansız ölüm döşeği sesi.
- **Ağız / Şive:** Sade köy dili; ölüm döşeğindeki bir annenin can havli feryadı.
- **Duygu Aralığı:** Evlat aşkı, mutlak çaresizlik, can korkusu değil evlat kaygısı.
- **Nefes / Duraklama:** Ciğerden gelen hırıltılı soluklar, öksürük krizleri, konuşurken nefesinin tükenmesi.

#### Replik 1 (Açılış)
- **TR:** `[kundaktaki bebeği kapı parmaklıklarına uzatarak, gözyaşları ve hırıltıyla]` "Yalvarırım taş atmayın... Bana acımıyorsanız şu kundaktaki sübyana acıyın! Boynumda veba çıbanı patladı, bilirim vaktim azdır... Amma bebeğim sağlıklıdır, ona süt verecek bir hatun yok mudur köyünüzde? Beni kireç kuyusuna atın amma sabiyi kurtarın!"
- **EN:** `[thrusting swaddled infant toward the grating, weeping in rasping gasps]` "I beg of you, cast no stones... If you pity not my wretch soul, pity the suckling in this swaddling! The pestilence boil has burst upon my throat; I know my hours are numbered... But my babe is clean! Is there no nursing mother within your walls? Fling me into the lime pit, but save my infant!"
- **Reji Notu:** Yürek parçalayıcı bir trajedi. Oyuncu ağlamamalı, boğulurcasına inlemelidir.

#### Replik 2 (Karantina Kabulü)
- **TR:** `[duvara yığılarak, son nefesleriyle]` "Kapı dibinde beklerim... İçeri girmem, koku salmam... Yalnız sabiyi alın ellerimden... Adı Yusuf'tur... Allah rızası için..."
- **EN:** `[collapsing against the stonework, breath failing]` "I will lie by the threshold... I will step no foot within, spread no blight... Only take the babe from my stiffening arms... His name is Yusuf... For the mercy of God..."
- **Reji Notu:** Ölümün eşiğindeki annenin son teslimiyeti.

---

### Ziyaretçi 25 (`diyalog_25`): Dursun (Kaçak Fırın Çırağı — Yetim)
- **Yaş:** 14
- **Ses Rengi:** İnce, kırılgan, hızlı ve soluk soluğa bir sokak çocuğu sesi.
- **Ağız / Şive:** Sokak Türkçesi; hızlı, telaşlı, kelimeleri yutan çocuk ağzı.
- **Duygu Aralığı:** Dehşet, falaka korkusu, akrabasını (Hamza Rençber) bulma umudu.
- **Nefes / Duraklama:** Hızlı, göğüsten soluma, arkasına bakmaktan nefesi kesilme.

#### Replik 1 (Açılış)
- **TR:** `[kapıya yapışıp titreyerek, korkuyla geriye bakarak]` "Muhafız emmi kurbanın olayım beni Erzincan'daki zalim fırıncıya verme! Her gece falakaya yatırırdı, sırtımda meşe sopasının izi durur... Hamza dayım bu köye sığınmış dediler! Dayımı ver bana, ocakta odun taşırım!"
- **EN:** `[clinging to the timber, shivering, glancing back in panic]` "Uncle guard, by your soul I implore you, yield me not back to that cruel Erzincan baker! Every night he had me strapped to the bastinado; the welts of his oak rod still crisscross my back... Folk whispered my uncle Hamza took shelter in this village! Let me find my uncle; I will haul logs for your hearth until I drop!"
- **Reji Notu:** Dayaktan kaçan çocuğun masum dehşeti.

#### Replik 2 (Dayıya Kavuşma Anı)
- **TR:** `[ağlamaklı bir sevinçle, elleriyle parmaklığı sıkarak]` "Dayııı! Hamza Dayı! Yaşıyorsun... Köy yandı dediklerinde öldün sandım... Kapıyı açın ne olur, dayımın yanına gideyim!"
- **EN:** `[tearful joy breaking through, gripping the iron slats]` "Uncle! Uncle Hamza! You draw breath... When they said the hamlet burned, I deemed you dead under ashes... Open the timber, I beg you, let me run to my uncle's side!"
- **Reji Notu:** Çocuğun sevinç çığlığı ve gözyaşları.

---

### Ziyaretçi 26 (`diyalog_26`): Hekim Lokman (Gezgin Otacı / Şarlatan — Esnaf)
- **Yaş:** 46
- **Ses Rengi:** Ağdalı bariton, bilge görünüşlü ama altından kurnazlık sızan yapışkan ses.
- **Ağız / Şive:** Medrese/şifahane dili; Arapça ve Latince tıp terimleri serpiştirilmiş tumturaklı dil.
- **Duygu Aralığı:** Kibir, şarlatanlık, gizli zehir ortaya çıktığında kurnazca sıvışma telaşı.
- **Nefes / Duraklama:** Tane tane, bilmiş bilmiş konuşma; merhem kutusunu açarken teatral nefesler.

#### Replik 1 (Açılış)
- **TR:** `[çantasından şişeleri çıkarıp sallayarak, teatral bir vakarla]` "Selam olsun can bekçilerine! Konya Darüşşifası'nda yetişmiş Hekim Lokman derler adıma... Kemiği sızlayana derman, ayazda donana tiryak sunmaya geldim. Köyün hastalarını iyi edeyim, şu merhemi kışlaya süreyim; açın kapıyı da ilim içeri girsin."
- **EN:** `[drawing flasks from satchel with theatrical poise]` "Hail to the wardens of life! Hakim Lokman is my name, schooled in the grand Maristan of Konya... Balm for aching bone and theriac for those biting the frost I bring. Let me heal your village sick, spread this salve upon garrison wounds; swing wide the portal that divine physick may enter."
- **Reji Notu:** Kendini hekimlerin şahı gibi pazarlayan bir sahtekârın tumturaklı tonu.

#### Replik 2 (Afyon Şurubu İtirafı)
- **TR:** `[kısık sesle, gözlerini kırpıştırarak]` "Bu şişedeki afyon şurubu muhafız... Zehir değil, hastayı uyutmak içindir! Ağrısı olan adam feryat etmesin diye verilir. Ne var yani hastanın kesesinden iki dirhem eksildiyse? Hekim hakkıdır o!"
- **EN:** `[lowering tone, blinking rapidly]` "This vial holds poppy syrup, guard... 'Tis no venom, but potion to lull the stricken to slumber! Administered solely lest the wretch shriek with agony. What if two silver dirhams went astray from his sash? An apothecary must have his fee!"
- **Reji Notu:** Hırsızlığını mesleki kılıfa uydurmaya çalışan şarlatanın pişkinliği.

---

### Ziyaretçi 27 (`diyalog_27`): Molla Şükrü (Azledilmiş Kâtip — Molla)
- **Yaş:** 49
- **Ses Rengi:** Tiz bariton, genizden konuşan, yapışkan ve kibirli bürokrat sesi.
- **Ağız / Şive:** Osmanlı öncesi Selçuklu kadı/medrese dili; kanun ve şer'i terimlerle dolu ağdalı ton.
- **Duygu Aralığı:** Kibir, entrika, sahte belgelerin açığa çıkmasından korkma, küçümseme.
- **Nefes / Duraklama:** Kelimeleri uzatarak konuşma; konuşurken sakalını sıvazlama.

#### Replik 1 (Açılış)
- **TR:** `[elindeki mühürlü tomarı sallayarak, burnu havada]` "Esselamü aleyküm serhad muhafızı. Sancak mahkemesinin azledilmiş kâtibiyim... Elimde beyliğin arazi tahrirleri ve şer'i hüccetleri vardır. Köyünüzün tarlasını tapulamaya, mecliste adalet dağıtmaya geldim. Çoban aklıyla nizama karşı durma, kapıyı aç!"
- **EN:** `[brandishing sealed parchment roll, chin tilted high]` "Peace upon you, march sentry. Former clerk of the district sharia court am I... In my keeping rest the land registers and judicial writs of the realm. I arrive to deed your hamlets and balance equity in your council. Oppose not lawful order with herdsman's wit; unbar the timber!"
- **Reji Notu:** Köylüyü ve askeri küçümseyen medrese kibri.

#### Replik 2 (Sahte Vakıfnameler)
- **TR:** `[belgeleri telaşla göğsüne basarak, sesi tizleşerek]` "Bu vakıfnameler sahte değildir! Mürekkebi taze mi dedin? Yeni tahrir edildiğinden o... Hasan Çelebi denen sürgün mü fitne yaydı hakkımda?! Onun sicili bozuktur muhafız, kanma ona!"
- **EN:** `[clutching deeds to chest in alarm, pitch sharpening]` "These endowment deeds are no forgeries! Ink still wet, you say? Penned recently during the evacuation, obviously... Has that exile Hasan Çelebi sown poison against my name?! His record is tainted, guard; heed not his spite!"
- **Reji Notu:** Köşeye sıkışan bürokratın ciyaklaması.

---

### Ziyaretçi 28 (`diyalog_28`): Banu Hatun (İntikam Savaşçısı — Alp Kadın)
- **Yaş:** 28
- **Ses Rengi:** Güçlü mezzo-soprano, çelik gibi keskin, matem ve hiddetle bilenen savaşçı kadın sesi.
- **Ağız / Şive:** Uç Türkmen alp ağzı; buyurgan, mert, kafiyeli savaş nidaları.
- **Duygu Aralığı:** İntikam ateşi, matem vakarı, korkusuzluk, haksızlığa karşı tahammülsüzlük.
- **Nefes / Duraklama:** At üstünden inmiş gibi dik ve derin nefes; kılıç şakırtısıyla senkron konuşma.

#### Replik 1 (Açılış)
- **TR:** `[kılıcını kınında şakırdatarak, gözlerinde ateşle]` "Yol verin muhafızlar! Dağların kurdu Banu Hatun derler bana... Ağabeyimi sırtından vuran kalleşlerin izini sürdüm buraya kadar. İçeride kan borcum olan bir nalbant saklanır! Adaleti siz vermezseniz şu karlı surları ateşe verip alırım hakkımı!"
- **EN:** `[rattling blade in scabbard, fiery gaze fixed on the sentry]` "Clear the way, sentinels! Banu Hatun, wolf of the highland ridges, they call me... I have tracked the craven dogs who skewered my brother from the brush straight to this pass. A farrier who owes blood-debt cowers within! If you deliver not justice, I set torch to your frosty palisade and carve my due!"
- **Reji Notu:** Asla histerik değil; son derece kontrollü ve ölümcül bir alp kadın otoritesi.

#### Replik 2 (Köy Muhafızı Teklifi)
- **TR:** `[kılıcını indirip göğsüne vurarak, tok bir sesle]` "Nalbant ağabeyimin katili değilse pusatım köyün emrindedir muhafız... Kışlada nöbet tutarım, haramiye karşı ilk kılıcı ben çekerim. Bir alp kadının sözü taşa yazılmış yazı gibidir."
- **EN:** `[sheathing blade, thumping cuirass with fist, resonant tone]` "If the farrier shares no guilt in my brother's blood, my steel stands at your village's call, guard... I keep vigil upon your bastion; against brigands my blade strikes first. An alp woman's word is chisel upon granite."
- **Reji Notu:** Mertlik ve güven aşılayan savaşçı yemini.

---

### Ziyaretçi 29 (`diyalog_29`): Kervancı İlyas (Kafile Habercisi — Kervancı)
- **Yaş:** 51
- **Ses Rengi:** Öfkeli bas-bariton, boğazı ayazda yırtılmış, sitemkâr ve gür ses.
- **Ağız / Şive:** Kervan yolları kaba dili; bağırarak, hesap sorarak konuşan ton.
- **Duygu Aralığı:** İsyan, vicdan azabı, kapıyı kapatan muhafıza karşı nefret dolu sitem.
- **Nefes / Duraklama:** Nefesi buz tutmuş gibi derin ve hiddetli soluma; kapıyı yumruklama sesleri.

#### Replik 1 (Açılış)
- **TR:** `[kapıyı iki yumruğuyla döverek, ayazda yırtılan sesiyle]` "Yüzünüze bakın da utanın kapı bekçileri! Dün gece çevirdiğiniz kırk can vadide karda dondu! Çığlıkları dağda yankılanırken sıcak çorbanızı mı içtiniz?! Sedye getirin, geride kalan üç yaralıyı bari alın içeriye, vicdansızlar!"
- **EN:** `[hammering gate with both fists, throat raw from freezing gale]` "Look upon your own faces and drown in shame, gatekeepers! The forty souls you turned away yestereve froze stiff in the valley drifts! Did you sup your warm broth while their death screams echoed off the crags?! Bring litters, take in the three wounded who yet breathe, you pitiless wretches!"
- **Reji Notu:** Vicdanları tokatlayan bir çaresizlik ve öfke patlaması.

#### Replik 2 (Pusu Şüphesi / Sınav)
- **TR:** `[gözlerini dikip dişlerini gıcırdatarak]` "Bana pusu mu kurdun dersin muhafız? Git vadiye bak... Cesetlerin üstünü kar örttü. Bu kapı insanlığa kapandıysa ardındaki köy de batsın!"
- **EN:** `[glaring through slats, teeth grating in contempt]` "You deem me an ambush scout, guard? Mount the crest and behold the glen... Snow covers forty corpses. If this timber is barred to common humanity, let the village rotting behind it sink into the earth!"
- **Reji Notu:** Acı ve beddua dolu sarsıcı kapanış.

---

### Ziyaretçi 30 (`diyalog_30`): Turna Hatun (Muhafızın Yetim Yeğeni — Çocuk/Genç Kız)
- **Yaş:** 16 (veya 11–16 genç kız / yetim çocuk)
- **Ses Rengi:** Berrak, hüzünlü soprano; masum, ayazda donmuş ama akrabasını bulunca titreşen sıcak ses.
- **Ağız / Şive:** Ata ocağı Erzincan Türkmen ağzı; samimi, aile sıcaklığı taşıyan kelimeler.
- **Duygu Aralığı:** Korku, amcasına sığınma sevinci, takip edilme dehşeti.
- **Nefes / Duraklama:** Titrek, hıçkırıklarını tutarak konuşma, elleriyle yüzüğünü veya göğsünü tutarken nefes verişi.

#### Replik 1 (Açılış)
- **TR:** `[kapı aralığından bakıp gözleri parlayarak, titrek bir fısıltıyla]` "Muhafız amca... Sen misin kurban olduğum? Erzincan'daki ata ocağımız yandı... Babam 'Dağ geçidine git, amcanın kapısına sığın, o seni bırakmaz' dedi. Tek başıma kaçtım dağlardan... Ayaklarım buz kesti amca, aç kapıyı ne olur!"
- **EN:** `[peering through the chink, eyes widening, tremulous whisper]` "Uncle guard... Is it truly you, soul of my kin? Our ancestral hearth in Erzincan was put to torch... Father gasped 'Flee to the highland pass, seek your uncle's gate; he will not forsake you.' Alone I fled over the ridges... My feet are turned to ice, uncle; open the timber, I pray you!"
- **Reji Notu:** Buz kesmiş bir yetimin amcasına kavuşma anı. Saf masumiyet ve tükenmişlik.

#### Replik 2 (Takip Edilme Korkusu)
- **TR:** `[korkuyla arkaya bakıp amcasına fısıldayarak]` "Peşimde voyvodanın süvarileri var amca... Beni konağa kapatmak istediler, kaçtım. Dursun kardeşimi de yolda kaybettim... Beni onlara verme amca, öldürürler beni!"
- **EN:** `[glancing over shoulder in terror, desperate whisper]` "The governor's horsemen are upon my heels, uncle... They sought to lock me in the manor keep; I broke free. And my brother Dursun was lost in the tumult... Surrender me not to their hands, uncle, they will slay me!"
- **Reji Notu:** Aile bağının ve vicdanın en tepe noktası.

---

## 5. Seslendirme Sanatçıları ve AI Ses Motoru (TTS) Parametre Tablosu

Aşağıdaki tablo, ileride hem stüdyo seslendirmenlerine oyuncu seçimi (casting) brifingi olarak verilecek hem de AI ses sentezi (ElevenLabs / Coqui / VITS) hatlarında modelleme parametreleri olarak kullanılacaktır.

| Karakter Kodu / Adı | Ses Tipi / Yaş | Hız (Speed) | Kararlılık (Stability) | Tını / Vurgu (Style) | Temel Vokal Efekti (AudioBus) |
|---|---|---|---|---|---|
| **Muhafız** | Bariton (38) | 0.90x | %75 | Ağırbaşlı, tok, şüpheli | Gate_Reverb (Low, 0.15s), Warm_EQ |
| **Elif (Eş)** | Sıcak Alto (34) | 0.95x | %85 | Şefkatli, fısıltılı, metin | Close_Proximity, Soft_Comp |
| **Yusuf** | Çocuk Tenor (12) | 1.10x | %50 | Kırılgan, telaşlı, masum | High_Pass (120Hz), Tremolo (hafif) |
| **Miraen** | Mezzo (38) | 0.85x | %80 | Kadife, bilge, Grek fonetiği | Soft_Reverb, Warm_Presence |
| **Thessra** | Bas-Bariton (42) | 0.90x | %90 | Tok, sert, ritmik | Hard_Limiter, Low_Boost |
| **Sorhan** | Çatlak Bariton (30)| 1.05x | %60 | Bozkır gırtlağı, vahşi | Distortion (hafif), Dry |
| **Karaca Usta** | Gür Bas (52) | 0.88x | %88 | Otoriter, fütüvvet vakarı | Deep_Resonance, Forge_Echo |
| **Aydoğdu** | Kaba Bariton (58) | 1.05x | %65 | Çatallı, bağırgan, sağır | High_Presence, Grunt_Filter |
| **Saruca Hatun**| Tok Alto (50) | 0.95x | %82 | Anaç, buyurgan, canlı | Mid_Warmth, Punchy |
| **Ayşe Bacı** | Kararlı Mezzo (40)| 0.92x | %85 | Teşkilatçı, vakur, mert | Clarity_EQ, Crisp |
| **Hasan Çelebi**| İnce Bariton (34) | 1.08x | %55 | Fısıltılı, bürokratik, ürkek | Intimate_Whisper, Air_EQ |
| **Nogay** | Kısık Bas (45) | 0.80x | %95 | Uğultulu, nefessiz, avcı | Sub_Bass_Boost, Extreme_Dry |
| **Hamza (D-01)**| Yanık Bariton (48)| 0.88x | %65 | Boğuk, isli, kederli | Low_Cut, Dirt_Texture |
| **Mahmut (D-02)**| Çarşı Tenor (50) | 1.12x | %70 | Hızlı, hesapçı, yılışık | Upper_Mid_Boost |
| **Balaban (D-03)**| Kırık Bariton (28)| 0.95x | %60 | Ağrılı, öfkeli kışla dili | Breath_Gasp, Dynamic_Drive |
| **Durmuş (D-04)**| Yayla Tenor (44) | 0.85x | %80 | Dingin, naif, yaylacı | Wide_Hall (açık hava hissi) |
| **Veli (D-05)** | Maden Tenor (24) | 1.02x | %72 | Canlı, çırak hevesi | Bright_Presence |
| **Timur (D-06)** | Alaycı Bariton (32)| 0.92x | %75 | Bezgin, lakayt, asker | Low_Mid_Dip |
| **Halil (D-07)** | Çatlak İhtiyar (56)| 0.78x | %60 | Yorgun, kesik iniltili | Aged_Filter, Rasp |
| **Cebrail (D-08)**| Tiz Çırak (19) | 1.15x | %50 | Ürkek, kaçamak, nefesli | High_Shelf |
| **Arslan (D-09)**| Keskin Bariton (29)| 0.85x | %90 | Buz gibi, çelik, intikamcı| Cold_Plate_Reverb (çok az) |
| **Yunus (D-10)** | Yanık Tenor (20) | 0.88x | %78 | Kederli, türkümsü | Vocal_Depth |
| **Sinan (D-11)** | Yaralı Bariton (35)| 0.82x | %45 | Ateşli, dermansız, inlemeli| Wet_Breath, Choke_Comp |
| **Davut (D-12)** | Sokak Tenor (41) | 1.08x | %70 | Kıvrak, şakacı, tekinsiz | Slapback_Echo (hafif) |
| **Mehmed (D-13)**| Dağlı Bariton (38)| 0.92x | %75 | İnatçı, sert, şefkatli | Heavy_Chest |
| **Şemsettin (14)**| Kuru Bas (54) | 0.85x | %85 | Tuzlu, ağırbaşlı tüccar | Dry_Chamber |
| **Hamit (D-15)** | Panik Tenor (26) | 1.18x | %40 | Nefesi dar, dehşet içinde | Tremble_LFO |
| **Pir Nazar (16)**| Şiirsel Bas (62) | 0.75x | %90 | Aşina, sakin bağcı | Sacred_Hearth_EQ |
| **İshak (D-17)** | Kantarcı Bariton (47)| 1.00x | %75 | Titiz, ölçülü, telaşlı | Boxy_Mid |
| **Rüstem (D-18)**| Kaba Bas (40) | 0.80x | %88 | Taş ırgatı, homurtulu | Sub_Harmonics |
| **Haydar (D-19)**| Fırıncı Bariton (45)| 1.04x | %80 | Canlı, telaşlı, samimi | Warm_Room |
| **Seyfi (D-20)** | Nalbant Bariton (37)| 0.88x | %60 | Acılı, diş sıkan, mert | Grate_Comp |
| **S. Burhan (21)**| Sufi Bas (65) | 0.72x | %95 | Mistik, ney buğusu, dingin| Infinite_Space (ince kuyruk) |
| **H. Behram (22)**| Kadife Bariton (52)| 0.92x | %82 | Fars ipeği, yılışık tüccar | Silk_Air |
| **Ç. Sungur (23)**| Yırtıcı Bariton (36)| 1.10x | %80 | Buyurgan, kışla terörü | Clip_Warning, Loudness |
| **Gülhatun (24)**| Vebalı Mezzo (25) | 0.70x | %35 | Can çekişen, ateşli feryat| Throat_Rattle, Gasp |
| **Dursun (D-25)**| Sokak Çocuğu (14) | 1.20x | %45 | Falaka korkusu, hızlı | Child_Panic |
| **Lokman (D-26)**| Şarlatan Bariton (46)| 1.05x | %70 | Ağdalı hekim, kibirli | Honey_Presence |
| **M. Şükrü (27)**| Tiz Molla (49) | 1.02x | %65 | Genizden, sahte adalet | Nasal_Boost |
| **Banu H. (D-28)**| Alp Mezzo (28) | 0.95x | %92 | Çelik, intikam ateşi, mert | Steel_Edge |
| **İlyas (D-29)** | Kervan Bası (51) | 1.08x | %75 | Ayazda yırtılmış isyan | Storm_Bellow |
| **Turna (D-30)**| Masum Soprano (16)| 0.90x | %50 | Yetim, gözyaşlı sevgi | Pure_Crystalline |

---

## 6. Dönem Sözlüğü ve Fonetik Telaffuz Kuralları

Seslendirme sırasında döneme ait özel terimlerin modern tahrifata uğramadan doğru okunması için aşağıdaki fonetik transkripsiyon kurallarına uyulmalıdır:

1. **Kösedağ [Kö-se-dağ]:** 'g' harfi boğazdan yumuşatılmadan, hafif genizsi bir 'ğ' ile tok söylenir. Modern "Köseda" gibi yutulmaz.
2. **Subaşı [Su-ba-şı]:** Askeri unvan. Vurgu ikinci hecededir. "Su-BA-şı".
3. **Dirhem [Dir-hem]:** 'h' harfi nefesle açıkça duyulmalıdır.
4. **Zihgir [Zih-gir]:** Okçu başparmak yüzüğü. İlk hecede kısa 'i', sert 'h' soluğu.
5. **Payza [Pay-za]:** Moğol geçiş tableti. Geniş 'a' sesleri, yayvan değil sertçe telaffuz edilir.
6. **Bacıyan-ı Rum [Ba-cı-yan-ı Rum]:** Anadolu kadın teşkilatı. Vakur ve kesintisiz tek nefeste okunmalıdır.
7. **Çinik [Çi-nik]:** Eski tahıl ölçeği. 'k' harfi sert ve patlamalıdır.
8. **Menzil [Men-zil]:** Kervan durağı. 'z' harfi arı vızıltısı gibi temiz ve keskindir.
9. **Kargı [Kar-gı]:** Mızrak. Boğazdan gelen kaba 'k' ve 'g' harfleriyle söylenir.
10. **Ahi [A-hi]:** Kardeşlik/esnaf teşkilatı. 'H' harfi yumuşak bir göğüs nefesiyle verilir.

---
*Bu kılavuz, Kapı Muhafızı seslendirme hattının tek ve nihai başvuru sözleşmesidir. Değişiklikler yalnızca yönetmen ve baş yazar onayıyla yapılabilir.*
