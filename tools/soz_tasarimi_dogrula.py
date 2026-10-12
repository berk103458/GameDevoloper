"""DIY-01: docs/SOZ_TASARIMI.md doğrulayıcısı.

Kurallar: tam iki bölüm (İnceleme, Kapı usulü); İnceleme'de yedi kaynak; her kaynakta dört satır
(Ne yapıyor, Neden işe yarıyor, Alınacak, Alınmayacak); her "Alınacak" parçası (`;` ile ayrılır)
ROADMAP_2.md'de var olan bir DIY veya ZAR kimliği taşır; iç ses, beceri ağacı ve görünmez zar
"Alınacak" satırında geçemez. Çıkış kodu hata sayısıdır (0 = geçti).
"""
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
KAYNAKLAR = ("Kingdom Come", "Disco Elysium", "Valve", "Failbetter", "Pentiment", "Papers, Please", "inkle")
SATIRLAR = ("Ne yapıyor", "Neden işe yarıyor", "Alınacak", "Alınmayacak")
YASAK = ("iç ses", "beceri ağacı", "görünmez zar")
KIMLIK = re.compile(r"\b(?:DIY|ZAR)-\d+[a-z]?\b")


def kimlikler(roadmap: str) -> set:
    return set(re.findall(r"^- \[[ /x]\] \*\*((?:DIY|ZAR)-\d+[a-z]?):\*\*", roadmap, re.M))


def dogrula(belge: str, gecerli: set) -> list:
    hatalar = []
    bolumler = re.findall(r"^## (.+)$", belge, re.M)
    if len(bolumler) != 2:
        hatalar.append(f"Bölüm sayısı {len(bolumler)}; tam 2 olmalı (İnceleme, Kapı usulü).")
    inceleme = re.split(r"^## ", belge, flags=re.M)
    govde = next((b for b in inceleme if b.startswith("İnceleme")), "")
    basliklar = re.split(r"^### ", govde, flags=re.M)[1:]
    for kaynak in KAYNAKLAR:
        if not any(b.startswith(kaynak) for b in basliklar):
            hatalar.append(f"Kaynak başlığı yok: {kaynak}")
    if len(basliklar) != len(KAYNAKLAR):
        hatalar.append(f"İnceleme {len(basliklar)} kaynak; tam {len(KAYNAKLAR)} olmalı.")
    for blok in basliklar:
        ad = blok.splitlines()[0].strip()
        for satir in SATIRLAR:
            m = re.search(r"^- \*\*" + re.escape(satir) + r":\*\*(.*)$", blok, re.M)
            if m is None or not m.group(1).strip():
                hatalar.append(f"{ad}: '{satir}' satırı yok ya da boş.")
                continue
            if satir != "Alınacak":
                continue
            metin = m.group(1)
            for yasak in YASAK:
                if yasak in metin.lower():
                    hatalar.append(f"{ad}: alınmayacak mekanik '{yasak}' Alınacak satırında.")
            for parca in (p.strip() for p in metin.split(";")):
                if not parca:
                    continue
                bulunan = KIMLIK.findall(parca)
                if not bulunan:
                    hatalar.append(f"{ad}: kimliği olmayan alınacak parça: {parca[:60]}")
                for k in bulunan:
                    if k not in gecerli:
                        hatalar.append(f"{ad}: ROADMAP_2'de olmayan kimlik {k}")
    return hatalar


def main(argv=None) -> int:
    argv = argv if argv is not None else sys.argv[1:]
    belge_yolu = Path(argv[0]) if argv else ROOT / "docs/SOZ_TASARIMI.md"
    gecerli = kimlikler((ROOT / "ROADMAP_2.md").read_text(encoding="utf-8"))
    hatalar = dogrula(belge_yolu.read_text(encoding="utf-8"), gecerli)
    for h in hatalar:
        print("HATA: " + h)
    print("SÖZ TASARIMI: " + ("GEÇTİ" if not hatalar else f"KALDI ({len(hatalar)} hata)"))
    return len(hatalar)


if __name__ == "__main__":
    raise SystemExit(main())
