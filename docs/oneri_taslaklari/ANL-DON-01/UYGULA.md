# ANL-DON-01: Uygulama Kılavuzu (Ahmet Onayladığında)

## Adım Adım Entegrasyon
1. `taslak_donus_diyaloglari.md` içindeki 6 diyalog, `data/diyalog/` klasörüne `diyalog_donusler.json` olarak eklenir.
2. `chr_023` (Sungur), `chr_025` (Dursun), `chr_026` (Lokman), `chr_028` (Banu) için `donus_kurali` ve `en_erken_gece` değerleri ayarlanır.
3. Test çalıştırma:
   ```bash
   C:\Users\Ahmet\Desktop\Godot.exe --headless --path . -s tests/unit/diyalog/diyalog_butunluk_test.gd
   ```
4. Sıfır hatayla doğrulandıktan sonra `ROADMAP_2.md` üzerinde `ANL-DON-01 [x]` olarak mühürlenir.
