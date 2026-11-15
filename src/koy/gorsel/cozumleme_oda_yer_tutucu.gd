## YAP05-ODA: izinli temel kutu ve kısa etiket; model/asset üretilmez.
extends RefCounted
static func kur(kok: Node3D, en: float, derin: float) -> void:
	var kutu := MeshInstance3D.new()
	kutu.name = "CozumlemeOdaYerTutucu"
	var mesh := BoxMesh.new()
	mesh.size = Vector3(en * 0.8,2.5,derin * 0.8)
	kutu.mesh = mesh
	kutu.position.y = 1.25
	var malzeme := StandardMaterial3D.new()
	malzeme.albedo_color = Color("7b705a")
	malzeme.roughness = 1.0
	kutu.material_override = malzeme
	kok.add_child(kutu)
	if Dunya3B.model_var_mi("cozumleme_odasi", "yapi"):
		kutu.visible = false
		var oda := Dunya3B.nesne("cozumleme_odasi", 2.8, "yapi")
		oda.name = "meshy_cozumleme_odasi"
		kok.add_child(oda)
		return
	HazirSahneModeli.etiket(kok,TranslationServer.translate("koy.yapi.cozumleme_odasi"),2.8)
