## BUG-0021 kabulü: yapı/nesne modelleri dokusunu kendi `.glb`si içinde taşır; temiz klonda da yüklenir.
##   godot --headless --path . -s tests/unit/dunya/model_doku_test.gd
extends SceneTree

const MODELLER := [
	"res://assets/model/nesne/okuz.glb",
	"res://assets/model/yapi/cadir.glb",
	"res://assets/model/yapi/ev.glb",
	"res://assets/model/yapi/kapi.glb",
	"res://assets/model/yapi/kervansaray.glb",
	"res://assets/model/yapi/pazar_tezgahi.glb",
]
var hata := 0


func _initialize() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	create_timer(120.0).timeout.connect(func() -> void: quit(1))
	for yol in MODELLER:
		var ad: String = yol.get_file()
		var sahne: PackedScene = load(yol)
		_kontrol(sahne != null, "%s yüklendi" % ad)
		if sahne == null:
			continue
		var kok := sahne.instantiate()
		_kontrol(kok != null, "%s örneklenebildi" % ad)
		if kok == null:
			continue
		var mesh := _ilk_mesh(kok)
		_kontrol(mesh != null, "%s mesh içeriyor" % ad)
		if mesh != null:
			var mat: Material = mesh.get_active_material(0)
			var doku: Texture2D = null
			if mat is StandardMaterial3D:
				doku = (mat as StandardMaterial3D).albedo_texture
			_kontrol(doku != null, "%s dokusu var (dış .jpg'ye bağlı değil)" % ad)
			if doku != null:
				_kontrol(doku.get_width() == 2048 and doku.get_height() == 2048, "%s dokusu 2048x2048" % ad)
		kok.free()
	await process_frame
	print("MODEL DOKU: " + ("GEÇTİ" if hata == 0 else "KALDI (%d)" % hata))
	quit(1 if hata else 0)


func _ilk_mesh(kok: Node) -> MeshInstance3D:
	if kok is MeshInstance3D and (kok as MeshInstance3D).mesh != null:
		return kok
	for c in kok.get_children():
		var bulunan := _ilk_mesh(c)
		if bulunan != null:
			return bulunan
	return null


func _kontrol(kosul: bool, ad: String) -> void:
	if not kosul:
		hata += 1
		push_error("  HATA " + ad)
	else:
		print("  ok   " + ad)
