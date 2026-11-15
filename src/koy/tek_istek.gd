## SEV-04: borç/kuyruk değil, kadroda ömür boyu tek kayıt.
extends RefCounted

const VERI := "res://data/soz/istekler.json"

static func tanim(k: Koylu) -> Dictionary:
	var veri: Variant = JSON.parse_string(FileAccess.get_file_as_string(VERI))
	if not veri is Array: return {}
	for v: Dictionary in veri:
		if String(k.adli_id) in v.get("kisiler", []): return v
	return {}

static func kabul(o: Oturum, g: Gelen, kaldi: bool) -> void:
	if not kaldi or not g.adli: return
	var d: Dictionary = o.kadro.durumlar.get(g.id, {})
	# Alan bir kez konur; eski kayıtların geçmişi yüklemede kapalı işaretlenir.
	if d.has("tek_istek"): return
	for k in o.yonetim.koylular:
		if k.adli_id != g.id: continue
		var v := tanim(k)
		if v.is_empty() or k.yas_grubu == &"cocuk": return
		d["tek_istek"] = {"id": v.id, "durum": "hazir", "giris": o.gun, "konusma": 0}
		return

static func durum(o: Oturum, k: Koylu) -> Dictionary:
	var d: Dictionary = o.kadro.durumlar.get(k.adli_id, {})
	var s: Variant = d.get("tek_istek", {})
	return s if s is Dictionary else {}

static func kapat(o: Oturum, id: StringName) -> void:
	var d: Dictionary = o.kadro.durumlar.get(id, {})
	var s: Variant = d.get("tek_istek", {})
	if s is Dictionary and s.get("durum", "") in ["hazir", "acik"]: s["durum"] = "kapandi"

static func ilerlet(o: Oturum) -> void:
	for id in o.kadro.durumlar:
		var d: Dictionary = o.kadro.durumlar[id]
		var k: Koylu = null
		for kisi in o.yonetim.koylular:
			if kisi.adli_id == id: k = kisi; break
		if k == null or k.saglik <= 0 or k.yas_grubu == &"cocuk" or String(d.get("durum", "")) != "koyde":
			kapat(o, id)
			continue
		var s := durum(o, k)
		var v := tanim(k) if not s.is_empty() else {}
		if not v.is_empty() and s.get("durum", "") in ["hazir", "acik"] and o.gun > int(s.giris) + int(v.gun_max):
			s["durum"] = "suresi_doldu" if s.durum == "acik" else "kapandi"

static func bina_var(o: Oturum, v: Dictionary) -> bool:
	for b in o.yonetim.binalar:
		if b.tur == String(v.bina) and b.hazir(): return true
	return false

static func konus(o: Oturum, k: Koylu) -> Dictionary:
	ilerlet(o)
	var s := durum(o, k)
	if s.get("durum", "") != "hazir": return s
	var v := tanim(k)
	if v.is_empty() or o.gun < int(s.giris) + int(v.gun_min) or not bina_var(o, v): return {}
	for d: Dictionary in o.kadro.durumlar.values():
		var diger: Variant = d.get("tek_istek", {})
		if diger is Dictionary and diger.get("durum", "") == "acik": return {}
	s["durum"] = "acik"
	s["konusma"] = 1
	return s

static func yanit(o: Oturum, k: Koylu, tut: bool) -> bool:
	ilerlet(o)
	var s := durum(o, k)
	if s.get("durum", "") != "acik": return false
	var v := tanim(k)
	if v.is_empty(): return false
	if not tut:
		s["durum"] = "reddedildi"
		# Yeni eşik/bar/düşman doğurmaz; mevcut kayda nötr ret izi bırakır.
		o.yonetim.husumet.reddedilenler.append({"ad": k.ad, "gun": o.gun, "haksiz": false, "usta": "", "neden": "tek_istek"})
		return false
	var maliyet: Dictionary = v.maliyet
	if not bina_var(o, v) or not o.yonetim.kaynaklar.yeterli(maliyet) or not o.yonetim.kaynaklar.harca(maliyet):
		s["durum"] = "kaynak_yok"
		return false
	s["durum"] = "tutuldu"
	return true

static func metin(s: Dictionary, v: Dictionary) -> String:
	var hal := String(s.get("durum", ""))
	if hal not in ["acik", "suresi_doldu", "tutuldu", "reddedildi", "kaynak_yok"]: return ""
	return TranslationServer.translate(String(v.metin) if hal == "acik" else "koy.istek." + hal)

