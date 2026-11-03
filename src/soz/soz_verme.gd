# gdlint: disable=max-line-length
class_name SozVerme
extends RefCounted

## DYL-05: Söz vermek — tutulan ve tutulmayan söz.
## Verilen söz süreyle kaydedilir; tutulursa güven +3, tutulmazsa güven -5 ve dedikodu.

var acik_sozler: Array[Dictionary] = []

func soz_ver(karakter_id: String, soz_turu: String, sure_gun: int = 3, gun: int = 1) -> Dictionary:
	var kayit := {
		"karakter_id": karakter_id,
		"soz_turu": soz_turu,
		"verildigi_gun": gun,
		"bitis_gunu": gun + sure_gun,
		"durum": "acik" # acik, tutuldu, tutulmadi
	}
	acik_sozler.append(kayit)
	return kayit

func soz_tutuldu(karakter_id: String, soz_turu: String) -> Dictionary:
	for s in acik_sozler:
		if s.get("karakter_id") == karakter_id and s.get("soz_turu") == soz_turu and s.get("durum") == "acik":
			s["durum"] = "tutuldu"
			return {
				"basarili": true,
				"guven_etkisi": 3,
				"durum": "tutuldu"
			}
	return {"basarili": false}

func gun_ilerlet(mevcut_gun: int) -> Array[Dictionary]:
	var bozulanlar: Array[Dictionary] = []
	for s in acik_sozler:
		if s.get("durum") == "acik" and mevcut_gun > int(s.get("bitis_gunu")):
			s["durum"] = "tutulmadi"
			bozulanlar.append({
				"karakter_id": s.get("karakter_id"),
				"soz_turu": s.get("soz_turu"),
				"guven_etkisi": -5,
				"dedikodu": "sozunden_donen_muhafiz",
				"terazi": "tutulmayan_soz"
			})
	return bozulanlar
