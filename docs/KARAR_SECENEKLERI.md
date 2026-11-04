# Kapı Muhafızı — Açık Hikâye Kararları İçin Hazır Seçenekler

**Hazırlayan:** Antigravity  
**Tarih:** 4 Kasım 2026  
**Dal:** `feature/diyalog-yeniden-yazim`  
**Amaç:** Ahmet'in telefondan rahatça okuyup tek dokunuşla seçebileceği, oyun kodunu bozmadan ileride aktifleştirilmeye hazır 3 kritik hikâye yol ayrımı.

---

## Karar 1: Banu Hatun'un Dağdaki 50 Atlısı

### Durum Özeti
Ziyaretçi 28 (Banu Hatun), sırtında kurt postu ve kalkanıyla tek başına kapıya gelmiş bir Türkmen alp hatunudur. Nalbant Karaca Usta ile eski bir kan borcu davası vardır ve dağ sırtlarında emrinde bekleyen 50 atlı çerisi bulunmaktadır. Banu Hatun köye kabul edildiğinde bu 50 atlının akıbeti ne olacaktır?

---

### Seçenek 1.1: Müttefik Süvari Muhafızları (İttifak ve Savunma)

- **Tanım:** Muhafız ve Çınar Meclisi, Banu Hatun'la anlaşarak 50 atlıyı köy sınırlarını koruyan uç süvarisi olarak istihdam eder. Süvariler vadi girişindeki korulukta ordugâh kurar.
- **Diyalog Satırları:**
  - *Muhafız:* "Atlıların kılıcı kınında duracaksa, bu köyün ekmeği de suyu da onlara helaldir Banu Hatun. Sınır boyunda Tekfur'un devriyesini savuşturur, ambarı korursunuz."
  - *Banu Hatun:* "Sözümüz taşa kazınmıştır Muhafız. 50 pusat bu gece köyün etrafına çelikten bir halka çeker. Lakin çerinin karnı doyacak; ambardan hakkımızı isteriz."
  - *Karaca Usta:* "Babamın kan borcunu bu nöbetle ödeyeceksen, atlarınızın nalını, kılıçlarınızın eğrisini ben döverim Banu."
- **Gereken Bayraklar:**
  - `banu_ittifak_kabul`: true
  - `suvari_50_orudgah_kuruldu`: true
  - `ambar_suvari_payi_aktif`: true
  - `koy_savunma_bonusu`: 50
- **Eş Yorumu:**
  - *Oda Düşüncesi:* "Eli pusat tutan 50 yiğit duvara yaslanmak gibidir efendi... Lakin 50 can 50 boğaz demektir. Kış bastırdığında ambar daralırsa o süvariler ekmeği kılıçla istemesin?"
- **Köy ve Ekonomi Sonuçları:**
  - **Savunma Gücü:** +50 (Tekfur akınları ve harami baskınları 0 kayıpla püskürtülür)
  - **Asayiş Riski:** -3
  - **Ambar Tüketimi:** Günlük -3 Erzak, -2 Arpa (düzenli iaşe kesintisi)
  - **Moral:** +1 (Köyde askeri güvence duygusu)
- **Oyuncuya Etkisi:**
  - Oyuncu geceleri askeri yönden rahatlar; yaklaşan büyük çapulcu dalgalarında köy surları hasar görmez. Ancak kış ekonomisi sertleşir, ambar yönetimi zorlaşır.
- **Antigravity'nin Önerisi:**
  - **(ÖNERİLEN)** Stratejik derinliği artıran, kış mevsiminde açlık ile güvenlik arasındaki zorlu ikilemi hissettiren en dengeli seçenektir.

---

### Seçenek 1.2: Yalnız Savaşçı ve Atlıların Men Edilmesi (İhtiyat ve Mesafe)

- **Tanım:** Banu Hatun tek başına köye kabul edilir ancak 50 atlının vadiye ve köy arazisine girmesi kesin olarak yasaklanır. Banu Hatun köyde rehin/misafir kalır.
- **Diyalog Satırları:**
  - *Muhafız:* "Sen içeri girersin Banu Hatun; ocak başında yerin vardır. Lakin arkandaki 50 pusat bu vadiye giremez. Burası uç kalesidir, sahipsiz ordu barındırmaz."
  - *Banu Hatun:* "Bize güvenmezsin demek... Atlılarım dağda aç kalırsa obaya döner ya da dağın kurdu olur Muhafız. Yarın Tekfur kapına dayandığında dağın ardına bakıp 'nerede bu atlar' demeyesin!"
  - *Karaca Usta:* "Doğrusunu ettin Muhafız. 50 başıboş süvariye köy teslim edilmez. Banu tektir, sözünün eridir; ama arkasındakilere kefil olamazdım."
- **Gereken Bayraklar:**
  - `banu_yalniz_kabul`: true
  - `suvari_vadiye_sokulmadi`: true
  - `suvari_dagda_kacak`: true
  - `banu_koyde_rehine`: true
- **Eş Yorumu:**
  - *Oda Düşüncesi:* "Aklınla bin yaşa efendi. 50 silahlı yabancıyı kapıdan içeri sokmak kendi ayağımıza pranga vurmaktı. Banu diş bilese de hakikat budur."
- **Köy ve Ekonomi Sonuçları:**
  - **Savunma Gücü:** Değişmez (+0)
  - **Asayiş Riski:** +1 (Dağdaki başsız süvariler kervan yolunu tehdit eder)
  - **Ambar Tüketimi:** Normal (fazladan erzak harcanmaz)
  - **Adalet:** +2 (Köy halkının güvenliği yabancı kılıçlara emanet edilmedi)
- **Oyuncuya Etkisi:**
  - Ekonomi rahat kalır, ambar tükenmez. Ancak ilerleyen gecelerde dağdaki atlıların kervan basma olayları tetiklenebilir ve savunma desteği alınamaz.

---

## Karar 2: Molla Şükrü vs Hasan Çelebi Meclis Yüzleşmesi

### Durum Özeti
Ziyaretçi 27 (Molla Şükrü), Sivas divanından kovulmuş, heybesinde sahte Selçuklu vakıfnamesi ve çalıntı mühür taşıyan kurnaz bir kâtiptir. İçeri alındığında köyün kadim kâtibi Hasan Çelebi ile tapu, arazi ve vakıf gelirleri üzerinde karşı karşıya gelir.

---

### Seçenek 2.1: Çınar Meclisi'nde Aleni Mahkeme (Hak ve Adalet)

- **Tanım:** Muhafız, Molla Şükrü'yü Çınar Meclisi'nin ve köy ahalisinin önüne çıkarır. Hasan Çelebi ile açık bir yüzleşme kurulur; sahte mühür ve tahrif edilmiş berat halkın gözü önünde kanıtlanır.
- **Diyalog Satırları:**
  - *Hasan Çelebi:* "Şu berattaki tuğraya bakın cemaat! Sultan Alaeddin mührü der, lakin mürekkebi daha geçen hafta sürülmüş bezir yağı kokar! Bu adam divan kâtibi değil, tahrifçi bir kalpazandır!"
  - *Molla Şükrü:* "İftiradır Muhafız! Bu köhne köyün imamı divan nizamından ne anlar? O kütükleri ben tutmazsam yarın Tekfur haracı iki katına çıkarır!"
  - *Muhafız:* "Hüküm verilmiştir Molla Şükrü. Sahte mühürle hak gasp edenin bu çınar altında yeri yoktur. Beratın yakılacak, kendin de demirhanede Karaca Usta'nın körüğünde ter dökeceksin!"
- **Gereken Bayraklar:**
  - `meclis_sukru_mahkeme_edildi`: true
  - `sukru_sahte_muhur_kanitlandi`: true
  - `sukru_cezali_demirhane`: true
  - `hasan_celebi_itibar_zirve`: true
- **Eş Yorumu:**
  - *Oda Düşüncesi:* "Güneş balçıkla sıvanmaz derlerdi, doğruymuş. Hasan Çelebi'nin hakkını köyün önünde teslim ettin ya, köylünün adalete olan imanı yenilendi."
- **Köy ve Ekonomi Sonuçları:**
  - **Adalet:** +3
  - **Moral:** +2
  - **Asayiş Riski:** -2
  - **Akçe:** +0 (sahte vakıf parasına el sürülmez)
  - **Demirhane Üretimi:** +1 Günlük Alet (Şükrü körük çeker)
- **Oyuncuya Etkisi:**
  - Adalet ve moral tavan yapar. Köyde dedikodu ve huzursuzluk biter. Oyuncu ahlaki zafer kazanır.
- **Antigravity'nin Önerisi:**
  - **(ÖNERİLEN)** Hikâyenin adalet ve meclis temasına en uygun, oyuncuya kadı/muhafız rolünü tam hissettiren tatmin edici seçenektir.

---

### Seçenek 2.2: Perde Arkası Kâtip İttifakı (Pragmatik İdare ve Rüşvet)

- **Tanım:** Muhafız, Şükrü'nün sahtekârlığını bildiğini gizlice yüzüne vurur; ancak onu cezalandırmak yerine sahte deftercilik yeteneğini köyün vergi kaçırması ve divan teftişini yanıltması için kullanır.
- **Diyalog Satırları:**
  - *Muhafız:* "Mührün sahte olduğunu ikimiz de biliriz Molla. Lakin Divan'ın kâtibi geldiğinde ambarı boş, köylüyü fakir gösterecek bir kalem lazımdır. Bizim için yazarsan kellen yerinde kalır."
  - *Molla Şükrü:* "Hele şöyle gel Muhafız... Akıllı adamsın vesselam. Beyin tahsildarı geldiğinde öyle bir kütük sunarım ki, köye borçlu çıkarlar! Akçeler köyde kalır."
  - *Hasan Çelebi:* "Kurdun defterini çakala tutturursunuz Muhafız... Bu köyün bereketi hileyle değil helalle dururdu. Bu günah senin boynunadır."
- **Gereken Bayraklar:**
  - `sukru_gizli_ittifak`: true
  - `vergi_kacakciligi_aktif`: true
  - `hasan_celebi_kirgin_ve_kuskun`: true
  - `divan_teftis_tehlikesi`: true
- **Eş Yorumu:**
  - *Oda Düşüncesi:* "Akçe gelir diyorsun efendi... Lakin haramın girdiği hanede huzur kalmaz. Hasan Çelebi yüzünü çevirdi, yarın bir gün Divan müfettişi gelirse ne cevap vereceksin?"
- **Köy ve Ekonomi Sonuçları:**
  - **Akçe Geliri:** Günlük +15 Akçe (vergi kaçırma geliri)
  - **Adalet:** -3
  - **Moral:** -1
  - **Asayiş Riski:** +2 (Divan teftişi riski)
  - **Hasan Çelebi Etkileşimi:** Kilitlenir (sohbetlerde soğuk ve mesafeli olur)
- **Oyuncuya Etkisi:**
  - Köyün hazinesi hızla dolar; bina ve sur yükseltmeleri kolaylaşır. Ancak ileride Divan müfettişi baskını gibi riskli olayların kapısı aralanır.

---

## Karar 3: Vebalı Sabi ve Anasının Akıbeti

### Durum Özeti
Ziyaretçi 24 (Vebalı Ana ve Sabi), Akpınar köyünden kara hummadan kaçıp kapıya gelmiştir. Muhafız vicdanına yenilmeyip onları doğrudan köy meydanına salmamış, kireç ocağı kuyusunda sıkı karantinaya almıştır. Köyün tabibi Miraen ilaç yapmaktadır. Sabinin kaderi ne olacaktır?

---

### Seçenek 3.1: Kireç Ocağında Şifa ve Sabinin Kurtuluşu (Umut ve Bedel)

- **Tanım:** Miraen dağdan topladığı şifalı otlar, sirke ve kükürtle özel bir panzehir hazırlar. Günler süren tecrit ve bakımın ardından sabinin humması düşer, anne ve yavrusu vebadan arınarak sağ salim ayağa kalkar.
- **Diyalog Satırları:**
  - *Miraen:* "Ateşi kırıldı Muhafız. Kükürt dumanı ve dağ kekiği göğsünü açtı. Yavru yaşayacak. Kireç kuyusu mezarları değil, yeniden doğdukları yer oldu."
  - *Vebalı Ana:* "Evladımı bana bağışladın Muhafız Bey... Ömrümce kapının eşiğinde süpürge olsam hakkını ödeyemem. Allah bu köyün ocağını söndürmesin."
  - *Muhafız:* "Şükür ki vaktinde tecrit ettik, köyü de tehlikeye atmadık canı da ziyan etmedik. Miraen, ecza masrafını sandıktan karşıla."
- **Gereken Bayraklar:**
  - `veba_kirec_karantina_basarili`: true
  - `sabi_iyilesti_kurtuldu`: true
  - `miraen_tabip_saygi_zirve`: true
  - `koyde_salgin_yok`: true
- **Eş Yorumu:**
  - *Oda Düşüncesi:* "Sabah ezanında haber geldi... Çocuğun nefesi düzelmiş. Gözümden yaş geldi efendi. Kapıda o vebalı anayı kirece alırken tereddüt etmiştin ya; meğer can kurtaracakmışsın."
- **Köy ve Ekonomi Sonuçları:**
  - **Moral:** +3 (Köyde büyük sevinç ve mucize hissi)
  - **Adalet:** +2
  - **Akçe:** -10 (Miraen'in ecza ve şifalı ot masrafı)
  - **Asayiş Riski:** 0 (Köyde salgın kesinlikle çıkmadı)
  - **Nüfus:** +2 Sağlıklı Köylü (Ana bahçede çalışmaya başlar)
- **Oyuncuya Etkisi:**
  - Oyuncuya derin bir duygusal tatmin sağlar; doğru karantinanın ve hekim desteğinin ödülünü alır.
- **Antigravity'nin Önerisi:**
  - **(ÖNERİLEN)** İlk zorlu krizin umutla taçlanması, oyuncunun Miraen ve sağlık sistemine güven duymasını sağlar.

---

### Seçenek 3.2: Dondurucu Ayazda Dramatik Kayıp (Karanlık Gerçekçilik ve Ağıt)

- **Tanım:** Miraen'in tüm çabalarına ve kireç ocağındaki ateşe rağmen, kış gecesinin dondurucu ayazında sabinin zayıf ciğerleri hummaya yenik düşer. Sabi sabaha karşı can verir; ana aklını yitirme raddesine gelir.
- **Diyalog Satırları:**
  - *Miraen:* "Yetişemedik... İlacı sürdüm, kireçle ovdum lakin o ayaz ciğerini dondurdu Muhafız. Sabaha karşı yavrunun nefesi kesildi. Köye veba bulaşmadı lakin can da kurtulmadı."
  - *Vebalı Ana:* "Yavrum... Kuzum... Beni niye koyup gittin? Muhafız! Taş duvarların kurusun Muhafız! Beni bu kuyuya kapattın da yavrumun canını aldın!"
  - *Muhafız:* "Köyün vebalini savuşturduk lakin bu acı sırtımızda bir dağ gibi kalacak. Sabiyi köy mezarlığının dışına, çitlembik ağacının altına kireç döküp sırlayın."
- **Gereken Bayraklar:**
  - `sabi_vefati_kis_matemi`: true
  - `vebali_ana_akil_yitirdi`: true
  - `muhafiz_agir_vicdan_yuku`: true
  - `koyde_salgin_yok`: true
- **Eş Yorumu:**
  - *Oda Düşüncesi:* "Gecenin kör ayazında ananın feryadı surları deldi geçti... Yüreğim dağlandı efendi. Sen elinden geleni yaptın, kirece almasan bütün köy kırılırdı. Lakin bu ağıt bu kış ocağımızdan çıkmaz."
- **Köy ve Ekonomi Sonuçları:**
  - **Asayiş Riski:** 0 (Salgın köye sıçramadı)
  - **Moral:** -3 (Köyde ağır matem havası)
  - **Adalet:** +1 (Muhafız'ın köyü koruma kararı takdir edilir ama acısı büyüktür)
  - **Eş Sohbeti:** 'Kış Ağıtı ve Kader' özel dertleşme dalı açılır.
- **Oyuncuya Etkisi:**
  - Oyunun tarihi sertliğini, 13. yüzyıl kış şartlarının acımasızlığını ve 'bazen her şeyi doğru yapsan bile herkesi kurtaramayacağını' hissettirir.

---

## Ahmet İçin Karşılaştırmalı Özet Tablosu

| Karar No | Karar Konusu | Seçenek 1 | Seçenek 2 | Antigravity Önerisi |
|---|---|---|---|---|
| **1** | Banu Hatun'un 50 Atlısı | **1.1 İttifak & Süvari Gücü:** +50 Savunma, -3 Erzak tüketimi | **1.2 Yalnız Kabul:** Erzak korunur, +1 Asayiş riski | **1.1 İttifak** (Kış stratejisini derinleştirir) |
| **2** | Molla Şükrü Meclis Yüzleşmesi | **2.1 Aleni Mahkeme:** +3 Adalet, +2 Moral, Demirhanede ceza | **2.2 Pragmatik İttifak:** +15 Günlük Akçe, -3 Adalet, Hasan küser | **2.1 Aleni Mahkeme** (Hak ve adaleti pekiştirir) |
| **3** | Vebalı Sabi ve Anası | **3.1 Şifa ve Kurtuluş:** +3 Moral, +2 Nüfus, -10 Akçe masraf | **3.2 Dramatik Kayıp:** -3 Moral, Eşle hüzün sohbeti, sert gerçekçilik | **3.1 Şifa** (İlk kriz için umut dengesi) |

---
*Bu seçenekler `docs/KARAR_SECENEKLERI.md` dosyasında saklıdır; Ahmet onay verdiğinde ilgili diyalog ve olay tetikleyicilerine tek satırla bağlanabilir.*
