## OMR-28: Yozlasma esigi (`nihai_sonlar.json esik.yozlasma`) omurgada gorunur.
## Esige uc kademe (15 puan) kala oda vicdan paneline tek satirlik erken uyari dusurur; esik degismez.
class_name OdaYozlasmaUyarisi
extends RefCounted

const NihaiSonSinifi = preload("res://src/sistemler/nihai_son.gd")
const KADEME_ADIMI := 5
const UYARI_KADEME_FARKI := 3


static func esik_degeri() -> int:
	return int(NihaiSonSinifi.AYAR.get("esik", {}).get("yozlasma", 60))


static func uyari_baslangici() -> int:
	return maxi(1, esik_degeri() - (KADEME_ADIMI * UYARI_KADEME_FARKI))


static func uyari_var_mi(kaynak: Variant) -> bool:
	var yozlasma := _yozlasma_coz(kaynak)
	return yozlasma >= uyari_baslangici()


static func satir(kaynak: Variant) -> String:
	if not uyari_var_mi(kaynak):
		return ""
	return "Yozlaşma eşiğine yaklaşıldı; sancağın gözü kapının üstünde."


static func _yozlasma_coz(kaynak: Variant) -> int:
	if kaynak is int or kaynak is float:
		return int(kaynak)
	if kaynak is Dictionary:
		return int((kaynak as Dictionary).get("yozlasma", 0))
	if kaynak is Oturum:
		return int(MuhafizTerazisi.durum(kaynak as Oturum).get("yozlasma", 0))
	return 0
