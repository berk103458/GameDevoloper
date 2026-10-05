"""Meshy'den elle indirilen GLB'leri seçim listesiyle eşleştirir ve adlandırarak yerleştirir.

Meshy topluluk modelleri yalnız hesapla indirilebiliyor; indirilen dosyaların adı tutarsız. Bu betik her GLB'nin
üçgen sayısını okur, `design/art/meshy/meshy-secim.json` içindeki modellerle karşılaştırır (Meshy aynı modeli aynı
üçgen sayısıyla verir) ve dosyayı `assets/meshy/<bölüm>/<kod>_<ad>.glb` olarak kopyalar. Oyuna eklemez; sahne kodu
bu dosyalara dokunmaz. Gözlem verir, hüküm vermez: eşleşmeyen ya da birden çok adaya uyan dosyayı yalnız raporlar.

Kullanım:
    python3 tools/varlik/meshy_esle.py [indirilenler_klasoru]      (varsayılan: assets/meshy/gelen)
    .zip içindeki GLB'ler de okunur.
"""
import json
import os
import shutil
import struct
import sys
import tempfile
import zipfile

KOK = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
LISTE = os.path.join(KOK, "design", "art", "meshy", "meshy-secim.json")
HEDEF = os.path.join(KOK, "assets", "meshy")
# Üçgen sayısı bu oranda farklıysa yine aday sayılır (dışa aktarımda birkaç üçgen oynayabilir).
TOLERANS = 0.002


def ucgen_sayisi(yol):
    """GLB'deki toplam üçgen sayısı (indeksli ya da indekssiz TRIANGLES ilkelleri)."""
    with open(yol, "rb") as f:
        bas = f.read(12)
        if len(bas) < 12 or bas[:4] != b"glTF":
            return None
        uzunluk, tur = struct.unpack("<I4s", f.read(8))
        if tur != b"JSON":
            return None
        gltf = json.loads(f.read(uzunluk))
    erisim = gltf.get("accessors", [])
    toplam = 0
    for mesh in gltf.get("meshes", []):
        for p in mesh.get("primitives", []):
            if p.get("mode", 4) != 4:
                continue
            if "indices" in p:
                toplam += erisim[p["indices"]]["count"] // 3
            elif "POSITION" in p.get("attributes", {}):
                toplam += erisim[p["attributes"]["POSITION"]]["count"] // 3
    return toplam


def glb_dosyalari(klasor, gecici):
    for kok, _, dosyalar in os.walk(klasor):
        for ad in sorted(dosyalar):
            yol = os.path.join(kok, ad)
            if ad.lower().endswith(".glb"):
                yield yol
            elif ad.lower().endswith(".zip"):
                with zipfile.ZipFile(yol) as z:
                    for ic in z.namelist():
                        if ic.lower().endswith(".glb"):
                            yield z.extract(ic, os.path.join(gecici, os.path.basename(ad)))


def main():
    klasor = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HEDEF, "gelen")
    liste = json.load(open(LISTE, encoding="utf-8"))
    bulunan = {}
    eslesmeyen, belirsiz = [], []
    with tempfile.TemporaryDirectory() as gecici:
        for yol in glb_dosyalari(klasor, gecici):
            n = ucgen_sayisi(yol)
            adaylar = [m for m in liste if n and m["ucgen"] and abs(m["ucgen"] - n) <= m["ucgen"] * TOLERANS]
            if len(adaylar) == 1:
                m = adaylar[0]
                cikis = os.path.join(HEDEF, m["bolum"], m["dosya"])
                os.makedirs(os.path.dirname(cikis), exist_ok=True)
                shutil.copy2(yol, cikis)
                bulunan[m["kod"]] = os.path.relpath(cikis, KOK)
                print(f"  {m['kod']:5s} {n:>9,} üçgen  {os.path.basename(yol)}  ->  {bulunan[m['kod']]}")
            elif adaylar:
                belirsiz.append((os.path.basename(yol), n, [m["kod"] for m in adaylar]))
            else:
                eslesmeyen.append((os.path.basename(yol), n))
    eksik = [m for m in liste if m["kod"] not in bulunan]
    print(f"\nEşleşen {len(bulunan)} / {len(liste)}")
    for ad, n, kodlar in belirsiz:
        print(f"  BELİRSİZ  {ad} ({n} üçgen): {', '.join(kodlar)} — dosyayı koduyla yeniden adlandır")
    for ad, n in eslesmeyen:
        print(f"  EŞLEŞMEDİ {ad} ({n} üçgen) — listede yok ya da Meshy indirirken üçgen sayısını değiştirdi")
    if eksik:
        print("\nHenüz indirilmeyenler:")
        for m in eksik:
            print(f"  {m['kod']:5s} {m['ad']}  {m['url']}")


if __name__ == "__main__":
    main()
