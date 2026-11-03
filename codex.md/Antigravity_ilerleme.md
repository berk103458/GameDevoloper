# Antigravity İlerleme Dosyası — Görev 3

**Görev:** Tüm diyalogların sahipliği: insanlaştırma, seçenek planı ve köy sohbetleri  
**Dal:** `feature/diyalog-yeniden-yazim`  
**Ajan:** Antigravity  
**Başlangıç Tarihi:** 3 Kasım 2026  

---

## Tamamlanan Aşamalar ve Partiler

- **Aşama A — Envanter ve Plan (Tamamlandı)**
  - `docs/DIYALOG_ANA_PLANI.md` hazırlandı:
    - 20 adsız kapı ziyaretçisi (`diyalog_01` – `diyalog_20`), 30 CHR sorgu karakteri (`CHR_001` – `CHR_030`), 10 adlı karakter ve köy sakinleri envanteri çıkarıldı.
    - Her karakter için kimliği, konuşma tarzı (13. yy Anadolu Selçuklu uç ağzı), derdi, gizlediği sırrı ve mevcut diyalog hataları tanımlandı.
    - Seçim–Sonuç Haritası (barlar, tansiyon, `KisiHafizasi`, `Dedikodu`, gecikmeli olay tetikleri) tablosu ve Mermaid grafı kuruldu.
    - Robotik "Kimsin/Nesin/Kendini tanıt" kalıplarının budanma ve dönüştürülme ilkeleri belirlendi.
    - Köy içi karakter sohbet sekansları (5 ana sekans) ve tıklayınca muhabbet (4 ana dal) ağaç taslakları çıkarıldı.
    - Teknik plan ve Parley adaptör mimarisi tanımlandı.
  - Commit: `18ca2c6f`

- **Aşama B Parti 1 — `diyalog_01` – `diyalog_05` (Tamamlandı)**
  - `diyalog_01` (Erzincanlı darı ve tohum taşıyan yanık rençber - Çiftçi)
  - `diyalog_02` (Kayserili çuhacı - Esnaf)
  - `diyalog_03` (Sivas bozgunundan kaçan yaralı kargıcı nefer - Asker)
  - `diyalog_04` (Yaylası yanan Akça ve Karaca koyunlu çoban - Çiftçi)
  - `diyalog_05` (Örssüz demirci kalfası - Esnaf)
  - Test: `tests/unit/kvr/diyalog_mantigi_test.gd` (Godot headless, 0 hata, GEÇTİ).
  - Commit: `286570c0`

- **Aşama B Parti 2 — `diyalog_06` – `diyalog_10` (Tamamlandı)**
  - `diyalog_06` (Miğferi yamuk, kılıcını ekmeğe satan yaya er - Asker): Er meydanı utancı, hancıya satılan pusat, gürz darbesi ve kışla kargıcılığı dalları yazıldı.
  - `diyalog_07` (Köyü yakılan, kırık saban ve arpa tohumlu rençber - Çiftçi): Kağnı devrilmesi, tohumun sıcaklığı, kara börklü süvariler ve ambar birliği dalları yazıldı.
  - `diyalog_08` (Çarşı yangınından kaçan b種類li dikici kalfası - Esnaf): Dükkânın kül oluşu, pabuç ve eyer onarımı, kapı dibinde sabaha kadar çalışma sözü ve çizme tamiri rüşveti yazıldı. (SYS-17 eşik=0 ret kuralı korundu).
  - `diyalog_09` (Oku tükenmiş kemankeş - Asker): Tokat kalesi boynuz zihgiri, kamıştan ok yapımı, şehit arkadaşlar ve kule gözetlemesi dalları yazıldı.
  - `diyalog_10` (Yetimlerle ekmeğini bölüşen obalı köylü - Çiftçi): Yarım somun ve testi suyu hikayesi, kuyu ve ark kazıcılığı, harama el uzatmama yemini dalları yazıldı.
  - Test: `tests/unit/kvr/diyalog_mantigi_test.gd` (Godot headless, 0 hata, GEÇTİ).

## Son Commit Hash'i
- `286570c0` (Aşama B Parti 2 commit'i atılacak)

## Bir Sonraki Adım
Aşama B Parti 3: `diyalog_11` – `diyalog_15` kapı diyaloglarının insanlaştırılması, yeni seçim/sonuçların ve tepki dallarının yazılması.

## Açık Sorular (Ahmet'e)
- Şimdilik açık soru bulunmamaktadır.
