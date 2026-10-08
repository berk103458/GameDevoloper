# Oda geliştirmeleri ve muhafız yorgunluğu — ODA-08

## Overview
Mevcut oda, kişisel akçeyle rahat yatak, donanım askılığı ve muhafız kütüphanesiyle geliştirilir. Tek optional oda_gelisimi kaydı kişisel yorgunluk ve günlük/gecelik makbuzları tutar; köylü nöbet yorgunluğu ve beş köy statı aynıdır.

## Player Fantasy
Muhafız kazancını kendi dinlenme alanına yatırır; dinlenmiş halde sorguya döner.

## Detailed Rules
Başarılı normal muhafız kararları +2 yorgunluk, gece başlangıcı +10. Engellenmiş karar yük eklemez; tüccar ticaret API'si bu normal karar/tecrübe akışına girmez. Yorgunluk0–100. Yatak20, askılık15, kütüphane25 kişisel akçe; askılık/kütüphane yatak gerektirir. Her geliştirme bir kez alınır; ödeme yorgunluğu sıfırlar. Gece pasif dinlenme yatak5, askılık10, kütüphane15; toplam aynı yüke uygulanır. Bunlar kaynakta sayı olmadığı için dış JSON denge varsayımlarıdır.

Yatakta dinlenme, yorgunluk varsa aynı gerçek gün bir kez ücretsiz sıfırlar. Zaman atlatmaz; aynı gün yeni kararlarla yorulunca tekrar kullanılamaz. Ertesi gün tekrar açılır. Odaya girip çıkmak dinlenme değildir. Oda durakladığında alttaki köy simülasyonu değişmez. Aynı panel yeniden çizilir; alınan kutular çoğalmaz. Mevcut yatak renk değiştirir; askılık ve kütüphane kutuları tek JSON konumundan eklenir.

## Formulas
Etkin sorgu tecrübesi=max(0,kazanılmış tecrübe−floor(yorgunluk/20)). Mevcut ChrSorgusu olasılık hesabı kullanır; gerçek muhafiz_tecrubesi veya CHR Resource silinmez/değişmez. Gece yorgunluğu=clamp(eski+10−toplam dinlenme,0,100); aynı son_gece tekrar işlenmez. Alım bedeli yalnız kişisel keseden bir kez.

## Edge Cases
Eski kayıt boş oda ve sıfır yorgunluk. Bozuk/sınır dışı sayaç/yabancı/önkoşulsuz geliştirme elenir. JSON alım/son_gece/son_dinlenme korur, reload günlük bedava dinlenmeyi sıfırlamaz. Terminalde alım/dinlenme/yorgunluk yükü yok. Geliştirme kişisel suç geçmişini, kamu stok/para/RNG veya köylü nöbet makbuzunu değiştirmez. Alt oda listesi kaydırılır; Köye dön sabittir. KAP-01/02/03 ve CSV aynı kalır.

## Dependencies
MuhafizOdaGelisimi helper, data/oda_gelisimi.json. Oturum karar/gece/kayıt ve ChrKapiAdaptoru etkin tecrübe için ince bağlantılar. OdaGelistirmePaneli aynı oda listesi ve mevcut MuhafizOdasi._kutu; OdaKasasiPaneli ve aynı yetenek paneli ödeme sonrası yenilenir. koy_halk_hareketi değiştirilmedi.

## Tuning Knobs
karar_yorgunluk/gece_yorgunluk/yorgunluk_azami/tecrube_ceza_aralik; üç geliştirmede bedel/dinlenme/önkoşul. Yatak renk, diğer kutularda etiket/boyut/konum/renk aynı JSON. Asset üretilmedi/indirilmedi; ODA08-YATAK/ASKILIK/KUTUPHANE envanter G'de, değişim noktası OdaGelistirmePaneli.gorsel.

## Acceptance Criteria
Gerçek karar yükü ve engellenmiş karar, kişisel ödeme/önkoşul/çift alım, günlük dinlenme/tekrar/ertesi gün, gece pasif yük/tek makbuz, JSON/legacy/sınırlar/terminal. Gerçek oda düğmeleri ve üç kutu, aynı panel/tek model, gerçek CHR etkin olasılığının dinlenince düzelmesi; kazanılmış tecrübe/kamu/stok/RNG korunması. Native/ayna ve genel gece/kayıt/kapı regresyonu.
