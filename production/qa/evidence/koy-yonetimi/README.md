# Köy yönetimi — görsel kanıt (6 Ekim 2026)

Godot 4.7.2, Forward+ (Vulkan, lavapipe), 1600×900. Tasarım: `design/gdd/koy-yonetimi.md`.

| Dosya | Ne gösteriyor | Nasıl çekildi |
|---|---|---|
| `kapi-gunduz.png` | Gündüz kapı ışığı (plan 14.1), yeni HUD (akçe, stoklar, huzur, adalet, asayiş, mevsim), "1. gün" etiketleri | `GECE=0 PERDE=1 SUR=0 BEKLE=3 tests/oto/kapi_foto.tscn` |
| `koy-yapi-bilgisi.png` | Akşam köyü; buğday tarlası bilgi paneli: çalışanlar, zanaat, moral, açılmış `usta çiftçi` bayrağı | `KIP=bilgi tests/oto/koy_foto.tscn` |
| `koy-insa-hayalet.png` | Yerleşim hayaleti (kırmızı = uygunsuz) ve red gerekçesi "meydana bağlı bir yola değmiyor" | `KIP=insa tests/oto/koy_foto.tscn` |
| `koy-gece-raporu.png` | Gece rapor kartı: üretim, tüketim, akçe, huzur, hafta başı vergisi; HUD'da günlük net değişim | `KIP=rapor tests/oto/koy_foto.tscn` |

Bilinen: kapı sahnesinin zemininde ilkbaharda da kar var (sahne mevsime bağlı değil) — Aşama D.

## Arazi ve çevre (görsel tasarım md, İş 1 — madde 1, 2, 3, 5)

| Dosya | Ne gösteriyor | Nasıl çekildi |
|---|---|---|
| `arazi-yakin-aksam.png` | Splat zemin: organik kenarlı patikalar ve meydan, yol çukurlarında çamur, yapı çevresinde çiğnenmiş toprak, rüzgârlı çimen tutamları | `KIP=bos tests/oto/koy_foto.tscn` |
| `arazi-orman-kusagi.png` | Köyü çevreleyen orman kuşağı (impostor atlası), kapıdan güneye toprak yol | `KIP=bos KAMERA=uzak` |
| `arazi-gece.png` | Gece fazı: ay ışığı, meydan ateşinin uzun gölgeleri (rapor kartı açılırken geçilir) | `KIP=bos FAZ=gece` (ay ışığı bu çekimden sonra biraz artırıldı) |
