# BÖLÜM 41 — Performans, kararlılık ve teknik borç

Faz 0 ile birlikte başlar; ölçüm Faz 4'te DEN ile kapanır. Zemin, kodda duran ve yeniden kurulmayacak makineler:

- Performans şeridi `src/debug/performans_seridi.gd` — `ac(evet)`, `_yenile`, `oku()` sözlüğü: `fps` (`TIME_FPS`), `kare_ms` (`TIME_PROCESS`), `draw`, RAM `MEMORY_STATIC`. Şerit ekrandadır; dosyaya yazmaz (tester planı K3).
- Düşük bellek `src/dunya/dusuk_bellek_profili.gd` `memory_free()` — beş önbellek: `Sanat`, `Pbr`, `Dunya3B`, `KarakterModel` klipleri, `DurusDuzeltici` şekilleri; `KapiManzarasi._gurultu` null.
- Grafik profili `src/dunya/grafik_profili_adaptoru.gd`; efekt havuzu `src/ses/efekt_havuzu_temizligi.gd`.
- `src/dunya/donma_yoneticisi.gd` donma bekçisi değildir. MEV-02 soğuk hasarıdır (`adaylar`, `risk`, `soguk`). Kare takılması burada ölçülmez.
- Kayıt atomik yazımı SYS-02 `atomik_json_kaydi.gd`; tek dosya `user://kayit.json`. Göç SYS-01/14, Bölüm 31.
- Yükleme katmanı `src/arayuz/varlik_yukleme_paneli.gd` — `hazirla` / `bitir`; zemin `Color("#0d1117")`; metin düz `"Hazırlanıyor…"` (çeviri anahtarı değil).
- Köy hızı `koy_ekrani.gd:337 _hiz_sec`; sahneden çıkış `_exit_tree` (satır 350) `paused` ve `time_scale` ve `max_physics_steps_per_frame` geri yükler.
- Açık bulgular: TST-0001, TST-0005 AÇIK. TST-0002 ve TST-0006 Bölüm 40'dadır (KLT-10, KLT-11). TST-0004 / BUG-0018 odun kilidi Bölüm 32'dedir, burada ikinci ekonomi yoktur. TST-0007 ve TST-0008 model ölçüsü Bölüm 44'tedir. ADV-01…07 `docs/denetim/2026-10-10-claude-test-raporu.md:62–69`. ADM-16 `[/]` (`ROADMAP.md`).

Bu bölüm salgın, mevsim, kayıt göçü veya köprü komut listesini yeniden yazmaz. Açık borcu kimliğiyle kapatır ve ölçer.

Kimlikler TEK-01 … TEK-34. Asset üretilmez. Bitince `[x]` ve ajan adı.

**Madde biçimi:** Ne, Kabul, Bağımlılık + Boyut, Dosya, Asset.

---

## 41.1 Açık bulgular — kimlik durur

- [ ] **TEK-01:** TST-0001 — `KoyNufusu.sayi` eksik sınıf anahtarında SCRIPT ERROR.
  - Ne: eski: TST-0001. `sayi()` olmayan sınıf anahtarında hata basmaz, 0 döner ve bir kez `push_warning` yazar.
  - Kabul: eksik anahtarda SCRIPT ERROR 0, dönüş 0. Test: birim.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `src/koy/koy_nufusu.gd`.
  - Asset: asset gerekmedi.
- [ ] **TEK-02:** TST-0005 — 43 yetim `.import`.
  - Ne: eski: TST-0005. `assets/model/karakter/*_yuru_Image_0.jpg.import` var, `.jpg` yok; headless import ERROR üretir. Karşılığı olmayan `.import` silinir. Yeni jpg üretilmez, mesh'e dokunulmaz.
  - Kabul: yetim `.import` sayısı 0; import logunda `_yuru_Image_0.jpg` ERROR 0. Test: import log sayımı.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `assets/model/karakter/*.import` (yalnız yetim meta).
  - Asset: asset gerekmedi.
- [ ] **TEK-03:** ADV-01 — güvenlik satırı kartta görünür.
  - Ne: eski: ADV-01. "Güvenlik … savunma hazırlığı +N" `koylu_karti.gd` içinde kaydırmadan görünen üst bloktadır.
  - Kabul: 1080p ve metin ölçeği 150'de satır ilk ekrandadır. Test: kart açılışı, kaydırma 0.
  - Bağımlılık: ARY-02. Boyut: S.
  - Dosya: `src/arayuz/koylu_karti.gd`.
  - Asset: asset gerekmedi.
- [ ] **TEK-04:** ADV-06 — teşhis ibresi bir kez yazılır.
  - Ne: eski: ADV-06. Yüz ve heybe incelemesinde aynı ibre satırı konuşma kaydına ikinci kez eklenmez.
  - Kabul: aynı incelemede ibre satırı 1. Test: iki inceleme.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: teşhis yazan kapi paneli (ince adaptör, tek satır).
  - Asset: asset gerekmedi.
- [ ] **TEK-05:** ADV-03 — eski `usta_demirci` bayrağı göçer.
  - Ne: eski: ADV-03. BUG-0001 yeni kabulleri düzeltir; eski kayıttaki CHR bayrağı Bölüm 31 göç adımına bir satır olarak girer. İkinci göç motoru yok.
  - Kabul: bayraklı eski kayıt açılınca göç sonrası bayrak doğru sınıfta 1. Test: KAY zinciri.
  - Bağımlılık: KAY-04. Boyut: S.
  - Dosya: `src/sistemler/kayit_gocu.gd` tek adım.
  - Asset: asset gerekmedi.
- [ ] **TEK-06:** ADM-16 kapanış ölçütü, komut listesi yeniden yazılmaz.
  - Ne: `ROADMAP.md` ADM-16 `[/]` durur. Bu madde köprüyü ikinci kez tasarlamaz. Kapanış: normal oyunda port yokken `oyun_koprusu.gd` süreç açmaz; `--bridge-port` ile `ping` döner. Komut kümesi o maddenin listesidir.
  - Kabul: portsuz açılışta dinleyen soket 0. Test: iki açılış.
  - Bağımlılık: ADM-16. Boyut: S.
  - Dosya: `src/debug/oyun_koprusu.gd` (oyun deposunda; bu klasörden yazılmaz).
  - Asset: asset gerekmedi.

## 41.2 Ölçüm — üç gece

- [ ] **TEK-07:** ADV-02 — kuyu zehri enjektörü hekimi hasta etmez.
  - Ne: eski: ADV-02. Debug "kuyu zehri" herkese `hasta` vermez; KRI-04 gibi yalnız su içenlere ve olasılıkla düşer. Hekim `hekim etkin` yanlış pozitif almaz.
  - Kabul: enjektör sonrası hekim `hasta` değilse `hekim etkin` true. Test: birim.
  - Bağımlılık: KRI-04. Boyut: S.
  - Dosya: `src/debug/` kuyu enjektörü.
  - Asset: asset gerekmedi.
- [ ] **TEK-08:** ADV-05 karar olarak kalır, yeni bonus yoktur.
  - Ne: eski: ADV-05. Kenetlenme bonusu gizli kuluçkada verilmez. Bu bir borç kapatma değil, yazılı karardır: dolaylı ipucu kabul. Kod değişmez, `docs/denetim` notu "karar" olur.
  - Kabul: bonus formülü diff'i 0. Test: tarama.
  - Bağımlılık: KRI-10. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **TEK-09:** ADV-07 eşikleri DEN'dedir.
  - Ne: eski: ADV-07. `data/atil_bayraklar.json` ve `data/nihai_sonlar.json` gözden geçirmesi Bölüm 32'dedir. Burada ikinci eşik tablosu açılmaz.
  - Kabul: bu dosyada yeni json 0. Test: sayım.
  - Bağımlılık: DEN-01. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **TEK-10:** Üç gecelik performans ölçümü.
  - Ne: `PerformansSeridi.oku()` üç gece boyunca gece başına bir satır yazar: fps ortanca, kare_ms en yüksek, `memory_free` öncesi RAM. Hedef (öneri, `data/teknik.json`): ortanca fps ≥ 30, kare_ms tavanı dosyada. Otomatik profil değiştirmez (AYR düşük profil satırı ayrıdır).
  - Kabul: üç gece sonunda satır 3; eşik altı bir uyarı, crash yok. Test: `tests/oto` koşusu.
  - Bağımlılık: yok. Boyut: M.
  - Dosya: yeni: `src/debug/performans_gunlugu.gd`; `data/teknik.json`.
  - Asset: asset gerekmedi.
- [ ] **TEK-11:** Günlük oyuncu sürümünde kapalıdır.
  - Ne: `performans_gunlugu` yalnız debug veya `--perf-log` ile yazar. SRM-05 kapalı sürümde dosya oluşmaz.
  - Kabul: bayraksız export'ta log dosyası 0. Test: açılış.
  - Bağımlılık: TEK-10, SRM-05. Boyut: S.
  - Dosya: `performans_gunlugu.gd`.
  - Asset: asset gerekmedi.
- [ ] **TEK-12:** ADV-04 — manifest bilinçli API değişince güncellenir.
  - Ne: eski: ADV-04. `tools/api_sozlesmesi.py` baseline ile birebir bakar. Korumalı imza değişince baseline aynı commit'te güncellenir; sessiz sapma sanity'yi geçmez.
  - Kabul: imza değişip baseline eskiyse sanity kırmızı. Test: araç.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `tools/api_sozlesmesi_baseline.json`.
  - Asset: asset gerekmedi.

## 41.3 Bellek ve önbellek

- [ ] **TEK-13:** `memory_free` ikinci önbellek açmaz.
  - Ne: beş önbellek listesi `dusuk_bellek_profili.gd` içindedir. Yeni sistem kendi önbelleğini bu listeye eklemeden biriktirmez.
  - Kabul: `memory_free` dönüş sözlüğünde beş anahtar. Test: birim.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `src/dunya/dusuk_bellek_profili.gd`.
  - Asset: asset gerekmedi.
- [ ] **TEK-14:** Düşük profil `memory_free` çağırır, şeridi çağırmaz.
  - Ne: `grafik_profili == dusuk` iken sahne geçişinde `memory_free` bir kez; `PerformansSeridi.ac(true)` oyuncuda 0.
  - Kabul: düşük profilde çağrı 1, şerit görünür 0. Test: profil değiştir.
  - Bağımlılık: TEK-13. Boyut: S.
  - Dosya: `grafik_profili_adaptoru.gd` tek satır.
  - Asset: asset gerekmedi.
- [ ] **TEK-15:** Efekt havuzu temizliği durur.
  - Ne: `efekt_havuzu_temizligi.gd` ve `ana.gd _goster` içindeki `Ses.efektleri_temizle()` yerinde kalır. İkinci havuz yok.
  - Kabul: sahne geçişinde çift temizlik çağrısı 1 (mevcut tek çağrı). Test: tarama.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

## 41.4 Hata bütçesi

- [ ] **TEK-16:** Sanity SCRIPT ERROR bütçesi 0'dır.
  - Ne: `tools/sanity_check.py` turunda SCRIPT ERROR satırı 0. TEK-01 kapanmadan bu madde kapanmaz.
  - Kabul: temiz turda SCRIPT ERROR 0. Test: sanity.
  - Bağımlılık: TEK-01. Boyut: S.
  - Dosya: `tools/sanity_check.py`.
  - Asset: asset gerekmedi.
- [ ] **TEK-17:** `[KEY_NOT_FOUND]` bütçesi KLT-10'dur.
  - Ne: metin eksikleri Bölüm 40'dadır. Bu madde ikinci doğrulayıcı yazmaz.
  - Kabul: `metin_dogrula.py` çağrısı `soz_kapi` / mevcut araçta 1, burada 0 yeni araç. Test: sayım.
  - Bağımlılık: KLT-10. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **TEK-18:** Push_error katalogu kilitlemez.
  - Ne: `GuvenliMetin` ve `Ayarlar.yukle` bozuk dosyada oyunu açar, varsayılana döner (`ayarlar.gd:38–49`). Bu davranış bozulmaz.
  - Kabul: bozuk `ayarlar.cfg` ile menü açılır. Test: birim.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

## 41.5 Yükleme katmanı

- [ ] **TEK-19:** Yükleme paneli bitince input'u bırakır.
  - Ne: `VarlikYuklemePaneli._input` her olayı yer (`set_input_as_handled`). `bitir` düğümü ağaçtan çıkarır; sonraki karede tıklama oyuna gider.
  - Kabul: `bitir` sonrası panel çocuğu 0, ilk tıklama menüye ulaşır. Test: akış.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `src/arayuz/varlik_yukleme_paneli.gd`.
  - Asset: asset gerekmedi.
- [ ] **TEK-20:** Çift kapı yüklemesi engeli durur.
  - Ne: `ana.gd _kapi_yukleniyor` (satır 80–97) ikinci `_kapiya_git` çağrısını yutar. Bayrak `bitir` sonrası false olur; takılı true kalırsa kapı bir daha açılmaz — test bunu yakalar.
  - Kabul: art arda iki çağrıda ekran 1; bitişte bayrak false. Test: birim.
  - Bağımlılık: TEK-19. Boyut: S.
  - Dosya: `src/arayuz/ana.gd` (yalnız test; imza değişmez).
  - Asset: asset gerekmedi.
- [ ] **TEK-21:** "Hazırlanıyor…" çeviri anahtarına geçer.
  - Ne: düz metin `arayuz.yukleme.hazirlaniyor` olur. YER-02 kuralı. Zemin rengi Bölüm 43'ün konusudur, burada değişmez.
  - Kabul: `tr("` dışı düz Türkçe bu dosyada 0 (bilinçli istisna listesi boş). Test: tarama.
  - Bağımlılık: YER-02. Boyut: S.
  - Dosya: `varlik_yukleme_paneli.gd`; `metinler.csv`.
  - Asset: asset gerekmedi.

## 41.6 Zaman ölçeği

- [ ] **TEK-22:** Sahne çıkışı hızı sıfırlar.
  - Ne: `koy_ekrani.gd _exit_tree` `paused = false`, `time_scale = 1`, fizik adımını `_onceki_fizik_adimi` yapar. Test kilitler; kod yeniden yazılmaz.
  - Kabul: hız 3'te menüye dönünce `time_scale` 1 ve `paused` false. Test: akış.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `tests/` akış.
  - Asset: asset gerekmedi.
- [ ] **TEK-23:** Gece kilidi hızı 1'de tutar.
  - Ne: `_hiz_sec` `_gece_kilidi.kilitli()` iken katı 1 yapar (`gece_gecis_kilidi.gd`). Kilit varken hız 3 seçilemez.
  - Kabul: kilitliyken `time_scale` 1. Test: birim.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **TEK-24:** Defter ve divan hızı geri verir.
  - Ne: HFZ-03 ve `divan_baglantisi.gd` hız saklama kalıbı bozulmaz. İkinci saklama yazılmaz.
  - Kabul: divan aç/kapa sonrası hız aynı. Test: HFZ-03 ile ortak.
  - Bağımlılık: HFZ-03. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

## 41.7 Kayıt yazımı

- [ ] **TEK-25:** Atomik yazım SYS-02'dir.
  - Ne: yarıda kesilen `kayit.json` bir sonraki açılışta ya tamdır ya yok hükmündedir. Bu madde `atomik_json_kaydi.gd` gövdesini değiştirmez; kesik dosya testini ekler.
  - Kabul: yarı yazılmış dosyada `devam_et` menüye döner, çökmez (`ana.gd:68–71`). Test: kesik dosya.
  - Bağımlılık: SYS-02. Boyut: S.
  - Dosya: `tests/unit` kayıt.
  - Asset: asset gerekmedi.
- [ ] **TEK-26:** Tek kayıt dosyası durur.
  - Ne: yuva Bölüm 35'tedir. Burada ikinci `user://` kayıt yolu açılmaz.
  - Kabul: `kayit_deposu.gd` yol sayısı 1. Test: tarama.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

## 41.8 Debug sınırı

- [ ] **TEK-27:** Admin HUD oyuncu sürümünde doğmaz.
  - Ne: `ana.gd:20 AdminHud.new()` SRM-05 kapalıyken eklenmez. Debug araçları (`gece_deneyi.gd`, enjektörler) aynı bayrağın ardındadır.
  - Kabul: kapalı sürümde `AdminHud` çocuk sayısı 0. Test: açılış.
  - Bağımlılık: SRM-05. Boyut: S.
  - Dosya: `src/arayuz/ana.gd` tek koşul.
  - Asset: asset gerekmedi.
- [ ] **TEK-28:** F1 ve `~` yalnız adminde.
  - Ne: `admin_hud.gd` kısayolları HUD yokken hiçbir şeyi açmaz.
  - Kabul: HUD'suz sahnede F1 etkisi 0. Test: girdi.
  - Bağımlılık: TEK-27. Boyut: S.
  - Dosya: `src/debug/admin_hud.gd`.
  - Asset: asset gerekmedi.

## 41.9 Uzun koşu

- [ ] **TEK-29:** Yirmi gece dumanı bellek sıçraması yazmaz.
  - Ne: tester dumanı (20 gece) TEK-10 günlüğünde RAM'in gece başına sınırsız artmadığını bakar. Eşik `data/teknik.json` (öneri: 20 gecede 2 kattan az). Sıçrama varsa madde açık kalır, otomatik `memory_free` spam'i yok.
  - Kabul: eşik altı koşu geçer; üstü raporda 1 satır. Test: duman.
  - Bağımlılık: TEK-10. Boyut: M.
  - Dosya: `data/teknik.json`.
  - Asset: asset gerekmedi.
- [ ] **TEK-30:** Soğuk ölüm bu bölümün işi değildir.
  - Ne: `donma_yoneticisi.gd` MEV-02'dir. Kare takılması veya bellek için ona satır eklenmez.
  - Kabul: dosya diff'i 0. Test: tarama.
  - Bağımlılık: MEV-02. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

## 41.10 Sınırlar ve kapanış

- [ ] **TEK-31:** Çekirdek ekonomi ve olay şeması değişmez.
  - Ne: `oyun.tres` denge sayıları, `OlayVerisi` alanları, `oturum.gd` kayıt sürümü bu bölümden artmaz. Sürüm artışı yalnız TEK-05 göçü gerektirirse KAY kuralıncadır.
  - Kabul: `olay_verisi.gd` diff 0. Test: sözleşme.
  - Bağımlılık: KAY-04. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **TEK-32:** Model ölçüsü burada yoktur.
  - Ne: TST-0007 (chr_011 pelerin) ve TST-0008 (ayak, Aydoğdu yayı) Bölüm 44 maddesidir. Asset üretilmez.
  - Kabul: bu dosyada `chr_011` düzeltme adımı 0. Test: sayım.
  - Bağımlılık: SAH. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **TEK-33:** Odun kilidi burada yoktur.
  - Ne: TST-0004 / BUG-0018 Bölüm 32 odun satırıdır.
  - Kabul: `odun_zinciri.gd` bu bölümden değişmez. Test: tarama.
  - Bağımlılık: DEN. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **TEK-34:** Kapanış testi.
  - Ne: tek koşu: TST-0001 anahtarı 0 hata; yetim import 0; üç gece perf satırı 3; yükleme paneli kalkınca tıklama gider; hız 3'ten menüde scale 1; portsuz köprü soketi 0.
  - Kabul: altı iddia. Test: `tests/unit/sistemler/teknik_borc_test.gd` + import sayımı.
  - Bağımlılık: TEK-01…33. Boyut: M.
  - Dosya: yeni test.
  - Asset: asset gerekmedi.

Alt başlıklarda madde sayısı üç ile altı arasındadır. Onuncu madde, 31 veya 32'de duran bir kuralı ikinci kez yazacağı için konmadı. Toplam 34 madde.
