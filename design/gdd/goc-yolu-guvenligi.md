# Göç yolu güvenliği — HAR-05

## Overview
Mevcut husumet tehdidi iki gerçek etkin muhafızın aynı gün soyut yol temizliğiyle azaltılır. Başarılı temizliğin makbuzu aynı kapı kuyruğunda iki ayrı gün birer göç ziyareti hakkı verir. HAR-14 özel tüccar akışı tamamlayıcısı henüz yapılmış sayılmaz.

## Player Fantasy
Muhafız eşkıya baskısını azaltıp göç yolundaki ailelerin hisara uğramasını sağlar; kapıya gelenlerin normal sorgusu ve kabul/ret sorumluluğu sürer.

## Detailed Rules
Gerçek husumet mevcut sızma eşiğine ulaşmış olmalı. İki sağlıklı etkin nöbetçi en yüksek stat, eşitlikte ID sırasıyla seçilir. Görev aynı gün tamamlanmış soyut eylemdir; zaman atlaması, ayrı müfreze nüfusu veya ikinci savaş döngüsü yoktur. Her katılanın sağlığı5 azalır. Toplam stat>=10 başarı: husumet20, asayiş riski5 azalır, iki ek ziyaret hakkı. Başarısızlıkta asayiş3 artar, göç ödülü yok. Gün başına tek deneme.

## Formulas
MuhafizMaasi.aday/borclu ve canlı sağlık>=50, yetişkin, sağlam, uyanık, iş reddi yok; çocuk/zindan/dış kervan görevi hariç. Güç=sum(seçilen2 gerçek stat). Husumet=max(0,puan−20). Başarı asayiş=max(0,risk−5), başarısız=min(100,risk+3). Ziyaret: bekleyen>0 ve son_ziyaret<gerçek gun ise mevcut _figur_gelen ile bir ek Gelen, hakkı1 azalt. Heybe ve kararlar var olan kuyruk işlemiyle oluşturulur.

## Edge Cases
Tehdit yok, eksik etkin nöbetçi, terminal veya aynı gün tekrar varsa tüm durum değişmeden reddedilir. Duvar gücü yol müfrezesine eklenmez. Kişisel/kamu para ve görevde RNG değişmez; yeni ziyaret doğal figür üretiminin mevcut RNG'sini kullanır. Ek gelen otomatik kabul edilmez ve gizli karakter gerçeği düzeltilmez. Göç ziyaretleri farklı sınıflardan olabilir; özel tüccar artırımı HAR-14'tedir. Legacy optional boş defter; bozuk sayılar elenir, tekrar makbuzları JSON'da korunur. Yeni başarı bekleyen ziyaretleri dış JSON tavan2 ile yeniler; sınırsız ödül biriktirme yok.

## Dependencies
GocYoluGuvenligi helper/dış JSON, Oturum optional save/load ve kuyrukta heybe öncesi tek çağrı. GocYoluPaneli mevcut pazar kartında tek bağlantı; CevreHaritasi aynı göç yolu bilgi alanına salt okunur tip çağrısı. KoyYonetimi/koy_halk_hareketi/kasa/CSV/CHR kaynakları ve kayıt sürümü3 korunur. Ayrı harita eylem HUD'ı kurulmaz.

## Tuning Knobs
mufreze_adet,guc_esik,saglik_min,gorev_saglik,husumet_azalt,asayiş deltaları,goc_ziyareti ve insan metinleri dış JSON. Bunlar kaynakta adet/formül verilmediğinden denge varsayımıdır. Asset gerekmedi; envanter G kontrol edildi, mevcut pazar/harita ve normal figür varlıkları kullanılır. Üretim/indirme yok.

## Acceptance Criteria
Tehdit/etkin muhafız/gerçek sağlık bedeli/başarı/başarısızlık/terminal/JSON/tekrar/bozuk alanlar ve para/görev RNG korunur. Aynı gerçek kuyruk +1, heybe/kabul/ret, gün başına tek ziyaret ve iki gün tükenen makbuz. Gerçek pazar düğmesi, disabled/yenileme, aynı harita saf güncel bilgi ve native/headless/ayna; köy/kayıt/kapı/harita/diğer pazar regresyonu.
