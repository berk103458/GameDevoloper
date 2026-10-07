# Gece bilançosu — EKO-15

## Overview
`Oturum.gece_sonu()` mevcut alanlarını korur; yeni `bilanco` sözlüğü gerçek açılış/kapanışı ve rapor hareketlerini açıklayan salt okunur bir adaptördür.

## Player Fantasy
Oyuncu ve rapor tüketicileri kasanın/stokların gerçekten neden değiştiğini, kamu ile kişisel parayı karıştırmadan inceleyebilir.

## Detailed Rules
`bilanco.surum=1`, gun; kamu ve kisisel once/sonra/net. Kamu maaşı yalnız gerçek yeni bordro ödemelerini (eski borç dahil), vergi yalnız gerçekleşen rapor olayını içerir; ödenmeyen ücret nakit gider değildir. Kamu diger_net bonus satışı/haraç vb. geriye kalan gerçek net harekettir, ayrı brüt gelir iddiası yoktur.
Her ambar türünün açılış/kapanış/neti; ambara gerçekten giren uretim, gerçek tuketim, bozulma, tasma_bildirimi ve tasma_gece; diger_net girdiler, hırsızlık, sabotaj, baskın, alet kullanımı vb. kalan net stok hareketidir. Bilinmeyen hareketlere sahte kesin sebep verilmez.
Gündüz zaten düşülen taşma gece bildirilse de gece stok kaybı olarak tekrar sayılmaz. Gece iflas el koymasından oluşup ertesi gece bildirilecek taşma ise gerçek oluştuğu gece kayıp sayılır. Kişisel kasa ayrı ve gözlemlenmiş netle verilir. Alet aşınması açılış/kapanış; transfer_ozeti ömür boyu kayıtlı transfer toplamlarıdır, bu gece gelir değildir.

## Formulas
Kamu net = vergi − maaş + diger_net. Stok net = üretim − tüketim − bozulma − tasma_gece + diger_net. tasma_gece = bildirilen taşma + kapanış bekleyen taşma − açılış bekleyen taşma. once/sonra gerçek fotoğraflardır.

## Edge Cases
Boş köy, negatif kamu, maaş borcu, aynı gece bordro koruması ve restore aynı gerçek sonuçları üretir. Kopya raporun değiştirilmesi canlı stoğu değiştirmez. Adaptör RNG, kasa, stok veya kayıt formatını değiştirmez; yeni bir ekonomik hesaplaşma çalıştırmaz.

## Dependencies
GeceBilancosu, Oturum.gece_sonu, mevcut KoyYonetimi raporu, MuhafizMaasi bordro, VergiPolitikasi olayı, AmbarBakimi pending taşma, EKO-14 transfer özeti. İnce adaptör yalnız Oturum'da iki satır; CSV/ikinci HUD yok.

## Tuning Knobs
Yeni oyun denge sabiti yoktur; gerçek model değerleri kullanılır. Şema sürümü teknik sözleşmedir.

## Acceptance Criteria
Gerçek gece testi: kamu/kişisel mutabakat, tüm stoklar, haftalık vergi, ödenmeyen ücret/eski borç ödemesi, gündüz taşmasının tekrar gider sayılmaması, JSON restore, salt okunur fotoğraf/hesap ve rapor kopyası. Import, kaynak API denetimi, köy/kapı regresyonu ve izole 20 gece geçer.
