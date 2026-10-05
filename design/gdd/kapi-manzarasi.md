# Kapı manzarası

*Durum: Uygulandı (5 Ekim 2026, kullanıcının konsept görseli ve yerleşim notu). Kod: `src/dunya/kapi_manzarasi.gd`, `src/dunya/kapi_cercevesi.gd`, `src/dunya/kapi_sahnesi.gd`.*

## Overview
Kapı ekranının 3D arka planı. Oyuncu kapının içinde (güvenli, sıcak ışık), gelenler dışarıdan (soğuk, karanlık,
savaş) gelir. Sahne yazı göstermeden üç soruyu cevaplar: **Neredeyim?** (Anadolu sınır köyünün kapısı) — **Bu
insanlar nereden geliyor?** (ufukta savaşın olduğu yönden, yol boyunca) — **Neden kontrol ediyoruz?** (dışarısı
tehlikeli; tehdit gece gece yaklaşıyor).

## Player Fantasy
"Kapının içi sıcak ama kırılgan bir güvenlik; dışarısı soğuk ve her gece biraz daha yakın bir savaş."

## Detailed Rules
1. **Kompozisyon:** UFUK → YOL → BEKLEYEN SIRA → SORGULANAN GELEN → KAPI → BEKÇİ. Kamera (z 3.0, görüş 46°,
   sağa kayma 1.3) iki kapı direğini arayüzün solundaki görünür pencerenin kenarlarına oturtur; gelen pencerenin ortasındadır.
2. **Işık:** kapıda iki demir kollu meşale (titreyen sıcak ışık, gölgeli); dışarıda soğuk ay ışığı ve mavi sis; ışıma (glow) açık.
3. **Yol:** kapıda 4.6 m (sorgu alanı) → ufukta 1.2 m; Catmull-Rom ile kıvrılır, arazide yükselir. Sorgu alanının arkası temiz (çit ve eşyalar yolun 4 m dışında).
4. **Sıra:** öndeki 5 kişi tam model; arkasında yol boyunca silüet mülteciler (yük, bazılarında fener). Sayı geceyle artar (1. perde `10 + 2·min(gece, 8)`).
5. **Orta plan:** öküzlü kağnı (yükü bir evin eşyası), kuru ceviz, yıkık taş direk, taş yığınları, kırık çitler, servi silüetleri.
6. **Tehdit, 1. perde:** tepenin ardında yanan köy. Gece 0 yalnız duman; sonra ateş sayısı `1 + int(şiddet·6)` (şiddet = gece/6), ufuk parıltısı ve duman kalınlaşır; 5. geceden sonra sırtta atlı silüetleri.
7. **Tehdit, 2. perde:** Tekfur ordusu. Kamp ateşi `3 + int(yakınlık·45)`, uzaklık `125 → 60 m`; yakınlık > 0.3 çadırlar, ≥ 0.7 tepede üç sıra asker. Yanan köy söner (kor).
8. **Kapı, sur seviyesine göre** (köy ekranındaki "Sur kur / büyüt"):
   - 0 — kütük direkler, kiriş, çapraz sırık, alçak örgü çit
   - 1 — kalın ahşap kapı, demir lamalar, kütük geçit, kazık çit
   - 2 — taş sur: taş kaplı direkler, taş geçit, taş kemer
   - 3 — derin taş geçit, kemer üstünde kule duvarı ve sancak, mazgallar
9. **Kıpırtı:** meşale ve uzak ateşler titrer, duman rüzgârla sağa yatar, öküz arada başını eğer, sıradakiler nefes alır (DurusDuzeltici).

10. **Gerçekçi görüntü (Forward+):** taranmış PBR dokular ve modeller (Poly Haven, CC0; `tools/varlik/polyhaven_indir.py`, liste `assets/ph/KAYNAK.md`):
    yol `muddy_tracks`, arazi `brown_mud_rocks_01` + kırağı `snow_02` (`arazi.gdshader`), sur `castle_wall_varriation` 4K,
    kapı ahşabı `medieval_wood` 4K, kütük `bark_willow`; modeller `large_castle_door` (kanatlar), `wooden_barrels_01`,
    `wooden_crate_01`, `boulder_01`, `rock_moss_set_01`, `dead_tree_trunk_02`, `dry_branches_medium_01`; gök HDRI
    `satara_night_no_lamps`. Dokusu bulunmayan yüzey düz renge düşer (`Pbr.malzeme`).
11. **Işık ve son işlem:** HDRI gök ve ortam ışığı, hacimsel sis (meşalenin sise katkısı 0.12: kamera ışığa çok yakın),
    SSAO, SSIL, AgX ton eşleme, renk ayarı (kontrast 1.08, doygunluk 0.88), yalnız küçük yarıçaplı ışıma, uzak alan bulanıklığı.
12. **Alev ve duman:** gölgelendirici (`alev.gdshader`, `duman.gdshader`): gürültüyle dalgalanan, kameraya dönük dörtgenler.
13. **Çözünürlük:** 3D, pencerenin fiziksel çözünürlüğünde çizilir (4K ekranda 3840×2160), arayüzün altına serilir.
14. **Uzak plan (ön planla aynı gerçeklik):** kutu ev ve koni ağaç yoktur.
   - Dağlar: ridged gürültülü yükseklik alanı (z −190…−350); kaya dokusu (`aerial_rocks_02`), tepelerde kar (`snow_field_aerial`), sise karışır.
   - Ağaçlar: `fir_sapling_medium`'dan pişirilmiş saydam görüntüler (impostor, `tools/varlik/impostor_pisir.gd`); servi dar, köknar geniş; kümeler hâlinde.
   - Yanan köy: Meshy `ev`/`cadir` modelleri yere oturur (y = arazi yüksekliği − 0.25), damlarda alev, evlerden yükselen duman sütunları, ufukta soluk kızıllık.
   - Yoldaki kaçanlar: gerçek karakter modelleri yürür; bir kısmı fener taşır (ışıklı), yolun sonunda baştan döner.
15. **Kuyruk (sıradan gelme):** kapıdaki kuyruk gecenin gerçek listesidir (`KapiSahnesi.kuyruk_doldur`); dekor değildir.
   - İlk `KUYRUK_GORUNEN` (6) kişi yolda sıra hâlinde durur (~1.3 m aralık, ikişer hafif yana kayık); gerisi uzakta bekler.
   - Sırası gelen kuyruğun başından çıkıp kapıya yürür (1.6 m/s); hiçbir gelen boşlukta belirmez.
   - Arkadakiler birer yer ilerler, öndekinden 0.35 s sonra (dalga); boşalan son yere uzakta bekleyen sisin içinden belirerek (1.6 s) katılır.
   - Dönüşler yumuşaktır (0.45 s); kimse yerinde anında dönmez.
   - Reddedilen kuyruğun solundan geri yürür, kuyruğun içinden geçmez; uzakta sise karışır.
   - Yoldaki yürüyenler kuyruğun sonunun gerisinde kalabalığa karışır (solarak), yolun ortasında birden yok olmaz.
   - Sıra olayında kuyruktan ayrılan, görünen kuyruğun sonundaki kişidir; gecenin listesinden de o çıkar.

## Formulas
- Kadraj: pencere x aralığı `[H − 0.755·d, H + 0.14·d]` (H = 1.3, d = kameraya uzaklık) — iki direk (±1.75, d≈4.2) sınırda.
- Şiddet `s = clamp(gece/6, 0, 1)`; Tekfur yakınlığı `y = perde2_gece / perde2_hedef_gece`.

## Edge Cases
- Öküz modeli yoksa (`assets/model/nesne/okuz.glb`) yalnız kağnı kurulur.
- 2. perdede sorgu yok: karar ekranı açılınca kadraj daralır (eski davranış).

## Dependencies
Kapı arayüzü (18), Köy yapıları / Sur (11, köy-gelisimi.md), Perde geçişi, Sıra olayları (25), Ses (22: köpek, rüzgâr).

## Tuning Knobs
`KapiSahnesi.GORUS`, `KapiEkrani.KAMERA_KAYMA`, `KapiManzarasi.YOL_NOKTALARI`, `KOY_YERI`, ateş/duman sayıları; `KapiCercevesi.YARI`, `Z`.

## Acceptance Criteria
- Kapının önü düz, yol kapıdan başlar ve ufukta yükselir; ilk gece ateş yok, 6. gece var; Tekfur yaklaştıkça ateş çoğalır; her sur seviyesi iki meşaleyle kurulur. — `tests/unit/kapi_manzarasi/kapi_manzarasi_test.gd`
- Görsel: dört sur seviyesi ve iki perdenin geceleri. — `production/qa/evidence/kapi-manzarasi-1/`
