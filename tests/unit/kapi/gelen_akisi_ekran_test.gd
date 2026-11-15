extends Node

var _hata := 0


func dene(kosul: bool, mesaj: String) -> void:
	if kosul:
		return
	_hata += 1
	push_error("KAP-16 EKRAN HATA: " + mesaj)


func _ready() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var ogz := Oturum.new(kat, 1001)
	var ke := KapiEkrani.new()
	ke.oturum = ogz
	ke.ayarlar = Ayarlar.new("user://unused_kap16_ui.cfg")
	add_child(ke)
	var gecis_say := [0]
	ke.gece_bitti.connect(func(_r: Dictionary) -> void: gecis_say[0] += 1)
	ke._kuyruk = []
	ke._siradaki()
	dene(gecis_say[0] == 1, "Kuyruk bossa faz koye (gece_bitti) gecer")
	var test_g := Gelen.new()
	test_g.id = &"chr_001"
	test_g.ad_anahtari = "test.kap16"
	test_g.sinif = &"koylu"
	ke._gelen = test_g
	var bekleyen_g := Gelen.new()
	bekleyen_g.id = &"chr_002"
	ke._kuyruk = [bekleyen_g]
	ke.evre = &"sohbet"
	ke._siradaki()
	dene(ke._gelen == test_g and ke._kuyruk.size() == 1, "Sohbet bitmeden kuyruk ilerlemez")
	ke.evre = &"karar"
	ke._siradaki()
	dene(ke._gelen == test_g and ke._kuyruk.size() == 1, "Karar bitmeden kuyruk ilerlemez")
	ke.process_mode = Node.PROCESS_MODE_DISABLED
	ke.process_mode = Node.PROCESS_MODE_INHERIT
	dene(ke._gelen == test_g and ke._gelen.id == &"chr_001", "Duraklatip devam edince acik kisinin kimligi degismez")
	print("GELEN AKISI EKRAN: %s" % ("GEÇTİ" if _hata == 0 else "KALDI (%d hata)" % _hata))
	get_tree().quit(0 if _hata == 0 else 1)
