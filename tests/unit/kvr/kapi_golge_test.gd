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
	root.positional_shadow_atlas_size = 4096
	var kapi := KapiSahnesi.new()
	root.add_child(kapi)
	_kontrol(root.positional_shadow_atlas_size == 2048 and not kapi._isiklar.is_empty(), "SAH-65: Gerçek kapı BUG-04 atlas tavanını uygular")
	for mesale in kapi._isiklar:
		_kontrol(mesale.distance_fade_enabled and mesale.distance_fade_shadow == 16.0, "SAH-65: Gerçek kapı meşalesinin gölge mesafesi sınırlı")
	print("SAH-65 kapı atlası=%d, meşale=%d" % [root.positional_shadow_atlas_size, kapi._isiklar.size()])
	var ilk_enerji := kapi._isiklar[0].light_energy
	kapi.queue_free()
	await process_frame
	_kontrol(root.positional_shadow_atlas_size == 4096, "SAH-65: Kapı kapanınca önceki atlas geri gelir")
	var koy := KoyAtmosferi.new()
	root.add_child(koy)
	koy.faz(&"gece", 0.0)
	var ayar: Dictionary = preload("res://data/ayarlar/sahne.json").data
	_kontrol(is_equal_approx(koy.cevre.ambient_light_energy, float(ayar.koy_isik.ortam_enerjisi.gece)), "SAH-67: Köy gecesi kendi ortam değerini kullanır")
	koy.queue_free()
	await process_frame
	kapi = KapiSahnesi.new()
	root.add_child(kapi)
	_kontrol(is_equal_approx(kapi._isiklar[0].light_energy, ilk_enerji) and is_equal_approx(ilk_enerji, float(ayar.kapi_isik.enerji)), "SAH-67: Köyden kapıya geçişte meşale enerjisi aynıdır")
	print("SAH-67 kapı öncesi/sonrası enerji=%.2f / %.2f" % [ilk_enerji, kapi._isiklar[0].light_energy])
	kapi.queue_free()
	await process_frame
	root.positional_shadow_atlas_size = atlas_once
	isik.free()
	await process_frame
	print("KAPI GÖLGE PROFİLİ: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	await root.get_node("Ses").cik(hata)

func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
