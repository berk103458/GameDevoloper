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
| 1 | Oyun durumu ve gün döngüsü | Core | MVP | Designed | design/gdd/oyun-durumu-ve-gun-dongusu.md | — |
| 2 | İçerik veri hattı (inferred) | Core | MVP | Designed | design/gdd/icerik-veri-hatti.md | — |
| 3 | Girdi ve odak gezinmesi (inferred) | Core | MVP | Designed | design/gdd/girdi-ve-odak-gezinmesi.md | 2 |
| 4 | Varış kuyruğu | Gameplay | MVP | Not Started | — | 1, 2, 5 |
| 5 | Karakter kadrosu | Gameplay | MVP | Designed | design/gdd/karakter-kadrosu.md | 1, 2 |
| 6 | Sohbet | Gameplay | MVP | Not Started | — | 2, 5 |
| 7 | Karar | Gameplay | MVP | Not Started | — | 5, 6, 8, 9, 10 |
| 8 | Barlar | Gameplay | MVP | Not Started | — | 1, 2 |
| 9 | Rüşvet hakları | Gameplay | MVP | Not Started | — | 1, 2 |
| 10 | Köy nüfusu | Gameplay | MVP | Not Started | — | 1, 2 |
| 11 | Köy yapıları | Gameplay | Vertical Slice | Not Started | — | 2, 10 |
| 12 | Köy üretimi | Economy | Vertical Slice | Not Started | — | 10, 11 |
| 13 | Köyün oturması ve ağalık geçişi | Progression | Vertical Slice | Not Started | — | 1, 8, 10, 12 |
| 14 | İkinci perde savunması | Gameplay | Vertical Slice | Not Started | — | 1, 8, 9, 10, 13 |
| 15 | Sonlar | Narrative | Alpha | Not Started | — | 1, 2, 8, 10, 13, 14, 21 |
| 16 | Kaydet / yükle (inferred) | Persistence | MVP | Not Started | — | 1, 4, 5, 8, 9, 10 |
| 17 | Ayarlar ve erişilebilirlik | Persistence | MVP (kısmi) + Vertical Slice | Designed | design/gdd/ayarlar-ve-erisilebilirlik.md | 2, 3 |
| 18 | Sohbet ve karar arayüzü | UI | MVP | Not Started | — | 3, 6, 7 |
| 19 | HUD | UI | MVP | Not Started | — | 1, 8, 9 |
| 20 | Köy görünümü | UI | Vertical Slice | Not Started | — | 1, 5, 7, 10, 11 |
| 21 | Menüler ve son ekranı | UI | Vertical Slice | Not Started | — | 1, 3, 16, 17 |
| 22 | Ses | Audio | Vertical Slice | Designed (uygulandı) | design/gdd/ses.md | 1, 16, 17, 25, 26 |
| 23 | Heybe ve rüşvet | Gameplay | Vertical Slice | Designed (uygulandı) | design/gdd/heybe-ve-rusvet.md | 2, 6, 7, 8, 12, 18 |
| 24 | İş yerleri | Gameplay | Vertical Slice | Yerine geçti (31) | design/gdd/is-yerleri.md | 7, 8, 10, 11, 18 |
| 25 | Sıra olayları | Gameplay | Vertical Slice | Designed (uygulandı) | design/gdd/sira-olaylari.md | 8, 18 |
| 26 | Tarla ve ürünler | Economy | Vertical Slice | Yerine geçti (31) | design/gdd/tarla-ve-urunler.md | 10, 12, 16, 20 |
| 27 | Köy gelişimi | Economy | Vertical Slice | Yerine geçti (31) | design/gdd/koy-gelisimi.md | 8, 10, 11, 20, 26 |
| 28 | Köy içi olaylar ve mini oyunlar | Gameplay | Vertical Slice | Designed (uygulandı) | design/gdd/koy-mini-oyunlari.md | 8, 12, 16, 20, 22 |
| 29 | Karakter sayfaları (CHR_001–030) | Narrative | Vertical Slice | Designed (uygulandı) | design/gdd/karakter-sayfalari.md | 7, 8, 18 |
| 30 | Kapı manzarası | UI | Vertical Slice | Designed (uygulandı) | design/gdd/kapi-manzarasi.md | 11, 18, 22, 25 |
| 31 | Köy yönetimi (2. aşama) | Economy | 2. Aşama | In Design (çekirdek, kapı ve köy arayüzü uygulandı) | design/gdd/koy-yonetimi.md | 7, 8, 10, 11, 16, 20, 26, 27 |

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
| Design docs started | 5 |
| Design docs reviewed | 0 |
| Design docs approved | 0 |
| MVP systems designed | 4/13 |
| Vertical Slice systems designed | 0/8 |

---

## Next Steps

- [x] Sistem listesi, bağımlılıklar ve öncelikler onaylandı (4 Ekim 2026)
- [ ] MVP sistemlerini tasarla (`/design-system [system-name]`), sırayla; ilki: Oyun durumu ve gün döngüsü
- [ ] Her biten tasarım belgesi için `/design-review`
- [ ] MVP tasarımları bitince `/gate-check technical-setup`
- [ ] En riskli sistemleri (Sohbet, Karar, Karakter kadrosu) `/prototype` ile erkenden dene

## Derin ekonomi uzantıları

- EKO-03 [Çeki lojistiği](ceki-lojistigi.md): uygulandı; ANI-04/TUC-02 ayrı paket.
- EKO-04 [Tahıl zinciri](tahil-zinciri.md): uygulandı; gerçek gece, UI ve kayıt kontrolleri geçti.

- [Taş/kireç/harç zinciri](harc-zinciri.md): EKO-05 gerçek üretim, taş ev ve son sur taksiti malzemeleri.

- [Demir ve alet zinciri](demir-alet-zinciri.md): EKO-06 madencilik, ocak ve aletsiz verim/aşınma.

- [Muhafız maaşları](muhafiz-maaslari.md): EKO-07 kamu maaşı/borç, kışla ve güvenlik/rüşvet riski.

- [Vergi politikası](vergi-politikasi.md): EKO-08 vergi, Moral ve hazineden ayrı ekonomik Refah.

- [Tüketim dengesi](tuketim-dengesi.md): EKO-09 nüfus/iklim ortak hesap, MEV-11 adaptörü.

- [Kamu iflası](iflas.md): EKO-10 üç negatif gece ve iadesiz kamu varlığına el koyma.

- [Kişisel kese](kisisel-kese.md) — EKO-11; kamu/kişisel HUD ayrımı.

- [Ambar bakımı](ambar-bakimi.md) — EKO-12; kapasite daralması ve gecelik gıda ziyanı.

- [Alet aşınması](alet-asinmasi.md) — EKO-13; mevcut adaptör, son alet geçişi ve salt okunur HUD.

- [Kasa transferi](kasa-transferi.md) — EKO-14; acil kurtarma ve bedelli günlük zimmet.

- [Gece bilançosu](gece-bilancosu.md) — EKO-15; gerçek kamu/kişisel ve stok mutabakat sözlüğü.

- [Muhafız donanımı](muhafiz-donanimi.md) — ANI-01: mevcut el soketleri, gece meşalesi ve sınırlı dinamik ışık.

- [Muhafız devriyesi](muhafiz-devriyesi.md) — ANI-02: mevcut A* üzerinde kapı/kışla/sur nöbet döngüsü.

- [Su taşıma rutini](sulama-rutini.md) — ANI-03: mevcut halk kuyruğunda kuyu/kova/su arkı döngüsü.

- [Oduncu ve öküz rotası](oduncu-rutini.md) — ANI-04: mevcut EKO-02/03 üstünde görsel balta/tomruk rotası.

- [Çoban ve sürü](coban-surusu.md) — ANI-05: CHR ağıl, kapı ve aynı A* üzerinde otlak/dönüş döngüsü.

- [Değirmen çarkı ve çuval](degirmen-hareketi.md) — ANI-06: gerçek çalışma koşullarıyla çark ve taşıma görseli.

- ANI-07: [Ateş başı ritüeli](ates-basi-ritueli.md) — mevcut ateş, ayrı A* durakları, gerçek iskelette ısınma.

- ANI-08: [Zanaat tezgâhı](zanaat-tezgahi.md) — gerçek reçete koşulları, mevcut el soketi, kutu yer tutucuları.

- ANI-09: [Karakter hava tepkileri](karakter-hava.md) — mevcut iklimde yağmur/kar; A* saçak, yürüyüş hızı, aynı gövde modifieri.

- ANI-10: [Sinsi gece](sinsi-gece.md) — salt görsel kuytu/kaçış; mevcut A* ve riskler.

- ANI-11: [Karakter ekipman soketi](karakter-ekipman.md) — mevcut zanaat aleti, tek BoneAttachment3D ve salt görsel stok.

- ANI-12: [Bekleme çeşitliliği](bekleme-cesitliligi.md) — kimlikten faz ofseti ve mevcut modifierde üç idle yer tutucusu.

- ANI-13: [Köy zemin navigasyonu](koy-zemin-navigasyonu.md) — patika A* sırası, bina dışı NavigationRegion3D koridorları.

- ANI-14: [Köylü takibi](koylu-takibi.md) — aynı kamera, mevcut köylü kartı seçimi ve tek billboard durum etiketi.

- ANI-15: [Atölye parçacıkları](atolye-parcaciklari.md) — mevcut çalışma varışı, düşük CPU bütçesi, uzaklık LOD ve mevcut düşük grafik profili.

- TUC-01: [Gezgin tüccar takvimi](gezgin-tuccar-takvimi.md) — mevcut kervan, dört gün varış ve iki gün konaklama.

- TUC-02: [Celep Hamdullah](celep-hamdullah.md) — tek hayvan kaydı, uzman takvimi ve ahır/ağıl alımı.

- TUC-03: [Nalbur stoğu](nalbur-stogu.md) — ziyaretlik sonlu ürün, tek ambar ve mevcut kaynak HUD.

- TUC-04: [Kumaşçı ve Aktar](kumas-aktar.md) — ortak stoktan mevcut tedavi desteği ve oyuncu kontrollü Refah dağıtımı.

- TUC-05: [Sipariş sözleşmeleri](siparis-sozlesmeleri.md) — mevcut ziyaretten teklif, kabul ve kalıcı tek defter.

- TUC-06: [Sipariş teslimatı](siparis-teslimati.md) — tek kamu ödülü, tüccara özgü itibar ve sonraki sadakat stoğu.

- [Sipariş ihlali ve ceza faizi](siparis-ihlali.md) — TUC-07, tek defter ve kamu borcu.

- [Gezgin silah tüccarı ve karaborsa](silah-karaborsasi.md) — TUC-08, mevcut ambar ve nüfus.

- [Mevsimsel ticaret fiyatları](ticaret-fiyatlari.md) — TUC-09, ortak tahsilat/gösterim.

- [Pazar satışında kasa hedefi](pazar-satisi.md) — TUC-10, mevcut çift kasa/zimmet.

- [Kişisel karaborsa ve muhafız odası](kisisel-karaborsa.md) — TUC-11, tek kişisel envanter.

- [Tüccar kapı geçişi](tuccar-kapi-gecisi.md) — TUC-12, tek ziyaret makbuzu ve mevcut çift kasa.

- [Sipariş muhafız komisyonu](siparis-komisyonu.md) — TUC-13, mevcut teslimat ve zimmet.

- [Canlı hayvan takası](canli-hayvan-takasi.md) — TUC-14, aynı sürü/kayıt ve sınırlı üretim katkısı.

- [Kervan koruması](kervan-korumasi.md) — TUC-15, süreli aynı kışla görevi ve geçici güvenlik katkısı.

- [Dört mevsim döngüsü](mevsim-dongusu.md) — MEV-01, mevcut oyun günü ve Takvim uyum adaptörü.

- [Kış soğuğu ve donma](donma-mekanigi.md) — MEV-02, tek yakacak hesabı ve sınırlı sağlık eşiği.

- [Donmuş toprak](donmus-toprak.md) — MEV-03, mevcut tarım duruşu ve bahar dönüşünün kabul kanıtı.

- [Mevsim kar örtüsü](mevsim-kar-ortusu.md) — MEV-04, mevcut yağış ve kademeli zemin/çatı karı.

- [Çatı kar bakımı](cati-kar-bakimi.md) — MEV-05, ağır kar yükü, boş iş gücü ve aynı bina kaldırma API.

- [İlkbahar taşkını](ilkbahar-taskini.md) — MEV-06, mevcut sağlık ve olay kartında bent/kuyu onarımı.

- [Yaz su dengesi ve kıvılcım](yaz-su-yangin.md) — MEV-07, aynı kuyu/ambar/pazar ve iadesiz yapı kaybı.

- [Hasat şenliği](hasat-senligi.md) — MEV-08, dolu erzak ambarında yıllık mevcut moral dopingi.

- [Kapı görüşü](kapi-gorusu.md) — MEV-09, mevcut CHR görsel izinde tipi/sis bulanıklığı.

- [Kış kurt baskını](kurt-baskini.md) — MEV-10, tek gerçek gece ve mevcut ağıl nöbeti.

- [Mevsim takvim HUD](mevsim-takvim.md) — MEV-12, mevcut tek etikette yıl günü/hava.

- [Soğuk hastalık baskısı](kis-hastaligi.md) — MEV-13, mevcut üretim/sağlık ve ortak şifahane slotu.

- [Kış samanı ve sürü kaybı](saman-bakimi.md) — MEV-14, tek ortak ambar ve mevcut gerçek hayvan sayaçları.

- [Fırtınada kapı bekleyişi](kapi-firtina-kuyrugu.md) — MEV-15, aynı gelen listesi ve tansiyon motoru.

- [Köy içi gece takip motoru](casus-gece-takibi.md) — CAS-01, gizli niyet ve gözlenen mevcut fiilin tek kaydı.

- [Gece devriyesi ve suçüstü tutanağı](casus-devriyesi.md) — CAS-02, mevcut meşale ve tek olay kartında gerçek fiil gözlemi.

- [Kuyu zehirleme ve sabah tespiti](kuyu-zehirleme.md) — CAS-03, CHR gecikmeli kaynak sonucu tek gerçek kuyu/sağlık fiili.

- [Ambar kundaklaması ve suyla söndürme](ambar-kundaklamasi.md) — CAS-04, kaynak fiili aynı yangın/rezerv/iadesiz yapı akışında.

- [Muhafız Divanı / meydan duruşması](muhafiz-divani.md) — CAS-05, mevcut tek meydanda gözlenmiş fiil inceleme sahnesi.

- [Divanda kanıt sunma ve sorgulama](divan-kanit-sorgusu.md) — CAS-06, gerçek kapı Clue kaydının tek kalıcı devamı ve gerçek fiil sorgusu.

- [Üçlü divan hükmü](divan-hukmu.md) — CAS-07, tek makbuz ve gerçek nüfus sonuçları.
- [Karaboran intikam baskını](karaboran-intikami.md) — CAS-08, zindan hükmünün üçüncü gecesinde tek ortak husumet sonucu.
- [Fısıltı gazetesi ve imzasız pusula](fisilti-gazetesi.md) — CAS-09, mevcut sabah kartında kanıt sayılmayan iddia.
- [Haksız yargı ve tazminat](divan-haksizligi.md) — CAS-10, ayrı kanıtsız dava ve tek kamu onarımı.
- [Clue–Divan tek devam sözleşmesi](clue-divan-sozlesmesi.md) — CAS-11/CAS-15, tüm30 CHR ve tek keşif/devam sahiplik sözleşmesi.
- [Kuyu zehri Clue/Flag sözleşmesi](zehir-clue-sozlesmesi.md) — CAS-12, kaynak kimliği ve gerçek kapı bayrak snapshotu.
- [Kundaklama Clue/Flag sözleşmesi](kundak-clue-sozlesmesi.md) — CAS-13, ortak helper ve mevcut bina kartında gerçek bulunan yük.

- [Divan kanıt kartları](divan-kanit-kartlari.md) — CAS-14, aynı listede kaynak açıklaması ve mevcut sunma işlemi.

- [Muhafız odası](muhafiz-odasi.md) — ODA-01, bağımsız kutu iç mekân ve mevcut köyden ince modal bağlantısı.

- [Gizli zemin kasası](oda-kasasi.md) — ODA-02, mevcut EKO kişisel kesenin aynı oda yüzeyi.

- [Kişisel eşya sergisi](oda-envanter-sergisi.md) — ODA-03, tek Oturum envanteri, sınırlı kutu önizleme ve kaydırılabilir oda listesi.

- [Muhafız terazisi](muhafiz-terazisi.md) — ODA-04, mevcut adalet/rüşvet/zimmet/haksızlık makbuzlarından saf görünüm.

- [Yozlaşma yetenekleri](yozlasma-yetenekleri.md) — ODA-05, tek kalıcı seçim, kişisel rüşvet bonusu ve günlük gerçek esnaf tahsilatı.

- [Adalet yetenekleri](adalet-yetenekleri.md) — ODA-06, aynı seçim ağacı, mevcut heybe keşfi ve isyan eşiği.

- [Sancak teftişi](sancak-teftisi.md) — ODA-07, mevcut kişisel kasa/yozlaşma, tek gece makbuzu ve aynı terminal akışı.

- [Oda geliştirmeleri](oda-gelistirmeleri.md) — ODA-08, tek kişisel yorgunluk ve günlük dinlenme, mevcut sorguda etkin tecrübe.

- [Muhafız vicdanı](muhafiz-vicdani.md) — ODA-09, gerçek ret/ölüm, tek kabus/yorgunluk ve rüya kutusu.

- [Muhafız epilogu](muhafiz-epilogu.md) — ODA-10/15, mevcut terazi/kasa ile aynı son ekranında bağımsız kader.

- [Rüşvet → oda kasası sözleşmesi](oda-rusvet-kasa-sozlesmesi.md) — ODA-11, mevcut EKO01/11 ve ODA02 tek muhasebe denetimi.

- [Tek yozlaşma runtime sözleşmesi](yozlasma-runtime-sozlesmesi.md) — ODA-12, mevcut tek terazi ve kalıcı kaynak makbuzları.

- [Teftiş save/state sözleşmesi](teftis-kayit-sozlesmesi.md) — ODA-13, yüklenen tek state, izole slot ve güvenli yedek denetimi.

- [Ortak kişisel kese göstergesi](oda-kese-gosterge-sozlesmesi.md) — ODA-14, mevcut EKO11/ODA02 tek bakiye ve ortak sınıf.

- [Şematik çevre haritası](cevre-haritasi.md) — HAR-01, mevcut köyden tek modal ve dört salt okunur bölge.

- [Moğol öncü tehdidi](mogol-oncusu.md) — HAR-02, gerçek gün kalan süre ve tek typed gece uyarısı.

- [Tekfur haraç heyeti](tekfur-harac-heyeti.md) — HAR-03, mevcut altı günlük bant ve kamu akçesi/buğday ödemesi.

- [Sancak asker toplama fermanı](sancak-asker-talebi.md) — HAR-04, mevcut kartta gerçek iş gücü/açık iş reddi seçimi.

- [Göç yolu güvenliği](goc-yolu-guvenligi.md) — HAR-05, gerçek husumet temizliği ve aynı kuyruğa ek ziyaret.

- [Gözcü kulesi ve erken uyarı](gozcu-kulesi.md) — HAR-06, mevcut maliyetli tür ve saf ertesi gün öngörüsü.

- [Ertuğrul Obası ittifakı](oba-ittifaki.md) — HAR-07, aynı Pazar ve gerçek buğday/at/alp takası.

- [Dağ çetesiyle süreli anlaşma](cete-anlasmasi.md) — HAR-08, mevcut ganimet kaybında kamu ödemeli süreli koruma.
