# gdlint: disable=max-line-length
extends SceneTree

const BeyanDefteri = preload("res://src/soz/beyan_defteri.gd")
const SozMotoru = preload("res://src/soz/soz_motoru.gd")

func _init() -> void:
	var hatalar: Array[String] = []

	var defter := BeyanDefteri.new()
	defter.beyan_ekle("b1", "Karaköy'den geldim", true, "ipucu_muhur")
	defter.beyan_ekle("b2", "Heybemde sadece ekmek var", false, "ipucu_altin")

	# 1. Beyan deftere kaydedilir
	var tum := defter.tum_beyanlar()
	if tum.size() != 2:
		hatalar.append("Beyanlar deftere eklenemedi! Boyut: %d" % tum.size())

	# 2. Tekil beyan çekme
	var b1 := defter.beyan_al("b1")
	if b1.get("metin") != "Karaköy'den geldim" or not b1.get("dogru"):
		hatalar.append("Beyan b1 doğru okunamadı!")

	# 3. Mükerrer beyan engeli
	defter.beyan_ekle("b1", "Farklı metin", true)
	if defter.tum_beyanlar().size() != 2:
		hatalar.append("Mükerrer beyan engellenemedi!")

	# 4. SozMotoru ile entegrasyon testi
	var dosya := {
		"konusmaci": "chr_009",
		"cekirdek": "durust",
		"dugumler": {
			"giris": {
				"id": "giris",
				"satir": "Selam",
				"beyan": { "id": "b_otomatik", "metin": "Ben rençberim", "dogru": true },
				"secenekler": []
			}
		}
	}
	var motor := SozMotoru.new()
	motor.yukle(dosya)
	if motor.beyan_defteri.is_empty():
		hatalar.append("Düğümdeki beyan SozMotoru beyan defterine işlenmedi!")
	elif motor.beyan_defteri[0].get("id") != "b_otomatik":
		hatalar.append("Motor beyan kimliği uyuşmuyor: %s" % motor.beyan_defteri[0].get("id"))

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: beyan_defteri_test.gd")
	quit(0)
