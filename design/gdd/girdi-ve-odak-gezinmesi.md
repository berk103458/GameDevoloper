# Girdi ve odak gezinmesi

> **Status**: In Design
> **Author**: Kullanıcı + ajanlar
> **Last Updated**: 2026-10-04
> **Last Verified**: 2026-10-04
> **Implements Pillar**: Seçenekler ekrana bir anda düşmez; B/Esc "ret" değildir (sanat kitabı 7.10)

## Summary

Girdi ve odak gezinmesi, klavye, fare ve gamepad girişini oyunun adlandırılmış eylemlerine çevirir ve her ekranda tek bir odaklı kontrol olmasını sağlar. Oyuncuya "bastığım şey ne yaptı" sorusunu hiç sordurmaz: gezinme görsel sırayı izler, B/Esc asla bir kararı vermez ve kısayolla verilen karar iki adımda onaylanır. Tüm etkileşimin girişi burasıdır; kararlar, sohbet seçenekleri, menüler ve ayarlar aynı kurallarla gezilir.

> **Quick reference** — Layer: `Foundation` · Priority: `MVP` · Category: `Core` (inferred) · Key deps: `Yok (yukarı akış)`

## Overview

Bu sistem ham girişi (tuş, fare, gamepad) anlamlı eylemlere çevirir, hangi kontrolün odakta olduğunu yönetir ve ekranlar arası geçişte girişin yanlışlıkla yutulmasını ya da taşmasını önler. Oyun sıra tabanlıdır ve gerçek zamanlı refleks istemez; bu yüzden tasarımın tek derdi **güvenli ve öngörülür gezinmedir**: yanlış basışla geri dönüşü olmayan bir karar verilmemeli (Papers-Please ağırlığı), fareyle oynayan da klavyeyle oynayan da aynı arayüzü kullanabilmeli. Sistemin kendi görseli yoktur; odak çerçevesi ve durumlar sanat kitabı 7.3'te, ekran yerleşimleri Sohbet ve karar arayüzü (18) ve Menüler (21) belgelerindedir. Sistem oyuncuya "ayarlar" olarak yalnız tuş atamayı ve iki adımlı onayı açıp kapamayı sunar; bunların arayüzü Ayarlar ve erişilebilirlik (17) belgesinindir.

## Detailed Design

### Core Rules

**Eylemler**

1. **Ham tuş yok.** Oyun kodu ham tuş, fare düğmesi ya da gamepad düğmesi sormaz; yalnız aşağıdaki adlandırılmış eylemleri (`StringName`) dinler. Böylece her tuş yeniden atanabilir.

| Eylem | Anlamı | Klavye (varsayılan) | Fare | Gamepad (varsayılan) |
|---|---|---|---|---|
| `gezin_yukari` / `gezin_asagi` / `gezin_sol` / `gezin_sag` | Odağı bir kontrol taşı | Ok tuşları, W A S D | — (odak fare ile taşınır, kural 8) | D-pad, sol çubuk |
| `onayla` | Odaktaki kontrolü etkinleştir | Enter, Boşluk | Sol tık (bırakınca) | A |
| `geri` | Seçimi iptal et, seçim yoksa menüyü aç/kapat | Esc | Sağ tık yalnız *seçimi iptal eder*, menü açmaz | B (menü açmak için Start da) |
| `kisayol_1` … `kisayol_4` | Karar panelinde 1–4. yuvayı seç | 1 2 3 4 | — | — (MVP'de yok) |
| `menu` | Duraklatma menüsünü aç/kapat | Esc, P | — | Start |

2. **Esc iki iş yapar, "ret" yapmaz.** `geri` seçim varsa seçimi iptal eder (Karar iki adımlı onayın ilk adımına döner); seçim yoksa duraklatma ister (`menu` ile aynı). Hiçbir eylem, hiçbir bağlamda, kendi başına bir kararı (kabul / ret / rüşvet / kışla) vermez. Sanat kitabı 7.10.
3. **Gamepad yüz tuşu kısayolu MVP'de yoktur.** B'nin `geri` olması ve A'nın `onayla` olması yüzünden X/Y dışında kısayola yer kalmaz; gamepad ile karar odak + A ile verilir. (Kararı gamepad kısayoluna bağlamak Açık Soru 2.)
4. **Yeniden atama.** Her eylem klavye ve gamepad için ayrı ayrı yeniden atanabilir. Bu sistem eylem listesini, varsayılanları ve doğrulamayı tutar; arayüzü Ayarlar (17) çizer. Kurallar: her eylemin her aygıt ailesinde (klavye+fare / gamepad) en az 1 bağı olur; aynı bağlamda iki eyleme aynı tuş atanamaz (reddedilir, bağ değişmez); "varsayılana dön" her zaman çalışır. Atamalar Ayarlar dosyasında saklanır (17), kayıtta (16) değil.

**Odak**

5. **Tek odak.** Bir ekranda aynı anda en çok bir kontrol odaklıdır ve odak çerçevesi (≥ 3 px kül çerçeve, sanat kitabı 7.3) yalnız onda görünür. Godot'un fare üzerine gelme durumu ile klavye/gamepad odağının ayrı olması (4.6) bu davranışı bozmamalıdır: tema, üzerine gelme (`hover`) görünümünü *normal* ile aynı tutar; çerçeveyi yalnız `focus` görünümü çizer.
6. **Son girişin kazandığı mod.** Sistem `girdi_modu` tutar: `fare` ya da `klavye_gamepad`. Mod yalnız *gerçek* bir giriş gelince değişir (Formüller F1). Fare moduna geçmek odağı hemen değiştirmez; odak fare bir kontrolün üzerine gelene dek aynı kontrolde kalır.
7. **Klavye/gamepad modunda** fare konumu odağı değiştirmez (fare titremesi, ekranda kalmış fare). Fare tıklaması her zaman fare moduna geçirir ve tıklanan kontrolü etkinleştirir.
8. **Fare modunda** fare bir odaklanabilir kontrolün üzerine girince o kontrol odak alır (`mouse_entered` → `grab_focus`). Fare hiçbir kontrolün üzerinde değilse odak son odaklanan kontrolde kalır; odak kimsede olmaz denilen bir an oluşmaz.
9. **Odak sırası görsel sırayı izler.** Sohbet listesinde yukarı/aşağı, karar yuvalarında sol/sağ. Her ekran `focus_neighbor_*` komşularını açıkça tanımlar; Godot'un otomatik komşu seçimine güvenilmez. Gezinme barlara (HUD) ya da menüye *atlamaz*; bunlar yalnız `menu` ya da fare ile erişilir. (HUD yalnız gösterir; odaklanamaz.)
10. **Liste sarması.** Listenin son öğesinde aşağı → ilk öğe, ilkinde yukarı → son öğe. Bir tuşa *basılı tutarken* otomatik tekrar sararken durur (listenin ucunda kalır); sarma yeni bir basışla olur. Böylece basılı tutmak odağı döndürüp oyuncuyu şaşırtmaz.
11. **Kareye bir hareket.** Aynı karede birden çok gezinme eylemi gelirse yalnız ilki işlenir.
12. **Varsayılan odak.** Her ekran/panel açılırken bir "varsayılan odak" kontrolü bildirir. Karar panelinde bu ilk yuvadır. Sohbet listesinde ilk *görünür* seçenektir (kural 17).
13. **Odak kaybolmaz.** Odaklı kontrol silinir, gizlenir ya da etkisiz kılınırsa odak ekranın varsayılan odağına, o da yoksa bağlamdaki ilk odaklanabilir kontrole gider. Hiçbiri yoksa geliştirme hatası kaydedilir; oyun takılmaz (fare yine çalışır).
14. **Etkisiz (kullanılamaz) kontrol** odaklanabilir kalır ama etkinleştirilemez (sanat kitabı 7.3: boş kese + kesik çerçeve). `onayla` ona gelirse hiçbir şey olmaz ve "etkisiz etkinleştirme" bildirilir (ses/geri bildirimi 18 ve 22'ye ait). Kontrolün hiç gösterilmemesi bir oyun tasarımı kararıdır, bu sistemin değil.

**İki adımlı onay (yalnız karar bağlamı)**

15. **Karar iki adımda verilir.** Karar yuvasının ilk etkinleştirilişi (fareyle tıklama, `onayla` ya da `kisayol_N`) yuvayı **seçili / onaya hazır** yapar (sanat kitabı 7.3: tam ters çevirme); aynı yuvanın ikinci etkinleştirilişi kararı verir. Başka bir yuva etkinleştirilirse seçim ona geçer, karar verilmez. `geri` (ya da sağ tık) seçimi kaldırır. Ayarlar'daki "iki adımlı onay" kapatılırsa fare/`onayla` ile tek adımda verilir; **kısayollar (`kisayol_N`) her durumda iki adımlıdır** (7.10). Karar *panelinde* gezinmek (yön eylemleri) seçimi bozmaz ve karar vermez.
16. **Sohbet seçenekleri tek adımdır.** Sohbet bir sonraki cümleyi seçer, geri dönüşü olmayan bir köy kararı değildir; iki adımlı onay yalnız karar bağlamına uygulanır.
17. **Belirme sırasında.** Seçenekler tek tek belirir (Sohbet ve karar arayüzü 18, "seçenek belirme hızı"). Odak yalnız belirmiş seçeneklere gelir; belirmemiş seçenek odaklanamaz ve `kisayol_N` onu seçemez. Belirme bitmeden ilk seçeneğe `onayla` basılırsa bu bir *atlama* isteğidir: kalan seçenekler hemen belirir, hiçbir seçenek etkinleşmez.

**Bağlamlar ve girişin yutulması**

18. **Girdi bağlamı yığını.** Her ekran bir bağlam açar (örn. *Sohbet*, *Karar*, *Duraklatma*, *Ayarlar*, *Menü*, *Son ekranı*) ve kapanınca bırakır. Eylemler yalnız en üstteki bağlama gider; alttaki bağlamlar odak ve giriş almaz. Duraklatma menüsü açıkken oyun sahnesi giriş almaz.
19. **Giriş yutma.** Yeni bir bağlam açıldığı anda *basılı olan* eylemler yutulur: o basış, tuş bırakılana dek yeni bağlamda "basıldı" sayılmaz. (Bir ekrandaki `onayla`nın, hemen açılan sonraki ekranın ilk yuvasını etkinleştirmesi önlenir.) Fare düğmesi için de aynıdır.
20. **Giriş kilidi.** Oyun durumu (1) *Perde geçişi*, *Oturum sonu* ve *Gece sonu* çözümü gibi girişin anlamsız olduğu anlarda bağlam yığınına bir *kilit* bağlamı koyar; eylemler hiçbir yere gitmez. Kilit kalkınca kural 19 uygulanır.
21. **Duraklatma isteği bu sistemden çıkar, kararı vermez.** `menu` (ya da seçim yokken `geri`) Oyun durumu'na "duraklat" ister. İsteği kabul/ret ve erteleme Oyun durumu'na aittir (GDD 1: *Perde geçişi*/*Oturum sonu*'nda yok sayılır, *Gece sonu* çözümünde bekletilir). Duraklatma bağlamı açıkken `menu` / `geri` menüyü kapatır ve "devam" ister.

**İpucu glifleri**

22. **İpucu seti.** `ipucu_seti` ∈ {`klavye`, `gamepad`}: son kullanılan *klavye/gamepad* aygıtı belirler (fare ikisini değiştirmez). Arayüz bir eylemin ipucunu `ipucu(eylem)` ile ister; dönen değer o setteki *güncel* bağın (yeniden atanmış olsa bile) etiketidir. Etiket metinleri çeviri anahtarlarıdır (`arayuz.girdi.tus.<ad>`), glif çizimi sanat kitabı 7.10'a göre kül renktedir.

**Kapsam dışı (bilinçli)**: dokunmatik, fare tekerleği ile gezinme, birden çok oyuncu, fare ile sürükle-bırak, kayan imleç ivmesi.

### States and Transitions

Sistemin üç bağımsız durum alanı vardır.

| Alan | Değerler | Değişim |
|---|---|---|
| `girdi_modu` | `fare`, `klavye_gamepad` | Gerçek fare hareketi/tık → `fare`; gezinme/onay/geri/menü/kısayol eylemi ya da gamepad eksen eşiği → `klavye_gamepad` |
| `ipucu_seti` | `klavye`, `gamepad` | Son klavye eylemi → `klavye`; son gamepad eylemi → `gamepad`; gamepad çıkarsa → `klavye` |
| Karar seçimi (yalnız karar bağlamı) | `bos`, `secili(yuva)` | `bos` + etkinleştirme → `secili(yuva)`; `secili(a)` + etkinleştirme a → karar verilir, `bos`; `secili(a)` + etkinleştirme b → `secili(b)`; `geri`/sağ tık/panel kapanması → `bos` |

Başlangıç: `girdi_modu = klavye_gamepad` (ekranda hareket etmemiş fare yanlışlıkla mod değiştirmesin), `ipucu_seti = klavye`, seçim `bos`. Bağlam yığını boştur; *Menü* açılırken ilk bağlam konur.

### Interactions with Other Systems

| Sistem | Bu sistemden alır | Bu sisteme verir | Sahip |
|---|---|---|---|
| Oyun durumu ve gün döngüsü (1) | `duraklat_istendi`, `devam_istendi` | Giriş kilidi bağlamı (Perde geçişi, Oturum sonu, Gece sonu çözümü) | 3 sinyal yayınlar, 1 karar verir |
| Sohbet ve karar arayüzü (18) | Eylemler, odak, `ipucu()`, iki adımlı onay yardımcısı | Bağlam açma/kapama, varsayılan odak, komşu tanımı, belirme durumu | 18 ekranı çizer, 3 kuralları verir |
| Menüler ve son ekranı (21) | Aynı | Aynı | 21 |
| Ayarlar ve erişilebilirlik (17) | Eylem listesi, varsayılanlar, atama doğrulaması | Yeniden atama istekleri, "iki adımlı onay" bayrağı, imleç boyutu | 17 arayüz, 3 doğrulama |
| Karar (7), Sohbet (6) | Etkinleştirme olayları (`onaylandi`, `secildi`) | — | 6 ve 7 sonucu yorumlar |
| İçerik veri hattı (2) | Eşik değerleri `data/ayarlar/girdi.tres`; ipucu etiketleri `tr()` | — | 2 |
| Ses (22) | `etkisiz_etkinlestirme`, odak taşıma olayı (yumuşak) | — | 22 |
| HUD (19) | — (HUD odaklanamaz) | — | — |

## Formulas

Sistemin tek sayısal kuralları giriş eşikleridir. Hepsi veridir (`data/ayarlar/girdi.tres`, İçerik veri hattı 2); başlangıç değerleri önerilir ve prototipte ayarlanır.

**F1 — Mod değişimi**

`fare_moduna_gec = (olay is InputEventMouseButton) or (olay is InputEventMouseMotion and olay.relative.length() >= FARE_HAREKET_ESIGI)`

`klavye_moduna_gec = (olay is InputEventKey and pressed and echo == false) or (olay is InputEventJoypadButton and pressed) or (olay is InputEventJoypadMotion and abs(olay.axis_value) >= GAMEPAD_EKSEN_ESIGI)`

**Variables:**
| Variable | Type | Range | Source | Description |
|----------|------|-------|--------|-------------|
| `FARE_HAREKET_ESIGI` | float (px) | 1–20 | data file | Tek bir hareket olayının en küçük göreli uzunluğu; altı sensör titremesi sayılır |
| `GAMEPAD_EKSEN_ESIGI` | float | 0.2–0.9 | data file | Çubuğun mod değiştirmesi için gereken eksen değeri; sapma (drift) mod değiştirmez |
| `olay.relative` | Vector2 | — | calculated | Motor olayının göreli hareketi |

**Output Range:** Her olay için `bool`. Başlangıç değerleri: `FARE_HAREKET_ESIGI = 4.0`, `GAMEPAD_EKSEN_ESIGI = 0.5`. Her iki koşul aynı karede doğruysa son gelen olay kazanır.
**Example:** `relative = (1, 1)` → uzunluk 1.41 < 4 → mod değişmez. `relative = (5, 0)` → 5 ≥ 4 → `fare`. Çubuk 0.3 → mod değişmez; 0.8 → `klavye_gamepad`.

**F2 — Basılı tutarak tekrar**

`tekrar_sayisi(t) = 0` eğer `t < TEKRAR_GECIKMESI`; aksi halde `1 + floor((t - TEKRAR_GECIKMESI) / TEKRAR_ARALIGI)`

**Variables:**
| Variable | Type | Range | Source | Description |
|----------|------|-------|--------|-------------|
| `t` | float (ms) | ≥ 0 | calculated | Gezinme eyleminin basılı kalma süresi (ilk basıştan sonra) |
| `TEKRAR_GECIKMESI` | float (ms) | 200–800 | data file | İlk basıştan sonra tekrarın başlama süresi |
| `TEKRAR_ARALIGI` | float (ms) | 60–250 | data file | Tekrarlar arası süre |

**Output Range:** 0 – sınırsız tamsayı, listenin ucuna varınca fazla tekrarlar yok sayılır (kural 10). Başlangıç: `TEKRAR_GECIKMESI = 400`, `TEKRAR_ARALIGI = 120`.
**Example:** t = 300 → 0 tekrar. t = 400 → 1. t = 640 → 1 + floor(240/120) = 3 tekrar.

## Edge Cases

**Mod ve odak**
- **If fare ekranda dururken klavye modundaki bir ekran açılırsa**: odak değişmez, hover çerçevesi çizilmez; fare ilk gerçek hareketinde (F1) moda geçer.
- **If fare moduna geçilirken odaklı kontrol fareyle aynı kontrol değilse**: odak fare bir kontrolün üzerine girene dek eskisinde kalır; çerçeve kaybolmaz.
- **If fare iki kontrolün arasındaki boşlukta ise**: odak son kontrolde kalır.
- **If gamepad çubuğu sapar (|eksen| < `GAMEPAD_EKSEN_ESIGI`)**: mod ve odak değişmez.
- **If gamepad oyun sırasında çıkarılırsa**: `ipucu_seti` `klavye`ye döner, oyun durumu değişmez (oyunun saati yok), duraklatma istenmez. Tekrar takılıp bir gamepad eylemi gelince `gamepad` olur.
- **If iki gamepad bağlıysa**: ikisinden de gelen eylemler kabul edilir; `ipucu_seti` `gamepad`dir.
- **If aynı karede iki farklı yön gelirse**: ilk gelen işlenir, ikincisi yok sayılır (kural 11).
- **If liste tek öğeliyse**: gezinme eylemleri odağı oynatmaz (sarma aynı öğeye döner), hata yok.
- **If odaklı kontrol silinir ya da gizlenirse**: kural 13; odak varsayılana, o da yoksa bağlamdaki ilk odaklanabilir kontrole gider.
- **If bağlamda hiç odaklanabilir kontrol yoksa**: geliştirme hatası kaydedilir; fare etkileşimi sürer.

**İki adımlı onay**
- **If seçili yuvadayken yön eylemleri gelirse**: odak taşınır, seçim değişmez; seçili yuva ters çevirmeyi korur.
- **If seçili yuvadayken panel kapanır (gece sonu, duraklatma, perde geçişi)**: seçim `bos` olur; geri gelince karar verilmemiş sayılır.
- **If aynı karede `kisayol_2` ve `onayla` gelirse**: ilk gelen işlenir (kural 11 mantığı: kareye bir etkinleştirme).
- **If iki adımlı onay kapalıyken `kisayol_N` basılırsa**: yine iki adımlıdır (kural 15). Ayar yalnız fare/`onayla` için geçerlidir.
- **If `geri` basılır ve seçim yoksa**: duraklatma istenir (kural 2, 21); Oyun durumu *Perde geçişi*/*Oturum sonu*'nda yok sayar (GDD 1).
- **If sağ tıklanır ve seçim yoksa**: hiçbir şey olmaz; menü açılmaz.
- **If etkisiz yuvaya `kisayol_N` ya da `onayla` gelirse**: seçim yapılmaz, mevcut seçim korunur, "etkisiz etkinleştirme" bildirilir.
- **If seçenekler henüz belirmediyse `kisayol_N` basılırsa**: yok sayılır; belirme bitince tekrar basılması gerekir (yutma yok, tuş "basıldı" sayılmamıştır).

**Bağlam ve yutma**
- **If bir bağlam açıldığı karede `onayla` basılıysa**: tuş bırakılana dek yeni bağlamda yok sayılır (kural 19).
- **If pencere odağını kaybederse (alt-tab)**: basılı tüm eylemler bırakılmış sayılır; tekrar sayacı sıfırlanır; odak ve seçim aynı kalır.
- **If giriş kilidi açıkken eylem gelirse**: hiçbir yere gitmez, birikmez (kuyruğa girmez); kilit kalkınca kural 19.
- **If aynı anda iki bağlam açılmak istenirse (aynı kare)**: yığına geliş sırasıyla konur; yalnız sonuncusu girişi alır.
- **If yığın boşken eylem gelirse**: yok sayılır, geliştirme hatası (her ekran bir bağlam açmalı).

**Yeniden atama**
- **If atanmak istenen tuş aynı bağlamda başka bir eyleme bağlıysa**: reddedilir, bağlar değişmez, çakışan eylemin adı bildirilir.
- **If bir eylemin son bağı silinmek istenirse**: reddedilir (kural 4, her aygıt ailesinde ≥ 1 bağ).
- **If kaydedilmiş atama dosyası bilinmeyen bir eylem ya da geçersiz tuş içeriyorsa**: o satır atlanır, kalan satırlar uygulanır, eksik eylemler varsayılanla doldurulur; geliştirme hatası kaydedilir. Oyun başlar (oyuncunun ayarı içerik değildir; İçerik veri hattı'nın "hata = başlama" kuralı atama dosyasına uygulanmaz).
- **If bir `kisayol_N` eylemi yeniden atanırsa**: yalnız klavye; gamepad'e atanamaz (MVP).

## Dependencies

**Yukarı akış (bu sistemin bağlı olduğu):** Yok — Foundation katmanı. Motor: Godot Input Map ve Control odak sistemi; yapılandırma değerleri İçerik veri hattı'ndan (2, yumuşak: değer yoksa kodda bir geri dönüş değeri kullanılmaz, İçerik veri hattı *Hatalı* olur).

**Aşağı akış (bu sisteme bağlı olanlar):**

| Sistem | Bağ | Arayüz |
|---|---|---|
| Oyun durumu ve gün döngüsü (1) | Sert | `duraklat_istendi` / `devam_istendi` alır; giriş kilidi bağlamı koyar |
| Ayarlar ve erişilebilirlik (17) | Sert | Eylem listesi, varsayılanlar, atama doğrulaması, "iki adımlı onay" bayrağı |
| Sohbet ve karar arayüzü (18) | Sert | Odak, bağlam, iki adımlı onay yardımcısı, `ipucu()` |
| Menüler ve son ekranı (21) | Sert | Aynı |
| Sohbet (6), Karar (7) | Sert (dolaylı, 18 üzerinden) | Etkinleştirme olayı |
| HUD (19) | Yumuşak | HUD odaklanamaz; yalnız `ipucu()` ile tuş ipucu gösterebilir |
| Ses (22) | Yumuşak | Odak/etkisiz etkinleştirme olayları |
| İçerik veri hattı (2) | Sert (yukarı akış) | Eşik değerleri |

*Çift yönlü bağımlılık için gerekenler: Ayarlar (17) belgesi "eylem listesi ve atama doğrulaması 3'tedir"; Sohbet ve karar arayüzü (18) belgesi "iki adımlı onay ve odak kuralları 3'tedir, karar vermek 18/7'dir" yazmalıdır. Sistem dizininde 3'ün bağımlılıklar sütununa 2 (eşik verisi) eklenmeli.*

## Acceptance Criteria

> **Gözlem noktaları:** Testler `Input.parse_input_event` ile sentetik olay verir ve şunları okur: `girdi_modu`, `ipucu_seti`, odaklı kontrolün adı (`get_viewport().gui_get_focus_owner()`), karar seçimi, yayınlanan sinyaller (`karar_verildi`, `duraklat_istendi`, `etkisiz_etkinlestirme`), geliştirme hatası sayacı. "Fixture ekranı" = 4 düğmeli (1 etkisiz) karar yuvası satırı ve 3 öğeli dikey liste içeren test sahnesi.

- **AC-1 (Logic) Eylemler.** **GIVEN** varsayılan atamalar **WHEN** `Enter`, `Boşluk`, gamepad `A` verilir **THEN** her biri `onayla` olarak çözülür; `Esc` `geri` ve `menu` olarak, `Start` `menu` olarak çözülür.
- **AC-2 (Logic) Ham tuş yok.** **GIVEN** `src/` altındaki `.gd` dosyaları **WHEN** denetim `InputEventKey.keycode ==`, `KEY_`, `JOY_BUTTON_` karşılaştırmalarını arar **THEN** bulgu yok (eylem eşlemeyi kuran dosya hariç).
- **AC-3 (Logic) Mod değişimi.** **GIVEN** `girdi_modu = klavye_gamepad` **WHEN** relative = (1,1) **THEN** mod değişmez; **WHEN** relative = (5,0) **THEN** `fare`; **WHEN** sonra ok tuşu **THEN** `klavye_gamepad`. Çubuk 0.3 → değişmez; 0.8 → `klavye_gamepad`.
- **AC-4 (Logic) Başlangıç durumu.** **GIVEN** yeni oyun **WHEN** ilk ekran açılır **THEN** `girdi_modu = klavye_gamepad`, `ipucu_seti = klavye`, seçim `bos`.
- **AC-5 (Integration) Tek odak.** **GIVEN** fixture ekranı, fare modu **WHEN** fare 2. düğmenin üzerine girer **THEN** odak sahibi 2. düğme, ekranda odak çerçevesi çizen kontrol sayısı = 1 (hover stili normal ile aynı). **WHEN** `gezin_sag` **THEN** odak 3. düğmeye taşınır, yine tek çerçeve.
- **AC-6 (Integration) Klavye modunda fare odak çalmaz.** **GIVEN** `klavye_gamepad`, odak 1. düğmede **WHEN** fare 3. düğmenin üstüne gelir ama eşik altı hareketle **THEN** odak 1. düğmede kalır.
- **AC-7 (Logic) Sarma ve tekrar.** **GIVEN** 3 öğeli liste, odak 3. öğede **WHEN** `gezin_asagi` basılır **THEN** odak 1. öğe. **WHEN** `gezin_asagi` basılı tutulup t = 640 ms **THEN** 3 tekrar işlenir ve odak listenin sonunda durur, sarmaz (F2).
- **AC-8 (Logic) Kareye bir hareket.** **GIVEN** odak 2. öğede **WHEN** aynı karede `gezin_asagi` ve `gezin_yukari` gelir **THEN** yalnız ilki işlenir.
- **AC-9 (Logic) Tek öğeli liste.** **GIVEN** tek öğeli liste **WHEN** her yön eylemi **THEN** odak aynı öğede, 0 hata.
- **AC-10 (Integration) Odak kaybolmaz.** **GIVEN** odak sahibi gizlenir **WHEN** bir sonraki kare **THEN** odak ekranın varsayılan odağındadır. **GIVEN** varsayılan da yok **THEN** bağlamdaki ilk odaklanabilir kontrol. **GIVEN** hiç yok **THEN** 1 geliştirme hatası, çökme yok.
- **AC-11 (Logic) Barlara atlamaz.** **GIVEN** karar panelinde odak son yuvada **WHEN** `gezin_sag` **THEN** odak ilk yuvaya sarar; odak HUD kontrolüne ya da menüye hiçbir yönde geçmez.
- **AC-12 (Logic) İki adımlı onay.** **GIVEN** fixture karar satırı, seçim `bos` **WHEN** 1. yuvada `onayla` **THEN** seçim `secili(1)`, `karar_verildi` yayınlanmadı. **WHEN** tekrar `onayla` **THEN** `karar_verildi(1)` bir kez yayınlanır, seçim `bos`.
- **AC-13 (Logic) Seçim değiştirme ve iptal.** **GIVEN** `secili(1)` **WHEN** 2. yuvada `onayla` **THEN** `secili(2)`, karar yok. **WHEN** `geri` **THEN** seçim `bos`, karar yok, `duraklat_istendi` yayınlanmadı.
- **AC-14 (Logic) Seçim yokken geri.** **GIVEN** seçim `bos` **WHEN** `geri` **THEN** `duraklat_istendi` bir kez yayınlanır, hiçbir karar verilmez.
- **AC-15 (Logic) Sağ tık.** **GIVEN** `secili(1)` **WHEN** sağ tık **THEN** seçim `bos`. **GIVEN** seçim `bos` **WHEN** sağ tık **THEN** hiçbir sinyal yayınlanmaz.
- **AC-16 (Logic) Kısayollar her zaman iki adımlı.** **GIVEN** iki adımlı onay **kapalı** **WHEN** fareyle 1. yuvaya tek tık **THEN** `karar_verildi(1)`. **GIVEN** aynı ayar **WHEN** `kisayol_2` bir kez **THEN** `secili(2)`, karar yok; ikinci basışta `karar_verildi(2)`.
- **AC-17 (Logic) Etkisiz yuva.** **GIVEN** 4. yuva etkisiz, `secili(1)` **WHEN** 4. yuvada `onayla` ya da `kisayol_4` **THEN** seçim `secili(1)` kalır, `etkisiz_etkinlestirme` bir kez, karar yok.
- **AC-18 (Logic) Belirme sırasında.** **GIVEN** 3 seçenekten yalnız 1'i belirmiş **WHEN** `kisayol_3` **THEN** yok sayılır. **WHEN** `onayla` (1. seçenekte) **THEN** kalan seçenekler hemen belirir, hiçbir seçenek etkinleşmez.
- **AC-19 (Logic) Sohbet tek adım.** **GIVEN** sohbet bağlamı **WHEN** bir seçenekte `onayla` **THEN** `secildi` bir kez yayınlanır (ara seçim yok).
- **AC-20 (Integration) Giriş yutma.** **GIVEN** *Sohbet*'te `onayla` basılı **WHEN** *Karar* bağlamı açılır ve tuş hâlâ basılıdır **THEN** yeni bağlamda 0 etkinleştirme; tuş bırakılıp tekrar basılınca etkinleşir.
- **AC-21 (Logic) Bağlam yığını.** **GIVEN** *Karar* altında *Duraklatma* bağlamı **WHEN** `onayla` **THEN** yalnız duraklatma menüsü tepki verir; karar paneli 0 olay alır. **WHEN** `menu` **THEN** `devam_istendi`.
- **AC-22 (Integration) Giriş kilidi.** **GIVEN** Oyun durumu *Perde geçişi*'nde **WHEN** `onayla`, `menu`, `kisayol_1` gönderilir **THEN** hiçbir olay yayınlanmaz ve kuyruğa girmez; kilit kalkınca 0 eylem uygulanır. `duraklat_istendi` yine de Oyun durumu'na ulaşır ve oradan yok sayılır (GDD 1 AC-39).
- **AC-23 (Logic) İpucu seti.** **GIVEN** `ipucu_seti = gamepad` **WHEN** `ipucu(onayla)` **THEN** "A" etiketi; klavye eylemi gelince `ipucu(onayla)` "Enter" etiketi. **GIVEN** `onayla` Boşluk'a yeniden atanmış **THEN** "Boşluk". Etiket metni `tr()` anahtarından gelir.
- **AC-24 (Logic) Gamepad çıkarılır.** **GIVEN** `ipucu_seti = gamepad` **WHEN** gamepad ayrılır **THEN** `ipucu_seti = klavye`, `duraklat_istendi` yayınlanmaz, durum değişmez.
- **AC-25 (Logic) Yeniden atama.** **GIVEN** `onayla` = Enter **WHEN** `gezin_sag` Enter'a atanmak istenir **THEN** reddedilir, her iki bağ değişmez, çakışan eylem adı döner. **WHEN** `onayla`nın klavyedeki son bağı silinmek istenir **THEN** reddedilir. **WHEN** varsayılana dön **THEN** AC-1 geçer.
- **AC-26 (Logic) Bozuk atama dosyası.** **GIVEN** dosyada bilinmeyen eylem `ucus` ve geçersiz tuş **WHEN** yüklenir **THEN** o satırlar atlanır, diğerleri uygulanır, eksikler varsayılan, 1 geliştirme hatası, oyun başlar.
- **AC-27 (Logic) Pencere odağı kaybı.** **GIVEN** `gezin_asagi` basılı tekrar ederken **WHEN** pencere odağı kaybolur **THEN** tekrar durur, odak ve seçim değişmez.
- **AC-28 (UI) Odak çerçevesi.** **GIVEN** karar ekranı her mod için **WHEN** odak 1. yuvada **THEN** çerçeve ≥ 3 px kül (sanat kitabı 7.3); seçili yuvada tam ters çevirme. Fare ve klavye modları için ayrı ekran görüntüleri `production/qa/evidence/` altında saklanır.
- **AC-29 (Integration) Çift odak regresyonu.** **GIVEN** Godot 4.7.2'de fixture ekranı **WHEN** fare bir düğmenin üstündeyken `gezin_sag` ile başka düğmeye geçilir **THEN** ekranda tek çerçeve görünür, hover çerçevesi yoktur (4.7'de doğrulama, Açık Soru 1).
- **AC-30 (Performance) Girdi gecikmesi.** **GIVEN** hedef PC **WHEN** bir eylem gelir **THEN** odağın taşınması ve çerçevenin çizilmesi aynı karede (≤ 1 kare) gerçekleşir.

## Open Questions

1. **4.7 odak davranışı** — "hover stili normal ile aynı + `mouse_entered → grab_focus`" yaklaşımının 4.7.2'de tek çerçeve verdiği küçük bir sahneyle doğrulanmadı (`core.md`/giriş referansı 4.6'ya göre; cihaz kimlikleri 4.7'de değişti). Sahibi: Kullanıcı / ui-programmer. Hedef: ilk girdi hikâyesi.
2. **Gamepad ile karar kısayolu** — X/Y ve D-pad bölümleri MVP'de bağlanmadı (B = `geri`, A = `onayla`). Gerekirse sonra eklenir (iki adımlı onayla). Sahibi: Kullanıcı. Hedef: Vertical Slice.
3. **Gamepad ipucu glifleri** — tek genel set mi, Xbox/PlayStation ayrımı mı? Sanat kitabı yalnız "gamepad" diyor. Sahibi: art-director. Hedef: Vertical Slice.
4. **Etkisiz kontrolün odaklanabilirliği** — Godot'ta `disabled` düğmenin odak alıp almadığı doğrulanmadı; almazsa etkisiz yuva `focus_mode = ALL` bir "sahte etkisiz" kontrol olarak çizilir. Sahibi: ui-programmer. Hedef: ilk uygulama.
5. **Ayarlar'daki "iki adımlı onay"** — Sanat kitabı 7.9 ayar olarak sayıyor, 7.10 kısayolları zorunlu kılıyor; bu belge ikisini uzlaştırdı (kural 15). Kullanıcının onayına açık.
6. **Sistem dizini** — 3'ün bağımlılıklar sütununa 2 eklenmeli.
