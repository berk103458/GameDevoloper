## Taranmış PBR malzemeler (Poly Haven, CC0): renk + normal + pürüzlülük haritası. Dokular
## `assets/ph/doku/<id>/<id>_{diff,nor_gl,rough}_<çöz>.jpg` (tools/varlik/polyhaven_indir.py indirir).
## UV'si olmayan yordamsal parçalar (kutu, silindir) için dünya uzayında üç yönlü (triplanar) eşleme kullanılır:
## doku parçanın boyuna göre gerilmez, bitişik parçalar birbirine dikişsiz bağlanır.
class_name Pbr
extends RefCounted

const KOK := "res://assets/ph/"

static var _onbellek: Dictionary = {}


## `id` dokusundan malzeme. `olcek`: dokunun dünyada kapladığı boy (m); `renk`: albedo çarpanı (ton ayarı).
## Doku bulunamazsa düz renkli malzemeye düşer (oyun yine açılır).
static func malzeme(id: String, olcek: float = 2.0, renk: Color = Color.WHITE, triplanar: bool = true) -> StandardMaterial3D:
	var anahtar := "%s|%s|%s|%s" % [id, olcek, renk.to_html(), triplanar]
	if _onbellek.has(anahtar):
		return _onbellek[anahtar]
	var m := StandardMaterial3D.new()
	var diff := doku(id, "diff")
	if diff == null:
		m.albedo_color = renk
		m.roughness = 1.0
		_onbellek[anahtar] = m
		return m
	m.albedo_texture = diff
	m.albedo_color = renk
	var nor := doku(id, "nor_gl")
	if nor != null:
		m.normal_enabled = true
		m.normal_texture = nor
		m.normal_scale = 1.2
	var kaba := doku(id, "rough")
	if kaba != null:
		m.roughness_texture = kaba
		m.roughness = 1.0
	m.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
	if triplanar:
		m.uv1_triplanar = true
		m.uv1_world_triplanar = true
		m.uv1_triplanar_sharpness = 4.0
		m.uv1_scale = Vector3.ONE / olcek
	else:
		m.uv1_scale = Vector3(1.0 / olcek, 1.0 / olcek, 1.0)
	_onbellek[anahtar] = m
	return m


## Bir doku haritası (en yüksek çözünürlüklü olanı); yoksa null.
static func doku(id: String, harita: String) -> Texture2D:
	for coz in ["4k", "2k", "1k"]:
		var yol := "%sdoku/%s/%s_%s_%s.jpg" % [KOK, id, id, harita, coz]
		if ResourceLoader.exists(yol):
			return load(yol)
	return null


## Poly Haven glTF modeli (assets/ph/model/<id>/<id>.gltf); yoksa null.
static func model(id: String) -> Node3D:
	var yol := "%smodel/%s/%s.gltf" % [KOK, id, id]
	if not ResourceLoader.exists(yol):
		return null
	return (load(yol) as PackedScene).instantiate()


## Gece gökyüzü HDRI'ı; yoksa null.
static func gok(id: String) -> Texture2D:
	for coz in ["4k", "2k", "1k"]:
		var yol := "%sgok/%s_%s.hdr" % [KOK, id, coz]
		if ResourceLoader.exists(yol):
			return load(yol)
	return null
