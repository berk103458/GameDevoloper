# Köy yönetimi — görsel kanıt (6 Ekim 2026)

Godot 4.7.2, Forward+ (Vulkan, lavapipe), 1600×900. Tasarım: `design/gdd/koy-yonetimi.md`.

| Dosya | Ne gösteriyor | Nasıl çekildi |
|---|---|---|
| `kapi-gunduz.png` | Gündüz kapı ışığı (plan 14.1), yeni HUD (akçe, stoklar, huzur, adalet, asayiş, mevsim), "1. gün" etiketleri | `GECE=0 PERDE=1 SUR=0 BEKLE=3 tests/oto/kapi_foto.tscn` |
| `koy-yapi-bilgisi.png` | Akşam köyü; buğday tarlası bilgi paneli: çalışanlar, zanaat, moral, açılmış `usta çiftçi` bayrağı | `KIP=bilgi tests/oto/koy_foto.tscn` |
| `koy-insa-hayalet.png` | Yerleşim hayaleti (kırmızı = uygunsuz) ve red gerekçesi "meydana bağlı bir yola değmiyor" | `KIP=insa tests/oto/koy_foto.tscn` |
| `koy-gece-raporu.png` | Gece rapor kartı: üretim, tüketim, akçe, huzur, hafta başı vergisi; HUD'da günlük net değişim | `KIP=rapor tests/oto/koy_foto.tscn` |

Bilinen: kapı sahnesinin zemininde ilkbaharda da kar var (sahne mevsime bağlı değil) — Aşama D.
