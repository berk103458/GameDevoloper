## Sürüm geçişleri yalnız derin kopyada uygulanır; dosya ve eski köy verisi korunur.
extends RefCounted

const GUNCEL_SURUM := 3

static func uygula(kayit: Dictionary, mevsim_gun: int) -> Dictionary:
	var kaynak_surumu: Variant = kayit.get("surum", 0)
	if (not kaynak_surumu is int and not kaynak_surumu is float) or not is_finite(float(kaynak_surumu)) or float(kaynak_surumu) != floor(float(kaynak_surumu)):
		return {}
	var surum := int(kaynak_surumu)
	# v1 eski dört bar kaydı köy yönetimi içermez: uydurma dönüşüm yapılmaz.
	if surum < 2 or surum > GUNCEL_SURUM or not kayit.get("koy_yonetimi") is Dictionary:
		return {}
	if not kayit.has("tohum") or not kayit.get("kadro", {}) is Dictionary:
		return {}
	var adimlar := {2: func(v: Dictionary) -> Dictionary: return _v2_v3(v, mevsim_gun)}
	var veri := preload("res://src/sistemler/kayit_gocu_soz.gd").uygula(kayit, GUNCEL_SURUM, adimlar)
	if veri.is_empty(): return {}
	for alan in ["muhafiz_akce", "muhafiz_tecrubesi", "mevsim"]:
		var deger: Variant = veri.get(alan)
		if (not deger is int and not deger is float) or float(deger) != floor(float(deger)) or float(deger) < 0:
			return {}
		veri[alan] = int(deger)
	if veri["mevsim"] > 3 or not veri.get("muhafiz_esyalari") is Array or not veri.get("yeni_binalar") is Array:
		return {}
	for alan in ["muhafiz_esyalari", "yeni_binalar"]:
		for oge in veri[alan]:
			if not oge is Dictionary:
				return {}
	if surum < GUNCEL_SURUM:
		veri["kayit_gocu_bildirimi"] = {"kaynak":surum, "hedef":GUNCEL_SURUM, "bekliyor":true}
	_usta_demirci_goc(veri)
	if not preload("res://src/sistemler/kayit_gocu_soz.gd").soz_denetle(veri):
		return {}
	return veri

## TEK-05: CHR kaydındaki yanlış `usta_demirci` doğru usta bayrağına döner. Adsız esnaf durur.
static func _usta_demirci_goc(veri: Dictionary) -> void:
	var koy: Variant = veri.get("koy_yonetimi", {})
	if not koy is Dictionary:
		return
	var kisiler: Variant = koy.get("koylular", [])
	if not kisiler is Array:
		return
	for kisi in kisiler:
		if not kisi is Dictionary:
			continue
		var adli := String(kisi.get("adli_id", "")).to_lower()
		if not ZanaatTuru.CHR.has(adli):
			continue
		var dogru := _usta_adi(int(ZanaatTuru.CHR[adli]))
		if dogru.is_empty() or dogru == "demirci":
			continue
		for alan in ["bayraklar", "gizli"]:
			var liste: Variant = kisi.get(alan, [])
			if not liste is Array or not liste.has("usta_demirci"):
				continue
			liste.erase("usta_demirci")
			var yeni := "usta_" + dogru
			if not liste.has(yeni):
				liste.append(yeni)


static func _usta_adi(tur: int) -> String:
	match tur:
		ZanaatTuru.Tur.CERRAH, ZanaatTuru.Tur.OTACI:
			return "cerrah"
		ZanaatTuru.Tur.DEMIRCI:
			return "demirci"
		ZanaatTuru.Tur.CIFTCI:
			return "ciftci"
		ZanaatTuru.Tur.COBAN:
			return "coban"
		_:
			return ""


static func _v2_v3(veri: Dictionary, mevsim_gun: int) -> Dictionary:
	veri["muhafiz_akce"] = veri.get("muhafiz_akce", 0)
	veri["muhafiz_esyalari"] = veri.get("muhafiz_esyalari", [])
	veri["muhafiz_tecrubesi"] = veri.get("muhafiz_tecrubesi", 0)
	veri["yeni_binalar"] = veri.get("yeni_binalar", [])
	veri["mevsim"] = Takvim.mevsim(int(veri["koy_yonetimi"].get("gun", 0)), maxi(1, mevsim_gun))
	veri["surum"] = 3
	return veri
