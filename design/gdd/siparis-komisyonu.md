# Sipariş muhafız komisyonu — TUC-13

## Overview
Mevcut sözleşme defterinde normal kamu tesliminin yanında %10/%20 kişisel komisyonlu teslim seçilir. Yeni sözleşme veya para sistemi yoktur.

## Player Fantasy
Muhafız zanaat siparişini teslim ederken ödülün bir kısmını kamu gelirinden kendi kesesine ayırır.

## Detailed Rules
Komisyon mevcut KasaTransferi zimmet kaydından geçer: günde tek zimmet, en çok 10 akçe, Adalet -5, Asayiş +5 ve yaşayan köylülerde Moral -3. Önceden pazar satışı/zimmet yapılmışsa komisyon düğmesi kapalıdır; komisyon da diğer zimmet yollarını aynı gün kapatır. Normal komisyonsuz teslim korunur. Tam ürün ve vade koşulları mevcut SiparisTeslimati tarafından denetlenir, itibar bir kez +10 olur. Tüccarın kapıda olması gerekmez.

## Formulas
Komisyon = floor(ödül × oran / 100). Net kamu = ödül - komisyon. Sıfır tutarlı komisyon kabul edilmez. Ön denetimde tam ödül sonrası kamu bakiyesi, kişisel taşma, günlük sınır ve birikimli zimmet kontrol edilir. Stok/ödül/transfer aynı yieldsiz işlemde gerçekleşir.

## Edge Cases
Eksik stok, vade, bitmiş oyun, kasa taşması veya zimmet sınırı kasaları/defteri/stoku değiştirmez. İkinci tıklama ödül/itibar/komisyon vermez. Negatif kamu bakiyesi tam ödülle karşılandıktan sonra yeterli net kasa kalıyorsa komisyon yapılabilir. Makbuz komisyon_orani/komisyon olarak aynı siparişte saklanır; bozuk veya donmuş ödülle uyuşmayan makbuz yüklenmez. Eski normal teslim kayıtları yeni alan gerektirmez.

## Dependencies
SiparisKomisyonu ve SiparisKomisyonPaneli yeni dosyalardır. Mevcut teslim panelinde tek çağrı, mevcut sipariş alan loaderında tek çağrı. KasaTransferi.gelir_uygun isteğe bağlı tam kamu geliri parametresi alır; mevcut satış çağrılarının davranışı korunur. Çekirdek Oturum/koy_ekrani ve halk hareketi değiştirilmez.

## Tuning Knobs
data/siparis_komisyonu.json izinli oranlar; mevcut data/koy/kasa_transferi.json günlük sınır ve sosyal bedelleri belirler. Yeni asset gerekmedi; envanter G tablosunda yeni ihtiyaç yok, üretim/indirme yapılmaz.

## Acceptance Criteria
Gerçek %20 düğmesi 24 ödülü 20 kamu/4 kişisel olarak böler; tek stok/itibar ve okunur makbuz verir. Model testleri %10, yanlış oran, günlük sınır, negatif kamu, taşma, kayıt dönüşü, eksik stok, normal teslim ve ikinci tıklamayı sınar. İlgili kasa/ticaret/kayıt/snapshot/iflas/UI ve 20 gece regresyonları geçer.
