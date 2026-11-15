class_name YasRolleri
extends RefCounted
const AGIR := ["tarla", "bostan", "hizarhane", "odunluk", "tas_ocagi", "kirec_kuyusu", "demir_madeni", "demir_ocagi", "atolye", "demirhane", "avci", "sur", "hendek", "muhafiz_kislasi", "nobetci_kulesi", "ahir", "agil", "su_arki", "civi_ocagi", "tamir_sundurmasi"]
const COCUK_HAFIF := ["koy_meydani", "han", "bez_evi"]
const DANISMAN_BONUSU := 0.15 # Bina başına bir kez; danışman kendi üretimini yapmaz.
static func kaynak(id: StringName) -> StringName:
	if id in [&"chr_003", &"chr_008", &"chr_013"]: return &"yasli"
	if id == &"chr_006": return &"cocuk" # Şecere: kaçırılmış dağ köylüsü çocuğu.
	return &"yetiskin" # Genç etiketi tek başına çocuk değildir.
static func oku(v: Variant, id: StringName) -> StringName:
	return StringName(v) if (v is String or v is StringName) and String(v) in ["cocuk", "genc", "yetiskin", "yasli"] else kaynak(id)
static func danisman(k: Koylu, tur: String) -> bool:
	if k.yas_grubu != &"yasli": return false
	return tur == "degirmen" or (tur in AGIR and CirakEgitimi.usta(k) and MeslekUyumu.carpan(k, tur) > 1.0)
static func atanabilir(k: Koylu, tur: String) -> bool:
	if DivanHukmu.zindanda(k): return false
	if k.yas_grubu == &"cocuk": return false if k.bayrak_var("kap18_yetim") else tur in COCUK_HAFIF
	if k.yas_grubu == &"yasli": return tur not in AGIR or danisman(k, tur)
	return true
static func fiziksel(k: Koylu, tur: String) -> bool:
	return atanabilir(k, tur) and not danisman(k, tur)
static func danismanlar(y: KoyYonetimi, b: KoyBinasi) -> Array[Koylu]:
	var sonuc: Array[Koylu] = []
	for k in y.calisanlar(b.id):
		if danisman(k, b.tur) and CirakEgitimi.saglam(k) and not IsMemnuniyeti.isyanci(k, y): sonuc.append(k)
	return sonuc
static func carpan(y: KoyYonetimi, b: KoyBinasi) -> float:
	return 1.0 + DANISMAN_BONUSU if b.tur == "degirmen" and not danismanlar(y, b).is_empty() else 1.0
static func metin(k: Koylu, y: KoyYonetimi) -> String:
	var tur := IsMemnuniyeti.gorev(k, y)
	var ad := {&"cocuk": "Çocuk", &"genc": "Genç", &"yetiskin": "Yetişkin", &"yasli": "Yaşlı"}
	return "%s%s" % [ad[k.yas_grubu], " · danışman, fiziksel üretim yok" if danisman(k, tur) else (" · yaş grubu bu işe uygun değil" if not tur.is_empty() and not atanabilir(k, tur) else "")]
