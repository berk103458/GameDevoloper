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
	if OS.get_environment("DUMAN_KISA_OYUNLAR") == "1":
		await _kisa_oyunlar(katalog)
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
	var rapor := await _kos(katalog, o, hedef, true)
	if rapor.is_empty() or int(rapor.gece) != hedef or (hedef == 20 and int(rapor.gun) != hedef):
		await Ses.cik(1)
		return
	print("DUMAN RAPOR: ", JSON.stringify(rapor))
	if hedef == 20:
		print("20 GECE DUMAN: GEÇTİ")
	else:
		print("KAY-52 RAPOR: ", JSON.stringify(rapor))
	await Ses.cik()


func _kisa_oyunlar(katalog: Katalog) -> void:
	const OYUN_SAYISI := 100
	const GECE_SINIRI := 6
	var baslangic := Time.get_ticks_msec()
	var toplam_gece := 0
	var sonlanan := 0
	for tohum in range(1, OYUN_SAYISI + 1):
		var rapor := await _kos(katalog, Oturum.new(katalog, tohum), GECE_SINIRI, false)
		if rapor.is_empty() or int(rapor.gece) < 1 or (int(rapor.gece) != GECE_SINIRI and String(rapor.son).is_empty()):
			push_error("DEN-79: %d tohumlu kısa oyun bitmedi" % tohum)
			await Ses.cik(1)
			return
		toplam_gece += int(rapor.gece)
		if not String(rapor.son).is_empty(): sonlanan += 1
	print("DEN-79 RAPOR: ", JSON.stringify({"oyun": OYUN_SAYISI, "gece": toplam_gece, "sonlanan": sonlanan,
		"sure_ms": Time.get_ticks_msec() - baslangic}))
	print("100 KISA OYUN: GEÇTİ")
	await Ses.cik()


func _kos(katalog: Katalog, o: Oturum, hedef: int, ayrinti: bool) -> Dictionary:
	var bot := get_parent()
	bot.ana = Ana.new()
	bot.ana.oturum = o
	var koy := KoyProbu.new()
	var hafiza_once := int(Performance.get_monitor(Performance.MEMORY_STATIC))
	var geceler := 0
	var hata := false
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
			hata = true
			break
		geceler += 1
		# JSON roundtrip her gece RNG/kadro/kasa sürekliliğini de sınar.
		var geri := Oturum.kayittan(katalog, JSON.parse_string(JSON.stringify(o.kaydet())))
		if geri == null or geri.gun != o.gun or geri.koy_akce != o.koy_akce:
			push_error("Duman testi: kayıt roundtrip bozuk")
			hata = true
			break
		o = geri
		bot.ana.oturum = o
		if ayrinti:
			print("DUMAN GECE %d: nufus=%d akce=%d son=%s" % [geceler, o.yonetim.nufus(), o.koy_akce, sonuc["son"]])
		await get_tree().process_frame
		if not ayrinti and not String(o.yonetim.son).is_empty(): break
	var rapor := {"gece": geceler, "gun": o.gun, "hafiza_once": hafiza_once,
		"hafiza_son": int(Performance.get_monitor(Performance.MEMORY_STATIC)), "son": o.yonetim.son}
	koy.free()
	bot.ana.free()
	bot.ana = null
	return {} if hata else rapor
