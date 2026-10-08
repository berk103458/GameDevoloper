# Yozlaşma ve adalet terazisi — ODA-04

## Overview
Oda kişisel terazisi mevcut adalet, kayıtlı rüşvet sayısı, zimmet toplamı ve onarılmamış haksız divan kararlarından saf görünüm hesaplar. İkinci sosyal/ekonomi sistemi veya makbuz listesi eklenmez.

## Player Fantasy
Muhafız kendi kararlarının adil muhafız ile yozlaşmış derebeyi arasındaki yönünü görür.

## Detailed Rules
Kişisel akçe miktarı yozlaşma değildir; yasal gelir veya parasını harcamış olmak geçmiş kararları değiştirmez. Rüşvet sayısı mevcut Oturum bayrağı, zimmet mevcut EKO-14 makbuzu, haksız karar CAS-10'un ödenmemiş makbuzudur. Ödenmiş onarım haksızlık katkısından çıkar; diğer kayıtlar silinmez. Köy adaleti kaynak kalır, terazi onu değiştirmez. Ekran açılınca hesaplanır, her kare veya ikinci gece işlemi çalışmaz.

## Formulas
R = geçerli rüşvet sayısı; Z = geçerli zimmet akçesi; H = ödenmemiş haksızlık makbuzu sayısı. Yozlaşma = clamp(R×5 + Z×1 + H×15, 0, 100). Adalet = clamp(mevcut köy adaleti, 0, 100). Denge = clamp(round(50 + (Adalet−Yozlaşma)×0.5), 0, 100). Denge≥65 adil; ≤35 yozlaşmış; arası kararsız. Bu değerler bağımsız denge varsayımıdır ve JSON'dan ayarlanır; mevcut stat etkileri tekrar uygulanmaz.

## Edge Cases
Eski kayıt eksik sayaçla sıfır katkı verir. Bozuk, negatif, kesirli veya nonfinite rüşvet sayısı sıfırdır; büyük sayaç bounded okunur. Haksızlık makbuzu mevcut CAS doğrulamasından geçer; çift okumada artmaz. Envanter değişimi/harcama adaleti aklamaz. JSON dönüşünde aynı kaynaklardan aynı sonuç oluşur. Bu madde yetenek açmaz ve epilog seçmez; sonraki ODA maddeleri aynı sözleşmeyi genişletir.

## Dependencies
MuhafizTerazisi yeni saf helper, OdaTerazisiPaneli tek oda bağlantısı. Oturum.bayraklar, KasaTransferi.oku, DivanHaksizligi.durum ve KoyYonetimi.adalet korunur. ODA-12 runtime erişimi aynı hesaba bağlanmalı, ikinci skor üretmemelidir.

## Tuning Knobs
data/muhafiz_terazisi.json ağırlıklar, merkez/çarpan ve unvan eşikleri. Asset gerekmedi; mevcut oda UI/ProgressBar, envanter G kontrol edildi.

## Acceptance Criteria
Gerçek rüşvet ve zimmet makbuzları skor yönünü değiştirir; kişisel para tek başına değiştirmez. Haksızlık/ödenmiş makbuz, sınırlar, eski/bozuk kaynak, JSON ve saf tekrar okuma doğrulanır. Native oda, kasa/envanter/divan/gece kontrolleri geçer.
