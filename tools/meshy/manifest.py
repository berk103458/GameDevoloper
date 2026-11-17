"""Asset planlarını tek makine okunur manifeste çevirir: `assets/meshy_manifest.json` (+ okunur `.csv`).

Kaynaklar (hepsi salt okunur):
  1. tools/model/meshy_uret.py VARLIKLAR — eski Meshy hattının ürettiği modeller (diskte → `mevcut`).
  2. production/eksikler/01-3d-modeller-ve-animasyon.md — hazır Meshy satırları (istemli).
  3. docs/EKSIK_ASSET_ENVANTERI.md — 3D tablo + ARY-05 tablosundaki 3B kimlikler (öncelik buradan).
  4. tools/meshy/plan_eki.json — kimlik eşlemesi, yalnız envanterde olanların istemleri.
  5. design/art/meshy/meshy-secim.json — CC0 Meshy topluluk seçimi (kredisiz indirme; üretilmez).
  6. Diskteki 3D dosyalar (glb/gltf/fbx/obj) ve Meshy hareket klipleri (`assets/model/hareket/*.res`).
  7. origin/claude/keen-cerf-42meo7 dalındaki 3D dosyalar (dal birleştirilmez; yalnız `git ls-tree`/`git show`).
  8. Yerel eski durum dosyası tools/model/durum.json (git'e girmez; varsa görev kimlikleri okunur).

Birleştirme kuralı: mevcut manifestteki üretim alanları (durum, görevler, dosya, sha256, kredi) asla
geriye yazılmaz; plandan düşen satır silinmez, `plan_disi` işaretlenir.
"""
import csv
import json
import os
import re
import subprocess
import sys
from pathlib import Path

import ortak
from ortak import KOK

sys.path.insert(0, os.path.join(KOK, "tools", "model"))
import chr_istemleri  # noqa: E402
import meshy_uret as eski_hat  # noqa: E402

ENVANTER = os.path.join(KOK, "docs", "EKSIK_ASSET_ENVANTERI.md")
EKSIKLER_01 = os.path.join(KOK, "production", "eksikler", "01-3d-modeller-ve-animasyon.md")
TOPLULUK = os.path.join(KOK, "design", "art", "meshy", "meshy-secim.json")
HAREKET_KLASORU = os.path.join(KOK, "assets", "model", "hareket")
ESKI_DAL = "origin/claude/keen-cerf-42meo7"
MODEL_UZANTI = (".glb", ".gltf", ".fbx", ".obj", ".blend")
TARANMAZ = (".godot", ".git", "node_modules", "work", "tools/art/ham", "tools/art/yedek")

URETIM_ALANLARI = ("durum", "meshy_task_id", "meshy_gorevleri", "dosya", "ek_dosyalar", "sha256",
                   "kredi_harcanan", "dogrulama", "onay_notu", "red_nedeni", "uretim_gunlugu", "hesap_plani_uretimde",
                   "_sayilan_gorev", "onceki_uretimler", "sha256_simdi", "meshy_uygun", "oyun_baglantisi")

HARICI_LISANS = [
    ("assets/esya/kaykit_", "KayKit (Kay Lousberg)", "CC0 — docs/credits/HAZIR_ASSET_ATIFLARI.md"),
    ("assets/cevre/megakit", "Quaternius Medieval Village MegaKit", "CC0 — docs/credits/HAZIR_ASSET_ATIFLARI.md"),
    ("assets/karakter/lowpo", "LOWPO Villager NPC (Standout 7)", "CC0 — docs/credits/HAZIR_ASSET_ATIFLARI.md"),
    ("assets/hayvan/", "Hazır hayvan paketi", "docs/credits/HAZIR_ASSET_ATIFLARI.md ve docs/asset_envanteri/UCRETSIZ_ASSET_TESLIM_2026-10-24.json"),
    ("assets/ph/", "Poly Haven", "CC0 — docs/credits/HAZIR_ASSET_ATIFLARI.md"),
    ("assets/kenney/", "Kenney", "CC0 — paket içindeki License.txt"),
    ("assets/animasyon/kaykit", "KayKit Character Animations", "CC0 — docs/credits/HAZIR_ASSET_ATIFLARI.md"),
]
ONCELIK_ESLE = {"yüksek": "yuksek", "yuksek": "yuksek", "orta": "orta", "düşük": "dusuk", "dusuk": "dusuk"}

# Görev 26 (15 Kasım 2026): Oyunda görünme sıklığına göre üretim öncelik sırası (1=Kapı, 2=Muhafız/Ev, 3=Köy sürekli, 4=Sık olay, 5=Nadir/Süs).
TAM_ANIMASYON_KARAKTERLERI = {
    "asker", "ciftci", "ciftci_kadin", "esnaf", "cocuk", "yasli",
    "muhafiz", "muhafiz_esi", "usta", "erkek_cirak", "kiz_cirak",
    "bey", "cavus", "haberci", "tahsildar", "dervis", "tekfur_askeri", "tekfur_elcisi", "turkmen_bey_adami",
    "aktar", "celep", "denetci", "kumasci",
}

KULLANIM_SIRASI = {
    # 1. Kapı nöbeti ekranı: kapı çevresi, nöbet kulübesi, meşale, kapıya her gün gelen ziyaretçi tipleri ve el eşyaları
    "kapi": (101, "1_kapi_nobeti"), "kapi_ic": (102, "1_kapi_nobeti"),
    "mesale": (103, "1_kapi_nobeti"), "mesale_el": (104, "1_kapi_nobeti"),
    "nobet_ocagi": (105, "1_kapi_nobeti"), "mizrak_sehpasi": (106, "1_kapi_nobeti"),
    "mizrak": (107, "1_kapi_nobeti"), "kalkan": (108, "1_kapi_nobeti"),
    "kilic": (109, "1_kapi_nobeti"), "yay": (110, "1_kapi_nobeti"),
    "fener": (111, "1_kapi_nobeti"), "sancak": (112, "1_kapi_nobeti"),
    "sur_2_palisat": (113, "1_kapi_nobeti"), "sur_3_tas": (114, "1_kapi_nobeti"),
    "kazik_cit": (115, "1_kapi_nobeti"), "araba": (116, "1_kapi_nobeti"),
    "cuval_yigini": (117, "1_kapi_nobeti"), "zar": (118, "1_kapi_nobeti"),
    "ciftci": (120, "1_kapi_nobeti"), "ciftci_kadin": (121, "1_kapi_nobeti"),
    "esnaf": (122, "1_kapi_nobeti"), "asker": (123, "1_kapi_nobeti"),
    "cocuk": (124, "1_kapi_nobeti"), "yasli": (125, "1_kapi_nobeti"),
    "usta": (126, "1_kapi_nobeti"), "nalbur": (127, "1_kapi_nobeti"),
    "silah_tuccari": (128, "1_kapi_nobeti"), "celep": (129, "1_kapi_nobeti"),
    "kumasci": (130, "1_kapi_nobeti"), "aktar": (131, "1_kapi_nobeti"),
    "el_torba": (140, "1_kapi_nobeti"), "el_heybe": (141, "1_kapi_nobeti"),
    "el_sepet": (142, "1_kapi_nobeti"), "el_sepet_buyuk": (143, "1_kapi_nobeti"),
    "el_asa": (144, "1_kapi_nobeti"), "el_degnek": (145, "1_kapi_nobeti"),
    "el_odun": (146, "1_kapi_nobeti"), "el_sandik": (147, "1_kapi_nobeti"),
    "el_cekic": (148, "1_kapi_nobeti"), "el_kamci": (149, "1_kapi_nobeti"),
    "el_kurk_bohca": (150, "1_kapi_nobeti"),

    # 2. Muhafızın kendisi, eşi ve evi (her akşam görülen sahne)
    "muhafiz": (201, "2_muhafiz_ve_evi"), "muhafiz_esi": (202, "2_muhafiz_ve_evi"),
    "muhafiz_odasi": (203, "2_muhafiz_ve_evi"), "yatak": (204, "2_muhafiz_ve_evi"),
    "masa": (205, "2_muhafiz_ve_evi"), "kasa": (206, "2_muhafiz_ve_evi"),
    "rahat_yatak": (207, "2_muhafiz_ve_evi"), "askilik": (208, "2_muhafiz_ve_evi"),
    "kutuphane": (209, "2_muhafiz_ve_evi"),

    # 3. Köy yönetimi ekranında her zaman görünen yapılar, tarlalar, tezgâhlar, hayvanlar ve köylüler
    "ev": (301, "3_koy_yonetimi_surekli"), "cadir": (302, "3_koy_yonetimi_surekli"),
    "tas_ev": (303, "3_koy_yonetimi_surekli"), "ambar": (304, "3_koy_yonetimi_surekli"),
    "firin": (305, "3_koy_yonetimi_surekli"), "degirmen": (306, "3_koy_yonetimi_surekli"),
    "tarla": (307, "3_koy_yonetimi_surekli"), "bostan": (308, "3_koy_yonetimi_surekli"),
    "kuyu": (309, "3_koy_yonetimi_surekli"), "dizili_taslar": (310, "3_koy_yonetimi_surekli"),
    "pazar_tezgahi": (311, "3_koy_yonetimi_surekli"), "kervansaray": (312, "3_koy_yonetimi_surekli"),
    "hizarhane": (313, "3_koy_yonetimi_surekli"), "odunluk": (314, "3_koy_yonetimi_surekli"),
    "tas_ocagi": (315, "3_koy_yonetimi_surekli"), "tas_yatagi": (316, "3_koy_yonetimi_surekli"),
    "atolye": (317, "3_koy_yonetimi_surekli"), "demirhane": (318, "3_koy_yonetimi_surekli"),
    "sifahane": (319, "3_koy_yonetimi_surekli"), "avci_cadiri": (320, "3_koy_yonetimi_surekli"),
    "agil": (321, "3_koy_yonetimi_surekli"), "ahir": (322, "3_koy_yonetimi_surekli"),
    "kirec_kuyusu": (323, "3_koy_yonetimi_surekli"), "demir_madeni": (324, "3_koy_yonetimi_surekli"),
    "demir_ocagi": (325, "3_koy_yonetimi_surekli"), "muhafiz_kislasi": (326, "3_koy_yonetimi_surekli"),
    "gozetleme_kulesi": (327, "3_koy_yonetimi_surekli"), "cozumleme_odasi": (328, "3_koy_yonetimi_surekli"),
    "ors": (330, "3_koy_yonetimi_surekli"), "firin_agzi": (331, "3_koy_yonetimi_surekli"),
    "dokuma_tezgahi": (332, "3_koy_yonetimi_surekli"), "divan_masasi": (333, "3_koy_yonetimi_surekli"),
    "divan_oturak": (334, "3_koy_yonetimi_surekli"), "zindan_kapisi": (335, "3_koy_yonetimi_surekli"),
    "sacak": (336, "3_koy_yonetimi_surekli"), "agac": (337, "3_koy_yonetimi_surekli"),
    "agac_02": (338, "3_koy_yonetimi_surekli"), "kaya": (339, "3_koy_yonetimi_surekli"),
    "kaya_02": (340, "3_koy_yonetimi_surekli"),
    "okuz": (345, "3_koy_yonetimi_surekli"), "koyun": (346, "3_koy_yonetimi_surekli"),
    "kopek": (347, "3_koy_yonetimi_surekli"), "inek": (348, "3_koy_yonetimi_surekli"),
    "koc": (349, "3_koy_yonetimi_surekli"), "beygir": (350, "3_koy_yonetimi_surekli"),
    "at": (351, "3_koy_yonetimi_surekli"), "keci": (352, "3_koy_yonetimi_surekli"),
    "deve": (353, "3_koy_yonetimi_surekli"),
    "erkek_cirak": (355, "3_koy_yonetimi_surekli"), "kiz_cirak": (356, "3_koy_yonetimi_surekli"),
    "balta": (360, "3_koy_yonetimi_surekli"), "orak": (361, "3_koy_yonetimi_surekli"),
    "kova": (362, "3_koy_yonetimi_surekli"), "kurek": (363, "3_koy_yonetimi_surekli"),
    "firin_kuregi": (364, "3_koy_yonetimi_surekli"), "su_kabi": (365, "3_koy_yonetimi_surekli"),
    "kirmen": (366, "3_koy_yonetimi_surekli"), "bakim_bezi": (367, "3_koy_yonetimi_surekli"),
    "anim_idle_nefes": (370, "3_koy_yonetimi_surekli"), "anim_idle_agirlik": (371, "3_koy_yonetimi_surekli"),
    "anim_idle_bakis": (372, "3_koy_yonetimi_surekli"), "anim_nobet": (373, "3_koy_yonetimi_surekli"),
    "anim_cekic_vurma": (374, "3_koy_yonetimi_surekli"), "anim_firin_kuregi": (375, "3_koy_yonetimi_surekli"),
    "anim_orak": (376, "3_koy_yonetimi_surekli"), "anim_isinma": (377, "3_koy_yonetimi_surekli"),
    "anim_kar_kureme": (378, "3_koy_yonetimi_surekli"), "anim_yagmur_yuru": (379, "3_koy_yonetimi_surekli"),
    "anim_buzulme": (380, "3_koy_yonetimi_surekli"), "anim_kos": (381, "3_koy_yonetimi_surekli"),
    "anim_otur": (382, "3_koy_yonetimi_surekli"),

    # 4. Sık görülen olay karakterleri ve olay varlıkları
    "bey": (401, "4_sik_olaylar"), "cavus": (402, "4_sik_olaylar"),
    "haberci": (403, "4_sik_olaylar"), "tahsildar": (404, "4_sik_olaylar"),
    "dervis": (405, "4_sik_olaylar"), "tekfur_elcisi": (406, "4_sik_olaylar"),
    "tekfur_askeri": (407, "4_sik_olaylar"), "turkmen_bey_adami": (408, "4_sik_olaylar"),
    "denetci": (409, "4_sik_olaylar"), "kurt": (410, "4_sik_olaylar"),
    "su_bendi": (411, "4_sik_olaylar"), "yanik_ev": (412, "4_sik_olaylar"),
    "kervan_yuku": (413, "4_sik_olaylar"), "hasta_cadiri": (414, "4_sik_olaylar"),
    "sonen_ates": (415, "4_sik_olaylar"),
    "anim_kavga": (420, "4_sik_olaylar"), "anim_saldir": (421, "4_sik_olaylar"),
    "anim_dus": (422, "4_sik_olaylar"), "anim_sinsi_yuru": (423, "4_sik_olaylar"),
    "anim_temkinli_bekle": (424, "4_sik_olaylar"),

    # 5. Nadir olaylar, tek seferlik karakterler, süs nesneleri en son
    "sorhan_karisi": (501, "5_nadir_ve_sus"), "kabus_golgesi": (502, "5_nadir_ve_sus"),
    "mezar": (510, "5_nadir_ve_sus"), "toplu_mezar": (511, "5_nadir_ve_sus"),
    "yemin_nesneleri": (512, "5_nadir_ve_sus"), "ahi_kusagi": (513, "5_nadir_ve_sus"),
    "davul_zurna": (514, "5_nadir_ve_sus"), "ilac_kutusu": (515, "5_nadir_ve_sus"),
    "kirik_kin": (516, "5_nadir_ve_sus"), "tezgah_ortusu": (520, "5_nadir_ve_sus"),
    "blok_ham": (521, "5_nadir_ve_sus"), "blok_iz": (522, "5_nadir_ve_sus"),
    "blok_bicim": (523, "5_nadir_ve_sus"), "blok_agiz": (524, "5_nadir_ve_sus"),
    "teslim_parcasi": (525, "5_nadir_ve_sus"), "hediye_bohcasi": (530, "5_nadir_ve_sus"),
    "iksir_sisesi": (531, "5_nadir_ve_sus"), "kisisel_iz": (532, "5_nadir_ve_sus"),
    "muhur": (533, "5_nadir_ve_sus"),
}


def kullanim_bilgisi(row):
    aid = row["asset_id"]
    if aid in KULLANIM_SIRASI:
        return KULLANIM_SIRASI[aid]
    if aid.startswith("chr_"):
        return (160, "1_kapi_nobeti")
    if aid.startswith("klip_eksik:"):
        hedef = aid.split(":", 1)[1]
        if hedef in ("ciftci", "ciftci_kadin", "esnaf", "asker"):
            return (390, "3_koy_yonetimi_surekli")
        return (550, "5_nadir_ve_sus")
    if row["tur"] in ("topluluk", "duzeltme", "harici") or aid.startswith(("klip:", "meshy_dosya:", "harici:", "dal:")):
        return (900, "mevcut_veya_harici")
    return (540, "5_nadir_ve_sus")


def _git(*arg):
    return subprocess.run(["git", "-C", KOK] + list(arg), capture_output=True, check=False)


def _json_oku(yol):
    with open(yol, encoding="utf-8") as f:
        return json.load(f)


def meshy_lisans_notu(ayar):
    plan = ayar.get("hesap_plani", "bilinmiyor")
    if plan == "ucretli":
        return "Meshy ücretli plan çıktısı: kullanıcıya ait, atıf gerekmez (Meshy Terms of Use 3.2)."
    if plan == "ucretsiz":
        return "Meshy ücretsiz plan çıktısı: CC BY 4.0; atıf zorunlu: 'Model created with Meshy – CC BY 4.0 License'."
    return ("Meshy çıktısı; üretim anındaki plan kayıtlı değil. Ücretli planda kullanıcıya ait, ücretsiz planda "
            "CC BY 4.0 (atıf zorunlu). Plan Ahmet'ten doğrulanmalı.")


def hedef_dosya(row, ayar):
    tv = ayar["tur_varsayilan"].get(row["tur"], {})
    klasor = tv.get("klasor")
    if not klasor:
        return ""
    if row["tur"] == "karakter" and row.get("iskelet"):
        return "%s/%s_yuru.glb" % (klasor, row["asset_id"])
    return "%s/%s.glb" % (klasor, row["asset_id"])


def kredi_hesapla(row, ayar, eski_durum=None):
    """Kalan tahmini kredi: biten görev aşamaları düşülür. Meshy'ye uygun olmayan satır 0."""
    if not row.get("meshy_uygun") or row.get("durum") in ortak.KILITLI_DURUMLAR or row.get("durum") == "reddedildi":
        return 0
    f = ayar["fiyat"]
    yapilan = {k for k, v in (row.get("meshy_gorevleri") or {}).items() if v and not str(v).startswith("BELIRSIZ")}
    toplam = 0
    if row["tur"] in ("karakter", "yapi", "nesne", "hayvan"):
        if "onizleme" not in yapilan:
            toplam += f["onizleme"].get(ayar["varsayilan"]["ai_model"], 20)
        if row.get("doku") and "doku" not in yapilan:
            toplam += f["doku_8k"] if ayar["varsayilan"].get("texture_resolution") == "8k" else f["doku_2k_4k"]
        if row.get("iskelet") and "iskelet" not in yapilan:
            toplam += f["iskelet"]
        for h in row.get("hareketler") or []:
            if "hareket:" + h not in yapilan:
                toplam += f["hareket"]
    elif row["tur"] == "animasyon":
        if row.get("iskelet_gerekli") and not row.get("iskelet_kaynagi") and "iskelet" not in yapilan:
            toplam += f["iskelet"]
        for h in row.get("hareketler") or [row["asset_id"]]:
            if "hareket:" + h not in yapilan:
                toplam += f["hareket"]
    return toplam


def _bos_satir(asset_id, tur, ad=""):
    return {
        "asset_id": asset_id, "ad": ad or asset_id, "tur": tur, "kaynak_plan": [], "plan_kimlikleri": [],
        "prompt": "", "prompt_ozeti": "", "poly_hedef": None, "boy_m": None, "olcu": "",
        "doku": False, "iskelet": False, "hareketler": [], "oncelik": "orta", "sira": 500, "kullanim_grubu": "5_nadir_ve_sus",
        "durum": "planli", "meshy_uygun": True, "uygun_degil_nedeni": "",
        "meshy_task_id": "", "meshy_gorevleri": {}, "dosya": "", "ek_dosyalar": [], "sha256": "",
        "kredi_tahmini": 0, "kredi_harcanan": 0, "kaynak": "", "lisans_notu": "",
        "topluluk_adayi": [], "notlar": [],
    }


def _oncelik_yukselt(row, yeni):
    yeni = ONCELIK_ESLE.get(str(yeni).strip().lower(), None)
    if yeni and ortak.ONCELIK_SIRASI[yeni] < ortak.ONCELIK_SIRASI.get(row["oncelik"], 1):
        row["oncelik"] = yeni


def _plan_ekle(row, kaynak, kimlik=None):
    if kaynak not in row["kaynak_plan"]:
        row["kaynak_plan"].append(kaynak)
    if kimlik and kimlik not in row["plan_kimlikleri"]:
        row["plan_kimlikleri"].append(kimlik)


def eksikler_01_oku():
    """`| `ad` | ... | `("tur", KARAKTER + "istem", doku, iskelet, boy, poli)` |` satırlarını ve kod bloğunu okur."""
    metin = Path(EKSIKLER_01).read_text(encoding="utf-8")
    kalip = re.compile(r'\("(karakter|yapi|nesne)",\s*(KARAKTER[^"]*?\+\s*)?"((?:[^"\\]|\\.)*)",\s*(True|False),\s*(True|False),\s*([\d.]+),\s*(\d+)\)')
    sonuc = []
    oncelik = "orta"
    for satir in metin.splitlines():
        if satir.startswith("## "):
            oncelik = "yuksek" if "(Ö1)" in satir else "orta"
        m = kalip.search(satir)
        if not m:
            continue
        ad_m = re.match(r"\|\s*`([a-z_0-9]+)`", satir) or re.match(r'\s*"([a-z_0-9]+)"\s*:', satir)
        if not ad_m:
            continue
        sonuc.append({
            "ad": ad_m.group(1), "tur": m.group(1), "karakter_onekli": bool(m.group(2)),
            "zirhsiz": bool(m.group(2) and "replace" in m.group(2)), "istem": m.group(3),
            "doku": m.group(4) == "True", "iskelet": m.group(5) == "True",
            "boy": float(m.group(6)), "poly": int(m.group(7)), "oncelik": oncelik,
        })
    return sonuc


def envanter_oku():
    """3D tablo: [(kimlik, tanım, ölçü)], ARY-05: {kimlik: (tür, öncelik)}."""
    metin = Path(ENVANTER).read_text(encoding="utf-8")
    bolum = metin.split("## 3D assetler — açık üretim ihtiyaçları", 1)[1].split("### Diyalog ve Anlatı 2D", 1)[0]
    tablo = []
    for s in bolum.splitlines():
        if s.startswith("| `"):
            p = [x.strip() for x in s.split("|")]
            tablo.append((p[1].strip("`"), p[2], p[3]))
    ary = {}
    h = metin.split("## H. ROADMAP 2 (ARY-05)", 1)[1]
    for s in h.splitlines():
        if s.startswith("| ") and not s.startswith("| ID") and not s.startswith("|---"):
            p = [x.strip() for x in s.split("|")]
            if len(p) > 8 and ("3B" in p[4] or "glTF" in p[4]):
                ary[p[1]] = (p[4], p[7], p[3])
    return tablo, ary


def diskteki_modeller():
    bulunan = []
    for kok, klasorler, dosyalar in os.walk(KOK):
        goreli = os.path.relpath(kok, KOK).replace(os.sep, "/")
        if any(goreli == t or goreli.startswith(t + "/") for t in TARANMAZ):
            klasorler[:] = []
            continue
        for ad in sorted(dosyalar):
            if ad.lower().endswith(MODEL_UZANTI):
                bulunan.append((goreli + "/" + ad).lstrip("./"))
    return sorted(bulunan)


def eski_dal_modelleri():
    """[(yol, sha256)] — dal yoksa boş liste ve uyarı."""
    r = _git("ls-tree", "-r", "--name-only", ESKI_DAL)
    if r.returncode != 0:
        return None
    sonuc = []
    for yol in r.stdout.decode().splitlines():
        if yol.lower().endswith(MODEL_UZANTI):
            veri = _git("show", "%s:%s" % (ESKI_DAL, yol)).stdout
            sonuc.append((yol, ortak.sha256_bayt(veri)))
    return sonuc


def eski_durum_oku():
    if os.path.isfile(ortak.ESKI_DURUM):
        try:
            return _json_oku(ortak.ESKI_DURUM)
        except (OSError, json.JSONDecodeError):
            return {}
    return {}


def _harici_kaynak(yol):
    for on, kaynak, lisans in HARICI_LISANS:
        if yol.startswith(on):
            return kaynak, lisans
    return "Bilinmeyen kaynak", "Lisans kaydı bulunamadı — docs/credits ve envanter teslim kaydına bakılmalı"


def kur(ayar=None, eski_dal=True):
    """Planlardan + diskten taze manifest satırlarını kurar (mevcut manifestle birleştirmeden)."""
    ayar = ayar or ortak.ayarlar_oku()
    eki = _json_oku(ortak.PLAN_EKI)
    eski_durum = eski_durum_oku()
    lisans = meshy_lisans_notu(ayar)
    satirlar = {}
    disk = diskteki_modeller()
    disk_kume = set(disk)
    sha_disk = {}

    def sha(yol):
        if yol not in sha_disk:
            sha_disk[yol] = ortak.sha256_dosya(os.path.join(KOK, yol))
        return sha_disk[yol]

    # 1) Eski Meshy hattı (tools/model/meshy_uret.py)
    for ad, (tur, istem, doku, iskelet, boy, poly) in eski_hat.VARLIKLAR.items():
        r = _bos_satir(ad, "karakter" if tur == "karakter" else ("yapi" if tur == "yapi" else "nesne"))
        if ad == "okuz":
            r["tur"] = "hayvan"
        r.update(prompt=eski_hat.STIL + istem, doku=doku, iskelet=iskelet, boy_m=boy or None, poly_hedef=poly,
                 kaynak="Meshy", lisans_notu=lisans, meshy_model="meshy-6-lite (eski hat)")
        if ad.startswith("chr_"):
            r["ad"] = "%s (%s)" % (chr_istemleri.CHR[ad][0], ad)
            r["hareketler"] = chr_istemleri.hareket_listesi(ad)
        _plan_ekle(r, "tools/model/meshy_uret.py#VARLIKLAR", ad)
        yol = "assets/model/%s/%s" % (tur, ad + ("_yuru.glb" if iskelet else ".glb"))
        if yol in disk_kume:
            r.update(durum="mevcut", dosya=yol, sha256=sha(yol))
        d = eski_durum.get(ad) or {}
        gorev = {k: d[k] for k in ("onizleme", "doku", "iskelet") if d.get(k)}
        if gorev:
            r["meshy_gorevleri"] = gorev
            r["meshy_task_id"] = gorev.get("doku") or gorev.get("onizleme", "")
            r["notlar"].append("görev kimlikleri yerel tools/model/durum.json'dan okundu")
        satirlar[ad] = r

    # 7) Eski dal: festive'de olmayan Meshy modeli (ör. koyun) mevcut sayılır
    dal = eski_dal_modelleri() if eski_dal else []
    if dal is None:
        dal = []
        dal_uyari = "%s okunamadı (git fetch origin claude/keen-cerf-42meo7 gerekli)" % ESKI_DAL
    else:
        dal_uyari = ""
    dal_sha = {}
    for yol, s in dal:
        dal_sha.setdefault(s, []).append(yol)
    dal_meshy_istem = {}
    r_git = _git("show", "%s:tools/model/meshy_uret.py" % ESKI_DAL)
    if r_git.returncode == 0:
        for m in re.finditer(r'^\s*"([a-z_0-9]+)":\s*\("(karakter|yapi|nesne)",\s*"((?:[^"\\]|\\.)*)"', r_git.stdout.decode(), re.M):
            dal_meshy_istem[m.group(1)] = m.group(3)

    # 2) production/eksikler/01
    for s in eksikler_01_oku():
        r = satirlar.get(s["ad"]) or _bos_satir(s["ad"], s["tur"])
        if r["durum"] == "planli" and not r["prompt"]:
            onek = ayar["karakter_oneki"] if s["karakter_onekli"] else ""
            if s["zirhsiz"]:
                onek = onek.replace("No armour plates, no horned helmets. ", "")
            r.update(prompt=ayar["stil_oneki"] + onek + s["istem"], doku=s["doku"], iskelet=s["iskelet"],
                     boy_m=s["boy"] or None, poly_hedef=s["poly"], kaynak="Meshy", lisans_notu=lisans)
            r["oncelik"] = s["oncelik"]
        _plan_ekle(r, "production/eksikler/01-3d-modeller-ve-animasyon.md#" + s["ad"], s["ad"])
        satirlar[s["ad"]] = r

    # 4) plan_eki.json assetleri (üstüne yazar)
    for aid, alan in eki["assetler"].items():
        yeni = aid not in satirlar
        r = satirlar.get(aid) or _bos_satir(aid, alan.get("tur", "nesne"))
        kilitli = r["durum"] != "planli"
        for k in ("ad", "tur", "olcu"):
            if k in alan:
                r[k] = alan[k]
        if not kilitli:
            if "boy_m" in alan:
                r["boy_m"] = alan["boy_m"]
            if "poly" in alan:
                r["poly_hedef"] = alan["poly"]
            if "doku" in alan:
                r["doku"] = alan["doku"]
            if "iskelet" in alan:
                r["iskelet"] = alan["iskelet"]
            if "prompt" in alan:
                onek = ayar["karakter_oneki"] if r["tur"] == "karakter" else ""
                if alan.get("karakter_oneki_zirhsiz"):
                    onek = onek.replace("No armour plates, no horned helmets. ", "")
                r["prompt"] = ayar["stil_oneki"] + onek + alan["prompt"]
            if "kitaplik" in alan:
                r["kitaplik"] = alan["kitaplik"]
        if "oncelik" in alan:
            if yeni:
                r["oncelik"] = alan["oncelik"]
            else:
                _oncelik_yukselt(r, alan["oncelik"])
        if alan.get("not"):
            r["notlar"].append(alan["not"])
        satirlar[aid] = r

    # Tür varsayılanları (yalnız planlı satırlarda doldurulur)
    for r in satirlar.values():
        if r["durum"] != "planli":
            continue
        tv = ayar["tur_varsayilan"].get(r["tur"], {})
        if r["tur"] in ("karakter", "yapi", "nesne", "hayvan"):
            if r["asset_id"] not in eski_hat.VARLIKLAR and not any("01-3d" in k for k in r["kaynak_plan"]):
                r["doku"] = tv.get("doku", True)
                if "iskelet" not in eki["assetler"].get(r["asset_id"], {}):
                    r["iskelet"] = tv.get("iskelet", False)
            r["poly_hedef"] = r["poly_hedef"] or tv.get("poly")
            if r["tur"] == "karakter" and r["iskelet"]:
                if r["asset_id"] in TAM_ANIMASYON_KARAKTERLERI:
                    r["hareketler"] = list(ayar["karakter_hareketleri"])
                else:
                    r["hareketler"] = ["bekle", "konus"]
            r["kaynak"] = r["kaynak"] or "Meshy"
            r["lisans_notu"] = lisans
        elif r["tur"] == "animasyon":
            r.update(kaynak="Meshy (animasyon kitaplığı)", lisans_notu=lisans, iskelet_gerekli=False,
                     iskelet_kaynagi="", hareketler=[r["asset_id"]])
            r["notlar"].append("Paylaşımlı klip: referans iskelete (ayarlar 'referans_iskelet') bir kez uygulanır; "
                               "her karaktere ayrı uygulanırsa kredi × karakter sayısı. Kitaplık anahtarı ilk gerçek "
                               "çalıştırmada ücretsiz /v1/animations/library ile doğrulanır.")
        poly = r.get("poly_hedef")
        lo, hi = ayar["varsayilan"]["poly_sinir"]
        if poly and not lo <= poly <= hi:
            r["notlar"].append("poly hedefi %d, smart-topology sınırına (%d–%d) çekilecek" % (poly, lo, hi))

    # Eski daldaki fazladan Meshy modelleri (koyun) → mevcut (dalda)
    for s, yollar in dal_sha.items():
        for yol in yollar:
            if not yol.startswith("assets/model/") or yol in disk_kume:
                continue
            ad = os.path.splitext(os.path.basename(yol))[0].replace("_yuru", "")
            r = satirlar.get(ad) or _bos_satir(ad, "hayvan" if ad in ("koyun", "keci", "at", "deve", "kopek", "okuz") else "nesne")
            r.update(durum="mevcut", dosya="git:%s:%s" % (ESKI_DAL.replace("origin/", ""), yol), sha256=s,
                     kaynak="Meshy", lisans_notu=lisans, meshy_model="meshy-6-lite (eski hat, keen-cerf)")
            if ad in dal_meshy_istem and not r["prompt"]:
                r["prompt"] = eski_hat.STIL + dal_meshy_istem[ad]
            r["notlar"].append("Yalnız eski dalda: almak için `git show %s:%s > %s` (dal birleştirilmez)." % (ESKI_DAL, yol, yol))
            _plan_ekle(r, "%s:tools/model/meshy_uret.py#VARLIKLAR" % ESKI_DAL, ad)
            satirlar[ad] = r

    # 3) Envanter eşlemesi
    tablo, ary = envanter_oku()
    eslenmeyen = []
    otomatik = []
    for kimlik, tanim, olcu in tablo:
        hedefler = eki["envanter"].get(kimlik)
        if hedefler is None:
            eslenmeyen.append(kimlik)
            continue
        for h in hedefler:
            if h.startswith("otomatik:"):
                otomatik.append(kimlik)
            _envanter_bagla(satirlar, h, kimlik, tanim, olcu, ary.get(kimlik), lisans, "docs/EKSIK_ASSET_ENVANTERI.md#3D")
    for kimlik, (tur, oncelik, ne) in ary.items():
        hedefler = eki["envanter"].get(kimlik)
        if hedefler is None:
            eslenmeyen.append(kimlik)
            continue
        for h in hedefler:
            _envanter_bagla(satirlar, h, kimlik, ne, "", (tur, oncelik, ne), lisans, "docs/EKSIK_ASSET_ENVANTERI.md#ARY-05")

    # Envanter kimliği yalnız aynı alanı tekrar etmesin: ölçü yoksa doldur
    for r in satirlar.values():
        if r["tur"] in ("karakter", "yapi", "nesne", "hayvan") and r["durum"] == "planli" and not r["prompt"]:
            r["meshy_uygun"] = False
            r["uygun_degil_nedeni"] = "istem yazılmamış (plan_eki.json'a eklenmeli)"

    # 5) Topluluk seçimi (kredisiz)
    topluluk = _json_oku(TOPLULUK)
    kod_ad = {}
    for m in topluluk:
        aid = "topluluk_" + m["kod"].lower()
        r = _bos_satir(aid, "topluluk", m["ad"])
        r.update(meshy_uygun=False, uygun_degil_nedeni="Meshy topluluk modeli: üretilmez, hesapla elle indirilir (tools/varlik/meshy_esle.py)",
                 kaynak="Meshy topluluk", lisans_notu="CC0 (lisans model başına Meshy API'den okundu — design/art/meshy/meshy-koy-varliklari.md)",
                 poly_hedef=m.get("ucgen"), olcu=m.get("yer", ""), topluluk_url=m.get("url", ""),
                 hedef_yol="assets/meshy/%s/%s" % (m["bolum"], m["dosya"]))
        _plan_ekle(r, "design/art/meshy/meshy-secim.json#" + m["kod"], m["kod"])
        yol = r["hedef_yol"]
        if yol in disk_kume:
            r.update(durum="mevcut", dosya=yol, sha256=sha(yol))
        satirlar[aid] = r
        kod_ad[m["kod"]] = aid
    for aid, kodlar in eki.get("topluluk_adayi", {}).items():
        if aid.startswith("_") or aid not in satirlar:
            continue
        satirlar[aid]["topluluk_adayi"] = [k for k in kodlar if k in kod_ad]

    # 6) Diskteki diğer 3D dosyalar ve Meshy hareket klipleri → mevcut
    bilinen = {r["dosya"] for r in satirlar.values() if r["dosya"]}
    for yol in disk:
        if yol in bilinen:
            continue
        if yol.startswith("assets/model/"):
            ad = os.path.splitext(os.path.basename(yol))[0]
            r = _bos_satir("meshy_dosya:" + ad, "harici", ad)
            r.update(kaynak="Meshy (eski hat, plan satırı yok)", lisans_notu=lisans)
        else:
            kaynak, lis = _harici_kaynak(yol)
            r = _bos_satir("harici:" + os.path.splitext(yol)[0], "harici", os.path.basename(yol))
            r.update(kaynak=kaynak, lisans_notu=lis)
        r.update(durum="mevcut", meshy_uygun=False, uygun_degil_nedeni="mevcut dosya", dosya=yol, sha256=sha(yol))
        if yol.startswith("tools/") or yol.startswith("tests/") or yol.startswith("prototypes/"):
            r["notlar"].append("oyun asset klasörü dışında")
        satirlar[r["asset_id"]] = r
    for yol, s in dal:
        if yol in disk_kume or yol.startswith("assets/model/"):
            continue
        es = [x for x in dal_sha.get(s, []) if x in disk_kume]
        kaynak, lis = _harici_kaynak(yol)
        r = _bos_satir("dal:" + os.path.splitext(yol)[0], "harici", os.path.basename(yol))
        r.update(durum="mevcut", meshy_uygun=False, uygun_degil_nedeni="yalnız eski dalda bulunan dosya",
                 dosya="git:%s:%s" % (ESKI_DAL.replace("origin/", ""), yol), sha256=s, kaynak=kaynak, lisans_notu=lis)
        if es:
            r["notlar"].append("aynı içerik festive'de: " + ", ".join(es))
        satirlar[r["asset_id"]] = r

    hareketler = ayar["karakter_hareketleri"]
    klip_var = {}
    if os.path.isdir(HAREKET_KLASORU):
        for ad in sorted(os.listdir(HAREKET_KLASORU)):
            if not ad.endswith(".res"):
                continue
            kok = ad[:-4]
            h = kok.rsplit("_", 1)[-1]
            karakter = kok[: -len(h) - 1]
            klip_var.setdefault(karakter, set()).add(h)
            yol = "assets/model/hareket/" + ad
            r = _bos_satir("klip:" + kok, "animasyon", "%s — %s" % (karakter, h))
            r.update(durum="mevcut", meshy_uygun=False, uygun_degil_nedeni="mevcut dosya", dosya=yol, sha256=sha(yol),
                     kaynak="Meshy (animasyon kitaplığı, eski hat)", lisans_notu=lisans, hareketler=[h])
            satirlar[r["asset_id"]] = r
    karakterler = [r for r in satirlar.values() if r["tur"] == "karakter" and r["durum"] == "mevcut" and r.get("iskelet")]
    for kr in sorted(karakterler, key=lambda x: x["asset_id"]):
        ad = kr["asset_id"]
        eksik = [h for h in hareketler if h not in klip_var.get(ad, set())]
        if not eksik:
            continue
        r = _bos_satir("klip_eksik:" + ad, "animasyon", "%s eksik klipler" % ad)
        r.update(hareketler=eksik, hedef_karakter=ad, iskelet_gerekli=True, kaynak="Meshy (animasyon kitaplığı)",
                 lisans_notu=lisans, oncelik="orta")
        iskelet = (kr.get("meshy_gorevleri") or {}).get("iskelet")
        r["iskelet_kaynagi"] = iskelet or ""
        if not iskelet:
            r["notlar"].append("İskelet görevi kimliği repoda yok (tools/model/durum.json yalnız eski makinede). "
                               "Yeniden iskelet 5 kredi ve girdi olarak dokulu statik model ister; statik model "
                               "repoya girmediği için ön koşul eksik olabilir.")
        _plan_ekle(r, "docs/EKSIK_ASSET_ENVANTERI.md#3D (eksik klipler)", "klip:" + ad)
        for kimlik in otomatik:
            if ad in _klip_satiri_karakterleri(kimlik):
                _plan_ekle(r, "docs/EKSIK_ASSET_ENVANTERI.md#3D", kimlik)
        satirlar[r["asset_id"]] = r

    for r in satirlar.values():
        r["prompt_ozeti"] = ortak.istem_ozeti(r["prompt"]) if r["prompt"] else ""
        if r["meshy_uygun"] and r["durum"] == "planli" and r["tur"] != "animasyon" and not r["dosya"]:
            hedef = hedef_dosya(r, ayar)
            if hedef and os.path.exists(os.path.join(KOK, hedef)):
                r.update(durum="mevcut", dosya=hedef, sha256=sha(hedef))
                r["notlar"].append("hedef dosya diskte bulundu; üretilmez")
        r["hedef_dosya"] = hedef_dosya(r, ayar) if r["meshy_uygun"] else r.get("hedef_yol", "")
        r["sira"], r["kullanim_grubu"] = kullanim_bilgisi(r)
    return satirlar, {"eslenmeyen_envanter": sorted(set(eslenmeyen)), "eski_dal_uyari": dal_uyari}


def _klip_satiri_karakterleri(kimlik):
    """'chr_002, 003, 008, 011–030' ya da 'asker, ciftci, …' biçimli envanter kimliğini karakter adlarına açar."""
    adlar = set()
    for parca in (p.strip() for p in kimlik.split(",")):
        aralik = re.fullmatch(r"(?:chr_)?(\d{3})\s*[–-]\s*(\d{3})", parca)
        if aralik:
            adlar.update("chr_%03d" % n for n in range(int(aralik.group(1)), int(aralik.group(2)) + 1))
        elif re.fullmatch(r"(?:chr_)?\d{3}", parca):
            adlar.add("chr_" + parca[-3:])
        elif parca:
            adlar.add(parca)
    return adlar


def _envanter_bagla(satirlar, hedef, kimlik, tanim, olcu, ary_satiri, lisans, kaynak):
    oncelik = ary_satiri[1] if ary_satiri else None
    if hedef.startswith("otomatik:"):
        return
    if hedef.startswith("meshy_disi:"):
        aid = "meshy_disi:" + kimlik
        r = satirlar.get(aid) or _bos_satir(aid, "duzeltme", kimlik)
        r.update(meshy_uygun=False, uygun_degil_nedeni=hedef.split(":", 1)[1], olcu=olcu or r["olcu"])
        r["notlar"] = r["notlar"] or [tanim]
        _plan_ekle(r, kaynak, kimlik)
        if oncelik:
            _oncelik_yukselt(r, oncelik)
        satirlar[aid] = r
        return
    if hedef.startswith("mevcut:"):
        ad = hedef.split(":", 1)[1]
        r = satirlar[ad]
        _plan_ekle(r, kaynak, kimlik)
        r["notlar"].append("%s bu dosyaya bağlı; yeniden üretim yalnız `uret --yeniden %s` ile (açık karar)." % (kimlik, ad))
        return
    r = satirlar.get(hedef)
    if r is None:
        r = _bos_satir(hedef, "nesne", tanim)
        r.update(meshy_uygun=False, uygun_degil_nedeni="plan_eki.json'da kaydı yok")
        satirlar[hedef] = r
    _plan_ekle(r, kaynak, kimlik)
    if olcu and not r["olcu"]:
        r["olcu"] = olcu
    if oncelik:
        _oncelik_yukselt(r, oncelik)


def birlestir(taze, eski):
    """Eski manifestteki üretim alanlarını korur; plandan düşen satırı silmez."""
    eski_satir = {r["asset_id"]: r for r in (eski or {}).get("assetler", [])}
    for aid, r in taze.items():
        o = eski_satir.get(aid)
        if not o:
            continue
        if o.get("durum") in ("uretiliyor", "uretildi", "onaylandi", "reddedildi") or o.get("meshy_gorevleri"):
            for k in URETIM_ALANLARI:
                if k in o:
                    r[k] = o[k]
            if o.get("prompt") and o.get("prompt") != r.get("prompt"):
                r.setdefault("notlar", []).append("Plan istemi değişti; üretimde kullanılan istem korundu.")
                r["prompt"] = o["prompt"]
                r["prompt_ozeti"] = o.get("prompt_ozeti", r["prompt_ozeti"])
    for aid, o in eski_satir.items():
        if aid not in taze:
            o["plan_disi"] = True
            taze[aid] = o
    return taze


def tekrar_istemleri(satirlar):
    """Aynı istem özetine sahip, ikisi de üretilecek satırlar (aynı asset'i iki kez üretme riski)."""
    gorulen = {}
    for r in satirlar.values():
        if r.get("prompt_ozeti") and r["meshy_uygun"]:
            gorulen.setdefault(r["prompt_ozeti"], []).append(r["asset_id"])
    return {k: v for k, v in gorulen.items() if len(v) > 1}


def sirala(satirlar):
    tur_sira = {"karakter": 0, "yapi": 1, "hayvan": 2, "nesne": 3, "animasyon": 4, "topluluk": 5, "duzeltme": 6, "harici": 7}
    for r in satirlar.values():
        if "sira" not in r or "kullanim_grubu" not in r:
            r["sira"], r["kullanim_grubu"] = kullanim_bilgisi(r)
    return sorted(satirlar.values(), key=lambda r: (r.get("sira", 500), ortak.ONCELIK_SIRASI.get(r["oncelik"], 1), tur_sira.get(r["tur"], 9), r["asset_id"]))


def oku():
    if os.path.isfile(ortak.MANIFEST):
        with open(ortak.MANIFEST, encoding="utf-8") as f:
            return json.load(f)
    return None


def manifest_nesnesi(satirlar, ayar, ek_bilgi):
    for r in satirlar.values():
        r["kredi_tahmini"] = kredi_hesapla(r, ayar)
    return {
        "_aciklama": "Kapı Muhafızı Meshy üretim manifesti. Üreten: tools/meshy/meshy_hat.py manifest. Elle düzenlemeyin; "
                     "durum değişikliği için meshy_hat.py onayla/reddet kullanın. Ayrıntı: docs/MESHY_URETIM_SISTEMI.md",
        "surum": 1,
        "fiyat_kaynagi": ayar["fiyat_kaynagi"],
        "hesap_plani": ayar.get("hesap_plani", "bilinmiyor"),
        "eslenmeyen_envanter": ek_bilgi.get("eslenmeyen_envanter", []),
        "uyarilar": [x for x in [ek_bilgi.get("eski_dal_uyari")] if x],
        "assetler": sirala(satirlar),
    }


def yaz(nesne):
    ortak.json_yaz_atomik(ortak.MANIFEST, nesne)
    alanlar = ["sira", "kullanim_grubu", "asset_id", "ad", "tur", "durum", "oncelik", "meshy_uygun", "kredi_tahmini", "kredi_harcanan",
               "poly_hedef", "boy_m", "doku", "iskelet", "hareketler", "meshy_task_id", "dosya", "sha256",
               "kaynak", "plan_kimlikleri", "kaynak_plan", "topluluk_adayi", "uygun_degil_nedeni", "prompt"]
    with ortak.yazi_ac_atomik(ortak.MANIFEST_CSV) as f:
        w = csv.writer(f, lineterminator="\n")
        w.writerow(alanlar)
        for r in nesne["assetler"]:
            w.writerow([";".join(map(str, r.get(a) or [])) if isinstance(r.get(a), list) else r.get(a, "") for a in alanlar])


def _cilalama_olculeri_bagla(satirlar):
    yol = os.path.join(KOK, "data", "varlik_olculeri.json")
    if not os.path.isfile(yol):
        return
    veri = _json_oku(yol).get("varliklar", {})
    kod_olcu = {}
    for ad, cfg in veri.items():
        if isinstance(cfg, dict) and cfg.get("kod"):
            kod_olcu[cfg["kod"]] = cfg
    for r in satirlar.values():
        cfg = None
        if r.get("tur") == "topluluk" and r.get("plan_kimlikleri"):
            cfg = kod_olcu.get(r["plan_kimlikleri"][0])
        elif r["asset_id"] in veri and isinstance(veri[r["asset_id"]], dict):
            cfg = veri[r["asset_id"]]
        if not cfg:
            continue
        if cfg.get("hedef_boy_m") and r.get("boy_m") is None:
            r["boy_m"] = float(cfg["hedef_boy_m"])
        if not r.get("olcu") and isinstance(cfg.get("azami_ayak_m"), list) and len(cfg["azami_ayak_m"]) >= 2 and r.get("boy_m"):
            ax, az = cfg["azami_ayak_m"][0], cfg["azami_ayak_m"][1]
            r["olcu"] = ("%.1f × %.1f × %.1f m" % (ax, float(r["boy_m"]), az)).replace(".", ",")
        if cfg.get("devre_disi"):
            r["oyun_baglantisi"] = "devre_disi"
            r["durum"] = "reddedildi"
            r["red_nedeni"] = cfg.get("neden", "Cilalama tekilleştirme kararı")
        elif cfg.get("bag"):
            r["oyun_baglantisi"] = cfg["bag"]


def guncelle(eski_dal=True):
    ayar = ortak.ayarlar_oku()
    taze, ek = kur(ayar, eski_dal=eski_dal)
    birlesik = birlestir(taze, oku())
    _cilalama_olculeri_bagla(birlesik)
    nesne = manifest_nesnesi(birlesik, ayar, ek)
    return nesne, tekrar_istemleri(birlesik)
