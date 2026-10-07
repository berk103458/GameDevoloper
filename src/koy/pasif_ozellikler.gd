## UZM-02: kalıcı güçlü/zayıf yön çifti; Flag/Clue adlarını değiştirmez.
class_name PasifOzellikler
extends RefCounted
const GUCLU := {
	"tetikte": "Tetikte", "agir_yuk_ustasi": "Ağır yük ustası", "zanaat_ustasi": "Zanaat ustası",
	"lider": "Lider", "cesur": "Cesur", "sessiz": "Sessiz", "okuryazar": "Okuryazar",
	"sifaci": "Şifacı", "ikna_edici": "İkna edici", "dayanikli": "Dayanıklı",
	"bitki_ustasi": "Bitki ustası", "tohum_ustasi": "Tohum ustası", "hayvan_dostu": "Hayvan dostu",
	"su_ustasi": "Su ustası", "gece_nobetcisi": "Gece nöbetçisi", "ritimci": "Ritimci",
	"el_becerisi": "El becerisi", "paylasimci": "Paylaşımcı", "olcu_ustasi": "Ölçü ustası",
}
const ZAYIF := {
	"kundak_egilimi": "Kundak eğilimi", "saf": "Saf", "gecmis_yuku": "Geçmişin yükü",
	"gaddar": "Gaddar", "ofkeli": "Öfkeli", "kibirli": "Kibirli", "santajci": "Şantajcı",
	"hirsizliga_meyilli": "Hırsızlığa meyilli", "korkak": "Korkak", "aile_kaygisi": "Aile kaygısı",
	"inatci": "İnatçı", "yalan_egilimi": "Yalan eğilimi", "utanc": "Utanç", "kumar_egilimi": "Kumar eğilimi",
	"icki_egilimi": "İçki eğilimi", "borc_yuku": "Borç yükü", "yorgun": "Yorgun",
}
# Açık tasarım eşlemesi: CHR_XXX.md Gerçek_Kimlik, Secere_Matrisi,
# Yüz_ve_Postür ve Köy_içi_Davranış. Kaynakta bulunmayan Trait alanı icat edilmez.
const CHR := {
	"chr_001": ["tetikte", "kundak_egilimi"], "chr_002": ["dayanikli", "saf"],
	"chr_003": ["zanaat_ustasi", "gecmis_yuku"], "chr_004": ["lider", "gaddar"],
	"chr_005": ["cesur", "ofkeli"], "chr_006": ["sessiz", "kundak_egilimi"],
	"chr_007": ["okuryazar", "kibirli"], "chr_008": ["sifaci", "gecmis_yuku"],
	"chr_009": ["sessiz", "yalan_egilimi"], "chr_010": ["ikna_edici", "santajci"],
	"chr_011": ["agir_yuk_ustasi", "hirsizliga_meyilli"], "chr_012": ["bitki_ustasi", "aile_kaygisi"],
	"chr_013": ["tohum_ustasi", "inatci"], "chr_014": ["hayvan_dostu", "yalan_egilimi"],
	"chr_015": ["su_ustasi", "ofkeli"], "chr_016": ["bitki_ustasi", "borc_yuku"],
	"chr_017": ["hayvan_dostu", "aile_kaygisi"], "chr_018": ["bitki_ustasi", "aile_kaygisi"],
	"chr_019": ["su_ustasi", "yalan_egilimi"], "chr_020": ["dayanikli", "kumar_egilimi"],
	"chr_021": ["gece_nobetcisi", "aile_kaygisi"], "chr_022": ["ritimci", "aile_kaygisi"],
	"chr_023": ["tetikte", "icki_egilimi"], "chr_024": ["el_becerisi", "utanc"],
	"chr_025": ["paylasimci", "aile_kaygisi"], "chr_026": ["el_becerisi", "borc_yuku"],
	"chr_027": ["el_becerisi", "utanc"], "chr_028": ["paylasimci", "aile_kaygisi"],
	"chr_029": ["zanaat_ustasi", "utanc"], "chr_030": ["olcu_ustasi", "aile_kaygisi"],
}

static func cift(id: StringName, sinif: StringName, kisi_id: int = 0) -> Dictionary:
	var kimlik := String(id).to_lower()
	if CHR.has(kimlik): return {"guclu": [CHR[kimlik][0]], "zayif": [CHR[kimlik][1]]}
	# Eski/genel köylülerde aynı kimlik aynı çifti verir; oyun RNG'si tüketilmez.
	var iyi: Array = {&"asker": ["gece_nobetcisi", "cesur", "tetikte"], &"esnaf": ["el_becerisi", "ikna_edici", "olcu_ustasi"]}.get(sinif, ["dayanikli", "agir_yuk_ustasi", "bitki_ustasi"])
	var kotu := ["korkak", "yorgun", "inatci"]
	var indeks := posmod(kisi_id, iyi.size())
	return {"guclu": [iyi[indeks]], "zayif": [kotu[posmod(kisi_id / iyi.size(), kotu.size())]]}

static func oku(v: Variant, varsayilan: Dictionary) -> Dictionary:
	if not v is Dictionary: return varsayilan.duplicate(true)
	var g: Variant = v.get("guclu")
	var z: Variant = v.get("zayif")
	if not g is Array or not z is Array or g.size() != 1 or z.size() != 1 or not g[0] is String or not z[0] is String or not GUCLU.has(g[0]) or not ZAYIF.has(z[0]): return varsayilan.duplicate(true)
	return {"guclu": g.duplicate(), "zayif": z.duplicate()}

static func metin(v: Dictionary, guclu: bool) -> String:
	var anahtar := "guclu" if guclu else "zayif"
	var sozluk := GUCLU if guclu else ZAYIF
	var adlar: Array[String] = []
	for id in v.get(anahtar, []): adlar.append(sozluk.get(id, "Belirsiz"))
	return ", ".join(adlar)
