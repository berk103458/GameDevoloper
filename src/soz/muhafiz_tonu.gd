## DIY-15: yalnız metin/tepki seçer; mekanik seçenek sözlüğüne yazmaz.
extends RefCounted
const GECMIS = preload("res://src/sistemler/muhafiz_gecmisi.gd")
const TONLAR := ["adil", "sert", "yoz"]

static func ton(o: Oturum) -> String:
	if o == null: return "sert"
	var denge: int = int(MuhafizTerazisi.durum(o).denge)
	if denge >= int(MuhafizTerazisi.AYAR.adil_esik): return "adil"
	if denge <= int(MuhafizTerazisi.AYAR.yoz_esik): return "yoz"
	return "sert"

static func gorunur(o: Oturum, s: Dictionary) -> bool:
	return not s.has("gecmis") or (o != null and String(s.gecmis) == GECMIS.kimlik(o))

static func dogrula(s: Dictionary, metinler: Variant = null) -> PackedStringArray:
	var h := PackedStringArray()
	if s.has("gecmis") and (not s.gecmis is String or not s.gecmis in GECMIS.SIRA): h.append("Tanımsız seçenek geçmişi")
	if not s.has("tonlar"): return h
	if not s.tonlar is Dictionary:
		h.append("Tonlar sözlük olmalı")
		return h
	if not s.get("etki", {}) is Dictionary: h.append("Mekanik etki sözlük olmalı")
	for t in s.tonlar:
		if t not in TONLAR: h.append("Tanımsız ton: " + String(t))
	for t in TONLAR:
		var v: Variant = s.tonlar.get(t)
		if not v is Dictionary or not v.get("metin_anahtari") is String or String(v.metin_anahtari).strip_edges().is_empty():
			h.append("Eksik ton metni: " + t)
			continue
		if metinler is Dictionary and (not metinler.get(v.metin_anahtari) is String or String(metinler[v.metin_anahtari]).strip_edges().is_empty()): h.append("Eksik ton kaynağı: " + t)
		if v.has("tepki_varyantlari") and not v.tepki_varyantlari is Array: h.append("Tepki varyantları dizi olmalı: " + t)
		if v.has("etki") and v.etki != s.get("etki", {}): h.append("Ton mekanik etkiyi değiştiremez: " + t)
		for alan in v:
			if alan not in ["metin_anahtari", "etki", "tepki_varyantlari"]: h.append("Ton yalnız metin ve tepki taşır: " + String(alan))
	return h

static func dugum_hatalari(d: Dictionary, metinler: Variant = null) -> PackedStringArray:
	var h := PackedStringArray()
	for s in d.get("secenekler", []):
		if s is Dictionary: h.append_array(dogrula(s, metinler))
	return h

static func anahtar(o: Oturum, s: Dictionary) -> String:
	if not gorunur(o, s) or not dogrula(s).is_empty(): return ""
	if not s.has("tonlar"): return String(s.get("metin_anahtari", ""))
	return String(s.tonlar[ton(o)].metin_anahtari)

static func tepki(o: Oturum, s: Dictionary, baglam: Dictionary) -> String:
	if not gorunur(o, s) or not dogrula(s).is_empty() or not s.has("tonlar"): return ""
	var liste: Array = s.tonlar[ton(o)].get("tepki_varyantlari", [])
	return SatirSecici.new().sec_metin(liste, baglam)
