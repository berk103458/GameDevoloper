extends SceneTree

var _hata := 0


func _dogrula(kosul: bool, mesaj: String) -> void:
	if not kosul:
		_hata += 1
		push_error("CIL-09 HATA: " + mesaj)


func _initialize() -> void:
	var kok := Node3D.new()
	get_root().add_child(kok)
	HazirEsyaHayvan.kopek_kur(kok, Vector3(1.0, 0.0, 2.0))
	_dogrula(kok.get_child_count() == 1, "kopek_kur tek çocuk ekledi")
	var kopek := kok.get_child(0) as Node3D
	_dogrula(kopek != null and kopek.has_meta("asset_yolu"), "kopek model meta doğrulandı")
	if kopek != null:
		_dogrula("styloo" in String(kopek.get_meta("asset_yolu", "")), "styloo/kopek.glb önceliklendirildi")
		var ap_liste := kopek.find_children("*", "AnimationPlayer", true, false)
		_dogrula(not ap_liste.is_empty(), "AnimationPlayer bulundu")
		if not ap_liste.is_empty():
			var ap := ap_liste[0] as AnimationPlayer
			_dogrula(ap.is_playing(), "kopek idle animasyonu oynuyor")
			_dogrula("iddle" in String(ap.current_animation).to_lower() or "idle" in String(ap.current_animation).to_lower(), "klip iddle/idle ile eşleşti: %s" % ap.current_animation)
			AnimasyonluVarlik.durum_ayarla(kopek, &"yuru", 1.5)
			_dogrula("walk" in String(ap.current_animation).to_lower(), "yuru durumunda walk klibi seçildi: %s" % ap.current_animation)
			AnimasyonluVarlik.durum_ayarla(kopek, &"kos", 3.5)
			_dogrula("run" in String(ap.current_animation).to_lower(), "kos durumunda run klibi seçildi: %s" % ap.current_animation)

	var kangal := HazirEsyaHayvan.kangal_kur(kok, Vector3(-1.0, 0.0, 0.0))
	_dogrula(kangal != null and Dunya3B.boyut(kangal).y <= 0.90, "Kangal B019 bekçi seçeneği normalize edildi")
	kok.free()

	print("CIL-09 KÖPEK ANİMASYON: GEÇTİ" if _hata == 0 else "CIL-09 KÖPEK ANİMASYON: KALDI (%d hata)" % _hata)
	quit(0 if _hata == 0 else 1)
