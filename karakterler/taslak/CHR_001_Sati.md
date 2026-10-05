# CHR_001 — Satı

### KARAKTER ŞABLONU

#### BÖLÜM 1

- [Entity_ID]: CHR_001
- [Tag_Array]: Kadın, Orta_Yaş, esnaf, Divriği yöresi
- [Gerçek_Kimlik]: Satı, kırk yaşında yaycıdır. Divriği'nin dere mahallesinde kiriş büker, boynuzu ağaca yatırırdı. Kocası toprağı tutardı. Oğlu Demir çırağıydı.
- [Sadakat_Fraksiyonu]: Kendi ocağına bağlıdır. Atlıya yazılmaz, kapıya da asker olmaz. Korkusu oğlunun kirişinden gelir, bir beyden değil.
- [Secere_Matrisi]: Doğum_Yeri Divriği dere mahallesi. Aile_Bağı kocası yolda kaldı, oğlu Demir atlılara gitti. Kırılma_Olayı oğlunu kiriş büksün diye götürdükleri gün zanaatı saklamaya başladı.
- [Spawn_Koşulu]: Tur > 4 ve Güvenlik < 5
- [Köy_içi_Davranış]: Gündüz_Döngüsü pazarda, tezgahın gölgesinde kiriş büker ve eyer kayışı diker. Gece_Döngüsü kervansaray avlusunda çuvalı direğin ardına yaslar, yarım yayı çıkarmaz, kapıya bakarak uyur.
- [Base_Stat_Potansiyeli]: Güvenlik +4, Moral +2

#### BÖLÜM 2

- [Persona_Maskesi]: Yorgun bir çiftçi duludur. Elinde arpa çuvalı vardır. Kapıdan bir köşe ve bir ekmek ister. Yaydan, kirişten, oğuldan söz etmez.
- [Gizlenen_Gerçek]: Yaycıdır. Çuvalın dibinde kirişi tam oturmamış yarım bir yay gövdesi vardır. Belindeki boynuz, yayın ucudur. Oğlunu bu el yüzünden götürmüşlerdir. Zanaat duyulursa nöbete yazılmaktan ve aynı atlıların izinden korkar.
- [Obje_1_Nişan]: Belinde, kuşağa sıkıştırılmış kısa bir boynuz durur. Dışı kararmış, ucu içe kıvrıktır. Kaşık sapı gibi gösterir. Eline alınca içi oyuktur, kenarında kirişin sürttüğü ince bir iz vardır, kaşıkta olmaz. Üretir [Clue_Boynuz_Kiris_Izi].
- [Obje_2_Yük]: Sırtındaki çuvalın ağzı arpa doludur, ipi gevşektir. Eline alınca üstteki arpa kayar, dipte beze sarılı sert bir ağaç çıkar. Kokusu taze yongadır, un gibi değil. Üretir [Clue_Cuval_Dibinde_Yay].

#### BÖLÜM 3

- [Yüz_ve_Postür]: Yanak çökmüş, göz altı morarmış bir kadındır. Bakışı kapıya değil çuvala gider. Omzunun biri düşük, ip orada iz bırakmıştır. Ağzı kapalı durur, sorulmadan açmaz.
- [Kıyafet_ve_Doku]: Soluk yün entari, dizde kurumuş çamur, belde dar deri kuşak, başörtüsü toz içindedir. Yeninin içi dışından koyudur. Elini oraya çeker.
- [Görsel_Hata]: Sol başparmağın içi oluk oluk kararmıştır. Tırnak kenarı serttir, orak kesmesi gibi dağınık değil, tek çizgide oturmuştur. [Sır_Bağlantısı]: Bu iz çiftçi orak tutsun diye değildir. Yıllarca kiriş sıkan yaycı elinin kendisidir. Çuvalın dibindeki yayın kanıtı bu parmaktır. Üretir [Clue_Gorsel_Basparmak_Olugu].
- [State_0 Idle]: Tansiyon 0, 1, 2 ya da 3. Çuvalın yanında durur. Omuz iner. Ses alçak kalır. Başparmak yenin içindedir.
- [State_1 Stressed]: Tansiyon 4, 5, 6 ya da 7. Çuvalın ağzını iki elle kapatır. Başparmak görünmesin diye yumruk sıkar. Cümleler bölünür. Yüzü çuvala döner.
- [State_2 Panic]: Tansiyon 8, 9 ya da 10. Çuvalı göğsüne çeker. Geri geri gider. Sesi incelir. Gözü kapıda değil, dış yoldadır. Bağıracak gibi ağzını açar.
- [SFX]: Kuru arpa hışırtısı, gevşek ipin tahtaya sürtmesi, ara sıra kısık öksürük. Bağırınca çuval yere çarpar, boynuz kapı tahtasına vurur.

#### BÖLÜM 4

- [Başlangıç_Tansiyonu]: 5. Kapıya State_1 ile gelir. Tansiyon 0 ile 10 arasında kalır. 10'un üstüne çıkmaz, 0'ın altına inmez. 00'a her dönüşte üç soru durur. Aynı soru yeniden sorulursa tansiyon üstüne biner.

##### Düğüm 00

Satı, çuvalı iki elle tutar. Kapıya değil yere bakar.

NPC: "Gece oldu. Dizim şişti, daha yürümem. Bana Satı derler. Divriği'nin dere kenarından kalktım. Şu çuvalda arpa var, bir ekmek çıkar belki, belki çıkmaz. İçeri alırsan köyün kenarında yatarım. Kimsenin ekmeğine el sürmem. Yolda kalan çoktu. Ben sona kaldım."

Oyuncu seçenekleri:

- "Bu yol seni nereden getirdi?" Hedef: 1.1
- "Evde kim kaldı?" Hedef: 2.1
- "Başparmağındaki oluk kirişten mi?" Hedef: 3.1, tansiyon +2. Bu seçenek yalnız [Clue_Boynuz_Kiris_Izi], [Clue_Cuval_Dibinde_Yay] ya da [Clue_Gorsel_Basparmak_Olugu] bulunduysa durur. Bu dal kanıt dalıdır.

##### Dal 1

###### 1.1

NPC: "Düz geldim. Önce dereyi geçtim, sonra sırtı aştım. Bir harman yerinde yattım, sabah çuvalı sardım, yine yürüdüm. Kimseye selam vermedim. Dilim damağım kurumuştu, verecek selam da yoktu. Yol bu kadar. Başka durak saymadım."

Oyuncu seçenekleri:

- "Su içtiğin yer neresiydi?" Hedef: 1.2, tansiyon -1
- "Harman yolu bu kapıya mı çıkar?" Hedef: 1.2_Baskı, tansiyon +2

###### 1.2

NPC: "Durduğum yerin adını şaşırdım, kusura bakma. Harman mıydı, han mıydı, karıştı. Kapısı kırıktı. İçerde ocak vardı, soğumuş, külü dağılmış. Su içtim, çıktım. Çuvalı orada bağlamadım. İpi yolda çektim, düğüm gevşek kaldı. Yorgunum, aklım dağılır."

Oyuncu seçenekleri:

- "Başka şey konuşalım mı?" Hedef: 00
- "O kırık kapıda kim vardı?" Hedef: 1.3. Bu seçenek yalnız tansiyon 8'in altındayken durur. Tansiyon 8, 9 ya da 10 ise bu soru yoktur, yalnız 00'a dönen soru kalır.

###### 1.2_Baskı

Yalanın adı burada konur. Harman yeri dediği yer harman değildir.

NPC: "Harman dedim, değil. Ağzımdan kaçtı. Dere boyuydu. Çamurda at izi duruyordu, taze, dağılmamış. Ben çuvalı göğsüme bastım, çömeldim, yüzümü kapadım. Geçtiler. Kaç kişiydi, bilmem. Saymasını öğrenmedim. Kimseye de sormadım. Görmesinler diye nefesimi tuttum, o kadar."

Tansiyon 8, 9 ya da 10 olunca duruş State_2 olur. Bu bantta tek hedef vardır.

Oyuncu seçenekleri:

- Tansiyon 8, 9 ya da 10 ise tek soru durur. "Ağzın kapandı mı?" Hedef: Düğüm_Final_Ret. Bu yol yalnız tansiyon 8 ya da daha yüksekken açılır.
- Tansiyon 0, 1, 2 ya da 3 ise tek soru durur. "Susmanı mı istiyorsun?" Hedef: 00, tansiyon -1
- Tansiyon 4, 5, 6 ya da 7 ise iki soru durur. "Susmanı mı istiyorsun?" Hedef: 00, tansiyon -1. "Atlılar kimi arıyordu?" Hedef: 1.3. Sıkıştıran soru yalnız bu bantta açılır.

###### 1.3

NPC: "Kapıda kimse oturmuyordu. Kırık kapının ardı boştu, ocak sönüktü. Bağıran dışarıdaydı. Dere boyunda atlılar yaycı diye bağırdı, yüksek. Bizim sokaktan bir çocuğu daha önce almışlar, kiriş büksün diye. Çocuk benim oğlum. Adını burada söylemem, yol duyar, kapı da duyar. Ben de anasıyım diye o kırık kapının ardına sindim. Çuvalın ağzını açmadılar. Arpa görsünler yeter sandım. Anlattım işte. Gerisini kurcalama, dizim titriyor."

Üretir [Flag_Yol_Sirri_Acik].

Oyuncu seçenekleri:

- "Başka kapıdan sorayım mı?" Hedef: 00
- "Bu kadar yol yeter mi?" Hedef: Son_Soz

##### Dal 2

###### 2.1

NPC: "Satı'yım. Çiftçi karısıyım. Kocam tarladaydı, tarla kaldı, o döndü mü bilmem. Çocuğum yok. Tek başımayım. Arpa ekerim, arpa biçerim, arpa taşırım. Başka hünerim yok, istemem de. Kapın çiftçi alıyorsa ben çiftçiyim. Çuval da bunun için."

Oyuncu seçeneği:

- "Tarlanda ne bitti?" Hedef: 2.2, tansiyon +1

###### 2.2

NPC: "Arpa bitti, öyle derler. Derenin öte yüzündeydi tarla. Dönümünü kocam bilirdi, ben bilmem. Ben biçmedim. Orak tutmadım. Kocam da tarlada değilmiş, yolda kalmış, onu da şimdi hatırladım. Neden şimdi, sorma. Ağzım birbirine giriyor. Çuval ağır. Ben hafifim. Uzatma."

Oyuncu seçenekleri:

- "Kocan nerede kaldı?" Hedef: 2.3, tansiyon -2
- "Oğlun yok muydu?" Hedef: 2.3_Agresif, tansiyon +3. Bu soru yalnız [Flag_Yol_Sirri_Acik] doğruysa durur. Yol sırrı açılmadan sorulmaz.

###### 2.3

NPC: "Doğrusunu söyleyeyim, tutma beni. Satı'yım. Divriği'nin dere mahallesindenim. Çiftçi değilim. Kocam toprağı tutardı, ben yay bükerdim. Oğlumun adı Demir. Çırağımdı. Atlılar onu kiriş için götürdü, eli bana benziyor diye. Ben de buraya çiftçi olayım diye geldim. Yaycı kapıda tutulur, nöbete yazılır, korktum. Arpa üstte durur. Benim işim altta kaldı."

Üretir [Flag_Kimlik_Cozuldu].

Oyuncu seçenekleri:

- "Başka kapıdan sorayım mı?" Hedef: 00
- "Kapıda bu kadar yeter mi?" Hedef: Son_Soz

###### 2.3_Agresif

Yol sırrı açık olduğu için çelişki bağırarak dökülür. Aynı gerçek söylenir, ses pazarlık ve korku karışıktır.

NPC: "Bırak yakamı. Çocuk yok dedim, Demir'i bir kapı daha yazmasın diye. Oğlumu aldılar, yaycı diye aldılar. Ben de yaycıyım. Duydun mu? Yaycıyım. Çuvalın altında yarım yay var. Arpa yalan değil, üstü o. İstersen çevir, istersen al. Oğlumun adını bir daha nöbete yazma."

Üretir [Flag_Kimlik_Cozuldu]. Bu itiş tansiyonu 8, 9 ya da 10 yaparsa duruş State_2 olur ve kilit yolu da açılır.

Oyuncu seçenekleri:

- "Yayı çuvalda mı bıraktın?" Hedef: Son_Soz
- Tansiyon 8, 9 ya da 10 ise bir de şu soru durur. "Susacak mısın?" Hedef: Düğüm_Final_Ret. Bu yol yalnız tansiyon 8 ya da daha yüksekken açılır.

##### Dal 3

###### 3.1

Bu düğüm yalnız [Clue_Boynuz_Kiris_Izi], [Clue_Cuval_Dibinde_Yay] ya da [Clue_Gorsel_Basparmak_Olugu] en az biri bulunduysa açılır. Oyuncu görsel hatayı adıyla sorar. Boynuz ipucu ve çuval ipucu bulunduysa söz onlara da değer.

Oyuncu: "Başparmağındaki oluk kirişten mi?"

NPC: "Elime bakma. Bakma dedim sana. O oluğu yenimin içinde saklıyordum, sen yine gördün. Dizim kesildi. Oturacağım. Şimdi sor, ayakta duramam." [Clue_Boynuz_Kiris_Izi] bulunduysa şunu da der: "Boynuzu da çevirdin. Kaşık sandın, değil." [Clue_Cuval_Dibinde_Yay] bulunduysa şunu da der: "Çuvalın dibine de elin gitti. O sert ağacı duydun."

Oyuncu seçeneği:

- "O el hangi işi tuttu?" Hedef: 3.2

###### 3.2

NPC: "Dur. Bir soluk. Dizim kesildi, oturdum. Çuval dizimde. Kapı şurada. Yol da arkada. Ben ortada kaldım. Soluğum gelsin, sonra konuşurum."

- Tansiyon 8, 9 ya da 10 ise Hedef: Düğüm_Final_Ret. Bu yol yalnız tansiyon 8 ya da daha yüksekken açılır. Duruş State_2 olur.
- Tansiyon 8'in altındaysa Hedef: 3.3

###### 3.3

NPC: "Duydun zaten. Saklamayacağım. Ben yay bükerim. Şu boynuz kaşık sapı değil, yayın ucu. Çuvalın dibindeki ağaç da yarım yay, kirişi daha tam oturmadı, yolda çekildi. Başparmağıma bak, orak kesmez öyle, kiriş keser, yıllardır. Demir'i, oğlumu, aynı el diye aldılar. Ben çiftçi oldum kapıda, tutmayın diye. Yay köyde kalsın, ben gideyim, dersen de olur. İkisini birden bağlama boynuma."

Üretir [Flag_Sir_Tamamen_Cozuldu].

Oyuncu seçeneği:

- "Bu kadar mı?" Hedef: Son_Soz

###### Düğüm_Final_Ret

NPC: "Bitti. Ağzım kapalı. Çuvalı da vermem. Bir adım atarsan bağırırım. Dere boyundaki atlı duyar. Ne yay sana gelir, ne söz. Çekil karşımdan."

Üretir [Flag_Kilitlendi].

Oyuncu seçeneği:

- "Söyleyecek sözün kaldı mı?" Hedef: Son_Soz

##### Son_Soz

[Flag_Kilitlendi] yanlışsa NPC: "Soru bitti. Ben çuvalın üstüne oturdum. Kapıyı sen tutuyorsun. Ben tutmuyorum. Ne diyeceksen de, ben beklerim."

[Flag_Kilitlendi] doğruysa yeni cümle yoktur. Son söz, Düğüm_Final_Ret içindeki çekilmesidir.

Bundan sonra kararlar açılır. Seçeneklerin sonucu burada söylenmez.

#### BÖLÜM 5

- Eğer [Flag_Yol_Sirri_Acik] yanlışsa: Dört tur sonra kervansarayın gece nöbeti at izini geç görür. İş, avlu nöbetidir. Güvenlik -3.
- Eğer [Flag_Kimlik_Cozuldu] yanlışsa: Yedi tur sonra pazara kocasının kardeşi gelir, adamın adını ve yerini sorar. Kapıda bu sorulmadığı için kimse cevap veremez, adam boş döner. İş, tezgah başında ad sormaktır. Moral -2.
- Eğer [Flag_Sir_Tamamen_Cozuldu] yanlışsa: Altı tur sonra kervansarayda bir el, dipteki yayın gevşek kıymığına gelir. Kanıt kapıda sorulmamıştır. İş, çuval çözmektir. Sağlık -2.
- Eğer [Flag_Kilitlendi] doğruysa: Açık kalan kararlar zorunlu ret ve kışladır. Kabul, gönüllü ret ve rüşvet kapanır. Kilit Güvenlik +2 ekler.
- Eğer [Flag_Kilitlendi] yanlışsa: Altı kararın altısı da açıktır.

- Kabul ve sır çözüldü. [Flag_Kimlik_Cozuldu] doğruysa ya da [Flag_Sir_Tamamen_Cozuldu] doğruysa bu karar açıktır. Aynı tur pazarda kiriş bükme başlar. Güvenlik +4. Doğar CHR_011, karardan 4 tur sonra: Demir kapıya gelir, elinde yarım kiriş, anasını sorar.
- Kabul ve sır duruyor. [Flag_Kimlik_Cozuldu] yanlışsa ve [Flag_Sir_Tamamen_Cozuldu] yanlışsa bu karar açıktır. Satı çuvalı açmadan girer. Sekiz tur sonra kervansarayda gece saklanan yarım yay bulunur, avlu karışır. İş, gece çuval saklamaktır. Moral -4. Doğar CHR_012, karardan 8 tur sonra: kervansaray bekçisi kapıya çıkar, çuvalın dibindeki yayı görmüştür.
- Zorunlu ret. Yarım yay köye girmedi, dere boyundaki atlı izi kapıda kaldı. Aynı tur Güvenlik +2. Beş tur sonra pazarda kiriş bükme işi boş kalır. Refah -3. Doğar CHR_013, karardan 3 tur sonra: yay arayan bir atlı kapıda Satı'nın adını sorar.
- Gönüllü ret. Çiftçi sandığın kadın geri çevrilir. Yedi tur sonra kervansarayda eyer kayışı dikilmez, kimse kiriş bükemez. Güvenlik -3. Doğar CHR_014, karardan 7 tur sonra: eyer kayışı çözülmüş bir sürücü, dikecek el aramak için kapıya gelir.
- Rüşvet. Muhafız boynuz nişanı beline takar, bir deste kirişi kendi kesesine koyar. Satı kapıdan girer. Altı tur sonra pazarda esnaf o boynuzu görür, tezgahlar erken kapanır. İş, beldeki nişanı görmektir. Moral -3. Doğar CHR_015, karardan 6 tur sonra: pazarcı bir çocuk, muhafızın belindeki boynuzu söylemeye gelir.
- Kışla. Satı sur dibindeki nöbet yerine yazılır. Aynı tur Güvenlik +5. Üç tur sonra pazarın önünde halk dul kadını surda görünce içi kararır. Moral -3. Doğar CHR_016, karardan 2 tur sonra: nöbete yazılmış bir yaycı çırağı, Satı'nın başparmağını tanır.
