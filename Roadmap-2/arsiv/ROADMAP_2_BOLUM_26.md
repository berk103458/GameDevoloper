# BÖLÜM 26 — Nöbet devri

Oyuncu köydeyken kapı boş kalmaz. Nöbeti tutan bir kişi vardır. Zemin ANI-02 devriye rotası ve HAR-15 güvenlik hesabıdır. Yeni ordu, yeni harita ve yeni savaş yok. Gece vardiyasının yorgunluğu UZM-14, uykusu YSM-03, fırtınanın kuyruk ve görüşü MEV-15 ile MEV-09, kıtlıkta nöbetçinin ambara gitmesi KRI-14'tür. Bu bölüm o kayıtları okur.

Kimlik numaraları yeniden sıralanmaz. `src/koy/kapi_nobeti.gd` henüz yoktur.

**Madde biçimi:** Ne, numaralı Kurallar, Uç durumlar, Kabul ve test, Bağımlılık, Boyut, Dosya, Asset.

---

## 26.1 Nöbetçinin kimliği ve kapıya etkisi

- [ ] **NBT-01:** Kapıda tek yuva.
  - Ne: Direğin üstündeki ad, yuvaya yazılmış köylünün kayıtlı adıdır. Kapıda ikinci yuva yoktur; ANI-02 rotası kapıya uğradığında orada bu kişi durur.
  - Kurallar:
    1. Kapıda tek nöbet yuvası vardır. Yuvaya köyde yaşayan bir kişinin kimliği yazılır.
    2. ANI-02 rotası (kapı, kışla, sur) durur. Bu madde rotayı yeniden çizmez. Rota kapıya uğradığında orada yuvadaki kişi durur.
    3. ISG-02 "gece bekçisine eşlik" işi yuvanın kendisi değildir. Eşlik eden ikinci kişidir. Yuva boşken eşlik eden yuvaya kendiliğinden geçmez.
    4. Kapı ACL-01 gereği kapalıysa yuva boş durabilir. Kapı açıldıktan sonra (ACL-04 ertesi sabah) yuva boşsa NBT-08 işler.
  - Uç durumlar: köyde asker yoksa yuvaya yazılacak kimse çiftçi veya esnaf olabilir. Bu atama NBT-02 uyarısını açar, atamayı reddetmez. Ölen kişinin kimliği yuvada kalamaz, sabah düşer.
  - Kabul: Kapı açık ve oyuncu köydeyken direkte görünen ad, yuva kimliğinin kayıtlı adıyla aynıdır; ikinci yuva 0'dır (`tests/unit/koy/kapi_nobeti_test.gd`). Eşlik işi yuvayı tek başına doldurmaz. Ek şart: Oyun açılışında yuva boştur; oyuncu kendiliğinden nöbetçi yazılmaz ve liste boşsa zorla köylü konmaz. Ek şart: Nöbetçi köy kartından seçilir, ayrı nöbet sahnesi açılmaz. Ek şart: Yuvadaki kişi o gece kendi işinde üretim yazmaz; sabah ölmediyse eski işine döner. Ek şart: Yuva, devir, görülenler, fırtına, uyku ve boş direk tek kayıt sözlüğündedir. Ek şart: Nöbet, `muhafiz_maas` dışında ikinci bir maaş açmaz. Ek şart: Yeni sahne, ses dosyası ve kalp alanı eklenmez.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: yeni `src/koy/kapi_nobeti.gd`; ANI-02 kapı noktasına tek okuma.
  - Asset: asset gerekmedi. Meşale ANI-01 soketindedir.

- [ ] **NBT-02:** Yanlış nöbetçi bir geleni kaçırır.
  - Ne: Eş ve çocuk yuvaya konamaz. Asker olmayan yetişkin veya yorgun kişi durursa o gecenin bir geleni sabah raporunda görülmedi diye durur; gelen KAP-16 listesinden kalkmaz.
  - Kurallar:
    1. Yanlış kişi şunlardır: çocuk (UZM-08 çalışmaz), eş (ACL-02 kapı nöbetine yazılamaz), yorgunluk eşiğini aşmış kişi (YSM-01), mesleği asker olmayan yetişkin. Asker olmayan yetişkin yazılabilir ama yanlış sayılır.
    2. Eş yuvaya konamaz. Düğme kapalıdır.
    3. Çocuk yuvaya konamaz.
    4. Yanlış yetişkin veya yorgun kişi durursa HAR-15 güvenlik katkısı o kişinin beceri ve sağlık teriminden gelir. Yeni güvenlik sayısı açılmaz. Ayrıca o gece kapıya gelen bir kişinin varışı sabah raporuna "görülmedi" diye düşer. Gelişin kendisi KAP-16'dadır, silinmez.
    5. Doğru kişi (asker, yorgun değil) "görülmedi" üretmez.
  - Uç durumlar: yorgun asker yanlış sayılır, mesleği asker diye affedilmez. Eş ve çocuk için kayıt denemesi 0 yazar. Görülmeyen kişi köye gizlice eklenmez. Yalnız rapor satırı eksik kalır.
  - Kabul: Eş ve çocuk ataması 0 kez yazılır. Yorgun olmayan askerde görülmedi satırı 0'dır. Asker olmayan yetişkinde o gecenin bir geleni raporda görülmedi olur ve HAR-15 aynı fonksiyondan okunur (`tests/unit/koy/kapi_nobeti_test.gd`). Ek şart: Usta yuvaya yazılamaz; kimin listeleneceği meslek kaydından okunur. Ek şart: Görülmeyen geliş ertesi gece yeni bir kuyruk kaydı olarak doğmaz; KAP-16 satırı durur.
  - Bağımlılık: NBT-01. Boyut: S.
  - Dosya: `src/koy/kapi_nobeti.gd`; HAR-15 hesabına yeni fonksiyon yok, duran fonksiyon okunur.
  - Asset: asset gerekmedi.

## 26.2 Devir zamanı, fırtına ve uyku

- [ ] **NBT-03:** Akşam teslim, sabah aynı yuva.
  - Ne: Gün kapanırken yuvadaki kişi tutan olur; sabah yuva kendiliğinden boşalmaz. Devir kaydı bırakan ve alan adını taşır, ayrı bir sahne açmaz.
  - Kurallar:
    1. Akşam, gün kapanırken yuvadaki kişi "tutan" olur. Sabah, gece hesabından sonra yuva boşaltılmaz. Oyuncu yeni bir ad yazarsa devir olur.
    2. Devir kaydı iki ad taşır: bırakan, alan. Aynı kişi iki gece durursa bırakan ve alan aynı addır. Bu da bir devirdir.
    3. Gün döngüsü ve gece sonu duran hesaptır. İkinci bir saat sistemi açılmaz.
    4. Devir anında en çok bir cümle vardır: bırakanın adı, alanın adı. Cümle gece raporunun malzemesidir (NBT-07). Ayrı bir sahne açılmaz.
  - Uç durumlar: akşam yuva boşsa devir kaydı "boş"tur, uydurma bir nöbetçi adı yazılmaz. Gece yarısı ölen tutan, sabah kaydında tutan olarak kalır ve yuva boşalır. Oyuncu köyde değil kapı sahnesindeyse devir yine yazılır, kapı sorgusu bölünmez.
  - Kabul: İki farklı kişide bırakan ve alan adları kayda uyar. Aynı kişi iki gece durunca iki ad da o kişidir. Boş yuvada uydurma ad 0'dır (`tests/unit/koy/kapi_nobeti_test.gd`). Ek şart: Aynı gece ikinci seçim veya ikinci devir öncekini bırakır ve yorgunluk kaydını bir kez yazar. Ek şart: Devir, kapı kuyruğunun sırasını silmez. Ek şart: Oyun hızı üç katındayken akşam devri bir kez yazılır. Ek şart: Eski kayıtta devir alanı yoksa nöbet yok sayılır ve kayıt açılır.
  - Bağımlılık: NBT-01. Boyut: S.
  - Dosya: `src/koy/kapi_nobeti.gd` kayıt alanı; gece sonuna tek satır.
  - Asset: asset gerekmedi.

- [ ] **NBT-04:** Fırtına bir geleni kaçırır.
  - Ne: Fırtına ve tipi MEV-09 ile MEV-15'ten okunur; kuyruk hesabı yeniden yazılmaz. Fırtına gecesinde doğru nöbetçi de bir geleni kaçırabilir ve sabah satırı tipi diye işaretler.
  - Kurallar:
    1. Fırtına ve tipi MEV-09 ile MEV-15'tir. Kuyruk daralması ve bulanık ipucu yeniden yazılmaz.
    2. Bu madde yalnız şunu ekler: fırtına gecesinde nöbetçi "görülmedi" sayısını NBT-02'deki yanlış kişi kuralından bağımsız bir artırır. Doğru kişi de fırtınada bir geleni kaçırabilir.
    3. Kaçırılan gelen KAP-16 listesinden silinmez. Sabah satırı "tipi, görülmedi" der.
    4. Fırtına yoksa bu artış 0'dır.
  - Uç durumlar: fırtına ve yanlış kişi aynı gece üst üste binirse iki ayrı "görülmedi" satırı yazılabilir, gelen iki kez silinmez. Kapı kapalıysa (ACL-01) fırtına satırı da yoktur, gelen yoktur. MEV-15 zaten kuyruğu sıfıra indirdiyse kaçırılacak gelen yoktur, satır "tipi, kapı boş geçti" olur.
  - Kabul: Fırtınasız doğru nöbetçide tipi satırı 0'dır. Fırtınalı gecede tipi ile görülmedi satırı en az 1'dir; kuyruk zaten boşsa satır tipi ve kapı boş geçti olur. Kuyruk uzunluğu bu maddeden sonra MEV-15 ile aynı kalır (`tests/unit/koy/kapi_nobeti_test.gd`).
  - Bağımlılık: NBT-02, NBT-03. Boyut: S.
  - Dosya: `src/koy/kapi_nobeti.gd`; MEV-09 bayrağına tek okuma.
  - Asset: asset gerekmedi.

- [ ] **NBT-05:** Uyuyan nöbetçi bir geleni kaçırır.
  - Ne: UZM-14 o gece uyku derse nöbetçi uyku halinde durur ve bir gelen uyudu diye işaretlenir. Yüzde tablosu bu maddede yoktur; kişi yatağına ışınlanmaz.
  - Kurallar:
    1. Uyuma ihtimali UZM-14 kaydıdır. Gece vardiyasında uyumama ve ertesi gün riski orada durur. Bu madde ikinci bir yüzde yazmaz.
    2. UZM-14 o gece uyku derse nöbetçi modelinde uyku hali oynar. Yeni animasyon üretilmez. Duran uyku veya çökme klibi yoksa idle eğik durur. Bu bir yer tutucudur.
    3. Uyuduğu gece NBT-02'deki gibi bir gelen "uyudu, görülmedi" diye işaretlenir. Gelen silinmez.
    4. YSM-03, nöbet tutan kişinin o gece yatakta uyumadığını zaten yazar. Bu madde onu eve ışınlamaz.
  - Uç durumlar: UZM-14 uyuma demezse eğik duruş da "uyudu" satırı da 0'dır. Çocuk ve eş zaten yuvada değildir (NBT-02). Uyuyan nöbetçi kıtlıkta ambara giderse (KRI-14) uyku hali biter, yuva NBT-08 gereği boş sayılır.
  - Kabul: UZM-14 uyku dediği gecede raporda uyudu ve görülmedi satırı 1'dir ve model uyku halindedir. Uyumadığı gecede bu satır 0'dır ve yüzde tablosu bu dosyada yoktur (`tests/unit/koy/kapi_nobeti_test.gd`).
  - Bağımlılık: NBT-04. Boyut: S.
  - Dosya: `src/koy/kapi_nobeti.gd`; UZM-14 sonucuna tek okuma.
  - Asset: asset gerekmedi. Uyku klibi yoksa idle eğik duruş yeter. Envantere yeni satır yok.

- [ ] **NBT-20:** Menü devri ilerletmez
  - Ne: Menü devri ilerletmez. Duraklat fark 0.
  - Kabul: Menü devri ilerletmez. 0. Test: menü.
  - Bağımlılık: GIR-08. Boyut: S.
  - Dosya: `src/arayuz/ana.gd`
  - Asset: asset gerekmedi.

## 26.3 Görünen ve sabah raporu

- [ ] **NBT-06:** Görülenler listesi sorgu değildir.
  - Ne: Liste, o gecenin KAP-16 gelişlerinden görülmedi işaretli olmayan kimlikleri taşır. Listede replik, ipucu ve karar yoktur; kapı sahnesindeki sorgu bu listeden açılmaz.
  - Kurallar:
    1. Görülenler listesi o gecenin KAP-16 gelişlerinden, "görülmedi" işaretli olmayan adları taşır.
    2. Liste ad, sınıf ve bir kısa haldir (yorgun, aileli, tek). Replik, ipucu ve karar yoktur.
    3. Oyuncu kapı sahnesine geçince sorgu duran kapı akışındadır. Nöbetçi listeyi oyuncuya soru olarak açmaz.
    4. CHR heybesi ve tansiyon bu listede yoktur. Heybe motoru okunmaz.
  - Uç durumlar: boş gece (KAP-16) listeyi boş bırakır, uydurma yüz yazılmaz. Aile (KAP-17) listede bir satırdır, kişi sayısı yanındadır, her çocuk ayrı sorgu olmaz. "Görülmedi" olan ad listede yoktur.
  - Kabul: Üç gelişli bir gecede görülmeyen biri çıktıktan sonra listede 2 ad durur. Listede replik anahtarı 0'dır (`tests/unit/koy/kapi_nobeti_test.gd`). Ek şart: Görülen kişi köye kabul edilmiş sayılmaz ve `kabul_sayisi` artmaz. Ek şart: Görülenler listesi beyan defterine satır yazmaz. Ek şart: Görülenler kayıtta kimlik listesidir; düz ad gömülmez.
  - Bağımlılık: NBT-05. Boyut: S.
  - Dosya: `src/koy/kapi_nobeti.gd` içinde görülenler listesi.
  - Asset: asset gerekmedi.

- [ ] **NBT-07:** Sabah raporunda iki nöbet satırı.
  - Ne: Duran gece raporuna iki satır eklenir; üçüncü nöbet satırı ve ikinci panel yoktur. İlk satır tutan adı, ikinci satır görülen ve görülmedi sayısıdır.
  - Kurallar:
    1. Satırlar duran gece raporuna eklenir. İkinci bir rapor paneli yoktur.
    2. İlk satır NBT-03 devridir: tutan ad, varsa bırakan ad.
    3. İkinci satır NBT-06 listesinin sayısı ile "görülmedi" sayısıdır. Fırtına (NBT-04) ve uyku (NBT-05) kendi sözcüğünü bu satıra ekler.
    4. Rapor kararı değiştirmez. Nöbetçi sabah rapordan sonra kendiliğinden cezalandırılmaz.
  - Uç durumlar: kapı kapalı gece (ACL-01) iki satırı da yazmaz. Boş gece "tutan ad, gelen 0" yazar. Tutan gece ölmüşse satır ölümü uydurmaz, "tutan sabaha kalmadı" der. Cenaze metni KRI-05'te kalır.
  - Kabul: Açık kapılı bir gecede nöbet satırı 2'dir. Kapalı kapıda nöbet satırı 0'dır. Fırtına sözcüğü fırtınasız raporda 0 kez geçer (`tests/unit/koy/kapi_nobeti_test.gd`). Ek şart: İki satır metin anahtarıdır; cümle betiğe düz yazılmaz.
  - Bağımlılık: NBT-06. Boyut: S.
  - Dosya: gece raporu metnine tek çağrı; `src/koy/kapi_nobeti.gd` satırları üretir.
  - Asset: asset gerekmedi.

- [ ] **NBT-30:** Sabah defteri raporu kopyalamaz
  - Ne: SAB-01 tek satır nöbeti anarsa tam listeyi tekrar basmaz.
  - Kabul: Tam liste 0 sabah defterinde. Test: SAB-01.
  - Bağımlılık: SAB-01 Boyut: S.
  - Dosya: `src/koy/sabah_defteri.gd`
  - Asset: asset gerekmedi.

## 26.4 Boş direk ve oyuncunun dönüşü

- [ ] **NBT-08:** Boş direk gecenin gelişlerini kaçırır.
  - Ne: Kapı açık, oyuncu köyde ve yuva boşsa o gecenin gelişlerinin hepsi görülmedi olur. Oyuncu kapı sahnesindeyse bu kaçırma yazılmaz; kıtlık nöbetçiyi ambara çektiyse yuva o gece boş sayılır.
  - Kurallar:
    1. Şart: kapı açık, oyuncu köy sahnesinde, yuva boş. Üçü birden yoksa bu madde susar.
    2. O gece KAP-16 gelişlerinin hepsi "görülmedi" olur. Liste (NBT-06) boş kalır.
    3. KRI-14 nöbetçiyi ambara çektiyse yuva o gece boş sayılır. Kıtlık nöbeti yeniden yazılmaz.
    4. CAS gece takibi durur. Bu madde yeni bir sabotaj türü eklemez. Boş direk, duran takibe yeni bir fiil yazmaz.
  - Uç durumlar: oyuncu kapı sahnesine geçmişse direk boş olsa da bu madde "görülmedi" basmaz, sorgu oyuncunundur. İlk gün kapı kapalıyken boş direk hata değildir. Boş direk güvenlik formülüne ikinci bir ceza eklemez. HAR-15 zaten kişi yoksa katkı almaz.
  - Kabul: Üç şart birden varken gelişlerin tamamı görülmedi olur ve görülenler listesi 0'dır. Oyuncu kapı sahnesindeyken aynı gecede bu görülmedi sayısı 0'dır (`tests/unit/koy/kapi_nobeti_test.gd`). Ek şart: Boş direk yalnız o gecenin gelişlerini kaçırır; ertesi gece ceza birikmez. Ek şart: Oyuncu o gece nöbete yazılırsa boş direk kaçırması yazılmaz. Ek şart: Boş yuvada maaş satırı yazılmaz.
  - Bağımlılık: NBT-07. Boyut: S.
  - Dosya: `src/koy/kapi_nobeti.gd`; KRI-14 sonucuna tek okuma.
  - Asset: asset gerekmedi.

- [ ] **NBT-09:** Oyuncu kapıya girince nöbetçi kenara çekilir.
  - Ne: Kapı sahnesi açılınca yuvadaki kişi direğin yanına çekilir ve sorguyu oyuncu yürütür. Köye dönüşte aynı kimlik yuvaya geri gelir; nöbetçinin kaçırdığı satır durur, bakılan gelene oyuncu gördü eklenir.
  - Kurallar:
    1. Kapı sahnesi açılınca yuvadaki kişi direğin bir adım yanına çekilir. Sorgu düğmeleri ona ait değildir.
    2. O ana kadar yazılmış görülenler listesi durur. Oyuncunun baktığı gelişler listeye "oyuncu gördü" diye eklenir, nöbetçinin kaçırdığı satır silinmez.
    3. Oyuncu köye dönünce aynı kişi yuvaya geri döner. Yeni bir atama penceresi zorlanmaz.
    4. Kapı sahnesinin kamera ve diyalog akışı yeniden kurulmaz.
  - Uç durumlar: yuva boşken oyuncu kapıya girerse kenara çekilecek model yoktur, sorgu yine açılır. Nöbetçi uyku halindeyse (NBT-05) kenara çekilince uyku hali biter. İki nöbetçi modeli direğe üst üste binmez.
  - Kabul: Kapı sahnesinde replik söyleyen yuva kimliği 0'dır. Köye dönüşte yuva kimliği aynı kalır (`tests/unit/koy/kapi_nobeti_test.gd`). Ek şart: Oyuncu kendisi nöbetçi yazılırsa kapı sorgusu açılmaz ve köy kadrajı durur. Ek şart: Oyuncu nöbet tutarken kalan soru hakkı değişmez. Ek şart: Oyuncu nöbeti `muhafiz_maas` tutarını artırmaz. Ek şart: Oyuncu nöbeti kayıtta tek bayraktır; yeni bar açılmaz. Ek şart: Kapı ekranına yeni sinyal eklenmez.
  - Bağımlılık: NBT-08. Boyut: M.
  - Dosya: `src/koy/kapi_nobeti.gd`; kapı sahnesi açılışına tek çağrı.
  - Asset: asset gerekmedi.

- [ ] **NBT-38:** Perde 2 boş direk uyarısı OMR'dedir
  - Ne: Perde 2 boş direk uyarısı OMR'dedir. Bu madde ikinci uyarı metni yazmaz.
  - Kabul: Metin 1 kaynak. Test: OMR.
  - Bağımlılık: OMR. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.
- [ ] **NBT-39:** Esc atamayı onaylamaz
  - Ne: Esc atamayı onaylamaz. Duraklat. Atama 0.
  - Kabul: Esc atamayı onaylamaz. 0. Test: GIR-08.
  - Bağımlılık: GIR-08. Boyut: S.
  - Dosya: `src/arayuz/ana.gd`
  - Asset: asset gerekmedi.
- [ ] **NBT-42:** Boş direk dedikodu tanık ister
  - Ne: Boş direk dedikodu tanık ister. Tanıksız kayıt 0.
  - Kabul: Boş direk dedikodu tanık ister. 0. Test: DIY-13.
  - Bağımlılık: DIY-13. Boyut: S.
  - Dosya: `src/sistemler/soylenti_agi.gd`
  - Asset: asset gerekmedi.

## 26.8 Oyuncunun nöbeti

- [ ] **NBT-69:** Oyuncu yorgunluğu ertesi gün
  - Ne: Oyuncu yorgunluğu ertesi gün. Ev uykusu siler. HAN ile aynı alan.
  - Kabul: Ev sonrası 0. Test: YSM-03.
  - Bağımlılık: YSM-03. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

## 26.9 Maaş ve güvenlik

- [ ] **NBT-79:** Maaş ölçümü DEN satırıdır
  - Ne: Maaş ölçümü DEN satırıdır. Formül değişmez.
  - Kabul: Maaş ölçümü DEN satırıdır. Satır 1. Test: DEN.
  - Bağımlılık: DEN-05. Boyut: S.
  - Dosya: `src/sistemler/denge_olcumu.gd`
  - Asset: asset gerekmedi.
- [ ] **NBT-81:** Maaş yetmezse nöbetçi kaçmaz
  - Ne: Kaçış KRI. Bu madde kaçış açmaz, maaş borcu satırı 1.
  - Kabul: Kaçış 0, satır 1. Test: birim.
  - Bağımlılık: NBT-01 Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

İnce satırların bir kısmı üst maddenin ek şartına alındı. Kodda bitenler kalktı. Başka dosyanın işi olan satırlar yerinde durur.
