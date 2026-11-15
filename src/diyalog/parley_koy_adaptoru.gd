# Parley - Köy Yönetimi İnce Adaptörü (Görev 3)
# Çekirdek sınıflara (Koylu, KoyYonetimi, Oturum) doğrudan Parley bağımlılığı sokmaz.
class_name ParleyKoyAdaptoru
extends RefCounted

## Köylü ve köy durumunu Parley context sözlüğüne dönüştürür
static func baglam_olustur(koylu: Koylu, yonetim: KoyYonetimi = null) -> Dictionary:
	var veri := {
		"koylu_id": koylu.id if koylu else -1,
		"ad": koylu.ad if koylu else "Köylü",
		"sinif": String(koylu.sinif) if koylu else "ciftci",
		"adli_id": String(koylu.adli_id) if koylu else "",
		"moral": koylu.moral if koylu else 60,
		"refah": koylu.refah if koylu else 50,
		"saglik": koylu.saglik if koylu else 100,
		"ac": koylu.ac if koylu else false,
		"is_yeri": koylu.is_yeri if koylu else -1,
		"havadisler": [],
		"baskil_havadis": "harami",
		"canli_soylenti": "",
		"canli_soylenti_olay": "",
		"canli_soylenti_tur": "",
		"uygulanan_etkiler": []
	}
	
	if yonetim:
		var havadis_listesi: Array = []
		if yonetim.kaynaklar.miktar("gida") < 15:
			havadis_listesi.append("kitlik")
		if yonetim.koylular.any(func(k: Koylu) -> bool: return SaglikYoneticisi.hasta(k)):
			havadis_listesi.append("hastalik")
		if yonetim.asayis_riski > 40:
			havadis_listesi.append("harami")
		if koylu != null and yonetim.has_meta(SoylentiKoprusu.META):
			var canli := NeDuydun.canli_sohbet_kaydi(yonetim, koylu)
			if not canli.is_empty():
				var soz := NeDuydun.olay_cumlesi_kayittan(yonetim, koylu, canli)
				veri["canli_soylenti"] = soz
				veri["canli_soylenti_olay"] = String(canli.get("olay_id", ""))
				veri["canli_soylenti_tur"] = String(canli.get("tur", ""))
				if not soz.is_empty() and not havadis_listesi.has("soylenti"):
					havadis_listesi.append("soylenti")
		veri["havadisler"] = havadis_listesi
		if not havadis_listesi.is_empty():
			veri["baskil_havadis"] = havadis_listesi[0]
			
	return veri


static func canli_soylenti_satiri(p_data: Dictionary) -> String:
	return String(p_data.get("canli_soylenti", "")).strip_edges()


## Parley diyaloğu sonucunda oluşan etkileri köy ve köylüye yansıtır
static func etkileri_uygula(p_data: Dictionary, koylu: Koylu, yonetim: KoyYonetimi = null) -> void:
	if not p_data or not p_data.has("uygulanan_etkiler"):
		return
	var etkiler: Array = p_data.get("uygulanan_etkiler", [])
	for e in etkiler:
		if not e is Dictionary:
			continue
		var tur: String = str(e.get("tur", ""))
		match tur:
			"moral":
				var d: int = int(e.get("delta", 0))
				if koylu:
					koylu.moral = clampi(koylu.moral + d, 0, 100)
			"akce":
				var m: int = int(e.get("miktar", 0))
				if yonetim and m != 0:
					yonetim.akce = maxi(0, yonetim.akce + m)
			"sadakat":
				var s: int = int(e.get("delta", 0))
				if koylu:
					koylu.sadakat = clampi(koylu.sadakat + s, 0, 100)
			"bayrak":
				var b: String = str(e.get("bayrak", ""))
				if koylu and not b.is_empty():
					koylu.bayrak_ekle(StringName(b))
