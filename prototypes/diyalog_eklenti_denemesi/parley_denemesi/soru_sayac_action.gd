# Parley Action: Soru sorulduğunda cevap sayacını artırır
extends ParleyActionInterface

func run(ctx: ParleyContext, values: Array) -> int:
	if ctx and ctx.p_data is Dictionary:
		var c: int = int(ctx.p_data.get("cevap_sayisi", 0)) + 1
		ctx.p_data["cevap_sayisi"] = c
		var soru_adi: String = str(values[0]) if values.size() > 0 else "bilinmeyen"
		print("[PARLEY ACTION] Soru yanıtlandı: %s (Toplam cevap: %d)" % [soru_adi, c])
	return OK
