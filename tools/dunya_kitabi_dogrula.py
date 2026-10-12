"""YAZ-01: docs/dunya_kitabi/ doğrulayıcısı.

- On dört konu dosyası (README sayılmaz); her birinde boş olmayan `## Kaynaklar`.
- `## Onay` iki satır: `Anlatı yönetmeni:` ve `Ahmet:`; "bekliyor" olan dosya onaysızdır ve
  YAZ-04 onu `data/soz/` altına almaz (`onayli_dosyalar`).
- Aynı olgu anahtarı iki dosyada farklı metinle geçerse çift listelenir (`celiskiler`); ikisi de oyuna girmez.
- `sehir_hatalari(metin)`: coğrafya dosyasının Şehirler listesinde olmayan şehir adı 1 hata.
Çıkış kodu yapısal hata sayısıdır; onay eksikliği hata değil, durum bilgisidir.
"""
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
KITAP = ROOT / "docs/dunya_kitabi"
KONULAR = ("tarih", "uc_duzeni", "turkmen_gocu", "bizans_rum", "ermeni_suryani", "ahi", "dervisler",
           "ticaret_kervansaray", "koy_ekonomisi", "meslekler", "giyim", "yemek", "inanc_yemin", "cografya")
OLGU = re.compile(r"^- \*\*([a-z0-9_]+):\*\*\s*(.+)$", re.M)
# Karakter kartında şehir sayılabilecek, dönemde bilinen ama listede olmayan adlar (yakalama listesi).
BILINEN_SEHIRLER = ("Sivas", "Erzincan", "Kayseri", "Konya", "Malatya", "Aksaray", "Kırşehir", "Amasya", "Tokat",
                    "Erzurum", "Niğde", "Ankara", "Kastamonu", "Sinop", "Samsun", "Antalya", "Alanya", "Trabzon",
                    "Bayburt", "Divriği", "Harput", "Elbistan", "Ahlat", "Tebriz", "Bağdat", "Halep", "Şam", "İznik", "İstanbul")


def bolum(metin: str, ad: str) -> str:
    m = re.search(r"^## " + re.escape(ad) + r"\s*$(.*?)(?=^## |\Z)", metin, re.M | re.S)
    return m.group(1) if m else ""


def kaynak_sayisi(metin: str) -> int:
    return len([s for s in bolum(metin, "Kaynaklar").splitlines() if s.strip().startswith("- ") and len(s.strip()) > 10])


def onay(metin: str) -> dict:
    govde = bolum(metin, "Onay")
    sonuc = {}
    for etiket in ("Anlatı yönetmeni", "Ahmet"):
        m = re.search(r"^- " + re.escape(etiket) + r":\s*(.*)$", govde, re.M)
        sonuc[etiket] = m.group(1).strip() if m else ""
    return sonuc


def onayli(metin: str) -> bool:
    return all(v and v.lower() != "bekliyor" for v in onay(metin).values())


def dosyalar(kitap: Path = KITAP) -> dict:
    return {p.stem: p.read_text(encoding="utf-8") for p in sorted(kitap.glob("*.md")) if p.stem != "README"}


def kaynakli_sayim(d: dict) -> int:
    return sum(1 for ad in KONULAR if ad in d and kaynak_sayisi(d[ad]) > 0)


def onayli_dosyalar(d: dict) -> list:
    return [ad for ad in KONULAR if ad in d and kaynak_sayisi(d[ad]) > 0 and onayli(d[ad])]


def celiskiler(d: dict) -> list:
    gorulen = {}
    ciftler = []
    for ad, metin in d.items():
        for anahtar, olgu in OLGU.findall(bolum(metin, "Olgular")):
            if anahtar in gorulen and gorulen[anahtar][1] != olgu.strip():
                ciftler.append((anahtar, gorulen[anahtar][0], ad))
            gorulen.setdefault(anahtar, (ad, olgu.strip()))
    return ciftler


def sehirler(d: dict) -> list:
    return [s.strip()[2:].strip() for s in bolum(d.get("cografya", ""), "Şehirler").splitlines() if s.strip().startswith("- ")]


def sehir_hatalari(metin: str, d: dict) -> list:
    izinli = set(sehirler(d))
    return [s for s in BILINEN_SEHIRLER if s not in izinli and re.search(r"\b" + re.escape(s) + r"\b", metin)]


def yapisal_hatalar(d: dict) -> list:
    hatalar = []
    for ad in KONULAR:
        if ad not in d:
            hatalar.append(f"{ad}.md yok")
            continue
        if kaynak_sayisi(d[ad]) == 0:
            hatalar.append(f"{ad}.md: Kaynaklar boş ya da yok")
        if not OLGU.findall(bolum(d[ad], "Olgular")):
            hatalar.append(f"{ad}.md: Olgular boş")
        if set(onay(d[ad])) != {"Anlatı yönetmeni", "Ahmet"} or any(v == "" for v in onay(d[ad]).values()):
            hatalar.append(f"{ad}.md: Onay bölümü iki satır değil")
    for anahtar, a, b in celiskiler(d):
        hatalar.append(f"çelişen olgu '{anahtar}': {a}.md ↔ {b}.md (ikisi de oyuna girmez)")
    return hatalar


def main() -> int:
    d = dosyalar()
    hatalar = yapisal_hatalar(d)
    for h in hatalar:
        print("HATA: " + h)
    print(f"Kaynaklı konu: {kaynakli_sayim(d)}/{len(KONULAR)} · Onaylı: {len(onayli_dosyalar(d))}/{len(KONULAR)}")
    print("DÜNYA KİTABI: " + ("GEÇTİ" if not hatalar else f"KALDI ({len(hatalar)} hata)"))
    return len(hatalar)


if __name__ == "__main__":
    raise SystemExit(main())
