extends Node
## AYR-11: gerçek kapı ekranında 20 satırlık sorgu sağ çubuk ve fare tekeriyle ilk satıra kaydırılır.
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_konusma_gecmisi.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 45)
		kayit = GuvenliKayit.new("user://test_konusma_gecmisi.json")
		theme = Tema.olustur(ayarlar)
var hata := 0


func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var e := KapiEkrani.new()
	e.oturum = ana.oturum
	e.ayarlar = ana.ayarlar
	ana._kapi = e
	ana._goster(e)
	e._gelen = ana.oturum._adli_gelen(&"chr_001")
	e._sohbet_goster()
	e._tumunu_goster()
	var kayit: RichTextLabel = e._kayit
	kayit.clear()
	for i in 20:
		e._yaz("sorgu satırı %d" % i)
	await _kare(4)
	var cubuk := kayit.get_v_scroll_bar()
	_kontrol(cubuk.max_value > cubuk.page and KonusmaGecmisi.sonda_mi(kayit), "20 satır kutuya sığmaz, akış son satırda")
	for n in 60:
		get_viewport().push_input(_cubuk(-1.0))
		if KonusmaGecmisi.ilk_satirda_mi(kayit):
			break
	await _kare(1)
	_kontrol(KonusmaGecmisi.ilk_satirda_mi(kayit) and not kayit.scroll_following, "Sağ çubuk yukarı ilk satıra döner, takip durur")
	e._yaz("yeni satır")
	await _kare(2)
	_kontrol(KonusmaGecmisi.ilk_satirda_mi(kayit), "Geriye okurken gelen satır okuru sona sürüklemez")
	for n in 80:
		get_viewport().push_input(_cubuk(1.0))
	await _kare(1)
	_kontrol(KonusmaGecmisi.sonda_mi(kayit) and kayit.scroll_following, "Sağ çubuk aşağı sona iner, takip geri açılır")
	var teker := InputEventMouseButton.new()
	teker.button_index = MOUSE_BUTTON_WHEEL_UP
	teker.pressed = true
	teker.position = kayit.get_global_rect().get_center()
	teker.global_position = teker.position
	var once := cubuk.value
	for n in 60:
		get_viewport().push_input(teker, true)
	await _kare(2)
	_kontrol(cubuk.value < once and KonusmaGecmisi.ilk_satirda_mi(kayit), "Fare tekeri aynı akışta ilk satıra çıkar")
	e._sohbet_goster()
	await _kare(2)
	_kontrol(kayit.scroll_following, "Yeni ziyaret akışı takiple başlar")
	get_tree().quit(1 if hata > 0 else 0)


func _cubuk(deger: float) -> InputEventJoypadMotion:
	var o := InputEventJoypadMotion.new()
	o.axis = JOY_AXIS_RIGHT_Y
	o.axis_value = deger
	return o


func _kare(n: int) -> void:
	for i in n:
		await get_tree().process_frame


func _kontrol(kosul: bool, ad: String) -> void:
	if kosul:
		print("GEÇTİ: ", ad)
	else:
		hata += 1
		push_error("KALDI: " + ad)
