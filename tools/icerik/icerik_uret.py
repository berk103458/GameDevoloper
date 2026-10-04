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
        elif isinstance(v, str) and not v.startswith(("Packed", "&", "{", "[", "Array[")):
            v = '"%s"' % v
        satirlar.append("%s = %s" % (k, v))
    tam = os.path.join(KOK, yol)
    os.makedirs(os.path.dirname(tam), exist_ok=True)
    with open(tam, "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(satirlar) + "\n")


def gd(v) -> str:
    """Python değerini Godot Variant metnine çevirir (sözlük, dizi, sayı, metin)."""
    import json
    return json.dumps(v, ensure_ascii=False)


def sn(x: str) -> str:
    return '&"%s"' % x


# ─── Barlar ve oyun ayarları ──────────────────────────────────────────────
BARLAR = [t("bar.halk", "Halk"), t("bar.soylular", "Soylular"),
          t("bar.tuccarlar", "Tüccarlar"), t("bar.ordu", "Ordu")]

tres("data/ayarlar/oyun.tres", "OyunAyarlari", "res://src/veri/oyun_ayarlari.gd", {
    "bar_anahtarlari": psa(BARLAR),
    "bar_baslangic": 6, "bar_azami": 10, "rusvet_kurtarma": 3, "rusvet_hakki": 3,
    "gece_basina_gelen": 3, "adli_olasiligi": 0.6, "azami_soru": 2, "belirme_ms": 300.0,
    "ciftci_uretim": 3, "tuketim_bolen": 1,
    "gida_carpani": 3, "ordu_baski_gecesi": 3, "vergi_araligi": 4, "tuccar_baski_gecesi": 2,
    "oturma_esigi": 18, "perde2_gece_basina_gelen": 2, "perde2_hedef_gece": 12,
    "pazar_bedel": pia([6, 12, 20]), "kervansaray_bedel": pia([8, 15, 24]), "sur_bedel": pia([8, 14, 22]),
    "pazar_esnaf": pia([1, 3, 5]), "kervansaray_esnaf": pia([2, 4, 6]),
    "akce_baslangic": 4, "rusvet_akce": 3, "kese_fiyati": 10, "kervansaray_gelir": 2, "esnaf_gelir": 1,
    "pazar_tezgah_taban": 2, "pazar_tezgah_artis": 2, "olay_olasiligi": 0.75,
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
    dict(id="ayse_baci", ad="Ayşe Bacı", koken="yerel", sinif="esnaf", kural="oranla_doner", erken=2, portre="farmer_02",
         secenekler=["kabul", "ret", "rusvet"],
         etki=dict(kabul=[1, 0, 1, 0], ret=[-1, 0, 0, 0], rusvet=[0, 1, 0, -1]),
         girisler=["Sırtında katlanmış bir dokuma tezgâhı taşıyan orta yaşlı bir kadın. Yanında iki genç kız.",
                   "Ayşe Bacı yine geldi. Tezgâhın bir ayağı kırık."],
         sorular=[(1, "Kimsin?", "Ayşe derler. Kayseri'de bacılardandım. Dokuruz, öğretiriz."),
                  (1, "Bu kızlar kim?", "Çıraklarım. Yolda annelerini yitirdiler."),
                  (1, "Bacılar ne iş yapar?", "Erkekler ocakta, biz tezgâhta. Biri olmazsa öteki eksik kalır."),
                  (2, "Tezgâha ne oldu?", "Bir dere geçerken kırıldı. Elimiz kırılmadı ama."),
                  (2, "Neden döndün?", "Başka uçta kapı var ama ocak yok. Burada olacak diye duydum.")]),
    dict(id="hasan_celebi", ad="Hasan Çelebi", koken="yerel", sinif="esnaf", kural="hic_donmez", erken=4, portre="craftsman_01",
         secenekler=["kabul", "ret", "rusvet", "kisla"],
         etki=dict(kabul=[-1, 2, 0, 0], ret=[0, -2, 0, 0], rusvet=[0, 1, 1, 0], kisla=[0, -1, 0, 1]),
         girisler=["İyi dikilmiş bir kaftan, mürekkep lekeli parmaklar. Yanında defterler dolu bir heybe."],
         sorular=[(0, "Kimsin?", "Hasan. Sivas divanında kâtiptim. Vergi yazardım."),
                  (0, "Heybede ne var?", "Kimin ne borçlu olduğu. Moğol da sorar, bey de."),
                  (0, "Burada ne işin var?", "Bir köy kayıtsız yaşamaz. Ben kaydederim; sen yönetirsin.")]),
    dict(id="nogay", ad="Nogay", koken="yabanci", sinif="asker", kural="birden_cok_gelir", n=2, erken=5, portre="soldier_01",
         secenekler=["kabul", "ret", "kisla"],
         etki=dict(kabul=[-1, 0, 1, 1], ret=[0, 0, 0, -1], kisla=[-1, -1, 0, 2]),
         girisler=["Bozkır biçimi kalpaklı, sessiz bir adam. Atını yedeğinde değil, elinde tutuyor.",
                   "Nogay yine geldi. Bu sefer atı yok; ayakları sargılı."],
         sorular=[(1, "Kimsin?", "Nogay. Dilmaçtım. Moğol beyinin sözünü Türkçeye çevirirdim."),
                  (1, "Neden kaçtın?", "Çevirdiğim sözler köyleri yaktı. Ben çevirmekten yoruldum."),
                  (1, "Moğollar nerede?", "Arkamda değil. Ama uzak da değil."),
                  (2, "Atın nerede?", "Bir Türkmen obası aldı. Karşılığında beni öldürmediler."),
                  (2, "Bu kez ne istiyorsun?", "Bir yer. Kimsenin sözünü çevirmediğim bir yer.")]),
    dict(id="yusuf", ad="Yusuf", koken="yerel", sinif="ciftci", kural="oranla_doner", erken=3, portre="farmer_01",
         secenekler=["kabul", "ret", "kisla"],
         etki=dict(kabul=[2, 0, 0, -1], ret=[-1, 0, 0, 0], kisla=[-2, 0, 0, 1]),
         girisler=["On iki yaşlarında bir oğlan. Elinde bir keçi ipi, ucunda keçi yok.",
                   "Yusuf yine kapıda. Daha zayıf."],
         sorular=[(1, "Adın ne?", "Yusuf."),
                  (1, "Ailen nerede?", "Kösedağ'a babam gitti. Annem yolda kaldı."),
                  (1, "Keçin nerede?", "İp bende kaldı. Keçi kaçtı. Belki döner."),
                  (2, "Nerede kaldın?", "Bir değirmencinin yanında. Sonra değirmen de gitti."),
                  (2, "Ne iş bilirsin?", "Keçi güderim. Bir de beklerim.")]),
]

for k in KARAKTERLER:
    i = k["id"]
    ad = t("karakter.%s.ad" % i, k["ad"])
    alan = {
        "id": sn(i), "ad_anahtari": sn(ad), "koken": sn(k["koken"]), "sinif": sn(k["sinif"]),
        "sohbet_id": sn(i), "karar_secenekleri": psa(k["secenekler"]),
        "donus_kurali": sn(k["kural"]), "en_erken_gece": k["erken"], "portre": sn(k.get("portre", i)),
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

# ─── Gece olayları ───────────────────────────────────────────────────────
# bar sırası: Halk, Soylular, Tüccarlar, Ordu. Her seçenek: (metin, etki sözlüğü, sonuç anlatısı)
OLAYLAR = [
    dict(id="thessra_afyon", baslik="Eksik şişe", kosul={"koyde": ["thessra"], "gece_min": 3}, agirlik=3,
         metin="Thessra'nın kutusundan bir şişe eksik. Sabah, değirmenin arkasında uyuşmuş bir adam bulundu.",
         secenekler=[("Thessra'yı sorguya çek", {"bar": [1, 0, 0, 0], "bayrak": "thessra_kirgin"}, "Thessra bir şey demedi. Ertesi gün kutuyu sana getirdi; kapağı açıktı."),
                     ("Kutuyu kilitle, anahtar sende dursun", {"bar": [-1, 1, 0, 0], "akce": 3}, "Kutuyu soran hekimler artık sana geliyor. Her biri bir akçe bırakıyor."),
                     ("Görmezden gel", {"bar": [-1, 0, 1, 0]}, "Pazarda şişeler el altından dolaşmaya başladı.")]),
    dict(id="miraen_cavus", baslik="Selçuklu çavuşu", kosul={"koyde": ["miraen"], "gece_min": 3}, agirlik=3,
         metin="Bir Selçuklu çavuşu kapıya geldi. Bozgundan kaçanları arıyor. Listesinde Miraen'in adı var.",
         secenekler=[("Miraen'i teslim et", {"bar": [0, 2, 0, -1], "ayril": "miraen"}, "Miraen karşı çıkmadı. Giderken kırık kınını kapının dibine bıraktı."),
                     ("Burada öyle biri yok de", {"bar": [0, -2, 0, 1], "bayrak": "miraen_sadik"}, "Çavuş inanmadı ama ısrar da etmedi. Miraen o gece nöbete kendisi çıktı."),
                     ("Çavuşun eline üç akçe sıkıştır", {"gerekli": {"akce": 3}, "bar": [0, 0, 0, 1]}, "Çavuş listeye bir çizgi çekti ve atına bindi.")]),
    dict(id="sorhan_damga", baslik="Damgalı atlar", kosul={"koyde": ["sorhan"], "gece_min": 2}, agirlik=3,
         metin="Bir Türkmen beyinin adamları geldi. Sorhan'ın getirdiği atlardaki damga onların.",
         secenekler=[("Atları geri ver", {"bar": [0, 1, -1, 0]}, "Adamlar atları alıp gitti. Sorhan bir süre kimseyle konuşmadı."),
                     ("Sorhan'ı koru", {"bar": [0, -1, 1, -1], "bayrak": "turkmen_kin"}, "Adamlar dönerken arkalarına baktılar. Uçta kin unutulmaz."),
                     ("Atları beş akçeye satın al", {"gerekli": {"akce": 5}, "bar": [0, 0, 0, 2]}, "Atlar köyün oldu. Kışlanın ilk binekleri.")]),
    dict(id="karaca_ocak", baslik="Ahi ocağı", kosul={"koyde": ["karaca_usta"], "yapi_min": {"pazar": 1}}, agirlik=3,
         metin="Karaca Usta, pazarın yanında bir Ahi ocağı kurmak istiyor. Çıraklar yemin edecek, esnaf birbirine kefil olacak.",
         secenekler=[("Ocağa izin ver", {"bar": [0, -1, 2, 0], "bayrak": "ahi_ocagi"}, "Ocağın kapısına bir kuşak asıldı. O gece pazar her zamankinden kalabalıktı."),
                     ("Önce Kayseri'ye olan borcunu öde", {"bar": [0, 0, -1, 0], "akce": 3}, "Karaca borcunu ödedi ama ocağı kurmaktan söz etmedi bir daha.")]),
    dict(id="aydogdu_oba", baslik="Obanın gelişi", kosul={"koyde": ["aydogdu"], "gece_min": 2}, agirlik=3,
         metin="Aydoğdu'nun obası kapıya dayandı: yirmi kişi, otuz koyun, iki kağnı.",
         secenekler=[("Hepsini al", {"nufus": {"asker": 2, "ciftci": 2}, "ambar": 4, "bar": [-1, 0, 0, 1]}, "Koyunlar ambarı doldurdu; çadırlar köyü kalabalıklaştırdı."),
                     ("Yalnız savaşanları al", {"nufus": {"asker": 2}, "bar": [0, 0, 0, 1]}, "Obanın kadınları ve çocukları yollarına devam etti. Aydoğdu onları uğurlarken dönmedi."),
                     ("Obayı geri gönder", {"bar": [1, 0, 0, -2], "ayril": "aydogdu"}, "Aydoğdu sabah atına bindi ve obasının peşine düştü.")]),
    dict(id="saruca_tohum", baslik="Tohum", kosul={"koyde": ["saruca_hatun"], "gece_min": 3}, agirlik=2,
         metin="Saruca Hatun'un getirdiği tohum ambarda bekliyor. Kış yaklaşıyor.",
         secenekler=[("Tarla aç, toprağa ver", {"bayrak": "tarla", "ambar": -2}, "İlk gece kimse bir şey görmedi. Ama köy artık her gece biraz daha fazla ürün kaldıracak."),
                     ("Ambara kat, kışı çıkaralım", {"ambar": 6}, "Ambar doldu. Saruca bir şey demedi; çocuğun ipini sıktı.")]),
    dict(id="vergi_tahsildari", baslik="Tahsildar", kosul={"gece_min": 3, "perde": 1}, agirlik=2, tek=False,
         metin="Beyin tahsildarı geldi. Yanında iki atlı, elinde defter.",
         secenekler=[("Dört akçe öde", {"gerekli": {"akce": 4}, "bar": [0, 1, 0, 0]}, "Tahsildar parayı saydı, defterine bir şey yazdı, gitti."),
                     ("Ambardan öde", {"gerekli": {"ambar": 4}, "bar": [-1, 1, 0, 0]}, "Çuvallar atlara yüklendi. Halk arkalarından baktı."),
                     ("Ödemeyi reddet", {"bar": [1, -2, 0, 0]}, "Tahsildar kapıdan çıkarken köyün adını yüksek sesle tekrarladı.")]),
    dict(id="mogol_duman", baslik="Ufukta duman", kosul={"gece_min": 4, "gece_max": 12}, agirlik=2,
         metin="Doğuda, tepelerin ardında duman var. Moğol öncüleri olabilir; yanan bir köy de olabilir.",
         secenekler=[("Yarın gece kapıyı kapalı tut", {"sonraki_gelen": -2, "bar": [-1, 0, 0, 1]}, "Ertesi gece kapının önünde kimse beklemedi. Ya da kimse kapıyı çalmadı."),
                     ("Nöbeti iki katına çıkar", {"bar": [-1, 0, 0, 2]}, "Gece boyu kimse uyumadı. Duman sabaha doğru dağıldı."),
                     ("Kaçanlara kapıyı aç", {"sonraki_gelen": 2, "bar": [1, 0, 0, -1]}, "O gece kapıya her zamankinden çok insan geldi.")]),
    dict(id="salgin", baslik="Öksürük", kosul={"nufus_min": 7}, agirlik=2,
         metin="Köyde öksürük yayılıyor. Önce çocuklar, sonra yaşlılar.",
         secenekler=[("Thessra'nın ilaçlarını kullan", {"gerekli": {"koyde": ["thessra"]}, "bar": [2, 0, 0, 0]}, "Thessra üç gece uyumadı. Kimse ölmedi."),
                     ("Hastaları ayır", {"nufus": {"ciftci": -1}, "bar": [-1, 0, 0, 1]}, "Hastaların çadırı köyün dışına kuruldu. Biri sabaha çıkmadı."),
                     ("Sabret, geçer", {"bar": [-2, 0, 0, 0]}, "Geçti. Ama herkes kimin öksürdüğünü hatırladı.")]),
    dict(id="dugun", baslik="Düğün", kosul={"nufus_min": 6}, agirlik=1,
         metin="İki aile, kapıdan ayrı ayrı girmiş iki genci evlendirmek istiyor.",
         secenekler=[("Düğün ver (üç akçe)", {"gerekli": {"akce": 3}, "bar": [2, 0, 1, 0]}, "Bir gece boyunca kimse kapıyı düşünmedi."),
                     ("Sade bir nikâh yeter", {"bar": [1, 0, 0, 0]}, "Nikâhı köyün en yaşlısı kıydı."),
                     ("Şimdi sırası değil", {"bar": [-1, 0, 0, 1]}, "Gençler bir şey demedi. Aileler dedi.")]),
    dict(id="kervan", baslik="Kervan", kosul={"yapi_min": {"kervansaray": 1}}, agirlik=2, tek=False,
         metin="Halep'ten Sivas'a giden bir kervan kervansarayda konaklamak istiyor.",
         secenekler=[("Konuk et", {"akce": 4, "bar": [0, 0, 1, 0]}, "Kervancılar haber getirdi: güneydeki yollar hâlâ açık."),
                     ("Ağır bir geçiş akçesi iste", {"akce": 8, "bar": [0, 0, -1, 0]}, "Kervan ödedi. Bir dahaki sefere başka yoldan gidecekler."),
                     ("Askerlerine eşlik ettir", {"bar": [0, 0, 2, -1]}, "Kervan güvenle geçti. Kışla bir gece boş kaldı.")]),
    dict(id="kitlik", baslik="Ambarın dibi", kosul={"ambar_max": 2, "nufus_min": 4}, agirlik=3, tek=False,
         metin="Ambarın dibi göründü. Çuvallar boş, ekmek ince.",
         secenekler=[("Beyden zahire iste", {"ambar": 5, "bar": [0, -1, 0, 0]}, "Zahire geldi; yanında bir de mektup: 'Unutmayız.'"),
                     ("Pazar malını sat, buğday al", {"gerekli": {"akce": 4}, "ambar": 6}, "Pazar bir gün boş kaldı. Ambar doldu."),
                     ("Tayını yarıya indir", {"ambar": 3, "bar": [-2, 0, 0, 0]}, "Kimse aç ölmedi. Kimse tok da uyumadı.")]),
    dict(id="dervis", baslik="Gezgin derviş", kosul={"gece_min": 2}, agirlik=1,
         metin="Bir gezgin derviş kapının dibinde geceledi. Batıdan, uçlardan haber getiriyor.",
         secenekler=[("Misafir et", {"ambar": -1, "bar": [1, 0, 0, 0], "bayrak": "dervis"}, "Derviş sabah giderken Söğüt diye bir yerden, orada toplanan Türkmenlerden söz etti."),
                     ("Ekmek ver, uğurla", {"bar": [0, 0, 0, 0]}, "Derviş dua etti ve yürüdü.")]),
    dict(id="hirsizlik", baslik="Pazarda hırsızlık", kosul={"sinif_min": {"esnaf": 2}}, agirlik=1,
         metin="Pazardan bir top kumaş ve bir kese çalındı. Esnaf suçluyu istiyor.",
         secenekler=[("Suçluyu bul, cezalandır", {"bar": [-1, 0, 1, 1]}, "Suçlu yeni gelenlerden biriydi. Herkes bunu hatırlayacak."),
                     ("Zararı köy kasasından öde", {"gerekli": {"akce": 3}, "bar": [0, 0, 1, 0]}, "Esnaf memnun. Hırsız hâlâ aralarında."),
                     ("Esnafın işine karışma", {"bar": [0, 0, -1, 0]}, "Pazarda kepenkler erken iniyor artık.")]),
    dict(id="ahi_haber", baslik="Kayseri'den haber", kosul={"bayrak": ["ahi_ocagi"]}, agirlik=2,
         metin="Kayseri'deki büyük Ahi ocağından bir haberci geldi. Yeni ocağı tanıyorlar.",
         secenekler=[("Ocağa bağlan", {"bar": [0, -1, 2, 0], "akce": 3}, "Ocağın kuşağı Kayseri'den mühürlü geldi."),
                     ("Bağımsız kal", {"bar": [0, 1, 0, 0]}, "Haberci kırgın döndü.")]),
    dict(id="tekfur_elcisi", baslik="Tekfur'un elçisi", kosul={"perde": 2}, agirlik=5,
         metin="Tekfur'un elçisi geldi. Sözü kısa: her ay haraç öde, köyün rahat etsin.",
         secenekler=[("Haracı kabul et (sekiz akçe)", {"gerekli": {"akce": 8}, "bayrak": "harac", "bar": [0, 0, 0, -2]}, "Elçi parayı aldı. Tekfur'un adamları o gece tepelerden inmedi."),
                     ("Reddet", {"bar": [1, -1, 0, 1]}, "Elçi gülümsedi ve gitti. Gülümsemesi iyi bir şey değildi."),
                     ("Oyala, cevabı sonra ver", {"bar": [0, 0, 0, 0]}, "Elçi bir gece daha bekleyeceğini söyledi.")]),
    dict(id="ertugrul_haberi", baslik="Batıdan haber", kosul={"perde": 2, "gece_min": 2}, agirlik=3,
         metin="Batıda, Söğüt yöresinde Ertuğrul adında bir Türkmen beyi uçlarda adam topluyor. Haberci senden de söz almak istiyor.",
         secenekler=[("Ertuğrul'a haber gönder", {"bayrak": "ertugrul", "bar": [0, -1, 0, 1]}, "Haberci sabah batıya yola çıktı. Ardından iki atlı daha gitti."),
                     ("Uzak dur", {"bar": [0, 1, 0, 0]}, "Söğüt uzak. Tekfur yakın.")]),
    dict(id="sur_catlak", baslik="Surda çatlak", kosul={"perde": 2}, agirlik=2, tek=False,
         metin="Gece saldırısından sonra surda bir çatlak açıldı.",
         secenekler=[("Ustalara onart (beş akçe)", {"gerekli": {"akce": 5}, "bar": [0, 0, 0, 1]}, "Sur sabaha onarıldı."),
                     ("Köylüleri çalıştır", {"bar": [-1, 0, 0, 1]}, "Herkes taş taşıdı. Kimse şikâyet etmedi, kimse teşekkür etmedi."),
                     ("Bırak, şimdilik dayanır", {"bar": [0, 0, 0, -1]}, "Çatlak her gece biraz daha uzadı.")]),
    dict(id="kacak_koylu", baslik="Gece kaçanlar", kosul={"perde": 2, "nufus_min": 8}, agirlik=2,
         metin="Gece köyden üç kişi kaçmaya çalışırken nöbetçiler yakaladı.",
         secenekler=[("Geri getir, ders olsun", {"bar": [-1, 0, 0, 1]}, "Kaçaklar geri getirildi. Bir daha kimse denemedi. Henüz."),
                     ("Bırak gitsinler", {"nufus": {"ciftci": -1, "esnaf": -1}, "bar": [1, 0, 0, 0]}, "Kapı arkalarından kapandı. Bu sefer içeriden.")]),
    dict(id="bey_daveti", baslik="Beyin daveti", kosul={"bar_min": {"1": 7}, "gece_min": 5}, agirlik=2,
         metin="Bölgenin beyi seni sofrasına çağırıyor. Köyünü kendi himayesine almak istiyor.",
         secenekler=[("Himayeyi kabul et", {"bayrak": "bey_dostu", "bar": [-1, 2, 0, 0]}, "Bey'in sancağı kapının üstüne asıldı. Vergi artık senden değil, beyin adamlarından sorulacak."),
                     ("Nazikçe geri çevir", {"bar": [1, -1, 0, 0]}, "Bey bir şey demedi. Beyler bir şey demezler.")]),
    dict(id="nogay_haber", baslik="Dilmacın uyarısı", kosul={"koyde": ["nogay"], "gece_min": 4}, agirlik=3,
         metin="Nogay geceyarısı yanına geldi: 'Moğol öncülerinin işaretini tanıyorum. Yolun kenarındaki taşlar dizilmiş.'",
         secenekler=[("Taşları dağıt, izleri sil", {"bar": [0, 0, 0, 2], "sonraki_gelen": -1}, "Ertesi gece yol sessizdi."),
                     ("Nogay'ı casus diye kov", {"ayril": "nogay", "bar": [1, 0, 0, -1]}, "Nogay hiçbir şey demeden gitti. Taşlar yerinde kaldı.")]),
    dict(id="hasan_defter", baslik="Kâtibin defteri", kosul={"koyde": ["hasan_celebi"]}, agirlik=3,
         metin="Hasan Çelebi köyün defterini tuttu. Kim ne getirdi, kim ne yedi, kim ne borçlu — hepsi yazılı.",
         secenekler=[("Deftere göre vergi topla", {"akce": 6, "bar": [-2, 1, 0, 0]}, "Kasa doldu. Halk defterden korkmaya başladı."),
                     ("Defteri yalnız ambar için kullan", {"ambar": 3, "bar": [0, 0, 1, 0]}, "Ambarda artık hiçbir şey kaybolmuyor."),
                     ("Defteri yak", {"bar": [2, -1, 0, 0]}, "Halk bir gece ateşin başında güldü. Hasan ağladı.")]),
    dict(id="ayse_tezgah", baslik="Bacıların tezgâhı", kosul={"koyde": ["ayse_baci"]}, agirlik=3,
         metin="Ayşe Bacı köyün kadınlarını tezgâhın başına topladı. Kilim dokuyacaklar, satacaklar.",
         secenekler=[("Destekle (iki akçe)", {"gerekli": {"akce": 2}, "bar": [1, 0, 2, 0], "bayrak": "baci_tezgah"}, "İlk kilim pazarda üç akçeye gitti."),
                     ("Kadınların işi tarlada", {"bar": [-1, 0, 0, 0], "ambar": 2}, "Tezgâh bir köşeye kaldırıldı.")]),
    dict(id="yusuf_keci", baslik="Keçi", kosul={"koyde": ["yusuf"], "gece_min": 2}, agirlik=2,
         metin="Yusuf'un keçisi bir sabah kapının önünde bekliyordu. Yanında dört keçi daha.",
         secenekler=[("Sürü Yusuf'un olsun", {"ambar": 3, "bar": [2, 0, 0, 0]}, "Yusuf o gün ilk kez güldü."),
                     ("Keçiler köyün malı", {"ambar": 5, "bar": [-1, 0, 0, 0]}, "Ambar doldu. Yusuf ipi yine eline aldı ve bir şey demedi.")]),
]

for o in OLAYLAR:
    i = o["id"]
    baslik = t("olay.%s.baslik" % i, o["baslik"])
    metin = t("olay.%s.metin" % i, o["metin"])
    secs, etkiler = [], []
    for n, (sec, etki, sonuc) in enumerate(o["secenekler"]):
        secs.append(t("olay.%s.secenek%d" % (i, n + 1), sec))
        t("olay.%s.sonuc%d" % (i, n + 1), sonuc)
        etkiler.append(etki)
    tres("data/olaylar/%s.tres" % i, "OlayVerisi", "res://src/veri/olay_verisi.gd", {
        "id": sn(i), "baslik_anahtari": baslik, "metin_anahtari": metin,
        "kosullar": gd(o["kosul"]), "agirlik": float(o.get("agirlik", 1)), "tek_sefer": o.get("tek", True),
        "secenek_anahtarlari": psa(secs), "secenek_etkileri": "Array[Dictionary](" + gd(etkiler) + ")"})

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
    "anlati.baski.gida": "Ambar boşaldı. Halk aç yattı.",
    "anlati.ambar": "Ambar: +%d ürün, −%d tüketim.",
    "anlati.gelir": "Pazar ve kervandan %d akçe geldi.",
    "anlati.maas": "Askerlerin payı: %d akçe.",
    "anlati.maas_yok": "Askerlere verecek akçe yok. Kışlada homurtu var.",
    "anlati.saldiri.guc": "Tekfur'un adamları: güç %d. Köyün savunması: %d.",
    "anlati.saldiri.kayip": "Saldırıda köyden biri öldü.",
    "arayuz.hud.akce": "Akçe %d",
    "arayuz.hud.ambar": "Ambar %d",
    "arayuz.koy.yapilar": "Yapılar",
    "arayuz.yapi.pazar": "Pazar",
    "arayuz.yapi.kervansaray": "Kervansaray",
    "arayuz.yapi.sur": "Sur",
    "arayuz.yapi.seviye": "%s — seviye %d",
    "arayuz.yapi.kur": "%s kur / büyüt — %d akçe",
    "arayuz.yapi.esnaf_gerek": "%d esnaf gerekir",
    "arayuz.yapi.azami": "%s — en üst seviyede",
    "arayuz.yapi.pazar_aciklama": "Esnaf başına gelir artar; Halk +1.",
    "arayuz.yapi.kervansaray_aciklama": "Gecelik kervan geliri; 2. seviyede kapıya daha çok kişi gelir.",
    "arayuz.yapi.sur_aciklama": "Her seviye savunmayı 2 artırır.",
    "arayuz.koy.kese_al": "Boş keseyi doldur — %d akçe",
    "arayuz.koy.olay_secenek_kosul": "(olmaz)",
    "arayuz.son.kirildi.0": "Halk kapıyı kendisi açtı ve gitti.",
    "arayuz.son.kirildi.1": "Bey seni azletti. Kapıya başkası bakacak.",
    "arayuz.son.kirildi.2": "Kervanlar yolunu değiştirdi. Köy açlıktan dağıldı.",
    "arayuz.son.kirildi.3": "Tekfur'un adamları kapıyı kırdı.",
    "arayuz.son.ertugrul": "Ertuğrul'un obasına katıldın.",
    "arayuz.son.ertugrul_metin": "Bir bahar sabahı batıdan atlılar geldi. Köy, Söğüt'teki obanın uç karakollarından biri oldu. Kapı açık kaldı; bekçisi artık sen değildin.",
    "arayuz.son.ahi": "Ahi kasabası.",
    "arayuz.son.ahi_metin": "Pazar büyüdü, ocak kuruldu. Köyün adı uçtan çok kervan yolunda anılır oldu. Tekfur bile buradan geçerken pazarlık etti.",
    "arayuz.son.harac": "Tekfur'un haraççısı.",
    "arayuz.son.harac_metin": "Köy ayakta kaldı. Her ay bir kese Tekfur'a gitti. Kimse savaşmadı; kimse de kapıdan özgür geçmedi.",
    "arayuz.son.bey": "Beyin uç köyü.",
    "arayuz.son.bey_metin": "Köy beyin sancağı altına girdi. Vergi düzenli, nöbet düzenli. Kapıyı artık beyin adamı tutuyor; sen sofrada oturuyorsun.",
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
    "arayuz.olay.devam": "Devam",
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
