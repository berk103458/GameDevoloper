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
