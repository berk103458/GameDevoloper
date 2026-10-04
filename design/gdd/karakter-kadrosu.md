# Karakter kadrosu

> **Status**: Designed (pending review)
> **Author**: Kullanıcı + ajanlar
> **Last Updated**: 2026-10-04
> **Last Verified**: 2026-10-04
> **Implements Pillar**: 1243 (dönem ve ton); kartta iyi/kötü etiketi yok

## Summary

Karakter kadrosu kapıya kimlerin gelebileceğini tanımlar: altı adlı karakter (üç uzak yabancı, üç yerli) ve geceleri dolduran adsız sınıf figürleri. Her adlı karakterin bir sınıfı, ona özel karar seçenekleri ve tek bir dönüş kuralı vardır (hiç dönmez / olasılıkla döner / birden çok gelir). Sistem kimin *gelebileceğini* ve karakterin oturum boyunca neler yaşadığını tutar; o gece kimin geleceğini Varış kuyruğu, ne konuşulacağını Sohbet, kararın sonucunu Karar belirler.

> **Quick reference** — Layer: `Core` · Priority: `MVP` · Category: `Gameplay` · Key deps: `İçerik veri hattı (2)`

## Overview

Kapı oyununun ağırlığı, gelen kişinin bir *kişi* olmasından gelir: oyuncu bir kartı değil, adı, yükü ve bir sırrı olan birini içeri alır ya da geri çevirir. Bu sistem o kişileri tanımlar. Demo kadrosu kasıtlı olarak küçüktür (6 adlı karakter); adlı karakterler hikâyeyi taşır, araya giren adsız figürler (yorgun çiftçi, yaralı asker, Ahi çırağı…) köyün nüfusunu ve gecelerin ritmini sağlar. Dönüş kuralları, kapıda verilen kararın kesin mi yoksa geri alınabilir mi hissettireceğini belirler: Miraen'i geri çevirmek bir son, Thessra'yı geri çevirmek belki bir erteleme, Sorhan'ı ise her gelişinde yeniden tartmaktır. Kimse iyi ya da kötü diye etiketlenmez ve kimse seçeneğin sonucunu söylemez (konsept kilidi).

## Detailed Design

### Core Rules

**Kadro**

1. **Altı adlı karakter (MVP).** Adlar ve geçmişler tasarım taslağıdır; kullanıcı değiştirebilir. Görünüm sanat kitabı 5.4'e uyar.

| id | Ad | Köken | Sınıf (kabul edilince) | Geçmiş | Kapıya getirdiği (gizli olan) | Dönüş kuralı |
|---|---|---|---|---|---|---|
| `miraen` | Miraen | Gürcü (yabancı) | asker | Selçuklu hizmetinde atlı; Kösedağ bozgunundan atsız döndü | Kırık bir kın — birliğini bırakıp kaçtı | `hic_donmez` |
| `sorhan` | Sorhan | Kıpçak (yabancı) | esnaf | Ailesi sürgün; at sürüsüyle uçtan uca gider | Üç at — ikisinde yabancı damga var, nereden geldiği söylenmez | `birden_cok_gelir` (3): atlarla, ailesiyle, yalnız |
| `thessra` | Thessra | Trabzonlu Rum (yabancı) | esnaf | Hekim kızı; babası yolda öldü, bildiğini ondan öğrendi | İlaç kutusu — içinde afyon: hem ağrı kesici hem ticaret malı | `oranla_doner` |
| `karaca_usta` | Karaca Usta | Kayserili (yerel) | esnaf (Ahi) | Tabakhanesi yandı; şeddini bağlamış gelir | İki çırak — Ahi ocağına borcu var | `oranla_doner` |
| `aydogdu` | Aydoğdu | Türkmen (yerel) | asker | Kösedağ'dan yaralı dönen okçu | Yay ve sadak — arkada yirmi kişilik obası bekliyor | `hic_donmez` |
| `saruca_hatun` | Saruca Hatun | Sivas yöresi (yerel) | çiftçi | Dul, yanında bir çocuk | Tohumluk buğday — ekilmez de yenirse kıştan çıkmaz | `birden_cok_gelir` (2): çocukla, sonra tohumla |

2. **Karar seçenekleri karaktere göredir.** Her karakter kendi seçenek listesini taşır (`karar_secenekleri`). Varsayılan küme {kabul, ret, rüşvet, kışla}; bir karakter bu kümeden bir altküme alabilir (ör. Miraen'de rüşvet yok — verecek parası yok). Ek, karaktere özel seçenekler (Sorhan'ın "at takası", Karaca'nın "yalnız ustayı al", Saruca'nın ikinci gelişte "tohumu al, onu değil") anlatı önerisidir; eklenip eklenmeyeceğine ve sonuçlarına **Karar (7)** karar verir. Bu sistem yalnız listeyi taşır.
3. **İyi/kötü etiketi yok.** Hiçbir veri alanı karakterin "güvenilir", "tehlikeli", "iyi" ya da "kötü" olduğunu söylemez. Gizli olan (sır) yalnız sohbette ortaya çıkabilir ve hüküm taşımaz.
4. **Hassasiyet kuralları (yazım ve çizim).** Rum köken Tekfur'a bağlanmaz; din işareti (haç, sarık) güven ya da tehdit ipucu değildir; Kıpçak karakterin gizlisi insan değil at olarak kalır; yerli karakterler de borç, eksik bilgi ve bencillik taşır ("yerli = iyi" çizgisi yok); kadın karakterler bilgi ve pazarlık gücü taşır, yalnız acı çeken değildir; Osmanlı dönemi adı ve dönem dışı yer adı yok.

**Adsız sınıf figürleri**

5. **Sınıf şablonu.** Her sınıfın (asker, esnaf, çiftçi) tam bir şablonu vardır: ad havuzu (≥ 3 ad anahtarı), sohbet kimliği ve karar seçenekleri. Önerilen başlangıç şablon durumları:

| Şablon ad örneği | Sınıf | Durum (tek satır) |
|---|---|---|
| "[köy]li yorgun çiftçi" | çiftçi | Öküzü yolda ölmüş, boyunduruğu sırtında taşıyor |
| "Irgat kadın [ad] Hatun" | çiftçi | Kocası tarlada kalmış; hasat işi istiyor |
| "Yaralı [Türkmen/sipahi] asker" | asker | Sargısı kirli; kimin adamı olduğunu söylemiyor |
| "Firari [ad]" | asker | Kimden kaçtığı belirsiz |
| "Ahi çırağı [ad]" | esnaf | Ustasını yolda kaybetmiş, alet torbası elinde |
| "Seyyar [bakırcı/keçeci]" | esnaf | Malı az, borcu çok; kervansarayı soruyor |

  Bir sınıfta birden çok durum satırı varsa her biri ayrı bir sohbet çeşidi olarak Sohbet (6) belgesinde yazılır; şablon sayısı sınıf başına 1'dir, çeşit sayısı serbesttir.
6. **Figür örneği.** Varış kuyruğu (4) bir şablon ister; bu sistem bir *figür örneği* döner: şablon, sınıf ve havuzdan seed'li RNG ile çekilmiş bir ad. Aynı gece içinde aynı ad iki kez çekilmez.
7. **Figürler iz bırakmaz.** Figür örneği o gece biter, dönmez, kayda geçmez. Kabul edilen figürün kalıcı izi yalnız Köy nüfusu'ndaki (10) sayıdır.

**Karakter durumu ve dönüş**

8. **Çalışma durumu.** Her adlı karakter için oturum boyunca şunlar tutulur ve Kaydet / yükle (16) tarafından `id` ile saklanır: `durum`, `ziyaret_sayisi`, `son_ziyaret_gecesi`, `son_karar`, `en_erken_donus_gecesi`.
9. **"Kaldı / gitti" sözleşmesi.** Karar (7) bir ziyaretin sonunda bu sisteme iki sonuçtan birini bildirir: **kaldı** (karakter köye/kışlaya geçti) ya da **gitti** (karakter kapıdan ayrıldı). Hangi düğmenin (kabul, ret, rüşvet, kışla, karaktere özel seçenekler) hangi sonuca düştüğünü 7 belirler. "Kaldı" → durum `koyde`; dönüş kuralı bir daha çalışmaz.
10. **Dönüş kuralı yalnız "gitti"de çalışır** ve tam olarak bir kez, ziyaretin sonunda:
    - `hic_donmez` → `kalici_ayrildi`. RNG çağrılmaz.
    - `oranla_doner` → önce üst sınır: `ziyaret_sayisi ≥ k_azami` ise `kalici_ayrildi` ve zar atılmaz. Değilse F1 ile zar atılır; tutarsa `donebilir` ve F2 ile en erken dönüş gecesi; tutmazsa `kalici_ayrildi`.
    - `birden_cok_gelir` → F3: ziyaret sayısı hedefin altındaysa `donebilir` + F2; değilse `kalici_ayrildi`.
11. **Uygunluk, seçim değil.** Bu sistem kimin *gelebileceğini* söyler; o gece kimin geleceğini Varış kuyruğu (4) seçer. Uygunluk: karakter bu gece henüz istenmemiş **ve** (durum `gelmedi` ve `gece ≥ en_erken_gece`, ya da durum `donebilir` ve `gece ≥ en_erken_donus_gecesi`). 4 bir karakteri istediğinde "bu gece istendi" işareti konur (gece sonunda temizlenir); uygun olmayan bir istek reddedilir.
12. **Ziyaret sayılır.** 4 bir karakteri o gecenin listesine koyduğunda değil, karakter kapıya *geldiğinde* `ziyaret_sayisi` 1 artar ve `son_ziyaret_gecesi` yazılır. "Ziyaret başladı" bildirimini Sohbet (6) o karakterle sohbeti açtığında gönderir. Bir ziyarete yalnız bir sonuç ("kaldı" ya da "gitti") kabul edilir; ikincisi yok sayılır.
13. **Rastgelelik enjekte ve ayrık.** Bu sistem iki seed'li `RandomNumberGenerator` akışı kullanır, ikisi de oturuma enjekte edilir: *dönüş akışı* (F1, F2) ve *ad akışı* (figür adları). Ayrı tutulur ki bir gecedeki figür sayısı dönüş zarlarını kaydırmasın. Seed'ler ve akış durumları 16 tarafından kaydedilir; aynı kayıttan aynı zarlar çıkar. Testler sahte ya da sabit seed'li RNG kullanır.
14. **Veri.** Adlı karakterler `res://data/karakterler/<id>.tres` (`KarakterVerisi`), şablonlar `res://data/siniflar/<sinif>.tres` (`SinifSablonu`) olarak İçerik veri hattı (2) kurallarıyla durur. Metinler (ad, geçmiş, durum) anahtardır: `karakter.<id>.ad`, `sablon.<sinif>.ad<n>`.

**`KarakterVerisi` alanları**

| Alan | Tip | Zorunlu | Doğrulama |
|---|---|---|---|
| `id` | StringName | E | ASCII snake_case, dosya adı |
| `ad_anahtari` | StringName | E | `karakter.<id>.ad`, tabloda var |
| `koken` | enum {yabanci, yerel} | E | — |
| `sinif` | enum {asker, esnaf, ciftci} | E | Kaldı'da 10'a yazılır |
| `sohbet_id` | StringName | E | Var olan `SohbetVerisi` |
| `karar_secenekleri` | Array[StringName] | E | ≥ 1, tekrarsız, Karar (7)'nin tanıdığı kimlikler |
| `donus_kurali` | enum {hic_donmez, oranla_doner, birden_cok_gelir} | E | — |
| `p0`, `d`, `k_azami` | float, float, int | `oranla_doner` ise | p0 ∈ (0, 1], d ∈ [0, 1], k_azami ∈ [2, 6] |
| `n_ziyaret` | int | `birden_cok_gelir` ise | [2, 6] |
| `g_min`, `g_max` | int | `hic_donmez` değilse | 1 ≤ g_min ≤ g_max ≤ 10 |
| `en_erken_gece` | int | E | ≥ 0 |

Kurala ait olmayan dolu alan uyarıdır, hata değildir. Katalog kuralı (İçerik veri hattı 11): en az 1 adlı karakter ve her sınıf için tam 1 şablon.

**`SinifSablonu` alanları:** `id` (= sınıf adı), `sinif`, `ad_havuzu` (Array[StringName], ≥ 3), `sohbet_id`, `karar_secenekleri` (aynı kural).

### States and Transitions

Adlı karakter başına `durum`:

| Durum | Anlamı | Geçiş |
|---|---|---|
| `gelmedi` | Henüz kapıya gelmedi | 4 seçer ve gelir → ziyaret (durum ziyaret sonunda değişir) |
| `donebilir` | Gitti, dönebilir | `gece ≥ en_erken_donus_gecesi` olunca 4 için uygun |
| `koyde` | Kaldı | Son durum (köyden ayrılma bu sistemin değil, gerekirse 10/13'ün konusu) |
| `kalici_ayrildi` | Gitti ve dönmeyecek | Son durum |

Ziyaret sonu: `kaldı` → `koyde`; `gitti` → kural 10'a göre `donebilir` ya da `kalici_ayrildi`. Ziyaret tamamlanmadan gece biterse (ör. bar kırıldı, oturum sonu) durum ziyaret öncesindeki gibi kalır; `ziyaret_sayisi` artışı da kayda geçmez, çünkü kayıt yalnız gece sonu çözümünde yazılır (GDD 1).

Figür örneklerinin durumu yoktur.

### Interactions with Other Systems

| Sistem | Bu sistemden alır | Bu sisteme verir |
|---|---|---|
| İçerik veri hattı (2) | — | `KarakterVerisi`, `SinifSablonu` kayıtları |
| Oyun durumu (1) | — | Gün sayacı (`gece` değeri) |
| Varış kuyruğu (4) | Uygun adlı karakterler, şablon listesi, figür örneği | "Bu karakter / bu şablon geldi" |
| Sohbet (6) | `sohbet_id`, ziyaret sayısı (kaçıncı gelişi olduğuna göre sohbet seçmek için), ad anahtarı | "Ziyaret başladı" (kural 12) |
| Karar (7) | `karar_secenekleri`, ziyaret sayısı | "kaldı / gitti" + verilen karar (`son_karar`) |
| Köy nüfusu (10) | Kaldı'da sınıf (adlı ya da figür) | — |
| Kaydet / yükle (16) | Karakter durumları, iki RNG akışının seed ve durumu | Yüklemede aynıları |
| Sonlar (15) | Karakter durumları (ör. kimin köyde olduğu) | — |
| Köy görünümü (20) | Köydeki adlı karakterler (imza ile görünürler) | — |

## Formulas

**F1 — Olasılıkla dönüş (`oranla_doner`)**

`p_k = clamp(p0 * d^(k - 1), 0, 1)`
`doner = (k < k_azami) and (rng.randf() < p_k)` — `and` kısa devre yapar: `k ≥ k_azami` ise zar atılmaz.

**Variables:**
| Variable | Type | Range | Source | Description |
|----------|------|-------|--------|-------------|
| `k` | int | 1 – k_azami | calculated | `ziyaret_sayisi` — bu ziyaret dahil, geliş anında artmış değer |
| `p0` | float | (0, 1] | data file | İlk ayrılıştan sonra dönme olasılığı |
| `d` | float | [0, 1] | data file | Her ziyarette olasılığın çarpıldığı azalma oranı |
| `k_azami` | int | 2 – 6 | data file | Kesin ziyaret üst sınırı |
| `rng` | RandomNumberGenerator | — | enjekte | Seed'li, kayıtlı |
| `p_k` | float | 0 – p0 | calculated | O anki dönme olasılığı |

**Output Range:** `p_k` ∈ [0, p0]; `d = 0` ise ikinci dönüş imkânsız. Toplam ziyaret ≤ `k_azami`, sonsuz dönüş yok. Başlangıç değerleri: `p0 = 0.6`, `d = 0.5`, `k_azami = 4`.
**Example:** Thessra 3. gecede ilk kez gider (k = 1): p_1 = 0.6; randf = 0.41 < 0.6 → döner. 2. gidişte p_2 = 0.30, 3.'de p_3 = 0.15, 4. gidişte k = k_azami → zar atılmaz, `kalici_ayrildi`. Beklenen ek ziyaret ≈ 0.6 + 0.6·0.3 + 0.6·0.3·0.15 ≈ 0.81.

**F2 — Dönüş aralığı (`oranla_doner` ve `birden_cok_gelir`)**

`en_erken_donus_gecesi = gece + rng.randi_range(g_min, g_max)`

**Variables:**
| Variable | Type | Range | Source | Description |
|----------|------|-------|--------|-------------|
| `gece` | int | ≥ 0 | Oyun durumu (1) `gun_sayaci` | Ayrılışın gerçekleştiği gecenin sayacı |
| `g_min` | int | 1 – 10 | data file | En kısa bekleme (gece) |
| `g_max` | int | g_min – 10 | data file | En uzun bekleme (gece) |

**Output Range:** [gece + g_min, gece + g_max]. Başlangıç: `g_min = 2`, `g_max = 4`. Bu değer yalnız *en erken* gecedir; o gece gelip gelmeyeceğine 4 karar verir.
**Example:** gece = 3, randi_range(2, 4) = 3 → en erken 6. gece (HUD'da "7. gece", GDD 1 F3).

**F3 — Birden çok geliş (`birden_cok_gelir`)**

`doner = ziyaret_sayisi < n_ziyaret`

**Variables:**
| Variable | Type | Range | Source | Description |
|----------|------|-------|--------|-------------|
| `ziyaret_sayisi` | int | 1 – n_ziyaret | calculated | Bu ziyaret dahil geliş sayısı |
| `n_ziyaret` | int | 2 – 6 | data file | Hedeflenen toplam geliş |

**Output Range:** `bool`; zar yok, yalnız aralık (F2) rastgeledir. Sorhan `n_ziyaret = 3`, Saruca `n_ziyaret = 2`.
**Example:** Sorhan 1. gelişinde gider → 1 < 3 → döner; 3. gelişinde gider → 3 < 3 değil → `kalici_ayrildi`.

## Edge Cases

- **If Karar "kaldı" bildirirse**: durum `koyde`, dönüş kuralı bir daha çalışmaz, sınıf 10'a bildirilir.
- **If `hic_donmez` bir karakter "gitti" alırsa**: `kalici_ayrildi`; RNG çağrılmaz (zar dizisi kaymaz).
- **If `oranla_doner`'de zar tutmazsa ya da `k = k_azami` ise**: `kalici_ayrildi`.
- **If `birden_cok_gelir` bir karakter bir ara gelişte "kaldı" alırsa** (ör. Sorhan 2. gelişte kabul edilir): `koyde`; kalan gelişler olmaz. Sohbet (6) bunun için ayrı bir son gerektirmez.
- **If `karar_secenekleri` boşsa, tekrar içeriyorsa ya da 7'nin tanımadığı bir kimlik taşıyorsa**: doğrulama hatası, katalog *Hatalı* (İçerik veri hattı).
- **If `oranla_doner`'de `p0 = 0` ise**: doğrulama hatası — bu `hic_donmez` demektir, onu kullan.
- **If `birden_cok_gelir`'de `n_ziyaret < 2` ise** ya da **`g_min > g_max` ise**: doğrulama hatası; değer kırpılmaz.
- **If bir sınıfın şablonu yoksa ya da bir sınıfa iki şablon varsa**: doğrulama hatası.
- **If 4 uygun olmayan bir karakteri isterse** (`koyde`, `kalici_ayrildi`, ya da erken): reddedilir, 1 geliştirme hatası, durum değişmez.
- **If 4 aynı karakteri aynı gece iki kez isterse**: ikinci istek reddedilir (ziyaret sırasında karakter uygun değildir).
- **If `en_erken_donus_gecesi` geçer ama 4 karakteri hiç seçmezse**: karakter süresiz `donebilir` kalır; üst sınır gerekip gerekmediğine Varış kuyruğu (4) karar verir (Açık Soru 2).
- **If ziyaret bitmeden gece sona ererse** (bar kırıldı → oturum sonu; ya da duraklat → menü): durum ziyaret öncesine aittir, çünkü kayıt yalnız gece sonu çözümünde yazılır; devam edilince aynı seed aynı zarları üretir.
- **If kayıtta katalogda olmayan bir karakter `id`'si varsa**: kayıt reddedilir, *Menü*'de kalınır; sessiz atlama yok (16 ile tutarlı).
- **If katalogda kayıtta olmayan yeni bir karakter varsa ve `icerik_surumu` aynıysa**: karakter `gelmedi` ile başlar.
- **If ad havuzu o gece tükenirse** (havuzdaki addan çok figür): havuz sıfırlanır, tekrar çekilir; aynı ad iki kez görünebilir, hata değil.
- **If "bu gece istendi" işaretli bir karakter gece sonunda gelmediyse** (ör. kuyruk erken kapandı): işaret temizlenir, durum değişmez, sonraki gece yine uygun olabilir.
- **If iki adlı karakter aynı gece uygunsa**: ikisi de uygundur; kaçının geleceği 4'ün işidir.
- **If oyun yeni oturumla başlarsa**: tüm adlı karakterler `gelmedi`, sayaçlar 0, RNG yeni seed.

## Dependencies

**Yukarı akış (bu sistemin bağlı olduğu):**

| Sistem | Bağ | Arayüz |
|---|---|---|
| İçerik veri hattı (2) | Sert | `KarakterVerisi`, `SinifSablonu`, metin anahtarları |
| Oyun durumu ve gün döngüsü (1) | Sert | `gun_sayaci` (F2'deki `gece`) |

**Aşağı akış (bu sisteme bağlı olanlar):**

| Sistem | Bağ | Arayüz |
|---|---|---|
| Varış kuyruğu (4) | Sert | Uygunluk sorgusu, figür örneği; "geldi" bildirimi |
| Sohbet (6) | Sert | `sohbet_id`, ziyaret sayısı, ad anahtarı; "ziyaret başladı" bildirir |
| Karar (7) | Sert | `karar_secenekleri`; "kaldı / gitti" bildirir |
| Köy nüfusu (10) | Sert | Kaldı'da sınıf |
| Sonlar (15) | Yumuşak | Karakter durumları |
| Kaydet / yükle (16) | Sert | Durumlar, iki RNG akışının seed'i ve durumu |
| Köy görünümü (20) | Yumuşak | Köydeki adlı karakterler |

*Çift yönlü bağımlılık: Sistem dizini 5'i yalnız 2'ye bağlı gösteriyor; 1'e (gün sayacı) de bağlıdır, eklendi. Karar (7) belgesi "kaldı / gitti" sözleşmesini ve her düğmenin hangisine düştüğünü yazmalıdır.*

## Visual/Audio Requirements

*`art-director` danışılmadı — Lean mod; üretimden önce elle gözden geçir.*

- Görünüm sanat kitabı 5'e bağlıdır: ortak figür şablonu (5.2), sınıf ipuçları siluetin dış hattında (5.3), taban ifade yorgun ve tutuk (5.6), ayrıntı basamakları (5.7).
- **Tek imza şekli (5.4) — öneri, art-director onaylayacak:**

| Karakter | İmza şekli (sınıf eşyası değil, niyet söylemez) |
|---|---|
| Miraen | Arkaya düşen uzun uçlu Gürcü keçe başlığı |
| Sorhan | Omuzda halka halka sarılı yular |
| Thessra | Geriye uzanan uzun başörtüsü ucu |
| Karaca Usta | Sırtta rulo yapılmış deri tomarı |
| Aydoğdu | Tek omuzdan atılmış keçe yamçı |
| Saruca Hatun | Çene altından bağlanan büyük üçgen yazma |

- **Geri dönüşte imza sabit, durum değişir** (5.4 kural 4): Sorhan'ın 2. gelişinde yanında aile, 3.'de yalnız; Saruca'nın 1. gelişinde çocuk, 2.'de tohum çuvalı. Yıpranma (kumaş, sargı) her gelişte bir basamak artar.
- **Köyde imzayla görünür** (5.4 kural 5): `koyde` olan adlı karakter Köy görünümü'nde (20) imzası okunur biçimde yer alır.
- **Adsız figürler** yalnız sınıf ipucu taşır, imza taşımaz; aynı şablonun art arda iki örneği farklı renk/yük çeşitlemesiyle ayrılır.
- **Poz seti:** karakter başına nötr-yorgun, dinleyen, kaçınan, konuşan, sessiz (5.6); sayı Bölüm 8 bütçesindedir.
- Ses: bu sistemin kendi sesi yok; geliş ve ayrılış seslerini Ses (22) tanımlar.

> 📌 **Asset Spec** — Görsel gereksinimler tanımlandı. Sanat kitabı onaylandıktan sonra `/asset-spec system:karakter-kadrosu` ile karakter başına görsel tarifler, boyutlar ve üretim istemleri çıkarılabilir.

## Acceptance Criteria

> **Gözlem noktaları:** Testler İçerik veri hattı'nın fixture kataloğunu kullanır. RNG yerine *sahte RNG* enjekte edilir: sıradaki `randf` / `randi_range` dönüşleri testte verilir, çağrılar argümanlarıyla sayılır. Köy nüfusu (10) yerine *spy*: aldığı sınıf bildirimlerini sayar. Okunanlar: karakter `durum`, `ziyaret_sayisi`, `son_karar`, `en_erken_donus_gecesi`, uygunluk sonucu, figür örneği alanları, uyarı ve geliştirme hatası sayaçları.

**Veri ve doğrulama**
- **AC-1 (Logic) Gerçek kadro.** **GIVEN** depodaki `res://data/` **WHEN** katalog yüklenir **THEN** *Hazır*; 6 adlı karakter ve 3 sınıf şablonu; her karakterin `sinif` ve `donus_kurali` değeri Core Rules 1 tablosuyla aynı; Sorhan `n_ziyaret = 3`, Saruca `n_ziyaret = 2`.
- **AC-2 (Logic) Alan doğrulaması.** **GIVEN** fixture'da her satır ayrı bir testte: `oranla_doner` + `p0` yok; `p0 = 0`; `p0 = 1.2`; `d = 1.5`; `k_azami = 1`; `k_azami = 7`; `birden_cok_gelir` + `n_ziyaret = 1`; `g_min = 5, g_max = 3`; `g_max = 11`; `en_erken_gece = -1`; `sohbet_id` var olmayan kayıt; `ad_anahtari` tabloda yok; `ad_havuzu` 2 öğe; hiç adlı karakter yok **WHEN** katalog yüklenir **THEN** her birinde *Hatalı* ve tam 1 hata.
- **AC-3 (Logic) Seçenek listesi.** **GIVEN** `karar_secenekleri` sırayla `[]`, `[kabul, kabul]`, `[ucur]` **WHEN** yükleme **THEN** her birinde *Hatalı*, 1 hata.
- **AC-4 (Logic) Şablon sayısı.** **GIVEN** `ciftci` şablonu yok; ayrı testte iki `asker` şablonu **WHEN** yükleme **THEN** *Hatalı*.
- **AC-5 (Logic) Fazla alan uyarıdır.** **GIVEN** `hic_donmez` karakterde `p0 = 0.5` dolu **WHEN** yükleme **THEN** *Hazır*, 1 uyarı, 0 hata.

**Durum, uygunluk, ziyaret**
- **AC-6 (Logic) Yeni oturum.** **GIVEN** yeni oturum, ayrı iki oturumda seed A ve B **WHEN** başlar **THEN** 6 karakter `gelmedi`, `ziyaret_sayisi = 0`; iki oturumun kayıtlı seed'leri farklı.
- **AC-7 (Logic) İlk uygunluk.** **GIVEN** `en_erken_gece = 2` **WHEN** gece = 1 uygunluk sorulur **THEN** hayır; **WHEN** gece = 2 **THEN** evet.
- **AC-8 (Logic) Dönüş uygunluğu.** **GIVEN** `donebilir`, `en_erken_donus_gecesi = 6` **WHEN** gece = 5 **THEN** hayır; **WHEN** gece = 6 **THEN** evet.
- **AC-9 (Logic) Erken istek.** **GIVEN** AC-8'deki karakter **WHEN** 4 gece 5'te ister **THEN** reddedilir, 1 geliştirme hatası, durum ve sayaçlar değişmez.
- **AC-10 (Logic) Aynı gece ikinci istek.** **GIVEN** karakter bu gece 4 tarafından istenmiş **WHEN** aynı gece tekrar istenir **THEN** reddedilir, 1 geliştirme hatası, durum değişmez.
- **AC-11 (Logic) Ziyaret sayımı.** **GIVEN** karakter istendi ama "ziyaret başladı" gelmedi **THEN** `ziyaret_sayisi = 0`. **WHEN** "ziyaret başladı" (gece 3) **THEN** `ziyaret_sayisi = 1`, `son_ziyaret_gecesi = 3`.
- **AC-12 (Logic) Son karar.** **GIVEN** ziyaret sürüyor **WHEN** Karar "gitti" ile `rusvet` bildirir **THEN** `son_karar = &"rusvet"`.

**Dönüş kuralları**
- **AC-13 (Logic) Kaldı (parametrik).** **GIVEN** sırayla `hic_donmez`, `oranla_doner`, `birden_cok_gelir` karakter **WHEN** "kaldı" **THEN** her birinde `koyde`, spy'da sınıf bildirimi tam 1, sahte RNG çağrısı 0.
- **AC-14 (Logic) Hiç dönmez.** **GIVEN** Miraen **WHEN** "gitti" **THEN** `kalici_ayrildi`, RNG çağrısı 0; sonraki 10 gecenin hiçbirinde uygun değil.
- **AC-15 (Logic) F1 ilk dönüş.** **GIVEN** p0 = 0.6, d = 0.5, k_azami = 4, `ziyaret_sayisi = 1`, gece = 3, sahte `randf` → 0.41, `randi_range` → 3 **WHEN** "gitti" **THEN** `donebilir`, `en_erken_donus_gecesi = 6`, `randi_range(2, 4)` çağrıldı.
- **AC-16 (Logic) F1 azalma — ret.** **GIVEN** aynı veri, `ziyaret_sayisi = 2` (p_2 = 0.30), `randf` → 0.35 **WHEN** "gitti" **THEN** `kalici_ayrildi`, `randi_range` çağrılmadı.
- **AC-17 (Logic) F1 azalma — dönüş.** **GIVEN** `ziyaret_sayisi = 2`, `randf` → 0.29 **WHEN** "gitti" **THEN** `donebilir`.
- **AC-18 (Logic) F1 üst sınır.** **GIVEN** `ziyaret_sayisi = 4 = k_azami` **WHEN** "gitti" **THEN** `kalici_ayrildi`, `randf` ve `randi_range` çağrılmadı.
- **AC-19 (Logic) F1 sınır değerleri.** **GIVEN** `d = 0`, p0 = 0.6 **WHEN** `ziyaret_sayisi = 1`, `randf` → 0.5 **THEN** `donebilir`; **WHEN** `ziyaret_sayisi = 2`, `randf` → 0.0 **THEN** `kalici_ayrildi` (p_2 = 0). **GIVEN** `p0 = 1.0`, `ziyaret_sayisi = 1`, `randf` → 0.999 **THEN** `donebilir`.
- **AC-20 (Logic) F2 aralık.** **GIVEN** g_min = 2, g_max = 4, gece = 10 **WHEN** sahte `randi_range` → 2, ayrı testte → 4 **THEN** sırasıyla 12 ve 14; çağrı argümanları `(2, 4)`. **GIVEN** g_min = g_max = 3 **THEN** `randi_range(3, 3)` çağrıldı, sonuç 13.
- **AC-21 (Logic) F3.** **GIVEN** Sorhan (`n_ziyaret = 3`), `randi_range` → 2 **WHEN** 1. ve 2. gelişte "gitti" **THEN** her seferinde `donebilir`, `randf` çağrılmadı. **WHEN** 3. gelişte "gitti" **THEN** `kalici_ayrildi`, `randf` ve `randi_range` çağrılmadı.
- **AC-22 (Logic) Ara gelişte kaldı.** **GIVEN** Sorhan 2. gelişinde **WHEN** "kaldı" **THEN** `koyde`; sonraki 10 gecede uygun değil.
- **AC-23 (Logic) Tek değerlendirme.** **GIVEN** bir ziyarete "gitti" bildirilmiş **WHEN** aynı ziyarete ikinci "gitti" ya da "kaldı" gelir **THEN** yok sayılır, 1 geliştirme hatası, durum ve RNG çağrı sayısı değişmez.

**Figürler**
- **AC-24 (Logic) Figür örneği.** **GIVEN** `esnaf` şablonu, havuz 3 ad **WHEN** aynı gece 3 örnek istenir **THEN** 3 farklı ad, sınıf hep `esnaf`. **WHEN** 4. örnek **THEN** havuzdan geçerli bir ad, 0 hata.
- **AC-25 (Logic) Figür iz bırakmaz.** **GIVEN** bir figür "kaldı" **THEN** spy'da 1 sınıf bildirimi; kayıt verisinde figür girişi yok; adlı karakterlerin tüm durum ve sayaçları değişmedi.
- **AC-26 (Logic) Figür adları dönüş zarlarını kaydırmaz.** **GIVEN** aynı dönüş seed'i, bir koşuda 0, diğerinde 5 figür örneği istenir **WHEN** aynı karar dizisi oynanır **THEN** iki koşuda tüm `en_erken_donus_gecesi` ve durumlar aynı (figür adları ayrı RNG akışından, kural 13).

**Kayıt ve oturum**
- **AC-27 (Integration) Determinizm ve kayıt.** **GIVEN** seed S, 3 gece oynanmış (Thessra `donebilir`, en erken 6; Miraen `kalici_ayrildi`) **WHEN** gece sonu kaydı yazılır ve yeni bir süreçte yüklenir **THEN** tüm durumlar aynı ve sonraki ilk dönüş zarı kayıttan önceki koşuyla aynı değer.
- **AC-28 (Integration) Gece ortası çıkış.** **GIVEN** gece 4'te Thessra'nın ziyareti sürerken menüye çıkılır **WHEN** "Devam" son gece sonu kaydından yükler **THEN** Thessra gece 4 başındaki durumda, `ziyaret_sayisi` artmamış.
- **AC-29 (Integration) Bar kırılınca.** **GIVEN** gece 5'te Sorhan "gitti" almadan bar kırılır **WHEN** oturum sonu **THEN** karakter durumları için kayıt yazılmamış (GDD 1: oturum sonu kaydı siler).
- **AC-30 (Integration) Bilinmeyen kimlik.** **GIVEN** kayıtta katalogda olmayan `ali` **WHEN** yükleme **THEN** reddedilir, *Menü*, 1 geliştirme hatası.
- **AC-31 (Integration) Yeni karakter, aynı sürüm.** **GIVEN** kayıtta yalnız 5 karakter, katalogda 6, `icerik_surumu` aynı **WHEN** yükleme **THEN** 6. karakter `gelmedi`, diğer 5'i kayıttaki gibi.

**İçerik ve görünüm**
- **AC-32 (Logic, CI) Hüküm alanı yok.** **GIVEN** `KarakterVerisi` ve `SinifSablonu` betikleri **WHEN** alan adları taranır **THEN** `iyi`, `kotu`, `guven`, `tehlike`, `sadakat` içeren alan yok.
- **AC-33 (Config/Data) Hassasiyet kontrol listesi.** **GIVEN** her karakterin metni ve geçmişi **WHEN** içerik incelemesi Core Rules 4'teki 6 maddeyi tek tek işaretler **THEN** 6 karakterin hepsinde 6/6; liste `production/qa/` altında saklanır.
- **AC-34 (Visual/Feel) İmza okunurluğu.** **GIVEN** 6 karakterin siyah dolgu 64 px silueti, adları gizli **WHEN** ≥ 3 kişiye 6 siluet ve 6 imza tarifi gösterilip eşleştirmeleri istenir **THEN** eşleştirme ≥ %90 doğru; görüntü `production/qa/evidence/` altında, art-director onayıyla.

## Open Questions

1. **"Kaldı / gitti" eşlemesi** — rüşvet, kışla ve karaktere özel seçenekler hangisine düşer? Sahibi: Karar (7). Hedef: Karar GDD'si.
2. **Uygunluk üst sınırı** — `donebilir` bir karakter süresiz mi bekler? Sahibi: Varış kuyruğu (4).
3. **Karaktere özel seçenekler** — "at takası", "yalnız ustayı al", "obayı da al", "tohumu al, onu değil": hangileri MVP'ye girer? Sahibi: Kullanıcı + Karar (7).
4. **Adlar** — Miraen, Sorhan, Thessra uydurma adlar; köken savunulabilir ama bir dil/tarih okumasından geçmeli. Sahibi: Kullanıcı. Hedef: Vertical Slice.
5. **Anakronizm (Sonlar 15)** — 1243'te Osman Bey doğmamıştı (~1258). "Osmanoğullarına katılmak" sonu ya zamanda ileri atlamalı ya da "Ertuğrul'un obası" olarak yeniden adlandırılmalı. Sahibi: Kullanıcı. Hedef: Sonlar GDD'si.
6. **Köyden ayrılma** — `koyde` olan karakter köyden ayrılabilir mi (ör. ikinci perdede)? Şimdilik hayır; gerekirse Köy nüfusu (10) / Köyün oturması (13).
7. **Moğolların görünümü** — sanat kitabı 5.5'te açık; bu kadroda Moğol karakter yok.
