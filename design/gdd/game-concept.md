# Game Concept: (ad yok)

*Created: 2026-10-03 · Revised: 2026-10-04*
*Status: Draft*

> **Kaynak:** `design/gdd/kapi-konsept.md` (Ahmet kilidi, 4 Ekim 2026). Bu belge o kilidi
> CCGS şablonunun başlıklarına dağıtır. Çelişki olursa kilit geçerlidir. Kilitte olmayan
> süre, kitle ve para modeli uydurulmaz; boş alanlar **Açık** olarak işaretlidir.

---

## Elevator Pitch

> Kösedağ'dan (1243) sonra, Moğol baskınından kaçanların sığındığı ıssız bir uçta kapıyı tutan kervan muhafızısın. Gelenle önce konuşursun, sonra karar verirsin. İçeri aldıkların sıfırdan bir köy kurar. Köy oturunca sen ağasın, kapı sade bir filtre olur ve elindekini Tekfur'a karşı savunursun.

---

## Core Identity

| Aspect | Detail |
| ---- | ---- |
| **Genre** | Kapıda konuşma ve karar oyunu + köy; ikinci perdede savunma |
| **Platform** | PC. Godot 4.7.2, GDScript (bkz. Technical Considerations — motor kararı). Konsol, mobil, web ve Steam Deck yok |
| **Target Audience** | Açık |
| **Player Count** | Tek oyunculu |
| **Session Length** | Açık |
| **Monetization** | Yok |
| **Estimated Scope** | Açık |
| **Comparable Titles** | Papers Please, Reigns, Not Tonight, Yes Your Grace, Death and Taxes — yakın oyunlar, kopya değil |

Şu an çevrimdışı demo. Oyunun tamamı 2D (4 Ekim motor kararı).

---

## Setting and Story Lock

- **Dönem:** Kösedağ sonrası uç. Fetret ve Malazgirt bu oyuna girmez.
- **Oyuncu:** Kervan muhafızı.
- **Kapı:** Dış dünyayla tek bağ. Moğol baskınından kaçan insan ve mal kapıdan geçer.
- **Köy:** İçeri alınanlarla ıssız bir yerde kurulur. Halk asker, esnaf ve çiftçidir.
- **Çiftçi:** Gıdayı köye doğrudan kazandırır; kervansaraya ya da pazara yazmaz.
- **Binalar:** Yalnız kervansaray ve pazar.
- **Ahi:** Esnafın yüzü.
- **Düşman:** Tekfur.
- **Özel karakterler:** Miraen, Sorhan ve Thessra özel olabilir; işleri serbest. Yanlarına yedi sekiz özgün karakter daha gelecek (adları yok). Aynı tipten sabit kadro yok. Biri bir orana göre döner, biri hiç dönmez, biri birden fazla gelir.
- **Birinci perde:** Kapı ve köy. Köy oturunca oyuncu ağadır.
- **İkinci perde:** Kapı sade bir filtredir ve savunma başlar.
- **Eşik:** Elli oyun günü örnektir, kilit değildir.
- **Sonlar:** Birkaç son vardır. Osmanoğullarına katılmak sonlardan biridir, tek son değildir. Sonların adı ve koşulu boştur.

---

## Core Fantasy

Yıkılmış bir dünyanın kenarında kapıyı tutan kişi olmak: kimin içeri gireceğine konuşarak karar vermek ve o kararlarla kurulan köyü sonra savunmak.

---

## Unique Hook

Papers Please gibi kapıda karar verirsin, ve ayrıca kararı bir sohbetten sonra verirsin; içeri aldıkların sıfırdan bir köy kurar ve o köyü Tekfur'a karşı savunursun.

---

## Player Experience Analysis (MDA Framework)

### Target Aesthetics

| Aesthetic | Priority | How We Deliver It |
| ---- | ---- | ---- |
| **Narrative** | 1 | Kösedağ sonrası uç, kapıya gelenler, açık sonlar |
| **Discovery** | 2 | Sohbette öğrenilenler; sonuçları kimse söylemez |
| **Fantasy** | 3 | Kervan muhafızından ağaya |
| **Challenge** | 4 | Barların kırılmaması, hayatta kalınan gün |
| **Sensation** | 5 | Kalın mürekkep, tek meşale ışığı |
| **Expression** | N/A | — |
| **Fellowship** | N/A | Tek oyunculu |
| **Submission** | N/A | — |

### Key Dynamics
- Oyuncu sohbette sorduklarıyla kişiyi tanımaya çalışır; seçeneğin sonucu söylenmediği için kendi yorumuna güvenir.
- Oyuncu köyün asker/esnaf/çiftçi dengesini barlar kırılmasın diye gözetir.

### Core Mechanics
1. **Sohbet:** "Kimsin, nesin, kendini tanıt" gibi diyalog seçimleri. Konuşma gündelik Türkçedir; anlatı ile konuşma ayrıdır.
2. **Karar:** Sohbetten sonra gelir. Şimdilik dört düğme (kabul, ret, rüşvet, kışla); sonra değişecek. Her karaktere aynı seçenekler gelmez.
3. **Köy:** Asker, esnaf, çiftçi; kervansaray ve pazar.
4. **Barlar:** Kırılan bar kaybettirir; muhafız yetmezse üç rüşvet hakkı. Bar etiketleri onaylanmadı.
5. **Perde geçişi:** Köy oturunca ağalık ve ikinci perde.

---

## Player Motivation Profile

### Primary Psychological Needs Served

| Need | How This Game Satisfies It | Strength |
| ---- | ---- | ---- |
| **Autonomy** | Sohbette ne sorulacağını ve sonra kararı oyuncu seçer | Core |
| **Competence** | Sonuçlar söylenmeden doğru okumayı öğrenmek; daha çok gün hayatta kalmak | Supporting |
| **Relatedness** | Geri dönen özel karakterler | Supporting |

### Player Type Appeal (Bartle Taxonomy)

- [x] **Explorers** — Sohbetlerde öğrenilenler, farklı sonlar.
- [x] **Achievers** — Hayatta kalınan gün skoru, ağalık.
- [ ] **Socializers** — Tek oyunculu.
- [ ] **Killers/Competitors** — Hedeflenmiyor.

### Flow State Design

Açık — prototip ve sistem tasarımında belirlenecek.

---

## Core Loop

### Moment-to-Moment (30 seconds)
Kapıya biri gelir. Önce sohbet edilir (kimsin, nesin, kendini tanıt). Sonra karar verilir. Seçenekler ekrana bir anda düşmez ve her karakterde aynı değildir.

### Short-Term (5-15 minutes)
Açık.

### Session-Level (30-120 minutes)
Açık.

### Long-Term Progression
Birinci perde: kapı ve köy; köy oturunca ağalık. İkinci perde: kapı sade filtre, savunma. Sonunda birkaç sondan biri.

### Retention Hooks
- **Curiosity:** Kim geri dönecek; sonlar.
- **Investment:** Kurulan köy.
- **Social:** Yok.
- **Mastery:** Hayatta kalınan gün.

---

## Game Pillars

Sıra önem sırasıdır; iki sütun çatışırsa üstteki kazanır.

### Pillar 1: Her kapı bir bedel
Hiçbir karar bedava değildir; içeri aldığın da geri çevirdiğin de bir şeye mal olur.

*Design test*: "Herkes için iyi" bir seçenek ile acı bir takas arasında kalırsak takası seçeriz.

### Pillar 2: Konuşarak karar ver
Karar sohbetten sonra gelir; soru ve cevap oyuncunun aracıdır. Kimse seçeneğin sonucunu söylemez.

*Design test*: Menü mü sohbet mi diye tartışırsak sohbeti seçeriz.

### Pillar 3: Yorgun gece
Ton soğuk ve yorgun; tek sıcak kaynak meşale.

*Design test*: Gösterişli bir efekt ile sade ve kasvetli bir an arasında kalırsak kasvetliyi seçeriz.

### Pillar 4: Köy senin aynan
Köyün bileşimi kapıda verilen kararlardan çıkar.

*Design test*: Rastgele bir olay ile oyuncunun kararının bir sonucu arasında kalırsak sonucu seçeriz.

### Anti-Pillars (What This Game Is NOT)

- **NOT bina yerleştirme, yol ve kaynak zinciri.**
- **NOT birinci perdede refleks.**
- **NOT kartta iyi ya da kötü etiketi.**
- **NOT tek mutlak son.**

---

## Visual Identity Anchor

- **One-line visual rule:** Kalın mürekkep, düz renk, gradyan yok; tek sıcak kaynak meşale.
- **Palette:** Gece `#0D0F14`, meşale `#C4843A`, soğuk mavi `#4A6B8A`, ahşap `#3D2E24`.
- **Figures:** Yorgun yüz, yün kapüşon, keten tunik, deri kemer.
- **Never:** Fotogerçekçi, anime; modern kep, palto, fermuar. Görselde yazı ve rakam yok — yazı ve rakam koddadır.

---

## Inspiration and References

| Reference | Note |
| ---- | ---- |
| Papers Please, Reigns, Not Tonight, Yes Your Grace, Death and Taxes | Yakın oyunlar, kopya değil |

---

## Target Player Profile

Açık.

---

## Technical Considerations

> **Görsel kararı (4 Ekim 2026, kullanıcı):** Oyun 3D sunuma geçti. Modeller Meshy AI ile üretilir (`tools/model/meshy_uret.py`); kapı ve köy 3D sahne, arayüz 2D kalır. Sanat kitabındaki palet, gece-meşale ışığı ve "iyi/kötü işareti yok" kuralları 3D için de geçerlidir; 2D çizim kuralları (mürekkep kalınlığı, 2× çizim) artık yalnız arayüz ve simgeler içindir.

> **Motor kararı (4 Ekim 2026, kullanıcı):** Godot 4.7.2, GDScript. Oyunun tamamı 2D,
> çünkü tüm asset'ler 2D. Bu karar kilitteki "Flutter, Dart" ve "3D savunma denemesi /
> 3D motoru açık" satırlarının yerine geçer.

| Consideration | Assessment |
| ---- | ---- |
| **Engine** | Godot 4.7.2, GDScript. Tamamı 2D |
| **Key Technical Challenges** | Karaktere göre değişen seçenekli sohbet sistemi |
| **Art Style** | 2D kalın mürekkep, düz renk |
| **Networking** | Yok |
| **Content Volume** | Açık |

---

## Risks and Open Questions

### Open Questions (kilitten)
- Sonların adı ve koşulu.
- Yedi sekiz karakterin adı.
- Köyün oturduğu eşik (elli gün yalnız örnek).
- Sohbet adım sayısı.
- ~~İkinci perdenin 3D motoru.~~ Kapandı: tamamı 2D, Godot (4 Ekim).
- Bar etiketleri (Halk, Soylular, Tüccarlar, Ordu) onaylanmadı.

### Risks
- Sohbet her karakterde tekrarlayıcı hissedebilir.
- Godot 4.7 eğitim verisinin ötesinde; API önerileri docs/engine-reference/godot ile doğrulanmalı.
- İkinci perde (savunma) kapsamı şişirebilir.

---

## MVP Definition

**Şimdiki demo (kilitten):** Çevrimdışı. Kapı ve karar; savunma ayrı savaş haritası değil — kırılan bar, muhafız yetmezse üç rüşvet hakkı; skor hayatta kalınan gün. Yeni oynanış bu gece yok.

### Scope Tiers

Açık — süre uydurulmaz.

---

## Next Steps

- [x] `/setup-engine` — Godot 4.7.2, GDScript
- [ ] `/art-bible` — yukarıdaki görsel kilitten
- [ ] `/design-review design/gdd/game-concept.md`
- [ ] `/map-systems` → `/design-system`
