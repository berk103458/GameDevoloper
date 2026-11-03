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
  - `diyalog_06` (Miğferi yamuk, kılıcını ekmeğe satan yaya er - Asker)
  - `diyalog_07` (Köyü yakılan, kırık saban ve arpa tohumlu rençber - Çiftçi)
  - `diyalog_08` (Çarşı yangınından kaçan b種類li dikici kalfası - Esnaf)
  - `diyalog_09` (Oku tükenmiş kemankeş - Asker)
  - `diyalog_10` (Yetimlerle ekmeğini bölüşen obalı köylü - Çiftçi)
  - Test: `tests/unit/kvr/diyalog_mantigi_test.gd` (Godot headless, 0 hata, GEÇTİ).
  - Commit: `0860d05e`

- **Aşama B Parti 3 — `diyalog_11` – `diyalog_15` (Tamamlandı)**
  - `diyalog_11` (Taş köprü nöbetinden çekilen yaralı kargıcı - Asker)
  - `diyalog_12` (Eşeğiyle gezen seyyar kalaycı ustası - Esnaf)
  - `diyalog_13` (Ağılı basılan, kucağında topal teke yavrusunu kaçıran çoban - Çiftçi)
  - `diyalog_14` (Kervanı vurulan kaya tuzu tüccarı - Esnaf)
  - `diyalog_15` (Kule baskınından borazanını kurtarıp kaçan nefer - Asker)
  - Test: `tests/unit/kvr/diyalog_mantigi_test.gd` (Godot headless, 0 hata, GEÇTİ).
  - Commit: `235a1f0a`

- **Aşama B Parti 4 — `diyalog_16` – `diyalog_20` (Tamamlandı)**
  - `diyalog_16` (Kökleri bezde asma fidanıyla kaçan bağcı - Çiftçi): Üç yıllık sabır, yaprak ve koruk bereketi, bağ bıçağı, kış sepetçiliği ve aşı çeliği rüşveti yazıldı.
  - `diyalog_17` (Pirinç dirhemleri ve el terazisiyle kaçan kantarcı - Esnaf): Pazar adaleti, sancak kadısı mührü, parçalanmış topuk ve hilesiz tartı yemini yazıldı.
  - `diyalog_18` (Kale hendeğinde harç karan, kürekli kireççi ırgat - Çiftçi): Kendi ördüğü sur taşının düşmesi, kireç yanığı eller, ahşap kazık diplerine taş temel örme ve kışla siper kazıcılığı yazıldı.
  - `diyalog_19` (Gürgen tekne ve oklavayla bacadan kaçan fırıncı - Esnaf): Babadan kalma tekne, kül kapağı kırma, kepeksiz tam buğday peksimeti, çay taşından tandır kurma ve çörekotu rüşveti yazıldı.
  - `diyalog_20` (Nal çivisi batmış, kerpetenli seyyar nalbant - Esnaf): Çiviyi kerpetenle çekip at tersi basma, Şam kervanı at damgası, öküz/katır tırnağı ve kışla süvari nallama yazıldı.
  - Test: `tests/unit/kvr/diyalog_mantigi_test.gd` (Godot headless, 0 hata, GEÇTİ).
  - Commit: `cd2bdadf`

- **Aşama C — Köy Sistemi (Parley Adaptörleri ve Muhabbet Ağaçları) (Tamamlandı)**
  - Çekirdek sistemlerle (`Oturum`, `Koylu`, `KoyYonetimi`) Parley'i gevşek bağlayan adaptör mimarisi kuruldu:
    - `src/diyalog/parley_koy_adaptoru.gd` (`ParleyKoyAdaptoru`)
    - `src/diyalog/facts/koylu_moral_fact.gd` (`KoyluMoralFact`)
    - `src/diyalog/facts/koy_havadis_fact.gd` (`KoyHavadisFact`)
    - `src/diyalog/actions/koy_moral_action.gd` (`KoyMoralAction`)
    - `src/diyalog/actions/koy_akce_action.gd` (`KoyAkceAction`)
  - 4 adet Parley diyalog sekansı (`data/parley/koy/`) oluşturuldu:
    - `koylu_muhabbet_genel.ds`: Tıklanan herhangi bir köylü ile 4 kollu derin muhabbet ağacı (Hal-hatır/moral sorgusu, İş durumu, Köy havadisleri, Yardım/akçe ricası).
    - `koylu_muhabbet_yusuf.ds`: Yusuf karakteri özel muhabbet ağacı (urgan örme, Karabaş köpeğin havlaması, Kösedağ'dan kaçış, muhafızlık hevesi).
    - `sekans_degirmen_kitlik.ds`: Değirmenci Latif ile Çiftçi İdris arasında un/tahıl tartışması ortam sekansı.
    - `sekans_meydan_atesi.ds`: Çoban Aydoğdu ile Ayşe Bacı arasında meydan ateşi başında kurt ve kış hazırlığı sekansı.
  - Çalışma zamanı yöneticisi ve arayüz:
    - `src/diyalog/koy_diyalog_yoneticisi.gd`: `.ds` AST ayrıştırıcı, Parley koşucusu, köylü bağlam aktarımı ve etki uygulayıcı.
    - `src/arayuz/koy_diyalog_paneli.gd`: 13. yy temalı, kaydırmalı butonlu, animasyonlu replik paneli.
    - `src/arayuz/koylu_karti.gd`: Köylü kartına "Muhabbet Et (Konuş)" butonu eklendi, karta basıldığında kart kapanıp diyalog paneli açılıyor.
  - Test: `tests/unit/diyalog/koy_parley_sistemi_test.gd` (Godot headless, AST yükleme, Türkçe karakter koruma, adaptör ve uçtan uca akış: 0 hata, GEÇTİ).

## Son Commit Hash'i
- `cd2bdadf` (Aşama B Parti 4)

## Bir Sonraki Adım
Aşama D: Bütünlük ve Doğrulama Kontrolü (Diyalog mantığı, Türkçe karakter bütünlüğü, CHR ayrıştırıcı denetimi, uçtan uca test süiti).

## Açık Sorular (Ahmet'e)
- Şimdilik açık soru bulunmamaktadır.
