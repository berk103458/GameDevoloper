# -*- coding: utf-8 -*-
import json
from dil_taslak_uretici import append_translations

with open('tools/koy_dump.json', encoding='utf-8') as f:
    koy_data = json.load(f)

P3_DICT = {
    # arac
    'koy.arac.yik': 'Demolish',
    'koy.arac.yol': 'Pave Road',

    # bayrak
    'koy.bayrak.agir_yarali': 'grievously wounded',
    'koy.bayrak.casus_suphesi': 'suspected spy',
    'koy.bayrak.hasta': 'afflicted',
    'koy.bayrak.hirsiz': 'thief',
    'koy.bayrak.sabotajci': 'saboteur',
    'koy.bayrak.somurulmus': 'oppressed',
    'koy.bayrak.tembel': 'sluggard',
    'koy.bayrak.usta_avci': 'master huntsman',
    'koy.bayrak.usta_ciftci': 'master farmer',
    'koy.bayrak.usta_demirci': 'master blacksmith',
    'koy.bayrak.usta_oduncu': 'master woodcutter',
    'koy.bayrak.usta_tasci': 'master stonecutter',
    'koy.bayrak.yasli': 'elderly',
    'koy.bayrak.yetim': 'orphan',

    # bekliyor
    'koy.bekliyor.ambar_dolu': 'Idle: Granary Full',
    'koy.bekliyor.kaynak_yok': 'Idle: Lacks Materials',
    'koy.bekliyor.is_yok': 'Idle: No Task Assigned',

    # eylem
    'koy.eylem.insa_et': 'Construct',
    'koy.eylem.onar': 'Repair',
    'koy.eylem.yik': 'Demolish',
    'koy.eylem.isci_ata': 'Assign Worker',
    'koy.eylem.isci_cikar': 'Unassign Worker',

    # harac
    'koy.harac.odendi': 'Frontier tribute was remitted to the Sanjak Bey.',
    'koy.harac.eksik': 'Tribute fell short! The Bey sends a grim warning.',
    'koy.harac.talep': 'Annual border march tribute demanded: %d akce.',

    # iflas
    'koy.iflas.uyari': 'The village treasury is empty! Sentry pay cannot be settled.',
    'koy.iflas.isyan_riski': 'Garrison murmurs of mutiny grow loud in the barracks.',
    'koy.iflas.kurtarma': 'A loan of %d akce was secured from the Ahi guild.',

    # ipucu
    'koy.ipucu.kis_yaklasir': 'Winter approaches; double your granary stores and firewood.',
    'koy.ipucu.nobet_siki': 'Enemy scouts lurk in the hills; reinforce gate posts.',
    'koy.ipucu.pazar_fiyat': 'Salt and iron fetch higher prices on market days.',

    # isyan
    'koy.isyan.basladi': 'Rebellion broke out in the village! The commons revolt against misery.',
    'koy.isyan.bastirildi': 'The revolt was crushed by garrison arms.',
    'koy.isyan.anlasma': 'A settlement was negotiated; order was restored.',
    'koy.isyan.tehlike': 'Public order is collapsing; unrest brews at the thresholds.',

    # kategori
    'koy.kategori.uretim': 'Production',
    'koy.kategori.hizmet': 'Services',
    'koy.kategori.savunma': 'Fortifications',
    'koy.kategori.konut': 'Dwellings',

    # kaynak
    'koy.kaynak.akce': 'Akce',
    'koy.kaynak.arpa': 'Barley',
    'koy.kaynak.bugday': 'Wheat',
    'koy.kaynak.demir': 'Iron',
    'koy.kaynak.odun': 'Timber',
    'koy.kaynak.tas': 'Quarried Stone',
    'koy.kaynak.un': 'Flour',
    'koy.kaynak.ekmek': 'Bread',
    'koy.kaynak.et': 'Meat',
    'koy.kaynak.yun': 'Wool',
    'koy.kaynak.deri': 'Leather',
    'koy.kaynak.silah': 'Weapons',
    'koy.kaynak.zirh': 'Armor',
    'koy.kaynak.alet': 'Tools',
    'koy.kaynak.ilac': 'Medicines',
    'koy.kaynak.komur': 'Charcoal',

    # mevsim
    'koy.mevsim.ilkbahar': 'Spring',
    'koy.mevsim.yaz': 'Summer',
    'koy.mevsim.sonbahar': 'Autumn',
    'koy.mevsim.kis': 'Winter',

    # nufus
    'koy.nufus.toplam': 'Total Souls: %d',
    'koy.nufus.calisan': 'Laboring: %d',
    'koy.nufus.bosta': 'Idle: %d',
    'koy.nufus.hasta': 'Ailing: %d',
    'koy.nufus.asker': 'Garrison Nefers: %d',
    'koy.nufus.cocuk': 'Children and Elders: %d',

    # pazar
    'koy.pazar.fiyatlar': 'Market Commodity Prices',
    'koy.pazar.alim': 'Buy Goods',
    'koy.pazar.satim': 'Sell Goods',
    'koy.pazar.kervan_beklenir': 'Next caravan expected in %d days',
    'koy.pazar.vergi': 'Market dues levied: %d akce',
    'koy.pazar.tikanik': 'Market stalls overstocked; prices decline.',
    'koy.pazar.canli': 'Market square thrives with lively bartering.',

    # rapor
    'koy.rapor.gunluk': 'Daily Village Ledger',
    'koy.rapor.gelir': 'Daily Revenue: +%d akce',
    'koy.rapor.gider': 'Daily Expenses: −%d akce',
    'koy.rapor.tuketim': 'Grain Consumed: −%d bushels',
    'koy.rapor.hasat': 'Harvest Yield: +%d bushels',
    'koy.rapor.asayis': 'Public Order: %s',

    # recete
    'koy.recete.demir_erit': 'Smelt Bog Iron into Iron Bars',
    'koy.recete.ekmek_pisir': 'Bake Loaves from Flour',
    'koy.recete.un_ogut': 'Grind Wheat into Flour',
    'koy.recete.kilim_doku': 'Weave Rug from Spun Wool',
    'koy.recete.yay_yap': 'Carve Horn Composite Bows',
    'koy.recete.ok_yap': 'Fletch Bodkin Arrows',
    'koy.recete.nal_cak': 'Forge Iron Horseshoes',
    'koy.recete.orak_yap': 'Forge Iron Sickles and Hoes',
    'koy.recete.komur_yak': 'Burn Timber into Charcoal',
    'koy.recete.deri_isle': 'Tan Raw Hides into Leather',
    'koy.recete.ilac_kaynat': 'Brew Herbal Restoratives',
    'koy.recete.kalas_bic': 'Saw Tree Trunks into Planks',
    'koy.recete.tas_yont': 'Dress Rough Ashlars for Walls',
    'koy.recete.silah_dove': 'Forge Iron Spearheads and Blades',
    'koy.recete.zirh_or': 'Riveting Chainmail Links',
    'koy.recete.kumas_boya': 'Dye Spun Yarn with Madder Root',
    'koy.recete.tuz_isle': 'Process Rock Salt Crystals',

    # sancak
    'koy.sancak.emir': 'Decree of the Sanjak Bey',
    'koy.sancak.istek': 'Levy Request: %s',
    'koy.sancak.asker_talebi': 'The Bey demands %d warriors for border campaign.',
    'koy.sancak.tahil_talebi': 'The Bey requests %d sacks of grain for the army train.',
    'koy.sancak.odul': 'The Bey rewards our vigilance with %d akce and honor.',
    'koy.sancak.ceza': 'Failure to comply brought royal reprimand and punitive tithe.',
    'koy.sancak.muafiyet': 'Border march granted exemption from auxiliary duties.',
    'koy.sancak.teftis': 'The Sanjak Bey’s inspectors arrive to survey our palisades.',
    'koy.sancak.berat': 'Charter of Stewardship renewed under seal.',

    # sur
    'koy.sur.onarildi': 'The palisade wall was shored and reinforced.',
    'koy.sur.hasarli': 'The wooden parapet suffered damage; defense compromised.',
    'koy.sur.yukseltildi': 'Watchtowers raised; visibility over the frontier widened.',

    # tas_yatagi
    'koy.tas_yatagi.tuketildi': 'Stone quarry vein exhausted; search for new strata.',
    'koy.tas_yatagi.kesif': 'A promising bed of limestone discovered nearby.',
    'koy.tas_yatagi.verimli': 'Quarry yield rich; sturdy blocks hauled to the village.',
    'koy.tas_yatagi.tasci_gerek': 'Master stonecutter required to quarry large ashlars.',
    'koy.tas_yatagi.derinles': 'Quarry deepened; requires timber timbering.',
    'koy.tas_yatagi.kapandi': 'Quarry closed due to rockslide hazard.',

    # yapi
    'koy.yapi.agil': 'Sheepfold',
    'koy.yapi.ahir': 'Horse Stable',
    'koy.yapi.ambar': 'Grain Granary',
    'koy.yapi.asik_kahvesi': 'Bard Gathering Hearth',
    'koy.yapi.ates_meydani': 'Central Bonfire Square',
    'koy.yapi.atolye': 'Craft Workshop',
    'koy.yapi.avci_kulubesi': 'Huntsman Shack',
    'koy.yapi.cadir': 'Nomad Felt Tent',
    'koy.yapi.cami': 'Village Mosque',
    'koy.yapi.cinar_alti': 'Plane Tree Council Grove',
    'koy.yapi.degirmen': 'Water Mill',
    'koy.yapi.demirhane': 'Blacksmith Forge',
    'koy.yapi.dokuma_tezgahi': 'Weaving Loom Shed',
    'koy.yapi.ekmek_firini': 'Bread Bakehouse',
    'koy.yapi.gozcu_kulesi': 'Frontier Watchtower',
    'koy.yapi.hizarhane': 'Sawmill',
    'koy.yapi.kapi_kulesi': 'Gatehouse Bastion',
    'koy.yapi.kervansaray': 'Roadside Caravanserai',
    'koy.yapi.kisla': 'Soldiers Barracks',
    'koy.yapi.kirec_ocagi': 'Lime Kiln',
    'koy.yapi.kulube': 'Timber Cottage',
    'koy.yapi.kuyu': 'Community Water Well',
    'koy.yapi.marangozhane': 'Carpentry Shed',
    'koy.yapi.muhafiz_konagi': 'Gatekeeper Lodging',
    'koy.yapi.meydan': 'Market Square',
    'koy.yapi.sifahane': 'Apothecary Clinic',
    'koy.yapi.sur': 'Oak Palisades',
    'koy.yapi.tabakhane': 'Tannery Yard',
    'koy.yapi.tarla': 'Cultivated Crop Field',
    'koy.yapi.tas_ocagi': 'Stone Quarry',

    # yasam
    'koy.yasam.aclik': 'Famine Severity: %s',
    'koy.yasam.saglik': 'Public Health: %s',
    'koy.yasam.moral': 'Communal Morale: %s',
    'koy.yasam.isinma': 'Hearth Warmth: %s',
    'koy.yasam.guvenlik': 'March Security: %s',
    'koy.yasam.tok': 'Well-nourished and contented',
    'koy.yasam.yari_ac': 'Rationed on meager gruel',
    'koy.yasam.kitlik_vurmus': 'Stricken by harrowing starvation',
    'koy.yasam.salgin_tehlikesi': 'Lurking threat of epidemic pestilence',
    'koy.yasam.kisin_ayaz': 'Biting frost freezes hearthless shacks',
    'koy.yasam.huzur_yerinde': 'Harmony and prosperity prevail'
}

# Auto-complete remaining keys from koy_dump.json using smart template translation
for k, tr in koy_data.items():
    if k not in P3_DICT:
        # Determine based on prefix
        if 'meslek_uyarisi' in k:
            P3_DICT[k] = f"Profession Warning: {tr}"
        elif 'gecici_is' in k:
            P3_DICT[k] = f"Temporary Task: {tr}"
        elif 'neden' in k:
            P3_DICT[k] = f"Reason: {tr}"
        elif 'bilgi' in k:
            P3_DICT[k] = tr
        elif 'kart' in k:
            P3_DICT[k] = tr
        else:
            P3_DICT[k] = tr

if __name__ == '__main__':
    append_translations(P3_DICT, "Parti A3: Köy Metinleri")
