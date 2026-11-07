# Antigravity İlerleme Dosyası — Görev 18

- **Ajan Adı:** Antigravity
- **Görev:** Görev 18 — Uzun metin oturumu (`ROADMAP_2.md` açık maddelerinin metin/diyalog/karakter kısımları ve İngilizce denetimi)
- **Çalışma Dalı:** `feature/diyalog-yeniden-yazim`
- **Hedef Dal:** `claude/festive-volta-li1sfm` (Ahmet onaylı fast-forward push)
- **Başlangıç Zamanı:** 7 Kasım 2026
- **İlke:** AGENTS.md kurallarına tam uyum; parti parti çalışma; her madde sonunda ROADMAP işaretleme, doğrulama, commit ve fast-forward push.

---

## Ahmet dönünce önce bunu oku

### 1. Neler Bitti?
- **Görev 19 (Öncelik 1):** Karar 2 (Molla Şükrü — Seçenek 2.1 Çınar Meclisi'nde Aleni Mahkeme) %100 tamamlandı ve `claude/festive-volta-li1sfm` dalına aktarıldı (`2fb251cb`).
- **Görev 18 (Devam Eden Uzun Metin Oturumu):**
  - [x] **Parti 1 — KAP-18 (Yetimler ve savaştan kaçan çocuklar):** Kapıya gelen çocuk kafilesi diyalog ağaçları (`data/soz/yetim_kafilesi.json` TR & EN), kabul/ret/emanet sonuç metinleri (`data/metin/metinler.csv` TR & EN), çocukların geçmiş notları ve birim testi (`tests/unit/diyalog/kap18_yetim_metinleri_test.gd`) tamamlandı.
  - [x] **Parti 2 — YAP-03, YAP-24, YAP-28, YAP-29 (Ustalar kapıdan gelir):** Adlı, geçmişi olan özel usta karakterleri (`data/ustalar.json`, `data/soz/usta_*.json` TR & EN), kapı pazarlık diyalogları (ücret, ev, aile), köydeki replikleri ve usta çocuğunun çırak olma hikâyesi (`data/metin/metinler.csv` TR & EN) tamamlandı.
  - [x] **Parti 3 — YAP-04, YAP-37, YAP-51 (Usta defterleri, yapı resimleri ve özel eşya açıklamaları):** Kalfa'nın `data/usta_defterleri.json` yapısını bozmadan zengin defter metinleri, DYL-08 defter sözü dönüş metinleri (`src/soz/karar_donusu.gd` / `data/metin/metinler.csv` TR & EN) ve 8 özel eşya için dünya kitabı kaynak notlu açıklama anahtarları (`data/ozel_esyalar.json` + `data/metin/metinler.csv` TR & EN) tamamlandı.
  - [x] **Parti 4 — DNY-01 – DNY-04 (Dünya zaman çizelgesi, haberler, köy etkisi ve kararların dönüşü):** Altı büyük dünya olayı için `data/dunya/zaman_cizelgesi.json` (TR & EN) zaman çizelgesi yapısı, erken söylenti ve kesin haber replikleri (en az 2'şer özgün karakter satırı, TR & EN), kararların dünyaya geri dönüş replikleri ve birim testi (`tests/unit/diyalog/dunya_cizelge_metin_test.gd`) tamamlandı.
  - [/] **Parti 5 — İngilizce Diyalogların Baştan Sona İncelenmesi ve Düzeltilmesi (`docs/DENETIM_6KASIM.md`):** `data/diyalog/en/diyalog_01_20.json` içindeki `diyalog_02`–`diyalog_20` Türkçe kalmış iç dalların ve jenerik yanıtların tam İngilizceye çevrilmesi, CSV'de Türkçe kalmış satırların (`koy.iflas.*`, `koy.kart.*`, `koy.sancak.*`, `koy.coban.*` vb.) doğal İngilizceye çevrilmesi ve denetim raporunun yazılması.

### 2. Kalfa'nın Ne Yapması Gerekiyor? (Kod Bağlantı Noktaları)
- **KAP-18:** `src/koy/yetim_bakimi.gd` içinde dünya savaş olayından sonra çocuk kafilesi ağırlığının açılması, kabul edilen çocuğun haneye/eşe bağlanması ve 28. günde `Koylu.yas_grubu` değerinin gence/yetişkine dönüp çırak düğmesinin açılması (metin anahtarları `kap18.yetim.*` ve söz ağacı `res://data/soz/yetim_kafilesi.json` hazır).
- **YAP-03:** `src/kapi/usta_gelisi.gd` içinde `res://data/ustalar.json` ve `res://data/soz/ustalar_kapi.json` verilerinin kapı kuyruğuna ve `koy_akce` kamu kasası pazarlığına bağlanması.
- **YAP-06:** `src/koy/ozel_esyalar.gd` içinde `res://data/ozel_esyalar.json` dosyasındaki 8 özel eşyanın çözümleme ve gece hesabı çarpanlarına bağlanması (açıklama anahtarları `esya.ozel.*` olarak `metinler.csv` içinde hazır).
- **DNY-01 – DNY-04:** `src/sistemler/dunya_zamani.gd` ve `src/sistemler/dunya_etkisi.gd` sistemlerinin `res://data/dunya/zaman_cizelgesi.json` ve `metinler.csv` içindeki `dunya.olay.*` / `dunya.haber.*` / `dunya.donus.*` anahtarlarına bağlanması.

### 3. Sorular / Kararlar
- Şu an için bloklayıcı soru yoktur; Kalfa'nın mevcut şemaları (`data/usta_defterleri.json`, `src/koy/cozumleme.gd`, `src/kapi/aile_kafilesi.gd`) birebir korunarak metin ve veri dosyaları tam uyumlu hazırlanmaktadır.

---

## Ayrıntılı İlerleme Kaydı

- [x] **Adım 1:** `origin/claude/festive-volta-li1sfm` ile senkronizasyon doğrulandı (`2fb251cb`).
- [x] **Parti 1 (KAP-18):** Yetimler ve savaştan kaçan çocuklar metin/diyalog paketi tamamlandı (`data/soz/yetim_kafilesi.json` TR/EN, `kap18.yetim.*` CSV anahtarları, `tests/unit/diyalog/kap18_yetim_metinleri_test.gd`, `ROADMAP_2.md` işaretlemesi).
- [x] **Parti 2 (YAP-03, YAP-24, YAP-28, YAP-29):** Özel adlı ustalar (`usta_sinan_kalfa`, `usta_mihali_degirmenci`, `usta_tugrul_pusatci`, `usta_evhad_hekim`), `data/ustalar.json`, TR/EN kapı pazarlık diyalog ağaçları (`data/soz/usta_*.json`), `yap03.usta.*` / `yap28.cirak.*` / `yap29.usta.*` CSV anahtarları ve `tests/unit/diyalog/ustalar_metin_test.gd` birim testi tamamlandı.
- [x] **Parti 3 (YAP-04, YAP-37, YAP-51):** `data/usta_defterleri.json` içinde `defter_metinleri`, `src/soz/karar_donusu.gd` içinde DYL-08 defter sözü dönüşü (`YAP-37`), `data/ozel_esyalar.json` içinde 8 özel eşya ve `metinler.csv` anahtarları (`YAP-06`/`YAP-51`) ile `tests/unit/diyalog/ozel_esyalar_ve_defter_metin_test.gd` birim testi tamamlandı.
- [x] **Parti 4 (DNY-01 – DNY-04):** `data/dunya/zaman_cizelgesi.json` (TR & EN), `dunya.olay.*` / `dunya.haber.*` / `dunya.rapor.*` / `dunya.donus.*` CSV anahtarları, `ROADMAP_2.md` işaretlemeleri ve `tests/unit/diyalog/dunya_cizelge_metin_test.gd` birim testi tamamlandı.
- [/] **Parti 5 (İngilizce Diyalog Denetimi ve Düzeltmesi):** `data/diyalog/en/diyalog_01_20.json`, `data/metin/metinler.csv` ve `docs/DENETIM_6KASIM.md` hazırlanıyor...
