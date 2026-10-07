## EKO-02: Orman kampı → tomruk → hızarda kalas (kereste) / yakacak.
## Denge varsayımı: kişi başına 3 tomruk; 2 tomruk → 1 kalas veya 3 odun.
## Kalas mevcut kereste alanıdır; eski kayıt/tarif kimlikleri korunur.
class_name OdunZinciri
extends RefCounted
static func uygula(turler: Dictionary) -> void:
	if not turler.has("odunluk") or not bool(turler.odunluk.get("kurulabilir", false)):
		turler["odunluk"] = {"kategori": "uretim", "boyut": [2, 2], "maliyet": {"odun": 4, "tas": 2}, "slot": 2, "insa_gun": 1, "kurulabilir": true, "uzmanlik": "oduncu", "receteler": {"tomruk": {"uretim": {"tomruk": 3.0}}}}
static func tarifler(tur: String, temel: Dictionary) -> Dictionary:
	if tur != "hizarhane": return temel
	# Ham katalog korunur; bütün gerçek üretim/UI çağrıları aynı adaptörden okur.
	var r: Dictionary = temel.duplicate(true)
	r["odun"] = {"girdi": {"tomruk": 2}, "uretim": {"odun": 3.0}}
	r["kereste"] = {"girdi": {"tomruk": 2}, "uretim": {"kereste": 1.0}}
	return r
static func ad(anahtar: String) -> String:
	return {"koy.kaynak.tomruk": "Tomruk", "koy.recete.tomruk": "Ormandan tomruk", "koy.recete.kereste": "Kalas · 2 tomruk", "koy.recete.odun": "Yakacak · 2 tomruk", "koy.yapi.odunluk": "Orman Kampı", "koy.yapi.odunluk_aciklama": "Oduncular ormandan tomruk getirir; hızar 2 tomruğu kalasa veya yakacak oduna işler."}.get(anahtar, CobanSurusu.ad(anahtar))
