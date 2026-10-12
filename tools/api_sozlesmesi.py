"""Audit protected GDScript API declarations against a Git baseline."""
import argparse
import json
from pathlib import Path
import re
import subprocess

ROOT = Path(__file__).resolve().parents[1]
CONTRACTS = {
    "src/dunya/karakter_model.gd": [("func", "kur"), ("func", "yuru"), ("var", "_klip_onbellek")],
    # HAN-51/OMR-52: genel imzalar değişmez; değişirse taban aynı commit'te güncellenir.
    "src/arayuz/koy_ekrani.gd": [("func", "ortam_baslat"), ("signal", "devam_istendi"), ("signal", "oturum_bitti")],
    # HAN-51/HFZ-31: genel imzalar değişmez; değişirse taban aynı commit'te güncellenir.
    "src/sistemler/oturum.gd": [("const", "KAYIT_SURUMU"), ("func", "gece_kuyrugu"), ("func", "gece_sonu"), ("func", "gosterge"), ("func", "gosterilen_gece"), ("func", "heybe_uret"), ("func", "karar_ver"), ("func", "kaydet"), ("func", "kayittan"), ("func", "olay_sec"), ("func", "olay_uygula"), ("func", "secenek_olur"), ("func", "sira_olayi_sec"), ("func", "tr_ad"), ("func", "tr_gelen"), ("func", "ziyaret_basladi"), ("var", "akce")],
    "src/koy/guvenli_kayit.gd": [("func", "yaz"), ("func", "oku"), ("func", "sil")],
    # OMR-52: genel imzalar değişmez; değişirse taban aynı commit'te güncellenir.
    "src/koy/perde_gecisi.gd": [("func", "baslangic"), ("func", "denetle"), ("func", "gece"), ("func", "isaretle"), ("func", "olay_metin"), ("func", "yukle")],
    # OMR-52: genel imzalar değişmez; değişirse taban aynı commit'te güncellenir.
    "src/sistemler/nihai_son.gd": [("func", "epilog"), ("func", "gostergeler"), ("func", "son"), ("func", "son_metni")],
    # HAN-51: genel imzalar değişmez; değişirse taban aynı commit'te güncellenir.
    "src/sistemler/koy_nufusu.gd": [("func", "cikar"), ("func", "cikar_rastgele"), ("func", "ekle"), ("func", "sayi"), ("func", "toplam"), ("signal", "degisti")],
    # SOY-47: genel imzalar değişmez; değişirse taban aynı commit'te güncellenir.
    "src/kapi/fisilti_gazetesi.gd": [("func", "durum"), ("func", "gece"), ("func", "oku"), ("func", "olay"), ("func", "tanimli"), ("func", "uygula"), ("func", "uygun")],
    # SOY-47: genel imzalar değişmez; değişirse taban aynı commit'te güncellenir.
    "src/koy/batil_inanc_histerisi.gd": [("func", "bekliyor"), ("func", "durum"), ("func", "gece"), ("func", "gercek_gosterilebilir"), ("func", "kaldir"), ("func", "kriz"), ("func", "metin"), ("func", "oku"), ("func", "olay"), ("func", "onyargi"), ("func", "oy_cezasi"), ("func", "tanimli"), ("func", "uygula"), ("func", "uygun"), ("func", "yerel"), ("func", "yukle")],
    # OZL-30: genel imzalar değişmez; değişirse taban aynı commit'te güncellenir.
    "src/veri/olay_verisi.gd": [("var", "agirlik"), ("var", "baslik_anahtari"), ("var", "id"), ("var", "kosullar"), ("var", "metin_anahtari"), ("var", "muzik"), ("var", "secenek_anahtarlari"), ("var", "secenek_etkileri"), ("var", "ses"), ("var", "tek_sefer")],
    # HFZ-31: genel imzalar değişmez; değişirse taban aynı commit'te güncellenir.
    "src/sistemler/karakter_kadrosu.gd": [("func", "figur_ornegi"), ("func", "gece_bitti"), ("func", "iste"), ("func", "kaydet"), ("func", "sonuc"), ("func", "uygunlar"), ("func", "yukle"), ("func", "ziyaret_basladi")],
    # HFZ-31: genel imzalar değişmez; değişirse taban aynı commit'te güncellenir.
    "src/arayuz/kapi_ekrani.gd": [("func", "gece_baslat"), ("signal", "_sira_secildi"), ("signal", "duraklat_istendi"), ("signal", "gece_bitti"), ("signal", "oturum_bitti")],
}


def normalize(text):
    # Whitespace outside literals is irrelevant; whitespace inside is API data.
    result, quote, escaped, comment = [], None, False, False
    for char in text:
        if comment:
            comment = char != "\n"
            continue
        if quote:
            result.append(char)
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == quote:
                quote = None
        elif char in ('"', "'"):
            quote = char
            result.append(char)
        elif char == "#":
            comment = True
        elif not char.isspace():
            result.append(char)
    return "".join(result)


def declaration(source, kind, name):
    start = re.search(r"^[ \t]*(?:@\w+(?:\([^)\n]*\))?[ \t]+)*(?:static[ \t]+)?" + kind + r"[ \t]+" + re.escape(name) + r"\b", source, re.M)
    if not start:
        return None
    if kind in ("var", "const"):
        line = source[start.start():].splitlines()[0].strip()
        # Values may legitimately change (save version); declaration/type stays.
        return normalize(line.split("=", 1)[0].rstrip(": "))
    opening = source.find("(", start.end())
    if opening < 0:
        return None
    depth, quote, escaped, closing, comment = 0, None, False, None, False
    for index in range(opening, len(source)):
        char = source[index]
        if comment:
            comment = char != "\n"
            continue
        if quote:
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == quote:
                quote = None
            continue
        if char in ('"', "'"):
            quote = char
        elif char == "#":
            comment = True
        elif char == "(":
            depth += 1
        elif char == ")":
            depth -= 1
            if depth == 0:
                closing = index
                break
    if closing is None:
        return None
    header = source[start.start():closing + 1]
    if kind == "func":
        tail = source[closing + 1:].splitlines()[0]
        ending = re.match(r"\s*(?:->\s*([^:]+))?\s*:", tail)
        if not ending:
            return None
        if ending[1]:
            header += "->" + ending[1]
    return normalize(header)


def differences(old, new, kind, name):
    before, after = declaration(old, kind, name), declaration(new, kind, name)
    if before is None:
        return f"Baseline contract missing: {kind} {name}"
    if after is None:
        return f"Deleted/malformed contract: {kind} {name}"
    if before != after:
        return f"Changed contract {kind} {name}: {before} -> {after}"
    return None


def main():
    cli = argparse.ArgumentParser(description=__doc__)
    cli.add_argument("--base", default="HEAD")
    cli.add_argument("--manifest", type=Path, help="Git çalıştırmadan sabit API imza manifestine karşı denetler")
    args = cli.parse_args()
    manifest = json.loads(args.manifest.read_text(encoding="utf-8")) if args.manifest else None
    errors = []
    for relative, contracts in CONTRACTS.items():
        try:
            old = None if manifest is not None else subprocess.check_output(["git", "show", f"{args.base}:{relative}"], cwd=ROOT, stderr=subprocess.PIPE).decode("utf-8")
            new = (ROOT / relative).read_text(encoding="utf-8-sig")
        except (subprocess.CalledProcessError, OSError) as error:
            errors.append(f"{relative}: {error}")
            continue
        for kind, name in contracts:
            if manifest is not None:
                expected = manifest.get(relative, {}).get(f"{kind}:{name}")
                problem = None if expected is not None and declaration(new, kind, name) == expected else f"Missing/changed manifest contract: {kind} {name}"
            else:
                problem = differences(old, new, kind, name)
            if problem:
                errors.append(f"{relative}: {problem}")
    for error in errors:
        print(error)
    print("API contract: " + ("FAIL" if errors else "PASS"))
    return 1 if errors else 0


if __name__ == "__main__":
    raise SystemExit(main())
