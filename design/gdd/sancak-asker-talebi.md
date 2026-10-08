# Sancak asker toplama fermanı — HAR-04

## Overview
Yeni SancakAskerTalebi helper mevcut Oturum gece, OlayVerisi seçenek ve kayıt API'lerine ince çağrılarla bağlanır. Aynı KoyEkrani olay kartı kullanılır; ikinci olay HUD veya köylü/asker sistemi yoktur.

## Player Fantasy
Muhafız Sancak Beyinin levent isteğini yerine getirirken köyün iş gücünü kaybetmekle mevcut açık iş reddi adaylarını göndermek arasında karar verir.

## Detailed Rules
Dış JSON denge varsayımı: ilk tamamlanan8. gece, sonraki her12 gece,2 levent. Bekleyen ferman cevaplanana kadar korunur; taşkın/suçüstü/pusula mevcut önceliği değiştirilmez. Gönderilen kişiler köyden kalıcı ayrılır, mevcut üretim ve savunma kişi sayısını yeniden okur. Ret köylüleri korur ve asayiş riskini5 artırır. Adlı CHR hikâye kişileri korunur. Suç, söylenti veya gizli casus bayrağı isyancı etiketi yaratmaz; mevcut IsMemnuniyeti.isyanci açık iş reddi durumudur.

## Formulas
Vade: no>=ilk_gece ve (no−ilk_gece) mod aralik_gece=0. no=r.gun+1 gerçek tamamlanan gecedir. Seçilebilir yetişkin sağlık>=50, CirakEgitimi.saglam; çocuk, tutuklu, dış kervan görevi ve uyuklayan hariç. ID sıralı adaylardan ilk2 seçilir; kalan köy nüfusu en az1 olmalı. İş gücü/isyancı listeleri aynı canlı durumdan türetilir. Ret asayiş=min(100,asayiş+ret_asayis).

## Edge Cases
Eksik aday, geçersiz/foreign/eski kart, terminal veya çift tıklama hiçbir şeyi değiştirmez. Seçimden hemen önce tüm adaylar tekrar kontrol edilir. Gönderilenlerin ev/iş slotları kişi listesinden türetildiği için hayalet işçi kalmaz; adlı hikâye/kadroya ikinci durum eklenmez. Pending kart ve seçilmiş ID makbuzu optional JSON alanından yüklenir; eski kayıtta boş. Her gece tekrarı tek makbuzla engellenir. Kişisel kese, kamu parası, stok ve RNG seçimin dışında değişmez; suç hükmü veya divan kanıtı üretilmez.

## Dependencies
SancakAskerTalebi, data/sancak_asker_talebi.json. Oturum'a optional makbuz + save/load normalizer + gece/olay/seçenek helper çağrıları. Aynı OlayVerisi ve KoyEkrani; KoyYonetimi/koy_halk_hareketi/CSV/CHR kaynakları değişmez. KAYIT_SURUMU3 korunur. Gece sonunda terminal varsa yeni talep yoktur.

## Tuning Knobs
ilk_gece,aralik_gece,levent,koyde_kalan_min,saglik_min,ret_asayis ve insan metinleri dış JSON'dadır. Kaynakta tarih/adet belirtilmediği için8/12/2 varsayımdır. Asset gerekmedi; envanter G kontrol edildi, mevcut yazılı olay kartı kullanılır. Asset üretimi veya indirme yapılmaz.

## Acceptance Criteria
7/8/19/20/32 gece; iş gücü/gerçek iş reddi/çocuk/hasta/zindan/adlı/dış görev aday ayrımı; atomik ret, nüfus köprüsü, tek seçim, terminal, bozuk optional JSON ve saf okuma. Gerçek Oturum gecesi, yüklenen pending ferman, aynı UI düğmeleri/sonuç ve mevcut devam_istendi sinyali; headless/native görüntü/ayna ve köy/kayıt/kapı/teftiş regresyonu.
