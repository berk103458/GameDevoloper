"""karakterler/CHR_001–030 için Meshy istemleri.

Her istem karakter sayfasının BÖLÜM 3'ünden (Yüz_ve_Postür, Kıyafet_ve_Doku, Görsel_Hata) ve
BÖLÜM 2'deki taşınan yükten (Obje_2_Yük) yazıldı. Sayfa değişirse buradaki satır da elle güncellenir.
Kimlikler `karakterler/OKU.md` ile aynı sırada; oyun içi kimlik = `chr_NNN`.
"""

# Ortak gövde: kapıya gelen, yere basan tek kişi. Yoksul/varlıklı ayrımı karakter satırında.
TABAN = ("Full body single character standing in A-pose, arms slightly away from body, feet apart, facing forward. "
         "13th-century Anatolian frontier villager, realistic proportions. ")

# kimlik: (ad, cinsiyet "e"/"k", boy_m, istem)
CHR = {
    "chr_001": ("Hamza", "e", 1.78, "Hamza, a tense bandit scout disguised as a refugee soldier: sun-darkened face, old sword scar on the left temple, rigid shoulders. Torn camel-hair cloak, coarse wool trousers caked with dried mountain mud, burn holes on the right sleeve. Carries an oak log bundle wrapped in wet reeds on his back."),
    "chr_002": ("Meryem", "k", 1.58, "Meryem, a frightened young peasant girl: big scared eyes, swollen eyelids, hugging a rough hemp sack tightly to her chest like a baby. Faded cotton dress muddy to the knees, torn green headscarf, worn goat-hair sandals. Blistered purple-stained hands."),
    "chr_003": ("Haydar", "e", 1.72, "Haydar Usta, an old master surgeon disguised as a poor tinker: deeply lined forehead, sharp calm eyes, slightly crooked shoulders. Sooty patched buffalo-leather vest, ash-stained linen shirt, leather bracers on the wrists. A double charcoal basket and a leather bellows on his back."),
    "chr_004": ("İlyas", "e", 1.82, "Ilyas, a bandit chief disguised as a fur merchant: frowning brows, pointed beard, cold piercing eyes, upright commanding stance holding a horse whip. Broadcloth kaftan lined with sable fur, silver-buckled leather belt, fine leather riding boots. A bundle of sable and fox furs over one shoulder."),
    "chr_005": ("Kerim", "e", 1.76, "Kerim, a bandit assassin pretending to be a crippled shepherd: pockmarked dark face, squinting right eye, left arm in a dirty sling held forward. Greasy sheepskin vest, broadcloth trousers torn at the knees, dusty leg wraps. An old goat-hair saddlebag on the shoulder."),
    "chr_006": ("Seyit", "e", 1.68, "Seyit, a young bandit errand boy pretending to be a mute porter: dirty blond hair, sooty cheeks, head bowed, eyes averted. Torn linen shirt tied with rags, trousers with holes at the knees, bare muddy feet. A woven reed basket full of straw on his back."),
    "chr_007": ("Şemsettin", "e", 1.74, "Semsettin, an arrogant corrupt deputy judge: pale fleshy face, thin beard, haughty upright posture with hands hidden in wide kaftan sleeves. Green broadcloth robe, clean white turban, gold-embroidered sash, clean leather slippers. Not a refugee, well dressed."),
    "chr_008": ("Dudu Hatun", "k", 1.55, "Dudu Hatun, an old mountain healer and midwife: deeply wrinkled kind sad face, slightly hunched, leaning on a juniper walking stick. Thick wool cardigan, patched dark blue baggy trousers, dusty white muslin headscarf. A large cloth-covered herb basket on her back."),
    "chr_009": ("Abbas", "e", 1.73, "Abbas, a sly travelling peddler and poison courier: pockmarked dark skin, shifty eyes, cut right earlobe, fawning bent posture. Patched colourful broadcloth vest, striped baggy trousers, crooked yellow head wrap, worn shoes. A pair of henna saddlebags over the shoulder."),
    "chr_010": ("Gaffar", "e", 1.72, "Gaffar, a crafty market crier and blackmailer: round cunning face, small moustache, leaning forward to whisper. Shiny wool vest, leather sash with a silver chain, dusty boots, striped cap. A goat-hair saddlebag on his back."),
    "chr_011": ("İdris", "e", 1.76, "Idris, a threshing labourer fleeing debt: sunburnt wrinkled forehead, hollow cheeks, strong broad shoulders, glancing back nervously. Dusty sweat-stained coarse cotton shirt, felt trousers patched at the knees, cowhide sandals. A heavy double-stitched grain sack on his back."),
    "chr_012": ("Zeynep", "k", 1.62, "Zeynep, a vineyard woman protecting her hidden child: tanned face, sad protective eyes, standing straight gripping the ropes of a large grapevine basket on her back. Sun-faded cotton dress, patched black baggy trousers, worn white headscarf, swaddling cloth padding on one shoulder."),
    "chr_013": ("Osman Dayı", "e", 1.66, "Osman Dayi, an old farmer with a clearly visible head and face: long white beard, wrinkled wind-burnt face, small dusty wool turban, slightly bent back. Worn camel-hair vest over a linen shirt, patched linen trousers, leather sandals, a cloth bandage around the right shin. Empty hands, no bags, no jugs."),
    "chr_014": ("Bekir", "e", 1.77, "Bekir, a young shepherd: tanned face, thick eyebrows, alert eyes, strong shoulders, twirling a shepherd's crook. Greasy sheepskin cloak, coarse trousers with wool leg wraps, dusty felt shepherd's cap. A large bundle of wool on his back."),
    "chr_015": ("Emine Hatun", "k", 1.64, "Emine Hatun, a defiant gardener and irrigation master: hard sun-darkened face, determined angry eyes, muscular arms, a hoe at her waist. Mud-stained coarse cotton dress, trousers rolled up to the knees, dark green head wrap, thick sandals. A basket of vegetable seedlings on her back."),
    "chr_016": ("Halil", "e", 1.74, "Halil, a vineyard pruner: sunburnt neck, cracked lips, calloused fingers, low shoulders. Old grape-stained shirt, patched rough wool trousers, muddy sandals. A bundle of straw-wrapped vine cuttings on his back, a pruning knife at the belt."),
    "chr_017": ("Fadime", "k", 1.62, "Fadime, a widowed ewe shepherdess hiding her little daughter: wind-cracked cheeks, sleepless eyes, thick wrists, anxiously glancing at her bag. Old wool dress with a sash, muddy sandals, felt cape on the shoulders. A large felt saddlebag on one shoulder."),
    "chr_018": ("Rahime", "k", 1.6, "Rahime, a vegetable gardener: sun-spotted forehead, dirt under her nails, leaning forward from the waist, holding a hoe. Muddy printed cotton skirt, patched vest, cracked sandals, a dried gourd water bottle hanging from a rope at her waist."),
    "chr_019": ("İsmail", "e", 1.73, "Ismail, a well and ditch cleaner: slumped shoulders, thin beard, eyes on the ground, hiding a wooden measuring stick behind his back. Muddy baggy trousers wet to the knees, sweaty shirt, waterlogged sandals, a blunt pickaxe at the belt."),
    "chr_020": ("Satılmış", "e", 1.75, "Satilmis, a threshing hand ashamed of gambling: flour-dusted beard, averted eyes, broad tired shoulders, one hand in his pocket. Straw-covered shirt, trousers torn at the knees, dusty sandals, an empty wooden sieve rim under his arm."),
    "chr_021": ("Cemil", "e", 1.77, "Cemil, a deserted infantry soldier posing as a stonemason: sleepless eyes, sunken cheeks, soldierly shoulders but drooping back. Faded wool short jacket, trousers muddy at the knees, sandals with a broken strap, a small travel bundle tied under the shirt, a broken wooden tally token at the sash."),
    "chr_022": ("Bayram", "e", 1.74, "Bayram, a barracks drummer who sold his drum: thin face, sleepless eyes, one shoulder strangely empty with a faded drum-strap mark. Old green short jacket, patched trousers, dusty sandals, a small herb bundle tied to the belt."),
    "chr_023": ("Necip", "e", 1.76, "Necip, a hungover scout soldier: bloodshot eyes, cracked lips, head down, heavy steps, grape stains on the beard. Dusty scout jacket, patched trousers, oddly clean sandals, a notched wooden tally stick at the belt."),
    "chr_024": ("Fehmi", "e", 1.72, "Fehmi, an armoury apprentice: sooty forehead, ashamed eyes, shoulders turned inward, a fresh thin cut on the left forearm. Burn-stained shirt, patched trousers, short leather apron, a curved sword wrapped in cloth carried under one arm."),
    "chr_025": ("Nevzat", "e", 1.74, "Nevzat, a barracks water carrier: dry lips, slumped shoulders. Sweaty shirt with flour on the armpit seam, trousers wet at the knees, fountain-mud sandals, a wooden water yoke with two leather buckets over his shoulders."),
    "chr_026": ("Salih", "e", 1.72, "Salih, a saddler ashamed of pawning a saddle: averted eyes, low shoulders, leather-stained hands. Oily leather apron, patched trousers, market-dusty sandals, a leather bag with a stirrup strap hanging out."),
    "chr_027": ("Rasim", "e", 1.73, "Rasim, a village potter: clay-dusted eyebrows, tired eyes, one trouser leg wet with clay. Mud-stained shirt, sandals caked with clay, carrying a cracked clay water jug against his hip."),
    "chr_028": ("Hulusi", "e", 1.72, "Hulusi, a tired cloth seller with a clearly visible head and face: short dark beard, plain felt cap, tired eyes. Faded long outer robe closed with a cloth sash, slightly bulky chest, dusty leather sandals. Empty hands, nothing carried."),
    "chr_029": ("Basri", "e", 1.73, "Basri, a nail smith: sooty forehead, ashamed downcast eyes, hiding his left hand. Ember-stained shirt, short leather apron, coal-dusty sandals, a small hammer at the belt and a small nail pouch under the apron."),
    "chr_030": ("Latif", "e", 1.72, "Latif, a miller's journeyman: flour on his eyelashes, tired eyes, hiding his measuring hand. Flour-covered shirt, patched trousers, mill-dusty sandals, a small flour sack sewn inside the jacket lining, a wooden grain measure in one hand."),
}

# Hareket kitaplığı: oyun içi ad → Meshy animasyon kitaplığındaki `key` adayları (ilk bulunan alınır).
# Kimlikler sabit yazılmaz; betik `/v1/animations/library?search=` ile çözer ve durum.json'a yazar.
# bekle: kapıda dururken · konus: soruya cevap verirken · sevinc: kabulde şükran (eğilme)
# ofke: ret sonrası, kötü niyetli · panik: ret sonrası, masum (diz çöker) · gergin: sorgu sıkışınca
HAREKETLER = {
    "bekle": ["Idle", "Idle_02"],
    "konus": ["Talk_with_Hands_Open", "Talk_with_Right_Hand_Open", "Talk_Passionately"],
    "sevinc": ["Formal_Bow", "Gentlemans_Bow"],
    "ofke": ["Stand_Talking_Angry", "Angry_Stomp"],
    "panik": ["Kneel_on_One_Knee_and_Stand"],
    "gergin": ["Alert"],
}

# Sayfadaki fraksiyonu haramiler / ayaktakımı / divan olanlar (tools/icerik/karakter_sayfalari.py ile aynı ölçüt).
TEHLIKELI = {"chr_001", "chr_004", "chr_005", "chr_006", "chr_007", "chr_009", "chr_010"}


def hareket_listesi(kimlik):
    """Karakter başına üretilecek hareketler (kredi bütçesi: 4 hareket × 3 kredi).
    Rette tepki niyete göre: kötü niyetli öfkelenir, masum diz çöker."""
    return ["bekle", "konus", "sevinc", "ofke" if kimlik in TEHLIKELI else "panik"]
