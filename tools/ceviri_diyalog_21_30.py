# -*- coding: utf-8 -*-
"""
Görev 11 - Bölüm B3: Ziyaretçi Diyalogları 21-30 İngilizce Taslağı
ve diyalog_01_20.json (30 ziyaretçinin tamamı) birleştirilmiş kopyası.
"""

import json
import os
from ceviri_diyalog_01_10 import FLAGS, translate_sorular_tree, translate_note

def build_part_b3():
    os.makedirs('docs/ingilizce_diyalog', exist_ok=True)
    with open('data/diyalog/diyalog_01_20.json', encoding='utf-8') as f:
        all_visitors = json.load(f)

    scenes_21_30 = {
        'diyalog_21': "A panting horseman leading an exhausted, foam-flecked charger dismounts before the ditch. His mail hauberk is missing several links, and an unsheathed scimitar hangs at his side.",
        'diyalog_22': "A keen-eyed huntsman wearing a leather hawking glove stands by the barrier. A hooded saker falcon perches calmly upon his wrist, turning its head toward every mountain gust.",
        'diyalog_23': "A courier bearing a tin cylinder sealed with green wax across his chest urges his mule to the gate. The animal's flank is spattered with roadside mud.",
        'diyalog_24': "A soot-stained woodcutter leading two pack-donkeys laden with bulky wicker hampers of oak charcoal halts at the palisade. His hands are pitch-blackened to the elbows.",
        'diyalog_25': "A mud-splattered miner wearing heavy iron-shod clogs and a frayed wool cowl stands leaning upon an iron crowbar. His knuckles bear deep stone cuts.",
        'diyalog_26': "A careful merchant steering an ox-cart laden with rows of earthenware amphorae, jugs, and storage crocks packed in dry straw reins in his team.",
        'diyalog_27': "A slender young minstrel carrying a three-stringed kopuz wrapped in oiled lambskin approaches the gate with light, measured steps.",
        'diyalog_28': "A thin man in a worn velvet gown with ink-stained fingers clutches a leather portfolio under his arm. He looks back over his shoulder with nervous frequency.",
        'diyalog_29': "A broad-shouldered lumberjack carrying a heavy double-bitted felling axe across his massive shoulder stops before the timbers of the gate.",
        'diyalog_30': "A sun-bronzed traveler wearing a coarse camel-hair mantle and carrying an olive-wood staff carved with holy emblems stops at the threshold."
    }

    openings_21_30 = {
        'diyalog_21': "Sound the horn, guard! The frontier patrol at the river defile was ambushed by twenty Tekfur lancers. I spurred through the thicket to bring warning; double your parapet archers!",
        'diyalog_22': "Greetings, sentry of the march. My hawk sees game and scouts from two leagues high. If your garrison requires a hunter who can track enemy columns through the crags, I am at your service.",
        'diyalog_23': "Urgent dispatch for the keeper of the gate! The Sanjak Bey’s seal is intact upon the cylinder. Admit me without delay; border security hinges upon this parchment.",
        'diyalog_24': "Six loads of dry oak charcoal for Karaca Usta’s forge! Without charcoal his fire dies and no plowshare gets sharpened. Let my donkeys pass before the rain dampens the baskets.",
        'diyalog_25': "The rock ceiling collapsed at the upper iron mine during the sleet storm. Four of my mates are trapped; I ran through the night to fetch picks, timber props, and strong arms.",
        'diyalog_26': "Cured earthenware for olive oil, sheep butter, and grain storage. Wooden barrels split in the mountain freeze; my baked clay vessels keep your food sweet through the winter.",
        'diyalog_27': "A ballad of Battal Gazi for a warm bowl of broth, guard effendi. When the night frost descends upon the frontier, music warms the heart better than a smoky brazier.",
        'diyalog_28': "I fled the retinue of the district tax commissioner after refusing to falsify the tithe rolls against the frontier obas. Horsemen pursue me; grant me sanctuary in your council house.",
        'diyalog_29': "I felled four straight mountain oaks in the north ravine. If your palisade needs timber buttresses before the blizzards hit, my axe and sledge are ready.",
        'diyalog_30': "I have walked from Jerusalem and Damascus, touching holy soil and visiting the tombs of the righteous. I bring prayer beads, fragrant myrrh, and tidings from the southern realms."
    }

    translated_21_30 = []
    for i in range(20, 30):
        v = all_visitors[i]
        v_en = json.loads(json.dumps(v))
        
        v_en['sahne'] = scenes_21_30.get(v['id'], v.get('sahne', ''))
        v_en['acilis'] = openings_21_30.get(v['id'], v.get('acilis', ''))
        v_en['not'] = translate_note(v.get('not', ''))
        
        if 'yanitlar' in v_en:
            for k in v_en['yanitlar']:
                if k == 'ret':
                    v_en['yanitlar'][k] = "Do not shut the gate against me! The wilderness outside is merciless!"
                elif k == 'kabul':
                    v_en['yanitlar'][k] = "May heaven reward your righteousness! You shall not regret this mercy."
                elif k == 'rusvet':
                    v_en['yanitlar'][k] = "Take this silver; let it remain unrecorded. Just allow me inside."
                elif k == 'kisla':
                    v_en['yanitlar'][k] = "I muster with the garrison at once."
                    
        v_en['sorular'] = translate_sorular_tree(v['id'], v_en.get('sorular', []))
        translated_21_30.append(v_en)

    with open('docs/ingilizce_diyalog/diyalog_21_30.json', 'w', encoding='utf-8') as f:
        json.dump(translated_21_30, f, ensure_ascii=False, indent=2)

    # Now load diyalog_01_10 and diyalog_11_20 to create the master diyalog_01_20.json (all 30)
    with open('docs/ingilizce_diyalog/diyalog_01_10.json', encoding='utf-8') as f:
        p1 = json.load(f)
    with open('docs/ingilizce_diyalog/diyalog_11_20.json', encoding='utf-8') as f:
        p2 = json.load(f)

    master_30 = p1 + p2 + translated_21_30
    with open('docs/ingilizce_diyalog/diyalog_01_20.json', 'w', encoding='utf-8') as f:
        json.dump(master_30, f, ensure_ascii=False, indent=2)

    print(f"Wrote {len(translated_21_30)} visitors to docs/ingilizce_diyalog/diyalog_21_30.json")
    print(f"Wrote {len(master_30)} total visitors to docs/ingilizce_diyalog/diyalog_01_20.json")

if __name__ == '__main__':
    build_part_b3()
