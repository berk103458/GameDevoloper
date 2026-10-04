# Oyun durumu ve gün döngüsü

> **Status**: In Design
> **Author**: kullanıcı + Claude
> **Last Updated**: 2026-10-04
> **Last Verified**: 2026-10-04
> **Implements Pillar**: Yorgun gece; Köy senin aynan

## Summary

[To be designed]

> **Quick reference** — Layer: `Foundation` · Priority: `MVP` · Key deps: `None`

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
8. **Duraklatma** zamanı durdurur ama durum değiştirmez; gecenin herhangi bir aşamasında açılabilir.

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
- **If aynı karede birden fazla "bar kırıldı" gelirse ya da bildirim *Oturum sonu* / *Menü*'deyken gelirse**: ilki işlenir, gerisi yok sayılır; skor bir kez hesaplanır.

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
- **If yüklenen kayıtta gun_sayaci negatifse, tam sayı değilse ya da perde 1 veya 2 değilse**: kayıt reddedilir, *Menü*'de kalınır, geliştirme sürümünde hata; sessiz düzeltme yok.

**Boş kuyruk**
- **If gece başında kuyruk boşsa (0 varış)**: durumlar atlanmaz (*Gece başlangıcı → Kapı açık → Gece sonu*); "kuyruk boşaldı" olayı *Kapı açık*'a girildikten sonra yayınlanır. Boş gecenin sayılıp sayılmayacağı ve art arda boş gecelerin önlenmesi **açık soru** — Varış kuyruğu (4) tasarlanırken birlikte karara bağlanacak.
- **If Varış kuyruğu gecenin listesini hiç vermezse**: *Gece başlangıcı*'nda kalınır; geliştirme hatası olarak kaydedilir.

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

[To be designed]

## Game Feel

[To be designed]

## UI Requirements

[To be designed]

## Cross-References

[To be designed]

## Acceptance Criteria

[To be designed]

## Open Questions

[To be designed]
