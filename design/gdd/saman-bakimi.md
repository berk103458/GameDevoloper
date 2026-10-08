# Kış samanı ve gerçek sürü kaybı — MEV-14

## Overview
Saman aynı ortak ambarın yeni yem türüdür; kış ve tipide hazır ağılın başlangıç koyunları ile mevcut lojistik hayvanları beslenir.

## Player Fantasy
Oyuncu sıcak mevsimde tahıl biçip kışlık yem ayırır; yem açığında gerçek sürü ve üretim kaybını görür.

## Detailed Rules
Denge varsayımı: hayvan başına gecede1 saman, eksikte gecede en fazla1 ölüm. Hazır ağıllar kimlik sırasıyla, her ağılın yaşayan başlangıç koyunları önce; sonra Celep yapılandırma tür sırasındaki satın alınmış hayvanlar beslenir. İlk yemsiz hayvan ölür. Başlangıç koyunu optional bina sayacında, satın alınmış hayvan mevcut lojistik sayacında azalır. İnşaat ağılının başlangıç sürüsü henüz aktif değildir; ahırı yıkmak satın alınmış hayvanı yemden muaf tutmaz. Ölüm üretimden önce çözülür, aynı gece ağıl üretimi azalır. Normal binada hasar alanı yok.

Gerçek ambara giren buğdayın1:1 yan ürünü saman aynı kapasiteye eklenir; yer yoksa eklenmez. Mevcut kervan kapı izni/ziyaret açıkken aynı pazar kartından10 saman5 kamu akçesine alınır. Gıda/odun fiyatı, özel kasa ve uzman stoğu ayrı mevcut kurallarıyla kalır. Saman mevcut stok şeridinde düz renk ikon, stok/net ve yem tooltip ile görünür. Bina bilgi kartı yaşayan başlangıç koyunu ve satın alınmış barınan sayısını gösterir.

## Formulas
İhtiyaç=yaşayan hayvan sayısı×1. Beslenen=min(hayvan sayısı,floor(stok/1)); tüketim=beslenen×1. Ölüm=min(aç sayısı,1). Ağıl temel üretim çarpanı=yaşayan başlangıç koyunu/4; mevcut inek/koç bonusu buna eklenir ve mevcut1.5 tavanına uyar. Boş ağıl ve sıfır destek sıfır üretir. Saman hasadı=floor(gerçek buğday çıktısı×1), aynı ambar boş yeriyle sınırlı. Pazar bedeli=ceil(10×0.5).

## Edge Cases
Aynı gece makbuzu kayıtla korunur; tekrar yem/ölüm yok. Eski bina kaydında başlangıç4, eski stokta saman0; kayıtlı sıfır sürü geri doğmaz. Bina yıkılınca onun başlangıç sürüsü kaydı da kaldırılır; satın alınmış hayvan kaydı mevcut lojistikte kalır. Hayvan ölümünde para/iade/ikinci envanter yok. Sıcak mevsimde otlama bedelsiz; yeni yem RNG yok. Görselleştirme ekonomik kayıt değiştirmez, temel/satın alınmış hayvanı aynı üç sürü dizisinde kimliğine göre azaltır; sıfır sürüden yeni koç eklenebilir. Çoban yolları ve sağ kalan hayvanların mevcut ilerlemesi korunur.

## Dependencies
SamanBakimi; KoyYonetimi gece/hasat/kayıt ince çağrıları; KoyBinasi optional agil_koyun; aynı Kaynaklar/AmbarBakimi. CanliHayvanTakasi mevcut üretim çarpanı; CanliHayvanSurusu/CobanSurusu mevcut tek sürü. SamanBilgisi mevcut bina/pazar kartının ince bağlantısı; Hud mevcut stok şeridi.

## Tuning Knobs
Data/saman_bakimi.json: gecelik_yem1, gecelik_azami_kayip1, hasat_orani1, alis_fiyat0.5, alis_partisi10 ve ikon rengi. Başlangıç sürü sayısı mevcut data/coban_surusu.json'dan. Asset üretilmedi/indirilmedi; saman gerçek ikon ihtiyacı envanter G MEV14-SAMAN, merkezi ColorRect yer tutucu.

## Acceptance Criteria
Yemli/yemsiz/kısmi gece, temel ve satın alınmış ölüm, sıfır üretim, çeki bonusu ve satışın düşmesi, makbuz/JSON restore/gerçek gece eşitliği, eski/sıfır kayıt, sıcak mevsim, aynı ambar taşması ve atomik pazar alış testi. Gerçek Ana/KoyEkrani pazar sinyali, tek HUD/aynı bina kartı, tek sürü üç dizi küçülmesi ve sıfırdan koç ekleme; native görünüm ve ilgili regresyonlar.
