## Ayar satırı: sol/sağ okla değer değişir, anında uygulanır, açıklama anahtarı seçilince yazılır.
extends RefCounted


static func ekle(kutu: VBoxContainer, a: Ayarlar, anahtar: StringName, aciklama: Label) -> void:
	var yatay := HBoxContainer.new()
	yatay.set_meta(&"anahtar", anahtar)
	yatay.add_theme_constant_override("separation", 14)
	kutu.add_child(yatay)
	var ad := Button.new()
	ad.text = TranslationServer.translate("arayuz.ayarlar." + String(anahtar)) if _ceviri_var("arayuz.ayarlar." + String(anahtar)) else String(anahtar)
	ad.alignment = HORIZONTAL_ALIGNMENT_LEFT
	ad.focus_mode = Control.FOCUS_ALL
	ad.flat = true
	ad.custom_minimum_size = Vector2(360, 42)
	ad.focus_entered.connect(func() -> void: _acikla(aciklama, anahtar))
	ad.mouse_entered.connect(func() -> void: _acikla(aciklama, anahtar))
	yatay.add_child(ad)
	var deger := Label.new()
	deger.custom_minimum_size = Vector2(260, 42)
	deger.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	deger.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	deger.add_theme_color_override("font_color", Kabuk.BAR_DOLU)
	deger.name = "deger_%s" % anahtar
	ad.pressed.connect(func() -> void: _degistir(a, anahtar, 1, deger))
	var geri := Button.new()
	geri.text = "‹"
	geri.custom_minimum_size = Vector2(76, 42)
	geri.focus_entered.connect(func() -> void: _acikla(aciklama, anahtar))
	geri.mouse_entered.connect(func() -> void: _acikla(aciklama, anahtar))
	geri.pressed.connect(func() -> void: _degistir(a, anahtar, -1, deger))
	yatay.add_child(geri)
	yatay.add_child(deger)
	var ileri := Button.new()
	ileri.text = "›"
	ileri.custom_minimum_size = Vector2(76, 42)
	ileri.focus_entered.connect(func() -> void: _acikla(aciklama, anahtar))
	ileri.mouse_entered.connect(func() -> void: _acikla(aciklama, anahtar))
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
	deger.text = _deger_metni(anahtar, _deger(a, anahtar))


static func _deger_metni(anahtar: StringName, v: Variant) -> String:
	if v is bool:
		return TranslationServer.translate("arayuz.ayarlar.acik") if v else TranslationServer.translate("arayuz.ayarlar.kapali")
	var en := TranslationServer.get_locale().begins_with("en")
	if anahtar == &"metin_olcegi" or anahtar == &"cozunurluk_3d":
		return "%%%d" % int(v)
	if anahtar == &"koy_hizi_varsayilan":
		return "%dx" % int(v)
	if anahtar == &"kare_siniri":
		return ("Uncapped" if en else "Sınırsız") if int(v) == 0 else ("%d FPS" % int(v))
	if anahtar == &"metin_agirligi":
		if int(v) == 500:
			return "Medium (500)" if en else "Kalın (500)"
		return "Regular (400)" if en else "Normal (400)"
	if v is StringName or v is String:
		var s := String(v)
		for on_ek in [
			"arayuz.ayarlar.deger.%s.%s" % [anahtar, s],
			"arayuz.ayarlar.ekran.%s" % s if anahtar == &"ekran_modu" else "",
			"arayuz.ayarlar.belirme.%s" % s if anahtar == &"belirme_hizi" else "",
			"arayuz.ayarlar.grafik.%s" % s if anahtar == &"grafik_profili" else "",
		]:
			if on_ek != "" and _ceviri_var(on_ek):
				return TranslationServer.translate(on_ek)
		match String(anahtar) + ":" + s:
			"zorluk:kolay": return "Easy" if en else "Kolay"
			"zorluk:olagan": return "Normal" if en else "Olağan"
			"zorluk:siki": return "Severe" if en else "Sıkı"
			"otomatik_kayit:her_gece": return "Every night" if en else "Her gece"
			"otomatik_kayit:uc_gecede_bir": return "Every 3 nights" if en else "3 gecede bir"
			"otomatik_kayit:kapali": return "Off" if en else "Kapalı"
			"satir_araligi:normal": return "Normal"
			"satir_araligi:genis": return "Wide" if en else "Geniş"
			"odak_cercevesi:normal": return "Normal"
			"odak_cercevesi:kalin": return "Thick" if en else "Kalın"
			"renk_paleti:olagan": return "Standard" if en else "Olağan"
			"renk_paleti:deuteranopi": return "Deuteranopi"
			"renk_paleti:protanopi": return "Protanopi"
			"renk_paleti:tritanopi": return "Tritanopi"
		return s
	return str(v)


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
