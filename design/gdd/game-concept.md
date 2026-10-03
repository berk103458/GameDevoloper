# Game Concept: Kapı Defteri (çalışma adı)

*Created: 2026-10-03*
*Status: Draft*

---

## Elevator Pitch

> Kösedağ'dan (1243) sonra, Moğol istilasından kaçanların sığındığı ıssız bir uçta kapıyı tutan kervan muhafızısın. Kapıya gelenle konuşur, pazarlık eder ve kimin içeri gireceğine karar verirsin; içeri aldıkların sıfırdan bir köy kurar, köy oturunca da Tekfur'a karşı elindekini savunursun.

---

## Core Identity

| Aspect | Detail |
| ---- | ---- |
| **Genre** | Anlatı odaklı karar/kart oyunu + köy kurma; ikinci perdede savunma |
| **Platform** | PC (Flutter). Konsol, mobil, web ve Steam Deck şimdilik yok |
| **Target Audience** | Aşağıdaki "Target Player Profile" bölümü |
| **Player Count** | Tek oyunculu |
| **Session Length** | 30-60 dakika (birkaç gece) |
| **Monetization** | Henüz yok — şu an çevrimdışı demo |
| **Estimated Scope** | Large (12-24 ay, 2 kişilik ekip) |
| **Comparable Titles** | Papers, Please; Reigns; Not Tonight; Yes, Your Grace; Death and Taxes |

---

## Setting and Story Premise

*Kaynak: kullanıcının verdiği hikaye özeti. Sonlar ve hikaye kararları kullanıcıya aittir.*

- **Dönem:** Kösedağ Savaşı (1243) sonrası. Anadolu Moğol istilasının ağır yıkımını yaşıyor; uç bölgelerinde hayatta kalma mücadelesi var.
- **Oyuncu:** Tekinsiz yollarda can ve mal güvenliğini sağlamaya çalışan bir kervan muhafızı.
- **Kapı:** Dış dünya ile tek bağlantı. Moğol baskınından kaçan çaresiz insanlar ve getirebildikleri mallar bu kapıdan girer.
- **Köy:** Kapıdan geçmesine izin verilenlerle tamamen ıssız bir yerde sıfırdan kurulur. Halk asker, esnaf ve çiftçiden oluşur.
- **Ahi esnafı:** Yeni düzenin birleştirici ve üretken yüzü.
- **Düşman:** Bölgedeki gücünü korumaya çalışan Tekfur.
- **Birinci perde — Kapı ve köy:** Kim girerse köy onunla kurulur. Köy tam oturup düzen sağlandığında oyuncu ağa olur.
- **İkinci perde — Savunma:** Kapı artık yalnızca kimin girip çıkacağını belirleyen sade bir filtredir. Dış baskı artar; elde olanı korumak için savunma başlar. (3D deneme tarafı — abinin işi.)
- **Sonlar:** Tek bir mutlak kader yok; sonlar açık. Osmanoğullarına katılmak ulaşılabilecek sonlardan yalnızca biri.

---

## Core Fantasy

Yıkılmış bir dünyanın kenarında, kimin yaşayacağına ve nasıl bir topluluk kurulacağına karar veren tek kişi olmak. Her gece kapıyı açtığında, sabah gördüğün köy senin kararlarının toplamıdır.

---

## Unique Hook

Papers, Please gibi kapıda karar verirsin, **ve ayrıca** içeri aldığın her insan, sıfırdan kurduğun bir köyün gerçek nüfusu olur — sonra o köyü, kurduğun haliyle savunmak zorunda kalırsın.

---

## Player Experience Analysis (MDA Framework)

### Target Aesthetics

| Aesthetic | Priority | How We Deliver It |
| ---- | ---- | ---- |
| **Narrative** | 1 | Kapıya gelenlerin hikayeleri, dönemin trajedisi, açık sonlar |
| **Discovery** | 2 | Konuşmada ortaya çıkan sırlar, köyün nasıl şekillendiği, farklı sonlar |
| **Fantasy** | 3 | Kervan muhafızı → ağa olma; bir topluluğun kaderini taşımak |
| **Challenge** | 4 | Kıt kaynakla doğru insanı seçmek, savunmaya hazırlıklı olmak |
| **Sensation** | 5 | Kalın mürekkep, meşale ışığı, gece sesleri |
| **Expression** | 6 | Her oyuncunun köyü farklı bir bileşime sahip olur |
| **Submission** | N/A | Ton bilinçli olarak gergin ve yorgun |
| **Fellowship** | N/A | Tek oyunculu |

### Key Dynamics
- Oyuncular kapıdaki kişilerin söylediklerini tartıp çelişki ve fırsat arar.
- Oyuncular köyün asker/esnaf/çiftçi dengesini ileride gelecek savunmayı düşünerek planlar.
- Oyuncular "o kişiyi içeri almalı mıydım?" diye kararlarını sonradan tartışır ve farklı sonlar için yeniden oynar.

### Core Mechanics
1. **Kapı konuşması:** Gelen kişiyle kısa diyalog; soru seçme, pazarlık, vaat. Sonunda içeri al / geri çevir.
2. **Sınıf bazlı nüfus:** İçeri alınanların çoğu asker, esnaf veya çiftçi olarak köy sayılarına eklenir; bazıları isimli özel karakterdir.
3. **Gece-sabah döngüsü:** Her gece birkaç kişi gelir; sabah köyün durumu raporlanır.
4. **Köyün oturması → ağalık:** Köy belirli bir düzene ulaşınca birinci perde biter.
5. **Savunma perdesi:** Kapı sade bir filtreye dönüşür; köyün bileşimi savunmanın kaynağıdır.

---

## Player Motivation Profile

### Primary Psychological Needs Served

| Need | How This Game Satisfies It | Strength |
| ---- | ---- | ---- |
| **Autonomy** | Ne soracağını, neyi isteyeceğini ve kimi alacağını oyuncu seçer | Core |
| **Competence** | Yalanları, fırsatları ve köyün ihtiyacını zamanla daha iyi okumak | Supporting |
| **Relatedness** | Geri dönen özel karakterler ve kendi kurduğu köye bağlılık | Supporting |

### Player Type Appeal (Bartle Taxonomy)

- [x] **Explorers** — Konuşmalarda sır ve bağlantı aramak, farklı sonları keşfetmek.
- [x] **Achievers** — Köyü oturtmak, ağa olmak, savunmayı atlatmak, tüm sonları görmek.
- [ ] **Socializers** — Tek oyunculu; yalnızca karakterlerle bağ.
- [ ] **Killers/Competitors** — Hedeflenmiyor.

### Flow State Design

- **Onboarding curve:** İlk gece az sayıda ve açık niyetli kişi gelir; konuşma ve karar arayüzü öğretilir.
- **Difficulty scaling:** Geceler ilerledikçe gelen kişi sayısı, belirsizlik ve kaynak baskısı artar.
- **Feedback clarity:** Sabah raporu kararların sonucunu sayılarla ve kısa olaylarla gösterir.
- **Recovery from failure:** Kötü kararlar oyunu bitirmekten çok köyü ve sonu şekillendirir; tam başarısızlık durumları (köyün dağılması) tasarımda netleşecek.

---

## Core Loop

### Moment-to-Moment (30 seconds)
Kapıya biri gelir. Kısa bir konuşmada ne soracağını seçer, bir şey ister ya da bir şey vaat edersin; sonra içeri alır veya geri çevirirsin. Soru ve vaatler sonucu değiştirdiği için karar tek tuşluk değildir.

### Short-Term (5-15 minutes)
Bir gece: kapıya birkaç kişi gelir. İçeri alınanlar asker/esnaf/çiftçi sayısına eklenir, arada isimli karakterler çıkar. Gece sonunda sabah raporu gelir; "bir gece daha" isteği burada doğar.

### Session-Level (30-120 minutes)
Birkaç gece köyü büyütmek. Doğal durma noktası her sabah raporu.

### Long-Term Progression
Köy oturunca oyuncu ağa olur ve birinci perde biter. İkinci perdede birinci perdede kurulan köyle Tekfur'a karşı savunma yapılır. Sonunda açık sonlardan birine ulaşılır.

### Retention Hooks
- **Curiosity:** Kapıya bir sonraki gece kim gelecek; geri çevrilenlere ne oldu; diğer sonlar neler.
- **Investment:** Kurulan köy ve isimli karakterler.
- **Social:** Yok (tek oyunculu).
- **Mastery:** Kapıda daha iyi okuma ve pazarlık; savunmaya daha hazır bir köy.

---

## Game Pillars

Sıra önem sırasıdır; iki sütun çatışırsa üstteki kazanır.

### Pillar 1: Her kapı bir bedel
Hiçbir karar bedava değildir; içeri aldığın da geri çevirdiğin de bir şeye mal olur.

*Design test*: "Herkes için iyi" bir seçenek ile acı bir takas arasında kalırsak takası seçeriz.

### Pillar 2: Konuşarak karar ver
Karar sözle verilir; soru, pazarlık ve vaat oyuncunun aracıdır.

*Design test*: Menü mü diyalog mu diye tartışırsak diyalogu seçeriz.

### Pillar 3: Yorgun gece
Ton soğuk, yorgun ve sessizdir; meşale ışığının dışı bilinmez.

*Design test*: Gösterişli bir efekt ile sade ve kasvetli bir an arasında kalırsak kasvetliyi seçeriz.

### Pillar 4: Köy senin aynan
Köyün bileşimi ve havası tamamen kapıda verilen kararlardan çıkar.

*Design test*: Rastgele bir olay ile oyuncunun kararının bir sonucu arasında kalırsak sonucu seçeriz.

### Anti-Pillars (What This Game Is NOT)

- **NOT ayrıntılı köy inşası**: Bina yerleştirme, yol ve kaynak zinciri yok — oyunu kapıdan uzaklaştırır (Pillar 4).
- **NOT refleks/aksiyon (birinci perde)**: Zamanlı tıklama yok — "Konuşarak karar ver" sütununu bozar (Pillar 2).
- **NOT kesin iyi/kötü karakter etiketi**: Kartlarda "bu kişi iyidir" yok — "Her kapı bir bedel" sütununu boşa çıkarır (Pillar 1).

---

## Visual Identity Anchor

*Lean modda art-director değerlendirmesi atlandı; aşağıdakiler kullanıcının verdiği yönlendirmeden derlendi ve `/art-bible` ile genişletilecek.*

- **Visual direction:** "Meşale ve Mürekkep"
- **One-line visual rule:** Her şey kalın siyah mürekkep çizgisi ve düz renkle, tek bir meşalenin ışığında çizilir.
- **Supporting principles:**
  1. *Düz renk, gradyan yok.* — Bir sahnede yumuşak geçiş mi düz renk bloğu mu diye kalırsak düz rengi seçeriz.
  2. *Meşale ışığı tek sıcak kaynak.* — Sıcak renk yalnızca ateş, meşale ve insan teninde; geri kalanı soğuk.
  3. *Yorgun, bitkin yüzler.* — Kahramanca poz yerine yorgun ve temkinli ifade.
- **Color philosophy:** Soğuk gece mavisi ve lacivert zemin; yıpranmış ahşap kahvesi; tek sıcak vurgu meşale turuncusu. Fotogerçekçi değil, anime değil. Referans: Reigns kart sanatı, Papers, Please'in yorgun kapısı.

---

## Inspiration and References

| Reference | What We Take From It | What We Do Differently | Why It Matters |
| ---- | ---- | ---- | ---- |
| Papers, Please | Kapıda yorgun, ahlaki karar verme | Belge kontrolü yerine konuşma ve pazarlık; içeri alınanlar köy kurar | Kapı kararının tek başına güçlü bir döngü olduğunu kanıtlar |
| Reigns | Kart başına hızlı karar, sonuçların birikmesi | Kaydırma yerine diyalog; tarihî ve somut bir dönem | Kart formatının anlatı taşıyabildiğini kanıtlar |
| Not Tonight | Kapı görevlisi perspektifi, siyasi baskı | Orta çağ Anadolu'su ve köy kurma | Kapı fantezisinin farklı temalarla çalıştığını gösterir |
| Yes, Your Grace | Kaynak kıtlığı altında halkı yönetme ve savunma | Oyuncu hükümdar değil, kapıdan ağalığa yükselir | Karar + savunma birleşiminin işlediğini gösterir |
| Death and Taxes | Kimin yaşayacağına karar vermenin ağırlığı | Sonuç bir köyün bileşimine dönüşür | Tek ekranda karar oyununun duygusal gücünü kanıtlar |

**Non-game inspirations**: Kösedağ sonrası Anadolu tarihi, Ahilik geleneği, uç beylikleri dönemi.

---

## Target Player Profile

| Attribute | Detail |
| ---- | ---- |
| **Age range** | 18-40 |
| **Gaming experience** | Mid-core |
| **Time availability** | 30-60 dakikalık oturumlar |
| **Platform preference** | PC |
| **Current games they play** | Papers, Please; Reigns; Frostpunk |
| **What they're looking for** | Tarihî atmosferi olan, kararları ağır basan anlatı oyunu |
| **What would turn them away** | Refleks gerektiren aksiyon; yüzeysel, sonuçsuz kararlar |

---

## Technical Considerations

| Consideration | Assessment |
| ---- | ---- |
| **Recommended Engine** | 2D kart/kapı tarafı: Flutter (Dart) — ekibin seçtiği ve kilitlediği teknoloji. 3D savunma denemesi: motor seçilmedi; `/setup-engine` ile karar verilecek |
| **Key Technical Challenges** | Diyalog ve pazarlık sistemi için veri odaklı içerik formatı; 2D tarafın köy durumunu 3D tarafa aktarması; Flutter'ın oyun motoru olmaması (araç desteği sınırlı) |
| **Art Style** | 2D düz renk, kalın mürekkep (kart tarafı); 3D stilize (savunma denemesi) |
| **Art Pipeline Complexity** | Medium (custom 2D, AI destekli üretim + elle düzeltme); 3D taraf High |
| **Audio Needs** | Moderate — ortam sesi, gece, ateş; az müzik |
| **Networking** | None |
| **Content Volume** | TBD — `/map-systems` ve sonrasında; çok sayıda sınıf bazlı kişi + sınırlı sayıda isimli karakter |
| **Procedural Systems** | Sınıf bazlı sıradan kişiler için şablonlu üretim olası; isimli karakterler el yapımı |

---

## Risks and Open Questions

### Design Risks
- Konuşma ve pazarlık her kişide tekrarlayıcı hissedebilir.
- "Köy senin aynan" ancak sonuçlar görünür ve okunaklı olursa çalışır.
- İki perdenin hissi farklı; ikinci perde birinci perdenin değerini düşürmemeli.

### Technical Risks
- 2D (Flutter) ve 3D (motor belirsiz) taraf arasında veri aktarımı ve tutarlılık.
- Flutter oyun motoru değil; animasyon, ses ve araç desteği elle kurulmalı.

### Market Risks
- Dar bir türün içinde; benzer oyunlar güçlü.
- Tarihî dönem yurt dışı kitlesine bağlam gerektirebilir.

### Scope Risks
- İlk oyun ve iki kişilik ekip; diyalog metni yükü yüksek.
- 3D savunma perdesi kapsamı en çok şişirebilecek parça.

### Open Questions
- Kapı konuşması kaç adım ve kaç seçenekten oluşmalı? — `/prototype` ile denenecek.
- "Köy oturdu" koşulu nedir? — `/design-system` ile tanımlanacak.
- Sonların yapısı ve sayısı nedir? — Kullanıcı kararı; anlatı tasarımında.
- 3D tarafın motoru ne olacak? — `/setup-engine`.

---

## MVP Definition

**Core hypothesis**: Kapıda konuşarak ve pazarlık ederek kimin içeri gireceğine karar vermek, birkaç gece boyunca ilgi çekici ve ağırlıklı hissettirir.

**Required for MVP**:
1. Kapı konuşma ekranı (soru, pazarlık, vaat, içeri al / geri çevir).
2. Sınıf bazlı nüfus sayacı (asker/esnaf/çiftçi) ve birkaç isimli karakter.
3. Gece-sabah döngüsü ve sabah raporu.
4. Köyün oturması için basit bir eşik.

**Explicitly NOT in MVP** (defer to later):
- 3D savunma perdesi.
- Birden fazla son.
- Tam ses ve müzik.

### Scope Tiers (if budget/time shrinks)

| Tier | Content | Features | Timeline |
| ---- | ---- | ---- | ---- |
| **MVP** | 3-5 gece, birkaç isimli karakter | Kapı konuşması + nüfus + sabah raporu | TBD |
| **Vertical Slice** | Birinci perdenin tamamı, bir son | Ağalığa geçiş dahil | TBD |
| **Alpha** | İki perde, tüm sonlar taslak | 3D savunma dahil, kaba | TBD |
| **Full Vision** | Tüm içerik | Tüm özellikler, cilalı | 12-24 ay |

---

## Next Steps

- [ ] `/setup-engine` — 2D için Flutter'ı kaydet, 3D motoru karara bağla
- [ ] `/art-bible` — görsel kimlik ("Meşale ve Mürekkep")
- [ ] `/design-review design/gdd/game-concept.md`
- [ ] `/prototype kapı-konuşması` — kapı döngüsünün eğlenceli olduğunu doğrula
- [ ] `/map-systems` → `/design-system` (her sistem için)
