# Diyalog Dalı Birleşme Notu (`feature/diyalog-yeniden-yazim`)

- **Tarih:** 4 Kasım 2026, 08:35 (Görev 16 Bölüm A — Festive Entegrasyonu)
- **Ajan:** Antigravity
- **Hedef Dal:** `claude/festive-volta-li1sfm`
- **Kaynak Dal:** `feature/diyalog-yeniden-yazim`
- **Entegre Edilen Son Festive Commit'i:** `7646b8d519d5f04b123687259021e10260714fc2` (Kalfa — "Yetenek kapalıyken esnaftan haraç alınmadığını doğrula")

---

## 1. Genel Özet ve Kapsam

Bu dal, Görev 3'ten Görev 15'e kadar Kapı Muhafızı'nın bütün anlatı, diyalog, yerelleştirme metinleri, köy içi NPC konuşma sistemleri, İngilizce taslakları ve karar/öneri paketlerinin hazırlanması amacıyla yürütülmüştür.

- **30 Kapı Ziyaretçisi:** Baştan sona insanlaştırılmış, alt sorular (3 kademe), soru takip bayrakları, yalan/doğru dalları ve derin diyalog ağaçları (`data/diyalog/diyalog_01_20.json`).
- **Eş Diyalog ve Karar Sistemi:** Kapı ekranında 4 aşamalı eş fısıltı ve kanaat adaptörü (`data/diyalog/es_kapi_dusunceleri.json`, `src/kapi/es_yorumu_adaptoru.gd`), oda içi 120+ düğümlü Parley eş muhabbet ağacı (`data/parley/koy/koylu_muhabbet_es.ds`).
- **Köy İçi Parley Sistemi:** 11 adli köylü muhabbet ağacı ve 6 köy sekansı (`data/parley/koy/*.ds`), ince adaptör (`src/diyalog/parley_koy_adaptoru.gd`, `src/diyalog/koy_diyalog_yoneticisi.gd`).
- **8 Yeni Köy Olayı:** Karar seçenekleri, ambar/akçe şartları ve 4 bar etkileri (`data/olaylar/*.tres`).
- **85 Yer Tutucu Metin:** Gece birleşen PR #15–#27 metinlerinin tamamı (`nobet.rapor.*`, `sabah.hukum.*`, `tez.cumle.*`, `yil.*`, `hafiza.*`, `arayuz.girdi.*` vb.) `metinler.csv` içine yerleştirildi (%100).
- **Söz Motoru ve Omurga:** `src/soz/` çekirdeği, hafıza/beyan defteri entegrasyonu, perde geçişleri, epiloglar ve dedikodu/söylenti ağı.
- **İngilizce Taslak Paketi (Görev 10–12):** Çalışan dosyalara dokunulmadan `docs/INGILIZCE_METIN_TASLAGI.csv` (2330 anahtar), `docs/ingilizce_diyalog/` (30 ziyaretçi, köylüler, eş ve sekanslar) ve `docs/INGILIZCE_TERIM_SOZLUGU.md` hazırlandı.
- **Karar Seçenekleri ve Yamaları (Görev 10 & 13):** Banu Hatun'un 50 atlısı, Molla Şükrü meclis yüzleşmesi ve Vebalı sabi için 6 bağımsız yama paketi (`docs/karar_yamalari/`) ve `UYGULA.md` rehberleri hazırlandı.
- **Yol Haritası Öneri Taslakları (Görev 14):** 7 anlatı önerisi için `docs/oneri_taslaklari/` altında tam replikler, bayraklar ve kod rehberleri hazırlandı.
- **2D Portre ve Sahne Promptları (Görev 13–14):** 30 ziyaretçi portresi, 10 köylü portresi ve 17 sahne/kart için toplam 57 adet Nano Banana promptu `docs/arayuz/DIYALOG_ASSET_PROMPTLARI.md` ve `docs/EKSIK_ASSET_ENVANTERI.md` içine işlendi.

---

## 2. Festive Entegrasyonu ve Çakışma Durumu

- **Merge Süreci:** `origin/claude/festive-volta-li1sfm` dalından Kalfa'nın son commit'leri (`7646b8d5` dahil) çekilmiş ve merge edilmiştir.
- **Çakışma (Conflict):** **0 çakışma**. `ROADMAP_2.md` dosyası Git tarafından otomatik ve temiz bir şekilde birleştirilmiştir.
- **Kalfa Alanı:** Kalfa'nın denge tabloları (`data/ayarlar/denge.json`, `data/ayarlar/denge_sinirlari.json`), birim testleri (`tests/unit/denge/aclik_uretim_test.gd`, `tests/unit/denge/rusvet_test.gd`), araçları (`tools/denge_dogrula.py`, `tests/tools/test_denge_dogrula.py`) ve oda paneli kodları aynen korunmuştur.
- **Cursor Alanı:** Gece birleşen PR kodlarına dokunulmamış, yalnızca bekledikleri metinler yerleşmiş durumdadır.

---

## 3. Test Sonuçları (Sıfır Hata Politikası)

Merge sonrası yapılan doğrulama ve birim testlerinde **tüm testler sıfır hatayla geçmiştir**:

1. **Python Doğrulayıcıları:**
   - `tools/metin_dogrula.py`: PASS
   - `tools/soz_dogrula.py`: PASS (KAY-53 chr=30, adli=30)
   - `tools/soz_tasarimi_dogrula.py`: PASS
   - `tests/tools/test_asset_envanteri.py`: 6/6 OK
   - `tests/tools/test_denge_dogrula.py`: 14/14 OK (Kalfa'nın yeni testleri)
   - `tools/denge_dogrula.py`: GECTI
   - `docs/dogrula_ingilizce_taslak.py`: 2330 CSV satırı, 6 JSON, 18 .ds dosyası (0 hata, 0 uyarı)

2. **Godot Headless Birim Testleri (16/16 PASS):**
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
   - `tests/unit/koy/aksam_sohbeti_test.gd`: PASS (0 hata)
   - `tests/unit/koy/hane_test.gd`: PASS (0 hata)
   - `tests/unit/kvr/soylenti_agi_test.gd`: PASS (0 hata)
   - `tests/unit/denge/aclik_uretim_test.gd`: PASS (0 hata — Kalfa'nın yeni testi)

3. **Söz Motoru Birim Testleri:**
   - `tests/unit/soz/*.gd` (40 test dosyasının tamamı): PASS (0 hata)

4. **Regresyon:** 0 adet. Bu merge yüzünden hiçbir test kırmızıya düşmemiştir.

---

## 4. Birleştirmede (Merge) Dikkat Edilecek Riskler ve Öneriler

1. **Çakışma Riski Bulunmamaktadır:** Dal, festive'in en güncel commit'i (`8c32c453`) ile zaten birleştirilmiş ve tüm testler yeşildir.
2. **Yerel Dosya Ayrımı:** Ahmet'in yerel çalışma kopyasında Godot motorunun kendiliğinden ürettiği `.import` veya `.uid` dosyaları bu dala dahil edilmemiştir; festive'e aktarılırken temiz bir merge (fast-forward veya no-ff) ile doğrudan aktarılabilir.
3. **Mevcut Mimari Uyum:** Hiçbir çekirdek sınıf yeniden yazılmamış, tüm sistemler ince adaptörlerle bağlanmıştır.
