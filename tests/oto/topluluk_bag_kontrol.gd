extends Node
## Topluluk modelleri: yer tutucunun adıyla yüklenir, tabanı y=0, dokusu düz renge boyanmaz.


func _ready() -> void:
	var hatalar: PackedStringArray = []
	for ad in Dunya3B.TOPLULUK_YER:
		var beklenen: String = Dunya3B.TOPLULUK_YER[ad]
		if not Dunya3B.model_var_mi(ad):
			hatalar.append("%s bulunamadı" % ad)
			continue
		var n := Dunya3B.nesne(ad, 1.2)
		add_child(n)
		if String(n.get_meta(&"topluluk_dosya", "")) != beklenen:
			hatalar.append("%s topluluk dosyasına bağlanmadı" % ad)
		var k := Dunya3B._kutu(n)
		if absf(k.position.y) > 0.05:
			hatalar.append("%s zemine oturmadı %s" % [ad, k])
		if k.size.y < 0.2 or k.size.y > 2.5:
			hatalar.append("%s boy ölçeği bozuk %s" % [ad, k.size])
		var duz := false
		for mi in n.find_children("*", "MeshInstance3D", true, false):
			if (mi as MeshInstance3D).material_override != null:
				duz = true
		if duz:
			hatalar.append("%s dokusu düz renge boyandı" % ad)
		n.free()
	var kuyu := KapiKuyuAyari.kuyu()
	if String(kuyu.get_meta(&"topluluk_dosya", "")) == "":
		hatalar.append("meydan kuyusu topluluk modelini kullanmıyor")
	kuyu.free()
	if hatalar.is_empty():
		print("TOPLULUK BAĞ: GEÇTİ")
	else:
		for h in hatalar:
			push_error(h)
		print("TOPLULUK BAĞ: KALDI (%d)" % hatalar.size())
	get_tree().quit(0 if hatalar.is_empty() else 1)
