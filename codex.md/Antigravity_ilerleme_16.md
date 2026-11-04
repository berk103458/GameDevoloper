# Antigravity İlerleme Dosyası — Görev 16

- **Ajan Adı:** Antigravity
- **Görev:** Görev 16 — İngilizceyi oyuna ekle ve diyalog dalını festive'e birleştir
- **Çalışma Dalı:** `feature/diyalog-yeniden-yazim`
- **Başlangıç Zamanı:** 4 Kasım 2026 08:35
- **Bitiş Zamanı:** 4 Kasım 2026 08:55
- **İlke:** AGENTS.md kurallarına tam uyum; Kalfa ve Cursor kodlarına dokunulmaz; kullanıcı talimatı uyarınca yalnızca `feature/diyalog-yeniden-yazim` dalına commit ve push atılır; parti parti çalışılır ve her parti sonrasında bu dosya güncellenir.
- **Kota:** %15 kaldı.

---

## Genel Durum ve Plan
- [x] **Bölüm A — festive'i al ve birleştir (önce bu):**
  - [x] `git fetch origin` yapıldı (origin/claude/festive-volta-li1sfm commit `7646b8d5`).
  - [x] `origin/claude/festive-volta-li1sfm` dalı merge edildi (`ab9c10b2`). 0 çakışma, Kalfa'nın son testleri korundu.
  - [x] Doğrulayıcılar ve testler çalıştırıldı (Python araçları + 20/20 Godot headless birim testleri sıfır hatayla geçti).
  - [x] `docs/DIYALOG_DALI_BIRLESME_NOTU.md` dosyası güncellendi.
  - [x] BIRLESME commit'i atıldı (`ab9c10b2`) ve kullanıcı talimatı uyarınca yalnızca `feature/diyalog-yeniden-yazim` dalına push edildi.
- [x] **Bölüm B — İngilizceyi oyuna ekle:**
  - [x] `codex.md/Antigravity_gorev.md` içindeki "Antigravity sorusu 3" Ahmet'in sabah onayıyla cevaplandı olarak işaretlendi.
  - [x] `tests/unit/arayuz/dil_test.gd` testi Türkçe varsayılan kalacak, İngilizce ikinci dil olarak izinli olacak şekilde güncellendi (`DIL: GEÇTİ (0 hata)`).
  - [x] `docs/INGILIZCE_METIN_TASLAGI.csv` içeriği `data/metin/metinler.csv` içine `en` sütunu olarak eklendi (2147 satır, 2331 anahtar). `arayuz.dil.en` ("İngilizce" / "English") dahil edildi.
  - [x] `tools/metin_dogrula.py --kaynak` sıfır hatayla doğrulandı.
  - [x] `data/metin/metinler.en.translation` derlendi ve `DilAyari` üzerinden dinamik olarak bağlandı. Ayarlar menüsü `DilSekmesi` dilleri otomatik olarak listeliyor.
  - [x] İngilizce diyalog paketleri oyun klasörlerine yerleştirildi:
    - `data/diyalog/en/` (30 kapı ziyaretçisi ve eş düşünceleri)
    - `data/soz/en/` (akşam dertleşme konuları)
    - `data/parley/en/koy/` (18 Parley NPC ve ortam sekansı)
  - [x] İnce adaptörler dillere duyarlı hale getirildi (Türkçe varsayılan korunarak, İngilizce seçildiğinde İngilizce dosyalar devreye giriyor):
    - `src/sistemler/oturum.gd`: `_gemini_al` fonksiyonunda `en` kontrolü.
    - `src/kapi/es_yorumu_adaptoru.gd`: `_veri_yukle` fonksiyonunda `en` kontrolü.
    - `src/diyalog/koy_diyalog_yoneticisi.gd`: `sekans_yukle` fonksiyonunda `en` kontrolü.
    - `src/koy/aksam_sohbeti.gd`: `veri_al` fonksiyonunda `en` kontrolü.
  - [x] `tests/unit/sistemler/hafiza_defteri_test.gd`: `tr("hafiza.bos.karar")` gerçek çeviri kontrolü eklendi (`HAFIZA DEFTERI (HFZ-01…32): GEÇTİ (0 hata)`).
  - [x] `tests/unit/diyalog/ingilizce_entegrasyon_test.gd` yeni birim testi yazıldı: Türkçe varsayılan metinler, İngilizce çeviriler, YER-17 karakter adı koruması, JSON ve Parley yüklemeleri ve dile dönüş uçtan uca doğrulandı (`INGILIZCE ENTEGRASYON TESTI: GECTI (0 hata)`).
  - [x] Tüm doğrulayıcılar ve Godot headless testleri çalıştırıldı:
    - Python: `metin_dogrula.py --kaynak` (PASS), `soz_dogrula.py` (PASS), `soz_tasarimi_dogrula.py` (PASS), `test_asset_envanteri.py` (6/6 OK), `test_denge_dogrula.py` (15/15 OK), `denge_dogrula.py` (GECTI), `dogrula_ingilizce_taslak.py` (0 hata, 0 uyarı).
    - Godot Headless: 21 testin tamamı (21/21 PASS, 0 hata).
  - [x] `docs/DIYALOG_GECE_OZETI.md` 9. bölümle güncellendi.
  - [x] `codex.md/Antigravity.md` günlüğüne Görev 16 raporu işlendi.
  - [x] DIL-EN commit'i atıldı ve kullanıcı talimatı uyarınca yalnızca `feature/diyalog-yeniden-yazim` dalına push edildi.

---

GOREV16_TAMAM
