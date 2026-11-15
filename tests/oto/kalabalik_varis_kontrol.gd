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
	h._bekleyen.clear()
	for i in ids.size():
		var id := ids[i]
		var f: KarakterModel = h.modeller[id]
		var bas := kapi + Vector2i(i % 4 - 2, -3 - i / 4)
		_kontrol(h.rotaci.gecilir(bas), "SAH-34: Başlangıç hücresi açık")
		f.position = h._konum(bas)
		h._durum[id].devriye_i = 0
		h._iste(id)
	for i in 3:
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
	s.queue_free()
	await get_tree().process_frame
	print("KALABALIK VARIŞ: GEÇTİ" if hata == 0 else "KALABALIK VARIŞ: KALDI")
	await Ses.cik(hata)


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
	_kontrol(varis == ids.size() and kesismeler == 0, "SAH-34: Sekiz canlı varışta kesişim sıfır")
	print("SAH-34 varış=%d, kesişim=%d, en küçük aralık=%.5f m, süre=%.2f s" % [varis, kesismeler, min_aralik, sure])


func _hucre(s: KoyYonetimSahnesi, konum: Vector3) -> Vector2i:
	var kose := s.hucre_kosesi(Vector2i.ZERO)
	return Vector2i(floori((konum.x - kose.x) / s.HUCRE), floori((konum.z - kose.z) / s.HUCRE))


func _kontrol(dogru: bool, ad: String) -> void:
	if not dogru:
		hata += 1
		push_error(ad)
