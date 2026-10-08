# Kişisel eşya sergisi — ODA-03

## Overview
Muhafızın gerçek rüşvet ve kişisel karaborsa eşyaları aynı oda panelinde okunur; masada sınırlandırılmış kutu önizlemeleri bulunur. Tek Oturum.muhafiz_esyalari kaydı kullanılır.

## Player Fantasy
Muhafız, aldığı rüşvet eşyalarını ve kişisel mallarını odasında görür.

## Detailed Rules
Pozitif adetli her envanter kaydı bir UI satırıdır. Ad kaydın ad/kaynak alanından, mevcut esya çevirisinden veya güvenli kişisel eşya etiketinden okunur. İç Clue kimlikleri oyuncuya ham metin olarak gösterilmez. Adet satırda tam görünür, adet başına mesh oluşturulmaz. İlk veri ayarlı sayıda kaydın masada tek kutu önizlemesi bulunur; kalan kayıtlar aynı kaydırılabilir listede kalır. Kayıtları okuma, satır kaydırma ve oda yeniden açma para/stok/envanteri değiştirmez.

## Formulas
Satır sayısı = adet > 0 olan mevcut kayıt sayısı. Mesh sayısı = min(satır sayısı, sergi_azami). Önizleme düzeneği: x = başlangıç.x + (indeks mod sütun) × aralık; z = başlangıç.z + floor(indeks/sütun) × aralık.

## Edge Cases
Boş veya satılan sıfır adetli envanter boş etiket gösterir. Çok büyük miktar tek satır/kutudur. Uzun adlar satır kaydırır, uzun liste dikey kayar; Köye dön düğmesi kaydırmanın dışında kalır. CHR metinleri/source Resource değişmez. JSON kayıt dönüşü ve tekrar giriş tek aynı kaydı kullanır. TUC-11 pazardaki envanter yüzeyi korunur; odada ikinci alış/satış motoru yoktur.

## Dependencies
OdaEnvanterSergisi yeni çizim helperi, MuhafizOdasiEkrani içinde tek çağrı. Mevcut oda/kasa/kese ve Oturum kişisel envanteri. Yer tutucu değişim noktası helperin _kutu fonksiyonu ve JSON boyut/renk/yerdir. Mevcut TUC-11 UI ayrıca bir depo oluşturmaz.

## Tuning Knobs
data/muhafiz_odasi.json sergi_azami/sutun/aralik/yer/boyut/renk. Asset üretimi/indirme yok; gerçek rüşvet/kişisel eşya modelleri envanter G ODA03-ESYA satırındadır.

## Acceptance Criteria
Gerçek CHR rüşvet eşyası ve karaborsa kaydı doğru ad/adetle görünür; JSON dönüşü ve read-only kayıt. Sıfır kayıt, büyük adet ve önizleme üst sınırı; kaydırmada erişilebilir dönüş. Headless/native oda, mevcut kasa/divan/gece/kişisel ekonomi kontrolleri geçer.
