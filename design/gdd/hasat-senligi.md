# Hasat şenliği — MEV-08

## Overview
Sonbahar dolu ambar kutlaması mevcut gerçek gece ve moral modeline tek yıllık etki ekler. İkinci olay kartı/HUD veya ekonomi yoktur.

## Player Fantasy
Oyuncu sonbahara dolu erzak deposuyla girer; köy hasadı kutlayıp morale kavuşur.

## Detailed Rules
Sonbaharda yaşayan nüfus, pozitif kapasite ve dolu ortak ambar gerekir. Bu gecenin mevcut erzak ihtiyacı da stokta olmalıdır; yalnız taşla dolu aç köy kutlayamaz. Adaylık üretim/inşaat/barındırma sonrası, normal tüketimden önce okunur. Mevcut sağlık, ücret ve husumet etkilerinden sonra şenlik kalan köylü moralini 100 yapar; isyan kontrolü yeni morali kullanır. İlave gıda tüketimi veya bedelsiz kaynak/para/RNG yaratılmaz. Aynı yılda bir kez, sonraki yıl yeniden koşullar sağlanırsa kutlanır.

## Formulas
Aday = sonbahar ve nüfus>0 ve kapasite>0 ve toplam stok>=kapasite ve gida>=TuketimDengesi.gerek.gida ve yıl>son kutlama yılı. Moral = clamp(ayar.moral,0,100), varsayılan 100.

## Edge Cases
Gece tüketiminden sonra depo artık tam dolu olmasa da tüketim öncesi hasat kanıtı korunur. Boş kapasite/boş köy/erzak eksikliği kutlamaz. Ölenler tekrar yaratılmaz. Aynı yıl ikinci çağrı moral veya olay tekrarlamaz. Eski/bozuk optional yıl sıfır kabul edilir; restore aynı gece sonucu verir. Şenlik mevcut savaş/iflas sonlarını iptal eden ayrı sistem değildir.

## Dependencies
HasatSenligi; KoyYonetimi gece/kayıt ince adaptörleri, ortak kaynaklar, MevsimYoneticisi ve mevcut gece raporu/Hud huzur barı. CSV/CHR ve kapı akışı değişmedi.

## Tuning Knobs
Data/hasat_senligi.json mevsim=2,moral=100. Asset gerekmedi; envanter G kontrol edildi. Mevcut köy/gece raporu yeterlidir; görsel/ses/klip üretilmedi veya indirilmedi.

## Acceptance Criteria
Gerçek dolu-erzak sonbahar gecesinde moral/huzur100; yıllık tek kutlama, sonraki yıl adaylık, aç/taş dolu ambar ret, restore eşitliği ve bozuk yıl testi. Gerçek Geceye geç ekranında hasat raporu ve mevcut huzur barı doğrulanır; moral/isyan/iflas/kayıt/20 gece regresyonları geçer.
