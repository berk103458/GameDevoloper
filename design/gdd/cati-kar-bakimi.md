# Çatı kar bakımı — MEV-05

## Overview
Ağır kar yükü mevcut binanın optional cati_kar kaydında tutulur. Çatı bakımı ve görsel rutin yeni helper dosyalarıdır; genel bina hasarı veya ikinci simülasyon eklenmez.

## Player Fantasy
Oyuncu sağlıklı yetişkinleri boşta bırakıp çatıları kürekle temizletir; ihmal edilen ağır kar yapı kaybı riski taşır.

## Detailed Rules
Örtü en az %65 ise hazır çatılı yapıya gece +1 yük eklenir. Sağlıklı, aç olmayan, boş yetişkinler en yüklü erişilebilir çatılara sırasıyla atanır; çatı başına bir kişi, gecede 2 yük temizler. Temizlik otomatik mevcut boş iş gücünden, herhangi bir yeni meslek veya alet stok tüketimi olmadan çalışır. Yük en az 2 kalırsa %10 çökme kontrolü mevcut kayıtlı RNG ile yapılır; gecede en fazla bir yapı kaybedilir. Çökme mevcut iadesiz bina kaldırma API'sidir: bina, yatak/depo/görev/ızgara bağları temizlenir; kişi otomatik ölmez. Oyuncu mevcut yapı kurma yolundan yeniden inşa eder. Baharda yük azalır.

## Formulas
Yük = min(100,eski_yük+gecelik_yuk), temizleyici varsa max(0,yük-temizlik). Ağır kar değilse max(0,yük-temizlik). Risk = yük>=cokme_yuku ve mevcut rng.randi_range(1,100)<=cokme_yuzde; gecelik_azami=1.

## Edge Cases
Çocuk/yaşlı/hasta/aç/atanmış nöbetçi temizlik için çekilmez. Mevcut A* erişilemeyen çatıya görev vermez. Aynı son_gece tekrar yük/temizlik/RNG/olay üretmez. Eski veya bozuk optional kayıt güvenli sıfır yükle açılır. Restore aynı yük, görev ve çökme/RNG sonucu verir. Çatı çökmesini kullanılmaz yapının iadesiz kaybı olarak modellemek denge varsayımıdır; normal binalara hasar sayacı eklenmez, sur hasarı korunur.

## Dependencies
CatiKarBakimi, MevsimKarOrtusu, KoyRotasi, KoyBinasi optional alan adaptörü ve KoyYonetimi.gece tek çağrısı. koy_halk_hareketi yalnız tek CatiKarRutini.hedef çağrısı; görsel kürek mevcut KarakterEkipmanYoneticisi gerçek RightHand soketi ve aynı saklama API’sindedir, eksik kemikte sahte soket yok. KoyEkrani mevcut bina bilgi kartında tek helper çağrısıyla risk/boş yetişkin açıklaması verir.

## Tuning Knobs
Data/cati_kar_bakimi.json eşik/yük/temizlik/risk/azami/sağlık/çatı türleri; data/cati_kar_rutini.json kutu sap/ağız ve salınım. G MEV05-KUREK gerçek model/klip ihtiyacı; üretim/indirme yok, yalnız düz kutu kürek kullanıldı.

## Acceptance Criteria
Gerçek gece temizlik ve çökme, iadesiz kayıp, ev boşalması, restore/RNG eşitliği, idempotans, eski/bozuk kayıt. Gerçek köyde mevcut rota, tek kürek soketi, bina risk açıklaması, salt okunur görsel, gece fazında temizleme doğrulanır. Bina/ambar/kayıt/iklim/rota/20 gece regresyonları geçer.
