# Parley Action: Eşle ilişki ve özel bayrak etkilerini uygulama
class_name EsIliskisiAction
extends ParleyActionInterface

func run(ctx: ParleyContext, values: Array) -> int:
	if not ctx or not (ctx.p_data is Dictionary):
		return OK
		
	var tur: String = String(values[0]) if values.size() > 0 else "moral"
	var miktar: int = int(values[1]) if values.size() > 1 else 0
	var bayrak: String = String(values[2]) if values.size() > 2 else ""
	
	var degisimler: Array = ctx.p_data.get("uygulanan_etkiler", [])
	
	if tur == "moral":
		var moral: int = int(ctx.p_data.get("moral", 60))
		moral = clampi(moral + miktar, 0, 100)
		ctx.p_data["moral"] = moral
		degisimler.append({"tur": "moral", "delta": miktar})
	elif tur == "sadakat":
		degisimler.append({"tur": "sadakat", "delta": miktar})
		
	if not bayrak.is_empty():
		degisimler.append({"tur": "bayrak", "bayrak": bayrak})
		var havadisler: Array = ctx.p_data.get("havadisler", [])
		if not havadisler.has(bayrak):
			havadisler.append(bayrak)
		ctx.p_data["havadisler"] = havadisler
		
	ctx.p_data["uygulanan_etkiler"] = degisimler
	return OK
