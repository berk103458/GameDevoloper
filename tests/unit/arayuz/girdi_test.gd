## GIR-01 … GIR-26 kontroller ve girdi. GIR-18 ve GIR-24 bu turda dokunulmaz.
extends SceneTree

const YOL := "user://test_girdi_ayar.cfg"

var hata := 0


func _initialize() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	_sil()
	GuvenliMetin.kur()
	_kapanis()
	_eylem_haritasi()
	_cakisma_ve_atama()
	_kayit()
	_gamepad_ve_fare()
	_esc_ve_ekran()
	_metin_ve_surum()
	await _arayuz()
	_sil()
	print("GIRDI: GEÇTİ (%d hata)" % hata if hata == 0 else "GIRDI: KALDI (%d hata)" % hata)
	quit(0 if hata == 0 else 1)


func _kapanis() -> void:
	GirdiEylemleri.kur(YOL)
	_kontrol(GirdiEylemleri.dinler("hiz_1", _tus("1")) and GirdiEylemleri.dinler("hiz_2", _tus("2")) and GirdiEylemleri.dinler("hiz_3", _tus("3")), "GIR-26: 1/2/3 hız")
	_kontrol(GirdiEylemleri.dinler("nufus", _tus("P")) and not GirdiEylemleri.dinler("menu", _tus("P")), "GIR-26: P nüfus, duraklat açmaz")
	_kontrol(GirdiEylemleri.dinler("hiz_dur", _tus("Space")), "GIR-26: Space durur")
	_kontrol(GirdiEylemleri.esc_kademe(true, false) != &"duraklat", "GIR-26: üst panel açıkken Esc duraklat açmaz")
	_kontrol(not GirdiEylemleri.proje_girdisi_var() and not GirdiEylemleri.kayit_dosyasinda_mi(), "GIR-26: [input] yok, atama kayıtta değil")


func _eylem_haritasi() -> void:
	var koy := _fonksiyon("res://src/arayuz/koy_ekrani.gd", "_unhandled_input")
	var dunya := _fonksiyon("res://src/arayuz/koy_ekrani.gd", "_dunya_girdisi")
	_kontrol(not koy.contains("physical_keycode") and not dunya.contains("physical_keycode"), "GIR-02: physical_keycode 0")
	_kontrol(koy.contains("is_action_pressed(\"hiz_2\")"), "GIR-02: hız 2 eylemden gelir")
	var csv := FileAccess.get_file_as_string("res://data/metin/metinler.csv")
	_kontrol(csv.contains("arayuz.girdi.geri,") and csv.contains("arayuz.girdi.hiz_1,"), "GIR-03: çeviri anahtarı")
	_kontrol(not GirdiEylemleri.proje_girdisi_var(), "GIR-04: [input] yok")
	_kontrol(GirdiEylemleri.dinler("nufus", _tus("P")) and GirdiEylemleri.dinler("menu", _tus("F10")), "GIR-05: P nüfus, menü F10")
	var once := InputMap.action_get_events("ui_accept").size() if InputMap.has_action("ui_accept") else -1
	GirdiEylemleri.kur(YOL)
	var sonra := InputMap.action_get_events("ui_accept").size() if InputMap.has_action("ui_accept") else -1
	_kontrol(InputMap.has_action("ui_up") and once == sonra, "GIR-06: ui_* yeniden tanımlanmaz")
	var ikisi := PackedStringArray(["hiz_1", "kisayol_1"])
	var koyda := GirdiEylemleri.karede(ikisi, "koy")
	var kapida := GirdiEylemleri.karede(ikisi, "kapi")
	_kontrol(koyda.size() == 1 and koyda[0] == "hiz_1" and kapida.size() == 1 and kapida[0] == "kisayol_1", "GIR-07: aynı karede tek ekran")
	_kontrol(not GirdiEylemleri.cakisiyor("hiz_1") and not GirdiEylemleri.cakisiyor("kisayol_1"), "GIR-07: ayrı ekran çakışma sayılmaz")


func _cakisma_ve_atama() -> void:
	_kontrol(GirdiEylemleri.ata("hiz_1", _tus("R")), "GIR-09: atama yazılır")
	_kontrol(GirdiEylemleri.dinler("hiz_1", _tus("R")) and not GirdiEylemleri.dinler("hiz_1", _tus("1")), "GIR-09: R hız seçer, 1 seçmez")
	_kontrol(GirdiEylemleri.tus_adi("hiz_1") == "R", "GIR-03: kısa ad R")
	_kontrol(not GirdiEylemleri.tus_adi("hiz_1").contains("as_text"), "GIR-03: as_text yok")
	GirdiEylemleri.varsayilana_don(YOL)
	_kontrol(GirdiEylemleri.ata("bina_cevir", _tus("1")), "GIR-10: çakışan atama kaydı")
	var dinleyen := 0
	if GirdiEylemleri.dinler("bina_cevir", _tus("1")):
		dinleyen += 1
	if GirdiEylemleri.dinler("hiz_1", _tus("1")):
		dinleyen += 1
	_kontrol(dinleyen == 1, "GIR-10: işleyen eylem 1")
	_kontrol(GirdiEylemleri.cakisiyor("bina_cevir") or GirdiEylemleri.cakisiyor("hiz_1"), "GIR-10: çakışıyor")
	var cfg := ConfigFile.new()
	_kontrol(cfg.load(YOL) == OK and str(cfg.get_value("girdi", "bina_cevir", "")) == "key:1", "GIR-10: kayıt silinmedi")
	GirdiEylemleri.varsayilana_don(YOL)
	var ayar := Ayarlar.new(YOL)
	ayar.yukle()
	ayar.varsayilana_don()
	_kontrol(GirdiEylemleri.dinler("nufus", _tus("P")) and GirdiEylemleri.dinler("hiz_1", _tus("1")), "GIR-11: sıfırlama sonrası P ve 1")


func _kayit() -> void:
	GirdiEylemleri.kur(YOL)
	GirdiEylemleri.ata("hiz_1", _tus("R"))
	var ayar := Ayarlar.new(YOL)
	ayar.yukle()
	ayar.ayarla(&"ses_ana", 4)
	ayar.yaz()
	GirdiEylemleri.kur(YOL)
	_kontrol(GirdiEylemleri.dinler("hiz_1", _tus("R")), "GIR-19: ayar yazılınca atama durur")
	_kontrol(not GirdiEylemleri.kayit_dosyasinda_mi(), "GIR-19: kayit.json değil")
	var bos := YOL + ".bos"
	GirdiEylemleri.kur(bos)
	_kontrol(GirdiEylemleri.dinler("hiz_1", _tus("1")), "GIR-19: dosya yokken varsayılan")
	var cfg := ConfigFile.new()
	cfg.set_value("girdi", "hiz_1", "")
	cfg.set_value("girdi", "yok_eylem", "key:r")
	cfg.set_value("ayarlar", "ses_ana", 8)
	cfg.save(YOL)
	GirdiEylemleri.kur(YOL)
	_kontrol(GirdiEylemleri.dinler("hiz_1", _tus("1")) and GirdiEylemleri.dinler("nufus", _tus("P")), "GIR-20: boş satır varsayılan, çökme yok")
	GirdiEylemleri.kur(YOL, "res://data/girdi_yok.json")
	_kontrol(GirdiEylemleri.dinler("hiz_1", _tus("1")) and GirdiEylemleri.hata_sayisi == 0, "GIR-12: json yokken klavye varsayılanı")


func _gamepad_ve_fare() -> void:
	GirdiEylemleri.kur(YOL)
	var kaynak := FileAccess.get_file_as_string("res://src/arayuz/girdi_eylemleri.gd")
	_kontrol(not kaynak.contains("JOY_BUTTON_") and not kaynak.contains("button_index = 0"), "GIR-12: kod içi düğme indeksi 0")
	var json := FileAccess.get_file_as_string("res://data/girdi.json")
	_kontrol(json.contains("\"lb\"") and json.contains("\"a\""), "GIR-12: gamepad sayıları dosyada")
	var hedef := KoyCubukImleci.hedef(Vector2(10, 10), Vector2(1, 0))
	_kontrol(hedef.x > 10.0 and not KoyCubukImleci.yakinlas_cagrilir(Vector2(1, 0)), "GIR-13: sapma hücreyi kaydırır, yakınlaşma artmaz")
	var cubuk := _fonksiyon("res://src/arayuz/koy_ekrani.gd", "_cubuk_imleci")
	_kontrol(not cubuk.contains("yakinlas"), "GIR-13: çubuk yakınlaşma çağırmaz")
	_kontrol(KoyCubukImleci.sapma() == Vector2.ZERO and GirdiEylemleri.dinler("geri", _tus("Escape")), "GIR-14: gamepad yokken klavye durur")
	var kapi := FileAccess.get_file_as_string("res://src/arayuz/kapi_ekrani.gd")
	_kontrol(kapi.contains("_karar_bas(\"kabul\")") and kapi.contains("_karar_bas.bind(anahtar)"), "GIR-15: klavye ve fare aynı karar yolu")
	_kontrol(GirdiEylemleri.dinler("kapi_kabul", _tus("Y")) and not GirdiEylemleri.dinler("kapi_kabul", _tus("Enter")), "GIR-16: kabul Enter değil")
	var fare := _fonksiyon("res://src/arayuz/koy_ekrani.gd", "_dunya_girdisi")
	_kontrol(fare.contains("is_action_pressed(\"sec\")") and fare.contains("is_action_pressed(\"yakinlas\")") and not fare.contains("MOUSE_BUTTON_"), "GIR-17: fare eylem kimliği")
	_kontrol(not json.contains("orta") and not fare.contains("MOUSE_BUTTON_MIDDLE"), "GIR-18: orta tuş bu bölümde yok")


func _esc_ve_ekran() -> void:
	_kontrol(GirdiEylemleri.esc_kademe(true, true) == &"ust_panel", "GIR-08: üst panel önce")
	_kontrol(GirdiEylemleri.esc_kademe(false, true) == &"kip", "GIR-08: sonra kip")
	_kontrol(GirdiEylemleri.esc_kademe(false, false) == &"duraklat", "GIR-08: sonra duraklat")
	var yan: Dictionary = GirdiEylemleri.esc_yan_etki(&"ust_panel")
	_kontrol(yan.nobet_yuva == false and yan.cinar_sadakat == false and yan.cinar_moral == false, "GIR-08: Esc nöbet ve meclis yazmaz")
	_kontrol(yan.tezgah_ucret == false and yan.tezgah_parca == false and yan.yil_kapanir == true and yan.yil_moral == false and yan.yil_erzak == false, "GIR-08: Esc tezgâh ve yıl kaynağı yazmaz")
	var hiz := _fonksiyon("res://src/arayuz/koy_ekrani.gd", "_hiz_sec")
	_kontrol(hiz.contains("Engine.time_scale") and hiz.contains("clampi") and not hiz.contains("is_action"), "GIR-25: hız gövdesi durur")


func _metin_ve_surum() -> void:
	GirdiEylemleri.kur(YOL)
	GirdiEylemleri.ata("hiz_1", _tus("R"))
	var ipucu := IpucuSeridi.hiz_ipucu()
	_kontrol(ipucu.contains("R") and not ipucu.contains("1"), "GIR-21: ipucu R söyler, 1 söylemez")
	var csv := FileAccess.get_file_as_string("res://data/metin/metinler.csv")
	var yapay := 0
	for satir in csv.split("\n"):
		if satir.begins_with("arayuz.girdi.") and _yapay_mi(satir):
			yapay += 1
	_kontrol(yapay == 0 and _soz_tarama() == 0, "GIR-22: arayuz.girdi yapaylık listesinde 0")
	_kontrol(GirdiEylemleri.kontroller_sekmesi_acik(false), "GIR-23: oyuncu sürümünde sekme açık")
	_kontrol(not FileAccess.get_file_as_string("res://src/arayuz/kontroller_sekmesi.gd").contains(".png"), "GIR-24: yeni png 0")


func _arayuz() -> void:
	await process_frame
	var ayar := Ayarlar.new(YOL)
	ayar.yukle()
	GirdiEylemleri.kur(YOL)
	var ekran := AyarlarEkrani.new()
	ekran.ayarlar = ayar
	root.add_child(ekran)
	await process_frame
	_kontrol(ekran.find_child("KontrollerSekmesiDugmesi", true, false) != null, "GIR-01: kontroller düğmesi")
	ekran._kontroller_goster()
	var sekme := ekran.get_node("KontrollerSekmesi") as KontrollerSekmesi
	var kimlik := sekme.satir_kimlikleri()
	_kontrol(kimlik.has("geri") and kimlik.has("menu") and kimlik.has("hiz_1") and kimlik.has("nufus") and kimlik.has("bina_cevir"), "GIR-01: satırlar")
	var ham := 0
	for id in kimlik:
		if sekme.satir_metni(id).contains(id):
			ham += 1
	_kontrol(ham == 0, "GIR-03: ham eylem kimliği 0")
	var dugmeler: Array = []
	ekran._dugme_topla(ekran, dugmeler)
	_kontrol(dugmeler.size() > 0 and OdakHalkasi.kopuk(dugmeler) == 0 and OdakHalkasi.bagla(dugmeler) == dugmeler.size(), "GIR-06: ayarlar halkası")
	sekme.dinle("hiz_1")
	_kontrol(sekme.olay_al(_tus("R")), "GIR-09: sekme ataması")
	var bilgi := BilgiEkrani.new()
	bilgi.ayarlar = ayar
	bilgi.baslik = "Duraklat"
	bilgi.dugmeler = PackedStringArray(["Devam", "Ayarlar", "Menü"])
	root.add_child(bilgi)
	await process_frame
	var duraklat: Array = []
	_dugmeleri_topla(bilgi, duraklat)
	_kontrol(duraklat.size() == 3 and OdakHalkasi.kopuk(duraklat) == 0, "GIR-06: duraklat halkası")
	ekran.queue_free()
	bilgi.queue_free()
	await process_frame
	await _enter_ret()


func _enter_ret() -> void:
	var kok := Control.new()
	root.add_child(kok)
	var kabul := Button.new()
	var ret := Button.new()
	var basilan := {"ad": ""}
	kabul.pressed.connect(func() -> void: basilan.ad = "kabul")
	ret.pressed.connect(func() -> void: basilan.ad = "ret")
	kok.add_child(kabul)
	kok.add_child(ret)
	OdakHalkasi.bagla([kabul, ret])
	kabul.custom_minimum_size = Vector2(200, 48)
	ret.custom_minimum_size = Vector2(200, 48)
	kok.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	ret.grab_focus()
	await process_frame
	var ev := InputEventKey.new()
	ev.keycode = KEY_ENTER
	ev.pressed = true
	var odak := root.gui_get_focus_owner()
	# Headless tuşu GUI'ye bırakmaz. Odak retteyse ve Enter ui_accept ise motor o düğmeyi basar;
	# kapi_kabul bu olayı dinlemez.
	if odak == ret and ev.is_action_pressed("ui_accept") and not GirdiEylemleri.dinler("kapi_kabul", ev):
		ret.pressed.emit()
	_kontrol(odak == ret and basilan.ad == "ret" and not GirdiEylemleri.dinler("kapi_kabul", ev), "GIR-16: odaklı ret, kabul basılmaz")
	kok.queue_free()


func _tus(ad: String) -> InputEventKey:
	var olay := InputEventKey.new()
	olay.physical_keycode = OS.find_keycode_from_string(ad) as Key
	olay.keycode = olay.physical_keycode
	olay.pressed = true
	return olay


func _fonksiyon(yol: String, ad: String) -> String:
	var metin := FileAccess.get_file_as_string(yol)
	var bas := metin.find("func " + ad)
	if bas < 0:
		return ""
	var son := metin.find("\nfunc ", bas + 1)
	if son < 0:
		son = metin.length()
	return metin.substr(bas, son - bas)


func _yapay_mi(satir: String) -> bool:
	for kalip in ["çünkü", "aslında", "kesinlikle", "harika", "demekti", "işte", "hani"]:
		if satir.contains(kalip):
			return true
	return false


func _soz_tarama() -> int:
	var kok := DirAccess.open("res://data/soz")
	if kok == null:
		return 0
	return _soz_dizini("res://data/soz")


func _soz_dizini(yol: String) -> int:
	var dizin := DirAccess.open(yol)
	if dizin == null:
		return 0
	var n := 0
	dizin.list_dir_begin()
	var ad := dizin.get_next()
	while ad != "":
		if ad != "." and ad != "..":
			var tam := yol.path_join(ad)
			if dizin.current_is_dir():
				n += _soz_dizini(tam)
			elif FileAccess.get_file_as_string(tam).contains("arayuz.girdi"):
				n += 1
		ad = dizin.get_next()
	return n


func _dugmeleri_topla(n: Node, hedef: Array) -> void:
	if n is Button:
		hedef.append(n)
	for cocuk in n.get_children():
		_dugmeleri_topla(cocuk, hedef)


func _sil() -> void:
	if FileAccess.file_exists(YOL):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(YOL))


func _kontrol(olur: bool, metin: String) -> void:
	if olur:
		return
	hata += 1
	push_error("FAIL " + metin)
