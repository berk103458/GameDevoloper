# Parley Fact: diyalog_01 esik kontrolü (cevap_sayisi >= 1 mi?)
extends ParleyFactInterface

func evaluate(ctx: ParleyContext, _values: Array) -> bool:
	if ctx and ctx.p_data is Dictionary:
		var cevap_sayisi: int = int(ctx.p_data.get("cevap_sayisi", 0))
		return cevap_sayisi >= 1
	return false
