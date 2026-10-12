# Gemini için tek tek üretim promptları — gece kapısı (Kalfa)

12 Ekim 2026. [Araştırma ve kaynaklar](NANO_BANANA_OYUN_ASSET_ARASTIRMASI.md). Bu belge eski gece kapısı promptlarının yerine uygulanacak yeni akıştır. Katalog 57 slot: **51 bağımsız resim promptu + altı aynı temel görselden türetilecek durum**. Bunlar mevcut UI kataloğudur; bütün oyun envanteri veya yeni 3D asset listesi değildir.

## Ahmet nasıl kullanacak?

- Aşağıdaki **tek bir** İngilizce bloğu Gemini görüntü üretimine yapıştır. Sonuç gerçekten görünüp indirilemeden sonraki bloğa geçme. Bir mesajda paket üretimi isteme. Önce `25 · loading_fill` ile küçük bir deneme yapılabilir.
- İlk resimde referans gerekmiyor. Beğendiğin bir resmi sonraki üretimlerde gerçek dosya olarak ekle; şekli değil yalnız malzemeyi aktarırken rolünü belirt. Buton ailesinde tek normal temel kullanılır, dört farklı çizim istenmez.
- Resim üretimindeki tuval oranı ile **nihai oyun dosyası ölçüsü farklıdır**. Tablodaki ölçü, alfa ve 9-slice payını Gemini'nin yazılı yanıtı doğrulamaz; bunlar indirme sonrası hazırlama hedefleridir. Oran seçici varsa belirtilen kaynak oranını kullan. Olmasa da sonuç kadrajı denetlenir.
- Saydamlık isteyen kaynak düz magenta üzerinde çizilir. Bu renk sonradan maske ile çıkarılır; damalı görüntü veya `.png` uzantısı gerçek alfa anlamına gelmez. Merkez dolgusunu koru; yalnız portre çerçevesinin penceresi de çıkarılır.
- Çok ince şeritleri çok geniş resim tuvalinin ortasında çizdiriyoruz. Sonradan kırpıp hedefe hazırlıyoruz; modele 48×768 veya 1024×96 gibi özel çıktı çözünürlüğü zorlamıyoruz.
- 9-slice sırası sol/üst/sağ/alt; kesin değerler final dosya pikselidir. Köşeleri bozmayan bantlar editörde ve Godot'ta doğrulanacak. İkon, imleç ve sahne resmine 9-slice uygulanmaz.
- Bu teslim prompt ve hazırlama tarifidir. Resim üretilmedi, alfa temizlenmedi, tema/animasyon oyuna bağlanmadı.

## Parça kataloğu

| No | Nihai dosya | Nihai ölçü | Nihai saydamlık | 9-slice S/Ü/Sa/A | Yol |
|---|---|---|---|---|---|
| 01 | `main_menu_bg.png` | 3840×2160 | Opak RGB | 0/0/0/0 — uygulanmaz | Tek resim |
| 02 | `interrogation_bg.png` | 3840×2160 | Opak RGB | 0/0/0/0 — uygulanmaz | Tek resim |
| 03 | `map_bg.png` | 3840×2160 | Opak RGB | 0/0/0/0 — uygulanmaz | Tek resim |
| 04 | `loading_bg.png` | 3840×2160 | Opak RGB | 0/0/0/0 — uygulanmaz | Tek resim |
| 05 | `dialogue_panel.png` | 1536×768 | RGBA; dışı saydam | 96/80/96/80 | Tek resim |
| 06 | `button_normal.png` | 768×192 | RGBA; dışı saydam | 64/48/64/48 | Tek resim |
| 07 | `button_hover.png` | 768×192 | RGBA; dışı saydam | 64/48/64/48 | Aynı temelden türet |
| 08 | `button_pressed.png` | 768×192 | RGBA; dışı saydam | 64/48/64/48 | Aynı temelden türet |
| 09 | `button_disabled.png` | 768×192 | RGBA; dışı saydam | 64/48/64/48 | Aynı temelden türet |
| 10 | `villager_card.png` | 768×1024 | RGBA; dışı saydam | 64/64/64/64 | Tek resim |
| 11 | `portrait_frame.png` | 512×640 | RGBA; dışı ve merkezi saydam | 0/0/0/0 — uygulanmaz | Tek resim |
| 12 | `settings_panel.png` | 1536×1536 | RGBA; dışı saydam | 80/80/80/80 | Tek resim |
| 13 | `tooltip_panel.png` | 768×384 | RGBA; dışı saydam | 48/48/48/48 | Tek resim |
| 14 | `hud_strip.png` | 2048×192 | RGBA; dışı saydam | 64/40/64/40 | Tek resim |
| 15 | `focus_ring.png` | 768×192 | RGBA; dışı ve merkezi saydam | 64/48/64/48 | Aynı temelden türet |
| 16 | `tab_normal.png` | 384×160 | RGBA; dışı saydam | 40/32/40/32 | Tek resim |
| 17 | `tab_selected.png` | 384×160 | RGBA; dışı saydam | 40/32/40/32 | Aynı temelden türet |
| 18 | `checkbox_off.png` | 96×96 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz | Tek resim |
| 19 | `checkbox_on.png` | 96×96 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz | Aynı temelden türet |
| 20 | `slider_track.png` | 768×64 | RGBA; dışı saydam | 24/16/24/16 | Tek resim |
| 21 | `slider_thumb.png` | 96×128 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz | Tek resim |
| 22 | `scrollbar_track.png` | 48×768 | RGBA; dışı saydam | 12/24/12/24 | Tek resim |
| 23 | `scrollbar_thumb.png` | 48×192 | RGBA; dışı saydam | 12/24/12/24 | Tek resim |
| 24 | `loading_track.png` | 1024×96 | RGBA; dışı saydam | 32/24/32/24 | Tek resim |
| 25 | `loading_fill.png` | 1024×96 | RGBA; dışı saydam | 32/24/32/24 | Tek resim |
| 26 | `ornament_corner.png` | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz | Tek resim |
| 27 | `ornament_divider.png` | 1024×96 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz | Tek resim |
| 28 | `ornament_emblem.png` | 512×512 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz | Tek resim |
| 29 | `ornament_seal.png` | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz | Tek resim |
| 30 | `cursor_arrow.png` | 128×128 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz | Tek resim |
| 31 | `cursor_point.png` | 128×128 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz | Tek resim |
| 32 | `cursor_grab.png` | 128×128 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz | Tek resim |
| 33 | `cursor_busy.png` | 128×128 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz | Tek resim |
| 34 | `icon_akce.png` | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz | Tek resim |
| 35 | `icon_erzak.png` | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz | Tek resim |
| 36 | `icon_odun.png` | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz | Tek resim |
| 37 | `icon_tas.png` | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz | Tek resim |
| 38 | `icon_demir.png` | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz | Tek resim |
| 39 | `icon_bez.png` | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz | Tek resim |
| 40 | `icon_alet.png` | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz | Tek resim |
| 41 | `icon_nufus.png` | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz | Tek resim |
| 42 | `icon_yatak.png` | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz | Tek resim |
| 43 | `icon_saglik.png` | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz | Tek resim |
| 44 | `icon_moral.png` | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz | Tek resim |
| 45 | `icon_guvenlik.png` | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz | Tek resim |
| 46 | `icon_adalet.png` | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz | Tek resim |
| 47 | `icon_gun.png` | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz | Tek resim |
| 48 | `icon_kabul.png` | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz | Tek resim |
| 49 | `icon_ret.png` | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz | Tek resim |
| 50 | `icon_uyari.png` | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz | Tek resim |
| 51 | `icon_kilit.png` | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz | Tek resim |
| 52 | `icon_geri.png` | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz | Tek resim |
| 53 | `icon_kapat.png` | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz | Tek resim |
| 54 | `icon_ayarlar.png` | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz | Tek resim |
| 55 | `icon_kaydet.png` | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz | Tek resim |
| 56 | `icon_harita.png` | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz | Tek resim |
| 57 | `icon_diyalog.png` | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz | Tek resim |

## Ayrı istekler

Her kod bloğu yalnız o parçayı ister; sıra numarası ve dosya adı resme yazılmaz. Dosyayı Ahmet indirdikten sonra katalog adına kaydeder.

### 01 · main_menu_bg.png — Ana menü arka planı

Nihai hazırlama: **3840×2160 px**, Opak RGB; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **16:9**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One continuous atmospheric night scene at a wooden frontier gate with iron fittings, distant hills and sparse mist. Place a small open ceramic oil lamp with a visible wick at the right. The left third stays naturally dark and low-detail through environmental lighting, with no hard rectangle or pasted menu panel. No people, buttons or title. No glass chimney or kerosene lantern.
Use a 16:9 source canvas. Fill the entire canvas with the continuous environment; no letterbox borders or flat isolation background.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 02 · interrogation_bg.png — Sorgu çevre arka planı

Nihai hazırlama: **3840×2160 px**, Opak RGB; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **16:9**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One empty guard-side night view of a timber gate threshold and stone jambs. Keep the central visitor area and the right dialogue area dark, calm and low-detail while preserving continuous scene shading. Include a small open ceramic oil lamp at upper right. No cream void, bright blank rectangle, portrait, queue, paper or interface controls. No glass chimney or kerosene lantern.
Use a 16:9 source canvas. Fill the entire canvas with the continuous environment; no letterbox borders or flat isolation background.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 03 · map_bg.png — Harita arka planı

Nihai hazırlama: **3840×2160 px**, Opak RGB; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **16:9**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One unlabeled illustrated frontier terrain map with subdued hills, a river and sparse tracks. Top-down composition; the central three quarters stay low-contrast. Edge ornament is restrained. No fixed settlements, location markers, compass lettering or route symbols; those will be runtime overlays.
Use a 16:9 source canvas. Fill the entire canvas with the continuous environment; no letterbox borders or flat isolation background.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 04 · loading_bg.png — Yükleme ekranı arka planı

Nihai hazırlama: **3840×2160 px**, Opak RGB; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **16:9**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One quiet night road approaching a distant wooden gate, layered foothills and gentle haze. A small open ceramic oil lamp with a bare flame and visible wick provides a warm accent. Keep the lower fifth calm through natural shading. No glass chimney, kerosene lantern, people, progress bar, wooden UI strip or pasted dark rectangle.
Use a 16:9 source canvas. Fill the entire canvas with the continuous environment; no letterbox borders or flat isolation background.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 05 · dialogue_panel.png — 9-slice diyalog paneli

Nihai hazırlama: **1536×768 px**, RGBA; dışı saydam; 9-slice **96/80/96/80**.

Üretim için kaynak tuvali: **16:9**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One front-facing horizontal dialogue panel, roughly twice as wide as tall. Dark opaque quiet reading surface, thin worn iron border and very small corner accents. Keep opposite edges straight and texture restrained along the middle of each edge. No portrait hole, decorations crossing the center, shadows outside the silhouette or giant star corner plates.
Use a 16:9 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 06 · button_normal.png — Buton — normal

Nihai hazırlama: **768×192 px**, RGBA; dışı saydam; 9-slice **64/48/64/48**.

Üretim için kaynak tuvali: **21:9**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One front-facing blank horizontal button, approximately four times as wide as tall, with a thin continuous iron rim around dark timber. Use one restrained repeated corner treatment and a calm opaque center. No extra vertical iron straps, symbols or raised decorations. This is the single master design from which all button states will be derived.
Use a 21:9 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 07 · button_hover.png — Buton — üstünde

Nihai hazırlama: **768×192 px**, RGBA; dışı saydam; 9-slice **64/48/64/48**.

**Gemini üretimi isteme.** button_normal: ince iç kenar vurgusu + mevcut dokunun aydınlatılması; dış kontur ve köşeler aynı kalır. Bu öneri henüz oyun koduna uygulanmadı. Ayrı PNG gerekiyorsa aynı temel maskesiyle editörde dışa aktar.

### 08 · button_pressed.png — Buton — basılı

Nihai hazırlama: **768×192 px**, RGBA; dışı saydam; 9-slice **64/48/64/48**.

**Gemini üretimi isteme.** button_normal: iç gölge + küçük içerik konum değişimi; çerçevenin dış konturu değişmez. Bu öneri henüz oyun koduna uygulanmadı. Ayrı PNG gerekiyorsa aynı temel maskesiyle editörde dışa aktar.

### 09 · button_disabled.png — Buton — pasif

Nihai hazırlama: **768×192 px**, RGBA; dışı saydam; 9-slice **64/48/64/48**.

**Gemini üretimi isteme.** button_normal: azaltılmış doygunluk/kontrast; pasif durumu etkileşim ve metin rengi de anlatır. Yeni şekil çizdirilmez. Bu öneri henüz oyun koduna uygulanmadı. Ayrı PNG gerekiyorsa aynı temel maskesiyle editörde dışa aktar.

### 10 · villager_card.png — Köylü kartı zemini

Nihai hazırlama: **768×1024 px**, RGBA; dışı saydam; 9-slice **64/64/64/64**.

Üretim için kaynak tuvali: **4:5**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One front-facing vertical villager card backing, approximately three quarters as wide as tall. Dark opaque calm central surface, thin iron rim, small matching corner accents. No portrait window, person, writing, stats, controls or large ornaments crossing the reading area.
Use a 4:5 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 11 · portrait_frame.png — Portre çerçevesi

Nihai hazırlama: **512×640 px**, RGBA; dışı ve merkezi saydam; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **4:5**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One front-facing vertical rectangular portrait frame, approximately four fifths as wide as tall. A thin dark timber and iron border with restrained corners surrounds a large empty rectangular window. Fill that whole window with the same flat magenta as the outside background. No face, opaque panel filling the window, elaborate protrusions or clipped edge.
Use a 4:5 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 12 · settings_panel.png — Ayarlar paneli

Nihai hazırlama: **1536×1536 px**, RGBA; dışı saydam; 9-slice **80/80/80/80**.

Üretim için kaynak tuvali: **1:1**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One front-facing square settings panel with an opaque charcoal reading surface and thin timber-and-iron border. Straight low-detail edge bands; small matching corner accents only. No switches, sliders, title, windows, huge star corner plates or labels.
Use a 1:1 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 13 · tooltip_panel.png — İpucu / küçük bilgi paneli

Nihai hazırlama: **768×384 px**, RGBA; dışı saydam; 9-slice **48/48/48/48**.

Üretim için kaynak tuvali: **16:9**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One front-facing horizontal tooltip panel, approximately twice as wide as tall. Thin dark iron edge, nearly opaque charcoal center, subtle timber texture at the corners only. No pointer triangle, controls, writing or huge rivets.
Use a 16:9 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 14 · hud_strip.png — HUD kaynak şeridi

Nihai hazırlama: **2048×192 px**, RGBA; dışı saydam; 9-slice **64/40/64/40**.

Üretim için kaynak tuvali: **21:9**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One very thin horizontal HUD backing strip, approximately ten times as wide as tall. Calm opaque dark timber center, simple matching iron end caps. Present the complete strip inside a wide canvas with substantial empty space above and below. No panel, icons, resource compartments, labels or shadow outside the strip.
Use a 21:9 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 15 · focus_ring.png — Klavye / gamepad odak halkası

Nihai hazırlama: **768×192 px**, RGBA; dışı ve merkezi saydam; 9-slice **64/48/64/48**.

**Gemini üretimi isteme.** button_normal dış konturundan ince amber odak çizgisi; içi ve dışı gerçek alfa. Editörde veya motorda çizilir. Bu öneri henüz oyun koduna uygulanmadı. Ayrı PNG gerekiyorsa aynı temel maskesiyle editörde dışa aktar.

### 16 · tab_normal.png — Sekme — normal

Nihai hazırlama: **384×160 px**, RGBA; dışı saydam; 9-slice **40/32/40/32**.

Üretim için kaynak tuvali: **16:9**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One short front-facing blank horizontal tab, approximately two and a half times as wide as tall. Thin matching timber-and-iron rim, quiet dark center, slightly raised upper corners and a straight lower seating edge. It must read as a small tab rather than a large dialogue panel. No selection glow or controls.
Use a 16:9 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 17 · tab_selected.png — Sekme — seçili

Nihai hazırlama: **384×160 px**, RGBA; dışı saydam; 9-slice **40/32/40/32**.

**Gemini üretimi isteme.** tab_normal: aynı dokuda küçük amber kenar vurgusu. Boyut ve köşe konumu değişmez. Bu öneri henüz oyun koduna uygulanmadı. Ayrı PNG gerekiyorsa aynı temel maskesiyle editörde dışa aktar.

### 18 · checkbox_off.png — Onay kutusu — boş

Nihai hazırlama: **96×96 px**, RGBA; dışı saydam; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **1:1**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One small square empty checkbox frame with a thin worn iron rim and an opaque dark central recess. No tick, cross, letter or inner decoration. This is the master for both checkbox states.
Use a 1:1 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 19 · checkbox_on.png — Onay kutusu — işaretli

Nihai hazırlama: **96×96 px**, RGBA; dışı saydam; 9-slice **0/0/0/0 — uygulanmaz**.

**Gemini üretimi isteme.** checkbox_off üstüne ayrı açık renk onay işareti. Boş kutunun pikselleri ve konumu korunur. Bu öneri henüz oyun koduna uygulanmadı. Ayrı PNG gerekiyorsa aynı temel maskesiyle editörde dışa aktar.

### 20 · slider_track.png — Ayar sürgüsü kanalı

Nihai hazırlama: **768×64 px**, RGBA; dışı saydam; 9-slice **24/16/24/16**.

Üretim için kaynak tuvali: **21:9**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One empty narrow horizontal slider channel, approximately twelve times as wide as tall. A recessed charcoal groove with thin worn iron edges. Full channel visible with plain space above and below. No thumb, amber fill, panel, progress percentage or end icons.
Use a 21:9 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 21 · slider_thumb.png — Ayar sürgüsü tutamacı

Nihai hazırlama: **96×128 px**, RGBA; dışı saydam; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **4:5**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One standalone vertical oval slider thumb, approximately three quarters as wide as tall. Dark timber center with a single shallow grip groove and a thin worn iron rim. No channel or background panel.
Use a 4:5 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 22 · scrollbar_track.png — Kaydırma kanalı

Nihai hazırlama: **48×768 px**, RGBA; dışı saydam; 9-slice **12/24/12/24**.

Üretim için kaynak tuvali: **9:16**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One empty very slender vertical scrollbar channel, approximately sixteen times as tall as wide. Recessed charcoal groove with thin straight iron edges. Present the full channel in a portrait canvas with plain space on both sides. No thumb, arrows or horizontal rail.
Use a 9:16 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 23 · scrollbar_thumb.png — Kaydırma tutamacı

Nihai hazırlama: **48×192 px**, RGBA; dışı saydam; 9-slice **12/24/12/24**.

Üretim için kaynak tuvali: **9:16**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One standalone slender vertical scrollbar thumb, approximately four times as tall as wide. A solid timber grip with matching small iron end caps. No hollow recessed channel, arrows or second object.
Use a 9:16 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 24 · loading_track.png — Yükleme çubuğu kanalı

Nihai hazırlama: **1024×96 px**, RGBA; dışı saydam; 9-slice **32/24/32/24**.

Üretim için kaynak tuvali: **21:9**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One empty very narrow horizontal loading track, approximately ten times as wide as tall. Dark recessed groove with thin iron edges and tiny matching end caps. Present the full track in the middle of a wide canvas with plain space above and below. No fill, slider knob, percentages or wooden panel.
Use a 21:9 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 25 · loading_fill.png — Yükleme çubuğu dolgusu

Nihai hazırlama: **1024×96 px**, RGBA; dışı saydam; 9-slice **32/24/32/24**.

Üretim için kaynak tuvali: **21:9**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One solid very narrow horizontal loading fill strip, approximately ten times as wide as tall. The strip itself is opaque muted amber with a subtle matte brushed texture and straight parallel edges. Present the whole strip in the middle of a wide canvas with plain space above and below. No iron frame, recessed groove, knob, empty channel, percentage, flame or outer glow. This is ONLY the fill material, not the entire progress bar.
Use a 21:9 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 26 · ornament_corner.png — Köşe süsü — sol üst

Nihai hazırlama: **256×256 px**, RGBA; dışı saydam; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **1:1**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One small upper-left L-shaped corner ornament of restrained worn iron and a single carved timber accent. Simple clear silhouette, no full panel, large floral spray, lettering or emblem.
Use a 1:1 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 27 · ornament_divider.png — Metin bölücü süs

Nihai hazırlama: **1024×96 px**, RGBA; dışı saydam; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **21:9**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One very thin horizontal decorative divider, approximately ten times as wide as tall. Restrained worn iron line with a tiny simple geometric detail at its center. Whole divider visible in a wide canvas with plain space above and below. No panel, ribbon, palette chips or lettering.
Use a 21:9 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 28 · ornament_emblem.png — Başlık yanı özgün amblem

Nihai hazırlama: **512×512 px**, RGBA; dışı saydam; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **1:1**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One compact original gate-inspired emblem: a simple wooden threshold and iron latch motif, with a restrained amber highlight. Clear silhouette and sparse ornament. No actual heraldic insignia, letters, shield text or panel.
Use a 1:1 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 29 · ornament_seal.png — Yazısız mühür / belge süsü

Nihai hazırlama: **256×256 px**, RGBA; dışı saydam; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **1:1**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One small round matte wax seal with an original simple gate-latch impression. No script, letters, numbers, historical coat of arms, document or ribbon.
Use a 1:1 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 30 · cursor_arrow.png — İmleç — normal

Nihai hazırlama: **128×128 px**, RGBA; dışı saydam; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **1:1**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One simple upper-left pointing arrow cursor with a clear sharp tip, ivory body and thin charcoal edge. Subtle worn craft character. No hand, surrounding panel, extra cursor or palette.
Use a 1:1 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 31 · cursor_point.png — İmleç — etkileşim

Nihai hazırlama: **128×128 px**, RGBA; dışı saydam; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **1:1**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One simple pointing-hand cursor, index finger extended, warm ivory shape with charcoal outline. No multiple hands, background panel, labels or palette.
Use a 1:1 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 32 · cursor_grab.png — İmleç — sürükleme

Nihai hazırlama: **128×128 px**, RGBA; dışı saydam; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **1:1**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One simple closed grasping-hand cursor, warm ivory shape with charcoal outline. No multiple hands, symbols, panel, labels or palette.
Use a 1:1 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 33 · cursor_busy.png — İmleç — bekleme

Nihai hazırlama: **128×128 px**, RGBA; dışı saydam; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **1:1**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One compact static busy cursor symbol: a small open ceramic oil lamp silhouette with a single amber flame. Strong readable contour. No rotation sequence, extra frames, glass chimney, scene, panel or palette.
Use a 1:1 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 34 · icon_akce.png — İkon — Akçe

Nihai hazırlama: **256×256 px**, RGBA; dışı saydam; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **1:1**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One centered game UI icon depicting a single worn round silver coin with a blank face. Use a strong readable silhouette and a generous clear outer margin. Keep it readable when shown small. No extra objects, background scene, tiny engraved marks or labels.
Use a 1:1 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 35 · icon_erzak.png — İkon — Erzak

Nihai hazırlama: **256×256 px**, RGBA; dışı saydam; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **1:1**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One centered game UI icon depicting a small grain sack with a few visible wheat grains. Use a strong readable silhouette and a generous clear outer margin. Keep it readable when shown small. No extra objects, background scene, tiny engraved marks or labels.
Use a 1:1 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 36 · icon_odun.png — İkon — Odun

Nihai hazırlama: **256×256 px**, RGBA; dışı saydam; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **1:1**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One centered game UI icon depicting two short stacked firewood logs. Use a strong readable silhouette and a generous clear outer margin. Keep it readable when shown small. No extra objects, background scene, tiny engraved marks or labels.
Use a 1:1 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 37 · icon_tas.png — İkon — Taş

Nihai hazırlama: **256×256 px**, RGBA; dışı saydam; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **1:1**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One centered game UI icon depicting three rough angular quarry stones. Use a strong readable silhouette and a generous clear outer margin. Keep it readable when shown small. No extra objects, background scene, tiny engraved marks or labels.
Use a 1:1 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 38 · icon_demir.png — İkon — Demir

Nihai hazırlama: **256×256 px**, RGBA; dışı saydam; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **1:1**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One centered game UI icon depicting one simple iron ingot. Use a strong readable silhouette and a generous clear outer margin. Keep it readable when shown small. No extra objects, background scene, tiny engraved marks or labels.
Use a 1:1 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 39 · icon_bez.png — İkon — Bez

Nihai hazırlama: **256×256 px**, RGBA; dışı saydam; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **1:1**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One centered game UI icon depicting a folded coarse woven cloth. Use a strong readable silhouette and a generous clear outer margin. Keep it readable when shown small. No extra objects, background scene, tiny engraved marks or labels.
Use a 1:1 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 40 · icon_alet.png — İkon — Alet

Nihai hazırlama: **256×256 px**, RGBA; dışı saydam; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **1:1**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One centered game UI icon depicting one small hand hammer and simple chisel. Use a strong readable silhouette and a generous clear outer margin. Keep it readable when shown small. No extra objects, background scene, tiny engraved marks or labels.
Use a 1:1 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 41 · icon_nufus.png — İkon — Nüfus

Nihai hazırlama: **256×256 px**, RGBA; dışı saydam; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **1:1**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One centered game UI icon depicting two distinct human head-and-shoulder silhouettes. Use a strong readable silhouette and a generous clear outer margin. Keep it readable when shown small. No extra objects, background scene, tiny engraved marks or labels.
Use a 1:1 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 42 · icon_yatak.png — İkon — Yatak

Nihai hazırlama: **256×256 px**, RGBA; dışı saydam; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **1:1**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One centered game UI icon depicting one simple wooden bed with a blanket. Use a strong readable silhouette and a generous clear outer margin. Keep it readable when shown small. No extra objects, background scene, tiny engraved marks or labels.
Use a 1:1 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 43 · icon_saglik.png — İkon — Sağlık

Nihai hazırlama: **256×256 px**, RGBA; dışı saydam; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **1:1**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One centered game UI icon depicting a mortar and pestle with one herb leaf. Use a strong readable silhouette and a generous clear outer margin. Keep it readable when shown small. No extra objects, background scene, tiny engraved marks or labels.
Use a 1:1 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 44 · icon_moral.png — İkon — Moral

Nihai hazırlama: **256×256 px**, RGBA; dışı saydam; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **1:1**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One centered game UI icon depicting a small upright oil-lamp flame with protective hands. Use a strong readable silhouette and a generous clear outer margin. Keep it readable when shown small. No extra objects, background scene, tiny engraved marks or labels.
Use a 1:1 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 45 · icon_guvenlik.png — İkon — Güvenlik

Nihai hazırlama: **256×256 px**, RGBA; dışı saydam; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **1:1**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One centered game UI icon depicting a plain round shield with no heraldry. Use a strong readable silhouette and a generous clear outer margin. Keep it readable when shown small. No extra objects, background scene, tiny engraved marks or labels.
Use a 1:1 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 46 · icon_adalet.png — İkon — Adalet

Nihai hazırlama: **256×256 px**, RGBA; dışı saydam; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **1:1**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One centered game UI icon depicting a simple balanced two-pan scale. Use a strong readable silhouette and a generous clear outer margin. Keep it readable when shown small. No extra objects, background scene, tiny engraved marks or labels.
Use a 1:1 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 47 · icon_gun.png — İkon — Gün / zaman

Nihai hazırlama: **256×256 px**, RGBA; dışı saydam; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **1:1**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One centered game UI icon depicting a plain sun disk with short rays. Use a strong readable silhouette and a generous clear outer margin. Keep it readable when shown small. No extra objects, background scene, tiny engraved marks or labels.
Use a 1:1 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 48 · icon_kabul.png — İkon — Kabul

Nihai hazırlama: **256×256 px**, RGBA; dışı saydam; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **1:1**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One centered game UI icon depicting a bold clean check mark inside a simple border. Use a strong readable silhouette and a generous clear outer margin. Keep it readable when shown small. No extra objects, background scene, tiny engraved marks or labels.
Use a 1:1 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 49 · icon_ret.png — İkon — Ret

Nihai hazırlama: **256×256 px**, RGBA; dışı saydam; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **1:1**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One centered game UI icon depicting a bold clean diagonal cross inside a simple border. Use a strong readable silhouette and a generous clear outer margin. Keep it readable when shown small. No extra objects, background scene, tiny engraved marks or labels.
Use a 1:1 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 50 · icon_uyari.png — İkon — Uyarı

Nihai hazırlama: **256×256 px**, RGBA; dışı saydam; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **1:1**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One centered game UI icon depicting a triangular warning outline with one solid central vertical stroke. Use a strong readable silhouette and a generous clear outer margin. Keep it readable when shown small. No extra objects, background scene, tiny engraved marks or labels.
Use a 1:1 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 51 · icon_kilit.png — İkon — Kilit

Nihai hazırlama: **256×256 px**, RGBA; dışı saydam; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **1:1**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One centered game UI icon depicting a simple closed iron padlock. Use a strong readable silhouette and a generous clear outer margin. Keep it readable when shown small. No extra objects, background scene, tiny engraved marks or labels.
Use a 1:1 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 52 · icon_geri.png — İkon — Geri

Nihai hazırlama: **256×256 px**, RGBA; dışı saydam; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **1:1**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One centered game UI icon depicting one broad left-pointing arrow. Use a strong readable silhouette and a generous clear outer margin. Keep it readable when shown small. No extra objects, background scene, tiny engraved marks or labels.
Use a 1:1 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 53 · icon_kapat.png — İkon — Kapat

Nihai hazırlama: **256×256 px**, RGBA; dışı saydam; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **1:1**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One centered game UI icon depicting one clear X-shaped close mark without a surrounding frame. Use a strong readable silhouette and a generous clear outer margin. Keep it readable when shown small. No extra objects, background scene, tiny engraved marks or labels.
Use a 1:1 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 54 · icon_ayarlar.png — İkon — Ayarlar

Nihai hazırlama: **256×256 px**, RGBA; dışı saydam; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **1:1**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One centered game UI icon depicting three simple horizontal adjustment lines with clearly offset sliders. Use a strong readable silhouette and a generous clear outer margin. Keep it readable when shown small. No extra objects, background scene, tiny engraved marks or labels.
Use a 1:1 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 55 · icon_kaydet.png — İkon — Kaydet

Nihai hazırlama: **256×256 px**, RGBA; dışı saydam; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **1:1**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One centered game UI icon depicting a tied folded document packet with a blank seal, not a floppy disk. Use a strong readable silhouette and a generous clear outer margin. Keep it readable when shown small. No extra objects, background scene, tiny engraved marks or labels.
Use a 1:1 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 56 · icon_harita.png — İkon — Harita

Nihai hazırlama: **256×256 px**, RGBA; dışı saydam; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **1:1**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One centered game UI icon depicting a folded blank map with one simple route stroke and no labels. Use a strong readable silhouette and a generous clear outer margin. Keep it readable when shown small. No extra objects, background scene, tiny engraved marks or labels.
Use a 1:1 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

### 57 · icon_diyalog.png — İkon — Diyalog

Nihai hazırlama: **256×256 px**, RGBA; dışı saydam; 9-slice **0/0/0/0 — uygulanmaz**.

Üretim için kaynak tuvali: **1:1**; final çözünürlük indirme sonrası hazırlanır.

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Smoky dark timber, worn cool iron, restrained amber oil-lamp highlights; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43, ivory #E6DDC6. Painterly ink-and-gouache shading, matte surfaces, simple readable contours.
One centered game UI icon depicting two overlapping blank speech silhouettes. Use a strong readable silhouette and a generous clear outer margin. Keep it readable when shown small. No extra objects, background scene, tiny engraved marks or labels.
Use a 1:1 source canvas. Use a flat uniform solid magenta (#FF00FF) background for later masking. Keep magenta out of the object and its highlights. No pink reflected light, background texture or cast shadow on the background. Leave clean empty space around the complete unclipped object.
If a style reference is attached, borrow only its palette, material treatment and brushwork; do not copy its layout or add its objects.
no text, no letters, no numbers, no pseudo-calligraphy, no logo, no palette swatches, no measurements, no labels, no checkerboard, no contact sheet, no website mockup, no additional objects, no 3D render.
```

## İsteğe bağlı küçük animasyon denemesi — beş karelik göz kırpma

Bu bölüm mevcut 57 slotun dışında bir **deneme**; bütün köylüler için portre listesi veya 3D animasyon işi değildir. Önce yalnız bir portrede dene. Son oyun kareleri `blink_000.png`…`blink_004.png`, her biri 512×640 RGBA, 9-slice yok. Her üretimde aynı temel `blink_000` resmi gerçekten eklenir. Ortak tuval/baş konumu sabit tutulur; kareler ayrı ayrı sıkı kırpılmaz. `blink_004`, `blink_000` dosyasının aynısıdır, yeniden çizdirilmez.

| Kare | Üretim | Hareket |
|---|---|---|
| 000 | Aşağıdaki temel prompt | Gözler açık; onaylı ana resim |
| 001 | Aynı ana resmin düzenlemesi | Yarı kapalı göz |
| 002 | Aynı ana resmin düzenlemesi | Tam kapalı göz |
| 003 | Aynı ana resmin düzenlemesi | Yeniden yarı açık göz |
| 004 | 000 kopyası | İlk pozla aynı; normal pozda bekleme |

Temel kare için varsa onaylı bir kendi portremizi referans olarak ekle. Olmuyorsa sıfırdan tek deneme yüzü çizilebilir; oyun karakteri kimliği atanmaz.

### Animasyon A · blink_000 kaynak resmi

```text
Create ONE actual image now.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
One front-facing shoulders-up portrait of an adult Anatolian gate villager wearing plain period-appropriate wool clothing. Calm neutral expression, both eyes naturally open, head upright. Keep the complete head and shoulders unclipped. Painterly charcoal and muted timber tones with restrained amber light and ivory highlights. No portrait frame or surrounding scene. Use a 4:5 canvas and a flat solid magenta (#FF00FF) background for later masking, with no magenta in the person or reflected light. If an approved portrait reference is attached, preserve that person's identity, clothes and framing. no text, no letters, no numbers, no palette swatches, no checkerboard, no contact sheet, no 3D render.
```

### Animasyon B · blink_001

Gemini’ye **blink_000 temelini** tekrar ekle.

```text
Create ONE edited image from the attached approved base portrait, not a new portrait.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Change only the eyelids: Lower both upper eyelids halfway in a natural blink. Keep the identity, face, head position, shoulders, clothing, camera, canvas, scale, lighting, brushwork and flat magenta background as close to the base as possible. No head movement, new shadows, crop, zoom or added objects. no text, no letters, no numbers, no checkerboard, no palette swatches, no frame labels, no contact sheet, no 3D render.
```

### Animasyon C · blink_002

Gemini’ye **blink_000 temelini** tekrar ekle.

```text
Create ONE edited image from the attached approved base portrait, not a new portrait.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Change only the eyelids: Close both eyelids naturally without squeezing or changing the expression. Keep the identity, face, head position, shoulders, clothing, camera, canvas, scale, lighting, brushwork and flat magenta background as close to the base as possible. No head movement, new shadows, crop, zoom or added objects. no text, no letters, no numbers, no checkerboard, no palette swatches, no frame labels, no contact sheet, no 3D render.
```

### Animasyon D · blink_003

Gemini’ye **blink_000 temelini** tekrar ekle.

```text
Create ONE edited image from the attached approved base portrait, not a new portrait.
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.
Change only the eyelids: Raise both upper eyelids to the halfway-open point of a natural blink. Keep the identity, face, head position, shoulders, clothing, camera, canvas, scale, lighting, brushwork and flat magenta background as close to the base as possible. No head movement, new shadows, crop, zoom or added objects. no text, no letters, no numbers, no checkerboard, no palette swatches, no frame labels, no contact sheet, no 3D render.
```

Kabul: resimleri üst üste karşılaştır; göz çevresi dışında kayma/değişim varsa kareyi reddet veya editörde yalnız göz bölgesini temel resme birleştir. Onaylanan karelerin gerçek alfa maskesi hazırlanır, aynı pivot ve tuvalde Godot SpriteFrames'e alınır. Süreler göz kırpma ritmine göre seçilir; normal gözün beklemesi kapalı gözden daha uzun olabilir. Kamera/baş oynuyorsa daha fazla kare üretmek sorunu çözmez. Alev denemesinde de önce statik kandil tabanı ayrılmalı; bütün arka planın yeniden çizimi istenmemeli.
