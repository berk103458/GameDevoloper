# gdlint: disable=max-line-length
extends SceneTree

const SozVerme = preload("res://src/soz/soz_verme.gd")

func _init() -> void:
	var hatalar: Array[String] = []

	var sistem := SozVerme.new()

	# 1. Söz verme kaydı
	sistem.soz_ver("chr_014", "as_verme", 2, 1) # Gün 1'de verildi, bitiş: Gün 3
	if sistem.acik_sozler.is_empty():
		hatalar.append("Söz kaydı listeye eklenmedi!")

	# 2. Söz tutulduğunda güven +3
	var tutuldu_sonuc := sistem.soz_tutuldu("chr_014", "as_verme")
	if not tutuldu_sonuc.get("basarili", false) or tutuldu_sonuc.get("guven_etkisi") != 3:
		hatalar.append("Tutulan söz güven +3 vermedi!")

	# 3. Süre dolunca tutulmayan söz güven -5 ve dedikodu üretir
	sistem.soz_ver("chr_015", "usta_yapma", 2, 1) # Bitiş gün 3
	var gun2_sonuc := sistem.gun_ilerlet(2) # Henüz dolmadı
	if not gun2_sonuc.is_empty():
		hatalar.append("Vakti gelmeden söz bozuldu sayıldı!")

	var gun4_sonuc := sistem.gun_ilerlet(4) # Gün 4'te süre aşıldı
	if gun4_sonuc.is_empty():
		hatalar.append("Süresi geçen söz bozulmadı!")
	elif gun4_sonuc[0].get("guven_etkisi") != -5 or gun4_sonuc[0].get("terazi") != "tutulmayan_soz":
		hatalar.append("Bozulan söz güven -5 ve terazi kaydı üretmedi!")

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: soz_verme_test.gd")
	quit(0)
