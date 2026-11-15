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

	# Gercek oyun baglantisi: Oturum kaydet/yukle + Bolum 39 HafizaDefteri + Ana._son_goster
	var kat := Katalog.new()
	_kontrol(kat.yukle() == Katalog.Durum.HAZIR, "Katalog yuklenmeli")
	var o := Oturum.new(kat, 19)
	o.son_verisi_isle({"nihai": "uc_tutundu", "baslik": "Uç tutundu", "metin": "Sınır ayakta.", "epilog": "Uzun epilog..."})
	var ham_kayit := o.kaydet()
	_kontrol(SonKaydiSinifi.kayittan_nihai_al(ham_kayit) == &"uc_tutundu", "Oturum.kaydet son.nihai yazmali")
	_kontrol(SonKaydiSinifi.kayittan_epilog_al(ham_kayit) == "Uzun epilog...", "Oturum.kaydet epilog yazmali")
	var yuklenen := Oturum.kayittan(kat, ham_kayit)
	_kontrol(yuklenen != null, "Oturum.kayittan son verisiyle yuklenmeli")
	if yuklenen != null:
		_kontrol(yuklenen.son_kaydi.nihai == &"uc_tutundu", "Yuklenen oturum son_kaydi.nihai okumali")
		_kontrol(yuklenen.son_kaydi.epilog == "Uzun epilog...", "Yuklenen oturum epilogu okumali")

	var kayitsiz := ham_kayit.duplicate(true)
	kayitsiz.erase("son")
	var eski_oturum := Oturum.kayittan(kat, kayitsiz)
	_kontrol(eski_oturum != null and eski_oturum.son_kaydi.nihai == &"" and eski_oturum.son_kaydi.epilog == "", "Eski kayitta son yoksa bos kalmali")

	var kaynak := HafizaDefteriBaglantisi.kaynak_derle(o)
	var defter := HafizaDefteri.new()
	var okunan := defter.oku(kaynak)
	var not_satirlari: Array = okunan.get("not", [])
	_kontrol(not_satirlari.any(func(s: Variant) -> bool: return s is Dictionary and String((s as Dictionary).get("nihai", "")) == "uc_tutundu"), "HafizaDefteri not sayfasinda son satiri olmali")
	var son_okuma := defter.son_kaydi_oku(kaynak)
	_kontrol(String(son_okuma.get("epilog", "")) == "Uzun epilog...", "HafizaDefteri epilogu yeniden okuyabilmeli")

	var ana_kod := FileAccess.get_file_as_string("res://src/arayuz/ana.gd")
	_kontrol(ana_kod.contains("son_verisi_isle") and ana_kod.contains("SonKaydi.kayda_son_ekle"), "Ana._son_goster SonKaydi baglantisi icermeli")

	if _hata == 0:
		print("SON KAYDI (OMR-17): GEÇTİ (0 hata)")
	else:
		print("SON KAYDI: KALDI (%d hata)" % _hata)
	quit(_hata)
