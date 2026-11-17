extends SceneTree

var _hata := 0


func _dogrula(kosul: bool, mesaj: String) -> void:
	if not kosul:
		_hata += 1
		push_error("CIL-07 HATA: " + mesaj)


var _s: KoyYonetimSahnesi
var _kat: BinaKatalogu


func _initialize() -> void:
	_kat = BinaKatalogu.new()
	_s = KoyYonetimSahnesi.new()
	_s.yonetim = KoyYonetimi.new(KoyAyarlari.new(), _kat, 77)
	var binalar_turler := [
		["demirhane", Vector2i(2, 2)],
		["firin", Vector2i(6, 2)],
		["ambar", Vector2i(10, 2)],
		["atolye", Vector2i(15, 2)],
		["muhafiz_kislasi", Vector2i(2, 6)],
		["odunluk", Vector2i(7, 6)],
		["tas_ocagi", Vector2i(11, 6)],
		["bostan", Vector2i(15, 6)],
		["han", Vector2i(2, 11)],
		["tas_ev", Vector2i(7, 11)],
		["ahir", Vector2i(11, 11)],
		["agil", Vector2i(15, 11)],
	]
	for idx in binalar_turler.size():
		var kayit: Array = binalar_turler[idx]
		var b := KoyBinasi.new()
		b.id = idx + 1
		b.tur = String(kayit[0])
		b.hucre = kayit[1] as Vector2i
		b.insa_kalan = 0
		_s.yonetim.binalar.append(b)
		var boy := b.boyut(_kat)
		for dy in boy.y:
			for dx in boy.x:
				_s.yonetim.izgara.dolu[b.hucre + Vector2i(dx, dy)] = b.id
	get_root().add_child(_s)
	call_deferred("_calistir")


func _calistir() -> void:
	var s := _s
	s.yenile()

	# 1) Dış halka eski 39 vitrin yığınından temizlendi (<= 6 arka silüet/orman).
	_dogrula(ToplulukDekoru._liste().size() <= 6, "ToplulukDekoru dış vitrin listesi küçültüldü (%d)" % ToplulukDekoru._liste().size())

	# 2) Binaların avlu eşyaları kuruldu.
	var avlu_sayisi := s._yapilar.find_children("avlu_*", "", true, false).size()
	var cevre_sayisi := s._yapilar.find_children("cevre_*", "", true, false).size()
	_dogrula(avlu_sayisi >= 20, "Avlu eşyaları binalara bağlandı (%d)" % avlu_sayisi)
	_dogrula(cevre_sayisi >= 3, "Çevre eşyaları kuruldu (%d)" % cevre_sayisi)

	# 3) Hiçbir avlu/çevre eşyası KoyZeminNavigasyonu yürüme hücresine taşmıyor.
	var rota := KoyRotasi.new()
	rota.kur(s.yonetim.izgara, 1.0)
	var bas := s.hucre_kosesi(Vector2i.ZERO)
	for node_v in s._yapilar.get_children():
		var node := node_v as Node3D
		if node == null or node.is_queued_for_deletion():
			continue
		var esyalar: Array[Node] = []
		if node.name == "koy_avlu_cevre":
			esyalar = node.get_children()
		else:
			var avlu := node.get_node_or_null("avlu_esyalari")
			if avlu != null:
				esyalar = avlu.get_children()
		for e_v in esyalar:
			var esya := e_v as Node3D
			if esya == null or not bool(esya.get_meta(&"avlu_esya", false)):
				continue
			var gpos: Vector3 = esya.global_position
			# Havadaki saçak kandili (y > 1.7) yaya koridorunu kapatmaz.
			if gpos.y > 1.7:
				continue
			var yerel_kutu := Dunya3B._kutu(esya)
			var gx_min := gpos.x + yerel_kutu.position.x + 0.04
			var gx_max := gpos.x + yerel_kutu.end.x - 0.04
			var gz_min := gpos.z + yerel_kutu.position.z + 0.04
			var gz_max := gpos.z + yerel_kutu.end.z - 0.04
			for px in [gx_min, gpos.x, gx_max]:
				for pz in [gz_min, gpos.z, gz_max]:
					var hx := int(floor((px - bas.x) / s.HUCRE))
					var hz := int(floor((pz - bas.z) / s.HUCRE))
					var h := Vector2i(hx, hz)
					_dogrula(not rota.gecilir(h), "%s yürüme hücresini (%s) tıkıyor!" % [esya.name, str(h)])

	print("CIL-07 AVLU EŞYA (%d avlu, %d çevre): GEÇTİ" % [avlu_sayisi, cevre_sayisi] if _hata == 0 else "CIL-07 AVLU EŞYA: KALDI (%d hata)" % _hata)
	quit(0 if _hata == 0 else 1)
