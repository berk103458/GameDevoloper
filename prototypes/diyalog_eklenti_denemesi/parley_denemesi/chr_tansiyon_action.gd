# Parley Action: CHR_011 Seçenek 3 seçildiğinde tansiyonu +2 artırır
extends ParleyActionInterface

func run(ctx: ParleyContext, values: Array) -> int:
	var delta: int = int(values[0]) if values.size() > 0 else 2
	if ctx and ctx.p_data is Dictionary:
		var t: int = int(ctx.p_data.get("tansiyon", 2)) + delta
		ctx.p_data["tansiyon"] = t
		print("[PARLEY ACTION] CHR_011 İpucu seçeneği uygulandı. Tansiyon artışı: +%d (Yeni tansiyon: %d)" % [delta, t])
	return OK
