# ES-GECM-01: Uygulama Kılavuzu (Ahmet Onayladığında)

## Adım Adım Entegrasyon
1. `taslak_diyalog_es_gecmis.md` içindeki üç anlatı dalı `data/parley/koy/koylu_muhabbet_es.ds` dosyasına yeni diyalog düğümleri olarak eklenir (kök düğümden dallanan 3 yeni soru).
2. Yeni çeviri anahtarları gerekirse `metinler.csv` içine eklenir (ör. `sohbet.es.yangin_soru`, `sohbet.es.yetim_soru`, `sohbet.es.sifa_soru`).
3. `bayraklar.md` dosyasındaki koşullar Parley kenar koşullarına (`Edge.conditions`) işlenir.
4. Test çalıştırma:
   ```bash
   C:\Users\Ahmet\Desktop\Godot.exe --headless --path . -s tests/unit/koy/koy_parley_sistemi_test.gd
   ```
5. Sıfır hatayla doğrulandıktan sonra `ROADMAP_2.md` üzerinde `ES-GECM-01 [x]` olarak mühürlenir.
