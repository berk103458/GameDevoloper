## SAH-09: Oyundaki model ve soketlerle göğüs/uyluk kesişimini ölçer.
extends SceneTree

const ESYALAR := {
	"chr_001": ["odun"],
	"chr_002": ["torba"],
	"chr_003": ["sepet", "cekic"],
	"chr_005": ["heybe"],
	"chr_006": ["sepet_buyuk"],
	"chr_007": ["sandik"],
	"chr_008": ["asa"],
}
const KEMIKLER := ["Spine", "Spine01", "Spine02", "LeftLeg", "RightLeg"]

var _kareler := {}
var _kesisen := {}
var _soket_farki := {}


func _initialize() -> void:
	_calistir.call_deferred()


func _calistir() -> void:
	seed(909)
	var figurlar: Array[KarakterModel] = []
	for ad in ESYALAR:
		var figur := Dunya3B.karakter(ad)
		figur.position.x = figurlar.size() * 4.0
		root.add_child(figur)
		figurlar.append(figur)
		var iskelet := figur.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
		iskelet.skeleton_updated.connect(_olc.bind(figur, iskelet, ESYALAR[ad]))
	await create_timer(0.5).timeout
	for figur in figurlar:
		figur.yuru(figur.position + Vector3(0, 0, 2.7), 1.35)
	await create_timer(2.1).timeout
	var gecti := _kareler.size() == 8
	for tur in _kareler:
		var kare: int = _kareler[tur]
		var kesisen: int = _kesisen.get(tur, 0)
		var fark: float = _soket_farki.get(tur, INF)
		print("SAH-09 %s: kare=%d, kesişen=%d, soket farkı=%.5f m" % [tur, kare, kesisen, fark])
		gecti = gecti and kare >= 60 and kesisen == 0 and fark <= 0.001
	for figur in figurlar:
		figur.free()
	gecti = (await _yuruyus_soketi()) and gecti
	print("EL EŞYASI TEMASI: GEÇTİ" if gecti else "EL EŞYASI TEMASI: KALDI")
	await root.get_node("Ses").cik(0 if gecti else 1)


func _olc(figur: KarakterModel, iskelet: Skeleton3D, turler: Array) -> void:
	var kesitler := PackedVector3Array()
	for ad in KEMIKLER:
		var id := iskelet.find_bone(ad)
		if id < 0:
			continue
		var ebeveyn := iskelet.get_bone_parent(id)
		if ebeveyn >= 0:
			kesitler.append(iskelet.to_global(iskelet.get_bone_global_pose(ebeveyn).origin))
			kesitler.append(iskelet.to_global(iskelet.get_bone_global_pose(id).origin))
	if kesitler.is_empty():
		return
	for tur in turler:
		var esya := figur.get_node_or_null("esya_" + tur) as ElEsyasi
		if esya == null or esya._el < 0:
			continue
		var nokta := _avuc_noktasi(figur, iskelet, esya)
		_soket_farki[tur] = maxf(float(_soket_farki.get(tur, 0.0)), nokta.distance_to(esya.global_position))
		_kareler[tur] = int(_kareler.get(tur, 0)) + 1
		if _kemige_deger(esya, kesitler):
			_kesisen[tur] = int(_kesisen.get(tur, 0)) + 1


func _avuc_noktasi(figur: KarakterModel, iskelet: Skeleton3D, esya: ElEsyasi) -> Vector3:
	var poz := iskelet.get_bone_global_pose(esya._el)
	var nokta := iskelet.to_global(poz.origin)
	var avuc: Variant = figur.duzeltici().avuc(iskelet.get_bone_name(esya._el))
	if avuc != null:
		nokta = iskelet.to_global(poz * (avuc as Vector3))
	elif esya._onkol >= 0:
		var dirsek := iskelet.to_global(iskelet.get_bone_global_pose(esya._onkol).origin)
		nokta += (nokta - dirsek).normalized() * ElEsyasi.AVUC
	return nokta


func _yuruyus_soketi() -> bool:
	const ADIM_SAYISI := 20
	var kapi := KapiSahnesi.new()
	root.add_child(kapi)
	var figur := Dunya3B.karakter("chr_001")
	kapi.add_child(figur)
	var hedef := Vector3(0.0, 0.0, -35.0)
	figur.bak(hedef)
	var ayak := figur.get_node("AyakZemini") as AyakZemini
	var iskelet := ayak._iskelet
	var esya := figur.get_node("esya_odun") as ElEsyasi
	var son_poz := {}
	iskelet.skeleton_updated.connect(func() -> void:
		son_poz["avuc"] = iskelet.to_local(_avuc_noktasi(figur, iskelet, esya))
	)
	await process_frame
	var onceki_kok := figur.global_position
	var onceki_hiz := 0.0
	var hizlanma := 0
	var adim := 0
	var azami_fark := 0.0
	var temaslar := {}
	var son_temasta_kok := {}
	var hizlandi := false
	figur.yuru(hedef, 1.35)
	while figur._yurume.is_running() and adim < ADIM_SAYISI:
		await process_frame
		var kok := figur.global_position
		var hiz := kok.distance_to(onceki_kok) / figur.get_process_delta_time()
		onceki_kok = kok
		if hiz > onceki_hiz + 0.5:
			hizlanma += 1
		onceki_hiz = hiz
		if hiz < 0.1 or not son_poz.has("avuc"):
			continue
		# Kök, iskeletin son yaydığı pozdan sonra ilerlese de el eşyası aynı noktayı izler.
		var avuc := iskelet.to_global(son_poz["avuc"])
		azami_fark = maxf(azami_fark, avuc.distance_to(esya.global_position))
		var farklar := ayak.temas_farklari()
		for i in farklar.size():
			if not iskelet.get_bone_name(ayak._kemikler[i]).to_lower().ends_with("foot"):
				continue
			var temas := farklar[i] <= 0.025
			var onceki_temas_koku: Vector3 = son_temasta_kok.get(i, Vector3.INF)
			if temas and not temaslar.get(i, true) and kok.distance_to(onceki_temas_koku) > 0.12:
				adim += 1
				son_temasta_kok[i] = kok
			temaslar[i] = temas
			if adim >= ADIM_SAYISI:
				break
		if adim >= 4 and not hizlandi:
			hizlandi = true
			figur.yuru(hedef, 2.5)
	print("SAH-10: gerçek adım=%d, hızlanma=%d, azami avuç farkı=%.5f m" % [adim, hizlanma, azami_fark])
	kapi.free()
	return adim == ADIM_SAYISI and hizlanma >= 2 and ElEsyasi.gecikme_uygun_mu(azami_fark)


func _kemige_deger(esya: ElEsyasi, kesitler: PackedVector3Array) -> bool:
	for dugum in esya.find_children("*", "MeshInstance3D", true, false):
		var parca := dugum as MeshInstance3D
		var kutu := parca.get_aabb()
		for i in range(0, kesitler.size(), 2):
			if kutu.intersects_segment(parca.to_local(kesitler[i]), parca.to_local(kesitler[i + 1])) != null:
				return true
	return false
