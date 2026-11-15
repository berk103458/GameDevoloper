"""YAZ-10: inceleme işaretleri ve kapsam taraması.

İşaret dosyası sahne dosyasından ayrıdır:
{"sahne": "<dosya_id>", "isaretler": {"<sid>": {"isaret": "dogal|yapay|yeniden_yaz", "metin": "..."}}}
Satır kimliği düğüm için "<dugum>", seçenek için "<dugum>/<secenek>"dir.
Kapsam taraması kayıtlı bağlam tohumlarıyla ağacı yürütür; kilit kuralları SozMotoru._kilit_uygun_mu ile aynıdır.
Oyuncu bu taramayı görmez; araç Godot başlatmaz, dosya yazmaz.
"""
from __future__ import annotations

from collections import deque

ISARETLER = ("dogal", "yapay", "yeniden_yaz")
METIN_DEGISTI = "metin_degisti"
ISARETSIZ = "isaretsiz"


def _dugumler(sahne: dict) -> dict[str, dict]:
    ham = sahne.get("dugumler", {})
    if isinstance(ham, list):
        return {str(d.get("id", "")): d for d in ham if isinstance(d, dict)}
    return {str(k): v for k, v in ham.items() if isinstance(v, dict)}


def satirlar(sahne: dict) -> dict[str, str]:
    sonuc: dict[str, str] = {}
    for kimlik, dugum in _dugumler(sahne).items():
        metin = str(dugum.get("satir", dugum.get("metin", "")))
        if metin:
            sonuc[kimlik] = metin
        for sec in dugum.get("secenekler", []) or []:
            sonuc["%s/%s" % (kimlik, sec.get("id", ""))] = str(sec.get("metin", ""))
    return sonuc


def isaretle(isaret: dict, sahne: dict, sid: str, deger: str) -> dict:
    if deger not in ISARETLER:
        raise ValueError("bilinmeyen isaret: " + deger)
    metin = satirlar(sahne)[sid]
    isaret.setdefault("sahne", sahne.get("dosya_id", ""))
    isaret.setdefault("isaretler", {})[sid] = {"isaret": deger, "metin": metin}
    return isaret


def durumlar(sahne: dict, isaret: dict) -> tuple[dict[str, str], list[str]]:
    """Satır başına durum ve sahnede karşılığı kalmayan işaretler."""
    kayit = isaret.get("isaretler", {}) if isinstance(isaret, dict) else {}
    simdiki = satirlar(sahne)
    durum: dict[str, str] = {}
    for sid, metin in simdiki.items():
        i = kayit.get(sid)
        if not isinstance(i, dict) or i.get("isaret") not in ISARETLER:
            durum[sid] = ISARETSIZ
        elif str(i.get("metin", "")) != metin:
            durum[sid] = METIN_DEGISTI
        else:
            durum[sid] = str(i["isaret"])
    eslesmeyen = sorted(sid for sid in kayit if sid not in simdiki)
    return durum, eslesmeyen


def kilit_uygun(kosul: dict, baglam: dict) -> bool:
    if not kosul:
        return True
    tansiyon = int(baglam.get("tansiyon", 0))
    if "tansiyon_max" in kosul and tansiyon > int(kosul["tansiyon_max"]):
        return False
    if "tansiyon_min" in kosul and tansiyon < int(kosul["tansiyon_min"]):
        return False
    if "gerekli_ipucu" in kosul and kosul["gerekli_ipucu"] not in baglam.get("ipuclari", []):
        return False
    if "gerekli_bayrak" in kosul and not baglam.get("bayraklar", {}).get(kosul["gerekli_bayrak"], False):
        return False
    if baglam.get("panik", False) and kosul.get("eylem_turu", "") in ("ikna", "gozdagi"):
        return False
    if kosul.get("final_ret", False) and not baglam.get("final_ret_uygun", True):
        return False
    if "karar_kisiti" in kosul and not baglam.get(kosul["karar_kisiti"], False):
        return False
    return True


def kapsam(sahne: dict, tohumlar: list[dict]) -> dict:
    """Hiç ulaşılmayan düğüm ve hiç sunulmayan seçenek satırları."""
    dugumler = _dugumler(sahne)
    if not tohumlar:
        return {"calismadi": True, "ulasilmayan": [], "secilmeyen": []}
    bas = str(sahne.get("baslangic_dugumu", next(iter(dugumler), "")))
    ulasilan: set[str] = set()
    sunulan: set[str] = set()
    for baglam in tohumlar:
        gorulen = {bas}
        kuyruk = deque([bas])
        while kuyruk:
            kimlik = kuyruk.popleft()
            ulasilan.add(kimlik)
            for sec in dugumler.get(kimlik, {}).get("secenekler", []) or []:
                kosul = sec.get("kosul", sec.get("kilit", {})) or {}
                if not kilit_uygun(kosul, baglam):
                    continue
                sunulan.add("%s/%s" % (kimlik, sec.get("id", "")))
                hedef = str(sec.get("hedef", ""))
                if hedef in dugumler and hedef not in gorulen:
                    gorulen.add(hedef)
                    kuyruk.append(hedef)
    secenekler = [sid for sid in satirlar(sahne) if "/" in sid]
    return {
        "calismadi": False,
        "ulasilmayan": sorted(k for k in dugumler if k not in ulasilan),
        "secilmeyen": sorted(s for s in secenekler if s not in sunulan),
    }


def onay_hatalari(sahne: dict, isaret: dict, tohumlar: list[dict]) -> list[dict]:
    """Sahne yalnız yapay/yeniden yaz/değişmiş/işaretsiz satır 0 ve görünmeyen satır 0 iken onaya gider."""
    hatalar: list[dict] = []
    durum, eslesmeyen = durumlar(sahne, isaret)
    for sid, d in sorted(durum.items()):
        if d != "dogal":
            hatalar.append({"tur": "hata", "kod": "YAZ-10", "mesaj": "%s: %s" % (sid, d)})
    for sid in eslesmeyen:
        hatalar.append({"tur": "hata", "kod": "YAZ-10", "mesaj": "eslesmeyen isaret: " + sid})
    tarama = kapsam(sahne, tohumlar)
    if tarama["calismadi"]:
        hatalar.append({"tur": "hata", "kod": "YAZ-10", "mesaj": "kapsam calismadi: tohum yok"})
    for k in tarama["ulasilmayan"]:
        hatalar.append({"tur": "hata", "kod": "YAZ-10", "mesaj": "ulasilmayan dugum: " + k})
    for s in tarama["secilmeyen"]:
        hatalar.append({"tur": "hata", "kod": "YAZ-10", "mesaj": "secilmeyen satir: " + s})
    return hatalar
