extends Node

var _hata := 0

func _ready() -> void:
	get_tree().create_timer(15).timeout.connect(func(): get_tree().quit(1))
	call_deferred("_calistir")

func _calistir() -> void:
	for tur in ["kulube", "tas_ev", "ambar", "demirhane"]:
		var n := Node3D.new()
		_dene(HazirKoyYapilari.kur(n, tur, 4.0, 4.0), "hazir_koy_yapilari_kontrol.gd:10")
		var a := Dunya3B._kutu(n)
		print(tur, " envelope=", a)
		_dene(absf(a.position.y) < 0.01, "hazir_koy_yapilari_kontrol.gd:13")
		_dene(a.size.x < 4.0 and a.size.z < 4.0 and a.size.y <= (3.21 if tur == "demirhane" else 3.01), "hazir_koy_yapilari_kontrol.gd:14")
		_dene(n.get_node_or_null("megakit_yapi/Door_1_Flat") != null, "hazir_koy_yapilari_kontrol.gd:15")
		n.free()
	var n := Node3D.new()
	_dene(not HazirKoyYapilari.kur(n, "tarla", 6, 6), "hazir_koy_yapilari_kontrol.gd:18")
	_dene(n.get_child_count() == 0, "hazir_koy_yapilari_kontrol.gd:19")
	n.free()
	var s := KoyYonetimSahnesi.new()
	s.yonetim = KoyYonetimi.new(KoyAyarlari.new(), BinaKatalogu.new(), 28)
	var b := KoyBinasi.new()
	b.tur = "kulube"
	b.insa_kalan = 0
	var dugum := s._bina_dugumu(b)
	_dene(dugum.get_node_or_null("megakit_yapi") != null, "hazir_koy_yapilari_kontrol.gd:27")
	dugum.free()
	s.free()
	print("HAZIR KÖY YAPILARI: GEÇTİ" if _hata == 0 else "HAZIR KÖY YAPILARI: KALDI (%d hata)" % _hata)
	await Ses.sustur()
	get_tree().quit(1 if _hata > 0 else 0)


func _dene(kosul: bool, ad: String) -> void:
	if not kosul:
		_hata += 1
		push_error(ad)
