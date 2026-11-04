# ANL-DON-01: Kod ve Sistem Notu

## Kod Gerekir mi?
- **HAYIR / ÇOK AZ.**
- Oyunun `KarakterVerisi` sınıfı (`src/veri/karakter_verisi.gd`) zaten `donus_kurali = &"oranla_doner"` ve `en_erken_gece` alanlarına sahiptir.
- İkinci karşılaşmalar için yeni bir `.tres` dosyası (ör. `chr_023_donus.tres`, `chr_028_donus.tres`) oluşturulabilir veya mevcut ziyaretçi seçim havuzuna bayrak koşullu ikinci sıra olarak eklenebilir.
- **Kimin İşi?:** Ziyaretçi sırası ve karakter havuzu entegrasyonu Kalfa / Cursor. Diyalog ve metinler Antigravity.
