extends SceneTree

var hata := 0
const YOL := "user://codex-atomik-test/save.json"

func _initialize() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(YOL.get_base_dir()))
	var kayit := GuvenliKayit.new(YOL)
	kayit.sil()
	_kontrol(kayit.yaz({"surum": 3, "sayi": 1}), "İlk atomik kayıt")
	_kontrol(kayit.yaz({"surum": 3, "sayi": 2}) and kayit.oku()["sayi"] == 2, "Mevcut kayıt atomik değişiyor")
	_kontrol(GuvenliKayit._oku_dosya(YOL + ".bak")["sayi"] == 1, "Önceki sağlam kayıt yedekte")
	_kontrol(not FileAccess.file_exists(YOL + ".tmp"), "Başarılı rename tmp bırakmıyor")
	# Kesilmiş yazı simülasyonu: tmp hiçbir zaman ana kayıt yerine okunamaz.
	var f := FileAccess.open(YOL + ".tmp", FileAccess.WRITE)
	f.store_string('{"sayi":')
	f.close()
	_kontrol(kayit.oku()["sayi"] == 2, "Yarım tmp ana kaydı etkilemez")
	f = FileAccess.open(YOL, FileAccess.WRITE)
	f.store_string("bozuk")
	f.close()
	_kontrol(kayit.oku().get("_yedekten", false), "Bozuk ana kayıt yedeğe düşüyor")
	_kontrol(kayit.yaz({"surum": 3, "sayi": 3}) and GuvenliKayit._oku_dosya(YOL + ".bak")["sayi"] == 1, "Bozuk ana dosya sağlam yedeği ezmez")
	# Backup rename hatası: yazı ana dosyayı bozmadan durmalı.
	DirAccess.remove_absolute(ProjectSettings.globalize_path(YOL + ".bak"))
	DirAccess.make_dir_absolute(ProjectSettings.globalize_path(YOL + ".bak"))
	_kontrol(not kayit.yaz({"surum": 3, "sayi": 4}) and kayit.oku()["sayi"] == 3, "Başarısız yedek rename ana kaydı korur")
	DirAccess.remove_absolute(ProjectSettings.globalize_path(YOL + ".bak"))
	kayit.sil()
	DirAccess.remove_absolute(ProjectSettings.globalize_path(YOL.get_base_dir()))
	print("ATOMİK KAYIT: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)

func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
