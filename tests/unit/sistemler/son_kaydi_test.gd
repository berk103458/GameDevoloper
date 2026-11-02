extends SceneTree

const SonKaydiSinifi = preload("res://src/sistemler/son_kaydi.gd")

var _hata: int = 0


func _kontrol(kosul: bool, mesaj: String) -> void:
	if not kosul:
		_hata += 1
		push_error("SON KAYDI TEST HATASI: " + mesaj)


func _initialize() -> void:
	# OMR-17: son_metni donusundeki nihai alani oyun kaydina yazilir
	var sahte_son_metni := {
		"nihai": &"ahi_kasabasi",
		"baslik": "Ahi Kasabası",
		"metin": "Uç kasabası ahi ahlakıyla yönetildi.",
		"epilog": "Epilog satırları...",
	}

	var kayit := {}
	SonKaydiSinifi.kayda_son_ekle(kayit, sahte_son_metni)

	_kontrol(kayit.has("son"), "Kayit sozlügünde 'son' bolumu olmali")
	_kontrol(kayit["son"].has("nihai"), "Kayit sozlügünde 'son.nihai' alani olmali")
	_kontrol(kayit["son"]["nihai"] == "ahi_kasabasi", "Nihai son kimligi dogru yazilmali")

	# Epilog ve nihai sonradan okunabilmeli
	var okunan_nihai := SonKaydiSinifi.kayittan_nihai_al(kayit)
	var okunan_epilog := SonKaydiSinifi.kayittan_epilog_al(kayit)
	_kontrol(okunan_nihai == &"ahi_kasabasi", "Kayittan okunan nihai son dogru olmali")
	_kontrol(okunan_epilog == "Epilog satırları...", "Kayittan okunan epilog metni dogru olmali")

	# Kabul: eski kayitta alan yoksa bos, oyun cokmez
	var eski_kayit := {"yonetim": {"nufus": 10}}
	var bos_nihai := SonKaydiSinifi.kayittan_nihai_al(eski_kayit)
	var bos_epilog := SonKaydiSinifi.kayittan_epilog_al(eski_kayit)
	_kontrol(bos_nihai == &"", "Eski kayitta nihai bos olmali")
	_kontrol(bos_epilog.is_empty(), "Eski kayitta epilog bos string olmali")

	var sk := SonKaydiSinifi.new()
	_kontrol(sk.kayittan_oku(eski_kayit), "Eski kayit yuklenirken cokmemeli")
	_kontrol(sk.nihai == &"", "Nesne nihai bos olmali")

	if _hata == 0:
		print("SON KAYDI (OMR-17): GEÇTİ (0 hata)")
	else:
		print("SON KAYDI: KALDI (%d hata)" % _hata)
	quit(_hata)
