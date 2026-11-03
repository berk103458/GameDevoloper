# gdlint: disable=max-line-length
extends SceneTree

const SozSemasi = preload("res://src/soz/soz_semasi.gd")

func _init() -> void:
	var hatalar: Array[String] = []

	# 1. ornek_durust.json ipucusuz geçer
	var dosya_durust := FileAccess.open("res://data/soz/ornek_durust.json", FileAccess.READ)
	if not dosya_durust:
		hatalar.append("ornek_durust.json açılamadı!")
	else:
		var parsed_durust = JSON.parse_string(dosya_durust.get_as_text())
		var err_durust := SozSemasi.dogrula(parsed_durust)
		if not err_durust.is_empty():
			hatalar.append("Dürüst örnek geçerli sayılmadı: %s" % str(err_durust))

	# 2. İpucusuz koruma yalanı geçmez
	var dosya_yalan := FileAccess.open("res://data/soz/ornek_koruma_yalani.json", FileAccess.READ)
	if not dosya_yalan:
		hatalar.append("ornek_koruma_yalani.json açılamadı!")
	else:
		var parsed_yalan = JSON.parse_string(dosya_yalan.get_as_text())
		# Geçerli hali
		var err_yalan := SozSemasi.dogrula(parsed_yalan)
		if not err_yalan.is_empty():
			hatalar.append("Geçerli koruma yalanı hata verdi: %s" % str(err_yalan))

		# İpucusu silinince hata vermeli
		var parsed_yalan_ipucusuz: Dictionary = parsed_yalan.duplicate(true)
		parsed_yalan_ipucusuz.erase("ipucu_id")
		var err_ipucusuz := SozSemasi.dogrula(parsed_yalan_ipucusuz)
		if not ("sir_cekirdegi_ipucusuz_gecemez" in err_ipucusuz):
			hatalar.append("İpucusuz koruma yalanı şemadan geçti! (Hata bekleniyordu)")

	# 3. ornek_hatali.json hataları kontrolü
	var dosya_hatali := FileAccess.open("res://data/soz/ornek_hatali.json", FileAccess.READ)
	if not dosya_hatali:
		hatalar.append("ornek_hatali.json açılamadı!")
	else:
		var parsed_hatali = JSON.parse_string(dosya_hatali.get_as_text())
		var err_hatali := SozSemasi.dogrula(parsed_hatali)

		var kadro_var := false
		var cift_secenek_var := false
		var kendine_kenar_var := false
		var ikinci_giris_var := false
		var tavan_asimi_var := false

		for e in err_hatali:
			if "kadroda_olmayan_konusmaci" in e:
				kadro_var = true
			if "cift_secenek_kimligi" in e:
				cift_secenek_var = true
			if "kendine_kenar_veren" in e:
				kendine_kenar_var = true
			if "birden_fazla_veya_eksik_giris" in e:
				ikinci_giris_var = true
			if "derinlik_tavani_asildi" in e:
				tavan_asimi_var = true

		if not kadro_var:
			hatalar.append("Kadroda olmayan konuşmacı hatası tespit edilemedi!")
		if not cift_secenek_var:
			hatalar.append("Çift seçenek kimliği hatası tespit edilemedi!")
		if not kendine_kenar_var:
			hatalar.append("Kendine kenar verme hatası tespit edilemedi!")
		if not ikinci_giris_var:
			hatalar.append("İkinci giriş hatası tespit edilemedi!")
		if not tavan_asimi_var:
			hatalar.append("Derinlik tavanı aşımı hatası tespit edilemedi!")

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: sema_test.gd")
	quit(0)
