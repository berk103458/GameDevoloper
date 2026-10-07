## UZM-12, mevcut alet/kaza zarlarından türetilir; ikinci bir risk zarı yok.
class_name ZanaatKazalari
extends RefCounted
const OCAKLAR := ["atolye", "demirhane", "civi_ocagi"]
static func oku(v: Variant) -> Dictionary:
	if not v is Dictionary or v.get("tur") not in ["alet", "yanik"] or not v.get("tedavi") is bool: return {}
	for alan in ["kalan", "son_gece"]:
		var n: Variant = v.get(alan)
		if (not n is int and not n is float) or not is_finite(float(n)) or floor(float(n)) != float(n): return {}
	if v.kalan < 0 or v.kalan > 1 or v.son_gece < 0 or v.son_gece > 1000000000: return {}
	if v.tur == "alet" and v.tedavi: return {}
	return {"tur": v.tur, "kalan": int(v.kalan), "son_gece": int(v.son_gece), "tedavi": v.tedavi}
static func acemi(k: Koylu) -> bool:
	return k.stat < 6 and not k.usta_mi() and not CirakEgitimi.usta(k)
static func durur(k: Koylu) -> bool:
	return int(k.zanaat_kazasi.get("kalan", 0)) > 0
static func alet_kirildi(y: KoyYonetimi, k: Koylu) -> void:
	if not acemi(k) or not k.zanaat_kazasi.is_empty(): return
	k.zanaat_kazasi = {"tur": "alet", "kalan": 1, "son_gece": y.gun, "tedavi": false}
static func yaralanma(y: KoyYonetimi, k: Koylu, olaylar: Array[Dictionary]) -> void:
	var b := y.bina(k.is_yeri)
	if b == null or b.tur not in OCAKLAR or not acemi(k): return
	k.zanaat_kazasi = {"tur": "yanik", "kalan": 1, "son_gece": y.gun, "tedavi": true}
	olaylar.append({"anahtar": "Köylü %s ocakta yandı; bir gece üretim duracak, Şifahane tedavisi gerekiyor.", "deger": [k.ad]})
static func gece(y: KoyYonetimi, olaylar: Array[Dictionary]) -> void:
	for k in y.koylular:
		if k.zanaat_kazasi.is_empty() or int(k.zanaat_kazasi.son_gece) == y.gun: continue
		k.zanaat_kazasi.kalan = maxi(0, int(k.zanaat_kazasi.kalan) - 1)
		if not k.zanaat_kazasi.tedavi: k.zanaat_kazasi.clear()
	var kapasite := Sifahane.tedavi_kapasitesi(y)
	for k in y.koylular:
		if kapasite <= 0: break
		if k.zanaat_kazasi.is_empty() or not k.zanaat_kazasi.tedavi or int(k.zanaat_kazasi.son_gece) == y.gun or k.saglik <= 0: continue
		if not y.kaynaklar.harca({"gida": 2}): break
		k.saglik = mini(100, k.saglik + IsKazalari.SAGLIK_KAYBI)
		# Yalnız bu kazanın sahip olduğu bayrak temizlenir.
		if k.is_kazasi.get("tur") == "yaralanma" and k.is_kazasi.get("bayrak_eklendi", false):
			k.bayraklar.erase("agir_yarali")
			k.is_kazasi.clear()
		k.zanaat_kazasi.clear()
		kapasite -= 1
		olaylar.append({"anahtar": "Şifahane köylü %s ocak yanığını tedavi etti; 2 erzak kullanıldı.", "deger": [k.ad]})
static func metin(k: Koylu) -> String:
	if k.zanaat_kazasi.is_empty(): return "Zanaat duruşu yok"
	return "%s · üretim duruşu %d gece%s" % ["Ocak yanığı" if k.zanaat_kazasi.tur == "yanik" else "Kırık alet", k.zanaat_kazasi.kalan, " · Şifahane tedavisi bekliyor" if k.zanaat_kazasi.tedavi else ""]
