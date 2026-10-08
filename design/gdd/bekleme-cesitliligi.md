# Bekleme çeşitliliği — ANI-12

## Overview
Mevcut köylü idle modifieri 0.1–1.5 saniye faz farkı ve üç basit bekleyiş profiliyle eşzamanlı kalabalık görüntüsünü azaltır.

## Player Fantasy
Köylüler aynı anda aynı hareketi tekrarlamaz; biri nefes alır, biri ağırlık aktarır, biri çevreye bakar.

## Detailed Rules
Yeni köylü modeli kurulurken tek satırlık KarakterBeklemeCesitliligi.uygula çağrısı kimlikten kararlı faz/varyant seçer. Aynı karakter rota ve gündüz/gece yenilemelerinde profili korur. Mevcut DurusDuzeltici._nefes aynı kemik dönüşlerini kullanır, açı hesabını yeni yardımcıya devreder; ikinci modifier/AnimationPlayer oluşturulmaz. Nefes, ağırlık, bakış profilleri üç açı grubunun dış yapılandırmadaki çarpanlarıdır. Yürüyüşte bekleme sıfıra yaklaşırken idle katkısı azalır. Profil atanmayan kapı/CHR modeli eski açı hesabını aynen korur. Gerçek üç klip gelene kadar bunlar açıkça modifier yer tutucusudur; animasyon dosyası üretilmez.

## Formulas
Ofset = min + (max−min) × ((id × adım) mod örnek_sayısı)/(örnek_sayısı−1). Varyant = id mod profil sayısı. Nefes = sin(t×TAU/nefes_suresi)×nefes_derece; ağırlık aynı şekilde agirlik_suresi/derece. Bakış iki sinüsün ağırlıklı toplamıdır. Her açı profil çarpanı ve bekleme (0…1) ile çarpılır; t = mevcut modifier zamanı + saniye ofseti.

## Edge Cases
İskeletsiz fallback'a sahte modifier/kemik kurulmaz. RNG ve kayıt değiştirilmez. Eski iş/duygu/hava pozu, yürüyüş tweeni ve klip önbelleği korunur. Son poz doğrulaması Skeleton3D.skeleton_updated sırasında yapılır; kare sonu geçici modifier pozunu temsil etmez. Yeni HUD/durum paneli yoktur.

## Dependencies
KarakterBeklemeCesitliligi, KoyHalkHareketi model kurulum adaptörü, DurusDuzeltici ve mevcut Skeleton3D. ANI-07/08/09/10/11 rutinleri aynı modifier ve alet bağlarını korur.

## Tuning Knobs
data/bekleme_cesitliligi.json: faz aralığı/kararlı örnekleme, üç profil çarpanı, eski nefes/ağırlık/bakış açı ve hızları. Klip ihtiyacı envanter G tablosu ANI12-IDLE; gerçek klip değiştirme noktası mevcut karakter idle yolu.

## Acceptance Criteria
0.1–1.5 saniye sınırı, kararlı profil, üç farklı açı, yürüyüşte sıfır etki, eski kapı profilinin formülü ve fallback. Gerçek altı köylüde üç profil/son baş pozu farkı, gece profil koruma ve oturum/RNG korunumu; native/ayna, eski animasyon/rutinler ve 20 gece geçer.
