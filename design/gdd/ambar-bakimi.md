# Ambar bakımı — EKO-12

## Overview
Tek ortak ambar sınırı kapasite küçülmesinde ve kayıt yüklemesinde korunur; tüketimden sonra kalan gıda gecelik bozulur.

## Player Fantasy
Depo yıkımı ve gereksiz gıda biriktirme artık gerçek stok kaybıdır. Mevcut ambar ipucu ve gece olayları sebebi açıklar.

## Detailed Rules
Kapasite negatife düşmez. Kapasite küçülmesi fazla stoğu hemen çıkarır; önce gıda, ardından dış JSON sırası uygulanır. Başlangıç/kayıt stokları da sınıra uyar. Kaybın bekleyen raporu kayıtla korunur. Üretimin mevcut sığan miktarı ve kritik bonusun satış davranışı korunur. Üretilemeyen ürün ayrıca ziyan sayılmaz.
Her gece tüketimden sonra kalan gıdanın %2'si bozulur. Bireysel ürün yaşı/FIFO takibi yoktur; aynı gece üretilmiş fakat tüketilmemiş gıda da kapanış stoğuna dahildir. Taş ve diğer malzeme bozulmaz. Ziyan para veya RNG tüketmez; tüketim raporundan ayrı `ziyan.tasma/bozulma` sözlüğüne yazılır.

## Formulas
H = kalan gıda × oran + önceki kesir; kayıp = floor(H), sonraki kesir = H − floor(H). Boş stok kesri sıfırlar. Fazla = max(0, toplam − kapasite); sıralı türlerden fazla bitene kadar çıkarılır.

## Edge Cases
Aynı gün bakım tekrar çalışmaz. Eski kaydın optional geçmişi sıfırdan açılır; yanlış tür, negatif/sonsuz kesir ve tarih reddedilir. Negatif stok sıfırlanır. Bekleyen kapasite kaybı ve kesir restore sonrası tek kez raporlanır. Kamu/kişisel kasalar korunur.

## Dependencies
Kaynaklar, KoyYonetimi.gece, mevcut Hud, IflasYoneticisi olay metin adaptörü. SYS-09 kilidi nedeniyle CSV değişmez.

## Tuning Knobs
`data/koy/ambar_bakimi.json`: gecelik_bozulma ve tasma_sirasi. Yeni ambar türü eklenirse taşma sırasına da eklenir.

## Acceptance Criteria
Birim testinde kapasite daralması, eski/bozuk kayıt, kesir birikimi, aynı gün koruması ve bozulmayan taş doğrulanır. Gerçek Ana/Hud senaryosu gecelik rapor, kasaların korunması ve restore deterministiğini doğrular. Headless import, tüm birim/UI senaryoları ve izole 20 gece duman testi geçer.
