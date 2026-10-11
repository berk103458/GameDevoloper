# BÖLÜM 38 — Gece, kapı dışı ve özel olaylar

Faz 5 (DNY ve KAP-16 ile birlikte). Zemin:

- Gece sonu kartı `src/veri/olay_verisi.gd` (`id`, `baslik_anahtari`, `metin_anahtari`, `kosullar`, `agirlik`, `tek_sefer`, `secenek_anahtarlari`, `secenek_etkileri`, `ses`, `muzik`). Koşul anahtarları: `gece_min/max`, `perde`, `koyde[]`, `ayrildi[]`, `bayrak[]`, `bayrak_yok[]`, `nufus_min`, `sinif_min{}`, `ambar_max`, `akce_min`, `yapi_min{}`, `bar_max{}`, `sans`.
- `data/olaylar/` 34 kart: `ahi_haber`, `aydogdu_oba`, `ayse_tezgah`, `bebek`, `bey_daveti`, `dervis`, `dugun`, `ertugrul_haberi`, `harman`, `hasan_defter`, `hirsizlik`, `kacak_koylu`, `karaca_ocak`, `kervan`, `kitlik`, `kurt`, `miraen_cavus`, `mogol_duman`, `nogay_haber`, `okculuk`, `pazar_gunu`, `salgin`, `saruca_tohum`, `sorhan_damga`, `sur_catlak`, `tarla_cekirge`, `tarla_don`, `tarla_kuraklik`, `tarla_yagmur`, `tekfur_elcisi`, `thessra_afyon`, `vergi_tahsildari`, `yangin`, `yusuf_keci`.
- Sıra olayları `data/sira_olaylari/`: `sira_atlama`, `sira_bayilma`, `sira_kavga`, `sira_panik`, `sira_vazgecen`; adaptör `src/kapi/sira_atlama_adaptoru.gd`. BUG-19/20 kişi ve sonuç bağını yazar.
- Olasılıklar `data/ayarlar/oyun.tres`: `olay_olasiligi 0.75`, `sira_olay_olasiligi 0.35`.
- Boş gün KAP-16, boş günün köyde keyfi SEV-01, olay ön koşulu BUG-16, nüfus katmanı KAP-19, cenaze akışı KRI-05, gece raporu `gece_bilancosu.gd`.
- Kodda olay kartını Söz motoruna bağlayan, boş günü sahneye çeviren veya gece kapı dışı bir evre açan bir katman yoktur.

Bu bölüm `OlayVerisi` şemasını değiştirmez, 34 kartı silmez, KRI-05 cenazesini yeniden kurmaz. Kartları Söz, defter ve boş güne bağlar; şemaya uyan en çok iki yeni kart ekler (kadı, âşık). Ses ve müzik alanları durur, yeni ses üretilmez (R2 seslendirme yasağı).

Kimlikler OZL-01 … OZL-35. Asset üretilmez. Yeni dosya + ince adaptör. Bitince `[x]` ve ajan adı.

**Madde biçimi:** Ne, Kabul, Bağımlılık + Boyut, Dosya, Asset.

---

## 38.1 Var olan kart — şema aynı, bağ yeni

- [ ] **OZL-01:** Olay seçici BUG-16'dan geçer, ikinci seçici yoktur.
  - Ne: gece sonu kartı mevcut seçiciden gelir; BUG-16 koşulu (`bina_var`, `nufus_en_az`, `cocuk_var`, `yas_grubu`) ve KAP-19 katmanı okunur. Bu bölüm yeni havuz yazmaz.
  - Kabul: `olay_secici` adlı ikinci dosya 0. Test: tarama.
  - Bağımlılık: BUG-16, KAP-19. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **OZL-02:** Kart metni Söz dalına düşebilir.
  - Ne: seçilen kartın `id` değeri DIY-09 bağlamına `olay.<id>` anahtarı olarak girer; kapıda veya köyde o olayı anan kişi (tanık, eş, dönen yüz) ilgili dalı açar. Kart metni CSV'de kalır, ikinci kopya yazılmaz.
  - Kabul: kart gecesi + tanık → dal 1; kart yokken 0. Test: iki gece.
  - Bağımlılık: DIY-09. Boyut: S.
  - Dosya: yeni: `src/sistemler/olay_soz_bagi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OZL-03:** Kart seçimi deftere düşer.
  - Ne: oyuncunun kart seçeneği Bölüm 39 defterine "olay, gece, seçenek" satırı yazar; etki `secenek_etkileri` ile aynıdır, ikinci etki tablosu yoktur.
  - Kabul: seçim gecesi defter satırı 1. Test: defter.
  - Bağımlılık: HFZ-01. Boyut: S.
  - Dosya: defter adaptörü tek satır.
  - Asset: asset gerekmedi.
- [ ] **OZL-04:** `tek_sefer` kartı ikinci kez gelmez.
  - Ne: şemanın `tek_sefer` alanı korunur; bu bölüm onu ezer bir "tekrar izin" yazmaz.
  - Kabul: `dervis`, `dugun` tek_sefer ise 30 gecede en çok 1. Test: runner.
  - Bağımlılık: OZL-01. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **OZL-05:** Kart yoksa gece kilitlenmez.
  - Ne: BUG-16 havuzu boşsa (kural 2) kart çıkmaz; rapor "bu gece köy sessiz" satırı yazar, oyun devam eder.
  - Kabul: havuz boş + `olay_olasiligi` 1 olsa bile kart 0, faz geçer. Test: boş havuz.
  - Bağımlılık: BUG-16. Boyut: S.
  - Dosya: `gece_bilancosu.gd` adaptörü tek satır.
  - Asset: asset gerekmedi.

## 38.2 Sıra olayları — kapıda, kuyrukta

- [ ] **OZL-06:** Beş sıra olayı BUG-19/20 ile bağlanır, altıncı tür açılmaz.
  - Ne: `sira_atlama`, `sira_bayilma`, `sira_kavga`, `sira_panik`, `sira_vazgecen` durur. Yeni sıra kartı bu bölümde yazılmaz.
  - Kabul: `data/sira_olaylari/` dosya sayısı 5. Test: sayım.
  - Bağımlılık: BUG-19, BUG-20. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **OZL-07:** Sıra olayı Söz dalını açar.
  - Ne: kuyruktaki kişinin Söz dosyasında `sira.<id>` dalı varsa (bayılma yardımı, kavga ayırma) kartın yanında o dal bir kez sorulur; yoksa kart tek başına kalır.
  - Kabul: dalı olan kişide 1, olmayanda kart-only. Test: iki kişi.
  - Bağımlılık: DIY-03, OZL-06. Boyut: M.
  - Dosya: `src/sistemler/olay_soz_bagi.gd`; `sira_atlama_adaptoru.gd` tek satır.
  - Asset: asset gerekmedi.
- [ ] **OZL-08:** Sıra olayı boş günde (KAP-16) çıkmaz.
  - Ne: KAP-16 boş gününde kuyruk yoktur; `sira_olay_olasiligi` o gece 0 okunur.
  - Kabul: boş günde sıra olayı 0. Test: KAP-16 gecesi.
  - Bağımlılık: KAP-16. Boyut: S.
  - Dosya: sıra seçicine tek satır.
  - Asset: asset gerekmedi.

## 38.3 Boş gün — kapı kapalı, köy açık

- [ ] **OZL-09:** Boş gün SEV-01'dir, ikinci boş gün sistemi yoktur.
  - Ne: KAP-16 üretir, SEV-01 köyde keyfe çevirir. Bu bölüm yalnız "boş günde kart havuzu"nu bağlar: kapı kartı 0, köy kartı (pazar_gunu, harman, dugun koşulu tutarsa) 1 olabilir.
  - Kabul: boş günde kapı kuyruğu 0, köy kartı koşulu tutarsa 1. Test: iki gece.
  - Bağımlılık: KAP-16, SEV-01. Boyut: S.
  - Dosya: yeni: `src/sistemler/bos_gun_olayi.gd`.
  - Asset: asset gerekmedi.
- [ ] **OZL-10:** Boş günde âşık veya gezgin ozan gelebilir.
  - Ne: yeni kart `data/olaylar/asik.tres`, `OlayVerisi` şeması; koşul `nufus_min: 6`, `tek_sefer: false`, ağırlık düşük. Seçenek: dinle (moral +1, akçe 0) / gönder (etki 0). Mini oyun yok, ses üretilmez.
  - Kabul: nüfus 5'te 0, 6+'da çıkabilir; `secenek_etkileri` iki sözlük. Test: iki nüfus.
  - Bağımlılık: OZL-09, BUG-16. Boyut: S.
  - Dosya: `data/olaylar/asik.tres`; `metinler.csv` `olay.asik.*`.
  - Asset: asset gerekmedi (yer tutucu: duran köylü).
- [ ] **OZL-11:** Boş gün deftere "kapı yoktu" yazar.
  - Ne: HFZ defterine gece türü `bos_gun` satırı; gelen 0, kart varsa kart id.
  - Kabul: boş gün satırı 1. Test: defter.
  - Bağımlılık: HFZ-01, KAP-16. Boyut: S.
  - Dosya: defter adaptörü.
  - Asset: asset gerekmedi.

## 38.4 Takvim ve mevsim kartları

- [ ] **OZL-12:** Tarla kartları mevsim okur, ikinci takvim açmaz.
  - Ne: `tarla_yagmur`, `tarla_kuraklik`, `tarla_don`, `tarla_cekirge` mevcut `kosullar` ile durur; `takvim.gd` (`mevsim`, `kis_mi`) koşula bağlanır. Yeni mevsim sayacı yok (MEV-01 durur).
  - Kabul: kışta `tarla_yagmur` 0 (koşul yazılırsa); koşulsuz imza BUG-16 listesindedir. Test: dört mevsim.
  - Bağımlılık: BUG-16, MEV-01. Boyut: S.
  - Dosya: ilgili `.tres` `kosullar`.
  - Asset: asset gerekmedi.
- [ ] **OZL-13:** `harman` ve `pazar_gunu` hafta başına bakabilir.
  - Ne: `takvim.hafta_basi` true iken bu iki kartın ağırlığı artar (öneri `data/olay_agirlik.json`); kart id değişmez.
  - Kabul: hafta başı olmayan gecede ağırlık taban, başında çarpan. Test: 7 gece.
  - Bağımlılık: OZL-01. Boyut: S.
  - Dosya: yeni: `data/olay_agirlik.json`.
  - Asset: asset gerekmedi.
- [ ] **OZL-14:** Kış odunu kartı yoktur.
  - Ne: odun darlığı BUG-22 / DEN tablosudur; "kış odunu yok" diye yeni kart yazılmaz (32. bölüm sınırı).
  - Kabul: `olaylar/` içinde `kis_odun` id 0. Test: sayım.
  - Bağımlılık: DEN-01. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

## 38.5 Yaşam olayları — düğün, bebek, cenaze

- [ ] **OZL-15:** `dugun.tres` KAP-19 ve BUG-16 ile bağlanır, tören motoru açılmaz.
  - Ne: düğün kartı en az iki yetişkin hane ister (KAP-19 kural 3). Mini oyun, dans veya hediye takvimi yok.
  - Kabul: 3 kişilik köyde 30 gece `dugun` 0. Test: KAP-19 testi ile ortak.
  - Bağımlılık: KAP-19, BUG-16. Boyut: S.
  - Dosya: `data/olaylar/dugun.tres` koşul.
  - Asset: asset gerekmedi.
- [ ] **OZL-16:** `bebek.tres` `cocuk_var` tersine bakmaz, `hane_var` ister.
  - Ne: bebek kartı çocuk doğurur; koşul yetişkin çift / hane. KAP-17 çocuk modeli doğumda kullanılır, ikinci model yok.
  - Kabul: hanesiz köyde `bebek` 0. Test: birim.
  - Bağımlılık: KAP-17, BUG-16. Boyut: S.
  - Dosya: `data/olaylar/bebek.tres`.
  - Asset: KAP-17 çocuk. Yeni satır yok.
- [ ] **OZL-17:** Ölüm KRI-05'e gider, yeni cenaze kartı yazılmaz.
  - Ne: yangın, kurt, salgın, sıra ölümü (BUG-20) duran cenaze akışını çağırır. `cenaze.tres` diye ikinci kart yoktur.
  - Kabul: `data/olaylar/cenaze.tres` 0; ölüm → KRI-05 çağrı 1. Test: tarama + birim.
  - Bağımlılık: KRI-05, BUG-20. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **OZL-18:** Cenaze gecesi HUD `cenaze_raporu.gd` okunur.
  - Ne: `src/arayuz/koy_hud/cenaze_raporu.gd` durur; Söz bağında `olay.cenaze` anahtarı bu rapordan türetilir, yeni panel yok.
  - Kabul: cenaze gecesi rapor paneli 1, yeni dosya 0. Test: ekran.
  - Bağımlılık: KRI-05. Boyut: S.
  - Dosya: `olay_soz_bagi.gd` okuyucu.
  - Asset: asset gerekmedi.

## 38.6 Dış yüzler — kart ve kapı aynı kişi olmaz

- [ ] **OZL-19:** Heyet kartı ile kapı yüzü aynı gece çakışmaz.
  - Ne: `tekfur_elcisi`, `bey_daveti`, `vergi_tahsildari`, `aydogdu_oba`, `miraen_cavus` kartları, OMR-24 "bir gecede en çok bir dış hat yüzü" kuralına girer: o gece kapıda aynı id yüz olarak duruyorsa kart 0'dır.
  - Kabul: yüz + kart aynı id, aynı gece 0. Test: enjekte.
  - Bağımlılık: OMR-24. Boyut: S.
  - Dosya: `bos_gun_olayi.gd` değil; olay seçicine tek satır.
  - Asset: asset gerekmedi.
- [ ] **OZL-20:** Haber kartları DNY-02 ile tek kaynaktır.
  - Ne: `ertugrul_haberi`, `nogay_haber`, `mogol_duman`, `ahi_haber` yazılı haberdir; yüz gelmeden haber (OMR-36) bu kartlardan biri olabilir, ikinci haber kanalı açılmaz.
  - Kabul: aynı olay id için kart + haberci ağı satırı aynı gece en çok 1. Test: OMR-36 ile ortak.
  - Bağımlılık: DNY-02, OMR-36. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

## 38.7 Gece evresi — kapı kapandıktan sonra

- [ ] **OZL-21:** Gece evresi yeni faz değildir.
  - Ne: `oturum_fazi.gd` değerleri `kapi` / `koy` durur; üçüncü faz (`gece_devriye`) açılmaz. Nöbet NBT-09 oyuncunun köy ekranında kalmasıdır.
  - Kabul: faz enum'una yeni değer 0. Test: tarama.
  - Bağımlılık: NBT-09. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **OZL-22:** Nöbet tutulan gecede kart ertesi sabaha kayar.
  - Ne: oyuncu NBT-09 ile nöbetteyse gece kartı ertesi köy evresinde açılır; iki kart üst üste binmez.
  - Kabul: nöbet gecesi kart 0, ertesi köy evresi 1 (koşul tutarsa). Test: iki gece.
  - Bağımlılık: NBT-09, OZL-01. Boyut: S.
  - Dosya: olay seçicine tek satır.
  - Asset: asset gerekmedi.
- [ ] **OZL-23:** Gözcü kulesi gece olayı üretmez.
  - Ne: duran gözcü kulesi (R1) yalnız görüş mesafesidir; "kuleden görülen olay" diye kart yazılmaz.
  - Kabul: `olaylar/` içinde `kule` id 0. Test: sayım.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

## 38.8 Yeni kart — yalnız şemaya uyan, yalnız gerekçeli

- [ ] **OZL-24:** Kadı kartı.
  - Ne: `data/olaylar/kadi.tres`; koşul `nufus_min: 10`, `gece_min` BUG-18 tehdit süresinden sonra, `tek_sefer: true`. Seçenek: davayı dinle (divan CAS-07 oturumu açılır, kart divanı yeniden kurmaz) / geçiştir (adalet −1, `koy.tres harc_adalet` okunur). Kadı kapı yüzü değildir.
  - Kabul: nüfus 9'da 0; dinle → divan oturumu 1. Test: iki nüfus.
  - Bağımlılık: CAS-07, BUG-18, BUG-16. Boyut: M.
  - Dosya: `data/olaylar/kadi.tres`; `metinler.csv` `olay.kadi.*`.
  - Asset: asset gerekmedi (yer tutucu: duran köylü).
- [ ] **OZL-25:** Üçüncü yeni kart yoktur.
  - Ne: âşık (OZL-10) ve kadı (OZL-24) bu bölümün tavanıdır. "İleride lazım" kartı yazılmaz.
  - Kabul: bu dosyada `data/olaylar/` yeni id sayısı 2. Test: sayım.
  - Bağımlılık: OZL-10, OZL-24. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

## 38.9 Görünürlük ve yazım

- [ ] **OZL-26:** Kart metni `olay.` anahtarıdır (SYS-09).
  - Ne: yeni ve eski kartların `baslik_anahtari` / `metin_anahtari` / `secenek_anahtarlari` `olay.` önekine uyar; düz Türkçe `.tres` içinde yok.
  - Kabul: `tools/metin_dogrula.py --kaynak` olay katalogu 0 eksik. Test: araç.
  - Bağımlılık: SYS-09. Boyut: S.
  - Dosya: `data/metin/metinler.csv`.
  - Asset: asset gerekmedi.
- [ ] **OZL-27:** Kart USLUP §1'den geçer.
  - Ne: yeni iki kartın metni YAZ-10 yapaylık taramasından geçer; "köyünüzün geleceği" kalıbı yok.
  - Kabul: `olay.asik.*` ve `olay.kadi.*` ihlal 0. Test: YAZ-10.
  - Bağımlılık: YAZ-10. Boyut: S.
  - Dosya: CSV satırları.
  - Asset: asset gerekmedi.
- [ ] **OZL-28:** Kart HUD'u `BilgiEkrani` kadrajıdır, yeni sahne değildir.
  - Ne: gece kartı duran bilgi/olay kadrajında açılır; 3B tören sahnesi yok (SAH sınırı).
  - Kabul: `olay_sahnesi.tscn` 0. Test: tarama.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **OZL-29:** Olasılıklar `oyun.tres` / `denge.json` dışına çıkmaz.
  - Ne: `olay_olasiligi` ve `sira_olay_olasiligi` DEN-01 tablosuna taşınır (32 zaten ister); bu bölüm yeni sabit yazmaz.
  - Kabul: `.gd` içinde `0.75` / `0.35` olay sabiti 0. Test: tarama.
  - Bağımlılık: DEN-01. Boyut: S.
  - Dosya: `data/ayarlar/denge.json`.
  - Asset: asset gerekmedi.

## 38.10 Sınırlar ve kapanış

- [ ] **OZL-30:** `OlayVerisi` alan listesi değişmez.
  - Ne: yeni koşul veya etki anahtarı eklenmez; kadı "divan aç" etkisi mevcut `bayrak` / çağrı ile yapılır.
  - Kabul: `olay_verisi.gd` export alanı sayısı bu madde öncesi ile eşit. Test: `api_sozlesmesi.py`.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `tools/api_sozlesmesi_baseline.json`.
  - Asset: asset gerekmedi.
- [ ] **OZL-31:** Ses ve müzik üretilmez.
  - Ne: şemadaki `ses` / `muzik` alanları boş kalabilir; yeni wav/ogg yok. R2 seslendirme yasağı.
  - Kabul: `assets/ses/` sayısı değişmez. Test: sayım.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **OZL-32:** İkinci harita ve gece haritası yoktur.
  - Ne: bölge haritası (R1) durur; "gece dışarı çık" haritası açılmaz.
  - Kabul: `gece_haritasi` 0. Test: tarama.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **OZL-33:** 34 eski kart silinmez, id değişmez.
  - Ne: rename / delete yok; koşul alanı eklenebilir (BUG-16).
  - Kabul: 34 id listesi bu dosyanın zeminindedir; silinen 0. Test: sayım.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `data/olaylar/*.tres`.
  - Asset: asset gerekmedi.
- [ ] **OZL-34:** Kayıt göçü.
  - Ne: yeni kart id'leri eski kayıtta yoksa seçilmez; oyun çökmez.
  - Kabul: eski kayıt + yeni katalog açılır. Test: KAY zinciri.
  - Bağımlılık: KAY-04. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **OZL-35:** Kapanış testi.
  - Ne: tek koşu: BUG-16 boş havuz → kart 0; `dugun` küçük köyde 0; boş gün + âşık koşulu; kadı → divan; yüz+kart çakışması 0; KRI-05 ölüm yolu.
  - Kabul: altı iddia tek testte. Test: `tests/unit/olay/ozel_olay_test.gd`.
  - Bağımlılık: OZL-01…34. Boyut: M.
  - Dosya: yeni: `tests/unit/olay/ozel_olay_test.gd`.
  - Asset: asset gerekmedi.

Alt başlıklarda madde sayısı üç ile altı arasındadır; onuncu madde 34 kartın her birini yeniden tarif edeceği veya `OlayVerisi` şemasını şişireceği için konmadı. Toplam 35 madde. Yeni kart tavanı 2 (âşık, kadı).
