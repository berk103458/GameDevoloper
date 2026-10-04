# Oyun durumu ve gün döngüsü

> **Status**: Designed (pending review)
> **Author**: kullanıcı + Claude
> **Last Updated**: 2026-10-04
> **Last Verified**: 2026-10-04
> **Implements Pillar**: Yorgun gece; Köy senin aynan

## Summary

Oyunun zamanını ve oturumunu tutan temel sistem: kaçıncı gecede olunduğunu, hangi perdede olunduğunu ve oturumun sürüp sürmediğini bilir. Bir gün bir gece nöbetidir; gece bitince sayaç artar ve skor, hayatta kalınan gece sayısıdır. Diğer sistemler zamanı buradan okur, gece sonundaki işlemler burada sıraya konur.

> **Quick reference** — Layer: `Foundation` · Priority: `MVP` · Key deps: `None` (bağımlı olanlar: Varış kuyruğu, Barlar, Rüşvet hakları, Köy nüfusu, Köyün oturması, Savunma, Sonlar, Kaydet / yükle, HUD, Menüler, Ses)

## Overview

Bu sistem oyunun zamanını ve oturum durumunu tutar: şu an kaçıncı gün olduğunu, günün hangi aşamasında olunduğunu, hangi perdede (kapı ve köy ya da savunma) olunduğunu ve oturumun sürüp sürmediğini. Diğer sistemler kendi durumlarını (barlar, nüfus, kadro) kendileri tutar; zamanı ve oturumun yaşam döngüsünü bu sistemden okur, ilerlemesini bu sisteme bildirir. Skor "hayatta kalınan gün" olduğu için gün sayacı yalnız bir gösterge değil, oyunun sonucudur. Oyuncu bu sistemle doğrudan etkileşmez; etkisini kapıdaki gecelerin birbirini izlemesinde, HUD'daki gün sayacında ve perde geçişinde görür.

## Detailed Design

### Core Rules

1. **Bir oyun günü = bir gece nöbeti** (kullanıcı kararı, 4 Ekim 2026). Gece, kapıya o gece gelen herkes işlenince biter. Gündüz sahnesi yoktur (sanat kitabı 2.3). O gece kaç kişinin geleceğini bu sistem değil, Varış kuyruğu (4) belirler.
2. **Gün sayacı gece bitince artar** (kullanıcı kararı). Gece sonuna kadar yaşanırsa o gün sayılır; gece ortasında oturum biterse (ör. bir bar kırılır) o gece sayılmaz.
3. **Skor = tamamlanan gece sayısı** — kilitteki "skor hayatta kalınan gündür" kuralının uygulaması.
4. **Tek sayaç, iki perde boyunca sürer** (kullanıcı kararı). İkinci perdeye geçişte sayaç sıfırlanmaz; skor toplam hayatta kalınan gündür. Eşikler (ör. "köy oturdu", elli gün yalnız örnek) bu tek sayaca göre çalışır; eşiğin kendisi Köyün oturması (13) sistemine aittir.
5. **Perde bilgisi bu sistemde tutulur:** `Perde 1 — kapı ve köy` ya da `Perde 2 — savunma`. Perde geçişini bu sistem **kendisi tetiklemez**; Köyün oturması (13) "köy oturdu" bildirdiğinde, o gecenin sonunda geçiş yapılır.
6. **Oturum sonu:** İki yol vardır — (a) bir bar kırılır (Barlar, 8 bildirir) ya da (b) bir son tetiklenir (Sonlar, 15 bildirir). İkisinde de sayaç o anki *tamamlanmış* gün sayısında donar ve skor odur.
7. **Bu sistem başka sistemlerin durumunu tutmaz.** Barlar, nüfus, rüşvet hakları ve kadro kendi durumlarını tutar; bu sistem yalnız zamanı (gün, gece aşaması), perdeyi ve oturumun yaşam döngüsünü tutar ve olayları yayınlar.
8. **Duraklatma** durum değiştirmez: duraklatılmışken durum, gün ve perde değişmez ve durum olayı yayınlanmaz. Bu sistemin bir saati yoktur; "zaman durur" bu anlama gelir. Duraklatılmışken gelen bildirimler kuyrukta tutulur ve Devam'da sırayla işlenir.
9. **Bekleyen bayraklar** ("köy oturdu", "son tetiklendi") her *Gece başlangıcı*'nda ve yeni oturum başında temizlenir; bir geceden ya da oturumdan sonrakine taşınmaz.
10. **Durumla uyumsuz bildirimler:** "Köy oturdu" ve "son tetiklendi" yalnız *Kapı açık* ve *Gece sonu* adım 2'de kabul edilir; "bar kırıldı" yalnız bu iki noktada oturumu bitirir. Başka bir durumda (*Gece başlangıcı*, *Perde geçişi*, *Oturum sonu*, *Menü*) gelen bu bildirimler yok sayılır ve geliştirme hatası olarak kaydedilir.
11. **Perde geçişinin bitişi:** *Perde geçişi*, sunum tarafı (geçiş sahnesi) "geçiş tamamlandı" bildirdiğinde biter; süresi ve oyuncu girdisi isteyip istemediği sunuma aittir.
12. **Devam, kayıt yokken** kullanılamaz (menüde pasif); bu durumda yalnız Yeni oyun açılır.

### States and Transitions

| Durum | Anlamı | Giriş | Çıkış |
|---|---|---|---|
| **Menü** | Oturum yok | Oyun açılışı; oturum sonu ekranından dönüş | Yeni oyun → *Gece başlangıcı* (gün = 0); Devam → *Gece başlangıcı* (kayıttaki gün) |
| **Gece başlangıcı** | Yeni gece hazırlanıyor | Menüden; önceki *Gece sonu*'ndan | Varış kuyruğu gecenin listesini verince → *Kapı açık* |
| **Kapı açık** | Kapıda biri var ya da sıradaki geliyor; sohbet ve karar burada | *Gece başlangıcı* | Kuyruk boşalınca → *Gece sonu*; bar kırılırsa → *Oturum sonu* |
| **Gece sonu** | Gece tamamlandı; bölünmez (aşağıdaki sıra) | *Kapı açık* | Bar kırıldıysa ya da bir son tetiklendiyse → *Oturum sonu*; değilse "köy oturdu" bekliyorsa ve Perde 1'deysek → *Perde geçişi*; değilse → *Gece başlangıcı* |
| **Perde geçişi** | Ağalığa geçiş anı (sanat kitabı 2.6) | *Gece sonu* | Perde = 2; otomatik kayıt → *Gece başlangıcı* |
| **Oturum sonu** | Skor gösterilir; kayıt silinir | *Kapı açık* (bar kırıldı) ya da *Gece sonu* (bar kırıldı ya da son tetiklendi) | Menüye dönüş → *Menü* |
| **Duraklatıldı** | Üst durum: zaman durdu | *Gece başlangıcı*, *Kapı açık*, *Gece sonu* | Devam → önceki durum; menüye dön → *Menü* (kayıtsız çıkış, açık soru) |

Geçersiz geçişler (ör. *Kapı açık* iken gün +1) reddedilir ve geliştirme sürümünde hata olarak kaydedilir.

**Gece sonu çözüm sırası** (kullanıcı kararları, 4 Ekim 2026). Bu adımlar bölünmez; duraklatma isteği adım 5 bitene kadar bekletilir:
1. Gün +1 (F1); "gece bitti" olayı yayınlanır.
2. Dinleyiciler gece sonu değerlendirmesini yapar (Barlar 8, Köy nüfusu 10, Köyün oturması 13, Sonlar 15).
3. Oturumu bitiren kontrol, öncelik sırasıyla: **bar kırıldı > son tetiklendi**. Biri varsa → *Oturum sonu* (bar kırıldıysa kayıp ekranı).
4. Yoksa ve "köy oturdu" bekliyorsa ve Perde 1'deysek → *Perde geçişi*.
5. Otomatik kayıt (sıradaki gecenin başlangıcı olarak) → *Gece başlangıcı*. Perde geçişi varsa kayıt geçiş tamamlandıktan sonra yazılır.

**Bekleyen bildirimler:** "Köy oturdu" ve "bir son tetiklendi" bildirimleri *Kapı açık* sırasında gelirse hemen uygulanmaz; bayrak olarak tutulur ve gece sonunda adım 3–4'te değerlendirilir (gece sayılır). *Kapı açık*'tan oturumu bitirebilen tek yol bar kırılmasıdır.

### Interactions with Other Systems

| Sistem | Bu sistemden aldığı | Bu sisteme verdiği | Arayüzün sahibi |
|---|---|---|---|
| Varış kuyruğu (4) | Gün numarası, perde, "gece başladı" olayı | O gecenin kuyruğu hazır; kuyruk boşaldı | Bu sistem (olaylar), Varış kuyruğu (liste) |
| Barlar (8) | Gün, perde, gece sonu olayı | "Bir bar kırıldı" | Barlar |
| Rüşvet hakları (9) | Gün, perde | — | Rüşvet hakları |
| Köy nüfusu (10) | Gün, gece sonu olayı | — | Köy nüfusu |
| Köyün oturması (13) | Gün sayacı (eşik için) | "Köy oturdu" | Köyün oturması |
| Savunma (14) | Perde = 2, gün | — | Savunma |
| Sonlar (15) | Gün, perde | "Bir son tetiklendi" (hangisi olduğu Sonlar'a ait) | Sonlar |
| Kaydet / yükle (16) | Gece sonunda "kaydet" isteği (sıradaki gecenin başlangıcı: gün, perde); oturum sonunda "kaydı sil" | Yüklenen gün ve perde | Kaydet / yükle |
| HUD (19) | Gün sayacı | — | HUD |
| Menüler ve son ekranı (21) | Skor, oturum sonu olayı | Yeni oyun / devam / menüye dön | Menüler |
| Ses (22) | Durum değişimi olayları | — | Ses |

## Formulas

### F1. Gün sayacı artışı

`gun_sayaci_yeni = gun_sayaci + GUN_ARTISI`

Yalnız *Kapı açık → Gece sonu* geçişinde (çözüm sırası adım 1), gece başına tam bir kez çalışır.

| Variable | Type | Range | Source | Description |
|----------|------|-------|--------|-------------|
| gun_sayaci | int | 0 – ∞ | calculated | O ana kadar tamamlanan gece sayısı. Yeni oyunda 0; devam ederken kayıttan okunur (int'e çevrilir, E13). |
| GUN_ARTISI | int | 1 | constant | Bir gece = bir oyun günü (kullanıcı kararı). Ayar değeri değildir. |
| gun_sayaci_yeni | int | 1 – ∞ | calculated | Gece sonundan sonraki sayaç. |

**Output Range:** 1 – ∞; üst sınır yok, kenetlenmez. Negatif ya da kesirli değer yalnız bozuk kayıttan gelebilir (E14).
**Example:** gun_sayaci = 3; dördüncü gecenin kuyruğu boşalır → gun_sayaci_yeni = 4. Dördüncü gece ortasında bar kırılsaydı *Gece sonu*'na girilmez, sayaç 3'te kalırdı.

### F2. Skor

`skor = gun_sayaci_son`

*Oturum sonu*'na girişte bir kez hesaplanır, sonra değişmez.

| Variable | Type | Range | Source | Description |
|----------|------|-------|--------|-------------|
| gun_sayaci_son | int | 0 – ∞ | calculated | *Oturum sonu*'na girildiği andaki gun_sayaci. |
| skor | int | 0 – ∞ | calculated | Hayatta kalınan gün (kilit). İki perde boyunca tek sayaç; perde çarpanı ya da bonus yok. |

**Output Range:** 0 – ∞. 0 geçerli bir skordur (ilk gecede bar kırılırsa).
**Example:** Perde 1'de 41 gece, Perde 2'de 9 gece tamamlanır (gun_sayaci = 50); 51. gece ortasında bar kırılır → skor = 50.

### F3. Gösterilen gece numarası

`gosterilen_gece = gun_sayaci + 1`

Oturum sürerken HUD'a verilir (kullanıcı kararı: "içinde bulunulan gece"). Skor ekranı F2'yi gösterir.

| Variable | Type | Range | Source | Description |
|----------|------|-------|--------|-------------|
| gun_sayaci | int | 0 – ∞ | calculated | F1'deki sayaç. |
| gosterilen_gece | int | 1 – ∞ | calculated | İçinde bulunulan gecenin sıra numarası. |

**Output Range:** 1 – ∞.
**Example:** İlk gece gun_sayaci = 0 → HUD "1. gece". Bu gece bar kırılırsa skor ekranı 0 gösterir.

*Not:* "Köy oturdu" eşiğinin karşılaştırması Köyün oturması (13) sistemine aittir; bu belgede yer almaz.

## Edge Cases

**Oturumu bitiren durumlar**
- **If bar *Kapı açık* sırasında kırılırsa**: hemen *Oturum sonu*; *Gece sonu*'na girilmez, F1 çalışmaz, gece sayılmaz. Kuyrukta kalanlar işlenmez; kayıt silinir.
- **If bar gece sonu değerlendirmesinde (adım 2) kırılırsa**: gece sayılır (F1 adım 1'de çalıştı), sonra *Oturum sonu* (kullanıcı kararı).
- **If aynı çağrı zinciri içinde (*Oturum sonu*'na girilmeden önce) birden fazla "bar kırıldı" gelirse ya da bildirim *Oturum sonu* / *Menü*'deyken gelirse**: ilki işlenir, gerisi yok sayılır; skor bir kez hesaplanır.

**"Köy oturdu" ve perde geçişi**
- **If "köy oturdu" *Kapı açık* sırasında gelirse**: bayrak olarak tutulur, gece sonunda adım 4'te uygulanır.
- **If aynı gece "köy oturdu" gelir ve bar *Kapı açık*'ta kırılırsa**: bayrak silinir, perde geçişi olmaz, gece sayılmaz.
- **If aynı gece "köy oturdu" gelir ve bar gece sonunda kırılırsa**: adım 3 adım 4'ten önce gelir → *Oturum sonu*, perde geçişi oynatılmaz; gece sayılır.
- **If aynı gece "köy oturdu" ve bir son birlikte gelirse**: son kazanır; perde geçişi oynatılmaz (kullanıcı kararı).
- **If perde zaten 2 iken "köy oturdu" yeniden gelirse**: yok sayılır; geliştirme sürümünde uyarı. Aynı gece birden fazla gelen bildirim tek bayraktır.
- **If kayıttan perde = 2 ile devam edilirse**: *Gece başlangıcı*'na Perde 2 ile girilir; *Perde geçişi* yeniden oynatılmaz (kayıt geçişten sonra yazıldığı için).

**Sonlar**
- **If birinci perdede bir son tetiklenirse**: bu sistem sonu perdeye göre filtrelemez; gece sonunda adım 3 → *Oturum sonu*. Birinci perdede son olup olmadığı Sonlar'ın (15) kararıdır.
- **If bir son *Kapı açık* sırasında tetiklenirse**: bayrak olarak bekler; gece normal biter ve sayılır (kullanıcı kararı).
- **If gece sonunda hem bar kırılır hem bir son tetiklenirse**: bar kazanır, kayıp ekranı gösterilir; skor aynıdır (kullanıcı kararı).

**Sıfır ve sınır değerleri**
- **If ilk gecede (gun_sayaci = 0) bar kırılırsa**: skor = 0, geçerli skor olarak gösterilir; kayıt silinir. Yeni oyun gün 0, Perde 1 ile başlar.
- **If sayaç çok büyürse**: üst sınır yok (64-bit int). Kayıt/yükle (16) sayacı okurken int'e çevirir — Godot'nun JSON ayrıştırması sayıları float döndürür. HUD ve son ekranı çok basamaklı sayıyı kesmeden gösterir.
- **If yüklenen kayıtta gun_sayaci negatifse, tam sayı değeri taşımıyorsa (ör. 2.5, "abc") ya da perde 1 veya 2 değilse**: kayıt reddedilir, *Menü*'de kalınır, geliştirme sürümünde hata; sessiz düzeltme yok. Tam sayı değerli bir float (ör. JSON'dan gelen `3.0`) geçerlidir ve int'e çevrilir.

**Boş kuyruk**
- **If gece başında kuyruk boşsa (0 varış)**: durumlar atlanmaz (*Gece başlangıcı → Kapı açık → Gece sonu*); "kuyruk boşaldı" olayı *Kapı açık*'a girildikten sonra yayınlanır. Boş gecenin sayılıp sayılmayacağı ve art arda boş gecelerin önlenmesi **açık soru** — Varış kuyruğu (4) tasarlanırken birlikte karara bağlanacak.
- **If Varış kuyruğu gecenin listesini hiç vermezse**: *Gece başlangıcı*'nda kalınır; bekleme süresi aşılınca geliştirme hatası olarak kaydedilir (süre veridir, bkz. Open Questions).

**Kayıt, yükleme ve duraklatma**
- **If oturum biterse**: kayıt silinir (kalıcı ölüm, kullanıcı kararı); Devam ölü oturuma dönemez.
- **If oyuncu gece ortasında menüye dönerse ya da uygulama kapanırsa**: kayıt yapılmaz; Devam aynı gecenin başlangıcına döner, o gecenin kararları geri alınır. Bu yolun açtığı "gece tekrarı" şimdilik kabul edildi, prototipte gözlenecek (kullanıcı kararı). Aynı gecenin aynı varışları getirip getirmeyeceği Varış kuyruğu (4) ve Kaydet/yükle (16) kararıdır.
- **If *Gece sonu* çözülürken duraklatma istenirse**: istek adım 5 bitene kadar bekletilir; "gün +1 oldu ama kayıt yazılmadı" ara durumu oluşmaz.
- **If *Perde geçişi* ya da *Oturum sonu* sırasında duraklatma istenirse**: yok sayılır.
- **If *Kapı açık* iken gün +1 ya da başka geçersiz geçiş istenirse**: reddedilir, durum değişmez, geliştirme sürümünde hata.

## Dependencies

**Yukarı akış (bu sistemin bağlı olduğu):** Yok — Foundation katmanı.

**Aşağı akış (bu sisteme bağlı olanlar):**

| Sistem | Bağ | Arayüz |
|---|---|---|
| Varış kuyruğu (4) | Sert | "Gece başladı" olayını dinler; "kuyruk hazır" ve "kuyruk boşaldı" bildirir |
| Barlar (8) | Sert | Gün, perde, "gece bitti"; "bar kırıldı" bildirir |
| Rüşvet hakları (9) | Sert | Gün, perde |
| Köy nüfusu (10) | Sert | Gün, "gece bitti" |
| Köyün oturması (13) | Sert | Gün sayacı; "köy oturdu" bildirir (gece içinde gelirse gece sonuna kadar bekler) |
| Savunma (14) | Sert | Perde = 2, gün |
| Sonlar (15) | Sert | Gün, perde; "son tetiklendi" bildirir (gece içinde gelirse gece sonuna kadar bekler) |
| Kaydet / yükle (16) | Sert | Gece sonunda kaydet, oturum sonunda sil; yüklemede gün ve perdeyi verir |
| HUD (19) | Sert | Gösterilen gece (F3) |
| Menüler ve son ekranı (21) | Sert | Skor (F2), oturum sonu olayı; yeni oyun / devam / menüye dön |
| Ses (22) | Yumuşak | Durum değişimi olayları |

*Bu sistemin yayınladığı olaylar (gece başladı, gece bitti, perde değişti, oturum bitti) ve bekleyen-bayrak kuralı, 13 ve 15'in belgelerinde de yazılmalıdır (çift yönlü bağımlılık).*

## Visual/Audio Requirements

Bu sistemin kendi görseli ya da sesi yok. Durum olayları (gece başladı, gece bitti, perde değişti, oturum bitti) sunumu tetikler; görünüşü HUD (19), Köy görünümü (20), Menüler ve son ekranı (21) ve Ses (22) belgeleri tanımlar. Perde geçişinin görünüşü sanat kitabı 2.6'dadır.

## Game Feel

Yok — bu sistem doğrudan oynanmaz. Tek his hedefi: gece sonu ile yeni gece arasında bekleme hissedilmemeli; kayıt ve geçişler oyuncuya takılma olarak görünmemeli.

## UI Requirements

- HUD gösterilen geceyi (F3) gösterir: ilk gece "1. gece" (HUD, 19; sanat kitabı 7.1).
- Son ekranı skoru (F2) gösterir; 0 geçerli skor olarak yazılır (Menüler ve son ekranı, 21; sanat kitabı 7.9).
- Kayıt yokken menüde Devam pasiftir.
- Sayılar koddan basılır, görselde rakam yoktur (sanat kitabı 1).

## Cross-References

| Belge | Neye bakar |
|---|---|
| `design/gdd/kapi-konsept.md` | Skor = hayatta kalınan gün; iki perde; "elli gün" yalnız örnek |
| `design/gdd/systems-index.md` | Bağımlılıklar ve öncelik |
| `design/art/art-bible.md` 2.3, 2.6, 7.1, 7.9 | Gece-only köy, perde geçişi görünüşü, HUD gün sayacı, son ekranı |
| Varış kuyruğu (4), Barlar (8), Köyün oturması (13), Sonlar (15), Kaydet / yükle (16) | Henüz tasarlanmadı — bu belgedeki olay sözleşmesi onların belgelerinde tekrarlanmalı |

## Acceptance Criteria

> **Test kanıtı:** Logic → `tests/unit/oyun_durumu/` (gdUnit4, `oyun_durumu_[ozellik]_test.gd`). Integration → `tests/integration/oyun_durumu/` ya da belgelenmiş oyun testi. UI → `production/qa/evidence/` altında saklanan ekran görüntüsü. Klasör adı `oyun_durumu` öneridir; mimari belgesinde kesinleşir.
> **Ortak düzen:** Diğer sistemler (Varış kuyruğu, Barlar, Köyün oturması, Sonlar, Kaydet/yükle) testlerde taklit (stub) ile değiştirilir. Gün ve perde değerleri fixture'lardan gelir; doğrudan sayı yalnız sınır testlerinde (0, 1, -1, 2.5, perde 0/3).
> **Gözlem noktaları:** "Durum" = sistemin bildirdiği durum adı. "Olay" = yayınlanan sinyal. "Geliştirme hatası" = sistemin hata kancasına düşen tek kayıt (kancanın biçimi açık soru — bkz. Open Questions).

### Temel kurallar
- **AC-01 (Logic) Gece = kuyruk.** **GIVEN** *Kapı açık*, kuyrukta 3 varış **WHEN** 2'si işlenir **THEN** durum *Kapı açık*. **WHEN** 3.'sü işlenip "kuyruk boşaldı" gelir **THEN** *Gece sonu*.
- **AC-02 (Logic) Sayaç yalnız gece bitince artar.** **GIVEN** gun_sayaci = N, *Kapı açık* **WHEN** kuyruk boşalır **THEN** N+1. **GIVEN** aynı **WHEN** bar kırılır **THEN** N kalır.
- **AC-03 (Logic) Skor = tamamlanan gece.** **GIVEN** K gece tamamlanmış **WHEN** K+1. gecede *Kapı açık*'ta bar kırılır **THEN** skor = K.
- **AC-04 (Logic) Tek sayaç.** **GIVEN** Perde 1, gun_sayaci = N, "köy oturdu" bayrağı kalkık **WHEN** gece biter ve *Perde geçişi* tamamlanır **THEN** perde = 2, gun_sayaci = N+1; sonraki gece sonunda N+2.
- **AC-05 (Logic) Perdeyi sistem kendisi değiştirmez.** **GIVEN** Perde 1, "köy oturdu" hiç gelmemiş **WHEN** fixture sayıda gece tamamlanır **THEN** perde hep 1, *Perde geçişi*'ne girilmez.
- **AC-06 (Logic) İki bitiş yolu.** **GIVEN** gun_sayaci = N **WHEN** (a) *Kapı açık*'ta bar kırılır **THEN** *Oturum sonu*, skor = N. **WHEN** (b) gece içinde "son tetiklendi" gelir ve gece biter **THEN** *Oturum sonu*, skor = N+1.
- **AC-07 (Logic) Yalnız zaman ve oturum.** **GIVEN** sistemin açık arayüzü **WHEN** okunur **THEN** yalnız gün, durum, perde, oturum açık/kapalı ve skor döner; bar, nüfus, rüşvet, kadro alanı yoktur. *(Ek kanıt: hikâye kapanışında kod incelemesi.)*
- **AC-08 (Logic) Duraklatma durum değiştirmez.** **GIVEN** *Gece başlangıcı* ya da *Kapı açık* **WHEN** duraklatılır ve stub'lar olay gönderir **THEN** durum, gün, perde değişmez, durum olayı yayınlanmaz. **WHEN** Devam **THEN** önceki duruma dönülür ve bekleyen bildirimler sırayla işlenir.
- **AC-09 (Logic) Bayraklar temizlenir.** **GIVEN** "köy oturdu" bayrağı kalkıkken *Kapı açık*'ta bar kırılır **WHEN** yeni oyun başlar ve ilk gece biter **THEN** *Perde geçişi*'ne girilmez.
- **AC-10 (Logic) Uyumsuz bildirim.** **GIVEN** *Gece başlangıcı* ya da *Perde geçişi* **WHEN** "bar kırıldı", "son tetiklendi" ya da "köy oturdu" gelir **THEN** durum değişmez, 1 geliştirme hatası kaydedilir.
- **AC-11 (Integration) Devam kayıt yokken.** **GIVEN** diskte kayıt yok **WHEN** menü açılır **THEN** Devam pasiftir; Yeni oyun gün 0, Perde 1 ile başlar.

### Formüller
- **AC-12 (Logic) F1 gece başına bir kez.** **GIVEN** gun_sayaci = N ve "gece bitti"yi sayan bir dinleyici **WHEN** bir gece tamamlanır **THEN** dinleyici 1 kez çağrılır, gun_sayaci = N+1.
- **AC-13 (Logic) F1 sınır.** **GIVEN** yeni oyun **THEN** gun_sayaci = 0, perde = 1; ilk gece bitince 1.
- **AC-14 (Logic) F1 büyük değer.** **GIVEN** kayıttan gun_sayaci = 2^40 **WHEN** gece biter **THEN** 2^40 + 1, tip int, kenetleme yok.
- **AC-15 (Logic) F2 bir kez.** **GIVEN** *Oturum sonu*'na skor = N ile girilmiş **WHEN** ardından bar/son/köy bildirimleri ve gün +1 isteği gelir **THEN** skor = N, "oturum bitti" toplam 1 kez yayınlanmış.
- **AC-16 (Logic) F3.** **GIVEN** gun_sayaci = 0 / N **THEN** gösterilen gece = 1 / N+1.
- **AC-17 (UI) F3 + F2 ekranları.** **GIVEN** ilk gece **THEN** HUD "1. gece" yazar. **GIVEN** ilk gece bar kırılmış **THEN** son ekranı "0" yazar. **GIVEN** gun_sayaci = 1 234 567 890 **THEN** HUD ve son ekranı tüm basamakları kesmeden gösterir (ekran görüntüleri).

### Gece sonu çözüm sırası
- **AC-18 (Logic) Adım 1 → 2.** **GIVEN** gun_sayaci = N **WHEN** "gece bitti" yayınlanır **THEN** dinleyici içinden gun_sayaci = N+1 okunur.
- **AC-19 (Logic) Adım 2 → 3.** **GIVEN** Barlar stub'u "gece bitti" içinde "bar kırıldı" bildirir **WHEN** gece sonu çözülür **THEN** *Oturum sonu*, skor = N+1, kayıp ekranı türü, "kaydet" gönderilmez, "kaydı sil" 1 kez.
- **AC-20 (Logic) Bar > son.** **GIVEN** "son tetiklendi" bayrağı kalkık **WHEN** adım 2'de bar kırılır **THEN** *Oturum sonu* kayıp ekranı türüyle, skor = N+1.
- **AC-21 (Logic) Son > köy oturdu.** **GIVEN** Perde 1, iki bayrak da kalkık **WHEN** gece sonu çözülür **THEN** *Oturum sonu*, *Perde geçişi*'ne girilmez, perde = 1, skor = N+1.
- **AC-22 (Logic) Adım 4.** **GIVEN** Perde 1, "köy oturdu" kalkık, bar/son yok **WHEN** gece sonu çözülür **THEN** *Gece sonu → Perde geçişi →* (sunum "geçiş tamamlandı" bildirince) *Gece başlangıcı*; "perde değişti" 1 kez.
- **AC-23 (Integration) Adım 5 kayıt zamanı.** **GIVEN** Kaydet/yükle stub'u çağrıları kaydeder **WHEN** (a) normal gece biter **THEN** tek kayıt {gun: N+1, perde: 1}, *Gece başlangıcı*'ndan önce. **WHEN** (b) perde geçişli gece biter **THEN** tek kayıt {gun: N+1, perde: 2}, geçiş tamamlandıktan sonra; geçişten önce kayıt yok.

### Bekleyen bayrak kuralı
- **AC-24 (Logic) "Köy oturdu" Kapı açık'ta.** **GIVEN** Perde 1, *Kapı açık*, 2 varış kalmış **WHEN** "köy oturdu" gelir **THEN** *Kapı açık* kalır, perde 1, 2 varış işlenir; gece bitince *Perde geçişi*.
- **AC-25 (Logic) "Son" Kapı açık'ta.** **GIVEN** *Kapı açık*, gun_sayaci = N **WHEN** "son tetiklendi" gelir **THEN** *Kapı açık* kalır; kuyruk boşalınca skor = N+1.
- **AC-26 (Logic) Kapı açık'tan tek çıkış bar.** **GIVEN** *Kapı açık* **WHEN** "köy oturdu" ve "son" gelir **THEN** *Oturum sonu*'na girilmez. **WHEN** "bar kırıldı" **THEN** hemen girilir.
- **AC-27 (Logic) Tekrarlı bildirim.** **GIVEN** Perde 1 **WHEN** aynı gece "köy oturdu" 3 kez gelir **THEN** "perde değişti" 1 kez.

### Ana kenar durumları
- **AC-28 (Logic) Bar Kapı açık'ta.** **GIVEN** gun_sayaci = N, 2 varış işlenmemiş **WHEN** "bar kırıldı" **THEN** *Gece sonu*'na girilmez, "gece bitti" yayınlanmaz, skor = N, kalan varışlar işlenmez, "kaydı sil" 1 kez.
- **AC-29 (Logic) Köy oturdu + bar Kapı açık'ta.** **GIVEN** Perde 1, "köy oturdu" kalkık **WHEN** *Kapı açık*'ta bar kırılır **THEN** skor = N, perde 1, *Perde geçişi* yok.
- **AC-30 (Logic) Perde zaten 2.** **GIVEN** perde = 2 **WHEN** "köy oturdu" gelir ve gece biter **THEN** *Perde geçişi* yok, *Gece başlangıcı*'na geçilir, 1 geliştirme uyarısı.
- **AC-31 (Integration) Perde 2 kaydından devam.** **GIVEN** kayıt {gun: N, perde: 2} **WHEN** Devam **THEN** *Gece başlangıcı*'na perde 2 ile girilir, *Perde geçişi* oynatılmaz, HUD "N+1. gece".
- **AC-32 (Logic) 0 varışlı gece — sayım AÇIK.** **GIVEN** kuyruk stub'u boş liste verir **WHEN** gece başlar **THEN** durum sırası tam olarak *Gece başlangıcı → Kapı açık → Gece sonu → Gece başlangıcı*; "kuyruk boşaldı" *Kapı açık*'a girildikten sonra işlenir. *Sayaç beklentisi Varış kuyruğu (4) kararından sonra eklenecek.*
- **AC-33 (Logic) Kuyruk listesi gelmez.** **GIVEN** kuyruk stub'u liste göndermez **WHEN** bekleme süresi (veri) geçer **THEN** *Gece başlangıcı* kalır, 1 geliştirme hatası.
- **AC-34 (Logic) Gün 0'da oyun sonu.** **GIVEN** yeni oyun, *Kapı açık* **WHEN** bar kırılır **THEN** skor = 0 (null ya da -1 değil), *Oturum sonu*, "kaydı sil".
- **AC-35 (Integration) Oturum sonu kalıcı.** **GIVEN** oturum *Oturum sonu*'nda bitmiş **WHEN** menüye dönülür **THEN** Devam pasif, kayıt dosyası diskte yok.
- **AC-36 (Logic) Geçersiz kayıt.** **GIVEN** sırayla gun = -1, 2.5, "abc"; perde = 0, 3 **WHEN** Devam **THEN** her birinde *Menü*'de kalınır, değerler değişmez, 1 geliştirme hatası. **GIVEN** gun = 3.0 **THEN** kabul edilir, gun_sayaci int 3.
- **AC-37 (Integration) Gece ortası çıkış kayıt yazmaz.** **GIVEN** kayıt {gun: N}, *Kapı açık*'ta 2 karar verilmiş **WHEN** duraklat → menü → Devam **THEN** *Gece başlangıcı*'na gun = N ile girilir; gece ortasında kaydet isteği gönderilmemiş.
- **AC-38 (Logic) Gece sonunda duraklatma ertelenir.** **GIVEN** adım 2'de duraklatma istenir **WHEN** gece sonu çözülür **THEN** duraklatma adım 5'teki kayıttan sonra, *Gece başlangıcı*'nda uygulanır.
- **AC-39 (Logic) Perde geçişi / Oturum sonu'nda duraklatma.** **WHEN** duraklatma istenir **THEN** durum değişmez, *Duraklatıldı*'ya girilmez.
- **AC-40 (Logic) Geçersiz geçiş.** **GIVEN** *Kapı açık*, gun_sayaci = N **WHEN** dışarıdan gün +1, *Perde geçişi*'ne ya da *Gece başlangıcı*'na geçiş istenir **THEN** her biri için durum ve sayaç değişmez, 1 geliştirme hatası.
- **AC-41 (Logic) Çift "bar kırıldı".** **GIVEN** *Kapı açık* **WHEN** aynı çağrı zincirinde 2, ardından *Menü*'de 1 "bar kırıldı" gelir **THEN** "oturum bitti" 1 kez, skor 1 kez hesaplanır, *Menü*'de durum değişmez.

## Open Questions

| # | Soru | Sahibi | Ne zaman |
|---|---|---|---|
| 1 | 0 varışlı gece sayılır mı; art arda boş geceler nasıl önlenir? | Kullanıcı + Varış kuyruğu (4) | Varış kuyruğu GDD'si |
| 2 | Duraklatmadan menüye dönüş: "gece tekrarı" açığı kabul edildi — prototipte gözlenecek; kapatılması gerekirse gece ortası kayıt mı, başka çözüm mü? | Kullanıcı | İlk prototip |
| 3 | "Geliştirme hatası" kancasının biçimi (sinyal / sayaç) — testler buna bağlı | lead-programmer | `/create-architecture` |
| 4 | Varış kuyruğu listesini bekleme süresi (veri değeri) | lead-programmer | Mimari |
| 5 | Kayıt/sil sözleşmesinin ayrıntısı (dosya biçimi, int dönüşümü) | Kaydet / yükle (16) | Kaydet/yükle GDD'si |
| 6 | Bekleyen bayrak kuralı ve olaylar 13 ve 15'in belgelerine de yazılmalı (çift yönlü bağımlılık) | Köyün oturması (13), Sonlar (15) | O GDD'ler |
