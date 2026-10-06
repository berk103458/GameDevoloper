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
import json
import os
import sys

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

# ─── Ürünler (design/gdd/tarla-ve-urunler.md): (id, ad, süre gece, verim ambar, tohum ambar) ─
BITKILER = [
    ("bugday", "Buğday", 4, 10, 2),
    ("arpa", "Arpa", 3, 7, 1),
    ("mercimek", "Mercimek", 2, 4, 1),
    ("nohut", "Nohut", 3, 6, 2),
]
for b in BITKILER:
    t("bitki.%s" % b[0], b[1])
    t("anlati.hasat.%s" % b[0], b[1] + " hasadı: +%d ürün ambara.")

# ─── Heybe eşyaları (design/gdd/heybe-ve-rusvet.md) ─────────────────────────
# (id, ad, tür, birim değer akçe, kimler taşır, yalnız astarda mı)
ESYALAR = [
    ("akce", "akçe", "akce", 1, "*", 0),
    ("arpa", "arpa çuvalı", "gida", 4, "ciftci", 0),
    ("tohum", "tohum kesesi", "gida", 3, "ciftci", 0),
    ("ekmek", "kuru ekmek", "gida", 1, "*", 0),
    ("tuz", "tuz kesesi", "mal", 2, "ciftci,esnaf", 0),
    ("kumas", "çuha topu", "mal", 4, "esnaf", 0),
    ("bakir", "bakır tas", "mal", 3, "esnaf", 0),
    ("ok", "ok demeti", "mal", 2, "asker", 0),
    ("hancer", "hançer", "mal", 3, "asker", 0),
    ("ilac", "ilaç şişesi", "mal", 3, "esnaf", 0),
    ("yuzuk", "gümüş yüzük", "mal", 9, "*", 1),
]
for e in ESYALAR:
    t("esya.%s" % e[0], e[1])

tres("data/ayarlar/oyun.tres", "OyunAyarlari", "res://src/veri/oyun_ayarlari.gd", {
    "bar_anahtarlari": psa(BARLAR),
    "bar_baslangic": 6, "bar_azami": 10, "rusvet_kurtarma": 3, "rusvet_hakki": 3,
    "gece_basina_gelen": 3, "adli_olasiligi": 0.6, "azami_soru": 4, "belirme_ms": 300.0,
    "ciftci_uretim": 3, "tuketim_bolen": 1,
    "gida_carpani": 3, "ordu_baski_gecesi": 3, "vergi_araligi": 4, "tuccar_baski_gecesi": 2,
    "oturma_esigi": 18, "perde2_gece_basina_gelen": 2, "perde2_hedef_gece": 12,
    "pazar_bedel": pia([6, 12, 20]), "kervansaray_bedel": pia([8, 15, 24]), "sur_bedel": pia([8, 14, 22]),
    "konak_bedel": pia([10, 18, 28]), "konak_nufus": pia([5, 10, 16]),
    "pazar_esnaf": pia([1, 3, 5]), "kervansaray_esnaf": pia([2, 4, 6]),
    "akce_baslangic": 4, "rusvet_akce": 3, "kese_fiyati": 10, "kervansaray_gelir": 2,
    "ambar_yedek_gece": 1, "seyyar_bolen": 2, "ambar_akce_orani": 4, "takas_taban": 2, "takas_pazar_artis": 1,
    "esnaf_gelir": 1,
    "pazar_tezgah_taban": 2, "pazar_tezgah_artis": 2, "olay_olasiligi": 0.75,
    "saldiri_taban": 1, "saldiri_artis_araligi": 2, "savunma_bolen": 2,
    "beyan_akce_min": 2, "beyan_akce_max": 8, "yalan_olasiligi": 0.35,
    "gizli_akce_min": 8, "gizli_akce_max": 20, "gizli_esya_olasiligi": 0.4,
    "teklif_orani": 0.5, "gasp_halk_cezasi": 1, "durust_arama_cezasi": 1,
    "sira_olay_olasiligi": 0.35,
    "okculuk_ok": 3, "okculuk_hiz": 0.45, "okculuk_hiz_artis": 0.12, "okculuk_merkez": 0.15, "okculuk_halka": 0.42,
    "harman_vurus": 8, "harman_aralik": 0.8, "harman_tolerans": 0.17,
    # Ürünler: (id, süre gece, verim ambar, tohum ambar)
    "ciftci_tarla_basina": 2, "tarla_azami": 6, "don_esigi": 1,
    "bitki_idleri": psa([b[0] for b in BITKILER]), "bitki_sureleri": pia([b[2] for b in BITKILER]),
    "bitki_verimleri": pia([b[3] for b in BITKILER]), "bitki_tohumlari": pia([b[4] for b in BITKILER]),
    # İş yerleri: (id, sınıf, uygunsuzda düşen bar: 0 Halk, 2 Tüccarlar, 3 Ordu, gereken yapı)
    "is_idleri": psa(["tarla", "pazar", "kervansaray", "kisla"]),
    "is_siniflari": psa(["ciftci", "esnaf", "esnaf", "asker"]),
    "is_barlari": pia([0, 2, 2, 3]), "is_yapilari": psa(["", "", "kervansaray", ""]), "uyumsuz_ceza": 1,
    "esya_idleri": psa([e[0] for e in ESYALAR]), "esya_turleri": psa([e[2] for e in ESYALAR]),
    "esya_degerleri": pia([e[3] for e in ESYALAR]), "esya_siniflari": psa([e[4] for e in ESYALAR]),
    "esya_gizli": pia([e[5] for e in ESYALAR]),
})

# ─── Adlı karakterler ────────────────────────────────────────────────────
# etki sırası: Halk, Soylular, Tüccarlar, Ordu
KARAKTERLER = [
    # sorular: (ziyaret, soru, cevap, [takip]) — takip: (soru, cevap, [takip]); bir soru sorulunca takipleri açılır.
    # acilislar: ziyaret başına, gelen kapıya varınca kendini ve hikâyesini anlattığı söz.
    dict(id="miraen", ad="Miraen", koken="yabanci", sinif="asker", kural="hic_donmez", erken=0,
         secenekler=["kabul", "ret", "kisla"],
         etki=dict(kabul=[0, -1, 0, 1], ret=[0, 0, 0, -1], kisla=[-1, 0, 0, 2]),
         girisler=["Atsız bir atlı. Kılıcının kını kırık; bakışı hep arkasındaki yolda."],
         acilislar=["Selam sana, kapıcı. Atımı da sancağımı da Kösedağ'da bıraktım. Üç gündür yürüyorum; arkamdan gelen olur mu diye dönüp duruyorum."],
         sorular=[(0, "Kimsin?", "Miraen. Gürcü'yüm. Sultanın ordusundaydım.", [
                      ("Gürcü ne arar sultanın ordusunda?", "Bizim beyler sultana bağlıydı, biz de onların atlısıyız. Sancak değişir, at aynı kalır.", [
                          ("Şimdi kime bağlısın?", "Kimseye. Bu kadar özgür olacağımı hiç düşünmezdim. Hoşuma da gitmiyor.", [])]),
                      ("Rütben neydi?", "Yüz atlının başıydım. Şimdi yüz adımlık yolun başındayım.", [])]),
                  (0, "Atın nerede?", "Kösedağ'da kaldı. Ben kalmadım.", [
                      ("Nasıl kurtuldun?", "Atım vuruldu, altında kaldım. Gece olunca ölülerin arasından kalktım.", [
                          ("Sonra?", "Sonra yürüdüm. Moğol ateşlerinden uzak, dereleri izleyerek.", [])]),
                      ("Kılıcın neden kırık?", "Kın kırık, kılıç sağlam. Kılıcı bırakmadım; kın kendini bıraktı.", [])]),
                  (0, "Birliğin nerede?", "Birlik mi... Dağıldı. Herkes dağıldı. (Gözlerini kaçırıyor.)", [
                      ("Seni arayan var mı?", "Kaçanları sayan biri hep olur. (Arkasındaki yola bakıyor.)", [
                          ("Kaçtın mı yani?", "Herkes kaçtı. Ben biraz daha geç kaçtım.", [])]),
                      ("Arkadaşların?", "İkisi benimle yürüdü. Biri dereyi geçemedi; öteki geçti ve gitti.", [])])]),
    dict(id="sorhan", ad="Sorhan", koken="yabanci", sinif="esnaf", kural="birden_cok_gelir", n=3, erken=1,
         secenekler=["kabul", "ret", "rusvet", "kisla"],
         etki=dict(kabul=[0, 0, 1, 1], ret=[0, 0, -1, 0], rusvet=[-1, 0, 2, 0], kisla=[0, -1, 0, 1]),
         girisler=["Üç atı yedeğinde bir Kıpçak. Atların ikisinde yabancı bir damga var.",
                   "Sorhan yine. Bu sefer yanında bir kadın ve iki çocuk. Atlardan biri eksik.",
                   "Sorhan. Yalnız. Ne at var ne aile."],
         acilislar=["Hey kapıcı! At lazım mı? İyi at bunlar, Moğol atından uslu. Ben Sorhan, Kıpçak'ım; hangi kapı açılırsa oraya giderim.",
                    "Yine ben. Bu sefer yalnız değilim: karım, iki çocuğum. Geçen sefer yolda bekliyorlardı; bu sefer bekleyecek yer kalmadı.",
                    "Sorhan. Hatırlarsın. Atlar yok, aile yok. Bir ben kaldım, bir de bu kapı."],
         sorular=[(1, "Kimsin?", "Sorhan. At satarım, alan olursa.", [
                      ("Nereden geliyorsun?", "Bozkırdan. Kıpçak obası dağıldı; Moğol bizi önce kendine kattı, sonra tükürdü.", [
                          ("Neden ayrıldın?", "Atlarını ben güdüyordum. Bir gece atları kendim için güttüm.", [])])]),
                  (1, "Bu atlar senin mi?", "Şimdi benim.", [
                      ("Damga kimin?", "Damga eski sahibin, at yeni sahibin. Damga yalan söylemez ama her şeyi de söylemez.", [
                          ("Eski sahibi nerede?", "Ya öldü ya beni arıyor. İkisi de benim derdim değil, değil mi?", [])]),
                      ("Kaça satarsın?", "Sana mı? Bir gece uyku, bir kap çorba. Başkasına beş akçe.", [])]),
                  (1, "Nereye gidiyorsun?", "Neresi kapı açarsa.", [
                      ("Ailen var mı?", "Var. Yolda bekliyorlar. Yer bulursam getireceğim.", [])]),
                  (2, "Bunlar kim?", "Karım, çocuklarım. Geçen sefer yolda bekliyorlardı.", [
                      ("Karının adı ne?", "Ayaz. Benden iyi ata biner, söylemesi ayıp.", []),
                      ("Çocuklar aç mı?", "Dün yediler. Bugünü sorma.", [])]),
                  (2, "Bir at nerede?", "Yol parası oldu.", [
                      ("Kime verdin?", "Bir Türkmen beyinin adamlarına. Geçit için at istediler. Bir at, bir aileye bedel.", [])]),
                  (2, "Neden geri geldin?", "Başka kapı açılmadı.", [
                      ("Başka kapıları denedin mi?", "Üçünü. Biri kapalıydı, biri yanmıştı, biri bize ok attı.", [])]),
                  (3, "Ailen nerede?", "Bir kervana verdim onları. Güneye.", [
                      ("Neden onlarla gitmedin?", "Kervancı üç kişi aldı. Ben dördüncüydüm.", [
                          ("Bir daha görecek misin?", "Halep'te bir han var, adı Kırmızı Kapı. Orada bekleyecekler. Beklerlerse.", [])])]),
                  (3, "Atlar?", "Atlar gitti. Ben kaldım.", [
                      ("Atsız ne yapacaksın?", "At bakmayı bilirim. Atı olan bir köy bulursam onun atlarına bakarım.", [])]),
                  (3, "Ne istiyorsun?", "Bir yer. Sadece bir yer.", [
                      ("Neden burası?", "Çünkü yolum hep buraya çıkıyor. Bu da bir hesap.", [])])]),
    dict(id="thessra", ad="Thessra", koken="yabanci", sinif="esnaf", kural="oranla_doner", erken=1,
         secenekler=["kabul", "ret", "rusvet"],
         etki=dict(kabul=[1, 0, 1, -1], ret=[-1, 0, 0, 0], rusvet=[0, 1, 1, -1]),
         girisler=["Kucağında tahta bir kutu taşıyan genç bir kadın.",
                   "Thessra yine kapıda. Kutusu daha hafif görünüyor."],
         acilislar=["Akşamın hayrolsun. Ben Thessra, Trabzonlu bir hekimin kızıyım. Babamı yolda gömdüm; elimde onun kutusu kaldı. Kutudakiler acıyı dindirir.",
                    "Yine ben. Kervan beni de kutuyu da istemedi. Kutu hafifledi; yol uzundu, ağrıyan çoktu."],
         sorular=[(1, "Kimsin?", "Thessra. Trabzon'dan. Babam hekimdi.", [
                      ("Trabzon'dan buraya neden?", "Babam Sivas'ta bir beye bakıyordu. Bey öldü, şehir yandı. Trabzon'a dönmeye çalışırken yol bizi buraya çıkardı.", []),
                      ("Sen de hekim misin?", "Yıllarca babamın elini tuttum. Yara sarmayı bilirim. Bana kimse hekim demez; kadınım çünkü.", [
                          ("Burada ne yaparsın?", "Ateş düşürürüm, yara sararım, doğuma yardım ederim. İsteyen olursa.", [])])]),
                  (1, "Kutuda ne var?", "İlaç. Ağrıya iyi gelir... başka şeye de.", [
                      ("Başka şey ne?", "Uyku. Fazlası derin uyku. Çok fazlası... uyanmamak.", [
                          ("Bunu neden söyledin?", "Sorarsın diye. Sormasaydın söylemezdim.", [])]),
                      ("Bir şişe ver bakalım.", "Ağrın yoksa vermem. Babam böyle öğretti.", [])]),
                  (1, "Baban nerede?", "Yolda gömdük.", [
                      ("Nasıl öldü?", "Hasta bir çocuğa baktı; çocuğun öksürüğü ona geçti. İyileştirdiği son kişi o çocuktu.", [])]),
                  (2, "Neden döndün?", "Kervan beni de kutuyu da istemedi.", [
                      ("Neden istemediler?", "Kutuda zehir var dediler. Var. Her ilaç biraz zehirdir.", [])]),
                  (2, "Kutu boşaldı mı?", "Yarısı. Yol uzun.", [
                      ("Kime harcadın?", "Bir bebeğin ateşine, bir askerin bacağına, bir yaşlının son gecesine.", [])]),
                  (2, "Kime sattın?", "Satmadım. Verdim. Ağrıyan çoktu.", [
                      ("Para almadan mı?", "Ağrıyandan para alınmaz. Ağrısı geçince verirse alırım.", [])])]),
    dict(id="karaca_usta", ad="Karaca Usta", koken="yerel", sinif="esnaf", kural="oranla_doner", erken=2,
         secenekler=["kabul", "ret", "rusvet", "kisla"],
         etki=dict(kabul=[1, 0, 1, 0], ret=[-1, 0, -1, 0], rusvet=[0, 1, -1, 0], kisla=[0, 0, -1, 1]),
         girisler=["Belinde şed bağlı bir usta. Yanında iki çırak.",
                   "Karaca Usta yine geldi. Çıraklardan biri yok."],
         acilislar=["Selamünaleyküm. Karaca derler; Kayseri'de tabakhanem vardı. Moğol geldi, deriler de ocak da yandı. Bu iki çırak, ocağımdan kalanlar.",
                    "Yine Karaca. Çıraklardan birini başka bir ustaya verdim, aç kalmasın diye. Ocak sorar: kapı neden kapandı? Cevabım olsun istedim."],
         sorular=[(1, "Kimsin?", "Karaca derler. Kayseri'de tabakhanem vardı. Yandı.", [
                      ("Ne iş yaparsın?", "Ham deriyi alırım; çarık olur, kemer olur, eyer olur. Sabır ister; deri aceleciyi sevmez.", []),
                      ("Tabakhane nasıl yandı?", "Moğol şehri almadı, yaktı. Biz derileri kurtaralım derken ocağı kaybettik.", [])]),
                  (1, "Bunlar kim?", "Çıraklarım. Ben neredeysem onlar orada.", [
                      ("Adları ne?", "Biri Hasan, biri Musa. Hasan sabırsız, Musa sessiz. İkisi birden bir usta eder.", [])]),
                  (1, "Ahi ocağın ne der?", "Ocağa borcum var. Ödeyeceğim, vakti gelince.", [
                      ("Ne borcu?", "Yola çıkarken ocağın sandığından akçe aldım. Ahi borcu unutmaz; ben de unutmam.", [
                          ("Ahiler kim?", "Esnafın kardeşliği. Birbirimize kefil oluruz. Bir usta yalan söylerse hepimiz utanırız.", [])])]),
                  (2, "Çırağın nerede?", "Başka bir ustaya verdim. Aç kalmasın diye.", [
                      ("Hangisini verdin?", "Musa'yı. Sessiz olanı. Sessizler az yer, çok çalışır.", [])]),
                  (2, "Neden döndün?", "Ocak sorar: kapı neden kapandı? Cevabım olsun istedim.", [
                      ("Cevabın ne?", "Henüz yok. Belki sen verirsin.", [])])]),
    dict(id="aydogdu", ad="Aydoğdu", koken="yerel", sinif="asker", kural="hic_donmez", erken=3,
         secenekler=["kabul", "ret", "kisla"],
         etki=dict(kabul=[1, -1, 0, 1], ret=[-1, 0, 0, 0], kisla=[0, -1, 0, 2]),
         girisler=["Kolu sargılı bir okçu. Sırtında yay, belinde sadak."],
         acilislar=["Aydoğdu. Türkmen'im, okçuyum. Kolum yaralı ama yayı hâlâ gerebilirim. Arkamdan obam geliyor; önden ben bakayım dedim."],
         sorular=[(0, "Kimsin?", "Aydoğdu. Türkmen'im.", [
                      ("Hangi boydan?", "Avşar. Babam beydi, ben değilim. Bey olmak için önce sağ kalmak gerek.", [])]),
                  (0, "Yaran ne?", "Kösedağ'dan hatıra.", [
                      ("Ağrıyor mu?", "Yayı gerince. Gerince her şey ağrır zaten.", []),
                      ("Kim sardı?", "Kendim. Dişimle. Pek güzel olmadı.", [])]),
                  (0, "Yalnız mısın?", "Şimdilik. (Arkasındaki yola bakıyor.)", [
                      ("Arkanda kim var?", "Obam. Yirmi kişi, otuz koyun. Yer varsa getiririm.", [
                          ("Ya yer yoksa?", "O zaman yürürüz. Türkmen yürümeyi bilir.", [])])])]),
    dict(id="saruca_hatun", ad="Saruca Hatun", koken="yerel", sinif="ciftci", kural="birden_cok_gelir", n=2, erken=0,
         secenekler=["kabul", "ret", "rusvet"],
         etki=dict(kabul=[1, 0, 0, 0], ret=[-1, 0, 0, 0], rusvet=[-1, 1, 1, 0]),
         girisler=["Kucağında çocuk, yorgun bir kadın.",
                   "Saruca Hatun yine. Bu sefer sırtında bir çuval."],
         acilislar=["Allah'ın selamı üzerine olsun. Ben Saruca, Sivas köylerindenim. Kocamı tarlada bıraktık. Kucağımdaki çocuk için bir çatı arıyorum, başka bir şey değil.",
                    "Yine geldim. Bu sefer sırtımda tohum var; çocuğu bir hana bıraktım. Tohumu toprağa koymadan ölürsem bu yük boşa taşınmış olur."],
         sorular=[(1, "Kimsin?", "Saruca. Sivas'ın köylerindendim.", [
                      ("Köyün ne oldu?", "Atlılar geldi, ambarı boşalttılar, sonra damları yaktılar. Biz dereye saklandık.", [])]),
                  (1, "Kocan nerede?", "Yoktur artık.", [
                      ("Ne oldu ona?", "Tarladan dönmedi. Bulduğumuzda geç kalmıştık. (Sesi hiç değişmiyor.)", [])]),
                  (1, "Ne istersin?", "Çocuğa bir çatı.", [
                      ("Sen ne iş yaparsın?", "Ekerim, biçerim, harman ederim. Bir tarla verirsen karnımızı ben doyururum.", [])]),
                  (2, "Çuvalda ne var?", "Tohum. Yemeyiz, ekeriz. Toprak verirseniz.", [
                      ("Ne tohumu?", "Buğday, biraz da mercimek. Buğday kışa dayanır, mercimek çabuk biter.", [])]),
                  (2, "Çocuk nerede?", "Bir hana bıraktım. Tohumu getirmek için.", [
                      ("Güvenli mi orası?", "Hancı kadın iyi biri. Ama han handır; bugün var, yarın yok.", [])]),
                  (2, "Kış yaklaşıyor.", "Biliyorum. Tohum da biliyor.", [])]),
    dict(id="ayse_baci", ad="Ayşe Bacı", koken="yerel", sinif="esnaf", kural="oranla_doner", erken=2, portre="farmer_02",
         secenekler=["kabul", "ret", "rusvet"],
         etki=dict(kabul=[1, 0, 1, 0], ret=[-1, 0, 0, 0], rusvet=[0, 1, 0, -1]),
         girisler=["Sırtında katlanmış bir dokuma tezgâhı taşıyan orta yaşlı bir kadın. Yanında iki genç kız.",
                   "Ayşe Bacı yine geldi. Tezgâhın bir ayağı kırık."],
         acilislar=["Hayırlı akşamlar. Ben Ayşe, Kayseri'de bacılardandım. Bu kızlara dokumayı ben öğretiyorum. Tezgâh sırtımda; ev neredeyse tezgâh orada kurulur.",
                    "Yine biz. Tezgâhın bir ayağı kırıldı ama ellerimiz sağlam. Başka uçta kapı var, ocak yok; burada olacak diye duydum."],
         sorular=[(1, "Kimsin?", "Ayşe derler. Kayseri'de bacılardandım. Dokuruz, öğretiriz.", [
                      ("Bacılar kim?", "Kadınların ocağı. Erkekler ahi olur, biz bacı. Biri olmazsa öteki eksik kalır.", [])]),
                  (1, "Bu kızlar kim?", "Çıraklarım. Yolda annelerini yitirdiler.", [
                      ("Ne öğreniyorlar?", "Yünü eğirmeyi, boyamayı, kilim dokumayı. Bir kilim bir kışı geçirir.", [])]),
                  (1, "Bacılar ne iş yapar?", "Erkekler ocakta, biz tezgâhta. Biri olmazsa öteki eksik kalır.", [
                      ("Dokuduğunuz satılır mı?", "Satılır. İyi bir kilim üç akçe eder, çok iyisi beş.", [])]),
                  (2, "Tezgâha ne oldu?", "Bir dere geçerken kırıldı. Elimiz kırılmadı ama.", [
                      ("Tamir edilir mi?", "Bir marangoz bulursam bir günde. Bulamazsam bir haftada, kendim.", [])]),
                  (2, "Neden döndün?", "Başka uçta kapı var ama ocak yok. Burada olacak diye duydum.", [
                      ("Kimden duydun?", "Yolda bir dervişten. Dervişler her şeyi duyar, yarısını söyler.", [])])]),
    dict(id="hasan_celebi", ad="Hasan Çelebi", koken="yerel", sinif="esnaf", kural="hic_donmez", erken=4, portre="craftsman_01",
         secenekler=["kabul", "ret", "rusvet", "kisla"],
         etki=dict(kabul=[-1, 2, 0, 0], ret=[0, -2, 0, 0], rusvet=[0, 1, 1, 0], kisla=[0, -1, 0, 1]),
         girisler=["İyi dikilmiş bir kaftan, mürekkep lekeli parmaklar. Yanında defterler dolu bir heybe."],
         acilislar=["Hasan, Sivas divanının kâtibi. Kimin ne borçlu olduğunun defterini taşıyorum. Moğol da sorar, bey de; cevap bende."],
         sorular=[(0, "Kimsin?", "Hasan. Sivas divanında kâtiptim. Vergi yazardım.", [
                      ("Kâtip ne iş yapar?", "Herkesin unutmak istediğini hatırlar.", [])]),
                  (0, "Bu defterler ne?", "Kimin ne borçlu olduğu. Moğol da sorar, bey de.", [
                      ("Neden yakmadın?", "Yakmak kolay. Ama yakarsam kimin ne ödediğini de kimse bilmez. Borç da yanar, alacak da.", [
                          ("Moğol'a verir misin?", "Kim kapıyı açarsa ona okurum. Bu kadar dürüstüm.", [])])]),
                  (0, "Burada ne işin var?", "Bir köy kayıtsız yaşamaz. Ben kaydederim; sen yönetirsin.", [])]),
    dict(id="nogay", ad="Nogay", koken="yabanci", sinif="asker", kural="birden_cok_gelir", n=2, erken=5, portre="soldier_01",
         secenekler=["kabul", "ret", "kisla"],
         etki=dict(kabul=[-1, 0, 1, 1], ret=[0, 0, 0, -1], kisla=[-1, -1, 0, 2]),
         girisler=["Bozkır biçimi kalpaklı, sessiz bir adam. Atını yedeğinde değil, elinde tutuyor.",
                   "Nogay yine geldi. Bu sefer atı yok; ayakları sargılı."],
         acilislar=["Nogay. Moğol beyinin dilmacıydım; onun sözünü Türkçeye çevirirdim. Çevirdiğim sözler köyleri yaktı. Çevirmekten yoruldum.",
                    "Yine Nogay. Atım yok; bir Türkmen obası aldı, karşılığında beni öldürmediler. Adil bir alışveriş."],
         sorular=[(1, "Kimsin?", "Nogay. Dilmaçtım. Moğol beyinin sözünü Türkçeye çevirirdim.", [
                      ("Kaç dil bilirsin?", "Dört. Beşincisi susmaktı; onu geç öğrendim.", [])]),
                  (1, "Neden kaçtın?", "Çevirdiğim sözler köyleri yaktı. Ben çevirmekten yoruldum.", [
                      ("Hangi sözler?", "'Teslim olun, kimseye dokunulmayacak.' Her köyde aynı sözü çevirdim. Hiçbirinde doğru çıkmadı.", [])]),
                  (1, "Moğollar nerede?", "Arkamda değil. Ama uzak da değil.", [
                      ("Buraya gelirler mi?", "Gelirler. Önce bir elçi, sonra bir söz, sonra ateş. Sırayı bilirim.", [])]),
                  (2, "Atın nerede?", "Bir Türkmen obası aldı. Karşılığında beni öldürmediler.", []),
                  (2, "Bu kez ne istiyorsun?", "Bir yer. Kimsenin sözünü çevirmediğim bir yer.", [
                      ("Bir şey bilirsen söyler misin?", "Sorarsan söylerim. Sormazsan da bazen.", [])])]),
    dict(id="yusuf", ad="Yusuf", koken="yerel", sinif="ciftci", kural="oranla_doner", erken=3, portre="farmer_01",
         secenekler=["kabul", "ret", "kisla"],
         etki=dict(kabul=[2, 0, 0, -1], ret=[-1, 0, 0, 0], kisla=[-2, 0, 0, 1]),
         girisler=["On iki yaşlarında bir oğlan. Elinde bir keçi ipi, ucunda keçi yok.",
                   "Yusuf yine kapıda. Daha zayıf."],
         acilislar=["Selam... Adım Yusuf. Keçimi arıyorum; ip bende kaldı. Karnım da aç, ama önce keçi.",
                    "Yine ben, Yusuf. Bir değirmencinin yanındaydım; değirmen de gitti. Keçi hâlâ dönmedi."],
         sorular=[(1, "Adın ne?", "Yusuf.", [
                      ("Kaç yaşındasın?", "On iki. Ya da on üç. Annem bilirdi.", [])]),
                  (1, "Ailen nerede?", "Kösedağ'a babam gitti. Annem yolda kaldı.", [
                      ("Yolda mı kaldı?", "Ateşi vardı. Bir sabah kalkmadı. Ben de ipi aldım, yürüdüm.", [])]),
                  (1, "Keçin nerede?", "İp bende kaldı. Keçi kaçtı. Belki döner.", [
                      ("Keçinin adı ne?", "Karabaş. Ama başı ak. Babam şakadan koymuş.", [])]),
                  (2, "Nerede kaldın?", "Bir değirmencinin yanında. Sonra değirmen de gitti.", [
                      ("Değirmene ne oldu?", "Askerler un istedi, değirmenci vermedi. Sonra değirmen yandı.", [])]),
                  (2, "Ne iş bilirsin?", "Keçi güderim. Bir de beklerim.", [
                      ("Neyi beklersin?", "Babamı. Keçiyi. Akşamı. Hepsi bir gün gelir.", [])])]),
]


def duzle(liste, ust=-1, cikti=None):
    """Soru ağacını düz listeye çevirir: [(ziyaret, soru, cevap, ust_indeks)]. Kök: (z, s, c, [takip]); takip: (s, c, [takip])."""
    if cikti is None:
        cikti = []
    for oge in liste:
        if len(oge) == 4 and isinstance(oge[0], int):
            z, s, c, takip = oge
        else:
            s, c, takip = oge
            z = cikti[ust][0]
        cikti.append((z, s, c, ust))
        duzle(takip, len(cikti) - 1, cikti)
    return cikti


# karakterler/CHR_001–030: sayfalardan ayrıştırılır (tools/icerik/karakter_sayfalari.py)
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from karakter_sayfalari import EL_ESYALARI  # noqa: E402
from karakter_sayfalari import karakterler as _chr_karakterleri  # noqa: E402
KARAKTERLER += _chr_karakterleri()[0]
# Elde taşınan eşyalar: model adı → [[eşya, el]] (src/dunya/el_esyasi.gd okur)
with open(os.path.join(KOK, "data", "el_esyalari.json"), "w", encoding="utf-8") as _f:
    json.dump({k: [list(x) for x in v] for k, v in sorted(EL_ESYALARI.items())}, _f, ensure_ascii=False, indent=1)
    _f.write("\n")

for k in KARAKTERLER:
    i = k["id"]
    ad = t("karakter.%s.ad" % i, k["ad"])
    alan = {
        "id": sn(i), "ad_anahtari": sn(ad), "koken": sn(k["koken"]), "sinif": sn(k["sinif"]),
        "sohbet_id": sn(i), "karar_secenekleri": psa(k["secenekler"]),
        "donus_kurali": sn(k["kural"]), "en_erken_gece": k["erken"], "portre": sn(k.get("portre", i)),
        "p0": 0.6, "d": 0.5, "k_azami": 4, "n_ziyaret": k.get("n", 1), "g_min": 2, "g_max": 4,
        "azami_soru": k.get("azami_soru", 0), "tehlikeli": k.get("tehlikeli", False),
        "zanaat": k.get("zanaat", 0), "gizli_bayraklar": psa(k.get("gizli", [])),
    }
    for karar in ("kabul", "ret", "rusvet", "kisla"):
        alan["etki_" + karar] = pia(k["etki"].get(karar, [0, 0, 0, 0]))
    tres("data/karakterler/%s.tres" % i, "KarakterVerisi", "res://src/veri/karakter_verisi.gd", alan)
    girisler = [t("sohbet.%s.giris%d" % (i, n + 1), g) for n, g in enumerate(k["girisler"])]
    acilislar = [t("sohbet.%s.acilis%d" % (i, n + 1), a) for n, a in enumerate(k["acilislar"])]
    sorular, cevaplar, ziyaret, ust, bayraklar = [], [], [], [], []
    for n, (z, s, c, u) in enumerate(duzle(k["sorular"])):
        bayraklar.append(",".join(k.get("gizli", [])) if s in k.get("kanit_sorulari", ()) else "")
        sorular.append(t("sohbet.%s.s%d" % (i, n + 1), s))
        cevaplar.append(t("sohbet.%s.c%d" % (i, n + 1), c))
        ziyaret.append(z)
        ust.append(u)
    tres("data/sohbetler/%s.tres" % i, "SohbetVerisi", "res://src/veri/sohbet_verisi.gd", {
        "id": sn(i), "giris_anahtarlari": psa(girisler), "acilis_anahtarlari": psa(acilislar),
        "soru_anahtarlari": psa(sorular), "cevap_anahtarlari": psa(cevaplar), "soru_ziyareti": pia(ziyaret),
        "soru_ust": pia(ust), "soru_bayraklari": psa(bayraklar)})

# ─── Sınıf şablonları ─────────────────────────────────────────────────────
# çeşit: (portre, giriş anlatısı, açılış sözü, sorular [(soru, cevap, [takip])])
SINIFLAR = [
    dict(id="ciftci",
         adlar=["Yorgun bir çiftçi", "Irgat bir kadın", "Sivaslı bir rençber", "Bir orakçı"],
         cesitler=[("farmer_01", "Sırtında boyunduruk taşıyan bir adam. Öküzü yok.",
                    "Akşam hayrola. Rençberim; öküzüm yolda öldü, boyunduruğu bırakamadım. Toprak verirseniz sabanı ben çekerim.",
                    [("Öküzün nerede?", "Yolda öldü. Boyunduruğu bırakamadım.", [
                         ("Neden taşıyorsun boyunduruğu?", "Öküz ölür, boyunduruk kalır. Belki başka öküz bulurum.", [])]),
                     ("Ne iş bilirsin?", "Toprak. Başka bir şey bilmem.", [
                         ("Ne ekersin?", "Buğday, arpa. Toprak iyiyse nohut.", [])]),
                     ("Nereden geliyorsun?", "Sivas'ın ovasından. Ova yandı.", [
                         ("Kim yaktı?", "Kim yakmadı ki? Önce Moğol geçti, sonra bizimkiler kalanı aldı.", [])])]),
                   ("farmer_02", "Elleri nasırlı bir kadın, yalnız.",
                    "Selam. Ben tarlada çalışırım; kocam tarlada kaldı. Hasada kadar bir iş, bir köşe isterim.",
                    [("Kimin nesisin?", "Kocam tarlada kaldı.", [
                         ("Çocuğun var mı?", "Vardı. (Başka bir şey demiyor.)", [])]),
                     ("Ne istersin?", "Hasat zamanı iş.", [
                         ("Hasada daha çok var.", "O zamana kadar ot yolarım, su taşırım. Boş durmam.", [])]),
                     ("Yalnız mı yürüdün?", "Yolda kimse kimseyi beklemiyor.", [
                         ("Yolda ne gördün?", "Boş köyler. Bir de yolun kenarına dizilmiş taşlar. Kim dizdi bilmiyorum.", [])])])],
         secenekler=["kabul", "ret", "rusvet", "kisla"],
         etki=dict(kabul=[1, 0, 0, 0], ret=[-1, 0, 0, 0], rusvet=[-1, 0, 1, 0], kisla=[0, 0, 0, 1])),
    dict(id="esnaf",
         adlar=["Bir Ahi çırağı", "Seyyar bir bakırcı", "Bir keçeci", "Bir semerci"],
         cesitler=[("craftsman_01", "Elinde alet torbası, genç bir çırak.",
                    "Selam usta... yani kapıcı. Ustamı yolda kaybettim. Deri işlerim, biraz da demir. Bir ocak bulursam yeniden başlarım.",
                    [("Ustan nerede?", "Yolda kaybettim. Arıyorum.", [
                         ("Nasıl kaybettin?", "Bir kalabalıkta elini bıraktım. Sonra kalabalık dağıldı, usta da.", [])]),
                     ("Ne iş yaparsın?", "Deri. Biraz da demir.", [
                         ("En iyi neyi yaparsın?", "Kemer tokası. Ustam 'senin tokan kemeri sever' derdi.", [])]),
                     ("Ocağın hangisi?", "Kayseri'nin. Ocak yerinde mi, bilmem.", [
                         ("Ahi misin?", "Henüz değil. Şed kuşanmama bir yıl vardı.", [])])]),
                   ("craftsman_01", "Sırtında birkaç bakır kap.",
                    "Bakırcıyım; tas, kepçe, kazan. Malım bu kadar kaldı, borcum daha çok. Kervansaray varsa orada satarım.",
                    [("Malın bu kadar mı?", "Kalan bu. Borcum daha çok.", [
                         ("Kalanı ne oldu?", "Yol aldı. Biri bir tasa ekmek verdi, biri bir kazana geçit.", [])]),
                     ("Nereye gidiyorsun?", "Kervansaray varsa oraya.", [
                         ("Kervansaray yoksa?", "O zaman pazara. Pazar da yoksa kapının dibine. Bakır her yerde satılır.", [])]),
                     ("Kime borçlusun?", "Bir Rum tüccara. O da yolda bir yerde.", [
                         ("Ödeyecek misin?", "Bulursam. Bulamazsam borç bende kalır.", [])])])],
         secenekler=["kabul", "ret", "rusvet", "kisla"],
         etki=dict(kabul=[0, 0, 1, 0], ret=[0, 0, -1, 0], rusvet=[0, 1, 1, -1], kisla=[0, 0, -1, 1])),
    dict(id="asker",
         adlar=["Yaralı bir asker", "Bir firari", "Yaya bir sipahi", "Bir sınır bekçisi"],
         cesitler=[("soldier_01", "Sargısı kirlenmiş bir asker.",
                    "Bir yudum su, bir köşe. Yaralıyım ama yürüyorum. Kimin adamı olduğumu sorma; artık kimsenin değilim.",
                    [("Kimin adamısın?", "Artık kimsenin.", [
                         ("Önce kimin adamıydın?", "Bir sipahinin. Kösedağ'da öldü; onu taşıyamadım.", [
                             ("Adı neydi?", "Bahadır Bey. Söylesem bilmezsin. Bilen kalmadı.", [])]),
                         ("Kimsenin olmak nasıl?", "Hafif. Kimse emir vermiyor. Kimse ekmek de vermiyor.", [
                             ("Yeniden birine bağlanır mısın?", "Ekmek veren, ok atmayı bilen birine bağlanırım. Sen misin?", [])])]),
                     ("Yaran ağır mı?", "Yürüyorum, değil mi?", [
                         ("Bakayım mı?", "Bakma. Bakınca kötüleşiyor sanki.", [])]),
                     ("Savaşta mıydın?", "Herkes savaştaydı. Sonra herkes yoldaydı.", [
                         ("Neler gördün?", "Çok şey. Çoğunu unutmaya çalışıyorum. Unutamadıklarım benimle yürüyor.", [])])]),
                   ("soldier_01", "Gözleri sürekli yolda olan bir adam.",
                    "Akşamın hayrolsun. Silahımı bıraktım, adımı da bırakmak isterim. Bir gece, bir köşe; sabah ola hayrola.",
                    [("Kimden kaçıyorsun?", "Herkes bir şeyden kaçıyor bu yolda.", [
                         ("Senin kaçtığın ne?", "Bir çavuş. Bir liste. Listede adım var mı, bilmiyorum. Varmış gibi yürüyorum.", [])]),
                     ("Silahın var mı?", "Bıraktım.", [
                         ("Nereye bıraktın?", "Bir dereye. Su iyi saklar.", [])]),
                     ("Peşinde biri var mı?", "Olsaydı bu kadar yavaş yürür müydüm?", [
                         ("Ya olsaydı?", "O zaman burada durup seninle konuşmazdım, kapıcı.", [])])])],
         secenekler=["kabul", "ret", "rusvet", "kisla"],
         etki=dict(kabul=[0, -1, 0, 1], ret=[0, 0, 0, -1], rusvet=[0, 1, 0, -1], kisla=[-1, 0, 0, 2])),
]

for s in SINIFLAR:
    i = s["id"]
    adlar = [t("sablon.%s.ad%d" % (i, n + 1), a) for n, a in enumerate(s["adlar"])]
    girisler, acilislar, portreler, sorular, cevaplar, cesit, ust = [], [], [], [], [], [], []
    for c, (portre, giris, acilis, ss) in enumerate(s["cesitler"]):
        girisler.append(t("sablon.%s.giris%d" % (i, c + 1), giris))
        acilislar.append(t("sablon.%s.acilis%d" % (i, c + 1), acilis))
        portreler.append(portre)
        taban = len(sorular)
        for n, (_z, soru, cevap, u) in enumerate(duzle([(0,) + tuple(x) for x in ss])):
            sorular.append(t("sablon.%s.c%d_s%d" % (i, c + 1, n + 1), soru))
            cevaplar.append(t("sablon.%s.c%d_c%d" % (i, c + 1, n + 1), cevap))
            cesit.append(c)
            ust.append(-1 if u < 0 else taban + u)
    alan = {"id": sn(i), "sinif": sn(i), "ad_havuzu": psa(adlar), "giris_anahtarlari": psa(girisler),
            "acilis_anahtarlari": psa(acilislar), "portreler": psa(portreler), "soru_anahtarlari": psa(sorular),
            "cevap_anahtarlari": psa(cevaplar), "soru_cesidi": pia(cesit), "soru_ust": pia(ust),
            "karar_secenekleri": psa(s["secenekler"])}
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
    dict(id="tarla_yagmur", baslik="Bereketli yağmur", kosul={"tarla_ekili_min": 1}, agirlik=2, tek=False,
         metin="Gece boyu ince ince yağmur yağdı. Sabah tarlalar ışıldıyordu.",
         secenekler=[("Şükret", {"tarla_gun": 1}, "Ekinler bir gecede bir karış uzadı."),
                     ("Ark kazdır, suyu tut (2 akçe)", {"gerekli": {"akce": 2}, "tarla_gun": 2}, "Arklardan su şırıldadı. Ekinler iki gecelik yol aldı.")]),
    dict(id="tarla_kuraklik", baslik="Kuraklık", kosul={"tarla_ekili_min": 1, "gece_min": 2}, agirlik=2, tek=False,
         metin="Günlerdir yağmur yok. Toprak çatladı, ekinler boynunu büktü.",
         secenekler=[("Kuyudan su taşıt", {"bar": [-1, 0, 0, 0]}, "Halk bütün gün kova taşıdı. Ekinler kurtuldu, sırtlar ağrıdı."),
                     ("Bekle, yağmur gelir", {"tarla_gun": -1}, "Yağmur gelmedi. Ekinler bir gece geriledi.")]),
    dict(id="tarla_cekirge", baslik="Çekirge", kosul={"tarla_ekili_min": 1, "gece_min": 3}, agirlik=1, tek=False,
         metin="Doğudan bir çekirge bulutu geliyor. Gökyüzü vızıldıyor.",
         secenekler=[("Duman yak, kov (1 ambar)", {"gerekli": {"ambar": 1}}, "Islak samanı yaktınız. Çekirgeler tarlaların üstünden geçip gitti."),
                     ("Kaderine bırak", {"tarla_verim": 0.5}, "Çekirgeler bir gece kaldı. Hasat yarıya indi.")]),
    dict(id="tarla_don", baslik="Erken don", kosul={"tarla_ekili_min": 1, "gece_min": 4}, agirlik=1, tek=False,
         metin="Gece ayaz çıktı. Sabaha karşı tarlaları kırağı bastı.",
         secenekler=[("Tarlaları örttür (2 akçe)", {"gerekli": {"akce": 2}}, "Keçeler, çuvallar, kilimler... Ne bulduysanız tarlaya serdiniz. Ekin kurtuldu."),
                     ("Örtecek bir şey yok", {"tarla_don": 1}, "Genç ekinler dondu. Toprağı yeniden sürmek gerekecek.")]),
    dict(id="yusuf_keci", baslik="Keçi", kosul={"koyde": ["yusuf"], "gece_min": 2}, agirlik=2,
         metin="Yusuf'un keçisi bir sabah kapının önünde bekliyordu. Yanında dört keçi daha.",
         secenekler=[("Sürü Yusuf'un olsun", {"ambar": 3, "bar": [2, 0, 0, 0]}, "Yusuf o gün ilk kez güldü."),
                     ("Keçiler köyün malı", {"ambar": 5, "bar": [-1, 0, 0, 0]}, "Ambar doldu. Yusuf ipi yine eline aldı ve bir şey demedi.")]),
    # ─── Köy içi olaylar ve mini oyunlar (design/gdd/koy-mini-oyunlari.md) ──
    # "oyun": mini oyun açar; ödül oyun_odul × puan, puan ≥ oyun_esik ise oyun_basari da uygulanır.
    dict(id="okculuk", baslik="Okçuluk yarışı", kosul={"sinif_min": {"asker": 2}, "gece_min": 2}, agirlik=2, tek=False,
         metin="Askerler kışlanın arkasına bir hedef dikmiş; köyün gençleri de sıraya girmiş. Senin de bir yay tutup tutmayacağını merak ediyorlar.",
         secenekler=[("Yayı al, sen de at", {"oyun": "okculuk", "oyun_odul": {"akce": 1}, "oyun_esik": 4, "oyun_basari": {"bar": [1, 0, 0, 1]}},
                      "Son ok da yerine oturdu. Kışladan bir uğultu yükseldi.",
                      "Oklar saman balyasına gömüldü; hedefe pek değmedi. Askerler gülmemeye çalıştı."),
                     ("Ödülü sen koy (iki akçe)", {"gerekli": {"akce": 2}, "bar": [0, 0, 0, 2]}, "Ödülü bir çoban kazandı. Ertesi gün kışlaya yazıldı."),
                     ("Ok boşa harcanmaz", {"bar": [0, 0, 0, -1]}, "Hedef söküldü. Gençler dağıldı.")]),
    dict(id="harman", baslik="Harman", kosul={"sinif_min": {"ciftci": 3}, "gece_min": 3}, agirlik=2, tek=False,
         metin="Harman yerine demetler serildi. Düveni çekecek öküzler hazır; birinin davulun ritmine uyup onları sürmesi gerek.",
         secenekler=[("Düveni sen sür", {"oyun": "harman", "oyun_odul": {"ambar": 1}, "oyun_esik": 6, "oyun_basari": {"bar": [1, 0, 0, 0]}},
                      "Saman savruldu, tane ambara aktı. Çiftçiler başını salladı.",
                      "Öküzler ritmi kaçırdı, düven sekti. Çiftçiler işi senden devraldı."),
                     ("Çiftçiler halletsin", {"ambar": 3}, "İş ağır ama sağlam gitti.")]),
    dict(id="kurt", baslik="Ağıldaki kurt", kosul={"gece_min": 3}, agirlik=2, tek=False,
         metin="Gece ağıldan uluma geldi. Sabah iki koyun eksikti; çamurda iri pençe izleri var.",
         secenekler=[("Askerleri pusuya yatır", {"gerekli": {"sinif": {"asker": 1}}, "bar": [1, 0, 0, 1]}, "Kurdun postu kapının üstüne asıldı."),
                     ("Ağılı taşla çevir (iki akçe)", {"gerekli": {"akce": 2}, "bar": [1, 0, 0, 0]}, "Taş duvar bir günde örüldü. Kurt bir daha gelmedi."),
                     ("Kaderine bırak", {"ambar": -2, "bar": [-1, 0, 0, 0]}, "Kurt üç gece daha geldi.")]),
    dict(id="yangin", baslik="Samanlıkta yangın", kosul={"nufus_min": 5, "gece_min": 2}, agirlik=1, tek=False,
         metin="Gece yarısı samanlıktan alev yükseldi. Rüzgâr evlere doğru esiyor.",
         secenekler=[("Herkes kovaya!", {"ambar": -1, "bar": [1, 0, 0, 0]}, "Kuyudan samanlığa bir insan zinciri kuruldu. Sabah herkes isliydi, ama evler ayaktaydı."),
                     ("Evleri koru, samanlık yansın", {"ambar": -3}, "Samanlık kül oldu. Evlere kıvılcım bile değmedi.")]),
    dict(id="bebek", baslik="Yeni doğan", kosul={"nufus_min": 6, "gece_min": 4}, agirlik=1,
         metin="Kapıdan geçen bir ailenin kızı köyde doğum yaptı. Köyde doğan ilk çocuk.",
         secenekler=[("Ziyafet ver (bir ambar)", {"gerekli": {"ambar": 1}, "bar": [2, 0, 0, 0]}, "Çocuğa köyün adı verildi."),
                     ("Ebeye bir akçe gönder", {"gerekli": {"akce": 1}, "bar": [1, 0, 0, 0]}, "Ebe akçeyi çocuğun beşiğine bağladı.")]),
    dict(id="pazar_gunu", baslik="Pazar günü", kosul={"yapi_min": {"pazar": 1}, "gece_min": 2}, agirlik=2, tek=False,
         metin="Komşu obalardan tüccarlar geldi. Pazar hiç bu kadar kalabalık olmamıştı.",
         secenekler=[("Bac al (pazar vergisi)", {"akce": 3, "bar": [0, 0, -1, 0]}, "Kasa doldu, tüccarlar söylendi."),
                     ("Bac alma, bol olsun", {"bar": [1, 0, 2, 0]}, "Tüccarlar gelecek ay yine geleceklerini söylediler.")]),
]

# Olay sesleri (tools/ses/ses_uret.py üretir): id → (efekt, müzik döngüsü).
OLAY_SESLERI = {
    "dugun": ("", "muzik_dugun_dongu"),
    "salgin": ("sfx_oksuruk", ""),
    "kervan": ("sfx_kervan", ""),
    "hirsizlik": ("sfx_kavga", ""),
    "tarla_yagmur": ("sfx_yagmur", ""),
    "tarla_kuraklik": ("sfx_ruzgar", ""),
    "tarla_cekirge": ("sfx_cekirge", ""),
    "tarla_don": ("sfx_ruzgar", ""),
    "sira_atlama": ("sfx_kalabalik", ""),
    "sira_kavga": ("sfx_kavga", ""),
    "sira_vazgecen": ("sfx_adim", ""),
    "sira_panik": ("sfx_at_nali", ""),
    "okculuk": ("sfx_ok", ""),
    "harman": ("sfx_hasat", ""),
    "kurt": ("sfx_kurt", ""),
    "yangin": ("sfx_kalabalik", ""),
    "pazar_gunu": ("sfx_kalabalik", ""),
    "bebek": ("", "muzik_dugun_dongu"),
}


def ses_alanlari(i):
    efekt, muzik = OLAY_SESLERI.get(i, ("", ""))
    return {"ses": sn(efekt), "muzik": sn(muzik)}


for o in OLAYLAR:
    i = o["id"]
    baslik = t("olay.%s.baslik" % i, o["baslik"])
    metin = t("olay.%s.metin" % i, o["metin"])
    secs, etkiler = [], []
    for n, secenek in enumerate(o["secenekler"]):
        sec, etki, sonuc = secenek[:3]
        secs.append(t("olay.%s.secenek%d" % (i, n + 1), sec))
        t("olay.%s.sonuc%d" % (i, n + 1), sonuc)
        if len(secenek) > 3:  # mini oyunda eşik altı puanın sonucu
            t("olay.%s.sonuc%d_az" % (i, n + 1), secenek[3])
        etkiler.append(etki)
    tres("data/olaylar/%s.tres" % i, "OlayVerisi", "res://src/veri/olay_verisi.gd", {
        "id": sn(i), "baslik_anahtari": baslik, "metin_anahtari": metin,
        "kosullar": gd(o["kosul"]), "agirlik": float(o.get("agirlik", 1)), "tek_sefer": o.get("tek", True),
        "secenek_anahtarlari": psa(secs), "secenek_etkileri": "Array[Dictionary](" + gd(etkiler) + ")",
        **ses_alanlari(i)})

# ─── Sıra olayları: iki gelen arasında kuyrukta olanlar (design/gdd/sira-olaylari.md) ──
# canlandirma: KapiSahnesi.sira_olayi() anahtarı; etki "kuyruk": -1 sıradan birini düşürür.
SIRA_OLAYLARI = [
    dict(id="sira_atlama", baslik="Sıra kapan", canlandirma="atlama", agirlik=3,
         metin="Sıranın arkasından biri dirsekleriyle öne doğru ilerliyor. Bekleyenler homurdanıyor.",
         secenekler=[("Sırasına geri gönder", {"bar": [1, 0, 0, 0], "geri": True}, "Adam söylene söylene geri döndü. Bekleyenler başlarıyla seni selamladı."),
                     ("Elindeki akçeyi al, öne geçsin", {"akce": 2, "bar": [-1, 0, 0, 0]}, "İki akçe avucuna düştü. Arkada biri yere tükürdü.")]),
    dict(id="sira_kavga", baslik="Kavga", canlandirma="kavga", agirlik=2,
         metin="Sırada iki adam bir su testisi yüzünden birbirine girdi.",
         secenekler=[("Araya gir, ayır", {"bar": [0, 0, 0, 1]}, "İkisini de bileğinden tuttun. Testiyi ikisine verdin; yarısı döküldü."),
                     ("Karışma, kendileri bitirsin", {"bar": [-1, 0, 0, 0]}, "Kavga kendi kendine bitti. Birinin kaşı yarıldı.")]),
    dict(id="sira_bayilma", baslik="Yere yığılan", canlandirma="bayilma", agirlik=2,
         metin="Sırada yaşlı bir kadın sendeledi ve yere yığıldı.",
         secenekler=[("Su ve ekmek gönder (1 ambar)", {"gerekli": {"ambar": 1}, "bar": [1, 0, 0, 0]}, "Kadın doğruldu; ekmeği ikiye bölüp yanındakine verdi."),
                     ("Sıra yürüsün", {"bar": [-1, 0, 0, 0]}, "Birileri kadını yolun kenarına çekti. Sıra yürüdü.")]),
    dict(id="sira_vazgecen", baslik="Vazgeçen", canlandirma="vazgecme", agirlik=2, kosul={"kuyruk_min": 2},
         metin="Sıranın sonundaki biri bir süre kapıya baktı, sonra döndü ve yola koyuldu.",
         secenekler=[("Seslen, geri çağır", {"geri": True}, "Seslendin. Durdu, düşündü, sonra sırasına döndü."),
                     ("Bırak gitsin", {"kuyruk": -1}, "Yol onu yuttu. Sıra bir kişi kısaldı.")]),
    dict(id="sira_panik", baslik="Arkadan atlılar", canlandirma="panik", agirlik=1,
         metin="Sıradakilerden biri bağırıyor: arkadan atlılar geliyormuş. Sıra kıpırdanıyor.",
         secenekler=[("Sakin olun, kapı açık", {"bar": [1, 0, 0, -1]}, "Sıra sustu. Kimse yerinden kıpırdamadı."),
                     ("Nöbetçileri yola sal", {"bar": [0, 0, 0, 1]}, "Nöbetçiler döndü: yolda yalnız bir kervan var.")]),
]

for o in SIRA_OLAYLARI:
    i = o["id"]
    baslik = t("olay.%s.baslik" % i, o["baslik"])
    metin = t("olay.%s.metin" % i, o["metin"])
    secs, etkiler = [], []
    for n, (sec, etki, sonuc) in enumerate(o["secenekler"]):
        secs.append(t("olay.%s.secenek%d" % (i, n + 1), sec))
        t("olay.%s.sonuc%d" % (i, n + 1), sonuc)
        etkiler.append(etki)
    kosul = dict(o.get("kosul", {}))
    kosul["canlandirma"] = o["canlandirma"]
    tres("data/sira_olaylari/%s.tres" % i, "OlayVerisi", "res://src/veri/olay_verisi.gd", {
        "id": sn(i), "baslik_anahtari": baslik, "metin_anahtari": metin,
        "kosullar": gd(kosul), "agirlik": float(o.get("agirlik", 1)), "tek_sefer": False,
        "secenek_anahtarlari": psa(secs), "secenek_etkileri": "Array[Dictionary](" + gd(etkiler) + ")",
        **ses_alanlari(i)})

# ─── Arayüz ve anlatı metinleri ──────────────────────────────────────────
ARAYUZ = {
    "arayuz.oyun.okculuk.baslik": "Okçuluk",
    "arayuz.oyun.okculuk.ipucu": "Nişangâh hedefin ortasından geçerken Boşluk'a bas ya da tıkla.",
    "arayuz.oyun.harman.baslik": "Harman",
    "arayuz.oyun.harman.ipucu": "Daralan halka düvenin çemberine oturduğu anda Boşluk'a bas ya da tıkla.",
    "arayuz.oyun.ok": "Ok %d / %d",
    "arayuz.oyun.vurus": "Vuruş %d / %d",
    "arayuz.oyun.tam": "Tam isabet  +2",
    "arayuz.oyun.kenar": "Halkaya  +1",
    "arayuz.oyun.iska": "Iska",
    "arayuz.oyun.isabet": "İsabet",
    "arayuz.oyun.puan": "Puan %d / %d",
    "arayuz.menu.yeni": "Yeni gece",
    "arayuz.menu.devam": "Devam",
    "arayuz.menu.ayarlar": "Ayarlar",
    "arayuz.menu.cik": "Çık",
    "arayuz.menu.alt": "Kösedağ'dan sonra. Uçta bir kapı.",
    "arayuz.menu.ust": "Kösedağ'dan sonra · 1243",
    "arayuz.menu.baslik": "Uçta bir kapı.",
    "arayuz.menu.ipucu": "Yön tuşları ile seç · Enter ile onayla",
    "arayuz.duraklat.baslik": "Duraklatıldı",
    "arayuz.duraklat.devam": "Devam et",
    "arayuz.duraklat.menu": "Ana menüye dön",
    "arayuz.hud.gece": "%d. gece",
    "arayuz.hud.kose": "Köy: %d",
    "arayuz.sohbet.sen": "Sen",
    "arayuz.sohbet.karar_ver": "Kararını ver",
    "arayuz.sohbet.devam": "Devam",
    "arayuz.sohbet.ipucu": "Kararda: 1–5 seçer · aynı karara tekrar basmak onaylar · Esc seçimi bırakır",
    "arayuz.karar.kabul": "Kabul",
    "arayuz.karar.ret": "Ret",
    "arayuz.karar.rusvet": "Rüşvet al",
    "arayuz.karar.kisla": "Kışlaya yaz",
    "arayuz.karar.elkoy": "El koy, geri çevir",
    "arayuz.is.baslik": "Nerede çalışacak?",
    "arayuz.is.tarla": "Tarlaya yaz",
    "arayuz.is.pazar": "Pazara yaz",
    "arayuz.is.kervansaray": "Kervansaraya yaz",
    "arayuz.is.kisla": "Kışlaya yaz",
    "arayuz.is.uygun": "%s işi",
    "arayuz.is.geri": "Karara dön",
    "anlati.is.yazildi": "%s %s yazıldı.",
    "anlati.is.yer.tarla": "tarlaya",
    "anlati.is.yer.pazar": "pazara",
    "anlati.is.yer.kervansaray": "kervansaraya",
    "anlati.is.yer.kisla": "kışlaya",
    "anlati.is.uyumsuz": "Bu iş ona göre değil. %s bunu hissedecek.",
    "arayuz.kapi.bilgi": "%d. gün · %d. gelen · sırada %d kişi",
    "arayuz.kapi.sorular": "Sorular",
    "arayuz.kapi.sira": "Sırada",
    "arayuz.kapi.karar": "Karar",
    "arayuz.kapi.sohbete_don": "Sohbete dön",
    "arayuz.karar.rusvet_miktar": "Rüşvet al — %d akçe",
    "arayuz.karar.rusvet_deger": "Rüşvet al — %d akçe değerinde",
    "arayuz.sohbet.heybe_sor": "Heybende ne var?",
    "arayuz.sohbet.heybe_ara": "Heybesini ara",
    "heybe.beyan.akce": "Kesemde %d akçe var.",
    "heybe.beyan.esya": "Bir de %s.",
    "heybe.beyan.yok": "Başka bir şeyim yok.",
    "heybe.baslik": "%s — heybe",
    "heybe.soyledigi": "Söylediği: “%s”",
    "heybe.sormadin": "Ona ne taşıdığını sormadın.",
    "heybe.astar": "Astarı yokla",
    "heybe.astar_yoklandi": "Astar yoklandı",
    "heybe.astar_bos": "Astar boş. %s seni süzüyor: “Aradın da ne buldun?”",
    "heybe.yakalandi": "Yalan yakalandı",
    "heybe.gizli": "beyan edilmedi",
    "heybe.alinacaklar": "Alınacaklar",
    "heybe.bos": "Bir eşyaya bas: alınacaklara gider. Yine bas: heybeye döner.",
    "heybe.toplam": "Değeri: %d akçe",
    "heybe.teklif": "Teklifi: %d akçe",
    "heybe.gasp_uyari": "Teklifinden %d akçe fazlası. Kapıda adın çıkar.",
    "heybe.serbest": "Sakladıklarını alırsan kimse bir şey diyemez.",
    "heybe.kapat": "Heybeyi kapat",
    "heybe.adet": "%d / %d",
    "anlati.heybe.alinan": "Alınan: %s.",
    "anlati.heybe.gasp": "Teklifinden fazlasını aldın. Halk bunu duyacak.",
    "anlati.heybe.durust": "Dürüst birinin heybesini didikledin. Halk bunu duyacak.",
    "anlati.heybe.yakalandi": "Astardan çıkanlar: %s. %s gözlerini kaçırıyor.",
    "anlati.sonuc.elkoy": "Saklananlara el konuldu. %s yoluna döndü.",
    "arayuz.karar.onayla": "%s — onayla",
    "arayuz.sinif.asker": "asker",
    "arayuz.sinif.esnaf": "esnaf",
    "arayuz.sinif.ciftci": "çiftçi",
    "arayuz.sinif.gibi": "%s gibi görünüyor",
    "anlati.sonuc.kabul": "Kapı açıldı. %s içeri girdi.",
    "anlati.sonuc.ret": "Kapı kapalı kaldı. %s yoluna döndü.",
    "anlati.sonuc.rusvet": "Kese el değiştirdi. %s içeri girdi.",
    "anlati.sonuc.kisla": "%s kışlaya yazıldı.",
    "anlati.gece.basladi": "%d. gün. Kapının önünde yine bir kuyruk var.",
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
    "arayuz.tarla.baslik": "Tarlalar (%d)",
    "arayuz.tarla.yok": "Tarla açmak için çiftçi gerek (her %d çiftçi bir tarla).",
    "arayuz.tarla.bos": "boş",
    "arayuz.tarla.durum": "%s %d/%d",
    "arayuz.tarla.ek": "%s ek — %d gece, +%d · tohum %d",
    "arayuz.yapi.pazar": "Pazar",
    "arayuz.yapi.kervansaray": "Kervansaray",
    "arayuz.yapi.sur": "Sur",
    "arayuz.yapi.konak": "Köy konağı",
    "arayuz.yapi.konak_aciklama": "Soylular +1; köy büyür, evler sağlamlaşır.",
    "arayuz.yapi.nufus_gerek": "%d nüfus gerekir",
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
# Bu betiğin üretmediği anahtarlar (köy yönetimi arayüzü gibi elle eklenenler) korunur; betik yalnız kendi
# anahtarlarının metnini yazar. Kullanılmayan elle eklenmiş anahtarı silmek elle yapılır.
if os.path.exists(yol):
    with open(yol, encoding="utf-8", newline="") as f:
        for satir in list(csv.reader(f))[1:]:
            if len(satir) >= 2 and satir[0] not in METIN:
                METIN[satir[0]] = satir[1]
with open(yol, "w", encoding="utf-8", newline="") as f:
    w = csv.writer(f, lineterminator="\n")
    w.writerow(["keys", "tr"])
    for k in sorted(METIN):
        w.writerow([k, METIN[k]])
print("Yazıldı: %d metin, %d karakter, %d sınıf" % (len(METIN), len(KARAKTERLER), len(SINIFLAR)))
