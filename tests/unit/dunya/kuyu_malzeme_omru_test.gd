## BUG-25 takip: yenilemede aynı malzeme; memory_free sonrası aktif sahne korunur.
extends SceneTree
var hata := 0
func _initialize() -> void:
	call_deferred("_kos")
func _kos() -> void:
	var ilk := KapiKuyuAyari.kuyu()
	root.add_child(ilk)
	var mat := ilk.find_children("*", "MeshInstance3D", true, false)[0].material_override as Material
	var farkli := {}
	for i in 200:
		var n := KapiKuyuAyari.kuyu()
		root.add_child(n)
		var m := n.find_children("*", "MeshInstance3D", true, false)[0].material_override as Material
		farkli[m.get_instance_id()] = true
		n.queue_free()
		if i % 10 == 0: await process_frame
	print("200 yenilemede ayrı malzeme sayısı: ", farkli.size())
	dene(farkli.size() == 1 and farkli.has(mat.get_instance_id()), "Kuyu yenilemeleri mevcut cachete aynı malzemeyi paylaşır")
	var temiz := DusukBellekProfili.memory_free()
	dene(temiz.size() == 5 and Pbr._onbellek.is_empty(), "Mevcut beş cache temizliği yeni cache bırakmaz")
	dene(is_instance_valid(mat) and ilk.find_children("*", "MeshInstance3D", true, false)[0].material_override == mat, "Aktif kuyunun malzemesi memory_free sonrası korunur")
	var son := KapiKuyuAyari.kuyu()
	root.add_child(son)
	var yeni := son.find_children("*", "MeshInstance3D", true, false)[0].material_override as Material
	dene(yeni != mat and is_instance_valid(yeni), "Cache temizlenince yeni kuyu güvenle yeni malzeme alır")
	ilk.queue_free()
	son.queue_free()
	await process_frame
	print("KUYU MALZEME ÖMRÜ: GEÇTİ" if hata == 0 else "KUYU MALZEME ÖMRÜ: KALDI")
	quit(hata)
func dene(ok: bool, ad: String) -> void:
	if not ok:
		hata += 1
		push_error(ad)
