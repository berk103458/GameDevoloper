# Quest system plan — Kapı Muhafızı

Status: **phase 1, plan only.** This document does not install a plugin, does not change game code, and does not mark any ROADMAP row done. Implementation is a later slice, after this plan is accepted.

Pinned facts below were read from `claude/festive-volta-li1sfm` (HEAD at plan time `018f4c9`) and from QuestSystem **2.0.1** tag `2.0.1.4_4`.

## What stays in charge

| Authority | Owner today | Quest slice |
| --- | --- | --- |
| Gate lines | `data/diyalog/diyalog_01_20.json`, `KapiEkrani`, named `SohbetVerisi` | Unchanged. KAP-01 stays locked. No Dialogic, no Dialogue Manager, no quest nodes inside the dialogue JSON. |
| Night event cards | `OlayVerisi` + `Oturum.bayraklar` + `Oturum.gorulen_olaylar` | Unchanged. Quests read flags. They do not replace the card picker in `Oturum.olay_sec()`. |
| Purse | One village purse: `KoyYonetimi.akce` / `Oturum.akce` | Unchanged. `koy_akce` / `muhafiz_akce` are still open as EKO-01. Trial quests pay nothing. |
| Save | `Oturum.kaydet()` → `Ana` → `GuvenliKayit` (`user://savegame.json`, `.tmp` then `.bak`) | One optional dictionary key added inside the existing payload. |
| Autoload | `project.godot` has a single autoload: `Ses` | A second autoload named `QuestSystem`, appended after `Ses`. |
| Heybe | `class_name Heybe` (not an autoload), `HeybePaneli` | Unchanged. Bribe, search, and confiscation stay in `Oturum.karar_ver()`. |

Festive rule (`AGENTS.md`): new feature = new files + a thin adapter. Protected files (`oturum.gd`, `koy_ekrani.gd`, `project.godot`) get the smallest possible hook, in their own commit, after a fresh fetch of festive. `tema.gd`, `hud.gd`, `ana.gd`, `kapi_ekrani.gd`, and `guvenli_kayit.gd` stay untouched.

## 1. Install QuestSystem 2

### Package

- Asset Library id **3809**, version **2.0.1** (submitted 2025-05-05, MIT, Godot 4.4+).
- Git tag to vendor: `2.0.1.4_4` on <https://github.com/shomykohai/quest-system>.
- Docs: <https://shomykohai.github.io/quest-system/>.
- This project is Godot **4.7** (`project.godot` features `4.7`, pin in `docs/engine-reference/godot/VERSION.md` is 4.7.2). 2.0.1 is the 4.4+ line. The 1.x line is for Godot 4.0–4.3 and must not be installed.
- Copy only `addons/quest_system/` (scripts, `.uid` files, `plugin.cfg`, `LICENSE`, editor icon). Leave the example repos (`quest-system-example`, `advanced-quest-system-example`) out of this project. Upstream `plugin.cfg`: name `QuestSystem`, script `plugin.gd`, version `2.0.1`.

### How the autoload is registered

The addon is an **editor plugin**. On `_enter_tree` it:

1. Calls `QuestSystemSettings.initialize()`, which **writes `project.godot`** (`ProjectSettings.save()`).
2. Reads `quest_system/config/autoload_script_path`.
3. Calls `add_autoload_singleton("QuestSystem", <that path>)`.

The singleton name is fixed as `QuestSystem`. That name does not collide with `Ses`, `Heybe`, `Oturum`, `Katalog`, or `GuvenliKayit`. There is no `class_name Quest` in this repo today; the addon will register global classes `Quest`, `QuestSystemManagerAPI`, `AbstractQuestManagerAPI`, `BaseQuestPool`, `QuestSystemSettings`. Game scripts that need a quest type should use a project class (`GorevKaydi`) so call sites stay in Turkish-domain names.

### Enable order (so Ses and KAP-01 survive)

1. Vendor `addons/quest_system/` in one commit. Do not enable the plugin yet.
2. In that same commit, hand-write the override **before** the editor ever runs the plugin:

```ini
[quest_system]

config/autoload_script_path="res://src/sistemler/gorev_yoneticisi.gd"
config/check_for_updates_on_startup=false
config/require_objective_completed=true
config/allow_repeating_completed_quests=false
```

`gorev_yoneticisi.gd` must `extend` `QuestSystemManagerAPI` (which itself extends `AbstractQuestManagerAPI`). The plugin rejects anything else and falls back to `quest_manager.gd`.

3. Enable the plugin once in the editor (or add the two lines below by hand if the editor is not available). Expected `project.godot` result:

```ini
[autoload]

Ses="*res://src/sistemler/ses.gd"
QuestSystem="*res://src/sistemler/gorev_yoneticisi.gd"

[editor_plugins]

enabled=PackedStringArray("res://addons/quest_system/plugin.cfg")
```

4. Review the **entire** `project.godot` diff after `ProjectSettings.save()`. Keep `Ses` first, keep `run/main_scene`, display size, and `locale/translations`. The settings helper can reorder keys; that diff is part of the review, not something to accept blindly.
5. Headless import must finish with no `SCRIPT ERROR` / `Failed to load script` before any quest resource is wired (`AGENTS.md` §5).

`check_for_updates_on_startup=false` keeps the editor plugin from calling out on startup. The update check lives in the editor plugin, so an exported game does not run it; the flag is still set so agent machines stay quiet.

Runtime: `GorevYoneticisi` is a `Node` autoload. It does not read `Ses`, does not scan `data/diyalog/`, and does not construct a `Heybe`. Pools (`Available`, `Active`, `Completed`) are created in the manager `_init`, which is upstream behavior.

### Addon API this slice actually uses

From tag `2.0.1.4_4`:

- `Quest.id` is an **`int`**. English slugs live on our subclass. The int is only the addon key.
- `start_quest` / `update_quest` / `complete_quest`. Completion is refused while `objective_completed` is false (`require_objective_completed` stays true).
- `pool_state_as_dict()` → `{ "available": [int], "active": [int], "completed": [int] }`.
- `restore_pool_state_from_dict(dict, quests)` then `deserialize_quests(data)`. Upstream issue #31: JSON turns those ints into floats; their restore path assigns into `Array[int]`. Our round-trip test must go through `JSON.stringify` / `JSON.parse_string`, the same path as `GuvenliKayit`.
- `serialize()` on `Quest` stores script variables except `id`. Override it on `GorevKaydi` so only progress fields are stored (no leaked object refs).

## 2. Adapter

New type `GorevAdaptoru` (`RefCounted`, no autoload of its own). It is the only code that talks to both `Oturum` and `QuestSystem`.

`Oturum` unit tests construct a session with no scene tree. Every adapter call must no-op when the `QuestSystem` singleton is absent, and `kaydet()` must still round-trip. Missing singleton → `"gorev"` key omitted (or an empty dictionary). Never `null`.

### Two flag stores (do not merge them)

| Store | Shape | Who writes it | Trial use |
| --- | --- | --- | --- |
| `Oturum.bayraklar` | `Dictionary` of `StringName` → `true`, plus the counter `rusvet_sayisi` | Night-card effect `"bayrak"` (`dervis`, `baci_tezgah`, …) and a bribe in `karar_ver` | Read-only. Trial quests do not write here. |
| `Koylu.bayraklar` | `PackedStringArray` (`usta_ciftci`, `hirsiz`, `somurulmus`, …) | `KoyYonetimi.kabul()` copies `Gelen.acik_bayraklar` when the visitor stays | Quest 3 reads `Gelen.acik_bayraklar` at the question, and also `Koylu.bayrak_var` after admit. |
| `Gelen.acik_bayraklar` | Filled by `KapiEkrani` from `soru_bayraklari` | Question answered | Transient. Lost if the visitor is refused. Quest completion is stored in the quest pool, so a completed trial stays complete. |

`Flag_*` names in character drafts (`Flag_Yol_Sirri_Acik`, …) are the KVR-06 contract and are **not** the keys in `Oturum.bayraklar` today. The adapter matches the runtime strings (`usta_ciftci`, `dervis`), not the draft `Flag_*` spelling. SYS-18 (`baci_tezgah`, `dervis`, `miraen_sadik`, `turkmen_kin`, `thessra_kirgin`, `rusvet_sayisi` → night/diplomacy) keeps those keys. A quest must not set them. A later, separate hook may set an additive session flag `gorev_<slug>` when a quest completes, so an `OlayVerisi` condition can require it with the existing `kosullar.bayrak` list. That hook is out of this trial.

### Objective mapping

`GorevKaydi` extends `Quest` and adds:

| Field | Role |
| --- | --- |
| `slug` | English id (`quest_gate_admit_three`). Stable. Shown nowhere. |
| `baslik_anahtari` / `amac_anahtari` | `metinler.csv` keys. `quest_name` / `quest_objective` on the base resource hold the same keys, so the addon UI (if ever opened in the editor) does not embed Turkish prose. |
| `tur` | `kabul_sayisi` \| `gida_esik` \| `bayrak` |
| `hedef` | int threshold |
| `bayrak` | runtime flag string; empty unless `tur == bayrak` |
| `bayrak_yeri` | `gelen` \| `koylu` \| `oturum` |
| `ilerleme` | int progress, serialized |
| `objective_completed` | upstream bool; set by the adapter, never by the player |

English slug → addon int (fixed for saves):

| slug | `Quest.id` |
| --- | --- |
| `quest_gate_admit_three` | 1 |
| `quest_granary_food_36` | 2 |
| `quest_zeynep_usta_ciftci` | 3 |

Catalog path: `data/gorev/*.tres`, loaded by path from a const table in `gorev_adaptoru.gd`. Each start does `duplicate(true)` so the packed `.tres` is not mutated in the editor.

Evaluation, called from two hooks (not from `_process`):

1. After `Oturum.karar_ver()` returns — one call `GorevAdaptoru.bildir_karar(oturum, gelen, karar, ek)`.
   - `tur == kabul_sayisi`: `ilerleme = oturum.yonetim.kabul_sayisi`. `kabul()` increments that counter for `kabul`, `harc`, `rusvet`, and `kisla`. `ret` and `elkoy` do not.
   - `tur == bayrak` and `bayrak_yeri == gelen`: true when `bayrak` is in `gelen.acik_bayraklar`.
2. After `Oturum.gece_sonu()` returns — `GorevAdaptoru.bildir_gece(oturum)`.
   - `tur == gida_esik`: `ilerleme = oturum.yonetim.kaynaklar.miktar("gida")`.
   - `tur == bayrak` and `bayrak_yeri == koylu`: true when any `Koylu.bayrak_var(bayrak)`.

When `ilerleme >= hedef` (or the flag is present), set `objective_completed = true` and call `complete_quest`. Then `update_quest` so `serialize()` keeps `ilerleme`.

The village panel reads `get_active_quests()` / `get_completed_quests()` when it is shown. It does not poll.

### Save / load

`Oturum.KAYIT_SURUMU` stays **2**. `kayittan` already rejects any other `surum`. An extra key is ignored by today's loader, so old builds can still open a new file, and new builds can still open an old file.

```gdscript
# inside Oturum.kaydet(), one extra entry
"gorev": GorevAdaptoru.kaydet()
```

```gdscript
# GorevAdaptoru.kaydet()
{
  "pools": QuestSystem.pool_state_as_dict(),
  "quests": QuestSystem.serialize_quests()
}
```

Load, after `KoyYonetimi.kayittan` has restored villagers and `kabul_sayisi`:

1. Build the three duplicated resources from `res://data/gorev/`.
2. `restore_pool_state_from_dict(veri.pools, kaynaklar)`.
3. `deserialize_quests(veri.quests)`.
4. If `veri` is missing or empty (old save, or brand-new session before the first write): `mark_quest_as_available` + `start_quest` for ids 1–3.

`Ana.yeni_oyun()` already deletes the save and builds a fresh `Oturum`. No change in `ana.gd`: the first `kayit.yaz(oturum.kaydet())` happens at the end of the gate shift (`_koye_git`), which is the right moment for the first quest snapshot. `devam_et()` uses `kayittan`, which calls `GorevAdaptoru.yukle`.

`KayitDeposu` (`user://kayit.json`) is a separate, older writer. The live path is `GuvenliKayit` in `Ana`. The adapter does not add a second file. A split file would break the `.tmp` / `.bak` swap.

## 3. UI

Quests are an evening defter on the **village screen**, not a gate overlay.

The gate is the interrogation (`KapiEkrani`: portrait, heybe, question tree, decision). A quest tracker there covers the lines KAP-01 exists to show. Progress at the gate is stored immediately; the player reads it after `_koye_git`, which is the same moment the save is written. That matches the fiction: the guard writes the book when the shift ends.

### Where

`KoyEkrani._ready` already builds `Hud` at the top and the build/roster band at the bottom, with a 3D `SubViewport` between them. Add one new control, `src/arayuz/koy_hud/gorev_defteri.gd`, as a child of `KoyEkrani` (one `add_child` in the protected file). Anchor it to the upper left, **under** the HUD strip (`Hud` min height 108). Width cap 380 px. Show at most the three active lines plus a one-line “bitti” for a quest that completed today. No second `SubViewport`, no shader, no particle, no scrolling atlas.

`hud.gd` itself is not edited, so the resource strip (akçe, gıda, odun, …) stays as it is.

### Look (extend the theme we have)

`GorevDefteri` is a `PanelContainer`:

- Panel: `Tema.koy_paneli()` — fill `#201f1bed`, 1 px border `#64543a`, square corners, 12×6 content margin. Same wood/bronze card as `KaynakGostergesi` and `YapiKarti`.
- Optional back plate: a `CerceveKutu` (`mouse_filter = IGNORE`) using `MenuSatiri.ALTIN` (`#C9A46A`) double stroke and `MenuSusu.elmas` corners. That is the gate ledger frame. It is drawn by `_draw`, so it costs no texture.
- Title: `Tema.koy_baslik_fontu()` (`assets/font/Cinzel-wght.ttf`, SIL OFL), color `MenuSatiri.KREM` (`#EFE6D2`), size `Tema.KUCUK_PX`.
- Body: the theme’s Alegreya (`assets/font/Alegreya-wght.ttf`, SIL OFL), color `Renkler.KUL`.
- Marks: incomplete `Renkler.MESALE` (`#C4843A`, the existing warning color, not a new red). Complete `KaynakGostergesi.ARTIS` (`#b9cba0`).
- One icon at most, for the granary line: existing `assets/ui/koy/gida.svg` at 24 px, modulate `KaynakGostergesi.BRONZ` (`#c6a56b`). The other two lines are text only.

Player strings come from `tr()` and `data/metin/metinler.csv` (append rows; do not rewrite the file). Keys:

- `gorev.defter.baslik` → `Defter`
- `gorev.quest_gate_admit_three.baslik` / `.amac`
- `gorev.quest_granary_food_36.baslik` / `.amac`
- `gorev.quest_zeynep_usta_ciftci.baslik` / `.amac`

### Textures we will not import

- Kenney UI / RPG packs. They are flat or fantasy-chrome and fight the square ink panels, Cinzel titles, and gold ledger frame already on screen.
- QuestSystem’s `addons/quest_system/assets/quest_resource.svg`. Editor icon only.
- Any example-project quest log scene.

### If a paper fiber is requested later

Still one static `TextureRect`, tinted toward `Renkler.AHSAP` (`#3D2E24`), max 512×512, no animation. Preferred file: **Old Parchment Paper** by cron, CC0, <https://opengameart.org/content/old-parchment-paper> (`parchment_alpha.png` has a transparent edge). Downscale before commit. Skip the 11–17 MB sheets (Q_x “Sheet of old paper”, Luke.RUSTLT “large parchment texture”): they are the wrong size for a 380 px panel on a 4 GB RTX 3050 that is already drawing the Meshy village in a `SubViewport`.

The first implementation ships **without** that texture. `StyleBoxFlat` + `CerceveKutu` is the period look this UI already uses.

### GPU budget

Target is a laptop RTX 3050 4 GB. The defter is a `Control` overlay on the village screen. It adds no viewport, no light, no material, and no per-frame allocation beyond the existing HUD blink. Gate scene node count stays the same.

## 4. Three trial quests

All three start active on a new game and on an old save that has no `gorev` key. No purse reward. No new session flag.

### 1 — `quest_gate_admit_three` (id 1)

- Title: **Kapıyı tut**
- Objective: **Üç kişiyi içeri al.**
- `tur = kabul_sayisi`, `hedef = 3`.
- Completes when `KoyYonetimi.kabul_sayisi >= 3`.
- Why it is a safe first test: every kept visitor increments that counter (`kabul`, `harc`, `rusvet`, `kisla`). `gece_basina_gelen` defaults to 3, so one full shift can finish it. Refusals do not count.

### 2 — `quest_granary_food_36` (id 2)

- Title: **Ambar defteri**
- Objective: **Erzakı 36'ya çıkar.**
- `tur = gida_esik`, `hedef = 36`, read `kaynaklar.miktar("gida")` after `gece_sonu`.
- Why 36: `KoyAyarlari.baslangic_kaynak` is `gida: 30` and `data/ayarlar/koy.tres` does not override it. A new game is under the line, so the quest does not complete in `_ready`. Night consumption is `nufus * gida_kisi` (`gida_kisi` default 1), so the number can also fall. `hedef` stays an exported field so a tester can set 31 without a code change.
- Checked in the village phase, which is when the defter is visible.

### 3 — `quest_zeynep_usta_ciftci` (id 3)

- Title: **Zeynep'in eli**
- Objective: **Zeynep'e sor; usta çiftçi izini aç.**
- `tur = bayrak`, `bayrak = usta_ciftci`, `bayrak_yeri = gelen` (also satisfied if a villager already `bayrak_var("usta_ciftci")` after load).
- Known character: **CHR_012 Zeynep** (`karakter.chr_012.ad`). `data/sohbetler/chr_012.tres` has `soru_bayraklari[9] == "usta_ciftci"` and `soru_ust[9] == -1`, so that question is a root and can be picked inside her `azami_soru` of 6. `KapiEkrani` copies it onto `Gelen.acik_bayraklar` when the answer is heard. The same flag string exists on CHR_013 Osman Dayı, CHR_015 Emine Hatun, and CHR_018 Rahime; any of them completes the objective. The title names Zeynep because she is the earliest (`en_erken_gece = 3`, same as Emine; Osman and Rahime are 4).
- She is not guaranteed on a given night. Named visitors are drawn with `adli_olasiligi` 0.6 from `KarakterKadrosu.uygunlar`, and only once `gun >= en_erken_gece`. Nights 1–3 (gun 0–2) cannot spawn her. Quests 1 and 2 are the day-one smoke test. Quest 3 is the flag wiring test.
- JSON queue figures from `diyalog_01_20.json` never set `soru_bayraklari`. This quest ignores them.

## 5. Risks and rollback

| Risk | What we do |
| --- | --- |
| Plugin `ProjectSettings.save()` rewrites `project.godot` and drops `Ses` or the main scene | Diff the whole file. `Ses` stays the first autoload. Revert the file if the rewrite is noisy. |
| Global class `Quest` clashes with a future script | Game code uses `GorevKaydi`. Do not add a second `class_name Quest`. |
| `Quest.id` is an int, so a slug rename orphans saves | Slug and int are a frozen table. New trials append ids 4+. Never reuse 1–3. |
| JSON float ids fail to restore (upstream #31) | Unit test round-trips through `JSON.stringify`. If assign-to-`Array[int]` fails on 4.7, coerce with `int()` in the adapter before calling restore. |
| Shared `.tres` progress leaks across plays | `duplicate(true)` before `start_quest`. |
| Quest writes `dervis` / `baci_tezgah` / `rusvet_sayisi` and fires or blocks a night card (SYS-18) | Trial resources have no `bayrak_yaz`. Adapter refuses to set session flags in this slice. |
| Completing “erzak 36” is hard if the first nights consume the 30 start | `hedef` is data. Smoke test may set 31. The shipped trial stays 36 so a fresh game is not already done. |
| Zeynep is absent for three nights | Expected. Documented on the objective line. Quests 1–2 still prove the pipeline. |
| Hook in `oturum.gd` races another festive branch | Fetch festive, touch only the `kaydet` entry, the `kayittan` call, and the two `bildir_*` calls. Separate commit from the vendored addon. |
| Headless tests have no autoload | Adapter no-ops. Existing `kapi_kararlari` save round-trip must stay green. |
| Extra `SubViewport` or parchment shader on the 3050 | Forbidden in this slice. Control draw only. |
| Update checker or example UI pulled in by mistake | Vendor the tag directory only. `check_for_updates_on_startup=false`. |

### Rollback

1. Remove the `QuestSystem` autoload line and the `editor_plugins` / `[quest_system]` block from `project.godot`. Leave `Ses` as it was.
2. Delete `addons/quest_system/`.
3. Delete `src/sistemler/gorev_*.gd`, `src/veri/gorev_kaydi.gd`, `src/arayuz/koy_hud/gorev_defteri.gd`, `data/gorev/`.
4. Revert the hook lines in `oturum.gd` and the one `add_child` in `koy_ekrani.gd`.
5. Remove the `gorev.*` rows from `metinler.csv`.
6. Saves: a file that still contains `"gorev"` loads on the rolled-back game, because `kayittan` ignores unknown keys and `surum` is still 2. No migration script. Players do not lose the village.

After rollback, re-run the `koy_yonetimi` and `kapi_kararlari` unit scripts and a short headless import. Gate dialogue JSON checksum should be identical to festive.

## 6. File touch list

### This phase (now)

| Path | Action |
| --- | --- |
| `docs/QUEST_SYSTEM_PLAN.md` | **New.** This file. |

No other file changes in phase 1. ROADMAP rows (SYS-18, EKO-01, KAP-01) stay as they are.

### Later implementation (not in this commit)

**New**

| Path | Role |
| --- | --- |
| `addons/quest_system/**` | Vendored 2.0.1, MIT `LICENSE` kept |
| `src/sistemler/gorev_yoneticisi.gd` | Autoload script, extends `QuestSystemManagerAPI` |
| `src/sistemler/gorev_adaptoru.gd` | Flag / karar / gıda ↔ pools, save dict |
| `src/veri/gorev_kaydi.gd` | `extends Quest`, slug + objective fields |
| `src/arayuz/koy_hud/gorev_defteri.gd` | Village defter |
| `data/gorev/quest_gate_admit_three.tres` | Trial 1 |
| `data/gorev/quest_granary_food_36.tres` | Trial 2 |
| `data/gorev/quest_zeynep_usta_ciftci.tres` | Trial 3 |
| `tests/unit/gorev/gorev_adaptoru_test.gd` | JSON round-trip, admit count, flag, food threshold, missing singleton |

**Modified, thin**

| Path | Change |
| --- | --- |
| `project.godot` | `QuestSystem` autoload after `Ses`, plugin enable, `quest_system` config |
| `src/sistemler/oturum.gd` | `"gorev"` in `kaydet`; `yukle` in `kayittan`; `bildir_karar` / `bildir_gece` |
| `src/arayuz/koy_ekrani.gd` | one `add_child(GorevDefteri)` under the HUD |
| `data/metin/metinler.csv` | seven new keys, row append only |

**Not modified**

`src/arayuz/tema.gd`, `renkler.gd`, `cerceve_kutu.gd`, `hud.gd`, `kapi_ekrani.gd`, `ana.gd`, `src/sistemler/heybe.gd`, `src/sistemler/ses.gd`, `src/veri/olay_verisi.gd`, `src/koy/guvenli_kayit.gd`, `data/diyalog/diyalog_01_20.json`, building catalog, character `.tres` files.

### Suggested commit split when implementation is allowed

1. Vendor addon + `project.godot` + empty `GorevYoneticisi` that only calls `super`. Headless import.
2. `GorevKaydi`, adapter, three `.tres`, unit test. No scene hook. Protected `oturum.gd` diff is this commit and nothing else.
3. `GorevDefteri` + csv rows + the `koy_ekrani.gd` one-liner.

## Acceptance for the implementation slice

- Headless load reports no script error.
- Existing save round-trip test still passes with and without a `gorev` key.
- New test: three admits → quest 1 completed; `gida` 36 after a fake night → quest 2 completed; `acik_bayraklar` contains `usta_ciftci` → quest 3 completed; refusing Zeynep does not clear the completed pool.
- `diyalog_01_20.json` byte-identical.
- `Ses` still the first autoload.
- Village defter uses `Tema.koy_paneli` and Cinzel/Alegreya; gate scene has no new control.
- No `muhafiz_akce` field added.
