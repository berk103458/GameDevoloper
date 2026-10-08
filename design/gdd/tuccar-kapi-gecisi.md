# Tüccar kapı geçişi — TUC-12

## Overview
Mevcut gezgin takvimindeki uzman kapı kuyruğunun önüne gelir. Resmi bac veya kişisel rüşvet pazarı açar; ret bu konaklamayı kapatır.

## Player Fantasy
Muhafız kamu kaydı ile kendi kesesine hızlı giriş bedeli arasında açık tercih yapar.

## Detailed Rules
Bir ziyaret, bir makbuz. Resmi bac 5 kamu akçesi; hızlı giriş 8 kişisel akçe, Adalet -5 ve Asayiş riski +5. Tüccar nüfusa eklenmez. Pazara kabul karar anında modelde açılır; diğer kapı ziyaretçileri atlanmaz, yönetim ekranı mevcut gece akışıyla açılır. Normal/CHR kuyruğu ve diyaloglar korunur. Bekleyen veya reddedilen uzman genel alış/satış, hayvan, özel stok, karaborsa ve sipariş teklifine erişemez; eski sipariş teslimatı ayrı defter sözleşmesidir.

## Formulas
Kamu += bac OR kişisel += rüşvet; risk/stat 0–100 sınırında. Makbuz anahtarı mevcut takvimin gelis_gunu ve uzman id değeridir. Takvim veya RNG yaratılmaz.

## Edge Cases
İkinci konaklama günü/yükleme ikinci tahsilat yaratmaz. Bekleyen kayıt ziyaretçiyi yeniden kurar. Ret sonraki ziyaret için engel değildir. Borç ambargosu kapı rüşvetiyle atlanamaz. Sahte/eski ziyaret, bilinmeyen karar, bitmiş oyun veya taşan kasa değişiklik yapmaz. Eski alanı olmayan kayıt tarihi takvim erişimini korur.

## Dependencies
TuccarKapiGecisi, mevcut Oturum.gece_kuyrugu/karar_ver ve KoyYonetimi kayıt alanına ince adaptörlerle bağlıdır. KapiEkrani karar satırları TuccarKapiPaneli kullanır; mevcut pazar durum satırı bekleme/ret bilgisini gösterir. Çift HUD veya köylü kabul yolu kullanılmaz.

## Tuning Knobs
data/tuccar_kapi_gecisi.json bac/rüşvet ve sosyal bedelleri belirler. Mevcut esnaf görünümü kullanılır; asset gerekmedi. Asset üretilmedi veya indirilmedi; G tablosuna yeni ihtiyaç yok.

## Acceptance Criteria
Gerçek kapı düğmesi tek tahsilat, ayrı kasalar ve sabit nüfus üretir. Model testi kayıt, ret, bekleme, tekrar ve sahte ziyaret durumlarını sınar. Genel test paketi mevcut CHR, çift kasa, sipariş, tüccar ve 20 gece akışını denetler.
