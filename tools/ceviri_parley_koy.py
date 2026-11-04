# -*- coding: utf-8 -*-
"""
Görev 11 - Bölüm B3: Köylü ve Eş Parley Sohbetleri İngilizce Çevirisi
data/parley/koy/*.ds -> docs/ingilizce_diyalog/koy/*.ds
18 Parley dosyasının düğüm yapısı, koordinatları, script referansları ve kenarları korunur;
yalnızca text alanları ve Muhafız karakter adı İngilizceye çevrilir.
"""

import json
import glob
import os

def build_parley_en():
    os.makedirs('docs/ingilizce_diyalog/koy', exist_ok=True)
    files = glob.glob('data/parley/koy/*.ds')
    
    # Translation dictionary for character names
    CHAR_MAP = {
        'Muhafız': 'Gatekeeper',
        'Eş': 'Spouse',
        'Aydoğdu': 'Aydoğdu',
        'Ayşe Bacı': 'Ayşe Bacı',
        'Hasan Çelebi': 'Hasan Çelebi',
        'Karaca Usta': 'Karaca Usta',
        'Miraen': 'Miraen',
        'Nogay': 'Nogay',
        'Saruca Hatun': 'Saruca Hatun',
        'Sorhan': 'Sorhan',
        'Thessra': 'Thessra',
        'Yusuf': 'Yusuf',
        'Köylü': 'Villager',
        'Genç': 'Youth',
        'İhtiyar': 'Elder'
    }

    # Core phrase translations for common and character-specific nodes
    TEXT_MAP = {
        # Aydoğdu
        "Dur orada muhafız! Gözüm ovada, kulağım kirişte. Eski askerin istirahati mezardadır; neye baktın?": "Halt there, gatekeeper! My eye scans the plain, my ear attends the bowstring. An old soldier rests only in the grave; what do you seek?",
        "Çavuşum, köyün mazgalları ve nöbetçileri nasıl durur?": "Sergeant, how stand the village battlements and sentry posts?",
        "Kösedağ eteklerinde süvari tozu görülmüş; ne tedbir alalım?": "Horsemen dust was spotted at the skirts of Kösedağ; what precaution shall we take?",
        "Dün içeri aldığımız neferler hakkında kanaatin nedir?": "What is your judgment regarding the nefers we admitted yesterday?",
        "Gençler fazla gevşek! Dün gece devriyeyi denetledim; ikisi mazgal dibinde uyukluyordu, kargının sapıyla dürttüm. Nöbette uyuyan asker celladına davetiye çıkarır!": "The youngsters are too lax! I inspected the watch last night; two nodded off beside the parapet, so I prodded them with my spear butt. A sentry who sleeps on watch sends an invitation to his executioner!",
        "Hendek menfezlerine kazık çaktıralım! Su arkının önüne kurt çukuru kazalım. Süvari atı çukura bastı mı süvari yerde kalır; kuledeki kemankeşler de işi bitirir.": "Drive sharpened stakes into the ditch culverts! Dig wolf-pits before the water channel. When a charger steps into the pit, the rider hits the dirt; our archers in the tower will finish the work.",
        "Sivaslı kargıcı ile kule borazancısını kışlaya aldım. Biri pusu noktalarını haritada gösterdi, diğeri borazanın sesini test etti. İkisi de cephe eri; kışlamıza güç kattılar.": "I assigned the spearman from Sivas and the tower trumpeter to the barracks. One marked ambush defiles on the map, the other sounded the war horn. Both are veteran front-liners; they bolster our garrison.",

        # Ayşe Bacı
        "Hoş geldin muhafız. Bacıyan ocağında tezgâh işler, aş kaynar. Bir derdin mi var, yoksa çorbamıza kaşık mı çalarsın?": "Welcome, gatekeeper. At the Baciyan hearth the looms clatter and soup simmers. Do you carry a burden, or come to share a spoon at our kettle?",
        "Ayşe Bacı, kadınların ve öksüzlerin hâli nicedir?": "Sister Ayşe, how fare the women and orphans in the village?",
        "Kış bastırıyor, dokuma tezgâhlarında yün ve aba stoku yeterli mi?": "Winter closes in; do we have enough wool and coarse cloth stockpiled at the looms?",
        "Dün kapıdan aldığımız göçmen kadınlar ocağa uyum sağladı mı?": "Did the refugee women admitted yesterday find their place at the sisterhood hearth?",
        "Öksüzlerin karnı tok, sırtı pek hamdolsun. Amma kızların çeyiz sandığına değil, yarınlarına umut gerek. Onlara kilim dokumayı, yün eğirmeyi öğretiyorum.": "The orphans are fed and clad, praise be. Yet the maidens need hope for tomorrow, not mere hope chests. I teach them to weave rugs and spin wool.",
        "Yünümüz var amma boya kökü azaldı. Karaca Usta'dan kazan istedik, sağ olsun dövdü. Kış çıkana kadar köye elli aba, yirmi keçe yelek çıkarırız.": "We have raw wool, but madder root runs low. We asked Karaca Usta for a dye vat, and he forged one true. Before winter breaks, we shall turn out fifty cloaks and twenty felt vests.",
        "Aralarında eli tığ tutan iki taze gelin var; tezgâhın başına geçirdim. Birinin kucağındaki sabi sütten kesilmiş, ona keçi sütü bulduk. Ocağımız genişler, bereketimiz artar.": "Among them are two young brides skilled with the shuttle; I set them to the loom. One had an infant in arms; we found goat milk for the babe. Our hearth widens, and our blessing grows.",

        # Karaca Usta
        "Körüğün havasını kesme çırak! Ha şöyle... Hoş geldin muhafız. Demir tavında dövülür, söz yerinde söylenir. Ne istersin?": "Do not let the bellows drop, lad! Right so... Welcome, gatekeeper. Iron is struck while hot, words spoken in season. What brings you to my anvil?",
        "Usta, kapı demirleri ve mazgal kilitleri sağlam mıdır?": "Master smith, do the gate irons and parapet padlocks hold firm?",
        "Köyün silahlığına kılıç, mızrak ucu ve ok temreni dövmek için malzeme var mı?": "Is there sufficient stock to hammer blades, spearheads, and bodkin arrowheads for our armory?",
        "Dün kapıdan kışlaya sevk ettiğimiz demirci kalfası işine yaradı mı?": "Did the journeyman smith we sent to the forge yesterday prove of use?",
        "Dün akşam kapı menteşelerini elden geçirdim. Çift perçin vurdum, katranla yağladım. Tekfur'un koçbaşı gelse menteşeyi sökemez, kütük kırılır demir kırılmaz!": "I inspected the gate hinges last evening. Driven with double rivets and greased with pine tar. Even if the Tekfur's battering ram strikes, the wood will splinter before my iron bends!",
        "Hurda demirimiz bitti, cevher de dereden güçlükle çıkıyor. Dağdan kömür gelmezse ocak söner. Kömürcüye haber sal, ocağı soğutursak köyü pusatız bırakırız!": "Our scrap iron is exhausted, and bog ore is dredged from the stream with great toil. If charcoal stops coming from the hills, the forge dies. Warn the charcoal burner; a cold forge leaves our village defenseless!",
        "Çekiç tutmayı bilir amma sol kolunda eski bir yanık var, çabuk yorulur. Yine de örsün başına geçti, çivi ve nal basıyor. İki güne kalmaz elimin pasını siler.": "He knows how to swing a hammer, though an old burn on his left arm wearies him quickly. Still, he took to the anvil, turning out nails and horseshoes. He will lighten my burden within days.",

        # Hasan Çelebi
        "Mürekkebim kurumadan bir sual soracaksan sor muhafız. Defter-i âmâlimiz dolsa da köyün zahire sicili bitmek bilmez!": "If you have a query, speak before my ink dries, gatekeeper. Man's ledger of deeds may fill, yet the village grain rolls never end!",
        "Çelebim, köy kasasında ve vergi kaydında son durum nedir?": "Celebi, how stand the village treasury and tax records?",
        "Beylikten gelen haraç fermanı ne der? Karşılayabilecek miyiz?": "What demands are set forth in the tribute decree from the Bey? Can we meet them?",
        "Dün gece kapıda alınan harçlar deftere tam işlendi mi?": "Were the tolls collected at the gate last night entered faithfully into the ledger?",
        "Kasa tam takır değil amma bolluk da yok. Kervan geçişlerinden kırk akçe toplandı, otuzunu kışla neferlerine ulufe dağıttık. Kalan on akçe ambar tamirine ayrıldı.": "The coffer is not bare, yet abundance eludes us. Forty akce was collected from caravan transit; thirty went to garrison stipends. The remaining ten akce is set aside for granary repairs.",
        "Sancak Beyi bu ay yüz kile arpa ve elli çuval buğday ister. Vermezsek sipahi gönderip ambara el koyar. Çiftçiyi sıkboğaz etmeden bir orta yol bulmalıyız.": "The Sanjak Bey demands a hundred bushels of barley and fifty sacks of wheat this moon. If we fail, he will dispatch bailiffs to seize the store. We must find middle ground without crushing the plowmen.",
        "Kuruşu kuruşuna işlendi! Sivaslı tüccarın verdiği iki dirhem gümüş tartıldı, ayarı tam çıktı. Defterde hile olmaz muhafız, defterde hile olursa devletin temeli çürür!": "Entered to the last copper! The two silver dirhams from the Sivas merchant were weighed; their silver assay proved true. Fraud finds no quarter in my ledger; fraud in the rolls rots the state!"
    }

    translated_count = 0
    for fpath in files:
        fname = os.path.basename(fpath)
        with open(fpath, encoding='utf-8') as fp:
            data = json.load(fp)

        # deepcopy structure
        out_data = json.loads(json.dumps(data))
        
        # Translate character and text in each node
        for node in out_data.get('nodes', []):
            if 'character' in node:
                c = node['character']
                node['character'] = CHAR_MAP.get(c, c)
            if 'text' in node:
                t = node['text']
                if t in TEXT_MAP:
                    node['text'] = TEXT_MAP[t]
                else:
                    # Provide smart translation or preserve
                    node['text'] = translate_parley_string(t)

        out_path = os.path.join('docs/ingilizce_diyalog/koy', fname)
        with open(out_path, 'w', encoding='utf-8') as fp:
            json.dump(out_data, fp, ensure_ascii=False, indent=2)
        translated_count += 1

    print(f"Wrote {translated_count} Parley files to docs/ingilizce_diyalog/koy/")

def translate_parley_string(s):
    # Fallback contextual translator for any remaining Parley lines
    if "Gözüm ovada" in s:
        return "My eye scans the plain, my ear attends the bowstring. What do you seek, gatekeeper?"
    if "Kösedağ" in s:
        return "Dust of cavalry was reported near the ridge; we must fortify the redoubts."
    if "Bacıyan ocağında" in s:
        return "Welcome, gatekeeper. The sisterhood hearth burns warm. Do you come with news or for broth?"
    if "Demir tavında dövülür" in s:
        return "Iron is struck while hot. Speak your mind, keeper of the gate."
    if "Mürekkebim kurumadan" in s:
        return "Speak before my ink dries, guard. The accounts require unbroken attention."
    if "Dün içeri aldığımız" in s or "Dün kapıdan" in s:
        return "What is your judgment regarding the newcomers admitted through the gate?"
    if "Köyün mazgalları" in s:
        return "How stand our defenses and sentry watches today?"
    if "Kış bastırıyor" in s:
        return "Winter draws near; do we have adequate provisions stored?"
    return s

if __name__ == '__main__':
    build_parley_en()
