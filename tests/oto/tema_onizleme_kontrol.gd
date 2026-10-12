## ARY-01: önizleme sahnesi üç şablonu sorgu, harita ve kart yer tutucusunda kurar (3 × 3 = 9 ekran).
extends Node
var hata := 0


func _ready() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	get_tree().create_timer(30.0).timeout.connect(func() -> void: get_tree().quit(1))
	var sahne: TemaOnizleme = load("res://src/arayuz/tema_onizleme.tscn").instantiate()
	add_child(sahne)
	await get_tree().process_frame
	_kontrol(sahne.veri.get("sablonlar", []).size() == 3, "Üç şablon okunur")
	_kontrol(sahne.ekranlar.size() == 9, "Dokuz yer tutucu ekran kurulur")
	for kimlik in ["cini", "parsomen", "ocak"]:
		for ekran in ["sorgu", "harita", "kart"]:
			_kontrol(sahne.find_child("%s_%s" % [kimlik, ekran], true, false) != null, "Ekran var: %s_%s" % [kimlik, ekran])
	var dugmeler := sahne.find_children("dugme_*", "Button", true, false)
	_kontrol(dugmeler.size() == 12, "Her şablonda dört düğme durumu (12)")
	sahne.queue_free()
	await get_tree().process_frame
	print("TEMA ÖNİZLEME: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	await Ses.cik(hata)


func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
