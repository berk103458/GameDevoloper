extends SceneTree

var hata := 0

func _initialize() -> void:
	call_deferred("_calistir")

func _calistir() -> void:
	var atlas_once := root.positional_shadow_atlas_size
	root.positional_shadow_atlas_size = 4096
	var isik := OmniLight3D.new()
	isik.light_energy = 1.9
	isik.shadow_enabled = true
	root.add_child(isik)
	var profil := preload("res://src/dunya/kapi_golge_profili.gd").new()
	profil.isiklar.append(isik)
	root.add_child(profil)
	_kontrol(root.positional_shadow_atlas_size == 2048, "4096 atlas 2048 sınırına iner")
	_kontrol(isik.distance_fade_enabled and isik.distance_fade_begin == 24 and isik.distance_fade_shadow == 16, "Renderer ışık/gölge LOD sınırları")
	_kontrol(is_equal_approx(isik.light_energy, 1.9) and isik.shadow_enabled, "Yakın ışık enerjisi ve gölge korunur")
	var ikinci := preload("res://src/dunya/kapi_golge_profili.gd").new()
	root.add_child(ikinci)
	profil.free()
	_kontrol(root.positional_shadow_atlas_size == 2048, "Diğer kapı açıkken atlas korunur")
	ikinci.free()
	_kontrol(root.positional_shadow_atlas_size == 4096, "Son kapı çıkınca önceki atlas geri döner")
	root.positional_shadow_atlas_size = 1024
	profil = preload("res://src/dunya/kapi_golge_profili.gd").new()
	root.add_child(profil)
	_kontrol(root.positional_shadow_atlas_size == 1024, "Düşük kalite ayarı yükseltilmez")
	root.positional_shadow_atlas_size = 512
	profil.free()
	_kontrol(root.positional_shadow_atlas_size == 512, "Sahne açıkken değişen kalite tercihi ezilmez")
	root.positional_shadow_atlas_size = atlas_once
	isik.free()
	await process_frame
	print("KAPI GÖLGE PROFİLİ: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)

func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
