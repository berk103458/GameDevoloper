# BÖLÜM 34 — Ana hikâye omurgası ve perde yapısı

Faz 5 (DNY ile birlikte; KOP-07 ve YAZ-06 metinlerinden sonra). Zemin, kodda duran iki perde ve beş sondur:

- Perde geçişi SYS-19: `src/koy/perde_gecisi.gd` — nüfus `agalik_nufus` (18, `data/ayarlar/oyun.tres oturma_esigi`) olunca "Köy oturdu", 2. perde kendi sayacını tutar, `perde2_hedef_gece` (12) dolunca `SON_ZAFER`. Perde 2'de gelen sayısı `perde2_gece_basina_gelen` (2).
- Beş son SYS-20: `src/sistemler/nihai_son.gd` — zafer beş sona ayrılır: `tekfur_haraccisi`, `ertugrul_obasi`, `beyin_uc_koyu`, `ahi_kasabasi`, `uc_tutundu`; kayıp sonları `isyan`, `tekfur`, `halk_kirildi`, `azil`, `idam` korunur. Göstergeler huzur/adalet/refah/güvenlik/nüfus/yozlaşma 0–100; eşikler `data/nihai_sonlar.json`. Epilog `muhafiz_epilogu.gd`, sunum `src/arayuz/muhafiz_epilogu_sunumu.gd`, kadraj `bilgi_ekrani.gd`.
- Dış dünya hatları: Moğol öncüsü `mogol_oncusu.gd`, tekfur haraç heyeti `tekfur_harac_heyeti.gd`, oba ittifakı `oba_ittifaki.gd`, sancak fermanı `sancak_asker_talebi.gd` (gece 8, aralık 12), haberci ağı `haberci_agi.gd` (HAR-09), olaylar `data/olaylar/` (ertugrul_haberi, nogay_haber, mogol_duman, tekfur_elcisi, bey_daveti, aydogdu_oba, miraen_cavus, sorhan_damga, thessra_afyon).

Bu bölüm perdeyi, sonu ve dış hatları yeniden kurmaz. Onları bir omurgaya dizer: oyuncu neyin ne zaman gelmekte olduğunu hisseder, her sonun yolu önceden okunur, her hat bir yüzle gelir. Mevsim izi Bölüm 30'dadır (YIL), buraya girmez. Dünya zaman çizelgesi DNY-01'dedir; bu bölüm ona perde ve son bağlar. Metinlerin ağzı KOP-07'dedir; burada metin yazılmaz.

Kimlikler OMR-01 … OMR-55. Kalp puanı, romans, ikinci harita, seslendirme yok. Asset üretilmez. Yeni dosya + ince adaptör; çekirdek dosya (`oturum.gd`, `koy_yonetim_sahnesi.gd`) değişmez. Bitince `[x]` ve ajan adı.

**Madde biçimi:** Ne, Kabul, Bağımlılık + Boyut, Dosya, Asset.

---

## 34.1 Omurga belgesi — üç perde, bir kapı

- [ ] **OMR-01:** Omurga tek belgede durur.
  - Ne: perde 1 (kapı açılır, köy kurulur, 18 nüfus), perde 2 (ağalık, 12 gece, dış baskı) ve kapanış (beş son) tek belgede; her perdenin sorusu, baskısı ve kapanış koşulu kod referansıyla yazılır.
  - Kabul: belgede `perde_gecisi.gd`, `nihai_son.gd`, `oyun.tres` alanları adlarıyla geçer; kodda olmayan koşul yoktur. Test: insan okuması + referans taraması.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: yeni: `design/omurga.md` (oyun deposunda, uygulama fazında).
  - Asset: asset gerekmedi.
- [ ] **OMR-02:** Perde 1'in üç dönemi.
  - Ne: perde 1 üç döneme bölünür: kuruluş (nüfus < 8), yerleşme (8–13), oturma (14–18). Dönem, mevcut nüfustan türetilir; yeni sayaç yoktur.
  - Kabul: `donem(y)` fonksiyonu nüfustan üç değer döner; kayda yazılmaz. Test: üç nüfus değeri.
  - Bağımlılık: OMR-01. Boyut: S.
  - Dosya: yeni: `src/sistemler/omurga.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-03:** Dönem, gelen kadroyu süzer.
  - Ne: `karakter_kadrosu.gd uygunlar(gece)` çağrısına dönem bilgisi eklenir: kuruluşta aile ve zanaatkâr ağırlıklı, oturmada tüccar, heyet ve tehdit. Karar matrisi (KOP-10) değişmez, yalnız aday havuzu daralır.
  - Kabul: `data/omurga.json` içinde dönem → sınıf ağırlığı; kuruluşta asker ağırlığı ≤ 0.1. Test: 100 gece simülasyon dağılımı.
  - Bağımlılık: OMR-02, KOP-10. Boyut: M.
  - Dosya: yeni: `src/sistemler/omurga_suzgeci.gd`; `karakter_kadrosu.gd` çağıran tarafa tek satır (çekirdek değil).
  - Asset: asset gerekmedi.
- [ ] **OMR-04:** Perde 2'nin üç dalgası.
  - Ne: 12 gecelik perde 2 üç dalgaya bölünür (4+4+4): baskı gelir, baskı sıkışır, kapanış. Dalga `perde_gecisi.gece(y)` değerinden türetilir.
  - Kabul: `dalga(y)` 1/2/3 döner; `perde2_hedef_gece` değişince dalga sınırları oranla kayar. Test: hedef 12 ve 15'te sınırlar.
  - Bağımlılık: OMR-01. Boyut: S.
  - Dosya: `src/sistemler/omurga.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-05:** Dış hatlar dalgaya bağlanır.
  - Ne: Moğol öncüsü, tekfur heyeti, oba ittifakı ve ferman tetikleri dalga numarasını okur; dalga 1'de yalnız haber, dalga 2'de talep, dalga 3'te sonuç. Hatların kendi aralığı (`harac_araligi`, ferman 12) korunur, dalga yalnız ön koşuldur.
  - Kabul: dalga 1'de tekfur talebi 0, haberi ≥ 1. Test: zaman makinesiyle üç dalga.
  - Bağımlılık: OMR-04, HAR-09. Boyut: M.
  - Dosya: yeni: `src/sistemler/dis_hat_kapisi.gd`; dört hat dosyasına birer satır.
  - Asset: asset gerekmedi.
- [ ] **OMR-06:** Omurga kayda yazmaz.
  - Ne: dönem ve dalga türetilmiş değerdir; kayıt alanı yoktur. Eski kayıt açılınca aynı dönem hesaplanır.
  - Kabul: `omurga.gd` içinde `kaydet/yukle` yoktur. Test: tarama.
  - Bağımlılık: OMR-02, OMR-04. Boyut: S.
  - Dosya: `src/sistemler/omurga.gd`.
  - Asset: asset gerekmedi.

## 34.2 Perde geçişi sahnesi

- [ ] **OMR-07:** "Köy oturdu" kadrajı tek ağızdan.
  - Ne: `perde_gecisi.olay_metin` sabit Türkçe metni (`"Köy oturdu · 2. perde başladı…"`) `metinler.csv` anahtarına taşınır; metin KOP-07 ağzıyla yeniden yazılır. Fonksiyon imzası değişmez.
  - Kabul: `perde_gecisi.gd` içinde sabit cümle 0; anahtar `anlati.perde.basladi`. Test: tarama + ekran.
  - Bağımlılık: KOP-07. Boyut: S.
  - Dosya: yeni: `src/sistemler/perde_metni.gd`; `perde_gecisi.gd` tek satır.
  - Asset: asset gerekmedi.
- [ ] **OMR-08:** Geçiş gecesinde kapı kapalıdır.
  - Ne: "Köy oturdu" gecesi kapıya kimse gelmez (KAP-16 boş gün zorlanır); oyuncu köyde ağalık kararını verir.
  - Kabul: geçiş gecesi `gece_basina_gelen` 0. Test: nüfus 18'e enjekte, o gece kuyruk boş.
  - Bağımlılık: KAP-16. Boyut: S.
  - Dosya: yeni: `src/sistemler/gecis_gecesi.gd`; kuyruk üreticisine tek satır.
  - Asset: asset gerekmedi.
- [ ] **OMR-09:** Geçişte eş ve çınar konuşur.
  - Ne: geçiş akşamı eş (DYL-07) ve çınar meclisi (MCL) "ağalık" konusunu alır; iki ayrı sahne değil, mevcut akşam sohbeti ve meclis dalıdır.
  - Kabul: Söz dosyasında `perde_gecisi` bağlam anahtarı (DIY-09). Test: bağlam açıkken dal 1.
  - Bağımlılık: DYL-07, MCL-01, DIY-09. Boyut: S.
  - Dosya: eş ve meclis söz dosyaları (YAZ-06 kapsamı) dal satırı.
  - Asset: asset gerekmedi.
- [ ] **OMR-10:** Geçiş kadrajında köyün özeti.
  - Ne: `bilgi_ekrani.gd` kadrajında perde 1 özeti: gün, gelen, kabul, ret, ölü, en çok anılan karar (Bölüm 39 defterinden). Resim yok.
  - Kabul: altı satır, hepsi kayıttan. Test: anlık görüntü.
  - Bağımlılık: HFZ-01. Boyut: S.
  - Dosya: yeni: `src/arayuz/perde_ozeti.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-11:** Geçiş sonrası ilk gün ipucu almaz.
  - Ne: perde 2'nin ilk günü Bölüm 33 ipucu sistemi susar; oyuncu deneyimlidir.
  - Kabul: `ilk_saat.json` kavramlarının hiçbiri perde 2'de tetiklenmez. Test: geçiş sonrası altı gece ipucu 0.
  - Bağımlılık: OGR-01. Boyut: S.
  - Dosya: `src/sistemler/ilk_saat.gd` tek koşul.
  - Asset: asset gerekmedi.
- [ ] **OMR-12:** Geçiş geri alınmaz, kayıt geçişi korur.
  - Ne: `perde_gecisi.yukle` legacy davranışı (alan yoksa sonraki gece başlar) belgelenir ve test edilir; omurga buna dokunmaz.
  - Kabul: `tests/unit/kvr/` mevcut perde testi referansla belgede. Test: var olan test geçer.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `design/omurga.md` referans satırı.
  - Asset: asset gerekmedi.

## 34.3 Beş sonun yolu görünür olur

- [ ] **OMR-13:** Son göstergeleri oda ekranında okunur.
  - Ne: `nihai_son.gostergeler(o)` altı değeri perde 2'de muhafız odası terazisi panelinde (`oda_terazisi_paneli.gd` yanında) görünür. Perde 1'de gizlidir.
  - Kabul: perde 2'de altı satır; sayı yerine kademe sözcüğü (`_kademe`: düşük/orta/yüksek). Test: anlık görüntü.
  - Bağımlılık: OMR-04. Boyut: S.
  - Dosya: yeni: `src/arayuz/oda_gidisat_paneli.gd`; `muhafiz_odasi_ekrani.gd` tek satır.
  - Asset: asset gerekmedi.
- [ ] **OMR-14:** Hangi sona yaklaşıldığı tek cümleyle söylenir.
  - Ne: `nihai_son.son(o, &"zafer")` sonucu perde 2 dalga 2'den itibaren oda panelinde "şu an gidişat: …" cümlesiyle görünür. Sayı yok, ad var.
  - Kabul: cümle `nihai_sonlar.json sonlar[n].baslik` ile aynı adı taşır. Test: beş son için beş cümle.
  - Bağımlılık: OMR-13. Boyut: S.
  - Dosya: `src/arayuz/oda_gidisat_paneli.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-15:** Her sonun bir yüzü vardır.
  - Ne: beş sonun her biri bir adlı karakterle anılır: tekfur haraççısı → tekfur elçisi (`tekfur_elcisi.tres`), Ertuğrul obası → Aydoğdu (`aydogdu_oba.tres`), beyin uç köyü → ulak (ACL-04), ahi kasabası → ahi (`ahi_haber.tres`), uç tutundu → eş. Yüz, dalga 2'de kapıya ya da köye gelir ve o sonun koşulunu kendi ağzından söyler (Söz motoru).
  - Kabul: beş yüz için beş Söz dosyası dalı; koşul metni `nihai_sonlar.json esik` değerleriyle çelişmez. Test: yazım hattı denetimi (KLT).
  - Bağımlılık: OMR-05, YAZ-06. Boyut: M.
  - Dosya: Söz dosyaları; `data/omurga.json` yüz eşlemesi.
  - Asset: asset gerekmedi.
- [ ] **OMR-16:** Kayıp sonları erken uyarır.
  - Ne: `isyan`, `tekfur`, `halk_kirildi`, `azil`, `idam` sonlarının her birinin eşiğine iki gece kala haberci ağı (HAR-09) bir satır düşürür. Eşik değişmez.
  - Kabul: her kayıp sonu için bir uyarı anahtarı; uyarı eşikten önce. Test: beş kayıp yolu zaman makinesiyle.
  - Bağımlılık: HAR-09. Boyut: M.
  - Dosya: yeni: `src/sistemler/son_uyarisi.gd`; `haberci_agi.gd` tek satır.
  - Asset: asset gerekmedi.
- [ ] **OMR-17:** Sonun seçildiği an kayda yazılır.
  - Ne: `son_metni` dönüşündeki `nihai` alanı oyun kaydına ve Bölüm 39 defterine yazılır; epilog sonradan yeniden okunabilir.
  - Kabul: kayıt alanı `son.nihai`; eski kayıtta yoksa boş. Test: KAY zinciri.
  - Bağımlılık: KAY-04, HFZ-01. Boyut: S.
  - Dosya: yeni: `src/sistemler/son_kaydi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-18:** Beş son beş farklı kadraj değil, bir kadraj beş metindir.
  - Ne: `muhafiz_epilogu_sunumu.gd` tek kadraj kalır; görsel çeşitleme yok. Metin KOP-07 ağzıyla.
  - Kabul: sunum dosyasında son başına görsel dalı 0. Test: tarama.
  - Bağımlılık: KOP-07. Boyut: S.
  - Dosya: `src/arayuz/muhafiz_epilogu_sunumu.gd` (değişmez; madde sınır koyar).
  - Asset: asset gerekmedi.

## 34.4 Dış hatların yüzleri

- [ ] **OMR-19:** Moğol hattı üç adımdır: duman, haber, öncü.
  - Ne: `mogol_duman.tres` (olay) → `nogay_haber.tres` → `mogol_oncusu.gd`; üç adım dalga 1/2/3'e bağlanır. Öncü kapıya gelirse Söz motoru sahnesi (KOP-02 heyet biçimi).
  - Kabul: üç adım sırası bozulmaz; adım atlanırsa sonraki tetiklenmez. Test: dalga sırası.
  - Bağımlılık: OMR-05. Boyut: S.
  - Dosya: `src/sistemler/dis_hat_kapisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-20:** Tekfur hattı: elçi, haraç, heyet.
  - Ne: `tekfur_elcisi.tres` → `tekfur_harac_heyeti.gd` → `tekfur_heyeti_paneli.gd`. Elçi kapıda konuşur (KOP-02); haraç kararı divan değil muhafızındır (CAS-07 dışı).
  - Kabul: elçi gelmeden haraç talebi 0. Test: dalga sırası.
  - Bağımlılık: OMR-05, KOP-02. Boyut: S.
  - Dosya: `src/sistemler/dis_hat_kapisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-21:** Oba hattı: Aydoğdu iki kez gelir.
  - Ne: `aydogdu_oba.tres` ve `oba_ittifaki.gd`; Aydoğdu ilk gelişte tanışır, ikincide ittifak ister. İki geliş arası ≥ 4 gece (öneri). Kişi hafızası (DIY-11) ikinci gelişi tanır.
  - Kabul: ikinci gelişte `durumlar[id].ziyaret` ≥ 1. Test: iki ziyaret.
  - Bağımlılık: DIY-11, OMR-05. Boyut: S.
  - Dosya: `src/sistemler/dis_hat_kapisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-22:** Sancak hattı: ulak döner.
  - Ne: ACL-04 ulağı `sancak_asker_talebi.gd` fermanını (gece 8) ve `sancak_teftisi.gd` teftişini kapıda bizzat getirir; yazılı haber yerine yüz.
  - Kabul: ferman gecesi ulak kuyrukta 1. Test: gece 8 kuyruğu.
  - Bağımlılık: ACL-04, OMR-05. Boyut: S.
  - Dosya: `src/sistemler/dis_hat_kapisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-23:** Ahi hattı: tezgâhtan kasabaya.
  - Ne: `ahi_haber.tres` ve `ahi_kasabasi` sonu; ahi, TEZ (Bölüm 29) teslimlerini ve refah/adalet göstergesini okur, dalga 2'de köye gelir.
  - Kabul: TEZ teslim sayısı ≥ 1 değilse ahi gelmez. Test: iki kayıt.
  - Bağımlılık: TEZ-08, OMR-05. Boyut: S.
  - Dosya: `src/sistemler/dis_hat_kapisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-24:** Hatlar aynı gece çakışmaz.
  - Ne: bir gecede en çok bir dış hat yüzü gelir; öncelik sırası `data/omurga.json`'da (sancak > tekfur > Moğol > oba > ahi).
  - Kabul: aynı gece iki hat yüzü 0. Test: hepsi uygunken bir gece.
  - Bağımlılık: OMR-19…23. Boyut: S.
  - Dosya: `src/sistemler/dis_hat_kapisi.gd`.
  - Asset: asset gerekmedi.

## 34.5 Oyuncunun kararı omurgayı büker

- [ ] **OMR-25:** Üç karar üç hattı kapatır.
  - Ne: tekfur elçisini reddetmek tekfur hattını sertleştirir, Moğol öncüsünü kabul etmek haraççı yolunu açar, ulağı aldatmak sancak hattını kapatır. Bu etkiler mevcut bar ve bayraklarla olur, yeni sayaç yok.
  - Kabul: üç karar → üç bayrak; bayrak `atil_bayraklar.json` zincirine uyar. Test: üç kayıt.
  - Bağımlılık: OMR-19…22. Boyut: M.
  - Dosya: `src/sistemler/dis_hat_kapisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-26:** Kapatılan hat sona yansır.
  - Ne: hat kapanınca `nihai_son.son` öncelik sırası değişmez ama koşul sağlanamaz hale gelir; oyuncu oda panelinde (OMR-14) gidişat değişimini görür.
  - Kabul: hat kapatıldıktan sonra panel cümlesi değişir. Test: önce/sonra.
  - Bağımlılık: OMR-14, OMR-25. Boyut: S.
  - Dosya: `src/arayuz/oda_gidisat_paneli.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-27:** Divan hükmü omurgaya dokunur.
  - Ne: CAS-07 infaz ve sürgün sayısı adalet göstergesini (`y.adalet`) etkiler; bu zaten koddadır. Madde, bu etkinin SAB (Bölüm 28) sabah satırında anılmasını ister.
  - Kabul: SAB-01 satırında adalet değişimi tek kelime. Test: hüküm sonrası satır.
  - Bağımlılık: SAB-01. Boyut: S.
  - Dosya: `src/koy/sabah_defteri.gd` tek alan.
  - Asset: asset gerekmedi.
- [ ] **OMR-28:** Yozlaşma eşiği omurgada görünür.
  - Ne: `nihai_sonlar.json esik.yozlasma` eşiğine üç kademe kala oda vicdan paneli (`oda_vicdan_paneli.gd`) bir satır düşürür.
  - Kabul: uyarı eşikten önce; eşik değişmez. Test: terazi enjeksiyonu (`stat_enjektoru.gd`).
  - Bağımlılık: ODA-12. Boyut: S.
  - Dosya: yeni: `src/arayuz/oda_yozlasma_uyarisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-29:** Verilen söz omurgaya girer.
  - Ne: DYL-05 verilen sözlerden dış hat yüzlerine verilenler (`"Aydoğdu'ya söz"`) `data/omurga.json`'da hat koşulu olarak okunur; tutulmayan söz hattı kapatır.
  - Kabul: söz tutulmadı → ilgili hat bayrağı. Test: iki kayıt.
  - Bağımlılık: DYL-05, OMR-25. Boyut: S.
  - Dosya: `src/sistemler/dis_hat_kapisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-30:** Omurga oyuncuyu zorlamaz.
  - Ne: hiçbir hat zorunlu değildir; hepsi reddedilirse `uc_tutundu` yolu açık kalır. Bu, `nihai_son.son` son satırının (varsayılan dönüş) belgelenmesidir.
  - Kabul: dört hat kapalı, yozlaşma düşük → son `uc_tutundu`. Test: kayıt.
  - Bağımlılık: OMR-25. Boyut: S.
  - Dosya: `design/omurga.md`.
  - Asset: asset gerekmedi.

## 34.6 Zamanlama ve tempo

- [ ] **OMR-31:** Perde 1 hedef süresi ölçülür.
  - Ne: 18 nüfusa ulaşma gecesi otomatik oyuncuyla ölçülür; hedef 20–30 gece (öneri). Sapınca `gece_basina_gelen` değil kabul oranı ve omurga süzgeci (OMR-03) oynar.
  - Kabul: ölçüm raporda, DEN tablosuyla paylaşılır. Test: runner.
  - Bağımlılık: DEN-05, OMR-03. Boyut: S.
  - Dosya: `tools/python_test_runner.py` satırı.
  - Asset: asset gerekmedi.
- [ ] **OMR-32:** Dalga başına en az bir yüz.
  - Ne: perde 2'nin her dalgasında en az bir dış hat yüzü gelir; hiçbiri uygun değilse ulak gelir.
  - Kabul: üç dalgada yüz sayısı ≥ 3. Test: hatları kapatılmış kayıt.
  - Bağımlılık: OMR-24. Boyut: S.
  - Dosya: `src/sistemler/dis_hat_kapisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-33:** Boş gün oranı perdeye göre değişir.
  - Ne: KAP-16 boş gün olasılığı perde 1 oturma döneminde artar, perde 2 dalga 3'te sıfırlanır. Değer `data/omurga.json`'dadır.
  - Kabul: dalga 3'te boş gün 0. Test: 12 gece.
  - Bağımlılık: KAP-16, OMR-04. Boyut: S.
  - Dosya: `data/omurga.json`; KAP-16 okuyucusuna tek satır.
  - Asset: asset gerekmedi.
- [ ] **OMR-34:** Mevsim omurgayı bağlamaz.
  - Ne: perde geçişi mevsime bağlı değildir (Bölüm 30 ayrı). Madde yalnız sınır koyar: `omurga.gd` `takvim.gd`'yi okumaz.
  - Kabul: `omurga.gd` içinde `Takvim` 0. Test: tarama.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `src/sistemler/omurga.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-35:** Tempo ölçümü ikizle doğrulanır.
  - Ne: aynı tohumla iki koşuda dönem/dalga geçiş geceleri eşittir.
  - Kabul: iki günlük eşit. Test: TST-06 ikizi.
  - Bağımlılık: TST-06. Boyut: S.
  - Dosya: yeni: `tests/oto/omurga_ikiz_kontrol.tscn`.
  - Asset: asset gerekmedi.

## 34.7 Haberci ağı omurgaya bağlanır

- [ ] **OMR-36:** Haber dalgayı önceler.
  - Ne: `haberci_agi.gd` her dış hat yüzünden 1–2 gece önce yazılı haber düşürür (kaynaklar `data/haberci_agi.json kaynaklar`). Yüz gelmeden haber gelir.
  - Kabul: yüz gecesi − haber gecesi ∈ {1, 2}. Test: dört hat.
  - Bağımlılık: OMR-05, HAR-09. Boyut: S.
  - Dosya: `src/sistemler/dis_hat_kapisi.gd` → `haberci_agi.gd` tek satır.
  - Asset: asset gerekmedi.
- [ ] **OMR-37:** Haber önce insandan duyulur (DNY-02 ile aynı kural).
  - Ne: haber kapıdaki bir kişinin ağzından da gelebilir (DIY-13 dedikodu); yazılı haber yalnız kimse söylemediyse düşer.
  - Kabul: bir ziyaretçi haberi söylediyse yazılı satır 0. Test: iki kayıt.
  - Bağımlılık: DNY-02, DIY-13. Boyut: S.
  - Dosya: `src/sistemler/dis_hat_kapisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-38:** Haber defteri Bölüm 39'a yazar.
  - Ne: haberci ağının `bekleyen` listesi hafıza defterinin "Haber" sayfasına geçer; `azami_metin` sınırı korunur.
  - Kabul: defter sayfası ile `haberci_agi.oku` listesi eşit. Test: karşılaştırma.
  - Bağımlılık: HFZ-01. Boyut: S.
  - Dosya: `src/arayuz/hafiza_defteri.gd` sayfa adaptörü.
  - Asset: asset gerekmedi.
- [ ] **OMR-39:** Sahte haber hat kapatmaz.
  - Ne: DIY-13 dedikodusu yanlış olabilir; omurga yalnız `haberci_agi` kaynaklı doğrulanmış haberi okur. Oyuncu farkı Bölüm 37'de görür.
  - Kabul: dedikodu bayrağı dış hat kapısını tetiklemez. Test: sahte dedikodu enjeksiyonu.
  - Bağımlılık: SOY-01. Boyut: S.
  - Dosya: `src/sistemler/dis_hat_kapisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-40:** Haber metni KOP-07 ağzındadır.
  - Ne: `mogol_oncusu.olay_metin` ve benzeri sabit metinler `metinler.csv`'ye taşınır; ağız aynı yazardadır. İmzalar değişmez.
  - Kabul: dört hat dosyasında sabit Türkçe cümle 0. Test: tarama.
  - Bağımlılık: KOP-07, OMR-07. Boyut: M.
  - Dosya: yeni: `src/sistemler/hat_metni.gd`; dört dosyaya birer satır.
  - Asset: asset gerekmedi.

## 34.8 Omurga ve köy sistemleri

- [ ] **OMR-41:** Krizler dalgaya göre sıklaşır.
  - Ne: KRI kriz tetik olasılığı (`data/koy/kriz_kenetlenmesi.json` ve ilgili) perde 2 dalga 2'de çarpanla artar; çarpan DEN tablosundadır.
  - Kabul: `denge.json` içinde `kriz_dalga_carpani`. Test: DEN-01 tablosu.
  - Bağımlılık: DEN-01, OMR-04. Boyut: S.
  - Dosya: `data/ayarlar/denge.json`.
  - Asset: asset gerekmedi.
- [ ] **OMR-42:** Nüfus 18 öncesi savaş yok.
  - Ne: BUG-18 tehdit alışma süresine ek olarak kurt baskını dışındaki saldırı hatları (çete, pusucu) oturma dönemine (nüfus ≥ 14) kadar gelmez.
  - Kabul: nüfus < 14 iken çete 0. Test: enjekte nüfus.
  - Bağımlılık: BUG-18, OMR-02. Boyut: S.
  - Dosya: `src/sistemler/omurga_suzgeci.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-43:** Perde 2'de ambar baskısı artar.
  - Ne: perde 2 gelen sayısı düşer (2) ama hane büyür; tüketim `tuketim_dengesi.json` değişmez, köy olayları (KRI) sıklaşır (OMR-41). Madde bu ilişkiyi DEN raporunda ölçer.
  - Kabul: perde 2 ortalama ambar eğimi raporda. Test: runner.
  - Bağımlılık: DEN-05. Boyut: S.
  - Dosya: `tools/python_test_runner.py`.
  - Asset: asset gerekmedi.
- [ ] **OMR-44:** Çınar meclisi perde 2'de her hafta toplanır.
  - Ne: MCL-05 "her gece açılmaz" kuralına perde 2 istisnası: `takvim.hafta_basi` gecelerinde meclis açılır ve dış hat konusu konuşulur.
  - Kabul: perde 2 hafta başı meclis 1. Test: 12 gece.
  - Bağımlılık: MCL-05, OMR-04. Boyut: S.
  - Dosya: MCL-05 dosyasına tek koşul.
  - Asset: asset gerekmedi.
- [ ] **OMR-45:** Nöbet devri perde 2'de zorunludur.
  - Ne: NBT (Bölüm 26) nöbetçi atanmadan perde 2 gecesi geçmez; boş direk (NBT-08) perde 2'de bir uyarı satırı alır.
  - Kabul: perde 2 boş direk gecesinde uyarı 1. Test: kayıt.
  - Bağımlılık: NBT-08. Boyut: S.
  - Dosya: NBT-08 dosyasına tek satır.
  - Asset: asset gerekmedi.

## 34.9 Yeniden oynanabilirlik

- [ ] **OMR-46:** Beş son beş farklı ilk aile değildir.
  - Ne: açılış (ACL-04) sabittir; omurga dallanması oyuncunun kararlarındadır. Madde sınır koyar: `omurga.json` açılışı okumaz.
  - Kabul: tarama. Test: tarama.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `design/omurga.md`.
  - Asset: asset gerekmedi.
- [ ] **OMR-47:** Alınan son kaydı ikinci oyunda hatırlanır.
  - Ne: `oyuncu_izi.cfg` (OGR-47) içine alınan sonlar yazılır; yeni oyun ekranında "daha önce: …" satırı. Başarım değil, iz.
  - Kabul: beş sondan alınanlar listelenir. Test: iki oyun.
  - Bağımlılık: OGR-47, OMR-17. Boyut: S.
  - Dosya: `src/sistemler/oyuncu_izi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-48:** Alınmamış sona ipucu, yol tarifi değil.
  - Ne: ikinci oyunda oda gidişat paneli (OMR-14) alınmamış sonları soluk gösterir; koşul yazmaz.
  - Kabul: panelde alınmamış son adı soluk, koşul metni 0. Test: anlık görüntü.
  - Bağımlılık: OMR-47. Boyut: S.
  - Dosya: `src/arayuz/oda_gidisat_paneli.gd`.
  - Asset: asset gerekmedi.
- [ ] **OMR-49:** Muhafızın geçmişi hat yüzlerinin ilk cümlesini değiştirir.
  - Ne: ACL-06 geçmişine göre ulak, elçi ve Aydoğdu ilk selamı farklı verir (DIY-04 selam). Beş yüz × geçmiş sayısı kadar selam satırı.
  - Kabul: iki geçmişle selam farkı ≥ 1. Test: Söz dosyası.
  - Bağımlılık: ACL-06, DIY-04. Boyut: S.
  - Dosya: Söz dosyaları.
  - Asset: asset gerekmedi.
- [ ] **OMR-50:** Tohum ve omurga.
  - Ne: oyun tohumu (RNG) hat yüzlerinin geliş gecesini dalga içinde kaydırır; dalga dışına çıkaramaz.
  - Kabul: 20 tohumda yüz gecesi dalga sınırı içinde. Test: runner.
  - Bağımlılık: OMR-05. Boyut: S.
  - Dosya: `tools/python_test_runner.py`.
  - Asset: asset gerekmedi.

## 34.10 Sınırlar ve kapanış

- [ ] **OMR-51:** Üçüncü perde yoktur.
  - Ne: `perde2_hedef_gece` dolunca oyun biter; omurga üçüncü perde, ikinci harita veya yeni son açmaz.
  - Kabul: `nihai_sonlar.json sonlar` sayısı sabit (5 + kayıp sonları). Test: sayım.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `design/omurga.md`.
  - Asset: asset gerekmedi.
- [ ] **OMR-52:** Çekirdek imzalar değişmez.
  - Ne: `perde_gecisi` statik fonksiyonları, `nihai_son.son/son_metni/gostergeler`, `oturum_bitti(son)` imzaları aynıdır.
  - Kabul: `tools/api_sozlesmesi.py` baseline farkı 0. Test: araç.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `tools/api_sozlesmesi_baseline.json`.
  - Asset: asset gerekmedi.
- [ ] **OMR-53:** Omurga verisi tek dosyadır.
  - Ne: dönem eşikleri, dalga sınırları, hat öncelikleri ve yüz eşlemesi `data/omurga.json`; `.gd` içinde sabit yok.
  - Kabul: `omurga*.gd` içinde sayı sabiti 0 (0/1 hariç). Test: tarama.
  - Bağımlılık: OMR-02…05. Boyut: S.
  - Dosya: yeni: `data/omurga.json`.
  - Asset: asset gerekmedi.
- [ ] **OMR-54:** Omurga metinleri ikinci sütuna hazır.
  - Ne: tüm omurga metinleri `metinler.csv` anahtarıdır (Bölüm 46).
  - Kabul: `omurga*.gd`, `dis_hat_kapisi.gd` içinde Türkçe sabit 0. Test: tarama.
  - Bağımlılık: YER-02. Boyut: S.
  - Dosya: `data/metin/metinler.csv`.
  - Asset: asset gerekmedi.
- [ ] **OMR-55:** Kapanış testi — iki perde tek koşu.
  - Ne: otomatik oyuncu nüfus 18'e ulaşır, geçiş gecesi kapı kapalıdır, üç dalgada ≥ 3 yüz gelir, son beşten biridir, kayıt `son.nihai` yazar.
  - Kabul: beş iddia tek testte. Test: `tests/oto/omurga_kontrol.tscn`.
  - Bağımlılık: OMR-01…54. Boyut: M.
  - Dosya: yeni: `tests/oto/omurga_kontrol.tscn`, `tests/oto/omurga_kontrol.gd`.
  - Asset: asset gerekmedi.

Alt başlıklarda madde sayısı beş ile altı arasındadır; onuncu madde her yerde var olan bir perde ya da son kuralını ikinci kez yazacağı için konmadı. Toplam 55 madde.
