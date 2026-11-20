# Eklenti lisansları

20 Kasım 2026, Cursor. Godot 4.7.2 (`ed1daf0bf`). Dosyalar belirli bir etiketten veya release zip'inden kopyalandı; git submodule yok. Oyun sahneleri ve `src/` değişmedi. `project.godot` yalnız eklenti listesi ile iki autoload ekler.

Headless sınama: `Godot_v4.7.2-stable_linux.x86_64 --headless --editor --import --quit`. İkinci koşu çıkış 0. Yeni `SCRIPT ERROR`, `Parse Error` ve `Failed to load script` yok. Kapanıştaki PagedAllocator / RID satırları bu turdan önce de vardı.

## Kurulu

| Ad | Sürüm | Lisans | Kaynak | Commit / etiket | Klasör |
| --- | --- | --- | --- | --- | --- |
| Dialogue Manager | 4.2.0 | MIT, Nathan Hoad. `addons/dialogue_manager/LICENSE` | https://github.com/nathanhoad/godot_dialogue_manager | `bbf9d2a5f6a9eaa276310eea8b1379a936239d2e`, etiket `v4.2.0` (Godot 4.7) | `addons/dialogue_manager/` |
| Sky3D | 2.1.0 | MIT. `addons/sky_3d/LICENSE.txt`. Gölgelendirici: J. Cuéllar, MIT, `addons/sky_3d/shaders/LICENSE`. Ay haritası: GPoSM 2019, MIT, `addons/sky_3d/assets/thirdparty/textures/moon/LICENSE.md` | https://github.com/TokisanGames/Sky3D | `6e151bc3d941906643443b3751a1df545a08feda`, etiket `v2.1.0` (Godot 4.3+) | `addons/sky_3d/` |
| Terrain3D | 1.1.0 | MIT, Cory Petkovsek, Roope Palmroos ve katkıcılar. `addons/terrain_3d/LICENSE.txt` | https://github.com/TokisanGames/Terrain3D | `629bbd65526bbdc3d1aa371840c7028055c30b02`, etiket `v1.1.0-stable`. Zip: `Terrain3D_v1.1.0-stable.zip` | `addons/terrain_3d/` |
| LimboAI | 1.8.1 | MIT, Serhii Snitsaruk ve katkıcılar. `addons/limboai/LICENSE.md`. Logo ayrı: `LOGO_LICENSE.md` | https://github.com/limbonaut/limboai | `e45e60e976dafab7f2c15cc341ae366e4cf3352b`, etiket `v1.8.1`. Zip: `limboai+v1.8.1.gdextension-4.6.zip` (README: 4.6 ve üzeri, 4.7.2'de yüklendi) | `addons/limboai/` |
| GdPlanningAI | 1.0.0 | Apache-2.0, Ethan Wilson. `addons/GdPlanningAI/LICENSE.txt` | https://github.com/WahahaYes/GdPlanningAI | `29912aae282332cbc8d9134a58ad242f1a2db026`, etiket `v1.0.0`. Zip: `GdPlanningAI-1.0.0.zip` | `addons/GdPlanningAI/` |
| ProtonScatter | 4.2.0 | MIT, HungryProton. `addons/proton_scatter/LICENSE` | https://github.com/HungryProton/scatter | `7198cc00078ebde61307578137c3f35223c6e438` (main, 2026-09-27). Etiket yok; `plugin.cfg` sürümü 4.2.0 | `addons/proton_scatter/` |
| Instanced Renderer | 1.3 | Unlicense (kamu malı), Myle. `addons/instanced_renderer/LICENSE.md` | https://github.com/MyleAtaraxia/InstancedRenderer | etiket `v1.3`, zip `instanced_renderer.zip` (2026-10-29). `compatibility_minimum` 4.4 | `addons/instanced_renderer/` |

## Alınmayan sürüm

Instanced Renderer **2.0.0** (MIT, commit `2fe5fd50f755e23c0f989297e6494bc8b58a2efa`, 2026-11-08) Godot 4.4+ diye yazıyor, fakat resmi Linux ikilisi `GLIBC_2.43` istiyor. Bu ortam GLIBC 2.39. Godot kütüphaneyi açamadan `Can't open GDExtension dynamic library` yazıyor. 1.3'ün Linux ikilisi GLIBC 2.38 ile yetiniyor ve 4.7.2 açılışında yükleniyor. Windows x86_64 DLL'i 1.3 paketinin içindedir.

## Etkinleştirme

`project.godot` → `editor_plugins`: Dialogue Manager, Sky3D, Terrain3D, GdPlanningAI, ProtonScatter. Parley ve Theatre duruyor.

Autoload, eklentinin kendi `_enable_plugin` adımıyla aynı: `DialogueManager`, `GdPAIAutoload`.

LimboAI ve Instanced Renderer `plugin.cfg` taşımaz. `.gdextension` dosyası açılışta yüklenir; Project Settings listesinde satırları yoktur.

## Bilerek dışarıda bırakılanlar

- Sky3D `demo/` ve ekran görüntüleri.
- Terrain3D kök `demo/` (modeller ve örnek sahneler). `addons/terrain_3d` içindeki fırça ve `extras` duruyor; eklentinin parçası.
- ProtonScatter `demos/` (Textures.com dokuları ve büyük blend). `presets/grass.tscn` ve `presets/scatter_default.tscn` bu demo sahnelerine baktığı için silindi. `tests/unit_testing.tscn` aynı nedenle silindi. Eklenti betikleri duruyor.
- GdPlanningAI örnek sahneleri ve `bin/.gitignore` (release DLL/SO'yu gizlerdi).
- Instanced Renderer 2.0.0 içindeki `GDProgress` kopyası; 1.3 paketinde yok.

## Yerel yama

`addons/terrain_3d/src/double_slider.gd`: headless Godot 4.7, `interface/editor/display_scale` ayarını boş döndürüyor. Nil bir `int`e yazılınca SCRIPT ERROR oluyordu. Boş değer 100% ölçeğe düşer. Dolu editör ayarı eskisi gibi okunur.

`addons/GdPlanningAI/scripts/nodes/gdpai_agent.gd`: zamanlayıcı araması genel `GdPAIAutoload` adı yerine `Engine.get_main_loop().root.get_node(^"/root/GdPAIAutoload")`. Genel ad, autoload kaydından önce derlenen betikte yoktu; hata zinciri JSON sözlüklerini boşaltıyordu.

## Üçüncü parti doku (Sky3D)

Samanyolu panoraması ESO/S. Brunier, CC BY 4.0. Dosya: `addons/sky_3d/assets/thirdparty/textures/milkyway/LICENSE.md`. Köy göğü Sky3D kubbesini kullandığı için bu kredi geçerlidir: `The Milky Way panorama by ESO/S. Brunier, licensed under CC BY 4.0`.

## Köylü yapay zekası

İkisi de yüklendi ve ikisi de bağlandı. Ayrıntı: `docs/EKLENTI_BAGLANTI.md`. Sınıf adları çakışmıyor. Yeni genel `Action` / `Goal` adı eklenmedi; planlayıcı eklentinin sınıflarını önekssiz `class_name` olmadan kullanır.

LimboAI köylü, hayvan ve tüccar görselinin gündüz iş, bekleme, gece eve dönüş ve alarm katmanıdır. GdPlanningAI bunun üstünde, en çok üç kişi için açlık, su ve pazar planıdır. Anahtar `data/ayarlar/eklenti_bag.json`.

## Ahmet'in makinesinde

1. `claude/festive-volta-li1sfm` dalında `git pull`.
2. Projeyi Godot 4.7.2 ile aç. Project → Project Settings → Plugins: Dialogue Manager, Sky3D, Terrain3D, GdPlanningAI, ProtonScatter etkin görünsün.
3. GDExtension için derleme yok. Windows x86_64 DLL'leri depoda: `addons/terrain_3d/bin/libterrain.windows.*.x86_64.dll`, `addons/limboai/bin/liblimboai.windows.*.x86_64.dll`, `addons/GdPlanningAI/bin/windows/gdplanningai_rust.dll`, `addons/instanced_renderer/bin/libInstancedRenderer.windows.*.x86_64.dll`.
4. Create New Node içinde `Terrain3D`, `Sky3D`, `BTPlayer`, `InstancedMesh3D`, `ProtonScatter`, `GdPAIAgent` görünmeli. Görünmezse Output'taki GDExtension satırını not et.
