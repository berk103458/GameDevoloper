## UZM-11: deneyim yalnız gerçekleşmiş, sağlıklı ve uyumlu çalışma gecelerinden.
class_name KoyluGelisimYoneticisi
extends RefCounted
const ESİK := 5
const KADEMELER := ["Çırak", "Kalfa", "Usta"]
static func temel(k: Koylu) -> int:
	if k.stat >= 7: return 2
	for f in k.bayraklar:
		if f.begins_with("usta_"): return 2
	if String(k.adli_id).begins_with("chr_"):
		for p in k.pasif_ozellikler.get("guclu", []):
			if p in CirakEgitimi.KAYNAK_USTALAR: return 2
	return 1 if k.stat >= 6 else 0
static func oku(v: Variant) -> Dictionary:
	var sonuc := {}
	if not v is Dictionary: return sonuc
	for meslek in v:
		if not meslek is String or not ZanaatTuru.Tur.has(meslek): continue
		var d: Variant = v[meslek]
		if not d is Dictionary or not d.get("bonus") is bool: continue
		var gecerli := true
		for alan in ["xp", "kademe", "son_gece"]:
			var n: Variant = d.get(alan)
			if (not n is int and not n is float) or not is_finite(float(n)) or floor(float(n)) != float(n): gecerli = false
		if not gecerli: continue
		if d.xp < 0 or d.xp >= ESİK or d.kademe < 0 or d.kademe > 2 or d.son_gece < -1 or d.son_gece > 1000000000: continue
		sonuc[meslek] = {"xp": int(d.xp), "kademe": int(d.kademe), "son_gece": int(d.son_gece), "bonus": d.bonus}
	return sonuc
static func durum(k: Koylu) -> Dictionary:
	return k.gelisim.get(ZanaatTuru.anahtar(k.zanaat_turu), {"xp": 0, "kademe": temel(k), "son_gece": -1, "bonus": false})
static func usta(k: Koylu) -> bool:
	var d := durum(k)
	return d.bonus and int(d.kademe) == 2
static func carpan(k: Koylu, tur: String) -> float:
	var d := durum(k)
	if not d.bonus or tur.is_empty() or MeslekUyumu.carpan(k, tur) < 1.0: return 1.0
	return 1.0 + 0.10 * int(d.kademe)
static func gece(y: KoyYonetimi, calismalar: Dictionary, olaylar: Array[Dictionary]) -> void:
	for k in y.koylular:
		if not calismalar.has(k.id) or not CirakEgitimi.saglam(k) or k.zanaat_turu == ZanaatTuru.Tur.BELIRSIZ: continue
		var b := y.bina(int(calismalar[k.id]))
		if b == null or k.is_yeri != b.id or not YasRolleri.fiziksel(k, b.tur) or MeslekUyumu.carpan(k, b.tur) < 1.0: continue
		var d := durum(k).duplicate(true)
		if int(d.son_gece) == y.gun: continue
		if int(d.kademe) == 2 and d.bonus: continue
		d.son_gece = y.gun
		d.xp += 1
		if d.xp == ESİK:
			d.xp = 0
			d.kademe = mini(2, maxi(int(d.kademe) + 1, temel(k)))
			d.bonus = true
			olaylar.append({"anahtar": "Köylü %s beş çalışma gecesiyle %s ustalık kademesini kazandı.", "deger": [k.ad, KADEMELER[d.kademe]]})
		k.gelisim[ZanaatTuru.anahtar(k.zanaat_turu)] = d
static func metin(k: Koylu) -> String:
	var d := durum(k)
	return "%s · %s · çalışma XP %d/%d · kazanılmış üretim bonusu +%%%d" % [ZanaatTuru.ad(k.zanaat_turu), KADEMELER[d.kademe], d.xp, ESİK, int(d.kademe) * 10 if d.bonus else 0]
