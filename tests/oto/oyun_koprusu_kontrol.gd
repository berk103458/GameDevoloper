extends Node
## Gerçek Ana/Kapi/Koy; kuyruk atlama, model gece_sonu veya kaynak hilesi yok.
var ana: Ana
var kopru: OyunKoprusu

func _ready() -> void:
	get_tree().create_timer(110.0).timeout.connect(func() -> void: get_tree().quit(1))
	ana = load("res://src/arayuz/ana.tscn").instantiate()
	add_child(ana)
	while ana.katalog == null or ana._ekran == null:
		await get_tree().process_frame
	assert(ana.find_children("*", "OyunKoprusu", true, false).is_empty())
	ana.kayit = GuvenliKayit.new("res://work/adm16/test_save.json")
	for c in ana.get_children():
		if c is AdminHud: c.anlik_goruntu.arac.slot = GuvenliKayit.new("res://work/adm16/test_snapshot.json")
	kopru = OyunKoprusu.new()
	kopru.ana = ana
	add_child(kopru)
	assert((await kopru.run_command("get_state"))["ekran"] == "menu")
	assert(not (await kopru.run_command("yeni_oyun", {"tohum": 11})).has("error"))
	var karar_sayisi := 0
	var nokta_alindi := false
	for _i in 1000:
		await get_tree().create_timer(0.08).timeout
		var s := kopru.get_state()
		if not s.hazir: continue
		if s.ekran == "koy": break
		assert(s.ekran == "kapi")
		if s.evre == "karar" and not s.kisi.kararlar.is_empty():
			if not nokta_alindi:
				assert(not (await kopru.run_command("kaydet")).has("error"))
				var once := ana.oturum.kaydet()
				assert(not (await kopru.run_command("yukle")).has("error"))
				assert(ana.oturum.kaydet() == once)
				nokta_alindi = true
				continue
			var once := ana.oturum.kaydet()
			assert((await kopru.run_command("kapi_karar", {"karar": "hile"})).has("error"))
			assert(ana.oturum.kaydet() == once)
			var karar: String = "kabul" if "kabul" in s.kisi.kararlar else s.kisi.kararlar[0]
			assert(not (await kopru.run_command("kapi_karar", {"karar": karar})).has("error"))
			karar_sayisi += 1
		elif s.evre == "sohbet":
			var eylem := false
			for b in s.eylemler:
				if "karar" in b.metin.to_lower():
					assert(not (await kopru.run_command("devam", {"alan": "eylem", "indeks": b.indeks})).has("error"))
					eylem = true
					break
			if not eylem and not s.secenekler.is_empty():
				assert(not (await kopru.run_command("soru_sor", {"indeks": 0})).has("error"))
		elif s.evre in ["sira", "is"] and not s.secenekler.is_empty():
			assert(not (await kopru.run_command("devam")).has("error"))
	assert(karar_sayisi > 0 and nokta_alindi and ana._ekran is KoyEkrani)
	var s := kopru.get_state()
	assert(s.koy.nufus == ana.oturum.yonetim.nufus() and s.akce.koy == ana.oturum.koy_akce)
	var kayit := ana.oturum.kaydet()
	assert((await kopru.run_command("koy_eylem", {"tur": "insa", "bina": "sahte", "hucre": [0, 0]})).has("error"))
	assert((await kopru.run_command("soru_sor", {"indeks": 0})).has("error"))
	assert(ana.oturum.kaydet() == kayit)
	# Aynı UI inşa ve bina kaldırma düğme yolları.
	var kuruldu := false
	for b in s.koy.kurulabilir:
		if b.tur == "tarla" and not b.hucreler.is_empty():
			assert(not (await kopru.run_command("koy_eylem", {"tur": "insa", "bina": b.tur, "hucre": b.hucreler[0]})).has("error"))
			kuruldu = true
			break
	assert(kuruldu)
	var son_bina := ana.oturum.yonetim.binalar.back() as KoyBinasi
	var bina_id := son_bina.id
	assert((await kopru.run_command("koy_eylem", {"tur": "insa", "bina": "tarla", "hucre": [4294967305, 8]})).has("error"))
	assert(not (await kopru.run_command("koy_eylem", {"tur": "kaldir", "bina": bina_id})).has("error"))
	assert(ana.oturum.yonetim.bina(bina_id) == null)
	var gun := ana.oturum.gun
	assert(not (await kopru.run_command("gece_bitir")).has("error"))
	s = kopru.get_state()
	assert(s.ekran == "rapor" and s.gun == gun + 1 and s.rapor_satirlari.size() > 0)
	assert(s.erzak == ana.oturum.ambar and s.akce.muhafiz == ana.oturum.muhafiz_akce and s.barlar.size() == 4)
	kayit = ana.oturum.kaydet()
	assert((await kopru.run_command("gece_bitir")).has("error"))
	assert(ana.oturum.kaydet() == kayit)
	ana.kayit.sil()
	for c in ana.get_children():
		if c is AdminHud: c.anlik_goruntu.arac.slot.sil()
	# Son sinyali fikstürü: azil, yönetimin boş son alanıyla karıştırılmamalı.
	ana._ekran.oturum_bitti.emit(&"azil")
	s = kopru.get_state()
	assert(s.ekran == "son" and s.son.kimlik == "azil" and not s.son.metin.is_empty())
	ana.queue_free()
	await get_tree().process_frame
	await Ses.sustur()
	print("OYUN KÖPRÜSÜ GERÇEK AKIŞ: GEÇTİ")
	get_tree().quit(0)
