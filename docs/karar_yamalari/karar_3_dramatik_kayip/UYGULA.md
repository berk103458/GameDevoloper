# Yama Uygulama Rehberi — Karar 3 / Seçenek 3.2 (Dondurucu Ayazda Dramatik Kayıp)

## Seçenek Özeti
- **Karar:** Vebalı Sabi ve Anasının Akıbeti
- **Seçim:** 3.2 Dondurucu Ayazda Dramatik Kayıp (Karanlık Gerçekçilik ve Ağıt)
- **Anlatı:** Miraen'in tüm çabalarına ve kireç ocağında yakılan ateşe rağmen, kış ayazının acımasızlığında sabinin zayıf ciğerleri hummaya yenik düşer. Sabi sabaha karşı can verir, ana aklını yitirme raddesine gelir. Köye salgın yayılmaz ancak köy ağır bir matem ve vicdan muhasebesine bürünür.

## Kopyalanacak Dosyalar
Aşağıdaki dosyaları bu klasörden oyunun ana dizinlerine kopyalayınız:
1. `diyalog_01_20.json` -> `data/diyalog/diyalog_01_20.json`
2. `es_kapi_dusunceleri.json` -> `data/diyalog/es_kapi_dusunceleri.json`
3. `koylu_muhabbet_miraen.ds` -> `data/parley/koy/koylu_muhabbet_miraen.ds`
4. `koylu_muhabbet_es.ds` -> `data/parley/koy/koylu_muhabbet_es.ds`
5. `metinler_parca.csv` satırlarını `data/metin/metinler.csv` dosyasına ekleyiniz.

## Etkinleşen Bayraklar ve Oyun Değişkenleri
- `sabi_vefati_kis_matemi`: true
- `vebali_ana_akil_yitirdi`: true
- `muhafiz_agir_vicdan_yuku`: true
- `koyde_salgin_yok`: true
- `moral`: -3
- `adalet`: +1 (muhafızın köyü koruma kararı haklı bulunur amma bedeli ağırdır)
- `asayis_riski`: 0 (salgın yok)
- `es_sohbeti`: 'Kış Ağıtı ve Kader' dertleşme dalı açılır

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
