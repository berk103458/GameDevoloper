## SEV-01: mevcut boş günün salt okunur iş sohbeti; ziyaretçi üretmez.
extends RefCounted

const META := &"sev01_is_satirlari"
const HAVUZ := {
	"CIFTCI": ["anlati.bos_gun.ekin", "anlati.bos_gun.tohum"],
	"DEMIRCI": ["anlati.bos_gun.ors", "anlati.bos_gun.cekic"],
	"ESNAF": ["anlati.bos_gun.tezgah", "anlati.bos_gun.mal"],
	"COBAN": ["anlati.bos_gun.suru", "anlati.bos_gun.otlak"],
}

static func acik(o: Oturum) -> bool:
	# gece_kuyrugu() üretici bir API'dir; buradan çağrılmaz.
	return SevilenYuz.new().bos_gun_isareti(o)

static func satir(o: Oturum, k: Koylu) -> String:
	if not acik(o) or k == null: return ""
	var d: Dictionary = o.get_meta(META, {"gun": o.gun, "adet": 0, "kullanilan": [], "son": ""})
	if int(d.gun) != o.gun:
		d.gun = o.gun
		d.adet = 0
	if int(d.adet) >= 2: return ""
	var tur := ZanaatTuru.anahtar(k.zanaat_turu)
	for anahtar: String in HAVUZ.get(tur, []):
		if anahtar == d.son or anahtar in d.kullanilan: continue
		d.kullanilan.append(anahtar)
		d.son = anahtar
		d.adet = int(d.adet) + 1
		o.set_meta(META, d)
		return anahtar
	return ""

## SEV-02: ANI-07 kadrajında gerçekten duran adlı köylülerden bir selam.
static var TANIDIK: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/soz/tanidik_yuz.json"))

static func ates_selami(o: Oturum, adaylar: Array[Koylu]) -> Dictionary:
	if not acik(o) or o.aksam_sohbeti_gece == o.gun: return {}
	for kayit: Dictionary in o.kadro.durumlar.values():
		if int(kayit.get("ates_son_gun", -100)) == o.gun: return {}
	var yetiskin := false
	for k in adaylar:
		if k.yas_grubu != &"cocuk": yetiskin = true
	for k in adaylar:
		if k.adli_id == &"" or (k.yas_grubu == &"cocuk" and not yetiskin): continue
		var hafiza := KisiHafizasi.oku(o.kadro, k.adli_id)
		if o.gun - int(o.kadro.durumlar.get(k.adli_id, {}).get("ates_son_gun", -100)) < int(TANIDIK.aralik_gun): continue
		hafiza["id"] = String(k.adli_id)
		hafiza["ad"] = k.ad
		var secim := SevilenYuz.new().ates_ziyaretcisi_sec([hafiza])
		if secim.is_empty(): continue
		o.kadro.durumlar[k.adli_id]["ates_son_gun"] = o.gun
		secim["koylu"] = k
		secim["hitap"] = TANIDIK.kisiler.get(String(k.adli_id), {}).get("hitap", "")
		return secim
	return {}

## ANI-07 gerçek yürüyüş süzgeci: adsız mevcut rutin korunur; adlı tek yüz seçilir.
static func ates_yol_adayi(y: KoyYonetimi, k: Koylu) -> bool:
	if k.adli_id == &"" or not y.has_meta(&"sev02_oturum"): return true
	var o: Oturum = y.get_meta(&"sev02_oturum").get_ref()
	if o == null or not acik(o) or o.aksam_sohbeti_gece == o.gun: return false
	for aday in y.koylular:
		if aday.adli_id == &"" or aday.is_yeri != KoyYonetimi.BOSTA: continue
		if MuhafizMaasi.aday(aday, y) or KapiNobeti.yuva(y) == aday.id: continue
		if aday.yas_grubu == &"cocuk": continue # Çocuğu tek başına yola çıkarma.
		var h := KisiHafizasi.oku(o.kadro, aday.adli_id)
		h["id"] = String(aday.adli_id)
		if SevilenYuz.new().ates_ziyaretcisi_sec([h]).is_empty(): continue
		var son := int(o.kadro.durumlar.get(aday.adli_id, {}).get("ates_son_gun", -100))
		# Selam verildiği akşam köylü ateşten aniden ayrılmaz.
		if son != o.gun and o.gun - son < int(TANIDIK.aralik_gun): continue
		return aday == k
	return false
