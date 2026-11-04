# ANL-EPI-01: Kod ve Sistem Notu

## Kod Gerekir mi?
- **EVET (Basit Sonuç Kart Gösterim Adaptörü).**
- Oyun sonu ekranında (`src/arayuz/perde_ozeti.gd` veya `sonuc_ekrani.gd`) genel özetin ardından sırayla 4-6 epilog kartını ekrana getiren 30 satırlık bir adaptör gerekir:
  `src/sistemler/epilog_olusturucu.gd`.
- Sınıf bayrakları okur, ilgili metinleri seçer ve kart dizisi olarak arayüze sunar.
- **Kimin İşi?:** Kod tarafı Cursor (arayüz). Metinler ve şablonlar Antigravity.
