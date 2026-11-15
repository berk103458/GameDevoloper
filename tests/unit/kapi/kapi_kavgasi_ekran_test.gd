## CAT-01: gerçek KapiEkrani._karar_ver -> Oturum.karar_ver -> metin bağı.
extends Node

class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_cat01.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 45)
		kayit = GuvenliKayit.new("user://unused_cat01.json")
		theme = Tema.olustur(ayarlar)

var hata := 0
func _ready() -> void:
	call_deferred("_calistir")

func _calistir() -> void:
	await get_tree().process_frame
	get_tree().create_timer(45.0).timeout.connect(func() -> void: get_tree().quit(1))
	if await _ekran() != true: hata += 1
	print("KAPI KAVGASI EKRAN: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	get_tree().quit(1 if hata > 0 else 0)

func _ekran() -> bool:
	var ana := TestAna.new()
	add_child(ana)
	ana.ayarlar.degerler[&"karar_onayi"] = false
	var e := KapiEkrani.new()
	e.oturum = ana.oturum
	e.ayarlar = ana.ayarlar
	ana._kapi = e
	ana._goster(e)
	await get_tree().process_frame
	var k := ana.oturum.yonetim.kabul({"ad": "nöbetçi", "sinif": "asker"})
	ana.oturum.yonetim.muhafiz_ata(k.id)
	var g := Gelen.new()
	g.ad_anahtari = "sablon.esnaf.ad1"
	g.giris_anahtari = "sablon.esnaf.giris1"
	preload("res://src/kapi/kapi_kavgasi_adaptoru.gd").kuyruk_hazirla(ana.oturum, [g])
	g.secenekler = PackedStringArray(["ret", "kabul"])
	e._gelen = g
	e._kuyruk.clear()
	e._karar_ver("ret")
	var a = preload("res://src/kapi/kapi_kavgasi_adaptoru.gd").al(ana.oturum)
	if a.son.get("kavga_bayragi", 0) != 1 or not e._kayit.get_parsed_text().contains(KapiKavgasi.YER_TUTUCU_CANLANDIRMA.metin):
		hata += 1
		push_error("Gerçek kapı kararı kavga bayrağını ve arbede metnini üretmeli")
	ana.queue_free()
	await get_tree().process_frame
	return true
