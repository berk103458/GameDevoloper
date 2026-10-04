# Systems Index: (ad yok)

> **Status**: Draft
> **Created**: 2026-10-04
> **Last Updated**: 2026-10-04
> **Source Concept**: design/gdd/game-concept.md (kilit: design/gdd/kapi-konsept.md)
>
> **Review gates (lean mode):** TD-SYSTEM-BOUNDARY, PR-SCOPE ve CD-SYSTEMS atlandı — lean mod. Yüksek riskli sistemler aşağıda ayrıca listelenmiştir.

---

## Overview

Oyun, kapıda geçen kısa bir sohbet-ve-karar döngüsü etrafında kurulu: kapıya biri gelir, oyuncu önce konuşur (sohbet), sonra karar verir; içeri alınanlar asker, esnaf ve çiftçi olarak sıfırdan bir köy kurar. Köy oturunca oyuncu ağa olur, kapı sade bir filtreye dönüşür ve Tekfur'a karşı savunma başlar. Mekanik kapsam bu yüzden üç kümeye ayrılır: (1) kapıdaki konuşma ve karar sistemleri, (2) kararların değiştirdiği durum — barlar, rüşvet hakları, köy nüfusu, yapılar, üretim — ve (3) perde geçişi, savunma ve sonlar. Kapsam sınırı kilitle çizilmiştir: bina yerleştirme, yol ve kaynak zinciri yok; birinci perdede refleks yok; kartta iyi ya da kötü etiketi yok; tek mutlak son yok. Kilitte "Açık" olan konular (sonların adı ve koşulu, yedi sekiz karakterin adı, köyün oturduğu eşik, sohbet adım sayısı, bar etiketleri) bu belgede doldurulmamıştır.

**Sistemler (kısa not):**
1. **Oyun durumu ve gün döngüsü** — gün sayacı, gecelerin akışı, skor = hayatta kalınan gün; diğer her sistemin bağlandığı durum çekirdeği.
2. **İçerik veri hattı** — karakter, sohbet ve bar verisi ile yerelleştirme anahtarları; "oynanış değerleri koddan değil veriden gelir" kuralının uygulaması. Çıkarım.
3. **Girdi ve odak gezinmesi** — klavye, fare ve gamepad; odak sırası, B/Esc'in "ret" olmaması (Bölüm 7.10).
4. **Varış kuyruğu** — geceleri kimin geldiği ve geri dönüş kuralları (biri bir orana göre döner, biri hiç dönmez, biri birden fazla gelir).
5. **Karakter kadrosu** — adlı özel karakterler ve adsız sınıf figürleri; Miraen, Sorhan, Thessra özel olabilir, yanlarına yedi sekiz özgün karakter gelecek (adları yok).
6. **Sohbet** — "kimsin, nesin, kendini tanıt" gibi diyalog seçimleri; karar sohbetten sonra gelir; anlatı ile konuşma ayrıdır, kimse seçeneğin sonucunu söylemez.
7. **Karar** — dört düğme (kabul, ret, rüşvet, kışla; sonra değişecek), karaktere göre farklı seçenekler, iki adımlı onay.
8. **Barlar** — kırılan bar kaybettirir; etiketler (Halk, Soylular, Tüccarlar, Ordu) onaylanmadı.
9. **Rüşvet hakları** — üç hak; muhafız yetmezse kullanılır.
10. **Köy nüfusu** — asker, esnaf, çiftçi sayıları; içeri alınanlar buraya yazılır.
11. **Köy yapıları** — yalnız kervansaray ve pazar.
12. **Köy üretimi** — çiftçi gıdayı köye doğrudan kazandırır (kervansaraya ya da pazara yazmaz); esnaf ve asker katkısı açık.
13. **Köyün oturması ve ağalık geçişi** — köy oturunca oyuncu ağa olur; elli oyun günü eşiği örnektir, kilit değildir.
14. **İkinci perde savunması** — kapı sade filtre; şimdiki demoda savunma ayrı bir savaş haritası değil: kırılan bar, muhafız yetmezse üç rüşvet hakkı, skor hayatta kalınan gün.
15. **Sonlar** — birkaç son; Osmanoğullarına katılmak sonlardan biri, tek son değil; adlar ve koşullar boş.
16. **Kaydet / yükle** — gün, nüfus, barlar, haklar ve kadro durumunun kalıcılığı. Çıkarım.
17. **Ayarlar ve erişilebilirlik** — metin ölçeği, iki adımlı onayı aç/kapa, azaltılmış hareket, belirme hızı, tuş atama, ekran modu (Bölüm 7.9).
18. **Sohbet ve karar arayüzü** — Bölüm 7.2–7.3'teki yerleşim, durum grameri ve iki adımlı onay.
19. **HUD** — barlar, üç rüşvet kesesi, gün sayacı (Bölüm 7.1, 7.6).
20. **Köy görünümü** — meşale sayısı, kabul izleri, reddedilenin uzak ateşi (Bölüm 6.4–6.5).
21. **Menüler ve son ekranı** — ana menü, duraklatma, ayarlar ekranı, skor ekranı (Bölüm 7.9).
22. **Ses** — ortam sesi, bar çatlama sesi (renk körlüğü için zorunlu yedek sinyal, Bölüm 4.5), arayüz sesleri. Çıkarım.

---

## Systems Enumeration

| # | System Name | Category | Priority | Status | Design Doc | Depends On |
|---|-------------|----------|----------|--------|------------|------------|
| 1 | Oyun durumu ve gün döngüsü | Core | MVP | Not Started | — | — |
| 2 | İçerik veri hattı (inferred) | Core | MVP | Not Started | — | — |
| 3 | Girdi ve odak gezinmesi (inferred) | Core | MVP | Not Started | — | — |
| 4 | Varış kuyruğu | Gameplay | MVP | Not Started | — | 1, 2, 5 |
| 5 | Karakter kadrosu | Gameplay | MVP | Not Started | — | 2 |
| 6 | Sohbet | Gameplay | MVP | Not Started | — | 2, 5 |
| 7 | Karar | Gameplay | MVP | Not Started | — | 5, 6, 8, 9, 10 |
| 8 | Barlar | Gameplay | MVP | Not Started | — | 1, 2 |
| 9 | Rüşvet hakları | Gameplay | MVP | Not Started | — | 1 |
| 10 | Köy nüfusu | Gameplay | MVP | Not Started | — | 1, 2 |
| 11 | Köy yapıları | Gameplay | Vertical Slice | Not Started | — | 2, 10 |
| 12 | Köy üretimi | Economy | Vertical Slice | Not Started | — | 10, 11 |
| 13 | Köyün oturması ve ağalık geçişi | Progression | Vertical Slice | Not Started | — | 1, 8, 10, 12 |
| 14 | İkinci perde savunması | Gameplay | Vertical Slice | Not Started | — | 1, 8, 9, 10, 13 |
| 15 | Sonlar | Narrative | Alpha | Not Started | — | 1, 2, 8, 10, 13, 14, 21 |
| 16 | Kaydet / yükle (inferred) | Persistence | MVP | Not Started | — | 1, 4, 5, 8, 9, 10 |
| 17 | Ayarlar ve erişilebilirlik | Persistence | Vertical Slice | Not Started | — | 3 |
| 18 | Sohbet ve karar arayüzü | UI | MVP | Not Started | — | 3, 6, 7 |
| 19 | HUD | UI | MVP | Not Started | — | 1, 8, 9 |
| 20 | Köy görünümü | UI | Vertical Slice | Not Started | — | 1, 5, 7, 10, 11 |
| 21 | Menüler ve son ekranı | UI | Vertical Slice | Not Started | — | 1, 3, 16, 17 |
| 22 | Ses (inferred) | Audio | Vertical Slice | Not Started | — | 1, 7, 8, 17 |

*Kategoriler arasında şablonun "Meta" kategorisi kullanılmadı.*

---

## Categories

| Category | Description | Systems |
|----------|-------------|---------|
| **Core** | Her şeyin bağlandığı temel | 1, 2, 3 |
| **Gameplay** | Oyunu oyun yapan sistemler | 4–11, 14 |
| **Progression** | Köyün ağalığa doğru ilerlemesi | 13 |
| **Economy** | Köyün kaynağı | 12 |
| **Persistence** | Kayıt ve ayarlar | 16, 17 |
| **UI** | Oyuncuya dönük bilgi ve etkileşim | 18–21 |
| **Audio** | Ses | 22 |
| **Narrative** | Sonlar | 15 |

---

## Priority Tiers

| Tier | Definition | Target Milestone | Design Urgency |
|------|------------|------------------|----------------|
| **MVP** | Çekirdek soru için gerekli: kapıda konuşup karar vermek birkaç gece boyunca ilgi çekici mi? Kilitteki demo tanımı (kırılan bar, üç rüşvet hakkı, skor = hayatta kalınan gün) bu sistemlerle çalışır; kaydet/yükle de buradadır. | İlk oynanabilir prototip | FIRST |
| **Vertical Slice** | Birinci perdenin tamamı, ağalığa geçiş ve savunma; köy görünümü, ses, ayarlar ve menüler. | Vertical slice / demo | SECOND |
| **Alpha** | Sonlar (içerik şu an boş). | Alpha | THIRD |
| **Full Vision** | Cila ve ek içerik — şimdilik boş. | Beta / Release | As needed |

*Ayarlar (17) MVP'de yoktur: MVP'de arayüz varsayılan değerlerle çalışır (iki adımlı onay açık), Ayarlar Vertical Slice'ta bu değerleri değiştirilebilir yapar.*

---

## Dependency Map

### Foundation Layer (no dependencies)
1. **Oyun durumu ve gün döngüsü (1)** — gün, gece ve skor çekirdeği.
2. **İçerik veri hattı (2)** — tüm değerlerin ve metinlerin geldiği yer.
3. **Girdi ve odak gezinmesi (3)** — tüm etkileşimin girişi.

### Core Layer (depends on foundation)
1. **Karakter kadrosu (5)** — depends on: 2
2. **Barlar (8)** — depends on: 1, 2
3. **Rüşvet hakları (9)** — depends on: 1
4. **Köy nüfusu (10)** — depends on: 1, 2
5. **Ayarlar ve erişilebilirlik (17)** — depends on: 3
6. **Varış kuyruğu (4)** — depends on: 1, 2, 5
7. **Sohbet (6)** — depends on: 2, 5
8. **Köy yapıları (11)** — depends on: 2, 10

### Feature Layer (depends on core)
1. **Karar (7)** — depends on: 5, 6, 8, 9, 10
2. **Köy üretimi (12)** — depends on: 10, 11
3. **Köyün oturması ve ağalık geçişi (13)** — depends on: 1, 8, 10, 12
4. **İkinci perde savunması (14)** — depends on: 1, 8, 9, 10, 13
5. **Kaydet / yükle (16)** — depends on: 1, 4, 5, 8, 9, 10

### Presentation Layer (depends on features)
1. **HUD (19)** — depends on: 1, 8, 9
2. **Sohbet ve karar arayüzü (18)** — depends on: 3, 6, 7
3. **Köy görünümü (20)** — depends on: 1, 5, 7, 10, 11
4. **Menüler ve son ekranı (21)** — depends on: 1, 3, 16, 17
5. **Ses (22)** — depends on: 1, 7, 8, 17

### Polish Layer (depends on everything)
1. **Sonlar (15)** — depends on: 1, 2, 8, 10, 13, 14, 21 (son ekranı üzerinden gösterilir)

**Darboğazlar** (çok sistem bunlara bağlı): Oyun durumu (1), İçerik veri hattı (2), Köy nüfusu (10), Barlar (8), Karar (7).
**Yapraklar** (hiçbir sistem bunlara bağlı değil, geç tasarlanabilir): Sonlar (15), Menüler ve son ekranı (21 — yalnız 15 hariç), Ses (22), HUD (19), Köy görünümü (20).

---

## Recommended Design Order

| Order | System | Priority | Layer | Agent(s) | Est. Effort |
|-------|--------|----------|-------|----------|-------------|
| 1 | Oyun durumu ve gün döngüsü (1) | MVP | Foundation | game-designer, systems-designer | M |
| 2 | İçerik veri hattı (2) | MVP | Foundation | lead-programmer, game-designer | M |
| 3 | Girdi ve odak gezinmesi (3) | MVP | Foundation | ux-designer, ui-programmer | S |
| 4 | Karakter kadrosu (5) | MVP | Core | game-designer, narrative-director | L |
| 5 | Barlar (8) | MVP | Core | systems-designer | M |
| 6 | Rüşvet hakları (9) | MVP | Core | systems-designer | S |
| 7 | Köy nüfusu (10) | MVP | Core | systems-designer | M |
| 8 | Varış kuyruğu (4) | MVP | Core | game-designer | M |
| 9 | Sohbet (6) | MVP | Core | game-designer, narrative-director | L |
| 10 | Karar (7) | MVP | Feature | game-designer, ux-designer | L |
| 11 | Kaydet / yükle (16) | MVP | Feature | lead-programmer | M |
| 12 | HUD (19) | MVP | Presentation | ux-designer, ui-programmer | S |
| 13 | Sohbet ve karar arayüzü (18) | MVP | Presentation | ux-designer, ui-programmer | M |
| 14 | Ayarlar ve erişilebilirlik (17) | Vertical Slice | Core | ux-designer, accessibility-specialist | M |
| 15 | Köy yapıları (11) | Vertical Slice | Core | systems-designer | S |
| 16 | Köy üretimi (12) | Vertical Slice | Feature | systems-designer, economy-designer | M |
| 17 | Köyün oturması ve ağalık geçişi (13) | Vertical Slice | Feature | game-designer, systems-designer | L |
| 18 | İkinci perde savunması (14) | Vertical Slice | Feature | game-designer, systems-designer | L |
| 19 | Köy görünümü (20) | Vertical Slice | Presentation | art-director, ux-designer | M |
| 20 | Menüler ve son ekranı (21) | Vertical Slice | Presentation | ux-designer, ui-programmer | M |
| 21 | Ses (22) | Vertical Slice | Presentation | audio-director, sound-designer | M |
| 22 | Sonlar (15) | Alpha | Polish | narrative-director | L |

*Effort: S = 1 oturum, M = 2–3 oturum, L = 4+ oturum. Tahminlerdir; sohbet, karar ve kadro (L) içerik hacmi netleşince değişir.*

---

## Circular Dependencies

Döngü yok. Dikkat edilen yakın döngüler:
- **Karar ↔ Barlar / Köy nüfusu:** Barlar ve nüfus durum tutar; Karar bunlara yazar. Onlar Karar'ı tanımaz (tek yön).
- **Köy görünümü ↔ Karar:** Köy görünümü kabul ve ret izlerini oyun durumundan okur; Karar'a doğrudan bağlı değildir (bağ yalnız 7 → durum → 20 üzerinden).
- **Menüler ↔ Sonlar:** Sonlar son ekranı üzerinden gösterilir (15 → 21); son ekranı yalnız skoru bilir.
- **Arayüz ↔ Ayarlar:** MVP'de arayüz varsayılan değerlerle çalışır; Ayarlar (Vertical Slice) bu değerleri değiştirilebilir yapar (yumuşak bağ, 18 → 17 yok).

---

## High-Risk Systems

| System | Risk Type | Risk Description | Mitigation |
|--------|-----------|-----------------|------------|
| Sohbet (6) | Design | Sohbet adım sayısı açık; her karakterde tekrarlayıcı hissedebilir | `/prototype` ile erken dene; adım sayısını veriyle ayarlanabilir tut |
| Karar (7) | Design | Seçenekler karaktere göre değişiyor; dört düğme "sonra değişecek"; iki adımlı onay "refleks yok" ilkesine yaslanıyor | Düğme sayısından bağımsız tasarla (Bölüm 3.3); prototiple |
| Karakter kadrosu (5) | Scope | Yazı yükü yüksek; geri dönüş kuralları karmaşık; iki kişilik ilk oyun | Önce küçük bir kadro; adsız sınıf figürleri için şablon |
| Köy üretimi (12) | Design | Çiftçi dışındaki katkılar tanımsız | Kilitteki kuralı (çiftçi doğrudan gıda) başlangıç al; gerisini `/design-system` sırasında kullanıcıya sor |
| Köyün oturması (13) | Design | Eşik açık (elli gün yalnız örnek) | Veriyle ayarlanabilir eşik; prototipte dene |
| Sonlar (15) | Scope | Adlar ve koşullar boş; kapsam büyüyebilir | Alpha'ya ertelendi; kullanıcı kararı gerektirir |
| İçerik veri hattı (2) | Technical | Her şey buradan okunacak, bir kez kurulunca değiştirmesi pahalı; Godot 4.7'ye yeni | Erken küçük bir kurulum; `docs/engine-reference/godot` ile doğrula |

---

## Progress Tracker

| Metric | Count |
|--------|-------|
| Total systems identified | 22 |
| Design docs started | 0 |
| Design docs reviewed | 0 |
| Design docs approved | 0 |
| MVP systems designed | 0/13 |
| Vertical Slice systems designed | 0/8 |

---

## Next Steps

- [x] Sistem listesi, bağımlılıklar ve öncelikler onaylandı (4 Ekim 2026)
- [ ] MVP sistemlerini tasarla (`/design-system [system-name]`), sırayla; ilki: Oyun durumu ve gün döngüsü
- [ ] Her biten tasarım belgesi için `/design-review`
- [ ] MVP tasarımları bitince `/gate-check technical-setup`
- [ ] En riskli sistemleri (Sohbet, Karar, Karakter kadrosu) `/prototype` ile erkenden dene
