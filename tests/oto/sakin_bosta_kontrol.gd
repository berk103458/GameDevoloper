extends SceneTree

var _hata := 0
var _ornekler: Array[Dictionary] = []


func _dogrula(kosul: bool, mesaj: String) -> void:
	if not kosul:
		_hata += 1
		push_error("CIL-23 HATA: " + mesaj)


func _initialize() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	var adlar: Array[String] = []
	for i in range(1, 31):
		adlar.append("chr_%03d" % i)
	adlar.append_array(["ciftci", "asker", "esnaf", "yasli", "cocuk", "dervis", "haberci", "aydogdu", "karaca_usta", "hasan_celebi"])

	for ad in adlar:
		var k := Dunya3B.karakter(ad)
		get_root().add_child(k)
		var sks := k.find_children("*", "Skeleton3D", true, false)
		var sk := sks[0] as Skeleton3D if not sks.is_empty() else null
		var ap := k._oynatici as AnimationPlayer
		var hips_i := sk.find_bone("Hips") if sk else -1
		if sk and hips_i < 0:
			for bi in sk.get_bone_count():
				var bn := sk.get_bone_name(bi).to_lower()
				if "hip" in bn or "pelvis" in bn:
					hips_i = bi
					break
		var head_i := sk.find_bone("Head") if sk else -1
		_dogrula(ap != null and ap.has_animation("bekle"), "%s bekleme klibi mevcut" % ad)
		_ornekler.append({
			"ad": ad, "k": k, "sk": sk, "ap": ap, "hips": hips_i, "head": head_i,
			"min": Vector3(INF, INF, INF), "max": Vector3(-INF, -INF, -INF),
			"head_min_y": INF, "head_max_y": -INF,
		})

	# 1.0 saniyelik boşta kalça/kök yer değiştirmesi (30 kare @ 30 Hz)
	for step in 30:
		for o in _ornekler:
			var ap := o["ap"] as AnimationPlayer
			if ap != null:
				ap.advance(1.0 / 30.0)
		await process_frame
		for o in _ornekler:
			var sk := o["sk"] as Skeleton3D
			var hips_i := int(o["hips"])
			if sk != null and hips_i >= 0:
				var hp := sk.global_transform * sk.get_bone_global_pose(hips_i).origin
				o["min"] = (o["min"] as Vector3).min(hp)
				o["max"] = (o["max"] as Vector3).max(hp)
			var head_i := int(o["head"])
			if sk != null and head_i >= 0:
				var eul := sk.get_bone_pose_rotation(head_i).get_euler()
				o["head_min_y"] = minf(float(o["head_min_y"]), eul.y)
				o["head_max_y"] = maxf(float(o["head_max_y"]), eul.y)

	# Baş bakış periyodu >= 3.0 s ve açı <= +-25° doğrulaması
	_dogrula(float(KarakterBeklemeCesitliligi.AYAR.nefes_suresi) >= 3.0, "Nefes periyodu >= 3 s")
	_dogrula(float(KarakterBeklemeCesitliligi.AYAR.agirlik_suresi) >= 3.0, "Ağırlık periyodu >= 3 s")
	_dogrula(float(KarakterBeklemeCesitliligi.AYAR.bakis_derece) <= 25.0, "Baş bakışı <= +-25°")
	for hiz in KarakterBeklemeCesitliligi.AYAR.bakis_hizlari:
		_dogrula(TAU / float(hiz) >= 3.0, "Bakış periyodu >= 3 s (%.2f)" % (TAU / float(hiz)))

	var max_disp := 0.0
	for o in _ornekler:
		var ad := String(o["ad"])
		var disp := ((o["max"] as Vector3) - (o["min"] as Vector3)).length()
		max_disp = maxf(max_disp, disp)
		_dogrula(disp <= 0.02, "%s boşta kök yer değiştirmesi <= 2 cm olmalı: %.4f m" % [ad, disp])
		var bas_aralik := rad_to_deg(float(o["head_max_y"]) - float(o["head_min_y"])) if float(o["head_max_y"]) > -INF else 0.0
		_dogrula(bas_aralik <= 50.0, "%s baş dönüş genişliği <= +-25° (toplam %.2f°)" % [ad, bas_aralik])
		(o["k"] as Node).free()

	print("CIL-23 SAKİN BOŞTA (%d karakter, max_kok=%.4fm): GEÇTİ" % [_ornekler.size(), max_disp] if _hata == 0 else "CIL-23 SAKİN BOŞTA: KALDI (%d hata)" % _hata)
	quit(0 if _hata == 0 else 1)
