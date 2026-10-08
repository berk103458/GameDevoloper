# Ticaret paketleri ve önbelleksiz açılış — 8 Ekim 2026

Codex, festive. ANI-11…15 ve TUC-01…10 yayımlandı. Denetlenen yalnız commitli snapshot: `fc98a7c`, Godot 4.7.2 ed1daf0bf; git archive ile `.godot` ve untracked kaynaklar alınmadan yeni dizine açıldı.

İlk editor/import çıkışı script/parse hatası üretmedi (`SCRIPT ERROR` sıfır), ancak 104 resource hata satırı vardı: başlangıçta henüz üretilmemiş `data/metin/metinler.tr.translation` ve glTF'nin çıkardığı `*_Image_0.jpg` yolları. Bunlar bu ortamda ilk import sırasında oluşan çıktılardır; yeni asset tasarlanmadı/indirilmedi. İlk import sıfır hata diye raporlanmaz.

Aynı temiz kaynakta ikinci headless editor/import sıfır hata geçti. Ardından `tests/oto/acilis_bagimlilik_kontrol.tscn` headless ve native çalıştırıldı: gerçek Ana/Ses ve bütün listelenen bağımlılıklar, gerçek menü, Katalog HAZIR ve runtime input/efekt havuzu geçti. Böylece oyun açılışı için untracked Codex kaynak dosyasına gereksinim yoktur. İlk cold import materializasyonu tamamlandıktan sonra yeniden import gerekebildiği kayıt altındadır; Ahmet'in makinesindeki açılışın doğrulandığı iddia edilmez.

Yerel kanıtlar (scratch): work/fc98a7c_clean_import.log, fc98a7c_clean_second_import.log, fc98a7c_clean_menu.log, fc98a7c_clean_native_menu.log. Temiz kaynak dizini work/clean_fc98a7c. Kullanıcı save dosyasına veya CSV kaynaklarına müdahale edilmedi.

TUC-11 ayrıca kendi import/birim/gerçek UI, native oda ve ds ayna import/UI kontrollerinden geçer; makbuz alanları mevcut kişisel eşya loaderında tek adaptörle normalleştirilir. Yeni ikon ihtiyaçları envanter G TUC11-MUHUR/IKSIR satırlarıdır.

Ahmet yolu C:\Users\Ahmet\Desktop\Cursor_All_DAta\Kapı_Muhafizi bu makinede yoktur. İki ds checkout eşitlenir; Muharrir festive güvenli pull sonrası kendi yerel kontrolünü yapmalıdır.
