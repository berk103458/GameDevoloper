# Kişisel karaborsa ve muhafız odası — TUC-11

## Overview
Silah Tüccarı konaklamasında yasak mühür/kaçak iksir yalnız kişisel keseden alınır ve mevcut muhafiz_esyalari listesine yazılır. Aynı pazardan odanın salt okunur envanteri açılır.

## Player Fantasy
Muhafız kişisel birikimiyle kayıtsız eşya toplar; köy kasası ve ortak ambar bu koleksiyonu finanse etmez.

## Detailed Rules
Yasak mühür 15 kişisel akçe, ziyaret başına 1; kaçak iksir 12, ziyaret başına 2. Silah uzmanı ve borç ambargosu mevcut takvimden gelir. Kamu akçesi, boş ambar veya kişisel kasa kurtarma düğmesi bu koşulu atlatmaz. Aynı envanter satırında toplam adet, son varış ve bu ziyarette alınan adet korunur. Yeni ziyaret toplam eşyayı silmez, yalnız ziyaret makbuzunu yeni alımda yeniler. Oda mevcut pazar kartında bu listeyi gösterir; ayrı oda simülasyonu/depo veya ikinci HUD yoktur. Eşyalar bu pakette saklanan koleksiyondur; tüketim/buff/silah donanımı etkisi verilmez.

## Formulas
Kalan = max(0, ziyaret stoğu - aynı varış makbuzu). Alınabilir = Silah ziyareti AND oyun bitmedi AND ambargo yok AND kalan > 0 AND muhafız akçesi ≥ fiyat AND toplam adet < 1 milyar. Başarı kişisel akçe -= fiyat; toplam adet += 1; ziyaret adedi += 1.

## Edge Cases
İkinci gün veya kayıt yüklemesi stoğu yenilemez. Başarısız/bilinmeyen/parasız alım kasa/eşya/ambar/RNG değiştirmez. Kamu akçesi büyük ama kişisel kese boşsa düğme kapalıdır. Diğer tüccarlar teklif sunmaz; tüccar ayrıldıktan sonra oda erişimi kalır. Mevcut rüşvet eşyaları aynı listede korunur. Kayıttaki isteğe bağlı makbuz sayıları normalleştirilir; bozuk/sonsuz/kesirli sayı güvenli sıfır olur. Oda açılışı model/kayıt değiştirmez.

## Dependencies
KaraborsaAdaptoru yeni saf helper; mevcut Oturum muhafiz_akce/muhafiz_esyalari alanları kullanılır. Mevcut kişisel eşya loaderında tek makbuz adaptörü. KisiselKaraborsaPaneli GezginStokPaneli içine tek çağrı; mevcut kart ve kaydırma/kapanış yolu. Oturum, kasa ve nüfus çekirdeği ezilmez.

## Tuning Knobs
data/kisisel_karaborsa.json isim, fiyat, ziyaret stoğu ve açıklama. Yeni ikonlar G TUC11-MUHUR/IKSIR satırlarında; tek oda görünümündeki ColorRect yer tutucusu. Asset üretimi/indirme ve CSV değişikliği yoktur.

## Acceptance Criteria
Gerçek UI yalnız kişisel 15 akçe tahsil eder; kamu ve ambar sabit kalır. Aynı ziyaret tükenmesi, ikinci gün, sonraki ziyaret, kayıt makbuzu, borç ambargosu ve bilinmeyen alım geçer. Oda gerçek eşya adedini gösterir ve sorgu kaydı korur. Çift kasa/transfer/pazar/tüccar/borç/sipariş/snapshot/iflas/20 gece regresyonları; native oda ve ds ayna import/UI geçer.
