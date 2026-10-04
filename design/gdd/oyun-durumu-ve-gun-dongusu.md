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
| **Gece sonu** | Gece tamamlandı | *Kapı açık* | Gün +1; otomatik kayıt; "köy oturdu" bildirildiyse ve Perde 1'deysek → *Perde geçişi*; bir son tetiklendiyse → *Oturum sonu*; değilse → *Gece başlangıcı* |
| **Perde geçişi** | Ağalığa geçiş anı (sanat kitabı 2.6) | *Gece sonu* | Perde = 2 → *Gece başlangıcı* |
| **Oturum sonu** | Skor gösterilir | *Kapı açık* (bar kırıldı) ya da *Gece sonu* (son tetiklendi) | Menüye dönüş → *Menü* |
| **Duraklatıldı** | Üst durum: zaman durdu | *Gece başlangıcı*, *Kapı açık*, *Gece sonu* | Devam → önceki durum; menüye dön → *Menü* (kayıtsız çıkış, açık soru) |

Geçersiz geçişler (ör. *Kapı açık* iken gün +1) reddedilir ve geliştirme sürümünde hata olarak kaydedilir.

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
| Kaydet / yükle (16) | Gün, perde, durum (*Gece başlangıcı*'nda) | Yüklenen gün ve perde | Kaydet / yükle |
| HUD (19) | Gün sayacı | — | HUD |
| Menüler ve son ekranı (21) | Skor, oturum sonu olayı | Yeni oyun / devam / menüye dön | Menüler |
| Ses (22) | Durum değişimi olayları | — | Ses |

## Formulas

[To be designed]

## Edge Cases

[To be designed]

## Dependencies

[To be designed]

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
