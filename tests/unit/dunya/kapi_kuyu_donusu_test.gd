extends SceneTree
var hata := 0
func _initialize() -> void:
	call_deferred("_kos")
func _kos() -> void:
	for seviye in 4:
		var c := KapiCercevesi.new()
		c.seviye = seviye
		root.add_child(c)
		c.position = Vector3(3, 0, -2)
		c.rotation.y = 0.4
		dene(c.isiklar.size() == 2, "Her sur seviyesinde iki meşale")
		for l in c.isiklar:
			var a: Node3D = l.get_meta("alev")
			var soket: Marker3D = l.get_meta("alev_soketi")
			dene(l.global_position.is_equal_approx(a.global_position) and soket.global_position.is_equal_approx(a.global_position), "Dünya dönüşünde ışık/alev/soket aynı")
			var once := soket.global_position
			l.visible = false
			a.visible = false
			dene(soket.global_position.is_equal_approx(once) and l.global_position.is_equal_approx(once), "Efekt ve ışık kapalıyken soket kaymaz")
			dene(is_equal_approx(l.light_energy, 1.9) and l.shadow_enabled and is_equal_approx(l.omni_range, 9.0), "Işık profili korunur")
		c.free()
	var kuyu := KapiKuyuAyari.kuyu()
	var k := Dunya3B.karakter("ciftci")
	root.add_child(k)
	await process_frame
	var sk := k.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var bas := sk.global_transform * sk.get_bone_global_rest(sk.find_bone("Head")).origin
	var kutu := Dunya3B._kutu(kuyu)
	print("Kuyu taban/tepe: ", kutu.position.y, " / ", kutu.end.y, "; gerçek köylü başı: ", bas.y)
	dene(is_zero_approx(kutu.position.y) and kutu.end.y < bas.y, "Kuyu zeminde ve gerçek köylünün başından alçak")
	for mi in kuyu.find_children("*", "MeshInstance3D", true, false):
		dene((mi.material_override as StandardMaterial3D).albedo_color.is_equal_approx(Color("#827d70")), "Mevcut kuyu malzemesi nötr taş renginde")
	var kaya := Dunya3B.nesne("kaya", 0.5)
	for mi in kaya.find_children("*", "MeshInstance3D", true, false):
		dene((mi.material_override as StandardMaterial3D).albedo_color.is_equal_approx(Renkler.SOGUK_MAVI), "Diğer nesnelerin mevcut paleti korunur")
	kaya.free()
	dene(Dunya3B.model_var_mi("kuyu"), "Mevcut kuyu modeli kullanılır; yeni asset gerekmedi")
	kuyu.free()
	k.free()
	await process_frame
	print("KAPI KUYU: GEÇTİ" if hata == 0 else "KAPI KUYU: KALDI")
	quit(hata)
func dene(ok: bool, ad: String) -> void:
	if not ok:
		hata += 1
		push_error(ad)
