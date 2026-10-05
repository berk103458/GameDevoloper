"""karakterler/CHR_*.md sayfalarını içerik hattının KARAKTERLER biçimine çevirir.

Okunan alanlar (sayfa şablonu `karakterler/CHR_002.md`):
- OKU.md satırı → ad, sınıf
- Tag_Array → cinsiyet (yedek model ve portre için)
- Spawn_Koşulu "Tur > N" → en erken gece N (bar eşiği oyunun barlarıyla eşleşmediği için alınmaz)
- Sadakat_Fraksiyonu → tehlikeli mi (haramiler, ayaktakımı, divan): karar etkilerini belirler
- Persona_Maskesi + Görsel_Hata → kapıya varış anlatısı (bekçinin gördüğü)
- Düğüm 00 NPC Replik → açılış sözü
- Dal 1/2/3 düğümleri → soru ağacı: seçenek metni = soru, hedef düğümün NPC repliği = cevap,
  hedefin seçenekleri = takip soruları. Tansiyon, ipucu ve bayrak koşulları oyunda yok: koşullu
  dallar düz takip sorusu olur; "Final_Ret" ve "Karar_Menusu" dallanmaz.
BÖLÜM 5 (gecikmeli sonuçlar, doğan karakterler) henüz oyuna bağlanmadı.
"""
import os
import re

KOK = os.path.normpath(os.path.join(os.path.dirname(__file__), "..", ".."))
KLASOR = os.path.join(KOK, "karakterler")
SINIF = {"Asker": "asker", "Esnaf": "esnaf", "Çiftçi": "ciftci"}
TEHLIKE = ("Harami", "Ayaktakım", "Divan")

# Karar etkileri (bar sırası: Halk, Soylular, Tüccarlar, Ordu). Sınıfın kabul katkısı + niyet.
SINIF_KABUL = {"asker": [0, 0, 0, 1], "esnaf": [0, 0, 1, 0], "ciftci": [1, 0, 0, 0]}
NIYET = {
    # Tehlikeli: içeri alınırsa sırrı köye zarar verir; ret ve kışla güveni artırır.
    True: dict(kabul=[-1, 0, 0, -2], ret=[0, 0, 0, 1], rusvet=[-1, 0, 1, -1], kisla=[0, 0, 0, 2]),
    # Masum (kaçak, borçlu, utanan): ret Halkı kırar; kışla haksızlık.
    False: dict(kabul=[0, 0, 0, 0], ret=[-1, 0, 0, 0], rusvet=[-1, 0, 1, 0], kisla=[-1, 0, 0, 1]),
}
AZAMI_SORU = 6

# Elde taşınan eşyalar (sayfadaki Obje_2_Yük ve Yüz_ve_Postür'den): kimlik → [(eşya, "sag"/"sol")].
# Meshy modelinde olmayan ya da sırtta kalan yük ele verilir; biçimler src/dunya/el_esyasi.gd.
# Modelde zaten olanlar (CHR_008 sepeti, CHR_011 sırt çuvalı, CHR_015 yabası) eklenmez.
EL_ESYALARI = {
    "chr_001": [("odun", "sag")],                       # ıslak sazla sarılı meşe kütüğü bağı
    "chr_002": [("torba", "sag")],                      # kenevir torba (zehirli tohum)
    "chr_003": [("sepet", "sol"), ("cekic", "sag")],    # kömür sepeti, kalaycı aleti
    "chr_004": [("kamci", "sag"), ("kurk", "sol")],     # at kamçısı, kürk dengi
    "chr_005": [("heybe", "sag")],                      # kıl heybe (sol kol sargıda)
    "chr_006": [("sepet_buyuk", "sag")],                # saman dolu saz sepet
    "chr_007": [("sandik", "sol")],                     # divan sandığı
    "chr_008": [("asa", "sag")],                        # ardıç baston (sepet modelde)
    "chr_009": [("heybe", "sol")],                      # kına heybesi
    "chr_010": [("heybe", "sag")],                      # kıl hurç
    # chr_011: harman çuvalı sayfada da sırtta; modelde var, ele eşya verilmez.
    "chr_012": [("sepet_buyuk", "sag")],                # asma küfesi
    "chr_013": [("degnek", "sag"), ("testi", "sol")],   # meşe değnek, tohum testisi
    "chr_014": [("degnek", "sag")],                     # çoban değneği
    "chr_015": [("sepet", "sag")],                      # fide sepeti (yaba modelde)
    "chr_016": [("odun", "sag")],                       # aşı çubuğu demeti
    "chr_017": [("heybe", "sag")],                      # keçe heybe
    "chr_018": [("capa", "sag"), ("kabak", "sol")],     # çapa, su kabağı
    "chr_019": [("kazma", "sag"), ("cubuk", "sol")],    # kör kazma, su ölçeği
    "chr_020": [("kalbur", "sol")],                     # kalbur kasnağı
    "chr_021": [("bohca", "sol")],                      # yol çıkını
    "chr_022": [("bohca", "sol")],                      # ot bohçası
    "chr_023": [("cubuk", "sag")],                      # geçit çubuğu
    "chr_024": [("kilic_bez", "sag")],                  # beze sarılı eğri kılıç
    "chr_025": [("kova", "sag"), ("kova", "sol")],      # su kovaları
    "chr_026": [("heybe", "sag")],                      # saraç çantası
    "chr_027": [("testi", "sag")],                      # çatlak testi
    "chr_028": [("bohca", "sol")],                      # bez topları
    "chr_029": [("cekic", "sag")],                      # çivi çekici
    "chr_030": [("kile", "sag"), ("torba", "sol")],     # tahta kile, un kesesi
}


def _alan(metin, ad):
    m = re.search(r"\[%s\]:\s*(.+)" % re.escape(ad), metin)
    return _temiz(m.group(1)) if m else ""


def _temiz(s):
    s = s.replace("\\>", ">").replace("\\<", "<").strip()
    return re.sub(r"\s+", " ", s)


def _soru_metni(s):
    s = _temiz(s)
    s = s.split("->")[0].strip()
    s = re.sub(r"\((Tansiyon|Yalnızca)[^)]*\)", "", s).strip()
    m = re.match(r'^"(.*)"\s*$', s)
    if m:
        s = m.group(1)
    if "ipuçlarına dikkatle bakılır" in s:
        s = s.split("bakılır:", 1)[1]
    s = re.sub(r"\s*\[Clue[^\]]*\]", "", s)
    s = re.sub(r"\((Tansiyon|Yalnızca)[^)]*\)", "", s)
    return re.sub(r"\s+", " ", s).strip().strip('"').strip()


def dugumler(metin):
    """Düğüm adı → {npc, secenekler: [(metin, hedef)], gec: [hedef]} (gec: metinsiz koşullu yönlendirme)."""
    d = {}
    simdiki = None
    for satir in metin.splitlines():
        m = re.match(r"\s*-\s*Düğüm[ _]([\w.]+):\s*$", satir)
        if m:
            simdiki = d.setdefault(m.group(1), {"npc": "", "secenekler": [], "gec": []})
            continue
        if simdiki is None:
            continue
        m = re.match(r'\s*-\s*NPC Replik:\s*"?(.*?)"?\s*$', satir)
        if m:
            simdiki["npc"] = _temiz(m.group(1)).strip('"')
            continue
        h = re.search(r"\[Hedef:\s*Düğüm[ _]([\w.]+)\]", satir)
        if not h:
            continue
        hedef = h.group(1)
        m = re.match(r'\s*-\s*(Seçenek[^:]*|Test sorusu):\s*(.*)$', satir)
        if m:
            simdiki["secenekler"].append((_soru_metni(m.group(2)), hedef))
        else:
            simdiki["gec"].append(hedef)
    return d


SON = {"00", "Final_Ret", "Karar_Menusu"}


def _cevap(d, ad, iz):
    """Düğümün cevabı ve takip seçenekleri; NPC'siz düğüm koşullu yönlendirmeyi izler."""
    dug = d.get(ad)
    adim = 0
    while dug is not None and not dug["npc"] and adim < 4:
        ileri = [g for g in dug["gec"] if g not in SON]
        if not ileri:
            return "", []
        ad = ileri[0]
        dug = d.get(ad)
        adim += 1
    if dug is None:
        return "", []
    return dug["npc"], [(m, h) for m, h in dug["secenekler"] if h not in SON and h not in iz and m]


def _agac(d, secenekler, iz, derinlik):
    out = []
    for metin, hedef in secenekler:
        if hedef in SON or hedef in iz or not metin:
            continue
        cevap, takip = _cevap(d, hedef, iz | {hedef})
        if not cevap:
            continue
        alt = _agac(d, takip, iz | {hedef}, derinlik + 1) if derinlik < 3 else []
        out.append((metin, cevap, alt))
    return out


def oku_dizini():
    sonuc = {}
    for satir in open(os.path.join(KLASOR, "OKU.md"), encoding="utf-8"):
        m = re.match(r"\s*-\s*(CHR_\d+):\s*([^,]+),\s*([^,]+),", satir)
        if m:
            sonuc[m.group(1)] = (m.group(2).strip(), m.group(3).strip())
    return sonuc


def karakterler():
    """KARAKTERLER sözlükleri (icerik_uret.py biçimi) + id → cinsiyet ('e'/'k')."""
    dizin = oku_dizini()
    liste, cinsiyet = [], {}
    for chr_id in sorted(dizin):
        yol = os.path.join(KLASOR, chr_id + ".md")
        if not os.path.exists(yol):
            continue
        metin = open(yol, encoding="utf-8").read()
        ad, sinif_ad = dizin[chr_id]
        sinif = SINIF[sinif_ad]
        kimlik = chr_id.lower()
        etiket = _alan(metin, "Tag_Array")
        cinsiyet[kimlik] = "k" if etiket.startswith("Kadın") else "e"
        m = re.search(r"Tur\s*>\s*(\d+)", _alan(metin, "Spawn_Koşulu"))
        erken = int(m.group(1)) if m else 2
        tehlikeli = any(t in _alan(metin, "Sadakat_Fraksiyonu") for t in TEHLIKE)
        etki = {k: [a + b for a, b in zip(SINIF_KABUL[sinif] if k == "kabul" else [0, 0, 0, 0], v)]
                for k, v in NIYET[tehlikeli].items()}
        d = dugumler(metin)
        acilis = d.get("00", {}).get("npc", "")
        agac = _agac(d, d.get("00", {}).get("secenekler", []), {"00"}, 1)
        giris = _alan(metin, "Persona_Maskesi")
        hata = re.search(r"-\s*\[Görsel_Hata\]:\s*(.+)", metin)
        if hata:
            giris += " " + _temiz(hata.group(1))
        portre = {"asker": "soldier_01", "esnaf": "craftsman_01", "ciftci": "farmer_01"}[sinif]
        if cinsiyet[kimlik] == "k":
            portre = "farmer_02"
        liste.append(dict(
            id=kimlik, ad=ad, koken="yerel", sinif=sinif, kural="hic_donmez", erken=erken, portre=portre,
            secenekler=["kabul", "ret", "rusvet", "kisla"], etki=etki, azami_soru=AZAMI_SORU,
            girisler=[giris], acilislar=[acilis], sorular=[(0, s, c, t) for s, c, t in agac],
            tehlikeli=tehlikeli))
    return liste, cinsiyet


if __name__ == "__main__":
    liste, _ = karakterler()
    for k in liste:
        def say(a):
            return sum(1 + say(x[2]) for x in a)
        print(k["id"], k["ad"], k["sinif"], "erken", k["erken"], "tehlikeli" if k["tehlikeli"] else "masum",
              "soru", say([(s, c, t) for _, s, c, t in k["sorular"]]))
