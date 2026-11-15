## UZM-13: ağır fiziksel işte statü/okumuşluk kaynaklı grev; RNG tüketmez.
class_name MeslekGrevi
extends RefCounted
const FIZIKSEL := ["tarla", "bostan", "hizarhane", "odunluk", "tas_ocagi", "kirec_kuyusu", "demir_madeni", "demir_ocagi", "atolye", "demirhane", "avci", "sur", "hendek", "ahir", "agil", "su_arki", "civi_ocagi", "tamir_sundurmasi"]
static func aday(k: Koylu, tur: String) -> bool:
	var okumus := k.adli_id == &"chr_007" or k.zanaat_turu == ZanaatTuru.Tur.KATIP or "soylu" in k.bayraklar + k.gizli_bayraklar or "okumus" in k.bayraklar + k.gizli_bayraklar
	return okumus and tur in FIZIKSEL and YasRolleri.fiziksel(k, tur) and MeslekUyumu.carpan(k, tur) <= 1.0
static func soylenti_olasilik_artisi(y: KoyYonetimi, tur: String = "") -> float:
	if y == null or not y.has_meta(SoylentiKoprusu.META): return 0.0
	var ag: Variant = y.get_meta(SoylentiKoprusu.META)
	if ag == null or not ag.has_method("grev_olasilik_artisi"): return 0.0
	return float(ag.grev_olasilik_artisi(tur))
static func olasilik(k: Koylu, y: KoyYonetimi) -> float:
	if k.saglik <= 0 or "hasta" in k.bayraklar + k.gizli_bayraklar or "agir_yarali" in k.bayraklar + k.gizli_bayraklar: return 0.0
	var tur := IsMemnuniyeti.gorev(k, y)
	if aday(k, tur): return 1.0
	if not (tur in FIZIKSEL) or not YasRolleri.fiziksel(k, tur): return 0.0
	return clampf(soylenti_olasilik_artisi(y, tur), 0.0, 1.0)
static func _soylenti_tetiklendi(k: Koylu, y: KoyYonetimi, tur: String) -> bool:
	var p := soylenti_olasilik_artisi(y, tur)
	if p <= 0.0 or not (tur in FIZIKSEL) or not YasRolleri.fiziksel(k, tur): return false
	if p >= 1.0: return true
	return posmod(hash("soylenti_grev|%d|%d|%s" % [y.gun, k.id, tur]), 10000) < int(round(p * 10000.0))
static func aktif(k: Koylu, y: KoyYonetimi) -> bool:
	if k.saglik <= 0 or "hasta" in k.bayraklar + k.gizli_bayraklar or "agir_yarali" in k.bayraklar + k.gizli_bayraklar: return false
	var tur := IsMemnuniyeti.gorev(k, y)
	return aday(k, tur) or _soylenti_tetiklendi(k, y, tur)
static func oku(v: Variant) -> Dictionary:
	if not v is Dictionary: return {}
	for alan in ["son_gece", "gece"]:
		var n: Variant = v.get(alan)
		if (not n is int and not n is float) or not is_finite(float(n)) or floor(float(n)) != float(n) or float(n) < 0 or float(n) > 1000000000: return {}
	return {"son_gece": int(v.son_gece), "gece": int(v.gece)}
static func gece(y: KoyYonetimi, olaylar: Array[Dictionary]) -> void:
	if y.isyan_kalan >= 0: return # Köy genelindeki isyanı ikinci kez cezalandırma.
	var grevciler: Array[Koylu] = []
	for k in y.koylular:
		if aktif(k, y): grevciler.append(k)
	var etkilenen := {}
	for k in grevciler:
		if k.grev.get("son_gece", -1) == y.gun: continue
		k.grev = {"son_gece": y.gun, "gece": mini(1000000000, int(k.grev.get("gece", 0)) + 1)}
		k.moral = maxi(0, k.moral - 5)
		k.sadakat = maxi(0, k.sadakat - 2)
		y.asayis_riski = mini(100, y.asayis_riski + 3)
		for diger in y.calisanlar(k.is_yeri):
			if diger in grevciler or etkilenen.has(diger.id) or not CirakEgitimi.saglam(diger): continue
			diger.moral = maxi(0, diger.moral - 2)
			etkilenen[diger.id] = true
		olaylar.append({"anahtar": "Köylü %s ağır işi aşağılayıcı bulup greve başladı; aynı işyerindeki köylüleri kışkırttı.", "deger": [k.ad]})
static func metin(k: Koylu, y: KoyYonetimi) -> String:
	return "Grev: ağır fiziksel işi reddediyor; uygun göreve aktarın." if aktif(k, y) else "Meslek grevi yok"
