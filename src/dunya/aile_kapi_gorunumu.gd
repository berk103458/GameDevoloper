## KAP-17: refakatçiler reise bağlıdır. Portre/sınıf modeli diskte varsa o model durur;
## yoksa düz kutu yer tutucu kurulur, isim etiketi yalnız debug açılışında görünür.
extends RefCounted
static func kur(reis: Node3D, g: Gelen) -> void:
	if g.aile.size() < 2 or reis.has_node("AileRefakatcileri"): return
	var grup := Node3D.new()
	grup.name = "AileRefakatcileri"
	reis.add_child(grup)
	var kamera := reis.get_viewport().get_camera_3d() if reis.is_inside_tree() else null
	for i in range(1, g.aile.size()):
		var u: Dictionary = g.aile[i]
		var boy := 1.15 if u.get("yas_grubu") == "cocuk" else (1.65 if u.get("yas_grubu") == "yasli" else 1.8)
		var yer := Vector3((1.0 if i % 2 else -1.0) * ceilf(i / 2.0) * 0.75, 0.0, 0.6)
		var yas := String(u.get("yas_grubu", "yetiskin"))
		var model_adi := "cocuk" if yas == "cocuk" and Dunya3B.model_var_mi("cocuk_yuru", "karakter") else (
			"yasli" if yas == "yasli" and Dunya3B.model_var_mi("yasli_yuru", "karakter") else
			Dunya3B.karakter_adi(&"", String(u.get("portre", "")), StringName(u.get("sinif", "ciftci")))
		)
		if Dunya3B.model_var_mi(model_adi + "_yuru", "karakter"):
			var model := Dunya3B.karakter(model_adi)
			model.position = yer
			grup.add_child(model)
			continue
		var kisi := MeshInstance3D.new()
		var kutu := BoxMesh.new()
		kutu.size = Vector3(0.45, boy, 0.35)
		kisi.mesh = kutu
		kisi.position = yer + Vector3.UP * boy / 2.0
		grup.add_child(kisi)
		var ad := Label3D.new()
		ad.text = String(u.ad) + " · yer tutucu"
		ad.position.y = boy / 2.0 + 0.25
		ad.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		ad.font_size = 24
		ad.visible = OyuncuSurumu.debug_acik()
		kisi.add_child(ad)
		if kamera != null:
			EtiketEkranSiniri.bagla(ad, kamera)
