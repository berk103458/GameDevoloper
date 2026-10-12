extends SceneTree

var hata := 0
const YOL := "user://kay01/kayit.json"


func _initialize() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(YOL.get_base_dir()))
	var katalog := Katalog.new()
	katalog.yukle()
	var o := Oturum.new(katalog, 4242)
	o.yonetim.gun = 4
	o.yonetim.akce = 33
	var veri := o.kaydet()
	_kontrol(typeof(veri["surum"]) == TYPE_INT and int(veri["surum"]) == 3, "Sürüm tek tam sayıdır")
	_kontrol(not GuvenliKayit.surum_gecerli({}) and not GuvenliKayit.surum_gecerli({"surum": 2.5}), "Eksik ve kesirli sürüm geçersiz")
	_kontrol(not GuvenliKayit.surum_gecerli({"surum": "3"}) and not GuvenliKayit.surum_gecerli({"surum": true}), "Metin ve mantık sürüm geçersiz")
	_kontrol(not GuvenliKayit.surum_gecerli({"surum": NAN}) and not GuvenliKayit.surum_gecerli({"surum": INF}), "Sonsuz ve NaN sürüm geçersiz")
	_kontrol(GuvenliKayit.surum_gecerli({"surum": 3}) and GuvenliKayit.surum_gecerli({"surum": 3.0}), "Tam sayı ve tam değerli ondalık sürüm geçerli")
	_kontrol(String(veri.keys()[0]) == "surum", "Sürüm sözlüğün ilk alanıdır")
	var kayit := GuvenliKayit.new(YOL)
	kayit.sil()
	_kontrol(kayit.yaz(veri), "Sağlam sürümlü kayıt yazıldı")
	_kontrol(FileAccess.get_file_as_string(YOL).begins_with('{"surum":'), "Dosyanın başı sürümdür")
	var geri := Oturum.kayittan(katalog, kayit.oku())
	_kontrol(geri != null and geri.yonetim.gun == 4, "Sağlam sürümlü kayıt normal yüklenir")
	o.yonetim.gun = 5
	_kontrol(kayit.yaz(o.kaydet()), "İkinci sağlam kayıt yedeği bırakır")
	var yedek_once := FileAccess.get_file_as_string(YOL + ".bak")
	_kontrol(JSON.parse_string(yedek_once) is Dictionary, "Yedek gerçekten duruyor")
	var alansiz := veri.duplicate(true)
	alansiz.erase("surum")
	var f := FileAccess.open(YOL, FileAccess.WRITE)
	_kontrol(f != null, "Alansız dosya açıldı")
	f.store_string(JSON.stringify(alansiz))
	f.close()
	_kontrol(kayit.oku().is_empty(), "Sürüm alanı yoksa yükleme durur, alansız dosya reddedilir")
	_kontrol(preload("res://src/sistemler/kayit_gocu.gd").uygula(alansiz, 7).is_empty(), "Alansız kayıt göçten geçmez, köy uydurulmaz")
	_kontrol(FileAccess.get_file_as_string(YOL + ".bak") == yedek_once, "Alansız dosya reddedilirken yedek yerinde durur")
	_kontrol(FileAccess.get_file_as_string(YOL) == JSON.stringify(alansiz), "Reddedilen alansız dosya diskte değişmez")
	kayit.sil()
	DirAccess.remove_absolute(ProjectSettings.globalize_path(YOL.get_base_dir()))
	print("KAYIT SÜRÜM KAPISI: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)


func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
