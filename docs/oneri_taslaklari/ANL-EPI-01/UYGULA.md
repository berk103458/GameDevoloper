# ANL-EPI-01: Uygulama Kılavuzu (Ahmet Onayladığında)

## Adım Adım Entegrasyon
1. `taslak_epilog_kartlari.md` metinleri `data/metin/metinler.csv` içine `epilog.*` anahtarlarıyla eklenir.
2. `src/sistemler/epilog_olusturucu.gd` oluşturulur ve `Oturum` bayraklarına bağlanır.
3. Oyun sonu perdesinde oyuncu 'İleri' butonuna bastıkça bu kartlar gösterilir.
4. Test çalıştırma:
   ```bash
   C:\Users\Ahmet\Desktop\Godot.exe --headless --path . -s tests/unit/diyalog/diyalog_butunluk_test.gd
   ```
5. Sıfır hatayla doğrulandıktan sonra `ROADMAP_2.md` üzerinde `ANL-EPI-01 [x]` olarak mühürlenir.
