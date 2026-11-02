## KAP-17: refakatçiler aynı reis modeline bağlı isim etiketli kutulardır.
## Gerçek aile modelleri geldiğinde yalnız bu uyarlama noktası değiştirilir.
extends RefCounted
static func kur(reis: Node3D, g: Gelen) -> void:
	if g.aile.size() < 2 or reis.has_node("AileRefakatcileri"): return
	var grup := Node3D.new()
	grup.name = "AileRefakatcileri"
	reis.add_child(grup)
	for i in range(1, g.aile.size()):
		var u: Dictionary = g.aile[i]
		var boy := 1.15 if u.get("yas_grubu") == "cocuk" else (1.65 if u.get("yas_grubu") == "yasli" else 1.8)
		var kisi := MeshInstance3D.new()
		var kutu := BoxMesh.new()
		kutu.size = Vector3(0.45, boy, 0.35)
		kisi.mesh = kutu
		kisi.position = Vector3((1.0 if i % 2 else -1.0) * ceilf(i / 2.0) * 0.75, boy / 2.0, 0.6)
		grup.add_child(kisi)
		var ad := Label3D.new()
		ad.text = String(u.ad) + " · yer tutucu"
		ad.position.y = boy / 2.0 + 0.25
		ad.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		ad.font_size = 24
		kisi.add_child(ad)
