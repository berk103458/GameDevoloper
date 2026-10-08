# Rüşvet → oda kasası sözleşmesi — ODA-11

## Overview
ODA-11, bitmiş EKO-01/EKO-11 ve ODA-02 akışının doğrulamasıdır. Oda 3B sahnesi para yazmaz; Oturum tek cüzdan sahibidir. İkinci kasa/saklama alanı yaratılmaz.

## Player Fantasy
Kapıda kabul edilen kişisel teklif, odadaki gizli zemin kasasında görünür; köy bütçesi ayrı kalır.

## Detailed Rules
src/sistemler/oturum.gd: karar_ver rusvet dalı cift_kasa_dagitimi.gd.kisisel_rusvet sonucunu MuhafizYetenekleri.rusvet üzerinden aynı muhafiz_akce ve muhafiz_esyalari alanlarına bir kere işler. CHR kişisel sonucu kaynak kararından; klasik heybe yalnız seçilmiş gerçek para/eşyadan gelir. Kamuya ikinci ödeme yapılmaz. Harç/el koyma eski kamu yoludur.

## Formulas
Tek kişisel bakiye += dağıtımın akce değeri. Mevcut Göz Yumma bonusu aynı yerde bir kere uygulanır; oda ikinci bonus/ödeme yapmaz. Eşyalar dağıtım kayıtlarıdır, ek satış bedeli uydurulmaz. Kamu akce aliası aynen kamu bakiyesidir.

## Edge Cases
Kapak açma/kapama yalnız görünürlük/transform değiştirir; para tüketmez, kamu ambarına eşya aktarmaz, gizlilik suç makbuzunu silmez. Tek oda modalı/hız/kamera dönüşü korunur. JSON aynı kişisel alanlara döner; oda ayrı save slotu yaratmaz.

## Dependencies
src/arayuz/oda_kasasi_paneli.gd.kur aynı KeseGostergesi.guncelle(Oturum) kullanır. src/dunya/muhafiz_odasi.gd yalnız BoxMesh dekorudur; ROADMAP taslak hedef yolu muhasebe sahibi diye uygulanmaz. Mevcut EKO/ODA API'leri değişmedi; CSV/CHR ve core dosyalarına yeni satır gerekmedi.

## Tuning Knobs
Rüşvet miktarı mevcut CHR/Heybe ve data/muhafiz_yetenekleri.json kaynağıdır. Yeni miktar/sayı konmadı. Asset gerekmedi; envanter G kontrol edildi, ODA-02 kasa kutusu tek görsel yolu kalır.

## Acceptance Criteria
cift_kasa_test gerçek klasik para3/eşya2, kamu/ambar unchanged, JSON; oda_kasasi_kontrol gerçek CHR4 + klasik3 = tek7 akçe/eşya2, tekrar/boş kasa/modal/kayıt. muhafiz_yetenekleri_test tek bonus ve kasa ayrımı. kese_gostergesi_kontrol ortak gösterge; kaynak/korumalı API denetimi. Bu örtüşme ayrı ekonomi yazmadan kapanır.
