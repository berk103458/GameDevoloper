extends Node

func _ready() -> void:
	get_tree().create_timer(15).timeout.connect(func(): get_tree().quit(1))
	call_deferred("_calistir")

func _calistir() -> void:
	for tur in ["kulube", "tas_ev", "ambar", "demirhane"]:
		var n := Node3D.new()
		assert(HazirKoyYapilari.kur(n, tur, 4.0, 4.0))
		var a := Dunya3B._kutu(n)
		print(tur, " envelope=", a)
		assert(absf(a.position.y) < 0.01)
		assert(a.size.x < 4.0 and a.size.z < 4.0 and a.size.y <= 3.01)
		assert(n.get_node_or_null("megakit_yapi/Door_1_Flat") != null)
		n.free()
	var n := Node3D.new()
	assert(not HazirKoyYapilari.kur(n, "tarla", 6, 6))
	assert(n.get_child_count() == 0)
	n.free()
	var s := KoyYonetimSahnesi.new()
	s.yonetim = KoyYonetimi.new(KoyAyarlari.new(), BinaKatalogu.new(), 28)
	var b := KoyBinasi.new()
	b.tur = "kulube"
	b.insa_kalan = 0
	var dugum := s._bina_dugumu(b)
	assert(dugum.get_node_or_null("megakit_yapi") != null)
	dugum.free()
	s.free()
	print("HAZIR KÖY YAPILARI: GEÇTİ")
	await Ses.sustur()
	get_tree().quit()
