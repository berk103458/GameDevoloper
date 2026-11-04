extends SceneTree

func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var y := Oturum.new(kat, 2929).yonetim
	y.kaynaklar.stok["gida"] = 0
	for i in 3:
		y.kabul({"ad": "Ölçüm %d" % i, "sinif": "ciftci"})
	var ilk_gun := y.gun
	var olum := 0
	for gece in 20:
		var rapor := y.gece()
		olum += rapor.olenler.size()
	print("DEN-29 ÖLÇÜM: gece=%d ölüm=%d" % [y.gun - ilk_gun, olum])
	var tablo: Dictionary = preload("res://src/sistemler/denge_tablosu.gd").oku()
	var aralik: Dictionary = tablo.get("aclik_olum_aralik", {})
	if y.gun - ilk_gun != 20 or not aralik.has("alt") or not aralik.has("ust") or olum < int(aralik.alt) or olum > int(aralik.ust):
		push_error("DEN-29: ölüm sayısı tablo aralığının dışında")
		quit(1)
		return
	print("AÇLIK ÜRETİM: GEÇTİ")
	quit()
