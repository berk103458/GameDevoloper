## UZM-05 denge varsayımı: fiilî uyumsuz üretimde %8, nöbette %10.
class_name IsKazalari
extends RefCounted
const YARALANMA_RISKI := 0.08
const UYUKLAMA_RISKI := 0.10
const YARALI_GECE := 3
const SAGLIK_KAYBI := 20
const ASAYIS_KAYBI := 5

static func oku(v: Variant) -> Dictionary:
	if not v is Dictionary or v.get("tur") not in ["yaralanma", "uyuklama"]: return {}
	var n: Variant = v.get("kalan")
	if (not n is int and not n is float) or not is_finite(float(n)) or float(n) != floor(float(n)): return {}
	if int(n) < 1 or int(n) > (YARALI_GECE if v["tur"] == "yaralanma" else 1) or not v.get("bayrak_eklendi") is bool: return {}
	return {"tur": v["tur"], "kalan": int(n), "bayrak_eklendi": v["bayrak_eklendi"]}

static func nobet(k: Koylu, y: KoyYonetimi) -> bool:
	if k.is_yeri == KoyYonetimi.MUHAFIZ: return true
	var b := y.bina(k.is_yeri)
	return b != null and b.hazir() and b.tur == "muhafiz_kislasi"

static func risk(k: Koylu, y: KoyYonetimi) -> float:
	if not k.is_kazasi.is_empty() or not CirakEgitimi.saglam(k): return 0.0
	if not YasRolleri.fiziksel(k, IsMemnuniyeti.gorev(k, y)): return 0.0
	if nobet(k, y): return minf(1.0, UYUKLAMA_RISKI * NobetYorgunlugu.carpan(k, y)) if MeslekUyumu.carpan(k, "muhafiz_kislasi") < 1.0 else 0.0
	var b := y.bina(k.is_yeri)
	if b == null or not b.hazir(): return 0.0
	return minf(1.0, YARALANMA_RISKI * NobetYorgunlugu.carpan(k, y)) if MeslekUyumu.carpan(k, b.tur) < 1.0 else 0.0

static func uyuyor(k: Koylu) -> bool:
	return k.is_kazasi.get("tur") == "uyuklama" and int(k.is_kazasi.get("kalan", 0)) > 0

static func gece(y: KoyYonetimi, calismalar: Dictionary, olaylar: Array[Dictionary]) -> void:
	for k in y.koylular:
		# Önceki kazanın süresi fiilî geceyle azalır; aynı gece tekrar kaza olmaz.
		if not k.is_kazasi.is_empty():
			k.is_kazasi["kalan"] -= 1
			if k.is_kazasi["kalan"] <= 0:
				if k.is_kazasi["tur"] == "yaralanma" and k.is_kazasi["bayrak_eklendi"]: k.bayraklar.erase("agir_yarali")
				k.is_kazasi.clear()
				olaylar.append({"anahtar": "Köylü %d iş kazasının etkisini atlattı.", "deger": [k.id]})
			continue
		var r := risk(k, y)
		var gece_nobeti := nobet(k, y)
		if r == 0.0 or (not gece_nobeti and not calismalar.has(k.id)): continue
		if y._rng.randf() >= r: continue
		if gece_nobeti:
			k.is_kazasi = {"tur": "uyuklama", "kalan": 1, "bayrak_eklendi": false}
			k.moral = maxi(0, k.moral - 3)
			y.asayis_riski = mini(100, y.asayis_riski + ASAYIS_KAYBI)
			olaylar.append({"anahtar": "Uyumsuz nöbette köylü %d uyuyakaldı; bu gece muhafız gücüne katılmıyor.", "deger": [k.id]})
		else:
			var eklenen := not k.bayrak_var("agir_yarali")
			k.bayrak_ekle("agir_yarali")
			k.saglik = maxi(0, k.saglik - SAGLIK_KAYBI)
			k.is_kazasi = {"tur": "yaralanma", "kalan": YARALI_GECE, "bayrak_eklendi": eklenen}
			ZanaatKazalari.yaralanma(y, k, olaylar)
			olaylar.append({"anahtar": "Uyumsuz işte köylü %d yaralandı: −20 sağlık, üç gece yaralı verimi.", "deger": [k.id]})

static func metin(k: Koylu) -> String:
	if k.is_kazasi.is_empty(): return "İş kazası etkisi yok"
	return ("Nöbette uyukladı" if uyuyor(k) else "İş kazasında yaralandı") + " · kalan %d gece" % int(k.is_kazasi["kalan"])
