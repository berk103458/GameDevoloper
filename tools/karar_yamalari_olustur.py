#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Karar Yamaları Oluşturucu — Görev 13 Bölüm A
Ahmet'in docs/KARAR_SECENEKLERI.md belgesindeki 3 kritik hikaye yol ayrımı için:
1. Banu Hatun'un Dağdaki 50 Atlısı (1.1 İttifak Süvari vs 1.2 Yalnız Kabul)
2. Molla Şükrü vs Hasan Çelebi (2.1 Aleni Mahkeme vs 2.2 Kâtip İttifakı)
3. Vebalı Sabi ve Anası (3.1 Şifa ve Kurtuluş vs 3.2 Dramatik Kayıp)
tam ve bağımsız yama paketlerini docs/karar_yamalari/ altına hazırlar.
"""

import os
import json
import copy

def uret_karar_1():
    base_dir_1 = "docs/karar_yamalari/karar_1_ittifak_suvari"
    base_dir_2 = "docs/karar_yamalari/karar_1_yalniz_kabul"
    os.makedirs(base_dir_1, exist_ok=True)
    os.makedirs(base_dir_2, exist_ok=True)

    with open("data/diyalog/diyalog_01_20.json", "r", encoding="utf-8") as f:
        diyaloglar = json.load(f)
    with open("data/diyalog/es_kapi_dusunceleri.json", "r", encoding="utf-8") as f:
        es_dusunceleri = json.load(f)
    with open("data/parley/koy/koylu_muhabbet_karaca_usta.ds", "r", encoding="utf-8") as f:
        karaca_ds = json.load(f)
    with open("data/parley/koy/koylu_muhabbet_es.ds", "r", encoding="utf-8") as f:
        es_ds = json.load(f)

    # --- SEÇENEK 1.1: İTTİFAK VE SÜVARİ ---
    d11 = copy.deepcopy(diyaloglar)
    chr28 = d11[27]
    chr28["sorular"][0][2][1] = [
        "Arkamda elli atlı var dersin; hani neredeler? Atlıların kılıcı kınında duracaksa, bu köyün ekmeği de suyu da onlara helaldir Banu Hatun. Sınır boyunda Tekfur'un devriyesini savuşturur, ambarı korursunuz.",
        "Sözümüz taşa kazınmıştır Muhafız! 50 pusat bu gece köyün etrafına çelikten bir halka çeker. Lakin çerinin karnı doyacak; ambardan hakkımızı isteriz. Sözüm sözdür!",
        [
            [
                "Köyün ambarından payınızı ayırırız; vadi girişindeki korulukta ordugâh kurup köyün sınırına kalkan olacaksınız, anlaştık mı?",
                "Anlaştık muhafız! 50 Türkmen atlısı bu gece vadiyi tutar; tek bir harami bu sınırdan kuş olup uçamaz!"
            ]
        ],
        "banu_ittifak_kabul"
    ]
    chr28["yanitlar"]["kabul"] = "Kılıcımı kınında, 50 pusatımı korulukta emrine verdim muhafız! Ambarından payımızı alır, suruna kalkan oluruz. Karaca Usta da babasının kan borcunu pusatlarımızı bileyerek ödesin; adaletliysen köyün kazanır!"

    with open(os.path.join(base_dir_1, "diyalog_01_20.json"), "w", encoding="utf-8") as f:
        json.dump(d11, f, ensure_ascii=False, indent=2)

    es11 = copy.deepcopy(es_dusunceleri)
    es11["diyalog_28"]["karar_oncesi"] = "Eli pusat tutan 50 yiğit duvara yaslanmak gibidir efendi... Lakin 50 can 50 boğaz demektir. Kış bastırdığında ambar daralırsa o süvariler ekmeği kılıçla istemesin?"
    es11["diyalog_28"]["karar_kabul"] = "50 atlıyla ittifak kurdun beyim... Vadi koruluğunda çadırlar kuruldu. Haramiye karşı çelik kalkan olduk lakin ambarı sıkı tutmak gerek gayrı."
    with open(os.path.join(base_dir_1, "es_kapi_dusunceleri.json"), "w", encoding="utf-8") as f:
        json.dump(es11, f, ensure_ascii=False, indent=2)

    karaca11 = copy.deepcopy(karaca_ds)
    karaca11["nodes"].append({
        "id": "node:opt_banu",
        "type": "DIALOGUE_OPTION",
        "position": "(700.0, 360.0)",
        "character": "Muhafız",
        "text": "Banu Hatun'un 50 atlısıyla anlaştık Karaca Usta; vadi koruluğunda sınır nöbetine durdular."
    })
    karaca11["nodes"].append({
        "id": "node:rep_banu",
        "type": "DIALOGUE",
        "position": "(1050.0, 360.0)",
        "character": "Karaca Usta",
        "text": "Babamın kan borcunu bu nöbetle ödeyeceksen, atlarınızın nalını, kılıçlarınızın eğrisini ben döverim Banu! 50 pusat köyün etrafında nöbetteyse körüğü gece gündüz yakarım Muhafız."
    })
    karaca11["nodes"].append({
        "id": "node:act_banu",
        "type": "ACTION",
        "position": "(1400.0, 360.0)",
        "description": "Köy Savunması ve Morali",
        "action_type": "SCRIPT",
        "action_script_ref": "res://src/diyalog/actions/koy_moral_action.gd",
        "values": ["2"]
    })
    karaca11["edges"].extend([
        {"id": "e_o_banu", "from_node": "node:selam", "from_slot": 0, "to_node": "node:opt_banu", "to_slot": 0, "should_override_colour": False, "colour_override": "(1, 1, 1, 1)"},
        {"id": "e_r_banu", "from_node": "node:opt_banu", "from_slot": 0, "to_node": "node:rep_banu", "to_slot": 0, "should_override_colour": False, "colour_override": "(1, 1, 1, 1)"},
        {"id": "e_a_banu", "from_node": "node:rep_banu", "from_slot": 0, "to_node": "node:act_banu", "to_slot": 0, "should_override_colour": False, "colour_override": "(1, 1, 1, 1)"},
        {"id": "e_e_banu", "from_node": "node:act_banu", "from_slot": 0, "to_node": "node:end", "to_slot": 0, "should_override_colour": False, "colour_override": "(1, 1, 1, 1)"}
    ])
    with open(os.path.join(base_dir_1, "koylu_muhabbet_karaca_usta.ds"), "w", encoding="utf-8") as f:
        json.dump(karaca11, f, ensure_ascii=False, indent=2)

    es_ds11 = copy.deepcopy(es_ds)
    for n in es_ds11["nodes"]:
        if n["id"] == "node:opt_z_banu":
            n["text"] = "Banu Hatun'un 50 atlısı korulukta ordugâh kurup sınır nöbetine durdu beyim."
        elif n["id"] == "node:rep_z_banu":
            n["text"] = "Vadi girişindeki ordugâhı gördüm beyim. 50 pusat köyün etrafında nöbete durdu; haramiye karşı yüreğim ferahladı amma kışın ambardaki buğday süvarilere yetecek mi diye uykum kaçar..."
    with open(os.path.join(base_dir_1, "koylu_muhabbet_es.ds"), "w", encoding="utf-8") as f:
        json.dump(es_ds11, f, ensure_ascii=False, indent=2)

    with open(os.path.join(base_dir_1, "metinler_parca.csv"), "w", encoding="utf-8") as f:
        f.write("anahtar,tr,en\n")
        f.write("karar.banu.ittifak.baslik,Banu Hatun ve 50 Atlı İttifakı,Banu Hatun and 50 Horsemen Alliance\n")
        f.write("karar.banu.ittifak.metin,\"50 Türkmen süvarisi vadi koruluğunda ordugâh kurdu. Köy savunması 50 puan arttı, ambar tüketimi günlük 3 erzak ve 2 arpa yükseldi.\",\"50 Turkmen horsemen pitched camp in the valley grove. Village defense increased by 50, grain consumption increased by 3 rations and 2 barley daily.\"\n")
        f.write("karar.banu.ittifak.sonuc,\"Süvari muhafızları sınır boyunda nöbette. Köy güvende, erzak azaldı.\",\"Cavalry guards on patrol along the frontier. Village is secure, rations depleted.\"\n")

    uygula_11 = """# Yama Uygulama Rehberi — Karar 1 / Seçenek 1.1 (İttifak ve Süvari Muhafızları)

## Seçenek Özeti
- **Karar:** Banu Hatun'un Dağdaki 50 Atlısı
- **Seçim:** 1.1 Müttefik Süvari Muhafızları (İttifak ve Savunma)
- **Anlatı:** Muhafız ve Çınar Meclisi, Banu Hatun ile anlaşır. 50 atlı vadi girişindeki korulukta ordugâh kurar ve köy sınırlarını koruyan uç süvarisi olur. Karaca Usta babasının kan borcunu pusatları bileyerek öder.

## Kopyalanacak Dosyalar
Aşağıdaki dosyaları bu klasörden oyunun ana dizinlerine kopyalayınız:
1. `diyalog_01_20.json` -> `data/diyalog/diyalog_01_20.json`
2. `es_kapi_dusunceleri.json` -> `data/diyalog/es_kapi_dusunceleri.json`
3. `koylu_muhabbet_karaca_usta.ds` -> `data/parley/koy/koylu_muhabbet_karaca_usta.ds`
4. `koylu_muhabbet_es.ds` -> `data/parley/koy/koylu_muhabbet_es.ds`
5. `metinler_parca.csv` satırlarını `data/metin/metinler.csv` dosyasına ekleyiniz.

## Etkinleşen Bayraklar ve Oyun Değişkenleri
- `banu_ittifak_kabul`: true
- `suvari_50_orudgah_kuruldu`: true
- `ambar_suvari_payi_aktif`: true
- `koy_savunma_bonusu`: 50
- `asayis_riski`: -3
- `moral`: +1
- `gunluk_erzak_tuketimi`: +3 erzak, +2 arpa

## Doğrulama ve Test Komutları
Uygulama sonrasında şu komutlarla sistemi test ediniz:
```powershell
$env:PYTHONUTF8=1
python tools/metin_dogrula.py
python tools/soz_dogrula.py
C:\\Users\\Ahmet\\Desktop\\Godot.exe --headless --path . -s tests/unit/diyalog/diyalog_butunluk_test.gd
C:\\Users\\Ahmet\\Desktop\\Godot.exe --headless --path . -s tests/unit/kapi/es_yorumu_test.gd
C:\\Users\\Ahmet\\Desktop\\Godot.exe --headless --path . -s tests/unit/diyalog/koy_parley_sistemi_test.gd
```
"""
    with open(os.path.join(base_dir_1, "UYGULA.md"), "w", encoding="utf-8") as f:
        f.write(uygula_11)

    # --- SEÇENEK 1.2: YALNIZ KABUL ---
    d12 = copy.deepcopy(diyaloglar)
    chr28 = d12[27]
    chr28["sorular"][0][2][1] = [
        "Arkamda elli atlı var dersin; hani neredeler? Sen tek başına içeri girersin Banu Hatun; ocak başında yerin vardır. Lakin arkandaki 50 pusat bu vadiye giremez. Burası uç kalesidir, sahipsiz ordu barındırmaz!",
        "Bize güvenmezsin demek muhafız... Atlılarım dağda aç kalırsa obaya döner ya da dağın kurdu olur! Yarın Tekfur kapına dayandığında dağın ardına bakıp 'nerede bu atlar' demeyesin!",
        [
            [
                "Sen kışlada misafir ve rehin kalacaksın; adaleti divanda ararız amma 50 başıboş süvariyi içeri sokup köylüyü tehlikeye atmam!",
                "Pekâlâ muhafız! Tek başıma girerim; amma atlılarımın dağda başıboş kalmasının vebalini sen taşırsın!"
            ]
        ],
        "banu_yalniz_kabul"
    ]
    chr28["yanitlar"]["kabul"] = "Tek başıma girdim muhafız. Pusatım kışlaya emanet, canım divana bağlıdır. Lakin dağdaki atlılarıma kefil değilim; aç kurt dağda ulursa vebali sanadır!"

    with open(os.path.join(base_dir_2, "diyalog_01_20.json"), "w", encoding="utf-8") as f:
        json.dump(d12, f, ensure_ascii=False, indent=2)

    es12 = copy.deepcopy(es_dusunceleri)
    es12["diyalog_28"]["karar_oncesi"] = "Aklınla bin yaşa efendi. 50 silahlı yabancıyı kapıdan içeri sokmak kendi ayağımıza pranga vurmaktı. Banu diş bilese de hakikat budur."
    es12["diyalog_28"]["karar_kabul"] = "Banu'yu tek başına aldın, 50 atlıyı vadiye sokmadın beyim. Ambarımız bize kaldı, köyün içine sahipsiz ordu sokmadın; en doğrusunu ettin."
    with open(os.path.join(base_dir_2, "es_kapi_dusunceleri.json"), "w", encoding="utf-8") as f:
        json.dump(es12, f, ensure_ascii=False, indent=2)

    karaca12 = copy.deepcopy(karaca_ds)
    karaca12["nodes"].append({
        "id": "node:opt_banu",
        "type": "DIALOGUE_OPTION",
        "position": "(700.0, 360.0)",
        "character": "Muhafız",
        "text": "Banu Hatun'u tek başına aldık Karaca Usta; dağdaki 50 atlıyı vadiye sokmadık."
    })
    karaca12["nodes"].append({
        "id": "node:rep_banu",
        "type": "DIALOGUE",
        "position": "(1050.0, 360.0)",
        "character": "Karaca Usta",
        "text": "Doğrusunu ettin Muhafız! 50 başıboş süvariye köy teslim edilmez. Banu tektir, sözünün eridir; divanda kan davasını konuşuruz. Amma arkasındaki 50 kılıca kefil olunmazdı."
    })
    karaca12["nodes"].append({
        "id": "node:act_banu",
        "type": "ACTION",
        "position": "(1400.0, 360.0)",
        "description": "Köy Adaleti ve Güven",
        "action_type": "SCRIPT",
        "action_script_ref": "res://src/diyalog/actions/koy_moral_action.gd",
        "values": ["2"]
    })
    karaca12["edges"].extend([
        {"id": "e_o_banu", "from_node": "node:selam", "from_slot": 0, "to_node": "node:opt_banu", "to_slot": 0, "should_override_colour": False, "colour_override": "(1, 1, 1, 1)"},
        {"id": "e_r_banu", "from_node": "node:opt_banu", "from_slot": 0, "to_node": "node:rep_banu", "to_slot": 0, "should_override_colour": False, "colour_override": "(1, 1, 1, 1)"},
        {"id": "e_a_banu", "from_node": "node:rep_banu", "from_slot": 0, "to_node": "node:act_banu", "to_slot": 0, "should_override_colour": False, "colour_override": "(1, 1, 1, 1)"},
        {"id": "e_e_banu", "from_node": "node:act_banu", "from_slot": 0, "to_node": "node:end", "to_slot": 0, "should_override_colour": False, "colour_override": "(1, 1, 1, 1)"}
    ])
    with open(os.path.join(base_dir_2, "koylu_muhabbet_karaca_usta.ds"), "w", encoding="utf-8") as f:
        json.dump(karaca12, f, ensure_ascii=False, indent=2)

    es_ds12 = copy.deepcopy(es_ds)
    for n in es_ds12["nodes"]:
        if n["id"] == "node:opt_z_banu":
            n["text"] = "Banu Hatun kışlada misafir kaldı amma 50 atlıyı vadiye sokmadık beyim."
        elif n["id"] == "node:rep_z_banu":
            n["text"] = "Banu Hatun ocak başında sessizce oturur beyim... Dağdaki 50 atlıyı vadiye sokmadığın çok iyi oldu. Ambarımız bize ancak yeter; yabancı kılıca güvenip köyün huzuru bozulmazdı."
    with open(os.path.join(base_dir_2, "koylu_muhabbet_es.ds"), "w", encoding="utf-8") as f:
        json.dump(es_ds12, f, ensure_ascii=False, indent=2)

    with open(os.path.join(base_dir_2, "metinler_parca.csv"), "w", encoding="utf-8") as f:
        f.write("anahtar,tr,en\n")
        f.write("karar.banu.yalniz.baslik,Banu Hatun Yalnız Kabul Edildi,Banu Hatun Admitted Alone\n")
        f.write("karar.banu.yalniz.metin,\"Banu Hatun tek başına köye kabul edildi, 50 süvari vadiye sokulmadı. Ambar erzakı korundu, dağda başıboş atlılar yüzünden asayiş riski 1 arttı.\",\"Banu Hatun was admitted alone; the 50 cavalry were denied entry. Rations preserved, public order risk increased by 1 due to stray mountain riders.\"\n")
        f.write("karar.banu.yalniz.sonuc,\"Banu köyde gözetim altında, ambar güvende, dağ yolları tekinsiz.\",\"Banu under watch in the village, granary safe, mountain roads uneasy.\"\n")

    uygula_12 = """# Yama Uygulama Rehberi — Karar 1 / Seçenek 1.2 (Yalnız Savaşçı ve Atlıların Men Edilmesi)

## Seçenek Özeti
- **Karar:** Banu Hatun'un Dağdaki 50 Atlısı
- **Seçim:** 1.2 Yalnız Savaşçı ve Atlıların Men Edilmesi (İhtiyat ve Mesafe)
- **Anlatı:** Banu Hatun tek başına köye kabul edilir ancak 50 atlının vadiye girmesi kesin olarak yasaklanır. Banu Hatun divan gözetiminde rehin/misafir kalır. Ambar erzakı korunur, yabancı ordu riski bertaraf edilir.

## Kopyalanacak Dosyalar
Aşağıdaki dosyaları bu klasörden oyunun ana dizinlerine kopyalayınız:
1. `diyalog_01_20.json` -> `data/diyalog/diyalog_01_20.json`
2. `es_kapi_dusunceleri.json` -> `data/diyalog/es_kapi_dusunceleri.json`
3. `koylu_muhabbet_karaca_usta.ds` -> `data/parley/koy/koylu_muhabbet_karaca_usta.ds`
4. `koylu_muhabbet_es.ds` -> `data/parley/koy/koylu_muhabbet_es.ds`
5. `metinler_parca.csv` satırlarını `data/metin/metinler.csv` dosyasına ekleyiniz.

## Etkinleşen Bayraklar ve Oyun Değişkenleri
- `banu_yalniz_kabul`: true
- `suvari_vadiye_sokulmadi`: true
- `suvari_dagda_kacak`: true
- `banu_koyde_rehine`: true
- `savunma_bonusu`: 0 (değişmez)
- `asayis_riski`: +1 (dağda başsız kalan süvariler kervan yolunu tehdit eder)
- `adalet`: +2
- `erzak_tuketimi`: normal (ekstra tüketim yok)

## Doğrulama ve Test Komutları
Uygulama sonrasında şu komutlarla sistemi test ediniz:
```powershell
$env:PYTHONUTF8=1
python tools/metin_dogrula.py
python tools/soz_dogrula.py
C:\\Users\\Ahmet\\Desktop\\Godot.exe --headless --path . -s tests/unit/diyalog/diyalog_butunluk_test.gd
C:\\Users\\Ahmet\\Desktop\\Godot.exe --headless --path . -s tests/unit/kapi/es_yorumu_test.gd
C:\\Users\\Ahmet\\Desktop\\Godot.exe --headless --path . -s tests/unit/diyalog/koy_parley_sistemi_test.gd
```
"""
    with open(os.path.join(base_dir_2, "UYGULA.md"), "w", encoding="utf-8") as f:
        f.write(uygula_12)

    print("Karar 1 yamaları eksiksiz oluşturuldu.")




def uret_karar_2():
    base_dir_1 = "docs/karar_yamalari/karar_2_aleni_mahkeme"
    base_dir_2 = "docs/karar_yamalari/karar_2_katip_ittifak"
    os.makedirs(base_dir_1, exist_ok=True)
    os.makedirs(base_dir_2, exist_ok=True)

    with open("data/diyalog/diyalog_01_20.json", "r", encoding="utf-8") as f:
        diyaloglar = json.load(f)
    with open("data/diyalog/es_kapi_dusunceleri.json", "r", encoding="utf-8") as f:
        es_dusunceleri = json.load(f)
    with open("data/parley/koy/koylu_muhabbet_hasan_celebi.ds", "r", encoding="utf-8") as f:
        hasan_ds = json.load(f)
    with open("data/parley/koy/koylu_muhabbet_es.ds", "r", encoding="utf-8") as f:
        es_ds = json.load(f)

    # --- SEÇENEK 2.1: ALENİ MAHKEME (HAK VE ADALET) ---
    d21 = copy.deepcopy(diyaloglar)
    chr27 = d21[26]
    chr27["sorular"][0][2][0] = [
        "Köyümüzün divan kâtibi Hasan Çelebi'dir; onun mühürlediği tapuya köyde kimse karşı çıkamaz! Seni Çınar Meclisi'nin huzuruna çıkaracağım, mühürlerin sahteliğini cümle köylü görecek!",
        "Divan mı?! İftiradır muhafız! O kütükleri ben tutmazsam yarın Tekfur haracı iki katına çıkarır! Amma hakikatten korkum yoktur, beni meclise çıkarın!",
        [
            [
                "Hüküm verilmiştir Molla Şükrü. Sahte mühürle hak gasp edenin bu çınar altında yeri yoktur. Beratın yakılacak, kendin de demirhanede Karaca Usta'nın körüğünde ter dökeceksin!",
                "Aman muhafızım, etme eyleme! Kalem tutan parmaklarım örs mü dövecek?! Razıyım... Yeter ki kellere kıyma, körüğü çeker günahımı öderim!"
            ]
        ],
        "meclis_sukru_mahkeme_edildi"
    ]
    chr27["yanitlar"]["kabul"] = "Kılıcımı kınında değil divitimi meclise teslim ettim muhafız. Sahte mühür meydana saçıldı amma boynum büküktür; demirhanede körük çekip ahaliye borcumu öderim!"

    with open(os.path.join(base_dir_1, "diyalog_01_20.json"), "w", encoding="utf-8") as f:
        json.dump(d21, f, ensure_ascii=False, indent=2)

    es21 = copy.deepcopy(es_dusunceleri)
    es21["diyalog_27"]["karar_oncesi"] = "Hasan Çelebi ile yüzleştir beyim. O sahte mühürle köylünün arazisine çökmeye kalkarsa Çınar Meclisi hakkını versin; kâtibin fitnesini aleni meydanda kır."
    es21["diyalog_27"]["karar_kabul"] = "Güneş balçıkla sıvanmaz derlerdi, doğruymuş. Hasan Çelebi'nin hakkını köyün önünde teslim ettin ya, köylünün adalete olan imanı yenilendi."
    with open(os.path.join(base_dir_1, "es_kapi_dusunceleri.json"), "w", encoding="utf-8") as f:
        json.dump(es21, f, ensure_ascii=False, indent=2)

    hasan21 = copy.deepcopy(hasan_ds)
    hasan21["nodes"].append({
        "id": "node:opt_sukru",
        "type": "DIALOGUE_OPTION",
        "position": "(700.0, 360.0)",
        "character": "Muhafız",
        "text": "Molla Şükrü'yü Çınar Meclisi'ne çıkardık Hasan Çelebi; sahte beratı meydana serildi."
    })
    hasan21["nodes"].append({
        "id": "node:rep_sukru",
        "type": "DIALOGUE",
        "position": "(1050.0, 360.0)",
        "character": "Hasan Çelebi",
        "text": "Şu berattaki tuğraya bakın cemaat! Mürekkebi daha geçen hafta sürülmüş bezir yağı kokar! Muhafız hileyi meydana serdi; hakikatin terazisi bozulmadı şükürler olsun."
    })
    hasan21["nodes"].append({
        "id": "node:act_sukru",
        "type": "ACTION",
        "position": "(1400.0, 360.0)",
        "description": "Köy Adaleti ve İtibar",
        "action_type": "SCRIPT",
        "action_script_ref": "res://src/diyalog/actions/koy_moral_action.gd",
        "values": ["3"]
    })
    hasan21["edges"].extend([
        {"id": "e_o_sukru", "from_node": "node:selam", "from_slot": 0, "to_node": "node:opt_sukru", "to_slot": 0, "should_override_colour": False, "colour_override": "(1, 1, 1, 1)"},
        {"id": "e_r_sukru", "from_node": "node:opt_sukru", "from_slot": 0, "to_node": "node:rep_sukru", "to_slot": 0, "should_override_colour": False, "colour_override": "(1, 1, 1, 1)"},
        {"id": "e_a_sukru", "from_node": "node:rep_sukru", "from_slot": 0, "to_node": "node:act_sukru", "to_slot": 0, "should_override_colour": False, "colour_override": "(1, 1, 1, 1)"},
        {"id": "e_e_sukru", "from_node": "node:act_sukru", "from_slot": 0, "to_node": "node:end", "to_slot": 0, "should_override_colour": False, "colour_override": "(1, 1, 1, 1)"}
    ])
    with open(os.path.join(base_dir_1, "koylu_muhabbet_hasan_celebi.ds"), "w", encoding="utf-8") as f:
        json.dump(hasan21, f, ensure_ascii=False, indent=2)

    es_ds21 = copy.deepcopy(es_ds)
    for n in es_ds21["nodes"]:
        if n["id"] == "node:opt_z_hekim_katip":
            n["text"] = "Molla Şükrü'nün sahte beratı Çınar Meclisi'nde mahkeme edildi beyim."
        elif n["id"] == "node:rep_z_hekim_katip":
            n["text"] = "Molla Şükrü'nün sahte beratını Çınar Meclisi'nde ateşe attın ya beyim, Hasan Çelebi'nin gözleri doldu. Adalet yerini buldu, köylünün içi rahatladı."
    with open(os.path.join(base_dir_1, "koylu_muhabbet_es.ds"), "w", encoding="utf-8") as f:
        json.dump(es_ds21, f, ensure_ascii=False, indent=2)

    with open(os.path.join(base_dir_1, "metinler_parca.csv"), "w", encoding="utf-8") as f:
        f.write("anahtar,tr,en\n")
        f.write("karar.sukru.mahkeme.baslik,Çınar Meclisinde Aleni Mahkeme,Public Trial at Plane Tree Council\n")
        f.write("karar.sukru.mahkeme.metin,\"Molla Şükrü Çınar Meclisi önünde yargılandı. Sahte mühür tahrifatı kanıtlandı, berat yakıldı, kâtip demirhane cezasına çarptırıldı. Adalet 3, Moral 2 arttı, Asayiş Riski 2 azaldı.\",\"Molla Sukru was tried before the Council. Forged seal was proven, charter burned, scribe sentenced to forge labor. Justice +3, Morale +2, Public Order Risk -2.\"\n")
        f.write("karar.sukru.mahkeme.sonuc,\"Hasan Çelebi ve divan onurlandırıldı. Köyde adalet tesis edildi.\",\"Hasan Celebi and council honored. Justice established in the village.\"\n")

    uygula_21 = """# Yama Uygulama Rehberi — Karar 2 / Seçenek 2.1 (Çınar Meclisi'nde Aleni Mahkeme)

## Seçenek Özeti
- **Karar:** Molla Şükrü vs Hasan Çelebi Meclis Yüzleşmesi
- **Seçim:** 2.1 Çınar Meclisi'nde Aleni Mahkeme (Hak ve Adalet)
- **Anlatı:** Muhafız, Molla Şükrü'yü Çınar Meclisi'nin ve köy ahalisinin önüne çıkarır. Hasan Çelebi sahte mührü ve bezir yağı kokan tahrifatı kanıtlar. Sahte berat yakılır; Şükrü kellesi bağışlanarak Karaca Usta'nın demirhanesinde körük çekme cezasına çarptırılır.

## Kopyalanacak Dosyalar
Aşağıdaki dosyaları bu klasörden oyunun ana dizinlerine kopyalayınız:
1. `diyalog_01_20.json` -> `data/diyalog/diyalog_01_20.json`
2. `es_kapi_dusunceleri.json` -> `data/diyalog/es_kapi_dusunceleri.json`
3. `koylu_muhabbet_hasan_celebi.ds` -> `data/parley/koy/koylu_muhabbet_hasan_celebi.ds`
4. `koylu_muhabbet_es.ds` -> `data/parley/koy/koylu_muhabbet_es.ds`
5. `metinler_parca.csv` satırlarını `data/metin/metinler.csv` dosyasına ekleyiniz.

## Etkinleşen Bayraklar ve Oyun Değişkenleri
- `meclis_sukru_mahkeme_edildi`: true
- `sukru_sahte_muhur_kanitlandi`: true
- `sukru_cezali_demirhane`: true
- `hasan_celebi_itibar_zirve`: true
- `adalet`: +3
- `moral`: +2
- `asayis_riski`: -2
- `demirhane_uretimi`: günlük +1 alet

## Doğrulama ve Test Komutları
Uygulama sonrasında şu komutlarla sistemi test ediniz:
```powershell
$env:PYTHONUTF8=1
python tools/metin_dogrula.py
python tools/soz_dogrula.py
C:\\Users\\Ahmet\\Desktop\\Godot.exe --headless --path . -s tests/unit/diyalog/diyalog_butunluk_test.gd
C:\\Users\\Ahmet\\Desktop\\Godot.exe --headless --path . -s tests/unit/kapi/es_yorumu_test.gd
C:\\Users\\Ahmet\\Desktop\\Godot.exe --headless --path . -s tests/unit/diyalog/koy_parley_sistemi_test.gd
```
"""
    with open(os.path.join(base_dir_1, "UYGULA.md"), "w", encoding="utf-8") as f:
        f.write(uygula_21)

    # --- SEÇENEK 2.2: PERDE ARKASI KÂTİP İTTİFAKI (PRAGMATİK İDARE) ---
    d22 = copy.deepcopy(diyaloglar)
    chr27 = d22[26]
    chr27["sorular"][0][2][0] = [
        "Mührün sahte olduğunu ikimiz de biliriz Molla. Lakin Divan'ın tahsildarı geldiğinde ambarı boş, köylüyü fakir gösterecek bir kalem lazımdır. Bizim için yazarsan kellen yerinde kalır.",
        "Hele şöyle gel Muhafız... Akıllı adamsın vesselam! Beyin tahsildarı geldiğinde öyle bir kütük sunarım ki, köye borçlu çıkarlar! Akçeler köyde kalır!",
        [
            [
                "Tek bir akçeyi kendi heybene atarsan ya da köylünün arazisine el uzatırsan seni darağacına çekerim Molla; gizli defteri yalnız benim emrimle tutacaksın!",
                "Sen canımı bağışladın, bana hazine kapısı açtın muhafız! O gizli defter ikimizin sırrıdır; Tekfur da Sancak Beyi de tek kuruş fazla haraç koparamaz!"
            ]
        ],
        "sukru_gizli_ittifak"
    ]
    chr27["yanitlar"]["kabul"] = "Anlaştık muhafız. Gözden ırak divan odasında iki ayrı kütük tutarım; biri beye sunulacak sahte vergi defteri, diğeri köyün gerçek hazinesi! Akçemiz bol olsun!"

    with open(os.path.join(base_dir_2, "diyalog_01_20.json"), "w", encoding="utf-8") as f:
        json.dump(d22, f, ensure_ascii=False, indent=2)

    es22 = copy.deepcopy(es_dusunceleri)
    es22["diyalog_27"]["karar_oncesi"] = "Akçe gelir diyorsun efendi... Lakin haramın girdiği hanede huzur kalmaz. Hasan Çelebi yüzünü çevirdi, yarın bir gün Divan müfettişi gelirse ne cevap vereceksin?"
    es22["diyalog_27"]["karar_kabul"] = "Akçe sandığı dolar diyorsun beyim amma Hasan Çelebi cami avlusunda başını önüne eğdi, yüzümüze bakmaz oldu. Hileli defter başımıza iş açmasın..."
    with open(os.path.join(base_dir_2, "es_kapi_dusunceleri.json"), "w", encoding="utf-8") as f:
        json.dump(es22, f, ensure_ascii=False, indent=2)

    hasan22 = copy.deepcopy(hasan_ds)
    hasan22["nodes"].append({
        "id": "node:opt_sukru",
        "type": "DIALOGUE_OPTION",
        "position": "(700.0, 360.0)",
        "character": "Muhafız",
        "text": "Molla Şükrü ile divan hesaplarını konuştun mu Hasan Çelebi?"
    })
    hasan22["nodes"].append({
        "id": "node:rep_sukru",
        "type": "DIALOGUE",
        "position": "(1050.0, 360.0)",
        "character": "Hasan Çelebi",
        "text": "(Yüzünü çevirir, sesi kırıktır) Kurdun defterini çakala tutturursunuz Muhafız... Bu köyün bereketi hileyle değil helalle dururdu. Sahte mühürlü kâtiple gizli pazarlık ettiniz ya, gayrı benden hüccet istemeyin..."
    })
    hasan22["nodes"].append({
        "id": "node:act_sukru",
        "type": "ACTION",
        "position": "(1400.0, 360.0)",
        "description": "Köy Adaleti ve Kırgınlık",
        "action_type": "SCRIPT",
        "action_script_ref": "res://src/diyalog/actions/koy_moral_action.gd",
        "values": ["-2"]
    })
    hasan22["edges"].extend([
        {"id": "e_o_sukru", "from_node": "node:selam", "from_slot": 0, "to_node": "node:opt_sukru", "to_slot": 0, "should_override_colour": False, "colour_override": "(1, 1, 1, 1)"},
        {"id": "e_r_sukru", "from_node": "node:opt_sukru", "from_slot": 0, "to_node": "node:rep_sukru", "to_slot": 0, "should_override_colour": False, "colour_override": "(1, 1, 1, 1)"},
        {"id": "e_a_sukru", "from_node": "node:rep_sukru", "from_slot": 0, "to_node": "node:act_sukru", "to_slot": 0, "should_override_colour": False, "colour_override": "(1, 1, 1, 1)"},
        {"id": "e_e_sukru", "from_node": "node:act_sukru", "from_slot": 0, "to_node": "node:end", "to_slot": 0, "should_override_colour": False, "colour_override": "(1, 1, 1, 1)"}
    ])
    with open(os.path.join(base_dir_2, "koylu_muhabbet_hasan_celebi.ds"), "w", encoding="utf-8") as f:
        json.dump(hasan22, f, ensure_ascii=False, indent=2)

    es_ds22 = copy.deepcopy(es_ds)
    for n in es_ds22["nodes"]:
        if n["id"] == "node:opt_z_hekim_katip":
            n["text"] = "Molla Şükrü gizli defteri tutmaya başladı; tahsildardan akçe kaçırırız."
        elif n["id"] == "node:rep_z_hekim_katip":
            n["text"] = "Molla Şükrü gizli defter tutar beyim... Sandık akçeyle doluyor amma Hasan Çelebi bize küstü. Sancak müfettişi kapıya dayanırsa bu hilenin altından nasıl kalkarız?"
    with open(os.path.join(base_dir_2, "koylu_muhabbet_es.ds"), "w", encoding="utf-8") as f:
        json.dump(es_ds22, f, ensure_ascii=False, indent=2)

    with open(os.path.join(base_dir_2, "metinler_parca.csv"), "w", encoding="utf-8") as f:
        f.write("anahtar,tr,en\n")
        f.write("karar.sukru.ittifak.baslik,Perde Arkası Kâtip İttifakı,Backroom Scribe Alliance\n")
        f.write("karar.sukru.ittifak.metin,\"Molla Şükrü ile vergi kaçırma ve gizli deftercilik anlaşması yapıldı. Günlük 15 akçe gelir sağlandı; Adalet 3 azaldı, Asayiş Riski 2 arttı, Hasan Çelebi küstü.\",\"Secret bookkeeping alliance formed with Molla Sukru. Daily +15 coins generated; Justice -3, Public Order Risk +2, Hasan Celebi estranged.\"\n")
        f.write("karar.sukru.ittifak.sonuc,\"Köy hazinesi doluyor, Divan teftiş riski kapıda.\",\"Village treasury swells, Divan inspection risk looms.\"\n")

    uygula_22 = """# Yama Uygulama Rehberi — Karar 2 / Seçenek 2.2 (Perde Arkası Kâtip İttifakı)

## Seçenek Özeti
- **Karar:** Molla Şükrü vs Hasan Çelebi Meclis Yüzleşmesi
- **Seçim:** 2.2 Perde Arkası Kâtip İttifakı (Pragmatik İdare ve Rüşvet)
- **Anlatı:** Muhafız Şükrü'nün sahtekârlığını yüzüne vurur ancak onu cezalandırmak yerine divan vergisini kaçırmak ve hazineyi büyütmek için gizli kâtip olarak istihdam eder. Köye ciddi akçe akar; ancak Hasan Çelebi kırılır, meclis adaleti sarsılır ve divan teftişi tehlikesi belirir.

## Kopyalanacak Dosyalar
Aşağıdaki dosyaları bu klasörden oyunun ana dizinlerine kopyalayınız:
1. `diyalog_01_20.json` -> `data/diyalog/diyalog_01_20.json`
2. `es_kapi_dusunceleri.json` -> `data/diyalog/es_kapi_dusunceleri.json`
3. `koylu_muhabbet_hasan_celebi.ds` -> `data/parley/koy/koylu_muhabbet_hasan_celebi.ds`
4. `koylu_muhabbet_es.ds` -> `data/parley/koy/koylu_muhabbet_es.ds`
5. `metinler_parca.csv` satırlarını `data/metin/metinler.csv` dosyasına ekleyiniz.

## Etkinleşen Bayraklar ve Oyun Değişkenleri
- `sukru_gizli_ittifak`: true
- `vergi_kacakciligi_aktif`: true
- `hasan_celebi_kirgin_ve_kuskun`: true
- `divan_teftis_tehlikesi`: true
- `gunluk_akce`: +15
- `adalet`: -3
- `moral`: -1
- `asayis_riski`: +2

## Doğrulama ve Test Komutları
Uygulama sonrasında şu komutlarla sistemi test ediniz:
```powershell
$env:PYTHONUTF8=1
python tools/metin_dogrula.py
python tools/soz_dogrula.py
C:\\Users\\Ahmet\\Desktop\\Godot.exe --headless --path . -s tests/unit/diyalog/diyalog_butunluk_test.gd
C:\\Users\\Ahmet\\Desktop\\Godot.exe --headless --path . -s tests/unit/kapi/es_yorumu_test.gd
C:\\Users\\Ahmet\\Desktop\\Godot.exe --headless --path . -s tests/unit/diyalog/koy_parley_sistemi_test.gd
```
"""
    with open(os.path.join(base_dir_2, "UYGULA.md"), "w", encoding="utf-8") as f:
        f.write(uygula_22)

    print("Karar 2 yamaları eksiksiz oluşturuldu.")


if __name__ == "__main__":
    uret_karar_1()
    uret_karar_2()
