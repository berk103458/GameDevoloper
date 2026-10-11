<!-- BOLUM_HAZIR -->
# Kapı Muhafızı — ROADMAP 2 / Parça B

Parça B: söz motoru, zar, kapı kavgası, diyalog eylemleri, köprüler. Bu dosya bölündükten sonra A döngüsü tarafından değiştirilmez.

**Madde biçimi:** `- [ ] **ÖNEK-NN:** Başlık — amaç.` Altında: **Amaç**, **Kurallar**, **Uç durumlar**, **Kabul** (ölçülebilir test), **Bağımlılık**, **Boyut**, **Dosya**, **Asset**.

**Ortak kurallar:** yeni dosya + ince adaptör; çekirdekte minimal ekleme; `koy_sahnesi` / statik `KoyYerlesimi` yok; ajan asset üretmez ve indirmez, gereken asset satıra yazılır, yerine kutu veya düz renk konur. ROADMAP 1'de biten makine (salgın, mevsim, tüccar, divan mahkemesi, yozlaşma ağacı, bölge haritası, çift kasa, cenaze, gözcü kulesi, heybe ve ipucu motoru, tansiyon aralıkları, üretim zinciri) yeniden kurulmaz. Varsa adaptör yazılır.


| Kaynak | Ne yapıyor | Bizdeki karşılığı |
|---|---|---|
| Kingdom Come: Deliverance 2 | Konu başlığından seçilen sohbet; zamanlı cevap; beceri kontrolünde zar yok, değer karşılaştırması; kontrolün türü (ikna, gözdağı, etkileme, baskı) itibara, kıyafete ve karşıdakinin statüsüne göre değişir; itibar köy/grup başına tutulur; suç tanıklar ve dedikodu ile gecikmeli yayılır | Konu merkezi (DIY-03), sıra sabrı (DIY-05), yaklaşım türleri ve muhafız itibarına göre değiştirici (ZAR-04), grup itibarı ve gecikmeli dedikodu (DIY-12, DIY-13) |
| Disco Elysium | Aktif kontrol 2d6 + beceri; beyaz kontrol tekrar denenebilir, kırmızı kontrol tek şanslık ve kalıcı; pasif kontrol zar atmadan ek satır açar | Görünür zar (ZAR-01), tekrar edilebilir / tek şanslık ayrımı (ZAR-05), muhafızın pasif sezgisi (ZAR-06) |
| Valve dinamik diyalog (Ruskin, GDC 2012) | Dünya durumu düz bir olgu listesine çevrilir; en çok koşulu tutan kural seçilir; kural yoksa susar | Bağlam sorgusu ve kural tablosu (DIY-08, DIY-09): "ambar yokken ambar demek" hatası yapısal olarak biter |
| Failbetter / Emily Short (kalite ve önem tabanlı anlatı) | Küçük "hikâyecik"ler değişken koşullarla açılır | Dünya olayları ve karakter dönüşleri hikâyecik havuzu (DNY-02) |
| Pentiment (Obsidian) | Dönem dili ağdalı değil yaşayan dil; geçmişin açtığı seçenek her zaman iyi değil; "Bu hatırlanacak" bildirimi | Muhafız geçmişi (ACL-06), üslup rehberi (YAZ-02), hatırlanma bildirimi (DIY-14) |
| Papers, Please | Beyan ile belge/eşya arasındaki çelişki oyuncunun bulduğu şeydir; denetim ve ceza | Beyan defteri ve çelişki yüzleşmesi (DIY-06, DIY-07), beyin denetçisi (DYL-09) |
| Ace Attorney | Oyuncu tanığın sözüyle kanıtı kendisi eşleştirir; yanlış eşleştirmenin bedeli var | Çelişkiyi yüzüne vurmak (DYL-01) |

**Ton örneği (yön göstermek için, nihai metin değil).** Bugünkü Sivaslı reçber kapıya varır varmaz hikâyesini anlatıyor. Hedeflenen:

- Selam: "(Çuvalı yere bırakır, bir süre soluklanır.) Selamün aleyküm, ağam… Bir tas su verir misin? Sonra ne sorarsan sor."
- "Nereden?" sorulursa: "Sivas yakasından. Köy yandı." (Susar.) Üstelenirse ikinci katman açılır.
- Tohum ancak heybede bulunursa konuşulur, ve gerekçesi bir ikilemdir (ör. tohum köyün ortak tohumudur, geride kalanlara söz vermiştir).

## A2. ROADMAP 1 zemini — biten makine, üstüne binen söz

Bu klasördeki `ROADMAP.md` kapanmış yol haritasıdır. Kapı ipucu motoru, tansiyon, heybe, karar matrisi, gecikmeli etkiler, çift kasa, mevsim, salgın, divan, yozlaşma, harita diplomasisi, fısıltı gazetesi, perde geçişi ve beş nihai son oyunda vardır. ROADMAP 2 bunları ikinci kez yazmaz. Yeni madde ya ince bir adaptördür ya da bu makinelerin üstünde duran söz katmanıdır.

| Biten iş | Kimlik | ROADMAP 2 kuralı |
|---|---|---|
| Heybe, görsel hata, suçlama kilidi | KAP-03…07, KAP-11, KAP-14 | Bakış ve yüzleşme yeni inceleme yolu açmaz. Aynı `Clue_*` okunur. |
| Kapıda hastalık teşhisi | KRI-11 | Bakışın bir bölgesidir. Kabulde mevcut karantina şartına yazar. |
| Tansiyon 0–3 / 4–7 / 8–10, panik kilidi | KAP-02, KAP-08, KAP-12, KAP-13 | Aralıklar korunur. Görünür zar bu aralıkların eki olur (ZAR-01). |
| Blöf olasılığı (oyuncu zarı görmüyor) | KAP-09 | Yerine ZAR-01 geçer. İkinci olasılık hesabı kalmaz. |
| Karar matrisi ve gecikmeli etki | KVR-07, KVR-08 | Kararın dönüşü (DYL-08) bu kuyruğa yazılır. Yeni kuyruk yok. |
| Karara bağlı sonraki karakter | KVR-09 | Karakter bağları (`baglar`) bu spawn alanına yazılır. Ayrı “takipçi listesi” yok. |
| Çift kasa, rüşvet, yozlaşma ağacı, vicdan | EKO-01, ODA-04…06, ODA-09 | Zar değiştiricisi ve muhafız tonu bu skoru okur. Yeni terazi yok. |
| Sancak müfettişi | ODA-07, ODA-13 | Beyin denetçisi (DYL-09) bu teftişin söz sahnesidir. İkinci denetçi sistemi yok. |
| Divan, kanıt sunma, ihbar | CAS-05, CAS-06, CAS-09, CAS-11, CAS-15 | Divan da Söz motoruyla konuşur (KOP-01). Dedikodu fısıltı gazetesine yazar. |
| Heyet kuyruk başında, atlanamaz | HAR-03, HAR-04, HAR-12 | Heyet bir köylü ağacı değildir (KOP-02). Ödeme kamu kasasından. |
| Mevsim, tipi, kapı görüşü | MEV-01, MEV-09, MEV-15 | Bakışın ışık koşulu ve gelen akışı bunları okur. |
| Açlık–sağlık, tüketim | EKO-09, KRI-12 | Yaşam barı (YSM) aynı gece hesabını gösterir. İkinci açlık sayacı yok. |
| Usta–çırak, bina seviyesi | UZM-04, UZM-11, ADM-08 | Yapı kilidi (YAP) yeni bir seviye sayısı icat etmez; mevcut seviyeyi bilgiye bağlar. |
| Beş nihai son, 2. perde | SYS-19, SYS-20, ODA-10 | Dünya olayları ve denetçi cezası bu sonlara koşul yazar. Altıncı son yok. |
| Adsız diyalog sırası | SYS-16 | Yeni motora geçene kadar kalır, sonra DIY-16 ile kapanır. |

Köprü maddeleri (KOP) aşağıdaki bölümlerin ön koşuludur. Kabul satırı olmayan bir “ayrıca şunu da yapalım” cümlesi yol haritasına girmez.

- [ ] **KOP-01:** Divan konuşması Söz motoruna bağlanır.
  - Ne: Yargılama sahnesi `SozMotoru` ile yürür; konuşan sanık ve muhafızdır. Kanıt listesi kapıdaki `Clue_*` kaydıdır. İpucu yokken suçlama kilitlidir. İtiraf, sürgün ve infaz mevcut üç karardan birine tek satır yazar; dördüncü ceza yoktur.
  - Kurallar:
    1. Yargılama sahnesi (CAS-05) `SozMotoru` ile yürür. Sahne dosyası `data/soz/divan_*.json` olur. Konuşan sanık ve muhafızdır.
    2. Kanıt listesi kapıdaki `Clue_*` kaydıdır (CAS-11). Yeni kanıt türü üretilmez. İpucu yoksa suçlama seçeneği kilitli kalır; kilit KAP-07 ile aynı anahtarı kullanır.
    3. Sanığın cevabı beyan defterine (DIY-06) geçer. İtiraf, sürgün ve infaz mevcut üçlü karara (CAS-07) yazılır. Dördüncü ceza türü yazılamaz.
    4. Divan dedikodu üretmez. Ağır sonuç KOP-05’in okuduğu tek kayda gider.
  - Uç durumlar: sanık kapıda hiç konuşmadan divana düşerse beyan defteri boştur; suçlama yalnız heybe ve görsel `Clue_*` ile açılır. Aynı ipucu kapıda tüketildiyse divanda ikinci yüzleşme dalı açılmaz. İtiraf seçeneği ipucu kilitliyken listede görünmez.
  - Kabul: ipucu yokken suçlama seçeneği kilitli, varken açık; verilen karar CAS-07 üçlüsünden birine tek satır yazar. Test: boş defter ve ipucu yokken suçlama sayısı 0; bir `Clue_*` varken suçlama 1 ve karar kaydı 1.
  - Bağımlılık: DIY-02, DIY-07, CAS-05. Boyut: M.
  - Dosya: `src/kapi/divan_kanit.gd` adaptör; sahne `data/soz/divan_*.json`.
  - Asset: asset gerekmedi.
- [ ] **KOP-02:** Heyet sahnesi — atlanamayan konuşma.
  - Ne: Heyet kuyruk başında durur ve atlanamaz. Heyet açıkken sıradaki köylüye soru, bakış ve heybe açılmaz. Ödeme yalnız kamu akçesi ve buğdaydır; `muhafiz_akce` bu sahnede yazılmaz. Ret, haritadaki mevcut saldırı veya asker sayacını bir artırır.
  - Kurallar:
    1. HAR-03 ve HAR-04 sahneleri `data/soz/heyet_*.json` ile yürür. Nereden, Yükün, Kimsin başlıkları bu dosyada yoktur.
    2. Heyet kuyruk başındadır ve atlanamaz (HAR-12). Heyet açıkken sıradaki köylüye soru, bakış ve heybe açılamaz.
    3. Ödeme yalnız kamu akçesi ve buğdaydır. `muhafiz_akce` bu sahnede yazılmaz.
    4. Ret, haritadaki mevcut saldırı veya asker toplama sayacına yazar. Yeni sayaç açılmaz.
  - Uç durumlar: kamu kasası ve buğday birlikte yetmezse ödeme düğmesi kilitli görünür ve eksik malın adı yazar; sahne kapanmaz. Aynı gün ikinci heyet spawn olmaz. Ferman metni üslup denetiminden geçer; yeni oyun sonu üretmez.
  - Kabul: heyet açıkken köylü soru sayısı 0. Test: haraç sahnesinde `konu_merkezi` seçeneği 0; ödeme kamu kasasından bir kez düşer; ret mevcut harita sayacını 1 artırır; `muhafiz_akce` deltası 0.
  - Bağımlılık: DIY-02, DIY-08. Boyut: M.
  - Dosya: yeni `data/soz/heyet_*.json`; `DiplomatikHeyet` tek satır.
  - Asset: asset gerekmedi.
- [ ] **KOP-03:** Hastalık, bakışın bir bölgesidir.
  - Ne: Yüz ve ellere bakınca ateş, kanlı öksürük veya irin satırı çıkabilir. Ayrı teşhis düğmesi yoktur. Belirti yokken enfeksiyon ipucu yazılmaz. Işık kapalıysa belirti de ipucu da oluşmaz. Kabul, duran karantina bayrağına bir kez yazar.
  - Kurallar:
    1. DYL-02 yüz ve eller bölgesi KRI-11 belirtilerini üretir: ateş, kanlı öksürük, irin. İpucu anahtarı KRI-11 ile aynıdır.
    2. Ayrı teşhis düğmesi yoktur. Bakış ipucu üretirse kabul kararı mevcut karantina şartını açar.
    3. Belirti satırı yokken enfeksiyon ipucu yazılmaz. Işık kapalıysa (DYL-02 `kosul.baglam.isik`) belirti de ipucu da oluşmaz.
    4. Şifahane ve salgın sayacı yeniden kurulmaz. Kabul, duran karantina bayrağına bir kez yazar.
  - Uç durumlar: aynı bölgeye ikinci bakış yeni belirti üretmez. Karakter kaçarsa (ZAR-03) ipucu kişi hafızasında kalır, karantina açılmaz. Heybede hastalık nesnesi yoksa yalnız bakış ipucu sayılır.
  - Kabul: belirti yokken enfeksiyon ipucu 0. Test: yüz bölgesinde ateş satırı varken kabul karantina şartını 1 kez açar; aynı ziyarette teşhis düğmesi 0; ışıksız bakışta ipucu 0.
  - Bağımlılık: DYL-02. Boyut: S.
  - Dosya: `src/soz/bakis.gd` ile `src/kapi/hastalik_teshis_adaptoru.gd` aynı kaydı yazar.
  - Asset: asset gerekmedi.
- [ ] **KOP-04:** Tek gecikmeli kuyruk, tek spawn zinciri.
  - Ne: Kararın dönüşü `gecikmeli_etkiler` ve `sonraki_spawns` alanlarına yazılır; ikinci kuyruk yoktur. Her satır `hedef_sistem`, `alan`, `deger` ve `tur_offset` taşır. Parser bina adını kelime listesinden tahmin etmez. Tahmin gerektiren satır `chr_parser --check` ile 1 hata verir.
  - Kurallar:
    1. DYL-08 dönüşleri ve karakter bağları `gecikmeli_etkiler` (KVR-08) ile `sonraki_spawns` (KVR-09) alanlarına yazılır. İkinci kuyruk yoktur.
    2. Her gecikmeli satır serbest cümle değildir. Zorunlu alanlar: `hedef_sistem`, `alan`, `deger`, `tur_offset`. `hedef_sistem` oyunda duran bir kapıdır: `bar`, `dedikodu`, `spawn`, `kuyu_zehri`, `ambar_kundak`. Yeni sistem adı yazılamaz.
    3. Parser bina adını kelime listesinden tahmin etmez. Tahmin olmadan `hedef_sistem` çıkmayan satır `chr_parser --check` hatasıdır.
    4. Bugün `stat_etkisi` gece motorunda genel uygulanmıyor. Yalnız kuyu zehri ve ambar kundaklaması `CasusGeceTakibi.gecikmeli` ile negatif stat arıyor. Bu madde o iki yolu ikinci kez yazmaz. Yapılandırılmış satır mevcut kuyruğa eklenir.
  - Uç durumlar: Fadime'nin "Tur 4'te Recep Ağıl kapısına dayanır" cümlesi ya `hedef_sistem: spawn` artı gerçek bir kimlik olur ya sayfadan çıkar. Şiir olarak kalan satır derlenmez. Yusuf kabulünün dönüşü kayıtta tek satırdır.
  - Kabul: yapılandırılmış satır tek kuyrukta durur. Tahmine muhtaç bir satırla `--check` 1 hata verir. Test: aynı karar iki kuyruğa yazılmaz.
  - Bağımlılık: DYL-08, DIY-11. Boyut: M.
  - Dosya: `src/soz/karar_donusu.gd` mevcut kuyruğa adaptör; `tools/chr_parser.py` alan okur, bina listesiyle tahmin etmez.
  - Asset: asset gerekmedi.
- [ ] **KOP-05:** Dedikodu, fısıltı gazetesinin yazarıdır.
  - Ne: Sabah pusulası yalnız dedikodu kaydındaki satırı basar. Kayıtta olmayan olay pusulada görünmez. Tanıksız rüşvet 0 satır üretir. Tanıklı rüşvet bir ila üç gece içinde tam bir satır olur. Gazete kendi cümlesini yazmaz, kaydı okur.
  - Kurallar:
    1. DIY-13 kaydı sabah pusulasına (CAS-09) ve SYS-18 bayraklarına tek yazardır.
    2. Gazete kayıttaki satırdan başka cümle basmaz. Kayıtta olmayan olay pusulada görünmez.
    3. Tanık yoksa satır çıkmaz. Tanık eşiği DIY-13 ile aynıdır; burada ikinci eşik yoktur.
    4. `BatilInancHisterisi` (KRI-08) aynı kaydı okur. Histeri motoru yeniden yazılmaz.
  - Uç durumlar: tanık gece ölür veya köyü terk ederse henüz basılmamış kayıt düşer. Aynı olay kimliği iki gece üst üste ikinci satır üretmez. Kişisel kasadaki rüşvet de tanık varsa bir satırdır; tanık yoksa akçe hareketi pusulaya yazılmaz.
  - Kabul: tanıksız rüşvet pusulada 0 satır. Test: tanıklı rüşvet 1–3 gece içinde pusulada tam 1 satır; gazete yazma çağrısı 0, okuma çağrısı 1.
  - Bağımlılık: DIY-13. Boyut: S.
  - Dosya: `src/sistemler/dedikodu.gd`; `fisilti_gazetesi.gd` okur.
  - Asset: asset gerekmedi.
- [ ] **KOP-06:** Yozlaşma ağacı sözü ve zarı değiştirir.
  - Ne: Göz yumma ve keskin bakış zar değiştiricisidir; yeni yetenek puanı açılmaz. Aynı skor muhafızın tonunu seçer: yoz uçta gözdağı, adil uçta gönül alma. Üç tonda da etki sözlüğü aynı kalır. Orta skorda değiştirici sıfırdır.
  - Kurallar:
    1. ODA-05 (göz yumma, haraç) ve ODA-06 (keskin bakış, gönül bağı) ZAR-04 değiştiricisidir. Yeni yetenek puanı açılmaz.
    2. Aynı skor DIY-15 tonunu seçer. Yoz uçta gözdağı metni, adil uçta gönül alma metni gelir. Üç tonda da mekanik etki sözlüğü aynı kalır.
    3. Vicdan kabusları (ODA-09) akşam sohbetinin konu adayıdır (DYL-07). Ayrı kabus sahnesi kurulmaz.
    4. Terazi yeniden kurulmaz. Okunan değer mevcut `MuhafizTerazisi` skorudur.
  - Uç durumlar: skor ortadaysa değiştirici 0’dır ve varsayılan ton gelir. Uç skor ±1’den büyük değiştirici yazamaz; tavan ZAR-04 tablosundadır. Kabus konusu o günün ağırlık tablosunda yoksa seçilmez.
  - Kabul: aynı seçenek kimliğinde yoz ve adil metin anahtarı farklı, etki sözlüğü aynıdır. Test: iki uçta etki JSON eşit; yeni yetenek anahtarı 0; orta skorda değiştirici 0.
  - Bağımlılık: ZAR-04, DIY-15, DYL-07. Boyut: S.
  - Dosya: `src/kapi/zar_degistiricileri.gd` mevcut skoru okur.
  - Asset: asset gerekmedi.
- [ ] **KOP-07:** Perde ve son metinleri aynı ağızdan yazılır.
  - Ne: Köyün oturması, beş nihai son ve epilog `data/soz/sonlar.json` anahtarlarından okunur. `nihai_son.gd` cümle üretmez. Altıncı son kimliği doğrulayıcıda 1 hata verir. Koşulu tutmayan son gösterilmez.
  - Kurallar:
    1. “Köy oturdu” (SYS-19), beş nihai son ve muhafız epiloğu (SYS-20, ODA-10) üslup rehberinden ve yapaylık denetiminden geçer.
    2. Yeni son eklenmez. Dünya olayı ve denetçi cezası mevcut son koşullarına yazar.
    3. Metin anahtarları `data/soz/sonlar.json` içindedir. `nihai_son.gd` cümle üretmez, anahtar okur.
    4. Yasak kalıp (YAZ-02) bu dosyada 0 olmalıdır. Denetim geçmeden son kapanmaz.
  - Uç durumlar: koşulu tutmayan son metni gösterilmez. İki son aynı gece tutarsa SYS-20 öncelik tablosu kazanır; yeni öncelik sırası yazılmaz. Epilog, son tetiklenmeden seçilmez.
  - Kabul: son kimliği sayısı 5; metin denetiminde yasak kalıp 0. Test: altıncı kimlikle yüklenen `sonlar.json` doğrulayıcıda 1 hata; koşulsuz epilog satırı 0.
  - Bağımlılık: YAZ-02, DNY-04, DYL-09. Boyut: M.
  - Dosya: `data/soz/sonlar.json`; `src/sistemler/nihai_son.gd` anahtar okur.
  - Asset: asset gerekmedi.
- [ ] **KOP-08:** Tüccar kapıda pazarlık sahnesidir.
  - Ne: Geçiş bacı ve rüşvet konu menüsü olmadan pazarlık sahnesinde yürür. Resmi vergi kamu kasasına, şahsi rüşvet `muhafiz_akce` hesabına ayrı satır yazar. İki hedef aynı düğmede birleşmez. Heyet kuyruk başındayken tüccar konuşmaz.
  - Kurallar:
    1. Geçiş bacı ve rüşvet (TUC-12) pazarlık sahne biçimindedir (OZGUNLUK §4). Konu menüsü yoktur.
    2. Şahsi rüşvet `muhafiz_akce` hesabına işler. İkinci kasa açılmaz.
    3. Resmi vergi kamu kasasına, şahsi rüşvet kişisel kasaya yazar. İki hedef aynı düğmede birleşmez.
    4. Pazarlık zar kullanırsa yaklaşım ikna veya blöftür (ZAR-04). Beşinci yaklaşım türü yoktur.
  - Uç durumlar: kişisel kasa yetmezse rüşvet düğmesi kilitli görünür ve sahne açık kalır. Heyet kuyruk başındayken (KOP-02) tüccar konuşmaz. Tanıklı rüşvet KOP-05’e tek satır yazar.
  - Kabul: resmi vergi ile şahsi rüşvet iki ayrı kayıt. Test: bir pazarlıkta kamu kasası +M ve `muhafiz_akce` +N ayrı satır; konu başlığı sayısı 0.
  - Bağımlılık: DIY-02. Boyut: S.
  - Dosya: `data/soz/tuccar_kapi.json`.
  - Asset: asset gerekmedi.
- [ ] **KOP-09:** Hayalet takip kimliği kalmaz.
  - Ne: `chr_parser.py --check` sayfası olmayan takip kimliğini artık uyarı değil hata sayar. `sonraki_spawns` içindeki her kimlik ya bir CHR sayfasına sahiptir ya satır silinir. Olmayan kişi için "ileride gelir" cümlesi yazılmaz. Boş yuvayı doldurmak için yeni CHR üretilmez.
  - Kurallar:
    1. `chr_parser.py --check` bugün 30 sayfayı geçerli sayar ve 93 takip kimliğini sayfasız bırakır (uyarı). Bu uyarı hataya döner.
    2. `sonraki_spawns` içindeki her kimlik ya `karakterler/CHR_*.md` sayfasına sahiptir ya satır silinir.
    3. Silinen satırın yerine "ileride gelir" cümlesi yazılmaz. Olmayan kişi vaat edilmez.
    4. Dört spawn zorunluluğu kalkar. Sayfa 0, 1 veya daha çok gerçek kimlik yazabilir. Eksik yuvayı doldurmak için boş CHR üretilmez.
  - Uç durumlar: CHR_017'deki CHR_068 (Hatice), CHR_069 (Recep), CHR_070 (Gülizar), CHR_071 (Pakize) ya kendi sayfalarını alır ya Fadime'nin spawn satırından silinir. Başka bir sayfanın aynı kimliğe bakması da sayfa sayılır. Kimlik çakışması hatadır.
  - Kabul: `--check` çıktısında external follow-up 0. Test: sayfasız bir kimlik bırakılan dosya 1 hata verir.
  - Bağımlılık: KOP-04. Boyut: M.
  - Dosya: `tools/chr_parser.py`; `karakterler/CHR_*.md` Bölüm 5 spawn satırları.
  - Asset: asset gerekmedi. Yeni model bu maddeyle açılmaz.
- [ ] **KOP-10:** Kapıdaki sayı, kişinin karar matrisinden gelir.
  - Ne: Adlı CHR ziyaretinde bar etkisi sınıf şablonundan değil `karar_matrisi` satırından gelir. Sır açık ve sır gizli varyantı varsa doğru varyant seçilir. Adsız figür şablonda kalır. Rüşvet akçesi kişisel kasada kalır, kamu kasasına ikinci kez yazılmaz.
  - Kurallar:
    1. Bugün adlı gelende düğme etkisi `k.etki(karar)` ile sınıf şablonundan gelir. CHR matrisinin beş statı (Refah, Erzak, Güvenlik, Moral, Sağlık) köy barına yazılmaz. Matris kapıda yalnız rüşvetin `muhafiz_akce` ve `esyalar` alanı için okunur.
    2. CHR ziyaretinde etki `karar_matrisi` satırından gelir. Sır açık ve sır gizli varyantı varsa doğru varyant seçilir. Clamp −4…+4 durur.
    3. Sınıf şablonu yalnız adsız figürde kalır (`diyalog_01_20.json` ve sınıf şablonu). Adlı CHR'de şablon etkisi ayrıca uygulanmaz.
    4. Rüşvet akçesi kişisel kasada kalır. Kamu kasasına ikinci bir yazım yoktur.
  - Uç durumlar: varyant yoksa düz satır kullanılır. Matriste olmayan bir karar düğmesi kapıda görünmez. Adsız kabuldeki rastgele ±1 (oturumdaki şablon titremesi) CHR yoluna sızmaz.
  - Kabul: CHR_017 kabul ve sır çözülmüşken Erzak +2 ve Moral +2 köy barına bir kez yazar; sınıf şablonu o ziyarette yazmaz. Adsız `diyalog_01` kabulü şablondan gelir. Test: dört karar türü, iki varyant.
  - Bağımlılık: DIY-02. Boyut: M.
  - Dosya: kapı karar uygulayıcısına tek okuma; `data/chr_runtime/CHR_*.tres` kaynağı değişmez, şema KOP-04 ile yapılandırılır.
  - Asset: asset gerekmedi.

---


Site şu an tek sahne: Yusuf, konu merkezli yüzleşme. Oyna, Ağaç, İnceleme, Şablon var. Güven, söz kesme, karşı soru ve yapaylık denetimi çalışıyor. Sıradaki iş siteyi ikinci bir oyun yapmak değil, biten sistemlerin söz hâlini bu sahnede denemek. Her adım bir ROADMAP maddesinin kabulünü küçültür. Godot’a ancak o kabul sitede görülünce geçilir.

1. **Bağlam paneli gerçek oyuna yaklaşır** (DIY-08). Mevsim ve şifahanenin yanına: yatak doluluk, salgın, terazi (adil/yoz), tipi (ışık), önceki karar, tanıyan köylü. Sahne bu alanları okur. Okumadığı bir düğme eklenmez.
2. **Çelişki tahtası** (DYL-01). Oyuncu iki kaydı kendisi eşleştirir. Yusuf’un beş çifti elle yazılmış “yüzleş” seçeneği olmaktan çıkar.
3. **Bakış** (DYL-02 + KOP-03). Yüz, eller, çarık, yük. Bir bölge KRI-11 belirtisidir. Işık kapalıyken (tipi, akşam) ayrıntı gizlenir.
4. **Kapıdan çıkış iki karttır** (DYL-07, DYL-08). Karardan sonra kısa akşam satırı, sonra “N gece sonra” dönüşü. Dönüş KVR-08 biçiminde bir kayıttır. Yeni sahne dosyası açılmaz; Yusuf’un sonlarına eklenir.
5. **İkinci kişi, başka biçim.** YAZ-05’in ikinci karakteri. Çekirdek ve sahne biçimi Yusuf’tan farklı olur (kısa dürüst, pazarlık, sessiz veya soru soran). Metin üslup rehberine uyar. Kör okuma (DYL-11) bu adımdan önce anlamsızdır, çünkü tek ses vardır.
6. **Yusuf’un ikinci çekirdeği** (DYL-10): `durust`. Aynı selam, başka heybe, yolda yedi ev yok. Tohum hâlâ köyün tohumu olabilir. Kadro kotası sitede sayılır.
7. **Altın oynanış** (DYL-16). Sitede “kayıt al”: seçimler ve zar sonucu → beklenen satırlar. Dosya `tests/soz/altin/` taslağı olarak bu klasörde durur. Oyun motoru yazılınca aynı dosyayı okur.
8. **Yerinde düzenleme** (DYL-15) en sonda. Önce iki biçim oturur. Düzenleyici, oturmamış bir kalıbı kolaylaştırmasın.

Sesli doğaçlama (YAZ-02) 5. adımın metninden önce gelir. Model “kim bu insan” paragrafını yazmaz.


Amaç: üç ayrı diyalog yolunu (adlı karakter sohbeti `SohbetVerisi`, adsız `diyalog_01_20.json`, CHR sorgu `ChrSorgusu`) tek bir konuşma motorunda toplamak. Eski metinler taşınmaz, baştan yazılır (YAZ-06); eski yollar yeni içerik hazır olunca kapatılır (DIY-16). Motor, profesyonel oyunların kanıtlanmış mantığı incelenerek ama kendi stilimizle kurulur. Motor yazımı Claude'un işidir (zor iş).

DIY-01 … DIY-18 gövdesi durur; alt başlıklara bölündü, kimlikleri değişmedi. Yeni maddeler DIY-19 … DIY-98. İkinci Söz motoru yok.

### 16.1 Şema — düğüm dosyası reddi

- [ ] **DIY-01:** Söz motoru tasarım belgesi — profesyonel oyunların mantığı ve "Kapı usulü".
  - Ne: `docs/SOZ_TASARIMI.md` yedi oyunun ne yaptığını, neyin alınacağını ve neyin alınmayacağını ayrı başlıklarda yazar. Alınan her mekanik bir DIY veya ZAR maddesine bağlanır. Kapı usulü selamı, eşiği, heybeden sürüklenen soruyu, susmayı ve beyan defterini bu belgede sabitler. Belge Ahmet onaylamadan şemaya geçilmez.
  - Kurallar:
    1. `docs/SOZ_TASARIMI.md` iki bölümden oluşur: İnceleme ve Kapı usulü. Üçüncü bölüm açılmaz.
    2. İnceleme yedi kaynağı ayrı başlıkta tutar: Kingdom Come 2, Disco Elysium, Valve kural seçimi, Failbetter/Emily Short, Pentiment, Papers Please, inkle/Ink. Her başlıkta dört satır zorunludur: ne yapıyor, neden işe yarıyor, alınacak kısım, alınmayacak kısım ve gerekçesi.
    3. Alınan her mekanik bir DIY veya ZAR maddesine bağlanır. Bağı olmayan “alınacak” satırı belgeye girmez. İç ses, beceri ağacı ve görünmez zar alınmaz; bunların maddesi yoktur.
    4. Kapı usulü şu kuralları yazar: selam ve ikram (su, ekmek, ateş başına davet tansiyonu değiştirir); eşikte konuşma (içeri alınmadan önce ve sonra ayrı satır); heybedeki eşya sohbete sürüklenerek sorulur; susmak cevaptır; beyan defteri ve yüzleşme; muhafız sezgisi ile eşin akşam yorumu iç sesin yerini tutar; kısa cümle, önce selam.
    5. Belge Ahmet onayı almadan DIY-01a şemasına geçilmez.
  - Uç durumlar: iki kaynak aynı mekaniği söylüyorsa tek maddeye bağlanır, ikinci tasarım yazılmaz. Maddesi olmayan fikir “park” listesine de konmaz. İnceleme bölümü oyun repliği üretmez.
  - Kabul: yedi kaynağın dördü de dolu; her alınacak satırın bir DIY veya ZAR kimliği vardır. Test: kimliği olmayan alınacak satırı doğrulayıcı 1 hata sayar; bölüm sayısı 2’den farklıysa kabul sayılmaz.
  - Bağımlılık: yok. Boyut: M.
  - Dosya: yeni `docs/SOZ_TASARIMI.md`.
  - Asset: asset gerekmedi.

- [ ] **DIY-01a:** Söz veri şeması — konuşma dosyası biçimi.
  - Ne: Konuşma dosyası düğüm, satır, konu, beyan, ikram, zar kontrolü ve `cekirdek` alanlarını taşır. Dürüst çekirdek ipucusuz geçebilir; koruma yalanı ipucusuz geçemez. Konuşmacı kadroda yoksa, seçenek kimliği çiftse, düğüm kendine kenar veriyorsa ya da birden fazla giriş varsa dosya yüklenmez. Derinlik tavanı `data/soz/kurallar.json` içindedir.
  - Kurallar:
    1. Zorunlu alanlar yalnız varış, karar ve `cekirdek`. Selam, konular, yüzleşme, sır ve ikilem yoksa dosya yine geçerlidir.
    2. `cekirdek` OZGUNLUK türlerinden biridir. Sır çekirdeği (`koruma_yalani`, `baskasinin_sirri`, `tehlikeli_yalan`) değilse heybe ipucu şartı kalkar. Doğrulayıcı bu karakterde `Clue_*` yok diye hata vermez.
    3. Sır çekirdeğinde en az bir ipucu ve bir yüzleşme çifti zorunludur.
    4. Evre listesi (selam, konular, derinleşme, yüzleşme, pazarlık, veda) örnektir, şablon değildir. Kadronun yarısından fazlası sır evresi kullanıyorsa uyarı YAZ-09'dadır; şema o uyarıyı üretmez, yalnız alanı taşır.
  - Uç durumlar: dürüst karakterde boş `sir` alanı hatadır, alan hiç yazılmaz. Çekirdeksiz dosya şemadan geçmez.
  - Kabul: Üç örnek dosyadan ipucusuz dürüst olan geçer, ipucusuz koruma yalanı geçmez (`tests/unit/soz/sema_test.gd`). Ek şart: kadroda olmayan konuşmacı, çift seçenek kimliği, kendine kenar ve ikinci giriş her biri 1 şema hatası verir. Ek şart: tavan 12 iken 13. düğüm 1 hata verir ve tavan `.gd` içine yazılmaz.
  - Bağımlılık: DIY-01. Boyut: M.
  - Dosya: yeni `docs/SOZ_SEMASI.md`, `data/soz/_sema.json`, `data/soz/ornek_*.json`.
  - Asset: asset gerekmedi.

### 16.2 Yürütme — etki, kayıt, kilit

- [ ] **DIY-02:** Söz motoru çekirdeği — düğüm yürütücü.
  - Ne: `SozMotoru` konuşma dosyasını okur, koşulu tutan satırı verir ve seçimin etkisini bir kez yazar. Şemaya uymayan dosya sahneyi sustu kapatır, oyunu düşürmez ve yedek hikâye uydurmaz. Etki anahtarı bar, akçe, ambar, bayrak, tansiyon ve ziyaret dışında olursa dosya reddedilir. Boş metin anahtarı ve bağlamda olmayan `{yer}` satırı oynatılmaz. Eski kayıtta düğüm alanı yoksa sahne girişten başlar.
  - Kurallar:
    1. `SozMotoru` konuşma dosyasını okur, koşulları değerlendirir, satırları sırayla verir, seçim alır, etkileri uygular.
    2. `ChrSorgusu` kilitleri motorda durur: tansiyon, ipucu kilidi, bayrak, panik kilidi, `Final_Ret`, karar kısıtı. Yeni kilit türü eklenmez.
    3. Karar matrisi ve gecikmeli etkiler (KVR-07/08) aynı API’den okunur. Motor ikinci kuyruk açmaz (KOP-04).
    4. Dosya şeması DIY-01a’dır. Şemaya uymayan dosya yüklenmez; motor yedek hikâye uydurmaz.
    5. Etki sözlüğü veridedir. Kod karakter adı veya cümle bilmez.
  - Uç durumlar: koşulu tutmayan satır atlanır. Hiç satır kalmazsa veda düğümüne düşülür; veda da yoksa sahne “sustu” ile kapanır ve karar düğmeleri açık kalır. Panik kilidinde ikna ve gözdağı kapanır, `Final_Ret` yolu durur. Kayıt yarım kalırsa son düğüm kimliği yazılır, sahne baştan açılmaz.
  - Kabul: Altı kilit türünün her biri bir örnek dosyayla geçer (`tests/unit/soz/soz_motoru_test.gd`). Şema hatası olan dosya 0 satır oynatır. Ek şart: aynı seçimin ikinci `sonuc` çağrısı barı bir kez daha değiştirmez. Ek şart: `altin` etki anahtarı ve boş metin anahtarı 1'er hata verir.
  - Bağımlılık: DIY-01a. Boyut: L.
  - Dosya: yeni `src/soz/soz_motoru.gd`, `src/soz/soz_dugumu.gd`.
  - Asset: asset gerekmedi.

- [ ] **DIY-03:** Selam önce, hikâye sonra — konu merkezi.
  - Ne: Karakter kapıya varınca oyuncu önce selamı görür; selam bitmeden konu listesi açılmaz. Konu sırası dosyadaki dizidir, kod yeniden sıralamaz. Konu düğümünde kabul ve ret kapalıdır; veda veya sustu kapanışında karar çubuğu açılır. Konu açıkken köy ekranına geçilmez. Her konu düğümünün merkeze dönen bir kenarı vardır.
  - Kurallar:
    1. Karakter kapıya varınca yalnız selam satırı gelir. Selam bitmeden konu listesi açılmaz.
    2. Ortak konu kümesi: Nereden, Neden yola düştün, Kiminle, Ne iş bilirsin, Yükün, Yolda ne gördün, varsa Haber. Başlık her karakterde aynıdır; cevap ağacı karaktere özeldir.
    3. “Kimsin / nesin / kendini tanıt” üçlüsü kalkar. Eski otomatik `acilis` hikâyesi selam sayılmaz (DIY-16).
    4. Veride olmayan konu listede görünmez. Boş başlık basılmaz.
    5. İkram (su, ekmek) selam evresinin seçeneğidir, ayrı konu değildir. Tansiyon etkisi seçenekte yazar.
  - Uç durumlar: konu listesi boşsa (sessiz karakter veya dil engeli) yalnız selam, bakış ve karar kalır. Heyet sahnesinde (KOP-02) konu merkezi açılmaz. Aynı konu ikinci kez seçilirse katman DIY-04’e gider, selam tekrar etmez.
  - Kabul: Otuz adlı karakterde selamdan önce hikâye satırı 0'dır (`tests/unit/soz/konu_merkezi_test.gd`). "Kimsin?" başlığı 0'dır. Ek şart: konu ekranında karar düğmesi 0'dır. Ek şart: kenarsız konu düğümü 1 şema hatası verir.
  - Bağımlılık: DIY-02. Boyut: M.
  - Dosya: yeni `src/soz/konu_merkezi.gd`; `src/arayuz/kapi/soz_paneli.gd` (yeni panel, eski panele adaptör).
  - Asset: asset gerekmedi.

### 16.3 Konu merkezi

- [ ] **DIY-04:** Derinleşme katmanları — aynı konuda üstelemek yeni bilgi açar.
  - Ne: Oyuncu aynı konuyu üstelerse ikinci katman açılır; birinci seçilmeden ikinci gelmez. Üsteleme başka konuya zıplamaz. Tavan `kurallar.json` içindedir, öneri 3'tür; dördüncü üsteleme yeni soru açmaz, veda satırı gelir. Susuş beyan yazmaz.
  - Kurallar:
    1. Her konuda en az 2 katman vardır. İkinci katman birincisi seçilmeden açılmaz.
    2. Üstelemek tansiyonu artırabilir. Artış seçenekte yazar; yazılmamışsa +0’dır.
    3. Karakter bir katmanda susabilir. Susuş satırı `susus: true` taşır, beyan üretmez, ipucu üretebilir.
    4. Doğrulayıcı her karakterde konu başına katman sayısını raporlar. 1 katman hatadır. Konu hiç yoksa rapor “yok” yazar, 0 diye hata basmaz.
    5. Son katmandan sonra üsteleme düğmesi kapanır. Motor yeni katman uydurmaz.
  - Uç durumlar: “gerisini sorma” susuşu o konunun sonraki katmanlarını kilitler. Güven eşiği (DIY-17) susuşu açabilir; eşik yazılmamışsa susuş kalır. Üsteleme sabır harcar (DIY-05).
  - Kabul: Bir katmanlı konu 1 hata verir; susuş satırı beyan defterine 0 kayıt yazar (`tests/unit/soz/derinlesme_test.gd`). İkinci katman birincisiz seçilemez. Ek şart: tavan 3 iken dördüncü üsteleme soru açmaz.
  - Bağımlılık: DIY-03. Boyut: M.
  - Dosya: şema + motor; içerik YAZ bölümünde.
  - Asset: asset gerekmedi.

- [ ] **DIY-05:** Sıra sabrı — sohbetin zaman bedeli.
  - Ne: Her soru, bakış ve yemin sıradaki sabırdan düşer; HUD kalan sayıyı ve eylemin bedelini gösterir. Sayaç saniye değildir: oyuncu düşünürken, menü açıkken ve sıra olayı kartı açıkken düşmez. Tavan `azami_soru` alanıdır, ikinci bir sayı yazılmaz. Sabır bitince konu kapanır, veda ve karar çubuğu açılır. Hız çarpanı açık düğümü kesmez.
  - Kurallar:
    1. Her soru, bakış, gösterme, yemin ve tercüman çağrısı sıradaki sabırdan düşer. Miktar eylemde yazar; yazılmamış soru −1’dir.
    2. Sabır gerçek zaman değildir. Oyuncu düşünürken sayaç ilerlemez.
    3. Sabır 0 olunca sıradan biri ayrılır veya mevcut sıra olayı tetiklenir (BUG-20). Yeni olay türü açılmaz.
    4. Sabır HUD’da görünür: kalan sayı ve bu eylemin bedeli.
    5. Heyet ve zorunlu gelen (KAP-16) sabır harcamaz.
  - Uç durumlar: sırada tek kişi varken sabır 0’a inerse ayrılacak kimse yoktur; sıra olayı da yoksa HUD “sabır bitti” der, kapıdaki kişi kaçmaz. Sabır eksiye inmez. Aynı konunun ikinci katmanı da sabır harcar.
  - Kabul: On iki soruluk örnekte ayrılan kişi ya da tetiklenen sıra olayı en az 1'dir (`tests/unit/kapi/sira_sabri_test.gd`). Şemada gerçek zaman alanı 0'dır. Ek şart: `azami_soru` dışında ikinci tavan sabiti 0'dır. Ek şart: menü açılıp kapanınca kalan sayı değişmez.
  - Bağımlılık: DIY-03, BUG-20. Boyut: S.
  - Dosya: yeni `src/kapi/sira_sabri.gd`.
  - Asset: asset gerekmedi.

### 16.4 Sabır ve kesme

- [ ] **DIY-06:** Beyan defteri — karakterin söyledikleri kayda geçer.
  - Ne: Önemli cevap, sorgu panelindeki küçük deftere metin anahtarı ve kaynak soru kimliğiyle düşer. Aynı ziyarette aynı beyan ikinci kez yazılmaz. Ziyaret bitince satırlar kişi hafızasına geçer; `Clue_*` sayısı bu yüzden artmaz. Köyden ayrılanın satırı silinmez, yanına gittiği yazılır. Eski kayıtta liste yoksa boş sayılır.
  - Kurallar:
    1. Önemli cevap bir beyan üretir. Beyan, metin anahtarı ve kaynak soru kimliği taşır. Örnekler: “Sivas’tan geliyorum”, “yalnızım”, “yükümde darı var”.
    2. Beyanlar sorgu panelindeki küçük defterde listelenir. Yanında hangi sorudan veya hangi bakıştan geldiği yazar.
    3. Aynı ziyarette aynı beyan kimliği ikinci kez yazılmaz.
    4. Ziyaret sonunda beyanlar kişi hafızasına geçer (DIY-11). `Clue_*` ayrı kalır; defter ipucu yöneticisinin yerine geçmez.
    5. Susuş (DIY-04) ve “anlaşılamadı” (DYL-06) beyan değildir. Ayrı kayıt türüdür.
  - Uç durumlar: yüzleşme beyanı çürütürse eski satır silinmez, “çürütüldü” işaretlenir. Karakter beyan bitmeden kaçarsa o ana kadarki beyanlar hafızaya yazılır. Boş metinli beyan şema hatasıdır, deftere girmez.
  - Kabul: Aynı cevabı iki kez seçmek defterde 1 satır bırakır (`tests/unit/soz/beyan_defteri_test.gd`). `Clue_*` sayısı beyan yüzünden artmaz. Ek şart: ayrılan kişinin satırı durur. Ek şart: beyan alanı olmayan eski kayıt açılır ve liste boştur.
  - Bağımlılık: DIY-02. Boyut: M.
  - Dosya: yeni `src/soz/beyan_defteri.gd`; `IpucuYoneticisi` yanında ikinci sistem değil, aynı ziyaret kapsamında ayrı defter.
  - Asset: asset gerekmedi.

- [ ] **DIY-07:** Çelişki ve yüzleşme — yalan, kanıtla ortaya çıkar.
  - Ne: Heybe, astar veya hastalık belirtisi bir beyanla çelişirse o çifte özel yüzleşme dalı açılır. İpucu yokken dal kapalıdır. Hazır "Yüzleş" düğmesi yalnız `celiski_yardimi` açıkken görünür. Çözülen çelişki aynı ziyarette ikinci dal açmaz.
  - Kurallar:
    1. İpucu (heybe, astar, görsel hata, hastalık belirtisi) bir beyanla çelişirse o çifte özel yüzleşme dalı tanımlanır.
    2. Hazır “Yüzleş” seçeneği yalnız `celiski_yardimi` açıkken görünür (DYL-01). Kapalıyken dal doğru çiftle açılır.
    3. Sır çekirdeğinde her CHR’de en az 1, tehlikeli CHR’de en az 2 çelişki çifti vardır. Dürüst çekirdekte çift zorunlu değildir (DIY-01a).
    4. İpucu yokken yüzleşme kapalıdır (KAP-07). İpucu varken dal koşulu açılır.
    5. Çözülen çelişki aynı ziyarette ikinci dal açmaz.
  - Uç durumlar: aynı ipucu iki çifte girerse ikisi de açılabilir; biri çözülünce öteki durur. Tehlikeli işareti olmayan CHR’de tek çift yeter. Çiftin bir kaydı silinmişse doğrulayıcı 1 hata verir, motor o dalı gizler.
  - Kabul: İpucu yokken yüzleşme seçeneği 0, varken 1'dir (`tests/unit/soz/celiski_test.gd`). Dürüst örnekte 0 çift şemadan geçer. Tehlikeli örnekte tek çift 1 hata verir.
  - Bağımlılık: DIY-06. Boyut: M.
  - Dosya: yeni `src/soz/celiski.gd`.
  - Asset: asset gerekmedi.

### 16.5 Beyan ve çelişki işareti

- [ ] **DIY-08:** Bağlam sorgusu — dünyanın durumu tek sözlükte.
  - Ne: Konuşma başında gün, mevsim, binalar, nüfus, terazi, yatak ve salgın tek sözlükte toplanır. Sözlük salt okunurdur; olmayan bina `false` döner. Ziyaret içinde dikilen bina aynı konuşmada görünmez. Kayıt yüklenince sözlük kayıttan değil canlı yöneticilerden kurulur.
  - Kurallar:
    1. Konuşma başında tek sözlük üretilir: gün, mevsim, hava, açık krizler, köydeki binalar, nüfus, muhafız terazisi, itibar, önceki ziyaretler, dünya olayları, yatak doluluk, salgın bayrağı, tipi ve ışık.
    2. Sözlük salt okunurdur. Ekonomiye, kasaya ve salgın sayacına yazmaz.
    3. Olmayan bina `false` döner. Kelime tahmini yoktur (KOP-04 ile aynı ilke).
    4. Sahne, sözlükte okumadığı alanla düğme açmaz. Koşul alanı sözlükte yoksa satır seçilmez ve doğrulayıcı uyarır.
    5. Sözlük ziyaret başında bir kez kurulur. Ziyaret içinde dikilen bina aynı konuşmada görünmez.
  - Uç durumlar: yönetici yoksa alan `false` veya 0 döner, sahne çökmez. İki kriz aynı anahtardaysa liste döner, son kriz öncekini silmez. Kayıt yüklenince sözlük kayıttan değil canlı yöneticilerden kurulur.
  - Kabul: Şifahane yokken `bina.sifahane` false döner (`tests/unit/soz/baglam_sorgusu_test.gd`). Sözlük yazma çağrısı 0'dır. Belgede olup sözlükte olmayan alan 1 hata verir.
  - Bağımlılık: yok. Boyut: M.
  - Dosya: yeni `src/soz/baglam_sorgusu.gd`; okuduğu yöneticiler değişmez.
  - Asset: asset gerekmedi.

- [ ] **DIY-09:** Kural tablosu ile bağlamsal satır seçimi.
  - Ne: Bir satırın birden çok varyantı varsa en çok koşulu tutan seçilir. Eşit sayıda tutan iki varyantta `oncelik` kazanır. Hiçbiri tutmazsa varsayılan gelir; varsayılan yoksa satır susar. Kısmi tutma sayılmaz.
  - Kurallar:
    1. Bir satırın birden çok varyantı olabilir. Her varyantın koşulları DIY-08 sözlüğündendir.
    2. En çok koşulu tutan varyant seçilir. Eşit sayıda tutan iki varyantta `oncelik` kazanır. İkisi de yoksa varsayılan satır gelir.
    3. Hiçbiri tutmazsa varsayılan satır gelir. Varsayılan yoksa satır susar, motor çökmez.
    4. Tansiyon bantları (sakin, gergin, panik), mevsim, kriz ve hafıza aynı seçiciyle yürür. İkinci seçici yoktur.
    5. Koşulu tutmayan varyant seçilmez. Kısmi tutma “biraz uygun” diye sayılmaz; sayım tam eşleşmedir.
  - Uç durumlar: altı koşulun beşi tutan varyant, üçü tutandan kazanır. Hepsi 0 tutarsa varsayılan gelir. `oncelik` de koşul sayısı da eşitse doğrulayıcı 1 hata verir; dosya sırası hakem olmaz. Boş koşul listesi varsayılan sayılır.
  - Kabul: Beş koşul tutan varyant, üç koşul tutanı 1000 seçimde 0 kez yener (`tests/unit/soz/satir_secici_test.gd`). Önceliksiz eşitlikte yükleme 1 hata verir.
  - Bağımlılık: DIY-08. Boyut: M.
  - Dosya: yeni `src/soz/satir_secici.gd`.
  - Asset: asset gerekmedi.

### 16.6 Bağlam sözlüğü

- [ ] **DIY-10:** Sır ve ikilem dalları — neden sakladığı.
  - Ne: Sırrı açığa çıkan karakter neden dalına geçer; neden aile, borç, korku, inanç veya yeminden biri olarak veridedir. Dalın sonunda en az iki seçenek kalır ve etkileri farklıdır. Dürüst dosyada ikilem zorunlu değildir. Kasayı eksiye indirecek seçenek kilitli görünür, silinmez.
  - Kurallar:
    1. Sır çekirdeğinde sırrı açığa çıkan karakter neden dalına geçer. Neden veridedir: aile, borç, korku, inanç veya yemin. Kod neden bilmez.
    2. Dalın sonunda en az 2 seçenek kalır. Her seçeneğin bedeli duran bir sisteme yazar: adalet, köy güvenliği, vicdan veya kasa. Yeni sayaç yok.
    3. İki seçenek aynı etki sözlüğünü taşıyamaz. Doğrulayıcı bunu hata sayar.
    4. Dürüst çekirdekte ikilem zorunlu değildir (DIY-01a).
    5. Tek şanslık zar (ZAR-05) yalnız bu düğümlerde durabilir.
  - Uç durumlar: bir seçenek koşul tutmadığı için gizlenir ve ortada tek seçenek kalırsa motor karar düğmesini de açık tutar. Karakter dal ortasında kaçarsa ikilem “çözülmedi” diye hafızaya yazılır. Kasayı eksiye indirecek seçenek kilitli görünür, silinmez.
  - Kabul: Her tehlikeli CHR dosyasında en az 1 ikilem vardır (`tests/unit/soz/ikilem_test.gd`). Aynı etki sözlüğüne sahip iki seçenek 1 hata verir. Dürüst dosyada 0 ikilem geçer.
  - Bağımlılık: DIY-07. Boyut: M.
  - Dosya: şema + motor; içerik YAZ.
  - Asset: asset gerekmedi.

- [ ] **DIY-11:** Kişi hafızası — dönen karakter hatırlar.
  - Ne: Dönen karakterin selamı son kararı okur; retten sonra selam `selam_ret` olur. Hafıza `KarakterKadrosu.durumlar` içindedir, ikinci depo yoktur. Kayıt yüklemek ziyaret sayacını artırmaz. Sayaç 9'dan sonra yeni selam anahtarı açmaz. Eski kayıtta alan yoksa boş sayılır, oyun çökmez.
  - Kurallar:
    1. Kişi başına hafıza şunları tutar: son karar (kabul, ret, rüşvet, kışla, kaçtı), verilen söz, yapılan yardım, yüzleşilen yalan, ödenen veya alınan akçe.
    2. Tek kaynak `KarakterKadrosu.durumlar[id]` alanlarıdır (`ziyaret`, `son_karar`). Yeni alanlar optional kayıttır. İkinci hafıza deposu yoktur.
    3. Dönüşte selam ve en az 1 konu hafızaya göre değişir (DIY-09 varyantı).
    4. Hafıza yoksa ilk ziyaret selamı gelir. Eski kayıtta alan yoksa oyun çökmez, alan boş sayılır.
    5. Eşin akşam hafızası aynı kaydın `es` altıdır (DYL-07). Ayrı eş deposu yok.
  - Uç durumlar: ret sonrası kabul, `son_karar` alanını ezer; ret satırı silinmez, selam son kararı okur. Kişi ölürse hafıza “öldü” diye kapanır ve selam varyantı seçilmez; haber DYL-08 kanalına gider. Aynı gün ikinci ziyaret yoksa hafıza ertesi kapıda okunur.
  - Kabul: `son_karar=ret` iken selam kimliği `selam_ret` olur (`tests/unit/soz/kisi_hafizasi_test.gd`). Kadroda ikinci sözlük yazımı 0'dır. Ek şart: kaydet-yükle sonrası ziyaret sayısı aynı kalır. Ek şart: onuncu ziyaret dokuzuncu ziyaretin selam anahtarını kullanır.
  - Bağımlılık: DIY-09. Boyut: M.
  - Dosya: yeni `src/soz/kisi_hafizasi.gd`; kayıt adaptörü (`guvenli_kayit.gd` çekirdek, minimal).
  - Asset: asset gerekmedi.

### 16.7 Hafıza, grup, güven

- [ ] **DIY-12:** Grup itibarı — Türkmen, Rum, Ahi, köylü, tüccar, asker.
  - Ne: Altı grubun her birinin itibarı eksi on ile artı on arasındadır. Bir ziyaret yalnız karakterin birincil grubuna yazar; Türkmen reti Rum değerini değiştirmez. Sınırın dışına taşan yazım eksi on veya artı onda kesilir. Yedinci grup adı reddedilir. Kayıt anahtarı kalp veya romans olamaz.
  - Kurallar:
    1. Gruplar: Türkmen, Rum, Ahi, köylü, tüccar, asker. İtibar grup başına −10…+10.
    2. Karar, karakterin birincil grubuna bir kez yazar. Çift gruplu kişide yazar birincil grubu seçer; ikinci gruba aynı ziyarette yazılmaz.
    3. İtibar satır seçimine (DIY-09) ve zar değiştiricisine (ZAR-04) girer.
    4. Köylü kartında ve muhafız odasında görünür. Yeni ekran açılmaz.
    5. Sınır dışına taşan yazım −10 veya +10’da kesilir.
  - Uç durumlar: grupsuz karakter köylü sayılır; bu varsayılan alandır, uyarı değildir. Türkmen ret dizisi Rum değerini değiştirmez. −10’dayken yeni ret değeri değiştirmez, yazım denemesi kayıtta “kesildi” diye durur.
  - Kabul: Türkmen reti Türkmen itibarını düşürür, Rum deltası 0 kalır (`tests/unit/sistemler/grup_itibari_test.gd`). Eksi ondayken bir ret daha eksi on bırakır. Bir ziyarette yazılan grup sayısı 1'dir.
  - Bağımlılık: DIY-08. Boyut: M.
  - Dosya: yeni `src/sistemler/grup_itibari.gd`, `data/gruplar.json`.
  - Asset: asset gerekmedi.

- [ ] **DIY-13:** Dedikodu yayılımı — haber gecikmeli dolaşır.
  - Ne: Rüşvet, şiddet, aileyi bölme ve haksız ret tanık varsa bir ila üç gece içinde yayılır. Tanık yoksa satır oluşmaz. Aynı olay kimliği ikinci kayıt açmaz. Sabah pusulasına bunu KOP-05 yazar; gazete kendi cümlesini uydurmaz.
  - Kurallar:
    1. Ağır olay türleri veridedir: rüşvet, şiddet, aileyi bölme, haksız ret. Listede olmayan olay dedikodu üretmez.
    2. Tanık yoksa kayıt oluşmaz. Tanık, kapıda sırada duran veya olayı gören köylüdür.
    3. Kayıt 1–3 gece içinde yayılır. Gün aralığı kayıtta yazar. Sabah pusulasına KOP-05 yazar.
    4. `FisiltiGazetesi` (CAS-09) ve `BatilInancHisterisi` (KRI-08) aynı kaydı okur. Kendi olayını yazmaz.
    5. Aynı olay kimliği ikinci kayıt açmaz.
  - Uç durumlar: tanık ertesi gece ölürse yayılmamış kayıt düşer. Üçüncü geceden sonra basılmamış satır silinir, birikmez. Kamu vergisi dedikodu değildir; tanıklı şahsi rüşvet yayılır.
  - Kabul: Tanıksız rüşvet 0 satır üretir (`tests/unit/sistemler/dedikodu_test.gd`). Tanıklı rüşvet üç gece içinde 1 satır olur. Gün sıfırda pusula satırı 0'dır.
  - Bağımlılık: DIY-11, DIY-12. Boyut: M.
  - Dosya: yeni `src/sistemler/dedikodu.gd`.
  - Asset: asset gerekmedi.

### 16.8 Dedikodu kancası

- [ ] **DIY-14:** "Bu hatırlanacak" bildirimi.
  - Ne: Hafıza veya dedikodu yazan seçimde oyuncu iki saniye "Bu hatırlanacak" notunu görür. Notta isim ve gece sayısı yoktur; metin çeviri anahtarıdır. Ayar kapatılırsa not gizlenir, kayıt yine yazılır. Aynı seçimde not bir kez çıkar.
  - Kurallar:
    1. Not yalnız hafıza (DIY-11) veya dedikodu (DIY-13) yazılan seçimde çıkar.
    2. Metin “Bu hatırlanacak”tır. İsim, grup ve gece sayısı yazılmaz.
    3. Ayarlardan kapatılabilir. Kapalıyken yazım durmaz, yalnız not gizlenir.
    4. Aynı seçimde hem hafıza hem dedikodu varsa not bir kez çıkar.
    5. Not 2 saniye sonra kapanır. Tıklanınca da kapanır. Kararı bekletmez.
  - Uç durumlar: ayar kapalıyken kayıt yine yazılır. İkinci not birincinin üstüne binmez; birincisi kapanır, kuyruk birikmez. Kaçış (ZAR-03) hafızaya yazıyorsa not çıkar.
  - Kabul: Ayar kapalıyken not 0 kez görünür, kayıt 1 kez yazılır (`tests/unit/kapi/hatirlanma_notu_test.gd`). Tek seçimde not sayısı 1'dir. Metinde özel ad 0'dır.
  - Bağımlılık: DIY-11. Boyut: S.
  - Dosya: yeni `src/arayuz/kapi/hatirlanma_notu.gd`.
  - Asset: asset gerekmedi.

- [ ] **DIY-15:** Muhafızın sesi — seçenek metni terazi ve geçmişe göre tonlanır.
  - Ne: Tonlanan her seçenekte adil, sert ve yozlaşmış üç metin vardır; etki sözlüğü üçünde aynıdır. Terazi ortaya yakınsa sert varyant gelir. Geçmişe özel seçenek geçmiş yoksa gizlenir. Boş varyantla sahne yüklenmez. Ton anahtarı yoksa nötr anahtar kullanılır ve ton sonucu değiştirmez.
  - Kurallar:
    1. Tonlanan her seçenekte 3 varyant vardır: adil, sert, yozlaşmış. Mekanik etki üçünde aynıdır. Metin ve karşı tepki farklıdır.
    2. Ton eşiği `data/` içindedir, sabit kodlanmaz. Eşik ODA skorunu okur (KOP-06).
    3. ACL-06 geçmişine özel seçenek bu katmandadır. Geçmiş yoksa o seçenek gizlenir; varsayılan ton kalır.
    4. Karşı tepki de DIY-09 ile seçilir. İkinci ton motoru yoktur.
    5. Üç metinden biri boşsa doğrulayıcı hata verir. Eksik tonla sahne yüklenmez.
  - Uç durumlar: terazi ortadaysa sert varyant gelir. Geçmiş seçeneği üç tonda da durur; ton metni değiştirir, seçeneği silmez. Etki sözlüğü farklı olan üçlü hata sayılır.
  - Kabul: Adil ve yoz metin anahtarları eşit değildir, etki JSON eşittir (`tests/unit/soz/muhafiz_tonu_test.gd`). Boş yoz varyant 1 hata verir.
  - Bağımlılık: DIY-09, ACL-06. Boyut: S.
  - Dosya: yeni `src/soz/muhafiz_tonu.gd`; okuma `MuhafizTerazisi`, `MuhafizVicdani`.
  - Asset: asset gerekmedi.

### 16.9 Ton, eski yol, prototip

- [ ] **DIY-16:** Eski diyalog yollarının kapatılması — yeniden yazılan içerik devreye girer.
  - Ne: Yeni konuşma dosyası biten karakter eski `diyalog_sirasi` yolundan çıkar; iki kaynak aynı karede basılmaz. Eşleme `data/soz/gecis.json` içindedir ve karşılığı olmayan alan `tasinmaz` diye yazılır. Kapanış bayrağı `kurallar.json` içindedir; bayrak kapalıyken eski sıra durur. Dosyası ve sınıf şablonu olmayan adlı figür sustu kapanır, şablon uydurulmaz.
  - Kurallar:
    1. Eşleme tablosu `docs/SOZ_SEMASI.md` içindedir. Satırlar: `diyalog_01_20.json` soru dizisi → konu ve katman; otomatik `acilis` → yalnız selam, hikâye konu seçilince; `SohbetVerisi` giriş / açılış / soru dizisi → aynı ayrım; CHR düğüm 00 ve üç dal → varış, konular, yüzleşme; `Clue_*` ve dört `Flag_*` aynı kimlikle kalır; `karar_matrisi` KOP-10'a gider.
    2. Karşılığı olmayan alan tabloda `tasinmaz` diye yazılır. Sessiz silme yoktur.
    3. Eski metin kendiliğinden taşınmaz. YAZ-06 dalgası biten karakter tek yola geçer, eski ve yeni birlikte çalışmaz.
    4. Son dalgadan sonra sohbet akışı, `_gemini_al()` ve `chr_diyalog_paneli.gd` kapıdan çıkar. Heybe, görsel hata, karar matrisi ve spawn verisi yerinde kalır. Eski kayıt açılır, `diyalog_sira` yok sayılır.
  - Uç durumlar: adsız yirmi diyalogun yirmisinde de `acilis` var ve ilk soru "Kimsin?". Tabloda bu ikisi `tasinmaz` veya yeni selam kuralına bağlanır; otomatik hikâye yeni dosyada kalamaz. Geçiş tablosunda olmayan karakter eski yolda kalır, ikisi birden açılmaz.
  - Kabul: Otuz adlı karakter yeni motordan konuşur ve eski yola çağrı 0'dır (`tests/unit/soz/gecis_test.gd`). Eşleme tablosunda boş karşılık 0'dır. Ek şart: bayrak kapalıyken `diyalog_sirasi.gd` `oku` hâlâ çağrılır; açıkken çağrı 0'dır.
  - Bağımlılık: DIY-02, YAZ-06, DIY-01a. Boyut: L.
  - Dosya: `Oturum`, `chr_kapi_adaptoru.gd`, `kapi_ekrani.gd` yönlendirmesi (çekirdek, minimal); karakter başına geçiş tablosu `data/soz/gecis.json`.
  - Asset: asset gerekmedi.

- [ ] **DIY-17:** Güven ve korku ayrı ölçülür.
  - Ne: Güven sıfır ile on arasında ayrı bir çubuktur; korkuyla açılan sır eksik kalır, güvenle açılan sır tam açılır. Güven yedi ve üstündeyken itiraf görünür ve zarsız tam sır açar. Altındayken itiraf düğmesi yoktur. İki değer toplanıp tek çubuk olmaz.
  - Kurallar:
    1. Güven 0–10’dur. Başlangıç karakter verisindedir; alan yoksa 3’tür.
    2. İkram, karşılık verme ve dinleme artırır. Sert soru, heybeyi izinsiz karıştırma ve söz kesme düşürür. Miktar seçenekte yazar.
    3. Güven satır koşuludur (`guven_min` / `guven_max`) ve zar değiştiricisidir: güven ≥ 7 iken ikna −1, güven ≤ 2 iken ikna +1.
    4. Güvenle açılan sır tam açılır. Korkuyla (zar, gözdağı) açılan sır eksik açılır; kalan parça bakış veya heybe ile doğrulanır.
    5. Güven ≥ 7 iken `itiraf` seçeneği görünür ve zarsız tam sır açar. Altındayken görünmez.
  - Uç durumlar: güven 0’ın altına ve 10’un üstüne yazılmaz. Aynı sır önce korkuyla açıldıysa güven sonradan yükselse bile itiraf o sır için kapanır; eksik parça yalnız bakış veya heybe ile tamamlanır. Yusuf prototip düğümleri `sir_acildi`, `sir_acildi_korku` ve `itiraf` bu kuralın örneğidir.
  - Kabul: Güven 6 iken itiraf düğmesi 0, 7 iken 1'dir (`tests/unit/soz/guven_korku_test.gd`). Korku dalındaki beyan sayısı tam daldan azdır.
  - Bağımlılık: DIY-02, DIY-09, ZAR-04. Boyut: M.
  - Dosya: `src/soz/` durum nesnesi; sorgu paneline ikinci çubuk.
  - Asset: asset gerekmedi.

### 16.10 Sınır ve kapanış

- [ ] **DIY-18:** Söz kesme, karşı soru ve muhafızın beyanı.
  - Ne: Muhafız anlatıyı kesince cümle "—" ile biter, sabır bir artar, güven bir düşer ve o düğüme bir daha girilmez. Karakter soru sorarsa muhafızın cevabı `soylenen` kaydına düşer ve bir sabır hakkı harcar. Cevap verilmeden o cevaba bağlı varyant seçilmez.
  - Kurallar:
    1. `kesme`: muhafız anlatıyı keser. Son replik yarıda kalır, sabır +1, güven −1. Kaçan düğüme bir daha ulaşılmaz.
    2. `kesilir`: karakter muhafızın cümlesini keser. Cümle yarıda kalır. Acele cevap sezgi satırı ve ipucu üretebilir.
    3. Karakter soru sorar. Muhafızın cevabı `soylenen` kaydıdır. Sonraki varyant yalnız o cevap verilmişse seçilir.
    4. Seçimden hemen sonra kısa `tepki` satırı gelir. Tepki yoksa atlanır.
    5. Arayüzde kesilen cümle “—” ile biter. Tamamı ayrıca gösterilmez.
  - Uç durumlar: kesilen düğümün cümlesi beyan defterine yazılmaz. `soylenen` yalan olabilir (DYL-04); bu madde doğruluğu denetlemez, kaydı tutar. Aynı anlatı ikinci kez kesilemez, düğüm kapalıdır. Soru sorulmadan `soylenen` koşullu varyant seçilmez.
  - Kabul: Kesilen anlatının devam düğümüne erişim 0'dır (`tests/unit/soz/soz_kesme_test.gd`). `soylenen` yokken koşullu varyant 0 kez seçilir. Ek şart: karşı soru kalan sabrı 1 düşürür.
  - Bağımlılık: DIY-02, DIY-09. Boyut: M.
  - Dosya: `src/soz/` motor; sorgu paneli satır çizimi.
  - Asset: asset gerekmedi.

ZAR-01 … ZAR-06 gövdesi durur. Yeni maddeler ZAR-07 … ZAR-86. İkinci zar sınıfı yok.

### 17.1 Zarın kendisi

- [ ] **ZAR-01:** Görünür zar — d6 ve d12.
  - Ne: İkna, blöf, gözdağı ve gönül almada oyuncu atılan zarın sayısını görür. Başarı `zar ≥ gerekli` kuralıdır; gerekli değer karakter değeri artı bir artı tansiyon ekidir. Sakin ek 0, gergin ek 1, panik ek 2'dir. Değer 2 ve sakin iken gerekli 3, panikte 5 olur. d20 reddedilir. Aynı tohum aynı sonucu verir.
  - Kurallar:
    1. İkna, blöf, gözdağı ve gönül alma seçeneklerinde ekranda zar atılır. Karakter verisinde `zar` alanı `d6` veya `d12` olur.
    2. Başarı kuralı `zar ≥ gerekli`. `gerekli` = karakter değeri + 1 + tansiyon eki + değiştiriciler.
    3. Tansiyon eki üç kademedir: sakin (0–3) +0, gergin (4–7) +1, panik (8–10) +2. Aralıklar KAP-02’den gelir.
    4. Formül ve eşikler `data/chr_runtime/sorgu_kurallari.tres` içindedir. Sabit kodlanmaz. Değer 2 örneği: sakin 3, gergin 4, panik 5.
    5. `ChrSorgusu.basari_olasiligi` (KAP-09) bu kurala döner. İkinci olasılık hesabı kalmaz. Eski kayıt açılır; eksik `zar` alanı ZAR-02 varsayılanına düşer.
  - Uç durumlar: `gerekli` zarın tavanından büyükse (d6’da 7 ve üstü) düğme kilitlenir, zar atılmaz. d6’da 6 ve d12’de 12 her zaman başarıdır; 1 her zaman başarısızdır. Değiştirici 1’i başarıya çevirmez. Zar görseli yoksa düz renk kutu ve sayı yeter.
  - Kabul: Değer 2, sakin ve değiştirici 0 iken gerekli 3'tür; panikte gerekli 5'tir (`tests/unit/kapi/sorgu_zari_test.gd`). On bin atışta d6 dağılımı teorik orandan en fazla yüzde 2 sapar. KAP-09'a giden ikinci hesap yolu 0'dır. Ek şart: aynı tohumla iki atış aynı sayıyı verir. Ek şart: yeni ses dosyası eklenmez. Ek şart: başarı ve başarısızlık yalnız renkle değil, sayı ve sözcükle de yazılır.
  - Bağımlılık: yok (DIY-02 gelince motora taşınır). Boyut: M.
  - Dosya: yeni `src/kapi/sorgu_zari.gd`; `ChrSorgusu.secenek_sec` tek satır.
  - Asset: zar görseli envantere `ZAR01-ZAR` (d6, d12); yer tutucu düz renk kutu + sayı.


### 17.2 Karakter değeri

- [ ] **ZAR-02:** Karakter değeri — kişiye göre taban zorluk.
  - Ne: Her adlı karakterin `sorgu_degeri` vardır; d6 için 1–5, d12 için 2–10. Alan CHR sayfasının dördüncü bölümündedir ve `chr_parser.py` okur. Eksik alanda sınıfa göre varsayılan yazılır ve doğrulama 1 hata verir. Aynı ziyarette iki atış aynı tabanı kullanır. Adsız figür bu alanı kullanmaz.
  - Kurallar:
    1. Her CHR ve adlı karakterde `sorgu_degeri` vardır. d6 için 1–5, d12 için 2–10.
    2. Alan CHR şablonunun Bölüm 4 satırındadır. `chr_parser.py` okur.
    3. Eksik alanda sınıfa göre varsayılan yazılır ve `--check` hata verir. Yeni sayfa üretilmez.
    4. Aralık dışı değer dosyayı geçirmez. Varsayılan da aralık dışına yazılamaz.
    5. Adsız figür bu alanı kullanmaz. Onun zorluğu sınıf sabitidir.
  - Uç durumlar: d6 karakterde değer 6 yazılırsa 1 hata. Alan boşluğu yalnız adlı CHR ve adlı karakterde hatadır; adsız yirmilik diyalog bu hatayı üretmez. Parser bu alanı sayı okur, bina adı tahmin etmez.
  - Kabul: Bir CHR'den alan silinince `chr_parser.py --check` 1 hata verir (`tests/tools/test_chr_sorgu_degeri.py`). d12'de değer 1 yazılırsa 1 hata verir. Ek şart: aynı ziyarette iki atışın tabanı aynıdır.
  - Bağımlılık: ZAR-01. Boyut: S.
  - Dosya: `karakterler/CHR_*.md` Bölüm 4 satırı, `tools/chr_parser.py`.
  - Asset: asset gerekmedi.

### 17.3 Tansiyon

- [ ] **ZAR-03:** Tansiyon 10'u aşarsa karakter gider.
  - Ne: Başarısız zar tansiyonu seçenekte yazan kadar artırır; yazılmamışsa bir artar. Tansiyon onu aşarsa karakter kaçar ve karar "kaçtı" olur; ret sayacı artmaz. Konu değişince tansiyon sıfırlanmaz, veda sıfırlar. Menü açıkken değer değişmez. Başarılı zar, tansiyon ondayken karakteri kaçırmaz.
  - Kurallar:
    1. Başarısız zar tansiyonu seçenekte yazan kadar artırır. Yazılmamışsa +1’dir.
    2. Tansiyon 10’u aşarsa karakter ayrılır. Karar “kaçtı”dır. Kabul, ret, rüşvet ve kışla yazılmaz.
    3. Kaçış kişi hafızasına yazılır. Tanık varsa dedikoduya da yazılır (DIY-13).
    4. Tehlikeli karakter kaçarsa sonraki tehdit, duran tehdit sayacına yazar. Yeni sayaç yok.
    5. Tansiyon 10’dayken başarılı zar kaçırmaz. Kaçış, eşi aşan başarısız zar veya aynı eşi aşan başka artıştır.
  - Uç durumlar: panik kilidi (8–10) seçenek kapatır; kaçış ziyareti bitirir. İkisi aynı bayrak değildir. Kaçışta gösterilmemiş çelişki “çözülmedi” diye kalır (DYL-01). Tansiyon 10’da artış +0 olan başarısızlık kaçırmaz.
  - Kabul: Tansiyon 10, başarısız zar ve artış 1 iken karar "kaçtı" olur (`tests/unit/kapi/tansiyon_kacis_test.gd`). Tansiyon 10 ve başarılı zarda karakter durur. Ek şart: kaçış `ret_sayisi` artırmaz. Ek şart: eşik sayısı `data/ayarlar/denge.json` içindedir.
  - Bağımlılık: ZAR-01. Boyut: S.
  - Dosya: `src/kapi/sorgu_zari.gd`; karar akışına adaptör.
  - Asset: asset gerekmedi.


### 17.4 Yaklaşım

- [ ] **ZAR-04:** Yaklaşım türleri ve değiştiriciler.
  - Ne: Dört yaklaşım vardır: ikna, blöf, gözdağı ve gönül alma. Terazi, grup itibarı, kanıt, asker ve yorgunluk `gerekli` değeri en çok eksi üç ile artı üç arasında değiştirir. Zar atılmadan önce tutan her madde ayrı satırda görünür. Beşinci yaklaşım adı reddedilir. Kalp veya romans eşiği yoktur.
  - Kurallar:
    1. Dört yaklaşım vardır: ikna, blöf, gözdağı, gönül alma. Beşinci tür yazılamaz.
    2. Değiştiriciler: terazi (adil iken ikna ve gönül alma −1; yoz iken gözdağı −1), grup itibarı (uçta en çok ±1), bulunmuş kanıt −1, yanındaki asker gözdağı −1, yorgunluk +1.
    3. Eksi, `gerekli` değerini düşürür. Artı yükseltir. Toplam −3…+3 dışında kesilir.
    4. Zar öncesi liste her tutan maddeyi ayrı satır gösterir. Gizli değiştirici yoktur.
    5. Tablo `data/zar_degistiricileri.json` içindedir. Skor kaynağı KOP-06’daki mevcut terazidir.
  - Uç durumlar: asker yokken asker satırı listede hiç yazılmaz. İki kanıt ikinci −1 vermez; “bulundu mu” sayılır. Toplam −4 hesaplanırsa −3’e kesilir ve listede kesildiği yazar.
  - Kabul: Adil terazi ve bulunan kanıt ikna eşiğini 2 düşürür; asker iknaya yazmaz (`tests/unit/kapi/zar_degistirici_test.gd`). Yoz gözdağı 1 düşürür. Toplam eksi 4 hesaplanırsa eksi 3'e kesilir. Ek şart: kalp veya romans anahtarı 1 hata verir.
  - Bağımlılık: ZAR-01, DIY-12. Boyut: M.
  - Dosya: yeni `src/kapi/zar_degistiricileri.gd`, `data/zar_degistiricileri.json`.
  - Asset: asset gerekmedi.

### 17.5 Beyaz ve kırmızı

- [ ] **ZAR-05:** Tekrar edilebilir ve tek şanslık kontroller.
  - Ne: Beyaz kontrol aynı koşul kümesiyle ikinci kez atılmaz; kanıt veya tansiyon bandı değişince yeniden açılır. Kırmızı kontrol bir kez atılır ve sonuç kalıcıdır; başarı da başarısızlık da dalı kapatır. Kod türü kendiliğinden değiştirmez. Menü açılıp kapanınca tekrar hakkı düşmez. Odak değişimi zarı yeniden atmaz.
  - Kurallar:
    1. Kontrol türü `tekrar` veya `tek_sans` olarak veride yazar.
    2. `tekrar` aynı koşul kümesiyle ikinci kez atılmaz. Koşul değişince (kanıt, tansiyon bandı veya güven eşiği) yeniden açılır.
    3. `tek_sans` kırmızı kenarlıdır, bir kez atılır, sonuç kalıcıdır. Yalnız sır ve ikilem düğümlerinde durur (DIY-10).
    4. Tek şansın başarısı da başarısızlığı da dalı kapatır. İkisi de ikinci kez açılmaz.
    5. Tür boşsa doğrulayıcı hata verir. Boş tür sessizce `tekrar` sayılmaz.
  - Uç durumlar: sır dışında yazılan `tek_sans` dosyayı geçirmez. Karakter kaçıp dönerse tek şans sonucu hafızada durur, düğüm açılmaz. `tekrar` kontrolünde zar 1 gelmişse koşul aynıyken düğme kilitlidir.
  - Kabul: Koşul değişmeden ikinci beyaz atış 0'dır; kanıt eklenince 1 atış daha açılır (`tests/unit/kapi/zar_tur_test.gd`). Sır dışında `tek_sans` 1 hata verir. Ek şart: menü açılıp kapanınca tekrar hakkı aynı kalır.
  - Bağımlılık: ZAR-01, DIY-10. Boyut: S.
  - Dosya: şema + `sorgu_zari.gd`.
  - Asset: asset gerekmedi.

### 17.6 Sezgi

- [ ] **ZAR-06:** Muhafız sezgisi — zarsız pasif kontrol.
  - Ne: Tecrübe ve geçmiş eşiği geçince ek bir satır kendiliğinden görünür; zar atılmaz. Eşik altındayken satır da ipucu da yoktur. Sezgi beyan değildir. Bir ziyarette en çok bir kez açılır. Sır çekirdeğinde her CHR'de en az bir sezgi satırı vardır.
  - Kurallar:
    1. Muhafız tecrübesi ve ACL-06 geçmişi eşiği geçince ek satır kendiliğinden görünür. Zar atılmaz.
    2. Eşik `data/` içindedir. Bakıştaki ek yorum (DYL-02) aynı eşiği kullanır. İkinci eşik yoktur.
    3. Sır çekirdeğinde her CHR’de en az 1 sezgi satırı vardır. Dürüst çekirdekte zorunlu değildir (DIY-01a).
    4. Eşik altındayken satır görünmez ve ipucu üretmez.
    5. Sezgi beyan değildir. İpucu üretirse `Clue_*` ile aynı anahtarı kullanır.
  - Uç durumlar: geçmiş o sezgiyi açmıyorsa satır gizlenir; genel sezgi varsa o gelir. Işık kapalıysa bakış sezgisi de gizlenir. Eşik eşitse satır görünür.
  - Kabul: Tecrübe eşiğin bir altındayken sezgi ipucu 0, eşitken 1'dir (`tests/unit/soz/sezgi_test.gd`). Zar çağrısı 0'dır. Ek şart: aynı ziyarette ikinci sezgi satırı 0'dır.
  - Bağımlılık: DIY-09, ACL-06. Boyut: S.
  - Dosya: yeni `src/soz/muhafiz_sezgisi.gd`.
  - Asset: asset gerekmedi.


CAT-01 … CAT-04 gövdesi durur. Yeni maddeler CAT-05 … CAT-84. Beşinci seçenek ve yeni ceza yoktur.

### 18.1 Kavga ne zaman

- [ ] **CAT-01:** Geri çevrilen kavga çıkarabilir.
  - Ne: Yer yokluğu veya sert ret, tip listesindeki genç erkek, aç aile reisi ya da asker kaçağında kavga isteği doğurur. Kavga yalnız kapıda ve en az bir asker varken açılır. Asker yoksa kişi tehdit edip gider; tanık varsa bu gidiş dedikoduya yazılır. Köy meydanı, şifahane ve divanda kavga sahnesi yoktur. Heyet sırasında kavga açılmaz.
  - Kurallar:
    1. Kavga isteği iki koşulla doğar: yer yokluğu veya sert ret; karakter tipi genç erkek, aç aile reisi veya asker kaçağı. Tip veridedir.
    2. Kavga yalnız kapıda ve en az 1 asker varken açılır.
    3. Asker yoksa kişi tehdit edip gider. Tanık varsa bu gidiş dedikoduya yazılır (DIY-13). Kavga sahnesi açılmaz.
    4. Köy meydanı, şifahane ve divanda kavga sahnesi yoktur.
    5. Tip listesinde olmayan ret sıradan rettir. Zorunlu kavga seçeneği eklenmez.
  - Uç durumlar: asker kapıdan ayrılırsa açılmamış istek “tehdit edip gitti”ye döner. Sahne başlamışsa seçenekler kapanır ve sonuç kaçış sayılır. Aynı kişi aynı gün ikinci kavga isteği üretmez. Heyet sırasında (KOP-02) kavga açılmaz.
  - Kabul: Askersiz köyde kavga sahnesi 0'dır (`tests/unit/kapi/kapi_kavgasi_test.gd`). Tip listesinde olmayan rette kavga bayrağı 0'dır. Asker 1 ve tip uygunken bayrak 1'dir. Ek şart: yeni ses dosyası, kan efekti ve ikinci harita eklenmez.
  - Bağımlılık: ACL-05, DIY-13. Boyut: M.
  - Dosya: yeni `src/kapi/kapi_kavgasi.gd`.
  - Asset: asset gerekmedi.


### 18.2 Dört seçenek

- [ ] **CAT-02:** Kavga seçenekleri — askerle karşılık, akçeyle erteleme, sözle yatıştırma, reddetme.
  - Ne: Kapıdaki kavgada oyuncu dört yoldan birini seçer: askerle karşılık, akçeyle erteleme, sözle yatıştırma veya reddetme. Askerle karşılık zar atar ve yaralanma, ölüm, kaçış ya da kin bırakır. Akçe yetmezse erteleme kilitli görünür. Beşinci seçenek yoktur. Kalp alanı yazılmaz.
  - Kurallar:
    1. Dört seçenek vardır: askerle karşılık, akçeyle erteleme, sözle yatıştırma, reddetme. Beşinci seçenek yazılamaz.
    2. Askerle karşılık asker becerisi ve ZAR-01 kullanır. Sonuç yaralanma, ölüm, kaçış veya kindir. Sonuç tablosu veridedir.
    3. Akçeyle erteleme DYL-05 `yarin_gel` sözünü açar. Kişi 2–4 gün sonra döner. Söz tutulmazsa grup itibarı −1 olur. Akçe `muhafiz_akce` hesabından düşer.
    4. Yatıştırma ikna veya gönül alma zarıdır. Reddetme kin ve, tanık varsa, dedikodu yazar; kavga anında biter.
    5. Ölüm, duran nüfus ve cenaze akışına haber verir. Yeni cenaze sistemi kurulmaz.
  - Uç durumlar: akçe yetmezse erteleme kilitli görünür. Asker ölürse karşılık seçeneği kapanır, diğer üçü durur. Açık söz sayısı 5 ise (DYL-05) erteleme kilitlidir ve nedeni yazar. Kin ile kaçış ayrı kayıt kimliğidir.
  - Kabul: Dört seçenek dört ayrı sonuç kimliği üretir (`tests/unit/kapi/kavga_secenek_test.gd`). Erteleme `verilen_soz` kaydına 1 satır yazar. Ölüm cenaze akışına tek çağrı yazar. Ek şart: kalp anahtarı 1 hata verir. Ek şart: aynı seçeneğe iki tıkta sonuç bir kez yazılır.
  - Bağımlılık: CAT-01, ZAR-01, DIY-11. Boyut: M.
  - Dosya: `src/kapi/kapi_kavgasi.gd`.
  - Asset: kavga canlandırması için envantere `CAT02-KAVGA` animasyon; yer tutucu sarsıntı + metin.

### 18.3 Yaralı

- [ ] **CAT-03:** Yaralının tedavisi — hekim varsa iyileştirir.
  - Ne: Kavga yaralısı, bizden ya da yabancı, şifahane varsa hekime gider. Hekim varsa duran iyileşme akışı sağlığı yükseltir; hekim yoksa veya hekim kendisi yaralıysa kayıp sürer. Yabancı tedavi edilip gönderilirse grup itibarı bir artar ve köylü olmaz. Ölü hekime gitmez. Aynı yara ikinci gece bir daha iyileşmez.
  - Kurallar:
    1. Yaralı bizden veya yabancı olabilir. İkisi de Şifahane’ye gidebilir.
    2. Hekim varsa mevcut KRI-03 akışı iyileştirir. Hekim yoksa sağlık kaybı sürer. Yeni ilaç üretilmez.
    3. Yabancı yaralıyı tedavi edip göndermek grup itibarını +1 yazar.
    4. Şifahane `false` ise (DIY-08) tedavi seçeneği görünmez.
    5. Ölüm bu maddeye girmez. Ölü hekime gitmez.
  - Uç durumlar: hekim kendisi yaralıysa tedavi edemez; sağlık kaybı sürer. İki yaralı aynı gece varsa hekim birini seçer, diğeri bekler. Bekleyen yabancı gece ölürse itibar artışı yazılmaz. Tedavisi biten yabancı köylü olmaz, gider.
  - Kabul: Hekim ve şifahane varken sağlık deltası pozitiftir; hekim yokken kayıp sürer (`tests/unit/koy/hekim_yara_test.gd`). İtibar artışı yalnız "tedavi edip gönder"de 1'dir. Ek şart: aynı yara ikinci gece sağlık deltası 0'dır.
  - Bağımlılık: CAT-02. Boyut: S.
  - Dosya: `src/koy/hekim_ilac.gd` adaptör.
  - Asset: asset gerekmedi.


### 18.4 Sıranın korkusu

- [ ] **CAT-04:** Kapıda şiddet sırayı korkutur.
  - Ne: Askerle karşılık veya ölüm, sıradaki kişilerin tansiyonunu okur. Eşik üstündekiler tablodaki olasılıkla ayrılabilir; herkes ayrılmaz. Yatıştırma ve erteleme bu ayrılmayı tetiklemez. Yeni korku barı açılmaz. Menü açıkken artış donar.
  - Kurallar:
    1. Şiddet, karşılık veya ölüm sonucudur. Sıradaki kişilerin sabrı ve tansiyonu okunur.
    2. Tansiyonu eşik üstü olan sıradaki ayrılabilir. Eşik `data/` içindedir. Herkes ayrılmaz.
    3. Ayrılan kişi sonraki gün, tanık kuralıyla, dedikodu taşır (DIY-13).
    4. Yatıştırma ve erteleme şiddet sayılmaz. Ayrılma tetiklemez.
    5. Olasılık tabloyla sabittir. Kod içine gömülü oran yoktur.
  - Uç durumlar: sırada kimse yoksa ayrılma 0, dedikodu da 0’dır. Ayrılan kişi o ziyaretin konusuysa ikinci kez kaçmaz. Şiddet heyet sırasında olmaz (KOP-02). Tabloda olasılık 0 ise test ortamında da ayrılan 0’dır.
  - Kabul: Eşik altı sırada ayrılan 0'dır (`tests/unit/kapi/siddet_korkusu_test.gd`). Eşik üstü ve olasılık 1 olan satırda ayrılan 1'dir. Yatıştırmada ayrılan 0'dır. Ek şart: menü açılıp kapanınca tansiyon artışı değişmez.
  - Bağımlılık: CAT-02, BUG-20. Boyut: S.
  - Dosya: yeni `src/kapi/siddet_korkusu.gd`.
  - Asset: asset gerekmedi.


Amaç: Söz motorunu (Bölüm 16) ve yazım hattını (Bölüm 19) derinleştirmek. Burada yeni sistem kurulmaz. Her madde var olan bir sistemin üstüne oturur: beyan defteri, kişi hafızası, dedikodu, eş, gecikmeli etkiler, kapsam taraması. Hepsi önce `Roadmap-2/soz_agaci` prototipinde Yusuf sahnesiyle denenir. Prototipte işe yaradığı görülmeden Godot'a geçmez.

**Bölümün ortak kuralları (her maddede geçerli, tekrar yazılmaz):**
- Her sorgu eylemi (göstermek, bakmak, yemin ettirmek, tercüman çağırmak) sıra sabrından düşer (DIY-05). Bedava eylem yoktur.
- Her eylemin sonucu veri dosyasındadır; kod karakter adı veya metin bilmez.
- Her etki mevcut bir değere yazılır: tansiyon, güven (DIY-17), grup itibarı (DIY-12), muhafız terazisi ve vicdanı, eşin morali, kişi hafızası (DIY-11), dedikodu (DIY-13). Bu bölüm için yeni bir sayaç açılmaz.
- Yazım araçları gözlem verir, karar vermez. Uyarıyı yazar gerekçe yazarak geçebilir.
- Ses dosyası yoktur. Bütün araçlar metinle çalışır.

DYL-01 … DYL-16 gövdesi durur. Yeni maddeler DYL-17 … DYL-96. İkinci diyalog motoru yok.

### 25.1 Çelişki ve bakış

- [ ] **DYL-01:** Çelişkiyi yüzüne vurmak — iki kaydı oyuncu kendisi eşleştirir.
  - Ne: Oyuncu defterden iki kaydı kendisi seçer; motor çifti otomatik eşleştirmez. Doğru çift yüzleşme dalını açar. Yanlış çift tansiyonu bir artırır, güveni iki düşürür ve aynı çift bir daha denenemez. Üç yanlıştan sonra "Göster" o ziyarette kapanır. İlk üç gün hazır "Yüzleş" düğmesi de durur, sonra yalnız "Göster" kalır.
  - Kurallar:
    1. Sorgu panelinde "Göster" eylemi. Oyuncu defterden iki kayıt seçer: beyan + ipucu, beyan + beyan ya da beyan + duyduğu söz (başka bir karakterin beyanı veya dedikodu, DIY-11/13).
    2. Sahne verisinde `celiskiler: [{a, b, dal, guc}]`. `a` ve `b` kayıt kimlikleridir; sıra önemsizdir.
    3. Doğru çift, o çelişkiye özel yüzleşme dalına geçer (DIY-07 dalları buradan tetiklenir).
    4. `guc: "guclu"` doğrudan dala gider. `guc: "zayif"` ikna zarı açar, kanıt değiştiricisi −1 (ZAR-04).
    5. Yanlış çift: tansiyon +1, güven −2, sabır −1. Karakterin kendine özgü tepki satırı gelir ("Ne alakası var bunun?"). Tepki satırı yoksa varsayılan satır kullanılır.
    6. Aynı yanlış çift ikinci kez denenemez. Üç yanlıştan sonra "Göster" o ziyarette kapanır, karakter muhafızı ciddiye almaz (gözdağı +1).
    7. Defterdeki her kaydın yanında nereden geldiği yazar: hangi soruda söylendi, hangi bakışta görüldü.
    8. Zorluk ayarı `celiski_yardimi`: açıkken bugünkü gibi hazır "Yüzleş" seçenekleri de görünür (öğretici ve kolay oyun); kapalıyken yalnız "Göster" kalır. Varsayılan: ilk 3 gün açık, sonra kapalı.
  - Uç durumlar: aynı ipucu iki çelişkide birden yer alabilir; çözülmüş çelişki defterde üstü çizili görünür ve yeniden gösterilemez. Karakter kaçarsa (ZAR-03) gösterilmemiş çelişkiler kişi hafızasına "çözülmedi" diye yazılır, karakter dönerse yeniden kullanılabilir. Defterde tek kayıt varken Göster kilitlidir; bir kayıt kendisiyle eşleşmez.
  - Kabul: Yusuf'un beş yüzleşmesi çelişki çiftiyle kurulur; elle yazılmış yüzleşme seçeneği 0 kalır (`tests/unit/soz/celiski_goster_test.gd`). Üç yanlıştan sonra "Göster" kapanır. Tek kayıtta "Göster" 0'dır. Ek şart: `koy_sahnesi` import edilmez.
  - Bağımlılık: DIY-06, DIY-07. Boyut: M.
  - Dosya: `src/soz/celiski.gd` (DIY-07 dosyası genişler, ikinci sistem yok); yeni `src/arayuz/kapi/beyan_defteri_paneli.gd`.
  - Asset: asset gerekmedi (defter paneli ARY şablonuyla).

- [ ] **DYL-02:** Bakmak — konuşmadan süzmek.
  - Ne: Oyuncu yüz, eller, çarık, giysi, yük ve yanındakilere bakar; her bakış sabırdan bir düşer ve bir gözlem satırı verir. Işık kapalıysa ayrıntı ve ipucu gelmez. Aynı bölgeye ikinci bakış yeni bilgi vermez. Tecrübe eşiği altındayken ek yorum satırı görünmez. Hastalık belirtisi bu bakışın bir bölgesidir; ikinci vücut haritası açılmaz.
  - Kurallar:
    1. Sorgu panelinde "Bak" eylemi, bölgelere ayrılır: yüz, eller, ayak ve çarık, giysi, yük (dokunmadan; heybeyi açmak ayrı eylemdir), yanındakiler (hayvan, çocuk, eşya).
    2. Her bakış sabırdan 1 düşer ve bir gözlem satırı verir (anlatı). Gözlem bir ipucu üretebilir.
    3. Muhafız tecrübesi eşiği geçerse aynı bakış ek yorum satırı verir ("Nasırsız el. Reçber eli değil bu."). Bu, ZAR-06 sezgisinin kullandığı eşiktir, ikinci eşik yoktur.
    4. Işık koşulu: akşam ve kışın bazı ayrıntılar görünmez (`kosul.baglam.isik`). Kapı meşalesi yanıyorsa görünür (BUG-25).
    5. Karakter bakılmaya tepki verebilir: uzun süzmek (aynı bölgeye ikinci bakış ya da üç bölgeden fazlası) karaktere özgü tepki satırı getirir ve güveni düşürür. Tepkiyi yazar yazar; yazmazsa tepki olmaz.
    6. Aynı bölgeye ikinci bakış yeni bilgi vermez, yalnız tepki riskini taşır.
    7. Bakış verisi modelde görünenle tutarlı olmalı. Görselde olmayan bir ayrıntı yazılmışsa doğrulayıcı onu "görsel bekliyor" diye listeler ve satır envantere bağlanır.
    8. CHR'lerdeki mevcut görsel hata verisi bu eylemle okunur, ayrı bir inceleme yolu kalmaz.
  - Şema: `bakislar: {bolge: {satirlar[], ipucu, kosul, tepki[]}}`.
  - Uç durumlar: Heybeyi açmak bakış sayılmaz; kendi eylemidir ve bu maddenin sabrını ayrıca harcamaz. Işık kapalıyken bölge düğmesi durur, gözlem satırı ve ipucu gelmez. Üç bölgeden sonraki bakış tepki eşiğini aşar, yeni ipucu üretmez.
  - Kabul: Yusuf'ta eller, çarık, kese ve yüzde bakış vardır (`tests/unit/soz/bakis_test.gd`). Her bölge sabırdan 1 düşer. Işıksız yüzde ipucu 0'dır. Tekrar bakış yeni ipucu üretmez.
  - Bağımlılık: DIY-02, ZAR-06, BUG-25. Boyut: M.
  - Dosya: yeni `src/soz/bakis.gd`; sorgu paneline eylem düğmesi.
  - Asset: karakter ayrıntıları (yamalı çarık, nasırlı el, sarılı yara, yanık giysi) envantere `DYL02-AYRINTI-*`; yer tutucu: modelin ilgili bölgesinde düz renkli küçük kutu + gözlem metni.

### 25.2 Yemin, yalan, söz

- [ ] **DYL-03:** Yemin ettirmek.
  - Ne: Oyuncu ziyarette bir kez "El bas, yemin et" der. Yemin şekli karakterin inancına göre dünya kitabından gelir; uymayan şekil hakarettir. Tutum dört türden biridir: eder, kıvranır, rahat ya da reddeder. Yemin zar açmaz. Bozulan yemin bir kez ceza yazar. İnanç alanı boşsa düğme gizlenir.
  - Kurallar:
    1. Seçenek: "El bas, yemin et." Ziyaret başına bir kez kullanılır.
    2. Yemin şekli karakterin inancına ve grubuna göre değişir. Hangi grup neye yemin eder, dünya kitabından gelir (YAZ-01). Örnekler kaynakla doğrulanmadan oyuna girmez.
    3. Yanlış şekil teklif etmek (karakterin inancına uymayan yemin) hakarettir: güven −3, grup itibarı −1.
    4. Karakter verisinde `yemin: {tutum, satirlar}`. Tutum dört türden biridir:
      - `eder`: dürüst kişi hemen eder.
      - `kivranir`: inançlı yalancı kaçamak cevap verir. İpucu `yemin_kacamak` oluşur.
      - `rahat`: inançsız yalancı rahatça yemin eder. Yalan yemin bayrağı gizli olarak düşer.
      - `reddeder`: inancı yemine izin vermeyen kişi gerekçesiyle reddeder. Bu bir yalan belirtisi değildir.
    5. Bedel: yemin istemek tansiyonu 1 artırır. Saygın kişide (derviş, ahi babası, yaşlı) güveni de 2 düşürür.
    6. Yalan yemin sonradan ortaya çıkarsa (DYL-08 dönüşü, dedikodu) kişi grubunda ağır itibar kaybı yaşar ve muhafız terazisine yazılır ("yalan yemine göz yumdun" değil, "yalan yemin edeni içeri aldın").
  - Uç durumlar: İnanç alanı boşsa yemin düğmesi gizlenir, hakaret yazılmaz. `reddeder` tutumu yalan bayrağı ve `yemin_kacamak` ipucu yazmaz. Sır açıldıktan sonraki satır, açılmadan önceki satırın yerine geçer; ikisi birden görünmez.
  - Kabul: Dört tutum dört ayrı sonuç verir (`tests/unit/soz/yemin_test.gd`). İkinci yemin seçeneği görünmez. İnanç alanı boşken yemin düğmesi 0'dır. Ek şart: yemin satırı zar atışı açmaz. Ek şart: bozulan yemin ikinci ceza yazmaz.
  - Bağımlılık: DIY-02, DIY-12, YAZ-01. Boyut: S.
  - Dosya: yeni `src/soz/yemin.gd`.
  - Asset: yemin nesneleri (dünya kitabına göre) envantere `DYL03-YEMIN`; yer tutucu: düz renk kutu + etiket.

- [ ] **DYL-04:** Muhafız da yalan söyler.
  - Ne: Oyuncu yalan seçeneğinin yanında "Yalan" etiketini görür; kandırılan karakterdir. Yalan tansiyonu düşürür ya da gözdağını kolaylaştırır. Köyde gerçek görülürse ertesi gün kişi hafızasına `muhafiz_yalani` yazılır. Tanık varsa dedikodu da yayılır. Sözlükte olmayan `gercek` anahtarı 1 hata verir.
  - Kurallar:
    1. Seçenekte `soylenen: {id, metin, dogru: false, gercek}`. `gercek` kontrol edilebilecek bağlam alanını gösterir (asker sayısı, beyin köyde olup olmadığı, yatak sayısı).
    2. Oyuncu yalan söylediğini bilir: seçeneğin yanında küçük işaret ve "Yalan" etiketi bulunur. Oyuncu kandırılmaz, karakter kandırılır.
    3. Faydası: tansiyon düşürür ya da gözdağını kolaylaştırır (−1). Hangisi olduğu seçenekte yazar.
    4. Ortaya çıkma yolları:
      1. Karakter içeri alınır ve köyde gerçeği görür (`gercek` alanı köyde gözlenebilir). Ertesi gün kişi hafızasına `muhafiz_yalani` yazılır.
      2. Dedikodu ile yayılır (DIY-13, tanık kuralı geçerli).
      3. Karakter yalanı anında sezer. Hangi koşulda sezeceğini yazar belirler (tecrübeli asker, köyü tanıyan kişi).
    5. Yakalanınca: güven −4, grup itibarı −1, vicdan kaydı. Dönen karakterin selamı bu varyanta geçer (DIY-11).
    6. "Senin söylediklerin" listesinde yalanlar ayrı renkte durur. Oyuncu ne söylediğini unutmaz.
  - Uç durumlar: Tanık yoksa dedikodu yolu susar; köyde gözlenen `gercek` alanı ertesi gün yine açığa çıkarabilir. `gercek` sözlükte yoksa yalan sessiz kalır ve doğrulayıcı 1 hata verir. Aynı ziyarette sezilen yalan gece denetiminde ikinci ceza yazmaz.
  - Kabul: Yusuf'taki "Bey içeride, kırk atlısı var" kaydı `dogru:false` taşır (`tests/unit/soz/yalan_denetimi_test.gd`). Köyde gözlenen alan yalanı açığa çıkarır. Aynı yalan için ceza kaydı 1'dir.
  - Bağımlılık: DIY-18, DIY-11, DIY-13. Boyut: M.
  - Dosya: `src/soz/` muhafız beyanı kaydı (DIY-18 dosyası); yeni `src/soz/yalan_denetimi.gd` (gece sonu, köyde gözlenen alanları karşılaştırır).
  - Asset: asset gerekmedi.

### 25.3 Dil ve akşam

- [ ] **DYL-05:** Söz vermek — tutulan ve tutulmayan söz.
  - Ne: Oyuncu "yarın gel" ya da "aileni ararım" dediğinde söz kişi hafızasına ve "Verdiğin sözler" listesine düşer. Süre dolunca kişi kapıya zorunlu gelen olarak gelir; sistem yatak ya da divan kaydına bakarak sözün tutulup tutulmadığını kendisi sayar. Tutulan söz güveni artırır, tutulmayan söz itibarı düşürür ve tanık varsa dedikodu açar. Aynı anda en çok beş açık söz vardır. Söz kimliği dosyada tekildir; tutulan sözün ödülü bir kez yazılır.
  - Kurallar:
    1. Seçenekte `soz: {id, tur, sure_gun, kosul}`. Türler: `yarin_gel` (yer açılınca), `beyle_konusurum`, `aileni_ararim` (kervan ya da gözcü sorar), `isini_ayarlarim`. Tür listesi veride.
    2. Söz kişi hafızasına ve muhafızın defterinde "Verdiğin sözler" listesine yazılır; süresi yaklaşınca bir gün önce hatırlatma çıkar.
    3. Süre dolunca karakter kendiliğinden kapıya gelir (KAP-16 gelen akışına zorunlu gelen olarak eklenir).
    4. Tutulup tutulmadığını sistem denetler (yatak boş mu, divanda ilgili eylem yapıldı mı vb.). Oyuncunun beyanına bakılmaz.
    5. Tutulan söz: güven ve grup itibarı artar; karakterin dönüş sahnesi "tuttun" varyantıyla açılır.
    6. Tutulmayan söz: itibar düşer, dedikodu yayılır, dönüş sahnesi sitem varyantıyla açılır.
    7. Söz verilen kişi her zaman dönmeyebilir (yolda öldü, başka köye yerleşti); bu ihtimal DYL-08 dönüşüyle bildirilir.
    8. Aynı anda en çok 5 açık söz. Altıncı söz seçeneği kilitli görünür ve nedeni yazar.
  - Uç durumlar: Süre 0 gün yazılırsa dosya geçmez. Kişi süre dolmadan ölürse söz düşer, itibar cezası yazılmaz, haber DYL-08 `haberci` kanalına gider. Açık söz 5 iken altıncı söz ve CAT-02 ertelemesi birlikte kilitlidir.
  - Kabul: Yusuf'u yer yokken çevirirken "yarın gel" sözü kayda düşer ve süre dolunca iki dönüş varyantından biri açılır (`tests/unit/soz/verilen_soz_test.gd`). Açık söz altıya çıkmaz. Süre 0 olan söz 1 hata verir. Ek şart: aynı söz kimliği ikinci kez 1 hata verir. Ek şart: tutulan sözün ödülü ikinci kez yazılmaz.
  - Bağımlılık: DIY-11, KAP-16; CAT-02 bu maddeyi kullanır. Boyut: M.
  - Dosya: yeni `src/soz/verilen_soz.gd`; muhafız defterine liste (oda ekranı adaptörü).
  - Asset: asset gerekmedi.

- [ ] **DYL-06:** Dil engeli ve tercüman.
  - Ne: Ortak dil yoksa oyuncu kırık Türkçe ya da "Rumca bir şeyler söylüyor" anlatısını görür; yabancı dilde tam cümle yazılmaz. Köyde o dili bilen biri varsa tercüman çağrılır, sabır iki düşer ve o köylü o gün yarım çalışır. Köyde tercüman yoksa düğme görünmez. Tercüman kendi grubuna göre satırı yumuşatabilir; eş tercüman çarpıtmaz. Ayrı bir tercüman motoru açılmaz.
  - Kurallar:
    1. Karakter verisinde `diller`; muhafızın dilleri geçmişinden gelir (ACL-06: medreseli Arapça ve Farsça, levent biraz Rumca). Köylülerin bildiği diller köylü verisinde optional alan.
    2. Ortak dil yoksa karakter satırlarının `kirik` varyantı gelir: kırık Türkçe ya da anlatı ("Rumca bir şeyler söylüyor. Arada 'Kayseri' diyor."). Oyunda yabancı dilde cümle yazılmaz; yalnız kırık Türkçe ve anlatı kullanılır.
    3. Ortak dil yokken konu merkezi daralır: yazar hangi konuların işaretle anlaşılabildiğini seçer (2–3 konu).
    4. Tercüman çağırmak: köyde dili bilen biri varsa çağrılır. Sabır −2, o köylü o gün yarım çalışır (ISG iş gücü hesabına tek satır).
    5. Tercüman tarafsız değildir. Kendi grubuna ve karakterine göre bazı satırları yumuşatır ya da çarpıtır (`tercuman` varyantları). Tecrübe eşiği üstünde muhafız çarpıtmayı sezer (sezgi satırı).
    6. Eş tercüman olabilir. Çarpıtmaz, ama akşam sohbetinde (DYL-07) duyduğunu anar.
    7. Tercümansız karar verilebilir; bu durumda beyan defterinde "anlaşılamadı" kayıtları kalır.
  - Yazım yükü: çok dilli her karakter için iki metin yazılır (anlaşılan ve kırık). Doğrulayıcı eksik `kirik` varyantını hata sayar.
  - Uç durumlar: Ortak dil varken `kirik` varyant seçilmez. Tercüman köylünün iş gücü 1.0 ise çağrıdan sonra 0.5 olur; zaten 0.5 ise ikinci çağrı 0’a indirimez. Eş tercüman çarpıtma varyantı üretmez.
  - Kabul: Ortak dil yokken yalnız kırık satırlar gelir; tercüman çağrılınca tam satırlar gelir (`tests/unit/soz/dil_engeli_test.gd`). Tercüman köylünün iş gücü 1.0 iken çağrıdan sonra 0.5 olur. Ortak dilde kırık satır 0'dır. Ek şart: tercüman bayrağı yokken düğme 0'dır.
  - Bağımlılık: DIY-09, DIY-12, ACL-06. Boyut: M.
  - Dosya: yeni `src/soz/dil_engeli.gd`; köylü verisine optional `diller`.
  - Asset: asset gerekmedi.


### 25.4 Dönüş, denetçi, varyant

- [ ] **DYL-07:** Akşam eşle konuşmak (ACL-03'ün ayrıntılı tasarımı).
  - Ne: Gece raporundan önce ocak başında en çok bir sohbet açılır. Konu, günün kararları arasından ağırlık tablosuna göre seçilir; eşin mesleği cümleyi değiştirir. Eş, muhafızın görmediği bir şeyi söyleyebilir ve bu ertesi gün ipucu olur. Sohbet atlanabilir, atlamanın cezası yoktur. Meclis gecesinde ve eş ölmüşken sohbet açılmaz. Yeni ses dosyası eklenmez.
  - Kurallar:
    1. Gece raporundan önce, ocak başında, en çok bir sohbet. 2–4 eş repliği, muhafız için 2–3 cevap: savunmak, kabul etmek, susmak.
    2. Konu, günün kararları arasından ağırlık tablosuna göre seçilir (`data/soz/aksam_konulari.json`). Örnek ağırlıklar: aileyi bölmek 5, rüşvet 5, çocuklu aileyi çevirmek 4, yalan yemin edeni almak 3, yakalanan yalan 3, tutulmayan söz 3. Eşit ağırlıkta en yeni olay seçilir.
    3. Eşin mesleği bakış açısını belirler: ebe hastalığı, fırıncı erzakı, dokumacı kadınlar arasındaki sözü anar. Her konuda en az 2 meslek varyantı yazılır.
    4. Eş muhafızın görmediğini söyleyebilir (kapının yanında gördüğü, köyde duyduğu). Bu bilgi ertesi gün ipucu ya da kişi hafızası olarak kullanılır.
    5. Eş geçmiş sohbetleri anar ("Geçen hafta da böyle demiştin"). Bunun için eşe ait küçük bir hafıza tutulur; DIY-11'in eş kaydıdır, ayrı sistem değildir.
    6. Etkiler: eşin morali ve muhafız terazisi (ACL-03). Muhafızın cevabı da etki taşır: susmak moral düşürmez ama terazi kaydına "kaçtı" yazar.
    7. Ağır karar yoksa gündelik kısa bir satır gelir ya da sohbet olmaz. Her gece konuşmak zorunlu değildir.
    8. Sohbet atlanabilir; atlamanın cezası yoktur.
  - İçerik ölçüsü: 10 konu × 3 tepki (ACL-03) × en az 2 meslek varyantı. Eşin ses kartı da YAZ-03 kurallarıyla yazılır.
  - Uç durumlar: Ağırlık tablosunda olmayan karar konu seçmez. Eş ölmüşse sohbet açılmaz ve ceza yazılmaz. İki olay aynı ağırlıktaysa ziyaret sırası büyük olan seçilir.
  - Kabul: Yusuf kararından sonra ağırlığı en yüksek olayın konusu seçilir (`tests/unit/koy/aksam_konu_test.gd`). Eşit ağırlıkta ziyaret sırası büyük olan konu gelir. Atlama barı değiştirmez. Ağırlığı 0 olan olay konu olmaz.
  - Bağımlılık: ACL-02, ACL-03, DIY-08, DIY-11. Boyut: M.
  - Dosya: `src/koy/aksam_sohbeti.gd` (ACL-03 dosyası); `data/soz/aksam_konulari.json`.
  - Asset: ocak başı ara sahne arka planı envantere `DYL07-OCAK`; yer tutucu: düz renk + metin, ARY-04 çerçevesi.

- [ ] **DYL-08:** Kararın sonradan dönüşü.
  - Ne: Bir kapı kararının sonucu günler sonra sabah raporu, başka bir gelenin haberi ya da köylü kartı olarak döner. Günde en çok iki dönüş gösterilir; üçüncüsü ertesi güne aynı kuyrukta kalır. Ölen kişinin dönüşü yalnız haberci kanalından gelir. Yeni sahne ve ikinci harita açılmaz.
  - Kurallar:
    1. Sahne verisinde her sonun `donusler: [{gun_min, gun_max, kosul, kanal, satirlar, etki}]` alanı olur.
    2. Kanal üç türden biridir:
      - `sabah`: sabah raporunda 2–4 satırlık kısa sahne.
      - `haberci`: kapıya gelen başka bir karakterin "Yolda ne gördün" konusunda geçer (DNY-02 kanalı).
      - `koylu`: köylü kartında ya da köy sohbetinde (YAZ-08).
    3. Dönüşün etkisi mevcut sisteme yazılır: salgın, moral, itibar, nüfus. Örnek: Yusuf gizlice alındıysa ateş salgın sistemine yazılır; şifahaneye alındıysa kız iyileşir ve Yusuf'un moraline yazılır.
    4. Dönüşlerin hepsi kötü değildir. Doğru kararın da dönüşü olur. Doğrulayıcı, bir sahnenin bütün dönüşleri cezaysa uyarır.
    5. Ağır kararların (DYL-07 tablosunda ağırlığı 4 ve üstü) en az bir dönüşü olmalı.
    6. Günde en çok 2 dönüş sahnesi gösterilir; fazlası ertesi güne kayar. Ölen ya da köyü terk eden karakterin dönüşü yalnız `haberci` kanalından gelir.
  - Uç durumlar: `gun_min` > `gun_max` ise dosya 1 hata verir. Ölen karakterin `sabah` ve `koylu` kanalı seçilmez, yalnız `haberci` kalır. Günlük 2 sınırını aşan üçüncü dönüş ertesi güne aynı KVR-08 kuyruğunda yazılır.
  - Kabul: Yusuf'un on bir sonundan en az altısının dönüşü gün aralığında gelir (`tests/unit/soz/karar_donusu_test.gd`). `gun_min` 5 ve `gun_max` 2 olan dönüş 1 hata verir. Üçüncü dönüş ayrı listede 0 satırdır. Ek şart: yeni sahne ve ikinci harita 0'dır. Ek şart: aynı kapı kararı ikinci sabah satırı yazmaz ve SAB-01 kancasına düşmez. Ek şart: ayrılan kişinin kimliği dönüş sahnesine girmez; satırda adı gitti diye işaretlenir. Ek şart: aynı dönüş bir barı bir kez değiştirir; ertesi gecede o barın deltası 0'dır. Ek şart: tanıklı dönüş mevcut dedikodu kaydına 1 satır düşer; tanıksız dönüşte dedikodu satırı 0'dır.
  - Bağımlılık: DIY-11, DNY-02, KVR-07/08. Boyut: M.
  - Dosya: yeni `src/soz/karar_donusu.gd` (kuyruğa yazan adaptör).
  - Asset: asset gerekmedi (ARY-04 çerçevesi).

### 25.5 Kör okuma ve yan yana

- [ ] **DYL-09:** Beyin denetçisi — sorgulanan muhafız.
  - Ne: Sancak beyinin adamı yedi ila on günde bir kapıya gelir ve muhafızı sorgular. Elinde dedikodu, kabul-ret sayısı ve tutulmayan sözler vardır. Teftiş koşulu tutmuyorsa sahne açılmaz. Sonuç övgü, uyarı ya da cezadır; üst üste iki ağır cezadan sonra görevden alma uyarısı mevcut son sistemine yazılır, altıncı son açılmaz.
  - Kurallar:
    1. Sancak beyinin adamı (HAR-04'teki beyle aynı kişi; unvanı dünya kitabından gelir) 7–10 günde bir gelir. Gelişi bir gün önce ulak ya da dedikoduyla duyulur.
    2. Denetçinin elindekiler: dedikodu kayıtları (DIY-13), ölçülebilir veriler (kabul ve ret sayısı, salgın, kasa, şiddet olayları) ve tutulmayan sözler (DYL-05).
    3. Sahne Söz motoruyla yürür. Konuşan denetçidir; seçenekler muhafızın cevaplarıdır. Tansiyon burada muhafızın gerginliğini ölçer.
    4. Denetçi de çelişki gösterir: muhafızın cevabını dedikodu kaydıyla karşılaştırır (DYL-01 ters yönde). Muhafız yalan söyleyebilir (DYL-04); yakalanırsa ağır bedel öder.
    5. Savunma zarı: muhafız ikna ya da gönül alma dener; zorluk denetçinin sorgu değeridir. ZAR-01 aynen geçerlidir.
    6. Sonuçlar: övgü (akçe ya da itibar), uyarı, ceza (akçe, birkaç gün yabancı kabul yasağı). Üst üste iki ağır cezadan sonra görevden alma uyarısı gelir. Oyun sonu yalnız mevcut son sistemine (SYS-20) bağlanır; yeni son yazılmaz.
    7. İlk denetçi gelmeden önce akşam sohbetinde eş bunu anar (DYL-07 konusu).
  - Uç durumlar: Denetçi günü gelmeden ceza uygulanmaz. Kabul yasağı yabancı kabulünü kapatır; heyet sahnesi (KOP-02) açık kalır. Üst üste iki ağır ceza SYS-20 koşuluna yazar, altıncı son açmaz.
  - Kabul: Temiz, karışık ve kötü defter için üç sahne vardır (`tests/unit/kapi/denetci_gelisi_test.gd`). Denetçi olmayan günde ceza bayrağı 0'dır. Kabul yasağında yabancı kabul 0, heyet sahnesi 1'dir.
  - Bağımlılık: DIY-02, DIY-13, DYL-01, DYL-04, HAR-04. Boyut: M.
  - Dosya: yeni `src/kapi/denetci_gelisi.gd`; sahne `data/soz/denetci_*.json`.
  - Asset: denetçi modeli envantere `DYL09-DENETCI`; yer tutucu: mevcut köylü modeli + renk farkı.

- [ ] **DYL-10:** Aynı karakter, farklı oyun — çekirdek varyantları.
  - Ne: Yusuf gibi kilit bir karakterin iki ya da üç çekirdeği aynı kimlikte durur; ikinci karakter kimliği açılmaz. Varyant oyun başında tohumla seçilir ve kayıtta değişmez. Heybe, bakış ayrıntısı ve dönüşler varyanta göre değişir. Dürüst Yusuf'ta yolda yedi ev yoktur.
  - Kurallar:
    1. Kilit karakterde 2–3 çekirdek bulunur (YAZ-09 türlerinden). Ortak kısım (selam, kimlik, çekirdekten bağımsız konular) bir kez yazılır; çekirdeğe bağlı düğüm ve satırlar `kosul.cekirdek` ile ayrılır.
    2. Varyant oyun başında tohumla seçilir, kayda yazılır ve o oyunda değişmez.
    3. Heybe içeriği, görsel ayrıntılar (DYL-02), bağlar (OZGUNLUK §6) ve dönüşler (DYL-08) varyanta göre değişir. Yusuf dürüstse yolda yedi ev de yoktur.
    4. Kadro denetimi (YAZ-09) bütün varyantları ayrı sayar ve kotayı beklenen değer üzerinden hesaplar.
    5. Önizleme aracında varyant seçici bulunur; kapsam taraması her varyantı ayrı yürütür.
  - Uç durumlar: Kayıtta tohum varsa çekirdek yeniden seçilmez. Dürüst varyantın heybesi boş olabilir; doğrulayıcı ipucu yok diye hata basmaz (DIY-01a). Hiçbir varyantta görünmeyen satır 1 hatadır.
  - Kabul: Aynı tohum ikinci açılışta aynı `cekirdek` değerini verir (`tests/unit/soz/cekirdek_secici_test.gd`). Yüz tohumda her varyant en az bir kez çıkar. Hiçbir varyantta görünmeyen satır 0 kalır.
  - Bağımlılık: YAZ-09, DIY-09. Boyut: M.
  - Dosya: yeni `src/soz/cekirdek_secici.gd`; kayıtta optional alan.
  - Asset: asset gerekmedi.


### 25.6 Örnek, site, fixtures

- [ ] **DYL-11:** Kör okuma testi — bu sözü kim söyledi?
  - Ne: İnceleme aracında seçilen ağızların replikleri adsız ve karışık sırayla gelir; okuyan her satırın konuşanını işaretler. Özel ad, yer adı ve karakterin kendi adı üç nokta ile kapanır. Sonuçta ağız başına doğru oranı ve en çok karışan çiftler durur. Şansın üstünde olup yüzde yetmişin altında kalan ağız için "ses kartları birbirine yakın" uyarısı çıkar.
  - Kurallar:
    1. İnceleme aracında ayrı sekme. Üç ya da dört ağız seçilir; yalnız karakter replikleri adsız ve karışık sırayla gelir.
    2. Ele veren bilgiler gizlenir: özel adlar, yer adları ve karakterin kendi adı "…" ile maskelenir. Maskelenecek sözcük listesi sahne verisinden otomatik çıkar.
    3. Okuyan her satır için kimin söylediğini seçer. Sonuçta karakter başına doğru oranı ve en çok karışan çiftler görünür.
    4. Eşik: şans düzeyinin üstünde ama %70'in altında kalan karakter için "ses kartları birbirine yakın" uyarısı çıkar. Şans düzeyi seçilen karakter sayısına göre hesaplanır.
    5. Aynı kişi testi tekrar yaparsa daha önce gördüğü satırlar öne çıkmaz.
    6. Sonuç inceleme dosyasına eklenir ve dışa aktarılır. Sahne dosyasının içine skor alanı yazılmaz.
  - Uç durumlar: Seçilen ağız sayısı 1 ise sekme kilitlenir; şans düzeyi hesaplanmaz. İki ağız seçilirse sonuç tablosu açılmaz. Maske listesi boşsa ve satırda özel ad kalmışsa skor yazılmaz. Aynı satır aynı oturumda ikinci kez öne çıkmaz.
  - Kabul: Yusuf ile iki ayrı ağız karışık listede maskesiz özel ad 0 bırakır ve doğru oranı hesaplanır (`tests/unit/soz/kor_okuma_test.gd`). Seçilen ağız 1 iken sekme kilitlidir. Maskelenmemiş özel ad varken skor satırı 0'dır. Ek şart: skor alanı olmayan dosya skor satırı yazmaz. Ek şart: oyun menüsünde kör okuma düğmesi yoktur. Ek şart: iki ağızla skor yazılmaz; skor satırı üç ağız ister.
  - Bağımlılık: YAZ-10, YAZ-03. Boyut: S.
  - Dosya: prototip `Roadmap-2/soz_agaci`; oyun tarafında `src/debug/soz_onizleme.gd` sekmesi.
  - Asset: asset gerekmedi.

- [ ] **DYL-12:** Muhafız tipleriyle tarama — sonlar dengeli mi?
  - Ne: Geliştirici aynı sahneyi beş muhafız tipiyle tarar; İnceleme sekmesinde son dağılımı, ortalama adım, sır açılma oranı ve kaçış oranı görünür. Sert tipte gözdağı seçimi yumuşak tipten yüksek çıkar. Bir tipte tek son yüzde seksenin üstündeyse ya da iki tip aynı dağılımı veriyorsa uyarı çıkar, son silinmez.
  - Kurallar:
    1. Muhafız tipleri veride (`data/soz/muhafiz_tipleri.json`):
      - sert: gözdağı, ikram yok, heybeye hemen bakar;
      - yumuşak: ikram eder, dinler, ikna dener;
      - açgözlü: rüşvet ve pazarlık;
      - meraklı: her konuyu açar, söz kesmez;
      - aceleci: az soru, hızlı karar.
    2. Tip, seçeneklerin özelliklerine ağırlık verir: zar yaklaşımı, tansiyon etkisi, kesme, ikram, karar türü. Yazarın ek etiket yazması gerekmez; gerekirse seçeneğe `tavir` etiketi eklenir.
    3. Her tip için rapor: sonların dağılımı, ortalama adım sayısı, sır açılma oranı (güvenle ya da korkuyla), kaçış oranı, ulaşılmayan düğümler.
    4. Gözlemler (hüküm değil):
      - bir tipte tek son %80'i geçiyorsa;
      - hiçbir tipte %1'i geçemeyen bir son varsa ve o son `nadir: true` diye işaretlenmemişse;
      - iki tip aynı dağılımı veriyorsa (tipler arasında fark yoksa sahne seçimlere tepki vermiyor demektir).
  - Uç durumlar: `nadir: true` son yüzde 1 altında kalsa da uyarı üretmez. İki tip aynı dağılımı verirse uyarı çıkar, son silinmez. Beş tipten biri dosyada yoksa tarama başlamaz.
  - Kabul: Yusuf sahnesi beş tiple taranır (`tests/tools/test_soz_tip_taramasi.py`). Sert tipin gözdağı oranı yumuşak tipinkinden yüksektir. `nadir: true` sonun uyarı sayısı 0'dır. Beş tipten biri dosyada yoksa tarama rapor satırı 0'dır ve 1 hata verir.
  - Bağımlılık: YAZ-10. Boyut: S.
  - Dosya: prototip; oyun tarafında `tools/soz_dogrula.py --tip`.
  - Asset: asset gerekmedi.

### 25.7 Kapı dışı sonuç

- [ ] **DYL-13:** Eski ve yeni metni yan yana görmek.
  - Ne: İnceleyen, işaret anındaki cümle ile yeni cümleyi kelime farkı olarak görür; eklenen yeşil, silinen kırmızı durur. "Yeniden yaz" ya da "yapay" işaretli satır değişince durum kendiliğinden "yeniden incele" olur. Satır yer değiştirirse `sid` işareti taşır; `sid` yokken benzer satır yalnız öneri verir ve hazır kimlik sayılmaz.
  - Kurallar:
    1. İşaretlendiği andaki metin zaten saklanıyor. Metin değişince eski ve yeni hâli kelime düzeyinde fark olarak gösterilir: eklenen yeşil, silinen kırmızı.
    2. "Yeniden yaz" ya da "yapay" işaretli bir satır değişince durumu kendiliğinden "yeniden incele" olur. İnceleyen yeni hâli yeniden işaretler.
    3. Her satırın sürüm geçmişi inceleme dosyasında tutulur. Kayıt, yazan ve inceleyen olmak üzere iki kişi adı ister.
    4. Satır yer değiştirdiyse kalıcı satır kimliği (`sid`, DYL-15) sayesinde işaret kaybolmaz. `sid` gelene kadar, metin benzerliğine göre "taşınmış olabilir" önerisi çıkar. Öneri, taşındı kimliğini hazır saymaz.
    5. Sahne özeti: kaç satır değişti; yapaylık uyarıları ve dolgu ile üç nokta oranları önce ve sonra.
  - Uç durumlar: `sid` yokken benzerlik eşiğinin altındaki satır otomatik eşlenmez, yalnız “taşınmış olabilir” önerisi çıkar. Değişmeyen satır “yeniden incele” olmaz. Yalnız boşluk farkı sürüm yazmaz. Eski cümle `data/soz` altına kopyalanmaz.
  - Kabul: Yusuf'un iki sürümünde değişen satırın durumu "yeniden incele" olur (`tests/unit/soz/metin_farki_test.gd`). Yalnız boşluk farkında sürüm sayısı 0'dır. Ek şart: kaydı olmayan taşındı kimliği hazır sayılmaz. Ek şart: eski cümle `data/soz` içine kopyalanmaz. Ek şart: sürüm kaydı iki kişi adı ister.
  - Bağımlılık: YAZ-10. Boyut: S.
  - Dosya: prototip; oyun tarafında `src/debug/soz_onizleme.gd`.
  - Asset: asset gerekmedi.

### 25.8 Eylem kadrajı

- [ ] **DYL-14:** Kaynaklı örnek defteri — bir köylü buna nasıl cevap verir?
  - Ne: Yazar, yapı türü ve durum için kaynaklı kısa örnekleri `docs/dunya_kitabi/ornek_defteri/` altında görür. İnceleme aracında yapaylık uyarısının yanında "örnek gör" bağlantısı, uyarının türüne uyan kayıtları açar. Model bu deftere satır yazmaz; kaynaksız kayıt listeye girmez.
  - Kurallar:
    1. `docs/dunya_kitabi/ornek_defteri/` altında kayıtlar tutulur. Her kayıtta:
      - yapı türü (USLUP_REHBERI §2 kategorileri);
      - durum (soruyu geçiştirme, yas, pazarlık, övünme, sitem, yalvarma);
      - kısa örnek;
      - kaynak (eser, sayfa, derleyen, yer, yıl);
      - ağız bölgesi;
      - not.
    2. Kaynak türleri USLUP_REHBERI §6'daki gibidir: göç ve mübadele tanıklıkları, ağız derlemeleri, Dede Korkut, köy edebiyatı.
    3. Telif sınırı: birebir alıntı en çok bir cümle; gerisi yapının tarifi ("soruya cevap vermeden önce soranın akrabasını sorar").
    4. Dönem notu: bugünkü ağızlar 13. yüzyılı birebir yansıtmaz. Örnekler cümle yapısı için kullanılır, kelime için değil; yasak kelime listesi geçerlidir.
    5. Kayıtları yalnız insan girer ve kaynağı doğrulanır. Model bu deftere örnek yazmaz.
    6. İnceleme aracında yapaylık uyarısının yanında "örnek gör" bağlantısı bulunur; uyarının türüne uyan kayıtlar açılır.
  - Uç durumlar: Kaynak alanı boş kayıt 1 hatadır ve “örnek gör” listesine girmez. Bir cümleden uzun birebir alıntı 1 hatadır. Kaynağı insan doğrulamamış satır deftere konmaz. Kadrodaki adı olmayan köylü kaydı deftere girmez.
  - Kabul: USLUP_REHBERI §2'deki 12 yapı türünün her birinde en az 3 kayıt vardır ve her kaydın kaynak alanı doludur (`tests/tools/test_ornek_defteri.py`). Kaynaksız kayıt 1 hata verir. İki cümlelik birebir alıntı 1 hata verir. Ek şart: ikinci örnek defteri açılmaz. Ek şart: defterdeki köylü adı kadroda yoksa kayıt 1 hata verir.
  - Bağımlılık: YAZ-01, YAZ-02. Boyut: M (içerik).
  - Dosya: yeni `docs/dunya_kitabi/ornek_defteri/*.md`.
  - Asset: asset gerekmedi.

- [ ] **DYL-73:** Eylem düğmesi tema durumunu kullanır
  - Ne: Normal, üstünde, basılı, kapalı. Yerel renk 0.
  - Kabul: Renk 0. Test: ARY-02.
  - Bağımlılık: ARY-02 Boyut: S.
  - Dosya: `chr_diyalog_paneli.gd`
  - Asset: asset gerekmedi.

- [ ] **DYL-74:** Kapalı eylem sebebi bir kelimedir
  - Ne: Kapanan sorgu eylemi kadrajdan silinmez; düğmenin altında bir kelimelik sebep görünür ve bu kelime çeviri anahtarıdır. Altı eylem düğmesi sığmazsa liste kayar. Yedinci eylem türü eklenmez. Oyuncu düğmede madde kimliği görmez.
  - Kurallar:
    1. Kapalı düğme görünür kalır. Sebep bir kelimedir ve `data/metin/metinler.csv` anahtarıdır.
    2. Eylem düğmesi sayısı 6'yı geçmez. Altı düğmede kaydırma vardır.
    3. Düğme metni oyuncu dilindedir. Madde kimliği ve dosya adı ekranda durmaz.
  - Uç durumlar: Sebep anahtarı yoksa düğme görünür kalır, sebep satırı boş basılmaz ve doğrulayıcı 1 hata verir. Yedinci tür dosyada varsa panel açılmaz.
  - Kabul: Üç yanlıştan sonra Göster düğmesi görünür kalır ve sebep bir kelimedir (`tests/unit/soz/eylem_kadraji_test.gd`). Altı düğmede kaydırma 1'dir. Ekran metninde `DYL-` öneki 0'dır. Yedinci eylem türü dosyada 0'dır.
  - Bağımlılık: DYL-01, YAZ-02. Boyut: S.
  - Dosya: `chr_diyalog_paneli.gd`
  - Asset: asset gerekmedi.

- [ ] **DYL-76:** Eylem klavye ile seçilir
  - Ne: GIR-15 kabul ve ret. Diğer eylemler ok tuşu. Yeni oyun kolu şartı bu maddede yoktur.
  - Kabul: Odak halkası düğme sayısı. Test: klavye.
  - Bağımlılık: GIR-06 Boyut: S.
  - Dosya: `chr_diyalog_paneli.gd`
  - Asset: asset gerekmedi.

- [ ] **DYL-77:** Eylem heybe açıkken donar
  - Ne: Eylem heybe açıkken donar. Heybe kapanınca aynı düğme.
  - Kabul: Eylem heybe açıkken donar. Hak aynı. Test: heybe.
  - Bağımlılık: DIY-05. Boyut: S.
  - Dosya: `src/arayuz/heybe_paneli.gd`
  - Asset: asset gerekmedi.

- [ ] **DYL-78:** Eylem boş günde yoktur
  - Ne: Eylem boş günde yoktur. Kuyruk 0 iken panel 0.
  - Kabul: Eylem boş günde yoktur. Panel 0. Test: KAP-16.
  - Bağımlılık: KAP-16. Boyut: S.
  - Dosya: `chr_diyalog_paneli.gd`
  - Asset: asset gerekmedi.

### 25.9 Kayıt ve ölçüm

- [ ] **DYL-15:** Sitede düzenleme — JS dosyası açmadan yazmak.
  - Ne: Yazar, İnceleme ve Ağaç sekmelerinde satır metnini yerinde değiştirir; koşul ve etki için form vardır, ham JSON açılmaz. Ağaçta düğüm eklenir, bağlantı sürüklenir, hedefi olmayan bağ kaydolmaz. Kaydetmek tarayıcıdan sahne dosyası indirir; `sid` yer değişse de durur.
  - Kurallar:
    1. Satırların ve seçeneklerin metni İnceleme ve Ağaç sekmelerinde yerinde düzenlenir. Koşul ve etki için form vardır; ham JSON düzenlenmez.
    2. Ağaç sekmesinde düğüm eklenir ve silinir, bağlantı sürüklenerek kurulur. Hedefi olmayan bağlantı kaydedilemez.
    3. Her değişiklikten sonra doğrulama ve yapaylık denetimi canlı çalışır.
    4. Kalıcı satır kimliği (`sid`): yeni satıra bir kez verilir, yer değiştirse de değişmez. İnceleme işaretleri ve DYL-13 geçmişi buna bağlanır. Mevcut sahnelere bir kez toplu olarak eklenir.
    5. Geri al ve yinele.
    6. Kaydetmek: tarayıcıdan sahne dosyası indirilir. Biçim DIY-01a şemasıdır, Godot aynı dosyayı okur. Dosyaya değişiklik günlüğü (kim, ne zaman, kaç satır) eklenir. Site `data/soz` altına yazmaz.
    7. Sitede yapılan değişiklik inceleme işaretlerini silmez; değişen satırlar DYL-13 kuralıyla "yeniden incele" olur.
  - Uç durumlar: İndirilen dosya DIY-01a şemasından geçmezse kayıt tamamlanmaz ve DYL-16 altın klasörüne yazılmaz. Geri al `sid` silmez. Hedefi olmayan bağlantı kaydedilemez.
  - Kabul: Yusuf sahnesinde eklenen düğüm bağlanır, düzeltilen satır indirilip yeniden yüklenince doğrulamadan geçer (`tests/tools/test_soz_duzenleyici.py`). Hedefi olmayan bağlantı kayda 0 satır yazar. Geri al `sid` değerini silmez. Şemaya uymayan indirme altın klasöre 0 dosya yazar. Ek şart: site kaydı `data/soz` altına yazmaz; HAT.md onayı olmadan kopya 0'dır.
  - Bağımlılık: DIY-01a, YAZ-10, DYL-13. Boyut: L (prototip aracı).
  - Dosya: `Roadmap-2/soz_agaci/duzenleyici.js` (yeni dosya); şemaya `sid` alanı.
  - Asset: asset gerekmedi.


- [ ] **DYL-81:** Eylem kaydı optional alandır
  - Ne: Eylem kaydı optional alandır. Eski kayıtta eylem listesi yoksa boş.
  - Kabul: Açılış çökmez. Test: KAY.
  - Bağımlılık: KAY-04. Boyut: S.
  - Dosya: `src/soz/soz_motoru.gd`
  - Asset: asset gerekmedi.

- [ ] **DYL-82:** Yükleme eylemi tekrarlamaz
  - Ne: Yükleme eylemi tekrarlamaz. Tutulan söz ikinci kez ödül yazmaz.
  - Kabul: Yükleme eylemi tekrarlamaz. Delta 0. Test: KAY.
  - Bağımlılık: SYS-02. Boyut: S.
  - Dosya: `src/soz/soz_motoru.gd`
  - Asset: asset gerekmedi.

- [ ] **DYL-85:** Eylem ölçümü DEN satırıdır
  - Ne: Hangi eylemin kaç kez kullanıldığı. Formül değişmez.
  - Kabul: Satır 1. Test: rapor.
  - Bağımlılık: DEN-05 Boyut: S.
  - Dosya: `src/sistemler/denge_olcumu.gd`
  - Asset: asset gerekmedi.


### 25.10 Sınır ve kapanış

- [ ] **DYL-16:** Ortak test dosyaları — prototip ve oyun aynı sonucu verir.
  - Ne: Prototipte "kayıt al" düğmesi seçimleri ve kayıtlı zar sonucunu beklenen satır kimlikleriyle `tests/soz/altin/` altına yazar. Godot aynı dosyayı `SozMotoru` ile oynatır; JS motoru da aynı kaydı oynatır. Ayrışan adım fark raporunda görünür. Bu kayıtta canlı zar çağrısı yoktur.
  - Kurallar:
    1. Prototipten "altın oynanış" kaydı alınır: bağlam, seçim dizisi, zar sonuçları (kayıtlı değer) → beklenen satır kimlikleri dizisi ve son durum (tansiyon, güven, sabır, bayraklar, beyanlar, söylenenler, karar).
    2. Kayıtlar `tests/soz/altin/*.json` altında durur. GDScript birim testi her kaydı `SozMotoru` ile oynatır ve birebir karşılaştırır. JS motoru da aynı kayıtları oynatır.
    3. Sahne başına en az: her son için bir oynanış; kesme, kesilir, söylenen, varyant seçimi, güvenle ve korkuyla sır açılması, kaçış. Prototipte "kayıt al" düğmesi bulunur.
    4. İki motor ayrışırsa hakem şema belgesidir (DIY-01a). Fark raporu hangi adımda ayrıldığını gösterir.
    5. Sanity tam paketine girer (`tools/sanity_check.py` tek satır).
  - Uç durumlar: Şemadan geçmeyen indirilen sahne altın oynanışa girmez ve Godot o dosyayı okumaz. Altın oynanış kayıtlı zarı kullanır; canlı zar çağrısı 0’dır. Eksik son için altın dosyası yoksa 15/15 kabulü verilmez.
  - Kabul: Yusuf için en az 15 altın oynanış iki motorda da 15/15 biter (`tests/unit/soz/altin_oynanis_test.gd`). Şemaya uymayan indirilen dosya 1 hata verir ve altın klasöre girmez. Bilerek bozulan bir etki, fark raporunda ayrıldığı adımı gösterir. Altın oynanışta canlı zar çağrısı 0'dır. Ek şart: `--check` farkı 0 değilse altın klasörüne kopya yazılmaz. Ek şart: aynı tohum ve aynı eylem dizisi iki ayrı koşuda aynı dal kimliğini seçer.
  - Bağımlılık: DIY-01a, DIY-02, KOP-09. Boyut: M.
  - Dosya: yeni `tests/soz/altin/`, `tests/unit/soz/altin_oynanis_test.gd`; prototipte kayıt düğmesi.
  - Asset: asset gerekmedi.

- [ ] **DYL-89:** Çekirdek sinyal büyümez
  - Ne: Kapı sinyalleri yerinde. Yeni `eylem_bitti` sinyali yok.
  - Kabul: Sinyal ek 0. Test: sözleşme.
  - Bağımlılık: TEK-12 Boyut: S.
  - Dosya: `src/arayuz/kapi_ekrani.gd`
  - Asset: asset gerekmedi.


- [ ] **DYL-95:** Çalışma anında model yoktur
  - Ne: Çalışma anında model yoktur. HTTP 0.
  - Kabul: Çalışma anında model yoktur. Tarama 0. Test: KLT-23.
  - Bağımlılık: KLT-23. Boyut: S.
  - Dosya: `src/soz/`
  - Asset: asset gerekmedi.

