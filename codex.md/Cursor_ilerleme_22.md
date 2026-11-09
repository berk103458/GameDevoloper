# Cursor — Görev 22 ilerleme (10 Kasım 2026)

Görev: `codex.md/Antigravity_gorev.md` Görev 22 ve eki (Antigravity kotası bittiği için, Ahmet onayıyla). Çalışma dalı `cursor/gorev22-sah-denetim-8f89`, her commit festive'e fast-forward gitti. Force push yok.
Ortam: Godot 4.7.2 `ed1daf0bf` headless. Her turda `godot --headless --import`, sonra yalnız hedefli testler; tam sanity koşulmadı.

## 1. SAH kanıt denetimi

Tablo: `docs/SAH_KANIT_TABLOSU.md`.

- `[x]` kalan: 8 (SAH-41, 42, 43, 44, 45, 46, 48, 49).
- Geri açılan: 38. SAH-01, 03…07 ve 17…33, 35…37, 39, 40 "Kalfa bekleniyor"; 08…10, 12…16, 47, 50 nedenleriyle.
- Zaten açık, dokunulmadı: SAH-02, 11, 34, 38. Kalfa'nın SAH-51+ maddelerine dokunulmadı.
- Test: `tests/unit/dunya/sah_kamera_kanit_test.gd` → `SAH KAMERA KANIT: GEÇTİ (31 kontrol)`. Kısıt satırı silinince `SAH KAMERA KANIT: KALDI (4 hata / 31 kontrol)` ve çıkış 1.
- `src/dunya/karakter_model.gd`: Görev 21'deki sahte `AyakZemini` bağı kaldırıldı. Topuğu değil kökü sıkıştırıyordu ve her modelde `sahne.json` okuyordu.

## 2. Kök temizliği

- `ilerleme_21` silindi. `ilerleme_20` yoktu. `_tmp_*` ve `_doc_*` dosyalarına dokunulmadı.

## 3. Genel düzeltme

Rapor: `docs/denetim/2026-11-10-gorev22-bagsiz-maddeler.md`.

- **YAZ-06:** `tests/unit/soz/toplu_yazim_test.gd` derlenmiyordu. 1099 betikten derlenmeyen tek dosya buydu. Test → `TEST PASS: toplu_yazim_test.gd`.
- **Çeviri dosyaları:** `metinler.tr/en.translation` 433 anahtar gerideydi ve HUD biçim hatası veriyordu. Yeniden üretildi; `tools/metin_dogrula.py` → `PASS .../data/metin/metinler.csv`.
- **Köy girdisi:** `src/arayuz/koy_ekrani.gd:355` fare hareketinde `SCRIPT ERROR` veriyordu. `is_pressed()` ile düzeltildi. `tests/unit/arayuz/girdi_test.gd` → `GIRDI: GEÇTİ (0 hata)`. YAP-62 testinin kaydında düzeltmeden önce bu `SCRIPT ERROR` vardı, sonra 0.
- **Oyuna bağlı olmayan `[x]` maddeler:** 74 madde geri açıldı. Hepsinin sınıfı yalnız testten çağrılıyor ya da dosyası yok:
  - `SoylentiAgi`: 46 SOY maddesi ve SOY-SON-01.
  - CAT-01, CAT-02, CAT-04, DYL-03, SEV-01…05, OGR-14, OGR-24, OMR-08, OMR-10, AYR-29, AYR-33.
  - Cursor'un kendi maddeleri: YIL-01, 02, 05, 09, 10, AYR-11, AYR-41.
  - HAN-13, HAN-34, KVR-SES-01, DYL-14.
- **Şüpheli, dokunulmadı:** Elle bakılması gereken 22 madde raporda listelendi.
- **Koşulan diğer testler:** Kalfa'nın `tests/oto/kapi_firtina_kuyrugu_kontrol.tscn` testi çıkış 0 verdi (`FIRTINA KUYRUK UI: GEÇTİ`). `sahne_ayak_esya_test`, `hareket_gecisi_test` ve `sahne_yol_kamera_test` geçti; ama bunlar yardımcı fonksiyon testidir, SAH kanıtı sayılmadı.

## 4. Yeni ROADMAP maddeleri

- **YAP-62 `[x] (Cursor)`:** `tests/unit/koy/yapi_karti_model_test.gd` (+ `.uid`) → `YAP-62 KART MODEL: GEÇTİ (10 kontrol)`. Gerçek köy ekranında dört kategori düğmesine ve kartlara fareyle basılır. Mesh farkı 0, kayıt farkı 0. Asset gerekmedi.
- **KLT-48 `[x] (Cursor)`:** `tools/soz_kapi.py` eski konuşma cümlesini (diyalog_01_20 ve SohbetVerisi satırları, 1617 cümle) hata sayar; `--eski-tara` ile `data/soz` taranır. `python3 -m unittest tests.tools.test_soz_kapi` → `Ran 37 tests ... OK`. `python3 tools/soz_kapi.py --eski-tara` → `eski_kopya=0`. Asset gerekmedi.
- **Alınamayanlar ve nedenleri:**
  - ISG-39: SOY-34 geri açıldı; ROADMAP'e not düşüldü.
  - DEN-37 ve DEN-38: ACL-02 testx'in `[/]` sahipliğinde.
  - OGR-23 ve OMR-33: KAP-16 testx'in `[/]` sahipliğinde.
  - ARY-02/03/04/70, YAP-55, GRV-02: ARY-01 seçimini bekliyor.
  - KLT-14 ve KLT-47: DYL-14 geri açıldı.
  - OGR-39: `AksamSohbeti` oyuna bağlı değil.

## 5. Festive'e giden commit'ler

`e7a0fb79`, `234f9c29`, `ec20e3c7`, `3e3b112d`, `4a2ce9e7`, `bdd21dd3`, `1cf58bd9`, `24ad9d30`, `5a1fe9d1`, `0c3ce20b` ve bu ilerleme commit'i.

kota görünmüyor

GOREV22_TAMAM
