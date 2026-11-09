## Gerçek sahneler ve yürüyüş klipleriyle ayak teması, eğim ve kayma.
extends Node

const MUAYENE = preload("res://tests/oto/karakter_muayene.gd")
const GOMULME_PAYI := 0.0001
const KLIP_TURU := 20


func _ready() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	get_tree().create_timer(90.0, true, false, true).timeout.connect(func() -> void: get_tree().quit(1))
	Engine.time_scale = 4.0
	var katalog := Katalog.new()
	katalog.yukle()
	var o := Oturum.new(katalog, 4401)
	var y := o.yonetim
	var meydan := y.a.meydan.position
	var yol_bas := meydan + Vector2i.UP
	var yol_son := meydan + Vector2i.UP * 3
	for i in range(1, 4):
		if not y.yol_kur(meydan + Vector2i.UP * i):
			await _bitir(false, "Bağlı üç patika hücresi kurulamadı")
			return
	var tarla := _tarla(y)
	if tarla == null:
		await _bitir(false, "Gerçek tarla kurulamadı")
		return
	var koy := KoyYonetimSahnesi.new()
	koy.yonetim = y
	add_child(koy)
	var kapi := KapiSahnesi.new()
	add_child(kapi)
	var kalas := kapi.cerceve._esik_yuzeyleri[0]
	var ust := kalas.to_global(Vector3.UP * kalas.get_aabb().end.y)
	if not is_equal_approx(kapi.ayak_zemini_yuksekligi(ust), ust.y) or ust.y <= KapiManzarasi.yukseklik(ust.x, ust.z):
		await _bitir(false, "Eşik yüksekliği gerçek kalastan okunmalı")
		return
	var egim_ornekleri := [["ciftci", PI / 2.0, 4402], ["ciftci", -PI / 2.0, 4403], ["lowpo_demirci", PI / 2.0, 4404]]
	for ornek in egim_ornekleri:
		if not await _egim(kapi, ornek[0], ornek[1], ornek[2]):
			await _bitir(false, "Eğik yolda bağımsız topuk teması")
			return
	# Kısa LOWPO temaslarını hızlandırılmış karelerde kaçırma.
	Engine.time_scale = 1.0
	var kayma_gecerli := true
	for ornek in [["ciftci", 1.35], ["lowpo_demirci", 1.35], ["chr_006", KarakterModel.YURUME_HIZI]]:
		kayma_gecerli = (await _kayma(kapi, ornek[0], ornek[1])) and kayma_gecerli
	Engine.time_scale = 4.0
	if not kayma_gecerli:
		await _bitir(false, "SAH-03: Ayak kayması")
		return
	var tarla_bas := koy.alan_merkezi(tarla.hucre, Vector2i.ONE)
	var tarla_son := koy.alan_merkezi(tarla.hucre + tarla.boyut(y.katalog) - Vector2i.ONE, Vector2i.ONE)
	if not await _yuru(koy, "tarla", "ciftci", tarla_bas, tarla_son):
		await _bitir(false, "Tarla ayak teması")
		return
	if not await _yuru(koy, "patika", "lowpo_demirci", koy.alan_merkezi(yol_bas, Vector2i.ONE), koy.alan_merkezi(yol_son, Vector2i.ONE)):
		await _bitir(false, "Patika ayak teması")
		return
	if not await _yuru(kapi, "kapı eşiği", "chr_001", KapiSahnesi.DURMA, Vector3(0, 0, 1.2)):
		await _bitir(false, "Kapı eşiği ayak teması")
		return
	koy.queue_free()
	kapi.queue_free()
	await get_tree().process_frame
	await _bitir(true, "")


func _egim(kapi: KapiSahnesi, ad: String, yon: float, tohum: int) -> bool:
	seed(tohum)
	var model := Dunya3B.karakter(ad)
	model.rotation.y = yon
	kapi.add_child(model)
	var ayak := model.get_node("AyakZemini") as AyakZemini
	for yol in [0.32, 0.4, 0.48, 0.56, 0.64, 0.72, 0.8, 0.88]:
		var nokta := KapiManzarasi.yol_noktasi(yol)
		model.position = nokta
		for _kare in 4:
			await get_tree().process_frame
		var farklar := ayak.temas_farklari()
		var topuklar := PackedVector3Array()
		var topuk_farklari := PackedFloat32Array()
		for i in farklar.size():
			var kemik := ayak._iskelet.get_bone_name(ayak._kemikler[i]).to_lower()
			if kemik.ends_with("foot"):
				topuklar.append(model.to_global(ayak._ham_tabanlar[i] + ayak._gorsel.position - ayak._taban_konum))
				topuk_farklari.append(farklar[i])
		if topuklar.size() != 2:
			push_error("SAH-02: %s için %d topuk ölçüldü" % [ad, topuklar.size()])
			break
		var zemin_farki := absf(kapi.ayak_zemini_yuksekligi(topuklar[0]) - kapi.ayak_zemini_yuksekligi(topuklar[1]))
		if zemin_farki < 0.008:
			continue
		var topuk_yuksekligi := absf(topuklar[0].y - topuklar[1].y)
		print("SAH-02 %s: yüzey farkı=%.5f m, topuk farkı=%.5f m, iki temas=%s" % [ad, zemin_farki, topuk_yuksekligi, topuk_farklari])
		var gecti := model.position.is_equal_approx(nokta) and topuk_yuksekligi > 0.005
		for fark in topuk_farklari:
			gecti = gecti and absf(fark) <= 0.003
		model.queue_free()
		return gecti
	model.queue_free()
	push_error("SAH-02: Ölçülebilir eğim veya iki topuk bulunamadı")
	return false


func _kayma(kapi: KapiSahnesi, ad: String, hiz: float) -> bool:
	const ADIM_SAYISI := 10
	const TEMAS_YUKSEKLIGI := 0.025
	var f := Dunya3B.karakter(ad)
	var hedef := KapiManzarasi.yol_noktasi(0.22)
	kapi.add_child(f)
	f.bak(hedef)
	var ayak := f.get_node("AyakZemini") as AyakZemini
	var temaslar := {}
	var tamamlanan := 0
	var azami := 0.0
	var boy_asimi := 0
	f.yuru(hedef, hiz)
	while f._yurume != null and f._yurume.is_running() and tamamlanan < ADIM_SAYISI:
		await get_tree().process_frame
		if f._oynatici.current_animation != f._anim:
			continue
		var kok := Vector2(f.global_position.x, f.global_position.z)
		var farklar := ayak.temas_farklari()
		for i in farklar.size():
			if not ayak._iskelet.get_bone_name(ayak._kemikler[i]).to_lower().ends_with("foot"):
				continue
			var topuk := f.to_global(ayak._ham_tabanlar[i] + ayak._gorsel.position - ayak._taban_konum)
			var iskelet := Vector2(topuk.x, topuk.z) - kok
			if farklar[i] <= TEMAS_YUKSEKLIGI:
				if not temaslar.has(i):
					temaslar[i] = {"kok": kok, "iskelet": iskelet, "kok_boyu": 0.0, "adim_boyu": 0.0, "kayma": 0.0}
				var d: Dictionary = temaslar[i]
				var kok_adimi: Vector2 = kok - d.kok
				var iskelet_adimi: Vector2 = iskelet - d.iskelet
				d.kok_boyu = maxf(d.kok_boyu, kok_adimi.length())
				d.adim_boyu = maxf(d.adim_boyu, maxf(kok_adimi.length(), iskelet_adimi.length()))
				d.kayma = maxf(d.kayma, (kok_adimi + iskelet_adimi).length())
			elif temaslar.has(i):
				var d: Dictionary = temaslar[i]
				temaslar.erase(i)
				if float(d.kok_boyu) < 0.05:
					continue
				tamamlanan += 1
				azami = maxf(azami, d.kayma)
				if float(d.kayma) > float(d.adim_boyu) + 0.001:
					boy_asimi += 1
				if tamamlanan == ADIM_SAYISI:
					break
	f.yurumeyi_durdur()
	f.queue_free()
	print("SAH-03 %s: adım=%d, azami kayma=%.4f m, eşik=%.2f m, adım boyu aşımı=%d" % [ad, tamamlanan, azami, ayak.kayma_esigi, boy_asimi])
	return tamamlanan == ADIM_SAYISI and azami <= ayak.kayma_esigi and boy_asimi == 0


func _tarla(y: KoyYonetimi) -> KoyBinasi:
	y.kaynaklar.ekle("odun", 20)
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if not y.yerlesim("tarla", h).olur:
				continue
			var b := y.bina(y.bina_kur("tarla", h).id)
			if b != null:
				b.insa_kalan = 0
				return b
	return null


func _yuru(sahne: Node3D, zemin: String, ad: String, bas: Vector3, son: Vector3) -> bool:
	var f := Dunya3B.karakter(ad)
	f.position = bas
	sahne.add_child(f)
	var ayak := f.get_node_or_null("AyakZemini")
	if ayak == null or f._oynatici == null or not ayak.has_method("temas_farklari"):
		f.queue_free()
		push_error("SAH-01: %s gerçek ayak ölçer bağlanmamış" % zemin)
		return false
	var dusuk_kok := bas - Vector3.UP * 0.08
	f.position = dusuk_kok
	await get_tree().process_frame
	await get_tree().process_frame
	var duzeltilen := MUAYENE.ayak_zemin_farklari(f)
	if duzeltilen.size() < 2 or float(Array(duzeltilen).min()) < -GOMULME_PAYI or not f.position.is_equal_approx(dusuk_kok):
		f.queue_free()
		push_error("SAH-01: Gömülü görsel yükselmeli ve hareket kökü sabit kalmalı")
		return false
	f.position = bas
	var klip := f._oynatici
	var tur := 0
	var kare := 0
	var en_alt := INF
	var gomulen := 0
	for gidis in range(KLIP_TURU):
		f.yuru(son if gidis % 2 == 0 else bas, 1.35)
		var once := -1.0
		while f._yurume != null and f._yurume.is_running():
			await get_tree().process_frame
			if klip.current_animation != f._anim:
				continue
			var konum := klip.current_animation_position
			if once >= 0.0 and konum + 0.001 < once:
				tur += 1
			once = konum
			var farklar := MUAYENE.ayak_zemin_farklari(f)
			if farklar.size() < 2:
				f.queue_free()
				push_error("SAH-01: Yürüyüş sırasında ayak ölçümü eksik")
				return false
			var kare_alt := float(Array(farklar).min())
			en_alt = minf(en_alt, kare_alt)
			if kare_alt < -GOMULME_PAYI:
				gomulen += 1
			kare += 1
		if tur >= KLIP_TURU:
			break
	print("SAH-01 %s: klip turu=%d, kare=%d, gömülme=%d, en alt zemin farkı=%.5f m" % [zemin, tur, kare, gomulen, en_alt])
	f.queue_free()
	return tur >= KLIP_TURU and kare > tur and gomulen == 0


func _bitir(gecti: bool, neden: String) -> void:
	Engine.time_scale = 1.0
	if gecti:
		print("AYAK ZEMİNİ: GEÇTİ")
	else:
		push_error("SAH-01: " + neden)
	await Ses.cik(0 if gecti else 1)
