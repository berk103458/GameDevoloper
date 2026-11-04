# ANL-DON-01: Bayraklar ve Tetikleme Koşulları

## 1. İlk Ziyaret Karar Bayrakları (Girdi Koşulları)
- `sungur_ret` / `sungur_rusvet_un`
- `dursun_kabul` ve `turna_kabul`
- `lokman_kabul`
- `banu_ittifak_kabul`
- `behram_kabul`

## 2. İkinci Karşılaşma Bayrakları (Çıktı Sonuçları)
- `sungur_ikinci_arama_yapildi` (bool)
- `sungur_dusman_oldu` (bool)
- `divan_teftis_ihbari` (bool)
- `dursun_turna_mutlu` (bool)
- `lokman_kovuldu` (bool)
- `banu_ittifak_pekisti` (bool)
- `behram_vefa_gosterdi` (bool)

## 3. Gün Eşiği Kuralları
- Karakterin ilk gelişinden en az 4-7 gece sonra tetiklenir (`en_erken_gece = ilk_gece + 5`).
