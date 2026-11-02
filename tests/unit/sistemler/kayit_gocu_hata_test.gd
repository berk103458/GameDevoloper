extends SceneTree
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func _initialize() -> void:
	var yol := "user://kalfa_kay05_%d.json" % OS.get_process_id()
	var k := GuvenliKayit.new(yol)
	k.sil()
	var baytlar := {}
	for ek in ["", ".bak", ".bak.tmp", ".tmp"]:
		var f := FileAccess.open(yol + ek, FileAccess.WRITE)
		f.store_string(JSON.stringify({"surum":2, "kisi":{"hafiza":["korunacak"]}, "isaret":"asıl" + ek}))
		f.close()
		baytlar[ek] = FileAccess.get_file_as_bytes(yol + ek)
	var cikti: Array = []
	var args := PackedStringArray(["--headless", "--path", ProjectSettings.globalize_path("res://"), "--script", "res://tests/fixtures/kay05_goc_hatasi.gd", "--quit-after", "30", "--", yol])
	var kod := OS.execute(OS.get_executable_path(), args, cikti, true, false)
	var log := "\n".join(cikti)
	var log_dosyasi := FileAccess.open(yol + ".negative.log", FileAccess.WRITE)
	log_dosyasi.store_string(log)
	log_dosyasi.close()
	dene(kod == 0 and log.count("KAY05_EXPECTED_MIGRATION_FAILURE") == 1 and log.contains("KAY05_STEP1_DONE") and log.contains("KAY05_REJECTED"), "Ara adımda gerçek hata, göç reddedildi; kasıtlı hata yalnız çocuk logunda")
	dene(not log.contains("KAY05_UNEXPECTED_SUCCESS"), "Hatalı göç başarı diye dönmez")
	for ek in baytlar:
		dene(FileAccess.get_file_as_bytes(yol + ek) == baytlar[ek], "Göç hatasında ana/yedek/bak.tmp/tmp baytı korunur: " + ek)
	dene(k.oku().get("surum") == 2, "Asıl dosya yeniden açılır; başarısız göç kalıcılaşmaz")
	k.sil()
	print("KAYIT GÖÇÜ HATA: GEÇTİ" if hata == 0 else "KAYIT GÖÇÜ HATA: KALDI")
	print("İzole kasıtlı hata logu: " + ProjectSettings.globalize_path(yol + ".negative.log"))
	quit(hata)
