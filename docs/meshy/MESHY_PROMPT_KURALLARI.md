# KURALLAR DOSYASI (Yapay Zeka Ajanı İçin Kesin Uygulama Yönergesi)

**AJANIN DİKKATİNE:** Bu dosya, Kapı Muhafızı oyunu için Meshy API'sinde 3D model ve animasyon üretecek yapay zeka ajanı için **kesin, esnetilemez ve doğrudan kopyalanabilir** sistem komutlarını içerir. Bu kuralların dışına çıkılması, API kredisinin boşa gitmesine ve projenin teknik olarak çökmesine neden olacaktır.

## 1. Uyması Zorunlu Stil ve Yasaklar

Üretilecek tüm modeller geç Ortaçağ (14. - 15. yüzyıl) Anadolu sınır boyu estetiğine uymak zorundadır. Oyunun doğasını bozan hiçbir unsur kabul edilemez.

- **İzin Verilen Malzemeler:** Aşınmış ahşap (worn wood), paslı demir (rusted hammered iron), kaba yün (coarse wool), keçe, kaba yontulmuş taş, deri, toprak ve toz.
- **Kesinlikle Yasak (YOKTUR):** Modern giysi/eşyalar, jenerik fantastik silahlar, parlayan büyülü objeler, abartılı şato gotik mimarisi, plastik görünümlü yansımalar.
- **Anatomi İhlalleri Yasaktır:** Karakterler "bipedal", normal insan ölçülerinde ve simetrik olmalıdır. Mobil oyun veya sevimli "chibi" tarzı yasaktır.
- **Yazı Yasağı:** Hiçbir 3D modelin yüzeyinde, kaplamasında, tabelasında veya kumaşında Latince, Arapça veya herhangi bir okunabilir/okunamaz uydurma yazı, amblem, logo BULUNAMAZ. ("no readable text, no letters" zorunludur).
- **Uçuşan Geometri Yasağı:** Model etrafında havada asılı duran parçalar, efektler veya çoklu nesneler yasaktır. ("single connected object, isolated on empty background" zorunludur).

## 2. Ortak Stil Çapası (Her Prompta Eklenecek)

Ajan, yazdığı her model betimlemesinin (prompt) sonuna aşağıdaki metin bloğunu **virgülle ayırarak** kesinlikle ekleyecektir:

> `", late medieval 14th century Anatolian frontier game asset, ottoman border, worn and dusty physical materials, grounded historical realistic style, serious tone, single connected object, no text, no letters, no modern elements"`

## 3. Lite / Standart ve Bütçe Seçim Kuralı (Sınıflandırma)

900 API kredilik bütçeyi korumak için aşağıdaki kural matrisinin dışına **çıkılamaz**:

- **Proplar (38 adet):** Kredi tasarrufu için SADECE MESH (Dokusuz) üretilecektir. `model_type: "smart-topology"`, `ai_model: "meshy-t2.5"`, **`should_texture: false`** kullanılacaktır. (Maliyet: 5 kredi).
- **İnsansılar (13 adet):** `model_type: "smart-topology"`, `ai_model: "meshy-t2.5"`, **`should_texture: true`**, **`pose_mode: "t-pose"`**. (Mesh+Doku 15 kredi, Rig 5 kredi. PBR haritaları eklenecek).
- **Yapılar (24 adet):** `model_type: "smart-topology"`, `ai_model: "meshy-t2.5"`, **`should_texture: true`**. (Maliyet: 15 kredi).
- **Hayvanlar (6 adet):** `model_type: "smart-topology"`, `ai_model: "meshy-t2.5"`, **`should_texture: true`**. (Maliyet: 15 kredi. RIG YAPILMAYACAKTIR).

## 4. İskelet (Rig) ve Animasyon Kuralları

- **Rig Sadece İnsansılara Yapılır:** Hayvanlara, proplara veya yapılara asla Rig API (`/openapi/v1/rigging`) isteği gönderilmeyecektir. Hayvanlarda API "Unprocessable Entity" hatası verir, krediyi boşa harcar.
- **Pozisyon ve Boyut:** İnsansılar üretilirken Text-to-3D aşamasında `pose_mode: "t-pose"` gönderilmesi, Rig aşamasında ise Godot dünyasına uyması için `height_meters: 1.7` (veya uygun insan boyu) parametresinin ayarlanması ZORUNLUDUR.
- **Animasyon API Kullanımı:** Elde edilen `rig_task_id` kullanılarak Animasyon API çağrısı yapılacaktır. 29 istenen eylem, kredi optimizasyonu için `action_ids` array parametresi içine virgülle dizilerek (Ör: `[10, 25, 92]`, istek başına en fazla 10 adet) gönderilmelidir. Bu sayede tüm klipler Godot'un `AnimationPlayer` nodu için tek bir GLB'de birleştirilir.

## 5. Teslim Öncesi Ajan Kontrol Listesi

Ajan, üretilen GLB önizlemesini (`thumbnail_url`) değerlendirmeli, şu hatalardan biri varsa modeli reddetmeli ve promptu iyileştirerek işlemi (reroll) tekrarlamalıdır:

1. [ ] Havada uçuşan anlamsız obje veya partiküller var mı? (Varsa Reddet).
2. [ ] Herhangi bir yüzeyde harf, yazı veya sembolik kelime oluşmuş mu? (Varsa Reddet).
3. [ ] İnsansı karakterde 3. kol, asimetrik bacak veya kılıcın karakterle kaynaşması var mı? (Varsa Reddet).
4. [ ] İnsansı karakter T-Pose duruşunda değil mi? (Kollar aşağıdaysa Rig bozulur, Reddet).
5. [ ] 38 Prop dokulu olarak mı üretildi? (Bütçe ihlali, Reddet, `should_texture: false` yap).

## 6. Sınıflara Göre Tam API Prompt / JSON Şablonları

*NOT: Aşağıdaki örnekler Meshy v2 API yapısına uygun, ajanın doğrudan kodunda kullanabileceği "Payload" örnekleridir.*

**Örnek A: ÇAVUŞ (İnsansı, Rig'e ve Dokuya Hazırlık)**

JSON

```
{
  "mode": "preview",
  "prompt": "A detailed bipedal human character, an older veteran village sergeant wearing a worn leather vest over a dirty coarse wool tunic, iron belt buckle, carrying a simple wooden staff, normal human anatomy, late medieval 14th century Anatolian frontier game asset, ottoman border, worn and dusty physical materials, grounded historical realistic style, serious tone, single connected object, no text, no letters, no modern elements",
  "model_type": "smart-topology",
  "ai_model": "meshy-t2.5",
  "pose_mode": "t-pose",
  "target_polycount": 15000,
  "target_formats": ["glb"]
}
```

*(Ajan bu preview tamamlanınca, `preview_task_id` alıp `mode: "refine"` ve `enable_pbr: true` ile dokulandırma isteği atmalıdır. Sonra Rig API çalıştırılmalıdır).*

**Örnek B: DERVİŞ (İnsansı, Rig'e ve Dokuya Hazırlık)**

JSON

```
{
  "mode": "preview",
  "prompt": "A detailed bipedal human character, a wandering mystic dervish wearing a ragged long coarse wool cloak, a conical felt hat, simple leather sandals, normal human anatomy, late medieval 14th century Anatolian frontier game asset, ottoman border, worn and dusty physical materials, grounded historical realistic style, serious tone, single connected object, no text, no letters, no modern elements",
  "model_type": "smart-topology",
  "ai_model": "meshy-t2.5",
  "pose_mode": "t-pose",
  "target_polycount": 15000,
  "target_formats": ["glb"]
}
```

**Örnek C: KÖY KAPISI (Yapı, Rig YOK, Doku VAR)**

JSON

```
{
  "mode": "preview",
  "prompt": "A medieval architecture structure, a robust border outpost village gate, thick weathered timber logs forming a palisade, heavy solid wood double doors with rusted iron hinges, mud on the base, isolated structure, late medieval 14th century Anatolian frontier game asset, ottoman border, worn and dusty physical materials, grounded historical realistic style, serious tone, single connected object, no text, no letters, no modern elements",
  "model_type": "smart-topology",
  "ai_model": "meshy-t2.5",
  "target_polycount": 30000,
  "target_formats": ["glb"]
}
```

**Örnek D: DEVE (Hayvan, Rig KESİNLİKLE YOK, Doku VAR)**

JSON

```
{
  "mode": "preview",
  "prompt": "A quadruped animal, a sturdy Anatolian pack camel, worn brown fur, equipped with empty wooden panniers strapped with rough leather belts, natural standing pose, late medieval 14th century Anatolian frontier game asset, ottoman border, worn and dusty physical materials, grounded historical realistic style, serious tone, single connected object, no text, no letters, no modern elements",
  "model_type": "smart-topology",
  "ai_model": "meshy-t2.5",
  "target_polycount": 15000,
  "target_formats": ["glb"]
}
```

**Örnek E: MEŞALE (Prop, SADECE MESH / DOKU YOK, Bütçe Kurtarıcı)**

JSON

```
{
  "mode": "preview",
  "prompt": "A static game prop, a rustic hand-held torch made from a split rough wooden branch, tightly bound with dark iron wire at the top holding unlit rags, isolated object, late medieval 14th century Anatolian frontier game asset, ottoman border, worn and dusty physical materials, grounded historical realistic style, serious tone, single connected object, no text, no letters, no modern elements",
  "model_type": "smart-topology",
  "ai_model": "meshy-t2.5",
  "should_texture": false,
  "target_polycount": 4000,
  "target_formats": ["glb"]
}
```

## Kaynaklar

1. [docs.meshy.ai — Game Assets: Create 3D Game Models with AI | Meshy Docs](https://docs.meshy.ai/en/webapp/guides/use-cases/game-assets)
2. [typingmind.com — Meshy 3d by calesthio — AI Skill for Any LLM | TypingMind](https://www.typingmind.com/skills/calesthio-meshy-3d)
3. [docs.meshy.ai — 3D Prompting Guide: Best Practices and Pro Tips | Meshy Docs](https://docs.meshy.ai/en/webapp/guides/prompting)
4. [docs.meshy.ai — Text to 3D: Generate 3D Models from Prompts | Meshy Docs](https://docs.meshy.ai/en/webapp/text-to-3d)
5. [docs.meshy.ai — Image to 3D API - Meshy Docs](https://docs.meshy.ai/en/api/image-to-3d)
6. [docs.meshy.ai — Metinden 3D'ye API - Meshy Docs](https://docs.meshy.ai/tr/api/text-to-3d)
7. [docs.meshy.ai — Creative Lab — Vinyl Figure API | Meshy Docs](https://docs.meshy.ai/en/api/creative-lab-vinyl-figure)
8. [docs.meshy.ai — คู่มือ 3D prompt: แนวทางและเคล็ดลับ - Meshy Docs](https://docs.meshy.ai/th/webapp/guides/prompting)
9. [fal.ai — Meshy 7.1 Image to 3D API Docs - Fal.ai](https://fal.ai/models/meshy/v7.1/image-to-3d/api)
10. [docs.meshy.ai — Changelog - Meshy Docs](https://docs.meshy.ai/en/api/changelog)
11. [comfy.icu — meshy / v7 / imageTo3D - ComfyUI Cloud - Comfy.ICU](https://comfy.icu/node/CivitaiPolyGenFalMeshyV7ImageTo3D)
12. [docs.meshy.ai — Text to 3D API - Meshy Docs](https://docs.meshy.ai/en/api/text-to-3d)
13. [docs.meshy.ai](https://docs.meshy.ai/en/api/pricing)
14. [parse.gl — I cannot create 3D assets fast enough for our game… - Parse](https://parse.gl/questions/i-cannot-create-3d-assets-fast-enough-for-our-game-development-pipeline-who-offers-generative-ai-for-3d-textures-and-meshes--ebbd1016-a243-4a45-bf2c-112cdb23d9af)
15. [github.com — Meshy for Game Asset Generation: Workflows for Unity, Unreal](https://github.com/meshy-dev/game-asset-pipeline)
16. [docs.meshy.ai — Multi-Image to 3D API - Meshy Docs](https://docs.meshy.ai/en/api/multi-image-to-3d)
17. [pixazo.ai — Meshy 7.1 API, Meshy 7 API, Meshy 6 API: Pricing, Documentation](https://www.pixazo.ai/models/meshy-3d)
18. [docs.meshy.ai — Rigging API - Meshy Docs](https://docs.meshy.ai/en/api/rigging)
19. [wavespeed.ai — Meshy V7.1 Multi Image To 3d API Documentation - WaveSpeedAI](https://wavespeed.ai/docs/docs-api/meshy/meshy-v7.1-multi-image-to-3d)
20. [docs.meshy.ai — Text to Motion API - Meshy Docs](https://docs.meshy.ai/en/api/text-to-motion)
21. [docs.meshy.ai — Animation API - Meshy Docs](https://docs.meshy.ai/en/api/animation)
22. [docs.meshy.ai — API de Animación | Meshy Docs](https://docs.meshy.ai/es/api/animation)
23. [mocaponline.com — Godot Animation System Guide: AnimationPlayer - MoCap Online](https://mocaponline.com/blogs/mocap-news/godot-animation-system-guide)
24. [stackoverflow.com — Animation player Tree how to use for gdscript (Godot 4.0)](https://stackoverflow.com/questions/75695489/animation-player-tree-how-to-use-for-gdscript-godot-4-0)
25. [docs.godotengine.org — Using AnimationTree — Godot Engine (4.4) documentation in English](https://docs.godotengine.org/en/4.4/tutorials/animation/animation_tree.html)
26. [reddit.com — State Machine connecting to animation tree : r/godot - Reddit](https://www.reddit.com/r/godot/comments/1qk793r/state_machine_connecting_to_animation_tree/)
27. [ludo.ai — How to Import an AI-Generated Rigged GLB into Godot, Unity](https://ludo.ai/docs/3d-generator/export-to-unity-godot-unreal)
28. [hatchery3d.com — Godot 4: import a GLB character with animations · Hatchery3D](https://hatchery3d.com/blog/rigged-glb-character-in-godot-4)
29. [glama.ai — meshy_multi_image_to_3d - Meshy MCP Server | Glama](https://glama.ai/mcp/servers/meshy-dev/meshy-mcp-server/tools/meshy_multi_image_to_3d)
30. [app.cinevva.com — Blender to Godot 4 Export Checklist: glTF Settings, Animations, and](https://app.cinevva.com/guides/blender-to-godot-export-checklist)
31. [github.com — CITY-ZERO/docs/CONTENT_PIPELINE.md at main · stuffthings15](https://github.com/stuffthings15/CITY-ZERO/blob/main/docs/CONTENT_PIPELINE.md)
32. [docs.meshy.ai — Remesh API - Meshy Docs](https://docs.meshy.ai/en/api/remesh)
33. [humgen3d.com — Export to Godot | Human Generator docs](https://humgen3d.com/docs/process/export-to-godot)
34. [uhiyama-lab.com — Godot 3D Model Import Basics: Bring In glTF, Fix Its Scale and](https://uhiyama-lab.com/en/notes/godot/3d-model-import-gltf-retarget/)
