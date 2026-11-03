## SRM-26: bayraksiz admin 0, pencere adi, kayitsiz devam, demo, dort sayi, ag/script taramasi.
## SRM-19 ve SRM-20: on bir ekran uc cozunurlukte acilir.
extends Node

var _hata := 0


func _ready() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	get_tree().create_timer(180.0).timeout.connect(func() -> void: get_tree().quit(1))
	TranslationServer.set_locale("tr")
	_kimlik()
	_acilis()
	_demo()
	_sinir()
	if OS.get_environment("SURUM_EKRAN") != "0":
		await _ekranlar()
	print("SURUM KONTROL: %s (%d hata)" % ["GEÇTİ" if _hata == 0 else "KALDI", _hata])
	get_tree().quit(_hata)


func _kontrol(kosul: bool, mesaj: String) -> void:
	if not kosul:
		_hata += 1
		push_error("SURUM: " + mesaj)


func _kimlik() -> void:
	var proje := FileAccess.get_file_as_string("res://project.godot")
	var ad := _ayikla(proje, "config/name")
	var surum := _ayikla(proje, "config/version")
	_kontrol(ad != "" and not ad.contains("GameDevoloper"), "pencere adi eski yazim degil")
	_kontrol(ad == SurumKimligi.pencere_adi(), "pencere adi proje ayari")
	_kontrol(surum == SurumKimligi.surum(), "surum iki yerde ayni")
	_kontrol(SurumKimligi.metin() == surum, "menude tek surum")
	_kontrol(proje.contains("\"4.7\""), "features 4.7 durur")
	var daginik := 0
	for yol in _gd("res://src"):
		if FileAccess.get_file_as_string(yol).contains(surum) and surum != "":
			daginik += 1
	_kontrol(daginik == 0, "kodda daginik surum yazisi 0")
	var csv := FileAccess.get_file_as_string("res://data/metin/metinler.csv")
	_kontrol(csv.contains("arayuz.menu.surum,"), "surum anahtari")
	_kontrol(csv.contains("arayuz.demo.bitti,"), "demo anahtari")
	var istatistik := _csv_hucre(csv, "arayuz.son.istatistik")
	_kontrol(istatistik.count("%d") == DemoKesiti.istatistik_sayisi(), "son ekrani 4 sayi")


func _acilis() -> void:
	_kontrol(not AdminHud.arac_acik(PackedStringArray()), "bayraksiz admin 0")
	_kontrol(OyuncuSurumu.debug_dugum_sayisi(PackedStringArray(), false, "") == 0, "oyuncu surumunde debug dugumu 0")
	_kontrol(OyuncuSurumu.debug_acik(PackedStringArray(["--debug-arac"])), "gelistirme bayragi acik")
	_kontrol(OyuncuSurumu.perf_istendi(PackedStringArray(["--debug-arac"]), false), "bayrakli perf")
	_kontrol(not OyuncuSurumu.perf_istendi(PackedStringArray(), false), "oyuncu perfi kapali")
	_kontrol(OyuncuSurumu.kopru_istendi(PackedStringArray(["--bridge-port", "9316"]), ""), "port ile kopru")
	_kontrol(not OyuncuSurumu.kopru_istendi(PackedStringArray(), ""), "portsuz kopru yok")
	var ana := FileAccess.get_file_as_string("res://src/arayuz/ana.gd")
	_kontrol(ana.contains("e.pasifler = [1]"), "kayitsiz devam pasif")
	var kayit := GuvenliKayit.new("user://srm26_yok.json")
	kayit.sil()
	_kontrol(not kayit.var_mi(), "dosya yokken devam kapali")
	var preset := FileAccess.get_file_as_string("res://export_presets.cfg")
	_kontrol(preset.contains("platform=\"Windows Desktop\""), "windows hedefi")
	_kontrol(not preset.to_lower().contains("steam"), "steam hedefi yok")
	_kontrol(preset.contains("debug/export_console_wrapper=0"), "verbose kapali")
	_kontrol(preset.count("platform=") == 1, "tek export hedefi")


func _demo() -> void:
	var sinir := DemoKesiti.esik()
	_kontrol(sinir == 18, "oturma esigi durur")
	DemoKesiti.zorla = 1
	_kontrol(DemoKesiti.kapi_gecesi(true, sinir, sinir) == 0, "demo kapı gecesi 0")
	_kontrol(DemoKesiti.bitis_karti(true, sinir, sinir) == 1, "demo bitis karti 1")
	_kontrol(not DemoKesiti.perde2_baslar(true), "demo perde 2 yok")
	DemoKesiti.zorla = 0
	_kontrol(DemoKesiti.perde2_baslar(false), "bayrak kapali perde 2")
	_kontrol(DemoKesiti.kapi_gecesi(false, sinir, sinir) == 1, "tam surumde kapı surer")
	_kontrol(DemoKesiti.bitis_karti(false, sinir, sinir) == 0, "tam surumde demo karti 0")
	DemoKesiti.zorla = -1
	var bos := "user://srm26_iz_yok.cfg"
	if FileAccess.file_exists(bos):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(bos))
	_kontrol(SurumKimligi.daha_once(bos).is_empty(), "bos izde satir 0")


func _sinir() -> void:
	var basarim := 0
	var ag := 0
	for yol in _gd("res://src"):
		var kod := FileAccess.get_file_as_string(yol)
		if kod.contains("class_name") and (kod.to_lower().contains("basarim") or kod.to_lower().contains("achievement")):
			basarim += 1
		if yol.ends_with("oyun_koprusu.gd"):
			continue
		for satir in kod.split("\n"):
			var govde := satir.split("#", true, 1)[0]
			if govde.contains("HTTPRequest") or govde.contains("HTTPClient") or govde.contains("WebSocket"):
				ag += 1
	_kontrol(basarim == 0, "basarim sinifi 0")
	_kontrol(ag == 0, "bayraksiz ag cagrisi 0")
	for yol in [
		"res://src/sistemler/surum_kimligi.gd",
		"res://src/sistemler/oyuncu_surumu.gd",
		"res://src/sistemler/demo_kesiti.gd",
		"res://src/sistemler/surum_ekran_listesi.gd",
		"res://src/arayuz/ana.gd",
	]:
		var kod := FileAccess.get_file_as_string(yol)
		_kontrol(not kod.contains("denge.json") and not kod.contains("data/soz/"), "denge ve soz agaci degismedi: " + yol)


func _ekranlar() -> void:
	_kontrol(SurumEkranListesi.KIMLIKLER.size() == 11, "on bir ekran")
	var katalog := Katalog.new()
	_kontrol(katalog.yukle() == Katalog.Durum.HAZIR, "katalog hazir")
	var oturum := Oturum.new(katalog, 3)
	var ayarlar := Ayarlar.new()
	for boyut in SurumEkranListesi.BOYUTLAR:
		SurumEkranListesi.boyut_uygula(boyut)
		for kimlik in SurumEkranListesi.KIMLIKLER:
			print("SURUM EKRAN %s %s" % [boyut, kimlik])
			var ekran := SurumEkranListesi.ac(kimlik, oturum, ayarlar)
			ekran.name = "surum_" + kimlik
			add_child(ekran)
			await get_tree().process_frame
			_kontrol(ekran.is_inside_tree(), "%s %s acilmadi" % [boyut, kimlik])
			ekran.queue_free()
			await get_tree().process_frame
	Engine.time_scale = 1.0
	get_tree().paused = false


func _gd(kok: String) -> Array[String]:
	var sonuc: Array[String] = []
	var kuyruk: Array[String] = [kok]
	while not kuyruk.is_empty():
		var yol: String = kuyruk.pop_back()
		for ad in DirAccess.get_directories_at(yol):
			kuyruk.append(yol.path_join(String(ad)))
		for ad in DirAccess.get_files_at(yol):
			if String(ad).ends_with(".gd"):
				sonuc.append(yol.path_join(String(ad)))
	return sonuc


func _ayikla(metin: String, anahtar: String) -> String:
	var bas := metin.find(anahtar + "=\"")
	if bas < 0:
		return ""
	bas += anahtar.length() + 2
	var son := metin.find("\"", bas)
	return metin.substr(bas, son - bas)


func _csv_hucre(csv: String, anahtar: String) -> String:
	for satir in csv.split("\n"):
		if satir.begins_with(anahtar + ","):
			return satir.substr(anahtar.length() + 1).trim_suffix("\r")
	return ""
