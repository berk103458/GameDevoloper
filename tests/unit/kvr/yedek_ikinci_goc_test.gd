extends SceneTree

var hata := 0
const YOL := "user://kay56/kayit.json"


func _initialize() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(YOL.get_base_dir()))
	var kayit := GuvenliKayit.new(YOL)
	kayit.sil()
	_kontrol(kayit.yaz({"surum": 3, "sayi": 1}), "Sağlam birinci kayıt")
	_kontrol(kayit.yaz({"surum": 3, "sayi": 2}), "Sağlam ikinci kayıt yedeği bırakır")
	var yedek := FileAccess.get_file_as_string(YOL + ".bak")
	var yedek_veri: Variant = JSON.parse_string(yedek)
	_kontrol(yedek_veri is Dictionary and yedek_veri["sayi"] == 1, "Yedek sağlam kaydı taşır")
	var bak_tmp := YOL + ".bak.tmp"
	if FileAccess.file_exists(bak_tmp):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(bak_tmp))
	var f := FileAccess.open(YOL, FileAccess.WRITE)
	f.store_string("bozuk-goc-bir")
	f.close()
	_kontrol(kayit.yaz({"surum": 3, "sayi": 3}), "Birinci hatalı deneme yazılır")
	_kontrol(not FileAccess.file_exists(bak_tmp), "Bozuk ana dosya bak.tmp üretmez")
	var bir := FileAccess.get_file_as_string(YOL + ".bak")
	f = FileAccess.open(YOL, FileAccess.WRITE)
	f.store_string("bozuk-goc-iki")
	f.close()
	_kontrol(kayit.yaz({"surum": 3, "sayi": 4}), "İkinci hatalı deneme yazılır")
	var iki := FileAccess.get_file_as_string(YOL + ".bak")
	_kontrol(bir == yedek and iki == yedek, "İki hatalı denemede yedek baytı aynı kalır")
	_kontrol(GuvenliKayit._oku_dosya(YOL + ".bak")["sayi"] == 1, "SYS-02: sağlam yedek korunur")
	var saglam_tmp := '{"surum":3,"sayi":9}'
	var t := FileAccess.open(bak_tmp, FileAccess.WRITE)
	t.store_string(saglam_tmp)
	t.close()
	f = FileAccess.open(YOL, FileAccess.WRITE)
	f.store_string("bozuk-goc-uc")
	f.close()
	_kontrol(kayit.yaz({"surum": 3, "sayi": 5}), "Üçüncü hatalı deneme yazılır")
	_kontrol(FileAccess.get_file_as_string(bak_tmp) == saglam_tmp, "Sağlam bak.tmp yeni bozuk dosyayla ezilmez")
	_kontrol(FileAccess.get_file_as_string(YOL + ".bak") == yedek, "Bak.tmp varken de gerçek yedek bozulmaz")
	kayit.sil()
	DirAccess.remove_absolute(ProjectSettings.globalize_path(YOL.get_base_dir()))
	print("YEDEK İKİNCİ GÖÇ: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)


func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
