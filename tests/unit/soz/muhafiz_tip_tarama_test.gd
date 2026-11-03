# gdlint: disable=max-line-length
extends SceneTree

func _init() -> void:
	var hatalar: Array[String] = []

	var tipler := ["sert", "merhametli", "kurnaz"]
	var sonlar := {
		"sert": { "kabul": 3, "ret": 7, "isyan_riski": 2 },
		"merhametli": { "kabul": 8, "ret": 2, "kitlik_riski": 3 },
		"kurnaz": { "kabul": 5, "ret": 5, "rusvet_kasasi": 15 }
	}

	for t in tipler:
		var sonuc: Dictionary = sonlar.get(t, {})
		var toplam_karar: int = int(sonuc.get("kabul", 0)) + int(sonuc.get("ret", 0))
		if toplam_karar != 10:
			hatalar.append("%s muhafız tipi için toplam karar 10 değil: %d" % [t, toplam_karar])

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: muhafiz_tip_tarama_test.gd")
	quit(0)
