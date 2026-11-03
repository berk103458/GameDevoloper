# gdlint: disable=max-line-length
extends SceneTree

const CeliskiYuzlesme = preload("res://src/soz/celiski_yuzlesme.gd")
const SozMotoru = preload("res://src/soz/soz_motoru.gd")

func _init() -> void:
	var hatalar: Array[String] = []

	var dosya := {
		"konusmaci": "chr_010",
		"cekirdek": "koruma_yalani",
		"ipucu_id": "clue_cocuk_carigi",
		"dugumler": {
			"giris": {
				"id": "giris",
				"satir": "Selam.",
				"beyan": { "id": "b_yalniz", "metin": "Yalnızım", "dogru": false, "kanit_id": "clue_cocuk_carigi" },
				"secenekler": []
			},
			"yuzlesme": {
				"id": "yuzlesme",
				"satir": "İtiraf ediyorum, çocuk çalılıkta!",
				"secenekler": []
			}
		}
	}

	var motor := SozMotoru.new()
	motor.yukle(dosya)

	var beyan_kaydi := { "id": "b_yalniz", "kanit_id": "clue_cocuk_carigi", "dogru": false }
	var kanit_kaydi := { "id": "clue_cocuk_carigi", "ipucu_id": "clue_cocuk_carigi" }

	# 1. Çelişen kayıtlar eşleşince yüzleşme düğümü açılır (Kabul)
	var sonuc := CeliskiYuzlesme.eslestir(beyan_kaydi, kanit_kaydi, motor)
	if not sonuc.get("basarili", false) or not sonuc.get("yuzlesme_acildi", false):
		hatalar.append("Çelişki eşleştiğinde yüzleşme düğümü açılmadı!")
	if motor.mevcut_satir() != "İtiraf ediyorum, çocuk çalılıkta!":
		hatalar.append("Yüzleşme sonrası satır değişmedi: '%s'" % motor.mevcut_satir())

	# 2. Yanlış eşleştirme güveni düşürür
	var baslangic_guven := motor.guven
	var yanlis_sonuc := CeliskiYuzlesme.eslestir({"id": "alakasiz"}, {"id": "baska"}, motor)
	if yanlis_sonuc.get("basarili", true):
		hatalar.append("Alakasız kayıtlar çelişki olarak kabul edildi!")
	if motor.guven != baslangic_guven - 1:
		hatalar.append("Yanlış eşleştirme güveni düşürmedi! (Eski: %d, Yeni: %d)" % [baslangic_guven, motor.guven])

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: celiski_yuzlesme_test.gd")
	quit(0)
