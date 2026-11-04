# SOY-SON-01: Uygulama Kılavuzu (Ahmet Onayladığında)

## Adım Adım Entegrasyon
1. `taslak_soylenti_kapanislari.md` içindeki 5 olay `data/olaylar/` klasörüne `olay_soylenti_degirmen.json` vb. formatında yazılır.
2. `src/sistemler/soylenti_agi.gd` sınıfında söylenti ömrü 2 günü aştığında ilgili olayı tetikleyecek tek satırlık olay çağrısı eklenir.
3. Test çalıştırma:
   ```bash
   C:\Users\Ahmet\Desktop\Godot.exe --headless --path . -s tests/unit/kvr/soylenti_agi_test.gd
   ```
4. Sıfır hatayla doğrulandıktan sonra `ROADMAP_2.md` üzerinde `SOY-SON-01 [x]` olarak işaretlenir.
