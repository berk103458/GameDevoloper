# Kapı Muhafızı — Oyun Testi Kontrol Listesi
*(Ahmet İçin Adım Adım Deneme Kılavuzu)*

Bu belge, bu gece oyuna eklenen ve derinleştirilen tüm anlatı, diyalog, eş fısıltıları, köy sohbetleri ve olayları sabah oyunu açtığında en pratik şekilde adım adım test edebilmen için hazırlanmıştır.

---

## 0. Hızlı Başlangıç ve Araçlar

1. **Oyunu Başlatma:**
   - Normal Başlatma: `C:\Users\Ahmet\Desktop\Godot.exe --path .`
   - Geliştirici / Debug Modu (Admin HUD açık): `C:\Users\Ahmet\Desktop\Godot.exe --path . -- --debug-arac`
2. **Hızlı Gece Atlama & Test Kontrolleri:**
   - Debug modunda ekranın altında açılan konsoldan `kapi_atla` düğmesiyle nöbeti hızlıca tamamlayabilir, köy ekranına geçebilirsin.
   - `F1` veya konsol girişinden `gece 15`, `akce 50`, `moral 80` komutlarıyla barları doğrudan ayarlayabilirsin.

---

## 1. 15 Dakikalık Hızlı Rota (En Önemli 10 An)

Aşağıdaki 10 anı sırasıyla 15 dakika içinde deneyerek bu gece yapılan devasa işin çekirdeğini görebilirsin:

### An 1: Fırın Çırağı Dursun (Ziyaretçi 25) — Yeğenin Yüzüğü
- [ ] **Nasıl Ulaşılır:** Kapıya Ziyaretçi 25 (yırtık yelekli, un lekeli titreyen oğlan) geldiğinde.
- [ ] **Adımlar:**
  1. 1. Soruya tıkla: *"Kollarındaki morluklar ve sırtındaki un çuvalı neyin nesidir oğul..."*
  2. Dursun: *"Erzincan çarşısındaki fırıncı kalleş çıktı... Hamza Dayımı ararım ben!"*
  3. Açılan alt soruya (↳) tıkla: *"Hamza rençber köyümüzün emektarıdır... un çuvalından akçe aşırmadın ya?"*
  4. Dursun astarındaki üç peksimeti ve dayısının gümüş yüzüğünü söyler.
  5. 3. Kademe alt soruya (↳) tıkla: *"O gümüş yüzüğü göster bakalım; üstündeki nal damgası Hamza'nın ocağına ait midir?"*
  6. Eşinin kapı fısıltısını oku: *"Gözleri tıpkı rahmetli kaynım Hasan'a ve Hamza rençbere benzer beyim! Al içeri!"*
- [ ] **Beklenen Sonuç:** Hamza'nın gümüş nal yüzüğü teyit edilir, `harami_karabudak_izi` bayrağı açılır, "Kabul" kararıyla Dursun köy fırınına çırak verilir.
- [ ] **[ ] çalıştı**

### An 2: Turna (Ziyaretçi 30) — Aile Bağının Tamamlanması
- [ ] **Nasıl Ulaşılır:** Kapıya Ziyaretçi 30 (Hasan rençberin kızı Turna) geldiğinde.
- [ ] **Adımlar:**
  1. Açılış: Turna boynundaki muskayı gösterip *"Muhafız amca... Sen misin kurban olduğum? Babam Hasan rençber 'Git amcanın kapısına sığın' dedi..."* der.
  2. 1. Soruya tıkla: *"Babam Hasan rençber dediğinde yüreğim yerinden oynadı kızım... peşinde kimler var?"*
  3. Turna sancak voyvodasının atlılarının peşinde olduğunu söyler.
  4. Alt soruya (↳) tıkla: *"Eşim içeridedir; kapıda bir yabancı kadını... kabul etmek kadınları tedirgin eder."*
  5. 3. Kademe soruya tıkla: *"Açılışta geride kimse kalmadı dedin; fırın çırağı kardeşin Dursun bu kapıdan geçti, kışlada odun taşır!"*
  6. Turna'nın gözyaşları içinde *"Dursun mu dedin amca?! Yetim kuzum yaşıyor mu?!"* cevabını oku.
- [ ] **Beklenen Sonuç:** `turna_oz_yegen_kabul` bayrağı set edilir, eş kapıda *"Öz kanımızdır, voyvodaya karşı dururuz"* der, kabul edilince iki yetim köyde kavuşur.
- [ ] **[ ] çalıştı**

### An 3: Derviş Baba (Ziyaretçi 21) — Moğol Fermanı
- [ ] **Nasıl Ulaşılır:** Kapıya Ziyaretçi 21 (keçe abalı, ardıç asalı Derviş) geldiğinde.
- [ ] **Adımlar:**
  1. 1. Soruya tıkla: *"Yaylanın dumanını aştım dedin derviş baba; obaları Moğol mu bastı?"*
  2. Alt soruya (↳) tıkla: *"Derviş dediğin tekkesinde oturur. Cübbenin altından beylik mührü veya ferman çıkarsa ne deriz?"*
  3. Derviş yolda bulduğu Moğol ulak atından aldığı ipek kâğıdı koynundan çıkarır.
  4. Takip sorusuna (↳) tıkla: *"O ipek kâğıtta ne yazar derviş baba..."*
  5. Derviş: *"Noyan damgasıdır oğul... Üç güne kalmaz ovadaki öncü kolu vadiye iner!"*
- [ ] **Beklenen Sonuç:** `dervis_mogol_fermani` bayrağı açılır, eş fısıltıda mescidin sundurmasına hasır verilmesini öğütler.
- [ ] **[ ] çalıştı**

### An 4: Banu Hatun (Ziyaretçi 28) — Dağların Kurdu ve 50 Atlı
- [ ] **Nasıl Ulaşılır:** Kapıya Ziyaretçi 28 (kurt postlu, kalkanlı Türkmen kızı) geldiğinde.
- [ ] **Adımlar:**
  1. 1. Soruya tıkla: *"Dağların kurdu Banu Hatun derler sana, bu kapıya barış için mi geldin, kan dökmek için mi?"*
  2. Banu Hatun: Nalbantın hileli nalla ağabeyini tökezlettiğini söyler.
  3. Alt soruya (↳) tıkla: *"Arkamda elli atlı var dersin; hani neredeler? Pusu mu kurarsın?!"*
  4. Banu Hatun: *"Ağabeyimin kanı yerde kalmasın, o elli atlı bu köyün sınırına kalkan olsun!"*
- [ ] **Beklenen Sonuç:** `banu_hatun_atli_guvencesi` bayrağı açılır, kılıcını kışlaya teslim ederek "Kışla" veya "Kabul" ile içeri alınır.
- [ ] **[ ] çalıştı**

### An 5: Vebalı Ana ve Sabi (Ziyaretçi 24) — Kireç Ocağı İmtihanı
- [ ] **Nasıl Ulaşılır:** Kapıya Ziyaretçi 24 (yüzü tülbentli, kucağında kundağı olan kadın) geldiğinde.
- [ ] **Adımlar:**
  1. 1. Soru: *"Kucağındaki kundağa can havliyle sarılırsın bacım amma... veba çıbanı taşır mısın?"*
  2. Kadın: *"Ben günahkâr bir anayım... Kundağımdaki Yusuf'um daha altı aylıktır! Onun teninde tek leke yoktur... Beni karda bırakın amma sabiyi kurtarın!"*
  3. Alt soruya (↳) tıkla: *"Köyün hekimi Miraen vardır... Sen girersen cümle bebeler kırılır!"*
  4. Kadın kireç ocağındaki terk edilmiş kulübeye kapatılmaya razı olur.
- [ ] **Beklenen Sonuç:** `veba_kaynagi_akpinar` bayrağı açılır, eş fısıltısı gözyaşlarıyla *"Bir anayım ben, o sabiyi kurtaralım"* der, kireç ocağı karantinası başlar.
- [ ] **[ ] çalıştı**

### An 6: Sancak Çavuşu Sungur (Ziyaretçi 23) — Rüşvet Pazarlığı
- [ ] **Nasıl Ulaşılır:** Kapıya Ziyaretçi 23 (paslı zırhlı inzibat çavuşu) geldiğinde.
- [ ] **Adımlar:**
  1. 1. Soru: *"Sancak subaşısının tuğu parlar amma armorun pas içinde... kışla firarilerini mi ararsın?"*
  2. Alt soruya (↳) tıkla: *"Kuşağındaki o ağır kese nedir? Kaçakları haraca mı bağlarsın?"*
  3. Sungur fısıldar: *"İki çuval un ve yirmi akçe ver, firarilerin adını kütükten 'karda dondu' diye sileyim!"*
- [ ] **Beklenen Sonuç:** `sungur_rusvet_teklifi` bayrağı açılır, rüşveti reddedip kışla nizamına sokabilir veya kışlaya alıp Aydoğdu ile yüzleştirebilirsin.
- [ ] **[ ] çalıştı**

### An 7: Şarlatan Hekim Lokman (Ziyaretçi 26) — Afyon Şişeleri
- [ ] **Nasıl Ulaşılır:** Kapıya Ziyaretçi 26 (eşeğinde ot sepetleri ve şişeler olan hekim) geldiğinde.
- [ ] **Adımlar:**
  1. 1. Soru: *"Konya Darüşşifası'ndanım dersin lakin heybelerin afyon kokar..."*
  2. Alt soruya (↳) tıkla: *"Akpınar'dan gelen vebalı kadın bir cerrah çırağının sahte merhem satıp kaçtığını söyledi. Sol yanağındaki o çıban izi nedir?!"*
  3. Lokman kekeleyerek *"Ne Akpınarı... o çıban değil tencere yanığı!"* diyerek yakalanır.
- [ ] **Beklenen Sonuç:** `hekim_lokman_supheli_merhem` bayrağı tetiklenir, Miraen'in denetimi şartıyla içeri alınır veya kovulur.
- [ ] **[ ] çalıştı**

### An 8: Molla Şükrü (Ziyaretçi 27) — Çalıntı Mühür
- [ ] **Nasıl Ulaşılır:** Kapıya Ziyaretçi 27 (çamurlu cübbeli kâtip) geldiğinde.
- [ ] **Adımlar:**
  1. 1. Soru: *"Sivas kadı divanından kovulduğunu duymayan kalmadı..."*
  2. Alt soruya (↳) tıkla: *"Kuşağındaki meşin keseden pirinç mühür sapı sarkar; kadı divanının mührünü çalıp kaçtığın söylenir?!"*
  3. Molla Şükrü titreyerek *"Kadı efendi kaçarken unuttu, haramiler yağmalamasın diye aldım!"* der.
- [ ] **Beklenen Sonuç:** `katip_calinti_muhur` bayrağı açılır, Hasan Çelebi ile divanda yüzleştirilmek üzere içeri alınır.
- [ ] **[ ] çalıştı**

### An 9: Muhafız Odasında Eşle Dertleşme ("Eşin Sedirde Dinleniyor")
- [ ] **Nasıl Ulaşılır:** Köy ekranında Muhafız Odası / Hane butonuna tıkla.
- [ ] **Adımlar:**
  1. "Eşin Sedirde Dinleniyor" panelini gör.
  2. "Eşinle Dertleş" butonuna bas.
  3. Parley diyalog ekranı açılır (`koylu_muhabbet_es.ds`).
  4. Seçenekler: "Dün gece kapıda verdiğimiz kararlar", "Köyün ahvali", "Bırak kapıyı köyü, sen nasılsın?", "Kış ayazı yaklaştı".
  5. Kapı kararları dalına gir; merhamet, sertlik veya rüşvet aldığını itiraf et.
  6. Eşinin derin ahlaki ve duygusal tepkilerini izle.
- [ ] **Beklenen Sonuç:** Parley arayüzünde 120+ düğümlü ağaç akıcı şekilde çalışır, moral ve ilişki bayrakları güncellenir.
- [ ] **[ ] çalıştı**

### An 10: Köy Olayı: Samanlık Yangını ve Harami Elçisi
- [ ] **Nasıl Ulaşılır:** Gece bitiminde rastlantısal veya tetikleyici bayraklarla çıkan olay ekranında.
- [ ] **Adımlar:**
  1. Olay ekranında Samanlık Yangını (`samanlik_yangini`) veya Harami Elçisi (`harami_elcisi`) başlığını gör.
  2. 3 seçenekten birini seç (ör. Harami Elçisi'ne karşı "Beyliğin onurunu koru, elçiyi kov").
  3. Sonuç metnini ve barlardaki (Asayiş +10, Akçe -5 vb.) değişimi izle.
- [ ] **Beklenen Sonuç:** Olayın 3 sonucu da hatasız çalışır, köy defterine işlenir.
- [ ] **[ ] çalıştı**

---

## 2. 30 Kapı Ziyaretçisi Test Tablosu

Aşağıdaki tablo 30 ziyaretçinin her birinde test edilecek kritik yol, soru zinciri ve eş düşüncelerini içerir:

| # | Ziyaretçi ID & Kimlik | Kritik Soru & Alt Soru (↳) | Açılan Bayrak / İpucu | Eş Fısıltısı (Kritik & Karar) | Karar Seçenekleri | Test Durumu |
| :--- | :--- | :--- | :--- | :--- | :--- | :---: |
| **01** | `diyalog_01` (Rençber Hamza) | Tohumluk buğday çuvalı ↳ Beyin ambarı yangını | `hamza_tohumluk_bugday` | "Tohumluk buğday kışa candır, içeri alalım." | Ret / Kabul / Harç | [ ] çalıştı |
| **02** | `diyalog_02` (Çuhacı Selim) | Kayseri yangını ↳ Kumaş denkleri ve borç | `kayseri_yangin_kumas` | "Kayserili çuhacı dürüsttür amma kumaşı az." | Ret / Kabul / Harç | [ ] çalıştı |
| **03** | `diyalog_03` (Sipahi Haydar) | Yaralı at ↳ Sivas meydan savaşı bozgunu | `haydar_yarali_at` | "Kışlaya alalım, yaralı sipahi pusat tutar." | Ret / Kabul / Kışla | [ ] çalıştı |
| **04** | `diyalog_04` (Çerçi İdris) | Şam makasları ↳ Gizli bileği çarkı | `cerci_makas_bilegi` | "Demirci Karaca Usta'ya çırak olur mu bilmem." | Ret / Kabul / Harç | [ ] çalıştı |
| **05** | `diyalog_05` (Çoban Veli) | Kurt saldırısı ↳ Kalan 2 cılız koyun | `veli_kurt_suru` | "Ağıla iki koyun girse kardır, kabul et." | Ret / Kabul / Harç | [ ] çalıştı |
| **06** | `diyalog_06` (Gazi Derviş) | İki kapılı han ↳ Tahta kılıç ve menkıbe | `gazi_dervis_menkibe` | "Derviş duası köyümüzün üstünde olsun." | Ret / Kabul / Harç | [ ] çalıştı |
| **07** | `diyalog_07` (Değirmenci Latif) | Yanan değirmen ↳ Tekfur'un akıncıları | `degirmen_tekfur_baskini` | "Değirmen taşı döndüren adam boş kalmaz." | Ret / Kabul / Harç | [ ] çalıştı |
| **08** | `diyalog_08` (Otacı Dudu Hatun) | Şifalı ot heybesi ↳ Boğaz humması şurubu | `otaci_dudu_otlar` | "Miraen kızımıza yardımcı olur, içeri al." | Ret / Kabul / Harç | [ ] çalıştı |
| **09** | `diyalog_09` (Nöbetçi Çavuşu) | Doğu boğazı ↳ Firari kumandanın sandığı | `nobetci_firari_sandik` | "Kışlada düzeni sağlar amma sert adamdır." | Ret / Kabul / Kışla | [ ] çalıştı |
| **10** | `diyalog_10` (Taşçı Ustası) | Ahşap çit çürümesi ↳ Taş temel andezit blok | `tasci_sur_temeli` | "Thessra ile birlikte surları tahkim eder." | Ret / Kabul / Harç | [ ] çalıştı |
| **11** | `diyalog_11` (Süvari Neferi) | Sınır harcı ↳ Atın eyerindeki ok sadakları | `suvari_ok_sadak` | "Atı kuvvetli, kışla nöbetine çok yarar." | Ret / Kabul / Kışla | [ ] çalıştı |
| **12** | `diyalog_12` (Kayıp Kardeş Arayan) | Konya kervanı ↳ Yeşil kuşaklı kâtip | `kayip_kardes_iz` | "Gözleri nemli garip, kardeşini arar." | Ret / Kabul / Harç | [ ] çalıştı |
| **13** | `diyalog_13` (Tuz Arabacısı) | Kırık dingil ↳ Göl tuzu çuvalları | `tuz_kirik_dingil` | "Kış günü tuz altın değerindedir, içeri al." | Ret / Kabul / Harç | [ ] çalıştı |
| **14** | `diyalog_14` (Demirci Kalfası) | Omuzda demir çubuk ↳ Karaca Usta'ya çıraklık | `demirci_kalfa_ocak` | "Karaca Usta'nın körüğüne can katar." | Ret / Kabul / Harç | [ ] çalıştı |
| **15** | `diyalog_15` (Bacıyan Elçisi) | Ak kuşaklı bacı ↳ Dokuma tezgâhı fermanı | `baciyan_elcisi_ferman` | "Saruca Hatun'un meclisine saygın bir Hatun." | Ret / Kabul / Kışla | [ ] çalıştı |
| **16** | `diyalog_16` (Avcı Kalo) | Dağ patikaları ↳ Kurt derisi ve tuzak teli | `avci_kalo_tuzak` | "Bozkır kurdunun izini iyi sürer bu adam." | Ret / Kabul / Harç | [ ] çalıştı |
| **17** | `diyalog_17` (Göğsü Ağrıyan Ana) | Bebek ateşi ↳ Thessra'nın adaçayı merhemi | `bebek_ates_ilac` | "Bir ananın feryadına kapı kapanmaz." | Ret / Kabul / Harç | [ ] çalıştı |
| **18** | `diyalog_18` (Debbağ Kızı Rahime) | 30 sığır gönü ↳ Palamut kabuğu seyreltisi | `debbag_gon_palamut` | "Kışlık çarık dikmeye deri getirmiş, al içeri." | Ret / Kabul / Harç | [ ] çalıştı |
| **19** | `diyalog_19` (Gümüş Tokalı Yolcu) | Babasının gümüş kemeri ↳ Harami haracı | `gumus_toka_yolcu` | "Gözleri tekin değil amma zanaatten anlar." | Ret / Kabul / Harç | [ ] çalıştı |
| **20** | `diyalog_20` (Seyyar Nalbant) | Topuğa batan çivi ↳ Hilal nal takımı | `nalbant_hilal_nal` | "Sorhan'ın atlarına nal çakar, işe yarar." | Ret / Kabul / Harç | [ ] çalıştı |
| **21** | `diyalog_21` (Derviş Baba) | Ardıç asa ↳ Moğol ulak fermanı | `dervis_mogol_fermani` | "Derviş duası köyün bereketidir." | Ret / Kabul / Harç | [ ] çalıştı |
| **22** | `diyalog_22` (Tebrizli Tüccar) | Şam ipeği ve safran ↳ Boyundaki gümüş payza | `tuccar_sahte_payza` | "Gözleri tilki gibi oynar, dikkat et." | Ret / Kabul / Rüşvet | [ ] çalıştı |
| **23** | `diyalog_23` (Çavuş Sungur) | Sancak mühürlü parşömen ↳ Kaçak affı rüşveti | `sungur_rusvet_teklifi` | "İnzibat kılıklı haramiye benzer, tetikte ol." | Ret / Kabul / Kışla | [ ] çalıştı |
| **24** | `diyalog_24` (Vebalı Ana) | Kucaktaki kundak ↳ Akpınar kuyu kırgını | `veba_kaynagi_akpinar` | "Sabiyi Ayşe Bacı'ya verip anayı tecrit et." | Ret / Kabul / Harç | [ ] çalıştı |
| **25** | `diyalog_25` (Fırın Çırağı Dursun)| Hamur teknesi izi ↳ Hamza Dayı nal yüzüğü | `harami_karabudak_izi` | "Rahmetli kardeşinin yetimi Dursun bu!" | Ret / Kabul / Harç | [ ] çalıştı |
| **26** | `diyalog_26` (Hekim Lokman) | Afyon şişeleri ↳ Yanakta Akpınar çıban izi | `hekim_lokman_supheli_merhem` | "Miraen kavanozlarını koklamadan dokunmasın." | Ret / Kabul / Harç | [ ] çalıştı |
| **27** | `diyalog_27` (Molla Şükrü) | Meşin kitap sandığı ↳ Kadı divanı çalıntı mühür | `katip_calinti_muhur` | "Fitneci kâtip Hasan Çelebi ile kavga eder." | Ret / Kabul / Harç | [ ] çalıştı |
| **28** | `diyalog_28` (Banu Hatun) | Kurt postu ve kalkan ↳ Dağdaki 50 atlı kalkanı | `banu_hatun_atli_guvencesi` | "Mert bir savaşçı, kışlada oku haramiye geçit vermez."| Ret / Kabul / Kışla | [ ] çalıştı |
| **29** | `diyalog_29` (Kafile Habercisi)| Karda donan araba ↳ İki çuval un ve kızak | `kafile_habercisi_kurtarma_cagrisi` | "Donan sabilerin ahı surlarımızı çürütür, kurtar."| Ret / Kabul / Harç | [ ] çalıştı |
| **30** | `diyalog_30` (Turna) | Kök boyalı muska ↳ Hasan Dayı vasiyeti | `turna_oz_yegen_kabul` | "Kendi öz kanımızdır, Turna'yı bağrımıza bas!"| Ret / Kabul / Harç | [ ] çalıştı |

---

## 3. Köy İçi Etkileşimler ve Parley Sohbetleri Testi

### A. İsimli Köylülerle Tıklayınca Konuşma (11 Karakter)
Köy yönetim ekranında gezinirken ilgili köylüye tıklandığında `KoyDiyalogPaneli` açılır ve her birinin kendine özgü Parley diyaloğu başlar:

1. **Aydoğdu (Gazi Okçu):**
   - [ ] Tıkla -> Açılış: *"Dur orada muhafız! Gözüm ovada, kulağım kirişte..."*
   - [ ] Seçenekler: "Köy surları ve nöbet yerleri", "Kösedağ eteklerinde atlı tozu", "Dün alınan neferler".
   - [ ] [ ] çalıştı

2. **Ayşe Bacı (Bacıyan Reisi):**
   - [ ] Tıkla -> Açılış: *"Hoş geldin evlat. Bacıyan-ı Rum tezgâhında mekik dokuruz..."*
   - [ ] Seçenekler: "Tezgâhlar ve aşevi", "Ambar daralırsa kadınlar ne yapar?", "Dün gelen yetimler".
   - [ ] [ ] çalıştı

3. **Karaca Usta (Ahi Demircisi):**
   - [ ] Tıkla -> Açılış: *"Körük harlıdır, demir tavındadır. Ahi ocağında boş lafa yer yoktur..."*
   - [ ] Seçenekler: "Sabanlar ve kalkanlar", "Harami fısıltısı", "Kapıdaki tüccarlar ve rüşvet dedikodusu".
   - [ ] [ ] çalıştı

4. **Hasan Çelebi (Kâtip):**
   - [ ] Tıkla -> Açılış: *"Hürmetler muhafız ağa. Kamış kalemim divan defterini yazar..."*
   - [ ] Seçenekler: "Köy nüfusu ve tahrir", "Sancaktan vergi baskısı gelirse", "Hileli dirhemi kırılan kantarcı".
   - [ ] [ ] çalıştı

5. **Saruca Hatun (Ambar Emini):**
   - [ ] Tıkla -> Açılış: *"Gel evlat, otur soluklan. Köyün ocağında çorba kaynar..."*
   - [ ] Seçenekler: "Zahire hesabı kışı çıkarır mı?", "Erzak azalırsa gizli sandık", "Fırıncı ve tuzcu".
   - [ ] [ ] çalıştı

6. **Miraen (Şifacı):**
   - [ ] Tıkla -> Açılış: *"Bostanın gölgesinde kekik kurutur, dağın bu yüzünden gelen dertleri dinlerim..."*
   - [ ] Seçenekler: "Şifahane ve merhemler", "Kuyu suyu ve salgın tecriti", "Kapıdan alınan yaralılar".
   - [ ] [ ] çalıştı

7. **Thessra (Taş Ustası):**
   - [ ] Tıkla -> Açılış: *"Taş ses verir, çekiç tartar. Sur bedenindeki çatlakları ölçerim..."*
   - [ ] Seçenekler: "Surlar ve su arkları", "Mancınık ve koçbaşı dayanımı", "Harç karan yeni ırgat".
   - [ ] [ ] çalıştı

8. **Sorhan (Seyis / At Yetiştiricisi):**
   - [ ] Tıkla -> Açılış: *"Bozkırın rüzgârı atların yelesindedir. Ahırda tayları tımarlarım..."*
   - [ ] Seçenekler: "Binek ve yük hayvanları", "Kıpçak süvarisi taktiği", "Gelen seyyar nalbant".
   - [ ] [ ] çalıştı

9. **Nogay (İz Sürücü):**
   - [ ] Tıkla -> Açılış: *"Sessiz ol muhafız... Rüzgâr dağdan estiğinde toprağın kokusu değişir..."*
   - [ ] Seçenekler: "Dağ yollarında ve çeperde izler", "Kızıl Karga çetesi keşifçileri", "Gözcü neferler ve çobanlar".
   - [ ] [ ] çalıştı

10. **Yusuf (Çoban Çocuğu):**
    - [ ] Tıkla -> Açılış: *"Ben Yusuf. Karabaş'ın ipini tutarım, kapıya bakarım hep..."*
    - [ ] Seçenekler: "Elindeki ip ve köpek", "Kış ayazında karnın aç mıdır?", "Dün gece kapıda verilen kararlar".
    - [ ] [ ] çalıştı

11. **Genel Köylü (Rastlantısal Köylüler):**
    - [ ] Tıkla -> Açılış: *"Selamün aleyküm muhafız ağa. Bir emrin, bir sualin var mıdır?"*
    - [ ] 4 ana seçenek: "Hal hatır", "İş güç", "Köyde havadis", "Bir maruzatın var mı?".
    - [ ] [ ] çalıştı

---

### B. 6 Köy İçi Sohbet Sekansı (Ortam Olayları)
Oyuncu köyde gezinirken veya ilgili mekana yaklaştığında otomatik tetiklenen iki köylü arası sohbetler:

1. **`sekans_degirmen_kitlik` (Değirmen Önü):**
   - Karakterler: Latif & İdris.
   - Konu: Değirmen taşının dönüp hazneye buğday dökülmemesi, dolu vuran başaklar.
   - Muhafız Müdahalesi: "Sakin olun, un idareli pay edilecek" / "İsraf eden hesabını verir!"
   - [ ] [ ] çalıştı

2. **`sekans_demirhane_pusat` (Demirhane):**
   - Karakterler: Karaca Usta & Thessra.
   - Konu: Kapı kanadı demir takviyeleri, çift sıra dövme perçinli kuşak.
   - Muhafız Müdahalesi: "Kömürü ben sağlarım, en sağlam çelikle donatın" / "İsraf yok, zayıf mazgallara takviye yapın."
   - [ ] [ ] çalıştı

3. **`sekans_kuyu_hastalik` (Köy Meydanı Kuyusu):**
   - Karakterler: Miraen & Saruca Hatun.
   - Konu: Kuyu suyunda kükürt ve pas kokusu, çocuklara kaynatmadan içirmeme uyarısı.
   - Muhafız Müdahalesi: "Sönmemiş kireç döküp iki gün dinlendirin" / "Suyu kaynatıp dağıtın."
   - [ ] [ ] çalıştı

4. **`sekans_meydan_atesi` (Meydan Ateşi):**
   - Karakterler: Aydoğdu & Ayşe Bacı.
   - Konu: Boğazdaki nal sesleri, atlıların yaklaşması, gece ayazı.
   - Muhafız Müdahalesi: "Korkmayın kulelerde nöbetçiler uyanık" / "Herkes çadırına çekilsin."
   - [ ] [ ] çalıştı

5. **`sekans_nobet_harami` (Ahır / Çit Kenarı):**
   - Karakterler: Nogay & Sorhan.
   - Konu: Kızıl Karga eşkıyasının 4 at izi, tayların huzursuz kişnemesi.
   - Muhafız Müdahalesi: "Kışla süvarilerini ve kemankeşleri alarma geçirin" / "İzleri takip edin amma ürkütmeyin."
   - [ ] [ ] çalıştı

6. **`sekans_pazar_fiskos` (Köy Pazarı):**
   - Karakterler: Hasan Çelebi & Yusuf.
   - Konu: Köy pazarında yabancıların dolaşması, Karabaş'ın havlamaması, dedikodular.
   - Muhafız Müdahalesi: "Adalet mülkün temelidir" / "Dedikoduya kulak asmayın."
   - [ ] [ ] çalıştı

---

## 4. 8 Yeni Köy Olayı Testi

Gece sonu raporunun ardından ekrana gelen olay kartlarında yeni 8 olayın test adımları:

1. **Harman Kavgası (`kavga_harman`):**
   - Seçenek 1: "Arpayı iki aileye eşit böl" -> Adalet +5, Moral +5.
   - Seçenek 2: "Kavgacıların payını ambara al" -> Akçe +10, Asayiş -5.
   - Seçenek 3: "Karaca Usta'yı hakem ata" -> Ahi nüfuzu artar.
   - [ ] [ ] çalıştı

2. **Ambar Hırsızlığı (`ambarda_hirsizlik`):**
   - Seçenek 1: "Nöbetçileri cezalandır, kilidi yenile" -> Asayiş +10.
   - Seçenek 2: "Fakir hanelere un dağıt" -> Moral +15, Ambar -10.
   - Seçenek 3: "Hırsızın peşine Nogay'ı sal" -> Suçlu yakalanır.
   - [ ] [ ] çalıştı

3. **Salgın Fısıltısı (`salgin_fisiltisi`):**
   - Seçenek 1: "Kuyuya kireç dök, şifahaneyi karantinaya al" -> Sağlık korunur.
   - Seçenek 2: "Fısıltıyı yayanı köyden sür" -> Asayiş sertleşir.
   - Seçenek 3: "Miraen'e sirke ve kekik dağıttır" -> Moral +10.
   - [ ] [ ] çalıştı

4. **Köy Düğünü (`koy_dugunu`):**
   - Seçenek 1: "Köy kasasından bir koyun bağışla" -> Moral +20, Akçe -5.
   - Seçenek 2: "Düğünü erken bitir, nöbeti aksatma" -> Asayiş +5.
   - Seçenek 3: "Bacıyan'ın dokuduğu kilimi hediye et" -> Dayanışma artar.
   - [ ] [ ] çalıştı

5. **Firari Cenazesi (`firari_cenazesi`):**
   - Seçenek 1: "Mescit arkasına insanca defnet" -> Adalet +10, Derviş duası.
   - Seçenek 2: "Cesedi vadide kurda bırak" -> Köyde soğuk ürperti (-10 Moral).
   - Seçenek 3: "Sancak subaşısına haber uçur" -> Sancak ilişkisi +5.
   - [ ] [ ] çalıştı

6. **Samanlık Yangını (`samanlik_yangini`):**
   - Seçenek 1: "Kışla neferlerini kovalara koştur" -> Yangın söndürülür, Kışla yorgunluğu.
   - Seçenek 2: "Ambarı ve ahşap suru korumaya al" -> Samanlık yanar, sur sağlam kalır.
   - Seçenek 3: "Kundaklama şüphesiyle yabancıları topla" -> Tansiyon +15.
   - [ ] [ ] çalıştı

7. **Gece Donu (`gece_donu`):**
   - Seçenek 1: "Tandır közlerini ambar altına taşı" -> Zahire korunur.
   - Seçenek 2: "Hayvanları kışla ahırına sıkıştır" -> Sürü donmaktan kurtulur.
   - Seçenek 3: "Nöbetçilere ekstra yün aba dağıt" -> Nöbet verimi artar.
   - [ ] [ ] çalıştı

8. **Harami Elçisi (`harami_elcisi`):**
   - Seçenek 1: "Elçiyi derhal kov, surlara okçu dik" -> Asayiş +15, Harami intikam riski.
   - Seçenek 2: "İki çuval darı verip oyala" -> Akçe -10, Moral -5.
   - Seçenek 3: "Elçiyi tutuklayıp kuleye kapat" -> Kriz düğümü başlar.
   - [ ] [ ] çalıştı

---

## 5. Söylenti Ağı ve Akşam Konuları Testi

1. **Söylenti Yayılımı (`SoylentiAgi`):**
   - Kapıda rüşvet alındığında veya haksız karar verildiğinde bir söylenti kaydı açılır.
   - 3 gece boyunca köyde fısıldaşılır; köyün %40'ı duyduğunda HUD şeridinde `Kamuoyu: rüşvet fısıltısı` kırmızı yanar.
   - Çınar Meclisi gecesinde bu konu meclis şikayeti olarak muhafızın önüne gelir.
   - [ ] [ ] çalıştı

2. **Akşam Sohbeti (Hane / Gece Raporu Öncesi):**
   - Gün içinde ağır bir karar verilmişse (ör. `aileyi_bolmek`, `rusvet_almak`, `firari_askeri_almak`), gece raporu ekranından önce oda sahnesi açılır.
   - Eşin 3 meslek varyantına (dokumacı, fırıncı, ebe) göre replikleri ve oyuncunun 3 yanıtı (Savun, Kabul Et, Sus) moral ve terazi etkisini uygular.
   - [ ] [ ] çalıştı

---

## 6. Zafer ve Oyun Sonu Testi

- **Uç Bağımsızlık Zaferi (30. Gün):**
  - Tekfur'un 3. kuşatması surlarda kırıldığında oyun zafer ekranı açılır.
  - Metin: `"Tekfur'un üçüncü baskısı da surun dibinde dağıldı. Köy artık kimseye haraç vermiyor; kapı senin, sözün senin."`
  - [ ] [ ] çalıştı
- **Kışa Tutunma Sonu:**
  - Tekfur'un akıncıları gelmediğinde köyün kışı çıkardığı son ekranı.
  - Metin: `"Tekfur'un adamları bir sabah gelmedi. Köy kışı çıkardı. Kapı hâlâ açılıp kapanıyor."`
  - [ ] [ ] çalıştı

---

*Bu kontrol listesindeki her madde, oyun kodundaki ve veri tabanındaki gerçek kimliklerle doğrulanmıştır; hiçbir adım veya anahtar uydurulmamıştır.*
