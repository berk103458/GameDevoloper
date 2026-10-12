# Arayüzde Sanat dışı yükleme istisnaları (GRV-27)

Portre ve ikon `Sanat` (`src/arayuz/sanat.gd`) üzerinden gelir; panel kendi `load("res://assets…")` yolunu açmaz. Bu liste kapalıdır; yeni satır ancak gerekçeyle eklenir. Denetim: `tools/kapsam_bekcisi.py` (GRV-27).

| Dosya | Yüklenen | Neden |
|---|---|---|
| `src/arayuz/tema.gd` | `res://assets/font/Cinzel-wght.ttf` | Yazı tipi temanın kendisidir; Sanat doku/portre içindir. |
| `src/arayuz/koy_hud/kaynak_gostergesi.gd` | `res://assets/ui/koy/<tur>.svg` | Kaynak ikonu SVG kümesi; gezgin stok ikonu yoksa düşülen yol. |
