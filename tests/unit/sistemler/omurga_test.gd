extends SceneTree

const OmurgaSinifi = preload("res://src/sistemler/omurga.gd")

var _hata: int = 0


func _kontrol(kosul: bool, mesaj: String) -> void:
	if not kosul:
		_hata += 1
		push_error("OMURGA TEST HATASI: " + mesaj)


func _initialize() -> void:
	# OMR-02: Perde 1 uc donemi (nufus < 8 -> kurulus, 8..13 -> yerlesme, 14..18 -> oturma)
	_kontrol(OmurgaSinifi.donem(5) == &"kurulus", "Nufus 5 iken donem kurulus olmali")
	_kontrol(OmurgaSinifi.donem(10) == &"yerlesme", "Nufus 10 iken donem yerlesme olmali")
	_kontrol(OmurgaSinifi.donem(16) == &"oturma", "Nufus 16 iken donem oturma olmali")

	# OMR-04: Perde 2 uc dalgasi; hedef 12 (4+4+4) ve hedef 15 (5+5+5) sinirlari
	_kontrol(OmurgaSinifi.dalga(0, 12) == 1 and OmurgaSinifi.dalga(3, 12) == 1, "Hedef 12'de gece 0..3 dalga 1 olmali")
	_kontrol(OmurgaSinifi.dalga(4, 12) == 2 and OmurgaSinifi.dalga(7, 12) == 2, "Hedef 12'de gece 4..7 dalga 2 olmali")
	_kontrol(OmurgaSinifi.dalga(8, 12) == 3 and OmurgaSinifi.dalga(11, 12) == 3, "Hedef 12'de gece 8..11 dalga 3 olmali")

	_kontrol(OmurgaSinifi.dalga(4, 15) == 1, "Hedef 15'te gece 4 dalga 1 olmali")
	_kontrol(OmurgaSinifi.dalga(5, 15) == 2 and OmurgaSinifi.dalga(9, 15) == 2, "Hedef 15'te gece 5..9 dalga 2 olmali")
	_kontrol(OmurgaSinifi.dalga(10, 15) == 3 and OmurgaSinifi.dalga(14, 15) == 3, "Hedef 15'te gece 10..14 dalga 3 olmali")

	# OMR-06 ve OMR-34: omurga.gd icinde kaydet/yukle ve Takvim gecmemeli
	var kaynak_metin := FileAccess.get_file_as_string("res://src/sistemler/omurga.gd")
	_kontrol(not kaynak_metin.contains("kaydet") and not kaynak_metin.contains("yukle"), "OMR-06: omurga.gd icinde kaydet/yukle olmamali")
	_kontrol(not kaynak_metin.contains("Takvim") and not kaynak_metin.contains("takvim"), "OMR-34: omurga.gd icinde Takvim olmamali")

	if _hata == 0:
		print("OMURGA: GEÇTİ (0 hata)")
	else:
		print("OMURGA: KALDI (%d hata)" % _hata)
	quit(_hata)
