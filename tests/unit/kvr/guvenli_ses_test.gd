extends SceneTree

var _hata := 0

const SES = preload("res://src/sistemler/ses.gd")

func _initialize() -> void:
	var hazir_degil := SES.new()
	_dene(not hazir_degil.oynat(&"sfx_onay"), "guvenli_ses_test.gd:7")
	hazir_degil.free()
	call_deferred("_calistir")

func _calistir() -> void:
	var ses := SES.new()
	root.add_child(ses)
	var sira: int = ses._sira
	_dene(not ses.oynat(&"olmayan_ses") and ses._sira == sira, "guvenli_ses_test.gd:15")
	_dene(not ses.oynat(&"") and not ses.oynat(&"sfx_onay", NAN), "guvenli_ses_test.gd:16")
	ses._sira = 999
	_dene(ses.oynat(&"sfx_onay", -12.0) and ses._sira < ses.ES_ZAMANLI, "guvenli_ses_test.gd:18")
	# Sessiz/cache null bozulması da havuz çağrısını güvenle durdurur.
	ses._onbellek["null_ses"] = null
	_dene(not ses.oynat(&"null_ses"), "guvenli_ses_test.gd:21")
	await ses.sustur()
	ses.free()
	print("GÜVENLİ SES: GEÇTİ" if _hata == 0 else "GÜVENLİ SES: KALDI (%d hata)" % _hata)
	quit(1 if _hata > 0 else 0)


func _dene(kosul: bool, ad: String) -> void:
	if not kosul:
		_hata += 1
		push_error(ad)
