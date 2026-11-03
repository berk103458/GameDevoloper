# gdlint: disable=max-line-length
extends SceneTree

const MuhafizYalani = preload("res://src/soz/muhafiz_yalani.gd")

func _init() -> void:
	var hatalar: Array[String] = []

	var chr := { "sezgi_esigi": 6 }

	# 1. Zar sezgi eşiğini geçerse yalan yakalanır
	var res_yakalandi := MuhafizYalani.yalan_soyle("koyde_veba_var", chr, {}, 7)
	if not res_yakalandi.get("yakalandi", false):
		hatalar.append("Zar 7 >= 6 iken yalan yakalanmadı!")
	if res_yakalandi.get("guven_farki") != -3:
		hatalar.append("Yakalanan yalan güveni -3 düşürmedi!")
	if res_yakalandi.get("tansiyon_farki") != 2:
		hatalar.append("Yakalanan yalan tansiyonu +2 artırmadı!")

	# 2. Zar sezgi eşiğinin altındaysa inanılır
	var res_inandirici := MuhafizYalani.yalan_soyle("asker_geliyor", chr, {}, 4)
	if res_inandirici.get("yakalandi", true):
		hatalar.append("Zar 4 < 6 iken yalan yakalandı sayıldı!")
	if res_inandirici.get("guven_farki") != 0:
		hatalar.append("İnandırıcı yalan haksız güven düşürdü!")

	# 3. Yalan dogru: false olarak kaydolur
	var beyan: Dictionary = res_inandirici.get("beyan_kaydi", {})
	if beyan.get("dogru", true) != false:
		hatalar.append("Muhafız yalanı 'dogru: false' olarak kaydedilmedi!")

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: muhafiz_yalani_test.gd")
	quit(0)
