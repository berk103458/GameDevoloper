# Yama Uygulama Rehberi — Karar 2 / Seçenek 2.2 (Perde Arkası Kâtip İttifakı)

## Seçenek Özeti
- **Karar:** Molla Şükrü vs Hasan Çelebi Meclis Yüzleşmesi
- **Seçim:** 2.2 Perde Arkası Kâtip İttifakı (Pragmatik İdare ve Rüşvet)
- **Anlatı:** Muhafız Şükrü'nün sahtekârlığını yüzüne vurur ancak onu cezalandırmak yerine divan vergisini kaçırmak ve hazineyi büyütmek için gizli kâtip olarak istihdam eder. Köye ciddi akçe akar; ancak Hasan Çelebi kırılır, meclis adaleti sarsılır ve divan teftişi tehlikesi belirir.

## Kopyalanacak Dosyalar
Aşağıdaki dosyaları bu klasörden oyunun ana dizinlerine kopyalayınız:
1. `diyalog_01_20.json` -> `data/diyalog/diyalog_01_20.json`
2. `es_kapi_dusunceleri.json` -> `data/diyalog/es_kapi_dusunceleri.json`
3. `koylu_muhabbet_hasan_celebi.ds` -> `data/parley/koy/koylu_muhabbet_hasan_celebi.ds`
4. `koylu_muhabbet_es.ds` -> `data/parley/koy/koylu_muhabbet_es.ds`
5. `metinler_parca.csv` satırlarını `data/metin/metinler.csv` dosyasına ekleyiniz.

## Etkinleşen Bayraklar ve Oyun Değişkenleri
- `sukru_gizli_ittifak`: true
- `vergi_kacakciligi_aktif`: true
- `hasan_celebi_kirgin_ve_kuskun`: true
- `divan_teftis_tehlikesi`: true
- `gunluk_akce`: +15
- `adalet`: -3
- `moral`: -1
- `asayis_riski`: +2

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
