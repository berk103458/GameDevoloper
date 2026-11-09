## SAH-01: Gerçek sahneler ve yürüyüş klipleriyle ayak teması.
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
