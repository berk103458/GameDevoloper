# Parley Fact: Köylünün moral seviyesi kontrolü (0..100)
# Değer karşılaştırması: "iyi" (>= 60), "vasat" (40..59), "dusuk" (< 40)
class_name KoyluMoralFact
extends ParleyFactInterface

func evaluate(ctx: ParleyContext, values: Array) -> bool:
	if not ctx or not ctx.p_data is Dictionary:
		return false
	var beklenen: String = str(values[0]) if values.size() > 0 else "iyi"
	var moral: int = int(ctx.p_data.get("moral", 60))
	match beklenen:
		"iyi":
			return moral >= 60
		"vasat":
			return moral >= 40 and moral < 60
		"dusuk":
			return moral < 40
		_:
			return moral >= int(beklenen)
