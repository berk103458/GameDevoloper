## Ses: olayların andığı dosyalar var; müzik ve ortam geçişi adı değiştirir. Düz betik:
##   godot --headless --path . -s tests/unit/ses/ses_test.gd   (çıkış 0 = geçti)
extends SceneTree

const SES := preload("res://src/sistemler/ses.gd")

var _hata := 0


func _init() -> void:
	var k := Katalog.new()
	if k.yukle() != Katalog.Durum.HAZIR:
		print("katalog yüklenemedi: ", k.hatalar)
		quit(1)
		return
	# Her olayın andığı efekt ve müzik dosyası var.
	var olaylar: Array = k.olaylar() + k.sira_olaylari()
	var anilan := 0
	for o: OlayVerisi in olaylar:
		for ad in [o.ses, o.muzik]:
			if ad != &"":
				anilan += 1
				_esit("dosya %s (%s)" % [ad, o.id], ResourceLoader.exists(SES.KOK + String(ad) + ".wav"), true)
	_esit("düğün müziği anılıyor", olaylar.any(func(o: OlayVerisi) -> bool: return o.muzik == &"muzik_dugun_dongu"), true)
	_esit("en az bir olay sesi", anilan > 5, true)
	_esit("köy ortamı dosyası", ResourceLoader.exists(SES.KOK + "ortam_koy_dongu.wav"), true)
	process_frame.connect(_gecis_dene, CONNECT_ONE_SHOT)


func _gecis_dene() -> void:
	var s: Node = SES.new()
	root.add_child(s)
	s.dongu_baslat()
	_esit("varsayılan müzik", s.muzik_adi(), SES.VARSAYILAN_MUZIK)
	s.muzik_cal(&"muzik_dugun_dongu")
	_esit("düğün müziği", s.muzik_adi(), &"muzik_dugun_dongu")
	s.muzik_cal(&"")
	_esit("müzik geri", s.muzik_adi(), SES.VARSAYILAN_MUZIK)
	s.ortam_cal(&"ortam_koy_dongu")
	_esit("köy ortamı", s.ortam_adi(), &"ortam_koy_dongu")
	s.muzik_cal(&"olmayan_dosya")
	_esit("olmayan dosya müziği değiştirmez", s.muzik_adi(), SES.VARSAYILAN_MUZIK)
	# Çıkıştan önce susturulur: ses sunucusu çalan döngüleri bırakır (kapanışta sızıntı bildirilmez).
	await s.sustur()
	_esit("susturuldu", s.muzik_adi(), &"")
	print("SES TEST: %s (%d hata)" % ["GEÇTİ" if _hata == 0 else "KALDI", _hata])
	quit(1 if _hata > 0 else 0)


func _esit(ad: String, gercek: Variant, beklenen: Variant) -> void:
	if gercek != beklenen:
		_hata += 1
		print("  KALDI %s: %s != %s" % [ad, gercek, beklenen])
