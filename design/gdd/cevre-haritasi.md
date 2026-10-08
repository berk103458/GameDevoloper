# Şematik çevre haritası — HAR-01

## Overview
Mevcut köy eylem grubundaki Harita düğmesi tek salt okunur modal açar. Dört veri ayarlı bölge: Taşlık Hisar, Karaboran, Tekfur Hisarı, göç yolları. İkinci HUD, köy ekonomisi veya diplomasi motoru yoktur.

## Player Fantasy
Muhafız kendi kapısını çevredeki hisar ve geçiş yollarıyla birlikte görür; hangi dış bölgeyi inceleyeceğini seçer.

## Detailed Rules
Şematik kutular ve yol çizgileri dış JSON üzerinden yerleşir; gerçek coğrafya/mesafe iddiası yok. Bölge seçimi aynı sağ bilgi alanını yeniler. Hisar gerçek gün/nüfus; Tekfur gerçek tekfur_baski/savusturulan değerlerini okur. Karaboran ve göç yolları yalnız bölge açıklamasıdır; HAR02–15 henüz mekanik değildir, gelecekteki sayaç/olasılık uydurulmaz.

## Formulas
Nokta merkezi=(x×alan genişliği,y×alan yüksekliği), kutu yarım boyutu çıkarılır. Yol aynı merkezler arası düz renk şerit. CevreHaritasi.bolgeler derin kopya verir, bilgi(Oturum,id) saf okuma. Zaman/maliyet/RNG formülü eklenmedi.

## Edge Cases
Gece kilidi, mevcut olay/divan/oda/harita veya terminal varken açılmaz. Harita açıkken oda/divan da açılmaz. Esc ve Köye dön aynı modalı kapatır; önceki 0/1/2/3 hız ve duraklama geri gelir. Köy kamera/kişisel kasa/ambar/Clue/kayıt/RNG değişmez. Bilinmeyen bölge son geçerli seçimi korur, null oturum model boş döner. Bilgi alanı kaydırılır ve mevcut yazı ölçeği kullanılır.

## Dependencies
CevreHaritasi + data/cevre_haritasi.json, HaritaEkrani, HaritaBaglantisi. KoyEkrani yalnız tek kur çağrısı; DivanBaglantisi/MuhafizOdasiBaglantisi yalnız yeni modal guardı. KoyHalkHareketi, Oturum, CSV/CHR değişmez. Mevcut Tema/Ayarlar kullanılır.

## Tuning Knobs
JSON bölge etiket/açıklama/renk/oransal konum, yol uçları ve kutu boyutları. Asset üretimi/indirme yok. Envanter G HAR01-HARITA: gelecekteki çizim için tek HaritaEkrani yer tutucu yolu; bugün düz renk kutular ve şeritler.

## Acceptance Criteria
Dört bölge/unknown/null/source kopya/JSON/saf okuma birimi. Gerçek köy düğmesi, dört gerçek pressed seçimi, karşılıklı modal koruması, P/1 giriş bloklama, Esc/geri ve önceki hız, olay/terminal red; kamera/kayıt/RNG değişmez. Headless/native/ayna, kutu kadrajı ve genel köy/gece/kayıt/oda/divan regresyonu.
