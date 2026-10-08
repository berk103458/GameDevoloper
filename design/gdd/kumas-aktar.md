# Kumaşçı ve Aktar — TUC-04

## Overview
Mevcut gezgin stok takviminde afyon/sargı ve keçe/kumaş alınır. Malzemeler ortak ambarda, etkiler mevcut Sağlık/Refah alanındadır.

## Player Fantasy
Oyuncu şifahanesini donatır ve köylülerine kumaş dağıtarak yaşam standardını yükseltir.

## Detailed Rules
Kumaşçı/Aktar 12–13, 28–29… günlerde gelir. Stok/fiyat: afyon 8/4 akçe, sargı 12/2, keçe 8/4, kumaş 8/6. Var olan başarılı şifahane yanık tedavisi iki erzak kullanmaya devam eder; iyileşme sonrası sağlık 100 altında ise 1 afyon + 1 sargı beraber harcanıp ek 5 sağlık verilir. İkisinden biri yoksa ek harcama olmaz, normal tedavi korunur. Pazarda oyuncu keçe/kumaş dağıtır; otomatik lüks tüketimi yoktur. Dağıtım kişi başına bir stok kullanır, keçe +3/kumaş +5 mevcut kişi Refah puanı verir.

## Formulas
Dağıtım adedi = min(stok, yaşayan ve Refah üst sınırı altında kişi sayısı). Öncelik düşük Refah, eşitlikte kişi id. Yeni Refah = min(üst sınır, eski Refah + ürün delta). Ek sağlık = min(100, normal tedavi sonrası sağlık + 5). Ek tedavi çift malzeme atomik harca işlemidir.

## Edge Cases
Tam sağlıkta ilaç ziyan olmaz; yarım malzeme harcanmaz. Şifahane çalışanı/kapasitesi ve eski kazaya ait bayrak temizliği korunur. Tam Refah/ölü kişiler lüks tüketmez. Dağıtılabilir stok yoksa pazarda gereksiz eylem satırı açılmaz. Başka uzman bu malları satmaz; stok iki günlük konaklamada ortak, sonraki ziyarette yenidir. Yeni türler eski kayıtta sıfırdır, mevcut taşma bakımına dahildir.

## Dependencies
GezginTuccarStogu aynı ziyaret kaydı/işlem; KumasAktarDestegi mevcut ZanaatKazalari.gece içinde tek destek çağrısı. KumasAktarPaneli aynı pazar kartında tek çağrı. EkonomikRefah mevcut sınırları, Kaynaklar ortak ambar ve Hud mevcut şerit genişletilir. İkinci tedavi/HUD/kasa sistemi yoktur.

## Tuning Knobs
data/gezgin_tuccar_stogu.json uzman ürün fiyat/stok/açıklaması; data/kumas_aktar_destegi.json ilaç maliyeti/sağlık ve lüks Refah deltalari. Yeni stok ikonları GezginStokIkonu.ikon merkezinde ColorRect; envanter G TUC04-AFYON/SARGI/KECE/KUMAS. Asset üretimi/indirme ve CSV değişikliği yok.

## Acceptance Criteria
Gerçek uzman UI alımları ve HUD stok adları; gerçek mevcut şifahane tedavisinde çift malzeme tüketimi/+5 sağlık, eksik malzemede korunum. İki gerçek dağıtım düğmesi düşük Refah kişisini destekler; kasa/RNG korunur. Kaydın malzeme/sağlık/Refah ve kalan ziyaret stoğu JSON dönüşü; native pazar, ayna import/UI, eski tedavi/Refah/ambar ve 20 gece kontrolleri geçer.
