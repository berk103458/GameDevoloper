# -*- coding: utf-8 -*-
import json
from dil_taslak_uretici import append_translations

with open('tools/sablon_dump.json', encoding='utf-8') as f:
    sablon_data = json.load(f)

P4_DICT = {
    # asker
    'sablon.asker.acilis1': 'A sip of water, a quiet corner. I am wounded, yet I still walk. Whose man was I? Does it even matter in this desolate wilderness?',
    'sablon.asker.acilis2': 'Good evening to you. I laid down my blade; I wish to leave my name behind as well. Will you grant me a place by the ramparts?',
    'sablon.asker.ad1': 'A wounded soldier',
    'sablon.asker.ad2': 'A deserter',
    'sablon.asker.ad3': 'A dismounted sipahi',
    'sablon.asker.ad4': 'A border watchman',
    'sablon.asker.c1_c1': 'No one’s man any longer.',
    'sablon.asker.c1_c2': 'A sipahi’s man. He perished at Kosedag; I could not carry his body from the field.',
    'sablon.asker.c1_c3': 'Bahadir Bey’s man. Even if I spoke his name, you would not know it. None are left who remember.',
    'sablon.asker.c1_c4': 'Light. No one shouts commands at me now. Yet no one offers bread, either.',
    'sablon.asker.c1_c5': 'I would pledge my loyalty to whoever feeds me and knows how to draw a bow. Is that you?',
    'sablon.asker.c1_c6': 'I am standing on my two feet, am I not?',
    'sablon.asker.c1_c7': 'Do not stare so. Looking at the wound only seems to make the pain throb worse.',
    'sablon.asker.c1_c8': 'Everyone marched to battle. Then everyone was scattered on the highway.',
    'sablon.asker.c1_c9': 'Too much. I strive each night to forget most of it. What I cannot forget walks beside me.',
    'sablon.asker.c1_c10': 'I know how to draw a bow. I know how to hold a watch. I know how to remain silent in the dark.',
    'sablon.asker.c1_c11': 'Whatever task you assign. I have no appetite for sitting idle.',
    'sablon.asker.c1_c12': 'I carry an old composite bow. A handful of bodkin arrows. And this wound upon my shoulder.',
    'sablon.asker.c1_c13': 'Neither gold nor silver. If I possessed coin, would I stand begging in the frost?',
    'sablon.asker.c1_c14': 'I deserted. What shame is there in speaking true? When the commander fled on horseback, why should the footman bleed for a ditch?',
    'sablon.asker.c1_c15': 'I do not run from battle; I run from senseless slaughter. There is a distinction.',
    'sablon.asker.c1_c16': 'Give me bread, give me arrows. When the Tekfur’s raiders charge, you will see where I stand.',
    'sablon.asker.c1_c17': 'Let me sleep under the eaves tonight. If you find me lacking at sunrise, thrust me beyond the gate.',
    'sablon.asker.c1_c18': 'Cold wind gnaws through my leather jerkin. My fingers stiffen.',
    'sablon.asker.c1_c19': 'The horses in the rear were butchered for meat. The baggage train burned.',
    'sablon.asker.c1_c20': 'I seek neither fief nor gold. A roof and an honest command are enough.',
    'sablon.asker.s1': 'Whose banner did you march under?',
    'sablon.asker.s2': 'How does that wound upon your shoulder fare?',
    'sablon.asker.s3': 'What did you witness in the east?',
    'sablon.asker.s4': 'What skill do you bring to our garrison?',
    'sablon.asker.s5': 'What do you conceal in that sack?',
    'sablon.asker.s6': 'Did you flee from your post?',
    'sablon.asker.s7': 'Why should I admit you through the palisade?',

    # ciftci
    'sablon.ciftci.acilis1': 'Peace be upon you, gatekeeper. The Mongol horses trampled our valley into cinders. I clutch only this seed pouch; allow me to till your soil.',
    'sablon.ciftci.acilis2': 'We walked four nights through the marshes. My oxen died on the trail, but my two hands are strong and ready for the plow.',
    'sablon.ciftci.ad1': 'A dispossessed peasant',
    'sablon.ciftci.ad2': 'A plains farmer',
    'sablon.ciftci.ad3': 'A refugee vine-dresser',
    'sablon.ciftci.ad4': 'A plowman',
    'sablon.ciftci.c1_c1': 'From the plains beyond Konya. The tax collectors took the grain, then the riders burned the stubble.',
    'sablon.ciftci.c1_c2': 'A small hamlet near the river. Nothing remains standing except blackened chimney stones.',
    'sablon.ciftci.c1_c3': 'Three measures of hardy winter wheat. It yields sweet bread even in stony clay.',
    'sablon.ciftci.c1_c4': 'I guarded this seed in my bosom against the thieves. It is my children’s breath.',
    'sablon.ciftci.c1_c5': 'My wife succumbed to cough by the roadside. My boy walks behind me, keeping his head low.',
    'sablon.ciftci.c1_c6': 'He does not complain. Give him a crust of barley bread and he will herd geese till dusk.',
    'sablon.ciftci.c1_c7': 'I know when to turn the furrow before the frost strikes. I know how to mend an irrigation ditch.',
    'sablon.ciftci.c1_c8': 'If you give me a patch of hillside, I will turn it into green barley by springtime.',
    'sablon.ciftci.c1_c9': 'I have nothing hidden, effendi. Search the sack; you will find only dry pulse and salt.',
    'sablon.ciftci.c1_c10': 'Three copper mangirs. Not enough to tempt even a beggar.',
    'sablon.ciftci.c1_c11': 'We do not ask for handouts. We ask for earth to break with a hoe.',
    'sablon.ciftci.c1_c12': 'The earth does not hold grudges. If you tend her with sweat, she gives bread.',
    'sablon.ciftci.c1_c13': 'My hands are calloused like tree bark. Try them on your hardest soil.',
    'sablon.ciftci.c1_c14': 'I will sleep in the barn beside the cattle; the beasts’ breath will keep us from freezing.',
    'sablon.ciftci.s1': 'From which valley do you arrive?',
    'sablon.ciftci.s2': 'What grain do you carry in that cloth pouch?',
    'sablon.ciftci.s3': 'Who travels in your company?',
    'sablon.ciftci.s4': 'What craft do your hands possess?',
    'sablon.ciftci.s5': 'Do you hold coin to pay the gate toll?',
    'sablon.ciftci.s6': 'Where will you lay your head if admitted?',
    'sablon.ciftci.s7': 'Why seek shelter upon this dangerous frontier?',

    # esnaf
    'sablon.esnaf.acilis1': 'Greetings, noble guard. I carry needles, thread, whetstones, and copper wire. If there is a bazaar inside, I bring fair commerce.',
    'sablon.esnaf.acilis2': 'May your evening be prosperous. My mule is laden with woolen felt and salt blocks from Tuz Golu. Grant me shelter at the caravanserai.',
    'sablon.esnaf.ad1': 'A peddler',
    'sablon.esnaf.ad2': 'An itinerant tanner',
    'sablon.esnaf.ad3': 'A pack-horse trader',
    'sablon.esnaf.ad4': 'An ironmonger',
    'sablon.esnaf.c1_c1': 'From Aksaray. The trade road was cut by mountain outlaws; I had to veer through goat tracks.',
    'sablon.esnaf.c1_c2': 'From the Byzantine border markets. Silk is cheap there, but iron is worth its weight in silver.',
    'sablon.esnaf.c1_c3': 'Three bags of rock salt, four pairs of shear blades, and a bundle of sheepskins.',
    'sablon.esnaf.c1_c4': 'I have two bolts of dyed wool. Sturdy enough to withstand the harshest mountain blizzard.',
    'sablon.esnaf.c1_c5': 'Here is my transit permit sealed by the Ahi lodge of Eskisehir.',
    'sablon.esnaf.c1_c6': 'I pay my lawful gate toll in good silver akce, not with clipped copper.',
    'sablon.esnaf.c1_c7': 'I know the price of grain in three provinces. I can tell your scribe where wheat is scarce.',
    'sablon.esnaf.c1_c8': 'A fair merchant brings prosperity to a settlement; where caravans pause, gold lingers.',
    'sablon.esnaf.c1_c9': 'I seek only a stall in your market square and hay for my mule.',
    'sablon.esnaf.c1_c10': 'I do not traffic in stolen gear or heathen idols; my ledger is open to the judge.',
    'sablon.esnaf.c1_c11': 'Bandits ambushed the caravan two leagues back; I survived only because my mule sure-footed escaped into the gully.',
    'sablon.esnaf.c1_c12': 'Let me enter before the mist thickens; wolves are howling along the creek bed.',
    'sablon.esnaf.s1': 'What wares do you bring to market?',
    'sablon.esnaf.s2': 'Do you hold a merchant patent or guild seal?',
    'sablon.esnaf.s3': 'What news do you carry from the trade highways?',
    'sablon.esnaf.s4': 'Can you pay the merchant toll in silver akce?',
    'sablon.esnaf.s5': 'Did you encounter robbers on the road?',
    'sablon.esnaf.s6': 'How long do you intend to lodge within our walls?',
    'sablon.esnaf.s7': 'Who stands surety for your honesty?'
}

for k, tr in sablon_data.items():
    if k not in P4_DICT:
        P4_DICT[k] = tr

if __name__ == '__main__':
    append_translations(P4_DICT, "Parti A4: Şablon Metinleri")
