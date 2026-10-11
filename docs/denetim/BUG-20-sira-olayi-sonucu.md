# BUG-20 — Sıra olayının gerçek sonucu (Kalfa)

`sonuclar.json` ölüm %15, sakatlık %25, ayrılma %25, toparlanma %35 ve sakat kabul sağlık 35 değerlerini taşır. Yardım mevcut kartın 1 erzak bedelini gerçek stoktan düşürür; kaynak yoksa gerçek UI düğmesi kapalı, doğrudan yardımcı çağrısı da atomik ret. Çift seçim ve aynı kişinin yeniden bayılması ücret, rapor, ölüm veya RNG tekrarı üretmez.

Seçilen gerçek modelin aynı indeksindeki `Gelen` nesnesi sonuç makbuzunu taşır. Ölen/ayrılan kişi mantıksal ve görsel sıradan çıkar; adlı kimlik mevcut kadroda kalıcı ayrılmış olur. Kabul API'si bu nesneyi engeller. Sakat/toparlanmış kişi ayağa kalkar ve sırada kalır; sakat nesne kabul edilirse gerçek köylü sağlık 35 ve açık sakatlık işaretiyle girer. Yeni kişi listesi yok. Paylaşılan olay `.tres` kaynağı değiştirilmez.

Optional gece raporu kaydı yükleme sonrası da korunur. Sağlık taramasından sonra bir kez tüketilir, ölüm adı mevcut `olenler` listesine eklenir; zaten duran `CenazeYasi.gece` çağrısı bir kez cenaze/yas açar. İkinci cenaze akışı veya sahte köylü üretilmez. Kapı debug anlık görüntüsü aynı Gelen'in sonuç makbuzunu korur. Eski/eksik alan boş kabul edilir.

Birim test: 1000 tohumlu zar 149/265/258/328; her sapma yüzde3'ün altında. Dört sonuç ayrı veri ayarıyla, gerçek kabul, kaynak/çift seçim, rapor tüketimi, pending JSON ve Gelen snapshot dönüşü, KRI-05 tek cenaze, ertesi gece yeni ölüm olmaması denetlenir. Gerçek UI testi beş sonuçta canlı düğmeye basar; model hareketi/çıkarılması, kaynak kilidi, metin, kabul sağlığı ve raporu doğrular. 17 hedefli kontrol 0 hata: CSV/Python/kaynak/API/import, yeni kişi/sonuç, kapı kararı, cenaze, gece bilançosu, snapshot birimleri; gerçek sonuç/sıra/cenaze/admin snapshot ve iki kriz sahnesi. Nihai tek tam UTF-8 sanity: 338 PASS / 0 hata / 20 gece; loglar `work/sanity-bug20-final`.

Asset gerekmedi; mevcut model ve cenaze yer tutucusu kullanılır. `res://work` test yolu yok; aynı anda tek tam sanity. ds ayna yolu bu bilgisayarda yok, eşitlenemedi. Başka ajanın sahipliği ve arşiv klasörü değişmedi.

Festive entegrasyonu: f4c19bc sonrası yeni asset kuralı ve BUG-23 tarla çalışması çakışmasız merge edildi. Sonraki 10 hedefli kontrol geçti: CSV/kaynak/API/import, tarla ve kişi/sonuç birimleri, gerçek sıra sonucu/navigasyon/köylü takip sahneleri. 338 kontrol tam koşusu merge öncesi uygulamaya aittir; son festive'nin tümüne yeni tam koşu iddiası yok.
