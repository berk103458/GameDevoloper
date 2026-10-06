"""CHR markdown -> typed Godot resources; never rewrites legacy data or CSV.

Usage: python tools/chr_parser.py [--check] [--source karakterler]
Output: data/chr_runtime/CHR_XXX.tres. All pages validate before any write.
Source spelling/IDs are preserved. Stats alone use the roadmap's ASCII keys.
Debuff durations are distinct from delayed start offsets. Follow-up IDs which
have no source page remain external references, reported as warnings.
"""
from __future__ import annotations
import argparse
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
STATS = {"Refah": "Refah", "Erzak": "Erzak", "Güvenlik": "Guvenlik", "Moral": "Moral", "Sağlık": "Saglik"}
FLAGS = ["Flag_Yol_Sirri_Acik", "Flag_Kimlik_Cozuldu", "Flag_Sir_Tamamen_Cozuldu", "Flag_Kilitlendi"]
CLASS = {"Asker": "asker", "Esnaf": "esnaf", "Çiftçi": "ciftci"}
DECISIONS = {"Kabul and secret solved": ("kabul", True), "Kabul and secret hidden": ("kabul", False), "Zorunlu ret": ("zorunlu_ret", None), "Gönüllü ret": ("gonullu_ret", None), "Rüşvet": ("rusvet", None), "Kışla": ("kisla", None)}


class SourceError(ValueError):
    pass


def field(text: str, name: str) -> str:
    match = re.search(r"^\s*-\s*\[" + re.escape(name) + r"\]:\s*(.+)$", text, re.M)
    if not match and name == "SFX":
        match = re.search(r"^\s*-\s*SFX:\s*(.+)$", text, re.M)
    if not match:
        raise SourceError(f"missing field [{name}]")
    return match[1].strip()


def effects(text: str) -> dict:
    return {STATS[name]: int(value) for name, value in re.findall(r"(Refah|Erzak|Güvenlik|Moral|Sağlık)\s*([+-]\d+)", text)}


def node_id(text: str) -> str:
    return re.sub(r"^Düğüm[ _]*", "", text.strip())


def key_node(text: str) -> str:
    return re.sub(r"[^A-Za-z0-9_]+", "_", text).upper()


def parse(path: Path) -> dict:
    text = path.read_text(encoding="utf-8-sig").replace("\\>", ">").replace("\\<", "<")
    entity = field(text, "Entity_ID")
    if entity != path.stem or not re.fullmatch(r"CHR_\d{3}", entity):
        raise SourceError("Entity_ID must equal source filename CHR_XXX")
    tags = field(text, "Tag_Array").split(",")
    classes = [CLASS[t.strip()] for t in tags if t.strip() in CLASS]
    if len(classes) != 1:
        raise SourceError("Tag_Array must identify exactly one supported class")
    spawn = field(text, "Spawn_Koşulu")
    first = re.search(r"Tur\s*>\s*(\d+)", spawn)
    if not first:
        raise SourceError("Spawn_Koşulu missing Tur > N")
    def parts(name, keys):
        value = field(text, name)
        result = {}
        for key in keys:
            found = re.search(re.escape(key) + r":\s*([^;]+)", value)
            if not found:
                raise SourceError(f"{name} missing {key}")
            result[key] = found[1].strip()
        return result
    data = dict(entity_id=entity, ad=field(text, "Gerçek_Kimlik").split(";")[0], sinif=classes[0], fraksiyon=field(text, "Sadakat_Fraksiyonu"), en_erken_tur=int(first[1]) + 1, spawn_kosulu=spawn,
                secere_matrisi=parts("Secere_Matrisi", ["Doğum_Yeri", "Aile_Bağı", "Kırılma_Olayı"]),
                koy_ici_davranis=parts("Köy_içi_Davranış", ["Gündüz_Döngüsü", "Gece_Döngüsü"]),
                persona_maskesi=field(text, "Persona_Maskesi"), gizlenen_gercek=field(text, "Gizlenen_Gerçek"),
                gorsel_hata=field(text, "Görsel_Hata"), sir_baglantisi=field(text, "Sır_Bağlantısı"), sfx=field(text, "SFX"),
                baslangic_tansiyonu=int(field(text, "Başlangıç_Tansiyonu")))
    if data["baslangic_tansiyonu"] not in (1, 2, 3):
        raise SourceError("Başlangıç_Tansiyonu must be 1–3")
    for i, name in [(1, "Obje_1_Nişan"), (2, "Obje_2_Yük")]:
        value = field(text, name)
        clue = re.search(r"Generate\s*\[(Clue_[^\]]+)\]", value)
        if not clue:
            raise SourceError(f"{name} missing Generate Clue")
        data[f"obje_{i}"] = {"aciklama": value[:clue.start()].strip(), "uretilen_ipucu": clue[1]}
    visual = re.search(r"Generate\s*\[(Clue_Görsel_[^\]]+)\]", text)
    if not visual:
        raise SourceError("missing visual clue")
    data["gorsel_hata_ipucu"] = visual[1]
    data["poz_aciklamalari"] = {state: field(text, f"State_{i} {state}") for i, state in enumerate(["Idle", "Stressed", "Panic"])}
    data["animasyon_anahtarlari"] = {s: s for s in data["poz_aciklamalari"]}
    data["sorgu_bayraklari"] = dict.fromkeys(FLAGS, False)
    data["metinler"] = {}
    for i in (1, 2):
        clue = data[f"obje_{i}"]["uretilen_ipucu"]
        prefix = "CLUE_" + clue.removeprefix("Clue_").upper()
        data["metinler"][prefix + "_BASLIK"] = field(text, f"Obje_{i}_" + ("Nişan" if i == 1 else "Yük")).split(".")[0]
        data["metinler"][prefix + "_TANIM"] = data[f"obje_{i}"]["aciklama"]
    section = text.split("#### BÖLÜM 4", 1)[1].split("#### BÖLÜM 5", 1)[0]
    nodes = {}
    current = None
    for line in section.splitlines():
        value = line.strip().removeprefix("- ")
        heading = re.fullmatch(r"(Düğüm(?:[ _].+)):\s*", value)
        if heading:
            current = node_id(heading[1])
            if current in nodes:
                raise SourceError(f"duplicate node {current}")
            key = f"{entity}_DUGUM_{key_node(current)}_REPLIK"
            nodes[current] = dict(replik_anahtari=key, secenekler=[], gecisler=[], bayraklar=[], kaynak=[])
            data["metinler"][key] = ""
            continue
        if current is None:
            continue
        node = nodes[current]
        node["kaynak"].append(value)
        if value.startswith("NPC Replik:") or value.startswith("Son söz:"):
            data["metinler"][node["replik_anahtari"]] = value.split(":", 1)[1].strip().strip('"')
        if value.startswith("Generate [Flag_"):
            flag = re.search(r"\[(Flag_[^\]]+)\]", value)[1]
            if flag not in FLAGS:
                raise SourceError(f"unknown flag {flag}")
            node["bayraklar"].append(flag)
        target = re.search(r"\[Hedef:\s*([^\]]+)\]", value)
        if not target:
            continue
        delta = re.search(r"Tansiyon\s*([+-]\d+)", value)
        option = dict(hedef=node_id(target[1]), tansiyon_delta=int(delta[1]) if delta else 0, kaynak=value)
        if value.startswith("Seçenek yalanı çürüt"):
            option["beceri"] = "blof"
        elif value.startswith("Seçenek empati") or value.startswith("Seçenek ikna"):
            option["beceri"] = "ikna"
        option["gerekli_ipuclari"] = re.findall(r"\[(Clue_[^\]]+)\]", value)
        option["gerekli_bayraklar"] = re.findall(r"\[(Flag_[^\]]+)\]", value)
        if value.startswith("(Eğer Tansiyon"):
            bound = re.search(r"Tansiyon\s*(>=|<)\s*(\d+)", value)
            verbal = re.search(r"Tansiyon (\d+) veya üzerinde", value)
            if not bound and verbal:
                bound_values = (">=", int(verbal[1]))
            elif bound:
                bound_values = (bound[1], int(bound[2]))
            else:
                raise SourceError(f"unrecognized tension condition {value}")
            option["tansiyon_kosulu"] = {"operator": bound_values[0], "deger": bound_values[1]}
            node["gecisler"].append(option)
        else:
            key = f"{entity}_DUGUM_{key_node(current)}_SEC_{len(node['secenekler'])+1}_METIN"
            option["metin_anahtari"] = key
            quoted = re.search(r'"(.*)"', value)
            display = quoted[1] if quoted else value.split("->")[0].strip()
            # Author-facing condition/clue IDs stay in schema, not player text.
            if display.startswith("[Clue_") and ":" in display:
                display = display.split(":", 1)[1].strip()
            display = re.sub(r"\([^)]*(?:Flag_|Tansiyon)[^)]*\)", "", display)
            display = re.sub(r"\[(?:Clue_|Flag_)[^\]]+\]", "", display)
            data["metinler"][key] = re.sub(r"\s{2,}", " ", display).strip()
            node["secenekler"].append(option)
    if "00" not in nodes:
        raise SourceError("missing Düğüm 00")
    for node in nodes.values():
        for option in node["secenekler"] + node["gecisler"]:
            if option["hedef"] not in nodes:
                raise SourceError(f"broken node target {option['hedef']}")
    data["diyalog_dugumleri"] = nodes
    section5 = text.split("#### BÖLÜM 5", 1)[1]
    data["karar_matrisi"] = {}
    data["gecikmeli_etkiler"] = []
    data["kosullu_etkiler"] = []
    data["sonraki_spawns"] = {}
    for line in section5.splitlines():
        line = line.strip().removeprefix("- ")
        spawn_match = re.match(r"on (accept|reject|bribe|jail): \[(CHR_\d{3})\].*?\+(\d+) tur", line)
        if spawn_match:
            kind, identity, offset = spawn_match.groups()
            data["sonraki_spawns"]["on_" + kind] = dict(entity_id=identity, offset=int(offset), kaynak=line)
            continue
        if ":" not in line:
            continue
        label, description = line.split(":", 1)
        if label not in DECISIONS and not label.startswith("If [Flag_"):
            continue
        condition = {}
        decision = ""
        if label in DECISIONS:
            decision, solved = DECISIONS[label]
            if solved is not None:
                condition["Flag_Sir_Tamamen_Cozuldu"] = solved
        else:
            flag = re.fullmatch(r"If \[(Flag_[^\]]+)\] is (false|true)", label)
            if not flag or flag[1] not in FLAGS:
                raise SourceError(f"unknown condition {label}")
            condition[flag[1]] = flag[2] == "true"
        result = dict(stat_etkisi=effects(description), kosullar=condition, kaynak=description.strip(), muhafiz_akce=0, esyalar=[])
        gain = re.search(r"Kişisel Kazanç:\s*([^\)]+)", description)
        if gain:
            for item in gain[1].split(","):
                coin = re.fullmatch(r"\s*(\d+)\s+(?:gümüş sikke|gümüş dirhem|altın sikke|bakır akçe)\s*", item)
                if coin:
                    result["muhafiz_akce"] += int(coin[1])
                else:
                    result["esyalar"].append(item.strip())
        delay = re.search(r"Tur\s+(\d+)", description)
        duration = re.search(r"Debuff:\s*(\d+) tur boyunca", description)
        if delay or duration:
            # Duration starts next turn; it is NOT a start delay of N turns.
            building = re.search(r"(?:Tur\s+\d+'[a-z]+|Debuff:\s*\d+ tur boyunca)\s+(.+?)(?: binasında| başında| muhafızları| nöbetçileri|'[a-z]+| toplanma)", description)
            if not building:
                # Search only explicit source locations; no invented default.
                locations = ["Muhafız Kışlası", "Erzak Ambarı", "Köy Meydanı", "Su Kuyusu", "Su Arkı", "Bağ Evi", "Tarla Damı", "Harman Yeri", "Tamir Sundurması", "Ortak Sofra", "Köy Çeşmesi", "Değirmen", "Odunluk", "Şifahane", "Demirhane", "Ahır", "Ağıl", "Bostan", "Hendek", "dere", "batı kapısı", "Han", "nöbetçi kulesi", "ambar", "Kuyu", "Sur", "köy", "zindan", "tarla"]
                # Python/Godot don't apply Turkish dotted-I case folding;
                # source comparison accounts for it without changing text.
                folded = description.replace("I", "ı").replace("İ", "i").lower()
                building_name = next((name for name in locations if re.search(r"\b" + re.escape(name.replace("I", "ı").replace("İ", "i").lower()), folded)), None)
                if building_name is None:
                    raise SourceError(f"cannot identify delayed target: {description}")
            else:
                building_name = building[1].strip()
            event_name = re.search(r"'([^']+)' (?:olayı|çıkar)", description)
            event = dict(tur_offset=int(delay[1]) if delay else 1, hedef_bina=building_name,
                         olay_id=event_name[1] if event_name else f"{entity}_{label}", stat_etkisi=result["stat_etkisi"],
                         karar=decision, kosullar=condition, sure=int(duration[1]) if duration else 1, kaynak=description.strip())
            data["gecikmeli_etkiler"].append(event)
            result["stat_etkisi"] = {}
        if decision:
            entry = data["karar_matrisi"].setdefault(decision, dict(stat_etkisi={}, muhafiz_akce=0, esyalar=[], varyantlar=[]))
            if condition:
                entry["varyantlar"].append(result)
            else:
                entry.update(result)
        else:
            data["kosullu_etkiler"].append(result)
    if set(data["karar_matrisi"]) != {v[0] for v in DECISIONS.values()}:
        raise SourceError("missing decision matrix row")
    if len(data["sonraki_spawns"]) != 4:
        raise SourceError("missing follow-up spawn")
    return data


def godot(value):
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, dict):
        names = {"uretilen_ipucu", "replik_anahtari", "metin_anahtari", "entity_id"}
        return "{" + ", ".join(godot(k) + ": " + ("&" if k in names and isinstance(v, str) else "") + godot(v) for k, v in value.items()) + "}"
    if isinstance(value, list):
        return "[" + ", ".join(map(godot, value)) + "]"
    return json.dumps(value, ensure_ascii=False)


def resource(data):
    header = '[gd_resource type="Resource" script_class="KarakterVerisi" load_steps=2 format=3]\n\n[ext_resource type="Script" path="res://src/veri/karakter_verisi.gd" id="1"]\n\n[resource]\nscript = ExtResource("1")\n'
    lines = []
    for key, value in data.items():
        encoded = godot(value)
        if key in ("entity_id", "sinif", "fraksiyon", "gorsel_hata_ipucu"):
            encoded = "&" + encoded
        if key in ("gecikmeli_etkiler", "kosullu_etkiler"):
            encoded = "Array[Dictionary](" + encoded + ")"
        lines.append(key + " = " + encoded)
    return header + "\n".join(lines) + "\n"


def main():
    cli = argparse.ArgumentParser(description=__doc__)
    cli.add_argument("--source", type=Path, default=ROOT / "karakterler")
    cli.add_argument("--output", type=Path, default=ROOT / "data/chr_runtime")
    cli.add_argument("--check", action="store_true")
    args = cli.parse_args()
    paths = sorted(args.source.glob("CHR_*.md"))
    if not paths:
        cli.error("no CHR source pages found")
    parsed, errors = [], []
    for path in paths:
        try:
            parsed.append(parse(path))
        except (SourceError, ValueError, IndexError) as error:
            errors.append(f"{path.name}: {error}")
    if errors:
        print("\n".join(errors))
        return 1
    known = {d["entity_id"] for d in parsed}
    external = {v["entity_id"] for d in parsed for v in d["sonraki_spawns"].values()} - known
    print(f"Validated {len(parsed)} pages; {len(external)} external follow-up IDs (no source page yet).")
    if not args.check:
        args.output.mkdir(parents=True, exist_ok=True)
        for data in parsed:
            (args.output / (data["entity_id"] + ".tres")).write_text(resource(data), encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
