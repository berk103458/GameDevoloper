## Gerçek Meshy karakterlerinin kabul/ret rotası sonunda düğüm ömrü kontrolü.
extends Node

var _hata := 0

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
		_dene(is_instance_valid(model) and model.is_inside_tree(), "karakter_omru_kontrol.gd:15")
		await sahne.gelen_git(i % 2 == 0, i % 3 == 0)
		var bitis := Time.get_ticks_msec() + 10000
		while is_instance_valid(model) and Time.get_ticks_msec() < bitis:
			await get_tree().process_frame
		_dene(not is_instance_valid(model), "karakter_omru_kontrol.gd:20")
		_dene(sahne._gelen == null and sahne._heybe == null, "karakter_omru_kontrol.gd:21")
		await get_tree().process_frame
		_dene(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)) == yetim_once, "karakter_omru_kontrol.gd:23")
		print("KARAKTER ÖMRÜ: rota %d düğüm silindi, orphan=%d" % [i + 1, yetim_once])
	# Köye/sahneye geçiş ayrılma rotasını yarıda keserse alt ağaç yine temizlenir.
	await sahne.gelen_yaklas("chr_001")
	var yolda := sahne._gelen
	await sahne.gelen_git(false)
	sahne.queue_free()
	await get_tree().process_frame
	await get_tree().process_frame
	_dene(not is_instance_valid(yolda), "karakter_omru_kontrol.gd:32")
	_dene(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)) == yetim_once, "karakter_omru_kontrol.gd:33")
	Engine.time_scale = zaman_once
	print("KARAKTER ÖMRÜ: GEÇTİ" if _hata == 0 else "KARAKTER ÖMRÜ: KALDI (%d hata)" % _hata)
	get_tree().quit(1 if _hata > 0 else 0)


func _dene(kosul: bool, ad: String) -> void:
	if not kosul:
		_hata += 1
		push_error(ad)
