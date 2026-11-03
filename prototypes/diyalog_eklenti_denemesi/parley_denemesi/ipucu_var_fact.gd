# Parley Fact: CHR_011 düğüm 00 seçenek 3 ipucu kontrolü
extends ParleyFactInterface

func evaluate(ctx: ParleyContext, _values: Array) -> bool:
	# ctx.p_data içinde "ipucu_var" veya CHR ipucu listesi kontrol edilir
	if ctx and ctx.p_data is Dictionary:
		return bool(ctx.p_data.get("ipucu_var", false))
	return false
