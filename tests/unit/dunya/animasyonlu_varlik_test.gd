extends SceneTree

var _hata := 0


func _dogrula(kosul: bool, mesaj: String) -> void:
	if not kosul:
		_hata += 1
		push_error("CIL-08 HATA: " + mesaj)


func _initialize() -> void:
	var adaylar := [
		["td_a146", 0.35, 0.48, false],
		["td_k05", 1.40, 1.75, true],
		["td_k13", 0.65, 0.90, true],
		["td_k09", 1.55, 1.85, true],
		["td_k12", 1.55, 1.85, true],
		["styloo_kopek", 0.50, 0.85, true],
	]
	for item in adaylar:
		var ad := String(item[0])
		var min_h := float(item[1])
		var max_h := float(item[2])
		var beklenen_anim := bool(item[3])
		var n := Dunya3B.nesne(ad)
		get_root().add_child(n)
		var b := Dunya3B.boyut(n)
		_dogrula(b.y >= min_h and b.y <= max_h, "%s boyu aralıkta değil: %.3f m (beklenen %.2f..%.2f)" % [ad, b.y, min_h, max_h])
		if beklenen_anim:
			_dogrula(AnimasyonluVarlik.calisiyor_mu(n), "%s AnimationPlayer aktif değil" % ad)
			AnimasyonluVarlik.durum_ayarla(n, &"yuru", 1.8)
			_dogrula(AnimasyonluVarlik.calisiyor_mu(n), "%s yürüyüş durumu aktif değil" % ad)
		n.free()

	print("CIL-08 ANİMASYONLU VARLIK (6 tür): GEÇTİ" if _hata == 0 else "CIL-08 ANİMASYONLU VARLIK: KALDI (%d hata)" % _hata)
	quit(0 if _hata == 0 else 1)
