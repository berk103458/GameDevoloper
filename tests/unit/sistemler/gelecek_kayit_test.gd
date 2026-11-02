extends SceneTree
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func ham_yaz(yol: String, veri: Dictionary) -> void:
	var f := FileAccess.open(yol, FileAccess.WRITE)
	f.store_string(JSON.stringify(veri))
	f.close()
func _initialize() -> void:
	var yol := "user://kalfa_kay02_%d.json" % OS.get_process_id()
	var k := GuvenliKayit.new(yol)
	k.sil()
	var eski := {"surum":Oturum.KAYIT_SURUMU, "isaret":"eski"}
	var gelecek := {"surum":Oturum.KAYIT_SURUMU + 1, "isaret":"gelecek"}
	ham_yaz(yol + ".bak", eski)
	ham_yaz(yol, gelecek)
	var ana := FileAccess.get_file_as_bytes(yol)
	var yedek := FileAccess.get_file_as_bytes(yol + ".bak")
	dene(k.oku().is_empty(), "Gelecek sürüm okunmaz; eski yedeğe sessizce dönülmez")
	dene(not k.yaz(eski), "Gelecek sürüm ana dosyası ezilmez")
	dene(FileAccess.get_file_as_bytes(yol) == ana and FileAccess.get_file_as_bytes(yol + ".bak") == yedek, "Ret ana/yedek baytlarını korur")
	dene(not FileAccess.file_exists(yol + ".tmp"), "Reddedilen yazı tmp bile oluşturmaz")
	k.sil()
	ham_yaz(yol + ".bak", gelecek)
	yedek = FileAccess.get_file_as_bytes(yol + ".bak")
	dene(k.oku().is_empty() and not k.yaz(eski), "Gelecek sürüm yedek de okunmaz/ezilmez")
	dene(FileAccess.get_file_as_bytes(yol + ".bak") == yedek and not FileAccess.file_exists(yol), "Yeni sürüm yedek korunur; ana yaratılmaz")
	k.sil()
	dene(not k.yaz(gelecek), "Oyunun bilmediği sürümle dosya üretilmez")
	dene(k.yaz(eski) and k.oku().get("isaret") == "eski", "Güncel sürüm yolu çalışır")
	k.sil()
	print("GELECEK KAYIT: GEÇTİ" if hata == 0 else "GELECEK KAYIT: KALDI")
	quit(hata)
