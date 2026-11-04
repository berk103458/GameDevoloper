# Yama Uygulama Rehberi — Karar 1 / Seçenek 1.2 (Yalnız Savaşçı ve Atlıların Men Edilmesi)

## Seçenek Özeti
- **Karar:** Banu Hatun'un Dağdaki 50 Atlısı
- **Seçim:** 1.2 Yalnız Savaşçı ve Atlıların Men Edilmesi (İhtiyat ve Mesafe)
- **Anlatı:** Banu Hatun tek başına köye kabul edilir ancak 50 atlının vadiye girmesi kesin olarak yasaklanır. Banu Hatun divan gözetiminde rehin/misafir kalır. Ambar erzakı korunur, yabancı ordu riski bertaraf edilir.

## Kopyalanacak Dosyalar
Aşağıdaki dosyaları bu klasörden oyunun ana dizinlerine kopyalayınız:
1. `diyalog_01_20.json` -> `data/diyalog/diyalog_01_20.json`
2. `es_kapi_dusunceleri.json` -> `data/diyalog/es_kapi_dusunceleri.json`
3. `koylu_muhabbet_karaca_usta.ds` -> `data/parley/koy/koylu_muhabbet_karaca_usta.ds`
4. `koylu_muhabbet_es.ds` -> `data/parley/koy/koylu_muhabbet_es.ds`
5. `metinler_parca.csv` satırlarını `data/metin/metinler.csv` dosyasına ekleyiniz.

## Etkinleşen Bayraklar ve Oyun Değişkenleri
- `banu_yalniz_kabul`: true
- `suvari_vadiye_sokulmadi`: true
- `suvari_dagda_kacak`: true
- `banu_koyde_rehine`: true
- `savunma_bonusu`: 0 (değişmez)
- `asayis_riski`: +1 (dağda başsız kalan süvariler kervan yolunu tehdit eder)
- `adalet`: +2
- `erzak_tuketimi`: normal (ekstra tüketim yok)

## Doğrulama ve Test Komutları
Uygulama sonrasında şu komutlarla sistemi test ediniz:
```powershell
$env:PYTHONUTF8=1
python tools/metin_dogrula.py
python tools/soz_dogrula.py
C:\Users\Ahmet\Desktop\Godot.exe --headless --path . -s tests/unit/diyalog/diyalog_butunluk_test.gd
C:\Users\Ahmet\Desktop\Godot.exe --headless --path . -s tests/unit/kapi/es_yorumu_test.gd
C:\Users\Ahmet\Desktop\Godot.exe --headless --path . -s tests/unit/diyalog/koy_parley_sistemi_test.gd
```
