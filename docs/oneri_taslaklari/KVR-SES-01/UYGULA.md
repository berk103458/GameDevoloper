# KVR-SES-01: Uygulama Kılavuzu (Ahmet Onayladığında)

## Adım Adım Entegrasyon
1. `taslak_hava_replikleri.md` içindeki satırlar `data/metin/metinler.csv` içine `kapi.hava.*` anahtarlarıyla eklenir.
2. `src/soz/hava_replik_adaptoru.gd` adında 20 satırlık küçük bir adaptör yazılır.
3. Kapı açılışında hava kontrol edilir ve repliğin başına eklenir.
4. Test çalıştırma:
   ```bash
   C:\Users\Ahmet\Desktop\Godot.exe --headless --path . -s tests/unit/diyalog/diyalog_butunluk_test.gd
   ```
5. Sıfır hatayla doğrulandıktan sonra `ROADMAP_2.md` üzerinde `KVR-SES-01 [x]` olarak mühürlenir.
