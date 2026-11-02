## ACL-01: mevcut köylü modeli, tek ayar yolundan renk ve kısa isim etiketi.
extends RefCounted
const ACILIS = preload("res://src/sistemler/acilis_senaryosu.gd")

static func kur(f: KarakterModel, k: Koylu) -> void:
	preload("res://src/koy/gorsel/aile_yas_gorunumu.gd").kur(f, k)
	var rol := "muhafiz" if k.bayrak_var(ACILIS.MUHAFIZ) else ("es" if k.bayrak_var(ACILIS.ES) else "")
	if rol.is_empty(): return
	var ayar: Dictionary = ACILIS.AYAR.yer_tutucu[rol]
	var renk := Color(String(ayar.renk))
	var anahtar := "acl01_hane|" + renk.to_html()
	if not Pbr._onbellek.has(anahtar):
		var mat := Dunya3B.duz_malzeme(renk)
		mat.blend_mode = BaseMaterial3D.BLEND_MODE_MUL
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		mat.albedo_color.a = 0.55
		Pbr._onbellek[anahtar] = mat
	for n in f.find_children("*", "MeshInstance3D", true, false):
		(n as MeshInstance3D).material_overlay = Pbr._onbellek[anahtar]
	var etiket := Label3D.new()
	etiket.name = "acilis_hane_etiketi"
	etiket.text = TranslationServer.translate(String(ayar.etiket))
	etiket.position.y = 2.1
	etiket.font = Tema.font(600)
	etiket.font_size = 30
	etiket.pixel_size = 0.008
	etiket.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	f.add_child(etiket)
