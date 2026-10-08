# Kış soğuğu ve donma — MEV-02

## Overview
EKO-09/MEV-11 tek yakacak hesabı korunur. DonmaYoneticisi mevcut soğuk sağlık kaybına gece başına üç kişilik donma eşiği sınırı ekler.

## Player Fantasy
Oyuncu kış yakacağını ve savunmasız köylülerin sağlığını planlar; odun kartının mevcut açıklaması riski gösterir.

## Detailed Rules
Kış veya zorlanmış kar fırtınasında mevcut kişi başı odun ihtiyacı bir kez hesaplanır ve ödenir. Yakacak eksikse mevcut soguk_saglik kaybı herkese uygulanır. Soğukla sıfıra inebilecek yaşayan köylüler sağlık, sonra id sırasıyla seçilir; en fazla üçü eşikten geçebilir. Diğerleri en az bir sağlıkta kalır. Gerçek ölüm ve iyileşme mevcut gece sağlık fazında çözülür; sağlıklı kişi anında öldürülmez.

## Formulas
İhtiyaç = MevsimTuketimAdaptoru.odun(y). Aday = 0 < sağlık <= soguk_saglik. Seçilen sayısı = min(aday sayısı, clamp(donma_azami,1,3)). Seçilmeyen yaşayanın son sağlığı = max(1, sağlık - soguk_saglik).

## Edge Cases
Tam yakacak ve ılık mevsimde donma yoktur. Boş köy risk yaratmaz. Açlık, önceden sıfır sağlık ve diğer ölüm sebepleri bu sınıra dahil değildir. Barınma/iyileşme eşikteki kişiyi kurtarabilir; uyarı kesin ölüm sayısı değil risktir. Kayıt dönüşü aynı risk ve gece raporunu verir.

## Dependencies
src/dunya/donma_yoneticisi.gd yeni helper; KoyYonetimi._tuket ve TuketimDengesi.tip ince çağrıları. Kaynak kartı, nüfus, ölüm raporu, kayıt ve iklim mevcut sistemlerdir; yeni panel/saat/RNG/ekonomi yoktur.

## Tuning Knobs
Mevcut KoyAyarlari.soguk_saglik; data/koy/tuketim_dengesi.json donma_azami=3. Asset gerekmedi; envanter G kontrol edildi, üretim/indirme yapılmadı.

## Acceptance Criteria
Yedi savunmasız kişi ve eksik yakacakta üç soğuk ölümü, dört yaşayan; bir savunmasız kişide bir risk. Sağlıklı kişiler eski sağlık kaybını alır. Yakacak bir kez ödenir, kayıt roundtrip aynıdır. Gerçek köy ekranında uyarı ve gece sonrası nüfus doğrulanır; ilgili sağlık/mevsim/kayıt/20 gece kontrolleri geçer.
