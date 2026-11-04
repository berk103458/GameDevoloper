# Yama Uygulama Rehberi — Karar 3 / Seçenek 3.1 (Kireç Ocağında Şifa ve Sabinin Kurtuluşu)

## Seçenek Özeti
- **Karar:** Vebalı Sabi ve Anasının Akıbeti
- **Seçim:** 3.1 Kireç Ocağında Şifa ve Sabinin Kurtuluşu (Umut ve Bedel)
- **Anlatı:** Miraen dağ kekiği, kükürt dumanı ve sirke ile hazırladığı panzehirle sabiyi kireç ocağında günlerce tedavi eder. Çocuğun ateşi düşer, anne ve sabi vebadan arınarak sağ salim ayağa kalkar. Köye salgın bulaşmaz, muazzam bir sevinç ve hekime saygı oluşur.

## Kopyalanacak Dosyalar
Aşağıdaki dosyaları bu klasörden oyunun ana dizinlerine kopyalayınız:
1. `diyalog_01_20.json` -> `data/diyalog/diyalog_01_20.json`
2. `es_kapi_dusunceleri.json` -> `data/diyalog/es_kapi_dusunceleri.json`
3. `koylu_muhabbet_miraen.ds` -> `data/parley/koy/koylu_muhabbet_miraen.ds`
4. `koylu_muhabbet_es.ds` -> `data/parley/koy/koylu_muhabbet_es.ds`
5. `metinler_parca.csv` satırlarını `data/metin/metinler.csv` dosyasına ekleyiniz.

## Etkinleşen Bayraklar ve Oyun Değişkenleri
- `veba_kirec_karantina_basarili`: true
- `sabi_iyilesti_kurtuldu`: true
- `miraen_tabip_saygi_zirve`: true
- `koyde_salgin_yok`: true
- `moral`: +3
- `adalet`: +2
- `akce`: -10 (ecza masrafı)
- `asayis_riski`: 0 (salgın yok)
- `nufus`: +2 sağlıklı köylü

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
