## TEK-25: Atomik yazım SYS-02'dedir. Yarıda kesilmiş kayıt dosyası bir sonraki açılışta
## ya tamdır ya yok hükmündedir; `atomik_json_kaydi.gd` gövdesi değişmez.
## Gerçek `devam_et` menü dönüşü akış tarafında: tests/oto/kesik_kayit_devam_kontrol.py.
extends SceneTree

const YOL := "user://codex-tek25-kesik/save.json"

var hata := 0


func _initialize() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(YOL.get_base_dir()))
	var kayit := GuvenliKayit.new(YOL)
	kayit.sil()
	var katalog := Katalog.new()
	_kontrol(katalog.yukle() == Katalog.Durum.HAZIR, "Katalog yüklenir")

	# 1) Yazım tam ortada kesildi: geçersiz JSON (dosya var, içerik tam değil).
	_ham_yaz(kayit.yol, '{"surum": 3, "tohum": "5", "koy_yone')
	_kontrol(kayit.var_mi(), "Kesik dosya varlık olarak görünür")
	_kontrol(kayit.oku().is_empty(), "Geçersiz JSON yok hükmündedir")
	_kontrol(_goc_uygula(katalog, kayit).is_empty(), "Geçersiz kesik gövde göçten geçmez (yok hükmü)")

	# 2) Kesilme tam bir JSON sınırında bitti: geçerli ama eksik gövde.
	_ham_yaz(kayit.yol, '{"surum": 3, "tohum": "5"}')
	_kontrol(not kayit.oku().is_empty(), "Tam JSON sınırındaki kesik dosya ham olarak okunur")
	_kontrol(_goc_uygula(katalog, kayit).is_empty(), "Eksik kesik gövde göçten geçmez (yok hükmü)")

	# 3) Kesik dosya silinmez; oyuncu verisi korunur.
	_kontrol(FileAccess.file_exists(kayit.yol), "Oku başarısız olsa da kesik dosya silinmez")

	# 4) Sınır yalnız bozuk dosyayı bağlar: tam kayıt gerçek oturum açar.
	_kontrol(kayit.yaz(Oturum.new(katalog, 77).kaydet()), "Sağlam kayıt atomik yazılır")
	var tam := Oturum.kayittan(katalog, kayit.oku())
	_kontrol(tam != null and tam.tohum == 77, "Tam kayıt gerçek oturuma açılır")

	kayit.sil()
	DirAccess.remove_absolute(ProjectSettings.globalize_path(YOL.get_base_dir()))
	await process_frame
	await process_frame
	print("KESİK KAYIT: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)


## Kesik dosyayı doğrudan diske yazar (atomik yazım bypass; kesilme simülasyonu).
func _ham_yaz(yol: String, metin: String) -> void:
	var f := FileAccess.open(yol, FileAccess.WRITE)
	f.store_string(metin)
	f.close()


## Sürüm göçü (kayıt yüzeyi) girdiyi reddediyorsa boş sözlük döner = yok hükmü.
func _goc_uygula(katalog: Katalog, kayit: GuvenliKayit) -> Dictionary:
	return preload("res://src/sistemler/kayit_gocu.gd").uygula(kayit.oku(), katalog.koy_ayarlari.mevsim_gun)


func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)