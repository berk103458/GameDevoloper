# Nano Banana Pro — ekran arka planları

20 Kasım 2026. Cursor. Ahmet üretir. Kod, dosya bu yolda ve bu adla durunca onu yükler. Yoksa isim etiketli koyu kutu kalır. `no text`. Saydamlık yok. Opak resim.

23 Kasım 2026: Altı çerçeve ve on arka plan üretildi. Grok Bot GenerateImage ile özgün üretildi, Ahmet onayladı 23 Kas 2026. Nihai dosyalar `assets/ui/atmosfer/gece_kapisi/` ve `assets/ui/arkaplan/` altında.

Ortak üslup: 14. yüzyıl Osmanlı uç beyliği, ciddi, gece, mum ve demir. Avrupa parşömen penceresi, çini desen dolgusu, çizgi film, gotik haç yok.

| Dosya | Boyut | Ekran | Prompt |
|---|---|---|---|
| `assets/ui/arkaplan/yukleme_kapi.png` | 1920×1080 | Yükleme, rastgele | Night gate of a 14th-century Anatolian frontier lodge, timber and iron, one oil lamp, empty road, no people, no text, painterly, serious |
| `assets/ui/arkaplan/yukleme_koy.png` | 1920×1080 | Yükleme, rastgele | Frontier village at dusk, mud roofs and a single poplar, cold blue sky, no people, no text, painterly |
| `assets/ui/arkaplan/yukleme_ocak.png` | 1920×1080 | Yükleme, rastgele | Interior hearth of a frontier house, low fire, soot and timber, no people, no text, painterly |
| `assets/ui/arkaplan/kapi_gece.png` | 1920×1080 | Kapı sorgu arkası | Close night air behind a standing visitor, dark timber gate, shallow depth, no face, no text |
| `assets/ui/arkaplan/koy_gunduz.png` | 1920×1080 | Köy HUD arkası | Dry frontier village noon, dust, short shadows, no people, no text |
| `assets/ui/arkaplan/koy_gece.png` | 1920×1080 | Köy gece | Same village under a thin moon, a few window slits, no people, no text |
| `assets/ui/arkaplan/ayarlar.png` | 1920×1080 | Ayarlar | Dark timber wall, iron studs, empty, no text |
| `assets/ui/arkaplan/envanter.png` | 1920×1080 | Heybe | Worn wool cloth on a low table, one unlit lamp, no objects with labels, no text |
| `assets/ui/arkaplan/gun_sonu.png` | 1920×1080 | Gün sonu raporu | Embers in a brazier, night room, no paper, no text |
| `assets/ui/arkaplan/kayit.png` | 1920×1080 | Kayıt yuvaları | Closed wooden chest and a dark shelf, no text |

Yükleme, `assets/ui/arkaplan/yukleme` ile başlayan png dosyalarından birini seçer. Hiçbiri yoksa `assets/ui/atmosfer/gece_kapisi/loading_bg.png` durur.

## Çerçeve seti (6 parça)

21 Kasım 2026. Ahmet, `docs/arayuz/UI_KIT_TARAMASI.md` içindeki Nano Banana yolunu seçti. Her mesajda bir parça. Yazı, rakam, arma, haç, kelt düğümü, fleur-de-lis ve Avrupa gotik motifi yok. Dönem: 14. yüzyıl Osmanlı / Selçuklu uç beyliği. Malzeme: eskimiş ceviz, deri, dövme demir, tombak, koyu mürekkep, çini yalnız ince sır olarak. Ciddi ve gerçekçi. Düz site kartı, yuvarlak mobil düğme ve çizgi film yok.

Kaynak zemin düz `#00FF00`. Bu yeşil nesnenin içinde kullanılmaz. Orta, 9-dilim için tekrarlanabilir bir bant ya da (portrede) aynı yeşil deliktir. `src/arayuz/gece_kapisi_tema.tres` eksik dosyayı referans almaz; Godot kayıp dokuda temayı açmaz. Bağ, çalışma anında `GeceKapisiCerceve` içindedir. Dosya yoksa eski tahta çerçeve ve düz yer tutucu kalır. Dosya aşağıdaki nihai adla durunca kod değişmez.

Ham yeşil kopya `work/ui_yesil_ham/<aynı dosya adı>` altına konur. Yeşili şeffafa çeviren araç repoda duruyor:

```powershell
$env:PYTHONUTF8="1"
python -B tools/art/gece_kapisi_hazirla.py docs/arayuz/gece_kapisi_cerceve_alti.json assets/ui/atmosfer/gece_kapisi
```

`method: green` yeşil zemini alfa yapar. Araç nihai PNG'yi 16 px boşlukla `assets/ui/atmosfer/gece_kapisi/` altına yazar. Godot'u bir kez açmak importu bitirir. Temiz RGBA dosya zaten o klasörde ve bu addaysa araç şart değildir.

| Parça | Dosya | Boyut | Dilim sol/üst/sağ/alt | Sahne |
|---|---|---|---|---|
| Diyalog şeridi | `assets/ui/atmosfer/gece_kapisi/cerceve_diyalog_seridi.png` | 1536×512 | 112 / 96 / 112 / 96 | Dialogue Manager balonu, `src/arayuz/diyalog/balon.tscn` konuşma paneli |
| Seçenek satırı | `assets/ui/atmosfer/gece_kapisi/cerceve_secenek_satiri.png` | 768×192 | 28 / 18 / 28 / 18 | Balonun cevap düğmeleri ve tema düğmesi. Hover ayrı çizim değil |
| Portre çerçevesi | `assets/ui/atmosfer/gece_kapisi/cerceve_portre.png` | 768×1024 | 96 / 96 / 96 / 96 | Kapı incelemesi, `GorselIz` portresinin arkası |
| Panel | `assets/ui/atmosfer/gece_kapisi/cerceve_panel.png` | 1280×768 | 96 / 96 / 96 / 96 | Tema paneli, ayar paneli, heybe ve köy paneli |
| Mühür | `assets/ui/atmosfer/gece_kapisi/cerceve_muhur.png` | 256×256 | 0 / 0 / 0 / 0 | Defter sayfasının sağ alt köşesi. Dilimlenmez |
| Rumi köşe | `assets/ui/atmosfer/gece_kapisi/cerceve_rumi_kose.png` | 256×256 | 0 / 0 / 0 / 0 | Balon panelinin dört köşesi. Tek köşe, dilimlenmez; sağ ve alt aynalanır |

### Diyalog şeridi

Geniş, alçak bir konuşma tahtası. Köşe süslü değil; süs ayrı rumi dosyasındadır. Orta bant yazı için düz ve tekrarlanır. Dışarısı düz yeşildir, tahtaya değmez.

```
One UI piece only. A wide horizontal dialogue strip for a 14th-century Ottoman and Seljuk frontier beylik, serious and realistic. Soot-dark worn walnut, a thin hammered iron lip, and a narrow tombak brass edge. The center is an empty flat dark wood band for text, with no letters and no ornament, so the middle can repeat in a 9-slice. Keep the carved lip inside the outer 112 px on the left, 96 px on the top, 112 px on the right and 96 px on the bottom. Corners are plain. Background is uniform solid #00FF00 and does not touch the wood. No green in the wood or metal, no green reflection, no shadow on the background. No text, no numbers, no cross, no coat of arms, no fleur-de-lis, no Celtic knot, no gothic tracery, no parchment scroll, no website card, no rounded mobile button. Canvas 1536 by 512 pixels.
```

### Seçenek satırı

Aynı tahtadan tek bir seçenek sırası. Uçlar süssüz. 48 px yüksekliğindeki düğmede köşe ezilmesin diye dudak üstte ve altta 18 px içinde kalır.

```
One UI piece only. A single horizontal choice row for a 14th-century Ottoman and Seljuk frontier beylik, serious and realistic. The same soot-dark worn walnut, slightly inset, with a thin tombak inner edge and worn leather shadow in the groove. No text. Plain ends so the row can be 9-sliced. Keep the carved lip inside the outer 28 px on the left and right and 18 px on the top and bottom; the middle is a plain repeatable band. Background is uniform solid #00FF00 and does not touch the wood. No green in the object, no green reflection, no shadow on the background. No cross, no coat of arms, no fleur-de-lis, no Celtic knot, no gothic arch, no mobile chip, no rounded app button. Canvas 768 by 192 pixels.
```

### Portre çerçevesi

Dikey pencere. Ortası ve dışı aynı düz yeşil, ikisi de kesilir. Yüz yok. Rumi kıvrım yalnız ahşabın dört köşesinde, deliğin içinde değil.

```
One UI piece only. A vertical portrait window for a 14th-century Ottoman and Seljuk frontier beylik, serious and realistic. Soot-dark worn wood, a thin tombak rim, and small iron nails. The middle is empty and the same uniform solid #00FF00 as the outside, so both can be cut out. A small rumi curl sits only at the four corners, inside the wood, not in the empty middle. Keep that wood inside a 96 px margin on every side. No face, no text, no numbers. No green in the wood or metal. No cross, no coat of arms, no knight helm, no fleur-de-lis, no Celtic knot, no gothic tracery. Canvas 768 by 1024 pixels.
```

### Panel

Oda, ayar ve heybe penceresi. Konuşma şeridinden daha kapalı. Köşe süssüz; rumi sonradan biner. Orta, koyu deri ya da isli tahta, tekrarlanır.

```
One UI piece only. A closed UI panel for a 14th-century Ottoman and Seljuk frontier beylik, serious and realistic. Soot-dark worn walnut frame, a strip of aged leather inside it, and a thin hammered iron edge. The center is a plain dark leather field with no letters, so it can repeat in a 9-slice. Keep the frame inside a 96 px margin on every side. Corners are plain, with no attached ornament. Background is uniform solid #00FF00 and does not touch the wood. No green in the object, no green reflection, no shadow on the background. No text, no numbers, no cross, no coat of arms, no fleur-de-lis, no Celtic knot, no gothic window, no tile-filled website card. Canvas 1280 by 768 pixels.
```

### Mühür

Yuvarlak, çatlak, koyu kırmızı-kahve mum. Sekiz köşeli sade Selçuklu yıldızı. Harf yok. Dilimlenmez; sayfanın üstüne konur.

```
One UI piece only. A round wax seal for a 14th-century Ottoman and Seljuk frontier beylik, serious and realistic. Dark red-brown wax, slightly cracked, pressed with a simple eight-point Seljuk star and no letters. Aged, not glossy. Background is uniform solid #00FF00. No green in the wax, no green reflection, no shadow on the background. No text, no numbers, no cross, no coat of arms, no fleur-de-lis, no Celtic knot, no gothic crest. Not a frame and not a 9-slice. Canvas 256 by 256 pixels.
```

### Rumi köşe

Tek köşe, sol üst. Diğer üç kenar boş yeşile döner. Tombak rumi. Çerçeve dosyasının içine çizilmez.

```
One UI piece only. A single top-left corner ornament for a 14th-century Ottoman and Seljuk frontier beylik, serious and realistic. Tombak brass formed as a Seljuk rumi scroll, worn, not shiny gold. The ornament sits in the top-left of the canvas. The other three edges fade to empty. Background is uniform solid #00FF00. No green in the metal, no green reflection, no shadow on the background. No text, no numbers, no cross, no coat of arms, no fleur-de-lis, no Celtic knot, no gothic crocket. One corner only, not a full frame. Canvas 256 by 256 pixels.
```
