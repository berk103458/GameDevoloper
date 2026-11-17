## HAR-06: tek düz kutu kule/ikon yer tutucusu; asset üretimi yoktur.
class_name GozcuKulesiGorseli
extends RefCounted
## Kademe model seçimi: S1 A113 → S2 O72 → S3 gozetleme_kulesi.glb.
static func kur(kok: Node3D, seviye: int = 1) -> void:
	var boy: Array=GozcuKulesi.AYAR.kutu_boyut
	var mesh:=BoxMesh.new()
	mesh.size=Vector3(float(boy[0]),float(boy[1]),float(boy[2]))
	var n:=MeshInstance3D.new()
	n.name="GozcuKulesiYerTutucu"
	n.mesh=mesh
	n.position.y=mesh.size.y/2.0
	var m:=StandardMaterial3D.new()
	m.albedo_color=Color(String(GozcuKulesi.AYAR.renk))
	n.material_override=m
	kok.add_child(n)
	var aday := _model_adi(seviye)
	var tur_kat := "yapi" if aday == "gozetleme_kulesi" else ""
	if Dunya3B.model_var_mi(aday, tur_kat):
		n.visible = false
		var hedef_boy := 4.8 if aday == "td_a113" else (5.5 if aday == "td_o72" else float(boy[1]))
		var kule := Dunya3B.sigdir(aday, hedef_boy, tur_kat, 3.5, 3.5)
		kule.name = "meshy_" + aday
		kok.add_child(kule)


static func _model_adi(seviye: int) -> String:
	if seviye <= 1 and Dunya3B.model_var_mi("td_a113"):
		return "td_a113"
	if seviye == 2 and Dunya3B.model_var_mi("td_o72"):
		return "td_o72"
	return "gozetleme_kulesi"
## Aynı yapı kartı için ColorRect ikon; yeni doku/model yolu açılmaz.
static func ikon(boy: int) -> ColorRect:
	var n:=ColorRect.new()
	n.color=Color(String(GozcuKulesi.AYAR.renk))
	n.custom_minimum_size=Vector2(boy,boy)
	n.mouse_filter=Control.MOUSE_FILTER_IGNORE
	return n
