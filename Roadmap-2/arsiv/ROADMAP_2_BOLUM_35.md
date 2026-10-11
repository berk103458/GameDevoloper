# BÖLÜM 35 — Ayarlar, erişilebilirlik ve okuma konforu

Faz 1 (Bölüm 33 ile birlikte; görsel kabuğu Bölüm 43 / ARY-02 tema altyapısından alır). Zemin, kodda duran ayar deposu ve ekranıdır:

- `src/sistemler/ayarlar.gd` — `VARSAYILAN`: `ses_ana 8`, `ses_muzik 7`, `ses_efekt 8`, `ekran_modu tam_ekran|pencere`, `metin_olcegi 100|125|150`, `belirme_hizi normal|hizli|aninda` (`CARPAN` 1.0/0.5/0.0), `grafik_profili normal|dusuk`, `cozunurluk_3d 50…100`. Fonksiyonlar `yukle`, `yaz`, `al`, `ayarla`, `varsayilana_don`, `belirme_ms`, `boyut`, `uygula`; sinyal `degisti`; dosya `user://ayarlar.cfg`.
- `src/arayuz/ayarlar_ekrani.gd` — `SATIRLAR` altı satır (üç ses, ekran modu, metin ölçeği, belirme hızı); zemin tek `ColorRect` `Renkler.GECE` (satır 21–24); `_degistir(a, yon)` sol/sağ oklarla değer değiştirir. `src/arayuz/grafik_ayarlari_paneli.gd` iki `OptionButton`.
- `src/arayuz/tema.gd` — `GOVDE_PX 26`, `KUCUK_PX 22`, `BASLIK_PX 34`; `boyut()` metin ölçeğini uygular. Font Alegreya değişken (`assets/font/`).
- Kayıt: `src/sistemler/kayit_deposu.gd` tek dosya `user://kayit.json` (`var_mi`, `yaz`, `oku`, `sil`); `oturum.gd KAYIT_SURUMU 3`; atomik yazım `atomik_json_kaydi.gd` (SYS-02); göç `kayit_gocu.gd` (SYS-01/14). Kayıt yuvası ve hızlı kayıt yoktur; Bölüm 31 onları buraya bıraktı (`BOLUM_31.md:5`).
- Zorluk çarpanı DEN-04'tedir; menüsü DEN-72 ile buraya ve 43'e bırakıldı.
- Kodda `ekran_modu` dışında pencere boyutu, vsync, kare sınırı, renk körlüğü paleti, tuş atama (Bölüm 45) ve dil seçimi (Bölüm 46) yoktur (`rg -i 'vsync|max_fps|daltonizm|renk_koru' src` → 0 [doğrulanamadı: yalnız bu dört terim tarandı]).

Bu bölüm ayar deposunu yeniden kurmaz; `ayarlar.gd` çekirdek sayılır, yeni anahtarlar ayrı dosyadan (`ayarlar_ek.gd`) `Ayarlar.degerler` sözlüğüne kaydolur. Ses ve seslendirme kapsam dışıdır; ses alt başlığı yalnız var olan üç bus için erişilebilirlik satırı taşır.

Kimlikler AYR-01 … AYR-52. Asset üretilmez; görsel ihtiyaç ARY-05'e yazılır. Bitince `[x]` ve ajan adı.

**Madde biçimi:** Ne, Kabul, Bağımlılık + Boyut, Dosya, Asset.

---

## 35.1 Ayarlar ekranının yapısı

- [ ] **AYR-01:** Ayarlar beş sekmedir.
  - Ne: Oyun, Görüntü, Okuma, Ses, Kontroller (45) ve Dil (46) için sekmeler; bugünkü tek düz liste yerine. Her sekme kendi dosyasıdır; `ayarlar_ekrani.gd` yalnız sekme kabuğunu çağırır.
  - Kabul: `ayarlar_ekrani.gd` içinde `SATIRLAR` kalır (geri uyum), sekmeler yeni dosyadan yüklenir. Test: sekme sayısı 6, her sekme bir `.gd`.
  - Bağımlılık: ARY-02. Boyut: M.
  - Dosya: yeni: `src/arayuz/ayarlar/ayar_sekmeleri.gd`, `oyun_sekmesi.gd`, `goruntu_sekmesi.gd`, `okuma_sekmesi.gd`, `ses_sekmesi.gd`; `ayarlar_ekrani.gd` tek satır.
  - Asset: asset gerekmedi.
- [ ] **AYR-02:** Ek anahtarlar ayrı dosyadan kaydolur.
  - Ne: bu bölümün yeni anahtarları (`VARSAYILAN` ve `GECERLI` listeleri) `ayarlar_ek.gd` içinde durur ve açılışta `Ayarlar.degerler`'e birleştirilir; `ayarlar.gd` değişmez.
  - Kabul: `ayarlar.gd` diff 0; `ayarlar.al(&"yeni_anahtar")` çalışır. Test: birim.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: yeni: `src/sistemler/ayarlar_ek.gd`; `ana.gd` tek satır.
  - Asset: asset gerekmedi.
- [ ] **AYR-03:** Her satırın açıklaması vardır.
  - Ne: seçili satırın altında tek satırlık açıklama (`arayuz.ayarlar.<anahtar>_aciklama`); ne yaptığı ve varsayılanı yazar.
  - Kabul: her anahtar için açıklama anahtarı var; `metin_dogrula.py` eksik açıklamayı hata sayar. Test: tarama.
  - Bağımlılık: AYR-01. Boyut: S.
  - Dosya: `data/metin/metinler.csv`; `tools/metin_dogrula.py` tek kural.
  - Asset: asset gerekmedi.
- [ ] **AYR-04:** Ayar anında uygulanır, kapanınca yazılır.
  - Ne: mevcut davranış (`ayarlar_ekrani.gd` başlık yorumu) korunur ve yeni sekmelere de uygulanır; "Uygula" düğmesi yoktur.
  - Kabul: değer değişince `degisti` sinyali; `yaz()` yalnız `_kapat()`'ta. Test: birim.
  - Bağımlılık: AYR-01. Boyut: S.
  - Dosya: `src/arayuz/ayarlar/ayar_sekmeleri.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-05:** Varsayılana dön sekme başınadır.
  - Ne: `varsayilana_don()` bütün ayarları sıfırlar; sekme başına "bu sekmeyi sıfırla" eklenir, onay ister.
  - Kabul: Okuma sekmesi sıfırlanınca ses değerleri aynı kalır. Test: birim.
  - Bağımlılık: AYR-02. Boyut: S.
  - Dosya: `src/sistemler/ayarlar_ek.gd` `sekme_sifirla(sekme)`.
  - Asset: asset gerekmedi.
- [ ] **AYR-06:** Ayarlar oyun içinden ve menüden aynı ekrandır.
  - Ne: Esc menüsü (`menu` eylemi) ve ana menü (`menu_ekrani.gd arayuz.menu.ayarlar`) aynı `AyarlarEkrani` örneğini açar; köy hızı açılışta saklanır, kapanışta geri gelir (`harita_baglantisi.gd:17` kalıbı).
  - Kabul: oyun içinde açılıp kapanınca `Engine.time_scale` eşit. Test: birim.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: yeni: `src/arayuz/koy_hud/ayarlar_baglantisi.gd`.
  - Asset: asset gerekmedi.

## 35.2 Okuma konforu

- [ ] **AYR-07:** Metin ölçeğine 175 eklenir.
  - Ne: `GECERLI.metin_olcegi` 100/125/150'ye 175 eklenir (ayrı dosyadan). Tüm paneller `ayarlar.boyut()` kullandığı sürece taşma `yapi_karti.gd:59` kalıbıyla kaydırmaya düşer.
  - Kabul: 175'te hiçbir metin kesilmez; TST-10 arayüz tarayıcısı üç çözünürlükte 0 taşma. Test: tarayıcı.
  - Bağımlılık: AYR-02, TST-10. Boyut: M.
  - Dosya: `src/sistemler/ayarlar_ek.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-08:** Satır aralığı ayarı.
  - Ne: `satir_araligi` anahtarı (normal/geniş); `RichTextLabel` `line_separation` tema sabitine yazılır.
  - Kabul: geniş modda satır aralığı +6 px (öneri). Test: ekran.
  - Bağımlılık: AYR-02, ARY-02. Boyut: S.
  - Dosya: `src/sistemler/ayarlar_ek.gd`; tema kaynağına tek satır.
  - Asset: asset gerekmedi.
- [ ] **AYR-09:** Belirme hızı Söz motoruna bağlanır.
  - Ne: `belirme_ms()` yeni Söz motorunun (DIY-03) satır belirmesinde tek kaynaktır; `aninda` seçildiğinde satır tam gelir, zar animasyonu (ZAR-01) da kısalır.
  - Kabul: `aninda`'da satır gecikmesi 0 ms, zar animasyonu ≤ 200 ms. Test: zamanlayıcı.
  - Bağımlılık: DIY-03, ZAR-01. Boyut: S.
  - Dosya: Söz motoru görünümüne tek satır.
  - Asset: asset gerekmedi.
- [ ] **AYR-10:** Okunmuş satır işareti.
  - Ne: Söz motorunda daha önce görülmüş seçenek soluk renkle işaretlenir (kişi hafızası DIY-11 ile aynı kayıt). Anahtar `okunmus_isaret` açık/kapalı.
  - Kabul: ikinci ziyarette aynı seçenek soluk. Test: iki ziyaret.
  - Bağımlılık: DIY-11. Boyut: S.
  - Dosya: Söz motoru görünümüne tek satır; `ayarlar_ek.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-11:** Konuşma geçmişi kaydırılabilir.
  - Ne: sorgu sırasında önceki satırlar yukarı kaydırılarak okunur (beyan defteri DIY-07'den ayrı, yalnız bu ziyaretin akışı). Fare tekeri ve gamepad sağ çubuk.
  - Kabul: 20 satırlık sorguda ilk satıra dönülür. Test: ekran.
  - Bağımlılık: DIY-03. Boyut: S.
  - Dosya: yeni: `src/arayuz/kapi/konusma_gecmisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-12:** İpuçları ve deneyimli oyuncu anahtarı.
  - Ne: Oyun sekmesinde `ipuclari` (açık/kapalı) ve `kademeli_hud` (açık/kapalı); "ipuçlarını sıfırla" düğmesi `ogretici.gorulen`'i temizler. Bölüm 33 bunları okur.
  - Kabul: kapalıyken ipucu 0; sıfırla sonrası yeni oyunda ipucu tekrar gelir. Test: iki koşu.
  - Bağımlılık: OGR-07, OGR-29. Boyut: S.
  - Dosya: `src/sistemler/ayarlar_ek.gd`; `src/arayuz/ayarlar/oyun_sekmesi.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-13:** Font ağırlığı seçimi.
  - Ne: Alegreya değişken font `wght` ekseni kullanılır (`tema.font(agirlik)`); `metin_agirligi` normal (400) / kalın (500). Yeni font dosyası yok.
  - Kabul: kalın seçilince gövde 500. Test: tema sorgusu.
  - Bağımlılık: AYR-02. Boyut: S.
  - Dosya: `src/sistemler/ayarlar_ek.gd`; tema kaynağına tek satır.
  - Asset: asset gerekmedi.

## 35.3 Görsel erişilebilirlik

- [ ] **AYR-14:** Renk körlüğü paleti.
  - Ne: `renk_paleti` anahtarı: olağan / deuteranopi / protanopi / tritanopi. Dört bar, tansiyon göstergesi, kaynak göstergesi ve zar rengini etkileyen palet ARY-02 tema kaynağının ikinci tablosudur; `renkler.gd` değişmez.
  - Kabul: palet değişince `Renkler` sabitleri yerine tema kaynağı okunur; dört palette bar renkleri çift çift ayrışır (ΔE ≥ 20, öneri). Test: ekran + sayı.
  - Bağımlılık: ARY-02. Boyut: M.
  - Dosya: yeni: `src/arayuz/tema/palet.gd`; yeni: `data/arayuz/paletler.json`.
  - Asset: asset gerekmedi.
- [ ] **AYR-15:** Renk tek bilgi taşıyıcı değildir.
  - Ne: bar, tansiyon ve kaynak durumu renkle birlikte bir biçim ya da harf taşır (bar adının ilk harfi, tansiyonda üç kademe çizgi). Palet seçiminden bağımsız açıktır.
  - Kabul: `tansiyon_gostergesi.gd` üç kademede üç farklı çizgi sayısı; `barlar.gd` görünümünde harf. Test: ekran.
  - Bağımlılık: AYR-14. Boyut: S.
  - Dosya: yeni: `src/arayuz/kapi/tansiyon_bicimi.gd`; bar görünümüne tek satır.
  - Asset: asset gerekmedi.
- [ ] **AYR-16:** Yüksek kontrast modu.
  - Ne: `yuksek_kontrast` anahtarı: panel dolgusu tam opak, kenar kalınlığı +1, metin rengi tam `KUL` yerine beyaz. Tema kaynağı ikinci değer kümesi.
  - Kabul: açıkken metin/zemin kontrast oranı ≥ 7:1 (WCAG AAA, öneri). Test: renk ölçümü.
  - Bağımlılık: ARY-02. Boyut: S.
  - Dosya: `src/arayuz/tema/palet.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-17:** Zar sonucu rakamla da yazılır.
  - Ne: görünür zar (ZAR-01) sonucunu yalnız yüzle değil rakamla ve "geçti/kaldı" sözüyle gösterir; `belirme_hizi aninda` ile uyumlu.
  - Kabul: zar panelinde rakam ve söz 1. Test: ekran.
  - Bağımlılık: ZAR-01. Boyut: S.
  - Dosya: zar görünümüne tek satır.
  - Asset: asset gerekmedi.
- [ ] **AYR-18:** Hareket azaltma.
  - Ne: `hareket_azalt` anahtarı: 12 fps adımlı hareket (`adim.gd`) korunur, ancak ekran sarsıntısı, kamera geçişi (`kapi_kamera_gecisi.gd`) ve panel kayma animasyonları anında olur.
  - Kabul: açıkken `kapi_kamera_gecisi` süresi 0. Test: zamanlayıcı.
  - Bağımlılık: AYR-02. Boyut: S.
  - Dosya: `src/sistemler/ayarlar_ek.gd`; kamera geçişine tek satır.
  - Asset: asset gerekmedi.
- [ ] **AYR-19:** İmleç ve odak çerçevesi büyütme.
  - Ne: `odak_cercevesi` normal/kalın; klavye ve gamepad odağı (`ui_*` eylemleri) kalın modda 3 px kenar.
  - Kabul: odaklı düğme kenarı 3 px. Test: ekran.
  - Bağımlılık: ARY-02, GIR-06. Boyut: S.
  - Dosya: `src/arayuz/tema/palet.gd`.
  - Asset: asset gerekmedi.

## 35.4 Ses ayarları (yalnız var olan üç bus)

- [ ] **AYR-20:** Ses sekmesi üç kaydırıcıdır.
  - Ne: `ses_ana`, `ses_muzik`, `ses_efekt` (`BUSLAR`) 0–10 kaydırıcı olarak taşınır; ok tuşlarıyla da değişir. Yeni bus yok.
  - Kabul: üç kaydırıcı; `AudioServer` bus adları `BUSLAR` ile aynı. Test: birim.
  - Bağımlılık: AYR-01. Boyut: S.
  - Dosya: `src/arayuz/ayarlar/ses_sekmesi.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-21:** Sessizde görsel karşılık.
  - Ne: `ses_ana` 0 iken tansiyon müziği (`tansiyon_muzigi.gd`) kademe geçişi tansiyon göstergesinde bir yanıp sönmeyle duyurulur; başka görsel ses karşılığı yok.
  - Kabul: ses 0 ve kademe geçişi → gösterge 1 yanıp sönme. Test: ekran.
  - Bağımlılık: AYR-15. Boyut: S.
  - Dosya: `src/arayuz/kapi/tansiyon_bicimi.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-22:** Odak kaybında ses kısılır.
  - Ne: pencere odak kaybedince `ses_ana` geçici 0; dönüşte eski değer. Anahtar `arka_planda_sustur`.
  - Kabul: `NOTIFICATION_APPLICATION_FOCUS_OUT` sonrası Master -80 dB; dönüşte eski. Test: birim.
  - Bağımlılık: AYR-02. Boyut: S.
  - Dosya: yeni: `src/sistemler/odak_sesi.gd`.
  - Asset: asset gerekmedi.

## 35.5 Oyun ayarları

- [ ] **AYR-23:** Zorluk seçimi.
  - Ne: DEN-04 çarpanı (kolay/olağan/sıkı) Oyun sekmesinde ve yeni oyun ekranında; oyun içinde değiştirilebilir, değişim Bölüm 39 defterine yazılır. DEN-72 bu maddeyle kapanır.
  - Kabul: değer `denge.json zorluk` anahtarlarından biri; kayıtta tutulur. Test: birim.
  - Bağımlılık: DEN-04, OGR-50. Boyut: S.
  - Dosya: `src/arayuz/ayarlar/oyun_sekmesi.gd`; kayıt alanı `zorluk`.
  - Asset: asset gerekmedi.
- [ ] **AYR-24:** Köy hızı varsayılanı.
  - Ne: `koy_hizi_varsayilan` 1/2/3: köy ekranı açılınca `_hiz_sec` bu değeri alır.
  - Kabul: ayar 2 ise açılışta `Engine.time_scale` 2. Test: birim.
  - Bağımlılık: AYR-02. Boyut: S.
  - Dosya: `src/sistemler/ayarlar_ek.gd`; `koy_ekrani.gd` tek satır.
  - Asset: asset gerekmedi.
- [ ] **AYR-25:** Olayda otomatik duraklat.
  - Ne: `olayda_duraklat` açıkken köy olayı (`OlayVerisi`) açılınca hız 0'a iner; kapanınca eski hız.
  - Kabul: olay paneli açılınca `paused` true. Test: birim.
  - Bağımlılık: AYR-02. Boyut: S.
  - Dosya: olay paneline tek satır.
  - Asset: asset gerekmedi.
- [ ] **AYR-26:** Gece raporu otomatik kapanmaz.
  - Ne: `rapor_bekle` açıkken gece raporu oyuncu kapatana kadar durur (varsayılan açık).
  - Kabul: açıkken rapor zamanlayıcısı 0. Test: birim.
  - Bağımlılık: AYR-02. Boyut: S.
  - Dosya: rapor panelinde tek satır.
  - Asset: asset gerekmedi.
- [ ] **AYR-27:** Karar onayı.
  - Ne: `karar_onayi` açıkken kabul/ret düğmesi ikinci tıklama ister (yanlış tıklamaya karşı). Varsayılan kapalı.
  - Kabul: açıkken tek tıkla karar 0. Test: birim.
  - Bağımlılık: AYR-02. Boyut: S.
  - Dosya: `kapi_ekrani.gd` karar düğmesine tek satır.
  - Asset: asset gerekmedi.

## 35.6 Kayıt: yuva, hızlı kayıt, otomatik kayıt

- [ ] **AYR-28:** Üç kayıt yuvası.
  - Ne: `kayit_deposu.gd` tek dosya kalır; üstüne `kayit_yuvalari.gd` üç yol verir (`user://kayit_1.json` … `_3`). Eski `user://kayit.json` ilk yuvaya göç eder (KAY zinciri).
  - Kabul: üç yuva; eski dosya varsa yuva 1'de görünür, silinmez. Test: göç birimi.
  - Bağımlılık: KAY-04, SYS-01. Boyut: M.
  - Dosya: yeni: `src/sistemler/kayit_yuvalari.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-29:** Yuva kartı.
  - Ne: her yuvada gün, nüfus, perde, son kayıt saati ve muhafızın geçmişi (ACL-06) yazar; ekran görüntüsü yok.
  - Kabul: beş alan kayıt başlığından okunur; bozuk kayıt "okunamadı" yazar, çökmez. Test: bozuk dosya.
  - Bağımlılık: AYR-28. Boyut: S.
  - Dosya: yeni: `src/arayuz/kayit_yuva_karti.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-30:** Hızlı kayıt yalnız köyde.
  - Ne: `hizli_kayit` eylemi (Bölüm 45, varsayılan F5) köy ekranında kayıt yazar; sorgu sırasında kapalıdır (KAY-30 ile uyumlu). Yazım atomiktir (SYS-02).
  - Kabul: sorgu ortasında eylem 0 etki; köyde dosya saati değişir. Test: birim.
  - Bağımlılık: KAY-30, GIR-03. Boyut: S.
  - Dosya: yeni: `src/sistemler/hizli_kayit.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-31:** Otomatik kayıt ayarı.
  - Ne: gece sonu kaydı (mevcut) korunur; `otomatik_kayit` anahtarı her gece / üç gecede bir / kapalı. Kapalıyken yalnız elle kayıt.
  - Kabul: üç gecede bir seçiliyken dosya saati üç gecede değişir. Test: birim.
  - Bağımlılık: AYR-02. Boyut: S.
  - Dosya: `src/sistemler/ayarlar_ek.gd`; gece sonu kayıt çağrısına tek satır.
  - Asset: asset gerekmedi.
- [ ] **AYR-32:** Silme iki adımdır.
  - Ne: yuva silme onay ister; silinen dosya `user://cop/` altına taşınır, bir sonraki açılışta temizlenir.
  - Kabul: silme sonrası `cop/` içinde dosya 1; ikinci açılışta 0. Test: birim.
  - Bağımlılık: AYR-28. Boyut: S.
  - Dosya: `src/sistemler/kayit_yuvalari.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-33:** Uyumsuz kayıt açılmaz, açıklanır.
  - Ne: `KAYIT_SURUMU` ileri olan dosya yuva kartında "yeni sürüm kaydı" yazar; açılmaz, silinmez.
  - Kabul: sürüm 99 dosyası → kart uyarısı, çökme 0. Test: birim.
  - Bağımlılık: AYR-29, KAY-04. Boyut: S.
  - Dosya: `src/arayuz/kayit_yuva_karti.gd`.
  - Asset: asset gerekmedi.

## 35.7 Yeni oyun ekranı

- [ ] **AYR-34:** Yeni oyun tek ekrandır.
  - Ne: `arayuz.menu.yeni` → tek ekran: muhafızın geçmişi (ACL-06), zorluk (AYR-23, ilk oyunda gizli OGR-50), yuva seçimi (AYR-28). Başka seçenek yok.
  - Kabul: ekranda üç alan; ilk oyunda iki. Test: ekran.
  - Bağımlılık: ACL-06, AYR-23, AYR-28. Boyut: S.
  - Dosya: yeni: `src/arayuz/yeni_oyun_ekrani.gd`; `menu_ekrani.gd` tek satır.
  - Asset: asset gerekmedi.
- [ ] **AYR-35:** Tohum gösterilir, girilir.
  - Ne: oyun tohumu ekranda okunur ve isteğe bağlı girilir (TST-06 ikizi için). Varsayılan rastgele.
  - Kabul: aynı tohumla iki oyun ilk altı gece aynı kuyruğu üretir. Test: ikiz.
  - Bağımlılık: TST-06. Boyut: S.
  - Dosya: `src/arayuz/yeni_oyun_ekrani.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-36:** Dolu yuvaya yazma onayı.
  - Ne: seçilen yuva doluysa üzerine yazma onayı; onaysız geri döner.
  - Kabul: dolu yuvada tek tıkla başlangıç 0. Test: birim.
  - Bağımlılık: AYR-28. Boyut: S.
  - Dosya: `src/arayuz/yeni_oyun_ekrani.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-37:** Önceki oyunların izi.
  - Ne: `oyuncu_izi.cfg` (OGR-47) alınan sonları ve oyun sayısını tek satırla gösterir (OMR-47).
  - Kabul: satır var/yok iz dosyasına göre. Test: iki durum.
  - Bağımlılık: OMR-47. Boyut: S.
  - Dosya: `src/arayuz/yeni_oyun_ekrani.gd`.
  - Asset: asset gerekmedi.

## 35.8 Görüntü ve performans ayarları

- [ ] **AYR-38:** Pencere boyutu seçimi.
  - Ne: `ekran_modu pencere` iken 1280×720 / 1600×900 / 1920×1080 seçimi (`project.godot` override 1600×900). Stretch `canvas_items/expand` korunur.
  - Kabul: seçim `DisplayServer.window_set_size`; tam ekranda seçici pasif. Test: birim.
  - Bağımlılık: AYR-02. Boyut: S.
  - Dosya: `src/arayuz/ayarlar/goruntu_sekmesi.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-39:** Dikey eşitleme ve kare sınırı.
  - Ne: `vsync` açık/kapalı (`DisplayServer.window_set_vsync_mode`), `kare_siniri` 30/60/kapalı (`Engine.max_fps`).
  - Kabul: değer anında uygulanır; `performans_seridi.gd` okur. Test: birim.
  - Bağımlılık: AYR-02. Boyut: S.
  - Dosya: `src/arayuz/ayarlar/goruntu_sekmesi.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-40:** Grafik profili ve 3B çözünürlük buraya taşınır.
  - Ne: `grafik_ayarlari_paneli.gd` iki seçicisi Görüntü sekmesine girer; panel dosyası ince adaptör kalır.
  - Kabul: aynı anahtarlar, aynı etkiler (`grafik_profili_adaptoru.gd`). Test: birim.
  - Bağımlılık: AYR-01. Boyut: S.
  - Dosya: `src/arayuz/ayarlar/goruntu_sekmesi.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-41:** Düşük profil otomatik önerisi.
  - Ne: `performans_seridi` üç gece ortalaması 30 fps altında kalırsa bir kez "düşük profil?" satırı; otomatik değiştirmez.
  - Kabul: öneri bir kez; `grafik_profili` kendi kendine değişmez. Test: birim.
  - Bağımlılık: TEK-10. Boyut: S.
  - Dosya: yeni: `src/sistemler/profil_onerisi.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-42:** Arayüz ölçeği 3B'den ayrı.
  - Ne: `cozunurluk_3d` 3B sahneyi küçültürken arayüz (`canvas_items`) tam çözünürlükte kalır; madde bunu test eder.
  - Kabul: `cozunurluk_3d 50` iken metin keskinliği değişmez. Test: ekran.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `tests/oto/` ekran kontrolü.
  - Asset: asset gerekmedi.

## 35.9 Kalıcılık, göç ve denetim

- [ ] **AYR-43:** Ayar dosyası sürümlüdür.
  - Ne: `ayarlar.cfg` içine `surum` anahtarı; bilinmeyen anahtar atılmaz, saklanır (ileri sürüm uyumu).
  - Kabul: ileri sürüm dosyası açılır, bilinmeyen anahtar korunur. Test: birim.
  - Bağımlılık: AYR-02. Boyut: S.
  - Dosya: `src/sistemler/ayarlar_ek.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-44:** Geçersiz değer varsayılana düşer, loglanır.
  - Ne: `_gecerli` reddettiği değer için tek satır log; oyun çökmez.
  - Kabul: bozuk cfg ile açılış, log 1. Test: birim.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `src/sistemler/ayarlar_ek.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-45:** Ayarlar kayıt dosyasına girmez.
  - Ne: zorluk (AYR-23) dışında hiçbir ayar oyun kaydında durmaz; kayıt taşınınca ayarlar makineye aittir.
  - Kabul: kayıt JSON'unda ayar anahtarı 0 (zorluk hariç). Test: tarama.
  - Bağımlılık: AYR-23. Boyut: S.
  - Dosya: `tests/unit/` kayıt tarama.
  - Asset: asset gerekmedi.
- [ ] **AYR-46:** Komut satırından ayar.
  - Ne: `--ayar anahtar=deger` argümanı (tester için); yalnız o oturumda geçerli, dosyaya yazılmaz.
  - Kabul: argümanla açılış değeri uygular, `yaz()` sonrası dosya değişmez. Test: birim.
  - Bağımlılık: AYR-02. Boyut: S.
  - Dosya: `src/sistemler/ayarlar_ek.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-47:** Ayar değişimi tester günlüğüne düşer.
  - Ne: TST-03 kancasına `AYAR` satırı: hangi anahtar ne oldu.
  - Kabul: değişim başına bir satır. Test: birim.
  - Bağımlılık: TST-03. Boyut: S.
  - Dosya: `src/sistemler/ayarlar_ek.gd`.
  - Asset: asset gerekmedi.

## 35.10 Sınırlar ve kapanış

- [ ] **AYR-48:** `ayarlar.gd` ve `tema.gd` değişmez.
  - Ne: iki çekirdek dosyanın diff'i 0; yeni anahtar, palet ve sekme ayrı dosyadadır.
  - Kabul: `git diff` iki dosyada 0 (uygulama fazında). Test: inceleme.
  - Bağımlılık: AYR-02, AYR-14. Boyut: S.
  - Dosya: `src/sistemler/ayarlar_ek.gd`, `src/arayuz/tema/palet.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-49:** Ses üretimi yok.
  - Ne: bu bölüm yeni ses dosyası, bus, seslendirme veya ekran okuyucu sesi eklemez.
  - Kabul: `assets/ses/` dosya sayısı değişmez. Test: sayım.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **AYR-50:** Tuş atama ve dil bu bölümde değildir.
  - Ne: Kontroller sekmesi Bölüm 45 (GIR), Dil sekmesi Bölüm 46 (YER) içindedir; burada yalnız sekme yuvası vardır.
  - Kabul: `ayar_sekmeleri.gd` iki boş yuva. Test: ekran.
  - Bağımlılık: GIR-01, YER-01. Boyut: S.
  - Dosya: `src/arayuz/ayarlar/ayar_sekmeleri.gd`.
  - Asset: asset gerekmedi.
- [ ] **AYR-51:** Ayar metinleri ikinci sütuna hazırdır.
  - Ne: tüm `arayuz.ayarlar.*` anahtarları Bölüm 46 kuralına uyar.
  - Kabul: sekme dosyalarında Türkçe sabit 0. Test: tarama.
  - Bağımlılık: YER-02. Boyut: S.
  - Dosya: `data/metin/metinler.csv`.
  - Asset: asset gerekmedi.
- [ ] **AYR-52:** Kapanış testi.
  - Ne: tek koşu: altı sekme açılır, her anahtar değiştirilip geri alınır, dosya yazılır, yeniden okunur, değerler eşit; üç yuvaya kayıt yazılır ve okunur.
  - Kabul: dört iddia tek testte. Test: `tests/oto/ayarlar_kontrol.tscn`.
  - Bağımlılık: AYR-01…51. Boyut: S.
  - Dosya: yeni: `tests/oto/ayarlar_kontrol.tscn`, `tests/oto/ayarlar_kontrol.gd`.
  - Asset: asset gerekmedi.

Alt başlıklarda madde sayısı üç ile yedi arasındadır; ses alt başlığı yalnız var olan üç bus ile sınırlı olduğu için üçtür, diğerlerinde onuncu madde var olan bir anahtarı ikinci kez yazacağı için konmadı. Toplam 52 madde.
