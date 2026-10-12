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


def srm16_steam(root):
    """SRM-16: Steamworks bu sürüme girmez; `steam` geçen betik (src/tools/bridge .gd/.py) 0."""
    return [_rel(root, p) for d in ("src", "tools", "bridge") if (root / d).is_dir() for p in sorted((root / d).rglob("*"))
            if p.suffix in (".gd", ".py") and p.name != "kapsam_bekcisi.py" and re.search(r"steam", p.read_text(encoding="utf-8", errors="replace"), re.I)]


def yer20_ikinci_tarayici(root):
    """YER-20: ikinci metin tarayıcısı yok; yerelleştirme metin_dogrula.py çıktısını okur."""
    return [_rel(root, p) for p in sorted(root.rglob("metin_tarayici*")) if ".godot" not in p.parts]


def srm22_24_magaza(root):
    """SRM-22/23/24: MAGAZA.md'de kayıt yolu bir kez, bulut sözü, seslendirme vaadi ve ikinci harita 0."""
    sayfa = root / "docs/surum/MAGAZA.md"
    if not sayfa.is_file():
        return []
    metin = sayfa.read_text(encoding="utf-8")
    ihlal = []
    if metin.count("user://kayit.json") != 1:
        ihlal.append("kayıt yolu tam bir kez değil")
    if re.search(r"bulut|cloud", metin, re.I):
        ihlal.append("bulut sözü")
    if re.search(r"sesli diyalog|seslendirilmiş|seslendirme (vardır|içerir)", metin, re.I):
        ihlal.append("seslendirme vaadi")
    if re.search(r"dünya haritası|ikinci harita|haritalar", metin, re.I):
        ihlal.append("ikinci harita")
    return ihlal


def srm15_tek_cikis(root):
    """SRM-15: oyunu kapatan tek çağrı `Ses.cik` içindeki `get_tree().quit`; ikinci kapatma yolu yok."""
    cagrilar = [(_rel(root, p), no) for p in _gd(root) for no, s in enumerate(p.read_text(encoding="utf-8").splitlines(), 1)
                if re.search(r"\.quit\(", s.split("#", 1)[0])]
    return [f"{d}:{n}" for d, n in cagrilar if d != "src/sistemler/ses.gd"] + ([] if len(cagrilar) <= 1 else [f"{len(cagrilar)} quit çağrısı"])


def grv27_sanat_disi_yukleme(root):
    """GRV-27: src/arayuz içinde load("res://assets…") yalnız Sanat'ta ya da belgelenmiş istisnada."""
    belge = root / "docs/arayuz/YUKLEME_ISTISNALARI.md"
    istisna = set(re.findall(r"^\| `(src/[^`]+)` \|", belge.read_text(encoding="utf-8"), re.M)) if belge.is_file() else set()
    istisna.add("src/arayuz/sanat.gd")
    return [_rel(root, p) for p in _gd(root, "src/arayuz") if _rel(root, p) not in istisna
            and re.search(r'load\("res://assets', _kod(p.read_text(encoding="utf-8")))]


def yer14_cogul(root):
    """YER-14: çoğul eki motoru yok; src'de çoğul/plural fonksiyonu 0."""
    return [_rel(root, p) for p in _gd(root) if re.search(r"func\s+\w*(cogul|plural)", p.read_text(encoding="utf-8"), re.I)]


def yer15_locale(root):
    """YER-15: sayı biçimi Türkçe kalır; tek locale çağrısı ana.gd'deki set_locale("tr")."""
    bulunan = [(_rel(root, p), s.strip()) for p in _gd(root) for s in _kod(p.read_text(encoding="utf-8")).splitlines() if "set_locale" in s]
    return [f"{d}: {s}" for d, s in bulunan if (d, s) != ("src/arayuz/ana.gd", 'TranslationServer.set_locale("tr")')]


def omr46_omurga_acilis(root):
    """OMR-46: omurga verisi açılışı okumaz."""
    veri = root / "data/omurga.json"
    return ["data/omurga.json"] if veri.is_file() and re.search(r"acilis|ACL-", veri.read_text(encoding="utf-8"), re.I) else []


def omr51_bes_son(root):
    """OMR-51: beş nihai son sabit; üçüncü perde/yeni son yok."""
    veri = root / "data/nihai_sonlar.json"
    if not veri.is_file():
        return []
    sonlar = json.loads(veri.read_text(encoding="utf-8")).get("sonlar", {})
    return [] if len(sonlar) == 5 else [f"nihai son sayısı {len(sonlar)}"]


def gir18_orta_tus(roadmap: str) -> list:
    """GIR-18: girdi bölümünde orta tuş maddesi tektir (GIR-18)."""
    bolum = roadmap.split("## BÖLÜM 45", 1)[1].split("\n## ", 1)[0] if "## BÖLÜM 45" in roadmap else ""
    maddeler = re.findall(r"^- \[[ /x]\] \*\*(GIR-\d+):\*\*([^\n]*)", bolum, re.M)
    orta = [m for m, baslik in maddeler if re.search(r"orta tuş", baslik, re.I)]
    return [] if len(orta) <= 1 else [f"orta tuş maddeleri: {orta}"]


# HAN-49: oyuncu eşi yönetmez; karakter yürütme (`.yuru(`) yalnız bu sahnelerde ve köylü rutinindedir.
YURU_IZINLI = {"src/dunya/kapi_sahnesi.gd", "src/dunya/menu_sahnesi.gd", "src/dunya/kapi_manzarasi.gd",
               "src/dunya/karakter_model.gd", "src/koy/gorsel/koy_halk_hareketi.gd",
               "src/kapi/sira_atlama_adaptoru.gd", "src/kapi/sira_olayi_sonucu.gd"}  # kapı kuyruğu gelenleri


def han49_es_yurutme(root):
    """HAN-49: izinli sahneler ve rutin dışında `.yuru(` çağrısı yok (eş sürüklenmez, kapıya gitmez)."""
    return [_rel(root, p) for p in _gd(root) if _rel(root, p) not in YURU_IZINLI
            and re.search(r"\.yuru\(", _kod(p.read_text(encoding="utf-8")))]


TURKCE_HARF = re.compile(r"[çğıöşüÇĞİÖŞÜ]")
TURKCE_CUMLE = re.compile(r"^[A-Za-zÇĞİÖŞÜçğıöşü]{2,} [a-zçğıöşü]{2,}")


def turkce_sabitler(metin: str) -> list:
    """GDScript kodundaki (yorum dışı) düz Türkçe dize sabitleri."""
    kod = "\n".join("" if s.strip().startswith("#") else s.split(" #", 1)[0] for s in metin.splitlines())
    return [d for d in re.findall(r'"([^"\n]*)"', kod) if TURKCE_HARF.search(d) or TURKCE_CUMLE.search(d)]


def _turkce_sabit_dosyalari(root, desenler):
    return [f"{_rel(root, p)}: {t[:30]}" for p in _gd(root) if any(re.search(d, _rel(root, p)) for d in desenler)
            for t in turkce_sabitler(p.read_text(encoding="utf-8"))]


def ayr51_ayar_metni(root):
    """AYR-51: ayarlar ekranı ve sekme dosyalarında Türkçe sabit 0 (metin arayuz.ayarlar.* anahtarıdır)."""
    return _turkce_sabit_dosyalari(root, [r"^src/arayuz/ayarlar_ekrani\.gd$", r"^src/arayuz/grafik_ayarlari_paneli\.gd$",
                                          r"^src/arayuz/.*sekme.*\.gd$"])


def tek21_yukleme_metni(root):
    """TEK-21: yükleme paneli metni çeviri anahtarıdır; dosyada düz Türkçe 0 (istisna listesi boş)."""
    return _turkce_sabit_dosyalari(root, [r"^src/arayuz/varlik_yukleme_paneli\.gd$"])


def tek17_ikinci_dogrulayici(root):
    """TEK-17: metin eksikleri tek araçtadır (metin_dogrula.py); ikinci metin doğrulayıcı/tarayıcı yok."""
    return [_rel(root, p) for p in sorted((root / "tools").glob("*.py")) if (root / "tools").is_dir()
            and re.search(r"metin.*(dogrula|tara)|anahtar.*dogrula", p.stem) and p.name != "metin_dogrula.py"]


def omr54_omurga_metni(root):
    """OMR-54: omurga*.gd ve dis_hat_kapisi.gd içinde Türkçe sabit 0."""
    return _turkce_sabit_dosyalari(root, [r"/omurga[^/]*\.gd$", r"/dis_hat_kapisi\.gd$"])


def ogr52_ogretici_sahnesi(root):
    """OGR-52: `rg -l 'ogretici_sahne|tutorial' src` → 0."""
    if not (root / "src").is_dir():
        return []
    return [_rel(root, p) for p in sorted((root / "src").rglob("*")) if p.is_file() and re.search(
        r"ogretici_sahne|tutorial", p.name + "\n" + (p.read_text(encoding="utf-8", errors="replace") if p.suffix in (".gd", ".tscn") else ""), re.I)]


def ogr56_ogretici_tus(root):
    """OGR-56: ogretici. satırlarında sabit tuş adı yok; tuş %s ile gelir."""
    csv_yol = root / "data/metin/metinler.csv"
    if not csv_yol.is_file():
        return []
    return [s.split(",", 1)[0] for s in csv_yol.read_text(encoding="utf-8-sig").splitlines()
            if s.startswith("ogretici.") and re.search(r"\b(F\d{1,2}|Esc|Ctrl|Shift|Alt|Space|Boşluk|Enter|Sol tık|Sağ tık)\b", s.split(",", 1)[-1])]


KURALLAR = {
    "TEK-21": tek21_yukleme_metni,
    "TEK-17": tek17_ikinci_dogrulayici,
    "AYR-51": ayr51_ayar_metni,
    "OMR-54": omr54_omurga_metni,
    "OGR-52": ogr52_ogretici_sahnesi,
    "OGR-56": ogr56_ogretici_tus,
    "HAN-49": han49_es_yurutme,
    "SRM-15": srm15_tek_cikis,
    "GRV-27": grv27_sanat_disi_yukleme,
    "YER-14": yer14_cogul,
    "YER-15": yer15_locale,
    "OMR-46": omr46_omurga_acilis,
    "OMR-51": omr51_bes_son,
    "SRM-16": srm16_steam,
    "YER-20": yer20_ikinci_tarayici,
    "SRM-22/23/24": srm22_24_magaza,
    "HAN-47": han47_hane_romans,
    "HFZ-30": hfz30_kalp_anahtari,
    "KLT-21": klt21_hitap_puani,
    "HAN-50": han50_hane_sahnesi,
    "SOY-31": soy31_baloncuk,
    "SOY-49/OZL-31/AYR-49": soy49_ozl31_ses_sayisi,
    "OZL-23": ozl23_kule_olayi,
    "OZL-28": ozl28_olay_sahnesi,
    "OZL-32": ozl32_gece_haritasi,
    "HFZ-22": hfz22_son_defter,
}

# Bölüm 41 (TEK) sınırları: bu bölümün commit'leri şu dosyalara dokunmaz (git geçmişi taraması).
TEK_DOKUNMAZ = {"TEK-30": "src/dunya/donma_yoneticisi.gd", "TEK-33": "src/koy/odun_zinciri.gd"}
# Bölüm sınırları (önek → yasak yol deseni): GRV commit'i src/koy/gorsel'e dokunmaz (GRV-29); GIR commit'i png eklemez (GIR-24).
ONEK_DOKUNMAZ = {"GRV-29": ("GRV", r"^src/koy/gorsel/"), "GIR-24": ("GIR", r"\.png$")}


def tek_commit_dosyalari(root: Path, onek: str = "TEK") -> list:
    """[(commit, konu, dosya)] — konusu <onek>-n içeren commit'lerin dokunduğu dosyalar; git yoksa boş."""
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
        elif satir.strip() and konu and re.search(r"\b" + onek + r"-\d+", konu):
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
    for madde, (onek, desen) in ONEK_DOKUNMAZ.items():
        sonuc[madde] = [f"{c} {d}" for c, _, d in tek_commit_dosyalari(root, onek) if re.search(desen, d)]
    # KLT-59: tester metin silmez/yazmaz — tester commit'i (konusu "(testx)", "tester" ya da "TUR-") metinler.csv'ye dokunmaz.
    sonuc["KLT-59"] = [f"{c} {d}" for c, k, d in tek_commit_dosyalari(root, "TUR")
                       + [x for x in tek_commit_dosyalari(root, r"[A-Z]{3}") if re.search(r"\(testx\)|tester", x[1], re.I)]
                       if d == "data/metin/metinler.csv"]
    roadmap = root / "ROADMAP_2.md"
    metin = roadmap.read_text(encoding="utf-8") if roadmap.is_file() else ""
    sonuc["TEK-32"] = tek32_chr011(metin)
    sonuc["GIR-18"] = gir18_orta_tus(metin)
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
