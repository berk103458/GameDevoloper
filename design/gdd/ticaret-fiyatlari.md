# Mevsimsel ticaret fiyatları — TUC-09

## Overview
Mevcut takvim/iklim mevsimi odun ve erzak ticaretini kış kıtlığı ve yaz bolluğuna bağlar. Tek saf fiyat hesabı gerçek tahsilat, uzman stoğu ve pazar etiketinde kullanılır.

## Player Fantasy
Oyuncu kış öncesi stok yaparak pahalı yakacak/erzak alımını önler; yazın daha düşük bedelle tedarik eder.

## Detailed Rules
Odun, gıda, buğday ve un ilkbahar/sonbaharda taban, yazın ×0.75, kışın ×3 fiyat kullanır. Bu mevsimsel kıtlık katsayısıdır; panel açılışı veya ambardaki stokla oynayarak yeni fiyat/RNG üretilemez. Diğer ürün ve canlı hayvan fiyatları korunur. Mevcut genel kervan alımına odun eklenir (taban 0.5 akçe/adet); ikinci satıcı yoktur. Kervan ve köy tezgâhına satış aynı mevsim katsayısını kullanır, tezgâhın %60 oranı ve günlük 4 akçe tavanı korunur. Sipariş kabulünde dondurulmuş ödül/ceza değişmez. Tekfur'a geçen demirci nedeniyle alet ×1.5 ek fiyatı tahsilattan önce görünür.

## Formulas
Katsayı = [1, 0.75, 1, 3][mevcut mevsim], yalnız ayarlı erzak/yakacak türlerinde. Genel alış parti bedeli = ceil(taban birim × katsayı × adet). Uzman sınırlı stokta birim = ceil(taban × katsayı), bedel = birim × adet. Satış birim = taban × katsayı; mevcut tam akçe/satılan adet hesabı korunur. Alışta sıfır/negatif adet reddedilir.

## Edge Cases
Eski kayıt fiyatı mevcut gününden türetir, ek kalıcı fiyat defteri yoktur. Admin iklim önayarı gerçek üretim/tüketimle aynı mevsimi kullanır. Uzmanlar ve sadakat ürünleri her sorguda derin kopyada fiyatlanır; JSON taban fiyatı değişmez. Yetersiz kasa/ambar veya borç ambargosu alımı engeller. Geçerli ziyaret yokken fiyat okunabilir ama işlem yapılamaz. Küçük yaz partileri tam akçeye yukarı yuvarlanır, bedava alım yoktur. Stok, kasa ve RNG sorguyla değişmez.

## Dependencies
TicaretFiyatlari yeni saf helper; KoyYonetimi tezgah_sat/kervana_sat/kervandan_al mevcut API'lerinde ince fiyat çağrıları. GezginTuccarStogu ürünü kopyaladıktan sonra tek fiyat satırı uygular. TicaretFiyatPaneli aynı pazar kartına tek açıklama; genel alım etiketi ortak bedel çağrısıdır. Mevcut takvim/iklim/ambar/kasa/sözleşme yolları korunur.

## Tuning Knobs
data/ticaret_fiyatlari.json hedef ürünler ve dört mevsim katsayısı. Mevcut KoyAyarlari kervan fiyatları, genel alışlar ve tezgâh sınırı. Asset gerekmedi; CSV, görsel/ses/model veya ikinci HUD üretilmedi.

## Acceptance Criteria
Kış ×3/yaz ×0.75/taban geçişi, gerçek alım/satım/tezgâh sınırı, parti yuvarlama, negatif adet engeli, Tekfur zammı ve admin mevsim önayarı testleri geçer. Gerçek UI gösterdiği 15/4 akçeyi tahsil eder. Fiyat sorgusu ve kayıt roundtrip RNG/stok/dengeyi korur. Tüccar, karaborsa, sipariş, borç, snapshot, iflas ve 20 gece regresyonları; native yaz/kış ve ds ayna import/UI geçer.
