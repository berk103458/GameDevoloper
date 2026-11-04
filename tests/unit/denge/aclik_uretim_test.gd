extends SceneTree

func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var ac := _olc(kat, 0)
	var tok := _olc(kat, 100)
	if ac.is_empty() or tok.is_empty():
		quit(1)
		return
	print("DEN-30 ÖLÇÜM: aç üretim=%d, tok üretim=%d" % [ac.uretim, tok.uretim])
	if tok.uretim <= ac.uretim:
		push_error("DEN-30: tok köyün üretimi aç köyün üstünde olmalı")
		quit(1)
		return
	print("AÇLIK ÜRETİM: GEÇTİ")
	quit()

func _olc(kat: Katalog, gida: int) -> Dictionary:
	var o := Oturum.new(kat, 2929)
	var y := o.yonetim
	y.kaynaklar.stok["gida"] = gida
	var bina := KoyBinasi.new()
	bina.id = 90
	bina.tur = "tas_ocagi"
	bina.recete = "tas"
	y.binalar.append(bina)
	for i in 3:
		var kisi := y.kabul({"ad": "Ölçüm %d" % i, "sinif": "tasci"})
		if i < 2:
			kisi.is_yeri = bina.id
	var ilk_gun := y.gun
	var olum := 0
	var uretim := 0
	for gece in 20:
		var rapor := y.gece()
		olum += rapor.olenler.size()
		uretim += int(rapor.uretim.get("tas", 0))
		var once := JSON.stringify(y.kaydet())
		for tekrar in 3:
			DengeOlcumu.olustur(o, rapor)
			for kisi in y.koylular:
				YasamBarlari.oku(kisi, y)
		if JSON.stringify(y.kaydet()) != once:
			push_error("DEN-31: bar veya denge gözlemi gece durumunu değiştirdi")
			quit(1)
			return {}
	print("DEN-29 ÖLÇÜM: gece=%d ölüm=%d" % [y.gun - ilk_gun, olum])
	var tablo: Dictionary = preload("res://src/sistemler/denge_tablosu.gd").oku()
	var aralik: Dictionary = tablo.get("aclik_olum_aralik", {})
	if gida == 0 and (y.gun - ilk_gun != 20 or not aralik.has("alt") or not aralik.has("ust") or olum < int(aralik.alt) or olum > int(aralik.ust)):
		push_error("DEN-29: ölüm sayısı tablo aralığının dışında")
		quit(1)
		return {}
	return {"olum": olum, "uretim": uretim}
