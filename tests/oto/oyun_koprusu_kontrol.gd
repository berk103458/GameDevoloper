extends Node

var _hata := 0
## Gerçek Ana/Kapi/Koy; kuyruk atlama, model gece_sonu veya kaynak hilesi yok.
var ana: Ana
var kopru: OyunKoprusu

func _ready() -> void:
	get_tree().create_timer(110.0).timeout.connect(func() -> void: get_tree().quit(1))
	ana = load("res://src/arayuz/ana.tscn").instantiate()
	add_child(ana)
	while ana.katalog == null or ana._ekran == null:
		await get_tree().process_frame
	_dene(ana.find_children("*", "OyunKoprusu", true, false).is_empty(), "oyun_koprusu_kontrol.gd:12")
	ana.kayit = GuvenliKayit.new("user://test_kopru_save.json")
	ana.oyuncu_izi.sifirla()
	# TEK-27: AdminHud oyuncu surumunde dogmaz; kopru kaydet/yukle snapshot aracini test kendisi saglar.
	var test_admin := AdminHud.new()
	test_admin.baglam = ana
	ana.add_child(test_admin)
	test_admin.anlik_goruntu.arac.slot = GuvenliKayit.new("user://test_kopru_snapshot.json")
	test_admin.anlik_goruntu.arac.slot.sil()
	kopru = OyunKoprusu.new()
	kopru.ana = ana
	add_child(kopru)
	_dene((await kopru.run_command("get_state"))["ekran"] == "menu", "oyun_koprusu_kontrol.gd:24")
	_dene(not (await kopru.run_command("yeni_oyun", {"tohum": 11})).has("error"), "oyun_koprusu_kontrol.gd:25")
	# Geçmiş seçimi durur. İlk satır bir geçmiştir; sonra köy açılır.
	_dene(kopru.get_state().ekran == "rapor", "oyun_koprusu_kontrol.gd:27")
	_dene(not (await kopru.run_command("devam", {"indeks": 2})).has("error"), "oyun_koprusu_kontrol.gd:28")
	_dene(ana._ekran.name == &"IlkSaatKadraci" and ana.oturum == null, "oyun_koprusu_kontrol.gd:29")
	_dene(not (await kopru.run_command("devam", {"indeks": 0})).has("error"), "oyun_koprusu_kontrol.gd:30")
	await get_tree().process_frame
	# ACL-01: yeni oyunun ilk günü köydedir. Kapıya model günü atlayarak
	# değil, gerçek gece ve rapor/olay düğmelerini köprüden kullanarak gideriz.
	var acilis := kopru.get_state()
	_dene(acilis.ekran == "koy" and acilis.koy.nufus == 2 and acilis.koy.yatak == 4, "oyun_koprusu_kontrol.gd:35")
	_dene(acilis.ILKSAAT == [{"ipucu": "koy_hizi", "gosterim_gecesi": 0, "ilk_kullanim_gecesi": -1}], "oyun_koprusu_kontrol.gd:36")
	ana._ekran._hiz_dugmeleri[1].pressed.emit()
	_dene(kopru.get_state().ILKSAAT[0].ilk_kullanim_gecesi == 0, "oyun_koprusu_kontrol.gd:38")
	_dene(not (await kopru.run_command("gece_bitir")).has("error"), "oyun_koprusu_kontrol.gd:39")
	# ACL-04: ilk akşam önce zorunlu ulak, sonra gerçek sorguda ilk aile.
	_dene(ana._ekran.has_node("KapiAcilisSunumu") and ana.oturum.gun == 0, "oyun_koprusu_kontrol.gd:41")
	var baslangic := Time.get_ticks_msec()
	for _i in 250:
		await get_tree().create_timer(0.08).timeout
		if ana._ekran is KapiEkrani and not ana._kapi_yukleniyor and ana._kapi.evre == &"sohbet": break
	_dene(Time.get_ticks_msec() - baslangic < 60000 and ana.oturum.gun == 0, "oyun_koprusu_kontrol.gd:46")
	_dene(ana.oturum.yonetim.nufus() == 2 and ana._kapi._gelen.id == &"acl04_ilk_aile", "oyun_koprusu_kontrol.gd:47")
	var sahne := ana._kapi.sahne
	var es := sahne.get_node_or_null("IlkAileEs") as KarakterModel
	var kamera := sahne.kamera
	if es == null or not kamera.is_position_in_frustum(KapiKameraVurgu.kadraj_hesapla(es.global_position)):
		push_error("SAH-53: Kuruluş eşi ilk aileyle aynı kadrajda olmalı.")
		get_tree().quit(1)
		return
	_dene(sahne.find_children("*", "Camera3D", true, false).size() == 1, "oyun_koprusu_kontrol.gd:55")
	_dene(kamera.get_viewport().get_camera_3d() == kamera, "oyun_koprusu_kontrol.gd:56")
	var ogretici := ana._kapi.get_node("AcilisOgretici")
	var ogretici_satirlari := (ogretici.get_node("Adimlar") as Label).text.split("\n")
	_dene(ogretici_satirlari.size() == 3 and ogretici_satirlari[0] == IlkSaat.ipucu_metni("ogretici.gecmis.medrese_talebesi"), "oyun_koprusu_kontrol.gd:59")
	_dene(not (ogretici.get_node("Adimlar") as Label).text.contains("ogretici."), "oyun_koprusu_kontrol.gd:60")
	_dene(kopru.get_state().ILKSAAT.size() == 1 + ogretici_satirlari.size(), "oyun_koprusu_kontrol.gd:61")
	(ogretici.get_child(1) as Button).pressed.emit()
	await get_tree().process_frame
	_dene(not ana._kapi.has_node("AcilisOgretici"), "oyun_koprusu_kontrol.gd:64")
	_dene(es.is_inside_tree() and kamera.get_viewport().get_camera_3d() == kamera, "oyun_koprusu_kontrol.gd:65")
	_dene(ana.oturum.gece_sonu().get("engellendi", false), "oyun_koprusu_kontrol.gd:66")
	ana._kapi._tumunu_goster()
	var ilk := kopru.get_state()
	if ilk.eylemler.size() != 1 or ilk.eylemler[0].metin != tr("arayuz.sohbet.karar_ver") or ilk.kisi.sorular.size() != 1:
		push_error("OGR-02: ilk ailede yalnız soru ve karar görünür. Eylemler: %s, sorular: %s" % [str(ilk.eylemler), str(ilk.kisi.sorular)])
		get_tree().quit(1)
		return
	_dene(ilk.kisi.kalan_soru_hakki <= ana.oturum.ayarlar.azami_soru and ana._kapi._gelen.chr_sorgusu() == null, "oyun_koprusu_kontrol.gd:73")
	var beyan_once := ana._kapi._gelen.heybe.soruldu
	ana._kapi._heybe_sor()
	ana._kapi._heybe_ac()
	_dene(ana._kapi._heybe_paneli == null and ana._kapi._gelen.heybe.soruldu == beyan_once, "oyun_koprusu_kontrol.gd:77")
	# Gerçek selam, konu ve karar düğmeleri; kaynak veya gün hilesi yok.
	var sohbet_konumu := kamera.position
	for _i in 2:
		ana._kapi._tumunu_goster()
		_dene(not (await kopru.run_command("soru_sor", {"indeks": 0})).has("error"), "oyun_koprusu_kontrol.gd:82")
		await get_tree().create_timer(0.3).timeout
	ana._kapi._karar_goster()
	ana._kapi._tumunu_goster()
	await get_tree().create_timer(0.35).timeout
	_dene(kamera.position.z > sohbet_konumu.z, "oyun_koprusu_kontrol.gd:87")
	_dene(sahne.find_children("*", "Camera3D", true, false).size() == 1, "oyun_koprusu_kontrol.gd:88")
	_dene(kamera.get_viewport().get_camera_3d() == kamera, "oyun_koprusu_kontrol.gd:89")
	var ilk_karar := kopru.get_state()
	_dene(ilk_karar.kisi.kararlar == ["kabul", "ret"] and ilk_karar.eylemler.is_empty(), "oyun_koprusu_kontrol.gd:91")
	_dene(not (await kopru.run_command("kapi_karar", {"karar": "kabul"})).has("error"), "oyun_koprusu_kontrol.gd:92")
	for _i in 150:
		await get_tree().create_timer(0.08).timeout
		if ana._ekran is KoyEkrani: break
	_dene(ana._ekran is KoyEkrani and ana.oturum.gun == 0 and ana.oturum.yonetim.nufus() == 4, "oyun_koprusu_kontrol.gd:96")
	await get_tree().process_frame
	var koy3b := (ana._ekran as KoyEkrani).sahne3b
	var koy_kamera := koy3b.kamera
	_dene(not is_instance_valid(kamera) and koy_kamera.get_viewport().get_camera_3d() == koy_kamera, "oyun_koprusu_kontrol.gd:100")
	_dene(koy3b.hedef.is_equal_approx(Vector3(0, 0, 4)) and is_equal_approx(koy3b.uzaklik, 38.0), "oyun_koprusu_kontrol.gd:101")
	_dene(koy3b.get_node_or_null("kamera_surukleme") is KameraSurukleme, "oyun_koprusu_kontrol.gd:102")
	_dene(not koy3b.get_children().any(func(dugum: Node) -> bool: return dugum is KapiKameraGecisi), "oyun_koprusu_kontrol.gd:103")
	print("SAH-56 KÖY KAMERASI AYRI: GEÇTİ" if _hata == 0 else "SAH-56 KÖY KAMERASI AYRI: KALDI (%d hata)" % _hata)
	var ambar_once := ana.oturum.ambar
	_dene(not (await kopru.run_command("gece_bitir")).has("error"), "oyun_koprusu_kontrol.gd:106")
	_dene(_kisa_rapor(ambar_once), "oyun_koprusu_kontrol.gd:107")
	var ilk_rapor := ana._ekran._ust_kart as Control
	_dene(ilk_rapor.find_child("kisa_ulak_berat", true, false) == null, "oyun_koprusu_kontrol.gd:109")
	_dene((ilk_rapor.find_child("kisa_gelenler", true, false) as Label).text.contains("ulağı"), "oyun_koprusu_kontrol.gd:110")
	_dene((ilk_rapor.find_child("kisa_gelenler", true, false) as Label).text.contains("Ali ve Zeynep"), "oyun_koprusu_kontrol.gd:111")
	_dene((ilk_rapor.find_child("kisa_kalanlar", true, false) as Label).text.ends_with("Ali, Zeynep"), "oyun_koprusu_kontrol.gd:112")
	for _i in 100:
		await get_tree().create_timer(0.08).timeout
		var adim := kopru.get_state()
		if adim.ekran == "kapi": break
		if not adim.hazir: continue
		_dene(adim.ekran == "rapor", "oyun_koprusu_kontrol.gd:118")
		_dene(not (await kopru.run_command("devam", {"indeks": 0})).has("error"), "oyun_koprusu_kontrol.gd:119")
	_dene(ana._ekran is KapiEkrani and ana.oturum.gun == 1, "oyun_koprusu_kontrol.gd:120")
	_dene(not is_instance_valid(es) and not ana._kapi.sahne.has_node("IlkAileEs"), "oyun_koprusu_kontrol.gd:121")
	print("SAH-53 İLK AİLE TEK KADRAJ: GEÇTİ" if _hata == 0 else "SAH-53 İLK AİLE TEK KADRAJ: KALDI (%d hata)" % _hata)
	var karar_sayisi := 0
	var nokta_alindi := false
	for _i in 1000:
		await get_tree().create_timer(0.08).timeout
		var s := kopru.get_state()
		if not s.hazir: continue
		if s.ekran == "koy": break
		_dene(s.ekran == "kapi", "oyun_koprusu_kontrol.gd:130")
		if s.evre == "karar" and not s.kisi.kararlar.is_empty():
			if not nokta_alindi:
				_dene(not (await kopru.run_command("kaydet")).has("error"), "oyun_koprusu_kontrol.gd:133")
				var once := ana.oturum.kaydet()
				_dene(not once.get("ilk_gece_gelenleri", []).is_empty(), "oyun_koprusu_kontrol.gd:135")
				var ilk_saat: Array = s.ILKSAAT
				_dene(not (await kopru.run_command("yukle")).has("error"), "oyun_koprusu_kontrol.gd:137")
				_dene(ana.oturum.kaydet() == once, "oyun_koprusu_kontrol.gd:138")
				_dene(kopru.get_state().ILKSAAT == ilk_saat, "oyun_koprusu_kontrol.gd:139")
				nokta_alindi = true
				continue
			var once := ana.oturum.kaydet()
			_dene((await kopru.run_command("kapi_karar", {"karar": "hile"})).has("error"), "oyun_koprusu_kontrol.gd:143")
			_dene(ana.oturum.kaydet() == once, "oyun_koprusu_kontrol.gd:144")
			var karar: String = "kabul" if "kabul" in s.kisi.kararlar else s.kisi.kararlar[0]
			_dene(not (await kopru.run_command("kapi_karar", {"karar": karar})).has("error"), "oyun_koprusu_kontrol.gd:146")
			karar_sayisi += 1
		elif s.evre == "sohbet":
			var eylem := false
			for b in s.eylemler:
				if "karar" in b.metin.to_lower():
					_dene(not (await kopru.run_command("devam", {"alan": "eylem", "indeks": b.indeks})).has("error"), "oyun_koprusu_kontrol.gd:152")
					eylem = true
					break
			if not eylem and not s.secenekler.is_empty():
				_dene(not (await kopru.run_command("soru_sor", {"indeks": 0})).has("error"), "oyun_koprusu_kontrol.gd:156")
		elif s.evre in ["sira", "is"] and not s.secenekler.is_empty():
			_dene(not (await kopru.run_command("devam")).has("error"), "oyun_koprusu_kontrol.gd:158")
	_dene(karar_sayisi > 0 and nokta_alindi and ana._ekran is KoyEkrani, "oyun_koprusu_kontrol.gd:159")
	var s := kopru.get_state()
	_dene(s.koy.nufus == ana.oturum.yonetim.nufus() and s.akce.koy == ana.oturum.koy_akce, "oyun_koprusu_kontrol.gd:161")
	var kayit := ana.oturum.kaydet()
	_dene((await kopru.run_command("koy_eylem", {"tur": "insa", "bina": "sahte", "hucre": [0, 0]})).has("error"), "oyun_koprusu_kontrol.gd:163")
	_dene((await kopru.run_command("soru_sor", {"indeks": 0})).has("error"), "oyun_koprusu_kontrol.gd:164")
	_dene(ana.oturum.kaydet() == kayit, "oyun_koprusu_kontrol.gd:165")
	# Aynı UI inşa ve bina kaldırma düğme yolları.
	var kuruldu := false
	for b in s.koy.kurulabilir:
		if b.tur == "tarla" and not b.hucreler.is_empty():
			_dene(not (await kopru.run_command("koy_eylem", {"tur": "insa", "bina": b.tur, "hucre": b.hucreler[0]})).has("error"), "oyun_koprusu_kontrol.gd:170")
			kuruldu = true
			break
	_dene(kuruldu, "oyun_koprusu_kontrol.gd:173")
	var son_bina := ana.oturum.yonetim.binalar.back() as KoyBinasi
	var bina_id := son_bina.id
	_dene((await kopru.run_command("koy_eylem", {"tur": "insa", "bina": "tarla", "hucre": [4294967305, 8]})).has("error"), "oyun_koprusu_kontrol.gd:176")
	_dene(not (await kopru.run_command("koy_eylem", {"tur": "kaldir", "bina": bina_id})).has("error"), "oyun_koprusu_kontrol.gd:177")
	_dene(ana.oturum.yonetim.bina(bina_id) == null, "oyun_koprusu_kontrol.gd:178")
	var gun := ana.oturum.gun
	ambar_once = ana.oturum.ambar
	_dene(not (await kopru.run_command("gece_bitir")).has("error"), "oyun_koprusu_kontrol.gd:181")
	_dene(_kisa_rapor(ambar_once), "oyun_koprusu_kontrol.gd:182")
	_dene(not (ana._ekran._ust_kart.find_child("kisa_gelenler", true, false) as Label).text.contains("ulağı"), "oyun_koprusu_kontrol.gd:183")
	var ulak_satirlari := (ana._ekran._ust_kart as Control).find_children("kisa_ulak_berat", "Label", true, false)
	_dene(ulak_satirlari.size() == 1 and ulak_satirlari[0].text == tr("koy.rapor.kisa.ulak_berat"), "oyun_koprusu_kontrol.gd:185")
	s = kopru.get_state()
	_dene(s.ekran == "rapor" and s.gun == gun + 1 and s.rapor_satirlari.size() > 0, "oyun_koprusu_kontrol.gd:187")
	_dene(s.erzak == ana.oturum.ambar and s.akce.muhafiz == ana.oturum.muhafiz_akce and s.barlar.size() == 4, "oyun_koprusu_kontrol.gd:188")
	kayit = ana.oturum.kaydet()
	_dene((await kopru.run_command("gece_bitir")).has("error"), "oyun_koprusu_kontrol.gd:190")
	_dene(ana.oturum.kaydet() == kayit, "oyun_koprusu_kontrol.gd:191")
	ana.kayit.sil()
	test_admin.anlik_goruntu.arac.slot.sil()
	test_admin.free()
	# Son sinyali fikstürü: azil, yönetimin boş son alanıyla karıştırılmamalı.
	ana._ekran.oturum_bitti.emit(&"azil")
	s = kopru.get_state()
	_dene(s.ekran == "son" and s.son.kimlik == "azil" and not s.son.metin.is_empty(), "oyun_koprusu_kontrol.gd:198")
	ana.queue_free()
	await get_tree().process_frame
	await Ses.sustur()
	print("OYUN KÖPRÜSÜ GERÇEK AKIŞ: GEÇTİ" if _hata == 0 else "OYUN KÖPRÜSÜ GERÇEK AKIŞ: KALDI (%d hata)" % _hata)
	get_tree().quit(1 if _hata > 0 else 0)

func _kisa_rapor(ambar_once: int) -> bool:
	var kart := ana._ekran._ust_kart as Control
	if kart == null: return false
	var kisa_satirlar := kart.find_children("kisa_*", "Label", true, false)
	var ambar := kart.find_child("kisa_ambar", true, false) as Label
	return kisa_satirlar.size() == (4 if ana.oturum.gun == 2 else 3) and ambar != null and ambar.text.ends_with("%d → %d" % [ambar_once, ana.oturum.ambar]) and kart.find_child("gece_akce", true, false) == null


func _dene(kosul: bool, ad: String) -> void:
	if not kosul:
		_hata += 1
		push_error(ad)
