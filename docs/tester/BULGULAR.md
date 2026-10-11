# Tester Bulguları

Kural ve kalıp: `docs/tester/TESTER_REHBERI.md` §5. Numara TST-0001'den artar; yeni bulgu **en üste** eklenir.
Durumlar: AÇIK → DÜZELTİLDİ (commit) → DOĞRULANDI / YENİDEN AÇILDI. Öncelik P0–P3.

| Kimlik | Öncelik | Madde | Başlık | Durum |
| --- | --- | --- | --- | --- |
| TST-0005 | P3 | ENVIRONMENT/asset | 43 orphan `.import` (jpg yok) import sırasında 86 ERROR satırı üretiyor | AÇIK |
| TST-0004 | P1 | SYS-19/DENGE | Zafer sonu ulaşılamıyor: EKO-02 tomruk zinciri sonrası köy odun üretemiyor, kıtlıkla çöküyor | AÇIK |
| TST-0003 | P1 | — | Sinsi gece rutini: koylu(id) null iken is_yeri erişimi; her karede SCRIPT ERROR | DOĞRULANDI (254202d) |
| TST-0002 | P2 | — | 6 metin anahtarı eksik; her oyunda [KEY_NOT_FOUND] uyarısı | AÇIK |
| TST-0001 | P2 | — | KoyNufusu.sayi() eksik sınıf anahtarında SCRIPT ERROR | AÇIK |

---

<!-- Bulgular buradan aşağı, en yenisi üstte -->

### TST-0005 · P3 · [ÇEVRE]/asset · 43 yetim `.import` dosyası import sırasında 86 ERROR satırı üretiyor
- **Durum:** AÇIK (önceden var olan repo artefaktı)
- **Commit:** 34d36f7
- **Adımlar:** 1) `godot --headless --editor --import --quit --path .` (headless import) 2) `work/tester/tur3/sanity/headless-import.log` içinde `Failed loading resource: ..._yuru_Image_0.jpg` satırlarını ara.
- **Beklenen:** Import hatasız/uyarısız tamamlanmalı (kabul kriteri: SCRIPT ERROR / "Failed to load script" yok).
- **Gerçek:** `assets/model/karakter/` altında **43 adet `*_yuru_Image_0.jpg.import`** var ama karşılık gelen `.jpg` **yok** (görüntü .glb içine gömülü). Godot her biri için `ERROR: Failed loading resource` + `ERROR: Failed to load` + `WARNING: glTF ... loaded directly instead` basıyor → logda **86 ERROR satırı** (ör. `chr_024_yuru_Image_0.jpg`).
- **Etki:** Zararsız (Godot gömülü görüntüye düşüyor, model yükleniyor) ama log spam'i gerçek hataları gölgeleyebilir ve "import hatasız" kabul kriterini kirletir.
- **Tekrar:** Import önbelleği yeniden kurulunca görünür (tur 2 logunda önbellek taze olduğu için yoktu; tur 3'te 86).
- **Kanıt:** `work/tester/tur3/sanity/headless-import.log` (86 satır); `Get-ChildItem assets/model/karakter -Filter '*_yuru_Image_0.jpg.import'` (43 dosya, .jpg yok).
- **Öneri:** Karşılığı olmayan 43 `.import` dosyasını sil (asset üretmeden; yalnız yetim meta dosyaları), veya glTF ayarında gömülü görüntü yolu düzeltilsin. Karar Claude/Codex'in.


### TST-0004 · P1 · [DENGE] · Zafer sonu ulaşılamıyor — EKO-02 tomruk zinciri köyü odun kilitine sokuyor
- **Durum:** AÇIK
- **Commit:** 34d36f7 (oyun 108–116 + tur 3 koşuları)
- **Adımlar:** 1) Otomatik oyuncu, herhangi bir kabul oranı (0.1–0.98) 2) Oyunu sonuna kadar oyna. 3) Ayrıca `tools/denge/koy_benzetimi.gd` (kendi mantığı) 5 tohumla.
- **Beklenen:** 2. perdeye (nüfus 18) ulaşan bir köy, doğru bina/iş dağılımıyla 12 gece dayanıp zafer (Uç Tutundu vb.) alabilmeli.
- **Gerçek:** 14/14 sürekli oyun + 5 tohum benzetim + 3 tur içi koşu + 1 pencereli koşu — **hiç zafer yok**. Tüm oyunlar g6–g19'da İsyan/Tekfur/azil ile bitiyor. Kök neden: `src/koy/odun_zinciri.gd` (EKO-02) `hizarhane` tarifini **2 tomruk → 3 odun** yaptı (girdi tomruk zorunlu); tomruk yalnız `odunluk` yapısından geliyor. Otomatik oyuncu ve `koy_benzetimi` `odunluk` kurmadığı için **odun 1. günden sonra sürekli 0**; köy ~5 yapıda donuyor, yeni tarla kurulamıyor, gıda nüfusa yetişmiyor.
- **Mekanizma (huzur eğrisi):** gıda 0 → `_saglik_ve_moral` aç köylüye `aclik_moral=15` ceza (−13…−15/gece) → huzur 60–70'ten tek haneliye iniyor → `isyan_esigi=10` altında 3 gece → İsyan sonu. Oyunlarda gıda g6–g8'de 0 oluyor; huzur g10–g12'de ≤5.
- **Tekrar:** 22/22 gözlem (14 kayıtlı oyun + 8 tur 3 koşusu) yenilgi. Zafer 0.
- **Kanıt:** `work/tester/oyunlar/oyun_108..116.log` (hepsinde `odun=0`), `work/tester/tur3/denge_ek.gd` (+tanı `hizar_tani.gd`), `work/tester/tur3/oto_201..203.log`, `work/tester/tur3/oto_301.log`.
- **Tahmin:** Strateji test araçları EKO-02 öncesine ait; güncellenince ya da odun zinciri (odunluk maliyeti/başlangıç odunu) ayarlanınca zafer ölçülebilir olur. Ayrıntı: ONR-003, ONR-004.

### TST-0003 doğrulaması · commit 254202d · **DOĞRULANDI**
- **Künye:** `sinsi_gece_rutini.gd` nobetçi yolunda ölmüş/ayrılmış (null) köylü için `is_yeri` erişimi her karede `SCRIPT ERROR` basıyordu (tur 2, oyun 112: 511 hata). Fix commit **254202d** (BUG-0017).
- **Kanıt:** fix sonrası oyunlar **113/114/115/116** loglarında `is_yeri` SCRIPT ERROR = **0** (`work/tester/oyunlar/oyun_11[3-6].log`). → **DOĞRULANDI**.
- **Not:** `codex.md/Tester.md` ve önceki tur raporlarında geçen 112 hata spam'i tekrar gözlenmedi.



### TST-0002 · P2 · [ARAYUZ]/[DIYALOG] · Altı metin anahtarı eksik; her oyunda [KEY_NOT_FOUND] uyarısı
- **Durum:** AÇIK
- **Commit:** 5396fae (oyun 109 doğruladı); ilk görüldüğü commit b9865ba (oyun 107)
- **Adımlar:** 1) Herhangi bir oyunu başlat (otomatik oyuncu veya elle) 2) HUD kurulurken (`kaynak_gostergesi.kur`) ve köy inşa menüsü metin arar.
- **Beklenen:** Aranan her anahtar `data/metin/metinler.csv` içinde bulunmalı.
- **Gerçek:** Şu 6 anahtar CSV'de yok; her oyunda uyarı basılıyor: `koy.kaynak.tomruk`, `koy.kaynak.un`, `koy.kaynak.harc`, `koy.kaynak.kirec`, `koy.yapi.tas_ev`, `koy.yapi.tas_ev_aciklama`. Log: `WARNING: Metin tablosu: eksik anahtar <anahtar>; ekranda [KEY_NOT_FOUND] gösteriliyor`.
- **Tekrar:** 7/7 oyunda (106,107,108,109 …); oyun 109'da 6 anahtarın her biri tam 1 kez.
- **Kanıt:** `work/tester/oyunlar/oyun_109.log`, `work/tester/oyunlar/oyun_107.log`; `data/metin/metinler.csv` (anahtarlar grep ile YOK).
- **Not:** `work/tester/oyunlar/foto_109/04_kart.png` üst kaynak şeridinde "Tomruk/Buğday/Un/Kireç/Harç" okunaklı görünüyor; `[KEY_NOT_FOUND]` başka bir alt panelde/ipucunda çıkıyor olabilir — hangi ekranda göründüğü ek görüntüyle kesinleştirilmeli.
- **Öneri (düzeltme):** 6 satırı `metinler.csv`'ye ekle (Anahtar,Metin) — ör. `koy.kaynak.tomruk,Tomruk`.

### TST-0001 · P2 · [HATA] · KoyNufusu.sayi() eksik sınıf anahtarında SCRIPT ERROR üretiyor
- **Durum:** AÇIK
- **Commit:** b9865ba (oyun 107). Kod yolu HEAD 5396fae'de değişmedi (`src/sistemler/koy_nufusu.gd` aynı); oyun 109'da ilgili sınıflar (zanaatkar/dervis) çıkmadığı için tekrarlamadı.
- **Adımlar:** 1) Otomatik oyuncu, TOHUM=107, kabul 0.98 (`work/tester/oyunlar/oyun_107.log`) 2) Oyun ilerlerken test aracı her olay/kartta DURUM satırı basar → `KoyNufusu.sayi()` çağrılır.
- **Beklenen:** Sınıf anahtarı yoksa sessizce 0 dönmeli (`sayi()` savunmalı olmalı); SCRIPT ERROR olmamalı.
- **Gerçek:** Oyun 107'de 60 kez `SCRIPT ERROR: Invalid access to property or key 'zanaatkar'/'dervis' on a base object of type 'Dictionary'` (`koy_nufusu.gd:28`, `sayilar[sinif]`). Her DURUM satırından önce tam 2 hata (30 DURUM → 60 hata).
- **Tekrar:** 30/30 (oyun 107 boyunca tutarlı). Oyun 106/108/109: aynı sınıflar çıkmadı → görülmedi.
- **Kanıt:** `work/tester/oyunlar/oyun_107.log` (satır 93,100,114,120,…), `~/.codex-tester/olaylar.log` HATA satırları (sayi=2…87).
- **Tahmin:** `KoyNufusu.sayilar` varsayılanı yalnız `{asker,esnaf,ciftci}` (`koy_nufusu.gd:7`); `zanaatkar`/`dervis` anahtarları sonradan `Oturum._koy_esitle()` (`oturum.gd:335`) ile ekleniyor. `sayi()`/`cikar()` `.get(sinif, 0)` kullanmadığı ve default sözlük eksik olduğu için erişim hata veriyor. Öneri: `.get()` kullan ya da default sözlüğe beş sınıfı ekle.

### BUG-0016 doğrulaması · commit 5396fae · **DOĞRULANDI**
- **Künye:** CHR sorgusunda tüm cevaplar kalıcı kapanıp kalanlar ipucu kilitli olunca oyuncu kapıda sıkışıyordu (7/24 oyunlar 103/106/107/108'de KILIT). Claude `chr_diyalog_paneli.gd`'ye, hiçbir cevap açık değilken görünen "Kararını ver" (düğüm adı `KilitliKarar`) çıkışı ekledi.
- **Kanıt 1 (birim):** `tests/unit/kvr/chr_kilit_cikisi_test.gd` → GEÇTİ (0 hata) — açık cevap varken çıkış yok; tüm cevaplar kapalıyken "Kararını ver" görünür ve `karar_istendi` yayar. Log: `work/tester/tur2/chr_kilit_cikisi.log`.
- **Kanıt 2 (sürekli oyun):** Fix sonrası başlayan oyun 109'da `SOHBET_KILIDI` 0, `KILIT` olayı yok (izleme sürüyor). Fix öncesi 106/107/108'de KILIT vardı.
- **Not:** `SOHBET_KILIDI` satırı aslında otomatik oyuncunun kendi yedeği (`otomatik_oyuncu.gd:167`: incele → karara geç), yani otomatik oyuncu donmuyordu; KILIT olayı gerçek (elle oynayan) oyuncu için softlock'u işaret ediyordu.
- **Pencereli elle doğrulama (ekran görüntüsü):** ÖLÇÜLMEDİ (tur bütçesi; otomatik koşu + birim testiyle yetinildi).

### TST-0003 · P1 · [HATA] · Sinsi gece rutini: köylü bulunamayınca `is_yeri` erişimi her karede SCRIPT ERROR
- **Durum:** AÇIK
- **Commit:** 5396fae (HEAD; 7/24 koşu, oyun 112)
- **Adımlar:** 1) Otomatik oyuncu, TOHUM=112 (kabul 0.2), commit 5396fae 2) Gece olur, köyde yürüyen modeller varken bekle.
- **Beklenen:** Nöbetçi rutini, köylüsü bulunmayan (silinmiş/taşınmış) model için sessizce atlamalı; SCRIPT ERROR olmamalı.
- **Gerçek:** Oyun 112'de 500+ kez `SCRIPT ERROR: Invalid access to property or key 'is_yeri' on a base object of type 'Nil'.` — `src/koy/is_kazalari.gd:18` (`nobet()`, `k.is_yeri`). Çağrı zinciri: `sinsi_gece_rutini.gd:14 nobetciler` → `muhafiz_maasi.gd:10 aday` → `is_kazalari.gd:18`. Üst çağrı `koy_halk_hareketi.gd:94 _process` → hata neredeyse her karede tekrar ediyor.
- **Tekrar:** Tutarlı (olaylar.log: sayi=460→464→511 ve artıyor; aynı tohum/harita gece fazında sürüyor).
- **Kanıt:** `work/tester/oyunlar/oyun_112.log` (satır 311’den itibaren), `~/.codex-tester/olaylar.log` HATA tohum=112.
- **Tahmin:** `sinsi_gece_rutini.nobetciler` (satır 11–15) `h.sahne.yonetim.koylu(id)` sonucunu null denetlemeden `MuhafizMaasi.aday(k, y)`'ye veriyor; `sinif` adayında (`sinsi_gece_rutini.aday`, satır 7) null koruması VAR ama `nobetciler` yolunda yok. `nobetciler` içinde `koylu(id)` null ise `continue` eklemek yeterli görünüyor.
