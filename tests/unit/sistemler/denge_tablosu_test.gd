extends SceneTree

const Tablo = preload("res://src/sistemler/denge_tablosu.gd")

func _initialize() -> void:
	var veri: Dictionary = Tablo.oku()
	var kaynaklar := Kaynaklar.new(100, {"gida": 4, "odun": 6})
	Tablo.acilis_erzagini_yaz(kaynaklar)
	if kaynaklar.miktar("gida") != 30 or kaynaklar.miktar("odun") != 6:
		push_error("DEN-03c: açılış erzağı")
		quit(1)
		return
	if Tablo.zorluk_carpani(veri, "olagan") != 1.0 or Tablo.zorluk_carpani(veri, "kolay") != 0.8 or Tablo.zorluk_carpani(veri, "siki") != 1.25:
		push_error("DEN-03c: zorluk çarpanları")
		quit(1)
		return
	var katalog := Katalog.new()
	katalog.yukle()
	var koy := Oturum.new(katalog, 303).yonetim
	var taban := float(TuketimDengesi.gerek(koy).kisi_gida)
	for mod in ["kolay", "olagan", "siki"]:
		koy.set_meta(&"zorluk", mod)
		if not is_equal_approx(float(TuketimDengesi.gerek(koy).kisi_gida), taban * Tablo.zorluk_carpani(veri, mod)):
			push_error("DEN-03c: erzak hesabı çarpanı uygulamadı")
			quit(1)
			return
	print("DEN-03c tablo ve tüketim: GEÇTİ")
	quit()
