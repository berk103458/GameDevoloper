# TEK-13 / TEK-14 / TEK-15 — bellek ve efekt doğrulaması (Kalfa)

Sahiplik 539997a, 11 Ekim 2026. Aynı ROADMAP 2 bölüm 41.3 içindeki üç S boyutlu kontrol maddesi birlikte alındı. Oyun kaynakları değiştirilmedi; ikinci önbellek, efekt havuzu, temizleyici veya performans motoru eklenmedi. Asset gerekmedi.

TEK-13: mevcut `DusukBellekProfili.memory_free` tam beş anahtar döndürür: sanat, malzeme, model, klip, sekil. Genişletilen birim testi temizleme öncesi tüm beş sayıyı karşılaştırır; sanat/şekil cache ve kapı gürültü referansının bırakılmasını da denetler. Mevcut aktif karakter klipleri ve aktif malzeme korunur; temizleme sonrası model yeniden yüklenir.

TEK-14: gerçek `Ana._goster` yoluyla üç düşük profil geçişi. Yalnız cache tarafından tutulan yoklama nesnesinin serbest kalması sayılır: geçiş başına 1. Geçişin ardından eklenen ikinci yoklama iki ertelenmiş kare boyunca korunur; efekt taraması yeniden memory_free çağırmaz. Aktif karakter klipleri korunur, performans şeridi görünmez ve işlem yapmaz, ekonomi/RNG/kayıt eşitliği korunur. Kaynak taramasında `_goster` bir GrafikProfiliAdaptoru kurar, adaptör `_ready` yalnız bir `_bellek` çağrısı yapar; düşük profilde `_bellek` tek mevcut memory_free çağrısını kullanır. Düşük profil şeridi açmaz.

TEK-15: `src/ses/efekt_havuzu_temizligi.gd`, mevcut Ses adaptörü ve Ana `_goster` içindeki tek `Ses.efektleri_temizle()` korunur. Yeni geçiş testi gerçek sfx_onay sesini başlatır; sonraki sahnede tüm efektler durmuş, stream referansları bırakılmış ve havuz sırası sıfırlanmıştır. Üç geçişte aynı AudioStreamPlayer dizisi kullanılır. Mevcut ayrı havuz birim testi arka plan müzik/ortam akışlarının korunmasını da doğrular.

Hedefli sonuç: düşük bellek, grafik profili, efekt havuzu, performans şeridi ve yeni gerçek geçiş sahnesi **5 PASS / 0 hata**. Kanıt `work/tek131415-target`. Yeni sahne sanity listesine eklendi; nihai tam UTF-8 sonucu koşu sonunda yazılacak. Testlerde `res://work` yolu yok, kullanıcı ayarı/kaydı yazılmaz.

Zorunlu ds çalışma kopyası ve GitHub aynası bu bilgisayarda yok; eşitlenemedi. Başkalarının TEK sahiplikleri ve ilgisiz untracked dosyalar korundu.

Nihai tek tam UTF-8 sanity **343 PASS / 0 hata / 20 gece**, `work/sanity-tek131415-final`. Yeni gerçek geçiş sahnesi aynı tam koşuda geçti.
