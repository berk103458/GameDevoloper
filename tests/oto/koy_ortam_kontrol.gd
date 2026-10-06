## Köy gündüz/gece ses bağlantısı; test oturumu kullanıcı kaydına yazılmaz.
extends Node

func _ready() -> void:
	get_tree().create_timer(20).timeout.connect(func() -> void: get_tree().quit(1))
	var katalog := Katalog.new()
	katalog.yukle()
	var ekran := KoyEkrani.new()
	ekran.oturum = Oturum.new(katalog, 55)
	ekran.ayarlar = Ayarlar.new()
	ekran.theme = Tema.olustur(ekran.ayarlar)
	add_child(ekran)
	ekran.ortam_baslat()
	assert(Ses.ortam_adi() == &"ortam_koy_gunduz" and Ses.ortam_busu_adi() == &"Ambiance")
	ekran._geceye_gec()
	assert(Ses.ortam_adi() == &"ortam_koy_gece")
	await Ses.sustur()
	ekran.queue_free()
	await get_tree().process_frame
	assert(Ses.ortam_busu_adi() == &"Efekt")
	print("KÖY ORTAM UI: GEÇTİ")
	get_tree().quit(0)
