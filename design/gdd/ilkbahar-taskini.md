# İlkbahar taşkını — MEV-06

## Overview
Kar erimesi, kırık bent ve kirli kuyu durumu yeni helper ile mevcut gece sağlık ve olay kartı akışına eklenir. Yeni bina türü veya ikinci olay kuyruğu yoktur.

## Player Fantasy
Oyuncu bahar öncesi taş/kireç depolar, bendi onarıp köy suyunu temizler.

## Detailed Rules
Başlangıç ilkbaharında olay yoktur. İkinci ve sonraki yılların ilk gerçek bahar gecesinde nüfus varsa kar erimesi köyün mevcut su bendini kırar. Bent kırıkken kirli su gecede kişi başına 3 sağlık kaybı yapar; iyileşme/ölüm mevcut sağlık fazındadır. Mevcut gece olay kartı onarım veya erteleme sunar. Onarım ortak ambardan 4 taş+2 kireç atomik harcar; suyu temizler. Erteleme moral -2, kaynak harcamaz ve sonraki gecede onarım tekrar sunulur. Onarım öncelikli olduğu sürece aynı gece ayrıca normal olay kartı açılmaz.

## Formulas
Tetik = gun>0, etkin mevsim ilkbahar, yıl günü 1 ve yıl>son taşkın yılı ve nüfus>0. Kirli su etkisi max(0,sağlık-kirli_su_saglik). Onarım Kaynaklar.harca(onarim) ile tek işlemdir.

## Edge Cases
Yalnız sorgu/olay kartı açma gün/RNG/stok ilerletmez. son_gece aynı gece etkiyi tekrar engeller. secim_gunu ve gün/yıl olay kimliği çift/eski kartı engeller. Eksik kaynak, oyun sonu ve yanlış seçim işlem yapmaz. Yeni kayıt alanı optional, bounded ve eski kayıtta temizdir. Restore aynı gece ve seçim sonucu verir. Bent global köy altyapısıdır; normal binaya hasar alanı eklenmez, sur API korunur. Her baharda bir kırılma ve hasar/bedel değerleri tasarım denge varsayımıdır.

## Dependencies
IlkbaharTaskini; KoyYonetimi gece/kayıt ince çağrıları; Oturum olay_sec/secenek_olur/olay_uygula ince adaptörleri. Aynı mevcut KoyEkrani seçim/sonuç kartı, ortak ambar, sağlık fazı, kayıt ve takvim kullanılır. CSV/CHR değiştirilmedi.

## Tuning Knobs
Data/ilkbahar_taskini.json onarim, kirli_su_saglik, ertele_moral. UI bedel metinleri aynı veriden türetilir. Asset gerekmedi; envanter G kontrol edildi, mevcut kuyu ve olay kartı yeterlidir; üretim/indirme yok.

## Acceptance Criteria
İlk yıl yok; ikinci yıl gerçek bahar, gece idempotansı, kaynak yetersizliği/atomik harcama, sağlık kaybının durması, erteleme/yeniden teklif, eski kart/çift tıklama ve restore eşitliği test edilir. Gerçek olay kartında disabled→enabled onarım ve Türkçe sonuç gösterilir. Sağlık/kayıt/iklim/20 gece regresyonları geçer.
