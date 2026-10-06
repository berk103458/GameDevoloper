## Güvenli kayıt (design/gdd/koy-yonetimi.md, 13): düz JSON; önce `.tmp`'ye yazılır ve geri okunarak doğrulanır,
## sonra mevcut kayıt `.bak` olur ve geçici dosya ana kaydın yerine geçer. Ana kayıt bozuksa yedek okunur.
## Kaynak (.tres) kaydı kullanılmaz: yüklenen kaynak betik çalıştırabilir.
class_name GuvenliKayit
extends RefCounted

var yol: String


func _init(yol_: String = "user://savegame.json") -> void:
	yol = yol_


func var_mi() -> bool:
	return FileAccess.file_exists(yol) or FileAccess.file_exists(yol + ".bak")


## Yazar; başarısızsa ana kayda dokunmaz ve false döner.
func yaz(veri: Dictionary) -> bool:
	var metin := JSON.stringify(veri)
	var tmp := yol + ".tmp"
	var f := FileAccess.open(tmp, FileAccess.WRITE)
	if f == null:
		push_error("Kayıt yazılamadı: %s" % FileAccess.get_open_error())
		return false
	f.store_string(metin)
	f.close()
	if _oku_dosya(tmp).is_empty():
		push_error("Kayıt doğrulanamadı")
		return false
	var dizin := DirAccess.open(yol.get_base_dir())
	if dizin == null:
		return false
	if FileAccess.file_exists(yol):
		dizin.copy(yol, yol + ".bak")
	return dizin.rename(tmp, yol) == OK


## Kayıt sözlüğü: ana kayıt bozuk ya da eksikse yedek; ikisi de yoksa boş. `yedekten` okunduysa işaretlenir.
func oku() -> Dictionary:
	var v := _oku_dosya(yol)
	if not v.is_empty():
		return v
	v = _oku_dosya(yol + ".bak")
	if not v.is_empty():
		push_warning("Ana kayıt bozuk; yedek yüklendi")
		v["_yedekten"] = true
	return v


func sil() -> void:
	for y in [yol, yol + ".bak", yol + ".tmp"]:
		if FileAccess.file_exists(y):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(y))


static func _oku_dosya(y: String) -> Dictionary:
	if not FileAccess.file_exists(y):
		return {}
	var j := JSON.new()
	if j.parse(FileAccess.get_file_as_string(y)) != OK:
		return {}
	return j.data if j.data is Dictionary else {}
