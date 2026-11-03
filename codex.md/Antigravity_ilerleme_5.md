# Antigravity İlerleme Dosyası — Görev 5

- **Ajan Adı:** Antigravity
- **Görev:** Görev 5 — Ahmet'in İstekleri (Bölüm 1) ve Ardından Yer Tutucu Metinler (Bölüm 2)
- **Çalışma Dalı:** `feature/diyalog-yeniden-yazim`
- **Başlangıç Zamanı:** 4 Kasım 2026 01:00

---

## Bölüm 1 — Ahmet'in İstekleri

### Parti 1: 1A — Kapı Sorgularında Tekrar Eden Soruları Düzeltme (Tamamlandı)

Ahmet'in tespiti doğrultusunda 20 kapı ziyaretçisinin tamamı (`diyalog_01` – `diyalog_20`) incelendi. Ziyaretçinin açılış konuşmasında (`acilis`) zaten verdiği bilgileri (nereden geldiği, mesleği, dükkânına/köyüne ne olduğu, ne taşıdığı vb.) dikkatsizce tekrar soran tüm kök ve alt sorular tespit edildi; bunlar açılışı kurcalayan, çelişki yakalayan ve iddiaları test eden derinleştirilmiş takip sorularına dönüştürüldü:

1. **`diyalog_01` (Erzincanlı Çiftçi):** Açılışta henüz Erzincan adı geçmeden muhafızın doğrudan "Erzincan'dan bu yana..." demesi düzeltildi; "Arkamda Moğol atlarının çiğnediği ova kaldı dedin rençber; ovadaki beylik tarlaları yandıysa hangi boğazı aşıp bu dağ geçidine saptın?" sorusuna çevrildi. Tohumu gizleme sorusu da açılıştaki "tohumu çiğnetmem" iddiasını kurcalayan soruya bağlandı (`zahire_hirsizi_suphesi`, `muhur_tahrif_suphesi` bayrakları bağlandı).
2. **`diyalog_02` (Kayseri Kumaşçısı):** "Kayseri çarşısı kül oldu derler, doğru mudur?" tekrarı kaldırıldı; "Tezgâhım duman oldu dedin; bedestendeki Ahi kethüdası tüccarlara sahip çıkmadı mı, yangını kim başlattı?" sorusuna dönüştürüldü (`gizli_akce_suphesi`).
3. **`diyalog_03` (Sivas Bozgun Askeri):** Açılışta "Sultan uzakta, dirlik bozuldu" demişken sorulan "Sivas kalesinde dirlik kaldı mı?" tekrarı silindi; "Sultan uzakta, dirlik bozuldu dedin nefer; Sivas Kalesi'ndeki subaşı sancağı terk mi etti, orduyu kim dağıttı?" sorusuna çevrildi (`firari_asker`).
4. **`diyalog_04` (Yaylası Yanan Çoban):** Açılışta sürüyü dağa saldığını söylemişken "sürüyü kime bıraktın?" sorusu kaldırıldı; "Yaylayı Moğol atlıları yaktı dedin; sürüyü dağa salıp kaçarken neden bu iki cılız koyunu peşine taktın, yük olmaz mıydı?" sorusuna dönüştürüldü (`suru_hastaligi_riski`).
5. **`diyalog_05` (Örssüz Demirci):** Açılışta örsün kalmadığını söylemişken "Örssüz demirci mi olur, örs nerede?" sorusu düzeltildi; Ahi loncası pirinden destur alıp almadığını sorgulayan "Örsüm kalmadı, körük yandı dedin; bir demirci ocağını terk ederken Ahi loncasının pirinden destur aldın mı, çırağın kalfan nerededir?" sorusuna çevrildi (`kacak_kalfa`).
6. **`diyalog_06` (Miğferi Yamuk Piyade):** Kılıcını harami pususunda kaybettiğini söyleyen nefere kılıcını ekmeğe sattın suçlaması yerine; "Erzincan boğazında harami pususunda kılıcımı kaybettim dedin; koca bölük pusuda dağılırken subaşınız neredeydi, haramiler boğazı nasıl tuttu?" sorusu bağlandı (`pusat_kaybi`).
7. **`diyalog_07` (Kağnısı Devrilen Çiftçi):** "Köyünüzü yakanlar kimlerdi?" genel sorusu yerine; "Köyünüz ateşe verildi dedin rençber; ovadaki Ahi dirliklerine haber salmadınız mı, kaçarken o dar patikada seni kimse görmedi mi?" sorusuna çevrildi (`yikilmis_koy`).
8. **`diyalog_08` (Çarşıdan Kaçan Saraç):** "Dükkânına ne oldu senin?" şeklindeki doğrudan tekrar sorusu kaldırıldı; "Çarşı kül oldu, dükkândan zor kaçtım dedin; koca saraçlar çarşısında yangın nereden çıktı, lonca kethüdası dükkânları korumadı mı?" sorusuna dönüştürüldü (`kacak_sarac`).
9. **`diyalog_09` (Uç Kemankeşi):** Açılışta son okuna kadar vuruştuğunu söyleyen okçuya "sadak niye bomboş, oklarını kime savurdun?" tekrarı kaldırıldı; "Dağ geçidinde son okuma kadar vuruştum dedin; vurduğun haramiler hangi boydandı, arkadan gelen Türkmen kafilesini dağda kim tuttu?" sorusu getirildi (`bos_sadak_kemankes`).
10. **`diyalog_10` (Bostancı Genç):** "Obamız kuraklıktan ve baskından dağıldı dedin; obanın beyi nereye çekildi, yolda rastladığın o yetimlerin anası babası neredeydi?" sorusuyla açılış iddiası kurcalandı (`fedakar_genc`).
11. **`diyalog_11` (Yaralı Levent):** "Taş köprüyü iki gün iki gece tuttuk dedin; köprünün diğer başındaki kale garnizonu neden yardıma gelmedi, bent nasıl yarıldı?" sorusuyla köprünün düşüşü doğrulandı (`yarali_gazi`).
12. **`diyalog_12` (Kalaycı Esnaf):** "Pazar yeri basılınca dere boyundan kaçtım dedin; heybendeki bakır taslar vadi boyunca şıngırdarken haramiler peşine nasıl düşmedi?" sorusuyla kurnazlığı ve şüphesi irdelendi (`supheli_bakirci`).
13. **`diyalog_13` (Topal Oğlaklı Çoban):** "Haramiler ağılı bastığında bu topal oğlağı bırakamadım dedin; sürü dağa kaçarken o haramilerin reisi kimdi, seni neden dere boyunda vurmadılar?" sorusuna dönüştürüldü (`topal_oglak`).
14. **`diyalog_14` (Kaya Tuzu Tüccarı):** Katırlar açılışta geçmişken deve denilen uyumsuzluk giderildi: "Tuz gölü kervanı bozkırda vuruldu dedin; katırlar uçuruma sürülürken o güzergahtaki han muhafızları neredeydi, sen kuşağındaki tuzu nasıl sakladın?" sorusuna çevrildi (`tuz_kervani_kacak`).
15. **`diyalog_15` (Kule Borazancısı):** Boruyu çalıp çalmadığı tekrarı yerine; "Meşaleyi yaktım amma kule ateşe verildi dedin; boruyu kule düşmeden önce kaç kez çaldın, ovadaki nöbetçi çavuşu işaretini almadı mı?" sorusu bağlandı (`borazanci_korkaklik_ithami`).
16. **`diyalog_16` (Bağ Bekçisi):** "Vadideki bağları kim yaktı, neden kaçtın?" tekrarı kaldırıldı; "Aşağı vadinin bağ bekçisiyim dedin; oranın üzümü beyliğin kilerine giderdi, bağı yakanlar köylüye ne yaptı, seni neden sağ bıraktılar?" sorusuna çevrildi (`saraplik_bag_suphesi`).
17. **`diyalog_17` (Kantarcı Esnaf):** "Menzil hanında pazar dağıtıldı dedin; handaki kervancıbaşı nerede, terazini kuşağına sokarken hancıyı ya da nöbetçileri görmedin mi?" sorusuyla doğrulandı (`hileli_dirhem`).
18. **`diyalog_18` (Hendek Irgatı):** "Şantiye basılınca küreği kapıp menfezden kaçtım dedin; omzundaki o koca morluk kaçarken taş çarpması mıdır, yoksa kale dizdarının sopası mı?" sorusuyla omzundaki morluk çelişkisi irdelendi (`rusvetci_dizdar_tanigi`).
19. **`diyalog_19` (Fırıncı Usta):** "Fırına atlılar dalınca hamur teknesiyle un bacasından fırladım dedin; o daracık bacadan koca tekneyi nasıl geçirdin, arkandaki un çuvallarına ne oldu?" sorusuyla bacadan kaçış hikâyesi kurcalandı (`zehirli_un_suphesi`).
20. **`diyalog_20` (Seyyar Nalbant):** "Aygır zincirini kırdı, nal çivisi topuğuma girdi dedin; ayağına çivi batmış bir adam o hendek menfezinden nasıl geçti, haramiler seni neden vurmadı?" sorusuyla topuk yarası ve kaçış açılışına bağlandı (`harami_ati_nali`).

- **Teknik Entegrasyon:** `src/sistemler/oturum.gd` içindeki `_json_sorular()` fonksiyonuna 4. parametre olarak bayrak desteği eklendi. Sorular sorulduğunda `Gelen.soru_soruldu()` üzerinden `acik_bayraklar` listesine güvenle aktarılması sağlandı.
- **Doğrulama:**
  - `tests/unit/diyalog/diyalog_butunluk_test.gd`: GEÇTİ (0 hata).
  - `tests/unit/kvr/diyalog_mantigi_test.gd`: GEÇTİ (0 hata).
  - `tools/metin_dogrula.py`: PASS.
  - `tools/soz_tasarimi_dogrula.py`: GEÇTİ.

---

## Sıradaki Adım
- Parti 2: 1B — Eşle Konuşma: Çok Kapsamlı Parley Diyalog Ağaçları (`koylu_muhabbet_es.ds`) ve Köy/Oda Adaptörü.
