## SAH-34: Sekiz gerçek muhafız tek kapının çevresinde ayrı hücrelere varır.
extends Node

var hata := 0


func _ready() -> void:
	_calistir.call_deferred()


func _calistir() -> void:
	var katalog := Katalog.new()
	katalog.yukle()
	var oturum := Oturum.new(katalog, 76)
	var y := oturum.yonetim
	var ids: Array[int] = []
	for i in 8:
		var kisi := y.kabul({"sinif": "asker", "stat": 5})
		kisi.is_yeri = KoyYonetimi.MUHAFIZ
		ids.append(kisi.id)
	var once := JSON.stringify(y.kaydet())
	var s := KoyYonetimSahnesi.new()
	s.yonetim = y
	add_child(s)
	var h := s.halk_hareketi
	h.set_process(false)
	var n := h.get_node("zemin_navigasyonu") as KoyZeminNavigasyonu
	for i in 120:
		if n.hazir():
			break
		await get_tree().physics_frame
	_kontrol(n.hazir(), "SAH-34: Gerçek ANI-13 ağı hazır")
	var kapi := KapiNobeti.esik_hucresi(y)
	_tek_esigi_dene(h, ids, kapi)
	h._bekleyen.clear()
	for i in ids.size():
		var id := ids[i]
		var f: KarakterModel = h.modeller[id]
		var bas := kapi + Vector2i(i % 4 - 2, -3 - i / 4)
		_kontrol(h.rotaci.gecilir(bas), "SAH-34: Başlangıç hücresi açık")
		f.position = h._konum(bas)
		h._durum[id].devriye_i = 0
		h._iste(id)
	for i in ids.size():
		if h._bekleyen.is_empty():
			break
		h._process(0.0)
	var hedefler := {}
	for id in ids:
		var d: Dictionary = h._durum[id]
		_kontrol(d.devriye and d.devriye_ad == "Kapıda nöbet" and not d.yol.is_empty(), "SAH-34: Mevcut kapı devriyesi hedefi")
		if not d.yol.is_empty():
			var hucre := _hucre(s, d.yol[-1])
			var fark := hucre - kapi
			_kontrol(maxi(absi(fark.x), absi(fark.y)) <= 2, "SAH-34: Varış kapının yakın çevresinde")
			hedefler[hucre] = true
	_kontrol(hedefler.size() == ids.size() and hedefler.has(kapi), "SAH-34: Sekiz farklı kapı çevresi hücresi")
	print("SAH-34 ayrılan hücre=%d, kişi=%d" % [hedefler.size(), ids.size()])
	if hata == 0:
		await _varislari_olc(s, ids)
	_kontrol(JSON.stringify(y.kaydet()) == once, "SAH-34: Rota kayıt ve RNG durumundan ayrı")
	await _rota_butcesini_dene(h)
	s.queue_free()
	await get_tree().process_frame
	await _yaslari_dene(katalog)
	print("KALABALIK VARIŞ: GEÇTİ" if hata == 0 else "KALABALIK VARIŞ: KALDI")
	await Ses.cik(hata)


func _yaslari_dene(katalog: Katalog) -> void:
	var oturum := Oturum.new(katalog, 76)
	var ids: Array[int] = []
	for yas in ["yetiskin", "cocuk", "yasli"]:
		ids.append(oturum.yonetim.kabul({"sinif": "ciftci", "yas_grubu": yas}).id)
	var sahne := KoyYonetimSahnesi.new()
	sahne.yonetim = oturum.yonetim
	add_child(sahne)
	await _ortak_agi_dene(sahne.halk_hareketi, ids)
	sahne.queue_free()
	await get_tree().process_frame


func _ortak_agi_dene(h: KoyHalkHareketi, ids: Array) -> void:
	h.set_process(false)
	h._ayar.hiz_farki = 0.0
	var s := h.sahne
	var bolge := h.get_node("zemin_navigasyonu") as KoyZeminNavigasyonu
	for i in 120:
		if bolge.hazir():
			break
		await get_tree().physics_frame
	var bas := s.yonetim.a.meydan.position
	var hucreler := h.rotaci.yol(bas, bas + Vector2i.RIGHT)
	var once := bolge.sorgu_sayisi
	var hizlar := PackedFloat64Array()
	for id in ids:
		var figur: KarakterModel = h.modeller[id]
		figur.yurumeyi_durdur()
		figur.position = h._konum(bas)
		var yol := KoyZeminNavigasyonu.yol(h, hucreler)
		_kontrol(yol.size() >= 2, "SAH-40: İki yaş ve yetişkin ortak rota alır")
		if yol.size() < 2:
			return
		h._durum[id].yol = yol
		h._durum[id].adim = 1
		for nokta in yol:
			_kontrol(NavigationServer3D.map_get_closest_point_owner(bolge.get_navigation_map(), nokta) == bolge.get_rid(), "SAH-40: Aynı ANI-13 bölge kimliği")
		# Aynı rotada hız ölçülürken diğer aktörler başlangıç hücresinde beklemez.
		for diger in ids:
			if diger != id:
				h.modeller[diger].yurumeyi_durdur()
				h.modeller[diger].position = h._konum(bas + Vector2i(0, 2 + ids.find(diger)))
		h._adim(id)
		_kontrol(figur.hareket_bandi() == "yuru" and figur._yurume != null, "SAH-40: Yaşlar yürüyüş bandını kullanır")
		if figur._yurume == null:
			return
		figur._yurume.pause()
		figur._yurume.custom_step(0.1)
		hizlar.append(figur.position.distance_to(h._konum(bas)) / 0.1)
	_kontrol(bolge.sorgu_sayisi - once == 3 and NavigationServer3D.map_get_regions(bolge.get_navigation_map()).size() == 1, "SAH-40: Üç aktör tek sunucu bölgesini kullanır")
	_kontrol(hizlar[0] > hizlar[1] and hizlar[1] > hizlar[2] and hizlar[2] > 0.0, "SAH-40: Çocuk ve yaşlı yetişkinden yavaş yürür")
	print("SAH-40 yetişkin/çocuk/yaşlı m/s=%s" % [hizlar])


func _rota_butcesini_dene(h: KoyHalkHareketi) -> void:
	var y := h.sahne.yonetim
	y.kabul({"sinif": "ciftci", "stat": 5})
	var son := y.kabul({"sinif": "ciftci", "stat": 5})
	h.yenile()
	var f: KarakterModel = h.modeller[son.id]
	var bas := h._konum(y.a.meydan.position)
	f.position = bas
	var hedef := bas + Vector3(0.45, 0, 0)
	h._durum[son.id].yol = [hedef]
	h._durum[son.id].adim = 0
	f.yuru(hedef, 1.35)
	h._iste(son.id)
	var ilk := h._bekleyen.size()
	var once := h.rota_butcesi_asimlari
	var butce := h._rota_butcesi_us
	# Sınırın dolmasını makine hızından bağımsız sınamak için bütçeyi bu karede sıfırla.
	h._rota_butcesi_us = 0
	h._process(0.0)
	_kontrol(ilk == 10 and h._bekleyen.size() == 9 and h.rota_butcesi_asimlari == once + 1, "SAH-39: On istekten ilk plan biter ve diğer istekler sırada kalır")
	_kontrol(h._bekleyen.has(son.id) and f._yurume != null and f._yurume.is_running(), "SAH-39: Ertelenen kök eski yolunda yürür")
	print("SAH-39 istek=%d, ertelenen=%d, bütçe aşımı=%d, yapılandırılan bütçe=%d µs" % [ilk, h._bekleyen.size(), h.rota_butcesi_asimlari - once, butce])
	h._rota_butcesi_us = butce
	await get_tree().process_frame


func _tek_esigi_dene(h: KoyHalkHareketi, ids: Array[int], kapi: Vector2i) -> void:
	var birinci: KarakterModel = h.modeller[ids[0]]
	var ikinci: KarakterModel = h.modeller[ids[1]]
	var merkez := h._konum(kapi)
	birinci.position = merkez + Vector3(-0.6, 0, 0)
	var bekleme := merkez + Vector3(0.6, 0, -1.05)
	var hedef := merkez + Vector3(0.6, 0, 0.6)
	ikinci.position = bekleme
	ikinci.position = KoyRotaAraligi.adim(hedef, 0.25, h, ikinci)
	_kontrol(ikinci.position.is_equal_approx(bekleme), "SAH-36: Eşik doluyken ikinci kök sınırda bekler")
	var durum := {"bekle": 0.0, "ilerleme_konumu": bekleme}
	ikinci.yuru(hedef, 1.35)
	_kontrol(not h._sikismada_bekle(ikinci, durum, hedef, 1.99), "SAH-37: İki saniyeden önce yürüyüş kesilmez")
	_kontrol(h._sikismada_bekle(ikinci, durum, hedef, 0.01), "SAH-37: İki saniyede bekleme başlar")
	_kontrol(ikinci.hareket_bandi() == "dur" and ikinci._yurume == null and ikinci.position == bekleme, "SAH-37: Kök yerinde ve yürüyüş tween’i kapalı")
	birinci.position = h._konum(kapi + Vector2i.LEFT)
	ikinci.position = KoyRotaAraligi.adim(hedef, 0.25, h, ikinci)
	_kontrol(_hucre(h.sahne, ikinci.position) == kapi, "SAH-36: Eşik boşalınca sıradaki kök geçer")


func _varislari_olc(s: KoyYonetimSahnesi, ids: Array[int]) -> void:
	var h := s.halk_hareketi
	var sure := 0.0
	var min_aralik := INF
	var kesismeler := 0
	var varis := 0
	while sure < 12.0 and varis < ids.size():
		await get_tree().process_frame
		var delta := get_process_delta_time()
		sure += delta
		h._process(delta)
		varis = 0
		for i in ids.size():
			var id := ids[i]
			var d: Dictionary = h._durum[id]
			var f: KarakterModel = h.modeller[id]
			if not d.yol.is_empty() and int(d.adim) >= d.yol.size():
				d.bekle = 0.0
				varis += 1
				_kontrol(_hucre(s, f.position) == _hucre(s, d.yol[-1]), "SAH-34: Kök ayrılan hücreye ulaştı")
			for j in range(i + 1, ids.size()):
				var diger: KarakterModel = h.modeller[ids[j]]
				var aralik := f.position.distance_to(diger.position)
				min_aralik = minf(min_aralik, aralik)
				if aralik + 0.001 < AyakZemini.CARPISMA_PAYI:
					kesismeler += 1
	if varis < ids.size():
		for id in ids:
			var d: Dictionary = h._durum[id]
			if int(d.adim) < d.yol.size():
				print("SAH-34 bekleyen=%d, konum=%s, sıradaki=%s, varış=%s" % [id, h.modeller[id].position, d.yol[d.adim], d.yol[-1]])
			else:
				print("SAH-34 varan=%d, konum=%s" % [id, h.modeller[id].position])
	_kontrol(varis == ids.size() and kesismeler == 0, "SAH-34: Sekiz canlı varışta kesişim sıfır")
	print("SAH-34 varış=%d, kesişim=%d, en küçük aralık=%.5f m, süre=%.2f s" % [varis, kesismeler, min_aralik, sure])


func _hucre(s: KoyYonetimSahnesi, konum: Vector3) -> Vector2i:
	var kose := s.hucre_kosesi(Vector2i.ZERO)
	return Vector2i(floori((konum.x - kose.x) / s.HUCRE), floori((konum.z - kose.z) / s.HUCRE))


func _kontrol(dogru: bool, ad: String) -> void:
	if not dogru:
		hata += 1
		push_error(ad)
