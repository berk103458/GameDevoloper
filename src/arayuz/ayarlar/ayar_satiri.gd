## Ayar satırı: sol/sağ okla değer değişir, anında uygulanır, açıklama anahtarı seçilince yazılır.
extends RefCounted


static func ekle(kutu: VBoxContainer, a: Ayarlar, anahtar: StringName, aciklama: Label) -> void:
	var yatay := HBoxContainer.new()
	yatay.set_meta(&"anahtar", anahtar)
	yatay.add_theme_constant_override("separation", 8)
	kutu.add_child(yatay)
	var ad := Button.new()
	ad.text = TranslationServer.translate("arayuz.ayarlar." + String(anahtar)) if _ceviri_var("arayuz.ayarlar." + String(anahtar)) else String(anahtar)
	ad.focus_mode = Control.FOCUS_ALL
	ad.flat = true
	ad.custom_minimum_size = Vector2(280, 36)
	ad.focus_entered.connect(func() -> void: _acikla(aciklama, anahtar))
	yatay.add_child(ad)
	var deger := Label.new()
	deger.custom_minimum_size = Vector2(180, 0)
	deger.name = "deger_%s" % anahtar
	yatay.add_child(deger)
	var geri := Button.new()
	geri.text = "‹"
	geri.focus_entered.connect(func() -> void: _acikla(aciklama, anahtar))
	geri.pressed.connect(func() -> void: _degistir(a, anahtar, -1, deger))
	yatay.add_child(geri)
	var ileri := Button.new()
	ileri.text = "›"
	ileri.focus_entered.connect(func() -> void: _acikla(aciklama, anahtar))
	ileri.pressed.connect(func() -> void: _degistir(a, anahtar, 1, deger))
	yatay.add_child(ileri)
	_yaz(a, anahtar, deger)
	var bag := _yenile.bind(a, anahtar, deger)
	if not a.degisti.is_connected(bag):
		a.degisti.connect(bag)
	deger.tree_exiting.connect(func() -> void:
		if a.degisti.is_connected(bag):
			a.degisti.disconnect(bag)
	)


static func _ceviri_var(anahtar: String) -> bool:
	return not GuvenliMetin.eksik_mi(anahtar) and TranslationServer.translate(anahtar) != anahtar


static func _acikla(aciklama: Label, anahtar: StringName) -> void:
	if aciklama == null:
		return
	var k := "arayuz.ayarlar.%s_aciklama" % anahtar
	aciklama.text = TranslationServer.translate(k) if _ceviri_var(k) else k


static func _yenile(_gelen: StringName, a: Ayarlar, anahtar: StringName, deger: Label) -> void:
	if is_instance_valid(deger):
		_yaz(a, anahtar, deger)


static func _yaz(a: Ayarlar, anahtar: StringName, deger: Label) -> void:
	var v: Variant = _deger(a, anahtar)
	if v is bool:
		deger.text = TranslationServer.translate("arayuz.ayarlar.acik") if v else TranslationServer.translate("arayuz.ayarlar.kapali")
	elif v is StringName or v is String:
		var ozel := "arayuz.ayarlar.deger.%s.%s" % [anahtar, String(v)]
		deger.text = TranslationServer.translate(ozel) if _ceviri_var(ozel) else String(v)
	else:
		deger.text = str(v)


static func _deger(a: Ayarlar, anahtar: StringName) -> Variant:
	if a.degerler.has(anahtar):
		return a.al(anahtar)
	return AyarlarEk.VARSAYILAN.get(anahtar, null)


static func _degistir(a: Ayarlar, anahtar: StringName, yon: int, deger: Label) -> void:
	var v: Variant = _deger(a, anahtar)
	if v is bool:
		_kaydet(a, anahtar, not bool(v))
	else:
		var liste := _liste(a, anahtar)
		if not liste.is_empty():
			var i := liste.find(v)
			if i < 0:
				i = 0
			_kaydet(a, anahtar, liste[(i + yon + liste.size()) % liste.size()])
		elif v is int or v is float:
			_kaydet(a, anahtar, clampi(int(v) + yon, 0, 10))
	_yaz(a, anahtar, deger)


static func _liste(a: Ayarlar, anahtar: StringName) -> Array:
	if anahtar == &"metin_olcegi":
		return AyarlarEk.METIN_OLCEKLERI
	if AyarlarEk.GECERLI.has(anahtar):
		var ek: Variant = AyarlarEk.GECERLI[anahtar]
		if ek is Array and not (ek as Array).is_empty() and (ek as Array)[0] is bool:
			return []
		return ek
	if Ayarlar.GECERLI.has(anahtar):
		return Ayarlar.GECERLI[anahtar]
	return []


static func _kaydet(a: Ayarlar, anahtar: StringName, deger: Variant) -> void:
	if AyarlarEk.VARSAYILAN.has(anahtar) or anahtar == &"metin_olcegi":
		AyarlarEk.ayarla(a, anahtar, deger)
	else:
		a.ayarla(anahtar, deger)
