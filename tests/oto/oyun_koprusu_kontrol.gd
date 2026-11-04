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
	ana.kayit = GuvenliKayit.new("user://test_kopru_save.json")
	# TEK-27: AdminHud oyuncu surumunde dogmaz; kopru kaydet/yukle snapshot aracini test kendisi saglar.
	var test_admin := AdminHud.new()
	test_admin.baglam = ana
	ana.add_child(test_admin)
	test_admin.anlik_goruntu.arac.slot = GuvenliKayit.new("user://test_kopru_snapshot.json")
	test_admin.anlik_goruntu.arac.slot.sil()
	kopru = OyunKoprusu.new()
	kopru.ana = ana
	add_child(kopru)
	assert((await kopru.run_command("get_state"))["ekran"] == "menu")
	assert(not (await kopru.run_command("yeni_oyun", {"tohum": 11})).has("error"))
	# Geçmiş seçimi durur. İlk satır bir geçmiştir; sonra köy açılır.
	assert(kopru.get_state().ekran == "rapor")
	assert(not (await kopru.run_command("devam", {"indeks": 0})).has("error"))
	await get_tree().process_frame
	# ACL-01: yeni oyunun ilk günü köydedir. Kapıya model günü atlayarak
	# değil, gerçek gece ve rapor/olay düğmelerini köprüden kullanarak gideriz.
	var acilis := kopru.get_state()
	assert(acilis.ekran == "koy" and acilis.koy.nufus == 2 and acilis.koy.yatak == 4)
	assert(not (await kopru.run_command("gece_bitir")).has("error"))
	# ACL-04: ilk akşam önce zorunlu ulak, sonra gerçek sorguda ilk aile.
	assert(ana._ekran.has_node("KapiAcilisSunumu") and ana.oturum.gun == 0)
	var baslangic := Time.get_ticks_msec()
	for _i in 250:
		await get_tree().create_timer(0.08).timeout
		if ana._ekran is KapiEkrani and not ana._kapi_yukleniyor and ana._kapi.evre == &"sohbet": break
	assert(Time.get_ticks_msec() - baslangic < 60000 and ana.oturum.gun == 0)
	assert(ana.oturum.yonetim.nufus() == 2 and ana._kapi._gelen.id == &"acl04_ilk_aile")
	var ogretici := ana._kapi.get_node("AcilisOgretici")
	(ogretici.get_child(1) as Button).pressed.emit()
	await get_tree().process_frame
	assert(not ana._kapi.has_node("AcilisOgretici"))
	assert(ana.oturum.gece_sonu().get("engellendi", false))
	# Aynı gerçek selam, konu, heybe ve karar düğmeleri; kaynak veya gün hilesi yok.
	for _i in 2:
		ana._kapi._tumunu_goster()
		assert(not (await kopru.run_command("soru_sor", {"indeks": 0})).has("error"))
		await get_tree().create_timer(0.3).timeout
	ana._kapi._heybe_ac()
	await get_tree().process_frame
	assert(ana._kapi._heybe_paneli != null)
	ana._kapi._heybe_paneli.kapandi.emit()
	await get_tree().process_frame
	ana._kapi._karar_goster()
	ana._kapi._tumunu_goster()
	assert(not (await kopru.run_command("kapi_karar", {"karar": "kabul"})).has("error"))
	for _i in 150:
		await get_tree().create_timer(0.08).timeout
		if ana._ekran is KoyEkrani: break
	assert(ana._ekran is KoyEkrani and ana.oturum.gun == 0 and ana.oturum.yonetim.nufus() == 4)
	assert(not (await kopru.run_command("gece_bitir")).has("error"))
	for _i in 100:
		await get_tree().create_timer(0.08).timeout
		var adim := kopru.get_state()
		if adim.ekran == "kapi": break
		if not adim.hazir: continue
		assert(adim.ekran == "rapor")
		assert(not (await kopru.run_command("devam", {"indeks": 0})).has("error"))
	assert(ana._ekran is KapiEkrani and ana.oturum.gun == 1)
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
	test_admin.anlik_goruntu.arac.slot.sil()
	test_admin.free()
	# Son sinyali fikstürü: azil, yönetimin boş son alanıyla karıştırılmamalı.
	ana._ekran.oturum_bitti.emit(&"azil")
	s = kopru.get_state()
	assert(s.ekran == "son" and s.son.kimlik == "azil" and not s.son.metin.is_empty())
	ana.queue_free()
	await get_tree().process_frame
	await Ses.sustur()
	print("OYUN KÖPRÜSÜ GERÇEK AKIŞ: GEÇTİ")
	get_tree().quit(0)
