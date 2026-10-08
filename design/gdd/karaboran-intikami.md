# Karaboran intikam baskını — CAS-08

## Overview
CHR_004 için gerçek divan zindan hükmünden sonraki üçüncü gece tek Karaboran baskını mevcut husumet sonucunu çalıştırır.

## Player Fantasy
Çete reisini hapsetmenin köy için açık ve kalıcı sonuçlarını karşılamak.

## Detailed Rules
Hüküm gecesi ilk gece, üçüncü gecenin husumet aşamasında tetiklenir. Yaşayan nüfustaki gerçek chr_004, zindanda bayrağı ve aynı kimlikli zindan hüküm kaydı birlikte gerekir. Niyet, kapıda asker atama/kışla kararı veya sahte bayrak intikam kaynağı değildir. CAS07 divan hükmü bu maddenin dar tetikleyicisidir; KAP01 karar API'si değiştirilmez.

Tetik teslim makbuzu kişi kimliğiyle yalnız bir kez saklanır. O gece doğal husumet zarı atılmaz, husumet sönümü korunur. Karaboran duyurusu ardından aynı ortak HusumetBaskini stok/yaralanma/moral/asayiş sonucu tek kez uygulanır. Yeni savaş, düşman ordusu, savunma veya HUD sistemi yok; mevcut gece raporu gösterir. Doğal sonraki husumet olayları ayrı mevcut sistemdir.

## Formulas
geçen_gece = gün−hüküm_günü+1; >=3. Ortak eski sonuç: mevcut gıdanın %30'u, odunun %20'si; en çok2 mevcut nüfus seçim zarı, sağlık−40 en az1; moral−15 ve asayiş riski+20 mevcut sınırlar. Bu oranlar yeni intikam bonusu değildir; eski husumet baskınının değişmeyen davranışıdır.

## Edge Cases
Ölmüş/ayrılmış/sürgün/infaz veya bitmiş oyun tetiklemez. Kayıt dönüşü üçüncü gece tarihini ve teslim makbuzunu korur. Bozuk/tekrar kişi makbuzları elenir; sınır100, dolu makbuzda yeni tetik güvenli reddedilir. Tekrarlı tetik stok/RNG etkilemez. İlk iki gece etkisiz; geç tarihli geçerli kayıt ilk uygun husumet aşamasında teslim edilir.

## Dependencies
KaraboranIntikami yeni helper, DivanHukmu tek hüküm kaynağı; KoyYonetimi._husumet dar seçici ve optional save/load. HusumetBaskini eski sonuç blokunun ortak çıkarımıdır; iki hasar yolu yok. CHR belgesi/CSV/koy_halk_hareketi değişmez.

## Tuning Knobs
data/karaboran_intikami.json kaynak chr_004, gece3 ve makbuz100. Asset gerekmedi; mevcut sabah raporu ve zindan kutusu, G envanteri kontrol edildi. Üretim/indirme yok.

## Acceptance Criteria
Gerçek iki gece etkisiz, üçüncü tek baskın; ikinci gece JSON aynı tarih, teslim sonrası JSON tekrar yok. Başka CHR/karar/ölüm/bitmiş oyun reddi, bozuk makbuz temizliği, doğal %100 baskın zarıyla çift hasar yok. Native/headless gerçek Geceye Geç raporu ve çift tıklama koruması; ortak gece/kayıt/regresyon ve iki ds kopyası.
