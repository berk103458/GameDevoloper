# BÖLÜM 37 — Söylenti, dedikodu ve kamuoyu ağı

Faz 2–3 (DIY-13 ve KOP-05 kapandıktan sonra). Zemin:

- Fısıltı gazetesi CAS-09: `src/kapi/fisilti_gazetesi.gd` (`oku`, `durum`, `gece`, `olay`, `tanimli`, `uygun`, `uygula`), veri `data/fisilti_gazetesi.json`; yer kalıbı BUG-17 ile `{yer}` olur.
- Dedikodu yayılımı DIY-13 (`src/sistemler/dedikodu.gd`, tanık, 1–3 gece, ağır olay listesi); KOP-05 dedikoduyu gazetenin tek yazarı yapar; `BatilInancHisterisi` (KRI-08, `src/koy/batil_inanc_histerisi.gd`) aynı kaydı okur.
- Grup itibarı DIY-12 (altı grup, −10…+10), kişi hafızası DIY-11, "Bu hatırlanacak" DIY-14, haber önce insandan DNY-02, sabah tek dedikodu satırı SAB-04, köy içi sohbetler YAZ-08, çınar meclisi MCL, eşin duyumu HAN-18, haberci ağı HAR-09 (`haberci_agi.gd`).
- Kodda kamuoyu, söylenti ağı, kaynak güvenilirliği yoktur; dört bar (`barlar.gd`) köy genelinin tek sayısıdır.

Bu bölüm dedikodu kaydını ve gazeteyi yeniden kurmaz. Dedikodunun ağını yazar: kaynağı, taşıyıcısı, kulağı, doğruluğu, kamuoyuna dönüşmesi ve oyuncunun bunu okuyup etkilemesi. Kayıt DIY-13'ündür; ağ ona kaynak, yol ve güvenilirlik alanı ekler. Söz motoru DIY-03 satır seçiminde ağı bağlam sorgusuyla (DIY-09) okur.

Kimlikler SOY-01 … SOY-50. Kalp puanı, romans, seslendirme yok. Asset üretilmez. Yeni dosya + ince adaptör; `fisilti_gazetesi.gd` ve `dedikodu.gd` imzaları değişmez. Bitince `[x]` ve ajan adı.

**Madde biçimi:** Ne, Kabul, Bağımlılık + Boyut, Dosya, Asset.

---

## 37.1 Söylentinin anatomisi — kaynak, yol, doğruluk

- [ ] **SOY-01:** Her dedikodu kaydının kaynağı ve doğruluğu vardır.
  - Ne: DIY-13 kaydına optional iki alan: `kaynak` (tanık köylü kimliği) ve `dogru` (bool; olay gerçekten oldu mu). Yanlış söylenti SOY-05 ile üretilir. Omurga (OMR-39) yalnız `dogru` kayıtları okur.
  - Kabul: alanlar optional; eski kayıt `dogru=true`, `kaynak=""` sayılır. Test: KAY birimi.
  - Bağımlılık: DIY-13, KAY-04. Boyut: S.
  - Dosya: yeni: `src/sistemler/soylenti_agi.gd` (kaydı okur, alan ekler).
  - Asset: asset gerekmedi.
- [ ] **SOY-02:** Düğüm — kim duydu.
  - Ne: her kayıt için "duyanlar" kümesi: başlangıçta tanık; her gece yayılım adımında (DIY-13 1–3 gece) tanığın komşuları (`izgara.gd` komşuluk) ve aynı iş yerindekiler (`meslek_yapilari.gd`) eklenir. Eşin duyumu (HAN-18) bu kümeden gelir.
  - Kabul: gece başına yeni duyan ≤ 4 (öneri, `data/soylenti.json`); duyanlar kümesi kayıtta. Test: üç gece.
  - Bağımlılık: SOY-01, HAN-18. Boyut: M.
  - Dosya: `src/sistemler/soylenti_agi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SOY-03:** Taşıyıcı — kapıdan giren haber.
  - Ne: kapıdan kabul edilen kişi dış haber taşıyabilir (DNY-02 söylentisi, hane misafiri HAN-14); içeri girince ilk düğüm odur.
  - Kabul: kabul edilen taşıyıcı kayıtta `kaynak`. Test: kabul.
  - Bağımlılık: DNY-02, SOY-02. Boyut: S.
  - Dosya: `src/sistemler/soylenti_agi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SOY-04:** Reddedilen de haber bırakır.
  - Ne: reddedilen kişi sıradakilere (kapı kuyruğu, `kapi_firtina_kuyrugu.gd` sırası) bir cümle bırakabilir; kuyruktaki kabul edilirse haberi taşır.
  - Kabul: red sonrası kuyrukta `tasinan_haber` 1. Test: red + kabul.
  - Bağımlılık: SOY-03. Boyut: S.
  - Dosya: `src/sistemler/soylenti_agi.gd`; kuyruk adaptörü tek satır.
  - Asset: asset gerekmedi.
- [ ] **SOY-05:** Yanlış söylenti.
  - Ne: kayıt yayılırken her adımda bozulma olasılığı (`yalan_olasiligi` 0.35'in çeyreği, öneri `data/soylenti.json`): kişi adı, yer veya miktar değişir; `dogru=false` kopyası oluşur. Asıl kayıt silinmez.
  - Kabul: 100 yayılımda bozulma oranı tablo ±%5; bozulan kopya `kaynak` alanında bozanı taşır. Test: simülasyon.
  - Bağımlılık: SOY-01. Boyut: M.
  - Dosya: `src/sistemler/soylenti_agi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SOY-06:** Söylenti ölür.
  - Ne: DIY-13 "üçüncü geceden sonra basılmamış satır silinir" kuralı korunur; ağ kaydı 7 gece (öneri) sonra düşer, kamuoyuna (SOY-13) dönüştüyse izi orada kalır.
  - Kabul: 8. gece kayıt 0. Test: zaman makinesi.
  - Bağımlılık: SOY-02. Boyut: S.
  - Dosya: `src/sistemler/soylenti_agi.gd`.
  - Asset: asset gerekmedi.

## 37.2 Kaynak güvenilirliği

- [ ] **SOY-07:** Her köylünün söz güvenilirliği vardır.
  - Ne: köylüde optional `guvenilirlik` 0–3 (başlangıç 2): yaydığı söylenti doğru çıkınca +1, yanlış çıkınca −1. Kalp puanı değil; yalnız haber doğruluğu.
  - Kabul: alan `koylu.gd` dışında ağ sözlüğünde (çekirdek değişmez). Test: iki olay.
  - Bağımlılık: SOY-05. Boyut: S.
  - Dosya: `src/sistemler/soylenti_agi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SOY-08:** Güvenilirlik köylü kartında bir kelimedir.
  - Ne: `koylu_karti_verisi.gd` adaptörüne tek alan: "ağzı sıkı / konuşkan / uyduruyor" (3/2/0–1).
  - Kabul: kartta kelime; sayı yok. Test: ekran.
  - Bağımlılık: SOY-07. Boyut: S.
  - Dosya: kart adaptörü tek alan.
  - Asset: asset gerekmedi.
- [ ] **SOY-09:** Doğrulama — oyuncu kaynağa sorar.
  - Ne: köy ekranında köylüye tıklayınca (`koylu_secimi.gd`) "ne duydun?" tek seçenek: köylü bildiği söylentiyi kendi ağzından söyler (YAZ-08 köy sohbeti dalı). Oyuncu iki kaynağı karşılaştırır; sistem doğruyu söylemez.
  - Kabul: duyan köylüde dal 1, duymayanda 0. Test: iki köylü.
  - Bağımlılık: YAZ-08, SOY-02. Boyut: M.
  - Dosya: yeni: `src/koy/ne_duydun.gd`; köylü seçim adaptörüne tek satır.
  - Asset: asset gerekmedi.
- [ ] **SOY-10:** Kapıda doğrulama (DYL-01 ile bağ).
  - Ne: sorguda beyan defterine (DIY-07) düşen söz, ağdaki bir kayıtla çelişiyorsa oyuncu "köyde başka duydum" diyebilir (DYL-01 çelişki yolu). Ağ kaydı `dogru=false` ise muhafız yanılır; tansiyon +1.
  - Kabul: doğru kayıtla çelişki zarsız geçer; yanlış kayıtla tansiyon +1. Test: iki kayıt.
  - Bağımlılık: DYL-01, SOY-01. Boyut: S.
  - Dosya: DYL-01 adaptörüne tek koşul.
  - Asset: asset gerekmedi.
- [ ] **SOY-11:** Yanlış söylenti doğrulanınca kaynağı düşer.
  - Ne: SOY-09/10 ile yanlış çıkan söylentinin bozan kaynağının güvenilirliği −1, doğru çıkanın +1; defter satırı yazılır.
  - Kabul: iki yön. Test: birim.
  - Bağımlılık: SOY-07, SOY-09. Boyut: S.
  - Dosya: `src/sistemler/soylenti_agi.gd`.
  - Asset: asset gerekmedi.

## 37.3 Kamuoyu — söylenti bara dönüşür

- [ ] **SOY-12:** Kamuoyu konusu.
  - Ne: aynı olay kimliğini köyün ≥ %40'ı (öneri) duyduğunda kayıt "kamuoyu konusu" olur; o andan sonra çınar meclisi (MCL-02) şikâyet olarak alabilir.
  - Kabul: eşik `data/soylenti.json`; eşik altında meclis adayı 0. Test: iki nüfus.
  - Bağımlılık: SOY-02, MCL-02. Boyut: S.
  - Dosya: `src/sistemler/soylenti_agi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SOY-13:** Kamuoyu barı oynatır, gazete oynatmaz.
  - Ne: bar değişimi (`barlar.gd`) yalnız kamuoyu konusu olunca ve bir kez: ağır olay türüne göre `bar.halk` ya da `bar.tuccarlar` −1. Gazete satırı bar değiştirmez (KOP-05 kural 2 korunur).
  - Kabul: eşik altında bar deltası 0; eşik üstünde bir kez −1. Test: simülasyon.
  - Bağımlılık: SOY-12. Boyut: S.
  - Dosya: `src/sistemler/soylenti_agi.gd` → bar adaptörü tek satır.
  - Asset: asset gerekmedi.
- [ ] **SOY-14:** Grup itibarı kamuoyuna girer (DIY-12 ile bağ).
  - Ne: kamuoyu konusu bir grubu anıyorsa (Türkmen/Rum/Ahi…) grup itibarı DIY-12 bir kez yazılır; iki kez yazılmaz (DIY-12 kural 2).
  - Kabul: aynı konu için grup yazımı 1. Test: birim.
  - Bağımlılık: DIY-12, SOY-12. Boyut: S.
  - Dosya: `src/sistemler/soylenti_agi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SOY-15:** Histeri kamuoyundan beslenir (KRI-08 ile bağ).
  - Ne: `BatilInancHisterisi` yanlış söylentileri (`dogru=false`) kamuoyu konusu olunca ek tetik sayar; histeri motoru değişmez, yalnız girdi kaynağı genişler.
  - Kabul: yanlış kamuoyu konusu histeri sayacına +1. Test: KRI-08 birimi.
  - Bağımlılık: KRI-08, SOY-05. Boyut: S.
  - Dosya: `batil_inanc_histerisi.gd` okuyucusuna tek satır.
  - Asset: asset gerekmedi.
- [ ] **SOY-16:** Kamuoyu söner.
  - Ne: kamuoyu konusu 5 gece (öneri) sonra "eski konu" olur; meclis almaz, bar değişmez, defterde kalır.
  - Kabul: 6. gece meclis adayı 0. Test: zaman makinesi.
  - Bağımlılık: SOY-12. Boyut: S.
  - Dosya: `src/sistemler/soylenti_agi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SOY-17:** Olumlu söylenti de vardır.
  - Ne: DIY-13 ağır olay listesine karşılık "iyi olay" listesi: haksızlığa karşı durma (divan), yaralıyı tedavi (CAT-03), aileyi birlikte alma. Olumlu kamuoyu `bar.halk` +1. Liste veridedir.
  - Kabul: `data/soylenti.json iyi_olaylar`; olumlu kamuoyu bir kez +1. Test: birim.
  - Bağımlılık: SOY-13. Boyut: S.
  - Dosya: `data/soylenti.json`.
  - Asset: asset gerekmedi.

## 37.4 Oyuncunun söylenti üzerindeki etkisi

- [ ] **SOY-18:** Muhafız söylenti yayabilir.
  - Ne: akşam sohbetinde (DYL-07) ya da çınarda (MCL) muhafız bir söylentiyi "doğru" ya da "yalan" diye niteleyebilir; nitelik ağa muhafız kaynaklı düğüm olarak girer; muhafızın da güvenilirliği vardır (SOY-07).
  - Kabul: muhafız düğümü kayıtta; yanlış nitelik güvenilirlik −1. Test: birim.
  - Bağımlılık: SOY-07, DYL-07. Boyut: M.
  - Dosya: `src/sistemler/soylenti_agi.gd`; DYL-07 ve MCL dalı.
  - Asset: asset gerekmedi.
- [ ] **SOY-19:** Muhafızın yalanı ağa düşer (DYL-04 ile bağ).
  - Ne: DYL-04 muhafız yalanı, tanık varsa DIY-13 kaydı açar (ağır olay listesine "muhafızın yalanı" eklenir).
  - Kabul: tanıklı yalan kayıt 1, tanıksız 0. Test: iki durum.
  - Bağımlılık: DYL-04, DIY-13. Boyut: S.
  - Dosya: DIY-13 olay listesi satırı.
  - Asset: asset gerekmedi.
- [ ] **SOY-20:** Susturma.
  - Ne: oyuncu bir kaynağa "bunu konuşma" diyebilir (SOY-09 ekranında ikinci seçenek): kaynak güvenilirliği yüksekse yayılım durur, düşükse hızlanır. Sonucu oyuncu bilmez.
  - Kabul: iki güvenilirlik düzeyinde iki sonuç. Test: birim.
  - Bağımlılık: SOY-09. Boyut: S.
  - Dosya: `src/koy/ne_duydun.gd`.
  - Asset: asset gerekmedi.
- [ ] **SOY-21:** Divan söylentiyi keser (CAS-07 ile bağ).
  - Ne: divan hükmü verilen olay için kamuoyu konusu kapanır; SAB-04 tek satırı yazılır, ağ kaydı "hükme bağlandı" olur.
  - Kabul: hüküm sonrası kamuoyu 0, SAB-04 satırı 1. Test: hüküm.
  - Bağımlılık: CAS-07, SAB-04. Boyut: S.
  - Dosya: `src/sistemler/soylenti_agi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SOY-22:** Rüşvetin söylentisi oda kasasına bakar.
  - Ne: tanıklı rüşvet (DIY-13 kural) kamuoyu olunca sancak teftişi (`sancak_teftisi.gd`) o olayı sorar; teftiş yeniden kurulmaz, soru listesine girdi.
  - Kabul: rüşvet kamuoyu + teftiş → soru 1. Test: birim.
  - Bağımlılık: SOY-12, ODA. Boyut: S.
  - Dosya: teftiş soru listesine tek satır.
  - Asset: asset gerekmedi.

## 37.5 Söz motorunda söylenti

- [ ] **SOY-23:** Bağlam sorgusunda söylenti anahtarları.
  - Ne: DIY-09 sözlüğüne `soylenti.<olay_id>.duydu`, `.dogru`, `.kaynak` anahtarları; satır seçimi "duydum ki…" dalını açar.
  - Kabul: duyan karakterde anahtar true. Test: birim.
  - Bağımlılık: DIY-09, SOY-02. Boyut: S.
  - Dosya: `src/sistemler/soylenti_agi.gd` → bağlam sözlüğü.
  - Asset: asset gerekmedi.
- [ ] **SOY-24:** Dönen karakter söylentiyi getirir.
  - Ne: DIY-11 dönen karakter köyde duyduğunu (ağ kaydı) ilk cümlesinde anabilir; söz dosyasında `soylenti` dalı.
  - Kabul: dönen + duyan → dal 1. Test: iki ziyaret.
  - Bağımlılık: DIY-11, SOY-23. Boyut: S.
  - Dosya: Söz dosyaları.
  - Asset: asset gerekmedi.
- [ ] **SOY-25:** Dış söylenti çelişir (DNY-02 kural 1).
  - Ne: iki kapı ziyaretçisi aynı dünya olayını farklı söyler; iki satır farklı `kaynak`, biri `dogru=false`. Oyuncu beyan defterinde ikisini görür.
  - Kabul: aynı olay iki satır, metinler farklı (DNY-02 kural 2). Test: iki ziyaret.
  - Bağımlılık: DNY-02, SOY-05. Boyut: S.
  - Dosya: Söz dosyaları; `soylenti_agi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SOY-26:** "Bu hatırlanacak" söylentide de çıkar (DIY-14).
  - Ne: oyuncunun seçimi ağa muhafız düğümü yazıyorsa DIY-14 notu çıkar; kural DIY-14'ündür.
  - Kabul: not bir kez. Test: birim.
  - Bağımlılık: DIY-14, SOY-18. Boyut: S.
  - Dosya: DIY-14 tetik listesi satırı.
  - Asset: asset gerekmedi.
- [ ] **SOY-27:** Söylenti satırları YAZ kotasına girer.
  - Ne: "duydum ki" satırları OZGUNLUK kotasında (YAZ-09) "dedikodu çekirdeği" türüne sayılır; kadroda ≤ %20 (öneri).
  - Kabul: kota raporu. Test: YAZ-09 denetimi.
  - Bağımlılık: YAZ-09. Boyut: S.
  - Dosya: YAZ-09 kota tablosu.
  - Asset: asset gerekmedi.

## 37.6 Görünürlük — oyuncu ağı nasıl okur

- [ ] **SOY-28:** Fısıltı gazetesi aynı kalır, kaynak sütunu eklenir.
  - Ne: sabah pusulası satırının altına küçük yazı: "duyan: Fatma" (SOY-01 `kaynak`). Satır sayısı ve kalıp değişmez.
  - Kabul: pusula satırında kaynak 1; kaynaksız kayıtta boş. Test: ekran.
  - Bağımlılık: SOY-01. Boyut: S.
  - Dosya: yeni: `src/arayuz/koy_hud/pusula_kaynak.gd`; gazete görünümüne tek satır.
  - Asset: asset gerekmedi.
- [ ] **SOY-29:** Defterde "Söylenti" sayfası.
  - Ne: Bölüm 39 defterinde canlı söylentiler: olay, kaynak, kaç kişi duydu (sayı değil kademe: birkaç / yarı köy / herkes), doğrulandı mı.
  - Kabul: sayfa ağ kaydıyla eşit. Test: defter.
  - Bağımlılık: HFZ-01, SOY-02. Boyut: S.
  - Dosya: defter adaptörü.
  - Asset: asset gerekmedi.
- [ ] **SOY-30:** Kamuoyu konusu HUD'da tek satırdır.
  - Ne: kamuoyu konusu varken köy HUD'unda tek satır "köy … konuşuyor"; tıklanınca defter sayfası.
  - Kabul: konu yokken satır 0. Test: ekran.
  - Bağımlılık: SOY-12, SOY-29. Boyut: S.
  - Dosya: yeni: `src/arayuz/koy_hud/kamuoyu_seridi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SOY-31:** Köylü üstü baloncuk yok.
  - Ne: 3B köylülerin üstünde söylenti baloncuğu çizilmez; ağ metinle okunur (Bölüm 44 sınırı).
  - Kabul: `koy/gorsel/` içinde söylenti çizimi 0. Test: tarama.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **SOY-32:** Yayılım haritası yalnız debug'da.
  - Ne: `src/debug/` panelinde ağ grafiği (kim kime, hangi gece); oyuncuya kapalı.
  - Kabul: debug kapalıyken panel 0. Test: tarama.
  - Bağımlılık: SOY-02. Boyut: S.
  - Dosya: yeni: `src/debug/soylenti_paneli.gd`.
  - Asset: asset gerekmedi.

## 37.7 Dedikodu ve köy sistemleri

- [ ] **SOY-33:** Çınar meclisi kamuoyu konusunu alır (MCL-02).
  - Ne: MCL-02 şikâyeti SOY-12 konusundan gelir; şikâyet metni kaynak adını taşır (MCL-06).
  - Kabul: kamuoyu konusu varken meclis şikâyeti onu seçer. Test: meclis.
  - Bağımlılık: MCL-02, SOY-12. Boyut: S.
  - Dosya: MCL-02 adaptörüne tek satır.
  - Asset: asset gerekmedi.
- [ ] **SOY-34:** Grev söylentiden tetiklenebilir (`meslek_grevi.gd`).
  - Ne: iş kazası ya da ücret söylentisi kamuoyu olursa meslek grevi olasılığı artar; grev motoru değişmez, girdi eklenir.
  - Kabul: kamuoyu + meslek eşleşmesi → grev olasılığı +0.1 (öneri). Test: birim.
  - Bağımlılık: SOY-12. Boyut: S.
  - Dosya: grev okuyucusuna tek satır.
  - Asset: asset gerekmedi.
- [ ] **SOY-35:** Husumet söylentiyle büyür (`husumet.gd`, `kan_davasi.gd`).
  - Ne: iki köylü arasındaki husumet, biri diğeri hakkında yanlış söylenti yaydığında +1; kan davası eşiği değişmez.
  - Kabul: yanlış söylenti kaynağı ve hedefi → husumet +1. Test: birim.
  - Bağımlılık: SOY-05. Boyut: S.
  - Dosya: husumet okuyucusuna tek satır.
  - Asset: asset gerekmedi.
- [ ] **SOY-36:** Pazar fiyatı söylentiye tepki verir (`ticaret_fiyatlari.gd`).
  - Ne: "kervan gelmeyecek" türü dış söylenti kamuoyu olunca pazar fiyat çarpanı bir gün +%10 (öneri); yanlışsa ertesi gün düzelir. Fiyat motoru değişmez.
  - Kabul: çarpan bir gün; DEN tablosunda. Test: birim.
  - Bağımlılık: SOY-12, DEN-01. Boyut: S.
  - Dosya: fiyat okuyucusuna tek satır; `denge.json`.
  - Asset: asset gerekmedi.
- [ ] **SOY-37:** Göç söylentisi (`goc_yolu_guvenligi.gd`).
  - Ne: "yol güvensiz" söylentisi kamuoyu olunca kapıya gelen sayısı o gece −1 (öneri); doğruysa ertesi gün de.
  - Kabul: gelen sayısı −1. Test: birim.
  - Bağımlılık: SOY-12. Boyut: S.
  - Dosya: kuyruk adaptörüne tek satır.
  - Asset: asset gerekmedi.

## 37.8 Veri ve ölçüm

- [ ] **SOY-38:** Ağ sayıları tek dosyadadır.
  - Ne: yayılım hızı, bozulma oranı, kamuoyu eşiği, ömür, bar etkisi `data/soylenti.json`; DEN-01 tablosu bu dosyayı okur.
  - Kabul: `.gd` içinde sayı sabiti 0. Test: tarama.
  - Bağımlılık: DEN-01. Boyut: S.
  - Dosya: yeni: `data/soylenti.json`.
  - Asset: asset gerekmedi.
- [ ] **SOY-39:** Söylenti yoğunluğu ölçülür.
  - Ne: 30 gecelik koşuda gece başına canlı söylenti sayısı, kamuoyu konusu sayısı, yanlış oranı raporlanır; hedef canlı ≤ 3, kamuoyu ≤ 1 (öneri).
  - Kabul: rapor DEN raporunun satırıdır. Test: runner.
  - Bağımlılık: DEN-05. Boyut: S.
  - Dosya: `tools/python_test_runner.py`.
  - Asset: asset gerekmedi.
- [ ] **SOY-40:** Küçük köyde ağ susar.
  - Ne: nüfus < 5 iken yayılım yoktur (duyan = tanık); kamuoyu konusu olmaz. BUG-16 ön koşul kuralı burada da geçerlidir.
  - Kabul: nüfus 4'te kamuoyu 0. Test: birim.
  - Bağımlılık: BUG-16. Boyut: S.
  - Dosya: `src/sistemler/soylenti_agi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SOY-41:** İkiz koşu.
  - Ne: aynı tohumla iki koşuda yayılım günlüğü eşit (RNG tek kaynaktan, `_rng_donus` kalıbı).
  - Kabul: iki günlük eşit. Test: TST-06.
  - Bağımlılık: TST-06. Boyut: S.
  - Dosya: yeni: `tests/oto/soylenti_ikiz_kontrol.tscn`.
  - Asset: asset gerekmedi.
- [ ] **SOY-42:** Kayıt göçü.
  - Ne: ağ alanları optional; eski kayıt açılınca DIY-13 kayıtları kaynaksız sayılır, ağ sıfırdan başlar; oyun çökmez.
  - Kabul: eski kayıt KAY testi. Test: KAY zinciri.
  - Bağımlılık: KAY-04. Boyut: S.
  - Dosya: `src/sistemler/soylenti_agi.gd` `yukle`.
  - Asset: asset gerekmedi.

## 37.9 Yazım

- [ ] **SOY-43:** "Duydum ki" kalıpları şablon dilbilgisidir (YAZ-09).
  - Ne: söylenti satırı şablonu `{kaynak} dedi, {olay}` değil; her karakter kendi ağzından söyler, şablon yalnız olay alanlarını doldurur. USLUP §1 yapay kalıp listesi geçerlidir.
  - Kabul: aynı olay için iki karakterde iki farklı cümle yapısı. Test: inceleme.
  - Bağımlılık: YAZ-09. Boyut: S.
  - Dosya: Söz dosyaları.
  - Asset: asset gerekmedi.
- [ ] **SOY-44:** Yanlış söylentinin bozulma biçimi yazılıdır.
  - Ne: SOY-05 bozulması üç biçimden biri: ad kayması, yer kayması, abartı; her biçimin metin kalıbı `fisilti_gazetesi.json` kalıplarına paralel.
  - Kabul: üç biçim üç kalıp. Test: birim.
  - Bağımlılık: SOY-05. Boyut: S.
  - Dosya: `data/soylenti.json` kalıpları.
  - Asset: asset gerekmedi.
- [ ] **SOY-45:** Kaynak adı yalnız köyde var olan kişidir (BUG-17 ile aynı kural).
  - Ne: `kaynak` köy listesinde yoksa satır basılmaz; uydurma ad yok.
  - Kabul: ölen kaynaklı satır 0. Test: birim.
  - Bağımlılık: BUG-17. Boyut: S.
  - Dosya: `src/sistemler/soylenti_agi.gd`.
  - Asset: asset gerekmedi.
- [ ] **SOY-46:** Köy sohbeti söylentiyi okur (YAZ-08).
  - Ne: YAZ-08 köylü sohbetleri canlı söylentiyi konu alabilir; iki köylü aynı olayı farklı söyler (DNY-02 kuralı).
  - Kabul: sohbette söylenti konusu varken iki satır farklı. Test: inceleme.
  - Bağımlılık: YAZ-08. Boyut: S.
  - Dosya: YAZ-08 konu tablosu.
  - Asset: asset gerekmedi.

## 37.10 Sınırlar ve kapanış

- [ ] **SOY-47:** Gazete ve dedikodu motoru değişmez.
  - Ne: `fisilti_gazetesi.gd`, `dedikodu.gd`, `batil_inanc_histerisi.gd` imzaları aynı; ağ onların kaydını okur, alan ekler.
  - Kabul: `api_sozlesmesi.py` farkı 0. Test: araç.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `tools/api_sozlesmesi_baseline.json`.
  - Asset: asset gerekmedi.
- [ ] **SOY-48:** İkinci dedikodu kaydı yoktur.
  - Ne: ağ, DIY-13 kaydını genişletir; ayrı `soylenti` kaydı tutmaz.
  - Kabul: kayıt JSON'unda iki ayrı dedikodu listesi 0. Test: tarama.
  - Bağımlılık: SOY-01. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **SOY-49:** Söylenti seslendirilmez, baloncuk çizilmez.
  - Ne: ses dosyası ve 3B baloncuk yok (SOY-31).
  - Kabul: `assets/ses/` sayısı değişmez. Test: sayım.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **SOY-50:** Kapanış testi.
  - Ne: tek koşu: tanıklı rüşvet → 3 gece yayılım → kamuoyu → bar −1 bir kez → meclis şikâyeti → divan hükmü → kamuoyu 0; yanlış kopya → kaynak güvenilirliği −1.
  - Kabul: yedi adım tek testte. Test: `tests/unit/kvr/soylenti_agi_test.gd`.
  - Bağımlılık: SOY-01…49. Boyut: M.
  - Dosya: yeni: `tests/unit/kvr/soylenti_agi_test.gd`.
  - Asset: asset gerekmedi.

Alt başlıklarda madde sayısı dört ile altı arasındadır; onuncu madde her yerde DIY-13 ya da KOP-05'te duran bir kuralı ikinci kez yazacağı için konmadı. Toplam 50 madde.
