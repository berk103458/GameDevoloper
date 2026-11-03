# Parley Action: Köylünün veya köyün moralini değiştirme
class_name KoyMoralAction
extends ParleyActionInterface

func run(ctx: ParleyContext, values: Array) -> int:
	var delta: int = int(values[0]) if values.size() > 0 else 0
	if ctx and ctx.p_data is Dictionary:
		var moral: int = int(ctx.p_data.get("moral", 60))
		moral = clampi(moral + delta, 0, 100)
		ctx.p_data["moral"] = moral
		var degisimler: Array = ctx.p_data.get("uygulanan_etkiler", [])
		degisimler.append({"tur": "moral", "delta": delta})
		ctx.p_data["uygulanan_etkiler"] = degisimler
	return OK
