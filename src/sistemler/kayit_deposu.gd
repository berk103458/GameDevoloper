## Oturum kaydı: gece sonunda yazılır, oturum sonunda silinir (GDD 1).
class_name KayitDeposu
extends RefCounted

var yol: String


func _init(yol_: String = "user://kayit.json") -> void:
	yol = yol_


func var_mi() -> bool:
	return GuvenliKayit.new(yol).var_mi()


## Sözlüğü yazar; başarısızsa false.
func yaz(veri: Dictionary) -> bool:
	return GuvenliKayit.new(yol).yaz(veri)


## Kayıt sözlüğü; yoksa ya da bozuksa boş sözlük.
func oku() -> Dictionary:
	return GuvenliKayit.new(yol).oku()


func sil() -> void:
	GuvenliKayit.new(yol).sil()
