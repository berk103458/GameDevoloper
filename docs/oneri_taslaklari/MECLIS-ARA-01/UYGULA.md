# MECLIS-ARA-01: Uygulama Kılavuzu (Ahmet Onayladığında)

## Adım Adım Entegrasyon
1. `taslak_meclis_davalari.md` içeriği `data/parley/koy/meclis_davalari.ds` olarak derlenir.
2. Köy meydanındaki Çınaraltı etkileşim alanına haftalık tetikleyici (ör. Her 7 günde bir) bağlanır.
3. Test çalıştırma:
   ```bash
   C:\Users\Ahmet\Desktop\Godot.exe --headless --path . -s tests/unit/koy/cinar_meclisi_genisletme_test.gd
   ```
4. Sıfır hatayla doğrulandıktan sonra `ROADMAP_2.md` üzerinde `MECLIS-ARA-01 [x]` olarak mühürlenir.
