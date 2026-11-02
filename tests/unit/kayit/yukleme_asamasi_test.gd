extends SceneTree
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func _initialize() -> void:
	call_deferred("_calistir")
func _calistir() -> void:
	var z = preload("res://src/sistemler/kayit_gocu_soz.gd")
	var kaynak := {"surum":1}
	var adimlar := {1:func(v: Dictionary) -> Dictionary: v.surum = 2; return v}
	dene(z.uygula(kaynak, 2, adimlar).get("surum") == 2, "Yükleme/menüde sürüm adımı çalışır")
	var ekran := Node.new()
	root.add_child(ekran)
	z.oynanis_isaretle(ekran, true)
	dene(z.oynanis_acik(), "Aktif oynanış tanınır")
	dene(z.uygula({"surum":2}, 2, {}).get("surum") == 2, "Güncel kaydın adımsız doğrulaması göç değildir")
	z.oynanis_isaretle(ekran, false)
	dene(not z.oynanis_acik() and z.uygula(kaynak, 2, adimlar).get("surum") == 2, "Menüye geçiş yükleme yolunu açar")
	ekran.free()
	var cikti: Array = []
	var kod := OS.execute(OS.get_executable_path(), PackedStringArray(["--headless", "--path", ProjectSettings.globalize_path("res://"), "--script", "res://tests/fixtures/kay71_oynanista_goc.gd", "--quit-after", "30"]), cikti, true, false)
	var log := "\n".join(cikti)
	var f := FileAccess.open("user://kay71_%d.negative.log" % OS.get_process_id(), FileAccess.WRITE)
	f.store_string(log)
	f.close()
	dene(kod == 0 and log.contains("KAY71_GAMEPLAY_MIGRATION") and log.contains("KAY71_REJECTED_BEFORE_STEP"), "Aktif sahnede gerçek adım çağrılmadan geliştirme hatası; yalnız izole logda")
	print("YÜKLEME AŞAMASI: GEÇTİ" if hata == 0 else "YÜKLEME AŞAMASI: KALDI")
	quit(hata)
