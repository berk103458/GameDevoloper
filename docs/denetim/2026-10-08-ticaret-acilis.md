# Ticaret paketleri ve önbelleksiz açılış — 8 Ekim 2026

Codex, festive. ANI-11…15 ve TUC-01…10 yayımlandı. Denetlenen yalnız commitli snapshot: `fc98a7c`, Godot 4.7.2 ed1daf0bf; git archive ile `.godot` ve untracked kaynaklar alınmadan yeni dizine açıldı.

İlk editor/import çıkışı script/parse hatası üretmedi (`SCRIPT ERROR` sıfır), ancak 104 resource hata satırı vardı: başlangıçta henüz üretilmemiş `data/metin/metinler.tr.translation` ve glTF'nin çıkardığı `*_Image_0.jpg` yolları. Bunlar bu ortamda ilk import sırasında oluşan çıktılardır; yeni asset tasarlanmadı/indirilmedi. İlk import sıfır hata diye raporlanmaz.

Aynı temiz kaynakta ikinci headless editor/import sıfır hata geçti. Ardından `tests/oto/acilis_bagimlilik_kontrol.tscn` headless ve native çalıştırıldı: gerçek Ana/Ses ve bütün listelenen bağımlılıklar, gerçek menü, Katalog HAZIR ve runtime input/efekt havuzu geçti. Böylece oyun açılışı için untracked Codex kaynak dosyasına gereksinim yoktur. İlk cold import materializasyonu tamamlandıktan sonra yeniden import gerekebildiği kayıt altındadır; Ahmet'in makinesindeki açılışın doğrulandığı iddia edilmez.

Yerel kanıtlar (scratch): work/fc98a7c_clean_import.log, fc98a7c_clean_second_import.log, fc98a7c_clean_menu.log, fc98a7c_clean_native_menu.log. Temiz kaynak dizini work/clean_fc98a7c. Kullanıcı save dosyasına veya CSV kaynaklarına müdahale edilmedi.

TUC-11 ayrıca kendi import/birim/gerçek UI, native oda ve ds ayna import/UI kontrollerinden geçer; makbuz alanları mevcut kişisel eşya loaderında tek adaptörle normalleştirilir. Yeni ikon ihtiyaçları envanter G TUC11-MUHUR/IKSIR satırlarıdır.

Ahmet yolu C:\Users\Ahmet\Desktop\Cursor_All_DAta\Kapı_Muhafizi bu makinede yoktur. İki ds checkout eşitlenir; Muharrir festive güvenli pull sonrası kendi yerel kontrolünü yapmalıdır.

## TUC-12 / 6904f14 yalnız commitli kontrol
Git archive 6904f14 ile .godot/untracked içermeyen yeni kopya. İlk import: 104 resource hata satırı, sıfır SCRIPT ERROR; önceki çeviri/glTF materializasyon sırası aynı. İkinci import sıfır hata. Headless ve native tests/oto/acilis_bagimlilik_kontrol.tscn gerçek Ana/Ses/menü ve bağımlılık kontrolü geçti. Yerel kanıt work/tuc12_clean_first.log, tuc12_clean_second.log, tuc12_clean_menu.log, tuc12_clean_native_menu.log. İlk import hatasız diye sunulmaz; Ahmet kopyası erişilemiyor.

## TUC-14 / 04f9896 yalnız commitli kontrol
Git archive 04f9896 ile .godot/untracked içermeyen kopya. İlk import 104 resource hata satırı ve sıfır SCRIPT ERROR: bilinen çeviri/glTF materializasyon sırası. İkinci import sıfır hata; headless/native gerçek Ana/Ses/menü bağımlılık testi geçti. Kanıt work/tuc14_clean_first.log, tuc14_clean_second.log, tuc14_clean_menu.log, tuc14_clean_native_menu.log. İlk import hatasız diye sunulmaz; Ahmet yolu erişilemiyor.

## TUC-15 / 8b8950c yalnız commitli kontrol
Git archive 8b8950c ile .godot/untracked içermeyen kopya. İlk import 104 resource hata satırı ve sıfır SCRIPT ERROR: bilinen çeviri/glTF materializasyon sırası. İkinci import sıfır hata; headless/native gerçek Ana/Ses/menü bağımlılık denetimi geçti. Kanıt work/tuc15_clean_first.log, tuc15_clean_second.log, tuc15_clean_menu.log, tuc15_clean_native_menu.log. İlk import hatasız diye sunulmaz; Ahmet yolu erişilemiyor.

## MEV-05 / 237786a yalnız commitli kontrol
Git archive 237786a, .godot/untracked yok. İlk import bilinen 104 resource hata satırı, sıfır SCRIPT ERROR; ikinci import sıfır hata. Headless/native gerçek Ana/Ses/menü geçti. Kanıt work/mev05_clean_first.log, mev05_clean_second.log, mev05_clean_menu.log, mev05_clean_native_menu.log. Ahmet yolu erişilemiyor; ilk import hatasız diye sunulmaz.
