## 2 Kasım 2026 — KAP-19 tamamlandı (Kalfa)

Mevcut BUG-16 denetçisine yaşayan hane sayımı/katman filtresi eklendi; ikinci seçici veya RNG yok. Optional `hane_id` aynı aileyi tek sayar, eski kayıtta hane alanı olmayan kişi kendi hanesi sayılır; evsiz aile tek tek kişi diye şişirilmez. Sağlık<=0 kişiler sayılmaz. 5/6/12/13 sınırları veri dosyasındadır. Üç açık liste `data/olaylar/nufus_katmanlari.json`: küçük 31, orta 34, büyük 35 kart. Orta liste küçük listeye bebek/düğün/salgını, büyük liste kaçak köylüyü ekler; mevcut tarih/bina/yaş/bar koşulları ayrıca geçmek zorundadır. Dosya havuzu dışındaki dinamik kartlar kendi eski koşullarını korur; üst listenin tüm 35 dosya kimliğini kapsaması testle doğrulanır.

Çocuk kartı bebek `cocuk_var`, düğün `yetiskin_hane_min:2` ister. Tek hanedeki çok sayıda yetişkin iki hane sayılmaz. Havuz yeni seçim anında okunur; açık olaya/nüfusa/kayıt/RNG'ye yazılmaz. Tüm kişi değişiklikleri yaşayan listeden türetilir, ayrı sayaç yok.

Kanıt: `work/kap19_unit.log` (3 kişi/30 gece, 13 hane/30 gece, 5/6/12/13 sınırları, ölü hane/çocuk, gerçek seçici ve liste kapsamı), `kap19_onkosul.log` (mevcut BUG-16 regresyonu), `kap19_koy.log` (köy birim testleri), 4 Python denetim testi, 35/35 olay koşul taraması ve recovery headless import geçti. İlk RED eksik yaşayan hane API'siydi; testte statik metoda dinamik erişim RefCounted örneğiyle düzeltildi. Tam sanity ve görünür pencere yok. İnceleme: salt aday filtresi/koşul, mevcut ağırlıklı seçici korunur; açık kartı değiştiren kod yok.

Asset gerekmedi; yeni ihtiyaç/envanter satırı yok. Antigravity DIY-09/11 ve testx sahiplikleri, ilgisiz yerel değişiklikler korundu. ds yolları yok, önceki izinli istisnayla eşitlenmedi. kota görünmüyor.
