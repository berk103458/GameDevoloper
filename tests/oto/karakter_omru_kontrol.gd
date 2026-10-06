## Gerçek Meshy karakterlerinin kabul/ret rotası sonunda düğüm ömrü kontrolü.
extends Node

func _ready() -> void:
	get_tree().create_timer(60.0, true, false, true).timeout.connect(func() -> void: get_tree().quit(1))
	var zaman_once := Engine.time_scale
	Engine.time_scale = 20.0
	var sahne := KapiSahnesi.new()
	add_child(sahne)
	await get_tree().process_frame
	var yetim_once := int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))
	for i in 6:
		await sahne.gelen_yaklas("chr_001" if i % 2 == 0 else "chr_003")
		var model := sahne._gelen
		assert(is_instance_valid(model) and model.is_inside_tree())
		await sahne.gelen_git(i % 2 == 0, i % 3 == 0)
		var bitis := Time.get_ticks_msec() + 10000
		while is_instance_valid(model) and Time.get_ticks_msec() < bitis:
			await get_tree().process_frame
		assert(not is_instance_valid(model))
		assert(sahne._gelen == null and sahne._heybe == null)
		await get_tree().process_frame
		assert(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)) == yetim_once)
		print("KARAKTER ÖMRÜ: rota %d düğüm silindi, orphan=%d" % [i + 1, yetim_once])
	# Köye/sahneye geçiş ayrılma rotasını yarıda keserse alt ağaç yine temizlenir.
	await sahne.gelen_yaklas("chr_001")
	var yolda := sahne._gelen
	await sahne.gelen_git(false)
	sahne.queue_free()
	await get_tree().process_frame
	await get_tree().process_frame
	assert(not is_instance_valid(yolda))
	assert(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)) == yetim_once)
	Engine.time_scale = zaman_once
	print("KARAKTER ÖMRÜ: GEÇTİ")
	get_tree().quit(0)
