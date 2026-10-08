# Tek yozlaşma runtime sözleşmesi — ODA-12

## Overview
ODA-12, ODA-04/05/06/07/10 tarafından kullanılan mevcut MuhafizTerazisi hesabının sözleşme denetimidir. ROADMAP'teki yozlasma.gd taslak hedefi ikinci sınıf/oturum skoru oluşturma talimatı değildir.

## Player Fantasy
Biriken rüşvet, zimmet, haraç ve onarılmamış haksızlık aynı terazide görünür; para harcamak geçmişi aklamaz.

## Detailed Rules
Tek API src/sistemler/muhafiz_terazisi.gd.durum(Oturum) → adalet/yozlasma/denge/unvan ve dört kaynak katkı. Kaynaklar Oturum.bayraklar rusvet_sayisi, kasa_transferleri.zimmet_toplam, muhafiz_yetenekleri.harac_toplam, DivanHaksizligi mevcut ödenmemiş makbuzları; adalet mevcut KoyYonetimi.adalet. Kişisel nakit varlığı suç değildir. Tazmin edilen haksızlık katkısı aynı kaynak makbuzuyla kalkar.

## Formulas
Yozlaşma=clamp(rüşvet×5+zimmet×1+haksızlık×15+haraç×1,0,100). Denge=clamp(round(50+(adalet−yozlaşma)×0.5),0,100). Denge≥65 Adil muhafız, ≤35 Yozlaşmış derebeyi; arası Kararsız muhafız. Tüm ağırlık/eşikler data/muhafiz_terazisi.json kaynağıdır. Unvan sınıfları ODA10 kader eşikleriyle aynı değildir; kader muhafiz_epilogu.json üzerinden bu tek skorun tüketicisidir.

## Edge Cases
Legacy kayıt optional girişleri sıfır okur. Bozuk/negatif/sonsuz/kesirli sayaç güvenli sıfır; büyük değer clamp. Okuma kaydı, stokları, kasa ve RNG değiştirmez. Runtime skor ayrıca kaydedilmez: JSON dönüşünde gerçek makbuzlardan tekrar hesaplanır; iki farklı oturum alanının ayrışması önlenir.

## Dependencies
OdaTerazisiPaneli tek bar/etiket; MuhafizYetenekleri satın alma sınırları; MuhafizAdaletYetenekleri mevcut isyan eşiği; SancakTeftisi tek gece kontrolü; MuhafizEpilogu saf kader seçimi aynı API'yi okur. CSV/CHR/core/kayıt sürümü değişmedi. İkinci HUD, scoreboard veya yozlasma.gd yaratılmadı.

## Tuning Knobs
Mevcut JSON ağırlıkları/denge merkez ve çarpanı/unvan eşikleri. Yeni denge değeri yok. Asset gerekmedi; envanter G kontrol edildi; ODA04 barı kullanılır.

## Acceptance Criteria
muhafiz_terazisi_test gerçek rüşvet/zimmet/haksız hüküm+tazmin, boş/bozuk kaynak, JSON ve saf okuma. muhafiz_yetenekleri_test ve muhafiz_adalet_yetenekleri_test aynı skora bağlı eşikler. sancak_teftisi_test aynı makbuz ve tek zar. oda_terazisi_kontrol gerçek tek bar/etiket ve kasa/RNG değişmezliği; korumalı API denetimi. Altı kontrol kapanış kanıtıdır.
