# Antigravity İlerleme Dosyası — Görev 8

- **Ajan Adı:** Antigravity
- **Görev:** Görev 8 — Yer tutucu metinleri oyuna yerleştir, yeni ziyaretçileri derinleştir
- **Çalışma Dalı:** `feature/diyalog-yeniden-yazim`
- **Başlangıç Zamanı:** 4 Kasım 2026 03:30
- **İlke:** AGENTS.md kurallarına tam uyum; Kalfa'nın alanına (ISG, YSM, YAP, DEN, EKO) dokunulmaz; yalnızca `feature/diyalog-yeniden-yazim` dalına commit ve push atılır; parti parti çalışılır ve her parti sonrasında bu dosya güncellenir.

---

## Bölüm A — Festive Merge ve Doğrulama (TAMAMLANDI)
- `claude/festive-volta-li1sfm` dalı (Cursor PR #15–#27 birleşimi, commit `b5ceb33a`) başarıyla çekilip merge edildi (Merge commit `49fcf091`).
- Çakışan dosyalar iki tarafın da içeriği korunarak çözüldü:
  - `data/metin/metinler.csv`: Hem yeni olaylar hem de Cursor PR ayarlar/hafıza/menü anahtarları korundu; `tools/metin_dogrula.py` PASS.
  - `data/soz/gecis.json`: Hem `yeni_motor: []` listesi hem de 30 karakterlik geçiş haritası korundu.
  - `src/soz/beyan_defteri.gd`: KAY-08/50/62 satır/tavan mekaniği ve DIY-06 API'si tek sınıfta birleştirildi.
  - `src/soz/soz_motoru.gd`: KAY-26/27/36/51 kayıt adaptörü ve DIY diyalog yürütücüsü birleştirildi; `yukle` metodu imza çakışması `Dictionary` dönüşüyle çözüldü.
  - `tests/unit/soz/altin_oynanis_test.gd`: 15 Yusuf altın testi ve tekil altın oynanış testi birleştirildi.
- Test düzeltmeleri (`dac9daa4`):
  - `src/sistemler/perde_metni.gd`: Statik fonksiyondan `tr()` çağrısı `TranslationServer.translate()` ile güncellendi.
  - `src/sistemler/gecis_gecesi.gd`: Mock ve `KoyYonetimi` nesneleri için özellik/meta okuması sağlandı.
  - `src/soz/soz_semasi.gd`: `bos_metin_anahtari` kontrolü şemaya eklendi.
  - `src/soz/soz_motoru.gd`: `soz_kesme` sabır düşüşü mükerrerlikten arındırıldı.
  - `tests/unit/soz/omurga_metinleri_test.gd`: Dizi metodu çağrısı ve KOP şeması doğrulandı.
- **Doğrulama Sonuçları:**
  - `tools/metin_dogrula.py`: PASS
  - `tools/soz_dogrula.py`: PASS
  - `tools/soz_tasarimi_dogrula.py`: PASS
  - `tools/soz_kapi.py` & `tools/soz_kadro_denetimi.py`: PASS
  - Godot Headless birim testleri (13/13): PASS (`konu_merkezi`, `derinlesme`, `sira_sabri`, `beyan_defteri`, `celiski_yuzlesme`, `sir_ikilem`, `guven_korku`, `soz_kesme`, `gecis`, `omurga_metinleri`, `aksam_sohbeti`, `hane`, `soylenti_agi`).
- **Son Commit:** `dac9daa4` (push edildi).
- **Kota:** %60 kaldı.

---

## Bölüm B — Yer Tutucu Metinlerin Yerleştirilmesi

### Parti B1: Nöbet Raporları & Sabah Hüküm Satırı (TAMAMLANDI)
- `nobet.rapor.devir`, `nobet.rapor.sabaha_kalmadi`, `nobet.rapor.bos`, `nobet.rapor.sayim`, `nobet.rapor.tipi_bos`, `nobet.rapor.tipi`, `nobet.rapor.uyudu`, `sabah.hukum.satir` (8 anahtar).
- Metinler `data/metin/metinler.csv` içine eklendi; `docs/YER_TUTUCU_METINLER.csv` dosyasında `yerlesti` olarak işaretlendi.
- `tools/metin_dogrula.py`: PASS.
- Testler: `tests/unit/koy/kapi_nobeti_test.gd` (PASS), `tests/unit/koy/sabah_defteri_test.gd` (PASS).

### Parti B2: Tezgâh Siparişleri & Mevsim Yıl İzi (TAMAMLANDI)
- `tez.cumle.tam`, `tez.cumle.egri`, `yil.yuz`, `yil.guz_sofra`, `yil.guz_harman`, `yil.kis_disari`, `yil.kis_ev`, `yil.ilkbahar_tarla`, `yil.ilkbahar_taskin`, `yil.yaz_su` (10 anahtar).
- Metinler `data/metin/metinler.csv` içine eklendi; `docs/YER_TUTUCU_METINLER.csv` dosyasında `yerlesti` olarak işaretlendi.
- `tools/metin_dogrula.py`: PASS.
- Testler: `tests/unit/koy/tezgahta_gun_test.gd` (PASS), `tests/unit/koy/yil_izi_test.gd` (PASS).

### Parti B3: Özel Olay Kart Metinleri (TAMAMLANDI)
- `olay.asik.baslik`, `olay.asik.metin`, `olay.asik.dinle`, `olay.asik.gonder`, `olay.asik.sonuc1`, `olay.asik.sonuc2`, `olay.kadi.baslik`, `olay.kadi.metin`, `olay.kadi.dinle`, `olay.kadi.gecistir`, `olay.kadi.sonuc1`, `olay.kadi.sonuc2` (12 anahtar).
- Metinler `data/metin/metinler.csv` içinde güncellendi; `docs/YER_TUTUCU_METINLER.csv` dosyasında `yerlesti` olarak işaretlendi.
- `tools/metin_dogrula.py`: PASS.
- Testler: `tests/unit/olay/ozel_olay_test.gd` (PASS, 0 hata).

---

## Sıradaki Adım
- **Parti B4:** `hafiza.*`, `koy.eylem.defter`, `arayuz.duraklat.defter` (20 anahtar) hafıza defteri metinlerinin yerleştirilmesi.
