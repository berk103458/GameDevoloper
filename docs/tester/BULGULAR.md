# Tester Bulguları

Kural ve kalıp: `docs/tester/TESTER_REHBERI.md` §5. Numara TST-0001'den artar; yeni bulgu **en üste** eklenir.
Durumlar: AÇIK → DÜZELTİLDİ (commit) → DOĞRULANDI / YENİDEN AÇILDI. Öncelik P0–P3.

| Kimlik | Öncelik | Madde | Başlık | Durum |
| --- | --- | --- | --- | --- |
| TST-0010 | P3 | SYS-19 | 2. perde hedef gecesi kod varsayılanı (10) ile etkin kaynak (`oyun.tres`=12) uyuşmuyor; kaynak yoksa hedef sessizce 10'a düşer | DOĞRULANDI (8acb352) |
| TST-0005 | P3 | ENVIRONMENT/asset | 43 orphan `.import` (jpg yok) import sırasında 86 ERROR satırı üretiyor | AÇIK |
| TST-0006 | P3 | [DIYALOG] metin | metinler.csv: 'Halkaya  +1' ve 'Tam isabet  +2' çift boşluk; tekfur saldırısı için iki ayrı anahtar | AÇIK |
| TST-0007 | P2 | [CEVRE] chr_011 | chr_011 kukuleta/pelerin mesh'i ölçüsüz; gövdeyi küre gibi sarıyor (el_aci 0.69) | AÇIK |
| TST-0008 | P3 | [CEVRE] modeller | chr_009/chr_021 ayak ~9 cm havada; Aydoğdu yayı bacak/gövdeye giriyor | AÇIK |
| TST-0009 | P3 | [CEVRE]/asset | Çadır modeli (`cadir.glb`) dokusuz → beyaz küre gibi; `assets/model/**` altında hiç `.jpg` yok (TST-0005 etkisi) | AÇIK |
| TST-0004 | P2 | SYS-19/DENGE | Otomatik oyuncu odun zincirini kurmuyor; çadır/tarla önce kurulursa odun geri dönüşsüz biter (oyuncu uyarılmıyor) | AÇIK (strateji tuzağı S3; BUG-0018) |
| TST-0003 | P1 | — | Sinsi gece rutini: koylu(id) null iken is_yeri erişimi; her karede SCRIPT ERROR | DOĞRULANDI (254202d) |
| TST-0002 | P2 | — | 6 metin anahtarı eksik; her oyunda [KEY_NOT_FOUND] uyarısı | AÇIK |
| TST-0001 | P3 | — | KoyNufusu.sayi() eksik sınıf anahtarında SCRIPT ERROR (tetikleyen: test aracının kendi kodu; oyun bu sınıfları sorgulamıyor) | AÇIK (Claude P2→P3) |

---

<!-- Bulgular buradan aşağı, en yenisi üstte -->

### Tur 6 doğrulama özeti · commit 6ce5f62 · (BUG-0016, BUG-0017/TST-0003, TST-0004)
- **BUG-0016 — DOĞRULANDI (tur 6):** `chr_kilit_cikisi_test.gd` → "CHR KILIT CIKISI: GEÇTİ (0 hata)". `~/.codex-tester/olaylar.log`'da KILIT yalnız 106/107/108 (fix öncesi); 5396fae sonrası 0. Loglarda `SOHBET_KILIDI` yalnız 106(2)/107(1)/108(3); 109–140'ta 0. Pencereli elle ekran görüntüsü ÖLÇÜLMEDİ.
- **BUG-0017 / TST-0003 — DOĞRULANDI (tur 6):** `key 'is_yeri'` SCRIPT ERROR toplam 511, tamamı oyun_112 (fix 254202d öncesi); 113–140'ta 0.
- **TST-0004 (BUG-0018, S3 strateji tuzağı) — sürüyor:** Açılış stoğu 20 odun/5 taş (tur 5 ölçümü). Tur 6: 2. perdeye geçen 36 oyunun HEPSİ `odun=0, sur=0, yapı=5` ile girer; odun gün 1'de 0'a düşer. Persona (bilinçli "önce odun zinciri") tohum 601/602/603 → 3/3 g7 Tekfur ölümü. ONR-003/004 aynı kök nedene bağlı (kopya değil).


### TST-0010 · P3 · SYS-19 · 2. perde hedef gecesi: kod varsayılanı 10, etkin kaynak 12 (sessiz yarıya inme riski)
- **Durum:** DOĞRULANDI (8acb352)
- **Commit:** 6ce5f62 (kod 062185b)
- **Adımlar:** 1) `Select-String perde2_hedef_gece src/veri/oyun_ayarlari.gd` → `@export var perde2_hedef_gece: int = 10` 2) aynı anahtar `data/ayarlar/oyun.tres:24` → `perde2_hedef_gece = 12` 3) kod yorumları: `src/koy/perde_gecisi.gd:3` ve `src/koy/koy_yonetimi.gd:59` "(varsayılan) 12" der.
- **Beklenen:** Tek bir doğruluk kaynağı; kod varsayılanı ile etkin ayar aynı olmalı (veya varsayılan 12 olmalı).
- **Gerçek:** GDScript varsayılanı 10, `.tres` etkin değeri 12. Rehber §2 de "12 gece" der. Normal oyunda `.tres` yüklendiği için etkin değer 12; ancak `oyun.tres` herhangi bir nedenle okunamazsa hedef **sessizce 10'a** düşer (oyuncu ve rapor fark etmez). Ayrıca iki yerde 12/10 karışıklığı ileride yanlış test/madde beklentisi üretir.
- **Tekrar:** 2/2 (statik, deterministik).

- **Tur 7 doğrulama (commit 8acb352):** `src/veri/oyun_ayarlari.gd:39` artık `@export var perde2_hedef_gece: int = 12`; `data/ayarlar/oyun.tres:24` = 12; `src/koy/perde_gecisi.gd:3` ve `src/koy/koy_yonetimi.gd:59` yorumları da 12 der. Sınıf varsayılanı / `.tres` etkin değeri / bellek içi yeni OyunAyarlari üçü de 12 → tek değer; .tres okunamazsa artık sessizce 10 değerine düşmez. `perde_gecisi_test` (tam 12 gece + ayar==12 kontrolü), `nihai_son_test`, oto `nihai_son_kontrol` GEÇTİ. Kanıt: work/tester/tur7/tst0010.log, perde_gecisi.log, nihai_son_kontrol.log.

- **Kanıt:** `src/veri/oyun_ayarlari.gd:39`, `data/ayarlar/oyun.tres:24`, `src/koy/perde_gecisi.gd:3`, `src/koy/koy_yonetimi.gd:59`; deneyim: persona/otomatik koşularda 2. perde hedefi pratikte 12 görüldü (oyun 124 g18 zafer).
- **Öneri:** Varsayılanı 12 yap ya da tek kaynak kullan; yorumları ayarla eşitle.


### TST-0009 · P3 · [CEVRE]/asset · Köy sahnesinde beyaz çadır modeli dokusuz (küre gibi görünen yer tutucu) — kimlik çözüldü
- **Durum:** AÇIK
- **Commit:** 39847ea
- **Adımlar:** 1) `CIKTI=work/tester/tur5/koy_gunduz.png GUN=6 KIP=bilgi FAZ=gunduz godot --path . --windowed --audio-driver Dummy tests/oto/koy_foto.tscn` 2) aynısı `FAZ=gece KIP=insa` 3) küçültülmüş `work/tester/tur5/v_koy_gunduz.jpg`, `v_koy_gece.jpg`.
- **Beklenen:** Köy yerleşiminde yapı/nesne ölçüsünde yer tutucular (asset kuralı: kutu/kapsül/düz renk) göze aşırı batmayacak ölçekte (boxsız `.glb` yoksa `BoxMesh`).
- **Gerçek:** Yerleşim kenarında, meydana yakın **kocaman beyaz/pürüzsüz bir küre** duruyor (gündüz beyaz, gece koyu gri; ~2 ızgara hücresi). `Dunya3B.nesne` yalnız `BoxMesh` yer tutucu kullanıyor; küre büyük olasılıkla bir `.glb` modeli. Kod taramasıyla kimlik kesinleşmedi.
- **Tekrar:** 2/2 (gündüz + gece aynı yerde).
- **Kanıt:** `work/tester/tur5/koy_gunduz.png`, `koy_gece.png`, `v_koy_gunduz.jpg`, `v_koy_gece.jpg`.
- **Öneri:** Kürenin hangi nesne/bina olduğu belirlenip ölçeği düzeltilsin; gerekirse `docs/EKSIK_ASSET_ENVANTERI.md`'ye "köy yerleşimi küresel yer tutucu (Yüksek)" eklenir (envanteri Claude ekler; tester yazmaz).
- **Tur 7 güncelleme — kimlik ÇÖZÜLDÜ:** Beyaz küre = **çadır (`res://assets/model/yapi/cadir.glb`)**, dokusu eksik olduğu için **tek renk beyaz** görünüyor. `Dunya3B._yol` yapıyı `assets/model/yapi/<ad>.glb`'den yükler; `cadir.glb.import` `cadir_0.jpg` dokusuna bağlı ama `assets/model/**` altında **tek bir `.jpg` yok (sayı: 0)** → tüm yapı/nesne/karakter modelleri dokusuz (düz renk/beyaz). Bu, TST-0005'in (43 yetim `.import`) oyun içi etkisidir. Ekran görüntüsünde ayrıca meydan yakınındaki **parlak mavi kutu**, inşa hayaleti (`KIP=insa` `_hayalet_guncelle`) olduğu için bulgu değildir. Ölçek/konum sorunu yok; sorun dokunun eksikliği. Kanıt: `work/tester/tur7/v_koy_gunduz_insa.jpg`, `work/tester/tur7/koy_gunduz_insa.png`, `assets/model/yapi/` (yalnız `.import`, `.jpg` yok).

### TST-0007 · P2 · [CEVRE] · chr_011 kukuleta/pelerin mesh'i ölçüsüz (gövdeyi küre gibi sarıyor)
- **Durum:** AÇIK
- **Commit:** 0ac499c
- **Adımlar:** 1) `KLASOR=work/tester/muayene godot --path . --audio-driver Dummy --windowed tests/oto/karakter_muayene.tscn` 2) `work/tester/muayene/chr_011.jpg` temas sayfasını aç (hareketler: bekle/yürü/…).
- **Beklenen:** Pelerin/kukuleta omuz ve gövdeye oturur; baş ve gövde ölçüsünde kıyafet (GDD: karakter giysisi gövdeye sarılır).
- **Gerçek:** Kahverengi pelerin mesh'i başın çok üstüne taşarak gövdeyi kocaman şişkin bir küre gibi sarıyor; kollar pelerinin içinde kayboluyor. Ölçüm: `el_aci` 0.69 (bekle) / 0.64 (yürü) — setin en yükseği (eşik 0.45). Yürümede pelerin gövdeden kopuk/şişkin kalıyor.
- **Tekrar:** 1/1 görsel (tutarlı, statik model).
- **Kanıt:** `work/tester/muayene/chr_011.jpg`, `work/tester/muayene/muayene.json` (chr_011.uyarilar).
- **Öneri:** chr_011 kıyafet/kukuleta mesh'i gövde ölçüsüne göre yeniden ölçeklendirilsin (asset üretmeden mevcut mesh düzeltmesi). Asset envanterine "chr_011 pelerin (Yüksek)" olarak girer.

### TST-0008 · P3 · [CEVRE] · Modellerde ayak havada ve el eşyası çakışması
- **Durum:** AÇIK
- **Commit:** 0ac499c
- **Adımlar:** 1) Karakter muayenesi 2) `work/tester/muayene/chr_009.jpg`, `chr_021.jpg`, `aydogdu.jpg` sayfaları + `muayene.json`.
- **Beklenen:** Konuşma/öfke/yürüme kliplerinde ayaklar yere basar (ayak_y ≈ 0); el eşyası (yay) gövdeye/bacağa girmez.
- **Gerçek:** chr_009 — `konus`/`ofke` kliplerinde ayaklar yerden kopuk (en alt 0.09 m); chr_021 — `yuru` 0.09 m havada. Aydoğdu — yan bakışta yay, bacak ve gövde silüetinin içinden geçiyor (el eşyası çakışması, Claude 11 Ekim gözlemi doğrulandı).
- **Tekrar:** 3/3 (muayene.json ölçümü + görsel).
- **Kanıt:** `work/tester/muayene/chr_009.jpg`, `work/tester/muayene/chr_021.jpg`, `work/tester/muayene/aydogdu.jpg`, `work/tester/muayene/muayene.json`.
- **Öneri:** İlgili kliplerde ayak kökünü zemine sabitle (root motion/ayak hedefi); Aydoğdu yayının tutuş açısını/uzunluğunu gövde-bacak çakışmayacak şekilde ayarla.

### TST-0004 · not (Tur 4, commit 0ac499c) — BUG-0018 ile özdeş, DOĞRULANDI
- **Doğrulama:** `git show --stat 0ac499c` yalnız denetim dosyasına BUG-0018 satırı ekliyor (oyun kodu değişmedi). BUG-0018 ile TST-0004 **aynı kök neden** (EKO-02 odun kilidi). Tur 4 kanıtı: 2. perdeye ulaşan **tüm** oyunlarda `odun=0, sur=0, yapı=5`; 24 oyunda **zafer 0**; ortalama son gün ≈ 11,4. İddia + kanıt birebir uyuşuyor. Durum **AÇIK** kalır (ROADMAP 2, düzeltilmedi).

### BUG-0016 / BUG-0017 · not (Tur 4) — tekrar DOĞRULANDI
- **BUG-0016 (5396fae):** fix sonrası oyunlar 109–123'te KILIT olayı ve `SOHBET_KILIDI` = 0 (KILIT yalnız fix öncesi 106/107/108'de). `chr_kilit_cikisi_test` tekrar GEÇTİ (0 hata).
- **BUG-0017 (254202d):** oyunlar 113–123'te `is_yeri` SCRIPT ERROR = **0** (11/11). 
- **Tur 7 (BUG-0016 DOĞRULANDI):** `chr_kilit_cikisi_test` → "CHR KILIT CIKISI: GEÇTİ (0 hata)". `olaylar.log` KILIT toplam 3 (106/107/108, fix öncesi b9865ba/df55a1b); `SOHBET_KILIDI` yalnız 106/107/108; **109–149 arası 0**. Fix 5396fae (01:53:44) sonrası yeni kilit/softlock **yok**. Tasarım adaleti sorusu (yanlışlıkla tüketilen cevabın geri dönüşü, "tek şans" uyarısı) → **ONR-001**'e kod kanıtı eklendi (`chr_sorgusu.gd:69-71`, `chr_diyalog_paneli.gd:40`).
### TST-0006 · P3 · [DIYALOG]/metin · metinler.csv: çift boşluk ve yinelenen Tekfur saldırı metni
- **Durum:** AÇIK
- **Commit:** 0ac499c
- **Adımlar:** 1) `data/metin/metinler.csv` ilk 150 satırı (§13.3 dilim: satır 2–150) oku 2) çift boşluk ve aynı olayın iki anahtarını ara.
- **Beklenen:** Metinlerde tek boşluk; bir olayın tek kanonik anahtarı olur (yazım denetimi: tools/metin_dogrula.py).
- **Gerçek:** İki satırda çift boşluk: `arayuz.oyun.kenar` = "Halkaya  +1", `arayuz.oyun.tam` = "Tam isabet  +2". Ayrıca Tekfur saldırısı için iki ayrı anahtar: `anlati.saldiri.guc` = "Tekfur'un adamları: güç %d. Köyün savunması: %d." (satır 33) ve kullanılan `koy.olay.tekfur_baskini` = "Tekfur'un akıncıları geldi: güçleri %d, savunman %d." (satır 340). `anlati.saldiri.guc` kod ile çağrılıyor mu belirsiz (yetim/legacy olabilir).
- **Tekrar:** 2/2 (dosya okuması, statik).
- **Kanıt:** `data/metin/metinler.csv:111,116,33,340`; dilim notu work/tester/tur4/metin_ilk150.txt.
- **Öneri:** Çift boşlukları tek boşluğa indir; `anlati.saldiri.guc` kullanılmıyorsa kaldır, kullanılıyorsa `koy.olay.tekfur_baskini` ile birleştir (metin tutarlılığı). CSV'yi tester değiştirmez.
- **Tur 7 dilim notu:** `metinler.csv` satır 451–600 tarandı — **temiz** (çift boşluk 0, format kalıntısı 0, `KEY_NOT_FOUND` 0). Tek küçük imla: `olay.nogay_haber.metin` "Nogay geceyarısı yanına geldi" → TDK **"gece yarısı"** (ayrı). Sonraki dilim: satır 601–750.
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
- **Tur 4 notu (0ac499c):** Hâlâ 43 yetim `.import` var; bu tur import logunda `_yuru_Image_0.jpg` geçen **124 satır**, toplam **140 ERROR satırı** (`work/tester/tur4/sanity_import.log`). Durum **AÇIK**.


### TST-0004 · P2 · SYS-19/DENGE · Ana kayıt · Otomatik oyuncu odun zincirini kurmuyor; çadır/tarla önce kurulursa odun geri dönüşsüz biter (oyuncu uyarılmıyor)
- **Durum:** AÇIK
- **Tur 7 güncelleme (ana kayıt):** Başlık ve öncelik düzeltildi (P1 → P2). Kök neden **kesin kilit DEĞİL**, **strateji tuzağı (S3)**: açılış stoğu 20 odun / 5 taş; Orman Kampı (+odunluk) + Hızarhane önce kurulursa zincir başlar. Sorun, otomatik oyuncunun/oyuncunun önce çadır/tarla kurup odunu geri dönüşsüz tüketmesi ve oyunun bunu **uyarmaması**. Kanıt: ADM-16 köprü durum dökümü (`get_state` ambar.odun=20, tas=5, gün 0); tur 6 ölçümü 36/36 oyun 2. perdeye `odun=0, sur=0, yapı=5` ile giriyor. BUG-0018 (denetim 062185b) iddiası buna göre düzeltildi. **Bu kayıt tek ana kayıttır; ONR-003 ve ONR-004 ona bağlıdır (kopya değil, aynı kök neden).**
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
- **Durum:** AÇIK (P3 — Tur 6, Claude kararı)
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

- **Tur 6 notu (Claude kararı):** Tetikleyen satır tester aracının kendi DURUM çıktısıydı; oyun bu sınıfları (zanaatkar/dervis) kendisi sorgulamıyor → **P2→P3**. Savunmasız API önerisi **ONR-002** olarak Codex kuyruğunda. TST-0002 de Codex kuyruğunda.
