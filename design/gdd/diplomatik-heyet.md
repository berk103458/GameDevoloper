# Zorunlu diplomatik/askeri heyet bildirisi — HAR-12

## Overview
Tekfurun gerçek bekleyen haraç talebi ve Moğolun gerçek5/2/0 gece uyarıları, mevcut Gelen kuyruğunun başında heyet olarak dinlenir. Ayrı kapı/savaş/hasar motoru yok.

## Player Fantasy
Önce sınırdan gelen askeri heyeti ve resmî haraç ulağını dinlemek, ardından sıradan kafile ve pazara geçmek.

## Detailed Rules
Moğol önce, Tekfur sonra, mevcut uzman/normal ziyaretçiler korunur. Tekfur için ikinci perde + harac_bekliyor gerekir; Moğol için aynı gerçek gün geri sayımı ve tamamlanmış gece uyarı makbuzu gerekir. Ziyaret aynı listeye bir kez eklenir; ekleme RNG/kasa/deftere yazmaz. Dinleme mevcut kabul simgesini kullanır ama generic köylü kabulüne düşmez. Moğol yalnız bildirir; Tekfur dinle veya gerçek kamu akçesi+buğday ödeme seçimi. Dinlemek haraç talebini çözmez; mevcut sonraki gece cevapsız/baskın kuralı korunur.

## Formulas
Optional makbuz tekfur_gun=-1 ve mogol=[izinli dinlenen eşikler]. Tekfur her gerçek talep gününde bir defa; Moğol her5/2/0 eşiğinde bir defa, 0 sonraki günlerde tekrarlanmaz. Haraç gerçek y.a.harac_akce/harac_gida (mevcut10/20) üzerinden TekfurHaracHeyeti.ode; kişisel kese, nüfus, kadro, stat, savaş, tecrübe ve RNG değişmez.

## Edge Cases
Eksik kaynakta ödeme kapalı ve doğrudan API atomik ret; dinleme açık, kaynak yok diye oyuncu kilitlenmez. İlk basış seçer, ikinci onaylar. Karar verilmeden _siradaki/klavye atlayamaz; sıradaki heyet varken sıra olayı/öne geçme oluşmaz. Mevcut fırtına görünür bütçesi ve bekleme uygulanır; logical sıra korunur. Bayat gün/terminal/yanlış seçim/ikinci karar atomik ret. Snapshot optional sınırlı bilet taşır, script/Resource yüklemez; legacy metadata yok. Geçersiz sayı/kimlik/tür elenir. Kalan negatif Tekfur sentinel yalnız gerçek -1 kabul eder.

## Dependencies
DiplomatikHeyet + dış JSON; Otu queue/karar/optional save-load ince çağrıları. HeyetKapiPaneli aynı karar başlık/alt/sonuç/kilit yüzeyi. KapiEkrani ileri ve ön ödeme guard; KapiFirtinaKuyrugu.sira_olayi optional liste argümanı ve SiraAtlamaAdaptoru guard, eski çağrılar korunur. KapiAnlikGoruntusu iki optional serialize/normalize çağrısı. KAP01/CHR/CSV/KarakterModel/Ses değişmez; normal uzman makbuzu ve iki kasa kendi politikalarını korur.

## Tuning Knobs
Öncelik/ad/giriş/karar metinleri ve mevcut asker portresi dış JSON. Moğol eşikleri mevcut MogolOncusu typed _esikler API'sinden alınır; JSON float/int üyelik farkı normalleştirilir. Yeni asset gerekmedi: mevcut asker modeli/karar simgeleri kullanılır, üretim/indirme yok; envanter G kontrol edilir.

## Acceptance Criteria
Gerçek25.gece Moğol ve ikinci perde6.gece Tekfur kaynak raporları; aynı queue zorunlu baş, normal nesneler/tekrar ekleme saflığı. Atomik yanlış/eksik/bayat/ikinci/terminal ret, gerçek10kamu20buğday ve kişisel kese ayrımı. JSON/snapshot bilet/makbuz, source RNG/nüfus korunması. Gerçek iki heyetin aynı model kuyruğunda dinlenmesi ve ödeme düğmesi, doğrudan ileri/atlama kilidi, sonrası gece_bitti; headless/native/ayna, kapı/snapshot/öngörü/heybe/fırtına/20gece regresyonları.
