## KAP-48: Rüşvet düğmesi OyunAyarlari.rusvet_hakki değerine göre kapanır; ikinci rüşvet uygulanmaz.
extends Node

var _hata := 0


func dene(kosul: bool, mesaj: String) -> void:
	if kosul:
		return
	_hata += 1
	push_error("KAP-48 HATA: " + mesaj)


func _rusvet_gelen(o: Oturum) -> Gelen:
	var g := o._figur_sablon()
	g.heybe = Heybe.new()
	g.secenekler = PackedStringArray(["kabul", "rusvet", "ret"])
	g.esikler = PackedInt32Array([0, 0, 0])
	return g


func _ready() -> void:
	get_tree().create_timer(25.0).timeout.connect(func() -> void: get_tree().quit(1))
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 1948)
	o.gun = 3
	o.ayarlar = o.ayarlar.duplicate() as OyunAyarlari
	o.ayarlar.rusvet_hakki = 1

	var ke := KapiEkrani.new()
	ke.oturum = o
	ke.ayarlar = Ayarlar.new("user://unused_kap48.cfg")
	ke.ayarlar.degerler[&"belirme_hizi"] = &"aninda"
	add_child(ke)
	await get_tree().process_frame

	# 1. İlk rüşvet hakkı açık: düğme etkin ve 1. rüşvet uygulanır.
	ke._gelen = _rusvet_gelen(o)
	ke._karar_goster()
	await get_tree().process_frame
	var r_idx := ke._karar_anahtarlari.find("rusvet")
	dene(r_idx >= 0, "Ilk gelen icin rusvet dugmesi olmali")
	var btn1 := ke._karar_dugmeleri[r_idx]
	dene(not btn1.disabled, "rusvet_hakki=1 iken ilk rusvet dugmesi acik olmali")
	btn1.pressed.emit()
	btn1.pressed.emit()
	dene(int(o.bayraklar.get(&"rusvet_sayisi", 0)) == 1, "Ilk rusvet bayragi 1 yazilmali")
	var kasa_ilk := o.muhafiz_akce

	# 2. İkinci rüşvet denemesi: düğme kapalıdır ve ikinci rüşvet yazılmaz.
	ke._gelen = _rusvet_gelen(o)
	ke._karar_goster()
	await get_tree().process_frame
	var r_idx2 := ke._karar_anahtarlari.find("rusvet")
	var btn2 := ke._karar_dugmeleri[r_idx2]
	dene(btn2.disabled, "rusvet_hakki=1 iken ikinci rusvet denemesinde dugme kapali olmali")
	btn2.pressed.emit()
	btn2.pressed.emit()
	ke._karar_bas("rusvet")
	ke._karar_bas("rusvet")
	ke._karar_ver("rusvet")
	dene(int(o.bayraklar.get(&"rusvet_sayisi", 0)) == 1 and o.muhafiz_akce == kasa_ilk, "Ikinci rusvet etki yazmamali")

	var gece_raporu := o.gece_sonu()
	dene(int(o.bayraklar.get(&"rusvet_sayisi", 0)) == 1 and int(gece_raporu.get("bilanco", {}).get("rusvet_sayisi", o.bayraklar.get(&"rusvet_sayisi", 0))) == 1, "Gece sonuna ikinci rusvet yazilmaz")

	# 3. Ayar rusvet_hakki=2 yapılınca düğme tekrar açılır (sabit gömülü değil).
	o.ayarlar.rusvet_hakki = 2
	ke._gelen = _rusvet_gelen(o)
	ke._karar_goster()
	await get_tree().process_frame
	var btn3 := ke._karar_dugmeleri[ke._karar_anahtarlari.find("rusvet")]
	dene(not btn3.disabled, "rusvet_hakki=2 iken dugme yeniden acilmali")

	var kapi_kaynak := FileAccess.get_file_as_string("res://src/arayuz/kapi_ekrani.gd")
	dene(kapi_kaynak.contains("rusvet_hakki"), "kapi_ekrani.gd rusvet_hakki ayarini okumali")

	ke.queue_free()
	await get_tree().process_frame
	print("RUSVET HAKKI: %s" % ("GEÇTİ" if _hata == 0 else "KALDI (%d hata)" % _hata))
	get_tree().quit(0 if _hata == 0 else 1)
