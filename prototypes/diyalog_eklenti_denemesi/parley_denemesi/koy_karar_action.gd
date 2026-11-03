# Parley Action: Köy kararı verme aksiyonu (Görev 2)
# NOT: Gerçek oyunda bu çağrı Oturum.karar_ver(gelen, &"kabul") ve hastalık için hastalik_teshis_adaptoru.gd olur.
extends ParleyActionInterface

func run(ctx: ParleyContext, values: Array) -> int:
	var karar: String = str(values[0]) if values.size() > 0 else "ret"
	# Gerçek oyunda bu çağrı Oturum.karar_ver(gelen, &"kabul") ve hastalık için hastalik_teshis_adaptoru.gd olur.
	match karar:
		"kabul":
			# Bar dizisi gelen.etkiler: indis 0 moral, 1 adalet, 2 akçe, 3 asayiş riski
			print("[PARLEY ACTION KÖY ETKİSİ] Karar: 'kabul' verildi. Bar indisleri: moral=0, adalet=1, akce=2, asayis_riski=3 -> KoyYonetimi.kabul çağrılır.")
		"ret":
			print("[PARLEY ACTION KÖY ETKİSİ] Karar: 'ret' verildi. Bar indisleri: yonetim.ret çağrılır; köy kapısı kapanır.")
		"rusvet":
			print("[PARLEY ACTION KÖY ETKİSİ] Karar: 'rusvet' verildi. Bar indisleri: muhafiz_akce (kasa) aktarımı yapılır, çift kasa dağıtılır.")
		_:
			print("[PARLEY ACTION KÖY ETKİSİ] Bilinmeyen karar: %s" % karar)
	if ctx and ctx.p_data is Dictionary:
		ctx.p_data["son_karar"] = karar
	return OK
