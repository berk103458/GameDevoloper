## SOY-23: ağdaki her kayıt, konuşan karakter için DIY-09 bağlamına yazılır.
## SatirSecici koşulu ilk noktadan böler (`soylenti` + kalan). Bu yüzden anahtarlar
## düz durur: `soylenti.<olay_id>.duydu`, `.dogru`, `.kaynak`.
## Olay kimliği kayıttan kayda değişir. Veri dalı `soylenti_duydu` özetine bakar;
## karakter ağdaki en az bir kaydı duyduysa özet true olur.
## İkinci söylenti kaydı açılmaz. Değerler yalnız `baglam_sorgusu_al` çıktısıdır.
class_name SoylentiBaglami
extends RefCounted

const OZET := "soylenti_duydu"


static func baglama_yaz(baglam: Dictionary, ag: RefCounted, karakter_id: String) -> Dictionary:
	var kopya := baglam.duplicate(true)
	var duydu := false
	var kayitlar: Variant = ag.get("ag_kayitlari") if ag != null else {}
	if kayitlar is Dictionary:
		var kimlikler: Array = (kayitlar as Dictionary).keys()
		kimlikler.sort()
		for ham in kimlikler:
			var olay_id := String(ham).strip_edges()
			if olay_id.is_empty():
				continue
			var sorgu: Dictionary = ag.baglam_sorgusu_al(karakter_id, olay_id)
			var taban := "soylenti.%s." % olay_id
			var duydu_mu := bool(sorgu.get("duydu", false))
			kopya[taban + "duydu"] = duydu_mu
			kopya[taban + "dogru"] = bool(sorgu.get("dogru", false))
			kopya[taban + "kaynak"] = str(sorgu.get("kaynak", ""))
			if duydu_mu:
				duydu = true
	kopya[OZET] = duydu
	return kopya
