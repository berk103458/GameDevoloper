## CIL-04 hedefli testi: demirhane ve tüm GLB'li yapılar MegaKit'e gömülmeden doğrudan ve parsel içinde görünmeli.
extends SceneTree

var _hata := 0

func _initialize() -> void:
	var kat := BinaKatalogu.new()
	var s := KoyYonetimSahnesi.new()
	s.yonetim = KoyYonetimi.new(KoyAyarlari.new(), kat, 42)
	var turler := [
		"demirhane", "firin", "ambar", "sifahane", "tas_ev", "atolye",
		"muhafiz_kislasi", "cadir", "hizarhane", "odunluk", "tas_ocagi", "avci",
	]
	for tur in turler:
		var b := KoyBinasi.new()
		b.tur = tur
		b.insa_kalan = 0
		var dugum := s._bina_dugumu(b)
		_kontrol(dugum.get_node_or_null("megakit_yapi") == null, "%s MegaKit kabuğuna gömülmemeli" % tur)
		var hedef_ad := "meshy_" + OlayYapilari.yapi_adi(tur)
		var meshler := dugum.find_children("*", "MeshInstance3D", true, false)
		_kontrol(dugum.get_node_or_null(hedef_ad) != null and not meshler.is_empty(), "%s GLB görünür düğümü (%s) kurulmalı" % [tur, hedef_ad])
		var boy := b.boyut(kat)
		var bb := Dunya3B._kutu(dugum.get_node_or_null(hedef_ad) if dugum.get_node_or_null(hedef_ad) != null else dugum)
		_kontrol(bb.size.x <= boy.x * KoyYonetimSahnesi.HUCRE + 0.05 and bb.size.z <= boy.y * KoyYonetimSahnesi.HUCRE + 0.05,
			"%s boyut (%.2f, %.2f) parseli (%.1f, %.1f) aşmamalı" % [tur, bb.size.x, bb.size.z, boy.x * 2.0, boy.y * 2.0])
		dugum.free()
	s.free()
	print("CIL-04 BİNA GÖRÜNÜRLÜĞÜ (%d tür): %s" % [turler.size(), "GEÇTİ" if _hata == 0 else "KALDI (%d hata)" % _hata])
	quit(1 if _hata > 0 else 0)

func _kontrol(ok: bool, msg: String) -> void:
	if not ok:
		_hata += 1
		push_error("CIL-04: " + msg)
