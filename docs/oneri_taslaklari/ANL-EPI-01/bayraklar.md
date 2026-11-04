# ANL-EPI-01: Epilog Bayrakları ve Seçim Koşulları

## 1. Epilog Seçim Haritası
- `epilog_turna_dursun`:
  - Koşul A: `dursun_kabul && turna_kabul`
  - Koşul B: `!dursun_kabul || !turna_kabul`
- `epilog_lokman`:
  - Koşul A: `lokman_kovuldu || lokman_zindan`
  - Koşul B: `lokman_kabul && meclis_sifahane_kuruldu`
- `epilog_banu`:
  - Koşul A: `banu_ittifak_kabul || banu_ittifak_pekisti`
  - Koşul B: `banu_ret`
- `epilog_sungur`:
  - Koşul A: `divan_teftis_ihbari || sungur_rusvet_un`
  - Koşul B: `sungur_dusman_oldu || sungur_ret`
- `epilog_vebali`:
  - Koşul A: `vebali_karantina_sifa || sifa_kurtulus_tamam`
  - Koşul B: `vebali_ret`
- `epilog_hane`:
  - Koşul A: `es_guven >= 3 && es_baglilik_derin`
  - Koşul B: `es_guven < 1`
