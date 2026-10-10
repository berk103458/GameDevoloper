# Beş nihai son + epilog matrisi — SYS-20

## Overview
Mevcut "zafer" sonu (SYS-19 ile 2. perdenin 12 gecesi ya da 3 Tekfur baskınının savuşturulması) köyün gidişatına göre beş nihai sondan birine ayrılır. Bütün sonlara 5 gösterge + yozlaşma epilog matrisi eklenir. Kayıp sonları (isyan, Tekfur, halk kırıldı, azil, idam) kendi başlık/metnini korur. Ana son ekranında tek satırlık adaptör (`src/sistemler/nihai_son.gd`); ikinci son ekranı yok.

## Detailed Rules — öncelik sırası (yalnız zafer)
1. **Tekfur Haraççısı:** muhafız yozlaşması ≥ 60, ya da Ağalıkta hiç haraç reddedilmeden/baskın savuşturulmadan en az bir haraç aralığı geçirildi.
2. **Ertuğrul Obası:** oba ittifakı kuruldu (`ObaIttifaki.muttefik`).
3. **Beyin Uç Köyü:** sancak fermanına levent gönderildi, ya da Güvenlik ≥ 70 ve en az 3 etkin nöbetçi.
4. **Ahi Kasabası:** Refah ≥ 60 ve Adalet ≥ 50.
5. **Uç Tutundu:** varsayılan.

## Epilog matrisi
Huzur, Adalet, Refah, Güvenlik, Nüfus (agalik nüfusunun 1,5 katına göre 0–100) ve Yozlaşma; her biri değer + yüksek (≥65) / orta / düşük (≤35) kademe cümlesi. Mevcut ODA-10 muhafız kaderi epilogu ayrıca sürer. Metinler `data/nihai_sonlar.json` (metinler.csv değişmedi).

## Acceptance Criteria
Birim: `tests/unit/kvr/nihai_son_test.gd` (5 son, öncelik, epilog, kayıp sonu korunur); akış: `tests/oto/nihai_son_kontrol.gd` (gerçek 2. perde zaferi → Ana son ekranı).
