# Antigravity İlerleme Dosyası — Görev 11

- **Ajan Adı:** Antigravity
- **Görev:** Görev 11 — İngilizce taslağı tamamla, oyun dosyalarına dokunmadan
- **Çalışma Dalı:** `feature/diyalog-yeniden-yazim`
- **Başlangıç Zamanı:** 4 Kasım 2026 05:25
- **İlke:** AGENTS.md kurallarına tam uyum; Kalfa ve Cursor alanındaki kodlara dokunulmaz; oyunun çalışan dosyalarına, testlere ve `metinler.csv`'ye dokunulmaz (yalnızca `docs/` altına yazılır); yalnızca `feature/diyalog-yeniden-yazim` dalına commit ve push atılır; parti parti çalışılır ve her parti sonrasında bu dosya güncellenir.
- **Kota:** %40 kaldı

---

## Genel Durum ve Plan
- [/] **Bölüm A — metinler.csv'nin Kalanı:** `docs/INGILIZCE_METIN_TASLAGI.csv`'de henüz bulunmayan 1895 anahtarın dönem İngilizcesine uygun olarak eklenmesi.
  - [x] Parti A1: Öğretici, ipuçları, hafıza, defter, nöbet, sabah hükmü, anlatı, bar, bitki, eşya, heybe, karakter, kayıt, tez, yıl, açılış (162 anahtar eklendi)
  - [x] Parti A2: Olay metinleri (`olay.*`, 364 anahtar eklendi)
  - [ ] Parti A3: Köy metinleri (`koy.*`, 277 anahtar)
  - [ ] Parti A4: Şablon metinleri (`sablon.*`, 102 anahtar)
  - [ ] Parti A5: Sohbet metinleri (`sohbet.*`, 999 anahtar)
- [ ] **Bölüm B — Diyaloglar:** `docs/ingilizce_diyalog/` klasörü altına oyunun orijinal JSON ve Parley dosyalarının yapısı birebir korunarak İngilizce çevirilerinin hazırlanması.
  - [ ] Parti B1: 30 Ziyaretçi Diyaloğu (`diyalog_01_20.json` - diyalog_01 ila diyalog_30)
  - [ ] Parti B2: Eş Kapı Düşünceleri (`es_kapi_dusunceleri.json` - 30 ziyaretçi + genel)
  - [ ] Parti B3: Köylü ve Eş Parley Sohbetleri (`koylu_muhabbet_*.ds` ve sekanslar)
  - [ ] Parti B4: Akşam Konuları (`aksam_konulari.json`)
- [ ] **Bölüm C — Ton Kontrolü ve Terim Sözlüğü:**
  - [ ] Terim tutarlılığı, dönem üslubu ve isim muhafazası kontrolü
  - [ ] `docs/INGILIZCE_TERIM_SOZLUGU.md` dosyasının yazılması
  - [ ] `docs/DIYALOG_GECE_OZETI.md` dosyasının Görev 11 ile güncellenmesi
- [ ] **Bitirme:** Doğrulayıcılar ve test kontrolü, `GOREV11_TAMAM`.
