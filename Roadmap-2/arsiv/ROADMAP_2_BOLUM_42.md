# BÖLÜM 42 — Sürüm hazırlığı ve cila

En son kapanır; 41 ve 43 bitmeden sürüm işareti konmaz. Zemin:

- `project.godot` `config/name="GameDevoloper"`. `config/version` yok. Ana sahne `res://src/arayuz/ana.tscn`. Özellikler `4.7`, Forward Plus.
- Menü `src/arayuz/menu_ekrani.gd` `OYUN_ADI := ""` (satır 8). Düğmeler `ana.gd:49`: yeni, devam, ayarlar, çık. Kayıt yoksa devam pasif (`pasifler = [1]`).
- Son ekranı `ana.gd:120 _son_goster`: epilog + `arayuz.son.istatistik` ile gün, kabul, ret, nüfus. Kayıt silinir. Başarım kodu yok (`basarim` / `achievement` araması 0).
- Çıkış `Ses.cik()` menüden. Duraklat `ana.gd:149`: devam, ayarlar, menü.
- Kayıt `user://kayit.json` tek dosya. Ayar `user://ayarlar.cfg`.
- Steamworks, export preset ve mağaza metni deposunda yoktur. Bu bölüm SDK kurmaz, başarım API'si açmaz.

Kimlikler SRM-01 … SRM-26. Asset üretilmez; ikon ihtiyacı ARY-05 satırıdır. Bitince `[x]` ve ajan adı.

**Madde biçimi:** Ne, Kabul, Bağımlılık + Boyut, Dosya, Asset.

---

## 42.1 Kimlik — ad, sürüm, pencere

- [ ] **SRM-01:** Pencere adı oyun adıdır.
  - Ne: `config/name` "GameDevoloper" kalmaz. Ad `arayuz.menu.baslik` ile aynı metinden okunur; `project.godot` adı o metnin düz kopyasıdır (Godot config çeviri fonksiyonu çağırmaz). `OYUN_ADI` boş kalırsa başlık satırı menüdeki `baslik`tır, ikinci marka yok.
  - Kabul: pencere başlığında "GameDevoloper" 0. Test: açılış başlığı.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `project.godot`; `menu_ekrani.gd` boş sabit durur ya da `baslik` ile dolar, ikinci ad yazılmaz.
  - Asset: asset gerekmedi.
- [ ] **SRM-02:** Sürüm tek sabittir.
  - Ne: `config/version` bir dizedir (öneri `0.2.0`, Ahmet koyar). Menü alt satırı `arayuz.menu.surum` ile onu gösterir. Kod içinde dağınık sürüm yazısı 0.
  - Kabul: menüde sürüm 1, `project.godot` ile aynı. Test: iki yer eşit.
  - Bağımlılık: SRM-01. Boyut: S.
  - Dosya: `project.godot`; `metinler.csv`.
  - Asset: asset gerekmedi.
- [ ] **SRM-03:** Godot 4.7 dışına çıkılmaz.
  - Ne: `config/features` 4.7 kalır. Sürüm notu 4.7.2 çalıştırma sürümünü belgeler (`docs/` bir satır). Motor yükseltilmez.
  - Kabul: features içinde `4.7` durur. Test: dosya.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `project.godot`.
  - Asset: asset gerekmedi.

## 42.2 Oyuncu sürümü — debug kapalı

- [ ] **SRM-04:** İki açılış vardır: geliştirme ve oyuncu.
  - Ne: oyuncu açılışı `--debug-arac` yokken admin, perf günlüğü ve köprüyü kurmaz. Geliştirme açılışı bugünkü davranıştır.
  - Kabul: bayraksız süreçte `AdminHud` 0 (TEK-27). Test: iki açılış.
  - Bağımlılık: TEK-27. Boyut: S.
  - Dosya: `src/arayuz/ana.gd` tek koşul.
  - Asset: asset gerekmedi.
- [ ] **SRM-05:** Debug kapalı sürüm.
  - Ne: export ön ayarında debug araçları kapalıdır: admin HUD, F1, performans şeridi, perf günlüğü, senaryo koşucusu, zaman makinesi, enjektörler. Köprü yalnız `--bridge-port` ile (ADM-16). Ön ayar `export_presets.cfg` içinde bir Windows hedefidir; Steam hedefi yoktur.
  - Kabul: oyuncu export'unda `src/debug/` düğümü 0. Test: export açılışı.
  - Bağımlılık: SRM-04, ADM-16. Boyut: M.
  - Dosya: `export_presets.cfg` (oyun deposunda, uygulanırken).
  - Asset: asset gerekmedi.
- [ ] **SRM-06:** Oyuncu sürümünde konsol izi yoktur.
  - Ne: `push_error` durur (TEK-18); oyuncuya hata ayıklama dökümü penceresi açılmaz. Godot'un kendi stdout'u paket dışında bırakılır.
  - Kabul: export'ta verbose bayrağı kapalı. Test: preset.
  - Bağımlılık: SRM-05. Boyut: S.
  - Dosya: `export_presets.cfg`.
  - Asset: asset gerekmedi.

## 42.3 Demo kesiti — yeni perde yok

- [ ] **SRM-07:** Demo, perde 1 ile sınırlı bir export bayrağıdır.
  - Ne: `demo` ayarı açıkken oyun `perde_gecisi` "Köy oturdu" kartında biter; perde 2 ve beş son çalışmaz. Omurga (Bölüm 34) yeniden yazılmaz. Sayı `oturma_esigi` (18) durur.
  - Kabul: demo bayrağında nüfus 18 sonrası kapı gecesi 0, bitiş kartı 1. Bayrak kapalıyken bugünkü perde 2. Test: iki bayrak.
  - Bağımlılık: OMR-08. Boyut: M.
  - Dosya: yeni: `src/sistemler/demo_kesiti.gd`; `perde_gecisi` çağrısına tek satır.
  - Asset: asset gerekmedi.
- [ ] **SRM-08:** Demo metni son ekranına eklenir, istatistik uydurmaz.
  - Ne: demo bitişinde mevcut dört sayı (gün, kabul, ret, nüfus) ve bir cümle `arayuz.demo.bitti`. Yeni sayaç yok.
  - Kabul: dört sayı `yonetim` alanlarından gelir. Test: son ekranı.
  - Bağımlılık: SRM-07. Boyut: S.
  - Dosya: `ana.gd _son_goster` demo dalı; `metinler.csv`.
  - Asset: asset gerekmedi.
- [ ] **SRM-09:** Tam sürümde demo kartı çıkmaz.
  - Ne: bayrak kapalıyken `demo_kesiti` 0 çağrı etkisi.
  - Kabul: normal oyunda perde 2 gecesi başlar. Test: bayrak kapalı.
  - Bağımlılık: SRM-07. Boyut: S.
  - Dosya: `demo_kesiti.gd`.
  - Asset: asset gerekmedi.

## 42.4 İstatistik — başarım sistemi yok

- [ ] **SRM-10:** Son ekranı sayaçları duran alanlardır.
  - Ne: gün, kabul, ret, nüfus (`ana.gd:125`). Başka alan eklenmez: zafer sayısı, ölüm, rüşvet. Onlar yoksa satır da yok.
  - Kabul: format argümanı 4. Test: `tr` yer tutucu sayısı.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `ana.gd`.
  - Asset: asset gerekmedi.
- [ ] **SRM-11:** Başarım tablosu açılmaz.
  - Ne: Steam başarımları ve oyun içi rozet yoktur. Alınan son izi OMR-47 `oyuncu_izi.cfg` dosyasıdır; bu bölüm onu başarım diye yeniden adlandırmaz.
  - Kabul: `basarim` sınıfı 0. Test: tarama.
  - Bağımlılık: OMR-47. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **SRM-12:** İkinci oyunda "daha önce" satırı OMR-47'dir.
  - Ne: menüde alınan sonların kısa adı. Liste OMR-47'den okunur, burada ikinci dosya yok.
  - Kabul: iz dosyası boşken satır 0. Test: OMR-47.
  - Bağımlılık: OMR-47. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

## 42.5 İlk açılış ve çıkış

- [ ] **SRM-13:** Kayıtsız devam kapalı kalır.
  - Ne: `kayit.var_mi()` false iken devam düğmesi pasif (`ana.gd:50–51`). Test bunu kilitler.
  - Kabul: dosya yokken `pasifler` içinde 1. Test: açılış.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **SRM-14:** Çıkış kaydı yazmadan menüye döner, duraklatta sorar.
  - Ne: duraklat → menü (`_duraklat` seçenek 2) mevcut kaydı silmez; son ekranı siler (`kayit.sil`). İkisi karışmaz. Yeni onay penceresi açılmaz.
  - Kabul: duraklattan menüye dönünce `kayit.json` durur. Test: akış.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **SRM-15:** `Ses.cik` oyunu kapatır.
  - Ne: menü çıkışı bugünkü `Ses.cik()` yoludur. İkinci kapatma fonksiyonu yok.
  - Kabul: çıkış çağrısı 1. Test: tarama.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `ana.gd`.
  - Asset: asset gerekmedi.

## 42.6 Mağaza metni — SDK yok

- [ ] **SRM-16:** Steamworks bu sürüme girmez.
  - Ne: depoda Steam API yoktur. Başarım, bulut kayıt, atölye eklenmez. Kayıt `user://` kalır.
  - Kabul: `steam` geçen script 0. Test: tarama.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **SRM-17:** Mağaza metni bu klasörde bir sayfadır, oyuna gömülmez.
  - Ne: `docs/surum/MAGAZA.md` (uygulanırken oyun deposunda) kısa paragraf, beş sonun adı, "seslendirme yok / tek harita" dürüst satırı. Oyun bu dosyayı okumaz.
  - Kabul: `res://` altında mağaza md 0. Test: export listesi.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `docs/surum/MAGAZA.md`.
  - Asset: asset gerekmedi.
- [ ] **SRM-18:** İkon üretilmez.
  - Ne: pencere ikonu yoksa Godot varsayılanı durur. İhtiyaç ARY-05'e `SRM18-IKON` diye yazılır. Dosya indirilmez.
  - Kabul: bu madde png yazmaz. Test: sayım.
  - Bağımlılık: ARY-05. Boyut: S.
  - Dosya: envanter satırı.
  - Asset: `SRM18-IKON`. Yer tutucu: Godot varsayılan ikonu.

## 42.7 Ekran listesi — çekim ve kontrol

- [ ] **SRM-19:** Sürüm kontrolü şu ekranları gezer.
  - Ne: tek liste: menü, ayarlar, yükleme, kapı (sorgu + karar), heybe, köy, harita, divan, muhafız odası, gece kartı, son ekranı. Liste Bölüm 43 envanterinin oyuncu yüzüdür; HUD parçaları ayrı sayılmaz.
  - Kabul: 11 ekranın her biri açılır, SCRIPT ERROR 0. Test: duman.
  - Bağımlılık: TEK-16. Boyut: M.
  - Dosya: `tests/oto` duman notu.
  - Asset: asset gerekmedi.
- [ ] **SRM-20:** Üç çözünürlükte aynı liste.
  - Ne: pencere 1280×720, 1600×900 (bugünkü override), 1920×1080. Taşan metin AYR ve GRV işidir; bu madde yalnız "açıldı" der.
  - Kabul: üç boyutta 11 ekran açılır. Test: duman × 3.
  - Bağımlılık: SRM-19, AYR. Boyut: M.
  - Dosya: —.
  - Asset: asset gerekmedi.

## 42.8 Gizlilik ve ağ

- [ ] **SRM-21:** Oyun dışarı istek atmaz.
  - Ne: oyuncu sürümünde HTTP/telemetri 0. Yerel köprü (ADM-16) localhost ve bayraklıdır, sürümde kapalıdır.
  - Kabul: bayraksız ağ bağlantısı 0. Test: tarama + açılış.
  - Bağımlılık: SRM-05. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **SRM-22:** Kayıt yolu belgede bir satırdır.
  - Ne: `user://kayit.json` ve `user://ayarlar.cfg`. Bulut kopyası yoktur.
  - Kabul: MAGAZA.md'de yol 1, bulut sözü 0. Test: dosya.
  - Bağımlılık: SRM-17. Boyut: S.
  - Dosya: `docs/surum/MAGAZA.md`.
  - Asset: asset gerekmedi.

## 42.9 İçerik sınırı

- [ ] **SRM-23:** Sürüm notu seslendirme vaat etmez.
  - Ne: mağaza ve menü "sesli diyalog" demez. Efekt ve müzik duran `Ses` autoload'ıdır, yeni dosya yok.
  - Kabul: `seslendirme` vaadi 0. Test: metin tarama.
  - Bağımlılık: SRM-17. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **SRM-24:** İkinci harita vaadi yoktur.
  - Ne: bölge haritası (R1 `harita_ekrani.gd`) tek haritadır. Mağaza "dünya haritası" diye ikinci bir oyun alanı yazmaz.
  - Kabul: MAGAZA.md'de ikinci harita 0. Test: dosya.
  - Bağımlılık: SRM-17. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

## 42.10 Sınırlar ve kapanış

- [ ] **SRM-25:** Denge ve yazım bu bölümde değişmez.
  - Ne: `denge.json` ve `data/soz/` sürüm kesitinden oynanmaz. Sapma DEN ve KLT'dedir.
  - Kabul: bu bölümün diff'i o iki ağaca girmez. Test: tarama.
  - Bağımlılık: DEN-01, KLT-01. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **SRM-26:** Kapanış testi.
  - Ne: bayraksız açılışta admin 0, pencere adı eski yazım değil, kayıtsız devam pasif, demo bayrağında perde 2 yok, son ekranı 4 sayı, steam script 0.
  - Kabul: altı iddia. Test: `tests/oto/surum_kontrol.tscn`.
  - Bağımlılık: SRM-01…25. Boyut: M.
  - Dosya: yeni test sahnesi.
  - Asset: asset gerekmedi.

Alt başlıklarda madde sayısı üçtür. Onuncu madde Steam API'si veya başarım tablosu uyduracağı için konmadı. Toplam 26 madde.
