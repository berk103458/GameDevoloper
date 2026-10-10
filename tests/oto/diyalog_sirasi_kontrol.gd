## SYS-16 gerçek akış: kapı günü hazır diyaloglar → köye geçişte gerçek kayıt → yeni Ana "Devam" → aynı sıradan sürer.
extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_sys16.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 1616)
		kayit = GuvenliKayit.new("user://test_sys16_ui.json")
		theme = Tema.olustur(ayarlar)
var hata := 0

func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	for i in 4: ana.oturum._figur_gelen()
	var sira := ana.oturum._gemini_sira
	var beklenen := ana.oturum.kaydet()
	ana._koye_git()
	await get_tree().process_frame
	var ikinci := TestAna.new()
	add_child(ikinci)
	ikinci.kayit = ana.kayit
	ikinci.devam_et()
	await get_tree().process_frame
	while ikinci._kapi_yukleniyor: await get_tree().process_frame
	_kontrol(ikinci.oturum != null and ikinci.oturum._gemini_sira >= sira, "Devam: diyalog sırası kayıttan döndü (%d)" % sira)
	var o2 := Oturum.kayittan(ana.katalog, beklenen)
	_kontrol(o2._figur_gelen().giris_anahtari == ana.oturum._figur_gelen().giris_anahtari, "Kaldığı diyalogdan sürer")
	ana.kayit.sil()
	ana.queue_free()
	ikinci.queue_free()
	await get_tree().process_frame
	print("DIYALOG SIRASI UI: GEÇTİ" if hata == 0 else "DIYALOG SIRASI UI: KALDI")
	await Ses.cik(hata)

func _kontrol(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
