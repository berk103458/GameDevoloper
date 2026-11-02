## 2 Kasım 2026 — KAY-11 tamamlandı (Kalfa)

Oturum mevcut `GrupItibari` sınıfından tek nesne taşır. `grup_itibari.kaydet()` altı puanı/yazım makbuzlarını kök kayda yazar; yükleme aynı sınıfın mevcut yükleyicisinden geçer. Eksik grup 0 olur, diğer puanlar korunur; alanı olmayan eski kayıt altı sıfır puanla açılır. Mevcut yükleyicinin −10…+10 kıskaçı korunur. Yükleme kaynak oturumu değiştirmez. İkinci itibar tablosu, yeni grup, karar motoru veya Söz şeması kurulmadı. Uygunsuz kök itibar tipi/kabul edilmeyen grup kaydı oturum yüklemesini reddeder.

Kanıt: `work/kay11_unit.log` gerçek Oturum JSON dönüşünde Türkmen −3/Rum +4, eksik Rum 0/Türkmen −3, altı grup, sınır ve eski kayıt; `kay11_eski.log` mevcut DIY-12 sınıf testleri; `kay11_goc.log` SYS-14 göç regresyonu; `kay11_bildirim.log` tek göç raporu regresyonu. Dört hedefli kontrol ve son recovery headless import (`kay11_import_son.log`) geçti. Önceki cache MD5 hatalı import logu korunur; son import temiz. Tam sanity/görünür Godot yok.

İnceleme: kayıt formülü mevcut sınıfa devredilir, additive optional alan, API imzaları korunur. Asset gerekmedi, yeni envanter ihtiyacı yok. Ahmetin Söz motorunu bekletme kararı sürer; bu bağımsız kayıt bağlantısıdır. Ayrı hazırlık kopyası indexi kullanıldı, ana checkout ve başka ajan işleri korunur. ds yolları yok, önceki istisnayla eşitlenmedi. kota görünmüyor.
