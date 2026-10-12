## Aynı dizinde doğrulanmış tmp → rename; hata olursa ana kayıt korunur.
extends RefCounted

static func yaz(yol: String, veri: Dictionary) -> bool:
	if veri.is_empty():
		return false
	# KAY-01: anahtar sirasi korunur; kayit dosyasi surum alaniyla baslar.
	var metin := JSON.stringify(veri, "", false)
	var tmp := yol + ".tmp"
	var f := FileAccess.open(tmp, FileAccess.WRITE)
	if f == null:
		return false
	f.store_string(metin)
	f.flush()
	var hata := f.get_error()
	f.close()
	if hata != OK or FileAccess.get_file_as_string(tmp) != metin or oku(tmp).is_empty():
		return false
	var dizin := DirAccess.open(yol.get_base_dir())
	if dizin == null:
		return false
	# Bozuk ana dosya sağlam önceki yedeği ezemez.
	if FileAccess.file_exists(yol) and not oku(yol).is_empty():
		var bak_tmp := yol + ".bak.tmp"
		if dizin.copy(yol, bak_tmp) != OK:
			return false
		if FileAccess.get_file_as_string(bak_tmp) != FileAccess.get_file_as_string(yol):
			return false
		if dizin.rename(bak_tmp, yol + ".bak") != OK:
			return false
	return dizin.rename(tmp, yol) == OK

static func oku(yol: String) -> Dictionary:
	if not FileAccess.file_exists(yol):
		return {}
	var json := JSON.new()
	if json.parse(FileAccess.get_file_as_string(yol)) != OK:
		return {}
	return json.data if json.data is Dictionary else {}
