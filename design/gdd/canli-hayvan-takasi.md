# Canlı hayvan takası ve sürü katkısı — TUC-14

## Overview
Mevcut Celep alışına kamuya geri satış eklenir. Aynı hayvan kaydı barınak, kutu görünümü, lojistik ve üretim desteğinin kaynağıdır.

## Player Fantasy
Oyuncu köy kasasından aldığı hayvanı sürüye katar, iş verimini artırır veya gerektiğinde Celep'e geri satar.

## Detailed Rules
Hazır ahır iki ortak öküz/inek/beygir yeri; ağıl başlangıç dört koyununa iki ek koç yeri sağlar. Alım mevcut Celep ve kapı/ambargo koşullarına uyar. Geri satış yalnız Celep'te, tek hayvan ve kamu geliridir. Barınaksız kalan kayıt hayvanı silinmez, üretim desteği vermez. Çeki yükü/zamanı mevcut CekiLojistigi 9 birim/0.5 gece hesabıdır. Öküz tarla/bostan erzak ve buğday üretimini destekler. İnek ağıl erzak çıktısında süt katkısını temsil eder; yeni süt kaynağı yoktur. Koç yalnız bulunduğu ağılın üretimine katkı verir. Bütün katkılar mevcut çalışan/yaş/moral/kış/isyan/girdi kuralları içindeki tek üretim hattına çarpan olarak uygulanır; boş iş yeri pasif çıktı yaratmaz.

## Formulas
Öküz: barınan adet başına +%25 tarla/bostan. İnek: barınan adet başına +%20 ağıl; yerel koç başına +%10. Ortak üst çarpan ×1.5. Geri satış = floor(alım fiyatı ×0.5). Al-sat para üretmez. Ondalık üretim mevcut _ambara artık hesabında kalır.

## Edge Cases
İkinci satış, yanlış uzman, kapı ret/bekleme, borç ambargosu, bitmiş oyun ve kasa taşması değişiklik yapmaz. Aynı lojistik kaydı yüklenince katkı yeniden hesaplanır; ikinci hayvan envanteri yoktur. Tamamlanmamış/yıkılmış barınak desteği engeller. Bir hayvan bir 3B düğüm: koç mevcut CobanSurusu koyunlar/adimlar/yollar listelerine katılır; dört temel koyun korunur. Satışta üç dizi birlikte küçülür. Dört sürülük görsel bütçe dışındaki koç merkezi barınak kutusunda kalır; model üretimi görüntü bütçesinden bağımsızdır.

## Dependencies
CanliHayvanTakasi, CanliHayvanSurusu, HayvanTakasPaneli yeni helper dosyalarıdır. Mevcut üretim miktarında tek çarpan çağrısı; mevcut Celep panelinde tek çağrı; mevcut sürü yenilemede tek çağrı ve statik hayvan görünümünde tek filtre. koy_halk_hareketi, Oturum ve koy_ekrani değiştirilmez. Mevcut A* sürü yol dizisi paylaşılır.

## Tuning Knobs
data/canli_hayvan_takasi.json satış ve katkı denge varsayımlarını tutar. G tablosundaki TUC02-OKUZ/INEK/KOC satırları TUC-14 için de geçerlidir; koç hareketi merkezi düz BoxMesh kullanır. Asset üretimi/indirme yoktur.

## Acceptance Criteria
Gerçek alım koçu dört temel koyuna ekler; yenilemede aynı sürü kalır. Geri satış kamuya 12 akçe, koç ve tek kutu azalması, boş kapasite ve dizi uyumu sağlar. Model testi tek üretim hattında gerçek artış, kayıt dönüşü, kapasite/bitmemiş barınak, al-sat zararı ve atomik retleri sınar. Çeki/çoban/tahıl/ambar/ticaret/kayıt/UI ve 20 gece regresyonları geçer.
