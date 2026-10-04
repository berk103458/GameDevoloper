#!/usr/bin/env python3
"""İçerik üreticisi — oyun içeriğinin TEK yazım yeri.

Bu betik `data/` altındaki .tres kayıtlarını ve `data/metin/metinler.csv`
metin tablosunu üretir (design/gdd/icerik-veri-hatti.md). Metni ve değerleri
burada değiştirip betiği yeniden çalıştırın:

    python3 tools/icerik/icerik_uret.py

Üretilen dosyalar elle düzenlenmez; elle düzenlenirse bir sonraki çalıştırmada
üzerine yazılır.
"""
import csv
import os

KOK = os.path.join(os.path.dirname(__file__), "..", "..")
METIN: dict[str, str] = {}


def t(anahtar: str, metin: str) -> str:
    """Metni tabloya ekler, anahtarı döner."""
    assert anahtar not in METIN or METIN[anahtar] == metin, anahtar
    METIN[anahtar] = metin
    return anahtar


def psa(liste) -> str:
    return "PackedStringArray(" + ", ".join('"%s"' % x for x in liste) + ")"


def pia(liste) -> str:
    return "PackedInt32Array(" + ", ".join(str(int(x)) for x in liste) + ")"


def tres(yol: str, sinif: str, betik: str, alanlar: dict) -> None:
    satirlar = [
        '[gd_resource type="Resource" script_class="%s" format=3]' % sinif,
        "",
        '[ext_resource type="Script" path="%s" id="1"]' % betik,
        "",
        "[resource]",
        'script = ExtResource("1")',
    ]
    for k, v in alanlar.items():
        if isinstance(v, bool):
            v = "true" if v else "false"
        elif isinstance(v, str) and not v.startswith(("Packed", "&")):
            v = '"%s"' % v
        satirlar.append("%s = %s" % (k, v))
    tam = os.path.join(KOK, yol)
    os.makedirs(os.path.dirname(tam), exist_ok=True)
    with open(tam, "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(satirlar) + "\n")


def sn(x: str) -> str:
    return '&"%s"' % x


# ─── Barlar ve oyun ayarları ──────────────────────────────────────────────
BARLAR = [t("bar.halk", "Halk"), t("bar.soylular", "Soylular"),
          t("bar.tuccarlar", "Tüccarlar"), t("bar.ordu", "Ordu")]

tres("data/ayarlar/oyun.tres", "OyunAyarlari", "res://src/veri/oyun_ayarlari.gd", {
    "bar_anahtarlari": psa(BARLAR),
    "bar_baslangic": 6, "bar_azami": 10, "rusvet_kurtarma": 3, "rusvet_hakki": 3,
    "gece_basina_gelen": 3, "adli_olasiligi": 0.6, "azami_soru": 2, "belirme_ms": 300.0,
    "gida_carpani": 3, "ordu_baski_gecesi": 3, "vergi_araligi": 4, "tuccar_baski_gecesi": 2,
    "oturma_esigi": 12, "perde2_gece_basina_gelen": 2, "perde2_hedef_gece": 10,
    "saldiri_taban": 1, "saldiri_artis_araligi": 2, "savunma_bolen": 2,
})

# ─── Adlı karakterler ────────────────────────────────────────────────────
# etki sırası: Halk, Soylular, Tüccarlar, Ordu
KARAKTERLER = [
    dict(id="miraen", ad="Miraen", koken="yabanci", sinif="asker", kural="hic_donmez", erken=0,
         secenekler=["kabul", "ret", "kisla"],
         etki=dict(kabul=[0, -1, 0, 1], ret=[0, 0, 0, -1], kisla=[-1, 0, 0, 2]),
         girisler=["Atsız bir atlı. Kılıcının kını kırık; bakışı hep arkasındaki yolda."],
         sorular=[(0, "Kimsin?", "Miraen. Gürcü'yüm. Sultanın ordusundaydım."),
                  (0, "Atın nerede?", "Kösedağ'da kaldı. Ben kalmadım."),
                  (0, "Birliğin nerede?", "Birlik mi... Dağıldı. Herkes dağıldı. (Gözlerini kaçırıyor.)")]),
    dict(id="sorhan", ad="Sorhan", koken="yabanci", sinif="esnaf", kural="birden_cok_gelir", n=3, erken=1,
         secenekler=["kabul", "ret", "rusvet", "kisla"],
         etki=dict(kabul=[0, 0, 1, 1], ret=[0, 0, -1, 0], rusvet=[-1, 0, 2, 0], kisla=[0, -1, 0, 1]),
         girisler=["Üç atı yedeğinde bir Kıpçak. Atların ikisinde yabancı bir damga var.",
                   "Sorhan yine. Bu sefer yanında bir kadın ve iki çocuk. Atlardan biri eksik.",
                   "Sorhan. Yalnız. Ne at var ne aile."],
         sorular=[(1, "Kimsin?", "Sorhan. At satarım, alan olursa."),
                  (1, "Bu atlar senin mi?", "Şimdi benim."),
                  (1, "Nereye gidiyorsun?", "Neresi kapı açarsa."),
                  (2, "Bunlar kim?", "Karım, çocuklarım. Geçen sefer yolda bekliyorlardı."),
                  (2, "Bir at nerede?", "Yol parası oldu."),
                  (2, "Neden geri geldin?", "Başka kapı açılmadı."),
                  (3, "Ailen nerede?", "Bir kervana verdim onları. Güneye."),
                  (3, "Atlar?", "Atlar gitti. Ben kaldım."),
                  (3, "Ne istiyorsun?", "Bir yer. Sadece bir yer.")]),
    dict(id="thessra", ad="Thessra", koken="yabanci", sinif="esnaf", kural="oranla_doner", erken=1,
         secenekler=["kabul", "ret", "rusvet"],
         etki=dict(kabul=[1, 0, 1, -1], ret=[-1, 0, 0, 0], rusvet=[0, 1, 1, -1]),
         girisler=["Kucağında tahta bir kutu taşıyan genç bir kadın.",
                   "Thessra yine kapıda. Kutusu daha hafif görünüyor."],
         sorular=[(1, "Kimsin?", "Thessra. Trabzon'dan. Babam hekimdi."),
                  (1, "Kutuda ne var?", "İlaç. Ağrıya iyi gelir... başka şeye de."),
                  (1, "Baban nerede?", "Yolda gömdük."),
                  (2, "Neden döndün?", "Kervan beni de kutuyu da istemedi."),
                  (2, "Kutu boşaldı mı?", "Yarısı. Yol uzun."),
                  (2, "Kime sattın?", "Satmadım. Verdim. Ağrıyan çoktu.")]),
    dict(id="karaca_usta", ad="Karaca Usta", koken="yerel", sinif="esnaf", kural="oranla_doner", erken=2,
         secenekler=["kabul", "ret", "rusvet", "kisla"],
         etki=dict(kabul=[1, 0, 1, 0], ret=[-1, 0, -1, 0], rusvet=[0, 1, -1, 0], kisla=[0, 0, -1, 1]),
         girisler=["Belinde şed bağlı bir usta. Yanında iki çırak.",
                   "Karaca Usta yine geldi. Çıraklardan biri yok."],
         sorular=[(1, "Kimsin?", "Karaca derler. Kayseri'de tabakhanem vardı. Yandı."),
                  (1, "Bunlar kim?", "Çıraklarım. Ben neredeysem onlar orada."),
                  (1, "Ahi ocağın ne der?", "Ocağa borcum var. Ödeyeceğim, vakti gelince."),
                  (2, "Çırağın nerede?", "Başka bir ustaya verdim. Aç kalmasın diye."),
                  (2, "Neden döndün?", "Ocak sorar: kapı neden kapandı? Cevabım olsun istedim.")]),
    dict(id="aydogdu", ad="Aydoğdu", koken="yerel", sinif="asker", kural="hic_donmez", erken=3,
         secenekler=["kabul", "ret", "kisla"],
         etki=dict(kabul=[1, -1, 0, 1], ret=[-1, 0, 0, 0], kisla=[0, -1, 0, 2]),
         girisler=["Kolu sargılı bir okçu. Sırtında yay, belinde sadak."],
         sorular=[(0, "Kimsin?", "Aydoğdu. Türkmen'im."),
                  (0, "Yaran ne?", "Kösedağ'dan hatıra."),
                  (0, "Yalnız mısın?", "Şimdilik. (Arkasındaki yola bakıyor.)")]),
    dict(id="saruca_hatun", ad="Saruca Hatun", koken="yerel", sinif="ciftci", kural="birden_cok_gelir", n=2, erken=0,
         secenekler=["kabul", "ret", "rusvet"],
         etki=dict(kabul=[1, 0, 0, 0], ret=[-1, 0, 0, 0], rusvet=[-1, 1, 1, 0]),
         girisler=["Kucağında çocuk, yorgun bir kadın.",
                   "Saruca Hatun yine. Bu sefer sırtında bir çuval."],
         sorular=[(1, "Kimsin?", "Saruca. Sivas'ın köylerindendim."),
                  (1, "Kocan nerede?", "Yoktur artık."),
                  (1, "Ne istersin?", "Çocuğa bir çatı."),
                  (2, "Çuvalda ne var?", "Tohum. Yemeyiz, ekeriz. Toprak verirseniz."),
                  (2, "Çocuk nerede?", "Bir hana bıraktım. Tohumu getirmek için."),
                  (2, "Kış yaklaşıyor.", "Biliyorum. Tohum da biliyor.")]),
]

for k in KARAKTERLER:
    i = k["id"]
    ad = t("karakter.%s.ad" % i, k["ad"])
    alan = {
        "id": sn(i), "ad_anahtari": sn(ad), "koken": sn(k["koken"]), "sinif": sn(k["sinif"]),
        "sohbet_id": sn(i), "karar_secenekleri": psa(k["secenekler"]),
        "donus_kurali": sn(k["kural"]), "en_erken_gece": k["erken"], "portre": sn(i),
        "p0": 0.6, "d": 0.5, "k_azami": 4, "n_ziyaret": k.get("n", 1), "g_min": 2, "g_max": 4,
    }
    for karar in ("kabul", "ret", "rusvet", "kisla"):
        alan["etki_" + karar] = pia(k["etki"].get(karar, [0, 0, 0, 0]))
    tres("data/karakterler/%s.tres" % i, "KarakterVerisi", "res://src/veri/karakter_verisi.gd", alan)
    girisler = [t("sohbet.%s.giris%d" % (i, n + 1), g) for n, g in enumerate(k["girisler"])]
    sorular, cevaplar, ziyaret = [], [], []
    for n, (z, s, c) in enumerate(k["sorular"]):
        sorular.append(t("sohbet.%s.s%d" % (i, n + 1), s))
        cevaplar.append(t("sohbet.%s.c%d" % (i, n + 1), c))
        ziyaret.append(z)
    tres("data/sohbetler/%s.tres" % i, "SohbetVerisi", "res://src/veri/sohbet_verisi.gd", {
        "id": sn(i), "giris_anahtarlari": psa(girisler), "soru_anahtarlari": psa(sorular),
        "cevap_anahtarlari": psa(cevaplar), "soru_ziyareti": pia(ziyaret)})

# ─── Sınıf şablonları ─────────────────────────────────────────────────────
SINIFLAR = [
    dict(id="ciftci",
         adlar=["Yorgun bir çiftçi", "Irgat bir kadın", "Sivaslı bir rençber", "Bir orakçı"],
         cesitler=[("farmer_01", "Sırtında boyunduruk taşıyan bir adam. Öküzü yok.",
                    [("Öküzün nerede?", "Yolda öldü. Boyunduruğu bırakamadım."),
                     ("Ne iş bilirsin?", "Toprak. Başka bir şey bilmem."),
                     ("Nereden geliyorsun?", "Sivas'ın ovasından. Ova yandı.")]),
                   ("farmer_02", "Elleri nasırlı bir kadın, yalnız.",
                    [("Kimin nesisin?", "Kocam tarlada kaldı."),
                     ("Ne istersin?", "Hasat zamanı iş."),
                     ("Yalnız mı yürüdün?", "Yolda kimse kimseyi beklemiyor.")])],
         secenekler=["kabul", "ret", "rusvet", "kisla"],
         etki=dict(kabul=[1, 0, 0, 0], ret=[-1, 0, 0, 0], rusvet=[-1, 0, 1, 0], kisla=[0, 0, 0, 1])),
    dict(id="esnaf",
         adlar=["Bir Ahi çırağı", "Seyyar bir bakırcı", "Bir keçeci", "Bir semerci"],
         cesitler=[("craftsman_01", "Elinde alet torbası, genç bir çırak.",
                    [("Ustan nerede?", "Yolda kaybettim. Arıyorum."),
                     ("Ne iş yaparsın?", "Deri. Biraz da demir."),
                     ("Ocağın hangisi?", "Kayseri'nin. Ocak yerinde mi, bilmem.")]),
                   ("craftsman_01", "Sırtında birkaç bakır kap.",
                    [("Malın bu kadar mı?", "Kalan bu. Borcum daha çok."),
                     ("Nereye gidiyorsun?", "Kervansaray varsa oraya."),
                     ("Kime borçlusun?", "Bir Rum tüccara. O da yolda bir yerde.")])],
         secenekler=["kabul", "ret", "rusvet", "kisla"],
         etki=dict(kabul=[0, 0, 1, 0], ret=[0, 0, -1, 0], rusvet=[0, 1, 1, -1], kisla=[0, 0, -1, 1])),
    dict(id="asker",
         adlar=["Yaralı bir asker", "Bir firari", "Yaya bir sipahi", "Bir sınır bekçisi"],
         cesitler=[("soldier_01", "Sargısı kirlenmiş bir asker.",
                    [("Kimin adamısın?", "Artık kimsenin."),
                     ("Yaran ağır mı?", "Yürüyorum, değil mi?"),
                     ("Savaşta mıydın?", "Herkes savaştaydı. Sonra herkes yoldaydı.")]),
                   ("soldier_01", "Gözleri sürekli yolda olan bir adam.",
                    [("Kimden kaçıyorsun?", "Herkes bir şeyden kaçıyor bu yolda."),
                     ("Silahın var mı?", "Bıraktım."),
                     ("Peşinde biri var mı?", "Olsaydı bu kadar yavaş yürür müydüm?")])],
         secenekler=["kabul", "ret", "rusvet", "kisla"],
         etki=dict(kabul=[0, -1, 0, 1], ret=[0, 0, 0, -1], rusvet=[0, 1, 0, -1], kisla=[-1, 0, 0, 2])),
]

for s in SINIFLAR:
    i = s["id"]
    adlar = [t("sablon.%s.ad%d" % (i, n + 1), a) for n, a in enumerate(s["adlar"])]
    girisler, portreler, sorular, cevaplar, cesit = [], [], [], [], []
    for c, (portre, giris, ss) in enumerate(s["cesitler"]):
        girisler.append(t("sablon.%s.giris%d" % (i, c + 1), giris))
        portreler.append(portre)
        for n, (soru, cevap) in enumerate(ss):
            sorular.append(t("sablon.%s.c%d_s%d" % (i, c + 1, n + 1), soru))
            cevaplar.append(t("sablon.%s.c%d_c%d" % (i, c + 1, n + 1), cevap))
            cesit.append(c)
    alan = {"id": sn(i), "sinif": sn(i), "ad_havuzu": psa(adlar), "giris_anahtarlari": psa(girisler),
            "portreler": psa(portreler), "soru_anahtarlari": psa(sorular), "cevap_anahtarlari": psa(cevaplar),
            "soru_cesidi": pia(cesit), "karar_secenekleri": psa(s["secenekler"])}
    for karar in ("kabul", "ret", "rusvet", "kisla"):
        alan["etki_" + karar] = pia(s["etki"][karar])
    tres("data/siniflar/%s.tres" % i, "SinifSablonu", "res://src/veri/sinif_sablonu.gd", alan)

# ─── Arayüz ve anlatı metinleri ──────────────────────────────────────────
ARAYUZ = {
    "arayuz.menu.yeni": "Yeni gece",
    "arayuz.menu.devam": "Devam",
    "arayuz.menu.ayarlar": "Ayarlar",
    "arayuz.menu.cik": "Çık",
    "arayuz.menu.alt": "Kösedağ'dan sonra. Uçta bir kapı.",
    "arayuz.duraklat.baslik": "Duraklatıldı",
    "arayuz.duraklat.devam": "Devam et",
    "arayuz.duraklat.menu": "Ana menüye dön",
    "arayuz.hud.gece": "%d. gece",
    "arayuz.hud.kose": "Köy: %d",
    "arayuz.sohbet.sen": "Sen",
    "arayuz.sohbet.karar_ver": "Kararını ver",
    "arayuz.sohbet.devam": "Devam",
    "arayuz.sohbet.ipucu": "Kararda: 1–4 seçer · aynı karara tekrar basmak onaylar · Esc seçimi bırakır",
    "arayuz.karar.kabul": "Kabul",
    "arayuz.karar.ret": "Ret",
    "arayuz.karar.rusvet": "Rüşvet al",
    "arayuz.karar.kisla": "Kışlaya yaz",
    "arayuz.karar.onayla": "%s — onayla",
    "arayuz.sinif.asker": "asker",
    "arayuz.sinif.esnaf": "esnaf",
    "arayuz.sinif.ciftci": "çiftçi",
    "arayuz.sinif.gibi": "%s gibi görünüyor",
    "anlati.sonuc.kabul": "Kapı açıldı. %s içeri girdi.",
    "anlati.sonuc.ret": "Kapı kapalı kaldı. %s yoluna döndü.",
    "anlati.sonuc.rusvet": "Kese el değiştirdi. %s içeri girdi.",
    "anlati.sonuc.kisla": "%s kışlaya yazıldı.",
    "anlati.gece.basladi": "%d. gece. Yolda yine birileri var.",
    "anlati.gece.bitti": "Gece bitti.",
    "anlati.baski.gida": "Ambar azaldı. Halk homurdanıyor.",
    "anlati.baski.ordu": "Uzakta Tekfur'un adamlarının ateşleri görüldü.",
    "anlati.baski.vergi": "Beyin adamı vergi istedi. Soylular memnun değil.",
    "anlati.baski.tuccar": "Pazar boş kaldı. Tüccarlar uğramıyor.",
    "anlati.rusvet.harcandi": "%s kırılmak üzereydi. Bir kese el altından gitti.",
    "anlati.saldiri.puskurtuldu": "Tekfur'un adamları surun dibine kadar geldi, geri döndü.",
    "anlati.saldiri.agir": "Tekfur'un adamları köyün kıyısını yaktı.",
    "arayuz.koy.baslik": "Köy",
    "arayuz.koy.nufus": "%d asker · %d esnaf · %d çiftçi",
    "arayuz.koy.sonraki": "Kapıya dön",
    "arayuz.perde.baslik": "Köy oturdu.",
    "arayuz.perde.metin": "Kapıdan girenler artık bir köy. Sen artık kapının muhafızı değil, köyün ağasısın.\nKapı sade bir süzgeç. Tekfur'un adamları uzakta, ama yakınlaşıyorlar.",
    "arayuz.perde.devam": "Ağa olarak devam et",
    "arayuz.son.kirildi": "%s kırıldı.",
    "arayuz.son.tutundu": "Uç tutundu.",
    "arayuz.son.tutundu_metin": "Tekfur'un adamları bir sabah gelmedi. Köy kışı çıkardı. Kapı hâlâ açılıp kapanıyor.",
    "arayuz.son.gun": "Hayatta kalınan gün",
    "arayuz.son.yeniden": "Yeniden başla",
    "arayuz.son.menu": "Ana menü",
    "arayuz.ayarlar.baslik": "Ayarlar",
    "arayuz.ayarlar.ses_ana": "Ana ses",
    "arayuz.ayarlar.ses_muzik": "Müzik",
    "arayuz.ayarlar.ses_efekt": "Efektler",
    "arayuz.ayarlar.ekran_modu": "Ekran",
    "arayuz.ayarlar.ekran.pencere": "Pencere",
    "arayuz.ayarlar.ekran.tam_ekran": "Tam ekran",
    "arayuz.ayarlar.metin_olcegi": "Metin büyüklüğü",
    "arayuz.ayarlar.belirme_hizi": "Seçeneklerin belirişi",
    "arayuz.ayarlar.belirme.normal": "Normal",
    "arayuz.ayarlar.belirme.hizli": "Hızlı",
    "arayuz.ayarlar.belirme.aninda": "Anında",
    "arayuz.ayarlar.varsayilan": "Varsayılana dön",
    "arayuz.ayarlar.geri": "Geri",
    "arayuz.hata.icerik": "Oyun içeriği yüklenemedi. Ayrıntı geliştirici günlüğünde.",
}
for k, v in ARAYUZ.items():
    t(k, v)

yol = os.path.join(KOK, "data/metin/metinler.csv")
with open(yol, "w", encoding="utf-8", newline="") as f:
    w = csv.writer(f, lineterminator="\n")
    w.writerow(["keys", "tr"])
    for k in sorted(METIN):
        w.writerow([k, METIN[k]])
print("Yazıldı: %d metin, %d karakter, %d sınıf" % (len(METIN), len(KARAKTERLER), len(SINIFLAR)))
