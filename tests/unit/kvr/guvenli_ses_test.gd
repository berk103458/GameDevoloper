extends SceneTree

const SES = preload("res://src/sistemler/ses.gd")

func _initialize() -> void:
	var hazir_degil := SES.new()
	assert(not hazir_degil.oynat(&"sfx_onay"))
	hazir_degil.free()
	call_deferred("_calistir")

func _calistir() -> void:
	var ses := SES.new()
	root.add_child(ses)
	var sira: int = ses._sira
	assert(not ses.oynat(&"olmayan_ses") and ses._sira == sira)
	assert(not ses.oynat(&"") and not ses.oynat(&"sfx_onay", NAN))
	ses._sira = 999
	assert(ses.oynat(&"sfx_onay", -12.0) and ses._sira < ses.ES_ZAMANLI)
	# Sessiz/cache null bozulması da havuz çağrısını güvenle durdurur.
	ses._onbellek["null_ses"] = null
	assert(not ses.oynat(&"null_ses"))
	await ses.sustur()
	ses.free()
	print("GÜVENLİ SES: GEÇTİ")
	quit(0)
