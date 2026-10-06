## Gerçek CHR kaynaklarının derlenmiş Resource kabul testi.
extends SceneTree

const Sozlesme = preload("res://src/veri/chr_sozlesmesi.gd")
var hata := 0

func _initialize() -> void:
	for n in range(1, 31):
		var kimlik := "CHR_%03d" % n
		var k := load("res://data/chr_runtime/%s.tres" % kimlik) as KarakterVerisi
		if k == null:
			_hata("%s yüklenemedi" % kimlik)
			continue
		if String(k.entity_id) != kimlik or k.ad.is_empty() or k.en_erken_tur < 1:
			_hata("%s kimlik/erken tur" % kimlik)
		for mesaj in Sozlesme.diyalog_hatalari(k.diyalog_dugumleri):
			_hata("%s: %s" % [kimlik, mesaj])
		for mesaj in Sozlesme.karar_hatalari(k.karar_matrisi):
			_hata("%s: %s" % [kimlik, mesaj])
		for mesaj in Sozlesme.bayrak_hatalari(k.sorgu_bayraklari):
			_hata("%s: %s" % [kimlik, mesaj])
		for mesaj in Sozlesme.gecikmeli_hatalari(k.gecikmeli_etkiler):
			_hata("%s: %s" % [kimlik, mesaj])
		for mesaj in Sozlesme.spawn_hatalari(k.sonraki_spawns):
			_hata("%s: %s" % [kimlik, mesaj])
		for dugum in k.diyalog_dugumleri.values():
			if not k.metinler.has(dugum["replik_anahtari"]):
				_hata("%s replik metni eksik" % kimlik)
			for secenek in dugum["secenekler"]:
				if not k.metinler.has(secenek["metin_anahtari"]):
					_hata("%s seçenek metni eksik" % kimlik)
		if k.obje_ipucu(1) == &"" or k.obje_ipucu(2) == &"" or k.gorsel_hata_ipucu == &"":
			_hata("%s ipucu eksik" % kimlik)
		if not k.obje_1["uretilen_ipucu"] is StringName or not k.obje_2["uretilen_ipucu"] is StringName:
			_hata("%s sözlük ipucu StringName değil" % kimlik)
	var hamza := load("res://data/chr_runtime/CHR_001.tres") as KarakterVerisi
	if hamza != null and hamza.karar_verisi(&"rusvet")["muhafiz_akce"] != 4:
		_hata("Kişisel rüşvet kayboldu")
	print("CHR DERLEME: %s (%d hata; 30 karakter)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)

func _hata(mesaj: String) -> void:
	hata += 1
	push_error(mesaj)
