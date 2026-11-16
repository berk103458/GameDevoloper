## Köy gündüz/gece ses bağlantısı; test oturumu kullanıcı kaydına yazılmaz.
extends Node

var _hata := 0

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
	_dene(Ses.ortam_adi() == &"ortam_koy_gunduz" and Ses.ortam_busu_adi() == &"Ortam", "koy_ortam_kontrol.gd:14")
	ekran._geceye_gec()
	_dene(Ses.ortam_adi() == &"ortam_koy_gece", "koy_ortam_kontrol.gd:16")
	await Ses.sustur()
	ekran.queue_free()
	await get_tree().process_frame
	_dene(Ses.ortam_busu_adi() == &"Ortam", "koy_ortam_kontrol.gd:20")
	print("KÖY ORTAM UI: GEÇTİ" if _hata == 0 else "KÖY ORTAM UI: KALDI (%d hata)" % _hata)
	get_tree().quit(1 if _hata > 0 else 0)


func _dene(kosul: bool, ad: String) -> void:
	if not kosul:
		_hata += 1
		push_error(ad)
