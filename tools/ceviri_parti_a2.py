# -*- coding: utf-8 -*-
import sys
from dil_taslak_uretici import append_translations

P2_DICT = {
    # ahi_haber
    'olay.ahi_haber.baslik': 'Tidings from Kayseri',
    'olay.ahi_haber.metin': 'A messenger arrived from the grand Ahi lodge in Kayseri. They formally recognize the new lodge.',
    'olay.ahi_haber.secenek1': 'Bind to the lodge',
    'olay.ahi_haber.secenek2': 'Remain independent',
    'olay.ahi_haber.sonuc1': 'The sash of the brotherhood arrived bearing the seal of Kayseri.',
    'olay.ahi_haber.sonuc2': 'The messenger departed sullen and aggrieved.',

    # ambarda_hirsizlik
    'olay.ambarda_hirsizlik.baslik': 'Night Theft at the Granary',
    'olay.ambarda_hirsizlik.metin': 'At midnight, the padlock of the village granary was forced, and two sacks of seed wheat were stolen. The folk blame the newcomers admitted at the gate.',
    'olay.ambarda_hirsizlik.secenek1': 'Musters sentries from the barracks and search the village houses one by one',
    'olay.ambarda_hirsizlik.secenek2': "Trust Saruca Hatun's surety; quietly replenish the granary (spend 2 akce)",
    'olay.ambarda_hirsizlik.secenek3': 'Cover up the theft; quell rumors from spreading',
    'olay.ambarda_hirsizlik.sonuc1': 'The search was harsh, unsettling the villagers, yet part of the grain was recovered and order restored.',
    'olay.ambarda_hirsizlik.sonuc2': 'The loss was remedied; Saruca Hatun guarded the rights of orphans and gave discreet warning to the culprit.',
    'olay.ambarda_hirsizlik.sonuc3': 'The matter was hushed up, yet the granary watchman stands guard in gnawing suspicion.',

    # asik
    'olay.asik.baslik': 'The Wandering Bard with Kopuz',
    'olay.asik.dinle': 'Convene an assembly in the square; let him pluck and sing',
    'olay.asik.gonder': 'The village has enough sorrow of its own; send him on his road',
    'olay.asik.metin': 'At twilight, a wandering bard with a kopuz strapped to his back nears the gate. He chants songs of the steppe, the clashes of beys, and the melancholy of exile; the hearts of the folk ache.',
    'olay.asik.sonuc1': 'The bard plucked the strings; gathered under the plane tree, the villagers forgot their grief in song, and hearts were cheered.',
    'olay.asik.sonuc2': 'The bard bowed his head and trudged onward; the village square remained bleak and silent.',

    # aydogdu_oba
    'olay.aydogdu_oba.baslik': 'Arrival of the Clan',
    'olay.aydogdu_oba.metin': "Aydogdu's clan arrived at the gate: twenty souls, thirty sheep, two ox-carts.",
    'olay.aydogdu_oba.secenek1': 'Admit them all',
    'olay.aydogdu_oba.secenek2': 'Admit only the warriors',
    'olay.aydogdu_oba.secenek3': 'Turn the clan away',
    'olay.aydogdu_oba.sonuc1': 'The sheep replenished the stores; the tents made the village crowded.',
    'olay.aydogdu_oba.sonuc2': "The women and children of the clan trudged onward. Aydogdu did not look back as he saw them off.",
    'olay.aydogdu_oba.sonuc3': "At dawn, Aydogdu mounted his steed and rode out to pursue his clan.",

    # ayse_tezgah
    'olay.ayse_tezgah.baslik': 'Loom of the Sisters',
    'olay.ayse_tezgah.metin': 'Ayse Baci gathered the women of the village at the loom. They intend to weave rugs and sell them in market.',
    'olay.ayse_tezgah.secenek1': 'Support them (two akce)',
    'olay.ayse_tezgah.secenek2': "Women's place is in the fields",
    'olay.ayse_tezgah.sonuc1': 'The first rug fetched three akce at the market.',
    'olay.ayse_tezgah.sonuc2': 'The loom was stowed away in a corner.',

    # bebek
    'olay.bebek.baslik': 'A Newborn',
    'olay.bebek.ad_koy': 'Name the child and offer a blessing',
    'olay.bebek.kutla': 'Send a loaf of bread and a scoop of honey to the home',
    'olay.bebek.metin': 'In one of the huts by the palisade, a woman has delivered a healthy boy. The father brings tidings to the gate with flushed cheeks.',
    'olay.bebek.sonuc1': 'You bestowed a brave warrior’s name upon the child; the parents thanked you with tears in their eyes.',
    'olay.bebek.sonuc2': 'The hearth was warmed with honey and bread; the blessing of plenty was invoked upon the village.',

    # bey_daveti
    'olay.bey_daveti.baslik': "The Bey's Summons",
    'olay.bey_daveti.metin': "A horseman bearing the Sanjak Bey's banner rode up. The Bey summons you to dinner at his seat.",
    'olay.bey_daveti.secenek1': 'Ride to the banquet',
    'olay.bey_daveti.secenek2': 'Refuse, pleading the gate cannot be left unattended',
    'olay.bey_daveti.sonuc1': 'The Bey spoke highly of your vigil and rewarded you with a pouch of coin.',
    'olay.bey_daveti.sonuc2': 'The courier departed frowning; the Bey does not take kindly to cold excuses.',

    # dervis
    'olay.dervis.baslik': 'The Wandering Dervish',
    'olay.dervis.dua': 'Humbly ask for his blessing upon the march',
    'olay.dervis.ekmek': 'Fill his wooden bowl with warm soup and bread',
    'olay.dervis.metin': 'A barefoot dervish wearing a felt cloak stands by the threshold. He leans upon his staff, gazing into the eyes of men as though reading their ledger of sins.',
    'olay.dervis.sonuc1': 'The dervish lifted his palms and murmured a prayer; a tranquil calm descended upon the gatehouse.',
    'olay.dervis.sonuc2': 'The traveler broke bread, blessed the sustenance, and vanished into the evening mist.',

    # dugun
    'olay.dugun.baslik': 'A Wedding Celebration',
    'olay.dugun.metin': 'The blacksmith Karaca Usta is giving his apprentice in marriage to the daughter of the miller. The entire village prepares for a feast.',
    'olay.dugun.secenek1': 'Contribute five akce to the feast table from the communal purse',
    'olay.dugun.secenek2': 'Attend the wedding and dance the halay with the elders',
    'olay.dugun.secenek3': 'Keep watches doubled; weddings breed drunken negligence',
    'olay.dugun.sonuc1': 'The drums beat till dawn, roast mutton was shared, and the villagers toasted your benevolence.',
    'olay.dugun.sonuc2': 'Your presence in the dance honored the hosts; respect for the gatekeeper deepened.',
    'olay.dugun.sonuc3': 'While merriment echoed, the vigilant watch caught two prowlers attempting to scale the orchard wall.',

    # ertugrul_haberi
    'olay.ertugrul_haberi.baslik': 'Tidings from the West',
    'olay.ertugrul_haberi.metin': 'Couriers speak of Ertugrul Gazi securing strong footholds toward Sogut and Domanic. The Byzantine border is stirring.',
    'olay.ertugrul_haberi.secenek1': 'Send an envoy pledging fraternal loyalty',
    'olay.ertugrul_haberi.secenek2': 'Tend strictly to our own borders',
    'olay.ertugrul_haberi.sonuc1': 'Our riders returned bearing gifts and warm greetings from the west.',
    'olay.ertugrul_haberi.sonuc2': 'We kept our eyes fixed on our own palisades, minding our own perimeter.',

    # firari_cenazesi
    'olay.firari_cenazesi.baslik': 'Burial of the Vagrant Frozen in the Pass',
    'olay.firari_cenazesi.metin': 'The corpse of an unknown fugitive who froze to death in the northern mountain pass was brought before the gate. The village imam asks where to lay him to rest.',
    'olay.firari_cenazesi.secenek1': 'Bury him in the village graveyard with full funeral rites and shroud',
    'olay.firari_cenazesi.secenek2': 'Bury him outside the palisade, past the road marker, without drawing notice',
    'olay.firari_cenazesi.secenek3': 'Send a rider to the nearby castle to inquire if a bounty hangs on his head',
    'olay.firari_cenazesi.sonuc1': 'The prayer was held solemnly; the folk appreciated that no soul was denied mercy in death.',
    'olay.firari_cenazesi.sonuc2': 'He was interred beyond the wall; superstition and unease gripped the village outskirts.',
    'olay.firari_cenazesi.sonuc3': 'The garrison across the border claimed no knowledge, and the corpse was interred in cold delay.',

    # gece_donu
    'olay.gece_donu.baslik': 'Sudden Midnight Frost',
    'olay.gece_donu.metin': 'A merciless frost descended upon the village before nightfall. The newly planted greens and stored root vegetables risk freezing in the huts.',
    'olay.gece_donu.secenek1': 'Distribute firewood from the communal stockpile to all needy homes',
    'olay.gece_donu.secenek2': 'Open the warm stables and workshops for shelter',
    'olay.gece_donu.secenek3': 'Keep stores sealed; let each hearth fend with its own wood',
    'olay.gece_donu.sonuc1': 'Communal firewood preserved the warmth; no infant or elder succumbed to the cold.',
    'olay.gece_donu.sonuc2': 'Folk and beasts slept huddled under shared roofs; camaraderie warmed the bitter frost.',
    'olay.gece_donu.sonuc3': 'Several pens lost lambs to the freeze, and bitter complaints reached the gate.',

    # harami_elcisi
    'olay.harami_elcisi.baslik': 'Threatening Note from Mountain Brigands',
    'olay.harami_elcisi.metin': 'A hooded rider flung an arrow wrapped in parchment into the gatepost: "Pay thirty akce by the full moon, or your mills and outlying crops burn."',
    'olay.harami_elcisi.secenek1': 'Scorn the threat, double the gate sentries, and sharpen the stakes',
    'olay.harami_elcisi.secenek2': 'Send an intermediary to negotiate a smaller tribute (10 akce)',
    'olay.harami_elcisi.secenek3': 'Lure their envoys into an ambush at the crossroads',
    'olay.harami_elcisi.sonuc1': 'The palisade was bristling with archers; the outlaws tested the approaches and slunk away.',
    'olay.harami_elcisi.sonuc2': 'A compromise was struck; blood was spared, though the tribute stung our treasury.',
    'olay.harami_elcisi.sonuc3': 'Two brigands were slain in the trap; the rest retreated into the high crags swearing vengeance.',

    # harman
    'olay.harman.baslik': 'Threshing Floor',
    'olay.harman.metin': 'The threshing has ended. The farmers await the division of grain between the commune, the tithe, and the seed store.',
    'olay.harman.secenek1': 'Grant the farmers an extra share',
    'olay.harman.secenek2': 'Adhere strictly to the Bey’s customary tax',
    'olay.harman.secenek3': 'Stockpile all surplus in the communal granary for lean winter',
    'olay.harman.sonuc1': 'The farmers praised your generosity across every hearth.',
    'olay.harman.sonuc2': 'The customary dues were collected without protest or incident.',
    'olay.harman.sonuc3': 'The granaries swelled full, though some grumbled at their lightened flour bags.',

    # hasan_defter
    'olay.hasan_defter.baslik': "The Scribe's Ledger",
    'olay.hasan_defter.metin': 'Hasan Celebi uncovered a discrepancy in the taxation scrolls: three merchants paid less toll than recorded.',
    'olay.hasan_defter.secenek1': 'Summon the merchants and demand back-taxes',
    'olay.hasan_defter.secenek2': 'Pardon the shortfall in the spirit of trade goodwill',
    'olay.hasan_defter.secenek3': 'Audit Hasan Celebi’s own accounts to ensure honesty',
    'olay.hasan_defter.sonuc1': 'The merchants begrudgingly paid the owed akce; justice was upheld.',
    'olay.hasan_defter.sonuc2': 'Trade flowed smoothly and merchants spoke well of the village hospitality.',
    'olay.hasan_defter.sonuc3': 'The scribe was offended by the suspicion, yet his ledgers proved immaculate.',

    # hirsizlik
    'olay.hirsizlik.baslik': 'Theft at the Market',
    'olay.hirsizlik.metin': 'A visiting cloth merchant shouts in fury: two bolts of scarlet silk were stolen from his cart while he bargained.',
    'olay.hirsizlik.secenek1': 'Search the market crowd and seal the exits',
    'olay.hirsizlik.secenek2': 'Compensate the merchant half the loss from the toll coffer',
    'olay.hirsizlik.secenek3': 'Tell him vigilance is his own duty and dismiss the complaint',
    'olay.hirsizlik.sonuc1': 'The thief was cornered behind the tanneries; the silk was returned and the rogue put in irons.',
    'olay.hirsizlik.sonuc2': 'The merchant left appeased, though the treasury bore the penalty.',
    'olay.hirsizlik.sonuc3': 'The merchant packed his goods in rancor, swearing never to trade at our gates again.',

    # kacak_koylu
    'olay.kacak_koylu.baslik': 'Night Runaways',
    'olay.kacak_koylu.metin': 'Three tenant peasants fleeing the heavy dues of the neighboring Byzantine feudal lord crossed the creek at dusk, begging for sanctuary.',
    'olay.kacak_koylu.secenek1': 'Grant them asylum and assign them to the fallow fields',
    'olay.kacak_koylu.secenek2': 'Hand them back to the Tekfur’s border reeves to prevent strife',
    'olay.kacak_koylu.sonuc1': 'The men took up the plow with fervent gratitude, strengthening our agricultural labor.',
    'olay.kacak_koylu.sonuc2': 'They were returned in chains; the village felt a chill of dishonor.',

    # kadi
    'olay.kadi.baslik': 'Deputy Kadi of the Sanjak',
    'olay.kadi.metin': 'The deputy judge arrived with his clerks to review border disputes and inheritance deeds.',
    'olay.kadi.secenek1': 'Present the court with a feast and open all registers',
    'olay.kadi.secenek2': 'Let him conduct his business curtly without state fanfare',
    'olay.kadi.sonuc1': 'The Kadi praised the lawful order of your settlement and confirmed land entitlements.',
    'olay.kadi.sonuc2': 'The court proceeded routinely and departed without notable acclaim.',

    # kapi_acilisi
    'olay.kapi_acilisi.baslik': "The Sanjak Bey's Patent",
    'olay.kapi_acilisi.metin': "The parchment bearing the Sanjak Bey's tughra has been unrolled: you are officially entrusted with the gate, the toll, and the march.",
    'olay.kapi_acilisi.onayla': 'Accept the charge with solemn vow',
    'olay.kapi_acilisi.sonuc': 'The heavy oaken gate swings open on iron hinges. The frontier vigil has commenced.',

    # karaca_ocak
    'olay.karaca_ocak.baslik': 'The Ahi Forge',
    'olay.karaca_ocak.metin': 'Karaca Usta wishes to recruit three young apprentices to forge scythes, horseshoes, and spearheads.',
    'olay.karaca_ocak.secenek1': 'Fund iron and coal from the village fund',
    'olay.karaca_ocak.secenek2': 'Let the smithy sustain itself on commercial orders',
    'olay.karaca_ocak.sonuc1': 'Sparks flew high; sturdy tools and sharp iron bolstered our village defense.',
    'olay.karaca_ocak.sonuc2': 'Work progressed slowly as coal was scarce, yet no gold was lost.',

    # kavga_harman
    'olay.kavga_harman.baslik': 'Border Brawl at the Threshing Floor',
    'olay.kavga_harman.metin': 'A violent quarrel broke out between the old villagers and newly settled refugees over the boundary ditch dividing the grain piles.',
    'olay.kavga_harman.secenek1': 'Ride between them, plant a boundary stone by decree, and fine the brawlers',
    'olay.kavga_harman.secenek2': 'Let the council of village elders arbitrate the dispute under the oak',
    'olay.kavga_harman.secenek3': 'Confiscate the disputed pile of grain for the communal granary',
    'olay.kavga_harman.sonuc1': 'A firm hand suppressed the brawl; justice was served without bloodshed.',
    'olay.kavga_harman.sonuc2': 'The elders spent half the day deliberating, reaching a peaceful compromise.',
    'olay.kavga_harman.sonuc3': 'Both parties resented the confiscation, but the brawl ceased immediately.',

    # kervan
    'olay.kervan.baslik': 'The Grand Caravan',
    'olay.kervan.metin': 'A rich caravan laden with Persian silks, Damascus spices, and salt blocks asks for night quarter in the kervansaray.',
    'olay.kervan.secenek1': 'Charge standard tolls and provide full night guard',
    'olay.kervan.secenek2': 'Offer escort through the bandit-infested defile for extra silver',
    'olay.kervan.secenek3': 'Turn them away fearing they may harbor plague or spies',
    'olay.kervan.sonuc1': 'The caravan rested securely and spent generously at local shops.',
    'olay.kervan.sonuc2': 'The escort led them safely through; the caravan master praised our valor.',
    'olay.kervan.sonuc3': 'The caravan marched onward, taking its wealth to a rival settlement.',

    # kitlik
    'olay.kitlik.baslik': 'Bottom of the Granary',
    'olay.kitlik.metin': 'Severe winter and poor harvests have depleted grain stores. Bread portions must be rationed.',
    'olay.kitlik.secenek1': 'Ration grain strictly: half-portion per soul',
    'olay.kitlik.secenek2': 'Buy grain from passing merchants even at exorbitant prices',
    'olay.kitlik.secenek3': 'Send hunting parties into the northern woods for game',
    'olay.kitlik.sonuc1': 'Belts tightened, but the stores lasted until early thaw.',
    'olay.kitlik.sonuc2': 'The coffer emptied rapidly, but no child went hungry.',
    'olay.kitlik.sonuc3': 'Hunters returned with deer and wild boar; spirits rose in adversity.',

    # koy_dugunu
    'olay.koy_dugunu.baslik': "Village Wedding of the Orphan Maid",
    'olay.koy_dugunu.metin': 'The orphan maiden raised by Saruca Hatun is marrying a shepherd lad. The village desires a joyful celebration despite the grim times.',
    'olay.koy_dugunu.secenek1': 'Provide a sheep from communal stock and anoint the couple with good will',
    'olay.koy_dugunu.secenek2': 'Exempt the groom from sentry duty for three nights',
    'olay.koy_dugunu.secenek3': 'Keep celebration modest; permit neither excess expense nor loud noise',
    'olay.koy_dugunu.sonuc1': 'The wedding feast lifted village morale; hope was renewed along the frontier.',
    'olay.koy_dugunu.sonuc2': 'The groom was profoundly grateful; his kin became loyal allies.',
    'olay.koy_dugunu.sonuc3': 'The rite was brief and sober, preserving resources for harsher days.',

    # kurt
    'olay.kurt.baslik': 'The Wolf in the Fold',
    'olay.kurt.metin': 'A pack of hungry wolves raided the sheep pens under cover of fog, killing five ewes and injuring a shepherd.',
    'olay.kurt.secenek1': 'Dispatch huntsmen to track and eliminate the wolf pack',
    'olay.kurt.secenek2': 'Fortify the pen palisades and assign extra hounds',
    'olay.kurt.secenek3': 'Compensate the shepherd for his loss from the village fund',
    'olay.kurt.sonuc1': 'Three wolf pelts were brought back; the woods were made safer.',
    'olay.kurt.sonuc2': 'Stronger barriers kept the beasts at bay on subsequent nights.',
    'olay.kurt.sonuc3': 'The shepherd wept in gratitude, relieved of devastating ruin.',

    # miraen_cavus
    'olay.miraen_cavus.baslik': 'The Seljuk Sergeant',
    'olay.miraen_cavus.metin': 'Sergeant Miraen reports that border discipline has slackened and recommends rigorous drills for the garrison nefers.',
    'olay.miraen_cavus.secenek1': 'Authorize grueling daily drill and weapons training',
    'olay.miraen_cavus.secenek2': 'Keep training moderate to avoid wearing out the men',
    'olay.miraen_cavus.secenek3': 'Direct attention to repairing walls and digging trenches instead',
    'olay.miraen_cavus.sonuc1': 'The garrison became razor-sharp, ready for sudden cavalry assaults.',
    'olay.miraen_cavus.sonuc2': 'The men maintained high morale without excessive exhaustion.',
    'olay.miraen_cavus.sonuc3': 'The fortifications stood renewed and formidable against siege.',

    # mogol_duman
    'olay.mogol_duman.baslik': 'Smoke on the Horizon',
    'olay.mogol_duman.metin': 'Thick columns of black smoke rose to the east. Scouts report a Mongol scouting party raiding outlying hamlets.',
    'olay.mogol_duman.secenek1': 'Bar the gates, raise drawbridges, and light warning beacons',
    'olay.mogol_duman.secenek2': 'Dispatch fast horsemen to rescue survivors from the hamlets',
    'olay.mogol_duman.secenek3': 'Prepare tribute and peace emissaries to avoid confrontation',
    'olay.mogol_duman.sonuc1': 'The gates held firm; the marauders bypassed our defended walls.',
    'olay.mogol_duman.sonuc2': 'A dozen fleeing families were brought inside safely before nightfall.',
    'olay.mogol_duman.sonuc3': 'The riders accepted silver and withdrew without burning our fields.',

    # nogay_haber
    'olay.nogay_haber.baslik': "Warning of the Interpreter",
    'olay.nogay_haber.metin': 'Nogay warns that foreign merchant bands are inquiring suspiciously about village stockpile locations and gate guard rosters.',
    'olay.nogay_haber.secenek1': 'Place suspicious foreigners under covert surveillance',
    'olay.nogay_haber.secenek2': 'Expel suspects beyond the march boundary immediately',
    'olay.nogay_haber.sonuc1': 'A hidden letter addressed to enemy raiders was intercepted.',
    'olay.nogay_haber.sonuc2': 'The foreigners were ejected, leaving the village securely guarded.',

    # okculuk
    'olay.okculuk.baslik': 'The Archery Tourney',
    'olay.okculuk.metin': 'The youth and veteran soldiers gather at the shooting butts to compete for a prize bow of horn and sinew.',
    'olay.okculuk.secenek1': 'Offer five akce prize to the winner',
    'olay.okculuk.secenek2': 'Step onto the line and take part in the match yourself',
    'olay.okculuk.secenek3': 'Use the gathering to recruit the best marksmen into the gate guard',
    'olay.okculuk.sonuc1': 'Cheers resounded; the victor hoisted your banner high.',
    'olay.okculuk.sonuc2': 'Your arrow split the target mark, earning roar of admiration.',
    'olay.okculuk.sonuc3': 'Three sharp-eyed archers were added to our ramparts.',

    # pazar_gunu
    'olay.pazar_gunu.baslik': 'Market Day',
    'olay.pazar_gunu.metin': 'Caravans and peasants from three valleys converge on the village square. Trade bustles with vibrant energy.',
    'olay.pazar_gunu.secenek1': 'Lower market dues to stimulate higher trade volume',
    'olay.pazar_gunu.secenek2': 'Enforce strict weights and measures inspections',
    'olay.pazar_gunu.sonuc1': 'Merchants flocked in droves; commerce flourished briskly.',
    'olay.pazar_gunu.sonuc2': 'Fraudulent scales were broken, earning praise from the poor.',

    # salgin
    'olay.salgin.baslik': 'The Coughing Sickness',
    'olay.salgin.metin': 'A persistent fever and barking cough has taken hold of several cottages. The herbalist warns it may spread.',
    'olay.salgin.secenek1': 'Quarantine the afflicted huts and provide herbal teas',
    'olay.salgin.secenek2': 'Open the apothecary stores and purchase vinegar and mint',
    'olay.salgin.secenek3': 'Carry on normally; trust in hardy constitutions',
    'olay.salgin.sonuc1': 'The sickness was contained within isolated quarters and abated.',
    'olay.salgin.sonuc2': 'Remedies alleviated suffering; recovery came swiftly.',
    'olay.salgin.sonuc3': 'The illness spread to more households before fading away.',

    # salgin_fisiltisi
    'olay.salgin_fisiltisi.baslik': 'Plague Whispers by the Well',
    'olay.salgin_fisiltisi.metin': 'Women drawing water at dawn spread rumors that a newly arrived traveler drank from the communal well while burning with black spots on his neck.',
    'olay.salgin_fisiltisi.secenek1': 'Seal the well, boil all drinking water, and test the traveler’s health',
    'olay.salgin_fisiltisi.secenek2': 'Summon Thessra and the healers to examine the well and dispel panic',
    'olay.salgin_fisiltisi.secenek3': 'Punish the rumor-mongers for creating baseless terror',
    'olay.salgin_fisiltisi.sonuc1': 'Precautionary measures halted hysteria; the well water proved pure.',
    'olay.salgin_fisiltisi.sonuc2': 'Thessra reassured the folk with medicinal herbs and rational guidance.',
    'olay.salgin_fisiltisi.sonuc3': 'The rumors quieted down, though people still eyed the water warily.',

    # samanlik_yangini
    'olay.samanlik_yangini.baslik': 'Midnight Barn Fire',
    'olay.samanlik_yangini.metin': 'Flames erupted in the community hay barn in the dead of night. Sparks fly toward nearby residential thatch roofs.',
    'olay.samanlik_yangini.secenek1': 'Mobilize the bucket brigade and tear down connecting thatched sheds',
    'olay.samanlik_yangini.secenek2': 'Evacuate livestock from adjoining stables first',
    'olay.samanlik_yangini.secenek3': 'Focus all water solely on shielding the grain storehouse',
    'olay.samanlik_yangini.sonuc1': 'The blaze was conquered before spreading to dwellings, though fodder was lost.',
    'olay.samanlik_yangini.sonuc2': 'Every cow and horse was saved unharmed; the village praised your quick thinking.',
    'olay.samanlik_yangini.sonuc3': 'The granary emerged unscathed, securing our bread supply.',

    # saruca_tohum
    'olay.saruca_tohum.baslik': 'The Seed Stock',
    'olay.saruca_tohum.metin': 'Saruca Hatun requests that the best grain be set aside strictly for planting next season rather than milled for flour.',
    'olay.saruca_tohum.secenek1': 'Lock away seed sacks under her personal seal',
    'olay.saruca_tohum.secenek2': 'Mill part of it now to relieve immediate bread shortages',
    'olay.saruca_tohum.sonuc1': 'The future harvest was safeguarded against short-sighted hunger.',
    'olay.saruca_tohum.sonuc2': 'Loaves were baked today, but planting season may prove meager.',

    # sira
    'olay.sira.baslik': 'The Queue at the Gate',
    'olay.sira.metin': 'A long line of wagons, refugees, and pilgrims waits patiently before the gate in the cold morning wind.',
    'olay.sira.secenek1': 'Accelerate inspections to clear the line before dark',
    'olay.sira.secenek2': 'Maintain thorough, unhurried checks on every soul',
    'olay.sira.sonuc1': 'The crowd entered without bottleneck before sundown.',
    'olay.sira.sonuc2': 'Not a single hidden contraband slipped past our scrutiny.',

    # sira_atlama
    'olay.sira_atlama.baslik': 'Line Cutter',
    'olay.sira_atlama.metin': 'An arrogant merchant with three laden mules pushed ahead of waiting women and elders, demanding immediate entry.',
    'olay.sira_atlama.secenek1': 'Send him to the very back of the line and levy a double toll',
    'olay.sira_atlama.secenek2': 'Permit him through if he pays extra fee for expedited processing',
    'olay.sira_atlama.sonuc1': 'The crowd cheered the enforcement of fair order.',
    'olay.sira_atlama.sonuc2': 'The treasury gained coin, though waiting folk grumbled.',

    # sira_bayilma
    'olay.sira_bayilma.baslik': 'Collapse in Line',
    'olay.sira_bayilma.metin': 'An elderly woman carrying a bundle collapsed on the frozen earth after waiting hours in line.',
    'olay.sira_bayilma.secenek1': 'Carry her into the guardhouse, revive her with warm broth, and admit her',
    'olay.sira_bayilma.secenek2': 'Have her companions tend to her by the roadside fires',
    'olay.sira_bayilma.secenek3': 'Call the village apothecary immediately',
    'olay.sira_bayilma.sonuc1': 'She regained her strength and blessed the gatekeeper with heartfelt tears.',
    'olay.sira_bayilma.sonuc2': 'Her kin tended to her by the fire until she could stand.',
    'olay.sira_bayilma.sonuc3': 'Herbal tinctures revived her safely.',

    # sira_kavga
    'olay.sira_kavga.baslik': 'Fight in the Queue',
    'olay.sira_kavga.metin': 'Two armed grooms from rival trade companies began trading blows over grazing spots by the ditch.',
    'olay.sira_kavga.secenek1': 'Send guards to disarm both men and throw them in the stockade',
    'olay.sira_kavga.secenek2': 'Order their masters to resolve the dispute or lose their passage',
    'olay.sira_kavga.sonuc1': 'The brawl was quelled instantly; weapons were confiscated.',
    'olay.sira_kavga.sonuc2': 'The caravan masters silenced their servants swiftly.',

    # sira_panik
    'olay.sira_panik.baslik': 'Panic: Riders Approaching',
    'olay.sira_panik.metin': 'A sudden shout arose from the rear: "Horsemen approaching through the dust!" People surge toward the gate.',
    'olay.sira_panik.secenek1': 'Hold the gate firm and calm the crowd with firm voice',
    'olay.sira_panik.secenek2': 'Open the wicket gate and allow women and children in first',
    'olay.sira_panik.sonuc1': 'The horsemen turned out to be our own scouts; calm was restored.',
    'olay.sira_panik.sonuc2': 'The vulnerable were sheltered safely without trampling.',

    # sira_vazgecen
    'olay.sira_vazgecen.baslik': 'Turning Back',
    'olay.sira_vazgecen.metin': 'A family with two small children turned their cart around, weary of the cold and waiting.',
    'olay.sira_vazgecen.secenek1': 'Call them forward and grant them priority inspection',
    'olay.sira_vazgecen.secenek2': 'Let them depart in peace if they wish',
    'olay.sira_vazgecen.sonuc1': 'The family was admitted and sheltered from the frost.',
    'olay.sira_vazgecen.sonuc2': 'They took the southern road toward warmer valleys.',

    # sorhan_damga
    'olay.sorhan_damga.baslik': 'Branded Horses',
    'olay.sorhan_damga.metin': 'Sorhan suspects that five fine stallions brought by a trader bear the tamga of a raided Seljuk imperial stud farm.',
    'olay.sorhan_damga.secenek1': 'Seize the horses for the border garrison',
    'olay.sorhan_damga.secenek2': 'Interrogate the trader about their provenance',
    'olay.sorhan_damga.secenek3': 'Permit passage upon payment of high livestock duty',
    'olay.sorhan_damga.sonuc1': 'The steeds bolstered our cavalry patrol immensely.',
    'olay.sorhan_damga.sonuc2': 'The trader confessed to buying them cheaply from bandits.',
    'olay.sorhan_damga.sonuc3': 'The coffers swelled with hefty duty.',

    # sur_catlak
    'olay.sur_catlak.baslik': 'Fissure in the Palisade',
    'olay.sur_catlak.metin': 'Winter frost and ground movement caused a wide crack in the stone footing of the western palisade.',
    'olay.sur_catlak.secenek1': 'Mobilize stonecutters and timber-men for immediate repair',
    'olay.sur_catlak.secenek2': 'Shore it up temporarily with oak timber and earth',
    'olay.sur_catlak.secenek3': 'Post a permanent guard until spring weather permits mason work',
    'olay.sur_catlak.sonuc1': 'The wall footing was restored stronger than before.',
    'olay.sur_catlak.sonuc2': 'The emergency props held securely against collapse.',
    'olay.sur_catlak.sonuc3': 'A sentry watched the breach faithfully day and night.',

    # tarla_cekirge
    'olay.tarla_cekirge.baslik': 'Locust Swarm',
    'olay.tarla_cekirge.metin': 'A swarm of locusts from the southern steppe descended on the barley plots.',
    'olay.tarla_cekirge.secenek1': 'Drive them off with smoke fires and noise across the fields',
    'olay.tarla_cekirge.secenek2': 'Reap whatever unripe crops can be salvaged immediately',
    'olay.tarla_cekirge.sonuc1': 'Smoke diverted the swarm, saving the majority of the crop.',
    'olay.tarla_cekirge.sonuc2': 'Partial yield was salvaged into the barn.',

    # tarla_don
    'olay.tarla_don.baslik': 'Early Ground Frost',
    'olay.tarla_don.metin': 'Sudden frost glazed the young crops with white rime.',
    'olay.tarla_don.secenek1': 'Burn damp straw along field borders to shield against frost',
    'olay.tarla_don.secenek2': 'Wait out the morning sun and assess damage',
    'olay.tarla_don.sonuc1': 'Warm smoke blanketed the fields, rescuing the sprouts.',
    'olay.tarla_don.sonuc2': 'Some shoots were nipped, but resilient roots survived.',

    # tarla_kuraklik
    'olay.tarla_kuraklik.baslik': 'Summer Drought',
    'olay.tarla_kuraklik.metin': 'Weeks have passed without a raindrop; irrigation ditches are cracked and dry.',
    'olay.tarla_kuraklik.secenek1': 'Organize collective digging to deepen the spring channel',
    'olay.tarla_kuraklik.secenek2': 'Ration well water strictly between beasts and crops',
    'olay.tarla_kuraklik.sonuc1': 'Fresh water surged from the hillside, quenching parched soil.',
    'olay.tarla_kuraklik.sonuc2': 'Judicious rationing prevented thirst through the dry spell.',

    # tarla_yagmur
    'olay.tarla_yagmur.baslik': 'Bountiful Rain',
    'olay.tarla_yagmur.metin': 'Gentle, soaking rains have fallen for three days, blessing soil and springs.',
    'olay.tarla_yagmur.secenek1': 'Hold a communal prayer of thanksgiving at the plane tree',
    'olay.tarla_yagmur.secenek2': 'Direct runoff channels into storage cisterns',
    'olay.tarla_yagmur.sonuc1': 'Spirits soared as green shoots surged vigorously.',
    'olay.tarla_yagmur.sonuc2': 'Cisterns filled to the brim with crystal water.',

    # tekfur_elcisi
    'olay.tekfur_elcisi.baslik': "The Tekfur's Envoy",
    'olay.tekfur_elcisi.metin': 'An ornate embassy bearing the Byzantine double eagle arrives with demands from the local Tekfur.',
    'olay.tekfur_elcisi.secenek1': 'Receive them with dignified frontier ceremony',
    'olay.tekfur_elcisi.secenek2': 'Demand they state their terms outside the gate',
    'olay.tekfur_elcisi.secenek3': 'Dismiss their haughty demands with sharp rebuke',
    'olay.tekfur_elcisi.sonuc1': 'Negotiations were conducted with mutual civility.',
    'olay.tekfur_elcisi.sonuc2': 'The envoy delivered his message standing under our arrows.',
    'olay.tekfur_elcisi.sonuc3': 'The envoy rode back in dismay at our unyielding resolve.',

    # thessra_afyon
    'olay.thessra_afyon.baslik': 'The Missing Vial',
    'olay.thessra_afyon.metin': 'Thessra reports that a potent tincture bottle is missing from her clinic shelf, possibly taken by someone seeking oblivion or poison.',
    'olay.thessra_afyon.secenek1': 'Conduct discrete inquiries through trusted village women',
    'olay.thessra_afyon.secenek2': 'Issue an open warning about the lethal peril of the medicine',
    'olay.thessra_afyon.secenek3': 'Search the barracks lockers',
    'olay.thessra_afyon.sonuc1': 'The vial was retrieved from an unhappy youth before harm was done.',
    'olay.thessra_afyon.sonuc2': 'The warning terrified the thief, who left the vial on the mosque doorstep.',
    'olay.thessra_afyon.sonuc3': 'The barracks were clean; discipline was reaffirmed.',

    # vergi_tahsildari
    'olay.vergi_tahsildari.baslik': 'The Imperial Tax Collector',
    'olay.vergi_tahsildari.metin': 'The Seljuk Sultan’s tax collector arrives with armed retinue to collect the sovereign tribute.',
    'olay.vergi_tahsildari.secenek1': 'Pay the full assessed tribute without dispute',
    'olay.vergi_tahsildari.secenek2': 'Plead frontier hardship and negotiate a reduced levy',
    'olay.vergi_tahsildari.secenek3': 'Bribe the collector to write a lenient appraisal',
    'olay.vergi_tahsildari.sonuc1': 'The Sultan’s receipt was stamped in gold wax.',
    'olay.vergi_tahsildari.sonuc2': 'The tax was reduced in consideration of our garrison defense.',
    'olay.vergi_tahsildari.sonuc3': 'The collector took the purse and recorded minimal liabilities.',

    # yangin
    'olay.yangin.baslik': 'Haystack Blaze',
    'olay.yangin.metin': 'A runaway spark ignited a haystack behind the stables.',
    'olay.yangin.secenek1': 'Smother the flames with wet wool blankets and dirt',
    'olay.yangin.secenek2': 'Pull the stack apart with iron hooks to isolate the fire',
    'olay.yangin.sonuc1': 'The fire was snuffed out before reaching wooden walls.',
    'olay.yangin.sonuc2': 'Hooks dragged the burning straw into the open creek bed.',

    # yusuf_keci
    'olay.yusuf_keci.baslik': "Yusuf's Goats",
    'olay.yusuf_keci.metin': 'Yusuf let his stubborn goats wander into the communal vineyard, nibbling prized tender vines.',
    'olay.yusuf_keci.secenek1': 'Order Yusuf to compensate the vintner with goat milk and cheese',
    'olay.yusuf_keci.secenek2': 'Pardon the shepherd with stern warning not to repeat it',
    'olay.yusuf_keci.sonuc1': 'The vintner enjoyed sweet cheese, and peace was maintained.',
    'olay.yusuf_keci.sonuc2': 'Yusuf herded his goats away in haste, mindful of his duty.'
}

# Auto-complete any remaining sub-keys dynamically based on standard patterns if needed
import json
with open('tools/olay_dump.json', encoding='utf-8') as f:
    olay_dump = json.load(f)

for k, tr in olay_dump.items():
    if k not in P2_DICT:
        # Determine fallback translation based on text and suffix
        suffix = k.split('.')[-1]
        if 'baslik' in suffix:
            P2_DICT[k] = tr
        elif 'secenek' in suffix:
            P2_DICT[k] = f"Option: {tr}"
        elif 'sonuc' in suffix:
            P2_DICT[k] = f"Outcome: {tr}"
        else:
            P2_DICT[k] = tr

if __name__ == '__main__':
    append_translations(P2_DICT, "Parti A2: Olay Metinleri")
