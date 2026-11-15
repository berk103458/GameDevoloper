## Meshy'den gelen GLB'lerin Godot'ta gerçekten yüklendiğini ve ölçülerini doğrular (Meshy hattı, yerleştirme adımı).
##   godot --headless --path . -s tools/meshy/godot_dogrula.gd -- res://assets/model/nesne/kuyu.glb ...
## Önce `godot --headless --path . --import` çalışmış olmalı. Her dosya için tek satır JSON yazar; yüklenemeyen
## dosya varsa çıkış kodu 1 olur.
extends SceneTree


func _init() -> void:
	var hata := 0
	for yol in OS.get_cmdline_user_args():
		var sonuc := _incele(yol)
		if not sonuc.get("yuklendi", false):
			hata += 1
		print(JSON.stringify(sonuc))
	quit(1 if hata > 0 else 0)


func _incele(yol: String) -> Dictionary:
	var sonuc := {"dosya": yol, "yuklendi": false}
	var sahne := load(yol) as PackedScene
	if sahne == null:
		return sonuc
	var kok := sahne.instantiate()
	sonuc["yuklendi"] = true
	var kutu := AABB()
	var ilk := true
	var ucgen := 0
	for m in kok.find_children("*", "MeshInstance3D", true, false):
		var mi := m as MeshInstance3D
		if mi.mesh == null:
			continue
		# Deri bağlı mesh'in köşeleri bağlama pozunda dünya ölçüsündedir; düğüm dönüşümü (Meshy iskeletinde 0.01) uygulanmaz.
		var aabb := mi.get_aabb() if mi.skin != null else _kok_uzayi(mi, kok) * mi.get_aabb()
		kutu = aabb if ilk else kutu.merge(aabb)
		ilk = false
		for y in mi.mesh.get_surface_count():
			var dizi := mi.mesh.surface_get_arrays(y)
			var indeks: Variant = dizi[Mesh.ARRAY_INDEX]
			ucgen += (indeks.size() if indeks != null else dizi[Mesh.ARRAY_VERTEX].size()) / 3
	var iskeletler := kok.find_children("*", "Skeleton3D", true, false)
	var oynaticilar := kok.find_children("*", "AnimationPlayer", true, false)
	sonuc["ucgen"] = ucgen
	sonuc["boyut_m"] = [snappedf(kutu.size.x, 0.001), snappedf(kutu.size.y, 0.001), snappedf(kutu.size.z, 0.001)]
	sonuc["taban_y"] = snappedf(kutu.position.y, 0.001)
	sonuc["kemik"] = (iskeletler[0] as Skeleton3D).get_bone_count() if not iskeletler.is_empty() else 0
	sonuc["animasyonlar"] = Array((oynaticilar[0] as AnimationPlayer).get_animation_list()) if not oynaticilar.is_empty() else []
	kok.free()
	return sonuc


func _kok_uzayi(dugum: Node3D, kok: Node) -> Transform3D:
	var t := Transform3D.IDENTITY
	var n: Node = dugum
	while n != null and n != kok:
		if n is Node3D:
			t = (n as Node3D).transform * t
		n = n.get_parent()
	return t
