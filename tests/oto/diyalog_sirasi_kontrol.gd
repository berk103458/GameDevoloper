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
	ana._koye_git()
	await get_tree().process_frame
	var beklenen := ana.oturum.kaydet()
	var ikinci := TestAna.new()
	add_child(ikinci)
	ikinci.kayit = ana.kayit
	ikinci.devam_et()
	await get_tree().process_frame
	while ikinci._kapi_yukleniyor: await get_tree().process_frame
	_kontrol(ikinci._ekran is KoyEkrani and ikinci._kapi == null, "İkinci gerçek Ana: köy ekranı, yeni kapı kuyruğu yok")
	_kontrol(ikinci.oturum != null and ikinci.oturum._gemini_sira == sira and ikinci.oturum.gun == ana.oturum.gun, "Devam: aynı gün/sıra, ek diyalog tüketilmedi (%d)" % sira)
	_kontrol(ikinci.oturum.kaydet().rng == beklenen.rng and ikinci.oturum.kadro.kaydet() == beklenen.kadro, "Devam: RNG/kadro yeni ziyaret tüketmedi")
	# Gerçek gece çözümü ve mevcut Devam sinyali yeni gün kaydını tekrar kapıya taşır.
	var gece := ikinci.oturum.gece_sonu()
	(ikinci._ekran as KoyEkrani).devam_istendi.emit(gece)
	while ikinci._kapi_yukleniyor: await get_tree().process_frame
	_kontrol(ikinci._ekran is KapiEkrani and ikinci.kayit.oku().faz == "kapi", "Gece sonrası yeni gün kapı fazı kaydedilir")
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
