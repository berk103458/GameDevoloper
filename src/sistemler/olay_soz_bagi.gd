## OZL-02: Kart metni Soz dalina dusebilir.
## Secilen kartin `id` degeri DIY-09 baglamina `olay.<id>` anahtari olarak girer;
## kapida veya koyde o olayi anan kisi (tanik, es, donen yuz) ilgili dali acar.
## Kart metni CSV'de kalir, ikinci kopya yazilmaz.
class_name OlaySozBagi
extends RefCounted

const SatirSeciciSinifi = preload("res://src/soz/satir_secici.gd")

const OLAY_ONEKI := "olay."
const SIRA_ONEKI := "sira."
const ANAN_ROLLER := ["tanik", "es", "donen_yuz"]


## Verilen karttan (`OlayVerisi`, `Dictionary`, `String` veya `StringName`) olay kimligini cikarir.
static func olay_kimligi_cikar(olay: Variant) -> String:
	if olay == null:
		return ""
	if olay is String or olay is StringName:
		var s := String(olay).strip_edges()
		if s.begins_with(OLAY_ONEKI):
			return s.substr(OLAY_ONEKI.length()).strip_edges()
		return s
	if olay is Dictionary:
		return olay_kimligi_cikar((olay as Dictionary).get("id", ""))
	if olay is Object and "id" in olay:
		return olay_kimligi_cikar(olay.get("id"))
	return ""


## Kartin `olay.<id>` baglam anahtarini doner; kart yoksa `""` doner.
static func olay_anahtari(olay: Variant) -> String:
	var kimlik := olay_kimligi_cikar(olay)
	if kimlik.is_empty():
		return ""
	return OLAY_ONEKI + kimlik


## Kisinin olayi anabilecek konumda (tanik, es veya donen yuz) olup olmadigini denetler.
static func anan_kisi_uygun_mu(kisi: Variant) -> bool:
	if kisi == null:
		return false
	if typeof(kisi) == TYPE_BOOL:
		return bool(kisi)
	if kisi is String or kisi is StringName:
		var rol := String(kisi).strip_edges().to_lower()
		return rol in ANAN_ROLLER
	if kisi is Dictionary:
		var d: Dictionary = kisi
		var rol := String(d.get("rol", d.get("bag", ""))).strip_edges().to_lower()
		if rol in ANAN_ROLLER:
			return true
		if bool(d.get("tanik", false)) or bool(d.get("es", false)) or bool(d.get("donen_yuz", false)):
			return true
	return false


## Secilen gece kartini DIY-09 baglam sozlugune `olay.<id> = true` olarak yazar.
## Kart yoksa veya kisi tanik/es/donen_yuz degilse anahtar yazilmaz.
static func baglama_olay_yaz(baglam: Dictionary, olay: Variant, kisi: Variant = "tanik") -> Dictionary:
	var kopya := baglam.duplicate(true)
	var anahtar := olay_anahtari(olay)
	if anahtar.is_empty() or not anan_kisi_uygun_mu(kisi):
		return kopya
	kopya[anahtar] = true
	return kopya


## Kart gecesi + tanik/es/donen_yuz -> acilan dal sayisi 1; kart yokken veya tanik yokken 0.
static func dal_sayisi(olay: Variant, kisi: Variant = "tanik", dallar: Array = []) -> int:
	var anahtar := olay_anahtari(olay)
	if anahtar.is_empty() or not anan_kisi_uygun_mu(kisi):
		return 0
	if dallar.is_empty():
		return 1
	var baglam := baglama_olay_yaz({}, olay, kisi)
	var secici := SatirSeciciSinifi.new()
	var secilen := secici.sec(dallar, baglam)
	return 1 if not secilen.is_empty() else 0


## DIY-09 SatirSecici uzerinden ilgili `olay.<id>` dalini secer.
## Kart metni CSV'de kalir; ikinci metin kopyasi uretilmez.
static func dal_sec(dallar: Array, baglam: Dictionary, olay: Variant, kisi: Variant = "tanik") -> Dictionary:
	var guncel_baglam := baglama_olay_yaz(baglam, olay, kisi)
	var secici := SatirSeciciSinifi.new()
	return secici.sec(dallar, guncel_baglam)


## OZL-07: Sira olayi Soz dalini acar.
## Kuyruktaki kisinin Soz dosyasinda `sira.<id>` dali varsa kartin yaninda o dal bir kez sorulur;
## yoksa kart tek basina (`kart_only`) kalir.
static func sira_anahtari(sira_id: Variant) -> String:
	var kimlik := olay_kimligi_cikar(sira_id)
	if kimlik.begins_with(SIRA_ONEKI):
		kimlik = kimlik.substr(SIRA_ONEKI.length()).strip_edges()
	if kimlik.is_empty():
		return ""
	return SIRA_ONEKI + kimlik


static func _kisi_soz_dallarini_cikar(kisi: Variant) -> Array[String]:
	var sonuc: Array[String] = []
	if kisi == null:
		return sonuc
	if kisi is Dictionary:
		var d: Dictionary = kisi
		var ham: Variant = d.get("soz_dallari", d.get("dallar", []))
		if ham is Array:
			for oge in ham:
				if oge is Dictionary:
					var id_str := String((oge as Dictionary).get("id", (oge as Dictionary).get("dal", ""))).strip_edges()
					if not id_str.is_empty():
						sonuc.append(id_str)
					var kosullar: Variant = (oge as Dictionary).get("kosullar", {})
					if kosullar is Dictionary:
						for k in (kosullar as Dictionary).keys():
							sonuc.append(String(k).strip_edges())
				else:
					sonuc.append(String(oge).strip_edges())
		elif ham is Dictionary:
			for k in (ham as Dictionary).keys():
				sonuc.append(String(k).strip_edges())
	elif kisi is Object:
		if kisi.has_meta("soz_dallari"):
			return _kisi_soz_dallarini_cikar({"soz_dallari": kisi.get_meta("soz_dallari")})
		if "veri" in kisi and kisi.get("veri") is Dictionary:
			return _kisi_soz_dallarini_cikar(kisi.get("veri"))
	return sonuc


static func sira_dali_var_mi(kisi: Variant, sira_id: Variant) -> bool:
	var anahtar := sira_anahtari(sira_id)
	if anahtar.is_empty():
		return false
	var ham_kimlik := anahtar.substr(SIRA_ONEKI.length())
	var alternatif := SIRA_ONEKI + ("sira_" + ham_kimlik if not ham_kimlik.begins_with("sira_") else ham_kimlik.substr(5))
	var dallar := _kisi_soz_dallarini_cikar(kisi)
	return (anahtar in dallar) or (alternatif in dallar)


## Kuyruktaki kisi icin sira olayini Soz daliyla baglar.
## Dal varsa ve daha once sorulmadiysa 1 kez sorar (`dal_sayisi: 1, kart_only: false`);
## dal yoksa veya zaten sorulduysa kart tek basina kalir (`dal_sayisi: 0, kart_only: true`).
static func sira_bagla(kisi: Variant, sira_id: Variant, soruldu_kaydi: Dictionary = {}) -> Dictionary:
	var anahtar := sira_anahtari(sira_id)
	if anahtar.is_empty() or not sira_dali_var_mi(kisi, sira_id):
		return {
			"kip": "kart_only",
			"kart_only": true,
			"dal_sayisi": 0,
			"dal_anahtari": "",
		}
	var kisi_id := ""
	if kisi is Dictionary:
		kisi_id = String((kisi as Dictionary).get("id", (kisi as Dictionary).get("ad", "")))
	elif kisi is Object and "ad" in kisi:
		kisi_id = String(kisi.get("ad"))
	var tekil_anahtar := "%s:%s" % [kisi_id, anahtar]
	if bool(soruldu_kaydi.get(tekil_anahtar, false)):
		return {
			"kip": "kart_only",
			"kart_only": true,
			"dal_sayisi": 0,
			"dal_anahtari": "",
		}
	soruldu_kaydi[tekil_anahtar] = true
	return {
		"kip": "kart_ve_dal",
		"kart_only": false,
		"dal_sayisi": 1,
		"dal_anahtari": anahtar,
	}
