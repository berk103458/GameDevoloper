## Meshy hareket glb'lerinden (`assets/model/karakter/<ad>_<hareket>.glb`, repoya girmez: ~3 MB, model+doku)
## yalnız animasyonu çıkarıp `assets/model/hareket/<ad>_<hareket>.res` olarak yazar (repoya girer, küçük).
##   godot --headless --path . -s tools/model/klip_ayikla.gd
## meshy_uret.py indirdikten sonra çalıştırılır; mevcut .res dosyalarının üstüne yazar.
extends SceneTree

const KAYNAK := "res://assets/model/karakter/"
const HEDEF := "res://assets/model/hareket/"


func _init() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(HEDEF))
	var n := 0
	for dosya in DirAccess.get_files_at(KAYNAK):
		if not dosya.ends_with(".glb"):
			continue
		var kok := dosya.get_basename()
		var hareket := kok.get_slice("_", kok.get_slice_count("_") - 1)
		if not hareket in KarakterModel.HAREKETLER:
			continue
		var sahne := load(KAYNAK + dosya) as PackedScene
		if sahne == null:
			continue
		var dugum := sahne.instantiate()
		var ap := dugum.find_children("*", "AnimationPlayer", true, false)
		if not ap.is_empty() and not (ap[0] as AnimationPlayer).get_animation_list().is_empty():
			var o := ap[0] as AnimationPlayer
			var anim := o.get_animation(o.get_animation_list()[0]).duplicate() as Animation
			var err := ResourceSaver.save(anim, HEDEF + kok + ".res", ResourceSaver.FLAG_COMPRESS)
			print(kok, " → ", HEDEF + kok + ".res", "" if err == OK else " HATA %d" % err)
			n += 1
		dugum.free()
	print("ayıklanan klip: ", n)
	quit()
