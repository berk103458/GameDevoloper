## CIL-03 hedefli testi: kimlik çakışması, ahır/değirmen tekilleştirmesi ve çözümleme odası temizliği.
extends SceneTree

var _hata := 0

func _initialize() -> void:
	var kat := BinaKatalogu.new()
	_kontrol(kat.boyut("muhafiz_kislasi") == Vector2i(3, 3), "muhafiz_kislasi 3x3 olmalı")
	_kontrol(OlayYapilari.yapi_adi("kisla") == "muhafiz_kislasi", "kisla -> muhafiz_kislasi")
	_kontrol(OlayYapilari.yapi_adi("avci") == "avci_cadiri", "avci -> avci_cadiri")
	_kontrol(OlayYapilari.yapi_adi("degirmen") == "degirmen_o76", "degirmen -> O76")

	var s := KoyYonetimSahnesi.new()
	s.yonetim = KoyYonetimi.new(KoyAyarlari.new(), kat, 28)

	var cozum := KoyBinasi.new()
	cozum.tur = "cozumleme_odasi"
	cozum.insa_kalan = 0
	var cd := s._bina_dugumu(cozum)
	_kontrol(cd.get_node_or_null("meshy_cozumleme_odasi") != null, "cozumleme_odasi GLB kurulmalı")
	_kontrol(cd.get_node_or_null("CozumlemeOdaYerTutucu") == null, "cozumleme_odasi artık küp kurmamalı")
	cd.free()

	var ahir := KoyBinasi.new()
	ahir.tur = "ahir"
	ahir.insa_kalan = 0
	var ad := s._bina_dugumu(ahir)
	_kontrol(ad.get_node_or_null("AhirYerTutucu") != null, "bozuk ahir.glb yerine AhirYerTutucu kurulmalı")
	ad.free()

	var deg := KoyBinasi.new()
	deg.tur = "degirmen"
	deg.insa_kalan = 0
	var dd := s._bina_dugumu(deg)
	var o76_var := not dd.find_children("meshy_o76_su_degirmeni", "Node3D", true, false).is_empty()
	_kontrol(o76_var, "degirmen içinde O76_su_degirmeni kurulmalı")
	dd.free()

	s.free()
	print("CIL-03 YAPI EŞLEME: %s" % ("GEÇTİ" if _hata == 0 else "KALDI (%d hata)" % _hata))
	quit(1 if _hata > 0 else 0)

func _kontrol(ok: bool, msg: String) -> void:
	if not ok:
		_hata += 1
		push_error("CIL-03: " + msg)
