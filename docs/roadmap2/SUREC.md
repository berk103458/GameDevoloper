# ROADMAP 2 atölyesi — süreç

ROADMAP 2 iki modelin karşılıklı tartışmasıyla (sparring) yazılır.

- **YAZAR:** Muse Spark — `PERSONA_SPARK_YAZAR.md`
- **ELEŞTİRMEN:** Gemini — `PERSONA_GEMINI_ELESTIRMEN.md`
- **Diyalog çerçevesi:** `DIYALOG_ODAK.md`
- **Karar sahibi:** Ahmet. Ahmet "dur" derse süreç o anda kesilir.

## Durum

Atölye kuruldu (10 Ekim 2026). Henüz madde yok. `ROADMAP_2.md` henüz oluşturulmadı. Eski `ROADMAP.md` aynen geçerlidir.

## Dosyalar

| Dosya | Kim yazar | İçerik |
|---|---|---|
| `docs/roadmap2/AHMET_EKSIKLER.md` | Ahmet | Playtest eksik listesi (girdi 1) |
| `ROADMAP_2.md` (repo kökü) | Spark | Çıktı. Tur 1'de oluşturulur, her revizyonda güncellenir |
| `docs/roadmap2/turlar/TUR_XX.md` | Spark + Gemini | Tur kaydı. `XX` iki hanelidir: `TUR_01.md` … `TUR_10.md` |
| `docs/roadmap2/turlar/TUR_SABLON.md` | — | Tur kaydı şablonu |

**Eski ROADMAP.md dokunulmaz.** Berk'in ajanları eski kalanları orada bitirir; iki liste karışmaz. ROADMAP 2 maddeleri `ROADMAP.md` içine kopyalanmaz. ROADMAP 2 onaylanınca nasıl devreye gireceğine Ahmet karar verir.

## Girdi sırası

Spark her turda girdileri bu sırayla okur. Çelişki olursa sıradaki ilk girdi kazanır.

1. **`docs/roadmap2/AHMET_EKSIKLER.md`** — Ahmet'in playtest eksikleri. Şu an boş şablon. Boşsa tur kaydına "Ahmet listesi boş" yazılır ve taslak 2. ve 3. girdiyle yazılır; liste dolunca bir sonraki tur önce bu satırları karşılar.
2. **`ROADMAP.md`** — biten `[x]` maddeler, pano, örtüşme notları. Biten iş tekrar yazılmaz.
3. **Kodun gerçek hali** — `src/`, `data/`, `karakterler/`, `tests/`, `tools/`. Spark taradığı dosyaları tur kaydına yazar. Kod ile ROADMAP çelişirse kod esas alınır ve çelişki tur kaydına not edilir.

Ek okumalar (her tur değil, gerektiğinde): `AGENTS.md`, `CLAUDE.md`, `codex.md/SOUL.md`, `docs/MUHARRIR_RAPORU.md` başı, `docs/METIN_ANAHTAR_STANDARDI.md`, `docs/EKSIK_ASSET_ENVANTERI.md`, `OYUN_RAPORU.md`.

## Tur döngüsü

```text
Tur 1:  Spark taslak  ->  Gemini eleştiri  ->  Spark revizyon
Tur 2:                    Gemini eleştiri  ->  Spark revizyon
...
Tur N:                    Gemini eleştiri  ->  Spark revizyon  ->  kapanış
```

- **N varsayılan 10'dur.** Ahmet başka sayı verirse o geçerlidir.
- Tur 1'de Spark ilk taslağı yazar. Sonraki turlarda yeni taslak yazılmaz; önceki taslak revize edilir.
- Her tur tek dosyadır: `docs/roadmap2/turlar/TUR_XX.md`. Bir tur kaydı kapandıktan sonra değiştirilmez; düzeltme sonraki turda yapılır.

### Bir turun adımları

1. **Spark — hazırlık.** Girdileri sırayla okur. Tur kaydının "Girdi ve tarama" bölümünü doldurur.
2. **Spark — taslak veya revizyon.** `ROADMAP_2.md` dosyasını yazar/günceller. Tur kaydına değişen madde ID'lerini listeler.
3. **Gemini — eleştiri.** Persona kontrol listesini uygular. Bulguları `G-01…` numarasıyla, şiddet ve öneriyle tur kaydına yazar. Turun sonunda özet satırı.
4. **Spark — cevap ve revizyon.** Her bulguya KABUL / RET / KISMİ KABUL + gerekçe yazar. Kabul edilenleri `ROADMAP_2.md` içinde uygular.
5. **Tur kapanışı.** Tur kaydına bulgu sayıları ve "sonraki tur gerekli mi" yazılır. Commit atılır.

### Erken bitiş

Süreç N'den önce şu durumlarda biter:

- Gemini "ROADMAP 2 hazır" yazar: açık kritik bulgu 0, açık orta bulgu en çok 2.
- Ahmet "dur" der. O anda yazılmakta olan tur yarım kalır; tur kaydına "Ahmet durdurdu" yazılır ve son kapanmış turun `ROADMAP_2.md` hali geçerli kalır.

N tura ulaşılıp hâlâ kritik bulgu varsa süreç durur ve açık bulgular Ahmet'e karar için listelenir. Kendiliğinden 11. tur açılmaz.

### Kilitlenme kuralı

Aynı konuda iki tur üst üste RET ve tekrar açılma olursa bulgu "Ahmet kararı bekliyor" olarak işaretlenir. Diğer maddeler beklemeden ilerler.

## Kurallar

- Eski `ROADMAP.md` değiştirilmez.
- Kod, sahne, test, CSV ve asset değiştirilmez. Bu atölye yalnız doküman üretir.
- Asset üretimi ve indirmesi yasaktır. Asset isteyen madde yer tutucu ve `docs/EKSIK_ASSET_ENVANTERI.md` kuralını taşır (bkz. `PERSONA_SPARK_YAZAR.md`).
- Madde boyutu takvimle değil teknik kapsamla verilir (S/M/L tanımı Spark personasında).
- Atölye maddeleri kimseye atamaz. `[/]` sahipliği yalnız uygulama başladığında, uygulayan ajan tarafından konur.
- Sırlar, anahtarlar ve token'lar hiçbir tur kaydına yazılmaz.

## Git düzeni

- Atölye kısa ömürlü bir dalda yürür, festive'den açılır (`AGENTS.md` §1).
- Her tur kapanışı tek commit: `docs(roadmap2): TUR_XX — <kısa özet>; asset gerekmedi`.
- PR festive'e açılır. Merge Ahmet'in kararıdır; ajanlar merge etmez.
- Duyuru `docs/MUHARRIR_RAPORU.md` başına kısa satırla yazılır (atölye açılışı, ROADMAP 2 hazır, Ahmet durdurdu gibi dönüm noktalarında).
- Ajan Masası (GitHub issue #11) erişilebilirse dönüm noktaları orada da `[Gönderen → Alıcı] [ETIKET] konu` biçiminde duyurulur.
