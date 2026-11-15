extends Node
## Pazar tezgâhı, su bendi ve yanık ev: model, zemin, tek kopya, çakışma yok.


func _ready() -> void:
	var hatalar: PackedStringArray = []
	_model_yolu(hatalar)
	_han_yolu(hatalar)
	_yer_tutucu(hatalar)
	if hatalar.is_empty():
		print("OLAY YAPILARI: GEÇTİ")
	else:
		for h in hatalar:
			push_error(h)
		print("OLAY YAPILARI: KALDI (%d)" % hatalar.size())
	get_tree().quit(0 if hatalar.is_empty() else 1)


func _model_yolu(hatalar: PackedStringArray) -> void:
	var s := KoyYonetimSahnesi.new()
	s.yonetim = KoyYonetimi.new(KoyAyarlari.new(), BinaKatalogu.new(), 28)
	var ust := Node3D.new()
	add_child(ust)
	OlayYapilari.kur(s, ust)
	var pazar := ust.find_child("pazar_tezgahi", true, false)
	var yanik := ust.find_child("yanik_ev", true, false)
	var hat := ust.get_node_or_null("su_bendi_hatti")
	if pazar == null or yanik == null or hat == null:
		hatalar.append("üç yapıdan biri kurulmadı")
		return
	if pazar.name.ends_with("_yer_tutucu") or yanik.name.ends_with("_yer_tutucu"):
		hatalar.append("model varken yer tutucu kuruldu")
	if hat.get_child_count() != 2:
		hatalar.append("su bendi iki modül olmalı, %d" % hat.get_child_count())
	if _ust_adet(ust, "pazar_tezgahi") != 1:
		hatalar.append("pazar tezgâhı çift göründü")
	if _ust_adet(ust, "yanik_ev") != 1:
		hatalar.append("yanık ev çift göründü")
	var kutular: Array[AABB] = []
	for ad in ["pazar_tezgahi", "yanik_ev"]:
		kutular.append(_dunya_kutu(ust.find_child(ad, true, false)))
	for bent in hat.get_children():
		kutular.append(_dunya_kutu(bent))
	for k in kutular:
		if k.position.y < -0.05 or k.position.y > 0.05:
			hatalar.append("taban zeminde değil: %s" % k)
	for i in kutular.size():
		for j in range(i + 1, kutular.size()):
			if kutular[i].intersects(kutular[j]):
				hatalar.append("yapılar çakıştı: %s / %s" % [kutular[i], kutular[j]])
	var orta := s.alan_merkezi(s.yonetim.a.meydan.position, s.yonetim.a.meydan.size)
	var kuyu := orta + Vector3(-2.2, 0, -2.2)
	var ocak := orta + Vector3(1.2, 0, 1.2)
	for k in kutular:
		if k.intersects(AABB(kuyu - Vector3(0.6, 0, 0.6), Vector3(1.2, 1.5, 1.2))):
			hatalar.append("kuyuyla çakıştı")
		if k.intersects(AABB(ocak - Vector3(0.5, 0, 0.5), Vector3(1.0, 1.2, 1.0))):
			hatalar.append("ocakla çakıştı")


func _han_yolu(hatalar: PackedStringArray) -> void:
	var s := KoyYonetimSahnesi.new()
	s.yonetim = KoyYonetimi.new(KoyAyarlari.new(), BinaKatalogu.new(), 28)
	var han := KoyBinasi.new()
	han.tur = "han"
	han.hucre = Vector2i(2, 2)
	s.yonetim.binalar.append(han)
	var bina := s._bina_dugumu(han)
	if bina.find_child("pazar_tezgahi", true, false) == null:
		hatalar.append("han yer tutucusu pazar tezgâhını göstermiyor")
	var ust := Node3D.new()
	add_child(ust)
	OlayYapilari.kur(s, ust)
	if ust.find_child("pazar_tezgahi", true, false) != null:
		hatalar.append("han varken meydanda ikinci tezgâh kuruldu")


func _yer_tutucu(hatalar: PackedStringArray) -> void:
	var ust := Node3D.new()
	add_child(ust)
	OlayYapilari._yerlestir(ust, "olmayan_yapi_xyz", "yapi", 1.0, Vector3.ZERO, Vector3(1, 1, 1))
	var n := ust.get_child(0)
	if n.name != "olmayan_yapi_xyz" or n.get_child(0).name != "olmayan_yapi_xyz_yer_tutucu":
		hatalar.append("eksik modelde kutu yer tutucu dönmedi")
	var k := _dunya_kutu(n)
	if absf(k.position.y) > 0.05:
		hatalar.append("yer tutucu zemine oturmadı")


func _ust_adet(ust: Node, ad: String) -> int:
	var n := 0
	for c in ust.get_children():
		if c.name == ad:
			n += 1
	return n


func _dunya_kutu(n: Node) -> AABB:
	var k := Dunya3B.boyut(n)
	var p := (n as Node3D).global_position
	return AABB(p + Vector3(-k.x * 0.5, 0, -k.z * 0.5), Vector3(k.x, k.y, k.z))
