# BÖLÜM 33 — Oyuncuyu alıştırma ve ilk saat

Faz 1 (ACL ve KAP-16 ile birlikte). Zemin: açılış sahnesi ACL-01 (köy ekranından başlar), ACL-04 (ulak, berat, ilk aile), ACL-06 (muhafızın geçmişi), açılış ekonomisi BUG-21/BUG-22, tehdit alışma süresi BUG-18, boş gün KAP-16, menü `src/arayuz/menu_ekrani.gd`, bilgi kadrajı `src/arayuz/bilgi_ekrani.gd`, metin anahtarları `data/metin/metinler.csv` (`arayuz.menu.ipucu` var). Kodda öğretici, rehber veya ilk gün akışı yoktur (`rg -i 'ogretici|tutorial|rehber' src` → 0). Bu bölüm açılışı yeniden yazmaz; ilk saatin öğrenme sırasını, ipuçlarının ne zaman ve nerede çıkacağını, neyin gizli kalacağını yazar.

Kimlikler OGR-01 … OGR-57. Öğretici ayrı bir mod değildir; oyunun ilk gecesidir. Pencereli, oyunu durduran, "devam için tıkla" diyen bir ders yoktur. Oyuncu kapıda ve köyde yaparak öğrenir; satırlar yalnız ilk kez bir şey yapılacağı an gelir, bir kez görünür, kayda yazılır.

Mimari: her madde yeni dosyadır, çekirdeğe (`ana.gd`, `koy_ekrani.gd`, `hud.gd`, `kapi_ekrani.gd`) tek satır adaptör. `koy_sahnesi` yasaktır. Bitince `[x]` ve ajan adı. Asset üretilmez; görsel ihtiyaç ARY-05'e yazılır. Ses yok.

**Madde biçimi:** Ne, Kabul, Bağımlılık + Boyut, Dosya, Asset.

---

## 33.1 İlk saatin omurgası — neyin ne zaman öğrenildiği

- [ ] **OGR-01:** İlk saat haritası tek dosyada durur.
  - Ne: oyuncunun ilk altı gecede karşılaşacağı kavramlar (kapı sorgusu, zar, bar, heybe, köy atama, gece raporu, pazar, divan, oda) gece numarasına bağlı sıralı listedir. Hangi kavramın hangi gecede ilk kez göründüğü buradan okunur.
  - Kabul: `data/ogretici/ilk_saat.json` içinde her kavramın `gece_min` ve `tetik` alanı vardır. Listede olmayan ipucu çıkmaz. Test: dosyadaki kavram sayısı ile ilk altı gecede gösterilen ipucu sayısı eşittir.
  - Bağımlılık: ACL-04. Boyut: S.
  - Dosya: yeni: `data/ogretici/ilk_saat.json`; yeni: `src/sistemler/ilk_saat.gd`.
  - Asset: asset gerekmedi.
- [ ] **OGR-02:** İlk gece yalnız kapı ve karar öğretir.
  - Ne: ulak ve ilk aile (ACL-04) geçerken oyuncu yalnız soru sormayı ve kabul/ret vermeyi görür. Rüşvet, arama, zar değiştiricisi ve heybe ilk gece kapalıdır.
  - Kabul: gece 0'da `rusvet_hakki` (`data/ayarlar/oyun.tres`) düğmesi görünmez; soru sayısı `azami_soru` (4) ile sınırlı kalır. Test: gece 0 anlık görüntüsünde rüşvet ve arama düğmesi 0.
  - Bağımlılık: OGR-01, ACL-04. Boyut: S.
  - Dosya: yeni: `src/kapi/ilk_gece_kisiti.gd`; `src/arayuz/kapi_ekrani.gd` tek satır.
  - Asset: asset gerekmedi.
- [ ] **OGR-03:** İkinci gece zar görünür olur.
  - Ne: görünür zar (ZAR-01) ilk kez ikinci gece bir soruda açılır. Oyuncu zarı ilk kez attığında "gerekli = değer + 1 + tansiyon eki" formülü tek satırlık ipucuyla gösterilir.
  - Kabul: ipucu bir kez görünür, `ilk_saat` kaydına `zar_gosterildi` yazılır. Test: aynı kayıtla ikinci açılışta ipucu 0.
  - Bağımlılık: ZAR-01, OGR-01. Boyut: S.
  - Dosya: yeni: `src/kapi/zar_ipucu.gd`.
  - Asset: asset gerekmedi.
- [ ] **OGR-04:** Köy ekranı ilk kez kabulden sonra açılır.
  - Ne: ilk kabul edilen kişi köye girince oyuncu köy ekranına geçer; ilk görev onu bir işe atamaktır (ISG-01 uyarısı burada ilk kez görünür).
  - Kabul: ilk kabulden önce köy ekranı düğmesi pasiftir. Test: kabul 0 iken köy ekranına geçiş 0.
  - Bağımlılık: ACL-01, ISG-01. Boyut: S.
  - Dosya: yeni: `src/sistemler/ilk_saat.gd` içinde `koy_acik()`; `src/arayuz/ana.gd` tek satır.
  - Asset: asset gerekmedi.
- [ ] **OGR-05:** Gece raporu ilk kez üç satırla gelir.
  - Ne: ilk gece raporu (`src/sistemler/gece_bilancosu.gd`) tam tablo yerine üç satır gösterir: kim geldi, kim kaldı, ambar ne oldu. Tam tablo üçüncü geceden sonra açılır.
  - Kabul: gece 0 ve 1 raporunda satır sayısı 3; gece 3'ten sonra tam. Test: iki anlık görüntü karşılaştırması.
  - Bağımlılık: OGR-01. Boyut: S.
  - Dosya: yeni: `src/arayuz/gece_raporu_kisa.gd`; `src/arayuz/koy_ekrani.gd` tek satır.
  - Asset: asset gerekmedi.
- [ ] **OGR-06:** Tehdit alışma süresi ilk saatle hizalıdır.
  - Ne: BUG-18'in "ilk N gün tehdit yok" değeri, OGR-01 listesinde pazar ve divan öğrenilmeden önce dolmaz. İki sayı tek yerden okunur.
  - Kabul: `ilk_saat.json` içindeki `tehdit_baslangic` BUG-18 sabitini okur; iki ayrı sayı yoktur. Test: değer değişince ikisi birlikte değişir.
  - Bağımlılık: BUG-18, OGR-01. Boyut: S.
  - Dosya: `data/ogretici/ilk_saat.json`.
  - Asset: asset gerekmedi.

## 33.2 Bağlamsal ipuçları — bir kez, yerinde, kısa

- [ ] **OGR-07:** İpucu kaydı kayıt dosyasındadır.
  - Ne: gösterilen her ipucunun kimliği oyun kaydına `ogretici.gorulen` dizisinde yazılır. Yeni oyunda sıfırlanır; ayarlardan "ipuçlarını sıfırla" ile de sıfırlanır (Bölüm 35).
  - Kabul: kayıt sürümü KAY zincirine uyar; eski kayıtta alan yoksa boş sayılır, oyun çökmez. Test: alan silinmiş kayıt açılır.
  - Bağımlılık: KAY-04. Boyut: S.
  - Dosya: yeni: `src/sistemler/ipucu_kaydi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OGR-08:** İpucu tek satırdır ve ekranın aynı köşesindedir.
  - Ne: ipucu metni en çok 90 karakterdir, HUD'un alt-sol köşesinde 6 saniye durur ya da ilk girdiyle kapanır. Pencere açmaz, oyunu durdurmaz.
  - Kabul: `metinler.csv` `ogretici.*` anahtarlarının hepsi ≤ 90 karakter (`tools/metin_dogrula.py` kuralı). Test: tarama 0 ihlal.
  - Bağımlılık: OGR-07. Boyut: S.
  - Dosya: yeni: `src/arayuz/ipucu_seridi.gd`; `tools/metin_dogrula.py` tek kural.
  - Asset: asset gerekmedi.
- [ ] **OGR-09:** İpucu kendi anahtarıyla yazılır, Üslup Rehberi'ne uyar.
  - Ne: ipucu metinleri `ogretici.` önekiyle `metinler.csv`'ye girer; USLUP_REHBERI §7 yapaylık denetiminden geçer ("Bu hatırlanacak" tonu değil, muhafızın kendi kendine notu tonu).
  - Kabul: `ogretici.` anahtarları yapaylık taramasından (YAZ-10) geçer. Test: tarama raporunda `ogretici.` ihlali 0.
  - Bağımlılık: YAZ-02, YAZ-10. Boyut: S.
  - Dosya: `data/metin/metinler.csv` (yeni satırlar).
  - Asset: asset gerekmedi.
- [ ] **OGR-10:** Aynı ipucu iki kez çıkmaz, kaçırılan ipucu geri çağrılabilir.
  - Ne: görülen ipucu bir daha gelmez. Oyuncu kaçırdıysa Bölüm 39 hafıza defterinin "Not" sayfasında son beş ipucu durur.
  - Kabul: aynı kimlik kayıtta bir kez; defter sayfasında en çok beş satır. Test: altı ipucu sonrası sayfa 5 satır.
  - Bağımlılık: OGR-07, HFZ-01. Boyut: S.
  - Dosya: `src/sistemler/ipucu_kaydi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OGR-11:** İpucu, köy hızı 0 değilken de gelir, hızı değiştirmez.
  - Ne: köy ekranında zaman akarken (`koy_ekrani.gd:342 _hiz_sec`) ipucu `Engine.time_scale`'e dokunmaz.
  - Kabul: ipucu öncesi ve sonrası `time_scale` eşittir. Test: hız 2'de ipucu açılıp kapanınca hız 2.
  - Bağımlılık: OGR-08. Boyut: S.
  - Dosya: `src/arayuz/ipucu_seridi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OGR-12:** Debug HUD'da ipucu akışı izlenir.
  - Ne: `src/debug/admin_hud.gd` (F1) listesine "görülen ipuçları" satırı ve "hepsini sıfırla" düğmesi eklenir. Oyuncu arayüzüne girmez.
  - Kabul: debug kapalıyken düğme 0. Test: `--debug` olmadan açılışta düğme yok.
  - Bağımlılık: OGR-07. Boyut: S.
  - Dosya: yeni: `src/debug/ipucu_paneli.gd`; `admin_hud.gd` tek satır.
  - Asset: asset gerekmedi.

## 33.3 Kapı sorgusunun öğretilmesi

- [ ] **OGR-13:** İlk aile sorgusu kılavuzsuz ama dar.
  - Ne: ACL-04'teki ilk ailede konu merkezinde (DIY-04) yalnız iki konu açıktır: kim olduğu ve neden geldiği. Diğer konular sonraki ziyaretlerde açılır.
  - Kabul: gece 0 ilk ailede açık konu 2. Test: söz dosyasında `gece_min` alanı.
  - Bağımlılık: DIY-04, ACL-04. Boyut: S.
  - Dosya: Söz veri dosyası (DIY-02 şeması) `gece_min` alanı; ilk aile dosyası YAZ-05 pilotunda.
  - Asset: asset gerekmedi.
- [ ] **OGR-14:** Beyan defteri ilk çelişkide tanıtılır.
  - Ne: beyan defteri (DIY-07) ilk kez bir karakter kendi sözüyle çelişince açılır; o ana kadar HUD'da düğmesi görünmez.
  - Kabul: ilk çelişki öncesi defter düğmesi 0; sonrası 1 ve ipucu bir kez. Test: çelişkisiz üç ziyaret sonrası düğme 0.
  - Bağımlılık: DIY-07, DIY-08, OGR-07. Boyut: S.
  - Dosya: yeni: `src/kapi/defter_tanitimi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OGR-15:** Heybe ilk kez bir gizli eşyada açılır.
  - Ne: heybe arama (R1 heybe, `src/sistemler/heybe.gd`) ilk kez `esya_gizli` (oyun.tres `yuzuk`) taşıyan kişide ipucu alır. Önceki ziyaretlerde heybe düğmesi vardır ama ipucu yoktur.
  - Kabul: ilk gizli eşya ziyaretinde ipucu 1. Test: gizli eşyasız kayıtta ipucu 0.
  - Bağımlılık: OGR-07. Boyut: S.
  - Dosya: `src/sistemler/ilk_saat.gd` tetik satırı.
  - Asset: asset gerekmedi.
- [ ] **OGR-16:** Tansiyon göstergesi ilk sarıda açıklanır.
  - Ne: `src/arayuz/kapi/tansiyon_gostergesi.gd` ilk kez "gergin" kademeye (ZAR-01 +1) geçince tek satır ipucu: zar zorlaştı.
  - Kabul: ipucu kademe geçişinde bir kez. Test: sakin kalan gecede ipucu 0.
  - Bağımlılık: ZAR-01, OGR-07. Boyut: S.
  - Dosya: `src/sistemler/ilk_saat.gd` tetik satırı.
  - Asset: asset gerekmedi.
- [ ] **OGR-17:** Bar etkisi ilk hareket eden barda gösterilir.
  - Ne: dört bar (`bar.halk`, `bar.soylular`, `bar.tuccarlar`, `bar.ordu`; `oyun.tres bar_baslangic 6`) ilk kez değişince hangi kararın hangi barı oynattığı tek satırla söylenir.
  - Kabul: ipucu ilk değişimde bir kez; bar adı anahtarla yazılır. Test: bar değişmeyen gecede 0.
  - Bağımlılık: OGR-07. Boyut: S.
  - Dosya: `src/sistemler/ilk_saat.gd` tetik satırı.
  - Asset: asset gerekmedi.
- [ ] **OGR-18:** Kabul sınırı (barınak) ilk doluda söylenir.
  - Ne: ACL-05 barınak kapasitesi ilk kez dolunca ipucu: yer yok, kabul edilen dışarıda kalır. İpucu kararı engellemez.
  - Kabul: ilk dolu anda bir kez. Test: kapasite dolmadan 0.
  - Bağımlılık: ACL-05, OGR-07. Boyut: S.
  - Dosya: `src/sistemler/ilk_saat.gd` tetik satırı.
  - Asset: asset gerekmedi.

## 33.4 Köy ekranının öğretilmesi

- [ ] **OGR-19:** İlk atama sürükle-bırakla gösterilir.
  - Ne: ilk köylü kartı (`src/arayuz/koylu_karti.gd`, `koylu_surukleme_kulpu.gd`) sürüklenebilir olduğunda tek satır ipucu ve kartın kulpunda bir kez yanıp sönen vurgu.
  - Kabul: ilk atama sonrası vurgu kalkar. Test: ikinci köylüde vurgu 0.
  - Bağımlılık: OGR-04. Boyut: S.
  - Dosya: yeni: `src/arayuz/koy_hud/ilk_atama_vurgusu.gd`.
  - Asset: asset gerekmedi (vurgu kod çizimi).
- [ ] **OGR-20:** Kaynak göstergesi ilk eksilişte açıklanır.
  - Ne: `koy_hud/kaynak_gostergesi.gd` ilk kez bir kaynak düşünce tüketim satırı (EKO-09, `tuketim_dengesi.json`) tek satırla söylenir.
  - Kabul: bir kez. Test: tüketim 0 olan gecede ipucu 0.
  - Bağımlılık: OGR-07. Boyut: S.
  - Dosya: `src/sistemler/ilk_saat.gd` tetik satırı.
  - Asset: asset gerekmedi.
- [ ] **OGR-21:** Taş ve odun kilidi ilk inşa denemesinde uyarır.
  - Ne: BUG-21/BUG-22 düzeltmesinden sonra bile ilk inşa denemesinde kaynak yetmezse ipucu kaynağın nereden geldiğini söyler (taş yatağı, oduncu).
  - Kabul: yetersiz kaynakla ilk denemede bir kez. Test: yeterli kaynakla 0.
  - Bağımlılık: BUG-21, BUG-22. Boyut: S.
  - Dosya: `src/sistemler/ilk_saat.gd` tetik satırı.
  - Asset: asset gerekmedi.
- [ ] **OGR-22:** Hız tuşları ilk köy gününde gösterilir.
  - Ne: köy ekranında hız seçimi (`koy_ekrani.gd:330–343`, 1–5 ve P) ilk açılışta tek satırla söylenir; tuş adları Bölüm 45 eylem haritasından okunur.
  - Kabul: ipucu metninde tuş adı sabit değil, eylemden gelir. Test: tuş yeniden atanınca ipucu metni değişir.
  - Bağımlılık: GIR-03, OGR-07. Boyut: S.
  - Dosya: `src/sistemler/ilk_saat.gd` tetik satırı.
  - Asset: asset gerekmedi.
- [ ] **OGR-23:** Boş gün ilk kez gelince açıklanır.
  - Ne: KAP-16 boş gün ilk kez düşünce ipucu: bugün kapıya kimse gelmedi, köy günü (SEV-01).
  - Kabul: ilk boş günde bir kez. Test: boş gün olmayan altı gecede 0.
  - Bağımlılık: KAP-16, SEV-01. Boyut: S.
  - Dosya: `src/sistemler/ilk_saat.gd` tetik satırı.
  - Asset: asset gerekmedi.
- [ ] **OGR-24:** Pazar ve divan düğmeleri açılınca işaretlenir.
  - Ne: pazar (TUC) ve divan (CAS-07) HUD düğmeleri ilk kez etkin olunca kenarında bir kez yanıp sönen işaret ve tek satır.
  - Kabul: ilk açılışta işaret; girince kalkar. Test: iki kez tıklanmış düğmede işaret 0.
  - Bağımlılık: OGR-07. Boyut: S.
  - Dosya: yeni: `src/arayuz/koy_hud/yeni_dugme_isareti.gd`.
  - Asset: asset gerekmedi.

## 33.5 Kademeli açılan arayüz

- [ ] **OGR-25:** HUD katmanları gece sayısına göre açılır.
  - Ne: köy HUD'undaki ~45 panelin tümü ilk gece görünmez. `ilk_saat.json` her panelin dosya adına `gece_min` verir; panel o geceden önce ağaca eklenmez.
  - Kabul: gece 0 HUD'unda panel sayısı ≤ 6. Test: `tests/oto/koy_hud_kontrol.tscn` gece 0 ile çalıştırılır.
  - Bağımlılık: OGR-01. Boyut: M.
  - Dosya: yeni: `src/arayuz/koy_hud/hud_katmani.gd`; `src/arayuz/hud.gd` tek satır.
  - Asset: asset gerekmedi.
- [ ] **OGR-26:** Gizli panel, verisi oluşunca kendini açar.
  - Ne: `gece_min` dolmasa da ilgili sistem veri üretirse (örn. karantina, `karantina_paneli.gd`) panel açılır. Gizlilik oyuncudan bilgi saklamaz.
  - Kabul: karantina bayrağı açıkken panel gece 0'da bile görünür. Test: bayrak enjekte edilir, panel 1.
  - Bağımlılık: OGR-25. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/hud_katmani.gd`.
  - Asset: asset gerekmedi.
- [ ] **OGR-27:** Muhafız odası ilk teftişten sonra açılır.
  - Ne: `src/arayuz/muhafiz_odasi_ekrani.gd` düğmesi ilk sancak teftişi (`sancak_teftisi.gd`) ya da ilk yozlaşma kararından sonra görünür.
  - Kabul: iki tetikten önce düğme 0. Test: tetiksiz kayıt.
  - Bağımlılık: OGR-25. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/hud_katmani.gd`.
  - Asset: asset gerekmedi.
- [ ] **OGR-28:** Harita ilk kervandan sonra açılır.
  - Ne: `src/arayuz/harita_ekrani.gd` ilk kervan olayı (`data/olaylar/kervan.tres`, `koy.tres kervan_araligi 4`) ya da ilk haberciden sonra açılır.
  - Kabul: tetik öncesi harita düğmesi 0. Test: gece 3 anlık görüntüsü.
  - Bağımlılık: OGR-25. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/hud_katmani.gd`.
  - Asset: asset gerekmedi.
- [ ] **OGR-29:** Kademeli açılış ayarlardan kapatılabilir.
  - Ne: Bölüm 35'te "deneyimli oyuncu" anahtarı; açıkken bütün paneller ilk geceden görünür ve ipucu çıkmaz.
  - Kabul: anahtar açıkken gece 0 HUD tam. Test: iki anahtar durumunda panel sayısı.
  - Bağımlılık: AYR-12, OGR-25. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/hud_katmani.gd`.
  - Asset: asset gerekmedi.
- [ ] **OGR-30:** Katman sırası tester ikizinde doğrulanır.
  - Ne: TST-06 kayıt ikizi ile aynı tohumda iki açılışın panel açılış geceleri eşittir.
  - Kabul: iki koşunun `hud_katmani` günlüğü aynıdır. Test: `tests/oto/` yeni kontrol.
  - Bağımlılık: OGR-25. Boyut: S.
  - Dosya: yeni: `tests/oto/hud_katmani_kontrol.tscn`.
  - Asset: asset gerekmedi.

## 33.6 İlk başarısızlık ve kurtarma

- [ ] **OGR-31:** İlk kötü karar bir açıklama satırı alır.
  - Ne: oyuncunun ilk reddi ya da kabulü kötü sonuç verince (DYL-08 kararın dönüşü) sabah raporunda bir satır bağlantı kurar: "Üç gece önce kapıda …". Ders değil, hatırlatma.
  - Kabul: ilk olumsuz dönüşte satır bir kez. Test: dönüş olmayan kayıtta 0.
  - Bağımlılık: DYL-08. Boyut: S.
  - Dosya: `src/sistemler/ilk_saat.gd` tetik satırı.
  - Asset: asset gerekmedi.
- [ ] **OGR-32:** Kıtlık eşiği ilk yaklaşmada görünür.
  - Ne: ambar `ambar_yedek_gece` (oyun.tres = 1) altına ilk inince ipucu ve ambar göstergesinde renk; kıtlık sistemi (KRI) değişmez.
  - Kabul: ilk yaklaşmada bir kez. Test: bol ambarlı kayıtta 0.
  - Bağımlılık: OGR-20. Boyut: S.
  - Dosya: `src/sistemler/ilk_saat.gd` tetik satırı.
  - Asset: asset gerekmedi.
- [ ] **OGR-33:** İlk saat içinde oyun bitmez.
  - Ne: ilk altı gecede beş sondan (SYS-20) hiçbiri tetiklenemez; eşik koşulu `nihai_son.gd` tarafından okunur, `ilk_saat.json` `son_kilidi_gece` alanıyla ertelenir.
  - Kabul: gece < 6 iken son 0. Test: en kötü değerlerle gece 5 anlık görüntüsü.
  - Bağımlılık: SYS-20, OGR-01. Boyut: S.
  - Dosya: yeni: `src/sistemler/son_kilidi.gd`; `nihai_son.gd` tek satır.
  - Asset: asset gerekmedi.
- [ ] **OGR-34:** İflas uyarısı ilk eksi kasada gelir.
  - Ne: `src/koy/iflas_yoneticisi.gd` (`data/koy/iflas.json`) eşiğinden iki gece önce tek satır uyarı.
  - Kabul: uyarı iflas gecesinden önce; iflas metni değişmez. Test: zaman makinesiyle (`src/debug/zaman_makinesi.gd`) iki gece.
  - Bağımlılık: OGR-07. Boyut: S.
  - Dosya: `src/sistemler/ilk_saat.gd` tetik satırı.
  - Asset: asset gerekmedi.
- [ ] **OGR-35:** "Ne yapabilirim?" sayfası — tek sayfa, metin.
  - Ne: Esc menüsüne (`menu` eylemi) "Kapı usulü" sayfası eklenir: kapı, köy, zar, bar, heybe için beşer satır. Kaydırmalı tek sayfa, resim yok.
  - Kabul: sayfa 25 satırı geçmez, hepsi `metinler.csv`'den. Test: anahtar sayısı 25.
  - Bağımlılık: OGR-09. Boyut: S.
  - Dosya: yeni: `src/arayuz/kapi_usulu_sayfasi.gd`; `menu_ekrani.gd` tek satır.
  - Asset: asset gerekmedi.
- [ ] **OGR-36:** İlk saat sonu özet satırı.
  - Ne: altıncı gecenin raporunda bir satır: kaç kişi geldi, kaç kabul, kaç ret, köy nüfusu. `ana.gd:125 arayuz.son.istatistik` biçimi kullanılır.
  - Kabul: gece 5 raporunda satır 1, başka gecede 0. Test: anlık görüntü.
  - Bağımlılık: OGR-05. Boyut: S.
  - Dosya: `src/arayuz/gece_raporu_kisa.gd`.
  - Asset: asset gerekmedi.

## 33.7 Muhafızın geçmişi ve öğretinin kişiselleşmesi

- [ ] **OGR-37:** Seçilen geçmiş ilk ipuçlarını değiştirir.
  - Ne: ACL-06 muhafızın geçmişi (eski asker, kâtip, çiftçi vb.) seçildiğinde o alanın ipucu atlanır: kâtip beyan defteri ipucunu görmez, asker tansiyon ipucunu görmez.
  - Kabul: `ilk_saat.json` her ipucuda `atla_gecmis` listesi. Test: iki geçmişle ipucu kümesi farkı ≥ 1.
  - Bağımlılık: ACL-06, OGR-01. Boyut: S.
  - Dosya: `data/ogretici/ilk_saat.json`.
  - Asset: asset gerekmedi.
- [ ] **OGR-38:** Atlanan ipucu yerine geçmişin tek cümlesi.
  - Ne: atlanan ipucunun yerinde muhafızın geçmişine ait tek cümle durur (USLUP_REHBERI ses kartı tonunda). Bilgi vermez, kişilik verir.
  - Kabul: cümle `ogretici.gecmis.*` anahtarındadır; en çok 70 karakter. Test: tarama.
  - Bağımlılık: OGR-37, YAZ-03. Boyut: S.
  - Dosya: `data/metin/metinler.csv`.
  - Asset: asset gerekmedi.
- [ ] **OGR-39:** Eş ilk akşam sohbetinde bir şey öğretir.
  - Ne: ACL-03 / DYL-07 akşam sohbetinin ilk gecesinde eş, gün içinde kullanılmayan bir aracı tek cümleyle anar (heybe, beyan). Bu Söz motorunda bir bağlam sorgusu dalıdır (DIY-09).
  - Kabul: dal yalnız ilk üç gecede ve araç kullanılmadıysa açılır. Test: aracı kullanan kayıtta dal 0.
  - Bağımlılık: DYL-07, DIY-09. Boyut: S.
  - Dosya: eş söz dosyası (YAZ-05 pilot kapsamı) dal satırı.
  - Asset: asset gerekmedi.
- [ ] **OGR-40:** Ulak ikinci gece dönüp berat şartını hatırlatır.
  - Ne: ACL-04 ulağı ikinci gecenin sonunda tek satır haber bırakır: sancak beyi kapının defterini ister (SYS-20 sonlarından teftiş yoluna işaret).
  - Kabul: satır gece 1 sonunda bir kez. Test: anlık görüntü.
  - Bağımlılık: ACL-04. Boyut: S.
  - Dosya: `src/sistemler/ilk_saat.gd` tetik satırı; metin `metinler.csv`.
  - Asset: asset gerekmedi.
- [ ] **OGR-41:** Yeni oyun başlangıç özeti tek kadraj.
  - Ne: ACL-06 seçiminden sonra `bilgi_ekrani.gd` kadrajında üç satır: kimsin, köy nerede, kapı ne zaman açılır. Resim yok, metin koddan.
  - Kabul: kadraj bir girdiyle geçilir; süre sınırı yok. Test: anahtar sayısı 3.
  - Bağımlılık: ACL-06. Boyut: S.
  - Dosya: `src/arayuz/bilgi_ekrani.gd` çağrısı; metin `metinler.csv`.
  - Asset: asset gerekmedi.

## 33.8 Ölçüm — ilk saat gerçekten öğretiyor mu

- [ ] **OGR-42:** İlk saat ölçüm kancası.
  - Ne: TST-03 ölçüm kancalarına `ILKSAAT` eklenir: her ipucunun gösterildiği gece, oyuncunun ilgili aracı ilk kullandığı gece.
  - Kabul: kanca günlüğü JSON'dur; tester runner okur. Test: altı gecelik koşuda satır sayısı = ipucu sayısı.
  - Bağımlılık: OGR-07, TST-03. Boyut: S.
  - Dosya: yeni: `src/debug/ilk_saat_kancasi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OGR-43:** Yedi persona ilk saati geçer.
  - Ne: TST-07 personaları (`tools/python_test_runner.py`) ilk altı geceyi oynar; hiçbiri OGR-33 kilidi yüzünden değil, oyun yüzünden kaybetmemelidir.
  - Kabul: yedi koşuda son 0, ambar ≥ 0. Test: runner raporu.
  - Bağımlılık: OGR-33, TST-07. Boyut: S.
  - Dosya: `tools/python_test_runner.py` senaryo satırı.
  - Asset: asset gerekmedi.
- [ ] **OGR-44:** Kullanılmayan araç raporu.
  - Ne: ölçüm, altı gecede hiç kullanılmayan aracı (heybe, beyan, yemin, bakmak…) listeler. Tasarım bu listeye göre ipucu gecesini kaydırır; kod değişmez.
  - Kabul: rapor `docs/tester/` altında tablo. Test: tablo üretilir.
  - Bağımlılık: OGR-42. Boyut: S.
  - Dosya: `tools/python_test_runner.py` rapor satırı.
  - Asset: asset gerekmedi.
- [ ] **OGR-45:** İpucu sayısı üst sınırı.
  - Ne: ilk altı gecede gösterilen ipucu toplamı 20'yi geçmez (öneri). Geçerse liste kırpılır, önce en az kullanılan araç kalır.
  - Kabul: `ilk_saat.json` kavram sayısı ≤ 20. Test: sayım.
  - Bağımlılık: OGR-01. Boyut: S.
  - Dosya: `data/ogretici/ilk_saat.json`.
  - Asset: asset gerekmedi.
- [ ] **OGR-46:** İlk saat süresi ölçülür.
  - Ne: altı gecenin gerçek süresi (otomatik oyuncu, `tests/oto/otomatik_oyuncu.tscn`) ölçülür; hedef 45–75 dakika (öneri). Sapınca `gece_basina_gelen` değil, ipucu ve kademeli açılış gecesi oynar.
  - Kabul: ölçüm raporda. Test: runner süre satırı.
  - Bağımlılık: OGR-42. Boyut: S.
  - Dosya: `tools/python_test_runner.py`.
  - Asset: asset gerekmedi.

## 33.9 Yeniden oynayan oyuncu

- [ ] **OGR-47:** İkinci oyunda ipucu kapalıdır.
  - Ne: `user://ayarlar.cfg` içinde `ilk_oyun_bitti` anahtarı; bir kez altı gece geçildiyse yeni oyunda ipucu ve kademeli açılış kapalı başlar, Bölüm 35'ten açılabilir.
  - Kabul: anahtar `Ayarlar.VARSAYILAN`'a değil ayrı dosyaya yazılır (çekirdek dosya korunur). Test: iki açılış.
  - Bağımlılık: AYR-12. Boyut: S.
  - Dosya: yeni: `src/sistemler/oyuncu_izi.gd` (`user://oyuncu_izi.cfg`).
  - Asset: asset gerekmedi.
- [ ] **OGR-48:** Açılış kadrajı ikinci oyunda atlanır.
  - Ne: OGR-41 kadrajı `ilk_oyun_bitti` iken gösterilmez.
  - Kabul: ikinci oyunda kadraj 0. Test: iki açılış.
  - Bağımlılık: OGR-41, OGR-47. Boyut: S.
  - Dosya: `src/sistemler/oyuncu_izi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OGR-49:** Yeni mekanik (sürüm sonrası) tek ipucu alır.
  - Ne: sürüm güncellemesiyle gelen yeni sistem, deneyimli oyuncuya da bir kez ipucu verir; `ilk_saat.json` kavramında `surum_min` alanı.
  - Kabul: eski `oyuncu_izi` ile yeni sürümde yalnız yeni kavramın ipucu 1. Test: sürüm alanı değiştirilir.
  - Bağımlılık: OGR-47, KAY-04. Boyut: S.
  - Dosya: `data/ogretici/ilk_saat.json`.
  - Asset: asset gerekmedi.
- [ ] **OGR-50:** Zorluk seçimi ikinci oyunda açılır.
  - Ne: DEN-04 zorluk çarpanı (kolay/olağan/sıkı) ilk oyunda gösterilmez, olağan başlar; `ilk_oyun_bitti` ile yeni oyun ekranında görünür.
  - Kabul: ilk oyunda zorluk seçici 0. Test: iki açılış.
  - Bağımlılık: DEN-04, OGR-47, AYR-23, AYR-34. Boyut: S.
  - Dosya: `src/sistemler/oyuncu_izi.gd`; yeni oyun ekranı AYR-34.
  - Asset: asset gerekmedi.
- [ ] **OGR-51:** Devam eden kayıtta ipucu durumu kayıttan gelir.
  - Ne: "Devam" ile açılan kayıtta `ogretici.gorulen` kayıttan, `ilk_oyun_bitti` ayardan okunur; ikisi çelişirse kayıt kazanır.
  - Kabul: kayıt alanı dolu, ayar boş → ipucu kayıt kadar. Test: çapraz durum.
  - Bağımlılık: OGR-07, OGR-47. Boyut: S.
  - Dosya: `src/sistemler/ipucu_kaydi.gd`.
  - Asset: asset gerekmedi.

## 33.10 Sınırlar ve kapanış

- [ ] **OGR-52:** Öğretici ayrı sahne açmaz.
  - Ne: `tutorial`, `ogretici_sahne` adlı sahne yoktur; her şey canlı oyunda olur.
  - Kabul: `rg -l 'ogretici_sahne|tutorial' src` → 0. Test: tarama.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: tarama `tools/godot_script_taramasi.py` tek kural.
  - Asset: asset gerekmedi.
- [ ] **OGR-53:** Çekirdek dosyalarda ipucu metni yoktur.
  - Ne: `ana.gd`, `koy_ekrani.gd`, `hud.gd`, `kapi_ekrani.gd` içinde `ogretici.` anahtarı geçmez; yalnız adaptör çağrısı vardır.
  - Kabul: dört dosyada `ogretici.` 0. Test: tarama.
  - Bağımlılık: OGR-08. Boyut: S.
  - Dosya: `tools/godot_script_taramasi.py`.
  - Asset: asset gerekmedi.
- [ ] **OGR-54:** İpucu oyun durumunu değiştirmez.
  - Ne: ipucu gösterimi RNG, kayıt sayaçları, bar ve kasaya dokunmaz. TST-06 ikiz koşusu ipucu açık/kapalı iken aynı sonucu verir.
  - Kabul: iki koşunun durum anlık görüntüsü (`src/debug/durum_anlik_goruntusu.gd`) eşittir. Test: ikiz.
  - Bağımlılık: OGR-25, TST-06. Boyut: S.
  - Dosya: yeni: `tests/oto/ipucu_ikiz_kontrol.tscn`.
  - Asset: asset gerekmedi.
- [ ] **OGR-55:** Admin HUD oyuncuya öğretilmez.
  - Ne: F1 / `~` (`src/debug/admin_hud.gd`) hiçbir ipucunda anılmaz; sürüm derlemesinde kapalıdır (Bölüm 42).
  - Kabul: `ogretici.` metinlerinde "F1" 0. Test: tarama.
  - Bağımlılık: SRM-05. Boyut: S.
  - Dosya: `tools/metin_dogrula.py` tek kural.
  - Asset: asset gerekmedi.
- [ ] **OGR-56:** İlk saat metinleri İngilizce sütuna hazır anahtarlardır.
  - Ne: `ogretici.` anahtarları Bölüm 46 ikinci sütun kuralına uyar; metin içinde tuş adı ve sayı yer tutucuyla (`%s`, `%d`) gelir.
  - Kabul: sabit tuş adı içeren `ogretici.` satırı 0. Test: tarama.
  - Bağımlılık: YER-02. Boyut: S.
  - Dosya: `data/metin/metinler.csv`.
  - Asset: asset gerekmedi.
- [ ] **OGR-57:** Kapanış testi — altı gece tek koşu.
  - Ne: tek otomatik koşu: ipucu sırası OGR-01 listesine eşit, panel açılış geceleri OGR-25'e eşit, son 0, ikinci açılışta ipucu 0.
  - Kabul: dört iddia tek testte. Test: `tests/oto/ilk_saat_kontrol.tscn`.
  - Bağımlılık: OGR-01…56. Boyut: S.
  - Dosya: yeni: `tests/oto/ilk_saat_kontrol.tscn`, `tests/oto/ilk_saat_kontrol.gd`.
  - Asset: asset gerekmedi.

Alt başlıklarda madde sayısı altı ile yedi arasındadır; onuncu madde her yerde bir öncekinin kabulünü tekrar edeceği için konmadı. Toplam 57 madde.
