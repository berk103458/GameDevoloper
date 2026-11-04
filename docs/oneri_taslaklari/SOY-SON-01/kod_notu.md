# SOY-SON-01: Kod ve Sistem Notu

## Kod Gerekir mi?
- **HAYIR.**
- Mevcut `src/sistemler/soylenti_agi.gd` sınıfı zaten dedikodu ekleme/silme ve gün sayacı takip fonksiyonlarına sahiptir.
- Kapanış sahneleri mevcut köy olayları havuzuna (`data/olaylar/olay_harman_kavga.json` vb.) standart olay formatında eklenir.
- Tetikleme koşulu: `Oturum.bayrak_al("soylenti_degirmen_un_caliyor") >= 2`.
- **Kimin İşi?:** Kod değişikliği gerekmez. Veri ve olay dosyası Antigravity tarafından eklenir.
