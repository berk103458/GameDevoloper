# Köy HUD ve hareket doğrulaması — 2026-10-06

Godot 4.7.2, Windows, Vulkan Forward+, NVIDIA RTX 3060. Ekranlar 1600×900.

- `koy-arayuz-100.png`, `koy-arayuz-150.png`: kaynak simgeleri, net miktarlar, maliyet kartları, yatay kaydırma ve büyük metin yerleşimi.
- `kapi-hud.png`: ortak HUD kapı ekranında.
- `koy-hareket-gunduz.png`: gündüz köy görünümü, yollarda yürüyen ve işyeri çevresinde duran köylüler.

Başarılı kontroller:

- `tests/unit/koy_rotasi/koy_rotasi_test.gd`: yol tercihi, bina/arazi engelleri, dört komşulu adımlar, kopuk alan, engel kaldırılması.
- `tests/oto/koy_hareket_kontrol.tscn`: işe yürüyüş; yenilemede model ve konum korunması; işten dinlenmeye geçiş; farklı ev hedefine gece dönüş; görsel hareketin kayıt/ekonomiyi değiştirmemesi; duraklamada hareketin durması.
- `tests/oto/koy_hud_kontrol.tscn`: akçe neti, aynı gün yenileme, kaydırılabilir kartlar, malzeme kapısı, duraklama/sürdürme, ekran çıkışında zaman ölçeğinin sıfırlanması.
- Editör importunda GDScript hatası yok; gerçek Vulkan çalıştırmasının hata çıktısı boş.

Hareket yalnız görseldir. Gece köylüler evin dışındaki erişilebilir hücreye döner; bina içine girme/saklanma eklenmedi. Meydan mobilyaları için ayrı çarpışma, yerel kalabalık kaçınması ve mesleğe özel aletler sonraki işlerdir. FPS/VRAM hedefleri bu kontrolde ölçülmedi.
