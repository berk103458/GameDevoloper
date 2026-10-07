class_name KanDavasi
extends RefCounted
const KAVGA_RISKI := 0.20 # UZM-07 denge varsayımı; bina/gece tek zar.
const DURUS_METNI := "Kan davası üretimi durduruyor. Düşman kişileri farklı binalara atayın."
# CHR_001/004 aile intikamı, CHR_005 açık kan davası; CHR_007 sancak divanı.
# Kaynak fraksiyon/şecere alanları yeniden adlandırılmaz; bu köy ilişkisi adaptörüdür.
static func kaynak(id: StringName) -> Dictionary:
	if id in [&"chr_001", &"chr_004", &"chr_005"]:
		return {"grup": "karaboran_haramileri", "dusman_gruplar": ["sancak_divani"]}
	if id == &"chr_007": return {"grup": "sancak_divani", "dusman_gruplar": []}
	return {"grup": "", "dusman_gruplar": []}

static func oku(v: Variant, varsayilan: Dictionary) -> Dictionary:
	if not v is Dictionary or not v.get("grup") is String or not v.get("dusman_gruplar") is Array: return varsayilan.duplicate(true)
	if String(v["grup"]).length() > 128 or v["dusman_gruplar"].size() > 32: return varsayilan.duplicate(true)
	var dusmanlar: Array[String] = []
	for d in v["dusman_gruplar"]:
		if not d is String or String(d).strip_edges().is_empty() or String(d).length() > 128 or d == v["grup"]: return varsayilan.duplicate(true)
		if d not in dusmanlar: dusmanlar.append(d)
	if String(v["grup"]).is_empty() and not dusmanlar.is_empty(): return varsayilan.duplicate(true)
	return {"grup": String(v["grup"]), "dusman_gruplar": dusmanlar}

static func dusman(a: Koylu, b: Koylu) -> bool:
	if a.id == b.id: return false
	var ag := String(a.toplumsal_bag.get("grup", ""))
	var bg := String(b.toplumsal_bag.get("grup", ""))
	if ag.is_empty() or bg.is_empty() or ag == bg: return false
	return bg in a.toplumsal_bag.get("dusman_gruplar", []) or ag in b.toplumsal_bag.get("dusman_gruplar", [])

static func ciftler(y: KoyYonetimi, bina: int) -> Array[Dictionary]:
	var sonuc: Array[Dictionary] = []
	var isci := y.calisanlar(bina)
	for i in isci.size():
		for j in range(i + 1, isci.size()):
			if dusman(isci[i], isci[j]): sonuc.append({"ilk": isci[i], "ikinci": isci[j]})
	return sonuc

static func engel(y: KoyYonetimi, bina: int) -> bool:
	return not ciftler(y, bina).is_empty()

static func gece(y: KoyYonetimi, olaylar: Array[Dictionary]) -> void:
	for b in y.binalar:
		if not b.hazir(): continue
		var esler := ciftler(y, b.id)
		if esler.is_empty(): continue
		olaylar.append({"anahtar": "Bina %d: düşman gruplar aynı işyerinde; kan davası üretimi durdurdu.", "deger": [b.id]})
		if y._rng.randf() >= KAVGA_RISKI: continue
		var katilanlar := {}
		for c in esler:
			for k: Koylu in [c["ilk"], c["ikinci"]]:
				if katilanlar.has(k.id): continue
				katilanlar[k.id] = true
				k.saglik = maxi(0, k.saglik - 5)
				k.moral = maxi(0, k.moral - 4)
		y.asayis_riski = mini(100, y.asayis_riski + 5)
		olaylar.append({"anahtar": "Bina %d: kan davası kavgasında %d köylü yaralandı (−5 sağlık, −4 moral).", "deger": [b.id, katilanlar.size()]})

static func metin(k: Koylu, y: KoyYonetimi) -> String:
	var grup := String(k.toplumsal_bag.get("grup", ""))
	var ad := {"karaboran_haramileri": "Karaboran haramileri", "sancak_divani": "Sancak divanı"}
	return "%s%s" % [ad.get(grup, grup) if not grup.is_empty() else "Düşmanlık bağı tanımlı değil", " · işyerinde kan davası, üretim durmuş" if k.is_yeri > 0 and engel(y, k.is_yeri) else ""]
