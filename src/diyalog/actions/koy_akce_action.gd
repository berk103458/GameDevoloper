# Parley Action: Muhafız ile köylü arasında akçe transferi
class_name KoyAkceAction
extends ParleyActionInterface

func run(ctx: ParleyContext, values: Array) -> int:
	var miktar: int = int(values[0]) if values.size() > 0 else 0
	if ctx and ctx.p_data is Dictionary:
		var degisimler: Array = ctx.p_data.get("uygulanan_etkiler", [])
		degisimler.append({"tur": "akce", "miktar": miktar})
		ctx.p_data["uygulanan_etkiler"] = degisimler
	return OK
