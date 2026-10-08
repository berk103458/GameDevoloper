# Pazar satışında kasa hedefi — TUC-10

## Overview
Mevcut tek pazarın ambar satış düğmeleri kamu kasası veya muhafız kişisel kesesi seçimini kullanır. Kişisel yön mevcut zimmet kurallarına bağlıdır; ikinci ekonomi veya kasa oluşturulmaz.

## Player Fantasy
Muhafız köyün fazla üretimini kamu yararına satabilir veya aynı satışın gelirini toplumsal bedel karşılığında kendisine ayırabilir.

## Detailed Rules
Varsayılan hedef köy kasasıdır. Tek OptionButton aynı pazar kartında hedefi değiştirir; 5/20 tezgâh ve 20 kervan satış düğmeleri ortak hedefi kullanır. Hedef değişikliği model/kayıt/RNG değiştirmez; kart yeniden açılırken UI tercihi korunur. Kamu satışı mevcut ekonomik yolu sürdürür. Kişisel satış önce gerçek satışı kamuya işler, ardından o tutarı mevcut KasaTransferi zimmet işlemiyle kişisele geçirir. Ön denetim bütün koşulları doğruladığından başarısız seçim stok/para tüketmez. Kişisel gelir günde bir kez ve en çok 10 akçe; Adalet -5, Moral -3, Asayiş riski +5 mevcut EKO-14 ayarından gelir. Negatif kamu kasasında kişisel kaçış yoktur; kamu satışı açığı kapatmaya devam eder.

## Formulas
Teklif: mevcut stok ve istenen adetle satış fiyatından tam akçe kazancı. Tezgâh için mevcut günlük kalan limit uygulanır; satılan adet = min(stok/istek, ceil(kazanç / birim fiyat)). Kamu hedefi: kamu += kazanç. Kişisel hedefi: satış kamu += kazanç; mevcut zimmet kamu -= kazanç, kişisel += kazanç. Toplam gelir bir kez yaratılır; ekstra ödül yoktur.

## Edge Cases
Kervan yokken kervan satışı, sıfır/negatif/büyük adet, bilinmeyen ürün, oyun sonu ve sıfır kazanç reddedilir. Günlük kişisel hak tüketilince kamu satışı açık kalır; kayıttan dönmek hakkı yenilemez. Kişisel kasa veya zimmet toplamı üst sınırında işlem önceden reddedilir. Tezgâh günlük sınırı hedef değişimiyle sıfırlanmaz. Mevsimsel fiyatlar ve Tekfur alış farkı korunur. Mevcut kişisel kasa kurtarma/zimmet düğmeleri aynı defteri kullanır.

## Dependencies
PazarSatisi yeni saf önizleme/yönlendirme helperı; mevcut KoyYonetimi satış API'lerini kullanır. KasaTransferi gelir_uygun ince ön-denetim uzantısı aynı zimmet koşulunu paylaşır. PazarSatisPaneli mevcut kartta tek hedef seçimi; KoyEkrani satış callbackleri ince helper çağrılarıdır. Oturum/kayıt/nüfus/HUD yeniden yazılmaz.

## Tuning Knobs
Mevcut KoyAyarlari satış/tezgâh dengesi ve data/koy/kasa_transferi.json günlük kişisel tavan/sosyal bedel. Asset gerekmedi; mevcut OptionButton ve düğmeler kullanılır, CSV/görsel/ses/model değişmez.

## Acceptance Criteria
Önizleme gerçek satış sonuçlarıyla üç mevsim/iki kanal/üç ürün için eşleşir. Kamu ve kişisel gerçek UI tahsilatı, sıfır kamu kasası, günlük sınır, kayıt sonrası engel, sosyal bedel ve RNG korunması geçer. Hedef seçimi kayıt değiştirmez. Mevcut çift kasa/transfer/tüccar/borç/sözleşme/snapshot/iflas/20 gece regresyonları, native pazar ve ds ayna import/UI geçer.
