# Antigravity İlerleme Dosyası — Görev 10

- **Ajan Adı:** Antigravity
- **Görev:** Görev 10 — Açık kararlar için hazır seçenekler, yeni madde önerileri, İngilizce metin taslağı
- **Çalışma Dalı:** `feature/diyalog-yeniden-yazim`
- **Başlangıç Zamanı:** 4 Kasım 2026 05:05
- **İlke:** AGENTS.md kurallarına tam uyum; Kalfa ve Cursor alanındaki kodlara dokunulmaz; yalnızca `feature/diyalog-yeniden-yazim` dalına commit ve push atılır; parti parti çalışılır ve her parti sonrasında bu dosya güncellenir.
- **Kota:** %40 kaldı

---

## Genel Durum ve Plan
- [x] **Bölüm A — 3 Açık Karar İçin İki Hazır Seçenek:** `docs/KARAR_SECENEKLERI.md` dosyası oluşturuldu. 3 açık karar (Banu Hatun 50 atlısı, Molla Şükrü meclis yüzleşmesi, Vebalı sabi) için tam diyaloglar, bayraklar, eş yorumları, köy sonuçları ve oyuncuya etki notlarıyla hazırlandı.
- [ ] **Bölüm B — Yeni ROADMAP Madde Önerileri:** Anlatı ve diyalog sisteminde eksik kalan noktalar tespit edilip `docs/ROADMAP_ONERILERI_ANTIGRAVITY.md` dosyasına yapılandırılmış öneriler olarak yazılacak.
- [ ] **Bölüm C — İngilizce Metin Taslağı İncelemesi:** Dil altyapısı, `metinler.csv`, `dil_test.gd` ve `DilAyari` mimarisi incelenecek; kurala göre sistem destekliyorsa uygulanacak, desteklemiyorsa gerekçesiyle soru/not düşülüp atlanacak.
- [ ] **Bitirme:** Doğrulayıcılar ve testler koşturulacak, `docs/DIYALOG_GECE_OZETI.md` güncellenecek ve `GOREV10_TAMAM` ile mühürlenecek.

---

## Bölüm A — 3 Açık Karar İçin İki Hazır Seçenek (TAMAMLANDI)
- `docs/KARAR_SECENEKLERI.md` dosyası yazıldı.
- 3 karar için ikişer hazır seçenek eksiksiz olarak kurgulandı:
  1. **Banu Hatun'un 50 Atlısı:**
     - Seçenek 1.1: Müttefik Süvari Muhafızları (+50 Savunma Gücü, -3 Günlük Erzak, -3 Asayiş Riski) — *(Önerilen)*
     - Seçenek 1.2: Yalnız Savaşçı ve Atlıların Men Edilmesi (Erzak korunur, +1 Asayiş Riski, +2 Adalet)
  2. **Molla Şükrü vs Hasan Çelebi Meclis Yüzleşmesi:**
     - Seçenek 2.1: Çınar Meclisi'nde Aleni Mahkeme (+3 Adalet, +2 Moral, demirhanede ceza) — *(Önerilen)*
     - Seçenek 2.2: Perde Arkası Kâtip İttifakı (+15 Günlük Akçe, -3 Adalet, Hasan Çelebi küser)
  3. **Vebalı Sabi ve Anasının Akıbeti:**
     - Seçenek 3.1: Kireç Ocağında Şifa ve Sabinin Kurtuluşu (+3 Moral, +2 Adalet, -10 Akçe, 0 Salgın) — *(Önerilen)*
     - Seçenek 3.2: Dondurucu Ayazda Dramatik Kayıp (-3 Moral, 0 Salgın, eşle kış matemi sohbeti)
- Karşılaştırmalı özet tablosu eklendi; mevcut kod akışına doğrudan dokunulmadan Ahmet'in kararına sunuldu.
- **Kota:** %40 kaldı.
