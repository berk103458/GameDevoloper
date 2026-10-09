# Güvenlik ve kafile dengesi — HAR-11

## Overview
Mevcut 0–10 Güvenlik göstergesi gerçek gece kuyruğunun seçim ağırlıklarını değiştirir. Yeni kafile döngüsü, saldırı zarı veya gizli suç kanıtı yok.

## Player Fantasy
Güvenli uçta ticaret çevresi daha çok yaklaşır; zayıf nöbet hattı, mevcut casus/çete profillerinin yaklaşmasını kolaylaştırır.

## Detailed Rules
Güvenlik<4: gerçek CAS profilli CHR adayları ağırlık3, diğerleri1. Güvenlik>7: esnaf sınıfı ağırlık2, diğerleri1. Kaynak CAS01 profil kümesi chr001/002/004/005/006/009/010; CHR kaynağında çete/casus niyetiyle aynı mevcut runtime. Oyuncuya kimlik veya kanıt olarak açılmaz. Erken gece/dönüş/istendi uygunlar filtresi önce işler, seçilen kişi aynı pop/iste yolundan geçer; adlı kişi bu gecede iki kez seçilemez.

## Formulas
Ağırlıklı aday olasılığı w_i/toplam(w); risk +iki sıradan aday örneğinde3/5, esnaf +iki sınıfta2/4. Aynı kategori ağırlıkları eşitse eski tek randi_range aynen kullanılır; Güvenlik4–7 eski RNG akışı tam eşittir. Ağırlıklı durumda mevcut Oturum._rng tek randf; RNG mevcut kayıt içinde deterministik devam eder. Güvenlik = mevcut Oturum.gosterge(3), KervanKorumasi.guvenlik /10; ayrı stat veya baz asayiş değişimi yok.

HAR-15 bu aynı Güvenlik kaynağına yalnız ağalıkta sınırlı savunma hazırlığı ekler; formül ve çift sayım önleme [savunma-guvenligi.md](savunma-guvenligi.md). HAR-11 eşikleri/ağırlıkları veya RNG çekim sayısı değiştirilmez.

## Edge Cases
Uygun risk adayı yoksa kişi zorla çağrılmaz. Hazır KAP01 JSON diyalog listesi tüketilme sırasıyla kalır; güvenlik etkisi onun ardından rastgele sınıf fallback'ında ve gerçek adlı kadroda. Esnaf mevcut oyunun ticaret sınıfı eşlemesidir; her esnaf ziyaretçisi uzman tüccar değildir. Gezgin uzman takvimi, geçiş bacı/rüşvet/ret makbuzu ve özel GocYolu ziyareti değiştirilmez. HAR14 ayrı tüccar akışı paketidir. Çete baskını/husumet/yaralanma veya savunma formülü yeniden kurulmaz.

## Dependencies
GuvenlikKafileDengesi + data/guvenlik_kafile_dengesi.json. Oturum.gece_kuyrugu aday pop seçimine tek helper, _figur_sablon sınıf seçimine tek helper. Kadro/CHR/CSV/KAP01/HUD/KarakterModel/Ses değişmez. Aynı GozcuOngoru izole runtime yeni ağırlığı doğal olarak simüle eder.

## Tuning Knobs
Dış JSON eşikler4/7, ağırlık3/2, gerçek CAS profil ID kümesi ve esnaf eşlemesi denge varsayımı. Yeni görsel/ses/model yok; asset gerekmedi, G envanter kontrolü yapılır.

## Acceptance Criteria
3/4 ve7/8 sınırları, exact ağırlıklı aralıklar, normal RNG eşitliği, kaynak state saflığı, gerçek uygun kadro kuyrukta tekrarsız, JSON aynı RNG devamı, kervan geçici güvenlik etkisi. Kaynak/korumalı API/20gece, kadro/CHR/kapı/tüccar/öngörü/kayıt testleri, mevcut native kapı/öngörü ve ds ayna.
