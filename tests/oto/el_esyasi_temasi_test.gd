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
	for tur in ["cuval", "asa"]:
		gecti = (await _diz_cokme(tur)) and gecti
	var ciftler := [
		["chr_005", "heybe", "kazma"], ["chr_003", "cekic", "sepet"],
		["chr_004", "kamci", "kurk"], ["chr_013", "degnek", "testi"],
		["chr_018", "capa", "kabak"], ["chr_019", "kazma", "cubuk"],
		["chr_025", "kova", "kova"], ["chr_030", "kile", "torba"],
	]
	for ornek in ciftler:
		gecti = (await _cift_soket(ornek[0], ornek[1], ornek[2])) and gecti
	gecti = (await _konusma_soketi("chr_005", "heybe", true)) and gecti
	gecti = (await _konusma_soketi("ciftci", "odun", false)) and gecti
	gecti = (await _kapi_koy_yuku()) and gecti
	gecti = (await _cocuk_yuku()) and gecti
	print("EL EŞYASI TEMASI: GEÇTİ" if gecti else "EL EŞYASI TEMASI: KALDI")
	await root.get_node("Ses").cik(0 if gecti else 1)


func _olc(figur: KarakterModel, iskelet: Skeleton3D, turler: Array) -> void:
	var kesitler := _kemik_kesitleri(iskelet)
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


func _diz_cokme(tur: String) -> bool:
	var kapi := KapiSahnesi.new()
	root.add_child(kapi)
	var figur := Dunya3B.karakter("chr_002")
	figur.position = KapiSahnesi.DURMA
	kapi.add_child(figur)
	figur.bak(kapi.kamera.position)
	figur.get_node("esya_torba").hide()
	var ayak := figur.get_node("AyakZemini") as AyakZemini
	var esya := ElEsyasi.olustur(tur)
	figur.add_child(esya)
	esya.bagla(figur, ayak._iskelet, true, figur.duzeltici())
	var parcalar := esya.find_children("*", "MeshInstance3D", true, false)
	await process_frame
	kapi._gelen = figur
	kapi.gelen_git(false, false)
	var kare := 0
	var gomulen := 0
	var en_alt := INF
	var diklik := 1.0
	var avuc_farki := 0.0
	var son_avuc := {}
	ayak._iskelet.skeleton_updated.connect(func() -> void:
		son_avuc["yerel"] = ayak._iskelet.to_local(_avuc_noktasi(figur, ayak._iskelet, esya))
	)
	while figur._yurume == null:
		await process_frame
		if figur._yurume != null:
			break
		if figur._oynatici.current_animation != figur._klipler.get("panik"):
			continue
		var alt := INF
		for dugum in parcalar:
			var parca := dugum as MeshInstance3D
			for i in 8:
				var nokta := parca.to_global(parca.get_aabb().get_endpoint(i))
				alt = minf(alt, nokta.y - kapi.ayak_zemini_yuksekligi(nokta))
		if alt < -0.0001:
			gomulen += 1
		en_alt = minf(en_alt, alt)
		diklik = minf(diklik, esya.global_basis.y.normalized().dot(Vector3.UP))
		if son_avuc.has("yerel"):
			avuc_farki = maxf(avuc_farki, esya.global_position.distance_to(ayak._iskelet.to_global(son_avuc.yerel)))
		kare += 1
	print("SAH-11 %s: kare=%d, gömülen=%d, en alt=%.5f m, diklik=%.5f, avuç farkı=%.5f m" % [tur, kare, gomulen, en_alt, diklik, avuc_farki])
	kapi.free()
	return kare >= 30 and gomulen == 0 and avuc_farki <= 0.001 and (tur != "asa" or diklik >= 0.9999)


func _kemik_kesitleri(iskelet: Skeleton3D) -> PackedVector3Array:
	var kesitler := PackedVector3Array()
	for ad in KEMIKLER:
		var id := iskelet.find_bone(ad)
		if id < 0:
			continue
		var ebeveyn := iskelet.get_bone_parent(id)
		if ebeveyn >= 0:
			kesitler.append(iskelet.to_global(iskelet.get_bone_global_pose(ebeveyn).origin))
			kesitler.append(iskelet.to_global(iskelet.get_bone_global_pose(id).origin))
	return kesitler


func _cift_soket(ad: String, sag_tur: String, sol_tur: String) -> bool:
	var kapi := KapiSahnesi.new()
	root.add_child(kapi)
	var figur := Dunya3B.karakter(ad)
	kapi.add_child(figur)
	var iskelet := (figur.get_node("AyakZemini") as AyakZemini)._iskelet
	var sag: ElEsyasi
	var sol: ElEsyasi
	for cocuk in figur.get_children():
		if not cocuk is ElEsyasi:
			continue
		if cocuk._el == iskelet.find_bone("RightHand"):
			sag = cocuk
		elif cocuk._el == iskelet.find_bone("LeftHand"):
			sol = cocuk
	if sol == null:
		sol = ElEsyasi.olustur(sol_tur)
		figur.add_child(sol)
		sol.bagla(figur, iskelet, false, figur.duzeltici())
	if sag == null:
		kapi.free()
		return false
	var sag_parcalar := sag.find_children("*", "MeshInstance3D", true, false)
	var sol_parcalar := sol.find_children("*", "MeshInstance3D", true, false)
	var sonuc := {"kare": 0, "esya": 0, "govde": 0, "avuc": 0.0}
	iskelet.skeleton_updated.connect(func() -> void:
		var kesitler := _kemik_kesitleri(iskelet)
		sonuc.kare += 1
		if _kemige_deger(sag, kesitler) or _kemige_deger(sol, kesitler):
			sonuc.govde += 1
		if _esya_kutulari_kesisir(sag_parcalar, sol_parcalar):
			sonuc.esya += 1
		for esya in [sag, sol]:
			var avuc := _avuc_noktasi(figur, iskelet, esya)
			sonuc.avuc = maxf(sonuc.avuc, avuc.distance_to(esya.global_position))
	)
	await create_timer(0.5).timeout
	await figur.yuru(Vector3(0.0, 0.0, -3.0), 1.35)
	await figur.konus(1.0)
	var iki_el := sag._el == iskelet.find_bone("RightHand") and sol._el == iskelet.find_bone("LeftHand")
	print("SAH-12 %s/%s: kare=%d, eşya=%d, gövde=%d, avuç=%.5f m" % [
		sag_tur, sol_tur, sonuc.kare, sonuc.esya, sonuc.govde, sonuc.avuc])
	kapi.free()
	return iki_el and not sag_parcalar.is_empty() and not sol_parcalar.is_empty() and sonuc.kare >= 120 and sonuc.esya == 0 and sonuc.govde == 0 and sonuc.avuc <= 0.001


func _konusma_soketi(ad: String, tur: String, klip_var: bool) -> bool:
	const SURE := 3.0
	var kapi := KapiSahnesi.new()
	root.add_child(kapi)
	var figur := Dunya3B.karakter(ad)
	figur.position = KapiSahnesi.DURMA
	kapi.add_child(figur)
	figur.bak(kapi.kamera.position)
	var iskelet := (figur.get_node("AyakZemini") as AyakZemini)._iskelet
	var esya := figur.get_node_or_null("esya_" + tur) as ElEsyasi
	if esya == null:
		esya = ElEsyasi.olustur(tur)
		figur.add_child(esya)
		esya.bagla(figur, iskelet, true, figur.duzeltici())
	var olcum := {"kare": 0, "ayrilan": 0, "fark": 0.0}
	iskelet.skeleton_updated.connect(func() -> void:
		var avuc := _avuc_noktasi(figur, iskelet, esya)
		olcum.kare += 1
		olcum.fark = maxf(olcum.fark, avuc.distance_to(esya.global_position))
		if not esya.soket_dolu_mu() or not esya.visible or esya.get_parent() != figur:
			olcum.ayrilan += 1
	)
	figur.dur()
	await process_frame
	var bekle := String(figur._oynatici.current_animation)
	var beklenen: String = String(figur._klipler.get("konus", "")) if klip_var else bekle
	var gecti: bool = figur.hareket_var("konus") == klip_var and not beklenen.is_empty()
	gecti = gecti and (klip_var or bekle != figur._anim)
	kapi._gelen = figur
	kapi.gelen_konus(SURE)
	var zamanlayici := create_timer(SURE)
	var beklenen_sure := 0.0
	while zamanlayici.time_left > 0.0:
		await process_frame
		if figur._oynatici.current_animation == beklenen:
			beklenen_sure += figur.get_process_delta_time()
	await process_frame
	gecti = gecti and figur._oynatici.current_animation == bekle and figur.get_node_or_null("esya_" + tur) == esya
	gecti = gecti and beklenen_sure >= SURE - 0.02 and olcum.kare >= 120
	gecti = gecti and olcum.ayrilan == 0 and olcum.fark <= 0.001
	print("SAH-13 %s/%s: %.3f s, kare=%d, ayrılan=%d, avuç farkı=%.5f m" % [
		ad, beklenen, beklenen_sure, olcum.kare, olcum.ayrilan, olcum.fark])
	kapi.free()
	return gecti


func _kapi_koy_yuku() -> bool:
	var katalog := Katalog.new()
	katalog.yukle()
	var oturum := Oturum.new(katalog, 914)
	var gelen := oturum._adli_gelen(&"chr_005")
	var kapi := KapiSahnesi.new()
	root.add_child(kapi)
	var ad := Dunya3B.karakter_adi(gelen.id, gelen.portre, gelen.sinif)
	kapi.kuyruk_doldur([ad])
	await kapi.gelen_yaklas(ad)
	var kapida := _yuk_soketi(kapi._gelen, "heybe")
	var karar := oturum.karar_ver(gelen, &"kabul")
	var kimlik := int(karar.get("koylu_id", -1))
	var koylu := oturum.yonetim.koylu(kimlik)
	if not karar.get("kaldi", false) or koylu == null:
		push_error("SAH-14: Gerçek kabul köylü üretmedi")
		kapi.free()
		return false
	var koy := KoyYonetimSahnesi.new()
	koy.yonetim = oturum.yonetim
	root.add_child(koy)
	var halk := koy.halk_hareketi
	halk.set_process(false)
	var koyde := _yuk_soketi(halk.modeller[kimlik], "heybe")
	# Eski kayıttaki yaş alanı görünümü değiştirir, taşıdığı eşya kaynağını değiştirmez.
	var kayit := koylu.kaydet()
	kayit["yas_grubu"] = "cocuk"
	var yuklenen := Koylu.kayittan(kayit)
	oturum.yonetim.koylular[oturum.yonetim.koylular.find(koylu)] = yuklenen
	var once := JSON.stringify(oturum.yonetim.kaydet())
	halk.yenile()
	var degisen: KarakterModel = halk.modeller[kimlik]
	var degisince := _yuk_soketi(degisen, "heybe")
	var model := String(degisen.get_meta("model_adi"))
	koy.free()
	var yeniden := KoyYonetimSahnesi.new()
	yeniden.yonetim = oturum.yonetim
	root.add_child(yeniden)
	var yeniden_figur: KarakterModel = yeniden.halk_hareketi.modeller[kimlik]
	var yeniden_soket := _yuk_soketi(yeniden_figur, "heybe")
	var ayni_kayit := JSON.stringify(oturum.yonetim.kaydet()) == once
	print("SAH-14 heybe: kapı=%s, köy=%s, %s dönüşümü=%s, yeniden kurulum=%s" % [
		kapida, koyde, model, degisince, yeniden_soket])
	kapi.free()
	yeniden.free()
	return kapida == "RightHand" and koyde == kapida and degisince == kapida and yeniden_soket == kapida and model in ["cocuk", "lowpo_cocuk"] and ayni_kayit


func _yuk_soketi(figur: KarakterModel, tur: String) -> String:
	var esya := figur.get_node_or_null("esya_" + tur) as ElEsyasi
	if esya == null or not esya.soket_dolu_mu() or esya._el < 0:
		return ""
	return esya._iskelet.get_bone_name(esya._el)


func _cocuk_yuku() -> bool:
	var yetiskin := Dunya3B.karakter("lowpo_demirci")
	var cocuk := Dunya3B.karakter("chr_006")
	yetiskin.position.x = -3.0
	cocuk.position.x = 3.0
	root.add_child(yetiskin)
	root.add_child(cocuk)
	var yetiskin_iskelet := yetiskin.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var yetiskin_yuku := ElEsyasi.olustur("sepet_buyuk")
	yetiskin.add_child(yetiskin_yuku)
	yetiskin_yuku.bagla(yetiskin, yetiskin_iskelet, true, yetiskin.duzeltici())
	var cocuk_yuku := cocuk.get_node("esya_sepet_buyuk") as ElEsyasi
	var cocuk_iskelet := cocuk_yuku._iskelet
	var yetiskin_boyu := Dunya3B.boyut(yetiskin.get_child(0)).y
	var cocuk_boyu := Dunya3B.boyut(cocuk.get_child(0)).y
	var oran := cocuk_boyu / yetiskin_boyu
	var kutu := Dunya3B.boyut(yetiskin_yuku)
	var cocuk_kutu := Dunya3B.boyut(cocuk_yuku)
	var olcum := {"fark": 0.0}
	cocuk_iskelet.skeleton_updated.connect(func() -> void:
		var avuc := _avuc_noktasi(cocuk, cocuk_iskelet, cocuk_yuku)
		olcum.fark = maxf(olcum.fark, avuc.distance_to(cocuk_yuku.global_position))
	)
	var en_az := INF
	var en_cok := 0.0
	for i in 180:
		if i == 30:
			yetiskin.yuru(yetiskin.position + Vector3(0.0, 0.0, 2.5), 1.35)
			cocuk.yuru(cocuk.position + Vector3(0.0, 0.0, 2.5), 1.35)
		await process_frame
		var yuk_orani := cocuk_kutu.y * cocuk_yuku.global_basis.y.length() / (kutu.y * yetiskin_yuku.global_basis.y.length())
		en_az = minf(en_az, yuk_orani)
		en_cok = maxf(en_cok, yuk_orani)
	print("SAH-15 sepet: model=%.5f, yük=%.5f..%.5f, avuç farkı=%.5f m" % [oran, en_az, en_cok, olcum.fark])
	yetiskin.free()
	cocuk.free()
	return oran > 0.5 and oran < 0.8 and absf(en_az - oran) <= 0.001 and absf(en_cok - oran) <= 0.001 and olcum.fark <= 0.001


func _esya_kutulari_kesisir(sag: Array, sol: Array) -> bool:
	for a: MeshInstance3D in sag:
		var a_kutu := a.global_transform * a.get_aabb()
		for b: MeshInstance3D in sol:
			if a_kutu.intersects(b.global_transform * b.get_aabb()):
				return true
	return false


func _kemige_deger(esya: ElEsyasi, kesitler: PackedVector3Array) -> bool:
	for dugum in esya.find_children("*", "MeshInstance3D", true, false):
		var parca := dugum as MeshInstance3D
		var kutu := parca.get_aabb()
		for i in range(0, kesitler.size(), 2):
			var bas := parca.to_local(kesitler[i])
			var son := parca.to_local(kesitler[i + 1])
			if kutu.intersects_segment(bas, son) == null:
				continue
			if parca.mesh is ArrayMesh and not (kutu.has_point(bas) and kutu.has_point(son)):
				var yuzey := parca.mesh.generate_triangle_mesh()
				if yuzey != null and yuzey.intersect_segment(bas, son).is_empty():
					continue
			return true
	return false
