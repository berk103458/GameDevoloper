## Oturum kaydı: gece sonunda yazılır, oturum sonunda silinir (GDD 1).
class_name KayitDeposu
extends RefCounted

var yol: String


func _init(yol_: String = "user://kayit.json") -> void:
	yol = yol_


func var_mi() -> bool:
	return FileAccess.file_exists(yol)


## Sözlüğü yazar; başarısızsa false.
func yaz(veri: Dictionary) -> bool:
	var f := FileAccess.open(yol, FileAccess.WRITE)
	if f == null:
		push_error("Kayıt yazılamadı: %s" % FileAccess.get_open_error())
		return false
	return f.store_string(JSON.stringify(veri))


## Kayıt sözlüğü; yoksa ya da bozuksa boş sözlük.
func oku() -> Dictionary:
	if not var_mi():
		return {}
	var veri: Variant = JSON.parse_string(FileAccess.get_file_as_string(yol))
	if not (veri is Dictionary):
		push_error("Kayıt bozuk")
		return {}
	return veri


func sil() -> void:
	if var_mi():
		DirAccess.remove_absolute(ProjectSettings.globalize_path(yol))
