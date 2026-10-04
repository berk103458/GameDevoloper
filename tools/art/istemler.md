# El ile üretim istemleri (Gemini uygulaması)

Bu dosya `tools/art/gemini_uret.py --istemler-md` ile **üretilir**; elle düzenlemeyin,
istemleri betikteki tablodan değiştirip yeniden üretin.

Gemini Pro aboneliği API kotası vermez; görselleri uygulamada el ile üretirsiniz:

1. https://gemini.google.com adresini açın (görsel üretimi açık bir model seçin).
2. Aşağıdan bir bölümün istemini kod bloğundan **olduğu gibi** kopyalayıp yapıştırın.
   Uygulama en-boy seçimi sunuyorsa bölümde yazan oranı seçin.
3. Çıkan görseli indirin (PNG, JPG ya da WEBP olabilir).
4. Dosyayı bölümde yazan **dosya adıyla** yeniden adlandırın (uzantı serbest)
   ve `tools/art/gelen/` klasörüne koyun.
5. Hepsi (ya da bir kısmı) hazır olunca depo kökünden çalıştırın:
   `python3 tools/art/gemini_uret.py --el-ile --yedek`
   Betik macenta arka planı siler, tam boyuta kırpar, palete oturtur ve sonucu
   `assets/art/` altına yazar. Eksik ve eşleşmeyen dosyaları raporlar.

Macenta (#FF00FF) arka plan istenen görsellerde arka plan **düz** ve **tek renk**
olmalı; gölge ya da zemin çizgisi varsa görseli yeniden üretin.


## char_aydogdu_idle_village

- Kaydedilecek ad: `tools/art/gelen/char_aydogdu_idle_village.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/char/char_aydogdu_idle_village.png`, 56 x 120 piksel
- İstenecek oran: **9:16**
- Arka plan: düz macenta #FF00FF (betik siler)

```text
STYLE: flat 2D game illustration in a bold graphic-novel ink style. Thick, confident ink-black outlines: heaviest on the outer silhouette, about half as thick for interior details (folds, face lines). Flat solid colour fills only. NO gradients, no soft shading, no airbrush, no glow, no bloom, no rim light haze, no texture noise, no grain, no dithering, no painterly brush strokes, no photorealism, no anime, no 3D render. It is night and the only warm light is a single torch: wherever the torch light touches a surface it is a hard-edged flat patch of torch amber; everything else is cold blue and near-black. STRICT PALETTE, use only these colours: night near-black #0D0F14 (background, voids, shadow); cold blue #4A6B8A (sky, stone, cloth, distant figures, the unlit side of faces); deep blue #24364A (second depth layer, distant layers, darker cloth); wood brown #3D2E24 (wood, leather, everything human-made); torch amber #C4843A (ONLY the torch flame and the hard-edged patches its light makes); ink black #06070A (outlines). No skin tone colour: a lit face is torch amber, an unlit face is cold blue. SETTING: the year 1243 on the Anatolian frontier (Seljuk borderland) while people flee the Mongol invasion. People are tired: low shoulders, head bowed forward, heavy eyelids, weight on one leg, no heroic or action poses, no evil or villain faces. Clothing of the period only: wool hood, felt cap, linen tunic, wrapped wool kaftan closed with ties or a sash, leather belt, sleeveless felt cloak, loose trousers, leg wraps, rawhide sandals or cloth-wrapped feet. FORBIDDEN: any text, letters, numbers, runes, writing, signatures, watermarks, logos or inscriptions; modern items (caps with visors, coats with collars, zippers, rows of buttons, metal buckles); fantasy armour, plate armour, horned helmets; later Ottoman turbans or fez; the colours red, green, gold or pink.

FRAMING: one small full-body standing figure for a village view, head to feet, front view, centred, feet at the bottom. It will be shown only about 100 pixels tall, so use very bold simple shapes: a readable silhouette, no facial features (the hood or headwear shape is enough), no folds, one thin uniform outline. A single hard-edged torch amber patch on the left side of the body, the rest cold blue, deep blue and wood brown.

SUBJECT: Aydogdu, a young Turkmen archer: thin moustache, wool hood, one forearm wrapped in a pale cloth BANDAGE (that hand raised near the chest so it is visible), a felt cloak draped over ONE shoulder only, a recurved composite BOW and a QUIVER of arrows on his back with the bow tip and arrow ends rising above the shoulder.

BACKGROUND: the subject stands alone on a perfectly flat, uniform, pure magenta #FF00FF background that fills the whole image edge to edge. No shadow, no ground, no floor line, no vignette, no frame, no border, nothing else in the background. Never use magenta, pink or purple anywhere on the subject itself.

IMAGE: aspect ratio 9:16 (portrait).
```

## char_aydogdu_neutral_card

- Kaydedilecek ad: `tools/art/gelen/char_aydogdu_neutral_card.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/char/char_aydogdu_neutral_card.png`, 600 x 760 piksel
- İstenecek oran: **4:5**
- Arka plan: düz macenta #FF00FF (betik siler)

```text
STYLE: flat 2D game illustration in a bold graphic-novel ink style. Thick, confident ink-black outlines: heaviest on the outer silhouette, about half as thick for interior details (folds, face lines). Flat solid colour fills only. NO gradients, no soft shading, no airbrush, no glow, no bloom, no rim light haze, no texture noise, no grain, no dithering, no painterly brush strokes, no photorealism, no anime, no 3D render. It is night and the only warm light is a single torch: wherever the torch light touches a surface it is a hard-edged flat patch of torch amber; everything else is cold blue and near-black. STRICT PALETTE, use only these colours: night near-black #0D0F14 (background, voids, shadow); cold blue #4A6B8A (sky, stone, cloth, distant figures, the unlit side of faces); deep blue #24364A (second depth layer, distant layers, darker cloth); wood brown #3D2E24 (wood, leather, everything human-made); torch amber #C4843A (ONLY the torch flame and the hard-edged patches its light makes); ink black #06070A (outlines). No skin tone colour: a lit face is torch amber, an unlit face is cold blue. SETTING: the year 1243 on the Anatolian frontier (Seljuk borderland) while people flee the Mongol invasion. People are tired: low shoulders, head bowed forward, heavy eyelids, weight on one leg, no heroic or action poses, no evil or villain faces. Clothing of the period only: wool hood, felt cap, linen tunic, wrapped wool kaftan closed with ties or a sash, leather belt, sleeveless felt cloak, loose trousers, leg wraps, rawhide sandals or cloth-wrapped feet. FORBIDDEN: any text, letters, numbers, runes, writing, signatures, watermarks, logos or inscriptions; modern items (caps with visors, coats with collars, zippers, rows of buttons, metal buckles); fantasy armour, plate armour, horned helmets; later Ottoman turbans or fez; the colours red, green, gold or pink.

FRAMING: character portrait card, chest-up (head, shoulders and upper chest), the figure centred and filling most of the image width, the chest cut off by the bottom edge of the image, a little empty space above the head. Three-quarter view toward the viewer. Tired neutral expression: heavy eyelids, a single ink line under each eye, mouth closed, head slightly bowed. LIGHT: one torch off to the left - the left half of the face and clothes is a flat hard-edged torch amber #C4843A patch, the right half of the face is flat cold blue #4A6B8A with ink-black shadow shapes; the boundary between them is one sharp line, no blending. Very thick outer outline, interior lines half as thick.

SUBJECT: Aydogdu, a young Turkmen archer: thin moustache, wool hood, one forearm wrapped in a pale cloth BANDAGE (that hand raised near the chest so it is visible), a felt cloak draped over ONE shoulder only, a recurved composite BOW and a QUIVER of arrows on his back with the bow tip and arrow ends rising above the shoulder.

BACKGROUND: the subject stands alone on a perfectly flat, uniform, pure magenta #FF00FF background that fills the whole image edge to edge. No shadow, no ground, no floor line, no vignette, no frame, no border, nothing else in the background. Never use magenta, pink or purple anywhere on the subject itself.

IMAGE: aspect ratio 4:5 (portrait).
```

## char_craftsman_01_idle_village

- Kaydedilecek ad: `tools/art/gelen/char_craftsman_01_idle_village.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/char/char_craftsman_01_idle_village.png`, 56 x 120 piksel
- İstenecek oran: **9:16**
- Arka plan: düz macenta #FF00FF (betik siler)

```text
STYLE: flat 2D game illustration in a bold graphic-novel ink style. Thick, confident ink-black outlines: heaviest on the outer silhouette, about half as thick for interior details (folds, face lines). Flat solid colour fills only. NO gradients, no soft shading, no airbrush, no glow, no bloom, no rim light haze, no texture noise, no grain, no dithering, no painterly brush strokes, no photorealism, no anime, no 3D render. It is night and the only warm light is a single torch: wherever the torch light touches a surface it is a hard-edged flat patch of torch amber; everything else is cold blue and near-black. STRICT PALETTE, use only these colours: night near-black #0D0F14 (background, voids, shadow); cold blue #4A6B8A (sky, stone, cloth, distant figures, the unlit side of faces); deep blue #24364A (second depth layer, distant layers, darker cloth); wood brown #3D2E24 (wood, leather, everything human-made); torch amber #C4843A (ONLY the torch flame and the hard-edged patches its light makes); ink black #06070A (outlines). No skin tone colour: a lit face is torch amber, an unlit face is cold blue. SETTING: the year 1243 on the Anatolian frontier (Seljuk borderland) while people flee the Mongol invasion. People are tired: low shoulders, head bowed forward, heavy eyelids, weight on one leg, no heroic or action poses, no evil or villain faces. Clothing of the period only: wool hood, felt cap, linen tunic, wrapped wool kaftan closed with ties or a sash, leather belt, sleeveless felt cloak, loose trousers, leg wraps, rawhide sandals or cloth-wrapped feet. FORBIDDEN: any text, letters, numbers, runes, writing, signatures, watermarks, logos or inscriptions; modern items (caps with visors, coats with collars, zippers, rows of buttons, metal buckles); fantasy armour, plate armour, horned helmets; later Ottoman turbans or fez; the colours red, green, gold or pink.

FRAMING: one small full-body standing figure for a village view, head to feet, front view, centred, feet at the bottom. It will be shown only about 100 pixels tall, so use very bold simple shapes: a readable silhouette, no facial features (the hood or headwear shape is enough), no folds, one thin uniform outline. A single hard-edged torch amber patch on the left side of the body, the rest cold blue, deep blue and wood brown.

SUBJECT: A craftsman (not a guild master): wool hood, tunic, a leather strap across the chest to a tool bag on his hip with a small hammer handle sticking out, a tied bundle on his back rising above one shoulder.

BACKGROUND: the subject stands alone on a perfectly flat, uniform, pure magenta #FF00FF background that fills the whole image edge to edge. No shadow, no ground, no floor line, no vignette, no frame, no border, nothing else in the background. Never use magenta, pink or purple anywhere on the subject itself.

IMAGE: aspect ratio 9:16 (portrait).
```

## char_craftsman_01_neutral_card

- Kaydedilecek ad: `tools/art/gelen/char_craftsman_01_neutral_card.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/char/char_craftsman_01_neutral_card.png`, 600 x 760 piksel
- İstenecek oran: **4:5**
- Arka plan: düz macenta #FF00FF (betik siler)

```text
STYLE: flat 2D game illustration in a bold graphic-novel ink style. Thick, confident ink-black outlines: heaviest on the outer silhouette, about half as thick for interior details (folds, face lines). Flat solid colour fills only. NO gradients, no soft shading, no airbrush, no glow, no bloom, no rim light haze, no texture noise, no grain, no dithering, no painterly brush strokes, no photorealism, no anime, no 3D render. It is night and the only warm light is a single torch: wherever the torch light touches a surface it is a hard-edged flat patch of torch amber; everything else is cold blue and near-black. STRICT PALETTE, use only these colours: night near-black #0D0F14 (background, voids, shadow); cold blue #4A6B8A (sky, stone, cloth, distant figures, the unlit side of faces); deep blue #24364A (second depth layer, distant layers, darker cloth); wood brown #3D2E24 (wood, leather, everything human-made); torch amber #C4843A (ONLY the torch flame and the hard-edged patches its light makes); ink black #06070A (outlines). No skin tone colour: a lit face is torch amber, an unlit face is cold blue. SETTING: the year 1243 on the Anatolian frontier (Seljuk borderland) while people flee the Mongol invasion. People are tired: low shoulders, head bowed forward, heavy eyelids, weight on one leg, no heroic or action poses, no evil or villain faces. Clothing of the period only: wool hood, felt cap, linen tunic, wrapped wool kaftan closed with ties or a sash, leather belt, sleeveless felt cloak, loose trousers, leg wraps, rawhide sandals or cloth-wrapped feet. FORBIDDEN: any text, letters, numbers, runes, writing, signatures, watermarks, logos or inscriptions; modern items (caps with visors, coats with collars, zippers, rows of buttons, metal buckles); fantasy armour, plate armour, horned helmets; later Ottoman turbans or fez; the colours red, green, gold or pink.

FRAMING: character portrait card, chest-up (head, shoulders and upper chest), the figure centred and filling most of the image width, the chest cut off by the bottom edge of the image, a little empty space above the head. Three-quarter view toward the viewer. Tired neutral expression: heavy eyelids, a single ink line under each eye, mouth closed, head slightly bowed. LIGHT: one torch off to the left - the left half of the face and clothes is a flat hard-edged torch amber #C4843A patch, the right half of the face is flat cold blue #4A6B8A with ink-black shadow shapes; the boundary between them is one sharp line, no blending. Very thick outer outline, interior lines half as thick.

SUBJECT: A craftsman (not a guild master): wool hood, tunic, a leather strap across the chest to a tool bag on his hip with a small hammer handle sticking out, a tied bundle on his back rising above one shoulder.

BACKGROUND: the subject stands alone on a perfectly flat, uniform, pure magenta #FF00FF background that fills the whole image edge to edge. No shadow, no ground, no floor line, no vignette, no frame, no border, nothing else in the background. Never use magenta, pink or purple anywhere on the subject itself.

IMAGE: aspect ratio 4:5 (portrait).
```

## char_farmer_01_idle_village

- Kaydedilecek ad: `tools/art/gelen/char_farmer_01_idle_village.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/char/char_farmer_01_idle_village.png`, 56 x 120 piksel
- İstenecek oran: **9:16**
- Arka plan: düz macenta #FF00FF (betik siler)

```text
STYLE: flat 2D game illustration in a bold graphic-novel ink style. Thick, confident ink-black outlines: heaviest on the outer silhouette, about half as thick for interior details (folds, face lines). Flat solid colour fills only. NO gradients, no soft shading, no airbrush, no glow, no bloom, no rim light haze, no texture noise, no grain, no dithering, no painterly brush strokes, no photorealism, no anime, no 3D render. It is night and the only warm light is a single torch: wherever the torch light touches a surface it is a hard-edged flat patch of torch amber; everything else is cold blue and near-black. STRICT PALETTE, use only these colours: night near-black #0D0F14 (background, voids, shadow); cold blue #4A6B8A (sky, stone, cloth, distant figures, the unlit side of faces); deep blue #24364A (second depth layer, distant layers, darker cloth); wood brown #3D2E24 (wood, leather, everything human-made); torch amber #C4843A (ONLY the torch flame and the hard-edged patches its light makes); ink black #06070A (outlines). No skin tone colour: a lit face is torch amber, an unlit face is cold blue. SETTING: the year 1243 on the Anatolian frontier (Seljuk borderland) while people flee the Mongol invasion. People are tired: low shoulders, head bowed forward, heavy eyelids, weight on one leg, no heroic or action poses, no evil or villain faces. Clothing of the period only: wool hood, felt cap, linen tunic, wrapped wool kaftan closed with ties or a sash, leather belt, sleeveless felt cloak, loose trousers, leg wraps, rawhide sandals or cloth-wrapped feet. FORBIDDEN: any text, letters, numbers, runes, writing, signatures, watermarks, logos or inscriptions; modern items (caps with visors, coats with collars, zippers, rows of buttons, metal buckles); fantasy armour, plate armour, horned helmets; later Ottoman turbans or fez; the colours red, green, gold or pink.

FRAMING: one small full-body standing figure for a village view, head to feet, front view, centred, feet at the bottom. It will be shown only about 100 pixels tall, so use very bold simple shapes: a readable silhouette, no facial features (the hood or headwear shape is enough), no folds, one thin uniform outline. A single hard-edged torch amber patch on the left side of the body, the rest cold blue, deep blue and wood brown.

SUBJECT: A male farmer: wool hood, plain tunic, a wooden carrying YOKE across both shoulders with ropes hanging down at each end - a wide horizontal shape.

BACKGROUND: the subject stands alone on a perfectly flat, uniform, pure magenta #FF00FF background that fills the whole image edge to edge. No shadow, no ground, no floor line, no vignette, no frame, no border, nothing else in the background. Never use magenta, pink or purple anywhere on the subject itself.

IMAGE: aspect ratio 9:16 (portrait).
```

## char_farmer_01_neutral_card

- Kaydedilecek ad: `tools/art/gelen/char_farmer_01_neutral_card.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/char/char_farmer_01_neutral_card.png`, 600 x 760 piksel
- İstenecek oran: **4:5**
- Arka plan: düz macenta #FF00FF (betik siler)

```text
STYLE: flat 2D game illustration in a bold graphic-novel ink style. Thick, confident ink-black outlines: heaviest on the outer silhouette, about half as thick for interior details (folds, face lines). Flat solid colour fills only. NO gradients, no soft shading, no airbrush, no glow, no bloom, no rim light haze, no texture noise, no grain, no dithering, no painterly brush strokes, no photorealism, no anime, no 3D render. It is night and the only warm light is a single torch: wherever the torch light touches a surface it is a hard-edged flat patch of torch amber; everything else is cold blue and near-black. STRICT PALETTE, use only these colours: night near-black #0D0F14 (background, voids, shadow); cold blue #4A6B8A (sky, stone, cloth, distant figures, the unlit side of faces); deep blue #24364A (second depth layer, distant layers, darker cloth); wood brown #3D2E24 (wood, leather, everything human-made); torch amber #C4843A (ONLY the torch flame and the hard-edged patches its light makes); ink black #06070A (outlines). No skin tone colour: a lit face is torch amber, an unlit face is cold blue. SETTING: the year 1243 on the Anatolian frontier (Seljuk borderland) while people flee the Mongol invasion. People are tired: low shoulders, head bowed forward, heavy eyelids, weight on one leg, no heroic or action poses, no evil or villain faces. Clothing of the period only: wool hood, felt cap, linen tunic, wrapped wool kaftan closed with ties or a sash, leather belt, sleeveless felt cloak, loose trousers, leg wraps, rawhide sandals or cloth-wrapped feet. FORBIDDEN: any text, letters, numbers, runes, writing, signatures, watermarks, logos or inscriptions; modern items (caps with visors, coats with collars, zippers, rows of buttons, metal buckles); fantasy armour, plate armour, horned helmets; later Ottoman turbans or fez; the colours red, green, gold or pink.

FRAMING: character portrait card, chest-up (head, shoulders and upper chest), the figure centred and filling most of the image width, the chest cut off by the bottom edge of the image, a little empty space above the head. Three-quarter view toward the viewer. Tired neutral expression: heavy eyelids, a single ink line under each eye, mouth closed, head slightly bowed. LIGHT: one torch off to the left - the left half of the face and clothes is a flat hard-edged torch amber #C4843A patch, the right half of the face is flat cold blue #4A6B8A with ink-black shadow shapes; the boundary between them is one sharp line, no blending. Very thick outer outline, interior lines half as thick.

SUBJECT: A male farmer: wool hood, plain tunic, a wooden carrying YOKE across both shoulders with ropes hanging down at each end - a wide horizontal shape.

BACKGROUND: the subject stands alone on a perfectly flat, uniform, pure magenta #FF00FF background that fills the whole image edge to edge. No shadow, no ground, no floor line, no vignette, no frame, no border, nothing else in the background. Never use magenta, pink or purple anywhere on the subject itself.

IMAGE: aspect ratio 4:5 (portrait).
```

## char_farmer_02_idle_village

- Kaydedilecek ad: `tools/art/gelen/char_farmer_02_idle_village.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/char/char_farmer_02_idle_village.png`, 56 x 120 piksel
- İstenecek oran: **9:16**
- Arka plan: düz macenta #FF00FF (betik siler)

```text
STYLE: flat 2D game illustration in a bold graphic-novel ink style. Thick, confident ink-black outlines: heaviest on the outer silhouette, about half as thick for interior details (folds, face lines). Flat solid colour fills only. NO gradients, no soft shading, no airbrush, no glow, no bloom, no rim light haze, no texture noise, no grain, no dithering, no painterly brush strokes, no photorealism, no anime, no 3D render. It is night and the only warm light is a single torch: wherever the torch light touches a surface it is a hard-edged flat patch of torch amber; everything else is cold blue and near-black. STRICT PALETTE, use only these colours: night near-black #0D0F14 (background, voids, shadow); cold blue #4A6B8A (sky, stone, cloth, distant figures, the unlit side of faces); deep blue #24364A (second depth layer, distant layers, darker cloth); wood brown #3D2E24 (wood, leather, everything human-made); torch amber #C4843A (ONLY the torch flame and the hard-edged patches its light makes); ink black #06070A (outlines). No skin tone colour: a lit face is torch amber, an unlit face is cold blue. SETTING: the year 1243 on the Anatolian frontier (Seljuk borderland) while people flee the Mongol invasion. People are tired: low shoulders, head bowed forward, heavy eyelids, weight on one leg, no heroic or action poses, no evil or villain faces. Clothing of the period only: wool hood, felt cap, linen tunic, wrapped wool kaftan closed with ties or a sash, leather belt, sleeveless felt cloak, loose trousers, leg wraps, rawhide sandals or cloth-wrapped feet. FORBIDDEN: any text, letters, numbers, runes, writing, signatures, watermarks, logos or inscriptions; modern items (caps with visors, coats with collars, zippers, rows of buttons, metal buckles); fantasy armour, plate armour, horned helmets; later Ottoman turbans or fez; the colours red, green, gold or pink.

FRAMING: one small full-body standing figure for a village view, head to feet, front view, centred, feet at the bottom. It will be shown only about 100 pixels tall, so use very bold simple shapes: a readable silhouette, no facial features (the hood or headwear shape is enough), no folds, one thin uniform outline. A single hard-edged torch amber patch on the left side of the body, the rest cold blue, deep blue and wood brown.

SUBJECT: A female farmer: plain headscarf, wool dress, a SICKLE held low in one hand at her side.

BACKGROUND: the subject stands alone on a perfectly flat, uniform, pure magenta #FF00FF background that fills the whole image edge to edge. No shadow, no ground, no floor line, no vignette, no frame, no border, nothing else in the background. Never use magenta, pink or purple anywhere on the subject itself.

IMAGE: aspect ratio 9:16 (portrait).
```

## char_farmer_02_neutral_card

- Kaydedilecek ad: `tools/art/gelen/char_farmer_02_neutral_card.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/char/char_farmer_02_neutral_card.png`, 600 x 760 piksel
- İstenecek oran: **4:5**
- Arka plan: düz macenta #FF00FF (betik siler)

```text
STYLE: flat 2D game illustration in a bold graphic-novel ink style. Thick, confident ink-black outlines: heaviest on the outer silhouette, about half as thick for interior details (folds, face lines). Flat solid colour fills only. NO gradients, no soft shading, no airbrush, no glow, no bloom, no rim light haze, no texture noise, no grain, no dithering, no painterly brush strokes, no photorealism, no anime, no 3D render. It is night and the only warm light is a single torch: wherever the torch light touches a surface it is a hard-edged flat patch of torch amber; everything else is cold blue and near-black. STRICT PALETTE, use only these colours: night near-black #0D0F14 (background, voids, shadow); cold blue #4A6B8A (sky, stone, cloth, distant figures, the unlit side of faces); deep blue #24364A (second depth layer, distant layers, darker cloth); wood brown #3D2E24 (wood, leather, everything human-made); torch amber #C4843A (ONLY the torch flame and the hard-edged patches its light makes); ink black #06070A (outlines). No skin tone colour: a lit face is torch amber, an unlit face is cold blue. SETTING: the year 1243 on the Anatolian frontier (Seljuk borderland) while people flee the Mongol invasion. People are tired: low shoulders, head bowed forward, heavy eyelids, weight on one leg, no heroic or action poses, no evil or villain faces. Clothing of the period only: wool hood, felt cap, linen tunic, wrapped wool kaftan closed with ties or a sash, leather belt, sleeveless felt cloak, loose trousers, leg wraps, rawhide sandals or cloth-wrapped feet. FORBIDDEN: any text, letters, numbers, runes, writing, signatures, watermarks, logos or inscriptions; modern items (caps with visors, coats with collars, zippers, rows of buttons, metal buckles); fantasy armour, plate armour, horned helmets; later Ottoman turbans or fez; the colours red, green, gold or pink.

FRAMING: character portrait card, chest-up (head, shoulders and upper chest), the figure centred and filling most of the image width, the chest cut off by the bottom edge of the image, a little empty space above the head. Three-quarter view toward the viewer. Tired neutral expression: heavy eyelids, a single ink line under each eye, mouth closed, head slightly bowed. LIGHT: one torch off to the left - the left half of the face and clothes is a flat hard-edged torch amber #C4843A patch, the right half of the face is flat cold blue #4A6B8A with ink-black shadow shapes; the boundary between them is one sharp line, no blending. Very thick outer outline, interior lines half as thick.

SUBJECT: A female farmer: plain headscarf, wool dress, a SICKLE held low in one hand at her side.

BACKGROUND: the subject stands alone on a perfectly flat, uniform, pure magenta #FF00FF background that fills the whole image edge to edge. No shadow, no ground, no floor line, no vignette, no frame, no border, nothing else in the background. Never use magenta, pink or purple anywhere on the subject itself.

IMAGE: aspect ratio 4:5 (portrait).
```

## char_karaca_usta_idle_village

- Kaydedilecek ad: `tools/art/gelen/char_karaca_usta_idle_village.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/char/char_karaca_usta_idle_village.png`, 56 x 120 piksel
- İstenecek oran: **9:16**
- Arka plan: düz macenta #FF00FF (betik siler)

```text
STYLE: flat 2D game illustration in a bold graphic-novel ink style. Thick, confident ink-black outlines: heaviest on the outer silhouette, about half as thick for interior details (folds, face lines). Flat solid colour fills only. NO gradients, no soft shading, no airbrush, no glow, no bloom, no rim light haze, no texture noise, no grain, no dithering, no painterly brush strokes, no photorealism, no anime, no 3D render. It is night and the only warm light is a single torch: wherever the torch light touches a surface it is a hard-edged flat patch of torch amber; everything else is cold blue and near-black. STRICT PALETTE, use only these colours: night near-black #0D0F14 (background, voids, shadow); cold blue #4A6B8A (sky, stone, cloth, distant figures, the unlit side of faces); deep blue #24364A (second depth layer, distant layers, darker cloth); wood brown #3D2E24 (wood, leather, everything human-made); torch amber #C4843A (ONLY the torch flame and the hard-edged patches its light makes); ink black #06070A (outlines). No skin tone colour: a lit face is torch amber, an unlit face is cold blue. SETTING: the year 1243 on the Anatolian frontier (Seljuk borderland) while people flee the Mongol invasion. People are tired: low shoulders, head bowed forward, heavy eyelids, weight on one leg, no heroic or action poses, no evil or villain faces. Clothing of the period only: wool hood, felt cap, linen tunic, wrapped wool kaftan closed with ties or a sash, leather belt, sleeveless felt cloak, loose trousers, leg wraps, rawhide sandals or cloth-wrapped feet. FORBIDDEN: any text, letters, numbers, runes, writing, signatures, watermarks, logos or inscriptions; modern items (caps with visors, coats with collars, zippers, rows of buttons, metal buckles); fantasy armour, plate armour, horned helmets; later Ottoman turbans or fez; the colours red, green, gold or pink.

FRAMING: one small full-body standing figure for a village view, head to feet, front view, centred, feet at the bottom. It will be shown only about 100 pixels tall, so use very bold simple shapes: a readable silhouette, no facial features (the hood or headwear shape is enough), no folds, one thin uniform outline. A single hard-edged torch amber patch on the left side of the body, the rest cold blue, deep blue and wood brown.

SUBJECT: Karaca Usta, an older Ahi master tanner from Kayseri: grey short beard, felt cap, a ROLLED ANIMAL HIDE tied horizontally across his back so it rises above both shoulders, wool kaftan, and the Ahi guild SASH (sed): a wide cloth sash tied over the leather belt with a knot whose two ENDS STICK OUT sideways beyond the body outline. Frame slightly lower than usual so the sash knot at the waist is visible.

BACKGROUND: the subject stands alone on a perfectly flat, uniform, pure magenta #FF00FF background that fills the whole image edge to edge. No shadow, no ground, no floor line, no vignette, no frame, no border, nothing else in the background. Never use magenta, pink or purple anywhere on the subject itself.

IMAGE: aspect ratio 9:16 (portrait).
```

## char_karaca_usta_neutral_card

- Kaydedilecek ad: `tools/art/gelen/char_karaca_usta_neutral_card.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/char/char_karaca_usta_neutral_card.png`, 600 x 760 piksel
- İstenecek oran: **4:5**
- Arka plan: düz macenta #FF00FF (betik siler)

```text
STYLE: flat 2D game illustration in a bold graphic-novel ink style. Thick, confident ink-black outlines: heaviest on the outer silhouette, about half as thick for interior details (folds, face lines). Flat solid colour fills only. NO gradients, no soft shading, no airbrush, no glow, no bloom, no rim light haze, no texture noise, no grain, no dithering, no painterly brush strokes, no photorealism, no anime, no 3D render. It is night and the only warm light is a single torch: wherever the torch light touches a surface it is a hard-edged flat patch of torch amber; everything else is cold blue and near-black. STRICT PALETTE, use only these colours: night near-black #0D0F14 (background, voids, shadow); cold blue #4A6B8A (sky, stone, cloth, distant figures, the unlit side of faces); deep blue #24364A (second depth layer, distant layers, darker cloth); wood brown #3D2E24 (wood, leather, everything human-made); torch amber #C4843A (ONLY the torch flame and the hard-edged patches its light makes); ink black #06070A (outlines). No skin tone colour: a lit face is torch amber, an unlit face is cold blue. SETTING: the year 1243 on the Anatolian frontier (Seljuk borderland) while people flee the Mongol invasion. People are tired: low shoulders, head bowed forward, heavy eyelids, weight on one leg, no heroic or action poses, no evil or villain faces. Clothing of the period only: wool hood, felt cap, linen tunic, wrapped wool kaftan closed with ties or a sash, leather belt, sleeveless felt cloak, loose trousers, leg wraps, rawhide sandals or cloth-wrapped feet. FORBIDDEN: any text, letters, numbers, runes, writing, signatures, watermarks, logos or inscriptions; modern items (caps with visors, coats with collars, zippers, rows of buttons, metal buckles); fantasy armour, plate armour, horned helmets; later Ottoman turbans or fez; the colours red, green, gold or pink.

FRAMING: character portrait card, chest-up (head, shoulders and upper chest), the figure centred and filling most of the image width, the chest cut off by the bottom edge of the image, a little empty space above the head. Three-quarter view toward the viewer. Tired neutral expression: heavy eyelids, a single ink line under each eye, mouth closed, head slightly bowed. LIGHT: one torch off to the left - the left half of the face and clothes is a flat hard-edged torch amber #C4843A patch, the right half of the face is flat cold blue #4A6B8A with ink-black shadow shapes; the boundary between them is one sharp line, no blending. Very thick outer outline, interior lines half as thick.

SUBJECT: Karaca Usta, an older Ahi master tanner from Kayseri: grey short beard, felt cap, a ROLLED ANIMAL HIDE tied horizontally across his back so it rises above both shoulders, wool kaftan, and the Ahi guild SASH (sed): a wide cloth sash tied over the leather belt with a knot whose two ENDS STICK OUT sideways beyond the body outline. Frame slightly lower than usual so the sash knot at the waist is visible.

BACKGROUND: the subject stands alone on a perfectly flat, uniform, pure magenta #FF00FF background that fills the whole image edge to edge. No shadow, no ground, no floor line, no vignette, no frame, no border, nothing else in the background. Never use magenta, pink or purple anywhere on the subject itself.

IMAGE: aspect ratio 4:5 (portrait).
```

## char_miraen_idle_village

- Kaydedilecek ad: `tools/art/gelen/char_miraen_idle_village.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/char/char_miraen_idle_village.png`, 56 x 120 piksel
- İstenecek oran: **9:16**
- Arka plan: düz macenta #FF00FF (betik siler)

```text
STYLE: flat 2D game illustration in a bold graphic-novel ink style. Thick, confident ink-black outlines: heaviest on the outer silhouette, about half as thick for interior details (folds, face lines). Flat solid colour fills only. NO gradients, no soft shading, no airbrush, no glow, no bloom, no rim light haze, no texture noise, no grain, no dithering, no painterly brush strokes, no photorealism, no anime, no 3D render. It is night and the only warm light is a single torch: wherever the torch light touches a surface it is a hard-edged flat patch of torch amber; everything else is cold blue and near-black. STRICT PALETTE, use only these colours: night near-black #0D0F14 (background, voids, shadow); cold blue #4A6B8A (sky, stone, cloth, distant figures, the unlit side of faces); deep blue #24364A (second depth layer, distant layers, darker cloth); wood brown #3D2E24 (wood, leather, everything human-made); torch amber #C4843A (ONLY the torch flame and the hard-edged patches its light makes); ink black #06070A (outlines). No skin tone colour: a lit face is torch amber, an unlit face is cold blue. SETTING: the year 1243 on the Anatolian frontier (Seljuk borderland) while people flee the Mongol invasion. People are tired: low shoulders, head bowed forward, heavy eyelids, weight on one leg, no heroic or action poses, no evil or villain faces. Clothing of the period only: wool hood, felt cap, linen tunic, wrapped wool kaftan closed with ties or a sash, leather belt, sleeveless felt cloak, loose trousers, leg wraps, rawhide sandals or cloth-wrapped feet. FORBIDDEN: any text, letters, numbers, runes, writing, signatures, watermarks, logos or inscriptions; modern items (caps with visors, coats with collars, zippers, rows of buttons, metal buckles); fantasy armour, plate armour, horned helmets; later Ottoman turbans or fez; the colours red, green, gold or pink.

FRAMING: one small full-body standing figure for a village view, head to feet, front view, centred, feet at the bottom. It will be shown only about 100 pixels tall, so use very bold simple shapes: a readable silhouette, no facial features (the hood or headwear shape is enough), no folds, one thin uniform outline. A single hard-edged torch amber patch on the left side of the body, the rest cold blue, deep blue and wood brown.

SUBJECT: Miraen, a Georgian former cavalryman in his forties: lean weathered face, short dark beard, tall felt cap whose LONG TAIL falls down behind his head and back (his signature shape, it must stick out of the silhouette), worn wool kaftan wrapped and belted, a BROKEN curved sabre scabbard - empty, snapped short, no blade - slung so it shows at his side/over the shoulder.

BACKGROUND: the subject stands alone on a perfectly flat, uniform, pure magenta #FF00FF background that fills the whole image edge to edge. No shadow, no ground, no floor line, no vignette, no frame, no border, nothing else in the background. Never use magenta, pink or purple anywhere on the subject itself.

IMAGE: aspect ratio 9:16 (portrait).
```

## char_miraen_neutral_card

- Kaydedilecek ad: `tools/art/gelen/char_miraen_neutral_card.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/char/char_miraen_neutral_card.png`, 600 x 760 piksel
- İstenecek oran: **4:5**
- Arka plan: düz macenta #FF00FF (betik siler)

```text
STYLE: flat 2D game illustration in a bold graphic-novel ink style. Thick, confident ink-black outlines: heaviest on the outer silhouette, about half as thick for interior details (folds, face lines). Flat solid colour fills only. NO gradients, no soft shading, no airbrush, no glow, no bloom, no rim light haze, no texture noise, no grain, no dithering, no painterly brush strokes, no photorealism, no anime, no 3D render. It is night and the only warm light is a single torch: wherever the torch light touches a surface it is a hard-edged flat patch of torch amber; everything else is cold blue and near-black. STRICT PALETTE, use only these colours: night near-black #0D0F14 (background, voids, shadow); cold blue #4A6B8A (sky, stone, cloth, distant figures, the unlit side of faces); deep blue #24364A (second depth layer, distant layers, darker cloth); wood brown #3D2E24 (wood, leather, everything human-made); torch amber #C4843A (ONLY the torch flame and the hard-edged patches its light makes); ink black #06070A (outlines). No skin tone colour: a lit face is torch amber, an unlit face is cold blue. SETTING: the year 1243 on the Anatolian frontier (Seljuk borderland) while people flee the Mongol invasion. People are tired: low shoulders, head bowed forward, heavy eyelids, weight on one leg, no heroic or action poses, no evil or villain faces. Clothing of the period only: wool hood, felt cap, linen tunic, wrapped wool kaftan closed with ties or a sash, leather belt, sleeveless felt cloak, loose trousers, leg wraps, rawhide sandals or cloth-wrapped feet. FORBIDDEN: any text, letters, numbers, runes, writing, signatures, watermarks, logos or inscriptions; modern items (caps with visors, coats with collars, zippers, rows of buttons, metal buckles); fantasy armour, plate armour, horned helmets; later Ottoman turbans or fez; the colours red, green, gold or pink.

FRAMING: character portrait card, chest-up (head, shoulders and upper chest), the figure centred and filling most of the image width, the chest cut off by the bottom edge of the image, a little empty space above the head. Three-quarter view toward the viewer. Tired neutral expression: heavy eyelids, a single ink line under each eye, mouth closed, head slightly bowed. LIGHT: one torch off to the left - the left half of the face and clothes is a flat hard-edged torch amber #C4843A patch, the right half of the face is flat cold blue #4A6B8A with ink-black shadow shapes; the boundary between them is one sharp line, no blending. Very thick outer outline, interior lines half as thick.

SUBJECT: Miraen, a Georgian former cavalryman in his forties: lean weathered face, short dark beard, tall felt cap whose LONG TAIL falls down behind his head and back (his signature shape, it must stick out of the silhouette), worn wool kaftan wrapped and belted, a BROKEN curved sabre scabbard - empty, snapped short, no blade - slung so it shows at his side/over the shoulder.

BACKGROUND: the subject stands alone on a perfectly flat, uniform, pure magenta #FF00FF background that fills the whole image edge to edge. No shadow, no ground, no floor line, no vignette, no frame, no border, nothing else in the background. Never use magenta, pink or purple anywhere on the subject itself.

IMAGE: aspect ratio 4:5 (portrait).
```

## char_saruca_hatun_idle_village

- Kaydedilecek ad: `tools/art/gelen/char_saruca_hatun_idle_village.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/char/char_saruca_hatun_idle_village.png`, 56 x 120 piksel
- İstenecek oran: **9:16**
- Arka plan: düz macenta #FF00FF (betik siler)

```text
STYLE: flat 2D game illustration in a bold graphic-novel ink style. Thick, confident ink-black outlines: heaviest on the outer silhouette, about half as thick for interior details (folds, face lines). Flat solid colour fills only. NO gradients, no soft shading, no airbrush, no glow, no bloom, no rim light haze, no texture noise, no grain, no dithering, no painterly brush strokes, no photorealism, no anime, no 3D render. It is night and the only warm light is a single torch: wherever the torch light touches a surface it is a hard-edged flat patch of torch amber; everything else is cold blue and near-black. STRICT PALETTE, use only these colours: night near-black #0D0F14 (background, voids, shadow); cold blue #4A6B8A (sky, stone, cloth, distant figures, the unlit side of faces); deep blue #24364A (second depth layer, distant layers, darker cloth); wood brown #3D2E24 (wood, leather, everything human-made); torch amber #C4843A (ONLY the torch flame and the hard-edged patches its light makes); ink black #06070A (outlines). No skin tone colour: a lit face is torch amber, an unlit face is cold blue. SETTING: the year 1243 on the Anatolian frontier (Seljuk borderland) while people flee the Mongol invasion. People are tired: low shoulders, head bowed forward, heavy eyelids, weight on one leg, no heroic or action poses, no evil or villain faces. Clothing of the period only: wool hood, felt cap, linen tunic, wrapped wool kaftan closed with ties or a sash, leather belt, sleeveless felt cloak, loose trousers, leg wraps, rawhide sandals or cloth-wrapped feet. FORBIDDEN: any text, letters, numbers, runes, writing, signatures, watermarks, logos or inscriptions; modern items (caps with visors, coats with collars, zippers, rows of buttons, metal buckles); fantasy armour, plate armour, horned helmets; later Ottoman turbans or fez; the colours red, green, gold or pink.

FRAMING: one small full-body standing figure for a village view, head to feet, front view, centred, feet at the bottom. It will be shown only about 100 pixels tall, so use very bold simple shapes: a readable silhouette, no facial features (the hood or headwear shape is enough), no folds, one thin uniform outline. A single hard-edged torch amber patch on the left side of the body, the rest cold blue, deep blue and wood brown.

SUBJECT: Saruca Hatun, a widowed farm woman in her fifties: lined face, a LARGE TRIANGULAR HEADSCARF tied under her chin (her signature shape), plain wool dress, a coarse cloth GRAIN SACK tied with rope held against her shoulder and chest.

BACKGROUND: the subject stands alone on a perfectly flat, uniform, pure magenta #FF00FF background that fills the whole image edge to edge. No shadow, no ground, no floor line, no vignette, no frame, no border, nothing else in the background. Never use magenta, pink or purple anywhere on the subject itself.

IMAGE: aspect ratio 9:16 (portrait).
```

## char_saruca_hatun_neutral_card

- Kaydedilecek ad: `tools/art/gelen/char_saruca_hatun_neutral_card.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/char/char_saruca_hatun_neutral_card.png`, 600 x 760 piksel
- İstenecek oran: **4:5**
- Arka plan: düz macenta #FF00FF (betik siler)

```text
STYLE: flat 2D game illustration in a bold graphic-novel ink style. Thick, confident ink-black outlines: heaviest on the outer silhouette, about half as thick for interior details (folds, face lines). Flat solid colour fills only. NO gradients, no soft shading, no airbrush, no glow, no bloom, no rim light haze, no texture noise, no grain, no dithering, no painterly brush strokes, no photorealism, no anime, no 3D render. It is night and the only warm light is a single torch: wherever the torch light touches a surface it is a hard-edged flat patch of torch amber; everything else is cold blue and near-black. STRICT PALETTE, use only these colours: night near-black #0D0F14 (background, voids, shadow); cold blue #4A6B8A (sky, stone, cloth, distant figures, the unlit side of faces); deep blue #24364A (second depth layer, distant layers, darker cloth); wood brown #3D2E24 (wood, leather, everything human-made); torch amber #C4843A (ONLY the torch flame and the hard-edged patches its light makes); ink black #06070A (outlines). No skin tone colour: a lit face is torch amber, an unlit face is cold blue. SETTING: the year 1243 on the Anatolian frontier (Seljuk borderland) while people flee the Mongol invasion. People are tired: low shoulders, head bowed forward, heavy eyelids, weight on one leg, no heroic or action poses, no evil or villain faces. Clothing of the period only: wool hood, felt cap, linen tunic, wrapped wool kaftan closed with ties or a sash, leather belt, sleeveless felt cloak, loose trousers, leg wraps, rawhide sandals or cloth-wrapped feet. FORBIDDEN: any text, letters, numbers, runes, writing, signatures, watermarks, logos or inscriptions; modern items (caps with visors, coats with collars, zippers, rows of buttons, metal buckles); fantasy armour, plate armour, horned helmets; later Ottoman turbans or fez; the colours red, green, gold or pink.

FRAMING: character portrait card, chest-up (head, shoulders and upper chest), the figure centred and filling most of the image width, the chest cut off by the bottom edge of the image, a little empty space above the head. Three-quarter view toward the viewer. Tired neutral expression: heavy eyelids, a single ink line under each eye, mouth closed, head slightly bowed. LIGHT: one torch off to the left - the left half of the face and clothes is a flat hard-edged torch amber #C4843A patch, the right half of the face is flat cold blue #4A6B8A with ink-black shadow shapes; the boundary between them is one sharp line, no blending. Very thick outer outline, interior lines half as thick.

SUBJECT: Saruca Hatun, a widowed farm woman in her fifties: lined face, a LARGE TRIANGULAR HEADSCARF tied under her chin (her signature shape), plain wool dress, a coarse cloth GRAIN SACK tied with rope held against her shoulder and chest.

BACKGROUND: the subject stands alone on a perfectly flat, uniform, pure magenta #FF00FF background that fills the whole image edge to edge. No shadow, no ground, no floor line, no vignette, no frame, no border, nothing else in the background. Never use magenta, pink or purple anywhere on the subject itself.

IMAGE: aspect ratio 4:5 (portrait).
```

## char_soldier_01_idle_village

- Kaydedilecek ad: `tools/art/gelen/char_soldier_01_idle_village.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/char/char_soldier_01_idle_village.png`, 56 x 120 piksel
- İstenecek oran: **9:16**
- Arka plan: düz macenta #FF00FF (betik siler)

```text
STYLE: flat 2D game illustration in a bold graphic-novel ink style. Thick, confident ink-black outlines: heaviest on the outer silhouette, about half as thick for interior details (folds, face lines). Flat solid colour fills only. NO gradients, no soft shading, no airbrush, no glow, no bloom, no rim light haze, no texture noise, no grain, no dithering, no painterly brush strokes, no photorealism, no anime, no 3D render. It is night and the only warm light is a single torch: wherever the torch light touches a surface it is a hard-edged flat patch of torch amber; everything else is cold blue and near-black. STRICT PALETTE, use only these colours: night near-black #0D0F14 (background, voids, shadow); cold blue #4A6B8A (sky, stone, cloth, distant figures, the unlit side of faces); deep blue #24364A (second depth layer, distant layers, darker cloth); wood brown #3D2E24 (wood, leather, everything human-made); torch amber #C4843A (ONLY the torch flame and the hard-edged patches its light makes); ink black #06070A (outlines). No skin tone colour: a lit face is torch amber, an unlit face is cold blue. SETTING: the year 1243 on the Anatolian frontier (Seljuk borderland) while people flee the Mongol invasion. People are tired: low shoulders, head bowed forward, heavy eyelids, weight on one leg, no heroic or action poses, no evil or villain faces. Clothing of the period only: wool hood, felt cap, linen tunic, wrapped wool kaftan closed with ties or a sash, leather belt, sleeveless felt cloak, loose trousers, leg wraps, rawhide sandals or cloth-wrapped feet. FORBIDDEN: any text, letters, numbers, runes, writing, signatures, watermarks, logos or inscriptions; modern items (caps with visors, coats with collars, zippers, rows of buttons, metal buckles); fantasy armour, plate armour, horned helmets; later Ottoman turbans or fez; the colours red, green, gold or pink.

FRAMING: one small full-body standing figure for a village view, head to feet, front view, centred, feet at the bottom. It will be shown only about 100 pixels tall, so use very bold simple shapes: a readable silhouette, no facial features (the hood or headwear shape is enough), no folds, one thin uniform outline. A single hard-edged torch amber patch on the left side of the body, the rest cold blue, deep blue and wood brown.

SUBJECT: An ordinary frontier foot soldier: padded quilted kaftan as his only armour, a plain conical iron cap or wool hood, a long spear held upright over the right shoulder with the spearhead above his head, the edge of a round wooden shield at his left side.

BACKGROUND: the subject stands alone on a perfectly flat, uniform, pure magenta #FF00FF background that fills the whole image edge to edge. No shadow, no ground, no floor line, no vignette, no frame, no border, nothing else in the background. Never use magenta, pink or purple anywhere on the subject itself.

IMAGE: aspect ratio 9:16 (portrait).
```

## char_soldier_01_neutral_card

- Kaydedilecek ad: `tools/art/gelen/char_soldier_01_neutral_card.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/char/char_soldier_01_neutral_card.png`, 600 x 760 piksel
- İstenecek oran: **4:5**
- Arka plan: düz macenta #FF00FF (betik siler)

```text
STYLE: flat 2D game illustration in a bold graphic-novel ink style. Thick, confident ink-black outlines: heaviest on the outer silhouette, about half as thick for interior details (folds, face lines). Flat solid colour fills only. NO gradients, no soft shading, no airbrush, no glow, no bloom, no rim light haze, no texture noise, no grain, no dithering, no painterly brush strokes, no photorealism, no anime, no 3D render. It is night and the only warm light is a single torch: wherever the torch light touches a surface it is a hard-edged flat patch of torch amber; everything else is cold blue and near-black. STRICT PALETTE, use only these colours: night near-black #0D0F14 (background, voids, shadow); cold blue #4A6B8A (sky, stone, cloth, distant figures, the unlit side of faces); deep blue #24364A (second depth layer, distant layers, darker cloth); wood brown #3D2E24 (wood, leather, everything human-made); torch amber #C4843A (ONLY the torch flame and the hard-edged patches its light makes); ink black #06070A (outlines). No skin tone colour: a lit face is torch amber, an unlit face is cold blue. SETTING: the year 1243 on the Anatolian frontier (Seljuk borderland) while people flee the Mongol invasion. People are tired: low shoulders, head bowed forward, heavy eyelids, weight on one leg, no heroic or action poses, no evil or villain faces. Clothing of the period only: wool hood, felt cap, linen tunic, wrapped wool kaftan closed with ties or a sash, leather belt, sleeveless felt cloak, loose trousers, leg wraps, rawhide sandals or cloth-wrapped feet. FORBIDDEN: any text, letters, numbers, runes, writing, signatures, watermarks, logos or inscriptions; modern items (caps with visors, coats with collars, zippers, rows of buttons, metal buckles); fantasy armour, plate armour, horned helmets; later Ottoman turbans or fez; the colours red, green, gold or pink.

FRAMING: character portrait card, chest-up (head, shoulders and upper chest), the figure centred and filling most of the image width, the chest cut off by the bottom edge of the image, a little empty space above the head. Three-quarter view toward the viewer. Tired neutral expression: heavy eyelids, a single ink line under each eye, mouth closed, head slightly bowed. LIGHT: one torch off to the left - the left half of the face and clothes is a flat hard-edged torch amber #C4843A patch, the right half of the face is flat cold blue #4A6B8A with ink-black shadow shapes; the boundary between them is one sharp line, no blending. Very thick outer outline, interior lines half as thick.

SUBJECT: An ordinary frontier foot soldier: padded quilted kaftan as his only armour, a plain conical iron cap or wool hood, a long spear held upright over the right shoulder with the spearhead above his head, the edge of a round wooden shield at his left side.

BACKGROUND: the subject stands alone on a perfectly flat, uniform, pure magenta #FF00FF background that fills the whole image edge to edge. No shadow, no ground, no floor line, no vignette, no frame, no border, nothing else in the background. Never use magenta, pink or purple anywhere on the subject itself.

IMAGE: aspect ratio 4:5 (portrait).
```

## char_sorhan_idle_village

- Kaydedilecek ad: `tools/art/gelen/char_sorhan_idle_village.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/char/char_sorhan_idle_village.png`, 56 x 120 piksel
- İstenecek oran: **9:16**
- Arka plan: düz macenta #FF00FF (betik siler)

```text
STYLE: flat 2D game illustration in a bold graphic-novel ink style. Thick, confident ink-black outlines: heaviest on the outer silhouette, about half as thick for interior details (folds, face lines). Flat solid colour fills only. NO gradients, no soft shading, no airbrush, no glow, no bloom, no rim light haze, no texture noise, no grain, no dithering, no painterly brush strokes, no photorealism, no anime, no 3D render. It is night and the only warm light is a single torch: wherever the torch light touches a surface it is a hard-edged flat patch of torch amber; everything else is cold blue and near-black. STRICT PALETTE, use only these colours: night near-black #0D0F14 (background, voids, shadow); cold blue #4A6B8A (sky, stone, cloth, distant figures, the unlit side of faces); deep blue #24364A (second depth layer, distant layers, darker cloth); wood brown #3D2E24 (wood, leather, everything human-made); torch amber #C4843A (ONLY the torch flame and the hard-edged patches its light makes); ink black #06070A (outlines). No skin tone colour: a lit face is torch amber, an unlit face is cold blue. SETTING: the year 1243 on the Anatolian frontier (Seljuk borderland) while people flee the Mongol invasion. People are tired: low shoulders, head bowed forward, heavy eyelids, weight on one leg, no heroic or action poses, no evil or villain faces. Clothing of the period only: wool hood, felt cap, linen tunic, wrapped wool kaftan closed with ties or a sash, leather belt, sleeveless felt cloak, loose trousers, leg wraps, rawhide sandals or cloth-wrapped feet. FORBIDDEN: any text, letters, numbers, runes, writing, signatures, watermarks, logos or inscriptions; modern items (caps with visors, coats with collars, zippers, rows of buttons, metal buckles); fantasy armour, plate armour, horned helmets; later Ottoman turbans or fez; the colours red, green, gold or pink.

FRAMING: one small full-body standing figure for a village view, head to feet, front view, centred, feet at the bottom. It will be shown only about 100 pixels tall, so use very bold simple shapes: a readable silhouette, no facial features (the hood or headwear shape is enough), no folds, one thin uniform outline. A single hard-edged torch amber patch on the left side of the body, the rest cold blue, deep blue and wood brown.

SUBJECT: Sorhan, a Kipchak horse trader, middle-aged: broad face, wide cheekbones, drooping moustache, felt cap, a COILED HORSE HALTER ROPE hanging over one shoulder (his signature shape), a tied cloth bundle on his back rising above the other shoulder, plain wool kaftan.

BACKGROUND: the subject stands alone on a perfectly flat, uniform, pure magenta #FF00FF background that fills the whole image edge to edge. No shadow, no ground, no floor line, no vignette, no frame, no border, nothing else in the background. Never use magenta, pink or purple anywhere on the subject itself.

IMAGE: aspect ratio 9:16 (portrait).
```

## char_sorhan_neutral_card

- Kaydedilecek ad: `tools/art/gelen/char_sorhan_neutral_card.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/char/char_sorhan_neutral_card.png`, 600 x 760 piksel
- İstenecek oran: **4:5**
- Arka plan: düz macenta #FF00FF (betik siler)

```text
STYLE: flat 2D game illustration in a bold graphic-novel ink style. Thick, confident ink-black outlines: heaviest on the outer silhouette, about half as thick for interior details (folds, face lines). Flat solid colour fills only. NO gradients, no soft shading, no airbrush, no glow, no bloom, no rim light haze, no texture noise, no grain, no dithering, no painterly brush strokes, no photorealism, no anime, no 3D render. It is night and the only warm light is a single torch: wherever the torch light touches a surface it is a hard-edged flat patch of torch amber; everything else is cold blue and near-black. STRICT PALETTE, use only these colours: night near-black #0D0F14 (background, voids, shadow); cold blue #4A6B8A (sky, stone, cloth, distant figures, the unlit side of faces); deep blue #24364A (second depth layer, distant layers, darker cloth); wood brown #3D2E24 (wood, leather, everything human-made); torch amber #C4843A (ONLY the torch flame and the hard-edged patches its light makes); ink black #06070A (outlines). No skin tone colour: a lit face is torch amber, an unlit face is cold blue. SETTING: the year 1243 on the Anatolian frontier (Seljuk borderland) while people flee the Mongol invasion. People are tired: low shoulders, head bowed forward, heavy eyelids, weight on one leg, no heroic or action poses, no evil or villain faces. Clothing of the period only: wool hood, felt cap, linen tunic, wrapped wool kaftan closed with ties or a sash, leather belt, sleeveless felt cloak, loose trousers, leg wraps, rawhide sandals or cloth-wrapped feet. FORBIDDEN: any text, letters, numbers, runes, writing, signatures, watermarks, logos or inscriptions; modern items (caps with visors, coats with collars, zippers, rows of buttons, metal buckles); fantasy armour, plate armour, horned helmets; later Ottoman turbans or fez; the colours red, green, gold or pink.

FRAMING: character portrait card, chest-up (head, shoulders and upper chest), the figure centred and filling most of the image width, the chest cut off by the bottom edge of the image, a little empty space above the head. Three-quarter view toward the viewer. Tired neutral expression: heavy eyelids, a single ink line under each eye, mouth closed, head slightly bowed. LIGHT: one torch off to the left - the left half of the face and clothes is a flat hard-edged torch amber #C4843A patch, the right half of the face is flat cold blue #4A6B8A with ink-black shadow shapes; the boundary between them is one sharp line, no blending. Very thick outer outline, interior lines half as thick.

SUBJECT: Sorhan, a Kipchak horse trader, middle-aged: broad face, wide cheekbones, drooping moustache, felt cap, a COILED HORSE HALTER ROPE hanging over one shoulder (his signature shape), a tied cloth bundle on his back rising above the other shoulder, plain wool kaftan.

BACKGROUND: the subject stands alone on a perfectly flat, uniform, pure magenta #FF00FF background that fills the whole image edge to edge. No shadow, no ground, no floor line, no vignette, no frame, no border, nothing else in the background. Never use magenta, pink or purple anywhere on the subject itself.

IMAGE: aspect ratio 4:5 (portrait).
```

## char_thessra_idle_village

- Kaydedilecek ad: `tools/art/gelen/char_thessra_idle_village.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/char/char_thessra_idle_village.png`, 56 x 120 piksel
- İstenecek oran: **9:16**
- Arka plan: düz macenta #FF00FF (betik siler)

```text
STYLE: flat 2D game illustration in a bold graphic-novel ink style. Thick, confident ink-black outlines: heaviest on the outer silhouette, about half as thick for interior details (folds, face lines). Flat solid colour fills only. NO gradients, no soft shading, no airbrush, no glow, no bloom, no rim light haze, no texture noise, no grain, no dithering, no painterly brush strokes, no photorealism, no anime, no 3D render. It is night and the only warm light is a single torch: wherever the torch light touches a surface it is a hard-edged flat patch of torch amber; everything else is cold blue and near-black. STRICT PALETTE, use only these colours: night near-black #0D0F14 (background, voids, shadow); cold blue #4A6B8A (sky, stone, cloth, distant figures, the unlit side of faces); deep blue #24364A (second depth layer, distant layers, darker cloth); wood brown #3D2E24 (wood, leather, everything human-made); torch amber #C4843A (ONLY the torch flame and the hard-edged patches its light makes); ink black #06070A (outlines). No skin tone colour: a lit face is torch amber, an unlit face is cold blue. SETTING: the year 1243 on the Anatolian frontier (Seljuk borderland) while people flee the Mongol invasion. People are tired: low shoulders, head bowed forward, heavy eyelids, weight on one leg, no heroic or action poses, no evil or villain faces. Clothing of the period only: wool hood, felt cap, linen tunic, wrapped wool kaftan closed with ties or a sash, leather belt, sleeveless felt cloak, loose trousers, leg wraps, rawhide sandals or cloth-wrapped feet. FORBIDDEN: any text, letters, numbers, runes, writing, signatures, watermarks, logos or inscriptions; modern items (caps with visors, coats with collars, zippers, rows of buttons, metal buckles); fantasy armour, plate armour, horned helmets; later Ottoman turbans or fez; the colours red, green, gold or pink.

FRAMING: one small full-body standing figure for a village view, head to feet, front view, centred, feet at the bottom. It will be shown only about 100 pixels tall, so use very bold simple shapes: a readable silhouette, no facial features (the hood or headwear shape is enough), no folds, one thin uniform outline. A single hard-edged torch amber patch on the left side of the body, the rest cold blue, deep blue and wood brown.

SUBJECT: Thessra, a young Greek woman from Trebizond, about eighteen, a healer's daughter: narrow tired face, a LONG HEADSCARF whose long tail hangs down past one shoulder (her signature shape), plain linen dress under a wool overdress, holding a SMALL PLAIN WOODEN BOX (no markings) against her chest with both hands.

BACKGROUND: the subject stands alone on a perfectly flat, uniform, pure magenta #FF00FF background that fills the whole image edge to edge. No shadow, no ground, no floor line, no vignette, no frame, no border, nothing else in the background. Never use magenta, pink or purple anywhere on the subject itself.

IMAGE: aspect ratio 9:16 (portrait).
```

## char_thessra_neutral_card

- Kaydedilecek ad: `tools/art/gelen/char_thessra_neutral_card.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/char/char_thessra_neutral_card.png`, 600 x 760 piksel
- İstenecek oran: **4:5**
- Arka plan: düz macenta #FF00FF (betik siler)

```text
STYLE: flat 2D game illustration in a bold graphic-novel ink style. Thick, confident ink-black outlines: heaviest on the outer silhouette, about half as thick for interior details (folds, face lines). Flat solid colour fills only. NO gradients, no soft shading, no airbrush, no glow, no bloom, no rim light haze, no texture noise, no grain, no dithering, no painterly brush strokes, no photorealism, no anime, no 3D render. It is night and the only warm light is a single torch: wherever the torch light touches a surface it is a hard-edged flat patch of torch amber; everything else is cold blue and near-black. STRICT PALETTE, use only these colours: night near-black #0D0F14 (background, voids, shadow); cold blue #4A6B8A (sky, stone, cloth, distant figures, the unlit side of faces); deep blue #24364A (second depth layer, distant layers, darker cloth); wood brown #3D2E24 (wood, leather, everything human-made); torch amber #C4843A (ONLY the torch flame and the hard-edged patches its light makes); ink black #06070A (outlines). No skin tone colour: a lit face is torch amber, an unlit face is cold blue. SETTING: the year 1243 on the Anatolian frontier (Seljuk borderland) while people flee the Mongol invasion. People are tired: low shoulders, head bowed forward, heavy eyelids, weight on one leg, no heroic or action poses, no evil or villain faces. Clothing of the period only: wool hood, felt cap, linen tunic, wrapped wool kaftan closed with ties or a sash, leather belt, sleeveless felt cloak, loose trousers, leg wraps, rawhide sandals or cloth-wrapped feet. FORBIDDEN: any text, letters, numbers, runes, writing, signatures, watermarks, logos or inscriptions; modern items (caps with visors, coats with collars, zippers, rows of buttons, metal buckles); fantasy armour, plate armour, horned helmets; later Ottoman turbans or fez; the colours red, green, gold or pink.

FRAMING: character portrait card, chest-up (head, shoulders and upper chest), the figure centred and filling most of the image width, the chest cut off by the bottom edge of the image, a little empty space above the head. Three-quarter view toward the viewer. Tired neutral expression: heavy eyelids, a single ink line under each eye, mouth closed, head slightly bowed. LIGHT: one torch off to the left - the left half of the face and clothes is a flat hard-edged torch amber #C4843A patch, the right half of the face is flat cold blue #4A6B8A with ink-black shadow shapes; the boundary between them is one sharp line, no blending. Very thick outer outline, interior lines half as thick.

SUBJECT: Thessra, a young Greek woman from Trebizond, about eighteen, a healer's daughter: narrow tired face, a LONG HEADSCARF whose long tail hangs down past one shoulder (her signature shape), plain linen dress under a wool overdress, holding a SMALL PLAIN WOODEN BOX (no markings) against her chest with both hands.

BACKGROUND: the subject stands alone on a perfectly flat, uniform, pure magenta #FF00FF background that fills the whole image edge to edge. No shadow, no ground, no floor line, no vignette, no frame, no border, nothing else in the background. Never use magenta, pink or purple anywhere on the subject itself.

IMAGE: aspect ratio 4:5 (portrait).
```

## crowd_tekfur_spear_01_far

- Kaydedilecek ad: `tools/art/gelen/crowd_tekfur_spear_01_far.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/char/crowd_tekfur_spear_01_far.png`, 420 x 80 piksel
- İstenecek oran: **21:9**
- Arka plan: düz macenta #FF00FF (betik siler)

```text
STYLE: flat 2D game illustration in a bold graphic-novel ink style. Thick, confident ink-black outlines: heaviest on the outer silhouette, about half as thick for interior details (folds, face lines). Flat solid colour fills only. NO gradients, no soft shading, no airbrush, no glow, no bloom, no rim light haze, no texture noise, no grain, no dithering, no painterly brush strokes, no photorealism, no anime, no 3D render. It is night and the only warm light is a single torch: wherever the torch light touches a surface it is a hard-edged flat patch of torch amber; everything else is cold blue and near-black. STRICT PALETTE, use only these colours: night near-black #0D0F14 (background, voids, shadow); cold blue #4A6B8A (sky, stone, cloth, distant figures, the unlit side of faces); deep blue #24364A (second depth layer, distant layers, darker cloth); wood brown #3D2E24 (wood, leather, everything human-made); torch amber #C4843A (ONLY the torch flame and the hard-edged patches its light makes); ink black #06070A (outlines). No skin tone colour: a lit face is torch amber, an unlit face is cold blue. SETTING: the year 1243 on the Anatolian frontier (Seljuk borderland) while people flee the Mongol invasion. People are tired: low shoulders, head bowed forward, heavy eyelids, weight on one leg, no heroic or action poses, no evil or villain faces. Clothing of the period only: wool hood, felt cap, linen tunic, wrapped wool kaftan closed with ties or a sash, leather belt, sleeveless felt cloak, loose trousers, leg wraps, rawhide sandals or cloth-wrapped feet. FORBIDDEN: any text, letters, numbers, runes, writing, signatures, watermarks, logos or inscriptions; modern items (caps with visors, coats with collars, zippers, rows of buttons, metal buckles); fantasy armour, plate armour, horned helmets; later Ottoman turbans or fez; the colours red, green, gold or pink.

SUBJECT: A distant row of about fourteen foot soldiers of the Byzantine frontier lord (tekfur), seen from far away: flat silhouettes only, all one flat cold blue #4A6B8A with a few deep blue #24364A shapes, NO outlines, no faces, no interior detail. Evenly spaced in a regular rhythm, each with an upright spear whose tip repeats above the heads and the same round shield. One horizontal band of figures filling the image width. Organised and distant, not demonic.

BACKGROUND: the subject stands alone on a perfectly flat, uniform, pure magenta #FF00FF background that fills the whole image edge to edge. No shadow, no ground, no floor line, no vignette, no frame, no border, nothing else in the background. Never use magenta, pink or purple anywhere on the subject itself.

IMAGE: aspect ratio 21:9 (landscape).
```

## env_gate_scene_bg

- Kaydedilecek ad: `tools/art/gelen/env_gate_scene_bg.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/env/env_gate_scene_bg.png`, 1140 x 1000 piksel
- İstenecek oran: **5:4**
- Arka plan: opak sahne (silinmez)

```text
STYLE: flat 2D game illustration in a bold graphic-novel ink style. Thick, confident ink-black outlines: heaviest on the outer silhouette, about half as thick for interior details (folds, face lines). Flat solid colour fills only. NO gradients, no soft shading, no airbrush, no glow, no bloom, no rim light haze, no texture noise, no grain, no dithering, no painterly brush strokes, no photorealism, no anime, no 3D render. It is night and the only warm light is a single torch: wherever the torch light touches a surface it is a hard-edged flat patch of torch amber; everything else is cold blue and near-black. STRICT PALETTE, use only these colours: night near-black #0D0F14 (background, voids, shadow); cold blue #4A6B8A (sky, stone, cloth, distant figures, the unlit side of faces); deep blue #24364A (second depth layer, distant layers, darker cloth); wood brown #3D2E24 (wood, leather, everything human-made); torch amber #C4843A (ONLY the torch flame and the hard-edged patches its light makes); ink black #06070A (outlines). No skin tone colour: a lit face is torch amber, an unlit face is cold blue. SETTING: the year 1243 on the Anatolian frontier (Seljuk borderland) while people flee the Mongol invasion. People are tired: low shoulders, head bowed forward, heavy eyelids, weight on one leg, no heroic or action poses, no evil or villain faces. Clothing of the period only: wool hood, felt cap, linen tunic, wrapped wool kaftan closed with ties or a sash, leather belt, sleeveless felt cloak, loose trousers, leg wraps, rawhide sandals or cloth-wrapped feet. FORBIDDEN: any text, letters, numbers, runes, writing, signatures, watermarks, logos or inscriptions; modern items (caps with visors, coats with collars, zippers, rows of buttons, metal buckles); fantasy armour, plate armour, horned helmets; later Ottoman turbans or fez; the colours red, green, gold or pink.

SUBJECT: First-person view from just inside a frontier palisade gate at night, looking out through the open gateway. Left and right image edges: thick vertical wooden gate posts made of planks; a heavy horizontal wooden beam across the top edge. A single torch fixed to the LEFT post: its flame torch amber, throwing one hard-edged flat amber patch onto the post and onto the ground at the lower left. Through the gateway: a dirt road narrowing to the horizon, flat layered cold blue and deep blue hills under a near-black sky, and far away on the road an irregular queue of tiny deep blue refugee silhouettes carrying bundles. Keep the centre calm and empty so a character can stand in front of it. Depth by flat tone layers only: no gradient sky, no stars, no moon.

IMAGE: aspect ratio 5:4 (landscape).
```

## env_menu_bg

- Kaydedilecek ad: `tools/art/gelen/env_menu_bg.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/env/env_menu_bg.png`, 1920 x 1080 piksel
- İstenecek oran: **16:9**
- Arka plan: opak sahne (silinmez)

```text
STYLE: flat 2D game illustration in a bold graphic-novel ink style. Thick, confident ink-black outlines: heaviest on the outer silhouette, about half as thick for interior details (folds, face lines). Flat solid colour fills only. NO gradients, no soft shading, no airbrush, no glow, no bloom, no rim light haze, no texture noise, no grain, no dithering, no painterly brush strokes, no photorealism, no anime, no 3D render. It is night and the only warm light is a single torch: wherever the torch light touches a surface it is a hard-edged flat patch of torch amber; everything else is cold blue and near-black. STRICT PALETTE, use only these colours: night near-black #0D0F14 (background, voids, shadow); cold blue #4A6B8A (sky, stone, cloth, distant figures, the unlit side of faces); deep blue #24364A (second depth layer, distant layers, darker cloth); wood brown #3D2E24 (wood, leather, everything human-made); torch amber #C4843A (ONLY the torch flame and the hard-edged patches its light makes); ink black #06070A (outlines). No skin tone colour: a lit face is torch amber, an unlit face is cold blue. SETTING: the year 1243 on the Anatolian frontier (Seljuk borderland) while people flee the Mongol invasion. People are tired: low shoulders, head bowed forward, heavy eyelids, weight on one leg, no heroic or action poses, no evil or villain faces. Clothing of the period only: wool hood, felt cap, linen tunic, wrapped wool kaftan closed with ties or a sash, leather belt, sleeveless felt cloak, loose trousers, leg wraps, rawhide sandals or cloth-wrapped feet. FORBIDDEN: any text, letters, numbers, runes, writing, signatures, watermarks, logos or inscriptions; modern items (caps with visors, coats with collars, zippers, rows of buttons, metal buckles); fantasy armour, plate armour, horned helmets; later Ottoman turbans or fez; the colours red, green, gold or pink.

SUBJECT: Wide night landscape for a title screen. The left two thirds: empty near-black sky over low deep blue ridges (room for a title that is added later in code - do not draw any text). The right third: a CLOSED heavy wooden frontier gate made of vertical planks between two plank posts under a top beam, a single torch on the left post, one hard-edged amber light patch on the post and on the ground below it. No people.

IMAGE: aspect ratio 16:9 (landscape).
```

## env_village_bg

- Kaydedilecek ad: `tools/art/gelen/env_village_bg.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/env/env_village_bg.png`, 1920 x 1000 piksel
- İstenecek oran: **16:9**
- Arka plan: opak sahne (silinmez)

```text
STYLE: flat 2D game illustration in a bold graphic-novel ink style. Thick, confident ink-black outlines: heaviest on the outer silhouette, about half as thick for interior details (folds, face lines). Flat solid colour fills only. NO gradients, no soft shading, no airbrush, no glow, no bloom, no rim light haze, no texture noise, no grain, no dithering, no painterly brush strokes, no photorealism, no anime, no 3D render. It is night and the only warm light is a single torch: wherever the torch light touches a surface it is a hard-edged flat patch of torch amber; everything else is cold blue and near-black. STRICT PALETTE, use only these colours: night near-black #0D0F14 (background, voids, shadow); cold blue #4A6B8A (sky, stone, cloth, distant figures, the unlit side of faces); deep blue #24364A (second depth layer, distant layers, darker cloth); wood brown #3D2E24 (wood, leather, everything human-made); torch amber #C4843A (ONLY the torch flame and the hard-edged patches its light makes); ink black #06070A (outlines). No skin tone colour: a lit face is torch amber, an unlit face is cold blue. SETTING: the year 1243 on the Anatolian frontier (Seljuk borderland) while people flee the Mongol invasion. People are tired: low shoulders, head bowed forward, heavy eyelids, weight on one leg, no heroic or action poses, no evil or villain faces. Clothing of the period only: wool hood, felt cap, linen tunic, wrapped wool kaftan closed with ties or a sash, leather belt, sleeveless felt cloak, loose trousers, leg wraps, rawhide sandals or cloth-wrapped feet. FORBIDDEN: any text, letters, numbers, runes, writing, signatures, watermarks, logos or inscriptions; modern items (caps with visors, coats with collars, zippers, rows of buttons, metal buckles); fantasy armour, plate armour, horned helmets; later Ottoman turbans or fez; the colours red, green, gold or pink.

SUBJECT: Wide side view of a small Seljuk-era frontier village at night, after the torches are lit. Centre-left: a small caravanserai - a closed square courtyard behind low, plain rubble-stone walls (cold blue with a few ink joint lines), ONE pointed-arch portal with wooden doors, above it an EMPTY blank inscription frame. Right side: an open market of a few wooden posts with stretched cloth awnings (deep blue) and low wooden tables. Flat cold blue ground across the lower half, deep blue distant ridges, near-black sky. Two or three small torches, each with a hard amber light patch. No people (they are added separately), no signs, organic layout, not a grid.

IMAGE: aspect ratio 16:9 (landscape).
```

## fx_torch_village_01

- Kaydedilecek ad: `tools/art/gelen/fx_torch_village_01.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/fx/fx_torch_village_01.png`, 40 x 110 piksel
- İstenecek oran: **9:16**
- Arka plan: düz macenta #FF00FF (betik siler)

```text
STYLE: flat 2D game illustration in a bold graphic-novel ink style. Thick, confident ink-black outlines: heaviest on the outer silhouette, about half as thick for interior details (folds, face lines). Flat solid colour fills only. NO gradients, no soft shading, no airbrush, no glow, no bloom, no rim light haze, no texture noise, no grain, no dithering, no painterly brush strokes, no photorealism, no anime, no 3D render. It is night and the only warm light is a single torch: wherever the torch light touches a surface it is a hard-edged flat patch of torch amber; everything else is cold blue and near-black. STRICT PALETTE, use only these colours: night near-black #0D0F14 (background, voids, shadow); cold blue #4A6B8A (sky, stone, cloth, distant figures, the unlit side of faces); deep blue #24364A (second depth layer, distant layers, darker cloth); wood brown #3D2E24 (wood, leather, everything human-made); torch amber #C4843A (ONLY the torch flame and the hard-edged patches its light makes); ink black #06070A (outlines). No skin tone colour: a lit face is torch amber, an unlit face is cold blue. SETTING: the year 1243 on the Anatolian frontier (Seljuk borderland) while people flee the Mongol invasion. People are tired: low shoulders, head bowed forward, heavy eyelids, weight on one leg, no heroic or action poses, no evil or villain faces. Clothing of the period only: wool hood, felt cap, linen tunic, wrapped wool kaftan closed with ties or a sash, leather belt, sleeveless felt cloak, loose trousers, leg wraps, rawhide sandals or cloth-wrapped feet. FORBIDDEN: any text, letters, numbers, runes, writing, signatures, watermarks, logos or inscriptions; modern items (caps with visors, coats with collars, zippers, rows of buttons, metal buckles); fantasy armour, plate armour, horned helmets; later Ottoman turbans or fez; the colours red, green, gold or pink.

SUBJECT: A single standing wooden torch: a straight wooden pole with a cloth-wrapped head and a flat flame on top. The flame is one flat torch amber #C4843A shape with jagged hard edges, the pole wood brown #3D2E24, a thick ink outline around everything. Vertical, centred, filling the image height. No glow, no sparks, no smoke.

BACKGROUND: the subject stands alone on a perfectly flat, uniform, pure magenta #FF00FF background that fills the whole image edge to edge. No shadow, no ground, no floor line, no vignette, no frame, no border, nothing else in the background. Never use magenta, pink or purple anywhere on the subject itself.

IMAGE: aspect ratio 9:16 (portrait).
```

## fx_torchlight_patch_village_01

- Kaydedilecek ad: `tools/art/gelen/fx_torchlight_patch_village_01.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/fx/fx_torchlight_patch_village_01.png`, 260 x 90 piksel
- İstenecek oran: **21:9**
- Arka plan: düz macenta #FF00FF (betik siler)

```text
STYLE: flat 2D game illustration in a bold graphic-novel ink style. Thick, confident ink-black outlines: heaviest on the outer silhouette, about half as thick for interior details (folds, face lines). Flat solid colour fills only. NO gradients, no soft shading, no airbrush, no glow, no bloom, no rim light haze, no texture noise, no grain, no dithering, no painterly brush strokes, no photorealism, no anime, no 3D render. It is night and the only warm light is a single torch: wherever the torch light touches a surface it is a hard-edged flat patch of torch amber; everything else is cold blue and near-black. STRICT PALETTE, use only these colours: night near-black #0D0F14 (background, voids, shadow); cold blue #4A6B8A (sky, stone, cloth, distant figures, the unlit side of faces); deep blue #24364A (second depth layer, distant layers, darker cloth); wood brown #3D2E24 (wood, leather, everything human-made); torch amber #C4843A (ONLY the torch flame and the hard-edged patches its light makes); ink black #06070A (outlines). No skin tone colour: a lit face is torch amber, an unlit face is cold blue. SETTING: the year 1243 on the Anatolian frontier (Seljuk borderland) while people flee the Mongol invasion. People are tired: low shoulders, head bowed forward, heavy eyelids, weight on one leg, no heroic or action poses, no evil or villain faces. Clothing of the period only: wool hood, felt cap, linen tunic, wrapped wool kaftan closed with ties or a sash, leather belt, sleeveless felt cloak, loose trousers, leg wraps, rawhide sandals or cloth-wrapped feet. FORBIDDEN: any text, letters, numbers, runes, writing, signatures, watermarks, logos or inscriptions; modern items (caps with visors, coats with collars, zippers, rows of buttons, metal buckles); fantasy armour, plate armour, horned helmets; later Ottoman turbans or fez; the colours red, green, gold or pink.

SUBJECT: A single irregular blob of torchlight as it lies on flat ground, seen from a low angle: a wide, flattened horizontal shape with hard irregular edges, ONE flat colour torch amber #C4843A, no outline, no glow, no gradient, nothing else in the image.

BACKGROUND: the subject stands alone on a perfectly flat, uniform, pure magenta #FF00FF background that fills the whole image edge to edge. No shadow, no ground, no floor line, no vignette, no frame, no border, nothing else in the background. Never use magenta, pink or purple anywhere on the subject itself.

IMAGE: aspect ratio 21:9 (landscape).
```

## icon_bribe_pouch_empty_48

- Kaydedilecek ad: `tools/art/gelen/icon_bribe_pouch_empty_48.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/ui/icon_bribe_pouch_empty_48.png`, 48 x 48 piksel
- İstenecek oran: **1:1**
- Arka plan: düz macenta #FF00FF (betik siler)

```text
STYLE: flat 2D game user-interface graphic. One bold, simple shape, readable at 48 pixels. Thick ink-black #06070A outline, flat solid fills, hard square corners where there are corners. NO gradients, no shading, no bevel, no gloss, no 3D, no drop shadow, no glow, no texture. Use only ash white #B8C2CC and ink black #06070A unless told otherwise. FORBIDDEN: any text, letters, numbers, writing, logos or watermarks; the colours red, green, gold, orange or pink.

SUBJECT: A square game icon, the pictogram centred and filling about 85% of the image. The same coin pouch but EMPTY and deflated, drawn only as a thick DASHED ash white outline with no fill (the inside is background).

BACKGROUND: the subject stands alone on a perfectly flat, uniform, pure magenta #FF00FF background that fills the whole image edge to edge. No shadow, no ground, no floor line, no vignette, no frame, no border, nothing else in the background. Never use magenta, pink or purple anywhere on the subject itself.

IMAGE: aspect ratio 1:1 (square).
```

## icon_bribe_pouch_full_48

- Kaydedilecek ad: `tools/art/gelen/icon_bribe_pouch_full_48.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/ui/icon_bribe_pouch_full_48.png`, 48 x 48 piksel
- İstenecek oran: **1:1**
- Arka plan: düz macenta #FF00FF (betik siler)

```text
STYLE: flat 2D game user-interface graphic. One bold, simple shape, readable at 48 pixels. Thick ink-black #06070A outline, flat solid fills, hard square corners where there are corners. NO gradients, no shading, no bevel, no gloss, no 3D, no drop shadow, no glow, no texture. Use only ash white #B8C2CC and ink black #06070A unless told otherwise. FORBIDDEN: any text, letters, numbers, writing, logos or watermarks; the colours red, green, gold, orange or pink.

SUBJECT: A square game icon, the pictogram centred and filling about 85% of the image. A FULL, round leather coin pouch tied at the neck with a cord: pouch body wood brown #3D2E24, the tie ash white, thick ink outline.

BACKGROUND: the subject stands alone on a perfectly flat, uniform, pure magenta #FF00FF background that fills the whole image edge to edge. No shadow, no ground, no floor line, no vignette, no frame, no border, nothing else in the background. Never use magenta, pink or purple anywhere on the subject itself.

IMAGE: aspect ratio 1:1 (square).
```

## icon_decision_accept_48

- Kaydedilecek ad: `tools/art/gelen/icon_decision_accept_48.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/ui/icon_decision_accept_48.png`, 48 x 48 piksel
- İstenecek oran: **1:1**
- Arka plan: düz macenta #FF00FF (betik siler)

```text
STYLE: flat 2D game user-interface graphic. One bold, simple shape, readable at 48 pixels. Thick ink-black #06070A outline, flat solid fills, hard square corners where there are corners. NO gradients, no shading, no bevel, no gloss, no 3D, no drop shadow, no glow, no texture. Use only ash white #B8C2CC and ink black #06070A unless told otherwise. FORBIDDEN: any text, letters, numbers, writing, logos or watermarks; the colours red, green, gold, orange or pink.

SUBJECT: A square game icon, the pictogram centred and filling about 85% of the image. An OPEN wooden gate: a gate frame with one leaf swung open inward.

BACKGROUND: the subject stands alone on a perfectly flat, uniform, pure magenta #FF00FF background that fills the whole image edge to edge. No shadow, no ground, no floor line, no vignette, no frame, no border, nothing else in the background. Never use magenta, pink or purple anywhere on the subject itself.

IMAGE: aspect ratio 1:1 (square).
```

## icon_decision_barracks_48

- Kaydedilecek ad: `tools/art/gelen/icon_decision_barracks_48.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/ui/icon_decision_barracks_48.png`, 48 x 48 piksel
- İstenecek oran: **1:1**
- Arka plan: düz macenta #FF00FF (betik siler)

```text
STYLE: flat 2D game user-interface graphic. One bold, simple shape, readable at 48 pixels. Thick ink-black #06070A outline, flat solid fills, hard square corners where there are corners. NO gradients, no shading, no bevel, no gloss, no 3D, no drop shadow, no glow, no texture. Use only ash white #B8C2CC and ink black #06070A unless told otherwise. FORBIDDEN: any text, letters, numbers, writing, logos or watermarks; the colours red, green, gold, orange or pink.

SUBJECT: A square game icon, the pictogram centred and filling about 85% of the image. An upright spear with a round shield leaning against it.

BACKGROUND: the subject stands alone on a perfectly flat, uniform, pure magenta #FF00FF background that fills the whole image edge to edge. No shadow, no ground, no floor line, no vignette, no frame, no border, nothing else in the background. Never use magenta, pink or purple anywhere on the subject itself.

IMAGE: aspect ratio 1:1 (square).
```

## icon_decision_bribe_48

- Kaydedilecek ad: `tools/art/gelen/icon_decision_bribe_48.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/ui/icon_decision_bribe_48.png`, 48 x 48 piksel
- İstenecek oran: **1:1**
- Arka plan: düz macenta #FF00FF (betik siler)

```text
STYLE: flat 2D game user-interface graphic. One bold, simple shape, readable at 48 pixels. Thick ink-black #06070A outline, flat solid fills, hard square corners where there are corners. NO gradients, no shading, no bevel, no gloss, no 3D, no drop shadow, no glow, no texture. Use only ash white #B8C2CC and ink black #06070A unless told otherwise. FORBIDDEN: any text, letters, numbers, writing, logos or watermarks; the colours red, green, gold, orange or pink.

SUBJECT: A square game icon, the pictogram centred and filling about 85% of the image. A coin pouch with one plain round coin beside it (no markings, no numbers).

BACKGROUND: the subject stands alone on a perfectly flat, uniform, pure magenta #FF00FF background that fills the whole image edge to edge. No shadow, no ground, no floor line, no vignette, no frame, no border, nothing else in the background. Never use magenta, pink or purple anywhere on the subject itself.

IMAGE: aspect ratio 1:1 (square).
```

## icon_decision_reject_48

- Kaydedilecek ad: `tools/art/gelen/icon_decision_reject_48.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/ui/icon_decision_reject_48.png`, 48 x 48 piksel
- İstenecek oran: **1:1**
- Arka plan: düz macenta #FF00FF (betik siler)

```text
STYLE: flat 2D game user-interface graphic. One bold, simple shape, readable at 48 pixels. Thick ink-black #06070A outline, flat solid fills, hard square corners where there are corners. NO gradients, no shading, no bevel, no gloss, no 3D, no drop shadow, no glow, no texture. Use only ash white #B8C2CC and ink black #06070A unless told otherwise. FORBIDDEN: any text, letters, numbers, writing, logos or watermarks; the colours red, green, gold, orange or pink.

SUBJECT: A square game icon, the pictogram centred and filling about 85% of the image. A CLOSED wooden gate barred by one heavy horizontal crossbar.

BACKGROUND: the subject stands alone on a perfectly flat, uniform, pure magenta #FF00FF background that fills the whole image edge to edge. No shadow, no ground, no floor line, no vignette, no frame, no border, nothing else in the background. Never use magenta, pink or purple anywhere on the subject itself.

IMAGE: aspect ratio 1:1 (square).
```

## ui_bar_segment_cracked_01

- Kaydedilecek ad: `tools/art/gelen/ui_bar_segment_cracked_01.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/ui/ui_bar_segment_cracked_01.png`, 22 x 30 piksel
- İstenecek oran: **3:4**
- Arka plan: düz macenta #FF00FF (betik siler)

```text
STYLE: flat 2D game user-interface graphic. One bold, simple shape, readable at 48 pixels. Thick ink-black #06070A outline, flat solid fills, hard square corners where there are corners. NO gradients, no shading, no bevel, no gloss, no 3D, no drop shadow, no glow, no texture. Use only ash white #B8C2CC and ink black #06070A unless told otherwise. FORBIDDEN: any text, letters, numbers, writing, logos or watermarks; the colours red, green, gold, orange or pink.

SUBJECT: A single vertical rectangular segment of a UI bar, like a flat stone slab, filling the ENTIRE image edge to edge, hard square corners. Solid ash white fill, thick ink border, ONE thick ink crack line zig-zagging from the top edge to the bottom edge.

BACKGROUND: the subject stands alone on a perfectly flat, uniform, pure magenta #FF00FF background that fills the whole image edge to edge. No shadow, no ground, no floor line, no vignette, no frame, no border, nothing else in the background. Never use magenta, pink or purple anywhere on the subject itself.

IMAGE: aspect ratio 3:4 (portrait).
```

## ui_bar_segment_cracked_02

- Kaydedilecek ad: `tools/art/gelen/ui_bar_segment_cracked_02.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/ui/ui_bar_segment_cracked_02.png`, 22 x 30 piksel
- İstenecek oran: **3:4**
- Arka plan: düz macenta #FF00FF (betik siler)

```text
STYLE: flat 2D game user-interface graphic. One bold, simple shape, readable at 48 pixels. Thick ink-black #06070A outline, flat solid fills, hard square corners where there are corners. NO gradients, no shading, no bevel, no gloss, no 3D, no drop shadow, no glow, no texture. Use only ash white #B8C2CC and ink black #06070A unless told otherwise. FORBIDDEN: any text, letters, numbers, writing, logos or watermarks; the colours red, green, gold, orange or pink.

SUBJECT: A single vertical rectangular segment of a UI bar, like a flat stone slab, filling the ENTIRE image edge to edge, hard square corners. Solid ash white fill, thick ink border, a thick ink crack from top to bottom with two side branches - the slab is about to split.

BACKGROUND: the subject stands alone on a perfectly flat, uniform, pure magenta #FF00FF background that fills the whole image edge to edge. No shadow, no ground, no floor line, no vignette, no frame, no border, nothing else in the background. Never use magenta, pink or purple anywhere on the subject itself.

IMAGE: aspect ratio 3:4 (portrait).
```

## ui_bar_segment_empty

- Kaydedilecek ad: `tools/art/gelen/ui_bar_segment_empty.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/ui/ui_bar_segment_empty.png`, 22 x 30 piksel
- İstenecek oran: **3:4**
- Arka plan: düz macenta #FF00FF (betik siler)

```text
STYLE: flat 2D game user-interface graphic. One bold, simple shape, readable at 48 pixels. Thick ink-black #06070A outline, flat solid fills, hard square corners where there are corners. NO gradients, no shading, no bevel, no gloss, no 3D, no drop shadow, no glow, no texture. Use only ash white #B8C2CC and ink black #06070A unless told otherwise. FORBIDDEN: any text, letters, numbers, writing, logos or watermarks; the colours red, green, gold, orange or pink.

SUBJECT: A single vertical rectangular segment of a UI bar, like a flat stone slab, filling the ENTIRE image edge to edge, hard square corners. EMPTY: only a thick ash white outline frame, the inside is background.

BACKGROUND: the subject stands alone on a perfectly flat, uniform, pure magenta #FF00FF background that fills the whole image edge to edge. No shadow, no ground, no floor line, no vignette, no frame, no border, nothing else in the background. Never use magenta, pink or purple anywhere on the subject itself.

IMAGE: aspect ratio 3:4 (portrait).
```

## ui_bar_segment_full

- Kaydedilecek ad: `tools/art/gelen/ui_bar_segment_full.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/ui/ui_bar_segment_full.png`, 22 x 30 piksel
- İstenecek oran: **3:4**
- Arka plan: düz macenta #FF00FF (betik siler)

```text
STYLE: flat 2D game user-interface graphic. One bold, simple shape, readable at 48 pixels. Thick ink-black #06070A outline, flat solid fills, hard square corners where there are corners. NO gradients, no shading, no bevel, no gloss, no 3D, no drop shadow, no glow, no texture. Use only ash white #B8C2CC and ink black #06070A unless told otherwise. FORBIDDEN: any text, letters, numbers, writing, logos or watermarks; the colours red, green, gold, orange or pink.

SUBJECT: A single vertical rectangular segment of a UI bar, like a flat stone slab, filling the ENTIRE image edge to edge, hard square corners. Solid ash white fill, thick ink border.

BACKGROUND: the subject stands alone on a perfectly flat, uniform, pure magenta #FF00FF background that fills the whole image edge to edge. No shadow, no ground, no floor line, no vignette, no frame, no border, nothing else in the background. Never use magenta, pink or purple anywhere on the subject itself.

IMAGE: aspect ratio 3:4 (portrait).
```

## ui_cursor_arrow_32

- Kaydedilecek ad: `tools/art/gelen/ui_cursor_arrow_32.png` (`.jpg`/`.webp` da olur)
- Hedef: `assets/art/ui/ui_cursor_arrow_32.png`, 32 x 32 piksel
- İstenecek oran: **1:1**
- Arka plan: düz macenta #FF00FF (betik siler)

```text
STYLE: flat 2D game user-interface graphic. One bold, simple shape, readable at 48 pixels. Thick ink-black #06070A outline, flat solid fills, hard square corners where there are corners. NO gradients, no shading, no bevel, no gloss, no 3D, no drop shadow, no glow, no texture. Use only ash white #B8C2CC and ink black #06070A unless told otherwise. FORBIDDEN: any text, letters, numbers, writing, logos or watermarks; the colours red, green, gold, orange or pink.

SUBJECT: A classic mouse pointer arrow pointing up-left, its sharp tip at the top-left corner of the image: ash white fill with a thick ink outline.

BACKGROUND: the subject stands alone on a perfectly flat, uniform, pure magenta #FF00FF background that fills the whole image edge to edge. No shadow, no ground, no floor line, no vignette, no frame, no border, nothing else in the background. Never use magenta, pink or purple anywhere on the subject itself.

IMAGE: aspect ratio 1:1 (square).
```
