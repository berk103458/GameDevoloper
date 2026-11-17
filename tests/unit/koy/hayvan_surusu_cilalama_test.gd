extends SceneTree

var _hata := 0


func _dogrula(kosul: bool, mesaj: String) -> void:
	if not kosul:
		_hata += 1
		push_error("CIL-10 HATA: " + mesaj)


func _initialize() -> void:
	# 1) Tavuk (Ahmet kararı: a146_tavuk_gercekci <= 0.45m; k04_tavuk sahnede devre dışı)
	_dogrula(not Dunya3B.model_var_mi("td_k04"), "k04_tavuk tekilleştirme gereği devre dışı")
	var tavuk := Dunya3B.nesne("td_a146")
	get_root().add_child(tavuk)
	var tb := Dunya3B.boyut(tavuk)
	_dogrula(tb.y >= 0.30 and tb.y <= 0.45, "a146 tavuk diz altı gerçek boyda: %.3f m" % tb.y)
	tavuk.free()

	# 2) Koyun (k13_koyun animasyonlu) ve Keçi (a163_keci)
	var koyun := CobanSurusu.koyun("koyun")
	get_root().add_child(koyun)
	var kb := Dunya3B.boyut(koyun)
	_dogrula(kb.y >= 0.65 and kb.y <= 0.801, "koyun gerçek boyda: %.3f m" % kb.y)
	_dogrula(AnimasyonluVarlik.calisiyor_mu(koyun), "k13_koyun animasyonu aktif")
	koyun.free()

	var keci := CobanSurusu.koyun("keci")
	get_root().add_child(keci)
	var keb := Dunya3B.boyut(keci)
	_dogrula(keb.y >= 0.65 and keb.y <= 0.85, "a163 keçi gerçek boyda: %.3f m" % keb.y)
	keci.free()

	# 3) At (k05), Esek (a157), Okuz (a172) ve Koc
	var koc := CanliHayvanSurusu._koc()
	get_root().add_child(koc)
	_dogrula(Dunya3B.boyut(koc).y <= 0.86, "koç gerçek boyda: %.3f m" % Dunya3B.boyut(koc).y)
	koc.free()

	var at := CelepHayvanGorseli._yer_tutucu("at")
	get_root().add_child(at)
	_dogrula(AnimasyonluVarlik.calisiyor_mu(at), "celep at (k05) animasyonu aktif")
	at.free()

	print("CIL-10 HAYVAN SÜRÜSÜ: GEÇTİ" if _hata == 0 else "CIL-10 HAYVAN SÜRÜSÜ: KALDI (%d hata)" % _hata)
	quit(0 if _hata == 0 else 1)
