# Diyalog Dalı Birleşme Notu (`feature/diyalog-yeniden-yazim`)

- **Tarih:** 4 Kasım 2026, 04:45
- **Ajan:** Antigravity
- **Hedef Dal:** `claude/festive-volta-li1sfm`
- **Kaynak Dal:** `feature/diyalog-yeniden-yazim`
- **Merge Base:** `b5ceb33a771b06ab0e757bef478ef5c6f9a8b811` (Cursor Gece PR #15–#27 birleşimi tam içerilmiştir)

---

## 1. Genel Özet ve Kapsam

Bu dal, Görev 3'ten Görev 9'a kadar Kapı Muhafızı'nın bütün anlatı, diyalog, yerelleştirme metinleri ve köy içi NPC konuşma sistemlerinin insanlaştırılması, derinleştirilmesi ve eksiksiz olarak tamamlanması amacıyla yürütülmüştür.

- **30 Kapı Ziyaretçisi:** Baştan sona insanlaştırılmış, alt sorular, soru takip bayrakları ve derin diyalog ağaçları (`data/diyalog/diyalog_01_20.json`).
- **Eş Diyalog ve Karar Sistemi:** Kapı ekranında 4 aşamalı eş fısıltı ve kanaat adaptörü (`data/diyalog/es_kapi_dusunceleri.json`, `src/kapi/es_yorumu_adaptoru.gd`), oda içi 120+ düğümlü Parley eş muhabbet ağacı (`data/parley/koy/koylu_muhabbet_es.ds`).
- **Köy İçi Parley Sistemi:** 11 adli köylü muhabbet ağacı ve 6 köy sekansı (`data/parley/koy/*.ds`), ince adaptör (`src/diyalog/parley_koy_adaptoru.gd`, `src/diyalog/koy_diyalog_yoneticisi.gd`).
- **8 Yeni Köy Olayı:** Karar seçenekleri, ambar/akçe şartları ve 4 bar etkileri (`data/olaylar/*.tres`).
- **85 Yer Tutucu Metin:** Gece birleşen PR #15–#27 metinlerinin tamamı (`nobet.rapor.*`, `sabah.hukum.*`, `tez.cumle.*`, `yil.*`, `hafiza.*`, `arayuz.girdi.*` vb.) `metinler.csv` içine yerleştirildi.
- **Söz Motoru ve Omurga:** `src/soz/` çekirdeği, hafıza/beyan defteri entegrasyonu, perde geçişleri, epiloglar ve dedikodu/söylenti ağı.

---

## 2. Eklenen ve Değiştirilen Dosyalar

### Eklenen Yeni Dosyalar (Kendi Alanımız):
1. **Diyalog Verileri:**
   - `data/diyalog/es_kapi_dusunceleri.json` (30 ziyaretçi için karar öncesi, kritik soru, kabul ve ret eş kanaatleri)
2. **Parley Köy Sohbetleri:**
   - `data/parley/koy/koylu_muhabbet_*.ds` (Genel, Eş, Karaca Usta, Ayşe Bacı, Yusuf, Miraen, Thessra, Sorhan, Aydoğdu, Saruca Hatun, Hasan Çelebi, Nogay)
   - `data/parley/koy/sekans_*.ds` (Değirmen Kıtlık, Demirhane Pusat, Kuyu Hastalık, Meydan Ateşi, Nöbet Harami, Pazar Fiskos)
3. **Köy Olayları:**
   - `data/olaylar/` altında 8 yeni olay kaynağı (`kavga_harman.tres`, `ambarda_hirsizlik.tres`, `salgin_fisiltisi.tres`, `koy_dugunu.tres`, `firari_cenazesi.tres`, `samanlik_yangini.tres`, `gece_donu.tres`, `harami_elcisi.tres`)
4. **Sistem ve Adaptör Sınıfları:**
   - `src/kapi/es_yorumu_adaptoru.gd` (Kapı arayüzü ile eş düşünceleri arasında ince köprü)
   - `src/diyalog/koy_diyalog_yoneticisi.gd`, `src/diyalog/parley_koy_adaptoru.gd` (Parley yürütücüsü ve köy adaptörü)
   - `src/diyalog/facts/` ve `src/diyalog/actions/` (Parley koşul ve aksiyon arayüzleri)
   - `src/koy/aksam_sohbeti.gd`, `src/koy/hane.gd`, `src/koy/sevilen_yuz.gd`
   - `src/sistemler/soylenti_agi.gd`, `src/sistemler/perde_metni.gd`, `src/sistemler/son_uyarisi.gd`, `src/sistemler/gecis_gecesi.gd`
   - `src/soz/*.gd` (Söz motoru, konu merkezi, beyan defteri, çelişki yüzleşme, sabır/sıra, yemin mekanizmaları)
5. **Birim ve Bütünlük Testleri:**
   - `tests/unit/diyalog/diyalog_butunluk_test.gd` (30 diyalog, 17 Parley ağacı, BFS erişilebilirlik ve Türkçe karakter testi)
   - `tests/unit/kapi/es_yorumu_test.gd`
   - `tests/unit/diyalog/koy_parley_sistemi_test.gd`
   - `tests/unit/olay/yeni_olaylar_test.gd`
   - `tests/unit/soz/*.gd` (15 adet söz motoru birim testi)
6. **Dokümantasyon:**
   - `docs/DIYALOG_ANA_PLANI.md`, `docs/YER_TUTUCU_METINLER.csv`, `docs/DIYALOG_DALI_BIRLESME_NOTU.md`, `docs/DIYALOG_GECE_OZETI.md`
   - `codex.md/Antigravity_ilerleme_*.md`

### Değiştirilen Çekirdek/Ortak Dosyalar:
1. `data/diyalog/diyalog_01_20.json`: 30 ziyaretçi tam sorgu, alt sorgu ve karar ağaçları.
2. `data/metin/metinler.csv`: 85 yeni yerelleştirme metni, olay metinleri ve düzeltilen dönem dili replikleri (satır bazlı eklenmiş olup mevcut anahtarlar korunmuştur).
3. `src/arayuz/kapi_ekrani.gd`: `EsYorumuAdaptoru` çağrısı tek satırlık korumalı bağlama ile eklendi.
4. `src/soz/beyan_defteri.gd` & `src/soz/soz_motoru.gd`: Cursor'un KAY kayıt adaptörleri ve DIY diyalog API'leri geriye dönük uyumlu biçimde tek sınıfta uzlaştırıldı.
5. `data/soz/gecis.json`: Hem yeni motor listesi hem 30 karakterlik geçiş eşlemeleri korundu.

---

## 3. Kalfa ve Cursor Alanlarına Müdahale Durumu

- **Kalfa Alanı:** ISG (işgal), YSM (yaşam), YAP (yapılar/inşaat), DEN (denge), EKO (ekonomi) ve Kalfa'nın test altyapısı kodlarına **kesinlikle dokunulmamıştır**.
- **Cursor Alanı:** Gece açılan ve birleşen PR #15–#27'deki arayüz, ayarlar, girdi, nöbet, tezgâh ve hafıza defteri kodları bozulmamış; bu sistemlerin beklediği yer tutucu metin anahtarları `metinler.csv` içine eksiksiz yerleştirilmiştir.
- **Mimari Disiplin:** Yeni bir çekirdek sınıf yeniden yazılmamış; tüm Parley ve eş fısıltı sistemleri bağımsız yeni dosyalarda tutulup ince adaptörlerle (`EsYorumuAdaptoru`, `ParleyKoyAdaptoru`) sisteme bağlanmıştır.

---

## 4. Test Sonuçları (Sıfır Hata Politikası)

Çalıştırılan 31 doğrulayıcı ve birim testin **tamamı (31/31) sıfır hatayla geçmiştir**:

1. **Python Doğrulayıcıları:**
   - `tools/metin_dogrula.py`: PASS
   - `tools/soz_dogrula.py`: PASS (KAY-53 chr=30, adli=30)
   - `tools/soz_tasarimi_dogrula.py`: PASS
   - `tools/soz_kapi.py`: PASS
   - `tools/soz_kadro_denetimi.py`: PASS

2. **Godot Headless Birim Testleri:**
   - `tests/unit/diyalog/diyalog_butunluk_test.gd`: PASS (0 hata — 30 diyalog, 17 Parley sekansı, 0 yetim düğüm, 0 kırık kenar, 12 Türkçe karakter render)
   - `tests/unit/kapi/es_yorumu_test.gd`: PASS (0 hata)
   - `tests/unit/diyalog/koy_parley_sistemi_test.gd`: PASS (0 hata)
   - `tests/unit/olay/yeni_olaylar_test.gd`: PASS (0 hata)
   - `tests/unit/olay/ozel_olay_test.gd`: PASS (0 hata)
   - `tests/unit/arayuz/girdi_test.gd`: PASS (0 hata)
   - `tests/unit/arayuz/dil_test.gd`: PASS (0 hata)
   - `tests/unit/sistemler/hafiza_defteri_test.gd`: PASS (0 hata)
   - `tests/unit/koy/kapi_nobeti_test.gd`: PASS (0 hata)
   - `tests/unit/koy/sabah_defteri_test.gd`: PASS (0 hata)
   - `tests/unit/koy/tezgahta_gun_test.gd`: PASS (0 hata)
   - `tests/unit/koy/yil_izi_test.gd`: PASS (0 hata)
   - `tests/unit/soz/*.gd` (14 adet söz motoru testi): PASS (0 hata)
   - `tests/unit/koy/aksam_sohbeti_test.gd`: PASS (0 hata)
   - `tests/unit/koy/hane_test.gd`: PASS (0 hata)
   - `tests/unit/kvr/soylenti_agi_test.gd`: PASS (0 hata)

*Not:* Festive dalında zaten bilinen ve Kalfa sorumluluğundaki (`nobet_yorgunlugu_test`, `oda_*_kontrol`, `ayarlar_bozuk_menu_kontrol`, `kesik_kayit_devam_kontrol`) dışındaki hiçbir testte hata veya regresyon yoktur.

---

## 5. Birleştirmede (Merge) Dikkat Edilecek Riskler ve Öneriler

1. **project.godot & .import Dosyaları:**
   - Ahmet'in çalışma ortamında Godot motorunun kendiliğinden ürettiği geçici `.import` veya `.uid` değişiklikleri bu dala dahil edilmemiştir. Festive'e merge edilirken yalnız bu daldaki kaynak dosyaların fast-forward veya no-ff merge ile alınması önerilir.
2. **metinler.csv Birleşimi:**
   - `metinler.csv` dosyasına hem yeni yer tutucular hem olay metinleri eklenmiştir. Başka bir daldan yeni metin anahtarı gelirse dosya toptan ezilmemeli (`checkout --theirs` yasağı), anahtar bazlı birleştirilmelidir.
3. **Parley Eklentisi:**
   - `addons/parley` eklentisi bağımsız bir eklenti klasörüdür. `project.godot` içinde eklenti kaydı açıldığında köy Parley sekansları sorunsuz görselleştirilebilir ve düzenlenebilir.
