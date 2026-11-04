# Antigravity İlerleme Dosyası — Görev 17

- **Ajan Adı:** Antigravity
- **Görev:** Görev 17 — Ahmet'in hikâye kararlarını uygula ve onaylanan 7 ROADMAP önerisini tamamla
- **Çalışma Dalı:** `feature/diyalog-yeniden-yazim`
- **Hedef Dal:** `claude/festive-volta-li1sfm` (Ahmet onaylı fast-forward push)
- **Başlangıç Zamanı:** 4 Kasım 2026 09:00
- **İlke:** AGENTS.md kurallarına tam uyum; parti parti çalışma; her parti sonunda ilerleme dosyası güncelleme ve commit/fast-forward push.
- **Kota:** %15 kaldı.

---

## Genel Durum ve Plan

- [x] **Parti 1 — Ahmet'in Hikâye Kararlarının Uygulanması:**
  - [x] **Karar 1 (Banu Hatun) → Seçenek 1.1 İttifak ve Süvari Muhafızları:**
    - `data/diyalog/diyalog_01_20.json` ve `data/diyalog/en/diyalog_01_20.json` içinde `diyalog_28` güncellendi (50 Türkmen atlısı ittifakı, `banu_ittifak_kabul` bayrağı, kabul yanıtı).
    - `data/diyalog/es_kapi_dusunceleri.json` ve `data/diyalog/en/es_kapi_dusunceleri.json` güncellendi (`karar_oncesi` ve `karar_kabul`).
    - `data/parley/koy/koylu_muhabbet_karaca_usta.ds` ve `data/parley/en/koy/` içinde `node:opt_banu` diyaloğu ve +2 moral aksiyonu bağlandı.
    - `data/parley/koy/koylu_muhabbet_es.ds` ve `data/parley/en/koy/` içinde `node:opt_z_banu` güncellendi.
  - [x] **Karar 3 (Vebalı Sabi ve Anası) → İki Seçenek De Oyunda (Koşullu Çift Dal):**
    - `data/diyalog/diyalog_01_20.json` ve `data/diyalog/en/` içinde `diyalog_24` güncellendi:
      - 3.1 Şifa & Kurtuluş dalı: Miraen kükürt/adaçayı ilacı ve ateşli tecrit (`veba_kirec_karantina_basarili`).
      - 3.2 Dramatik Kayıp dalı: Dondurucu ayazda kireç kuyusuna tecrit (`sabi_vefati_kis_matemi`).
      - Dinamik kabul yanıtları: `kabul_sifa` ve `kabul_kayip`.
    - `src/kapi/es_yorumu_adaptoru.gd` ince adaptörü oyuncunun sorgudaki seçimine göre dinamik olarak doğru kabul yanıtını ve eş yorumunu (`karar_kabul_sifa` vs `karar_kabul_kayip`) devreye sokacak şekilde güncellendi.
    - `data/parley/koy/koylu_muhabbet_miraen.ds` ve `data/parley/en/koy/` içine hem `node:opt_veba_sifa` (+3 moral) hem `node:opt_veba_kayip` (-3 moral) eklendi.
    - `data/parley/koy/koylu_muhabbet_es.ds` ve `data/parley/en/koy/` içine hem `node:opt_z_veba_sifa` (+2 moral) hem `node:opt_z_veba_kayip` (-2 moral) eklendi.
  - [x] **Karar 2 (Molla Şükrü) → BEKLİYOR:** Dokunulmadı, mevcut hali korundu.
  - [x] `data/metin/metinler.csv` içine karar metinleri (TR & EN) eklendi (`karar.banu.ittifak.*`, `karar.veba.sifa.*`, `karar.veba.kayip.*`).
  - [x] `docs/KARAR_SECENEKLERI.md` dosyası güncellendi (Karar 1.1 UYGULANDI, Karar 2 BEKLİYOR, Karar 3 UYGULANDI Çift Son). Koşul mantığı ve ipuçları detaylandırıldı.
  - [x] `tests/unit/diyalog/karar_secenekleri_test.gd` yeni birim testi yazıldı ve 0 hatayla geçti.
  - [x] Testler: Python doğrulayıcıları PASS, Godot headless (karar_secenekleri_test, diyalog_butunluk_test, ingilizce_entegrasyon_test, es_yorumu_test, koy_parley_sistemi_test) PASS.
  - [x] Commit & Push: `KARAR-01-03: Banu Hatun ittifakı (1.1) ve Vebalı sabi çift son koşullu dalı (3.1/3.2) entegrasyonu (Antigravity)`

- [x] **Parti 2 — ROADMAP_2.md'ye 7 Yeni Maddenin Eklenmesi:**
  - [x] `docs/ROADMAP_ONERILERI_ANTIGRAVITY.md`'deki 7 önerinin tamamı (ANL-DON-01, ES-GECM-01, ANL-EPI-01, SOY-SON-01, KVR-SES-01, MECLIS-ARA-01, SES-DIL-01) `ROADMAP_2.md`'ye eklendi.
  - [x] Sahiplikler açıkça belirtildi: Kod isteyen kısımlar Kalfa'ya (`sonuc_epilog_olusturucu.gd`, hava entegrasyonu), anlatı ve diyalog Antigravity'ye.
  - [x] Commit & Fast-Forward Push: `ROADMAP-ONERI-01: Ahmet tarafindan onaylanan 7 yeni anlati ve diyalog maddesinin ROADMAP_2'ye eklenmesi (Antigravity)`
- [x] **Parti 3 — ES-GECM-01 & ANL-DON-01 Uygulanması:**
  - [x] **ES-GECM-01 (Eşin Geçmişi ve Anlatı Yayları):**
    - `data/parley/koy/koylu_muhabbet_es.ds` ve `data/parley/en/koy/koylu_muhabbet_es.ds` içine 3 derin anlatı dalı (Eski köy yangını/göç, yetimler ve çocuksuzluk hüznü, ayazda şifalı ıhlamur/bal) tam etkileşimli diyalog düğümleri ve ahlaki seçimlerle eklendi.
    - `data/soz/aksam_konulari.json` ve `data/soz/en/aksam_konulari.json` içine 3 yeni akşam dertleşme konusu (`es_yangin_ve_goc`, `es_yetim_ve_cocuk`, `es_gece_sifasi`) eklendi.
    - `ROADMAP_2.md` üzerinde `ES-GECM-01 [x] (Antigravity)` olarak işaretlendi.
  - [x] **ANL-DON-01 (Ziyaretçi Geri Dönüş Döngüsü - Echo Visits):**
    - `data/diyalog/diyalog_donusler.json` ve `data/diyalog/en/diyalog_donusler.json` oluşturuldu (6 kritik karakterin 5-10 gece sonra kapıda ve meydanda dönüş sekansları: Sungur hasım dönüşü, Sungur müttefik teftiş ihbarı, Turna & Dursun ilk fırın ekmeği, Lokman sahte merhem arbedesi, Banu Hatun zafer ganimeti, Behram vefa hediyesi).
    - `ROADMAP_2.md` üzerinde `ANL-DON-01 [x] (Antigravity)` olarak işaretlendi.
  - [x] `tests/unit/diyalog/es_gecmis_ve_donusler_test.gd` birim testi yazıldı ve 0 hatayla geçti.
  - [x] Commit & Fast-Forward Push: `feat(ES-GECM-01, ANL-DON-01): Eşin geçmişi anlatı yayları ve ziyaretçi geri dönüş döngüsü entegrasyonu (Antigravity); asset gerekmedi`
- [x] **Parti 4 — SOY-SON-01 & MECLIS-ARA-01 Uygulanması:**
  - [x] **SOY-SON-01 (Söylenti Ağının Somut Olaylara Kapanışı):**
    - 5 somut kapanış olayı (`soylenti_degirmen_kapanis`, `soylenti_kuyu_kapanis`, `soylenti_tekfur_araba_kapanis`, `soylenti_mogol_casus_kapanis`, `soylenti_vebali_kumas_kapanis`) `data/olaylar/*.tres` olarak oluşturuldu.
    - `src/sistemler/soylenti_agi.gd` içine `soylenti_kapanis_olayi_al` ve `soylenti_kapanisi_uygula` fonksiyonları eklendi.
    - `data/metin/metinler.csv` içine 10 yeni metin satırı (TR & EN) eklendi.
    - `ROADMAP_2.md` üzerinde `SOY-SON-01 [x] (Antigravity)` olarak işaretlendi.
  - [x] **MECLIS-ARA-01 (Çınar Meclisi İnteraktif Dava Sistemi):**
    - `data/parley/koy/meclis_davalari.ds` ve `data/parley/en/koy/meclis_davalari.ds` oluşturuldu (Karaca Usta vs Yusuf balta davası, Ayşe Bacı vs Çuhacı boya davası, Aydoğdu vs Molla Şükrü mera davası, Thessra vs Miraen şifahane davası).
    - `ROADMAP_2.md` üzerinde `MECLIS-ARA-01 [x] (Antigravity)` olarak işaretlendi.
  - [x] `tests/unit/kvr/soylenti_ve_meclis_davalari_test.gd` birim testi yazıldı ve 0 hatayla geçti.
  - [x] Commit & Fast-Forward Push: `feat(SOY-SON-01, MECLIS-ARA-01): Söylenti kapanış olayları ve Çınar Meclisi interaktif dava sistemi (Antigravity); asset gerekmedi`
- [ ] **Parti 5 — ANL-EPI-01, KVR-SES-01, SES-DIL-01 & Bitiş**
