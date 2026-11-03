## İzole 20 gece model duman testi; mevcut otomatik oyuncunun köy stratejisini kullanır.
## Gerçek kapı/köy UI adaptörleri ayrı kabul sahnelerinde doğrulanır.
extends Node

class KoyProbu:
	extends KoyEkrani
	func _yenile() -> void:
		pass

func _ready() -> void:
	call_deferred("_calistir")

func _calistir() -> void:
	var katalog := Katalog.new()
	if katalog.yukle() != Katalog.Durum.HAZIR:
		get_tree().quit(1)
		return
	var o := Oturum.new(katalog, 11)
	if OS.get_environment("DUMAN_GOCMUS") == "1":
		o = preload("res://tests/oto/duman_cekirdek.gd").gocmus_oturum(katalog)
		if o == null:
			push_error("Göçmüş duman kaydı açılmadı")
			get_tree().quit(1)
			return
	var hedef := 20
	if OS.get_environment("DUMAN_YIL") == "3":
		hedef = maxi(1, katalog.koy_ayarlari.mevsim_gun) * 12
	var bot := get_parent()
	bot.ana = Ana.new()
	bot.ana.oturum = o
	var koy := KoyProbu.new()
	var hafiza_once := int(Performance.get_monitor(Performance.MEMORY_STATIC))
	var geceler := 0
	for gece in hedef:
		for g in o.gece_kuyrugu():
			var chr := g.chr_sorgusu()
			if chr != null:
				chr.obje_incele(1)
				chr.obje_incele(2)
				chr.gorsel_incele()
				if chr.secenek_sec(2):
					chr.secenek_sec(0)
					chr.secenek_sec(0)
			var karar: StringName = &"ret" if g.tehlikeli else &"kabul"
			if not String(karar) in g.secenekler:
				karar = StringName(g.secenekler[0])
			o.karar_ver(g, karar)
		bot._koy_yonet(koy)
		var once := o.gun
		var sonuc := o.gece_sonu()
		if o.gun != once + 1:
			push_error("Duman testi: gece sayımı bozuk")
			get_tree().quit(1)
			return
		geceler += 1
		# JSON roundtrip her gece RNG/kadro/kasa sürekliliğini de sınar.
		var geri := Oturum.kayittan(katalog, JSON.parse_string(JSON.stringify(o.kaydet())))
		if geri == null or geri.gun != o.gun or geri.koy_akce != o.koy_akce:
			push_error("Duman testi: kayıt roundtrip bozuk")
			get_tree().quit(1)
			return
		o = geri
		bot.ana.oturum = o
		print("DUMAN GECE %d: nufus=%d akce=%d son=%s" % [geceler, o.yonetim.nufus(), o.koy_akce, sonuc["son"]])
		await get_tree().process_frame
	var rapor := {"gece": geceler, "gun": o.gun, "hafiza_once": hafiza_once,
		"hafiza_son": int(Performance.get_monitor(Performance.MEMORY_STATIC)), "son": o.yonetim.son}
	print("DUMAN RAPOR: ", JSON.stringify(rapor))
	koy.free()
	bot.ana.free()
	bot.ana = null
	if hedef == 20:
		print("20 GECE DUMAN: GEÇTİ")
		get_tree().quit(0 if geceler == 20 and o.gun == 20 else 1)
	else:
		print("KAY-52 RAPOR: ", JSON.stringify(rapor))
		get_tree().quit(0 if geceler == hedef else 1)
