extends SceneTree

var hata := 0
var bildirim := 0

func _initialize() -> void:
	var servis := IpucuYoneticisi.new()
	servis.ipucu_bulundu.connect(func(_ipucu: StringName) -> void: bildirim += 1)
	_kontrol(servis.kaydet(&"Clue_CHR001_KavliCakmak"), "Yeni ipucu kayıt olur")
	_kontrol(not servis.kaydet(&"Clue_CHR001_KavliCakmak") and bildirim == 1, "Mükerrer ipucu sinyali tekrarlamaz")
	_kontrol(not servis.kaydet(&"") and not servis.kaydet(&"Flag_Kilitlendi"), "Boş anahtar ve Flag ipucu değildir")
	var kopya := servis.kayitlar()
	kopya.clear()
	_kontrol(servis.var_mi(&"Clue_CHR001_KavliCakmak"), "Dışarı verilen kopya iç kaydı değiştirmez")
	_kontrol(IpucuYoneticisi.new().kayitlar().is_empty(), "İkinci ziyaretin kaydı bağımsız")
	print("İPUCU SERVİSİ: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)

func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
