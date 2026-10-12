## TEK-26: Tek kayıt dosyası durur. Kayıt yuvası Bölüm 35'tedir; burada ikinci bir
## `user://` kayıt yolu açılmaz. Test kaynağı tarar ve varsayılan yuvayı doğrular.
extends SceneTree

const KAYNAK := "res://src/sistemler/kayit_deposu.gd"

var hata := 0


func _initialize() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	var metin := FileAccess.get_file_as_string(KAYNAK)
	_kontrol(not metin.is_empty(), "kayit_deposu.gd kaynağı okunur")
	var yollar := _yollar(metin)
	_kontrol(yollar.size() == 1, "kayit_deposu.gd tek user:// kayıt yolu tanımlar (bulunan %d)" % yollar.size())
	_kontrol(yollar.size() == 1 and yollar[0] == "user://kayit.json", "Tek kayıt yolu user://kayit.json")
	var depo := KayitDeposu.new()
	_kontrol(depo.yol == "user://kayit.json", "KayitDeposu varsayılanı user://kayit.json")
	_kontrol(KayitDeposu.new().yol == depo.yol, "Her yuva aynı tek yolu paylaşır; ikinci yol yok")
	print("TEK KAYIT YOLU: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)


## Dosya metnindeki user:// yollarını sırayla döndürür.
func _yollar(metin: String) -> Array:
	var re := RegEx.new()
	re.compile("user://[^\"\\s']*")
	var bulunan: Array = []
	for m in re.search_all(metin):
		bulunan.append(m.get_string())
	return bulunan


func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)