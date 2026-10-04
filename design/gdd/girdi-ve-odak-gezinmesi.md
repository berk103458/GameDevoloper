# Girdi ve odak gezinmesi

> **Status**: Designed (pending review)
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
| `geri` | Seçimi iptal et, seçim yoksa duraklatma iste / menüyü kapat | Esc | Sağ tık yalnız *seçimi iptal eder*, menü açmaz | B |
| `kisayol_1` … `kisayol_4` | Karar panelinde 1–4. yuvayı seç | 1 2 3 4 | — | — (MVP'de yok) |
| `menu` | Duraklatma menüsünü aç/kapat (seçimden bağımsız) | P | — | Start |

Esc yalnız `geri`ye bağlıdır; `menu`ye bağlanmaz. Böylece seçim varken Esc'e basmak aynı anda hem seçimi kaldırıp hem duraklatma istemez.

2. **Esc iki iş yapar, "ret" yapmaz.** `geri` seçim varsa seçimi iptal eder (Karar iki adımlı onayın ilk adımına döner); seçim yoksa duraklatma ister (`menu` ile aynı). Hiçbir eylem, hiçbir bağlamda, kendi başına bir kararı (kabul / ret / rüşvet / kışla) vermez. Sanat kitabı 7.10.
3. **Gamepad yüz tuşu kısayolu MVP'de yoktur.** A `onayla`, B `geri` olduğu için dört yuvaya dört yüz tuşu verilemez; gamepad ile karar odak + A ile verilir. X/Y ya da başka bir düzenle kısayol eklemek Açık Soru 2'dir.
4. **Yeniden atama.** Her eylem klavye ve gamepad için ayrı ayrı yeniden atanabilir. Bu sistem eylem listesini, varsayılanları ve doğrulamayı tutar; arayüzü Ayarlar (17) çizer. Kurallar: her eylemin her aygıt ailesinde (klavye+fare / gamepad) en az 1 bağı olur; aynı bağlamda iki eyleme aynı tuş atanamaz (reddedilir, bağ değişmez); "varsayılana dön" her zaman çalışır. Atamalar Ayarlar dosyasında saklanır (17), kayıtta (16) değil.

**Odak**

5. **Tek odak.** Bir ekranda aynı anda en çok bir kontrol odaklıdır ve odak çerçevesi (≥ 3 px kül çerçeve, sanat kitabı 7.3) yalnız onda görünür. Godot'un fare üzerine gelme durumu ile klavye/gamepad odağının ayrı olması (4.6) bu davranışı bozmamalıdır: tema, üzerine gelme (`hover`) görünümünü *normal* ile aynı tutar; çerçeveyi yalnız `focus` görünümü çizer.
6. **Son girişin kazandığı mod.** Sistem `girdi_modu` tutar: `fare` ya da `klavye_gamepad`. Mod yalnız *gerçek* bir giriş olayı gelince değişir; ne sayılacağının **tek kaynağı Formüller F1'dir** (olay tabanlı; eylemin adı önemli değildir). Fare moduna geçmek odağı hemen değiştirmez; odak fare bir kontrolün üzerine gelene dek aynı kontrolde kalır.
7. **Klavye/gamepad modunda** fare konumu odağı değiştirmez (fare titremesi, ekranda kalmış fare). Fare tıklaması her zaman fare moduna geçirir ve tıklanan kontrolü etkinleştirir.
8. **Fare modunda** fare bir odaklanabilir kontrolün üzerine girince o kontrol odak alır (`mouse_entered` → `grab_focus`). Fare hiçbir kontrolün üzerinde değilse odak son odaklanan kontrolde kalır; odak kimsede olmaz denilen bir an oluşmaz.
9. **Odak sırası görsel sırayı izler.** Sohbet listesinde yukarı/aşağı, karar yuvalarında sol/sağ. Her ekran `focus_neighbor_*` komşularını açıkça tanımlar; Godot'un otomatik komşu seçimine güvenilmez. Gezinme barlara (HUD) ya da menüye *atlamaz*; bunlar yalnız `menu` ya da fare ile erişilir. (HUD yalnız gösterir; odaklanamaz.)
10. **Liste sarması.** Listenin son öğesinde aşağı → ilk öğe, ilkinde yukarı → son öğe. Bir tuşa *basılı tutarken* otomatik tekrar sararken durur (listenin ucunda kalır); sarma yeni bir basışla olur. Böylece basılı tutmak odağı döndürüp oyuncuyu şaşırtmaz.
11. **Kareye bir hareket, bir etkinleştirme.** İki işlenme karesi arasında birden çok gezinme eylemi gelirse yalnız geliş sırasındaki ilki işlenir; etkinleştirmeler (`onayla`, `kisayol_N`, tık) için de aynı. *Mod* (F1) ise her olayda güncellenir, yani aynı karede son gelen olayın modu kalır: yön için ilk, mod için son.
12. **Varsayılan odak.** Her ekran/panel açılırken bir "varsayılan odak" kontrolü bildirir. Karar panelinde bu ilk yuvadır. Sohbet listesinde ilk *görünür* seçenektir (kural 17).
13. **Odak kaybolmaz.** Odaklı kontrol silinir, gizlenir ya da etkisiz kılınırsa odak ekranın varsayılan odağına, o da yoksa bağlamdaki ilk odaklanabilir kontrole gider. Hiçbiri yoksa geliştirme hatası kaydedilir; oyun takılmaz (fare yine çalışır).
14. **Etkisiz (kullanılamaz) kontrol** odaklanabilir kalır ama etkinleştirilemez (sanat kitabı 7.3: boş kese + kesik çerçeve). `onayla` ona gelirse hiçbir şey olmaz ve "etkisiz etkinleştirme" bildirilir (ses/geri bildirimi 18 ve 22'ye ait). Kontrolün hiç gösterilmemesi bir oyun tasarımı kararıdır, bu sistemin değil.

**İki adımlı onay (yalnız karar bağlamı)**

15. **Karar iki adımda verilir.** Karar yuvasının ilk etkinleştirilişi (fareyle tıklama, `onayla` ya da `kisayol_N`) yuvayı **seçili / onaya hazır** yapar (sanat kitabı 7.3: tam ters çevirme); aynı yuvanın ikinci etkinleştirilişi kararı verir. İkinci adım, seçimi hangi yolla yapılmış olursa olsun o yuvanın *herhangi* bir etkinleştirilişidir: `kisayol_2` ile seçilmiş yuvaya `onayla`, fare tıklaması ya da yeniden `kisayol_2` kararı verir. Başka bir yuva etkinleştirilirse seçim ona geçer, karar verilmez. `geri` (ya da sağ tık) seçimi kaldırır. Ayarlar'daki "iki adımlı onay" kapatılırsa fare/`onayla` ile tek adımda verilir; **kısayollar (`kisayol_N`) her durumda iki adımlıdır** (7.10). Karar *panelinde* gezinmek (yön eylemleri) seçimi bozmaz ve karar vermez.
16. **Sohbet seçenekleri tek adımdır.** Sohbet bir sonraki cümleyi seçer, geri dönüşü olmayan bir köy kararı değildir; iki adımlı onay yalnız karar bağlamına uygulanır.
17. **Belirme sırasında.** Seçenekler tek tek belirir (Sohbet ve karar arayüzü 18, "seçenek belirme hızı"). Odak yalnız belirmiş seçeneklere gelir; belirmemiş seçenek odaklanamaz ve `kisayol_N` onu seçemez. Belirme sürerken odak daima belirmiş seçeneklerden birindedir (açılışta ilk belirmiş seçenek, kural 12). Belirme bitmeden `onayla` basılırsa — odak hangi belirmiş seçenekte olursa olsun — bu bir *atlama* isteğidir: kalan seçenekler hemen belirir, hiçbir seçenek etkinleşmez. Belirmemiş seçeneğe yönelen `kisayol_N` bir *boş basış*tır: hiçbir şey olmaz, birikmez; tuş yine "basıldı" sayıldığı için kural 19'daki *yutma* ile karıştırılmamalıdır.

**Bağlamlar ve girişin yutulması**

18. **Girdi bağlamı yığını.** Her ekran bir bağlam açar (örn. *Sohbet*, *Karar*, *Duraklatma*, *Ayarlar*, *Menü*, *Son ekranı*) ve kapanınca bırakır. Eylemler yalnız en üstteki bağlama gider; alttaki bağlamlar odak ve giriş almaz. Duraklatma menüsü açıkken oyun sahnesi giriş almaz.
19. **Giriş yutma.** Yeni bir bağlam açıldığı anda *basılı olan* eylemler yutulur: o basış, tuş bırakılana dek yeni bağlamda "basıldı" sayılmaz. (Bir ekrandaki `onayla`nın, hemen açılan sonraki ekranın ilk yuvasını etkinleştirmesi önlenir.) Fare düğmesi için de aynıdır.
20. **Giriş kilidi.** Oyun durumu (1) *Perde geçişi*, *Oturum sonu* ve *Gece sonu* çözümü gibi girişin anlamsız olduğu anlarda bağlam yığınına bir *kilit* bağlamı koyar; eylemler hiçbir yere gitmez. Kilit kalkınca kural 19 uygulanır.
21. **Duraklatma isteği bu sistemden çıkar, kararı vermez.** İstek her zaman hemen gönderilir; bekletme bu sistemde değil, Oyun durumu'ndadır. `menu` (ya da seçim yokken `geri`) Oyun durumu'na "duraklat" ister. İsteği kabul/ret ve erteleme Oyun durumu'na aittir (GDD 1: *Perde geçişi*/*Oturum sonu*'nda yok sayılır, *Gece sonu* çözümünde bekletilir). Duraklatma bağlamı açıkken `menu` / `geri` menüyü kapatır ve "devam" ister.

**İpucu glifleri**

22. **İpucu seti.** `ipucu_seti` ∈ {`klavye`, `gamepad`}: F1'deki `klavye_moduna_gec` olayını üreten aygıt belirler (klavye olayı → `klavye`, gamepad olayı → `gamepad`, aynı eşikler). Fare olayları `ipucu_seti`ni değiştirmez. Arayüz bir eylemin ipucunu `ipucu(eylem)` ile ister; dönen değer o setteki *güncel* bağın (yeniden atanmış olsa bile) etiketidir. Etiket metinleri çeviri anahtarlarıdır (`arayuz.girdi.tus.<ad>`), glif çizimi sanat kitabı 7.10'a göre kül renktedir.

**Kapsam dışı (bilinçli)**: dokunmatik, fare tekerleği ile gezinme, birden çok oyuncu, fare ile sürükle-bırak, kayan imleç ivmesi.

### States and Transitions

Sistemin üç bağımsız durum alanı vardır.

| Alan | Değerler | Değişim |
|---|---|---|
| `girdi_modu` | `fare`, `klavye_gamepad` | F1: `fare_moduna_gec` → `fare`; `klavye_moduna_gec` → `klavye_gamepad` |
| `ipucu_seti` | `klavye`, `gamepad` | F1 `klavye_moduna_gec` klavye olayıyla → `klavye`, gamepad olayıyla → `gamepad`; gamepad çıkarsa → `klavye`; fare değiştirmez |
| Karar seçimi (yalnız karar bağlamı) | `bos`, `secili(yuva)` | `bos` + etkinleştirme → `secili(yuva)`; `secili(a)` + etkinleştirme a → karar verilir, `bos`; `secili(a)` + etkinleştirme b → `secili(b)`; `geri`/sağ tık/panel kapanması → `bos` |

Başlangıç (ilk bağlam — *Menü* — açıldığı anda): `girdi_modu = klavye_gamepad` (ekranda hareket etmemiş fare yanlışlıkla mod değiştirmesin), `ipucu_seti = klavye`, seçim `bos`. Bağlam yığını boştur; *Menü* açılırken ilk bağlam konur.

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

Süre, test edilebilirlik için enjekte edilen bir saatten okunur (gerçek saat değil).

**Output Range:** 0 – sınırsız tamsayı; ilk basışın kendi hareketi bu sayıya dahil değildir, listenin ucuna varınca fazla tekrarlar yok sayılır (kural 10). Başlangıç: `TEKRAR_GECIKMESI = 400`, `TEKRAR_ARALIGI = 120`.
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
- **If aynı karede `kisayol_2` ve `onayla` gelirse**: geliş sırasındaki ilki işlenir (kural 11).
- **If iki adımlı onay kapalıyken `kisayol_N` basılırsa**: yine iki adımlıdır (kural 15). Ayar yalnız fare/`onayla` için geçerlidir.
- **If `geri` basılır ve seçim yoksa**: duraklatma istenir (kural 2, 21); Oyun durumu *Perde geçişi*/*Oturum sonu*'nda yok sayar (GDD 1).
- **If sağ tıklanır ve seçim yoksa**: hiçbir şey olmaz; menü açılmaz.
- **If etkisiz yuvaya `kisayol_N` ya da `onayla` gelirse**: seçim yapılmaz, mevcut seçim korunur, "etkisiz etkinleştirme" bildirilir.
- **If seçenekler henüz belirmediyse `kisayol_N` basılırsa**: *boş basış*tır (kural 17): hiçbir şey olmaz, birikmez; belirme bitince tekrar basılması gerekir.

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

> **Gözlem noktaları:** Testler sentetik olay verir ve şunları okur: `girdi_modu`, `ipucu_seti`, odak sahibi (`get_viewport().gui_get_focus_owner()`), karar seçimi, yayınlanan sinyaller (`karar_verildi`, `secildi`, `duraklat_istendi`, `devam_istendi`, `etkisiz_etkinlestirme`), geliştirme hatası sayacı.
> **Test donanımı:** "Fixture ekranı" = 4 karar yuvası (4. etkisiz) + 3 öğeli dikey liste. "Bir kare" = `await get_tree().process_frame`; "aynı kare" = iki olay `Input.parse_input_event` ile art arda verilip *sonra* bir kare ilerletilir. Süre, sisteme enjekte edilen sahte saatle ilerletilir (gerçek saat yok, determinizm kuralı). `parse_input_event` ile verilemeyenler: pencere odağı kaybı → `NOTIFICATION_APPLICATION_FOCUS_OUT` elle gönderilir; gamepad takma/çıkarma → `Input.joy_connection_changed` sinyali elle yayınlanır; `mouse_entered` → viewport içinde geçerli `position` taşıyan `InputEventMouseMotion`; oyun durumu kilidi → Oyun durumu stub'u.

**Eylemler ve mod**
- **AC-1 (Logic) Varsayılan eylemler.** **GIVEN** varsayılan atamalar **WHEN** sırayla `Enter`, `Boşluk`, gamepad `A` **THEN** her biri `onayla`. **WHEN** `Esc` **THEN** yalnız `geri` (`menu` değil). **WHEN** `P` ya da `Start` **THEN** `menu`.
- **AC-2 (Logic, CI) Ham tuş yok.** **GIVEN** `src/` **WHEN** `tools/ci/girdi_ham_tus_denetimi.sh` `KEY_`, `JOY_BUTTON_`, `MOUSE_BUTTON_`, `.keycode`, `Input.is_key_pressed`, `Input.is_joy_button_pressed`, `Input.is_mouse_button_pressed` desenlerini tarar **THEN** 0 bulgu; tek istisna eşlemeyi kuran `src/girdi/eylem_eslemesi.gd`. Betik çıkış kodu ≠ 0 ise birleştirme yok.
- **AC-3 (Logic) Mod değişimi (F1).** **GIVEN** `klavye_gamepad` **WHEN** fare relative (1,1) **THEN** mod değişmez; **WHEN** (5,0) **THEN** `fare`; **WHEN** ok tuşu **THEN** `klavye_gamepad`. **GIVEN** `fare` **WHEN** çubuk 0.3 **THEN** değişmez; **WHEN** 0.8 **THEN** `klavye_gamepad`.
- **AC-4 (Logic) Başlangıç.** **GIVEN** yeni oturum **WHEN** *Menü* bağlamı açılır **THEN** `girdi_modu = klavye_gamepad`, `ipucu_seti = klavye`, seçim `bos`.
- **AC-5 (Logic) Aynı karede mod son, yön ilk.** **GIVEN** odak listede 2. öğe, `klavye_gamepad` **WHEN** aynı karede `gezin_asagi`, `gezin_yukari`, fare relative (6,0) **THEN** odak 3. öğe (yalnız ilk yön), `girdi_modu = fare`.

**Odak**
- **AC-6 (Logic) Tek odak.** **GIVEN** fixture ekranı, `fare` **WHEN** fare 2. yuvanın içinde konumlu harekette **THEN** odak sahibi 2. yuva; `has_focus()` true olan kontrol sayısı = 1; temadaki `hover` StyleBox kaynağı `normal` ile aynıdır. **WHEN** `gezin_sag` **THEN** odak 3. yuva, sayı yine 1.
- **AC-7 (Logic) Klavye modunda fare odak çalmaz.** **GIVEN** `klavye_gamepad`, odak 1. yuvada, fare 3. yuvanın üstünde konumlu **WHEN** relative (1,0) hareket **THEN** odak 1. yuvada, mod değişmez.
- **AC-8 (Logic) Klavye modunda tık.** **GIVEN** `klavye_gamepad`, odak listede 1. öğe **WHEN** 2. öğeye sol tık (bas + bırak) **THEN** `girdi_modu = fare`, odak 2. öğe, `secildi(2)` bir kez.
- **AC-9 (Logic) Fare boşlukta.** **GIVEN** `fare`, odak 2. yuva **WHEN** fare hiçbir kontrolün üstünde olmayan bir konuma gider **THEN** odak 2. yuvada kalır.
- **AC-10 (Logic, CI) Komşular açık.** **GIVEN** projedeki her ekran sahnesi **WHEN** tarama betiği odaklanabilir (`focus_mode != NONE`) her kontrolün dört `focus_neighbor_*` alanını okur **THEN** boş (otomatik komşuya bırakılmış) alan sayısı 0; komşular aynı bağlamın dışına (HUD, menü) işaret etmez.
- **AC-11 (Logic) Varsayılan odak.** **GIVEN** karar paneli açılır **THEN** bir kare sonra odak 1. yuvada. **GIVEN** sohbet listesi 3 seçenekten yalnız 1'i belirmiş açılır **THEN** odak o belirmiş seçenekte.
- **AC-12 (Logic) Sarma ve basılı tekrar.** **GIVEN** 3 öğeli liste, odak 3. öğe **WHEN** `gezin_asagi` bas-bırak **THEN** odak 1. öğe. **GIVEN** odak 1. öğe, `TEKRAR_GECIKMESI = 400`, `TEKRAR_ARALIGI = 120` **WHEN** `gezin_asagi` basılır ve sahte saat 640 ms ilerletilir **THEN** ilk basış 1→2, tekrarlar 2→3 ve sonra durur; son odak 3. öğe, sarmadı (F2: 3 tekrar, 2'si uçta yok sayıldı).
- **AC-13 (Logic) Tek öğeli liste.** **GIVEN** tek öğeli liste **WHEN** dört yön **THEN** odak aynı öğede, 0 hata.
- **AC-14 (Logic) Odak kaybolmaz.** **GIVEN** odak sahibi gizlenir **WHEN** bir kare **THEN** odak varsayılan odakta. **GIVEN** varsayılan da gizli **THEN** bağlamdaki ilk odaklanabilir kontrolde. **GIVEN** hiç yok **THEN** odak sahibi `null`, 1 geliştirme hatası, çökme yok.
- **AC-15 (Logic) HUD ve menüye geçmez.** **GIVEN** odak son yuvada **WHEN** `gezin_sag` **THEN** odak 1. yuva. **WHEN** her yönde 10 basış **THEN** odak hiçbir zaman HUD kontrolüne ya da başka bağlama geçmez.
- **AC-16 (Logic) Etkisiz yuva odak alır.** **GIVEN** odak 3. yuva **WHEN** `gezin_sag` **THEN** odak 4. (etkisiz) yuvada.

**İki adımlı onay**
- **AC-17 (Logic) Temel iki adım.** **GIVEN** seçim `bos`, ayar açık **WHEN** 1. yuvada `onayla` **THEN** `secili(1)`, `karar_verildi` yok. **WHEN** tekrar `onayla` **THEN** `karar_verildi(1)` tam bir kez, seçim `bos`.
- **AC-18 (Logic) Fareyle iki adım.** **GIVEN** ayar açık **WHEN** 2. yuvaya tık **THEN** `secili(2)`; **WHEN** 2. yuvaya ikinci tık **THEN** `karar_verildi(2)`.
- **AC-19 (Logic) Karışık ikinci adım.** **GIVEN** `kisayol_2` ile `secili(2)` **WHEN** odak 2. yuvada `onayla` **THEN** `karar_verildi(2)`. **GIVEN** `onayla` ile `secili(3)` **WHEN** `kisayol_3` **THEN** `karar_verildi(3)`.
- **AC-20 (Logic) Değiştirme ve iptal.** **GIVEN** `secili(1)` **WHEN** 2. yuvada `onayla` **THEN** `secili(2)`, karar yok. **WHEN** `Esc` **THEN** seçim `bos`, karar yok, `duraklat_istendi` yok.
- **AC-21 (Logic) Seçim yokken geri.** **GIVEN** seçim `bos` **WHEN** `Esc` ya da `B` **THEN** `duraklat_istendi` tam bir kez, karar yok.
- **AC-22 (Logic) Sağ tık.** **GIVEN** `secili(1)` **WHEN** sağ tık **THEN** seçim `bos`. **GIVEN** `bos` **WHEN** sağ tık **THEN** hiçbir sinyal yok.
- **AC-23 (Logic) Ayar kapalı.** **GIVEN** ayar kapalı **WHEN** 1. yuvaya tek tık **THEN** `karar_verildi(1)`. **WHEN** (yeni panelde) 1. yuvada tek `onayla` **THEN** `karar_verildi(1)`. **WHEN** `kisayol_2` bir kez **THEN** `secili(2)`, karar yok; ikinci `kisayol_2` **THEN** `karar_verildi(2)`.
- **AC-24 (Logic) Gezinme seçimi bozmaz.** **GIVEN** `secili(1)` **WHEN** `gezin_sag` iki kez **THEN** seçim `secili(1)`, odak 3. yuva, karar yok.
- **AC-25 (Logic) Panel kapanınca.** **GIVEN** `secili(2)` **WHEN** panel kapanır ve yeniden açılır **THEN** seçim `bos`, karar verilmemiş.
- **AC-26 (Logic) Etkisiz yuva etkinleşmez.** **GIVEN** `secili(1)` **WHEN** 4. yuvada `onayla`, sonra `kisayol_4` **THEN** seçim `secili(1)`, `etkisiz_etkinlestirme` iki kez, karar yok.
- **AC-27 (Logic) Aynı karede kısayol + onay.** **GIVEN** `bos`, odak 1. yuva **WHEN** aynı karede `kisayol_2` sonra `onayla` **THEN** `secili(2)`, `onayla` yok sayıldı, karar yok.

**Sohbet ve belirme**
- **AC-28 (Logic) Sohbet tek adım.** **GIVEN** sohbet bağlamı, tüm seçenekler belirmiş **WHEN** 2. seçenekte `onayla` **THEN** `secildi(2)` tam bir kez.
- **AC-29 (Logic) Belirme sırasında.** **GIVEN** 3 seçenekten 1'i belirmiş **WHEN** `kisayol_3` **THEN** hiçbir sinyal, durum değişmez. **WHEN** `onayla` **THEN** bir kare sonra 3 seçenek de belirmiş, `secildi` yok.

**Bağlamlar, yutma, kilit**
- **AC-30 (Logic) Klavye yutma.** **GIVEN** *Sohbet*'te `onayla` basılı **WHEN** *Karar* bağlamı açılır, tuş basılı kalır, 3 kare ilerler **THEN** 0 etkinleştirme. **WHEN** bırakılıp yeniden basılır **THEN** 1 etkinleştirme.
- **AC-31 (Logic) Fare yutma.** **GIVEN** sol fare düğmesi basılı **WHEN** yeni bağlam açılır ve düğme yeni bağlamın 1. yuvası üstünde bırakılır **THEN** 0 etkinleştirme.
- **AC-32 (Logic) Yığın.** **GIVEN** *Karar* üstünde *Duraklatma* **WHEN** `onayla` **THEN** yalnız duraklatma menüsü tepki verir, karar paneli 0 olay. **WHEN** `P` **THEN** `devam_istendi` tam bir kez.
- **AC-33 (Logic) Aynı karede iki bağlam.** **WHEN** aynı karede A sonra B bağlamı açılır **THEN** `onayla` yalnız B'ye gider.
- **AC-34 (Logic) Boş yığın.** **GIVEN** yığın boş **WHEN** `onayla` **THEN** hiçbir sinyal, 1 geliştirme hatası.
- **AC-35 (Logic) Kilit.** Oyun durumu stub'u sırayla *Perde geçişi*, *Oturum sonu*, *Gece sonu* çözümü için kilit koyar. **GIVEN** her biri **WHEN** `onayla`, `kisayol_1`, `gezin_sag` **THEN** 0 sinyal ve odak değişmez; **WHEN** kilit kalkar ve 1 kare geçer **THEN** yine 0 sinyal (birikme yok).
- **AC-36 (Logic) Kilitte duraklatma isteği.** **GIVEN** kilit **WHEN** `P` **THEN** `duraklat_istendi` Oyun durumu stub'una tam bir kez ulaşır (kabul/ret Oyun durumu'nun işi, GDD 1 AC-39).

**İpucu ve aygıtlar**
- **AC-37 (Logic) İpucu seti ve etiket.** **GIVEN** gamepad `A` basıldı **WHEN** `ipucu(&"onayla")` **THEN** anahtar `arayuz.girdi.tus.gamepad_a`, `tr()` değeri boş değil. **WHEN** sonra `Enter` **THEN** anahtar `arayuz.girdi.tus.enter`. **GIVEN** `onayla` klavyede yalnız Boşluk'a atanmış **THEN** anahtar `arayuz.girdi.tus.bosluk`.
- **AC-38 (Logic) Fare ipucu setini değiştirmez.** **GIVEN** `ipucu_seti = gamepad` **WHEN** fare relative (10,0) ve sol tık **THEN** `ipucu_seti = gamepad`, `girdi_modu = fare`.
- **AC-39 (Logic) Gamepad çıkarılır.** **GIVEN** `ipucu_seti = gamepad` **WHEN** `joy_connection_changed(0, false)` **THEN** `ipucu_seti = klavye`, `duraklat_istendi` yok, oyun durumu stub'u değişmedi.
- **AC-40 (Logic) İki gamepad.** **GIVEN** cihaz 0 ve 1 bağlı **WHEN** cihaz 1'den `A` **THEN** `onayla` işlenir; **WHEN** cihaz 0'dan `B` **THEN** `geri` işlenir.
- **AC-41 (Logic) Pencere odağı kaybı.** **GIVEN** `gezin_asagi` basılı ve tekrar ediyor, odak 1. öğe **WHEN** `NOTIFICATION_APPLICATION_FOCUS_OUT`, sonra sahte saat 500 ms **THEN** 0 yeni odak hareketi; seçim değişmez.

**Yeniden atama**
- **AC-42 (Logic) Çakışma.** **GIVEN** `onayla` = Enter **WHEN** `gezin_sag` Enter'a atanmak istenir **THEN** reddedilir, iki bağ değişmez, dönen değer `&"onayla"`.
- **AC-43 (Logic) Son bağ.** **WHEN** `onayla`nın klavyedeki tüm bağları silinmek istenir **THEN** son silme reddedilir. **WHEN** gamepad'deki son bağ (`A`) silinmek istenir **THEN** reddedilir.
- **AC-44 (Logic) Kısayol gamepad'e atanamaz.** **WHEN** `kisayol_1` gamepad `X`'e atanmak istenir **THEN** reddedilir.
- **AC-45 (Logic) Varsayılana dönüş.** **GIVEN** birkaç atama değişmiş **WHEN** varsayılana dön **THEN** AC-1 geçer.
- **AC-46 (Logic) Bozuk atama dosyası.** **GIVEN** dosyada bilinmeyen eylem `ucus` ve geçersiz tuş kodu **WHEN** yüklenir **THEN** o iki satır atlanır, diğerleri uygulanır, eksik eylemler varsayılan, 1 geliştirme hatası, oyun açılır.

**Görsel ve tepki**
- **AC-47 (Logic) Aynı karede tepki.** **GIVEN** odak 1. yuva **WHEN** `gezin_sag` verilip bir kare ilerletilir **THEN** odak sahibi 2. yuva (tepki ≤ 1 kare).
- **AC-48 (UI) Odak ve seçim görünümü.** **GIVEN** Godot 4.7.2'de karar ekranı **WHEN** (a) fare modunda fare 2. yuvada, (b) klavye modunda fare 1. yuvanın üstünde dururken odak `gezin_sag` ile 2. yuvaya, (c) `secili(2)` **THEN** (a) ve (b)'de ekranda tek ≥ 3 px kül çerçeve, hover çerçevesi yok; (c)'de tam ters çevirme (sanat kitabı 7.3). Üç ekran görüntüsü `production/qa/evidence/` altında saklanır; bu, Açık Soru 1'in kanıtıdır.

## Open Questions

1. **4.7 odak davranışı** — "hover stili normal ile aynı + `mouse_entered → grab_focus`" yaklaşımının 4.7.2'de tek çerçeve verdiği küçük bir sahneyle doğrulanmadı (`core.md`/giriş referansı 4.6'ya göre; cihaz kimlikleri 4.7'de değişti). Sahibi: Kullanıcı / ui-programmer. Hedef: ilk girdi hikâyesi.
2. **Gamepad ile karar kısayolu** — X/Y ve D-pad bölümleri MVP'de bağlanmadı (B = `geri`, A = `onayla`). Gerekirse sonra eklenir (iki adımlı onayla). Sahibi: Kullanıcı. Hedef: Vertical Slice.
3. **Gamepad ipucu glifleri** — tek genel set mi, Xbox/PlayStation ayrımı mı? Sanat kitabı yalnız "gamepad" diyor. Sahibi: art-director. Hedef: Vertical Slice.
4. **Etkisiz kontrolün odaklanabilirliği** — Godot'ta `disabled` düğmenin odak alıp almadığı doğrulanmadı; almazsa etkisiz yuva `focus_mode = ALL` bir "sahte etkisiz" kontrol olarak çizilir. Sahibi: ui-programmer. Hedef: ilk uygulama.
5. **Ayarlar'daki "iki adımlı onay"** — Sanat kitabı 7.9 ayar olarak sayıyor, 7.10 kısayolları zorunlu kılıyor; bu belge ikisini uzlaştırdı (kural 15). Kullanıcının onayına açık.
6. **Sistem dizini** — 3'ün bağımlılıklar sütununa 2 eklendi (4 Ekim 2026).
