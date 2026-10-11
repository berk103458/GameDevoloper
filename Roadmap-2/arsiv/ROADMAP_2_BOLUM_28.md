# BÖLÜM 28: Hükmün sabahı

Zemin: divan hükmü CAS-07 üçlüsüdür (zindan, sürgün, infaz). Cenaze KRI-05 ve SEV-07 akışıdır. Mahkeme yeniden kurulmaz. KOP-01 divan konuşmasını yürütür; bu bölüm o konuşmayı yazmaz. Burada hükümden sonraki üç sabah köyde neyin değiştiği durur: hane kapısı, boş tezgâh, tek dedikodu satırı, zindanın ekmeği, sürgünün yolu.

Dönem 1240'lar. Yol adı metindir. İkinci harita, kalp puanı, romans ve ses yoktur. Her madde bir öncekinin kaydını okur.

## 28.1 Hükmün kaydı

- [ ] **SAB-01:** Gece hükmü sabah defterine tek satır düşer.
  - Ne: Gece bitince son CAS-07 kaydı deftere tek satır olur: kişi, hüküm (zindan, sürgün veya infaz) ve gün 0; ertesi sabah aynı satır basılmaz. Hüküm yoksa defter boş kalır ve sonraki sabahları açmaz; gece içinde değişen hükümden yalnız son hali okunur, ad sorulmamışsa maskede kalır.
  - Kabul: İnfaz gecesinin sabahında satır sayısı 1 ve `hukum` değeri `infaz` olur (`tests/unit/koy/sabah_defteri_test.gd`). Hüküm yokken satır 0, aynı kişiye iki yazımda satır 1 kalır. Meclis tutanağıyla birebir satır 0. Kayıtta düz metin alanı 0. Aynı sabah ikinci yol satırı 0. Yeni ses dosyası ve kalp anahtarı 0.
  - Bağımlılık: CAS-07. Boyut: S.
  - Dosya: yeni `src/koy/sabah_defteri.gd`; CAS-07 kaydına okuma.
  - Asset: asset gerekmedi.

- [ ] **SAB-15:** Satır anahtardır
  - Ne: Satır anahtardır. Düz cümle 0.
  - Kabul: Satır anahtardır. 0. Test: SYS-09.
  - Bağımlılık: SYS-09. Boyut: S.
  - Dosya: `data/metin/metinler.csv`
  - Asset: asset gerekmedi.
- [ ] **SAB-17:** Satır kayda optional
  - Ne: Satır kayda optional. Eski kayıt satırsız.
  - Kabul: Eski kayıt satırsız açılır ve yazılan satır 0 kalır (`tests/unit/kvr/kayit_gocu_test.gd`).
  - Bağımlılık: KAY-04. Boyut: S.
  - Dosya: `src/sistemler/kayit_gocu.gd`
  - Asset: asset gerekmedi.
- [ ] **SAB-18:** Satır hızı değiştirmez
  - Ne: Satır hızı değiştirmez. Scale aynı.
  - Kabul: Satır hızı değiştirmez. Fark 0. Test: TEK-22.
  - Bağımlılık: TEK-22. Boyut: S.
  - Dosya: `src/arayuz/koy_ekrani.gd`
  - Asset: asset gerekmedi.

## 28.2 İlk sabah köyde

- [ ] **SAB-02:** Evde kalanların adı kapı satırına düşer.
  - Ne: Satırdaki kişinin hanesinde veride kim varsa sabah kapısı onların görünen adını sayar; çocuk listede durur ama ağır işe yazılmaz. Kayıt yoksa veya kalan 0 ise sonuç `evi_bos` olur, evlilik ve yeni akraba eklenmez.
  - Kabul: Hanede 2 kişi varken sabah satırı 2 ad taşır (`tests/unit/koy/sabah_defteri_test.gd`). Hane kaydı yokken ad sayısı 0 ve kayıt `evi_bos` olur.
  - Bağımlılık: SAB-01. Boyut: S.
  - Dosya: `src/koy/sabah_defteri.gd`; hane kaydına okuma.
  - Asset: asset gerekmedi.

- [ ] **SAB-03:** Birincil iş yeri o sabah kapalı kalır.
  - Ne: Hükümlünün birincil iş yeri o sabah `kapali` olur ve o gün kişi katkısını duran hesaba yazmaz. İki yer bağlıysa yalnız birincil kapanır; tezgâh yoksa veya yer zaten kapalıysa yeni bayrak ve ikinci tabela yazılmaz.
  - Kabul: Demirhaneye bağlı bir zindan hükmünde sabah demirhane `kapali` ve kişi katkısı 0 olur (`tests/unit/koy/sabah_defteri_test.gd`). Tezgâhsız kişide `kapali` bayrağı 0.
  - Bağımlılık: SAB-02. Boyut: M.
  - Dosya: `src/koy/sabah_defteri.gd`; ANI-08 düğümüne `kapali` adaptörü.
  - Asset: kapalı örtü envantere `SAB03-ORTU`; yer tutucu düz renk bez, ANI-08 düğümünün üstünde.

- [ ] **SAB-04:** Kapalı tezgâh tek dedikodu satırı olur.
  - Ne: Kapalı tezgâh varsa o sabah tek dedikodu satırı tezgâhın adını taşır; tezgâh yoksa konu hüküm değeridir. Tanık yoksa satır çıkmaz ve köy sohbeti ayrı bir infaz haberi üretmez.
  - Kabul: Tanıklı kapalı tezgâhta pusulada 1 satır vardır ve satır tezgâhın adını taşır (`tests/unit/koy/sabah_defteri_test.gd`). Tanıksız sabah satır sayısı 0. Aynı sabahta ikinci satır 0.
  - Bağımlılık: SAB-03, DIY-13. Boyut: S.
  - Dosya: `src/sistemler/dedikodu.gd` tek yazım; yeni gazete dosyası yok.
  - Asset: asset gerekmedi.

- [ ] **SAB-25:** Eş tezgâhı meslek üretimidir
  - Ne: HAN. Sabah onu kopyalamaz, bir satır yeter.
  - Kabul: Satır 1. Test: HAN-07.
  - Bağımlılık: HAN-07 Boyut: S.
  - Dosya: `src/koy/es_uretimi.gd`
  - Asset: asset gerekmedi.

## 28.3 Hükmün yolu — zindan, sürgün, infaz

- [ ] **SAB-05:** Zindan payı bir erzak düşürür.
  - Ne: Zindan hükmünde hane doluysa pay onların erzağından 1 düşer, hane boşsa kamu ambarından 1 düşer; sürgün ve infaz erzak düşürmez. Erzak kalmamışsa kişiye `ekmek_yok` yazılır, kişi zindanda kalır ve bu pay onu öldürmez.
  - Kabul: Zindan ve dolu hanede hane erzağı 1 azalır, zindan payı 1 olur (`tests/unit/koy/sabah_defteri_test.gd`). İnfazda erzak deltası 0. Ambar 0 iken işaret `ekmek_yok` olur. Pay miktarı `data/koy/` içindedir. Eşin ayrı tüketimi ikinci kez düşmez. Çocuk bu paya yazılmaz. Aynı tohumla iki koşu aynı düşüşü yazar.
  - Bağımlılık: SAB-02. Boyut: S.
  - Dosya: yeni `src/koy/zindan_ekmegi.gd`; EKO-09 düşüşüne tek satır.
  - Asset: asset gerekmedi. Ekmek, duran erzak ikonudur.

- [ ] **SAB-06:** Sürgün kapıdan bir yol adıyla çıkar.
  - Ne: Sürgün sabahında kitaptaki bir yol adı (Sivas, Kayseri, Konya veya dosyadaki başka ad) kapı satırına yazılır, kişi nüfustan 1 düşer ve harita açılmaz. Hanede kalanlar köyde kalır; ad boşsa nüfus düşmez, çocuk yanında kayıt yoksa satır `açıkta` kalır ve kayıt görünen adı değil yol kimliğini tutar.
  - Kabul: Sürgünde nüfus 1 azalır ve sabah metninde bir yol adı vardır (`tests/unit/koy/sabah_defteri_test.gd`). Yol adı boşsa nüfus deltası 0. Zindan ve infazda yol satırı 0. Harita düğümü 0. Yol satırı için ses dosyası 0.
  - Bağımlılık: SAB-03. Boyut: M.
  - Dosya: `src/koy/sabah_defteri.gd`; `data/soz/surgun_yollari.json`.
  - Asset: asset gerekmedi.

- [ ] **SAB-07:** İnfaz sabahı duran cenazeyi açar.
  - Ne: İnfaz sabahı duran cenaze akışını bir kez çağırır; tören seçeneği iki kalır ve ad satırı bir kez yazılır. Zindan ve sürgünde cenaze açılmaz, kişi zaten ölü kayıtlıysa ikinci çağrı yazılmaz.
  - Kabul: İnfaz sabahında cenaze çağrısı 1 ve tören seçeneği 2 olur (`tests/unit/koy/sabah_defteri_test.gd`). Zindanda cenaze çağrısı 0. Ad satırı sayısı 1.
  - Bağımlılık: SAB-04, SEV-07. Boyut: S.
  - Dosya: `src/koy/cenaze_yasi.gd` tek çağrı; yeni tören dosyası yok.
  - Asset: asset gerekmedi. Mezar yer tutucusu KRI-05'te durur.

## 28.4 Sonraki sabahlar

- [ ] **SAB-08:** İkinci sabah ekmeği sürer, yolu basmaz.
  - Ne: Gün 0'dan 1'e çıkar ve yeni CAS-07 kararı yazılmaz; zindan payı bir kez daha düşer, sürgün yolu ile nüfus düşüşü tekrar yazılmaz. İnfazda tezgâh kapalı kalır, cenaze ikinci kez çağrılmaz ve dedikodu kimliği ikinci satır basmaz.
  - Kabul: Zindanın ikinci sabahında erzak bir kez daha 1 azalır ve dedikodu satırı 1 kalır (`tests/unit/koy/sabah_defteri_test.gd`). Sürgünün ikinci sabahında nüfus deltası 0. Kayıt yüklenince gün artışı 0. Gün tavanı `data/koy/` içindedir, betiğe gömülü 3 sabiti yoktur.
  - Bağımlılık: SAB-05, SAB-06, SAB-07. Boyut: S.
  - Dosya: `src/koy/sabah_defteri.gd`.
  - Asset: asset gerekmedi.

- [ ] **SAB-09:** Üçüncü sabah tezgâha vekil yazmaz.
  - Ne: Gün 2 olunca `kapali` bayrağı sürer; haneden kimse usta yazılmaz, çırak varsa rütbesi artmaz ve yas bitse de tezgâh burada açılmaz. Zindan payı üçüncü kez düşer, erzak yoksa `ekmek_yok` durur ve yeni dedikodu satırı yazılmaz.
  - Kabul: Gün 2'de `kapali` tezgâh 1 ve otomatik işçi 0 olur (`tests/unit/koy/sabah_defteri_test.gd`). Üç sabahın ekmek toplamı zindanda 3, infazda 0 ve sürgünde 0'dır. Dördüncü sabah bu hükümden ekmek düşüşü 0.
  - Bağımlılık: SAB-08. Boyut: S.
  - Dosya: `src/koy/sabah_defteri.gd`.
  - Asset: asset gerekmedi.

- [ ] **SAB-42:** Sayaç optional
  - Ne: Sayaç optional. Eski kayıt günden başlar.
  - Kabul: Sayaç optional. Açılış 1. Test: `tests/unit/kvr/kayit_gocu_test.gd`.
  - Bağımlılık: KAY-04. Boyut: S.
  - Dosya: `src/sistemler/kayit_gocu.gd`
  - Asset: asset gerekmedi.

## 28.5 Hesap

- [ ] **SAB-10:** Üç sabahın sayıları kapanışta okunur.
  - Ne: Üçüncü sabahın sonunda kapanış yedi sayıyı okur: hüküm, hane kalanı, kapalı tezgâh, dedikodu, ekmek düşüşü, yol ve cenaze. Gün 2 olmadan kapanış görünmez; kapanış erzak, nüfus ve tezgâh yazmaz.
  - Kabul: Sürgünde cenaze 0 ve yol 1, infazda yol 0 ve cenaze 1, zindanda ekmek 3 ve yol 0 (`tests/unit/koy/sabah_defteri_test.gd`). Kişi kaydı yoksa kapanış `kayip` der, sayılar 0 yazılır ve sahne açık kalır.
  - Bağımlılık: SAB-09. Boyut: S.
  - Dosya: `src/koy/sabah_defteri.gd` kapanış sayımı.
  - Asset: asset gerekmedi.

## 28.6 Sabahın yeri

- [ ] **SAB-55:** Sabah nöbet raporunu yutmaz
  - Ne: NBT iki satırı durur, sabah onlardan birini anarsa tam listeyi basmaz.
  - Kabul: Tam liste 0. Test: NBT-07.
  - Bağımlılık: NBT-07 Boyut: S.
  - Dosya: `src/koy/sabah_defteri.gd`
  - Asset: asset gerekmedi.
- [ ] **SAB-56:** Sabah meclisi açmaz
  - Ne: Sabah meclisi açmaz. MCL kendi gecesi.
  - Kabul: Açılış 0 sabah fazında. Test: MCL-05.
  - Bağımlılık: MCL-05. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.
- [ ] **SAB-57:** Sabah zar atmaz
  - Ne: Sabah zar atmaz. ZAR 0.
  - Kabul: Sabah zar atmaz. 0. Test: ZAR-01.
  - Bağımlılık: ZAR-01. Boyut: S.
  - Dosya: `src/soz/zar_atisi.gd`
  - Asset: asset gerekmedi.

## 28.7 Ekmek

- [ ] **SAB-62:** Pay bitince sağlık düşer
  - Ne: Pay bitince sağlık düşer. YSM. Yeni hastalık yok.
  - Kabul: Düşüş 1 kaynak. Test: YSM-02.
  - Bağımlılık: YSM-02. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.
- [ ] **SAB-64:** Pay ölçümü DEN'dedir
  - Ne: Pay ölçümü DEN'dedir. Formül değişmez.
  - Kabul: Pay ölçümü DEN'dedir. Satır 1. Test: DEN.
  - Bağımlılık: DEN-05. Boyut: S.
  - Dosya: `src/sistemler/denge_olcumu.gd`
  - Asset: asset gerekmedi.

## 28.8 Yol

- [ ] **SAB-68:** Yol kapı kuyruğuna geri yazmaz
  - Ne: Yol kapı kuyruğuna geri yazmaz. Aynı gün gelen 0.
  - Kabul: Yol kapı kuyruğuna geri yazmaz. 0. Test: KAP-16.
  - Bağımlılık: KAP-16. Boyut: S.
  - Dosya: `src/arayuz/kapi_ekrani.gd`
  - Asset: asset gerekmedi.
- [ ] **SAB-69:** Yol eşiyse hane uyarısı
  - Ne: Yol eşiyse hane uyarısı. ACL. Köy silinmez.
  - Kabul: Yol eşiyse hane uyarısı. Silme 0. Test: ACL-02.
  - Bağımlılık: ACL-02. Boyut: S.
  - Dosya: `src/koy/`
  - Asset: asset gerekmedi.

## 28.9 Kadraj

- [ ] **SAB-75:** Sabah paneli köy ekranında durur.
  - Ne: Hüküm satırı köy ekranında bir panelde durur ve kapı kuyruğu kurulmadan okunur. Ayrı sabah sahnesi açılmaz; panel `rapor_bekle` ayarını kullanır ve ikinci anahtar açmaz.
  - Kabul: Satır varken köy ekranında panel 1 ve sabah sahnesi 0 (`tests/unit/koy/sabah_defteri_test.gd`). Kuyruk kurulmadan panel okunmuş olur. Bu panel için ayar anahtarı 1.
  - Bağımlılık: SAB-01. Boyut: S.
  - Dosya: `src/arayuz/koy_ekrani.gd`
  - Asset: asset gerekmedi.

- [ ] **SAB-78:** Uzun sabah kayar
  - Ne: Uzun sabah kayar. Kesilen glif 0.
  - Kabul: Uzun sabah kayar. 0. Test: GRV-15.
  - Bağımlılık: GRV-15. Boyut: S.
  - Dosya: `src/arayuz/koy_ekrani.gd`
  - Asset: asset gerekmedi.
- [ ] **SAB-80:** Eksik anahtar sabahı düşürmez
  - Ne: Eksik anahtar sabahı düşürmez. Nötr.
  - Kabul: Eksik anahtar nötr metin basar. Test: SYS-09.
  - Bağımlılık: SYS-09. Boyut: S.
  - Dosya: `src/koy/sabah_defteri.gd`
  - Asset: asset gerekmedi.

## 28.10 Sınır ve kapanış

Dördüncü ceza kodda üç kararla kapanmıştır. Kapanış paketi bu bölümdeki kabul satırlarının tekrarıydı.
