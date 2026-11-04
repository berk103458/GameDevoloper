# -*- coding: utf-8 -*-
"""
Görev 11 - Bölüm B2: Ziyaretçi Diyalogları 11-20 İngilizce Taslağı
docs/ingilizce_diyalog/ klasörü altına yazılır.
"""

import json
import os
from ceviri_diyalog_01_10 import FLAGS, translate_sorular_tree, translate_note

def build_part_b2():
    os.makedirs('docs/ingilizce_diyalog', exist_ok=True)
    with open('data/diyalog/diyalog_01_20.json', encoding='utf-8') as f:
        all_visitors = json.load(f)

    scenes_11_20 = {
        'diyalog_11': "A cloaked traveler carrying an oiled leather valise slips toward the threshold under the shadows of evening. He keeps his hood low; his silver rings catch the torchlight as his fingers tap restlessly upon his belt.",
        'diyalog_12': "A woman wearing a tattered traveling mantle stands in the biting wind. Her lips are pale with frost, her dark eyes hollow with sorrow, scanning the sentry catwalks with anxious desperation.",
        'diyalog_13': "An elderly carter with a grizzled beard stands beside his tilted ox-cart. A fractured wheel axle is propped upon a stack of rough-hewn pine logs, while steam rises from the nostrils of his two patient oxen.",
        'diyalog_14': "A gaunt youth wearing a singed blacksmith's apron shivers by the timber palisade. His knuckles are raw and blackened with forge soot; purple welts from a severe beating show upon his forearms.",
        'diyalog_15': "A dignified woman riding a sturdy bay mare reins in before the ditch. Over her wool riding robe she wears the embroidered white sash of the Baciyan-i Rum, flanked by two armed youths bearing quarterstaffs.",
        'diyalog_16': "A wiry woodsman carrying a short reflex bow and iron-tipped furrier's axe steps out of the forest edge. Dried mud covers his high deerskin boots, and his keen gaze measures the height of our watchtowers.",
        'diyalog_17': "A young mother clutching a tightly swaddled infant to her breast leans against the gatepost. The child's feverish whimpering echoes through the dusk; her eyes are red from weeping and road dust.",
        'diyalog_18': "A brisk, determined young woman accompanied by a pack-pony laden with empty wooden brine tubs halts at the gate. Her leather apron smells strongly of lime and sumac bark.",
        'diyalog_19': "A young boy of twelve winters, wearing an oversized sheepskin vest and patched wool trousers, stands clutching an iron buckle in his palm. His chin quivers, yet he refuses to lower his eyes.",
        'diyalog_20': "A stout merchant leading three pack mules laden with heavy salt sacks approaches the barrier. The white crust of lake salt coats the burlap bags and his own thick beard."
    }

    openings_11_20 = {
        'diyalog_11': "Do not detain me long in this draughty pass, guard. I pay my gate tax in honest silver coin, ask for no communal bread, and desire only a quiet room in the upper quarter until the morning mist clears.",
        'diyalog_12': "In the name of the merciful, tell me: is my brother within these walls? He marched with the border levies three moons ago; wounded travelers on the highway told me he was carried to this sanctuary.",
        'diyalog_13': "My left axle snapped on the boulder ford, effendi. Darkness falls and wolves are gathering in the pine scrub. Grant my cart yard space; I have two barrels of cured olives and winter grease to barter.",
        'diyalog_14': "The master smith in the valley fortress laid an iron rod across my shoulders when the tongs slipped. Look at these scars, guard... If you cast me back, he will chain me to the anvil till I perish.",
        'diyalog_15': "Peace be upon your vigil, keeper of the gate. I ride with blessings from the grand lodge of Baciyan-i Rum. We bring woven cloaks for your sentries and seek counsel with Sister Ayse.",
        'diyalog_16': "I trapped marten and wolf across the Byzantine ridges all autumn. I know every bridle path between here and the Tekfur’s border castles. Grant me entry and I will share what I spied.",
        'diyalog_17': "My baby burns with the chest fever, master... The apothecary Thessra lives in this village, does she not? Let us in before the night frost stops my child's breath!",
        'diyalog_18': "I am Rahime, daughter of the tanner in the lower valley. We have thirty bull hides soaking in the vats that will spoil unless we procure rock salt before sunset. Let me into the bazaar.",
        'diyalog_19': "My father wore a green turban and carried a silver-inlaid belt buckle like this one. He came to your gate four days ago and never returned to our tent. Did you let him inside, guard effendi?",
        'diyalog_20': "Finest rock salt from the great lake! Pure white crystals that keep mutton sweet through the harshest winter. A village without salt faces rot, muhafiz. Let my mules into the yard."
    }

    translated_visitors = []
    for i in range(10, 20):
        v = all_visitors[i]
        v_en = json.loads(json.dumps(v))
        
        v_en['sahne'] = scenes_11_20.get(v['id'], v.get('sahne', ''))
        v_en['acilis'] = openings_11_20.get(v['id'], v.get('acilis', ''))
        v_en['not'] = translate_note(v.get('not', ''))
        
        if 'yanitlar' in v_en:
            for k in v_en['yanitlar']:
                if k == 'ret':
                    v_en['yanitlar'][k] = "Do not turn me away into the freezing night, guard! Have pity on a traveler!"
                elif k == 'kabul':
                    v_en['yanitlar'][k] = "May heaven reward your justice and preserve your threshold!"
                elif k == 'rusvet':
                    v_en['yanitlar'][k] = "Take this silver purse; let it be between our two souls. Just lift the latch."
                elif k == 'kisla':
                    v_en['yanitlar'][k] = "I report to the garrison captain at once. My blade is yours."
                    
        v_en['sorular'] = translate_sorular_tree(v['id'], v_en.get('sorular', []))
        translated_visitors.append(v_en)
        
    with open('docs/ingilizce_diyalog/diyalog_11_20.json', 'w', encoding='utf-8') as f:
        json.dump(translated_visitors, f, ensure_ascii=False, indent=2)
        
    print(f"Wrote {len(translated_visitors)} visitors to docs/ingilizce_diyalog/diyalog_11_20.json")

if __name__ == '__main__':
    build_part_b2()
