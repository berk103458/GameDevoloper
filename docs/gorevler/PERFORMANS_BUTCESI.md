# Performans Bütçesi (Başlangıç Eşikleri)

Bu belge ölçüm öncesi başlangıç bütçesini tek sayfada toplar (`docs/gorevler/ALPHA_OYUNCU_GOZU_GOREVI.md` Hedef 3). Buradaki bütün sayılar repodaki doğrulanmış kaynaklardan alınmıştır; ölçüm (`tests/oto/olcum/performans_izi.gd`, Bölüm 1 onayından sonra eklenecek) olmadan yeni eşik uydurulmaz.

## Doğrulanmış Başlangıç Sayıları

| Kalem | Değer / Eşik | Kaynak |
| --- | --- | --- |
| Tavuk hedef boyu | `0,40 m` (`azami_ayak_m: [0.45, 0.45]`) | `data/varlik_olculeri.json` (`a146_tavuk_gercekci`, `td_a146`), `docs/CILALAMA_PLANI.md` |
| Dekor görüş mesafesi (`GORUNUR_METRE`) | `120.0 m` (fade marjı `8.0 m`) | `src/koy/gorsel/topluluk_dekoru.gd` |
| Model başına üçgen tavanı | `<= 60.000` üçgen | `docs/CILALAMA_PLANI.md` (satır 755) |
| Düşük profil FPS uyarısı eşiği | `30.0 FPS` ortalama (üst üste `3` gece) | `ROADMAP_2.md` (`AYR-41`), `src/sistemler/profil_onerisi.gd` |
| Performans günlüğü alt FPS eşiği | `fps_ortanca_en_az: 30.0` | `data/teknik.json`, `data/teknik_varsayilan.json`, `src/debug/performans_gunlugu.gd` |
| Performans günlüğü üst kare süresi | `kare_ms_azami: 100.0 ms` | `data/teknik.json`, `data/teknik_varsayilan.json`, `src/debug/performans_gunlugu.gd` |
| Duman testi bellek artış tavanı | `bellek_carpan_tavan: 2.0` | `data/teknik.json` |

## Kurallar ve Kapsam Notları

- `tests/oto/olcum/performans_izi.gd` dosyası Bölüm 1 onayından sonra ayrı küçük bir iş olarak eklenecek ve `src/debug/performans_gunlugu.gd` ile aynı ölçüm dilini kullanacaktır.
- Gerçek sahnede aynı prop'tan çok kopyanın çizim maliyetini ölçümle kanıtlamadan `MultiMeshInstance3D` optimizasyonu eklenmez.
- Doku sıkıştırma (`compress/mode`) ve toplu mesh import (`generate_lods`, `light_baking`) parametreleri ölçüm ve Ahmet onayı olmadan toplu değiştirilmez.
