# ES-GECM-01: Gereken Bayraklar ve Tetikleme Koşulları

## 1. Yeni Bayraklar
- `es_gecmis_yangin_bilindi` (bool): Eşin eski köy yangını ve göç anısı dinlendi.
- `es_yetim_analik_istegi` (bool): Eşin Turna ve Dursun'a kol kanat germe kararı.
- `es_sabir_pekisti` (bool): Eşin çocuksuzluk hüznüne sabır gösterme tutumu.
- `es_sifa_ihlamur_verildi` (bool): Eşin gece Muhafız'a kaynattığı ıhlamur/bal şifası.
- `es_baglilik_derin` (bool): Üç geçmiş konuşması da tamamlandığında açılan özel güven bağı.

## 2. Tetikleme Koşulları
- **Dal 1 (Yangın):** `gun >= 3` ve `es_guven >= 1`.
- **Dal 2 (Yetimler):** `ziyaretci_kabul_dursun == true` VEYA `ziyaretci_kabul_turna == true` VEYA `gun >= 6`.
- **Dal 3 (Şifa):** `hava_durumu == "kar" || hava_durumu == "firtina"` VEYA `nobet_yorgunlugu >= 2`.

## 3. Köy Barları ve Karakter Etkileri
- `es_yetim_analik_istegi`: Köy Morali +2, Eş İlişkisi +2.
- `es_sifa_ihlamur_verildi`: Nöbet Yorgunluğu -1, Muhafız Dirayeti +1.
