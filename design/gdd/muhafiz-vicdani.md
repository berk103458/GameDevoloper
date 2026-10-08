# Vicdan ve kabuslar — ODA-09

## Overview
Gerçek kapı retleri ve gece ölüm raporu tek kişisel vicdan makbuzuna bağlanır. Aynı sabah raporunda kabus anlatısı, aynı odada açıkça rüya diye etiketlenen kutu gölgesi gösterilir. Yeni köy statı/Clue/kimlik motoru yoktur.

## Player Fantasy
Muhafız kapı dışında kalanların ve köyde kaybedilenlerin ağırlığını hisseder; yatağa çekilmesi geçmiş kararları silmez.

## Detailed Rules
Mevcut KoyYonetimi.ret'in kullandığı aynı not Gelen.kusurlu() ölçütüyle ret/el koyma haksız sayılır ve yük30 artar. Başka etik sınıflandırma icat edilmez. Engellenmiş karar çağrıya ulaşmaz. Gerçek r.olenler dizisi her kayıp için yük20 ekler; ölüm nedeni muhafıza isnat edilmez, ad/kimlik/ipucu kopyalanmaz. Her gerçek gece yük5 azalır. Son yük en az40 ve köy terminali yoksa kabus oluşur; mevcut oda yorgunluğuna10 eklenir. Değerler kaynakta sayı verilmediği için JSON denge varsayımlarıdır.

Kabus kutusu yalnız son gece sonrası gerçek günün odasında görünür; etiket ve açıklama bunun rüya olduğunu söyler. Ertesi gün eski kutu görünmez; yeni kabus varsa yeni gece makbuzu geçerlidir. Gündelik rüya bilgisi suçlamaya veya Divan kanıtına dönüşmez. Oda açma/kapama kaynak, kasa, RNG ve Clue değiştirmez.

## Formulas
Yük=clamp(eski+30×haksız ret+20×gece ölümü−5,0,100). Gece no=r.gun+1; son_gece tekrar korur. Aktif rüya: son_kabus==o.gun ve terminal boş. Kabus yorgunluğu aynı MuhafizOdaGelisimi alanına eklenir, ikinci ceza motoru yoktur. Tarihsel ret/ölüm toplamları geri azalmaz; yorgunluk giderilse de karar geçmişi kalır.

## Edge Cases
Eski kayıt sıfır vicdan ve−1 gece; bozuk/sonsuz/negatif sayaçlar elenir. Tek gece tekrar ek yorgunluk/zar/olay yaratmaz. Temiz gecede kabus yok. Ölüm köyü bitirmişse kabus oynatılmaz ama gerçek kayıp toplamı kayıtlıdır. Mevcut teftiş aynı gece terminal üretirse oda rüyası açılmaz. JSON makbuz ve günü korur. Tüccar ayrı karar API'si normal ret akışına girmez. Geçmiş suç kararı/adalet/terazi değişmez; rüya gerçek kişinin suçunu ifşa etmez.

## Dependencies
MuhafizVicdani helper, data/muhafiz_vicdani.json. Oturum karar/gece/kayıt için ince çağrılar; IflasYoneticisi aynı typed rapor metni. MuhafizOdaGelisimi.yor aynı kişisel alanı kullanır. OdaVicdanPaneli mevcut oda listesi ve MuhafizOdasi._kutu. KoyEkrani, koy_halk_hareketi, CSV/CHR/kilitli KAP değişmez.

## Tuning Knobs
ret_yuk/olum_yuk/gece_sonum/kabus_esigi/kabus_yorgunluk/yuk_azami; golge boyut/konum/renk/etiket. Asset üretilmedi/indirilmedi; G ODA09-KABUS modeli için tek kutu yer tutucu yolu kayıtlı.

## Acceptance Criteria
Gerçek masum/tehlikeli ret ve engellenmiş kabul, tam gerçek gece ölüm dizisi, tek yük/yorgunluk/gece makbuzu, JSON/gün/legacy/temiz gece. Aynı oda kutusu açık rüya etiketli, sonraki gün yok, source/Clue/kasa/RNG unchanged. Native/headless/ayna ve genel kayıt/kapı/gece/oda regresyonu.
