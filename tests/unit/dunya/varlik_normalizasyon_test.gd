## CIL-01 hedefli testi: data/varlik_olculeri.json altındaki tüm modellerin ölçek/taban/ayak izi doğrulaması.
extends SceneTree

var _hata := 0

func _initialize() -> void:
	var veri: Variant = JSON.parse_string(FileAccess.get_file_as_string("res://data/varlik_olculeri.json"))
	_kontrol(veri is Dictionary and veri.has("varliklar"), "varlik_olculeri.json geçerli")
	if not (veri is Dictionary):
		quit(1)
		return
	var tablo: Dictionary = veri.get("varliklar", {})
	var kontrol_sayisi := 0
	for ad in tablo:
		var cfg: Dictionary = tablo[ad]
		if cfg.get("devre_disi", false):
			_kontrol(not Dunya3B.model_var_mi(String(ad), String(cfg.get("tur", ""))), "%s devre dışı olmalı" % ad)
			continue
		var tur := String(cfg.get("tur", ""))
		var arama_ad := String(ad)
		var arama_tur := "" if tur == "topluluk" or ad == "styloo_kopek" else tur
		if not Dunya3B.model_var_mi(arama_ad, arama_tur):
			continue
		var hedef_y := float(cfg.get("hedef_boy_m", 0.0))
		var ayak: Array = cfg.get("azami_ayak_m", [])
		var dugum := Dunya3B.nesne(String(ad), hedef_y, arama_tur)
		if ad in ["k09_okcu_pers", "k12_ortacag_tuccari", "td_k09", "td_k12"]:
			_kontrol(not dugum.find_children("*", "MeshInstance3D", true, false).is_empty(), "%s mesh içermeli" % ad)
		var bb := Dunya3B._kutu(dugum)
		_kontrol(bb.size.y > 0.05, "%s boy > 0.05 m (geldi: %.4f)" % [ad, bb.size.y])
		_kontrol(absf(bb.position.y - float(cfg.get("taban_y", 0.0))) < 0.05, "%s taban y=0 (geldi: %.3f)" % [ad, bb.position.y])
		if ayak.size() >= 2:
			_kontrol(bb.size.x <= float(ayak[0]) + 0.05 and bb.size.z <= float(ayak[1]) + 0.05,
				"%s ayak (%.2f, %.2f) <= (%.2f, %.2f)" % [ad, bb.size.x, bb.size.z, float(ayak[0]), float(ayak[1])])
		if hedef_y > 0.0:
			_kontrol(bb.size.y <= hedef_y + 0.05, "%s boy %.2f <= %.2f" % [ad, bb.size.y, hedef_y])
		kontrol_sayisi += 1
		dugum.free()
	# Örnek kritik iskeletli modellerin gerçek metre boyu kontrolü
	for ad_crit in [["td_k05", 0.5, 1.8], ["td_k13", 0.35, 1.0], ["td_a146", 0.30, 0.50]]:
		var dn := Dunya3B.nesne(String(ad_crit[0]))
		var dbb := Dunya3B._kutu(dn)
		_kontrol(dbb.size.y >= float(ad_crit[1]) and dbb.size.y <= float(ad_crit[2]),
			"Kritik %s boyu [%.2f..%.2f]: geldi=%.3f" % [ad_crit[0], ad_crit[1], ad_crit[2], dbb.size.y])
		dn.free()
	print("CIL-01 NORMALİZASYON (%d varlık): %s" % [kontrol_sayisi, "GEÇTİ" if _hata == 0 else "KALDI (%d hata)" % _hata])
	quit(1 if _hata > 0 else 0)

func _kontrol(ok: bool, msg: String) -> void:
	if not ok:
		_hata += 1
		push_error("CIL-01: " + msg)
