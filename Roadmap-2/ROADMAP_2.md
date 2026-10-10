# Kapı Muhafızı — ROADMAP 2 (TASLAK, tartışma aşaması)

> Bu dosya commit edilmedi. Ahmet ile fikir alışverişi için yerel taslaktır. Eski `ROADMAP.md` aynen geçerlidir.

**DURUM LEJANDI:**
- `[x]` TAMAMLANDI (KİLİTLİ — DOKUNMAYIN)
- `[/]` GELİŞTİRİLİYOR (AKTİF İŞ PAKETİ — ÇAKIŞMA ÖNLEME KORUMASINDA)
- `[ ]` BEKLEMEDE (SIRADAKİ GÖREVLER)
- `[!]` KRİTİK BUGFIX / TEST BEKLİYOR

**Madde biçimi:** `- [ ] **ÖNEK-NN:** Başlık — amaç.` Altında: **Kabul** (ölçülebilir), **Bağımlılık**, **Boyut** (S: tek yeni dosya + 1–3 satır adaptör · M: 2–4 dosya, kayıt alanı olabilir · L: çekirdek dosyaya dokunur veya birden çok sistemi bağlar), **Dosya** (taslak hedef yol), **Asset**.

**Her maddede geçerli kurallar (tekrar yazılmaz):** yeni dosya + ince adaptör; korumalı çekirdek dosyalarda minimal ekleme; `koy_sahnesi`/statik `KoyYerlesimi` yok; korunan imzalar değişmez; `metinler.csv` satır satır; ajan asset üretmez/indirmez, gerekli asset `docs/EKSIK_ASSET_ENVANTERI.md` listesine yazılır ve yerine kutu/düz renk yer tutucu konur; `tools/sanity_check.py` tam paket 0 hata; UI zamanı ile `gece_sonu()` karışmaz.

---

## A. Araştırma özeti ve oyuna çevirisi

| Kaynak | Ne yapıyor | Bizdeki karşılığı |
|---|---|---|
| Kingdom Come: Deliverance 2 | Konu başlığından seçilen sohbet; zamanlı cevap; beceri kontrolünde zar yok, değer karşılaştırması; kontrolün türü (ikna, gözdağı, etkileme, baskı) itibara, kıyafete ve karşıdakinin statüsüne göre değişir; itibar köy/grup başına tutulur; suç tanıklar ve dedikodu ile gecikmeli yayılır | Konu merkezi (DIY-03), sıra sabrı (DIY-05), yaklaşım türleri ve muhafız itibarına göre değiştirici (ZAR-04), grup itibarı ve gecikmeli dedikodu (DIY-12, DIY-13) |
| Disco Elysium | Aktif kontrol 2d6 + beceri; beyaz kontrol tekrar denenebilir, kırmızı kontrol tek şanslık ve kalıcı; pasif kontrol zar atmadan ek satır açar | Görünür zar (ZAR-01), tekrar edilebilir / tek şanslık ayrımı (ZAR-05), muhafızın pasif sezgisi (ZAR-06) |
| Valve dinamik diyalog (Ruskin, GDC 2012) | Dünya durumu düz bir olgu listesine çevrilir; en çok koşulu tutan kural seçilir; kural yoksa susar | Bağlam sorgusu ve kural tablosu (DIY-08, DIY-09): "ambar yokken ambar demek" hatası yapısal olarak biter |
| Failbetter / Emily Short (kalite ve önem tabanlı anlatı) | Küçük "hikâyecik"ler değişken koşullarla açılır | Dünya olayları ve karakter dönüşleri hikâyecik havuzu (DNY-02) |
| Pentiment (Obsidian) | Dönem dili ağdalı değil yaşayan dil; geçmişin açtığı seçenek her zaman iyi değil; "Bu hatırlanacak" bildirimi | Muhafız geçmişi (ACL-06), üslup rehberi (YAZ-02), hatırlanma bildirimi (DIY-14) |
| Papers, Please | Beyan ile belge/eşya arasındaki çelişki oyuncunun bulduğu şeydir | Beyan defteri ve çelişki yüzleşmesi (DIY-06, DIY-07) |

**Ton örneği (yön göstermek için, nihai metin değil).** Bugünkü Sivaslı reçber kapıya varır varmaz hikâyesini anlatıyor. Hedeflenen:

- Selam: "(Çuvalı yere bırakır, bir süre soluklanır.) Selamün aleyküm, ağam… Bir tas su verir misin? Sonra ne sorarsan sor."
- "Nereden?" sorulursa: "Sivas yakasından. Köy yandı." (Susar.) Üstelenirse ikinci katman açılır.
- Tohum ancak heybede bulunursa konuşulur, ve gerekçesi bir ikilemdir (ör. tohum köyün ortak tohumudur, geride kalanlara söz vermiştir).

---

## BÖLÜM 13: Acil Oyun Hataları ve Oynanış Kilitleri (Faz 0 — ilk yapılır)

- [ ] **BUG-16:** Olay ön koşul denetimi — bina, nüfus ve yaş grubu koşulu sağlanmayan olay tetiklenmez.
  - Kabul: `OlayVerisi.kosullar` içine `bina_var`, `nufus_en_az`, `cocuk_var` gibi koşullar okunur; ambar yokken ambar geçen olay 0 kez çıkar (test `tests/unit/olay/on_kosul_test.gd`, 100 gece simülasyonu); mevcut olayların hepsi taranıp gereken koşul yazılır, liste test dosyasında.
  - Bağımlılık: yok. Boyut: M.
  - Dosya: yeni `src/sistemler/olay_on_kosulu.gd`; olay seçiminde tek satır çağrı; `data/olaylar/*.tres` koşul alanları.
  - Asset: asset gerekmedi.
- [ ] **BUG-17:** Fısıltı gazetesi yer bilgisi — pusula yalnız köyde var olan bir yeri anar.
  - Kabul: `data/fisilti_gazetesi.json` kalıpları `{yer}` alır; yer, hazır binalardan seçilir; uygun bina yoksa pusula yazılmaz. Test: binasız köyde 30 gece 0 pusula; ambarlı köyde "ambar" geçebilir.
  - Bağımlılık: BUG-16. Boyut: S.
  - Dosya: `src/kapi/fisilti_gazetesi.gd` yer seçimine adaptör; yeni yer listesi JSON'da.
  - Asset: asset gerekmedi.
- [ ] **BUG-18:** Tehdit alışma süresi — pusucu, çete, casus ve sabotaj ilk N gün gelmez.
  - Kabul: `data/ayarlar` içinde `tehdit_baslangic_gunu` (öneri 14); bu güne kadar CAS/HAR tehdit CHR'leri ve baskınları 0; Moğol sayacı (HAR-02) bundan etkilenmez. Test: 13. gün 0, 15. gün ve sonrası normal ağırlık.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: yeni `src/sistemler/tehdit_takvimi.gd`; `GuvenlikKafileDengesi` ve baskın tetikleyicilerine tek satır.
  - Asset: asset gerekmedi.
- [ ] **BUG-19:** Sıra olaylarında cinsiyet ve yaş uyumu — metin, sahnedeki gerçek modele göre yazılır.
  - Kabul: `sira_bayilma` ve diğer 4 sıra olayı seçilen bekleyenin cinsiyet/yaş verisini kullanır; metinde "kadın/adam/çocuk/yaşlı" modelle 100 denemede birebir. Metinler `{kisi}` kalıbıyla, CSV'de cinsiyete göre ayrı anahtar.
  - Bağımlılık: yok. Boyut: M.
  - Dosya: yeni `src/kapi/sira_olayi_kisisi.gd`; `data/sira_olaylari/*.tres` anahtar ekleri; `metinler.csv` satır ekleme.
  - Asset: asset gerekmedi.
- [ ] **BUG-20:** Sıra olayı seçimlerinin gerçek sonucu — yardım edilmeyen kişi ölebilir, sakatlanabilir, terk edebilir.
  - Kabul: "Sıra yürüsün" seçiminde olasılık tablosu (`data/sira_olaylari/sonuclar.json`): ölüm / sakatlık (kabulde düşük sağlık) / sıradan ayrılma / toparlanma. Sonuç gece raporunda tek satırla görünür; sıradakilerin tansiyonu ve halk barı etkilenir; ölümde KRI-05 cenaze akışı çalışır. Yardım seçeneği gerçek kaynak düşer (erzak veya akçe, olaya göre). Test: 1000 zar, oranlar tablo ±%3.
  - Bağımlılık: BUG-19. Boyut: M.
  - Dosya: yeni `src/kapi/sira_olayi_sonucu.gd`; olay sonucu uygulayan yere tek satır.
  - Asset: asset gerekmedi.
- [ ] **BUG-21:** Taş kilidi — başlangıç taş yatağı ve kurtarıcı kaynak.
  - Kabul: başlangıçta köy kenarında kazılabilir "taş yatağı" (toplam 20 taş, işçi başı gün 4) haritada ve Kaynak bilgisinde "Taş yatağı: 20 taştan N kaldı" olarak görünür. Taş = 0, taş ocağı yok ve taş ocağı kurulamıyorsa sabaha geçerken rastgele boş hücreye 10 taşlık yatak düşer ve oyuncuya tek satır bilgi verilir (oyun başına en çok 3 kez). Test: hızarhane + 2 çadır + tarla açılışından sonra 10 gün içinde taş ocağı kurulabilir.
  - Bağımlılık: yok. Boyut: M.
  - Dosya: yeni `src/koy/tas_yatagi.gd`, `src/koy/kaynak_kurtarici.gd`; `KoyYonetimi` sabah akışına tek satır; kayıtta optional alan.
  - Asset: taş yatağı modeli — yer tutucu gri `BoxMesh` öbeği; envantere `BUG21-TASYATAGI`.
- [ ] **BUG-22:** Açılış ekonomisi dengesi — başlangıç stoku ve ilk yapı maliyetleri kilitlenmez.
  - Kabul: `baslangic_kaynak` ve `binalar.json` maliyetleri tek tabloda yeniden ayarlanır; otomatik oyuncu 5 farklı açılış sırasıyla 20 gece kilitlenmeden geçer (`DUMAN_TESTI_ACILIS=1`).
  - Bağımlılık: BUG-21, ACL-01. Boyut: M.
  - Dosya: `data/ayarlar/koy.tres`, `data/koy/binalar.json`; yeni test senaryosu `tests/oto/acilis_denge_kontrol.tscn`.
  - Asset: asset gerekmedi.
- [ ] **BUG-23:** Çiftçi tarla üstünde çalışır — iş noktası tarla alanının içinde.
  - Kabul: tarla atanan köylü çalışma saatinde tarla dikdörtgeninin içinde; 20 denemede 0 dışarıda. Gezinme ağı tarla içini yürünebilir tutar.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: tarla iş noktası adaptörü (yeni `src/koy/tarla_is_noktalari.gd`); ANI-13 gezinme ağı.
  - Asset: asset gerekmedi.
- [ ] **BUG-24:** Kamera orta tuşla sürükleme — strateji oyunlarındaki gibi harita kaydırma.
  - Kabul: köy ekranında orta tuş basılıyken fare hareketi kamerayı zemin düzleminde kaydırır; sınır dışına çıkmaz; ANI-14 takip kamerası sürüklemede bırakılır. Ayar menüsünde ters çevirme seçeneği.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: yeni `src/dunya/kamera_surukleme.gd`; `koy_yonetim_sahnesi.gd` (çekirdek, minimal) tek bağlantı.
  - Asset: asset gerekmedi.
- [ ] **BUG-25:** Kapı meşaleleri ve kuyu modeli onarımı.
  - Kabul: iki kapı meşalesi doğru konum ve ölçekte, alev soketi ve ışık aynı noktada; kuyu modeli zeminde, oranı insan boyuna uygun. Yeni asset gelene kadar mevcut olanın konum/ölçek/malzeme ayarı yapılır, gerekirse yer tutucu.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: kapı ve kuyu sahne/ayar dosyaları.
  - Asset: gerçek meşale ve kuyu modeli gerekiyorsa envantere `BUG25-MESALE`, `BUG25-KUYU`.

---

## BÖLÜM 14: Açılış, Hane ve Köyün Kuruluşu (Faz 1)

- [ ] **ACL-01:** Oyun köy ekranından başlar — tek ev, muhafız ve eşi.
  - Kabul: yeni oyun köy ekranında açılır; haritada 1 hazır ev (yatak 4), muhafız ve eşi; kapı ilk gün kapalıdır ve HUD'da "Kapı kapalı" görünür. Eski kayıtlar etkilenmez (göç testi).
  - Bağımlılık: yok. Boyut: L (açılış akışı `ana.gd` çekirdek, minimal).
  - Dosya: yeni `src/sistemler/acilis_senaryosu.gd`; `ana.gd` tek yönlendirme; `data/acilis.json`.
  - Asset: muhafız ve eş modeli için envantere `ACL01-MUHAFIZ`, `ACL01-ES`; yer tutucu mevcut köylü modeli + renk farkı.
- [ ] **ACL-02:** Eş — oynanabilir ama sıradan köylü değil.
  - Kabul: eş köylü listesinde ayrı satırda; kışlaya, kervana, sürgüne, divana gönderilemez. Mesleğini oyuncu seçer, ama yalnız eşe açık listeden: dokumacı/keçeci, ebe/şifacı, fırıncı/aşçı, bostancı, sütçü/yoğurtçu, yün eğirici; okuryazar geçmişte kâtiplik. Ağır ve dönemle bağdaşmayan işler (demirci, taşçı, oduncu, asker, madenci) listede yoktur. Liste `data/hane_esi.json` içinde. Meslek değiştirilebilir, değişim 1 gün verimsizlik getirir. Ayrıca her meslekte kadınlar arasında arabuluculuk (moral +). Sağlığı ve morali ayrı izlenir; ölümü ağır yas ve epilog dalı açar. Test: listedeki meslek atanır, liste dışı meslek reddedilir.
  - Bağımlılık: ACL-01. Boyut: M.
  - Dosya: yeni `src/koy/hane_esi.gd`; köylü kartına adaptör.
  - Asset: asset gerekmedi (ACL-01 modeli).
- [ ] **ACL-03:** Akşam sohbeti — eş günün kararlarını konuşur.
  - Kabul: her gece raporundan önce en çok 1 kısa sohbet; konu, günün en ağır kararından seçilir (rüşvet, ret edilen aile, ceza, ölüm); eşin tepkisi muhafız terazisine ve eşin moraline yazılır. 10 farklı konu, her konuda en az 3 tepki. Sohbet atlanabilir.
  - Bağımlılık: ACL-02, DIY-08. Boyut: M.
  - Dosya: yeni `src/koy/aksam_sohbeti.gd`; gece raporu öncesine tek çağrı.
  - Asset: asset gerekmedi.
- [ ] **ACL-04:** Kapıyı açan olay — ilk gün akşamı: Sancak Beyi'nin ulağı ve kapıdaki ilk aile.
  - Kabul: ilk gün akşamı ulak gelir, beratı okur: muhafız uç kapısını tutacak, "bu yurt sığınana açıktır" fermanı ilan edilmiştir (sancak beyi HAR-04 ile aynı kişi). Ulak giderken ilk aile kapıya varır; ilk sorgu bu aileyle yapılır ve öğreticidir (selam, konu seçme, heybe, karar); eş kapının yanında kısa yorum yapar. Kapı bundan sonra her sabah açılır. Sahne atlanabilir değildir ama öğretici kısım atlanabilir; ulak bölümü 60 saniyeyi geçmez.
  - Bağımlılık: ACL-01. Boyut: M.
  - Dosya: yeni `src/sistemler/kapi_acilis_olayi.gd`; `data/olaylar/kapi_acilisi.tres`.
  - Asset: ara sahne arka planı envantere `ACL04-ARASAHNE`; yer tutucu düz renk + metin.
- [ ] **ACL-05:** Barınak kapasitesi kabul sınırı — yer yokken kabul edileni oyuncu bilir.
  - Kabul: kapı karar panelinde "Yatak: 3/4" görünür; yatak doluyken kabulde uyarı: "Yatacak yer yok; açıkta kalır (moral −, hastalık riski)". Kabul yine yapılabilir ama sonucu işler (açıkta kalan köylü). Test: dolu köyde kabul → açıkta kalan sayısı +1.
  - Bağımlılık: ACL-01. Boyut: S.
  - Dosya: yeni `src/kapi/barinak_uyarisi.gd`; karar paneline tek satır.
  - Asset: asset gerekmedi.
- [ ] **ACL-06:** Muhafızın geçmişi — açılışta seçilen arka plan.
  - Kabul: yeni oyunda 3–4 geçmişten biri seçilir (ör. eski levent, Ahi çırağı, medrese talebesi, çoban oğlu); her geçmiş 1 yapı bilgisi (YAP-02) ve diyalogda kendine özgü seçenekler açar; bu seçenekler her zaman avantajlı değildir (karakterin statüsüne göre tansiyon artırabilir). Kayıtta tek alan.
  - Bağımlılık: ACL-01. Boyut: M.
  - Dosya: yeni `src/sistemler/muhafiz_gecmisi.gd`, `data/muhafiz_gecmisleri.json`.
  - Asset: asset gerekmedi.

## BÖLÜM 15: Kapı Akışı ve Nüfus Gerçekçiliği (Faz 1)

- [ ] **KAP-16:** Değişken gelen sayısı ve boş günler.
  - Kabul: `gece_basina_gelen = 3` sabiti yerine günlük dağılım: köy çekiciliği (refah, güvenlik, yatak), mevsim (kışın az), dünya olayı (göç dalgası) ve rastgelelik. 28 günde en az 4 boş gün (ayarlanabilir); gözcü öngörüsü (HAR-06/13) boş günü bildirir. Test: 100 tohumlu 28 gün koşusunda ortalama ve boş gün sayısı tablo aralığında.
  - Bağımlılık: yok. Boyut: M.
  - Dosya: yeni `src/kapi/gelen_akisi.gd`, `data/gelen_akisi.json`; kuyruk kurulumuna tek satır.
  - Asset: asset gerekmedi.
- [ ] **KAP-17:** Aileler birlikte gelir.
  - Kabul: kapıya 1–5 kişilik aile gelebilir (karı-koca, çocuk, yaşlı); sorgu aile reisiyle yapılır, karar ailenin tamamına uygulanır veya "yalnız çocukları al" gibi bölme seçeneği çıkar; bölme kararı ağır vicdan ve dedikodu bedeli taşır. Test: 4 kişilik aile kabulü 4 köylü ekler, yatak kontrolü dördü için yapılır.
  - Bağımlılık: ACL-05. Boyut: L.
  - Dosya: yeni `src/kapi/aile_kafilesi.gd`; `Gelen` için aile alanı (optional); köylü üretimine adaptör.
  - Asset: çocuk ve yaşlı modelleri envantere `KAP17-COCUK`, `KAP17-YASLI`.
- [ ] **KAP-18:** Yetimler ve savaştan kaçan çocuklar.
  - Kabul: savaş olaylarından sonra yalnız çocuk/genç kafileleri gelir; kabul edilen çocuk bir haneye veya eşe emanet edilir; çocuk çalışmaz (UZM-08), belli günden sonra genç olur ve çırak alınabilir. Test: 28 günde genç olma geçişi.
  - Bağımlılık: KAP-17, DNY-01. Boyut: M.
  - Dosya: yeni `src/koy/yetim_bakimi.gd`; `Koylu.yas_grubu` geçişine adaptör.
  - Asset: KAP-17 çocuk modeli.
- [ ] **KAP-19:** Köy nüfusu kompozisyonu — çocuksuz köyde çocuk olayı yok, köy büyüdükçe olay havuzu genişler.
  - Kabul: köy olay havuzu nüfusa göre katmanlanır (≤5 hane, 6–12, 13+); her katmanın olay listesi veri dosyasında. Test: 3 kişilik köyde düğün/çocuk olayı 0.
  - Bağımlılık: BUG-16, KAP-17. Boyut: S.
  - Dosya: `data/olaylar` koşulları + BUG-16 denetimi.
  - Asset: asset gerekmedi.

## BÖLÜM 16: Söz Sistemi — Yeni Diyalog Motoru (Faz 2)

Amaç: üç ayrı diyalog yolunu (adlı karakter sohbeti `SohbetVerisi`, adsız `diyalog_01_20.json`, CHR sorgu `ChrSorgusu`) tek bir konuşma motorunda toplamak. Eski metinler taşınmaz, baştan yazılır (YAZ-06); eski yollar yeni içerik hazır olunca kapatılır (DIY-16). Motor, profesyonel oyunların kanıtlanmış mantığı incelenerek ama kendi stilimizle kurulur. Motor yazımı Claude'un işidir (zor iş).

- [ ] **DIY-01:** Söz motoru tasarım belgesi — profesyonel oyunların mantığı ve "Kapı usulü".
  - Kabul: `docs/SOZ_TASARIMI.md` iki bölümden oluşur.
    1. **İnceleme:** Kingdom Come 2 (konu seçimi, itibar ve görünüşe bağlı yaklaşım, gecikmeli dedikodu), Disco Elysium (görünür zar, tekrar/tek şans, pasif sezgi, iç ses), Valve kural tabanlı satır seçimi, Failbetter/Emily Short hikâyecik mantığı, Pentiment (dönem dili, geçmişin açtığı riskli seçenek, "hatırlanacak"), Papers, Please (beyan–belge çelişkisi), inkle/Ink (iç içe akış, tükenen ve tükenmeyen seçenek). Her biri için: ne yapıyor, neden işe yarıyor, bizde alınacak / alınmayacak kısım ve gerekçesi.
    2. **Kapı usulü — bize özgü kurallar:** selam ve ikram ritüeli (su, ekmek, ateş başına davet konuşmanın parçasıdır ve tansiyonu değiştirir); eşikte konuşma (karakter kapının dışındadır, içeri alınmadan önce ve sonra farklı konuşur); heybeyle konuşma iç içe (bulunan eşya sohbete sürüklenerek sorulur); susmak cevaptır; beyan defteri ve yüzleşme; muhafız sezgisi ve eşin akşam yorumu iç ses yerine geçer; dönem dili, kısa cümle, önce selam.
  - Her alınan mekanik bir DIY/ZAR maddesine bağlanır; bağlanmayan mekanik belgeye girmez. Ahmet onayı.
  - Bağımlılık: yok. Boyut: M.
  - Dosya: yeni `docs/SOZ_TASARIMI.md`.
  - Asset: asset gerekmedi.
- [ ] **DIY-01a:** Söz veri şeması — konuşma dosyası biçimi.
  - Kabul: `docs/SOZ_SEMASI.md` ve JSON şeması: evreler (selam, konular, derinleşme, yüzleşme, pazarlık, veda), düğüm, satır (konuşan, metin anahtarı, koşul, etki, varyant), konu, beyan, sır, ikram, zar kontrolü. 3 örnek dosya şemadan geçer.
  - Bağımlılık: DIY-01. Boyut: M.
  - Dosya: yeni `docs/SOZ_SEMASI.md`, `data/soz/_sema.json`, `data/soz/ornek_*.json`.
  - Asset: asset gerekmedi.
- [ ] **DIY-02:** Söz motoru çekirdeği — düğüm yürütücü.
  - Kabul: `SozMotoru` bir konuşma dosyasını okur, koşulları değerlendirir, satırları sırayla verir, seçim alır, etkileri uygular; `ChrSorgusu`'nun bugünkü mekanikleri (tansiyon, ipucu kilidi, bayrak, panik kilidi, `Final_Ret`, karar kısıtı) yeni motorda da vardır. Test: bu mekaniklerin her biri için örnek dosyayla birim testi; karar matrisi ve gecikmeli etkiler (KVR-07/08) aynı API'den okunur.
  - Bağımlılık: DIY-01a. Boyut: L.
  - Dosya: yeni `src/soz/soz_motoru.gd`, `src/soz/soz_dugumu.gd`.
  - Asset: asset gerekmedi.
- [ ] **DIY-03:** Selam önce, hikâye sonra — konu merkezi.
  - Kabul: karakter kapıya varınca yalnız selam satırı gelir; hikâye, oyuncu konu seçtikçe açılır. Ortak konu kümesi: Nereden, Neden yola düştün, Kiminle, Ne iş bilirsin, Yükün, Yolda ne gördün, (varsa) Haber. Konu başlıkları her karakterde aynıdır ama cevap ağaçları karaktere özeldir; "kimsin/nesin/kendini tanıt" üçlüsü kalkar. Test: 30 CHR + adlı karakterlerin hiçbirinde selamdan önce hikâye satırı yok (doğrulayıcı kuralı).
  - Bağımlılık: DIY-02. Boyut: M.
  - Dosya: yeni `src/soz/konu_merkezi.gd`; `src/arayuz/kapi/soz_paneli.gd` (yeni panel, eski panele adaptör).
  - Asset: asset gerekmedi.
- [ ] **DIY-04:** Derinleşme katmanları — aynı konuda üstelemek yeni bilgi açar.
  - Kabul: her konu en az 2 katman; üstelemek tansiyonu artırabilir; karakter bir katmanda susabilir ("gerisini sorma") ve bu susuş kendi başına bilgi taşır. Doğrulayıcı: her karakterde konu başına katman sayısı raporlanır.
  - Bağımlılık: DIY-03. Boyut: M.
  - Dosya: şema + motor; içerik YAZ bölümünde.
  - Asset: asset gerekmedi.
- [ ] **DIY-05:** Sıra sabrı — sohbetin zaman bedeli.
  - Kabul: her soru sıradakilerin sabrından düşer (KCD2 zamanlı cevap karşılığı, gerçek zaman sayacı değil); sabır bitince sıradan biri ayrılır veya sıra olayı tetiklenir; sabır HUD'da görünür. Test: 12 soruda en az 1 sabır sonucu.
  - Bağımlılık: DIY-03, BUG-20. Boyut: S.
  - Dosya: yeni `src/kapi/sira_sabri.gd`.
  - Asset: asset gerekmedi.
- [ ] **DIY-06:** Beyan defteri — karakterin söyledikleri kayda geçer.
  - Kabul: her önemli cevap bir beyan üretir ("Sivas'tan geliyorum", "yalnızım", "yükümde darı var"); beyanlar sorgu panelinde küçük defterde listelenir. Test: beyan kaydı mükerrer olmaz, ziyaret sonunda kişi hafızasına geçer (DIY-11).
  - Bağımlılık: DIY-02. Boyut: M.
  - Dosya: yeni `src/soz/beyan_defteri.gd`; `IpucuYoneticisi` yanında ikinci sistem değil, aynı ziyaret kapsamında ayrı defter.
  - Asset: asset gerekmedi.
- [ ] **DIY-07:** Çelişki ve yüzleşme — yalan, kanıtla ortaya çıkar.
  - Kabul: ipucu (heybe, astar, görsel hata, hastalık belirtisi) bir beyanla çelişirse "Yüzleş" seçeneği açılır; yüzleşme o çelişkiye özel dal yürütür. Her CHR'de en az 1, tehlikeli CHR'de en az 2 çelişki çifti. Test: ipucu yokken yüzleşme kapalı, varken açık (KAP-07 davranışı korunur).
  - Bağımlılık: DIY-06. Boyut: M.
  - Dosya: yeni `src/soz/celiski.gd`.
  - Asset: asset gerekmedi.
- [ ] **DIY-08:** Bağlam sorgusu — dünyanın durumu tek sözlükte.
  - Kabul: konuşma başında tek sözlük üretilir: gün, mevsim, hava, açık krizler, köydeki binalar, nüfus, muhafız terazisi, itibar, karakterin önceki ziyaretleri, dünya olayları. Sözlük salt okunur; ekonomiye yazmaz. Test: sözlük alanları belgeyle aynı; olmayan bina `false`.
  - Bağımlılık: yok. Boyut: M.
  - Dosya: yeni `src/soz/baglam_sorgusu.gd`; okuduğu yöneticiler değişmez.
  - Asset: asset gerekmedi.
- [ ] **DIY-09:** Kural tablosu ile bağlamsal satır seçimi.
  - Kabul: bir satırın birden çok varyantı olabilir; her varyantın koşulları vardır; en çok koşulu tutan seçilir, hiçbiri tutmazsa varsayılan satır. Bu yolla tansiyon (sakin/gergin/panik), mevsim, kriz ve hafıza varyantları aynı mekanizmayla seçilir. Test: 6 koşullu örnekte doğru varyant; koşulu tutmayan varyant asla seçilmez.
  - Bağımlılık: DIY-08. Boyut: M.
  - Dosya: yeni `src/soz/satir_secici.gd`.
  - Asset: asset gerekmedi.
- [ ] **DIY-10:** Sır ve ikilem dalları — neden sakladığı.
  - Kabul: sırrı açığa çıkan karakter, sırrın nedenini anlatan dala geçer (aile, borç, korku, inanç, yemin); sır dalının sonunda oyuncuya en az 2 meşru seçenek kalır ve her birinin bedeli farklı sistemlere yazılır (adalet, köy güvenliği, vicdan, kasa). Örnek: kızı için saklayan baba. Test: her tehlikeli CHR'de en az 1 ikilem; ikilem seçenekleri farklı etki üretir.
  - Bağımlılık: DIY-07. Boyut: M.
  - Dosya: şema + motor; içerik YAZ.
  - Asset: asset gerekmedi.
- [ ] **DIY-11:** Kişi hafızası — dönen karakter hatırlar.
  - Kabul: kişi başına hafıza: son karar (kabul/ret/rüşvet/kışla), verilen söz ("yarın gel"), yapılan yardım, yüzleşilen yalan, ödenen/alınan akçe. Mevcut `KarakterKadrosu.durumlar[id]` (`ziyaret`, `son_karar`) tek kaynaktır; yeni alanlar optional kayıt. Dönüşte selam ve en az 1 konu hafızaya göre değişir. Test: ret → dönüş selamı ret varyantı.
  - Bağımlılık: DIY-09. Boyut: M.
  - Dosya: yeni `src/soz/kisi_hafizasi.gd`; kayıt adaptörü (`guvenli_kayit.gd` çekirdek, minimal).
  - Asset: asset gerekmedi.
- [ ] **DIY-12:** Grup itibarı — Türkmen, Rum, Ahi, köylü, tüccar, asker.
  - Kabul: muhafızın grup başına itibarı (−10…+10); kararlar ilgili gruba yazılır; itibar, satır seçimine ve zar değiştiricisine girer (ZAR-04). Köylü kartında ve muhafız odasında görünür. Test: Türkmen ret dizisi Türkmen itibarını düşürür, Rum etkilenmez.
  - Bağımlılık: DIY-08. Boyut: M.
  - Dosya: yeni `src/sistemler/grup_itibari.gd`, `data/gruplar.json`.
  - Asset: asset gerekmedi.
- [ ] **DIY-13:** Dedikodu yayılımı — haber gecikmeli dolaşır.
  - Kabul: kapıdaki önemli olay (rüşvet, şiddet, aileyi bölme, haksız ret) bir dedikodu kaydı üretir; 1–3 gece içinde köylüler arasında yayılır, kapıya gelenlerin selamına ve fısıltı gazetesine girer; tanık yoksa yayılmaz. Mevcut `FisiltiGazetesi` (CAS-09) ve `BatilInancHisterisi` (KRI-08) yeniden yazılmaz, aynı kaydı okur. Test: tanıksız rüşvet yayılmaz; tanıklı rüşvet 3 gece içinde en az 1 satırda geçer.
  - Bağımlılık: DIY-11, DIY-12. Boyut: M.
  - Dosya: yeni `src/sistemler/dedikodu.gd`.
  - Asset: asset gerekmedi.
- [ ] **DIY-14:** "Bu hatırlanacak" bildirimi.
  - Kabul: hafızaya veya dedikoduya giren seçimde ekranda kısa not çıkar (kimin hatırlayacağı söylenmez). Ayarlardan kapatılabilir.
  - Bağımlılık: DIY-11. Boyut: S.
  - Dosya: yeni `src/arayuz/kapi/hatirlanma_notu.gd`.
  - Asset: asset gerekmedi.
- [ ] **DIY-15:** Muhafızın sesi — seçenek metni terazi ve geçmişe göre tonlanır.
  - Kabul: aynı seçeneğin 3 ton varyantı (adil, sert, yozlaşmış); mekanik etki aynı, metin ve karşı tepki farklı; ton eşiği `data/` içinde. ACL-06 geçmişine özel seçenekler bu katmanda. Test: terazi uçlarında farklı metin.
  - Bağımlılık: DIY-09, ACL-06. Boyut: S.
  - Dosya: yeni `src/soz/muhafiz_tonu.gd`; okuma `MuhafizTerazisi`, `MuhafizVicdani`.
  - Asset: asset gerekmedi.
- [ ] **DIY-16:** Eski diyalog yollarının kapatılması — yeniden yazılan içerik devreye girer.
  - Kabul: eski metinler otomatik taşınmaz. YAZ-06 dalgaları bittikçe ilgili karakter yeni motora geçer; geçiş sırasında karakter başına tek yol çalışır (eski ya da yeni, ikisi birden değil). Son dalgadan sonra `SohbetVerisi` sohbet akışı, `_gemini_al()` ve `chr_diyalog_paneli.gd` kapı akışından çıkarılır; CHR'lerin heybe, görsel hata, karar matrisi ve spawn verisi (`KarakterVerisi`) yerinde kalır. Eski kayıtlar açılır (SYS-16 `diyalog_sira` okunur, yok sayılır). Test: 30 CHR + adlı karakterlerin tamamı yeni motordan; eski yollara çağrı 0.
  - Bağımlılık: DIY-02, YAZ-06. Boyut: L.
  - Dosya: `Oturum`, `chr_kapi_adaptoru.gd`, `kapi_ekrani.gd` yönlendirmesi (çekirdek, minimal); karakter başına geçiş tablosu `data/soz/gecis.json`.
  - Asset: asset gerekmedi.
- [ ] **DIY-17:** Güven ve korku ayrı ölçülür.
  - Kabul: tansiyon (korku) yanında ikinci değer olarak güven (0–10). İkram, karşılık verme ve dinleme güveni artırır; sert soru, heybeyi izinsiz karıştırma ve söz kesme düşürür. Güven satır koşulu (`guven_min/max`) ve zar değiştiricisidir (yüksek güven ikna −1, düşük güven +1). Güvenle açılan sır tam açılır; korkuyla (zar, gözdağı) açılan sır eksik açılır ve muhafız kalanını gözle doğrulamak zorunda kalır. Güven yeterince yükselince karakter kendiliğinden söze girer (zarsız itiraf). Prototip: `Roadmap-2/soz_agaci` (Yusuf: `sir_acildi` ve `sir_acildi_korku`, `itiraf`). Test: aynı sırrın iki açılışı farklı bilgi bırakır; güven ≥ 7 olmadan itiraf seçeneği görünmez.
  - Bağımlılık: DIY-02, DIY-09, ZAR-04. Boyut: M.
  - Dosya: `src/soz/` durum nesnesi; sorgu paneline ikinci çubuk.
  - Asset: asset gerekmedi.
- [ ] **DIY-18:** Söz kesme, karşı soru ve muhafızın beyanı.
  - Kabul: (a) Muhafız uzun anlatıyı kesebilir (`kesme`): karakterin son repliği yarıda kalır, sabır kazanılır, güven düşer, kaçan bilgi bir daha gelmez. (b) Karakter muhafızın sözünü kesebilir (`kesilir`): muhafızın cümlesi yarıda kalır, cevabın aceleciliği sezgi satırı ve ipucu üretir. (c) Karakter de soru sorar; muhafızın verdiği cevap `soylenen` olarak kaydedilir ve sonraki satırlarda karşılık bulur ("Berat dedin ya…"). (d) Seçimden hemen sonra kısa tepki (`tepki`). Arayüzde kesilen cümle "—" ile biter. Test: kesilen anlatının devam düğümüne bir daha ulaşılamaz; `soylenen` koşullu varyant yalnız o cevap verilmişse seçilir.
  - Bağımlılık: DIY-02, DIY-09. Boyut: M.
  - Dosya: `src/soz/` motor; sorgu paneli satır çizimi.
  - Asset: asset gerekmedi.

## BÖLÜM 17: Görünür Zar ve Sorgu Dengesi (Faz 2)

- [ ] **ZAR-01:** Görünür zar — d6 ve d12.
  - Kabul: ikna/blöf/gözdağı seçeneklerinde ekranda zar atılır; karakter verisinde `zar` alanı `d6` veya `d12`. Başarı: `zar ≥ gerekli`. `gerekli` = karakter değeri + 1 + tansiyon eki + değiştiriciler. Tansiyon eki üç kademe: Sakin (0–3) +0, Gergin (4–7) +1, Panik (8–10) +2. Örnek: değer 2 → sakin 3, gergin 4, panik 5. Formül ve eşikler `data/chr_runtime/sorgu_kurallari.tres` içinde, sabit kodlanmaz. Mevcut olasılık hesabı (`ChrSorgusu.basari_olasiligi`, KAP-09) bu kuralla değişir; eski kayıt çalışır. Test: 10.000 atışta dağılım teorik ±%2; d6'da 6, d12'de 12 her zaman başarı; 1 her zaman başarısız.
  - Bağımlılık: yok (DIY-02 gelince motora taşınır). Boyut: M.
  - Dosya: yeni `src/kapi/sorgu_zari.gd`; `ChrSorgusu.secenek_sec` tek satır.
  - Asset: zar görseli envantere `ZAR01-ZAR` (d6, d12); yer tutucu düz renk kutu + sayı.
- [ ] **ZAR-02:** Karakter değeri — kişiye göre taban zorluk.
  - Kabul: her CHR ve adlı karakterde `sorgu_degeri` (d6 için 1–5, d12 için 2–10); CHR şablonu ve `chr_parser.py` alanı okur; eksikse sınıfa göre varsayılan. Test: parser 30 CHR'de alanı doğrular.
  - Bağımlılık: ZAR-01. Boyut: S.
  - Dosya: `karakterler/CHR_*.md` Bölüm 4 satırı, `tools/chr_parser.py`.
  - Asset: asset gerekmedi.
- [ ] **ZAR-03:** Tansiyon 10'u aşarsa karakter gider.
  - Kabul: başarısız zar tansiyonu artırır; 10'u aşan karakter kapıdan ayrılır (karar "kaçtı"); hafızaya ve dedikoduya yazılır; tehlikeli karakter kaçarsa sonraki tehdit olasılığı artar. Test: 10'da başarısız zar → kaçış.
  - Bağımlılık: ZAR-01. Boyut: S.
  - Dosya: `src/kapi/sorgu_zari.gd`; karar akışına adaptör.
  - Asset: asset gerekmedi.
- [ ] **ZAR-04:** Yaklaşım türleri ve değiştiriciler.
  - Kabul: dört yaklaşım: ikna, blöf, gözdağı, gönül alma. Değiştiriciler: muhafız terazisi (adil → ikna/gönül alma kolay, yozlaşmış → gözdağı kolay), grup itibarı, bulunmuş kanıt (+), yanındaki asker (gözdağı +), muhafız yorgunluğu (−). Değiştiriciler zar öncesi listede görünür. Test: her değiştirici ayrı test.
  - Bağımlılık: ZAR-01, DIY-12. Boyut: M.
  - Dosya: yeni `src/kapi/zar_degistiricileri.gd`, `data/zar_degistiricileri.json`.
  - Asset: asset gerekmedi.
- [ ] **ZAR-05:** Tekrar edilebilir ve tek şanslık kontroller.
  - Kabul: kontrol türü verisi: "tekrar" (koşul değişince yeniden denenir) ve "tek şans" (kırmızı kenarlı, bir kez, kalıcı sonuç). Tek şanslık kontrol yalnız sır/ikilem düğümlerinde. Test: tek şanslık kontrol ikinci kez açılmaz.
  - Bağımlılık: ZAR-01, DIY-10. Boyut: S.
  - Dosya: şema + `sorgu_zari.gd`.
  - Asset: asset gerekmedi.
- [ ] **ZAR-06:** Muhafız sezgisi — zarsız pasif kontrol.
  - Kabul: muhafız tecrübesi (+ geçmiş) belirli eşiği geçince ek satır kendiliğinden görünür ("Elleri nasırsız; reçber eli değil bu."). Zar atılmaz. Her CHR'de en az 1 sezgi satırı. Test: eşik altı görünmez.
  - Bağımlılık: DIY-09, ACL-06. Boyut: S.
  - Dosya: yeni `src/soz/muhafiz_sezgisi.gd`.
  - Asset: asset gerekmedi.

## BÖLÜM 18: Kapıda Çatışma ve Sonuçları (Faz 2)

- [ ] **CAT-01:** Geri çevrilen kavga çıkarabilir.
  - Kabul: yer yokluğu veya sert retle çevrilen, belli karakter tiplerinde (genç erkek, aç aile reisi, asker kaçağı) kavga isteği doğar; kavga yalnız en az 1 asker varken ve kapıda; asker yoksa kişi tehdit edip gider (dedikodu). Test: askersiz köyde kavga 0.
  - Bağımlılık: ACL-05, DIY-13. Boyut: M.
  - Dosya: yeni `src/kapi/kapi_kavgasi.gd`.
  - Asset: asset gerekmedi.
- [ ] **CAT-02:** Kavga seçenekleri — askerle karşılık, akçeyle erteleme, sözle yatıştırma, reddetme.
  - Kabul: dört seçenek; askerle karşılık asker becerisi + zar; akçeyle erteleme "yarın gel" sözü üretir ve kişi 2–4 gün sonra döner (söz tutulmazsa itibar −); yatıştırma ZAR kontrolüdür. Sonuçlar: yaralanma, ölüm, kaçış, kin. Test: her seçenek ayrı sonuç.
  - Bağımlılık: CAT-01, ZAR-01, DIY-11. Boyut: M.
  - Dosya: `src/kapi/kapi_kavgasi.gd`.
  - Asset: kavga canlandırması için envantere `CAT02-KAVGA` animasyon; yer tutucu sarsıntı + metin.
- [ ] **CAT-03:** Yaralının tedavisi — hekim varsa iyileştirir.
  - Kabul: kavgada yaralanan (bizimki veya yabancı) Şifahaneye gidebilir; hekim yoksa sağlık kaybı sürer. Yabancı yaralıyı tedavi edip göndermek itibar +. Mevcut KRI-03 hekim akışı kullanılır. Test: hekimli/hekimsiz fark.
  - Bağımlılık: CAT-02. Boyut: S.
  - Dosya: `src/koy/hekim_ilac.gd` adaptör.
  - Asset: asset gerekmedi.
- [ ] **CAT-04:** Kapıda şiddet sırayı korkutur.
  - Kabul: kapıda şiddet gören sıradakilerden tansiyonu yüksek olanlar ayrılabilir; ayrılan kişi sonraki gün dedikodu taşır. Test: şiddet sonrası en az 1 ayrılma olasılığı tabloyla uyumlu.
  - Bağımlılık: CAT-02, BUG-20. Boyut: S.
  - Dosya: yeni `src/kapi/siddet_korkusu.gd`.
  - Asset: asset gerekmedi.

## BÖLÜM 19: Söz İçeriği — Dünya Kitabı ve Karakterlerin Yeniden Yazımı (Faz 3)

İlke: oyun çalışırken yapay zekâ çağrılmaz. Metinler oyun dışında, dünya kitabına (RAG) dayanarak güçlü bir modelle yazılır, doğrulayıcıdan geçer, insan onayıyla veri olarak girer.

- [ ] **YAZ-01:** Dünya kitabı — dönem bilgisi.
  - Kabul: `docs/dunya_kitabi/` altında konu başına dosya: 1230–1260 Anadolu (Babai İsyanı 1240, Kösedağ 1243 ve sonrası Moğol tahakkümü), Selçuklu uç düzeni, Türkmen boyları ve göç, Bizans uç beyleri ve Rum köylüler, Ermeni ve Süryani toplulukları, Ahi teşkilatı, dervişler, ticaret yolları ve kervansaraylar, köy ekonomisi, meslekler, giyim, yemek, inanç ve yemin kalıpları, coğrafya (Sivas, Erzincan, Kayseri, Konya, Malatya…). Her dosyada kaynak listesi. Anlatı yönetmeni ve Ahmet onayı.
  - Bağımlılık: yok. Boyut: L (içerik).
  - Dosya: yeni `docs/dunya_kitabi/*.md`.
  - Asset: asset gerekmedi.
- [ ] **YAZ-02:** Üslup rehberi — dönem dili, yaşayan dil.
  - Kabul: `docs/dunya_kitabi/USLUP.md` (taslak: `Roadmap-2/USLUP_REHBERI.md`): hitaplar (ağam, beğim, bacı, ahi baba, efendi, ana, kardaş), selamlaşma, yemin ve dua kalıpları, ağız farkları (Türkmen, Rum, Ahi, derviş, levent), yasak kelime listesi (anakronizm ve modern deyim), cümle uzunluğu ölçüsü (selam ≤ 2 cümle; ilk cevaplar kısa). Kelimeden çok **cümle yapısı**: yapay metnin kalıpları (vecize karşıtlığı, "X değil Y", üçlü sıra, gerekçe bağlacı, soruya tam oturan cevap, tekdüze ritim, güzel kapanış) ve halk ağzının yapıları (devrik cümle, aktarılan söz, soruya soru, dolgu sözler, yarım bırakma, kendini düzeltme, yan cevap). Yöntem: özet → sesli doğaçlama → biçime sokma → denetim → inceleme. Doğrulayıcı yasak kelimeleri ve yapı kurallarını tarar (YAZ-07).
  - Bağımlılık: YAZ-01. Boyut: M.
  - Dosya: yeni `docs/dunya_kitabi/USLUP.md`, `data/soz/yasak_kelimeler.txt`.
  - Asset: asset gerekmedi.
- [ ] **YAZ-03:** Karakter ses kartı — her karakter için.
  - Kabul: her CHR ve adlı karakter için tek kart: önce insan eliyle yazılmış "kim bu insan" paragrafı; kökeni, ağzı, konuşma alışkanlıkları (sıfat değil somut alışkanlık: "soruya önce yarım cevap verir, sonra düzeltir"), yalan söyleme biçimi (sapma, aşırı ayrıntı, soruya soru, susma), korktuğu şey, istediği şey, hikâye çekirdeği (YAZ-09), varsa sır ve nedeni, diğer karakterlerle bağları. 30 CHR + 40 adlı karakter kartı doğrulayıcıdan geçer.
  - Bağımlılık: YAZ-01. Boyut: L (içerik).
  - Dosya: yeni `data/soz/ses_kartlari/*.json`.
  - Asset: asset gerekmedi.
- [ ] **YAZ-04:** Yazım hattı — model istemi, üretim, doğrulama, onay.
  - Kabul: `tools/soz_yazim/` altında istem şablonu (dünya kitabı + üslup + ses kartı + şema), çıktıyı şemaya çeviren araç ve inceleme raporu (yasak kelime, uzunluk, selamdan önce hikâye, eksik konu, çelişki çifti). Çıktı ancak insan onayıyla `data/soz/` altına girer; onay imzası dosyada.
  - Bağımlılık: DIY-01, YAZ-02, YAZ-03. Boyut: M.
  - Dosya: yeni `tools/soz_yazim/*.py`, `tools/soz_yazim/istem.md`.
  - Asset: asset gerekmedi.
- [ ] **YAZ-05:** Pilot: Sivaslı reçber ve iki karakter daha.
  - Kabul: reçber + 1 tehlikeli CHR + 1 adlı karakter yeni biçimde, tam ağaçla (selam, 7 konu, katmanlar, en az 2 çelişki, sır ve ikilem, hafıza varyantları, mevsim/kriz varyantları). Ahmet okuyup onaylar; onay olmadan toplu üretim başlamaz.
  - Bağımlılık: YAZ-04, DIY-02…DIY-11. Boyut: M.
  - Dosya: `data/soz/recber.json` vb.
  - Asset: asset gerekmedi.
- [ ] **YAZ-06:** Toplu yeniden yazım — 30 CHR, 40 adlı karakter, adsız şablonlar.
  - Kabul: dalgalar halinde (10'arlı); her dalga doğrulayıcı 0 hata + insan onayı; adsız gelenler için sınıf başına en az 4 farklı kişilik şablonu (aynı sınıftan iki kişi aynı konuşmaz). Rapor: karakter başına düğüm, konu, çelişki, ikilem sayısı.
  - Bağımlılık: YAZ-05. Boyut: L (içerik).
  - Dosya: `data/soz/*.json`.
  - Asset: asset gerekmedi.
- [ ] **YAZ-07:** Söz doğrulayıcı ve önizleme aracı.
  - Kabul: `tools/soz_dogrula.py` sanity'ye girer: şema, kopuk düğüm, ulaşılamayan dal, eksik metin anahtarı, yasak kelime, selam kuralı, tek şanslık kontrol yeri, yapaylık kuralları (prototip: `Roadmap-2/soz_agaci/yapaylik.js`, 14 kural; uyarı verir, karar vermez). Oyun içi debug önizleyicisi (ADM paneli): karakter seç, bağlamı ayarla (mevsim, kriz, tansiyon, hafıza), ağacı yürüt. Kayda yazmaz.
  - Bağımlılık: DIY-01. Boyut: M.
  - Dosya: yeni `tools/soz_dogrula.py`, `src/debug/soz_onizleme.gd`; `tools/sanity_check.py` tek satır; ADM paneline tek düğme.
  - Asset: asset gerekmedi.
- [ ] **YAZ-08:** Köy içi sohbetler — köylüler de konuşur.
  - Kabul: kabul edilen karakterle köyde konuşulabilir (köylü kartından); konular: iş, aile, dert, dedikodu; kapıdaki hafıza devam eder. Her CHR için en az 3 köy satırı.
  - Bağımlılık: YAZ-06, DIY-13. Boyut: M.
  - Dosya: yeni `src/arayuz/koy_hud/koylu_sohbeti.gd`.
  - Asset: asset gerekmedi.
- [ ] **YAZ-09:** Hikâye çekirdekleri ve kadro özgünlük denetimi.
  - Kabul: `Roadmap-2/OZGUNLUK.md` esas alınır. Şablon zorunlu evre dayatmaz (yalnız varış ve karar). Her karakterin `cekirdek` alanı (dürüst, koruma yalanı, yanlış anlaşılma, bilmediği, abartma, başkasının sırrı, pazarlık, itiraf etmek isteyen, dinlenmek isteyen, tehlikeli yalan, hafif) ve yedi eksenli benzersizlik matrisi var. Kadro denetimi: dürüst + dinlenmek isteyen ≈ %40; başka hiçbir çekirdek %15'i, hiçbir sahne biçimi %30'u geçmez; dört eksende aynı iki karakter uyarı; kadronun yarısından fazlası "sır" evresini kullanıyorsa uyarı. Karakterler arası bağlar (`baglar`) hafıza ve dedikoduya bağlanır. Test: denetim örnek kadroda kotayı doğru sayar; gerekçe notu uyarıyı geçirir.
  - Bağımlılık: YAZ-03, YAZ-07. Boyut: M.
  - Dosya: yeni `tools/soz_kadro_denetimi.py`; `data/soz/kadro.json`.
  - Asset: asset gerekmedi.
- [ ] **YAZ-10:** İnceleme modu ve kapsam taraması.
  - Kabul: önizleme aracında her satır ✓ doğal / ✗ yapay / ✎ yeniden yaz olarak işaretlenir, not alınır; işaretler dışa ve içe aktarılır (JSON), metin değişince "metin değişti" uyarısı çıkar. Kapsam taraması binlerce rastgele oynanışta hiç görünmeyen satırı ve ulaşılmayan düğümü listeler. Bir sahne ancak ✗ ve ✎ işareti kalmayınca ve kapsamda görünmeyen satır yokken onaya gider. Prototip: `Roadmap-2/soz_agaci` İnceleme sekmesi ve Şablon sekmesindeki kapsam düğmesi.
  - Bağımlılık: YAZ-07. Boyut: S.
  - Dosya: `src/debug/soz_onizleme.gd`; `tools/soz_dogrula.py --kapsam`.
  - Asset: asset gerekmedi.

## BÖLÜM 20: İş Gücü, Meslek Uyarısı ve Geçici İşler (Faz 4)

- [ ] **ISG-01:** Kabul anında meslek uyarısı.
  - Kabul: mesleği olan karakterin karar panelinde: "Kumaşçı — dokuma tezgâhı yok. Nitelikli iş verilemez; günde 1 erzak yer, geçici işte %X verimle çalışır." Uyarı mesleğin binasına göre otomatik. Test: atölyesiz köyde uyarı var, atölyeli köyde yok.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: yeni `src/kapi/meslek_uyarisi.gd`; meslek→bina eşlemesi `data/meslek_binalari.json`.
  - Asset: asset gerekmedi.
- [ ] **ISG-02:** Geçici işler havuzu — boştakilere iş.
  - Kabul: bina gerektirmeyen işler: taş toplama (taş yatağı), çalı ve dal toplama (odun), su taşıma, hendek/yol açma (inşaat hızı +), inşaat yardımcılığı, gece bekçisine eşlik (güvenlik +, yorgunluk +), yün eğirme (evde, kadın/yaşlı), ot ve mantar toplama (mevsimlik gıda), çocuk ve hasta bakımı. Her işin verimi ve yorgunluğu `data/gecici_isler.json`. Köylü kartında "Geçici işler" sekmesi. Test: her iş gece hesabına ayrı satır yazar.
  - Bağımlılık: BUG-21, YSM-01. Boyut: M.
  - Dosya: yeni `src/koy/gecici_isler.gd`; köylü kartına adaptör.
  - Asset: işlere özel el aleti envantere `ISG02-ALETLER`; yer tutucu ANI-11 kutu soketi.
- [ ] **ISG-03:** Boşta kalma bedeli ve görünürlüğü.
  - Kabul: HUD'da "Boşta: N kişi"; boşta kalan moralini kaybeder; 3 gün boşta kalan mesleki kişi köyü terk etmeyi düşünür (köy sohbetinde söyler). Test: 3. gün terk isteği.
  - Bağımlılık: ISG-02. Boyut: S.
  - Dosya: yeni `src/koy/bosta_kalma.gd`.
  - Asset: asset gerekmedi.

## BÖLÜM 21: Yapı Kilidi, Ustalar, Usta Defterleri ve Yapı Resimleri (Faz 4)

- [ ] **YAP-01:** Yapı kademeleri — her şey baştan açık değil.
  - Kabul: yapılar kademelere ayrılır: K0 (çadır, tarla, taş yatağı, odun yığını), K1 (kulübe, hızarhane, taş ocağı, ambar), K2 (taş ev, sur 2, değirmen, şifahane…), K3 (sur 3, konak, gelişmiş atölyeler). Kademe tablosu `data/koy/yapi_kademeleri.json`. Kilitli yapı inşa menüsünde görünür ama gri; "Gerekli: duvarcı ustası" yazar. Test: K2 usta yokken kurulamaz.
  - Bağımlılık: yok. Boyut: M.
  - Dosya: yeni `src/koy/yapi_kilidi.gd`; `BinaKatalogu` sorgusuna tek satır.
  - Asset: asset gerekmedi.
- [ ] **YAP-02:** Yapı bilgisinin kaynakları — usta, muhafız geçmişi, çırak.
  - Kabul: bir yapı şu yollardan biriyle açılır: o bilgiye sahip usta köyde yaşıyor; muhafızın geçmişi biliyor (ACL-06); çırak usta oldu (UZM-04/11). Usta ölür veya giderse yeni inşaat durur, mevcut yapı kalır; çırak yetişmişse bilgi korunur. Test: usta ayrılınca kilit geri gelir, çıraklı köyde gelmez.
  - Bağımlılık: YAP-01, ACL-06. Boyut: M.
  - Dosya: yeni `src/koy/yapi_bilgisi.gd`; ustalık verisi `Koylu` (optional alan).
  - Asset: asset gerekmedi.
- [ ] **YAP-03:** Ustalar kapıdan gelir — özel karakterler.
  - Kabul: duvarcı, dülger, değirmen ustası, demirci, mimar gibi ustalar nadir gelir; gelmeleri köy çekiciliğine ve dünya olaylarına bağlıdır; her usta kendi söz ağacıyla gelir ve kabul kararı gerçek bir pazarlıktır (ücret, ev, yanında gelen ailesi). Test: K2 ustası 28 günde en az 1 kez gelir (tohumlu).
  - Bağımlılık: YAP-02, KAP-16, YAZ-05. Boyut: M.
  - Dosya: yeni `src/kapi/usta_gelisi.gd`, `data/ustalar.json`.
  - Asset: usta modelleri envantere `YAP03-USTALAR`.
- [ ] **YAP-04:** Usta defterleri ve yapı resimleri — ganimetten gelen bilgi.
  - Kabul: dış seferler, pusu temizliği (HAR-05/14), baskın sonrası ganimet ve tüccarlar "usta defteri / yapı resmi / örnek eşya" getirebilir; defter tek başına yapı açmaz, kâtip veya usta tarafından çözülmesi gerekir (YAP-05). Defter envanterde görünür. Test: ganimet tablosu defter üretir.
  - Bağımlılık: YAP-01. Boyut: M.
  - Dosya: yeni `src/koy/usta_defterleri.gd`, `data/usta_defterleri.json`.
  - Asset: defter ikonu envantere `YAP04-DEFTER`.
- [ ] **YAP-05:** Çözümleme işi — araştırma.
  - Kabul: kâtip, medreseli veya usta, çözümleme odasında (K1 yapı) defteri N günde çözer; çözüm bir yapıyı veya özel eşyayı açar (ör. Horasan harcı: sur dayanımı +; Rum usulü su değirmeni; Türkmen keçesi: kış odun tüketimi −; uzun menzilli yay). Aynı anda tek çözümleme. Test: süre ve sonuç tabloyla uyumlu.
  - Bağımlılık: YAP-04. Boyut: M.
  - Dosya: yeni `src/koy/cozumleme.gd`; çözümleme odası katalog satırı.
  - Asset: çözümleme odası modeli envantere `YAP05-ODA`.
- [ ] **YAP-06:** Özel eşyalar.
  - Kabul: çözümlemeden çıkan eşyalar ayrı listede; her birinin mekanik etkisi tek sisteme yazılır ve testle doğrulanır; en az 8 eşya, dönemle uyumlu (dünya kitabından kaynaklı).
  - Bağımlılık: YAP-05, YAZ-01. Boyut: M.
  - Dosya: yeni `src/koy/ozel_esyalar.gd`, `data/ozel_esyalar.json`.
  - Asset: eşya ikonları envantere `YAP06-ESYA`.

## BÖLÜM 22: Yaşam Barları ve Köylü Davranışı (Faz 4)

- [ ] **YSM-01:** Köylü başına açlık, yorgunluk, moral barı.
  - Kabul: köylü kartında ve yüzen kartta (ANI-14) üç bar; değerler gece hesabından gelir, ikinci hesap kurulmaz (KRI-12 açlık–sağlık bağı kullanılır). Test: erzaksız gecede açlık artar.
  - Bağımlılık: yok. Boyut: M.
  - Dosya: yeni `src/koy/yasam_barlari.gd`, `src/arayuz/koy_hud/yasam_barlari_paneli.gd`.
  - Asset: bar ikonları envantere `YSM01-IKON`.
- [ ] **YSM-02:** Açlığın kademeli etkisi.
  - Kabul: 1 gün aç: üretim −%20; 2 gün: −%50, yürüyüş yavaş; 2 günü aşan: evde yatar, çalışmaz, hastalık riski +. Eşikler veri dosyasında. Test: her kademe.
  - Bağımlılık: YSM-01. Boyut: S.
  - Dosya: yeni `src/koy/aclik_kademesi.gd`; ANI rutinlerine tek satır.
  - Asset: asset gerekmedi.
- [ ] **YSM-03:** Gece evde uyku, gündüz dinlenme.
  - Kabul: yorgunluk gece evde uyuyarak düşer; yatağı olmayan açıkta uyur, yorgunluğu yarım düşer; yorgun köylü kaza riskini artırır (UZM-12/14 bağlanır). Test: yataklı/yataksız fark.
  - Bağımlılık: YSM-01, ACL-05. Boyut: S.
  - Dosya: yeni `src/koy/uyku_dinlenme.gd`.
  - Asset: asset gerekmedi.

## BÖLÜM 23: Zamanla İlerleyen Dünya (Faz 5)

- [ ] **DNY-01:** Dünya zaman çizelgesi.
  - Kabul: `data/dunya/zaman_cizelgesi.json`: takvime bağlı büyük olaylar (Moğol ilerleyişi, Selçuklu taht kavgası, Bizans uç baskısı, kıtlık yılı, salgın dalgası, ticaret yolunun kapanması); her olayın erken söylenti, kesin haber ve etki evresi. HAR-02 Moğol sayacı bu çizelgeye bağlanır, ikinci sayaç yok. Test: 3 yıl simülasyonunda olay sırası belgeyle aynı.
  - Bağımlılık: YAZ-01. Boyut: M.
  - Dosya: yeni `src/sistemler/dunya_zamani.gd`.
  - Asset: asset gerekmedi.
- [ ] **DNY-02:** Haber önce insanlardan duyulur.
  - Kabul: dünya olayı etki etmeden önce kapıya gelenlerin "Yolda ne gördün" konusunda ve köy dedikodusunda geçer; aynı olay farklı karakterlerde farklı (çelişkili olabilir) anlatılır. Test: etki evresinden önce en az 2 karakter satırı.
  - Bağımlılık: DNY-01, DIY-03, DIY-13. Boyut: M.
  - Dosya: `src/soz/baglam_sorgusu.gd` alanı; içerik YAZ.
  - Asset: asset gerekmedi.
- [ ] **DNY-03:** Olayların köye etkisi.
  - Kabul: her dünya olayı tek bir mevcut sisteme yazar (gelen akışı, fiyat, tehdit, salgın, vergi); etki gece raporunda kaynağıyla görünür. Test: olay başına bir etki testi.
  - Bağımlılık: DNY-01, KAP-16. Boyut: M.
  - Dosya: yeni `src/sistemler/dunya_etkisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **DNY-04:** Oyuncunun kararları dünyaya geri döner.
  - Kabul: belirli kararlar (Tekfur haracı, Moğol elçisi, Türkmen beyiyle ittifak) çizelgede sonraki olayların koşulunu değiştirir; nihai sonlar (SYS-20) bu kayıtları okur. Test: farklı karar dizisi farklı olay dizisi.
  - Bağımlılık: DNY-01. Boyut: M.
  - Dosya: `src/sistemler/dunya_zamani.gd`.
  - Asset: asset gerekmedi.

## BÖLÜM 24: Arayüz, Görsel Dil ve Yükleme Ekranları (Faz 1'de başlar, sonra yayılır)

- [ ] **ARY-01:** Görsel dil için örnek şablonlar — Berk ve Ahmet seçer.
  - Kabul: 3 farklı şablon önerisi (renk, çerçeve, yazı tipi ailesi, düğme durumları, panel dokusu tarifi); her biri sorgu ekranı, harita ve köylü kartı üzerinde yer tutucu ile canlı gösterilir. Seçim kararı belgeye yazılır.
  - Bağımlılık: yok. Boyut: M.
  - Dosya: yeni `docs/arayuz/SABLONLAR.md`, `src/arayuz/tema_onizleme.tscn`.
  - Asset: şablonlar için doku/çerçeve/yazı tipi envantere `ARY01-*`; yer tutucu `StyleBoxFlat`.
- [ ] **ARY-02:** Tema altyapısı — seçilen dil tek yerden.
  - Kabul: tüm paneller tek tema kaynağından stil alır; panel başına yerel renk/boyut kalmaz (tarama raporu 0). `tema.gd` çekirdek, minimal; yeni stiller ayrı kaynakta.
  - Bağımlılık: ARY-01. Boyut: L.
  - Dosya: yeni `src/arayuz/tema/*.tres`; `tema.gd` adaptör.
  - Asset: ARY-01 envanteri.
- [ ] **ARY-03:** Ekranların taşınması — harita, sorgu, seçim düğmeleri, köy HUD, pazar, divan, oda, gece raporu.
  - Kabul: her ekran için ayrı alt madde kapanır; ekran görüntüsü önce/sonra raporda; kapı sahnesindeki kalite ölçüt alınır.
  - Bağımlılık: ARY-02. Boyut: L (ekranlara bölünür).
  - Dosya: ilgili arayüz dosyaları, adaptörle.
  - Asset: ekran arka planları envantere `ARY03-*`.
- [ ] **ARY-04:** Yükleme ekranları ve ara sahne çerçevesi — çeşitli, tekrarsız.
  - Kabul: en az 8 yükleme görseli için yuva; aynı görsel art arda gelmez; görselin altında dönemle ilgili kısa metin (dünya kitabından); ara sahneler aynı çerçeveyi kullanır. Görseller gelene kadar düz renk + metin.
  - Bağımlılık: ARY-02, YAZ-01. Boyut: M.
  - Dosya: yeni `src/arayuz/yukleme_ekrani.gd`, `data/yukleme_ekranlari.json`.
  - Asset: 8+ yükleme görseli ve ara sahne arka planları envantere `ARY04-YUKLEME-01…08`.
- [ ] **ARY-05:** ROADMAP 2 asset listesi — karakterlerle birlikte, yalnız gerekenler.
  - Kabul: `docs/EKSIK_ASSET_ENVANTERI.md` içinde ROADMAP 2 bölümü: yeni karakterler (muhafız, eş, çocuk, yaşlı, ustalar, yetimler), yapı ve kaynaklar (taş yatağı, çözümleme odası, kademe yapıları), arayüz (şablon dokuları, ikonlar, zar), yükleme ve ara sahne görselleri, onarım (meşale, kuyu). Her satırda ROADMAP ID, tür, yer tutucu yolu, TR+EN arama kelimeleri, öncelik. Gereksiz satır yok: her satırın bir ROADMAP 2 maddesi var.
  - Bağımlılık: her bölümün kapanışında güncellenir. Boyut: S (sürekli).
  - Dosya: `docs/EKSIK_ASSET_ENVANTERI.md`.
  - Asset: —

---

## Önerilen uygulama sırası

1. **Faz 0:** BUG-16 … BUG-25 (oyun kilitlerini ve yanlış olayları kapat).
2. **Faz 1:** ACL, KAP-16 … KAP-19; paralelde ARY-01 (şablon kararı insan beklediği için erken başlar).
3. **Faz 2:** DIY, ZAR, CAT (motor). Paralelde YAZ-01 … YAZ-03 (dünya kitabı ve ses kartları motoru beklemez).
4. **Faz 3:** YAZ-04 … YAZ-10 (pilot → inceleme → onay → toplu yazım; kadro denetimi her dalgada).
5. **Faz 4:** ISG, YAP, YSM.
6. **Faz 5:** DNY.
7. **Faz 6:** ARY-02 … ARY-04 (seçilen şablonla yayılım).

## Karar kaydı (Ahmet, 10 Ekim 2026)

1. **ACL-04:** Kapıyı Sancak Beyi'nin ulağı ve beratı açar; hemen ardından ilk aile gelir ve ilk sorgu onlarla yapılır.
2. **ZAR-01:** Tansiyon eki üç kademe: sakin +0, gergin +1, panik +2. Değer 2 → 3 / 4 / 5.
3. **ACL-02:** Eşin mesleğini oyuncu seçer, ama yalnız eşe uygun listeden (demirci, taşçı, asker vb. yok).
4. **YAP-04:** "Şematik" yerine "usta defteri / yapı resmi".
5. **DIY-16:** Eski diyaloglar taşınmaz, baştan yazılır. Önce profesyonel oyunların mantığı incelenir, kendi stilimizle motor kurulur (DIY-01).
6. **YAZ-02:** Doğallık kelimeden değil cümle yapısından gelir. Metin önce sesli doğaçlamayla çıkar, sonra yapaylık denetimi ve satır satır inceleme yapılır (YAZ-10).
7. **YAZ-09:** Şablon bir dilbilgisidir, içerik kalıbı değil. Her karakterin sırrı olmaz; hikâye çekirdekleri kadroya kotayla dağıtılır.
