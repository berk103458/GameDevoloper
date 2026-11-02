extends SceneTree

const OlaySozBagiSinifi = preload("res://src/sistemler/olay_soz_bagi.gd")
const SatirSeciciSinifi = preload("res://src/soz/satir_secici.gd")

var _hata: int = 0


func _kontrol(kosul: bool, mesaj: String) -> void:
	if not kosul:
		_hata += 1
		push_error("OLAY SOZ BAGI TEST HATASI: " + mesaj)


func _initialize() -> void:
	var dallar := [
		{
			"id": "dal_yangin",
			"kosullar": {"olay.yangin": true},
			"oncelik": 2,
			"csv_anahtari": "olay.yangin.metin",
		},
	]

	# Gece 1: Kart gecesi + tanik -> dal 1
	var kart_gece1 := {"id": "yangin"}
	var baglam_gece1 := OlaySozBagiSinifi.baglama_olay_yaz({"gun": 1}, kart_gece1, "tanik")
	_kontrol(bool(baglam_gece1.get("olay.yangin", false)), "Kart gecesi + tanik baglama olay.yangin yazmali")
	var dal_gece1 := OlaySozBagiSinifi.dal_sayisi(kart_gece1, "tanik", dallar)
	_kontrol(dal_gece1 == 1, "Gece 1 (kart + tanik) acilan dal sayisi 1 olmali")
	var secilen_dal := OlaySozBagiSinifi.dal_sec(dallar, {"gun": 1}, kart_gece1, {"rol": "es"})
	_kontrol(String(secilen_dal.get("id", "")) == "dal_yangin", "Es veya tanik ilgili Soz dalini acmali")

	# Gece 2: Kart yokken -> dal 0
	var baglam_gece2 := OlaySozBagiSinifi.baglama_olay_yaz({"gun": 2}, null, "tanik")
	_kontrol(not baglam_gece2.has("olay.yangin"), "Kart yokken baglama olay anahtari yazilmamali")
	var dal_gece2 := OlaySozBagiSinifi.dal_sayisi(null, "tanik", dallar)
	_kontrol(dal_gece2 == 0, "Gece 2 (kart yokken) acilan dal sayisi 0 olmali")
	var secilen_bos := OlaySozBagiSinifi.dal_sec(dallar, {"gun": 2}, null, "tanik")
	_kontrol(secilen_bos.is_empty(), "Kart yokken dal secilmemeli")

	# Dogrulama: DIY-09 dogrulayicisi olay.<id> alanini tanimali
	var hatalar := SatirSeciciSinifi.dogrula(dallar, {"gun": 1})
	_kontrol(hatalar.is_empty(), "SatirSecici olay.<id> kosul alanini gecerli saymali")

	if _hata == 0:
		print("OLAY SOZ BAGI: GEÇTİ (0 hata)")
	else:
		print("OLAY SOZ BAGI: KALDI (%d hata)" % _hata)
	quit(_hata)
