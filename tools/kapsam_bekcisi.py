"""ROADMAP 2 kapsam bekçisi: "X yoktur" maddelerinin tarama kuralları (salt okunur).

Her kural bir ya da birkaç maddeye bağlıdır ve ihlal listesi döner (boş = temiz). Kural metni maddenin
Kabul satırından gelir; bir sınır kalkacaksa önce madde değişir, sonra kural.
Kullanım: python -B tools/kapsam_bekcisi.py   (çıkış kodu ihlal sayısı)
"""
from pathlib import Path
import json
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
# SOY-49 / OZL-31: R2 seslendirme yasağı; assets/ses altında ses dosyası sayısı bu sayıdan artmaz.
SES_TABANI = 39
SES_UZANTILARI = (".wav", ".ogg", ".mp3")


def _kod(metin: str) -> str:
    """GDScript yorumlarını atar (# sonrası); dize içindeki # kabaca korunmaz, kurallar için yeterli."""
    return "\n".join(s.split("#", 1)[0] for s in metin.splitlines())


def _gd(root: Path, alt: str = "src"):
    yield from sorted((root / alt).rglob("*.gd")) if (root / alt).is_dir() else ()


def _rel(root: Path, p: Path) -> str:
    return p.relative_to(root).as_posix()


def han47_hane_romans(root):
    """HAN-47: `rg -i 'kalp|hediye|romans|iliski' src/koy/hane*.gd` → 0 (yorum ve dize dahil, madde birebir)."""
    desen = re.compile(r"kalp|hediye|romans|iliski", re.I)
    return [_rel(root, p) for p in sorted((root / "src/koy").glob("hane*.gd")) if desen.search(p.read_text(encoding="utf-8"))]


def hfz30_kalp_anahtari(root):
    """HFZ-30: kodda ve veri anahtarlarında kalp/romans/hediye adı yok (diyalog metni sayılmaz)."""
    ad = re.compile(r"\b(kalp|romans|hediye)\w*", re.I)
    bulunan = [_rel(root, p) for p in _gd(root) if ad.search(re.sub(r'"[^"\n]*"', '""', _kod(p.read_text(encoding="utf-8"))))]
    for p in sorted((root / "data").rglob("*.json")) if (root / "data").is_dir() else ():
        if re.search(r'"(kalp|romans|hediye)\w*"\s*:', p.read_text(encoding="utf-8", errors="replace"), re.I):
            bulunan.append(_rel(root, p))
    return bulunan


def klt21_hitap_puani(root):
    """KLT-21: `hitap_puani` alanı açılmaz."""
    return [_rel(root, p) for d in ("src", "data") if (root / d).is_dir() for p in sorted((root / d).rglob("*"))
            if p.is_file() and p.suffix in (".gd", ".json", ".tres") and "hitap_puani" in p.read_text(encoding="utf-8", errors="replace")]


def han50_hane_sahnesi(root):
    """HAN-50: hane_sahnesi / ev_ici adlı sahne ya da betik yok."""
    return [_rel(root, p) for p in sorted((root / "src").rglob("*")) if p.suffix in (".tscn", ".gd") and re.search(r"hane_sahnesi|ev_ici", p.name)]


def soy31_baloncuk(root):
    """SOY-31: koy/gorsel içinde söylenti çizimi yok."""
    return [_rel(root, p) for p in _gd(root, "src/koy/gorsel") if re.search(r"soylenti", _kod(p.read_text(encoding="utf-8")), re.I)]


def soy49_ozl31_ses_sayisi(root):
    """SOY-49 / OZL-31: assets/ses ses dosyası sayısı tabanı aşmaz."""
    klasor = root / "assets/ses"
    sayi = sum(1 for p in klasor.rglob("*") if p.suffix.lower() in SES_UZANTILARI) if klasor.is_dir() else 0
    return [f"assets/ses: {sayi} > {SES_TABANI}"] if sayi > SES_TABANI else []


def ozl23_kule_olayi(root):
    """OZL-23: data/olaylar içinde kule kimlikli olay yok."""
    klasor = root / "data/olaylar"
    return [_rel(root, p) for p in sorted(klasor.rglob("*")) if p.is_file() and "kule" in p.name.lower()] if klasor.is_dir() else []


def ozl28_olay_sahnesi(root):
    """OZL-28: olay_sahnesi.tscn yok; kart BilgiEkrani kadrajıdır."""
    return [_rel(root, p) for p in sorted(root.rglob("olay_sahnesi.tscn")) if ".godot" not in p.parts]


def ozl32_gece_haritasi(root):
    """OZL-32: gece haritası yok."""
    return [_rel(root, p) for d in ("src", "data") if (root / d).is_dir() for p in sorted((root / d).rglob("*"))
            if p.is_file() and ("gece_haritasi" in p.name or (p.suffix in (".gd", ".json", ".tres") and "gece_haritasi" in p.read_text(encoding="utf-8", errors="replace")))]


def hfz22_son_defter(root):
    """HFZ-22: son ekranı (ana.gd) hafıza defterini açmaz."""
    ana = root / "src/arayuz/ana.gd"
    return ["src/arayuz/ana.gd"] if ana.is_file() and "HafizaDefteriEkrani" in _kod(ana.read_text(encoding="utf-8")) else []


KURALLAR = {
    "HAN-47": han47_hane_romans,
    "HFZ-30": hfz30_kalp_anahtari,
    "KLT-21": klt21_hitap_puani,
    "HAN-50": han50_hane_sahnesi,
    "SOY-31": soy31_baloncuk,
    "SOY-49/OZL-31": soy49_ozl31_ses_sayisi,
    "OZL-23": ozl23_kule_olayi,
    "OZL-28": ozl28_olay_sahnesi,
    "OZL-32": ozl32_gece_haritasi,
    "HFZ-22": hfz22_son_defter,
}

# Bölüm 41 (TEK) sınırları: bu bölümün commit'leri şu dosyalara dokunmaz (git geçmişi taraması).
TEK_DOKUNMAZ = {"TEK-30": "src/dunya/donma_yoneticisi.gd", "TEK-33": "src/koy/odun_zinciri.gd"}


def tek_commit_dosyalari(root: Path) -> list:
    """[(commit, konu, dosya)] — konusu TEK-n içeren commit'lerin dokunduğu dosyalar; git yoksa boş."""
    import subprocess
    try:
        cikti = subprocess.run(["git", "log", "--format=@@%h %s", "--name-only", "HEAD"], cwd=root,
                               capture_output=True, text=True, encoding="utf-8", errors="replace", timeout=60).stdout
    except (OSError, subprocess.SubprocessError):
        return []
    sonuc, konu = [], None
    for satir in cikti.splitlines():
        if satir.startswith("@@"):
            konu = satir[2:]
        elif satir.strip() and konu and re.search(r"\bTEK-\d+", konu):
            sonuc.append((konu.split(" ", 1)[0], konu, satir.strip()))
    return sonuc


def tek_dokunmaz_ihlalleri(kayitlar: list) -> dict:
    return {madde: [f"{c} {dosya}" for c, _, d in kayitlar if d == dosya] for madde, dosya in TEK_DOKUNMAZ.items()}


def tek32_chr011(roadmap: str) -> list:
    """TEK-32: Bölüm 41'de chr_011 düzeltme adımı yok; chr_011 yalnız TEK-32'nin kendi satırlarında geçer."""
    bolum = roadmap.split("## BÖLÜM 41", 1)[1].split("\n## ", 1)[0] if "## BÖLÜM 41" in roadmap else ""
    ihlal, madde = [], None
    for satir in bolum.splitlines():
        m = re.match(r"- \[[ /x]\] \*\*(TEK-\d+):", satir)
        if m:
            madde = m.group(1)
        if "chr_011" in satir and madde != "TEK-32":
            ihlal.append(f"{madde}: {satir.strip()[:60]}")
    return ihlal


def denetle(root: Path = ROOT) -> dict:
    sonuc = {ad: kural(root) for ad, kural in KURALLAR.items()}
    sonuc.update(tek_dokunmaz_ihlalleri(tek_commit_dosyalari(root)))
    roadmap = root / "ROADMAP_2.md"
    sonuc["TEK-32"] = tek32_chr011(roadmap.read_text(encoding="utf-8")) if roadmap.is_file() else []
    return sonuc


def main() -> int:
    sonuc = denetle()
    toplam = 0
    for ad, ihlal in sonuc.items():
        print(("FAIL " if ihlal else "PASS ") + ad + ("" if not ihlal else ": " + ", ".join(ihlal)))
        toplam += len(ihlal)
    print("KAPSAM BEKÇİSİ: " + ("GEÇTİ" if toplam == 0 else f"KALDI ({toplam} ihlal)"))
    return toplam


if __name__ == "__main__":
    raise SystemExit(main())
