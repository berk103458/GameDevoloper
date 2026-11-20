# Üçüncü parti araçlar

Kapı Muhafızı `project.godot` özelliği `4.7` / Forward Plus. Sabitlenen motor `4.7.2.stable.official.ed1daf0bf` (`docs/engine-reference/godot/VERSION.md`). Bu dosyadaki araçlar o sürüme göre seçildi.

Kurulum kuralı: git submodule yok. Dosyalar belirli bir commit'ten kopyalandı. Lisans, eklentinin klasöründe durur. `project.godot` içinde hiçbir eklenti etkinleştirilmedi. Etkinleştirme ve editörde deneme Kalfa görevindedir: `codex.md/Kalfa_gorev_eklentiler.md`.

Parley ve Theatre bu turda kurulmadı. Onların denemesi `codex.md/Antigravity_gorev.md` içindeki Görev 2'dir.

## Sürüm kararı

| Araç | İstediği Godot | Karar |
| --- | --- | --- |
| godot-mcp 0.6.1 | 4.4+ | Kuruldu. Proje 4.7.2. |
| HammerForge | 4.7+ (4.7.stable üzerinde denenmiş) | Kuruldu. Proje 4.7.2, alt sınırla çakışmıyor. |
| Cognite | Rozet 4.6; kendi demo `project.godot` özelliği 4.6. `plugin.cfg` sürüm kilidi yok. | Kuruldu. 4.7'yi dışlayan bir alt/üst sınır yok. |
| gdTree3D | 4.5+; `compatibility_minimum = 4.5`. İkililer godot-cpp `4.5` dalıyla derlenmiş. | Kuruldu. 4.7.2 bu aralığın içinde. |
| Dingo | README: Godot 4. Sürüm kilidi yok. | Kuruldu. |

HammerForge "4.7 istiyor" diye elenmedi: oyunun kendi sürümü de 4.7.2.

## Headless içe aktarma

Komut, resmi Linux ikilisiyle:

`Godot_v4.7.2-stable_linux.x86_64 --headless --path <proje> --import`

İkili: Godot Engine v4.7.2.stable.official.ed1daf0bf.

Bu VM'de Godot yoktu. Resmi Linux ikilisi indirildi: `Godot_v4.7.2-stable_linux.x86_64`, sürüm satırı `4.7.2.stable.official.ed1daf0bf`.

Sonuç: çıkış kodu 0. `SCRIPT ERROR` yok. `Failed to load script` yok. GDExtension doğrulama adımı hata basmadan geçti; `libTree3D` için yükleme hatası yazılmadı. Bu, Windows editöründe Tree3D düğmesinin üretildiğini kanıtlamaz. Kalfa onu ayrıca çalıştırır.

İki içe aktarma uyarısı var. İkisi de üst depodan geldi, bu turda üretilmedi:

- `addons/hammerforge/icons/player_start.png` 1×1 gri PNG. Godot `ERR_FILE_CORRUPT` verdi, `.import` dosyasında `valid=false`. Betik hatası değil.
- Sci-fi FBX dosyaları `initialShadingGroup_Base_color (1).png` arıyor. Bu PNG depoda yok; yol FBX'in içine gömülü. Godot dosyayı açamadı. Zindan örnekleri bu dokuya bağlı değil.

`project.godot` import sırasında değişmedi. Eklentiler kapalı kaldı. Import'un ürettiği `data/metin/metinler.tr.translation` farkı ve oyunun eski betiklerine yazdığı `.uid` dosyaları bu pakete alınmadı.

## 1. godot-mcp

- Kaynak: https://github.com/tomyud1/godot-mcp
- Commit / sürüm: `2c1f30088437d9d842eb6b32069f93b979e718ec` (etiket `v0.6.1`, 2026-10-17)
- Lisans: MIT, Copyright (c) 2025-2026 Tomer Yud. Dosya: `addons/godot_mcp/LICENSE` ve `tools/ucuncu_parti/godot-mcp-server/LICENSE`
- Ne işe yarar: Editör eklentisi, yapay zeka istemcisinin sahne, betik ve proje ayarını WebSocket üzerinden okuyup yazması için 69 araç sunar. Ayrı Node.js süreci MCP sunucusudur.
- Kurulum yolu: `addons/godot_mcp/` (editör eklentisi). Sunucu kaynakları: `tools/ucuncu_parti/godot-mcp-server/` (aynı commit, `node_modules` yok).

### MCP sunucusu (bu makinede çalıştırılmadı)

Sunucu Godot eklentisi değildir. Editör eklentisi `6505` portunda WebSocket bekler. Görsel gezgin `6510` portundadır. İkisi de yalnız localhost.

Windows (Ahmet'in makinesi), Cursor veya Claude Desktop:

```json
{
  "mcpServers": {
    "godot": {
      "command": "cmd",
      "args": ["/c", "npx", "-y", "godot-mcp-server@0.6.1"]
    }
  }
}
```

Linux / macOS:

```json
{
  "mcpServers": {
    "godot": {
      "command": "npx",
      "args": ["-y", "godot-mcp-server@0.6.1"]
    }
  }
}
```

Sabitlenmiş kaynaktan kurmak (npm paketini kullanmadan):

```bash
cd tools/ucuncu_parti/godot-mcp-server
npm install
npm run build
node dist/index.js
```

İstemci komutu o zaman `node` ve argüman `tools/ucuncu_parti/godot-mcp-server/dist/index.js` olur. Node.js LTS gerekir. Eklenti Project Settings → Plugins içinde açılmadan sunucu editöre bağlanamaz. Bu depoda açılmadı.

## 2. HammerForge

- Kaynak: https://github.com/saworbit/hammerforge
- Commit / sürüm: `e4cc86091a87a5a74ae5ee117a4049fb7fc7ea5f` (main, 2026-11-02). `plugin.cfg` sürümü `0.4.1-dev`. Etiket `v0.4.0` bu commit'ten öncedir; kurulan ağaç etiketten yenidir.
- Lisans: MIT, Copyright (c) 2026 Shane Wall. Dosya: `addons/hammerforge/LICENSE`
- Ne işe yarar: Godot editörünün içinde fırçayla oda, kapı, zemin ve arazi çizen seviye editörü. Pişirme editörde yapılır.
- Kurulum yolu: `addons/hammerforge/`
- Örnek sahneler: `addons/hammerforge/ornek/` (`hf_sample_minimal.tscn` küçük zemin ve duvar). Üst depodaki `samples/` buraya taşındı. `hf_sample_stress.tscn` içindeki spawner yolu `res://addons/hammerforge/ornek/hf_stress_spawner.gd` oldu. Editör duman aracı (`tools/prepare_editor_smoke.gd`) eklenti parçası olmadığı için kopyalanmadı.
- Kopyalanmayanlar: HammerForge deposunun kendi oyunu, `addons/gut` test çerçevesi, doküman görselleri.

## 3. Cognite

- Kaynak: https://github.com/matheus-s-arruda/Cognite
- Commit / sürüm: `70d8fca72848324623751de083126bd9803ab96c` (main, 2026-02-16, "Update lith_ia.tres"). Son etiket `v3.0` (`6419e1824dd1e1c65644ee4ad6f59464c2cdfb5d`) bu commit'ten eskidir. README bu ağacı "Update 4.0" diye anlatır: grafik durum makinesi kaldırılmış, algı / bağlam / skor / eylem düzeni gelmiştir. Görsel bir graf editörü bu commit'te yoktur; editör dock'u skor tablosudur.
- Lisans: MIT, Copyright (c) 2023 Matheus arruda. Dosya: `addons/cognite/LICENSE`
- Ne işe yarar: NPC kararını skorlayan davranış kurucusu. `CogniteNode` algıları okur, bağlamlar skora döner, eylemler deed olarak sırayla veya paralel çalışır.
- Kurulum yolu: `addons/cognite/`
- Örnek: `addons/cognite/ornek/example.tscn` ve `lith_ia.tres`. Üst deponun `assets/`, `scripts/` ve örnek kaynakları oyun köküne konmadı; yollar `res://addons/cognite/ornek/` altına çevrildi. Demo `project.godot` kopyalanmadı.

## 4. gdTree3D

- Kaynak: https://github.com/JekSun97/gdTree3D
- Commit / sürüm: `e9ec657b0ee3667ac11dddad6133d52274c656f7` (2026-09-14, PR #39 kütüphaneleri). `.gdextension` içindeki yazı `v1.0` güncel değil. Son etiket `v1.1.0`.
- Lisans: MIT, Copyright (c) 2024 Artyom Bozhko and contributors. Dosya: `addons/Tree3D/LICENSE.md`
- Ne işe yarar: C++ GDExtension. `Tree3D` düğümü prosedürel gövde, dal, yaprak, çarpışma ve rüzgar rengi üretir.
- Kurulum yolu: `addons/Tree3D/` (`.gdextension` bu yolu bekler). Örnek sahneler: `addons/Tree3D/ornek/tree_3d.tscn` ve `forest.tscn`. Demo dokuları oyun köküne konmadı; `res://` yolları `res://addons/Tree3D/ornek/` oldu.
- İkililer: Bu commit'teki hazır kütüphaneler kullanıldı. Ayrı release zip indirilmedi. Windows x86_64: `libTree3D.windows.template_release.x86_64.dll` ve `libTree3D.windows.template_debug.x86_64.dll` (32 bit karşılıkları da duruyor). Linux `.so` ve macOS kütüphaneleri de aynı klasörde. CI bu ikilileri godot-cpp dalı `4.5` ile üretir.

Yeniden derlemek gerekirse (bu turda derlenmedi):

1. Aynı commit'i ayrı bir klasöre al.
2. `godot-cpp` deposunu `4.5` dalıyla `godot-cpp/` altına, alt modülleriyle koy. 4.7.2'ye karşı derlenecekse godot-cpp dalını `4.7` yap ve `.gdextension` içindeki `compatibility_minimum` değerini o sürüme çek.
3. `scons target=template_release arch=x86_64 platform=windows`
4. Üretilen `libTree3D.*` dosyasını `addons/Tree3D/` içine, `.gdextension` satırındaki adla koy.
5. Linux ve Windows için depodaki Dockerfile aynı işi yapar: `docker build -t tree3dbuilder:latest .` sonra `docker run --rm -v "$(pwd):/source" tree3dbuilder:latest scons target=template_release arch=x86_64 platform=windows`.

GDExtension, Project Settings eklenti listesinden bağımsız yüklenir. Dosya diskte olduğu sürece motor açılışta kitaplığı dener.

## 5. Dingo

- Kaynak: https://github.com/benjtek01/dingo-godot-addon
- Commit / sürüm: `985285f06fb8ace9651062352604d8e16d044de7` (2026-01-08, "new logo"). Etiket yok.
- Lisans: MIT, Copyright (c) 2025 Benji Lising. Dosya: `addons/dingo/LICENSE`. Örnek doku ve FBX paketleri aynı deponun içindedir; ayrı bir lisans dosyası yok.
- Ne işe yarar: GridMap üzerine oda tipi, kapı ve koridorla prosedürel zindan yerleşimi. `plugin.cfg` yok; `@tool` betiği `dingo_generator.gd`, düğüm `RoomType`.
- Kurulum yolu: `addons/dingo/`
- Örnek sahne: `addons/dingo/Scenes/Example Scenes/dungeon_starter_example.tscn`
- Yol düzeltmesi: Üst sahneler iki farklı köke bakıyordu (`res://Dingo - Dungeon Generator Plugin/` ve `res://Dingo - Procedural room generrator/`). Diskteki klasör ikincisiydi ve `plugin.cfg` yoktu. İkisi de `res://addons/dingo/` olacak şekilde metin kaynaklarda değiştirildi. Davranış kodu değiştirilmedi.

## Bilerek kurulmayanlar

- https://github.com/bisterix-studio/parley — graf diyalog, Godot 4.4+, MIT. Görev 2.
- https://github.com/nndda/Theatre — düz metin diyalog, Godot 4.4+, MIT. Görev 2.

## Oyunla ilişki

Bu araçlar kapı, köy ve kayıt koduna bağlanmadı. `src/` ve `project.godot` değişmedi. Yeni oyun görseli üretilmedi. Eklenti örneklerindeki doku ve model, aracın kendi MIT paketidir.

## 6. Parley (Görev 2)

- Kaynak: https://github.com/bisterix-studio/parley
- Commit / sürüm: `ef75bc30a5307ce118645d3463091d6c9adf1718` (sürüm etiketi `2.1.0`, Godot 4.4+)
- Lisans: MIT, Copyright (c) 2025 Bisterix Studio. Dosya: `addons/parley/LICENSE`. README'deki treeware rozeti bağış çağrısıdır; yasal lisans `LICENSE` metninde tam MIT'dir.
- Ne işe yarar: Graf düğümleriyle diyalog dizisi (sequence) ve akışı tasarlayan editör eklentisi. Düğümler: Dialogue, Dialogue Option, Condition, Match, Action, Jump, Group, Start, End. Karakter (`ParleyCharacterStore`), eylem (`ParleyActionStore`) ve olgu (`ParleyFactStore`) depoları ve CSV/GNUText yerelleştirme desteği sunar.
- Kurulum yolu: `addons/parley/` (dosyalar ve `plugin.cfg` korunmuştur).
- Godot 4.7.2 uyumu: Uyumlu; headless ve editör import'unda SCRIPT ERROR veya Failed to load vermeden yüklendi. Yalnızca `feature/diyalog-eklenti-denemesi` dalında `project.godot` eklenti listesinde etkinleştirildi.

## 7. Theatre (Görev 2)

- Kaynak: https://github.com/nndda/Theatre
- Commit / sürüm: `11c19e1b02eae7ed7eb7c83b9da9c70532b8107d` (sürüm etiketi `0.12.2`, Godot 4.4+)
- Lisans: MIT, Copyright (c) 2023-2025 nnda. Dosya: `addons/Theatre/LICENSE`.
- Ne işe yarar: Düz metinle yazılan, satır satır ilerleyen diyalog eklentisi. Tamamı GDScript. `Dialogue.load`, `TheatreStage.start`, `progress` akışıyla çalışır. Değişken atama ve `Expression` tabanlı ifade değerlendirmesi içerir.
- Kurulum yolu: `addons/Theatre/`
- Godot 4.7.2 uyumu: Uyumlu; headless ve editör import'unda SCRIPT ERROR veya Failed to load vermeden yüklendi. Yalnızca `feature/diyalog-eklenti-denemesi` dalında `project.godot` eklenti listesinde etkinleştirildi.

## 8. 20 Kasım 2026 eklenti paketi

Dialogue Manager, Sky3D, Terrain3D, LimboAI, GdPlanningAI, ProtonScatter ve Instanced Renderer bu turda `addons/` altına kondu ve (`plugin.cfg` olanlar) `project.godot` içinde etkinleştirildi. Sürüm, commit, lisans ve alınmayan Instanced Renderer 2.0.0 notu: `docs/EKLENTI_LISANSLARI.md`. Oyun sahnelerine bağlanmadı.
