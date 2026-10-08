# Kış kurt baskını — MEV-10

## Overview
Mevcut hazır ağıl, gerçek gece, muhafız devriyesi ve ortak ambar üstüne kış kurt tehdidi. İkinci sürü ekonomisi veya savaş simülasyonu yok.

## Player Fantasy
Oyuncu kışın sürüsünü meşaleli mevcut muhafızla korur; karanlıkta üç kutu kurt yaklaşır.

## Detailed Rules
Yaşayan köy ve hazır ağıl soğukta adaydır. Her etkin yerel muhafız id sırasındaki bir ağılı korur. Dış kervan görevi, borç, uyku ve isyan mevcut etkin muhafız API'sinde hariçtir. Gecede tek deneme; korunmayan ilk ağıla yüzde15 saldırı. Denge varsayımı: sürüyü yemle uzaklaştırarak koruma, aynı ambardan en çok4 gıda. Yem eksikse kişi morali eksik kadar düşer. Temel dört koyun/koç, normal bina hasarı ve özel kasa değiştirilmez; hayvan ölümü için ikinci kalıcı sürü modeli eklenmez. Muhafız tam korumada zar tüketilmez. Gece raporu yemi normal tüketimle toplar; ambar ziyanı ayrı mevcut alandadır.

## Formulas
korunan=index(kararlı hazır ağıllar)<etkin_muhafiz_sayisi; yem=min(4,stok.gida); moral kaybı=4-yem. Baskın yüzde15/gece, en çok bir ağıl. Görsel hız1.6; üç kurt aynı A* yolu üzerinde iki durak arayla yürür, korumada yol ortasında geri çekilir.

## Edge Cases
Optional son gece makbuzu eski/bozuk kayıtta -1; tekrar RNG/olay/kayıp yok. Sıcak/gündüz/boş köy veya yıkılmış ağıl görseli kaldırır. Kapalı rotada çitten kestirme yapılmaz; görünmez. Yenilemede tek KurtSurusu düğümü. Görseller gün/ekonomi/RNG/kanıt değiştirmez. Mevcut devriye ağıla da uğrar; donanım ve el kemikleri yeniden üretilmez.

## Dependencies
KurtBaskini; KoyYonetimi gece/kayıt ve tüketim toplama ince adaptörü; MuhafizDevriyesi tek hedef listesi bağlantısı; KoyHalkHareketi yenile/faz yalnız birer helper çağrısı; mevcut MuhafizDonanimi ve A*.

## Tuning Knobs
Data/kurt_baskini.json risk15, yem4, kurt3, hız1.6 ve kutu renk. Yeni asset üretilmedi/indirilmedi. G MEV10-KURT satırı: kurt modeli/yürüme/kaçış animasyon ihtiyacı; aynı merkezi BoxMesh yer tutucusu.

## Acceptance Criteria
Gerçek baskında yem/tekrar/koruma/sıcak hava, gerçek gece tüketim ve restore eşitliği. Gerçek köyde üç kutu, A* yaklaşma/geri çekilme, mevcut meşale/silah/nöbet, tek düğüm, gündüz/bahar temizlik, native görüntü ve kayıt değişmeme testi.
