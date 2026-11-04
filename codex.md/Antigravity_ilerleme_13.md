# Antigravity İlerleme Dosyası — Görev 13

- **Ajan Adı:** Antigravity
- **Görev:** Görev 13 — Karar seçeneklerini uygulamaya hazır hale getir, eksik 2D asset promptlarını tamamla
- **Çalışma Dalı:** `feature/diyalog-yeniden-yazim`
- **Başlangıç Zamanı:** 4 Kasım 2026 06:32
- **İlke:** AGENTS.md kurallarına tam uyum; Kalfa ve Cursor alanındaki kodlara dokunulmaz; oyunun çalışan dosyalarına, testlere ve `metinler.csv`'ye dokunulmaz (yalnızca `docs/` ve `codex.md/` altına yazılır); yalnızca `feature/diyalog-yeniden-yazim` dalına commit ve push atılır; parti parti çalışılır ve her parti sonrasında bu dosya güncellenir.
- **Kota:** %35 kaldı

---

## Genel Durum ve Plan
- [/] **Bölüm A — Karar Seçenekleri Uygulamaya Hazır Paketler:**
  - [x] **Parti A1 — Karar 1 (Banu Hatun'un Dağdaki 50 Atlısı):**
    - `docs/karar_yamalari/karar_1_ittifak_suvari/` (Seçenek 1.1 — İttifak & Savunma)
    - `docs/karar_yamalari/karar_1_yalniz_kabul/` (Seçenek 1.2 — Yalnız Kabul & İhtiyat)
    - Her klasörde tam `diyalog_01_20.json`, `es_kapi_dusunceleri.json`, `koylu_muhabbet_karaca_usta.ds`, `koylu_muhabbet_es.ds`, `metinler_parca.csv` ve `UYGULA.md` eksiksiz oluşturuldu.
    - Commit `KARAR-01:...` hazırlandı.
  - [ ] **Parti A2 — Karar 2 (Molla Şükrü vs Hasan Çelebi Meclis Yüzleşmesi):**
    - `docs/karar_yamalari/karar_2_aleni_mahkeme/` (Seçenek 2.1)
    - `docs/karar_yamalari/karar_2_katip_ittifak/` (Seçenek 2.2)
    - Her klasörde tam diyalog, eş düşünceleri, Hasan Çelebi & Meclis sohbeti, `metinler_parca.csv` ve `UYGULA.md`.
    - Commit `KARAR-02:...` ve push.
  - [ ] **Parti A3 — Karar 3 (Vebalı Sabi ve Anasının Akıbeti):**
    - `docs/karar_yamalari/karar_3_sifa_kurtulus/` (Seçenek 3.1)
    - `docs/karar_yamalari/karar_3_dramatik_kayip/` (Seçenek 3.2)
    - Her klasörde tam diyalog, eş düşünceleri, Miraen & Karantina sohbeti, `metinler_parca.csv` ve `UYGULA.md`.
    - Commit `KARAR-03:...` ve push.
- [ ] **Bölüm B — Diyalog ve Anlatıyla İlgili Eksik 2D Asset Promptları:**
  - `docs/EKSIK_ASSET_ENVANTERI.md` incelenecek.
  - Yeni 10 ziyaretçi, muhafızın eşi, 8 köy olayı, hafıza defteri ve epilog/sonlar için 2D portre, kart ve sahne promptları tek tek Nano Banana formatında hazırlanacak.
  - Commit `ASSET-PROMPT-01:...` ve push.
- [ ] **Bölüm C — Bitirme & Doğrulama:**
  - Tüm doğrulayıcılar ve testlerin koşulması.
  - `docs/DIYALOG_GECE_OZETI.md` güncellenmesi.
  - `codex.md/Antigravity.md` günlüğünün güncellenmesi.
  - Dosyanın sonuna `GOREV13_TAMAM` yazılması ve son push.
