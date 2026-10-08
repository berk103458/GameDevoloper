# Tekfur haraç heyeti — HAR-03

## Overview
Mevcut KoyYonetimi haraç döngüsü ve KoyEkrani haraç bandı genişletilir. Ayrı heyet kuyruğu, ikinci HUD veya savaş motoru yoktur.

## Player Fantasy
Muhafız Tekfur heyetinin kamu kasası ve buğday talebini karşılar veya surlarına güvenerek reddeder.

## Detailed Rules
Ağalık açıldıktan sonra mevcut gerçek gece sayısı her altı gecede bir bekleyen talep oluşturur. Eski 10 akçe / 20 miktarı korunur; gıda yerine buğday gerekir. Altın talebi mevcut kamu akçesi ekonomisini kullanır, ikinci para birimi açılmaz. Ret veya sonraki gece cevapsız kalması mevcut tekfur_baski sayacını bir artırır. Mevcut baskın/savunma/zafer formülleri korunur.

## Formulas
Vade: (gun+1) mod max(1,harac_araligi)=0. Varsayılan harac_araligi=6. Ödeme: kamu akçesi >= harac_akce ve buğday >= harac_gida ise ikisini aynı işlemde düş, harac_bekliyor=false. Legacy Resource alan adı harac_gida buğday miktarını taşır; özel Resource denge ayarları korunur. Runtime ikinci vade/ödendi defteri oluşturmaz.

## Edge Cases
Eksik tek kaynakta tüm durum değişmeden reddedilir; gıda veya kişisel kese ödeme yerine geçmez. Tekrarlı tıklama ve JSON sonrası yeniden ödeme yapılamaz. Terminalde ödeme yok. Önceki kayıt bekleyen haraç alanını korur ve yeni talebi buğday olarak gösterir. Ağalık öncesinde talep yok; otomatik oyuncu aynı harac_ode API'sini kullanır. Heyet altıncı tamamlanan gecede gelir; UI mevcut bir tabanlı gün gösterimini korur.

## Dependencies
TekfurHaracHeyeti model helper, TekfurHeyetiPaneli mevcut bantta tek kur çağrısı. KoyYonetimi ödeme/raporda ince adapter, KoyAyarlari export ayarı, IflasYoneticisi typed metin. Oturum/CSV/CHR/koy_halk_hareketi değişmez; kayıt sürümü ve eski ödeme/ret API imzaları korunur. Haraçsız isyan satırı node üretmez, boş satır sızıntısı giderildi.

## Tuning Knobs
KoyAyarlari harac_araligi/harac_akce/harac_gida; dış JSON insan talep metni ve tek ColorRect görünümü. Asset üretimi/indirme yok. Gerçek heyet simgesi HAR03-HEYET olarak envanter G tablosundadır; tek panel helper ve dış JSON üzerinden değiştirilebilir.

## Acceptance Criteria
5/6/12 gerçek gece, ödeme/eksik akçe/eksik buğday/ret/cevapsız/terminal/JSON/tekrar ve kişisel kese/gıda/RNG koruması. Tam Oturum gecesi typed rapor; gerçek KoyEkrani düğme, eksik stokta disabled, tam ödeme ve yüklenen kayıtta ret. Headless/native görüntü, köy/kayıt/kapı/gece regresyonu ve ds aynası.
