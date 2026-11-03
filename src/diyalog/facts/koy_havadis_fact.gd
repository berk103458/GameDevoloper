# Parley Fact: Köydeki dedikodu / havadis varlığı kontrolü
# "rusvet", "harami", "hastalik", "kitlik"
class_name KoyHavadisFact
extends ParleyFactInterface

func evaluate(ctx: ParleyContext, values: Array) -> bool:
	if not ctx or not ctx.p_data is Dictionary:
		return false
	var aranan: String = str(values[0]) if values.size() > 0 else "harami"
	var havadisler: Array = ctx.p_data.get("havadisler", [])
	return havadisler.has(aranan) or str(ctx.p_data.get("baskil_havadis", "")) == aranan
