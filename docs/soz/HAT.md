# Söz hattı

Oyuna kopya, bu sıradan önce alınmaz. Araç `tools/soz_kapi.py`. İkinci kapı yoktur.

1. YAZ-01 kitap
2. taslak
3. YAZ-10 yapaylık
4. DYL-11 kör okuma
5. YAZ-09 kota
6. insan onayı: anlatı yönetmeni ve Ahmet
7. YAZ-04 `data/soz/`

## Adım kutusu

Tek kutu bu dosyadır. Geçen adım paketin `adimlar` listesinde durur. Kutusuz paket kopyalanmaz.

| Adım | Durum |
| --- | --- |
| kitap | bekler |
| taslak | bekler |
| yapaylik | bekler |
| kor_okuma | bekler |
| kota | bekler |
| onay | bekler |
| kopya | bekler |

Sebepsiz atlama reddedilir. Atlama satırında `sebep` boşsa kopya yoktur.

Hata kopyayı keser. Uyarı kesmez.

KLT-19 kapsamında K6 ses turu açılmaz. Kör okumadaki ağız karşılaştırması metin üzerinden yapılır. Ses dosyası veya seslendirme bu yazım denetiminin girdisi değildir.

## Tester turunda diyalog kabulü

Tur raporunda diyalog kutusunu yalnız `python -B tools/soz_kapi.py --paket <paket>` çıkış kodu 0 ise işaretle. Yazım kapısı hata verirse rapora hata sayısını ve paket yolunu yaz. Oyun testleri geçmiş olsa bile diyalog kutusu açık kalır.

- [x] Oyun testleri geçti.
- [ ] Diyalog geçti. Yazım kapısı çıkış 1, yasak kalıp.

Kapı Godot başlatmaz, `user://` yazmaz, `data/soz` dosyası silmez. Red listesi ayrı `red/` klasörüne yazılır.
