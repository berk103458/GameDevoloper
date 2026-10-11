# BÖLÜM 43 — Arayüz görsel revizyonu ve ekran envanteri

Faz 6, ARY ile birlikte, yüksek öncelik. Zemin:

- ARY-01 üç şablon ve seçim (`docs/arayuz/SABLONLAR.md`). Seçim yoksa ARY-02 başlamaz. Bu bölüm şablon icat etmez.
- ARY-02 tema kaynağı `src/arayuz/tema/*.tres`; `tema.gd` bağlar. `GOVDE_PX 26`, `KUCUK_PX 22`, `BASLIK_PX 34`.
- ARY-03 sekiz alt kapanış: harita, sorgu, seçim, köy HUD, pazar, divan, oda, gece raporu. Bu bölüm o sekizini dosya adına bağlar; ARY kimliği değişmez.
- ARY-04 yükleme yuvaları. ARY-05 envanter. Yer tutucu düz renktir.
- `Renkler`, `Sanat.KOK = res://assets/art/`. Menü zemini `menu_ekrani.gd` `ColorRect` `Renkler.GECE` artı 3B `MenuSahnesi`. Ayarlar zemini `ayarlar_ekrani.gd:21–24` yalnız `ColorRect` `Renkler.GECE`. Yükleme `varlik_yukleme_paneli.gd` `Color("#0d1117")`.

Aşağıdaki tablo envanterin kendisidir. Listede olmayan bir ekran ARY-03 kapsamına girmez. Widget'lar ekran sayılmaz.

| Ekran | Dosya | Zemin bugün |
|---|---|---|
| Kök / geçiş | `src/arayuz/ana.gd` | sahne yok, çocuk ekran |
| Menü | `menu_ekrani.gd`, `menu_satiri.gd`, `menu_susu.gd` | 3B gece + `ColorRect` |
| Ayarlar | `ayarlar_ekrani.gd`, `grafik_ayarlari_paneli.gd` | yalnız `ColorRect` GECE |
| Yükleme | `varlik_yukleme_paneli.gd` | düz `#0d1117` |
| Bilgi, son, duraklat, perde | `bilgi_ekrani.gd` (`ana._bilgi`, `arka_plan`) | `3d_kapi` / `3d_koy` / duraklatta `""` |
| Kapı | `kapi_ekrani.gd`, `hud.gd`, `hud_islem_kapisi.gd` | 3B kapı |
| Kapı parçaları | `chr_diyalog_paneli.gd`, `chr_inceleme_paneli.gd`, `chr_kapi_adaptoru.gd`, `heybe_paneli.gd`, `heybe_cizimi.gd`, `esya_karti.gd`, `esya_simgesi.gd`, `kapi/esya_detay_karti.gd`, `kapi/kapi_gorus_adaptoru.gd`, `kapi/tansiyon_gostergesi.gd`, `heyet_kapi_paneli.gd`, `tuccar_kapi_paneli.gd` | kapı sahnesinin üstü |
| Köy | `koy_ekrani.gd`, `koy_atama_alani.gd`, `koylu_karti.gd`, `koylu_surukleme_kulpu.gd` | 3B köy |
| Harita | `harita_ekrani.gd` | ARY-03 harita |
| Divan | `src/kapi/divan_ekrani.gd` (+ `divan_sorgu_paneli.gd`, `divan_hukum_paneli.gd`, `divan_kanit_karti.gd`, `divan_haksizlik_paneli.gd`, `divan_baglantisi.gd`) | ayrı ekran |
| Muhafız odası | `muhafiz_odasi_ekrani.gd`, `oda_kasasi_paneli.gd`, `oda_terazisi_paneli.gd`, `oda_vicdan_paneli.gd`, `oda_yetenek_paneli.gd`, `oda_gelistirme_paneli.gd`, `oda_envanter_sergisi.gd`, `oda_teftis_notu.gd` | oda sahnesi |
| Mini oyun | `mini_oyun.gd`, `harman_oyunu.gd`, `okculuk_oyunu.gd` | oyun kadrajı |
| Köy HUD | `src/arayuz/koy_hud/*.gd` (43 dosya; pazar `pazar_satis_paneli.gd`, meclis `cinar_meclis_paneli.gd`, cenaze `cenaze_raporu.gd`) | köyün üstü |
| Tema | `tema.gd`, `renkler.gd`, `sanat.gd`, `cerceve_kutu.gd`, `muhur.gd`, `adim.gd` | kaynak |

Gece raporu ayrı ekran değildir: `src/sistemler/gece_bilancosu.gd` köy ekranında çizilir. İkinci rapor sahnesi açılmaz.

Kimlikler GRV-01 … GRV-101. Asset üretilmez. Bitince `[x]` ve ajan adı.

**Madde biçimi:** Ne, Kabul, Bağımlılık + Boyut, Dosya, Asset.

---

## 43.1 Envanter kapanışı

- [ ] **GRV-01:** Bu tablodaki her ekranın bir zemin hükmü vardır.
  - Ne: hüküm üçtür: `sahne` (3B duruyor), `tema` (ARY-02 düzlemi), `eksik` (düz renk, sahne yok). Hüküm bu dosyadaki tablonun sağ sütunundan çıkar, ikinci liste tutulmaz.
  - Kabul: tabloda satırı olup hükmü boş ekran 0. Test: satır sayımı.
  - Bağımlılık: ARY-02. Boyut: S.
  - Dosya: bu bölüm. Uygulanırken kopya `docs/arayuz/EKRANLAR.md` (oyun deposu).
  - Asset: asset gerekmedi.
- [ ] **GRV-02:** Ayarlar `eksik`tir.
  - Ne: `ayarlar_ekrani.gd` zemini yalnız `ColorRect`. ARY-02 sonrası tema düzlemi gelir; fotoğraf üretilmez. Sağ kenar boşluğu bugün `margin_right 760` (satır 30) — 1600×900'de sağ yarı boş kalır, yerleşim tema ile dolar.
  - Kabul: yerel `ColorRect` rengi 0, tema kaynağından 1. Test: ARY-02 tarama.
  - Bağımlılık: ARY-02, GRV-01. Boyut: M.
  - Dosya: `src/arayuz/ayarlar_ekrani.gd`.
  - Asset: asset gerekmedi.
- [ ] **GRV-03:** Yükleme `eksik`tir, ARY-04 yuvasına bağlanır.
  - Ne: `#0d1117` gömülü renk kalkar. Zemin ARY-04 yuvası ya da yuva yoksa tema nötrüdür. Metin TEK-21 anahtarıdır. Yeni sinematik yok.
  - Kabul: dosyada `Color("#0d1117")` 0. Test: tarama.
  - Bağımlılık: ARY-04, TEK-21. Boyut: S.
  - Dosya: `varlik_yukleme_paneli.gd`.
  - Asset: ARY-04 yer tutucusu. Yeni satır yok.
- [ ] **GRV-04:** Duraklat zemini boş string bırakmaz.
  - Ne: `ana.gd:152` duraklat `arka_plan ""` verir. Boşken `bilgi_ekrani` tema düzlemi kullanır, pembe/şeffaf delik yok.
  - Kabul: duraklatta arka plan düğümü 1. Test: ekran.
  - Bağımlılık: ARY-02. Boyut: S.
  - Dosya: `bilgi_ekrani.gd`.
  - Asset: asset gerekmedi.

## 43.2 ARY-03 sekizi — dosya bağı

- [ ] **GRV-05:** Harita `harita_ekrani.gd`.
  - Ne: ARY-03 harita alt kapanışı bu dosyadır. Bölge haritası (R1) yeniden kurulmaz, kabuk değişir.
  - Kabul: önce/sonra görüntüsü ARY-03 raporunda bu dosya adıyla. Test: ARY-03.
  - Bağımlılık: ARY-03. Boyut: M.
  - Dosya: `src/arayuz/harita_ekrani.gd`.
  - Asset: `ARY03-HARITA` yer tutucu, düz renk.
- [ ] **GRV-06:** Sorgu `kapi_ekrani.gd` konuşma kutusu ve `chr_diyalog_paneli.gd`.
  - Ne: `KONUSMA` dikdörtgeni (satır 14, `Rect2(36, 742, 1104, 314)`) ve sağ `DEFTER` (satır 13) tema kaynağına bağlanır. 3B kapı sahnesi yeniden çizilmez.
  - Kabul: iki panelde yerel renk 0. Test: ARY-02 tarama.
  - Bağımlılık: ARY-03. Boyut: M.
  - Dosya: `kapi_ekrani.gd`, `chr_diyalog_paneli.gd`.
  - Asset: asset gerekmedi.
- [ ] **GRV-07:** Seçim düğmeleri kapı karar çubuğudur.
  - Ne: `kapi_ekrani` karar düğmeleri (`_karar_dugmeleri`) tema düğme durumlarını (normal, üstünde, basılı, kapalı) kullanır. Yeni karar türü eklenmez.
  - Kabul: düğme `StyleBox` tema kaynağından. Test: tarama.
  - Bağımlılık: ARY-02. Boyut: S.
  - Dosya: `kapi_ekrani.gd`.
  - Asset: asset gerekmedi.
- [ ] **GRV-08:** Köy HUD `src/arayuz/koy_hud/`.
  - Ne: 43 panel tek tema kaynağı. Her panele ayrı palet yok. İşlev (pazar, meclis, cenaze, vergi) durur.
  - Kabul: klasörde yerel renk tarama 0, istisna listesi ARY-02 belgesinde. Test: tarama.
  - Bağımlılık: ARY-02. Boyut: L.
  - Dosya: `src/arayuz/koy_hud/*.gd`.
  - Asset: asset gerekmedi.
- [ ] **GRV-09:** Pazar `pazar_satis_paneli.gd`.
  - Ne: ARY-03 pazar alt kapanışı bu panel ve `ticaret_fiyat_paneli.gd`, `pazar_kart_kaydirma.gd`. Fiyat motoru değişmez.
  - Kabul: üç dosyada yerel renk 0. Test: tarama.
  - Bağımlılık: ARY-03. Boyut: S.
  - Dosya: adı geçen üç dosya.
  - Asset: asset gerekmedi.
- [ ] **GRV-10:** Divan `divan_ekrani.gd`.
  - Ne: sorgu, hüküm, kanıt, haksızlık panelleri aynı tema. `divan_meydani.gd` 3B'dir, kabuk işi değildir (Bölüm 44).
  - Kabul: dört panel dosyasında yerel renk 0. Test: tarama.
  - Bağımlılık: ARY-03. Boyut: M.
  - Dosya: `src/kapi/divan_ekrani.gd` ve üç panel.
  - Asset: asset gerekmedi.
- [ ] **GRV-11:** Oda `muhafiz_odasi_ekrani.gd`.
  - Ne: yedi `oda_*` paneli tema. Terazi, vicdan, kasa kuralları ODA maddelerindedir, burada değişmez.
  - Kabul: oda ekranında yerel renk 0. Test: tarama.
  - Bağımlılık: ARY-03. Boyut: M.
  - Dosya: `muhafiz_odasi_ekrani.gd`, `oda_*.gd`.
  - Asset: asset gerekmedi.
- [ ] **GRV-12:** Gece raporu ayrı sahne olmaz.
  - Ne: `gece_bilancosu.gd` çıktısı köy ekranındaki mevcut kadrajda tema ile çizilir. `gece_raporu_ekrani.tscn` açılmaz.
  - Kabul: bu adlı sahne 0. Test: tarama.
  - Bağımlılık: ARY-03. Boyut: S.
  - Dosya: `koy_ekrani.gd` rapor çizimi.
  - Asset: asset gerekmedi.

## 43.3 Okunurluk

- [ ] **GRV-13:** Gövde puntosu 26'nın altına inmez.
  - Ne: `Tema.GOVDE_PX` 26 tabandır; `metin_olcegi` 100'de gövde 26. HUD sayı etiketleri `KUCUK_PX` 22'nin altına yerel punto ile düşmez.
  - Kabul: 22 altı `font_size` override tarama 0 (istisna: `performans_seridi.gd` 18, debug, SRM-05'te yok). Test: tarama.
  - Bağımlılık: ARY-02. Boyut: S.
  - Dosya: `tema.gd`.
  - Asset: asset gerekmedi.
- [ ] **GRV-14:** ADV-01 kart düzeni GRV ile aynı geçişte kapanır.
  - Ne: TEK-03 güvenlik satırı, kart teması değişirken kaybolmaz. İki iş aynı dosyada çakışırsa satır üstte kalır.
  - Kabul: tema sonrası satır görünür. Test: TEK-03.
  - Bağımlılık: TEK-03. Boyut: S.
  - Dosya: `koylu_karti.gd`.
  - Asset: asset gerekmedi.
- [ ] **GRV-15:** Uzun metin kesilmez, kayar.
  - Ne: kapı konuşması ve divan metni `autowrap` + kaydırma. 1920 ve 1280'de son satır kaydırılarak okunur (tester K5).
  - Kabul: 400 karakterlik deneme metninde kesilen glif 0. Test: iki çözünürlük.
  - Bağımlılık: GRV-06. Boyut: M.
  - Dosya: `chr_diyalog_paneli.gd`, `divan_sorgu_paneli.gd`.
  - Asset: asset gerekmedi.

## 43.4 Odak ve durum

- [ ] **GRV-16:** Düğme dört durumu temadadır.
  - Ne: normal, üstünde, basılı, kapalı. Kapalı devam düğmesi (`pasifler`) kapalı stili kullanır, kaybolmaz.
  - Kabul: kayıtsız menüde devam görünür ve `disabled`. Test: menü.
  - Bağımlılık: ARY-01. Boyut: S.
  - Dosya: `menu_satiri.gd`.
  - Asset: asset gerekmedi.
- [ ] **GRV-17:** Odak çerçevesi AYR ile aynı anahtardır.
  - Ne: klavye odağı kalınlığı AYR `odak_cercevesi` değeridir. Burada ikinci çerçeve rengi yok.
  - Kabul: tema odak stili 1. Test: AYR ile ortak.
  - Bağımlılık: AYR. Boyut: S.
  - Dosya: tema kaynağı.
  - Asset: asset gerekmedi.

## 43.5 Mini oyun ve heybe

- [ ] **GRV-18:** Harman ve okçuluk kadrajı temaya girer, kuralı girmez.
  - Ne: `harman_oyunu.gd`, `okculuk_oyunu.gd` skor yazısı tema puntosu. Oyun eşiği `OlayVerisi` içindedir, değişmez.
  - Kabul: skor puntosu `boyut()` ile ölçeklenir. Test: ölçek 150.
  - Bağımlılık: ARY-02. Boyut: S.
  - Dosya: iki oyun dosyası.
  - Asset: asset gerekmedi.
- [ ] **GRV-19:** Heybe paneli kapı defterinin üstüne taşmaz.
  - Ne: `heybe_paneli.gd` açıkken `DEFTER` dikdörtgeni ile çakışma alanı 0 (tester üst üste panel). Çakışırsa panel konuşma kutusunun üstünde, defterin solunda durur.
  - Kabul: 1600×900'de iki dikdörtgen kesişimi boş. Test: ölçüm.
  - Bağımlılık: GRV-06. Boyut: S.
  - Dosya: `heybe_paneli.gd`.
  - Asset: asset gerekmedi.

## 43.6 Menü

- [ ] **GRV-20:** Menü 3B sahnesi durur.
  - Ne: `MenuSahnesi` referans yerleşimi (4 Ekim notu, dosya başı) bozulmaz. Tema yalnız yazı ve düğmeye gelir.
  - Kabul: `SubViewport` düğümü durur. Test: menü açılır.
  - Bağımlılık: ARY-02. Boyut: S.
  - Dosya: `menu_ekrani.gd`.
  - Asset: asset gerekmedi.
- [ ] **GRV-21:** Menü ipucu köşesi ölçekle taşmaz.
  - Ne: sağ alt ipucu (`offset` satır 74–80) `metin_olcegi` 150'de ekran içinde kalır.
  - Kabul: 150 ölçekte ipucu kutusu viewport içindedir. Test: iki ölçek.
  - Bağımlılık: AYR. Boyut: S.
  - Dosya: `menu_ekrani.gd`.
  - Asset: asset gerekmedi.

## 43.7 Tutarlılık taraması

- [ ] **GRV-22:** Gömülü renk listesi kapanır.
  - Ne: `src/arayuz/**/*.gd` içinde `Color("#` ve `ColorRect` ham renk ARY-02 istisna listesinde değilse hatadır. `Renkler` sabitleri tema kaynağına taşınınca istisna da düşer.
  - Kabul: istisna dışı 0. Test: `tools/` tarama kuralı.
  - Bağımlılık: ARY-02. Boyut: M.
  - Dosya: yeni tarama kuralı, `sanity_check.py` tek satır.
  - Asset: asset gerekmedi.
- [ ] **GRV-23:** Admin katmanı tema yutmaz (ARY-02 kural 4).
  - Ne: `src/debug/` renkleri oyuncu temasına girmez.
  - Kabul: debug dosyası tema kaynağını import etmez. Test: tarama.
  - Bağımlılık: ARY-02. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

## 43.8 Yeni ekranlar — kabuk hazır, sistem değil

- [ ] **GRV-24:** Hafıza defteri kabuğu bu temadadır.
  - Ne: HFZ-01 ekranı bilgi ekranı yerleşimini kullanır, kendi paletini açmaz.
  - Kabul: `hafiza_defteri_ekrani.gd` içinde `Color("#` 0. Test: tarama.
  - Bağımlılık: HFZ-01, ARY-02. Boyut: S.
  - Dosya: `hafiza_defteri_ekrani.gd`.
  - Asset: asset gerekmedi.
- [ ] **GRV-25:** Ayar sekmeleri (35, 45, 46) aynı paneldedir.
  - Ne: ses, görüntü, oyun, kontroller (GIR-01), dil (YER-01) ayrı pencere açmaz. Ayarlar ekranı sekmeli tek kabuktur.
  - Kabul: aynı anda açık ayar penceresi 1. Test: sekme geçişi.
  - Bağımlılık: GIR-01, YER-01, ARY-02. Boyut: M.
  - Dosya: `ayarlar_ekrani.gd`.
  - Asset: asset gerekmedi.

## 43.9 Asset sınırı

- [ ] **GRV-26:** Yeni doku üretilmez.
  - Ne: eksik zemin ARY-05'e yazılır: `GRV02-AYARLAR`, `GRV04-DURAKLAT`. Yer tutucu tema düzlemi. İndirme yok.
  - Kabul: bu madde dosya üretmez. Test: sayım.
  - Bağımlılık: ARY-05. Boyut: S.
  - Dosya: `docs/EKSIK_ASSET_ENVANTERI.md`.
  - Asset: iki envanter satırı. Yer tutucu: tema rengi.
- [ ] **GRV-27:** Portre ve ikon `Sanat`'tan gelir.
  - Ne: `sanat.gd` `portre` / `doku` durur. Panel kendi `load` yolunu açmaz.
  - Kabul: `src/arayuz` içinde `load("res://assets` tarama, `Sanat.` dışı 0 (istisna belgede). Test: tarama.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

## 43.10 Sınırlar ve kapanış

- [ ] **GRV-28:** Oynanış bu bölümden değişmez.
  - Ne: kabul, ret, hız, fiyat, divan hükmü aynı fonksiyonlardır. Yalnız çizim kaynağı değişir.
  - Kabul: `api_sozlesmesi.py` oyun kuralları farkı 0. Test: araç.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: baseline.
  - Asset: asset gerekmedi.
- [ ] **GRV-29:** 3B cila Bölüm 44'tür.
  - Ne: kamera, animasyon, pelerin, ayak (TST-0007/0008) burada yoktur.
  - Kabul: `src/koy/gorsel/` diff'i bu bölümden 0. Test: tarama.
  - Bağımlılık: SAH. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **GRV-30:** Kapanış testi.
  - Ne: ayarlar ve yüklemede gömülü renk 0; sekiz ARY-03 dosya adı raporda; duraklat zemini var; heybe-defter kesişimi boş; debug tema import etmez.
  - Kabul: beş iddia. Test: tarama betiği `tests/tools/test_arayuz_renk.py`.
  - Bağımlılık: GRV-01…29. Boyut: M.
  - Dosya: yeni test.
  - Asset: asset gerekmedi.

Alt başlık 43.2'de sekiz madde vardır; diğerlerinde iki ile dört. Onuncu madde, her HUD dosyasına ayrı kimlik açacağı için konmadı (43 dosya tek maddede, GRV-08). Toplam 30 madde.

## 43.11 Ekran envanteri — arka plansız veya düz düğme

Her satır 11 Ekim 2026 taramasındandır (`ColorRect` ve `Button.new` sayımı). Oynanış fonksiyonu değişmez. Asset üretilmez. GRV-08 klasör maddesi durur; burada dosya dosyadır.

### 43.11 Kapı ve inceleme

- [ ] **GRV-31:** `chr_diyalog_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/chr_diyalog_paneli.gd` bugün ColorRect 0 ve 3 düz düğmeyle duruyor; notu: Konuşma seçenekleri düz düğme. Tema bağlanınca yalnız `chr_diyalog_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Konuşma seçenekleri düz düğme davranışı değişmez.
  - Kabul: `chr_diyalog_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `chr_diyalog_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/chr_diyalog_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-32:** `chr_inceleme_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/chr_inceleme_paneli.gd` bugün ColorRect 0 ve 4 düz düğmeyle duruyor; notu: Bakış seçenekleri düz düğme. Tema bağlanınca yalnız `chr_inceleme_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Bakış seçenekleri düz düğme davranışı değişmez.
  - Kabul: `chr_inceleme_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `chr_inceleme_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/chr_inceleme_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-33:** `grafik_ayarlari_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/grafik_ayarlari_paneli.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Grafik seçicisi düz düğme, zemin yok. Tema bağlanınca yalnız `grafik_ayarlari_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Grafik seçicisi düz düğme, zemin yok davranışı değişmez.
  - Kabul: `grafik_ayarlari_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `grafik_ayarlari_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/grafik_ayarlari_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-34:** `esya_karti.gd` temaya bağlanır.
  - Ne: `src/arayuz/esya_karti.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Eşya kartı zeminsiz. Tema bağlanınca yalnız `esya_karti.gd` ARY-02 zeminini ve düğme durumunu okur, Eşya kartı zeminsiz davranışı değişmez.
  - Kabul: `esya_karti.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `esya_karti.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/esya_karti.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-35:** `hud.gd` temaya bağlanır.
  - Ne: `src/arayuz/hud.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Kapı HUD yazısı zeminsiz. Tema bağlanınca yalnız `hud.gd` ARY-02 zeminini ve düğme durumunu okur, Kapı HUD yazısı zeminsiz davranışı değişmez.
  - Kabul: `hud.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `hud.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/hud.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-36:** `koy_ekrani.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_ekrani.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Köy araç şeridi düz düğme; 3B sahne zemin sayılmaz. Tema bağlanınca yalnız `koy_ekrani.gd` ARY-02 zeminini ve düğme durumunu okur, Köy araç şeridi düz düğme; 3B sahne zemin sayılmaz davranışı değişmez.
  - Kabul: `koy_ekrani.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `koy_ekrani.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_ekrani.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-37:** `koylu_karti.gd` temaya bağlanır.
  - Ne: `src/arayuz/koylu_karti.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Köylü kartı zeminsiz. Tema bağlanınca yalnız `koylu_karti.gd` ARY-02 zeminini ve düğme durumunu okur, Köylü kartı zeminsiz davranışı değişmez.
  - Kabul: `koylu_karti.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `koylu_karti.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koylu_karti.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-38:** `koy_atama_alani.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_atama_alani.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Atama alanı zeminsiz. Tema bağlanınca yalnız `koy_atama_alani.gd` ARY-02 zeminini ve düğme durumunu okur, Atama alanı zeminsiz davranışı değişmez.
  - Kabul: `koy_atama_alani.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `koy_atama_alani.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_atama_alani.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-39:** `heyet_kapi_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/heyet_kapi_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Heyet paneli zeminsiz. Tema bağlanınca yalnız `heyet_kapi_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Heyet paneli zeminsiz davranışı değişmez.
  - Kabul: `heyet_kapi_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `heyet_kapi_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/heyet_kapi_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-40:** `tuccar_kapi_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/tuccar_kapi_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Tüccar paneli zeminsiz. Tema bağlanınca yalnız `tuccar_kapi_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Tüccar paneli zeminsiz davranışı değişmez.
  - Kabul: `tuccar_kapi_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `tuccar_kapi_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/tuccar_kapi_paneli.gd`.
  - Asset: asset gerekmedi.


### 43.12 Köy, kart, oda

- [ ] **GRV-41:** `oda_gelistirme_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/oda_gelistirme_paneli.gd` bugün ColorRect 0 ve 2 düz düğmeyle duruyor; notu: Geliştirme düğmeleri düz. Tema bağlanınca yalnız `oda_gelistirme_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Geliştirme düğmeleri düz davranışı değişmez.
  - Kabul: `oda_gelistirme_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `oda_gelistirme_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/oda_gelistirme_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-42:** `oda_kasasi_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/oda_kasasi_paneli.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Kasa düğmesi düz, zemin yok. Tema bağlanınca yalnız `oda_kasasi_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Kasa düğmesi düz, zemin yok davranışı değişmez.
  - Kabul: `oda_kasasi_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `oda_kasasi_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/oda_kasasi_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-43:** `oda_terazisi_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/oda_terazisi_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Terazi yazısı zeminsiz. Tema bağlanınca yalnız `oda_terazisi_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Terazi yazısı zeminsiz davranışı değişmez.
  - Kabul: `oda_terazisi_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `oda_terazisi_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/oda_terazisi_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-44:** `oda_vicdan_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/oda_vicdan_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Vicdan yazısı zeminsiz. Tema bağlanınca yalnız `oda_vicdan_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Vicdan yazısı zeminsiz davranışı değişmez.
  - Kabul: `oda_vicdan_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `oda_vicdan_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/oda_vicdan_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-45:** `oda_yetenek_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/oda_yetenek_paneli.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Yetenek düğmesi düz. Tema bağlanınca yalnız `oda_yetenek_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Yetenek düğmesi düz davranışı değişmez.
  - Kabul: `oda_yetenek_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `oda_yetenek_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/oda_yetenek_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-46:** `harman_oyunu.gd` temaya bağlanır.
  - Ne: `src/arayuz/harman_oyunu.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Harman kadrajı zeminsiz. Tema bağlanınca yalnız `harman_oyunu.gd` ARY-02 zeminini ve düğme durumunu okur, Harman kadrajı zeminsiz davranışı değişmez.
  - Kabul: `harman_oyunu.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `harman_oyunu.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/harman_oyunu.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-47:** `okculuk_oyunu.gd` temaya bağlanır.
  - Ne: `src/arayuz/okculuk_oyunu.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Okçuluk kadrajı zeminsiz. Tema bağlanınca yalnız `okculuk_oyunu.gd` ARY-02 zeminini ve düğme durumunu okur, Okçuluk kadrajı zeminsiz davranışı değişmez.
  - Kabul: `okculuk_oyunu.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `okculuk_oyunu.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/okculuk_oyunu.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-48:** `tansiyon_gostergesi.gd` temaya bağlanır.
  - Ne: `src/arayuz/kapi/tansiyon_gostergesi.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Tansiyon yazısı zeminsiz. Tema bağlanınca yalnız `tansiyon_gostergesi.gd` ARY-02 zeminini ve düğme durumunu okur, Tansiyon yazısı zeminsiz davranışı değişmez.
  - Kabul: `tansiyon_gostergesi.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `tansiyon_gostergesi.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/kapi/tansiyon_gostergesi.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-49:** `kapi_gorus_adaptoru.gd` temaya bağlanır.
  - Ne: `src/arayuz/kapi/kapi_gorus_adaptoru.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Görüş satırı zeminsiz. Tema bağlanınca yalnız `kapi_gorus_adaptoru.gd` ARY-02 zeminini ve düğme durumunu okur, Görüş satırı zeminsiz davranışı değişmez.
  - Kabul: `kapi_gorus_adaptoru.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `kapi_gorus_adaptoru.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/kapi/kapi_gorus_adaptoru.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-50:** `divan_ekrani.gd` temaya bağlanır.
  - Ne: `src/kapi/divan_ekrani.gd` bugün ColorRect 0 ve 2 düz düğmeyle duruyor; notu: Divan ekranı zeminsiz, düz düğme. Tema bağlanınca yalnız `divan_ekrani.gd` ARY-02 zeminini ve düğme durumunu okur, Divan ekranı zeminsiz, düz düğme davranışı değişmez.
  - Kabul: `divan_ekrani.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `divan_ekrani.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/kapi/divan_ekrani.gd`.
  - Asset: asset gerekmedi.


### 43.13 Divan

- [ ] **GRV-51:** `divan_sorgu_paneli.gd` temaya bağlanır.
  - Ne: `src/kapi/divan_sorgu_paneli.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Divan sorgu düğmesi düz. Tema bağlanınca yalnız `divan_sorgu_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Divan sorgu düğmesi düz davranışı değişmez.
  - Kabul: `divan_sorgu_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `divan_sorgu_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/kapi/divan_sorgu_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-52:** `divan_hukum_paneli.gd` temaya bağlanır.
  - Ne: `src/kapi/divan_hukum_paneli.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Hüküm düğmesi düz. Tema bağlanınca yalnız `divan_hukum_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Hüküm düğmesi düz davranışı değişmez.
  - Kabul: `divan_hukum_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `divan_hukum_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/kapi/divan_hukum_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-53:** `divan_haksizlik_paneli.gd` temaya bağlanır.
  - Ne: `src/kapi/divan_haksizlik_paneli.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Haksızlık düğmesi düz. Tema bağlanınca yalnız `divan_haksizlik_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Haksızlık düğmesi düz davranışı değişmez.
  - Kabul: `divan_haksizlik_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `divan_haksizlik_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/kapi/divan_haksizlik_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-54:** `divan_kanit_karti.gd` temaya bağlanır.
  - Ne: `src/kapi/divan_kanit_karti.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Kanıt kartı düz düğme. Tema bağlanınca yalnız `divan_kanit_karti.gd` ARY-02 zeminini ve düğme durumunu okur, Kanıt kartı düz düğme davranışı değişmez.
  - Kabul: `divan_kanit_karti.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `divan_kanit_karti.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/kapi/divan_kanit_karti.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-55:** `ambar_kapisi_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/ambar_kapisi_paneli.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Ambar düğmesi düz. Tema bağlanınca yalnız `ambar_kapisi_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Ambar düğmesi düz davranışı değişmez.
  - Kabul: `ambar_kapisi_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `ambar_kapisi_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/ambar_kapisi_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-56:** `cati_kar_bilgisi.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/cati_kar_bilgisi.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Çatı satırı zeminsiz. Tema bağlanınca yalnız `cati_kar_bilgisi.gd` ARY-02 zeminini ve düğme durumunu okur, Çatı satırı zeminsiz davranışı değişmez.
  - Kabul: `cati_kar_bilgisi.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `cati_kar_bilgisi.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/cati_kar_bilgisi.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-57:** `cinar_meclis_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/cinar_meclis_paneli.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Meclis düğmesi düz. Tema bağlanınca yalnız `cinar_meclis_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Meclis düğmesi düz davranışı değişmez.
  - Kabul: `cinar_meclis_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `cinar_meclis_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/cinar_meclis_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-58:** `harita_baglantisi.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/harita_baglantisi.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Harita düğmesi düz. Tema bağlanınca yalnız `harita_baglantisi.gd` ARY-02 zeminini ve düğme durumunu okur, Harita düğmesi düz davranışı değişmez.
  - Kabul: `harita_baglantisi.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `harita_baglantisi.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/harita_baglantisi.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-59:** `hekim_ilac_bilgisi.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/hekim_ilac_bilgisi.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Hekim satırı zeminsiz. Tema bağlanınca yalnız `hekim_ilac_bilgisi.gd` ARY-02 zeminini ve düğme durumunu okur, Hekim satırı zeminsiz davranışı değişmez.
  - Kabul: `hekim_ilac_bilgisi.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `hekim_ilac_bilgisi.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/hekim_ilac_bilgisi.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-60:** `histeri_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/histeri_paneli.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Histeri düğmesi düz. Tema bağlanınca yalnız `histeri_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Histeri düğmesi düz davranışı değişmez.
  - Kabul: `histeri_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `histeri_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/histeri_paneli.gd`.
  - Asset: asset gerekmedi.


### 43.14 Köy şeridi — düğmeli

- [ ] **GRV-61:** `kaynak_gostergesi.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/kaynak_gostergesi.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Kaynak yazısı zeminsiz. Tema bağlanınca yalnız `kaynak_gostergesi.gd` ARY-02 zeminini ve düğme durumunu okur, Kaynak yazısı zeminsiz davranışı değişmez.
  - Kabul: `kaynak_gostergesi.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `kaynak_gostergesi.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/kaynak_gostergesi.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-62:** `kese_gostergesi.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/kese_gostergesi.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Kese yazısı zeminsiz. Tema bağlanınca yalnız `kese_gostergesi.gd` ARY-02 zeminini ve düğme durumunu okur, Kese yazısı zeminsiz davranışı değişmez.
  - Kabul: `kese_gostergesi.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `kese_gostergesi.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/kese_gostergesi.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-63:** `kundak_clue_bilgisi.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/kundak_clue_bilgisi.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Kundak satırı zeminsiz. Tema bağlanınca yalnız `kundak_clue_bilgisi.gd` ARY-02 zeminini ve düğme durumunu okur, Kundak satırı zeminsiz davranışı değişmez.
  - Kabul: `kundak_clue_bilgisi.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `kundak_clue_bilgisi.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/kundak_clue_bilgisi.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-64:** `kuyu_kirecleme_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/kuyu_kirecleme_paneli.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Kuyu düğmesi düz. Tema bağlanınca yalnız `kuyu_kirecleme_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Kuyu düğmesi düz davranışı değişmez.
  - Kabul: `kuyu_kirecleme_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `kuyu_kirecleme_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/kuyu_kirecleme_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-65:** `muhafiz_odasi_baglantisi.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/muhafiz_odasi_baglantisi.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Oda düğmesi düz. Tema bağlanınca yalnız `muhafiz_odasi_baglantisi.gd` ARY-02 zeminini ve düğme durumunu okur, Oda düğmesi düz davranışı değişmez.
  - Kabul: `muhafiz_odasi_baglantisi.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `muhafiz_odasi_baglantisi.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/muhafiz_odasi_baglantisi.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-66:** `pazar_satis_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/pazar_satis_paneli.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Pazar düğmesi düz. Tema bağlanınca yalnız `pazar_satis_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Pazar düğmesi düz davranışı değişmez.
  - Kabul: `pazar_satis_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `pazar_satis_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/pazar_satis_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-67:** `saman_bilgisi.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/saman_bilgisi.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Saman düğmesi düz. Tema bağlanınca yalnız `saman_bilgisi.gd` ARY-02 zeminini ve düğme durumunu okur, Saman düğmesi düz davranışı değişmez.
  - Kabul: `saman_bilgisi.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `saman_bilgisi.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/saman_bilgisi.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-68:** `siparis_sozlesme_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/siparis_sozlesme_paneli.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Sözleşme düğmesi düz. Tema bağlanınca yalnız `siparis_sozlesme_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Sözleşme düğmesi düz davranışı değişmez.
  - Kabul: `siparis_sozlesme_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `siparis_sozlesme_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/siparis_sozlesme_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-69:** `su_rezerv_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/su_rezerv_paneli.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Su düğmesi düz. Tema bağlanınca yalnız `su_rezerv_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Su düğmesi düz davranışı değişmez.
  - Kabul: `su_rezerv_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `su_rezerv_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/su_rezerv_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-70:** `yapi_karti.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/yapi_karti.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Yapı kartı zeminsiz. Tema bağlanınca yalnız `yapi_karti.gd` ARY-02 zeminini ve düğme durumunu okur, Yapı kartı zeminsiz davranışı değişmez.
  - Kabul: `yapi_karti.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `yapi_karti.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/yapi_karti.gd`.
  - Asset: asset gerekmedi.


### 43.15 Köy şeridi — yazı

- [ ] **GRV-71:** `alet_asinma_bilgisi.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/alet_asinma_bilgisi.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Aşınma satırı zeminsiz. Tema bağlanınca yalnız `alet_asinma_bilgisi.gd` ARY-02 zeminini ve düğme durumunu okur, Aşınma satırı zeminsiz davranışı değişmez.
  - Kabul: `alet_asinma_bilgisi.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `alet_asinma_bilgisi.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/alet_asinma_bilgisi.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-72:** `ceki_hayvani_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/ceki_hayvani_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Çeki hayvanı paneli zeminsiz. Tema bağlanınca yalnız `ceki_hayvani_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Çeki hayvanı paneli zeminsiz davranışı değişmez.
  - Kabul: `ceki_hayvani_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `ceki_hayvani_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/ceki_hayvani_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-73:** `celep_pazar_adaptoru.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/celep_pazar_adaptoru.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Celep adaptörü zeminsiz. Tema bağlanınca yalnız `celep_pazar_adaptoru.gd` ARY-02 zeminini ve düğme durumunu okur, Celep adaptörü zeminsiz davranışı değişmez.
  - Kabul: `celep_pazar_adaptoru.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `celep_pazar_adaptoru.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/celep_pazar_adaptoru.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-74:** `cenaze_raporu.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/cenaze_raporu.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Cenaze raporu zeminsiz. Tema bağlanınca yalnız `cenaze_raporu.gd` ARY-02 zeminini ve düğme durumunu okur, Cenaze raporu zeminsiz davranışı değişmez.
  - Kabul: `cenaze_raporu.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `cenaze_raporu.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/cenaze_raporu.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-75:** `cete_anlasma_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/cete_anlasma_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Çete paneli zeminsiz. Tema bağlanınca yalnız `cete_anlasma_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Çete paneli zeminsiz davranışı değişmez.
  - Kabul: `cete_anlasma_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `cete_anlasma_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/cete_anlasma_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-76:** `gezgin_stok_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/gezgin_stok_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Gezgin stok paneli zeminsiz. Tema bağlanınca yalnız `gezgin_stok_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Gezgin stok paneli zeminsiz davranışı değişmez.
  - Kabul: `gezgin_stok_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `gezgin_stok_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/gezgin_stok_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-77:** `gezgin_tuccar_pazar_adaptoru.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/gezgin_tuccar_pazar_adaptoru.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Gezgin tüccar adaptörü zeminsiz. Tema bağlanınca yalnız `gezgin_tuccar_pazar_adaptoru.gd` ARY-02 zeminini ve düğme durumunu okur, Gezgin tüccar adaptörü zeminsiz davranışı değişmez.
  - Kabul: `gezgin_tuccar_pazar_adaptoru.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `gezgin_tuccar_pazar_adaptoru.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/gezgin_tuccar_pazar_adaptoru.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-78:** `goc_yolu_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/goc_yolu_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Göç yolu paneli zeminsiz. Tema bağlanınca yalnız `goc_yolu_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Göç yolu paneli zeminsiz davranışı değişmez.
  - Kabul: `goc_yolu_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `goc_yolu_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/goc_yolu_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-79:** `hayvan_takas_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/hayvan_takas_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Hayvan takas paneli zeminsiz. Tema bağlanınca yalnız `hayvan_takas_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Hayvan takas paneli zeminsiz davranışı değişmez.
  - Kabul: `hayvan_takas_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `hayvan_takas_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/hayvan_takas_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-80:** `karantina_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/karantina_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Karantina paneli zeminsiz. Tema bağlanınca yalnız `karantina_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Karantina paneli zeminsiz davranışı değişmez.
  - Kabul: `karantina_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `karantina_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/karantina_paneli.gd`.
  - Asset: asset gerekmedi.


### 43.16 Köy şeridi — kalan paneller

- [ ] **GRV-81:** `kasa_transfer_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/kasa_transfer_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Kasa transferi zeminsiz. Tema bağlanınca yalnız `kasa_transfer_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Kasa transferi zeminsiz davranışı değişmez.
  - Kabul: `kasa_transfer_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `kasa_transfer_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/kasa_transfer_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-82:** `kervan_koruma_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/kervan_koruma_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Kervan koruma paneli zeminsiz. Tema bağlanınca yalnız `kervan_koruma_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Kervan koruma paneli zeminsiz davranışı değişmez.
  - Kabul: `kervan_koruma_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `kervan_koruma_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/kervan_koruma_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-83:** `konuslanma_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/konuslanma_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Konuşlanma paneli zeminsiz. Tema bağlanınca yalnız `konuslanma_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Konuşlanma paneli zeminsiz davranışı değişmez.
  - Kabul: `konuslanma_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `konuslanma_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/konuslanma_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-84:** `kumas_aktar_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/kumas_aktar_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Kumaş aktarım paneli zeminsiz. Tema bağlanınca yalnız `kumas_aktar_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Kumaş aktarım paneli zeminsiz davranışı değişmez.
  - Kabul: `kumas_aktar_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `kumas_aktar_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/kumas_aktar_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-85:** `mevsim_takvim.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/mevsim_takvim.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Mevsim takvimi zeminsiz. Tema bağlanınca yalnız `mevsim_takvim.gd` ARY-02 zeminini ve düğme durumunu okur, Mevsim takvimi zeminsiz davranışı değişmez.
  - Kabul: `mevsim_takvim.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `mevsim_takvim.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/mevsim_takvim.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-86:** `oba_ittifak_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/oba_ittifak_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Oba paneli zeminsiz. Tema bağlanınca yalnız `oba_ittifak_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Oba paneli zeminsiz davranışı değişmez.
  - Kabul: `oba_ittifak_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `oba_ittifak_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/oba_ittifak_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-87:** `pazar_kart_kaydirma.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/pazar_kart_kaydirma.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Pazar kaydırma zeminsiz. Tema bağlanınca yalnız `pazar_kart_kaydirma.gd` ARY-02 zeminini ve düğme durumunu okur, Pazar kaydırma zeminsiz davranışı değişmez.
  - Kabul: `pazar_kart_kaydirma.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `pazar_kart_kaydirma.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/pazar_kart_kaydirma.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-88:** `silah_karaborsa_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/silah_karaborsa_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Silah paneli zeminsiz. Tema bağlanınca yalnız `silah_karaborsa_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Silah paneli zeminsiz davranışı değişmez.
  - Kabul: `silah_karaborsa_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `silah_karaborsa_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/silah_karaborsa_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-89:** `siparis_ihlal_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/siparis_ihlal_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: İhlal paneli zeminsiz. Tema bağlanınca yalnız `siparis_ihlal_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, İhlal paneli zeminsiz davranışı değişmez.
  - Kabul: `siparis_ihlal_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `siparis_ihlal_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/siparis_ihlal_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-90:** `siparis_komisyon_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/siparis_komisyon_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Komisyon paneli zeminsiz. Tema bağlanınca yalnız `siparis_komisyon_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Komisyon paneli zeminsiz davranışı değişmez.
  - Kabul: `siparis_komisyon_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `siparis_komisyon_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/siparis_komisyon_paneli.gd`.
  - Asset: asset gerekmedi.


### 43.17 Tek renk ve bağlar

- [ ] **GRV-91:** `siparis_teslim_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/siparis_teslim_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Teslim paneli zeminsiz. Tema bağlanınca yalnız `siparis_teslim_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Teslim paneli zeminsiz davranışı değişmez.
  - Kabul: `siparis_teslim_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `siparis_teslim_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/siparis_teslim_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-92:** `ticaret_fiyat_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/ticaret_fiyat_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Fiyat paneli zeminsiz. Tema bağlanınca yalnız `ticaret_fiyat_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Fiyat paneli zeminsiz davranışı değişmez.
  - Kabul: `ticaret_fiyat_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `ticaret_fiyat_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/ticaret_fiyat_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-93:** `vergi_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/vergi_paneli.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Vergi paneli zeminsiz. Tema bağlanınca yalnız `vergi_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Vergi paneli zeminsiz davranışı değişmez.
  - Kabul: `vergi_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `vergi_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/vergi_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-94:** `gezgin_stok_ikonu.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/gezgin_stok_ikonu.gd` bugün ColorRect 1 ve 0 düz düğmeyle duruyor; notu: Tek ColorRect var, tema kaynağına bağlı değil. Tema bağlanınca yalnız `gezgin_stok_ikonu.gd` ARY-02 zeminini ve düğme durumunu okur, Tek ColorRect var, tema kaynağına bağlı değil davranışı değişmez.
  - Kabul: `gezgin_stok_ikonu.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `gezgin_stok_ikonu.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/gezgin_stok_ikonu.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-95:** `haberci_anlati_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/haberci_anlati_paneli.gd` bugün ColorRect 1 ve 0 düz düğmeyle duruyor; notu: Tek ColorRect, düz anlatı. Tema bağlanınca yalnız `haberci_anlati_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Tek ColorRect, düz anlatı davranışı değişmez.
  - Kabul: `haberci_anlati_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `haberci_anlati_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/haberci_anlati_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-96:** `kisisel_karaborsa_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/kisisel_karaborsa_paneli.gd` bugün ColorRect 1 ve 0 düz düğmeyle duruyor; notu: Tek ColorRect, tema dışı. Tema bağlanınca yalnız `kisisel_karaborsa_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Tek ColorRect, tema dışı davranışı değişmez.
  - Kabul: `kisisel_karaborsa_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `kisisel_karaborsa_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/kisisel_karaborsa_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-97:** `tekfur_heyeti_paneli.gd` temaya bağlanır.
  - Ne: `src/arayuz/koy_hud/tekfur_heyeti_paneli.gd` bugün ColorRect 1 ve 0 düz düğmeyle duruyor; notu: Tek ColorRect, tema dışı. Tema bağlanınca yalnız `tekfur_heyeti_paneli.gd` ARY-02 zeminini ve düğme durumunu okur, Tek ColorRect, tema dışı davranışı değişmez.
  - Kabul: `tekfur_heyeti_paneli.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `tekfur_heyeti_paneli.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koy_hud/tekfur_heyeti_paneli.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-98:** `koylu_surukleme_kulpu.gd` temaya bağlanır.
  - Ne: `src/arayuz/koylu_surukleme_kulpu.gd` bugün ColorRect 0 ve 0 düz düğmeyle duruyor; notu: Sürükleme kulpu zeminsiz. Tema bağlanınca yalnız `koylu_surukleme_kulpu.gd` ARY-02 zeminini ve düğme durumunu okur, Sürükleme kulpu zeminsiz davranışı değişmez.
  - Kabul: `koylu_surukleme_kulpu.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `koylu_surukleme_kulpu.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/koylu_surukleme_kulpu.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-99:** `divan_baglantisi.gd` temaya bağlanır.
  - Ne: `src/kapi/divan_baglantisi.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Divan açılış düğmesi düz. Tema bağlanınca yalnız `divan_baglantisi.gd` ARY-02 zeminini ve düğme durumunu okur, Divan açılış düğmesi düz davranışı değişmez.
  - Kabul: `divan_baglantisi.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `divan_baglantisi.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/kapi/divan_baglantisi.gd`.
  - Asset: asset gerekmedi.

- [ ] **GRV-100:** `chr_kapi_adaptoru.gd` temaya bağlanır.
  - Ne: `src/arayuz/chr_kapi_adaptoru.gd` bugün ColorRect 0 ve 1 düz düğmeyle duruyor; notu: Kapı adaptör düğmesi düz. Tema bağlanınca yalnız `chr_kapi_adaptoru.gd` ARY-02 zeminini ve düğme durumunu okur, Kapı adaptör düğmesi düz davranışı değişmez.
  - Kabul: `chr_kapi_adaptoru.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `chr_kapi_adaptoru.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/arayuz/chr_kapi_adaptoru.gd`.
  - Asset: asset gerekmedi.


### 43.18 Ekran

- [ ] **GRV-101:** `hastalik_teshis_adaptoru.gd` temaya bağlanır.
  - Ne: `src/kapi/hastalik_teshis_adaptoru.gd` bugün ColorRect 0 ve 2 düz düğmeyle duruyor; notu: Teşhis düğmeleri düz. Tema bağlanınca yalnız `hastalik_teshis_adaptoru.gd` ARY-02 zeminini ve düğme durumunu okur, Teşhis düğmeleri düz davranışı değişmez.
  - Kabul: `hastalik_teshis_adaptoru.gd` içinde ham `Color(` ve tema dışı ColorRect kalmaz. Test: GRV-22 yalnız `hastalik_teshis_adaptoru.gd` satırında 0 ihlal görür.
  - Bağımlılık: ARY-02, GRV-22. Boyut: S.
  - Dosya: `src/kapi/hastalik_teshis_adaptoru.gd`.
  - Asset: asset gerekmedi.


43.11–43.18 taramanın arka plansız veya düz düğmeli panelleridir. Mantık dosyaları (`fisilti_gazetesi.gd`, `divan_hukmu.gd`, `ipucu_yoneticisi.gd`) ekran değildir, satır açılmadı. Son kimlik GRV-101.
