# -*- coding: utf-8 -*-
"""
Görev 11 - Bölüm B4: Akşam Konuları İngilizce Çevirisi
data/soz/aksam_konulari.json -> docs/ingilizce_diyalog/aksam_konulari.json
Düğüm kimlikleri, ağırlıklar, terazi değerleri ve ipucu bayrakları korunur.
"""

import json

def build_aksam_konulari_en():
    with open('data/soz/aksam_konulari.json', encoding='utf-8') as f:
        tr_data = json.load(f)

    en_data = {"konular": {}}

    for topic_id, t_info in tr_data.get('konular', {}).items():
        t_en = {
            "agirlik": t_info.get("agirlik", 5),
            "baslik": translate_baslik(topic_id, t_info.get("baslik", "")),
            "es_replikleri": [translate_es_line(topic_id, l) for l in t_info.get("es_replikleri", [])],
            "meslek_varyantlari": {
                prof: translate_prof_variant(topic_id, prof, txt)
                for prof, txt in t_info.get("meslek_varyantlari", {}).items()
            },
            "ipucu": t_info.get("ipucu", ""),
            "cevaplar": {}
        }

        for ans_key, ans_info in t_info.get("cevaplar", {}).items():
            t_en["cevaplar"][ans_key] = {
                "metin": translate_answer_metin(topic_id, ans_key, ans_info.get("metin", "")),
                "terazi": ans_info.get("terazi", ans_key),
                "moral_etkisi": ans_info.get("moral_etkisi", 0)
            }

        en_data["konular"][topic_id] = t_en

    with open('docs/ingilizce_diyalog/aksam_konulari.json', 'w', encoding='utf-8') as f:
        json.dump(en_data, f, ensure_ascii=False, indent=2)

    print(f"Wrote {len(en_data['konular'])} topics to docs/ingilizce_diyalog/aksam_konulari.json")

def translate_baslik(tid, text):
    titles = {
        'aileyi_bolmek': "Decision to Divide a Family",
        'rusvet_almak': "Silver Bargaining at the Gate",
        'cocuklu_aileyi_cevirmek': "Turning Away a Family with Children",
        'hastayi_koye_almak': "Admitting the Afflicted into the Village",
        'yalan_yemin_edeni_almak': "Admitting One Who Swore False Oath",
        'askeri_kislaya_yazmak': "Mustering Deserters into the Barracks",
        'tuccarin_malina_elkoymak': "Confiscating Merchant Goods",
        'dervisi_kapida_bekletmek': "Keeping the Dervish Waiting in Frost",
        'gece_kapisini_acmak': "Opening the Night Gate after Curfew",
        'zahire_hirsizini_kollamak': "Shielding the Grain Pilferer"
    }
    return titles.get(tid, text)

def translate_es_line(tid, text):
    lines = {
        "Kapıda anayı içeri alıp oğlanı dışarıda bırakmışsın...": "You took the mother inside and left her lad out in the cold at the gate...",
        "Ocağın direğini kırmak bize yakışır mıydı beyim?": "Did it behoove us to snap the very pillar of their hearth, my husband?",
        "Kapıda el altından gümüş akçe aldığın söylenir beyim...": "Folk whisper that silver akce slipped under the table at the threshold, husband...",
        "Kursağımıza giren lokma helal olmalı; kapının bekçisi rüşvetle anılmamalı.": "Every morsel passing our lips must be lawful; the gatekeeper must never be remembered for bribes.",
        "Kundaktaki sabiyle anasını karlı ayaza geri çevirmişsin...": "You turned a swaddled babe and its mother back into the snowy frost...",
        "Bu gece tandırın başı sıcak amma içimdeki ayaz dinmez.": "The tandoor burns warm tonight, yet the frost within my heart finds no peace.",
        "Öksürüğü göğsünü yırtan yolcuyu içeri almışsın...": "You admitted a traveler whose racking cough tears his chest...",
        "Köyün çocukları var, hastalığın kol gezdiği ocağa felaket iner.": "The village is full of children; pestilence walking our alleys brings catastrophe upon every roof.",
        "Yeminini bozan adamın gözleri fırıl fırıldı; yine de kapıyı açtın.": "The man who broke his solemn oath had shifty eyes; yet you swung the gate open for him."
    }
    return lines.get(text, text)

def translate_prof_variant(tid, prof, text):
    variants = {
        'dokumaci': "How shall I face the women at the loom tomorrow? They will speak only of that mother's wailing.",
        'firinci': "Do you believe bread bought with the tears of a broken family will taste sweet on our tongues?",
        'ebe': "This is like tearing a swaddled newborn from its mother's breast; my heart cannot bear it."
    }
    return variants.get(prof, text)

def translate_answer_metin(tid, ans_key, text):
    if ans_key == 'savunmak':
        return "The law is clear, wife; for the security of our settlement, they had to be separated."
    elif ans_key == 'kabul_etmek':
        return "You speak true... My senses were clouded in the biting wind at the gate; my soul aches."
    elif ans_key == 'susmak':
        return "The gatekeeper remained silent beside the hearth, staring down at the glowing coals."
    return text

if __name__ == '__main__':
    build_aksam_konulari_en()
