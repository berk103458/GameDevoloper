extends Node
## KVR-SES-01: gerçek kapı akışında ziyaretçi gelince hava/ayaz replikleri açılış satırından önce yazılır.
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_kvr_ses.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 71)
		kayit = GuvenliKayit.new("user://test_kvr_ses.json")
		theme = Tema.olustur(ayarlar)
var hata := 0


func _ready() -> void:
	get_tree().create_timer(120.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var o := ana.oturum
	o.gun = 4
	var e := KapiEkrani.new()
	e.oturum = o
	e.ayarlar = ana.ayarlar
	ana._kapi = e
	ana._goster(e)
	await _kare(3)
	var ayaz := await _ziyaret(e, 3, "normal")
	var ayaz_muhafiz := tr("kapi.hava.ayaz.muhafiz")
	_kontrol(ayaz.contains(ayaz_muhafiz) and (ayaz.contains(tr("kapi.hava.ayaz.ziyaretci.1")) or ayaz.contains(tr("kapi.hava.ayaz.ziyaretci.2"))), "Kış gecesinde muhafız ayaz karşılaması akışta")
	_kontrol(ayaz.find(ayaz_muhafiz) < ayaz.rfind(tr(e._gelen.ad_anahtari) + ":"), "Hava satırı ziyaretçi konuşmasından önce")
	var tipi := await _ziyaret(e, 3, "kar_firtinasi")
	_kontrol(tipi.contains(tr("kapi.hava.firtina.muhafiz")) and not tipi.contains(ayaz_muhafiz), "Kar fırtınası fırtına repliğini seçer")
	var yaz := await _ziyaret(e, 1, "normal")
	_kontrol(not yaz.contains(ayaz_muhafiz) and not yaz.contains(tr("kapi.hava.firtina.muhafiz")) and KapiHavaRepligi.satirlar(o, e._gelen).is_empty(), "Yaz gecesi açık havada hava satırı yok")
	get_tree().quit(1 if hata > 0 else 0)


func _ziyaret(e: KapiEkrani, mevsim: int, hava: String) -> String:
	IklimDeneyi.yukle(e.oturum.yonetim, {"mevsim": mevsim, "hava": hava})
	var g := e.oturum._adli_gelen(&"chr_002")
	e._kuyruk = [g]
	e.evre = &"bekle"
	e._siradaki()
	var bas := Time.get_ticks_msec()
	while e._gelen != g or e.evre != &"sohbet" and e.evre != &"karar":
		await get_tree().process_frame
		if Time.get_ticks_msec() - bas > 15000:
			break
	await _kare(2)
	return e._kayit.get_parsed_text()


func _kare(n: int) -> void:
	for i in n:
		await get_tree().process_frame


func _kontrol(kosul: bool, ad: String) -> void:
	if kosul:
		print("GEÇTİ: ", ad)
	else:
		hata += 1
		push_error("KALDI: " + ad)
