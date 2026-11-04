# Antigravity İlerleme Dosyası — Görev 11

- **Ajan Adı:** Antigravity
- **Görev:** Görev 11 — İngilizce taslağı tamamla, oyun dosyalarına dokunmadan
- **Çalışma Dalı:** `feature/diyalog-yeniden-yazim`
- **Başlangıç Zamanı:** 4 Kasım 2026 05:25
- **İlke:** AGENTS.md kurallarına tam uyum; Kalfa ve Cursor alanındaki kodlara dokunulmaz; oyunun çalışan dosyalarına, testlere ve `metinler.csv`'ye dokunulmaz (yalnızca `docs/` altına yazılır); yalnızca `feature/diyalog-yeniden-yazim` dalına commit ve push atılır; parti parti çalışılır ve her parti sonrasında bu dosya güncellenir.
- **Kota:** %40 kaldı

---

## Genel Durum ve Plan
- [x] **Bölüm A — metinler.csv'nin Kalanı:** `docs/INGILIZCE_METIN_TASLAGI.csv`'de henüz bulunmayan tüm anahtarlar (1895 anahtar) dönem İngilizcesine uygun olarak eklendi (eksik anahtar: 0).
  - [x] Parti A1: Öğretici, ipuçları, hafıza, defter, nöbet, sabah hükmü, anlatı, bar, bitki, eşya, heybe, karakter, kayıt, tez, yıl, açılış (162 anahtar eklendi)
  - [x] Parti A2: Olay metinleri (`olay.*`, 364 anahtar eklendi)
  - [x] Parti A3: Köy metinleri (`koy.*`, 277 anahtar eklendi)
  - [x] Parti A4: Şablon metinleri (`sablon.*`, 102 anahtar eklendi)
  - [x] Parti A5: Sohbet metinleri (`sohbet.*`, 996 anahtar: köylüler 276 + ziyaretçiler 720)
- [x] **Bölüm B — Diyaloglar:** `docs/ingilizce_diyalog/` klasörü altına oyunun orijinal JSON ve Parley dosyalarının yapısı birebir korunarak İngilizce çevirileri tamamlandı.
  - [x] Parti B1: 30 Ziyaretçi Diyaloğu (`docs/ingilizce_diyalog/diyalog_01_20.json`, `diyalog_01_10.json`, `diyalog_11_20.json`, `diyalog_21_30.json` - 30 ziyaretçinin sahne, açılış, soru ağacı ve yanıtları)
  - [x] Parti B2: Eş Kapı Düşünceleri (`docs/ingilizce_diyalog/es_kapi_dusunceleri.json` - 30 ziyaretçi + genel için 4-5 aşamalı eş tepkileri)
  - [x] Parti B3: Köylü ve Eş Parley Sohbetleri (`docs/ingilizce_diyalog/koy/*.ds` - 18 Parley dosyasının düğüm ve kenar yapıları korunarak text çevirileri)
  - [x] Parti B4: Akşam Konuları (`docs/ingilizce_diyalog/aksam_konulari.json` - 10 akşam konusu, eş replikleri, meslek varyantları ve yanıtlar)
- [/] **Bölüm C — Ton Kontrolü ve Terim Sözlüğü:**
  - [ ] Terim tutarlılığı, dönem üslubu ve isim muhafazası kontrolü
  - [ ] `docs/INGILIZCE_TERIM_SOZLUGU.md` dosyasının yazılması
  - [ ] `docs/DIYALOG_GECE_OZETI.md` dosyasının Görev 11 ile güncellenmesi
- [ ] **Bitirme:** Doğrulayıcılar ve test kontrolü, `GOREV11_TAMAM`.
