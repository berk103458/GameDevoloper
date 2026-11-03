# gdlint: disable=max-line-length
extends SceneTree

func _init() -> void:
	var hatalar: Array[String] = []

	var dosya := FileAccess.open("res://data/soz/kadro_ozgunluk.json", FileAccess.READ)
	if not dosya:
		hatalar.append("kadro_ozgunluk.json açılamadı!")
		quit(1)
		return

	var parsed = JSON.parse_string(dosya.get_as_text())
	var dagilim: Dictionary = parsed.get("cekirdek_dagilimi", {})
	var toplam: int = int(parsed.get("toplam_karakter", 30))

	var sir_sayisi: int = int(dagilim.get("koruma_yalani", 0)) + int(dagilim.get("baskasinin_sirri", 0)) + int(dagilim.get("tehlikeli_yalan", 0))

	# Kadronun yarısından fazlası sır evresi kullanamaz
	if float(sir_sayisi) / float(toplam) > 0.5:
		hatalar.append("YAZ-09 ihlali: Sır çekirdeği oranı %%50'yi aştı! (%d / %d)" % [sir_sayisi, toplam])

	# Kişi adları çevrilmez kuralı (YAZ-79)
	if not parsed.get("kisi_adlari_cevrilemez", false):
		hatalar.append("YAZ-79 kuralı doğrulanmadı: kişi adları çevrilemez kuralı eksik!")

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: ozgunluk_denetimi_test.gd")
	quit(0)
