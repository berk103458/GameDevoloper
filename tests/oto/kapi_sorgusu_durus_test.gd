## SAH-23: Kapıya gerçek yaklaşma bittikten sonra beş saniyelik sorgu pozu.
extends SceneTree

const KARE := 1.0 / 120.0
const SURE := 5.0


func _initialize() -> void:
	_calistir.call_deferred()


func _calistir() -> void:
	var sahne := KapiSahnesi.new()
	root.add_child(sahne)
	await process_frame
	await sahne.gelen_yaklas("chr_001")
	var gelen := sahne._gelen
	var bas := gelen.global_position
	var oynatici := gelen._oynatici
	var konus := String(gelen._klipler.get("konus", ""))
	var gecti := bas.is_equal_approx(KapiSahnesi.DURMA) and gelen.hareket_var("konus")
	var konus_kareleri := 0
	var yurume_kareleri := 0
	var azami_kok := 0.0
	var sure := 0.0
	sahne.gelen_konus(SURE)
	while sure < SURE:
		await process_frame
		sure += KARE
		azami_kok = maxf(azami_kok, bas.distance_to(gelen.global_position))
		if oynatici.current_animation == konus:
			konus_kareleri += 1
		if oynatici.current_animation == gelen._anim or gelen.hareket_bandi() != "dur":
			yurume_kareleri += 1
		gecti = gecti and (gelen._yurume == null or not gelen._yurume.is_running())
	gecti = gecti and azami_kok <= 0.00001 and yurume_kareleri == 0
	gecti = gecti and konus_kareleri >= floori(SURE / KARE) - 2
	print("SAH-23 süre=%.2f s, konuşma=%d kare, yürüyüş=%d kare, azami kök farkı=%.6f m" % [
		sure, konus_kareleri, yurume_kareleri, azami_kok])
	sahne.queue_free()
	await process_frame
	print("KAPI SORGUSU DURUŞU: GEÇTİ" if gecti else "KAPI SORGUSU DURUŞU: KALDI")
	await root.get_node("Ses").cik(0 if gecti else 1)
