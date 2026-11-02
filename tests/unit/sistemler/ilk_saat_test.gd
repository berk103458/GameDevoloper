extends SceneTree

const IlkSaatSinifi = preload("res://src/sistemler/ilk_saat.gd")

var _hata: int = 0


func _kontrol(kosul: bool, mesaj: String) -> void:
	if not kosul:
		_hata += 1
		push_error("ILK SAAT TEST HATASI: " + mesaj)


func _initialize() -> void:
	var ilk := IlkSaatSinifi.new()
	var kavramlar := ilk.kavramlar()
	_kontrol(kavramlar.size() == 9, "ilk_saat.json icinde 9 temel kavram olmali")
	for k in kavramlar:
		_kontrol(k.has("gece_min") and k.has("tetik"), "Her kavramin gece_min ve tetik alani olmali")

	# Listede olmayan ipucu cikmaz
	var uydurma := ilk.tetikle("uydurma_ipucu", 5)
	_kontrol(not bool(uydurma.get("gosterildi", true)), "Listede olmayan ipucu cikmamali")

	# Ilk alti gecede (gece 0..5) tum kavramlar tetiklendiginde gosterilen ipucu sayisi kavram sayisiyla esittir
	var gosterilen := 0
	for gece in range(0, 6):
		for k in kavramlar:
			var sonuc := ilk.tetikle(String(k.get("tetik", "")), gece)
			if bool(sonuc.get("gosterildi", false)):
				gosterilen += 1
	_kontrol(gosterilen == ilk.kavram_sayisi(), "Dosyadaki kavram sayisi ile ilk alti gecede gosterilen ipucu sayisi esit olmali")

	if _hata == 0:
		print("ILK SAAT: GEÇTİ (0 hata)")
	else:
		print("ILK SAAT: KALDI (%d hata)" % _hata)
	quit(_hata)
