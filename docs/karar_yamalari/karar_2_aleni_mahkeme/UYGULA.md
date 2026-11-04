# Yama Uygulama Rehberi — Karar 2 / Seçenek 2.1 (Çınar Meclisi'nde Aleni Mahkeme)

## Seçenek Özeti
- **Karar:** Molla Şükrü vs Hasan Çelebi Meclis Yüzleşmesi
- **Seçim:** 2.1 Çınar Meclisi'nde Aleni Mahkeme (Hak ve Adalet)
- **Anlatı:** Muhafız, Molla Şükrü'yü Çınar Meclisi'nin ve köy ahalisinin önüne çıkarır. Hasan Çelebi sahte mührü ve bezir yağı kokan tahrifatı kanıtlar. Sahte berat yakılır; Şükrü kellesi bağışlanarak Karaca Usta'nın demirhanesinde körük çekme cezasına çarptırılır.

## Kopyalanacak Dosyalar
Aşağıdaki dosyaları bu klasörden oyunun ana dizinlerine kopyalayınız:
1. `diyalog_01_20.json` -> `data/diyalog/diyalog_01_20.json`
2. `es_kapi_dusunceleri.json` -> `data/diyalog/es_kapi_dusunceleri.json`
3. `koylu_muhabbet_hasan_celebi.ds` -> `data/parley/koy/koylu_muhabbet_hasan_celebi.ds`
4. `koylu_muhabbet_es.ds` -> `data/parley/koy/koylu_muhabbet_es.ds`
5. `metinler_parca.csv` satırlarını `data/metin/metinler.csv` dosyasına ekleyiniz.

## Etkinleşen Bayraklar ve Oyun Değişkenleri
- `meclis_sukru_mahkeme_edildi`: true
- `sukru_sahte_muhur_kanitlandi`: true
- `sukru_cezali_demirhane`: true
- `hasan_celebi_itibar_zirve`: true
- `adalet`: +3
- `moral`: +2
- `asayis_riski`: -2
- `demirhane_uretimi`: günlük +1 alet

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
