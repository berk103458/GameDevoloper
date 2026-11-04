"""KAY-31: söz verisinin tek doğrulayıcısı. Kayıt uyumu bu araca eklenir; ikinci betik yoktur.

Metin yazmaz. Eksik anahtar, yasak kelime ve kota yüklemeyi durdurmaz.
"""
from __future__ import annotations

import argparse
import json
import re
import sys
import time
from pathlib import Path

from soz_kadro_denetimi import denetle as kadro_denetle

ROOT = Path(__file__).resolve().parents[1]
KIMLIK = re.compile(r'(?:entity_id|id)\s*=\s*&"([^"]+)"')
HEDEF = re.compile(r'"hedef"\s*:\s*"([^"]*)"')
GOC_DURDURMAZ = {"eksik_anahtar", "yasak_kelime", "kota", "sahte_kimlik", "kopuk_dugum"}


def katalog_kimlikleri(root: Path = ROOT) -> set[str]:
    kimlikler: set[str] = set()
    for klasor in (root / "data/chr_runtime", root / "data/karakterler"):
        if not klasor.is_dir():
            continue
        for dosya in klasor.glob("*.tres"):
            metin = dosya.read_text(encoding="utf-8", errors="replace")
            kimlikler.update(KIMLIK.findall(metin))
    return kimlikler


def _blok(metin: str, imza: str) -> str:
    bas = metin.find(imza)
    if bas < 0:
        return ""
    sol = metin.find("{", bas)
    if sol < 0:
        return ""
    derinlik = 0
    metin_ici = False
    kacis = False
    for i in range(sol, len(metin)):
        ch = metin[i]
        if metin_ici:
            if kacis:
                kacis = False
            elif ch == "\\":
                kacis = True
            elif ch == '"':
                metin_ici = False
            continue
        if ch == '"':
            metin_ici = True
        elif ch == "{":
            derinlik += 1
        elif ch == "}":
            derinlik -= 1
            if derinlik == 0:
                return metin[sol:i + 1]
    return ""


def _dugum_kimlikleri(blok: str) -> set[str]:
    kimlikler: set[str] = set()
    derinlik = 0
    metin_ici = False
    kacis = False
    i = 0
    while i < len(blok):
        ch = blok[i]
        if metin_ici:
            if kacis:
                kacis = False
            elif ch == "\\":
                kacis = True
            elif ch == '"':
                metin_ici = False
            i += 1
            continue
        if ch == '"':
            son = blok.find('"', i + 1)
            if son < 0:
                break
            if derinlik == 1 and son + 1 < len(blok) and blok[son + 1:son + 4].lstrip().startswith(":"):
                kimlikler.add(blok[i + 1:son])
            i = son + 1
            continue
        if ch == "{":
            derinlik += 1
        elif ch == "}":
            derinlik -= 1
        i += 1
    return kimlikler


def sema_hatalari(metin: str, ad: str) -> list[dict]:
    if metin.lstrip().startswith("{"):
        try:
            veri = json.loads(metin)
        except json.JSONDecodeError as exc:
            return [{"tur": "kopuk_dugum", "dosya": ad, "mesaj": "sema json bozuk: %s" % exc}]
        dugumler = veri.get("dugumler", {})
        if not isinstance(dugumler, dict):
            return [{"tur": "kopuk_dugum", "dosya": ad, "mesaj": "dugumler sozluk degil"}]
        return _hedef_hatalari(ad, set(dugumler), _json_hedefler(dugumler))
    blok = _blok(metin, "diyalog_dugumleri")
    if not blok:
        return []
    return _hedef_hatalari(ad, _dugum_kimlikleri(blok), HEDEF.findall(blok))


def _json_hedefler(dugumler: dict) -> list[str]:
    hedefler: list[str] = []

    def yuru(dugum) -> None:
        if isinstance(dugum, dict):
            if "hedef" in dugum:
                hedefler.append(str(dugum.get("hedef", "")))
            for deger in dugum.values():
                yuru(deger)
        elif isinstance(dugum, list):
            for deger in dugum:
                yuru(deger)

    for dugum in dugumler.values():
        yuru(dugum)
    return hedefler


def _hedef_hatalari(ad: str, dugumler: set[str], hedefler: list[str]) -> list[dict]:
    hatalar = []
    for hedef in hedefler:
        if hedef and hedef not in dugumler:
            hatalar.append({"tur": "kopuk_dugum", "dosya": ad, "mesaj": "kopuk dugum: %s" % hedef})
    return hatalar


def kayit_hatalari(kayit: dict, katalog: set[str], anahtarlar: set[str] | None = None, yasaklar: list[str] | None = None) -> list[dict]:
    hatalar: list[dict] = []
    for kimlik in _kayit_kimlikleri(kayit):
        if kimlik not in katalog:
            hatalar.append({"tur": "sahte_kimlik", "mesaj": "katalogda yok: %s" % kimlik})
    if anahtarlar is not None:
        for anahtar in _metin_anahtarlari(kayit):
            if anahtar not in anahtarlar:
                hatalar.append({"tur": "eksik_anahtar", "mesaj": "eksik metin anahtari: %s" % anahtar})
    for kelime in yasaklar or []:
        if kelime and _metinde_var(kayit, kelime):
            hatalar.append({"tur": "yasak_kelime", "mesaj": "yasak kelime: %s" % kelime})
    soz = kayit.get("soz", {})
    if isinstance(soz, dict):
        cekirdek = soz.get("cekirdekler", [])
        if isinstance(cekirdek, list):
            for uyari in kadro_denetle([str(x) for x in cekirdek]):
                hatalar.append(uyari)
    return hatalar


def goc_durur(hatalar: list[dict]) -> bool:
    return any(h.get("tur") not in GOC_DURDURMAZ for h in hatalar)


def _kayit_kimlikleri(kayit: dict) -> list[str]:
    kimlikler: list[str] = []
    kadro = kayit.get("kadro", {})
    if isinstance(kadro, dict):
        kimlikler.extend(str(k) for k in kadro.keys())
    soz = kayit.get("soz", {})
    if isinstance(soz, dict):
        for satir in soz.get("hafiza", []) or []:
            if isinstance(satir, dict) and str(satir.get("id", "")).strip():
                kimlikler.append(str(satir["id"]).strip())
    return kimlikler


def _metin_anahtarlari(kayit: dict) -> list[str]:
    soz = kayit.get("soz", {})
    anahtarlar: list[str] = []
    if not isinstance(soz, dict):
        return anahtarlar
    for satir in soz.get("satirlar", []) or []:
        if isinstance(satir, str) and satir.strip():
            anahtarlar.append(satir.strip())
        elif isinstance(satir, dict) and str(satir.get("anahtar", "")).strip():
            anahtarlar.append(str(satir["anahtar"]).strip())
    return anahtarlar


def _metinde_var(deger, kelime: str) -> bool:
    if isinstance(deger, str):
        return kelime.casefold() in deger.casefold()
    if isinstance(deger, dict):
        return any(_metinde_var(v, kelime) for v in deger.values())
    if isinstance(deger, list):
        return any(_metinde_var(v, kelime) for v in deger)
    return False


def yasak_listesi(yol: Path | None) -> list[str]:
    if yol is None or not yol.is_file():
        return []
    return [satir.strip() for satir in yol.read_text(encoding="utf-8").splitlines() if satir.strip() and not satir.startswith("#")]


def chr_dosyalari(root: Path = ROOT) -> list[Path]:
    return sorted((root / "data/chr_runtime").glob("CHR_*.tres"))


def adli_dosyalar(root: Path = ROOT) -> list[Path]:
    return sorted((root / "data/karakterler").glob("chr_*.tres"))


def sema_kosusu(root: Path = ROOT) -> tuple[list[dict], dict]:
    bas = time.perf_counter()
    hatalar: list[dict] = []
    chrler = chr_dosyalari(root)
    adlilar = adli_dosyalar(root)
    for dosya in chrler + adlilar:
        hatalar.extend(sema_hatalari(dosya.read_text(encoding="utf-8", errors="replace"), dosya.name))
    sure_ms = (time.perf_counter() - bas) * 1000
    return hatalar, {"sure_ms": round(sure_ms, 2), "chr": len(chrler), "adli": len(adlilar)}


def main(argv: list[str] | None = None) -> int:
    if str(ROOT) not in sys.path:
        sys.path.insert(0, str(ROOT / "tools"))
    ayr = argparse.ArgumentParser(description="Söz doğrulayıcı")
    ayr.add_argument("--sema", action="store_true")
    ayr.add_argument("--kayit", type=Path)
    ayr.add_argument("--yasak", type=Path)
    ayr.add_argument("--anahtarlar", type=Path)
    ayr.add_argument("--tum", action="store_true", help="KAY-53: 30 CHR ve adlı karakterler")
    arg = ayr.parse_args(argv)
    if not arg.sema and arg.kayit is None and not arg.tum:
        arg.sema = True
        arg.tum = True
    hatalar: list[dict] = []
    rapor = {"sure_ms": 0, "chr": 0, "adli": 0}
    if arg.sema or arg.tum:
        hatalar, rapor = sema_kosusu()
        print("KAY-53 sure_ms=%s chr=%s adli=%s" % (rapor["sure_ms"], rapor["chr"], rapor["adli"]))
    if arg.kayit is not None:
        kayit = json.loads(arg.kayit.read_text(encoding="utf-8"))
        anahtarlar = None
        if arg.anahtarlar is not None:
            anahtarlar = {satir.split(",", 1)[0].strip() for satir in arg.anahtarlar.read_text(encoding="utf-8").splitlines() if satir.strip()}
        hatalar.extend(kayit_hatalari(kayit, katalog_kimlikleri(), anahtarlar, yasak_listesi(arg.yasak)))
    for hata in hatalar:
        print("%s: %s" % (hata.get("tur", "hata"), hata.get("mesaj", "")))
    if hatalar and goc_durur(hatalar):
        print("KAY-17 GOC_DURUR")
    elif hatalar:
        print("KAY-33 GOC_SURER")
    if not any(h.get("tur") == "kopuk_dugum" for h in hatalar):
        print("KAY-38")
    return 1 if any(h.get("tur") != "kota" for h in hatalar) else 0


if __name__ == "__main__":
    sys.path.insert(0, str(ROOT / "tools"))
    raise SystemExit(main())
