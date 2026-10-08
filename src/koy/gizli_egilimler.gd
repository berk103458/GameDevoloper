class_name GizliEgilimler
extends RefCounted
const HAYDUTLAR := [&"chr_001", &"chr_004", &"chr_005", &"chr_009"]
const HIRSIZLIK_RISKI := 0.20
const IHTIYAC_RISKI := 0.35
const ERZAK := 3 # Denge varsayımı: kişi/gece en çok 3, mevcut stokla sınırlı.
static func kaynak(k: Koylu) -> Dictionary:
	var tur := "yok"
	if k.adli_id in HAYDUTLAR: tur = "haydut"
	elif k.adli_id == &"chr_011": tur = "firsatci"
	elif String(k.adli_id).begins_with("chr_") and int(String(k.adli_id).trim_prefix("chr_")) in range(1, 31):
		pass # Güncel CHR025/028/030 aile hikâyesi eski hirsiz bayrağıyla ezilmez.
	elif "haydut" in k.bayraklar + k.gizli_bayraklar: tur = "haydut"
	elif "hirsiz" in k.bayraklar + k.gizli_bayraklar or "hirsizliga_meyilli" in k.pasif_ozellikler.get("zayif", []): tur = "firsatci"
	return {"tur": tur, "calinan": 0, "son_gece": 0, "yakalanma": false}
static func oku(v: Variant, k: Koylu) -> Dictionary:
	if not v is Dictionary or v.get("tur") not in ["yok", "haydut", "firsatci"] or not v.get("yakalanma") is bool: return kaynak(k)
	for alan in ["calinan", "son_gece"]:
		var n: Variant = v.get(alan)
		if (not n is int and not n is float) or not is_finite(float(n)) or float(n) != floor(float(n)) or float(n) < 0 or float(n) > 1000000000: return kaynak(k)
	return {"tur": v["tur"], "calinan": int(v["calinan"]), "son_gece": int(v["son_gece"]), "yakalanma": v["yakalanma"]}
static func risk(k: Koylu) -> float:
	if DivanHukmu.zindanda(k): return 0.0
	if k.saglik <= 0 or "hasta" in k.bayraklar + k.gizli_bayraklar or "agir_yarali" in k.bayraklar + k.gizli_bayraklar: return 0.0
	var tur := String(k.gizli_egilim.get("tur", "yok"))
	if tur == "haydut": return HIRSIZLIK_RISKI
	if tur == "firsatci" and (k.ac or k.sadakat < 40): return IHTIYAC_RISKI
	return 0.0
static func gece(y: KoyYonetimi, calismalar: Dictionary, olaylar: Array[Dictionary]) -> void:
	for k in y.koylular:
		var r := risk(k)
		if r == 0.0 or y.kaynaklar.miktar("gida") <= 0: continue
		if y._rng.randf() >= r: continue
		var yakalama := minf(0.75, 0.10 + 0.10 * y.etkin_muhafiz_sayisi())
		if calismalar.has(k.id): yakalama *= 0.5 # Gündüz çalışması örtü sağlar; üretimi kesilmez.
		k.gizli_egilim["son_gece"] = y.gun
		if y._rng.randf() < yakalama:
			k.gizli_egilim["yakalanma"] = true
			k.bayrak_ac("hirsiz")
			CasusGeceTakibi.kaydet(y, k, "ambar", -1, "hirsizlik", "gida", 0, true)
			olaylar.append({"anahtar": "Köylü %s gece erzak çalarken yakalandı; ambar korundu.", "deger": [k.ad]})
		else:
			var kayip := y.kaynaklar.azalt("gida", ERZAK)
			k.gizli_egilim["calinan"] += kayip
			CasusGeceTakibi.kaydet(y, k, "ambar", -1, "hirsizlik", "gida", kayip, false)
			olaylar.append({"anahtar": "Gece ambardan %d erzak eksildi; kimin aldığı görülmedi.", "deger": [kayip]})
static func oyuncu_metin(k: Koylu) -> String:
	return "Hırsızlık açığa çıktı" if k.bayrak_var("hirsiz") else "Gizli eğilimler bilinmiyor"
static func debug_metin(k: Koylu) -> String:
	return "DEBUG gizli eğilim: %s · çalınan %d · son girişim gece %d · %s" % [k.gizli_egilim.get("tur", "yok"), k.gizli_egilim.get("calinan", 0), k.gizli_egilim.get("son_gece", 0), oyuncu_metin(k)]
