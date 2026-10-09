# HAR-13 — Gözcü ertesi gün kafile önizleme

9 Ekim 2026, Codex uygulaması; taban commit `3411594`. Kapanış ve yayın Claude Code'a aittir.

HAR-06 `GozcuOngoru`, kaynak oturumun JSON kayıt kopyasında mevcut `gece_sonu()` ve `gece_kuyrugu()` akışını bir kez çalıştırır. Yeni `gozcu_kafile_ozeti.gd` yalnız bu üretilmiş kuyruğu sayar ve sunar; ikinci simülasyon veya kalıcı öngörü kaydı yoktur. `durum()` mevcut alanlarını korur, `ozet` alanı ekler.

Mevcut Harita → Hisar bilgi metninde ertesi gün başlığının altında toplam kapı ziyareti, yolcu, gezgin tüccar ve heyet sayıları görünür. HAR-12 `DiplomatikHeyet.bilet()` ile tanınan heyetlerin herkese açık adları gerçek kuyruk önceliğinde listelenir. Gezgin tüccar mevcut `TuccarKapiGecisi.ilgilenir()` işaretinden tanınır; sıradan esnaf otomatik olarak gezgin tüccar sayılmaz. Bir heyet bir kapı ziyaretidir; fiziksel kişi veya kafile büyüklüğü tahmin edilmez. Diğer ziyaretler yolcu sayılır.

Özet kuyruğun tamamını sayar. HAR-06'nın en fazla sekiz kişilik herkese açık isim/sınıf ayrıntısı aynı kalır; bu sınır toplamı etkilemez. Gizli CHR kimliği, niyeti, bayrakları, heybesi, statları, sorgu veya makbuz verisi özete taşınmaz. Kule koşulu sağlanmıyorsa özet boş bırakılır ve mevcut kapalı açıklaması gösterilir. Simüle gece terminal sonuç üretiyorsa mevcut belirsizlik notu gösterilir; sıfır ziyaret gibi sunulmaz.

Kaynak oturumun beş RNG akışı, stok, kamu/kişisel kasa, CHR kadrosu, diplomatik heyet ve tüccar ziyaret makbuzları değişmez. Gece/olay kararları veya köy durumu değişirse öngörü değişebilir; mevcut uyarı metni korunur. Öngörü gerçek ziyaret veya talebin dinlenmesi/ödenmesi değildir.

Yeni HUD veya harita paneli kurulmadı; mevcut `CevreHaritasi.bilgi()` → `GozcuOngoru.metin()` bağlantısı ve kaydırılabilir bilgi alanı kullanıldı. Korumalı çekirdek dosyalar değiştirilmedi. Asset gerekmedi; envantere yeni asset ihtiyacı yoktur.

Doğrulama: `tests/unit/kvr/gozcu_kafile_ozeti_test.gd` gerçek ertesi günle eşleşme, sekizden uzun kuyruk, heyet/tüccar ayrımı, makbuzlar/RNG izolasyonu, gizlilik, deterministik tekrar, kayıt yükleme ve kapalı/belirsiz durumları denetler. `tests/oto/gozcu_kafile_ozeti_kontrol.tscn` gerçek köy ekranından harita düğmesiyle açılır; Hisar/Tekfur seçimi, tek bilgi alanı, kapanış ve 2x hızın dönüşü, %150 metin kaydırması, tekrar açılış ve görevli koşulu denetlenir. UI sahnesi `tools/sanity_check.py` listesine eklendi; birim test mevcut otomatik keşfe girer.
