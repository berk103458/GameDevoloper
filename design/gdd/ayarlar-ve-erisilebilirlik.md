# Ayarlar ve erişilebilirlik

> **Status**: Designed (pending review)
> **Author**: Kullanıcı + ajanlar
> **Last Updated**: 2026-10-04
> **Last Verified**: 2026-10-04
> **Implements Pillar**: Okunurluk (sanat kitabı 7.4, 7.9); Türkçe metin ağırlıklı oyun herkes için okunur olmalı

## Summary

Ayarlar ve erişilebilirlik, oyuncunun oyunu kendine göre ayarladığı tek yerdir: ses düzeyleri, ekran modu, metin büyüklüğü, seçeneklerin belirme hızı ve (Vertical Slice'ta) tuş atama, iki adımlı onay, imleç boyutu, azaltılmış hareket ve ekran okuyucu. Ayarlar oyun kaydından ayrı bir dosyada durur, değiştiği anda uygulanır ve oturumlar arasında korunur.

> **Quick reference** — Layer: `Feature` · Priority: `MVP (kısmi)` + `Vertical Slice` · Category: `Persistence` · Key deps: `Girdi ve odak gezinmesi (3)`, `İçerik veri hattı (2)`

## Overview

Oyun sohbet ve okuma üzerine kurulu; metni rahat okuyamayan biri oyunu oynayamaz. Bu yüzden ilk demoda bile metin ölçeği ve seçeneklerin belirme hızı ayarlanabilir; ses düzeyleri ve ekran modu da her oyuncunun beklediği temel ayarlardır (kullanıcı kararı, 4 Ekim 2026: bu dördü MVP). Tuş atama, iki adımlı onay, imleç boyutu, azaltılmış hareket ve ekran okuyucu bu belgede tanımlanır ama Vertical Slice'ta açılır. Ayarlar ana menüden ve duraklatma menüsünden açılır, oyuncu bir değeri değiştirdiği anda sonucu görür ve hiçbir ayar oyunun kuralını (barlar, kararlar, gün sayacı) değiştirmez.

## Detailed Design

### Core Rules

**Ayar listesi**

1. Her ayarın türü, değerleri ve varsayılanı aşağıdadır. Varsayılanlar ve seçenek listeleri veridir (`res://data/ayarlar/ayar_varsayilanlari.tres`, İçerik veri hattı 2); bu tablo başlangıç önerisidir.

| Anahtar | Ad (ekranda, `tr()`) | Değerler | Varsayılan | Uygulama | Aşama |
|---|---|---|---|---|---|
| `ses_ana` | Ana ses | 0–10 (tam sayı, 10 parçalı kaydırıcı) | 8 | Master bus | MVP |
| `ses_muzik` | Müzik | 0–10 | 7 | Müzik bus | MVP |
| `ses_efekt` | Efektler | 0–10 | 8 | Efekt bus | MVP |
| `ekran_modu` | Ekran | `pencere`, `tam_ekran` | `tam_ekran` | Pencere modu | MVP |
| `metin_olcegi` | Metin büyüklüğü | 100, 125, 150 (%) | 100 | Tema yazı boyutları (F2) | MVP |
| `belirme_hizi` | Seçeneklerin belirişi | `normal`, `hizli`, `aninda` | `normal` | Belirme süresi çarpanı (F3) | MVP |
| `iki_adimli_onay` | Kararı iki adımda onayla | açık / kapalı | açık | Girdi (3) kural 15 | Vertical Slice |
| `tus_atama` | Tuşlar | Girdi (3) eylem listesi | Girdi (3) varsayılanları | Input Map | Vertical Slice |
| `imlec_boyutu` | İmleç | 32, 48 (px, 1080p) | 32 | Özel imleç (sanat kitabı 7.8) | Vertical Slice |
| `sistem_imleci` | Sistem imlecini kullan | açık / kapalı | kapalı | Özel imleç kapanır | Vertical Slice |
| `azaltilmis_hareket` | Azaltılmış hareket | açık / kapalı | kapalı | Kayma ve geçişler kaldırılır (sanat kitabı 7.7) | Vertical Slice |
| `ekran_okuyucu` | Ekran okuyucu | açık / kapalı | kapalı | AccessKit duyuruları (kural 13) | Vertical Slice |

2. **MVP'de görünmeyen ayar yoktur, gizli ayar yoktur.** Vertical Slice ayarları MVP ekranında hiç gösterilmez (pasif düğme olarak bile); ayar dosyasında da yazılmaz.
3. **Ayarlar oyunu değiştirmez.** Hiçbir ayar bar değeri, karar seçeneği, dönüş olasılığı, gün sayısı ya da skor üzerinde etki yapmaz. "Kolay mod" bu sistemin konusu değildir.

**Uygulama ve saklama**

4. **Anında uygulanır.** Oyuncu bir değeri değiştirdiği anda sonuç görülür ve duyulur: ses kaydırıcısı oynarken düzey değişir, metin ölçeği değişince ayarlar ekranının kendisi de yeni boyutla çizilir. "Uygula" düğmesi yoktur.
5. **Ekrandan çıkınca yazılır.** Ayarlar ekranı kapanırken (geri ya da menüye dönüş) değerler `user://ayarlar.cfg` dosyasına (Godot `ConfigFile`) bir kez yazılır. Yazma başarısız olursa değerler bu oturum boyunca geçerli kalır ve geliştirme hatası kaydedilir; oyuncuya engel çıkarılmaz.
6. **Kayıttan ayrıdır.** Ayar dosyası oyun kaydı (16) değildir: oturum sonunda silinmez, yeni oyunda sıfırlanmaz, kayıt yüklemek ayarları değiştirmez.
7. **Açılışta okunur.** Ayarlar oyun açılırken, İçerik veri hattı *Hazır* olduktan sonra ve *Menü* gösterilmeden önce okunup uygulanır; ilk karede doğru ses düzeyi ve metin boyutu vardır.
8. **Bozuk ya da eksik dosya.** Dosya yoksa varsayılanlar kullanılır (ilk açılış). Bir anahtar bilinmiyorsa yok sayılır; bir değer geçersizse (tür yanlış, aralık dışı, listede yok) **o anahtar varsayılana döner** — değer en yakına kırpılmaz — ve geliştirme hatası kaydedilir. Oyun her durumda açılır (ayar dosyası içerik değildir; İçerik veri hattı'nın "hata = başlama" kuralı uygulanmaz).
9. **Varsayılana dön.** Ayarlar ekranının her sayfasında "Varsayılana dön" vardır; yalnız o sayfanın ayarlarını varsayılana döndürür, hemen uygular. Geri alınamaz ama tek ayarın değeri yeniden değiştirilebilir; onay sorulmaz (hiçbir oyun verisi kaybolmaz).

**Ses**

10. **Ses düzeyleri** üç bus'a uygulanır: Master, Müzik, Efekt; Müzik ve Efekt Master'a bağlıdır (Ses 22 bus düzenini kurar). Düzey 0 bus'ı susturur (`mute`), sıfır doğrusal kazanç ile beklenmeyen ses kalmaz. Dönüşüm F1'dedir.

**Ekran**

11. **Ekran modu** yalnız iki değer taşır: `pencere` (1920×1080 içerik, pencere sistemce boyutlanabilir; ölçekleme `project.godot` ayarlarıyla) ve `tam_ekran` (sınırsız tam ekran). Çözünürlük seçimi yoktur: içerik her zaman 1920×1080 taban üzerinden ölçeklenir (sanat kitabı 8.3). Değişim anında olur; geri sayımlı "değişikliği koru?" sorusu gerekmez çünkü iki mod da her zaman görüntü verir.

**Metin**

12. **Metin ölçeği** tüm oyun metnine uygulanır: sohbet, anlatı, seçenekler, karar düğmeleri, menüler, ayarlar ekranı, HUD etiketleri. Taban boyutları sanat kitabı 7.4'tedir (gövde ≥ 22 px). Satır aralığı oranı (1.35–1.45) ölçekle değişmez. %150'de sohbet sütunu taşarsa kaydırılır (sanat kitabı 7.4); hiçbir metin kesilmez ya da başka bir kontrolün üstüne binmez. Son ekranındaki skor rakamı (72 px) ölçeklenmez.
13. **Seçeneklerin belirişi** Sohbet ve karar arayüzü'nün (18) belirme süresini çarpanla değiştirir (F3). `aninda` seçildiğinde seçenekler sıralı ama gecikmesiz görünür (aynı karede hepsi). Belirme sırasında atlama her ayarda çalışır (Girdi 3, kural 17).

**Erişilebilirlik (Vertical Slice)**

14. **Ekran okuyucu** açıkken her yeni odak (Girdi 3) ve her yeni belirmiş seçenek AccessKit üzerinden duyurulur; konuşan karakterin adı satırdan önce okunur; karar düğmeleri seçili/onaya hazır durumunu da söyler. Kapalıyken AccessKit ağacı yine kurulur (işletim sistemi araçları için) ama oyun ayrıca duyuru yapmaz.
15. **Azaltılmış hareket** açıkken kayma ve konum geçişleri kaldırılır, sıra ve süreler korunur (sanat kitabı 7.7).
16. **İmleç**: `imlec_boyutu` özel imlecin boyutunu seçer; `sistem_imleci` açıkken özel imleç hiç kurulmaz.
17. **İki adımlı onay ve tuş atama** yalnız bu ekranda değiştirilir; kuralları ve doğrulaması Girdi ve odak gezinmesi'ndedir (3). Bu sistem yalnız arayüzü çizer ve değeri saklar. Çakışan atama reddedildiğinde ekranda çakışan eylemin adı gösterilir.

**Erişim**

18. **Nereden açılır:** ana menü ve duraklatma menüsü (Menüler 21). Oyun sırasında açılınca Oyun durumu *Duraklatıldı*'dadır (GDD 1); ayar ekranı kapanınca duraklatma menüsüne dönülür.
19. **Ayarlar ekranı** bir girdi bağlamıdır (Girdi 3, kural 18); `geri` ekranı kapatır, kaydırıcılar `gezin_sol` / `gezin_sag` ile birer parça değişir, seçimli ayarlar aynı tuşlarla döner. Tüm ekran fare, klavye ve gamepad ile kullanılabilir.

### States and Transitions

| Durum | Giriş | Çıkış |
|---|---|---|
| **Yüklenmedi** | Program açılışı | Dosya okundu ya da yok → *Uygulandı* |
| **Uygulandı** | Açılış okuması, ya da ekran kapandıktan sonra yazma | Ayarlar ekranı açılır → *Düzenleniyor* |
| **Düzenleniyor** | Ayarlar ekranı açık; her değişiklik anında uygulanır, dosyaya yazılmaz | Ekran kapanır → dosyaya yazılır → *Uygulandı* |

Program *Düzenleniyor*'dayken kapanırsa (pencere kapatma, çökme) son yazılmış dosya geçerlidir; ekranda yapılan değişiklikler kaybolur.

### Interactions with Other Systems

| Sistem | Bu sistemden alır | Bu sisteme verir |
|---|---|---|
| Girdi ve odak gezinmesi (3) | `iki_adimli_onay`, tuş atamaları, `imlec_boyutu` | Eylem listesi, varsayılan atamalar, atama doğrulaması; ayar ekranı için odak kuralları |
| İçerik veri hattı (2) | — | Ayar varsayılanları ve seçenek listeleri; ekrandaki metin anahtarları |
| Oyun durumu (1) | — | *Duraklatıldı* durumu (oyun içinden açılış) |
| Sohbet ve karar arayüzü (18) | `metin_olcegi`, `belirme_hizi` çarpanı, `azaltilmis_hareket`, `ekran_okuyucu` | Belirme süresinin tabanı |
| HUD (19), Menüler (21), Köy görünümü (20) | `metin_olcegi`, `azaltilmis_hareket` | Menüler ayar ekranını açar |
| Ses (22) | Bus düzeyleri (F1) | Bus düzeni (Master → Müzik, Efekt) |
| Kaydet / yükle (16) | — (ayrı dosya) | — |

## Formulas

**F1 — Ses düzeyi**

`kazanc_db = linear_to_db(seviye / SES_ADIMI)` ; `seviye = 0` ise bus `mute`

**Variables:**
| Variable | Type | Range | Source | Description |
|----------|------|-------|--------|-------------|
| `seviye` | int | 0 – 10 | ayar dosyası | Kaydırıcı parçası |
| `SES_ADIMI` | int | 10 | data file | Kaydırıcıdaki parça sayısı |
| `kazanc_db` | float | −20.0 – 0.0 dB | calculated | Bus'a yazılan düzey |

**Output Range:** seviye 1 → −20.0 dB, 5 → −6.02 dB, 8 → −1.94 dB, 10 → 0 dB; seviye 0 → bus susturulur. Müzik ve Efekt, Master'a bağlı olduğu için etkin düzeyleri desibel olarak toplanır (ör. ana 5, müzik 5 → −12.04 dB). Doğrusal adım algıda ilk parçalarda büyük sıçrama yapar; prototipte duyulursa F1'e üs eklenir (Açık Soru 2).
**Example:** `ses_ana = 8` → `linear_to_db(0.8)` = −1.94 dB.

**F2 — Metin boyutu**

`boyut_px = round(taban_px * metin_olcegi / 100)`

**Variables:**
| Variable | Type | Range | Source | Description |
|----------|------|-------|--------|-------------|
| `taban_px` | int | 22 – 72 | sanat kitabı 7.4 / tema | Bir metin türünün %100'deki boyutu |
| `metin_olcegi` | int | 100, 125, 150 | ayar dosyası | Seçili ölçek |

**Output Range:** gövde 22 px → 22 / 28 / 33 px. Skor rakamı (72 px) bu formülden muaftır (kural 12).
**Example:** 26 px başlık, %125 → round(32.5) = 33 px (Godot `round` yarımı sıfırdan uzağa yuvarlar).

**F3 — Belirme süresi**

`gecikme_ms = taban_gecikme_ms * CARPAN[belirme_hizi]`

**Variables:**
| Variable | Type | Range | Source | Description |
|----------|------|-------|--------|-------------|
| `taban_gecikme_ms` | float | Sohbet ve karar arayüzü (18) belirler | data file | İki seçeneğin belirişi arasındaki süre (%100) |
| `CARPAN` | Dictionary[StringName, float] | normal 1.0, hizli 0.5, aninda 0.0 | data file | Ayara göre çarpan |

**Output Range:** 0 – `taban_gecikme_ms`. `aninda` → 0 ms; tüm seçenekler aynı karede, sırası korunarak.
**Example:** taban 300 ms (18 belirleyecek; burada yalnız örnek), `hizli` → 150 ms.

## Edge Cases

- **If ayar dosyası hiç yoksa**: varsayılanlar uygulanır; dosya, oyuncu ayar ekranını ilk kez kapattığında yazılır (açılışta yazılmaz).
- **If dosya okunamıyorsa (bozuk biçim)**: tüm ayarlar varsayılan, 1 geliştirme hatası; dosya ayar ekranı kapanana dek üzerine yazılmaz.
- **If bir değer aralık dışındaysa** (ör. `ses_ana = 14`, `metin_olcegi = 110`, `ekran_modu = "yarim"`): yalnız o anahtar varsayılana döner, kırpılmaz; 1 geliştirme hatası.
- **If dosyada bilinmeyen anahtar varsa** (ör. eski sürümden): yok sayılır; bir sonraki yazmada dosyadan düşer.
- **If MVP sürümünde dosyada Vertical Slice anahtarı varsa** (ileride): okunur ama uygulanmaz ve ekranda gösterilmez; yazarken korunur.
- **If dosyaya yazılamıyorsa** (salt okunur klasör, disk dolu): değerler bu oturumda geçerli, 1 geliştirme hatası, oyuncuya engel yok.
- **If ana ses 0 ise**: tüm sesler susar; müzik ve efekt kaydırıcıları değerlerini korur ve çalışır görünür.
- **If tam ekrana geçilirken birden çok monitör varsa**: oyun penceresinin bulunduğu monitörde tam ekran olur.
- **If pencere modunda pencere en küçük boyuta indirilirse**: içerik ölçeklenir, metin ölçeği ayarı bundan bağımsızdır.
- **If metin ölçeği %150 ve en uzun sohbet satırı sütuna sığmıyorsa**: sohbet sütunu kaydırılır, satır kesilmez (AC ile denetlenir).
- **If `aninda` seçiliyken oyuncu atlama tuşuna basarsa**: zaten belirmiş; atlama hiçbir şey yapmaz, seçim de yapılmaz.
- **If ayarlar oyun içinden (duraklatma) açılıp metin ölçeği değiştirilirse**: arkadaki sohbet ve HUD da hemen yeni boyutla çizilir; ekran kapanınca yeniden düzen gerekmez.
- **If ayarlar ekranı açıkken pencere kapatılırsa**: son yazılmış dosya geçerli; bu oturumdaki değişiklikler kaybolur.
- **If `sistem_imleci` açık ve `imlec_boyutu = 48` ise**: sistem imleci kullanılır, boyut ayarı etkisizdir (ekranda pasif değil, açıklama metniyle).

## Dependencies

**Yukarı akış (bu sistemin bağlı olduğu):**

| Sistem | Bağ | Arayüz |
|---|---|---|
| Girdi ve odak gezinmesi (3) | Sert | Eylem listesi, atama doğrulaması, ekran gezinmesi |
| İçerik veri hattı (2) | Sert | Varsayılanlar, seçenek listeleri, metin anahtarları |
| Oyun durumu (1) | Yumuşak | Oyun içinden açılış *Duraklatıldı*'da |

**Aşağı akış (bu sisteme bağlı olanlar):**

| Sistem | Bağ | Arayüz |
|---|---|---|
| Sohbet ve karar arayüzü (18) | Sert | Metin ölçeği, belirme çarpanı, azaltılmış hareket, ekran okuyucu |
| HUD (19), Köy görünümü (20), Menüler (21) | Sert | Metin ölçeği, azaltılmış hareket; Menüler ayar ekranını açar |
| Ses (22) | Sert | Bus düzeyleri |
| Girdi ve odak gezinmesi (3) | Sert | İki adımlı onay bayrağı, atamalar, imleç boyutu |

*Sistem dizini düzeltmesi: 17'nin bağımlılıklarına 2 eklenmeli; öncelik "Vertical Slice" yerine "MVP (kısmi)" — ses, ekran modu, metin ölçeği ve belirme hızı MVP'ye alındı (kullanıcı kararı, 4 Ekim 2026).*

## UI Requirements

- Ayarlar ekranı sanat kitabı 7.9'a uyar: gece zemin, kül metin; kaydırıcılar **parçalı** (bar grameri, 10 parça), seçimli ayarlar sol/sağ oklu tek satır; odakta ≥ 3 px kül çerçeve, seçili değer ters çevirme (7.3).
- MVP'de tek sayfa (Ses, Ekran, Metin başlıkları altında); Vertical Slice'ta sekmeler: Ses · Görüntü · Metin · Kontroller · Erişilebilirlik.
- Her ayarın altında bir satırlık açıklama (`tr()` anahtarı) — ör. "Seçeneklerin ekranda ne hızla belirdiği".
- Ekran okuyucu açıkken ayar adları ve değerleri okunur.

> 📌 **UX Flag — Ayarlar ve erişilebilirlik**: Bu sistemin arayüz gereksinimleri var. Pre-Production'da epiklerden önce `/ux-design` ile `design/ux/ayarlar.md` yazılmalı.

## Acceptance Criteria

> **Gözlem noktaları:** Testler ayar sistemini geçici bir `user://` klasörüyle kurar; okunanlar: geçerli ayar değerleri, `AudioServer` bus düzeyi ve mute durumu, pencere modu, tema yazı boyutları, belirme çarpanı, dosya içeriği, geliştirme hatası sayacı.

**Saklama**
- **AC-1 (Logic) İlk açılış.** **GIVEN** `user://ayarlar.cfg` yok **WHEN** oyun açılır **THEN** tüm MVP ayarları tablo 1'deki varsayılanlarda; dosya hâlâ yok.
- **AC-2 (Logic) Ekrandan çıkınca yazma.** **GIVEN** ayar ekranında `ses_muzik` 7 → 4 **WHEN** ekran açıkken dosya okunur **THEN** dosyada değer eski; **WHEN** ekran kapanır **THEN** dosyada `ses_muzik = 4`, tek yazma.
- **AC-3 (Logic) Yeniden açılış.** **GIVEN** dosyada `metin_olcegi = 150`, `ekran_modu = pencere` **WHEN** oyun açılır **THEN** *Menü*'nün ilk karesinde gövde metni 33 px ve pencere modu.
- **AC-4 (Logic) Geçersiz değer.** **GIVEN** dosyada `ses_ana = 14`, `metin_olcegi = 110`, `ekran_modu = "yarim"`, `belirme_hizi = 3` **WHEN** açılış **THEN** dördü de varsayılan (8, 100, tam_ekran, normal), diğer anahtarlar dosyadaki gibi, 4 geliştirme hatası, oyun açıldı.
- **AC-5 (Logic) Bozuk dosya.** **GIVEN** dosya geçersiz biçimde **WHEN** açılış **THEN** tüm ayarlar varsayılan, 1 geliştirme hatası, oyun açıldı; dosya içeriği değişmedi.
- **AC-6 (Logic) Bilinmeyen anahtar.** **GIVEN** dosyada `parlaklik = 5` **WHEN** açılış ve ayar ekranı aç-kapa **THEN** hata yok; yeni dosyada `parlaklik` yok.
- **AC-7 (Logic) Yazma hatası.** **GIVEN** dosya yazılamaz **WHEN** ekran kapanır **THEN** değerler bellekte yeni hâlinde, 1 geliştirme hatası, ekran kapandı.
- **AC-8 (Integration) Kayıttan bağımsız.** **GIVEN** `metin_olcegi = 125` **WHEN** oturum biter (kayıt silinir), yeni oyun başlar, eski bir kayıt yüklenir **THEN** her durumda `metin_olcegi = 125`.

**Uygulama**
- **AC-9 (Logic) Ses F1.** **GIVEN** `ses_ana` sırayla 10, 8, 5, 1, 0 **WHEN** uygulanır **THEN** Master bus 0.0, −1.94, −6.02, −20.0 dB (±0.01) ve 0'da `mute = true`; 1'e dönülünce `mute = false`.
- **AC-10 (Logic) Bus bağımsızlığı.** **GIVEN** `ses_muzik = 0`, `ses_efekt = 8` **THEN** Müzik bus susturulmuş, Efekt bus −1.94 dB.
- **AC-11 (Logic) Anında uygulama.** **GIVEN** ayar ekranı açık **WHEN** `ses_efekt` kaydırıcısında `gezin_sag` bir kez **THEN** aynı karede Efekt bus yeni düzeyde.
- **AC-12 (Logic) Metin F2.** **GIVEN** taban 22 ve 26 px **WHEN** ölçek 100 / 125 / 150 **THEN** 22/28/33 ve 26/33/39 px; skor rakamı her ölçekte 72 px.
- **AC-13 (Integration) Metin taşmaz.** **GIVEN** %150, veri hattındaki en uzun sohbet satırı ve en uzun karar düğmesi metni **WHEN** ekran çizilir **THEN** hiçbir `Label`'ın metni kesilmemiş (`get_visible_line_count() == get_line_count()` ya da kaydırma kabında), kontroller birbirinin üstüne binmiyor.
- **AC-14 (Logic) Belirme F3.** **GIVEN** `taban_gecikme_ms = 300` (fixture) **WHEN** `normal`, `hizli`, `aninda` **THEN** 300, 150, 0 ms. `aninda`'da 3 seçeneğin üçü aynı karede görünür, sıra korunur.
- **AC-15 (Logic) Ekran modu.** **GIVEN** `tam_ekran` **WHEN** `pencere` seçilir **THEN** aynı karede pencere modu `WINDOW_MODE_WINDOWED`; içerik 1920×1080 tabandan ölçekli.
- **AC-16 (Logic) Varsayılana dön.** **GIVEN** Ses sayfasında üç değer değişmiş, Metin sayfasında ölçek 150 **WHEN** Ses sayfasında "Varsayılana dön" **THEN** üç ses varsayılanda ve uygulanmış; ölçek hâlâ 150; onay sorulmadı.
- **AC-17 (Logic) Oyun kuralına dokunmaz.** **GIVEN** fixture oturumu, sabit seed **WHEN** aynı karar dizisi tüm ayar birleşimleriyle (MVP) oynanır **THEN** gün sayacı, bar değerleri ve karakter durumları her birleşimde aynı.

**Erişim ve gezinme**
- **AC-18 (Integration) Oyun içinden açılış.** **GIVEN** *Kapı açık* **WHEN** duraklat → Ayarlar → değişiklik → geri **THEN** Oyun durumu açılış boyunca *Duraklatıldı*; geri ile duraklatma menüsüne dönülür.
- **AC-19 (Logic) Gamepad ile tam kullanım.** **GIVEN** yalnız gamepad olayları **WHEN** ayar ekranındaki her ayara gidilip değeri bir kez değiştirilir ve ekran kapatılır **THEN** her ayar değişti, fare olayı kullanılmadı.
- **AC-20 (Logic) MVP'de VS ayarı yok.** **GIVEN** MVP yapılandırması **WHEN** ayar ekranı açılır **THEN** yalnız 6 MVP ayarı var; dosya yazılınca yalnız 6 anahtar.

**Görünüm**
- **AC-21 (UI) Ayar ekranı.** **GIVEN** 1080p **WHEN** ayar ekranı %100 ve %150'de açılır **THEN** parçalı kaydırıcılar, odak çerçevesi ve ters çevirme sanat kitabı 7.3/7.9'a uygun; iki ekran görüntüsü `production/qa/evidence/` altında saklanır.

*Vertical Slice ayarlarının (iki adımlı onay, tuş atama, imleç, azaltılmış hareket, ekran okuyucu) kabul ölçütleri Vertical Slice başında bu belgeye eklenecek; tuş atama ve iki adımlı onayın davranış ölçütleri zaten Girdi ve odak gezinmesi'nde (AC-23, AC-42–46).*

## Open Questions

1. **Ekran okuyucu (AccessKit) 4.7.2'de** — duyuru API'si ve Windows'ta NVDA/Narrator ile davranış doğrulanmadı. Sahibi: ui-programmer. Hedef: Vertical Slice başı.
2. **Ses eğrisi** — F1 doğrusal kazanç; düşük parçalarda sıçrama duyulursa `(seviye/10)^2` gibi bir üs eklenir. Sahibi: Ses (22). Hedef: ilk prototip.
3. **Varsayılan ekran modu** — `tam_ekran` mı `pencere` mi? Geliştirme sırasında pencere daha pratik; dağıtımda tam ekran öneriliyor. Sahibi: Kullanıcı.
4. **Altyazı / ses betimleme** — seslendirme yok; ses efektlerine altyazı gerekip gerekmediği Ses (22) tasarlanırken karar verilir.
5. **Renk körlüğü** — palet tek renk ayrımına dayanmıyor (sanat kitabı 4); ayrı bir renk modu şimdilik gerekmiyor. Sahibi: art-director onaylayacak.
