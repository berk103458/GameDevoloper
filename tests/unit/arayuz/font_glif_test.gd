extends SceneTree
## YER-12: Alegreya gövde fontu Türkçe glifleri taşır; ı İ ş ğ ü ö ç (büyükleriyle) kutuya düşmez.
## Ölçüm tema.gd'nin fontuyla yapılır; yeni font indirilmez.

const HARFLER := "ıİşŞğĞüÜöÖçÇ"
var hata := 0


func _initialize() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	for italik in [false, true]:
		var f: Font = Tema.font(400, italik)
		_kontrol(f != null, "Tema fontu yüklenir (italik=%s)" % italik)
		if f == null:
			continue
		for i in HARFLER.length():
			var kod := HARFLER.unicode_at(i)
			_kontrol(f.has_char(kod), "Glif var: %s (italik=%s)" % [HARFLER[i], italik])
			_kontrol(f.get_char_size(kod, 24) != Vector2.ZERO, "Glif boyutu 0 değil: %s (italik=%s)" % [HARFLER[i], italik])
	# Kural gerçek eksik glifi yakalar: Alegreya'da olmayan bir CJK karakteri.
	var gercek: Font = Tema.font(400)
	if gercek != null:
		_kontrol(not gercek.has_char("漢".unicode_at(0)), "Olmayan glif has_char ile yakalanır")
	await process_frame
	print("FONT GLİF: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)


func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
