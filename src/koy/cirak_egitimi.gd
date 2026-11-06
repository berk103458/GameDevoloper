## UZM-04: beş gerçek ortak üretim gecesi; öğrenme gece başına bir kez.
class_name CirakEgitimi
extends RefCounted
const GEREKEN := 5
const KAYNAK_USTALAR := ["zanaat_ustasi", "tohum_ustasi", "bitki_ustasi", "su_ustasi"]

static func oku(v: Variant) -> Dictionary:
	if not v is Dictionary: return {}
	for alan in ["usta", "bina", "gece"]:
		var deger: Variant = v.get(alan)
		if (not deger is int and not deger is float) or not is_finite(float(deger)) or float(deger) != floor(float(deger)): return {}
	if int(v["usta"]) <= 0 or int(v["bina"]) <= 0 or int(v["gece"]) < 0 or int(v["gece"]) > GEREKEN or not v.get("tamamlandi") is bool: return {}
	if v["tamamlandi"] != (int(v["gece"]) == GEREKEN): return {}
	return {"usta": int(v["usta"]), "bina": int(v["bina"]), "gece": int(v["gece"]), "tamamlandi": v["tamamlandi"]}

static func usta(k: Koylu) -> bool:
	if k.usta_mi(): return true
	if String(k.adli_id).begins_with("chr_"):
		for yon in k.pasif_ozellikler.get("guclu", []):
			if yon in KAYNAK_USTALAR: return true
	return false

static func saglam(k: Koylu) -> bool:
	if KarantinaYoneticisi.aktif(k): return false
	return not DivanHukmu.zindanda(k) and not KisHastaligi.hasta(k) and not k.ac and k.saglik > 0 and "hasta" not in k.bayraklar + k.gizli_bayraklar and "agir_yarali" not in k.bayraklar + k.gizli_bayraklar

static func gece(y: KoyYonetimi, calismalar: Dictionary, olaylar: Array[Dictionary]) -> void:
	for k in y.koylular:
		if k.egitim.get("tamamlandi", false): continue
		if not k.egitim.is_empty():
			var onceki := y.koylu(int(k.egitim["usta"]))
			if k.is_yeri != int(k.egitim["bina"]) or onceki == null or onceki.is_yeri != k.is_yeri: k.egitim.clear()
		if k.stat >= 6 or usta(k) or not saglam(k) or not calismalar.has(k.id): continue
		var bina := y.bina(k.is_yeri)
		if bina == null or not YasRolleri.atanabilir(k, bina.tur): continue # ISG-73: tek yaş kaynağı.
		var ogretmen: Koylu
		for aday in y.calisanlar(bina.id):
			if aday == k or not calismalar.has(aday.id) or not saglam(aday) or not usta(aday) or MeslekUyumu.carpan(aday, bina.tur) < 1.0: continue
			if ogretmen == null or aday.id == int(k.egitim.get("usta", -1)): ogretmen = aday
			if aday.id == int(k.egitim.get("usta", -1)): break
		if ogretmen == null: continue
		if k.egitim.is_empty() or k.egitim["usta"] != ogretmen.id:
			k.egitim = {"usta": ogretmen.id, "bina": bina.id, "gece": 0, "tamamlandi": false}
		k.egitim["gece"] += 1
		if k.egitim["gece"] == GEREKEN:
			k.egitim["tamamlandi"] = true
			k.stat = maxi(k.stat, 6)
			k.zanaat_turu = ZanaatTuru.Tur.DEMIRCI if ogretmen.adli_id == &"chr_003" and bina.tur in ["demirhane", "atolye"] else ogretmen.zanaat_turu
			olaylar.append({"anahtar": "Köylü %d, usta %d yanında beş gece çalışarak yarı usta oldu.", "deger": [k.id, ogretmen.id]})

static func metin(k: Koylu) -> String:
	if k.egitim.is_empty(): return "Eğitim yok"
	if k.egitim.get("tamamlandi", false): return "Yarı usta · eğitim tamamlandı"
	return "Usta #%d · bina #%d · %d/5 ortak çalışma gecesi" % [k.egitim["usta"], k.egitim["bina"], k.egitim["gece"]]
