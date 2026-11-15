## ANL-EPI-01: Kış sonu kişisel epilog kartları ve akıbet metin adaptörü.
## Kalfa'nın hazırlayacağı sonuc_epilog_olusturucu.gd UI ekranı için veri köprüsü.
class_name EpilogMetinVerisi
extends RefCounted

const KARTLAR: Array[StringName] = [
	&"dursun_turna",
	&"lokman",
	&"banu",
	&"sungur",
	&"vebali_ana",
	&"hane",
]

const BASLIKLAR: Dictionary = {
	&"dursun_turna": "epilog.kart.dursun_turna",
	&"lokman": "epilog.kart.lokman",
	&"banu": "epilog.kart.banu",
	&"sungur": "epilog.kart.sungur",
	&"vebali_ana": "epilog.kart.vebali_ana",
	&"hane": "epilog.kart.hane",
}

## Belirtilen kart için uygun epilog metin anahtarını döner.
## context parametresi bir Oturum nesnesi veya bayrakları içeren Dictionary/Array olabilir.
static func kart_metin_anahtari(kart_id: StringName, context: Variant = null) -> String:
	match kart_id:
		&"dursun_turna":
			return _dursun_turna_anahtari(context)
		&"lokman":
			return _lokman_anahtari(context)
		&"banu":
			return _banu_anahtari(context)
		&"sungur":
			return _sungur_anahtari(context)
		&"vebali_ana":
			return _vebali_ana_anahtari(context)
		&"hane":
			return _hane_anahtari(context)
		_:
			return ""

## Tüm kartların durumunu, başlık anahtarını ve metin anahtarını liste olarak döner.
static func tum_kartlar(context: Variant = null) -> Array[Dictionary]:
	var sonuc: Array[Dictionary] = []
	for kart in KARTLAR:
		var anahtar := kart_metin_anahtari(kart, context)
		var olumlu := _kart_olumlu_mu(kart, anahtar)
		sonuc.append({
			"id": kart,
			"baslik_anahtari": BASLIKLAR.get(kart, ""),
			"metin_anahtari": anahtar,
			"olumlu": olumlu,
		})
	return sonuc

## Tek bir kartın verisini döner.
static func kart_verisi_al(kart_id: StringName, context: Variant = null) -> Dictionary:
	var anahtar := kart_metin_anahtari(kart_id, context)
	return {
		"id": kart_id,
		"baslik_anahtari": BASLIKLAR.get(kart_id, ""),
		"metin_anahtari": anahtar,
		"olumlu": _kart_olumlu_mu(kart_id, anahtar),
	}

static func _bayrak_var_mi(context: Variant, bayrak: StringName) -> bool:
	if context == null:
		return false
	if context is Dictionary:
		return context.has(bayrak) or context.has(String(bayrak))
	if context is Array:
		return context.has(bayrak) or context.has(String(bayrak))
	if context is Oturum:
		if context.bayraklar.has(bayrak) or context.bayraklar.has(StringName(bayrak)):
			return true
	return false

static func _dursun_turna_anahtari(context: Variant) -> String:
	if _bayrak_var_mi(context, &"dursun_ve_turna_kabul") or _bayrak_var_mi(context, &"dursun_turna_kabul") or \
		(_bayrak_var_mi(context, &"turna_kabul") and _bayrak_var_mi(context, &"dursun_kabul")):
		return "epilog.dursun_turna.kabul"
	return "epilog.dursun_turna.ret"

static func _lokman_anahtari(context: Variant) -> String:
	if _bayrak_var_mi(context, &"lokman_kovuldu") or _bayrak_var_mi(context, &"lokman_zindan") or _bayrak_var_mi(context, &"lokman_ihanet"):
		return "epilog.lokman.kovuldu"
	if _bayrak_var_mi(context, &"lokman_iyilesti") or _bayrak_var_mi(context, &"lokman_kabul"):
		return "epilog.lokman.iyilesti"
	return "epilog.lokman.kovuldu"

static func _banu_anahtari(context: Variant) -> String:
	if _bayrak_var_mi(context, &"banu_ittifak_kabul") or _bayrak_var_mi(context, &"banu_ittifak") or _bayrak_var_mi(context, &"oba_ittifaki"):
		return "epilog.banu.ittifak"
	return "epilog.banu.ret"

static func _sungur_anahtari(context: Variant) -> String:
	if _bayrak_var_mi(context, &"sungur_tatmin_edildi") or _bayrak_var_mi(context, &"sungur_ittifak") or _bayrak_var_mi(context, &"sungur_isbirligi") or _bayrak_var_mi(context, &"sungur_muttefik"):
		return "epilog.sungur.ittifak"
	return "epilog.sungur.hasim"

static func _vebali_ana_anahtari(context: Variant) -> String:
	if _bayrak_var_mi(context, &"veba_kirec_karantina_basarili") or _bayrak_var_mi(context, &"vebali_sifa"):
		return "epilog.vebali_ana.sifa"
	return "epilog.vebali_ana.kayip"

static func _hane_anahtari(context: Variant) -> String:
	if _bayrak_var_mi(context, &"hane_sadakat") or _bayrak_var_mi(context, &"es_sadakat_yuksek"):
		return "epilog.hane.sadakat"
	if _bayrak_var_mi(context, &"hane_yabanci") or _bayrak_var_mi(context, &"es_guvensizlik"):
		return "epilog.hane.yabanci"
	if context is Oturum and context.yonetim != null:
		if context.yonetim.huzur() >= 40:
			return "epilog.hane.sadakat"
		else:
			return "epilog.hane.yabanci"
	return "epilog.hane.sadakat"

static func _kart_olumlu_mu(_kart_id: StringName, anahtar: String) -> bool:
	return anahtar.ends_with(".kabul") or \
		anahtar.ends_with(".iyilesti") or \
		anahtar.ends_with(".ittifak") or \
		anahtar.ends_with(".sifa") or \
		anahtar.ends_with(".sadakat")
