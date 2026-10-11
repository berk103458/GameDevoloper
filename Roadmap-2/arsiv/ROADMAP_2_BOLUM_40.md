# BÖLÜM 40 — Diyalog kalite güvencesi ve yazım hattı

Faz 3 (YAZ-04…10 ve DYL-11…16 ile birlikte). Zemin:

- Yazım hattı YAZ-01…10 (dünya kitabı, üslup, üretim, doğrulama, kota, satır inceleme).
- Yazım araçları 25.3: DYL-11 kör okuma, DYL-12 muhafız tipi tarama, DYL-13 eski/yeni yan yana, DYL-14 kaynaklı örnek, DYL-15 sitede düzenleme, DYL-16 prototip `--check`.
- Prototip `Roadmap-2/soz_agaci/yapaylik.js`, `motor.js`, `sahne_recber.js`. Oyun tarafı `tools/metin_dogrula.py`, `docs/METIN_ANAHTAR_STANDARDI.md`.
- Tester planı K7: diyalog kalitesi elle; otomatik yapaylık taraması yok. TST-0002 (6 eksik anahtar), TST-0006 (çift boşluk, yinelenen tekfur metni) AÇIK.
- Kodda `data/soz/` üretim kapısı ve CI yapaylık adımı yoktur (YAZ-04 onları tanımlar; bu bölüm kapıyı ölçülebilir kılar).

Bu bölüm DYL-11…16'yı kopyalamaz, YAZ maddelerini yeniden yazmaz. Onların çıktısını kabul ölçütüne, tarama sırasına ve "oyuna girer / girmez" kararına bağlar. Yeni diyalog içeriği buradan üretilmez.

Kimlikler KLT-01 … KLT-75. Bitince `[x]` ve ajan adı.

**Madde biçimi:** Ne, Kabul, Bağımlılık + Boyut, Dosya, Asset.

---

## 40.1 Hattın sırası — oyuna girmeden önce

- [ ] **KLT-01:** Üretim sırası tek belgededir.
  - Ne: sıra sabittir: YAZ-01 kitap → taslak → YAZ-10 yapaylık → DYL-11 kör okuma → YAZ-09 kota → insan onayı → YAZ-04 `data/soz/`. Sıra atlanırsa dosya oyuna alınmaz.
  - Kabul: `docs/soz/HAT.md` içinde sıra; atlanan adımlı dosya YAZ-04 tarafından reddedilir. Test: onaysız dosya 0 kopya.
  - Bağımlılık: YAZ-04, YAZ-10, DYL-11. Boyut: S.
  - Dosya: yeni: `docs/soz/HAT.md`.
  - Asset: asset gerekmedi.
- [ ] **KLT-02:** Onay iki isimdir (YAZ-01 kural 4).
  - Ne: anlatı yönetmeni + Ahmet; tek isim yetmez. Bu madde ikinci onay süreci açmaz.
  - Kabul: tek isimli dosya reddedilir. Test: YAZ-04. Taşınan: KLT-49: İki isimden biri boşsa red.
  - Bağımlılık: YAZ-01. Boyut: S.
  - Dosya: `HAT.md`.
  - Asset: asset gerekmedi.
- [ ] **KLT-03:** Şablon sır dayatmaz (DIY-01a).
  - Ne: kapı denetimi `soz` dosyasında `sira` alanı yoksa kabul; varsa ve zorunluysa red. DIY-01a kuralı burada ölçülür.
  - Kabul: zorunlu sırası olan dosya 1 hata. Test: birim.
  - Bağımlılık: DIY-01a. Boyut: S.
  - Dosya: yeni: `tools/soz_kapi.py`.
  - Asset: asset gerekmedi.

- [ ] **KLT-26:** Adım kutusu tek dosyadır
  - Ne: Adım kutusu tek dosyadır. Geçen adım `HAT.md` kutusuna yazılır.
  - Kabul: Kutusuz kopya 0. Test: kapı.
  - Bağımlılık: KLT-01. Boyut: S.
  - Dosya: `docs/soz/HAT.md`
  - Asset: asset gerekmedi.
- [ ] **KLT-27:** Sebepsiz adım atlama reddedilir
  - Ne: Sebepsiz adım atlama reddedilir. Atlama satırında sebep yoksa kopya yoktur.
  - Kabul: Sebepsiz 1 hata. Test: fixtures.
  - Bağımlılık: KLT-01. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.
- [ ] **KLT-28:** Kapı Godot başlatmaz
  - Ne: Kapı Godot başlatmaz. Doğrulayıcı oyun sürecini açmaz.
  - Kabul: Süreç 0. Test: tarama.
  - Bağımlılık: KLT-01. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.
- [ ] **KLT-29:** Kapı anahtar silmez
  - Ne: Kapı anahtar silmez. CSV'den satır silinmez.
  - Kabul: Silinen 0. Test: diff.
  - Bağımlılık: SYS-09. Boyut: S.
  - Dosya: `data/metin/metinler.csv`
  - Asset: asset gerekmedi.
- [ ] **KLT-30:** Hata kopyayı keser, uyarı kesmez
  - Ne: Hata kopyayı keser, uyarı kesmez. İki seviye karışmaz.
  - Kabul: Hata 0 kopya, uyarı 1 kopya. Test: fixtures.
  - Bağımlılık: KLT-04. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.

## 40.2 Otomatik taramalar — DYL araçlarını çağırır

- [ ] **KLT-04:** Yapaylık taraması CI adımıdır.
  - Ne: `yapaylik.js` kuralları (USLUP §1) `tools/soz_kapi.py` içinden çağrılır; ihlal 0 olmadan `data/soz/` kopyalanmaz. DYL-16 `--check` aynı dosyayı kullanır, ikinci kural seti yok.
  - Kabul: bilinen yasak kalıp 1 hata. Test: fixtures.
  - Bağımlılık: YAZ-10, DYL-16. Boyut: M.
  - Dosya: `tools/soz_kapi.py`.
  - Asset: asset gerekmedi.
- [ ] **KLT-05:** Kör okuma skoru kayda geçer (DYL-11).
  - Ne: DYL-11 testi yapılmadan karakter dosyası "hazır" olmaz; skor `docs/soz/kor_okuma.csv` satırıdır. Eşik DYL-11'indir, burada icat edilmez.
  - Kabul: skor satırı olmayan id YAZ-04 red. Test: kapı.
  - Bağımlılık: DYL-11. Boyut: S.
  - Dosya: `docs/soz/kor_okuma.csv`.
  - Asset: asset gerekmedi.
- [ ] **KLT-06:** Kota raporu YAZ-09'dan okunur.
  - Ne: sır, dinleyici, dedikodu çekirdeği (SOY-27) yüzdeleri; aşım red.
  - Kabul: dedikodu > %20 (SOY-27 öneri) → 1 hata. Test: kota.
  - Bağımlılık: YAZ-09, SOY-27. Boyut: S.
  - Dosya: `soz_kapi.py`.
  - Asset: asset gerekmedi.

- [ ] **KLT-31:** Yasak kalıp USLUP §1 dışına taşmaz
  - Ne: Yasak kalıp USLUP §1 dışına taşmaz. İkinci yasak dosyası yok.
  - Kabul: Dosya 1. Test: tarama.
  - Bağımlılık: YAZ-02. Boyut: S.
  - Dosya: `USLUP_REHBERI.md`
  - Asset: asset gerekmedi.
- [ ] **KLT-32:** Aynı iskelet iki ağızda uyarır
  - Ne: Aynı iskelet iki ağızda uyarır. Bilgi aynı, sıra aynıysa 1 uyarı.
  - Kabul: Uyarı 1. Test: fixtures.
  - Bağımlılık: YAZ-09. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.
- [ ] **KLT-33:** Ünlem yığılması uyarır
  - Ne: Ünlem yığılması uyarır. Üç ünlem 1 uyarı. Diyalog satırında.
  - Kabul: Uyarı 1. Test: fixtures.
  - Bağımlılık: YAZ-02. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.
- [ ] **KLT-34:** Oyuncu yönergesi diyalogda reddedilir
  - Ne: Oyuncu yönergesi diyalogda reddedilir. 'Tıkla', 'menüye dön' ağızda 1 hata. İpucu anahtarı hariç.
  - Kabul: Hata 1. Test: fixtures.
  - Bağımlılık: YAZ-02. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.
- [ ] **KLT-35:** Rakamla yıl ağızda reddedilir
  - Ne: Rakamla yıl ağızda reddedilir. 1240 veya 1243 karakter satırında 1 hata. Kitapta serbest.
  - Kabul: Hata 1. Test: fixtures.
  - Bağımlılık: YAZ-02. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.

## 40.3 Tutarlılık — ölü, giden, çelişki

- [ ] **KLT-07:** Ölü veya ayrılmış kişi anılmaz.
  - Ne: `koyde[]` / `ayrildi[]` koşulu tutmayan satırda o kişinin adı geçiyorsa tarama hatası (Valve olgu listesi, DIY-09).
  - Kabul: ayrılmış id + ad geçen satır 1 hata. Test: fixtures. Taşınan: KLT-36: Ayrılan kişi koşulsuz anılmaz.
  - Bağımlılık: DIY-09. Boyut: S.
  - Dosya: `soz_kapi.py`.
  - Asset: asset gerekmedi.
- [ ] **KLT-08:** Aynı gün iki zıt olgu.
  - Ne: aynı `gece` ve aynı `olay_id` için iki `dogru=true` çelişik beyan tarama uyarısıdır; DNY-02 kural 1 kasıtlı çelişkiyse `kasitli_celiski` işareti gerekir.
  - Kabul: işaretsiz çelişki 1 uyarı. Test: fixtures.
  - Bağımlılık: DNY-02, SOY-25. Boyut: S.
  - Dosya: `soz_kapi.py`.
  - Asset: asset gerekmedi.
- [ ] **KLT-09:** Yer ve bina adı BUG-16 listesindedir.
  - Ne: satırdaki bina adı `bina_var` veya koşulsuz imza listesinde değilse hata (BUG-17 gazete kuralının Söz hali).
  - Kabul: olmayan bina adı 1 hata. Test: fixtures.
  - Bağımlılık: BUG-16, BUG-17. Boyut: S.
  - Dosya: `soz_kapi.py`.
  - Asset: asset gerekmedi.

- [ ] **KLT-37:** Aynı gece iki doğru çelişki işareti ister
  - Ne: Aynı gece iki doğru çelişki işareti ister. İşaretsiz çift 1 uyarı. KLT-08.
  - Kabul: Uyarı 1. Test: fixtures.
  - Bağımlılık: KLT-08. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.
- [ ] **KLT-39:** Olmayan meslek ağızda reddedilir
  - Ne: Olmayan meslek ağızda reddedilir. Meslek listesi `meslek_yapilari` dışındaysa 1 hata.
  - Kabul: Hata 1. Test: fixtures.
  - Bağımlılık: ISG-01. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.
- [ ] **KLT-40:** Çocuk ağzı iş emri vermez
  - Ne: Çocuk ağzı iş emri vermez. Çocuk düğümünde iş atama fiili 1 uyarı.
  - Kabul: Uyarı 1. Test: fixtures.
  - Bağımlılık: UZM-08. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.

## 40.4 Metin anahtarı ve CSV

- [ ] **KLT-10:** TST-0002 altı eksik anahtar kapanır.
  - Ne: eski: TST-0002. `metin_dogrula.py --kaynak` 0 eksik anahtar olmadan bu madde açık kalır. Yeni sistem değil, açık bulgu.
  - Kabul: `GuvenliMetin.eksikler` uzunluğu 0 (temiz tur). Test: araç. Taşınan: KLT-41: Eksik anahtar listesi tektir.
  - Bağımlılık: SYS-09. Boyut: S.
  - Dosya: `data/metin/metinler.csv`.
  - Asset: asset gerekmedi.
- [ ] **KLT-11:** TST-0006 çift boşluk ve tekfur ikizi.
  - Ne: eski: TST-0006. `arayuz.oyun.kenar`, `arayuz.oyun.tam` tek boşluk; `anlati.saldiri.guc` ya yetimdir (kaldır) ya `koy.olay.tekfur_baskini` ile birleşir. Anahtar silme SYS-09 kuralına aykırıysa yetim belgelenir, metin eşitlenir.
  - Kabul: iki satırda çift boşluk 0; iki metin çelişmez. Test: `metin_dogrula.py` kural + inceleme. Taşınan: KLT-42: Çift boşluk sohbet önekine de bakar.
  - Bağımlılık: SYS-09. Boyut: S.
  - Dosya: `metinler.csv`.
  - Asset: asset gerekmedi.
- [ ] **KLT-12:** `ogretici.` uzunluk kuralı (OGR-08) kapıdadır.
  - Ne: `ogretici.*` ≤ 90 karakter; `soz_kapi.py` bunu `metin_dogrula` ile paylaşır, ikinci limit yazılmaz.
  - Kabul: 91 karakter 1 hata. Test: fixtures.
  - Bağımlılık: OGR-08. Boyut: S.
  - Dosya: `metin_dogrula.py`.
  - Asset: asset gerekmedi.

- [ ] **KLT-43:** Yer tutucu fazlası hatadır
  - Ne: Yer tutucu fazlası hatadır. Kod argümanından fazla `%s` 1 hata.
  - Kabul: Hata 1. Test: araç.
  - Bağımlılık: YER-02. Boyut: S.
  - Dosya: `tools/metin_dogrula.py`
  - Asset: asset gerekmedi.
- [ ] **KLT-44:** Mükerrer anahtar hatadır
  - Ne: Mükerrer anahtar hatadır. Aynı anahtar iki satır 1 hata. Silme yok, ikincisi red.
  - Kabul: Hata 1. Test: araç.
  - Bağımlılık: SYS-09. Boyut: S.
  - Dosya: `tools/metin_dogrula.py`
  - Asset: asset gerekmedi.
- [ ] **KLT-45:** Tırnak kırığı satırı yutar
  - Ne: Tırnak kırığı satırı yutar. Standart §2. Kırık tırnak 1 hata, sonraki anahtar kurtulur.
  - Kabul: Hata 1, sonraki anahtar durur. Test: fixtures.
  - Bağımlılık: SYS-09. Boyut: S.
  - Dosya: `tools/metin_dogrula.py`
  - Asset: asset gerekmedi.

## 40.5 İnsan incelemesi — araçları tekrar tarif etmez

- [ ] **KLT-13:** DYL-13 yan yana bakış kapı adımıdır.
  - Ne: eski/yeni metin bakılmadan "taşındı" sayılmaz. DIY-16 eski diyalogları taşımama kararı durur; bakış, silinenle yeninin aynı ağız olmadığını doğrular.
  - Kabul: bakış kaydı olmayan karakter "hazır" değil. Test: `HAT.md` kutusu.
  - Bağımlılık: DYL-13, DIY-16. Boyut: S.
  - Dosya: `docs/soz/HAT.md`.
  - Asset: asset gerekmedi.
- [ ] **KLT-14:** DYL-14 örnek defteri yazarın elindedir.
  - Ne: "bir köylü buna nasıl cevap verir?" sorusu üretimde zorunlu; çıktı DYL-14 defterine gider, burada ikinci defter yok.
  - Kabul: örnek satırı 0 olan taslak red. Test: kapı.
  - Bağımlılık: DYL-14. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **KLT-15:** DYL-12 son dağılımı yazım kapısı değildir.
  - Ne: muhafız tipi tarama denge içindir (32); yazım hattını kilitlemez. Bu madde o taramayı buraya taşımaz.
  - Kabul: `soz_kapi.py` içinde son eşiği 0. Test: tarama.
  - Bağımlılık: DYL-12, DEN. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

- [ ] **KLT-46:** Kör okuma satırı silinmez
  - Ne: Kör okuma satırı silinmez. Skor dosyasında eski satır kalır, üstüne yazılırsa tarih düşer.
  - Kabul: Silinen id 0. Test: diff.
  - Bağımlılık: DYL-11. Boyut: S.
  - Dosya: `docs/soz/kor_okuma.csv`
  - Asset: asset gerekmedi.
- [ ] **KLT-47:** Örnek cümle kadro adıdır
  - Ne: Örnek cümle kadro adıdır. Örnekteki ad kadroda yoksa 1 hata.
  - Kabul: Hata 1. Test: fixtures.
  - Bağımlılık: DYL-14. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.
- [ ] **KLT-48:** Yan yana bakış eski metni kopyalamaz
  - Ne: Yan yana bakış eski metni kopyalamaz. Eski cümle `data/soz` içine düşerse 1 hata.
  - Kabul: Hata 1. Test: diff.
  - Bağımlılık: DIY-16. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.
- [ ] **KLT-50:** İnceleme kutusu satır sayısı dosya satırına eşittir
  - Ne: İnceleme kutusu satır sayısı dosya satırına eşittir. Eksik satır 1 hata.
  - Kabul: Hata 1. Test: sayım.
  - Bağımlılık: YAZ-10. Boyut: S.
  - Dosya: `docs/soz/HAT.md`
  - Asset: asset gerekmedi.

## 40.6 Prototip ve oyun aynı sonuç

- [ ] **KLT-16:** DYL-16 `--check` kapanmadan `data/soz/` şişmez.
  - Ne: prototip motoru ile oyun adaptörü aynı fixtures'ta aynı dalı seçer. KOP söz adaptörü imzası değişmez.
  - Kabul: `--check` 0 fark. Test: DYL-16.
  - Bağımlılık: DYL-16, KOP. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **KLT-17:** DYL-15 sitede düzenleme üretim aracıdır, oyun içi editör değildir.
  - Ne: oyuncu Söz dosyası düzenlemez; madde sınırı koyar.
  - Kabul: `src/` içinde soz editörü 0. Test: tarama. Taşınan: KLT-52: Site editörü `src` altında değildir.
  - Bağımlılık: DYL-15. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

- [ ] **KLT-53:** Prototip kaydı onay bezemez
  - Ne: Prototip kaydı onay bezemez. Site kaydı HAT onayı sayılmaz.
  - Kabul: Onaysız kopya 0. Test: kapı.
  - Bağımlılık: YAZ-04. Boyut: S.
  - Dosya: `Roadmap-2/soz_agaci/`
  - Asset: asset gerekmedi.
- [ ] **KLT-54:** JS ve GDScript aynı seçim kimliğini verir
  - Ne: JS ve GDScript aynı seçim kimliğini verir. Bir fixtures.
  - Kabul: Fark 0. Test: DYL-16.
  - Bağımlılık: DIY-02. Boyut: S.
  - Dosya: `src/soz/soz_motoru.gd`
  - Asset: asset gerekmedi.
- [ ] **KLT-55:** Fixtures içine düz Türkçe gömülmez
  - Ne: Fixtures içine düz Türkçe gömülmez. Anahtar kullanılır.
  - Kabul: Düz cümle 1 hata. Test: tarama.
  - Bağımlılık: SYS-09. Boyut: S.
  - Dosya: `Roadmap-2/soz_agaci/`
  - Asset: asset gerekmedi.

## 40.7 Tester köprüsü

- [ ] **KLT-18:** Tester K7 kör noktası bu kapıya bağlanır.
  - Ne: tur raporunda `soz_kapi.py` özeti bir satır: ihlal, kota, eksik anahtar. Persona "hikâye odaklı" (TESTER planı §3) diyalog dalını gezer; kalite puanı kanaat değildir, kapı sayısıdır.
  - Kabul: tur raporunda `soz_kapi` satırı. Test: örnek rapor. Taşınan: KLT-56: Tur satırı `soz_kapi` özetidir.
  - Bağımlılık: ADM-16. Boyut: S.
  - Dosya: tester rapor şablonu (oyun deposu `docs/tester/`, bu klasörden yazılmaz — madde oraya işaret eder).
  - Asset: asset gerekmedi.
- [ ] **KLT-19:** Ses testi yoktur.
  - Ne: tester K6 (ses) ve R2 seslendirme yasağı; bu bölüm ses taraması açmaz.
  - Kabul: `soz_kapi.py` içinde ses kuralı 0. Test: tarama. Taşınan: KLT-58: Ses turu açılmaz.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

- [ ] **KLT-57:** Hikâye personası dal gezmez diye kalite puanı yazılmaz
  - Ne: Hikâye personası dal gezmez diye kalite puanı yazılmaz. Puan kapı sayısıdır. Kanaat satırı raporda 0.
  - Kabul: Kanaat 0. Test: şablon.
  - Bağımlılık: KLT-18. Boyut: S.
  - Dosya: `docs/tester/`
  - Asset: asset gerekmedi.
- [ ] **KLT-59:** Tester metin silmez
  - Ne: Tester metin silmez. CSV yaması tester işi değildir.
  - Kabul: Yazım 0. Test: tarama.
  - Bağımlılık: TST-0006. Boyut: S.
  - Dosya: `docs/tester/`
  - Asset: asset gerekmedi.
- [ ] **KLT-60:** Kapı kırmızıysa tur diyaloğu geçti sayılmaz
  - Ne: Kapı kırmızıysa tur diyaloğu geçti sayılmaz. Sanity yeşil olsa da kapı kırmızıysa diyalog kutusu açık kalır.
  - Kabul: Kutu açık. Test: örnek.
  - Bağımlılık: KLT-04. Boyut: S.
  - Dosya: `docs/soz/HAT.md`
  - Asset: asset gerekmedi.

## 40.8 Kapsam ve kota disiplini

- [ ] **KLT-20:** Her karakterin sırrı yoktur (YAZ-09).
  - Ne: kapı, kadroda sır çekirdeği kotasını okur; %100 sır red.
  - Kabul: kota aşımı 1 hata. Test: YAZ-09. Taşınan: KLT-61: Sır kotası yüzde yüzü reddeder.
  - Bağımlılık: YAZ-09. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **KLT-21:** Hitap türü kota notudur, sistem değildir.
  - Ne: karar kaydı 10; `hitap` alanı oyun mekaniği açmaz.
  - Kabul: `hitap_puani` 0. Test: tarama. Taşınan: KLT-63: Hitap puanı alanı açılmaz.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

- [ ] **KLT-64:** Dinleyici kotası ayrı sütundur
  - Ne: Dinleyici kotası ayrı sütundur. Sır ile toplanmaz.
  - Kabul: Tek sütun 0. Test: rapor.
  - Bağımlılık: YAZ-09. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.
- [ ] **KLT-65:** Kota dosyası `kurallar.json` ile çelişirse kapı durur
  - Ne: Kota dosyası `kurallar.json` ile çelişirse kapı durur. İki sayı. Büyük olan değil, kapı hatası.
  - Kabul: Hata 1. Test: fixtures.
  - Bağımlılık: YAZ-09. Boyut: S.
  - Dosya: `data/soz/kurallar.json`
  - Asset: asset gerekmedi.

## 40.9 Dosya ve araç sınırı

- [ ] **KLT-22:** Dünya kitabı çalışma anında okunmaz (YAZ-01).
  - Ne: `docs/dunya_kitabi/` `res://` altına kopyalanmaz.
  - Kabul: export'ta kitap yolu 0. Test: export listesi. Taşınan: KLT-66: Kitap export'a girmez.
  - Bağımlılık: YAZ-01. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **KLT-23:** Çalışma anında model çağrısı yoktur (YAZ ilke).
  - Ne: `src/` içinde HTTP/LLM çağrısı 0 (mevcut köprü localhost hariç, ADM-16).
  - Kabul: tarama 0. Test: `godot_script_taramasi.py` kuralı. Taşınan: KLT-67: HTTP dizesi söz araçlarında yoktur.
  - Bağımlılık: ADM-16. Boyut: S.
  - Dosya: araç kuralı.
  - Asset: asset gerekmedi.

- [ ] **KLT-68:** Araç `user://` yazmaz
  - Ne: Araç `user://` yazmaz. Kayıt ve ayar dosyasına dokunmaz.
  - Kabul: Yazım 0. Test: tarama.
  - Bağımlılık: KLT-23. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.
- [ ] **KLT-69:** Araç ağacı silmez
  - Ne: Araç ağacı silmez. `data/soz` dosyası araç tarafından kaldırılmaz. Red ayrı klasöre liste yazar.
  - Kabul: Silinen 0. Test: diff.
  - Bağımlılık: YAZ-04. Boyut: S.
  - Dosya: `tools/soz_kapi.py`
  - Asset: asset gerekmedi.

## 40.10 Sınırlar ve kapanış

- [ ] **KLT-24:** 25.3 kimlikleri silinmez.
  - Ne: DYL-11…16 yerinde; bu bölüm onlara atıf verir.
  - Kabul: B dosyasında DYL-11…16 durur. Test: sayım. Taşınan: KLT-71: DYL-11…16 durur.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `ROADMAP_2_B.md`.
  - Asset: asset gerekmedi.
- [ ] **KLT-25:** Kapanış testi.
  - Ne: fixtures: yasak kalıp, onaysız dosya, ölü adı, 91 karakter ipucu, çift boşluk — beşinin de red.
  - Kabul: beş fixture 5 hata. Test: `tests/tools/test_soz_kapi.py`. Taşınan: KLT-75: Kapanış beş fixtures reddeder.
  - Bağımlılık: KLT-01…24. Boyut: M.
  - Dosya: yeni test.
  - Asset: asset gerekmedi.

Alt başlıklarda madde sayısı iki ile üç arasındadır; onuncu madde YAZ veya DYL gövdesini tekrar edeceği için konmadı. Toplam 25 madde.

- [ ] **KLT-72:** Yeni madde ikinci motor açmaz
  - Ne: Yeni madde ikinci motor açmaz. Sınıf ek 0.
  - Kabul: Sınıf 1. Test: tarama.
  - Bağımlılık: DIY-02. Boyut: S.
  - Dosya: `src/soz/soz_motoru.gd`
  - Asset: asset gerekmedi.
- [ ] **KLT-73:** Wav eklenmez
  - Ne: Wav eklenmez. Sayı aynı.
  - Kabul: Sayım. Test: sayım.
  - Bağımlılık: KLT-19. Boyut: S.
  - Dosya: `assets/ses/`
  - Asset: asset gerekmedi.

