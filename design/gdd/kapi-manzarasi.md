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
