# BÖLÜM 27 — Çınar meclisinin sesi

Oylama duruyor. KRI-07 krizde çınar altı meclisini açar, gizli oyu sayar, halkın kararını uygula veya reddet diye önüne koyar. Bu bölüm yeni meclis kurmaz. İçeri alınan kişiler konuşur. Şikâyet, gerçek bir kararın adını taşır. Oy, duran bir değere yazılır. Meclis her gece açılmaz.

Kalp puanı, romans ve seslendirme yok.

Kimlik aralığı MCL-01 … MCL-90'tır. Numaralar yeniden sıralanmaz.

**Madde biçimi:** Amaç, numaralı Kurallar, Uç durumlar, Kabul ve test, Bağımlılık, Boyut, Dosya, Asset.

---

## 27.1 Konuşan ve şikâyetin adı

- [ ] **MCL-01:** Çınarın altında konuşan, içeri alınan kişidir.
  - Ne: Krizli gecede içeri alınmış ve o gece köyde yaşayan en çok üç kişi çınarın altında konuşur. Kapı kuyruğundaki, ret yemiş veya ölü kimlik satıra yazılmaz; adlı kimse yoksa oylama adsız tek satırla açılır.
  - Kabul: Krizsiz gecede konuşmacı sayısı 0'dır. Krizli gecede konuşanların hepsi köy kaydındadır ve sayı 3'ü geçmez. Ret yemiş bir kimlik satırda 0 kez durur (`tests/unit/koy/meclis_sesi_test.gd`). Ek şart: `meclis` adlı yeni sahne açılmaz ve wav dosyası eklenmez. Ek şart: `meclis_sesi.gd` ile KRI-07 paneli dışında üçüncü bir meclis dosyası açılmaz.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: yeni `src/koy/meclis_sesi.gd`; KRI-07 paneline konuşma listesi, oy hesabına dokunulmaz.
  - Asset: asset gerekmedi. Çınar ANI-07 ateş başındadır.

- [ ] **MCL-02:** Şikâyet, bir kararın adını taşır.
  - Ne: Şikâyet cümlesi, kapıda duran kararın adını ve hedef kişinin adını taşır; ad kabul, ret, rüşvet, kışla veya aileyi bölmeden biridir. Aynı karar ikinci ağza verilmez; kayıt yoksa o ağız susar ve genel yakınma satırı üretilmez.
  - Kabul: Karar kaydı olmayan köyde konuşma satırı 0'dır; KRI-07 oyu açılabilir. Bir ret ve bir rüşvet kayıtlıysa en az bir cümle bu adlardan birini taşır ve iki ağız aynı karar kimliğini tekrarlamaz (`tests/unit/koy/meclis_sesi_test.gd`). Ek şart: Aynı tohumla iki koşu aynı şikâyet karar kimliğini seçer. Ek şart: Divanda hükme bağlanmış karar ertesi mecliste şikâyet adayı olmaz. Ek şart: Şikâyet kaydı karar kimliğini tutar; kişinin düz adı kayda gömülü ikinci bir alan olmaz.
  - Bağımlılık: MCL-01. Boyut: S.
  - Dosya: `src/koy/meclis_sesi.gd`; kapı karar kaydına okuma.
  - Asset: asset gerekmedi.

- [ ] **MCL-03:** Eş veya usta söz isterse üç ağzın dışında bir satır alır.
  - Ne: Sağ eş, üç ağzın dışında bir satır alır ve cümlede mesleğinin sözcüğü durur; eş yoksa usta, dolu yapı bilgisinin adını söyler. Eş ile usta aynı gece ikisi birden konuşmaz ve bu satır üç ağzın yerine geçmez.
  - Kabul: Eş sağken ek satır 1'dir ve meslek sözcüğü cümlededir. Eş ölü, usta varken ek satır yapı adını taşır; ikisi de yokken ek satır 0'dır. Üç ağız duruyorsa toplam satır 4'ü geçmez (`tests/unit/koy/meclis_sesi_test.gd`).
  - Bağımlılık: MCL-02. Boyut: S.
  - Dosya: `src/koy/meclis_sesi.gd`; ACL-02 ve YAP-03 kaydına okuma.
  - Asset: asset gerekmedi.

## 27.2 Oy ve açılış sıklığı

- [ ] **MCL-04:** Oy, duran bir değere yazar.
  - Ne: Uygula ve reddet, KRI-07 tablosundaki sadakat ve moral farkını yazar; bu dosyada yeni bir oy katsayısı yoktur. Reddet, şikâyetin hedef kişisine gece boyunca bir kez "mecliste adı geçti" yazar; hafıza kaydı yoksa işaret gece raporunda kalır.
  - Kabul: Uygula ile reddet farklı sonuç yazar ve KRI-07 sayılarının dışında yeni bar anahtarı 0'dır. Hedef kişide "mecliste adı geçti" en çok 1'dir (`tests/unit/koy/meclis_sesi_test.gd`). Ek şart: Aynı düğmeye iki basışta sadakat farkı bir kez yazılır. Ek şart: Meclis sesi alanı olmayan eski kayıt açılır; o gece oy adsız durur ve işaret yazılmaz.
  - Bağımlılık: MCL-03. Boyut: S.
  - Dosya: `src/koy/meclis_sesi.gd`; KRI-07 sonuç fonksiyonuna tek işaret.
  - Asset: asset gerekmedi.

- [ ] **MCL-05:** Meclis her gece açılmaz.
  - Ne: İki meclis arasında en az dört gece vardır; süre `data/koy` meclis ayarından okunur ve koda gömülü ikinci takvim yazılmaz. Heyet veya açılış ulağı olan gece meclis ertelenir, ertelenen oy silinmez.
  - Kabul: Kriz sürerken art arda iki gecede meclis 0'dır. Dört gece sonra kriz duruyorsa meclis 1'dir. Heyet gecesinde meclis 0, ertesi uygun gecede 1'dir. Kriz o gece biterse ertelenmiş meclis açılmaz. Süre dolmadan zorla açılan meclis dört gece sayacını yine işletir (`tests/unit/koy/meclis_sesi_test.gd`). Ek şart: Kapının boş günü meclisi kendiliğinden açmaz; şikâyet kaydı duruyorsa boş gün meclisi engellemez.
  - Bağımlılık: MCL-04. Boyut: S.
  - Dosya: `src/koy/meclis_sesi.gd`; KRI-07 tetikine tek süre kapısı.
  - Asset: asset gerekmedi.

- [ ] **MCL-23:** Oy duraklatta sayılmaz
  - Ne: Oy duraklatta sayılmaz. Delta 0.
  - Kabul: Oy duraklatta sayılmaz. 0. Test: menü.
  - Bağımlılık: GIR-08. Boyut: S.
  - Dosya: `src/arayuz/ana.gd`
  - Asset: asset gerekmedi.
- [ ] **MCL-26:** Oy ölçümü DEN satırıdır
  - Ne: Oy ölçümü DEN satırıdır. Formül değişmez.
  - Kabul: Oy ölçümü DEN satırıdır. Satır 1. Test: DEN.
  - Bağımlılık: DEN-05. Boyut: S.
  - Dosya: `src/sistemler/denge_olcumu.gd`
  - Asset: asset gerekmedi.

## 27.3 Karar cümlesi ve söz sırası

- [ ] **MCL-06:** Uygula ve reddet, konuşulan adı söyler.
  - Ne: Uygula ve reddet düğmelerinin altında konuşulan kararın adı ve kişisi yazar; alt satır yoksa düğme çalışır. Basılan düğme gece raporuna bu satırla bir kez düşer, gizli oy yeniden sayılmaz.
  - Kabul: Düğme sayısı 2'dir ve kimlikler KRI-07 ile aynıdır; üçüncü düğme 0'dır. Raporda karar adı 1 kez geçer (`tests/unit/koy/meclis_sesi_test.gd`).
  - Bağımlılık: MCL-05. Boyut: S.
  - Dosya: KRI-07 paneline tek alt satır; `src/koy/meclis_sesi.gd` metni verir.
  - Asset: asset gerekmedi.

- [ ] **MCL-07:** En ağır kararın sahibi önce konuşur.
  - Ne: İlk ağız, köyde duran en ağır kararın hedefidir; ağırlık akşam konuları tablosundan okunur, tablo yoksa sıra aileyi bölme, rüşvet, çocuklu ret ve ölümdür. Eşin ek satırı ağırlık sırasında yarışmaz, ilk ağızdan sonra gelir.
  - Kabul: Bölme ve rüşvet aynı köydeyse ilk ağız bölmenin hedefidir. Tablo yokken bölme, rüşvetten önce gelir. Eş satırı ilk ağız değildir (`tests/unit/koy/meclis_sesi_test.gd`).
  - Bağımlılık: MCL-06. Boyut: M.
  - Dosya: `src/koy/meclis_sesi.gd`; DYL-07 tablosuna okuma. Yazma yok.
  - Asset: asset gerekmedi.

## 27.4 Sınırlar

- [ ] **MCL-08:** Köyde olmayan kişi çınarın altında duramaz.
  - Ne: Liste her satırdan önce köy nüfusuna bakar; köyde olmayan kişinin cümlesi düşer ve sırada karar sahibi varsa o kişi geçer. O gece ölen veya divanla çıkan kişi listeyi bir satır kısaltır, meclis kapanmaz.
  - Kabul: Köyde olmayan kimlik listede 0'dır. Üç adaydan biri ölünce satır sayısı 2'dir ve meclis sürer. Sahnedeki model sayısı kalan satır sayısıyla aynıdır (`tests/unit/koy/meclis_sesi_test.gd`).
  - Bağımlılık: MCL-07. Boyut: S.
  - Dosya: `src/koy/meclis_sesi.gd`; nüfus kaydına tek süzgeç.
  - Asset: asset gerekmedi.

- [ ] **MCL-09:** Meclis savaş, bina ve son açamaz.
  - Ne: Meclis harita, sefer, yapı kademesi ve nihai son kaydını değiştirmez; yazabildiği yer KRI-07 farkı ile "mecliste adı geçti" işaretidir. Metinde sefer, düğün veya kalp sözcüğü varsa o cümle karar adına döner.
  - Kabul: Meclis gecesinden sonra HAR, YAP ve SYS-20 kayıtlarının özü değişmez. Yasak sözcük taramasında hata 0'dır. Fark ve işaret dışında yazılan alan 0'dır. Evlilik, hediye ve kalp alanı bu gecede yazılmaz (`tests/unit/koy/meclis_sesi_test.gd`). Ek şart: Reddet divan hükmü, infaz veya sürgün kaydı açmaz. Ek şart: Meclis nöbet yuvasına kimse yazmaz. Ek şart: Meclis kapı kabulü, reti, rüşveti, kışlayı veya aile bölmeyi yazmaz.
  - Bağımlılık: MCL-08. Boyut: S.
  - Dosya: `src/koy/meclis_sesi.gd` yazma listesi; `tools` tarafında meclis metni taraması tek liste.
  - Asset: asset gerekmedi.

## 27.6 Şikâyetin kaynağı

- [ ] **MCL-55:** Hüküm sabah satırıdır
  - Ne: SAB-01. Meclis ikinci sabah cümlesi yazmaz.
  - Kabul: Cümle 1 kaynak. Test: SAB-01.
  - Bağımlılık: SAB-01 Boyut: S.
  - Dosya: `src/koy/sabah_defteri.gd`
  - Asset: asset gerekmedi.

## 27.7 Perde 2 konusu

- [ ] **MCL-59:** Perde 2 hafta başı meclis açabilir
  - Ne: OMR istisnası. MCL-05 aralığı o gecede delinir, başka gece delinmez.
  - Kabul: Hafta başı 1, ara gece 0. Test: OMR.
  - Bağımlılık: MCL-05 Boyut: S.
  - Dosya: `src/koy/takvim.gd`
  - Asset: asset gerekmedi.
- [ ] **MCL-60:** Dış hat konusu o gecenin konusudur
  - Ne: Köy şikâyeti varsa dış hat önceliklidir, ikisi birden 0.
  - Kabul: Konu 1. Test: birim.
  - Bağımlılık: OMR-24 Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.
- [ ] **MCL-61:** Hat yüzü mecliste konuşmaz
  - Ne: Hat yüzü mecliste konuşmaz. Yüz kapıdadır. Mecliste adı anılır.
  - Kabul: Yüz modeli 0 mecliste. Test: tarama.
  - Bağımlılık: OMR-24. Boyut: S.
  - Dosya: `src/koy/gorsel/`
  - Asset: asset gerekmedi.
- [ ] **MCL-62:** Konu bitince kamuoyu düşmez
  - Ne: Konu bitince kamuoyu düşmez. Düşüş divan veya süredir. SOY-16.
  - Kabul: Meclis tek başına kamuoyu 0 yazmaz. Test: SOY-16.
  - Bağımlılık: SOY-16. Boyut: S.
  - Dosya: `src/sistemler/soylenti_agi.gd`
  - Asset: asset gerekmedi.

## 27.8 Panel

- [ ] **MCL-69:** Uzun şikâyet kayar
  - Ne: Uzun şikâyet kayar. Kesilen glif 0.
  - Kabul: Uzun şikâyet kayar. 0. Test: GRV-15.
  - Bağımlılık: GRV-15. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/cinar_meclis_paneli.gd`
  - Asset: asset gerekmedi.
- [ ] **MCL-72:** Hız panelde donar
  - Ne: Hız panelde donar. Scale aynı.
  - Kabul: Hız panelde donar. Fark 0. Test: TEK-24.
  - Bağımlılık: TEK-24. Boyut: S.
  - Dosya: `src/arayuz/koy_ekrani.gd`
  - Asset: asset gerekmedi.

## 27.9 Aynı gece

- [ ] **MCL-76:** Nöbet meclisi kesmez
  - Ne: Nöbet meclisi kesmez. NBT devri aynı gece durur.
  - Kabul: Nöbet meclisi kesmez. Devir 1. Test: NBT-03.
  - Bağımlılık: NBT-03. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.
- [ ] **MCL-81:** Meclis üretimi durdurmaz
  - Ne: Meclis üretimi durdurmaz. İş o gece biter. ISG.
  - Kabul: Kesinti 0. Test: ISG-02.
  - Bağımlılık: ISG-02. Boyut: S.
  - Dosya: `src/koy/uretim.gd`
  - Asset: asset gerekmedi.
- [ ] **MCL-82:** Meclis maaşı değiştirmez
  - Ne: Meclis maaşı değiştirmez. NBT maaş.
  - Kabul: Meclis maaşı değiştirmez. Delta 0. Test: NBT.
  - Bağımlılık: NBT-01. Boyut: S.
  - Dosya: `data/ayarlar/koy.tres`
  - Asset: asset gerekmedi.
