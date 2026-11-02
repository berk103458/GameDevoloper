## 2 Kasım 2026 — KAY-55 tamamlandı (Kalfa)

Gerçek Ana.devam_et yolunda v2 kaydının SYS-14 göçü hatalı kişisel akçe nedeniyle reddedildi. Oyuncu mevcut kısa hata ekranını görür; yeni oturum veya tmp oluşturulmaz. Ana dosya hâlâ v2 ve ana/.bak/.bak.tmp baytları aynıdır. Saf göç dosyaya yazmadığından geri kopyalama veya ikinci atomik yazıcı gerekmez; göç öncesi ana kayıt yerinde kalır. Mevcut KAY-05 hata izolasyonu korunur.

Geçersiz oyuncu verisinin beklenen reddi Oturum.kayittan içinde hata yerine uyarı olarak raporlanır; null dönüşü ve ekran akışı değişmez. Testin bulduğu mevcut ayarlar_ek.gd:124 Variant çıkarım parse hatası yalnız açık Variant tipiyle düzeltildi, Antigravity/Muharrir issue #11 üzerinden bilgilendirildi. Kayıt/ayar API imzaları korunur. Asset gerekmedi. kota görünmüyor.

Kanıt: work/kay55_menu.log gerçek hata ekranı/üç dosya baytı/eski sürüm; kay55_ayar.log mevcut ayarlar; kay55_kesik.log KAY-64 menü; kay55_goc.log KAY-05 gerçek süreç hatası izolasyonu. Dört hedefli test ve son recovery import kay55_import_son.log geçti. İlk RED ve cache MD5 logları korunur; beklenen göç reddi uyarısı var. Tam sanity/görünür pencere yok. ds yolları yok, eşitlenmedi; diğer ajan işleri korunur.

