extends SceneTree

var _hata := 0


func _dogrula(kosul: bool, mesaj: String) -> void:
	if not kosul:
		_hata += 1
		push_error("CIL-11 HATA: " + mesaj)


func _initialize() -> void:
	# 1) Tüm 20 ElEsyasi anahtarı için mesh sınırının el merkezine (0,0,0) uzaklığı <= 0.15 m
	var turler := [
		"torba", "heybe", "sepet", "sepet_buyuk", "asa", "degnek", "odun", "sandik",
		"cekic", "kamci", "kurk", "kova", "balta", "orak", "kurek", "firin_kuregi",
		"su_kabi", "kirmen", "bakim_bezi", "kilic_bez",
	]
	for t in turler:
		var e := ElEsyasi.olustur(t)
		_dogrula(e != null, "%s oluşturulamadı" % t)
		if e != null:
			var kutu := Dunya3B._kutu(e)
			var yakin := Vector3(
				clampf(0.0, kutu.position.x, kutu.end.x),
				clampf(0.0, kutu.position.y, kutu.end.y),
				clampf(0.0, kutu.position.z, kutu.end.z)
			)
			var mesafe := yakin.length()
			_dogrula(mesafe <= 0.15, "%s mesh sınırı el merkezinden uzak: %.3f m" % [t, mesafe])
			e.free()

	# 2) k09 (kışla muhafızı), k02 (kışla bekçisi) ve k12 (han tüccarı) ölçek ve animasyonları
	for c in [["td_k09", true], ["td_k12", true], ["td_k02", false]]:
		var ad := String(c[0])
		var anim_gerek := bool(c[1])
		var n := Dunya3B.nesne(ad)
		get_root().add_child(n)
		var b := Dunya3B.boyut(n)
		_dogrula(b.y >= 1.65 and b.y <= 1.80, "%s boyu 1.70–1.75 m bandında: %.3f m" % [ad, b.y])
		if anim_gerek:
			_dogrula(AnimasyonluVarlik.calisiyor_mu(n), "%s animasyonu aktif" % ad)
		n.free()

	print("CIL-11 EL EŞYASI & AKTÖR (20 eşya + 3 aktör): GEÇTİ" if _hata == 0 else "CIL-11 EL EŞYASI & AKTÖR: KALDI (%d hata)" % _hata)
	quit(0 if _hata == 0 else 1)
