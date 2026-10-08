# Teftiş save/state sözleşmesi — ODA-13

## Overview
Mevcut tek kayıt servisi üzerinden yüklenen state gerçek teftişin kaynağıdır. Başka slotların serveti/suçu güncel oturuma aktarılmaz; çoklu slot oyunu veya geçmiş disk taraması icat edilmez.

## Player Fantasy
Kasayı kapatmak ya da oyunu kaydedip yeniden açmak muhafızın kişisel servetini ve suç makbuzunu gizlemez.

## Detailed Rules
src/koy/guvenli_kayit.gd.oku sağlam ana JSON veya mevcut yedeğini verir. Oturum.kayittan aynı muhafiz_akce/muhafiz_esyalari ve rüşvet/zimmet/haraç/haksızlık kaynağını yükler. SancakTeftisi.gece yüklenen oturumun SancakTeftisi.kasa ve MuhafizTerazisi.durum değerlerini okur. Diğer kayıt dosyalarını enumerasyonla suç kaynağına karıştırmaz.

## Formulas
ODA07 aynı ilk6/her5 gece, gerçek kişisel nakit/pozitif eşya kaydı ve yozlaşma eşiği. Kaydedilmiş sancak_teftisi.son_gece tek tekrar makbuzu; terminal reload yeni zar atmaz. Ana kayıt bozuksa GuvenliKayit aynı slotun yedeğini okur; terminal henüz kaydedilmemiş eski state geçerli yüklenince o state'in gerçek sıradaki gecesi değerlendirilir.

## Edge Cases
İki izole slot testi: kirli/kişisel kasa olan yüklenen oturum azil, meşru zengin olan ayrı oturum temiz. Okuma diski veya verilen sözlüğü değiştirmez. Gerçek oyun savegame dosyasına test dokunmaz. Önceki slotun suçu başka oyuncuya taşınmaz; kayıt sıfırlayıp oynama yeni oyundur. Sahte _yedekten metası ceza alanı değildir.

## Dependencies
Mevcut GuvenliKayit/AtomikJsonKaydi/Oturum.kayittan/SancakTeftisi; yeni üretim helperi veya kayıt şeması gerekmedi. Yeni tests/unit/kvr/sancak_kayit_slotu_test.gd iki gerçek geçici dosya ve tam gece üzerinden sözleşmeyi denetler. ODA07 canlı kasa kontrolü bu yüklenen state'i zaten kullanmaktadır.

## Tuning Knobs
Yeni sayı yok; mevcut data/sancak_teftisi.json. Asset gerekmedi, G kontrol edildi.

## Acceptance Criteria
İki slot, gerçek atomik yaz/oku, dolu kasa ve suç makbuzunun tam gece sonucu, meşru slot ayrımı, disk/source purity, terminal JSON tekrar, bozuk ana/yedek tam gece. Mevcut atomik kayıt/teftiş birimleri ve gerçek teftiş UI, import/korumalı API regresyonu. Test alt dizini kapanışta temizlenir.
