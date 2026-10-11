# BÖLÜM 45 — Kontroller ve girdi

43'ten sonra, 46'dan önce. Zemin:

- `project.godot` içinde `[input]` bloğu yoktur. Eylemler `src/arayuz/ana.gd:237 _eylemleri_kur()` ile çalışma anında eklenir.
- Eylemler: `geri` = Esc ve gamepad B (`JOY_BUTTON_B`); `menu` = P ve Start (`JOY_BUTTON_START`); `kisayol_1`…`kisayol_5` = 1…5. Yorum: gezinme ve onay Godot'un `ui_*` eylemleridir.
- Köy ham tuş okur (`koy_ekrani.gd:312 _unhandled_input`): R yön çevirir, B barınma kategorisi, P nüfus, 1/2/3 hız (`_hiz_sec`), Space dur/sürdür, Esc kip temizler. Fare (`_dunya_girdisi`, satır 232): tekerlek yakınlaşır, sol seçer, sağ kipi kapatır.
- Orta tuş kamera BUG-24'tedir. Bu bölüm onu yeniden yazmaz.
- Tuş atama ekranı yoktur. Ayarlar `SATIRLAR` listesinde girdi satırı yoktur.

Kimlikler GIR-01 … GIR-26. Asset üretilmez. Bitince `[x]` ve ajan adı.

**Madde biçimi:** Ne, Kabul, Bağımlılık + Boyut, Dosya, Asset.

---

## 45.1 Eylem haritası

- [ ] **GIR-01:** Ayarlarda kontroller sekmesi.
  - Ne: `ayarlar_ekrani.gd` sekmelerinden biri kontrollerdir (GRV-25). Sekme eylemleri listeler, yeniden atamayı açar, varsayılana döner. Oynanış ayarı buraya gömülmez.
  - Kabul: sekme açıkken en az `geri`, `menu`, hız ve köy eylemleri satırdadır. Test: ekran.
  - Bağımlılık: GRV-25. Boyut: M.
  - Dosya: yeni: `src/arayuz/kontroller_sekmesi.gd`; `ayarlar_ekrani.gd` tek satır.
  - Asset: asset gerekmedi.
- [ ] **GIR-02:** Köy ham tuşu bırakır.
  - Ne: `KEY_R`, `KEY_B`, `KEY_P`, `KEY_1`, `KEY_2`, `KEY_3`, `KEY_SPACE`, `KEY_ESCAPE` karşılaştırması kalkar. Yerine `is_action_pressed`: `bina_cevir`, `bina_barinma`, `nufus`, `hiz_1`, `hiz_2`, `hiz_3`, `hiz_dur`, `kip_kapat`.
  - Kabul: `_unhandled_input` içinde `physical_keycode` 0. Test: tarama + hız 2 hâlâ 2.
  - Bağımlılık: GIR-01. Boyut: M.
  - Dosya: `koy_ekrani.gd`; eylemler `ana.gd _eylemleri_kur` ya da yeni `src/arayuz/girdi_eylemleri.gd`.
  - Asset: asset gerekmedi.
- [ ] **GIR-03:** Eylem adı ekranda çeviri anahtarıdır.
  - Ne: atama satırı `arayuz.girdi.<eylem>` ile yazılır, tuşun görünen adı `InputEvent.as_text()` değil, OS tuş adının kısa hali (Esc, Space, 1, P). Oyuncu "kisayol_1" görmez.
  - Kabul: sekmede ham eylem kimliği 0. Test: ekran + CSV.
  - Bağımlılık: GIR-01, YER-02. Boyut: S.
  - Dosya: `kontroller_sekmesi.gd`; `metinler.csv`.
  - Asset: asset gerekmedi.
- [ ] **GIR-04:** `[input]` proje dosyasına gömülmez.
  - Ne: bugünkü yol durur: eylemler kodda kurulur, atamalar `user://ayarlar.cfg` ek bölümünde saklanır. `project.godot` `[input]` bloğu açılmaz; iki kaynak olmasın.
  - Kabul: `project.godot` içinde `[input]` 0. Test: dosya.
  - Bağımlılık: GIR-02. Boyut: S.
  - Dosya: `girdi_eylemleri.gd`; `ayarlar.gd` ek bölüm (çekirdek anahtar listesi büyümez, bölüm adı `girdi`).
  - Asset: asset gerekmedi.

## 45.2 Çakışma

- [ ] **GIR-05:** P iki iş taşımaz.
  - Ne: `menu` eylemi P, köy `nufus` da P. Aynı fiziksel tuş iki eyleme atanamaz. Varsayılan: `menu` Esc yanına değil, ayrı bir tuşa (öneri F10) çekilir ya da yalnız duraklat açıkken dinlenir. Köyde P nüfus olarak kalır.
  - Kabul: köy ekranında P bir iş yapar (nüfus), duraklat açmaz. Test: köyde P.
  - Bağımlılık: GIR-02. Boyut: S.
  - Dosya: `girdi_eylemleri.gd`.
  - Asset: asset gerekmedi.
- [ ] **GIR-06:** Odak gezinmesi `ui_*` ile kalır, her ekranda komşu vardır.
  - Ne: `ui_up`, `ui_down`, `ui_left`, `ui_right`, `ui_accept`, `ui_cancel` Godot varsayılanıdır, yeniden tanımlanmaz. Menüdeki `_odak_komsulari` kalıbı ayarlar, defter ve duraklat düğmelerine de uygulanır. Fare olmadan sekme gezilir.
  - Kabul: ayarlar sekmesinde odak halkası düğme sayısına eşittir, kopuk düğme 0. Test: klavye.
  - Bağımlılık: GIR-01. Boyut: M.
  - Dosya: `ayarlar_ekrani.gd`, `hafiza_defteri_ekrani.gd`, `ana.gd` duraklat.
  - Asset: asset gerekmedi.
- [ ] **GIR-07:** 1–3 hız ile kapı kısayolu aynı anda dinlemez.
  - Ne: `kisayol_1…3` kapı sorgu ekranında, `hiz_1…3` köy ekranında. İkisi birden aynı karede işlenmez. Aynı tuşa atamak serbesttir çünkü ekranlar ayrıdır; atama ekranı bunu çakışma saymaz.
  - Kabul: köyde 1 hız seçer, kapı kısayolunu çalıştırmaz. Test: iki ekran.
  - Bağımlılık: GIR-02. Boyut: S.
  - Dosya: `girdi_eylemleri.gd`.
  - Asset: asset gerekmedi.
- [ ] **GIR-08:** Esc sırası tektir.
  - Ne: açık üst panel (heybe, kart, defter, kip) varsa Esc onu kapatır; yoksa `geri` duraklatır. `kip_kapat` ve `geri` aynı tuşta olabilir, tüketim sırası: üst panel, kip, duraklat.
  - Kabul: heybe açıkken Esc duraklat açmaz. Test: üç durum.
  - Bağımlılık: GIR-02. Boyut: S.
  - Dosya: `koy_ekrani.gd`, `kapi_ekrani.gd`.
  - Asset: asset gerekmedi.

## 45.3 Atama

- [ ] **GIR-09:** Bir eylem bir tuş bekler.
  - Ne: satıra basılınca sonraki tuş veya gamepad düğmesi o eyleme yazılır. Fare düğmesi kamera eylemine yazılır (tekerlek, sol, sağ); karar düğmesine yazılmaz.
  - Kabul: `hiz_1` R'ye alınınca 1 hız seçmez, R seçer. Test: atama.
  - Bağımlılık: GIR-01. Boyut: M.
  - Dosya: `kontroller_sekmesi.gd`.
  - Asset: asset gerekmedi.
- [ ] **GIR-10:** Çakışan atama uyarı verir, sessizce silmez.
  - Ne: aynı ekranda dinlenen iki eylem aynı tuşa gelirse satır "çakışıyor" der (`arayuz.girdi.cakisma`). Kayıt yazılır ama ikinci eylem o tuşu dinlemez.
  - Kabul: çakışmada işleyen eylem 1. Test: birim.
  - Bağımlılık: GIR-09. Boyut: S.
  - Dosya: `girdi_eylemleri.gd`.
  - Asset: asset gerekmedi.
- [ ] **GIR-11:** Varsayılan `ayarlar.varsayilana_don` girdiye de döner.
  - Ne: mevcut düğme (`ayarlar_ekrani.gd:68`) girdi bölümünü de sıfırlar. Ayrı "tuşları sıfırla" şart değildir; varsa aynı fonksiyonu çağırır.
  - Kabul: sıfırlama sonrası P nüfus, 1 hız. Test: atama + sıfır.
  - Bağımlılık: GIR-09. Boyut: S.
  - Dosya: `ayarlar.gd` `varsayilana_don`.
  - Asset: asset gerekmedi.

## 45.4 Gamepad

- [ ] **GIR-12:** Gamepad bugün iki eylemdir, liste bunu söyler.
  - Ne: varsayılan gamepad: `geri` B, `menu` Start. Hız, nüfus, çevir, kabul/ret için varsayılan düğme `data/girdi.json` içindedir (öneri: omuz hız, A kabul, X ret — sayılar dosyada). Kod içi düğme indeksi 0.
  - Kabul: json silinince oyun klavye varsayılanıyla açılır, çökmez. Test: dosyasız açılış.
  - Bağımlılık: GIR-04. Boyut: M.
  - Dosya: yeni: `data/girdi.json`.
  - Asset: asset gerekmedi.
- [ ] **GIR-13:** Sol çubuk köy imlecini kaydırır, yeni kamera yazmaz.
  - Ne: çubuk, fare hareketinin yerine `sahne3b.isaret` noktasına ofset ekler. Yakınlaşma tekerlek eylemi `yakinlas` ile kalır (BUG-24 orta tuş ayrı).
  - Kabul: çubuk sapması seçim hücresini değiştirir, `yakinlas` çağrı sayısı sapma ile artmaz. Test: girdi.
  - Bağımlılık: GIR-12. Boyut: M.
  - Dosya: `koy_ekrani.gd` tek dal.
  - Asset: asset gerekmedi.
- [ ] **GIR-14:** Gamepad yokken klavye tamdır.
  - Ne: düğme okunamazsa klavye yolu durur. Oyun gamepad aramaz, hata basmaz.
  - Kabul: gamepads boşken SCRIPT ERROR 0. Test: açılış.
  - Bağımlılık: GIR-12. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

## 45.5 Kapı kararları

- [ ] **GIR-15:** Kabul ve ret eylemdir.
  - Ne: kapı karar düğmeleri tıklanınca olduğu gibi kalır; ek olarak `kapi_kabul` ve `kapi_ret` eylemleri aynı fonksiyonu çağırır. Yeni karar türü yok (`KARAR_SIMGE` kümesi durur).
  - Kabul: klavye ile kabul, fare ile kabul aynı `sonuc` yolunu bir kez çağırır. Test: iki girdi.
  - Bağımlılık: GIR-02. Boyut: S.
  - Dosya: `kapi_ekrani.gd` tek bağ.
  - Asset: asset gerekmedi.
- [ ] **GIR-16:** `ui_accept` ile `kapi_kabul` çakışması GIR-10'dur.
  - Ne: Godot varsayılan Enter hem `ui_accept` hem kabul olmasın diye kabul eylemi Enter'dan başka varsayılan taşır (öneri Y). Enter odaklanan düğmeyi basar.
  - Kabul: odaklı ret düğmesinde Enter ret basar, kabul basmaz. Test: odak.
  - Bağımlılık: GIR-06, GIR-15. Boyut: S.
  - Dosya: `data/girdi.json`.
  - Asset: asset gerekmedi.

## 45.6 Fare

- [ ] **GIR-17:** Sol, sağ, tekerlek eylem kimliği alır, davranış değişmez.
  - Ne: `MOUSE_BUTTON_LEFT/RIGHT/WHEEL_*` karşılaştırması eylem olur: `sec`, `iptal_kip`, `yakinlas`, `uzaklas`. İşlev satır 236–248'dekiyle aynıdır.
  - Kabul: sol köylü kartını açar, tekerlek `yakinlas` işaretini korur. Test: köy.
  - Bağımlılık: GIR-02. Boyut: S.
  - Dosya: `koy_ekrani.gd`.
  - Asset: asset gerekmedi.
- [ ] **GIR-18:** Orta tuş BUG-24'te kalır.
  - Ne: kamera orta tuşu bu dosyada yeniden tanımlanmaz.
  - Kabul: bu bölümde orta tuş maddesi 1'dir ve o da budur (iş yok). Test: sayım.
  - Bağımlılık: BUG-24. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

## 45.7 Kayıt

- [ ] **GIR-19:** Atama ayar dosyasındadır, oyun kaydında değildir.
  - Ne: tuşlar `ayarlar.cfg` `girdi` bölümünde. `kayit.json` silinince atama durur. Eski ayar dosyasında bölüm yoksa varsayılan kurulur.
  - Kabul: kayıtsız açılışta atama hatırlanır; ayar dosyası yokken varsayılan. Test: iki dosya.
  - Bağımlılık: GIR-04. Boyut: S.
  - Dosya: `ayarlar.gd`.
  - Asset: asset gerekmedi.
- [ ] **GIR-20:** Bozuk atama satırı düşer.
  - Ne: bilinmeyen eylem veya boş olay `_gecerli` gibi yutulur, o eylem varsayılana döner, oyun açılır (`ayarlar.gd:48` kalıbı).
  - Kabul: `hiz_1=` boş satırında hız tuşu 1'dir, çökme 0. Test: birim.
  - Bağımlılık: GIR-19. Boyut: S.
  - Dosya: `girdi_eylemleri.gd`.
  - Asset: asset gerekmedi.

## 45.8 Metin ve öğretici

- [ ] **GIR-21:** İpucu tuş adı eylemden gelir.
  - Ne: OGR ipuçları "1'e bas" diye gömülü yazmaz. `arayuz.girdi.hiz_1` görünen adı yer tutucuya girer. Oyuncu tuşu değiştirince ipucu yeni adı söyler.
  - Kabul: `hiz_1` R iken ipucu metninde R geçer, "1" geçmez. Test: atama + ipucu.
  - Bağımlılık: GIR-03, OGR-09. Boyut: S.
  - Dosya: `ipucu_seridi.gd`.
  - Asset: asset gerekmedi.
- [ ] **GIR-22:** Kontroller sekmesi USLUP dışıdır.
  - Ne: tuş adları tekniktir; YAZ-10 diyalog taramasına girmez.
  - Kabul: `arayuz.girdi.*` yapaylık listesinde 0. Test: KLT kapısı.
  - Bağımlılık: KLT-04. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

## 45.9 Sürüm

- [ ] **GIR-23:** Oyuncu sürümünde atama ekranı durur.
  - Ne: SRM-05 debug'ı kapatır, kontroller sekmesini kapatmaz.
  - Kabul: bayraksız export'ta sekme 1. Test: SRM-05 açılışı.
  - Bağımlılık: SRM-05. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **GIR-24:** Gamepad glyph çizilmez.
  - Ne: düğme ikonu üretilmez. Metin "A", "B", "Start" yeter. İhtiyaç doğarsa ARY-05, bu madde dosya koymaz.
  - Kabul: yeni png 0. Test: sayım.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

## 45.10 Sınırlar ve kapanış

- [ ] **GIR-25:** Hız formülü değişmez.
  - Ne: `_hiz_sec` 0…3, kilitliyken 1, `time_scale` kuralı TEK-22/23'tedir. Bu bölüm yalnız tuşu değiştirir.
  - Kabul: `_hiz_sec` gövdesi diff'i yorum ve eylem bağı dışında 0. Test: hız birimi.
  - Bağımlılık: TEK-23. Boyut: S.
  - Dosya: `koy_ekrani.gd`.
  - Asset: asset gerekmedi.
- [ ] **GIR-26:** Kapanış testi.
  - Ne: varsayılanda köy 1/2/3 hız, P nüfus, Space durur; P duraklat açmaz; heybe açıkken Esc duraklat açmaz; atama kaydı oyun kaydından bağımsız; `[input]` yok.
  - Kabul: beş iddia. Test: `tests/unit/arayuz/girdi_test.gd`.
  - Bağımlılık: GIR-01…25. Boyut: M.
  - Dosya: yeni test.
  - Asset: asset gerekmedi.

Alt başlıklarda madde sayısı iki ile dört arasındadır. Onuncu madde, her HUD paneline ayrı kısayol uyduracağı için konmadı. Toplam 26 madde.
