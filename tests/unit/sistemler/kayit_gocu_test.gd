extends SceneTree

func _initialize() -> void:
	var katalog := Katalog.new()
	katalog.yukle()
	var oturum := Oturum.new(katalog, 62)
	var kisi := oturum.yonetim.kabul({"ad": "Ali"})
	var veri: Dictionary = JSON.parse_string(JSON.stringify(oturum.kaydet()))
	for kayit in veri.koy_yonetimi.koylular:
		if int(kayit.id) == kisi.id:
			kayit.erase("gecici_is")
			kayit.erase("is_yeri")
	var geri := Oturum.kayittan(katalog, veri)
	var koylu := geri.yonetim.koylu(kisi.id) if geri != null else null
	if koylu == null or koylu.is_yeri != KoyYonetimi.BOSTA or not koylu.gecici_is.is_empty():
		push_error("ISG-62: iş alanı olmayan kayıt boşta yüklenmeli")
		quit(1)
		return
	print("ISG-62: GEÇTİ")
	quit()
