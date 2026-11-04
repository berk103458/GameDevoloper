# Yama Uygulama Rehberi — Karar 1 / Seçenek 1.1 (İttifak ve Süvari Muhafızları)

## Seçenek Özeti
- **Karar:** Banu Hatun'un Dağdaki 50 Atlısı
- **Seçim:** 1.1 Müttefik Süvari Muhafızları (İttifak ve Savunma)
- **Anlatı:** Muhafız ve Çınar Meclisi, Banu Hatun ile anlaşır. 50 atlı vadi girişindeki korulukta ordugâh kurar ve köy sınırlarını koruyan uç süvarisi olur. Karaca Usta babasının kan borcunu pusatları bileyerek öder.

## Kopyalanacak Dosyalar
Aşağıdaki dosyaları bu klasörden oyunun ana dizinlerine kopyalayınız:
1. `diyalog_01_20.json` -> `data/diyalog/diyalog_01_20.json`
2. `es_kapi_dusunceleri.json` -> `data/diyalog/es_kapi_dusunceleri.json`
3. `koylu_muhabbet_karaca_usta.ds` -> `data/parley/koy/koylu_muhabbet_karaca_usta.ds`
4. `koylu_muhabbet_es.ds` -> `data/parley/koy/koylu_muhabbet_es.ds`
5. `metinler_parca.csv` satırlarını `data/metin/metinler.csv` dosyasına ekleyiniz.

## Etkinleşen Bayraklar ve Oyun Değişkenleri
- `banu_ittifak_kabul`: true
- `suvari_50_orudgah_kuruldu`: true
- `ambar_suvari_payi_aktif`: true
- `koy_savunma_bonusu`: 50
- `asayis_riski`: -3
- `moral`: +1
- `gunluk_erzak_tuketimi`: +3 erzak, +2 arpa

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
